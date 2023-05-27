resourceGroup="$RESOURCE_GROUP"
location="$LOCATION"
dashboardName="guysdashboard"
path
az portal dashboard create --resource-group $resourceGroup --name $dashboardName \
   --input-path portal-dashboard-template-testvm.json --location centralus