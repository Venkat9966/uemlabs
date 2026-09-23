# UEM Labs Academy

A responsive frontend MVP for an endpoint-management learning platform.

## New in this phase

- Added `dashboard.html`, a student learning dashboard with active enrollments, progress, activity, streak, and access-expiration UI.
- Added `dashboard.css` and `dashboard.js` for the responsive dashboard and demo interactions.
- Added `database/schema.sql` with a Supabase/PostgreSQL model for profiles, courses, sections, lessons, enrollments, progress, access extensions, RLS, and course-access checks.

## Run locally

Open `index.html` or `dashboard.html` in a browser, or serve the folder:

```bash
python3 -m http.server 8000
```

The dashboard is currently demo data. To make it production-ready, create a Supabase project, run `database/schema.sql`, add the Supabase client, and replace the demo records with authenticated queries. Stripe and the admin extension workflow can then be connected to the `enrollments` and `access_events` tables.
