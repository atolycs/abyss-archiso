make_setup_mkinitcpio() {
    local _hook _hook_list=( "archiso" "archiso_pxe_common" "archiso_pxe_nbd" "archiso_pxe_http" "archiso_pxe_nfs" "archiso_loop_mnt" )
    
    # mkdir initcpio folder
    mkdir -p "${airootfs_dir}/etc/initcpio/{hooks,install}"

    # hook instlall
    for _hook in ${_hook_list[@]};do
        install -m 0644 -- "${script_path}/mkinitcpio/hooks/${_hook}" "${airootfs_dir}/etc/initcpio/hooks"
        install -m 0644 -- "${script_path}/mkinitcpio/install/${_hook}" "${airootfs_dir}/etc/initcpio/install"
    done

    # install cpio
    install -m 0644 -- "${script_path}/mkinitcpio/install/archiso_kms" "${airootfs_dir}/etc/initcpio/install"
    install -m 0644 -- "${script_path}/mkinitcpio/mkinitcpio-archiso.conf" "${airootfs_dir}/etc/mkinitcpio-archiso.conf"

    # Generate Boot Image
    _run_on_chroot mkinitcpio -c "/etc/mkinitcpio-archiso.conf" -k "/boot/${kernel_filename}" -g "/boot/archiso.img"

    return 0
}