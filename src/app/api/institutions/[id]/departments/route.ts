import { z } from 'zod';
import { requireUser } from '@/lib/auth/require-user';
import { readJson, apiError } from '@/lib/api-http';

const schema=z.object({name:z.string().trim().min(2).max(120)});
export async function POST(request:Request,{params}:{params:Promise<{id:string}>}){
  const auth=await requireUser();if(auth.error)return auth.error;const id=(await params).id;const parsed=schema.safeParse(await readJson(request));if(!parsed.success)return apiError(400,'Department name must be between 2 and 120 characters.');
  const db=auth.user.supabase;const {data:membership}=await db.from('institution_members').select('role,status').eq('institution_id',id).eq('user_id',auth.user.id).maybeSingle();if(membership?.role!=='institution_admin'||membership.status!=='active')return apiError(403,'Only an active institution administrator can manage departments.');
  const {data:institution}=await db.from('institutions').select('status').eq('id',id).maybeSingle();if(institution?.status!=='verified')return apiError(409,'The institution must be verified before it can manage learning groups.');
  const {data,error}=await db.from('institution_departments').insert({institution_id:id,name:parsed.data.name,created_by:auth.user.id}).select('id,institution_id,name,created_at').single();return error?apiError(error.code==='23505'?409:503,error.code==='23505'?'That department already exists.':'Department could not be created.'):Response.json(data,{status:201});
}
export async function GET(_request:Request,{params}:{params:Promise<{id:string}>}){const auth=await requireUser();if(auth.error)return auth.error;const id=(await params).id;const {data,error}=await auth.user.supabase.from('institution_departments').select('id,institution_id,name,created_at').eq('institution_id',id).order('name');return error?apiError(503,'Departments could not be loaded.'):Response.json(data||[],{headers:{'Cache-Control':'private, no-store'}});}
