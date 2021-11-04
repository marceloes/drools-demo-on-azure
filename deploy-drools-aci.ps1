az login

$RANDOM_SUFFIX=((Get-Random).ToString())
$RESOURCE_GROUP="drools-rg-$RANDOM_SUFFIX"
$LOCATION="eastus"
$CONTAINERAPPS_NAME="drools-workbench-$RANDOM_SUFFIX"
$CONTAINERAPPS_IMAGE="jboss/drools-workbench-showcase:latest"
$DNS_LABEL="drools-aci-$RANDOM_SUFFIX"

Write-Host "Creating group..."
az group create --name $RESOURCE_GROUP --location "$LOCATION"

Write-Host "Creating ACI..."
az container create `
  --resource-group $RESOURCE_GROUP `
  --location southcentralus `
  --name $CONTAINERAPPS_NAME `
  --image $CONTAINERAPPS_IMAGE `
  --ports 8080 8001 `
  --dns-name-label $DNS_LABEL `
  --ip-address public `
  --os-type Linux `
  --restart-policy OnFailure  `
  --cpu 2 `
  --memory 4 

$CONTAINERAPP_FQDN=(az container show --resource-group $RESOURCE_GROUP --name $CONTAINERAPPS_NAME --query "ipAddress.fqdn" -o tsv)
$URL = "http://" + $CONTAINERAPP_FQDN + ":8080/business-central"
Start-Process $URL

# Cleanup resources (only run after you're done with the demo)
#az group delete --name $RESOURCE_GROUP --yes --no-wait
