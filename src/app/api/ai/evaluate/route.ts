import { NextResponse } from 'next/server';
import { z } from 'zod';
import { requireUser } from '@/lib/auth/require-user';
import { readJson, apiError } from '@/lib/api-http';
import { rateLimit } from '@/lib/security/rate-limit';
import { evaluateSubmission } from '@/lib/ai/evaluation-engine';
import { getAiConfig } from '@/lib/ai/config';
import { createSupabaseAdminClient } from '@/lib/supabase/admin';

const bodySchema=z.object({submissionId:z.string().uuid(),sessionId:z.string().uuid().optional()});
export async function POST(request:Request){
 const auth=await requireUser(['student']);if(auth.error)return auth.error;
 const parsed=bodySchema.safeParse(await readJson(request));if(!parsed.success)return apiError(400,'A valid submissionId is required.');
 const limit=rateLimit(`evaluate:${auth.user.id}`,5);if(!limit.allowed)return NextResponse.json({error:'Evaluation rate limit reached. Please try again later.'},{status:429,headers:{'Retry-After':String(limit.retryAfter)}});
 const {data:submission,error:submissionError}=await auth.user.supabase.from('submissions').select('id,simulation_id,submission_content,created_at,simulations!inner(id,title,category,description)').eq('id',parsed.data.submissionId).eq('student_id',auth.user.id).maybeSingle();
 if(submissionError||!submission)return apiError(404,'Submission not found.');
 const sim=(submission as any).simulations;
 const {data:scenario,error:scenarioError}=await auth.user.supabase.from('simulation_scenarios').select('id,scenario_content,assessment_rubric').eq('simulation_id',sim.id).maybeSingle();
 if(scenarioError||!scenario)return apiError(503,'This simulation scenario is not available for evaluation.');
 if(parsed.data.sessionId){const{data:session}=await auth.user.supabase.from('simulation_sessions').select('id,scenario_id,interaction_mode').eq('id',parsed.data.sessionId).eq('student_id',auth.user.id).maybeSingle();if(!session||session.scenario_id!==scenario.id||session.interaction_mode!=='conversation')return apiError(403,'This conversation session does not belong to this submission.');}
 const {data:existing}=await auth.user.supabase.from('ai_evaluations').select('*').eq('submission_id',submission.id).eq('student_id',auth.user.id).maybeSingle();
 if(existing?.evaluation_status==='completed')return NextResponse.json(existing);
 const config=getAiConfig();
 const supaConfig=(await import('@/lib/supabase/config')).getSupabaseConfig();
 if(!config.configured||!supaConfig?.serviceRoleKey)return apiError(503,'AI evaluation needs server configuration: OPENAI_API_KEY, AI_MODEL, and SUPABASE_SERVICE_ROLE_KEY.');
 try{
  const content=scenario.scenario_content as Record<string,unknown>;
  const result=await evaluateSubmission({title:sim.title,category:sim.category,description:sim.description,scenario:String(content.workplace_context||''),role:String(content.assigned_role||''),task:String(content.task_instructions||''),rubric:scenario.assessment_rubric,response:submission.submission_content});
  const evaluation={...result.evaluation};
  const admin=createSupabaseAdminClient();
  const {data:evaluationId,error}=await admin.rpc('persist_phase3_evaluation',{p_student_id:auth.user.id,p_submission_id:submission.id,p_simulation_id:sim.id,p_scenario_id:scenario.id,p_session_id:parsed.data.sessionId||null,p_evaluation:evaluation,p_provider:config.provider,p_model:result.model,p_input_tokens:result.usage.input_tokens,p_output_tokens:result.usage.output_tokens});
  await admin.from('ai_usage_logs').insert({student_id:auth.user.id,request_type:'evaluation',provider:config.provider,model:result.model,input_tokens:result.usage.input_tokens,output_tokens:result.usage.output_tokens,status:error?'failed':'succeeded',error_code:error?.code||null});
  if(error||!evaluationId)return apiError(500,'Evaluation was generated but could not be saved. Please retry.');
  const {data:saved}=await auth.user.supabase.from('ai_evaluations').select('*').eq('id',evaluationId).eq('student_id',auth.user.id).single();
  return NextResponse.json(saved||{id:evaluationId,...evaluation,evaluation_status:'completed'});
 }catch(error){
  const code=error instanceof Error?error.message:'AI_PROVIDER_UNAVAILABLE';
  const messages:Record<string,[number,string]>={AI_NOT_CONFIGURED:[503,'AI evaluation is not configured. Set OPENAI_API_KEY and AI_MODEL in the server environment.'],AI_RATE_LIMIT:[429,'The AI provider rate limit was reached. Please try again shortly.'],AI_PROVIDER_AUTH:[502,'The AI provider rejected its server credentials. Check OPENAI_API_KEY.'],AI_PROVIDER_UNAVAILABLE:[502,'The AI provider is temporarily unavailable. Please retry shortly.'],AI_REQUEST_REJECTED:[502,'The AI provider could not process this evaluation.'],AI_TIMEOUT:[504,'Evaluation timed out. Please retry.'],AI_INVALID_RESPONSE:[502,'The AI response failed validation. No evaluation was saved.']};
  const [status,message]=messages[code]||[502,'Evaluation failed safely. Please retry later.'];
  if(supaConfig?.serviceRoleKey){const admin=createSupabaseAdminClient();await admin.from('ai_usage_logs').insert({student_id:auth.user.id,request_type:'evaluation',provider:config.provider,model:config.model||'unconfigured',status:'failed',error_code:code.slice(0,60)});}
  return apiError(status,message);
 }
}
