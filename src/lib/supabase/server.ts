import 'server-only';
import { createServerClient } from '@supabase/ssr';
import { cookies } from 'next/headers';
import { getSupabaseConfig } from './config';
export async function createSupabaseServerClient(options?: { remember?: boolean }) {
  const config = getSupabaseConfig();
  if (!config) throw new Error('Supabase is not configured.');
  const cookieStore = await cookies();
  return createServerClient(config.url, config.publicKey, {
    cookieOptions: options?.remember ? { maxAge: 60 * 60 * 24 * 30, sameSite: 'lax', secure: process.env.NODE_ENV === 'production' } : { sameSite: 'lax', secure: process.env.NODE_ENV === 'production' },
    cookies: {
      getAll() { return cookieStore.getAll(); },
      setAll(cookiesToSet) {
        try { for (const { name, value, options: cookieOptions } of cookiesToSet) cookieStore.set(name, value, cookieOptions); } catch { /* Server Components cannot write cookies; middleware refreshes them. */ }
      },
    },
  });
}
