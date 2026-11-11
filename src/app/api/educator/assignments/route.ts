import { NextResponse } from 'next/server';
import { z } from 'zod';
import { requireUser } from '@/lib/auth/require-user';
import { readJson, validationError } from '@/lib/api-http';
const schema = z.object({ classId: z.string().uuid(), title: z.string().trim().min(3).max(160), instructions: z.string().trim().max(5000).default(''), dueAt: z.string().datetime().nullable().default(null), roadmapId: z.string().uuid().nullable().default(null) });
export async function GET() {
  const auth = await requireUser(['educator', 'administrator']); if (auth.error) return auth.error;
  const { data, error } = await auth.user.supabase.from('educator_assignments').select('id,class_id,title,instructions,due_at,created_at,educator_classes(class_name),assignment_submissions(id,student_id,status,submitted_at,profiles(full_name,email))').order('created_at', { ascending: false });
  if (error) return NextResponse.json({ error: 'Could not load assignments.' }, { status: 500 });
  return NextResponse.json(data ?? [], { headers: { 'Cache-Control': 'private, no-store' } });
}
export async function POST(request: Request) {
  const auth = await requireUser(['educator']); if (auth.error) return auth.error;
  const parsed = schema.safeParse(await readJson(request)); if (!parsed.success) return validationError(parsed.error);
  const { data, error } = await auth.user.supabase.from('educator_assignments').insert({ class_id: parsed.data.classId, educator_id: auth.user.id, title: parsed.data.title, instructions: parsed.data.instructions, due_at: parsed.data.dueAt, roadmap_id: parsed.data.roadmapId }).select('id,title,due_at,created_at').single();
  if (error) return NextResponse.json({ error: 'Could not create the assignment for that class.' }, { status: 400 });
  return NextResponse.json(data, { status: 201 });
}
