import { z } from 'zod';
import { requireUser } from '@/lib/auth/require-user';
import { createSupabaseAdminClient } from '@/lib/supabase/admin';
import { readJson, apiError } from '@/lib/api-http';
const schema = z.object({ role: z.enum(['student', 'educator', 'administrator']) });
export async function PATCH(request: Request, { params }: { params: Promise<{ id: string }> }) {
  const auth = await requireUser(['administrator']); if (auth.error) return auth.error;
  const { id } = await params; const parsed = schema.safeParse(await readJson(request));
  if (!parsed.success) return apiError(400, 'A valid account role is required.');
  if (id === auth.user.id) return apiError(400, 'You cannot change your own administrator role.');
  try {
    const admin = createSupabaseAdminClient();
    const { data: target, error: targetError } = await admin.from('profiles').select('id,role').eq('id', id).maybeSingle();
    if (targetError) return apiError(503, 'Role update failed.');
    if (!target) return apiError(404, 'User not found.');
    if (target.role === 'administrator' && parsed.data.role !== 'administrator') {
      const { count, error } = await admin.from('profiles').select('id', { count: 'exact', head: true }).eq('role', 'administrator').eq('account_status', 'active');
      if (error) return apiError(503, 'Role update failed.');
      if ((count || 0) <= 1) return apiError(409, 'The last administrator cannot be demoted.');
    }
    const { data, error } = await admin.from('profiles').update({ role: parsed.data.role }).eq('id', id).select('id,role').maybeSingle();
    if (error) return apiError(400, 'Role update failed.');
    if (!data) return apiError(404, 'User not found.');
    const { error: auditError } = await admin.from('platform_admin_audit_logs').insert({ actor_id: auth.user.id, target_user_id: id, action: 'user.role_changed', details: { previousRole: target.role, newRole: parsed.data.role } });
    if (auditError) return apiError(503, 'Role updated, but the audit record could not be saved.');
    return Response.json(data);
  }
  catch { return apiError(503, 'Administrator service is not configured.'); }
}
