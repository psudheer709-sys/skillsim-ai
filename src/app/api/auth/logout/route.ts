import { NextResponse } from 'next/server';
import { createSupabaseServerClient } from '@/lib/supabase/server';
export async function POST() { try { const client = await createSupabaseServerClient(); await client.auth.signOut(); } catch { /* Local session may already be absent. */ } return NextResponse.json({ ok: true }); }
