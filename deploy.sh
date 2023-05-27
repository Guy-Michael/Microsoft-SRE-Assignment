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
    az group create \
        --name $resourceGroupName \
        --location $location
}

DeployStorageAccounts()
{
    az deployment group create \
        --name "$storageDeploymentName" \
        --resource-group "$resourceGroupName" \
        --template-file "$storageAccountsTemplateFile" \
        --parameters "$storageParametersFile"
}

DeployVM()
{
    az deployment group create \
    --name "$vmDeploymentName" \
    --resource-group "$resourceGroupName" \
    --template-file $vmTemplateFile \
    --parameters "$vmParametersFile"
}

CreateDashboard()
{
    az deployment group create \
        --name "$dashboardDeploymentName" \
        --resource-group "$resourceGroupName" \
        --template-file "$dashboardTemplateFile" \
        --parameters "$dashboardParametersFile"
}

InitVariables

echo "Creating a resource group named $resourceGroupName"
CreateResourceGroup

echo "Deploying 2 storage accounts"
DeployStorageAccounts

echo "Deploying Linux VM"
DeployVM

echo "Deploying Dashboard"
CreateDashboard
