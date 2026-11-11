import { NextResponse } from 'next/server';
import type { ZodError } from 'zod';
export function apiError(status: number, error: string, details?: unknown) {
  return NextResponse.json({ error, ...(details ? { details } : {}) }, { status, headers: { 'Cache-Control': 'no-store' } });
}
export async function readJson(request: Request): Promise<unknown> {
  try { return await request.json(); } catch { return null; }
}
export function validationError(error: ZodError) {
  return apiError(400, 'Please check the supplied fields.', error.issues.map(issue => ({ field: issue.path.join('.'), message: issue.message })));
}
export function apiMessage(error: { code?: string; message?: string } | null | undefined, fallback = 'The request could not be completed.') {
  if (!error) return fallback;
  if (error.code === 'PGRST116') return 'The requested record was not found.';
  if (error.code === '23505') return 'This record already exists.';
  if (error.code === '42501') return 'You do not have permission to perform this action.';
  return fallback;
}
