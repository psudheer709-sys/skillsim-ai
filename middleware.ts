import { createServerClient } from '@supabase/ssr';
import { NextResponse, type NextRequest } from 'next/server';
import { getSupabaseConfig } from '@/lib/supabase/config';

const protectedPaths = [
  '/dashboard','/career-roadmaps','/roadmap-details','/roadmap-preferences','/learning-path','/topic',
  '/simulations','/simulation','/mistake-dna','/recommendations','/skill-passport','/submissions',
  '/achievements','/profile','/settings','/educator','/admin','/institutions','/career-engine',
  '/reset-password',
];
function isProtected(pathname: string) { return protectedPaths.some(path => pathname === path || pathname.startsWith(`${path}/`)); }
function safeDestination(value: string | null, fallback = '/dashboard') {
  return value && value.startsWith('/') && !value.startsWith('//') && !value.startsWith('/\\') ? value : fallback;
}

export async function middleware(request: NextRequest) {
  const { pathname } = request.nextUrl;
  const protectedRoute = isProtected(pathname);
  const config = getSupabaseConfig();
  if (!config) {
    if (!protectedRoute) return NextResponse.next();
    const url = request.nextUrl.clone();
    url.pathname = '/login';
    url.searchParams.set('setup', 'required');
    url.searchParams.set('next', safeDestination(`${pathname}${request.nextUrl.search}`));
    return NextResponse.redirect(url);
  }

  let response = NextResponse.next({ request });
  const supabase = createServerClient(config.url, config.publicKey, {
    cookies: {
      getAll() { return request.cookies.getAll(); },
      setAll(cookiesToSet) {
        for (const { name, value } of cookiesToSet) request.cookies.set(name, value);
        response = NextResponse.next({ request });
        for (const { name, value, options } of cookiesToSet) response.cookies.set(name, value, options);
      },
    },
  });
  const { data: claimsResult, error: claimsError } = await supabase.auth.getClaims();
  const userId = typeof claimsResult?.claims?.sub === 'string' ? claimsResult.claims.sub : null;
  if (!userId || claimsError) {
    if (!protectedRoute) return response;
    const url = request.nextUrl.clone();
    url.pathname = '/login';
    url.searchParams.set('next', safeDestination(`${pathname}${request.nextUrl.search}`));
    return NextResponse.redirect(url);
  }

  const { data: profile, error: profileError } = await supabase.from('profiles').select('role,account_status').eq('id', userId).maybeSingle();
  if (protectedRoute && (profileError || !profile)) {
    const url = request.nextUrl.clone();
    url.pathname = '/login';
    url.searchParams.set('reason', profileError ? 'profile-unavailable' : 'profile-missing');
    return NextResponse.redirect(url);
  }
  if (profile?.account_status === 'suspended' && pathname !== '/account-suspended') {
    const url = request.nextUrl.clone(); url.pathname = '/account-suspended'; url.search = ''; return NextResponse.redirect(url);
  }
  const role = profile?.role as string | undefined;
  if (pathname === '/dashboard' && role === 'administrator') {
    const url = request.nextUrl.clone(); url.pathname = '/admin'; return NextResponse.redirect(url);
  }
  if (pathname.startsWith('/admin') && role !== 'administrator') {
    const url = request.nextUrl.clone(); url.pathname = role === 'educator' ? '/educator' : '/dashboard'; return NextResponse.redirect(url);
  }
  if (pathname.startsWith('/educator') && !['educator','administrator'].includes(role || '')) {
    const url = request.nextUrl.clone(); url.pathname = '/dashboard'; return NextResponse.redirect(url);
  }
  if ((pathname === '/login' || pathname === '/register') && role) {
    const next = safeDestination(request.nextUrl.searchParams.get('next'), role === 'educator' ? '/educator' : role === 'administrator' ? '/admin' : '/dashboard');
    const url = request.nextUrl.clone(); url.pathname = next; url.search = ''; return NextResponse.redirect(url);
  }
  return response;
}

export const config = { matcher: ['/((?!_next/static|_next/image|favicon.ico|.*\\.(?:svg|png|jpg|jpeg|gif|webp)$).*)'] };
