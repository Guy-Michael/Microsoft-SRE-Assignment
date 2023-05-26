#!/bin/bash
{

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

InitVariables
CreateResourceGroup
DeployStorageAccounts
DeployVM
} > ~/Desktop/files/log.txt