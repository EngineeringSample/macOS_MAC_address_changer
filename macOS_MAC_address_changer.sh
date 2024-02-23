#!/bin/bash

# This script is used to change the MAC address of the Wi-Fi network interface on macOS.

# **Functions**

# Get the current MAC address
function get_mac_address() {
    # Get the name of the Wi-Fi interface
    wifi_interface=$(networksetup -listallhardwareports | awk '/Hardware Port: Wi-Fi/{getline; print $NF}')

    # Get the MAC address
    mac_address=$(ifconfig "$wifi_interface" | awk '/ether/{print $2}')

    # Display the MAC address
    echo "Current MAC address: $mac_address"
}

# Change the MAC address
function change_mac() {
    # Check user input
    if [[ -z "$new_mac" ]]; then
        echo "Please enter a new MAC address:"
        read new_mac
    fi

    # Check MAC address format
    if ! [[ $new_mac =~ ^([0-9a-fA-F]{2}:){5}[0-9a-fA-F]{2}$ ]]; then
        echo "Invalid MAC address format, please re-enter:"
        read new_mac
        return 1
    fi

    # Get the name of the Wi-Fi interface
    wifi_interface=$(networksetup -listallhardwareports | awk '/Hardware Port: Wi-Fi/{getline; print $NF}')

    # Disable the Wi-Fi interface
    sudo ifconfig "$wifi_interface" down

    # Change the MAC address
    sudo ifconfig "$wifi_interface" lladdr "$new_mac"

    # Re-enable the Wi-Fi interface
    sudo ifconfig "$wifi_interface" up

    # Display success message
    echo "MAC address changed successfully to $new_mac"
}

# **Main Script**

# Get the current MAC address
get_mac_address

# Display prompt information
echo "-------------------------"

# Select an action
echo "Please select an action to perform:"
echo "1. Change MAC address"
echo "2. Exit"
echo "-------------------------"

read -p "Enter option number: " choice

case "$choice" in
    1)
        change_mac
        ;;
    2)
        echo "Script exited!"
        exit 0
        ;;
    *)
        echo "Invalid option, please select again:"
        read -p "Enter option number: " choice
        ;;
esac

# Display ending information
echo "-------------------------"
echo "Script execution completed!"
