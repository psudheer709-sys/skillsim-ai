import { z } from 'zod';
import { requireUser } from '@/lib/auth/require-user';
import { createSupabaseAdminClient } from '@/lib/supabase/admin';
import { readJson, apiError } from '@/lib/api-http';

export async function GET() {
  const auth = await requireUser(['administrator']);
  if (auth.error) return auth.error;
  const { data, error } = await createSupabaseAdminClient().from('platform_announcements').select('id,title,message,created_at,publish_until').order('created_at', { ascending: false }).limit(30);
  if (error) return apiError(503, 'Could not load platform announcements.');
  return Response.json(data || [], { headers: { 'Cache-Control': 'private, no-store' } });
}

const schema = z.object({ title: z.string().trim().min(3).max(160), message: z.string().trim().min(1).max(3000), publishUntil: z.string().datetime().nullable().optional() });
export async function POST(request: Request) {
  const auth = await requireUser(['administrator']);
  if (auth.error) return auth.error;
  const parsed = schema.safeParse(await readJson(request));
  if (!parsed.success) return apiError(400, 'Enter an announcement title and message.');
  const admin = createSupabaseAdminClient();
  const { data, error } = await admin.from('platform_announcements').insert({ title: parsed.data.title, message: parsed.data.message, publish_until: parsed.data.publishUntil || null, created_by: auth.user.id }).select('id,title,message,created_at,publish_until').single();
  if (error) return apiError(503, 'The announcement could not be published.');
  const { error: auditError } = await admin.from('platform_admin_audit_logs').insert({ actor_id: auth.user.id, action: 'announcement.published', details: { announcementId: data.id, title: data.title } });
  if (auditError) return apiError(503, 'Announcement saved, but its audit record could not be saved.');
  return Response.json(data, { status: 201 });
}
