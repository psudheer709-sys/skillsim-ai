-- Explicit server-only audit-log policy (there are intentionally no user policies).
drop policy if exists "Server records AI usage logs" on public.ai_usage_logs;
create policy "Server records AI usage logs" on public.ai_usage_logs for all to service_role using(true) with check(true);

-- Link conversational transcripts to their saved evaluation and close the session atomically.
drop function if exists public.persist_phase3_evaluation(uuid,uuid,uuid,uuid,jsonb,text,text,integer,integer);
create function public.persist_phase3_evaluation(
 p_student_id uuid,p_submission_id uuid,p_simulation_id uuid,p_scenario_id uuid,p_session_id uuid,
 p_evaluation jsonb,p_provider text,p_model text,p_input_tokens integer,p_output_tokens integer
) returns uuid language plpgsql set search_path=public as $$
declare v_id uuid;
begin
 select id into v_id from public.ai_evaluations where submission_id=p_submission_id;
 if v_id is not null then return v_id; end if;
 insert into public.ai_evaluations(student_id,submission_id,simulation_id,scenario_id,session_id,overall_score,criteria_scores,strengths,weaknesses,improvements,mistakes,model_answer,next_practice,evaluation_status,provider,model,input_tokens,output_tokens)
 values(p_student_id,p_submission_id,p_simulation_id,p_scenario_id,p_session_id,(p_evaluation->>'overall_score')::integer,p_evaluation->'criteria',array(select jsonb_array_elements_text(p_evaluation->'strengths')),array(select jsonb_array_elements_text(p_evaluation->'weaknesses')),array(select jsonb_array_elements_text(p_evaluation->'improvements')),p_evaluation->'mistakes',p_evaluation->>'model_answer',p_evaluation->>'next_practice','completed',p_provider,p_model,p_input_tokens,p_output_tokens)
 on conflict(submission_id) do nothing returning id into v_id;
 if v_id is null then select id into v_id from public.ai_evaluations where submission_id=p_submission_id; return v_id; end if;
 insert into public.student_mistakes(student_id,evaluation_id,simulation_id,category,description,severity)
 select p_student_id,v_id,p_simulation_id,m->>'category',m->>'description',m->>'severity' from jsonb_array_elements(p_evaluation->'mistakes') m
 on conflict(evaluation_id,category,description) do nothing;
 insert into public.student_skill_scores(student_id,skill_name,current_score,previous_score)
 select p_student_id,c->>'name',(c->>'score')::integer,null from jsonb_array_elements(p_evaluation->'criteria') c
 on conflict(student_id,skill_name) do update set previous_score=student_skill_scores.current_score,current_score=excluded.current_score,updated_at=now();
 update public.submissions set status='reviewed' where id=p_submission_id and student_id=p_student_id;
 if p_session_id is not null then update public.simulation_sessions set status='completed',completed_at=now() where id=p_session_id and student_id=p_student_id; end if;
 return v_id;
end; $$;
revoke all on function public.persist_phase3_evaluation(uuid,uuid,uuid,uuid,uuid,jsonb,text,text,integer,integer) from public,anon,authenticated;
grant execute on function public.persist_phase3_evaluation(uuid,uuid,uuid,uuid,uuid,jsonb,text,text,integer,integer) to service_role;
