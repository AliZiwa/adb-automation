#!/bin/bash

# Function to check if su command is available
check_su() {
    if adb shell su -c 'echo "su available"'; then
        echo "Superuser access is available."
        HAS_SU=true
    else
        echo "Superuser access is not available."
        HAS_SU=false
    fi
}

get_emulator_name() {
	echo "Available emulators: "
	AVD_LIST=($(emulator -list-avds))
	for i in "${!AVD_LIST[@]}"; do
		echo "$i: ${AVD_LIST[$i]}"
	done
	echo ""
	read -p "Enter the name of the emulator you want to start: " EMULATOR_INDEX
	EMULATOR_NAME=${AVD_LIST[$EMULATOR_INDEX]}
	echo "Starting emulator ${EMULATOR_NAME}......"
}

get_proxy_configurations() {
	# Capture proxy ip
	read -p "Enter proxy IP Address: " PROXY_IP
	echo "Captured proxy address ${PROXY_IP}"

	# Capture proxy port
	read -p "Enter proxy port: " PROXY_PORT
	echo "Captured proxy port ${PROXY_PORT}"
}

# Name of your emulator
get_emulator_name

# Get proxy configurations, i.e proxy ip and proxy port
get_proxy_configurations

# Check if user has super root priviledges
check_su

# Start the emulator if it's not running
if ! adb get-state 1>/dev/null 2>&1; then
    echo "Starting emulator..."
    emulator -avd $EMULATOR_NAME &
    # Wait for the emulator to boot up
    boot_completed="0"
    while [[ "$boot_completed" != "1" ]]; do
        boot_completed=$(adb -e shell getprop sys.boot_completed 2>/dev/null | tr -d '\r')
        sleep 1
    done
    echo "Emulator started."
fi

# Open the Wi-Fi settings
echo "Opening Wi-Fi settings app..."
adb shell am start -a android.settings.WIFI_SETTINGS

# Sleep to ensure Wi-Fi settings are open
sleep 5


if [ "HAS_SU" = true ]; then
	# Find connected Wi-Fi network (requires root)
	echo "Finding connected Wi-Fi network..."
	connected_wifi=$(adb shell su -c 'dumpsys wifi | grep "SSID"')
	echo "Connected Wi-Fi: $connected_wifi"

	# Set the proxy settings (requires root)
	echo "Setting Wi-Fi proxy to $PROXY_IP:$PROXY_PORT"
	adb shell su -c "settings put global http_proxy $PROXY_IP:$PROXY_PORT"
else
	# Alternative method without root
    echo "Setting Wi-Fi proxy to $PROXY_IP:$PROXY_PORT without root"
    adb shell settings put global http_proxy $PROXY_IP:$PROXY_PORT	
fi

echo "Proxy settings updated."
