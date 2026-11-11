-- Phase 5 institution onboarding and organization-isolated learning records.
create table if not exists public.institutions (
  id uuid primary key default gen_random_uuid(),
  name text not null check(char_length(name) between 2 and 180),
  slug text not null unique check(slug ~ '^[a-z0-9]+(-[a-z0-9]+)*$'),
  domain text, website text, description text not null default '',
  status text not null default 'pending' check(status in ('pending','verified','suspended')),
  created_by uuid not null references public.profiles(id) on delete restrict,
  verified_by uuid references public.profiles(id) on delete set null,
  verified_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create table if not exists public.institution_members (
  institution_id uuid not null references public.institutions(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  role text not null check(role in ('institution_admin','educator','student')),
  status text not null default 'active' check(status in ('pending','active','suspended')),
  invited_by uuid references public.profiles(id) on delete set null,
  joined_at timestamptz not null default now(),
  primary key(institution_id,user_id)
);
create table if not exists public.institution_departments (
  id uuid primary key default gen_random_uuid(),
  institution_id uuid not null references public.institutions(id) on delete cascade,
  name text not null check(char_length(name) between 2 and 120),
  created_by uuid not null references public.profiles(id) on delete restrict,
  created_at timestamptz not null default now(), unique(institution_id,name)
);
create table if not exists public.institution_batches (
  id uuid primary key default gen_random_uuid(),
  institution_id uuid not null references public.institutions(id) on delete cascade,
  department_id uuid references public.institution_departments(id) on delete set null,
  name text not null check(char_length(name) between 2 and 120),
  starts_on date, ends_on date, created_at timestamptz not null default now(),
  unique(institution_id,name)
);
create table if not exists public.institution_roadmap_assignments (
  id uuid primary key default gen_random_uuid(),
  institution_id uuid not null references public.institutions(id) on delete cascade,
  roadmap_id uuid not null references public.roadmaps(id) on delete cascade,
  assigned_by uuid not null references public.profiles(id) on delete restrict,
  batch_id uuid references public.institution_batches(id) on delete cascade,
  due_at timestamptz, created_at timestamptz not null default now(),
  unique(institution_id,roadmap_id,batch_id)
);
create index if not exists institution_members_user_idx on public.institution_members(user_id,status);
create index if not exists institutions_status_created_idx on public.institutions(status,created_at desc);

create schema if not exists app_private;
revoke all on schema app_private from public,anon,authenticated;
grant usage on schema app_private to authenticated;
create or replace function app_private.is_institution_member(target_institution uuid)
returns boolean language sql stable security definer set search_path=''
as $$ select auth.uid() is not null and exists(select 1 from public.institution_members m where m.institution_id=target_institution and m.user_id=auth.uid() and m.status='active'); $$;
create or replace function app_private.is_institution_admin(target_institution uuid)
returns boolean language sql stable security definer set search_path=''
as $$ select auth.uid() is not null and exists(select 1 from public.institution_members m where m.institution_id=target_institution and m.user_id=auth.uid() and m.role='institution_admin' and m.status='active'); $$;
revoke all on function app_private.is_institution_member(uuid) from public,anon,authenticated;
revoke all on function app_private.is_institution_admin(uuid) from public,anon,authenticated;
grant execute on function app_private.is_institution_member(uuid) to authenticated;
grant execute on function app_private.is_institution_admin(uuid) to authenticated;

alter table public.institutions enable row level security;
alter table public.institution_members enable row level security;
alter table public.institution_departments enable row level security;
alter table public.institution_batches enable row level security;
alter table public.institution_roadmap_assignments enable row level security;
create policy institution_read_members on public.institutions for select to authenticated using(app_private.is_institution_member(id) or public.is_administrator());
create policy institution_request_insert on public.institutions for insert to authenticated with check(created_by=(select auth.uid()) and status='pending');
create policy institution_update_admin on public.institutions for update to authenticated using(app_private.is_institution_admin(id) or public.is_administrator()) with check(app_private.is_institution_admin(id) or public.is_administrator());
create policy institution_members_read_scope on public.institution_members for select to authenticated using(user_id=(select auth.uid()) or app_private.is_institution_admin(institution_id) or public.is_administrator());
create policy institution_members_admin_manage on public.institution_members for all to authenticated using(app_private.is_institution_admin(institution_id) or public.is_administrator()) with check(app_private.is_institution_admin(institution_id) or public.is_administrator());
create policy institution_departments_read_scope on public.institution_departments for select to authenticated using(app_private.is_institution_member(institution_id) or public.is_administrator());
create policy institution_departments_admin_manage on public.institution_departments for all to authenticated using(app_private.is_institution_admin(institution_id) or public.is_administrator()) with check(app_private.is_institution_admin(institution_id) or public.is_administrator());
create policy institution_batches_read_scope on public.institution_batches for select to authenticated using(app_private.is_institution_member(institution_id) or public.is_administrator());
create policy institution_batches_admin_manage on public.institution_batches for all to authenticated using(app_private.is_institution_admin(institution_id) or public.is_administrator()) with check(app_private.is_institution_admin(institution_id) or public.is_administrator());
create policy institution_roadmaps_read_scope on public.institution_roadmap_assignments for select to authenticated using(app_private.is_institution_member(institution_id) or public.is_administrator());
create policy institution_roadmaps_admin_manage on public.institution_roadmap_assignments for all to authenticated using(app_private.is_institution_admin(institution_id) or public.is_administrator()) with check(app_private.is_institution_admin(institution_id) or public.is_administrator());
grant select,insert,update on public.institutions to authenticated;
grant select,insert,update,delete on public.institution_members,public.institution_departments,public.institution_batches,public.institution_roadmap_assignments to authenticated;
grant all on public.institutions,public.institution_members,public.institution_departments,public.institution_batches,public.institution_roadmap_assignments to service_role;
