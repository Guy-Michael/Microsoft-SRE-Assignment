#!/bin/bash
#Install Azure CLI, Docker and .Net Framework on the linux VM

machineName=$VM_NAME
resourceGroupName=$GROUP_NAME

# # Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# # Docker
curl -fsSL https://get.docker.com -o get-docker.sh 
sudo sh ./get-docker.sh