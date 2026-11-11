import { NextResponse } from 'next/server';
import { readJson, validationError, apiError } from '@/lib/api-http';
import { registerSchema } from '@/lib/validation';
import { createSupabaseServerClient } from '@/lib/supabase/server';
import { getSupabaseConfig, getSupabaseSetupMessage } from '@/lib/supabase/config';
import { rateLimit, clientAddress } from '@/lib/security/rate-limit';
export async function POST(request: Request) {
  if (!rateLimit(`register:${clientAddress(request)}`, 5).allowed) return apiError(429, 'Too many sign-up attempts. Try again later.');
  const parsed = registerSchema.safeParse(await readJson(request)); if (!parsed.success) return validationError(parsed.error);
  try {
    const { fullName, email, password, collegeName, course, careerInterest, accountType } = parsed.data;
    const supabase = await createSupabaseServerClient();
    const destination = accountType === 'educator' ? '/educator' : '/dashboard';
    const { data, error } = await supabase.auth.signUp({ email, password, options: { data: { full_name: fullName, account_type: accountType, college_name: collegeName, course, career_interest: careerInterest }, emailRedirectTo: `${new URL(request.url).origin}/auth/confirm?next=${destination}` } });
    if (error) return apiError(error.status === 429 ? 429 : 400, error.message);
    if (!data.session) return NextResponse.json({ message: 'Check your email to confirm your account before signing in.', confirmationRequired: true }, { status: 201 });
    return NextResponse.json({ message: 'Account created.', user: { id: data.user?.id, email: data.user?.email } }, { status: 201 });
  } catch { return apiError(503, getSupabaseConfig() ? 'Supabase Auth could not be reached. Check the project URL and network, then try again.' : getSupabaseSetupMessage()); }
}
