-- Break cyclic RLS checks across Phase 4 educator classes and memberships.
-- Private SECURITY DEFINER predicates inspect relationships without re-entering
-- the exposed-table policies; every predicate is scoped to the signed-in user.
create schema if not exists app_private;
revoke all on schema app_private from public, anon, authenticated;
grant usage on schema app_private to authenticated;

create or replace function app_private.is_class_owner(target_class uuid)
returns boolean
language sql stable security definer set search_path = ''
as $$
  select auth.uid() is not null and exists (
    select 1 from public.educator_classes c
    where c.id = target_class and c.educator_id = auth.uid()
  );
$$;

create or replace function app_private.is_class_member(target_class uuid)
returns boolean
language sql stable security definer set search_path = ''
as $$
  select auth.uid() is not null and exists (
    select 1 from public.class_memberships m
    where m.class_id = target_class and m.student_id = auth.uid()
  );
$$;

create or replace function app_private.has_class_invitation(target_class uuid)
returns boolean
language sql stable security definer set search_path = ''
as $$
  select auth.uid() is not null and exists (
    select 1 from public.class_invitations i
    where i.class_id = target_class
      and lower(i.email) = lower(coalesce(auth.jwt() ->> 'email', ''))
  );
$$;

revoke all on function app_private.is_class_owner(uuid) from public, anon, authenticated;
revoke all on function app_private.is_class_member(uuid) from public, anon, authenticated;
revoke all on function app_private.has_class_invitation(uuid) from public, anon, authenticated;
grant execute on function app_private.is_class_owner(uuid) to authenticated;
grant execute on function app_private.is_class_member(uuid) to authenticated;
grant execute on function app_private.has_class_invitation(uuid) to authenticated;

drop policy if exists educator_classes_member_read on public.educator_classes;
create policy educator_classes_member_read on public.educator_classes
  for select to authenticated
  using (app_private.is_class_member(id));

drop policy if exists class_memberships_owner_or_member_read on public.class_memberships;
create policy class_memberships_owner_or_member_read on public.class_memberships
  for select to authenticated
  using (
    student_id = (select auth.uid())
    or app_private.is_class_owner(class_id)
    or public.is_administrator()
  );

drop policy if exists class_memberships_invited_student_join on public.class_memberships;
create policy class_memberships_invited_student_join on public.class_memberships
  for insert to authenticated
  with check (
    student_id = (select auth.uid())
    and public.app_role_for_user() = 'student'
    and app_private.has_class_invitation(class_id)
  );

drop policy if exists class_invitations_owner_all on public.class_invitations;
create policy class_invitations_owner_all on public.class_invitations
  for all to authenticated
  using (app_private.is_class_owner(class_id))
  with check (
    invited_by = (select auth.uid())
    and app_private.is_class_owner(class_id)
  );

drop policy if exists educator_assignments_owner_select on public.educator_assignments;
create policy educator_assignments_owner_select on public.educator_assignments
  for select to authenticated
  using (
    educator_id = (select auth.uid())
    or app_private.is_class_member(class_id)
    or public.is_administrator()
  );

drop policy if exists educator_assignments_owner_insert on public.educator_assignments;
create policy educator_assignments_owner_insert on public.educator_assignments
  for insert to authenticated
  with check (
    educator_id = (select auth.uid())
    and app_private.is_class_owner(class_id)
  );

drop policy if exists educator_assignments_owner_update on public.educator_assignments;
create policy educator_assignments_owner_update on public.educator_assignments
  for update to authenticated
  using (educator_id = (select auth.uid()))
  with check (
    educator_id = (select auth.uid())
    and app_private.is_class_owner(class_id)
  );

drop policy if exists educator_announcements_read on public.educator_announcements;
create policy educator_announcements_read on public.educator_announcements
  for select to authenticated
  using (
    educator_id = (select auth.uid())
    or app_private.is_class_member(class_id)
    or public.is_administrator()
  );

drop policy if exists educator_announcements_owner_insert on public.educator_announcements;
create policy educator_announcements_owner_insert on public.educator_announcements
  for insert to authenticated
  with check (
    educator_id = (select auth.uid())
    and app_private.is_class_owner(class_id)
  );
