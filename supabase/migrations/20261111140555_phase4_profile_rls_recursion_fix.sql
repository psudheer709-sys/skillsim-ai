-- Break the Phase 4 profile/class-membership RLS recursion.
create schema if not exists app_private;
revoke all on schema app_private from public, anon, authenticated;
grant usage on schema app_private to authenticated;

create or replace function app_private.is_class_educator_for_student(target_student uuid)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select auth.uid() is not null and exists (
    select 1
    from public.class_memberships m
    join public.educator_classes c on c.id = m.class_id
    where m.student_id = target_student
      and c.educator_id = auth.uid()
  );
$$;

revoke all on function app_private.is_class_educator_for_student(uuid) from public, anon, authenticated;
grant execute on function app_private.is_class_educator_for_student(uuid) to authenticated;

drop policy if exists class_educator_read_profiles on public.profiles;
create policy class_educator_read_profiles on public.profiles
  for select to authenticated
  using (app_private.is_class_educator_for_student(id));
