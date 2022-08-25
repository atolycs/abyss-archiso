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
  if [ ! -d "${airootfs_dir}/etc/pacman.d" ];then
    mkdir -p "${airootfs_dir}/etc/pacman.d"
  fi
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

make_pacman_conf() {
  local _pacman_conf _pacman_conf_list=("${script_path}/pacman.${arch}.conf" "${profile_dir}/${profile}/pacman.${arch}.conf" "${modules_dir}/pacman.${arch}.conf")
  for _pacman_conf in "${_pacman_conf_list[@]}"; do
    if [[ -f "${_pacman_conf}" ]];then
      build_pacman_conf="${_pacman_conf}"
      break
    else
      info "Skipping ${_pacman_conf}...."
    fi
  done
  info "Use ${build_pacman_conf}"
  sed -r "s|^#\\s*CacheDir.+|CacheDir     = ${cache_dir}|g" "${build_pacman_conf}" > "${build_dir}/pacman.conf"
  _pacman_mirror_server
}