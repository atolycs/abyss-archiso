#!/bin/bash

script_path="$( cd -P $(dirname $(readlink -f ${0})) && pwd)"

ARGUMENT=("${@}")
# Load script Wrapper
echo ${script_path}
for f in $(ls -1 ${script_path}/shell_lib/*.bash);do
   echo "Loading $(basename $f)"
   source $f
done

# Load config 
arch="$(uname -m)"
profile="xfce4"
work_dir="work"
out_dir="out"
noconfirm=false
debug=false
dry_run=false

info() {
   _msg_common info "${@}"
}

warn() {
   _msg_common warn "${@}"
}

debug() {
   [[ "${debug}" = "true" ]] && _msg_common debug "${@}" || return 0;
}

error() {
   _msg_common error "${@}"
}

_umount_trap(){
   local _status="${?}"
   error "Killed by the user."
   exit ${_status}
}

ARGUMENT=("${DEFAULT_ARGUMENT[@]}" "${@}")

OPTS=("a:" "c:" "o:" "w:" "p:") OPTL=("arch:" "comp-type:" "no-confirm" "debug" "pacman-sv:" "dry-run" "out:" "work:" "profile:" "country:")
GETOPT=(-o "$(printf "%s," "${OPTS[@]}")" -l "$(printf "%s," "${OPTL[@]}")" -- "${ARGUMENT[@]}")
getopt -Q "${GETOPT[@]}" || exit 1
readarray -t OPT < <(getopt "${GETOPT[@]}")

eval set -- "${OPT[@]}"
info "Argument: ${OPT[*]}"

unset OPT OPTS OPTL DEFAULT_ARGUMENT GETOPT


while true; do
   case "${1}" in 
      -c | --comp-type)
         case "${2}" in
            "gzip" | "lzma" | "lzo" | "lz4" | "xz" | "zstd") sfs_comp="${2}" ;;
               *) error "Invalid compress '${2}'";;
         esac
         shift 2
         ;;
      --debug)         debug=true                            && shift 1;;
      --pacman-sv)     pacman_mirror_server="${2}"           && shift 2;;
      --dry-run)       dry_run=true                          && shift 1;;
      --country)       pacman_mirror_server="${2}"           && shift 2;;
      --no-confirm)    noconfirm=true                        && shift 1;;
      -a | --arch)     arch="${2}"                           && shift 2;;
      -o | --out)      out_dir="${2}"                        && shift 2;;
      -w | --work)     work_dir="${2}"                       && shift 2;;
      -p | --profile)  profile="${2}"                        && shift 2;;
      -- ) shift 1                                           && break  ;;
      *)
         error "Argument exception error '${1}'";;
   esac
done

#prepare_build


#for ta_list in ${tt_array}; do
#    pacstrap /mnt ${ta_list[@]}
#done
#echo "${dry_run}"
#echo "${debug}"
_force_exit_trap

build_dir="${work_dir}/build/${arch}"
cache_dir="${work_dir}/cache/${arch}"
modules_dir="${script_path}/modules"
airootfs_dir="${build_dir}/airootfs"
isofs_dir="${build_dir}/iso"
lockfile_dir="${build_dir}/lockfile"
profile_dir="${script_path}/profiles"
out_dir="${work_dir}/${out_dir}"
#build_pacman_conf="${profile_dir}/${profile}/pacman.${arch}.conf"

[[ "${dry_run}" = "true" ]] && debug "dry-run mode"

for _dir in build_dir cache_dir airootfs_dir isofs_dir lockfile_dir out_dir;do
  if [[ "${dry_run}" == "false" ]];then
    mkdir -p "$(eval "echo \$${_dir}")"
    eval "${_dir}=\"$(realpath "$(eval "echo \$${_dir}")")\""
  else
    eval "${_dir}=\"$(realpath -m "$(eval "echo \$${_dir}")")\""
    _show_config
    info "dry-run mode to exit."
    exit 0
  fi
done

_rootcheck

_show_config
run_once make_pacman_conf
run_once make_basefs
run_once make_packages_repo
#run_once 
run_once make_setup_mkinitcpio
run_once make_efi_boot
