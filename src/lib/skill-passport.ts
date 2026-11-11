type SupabaseClient = Awaited<ReturnType<(typeof import('@/lib/supabase/server'))['createSupabaseServerClient']>>;

export async function collectSkillPassport(client: SupabaseClient, userId: string) {
  const [profileResult, skillsResult, roadmapsResult, achievementsResult, evaluationsResult] = await Promise.all([
    client.from('profiles').select('id,full_name,course,career_interest,created_at').eq('id', userId).maybeSingle(),
    client.from('student_skill_scores').select('skill_name,current_score,previous_score,updated_at').eq('student_id', userId).order('current_score', { ascending: false }),
    client.from('student_roadmaps').select('selection_status,started_at,completed_at,roadmaps(id,title,description)').eq('student_id', userId).order('started_at', { ascending: false }),
    client.from('achievements').select('achievement_name,description,earned_at').eq('student_id', userId).order('earned_at', { ascending: false }),
    client.from('ai_evaluations').select('id,overall_score,created_at,simulations(title,category)').eq('student_id', userId).eq('evaluation_status', 'completed').order('created_at', { ascending: false }).limit(30),
  ]);

  if (profileResult.error || skillsResult.error || roadmapsResult.error || achievementsResult.error || evaluationsResult.error) {
    throw new Error('PASSPORT_DATA_UNAVAILABLE');
  }

  const skills = (skillsResult.data ?? []).map((skill) => ({
    name: skill.skill_name,
    score: skill.current_score,
    previousScore: skill.previous_score,
    updatedAt: skill.updated_at,
  }));
  const average = (matches: (name: string) => boolean) => {
    const values = skills.filter((skill) => matches(skill.name.toLowerCase())).map((skill) => skill.score);
    return values.length ? Math.round(values.reduce((total, value) => total + value, 0) / values.length) : null;
  };
  const completedRoadmaps = (roadmapsResult.data ?? []).filter((row) => row.selection_status === 'completed').map((row) => {
    const roadmap = row.roadmaps as unknown as { id: string; title: string } | null;
    return { id: roadmap?.id ?? null, title: roadmap?.title ?? 'Career roadmap', completedAt: row.completed_at };
  });
  const evaluations = (evaluationsResult.data ?? []).map((row) => {
    const simulation = row.simulations as unknown as { title: string; category: string } | null;
    return { id: row.id, score: row.overall_score, createdAt: row.created_at, title: simulation?.title ?? 'Simulation assessment', category: simulation?.category ?? 'Workplace skills' };
  });
  const avgScore = evaluations.length ? Math.round(evaluations.reduce((total, row) => total + row.score, 0) / evaluations.length) : null;

  return {
    profile: profileResult.data,
    skills,
    communication: average((name) => /communication|clarity|empathy|writing/.test(name)),
    problemSolving: average((name) => /problem|reasoning|analysis|critical thinking/.test(name)),
    technical: average((name) => /technical|coding|code|programming|correctness/.test(name)),
    completedRoadmaps,
    achievements: (achievementsResult.data ?? []).map((row) => ({ name: row.achievement_name, description: row.description, earnedAt: row.earned_at })),
    evaluations,
    assessmentCount: evaluations.length,
    averageAssessmentScore: avgScore,
    overallProgress: skills.length ? Math.round(skills.reduce((total, skill) => total + skill.score, 0) / skills.length) : 0,
  };
}

export type SkillPassportData = Awaited<ReturnType<typeof collectSkillPassport>>;
