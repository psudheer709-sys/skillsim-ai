import { NextResponse } from 'next/server';
import { requireUser } from '@/lib/auth/require-user';
import { profileSchema } from '@/lib/validation';
import { readJson, validationError } from '@/lib/api-http';
export async function GET() { const auth = await requireUser(); if (auth.error) return auth.error; return NextResponse.json(auth.user.profile); }
export async function PATCH(request: Request) { const auth = await requireUser(); if (auth.error) return auth.error; const parsed = profileSchema.safeParse(await readJson(request)); if (!parsed.success) return validationError(parsed.error); const { data, error } = await auth.user.supabase.from('profiles').update(parsed.data).eq('id', auth.user.id).select('*').single(); return error ? Response.json({ error: 'Profile update failed.' }, { status: 400 }) : NextResponse.json(data); }
