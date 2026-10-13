#!/usr/bin/env bash

# Fantech EOS PRO II S WGP15V2S Bluetooth Repair
# CachyOS / SteavenLinux
# Does not restart, stop, or reconfigure the Bluetooth service.

MAC="98:B6:E9:A3:25:9B"
NAME="Fantech EOS PRO II S WGP15V2S"
MAX_RETRIES=3

clear

echo "============================================================"
echo "       FANTECH EOS PRO II S - BLUETOOTH CONNECT"
echo "============================================================"
echo
echo "Controller: $NAME"
echo "Address:    $MAC"
echo
echo "This script will:"
echo "  1. Check Bluetooth adapter availability."
echo "  2. Enable the Bluetooth service and adapter."
echo "  3. Remove this controller's existing pairing."
echo "  4. Wait for you to enable pairing mode."
echo "  5. Scan, pair, trust, and connect the controller."
echo "  6. Offer a service restart if a step fails."
echo
echo "Other Bluetooth device pairings will not be removed."
echo
read -rp "Press ENTER to begin, or Ctrl+C to cancel..."


restart_bluetooth_on_failure() {
    local answer

    while true; do
        read -rp "Step failed. Restart Bluetooth service and retry? [y/N]: " answer

        case "$answer" in
            [Yy]|[Yy][Ee][Ss])
                sudo systemctl restart bluetooth.service || return 1
                sudo rfkill unblock bluetooth 2>/dev/null || true
                sleep 2
                bluetoothctl power on
                bluetoothctl agent on
                bluetoothctl default-agent
                bluetoothctl pairable on
                return 0
                ;;
            [Nn]|[Nn][Oo]|"")
                echo "Bluetooth restart skipped."
                return 1
                ;;
            *)
                echo "Please enter Y or N."
                ;;
        esac
    done
}

# Check Bluetooth adapter without changing the service.
if ! bluetoothctl show >/dev/null 2>&1; then
    echo
    echo "ERROR: Bluetooth adapter is unavailable."
    exit 1
fi

echo "Enabling and starting Bluetooth service (may prompt for password)..."
sudo systemctl enable --now bluetooth.service
sudo rfkill unblock bluetooth 2>/dev/null || true
sleep 2 # Wait for the service to spin up

echo "Powering on and initializing Bluetooth adapter..."
# Turn on the adapter
bluetoothctl power on < /dev/null
# Turn on the Bluetooth agent (handles pairing PINs/confirmations automatically)
bluetoothctl agent on < /dev/null
bluetoothctl default-agent < /dev/null
# Ensure the adapter is allowed to pair with new devices
bluetoothctl pairable on < /dev/null
sleep 2 # Give the adapter a moment to initialize

echo
echo "Removing the old pairing for this controller..."
bluetoothctl remove "$MAC" 2>/dev/null || true

# IMPORTANT: Wait for user BEFORE starting the scan.
echo
echo "============================================================"
echo "             BEFORE SCANNING - IMPORTANT"
echo "============================================================"
echo
echo "Please do the following NOW:"
echo
echo "  1. Put your Fantech controller in SWITCH MODE."
echo "  2. Turn on BLUETOOTH PAIRING MODE."
echo "  3. Make sure the controller LED indicates pairing."
echo "  4. Keep the controller close to your computer."
echo
echo "The Bluetooth scan WILL NOT start until you press ENTER."
echo
read -rp "Controller is in pairing mode? Press ENTER to scan..."

echo
echo "Scanning for $NAME for 15 seconds..."
echo "Keep the controller in pairing mode."
bluetoothctl --timeout 15 scan on

echo
echo "Attempting to pair with $NAME..."

if ! bluetoothctl pair "$MAC"; then
    echo
    echo "ERROR: Pairing failed."
    echo "Restarting Bluetooth and starting the script over..."

    if restart_bluetooth_on_failure; then
        sleep 2
        exec bash "$0"
    else
        exit 1
    fi
fi

echo
echo "Trusting controller..."

if ! bluetoothctl trust "$MAC"; then
    echo
    echo "ERROR: Trusting the controller failed."
    echo "Restarting Bluetooth and starting the script over..."

    if restart_bluetooth_on_failure; then
        sleep 2
        exec bash "$0"
    else
        exit 1
    fi
fi

echo
echo "Connecting controller..."

if bluetoothctl connect "$MAC"; then
    echo
    echo "============================================================"
    echo "              CONNECTION SUCCESSFUL"
    echo "============================================================"
    echo "$NAME is paired and connected."
    echo "Test it in Steam or your game."
else
    echo
    echo "ERROR: Pairing succeeded, but connection failed."
    echo "Restarting Bluetooth and starting the script over..."

    if restart_bluetooth_on_failure; then
        sleep 2
        exec bash "$0"
    else
        exit 1
    fi
fi
