'use client';

import { useState } from 'react';
import { Play, RotateCcw } from 'lucide-react';

type Mode = 'html' | 'css' | 'javascript';

const starterCode: Record<Mode, string> = {
  html: '<!doctype html>\n<html lang="en">\n  <head>\n    <meta charset="utf-8">\n    <title>My first page</title>\n  </head>\n  <body>\n    <h1>My learning journey</h1>\n    <p>I am learning to build for the web.</p>\n    <a href="#practice">Visit my practice page</a>\n  </body>\n</html>',
  css: 'body {\n  font-family: system-ui, sans-serif;\n  line-height: 1.6;\n  margin: 2rem;\n}\n\nh1 {\n  color: rebeccapurple;\n}',
  javascript: 'const button = document.querySelector("#try-button");\nconst message = document.querySelector("#message");\n\nbutton.addEventListener("click", () => {\n  message.textContent = "Great job! You made this page respond.";\n});',
};

const prompts: Record<Mode, string> = {
  html: 'Change the heading to your name and the paragraph to something you enjoy. Click Run preview to see your page.',
  css: 'Change “rebeccapurple” to “teal”, then click Run preview. Try changing it back and choosing another color.',
  javascript: 'Change the message inside the quotes. Click Run preview, then click the button in the preview to see your message.',
};

function makePreview(mode: Mode, code: string) {
  if (mode === 'html') return code;
  if (mode === 'css') {
    return `<!doctype html><html><head><meta charset="utf-8"><style>${code}</style></head><body><h1>My first page</h1><p>This is a paragraph. Change the color and spacing with CSS.</p><a href="#practice">This is a link</a></body></html>`;
  }

  return `<!doctype html><html><head><meta charset="utf-8"><style>body{font:16px system-ui,sans-serif;padding:24px;color:#172033}button{padding:10px 14px;border:0;border-radius:8px;background:#6553e8;color:white;cursor:pointer}</style></head><body><h1>Try a button</h1><p id="message">Click the button to see what happens.</p><button id="try-button" type="button">Click me</button><script>${code}</script></body></html>`;
}

export function TopicPlayground({ mode }: { mode: Mode }) {
  const [code, setCode] = useState(starterCode[mode]);
  const [previewCode, setPreviewCode] = useState(starterCode[mode]);

  function run() {
    setPreviewCode(code);
  }

  function reset() {
    setCode(starterCode[mode]);
    setPreviewCode(starterCode[mode]);
  }

  return (
    <section className="mt-5 rounded-xl border border-emerald-300/15 bg-emerald-300/[.035] p-4 sm:p-5">
      <div className="flex flex-wrap items-start justify-between gap-3">
        <div>
          <h2 className="text-sm font-semibold text-emerald-100">Try it yourself</h2>
          <p className="mt-1 max-w-2xl text-xs leading-5 text-slate-400">{prompts[mode]}</p>
        </div>
        <div className="flex shrink-0 gap-2">
          <button type="button" onClick={reset} className="rounded-lg border border-white/10 px-3 py-2 text-xs text-slate-300">
            <RotateCcw size={13} className="mr-1 inline"/>Reset
          </button>
          <button type="button" onClick={run} className="rounded-lg bg-emerald-300/15 px-3 py-2 text-xs font-semibold text-emerald-100">
            <Play size={13} className="mr-1 inline"/>Run preview
          </button>
        </div>
      </div>
      <div className="mt-4 grid gap-4 lg:grid-cols-2">
        <label className="block text-xs font-medium text-slate-300">
          Your {mode === 'html' ? 'HTML' : mode === 'css' ? 'CSS' : 'JavaScript'} code
          <textarea
            aria-label={`Edit ${mode} code`}
            spellCheck={false}
            value={code}
            onChange={(event) => setCode(event.target.value)}
            className="mt-2 min-h-64 w-full resize-y rounded-lg border border-white/10 bg-[#080b18] p-3 font-mono text-[11px] leading-5 text-emerald-100 outline-none focus:border-emerald-300/40"
          />
        </label>
        <div>
          <h3 className="text-xs font-medium text-slate-300">What the browser shows</h3>
          <iframe
            title={`${mode.toUpperCase()} practice preview`}
            sandbox={mode === 'javascript' ? 'allow-scripts' : ''}
            srcDoc={makePreview(mode, previewCode)}
            className="mt-2 min-h-64 w-full rounded-lg border border-white/10 bg-white"
          />
        </div>
      </div>
      <p className="mt-3 text-[10px] leading-4 text-slate-500">Your practice runs only in this isolated preview. It does not change your account or save code.</p>
    </section>
  );
}
