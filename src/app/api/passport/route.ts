import { NextResponse } from 'next/server';
import { z } from 'zod';
import { requireUser } from '@/lib/auth/require-user';
import { readJson, validationError } from '@/lib/api-http';
import { collectSkillPassport } from '@/lib/skill-passport';

const shareSchema = z.object({
  isPublic: z.boolean(),
  fields: z.object({ name: z.boolean(), skills: z.boolean(), achievements: z.boolean(), history: z.boolean(), roadmaps: z.boolean().default(false) }),
});

function publicSnapshot(data: Awaited<ReturnType<typeof collectSkillPassport>>, fields: z.infer<typeof shareSchema>['fields']) {
  return {
    version: 1,
    generatedAt: new Date().toISOString(),
    ...(fields.name ? { name: data.profile?.full_name || 'SkillSim learner', course: data.profile?.course || '', careerInterest: data.profile?.career_interest || '' } : {}),
    ...(fields.skills ? { skills: data.skills, communication: data.communication, problemSolving: data.problemSolving, technical: data.technical, overallProgress: data.overallProgress } : {}),
    ...(fields.roadmaps ? { completedRoadmaps: data.completedRoadmaps } : {}),
    ...(fields.achievements ? { achievements: data.achievements } : {}),
    ...(fields.history ? { assessmentCount: data.assessmentCount, averageAssessmentScore: data.averageAssessmentScore } : {}),
    ...(fields.history ? { history: data.evaluations.slice(0, 10) } : {}),
    visibility: fields,
  };
}

export async function GET() {
  const auth = await requireUser(['student']);
  if (auth.error) return auth.error;
  try {
    const [passport, share] = await Promise.all([
      collectSkillPassport(auth.user.supabase, auth.user.id),
      auth.user.supabase.from('public_skill_passports').select('public_id,is_public,snapshot,updated_at').eq('user_id', auth.user.id).maybeSingle(),
    ]);
    if (share.error) throw share.error;
    const defaultVisibility = { name: true, skills: true, achievements: true, history: false };
    const visibility = (share.data?.snapshot as { visibility?: typeof defaultVisibility } | undefined)?.visibility ?? defaultVisibility;
    return NextResponse.json({ ...passport, sharing: { isPublic: share.data?.is_public ?? false, publicId: share.data?.public_id ?? null, visibility } }, { headers: { 'Cache-Control': 'private, no-store' } });
  } catch {
    return NextResponse.json({ error: 'Could not load your verified Skill Passport.' }, { status: 500 });
  }
}

export async function POST(request: Request) {
  const auth = await requireUser(['student']);
  if (auth.error) return auth.error;
  const parsed = shareSchema.safeParse(await readJson(request));
  if (!parsed.success) return validationError(parsed.error);
  try {
    const data = await collectSkillPassport(auth.user.supabase, auth.user.id);
    const { data: share, error } = await auth.user.supabase.from('public_skill_passports').upsert({
      user_id: auth.user.id,
      is_public: parsed.data.isPublic,
      snapshot: publicSnapshot(data, parsed.data.fields),
      updated_at: new Date().toISOString(),
    }, { onConflict: 'user_id' }).select('public_id,is_public,updated_at').single();
    if (error) throw error;
    return NextResponse.json({ isPublic: share.is_public, publicId: share.public_id, updatedAt: share.updated_at }, { headers: { 'Cache-Control': 'private, no-store' } });
  } catch {
    return NextResponse.json({ error: 'Your sharing settings could not be saved.' }, { status: 500 });
  }
}
