import { NextResponse } from 'next/server';
import { requireUser } from '@/lib/auth/require-user';
import { readJson, validationError } from '@/lib/api-http';
import { planCreateSchema } from '@/lib/validation';

export async function GET(request: Request) {
  const auth = await requireUser(['student']); if (auth.error) return auth.error;
  const roadmapId = new URL(request.url).searchParams.get('roadmapId');
  let query = auth.user.supabase.from('weekly_learning_plans').select('*, weekly_learning_tasks(*)').eq('student_id', auth.user.id).order('week_start_date', { ascending: false });
  if (roadmapId) query = query.eq('roadmap_id', roadmapId);
  const { data, error } = await query.limit(1).maybeSingle();
  return error ? Response.json({ error: 'Could not load learning plan.' }, { status: 500 }) : NextResponse.json(data);
}

export async function POST(request: Request) {
  const auth = await requireUser(['student']); if (auth.error) return auth.error;
  const parsed = planCreateSchema.safeParse(await readJson(request)); if (!parsed.success) return validationError(parsed.error);
  const p = parsed.data, db = auth.user.supabase;
  const [{ data: roadmap }, { data: progress }, { data: topics }, { data: prefs }] = await Promise.all([
    db.from('roadmaps').select('id').eq('id', p.roadmapId).maybeSingle(),
    db.from('topic_progress').select('topic_id,status').eq('student_id', auth.user.id).eq('roadmap_id', p.roadmapId),
    db.from('roadmap_topics').select('id,topic_title,topic_order').eq('roadmap_id', p.roadmapId).order('topic_order'),
    db.from('student_preferences').select('daily_learning_time').eq('student_id', auth.user.id).maybeSingle(),
  ]);
  if (!roadmap) return Response.json({ error: 'Roadmap not found.' }, { status: 404 });
  const complete = new Set((progress || []).filter(x => x.status === 'completed').map(x => x.topic_id));
  const minutes = prefs?.daily_learning_time === '30 minutes' ? 30 : prefs?.daily_learning_time === '2 hours' ? 120 : prefs?.daily_learning_time === '3 hours or more' ? 180 : 60;
  const targetMinutes = minutes * p.weeklyTargetDays;
  const { data: plan, error } = await db.from('weekly_learning_plans').upsert({ student_id: auth.user.id, roadmap_id: p.roadmapId, week_start_date: p.weekStartDate, weekly_target_minutes: targetMinutes, plan_data: { weeklyTargetDays: p.weeklyTargetDays } }, { onConflict: 'student_id,roadmap_id,week_start_date' }).select('*').single();
  if (error) return Response.json({ error: 'Could not create learning plan.' }, { status: 400 });
  const pending = (topics || []).filter(t => !complete.has(t.id)).slice(0, p.weeklyTargetDays);
  const rows = pending.map((t, i) => { const day = new Date(`${p.weekStartDate}T12:00:00`); day.setDate(day.getDate() + Math.floor(i * 7 / p.weeklyTargetDays)); return { plan_id: plan.id, student_id: auth.user.id, topic_id: t.id, task_title: t.topic_title, scheduled_date: day.toISOString().slice(0, 10), estimated_minutes: minutes }; });
  if (rows.length) { const { error: taskError } = await db.from('weekly_learning_tasks').upsert(rows, { onConflict: 'plan_id,scheduled_date,topic_id' }); if (taskError) return Response.json({ error: 'Plan created but tasks could not be saved.' }, { status: 500 }); }
  const { data: tasks } = await db.from('weekly_learning_tasks').select('*').eq('plan_id', plan.id).order('scheduled_date');
  return NextResponse.json({ ...plan, tasks: tasks || [] }, { status: 201 });
}
