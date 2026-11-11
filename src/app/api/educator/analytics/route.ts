import { NextResponse } from 'next/server';
import { requireUser } from '@/lib/auth/require-user';

export async function GET() {
  const auth = await requireUser(['educator', 'administrator']); if (auth.error) return auth.error;
  let classQuery = auth.user.supabase.from('educator_classes').select('id,class_name,class_memberships(id,student_id,profiles(id,full_name,course))').order('created_at', { ascending: false });
  if (auth.user.role !== 'administrator') classQuery = classQuery.eq('educator_id', auth.user.id);
  const { data: classes, error } = await classQuery;
  if (error) return NextResponse.json({ error: 'Could not load class analytics.' }, { status: 500 });
  const memberships = (classes ?? []).flatMap((row: any) => (row.class_memberships ?? []).map((member: any) => ({ ...member, classId: row.id, className: row.class_name })));
  const studentIds = [...new Set(memberships.map((row: any) => row.student_id))];
  if (!studentIds.length) return NextResponse.json({ classes: classes ?? [], learners: [], averageScore: null, weeklyScores: [], assignmentsSubmitted: 0 });
  const [evaluations, progress, submissions] = await Promise.all([
    auth.user.supabase.from('ai_evaluations').select('student_id,overall_score,created_at').in('student_id', studentIds).eq('evaluation_status', 'completed').order('created_at', { ascending: false }),
    auth.user.supabase.from('topic_progress').select('student_id,status').in('student_id', studentIds),
    auth.user.supabase.from('assignment_submissions').select('student_id,status').in('student_id', studentIds),
  ]);
  if (evaluations.error || progress.error || submissions.error) return NextResponse.json({ error: 'Could not calculate class analytics.' }, { status: 500 });
  const scores = evaluations.data ?? []; const completedTopics = progress.data ?? []; const submitted = submissions.data ?? [];
  const learners = memberships.map((member: any) => {
    const ownScores = scores.filter(row => row.student_id === member.student_id);
    const ownProgress = completedTopics.filter(row => row.student_id === member.student_id);
    return { id: member.student_id, className: member.className, name: member.profiles?.full_name || 'Learner', course: member.profiles?.course || '', averageScore: ownScores.length ? Math.round(ownScores.reduce((sum, row) => sum + row.overall_score, 0) / ownScores.length) : null, completedAssessments: ownScores.length, completedTopics: ownProgress.length, submittedAssignments: submitted.filter(row => row.student_id === member.student_id && row.status === 'submitted').length };
  });
  const averageScore = scores.length ? Math.round(scores.reduce((sum, row) => sum + row.overall_score, 0) / scores.length) : null;
  const weeklyScores = Array.from({ length: 6 }, (_, i) => { const start = new Date(); start.setUTCHours(0, 0, 0, 0); start.setUTCDate(start.getUTCDate() - (5 - i) * 7); const end = new Date(start); end.setUTCDate(end.getUTCDate() + 7); const current = scores.filter(row => new Date(row.created_at) >= start && new Date(row.created_at) < end); return { week: `W${i + 1}`, score: current.length ? Math.round(current.reduce((sum, row) => sum + row.overall_score, 0) / current.length) : null, assessments: current.length }; });
  return NextResponse.json({ classes: classes ?? [], learners, averageScore, weeklyScores, assignmentsSubmitted: submitted.filter(row => row.status === 'submitted').length }, { headers: { 'Cache-Control': 'private, no-store' } });
}
