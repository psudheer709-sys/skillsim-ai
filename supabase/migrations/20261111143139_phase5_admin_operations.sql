-- Phase 5 foundation: real platform activity, announcements, settings and
-- administrator audit events. Privileged writes remain server-only.
alter table public.profiles
  add column if not exists account_status text not null default 'active'
  check (account_status in ('active','suspended'));

create table if not exists public.user_activity_days (
  user_id uuid not null references public.profiles(id) on delete cascade,
  activity_date date not null default current_date,
  login_count integer not null default 1 check (login_count > 0),
  last_seen_at timestamptz not null default now(),
  primary key(user_id, activity_date)
);
create index if not exists user_activity_days_date_idx on public.user_activity_days(activity_date desc);
alter table public.user_activity_days enable row level security;
revoke all on public.user_activity_days from anon, authenticated;
grant all on public.user_activity_days to service_role;

create table if not exists public.platform_announcements (
  id uuid primary key default gen_random_uuid(),
  title text not null check(char_length(title) between 3 and 160),
  message text not null check(char_length(message) between 1 and 3000),
  created_by uuid not null references public.profiles(id) on delete restrict,
  created_at timestamptz not null default now(),
  publish_until timestamptz
);
alter table public.platform_announcements enable row level security;
create policy platform_announcements_read_published on public.platform_announcements
  for select to authenticated using (publish_until is null or publish_until > now());
grant select on public.platform_announcements to authenticated;
revoke insert, update, delete on public.platform_announcements from anon, authenticated;
grant all on public.platform_announcements to service_role;

create table if not exists public.platform_admin_audit_logs (
  id uuid primary key default gen_random_uuid(),
  actor_id uuid not null references public.profiles(id) on delete restrict,
  action text not null check(char_length(action) between 1 and 120),
  target_user_id uuid references public.profiles(id) on delete set null,
  details jsonb not null default '{}'::jsonb check(jsonb_typeof(details)='object'),
  created_at timestamptz not null default now()
);
create index if not exists platform_admin_audit_logs_created_idx on public.platform_admin_audit_logs(created_at desc);
alter table public.platform_admin_audit_logs enable row level security;
revoke all on public.platform_admin_audit_logs from anon, authenticated;
grant all on public.platform_admin_audit_logs to service_role;

create table if not exists public.platform_settings (
  setting_key text primary key check(char_length(setting_key) between 1 and 100),
  setting_value jsonb not null default '{}'::jsonb check(jsonb_typeof(setting_value)='object'),
  updated_by uuid not null references public.profiles(id) on delete restrict,
  updated_at timestamptz not null default now()
);
alter table public.platform_settings enable row level security;
revoke all on public.platform_settings from anon, authenticated;
grant all on public.platform_settings to service_role;
