print_ascii_art() {
    echo "__________                  __  ___________        ___________"
    echo "\______   \  ____    ____ _/  |_\_   _____/___  ___\_   _____/"
    echo " |       _/ /  _ \  /  _ \\   __\|    __)_ \  \/  / |    __)_ "
    echo " |    |   \(  <_> )(  <_> )|  |  |        \ >    <  |        \\"
    echo " |____|_  / \____/  \____/ |__| /_______  //__/\_ \/_______  /"
    echo "        \/                              \/       \/        \/"
    echo ""
    echo "   _____                  .__                                        ___.                  "
    echo "  /  _  \ _______   ____  |  |   __ __  ______           ____  ___.__.\_ |__    ____ _______ "
    echo " /  /_\  \\_  __ \_/ ___\ |  |  |  |  \/  ___/  ______ _/ ___\<   |  | | __ \ _/ __ \\_  __ \\"
    echo "/    |    \|  | \/\  \___ |  |__|  |  /\___ \  /_____/ \  \___ \___  | | \_\ \\  ___/ |  | \/"
    echo "\____|__  /|__|    \___  >|____/|____//____  >          \___  >/ ____| |___  / \___  >|__|   "
    echo "        \/             \/                  \/               \/ \/          \/      \/        "
    echo "# Author: Ross Brereton (https://www.linkedin.com/in/ross-b-673872107/)"
    echo "# Website: https://github.com/msf-Root-ExE"
    echo "# Thank you for choosing Arculus-Cyber"
    echo "# https://arculus-cyber.co.uk"
}

#!/bin/bash

read -p "Enter the path to the subnet file: " SUBNET_FILE

if [ ! -f "$SUBNET_FILE" ]; then
    echo "File not found: $SUBNET_FILE"
    exit 1
fi

GATEWAY=$(ping -c 1 _gateway | grep PING | sed -r 's/^PING[^(]+\(([^)]+)\).+$/\1/')

if [ -z "$GATEWAY" ]; then
    echo "Gateway address could not be determined automatically."
    read -p "Please enter the gateway address manually: " GATEWAY
fi

echo "Using gateway address: $GATEWAY"

read -p "Enter the network interface (e.g., eth0): " INTERFACE

while IFS= read -r subnet
do
    echo "Adding route: sudo route add -net $subnet gw $GATEWAY $INTERFACE"

    sudo route add -net "$subnet" gw "$GATEWAY" "$INTERFACE"
    if [ $? -ne 0 ]; then
        echo "Failed to add route for subnet: $subnet"
    fi
done < "$SUBNET_FILE"

echo "Finished adding routes."
