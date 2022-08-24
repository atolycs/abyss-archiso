
_msg_common() {
  local _data=${1} _msg_opts
  [[ "${_data}" == "-n" ]] && _msg_opts+="-n" && shift 1;
  local _loglevel=${1}; shift 1
  eval "_msg_${_loglevel} ${_msg_opts} ${@}"
}

_msg_info() {
  local _opts
  if [[ "$1" == "-n" ]];then
     _opts+="-n"
     shift 1
  fi
  echo -e ${_opts} "[ ${CYAN}INFO${RESET} ] ${@}"
}

_msg_debug() {
  local _opts
  if [[ "$1" == "-n" ]];then
     _opts+="-n"
     shift 1
  fi
  echo -e ${_opts} "[ ${BLUE}DEBUG${RESET} ] ${@}"
}

_msg_error() {
  local _opts
  if [[ "$1" == "-n" ]];then
     _opts+="-n"
     shift 1
  fi
  echo -e ${_opts} "[ ${RED}ERROR${RESET} ] ${@}"
}

_msg_warn() {
  local _opts
  if [[ "$1" == "-n" ]];then
     _opts+="-n"
     shift 1
  fi
  echo -e ${_opts} "[ ${YELLOW}WARN${RESET} ] ${@}"
}

