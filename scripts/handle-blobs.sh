#!/bin/bash

groupName=$GROUP_NAME
vmDeploymentName=$VM_DEPLOYMENT_NAME

GetConnectionString()
{
    local connectionString=$(az storage account show-connection-string \
        --name "$1" \
        --resource-group "$resourceGroupName" \
        --query connectionString)

    echo "$connectionString"
}

GetSSHIdentification()
{
    local sshIdentification=$(az deployment group show \
    --name "$vmDeploymentName" \
    --resource-group "$groupName" \
    --query properties.outputs.sshIdentification.value \
    --output tsv)

    echo $sshIdentification
}

connectionStringA=$(GetConnectionString "storageA")
connectionStringB=$(GetConnectionString "storageB")
sshIdentification=$(GetSSHIdentification)

ssh "$sshIdentification" \
    "sudo docker pull guymichael275/blobs-logic"

ssh "$sshIdentification" \
    -o StrictHostKeychecking=no \
    "sudo docker run guymichael275/blobs-logic $connectionStringA $connectionStringB"