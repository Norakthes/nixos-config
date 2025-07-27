#!/usr/bin/env sh
set -euo pipefail

# Change brightness and get the new values in one command
brightness_data=($(brightnessctl -m "$@" | tr "," " "))
brightness_percentage=${brightness_data[3]/"%"/""}
brightness_value=${brightness_data[2]}

# Extract device name (everything after "::")
device_full=${brightness_data[0]}
device=${device_full##*::}

# Show notification with current brightness
notify-send \
    -a "brightness" \
    -u low \
    -r "9993" \
    -h int:value:"$brightness_percentage" \
    -i "brightness-${1:-set}" \
    "Brightness ($device): ${brightness_percentage}% (${brightness_value})" \
    -t 2000
