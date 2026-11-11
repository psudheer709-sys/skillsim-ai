import { createSupabaseServerClient } from '@/lib/supabase/server';
import { getSupabaseConfig } from '@/lib/supabase/config';
import { apiError } from '@/lib/api-http';

export type AuthenticatedUser = { id: string; email: string; role: 'student'|'educator'|'administrator'; profile: Record<string,unknown>; supabase: Awaited<ReturnType<typeof createSupabaseServerClient>> };
export async function requireUser(allowedRoles?: Array<AuthenticatedUser['role']>): Promise<{ user: AuthenticatedUser; error?: never } | { user?: never; error: Response }> {
  if (!getSupabaseConfig()) return { error: apiError(503,'Supabase is not configured. Set the variables in .env.local and restart the app.') };
  let supabase: Awaited<ReturnType<typeof createSupabaseServerClient>>;
  try { supabase = await createSupabaseServerClient(); } catch { return { error: apiError(503,'Authentication is temporarily unavailable.') }; }
  // Middleware already refreshes SSR cookies and validates the JWT. Verify the
  // signed claims here instead of making a second Auth network request that can
  // race cookie refreshes across concurrent dashboard API calls.
  const { data: claimsResult, error: authError } = await supabase.auth.getClaims();
  const claims = claimsResult?.claims;
  const userId = typeof claims?.sub === 'string' ? claims.sub : null;
  if (authError || !userId) return { error: apiError(401,'Please sign in to continue.') };
  const { data: profile, error: profileError } = await supabase.from('profiles').select('*').eq('id',userId).maybeSingle();
  if (profileError || !profile) return { error: apiError(403,'Your account profile is unavailable. Contact the platform administrator if this continues.') };
  if (profile.account_status === 'suspended') return { error: apiError(403,'This account is suspended. Contact the platform administrator for assistance.') };
  const role = profile.role as AuthenticatedUser['role'];
  if (allowedRoles && !allowedRoles.includes(role)) return { error: apiError(403,'You do not have permission to access this resource.') };
  return { user: { id:userId,email:typeof claims?.email === 'string' ? claims.email : '',role,profile,supabase } };
}
