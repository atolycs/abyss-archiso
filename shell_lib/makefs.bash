make_basefs() {
  info "Creating ext4 Image of 32GiB..."
  truncate -s 32G -- "${airootfs_dir}.img"
  mkfs.ext4 -O '^has_journal,^resize_inode' -E 'lazy_itable_init=0' -m 0 -F -- "${airootfs_dir}.img" 32G
  tune2fs -c "0" -i "0" "${airootfs_dir}.img"
  info "Done!"

  info "Mounting ${airootfs_dir}.img on ${airootfs_dir} ..."
}

