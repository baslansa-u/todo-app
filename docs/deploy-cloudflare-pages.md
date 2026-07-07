# Deploy to Cloudflare Pages

Use Cloudflare Pages Git integration for this Flutter web app.

## Cloudflare Pages settings

- Framework preset: `None`
- Production branch: `main` or your default GitHub branch
- Build command: `bash tool/cloudflare_pages_build.sh`
- Build output directory: `build/web`
- Root directory: leave empty

## Optional environment variables

- `FLUTTER_VERSION`: `3.35.0`

The build script installs Flutter in the Cloudflare build container, runs
`flutter pub get`, runs the test suite, and builds the web app.

After setup, every push to the production branch triggers a new production
deployment. Other branches are used for preview deployments.
