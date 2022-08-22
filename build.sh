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

