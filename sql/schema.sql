create extension if not exists pgcrypto;

create table if not exists profiles (
  id text primary key,
  name text not null
);

create table if not exists units (
  id text primary key,
  name text not null,
  type text,
  city text,
  active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists users (
  id text primary key,
  name text not null,
  email text not null unique,
  password text not null,
  profile_id text not null references profiles(id),
  unit_id text references units(id),
  active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists cid10 (
  code text primary key,
  description text not null,
  active boolean not null default true
);

create table if not exists students (
  id text primary key,
  unit_id text not null references units(id),
  name text not null,
  enrollment text,
  grade text,
  class_group text,
  birth_date date,
  regular_teacher text,
  attends_aee text,
  has_report text,
  report_file_name text,
  cid_primary text references cid10(code),
  cid_secondary_1 text references cid10(code),
  cid_secondary_2 text references cid10(code),
  uses_medication text,
  medications text,
  inclusion jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists teachers (
  id text primary key,
  name text not null,
  document text,
  email text,
  phone text,
  unit_id text references units(id),
  active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists assignments (
  id text primary key,
  teacher_id text not null references teachers(id) on delete cascade,
  student_id text not null references students(id) on delete cascade,
  unit_id text references units(id),
  start_time time,
  end_time time,
  active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (teacher_id, student_id)
);

create table if not exists requests (
  id text primary key,
  student_id text not null references students(id) on delete cascade,
  unit_id text references units(id),
  priority text not null default 'Normal',
  status text not null default 'Aberta',
  observations text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists pei (
  id text primary key,
  student_id text not null references students(id) on delete cascade,
  unit_id text references units(id),
  goals text,
  interventions text,
  evaluation text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists access_settings (
  profile_id text primary key references profiles(id),
  settings jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

-- Compatibilidade com o app atual, que sincroniza um payload unico.
create table if not exists app_snapshots (
  id text primary key,
  payload jsonb not null,
  updated_at timestamptz not null default now()
);

create index if not exists idx_students_unit_id on students(unit_id);
create index if not exists idx_teachers_unit_id on teachers(unit_id);
create index if not exists idx_assignments_teacher_id on assignments(teacher_id);
create index if not exists idx_assignments_student_id on assignments(student_id);
create index if not exists idx_requests_student_id on requests(student_id);
create index if not exists idx_pei_student_id on pei(student_id);
