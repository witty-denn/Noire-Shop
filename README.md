# NOIRÉ — HNG15 Lesson 2

A full-stack fashion shop demonstrating the HNG15 Lesson 2 requirements: shop catalogue, checkout, Supabase persistence, Mailgun confirmation email and Google authentication.

## Stack
- Next.js + TypeScript
- Supabase (Postgres + Auth)
- Google OAuth via Supabase Auth / Google Cloud Console
- Mailgun
- Vercel-ready deployment

## Local setup
1. `npm install`
2. Copy `.env.example` to `.env.local` and fill values.
3. Create a Supabase project.
4. Run `supabase/schema.sql` in the Supabase SQL editor.
5. In Supabase Auth → Providers → Google, enable Google and enter the Google OAuth client ID/secret from Google Cloud Console.
6. Add your local callback URL to Google/Supabase: `http://localhost:3000/auth/callback`.
7. Add Mailgun variables. For production, verify your sending domain in Mailgun.
8. `npm run dev`

## Production deployment
Deploy the repository to Vercel and add the same environment variables. Add `https://YOUR-DOMAIN/auth/callback` to the Google OAuth redirect configuration and set the Supabase Auth Site URL to your production URL.

## HNG requirements mapped
- Shop: `/`
- Checkout: `/checkout`
- Database persistence: Supabase tables in `supabase/schema.sql`
- Confirmation emails: `/app/api/orders/route.ts` via Mailgun
- Google auth: `/login` + `/auth/callback`

## Security notes
Never commit `.env.local` or service-role keys. This app only uses the Supabase anon key in the browser. Mailgun credentials are server-side only.
