#!/bin/bash
#Install Azure CLI, Docker and .Net Framework on the linux VM

vmName=$VM_NAME
resourceGroupName=$GROUP_NAME

echo "Variables: "
echo "$vmName"
echo "$resourceGroupName"

az vm run-command invoke \
    -n "$vmName" \
    -g "$resourceGroupName" \
    --command-id RunShellScript \
    --scripts "curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash" \
                "curl -fsSL https://get.docker.com -o get-docker.sh && sudo sh ./get-docker.sh"

read


# curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# # # Docker
# curl -fsSL https://get.docker.com -o get-docker.sh && sudo sh ./get-docker.sh