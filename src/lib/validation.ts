import { z } from 'zod';
const email = z.string().trim().email().max(254);
const password = z.string().min(12,'Use at least 12 characters.').max(128).regex(/[a-z]/,'Include a lowercase letter.').regex(/[A-Z]/,'Include an uppercase letter.').regex(/[0-9]/,'Include a number.').regex(/[^A-Za-z0-9]/,'Include a symbol.');
export const registerSchema = z.object({
 fullName:z.string().trim().min(2).max(200),email,password,confirmPassword:z.string().min(1),
 collegeName:z.string().trim().min(2).max(200),course:z.string().trim().min(2).max(200),careerInterest:z.string().trim().min(2).max(200),
 accountType:z.enum(['student','educator'])
}).refine(v=>v.password===v.confirmPassword,{path:['confirmPassword'],message:'Passwords do not match.'});
export const loginSchema=z.object({email,password:z.string().min(1).max(128),remember:z.boolean().optional().default(true)});
export const profileSchema=z.object({full_name:z.string().trim().min(2).max(200),college_name:z.string().trim().max(200),course:z.string().trim().max(200),career_interest:z.string().trim().max(200)}).partial().refine(v=>Object.keys(v).length>0,{message:'Provide at least one profile field.'});
export const roadmapSelectionSchema=z.object({roadmapId:z.string().uuid(),currentSkillLevel:z.enum(['Beginner','Intermediate','Advanced']),dailyLearningTime:z.enum(['30 minutes','1 hour','2 hours','3 hours or more']),careerGoal:z.string().trim().min(2).max(160),preferredLearningStyle:z.string().trim().min(2).max(40).default('mixed')});
export const topicProgressSchema=z.object({roadmapId:z.string().uuid(),topicId:z.string().uuid(),status:z.enum(['in_progress','completed']),completionPercentage:z.number().int().min(0).max(100),learningTime:z.number().int().min(0).max(600)}).refine(v=>v.status!=='completed'||v.completionPercentage===100,{message:'Completed topics must have 100% completion.'});
export const quizAttemptSchema=z.object({topicId:z.string().uuid(),score:z.number().int().min(0),totalQuestions:z.number().int().min(1).max(100),answers:z.array(z.object({questionId:z.string().max(100),answer:z.string().max(2000),correct:z.boolean()})).max(100)}).refine(v=>v.score<=v.totalQuestions,{message:'Score cannot exceed total questions.'});
export const planCreateSchema=z.object({roadmapId:z.string().uuid(),weekStartDate:z.string().regex(/^\d{4}-\d{2}-\d{2}$/),weeklyTargetDays:z.number().int().min(3).max(7).default(5)});
export const taskUpdateSchema=z.object({status:z.enum(['in_progress','completed']),actualMinutes:z.number().int().min(0).max(600).optional()});
export const submissionSchema=z.object({simulationId:z.string().uuid(),content:z.string().trim().min(1).max(20000),requestId:z.string().uuid().optional()});
