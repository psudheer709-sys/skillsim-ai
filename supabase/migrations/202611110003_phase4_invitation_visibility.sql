-- Let an invited account see the minimal class metadata needed to decide
-- whether to accept. The invitation table remains email-scoped by RLS.
create policy educator_classes_invitee_read on public.educator_classes
  for select to authenticated using (exists (
    select 1 from public.class_invitations i
    where i.class_id = public.educator_classes.id
      and lower(i.email) = lower(coalesce(auth.jwt()->>'email', ''))
  ));
