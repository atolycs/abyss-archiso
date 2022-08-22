#!/bin/bash

script_path="$( cd $(dirname $(readlink -f ${0})) && pwd)"

# Load script Wrapper
echo ${script_path}
for f in $(ls -1 ${script_path}/shell_lib/*.bash);do
   source $f
done

_msg_common -n info "This is test"
