import { NextResponse } from 'next/server';
import { readJson, validationError, apiError } from '@/lib/api-http';
import { loginSchema } from '@/lib/validation';
import { createSupabaseServerClient } from '@/lib/supabase/server';
import { getSupabaseConfig, getSupabaseSetupMessage } from '@/lib/supabase/config';
import { rateLimit, clientAddress } from '@/lib/security/rate-limit';
import { createSupabaseAdminClient } from '@/lib/supabase/admin';
export async function POST(request: Request) {
  if (!rateLimit(`login:${clientAddress(request)}`, 10).allowed) return apiError(429, 'Too many sign-in attempts. Try again later.');
  const parsed = loginSchema.safeParse(await readJson(request)); if (!parsed.success) return validationError(parsed.error);
  try { const { email, password, remember } = parsed.data; const supabase = await createSupabaseServerClient({ remember }); const { data, error } = await supabase.auth.signInWithPassword({ email, password });
    if (error || !data.user) return apiError(401, 'Email or password is incorrect.');
    const { data: profile, error: profileError } = await supabase.from('profiles').select('role,account_status').eq('id', data.user.id).maybeSingle();
    if (profileError || !profile) { await supabase.auth.signOut(); return apiError(403, 'Your account profile is unavailable. Please contact the platform administrator.'); }
    if (profile.account_status === 'suspended') { await supabase.auth.signOut(); return apiError(403, 'This account is suspended. Contact the platform administrator for assistance.'); }
    try {
      const admin = createSupabaseAdminClient();
      await admin.from('user_activity_days').upsert({ user_id: data.user.id, activity_date: new Date().toISOString().slice(0, 10), last_seen_at: new Date().toISOString() }, { onConflict: 'user_id,activity_date' });
    } catch { /* Activity analytics are best-effort; never block a valid login. */ }
    return NextResponse.json({ user: { id: data.user.id, email: data.user.email, role: profile?.role || 'student' } });
  } catch { return apiError(503, getSupabaseConfig() ? 'Supabase Auth could not be reached. Check the project URL and network, then try again.' : getSupabaseSetupMessage()); }
}
