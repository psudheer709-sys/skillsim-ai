import { z } from 'zod';
import { requireUser } from '@/lib/auth/require-user';
import { readJson, apiError } from '@/lib/api-http';
const schema = z.object({ password: z.string().min(12).max(128).regex(/[a-z]/).regex(/[A-Z]/).regex(/[0-9]/).regex(/[^A-Za-z0-9]/) });
export async function POST(request: Request) { const auth = await requireUser(); if (auth.error) return auth.error; const parsed = schema.safeParse(await readJson(request)); if (!parsed.success) return apiError(400, 'Use 12 or more characters with lowercase, uppercase, number, and symbol.'); const { error } = await auth.user.supabase.auth.updateUser({ password: parsed.data.password }); return error ? apiError(400, 'Password update failed.') : Response.json({ ok: true }); }
