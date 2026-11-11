import { NextResponse } from 'next/server';
import { getSupabaseConfig, getSupabaseSetupMessage } from '@/lib/supabase/config';
export async function GET() {
  const configured = Boolean(getSupabaseConfig());
  return NextResponse.json({ configured, ...(!configured ? { message: getSupabaseSetupMessage() } : {}) }, { headers: { 'Cache-Control': 'no-store' } });
}
