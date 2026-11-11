import { z } from 'zod';
import { requireUser } from '@/lib/auth/require-user';
import { readJson, apiError } from '@/lib/api-http';

const schema=z.object({roadmapId:z.string().uuid(),batchId:z.string().uuid().nullable().optional(),dueAt:z.string().datetime().nullable().optional()});
export async function POST(request:Request,{params}:{params:Promise<{id:string}>}){
  const auth=await requireUser();if(auth.error)return auth.error;const id=(await params).id;const parsed=schema.safeParse(await readJson(request));if(!parsed.success)return apiError(400,'Choose a valid roadmap and batch.');const db=auth.user.supabase;
  const {data:membership}=await db.from('institution_members').select('role,status').eq('institution_id',id).eq('user_id',auth.user.id).maybeSingle();if(membership?.role!=='institution_admin'||membership.status!=='active')return apiError(403,'Only an active institution administrator can assign roadmaps.');
  const {data:institution}=await db.from('institutions').select('status').eq('id',id).maybeSingle();if(institution?.status!=='verified')return apiError(409,'The institution must be verified before assigning roadmaps.');
  const {data:roadmap}=await db.from('roadmaps').select('id').eq('id',parsed.data.roadmapId).eq('is_active',true).maybeSingle();if(!roadmap)return apiError(400,'Choose an active roadmap.');if(parsed.data.batchId){const {data:batch}=await db.from('institution_batches').select('id').eq('id',parsed.data.batchId).eq('institution_id',id).maybeSingle();if(!batch)return apiError(400,'Choose a batch in this institution.');}
  const {data,error}=await db.from('institution_roadmap_assignments').upsert({institution_id:id,roadmap_id:roadmap.id,batch_id:parsed.data.batchId||null,due_at:parsed.data.dueAt||null,assigned_by:auth.user.id},{onConflict:'institution_id,roadmap_id,batch_id'}).select('id,institution_id,roadmap_id,batch_id,due_at,created_at').single();return error?apiError(503,'Roadmap could not be assigned.'):Response.json(data,{status:201});
}
export async function GET(_request:Request,{params}:{params:Promise<{id:string}>}){const auth=await requireUser();if(auth.error)return auth.error;const id=(await params).id;const {data,error}=await auth.user.supabase.from('institution_roadmap_assignments').select('id,roadmap_id,batch_id,due_at,created_at,roadmaps(id,title,category),institution_batches(name)').eq('institution_id',id).order('created_at',{ascending:false});return error?apiError(503,'Institution roadmaps could not be loaded.'):Response.json(data||[],{headers:{'Cache-Control':'private, no-store'}});}
