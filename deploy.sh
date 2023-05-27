#!/bin/bash

resourceGroupName=$GROUP_NAME
location=$LOCATION
storageDeploymentName=$STORAGE_DEPLOYMENT_NAME
vmDeploymentName=$VM_DEPLOYMENT_NAME
dashboardDeploymentName=$DASHBOARD_DEPLOYMENT_NAME

InitVariables()
{
    export templatePath="./arm-templates"
    export storageAccountsTemplateFile="$templatePath/Storage/storage.json"
    export storageParametersFile="$templatePath/Storage/storage.parameters.json"
    export vmTemplateFile="$templatePath/VM/linuxVM.json"
    export vmParametersFile="$templatePath/VM/linuxVM.parameters.json"
    export dashboardTemplateFile="$templatePath/Dashboard/dashboard.json"
    export dashboardParametersFile="$templatePath/Dashboard/dashboard.parameters.json"
}

CreateResourceGroup()
{
    echo "Creating a resource group named $resourceGroupName"
    az group create --name $resourceGroupName --location $location
}

DeployStorageAccounts()
{
    echo "Deploying 2 storage accounts"
    local publicIp=$(az deployment group create \
        --name $storageDeploymentName \
        --resource-group $resourceGroupName \
        --template-file $storageAccountsTemplateFile \
        --parameters $storageParametersFile \
        --query properties.output.publicIp.value \
        --output tsv)

    echo "$publicIp"
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

    local connectionString=$(az storage account show-connection-string \
        --name "$accountName" \
        --resource-group "$resourceGroupName" \
        --query connectionString)

    echo "$connectionString"
}

CreateDashboard()
{
    az deployment group create \
        --name "$dashboardDeploymentName" \
        --resource-group "$resourceGroupName" \
        --template-file "$dashboardTemplateFile" \
        --parameters "$dashboardParametersFile"

    # az portal dashboard create \
    #     --resource-group "$resourceGroupName" \
    #     --name "$dashboardName" \
    #     --input-path "$dashboardTemplateFile" \
    #     --location "$location"
}

InitVariables
CreateResourceGroup
DeployStorageAccounts
publicIp=$(DeployVM)
CreateDashboard

#Output the connection string to the yaml pipeline
echo "##vso[task.setvariable variable=CONNECTION_STRING_A]$(GetConnectionString storageA)"
echo "##vso[task.setvariable variable=CONNECTION_STRING_B]$(GetConnectionString storageB)"
echo "##vso[task.setvariable variable=PUBLIC_IP]$publicIp"

read