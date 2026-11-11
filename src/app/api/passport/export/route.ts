import { requireUser } from '@/lib/auth/require-user';
import { collectSkillPassport } from '@/lib/skill-passport';
import { makeSimplePdf } from '@/lib/pdf';

export async function GET() {
  const auth = await requireUser(['student']); if (auth.error) return auth.error;
  try {
    const data = await collectSkillPassport(auth.user.supabase, auth.user.id);
    const lines = [
      'SKILLSIM AI - VERIFIED SKILL PASSPORT',
      `Learner: ${data.profile?.full_name || 'SkillSim learner'}`,
      `Created: ${new Date().toISOString().slice(0, 10)}`,
      `Average verified skill score: ${data.overallProgress}/100`,
      `Completed simulation assessments: ${data.assessmentCount}`,
      `Average assessment score: ${data.averageAssessmentScore === null ? 'No completed assessments' : `${data.averageAssessmentScore}/100`}`,
      'Verified skills:',
      ...(data.skills.length ? data.skills.map(skill => `${skill.name}: ${skill.score}/100`) : ['No evaluated skills recorded yet.']),
      'Completed roadmaps:',
      ...(data.completedRoadmaps.length ? data.completedRoadmaps.map(roadmap => `${roadmap.title} (${roadmap.completedAt || 'date unavailable'})`) : ['No completed roadmap recorded yet.']),
      'Earned achievements:',
      ...(data.achievements.length ? data.achievements.map(achievement => achievement.name) : ['No achievement recorded yet.']),
      'Scores and milestones reflect persisted SkillSim records.',
    ];
    return new Response(makeSimplePdf(lines), { headers: { 'Content-Type': 'application/pdf', 'Content-Disposition': 'attachment; filename="skillsim-skill-passport.pdf"', 'Cache-Control': 'private, no-store' } });
  } catch {
    return Response.json({ error: 'Your verified Skill Passport could not be exported.' }, { status: 500 });
  }
}
