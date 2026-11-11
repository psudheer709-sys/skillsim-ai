import { NextResponse } from 'next/server';
import { z } from 'zod';
import { requireUser } from '@/lib/auth/require-user';
import { readJson, validationError } from '@/lib/api-http';
const schema = z.object({ classId: z.string().uuid(), title: z.string().trim().min(3).max(160), message: z.string().trim().min(1).max(3000) });
export async function POST(request: Request) {
  const auth = await requireUser(['educator']); if (auth.error) return auth.error;
  const parsed = schema.safeParse(await readJson(request)); if (!parsed.success) return validationError(parsed.error);
  const { data, error } = await auth.user.supabase.from('educator_announcements').insert({ class_id: parsed.data.classId, educator_id: auth.user.id, title: parsed.data.title, message: parsed.data.message }).select('id,title,message,created_at').single();
  if (error) return NextResponse.json({ error: 'Could not post this class announcement.' }, { status: 400 });
  return NextResponse.json(data, { status: 201 });
}
