
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

_force_exit_trap() {
    local _trap_remove_work
    _trap_remove_work() {
        local status="${?}"
        warn "Detected Force Kill"
        info "Deleteing Work Folder..."
        _umount ${airootfs_dir}
        yes | rm -r ${work_dir}
        exit "${status}"
    }
    trap '_trap_remove_work' HUP INT QUIT TERM
}

_buildcheck() {
  [[ "${noconfirm}" == "false" ]] && [[ "${dry_run}" == "false"  ]] && \
      echo -e "\nPlease Enter to continue or Ctrl+c to abort..." && read -r
  trap HUP INT QUIT TERM ERR
  trap 'umount_trap' HUP INT QUIT TERM
  trap 'error_exit_trap $LINENO' ERR
}

_rootcheck() {
  if ((  ! "${EUID}" == 0 ));then
    warn "This script must be run as root."
    warn "Re-run: sudo ${0} ${ARGUMENT[*]}"
    sudo "${0}" "${ARGUMENT[@]}"
    exit "${?}"
  fi
}
