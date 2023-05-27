#!/bin/bash
#Install Docker

groupName=$GROUP_NAME
vmDeploymentName=$VM_DEPLOYMENT_NAME

echo "Variables:"
echo "$groupName"
echo "$vmDeploymentName"

GetSSHIdentification()
{
    local sshIdentification=$(az deployment group show \
    --name "$vmDeploymentName" \
    --resource-group "$groupName" \
    --query properties.outputs.sshIdentification.value \
    --output tsv)

    echo "$sshIdentification"
}

sshIdentification=$(GetSSHIdentification)

ssh "$sshIdentification" \
    "curl -fsSL https://get.docker.com -o get-docker.sh && sudo sh ./get-docker.sh"

read