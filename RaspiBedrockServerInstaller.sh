# Bedrock Server Installation Script for ARM64

sudo apt install git build-essential cmake unzip -y #Install necessary dependencies for this script

# Install box64
echo /e[36mStarting box64 installation.../e[0m
curl -o box64.zip https://github.com/ptitSeb/box64/archive/refs/tags/v0.2.8.zip
unzip box64.zip
cd box64
mkdir build; cd build; cmake .. -D ARM_DYNAREC=ON -D CMAKE_BUILD_TYPE=RelWithDebInfo
make -j4
sudo make install
sudo systemctl restart systemd-binfmt
echo /e[36mbox64 installation has finished/e[0m

# Installation Prompts
server_type_finished=false
server_type="null"
until server_type == "release"||"preview"
echo "What server type do you want to install? (release, preview)"
read server_type
done
if [server_type == "release"]
then 
echo "/e[36mSelected server type: '/e[32mrelease/e[36m'/e[0m"



elif [server_type == "preview"]
then 
echo "/e[36mSelected server type: '/e[32mpreview/e[36m'/e[0m"

else
echo "/e[31mError: Server type is invalid/e[0m"




