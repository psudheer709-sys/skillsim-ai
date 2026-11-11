import { requireUser } from '@/lib/auth/require-user';
import { getAiConfig } from '@/lib/ai/config';
import { getSupabaseConfig } from '@/lib/supabase/config';
import { NextResponse } from 'next/server';
export async function GET(){const auth=await requireUser();if(auth.error)return auth.error;const ai=getAiConfig();const db=getSupabaseConfig();return NextResponse.json({configured:ai.configured&&Boolean(db?.serviceRoleKey)});}
