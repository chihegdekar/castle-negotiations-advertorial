# Castle Negotiations — Advertorial

`index.html` is the page. Open it in a browser — no build step, no dependencies (fonts load from Google Fonts).

`build-media.sh` cuts every supporting clip in `media/` from the source footage. You only need to run it if you want to re-cut something; the output is already committed.

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
| Blue guarantee badges | Gold "no regret / 0.1% refund rate" seal over the guarantee clip |
| Red BEFORE / green AFTER tabs, flush to the corner | Same — `#E11B1B` and `#15803D`, deliberately not the brand palette |
| Raw iPhone snapshot from a conference | Castle's own room footage, ungraded |
| Facebook comment thread + Summer Sale box | Dropped (your call) |

## How the supporting media works

Same six devices the reference uses, all of them earning their place rather than decorating:

| Device | Where | How it's done |
|---|---|---|
| Two-pane contrast | Most split figures | Two grid cells, one greyed, one in colour |
| Hard before/after flip | The $3.7M montage | Eight 0.56s segments concatenated in ffmpeg; grey burned in per segment |
| Grey as the past tense | Every `is-grey` cell | CSS `filter: grayscale(1)` — no re-encode, toggle it by deleting one class |
| Burned-in annotation | Driver Mapping, the seam arrows | Absolutely-positioned `.pin` / `.seam` elements |
| Live counter | The $15,000/minute pane | `.tick` counts up while visible, resets when it scrolls away |
| Hard-cut text | The blame wheel, the trainer's script | `data-cyc="line|line|line"`, swapped every 1.1s |

## Two rules that are easy to break

**1. One source clip per section.** Never point two figures at the same footage. Two different timestamps of the same locked-off shot still read as a repeat — the reader clocks it instantly and the page starts to feel thin. The four clips inside the montage each appear twice, but that alternation *is* the device and it stays sealed inside that one figure. If you add a section, add a source.

**2. No explanatory captions.** Text belongs on the media only when it's part of the visual — the trainer's script, the department pins on the driver map, the counter's unit label, the corner tabs. If it reads like a sentence describing what you're looking at, cut it. The reference page has none of that, and the picture landing on its own is what makes the point stick. These readers make the connection faster than a caption can explain it.

Clips are 2–6s, silent, looping, and lazy-loaded by IntersectionObserver: nothing downloads until it's near the viewport, and clips pause when they scroll off. All 22 come to about 8MB.

To check nothing has started sharing footage:

```bash
grep -oE '(cut45|cut169|cutbox|seg) "[^"]+"' build-media.sh | sed 's/.*"\(.*\)"/\1/' | sed 's#.*/##' | sort | uniq -c | sort -rn
```

Everything should show `1`, except the four montage sources at `2`.

The one thing that *is* timing-critical: the montage badge reads `requestVideoFrameCallback` so the BEFORE/AFTER label matches the frame actually on screen. If you re-cut `s5-rounds.mp4` with a different number of segments, change `data-montage="8"` to match.

## Before it goes live

1. **Swap the CTA links.** Find/replace `#book` with the real booking URL.
2. **The study screenshot.** One slot is deliberately left empty — the wide frame under "The Defensibility Trap strikes." Drop your screenshot in with the conclusion highlighted in `#FFFF00`, plain and unframed. It's the strongest trust moment on the reference page.
3. **Headshot.** The byline `.avatar` currently holds `Chi & Ruth.png`.
4. **Legal.** Terms / Privacy / Contact links are stubs. The business disclaimer is a first draft written to mirror the reference's health disclaimer — get it checked.

## Notes

- On mobile the rail falls to the bottom of the page, just before the disclaimer.
- Checked at 360, 390, 768 and 1280px — no horizontal overflow at any of them. The cost comparison and the three-up stack both go single-column below 640px.
- No client is named in any caption. The logo wall is the only proof that identifies anyone, and it's the same set already public on the lead-gen page.
- `Video ideas/` is gitignored, including the stock `build-media.sh` downloads into `Video ideas/_pexels/`. Re-running the script re-fetches anything missing.
