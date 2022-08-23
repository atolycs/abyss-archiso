#!/bin/bash

script_path="$( cd $(dirname $(readlink -f ${0})) && pwd)"

# Load script Wrapper
echo ${script_path}
for f in $(ls -1 ${script_path}/shell_lib/*.bash);do
   echo "Loading $(basename $f)"
   source $f
done

info() {
   _msg_common info "${@}"
}

warn() {
   _msg_common warn "${@}"
}

debug() {
   [[ "${debug}" = true ]] && _msg_common debug "${@}"
}

error() {
   _msg_common error "${@}"
}

_umount_trap(){
   local _status="${?}"
   error "Killed by the user."
   exit ${_status}
}

ARGUMENT=("${@}")
OPTS=("a:" "c:" "o:" "w:" "p:") OPTL=("arch:" "comp-type:" "out:" "work:" "profile:")
GETOPT=(-o "$(printf "%s," "${OPTS[@]}")" -l "$(printf "%s," "${OPTL[@]}")" -- "${ARGUMENT[@]}")
getopt -Q "${GETOPT[@]}" || exit 1
readarray -t OPT < <(getopt "${GETOPT[@]}")

eval set -- "${OPT[@]}"
info "Argument: ${OPT[*]}"
unset OPT OPTS OPTL GETOPT


while true; do
   case "${1}" in 
      -c | --comp-type)
         case "${2}" in
            "gzip" | "lzma" | "lzo" | "lz4" | "xz" | "zstd") sfs_comp="${2}" ;;
               *) error "Invalid compress '${2}'";;
         esac
         shift 2
         ;;
      -a | --arch) arch="${2}"       && shift 2;;
      -o | --out) out_dir="${2}"     && shift 2;;
      -w | --work) work_dir="${2}"   && shift 2;;
      -p | --profile) profile="${2}" && shift 2;;
      -- ) shift 1                   && break  ;;
      *)
         error "Argument exception error '${1}'";;
   esac
done

#prepare_build
_show_config