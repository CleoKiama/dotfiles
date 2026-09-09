#!/usr/bin/env python3
import os, re, html

defsrc_txt = open('defsrc/pc.kbd').read()
defsrc_toks = re.search(r'\(defsrc\n(.*?)\n\)', defsrc_txt, re.S).group(1).split()
key_to_idx = {tok: idx for idx, tok in enumerate(defsrc_toks)}

def get_layer(filename, lname):
    txt = open(filename).read()
    m = re.search(r'\(deflayer '+lname+r'\n(.*?)\n\)', txt, re.S)
    if not m: return []
    lines = [l for l in m.group(1).splitlines() if not l.strip().startswith(';;')]
    return re.findall(r'\([^)]+\)|\S+', '\n'.join(lines))

base_toks = get_layer('deflayer/colemak-dh-base.kbd', 'base')
sym_toks  = get_layer('deflayer/symbols.kbd', 'symbols')
num_toks  = get_layer('deflayer/symbols.kbd', 'numrow')
nav_toks  = get_layer('deflayer/navigation.kbd', 'navigation')
fp_toks   = get_layer('deflayer/navigation.kbd', 'funpad')
wsp_toks  = get_layer('deflayer/navigation.kbd', 'workspace')
med_toks  = get_layer('deflayer/media.kbd', 'media')
mod_toks  = get_layer('deflayer/navigation.kbd', 'modifiers')

GRID_KEYS = [
    ['`','1','2','3','4','6','7','8','9','0','-'],
    ['tab','q','w','e','r','y','u','i','o','p','['],
    ['caps','a','s','d','f','h','j','k','l',';',"'"],
    ['lshift','z','x','c','v','n','m',',','.','/']
]

# Map kanata aliases to user-friendly display labels
LABEL_MAP = {
    'XX': '', '_': '·',
    '@a': 'a', '@r': 'r', '@s': 's', '@t': 't',
    '@n': 'n', '@e': 'e', '@i': 'i', '@o': 'o',
    'rsft': 'Shift', 'lsft': 'Shift', 'lshift': 'Shift', 'rshift': 'Shift',
    'lalt': 'Alt', 'ralt': 'Alt', 'lctl': 'Ctrl', 'rctl': 'Ctrl', 'lmet': 'Super', 'rmet': 'Super',
    '@bspsym': 'Bspc / Sym', '@nav': 'Spc / Nav', '@shfwsp': 'Shf / Wksp', '@shf': 'Shift', '@entnum': 'Ret / Num', '@m-thumb': 'Shf / Mod',
    '@wsp': '/', '@med': 'Media', 'med': 'Media',
    '@os-sft': 'Shift', '@os-alt': 'Alt', '@os-met': 'Super', '@os-ctl': 'Ctrl',
    '@pl': '(', '@pr': ')', '@cl': '{', '@cr': '}', '@sl': '[', '@sr': ']',
    '@scl': ';', '@ndo': 'Undo', '@cut': 'Cut', '@cpy': 'Copy', '@rdo': 'Redo', '@pst': 'Paste',
    '@all': 'All', '@sav': 'Save', '@run': 'Run', '@fun': 'FunPad',
    '@std': 'Base', '@mwl': 'WhlL', '@mwd': 'WhlD', '@mwu': 'WhlU', '@mwr': 'WhlR',
    '@^': '^', '@<': '<', '@>': '>', '@$': '$', '@%': '%', '@@': '@', '@&': '&', '@*': '*', '@\'': '\'',
    '@{': '{', '@}': '}', '@=': '=', '@\\': '\\', '@+': '+', '@-': '-', '@/': '/',
    '@~': '~', '@[': '[', '@]': ']', '@_': '_', '@#': '#', '@|': '|', '@!': '!', '@:': ':',
    '@?': '?', '@`': '`', '@\'\'': '"', '@6': '6', '@7': '7', '@8': '8', '@9': '9', '@0': '0',
    '@1': '1', '@2': '2', '@3': '3', '@4': '4', '@5': '5',
    '@dk1': '', '@dk2': '', '@dk3': '', '@dk4': '', '@dk5': '',
    'lft': '←', 'down': '↓', 'up': '↑', 'rght': '→',
    '@bck': 'Alt+←', '@fwd': 'Alt+→', 'bck': 'Alt+←', 'fwd': 'Alt+→',
    '@cls': 'Ctrl+W', 'cls': 'Ctrl+W', 'S-tab': 'S-Tab', 'tab': 'Tab', 'del': 'Del',
    'home': 'Home', 'pgdn': 'PgDn', 'pgup': 'PgUp', 'end': 'End',
    'M-1': 'Wksp 1', 'M-2': 'Wksp 2', 'M-3': 'Wksp 3', 'M-4': 'Wksp 4', 'M-5': 'Wksp 5',
    'M-6': 'Wksp 6', 'M-7': 'Wksp 7', 'M-8': 'Wksp 8', 'M-9': 'Wksp 9', 'M-0': 'Wksp 10',
    'f1': 'F1', 'f2': 'F2', 'f3': 'F3', 'f4': 'F4', 'f5': 'F5', 'f6': 'F6',
    'f7': 'F7', 'f8': 'F8', 'f9': 'F9', 'f10': 'F10', 'f11': 'F11', 'f12': 'F12'
}

HRM_MODS = {'tab':'Shift','q':'Alt','w':'Super','e':'Ctrl','i':'Ctrl','o':'Super','p':'Alt','[':'Shift'}

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
    svg.append('    rect.key { fill: #ffffff; stroke: #cbd5e1; stroke-width: 1.5px; }')
    svg.append('    rect.gap { fill: #f1f5f9; stroke: #cbd5e1; stroke-dasharray: 4 4; }')
    svg.append('    rect.hrm { fill: #fff7ed; stroke: #f97316; stroke-width: 1.5px; }')
    svg.append('    rect.thumb { fill: #eff6ff; stroke: #3b82f6; stroke-width: 2px; }')
    
    svg.append('    text { font-family: system-ui, -apple-system, sans-serif; text-anchor: middle; }')
    svg.append('    text.title { font-size: 20px; font-weight: 800; fill: #0f172a; }')
    svg.append('    text.subtitle { font-size: 13px; font-weight: 500; fill: #64748b; }')
    svg.append('    text.phys { font-size: 9px; font-weight: 700; fill: #94a3b8; text-anchor: start; }')
    
    # Color classes for layer badges
    svg.append('    text.base { font-size: 15px; font-weight: 800; fill: #0f172a; }')
    svg.append('    text.mod { font-size: 10px; font-weight: 700; fill: #ea580c; }')
    svg.append('    text.sym { font-size: 12px; font-weight: 700; fill: #7c3aed; }')
    svg.append('    text.nav { font-size: 10px; font-weight: 700; fill: #059669; }')
    svg.append('    text.num { font-size: 11px; font-weight: 700; fill: #0284c7; }')
    svg.append('    text.dead { font-size: 12px; font-weight: 600; fill: #94a3b8; }')
    svg.append('    text.legend { font-size: 12px; font-weight: 600; text-anchor: start; }')
    
    # Dark Mode Styles
    svg.append('    @media (prefers-color-scheme: dark) {')
    svg.append('      rect.key { fill: #1e293b; stroke: #334155; }')
    svg.append('      rect.gap { fill: #0f172a; stroke: #334155; }')
    svg.append('      rect.hrm { fill: #2e1065; stroke: #a855f7; }')
    svg.append('      rect.thumb { fill: #172554; stroke: #3b82f6; }')
    svg.append('      text.title { fill: #f8fafc; }')
    svg.append('      text.subtitle { fill: #94a3b8; }')
    svg.append('      text.phys { fill: #94a3b8; }')
    svg.append('      text.base { fill: #f8fafc; }')
    svg.append('      text.mod { fill: #c084fc; }')
    svg.append('      text.sym { fill: #a78bfa; }')
    svg.append('      text.nav { fill: #34d399; }')
    svg.append('      text.num { fill: #38bdf8; }')
    svg.append('      text.dead { fill: #64748b; }')
    svg.append('    }')
    svg.append('  </style>')

    # Header Title
    svg.append('  <text x="425" y="38" class="title">Colemak-DH Layout</text>')

    # Color Legend
    svg.append('  <g transform="translate(45, 72)">')
    svg.append('    <circle cx="0" cy="0" r="5" fill="#0f172a"/>')
    svg.append('    <text x="10" y="4" class="legend" fill="#0f172a">Base Alpha</text>')
    svg.append('    <circle cx="110" cy="0" r="5" fill="#ea580c"/>')
    svg.append('    <text x="120" y="4" class="legend" fill="#ea580c">Home-Row Mod</text>')
    svg.append('    <circle cx="260" cy="0" r="5" fill="#7c3aed"/>')
    svg.append('    <text x="270" y="4" class="legend" fill="#7c3aed">Symbol Layer (x)</text>')
    svg.append('    <circle cx="410" cy="0" r="5" fill="#059669"/>')
    svg.append('    <text x="420" y="4" class="legend" fill="#059669">Nav Layer (c)</text>')
    svg.append('    <circle cx="540" cy="0" r="5" fill="#0284c7"/>')
    svg.append('    <text x="550" y="4" class="legend" fill="#0284c7">NumRow Layer (,)</text>')
    svg.append('    <circle cx="700" cy="0" r="5" fill="#3b82f6"/>')
    svg.append('    <text x="710" y="4" class="legend" fill="#3b82f6">Thumbs</text>')
    svg.append('  </g>')

    for r_idx, row in enumerate(GRID_KEYS):
        y = margin_y + r_idx * stride_y
        for c_idx, pkey in enumerate(row):
            is_right = (c_idx >= 6)
            is_dead_col = (c_idx == 5)
            is_thumb = (pkey in ('x', 'c', 'm', ','))

            # Skip rendering non-active layout keys (dead center column & non-thumb bottom keys)
            if is_dead_col or (r_idx == 3 and not is_thumb):
                continue

            x = margin_x + c_idx * stride_x + (gap_extra if is_right else 0)

            src_idx = key_to_idx[pkey]
            b_tok = base_toks[src_idx] if src_idx < len(base_toks) else 'XX'
            s_tok = sym_toks[src_idx]  if src_idx < len(sym_toks) else 'XX'
            n_tok = nav_toks[src_idx]  if src_idx < len(nav_toks) else 'XX'
            num_tok = num_toks[src_idx] if src_idx < len(num_toks) else 'XX'

            is_hrm = (pkey in HRM_MODS)

            rect_cls = ' class="key"'
            if is_thumb: rect_cls = ' class="thumb"'
            elif is_hrm: rect_cls = ' class="hrm"'
            elif b_tok == 'XX': rect_cls = ' class="gap"'

            svg.append(f'  <g transform="translate({x},{y})">')
            svg.append(f'    <rect width="{kw}" height="{kh}" rx="8"{rect_cls}/>')
            svg.append(f'    <text x="6" y="12" class="phys">{esc(pkey)}</text>')

            if b_tok == 'XX':
                svg.append(f'    <text x="32" y="38" class="dead">XX</text>')
            elif is_thumb:
                b_lbl = fmt(b_tok)
                parts = b_lbl.split(' / ')
                if len(parts) > 1:
                    svg.append(f'    <text x="32" y="32" class="base">{esc(parts[0])}</text>')
                    svg.append(f'    <text x="32" y="50" class="nav">{esc(parts[1])}</text>')
                else:
                    svg.append(f'    <text x="32" y="38" class="base">{esc(parts[0])}</text>')
            elif is_hrm:
                b_lbl = fmt(b_tok)
                mod_lbl = HRM_MODS[pkey]
                svg.append(f'    <text x="26" y="30" class="base">{esc(b_lbl)}</text>')
                svg.append(f'    <text x="26" y="46" class="mod">{esc(mod_lbl)}</text>')
                if s_tok != 'XX':
                    svg.append(f'    <text x="50" y="16" class="sym">{esc(fmt(s_tok))}</text>')
                if n_tok != 'XX':
                    nav_str = fmt(n_tok)
                    fsize = "7.5px" if len(nav_str) > 5 else ("8.5px" if len(nav_str) > 3 else "10px")
                    svg.append(f'    <text x="44" y="56" class="nav" font-size="{fsize}">{esc(nav_str)}</text>')
            else:
                # Normal Alpha Key with Multi-Layer Badges
                b_lbl = fmt(b_tok)
                b_fsize = ' font-size="12px"' if len(b_lbl) > 3 else ''
                svg.append(f'    <text x="20" y="36" class="base"{b_fsize}>{esc(b_lbl)}</text>')

                # Top Right: Symbol Layer Output
                if s_tok != 'XX' and s_tok != '_':
                    svg.append(f'    <text x="50" y="16" class="sym">{esc(fmt(s_tok))}</text>')
                
                # Bottom Right: Navigation Layer Output
                if n_tok != 'XX' and n_tok != '_':
                    nav_str = fmt(n_tok)
                    fsize = "7.5px" if len(nav_str) > 5 else ("8.5px" if len(nav_str) > 3 else "10px")
                    # Shift left slightly if num badge also present on this key
                    nav_x = "41" if (num_tok != 'XX' and num_tok != '_') else "44"
                    svg.append(f'    <text x="{nav_x}" y="56" class="nav" font-size="{fsize}">{esc(nav_str)}</text>')

                # Bottom Left: NumRow Layer Output
                if num_tok != 'XX' and num_tok != '_':
                    num_str = fmt(num_tok)
                    if num_str:
                        svg.append(f'    <text x="14" y="56" class="num">{esc(num_str)}</text>')

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
        'funpad':    ('fill: #fefce8; stroke: #ca8a04;', 'fill: #422006; stroke: #facc15;', '#ca8a04', '#facc15'),
        'thumbs':    ('fill: #eff6ff; stroke: #2563eb;', 'fill: #172554; stroke: #60a5fa;', '#2563eb', '#60a5fa')
    }
    
    l_light_bg, l_dark_bg, l_light_txt, l_dark_txt = theme_styles.get(theme_color, theme_styles['symbols'])

    svg = []
    svg.append('<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 780 350">')
    svg.append('  <style>')
    svg.append('    :root { color-scheme: light dark; }')
    svg.append('    rect.key { fill: #ffffff; stroke: #cbd5e1; stroke-width: 1.5px; }')
    svg.append('    rect.gap { fill: #f1f5f9; stroke: #cbd5e1; stroke-dasharray: 4 4; }')
    svg.append(f'    rect.active {{ {l_light_bg} stroke-width: 2px; }}')
    
    svg.append('    text { font-family: system-ui, -apple-system, sans-serif; text-anchor: middle; }')
    svg.append('    text.title { font-size: 19px; font-weight: 800; fill: #0f172a; }')
    svg.append('    text.subtitle { font-size: 13px; font-weight: 500; fill: #64748b; }')
    svg.append('    text.phys { font-size: 9px; font-weight: 700; fill: #94a3b8; text-anchor: start; }')
    svg.append(f'    text.main {{ font-size: 16px; font-weight: 800; fill: {l_light_txt}; }}')
    svg.append('    text.sub { font-size: 11px; font-weight: 600; fill: #64748b; }')
    svg.append('    text.hrm-sub { font-size: 11px; font-weight: 700; fill: #ea580c; }')
    svg.append('    text.dead { font-size: 11px; fill: #94a3b8; }')
    
    svg.append('    @media (prefers-color-scheme: dark) {')
    svg.append('      rect.key { fill: #1e293b; stroke: #334155; }')
    svg.append('      rect.gap { fill: #0f172a; stroke: #334155; }')
    svg.append(f'      rect.active {{ {l_dark_bg} }}')
    svg.append('      text.title { fill: #f8fafc; }')
    svg.append('      text.subtitle { fill: #94a3b8; }')
    svg.append('      text.phys { fill: #94a3b8; }')
    svg.append(f'      text.main {{ fill: {l_dark_txt}; }}')
    svg.append('      text.sub { fill: #94a3b8; }')
    svg.append('      text.hrm-sub { fill: #fb923c; }')
    svg.append('      text.dead { fill: #64748b; }')
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
            is_thumb = (pkey in ('x', 'c', 'm', ','))

            # Skip rendering non-active layout keys (dead center column & non-thumb bottom keys)
            if is_dead_col or (r_idx == 3 and not is_thumb):
                continue

            x = margin_x + c_idx * stride_x + (gap_extra if is_right else 0)

            src_idx = key_to_idx[pkey]
            raw_tok = layer_toks[src_idx] if src_idx < len(layer_toks) else 'XX'
            val = fmt(raw_tok)

            is_active = (raw_tok != 'XX' and raw_tok != '_')
            rect_cls = ' class="key"'
            if is_thumb: rect_cls = ' class="active"'
            elif is_active: rect_cls = ' class="active"'
            else: rect_cls = ' class="gap"'

            svg.append(f'  <g transform="translate({x},{y})">')
            svg.append(f'    <rect width="{kw}" height="{kh}" rx="8"{rect_cls}/>')
            svg.append(f'    <text x="6" y="12" class="phys">{esc(pkey)}</text>')

            if raw_tok == 'XX':
                svg.append(f'    <text x="30" y="36" class="dead">XX</text>')
            elif ' / ' in val:
                parts = val.split(' / ')
                svg.append(f'    <text x="30" y="30" class="main">{esc(parts[0])}</text>')
                svg.append(f'    <text x="30" y="48" class="sub">{esc(parts[1])}</text>')
            elif pkey in HRM_MODS:
                mod_lbl = HRM_MODS[pkey]
                fsize_style = ' font-size="11px"' if len(val) > 4 else ''
                if val == mod_lbl:
                    # In modifiers layer, avoid duplicate label (e.g. Shift / Shift)
                    svg.append(f'    <text x="30" y="36" class="main"{fsize_style}>{esc(val)}</text>')
                else:
                    svg.append(f'    <text x="30" y="28" class="main"{fsize_style}>{esc(val)}</text>')
                    svg.append(f'    <text x="30" y="46" class="hrm-sub">{esc(mod_lbl)}</text>')
            else:
                fsize_style = ' font-size="11px"' if len(val) > 4 else ''
                svg.append(f'    <text x="30" y="36" class="main"{fsize_style}>{esc(val)}</text>')

            svg.append('  </g>')

    svg.append('</svg>')
    return '\n'.join(svg)


# Write all SVG files
os.makedirs('docs/images', exist_ok=True)

svgs = {
    'all.svg': render_all_svg(),
    'hrm.svg': render_layer_svg('Home-Row Mods (Top Row)', 'tab q w e → Shift Alt Super Ctrl  |  i o p → Ctrl Super Alt', base_toks, 'hrm'),
    'layer_taps.svg': render_layer_svg('Thumb Layer Taps', 'x: Bspc / Sym  |  c: Spc / Nav  |  m: Shf / Mod  |  ,: Ret / Num', base_toks, 'thumbs'),
    'symbols.svg': render_layer_svg('Symbols Layer', 'Activated by Holding Left Mid Thumb (x)', sym_toks, 'symbols'),
    'navigation.svg': render_layer_svg('Navigation & Editor Layer', 'Activated by Holding Left Index Thumb (c)', nav_toks, 'navigation'),
    'modifiers.svg': render_layer_svg('Modifiers Layer (One-Shot / Held)', 'Activated by Holding Right Index Thumb (m)', mod_toks, 'hrm'),
    'numrow.svg': render_layer_svg('NumRow Layer', 'Activated by Holding Right Mid Thumb (,) — Digits 1..0', num_toks, 'numrow'),
    'workspace.svg': render_layer_svg('Workspace Layer', 'Activated by Holding Right Pinky (/) — Super+1..0', wsp_toks, 'workspace'),
    'media.svg': render_layer_svg('Media Layer', 'Activated by Holding Physical j Key — Playback & Volume', med_toks, 'symbols'),
    'fn.svg': render_layer_svg('FunPad Sub-Layer', 'F1..F12 Function Keys', fp_toks, 'funpad'),
}

for filename, content in svgs.items():
    path = os.path.join('docs/images', filename)
    open(path, 'w').write(content)
    print(f"Generated clean {path}")
