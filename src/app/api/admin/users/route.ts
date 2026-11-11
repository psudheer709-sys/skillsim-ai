import { NextResponse } from 'next/server';
import { requireUser } from '@/lib/auth/require-user';
import { createSupabaseAdminClient } from '@/lib/supabase/admin';

export async function GET(request: Request) {
  const auth = await requireUser(['administrator']);
  if (auth.error) return auth.error;
  const params = new URL(request.url).searchParams;
  const page = Math.max(1, Math.min(10000, Number(params.get('page')) || 1));
  const pageSize = Math.max(10, Math.min(100, Number(params.get('pageSize')) || 25));
  try {
    const { data, count, error } = await createSupabaseAdminClient().from('profiles')
      .select('id,full_name,email,role,account_status,created_at', { count: 'exact' })
      .order('created_at', { ascending: false }).range((page - 1) * pageSize, page * pageSize - 1);
    if (error) throw error;
    return NextResponse.json({ users: (data || []).map(user => ({ ...user, isCurrentAdmin: user.id === auth.user.id })), total: count || 0, page, pageSize }, { headers: { 'Cache-Control': 'private, no-store' } });
  } catch {
    return NextResponse.json({ error: 'Could not load platform users.' }, { status: 503 });
  }
}
