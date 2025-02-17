#!/bin/bash

InstalledServerType=cat server_type
InstalledServerVersion=cat version

if [ $InstalledServerType = "release" ]
then
    LatestVersion=`curl -s https://raw.githubusercontent.com/Bedrock-OSS/BDS-Versions/main/versions.json | jq -r '.linux.stable'`

    if [ $InstalledServerVersion != $LatestVersion ]
    then
        curl -A "Mozilla/5.0" -o "BedrockServer.zip" "https://www.minecraft.net/bedrockdedicatedserver/bin-linux/bedrock-server-$LatestVersion.zip"
        unzip -d /minecraft BedrockServer.zip
    fi

elif [ $InstalledServerType = "preview" ]
then
    LatestVersion=`curl -s https://raw.githubusercontent.com/Bedrock-OSS/BDS-Versions/main/versions.json | jq -r '.linux.preview'`

    if [ $InstalledServerVersion != $LatestVersion ]
    then
        curl -A "Mozilla/5.0" -o "BedrockServer.zip" "https://www.minecraft.net/bedrockdedicatedserver/bin-linux/bedrock-server-$LatestVersion.zip"
        unzip -d /minecraft BedrockServer.zip
    fi
fi