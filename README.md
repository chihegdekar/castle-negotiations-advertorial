# Castle Negotiations — Advertorial

One file: `index.html`. Open it in a browser. No build step, no dependencies (fonts load from Google Fonts).

Structure, formatting and pacing are lifted from `Reference Advertorial Page.pdf`.

**The split that matters:** the page *chrome* is branded — navy `#0F1B2D` masthead, muted gold `#C9A96A` CTAs, the Tracked Results rail. The *article itself* deliberately isn't. Inside the article: Archivo throughout (no serif, no mono), plain black text, the reference's literal `#FFFF00` marker and `#FF0000` red, bold lead-ins, and nothing else. Every list, cost breakdown, testimonial and comparison is written as normal paragraphs — no cards, no borders, no panels, no columns.

That's the whole trick: an advertorial only works while it reads as an organic blog post. **Resist the urge to prettify the body.** If something in the article starts looking designed, it's wrong.

## What maps to what

| Reference | Ours |
|---|---|
| Black masthead, "Trending in 'Health'" | Navy masthead, knight mark, "Trending in 'Procurement'" |
| Yellow highlighter | Same — `#FFFF00` (`.hl`) |
| Red money figures | Same — `#FF0000` (`.fig`), and used sparingly like the reference: six villain numbers only, everything else plain bold |
| ★★★★☆ 3,791 Ratings | ⭐️⭐️⭐️⭐️⭐️ 10,000+ pros trained |
| Bold sans headline, italic dek | Same — Archivo, no serif in the article |
| Cost breakdowns, testimonials, paths as plain text | Same — plain paragraphs with bold lead-ins |
| Yellow CTA button, grey scrim | Gold CTA button, navy scrim |
| Star-rating sidebar | Tracked Results panel — savings, headcount, refund rate, by-outcome meters |
| Blue guarantee badges | Gold seal placeholder in the guarantee section |
| Facebook comment thread + Summer Sale box | Dropped (your call) |

## Before it goes live

1. **Swap the CTA links.** Every button is `href="#book"` — 8 of them. Find/replace with the real booking URL.
2. **Drop in the images.** 15 placeholder slots, each labelled with a slug (`HERO A`, `IMAGE 4B`…) and a note describing what belongs there. Replace the `<div class="ph-cell">…</div>` with `<img src="…" alt="…">` — the gold-gap frame handles the rest. Hero A takes a video if you want one.
3. **Headshot.** The dashed circle in the byline (`.avatar`) wants Ruth's photo.
4. **Legal.** Terms / Privacy / Contact links are stubs. The business disclaimer is a first draft written to mirror the reference's health disclaimer — get it checked.

## Notes

- On mobile the Tracked Results panel falls to the bottom of the page, just before the disclaimer. If you want it higher, say so and I'll duplicate it under the hero for small screens.
- The 1997 loss-aversion study has a wide placeholder above it for a screenshot of the abstract with the conclusion highlighted — the reference does exactly this and it's one of the strongest trust moments on the page.
