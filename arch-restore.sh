# Official repo packages (explicitly installed)
pacman -Qeq > pacman_packages.txt

# AUR packages (explicitly installed via yay)
yay -Qqem > aur_packages.txt
