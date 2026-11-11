'use client';

import { useMemo, useState } from 'react';

type LabKind = 'algorithms' | 'web' | 'ai' | 'data' | 'security' | 'cloud' | 'mobile';

function getLabKind(roadmap: string, topic: string): LabKind {
  const path = roadmap.toLowerCase();
  const lesson = topic.toLowerCase();
  if (path.includes('dsa')) return 'algorithms';
  if (path.includes('cyber')) return 'security';
  if (path.includes('cloud') || path.includes('devops')) return 'cloud';
  if (path.includes('data science')) return 'data';
  if (path.includes('artificial intelligence') || path.includes('machine learning')) return 'ai';
  if (path.includes('app development') || path.includes('mobile')) return 'mobile';
  if (path.includes('web') || /html|css|javascript|react|frontend|backend|api/i.test(lesson)) return 'web';
  return 'data';
}

const shell = 'mt-5 rounded-xl border border-emerald-300/15 bg-emerald-300/[.035] p-4 sm:p-5';
const input = 'rounded-lg border border-white/10 bg-[#080b18] px-3 py-2 text-xs text-slate-100 outline-none focus:border-emerald-300/40';
const button = 'rounded-lg bg-emerald-300/15 px-3 py-2 text-xs font-semibold text-emerald-100 hover:bg-emerald-300/25';

export function RoadmapPracticeLab({ roadmapTitle, topicTitle }: { roadmapTitle: string; topicTitle: string }) {
  const kind = getLabKind(roadmapTitle, topicTitle);
  const [numbers, setNumbers] = useState('8, 3, 6, 1');
  const [target, setTarget] = useState('6');
  const [algorithmResult, setAlgorithmResult] = useState('Change the values, choose an operation, and run it.');
  const [scores, setScores] = useState('70, 80, 90');
  const [threshold, setThreshold] = useState('75');
  const [secureOptions, setSecureOptions] = useState<string[]>([]);
  const [replicas, setReplicas] = useState(2);
  const [healthy, setHealthy] = useState(true);
  const [count, setCount] = useState(0);
  const [learnerName, setLearnerName] = useState('Asha');
  const [taskDone, setTaskDone] = useState(false);
  const safeNumbers = useMemo(() => numbers.split(',').map(Number).filter(Number.isFinite), [numbers]);
  const safeScores = useMemo(() => scores.split(',').map(Number).filter((score) => Number.isFinite(score) && score >= 0 && score <= 100), [scores]);

  const header = <div><h2 className="text-sm font-semibold text-emerald-100">Do it yourself · {roadmapTitle}</h2><p className="mt-1 max-w-3xl text-xs leading-5 text-slate-400">Try the small interactive lab for <span className="text-slate-300">{topicTitle}</span>. Change something, run or interact with it, and notice what changes.</p></div>;

  return <section className={shell}>
    {header}
    {kind === 'algorithms' && <div className="mt-4 space-y-3">
      <p className="text-xs text-slate-300">Practice arrays, searching, and sorting with your own numbers.</p>
      <div className="grid gap-3 sm:grid-cols-[1fr_8rem_auto_auto] sm:items-end">
        <label className="text-[11px] text-slate-400">Numbers (comma separated)<input aria-label="Numbers for algorithm practice" className={`${input} mt-1 w-full`} value={numbers} onChange={(e) => setNumbers(e.target.value)} /></label>
        <label className="text-[11px] text-slate-400">Find number<input aria-label="Number to search for" className={`${input} mt-1 w-full`} value={target} onChange={(e) => setTarget(e.target.value)} /></label>
        <button className={button} onClick={() => setAlgorithmResult(`Sorted: ${[...safeNumbers].sort((a, b) => a - b).join(', ')}`)}>Sort</button>
        <button className={button} onClick={() => { const index = safeNumbers.indexOf(Number(target)); setAlgorithmResult(index < 0 ? `${target} was not found. Try a value from the list.` : `Found ${target} at position ${index + 1} (counting from 1).`); }}>Search</button>
      </div>
      <output aria-live="polite" className="block rounded-lg border border-white/[.07] bg-[#080b18] p-3 font-mono text-xs text-emerald-100">{algorithmResult}</output>
    </div>}
    {kind === 'data' && <div className="mt-4 space-y-3">
      <p className="text-xs text-slate-300">Use a tiny dataset to calculate a real result. Add or change scores and watch the average update.</p>
      <label className="block text-[11px] text-slate-400">Quiz scores from 0 to 100<input aria-label="Quiz score dataset" className={`${input} mt-1 w-full`} value={scores} onChange={(e) => setScores(e.target.value)} /></label>
      <output aria-live="polite" className="block rounded-lg border border-white/[.07] bg-[#080b18] p-3 text-xs text-emerald-100">{safeScores.length ? `There are ${safeScores.length} scores. Average: ${(safeScores.reduce((a, b) => a + b, 0) / safeScores.length).toFixed(1)}.` : 'Enter one or more scores from 0 to 100, separated by commas.'}</output>
    </div>}
    {kind === 'ai' && <div className="mt-4 space-y-3">
      <p className="text-xs text-slate-300">Experiment with a simple rule-based classifier. This is a toy model to understand thresholds, not a real trained AI model.</p>
      <label className="block text-[11px] text-slate-400">Practice scores<input aria-label="Scores for classifier" className={`${input} mt-1 w-full`} value={scores} onChange={(e) => setScores(e.target.value)} /></label>
      <label className="block text-[11px] text-slate-400">Classify as “ready” at or above: {threshold}<input aria-label="Classifier threshold" className="mt-2 block w-full accent-emerald-300" type="range" min="0" max="100" value={threshold} onChange={(e) => setThreshold(e.target.value)} /></label>
      <div className="grid gap-2 sm:grid-cols-3">{safeScores.map((score, index) => <div key={`${index}-${score}`} className="rounded-lg border border-white/[.07] bg-[#080b18] p-3 text-xs text-slate-300">Example {index + 1}: score {score} → <strong className="text-emerald-100">{score >= Number(threshold) ? 'ready' : 'needs practice'}</strong></div>)}</div>
      <p className="text-[10px] leading-4 text-slate-500">Try moving the threshold. A model’s result depends on its data and decision rule; check for unfair or incorrect results.</p>
    </div>}
    {kind === 'security' && <div className="mt-4 space-y-3">
      <p className="text-xs text-slate-300">Secure a pretend student sign-in. Select protections and see how many common safeguards you added.</p>
      <div className="grid gap-2 sm:grid-cols-2">{['Use HTTPS', 'Hash passwords securely', 'Rate-limit repeated attempts', 'Require multi-factor authentication'].map((item) => <label key={item} className="flex items-center gap-2 rounded-lg border border-white/[.07] bg-[#080b18] p-3 text-xs text-slate-300"><input type="checkbox" checked={secureOptions.includes(item)} onChange={(e) => setSecureOptions((old) => e.target.checked ? [...old, item] : old.filter((value) => value !== item))} />{item}</label>)}</div>
      <output aria-live="polite" className="block rounded-lg border border-white/[.07] bg-[#080b18] p-3 text-xs text-emerald-100">{secureOptions.length}/4 safeguards selected. {secureOptions.length === 4 ? 'Good coverage for this toy checklist; real systems need a full security review.' : 'Choose another safeguard and explain what risk it reduces.'}</output>
    </div>}
    {kind === 'cloud' && <div className="mt-4 space-y-3">
      <p className="text-xs text-slate-300">Operate a pretend web service. Change its replica count and health, then observe the availability status.</p>
      <div className="flex flex-wrap items-center gap-3 rounded-lg border border-white/[.07] bg-[#080b18] p-3 text-xs text-slate-300"><label>Running copies <select className={`${input} ml-2`} value={replicas} onChange={(e) => setReplicas(Number(e.target.value))}><option value={0}>0</option><option value={1}>1</option><option value={2}>2</option><option value={3}>3</option></select></label><label className="flex items-center gap-2"><input type="checkbox" checked={healthy} onChange={(e) => setHealthy(e.target.checked)} />Health check passes</label></div>
      <output aria-live="polite" className="block rounded-lg border border-white/[.07] bg-[#080b18] p-3 text-xs text-emerald-100">{replicas === 0 ? 'Service is unavailable: no copies are running.' : !healthy ? 'Health check failed: investigate the service before sending traffic.' : replicas === 1 ? 'One healthy copy is running, but it is a single point of failure.' : `${replicas} healthy copies are running; the service can handle one copy failing.`}</output>
    </div>}
    {kind === 'mobile' && <div className="mt-4 space-y-3">
      <p className="text-xs text-slate-300">Try state in a tiny habit counter. Tap a control and watch the screen update, just like a mobile app.</p>
      <div className="mx-auto max-w-xs rounded-2xl border border-white/10 bg-[#080b18] p-5 text-center"><p className="text-xs text-slate-400">Study sessions today</p><p aria-live="polite" className="my-4 text-4xl font-semibold text-emerald-100">{count}</p><div className="flex justify-center gap-2"><button className={button} onClick={() => setCount((value) => value + 1)}>＋ Add session</button><button className="rounded-lg border border-white/10 px-3 py-2 text-xs text-slate-300" onClick={() => setCount(0)}>Reset</button></div></div>
      <p className="text-[10px] text-slate-500">The counter is app state: each tap changes the value and updates the display.</p>
    </div>}
    {kind === 'web' && <div className="mt-4 space-y-3">
      <p className="text-xs text-slate-300">Personalize a tiny profile card and interact with its task button.</p>
      <label className="block text-[11px] text-slate-400">Your name<input aria-label="Name for profile preview" className={`${input} mt-1 w-full`} value={learnerName} onChange={(e) => setLearnerName(e.target.value)} /></label>
      <div className="rounded-xl border border-white/[.07] bg-[#080b18] p-4"><p className="text-sm font-semibold text-slate-100">Hello, {learnerName || 'learner'}!</p><p className="mt-1 text-xs text-slate-400">{taskDone ? 'You completed today’s practice.' : 'Today’s goal: complete one small practice task.'}</p><button className={`${button} mt-3`} onClick={() => setTaskDone((value) => !value)}>{taskDone ? 'Mark as not done' : 'Mark practice complete'}</button></div>
      <p className="text-[10px] text-slate-500">Change the name, click the button, and notice how the page responds. Your existing HTML, CSS, and JavaScript editor is available above for runnable code practice.</p>
    </div>}
  </section>;
}
