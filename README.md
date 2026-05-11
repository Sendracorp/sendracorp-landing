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
├── og-image.png    # 1200×630 Open Graph / Twitter share image
├── robots.txt      # Crawler directives + sitemap pointer
├── sitemap.xml     # URL index for search engines
└── app-ads.txt     # AdMob authorized sellers (for OverSky iOS)
scripts/
├── generate-favicon.swift    # Regenerate favicon.png
└── generate-og-image.swift   # Regenerate og-image.png
vercel.json         # Output directory + headers config
```

## Deployment

Hosted on [Vercel](https://vercel.com). Connect this repo, Vercel reads `vercel.json` and serves from `public/`.

To connect a custom domain: Vercel project → Settings → Domains → add your domain. Vercel provisions HTTPS automatically.

## Regenerating images

```bash
swift scripts/generate-favicon.swift     # public/favicon.png  (32×32)
swift scripts/generate-og-image.swift    # public/og-image.png (1200×630)
```

## License

Copyright © 2026 Sendracorp. All Rights Reserved. See [LICENSE](LICENSE).
