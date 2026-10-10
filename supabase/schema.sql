-- Score Up database schema.
-- Run once in Supabase: SQL Editor > New query > paste this file > Run.

-- One row per registered user, filled in after they verify their email code.
create table if not exists public.profiles (
  id          uuid primary key references auth.users (id) on delete cascade,
  full_name   text not null check (char_length(full_name) between 2 and 120),
  email       text not null,
  phone       text not null check (char_length(phone) between 8 and 20),
  consent_at  timestamptz not null default now(),
  created_at  timestamptz not null default now()
);

-- What each user changed in the app: loan reminders, loans marked as paid, alerts marked as read.
create table if not exists public.user_state (
  user_id      uuid primary key references auth.users (id) on delete cascade,
  reminders    jsonb  not null default '{}'::jsonb,
  paid_loans   text[] not null default '{}',
  read_alerts  text[] not null default '{}',
  updated_at   timestamptz not null default now()
);

-- Row level security: a signed-in user can only see and change their own rows.
alter table public.profiles   enable row level security;
alter table public.user_state enable row level security;

drop policy if exists "Own profile: read"   on public.profiles;
drop policy if exists "Own profile: insert" on public.profiles;
drop policy if exists "Own profile: update" on public.profiles;
create policy "Own profile: read"   on public.profiles for select to authenticated using (auth.uid() = id);
create policy "Own profile: insert" on public.profiles for insert to authenticated with check (auth.uid() = id);
create policy "Own profile: update" on public.profiles for update to authenticated using (auth.uid() = id) with check (auth.uid() = id);

drop policy if exists "Own state: read"   on public.user_state;
drop policy if exists "Own state: insert" on public.user_state;
drop policy if exists "Own state: update" on public.user_state;
create policy "Own state: read"   on public.user_state for select to authenticated using (auth.uid() = user_id);
create policy "Own state: insert" on public.user_state for insert to authenticated with check (auth.uid() = user_id);
create policy "Own state: update" on public.user_state for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);

grant select, insert, update on public.profiles, public.user_state to authenticated;
