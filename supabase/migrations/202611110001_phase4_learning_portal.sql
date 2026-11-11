-- Phase 4: educator classes and assignments, notification preferences,
-- public Skill Passport snapshots, and evidence-based achievement awards.
-- Additive only: existing student and Phase 3 records remain intact.

alter table public.educator_students
  add column if not exists status text not null default 'active'
  check (status in ('active','inactive'));

create table if not exists public.educator_classes (
  id uuid primary key default gen_random_uuid(),
  educator_id uuid not null references public.profiles(id) on delete cascade,
  class_name text not null check (char_length(class_name) between 2 and 120),
  description text not null default '' check (char_length(description) <= 1000),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index if not exists educator_classes_owner_created_idx on public.educator_classes(educator_id, created_at desc);

create table if not exists public.class_invitations (
  id uuid primary key default gen_random_uuid(),
  class_id uuid not null references public.educator_classes(id) on delete cascade,
  email text not null check (char_length(email) between 3 and 320),
  invited_by uuid not null references public.profiles(id) on delete cascade,
  created_at timestamptz not null default now(),
  accepted_at timestamptz,
  unique(class_id, email)
);
create index if not exists class_invitations_email_idx on public.class_invitations(lower(email));

create table if not exists public.class_memberships (
  id uuid primary key default gen_random_uuid(),
  class_id uuid not null references public.educator_classes(id) on delete cascade,
  student_id uuid not null references public.profiles(id) on delete cascade,
  joined_at timestamptz not null default now(),
  unique(class_id, student_id)
);
create index if not exists class_memberships_student_idx on public.class_memberships(student_id, joined_at desc);

create table if not exists public.educator_assignments (
  id uuid primary key default gen_random_uuid(),
  class_id uuid not null references public.educator_classes(id) on delete cascade,
  educator_id uuid not null references public.profiles(id) on delete cascade,
  roadmap_id uuid references public.roadmaps(id) on delete set null,
  title text not null check (char_length(title) between 3 and 160),
  instructions text not null default '' check (char_length(instructions) <= 5000),
  due_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index if not exists educator_assignments_class_due_idx on public.educator_assignments(class_id, due_at);

create table if not exists public.assignment_submissions (
  id uuid primary key default gen_random_uuid(),
  assignment_id uuid not null references public.educator_assignments(id) on delete cascade,
  student_id uuid not null references public.profiles(id) on delete cascade,
  response text not null check (char_length(response) between 1 and 12000),
  status text not null default 'submitted' check (status in ('submitted','reviewed')),
  submitted_at timestamptz not null default now(),
  reviewed_at timestamptz,
  unique(assignment_id, student_id)
);
create index if not exists assignment_submissions_student_idx on public.assignment_submissions(student_id, submitted_at desc);

create table if not exists public.notification_preferences (
  user_id uuid primary key references public.profiles(id) on delete cascade,
  daily_reminders boolean not null default true,
  assignment_notifications boolean not null default true,
  milestone_notifications boolean not null default true,
  feedback_notifications boolean not null default true,
  announcement_notifications boolean not null default true,
  updated_at timestamptz not null default now()
);

create table if not exists public.public_skill_passports (
  user_id uuid primary key references public.profiles(id) on delete cascade,
  public_id uuid not null unique default gen_random_uuid(),
  is_public boolean not null default false,
  snapshot jsonb not null default '{}'::jsonb check (jsonb_typeof(snapshot) = 'object'),
  updated_at timestamptz not null default now()
);
create index if not exists public_skill_passports_public_id_idx on public.public_skill_passports(public_id) where is_public;

alter table public.educator_classes enable row level security;
alter table public.class_invitations enable row level security;
alter table public.class_memberships enable row level security;
alter table public.educator_assignments enable row level security;
alter table public.assignment_submissions enable row level security;
alter table public.notification_preferences enable row level security;
alter table public.public_skill_passports enable row level security;

create policy educator_classes_owner_read on public.educator_classes
  for select to authenticated using (educator_id = (select auth.uid()) or public.is_administrator());
create policy educator_classes_owner_insert on public.educator_classes
  for insert to authenticated with check (educator_id = (select auth.uid()) and public.app_role_for_user() = 'educator');
create policy educator_classes_owner_update on public.educator_classes
  for update to authenticated using (educator_id = (select auth.uid())) with check (educator_id = (select auth.uid()));
create policy educator_classes_owner_delete on public.educator_classes
  for delete to authenticated using (educator_id = (select auth.uid()));
create policy educator_classes_member_read on public.educator_classes
  for select to authenticated using (exists (
    select 1 from public.class_memberships m where m.class_id = id and m.student_id = (select auth.uid())
  ));

create policy class_invitations_owner_all on public.class_invitations
  for all to authenticated using (exists (
    select 1 from public.educator_classes c where c.id = class_id and c.educator_id = (select auth.uid())
  )) with check (invited_by = (select auth.uid()) and exists (
    select 1 from public.educator_classes c where c.id = class_id and c.educator_id = (select auth.uid())
  ));
create policy class_invitations_invitee_read on public.class_invitations
  for select to authenticated using (lower(email) = lower(coalesce(auth.jwt()->>'email','')));

create policy class_memberships_owner_or_member_read on public.class_memberships
  for select to authenticated using (
    student_id = (select auth.uid()) or exists (
      select 1 from public.educator_classes c where c.id = class_id and c.educator_id = (select auth.uid())
    ) or public.is_administrator()
  );
create policy class_memberships_invited_student_join on public.class_memberships
  for insert to authenticated with check (
    student_id = (select auth.uid()) and public.app_role_for_user() = 'student' and exists (
      select 1 from public.class_invitations i
      where i.class_id = public.class_memberships.class_id and lower(i.email) = lower(coalesce(auth.jwt()->>'email',''))
    )
  );
create policy class_memberships_student_leave on public.class_memberships
  for delete to authenticated using (student_id = (select auth.uid()));

create policy educator_assignments_owner_select on public.educator_assignments
  for select to authenticated using (
    educator_id = (select auth.uid()) or exists (
      select 1 from public.class_memberships m where m.class_id = public.educator_assignments.class_id and m.student_id = (select auth.uid())
    ) or public.is_administrator()
  );
create policy educator_assignments_owner_insert on public.educator_assignments
  for insert to authenticated with check (
    educator_id = (select auth.uid()) and exists (
      select 1 from public.educator_classes c where c.id = class_id and c.educator_id = (select auth.uid())
    )
  );
create policy educator_assignments_owner_update on public.educator_assignments
  for update to authenticated using (educator_id = (select auth.uid()))
  with check (educator_id = (select auth.uid()) and exists (
    select 1 from public.educator_classes c where c.id = class_id and c.educator_id = (select auth.uid())
  ));
create policy educator_assignments_owner_delete on public.educator_assignments
  for delete to authenticated using (educator_id = (select auth.uid()));

create policy assignment_submissions_student_or_teacher_read on public.assignment_submissions
  for select to authenticated using (
    student_id = (select auth.uid()) or exists (
      select 1 from public.educator_assignments a
      join public.educator_classes c on c.id = a.class_id
      where a.id = assignment_id and c.educator_id = (select auth.uid())
    ) or public.is_administrator()
  );
create policy assignment_submissions_student_insert on public.assignment_submissions
  for insert to authenticated with check (
    student_id = (select auth.uid()) and exists (
      select 1 from public.educator_assignments a
      join public.class_memberships m on m.class_id = a.class_id
      where a.id = assignment_id and m.student_id = (select auth.uid())
    )
  );
create policy assignment_submissions_student_update on public.assignment_submissions
  for update to authenticated using (student_id = (select auth.uid()) and status = 'submitted')
  with check (student_id = (select auth.uid()) and status = 'submitted');
create policy assignment_submissions_teacher_review on public.assignment_submissions
  for update to authenticated using (exists (
    select 1 from public.educator_assignments a
    where a.id = assignment_id and a.educator_id = (select auth.uid())
  )) with check (exists (
    select 1 from public.educator_assignments a
    where a.id = assignment_id and a.educator_id = (select auth.uid())
  ));

create policy notification_preferences_owner_read on public.notification_preferences
  for select to authenticated using (user_id = (select auth.uid()));
create policy notification_preferences_owner_insert on public.notification_preferences
  for insert to authenticated with check (user_id = (select auth.uid()));
create policy notification_preferences_owner_update on public.notification_preferences
  for update to authenticated using (user_id = (select auth.uid())) with check (user_id = (select auth.uid()));

create policy public_skill_passports_owner_read on public.public_skill_passports
  for select to authenticated using (user_id = (select auth.uid()));
create policy public_skill_passports_shared_read on public.public_skill_passports
  for select to anon, authenticated using (is_public);
create policy public_skill_passports_owner_insert on public.public_skill_passports
  for insert to authenticated with check (user_id = (select auth.uid()));
create policy public_skill_passports_owner_update on public.public_skill_passports
  for update to authenticated using (user_id = (select auth.uid())) with check (user_id = (select auth.uid()));

grant select, insert, update, delete on public.educator_classes, public.class_invitations,
  public.class_memberships, public.educator_assignments, public.assignment_submissions,
  public.notification_preferences to authenticated;
grant select on public.public_skill_passports to anon, authenticated;
grant insert, update on public.public_skill_passports to authenticated;
grant select, insert, update on public.assignment_submissions to authenticated;

-- Awards are emitted only from completed, persisted assessments and verified
-- roadmap completion records. Client requests cannot mint an achievement.
create or replace function public.award_phase4_achievements()
returns trigger language plpgsql security definer set search_path = public, pg_temp as $$
declare v_student uuid; v_score integer; v_title text; v_category text;
begin
  if TG_TABLE_NAME = 'ai_evaluations' then
    v_student := NEW.student_id;
    if NEW.evaluation_status <> 'completed' then return NEW; end if;
    v_score := NEW.overall_score;
    select title, category into v_title, v_category from public.simulations where id = NEW.simulation_id;
    insert into public.achievements(student_id, achievement_name, description)
      values (v_student, 'First Simulation Completed', 'Completed and received a saved assessment for a workplace simulation.')
      on conflict (student_id, achievement_name) do nothing;
    if v_category = 'Technical' and v_score >= 80 then
      insert into public.achievements(student_id, achievement_name, description)
        values (v_student, 'Problem Solver', 'Scored at least 80 on a completed technical simulation assessment.')
        on conflict (student_id, achievement_name) do nothing;
    end if;
    if v_category = 'Communication' and v_score >= 80 then
      insert into public.achievements(student_id, achievement_name, description)
        values (v_student, 'Communication Pro', 'Scored at least 80 on a completed communication simulation assessment.')
        on conflict (student_id, achievement_name) do nothing;
    end if;
    if coalesce(v_title,'') ilike '%interview%' and v_score >= 75 then
      insert into public.achievements(student_id, achievement_name, description)
        values (v_student, 'Interview Ready', 'Scored at least 75 on a completed interview simulation assessment.')
        on conflict (student_id, achievement_name) do nothing;
    end if;
  elsif TG_TABLE_NAME = 'student_roadmaps' then
    if NEW.selection_status = 'completed' then
      insert into public.achievements(student_id, achievement_name, description)
        values (NEW.student_id, 'Roadmap Completed', 'Completed every required topic in a selected career roadmap.')
        on conflict (student_id, achievement_name) do nothing;
      if exists (select 1 from public.roadmaps r where r.id = NEW.roadmap_id and r.title ilike 'Python%') then
        insert into public.achievements(student_id, achievement_name, description)
          values (NEW.student_id, 'Python Beginner', 'Completed the Python + DSA learning roadmap.')
          on conflict (student_id, achievement_name) do nothing;
      end if;
    end if;
  end if;
  return NEW;
end;
$$;
revoke all on function public.award_phase4_achievements() from public, anon, authenticated;
drop trigger if exists award_phase4_simulation_achievement on public.ai_evaluations;
create trigger award_phase4_simulation_achievement after insert or update of evaluation_status
  on public.ai_evaluations for each row execute function public.award_phase4_achievements();
drop trigger if exists award_phase4_roadmap_achievement on public.student_roadmaps;
create trigger award_phase4_roadmap_achievement after insert or update of selection_status
  on public.student_roadmaps for each row execute function public.award_phase4_achievements();

insert into public.achievements(student_id, achievement_name, description)
select e.student_id, 'First Simulation Completed', 'Completed and received a saved assessment for a workplace simulation.'
from public.ai_evaluations e where e.evaluation_status = 'completed'
on conflict (student_id, achievement_name) do nothing;
