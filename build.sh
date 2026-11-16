#!/bin/bash
set -euxo pipefail
SCRIPT_DIR=$(cd $(dirname "$0") && pwd)
cd "$SCRIPT_DIR"
DIRNAME=$(uuidgen)

host="orange20"

while getopts "h:" opt; do
    case "$opt" in
        h) host="$OPTARG" ;; 
        # x) flag_x=true ;;
        *) echo "使い方: $0 [-h host] " >&2; exit 1 ;;
    esac
done

rsync -avz --delete --filter=':- .gitignore' --exclude='.git' -e ssh . ${host}:/tmp/${DIRNAME}/
ssh ${host} << EOF
  LD_LIBRARY_PATH=/ced-home/staff/narumi/Xilinx/Vivado/2022.1/lib
  cd /tmp/${DIRNAME}
  /ced-home/staff/narumi/Xilinx/Vivado/2022.1/bin/vivado -mode batch -source ./scripts/full.tcl -notrace -nojournal -nolog -quiet
EOF

scp ${host}:/tmp/${DIRNAME}/out/main.bit ./out/main.bit
ssh ${host} "rm -rf /tmp/${DIRNAME}"