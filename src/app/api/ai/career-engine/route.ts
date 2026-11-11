import { NextResponse } from 'next/server';
import { requireUser } from '@/lib/auth/require-user';
import { collectSkillPassport } from '@/lib/skill-passport';
import { buildCareerEngine } from '@/lib/career-engine';

export async function GET(){
 const auth=await requireUser(['student']);if(auth.error)return auth.error;const db=auth.user.supabase;
 try{
  const [passport,preference,selection]=await Promise.all([
   collectSkillPassport(db,auth.user.id),
   db.from('student_preferences').select('career_goal').eq('student_id',auth.user.id).maybeSingle(),
   db.from('student_roadmaps').select('roadmap_id,roadmaps(id,title)').eq('student_id',auth.user.id).eq('is_primary',true).maybeSingle(),
  ]);
  if(preference.error||selection.error)throw new Error('CAREER_DATA_UNAVAILABLE');
  const roadmap=selection.data?.roadmaps as unknown as {id:string;title:string}|null;
  let completedTopics:number|null=null,totalTopics:number|null=null,nextTopic:string|null=null;
  if(roadmap?.id){
   const [topics,progress]=await Promise.all([db.from('roadmap_topics').select('id,topic_title').eq('roadmap_id',roadmap.id).order('topic_order'),db.from('topic_progress').select('topic_id,status').eq('student_id',auth.user.id).eq('roadmap_id',roadmap.id)]);
   if(topics.error||progress.error)throw new Error('CAREER_PROGRESS_UNAVAILABLE');
   const done=new Set((progress.data||[]).filter(x=>x.status==='completed').map(x=>x.topic_id));
   completedTopics=done.size;totalTopics=(topics.data||[]).length;nextTopic=(topics.data||[]).find(x=>!done.has(x.id))?.topic_title||null;
  }
  const engine=buildCareerEngine({skills:passport.skills.map(x=>({name:x.name,score:x.score,previousScore:x.previousScore})),interest:preference.data?.career_goal||passport.profile?.career_interest||'',averageAssessment:passport.averageAssessmentScore,assessmentCount:passport.assessmentCount,completedTopics,totalTopics,roadmapTitle:roadmap?.title||null,nextTopic});
  return NextResponse.json({generatedAt:new Date().toISOString(),...engine},{headers:{'Cache-Control':'private, no-store'}});
 }catch{return NextResponse.json({error:'Career insights could not be calculated from your saved learning data.'},{status:503});}
}
