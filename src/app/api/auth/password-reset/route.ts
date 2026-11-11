import { z } from 'zod';
import { readJson, apiError } from '@/lib/api-http';
import { createSupabaseServerClient } from '@/lib/supabase/server';
const schema = z.object({ email: z.string().trim().email().max(254) });
export async function POST(request: Request) { const parsed = schema.safeParse(await readJson(request)); if (!parsed.success) return apiError(400, 'Enter a valid email address.'); try { const client = await createSupabaseServerClient(); await client.auth.resetPasswordForEmail(parsed.data.email, { redirectTo: `${new URL(request.url).origin}/auth/confirm?next=/reset-password` }); } catch { /* Keep response generic to avoid account enumeration. */ } return Response.json({ message: 'If an account exists for that address, a password reset email has been sent.' }); }
