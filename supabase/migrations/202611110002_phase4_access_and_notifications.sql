-- Extend class membership authorization to existing learner records and wire
-- database-backed in-app notifications to real assessment and assignment events.
alter table public.notifications add column if not exists notification_type text not null default 'general';
alter table public.notifications add column if not exists class_id uuid references public.educator_classes(id) on delete cascade;
alter table public.notifications add column if not exists created_by uuid references public.profiles(id) on delete set null;
alter table public.notifications add column if not exists related_url text;

create table if not exists public.educator_announcements (
  id uuid primary key default gen_random_uuid(),
  class_id uuid not null references public.educator_classes(id) on delete cascade,
  educator_id uuid not null references public.profiles(id) on delete cascade,
  title text not null check (char_length(title) between 3 and 160),
  message text not null check (char_length(message) between 1 and 3000),
  created_at timestamptz not null default now()
);
create index if not exists educator_announcements_class_created_idx on public.educator_announcements(class_id, created_at desc);
alter table public.educator_announcements enable row level security;

create policy educator_announcements_read on public.educator_announcements
  for select to authenticated using (
    educator_id = (select auth.uid()) or exists (
      select 1 from public.class_memberships m where m.class_id = public.educator_announcements.class_id and m.student_id = (select auth.uid())
    ) or public.is_administrator()
  );
create policy educator_announcements_owner_insert on public.educator_announcements
  for insert to authenticated with check (
    educator_id = (select auth.uid()) and exists (
      select 1 from public.educator_classes c where c.id = class_id and c.educator_id = (select auth.uid())
    )
  );
grant select, insert on public.educator_announcements to authenticated;

-- Educators gain read-only access only to the learners explicitly enrolled in
-- one of their classes. Existing self and admin policies remain unchanged.
create policy class_educator_read_profiles on public.profiles
  for select to authenticated using (exists (
    select 1 from public.class_memberships m
    join public.educator_classes c on c.id = m.class_id
    where m.student_id = public.profiles.id and c.educator_id = (select auth.uid())
  ));
create policy class_educator_read_roadmaps on public.student_roadmaps
  for select to authenticated using (exists (
    select 1 from public.class_memberships m join public.educator_classes c on c.id = m.class_id
    where m.student_id = public.student_roadmaps.student_id and c.educator_id = (select auth.uid())
  ));
create policy class_educator_read_topic_progress on public.topic_progress
  for select to authenticated using (exists (
    select 1 from public.class_memberships m join public.educator_classes c on c.id = m.class_id
    where m.student_id = public.topic_progress.student_id and c.educator_id = (select auth.uid())
  ));
create policy class_educator_read_quiz_attempts on public.quiz_attempts
  for select to authenticated using (exists (
    select 1 from public.class_memberships m join public.educator_classes c on c.id = m.class_id
    where m.student_id = public.quiz_attempts.student_id and c.educator_id = (select auth.uid())
  ));
create policy class_educator_read_weekly_plans on public.weekly_learning_plans
  for select to authenticated using (exists (
    select 1 from public.class_memberships m join public.educator_classes c on c.id = m.class_id
    where m.student_id = public.weekly_learning_plans.student_id and c.educator_id = (select auth.uid())
  ));
create policy class_educator_read_weekly_tasks on public.weekly_learning_tasks
  for select to authenticated using (exists (
    select 1 from public.class_memberships m join public.educator_classes c on c.id = m.class_id
    where m.student_id = public.weekly_learning_tasks.student_id and c.educator_id = (select auth.uid())
  ));
create policy class_educator_read_project_progress on public.project_progress
  for select to authenticated using (exists (
    select 1 from public.class_memberships m join public.educator_classes c on c.id = m.class_id
    where m.student_id = public.project_progress.student_id and c.educator_id = (select auth.uid())
  ));
create policy class_educator_read_submissions on public.submissions
  for select to authenticated using (exists (
    select 1 from public.class_memberships m join public.educator_classes c on c.id = m.class_id
    where m.student_id = public.submissions.student_id and c.educator_id = (select auth.uid())
  ));
create policy class_educator_read_evaluations on public.ai_evaluations
  for select to authenticated using (exists (
    select 1 from public.class_memberships m join public.educator_classes c on c.id = m.class_id
    where m.student_id = public.ai_evaluations.student_id and c.educator_id = (select auth.uid())
  ));
create policy class_educator_read_mistakes on public.student_mistakes
  for select to authenticated using (exists (
    select 1 from public.class_memberships m join public.educator_classes c on c.id = m.class_id
    where m.student_id = public.student_mistakes.student_id and c.educator_id = (select auth.uid())
  ));
create policy class_educator_read_skills on public.student_skill_scores
  for select to authenticated using (exists (
    select 1 from public.class_memberships m join public.educator_classes c on c.id = m.class_id
    where m.student_id = public.student_skill_scores.student_id and c.educator_id = (select auth.uid())
  ));
create policy class_educator_read_achievements on public.achievements
  for select to authenticated using (exists (
    select 1 from public.class_memberships m join public.educator_classes c on c.id = m.class_id
    where m.student_id = public.achievements.student_id and c.educator_id = (select auth.uid())
  ));

create policy notification_owner_insert on public.notifications
  for insert to authenticated with check (user_id = (select auth.uid()));
create policy educator_class_notification_insert on public.notifications
  for insert to authenticated with check (
    created_by = (select auth.uid()) and class_id is not null and exists (
      select 1 from public.educator_classes c join public.class_memberships m on m.class_id = c.id
      where c.id = public.notifications.class_id and c.educator_id = (select auth.uid()) and m.student_id = public.notifications.user_id
    )
  );

create policy ai_recommendations_student_insert on public.ai_recommendations
  for insert to authenticated with check (student_id = (select auth.uid()));
create policy ai_recommendations_student_update on public.ai_recommendations
  for update to authenticated using (student_id = (select auth.uid()))
  with check (student_id = (select auth.uid()));
grant insert, update on public.ai_recommendations to authenticated;

create or replace function public.notify_phase4_assignment()
returns trigger language plpgsql security definer set search_path = public, pg_temp as $$
begin
  insert into public.notifications(user_id, title, message, notification_type, class_id, created_by, related_url)
  select m.student_id, 'New class assignment', NEW.title || case when NEW.due_at is null then '' else ' · Due ' || to_char(NEW.due_at at time zone 'UTC','Mon DD, YYYY HH24:MI') || ' UTC' end,
    'assignment', NEW.class_id, NEW.educator_id, '/dashboard'
  from public.class_memberships m
  left join public.notification_preferences p on p.user_id = m.student_id
  where m.class_id = NEW.class_id and coalesce(p.assignment_notifications, true);
  return NEW;
end;
$$;
revoke all on function public.notify_phase4_assignment() from public, anon, authenticated;
drop trigger if exists notify_phase4_assignment_created on public.educator_assignments;
create trigger notify_phase4_assignment_created after insert on public.educator_assignments
  for each row execute function public.notify_phase4_assignment();

create or replace function public.notify_phase4_announcement()
returns trigger language plpgsql security definer set search_path = public, pg_temp as $$
begin
  insert into public.notifications(user_id, title, message, notification_type, class_id, created_by, related_url)
  select m.student_id, NEW.title, NEW.message, 'announcement', NEW.class_id, NEW.educator_id, '/dashboard'
  from public.class_memberships m
  left join public.notification_preferences p on p.user_id = m.student_id
  where m.class_id = NEW.class_id and coalesce(p.announcement_notifications, true);
  return NEW;
end;
$$;
revoke all on function public.notify_phase4_announcement() from public, anon, authenticated;
drop trigger if exists notify_phase4_announcement_created on public.educator_announcements;
create trigger notify_phase4_announcement_created after insert on public.educator_announcements
  for each row execute function public.notify_phase4_announcement();

create or replace function public.notify_phase4_assessment()
returns trigger language plpgsql security definer set search_path = public, pg_temp as $$
begin
  if NEW.evaluation_status = 'completed' and (TG_OP = 'INSERT' or OLD.evaluation_status is distinct from 'completed') then
    insert into public.notifications(user_id, title, message, notification_type, created_by, related_url)
    select NEW.student_id, 'Simulation feedback is ready', 'Your saved simulation has a completed assessment. Review the feedback and choose a next practice task.', 'feedback', NEW.student_id, '/submissions'
    where coalesce((select p.feedback_notifications from public.notification_preferences p where p.user_id = NEW.student_id), true);
  end if;
  return NEW;
end;
$$;
revoke all on function public.notify_phase4_assessment() from public, anon, authenticated;
drop trigger if exists notify_phase4_assessment_ready on public.ai_evaluations;
create trigger notify_phase4_assessment_ready after insert or update of evaluation_status on public.ai_evaluations
  for each row execute function public.notify_phase4_assessment();

create or replace function public.notify_phase4_milestone()
returns trigger language plpgsql security definer set search_path = public, pg_temp as $$
begin
  insert into public.notifications(user_id, title, message, notification_type, created_by, related_url)
  select NEW.student_id, 'Achievement unlocked', NEW.achievement_name || ' · ' || NEW.description, 'milestone', NEW.student_id, '/achievements'
  where coalesce((select p.milestone_notifications from public.notification_preferences p where p.user_id = NEW.student_id), true);
  return NEW;
end;
$$;
revoke all on function public.notify_phase4_milestone() from public, anon, authenticated;
drop trigger if exists notify_phase4_milestone_unlocked on public.achievements;
create trigger notify_phase4_milestone_unlocked after insert on public.achievements
  for each row execute function public.notify_phase4_milestone();

grant select, insert, update on public.notifications to authenticated;
