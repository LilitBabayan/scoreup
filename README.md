# Score Up Web

A web version of a personal credit score app: score gauge, 12-month trend, loans, credit checks, guarantees and alerts.

**Demo only.** All data is mock data and sign-up is simulated (demo code `123456`). Nothing is sent to a server and no real credit bureau is connected.

## Run locally

Open `index.html` in a browser, or serve the folder:

```bash
python3 -m http.server 8000
```

## Deploy

It is a single static file, so Vercel needs no build step: import the repo and deploy with the default settings.
