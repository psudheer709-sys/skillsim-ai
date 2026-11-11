import { NextResponse } from 'next/server';
import { z } from 'zod';
import { requireUser } from '@/lib/auth/require-user';
import { readJson, validationError } from '@/lib/api-http';
const schema = z.object({ invitationId: z.string().uuid() });
export async function GET() {
  const auth = await requireUser(['student']); if (auth.error) return auth.error;
  const { data, error } = await auth.user.supabase.from('class_invitations').select('id,email,created_at,class_id,educator_classes(class_name,description)').order('created_at', { ascending: false });
  if (error) return NextResponse.json({ error: 'Could not load class invitations.' }, { status: 500 });
  const invites = (data ?? []).filter((x: any) => x.email?.toLowerCase() === auth.user.email.toLowerCase());
  const { data: joined } = await auth.user.supabase.from('class_memberships').select('class_id').eq('student_id', auth.user.id);
  const joinedIds = new Set((joined ?? []).map(row => row.class_id));
  return NextResponse.json(invites.filter((row: any) => !joinedIds.has(row.class_id)), { headers: { 'Cache-Control': 'private, no-store' } });
}
export async function POST(request: Request) {
  const auth = await requireUser(['student']); if (auth.error) return auth.error;
  const parsed = schema.safeParse(await readJson(request)); if (!parsed.success) return validationError(parsed.error);
  const { data: invite, error: lookupError } = await auth.user.supabase.from('class_invitations').select('id,class_id,email').eq('id', parsed.data.invitationId).maybeSingle();
  if (lookupError || !invite || invite.email.toLowerCase() !== auth.user.email.toLowerCase()) return NextResponse.json({ error: 'This invitation is not available to your account.' }, { status: 404 });
  const { error } = await auth.user.supabase.from('class_memberships').upsert({ class_id: invite.class_id, student_id: auth.user.id }, { onConflict: 'class_id,student_id' });
  if (error) return NextResponse.json({ error: 'Could not accept this invitation.' }, { status: 400 });
  return NextResponse.json({ accepted: true });
}
