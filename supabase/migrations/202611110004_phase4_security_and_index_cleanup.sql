-- The achievements table already has a unique constraint on this pair.
drop index if exists public.achievements_student_name_unique;

-- Cover the foreign keys used by Phase 4 queries and cascading deletes.
create index if not exists class_invitations_invited_by_idx on public.class_invitations(invited_by);
create index if not exists educator_announcements_educator_idx on public.educator_announcements(educator_id);
create index if not exists educator_assignments_educator_idx on public.educator_assignments(educator_id);
create index if not exists educator_assignments_roadmap_idx on public.educator_assignments(roadmap_id);
create index if not exists notifications_class_id_idx on public.notifications(class_id) where class_id is not null;
create index if not exists notifications_created_by_idx on public.notifications(created_by) where created_by is not null;
create index if not exists student_roadmaps_roadmap_id_idx on public.student_roadmaps(roadmap_id);
create index if not exists topic_progress_roadmap_id_idx on public.topic_progress(roadmap_id);
create index if not exists topic_progress_topic_id_idx on public.topic_progress(topic_id);

-- Policies and the authenticated roadmap-selection API need these helpers,
-- but anonymous clients do not. Trigger functions are not RPC entry points.
revoke execute on function public.app_role_for_user(uuid) from public, anon;
grant execute on function public.app_role_for_user(uuid) to authenticated;
revoke execute on function public.is_administrator(uuid) from public, anon;
grant execute on function public.is_administrator(uuid) to authenticated;
revoke execute on function public.is_assigned_student(uuid, uuid) from public, anon;
grant execute on function public.is_assigned_student(uuid, uuid) to authenticated;
revoke execute on function public.is_authorized_educator_for_student(uuid) from public, anon;
grant execute on function public.is_authorized_educator_for_student(uuid) to authenticated;
revoke execute on function public.select_primary_roadmap(uuid, text, text, text, text) from public, anon;
grant execute on function public.select_primary_roadmap(uuid, text, text, text, text) to authenticated;
revoke execute on function public.guard_profile_role() from public, anon, authenticated;
revoke execute on function public.handle_new_auth_user() from public, anon, authenticated;
