This article provides implementation guidance for automating subscription vending. Subscription vending standardizes the process for requesting, deploying, and governing subscriptions for application landing zones. It places the subscription creation process under the governance of the platform, so application teams can focus on deploying their workloads with greater confidence and efficiency. You should automate as much of the subscription vending process as you can.

![GitHub icon](../_images/github.png) We created subscription vending [Bicep](https://aka.ms/lz-vending/bicep) and [Terraform](https://aka.ms/lz-vending/tf) modules that you should use as a starting point. Modify the templates to fit your implementation needs.

## Architecture

You should architect your subscription vending automation to accomplish three primary tasks. Subscription vending automation should (1) collect subscription request data, (2) initiate platform automation, and (3) create the subscription using infrastructure-as-code. Numerous approaches exist for implementing subscription vending automation. The example implementation utilizes a Gitflow implementation (*see Figure 1*).

[![Diagram showing the components of the example implementation of subscription vending automation.](images/subscription-vending-components.png)](images/subscription-vending-components.png)
*Figure 1. Example implementation of subscription vending automation. For a visualization of the flow, see [subscription vending process flow](https://github.com/microsoftdocs/architecture-center/blob/main/docs/landing-zones/images/subscription-vending-process-flow.md)*

The request pipeline, source control, and deployment pipeline are the platform automation. The Gitflow design aligns with the declarative approach that platform teams use to manage the platform. The data collection tool gathers subscription request data. When the request receives approval, it triggers the request pipeline. The request pipeline creates a JSON or YAML subscription parameter file with the data from the data collection tool. The request pipeline creates a new branch, commits the subscription parameter file and opens pull request in source control. The new branch mergers into the main branch in source control. The merge triggers the deployment pipeline to create the subscription with the infrastructure-as-code modules. The deployment should create the subscription in the right management group with the necessary governance (*see Figure 2*).

[![Diagram showing how the subscriptions vending fits in an organization.](images/sample-subscription-vending-architecture.png)](images/sample-subscription-vending-architecture.png)
*Figure 2. Subscription vending automation in an example Azure environment.*

Based on the needs of the workload, the deployment could create an empty virtual network and configure peering to a regional hub. The platform team should hand off the subscription to the application team, and the application team should apply a budget to the subscription and create the workload resources.

## How to collect data

The goal of data collection is to receive business approval and define the values of the JSON/YAML subscription parameter file. You should use a data collection tool to collect the required data. The data collection tool should interface with other systems in the subscription vending workflow to initiate the platform automation.

**Use a data collection tool.** You can use an IT Service Management (ITSM) to collect the data or build a customer portal with a low-code or no-code tool like [Microsoft PowerApps](https://powerapps.microsoft.com/). This data collection tool should provide business logic approve or deny the subscription request.

**Collect the required data.** You need to collect enough data to define the values of the JSON/YAML subscription parameter so you can automate the deployment. The specific values you collect depend on your needs. You should capture the request authorizer, cost center, and networking requirements (internet connectivity needed, on-premises connectivity needed). It might be helpful to ask the application team for anticipate workload components (application platform, data requirements), data sensitivity levels, and the number of environments (development, test, preproduction, production).

**Validate data.** You want to validate as much data as possible during the request collection process as possible. It's harder to address issues in the platform automation phases.

**Create trackable request.** Your data collection tool should result in a logged and trackable request for a new subscription. For example, an ITSM generates a ticket. The request should contain all necessary data to fulfill the requirements of that subscription. You should bind the business logic and authorization tracking to the request.

**Interface with other internal systems.** Where needed, the data collection tool should interface with other tools or systems in your organizations. The goal of the interface is to enrich the request with data from other systems. These systems contain identity, finance, security, and networking data. For example, you could interface with an IP address management (IPAM) tool to reserve the right IP address space.

**Create trigger.** When the subscription request receives approval, the data transfer should trigger the platform automation. It's ideal to create a push notification from your data collection with the necessary data. You might need a middleware layer, such as Azure Functions or Logic Apps, to initiate the process.

## How to initiate platform automation

The notification and data from the data collection tools should trigger the platform automation. The goal of platform automation is to create a JSON/YAML subscription parameter file, merge the file to the main branch, and deploy it with the infrastructure-as-code modules to create the subscription. The platform team owns and maintains this implementation responsible for subscription creation in the organization.

**Use JSON or YAML files.** You should use structured data files (JSON or YAML) to store the data necessary to create a subscription. The structure of the file should be documented and extensible to support future needs. The following JSON file defines the values of the subscription parameters in the Bicep template.

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "subscriptionDisplayName": {
      "value": "sub-bicep-lz-vending-example-001"
    },
    "subscriptionAliasName": {
      "value": "sub-bicep-lz-vending-example-001"
    },
    "subscriptionBillingScope": {
      "value": "providers/Microsoft.Billing/billingAccounts/1234567/enrollmentAccounts/123456"
    },
  // Insert more parameters here
  }
}

*[See code in context](https://github.com/azure/bicep-lz-vending/wiki/Example-1-Hub-and-Spoke#arm-json-parameter-file). For more examples, see [Bicep examples](https://github.com/azure/bicep-lz-vending/wiki/examples) and [Terraform examples](https://registry.terraform.io/modules/Azure/lz-vending/azurerm/latest#example)*

**Use one file per subscription request.** Each subscription request should get its own dedicated configuration file.  The subscription is the unit of deployment in the vending process.

**Use a pull request system.** The Gitflow process that creates the subscription parameter file should automate the following steps:

1. Create a new branch for each subscription request
1. Use the data collected to create a single YAML/JSON subscription parameter file for the new subscription in the branch.
1. Create a pull request from your branch into `main`
1. Update the data collection tool with a state change and reference to this pull request

The *request pipeline* in the example implementation executes these steps (*see figure 1*). You could also use a code-based solution hosted in Azure if the workflow becomes complex.

**Validate the subscription parameter file**. The pull request should trigger a linting process to validate the request data. The goal to ensure the deployment is successful. It should validate the YAML/JSON subscription parameter file. It could also verify that the IP address range is still available. You might also want to add a manual review gate with human intervention. They could perform the final review and make any alterations to the subscription parameter file. The output should be a JSON/YAML subscription parameter file with all the data to create a subscription. For example, mapped Owner RBAC role to subscription owner alias.

**Trigger the deployment pipeline.** When the pull request merges into `main` the main branch, it should trigger the deployment pipeline.

## How to create subscription

The last task of the subscription vending automation is to create and configures the workload subscription. The example implementation uses the *deployment pipeline* to deploy the infrastructure-as-code template with the JSON/YAML subscription parameter file (*see figure 1*).

**Use infrastructure as code.** Your deployments should use infrastructure as code templates to create the subscription. The platform team should create and maintain these templates to ensure proper governance.

![GitHub icon](../_images/github.png) Reference the subscription vending [Bicep](https://aka.ms/lz-vending/bicep) and [Terraform](https://aka.ms/lz-vending/tf) modules and modify to your implementation.

**Use a deployment pipeline.** The deployment pipeline orchestrates the creation and configuration of the workload subscription. The pipeline should execute the following tasks:

| Task category | Pipeline task |
| --- | --- |
| **Identity** |• Create or update Azure AD resources to represent subscription ownership<br>• Configure privileged workload identities for workload team deployments
| **Governance** |• Place in management group hierarchy<br>• Assign subscription owner<br>• Configure subscription-level role-based access controls (RBACs) to configured security groups.<br>• Assign subscription-level Azure Policy<br>• Configure the Microsoft Defender for Cloud enrollment.|
| **Networking** |• Deploy virtual networks<br>• Configure virtual network peering to platform resources (regional hub)
| **Budgets** |• Create budgets for the subscription owners using the collected data.|
| **Reporting** |• Update external systems, such as IPAM to commit on IP reservations<br>• Update the data collection tool request with final subscription name and globally unique identifier (GUID)<br>• Notify the application team that they subscription is ready.

You need a commercial agreement to create a subscription programmatically. If you don't have a commercial agreement, you need to introduce a manual process to create the subscription, but you can automate all other aspects of subscription configuration without a commercial agreement.

**Establish workload identity.** The deployment pipeline needs permission to perform these operations with all systems it interfaces with. You should either use managed identity or OpenID Connect (OIDC) to authenticate to Azure.

## Post-deployment

The subscription vending automation ends with subscription creation and automation. The platform team should hand off the new subscription to the application team to create the subscription budget and deploy the workload. However, the platform team maintains control over subscription governance and manages changes over time.

**Enforce cost management.**

TODO

**Manage subscription governance.** You should update the subscription as the governance requirements of the workload change. For example, you might need to move a subscription to a different management group. You should build automation for some of these routine operations. For more information, see:

- [Moving management groups and subscription](/azure/governance/management-groups/overview#moving-management-groups-and-subscriptions)
- [Keep policies and policy initiatives up to date](/azure/cloud-adoption-framework/govern/resource-consistency/keep-azure-landing-zone-up-to-date#keep-policies-and-policy-initatives-up-to-date)
- [Resource tagging](/azure/cloud-adoption-framework/govern/resource-consistency/tagging#enforce)

## Next steps

TODO

- [Bicep modules](https://aka.ms/lz-vending/bicep)
- [Terraform modules](https://aka.ms/lz-vending/tf)
