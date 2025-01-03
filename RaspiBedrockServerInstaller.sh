# Bedrock Server Installation Script for ARM64

sudo apt install git build-essential cmake unzip -y # Install necessary dependencies for this script

# Install box64
echo /e[36mStarting box64 installation.../e[0m
curl -o box64.zip https://github.com/ptitSeb/box64/archive/refs/tags/v0.2.8.zip
unzip box64.zip
cd box64
mkdir build; cd build; cmake .. -D ARM_DYNAREC=ON -D CMAKE_BUILD_TYPE=RelWithDebInfo
make -j4
sudo make install
rm -rf box64
sudo systemctl restart systemd-binfmt
echo /e[36mbox64 installation has finished/e[0m

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
