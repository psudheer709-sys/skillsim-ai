import { NextResponse } from 'next/server';
import { z } from 'zod';
import { requireUser } from '@/lib/auth/require-user';
import { readJson, validationError } from '@/lib/api-http';

const schema = z.object({ daily_reminders: z.boolean(), assignment_notifications: z.boolean(), milestone_notifications: z.boolean(), feedback_notifications: z.boolean(), announcement_notifications: z.boolean() });
const defaults = { daily_reminders: true, assignment_notifications: true, milestone_notifications: true, feedback_notifications: true, announcement_notifications: true };
export async function GET() {
  const auth = await requireUser(); if (auth.error) return auth.error;
  const { data, error } = await auth.user.supabase.from('notification_preferences').select('*').eq('user_id', auth.user.id).maybeSingle();
  if (error) return NextResponse.json({ error: 'Could not load notification preferences.' }, { status: 500 });
  return NextResponse.json(data ?? defaults, { headers: { 'Cache-Control': 'private, no-store' } });
}
export async function PUT(request: Request) {
  const auth = await requireUser(); if (auth.error) return auth.error;
  const parsed = schema.safeParse(await readJson(request)); if (!parsed.success) return validationError(parsed.error);
  const { data, error } = await auth.user.supabase.from('notification_preferences').upsert({ user_id: auth.user.id, ...parsed.data, updated_at: new Date().toISOString() }).select().single();
  if (error) return NextResponse.json({ error: 'Could not save notification preferences.' }, { status: 400 });
  return NextResponse.json(data, { headers: { 'Cache-Control': 'private, no-store' } });
}
