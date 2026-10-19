# Event Registration (GitHub Pages + Supabase)

- `index.html` – participant form (name + contact number)
- `admin.html` – organizer login + table of participants (search, delete, CSV export)
- `style.css` / `polish.css` – shared styles; `polish.css` holds the typography and alignment refinements and loads last
- `config.js` – your Supabase URL, anon key, event name
- `schema.sql` – database table + security rules

## 1. Supabase
1. Create a project at supabase.com (free tier).
2. SQL Editor → paste `schema.sql` → Run.
3. Authentication → Users → **Add user** → enter your admin email + password
   (tick "Auto Confirm User"). Then Authentication → Providers → Email → turn **off "Allow new users to sign up"** so nobody else can create an account.
4. Project Settings → API → copy **Project URL** and **anon public** key into `config.js`.
   (Never put the `service_role` key in these files.)

## 2. GitHub Pages
1. Create a GitHub repo, upload all files in this folder to the root.
2. Settings → Pages → Source: **Deploy from a branch** → `main` / `(root)` → Save.
3. Your site: `https://USERNAME.github.io/REPO/` (participants) and `.../admin.html` (admin).

## Notes
- The anon key being public is fine: the rules in `schema.sql` let visitors only insert; reading needs admin login.
- Free Supabase projects pause after a week of inactivity; open the dashboard to wake it.


## Event feedback page

Open `feedback.html` for attendees to submit a 1–5 overall rating, optional program and venue ratings, and written comments. The admin dashboard has a **Feedback** category for reviewing, searching, exporting, and deleting responses.

**Database update required:** Open Supabase SQL Editor and run the added feedback-table section at the bottom of `schema.sql` (or rerun the full schema file). The feedback page will not be able to save responses until the table and row-level security policies exist. Keep the Supabase service-role key private; the site uses only the publishable/anon key.
