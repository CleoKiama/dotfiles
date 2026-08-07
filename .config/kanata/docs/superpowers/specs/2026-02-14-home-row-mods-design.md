# Home Row Mods Alignment Spec

**Date:** 2026-02-14  
**Status:** Approved

## Overview
Align the home-row modifier mapping across base layers (`deflayer/base.kbd` and `deflayer/colemak-dh-base.kbd`) and documentation (`README.md`). Shift is placed on the ring fingers and Meta (Alt) is placed on the pinky fingers.

## Design

### 1. Home Row Mods Target Layout
The standardized home-row mod order (from outer/pinky to inner/index) for both hands is:
- **Pinky** (`a` / `;`): Meta / Alt (`lalt` / `ralt`)
- **Ring** (`s` / `l`): Shift (`lsft` / `rsft`)
- **Middle** (`d` / `k`): Super (`lmet` / `rmet`)
- **Index** (`f` / `j`): Ctrl (`lctl` / `rctl`)

### 2. Base Files Status & Changes

#### `deflayer/base.kbd` (QWERTY)
- Currently matches target layout.
- No code changes needed; confirmed correct.

#### `deflayer/colemak-dh-base.kbd` (Colemak-DH)
Update the `defalias` definitions:
- `a`: `(tap-hold-release-keys $tap-time $hold-time a lalt $left-hand-keys)`
- `s`: `(tap-hold-release-keys $tap-time $hold-time r lsft $left-hand-keys)`
- `l`: `(tap-hold-release-keys $tap-time $hold-time i rsft $right-hand-keys)`
- `;`: `(tap-hold-release-keys $tap-time $hold-time o ralt $right-hand-keys)`

### 3. Documentation (`README.md`)
Update the "Base — Home-Row Mods" reference table:
- Key `A` / `;` -> Meta/Alt (left/right)
- Key `S` / `L` -> Shift (left/right)
- Key `D` / `K` -> Super (left/right)
- Key `F` / `J` -> Ctrl (left/right)
