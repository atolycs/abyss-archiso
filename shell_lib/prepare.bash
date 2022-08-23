
prepare_base_build() {
    # Base 
    local _package_store=("base" "share")  _pkglist
    for _file in "${_package_store[@]}"; do
        readarray -t -O "${#_pkglist[@]}" _pkglist < <(grep -h -v ^'#' "${modules_dir}/${_file}/packages.${arch}" | grep -h -v ^$)
    done
    printf "%s\n" "${_pkglist[@]}"
}

_package_listup() {
    local _selector="${1}" _list="${2}" _pkglist
    local _package_store="${profile_dir}/${_selector}/packages.${_list}"
    for _file in "${_package_store[@]}"; do
        readarray -t -O "${#_pkglist[@]}" _pkglist < <(grep -h -v ^'#' "${_file}" | grep -h -v ^$)
    done
    printf "%s\n" "${_pkglist[@]}"
}
