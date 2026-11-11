'use client';

export function SuspendedAccount() {
  async function signOut() {
    await fetch('/api/auth/logout', { method: 'POST' });
    location.href = '/login';
  }
  return <main className="grid min-h-screen place-items-center bg-[#080b18] px-5 text-slate-100"><section className="glass max-w-lg rounded-2xl p-8 text-center"><h1 className="text-2xl font-semibold">Account temporarily suspended</h1><p className="mt-3 text-sm leading-6 text-slate-400">This account cannot access SkillSim AI right now. Contact your platform administrator if you believe this is a mistake.</p><button onClick={signOut} className="btn-primary mt-6 rounded-xl px-5 py-3 text-sm font-semibold">Sign out</button></section></main>;
}
