## Solution overview

For more information about this solution, see [
IaaS web application Blueprint Automation for FedRAMP-compliant environments](https://aka.ms/fedrampblueprint).

## Deploy the solution

This Azure Blueprint solution is comprised of JSON configuration files and PowerShell scripts that are handled by Azure Resource Manager's API service to deploy resources within Azure. 

#### Quickstart
1. Clone this repository to your local workstation.
2. Run the pre-deployment PowerShell script: azure-blueprint/predeploy/Orchestration_InitialSetup.ps1. [Read more about pre-deployment.](#pre-deployment)
3. Click the button below, sign into the Azure portal, enter the required ARM template parameters, and click **Purchase**. [Read more about deployment.](#deployment)

	[![Deploy to Azure](http://azuredeploy.net/AzureGov.png)](https://portal.azure.us/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAppliedIS%2Fazure-blueprint%2Fmaster%2Fazuredeploy.json)

### PRE-DEPLOYMENT

During pre-deployment, you will confirm that your Azure subscription and local workstation are prepared to deploy the solution. The final pre-deployment step will run a PowerShell script that verifies the setup requirements, gathers parameters and credentials, and creates resources in Azure to prepare for deployment.

#### Azure subscription requirements

This Azure Blueprint solution is designed to deploy to Azure Government. The solution does not currently support Azure commercial regions. For customers with a multi-tenant environment, the account used to deploy must be a member of the Azure Active Directory instance that is associated with the subscription where this solution will be deployed.

#### Local workstation requirements

PowerShell is used to initiate some pre-deployment tasks. PowerShell version 5.0 or greater must be installed on your local workstation. In PowerShell, use the following command to check the version:

`$PSVersionTable.psversion`

In order to run the pre-deployment script, you must have the current Azure PowerShell AzureRM modules installed (see [Installing AzureRM modules](https://docs.microsoft.com/powershell/azure/install-azurerm-ps)).

#### SSL certificate
This solution deploys an Application Gateway and requires an SSL certificate. To generate a self-signed SSL certificate using PowerShell, run [this script](predeploy/generateCert.ps1). Note that self-signed certificates are not recommended for use in production environments.

#### Pre-deployment script

The pre-deployment PowerShell script will verify that the necessary Azure PowerShell modules are installed. Azure PowerShell modules provide cmdlets for managing Azure resources. After all the setup requirements are verified, the script will ask you to sign into Azure and will then prompt for parameters and credentials to use when the solution is deployed. The script will prompt for the following parameters, in this order:

* **Azure username**: Your Azure username (ex. someuser@contoso.onmicrosoft.com)
* **Azure password**: Password for the Azure account above
* **Admin username**: Administrator username you want to use for the administrator accounts on deployed virtual machines
* **adminPassword**: Administrator password you want to use for the administrator accounts on deployed virtual machines (must meet the complexity requirements; see below)
* **sqlServerServiceAccountPassword**: SQL service account password you want to use (must meet the complexity requirements; see below)
* **subscriptionId**: To find your Azure Government subscription ID, navigate to https://portal.azure.us and sign in. Expand the service menu on the left side of the portal, select "more services," and begin typing "subscription" in the filter box. Click **Subscriptions** to open the subscriptions blade. Note the subscription ID, which has the format xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx.
* **resourceGroupName**: Resource group name you want to use for this deployment; must be a string of 1-90 alphanumeric characters (such as 0-9, a-z, A-Z), periods, underscores, hyphens, and parenthesis and it cannot end in a period (e.g., such as `blueprint-rg`).
* **keyVaultName**: Key Vault name you want to use for this deployment; must be a string 3-24 alphanumeric characters (such as 0-9, a-z, A-Z) and hyphens and must be unique across Azure Government.

Passwords must be at least 14 characters and contain one each of the following: lower case character, upper case character, number, and special character.

#### Pre-deployment instructions

1. Clone this GitHub repository to your local workstation
`git clone https://github.com/AppliedIS/azure-blueprint.git`
2. Start PowerShell as an administrator
3. Run Orchestration_InitialSetup.ps1
4. Enter the parameters above when prompted

Note the resource group name and Key Vault name; these will be required during the deployment phase. The script will also generate a GUID for use during the deployment phase.

### DEPLOYMENT

During this phase, an Azure Resource Manager (ARM) template will deploy Azure resources to your subscription and perform configuration activities.

After clicking the Deploy to Azure Gov button, the Azure portal will open and prompt you for the following settings:

**Basics**
* **Subscription**: Choose the same subscription used during the pre-deployment phase
* **Resource group**: Select 'Use existing' and choose the resource group created during pre-deployment
* **Location**: Select 'USGovVirginia'

**Settings**
* **Admin Username**: Administrator username you want to use for administrative accounts for deployed resources (can be the same username you entered during the pre-deployment phase)
* **Key Vault Name**: Name of the Key Vault created during pre-deployment
* **Key Vault Resource Group Name**: Name of the resource group created during pre-deployment
* **Cert Data**: 64bit-encoded certificate for SSL
* **Cert Password**: Password used to create the certificate
* **Scheduler Job GUID**: GUID for the runbook job to be started (use GUID output by pre-deployment script or run New-Guid in PowerShell)
* **OMS Workspace Name**: Name you want to use for the Log Analytic workspace; must be a string 4-63 alphanumeric characters (such as 0-9, a-z, A-Z) and hyphens and it must be unique across Azure Government.
* **OMS Automation Account Name**: Name you want to use for the automation account used with OMS; must be a string 6-50 alphanumeric characters (such as 0-9, a-z, A-Z) and hyphens and it must be unique across Azure Government.

#### Deployment instructions

1. Click the button below.

	[![Deploy to Azure](http://azuredeploy.net/AzureGov.png)](https://portal.azure.us/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAppliedIS%2Fazure-blueprint%2Fmaster%2Fazuredeploy.json)
2. Enter the settings above.
3. Review the terms and conditions and click **I agree to the terms and conditions stated above**.
4. Click **Purchase**.

#### Monitoring deployment status
This solution uses multiple nested templates to deploy and configure the resources shown in the architecture diagram. The full deployment will take approximately **[120]** minutes. You can monitor the deployment from Azure Portal.

See [TIMELINE.md](/docs/TIMELINE.md) for a resource dependency outline.

### POST-DEPLOYMENT

#### Accessing deployed resources

You can access your machines through the MGT VM that is created from the deployment. From this VM, you can remote into and access any of the VMs in the network.

#### Cost

Deploying this solution will create resources within your Azure subscription. You will be responsible for the costs associated with these resources, so it is important that you review the applicable pricing and legal terms associated with all the resources and offerings deployed as part of this solution. For cost estimates, you can use the Azure Pricing Calculator.

#### Extending the Solution with Advanced Configuration

If you have a basic knowledge of how Azure Resource Manager (ARM) templates work, you can customize the deployment by editing  azuredeploy.json or any of the templates located in the nested templates folder. Some items you might want to edit include, but are not limited to:
- Network Security Group rules (nestedtemplates/virtualNetworkNSG.json)
- OMS alert rules and configuration (nestedtemplates/provisioningAutoAccOMSWorkspace)
- Application Gateway routing rules (nestedtemplates/provisioningApplicationGateway.json)

Additional documentaiton about template deployment is available at the following links:

- [Azure Resource Manager Templates](https://docs.microsoft.com/azure/azure-resource-manager/resource-group-overview#template-deployment)
- [ARM Template Functions](https://docs.microsoft.com/azure/azure-resource-manager/resource-group-template-functions)
- [ARM Templating and Nesting Resources](https://docs.microsoft.com/azure/azure-resource-manager/resource-group-linked-templates)

If you do not want to specifically alter the template contents, you can edit the parameters section at the top level of the JSON object within azuredeploy.json.

#### Troubleshooting

If your deployment should fail, to avoid incurring costs and orphan resources it is advisable to delete the resource group associated with this solution in its entirety, fix the issue, and redeploy the solution. See the section below for instructions to delete all resources deployed by the solution.

Please feel free to open and submit a GitHub issue pertaining to the error you are experiencing.

#### How to delete deployed resources

To help with deleting protected resources, use postdeploy/deleteProtectedItems.ps1 -- this will specifically help you with removing the delete lock on the resources inside your vault.

## Known Issues

1. Deployment only works successfully with a new Key Vault (it does not work with an existing Key Vault).

## Disclaimer

- This document is for informational purposes only. MICROSOFT MAKES NO WARRANTIES, EXPRESS, IMPLIED, OR STATUTORY, AS TO THE INFORMATION IN THIS DOCUMENT. This document is provided "as-is." Information and views expressed in this document, including URL and other Internet website references, may change without notice. Customers reading this document bear the risk of using it.  
- This document does not provide customers with any legal rights to any intellectual property in any Microsoft product or solutions.  
- Customers may copy and use this document for internal reference purposes.  
- Certain recommendations in this document may result in increased data, network, or compute resource usage in Azure, and may increase a customer's Azure license or subscription costs.  
- This architecture is intended to serve as a foundation for customers to adjust to their specific requirements and should not be used as-is in a production environment.
- This document is developed as a reference and should not be used to define all means by which a customer can meet specific compliance requirements and regulations. Customers should seek legal support from their organization on approved customer implementations.

