insert into profiles (id, name) values
  ('admin', 'Administrador'),
  ('semed', 'SEMED'),
  ('diretoria-semed', 'Diretoria SEMED'),
  ('crei', 'CREI'),
  ('unidade', 'Unidade de Ensino'),
  ('assessoria', 'Assessoria')
on conflict (id) do update set name = excluded.name;

insert into units (id, name, type, city, active) values
  ('admin', 'Administracao SEMED', 'Administracao', 'Uberaba', true)
on conflict (id) do update set
  name = excluded.name,
  type = excluded.type,
  city = excluded.city,
  active = excluded.active,
  updated_at = now();

insert into users (id, name, email, password, profile_id, unit_id, active) values
  ('u-admin', 'Admin Sistema', 'admin@semed.local', 'Admin@123', 'admin', 'admin', true)
on conflict (id) do update set
  name = excluded.name,
  email = excluded.email,
  password = excluded.password,
  profile_id = excluded.profile_id,
  unit_id = excluded.unit_id,
  active = excluded.active,
  updated_at = now();

insert into cid10 (code, description, active) values
  ('F84.0', 'Autismo infantil', true),
  ('F84.1', 'Autismo atipico', true),
  ('F84.5', 'Sindrome de Asperger', true),
  ('F81.0', 'Transtorno especifico de leitura', true),
  ('F81.1', 'Transtorno especifico da soletracao', true),
  ('F81.2', 'Transtorno especifico da habilidade em aritmetica', true),
  ('F90.0', 'Transtorno da atividade e da atencao', true),
  ('F70', 'Deficiencia intelectual leve', true),
  ('F71', 'Deficiencia intelectual moderada', true),
  ('H54', 'Cegueira e visao subnormal', true),
  ('H90', 'Perda de audicao por transtorno de conducao e/ou neurossensorial', true),
  ('G80', 'Paralisia cerebral', true),
  ('E34', 'Outros transtornos endocrinos', true),
  ('E40', 'Kwashiorkor', true),
  ('E41', 'Marasmo nutricional', true),
  ('E42', 'Kwashiorkor marasmatico', true),
  ('E43', 'Desnutricao proteico-calorica grave', true),
  ('E44', 'Desnutricao proteico-calorica moderada e leve', true)
on conflict (code) do update set
  description = excluded.description,
  active = excluded.active;

insert into access_settings (profile_id, settings) values
  ('admin', '{"fields":{"studentFields":true,"medicalFields":true,"requests":true,"supportTeachers":true,"assignments":true,"pei":true,"reports":true,"users":true,"units":true}}'::jsonb),
  ('semed', '{"fields":{"studentFields":true}}'::jsonb),
  ('diretoria-semed', '{"fields":{"studentFields":true}}'::jsonb),
  ('crei', '{"fields":{"studentFields":true}}'::jsonb),
  ('unidade', '{"fields":{"studentFields":true}}'::jsonb),
  ('assessoria', '{"fields":{"studentFields":true}}'::jsonb)
on conflict (profile_id) do update set
  settings = excluded.settings,
  updated_at = now();
