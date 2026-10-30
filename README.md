# dotfiles

Personal configuration managed with [chezmoi](https://www.chezmoi.io/).
The repo is the chezmoi source state, so files use the `dot_` naming
(`dot_zshrc` becomes `~/.zshrc`).

## Machines

- `nebula`: Artix desktop, primary machine.
- `astra`: remote box, reached over SSH. Desktop-only configs
  (window managers, terminal emulators, fonts, wallpaper) are skipped
  there by `.chezmoiignore`.

## Bootstrap a machine

```sh
# 1. Get the age key that decrypts tracked secrets (copy from nebula)
mkdir -p ~/.config/chezmoi
scp nebula:~/.config/chezmoi/key.txt ~/.config/chezmoi/key.txt

# 2. Clone and apply
chezmoi init --apply git@github.com:CleoKiama/dotfiles.git
```

`.chezmoi.toml.tmpl` writes the age settings on first init, so no manual
config is needed. On a machine without the key, encrypted files fail to
decrypt; copy the key first.

## Daily use

```sh
chezmoi edit --apply ~/.zshrc   # edit the source, write it through
chezmoi add ~/.zshrc            # import a live change back into the source
chezmoi re-add                  # import all changed live files
chezmoi diff                    # preview what apply would change
chezmoi apply                   # write the source state to $HOME
chezmoi update                  # pull + apply
chezmoi cd                      # shell in the source repo
```

## Layout

```text
dot_zshrc, dot_bashrc, dot_gitconfig, dot_tmux.conf.tmpl
dot_config/          -> ~/.config
scripts/             -> ~/scripts
assets/              -> ~/assets (wallpaper)
.chezmoitemplates/   shared tmux variants, not target files
.chezmoiignore       repo-only files + astra exclusions
.chezmoi.toml.tmpl   age encryption config for new machines
```

Secrets (`.gitconfig-thegoodco`, opencode keys) are tracked as
`encrypted_*.age` and decrypt with `~/.config/chezmoi/key.txt`.
Package lists (`pkglist*.txt`) are reference only; they are not applied.

## Packages

`pkglist.txt` and `pkglist-aur.txt` are snapshots of explicitly installed
packages. Regenerate with `arch-restore.sh`; reinstall manually.
