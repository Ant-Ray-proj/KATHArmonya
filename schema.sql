-- Run this in Supabase: SQL Editor > New query > Run

create table if not exists public.registrations (
  id uuid primary key default gen_random_uuid(),
  name text not null check (char_length(name) between 2 and 100),
  contact_number text not null check (contact_number ~ '^\+?[0-9]{7,15}$'),
  created_at timestamptz not null default now()
);

-- Prevent the same number registering twice
create unique index if not exists registrations_contact_unique
  on public.registrations (contact_number);

alter table public.registrations enable row level security;

-- Anyone (the public form) can ONLY add a row
create policy "public can register" on public.registrations
  for insert to anon, authenticated
  with check (true);

-- Only the signed-in admin can read or delete
create policy "admin can read" on public.registrations
  for select to authenticated using (true);

create policy "admin can delete" on public.registrations
  for delete to authenticated using (true);


-- Attendee event feedback (public submissions; only signed-in admins can read/delete)
create table if not exists public.feedback (
  id uuid primary key default gen_random_uuid(),
  attendee_name text check (attendee_name is null or char_length(attendee_name) <= 100),
  overall_rating integer not null check (overall_rating between 1 and 5),
  program_rating integer check (program_rating is null or program_rating between 1 and 5),
  venue_rating integer check (venue_rating is null or venue_rating between 1 and 5),
  comments text check (comments is null or char_length(comments) <= 3000),
  created_at timestamptz not null default now()
);

alter table public.feedback enable row level security;
drop policy if exists "public can submit feedback" on public.feedback;
drop policy if exists "admin can read feedback" on public.feedback;
drop policy if exists "admin can delete feedback" on public.feedback;
create policy "public can submit feedback" on public.feedback
  for insert to anon, authenticated with check (true);
create policy "admin can read feedback" on public.feedback
  for select to authenticated using (true);
create policy "admin can delete feedback" on public.feedback
  for delete to authenticated using (true);
