export type SupabaseConfig = { url: string; publicKey: string; serviceRoleKey?: string };
export function getSupabaseConfig(): SupabaseConfig | null {
  const url = process.env.NEXT_PUBLIC_SUPABASE_URL?.trim();
  const publicKey = process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY?.trim() || process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY?.trim();
  if (!url || !publicKey || /^(your_|placeholder|change.?me)/i.test(publicKey)) return null;
  try {
    const parsed = new URL(url);
    if (!['https:', 'http:'].includes(parsed.protocol) || /^(your_|placeholder|change.?me)/i.test(parsed.hostname)) return null;
  } catch { return null; }
  return { url, publicKey, serviceRoleKey: process.env.SUPABASE_SERVICE_ROLE_KEY?.trim() || undefined };
}
export function getSupabaseSetupMessage() {
  return 'Supabase configuration is incomplete. Please configure your Project URL and Publishable Key in .env.local.';
}
