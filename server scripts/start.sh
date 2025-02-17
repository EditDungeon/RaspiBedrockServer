#!/bin/bash

bash scripts/update-scripts.sh
bash scripts/update-server.sh

chmod +x bedrock_server
./bedrock_server