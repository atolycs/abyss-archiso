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

#_remove_workdir() {
#    
#}

# Error message
error_exit_trap(){
    local _exit="${?}" _line="${1}" && shift 1
    error "An exception error occurred in the function"
    error "Exit Code: ${_exit}\nLine: ${_line}\nArgument: ${ARGUMENT[*]}"
    exit "${_exit}"
}

umount_trap() {
    local _status="${?}"
    _umount ${airootfs_dir}
    error "It was killed by the user.\nThe process may not have completed successfully."
    exit "${_status}"
}