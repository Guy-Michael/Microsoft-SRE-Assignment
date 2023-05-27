#!/bin/bash
groupName=$GROUP_NAME
vmName=$VM_NAME
storageDeploymentName=$STORAGE_DEPLOYMENT_NAME

GetConnectionString()
{
    local accountName=$(az deployment group show \
        -g "$groupName" \
        -n "$storageDeploymentName" \
        --query properties.outputs.$1.value \
        --output tsv)

    local key=$(az storage account keys list \
        --resource-group "$groupName" \
        -n "$accountName" \
        --query [0].value \
        --output tsv)

    echo "DefaultEndpointsProtocol=https;AccountName=$accountName;AccountKey=$key;EndpointSuffix=core.windows.net";
}

connectionStringA=$(GetConnectionString "storageA")
connectionStringB=$(GetConnectionString "storageB")

az vm run-command invoke \
    -g "$groupName" \
    -n "$vmName" \
    --command-id RunShellScript \
    --script "sudo docker pull guymichael275/dotnet-script && sudo docker run guymichael275/dotnet-script $connectionStringA $connectionStringB"
    # --script 'sudo docker run --env CONNECTION_STRING_A="$connectionStringA" --env CONNECTION_STRING_B="$connectionStringB" guymichael275/dotnet-script'

read