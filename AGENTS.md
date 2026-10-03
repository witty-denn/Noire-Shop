# AGENTS.md

## Project
NOIRÉ is a Next.js e-commerce demo for HNG15 Lesson 2.

## Architecture
- App Router pages under `app/`
- Browser cart state in `components/cart-provider.tsx`
- Supabase browser client in `lib/supabase.ts`
- Supabase server client in `lib/supabase-server.ts`
- SQL schema and seed data in `supabase/schema.sql`
- Server-only checkout endpoint in `app/api/orders/route.ts`
- Google OAuth callback in `app/auth/callback/route.ts`
- Mailgun is called only from the server checkout endpoint

## Requirements
1. Shop website with product catalogue and product detail pages.
2. Checkout page.
3. Persist products/orders/order items in Supabase.
4. Send order confirmation email with Mailgun.
5. Google authentication through Supabase Auth configured with Google Cloud Console.

## Development rules
- Keep secrets in environment variables.
- Do not expose Mailgun API keys to client code.
- Do not add service-role Supabase keys to browser code.
- Validate order totals server-side before inserting an order.
- Keep UI responsive and accessible.
