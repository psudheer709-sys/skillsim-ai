import { z } from 'zod';
import { requireUser } from '@/lib/auth/require-user';
import { createSupabaseAdminClient } from '@/lib/supabase/admin';
import { readJson, apiError } from '@/lib/api-http';

export async function GET() {
  const auth = await requireUser(['administrator']);
  if (auth.error) return auth.error;
  const { data, error } = await createSupabaseAdminClient().from('institutions')
    .select('id,name,slug,domain,website,status,created_at,created_by')
    .order('created_at', { ascending: false }).limit(100);
  if (error) return apiError(503, 'Could not load institutions.');
  return Response.json(data || [], { headers: { 'Cache-Control': 'private, no-store' } });
}

const updateSchema = z.object({ id: z.string().uuid(), status: z.enum(['verified', 'suspended', 'pending']) });
export async function PATCH(request: Request) {
  const auth = await requireUser(['administrator']);
  if (auth.error) return auth.error;
  const parsed = updateSchema.safeParse(await readJson(request));
  if (!parsed.success) return apiError(400, 'Choose a valid institution and status.');
  const admin = createSupabaseAdminClient();
  const verified = parsed.data.status === 'verified';
  const { data, error } = await admin.from('institutions').update({ status: parsed.data.status, verified_by: verified ? auth.user.id : null, verified_at: verified ? new Date().toISOString() : null }).eq('id', parsed.data.id).select('id,status').maybeSingle();
  if (error || !data) return apiError(error ? 503 : 404, 'Institution status could not be updated.');
  const { error: auditError } = await admin.from('platform_admin_audit_logs').insert({ actor_id: auth.user.id, action: `institution.${parsed.data.status}`, details: { institutionId: parsed.data.id } });
  if (auditError) return apiError(503, 'Institution updated, but the audit record could not be saved.');
  return Response.json(data);
}
