#!/bin/bash
#Installs docker on an Azure linux VM.
machineName=$vmName
resourceGroupName=$groupName

az vm run-command invoke \
    --command-id RunShellScript \
    --name "$machineName"\
    --resource-group "$resourceGroupName" \
    --scripts "curl -fsSL https://get.docker.com -o get-docker.sh" "sudo sh ./get-docker.sh"
