# Pacstrap installer
_pacstrap_install() {
  info "Installing packages to ${airootfs_dir}/..."
  local _args=("-c" "-G" "-M" "--" "${airootfs_dir}" "${@}")
  [[ "${pacman_debug}" = true ]] && _args+=(--debug)
  pacstrap -C "${build_dir}/pacman.conf" "${_args[@]}"
  info "Packages Installed Successfully."
}
