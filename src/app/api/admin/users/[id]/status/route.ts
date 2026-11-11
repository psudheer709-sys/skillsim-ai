import { z } from 'zod';
import { requireUser } from '@/lib/auth/require-user';
import { createSupabaseAdminClient } from '@/lib/supabase/admin';
import { readJson, apiError } from '@/lib/api-http';

const schema = z.object({ status: z.enum(['active', 'suspended']) });

export async function PATCH(request: Request, { params }: { params: Promise<{ id: string }> }) {
  const auth = await requireUser(['administrator']);
  if (auth.error) return auth.error;
  const { id } = await params;
  if (id === auth.user.id) return apiError(400, 'You cannot suspend or restore your own administrator account.');
  const parsed = schema.safeParse(await readJson(request));
  if (!parsed.success) return apiError(400, 'Choose a valid account status.');

  try {
    const admin = createSupabaseAdminClient();
    const { data: target, error: targetError } = await admin.from('profiles').select('id,role,account_status').eq('id', id).maybeSingle();
    if (targetError) throw targetError;
    if (!target) return apiError(404, 'User not found.');
    if (target.role === 'administrator' && parsed.data.status === 'suspended') {
      const { count, error } = await admin.from('profiles').select('id', { count: 'exact', head: true }).eq('role', 'administrator').eq('account_status', 'active');
      if (error) throw error;
      if ((count || 0) <= 1) return apiError(409, 'The last active administrator cannot be suspended.');
    }
    const { data, error } = await admin.from('profiles').update({ account_status: parsed.data.status }).eq('id', id).select('id,account_status').single();
    if (error) throw error;
    const { error: auditError } = await admin.from('platform_admin_audit_logs').insert({ actor_id: auth.user.id, target_user_id: id, action: parsed.data.status === 'suspended' ? 'user.suspended' : 'user.restored', details: { previousStatus: target.account_status, newStatus: parsed.data.status } });
    if (auditError) throw auditError;
    return Response.json(data);
  } catch {
    return apiError(503, 'The account status could not be updated.');
  }
}
