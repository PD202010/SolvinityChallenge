#!/bin/bash
export script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

cd $script_dir/ansible

ansible-playbook -i hosts full.yml
