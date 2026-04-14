# Sendracorp Landing

Static landing page for [sendracorp.com](https://sendracorp.com). Deployed to Vercel — every push to `main` auto-deploys.

## Local development

```bash
npx serve public
```

Opens at `http://localhost:3000`.

## Structure

```
public/
├── index.html      # Landing page (retro terminal aesthetic)
├── favicon.png     # 32×32 green "S" on dark background
└── app-ads.txt     # AdMob authorized sellers (for OverSky iOS)
scripts/
└── generate-favicon.swift   # Regenerate favicon.png
vercel.json         # Output directory + headers config
```

## Deployment

Hosted on [Vercel](https://vercel.com). Connect this repo, Vercel reads `vercel.json` and serves from `public/`.

To connect a custom domain: Vercel project → Settings → Domains → add your domain. Vercel provisions HTTPS automatically.

## Regenerating the favicon

```bash
swift scripts/generate-favicon.swift
```

Writes `public/favicon.png` (32×32 PNG).

## License

Copyright © 2026 Sendracorp. All Rights Reserved. See [LICENSE](LICENSE).
