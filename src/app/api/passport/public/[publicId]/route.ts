import { createClient } from '@supabase/supabase-js';
import { NextResponse } from 'next/server';
import { getSupabaseConfig } from '@/lib/supabase/config';

export async function GET(_request: Request, { params }: { params: Promise<{ publicId: string }> }) {
  const { publicId } = await params;
  if (!/^[0-9a-f-]{36}$/i.test(publicId)) return NextResponse.json({ error: 'Passport not found.' }, { status: 404 });
  const config = getSupabaseConfig();
  if (!config) return NextResponse.json({ error: 'Public Skill Passport is unavailable.' }, { status: 503 });
  const publicClient = createClient(config.url, config.publicKey, { auth: { autoRefreshToken: false, persistSession: false, detectSessionInUrl: false } });
  const { data, error } = await publicClient.from('public_skill_passports').select('snapshot,updated_at').eq('public_id', publicId).eq('is_public', true).maybeSingle();
  if (error || !data) return NextResponse.json({ error: 'This Skill Passport is private or the link is invalid.' }, { status: 404 });
  return NextResponse.json({ snapshot: data.snapshot, updatedAt: data.updated_at }, { headers: { 'Cache-Control': 'public, max-age=60, stale-while-revalidate=300' } });
}
