import { NextResponse } from 'next/server';
import { requireUser } from '@/lib/auth/require-user';
import { makeSimplePdf } from '@/lib/pdf';

export async function GET(request: Request) {
  const auth = await requireUser(['student']);
  if (auth.error) return auth.error;
  const roadmapId = new URL(request.url).searchParams.get('roadmapId');
  if (!roadmapId || !/^[0-9a-f-]{36}$/i.test(roadmapId)) return NextResponse.json({ error: 'Choose a valid roadmap.' }, { status: 400 });
  const { data, error } = await auth.user.supabase.from('student_roadmaps').select('completed_at,selection_status,roadmaps(title)').eq('student_id', auth.user.id).eq('roadmap_id', roadmapId).eq('selection_status', 'completed').maybeSingle();
  if (error || !data) return NextResponse.json({ error: 'Certificates are available after the roadmap is fully completed.' }, { status: 403 });
  const roadmapRow = data.roadmaps as unknown as { title: string } | null;
  const roadmap = roadmapRow?.title || 'Career Roadmap';
  const date = new Date(data.completed_at ?? new Date().toISOString()).toLocaleDateString('en-US', { year: 'numeric', month: 'long', day: 'numeric', timeZone: 'UTC' });
  const pdf = makeSimplePdf(['SKILLSIM AI - CERTIFICATE OF COMPLETION', 'This certificate recognizes', String(auth.user.profile.full_name || 'SkillSim learner'), `for completing ${roadmap}.`, `Completed ${date}`, 'Awarded from verified roadmap completion records.']);
  return new Response(pdf, { headers: { 'Content-Type': 'application/pdf', 'Content-Disposition': 'attachment; filename="skillsim-certificate.pdf"', 'Cache-Control': 'private, no-store' } });
}
