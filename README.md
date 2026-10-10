# Score Up Web

A web version of a personal credit score app: score gauge, 12-month trend, loans, credit checks, guarantees, alerts, a loan calculator (annuity or differentiated repayment), credit tips and a profile page. The interface is in Armenian (default), English and Russian; the choice is remembered in the browser (`scoreup-lang`).

Scores, loans, checks, guarantees and alerts are sample data; no real credit bureau is connected.

## Registration and database (Supabase)

Sign-up sends a real 6-digit code by email and saves each user's profile (name, email, phone, consent) and their actions (loan reminders, loans marked as paid, alerts read) in a Supabase Postgres database.

1. Create a free project at [supabase.com](https://supabase.com).
2. In **SQL Editor**, run [`supabase/schema.sql`](supabase/schema.sql). It creates the `profiles` and `user_state` tables with row level security, so each user can only read and change their own rows.
3. In **Authentication > Emails**, edit the **Magic Link** and **Confirm signup** templates so the email shows the code: add `{{ .Token }}` to the body.
4. In **Authentication > URL Configuration**, set **Site URL** to your Vercel address.
5. In **Project Settings > API**, copy the **Project URL** and the **anon** (or publishable) key into `SUPABASE_URL` and `SUPABASE_KEY` at the top of the script in `index.html`. Both are meant to be public; the row level security is what protects the data.

Supabase's built-in email sender allows only a few emails per hour. For real users, add your own SMTP provider under **Authentication > Emails > SMTP Settings**.

### Bank comparison and applications

The **Compare** tab ranks sample bank offers for an amount, period and loan type, and each card has an **Apply** button. An application (contact details, monthly income, employment, the chosen offer) is saved to the `applications` table, or to the browser in demo mode, and listed under **Profile > My applications**. **It is not sent to the bank.** The offers in `OFFERS` are made-up sample rates; real submissions and real rates need agreements and data feeds with the banks.

If `SUPABASE_URL` and `SUPABASE_KEY` are empty, the app runs in demo mode: the code is always `123456` and everything is kept in the browser's local storage.

## Run locally

Open `index.html` in a browser, or serve the folder:

```bash
python3 -m http.server 8000
```

## Deploy

It is a single static file, so Vercel needs no build step: import the repo and deploy with the default settings.
