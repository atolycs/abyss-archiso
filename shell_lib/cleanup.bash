# clean up airootfs
_cleanup_common() {
 info "Cleaning up we can on airootfs..."
 [[ -d "${airootfs_dir}/var/lib/pacman" ]] && find "${airootfs_dir}/var/lib/pacman" -maxdepth 1 -type f -delete
 [[ -d "${airootfs_dir}/var/lib/pacman/sync" ]] && find "${airootfs_dir}/var/lib/pacman/sync" -delete
 [[ -d "${airootfs_dir}/var/lib/pacman/pkg" ]] && find "${airootfs_dir}/var/lib/pacman/pkg" -type f -delete
 [[ -d "${airootfs_dir}/var/log" ]] && find "${airootfs_dir}/var/log" -type f -delete
 [[ -d "${airootfs_dir}/var/tmp" ]] && find "${airootfs_dir}/var/tmp" -mindepth 1 -type f -delete
 find "${build_dir}" \( -name '*.pacnew' -o -name '*.pacsave' -o -name '*.pacorig' \) -delete
 [[ -d "${airootfs_dir}/var/cache" ]] && find "${airootfs_dir}/var/cache" -mindepth 1 -delete
 printf '' > "${airootfs_dir}/etc/machine-id"

 info "Done!"
}
