#!/bin/bash
set -e
mkdir -p log
bash ./build_sim.sh
RAW_LOG="log/heat_diffusion_log.csv"
rm -f "$RAW_LOG"
SIMULATOR="./bin/heat_diffusion"
if [ ! -f "$SIMULATOR" ] && [ -f "${SIMULATOR}.exe" ]; then
    SIMULATOR="${SIMULATOR}.exe"
fi
"$SIMULATOR" config/heat_config_nonuniform_initial.json 250
{
    printf "time;model_id;model_name;port_name;data\n"
    awk -F';' '
        NR > 2 && $4 == "" && $3 ~ /^\([0-9]+,[0-9]+\)$/ {
            key = $1 ";" $3;
            if (seen[key]++) next;
            if (current_time != $1) {
                current_time = $1;
                print;
            }
            print;
        }
    ' "$RAW_LOG"
} > log/grid_nonuniform_initial_log.csv
rm -f "$RAW_LOG"
echo "Nonuniform initial scenario done."

