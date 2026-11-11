import { NextResponse } from 'next/server';
import { z } from 'zod';
import { requireUser } from '@/lib/auth/require-user';
import { readJson, validationError } from '@/lib/api-http';
const schema = z.object({ email: z.string().trim().email().max(320).transform(v => v.toLowerCase()) });
export async function POST(request: Request, context: { params: Promise<{ id: string }> }) {
  const auth = await requireUser(['educator']); if (auth.error) return auth.error;
  const { id } = await context.params;
  const parsed = schema.safeParse(await readJson(request)); if (!parsed.success) return validationError(parsed.error);
  const { data, error } = await auth.user.supabase.from('class_invitations').upsert({ class_id: id, email: parsed.data.email, invited_by: auth.user.id }, { onConflict: 'class_id,email' }).select('id,email,created_at').single();
  if (error) return NextResponse.json({ error: 'Could not invite this learner. Confirm that the class belongs to you.' }, { status: 400 });
  return NextResponse.json(data, { status: 201 });
}
