#!/usr/bin/env python3
import os, re, html

defsrc_txt = open('defsrc/pc.kbd').read()
defsrc_toks = re.search(r'\(defsrc\n(.*?)\n\)', defsrc_txt, re.S).group(1).split()
key_to_idx = {tok: idx for idx, tok in enumerate(defsrc_toks)}

def get_layer(filename, lname):
    txt = open(filename).read()
    m = re.search(r'\(deflayer '+lname+r'\n(.*?)\n\)', txt, re.S)
    return m.group(1).split() if m else []

base_toks = get_layer('deflayer/colemak-dh-base.kbd', 'base')
sym_toks  = get_layer('deflayer/symbols.kbd', 'symbols')
num_toks  = get_layer('deflayer/symbols.kbd', 'numrow')
nav_toks  = get_layer('deflayer/navigation.kbd', 'navigation')
np_toks   = get_layer('deflayer/navigation.kbd', 'numpad')
fp_toks   = get_layer('deflayer/navigation.kbd', 'funpad')
wsp_toks  = get_layer('deflayer/navigation.kbd', 'workspace')
med_toks  = get_layer('deflayer/media.kbd', 'media')

GRID_KEYS = [
    ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '-'],
    ['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p', '['],
    ['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', ';', "'"],
    ['z', 'x', 'c', 'v', 'b', 'n', 'm', ',', '.', '/']
]

# Map kanata aliases to user-friendly display labels
LABEL_MAP = {
    'XX': '', '_': '·',
    '@a': 'a', '@r': 'r', '@s': 's', '@t': 't',
    '@n': 'n', '@e': 'e', '@i': 'i', '@o': 'o',
    '@num': 'Bspc / Num', '@escwsp': 'Esc / Wksp', '@nav': 'Spc / Nav', '@sym': 'Ret / Sym',
    '@pl': '(', '@pr': ')', '@cl': '{', '@cr': '}', '@sl': '[', '@sr': ']',
    '@scl': ';', '@ndo': 'Undo', '@cut': 'Cut', '@cpy': 'Copy', '@pst': 'Paste',
    '@all': 'All', '@sav': 'Save', '@run': 'Run', '@fun': 'FunPad', '@pad': 'NumPad',
    '@std': 'Base', '@mwl': 'WhlL', '@mwd': 'WhlD', '@mwu': 'WhlU', '@mwr': 'WhlR',
    '@^': '^', '@<': '<', '@>': '>', '@$': '$', '@%': '%', '@@': '@', '@&': '&', '@*': '*', '@\'': '\'',
    '@{': '{', '@}': '}', '@=': '=', '@\\': '\\', '@+': '+', '@-': '-', '@/': '/',
    '@~': '~', '@[': '[', '@]': ']', '@_': '_', '@#': '#', '@|': '|', '@!': '!', '@:': ':',
    '@?': '?', '@`': '`', '@\'\'': '"', '@6': '6', '@7': '7', '@8': '8', '@9': '9', '@0': '0',
    '@1': '1', '@2': '2', '@3': '3', '@4': '4', '@5': '5',
    '@dk1': 'dk1', '@dk2': 'dk2', '@dk3': 'dk3', '@dk4': 'dk4', '@dk5': 'dk5',
    'lft': '←', 'down': '↓', 'up': '↑', 'rght': '→',
    'bck': 'Alt+←', 'fwd': 'Alt+→', 'cls': 'Ctrl+W', 'S-tab': 'S-Tab', 'tab': 'Tab', 'del': 'Del',
    'home': 'Home', 'pgdn': 'PgDn', 'pgup': 'PgUp', 'end': 'End',
    'M-1': 'Wksp 1', 'M-2': 'Wksp 2', 'M-3': 'Wksp 3', 'M-4': 'Wksp 4', 'M-5': 'Wksp 5',
    'M-6': 'Wksp 6', 'M-7': 'Wksp 7', 'M-8': 'Wksp 8', 'M-9': 'Wksp 9', 'M-0': 'Wksp 10'
}

HRM_MODS = {
    'q': 'Shift', 'w': 'Alt', 'e': 'Super', 'r': 'Ctrl',
    'i': 'Ctrl', 'o': 'Super', 'p': 'Alt', '[': 'Shift'
}

def fmt(tok):
    return LABEL_MAP.get(tok, tok)

def esc(s):
    return html.escape(str(s))

def render_all_svg():
    kw, kh = 64, 64
    stride_x, stride_y = 72, 72
    margin_x, margin_y = 24, 100
    gap_extra = 32

    svg = []
    svg.append('<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 850 440">')
    svg.append('  <style>')
    svg.append('    :root { color-scheme: light dark; }')
    svg.append('    rect.key { fill: #ffffff; stroke: #cbd5e1; stroke-width: 1.5px; rx: 8px; ry: 8px; }')
    svg.append('    rect.gap { fill: #f1f5f9; stroke: #cbd5e1; stroke-dasharray: 4 4; rx: 8px; ry: 8px; }')
    svg.append('    rect.hrm { fill: #fff7ed; stroke: #f97316; stroke-width: 1.5px; rx: 8px; ry: 8px; }')
    svg.append('    rect.thumb { fill: #eff6ff; stroke: #3b82f6; stroke-width: 2px; rx: 8px; ry: 8px; }')
    
    svg.append('    text { font-family: system-ui, -apple-system, sans-serif; text-anchor: middle; }')
    svg.append('    text.title { font-size: 20px; font-weight: 800; fill: #0f172a; }')
    svg.append('    text.subtitle { font-size: 13px; font-weight: 500; fill: #64748b; }')
    svg.append('    text.phys { font-size: 9px; font-weight: 700; fill: #94a3b8; text-anchor: start; }')
    
    # Color classes for layer badges
    svg.append('    text.base { font-size: 15px; font-weight: 800; fill: #0f172a; }')
    svg.append('    text.mod { font-size: 10px; font-weight: 700; fill: #ea580c; }')
    svg.append('    text.sym { font-size: 12px; font-weight: 700; fill: #7c3aed; }')
    svg.append('    text.nav { font-size: 11px; font-weight: 700; fill: #059669; }')
    svg.append('    text.num { font-size: 11px; font-weight: 700; fill: #0284c7; }')
    svg.append('    text.dead { font-size: 12px; font-weight: 600; fill: #cbd5e1; }')
    svg.append('    text.legend { font-size: 12px; font-weight: 600; text-anchor: start; }')
    
    # Dark Mode Styles
    svg.append('    @media (prefers-color-scheme: dark) {')
    svg.append('      rect.key { fill: #1e293b; stroke: #334155; }')
    svg.append('      rect.gap { fill: #0f172a; stroke: #334155; }')
    svg.append('      rect.hrm { fill: #2e1065; stroke: #a855f7; }')
    svg.append('      rect.thumb { fill: #172554; stroke: #3b82f6; }')
    svg.append('      text.title { fill: #f8fafc; }')
    svg.append('      text.subtitle { fill: #94a3b8; }')
    svg.append('      text.phys { fill: #64748b; }')
    svg.append('      text.base { fill: #f8fafc; }')
    svg.append('      text.mod { fill: #c084fc; }')
    svg.append('      text.sym { fill: #a78bfa; }')
    svg.append('      text.nav { fill: #34d399; }')
    svg.append('      text.num { fill: #38bdf8; }')
    svg.append('      text.dead { fill: #475569; }')
    svg.append('    }')
    svg.append('  </style>')

    # Header Title
    svg.append('  <text x="425" y="32" class="title">Ergonomic-Shift Colemak-DH — Master Multi-Layer Map</text>')
    svg.append('  <text x="425" y="52" class="subtitle">Row Shift-Up  •  Col 6 Split Gap (XX)  •  Color-Coded Dual Roles</text>')

    # Color Legend
    svg.append('  <g transform="translate(45, 72)">')
    svg.append('    <circle cx="0" cy="0" r="5" fill="#0f172a"/>')
    svg.append('    <text x="10" y="4" class="legend" fill="#0f172a">Base Alpha</text>')
    svg.append('    <circle cx="110" cy="0" r="5" fill="#ea580c"/>')
    svg.append('    <text x="120" y="4" class="legend" fill="#ea580c">🟠 Home-Row Mod</text>')
    svg.append('    <circle cx="270" cy="0" r="5" fill="#7c3aed"/>')
    svg.append('    <text x="280" y="4" class="legend" fill="#7c3aed">🟣 Symbol Layer (,)</text>')
    svg.append('    <circle cx="430" cy="0" r="5" fill="#059669"/>')
    svg.append('    <text x="440" y="4" class="legend" fill="#059669">🟢 Nav Layer (m)</text>')
    svg.append('    <circle cx="580" cy="0" r="5" fill="#0284c7"/>')
    svg.append('    <text x="590" y="4" class="legend" fill="#0284c7">🩵 NumRow Layer (c)</text>')
    svg.append('    <circle cx="730" cy="0" r="5" fill="#3b82f6"/>')
    svg.append('    <text x="740" y="4" class="legend" fill="#3b82f6">🔵 Thumbs</text>')
    svg.append('  </g>')

    for r_idx, row in enumerate(GRID_KEYS):
        y = margin_y + r_idx * stride_y
        for c_idx, pkey in enumerate(row):
            is_right = (c_idx >= 6)
            is_dead_col = (c_idx == 5)
            x = margin_x + c_idx * stride_x + (gap_extra if is_right else 0)

            src_idx = key_to_idx[pkey]
            b_tok = base_toks[src_idx] if src_idx < len(base_toks) else 'XX'
            s_tok = sym_toks[src_idx]  if src_idx < len(sym_toks) else 'XX'
            n_tok = nav_toks[src_idx]  if src_idx < len(nav_toks) else 'XX'
            num_tok = num_toks[src_idx] if src_idx < len(num_toks) else 'XX'

            is_thumb = (pkey in ('c', 'v', 'm', ','))
            is_hrm = (pkey in HRM_MODS)

            rect_cls = ' class="key"'
            if is_dead_col or b_tok == 'XX': rect_cls = ' class="gap"'
            elif is_thumb: rect_cls = ' class="thumb"'
            elif is_hrm: rect_cls = ' class="hrm"'

            svg.append(f'  <g transform="translate({x},{y})">')
            svg.append(f'    <rect width="{kw}" height="{kh}"{rect_cls}/>')
            svg.append(f'    <text x="6" y="12" class="phys">{esc(pkey)}</text>')

            if is_dead_col or b_tok == 'XX':
                svg.append(f'    <text x="32" y="38" class="dead">XX</text>')
            elif is_thumb:
                b_lbl = fmt(b_tok)
                parts = b_lbl.split(' / ')
                svg.append(f'    <text x="32" y="32" class="base">{esc(parts[0])}</text>')
                svg.append(f'    <text x="32" y="50" class="nav">{esc(parts[1])}</text>')
            elif is_hrm:
                b_lbl = fmt(b_tok)
                mod_lbl = HRM_MODS[pkey]
                svg.append(f'    <text x="32" y="30" class="base">{esc(b_lbl)}</text>')
                svg.append(f'    <text x="32" y="44" class="mod">{esc(mod_lbl)}</text>')
                if s_tok != 'XX':
                    svg.append(f'    <text x="52" y="16" class="sym">{esc(fmt(s_tok))}</text>')
                if n_tok != 'XX':
                    svg.append(f'    <text x="52" y="58" class="nav">{esc(fmt(n_tok))}</text>')
            else:
                # Normal Alpha Key with Multi-Layer Badges
                b_lbl = fmt(b_tok)
                svg.append(f'    <text x="24" y="36" class="base">{esc(b_lbl)}</text>')

                # Top Right: Symbol Layer Output
                if s_tok != 'XX' and s_tok != '_':
                    svg.append(f'    <text x="52" y="16" class="sym">{esc(fmt(s_tok))}</text>')
                
                # Bottom Right: Navigation Layer Output
                if n_tok != 'XX' and n_tok != '_':
                    svg.append(f'    <text x="52" y="58" class="nav">{esc(fmt(n_tok))}</text>')

                # Bottom Left: NumRow Layer Output
                if num_tok != 'XX' and num_tok != '_':
                    svg.append(f'    <text x="12" y="58" class="num">{esc(fmt(num_tok))}</text>')

            svg.append('  </g>')

    svg.append('</svg>')
    return '\n'.join(svg)


def render_layer_svg(title, subtitle, layer_toks, theme_color, layer_name=""):
    kw, kh = 60, 60
    stride_x, stride_y = 66, 66
    margin_x, margin_y = 20, 70
    gap_extra = 30

    theme_styles = {
        'hrm':       ('fill: #fff7ed; stroke: #ea580c;', 'fill: #2e1065; stroke: #c084fc;', '#ea580c', '#c084fc'),
        'symbols':   ('fill: #f5f3ff; stroke: #7c3aed;', 'fill: #2e1065; stroke: #a78bfa;', '#7c3aed', '#a78bfa'),
        'navigation':('fill: #ecfdf5; stroke: #059669;', 'fill: #064e3b; stroke: #34d399;', '#059669', '#34d399'),
        'numrow':    ('fill: #f0f9ff; stroke: #0284c7;', 'fill: #0c4a6e; stroke: #38bdf8;', '#0284c7', '#38bdf8'),
        'workspace': ('fill: #fff1f2; stroke: #e11d48;', 'fill: #4c0519; stroke: #fb7185;', '#e11d48', '#fb7185'),
        'numpad':    ('fill: #f0fdf4; stroke: #16a34a;', 'fill: #052e16; stroke: #4ade80;', '#16a34a', '#4ade80'),
        'funpad':    ('fill: #fefce8; stroke: #ca8a04;', 'fill: #422006; stroke: #facc15;', '#ca8a04', '#facc15'),
        'thumbs':    ('fill: #eff6ff; stroke: #2563eb;', 'fill: #172554; stroke: #60a5fa;', '#2563eb', '#60a5fa')
    }
    
    l_light_bg, l_dark_bg, l_light_txt, l_dark_txt = theme_styles.get(theme_color, theme_styles['symbols'])

    svg = []
    svg.append('<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 780 350">')
    svg.append('  <style>')
    svg.append('    :root { color-scheme: light dark; }')
    svg.append('    rect.key { fill: #ffffff; stroke: #cbd5e1; stroke-width: 1.5px; rx: 8px; ry: 8px; }')
    svg.append('    rect.gap { fill: #f1f5f9; stroke: #cbd5e1; stroke-dasharray: 4 4; rx: 8px; ry: 8px; }')
    svg.append(f'    rect.active {{ {l_light_bg} stroke-width: 2px; rx: 8px; ry: 8px; }}')
    
    svg.append('    text { font-family: system-ui, -apple-system, sans-serif; text-anchor: middle; }')
    svg.append('    text.title { font-size: 19px; font-weight: 800; fill: #0f172a; }')
    svg.append('    text.subtitle { font-size: 13px; font-weight: 500; fill: #64748b; }')
    svg.append('    text.phys { font-size: 9px; font-weight: 700; fill: #94a3b8; text-anchor: start; }')
    svg.append(f'    text.main {{ font-size: 16px; font-weight: 800; fill: {l_light_txt}; }}')
    svg.append('    text.sub { font-size: 11px; font-weight: 600; fill: #64748b; }')
    svg.append('    text.dead { font-size: 11px; fill: #cbd5e1; }')
    
    svg.append('    @media (prefers-color-scheme: dark) {')
    svg.append('      rect.key { fill: #1e293b; stroke: #334155; }')
    svg.append('      rect.gap { fill: #0f172a; stroke: #334155; }')
    svg.append(f'      rect.active {{ {l_dark_bg} }}')
    svg.append('      text.title { fill: #f8fafc; }')
    svg.append('      text.subtitle { fill: #94a3b8; }')
    svg.append('      text.phys { fill: #64748b; }')
    svg.append(f'      text.main {{ fill: {l_dark_txt}; }}')
    svg.append('      text.sub { fill: #94a3b8; }')
    svg.append('      text.dead { fill: #475569; }')
    svg.append('    }')
    svg.append('  </style>')

    # Title
    svg.append(f'  <text x="390" y="28" class="title">{esc(title)}</text>')
    svg.append(f'  <text x="390" y="48" class="subtitle">{esc(subtitle)}</text>')

    for r_idx, row in enumerate(GRID_KEYS):
        y = margin_y + r_idx * stride_y
        for c_idx, pkey in enumerate(row):
            is_right = (c_idx >= 6)
            is_dead_col = (c_idx == 5)
            x = margin_x + c_idx * stride_x + (gap_extra if is_right else 0)

            src_idx = key_to_idx[pkey]
            raw_tok = layer_toks[src_idx] if src_idx < len(layer_toks) else 'XX'
            val = fmt(raw_tok)

            is_active = (raw_tok != 'XX' and raw_tok != '_')
            rect_cls = ' class="key"'
            if is_dead_col or raw_tok == 'XX': rect_cls = ' class="gap"'
            elif is_active: rect_cls = ' class="active"'

            svg.append(f'  <g transform="translate({x},{y})">')
            svg.append(f'    <rect width="{kw}" height="{kh}"{rect_cls}/>')
            svg.append(f'    <text x="6" y="12" class="phys">{esc(pkey)}</text>')

            if is_dead_col or raw_tok == 'XX':
                svg.append(f'    <text x="30" y="36" class="dead">XX</text>')
            elif theme_color == 'thumbs' and ' / ' in val:
                parts = val.split(' / ')
                svg.append(f'    <text x="30" y="32" class="main">{esc(parts[0])}</text>')
                svg.append(f'    <text x="30" y="48" class="sub">{esc(parts[1])}</text>')
            else:
                svg.append(f'    <text x="30" y="36" class="main">{esc(val)}</text>')

            svg.append('  </g>')

    svg.append('</svg>')
    return '\n'.join(svg)


# Write all SVG files
os.makedirs('docs/images', exist_ok=True)

svgs = {
    'all.svg': render_all_svg(),
    'hrm.svg': render_layer_svg('Home-Row Mods (Top Row)', 'q w e r → Shift Alt Super Ctrl  |  i o p [ → Ctrl Super Alt Shift', base_toks, 'hrm'),
    'layer_taps.svg': render_layer_svg('Thumb Layer Taps', 'c: Bspc / Num  |  v: Esc / Wksp  |  m: Spc / Nav  |  ,: Ret / Sym', base_toks, 'thumbs'),
    'symbols.svg': render_layer_svg('Symbols Layer', 'Activated by Holding Right Mid Thumb (,)', sym_toks, 'symbols'),
    'navigation.svg': render_layer_svg('Navigation & Editor Layer', 'Activated by Holding Right Index Thumb (m)', nav_toks, 'navigation'),
    'numrow.svg': render_layer_svg('NumRow Layer', 'Activated by Holding Left Mid Thumb (c) — Digits 1..0', num_toks, 'numrow'),
    'workspace.svg': render_layer_svg('Workspace Layer', 'Activated by Holding Left Index Thumb (v) — Super+1..0', wsp_toks, 'workspace'),
    'media.svg': render_layer_svg('Media Layer', 'Activated by Holding Physical j Key — Playback & Volume', med_toks, 'symbols'),
    'numpad.svg': render_layer_svg('NumPad Sub-Layer', 'Calculator Layout & Arrow Navigation', np_toks, 'numpad'),
    'fn.svg': render_layer_svg('FunPad Sub-Layer', 'F1..F12 Function Keys', fp_toks, 'funpad'),
    'angle_mod.svg': render_layer_svg('Angle Mod (Left Hand)', 'Physical Home Row (a s d f g) → x c d v z', base_toks, 'hrm')
}

for filename, content in svgs.items():
    path = os.path.join('docs/images', filename)
    open(path, 'w').write(content)
    print(f"Generated vibrant {path}")

