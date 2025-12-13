#!/bin/bash
# Image optimization script for Jekyll site
# Requires: imagemagick (brew install imagemagick)

echo "🖼️  Optimizing images in images/2025/..."

# Backup originals
mkdir -p images/2025/originals
cp -r images/2025/*.jpg images/2025/originals/ 2>/dev/null || true
cp -r images/2025/*/*.jpg images/2025/originals/ 2>/dev/null || true

# Optimize header/hero images (max 1200px wide, 85% quality)
for img in images/2025/m50x-header.jpg images/2025/m50x-headband.jpg; do
    if [ -f "$img" ]; then
        echo "Optimizing $img..."
        magick "$img" -resize '1200x1200>' -quality 85 -strip "$img"
    fi
done

# Optimize gallery images (max 800px wide, 80% quality)
for img in images/2025/m50x-hinge/*.jpg images/2025/m50x-speaker/*.jpg images/2025/m50x-replacement-cable.jpg; do
    if [ -f "$img" ]; then
        echo "Optimizing $img..."
        magick "$img" -resize '800x800>' -quality 80 -strip "$img"
    fi
done

echo "✅ Done! Original images backed up to images/2025/originals/"
echo ""
echo "Before/After sizes:"
du -sh images/2025/originals/
du -sh images/2025/
