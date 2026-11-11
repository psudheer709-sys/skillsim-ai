import { NextResponse } from 'next/server';
import { requireUser } from '@/lib/auth/require-user';
export async function GET() { const result = await requireUser(); if (result.error) return result.error; return NextResponse.json({ id: result.user.id, email: result.user.email, ...result.user.profile }); }
