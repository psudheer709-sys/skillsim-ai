import { NextResponse } from 'next/server';
import { requireUser } from '@/lib/auth/require-user';
const periods:Record<string,number|undefined>={'7d':7,'30d':30,'90d':90,all:undefined};
export async function GET(request:Request){
 const auth=await requireUser();if(auth.error)return auth.error;
 const period=new URL(request.url).searchParams.get('period')||'30d';if(!(period in periods))return NextResponse.json({error:'Choose 7d, 30d, 90d, or all.'},{status:400});
 let query=auth.user.supabase.from('student_mistakes').select('id,category,description,severity,created_at,simulation_id,simulations(title),ai_evaluations!inner(overall_score)').eq('student_id',auth.user.id).order('created_at',{ascending:false}).limit(500);
 const days=periods[period];if(days)query=query.gte('created_at',new Date(Date.now()-days*86400000).toISOString());
 const {data,error}=await query;if(error)return NextResponse.json({error:'Could not load mistake history.'},{status:500});
 const rows=data||[];const counts=new Map<string,number>();for(const row of rows)counts.set(row.category,(counts.get(row.category)||0)+1);
 const categories=[...counts].map(([category,count])=>({category,count})).sort((a,b)=>b.count-a.count);
 let evaluations=auth.user.supabase.from('ai_evaluations').select('id,overall_score,created_at').eq('student_id',auth.user.id).eq('evaluation_status','completed').order('created_at',{ascending:false}).limit(200);
 if(days)evaluations=evaluations.gte('created_at',new Date(Date.now()-days*86400000).toISOString());
 const evaluationResult=await evaluations;if(evaluationResult.error)return NextResponse.json({error:'Could not load evaluation trends.'},{status:500});
 const points=(evaluationResult.data||[]).reverse();let improvement:number|null=null;if(points.length>=4){const midpoint=Math.floor(points.length/2);const earlier=points.slice(0,midpoint).reduce((a,x)=>a+x.overall_score,0)/midpoint;const recent=points.slice(midpoint).reduce((a,x)=>a+x.overall_score,0)/(points.length-midpoint);if(earlier>0)improvement=Math.round(((recent-earlier)/earlier)*100)}
 const repeated=categories.reduce((sum,item)=>sum+Math.max(0,item.count-1),0);
 const trendRows=(points as any[]).reduce((map:Map<string,{date:string;mistakes:number;scores:number[]}>,row)=>{const date=String(row.created_at).slice(0,10);const item=map.get(date)||{date,mistakes:0,scores:[]};item.scores.push(row.overall_score);map.set(date,item);return map},new Map<string,{date:string;mistakes:number;scores:number[]}>());
 for(const row of rows){const date=String(row.created_at).slice(0,10);const item=trendRows.get(date);if(item)item.mistakes++}
 return NextResponse.json({period,totalMistakes:rows.length,mostFrequent:categories[0]?.category||null,repeatedMistakeCount:repeated,improvementPercent:improvement,hasEnoughTrendData:points.length>=4,categories,trends:[...trendRows.values()].sort((a,b)=>a.date.localeCompare(b.date)).map(x=>({date:x.date,mistakes:x.mistakes,averageScore:x.scores.length?Math.round(x.scores.reduce((a,b)=>a+b,0)/x.scores.length):null})),recent:rows.slice(0,15)},{headers:{'Cache-Control':'private, no-store'}});
}
