#!/usr/bin/env python3
"""Emit rofi dmenu rows for image entries in cliphist.

Each row is "<id>\t<caption>\0icon\x1f<thumb>". Thumbnails are generated once
per entry by streaming `cliphist decode` into `vips thumbnail_source`, so
full-size images are never written to disk. Thumbnails for entries no longer
in history are pruned on every run.
"""

import os
import re
import subprocess

CACHE_DIR = os.path.join(os.getenv("XDG_RUNTIME_DIR", "/tmp"), "cliphist")
THUMB_SIZE = "720"

# e.g. "9599\t[[ binary data 272 KiB png 915x667 ]]"
ENTRY = re.compile(
    r"^(\d+)\t\[\[ binary data ([\d.]+ \w+) (jpe?g|png|bmp|webp) (\d+)x(\d+) \]\]",
    re.IGNORECASE,
)


def thumb_path(entry_id: str) -> str:
    return os.path.join(CACHE_DIR, f"{entry_id}.thumb.png")


def ensure_thumb(entry_id: str) -> bool:
    path = thumb_path(entry_id)
    if os.path.exists(path):
        return True
    decode = subprocess.Popen(["cliphist", "decode", entry_id], stdout=subprocess.PIPE)
    vips = subprocess.run(
        ["vips", "thumbnail_source", "[descriptor=0]", path, THUMB_SIZE],
        stdin=decode.stdout,
        stderr=subprocess.DEVNULL,
    )
    decode.stdout.close()
    decode.wait()
    if vips.returncode != 0 or decode.returncode != 0:
        if os.path.exists(path):
            os.remove(path)
        return False
    return True


def prune(keep: set[str]) -> None:
    for name in os.listdir(CACHE_DIR):
        if name not in keep:
            os.remove(os.path.join(CACHE_DIR, name))


def main() -> None:
    os.makedirs(CACHE_DIR, exist_ok=True)
    try:
        listing = subprocess.run(
            ["cliphist", "list"], capture_output=True, text=True, check=True
        ).stdout
    except (OSError, subprocess.CalledProcessError):
        return

    keep: set[str] = set()
    rows: list[str] = []
    for line in listing.splitlines():
        match = ENTRY.match(line)
        if not match:
            continue
        entry_id, size, _fmt, width, height = match.groups()
        if not ensure_thumb(entry_id):
            continue
        keep.add(os.path.basename(thumb_path(entry_id)))
        rows.append(f"{entry_id}\t{{pos}}  ·  {width}×{height}  ·  {size}\0icon\x1f{thumb_path(entry_id)}")

    # Position counter ("2/5") helps orient in the one-image-per-page view
    for pos, row in enumerate(rows, 1):
        print(row.replace("{pos}", f"{pos}/{len(rows)}", 1))

    prune(keep)


if __name__ == "__main__":
    main()
