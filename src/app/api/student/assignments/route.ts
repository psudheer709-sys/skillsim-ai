import { NextResponse } from 'next/server';
import { z } from 'zod';
import { requireUser } from '@/lib/auth/require-user';
import { readJson, validationError } from '@/lib/api-http';
const schema = z.object({ assignmentId: z.string().uuid(), response: z.string().trim().min(1).max(12000) });
export async function GET() {
  const auth = await requireUser(['student']); if (auth.error) return auth.error;
  const { data, error } = await auth.user.supabase.from('educator_assignments').select('id,class_id,title,instructions,due_at,created_at,educator_classes(class_name),assignment_submissions(id,response,status,submitted_at)').order('created_at', { ascending: false });
  if (error) return NextResponse.json({ error: 'Could not load class assignments.' }, { status: 500 });
  return NextResponse.json(data ?? [], { headers: { 'Cache-Control': 'private, no-store' } });
}
export async function POST(request: Request) {
  const auth = await requireUser(['student']); if (auth.error) return auth.error;
  const parsed = schema.safeParse(await readJson(request)); if (!parsed.success) return validationError(parsed.error);
  const { data, error } = await auth.user.supabase.from('assignment_submissions').upsert({ assignment_id: parsed.data.assignmentId, student_id: auth.user.id, response: parsed.data.response, status: 'submitted', submitted_at: new Date().toISOString() }, { onConflict: 'assignment_id,student_id' }).select('id,status,submitted_at').single();
  if (error) return NextResponse.json({ error: 'Could not submit the assignment. Confirm that you joined its class.' }, { status: 400 });
  return NextResponse.json(data, { status: 201 });
}
