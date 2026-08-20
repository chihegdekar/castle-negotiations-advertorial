#!/bin/bash
# ============================================================
# Castle Negotiations — advertorial media build
#
# Cuts every supporting clip on the page from source footage.
# Re-runnable: deletes nothing you can't regenerate.
#
#   ./build-media.sh
#
# Sources:
#   Video ideas/nonhero/   – licensed stock (Pexels)
#   Video ideas/           – Castle's own footage
#   Video ideas/_pexels/   – extra stock, auto-downloaded via PEXELS_API_KEY
#
# Output: media/*.mp4  — 4:5 for split/triple cells, 16:9 for wide.
# No audio, faststart, CRF 27. Each clip is a 4–6s silent loop.
# ============================================================
set -euo pipefail
cd "$(dirname "$0")"

VI="Video ideas"
NH="$VI/nonhero"
PX="$VI/_pexels"
OUT="media"
mkdir -p "$OUT" "$PX"

ENC=(-c:v libx264 -profile:v main -pix_fmt yuv420p -crf 27 -preset slow -movflags +faststart -an)

# ---- fetch the extra stock we need (idempotent) -------------
fetch_pexels() {
  local id="$1"
  [ -f "$PX/$id.mp4" ] && return 0
  echo "  ↓ pexels $id"
  python3 - "$id" "$PX/$id.mp4" <<'PY'
import json, sys, urllib.request
key = None
for line in open("../.env"):
    if line.startswith("PEXELS_API_KEY="):
        key = line.split("=", 1)[1].strip()
ua = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 Chrome/126 Safari/537.36"
vid, out = sys.argv[1], sys.argv[2]
req = urllib.request.Request(f"https://api.pexels.com/videos/videos/{vid}",
                             headers={"Authorization": key, "User-Agent": ua})
d = json.load(urllib.request.urlopen(req))
files = [f for f in d["video_files"] if (f.get("width") or 0) <= 2000] or d["video_files"]
best = max(files, key=lambda f: (f.get("width") or 0))
req = urllib.request.Request(best["link"], headers={"User-Agent": ua})
with urllib.request.urlopen(req) as r, open(out, "wb") as fh:
    fh.write(r.read())
PY
}

echo "▸ fetching stock"
for id in 4468754 12893568 7054942 7593780 5981905 \
          6100413 5778854 8170593 7552528 8135380 8135159 8460998 7693470 \
          8512946 9057678; do
  fetch_pexels "$id"
done

# ---- cutters -------------------------------------------------
# portrait 4:5 cell.  xf/yf = 0..1 pan within the source frame.
# optional 7th arg: zoom (>1 pushes in), 8th: extra filters.
cut45() { # src start dur xf yf out [zoom] [filters]
  local src="$1" ss="$2" t="$3" xf="$4" yf="$5" out="$6" z="${7:-1}" fx="${8:-}"
  local cw="min(iw,ih*4/5)/$z" ch="min(ih,iw*5/4)/$z"
  echo "  ▪ $out"
  ffmpeg -v error -y -ss "$ss" -t "$t" -i "$src" \
    -vf "crop='$cw':'$ch':'(iw-$cw)*$xf':'(ih-$ch)*$yf',${fx}scale=720:900:flags=lanczos,setsar=1" \
    "${ENC[@]}" "$OUT/$out"
}

# landscape 16:9 cell.
cut169() { # src start dur xf yf out
  local src="$1" ss="$2" t="$3" xf="$4" yf="$5" out="$6"
  echo "  ▪ $out"
  ffmpeg -v error -y -ss "$ss" -t "$t" -i "$src" \
    -vf "crop='min(iw,ih*16/9)':'min(ih,iw*9/16)':'(iw-min(iw,ih*16/9))*$xf':'(ih-min(ih,iw*9/16))*$yf',scale=1280:720:flags=lanczos,setsar=1" \
    "${ENC[@]}" "$OUT/$out"
}

# explicit pixel crop, for frames that need to dodge something.
cutbox() { # src start dur x y w h out
  local src="$1" ss="$2" t="$3" x="$4" y="$5" w="$6" h="$7" out="$8"
  echo "  ▪ $out"
  ffmpeg -v error -y -ss "$ss" -t "$t" -i "$src" \
    -vf "crop=$w:$h:$x:$y,scale=720:900:flags=lanczos,setsar=1" \
    "${ENC[@]}" "$OUT/$out"
}

A="$NH/6814547-uhd_4096_2160_25fps.mp4"   # lone exec across the table, stonewalled
B="$NH/7552494-hd_1920_1080_25fps.mp4"    # handshake, agreement reached
C="$NH/8124280-hd_1920_1080_30fps.mp4"    # trainer presenting to a seated room
D="$NH/8141397-uhd_2160_3840_25fps.mp4"   # team handshake, aligned
E="$NH/8343952-uhd_3840_2160_25fps.mp4"   # cross-functional meeting, tense
F="$NH/8461012-uhd_3840_2160_25fps.mp4"   # cohort watching a session

# ONE SOURCE PER SLOT. Two sections must never share a clip — even two
# different timestamps of the same locked-off shot read as a repeat, which
# is exactly what went wrong the first time round. If you add a section,
# add a source; don't re-point an existing one.
echo "▸ cutting cells"
cut45 "$A"                4.0 5.0 0.42 0.40 s1a-alone.mp4
# later in the clip the car bodies are on the line — reads as an OEM, not just "a factory"
cut45 "$PX/4468754.mp4"   6.5 5.0 0.50 0.55 s1b-line.mp4
cut45 "$PX/12893568.mp4"  2.0 5.5 0.50 0.35 s2a-nights.mp4
cut45 "$PX/7054942.mp4"   0.5 6.0 0.42 0.50 s2b-paper.mp4
# Castle's own tower collapse — a proper pull-and-topple on a clean sweep,
# which the stock jenga never gave us
cutbox "$VI/Screen Recording 2026-08-13 at 23.36.08.mov" 0.4 6.0  480 0 1405 1756 s3a-jenga.mp4
cut45 "$PX/7593780.mp4"   2.0 5.5 0.45 0.45 s3b-stamp.mp4
cut45 "$PX/6100413.mp4"   9.0 5.0 0.50 0.42 s4a-before.mp4
cut45 "$PX/5778854.mp4"   1.2 5.0 0.50 0.50 s4b-after.mp4
cut45 "$C"                1.0 5.5 0.55 0.40 s6a-taught.mp4
cut45 "$E"                2.0 5.5 0.45 0.45 s6b-real.mp4
# stay on the first page of the brief — later the animation swaps pages and
# drifts, which clips the "HIPPO" title mid-loop
cut45 "../Pre-brief animation.mp4" 0.3 3.2 0.50 0.22 s7a-hippo.mp4
# crop below the handwriting — the notes carry it, the words would fight the labels
cut45 "$PX/5981905.mp4"   1.0 5.5 0.50 1.00 s7b-drivers.mp4 1.45
cut45 "$VI/download.mp4"  0.0 5.0 0.50 0.50 s7c-knight.mp4
# "But here's the catch" — what you're actually booking, and the calendar
# that caps it. The laptop screen sits right of frame, hence xf=0.80; the
# source is flat so it gets a contrast lift.
cut45 "$PX/8512946.mp4"   1.0 5.0 0.80 0.45 s10a-call.mp4 1 "eq=contrast=1.14:saturation=1.08,"
# shot from across the table, so the month reads upside down — rotate 180
# and the hands come in from the bottom like they're your own
cut45 "$PX/9057678.mp4"   1.0 5.5 0.50 0.50 s10b-slots.mp4 1 "hflip,vflip,"
# path 1: procurement getting leaned on by two people at once
cut45 "$PX/7552528.mp4"   3.0 5.0 0.50 0.42 s12a-path1.mp4
cut45 "$D"                1.5 5.0 0.50 0.40 s12b-path2.mp4
cut45 "$B"                7.6 5.0 0.50 0.45 s13b-signed.mp4
cut169 "$PX/8170593.mp4"  1.5 5.5 0.50 0.45 s11-guarantee.mp4

# Castle's own Blame Wheel, sitting in the BEFORE cell of the final
# comparison — the copy beside it is "your procurement team has taken the
# blame long enough". Chi's crop is 942x1220 (0.772); the cell is 4:5, so pad
# the sides out to 976 rather than crop. There's only 20px of clearance under
# the Spin button and cropping would eat it.
# 140px of headroom on top so the BEFORE badge never clips the title. It has
# to clear the badge at 390px too, where the badge stops shrinking (its font
# hits the clamp floor) while the cell keeps getting smaller — so the gap is
# sized for mobile, not desktop. Side padding keeps the result at exactly 4:5
# so it matches the AFTER cell and the grid row stays even.
echo "  ▪ s13a-wheel.mp4"
ffmpeg -v error -y -i "$OUT/Procurement Blame Wheel (1).mov" \
  -vf "pad=1088:1360:73:140:color=white,scale=720:900:flags=lanczos,setsar=1,fps=30" \
  "${ENC[@]}" "$OUT/s13a-wheel.mp4"

# ---- the alternating before/after montage --------------------
# Eight 0.55s segments, hard cuts, no transitions. Grayscale is burned
# in per-segment so BEFORE reads cold against a full-colour AFTER.
# The badges are drawn in CSS off video.currentTime — see index.html.
echo "▸ building montage"
SEG=0.55
seg() { # src start gray out
  local gray=""
  [ "$3" = "gray" ] && gray="hue=s=0,eq=contrast=1.12:brightness=-0.03,"
  ffmpeg -v error -y -ss "$2" -t "$SEG" -i "$1" \
    -vf "crop='min(iw,ih*16/9)':'min(ih,iw*9/16)':'(iw-min(iw,ih*16/9))*0.5':'(ih-min(ih,iw*9/16))*0.45',${gray}scale=1280:720:flags=lanczos,setsar=1,fps=25" \
    "${ENC[@]}" "$4"
}

# Four sources the rest of the page never touches: two rooms going nowhere,
# two rooms that landed it. Each appears twice, at different moments — the
# alternation IS the device, but it stays sealed inside this one figure.
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
seg "$PX/8135380.mp4"  4.0 gray  "$TMP/01.mp4"
seg "$PX/8460998.mp4"  6.0 col   "$TMP/02.mp4"
seg "$PX/8135159.mp4"  7.0 gray  "$TMP/03.mp4"
seg "$PX/7693470.mp4"  9.0 col   "$TMP/04.mp4"
seg "$PX/8135380.mp4" 19.0 gray  "$TMP/05.mp4"
seg "$PX/8460998.mp4" 10.5 col   "$TMP/06.mp4"
seg "$PX/8135159.mp4" 24.0 gray  "$TMP/07.mp4"
seg "$PX/7693470.mp4"  3.0 col   "$TMP/08.mp4"
: > "$TMP/list.txt"
for f in "$TMP"/0*.mp4; do echo "file '$f'" >> "$TMP/list.txt"; done
ffmpeg -v error -y -f concat -safe 0 -i "$TMP/list.txt" "${ENC[@]}" "$OUT/s5-rounds.mp4"
echo "  ▪ s5-rounds.mp4"

# ---- poster frames, so nothing pops in grey ------------------
echo "▸ posters"
for f in "$OUT"/s*.mp4; do
  n=$(basename "$f" .mp4)
  ffmpeg -v error -y -ss 0.1 -i "$f" -frames:v 1 -q:v 6 "$OUT/$n.jpg"
done

echo
echo "✓ done"
du -sh "$OUT"
ls -la "$OUT"/*.mp4 | awk '{printf "  %-28s %6.0f KB\n", $9, $5/1024}'
