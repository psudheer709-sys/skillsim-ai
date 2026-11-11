import { NextResponse } from 'next/server';
import { requireUser } from '@/lib/auth/require-user';
import { createSupabaseAdminClient } from '@/lib/supabase/admin';

export async function GET() {
  const auth = await requireUser(['administrator']);
  if (auth.error) return auth.error;

  try {
    const admin = createSupabaseAdminClient();
    const today = new Date().toISOString().slice(0, 10);
    const monthStart = new Date();
    monthStart.setUTCDate(monthStart.getUTCDate() - 29);
    const monthStartDate = monthStart.toISOString().slice(0, 10);
    const count = async (table: string, column?: string, value?: string) => {
      let query = admin.from(table).select('id', { count: 'exact', head: true });
      if (column && value) query = query.eq(column, value);
      const { count: total, error } = await query;
      if (error) throw error;
      return total || 0;
    };
    const [students, educators, institutions, activeToday, simulationsCompleted, roadmapsCompleted, activityRows, users] = await Promise.all([
      count('profiles', 'role', 'student'), count('profiles', 'role', 'educator'), count('institutions'),
      count('user_activity_days', 'activity_date', today),
      count('simulation_sessions', 'status', 'completed'), count('student_roadmaps', 'selection_status', 'completed'),
      admin.from('user_activity_days').select('user_id').gte('activity_date', monthStartDate).order('activity_date').limit(50000),
      count('profiles'),
    ]);
    if (activityRows.error) throw activityRows.error;
    const uniqueMonthlyUsers = new Set((activityRows.data || []).map(row => row.user_id)).size;
    const capped = (activityRows.data || []).length === 50000;
    return NextResponse.json({
      totalStudents: students, totalEducators: educators, totalInstitutions: institutions,
      activeUsers: activeToday, dailyActiveUsers: activeToday, monthlyActiveUsers: uniqueMonthlyUsers,
      monthlyActiveUsersCapped: capped, totalUsers: users, simulationsCompleted, roadmapsCompleted,
      usageEventsLast30Days: (activityRows.data || []).length,
    }, { headers: { 'Cache-Control': 'private, no-store' } });
  } catch {
    return NextResponse.json({ error: 'Could not load platform analytics.' }, { status: 503 });
  }
}
