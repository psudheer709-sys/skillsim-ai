import { z } from 'zod';

export const evaluationSchema = z.object({
  criteria: z.array(z.object({ name: z.string().min(1).max(80), score: z.number().int().min(0).max(100), feedback: z.string().min(1).max(600) })).length(5).superRefine((items,ctx)=>{if(new Set(items.map(item=>item.name)).size!==items.length)ctx.addIssue({code:'custom',message:'Criterion names must be unique.'})}),
  strengths: z.array(z.string().min(1).max(500)).max(8),
  weaknesses: z.array(z.string().min(1).max(500)).max(8),
  mistakes: z.array(z.object({ category: z.enum(['Missing Requirements','Weak Explanation','Incorrect Assumptions','Poor Prioritisation','Coding Errors','Logical Reasoning Errors','Communication Problems','Incomplete Solutions','Time Management Issues','Weak Problem Analysis']), description: z.string().min(1).max(600), severity: z.enum(['low','medium','high']) })).max(12),
  improvements: z.array(z.string().min(1).max(500)).min(1).max(8),
  model_answer: z.string().min(1).max(5000),
  next_practice: z.string().min(1).max(300),
});
export type Evaluation = z.infer<typeof evaluationSchema> & { overall_score: number };
