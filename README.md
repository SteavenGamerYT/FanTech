# Fantech Controllers on Linux

![Fantech](https://github.com/SteavenGamerYT/fantech-controllers/raw/refs/heads/main/fantech-logo.webp)

A collection of scripts and fixes to get Fantech gamepads working flawlessly on Linux (tested on CachyOS / Arch Linux).

---

## Fantech EOS Pro II S (WGP15V2S)

![Fantech EOS Pro II S](https://github.com/SteavenGamerYT/fantech-controllers/raw/refs/heads/main/fantech-eos-pro-ii-s-switch-mode.webp)

### The Problem: Gyroscope & Switch Mode
To use the gyroscope features of the EOS Pro II S on Linux (e.g., for Steam Input or emulators), the controller **must** be paired in **Switch Mode**. 

However, standard Linux Bluetooth GUI managers often struggle to pair with this controller in Switch mode, resulting in connection loops or instant disconnects. 

### The Solution
`fantech-eos-pro-ii-s-switch-mode.sh` is an automated bash script that utilizes `bluetoothctl` to properly clear old pairings, scan, pair, trust, and connect the controller in Switch mode.

### ⚙️ Prerequisites
Ensure you have standard Bluetooth utilities installed:
* `bluez`
* `bluez-utils` (provides `bluetoothctl`)

### 🚀 Usage Instructions

**1. Clone the repository:**
```bash
git clone [https://github.com/SteavenGamerYT/fantech-controllers.git](https://github.com/SteavenGamerYT/fantech-controllers.git)
cd fantech-controllers
```

**2. Find your Controller's MAC Address:**
Before running the script, you need to find your controller's unique Bluetooth MAC address.
1. Put the controller in Switch pairing mode.
2. Open a terminal and run `bluetoothctl`.
3. Type `scan on` and look for `Pro Controller` or `Fantech EOS PRO II S`.
4. Copy the MAC address (format: `XX:XX:XX:XX:XX:XX`).
5. Type `exit`.

**3. Edit the script:**
Open `fantech-eos-pro-ii-s-switch-mode.sh` in a text editor and replace the default MAC address with yours:
```bash
# Change this line in the script to match YOUR controller
MAC="98:B6:E9:A3:25:9B" 
```

**4. Make the script executable:**
```bash
chmod +x fantech-eos-pro-ii-s-switch-mode.sh
```

**5. Run the script:**
```bash
./fantech-eos-pro-ii-s-switch-mode.sh
```
Follow the on-screen prompts. The script will ask you to ensure the controller is in pairing mode before it initiates the connection sequence.