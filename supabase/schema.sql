create extension if not exists "pgcrypto";

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text,
  email text,
  created_at timestamptz default now()
);

create table if not exists public.products (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  slug text unique not null,
  description text not null,
  price numeric(12,2) not null check (price >= 0),
  category text not null,
  image_url text not null,
  inventory integer not null default 0 check (inventory >= 0),
  featured boolean not null default false,
  created_at timestamptz default now()
);

create table if not exists public.orders (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete set null,
  email text not null,
  customer_name text not null,
  phone text,
  address text not null,
  city text not null,
  country text not null default 'Nigeria',
  total numeric(12,2) not null check (total >= 0),
  status text not null default 'confirmed' check (status in ('confirmed','processing','shipped','cancelled')),
  created_at timestamptz default now()
);

create table if not exists public.order_items (
  id uuid primary key default gen_random_uuid(),
  order_id uuid not null references public.orders(id) on delete cascade,
  product_id uuid references public.products(id) on delete set null,
  product_name text not null,
  quantity integer not null check (quantity > 0),
  unit_price numeric(12,2) not null check (unit_price >= 0)
);

alter table public.profiles enable row level security;
alter table public.products enable row level security;
alter table public.orders enable row level security;
alter table public.order_items enable row level security;

create policy "products are public" on public.products for select using (true);
create policy "users can read own profile" on public.profiles for select using (auth.uid() = id);
create policy "users can update own profile" on public.profiles for update using (auth.uid() = id);
create policy "users can read own orders" on public.orders for select using (auth.uid() = user_id);
create policy "users can read own order items" on public.order_items for select using (
  exists (select 1 from public.orders o where o.id = order_id and o.user_id = auth.uid())
);

create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  insert into public.profiles (id, full_name, email)
  values (new.id, coalesce(new.raw_user_meta_data->>'full_name', new.raw_user_meta_data->>'name'), new.email)
  on conflict (id) do update set full_name = excluded.full_name, email = excluded.email;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created after insert on auth.users
for each row execute procedure public.handle_new_user();

insert into public.products (name,slug,description,price,category,image_url,inventory,featured) values
('Noir Essential Tee','noir-essential-tee','A heavyweight cotton tee with a relaxed silhouette and clean tonal branding.',45000,'T-Shirts','https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?auto=format&fit=crop&w=1200&q=85',24,true),
('Studio Overshirt','studio-overshirt','Structured everyday overshirt designed for layering from studio to street.',68000,'Shirts','https://images.unsplash.com/photo-1598032895397-b9472444bf93?auto=format&fit=crop&w=1200&q=85',12,true),
('After Hours Hoodie','after-hours-hoodie','Heavyweight fleece hoodie with a refined oversized fit.',75000,'Hoodies','https://images.unsplash.com/photo-1556821840-3a63f95609a7?auto=format&fit=crop&w=1200&q=85',18,true),
('Form Straight Trousers','form-straight-trousers','Minimal straight-leg trousers with a tailored finish.',82000,'Trousers','https://images.unsplash.com/photo-1506629905607-d9c297d6f3c3?auto=format&fit=crop&w=1200&q=85',9,false),
('Mono Cap','mono-cap','Six-panel cotton cap finished with understated embroidery.',32000,'Accessories','https://images.unsplash.com/photo-1521369909029-2afed882baee?auto=format&fit=crop&w=1200&q=85',30,false),
('Atelier Tote','atelier-tote','Durable canvas carryall for daily essentials.',28000,'Accessories','https://images.unsplash.com/photo-1544816155-12df9643f363?auto=format&fit=crop&w=1200&q=85',20,false)
on conflict (slug) do nothing;
