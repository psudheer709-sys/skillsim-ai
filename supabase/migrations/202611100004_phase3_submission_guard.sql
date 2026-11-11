-- Keep the reviewed response attached to its immutable AI evaluation.
create or replace function public.guard_completed_ai_submission()
returns trigger language plpgsql set search_path=public as $$
begin
  if new.submission_content is distinct from old.submission_content and exists (
    select 1 from public.ai_evaluations e
    where e.submission_id=old.id and e.evaluation_status='completed'
  ) then
    raise exception 'A response with a completed AI evaluation cannot be edited.' using errcode='55000';
  end if;
  return new;
end;
$$;
drop trigger if exists guard_completed_ai_submission on public.submissions;
create trigger guard_completed_ai_submission before update of submission_content on public.submissions
for each row execute function public.guard_completed_ai_submission();
