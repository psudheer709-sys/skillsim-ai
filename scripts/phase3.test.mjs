import test from 'node:test';
import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import { evaluationSchema } from '../src/lib/ai/response-validator.ts';

test('AI evaluation schema accepts valid feedback and bounds scores', () => {
  const result=evaluationSchema.safeParse({criteria:[{name:'Clarity',score:75,feedback:'Clear response.'},{name:'Professionalism',score:75,feedback:'Appropriate tone.'},{name:'Empathy',score:80,feedback:'Acknowledges impact.'},{name:'Communication',score:75,feedback:'Direct language.'},{name:'Problem resolution',score:50,feedback:'Needs a follow-up.'}],strengths:['Clear tone'],weaknesses:['No timeline'],mistakes:[{category:'Missing Requirements',description:'No resolution timeline was provided.',severity:'medium'}],improvements:['Provide an expected update time.'],model_answer:'Thank you for explaining the issue...',next_practice:'Escalation handling'});
  assert.equal(result.success,true);
  const invalid=evaluationSchema.safeParse({criteria:[{name:'Clarity',score:110,feedback:'x'}],strengths:[],weaknesses:[],mistakes:[],improvements:['x'],model_answer:'x',next_practice:'x'});
  assert.equal(invalid.success,false);
});

test('evaluation route is authenticated, student scoped, and uses server-only AI config', async () => {
  const route=await readFile(new URL('../src/app/api/ai/evaluate/route.ts',import.meta.url),'utf8');
  const engine=await readFile(new URL('../src/lib/ai/evaluation-engine.ts',import.meta.url),'utf8');
  assert.match(route,/requireUser\(\['student'\]\)/);
  assert.match(route,/eq\('student_id',auth\.user\.id\)/);
  assert.match(route,/rateLimit\(/);
  assert.match(engine,/import 'server-only'/);
  assert.match(engine,/store:false/);
  assert.doesNotMatch(engine,/NEXT_PUBLIC_OPENAI_API_KEY/);
});

test('Phase 3 migration enables RLS and prevents duplicate evaluation writes', async () => {
  const sql=await readFile(new URL('../supabase/migrations/202611100002_phase3_ai.sql',import.meta.url),'utf8');
  for(const table of ['simulation_scenarios','simulation_sessions','simulation_messages','ai_evaluations','student_mistakes','student_skill_scores','ai_recommendations','ai_usage_logs'])assert.match(sql,new RegExp(`alter table public\\.${table} enable row level security`));
  assert.match(sql,/unique\(evaluation_id,category,description\)/);
  assert.match(sql,/submission_id uuid unique/);
  assert.match(sql,/revoke all on function public\.persist_phase3_evaluation[\s\S]*from public,anon,authenticated/);
  assert.doesNotMatch(sql,/security definer/i);
});

test('AI setup uses explicit model selection and never leaks server credentials to client config', async () => {
  const example=await readFile(new URL('../.env.example',import.meta.url),'utf8');
  const aiConfig=await readFile(new URL('../src/lib/ai/config.ts',import.meta.url),'utf8');
  assert.match(example,/^OPENAI_API_KEY=$/m);
  assert.match(example,/^AI_MODEL=$/m);
  assert.match(example,/^AI_PROVIDER=openai$/m);
  assert.match(aiConfig,/process\.env\.AI_MODEL/);
  assert.match(aiConfig,/provider === 'openai'/);
});

test('Phase 3 pages use stored records rather than sample score arrays', async () => {
  const views=await readFile(new URL('../src/components/phase3-views.tsx',import.meta.url),'utf8');
  assert.match(views,/fetch\(`\/api\/ai\/mistake-dna\?period=/);
  assert.match(views,/fetch\('\/api\/ai\/recommendations'/);
  assert.match(views,/fetch\('\/api\/submissions'/);
  assert.match(views,/No mistakes recorded yet/);
  assert.ok(/no completed AI evaluations yet/i.test(views));
});
