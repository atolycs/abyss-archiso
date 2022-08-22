
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

mount_abyss_rootfs() {
  mkdir -p "${abyss_rootfs_dir}"
  _mount "${abyss_rootfs}.img" "${abyss_rootfs_dir}"
}


