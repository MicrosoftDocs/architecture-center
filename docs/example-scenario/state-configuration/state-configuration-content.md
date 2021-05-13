Azure Automation State Configuration is an Azure configuration management service that allows you to configure and enforce state on virtual and physical machines in any cloud or on-premises datacenter. The service is fully managed and is accessed through the Azure portal or Azure command-line tools and software development kits. In addition to enforcing configuration, you can also use Azure Automation State Configuration in a report-only mode where compliance data is generated based on a virtual or physical machine's compliance with a configuration.

This example scenario demonstrates using Azure Automation State Configuration to install a web server on both Windows and Linux-based Azure Virtual Machines. Use the included deployment to experience Azure Automation State Configuration in your Azure environment.

## Architecture

![](./media/azure-state-config.png)

## Reference deployment

This deployment includes an Azure Automation account, the Azure Automation State Configuration feature, and one to many Windows and Linux Virtual machines that are onboarded onto State Configuration. Once deployed, and configuration is applied to each virtual machine that installs a web server.

#### [Azure CLI](#tab/cli)

Use the following command to create a resource group for the deployment. Click the **Try it** button to use an embedded shell.

```azurecli-interactive
az group create --name state-configuration --location eastus
```

Run the following command to deploy the ARM template. When prompted, enter a username and password. These values can be used to log into the created virtual machines.

```azurecli-interactive
az deployment group create --resource-group state-configuration \
    --template-uri https://raw.githubusercontent.com/mspnp/samples/master/OperationalExcellence/azure-automation-state-configuration/azuredeploy.json
```

Once deployed, in the Azure portal click on the **Automation Account** resource and then **State configuration (DSC)** and notice that all virtual machines have been added to the system and are compliant. These machines have all had the PowerShell DSC configuration applied, which has installed a web server on each.

![Image of DSC compliance results as seen in the Azure portal.](./media/dsc-results.png)

You can also browse to the public IP address of any virtual machine to verify that a web server is running.

#### [PowerShell](#tab/powershell)

Use the following command to create a resource group for the deployment. Click the **Try it** button to use an embedded shell.

```azurepowershell-interactive
New-AzResourceGroup -Name state-configuration -Location eastus
```

Run the following command to deploy the ARM template. When prompted, enter a username and password. These values can be used to log into the created virtual machines.

```azurepowershell-interactive
New-AzResourceGroupDeployment -ResourceGroupName state-configuration `
    -TemplateUri https://raw.githubusercontent.com/mspnp/samples/master/OperationalExcellence/azure-automation-state-configuration/azuredeploy.json
```

Once deployed, in the Azure portal click on the **Automation Account** resource and then **State configuration (DSC)** and notice that all virtual machines have been added to the system and are compliant. These machines have all had the PowerShell DSC configuration applied, which has installed a web server on each.

![Image of DSC compliance results as seen in the Azure portal.](./media/dsc-results.png)

You can also browse to the public IP address of any virtual machine to verify that a web server is running.

#### [Azure portal](#tab/portal)

Use the following button to deploy the reference using the Azure portal.

[![Deploy to Azure](../../_images/deploy-to-azure.svg)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fmspnp%2Fsamples%2Fmaster%2FOperationalExcellence%2Fazure-automation-state-configuration%2Fazuredeploy.json)

Once deployed, in the Azure portal click on the **Automation Account** resource and then **State configuration (DSC)** and notice that all virtual machines have been added to the system and are compliant. These machines have all had the PowerShell DSC configuration applied, which has installed a web server on each.

![Image of DSC compliance results as seen in the Azure portal.](./media/dsc-results.png)

You can also browse to the public IP address of any virtual machine to verify that a web server is running.

--- 

## Components

**Azure Automation:** Azure Automation delivers a cloud-based automation and configuration service that supports consistent management across your Azure and non-Azure environments.

**Azure Automation State Configuration:** is a configuration management solution built on top of PowerShell Desired State Configuration (DSC). State configuration works with Azure virtual machines, on-premises machines, and machines in a cloud other than Azure. Using state configuration, you can import PowerShell DSC resources and assign them to many virtual machines from a central location. Once each endpoint has evaluated and / or applied the desired state, state compliance is reported to Azure and can be seen on a built-in dashboard.

**Azure Monitor:** Azure Monitor collects and stores metrics and logs, application telemetry, and platform metrics for the Azure services. Use this data to monitor the application, set up alerts, dashboards, and perform root cause analysis of failures.

**Azure Virtual Machines:** Azure IaaS solution for running virtual machines.

## Potential use cases

## Alternatives

## Considerations