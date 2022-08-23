
# Mount Wrapper
# Usage: _mount {source} {target}
# Description: Check mountpoint -> File available and Directory available check -> Run Mount

_mount() {
  ! mountpoint -q "${2}" && \
        [[ -f "${1}" ]] && [[ -d "${2}" ]] && \
            mount "${1}" "${2}";
  return 0;
}

# Umount Wrapper
# Usage: _umount {target}
# Description: Check already mountpoint -> Run Umount

_umount() {
  mountpoint -q "${1}" && \
    umount -lf "${1}";
  return 0;
}

mount_airootfs() {
  mkdir -p "${airootfs_dir}"
  _mount "${airootfs_dir}.img" "${airootfs_dir}"
}

# run on chroot
_run_on_chroot() {
  info "Running ${@} on chroot env..."
  arch-chroot ${airootfs_dir} "${@}" || return "${?}"
}

run_once() {
  if [[ ! -e "${lockfile_dir}/build.${1}" ]];then
    _umount ${airootfs_dir}
    mount_airootfs
    eval "${@}"
    mkdir -p "${lockfile_dir}"; touch "${lockfile_dir}/build.${1}"
  fi
}
