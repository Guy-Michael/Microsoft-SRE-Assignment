#!/bin/bash

resourceGroupName=$GROUP_NAME
location=$LOCATION
storageDeploymentName=$STORAGE_DEPLOYMENT_NAME
vmDeploymentName=$VM_DEPLOYMENT_NAME

InitVariables()
{
    export templatePath="./arm-templates"
    export storageAccountsTemplateFile="$templatePath/Storage/storage.json"
    export storageParametersFile="$templatePath/Storage/storage.parameters.json"
    export vmTemplateFile="$templatePath/VM/linuxVM.json"
    export vmParametersFile="$templatePath/VM/linuxVM.parameters.json"
}

CreateResourceGroup()
{
    echo "Creating a resource group named $resourceGroupName"
    az group create --name $resourceGroupName --location $location
}

DeployStorageAccounts()
{
    echo "Deploying 2 storage accounts"
    az deployment group create \
        --name $storageDeploymentName \
        --resource-group $resourceGroupName \
        --template-file $storageAccountsTemplateFile \
        --parameters $storageParametersFile
}

DeployVM()
{
    echo "Deploying linux VM"

    az deployment group create \
    --name $vmDeploymentName \
    --resource-group $resourceGroupName \
    --template-file $vmTemplateFile \
    --parameters $vmParametersFile
}

GetConnectionString()
{
    local accountName=$(az deployment group show \
        -g "$resourceGroupName" \
        -n "$storageDeploymentName" \
        --query properties.outputs.$1.value \
        --output tsv)

    local key=$(az storage account keys list \
        --resource-group "$resourceGroupName" \
        -n "$accountName" \
        --query [0].value \
        --output tsv)

    echo "DefaultEndpointsProtocol=https;AccountName=$accountName;AccountKey=$key;EndpointSuffix=core.windows.net";
}

InitVariables
CreateResourceGroup
DeployStorageAccounts
DeployVM

#Output the connection string to the yaml pipeline
echo "##vso[task.setvariable variable=connectionStringA]$(GetConnectionString storageA)"
echo "##vso[task.setvariable variable=connectionStringB]$(GetConnectionString storageB)"
