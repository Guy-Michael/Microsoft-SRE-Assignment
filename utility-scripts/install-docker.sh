#!/bin/bash
#Install Docker

groupName=$GROUP_NAME
vmDeploymentName=$VM_DEPLOYMENT_NAME

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
    -o StrictHostKeychecking=no \
    "curl -fsSL https://get.docker.com -o get-docker.sh && sudo sh ./get-docker.sh"