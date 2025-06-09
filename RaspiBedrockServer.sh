#!/bin/bash

## Bedrock Server Installation Script for ARM64


sudo apt install curl jq unzip screen systemd -y # Install required dependencies

# box64 installation function
function Installbox64() {
    if [ "$device_type" = "rpi3" ]
    then
        curl -o "box64.deb" "https://github.com/ryanfortner/box64-debs/raw/29718ee854c648152d82eb622897b34391a97c2a/debian/box64-rpi3arm64_0.2.8%2B20240522.8545d05-1_arm64.deb"
        sudo apt install "./box64.deb"
        rm "box64.deb"

    elif [ "$device_type" = "rpi4" ]
    then
        curl -o "box64.deb" "https://github.com/ryanfortner/box64-debs/raw/29718ee854c648152d82eb622897b34391a97c2a/debian/box64-rpi4arm64_0.2.8%2B20240522.8545d05-1_arm64.deb"
        sudo apt install "./box64.deb"
        rm "box64.deb"
    
    elif [ "$device_type" = "rpi5" ]
    then
        curl -o "box64.deb" "https://github.com/ryanfortner/box64-debs/raw/29718ee854c648152d82eb622897b34391a97c2a/debian/box64-rpi5arm64ps16k_0.2.8%2B20240522.8545d05-1_arm64.deb"
        sudo apt install "./box64.deb"
        rm "box64.deb"

    elif [ "$device_type" = "rk3399" ]
    then
        curl -o "box64.deb" "https://github.com/ryanfortner/box64-debs/raw/29718ee854c648152d82eb622897b34391a97c2a/debian/box64-rk3399_0.2.8%2B20240522.8545d05-1_arm64.deb"
        sudo apt install "./box64.deb"
        rm "box64.deb"

    elif [ "$device_type" = "rk3588" ]
    then
        curl -o "box64.deb" "https://github.com/ryanfortner/box64-debs/raw/29718ee854c648152d82eb622897b34391a97c2a/debian/box64-rk3588_0.2.8%2B20240522.8545d05-1_arm64.deb"
        sudo apt install "./box64.deb"
        rm "box64.deb"

    elif [ "$device_type" = "other" ]
    then
        curl -o "box64.deb" "https://github.com/ryanfortner/box64-debs/raw/29718ee854c648152d82eb622897b34391a97c2a/debian/box64_0.2.8%2B20240522.8545d05-1_arm64.deb"
        sudo apt install "./box64.deb"
        rm "box64.deb"
    
    fi
}

# Device selection
function PromptDeviceType() {
    echo -n "What device are you using? (rpi3, rpi4, rpi5, rk3399, rk3588, other)"
    read device_type
}
device_type_satisfied=false

until [ "$device_type_satisfied" = true ];
do
    PromptDeviceType

    if [[ "$device_type" =~ ^(rpi3|rpi4|rpi5|rk3399|rk3588|other)$  ]];
    then
        device_type_satisfied=true
        Installbox64
    else
         "Invalid selection, try again."
        
    fi
done


# Server Type Prompt
function PromptServerType() {
echo -n "What server type do you want to install? (release, preview)"
read server_type
}
server_type_satisfied=false
until [ "$server_type_satisfied" = true ];
do

    PromptServerType

    if [ "$server_type" = "release" ];
    then 
        server_type_satisfied=true
        echo -e "/e[36mSelected server type: '/e[32mrelease/e[36m'/e[0m"
        echo "What version do you want to install? (Enter 'latest' for latest available version) (https://github.com/Bedrock-OSS/BDS-Versions/blob/main/versions.json)"
        read version
        if [ "$version" = "latest" ];
        then
            # Downloading latest release version
            LatestReleaseVersion=`curl -s https://raw.githubusercontent.com/Bedrock-OSS/BDS-Versions/main/versions.json | jq -r '.linux.stable'`

            echo "Downloading latest release version..."
            curl -A "Mozilla/5.0" -o "BedrockServer.zip" "https://www.minecraft.net/bedrockdedicatedserver/bin-linux/bedrock-server-$LatestReleaseVersion.zip"
            InstalledVersion=$LatestReleaseVersion

        else
            # Downloading specified version

            echo "Downloading specified version: '$version'"
            curl -A "Mozilla/5.0" -o "BedrockServer.zip" "https://www.minecraft.net/bedrockdedicatedserver/bin-linux/bedrock-server-$version.zip"
            InstalledVersion=$version
        fi


    elif [ "$server_type" = "preview" ];
    then 
        server_type_satisfied=true
        echo -e "/e[36mSelected server type: '/e[32mpreview/e[36m'/e[0m"
        echo "What version do you want to install? (Enter 'latest' for latest available version) (https://github.com/Bedrock-OSS/BDS-Versions/blob/main/versions.json)"
        read version
        if [ "$version" = "latest" ];
        then
            # Downloading latest preview version
            LatestPreviewVersion=`curl -s https://raw.githubusercontent.com/Bedrock-OSS/BDS-Versions/main/versions.json | jq -r '.linux.preview'`

            echo "Downloading latest release version..."
            curl -A "Mozilla/5.0" -o "BedrockServer.zip" "https://www.minecraft.net/bedrockdedicatedserver/bin-linux-preview/bedrock-server-$LatestPreviewVersion.zip"
            InstalledVersion=$LatestPreviewVersion

            else
            # Downloading specified version

            echo "Downloading specified version: '$version'"
            curl -A "Mozilla/5.0" -o "BedrockServer.zip" "https://www.minecraft.net/bedrockdedicatedserver/bin-linux-preview/bedrock-server-$version.zip"
            InstalledVersion=$version
        fi


else
    echo -e "/e[31mError: Invalid server type/e[0m"
fi

done

echo "Finishing installation..."

sudo mkdir /minecraft # Make server directory
unzip -d /minecraft BedrockServer.zip # Extract server files
rm "BedrockServer.zip" # Delete ZIP file
echo $server_type > /minecraft/server_type
echo $InstalledVersion > /minecraft/version

sudo useradd minecraft # Make new user for running the server
sudo chown -R minecraft /minecraft # Give server user ownership of server directory

mkdir /minecraft/scripts # Make server scripts folder
cd /minecraft/scripts # Open scripts folder

# Download server scripts
echo "Downloading server scripts..."
curl https://github.com/EditDungeon/RaspiBedrockServer/raw/refs/heads/main/server%20scripts/start.sh
curl https://github.com/EditDungeon/RaspiBedrockServer/raw/refs/heads/main/server%20scripts/restart.sh
curl https://github.com/EditDungeon/RaspiBedrockServer/raw/refs/heads/main/server%20scripts/update-server.sh
curl https://github.com/EditDungeon/RaspiBedrockServer/raw/refs/heads/main/server%20scripts/update-scripts.sh
echo "Finished downloading scripts."

# Install systemd service
cd /etc/systemd/system
curl https://github.com/EditDungeon/RaspiBedrockServer/raw/refs/heads/main/MinecraftBedrock.service
sudo systemctl daemon-reload

# Prompt auto-starting the server
echo "Would you like to start the server on boot? (y/n)" 
read auto_start

if [ $auto_start = "y" || $auto_start = "Y" ]
then
    sudo systemctl enable MinecraftBedrock.service
fi

# Register alias commands

alias "start-bedrock"=sudo systemctl start MinecraftBedrock.service
alias "stop-bedrock"=sudo systemctl stop MinecraftBedrock.service
alias "restart-bedrock"=sudo systemctl restart MinecraftBedrock.service
alias "console-bedrock"=screen -r MinecraftBedrock

# Installation finished
 
echo "Finished installation"
echo "Use 'start-bedrock' to start the server"
echo "Use 'stop-bedrock' to stop the server"
echo "Use 'restart-bedrock' to restart the server"
echo "Use 'console-bedrock' to view the server console"



