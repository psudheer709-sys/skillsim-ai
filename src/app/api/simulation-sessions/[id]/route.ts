import { NextResponse } from 'next/server';
import { z } from 'zod';
import { requireUser } from '@/lib/auth/require-user';
import { apiError } from '@/lib/api-http';
const uuid=z.string().uuid();
export async function GET(_request:Request,{params}:{params:Promise<{id:string}>}){const auth=await requireUser(['student']);if(auth.error)return auth.error;const id=(await params).id;if(!uuid.safeParse(id).success)return apiError(400,'Invalid session id.');const{data,error}=await auth.user.supabase.from('simulation_sessions').select('id,scenario_id,interaction_mode,status,started_at,completed_at,simulation_messages(id,sender_type,message_content,created_at)').eq('id',id).eq('student_id',auth.user.id).maybeSingle();return error||!data?apiError(404,'Simulation session not found.'):NextResponse.json(data);}
