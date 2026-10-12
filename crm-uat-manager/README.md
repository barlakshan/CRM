# CRM UAT Manager

A simple Next.js dashboard to manage CRM pilot-run test cases, coverage, execution results and a defect register. Designed for deployment on Vercel with Supabase/PostgreSQL persistence.

## Features in this starter
- Dashboard totals for passed, failed, blocked and pending cases
- Execution progress and coverage-by-transaction-area visualizations
- Searchable/filterable test-case list
- Add/edit/delete test cases and update status inline
- CSV export of the currently filtered test cases
- Provider coverage checklist for SLIC Life/General, PIC, PLC, Dialog, Mobitel, SLT, Dialog TV, CEB, LECO and Water Board
- Defect register with example pilot issues
- Responsive layout for desktop and mobile
- Demo data mode before database connection

## Run locally
1. Install Node.js 20+.
2. Extract this folder and run:
   ```bash
   npm install
   npm run dev
   ```
3. Open `http://localhost:3000`. Without Supabase variables, the app runs in demo mode. Changes in demo mode are held in browser memory and reset on refresh.

## Connect Supabase for persistent data
1. Create a Supabase project.
2. In Supabase **SQL Editor**, run `supabase/schema.sql`.
3. Copy `.env.example` to `.env.local` and fill in your Supabase project URL and publishable/anon key.
4. Restart the dev server.
5. Deploy the project to Vercel and add the same environment variables in **Project Settings → Environment Variables**.

The schema seeds example cases and defects. The browser loads those database rows when Supabase is configured.

## Deploy to Vercel
1. Push this folder to a GitHub repository.
2. In Vercel, choose **Add New → Project** and import the repository.
3. Add `NEXT_PUBLIC_SUPABASE_URL` and `NEXT_PUBLIC_SUPABASE_ANON_KEY`.
4. Deploy.

## Important security note
This is a starter/prototype, not approved for production banking data. The included SQL policies intentionally allow anonymous demo CRUD for ease of setup. Before entering real internal test results, account details, transaction references, screenshots or other confidential information, configure Supabase Auth, restrict access to authorized team members, and replace the demo row-level-security policies with appropriate authenticated/team-based policies. Do not use a Supabase service-role key in any `NEXT_PUBLIC_` variable. Confirm the bank's approval for hosting internal data on external cloud services before deployment.

## Scope / data model
Test cases store: case ID, title, transaction type, provider, channel, environment, priority, status, expected result, actual result, tester, linked defect ID and notes. Demo records reflect previously discussed CRM pilot issues and are examples; verify against the current official test workbook and defect register before using them for sign-off.
