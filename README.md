# UbntHelp

UbntHelp is a Bash script designed to assist users in managing Ubiquiti devices, which are widely used and managed by Wireless Internet Service Providers (WISPs). This script was developed to provide an easier way to manage essential functionalities of the Ubiquiti devices through SSH for occurrances where the web interface is unusable due to slow connections.
Made in 2021 approx.

## Features

- **View Current Station**: Display the station currently in use.
- **Signal Quality**: Check the signal strength in dB.
- **Factory Reset**: Restore the device to its factory settings (use with caution).
- **Scan Stations**: List visible stations.
- **Set Station**: Change the current station and optionally update the network password.
- **Get Info**: Retrieve detailed information about the device from the AirControl panel.

## How to Run

1. Download the script file or copy it manually into the station you're having issues managing.
2. Make the script executable:
   ```bash
   chmod +x ubnt_help.sh
   ```
3. Load the script into your system commands:
   ```bash
   source ./ubnt_help.sh
   ```

## Available Commands

After loading the script, type `comandi` to see the list of available commands:
- `diffusore_attuale`: Show the current station being used.
- `qualita_segnale`: Display the signal quality in dB.
- `factory_reset`: Reset the device to factory settings (caution: not recommended for remote use).
- `scansiona_station`: Scan and list visible stations.
- `imposta_station`: Change the current station and optionally update the network password.
- `ottieni_info`: Retrieve device information from the AirControl panel.
