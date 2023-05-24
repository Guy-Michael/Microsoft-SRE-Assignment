#!/bin/bash

InitVariables()
{
    export resourceGroupName="guyResourceGroupD"
    export location="westus"
    export deploymentName="deployment"
    export storageDeploymentName="deploymentStorageAccounts"
    export vmDeploymentName="deploymentVM"

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

GetConnectionString()
{
    local accountName=$(az deployment group show \
        -g $resourceGroupName \
        -n $storageDeploymentName \
        --query properties.outputs.$1.value \
        --output tsv)

    local key=$(az storage account keys list \
        --resource-group $resourceGroupName \
        -n "$accountName" \
        --query [0].value \
        --output tsv)

    echo "DefaultEndpointsProtocol=https;AccountName=$accountName;AccountKey=$key;EndpointSuffix=core.windows.net";
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

RunDotnetApplication()
{
    echo "running dotnet application"
    dotnet build
    dotnet run ./UploadAndCopyBlobs.cs $resourceGroupName $1 $2
}

InstallDotNet()
{
    local vmName
    echo "getting name"

    vmName=$(az deployment group show \
    -n $vmDeploymentName \
    -g $resourceGroupName \
    --query properties.outputs.name.value \
    --output tsv)

    echo $vmName
    echo "running command"
    az vm run-command invoke \
    -n "$vmName" \
    -g $resourceGroupName \
    --command-id RunShellScript \
    --scripts "echo hello"
    # --scripts @./install-dotnet.sh
}

InitVariables
# CreateResourceGroup
# DeployStorageAccounts
# DeployVM
# InstallDotNet

# connectionStringA=$(GetConnectionString "storageA")
# connectionStringB=$(GetConnectionString "storageB")

./handle-blobs.sh $resourceGroupName $storageDeploymentName




# RunDotnetApplication $connectionStringA $connectionStringB