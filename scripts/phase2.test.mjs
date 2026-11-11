import test from 'node:test';
import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import { roadmaps } from '../src/lib/roadmaps.ts';
import { simulations } from '../src/lib/data.ts';
import { withStableDuplicateKeys } from '../src/lib/stable-list-keys.ts';
import { registerSchema, roadmapSelectionSchema, topicProgressSchema } from '../src/lib/validation.ts';
import { getSupabaseConfig, getSupabaseSetupMessage } from '../src/lib/supabase/config.ts';

test('seed catalog has stable roadmap, topic, and simulation data', () => {
  assert.equal(roadmaps.length, 9);
  assert.equal(roadmaps.reduce((n, r) => n + r.stages.reduce((m, s) => m + s.topics.length, 0), 0), 131);
  assert.equal(simulations.length, 12);
  assert.ok(roadmaps.every(r => r.stages.every(s => s.topics.length > 0)));
});

test('duplicate roadmap skill labels retain their values and receive unique stable keys', () => {
  const entries = withStableDuplicateKeys(['NumPy', 'Pandas', 'NumPy', 'Pandas'], 'ai-ml:skills');
  assert.deepEqual(entries.map(entry => entry.value), ['NumPy', 'Pandas', 'NumPy', 'Pandas']);
  assert.equal(new Set(entries.map(entry => entry.key)).size, entries.length);
});

test('roadmap activation API argument names match the database function', async () => {
  const route = await readFile(new URL('../src/app/api/roadmaps/selection/route.ts', import.meta.url), 'utf8');
  const migration = await readFile(new URL('../supabase/migrations/202611100001_phase2_core.sql', import.meta.url), 'utf8');
  const rpcArgs = route.match(/rpc\('select_primary_roadmap',\s*\{([\s\S]*?)\}\)/)?.[1];
  const functionArgs = migration.match(/create or replace function public\.select_primary_roadmap\(([\s\S]*?)\)\s*returns/)?.[1];
  assert.ok(rpcArgs);
  assert.ok(functionArgs);
  assert.deepEqual(
    [...rpcArgs.matchAll(/\b(p_[a-z_]+)\s*:/g)].map(match => match[1]),
    [...functionArgs.matchAll(/\b(p_[a-z_]+)\s+[a-z]+/g)].map(match => match[1]),
  );
});

test('registration validates strong passwords and does not accept admin role', () => {
  const base = { fullName:'Taylor Learner', email:'taylor@example.com', password:'SecurePass123!', confirmPassword:'SecurePass123!', collegeName:'Example College', course:'Computer Science', careerInterest:'Software development', accountType:'student' };
  assert.equal(registerSchema.safeParse(base).success, true);
  assert.equal(registerSchema.safeParse({...base, password:'simple',confirmPassword:'simple'}).success, false);
  assert.equal(registerSchema.safeParse({...base, accountType:'administrator'}).success, false);
});

test('roadmap and topic progress payloads enforce database identifiers and completion rules', () => {
  assert.equal(roadmapSelectionSchema.safeParse({roadmapId:'00000000-0000-4000-8000-000000000001',currentSkillLevel:'Beginner',dailyLearningTime:'1 hour',careerGoal:'Engineer'}).success,true);
  assert.equal(topicProgressSchema.safeParse({roadmapId:'00000000-0000-4000-8000-000000000001',topicId:'00000000-0000-4000-8000-000000000002',status:'completed',completionPercentage:70,learningTime:15}).success,false);
});

test('Supabase config prefers the publishable key and falls back to the legacy anon key', () => {
  const original = Object.fromEntries(['NEXT_PUBLIC_SUPABASE_URL','NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY','NEXT_PUBLIC_SUPABASE_ANON_KEY'].map(k => [k, process.env[k]]));
  try {
    process.env.NEXT_PUBLIC_SUPABASE_URL = 'https://example-project.supabase.co';
    process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY = 'sb_publishable_test_value';
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY = 'legacy_test_value';
    assert.equal(getSupabaseConfig()?.publicKey, 'sb_publishable_test_value');
    delete process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY;
    assert.equal(getSupabaseConfig()?.publicKey, 'legacy_test_value');
  } finally {
    for (const [key, value] of Object.entries(original)) value === undefined ? delete process.env[key] : process.env[key] = value;
  }
});

test('Supabase config rejects missing or placeholder credentials with the requested setup message', () => {
  const original = Object.fromEntries(['NEXT_PUBLIC_SUPABASE_URL','NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY','NEXT_PUBLIC_SUPABASE_ANON_KEY'].map(k => [k, process.env[k]]));
  try {
    delete process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY;
    delete process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;
    assert.equal(getSupabaseConfig(), null);
    process.env.NEXT_PUBLIC_SUPABASE_URL = 'your_project_url';
    process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY = 'your_publishable_key';
    assert.equal(getSupabaseConfig(), null);
    assert.equal(getSupabaseSetupMessage(), 'Supabase configuration is incomplete. Please configure your Project URL and Publishable Key in .env.local.');
  } finally {
    for (const [key, value] of Object.entries(original)) value === undefined ? delete process.env[key] : process.env[key] = value;
  }
});
