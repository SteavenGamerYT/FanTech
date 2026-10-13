
#!/usr/bin/env bash

# Fantech EOS PRO II S WGP15V2S Bluetooth Repair
# CachyOS / SteavenLinux
# Does not restart, stop, or reconfigure the Bluetooth service.

MAC="98:B6:E9:A3:25:9B"
NAME="Fantech EOS PRO II S WGP15V2S"

clear

echo "============================================================"
echo "       FANTECH EOS PRO II S - BLUETOOTH REPAIR"
echo "============================================================"
echo
echo "Controller: $NAME"
echo "Address:    $MAC"
echo
echo "This script will:"
echo "  1. Check Bluetooth adapter availability."
echo "  2. Enable Bluetooth Services."
echo "  3. Enable Bluetooth"
echo "  4. Remove this controller's existing pairing."
echo "  5. Scan for the controller."
echo "  6. Pair, trust, and connect it."
echo
echo "No Bluetooth service changes will be made."
echo "Other Bluetooth device pairings will not be removed."
echo
read -rp "Press ENTER to begin, or Ctrl+C to cancel..."

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
    echo "Ensure the controller is still in pairing mode."
    exit 1
fi

echo
echo "Trusting controller..."
bluetoothctl trust "$MAC" || true

echo
echo "Connecting controller..."
if bluetoothctl connect "$MAC"; then
    echo
    echo "============================================================"
    echo "                REPAIR SUCCESSFUL"
    echo "============================================================"
    echo "$NAME is paired and connected."
    echo "Test it in Steam or your game."
else
    echo
    echo "ERROR: Pairing succeeded, but connection failed."
    exit 1
fi
