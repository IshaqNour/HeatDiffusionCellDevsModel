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
"$SIMULATOR" config/heat_config_hotter_source.json 250
{
    printf "sep=;\n"
    printf "time;model_id;model_name;port_name;data\n"
    awk -F';' 'NR > 2 && $4 == "" && $3 ~ /^\([0-9]+,[0-9]+\)$/ { print }' "$RAW_LOG"
} > log/heat_diffusion_hotter_source_log.csv
rm -f "$RAW_LOG"
echo "Hotter source scenario done."