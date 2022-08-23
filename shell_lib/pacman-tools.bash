# Pacstrap installer

_pacstrap_install() {
  info "Installing packages to ${airootfs_dir}/..."
  local _args=("-c" "-G" "-M" "--" "${airootfs_dir}" "${@}")
  [[ "${pacman_debug}" = true ]] && _args+=(--debug)
  pacstrap -C "${build_dir}/pacman.conf" "${_args[@]}"
  info "Packages Installed Successfully."
}

_pacman_mirror_server() {
  info "Downloading ${pacman_mirror_server} Pacman Server List"
  reflector --protocol "https,http" \
            --sort rate \
            --country ${pacman_mirror_server} \
            --latest 10 \
            --save ${airootfs_dir}/etc/pacman.d/mirrorlist
}

make_packages_repo() {
  readarray -t _pkglist < <(prepare_base_build)
  _pkglist+=($(_package_listup ${profile} ${arch}))
  echo "${_pkglist[*]}"
  printf "%s\n" "${_pkglist[@]}" >> "${build_dir}/packages.list"
  _pacstrap_install ${_pkglist[@]}
}