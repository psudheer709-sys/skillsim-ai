import { z } from 'zod';
import { requireUser } from '@/lib/auth/require-user';
import { readJson, apiError } from '@/lib/api-http';

const createSchema = z.object({ name: z.string().trim().min(2).max(180), domain: z.string().trim().max(253).optional().or(z.literal('')) });

export async function GET() {
  const auth = await requireUser();
  if (auth.error) return auth.error;
  const { data, error } = await auth.user.supabase.from('institution_members')
    .select('institution_id,role,status,joined_at,institutions(id,name,slug,domain,status)')
    .eq('user_id', auth.user.id).order('joined_at', { ascending: false });
  if (error) return apiError(503, 'Could not load your institution memberships.');
  return Response.json(data || [], { headers: { 'Cache-Control': 'private, no-store' } });
}

export async function POST(request: Request) {
  const auth = await requireUser();
  if (auth.error) return auth.error;
  if (auth.user.role === 'administrator') return apiError(400, 'Platform administrators manage institutions from the administrator workspace.');
  const parsed = createSchema.safeParse(await readJson(request));
  if (!parsed.success) return apiError(400, 'Enter a valid institution name and email domain.');
  const slug = parsed.data.name.toLowerCase().normalize('NFKD').replace(/[\u0300-\u036f]/g, '').replace(/[^a-z0-9]+/g, '-').replace(/^-|-$/g, '').slice(0, 100).replace(/-$/g, '');
  if (!slug) return apiError(400, 'Use an institution name containing English letters or numbers.');
  try {
    // Let PostgreSQL apply the required description column's empty-string default.
    // Sending `null` explicitly violates its NOT NULL constraint.
    const { error } = await auth.user.supabase.from('institutions').insert({ name: parsed.data.name, slug, domain: parsed.data.domain || null, created_by: auth.user.id, status: 'pending' });
    if (error) {
      if (error.code === '23505') return apiError(409, 'An institution with a similar name is already registered. Contact support if it is yours.');
      if (error.code === '42501') return apiError(403, 'Supabase rejected this registration for the current session. Sign out, sign back in, and try again.');
      return apiError(503, 'Institution request could not be saved. Please try again.');
    }
    // Avoid asking PostgREST to return an institution row through its separate
    // SELECT policy. The database trigger creates the owner's membership.
    return Response.json({ ok: true }, { status: 201 });
  } catch {
    return apiError(503, 'Institution registration could not reach Supabase. Check the server configuration and try again.');
  }
}
