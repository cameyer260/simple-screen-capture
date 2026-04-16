# simple-screen-capture

Screenshot, GIF, and screencast capture for Ubuntu/PopOS (X11) with a floating GTK menu.

## Install

```bash
bash <(curl -fsSL https://github.com/KerryRitter/simple-screen-capture/releases/latest/download/install.sh)
```

Press `Ctrl+Shift+Alt+4` to open the capture panel.

## Features

- **Screenshot** — select any area, copied to clipboard as **Image**, **Base64**, or **URL**; saved to `~/Pictures/Screenshots`
- **Record GIF** — select any area, records and converts to an optimised GIF
- **Record Screen** — select any area, records as MP4 (with optional audio)
- **URL mode** — auto-uploads the capture to your S3 / R2 / B2 / MinIO bucket and copies a shareable URL to the clipboard (screenshots, GIFs, and screencasts). Configure once via `simple-screen-capture --setup`; tiny stdlib-only SigV4 uploader, no `awscli` dependency.
- **Smart Slice** — automatically extracts key screenshots from a recording when notable screen changes are detected (tunable sensitivity slider)
- Persistent resizable region selector — the capture area is always visible before you commit
- Per-mode region memory — each mode remembers its last capture area

## S3 / R2 upload config

Running `simple-screen-capture --setup` walks you through the upload config (endpoint, bucket, credentials, optional CDN base, etc.) and writes `~/.config/capture/s3.conf` (chmod 600). Works with:

- AWS S3 — set `S3_ACL=public-read` if you want anonymous reads
- Cloudflare R2 — leave ACL blank; serve via custom domain bound in the R2 dashboard (set `S3_PUBLIC_URL_BASE`)
- Backblaze B2 / MinIO / any other S3-compatible host

## Team sharing (passphrase-encrypted config)

If your team uses a shared R2 bucket, the owner can export an encrypted blob that teammates decrypt at install time.

**Owner** (one time, after running `--setup` normally):

```bash
simple-screen-capture --export-config
# prompts for a passphrase (≥12 chars, twice), then prints a single-line
# ciphertext blob starting with U2FsdGVkX1… — copy that string.
```

AES-256-CBC with PBKDF2 (600k iterations). Share the ciphertext + passphrase with your team via a password manager.

**Teammate** (one-liner — paste the ciphertext inline):

```bash
CAPTURE_CONFIG='U2FsdGVkX1...your-ciphertext-here...' \
  bash <(curl -fsSL https://github.com/KerryRitter/simple-screen-capture/releases/latest/download/install.sh)
```

Or if you'd rather host the blob at a URL, pass that URL as `CAPTURE_CONFIG` instead — the installer detects `http(s)://` and fetches it. Either way, the teammate gets prompted for the passphrase during install.

**Security reality check:** after decryption, every teammate has full R2 credentials locally — they can read, overwrite, or delete anything in the bucket. Rotate the R2 token + re-export whenever someone leaves. For stricter isolation, issue per-user R2 tokens scoped to a path prefix and have each teammate run `--setup` normally instead.

## Build from source

```bash
bash build.sh 1.7.0
sudo apt install ./simple-screen-capture_1.7.0_all.deb
simple-screen-capture --setup
```
