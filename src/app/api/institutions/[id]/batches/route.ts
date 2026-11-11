import { z } from 'zod';
import { requireUser } from '@/lib/auth/require-user';
import { readJson, apiError } from '@/lib/api-http';

const schema=z.object({name:z.string().trim().min(2).max(120),departmentId:z.string().uuid().nullable().optional(),startsOn:z.string().date().nullable().optional(),endsOn:z.string().date().nullable().optional()}).refine(v=>!v.startsOn||!v.endsOn||v.endsOn>=v.startsOn,{path:['endsOn'],message:'End date must be after the start date.'});
export async function POST(request:Request,{params}:{params:Promise<{id:string}>}){
  const auth=await requireUser();if(auth.error)return auth.error;const id=(await params).id;const parsed=schema.safeParse(await readJson(request));if(!parsed.success)return apiError(400,'Check the batch name, department and dates.');
  const db=auth.user.supabase;const {data:membership}=await db.from('institution_members').select('role,status').eq('institution_id',id).eq('user_id',auth.user.id).maybeSingle();if(membership?.role!=='institution_admin'||membership.status!=='active')return apiError(403,'Only an active institution administrator can manage batches.');
  const {data:institution}=await db.from('institutions').select('status').eq('id',id).maybeSingle();if(institution?.status!=='verified')return apiError(409,'The institution must be verified before it can manage learning groups.');
  if(parsed.data.departmentId){const {data:department}=await db.from('institution_departments').select('id').eq('id',parsed.data.departmentId).eq('institution_id',id).maybeSingle();if(!department)return apiError(400,'Choose a department in this institution.');}
  const {data,error}=await db.from('institution_batches').insert({institution_id:id,name:parsed.data.name,department_id:parsed.data.departmentId||null,starts_on:parsed.data.startsOn||null,ends_on:parsed.data.endsOn||null}).select('id,institution_id,department_id,name,starts_on,ends_on,created_at').single();return error?apiError(error.code==='23505'?409:503,error.code==='23505'?'That batch already exists.':'Batch could not be created.'):Response.json(data,{status:201});
}
export async function GET(_request:Request,{params}:{params:Promise<{id:string}>}){const auth=await requireUser();if(auth.error)return auth.error;const id=(await params).id;const {data,error}=await auth.user.supabase.from('institution_batches').select('id,institution_id,department_id,name,starts_on,ends_on').eq('institution_id',id).order('name');return error?apiError(503,'Batches could not be loaded.'):Response.json(data||[],{headers:{'Cache-Control':'private, no-store'}});}
