#!/bin/bash
#Install Azure CLI, Docker and .Net Framework on the linux VM

vmName=$VM_NAME
resourceGroupName=$GROUP_NAME

az vm run-command invoke \
    -n "$vmName" \
    -g "$resourceGroupName" \
    --command-id RunShellScript \
    --scripts "curl -fsSL https://get.docker.com -o get-docker.sh && sudo sh ./get-docker.sh"

read