# Colemak-DH

A Kanata configuration that turns a laptop keyboard into a pseudo-split columnar layout.

![Layout overview](docs/images/all.svg)

## How it works

The layout shifts both hands up one physical row and outward, leaving empty space in the middle. Keys outside this 35-key cluster are disabled.

- **Left hand**: starts on `tab`. Home row is `tab q w e r` (mapped to `a r s t g`).
- **Right hand**: starts on `i`. Home row is `i o p [ ]` (mapped to `m n e i o`).
- **Middle gap**: columns 5, 6, and 7 (`5 t g b`, `6 y h n`, and `7 u j m`) are unmapped.

## Home-row mods

Modifiers sit on the home row using bilateral timeless tap-hold:

| Finger | Left key | Output / Hold | Right key | Output / Hold |
| --- | --- | --- | --- | --- |
| Pinky | `tab` | `a` / Left Shift | `]` | `o` / Right Shift |
| Ring | `q` | `r` / Left Alt | `[` | `i` / Right Alt |
| Middle | `w` | `s` / Left Super | `p` | `e` / Right Super |
| Index | `e` | `t` / Left Ctrl | `o` | `n` / Right Ctrl |

## Thumbs

Four physical keys handle space, enter, editing, and layer switches:

| Key | Position | Tap | Hold layer |
| --- | --- | --- | --- |
| `x` | Left middle | Backspace | Symbols |
| `c` | Left index | Space | Navigation |
| `,` | Right index | One-shot Shift | Modifiers |
| `.` | Right middle | Enter | Numbers |

## Combos and extras

- **Escape**: press physical keys `2` and `3` (`f` and `p`) together.
- **Live reload**: tap `prtsc` to reload the config without restarting the service.
- **Workspace layer**: hold physical `ret` (right pinky) for `Super+1` through `Super+0`.

## Inspiration

- [Kanata](https://github.com/jtroo/kanata), keyboard remapping engine.
- [Arsenik](https://github.com/OneDeadKey/arsenik) by OneDeadKey, compact layout design for standard keyboards.
- [Timeless Home-Row Mods](https://urob.github.io/zmk-config/) by urob.
- [How to Make a Regular Keyboard More Ergonomic](https://youtu.be/2BIkk9FkxcU) by safi.
