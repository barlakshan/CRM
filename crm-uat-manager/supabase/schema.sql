-- CRM UAT Manager schema for Supabase (PostgreSQL)
-- Run this in Supabase Dashboard > SQL Editor before connecting the app.
create extension if not exists pgcrypto;

create table if not exists public.test_cases (
  id text primary key,
  case_id text not null unique,
  title text not null,
  transaction_type text not null default 'Withdrawal',
  provider text not null default 'People’s Bank',
  channel text not null default 'Card-based',
  environment text not null default 'Pilot',
  priority text not null default 'Medium',
  status text not null default 'Not Run' check (status in ('Not Run','Pass','Fail','Blocked','Retest')),
  expected_result text not null default '',
  actual_result text not null default '',
  tester text not null default '',
  defect_id text not null default '',
  notes text not null default '',
  updated_at timestamptz not null default now()
);

create table if not exists public.defects (
  id text primary key,
  defect_id text not null unique,
  title text not null,
  machine text not null default '',
  severity text not null default 'Medium',
  status text not null default 'Open',
  owner text not null default '',
  notes text not null default '',
  created_at timestamptz not null default now()
);

-- This starter is intended for a private internal pilot. Do NOT leave public write access
-- enabled for sensitive bank data. Configure Supabase Auth + per-user/team RLS policies
-- before production use. The policies below permit anonymous access only to get the demo
-- working; replace them before storing real UAT evidence or confidential information.
alter table public.test_cases enable row level security;
alter table public.defects enable row level security;
drop policy if exists "demo read test cases" on public.test_cases;
drop policy if exists "demo insert test cases" on public.test_cases;
drop policy if exists "demo update test cases" on public.test_cases;
drop policy if exists "demo delete test cases" on public.test_cases;
drop policy if exists "demo read defects" on public.defects;
create policy "demo read test cases" on public.test_cases for select using (true);
create policy "demo insert test cases" on public.test_cases for insert with check (true);
create policy "demo update test cases" on public.test_cases for update using (true) with check (true);
create policy "demo delete test cases" on public.test_cases for delete using (true);
create policy "demo read defects" on public.defects for select using (true);

insert into public.test_cases (id,case_id,title,transaction_type,provider,channel,environment,priority,status,expected_result,actual_result,tester,defect_id,notes)
values
('1','CRM-WD-001','Card-based withdrawal – People’s Bank card','Withdrawal','People’s Bank','Card-based','Pilot','High','Pass','Cash dispensed, account debited correctly and receipt printed.','Transaction completed and receipt verified.','UAT Team','','Verify host response and balancing.'),
('2','CRM-WD-002','Other-bank card withdrawal','Withdrawal','Other Bank','Card-based','Pilot','High','Blocked','Approved withdrawal completes and is reconciled.','Pending availability of staging facility.','UAT Team','','External card facility dependency.'),
('3','CRM-DEP-001','Card-based cash deposit','Deposit','People’s Bank','Card-based','Pilot','High','Pass','Accepted notes credited to the selected account; receipt matches amount.','Deposit completed; confirm reconciliation during balancing.','UAT Team','','Check denomination acceptance and CBS credit.'),
('4','CRM-DEP-002','Cardless deposit over LKR 200,000','Deposit','People’s Bank','Cardless','Pre-Prod','Critical','Pass','Reject all notes and cancel the transaction when the limit is exceeded.','Retest confirmed rejection and cancellation.','UAT Team','','Retested 23 Sep 2026.'),
('5','CRM-BP-001','Dialog bill payment – final confirmation','Bill Payment','Dialog','Card-based','Pilot','High','Fail','Confirmation displays service charge LKR 12.11 and correct total amount.','Previous test showed missing service charge and total as 0.','UAT Team','CRM-DEF-014','Recheck on current pilot build.'),
('6','CRM-BP-002','SLIC Life insurance payment','Bill Payment','SLIC Life','Cardless','Pilot','High','Blocked','Payment accepted, reference displayed and receipt printed.','Provider transaction facility unavailable for testing.','UAT Team','','Staging/provider dependency.'),
('7','CRM-BP-003','PIC insurance payment','Bill Payment','PIC','Card-based','Pilot','High','Blocked','Payment completes and is reflected in provider response and bank records.','Provider transaction not functioning in previous pilot checks.','UAT Team','','Retest when provider is available.'),
('8','CRM-BP-004','PLC insurance payment','Bill Payment','PLC','Cardless','Pilot','High','Blocked','Payment completes with correct amount and reference.','Provider transaction unavailable in previous pilot checks.','UAT Team','','Retest when provider is available.'),
('9','CRM-BP-005','Mobitel bill payment','Bill Payment','Mobitel','Card-based','Pilot','Medium','Not Run','Valid bill is paid and confirmation/receipt are correct.','','','',''),
('10','CRM-BP-006','SLT bill payment','Bill Payment','SLT','Cardless','Pilot','Medium','Not Run','Valid bill is paid and confirmation/receipt are correct.','','','',''),
('11','CRM-BP-007','Dialog TV bill payment','Bill Payment','Dialog TV','Card-based','Pilot','Medium','Not Run','Valid bill is paid and confirmation/receipt are correct.','','','',''),
('12','CRM-BP-008','CEB electricity bill payment','Bill Payment','CEB','Cardless','Pilot','Medium','Not Run','Valid bill is paid and confirmation/receipt are correct.','','','',''),
('13','CRM-BP-009','LECO electricity bill payment','Bill Payment','LECO','Card-based','Pilot','Medium','Not Run','Valid bill is paid and confirmation/receipt are correct.','','','',''),
('14','CRM-BP-010','Water bill payment','Bill Payment','Water Board','Cardless','Pilot','Medium','Not Run','Valid water bill is paid and confirmation/receipt are correct.','','','',''),
('15','CRM-OPS-001','Supervisor mode exit and service recovery','Operations','Hitachi','Machine Operations','Pilot','High','Fail','CRM returns to service promptly after supervisor/admin activity.','Delay observed when exiting Supervisor Mode.','UAT Team','CRM-DEF-018','Check after SOP/Admin operations.'),
('16','CRM-REC-001','Cash balancing after SOP and Admin operations','Reconciliation','Hitachi','Machine Operations','Pilot','Critical','Fail','Physical cash, CRM totals and host records reconcile.','Balancing discrepancy reported after SOP/Admin operations.','UAT Team','CRM-DEF-019','Finance verification required.')
on conflict (case_id) do nothing;

insert into public.defects (id,defect_id,title,machine,severity,status,owner,notes) values
('d1','CRM-DEF-014','Dialog confirmation service charge / total incorrect','Hitachi','High','Open','Vendor / IT','Service charge 12.11 missing; total displayed as 0.'),
('d2','CRM-DEF-018','Supervisor Mode exit delay','Hitachi','Medium','Open','Vendor / IT','Delay observed when returning to service.'),
('d3','CRM-DEF-019','Cash balancing discrepancy after SOP/Admin','Hitachi','Critical','Open','IT / Finance','Confirm balancing and reconciliation evidence.')
on conflict (defect_id) do nothing;
