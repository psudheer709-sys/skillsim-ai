import { NextResponse } from 'next/server';
import { requireUser } from '@/lib/auth/require-user';

export async function GET() {
  const auth = await requireUser(['student']);
  if (auth.error) return auth.error;
  const { data, error } = await auth.user.supabase.from('achievements')
    .select('id,achievement_name,description,earned_at')
    .eq('student_id', auth.user.id).order('earned_at', { ascending: false });
  if (error) return NextResponse.json({ error: 'Could not load verified achievements.' }, { status: 500 });
  return NextResponse.json(data ?? [], { headers: { 'Cache-Control': 'private, no-store' } });
}
