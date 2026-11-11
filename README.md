# SkillSim AI — Phase 2 foundation

SkillSim AI is a Next.js 15 / React 19 application with a Supabase/PostgreSQL backend. The existing Phase 1 visual experience remains in the app. Authentication and the server APIs require a Supabase project; without credentials, protected routes redirect to sign-in and API routes return a clear setup error. There is no demo sign-in path.

## Local setup

1. Install Node.js 20+ and dependencies: `npm install`.
2. Create a Supabase project and copy `.env.example` to `.env.local`.
3. Set `NEXT_PUBLIC_SUPABASE_URL` and `NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY`. Existing projects can use `NEXT_PUBLIC_SUPABASE_ANON_KEY` as a fallback. The service role key is optional for normal app use and must stay server-only.
4. Apply `supabase/migrations/202611100001_phase2_core.sql` in the Supabase SQL Editor or with `supabase db push` after linking the project.
5. Seed the current 9 roadmaps (131 topics) and 12 simulations with `npm run seed:generate`, then apply `supabase/seed.sql` in the SQL Editor. The script reads the Phase 1 TypeScript catalog and writes stable, repeatable upserts; it does not require service credentials.
6. In Supabase Auth URL configuration, add the app origin as a Site URL and allow `${APP_ORIGIN}/auth/confirm` as a redirect URL. Enable email confirmations for production.
7. Start the app with `npm run dev` and visit `/register`.

New users can self-register as students or educators. Public sign-up metadata cannot grant administrator access. Assign an administrator only from the trusted SQL Editor after verifying the user's email/UUID:

```sql
update public.profiles set role = 'administrator' where id = '<verified-auth-user-uuid>';
```

The role-change trigger blocks normal users from editing their own role. Never expose `SUPABASE_SERVICE_ROLE_KEY` in a browser variable or client component.

## Database and security

The migration creates profiles, student preferences, educator profiles and student assignments, roadmaps, stages and topics, selected roadmaps, topic and project progress, quiz attempts, weekly plans and tasks, simulations, submissions, notifications and achievements. Foreign keys, uniqueness constraints, indexes, timestamp triggers and an auth-user profile trigger are included. RLS is enabled on application tables. Student-owned rows are scoped to `auth.uid()`; educator access is limited to assigned students; administrator access is explicit. The roadmap selection RPC switches the primary path transactionally.

Authentication uses Supabase SSR cookies. The middleware refreshes sessions and checks profile roles for protected pages. Server endpoints recheck the signed-in user and role; they never trust a client-supplied user id. Signup and login include a process-local request limiter; deploy behind a distributed gateway limiter for multi-instance production.

## API routes

- Auth: `POST /api/auth/register`, `/login`, `/logout`, `/password-reset`, `/password-update`; `GET /api/auth/me`.
- Profile: `GET/PATCH /api/profile`.
- Roadmaps: `GET /api/roadmaps`, `GET /api/roadmaps/:id`, `GET/POST /api/roadmaps/selection`.
- Learning: `GET/POST /api/progress`, `POST /api/progress/projects`, `POST /api/quiz-attempts`, `GET/POST /api/plans`, `PATCH /api/plans/tasks/:id`.
- Practice: `GET /api/simulations`, `GET/POST /api/submissions`.
- Dashboards: `GET /api/dashboard/student`, `/api/dashboard/educator`.
- Notifications: `GET /api/notifications`.

Automated checks: `npm run typecheck`, `npm run test`, `npm run build`. End-to-end verification against data requires a configured Supabase project and seeded schema.

## Phase 1 browser data

Existing Phase 1 localStorage keys are not imported automatically or cleared by this backend foundation. They remain on the same browser until the user clears site data. A future account migration should explicitly preview, validate and confirm every imported record before writing it to a signed-in account.

## Current scope

Phase 3 AI evaluation, saved feedback, mistake analysis, roadmap-aware practice recommendations, conversational simulations, and history are implemented. Live AI-generated results require the server credentials in the Phase 3 setup section. Credential issuance and other advanced verification features remain out of scope.
# SkillSim AI

## Phase 3 AI setup

AI requests are made by authenticated Next.js server routes. The OpenAI key and Supabase service role key must remain server-side and must never use a `NEXT_PUBLIC_` prefix.

Add these values to the project-root `.env.local` (alongside `package.json`):

```env
OPENAI_API_KEY=
AI_MODEL=
AI_PROVIDER=openai
SUPABASE_SERVICE_ROLE_KEY=
```

Choose an `AI_MODEL` available to your OpenAI API account. The app does not silently select a model. API usage can incur provider charges. The service-role key is only used by the server to persist verified AI results; do not share it in chat or commit it. Restart the development server after updating environment values.

The text, technical, and decision modes submit responses for rubric evaluation. Technical submissions are evaluated as text and are never executed. Conversation mode uses an AI workplace character and saves the session messages. AI routes validate provider output, enforce per-user in-process rate limits, and record token usage when the provider returns it. Mistake DNA, student skill scores, recommendations, and history are computed from saved records; no sample performance scores are used in those views.

If AI credentials are absent, simulation browsing and saving submissions remain available, while evaluation and character conversation return a configuration message.

For a fresh Supabase deployment, apply `supabase/migrations/202611100002_phase3_ai.sql`, then `202611100003_phase3_sessions.sql` and `202611100004_phase3_submission_guard.sql` after the Phase 2 core migration and seed. The connected SkillSim project already has these Phase 3 migrations applied.
