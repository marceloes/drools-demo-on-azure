az login

$RANDOM_SUFFIX=((Get-Random).ToString())
$RESOURCE_GROUP="drools-rg-$RANDOM_SUFFIX"
$LOCATION="southcentralus"
$CONTAINERAPPS_NAME="drools-workbench-$RANDOM_SUFFIX"
$CONTAINERAPPS_IMAGE="jboss/drools-workbench-showcase:latest"
$APP_SERVICE_PLAN_NAME="svcplanlinux$RANDOM_SUFFIX"

Write-Host "Creating group..."
az group create --name $RESOURCE_GROUP --location "$LOCATION"

Write-Host "Creating app service plan..."
az appservice plan create `
  --name $APP_SERVICE_PLAN_NAME `
  --resource-group $RESOURCE_GROUP `
  --location $LOCATION `
  --is-linux `
  --sku B3

Write-Host "Creating web app..."
az webapp create `
  --name $CONTAINERAPPS_NAME `
  --plan $APP_SERVICE_PLAN_NAME `
  --resource-group $RESOURCE_GROUP `
  --deployment-container-image-name "$CONTAINERAPPS_IMAGE"

Write-Host "Configure ports..."
az webapp config appsettings set `
  --name $CONTAINERAPPS_NAME `
  --resource-group $RESOURCE_GROUP `
  --settings "WEBSITES_PORT=8080"

$CONTAINERAPP_FQDN=(az webapp show --name $CONTAINERAPPS_NAME --resource-group $RESOURCE_GROUP --query defaultHostName -o tsv)

Start-Process "http://$CONTAINERAPP_FQDN/business-central"
