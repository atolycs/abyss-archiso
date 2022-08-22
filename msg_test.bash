#!/bin/bash 

source ./shell_lib/colors.bash
source ./shell_lib/msg.bash


_msg_common error "This is error"
_msg_common info "This is Info"
_msg_common warn "This is warn"
_msg_common debug "This is debug"

_msg_common -n error "This is error"
_msg_common -n info "This is Info"
_msg_common -n warn "This is warn"
_msg_common -n debug "This is debug"

