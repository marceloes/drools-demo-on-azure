az login
az extension add --source https://workerappscliextension.blob.core.windows.net/azure-cli-extension/containerapp-0.2.0-py2.py3-none-any.whl

$RANDOM_SUFFIX=((Get-Random).ToString())
$RESOURCE_GROUP="drools-rg-$RANDOM_SUFFIX"
$LOCATION="canadacentral"
$CONTAINERAPPS_NAME="drools-workbench-$RANDOM_SUFFIX"
$CONTAINERAPPS_ENVIRONMENT="drools-dev-env-$RANDOM_SUFFIX"
$CONTAINERAPPS_IMAGE="jboss/drools-workbench-showcase:latest"
$LOG_ANALYTICS_WORKSPACE="containerapps-logs-$RANDOM_SUFFIX"

Write-Host "Creating group..."
az group create --name $RESOURCE_GROUP --location "$LOCATION"

Write-Host "Creating log analytics workspace..."
az monitor log-analytics workspace create `
  --resource-group $RESOURCE_GROUP `
  --workspace-name $LOG_ANALYTICS_WORKSPACE

$LOG_ANALYTICS_WORKSPACE_CLIENT_ID=(az monitor log-analytics workspace show --query customerId -g $RESOURCE_GROUP -n $LOG_ANALYTICS_WORKSPACE --out tsv)
$LOG_ANALYTICS_WORKSPACE_CLIENT_SECRET=(az monitor log-analytics workspace get-shared-keys --query primarySharedKey -g $RESOURCE_GROUP -n $LOG_ANALYTICS_WORKSPACE --out tsv)

Write-Host "Creating container apps environment..."
az containerapp env create `
  --name $CONTAINERAPPS_ENVIRONMENT `
  --resource-group $RESOURCE_GROUP `
  --logs-workspace-id $LOG_ANALYTICS_WORKSPACE_CLIENT_ID `
  --logs-workspace-key $LOG_ANALYTICS_WORKSPACE_CLIENT_SECRET `
  --location "$LOCATION"

Write-Host "Creating container app ...."
az containerapp create `
  --name $CONTAINERAPPS_NAME `
  --resource-group $RESOURCE_GROUP `
  --environment $CONTAINERAPPS_ENVIRONMENT `
  --image "$CONTAINERAPPS_IMAGE" `
  --target-port 8080 `
  --cpu 2 `
  --memory 4Gi `
  --ingress 'external' 

$CONTAINERAPP_FQDN=(az containerapp show --resource-group $RESOURCE_GROUP --name $CONTAINERAPPS_NAME --query "latestRevisionFqdn" -o tsv)

Start-Process "https://$CONTAINERAPP_FQDN/business-central"

#cleanup (run after you're done wiht the demo)
#az group delete --name $RESOURCE_GROUP --yes --no-wait