
prepare_base_build() {
    # Base 
    local _package_store=("base" "share")  _pkglist
    for _file in "${_package_store[@]}"; do
        readarray -t -O "${#_pkglist[@]}" _pkglist < <(grep -h -v ^'#' "${modules_dir}/${_file}/packages.${arch}" | grep -h -v ^$)
    done
    printf "%s\n" "${_pkglist[@]}"
}

# _package_listup()
# 
# _selector: Profile Name
# _list: Architecture

_package_listup() {
    local _selector="${1}" _list="${2}" _pkglist
    local _profile_dir="${profile_dir}/${_selector}"
    local _package_store=("${_profile_dir}/packages.${_list}")
    local _prepare_package _prepare_module

    if [ -f ${_profile_dir}/prepare_module ];then
        _prepare_module=$(cat ${_profile_dir}/prepare_module)
        _package_store+=(${modules_dir}/${_prepare_module}/packages.${arch})
    fi
       
    for _file in "${_package_store[@]}"; do
        readarray -t -O "${#_pkglist[@]}" _pkglist < <(grep -h -v ^'#' "${_file}" | grep -h -v ^$)
    done
    printf "%s\n" "${_pkglist[@]}"
}
