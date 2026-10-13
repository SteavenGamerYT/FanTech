# Fantech Controllers on Linux

![Fantech](https://github.com/SteavenGamerYT/FanTech/raw/refs/heads/main/fantech-logo.webp)

A collection of scripts and fixes to get Fantech gamepads working flawlessly on Linux (tested on CachyOS / Arch Linux).

---

## Fantech EOS Pro II S (WGP15V2S)

![Fantech EOS Pro II S](https://github.com/SteavenGamerYT/FanTech/raw/refs/heads/main/fantech-eos-pro-ii-s-switch-mode.webp)

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
git clone [https://github.com/SteavenGamerYT/FanTech.git](https://github.com/SteavenGamerYT/FanTech.git)
cd FanTech