-- SkillSim AI Phase 2 schema. Apply with `supabase db push`.
create extension if not exists pgcrypto;

do $$ begin
  create type public.account_role as enum ('student','educator','administrator');
exception when duplicate_object then null; end $$;

do $$ begin
  create type public.learning_record_status as enum ('not_started','in_progress','completed');
exception when duplicate_object then null; end $$;

do $$ begin
  create type public.submission_status as enum ('submitted','reviewed','returned');
exception when duplicate_object then null; end $$;

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text not null default '',
  email text not null default '',
  college_name text not null default '',
  course text not null default '',
  career_interest text not null default '',
  role public.account_role not null default 'student',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.student_preferences (
  id uuid primary key default gen_random_uuid(),
  student_id uuid not null unique references public.profiles(id) on delete cascade,
  current_skill_level text not null default 'Beginner' check (current_skill_level in ('Beginner','Intermediate','Advanced')),
  daily_learning_time text not null default '1 hour' check (daily_learning_time in ('30 minutes','1 hour','2 hours','3 hours or more')),
  career_goal text not null default 'Software Developer',
  preferred_learning_style text not null default 'mixed',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.educator_profiles (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null unique references public.profiles(id) on delete cascade,
  institution text not null default '',
  designation text not null default '',
  created_at timestamptz not null default now()
);

create table if not exists public.roadmaps (
  id uuid primary key default gen_random_uuid(),
  roadmap_code text not null unique,
  title text not null,
  description text not null default '',
  category text not null,
  difficulty text not null,
  estimated_duration integer not null check (estimated_duration > 0),
  career_opportunities text[] not null default '{}',
  skills_covered text[] not null default '{}',
  prerequisites text[] not null default '{}',
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.roadmap_stages (
  id uuid primary key default gen_random_uuid(),
  roadmap_id uuid not null references public.roadmaps(id) on delete cascade,
  stage_name text not null,
  description text not null default '',
  stage_order integer not null check (stage_order > 0),
  unique (roadmap_id, stage_order)
);

create table if not exists public.roadmap_topics (
  id uuid primary key default gen_random_uuid(),
  roadmap_id uuid not null references public.roadmaps(id) on delete cascade,
  stage_id uuid not null references public.roadmap_stages(id) on delete cascade,
  topic_title text not null,
  topic_description text not null default '',
  learning_objectives jsonb not null default '[]'::jsonb check (jsonb_typeof(learning_objectives) = 'array'),
  topic_order integer not null check (topic_order > 0),
  estimated_duration integer not null default 35 check (estimated_duration > 0),
  content jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  unique (stage_id, topic_order),
  unique (roadmap_id, topic_title),
  check (jsonb_typeof(content) = 'object')
);

create table if not exists public.student_roadmaps (
  id uuid primary key default gen_random_uuid(),
  student_id uuid not null references public.profiles(id) on delete cascade,
  roadmap_id uuid not null references public.roadmaps(id) on delete restrict,
  is_primary boolean not null default false,
  selection_status public.learning_record_status not null default 'in_progress',
  started_at timestamptz not null default now(),
  completed_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (student_id, roadmap_id)
);
create unique index if not exists student_roadmaps_one_primary_per_student
  on public.student_roadmaps(student_id) where is_primary;

create table if not exists public.topic_progress (
  id uuid primary key default gen_random_uuid(),
  student_id uuid not null references public.profiles(id) on delete cascade,
  roadmap_id uuid not null references public.roadmaps(id) on delete cascade,
  topic_id uuid not null references public.roadmap_topics(id) on delete cascade,
  status public.learning_record_status not null default 'in_progress',
  completion_percentage integer not null default 0 check (completion_percentage between 0 and 100),
  learning_time integer not null default 0 check (learning_time >= 0),
  completed_at timestamptz,
  updated_at timestamptz not null default now(),
  unique (student_id, roadmap_id, topic_id)
);

create table if not exists public.quiz_attempts (
  id uuid primary key default gen_random_uuid(),
  student_id uuid not null references public.profiles(id) on delete cascade,
  topic_id uuid not null references public.roadmap_topics(id) on delete cascade,
  score integer not null check (score >= 0),
  total_questions integer not null check (total_questions > 0),
  answers jsonb not null default '[]'::jsonb check (jsonb_typeof(answers) = 'array'),
  completed_at timestamptz not null default now(),
  check (score <= total_questions)
);

create table if not exists public.weekly_learning_plans (
  id uuid primary key default gen_random_uuid(),
  student_id uuid not null references public.profiles(id) on delete cascade,
  roadmap_id uuid not null references public.roadmaps(id) on delete cascade,
  week_start_date date not null,
  weekly_target_minutes integer not null check (weekly_target_minutes > 0),
  plan_data jsonb not null default '{}'::jsonb check (jsonb_typeof(plan_data) = 'object'),
  created_at timestamptz not null default now(),
  unique (student_id, roadmap_id, week_start_date)
);

create table if not exists public.weekly_learning_tasks (
  id uuid primary key default gen_random_uuid(),
  plan_id uuid not null references public.weekly_learning_plans(id) on delete cascade,
  student_id uuid not null references public.profiles(id) on delete cascade,
  topic_id uuid references public.roadmap_topics(id) on delete set null,
  task_title text not null,
  scheduled_date date not null,
  estimated_minutes integer not null default 35 check (estimated_minutes > 0),
  actual_minutes integer check (actual_minutes is null or actual_minutes >= 0),
  status public.learning_record_status not null default 'not_started',
  completed_at timestamptz,
  created_at timestamptz not null default now(),
  unique (plan_id, scheduled_date, topic_id)
);

create table if not exists public.simulations (
  id uuid primary key default gen_random_uuid(),
  title text not null unique,
  description text not null default '',
  category text not null,
  difficulty text not null,
  estimated_duration integer not null check (estimated_duration > 0),
  is_active boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists public.submissions (
  id uuid primary key default gen_random_uuid(),
  student_id uuid not null references public.profiles(id) on delete cascade,
  simulation_id uuid not null references public.simulations(id) on delete restrict,
  submission_content text not null check (length(btrim(submission_content)) between 1 and 20000),
  status public.submission_status not null default 'submitted',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.notifications (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  title text not null,
  message text not null,
  is_read boolean not null default false,
  created_at timestamptz not null default now()
);

create table if not exists public.achievements (
  id uuid primary key default gen_random_uuid(),
  student_id uuid not null references public.profiles(id) on delete cascade,
  achievement_name text not null,
  description text not null default '',
  earned_at timestamptz not null default now(),
  unique (student_id, achievement_name)
);

-- Educator scope is explicit: educators only see students assigned to them.
create table if not exists public.educator_students (
  id uuid primary key default gen_random_uuid(),
  educator_id uuid not null references public.profiles(id) on delete cascade,
  student_id uuid not null references public.profiles(id) on delete cascade,
  assigned_by uuid references public.profiles(id) on delete set null,
  created_at timestamptz not null default now(),
  unique (educator_id, student_id),
  check (educator_id <> student_id)
);

create table if not exists public.educator_simulations (
  id uuid primary key default gen_random_uuid(),
  educator_id uuid not null references public.profiles(id) on delete cascade,
  simulation_id uuid not null references public.simulations(id) on delete cascade,
  created_at timestamptz not null default now(),
  unique (educator_id, simulation_id)
);

create table if not exists public.project_progress (
  id uuid primary key default gen_random_uuid(),
  student_id uuid not null references public.profiles(id) on delete cascade,
  roadmap_id uuid not null references public.roadmaps(id) on delete cascade,
  project_title text not null,
  status public.learning_record_status not null default 'not_started',
  completed_at timestamptz,
  updated_at timestamptz not null default now(),
  unique (student_id, roadmap_id, project_title)
);

create index if not exists idx_roadmap_stages_roadmap_order on public.roadmap_stages(roadmap_id, stage_order);
create index if not exists idx_roadmap_topics_stage_order on public.roadmap_topics(stage_id, topic_order);
create index if not exists idx_student_roadmaps_student on public.student_roadmaps(student_id);
create index if not exists idx_topic_progress_student_roadmap on public.topic_progress(student_id, roadmap_id);
create index if not exists idx_quiz_attempts_student_topic on public.quiz_attempts(student_id, topic_id, completed_at desc);
create index if not exists idx_weekly_plans_student_week on public.weekly_learning_plans(student_id, week_start_date desc);
create index if not exists idx_weekly_tasks_student_date on public.weekly_learning_tasks(student_id, scheduled_date);
create index if not exists idx_submissions_student_created on public.submissions(student_id, created_at desc);
create index if not exists idx_notifications_user_created on public.notifications(user_id, created_at desc);
create index if not exists idx_educator_students_educator on public.educator_students(educator_id);
create index if not exists idx_educator_students_student on public.educator_students(student_id);

create or replace function public.set_updated_at()
returns trigger language plpgsql set search_path = public as $$
begin new.updated_at = now(); return new; end;
$$;

do $$ declare t text; begin
  foreach t in array array['profiles','student_preferences','roadmaps','student_roadmaps','topic_progress','submissions','project_progress'] loop
    execute format('drop trigger if exists %I_set_updated_at on public.%I',t,t);
    execute format('create trigger %I_set_updated_at before update on public.%I for each row execute function public.set_updated_at()',t,t);
  end loop;
end $$;

create or replace function public.app_role_for_user(user_id uuid default auth.uid())
returns public.account_role language sql stable security definer set search_path = public as $$
  select role from public.profiles where id = user_id
$$;
create or replace function public.is_administrator(user_id uuid default auth.uid())
returns boolean language sql stable security definer set search_path = public as $$
  select coalesce(public.app_role_for_user(user_id) = 'administrator', false)
$$;
create or replace function public.is_assigned_student(target_student uuid, educator uuid default auth.uid())
returns boolean language sql stable security definer set search_path = public as $$
  select exists(select 1 from public.educator_students es where es.student_id = target_student and es.educator_id = educator)
$$;
revoke all on function public.app_role_for_user(uuid) from public;
revoke all on function public.is_administrator(uuid) from public;
revoke all on function public.is_assigned_student(uuid,uuid) from public;
grant execute on function public.app_role_for_user(uuid) to authenticated;
grant execute on function public.is_administrator(uuid) to authenticated;
grant execute on function public.is_assigned_student(uuid,uuid) to authenticated;

create or replace function public.guard_profile_role()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  if new.role is distinct from old.role
     and coalesce(auth.role(), '') <> 'service_role'
     and session_user not in ('postgres','supabase_admin') then
    raise exception 'Profile roles can only be changed by an authorized administrator operation.' using errcode = '42501';
  end if;
  return new;
end;
$$;
drop trigger if exists profiles_guard_role on public.profiles;
create trigger profiles_guard_role before update of role on public.profiles for each row execute function public.guard_profile_role();

create or replace function public.handle_new_auth_user()
returns trigger language plpgsql security definer set search_path = public as $$
declare requested_role text;
begin
  requested_role := lower(coalesce(new.raw_user_meta_data->>'account_type','student'));
  insert into public.profiles(id, full_name, email, college_name, course, career_interest, role)
  values (
    new.id,
    left(coalesce(new.raw_user_meta_data->>'full_name',''),200),
    coalesce(new.email,''),
    left(coalesce(new.raw_user_meta_data->>'college_name',''),200),
    left(coalesce(new.raw_user_meta_data->>'course',''),200),
    left(coalesce(new.raw_user_meta_data->>'career_interest',''),200),
    case when requested_role = 'educator' then 'educator'::public.account_role else 'student'::public.account_role end
  ) on conflict (id) do update set email = excluded.email;
  if requested_role = 'educator' then
    insert into public.educator_profiles(user_id, institution, designation)
    values (new.id, left(coalesce(new.raw_user_meta_data->>'college_name',''),200), left(coalesce(new.raw_user_meta_data->>'designation','Educator'),120))
    on conflict (user_id) do nothing;
  end if;
  return new;
end;
$$;
drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created after insert on auth.users for each row execute function public.handle_new_auth_user();

create or replace function public.select_primary_roadmap(
  p_roadmap_id uuid,
  p_current_skill_level text,
  p_daily_learning_time text,
  p_career_goal text,
  p_preferred_learning_style text default 'mixed'
)
returns public.student_roadmaps language plpgsql security definer set search_path = public as $$
declare uid uuid := auth.uid(); result public.student_roadmaps;
begin
  if uid is null then raise exception 'Authentication required' using errcode = '28000'; end if;
  if public.app_role_for_user(uid) is distinct from 'student' then raise exception 'Only students can select a learning roadmap' using errcode = '42501'; end if;
  if not exists(select 1 from public.roadmaps where id = p_roadmap_id and is_active) then raise exception 'Roadmap not found or inactive' using errcode = '22023'; end if;
  if p_current_skill_level not in ('Beginner','Intermediate','Advanced') then raise exception 'Invalid skill level' using errcode = '22023'; end if;
  if p_daily_learning_time not in ('30 minutes','1 hour','2 hours','3 hours or more') then raise exception 'Invalid daily learning time' using errcode = '22023'; end if;
  update public.student_roadmaps set is_primary = false, updated_at = now() where student_id = uid and is_primary;
  insert into public.student_roadmaps(student_id, roadmap_id, is_primary, selection_status, started_at)
    values(uid, p_roadmap_id, true, 'in_progress', now())
  on conflict(student_id, roadmap_id) do update set is_primary = true, selection_status = case when student_roadmaps.selection_status = 'completed' then 'completed'::public.learning_record_status else 'in_progress'::public.learning_record_status end, updated_at = now()
  returning * into result;
  insert into public.student_preferences(student_id,current_skill_level,daily_learning_time,career_goal,preferred_learning_style)
    values(uid,p_current_skill_level,p_daily_learning_time,left(p_career_goal,160),left(coalesce(p_preferred_learning_style,'mixed'),40))
  on conflict(student_id) do update set current_skill_level=excluded.current_skill_level,daily_learning_time=excluded.daily_learning_time,career_goal=excluded.career_goal,preferred_learning_style=excluded.preferred_learning_style,updated_at=now();
  return result;
end;
$$;
revoke all on function public.select_primary_roadmap(uuid,text,text,text,text) from public;
grant execute on function public.select_primary_roadmap(uuid,text,text,text,text) to authenticated;

create or replace function public.is_authorized_educator_for_student(target_student uuid)
returns boolean language sql stable security definer set search_path=public as $$
 select public.app_role_for_user(auth.uid())='educator' and public.is_assigned_student(target_student,auth.uid())
$$;
revoke all on function public.is_authorized_educator_for_student(uuid) from public;
grant execute on function public.is_authorized_educator_for_student(uuid) to authenticated;

alter table public.profiles enable row level security;
alter table public.student_preferences enable row level security;
alter table public.educator_profiles enable row level security;
alter table public.roadmaps enable row level security;
alter table public.roadmap_stages enable row level security;
alter table public.roadmap_topics enable row level security;
alter table public.student_roadmaps enable row level security;
alter table public.topic_progress enable row level security;
alter table public.quiz_attempts enable row level security;
alter table public.weekly_learning_plans enable row level security;
alter table public.weekly_learning_tasks enable row level security;
alter table public.simulations enable row level security;
alter table public.submissions enable row level security;
alter table public.notifications enable row level security;
alter table public.achievements enable row level security;
alter table public.educator_students enable row level security;
alter table public.educator_simulations enable row level security;
alter table public.project_progress enable row level security;

drop policy if exists profiles_read_self_or_assigned on public.profiles;
create policy profiles_read_self_or_assigned on public.profiles for select to authenticated using (id=auth.uid() or public.is_administrator() or public.is_authorized_educator_for_student(id));
drop policy if exists profiles_update_self on public.profiles;
create policy profiles_update_self on public.profiles for update to authenticated using (id=auth.uid()) with check (id=auth.uid());

drop policy if exists preferences_self on public.student_preferences;
create policy preferences_self on public.student_preferences for all to authenticated using (student_id=auth.uid() or public.is_administrator()) with check (student_id=auth.uid() or public.is_administrator());
drop policy if exists educator_profiles_self_admin on public.educator_profiles;
create policy educator_profiles_self_admin on public.educator_profiles for select to authenticated using (user_id=auth.uid() or public.is_administrator());
drop policy if exists educator_profiles_update_self on public.educator_profiles;
create policy educator_profiles_update_self on public.educator_profiles for update to authenticated using (user_id=auth.uid()) with check (user_id=auth.uid());

drop policy if exists roadmaps_public_read on public.roadmaps;
create policy roadmaps_public_read on public.roadmaps for select to anon,authenticated using (is_active or public.is_administrator());
drop policy if exists stages_public_read on public.roadmap_stages;
create policy stages_public_read on public.roadmap_stages for select to anon,authenticated using (exists(select 1 from public.roadmaps r where r.id=roadmap_id and r.is_active));
drop policy if exists topics_public_read on public.roadmap_topics;
create policy topics_public_read on public.roadmap_topics for select to anon,authenticated using (exists(select 1 from public.roadmaps r where r.id=roadmap_id and r.is_active));

drop policy if exists student_roadmaps_self_or_assigned_read on public.student_roadmaps;
create policy student_roadmaps_self_or_assigned_read on public.student_roadmaps for select to authenticated using (student_id=auth.uid() or public.is_administrator() or public.is_authorized_educator_for_student(student_id));
drop policy if exists student_roadmaps_self_write on public.student_roadmaps;
create policy student_roadmaps_self_write on public.student_roadmaps for insert to authenticated with check (student_id=auth.uid() and public.app_role_for_user() = 'student');
-- Primary-roadmap changes use select_primary_roadmap() so the transition is atomic.

drop policy if exists topic_progress_self_or_assigned_read on public.topic_progress;
create policy topic_progress_self_or_assigned_read on public.topic_progress for select to authenticated using (student_id=auth.uid() or public.is_administrator() or public.is_authorized_educator_for_student(student_id));
drop policy if exists topic_progress_self_insert on public.topic_progress;
create policy topic_progress_self_insert on public.topic_progress for insert to authenticated with check (student_id=auth.uid() and public.app_role_for_user()='student');
drop policy if exists topic_progress_self_update on public.topic_progress;
create policy topic_progress_self_update on public.topic_progress for update to authenticated using (student_id=auth.uid()) with check (student_id=auth.uid());

drop policy if exists quiz_attempts_self_or_assigned_read on public.quiz_attempts;
create policy quiz_attempts_self_or_assigned_read on public.quiz_attempts for select to authenticated using (student_id=auth.uid() or public.is_administrator() or public.is_authorized_educator_for_student(student_id));
drop policy if exists quiz_attempts_self_insert on public.quiz_attempts;
create policy quiz_attempts_self_insert on public.quiz_attempts for insert to authenticated with check (student_id=auth.uid() and public.app_role_for_user()='student');

drop policy if exists weekly_plans_self_or_assigned_read on public.weekly_learning_plans;
create policy weekly_plans_self_or_assigned_read on public.weekly_learning_plans for select to authenticated using (student_id=auth.uid() or public.is_administrator() or public.is_authorized_educator_for_student(student_id));
drop policy if exists weekly_plans_self_write on public.weekly_learning_plans;
create policy weekly_plans_self_write on public.weekly_learning_plans for all to authenticated using (student_id=auth.uid() and public.app_role_for_user()='student') with check (student_id=auth.uid() and public.app_role_for_user()='student');

drop policy if exists weekly_tasks_self_or_assigned_read on public.weekly_learning_tasks;
create policy weekly_tasks_self_or_assigned_read on public.weekly_learning_tasks for select to authenticated using (student_id=auth.uid() or public.is_administrator() or public.is_authorized_educator_for_student(student_id));
drop policy if exists weekly_tasks_self_write on public.weekly_learning_tasks;
create policy weekly_tasks_self_write on public.weekly_learning_tasks for insert to authenticated with check (student_id=auth.uid() and public.app_role_for_user()='student');
drop policy if exists weekly_tasks_self_update on public.weekly_learning_tasks;
create policy weekly_tasks_self_update on public.weekly_learning_tasks for update to authenticated using (student_id=auth.uid()) with check (student_id=auth.uid());

drop policy if exists simulations_public_read on public.simulations;
create policy simulations_public_read on public.simulations for select to anon,authenticated using (is_active or public.is_administrator());
drop policy if exists submissions_self_or_assigned_read on public.submissions;
create policy submissions_self_or_assigned_read on public.submissions for select to authenticated using (student_id=auth.uid() or public.is_administrator() or public.is_authorized_educator_for_student(student_id));
drop policy if exists submissions_self_insert on public.submissions;
create policy submissions_self_insert on public.submissions for insert to authenticated with check (student_id=auth.uid() and public.app_role_for_user()='student');
drop policy if exists submissions_self_update on public.submissions;
create policy submissions_self_update on public.submissions for update to authenticated using (student_id=auth.uid()) with check (student_id=auth.uid());

drop policy if exists notifications_self_read_update on public.notifications;
create policy notifications_self_read_update on public.notifications for select to authenticated using (user_id=auth.uid() or public.is_administrator());
drop policy if exists notifications_self_update on public.notifications;
create policy notifications_self_update on public.notifications for update to authenticated using (user_id=auth.uid()) with check (user_id=auth.uid());
drop policy if exists achievements_self_read on public.achievements;
create policy achievements_self_read on public.achievements for select to authenticated using (student_id=auth.uid() or public.is_administrator() or public.is_authorized_educator_for_student(student_id));

drop policy if exists educator_students_admin_or_self_read on public.educator_students;
create policy educator_students_admin_or_self_read on public.educator_students for select to authenticated using (educator_id=auth.uid() or public.is_administrator());
drop policy if exists educator_students_admin_write on public.educator_students;
create policy educator_students_admin_write on public.educator_students for all to authenticated using (public.is_administrator()) with check (public.is_administrator());
drop policy if exists educator_simulations_educator_read on public.educator_simulations;
create policy educator_simulations_educator_read on public.educator_simulations for select to authenticated using (educator_id=auth.uid() or public.is_administrator());
drop policy if exists educator_simulations_admin_write on public.educator_simulations;
create policy educator_simulations_admin_write on public.educator_simulations for all to authenticated using (public.is_administrator()) with check (public.is_administrator());

drop policy if exists project_progress_self_read_write on public.project_progress;
create policy project_progress_self_read_write on public.project_progress for all to authenticated using (student_id=auth.uid() and public.app_role_for_user()='student') with check (student_id=auth.uid() and public.app_role_for_user()='student');

-- Explicit grants complement RLS; anon only receives published catalog reads.
grant usage on schema public to anon, authenticated;
grant select on public.roadmaps,public.roadmap_stages,public.roadmap_topics,public.simulations to anon,authenticated;
grant select,update on public.profiles to authenticated;
grant select,insert,update,delete on public.student_preferences,public.educator_profiles,public.topic_progress,public.weekly_learning_plans,public.weekly_learning_tasks,public.submissions,public.notifications,public.project_progress to authenticated;
grant select,insert on public.student_roadmaps,public.quiz_attempts to authenticated;
grant select on public.achievements,public.educator_students,public.educator_simulations to authenticated;
grant all on all tables in schema public to service_role;
