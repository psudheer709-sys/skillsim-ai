-- Create the institution owner's membership as part of the authenticated
-- institution insert. Keeping this in a private trigger avoids requiring a
-- service-role key for normal signed-in registration.
create or replace function app_private.add_institution_creator_membership()
returns trigger
language plpgsql
security definer
set search_path = ''
as $function$
begin
  if auth.uid() is null
     or new.created_by is distinct from auth.uid()
     or new.status is distinct from 'pending' then
    raise exception 'Only the signed-in creator can register a pending institution.'
      using errcode = '42501';
  end if;

  insert into public.institution_members (institution_id, user_id, role, status)
  values (new.id, new.created_by, 'institution_admin', 'active');

  return new;
end;
$function$;

revoke all on function app_private.add_institution_creator_membership() from public, anon, authenticated;

drop trigger if exists institutions_add_creator_membership on public.institutions;
create trigger institutions_add_creator_membership
after insert on public.institutions
for each row execute function app_private.add_institution_creator_membership();
