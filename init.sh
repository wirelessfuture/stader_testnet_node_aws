#!/bin/bash
sudo apt-get --assume-yes update
mkdir ~/bin
wget https://stadernode.s3.amazonaws.com/v0.0.1-alpha/stader-cli-linux-amd64 -O ~/bin/stader-cli
chmod +x ~/bin/stader-cli
exit 0