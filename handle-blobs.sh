#!/bin/bash
connectionStringA=$CONNECTION_STRING_A
connectionStringB=$CONNECTION_STRING_B
groupName=$GROUP_NAME
vmName=$VM_NAME

echo "Variables: "
echo "$connectionStringA"
echo "$connectionStringB"
echo "$groupName"
echo "$vmName"

az vm run-command invoke \
    -g "$groupName" \
    -n "$vmName" \
    --command-id RunShellScript \
    --script "docker pull guymichael275/dotnet-script" "docker run --env CONNECTION_STRING_A=$connectionStringA --env CONNECTION_STRING_B=$connectionStringB guymichael275/dotnet-script"

read