#!/bin/bash

# This script is now obselete Because I couldn't authenticate Azure CLI on the VM,
# This script uses the Azure CLI to handle the blob operations.
# The CD pipeline uses the "UploadAndCopyBlobs.csx" script via Docker.

resourceGroupName=$1
storageDeploymentName=$2
containerNameA="dev-container-a-$RANDOM"
containerNameB="dev-container-b-$RANDOM"

generateSasToken()
{
    local expiry=$(date -u -d "+1 hour" "+%Y-%m-%dT%H:%M:%SZ")
    local sasToken=$(az storage account generate-sas \
    --permissions acdlruw \
    --expiry "$expiry" \
    --connection-string "$1" \
    --resource-types c \
    --services bf \
    --resource-types c)

    echo $sasToken
}

GetConnectionString()
{
    local key=$(az storage account keys list \
        --resource-group "$resourceGroupName" \
        -n "$1" \
        --query [0].value \
        --output tsv)

    echo "DefaultEndpointsProtocol=https;AccountName=$1;AccountKey=$key;EndpointSuffix=core.windows.net";
}

createStorageContainer()
{
    az storage container create \
    --name "$1"\
    --connection-string "$2"
}

GetStorageAccountName()
{
    local accountName=$(az deployment group show \
        -g $resourceGroupName \
        -n $storageDeploymentName \
        --query properties.outputs.$1.value \
        --output tsv)

    echo $accountName
}

GenerateLocalFiles()
{
    mkdir files
    path="./files"

    for i in {1..100}
    do
        echo "Hi! I'm Blob #$i!" >> "$path/Blob$i"
    done
}

UploadFilesToStorageA()
{
    az storage blob upload-batch \
    --account-name "$accountNameA" \
    --connection-string "$connectionStringA" \
    --destination $containerNameA \
    --source "./files"
}

CopyFilesToStorageB()
{
    az storage copy \
    --source $containerUrlA \
    --destination $containerUrlB \
    --recursive
}

accountNameA=$(GetStorageAccountName "storageA")
accountNameB=$(GetStorageAccountName "storageB")

connectionStringA=$(GetConnectionString "$accountNameA")
connectionStringB=$(GetConnectionString "$accountNameB")

createStorageContainer "$containerNameA" "$connectionStringA"
createStorageContainer "$containerNameB" "$connectionStringB"

containerUrlA="https://$accountNameA.blob.core.windows.net/$containerNameA"
containerUrlB="https://$accountNameB.blob.core.windows.net/$containerNameB"

UploadFilesToStorageA
CopyFilesToStorageB

rm -rf ./files