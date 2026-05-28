#!/usr/bin/env bash
# migrate-to-flat.sh — Restructure dotfiles from per-app stow packages to flat layout
# Usage:
#   ./migrate-to-flat.sh --dry-run   # Preview changes
#   ./migrate-to-flat.sh             # Execute migration

set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
DRY_RUN=false

if [[ "${1:-}" == "--dry-run" ]]; then
    DRY_RUN=true
    echo "=== DRY RUN MODE — no changes will be made ==="
    echo
fi

# Packages that have .config/ content inside their stow directory
CONFIG_PKGS=(
    alacritty atuin bookmarks doom fish fontconfig ghostty
    hypr kitty mango mpv niri nvim opencode rofi starship
    sunsetr swaync systemd waybar wlogout yazi
)

# scripts/ is special — it targets ~/scripts/, not ~/.config/
SCRIPTS_PKG=scripts

# git/ targets $HOME directly (.gitconfig), not .config/
HOME_PKGS=(git)

run() {
    if $DRY_RUN; then
        echo "[would run] $*"
    else
        echo "[running] $*"
        "$@"
    fi
}

# ─── Step 1: Unstow all affected packages ───────────────────────────────────
echo "=== Step 1: Unstowing current packages ==="

for pkg in "${CONFIG_PKGS[@]}" "${HOME_PKGS[@]}" "$SCRIPTS_PKG"; do
    if [[ -d "$DOTFILES/$pkg" ]]; then
        run stow -d "$DOTFILES" -t "$HOME" -D "$pkg"
    fi
done
echo

# ─── Step 2: Create the flat .config/ directory at repo root ─────────────────
echo "=== Step 2: Restructuring into flat layout ==="

if ! $DRY_RUN; then
    mkdir -p "$DOTFILES/.config"
fi

for pkg in "${CONFIG_PKGS[@]}"; do
    src="$DOTFILES/$pkg/.config"
    if [[ -d "$src" ]]; then
        # Each package has <pkg>/.config/<app-name>/ — move contents into .config/
        for app_dir in "$src"/*/; do
            [[ -d "$app_dir" ]] || continue
            app_name="$(basename "$app_dir")"
            dest="$DOTFILES/.config/$app_name"
            if [[ -e "$dest" ]]; then
                echo "[SKIP] .config/$app_name already exists — manual merge needed"
            else
                run mv "$app_dir" "$dest"
            fi
        done
        # Also handle loose files directly in .config/ (e.g. starship.toml)
        for f in "$src"/*; do
            [[ -f "$f" ]] || continue
            fname="$(basename "$f")"
            dest="$DOTFILES/.config/$fname"
            if [[ -e "$dest" ]]; then
                echo "[SKIP] .config/$fname already exists"
            else
                run mv "$f" "$dest"
            fi
        done
        # Remove the now-empty stow package directory
        if ! $DRY_RUN; then
            rm -rf "$DOTFILES/$pkg"
        else
            echo "[would run] rm -rf $DOTFILES/$pkg"
        fi
    else
        echo "[WARN] $pkg/.config/ not found — skipping"
    fi
done

echo
echo "=== Handling git (targets \$HOME directly) ==="
for pkg in "${HOME_PKGS[@]}"; do
    src="$DOTFILES/$pkg"
    if [[ -d "$src" ]]; then
        for f in "$src"/.*; do
            [[ -f "$f" ]] || continue
            fname="$(basename "$f")"
            [[ "$fname" == "." || "$fname" == ".." ]] && continue
            dest="$DOTFILES/$fname"
            if [[ -e "$dest" ]]; then
                echo "[SKIP] $fname already exists at repo root"
            else
                run mv "$f" "$dest"
            fi
        done
        if ! $DRY_RUN; then
            rm -rf "$src"
        else
            echo "[would run] rm -rf $src"
        fi
    fi
done

# Handle scripts/ — targets ~/scripts/ not ~/.config/
# In flat layout, keep it as scripts/ at repo root (stow from repo root targets $HOME)
echo
echo "=== Handling scripts/ package ==="
src="$DOTFILES/$SCRIPTS_PKG/scripts"
if [[ -d "$src" ]]; then
    # Move scripts/scripts/* → scripts/* (flatten one level)
    if ! $DRY_RUN; then
        # Move inner scripts/ content to a temp, remove wrapper, rename
        mv "$src" "$DOTFILES/_scripts_tmp"
        rm -rf "$DOTFILES/$SCRIPTS_PKG"
        mv "$DOTFILES/_scripts_tmp" "$DOTFILES/scripts"
    else
        echo "[would run] flatten $SCRIPTS_PKG/scripts/ → scripts/"
    fi
else
    echo "[WARN] scripts/scripts/ not found — skipping"
fi

echo

# ─── Step 3: Restow with new flat layout ────────────────────────────────────
echo "=== Step 3: Restowing with flat layout ==="
# With flat layout, the entire repo IS the stow package, stowed from parent dir
run stow --adopt -d "$DOTFILES" -t "$HOME" .

echo
echo "=== Step 4: Verify — check for dangling symlinks in ~/.config/ ==="
if ! $DRY_RUN; then
    echo "Checking for dangling symlinks..."
    broken=$(find "$HOME/.config" -maxdepth 2 -type l ! -exec test -e {} \; -print 2>/dev/null || true)
    if [[ -n "$broken" ]]; then
        echo "[WARN] Dangling symlinks found:"
        echo "$broken"
    else
        echo "No dangling symlinks found. Migration successful!"
    fi
else
    echo "[would check] find ~/.config -type l (dangling check)"
fi

echo
echo "=== Done ==="
echo
echo "NOTE: You'll want to update your .stow-local-ignore or add a .stow-local-ignore"
echo "to exclude: assets/, docs/, arch-restore.sh, aur_packages.txt, pacman_packages.txt,"
echo "README.md, LICENCE, migrate-to-flat.sh, .git/, .sisyphus/, structure.txt"
