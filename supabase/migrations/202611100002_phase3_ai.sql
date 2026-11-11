-- SkillSim Phase 3. Adds private evaluation records and curated workplace scenarios.
create table if not exists public.simulation_scenarios (
  id uuid primary key default gen_random_uuid(),
  simulation_id uuid not null unique references public.simulations(id) on delete cascade,
  scenario_content jsonb not null default '{}'::jsonb check (jsonb_typeof(scenario_content)='object'),
  assessment_rubric jsonb not null default '{}'::jsonb check (jsonb_typeof(assessment_rubric)='object'),
  skills_assessed text[] not null default '{}',
  learning_objectives text[] not null default '{}',
  supported_modes text[] not null default '{text,technical,decision}',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

insert into public.simulations(title,category,description,difficulty,estimated_duration,is_active) values
('Client Meeting','Communication','Prepare and lead a client meeting after a delivery concern.','Intermediate',25,true),
('Handling Difficult Conversations','Communication','Address a sensitive performance concern respectfully and constructively.','Intermediate',20,true),
('Coding Problem Solving','Technical','Design and explain an approach to a practical programming challenge.','Intermediate',30,true),
('Software Debugging','Technical','Investigate a software defect from symptoms, logs and a reproduction.','Intermediate',25,true),
('Business Case Analysis','Business','Assess a proposal using evidence, costs, benefits and risks.','Intermediate',30,true),
('Resource Management','Business','Rebalance a project plan when capacity changes unexpectedly.','Intermediate',25,true),
('Team Collaboration','Professional','Coordinate responsibilities across a cross-functional team.','Beginner',20,true),
('Decision Making','Professional','Make and communicate a defensible decision with incomplete information.','Intermediate',25,true),
('HR Interview','Career and Interview','Answer a behavioral interview question using clear evidence.','Beginner',20,true),
('Technical Interview','Career and Interview','Explain a technical solution, trade-offs and complexity.','Intermediate',30,true),
('Group Discussion','Career and Interview','Contribute constructively to a time-boxed group discussion.','Intermediate',20,true),
('Resume Explanation','Career and Interview','Explain a project achievement and your specific contribution.','Beginner',15,true),
('Self Introduction','Career and Interview','Give a concise introduction tailored to a role.','Beginner',10,true)
on conflict(title) do nothing;

insert into public.simulation_scenarios(simulation_id,scenario_content,assessment_rubric,skills_assessed,learning_objectives,supported_modes)
select s.id,
jsonb_build_object('assigned_role',case s.category when 'Communication' then 'Customer-facing team member' when 'Technical' then 'Software engineer' when 'Business' then 'Project analyst' when 'Career and Interview' then 'Candidate' else 'Team member' end,
'workplace_context',s.description,
'task_instructions',case s.title
 when 'Customer Complaint Handling' then 'A customer says a recent product update broke an essential workflow. A deadline is approaching. Write a response that acknowledges the impact, asks only necessary clarifying questions, offers immediate safe next steps, and sets a realistic follow-up time.'
 when 'Professional Email Writing' then 'A cross-functional partner has not sent a dependency your team needs by tomorrow. Draft a concise, respectful email that explains impact, makes a clear request, and offers a way to unblock the work.'
 when 'Python Debugging' then 'A Python data import function skips records when an optional field is empty. Explain how you would reproduce and isolate the bug, describe a safe fix, and propose tests. Submit code as text; it will not be executed.'
 when 'Spreadsheet Analysis' then 'A manager needs a decision from a spreadsheet containing regional sales, returns, and targets. Explain the checks and analysis you would perform before recommending an action.'
 when 'Technical Problem Solving' then 'A service latency alert coincides with a deployment. Explain how you would scope impact, investigate evidence, reduce user harm, and communicate a rollback or recovery decision.'
 when 'Project Planning' then 'A project has a fixed launch date, one team member unavailable, and an at-risk integration. Propose a realistic plan, owners, dependencies, and contingency.'
 when 'Business Decision Making' then 'Choose between two product requests with limited capacity. Explain the evidence you need, decision criteria, trade-offs, and how you will communicate the decision.'
 when 'Task Prioritisation' then 'Three requests arrive at once: a production issue, a leadership update due today, and a routine report. State your order, explain the impact-based reasoning, and communicate expectations.'
 when 'Time Management' then 'Two high-priority deliverables conflict this afternoon. Explain how you will clarify deadlines, break down work, negotiate scope, and keep stakeholders informed.'
 when 'Leadership' then 'A team has missed two milestones and morale is falling. Describe how you will learn what is blocking progress, agree on support and accountability, and reset the plan.'
 when 'Workplace Conflict Resolution' then 'Two teammates disagree publicly about ownership of a task. Describe how you will lower tension, understand both views, and agree on a practical next step.'
 when 'Team Communication' then 'Your team will miss a dependency unless another group responds today. Draft a concise update that gives context, impact, a specific ask, and a fallback.'
 when 'Client Meeting' then 'A client is concerned about a delayed deliverable. Prepare an opening, focused questions, options with trade-offs, and a clear follow-up commitment.'
 when 'Handling Difficult Conversations' then 'A colleague repeatedly interrupts handoffs, causing missed details. Plan a private conversation using specific observations, impact, curiosity, and an agreed follow-up.'
 when 'Coding Problem Solving' then 'Given a list of event timestamps, explain a clear algorithm to find the longest contiguous interval without duplicate events. Include edge cases and complexity; code is evaluated as text and never executed.'
 when 'Software Debugging' then 'A service returns intermittent 500 errors only after a recent release. Outline a reproducible, evidence-led investigation and a safe mitigation.'
 when 'Business Case Analysis' then 'A proposed workflow tool costs time to adopt but may reduce manual processing. Identify the evidence, costs, benefits, risks and decision threshold you would use.'
 when 'Resource Management' then 'A project loses 20% of its planned engineering capacity mid-sprint. Reassess commitments, communicate scope options, and protect the highest-value outcome.'
 when 'Team Collaboration' then 'A design, engineering and operations team must coordinate a launch. Propose responsibilities, handoffs, a shared checkpoint, and how blockers are raised.'
 when 'Decision Making' then 'A customer-impacting decision is needed before all data is available. State what is known, assumptions, reversible action, risks, and review trigger.'
 when 'HR Interview' then 'Answer: “Tell me about a time you handled a setback.” Use a specific example, your actions, outcome, and learning without disclosing confidential information.'
 when 'Technical Interview' then 'Explain an approach to detect a duplicate in a large list, including correctness, complexity, memory trade-offs, and test cases.'
 when 'Group Discussion' then 'Your group has five minutes to recommend one of three improvements to a campus service. Show how you contribute, invite others, and move toward a reasoned conclusion.'
 when 'Resume Explanation' then 'Choose one project achievement and explain the problem, your individual contribution, a measurable result, and what you would improve.'
 when 'Self Introduction' then 'Give a concise introduction for an entry-level role, connecting your relevant learning, one concrete project, and the contribution you hope to make.'
 else s.description end,
'expected_deliverables',jsonb_build_array('A direct response to the task','Reasoning grounded in the scenario','Concrete next steps'),
'time_guidance',s.estimated_duration||' minutes'),
jsonb_build_object('criteria',case s.category
 when 'Communication' then jsonb_build_array('Clarity','Professionalism','Empathy','Communication','Problem resolution')
 when 'Technical' then jsonb_build_array('Correctness','Logical reasoning','Code quality','Efficiency','Problem-solving approach')
 when 'Business' then jsonb_build_array('Decision quality','Analytical thinking','Prioritisation','Practical feasibility','Risk awareness')
 when 'Career and Interview' then jsonb_build_array('Clarity','Professionalism','Evidence and examples','Relevance','Confidence')
 else jsonb_build_array('Leadership','Teamwork','Time management','Critical thinking','Workplace behaviour') end),
case s.category when 'Communication' then array['Clarity','Empathy','Professional tone','Resolution'] when 'Technical' then array['Correctness','Reasoning','Problem solving','Code quality'] when 'Business' then array['Analysis','Decision making','Prioritisation','Risk awareness'] when 'Career and Interview' then array['Communication','Evidence','Role alignment'] else array['Leadership','Teamwork','Planning','Critical thinking'] end,
array['Analyse the scenario before responding','Communicate a clear and actionable next step','Reflect on evidence-based feedback'],
 case s.category when 'Communication' then array['text','conversation'] when 'Technical' then array['text','technical'] when 'Business' then array['text','decision'] else array['text','conversation','decision'] end
from public.simulations s where s.is_active=true
on conflict(simulation_id) do update set scenario_content=excluded.scenario_content,assessment_rubric=excluded.assessment_rubric,skills_assessed=excluded.skills_assessed,learning_objectives=excluded.learning_objectives,supported_modes=excluded.supported_modes,updated_at=now();

create table if not exists public.simulation_sessions (
 id uuid primary key default gen_random_uuid(), student_id uuid not null references public.profiles(id) on delete cascade,
 scenario_id uuid not null references public.simulation_scenarios(id) on delete cascade,
 interaction_mode text not null check(interaction_mode in ('text','conversation','technical','decision')),
 status text not null default 'in_progress' check(status in ('in_progress','completed','abandoned')),
 started_at timestamptz not null default now(), completed_at timestamptz
);
create index if not exists simulation_sessions_student_started_idx on public.simulation_sessions(student_id,started_at desc);
create table if not exists public.simulation_messages (
 id uuid primary key default gen_random_uuid(), session_id uuid not null references public.simulation_sessions(id) on delete cascade,
 sender_type text not null check(sender_type in ('student','ai')), message_content text not null check(char_length(message_content) between 1 and 5000),
 client_message_id uuid, created_at timestamptz not null default now(), unique(session_id,client_message_id,sender_type)
);
create index if not exists simulation_messages_session_created_idx on public.simulation_messages(session_id,created_at);

create table if not exists public.ai_evaluations (
 id uuid primary key default gen_random_uuid(), student_id uuid not null references public.profiles(id) on delete cascade,
 simulation_id uuid not null references public.simulations(id) on delete restrict,
 scenario_id uuid not null references public.simulation_scenarios(id) on delete restrict,
 session_id uuid references public.simulation_sessions(id) on delete set null,
 submission_id uuid unique references public.submissions(id) on delete cascade,
 overall_score integer check(overall_score between 0 and 100), criteria_scores jsonb not null default '[]'::jsonb check(jsonb_typeof(criteria_scores)='array'),
 strengths text[] not null default '{}', weaknesses text[] not null default '{}', improvements text[] not null default '{}', mistakes jsonb not null default '[]'::jsonb check(jsonb_typeof(mistakes)='array'),
 model_answer text, next_practice text, evaluation_status text not null default 'pending' check(evaluation_status in ('pending','completed','failed')),
 provider text, model text, input_tokens integer, output_tokens integer, error_code text,
 created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create index if not exists ai_evaluations_student_created_idx on public.ai_evaluations(student_id,created_at desc);
create index if not exists ai_evaluations_simulation_idx on public.ai_evaluations(simulation_id);
create table if not exists public.student_mistakes (
 id uuid primary key default gen_random_uuid(), student_id uuid not null references public.profiles(id) on delete cascade,
 evaluation_id uuid not null references public.ai_evaluations(id) on delete cascade,
 simulation_id uuid not null references public.simulations(id) on delete restrict,
 category text not null check(category in ('Missing Requirements','Weak Explanation','Incorrect Assumptions','Poor Prioritisation','Coding Errors','Logical Reasoning Errors','Communication Problems','Incomplete Solutions','Time Management Issues','Weak Problem Analysis')),
 description text not null check(char_length(description) between 1 and 600), severity text not null check(severity in ('low','medium','high')), created_at timestamptz not null default now(), unique(evaluation_id,category,description)
);
create index if not exists student_mistakes_student_created_idx on public.student_mistakes(student_id,created_at desc);
create table if not exists public.student_skill_scores (
 id uuid primary key default gen_random_uuid(), student_id uuid not null references public.profiles(id) on delete cascade,
 skill_name text not null, current_score integer not null check(current_score between 0 and 100), previous_score integer check(previous_score between 0 and 100), updated_at timestamptz not null default now(), unique(student_id,skill_name)
);
create table if not exists public.ai_recommendations (
 id uuid primary key default gen_random_uuid(), student_id uuid not null references public.profiles(id) on delete cascade,
 recommendation_type text not null, title text not null, description text not null,
 related_roadmap_id uuid references public.roadmaps(id) on delete set null, related_simulation_id uuid references public.simulations(id) on delete set null,
 status text not null default 'active' check(status in ('active','completed','dismissed')), created_at timestamptz not null default now()
);
create index if not exists ai_recommendations_student_created_idx on public.ai_recommendations(student_id,created_at desc);
create table if not exists public.ai_usage_logs (
 id uuid primary key default gen_random_uuid(), student_id uuid not null references public.profiles(id) on delete cascade,
 request_type text not null, provider text not null, model text not null, input_tokens integer, output_tokens integer,
 status text not null check(status in ('succeeded','failed')), error_code text, created_at timestamptz not null default now()
);
create index if not exists ai_usage_logs_student_created_idx on public.ai_usage_logs(student_id,created_at desc);
alter table public.submissions add column if not exists client_request_id uuid;
create unique index if not exists submissions_student_request_id_unique on public.submissions(student_id,client_request_id) where client_request_id is not null;

alter table public.simulation_scenarios enable row level security;
alter table public.simulation_sessions enable row level security;
alter table public.simulation_messages enable row level security;
alter table public.ai_evaluations enable row level security;
alter table public.student_mistakes enable row level security;
alter table public.student_skill_scores enable row level security;
alter table public.ai_recommendations enable row level security;
alter table public.ai_usage_logs enable row level security;
drop policy if exists "Active scenario details are visible to signed-in users" on public.simulation_scenarios;
create policy "Active scenario details are visible to signed-in users" on public.simulation_scenarios for select to authenticated using (exists(select 1 from public.simulations s where s.id=simulation_id and s.is_active));
drop policy if exists "Students manage their own sessions" on public.simulation_sessions;
create policy "Students manage their own sessions" on public.simulation_sessions for all to authenticated using(student_id=auth.uid()) with check(student_id=auth.uid());
drop policy if exists "Students read messages from their sessions" on public.simulation_messages;
create policy "Students read messages from their sessions" on public.simulation_messages for select to authenticated using(exists(select 1 from public.simulation_sessions x where x.id=session_id and x.student_id=auth.uid()));
drop policy if exists "Students append their own messages" on public.simulation_messages;
create policy "Students append their own messages" on public.simulation_messages for insert to authenticated with check(sender_type='student' and exists(select 1 from public.simulation_sessions x where x.id=session_id and x.student_id=auth.uid()));
drop policy if exists "Students read their evaluations" on public.ai_evaluations;
create policy "Students read their evaluations" on public.ai_evaluations for select to authenticated using(student_id=auth.uid());
drop policy if exists "Students read their mistakes" on public.student_mistakes;
create policy "Students read their mistakes" on public.student_mistakes for select to authenticated using(student_id=auth.uid());
drop policy if exists "Students read their skill scores" on public.student_skill_scores;
create policy "Students read their skill scores" on public.student_skill_scores for select to authenticated using(student_id=auth.uid());
drop policy if exists "Students read their recommendations" on public.ai_recommendations;
create policy "Students read their recommendations" on public.ai_recommendations for select to authenticated using(student_id=auth.uid());
revoke all on public.ai_usage_logs from anon, authenticated;
grant select on public.simulation_scenarios to authenticated;
grant select,insert,update on public.simulation_sessions to authenticated;
grant select,insert on public.simulation_messages to authenticated;
grant select on public.ai_evaluations,public.student_mistakes,public.student_skill_scores,public.ai_recommendations to authenticated;
grant all on public.simulation_scenarios,public.simulation_sessions,public.simulation_messages,public.ai_evaluations,public.student_mistakes,public.student_skill_scores,public.ai_recommendations,public.ai_usage_logs to service_role;

-- Atomic, server-only persistence. Invoker rights ensure service_role's RLS bypass is used.
create or replace function public.persist_phase3_evaluation(
 p_student_id uuid,p_submission_id uuid,p_simulation_id uuid,p_scenario_id uuid,
 p_evaluation jsonb,p_provider text,p_model text,p_input_tokens integer,p_output_tokens integer
) returns uuid language plpgsql set search_path=public as $$
declare v_id uuid;
begin
 select id into v_id from public.ai_evaluations where submission_id=p_submission_id;
 if v_id is not null then return v_id; end if;
 insert into public.ai_evaluations(student_id,submission_id,simulation_id,scenario_id,overall_score,criteria_scores,strengths,weaknesses,improvements,mistakes,model_answer,next_practice,evaluation_status,provider,model,input_tokens,output_tokens)
 values(p_student_id,p_submission_id,p_simulation_id,p_scenario_id,(p_evaluation->>'overall_score')::integer,p_evaluation->'criteria',array(select jsonb_array_elements_text(p_evaluation->'strengths')),array(select jsonb_array_elements_text(p_evaluation->'weaknesses')),array(select jsonb_array_elements_text(p_evaluation->'improvements')),p_evaluation->'mistakes',p_evaluation->>'model_answer',p_evaluation->>'next_practice','completed',p_provider,p_model,p_input_tokens,p_output_tokens)
 on conflict(submission_id) do nothing returning id into v_id;
 if v_id is null then select id into v_id from public.ai_evaluations where submission_id=p_submission_id; return v_id; end if;
 insert into public.student_mistakes(student_id,evaluation_id,simulation_id,category,description,severity)
 select p_student_id,v_id,p_simulation_id,m->>'category',m->>'description',m->>'severity' from jsonb_array_elements(p_evaluation->'mistakes') m
 on conflict(evaluation_id,category,description) do nothing;
 insert into public.student_skill_scores(student_id,skill_name,current_score,previous_score)
 select p_student_id,c->>'name',(c->>'score')::integer,null from jsonb_array_elements(p_evaluation->'criteria') c
 on conflict(student_id,skill_name) do update set previous_score=student_skill_scores.current_score,current_score=excluded.current_score,updated_at=now();
 update public.submissions set status='reviewed' where id=p_submission_id and student_id=p_student_id;
 return v_id;
end; $$;
revoke all on function public.persist_phase3_evaluation(uuid,uuid,uuid,uuid,jsonb,text,text,integer,integer) from public,anon,authenticated;
grant execute on function public.persist_phase3_evaluation(uuid,uuid,uuid,uuid,jsonb,text,text,integer,integer) to service_role;
