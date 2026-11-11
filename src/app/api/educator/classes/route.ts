import { NextResponse } from 'next/server';
import { z } from 'zod';
import { requireUser } from '@/lib/auth/require-user';
import { readJson, validationError } from '@/lib/api-http';

const schema = z.object({ className: z.string().trim().min(2).max(120), description: z.string().trim().max(1000).default('') });
export async function GET() {
  const auth = await requireUser(['educator', 'administrator']); if (auth.error) return auth.error;
  let query = auth.user.supabase.from('educator_classes').select('id,class_name,description,created_at,class_memberships(id,student_id,joined_at,profiles(id,full_name,email,course))').order('created_at', { ascending: false });
  if (auth.user.role !== 'administrator') query = query.eq('educator_id', auth.user.id);
  const { data, error } = await query;
  if (error) return NextResponse.json({ error: 'Could not load your classes.' }, { status: 500 });
  return NextResponse.json(data ?? [], { headers: { 'Cache-Control': 'private, no-store' } });
}
export async function POST(request: Request) {
  const auth = await requireUser(['educator']); if (auth.error) return auth.error;
  const parsed = schema.safeParse(await readJson(request)); if (!parsed.success) return validationError(parsed.error);
  const { data, error } = await auth.user.supabase.from('educator_classes').insert({ educator_id: auth.user.id, class_name: parsed.data.className, description: parsed.data.description }).select('id,class_name,description,created_at').single();
  if (error) return NextResponse.json({ error: 'Could not create the class.' }, { status: 400 });
  return NextResponse.json(data, { status: 201 });
}
