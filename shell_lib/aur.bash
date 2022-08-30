_aur_helper_install() {
    info "Installing yay AUR Helper on ${airootfs_dir}"
    _run_on_chroot "cd && git clone https://aur.archlinux.org/paru.git && cd paru && makepkg -is --noconfirm"
    info "Done"
}