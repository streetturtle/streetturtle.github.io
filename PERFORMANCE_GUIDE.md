# 🚀 Performance Optimization Guide

## Summary of Changes Made

### ✅ Completed Optimizations

1. **Conditional Lightbox Loading** - Lightbox CSS/JS only loads on pages with `gallery: true`
2. **Async JavaScript** - All JS scripts use `defer` to prevent render blocking
3. **Font Optimization** - Added `preconnect`, `display=swap`, and removed redundant WebFont loader
4. **Lazy Font Awesome** - Font Awesome CSS loads asynchronously

### 🔴 Critical: Image Optimization Required

Your images are **HUGE** and need optimization:

#### Current Sizes (28MB total):
- `m50x-header.jpg`: 5.7MB
- `m50x-headband.jpg`: 5.6MB  
- `m50x-speaker-1.jpg`: 4.7MB
- `m50x-speaker-2.jpg`: 4.8MB
- `m50x-hinge-1.jpg`: 3.4MB
- `m50x-hinge-2.jpg`: 3.5MB

#### Target Sizes (2-3MB total):
- Header images: ~150-200KB each
- Gallery images: ~80-120KB each

#### How to Optimize:

**Option 1: GitHub Actions (Recommended - Automated)**

Two workflows are set up:

1. **Automatic optimization** - Runs on every push with new images
   - Automatically optimizes images when you commit them
   - No manual work needed!

2. **One-time bulk optimization** - For existing images
   - Go to: https://github.com/streetturtle/streetturtle.github.io/actions
   - Select "Optimize All Existing Images (One-Time)"
   - Click "Run workflow"
   - Wait ~2-3 minutes
   - Done! All existing images optimized

**Option 2: Local Script**
```bash
# Install ImageMagick
brew install imagemagick

# Run the optimization script
chmod +x optimize-images.sh
./optimize-images.sh
```

**Option 3: Manual Optimization**
Use online tools:
- https://tinypng.com/ (drag & drop, max 5MB)
- https://squoosh.app/ (Google's tool)
- https://imageoptim.com/mac (Mac app)

**Settings:**
- Max width: 1200px for headers, 800px for gallery
- Quality: 80-85%
- Strip metadata

---

## Performance Metrics

### Before Optimization:
- **Page Size**: ~30MB
- **Load Time**: 10-30+ seconds (slow connection)
- **Render Blocking**: 3 JS files, 5 CSS files
- **Lighthouse Score**: Likely 20-40/100

### After Full Optimization:
- **Page Size**: ~3-4MB (87% reduction)
- **Load Time**: 2-5 seconds
- **Render Blocking**: Minimal (deferred JS)
- **Lighthouse Score**: Expected 70-85/100

---

## Additional Recommendations

### Priority 2: Add Lazy Loading to Images

Add `loading="lazy"` to images below the fold:

```markdown
![Alt text](image.jpg){:.center-image loading="lazy"}
```

### Priority 3: Enable GitHub Pages Caching

Add to `_config.yml`:
```yaml
plugins:
  - jekyll-paginate
  - jekyll-sitemap
  - jekyll-seo-tag
```

### Priority 4: Consider WebP Format

Modern browsers support WebP (30% smaller than JPEG):
```bash
# Convert to WebP
magick image.jpg -quality 85 image.webp
```

Then use with fallback:
```html
<picture>
  <source srcset="image.webp" type="image/webp">
  <img src="image.jpg" alt="Description">
</picture>
```

---

## How to Use Gallery Feature

For posts with image galleries, add to front matter:
```yaml
---
layout: post
title: "Your Post"
gallery: true
---
```

This ensures lightbox JS/CSS only loads when needed.

---

## Testing Performance

### Local Testing:
```bash
# Start server
bundle exec jekyll serve

# Check page size
curl -s http://localhost:4000/2025/12/audio-technica-m50x-10-years/ | wc -c
```

### Online Testing:
- **PageSpeed Insights**: https://pagespeed.web.dev/
- **GTmetrix**: https://gtmetrix.com/
- **WebPageTest**: https://www.webpagetest.org/

---

## Maintenance

- **Optimize all new images** before adding to site
- **Review page size** if it exceeds 5MB
- **Test on slow connections** (Chrome DevTools → Network → Slow 3G)
- **Monitor Core Web Vitals** in Google Search Console

---

## Quick Wins Checklist

- [ ] Run `./optimize-images.sh` to compress images
- [ ] Add `gallery: true` to posts with image galleries
- [ ] Test site with Chrome DevTools Lighthouse
- [ ] Check mobile performance
- [ ] Verify all images load correctly after optimization
