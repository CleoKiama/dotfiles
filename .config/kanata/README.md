# Kanata Layout: Ergonomic-Shift Colemak-DH

A [Kanata](https://github.com/jtroo/kanata) implementation of the Ergonomic-Shift Colemak-DH layout for standard staggered keyboards.

## Overview and design philosophy

Ergonomic-Shift converts a standard staggered keyboard into a columnar layout by shifting hand positions:

1. **Shift-up and tab-origin (1-column left shift)**: The alpha block shifts up by one physical row. The left hand shifts left by 1 column (tab-origin) for a straight wrist posture.
   - Left hand home row starts on `tab`: `tab q w e r` maps to `a r s t g`.
   - Left hand top row starts on `` ` ``: `` ` 1 2 3 4 `` maps to `q w f p b`.
   - Left hand bottom alpha row starts on `caps`: `caps a s d f` maps to `z x c d v`.
   - Thumb keys move inward: left thumbs on `x` and `c`, right thumbs on `m` (`@m-thumb`) and `,` (`@entnum`).
2. **Split hands (double dead gap)**: Physical columns `5, t, g, b` and `6, y, h, n` (plus `bspc`) are dead (`XX`). This creates a 2-column vertical gap between hands while keeping Colemak-DH column assignments straight.

### Layout overview

![Full Ergonomic-Shift Layout](docs/images/all.svg)

### Key features

- **Colemak-DH base**: Standard Colemak-DH letter layout.
- **Un-angled bottom alpha row**: Standard Colemak-DH columns (`z x c d v` mapped to physical `caps a s d f`). Because physical Row 3 staggers 0.25U right of Row 2, standard fingering matches arm geometry without requiring an angle mod.
- **Home-row mods**: Left hand mods sit on `tab q w e` (`tab` = `a`/Shift, `q` = `r`/Alt, `w` = `s`/Super, `e` = `t`/Ctrl). Right hand mods sit on `i o p [` (Ctrl, Super, Alt, Shift).
- **Escape combo**: Pressing physical keys `2` and `3` (`f` and `p`) together sends Escape.
- **4 thumb keys**:
  - `x` (Left Middle): Tap for Backspace, hold for Symbols layer.
  - `c` (Left Index): Tap for Space, hold for Navigation layer.
  - `m` (Right Index, rest position): Tap for one-shot Shift (`@os-sft`), hold for Modifiers layer (`@m-thumb`).
  - `,` (Right Middle, angled): Tap for Enter, hold for NumRow layer.
- **Full key capture**: Only the 35-key Ergonomic-Shift cluster is captured in `defsrc`. Everything else (arrows, F-keys, numpad, spacebar row, outer keys) is a hard no-op via `block-unmapped-keys`. Brightness and speaker keys still work because they are firmware-level Fn combos, untouched by kanata.

---

## Physical keyboard mapping

### Left hand (tab-origin shift, column 5 dead)

```
Physical Row                Mapping (Output)
─────────────────────────────────────────────────────────────
1  2  3  4                  w  f  p  b      (Number row, 2+3 = Esc combo)
tab q  w  e  r              @a @r @s @t  g  (Top row, HOME: Shift, Alt, Super, Ctrl, g)
caps a  s  d  f             z  x  c  d  v  (Home row, Bottom alpha row)
x  c                       Bspc/Sym  Spc/Nav (Thumbs)
```

### Right hand (columns 7-11, column 6 dead)

```
Physical Row            Mapping (Output)
─────────────────────────────────────────────────────────────
7  8  9  0              j  l  u  y  (Number row)
u  i  o  p              m  Ctrl Super Alt (Top row, HOME)
j  k  l  ;              Med  h  ,  .  (Home row)
m  ,                    Shf/Mod  Ret/Num (Thumbs)
'  -  `  [              Wksp  ;  q  Shift  (Outer row, right-pinky hold = Workspace)
```

- Physical columns 5 and 6 (`5 t g b`, `6 y h n`) are excluded from `defsrc` and dead by definition.
- F-row, arrows, numpad, spacebar row, and all other outer keys are excluded from `defsrc` and blocked by `block-unmapped-keys`.

---

## Layers

### Base: Colemak-DH and home-row mods

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

### Thumb keys

![Thumb Keys](docs/images/layer_taps.svg)

| Thumb Key   | Physical Key | Tap                  | Hold Layer          |
| ----------- | ------------ | -------------------- | ------------------- |
| Left Mid    | `x`          | Backspace            | Symbols             |
| Left Idx    | `c`          | Space                | Navigation          |
| Right Idx   | `m` (Rest)   | One-Shot Shift (`@os-sft`) | Modifiers     |
| Right Mid   | `,` (Angled) | Enter                | NumRow              |

### Symbols layer

![Symbols Layer](docs/images/symbols.svg)

Holding `x` (Left Mid thumb) activates this layer. It provides Lafayette and Ergo-L programming symbols:

```
Number row:  _  <  >  $  %  | (col 6 dead) |  @  &  *  '
Top row:     {  (  )  }  =  | (col 6 dead) |  \  +  -  /  "
Home row:    ~  ;  :  ^  #  | (col 6 dead) |  |  !  [  ]
Bottom row:  ?  `           | (col 6 dead) |  "
```

### Modifiers layer

![Modifiers Layer](docs/images/modifiers.svg)

Holding right thumb `m` (`@m-thumb`) activates this layer. It provides sticky one-shot and held modifiers on the home row:

| Hand  | Key (Physical) | Key (Logical) | Modifier |
| ----- | -------------- | ------------- | -------- |
| Left  | `tab`          | Pinky         | Shift    |
| Left  | `q`            | Ring          | Alt      |
| Left  | `w`            | Middle        | Super    |
| Left  | `e`            | Index         | Ctrl     |
| Right | `i` (`u`)      | Index         | Ctrl     |
| Right | `o` (`i`)      | Middle        | Super    |
| Right | `p` (`o`)      | Ring          | Alt      |
| Right | `[` (`;`)      | Pinky         | Shift    |

```
Left Hand (tab q w e):    Shift   Alt    Super   Ctrl
Right Hand (u i o ;):     Ctrl    Super  Alt     Shift
```

### Navigation layer

![Navigation Layer](docs/images/navigation.svg)

Holding `c` (Left Idx thumb) activates this layer. It places Vim navigation on the right hand and editor shortcuts on the left hand:

```
Top row:     Close(Ctrl+W)  XX           XX          XX          XX          |  Home   PgDn   PgUp   End
Home row:    Back(Alt+←)    S-Tab        Tab         Fwd(Alt+→)  XX          |  Left   Down   Up     Right
Bottom row:  Undo(Ctrl+Z)   Cut(Ctrl+X)  Copy(Ctrl+C) Redo(Ctrl+Y) Paste(Ctrl+V) |  WheelL WheelD WheelU WheelR
```

- Holds of physical `[` (`@fun`) access F1-F12 from the `navigation` layer.

### NumRow layer

![NumRow Layer](docs/images/numrow.svg)

Holding `,` (Right Mid thumb) activates this layer. It maps numbers 1-0 to the left hand:

```
Top row:     6  7  8  9  0
Home row:    1  2  3  4  5
```

Right-hand keys pass through as plain letters (`_`) so relative movement commands like `2j` or `2k` work without layer interference.

### Workspace layer

![Workspace Layer](docs/images/workspace.svg)

Holding `/` (Right Pinky, physical quote key `'`) activates this layer. It sends Super+1 through Super+0 on the left hand for window manager workspace switching:

```
Top row:     Super+6  Super+7  Super+8  Super+9  Super+0
Home row:    Super+1  Super+2  Super+3  Super+4  Super+5
```

---

## Configuration

### Variables and hand definitions

```lisp
(defhands
  (left  ` 1 2 3 4 tab q w e r caps a s d f x c)
  (right 7 8 9 0 - u i o p [ ' j k l ; m ,))

(defvar
  tap-time 180          ;; ms to register a tap
  hold-time 180         ;; ms to register a hold (tuned for 40 WPM)
)
```

### Hard-blocking unused keys

`defsrc` captures only the 35-key cluster. `process-unmapped-keys yes` makes kanata aware of every other key; `block-unmapped-keys yes` turns all of them into no-ops:

```lisp
(defcfg
  process-unmapped-keys yes
  block-unmapped-keys yes
  concurrent-tap-hold yes
)
```

Excluded keys also stay out of kanata's state machine, so a stray numpad or arrow press can no longer disturb a pending tap-hold or one-shot decision.

### Timeless home-row mods (`defhands` + `tap-hold-opposite-hand`)

- **Bilateral opposite-hand trigger**: Home-row mods use Kanata's native `tap-hold-opposite-hand` driven by `defhands`. Pressing an opposite-hand key activates the modifier immediately on key-down.
- **Require prior idle (`(require-prior-idle 200)`)**: Requires a 200ms pause after typing before a key can activate a modifier hold, tuned to prevent misfires at 40 WPM.
- **Same-hand suppression**: Pressing a same-hand key resolves as a plain tap immediately, preventing accidental shortcuts during fast rolls on the same hand.
- **Live reload**: `prtsc` maps to `lrld` to reload config without restarting Kanata.

---

## File structure

```
.config/kanata/
├── config.kbd              # Main config: defcfg, defvar, defhands, includes
├── defsrc/
│   └── pc.kbd              # Source key capture (35-key cluster)
├── defalias/
│   └── qwerty.kbd          # Shared symbol and shortcut aliases
└── deflayer/
    ├── colemak-dh-base.kbd # Base Colemak-DH layer, home-row mods, thumbs
    ├── symbols.kbd         # Symbols and NumRow layers
    └── navigation.kbd      # Navigation, Modifiers, FunPad, Workspace layers
```

---

## Credits

- **[Kanata](https://github.com/jtroo/kanata)**, keyboard remapping engine.
- **[Colemak-DH](https://colemakmods.github.io/comfy-ergonomic-keyboard/colemak_dh.html)**, ergonomic alpha layout.
- **[Ergo-L / Lafayette](https://ergo-l.fr/)**, symbol layer inspiration.
