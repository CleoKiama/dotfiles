# Kanata Layout — Ergonomic-Shift Colemak-DH

A [Kanata](https://github.com/jtroo/kanata) implementation of the **Ergonomic-Shift** Colemak-DH layout for standard staggered full-size or laptop keyboards.

## Overview & Design Philosophy

Ergonomic-Shift transforms a standard staggered keyboard into an ergonomic columnar-like layout by applying hand-position shifts:

1. **Shift-Up & Tab-Origin (1-Col Left Shift)**: The entire alpha block is shifted up by one physical row. For the left hand, keys are shifted left by 1 column (Tab-Origin) for natural palm-on-edge resting posture.
   - Left hand home row starts on `tab`: `tab q w e r` → `a r s t g`.
   - Left hand top row starts on `` ` ``: `` ` 1 2 3 4 `` → `q w f p b`.
   - Left hand bottom alpha row starts on `caps`: `caps a s d f` → `z x c d v`.
   - Dedicated thumb keys move inward: left thumbs on `x` and `c`, right thumb on `,` (physical `m` is now plain **Shift**).
2. **Split Hands (Double Dead Gap)**: Physical columns `5, t, g, b` (left dead gap) and `6, y, h, n` (plus `bspc`) are dead (`XX`).
   - This creates a wide 2-column vertical gap between the hands while keeping Colemak-DH finger-to-letter column assignments straight.

### Layout Overview

![Full Ergonomic-Shift Layout](docs/images/all.svg)

### Key Features

- **Colemak-DH Base**: Ergonomic layout optimized for English typing.
- **Un-Angled Bottom Alpha Row**: Standard Colemak-DH columns (`z x c d v` mapped to physical `caps a s d f`). Because physical Row 3 staggers 0.25U to the right of Row 2, standard fingering naturally matches left arm ergonomics without requiring an angle mod.
- **Home-Row Mods**: Left hand mods live on `tab q w e` (`tab` = `a`/Shift, `q` = `r`/Alt, `w` = `s`/Super, `e` = `t`/Ctrl). Right hand mods live on `i o p [` (Ctrl, Super, Alt, Shift). Pinkies have zero tap-hold delay when plain tapping.
- **Escape Combo**: Physical keys `2` + `3` (`f` + `p`) pressed together emit **Escape** with 100% zero-collision reliability.
- **3 Thumb Keys + Shift**:
  - `x` (Left Middle): Tap = Backspace, Hold = **Symbols** layer
  - `c` (Left Index): Tap = Space, Hold = **Navigation** layer
  - `m` (Right Index - Rest): **Shift** (plain `rsft`, no layer)
  - `,` (Right Middle - Angled): Tap = Enter, Hold = **NumRow** layer
- **Full Capture (`process-unmapped-keys yes`)**: Outer physical keys (arrows, F-keys, numpad, original spacebar row) are silenced (`XX`).
- **Same-Hand Suppression**: Home-row mods use `$left-hand-keys` and `$right-hand-keys` lists plus `tap-hold-require-prior-idle 100` to prevent misfires during fast typing.

---

## Physical Keyboard Mapping

### Left Hand (Tab-Origin Shift & Dead Column 5)

```
Physical Row                Mapping (Output)
─────────────────────────────────────────────────────────────────
`  1  2  3  4  5            q  w  f  p  b XX      (Number row — 2+3 = Esc combo)
tab q  w  e  r  t           @a @r @s @t  g XX      (Top row — HOME: Shift, Alt, Super, Ctrl, g)
caps a  s  d  f  g          z  x  c  d  v XX      (Home row — Bottom alpha row)
lshift z  x  c  v  b  <     XX XX @bspsym @nav XX XX XX (Bottom row — Thumbs on x and c)
```

### Right Hand (Columns 7–11, Column 6 Dead)

```
Physical Row            Mapping (Output)
─────────────────────────────────────────────────────────────
6 (XX)  7  8  9  0  -     XX  j  l  u  y  ;   (Number row)
y (XX)  u  i  o  p  [     XX  m @n @e @i  o   (Top row — HOME: XX, m, Ctrl, Super, Alt, o)
h (XX)  j  k  l  ;  '     XX  k  h  ,  .  /   (Home row)
n (XX)  m  ,  .  /        XX rsft    @entnum XX XX (Bottom row — m = Shift plain, , = Ret/Num thumb)
```

- **Double Dead Gap**: Physical columns `5`, `t`, `g`, `b` and `6`, `y`, `h`, `n` are `XX` in all layers.
- **Spacebar Row**: `lalt`, `spc`, `ralt` are all `XX`.

---

## Layers

### Base — Colemak-DH & Home-Row Mods

![Home-Row Mods](docs/images/hrm.svg)

Home-row modifiers live on left `tab q w e` and right `i o p [`:

| Hand  | Key   | Tap | Hold Mod      |
| ----- | ----- | --- | ------------- |
| Left  | `tab` | `a` | Shift (left)  |
| Left  | `q`   | `r` | Alt (left)    |
| Left  | `w`   | `s` | Super (left)  |
| Left  | `e`   | `t` | Ctrl (left)   |
| Right | `i`   | `n` | Ctrl (right)  |
| Right | `o`   | `e` | Super (right) |
| Right | `p`   | `i` | Alt (right)   |
| Right | `[`   | `o` | Shift (right) |

### Thumb Keys

![Thumb Keys](docs/images/layer_taps.svg)

| Thumb Key   | Physical Key | Tap                  | Hold Layer                 |
| ----------- | ------------ | -------------------- | -------------------------- |
| Left Mid    | `x`          | Backspace            | **Symbols**                |
| Left Idx    | `c`          | Space                | **Navigation**             |
| Right Idx   | `m` (Rest)   | Shift (plain `rsft`)| *(none — plain Shift)*     |
| Right Mid   | `,` (Angled) | Enter                | **NumRow**                 |

### Symbols Layer

![Symbols Layer](docs/images/symbols.svg)

Activated by holding `x` (Left Mid thumb). Provides Lafayette / Ergo-L inspired programming symbols:

```
Number row:  _  <  >  $  %  | (col 6 dead) |  @  &  *  '
Top row:     {  (  )  }  =  | (col 6 dead) |  \  +  -  /  "
Home row:    ~  ;  :  ^  #  | (col 6 dead) |  |  !  [  ]
Bottom row:  ?  `           | (col 6 dead) |  "
```

### Modifiers Layer (Callum-style) — **REMOVED**

> Removed: physical `m` is now plain **Shift** (`rsft`). The Callum-style Modifiers layer was inert (all `XX`) and its `docs/images/modifiers.svg` has been deleted. Use home-row mods or the remaining thumb layers instead.

### Navigation Layer

![Navigation Layer](docs/images/navigation.svg)

Activated by holding `c` (Left Idx thumb). Vim-style navigation on the right hand, editor shortcuts on the left hand:

```
Top row:     XX  Close(Ctrl+W)  S-Tab        Tab         Back(Alt+←) |  Home  PgDn  PgUp  End
Home row:    Shift(Sticky)   Alt(Sticky)    Super(Sticky) Ctrl(Sticky) Fwd(Alt+→)  |  Left  Down  Up    Right
Bottom row:  Undo(Ctrl+Z)    Cut(Ctrl+X)    Copy(Ctrl+C) Redo(Ctrl+Y) Paste(Ctrl+V) | WheelL WheelD WheelU WheelR
```

- **NumPad — REMOVED (unused)**: `@pad` is now `XX`; numpad layer deleted from `navigation.kbd`. Use **NumRow** (`,`) for digits. Formerly `NumPad(switch)` on physical `1`/`q` — removed to avoid confusion with NumRow.
- **FunPad**: Hold physical `'` (`@fun`) to access F1–F12 keys.

### NumRow Layer

![NumRow Layer](docs/images/numrow.svg)

Activated by holding `,` (Right Mid thumb). Numbers 1..0 on the left hand:

```
Top row:     6  7  8  9  0
Home row:    1  2  3  4  5
```

Right-hand keys pass through as plain letters (`_`) so vim relative movement commands (e.g. `2j` / `2k`) roll naturally without layer interference.

### Workspace Layer

![Workspace Layer](docs/images/workspace.svg)

Activated by holding `/` (Right Pinky, physical quote key `'`). Sends Super+1 through Super+0 on the left hand for window manager workspace switching:

```
Top row:     Super+6  Super+7  Super+8  Super+9  Super+0
Home row:    Super+1  Super+2  Super+3  Super+4  Super+5
```

---

## Configuration

### Variables & Suppression

```lisp
(defvar
  tap-time 150          ;; ms to register a tap
  hold-time 200         ;; ms to register a hold
  left-hand-keys (` 1 2 3 4 tab q w e r caps a s d f lshift z x c)
  right-hand-keys (6 7 8 9 0 - y u i o p [ ] ' h j k l ; n m , . / bspc)
)
```

### Kanata Settings

- `tap-hold-require-prior-idle 100`: requires 100ms of idle time before a hold activates, preventing accidental mod triggers during fast typing rolls.
- **Live Reload**: `prtsc` is mapped to `lrld` to reload config without restarting Kanata.

---

## File Structure

```
.config/kanata/
├── config.kbd              # Main config: defcfg, defvar, includes
├── defsrc/
│   └── pc.kbd              # Source key capture (103 physical keys)
├── defalias/
│   └── qwerty.kbd          # Shared symbol and shortcut aliases
└── deflayer/
    ├── colemak-dh-base.kbd # Base Colemak-DH layer + home-row mods + thumbs
    ├── symbols.kbd         # Symbols + NumRow layers
    └── navigation.kbd      # Navigation + FunPad + Workspace layers (NumPad removed — unused)
```

---

## Credits

- **[Kanata](https://github.com/jtroo/kanata)** — keyboard remapping engine.
- **[Colemak-DH](https://colemakmods.github.io/comfy-ergonomic-keyboard/colemak_dh.html)** — ergonomic alpha layout.
- **[Ergo-L / Lafayette](https://ergo-l.fr/)** — symbol layer inspiration.
