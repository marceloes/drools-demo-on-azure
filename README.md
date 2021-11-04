# drools-demo-on-azure
Running a demo of Drools on Azure using Container Apps, Container Instances or App Service

## Pre-requisites

- Make sure you have an Azure subscription where you have **Contributor** access. Alternatively, you can easily modify this demo if you only have **Contributor** access to a Resource Group, just change the script to reference that instead of creating a new Resource Group
- You also need PowerShell 5 minimum on a Windows machine.
    - **A version in Bash is coming soon.**
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-windows?tabs=azure-cli)

## Running the demo

Choose the script you're going to use to run it and run it!

    - Alternatively, you can run all of these commands in [Azure Shell](https://shell.azure.com)
    - If using Azure Shell, you can comment out the ```az login``` statements

**NOTE: 

- You may have to carefully choose the region you're deploying to if you're using Azure Container Apps (Preview). This is due to capacity issues on this brand new service in preview.
- Some services may take a little to spin up so give it a couple of minutes to start. You may have to refresh the page a few times





