-- Run this whole file once in Supabase → SQL Editor
create table profiles(id uuid primary key references auth.users on delete cascade,
  username text not null check (username ~ '^[A-Za-z0-9_]{3,20}$'), created_at timestamptz default now());
create unique index profiles_username_key on profiles(lower(username));   -- no username can be used twice

create function handle_new_user() returns trigger language plpgsql security definer set search_path=public as $$
begin insert into profiles(id,username) values(new.id,new.raw_user_meta_data->>'username'); return new; end $$;
create trigger on_signup after insert on auth.users for each row execute function handle_new_user();

create function username_available(n text) returns boolean language sql security definer set search_path=public as
$$ select not exists(select 1 from profiles where lower(username)=lower(n)) $$;
grant execute on function username_available to anon, authenticated;

create table papers(id bigserial primary key, sub text not null, kind text not null check(kind in('paper','sol')),
  year text not null check(year ~ '^\d{4}$'), title text not null check(length(title)<=120), file_path text not null,
  user_id uuid, username text, created_at timestamptz default now());
create table votes(id bigserial primary key, pid bigint not null references papers on delete cascade,
  user_id uuid, username text, unique(pid,user_id));
create table events(id bigserial primary key, title text not null check(length(title)<=120), description text default '',
  start_date date not null, end_date date not null, check(end_date>=start_date),
  user_id uuid, username text, created_at timestamptz default now());
create table threads(id bigserial primary key, body text not null check(length(body)<=2000), parent_id bigint,
  user_id uuid, username text, created_at timestamptz default now());

-- uploader's name + id are stamped by the database, so they cannot be faked
create function stamp() returns trigger language plpgsql security definer set search_path=public as $$
begin new.user_id:=auth.uid(); new.username:=(select username from profiles where id=auth.uid()); return new; end $$;
create trigger s1 before insert on papers  for each row execute function stamp();
create trigger s2 before insert on votes   for each row execute function stamp();
create trigger s3 before insert on events  for each row execute function stamp();
create trigger s4 before insert on threads for each row execute function stamp();

alter table profiles enable row level security; alter table papers enable row level security;
alter table votes enable row level security; alter table events enable row level security; alter table threads enable row level security;
-- anyone (even logged out) can read; only logged-in users can write; emails are never exposed (they live in auth.users)
create policy r on profiles for select using(true);
create policy r on papers  for select using(true);
create policy r on votes   for select using(true);
create policy r on threads for select using(true);
create policy r on events  for select using(end_date>=current_date);   -- expired events vanish automatically
create policy w on papers  for insert to authenticated with check(user_id=auth.uid());
create policy w on votes   for insert to authenticated with check(user_id=auth.uid());
create policy w on events  for insert to authenticated with check(user_id=auth.uid());
create policy w on threads for insert to authenticated with check(user_id=auth.uid());
create policy d on papers  for delete to authenticated using(user_id=auth.uid());
create policy d on votes   for delete to authenticated using(user_id=auth.uid());
create policy d on events  for delete to authenticated using(user_id=auth.uid());
create policy d on threads for delete to authenticated using(user_id=auth.uid());

insert into storage.buckets(id,name,public,file_size_limit,allowed_mime_types)
 values('papers','papers',true,20971520,array['application/pdf']) on conflict do nothing;
create policy up on storage.objects for insert to authenticated
 with check(bucket_id='papers' and (storage.foldername(name))[1]=auth.uid()::text);
