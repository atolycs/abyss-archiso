
prepare_base_build() {
    # Base 
    local _package_store=("base" "share")
    for modules_name in ${_package_store[@]}; do
        cat ${script_path}/modules/${modules_name}/packages.${arch} | \
            sed -e 's|^#.*||g' \
                -e '/^$/d'
    done
}

_package_listup() {
    local _selector="${1}" _list="${2}"
#    info "Checking ${_selector} in package.${_list}"
    cat ${_selector}/packages.${_list} | \
        sed -e 's|^#.*||g' \
            -e '/^$/d'
}
