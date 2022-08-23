_package_listup() {
    local _selector="${1}" _list="${2}"
    info "Checking ${_selector} in ${_list}"
}

prepare_base_build() {
    # Base 
    local _package_store=("base" "share")
    for modules_name in ${_package_store[@]}; do
        cat ${script_path}/modules/${modules_name}/packages.${arch} | \
            sed -e 's|^#.*||g' \
                -e '/^$/d'
    done
}