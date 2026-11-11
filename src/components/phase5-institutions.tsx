'use client';

import { useState } from 'react';
import { Building2, Plus } from 'lucide-react';

async function readApiResponse(response: Response): Promise<{ error?: string }> {
  const text = await response.text();
  let data: { error?: string };
  try {
    data = text ? JSON.parse(text) as { error?: string } : {};
  } catch {
    throw new Error(`The server could not complete the request (HTTP ${response.status}).`);
  }
  if (!response.ok) throw new Error(data.error || `The server could not complete the request (HTTP ${response.status}).`);
  return data;
}

export function Phase5Institutions() {
  const [name, setName] = useState('');
  const [domain, setDomain] = useState('');
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState('');
  const [notice, setNotice] = useState('');

  async function createInstitution(event: React.FormEvent<HTMLFormElement>) {
    event.preventDefault();
    setBusy(true);
    setError('');
    setNotice('');
    try {
      const response = await fetch('/api/institutions', {
        method: 'POST',
        headers: { 'content-type': 'application/json' },
        body: JSON.stringify({ name, domain }),
      });
      await readApiResponse(response);
      setName('');
      setDomain('');
      setNotice('Institution request submitted. It will be available after platform verification.');
    } catch (cause) {
      setError(cause instanceof Error ? cause.message : 'Institution request could not be submitted.');
    } finally {
      setBusy(false);
    }
  }

  const input = 'input !mt-0';
  const button = 'btn-primary rounded-xl px-4 py-2.5 text-xs font-semibold disabled:opacity-50';

  return (
    <div className="space-y-6">
      <section className="flex flex-wrap items-end justify-between gap-4">
        <div>
          <p className="text-xs font-semibold uppercase tracking-[.18em] text-blue-300">Organization workspace</p>
          <h1 className="mt-2 text-2xl font-semibold">Institutions</h1>
          <p className="mt-2 text-sm text-slate-400">Register an institution for platform verification.</p>
        </div>
      </section>

      {error && <p role="alert" className="rounded-xl border border-red-400/20 bg-red-400/10 px-4 py-3 text-sm text-red-200">{error}</p>}
      {notice && <p role="status" className="rounded-xl border border-emerald-400/20 bg-emerald-400/10 px-4 py-3 text-sm text-emerald-200">{notice}</p>}

      <form onSubmit={createInstitution} className="glass max-w-2xl rounded-2xl p-5">
        <div className="flex items-center gap-2">
          <Building2 size={17} className="text-blue-300" />
          <h2 className="font-semibold">Register an institution</h2>
        </div>
        <p className="mt-2 text-xs leading-5 text-slate-500">New organizations begin as pending and must be verified by a platform administrator.</p>
        <div className="mt-4 grid gap-4">
          <label className="text-xs text-slate-400">Institution name
            <input required minLength={2} maxLength={180} value={name} onChange={event => setName(event.target.value)} className={input} />
          </label>
          <label className="text-xs text-slate-400">Email domain (optional)
            <input placeholder="university.edu" value={domain} onChange={event => setDomain(event.target.value)} className={input} />
          </label>
          <button disabled={busy} className={button}>
            <Plus size={14} className="mr-1 inline" />{busy ? 'Submitting…' : 'Submit for verification'}
          </button>
        </div>
      </form>
    </div>
  );
}
