-- UEM Labs Academy learning platform schema
-- Designed for Supabase/PostgreSQL. Run after enabling Supabase Auth.

create type public.user_role as enum ('student', 'admin');
create type public.course_status as enum ('draft', 'published', 'archived');

create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text not null default '',
  role public.user_role not null default 'student',
  status text not null default 'active',
  created_at timestamptz not null default now()
);

create table public.courses (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  slug text unique not null,
  description text not null default '',
  thumbnail_url text,
  price_cents integer not null default 0 check (price_cents >= 0),
  status public.course_status not null default 'draft',
  created_at timestamptz not null default now()
);

create table public.sections (
  id uuid primary key default gen_random_uuid(), course_id uuid not null references public.courses(id) on delete cascade,
  title text not null, position integer not null default 0
);

create table public.lessons (
  id uuid primary key default gen_random_uuid(), section_id uuid not null references public.sections(id) on delete cascade,
  title text not null, description text not null default '', youtube_video_id text,
  duration_seconds integer not null default 0, position integer not null default 0, published boolean not null default false
);

create table public.enrollments (
  id uuid primary key default gen_random_uuid(), user_id uuid not null references public.profiles(id) on delete cascade,
  course_id uuid not null references public.courses(id) on delete cascade, starts_at timestamptz not null default now(),
  expires_at timestamptz not null, status text not null default 'active', created_at timestamptz not null default now(),
  unique(user_id, course_id)
);

create table public.lesson_progress (
  user_id uuid not null references public.profiles(id) on delete cascade, lesson_id uuid not null references public.lessons(id) on delete cascade,
  completed boolean not null default false, watched_seconds integer not null default 0, updated_at timestamptz not null default now(),
  primary key(user_id, lesson_id)
);

create table public.access_events (
  id uuid primary key default gen_random_uuid(), enrollment_id uuid not null references public.enrollments(id) on delete cascade,
  admin_id uuid references public.profiles(id), days_added integer, previous_expires_at timestamptz, new_expires_at timestamptz,
  reason text, created_at timestamptz not null default now()
);

alter table public.profiles enable row level security;
alter table public.courses enable row level security;
alter table public.sections enable row level security;
alter table public.lessons enable row level security;
alter table public.enrollments enable row level security;
alter table public.lesson_progress enable row level security;
alter table public.access_events enable row level security;

create policy "Published courses are public" on public.courses for select using (status = 'published');
create policy "Students view own enrollments" on public.enrollments for select using (auth.uid() = user_id);
create policy "Students view own progress" on public.lesson_progress for select using (auth.uid() = user_id);
create policy "Students update own progress" on public.lesson_progress for insert with check (auth.uid() = user_id);
create policy "Students update progress" on public.lesson_progress for update using (auth.uid() = user_id);

create or replace function public.has_course_access(course uuid)
returns boolean language sql security definer set search_path = public as $$
  select exists (select 1 from enrollments where user_id = auth.uid() and course_id = course and starts_at <= now() and expires_at >= now() and status = 'active');
$$;
