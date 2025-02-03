# Bedrock Server Installation Script for ARM64

sudo apt install git build-essential cmake unzip -y # Install necessary dependencies for this script

# box64 installation function
function Installbox64() {
    if [ "$device_type" = "rpi3" ]
    then
        curl -o "box64.deb" "https://github.com/ryanfortner/box64-debs/blob/29718ee854c648152d82eb622897b34391a97c2a/debian/box64-rpi3arm64_0.2.8%2B20240522.8545d05-1_arm64.deb"
        sudo apt install "./box64.deb"
        rm "box64.deb"

    elif [ "$device_type" = "rpi4" ]
    then
        curl -o "box64.deb" "https://github.com/ryanfortner/box64-debs/blob/29718ee854c648152d82eb622897b34391a97c2a/debian/box64-rpi4arm64_0.2.8%2B20240522.8545d05-1_arm64.deb"
        sudo apt install "./box64.deb"
        rm "box64.deb"
    
    elif [ "$device_type" = "rpi5" ]
    then
        curl -o "box64.deb" "https://github.com/ryanfortner/box64-debs/blob/29718ee854c648152d82eb622897b34391a97c2a/debian/box64-rpi5arm64ps16k_0.2.8%2B20240522.8545d05-1_arm64.deb"
        sudo apt install "./box64.deb"
        rm "box64.deb"

    elif [ "$device_type" = "rk3399" ]
    then
        curl -o "box64.deb" "https://github.com/ryanfortner/box64-debs/blob/29718ee854c648152d82eb622897b34391a97c2a/debian/box64-rk3399_0.2.8%2B20240522.8545d05-1_arm64.deb"
        sudo apt install "./box64.deb"
        rm "box64.deb"

    elif [ "$device_type" = "rk3588" ]
    then
        curl -o "box64.deb" "https://github.com/ryanfortner/box64-debs/blob/29718ee854c648152d82eb622897b34391a97c2a/debian/box64-rk3588_0.2.8%2B20240522.8545d05-1_arm64.deb"
        sudo apt install "./box64.deb"
        rm "box64.deb"

    elif [ "$device_type" = "other" ]
    then
        curl -o "box64.deb" "https://github.com/ryanfortner/box64-debs/blob/29718ee854c648152d82eb622897b34391a97c2a/debian/box64_0.2.8%2B20240522.8545d05-1_arm64.deb"
        sudo apt install "./box64.deb"
        rm "box64.deb"
    
    fi
}

# Device selection
function PromptDeviceType() {
    echo "What device are you using? (rpi3, rpi4, rpi5, rk3399, rk3588, other)"
    read device_type
}
device_type_satisfied=false

until [ "$device_type_satisfied" = true ];
do
    PromptDeviceType

    if [[ "$device_type" = "rpi3" || "$device_type" = "rpi4" || "$device_type" = "rpi5" || "$device_type" = "rk3399" || "$device_type" = "rk3588"  ]]
    then
        device_type_satisfied=true
        Installbox64
    fi
done


# Server Type Prompt
function PromptServerType() {
echo "What server type do you want to install? (release, preview)"
read server_type
}
server_type_satisfied=false
until [ "$server_type_satisfied" = true ];
do

    PromptServerType

    if [ "$server_type" = "release" ];
    then 
        server_type_satisfied=true
        echo "/e[36mSelected server type: '/e[32mrelease/e[36m'/e[0m"
        echo "What version do you want to install? (Enter 'latest' for latest available version) (https://aka.ms/MCChangelogs)"
        read version
        if [ "$version" = "latest" ];
        then
            # Downloading latest version

            DownloadURL=$(grep -o 'https://www.minecraft.net/bedrockdedicatedserver/bin-linux/[^"]*' downloads/version.html)
            DownloadFile=$(echo "$DownloadURL" | sed 's#.*/##')
            echo "Downloading latest version..."
            curl -A "Mozilla/5.0" -o "BedrockServer.zip" "$DownloadURL"

        else
            # Downloading specified version

            echo "Downloading specified version: '$version'"
            curl -A "Mozilla/5.0" -o "BedrockServer.zip" "https://www.minecraft.net/bedrockdedicatedserver/bin-linux/bedrock-server-$version.zip"
        fi


    elif [ "$server_type" = "preview" ];
    then 
        server_type_satisfied=true
        echo "/e[36mSelected server type: '/e[32mpreview/e[36m'/e[0m"
        echo "What version do you want to install? (Enter 'latest' for latest available version) (https://feedback.minecraft.net/hc/sections/360001185332)"
        read version
        if [ "$version" = "latest" ];
        then
            # Downloading latest version
            # Code taken from: https://github.com/TheRemote/MinecraftBedrockServer/blob/master/SetupMinecraft.sh

            DownloadURL=$(grep -o 'https://www.minecraft.net/bedrockdedicatedserver/bin-linux/[^"]*' downloads/version.html)
            DownloadFile=$(echo "$DownloadURL" | sed 's#.*/##')
            echo "Downloading latest version..."
            curl -H "Accept-Encoding: identity" -H "Accept-Language: en" -L -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.33 (KHTML, like Gecko) Chrome/90.0.$RandNum.212 Safari/537.33" -o "BedrockServer.zip" "$DownloadURL"

            else
            # Downloading specified version

            echo "Downloading specified version: '$version'"
            curl -A "Mozilla/5.0" -o "BedrockServer.zip" "https://www.minecraft.net/bedrockdedicatedserver/bin-linux/bedrock-server-$version.zip"
        fi


else
    echo "/e[31mError: Invalid server type/e[0m"
fi

done

# Extract server files, then delete ZIP file
unzip "BedrockServer.zip" 
rm "BedrockServer.zip"
