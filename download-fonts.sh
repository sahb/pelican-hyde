#!/bin/bash
# download-fonts.sh — Downloads woff2 font files for self-hosting.
# Run from the theme root directory (where static/ is).
# Usage: bash download-fonts.sh
#
# If any URL breaks (Google updates versions), use https://gwfh.mranftl.com
# to get fresh URLs, or download from https://fonts.google.com directly.

set -euo pipefail

FONT_DIR="static/fonts"
mkdir -p "$FONT_DIR"

echo "Downloading fonts to $FONT_DIR ..."

# --- Literata (body) ---
curl -sL -o "$FONT_DIR/literata-v400-latin.woff2" \
  "https://fonts.gstatic.com/s/literata/v37/or3PQ6P12-iJxAIgLa78DkrbXsDgk0oVDaBPYLanFLHpPf0TbJG_F.woff2"
curl -sL -o "$FONT_DIR/literata-v400-italic-latin.woff2" \
  "https://fonts.gstatic.com/s/literata/v37/or3NQ6P12-iJxAIgLYT1PLs1Zd0nR0j7yoA6BTNYGqHF.woff2"
curl -sL -o "$FONT_DIR/literata-v600-latin.woff2" \
  "https://fonts.gstatic.com/s/literata/v37/or3PQ6P12-iJxAIgLa78DkrbXsDgk0oVDaBPYLanFLHpPf2TYpG_F.woff2"
curl -sL -o "$FONT_DIR/literata-v700-latin.woff2" \
  "https://fonts.gstatic.com/s/literata/v37/or3PQ6P12-iJxAIgLa78DkrbXsDgk0oVDaBPYLanFLHpPf2qYpG_F.woff2"
curl -sL -o "$FONT_DIR/literata-v600-italic-latin.woff2" \
  "https://fonts.gstatic.com/s/literata/v37/or3NQ6P12-iJxAIgLYT1PLs1Zd0nR0j7yoA6BTNYGqHFkawl.woff2"

# --- Playfair Display (headings) ---
curl -sL -o "$FONT_DIR/playfair-display-v400-latin.woff2" \
  "https://fonts.gstatic.com/s/playfairdisplay/v37/nuFvD-vYSZviVYUb_rj3ij__anPXJzDwcbmjWBN2PKdFvUDQZNLo_U2r.woff2"
curl -sL -o "$FONT_DIR/playfair-display-v700-latin.woff2" \
  "https://fonts.gstatic.com/s/playfairdisplay/v37/nuFvD-vYSZviVYUb_rj3ij__anPXJzDwcbmjWBN2PKd2ukDQZNLo_U2r.woff2"
curl -sL -o "$FONT_DIR/playfair-display-v400-italic-latin.woff2" \
  "https://fonts.gstatic.com/s/playfairdisplay/v37/nuFRD-vYSZviVYUb_rj3ij__anPXDTnCjmHKM4nYO7KN_qiTbtbK-F2rA0s.woff2"

# --- Inter (sidebar/UI) ---
curl -sL -o "$FONT_DIR/inter-v400-latin.woff2" \
  "https://fonts.gstatic.com/s/inter/v18/UcCO3FwrK3iLTeHuS_nVMrMxCp50SjIw2boKoduKmMEVuLyfAZ9hjQ.woff2"
curl -sL -o "$FONT_DIR/inter-v500-latin.woff2" \
  "https://fonts.gstatic.com/s/inter/v18/UcCO3FwrK3iLTeHuS_nVMrMxCp50SjIw2boKoduKmMEVuI6fAZ9hjQ.woff2"
curl -sL -o "$FONT_DIR/inter-v600-latin.woff2" \
  "https://fonts.gstatic.com/s/inter/v18/UcCO3FwrK3iLTeHuS_nVMrMxCp50SjIw2boKoduKmMEVuGKYAZ9hjQ.woff2"
curl -sL -o "$FONT_DIR/inter-v700-latin.woff2" \
  "https://fonts.gstatic.com/s/inter/v18/UcCO3FwrK3iLTeHuS_nVMrMxCp50SjIw2boKoduKmMEVuFuYAZ9hjQ.woff2"

# --- Abril Fatface (sidebar title) ---
curl -sL -o "$FONT_DIR/abril-fatface-v400-latin.woff2" \
  "https://fonts.gstatic.com/s/abrilfatface/v23/zOL64pLDlL1D99S8HAFadkA0req0fDau.woff2"

# --- JetBrains Mono (code) ---
curl -sL -o "$FONT_DIR/jetbrains-mono-v400-latin.woff2" \
  "https://fonts.gstatic.com/s/jetbrainsmono/v20/tDbY2o-flEEny0FZhsfKu5WU4zr3E_BX0PnT8RD8yKxTOlOTk6OThhvA.woff2"
curl -sL -o "$FONT_DIR/jetbrains-mono-v500-latin.woff2" \
  "https://fonts.gstatic.com/s/jetbrainsmono/v20/tDbY2o-flEEny0FZhsfKu5WU4zr3E_BX0PnT8RD8yKxTOlOjk6OThhvA.woff2"

COUNT=$(ls -1 "$FONT_DIR"/*.woff2 2>/dev/null | wc -l)
echo ""
echo "Done! Downloaded $COUNT font files."
