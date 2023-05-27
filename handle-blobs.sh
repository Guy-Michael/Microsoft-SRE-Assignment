#!/bin/bash

groupName=$GROUP_NAME
storageDeploymentName=$STORAGE_DEPLOYMENT_NAME
vmDeploymentName=$VM_DEPLOYMENT_NAME

echo "Variables:"
echo "$groupName"
echo "$storageDeploymentName"
echo "$vmDeploymentName"



GetConnectionString()
{
    local accountName=$(az deployment group show \
        --resource-group "$groupName" \
        --name "$storageDeploymentName" \
        --query properties.outputs."$1".value \
        --output tsv)

    local connectionString=$(az storage account show-connection-string \
        --name "$accountName" \
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
    "sudo docker run guymichael275/blobs-logic $connectionStringA $connectionStringB"

# connectionStringA=$(GetConnectionString "storageA")
# connectionStringB=$(GetConnectionString "storageB")

# az vm run-command invoke \
#     -g "$groupName" \
#     -n "$vmName" \
#     --command-id RunShellScript \
#     --script "sudo docker pull guymichael275/dotnet-script && sudo docker run guymichael275/dotnet-script $connectionStringA $connectionStringB"
    # --script 'sudo docker run --env CONNECTION_STRING_A="$connectionStringA" --env CONNECTION_STRING_B="$connectionStringB" guymichael275/dotnet-script'

read