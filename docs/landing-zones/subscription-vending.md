---
title: Subscription Vending Implementation Guidance
description: Learn how to implement subscription vending to standardize the process for automatic subscription creation and deploy workloads faster.
author: jtracey93
ms.author: jatracey
ms.date: 12/15/2025
ms.topic: conceptual
ms.subservice: architecture-guide
ai-usage: ai-assisted
---

# Subscription vending implementation guidance

This article provides implementation guidance for subscription vending automation. Subscription vending standardizes the process for requesting, deploying, and governing subscriptions so that application teams can deploy their workloads faster.

:::image type="complex" border="false" source="images/sample-subscription-vending-architecture.png" lightbox="images/sample-subscription-vending-architecture.png" alt-text="Diagram that shows subscription vending organization.":::
   The architecture diagram shows subscription vending organization with a management group hierarchy at the top and subscription automation workflow at the bottom. At the top, a tenant root group contains a Contoso management group, which branches into three child groups: platform on the left (containing identity and connectivity subscriptions), landing zones in the center (containing SAP, corp, and online subscriptions), and sandbox on the right. Underneath the management group section, a subscriptions layer shows four subscription boxes: identity subscription and connectivity subscription under platform, A1 subscription and A2 subscription under landing zones, and sandbox subscription 1 under sandbox. An arrow points from the connectivity subscription to a section that shows detailed networking components, including a regional hub icon connected by VNet peering to a Virtual network icon. The A2 subscription expands to show five icons that represent the budget, role assignment, policy assignment, Azure Network Watcher, and Microsoft Defender for Cloud configuration components. On the right side, a subscription vending automation workflow displays a linear process. The data collection tool triggers a request pipeline, which commits to source control, which then triggers a deployment pipeline. The deployment pipeline connects to infrastructure as code (IaC) modules at the top. A JSON/YAML subscription parameter file feeds into the workflow from the data collection tool. Arrows throughout the diagram show the flow from data collection through deployment, with the final arrow from the deployment pipeline pointing back up to the A2 subscription, which indicates the automated creation and configuration of subscriptions.
:::image-end:::

> [!TIP]
> :::image type="icon" source="../_images/github.svg"::: The subscription vending [Bicep](https://aka.ms/lz-vending/bicep) and [Terraform](https://registry.terraform.io/modules/Azure/avm-ptn-alz-sub-vending/azure) modules help you accelerate the creation of Azure subscriptions, or application landing zones, at scale. Tailor the input parameters and variables passed to the modules to fit the workloads' needs. For more information about the subscription vending process, see [Subscription vending overview](/azure/cloud-adoption-framework/ready/landing-zone/design-area/subscription-vending).
<br/><br/>
> [!VIDEO https://www.youtube.com/embed/OoC_0afxACg]

## Architecture

We recommend that you design your subscription vending automation to accomplish the following tasks:

- Subscription request data collection
- Platform automation initiation
- Subscription creation by using infrastructure as code (IaC)

You can take several approaches to implement subscription vending automation to accomplish these tasks. The following example implementation shows one approach that uses a Gitflow. The Gitflow design aligns with the declarative approach that many platform teams use to manage the platform.

:::image type="complex" border="false" source="images/subscription-vending-components.png" alt-text="Diagram that shows an example implementation of subscription vending automation." lightbox="images/subscription-vending-components.png":::
   The diagram shows a linear workflow for subscription vending automation that flows from left to right across five main components. On the far left is the data collection tool icon. An arrow labeled "trigger" points from the data collection tool to the request pipeline icon. Above the request pipeline, a gear icon with text reads "JSON/YAML subscription parameter file." From the request pipeline, an arrow labeled "commit" points to the source control icon in the center of the diagram. Above source control, two curved arrows point from a blue document icon labeled "IaC modules" to the source control icon and the deployment pipeline icon. From source control, an arrow labeled "trigger" points to the deployment pipeline icon. Finally, an arrow points from the deployment pipeline to a yellow key icon that represents the subscription. Under the request pipeline, source control, and deployment pipeline icons, a gray bar displays the text "Platform automation" in italics, which indicates that the request pipeline, source control, and deployment pipeline components are all part of the automated platform process. At the bottom of the diagram, three blue sections contain phase labels: "Collect data" on the left corresponding to the Data collection tool, "Initiate platform automation" in the center corresponding to the platform automation components, and "Create subscription" on the right corresponding to the final subscription output, showing the three main phases of the subscription vending process.
:::image-end:::

In the example implementation, the *data collection tool* gathers subscription request data. When the subscription request receives approval, it initiates the platform automation. The *platform automation* consists of the request pipeline, source control, and deployment pipeline. The *request pipeline* creates a JSON or YAML subscription parameter file with the data from the data collection tool. The request pipeline also creates a new branch, commits the subscription parameter file, and opens a pull request in *source control*. The new branch merges with the main branch in source control. The merge triggers the *deployment pipeline* to create the subscription with the IaC modules.

The deployment should place the *subscription* in the correct management group based on the governance requirements. The deployment creates a preliminary subscription budget as the foundation for cost management. Based on the needs of the workload, the deployment can create an empty virtual network and configure peering to a regional hub. The platform team should hand off the subscription to the application team after creation and configuration. The application team should update the subscription budget and create the workload resources.

## Collect data

The goal of collecting data is to receive business approval and define the values of the JSON/YAML subscription parameter file. Use a data collection tool to collect the required data when the application team submits the subscription request. The data collection tool should interface with other systems in the subscription vending workflow to initiate the platform automation.

**Use a data collection tool.** You can use an IT service management (ITSM) tool to collect the data or build a customer portal by using a low-code or no-code tool like [Microsoft Power Apps](https://powerapps.microsoft.com/). The data collection tool should provide business logic to approve or deny the subscription request.

**Collect the required data.** You need to collect enough data to define the values of the JSON/YAML subscription parameter so that you can automate the deployment. The specific values you collect depend on your needs. Capture the request authorizer, cost center, and networking requirements like internet or on-premises connectivity. It might be helpful to ask the application team for anticipated workload components like the application platform and data requirements, data sensitivity, and number of environments, including development, test, preproduction, and production environments.

**Validate data.** We recommend that you validate data during the data collection process. It's harder to address issues later in the platform automation phases.

**Create a trackable request.** Your data collection tool should create a logged and trackable request, like a ticket in an ITSM tool, for a new subscription. The request should contain all necessary data to fulfill the requirements of that subscription. Bind the business logic and authorization tracking to the request.

**Interface with other internal systems.** Where needed, the data collection tool should interface with other tools or systems in your organization. The goal is to enrich the request with data from other systems. You might need identity, finance, security, and networking data to run the automation. For example, the automation can interface with an IP address management (IPAM) tool to reserve the right IP address space.

**Create a trigger.** When the subscription request receives approval, the data transfer should trigger the platform automation. It's best to create a push notification with the necessary data from your data collection tool. You might need a middleware layer, like Azure Functions or Azure Logic Apps, to initiate the process.

## Initiate platform automation

The notification and data from the data collection tool should trigger the platform automation. The goal of platform automation is to create a JSON/YAML subscription parameter file, merge the file to the main branch, and use the IaC modules to deploy the file to create the subscription. The platform team should own and maintain the platform automation. The platform automation in the example implementation consists of the request pipeline, source control, and deployment pipeline.

**Use JSON or YAML files.** Use structured data files like JSON or YAML to store the data to create a subscription. Document the structure of the file and make it extensible to support future needs. For example, the following JSON code snippet defines the subscription parameter values for one of the Bicep modules in GitHub.

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
```

*[See the entire file](https://github.com/Azure/bicep-registry-modules/tree/main/avm/ptn/lz/sub-vending#example-3-using-only-defaults). For more examples, see [Bicep examples](https://github.com/Azure/bicep-registry-modules/tree/main/avm/ptn/lz/sub-vending#Usage-examples) and [Terraform examples](https://registry.terraform.io/modules/Azure/avm-ptn-alz-sub-vending/azure/latest/examples/complete)*.

**Use one file for each subscription request.** The subscription is the unit of deployment in the subscription vending process, so each subscription request should have one dedicated subscription parameter file.

> [!IMPORTANT]
> For Terraform implementations, use a dedicated state file for each application landing zone subscription to improve plan and apply performance and reduce the blast radius of potential misconfigurations.

**Use a pull request system.** The Gitflow process that creates the subscription parameter file should automate the following steps:

1. Create a new branch for each subscription request.
1. Use the data collected to create a single YAML/JSON/TFVARS subscription parameter file for the new subscription in the branch.
1. Create a pull request from your branch into `main`.
1. Update the data collection tool with a state change and reference to this pull request.

The *request pipeline* in the example implementation executes these steps (*see figure 2*). You could also use a code-based solution hosted in Azure if the workflow is complex.

**Validate the subscription parameter/variables file.** The pull request should trigger a linting process to validate the request data. The goal is to ensure the deployment is successful. It should validate the YAML/JSON/TFVARS subscription parameter file. It could also verify that the IP address range is still available. You might also want to add a manual review gate with human intervention. They could perform the final review and make changes to the subscription parameter file. The output should be a JSON/YAML/TFVARS subscription parameter file with all the data to create a subscription.

**Trigger the deployment pipeline.** When the pull request merges into the `main` branch, the merge should trigger the deployment pipeline.

## Create a subscription

The last task of the subscription vending automation is to create and configure the new subscription. The example implementation uses the *deployment pipeline* to deploy the IaC module with the JSON/YAML subscription parameter file (*see figure 2*).

**Use IaC.** Your deployment should use IaC to create the subscription. The platform team should create and maintain these templates to ensure proper governance. Use the subscription vending [Bicep](https://github.com/Azure/bicep-registry-modules/tree/main/avm/ptn/lz/sub-vending) and [Terraform](https://registry.terraform.io/modules/Azure/lz-vending) modules and modify them to fit your implementation needs.

**Use a deployment pipeline.** The deployment pipeline orchestrates the creation and configuration of the new subscription. The pipeline should execute the following tasks:

| Task category | Pipeline task |
| --- | --- |
| Identity |• Create or update Microsoft Entra resources to represent subscription ownership.<br>• Configure privileged workload identities for workload team deployments.|
| Governance |• Place in management group hierarchy.<br>• Assign subscription owner.<br>• Configure subscription-level Azure role-based access control (Azure RBAC) to the correct security groups.<br>• Assign subscription-level Azure Policy.<br>• Configure the Microsoft Defender for Cloud enrollment.|
| Networking |• Deploy virtual networks.<br>• Configure virtual network peering to platform resources (regional hub).|
| Budgets |• Create budgets for the subscription owners by using the collected data.|
| Reporting |• Update external systems, such as IPAM, to commit to IP reservations.<br>• Update the data collection tool request with final subscription name and globally unique identifier (GUID).<br>• Notify the application team that the subscription is ready.|

You need a commercial agreement to create a subscription programmatically. If you don't have a commercial agreement, you need to introduce a manual process to create the subscription but can still automate all other aspects of subscription configuration.

**Establish a workload identity.** The deployment pipeline needs permission to perform these operations with all the systems it interfaces with. Use managed identity or OpenID Connect (OIDC) to authenticate to Azure.

## Post-deployment

The subscription vending automation ends with subscription creation and configuration. The platform team should hand off the new subscription to the application team after creation. The application team should update the subscription budget, create the workload resources, and deploy the workload. The platform team controls the governance of the subscription and manages changes to subscription governance over time.

**Enforce cost management.** Subscription budgets provide notifications that are critical to cost management. The deployment should create a preliminary subscription budget based on the subscription request data. The application team receives the subscription. They should update the budget to meet the needs of the workload. For more information, see:

- [Create and manage budgets](/azure/cost-management-billing/costs/tutorial-acm-create-budgets)
- [Manage costs with Azure Budgets](/azure/cost-management-billing/manage/cost-management-budget-scenario)
- [Cost allocation](/azure/cost-management-billing/costs/allocate-costs)
- [Track costs across business units, environments, or projects](/azure/cloud-adoption-framework/ready/azure-best-practices/track-costs)

**Manage subscription governance.** Update the subscription as the governance requirements of the workload change. For example, you might need to move a subscription to a different management group. Build automation for some of these routine operations. For more information, see:

- [Move management groups and subscription](/azure/governance/management-groups/overview#moving-management-groups-and-subscriptions)
- [Keep policies and policy initiatives up to date](/azure/cloud-adoption-framework/ready/landing-zone/design-area/keep-azure-landing-zone-up-to-date#keep-policies-and-policy-initiatives-up-to-date)
- [Resource tagging](/azure/cloud-adoption-framework/ready/azure-best-practices/resource-tagging)
- [Tailor the Azure landing zone architecture to meet requirements](/azure/cloud-adoption-framework/ready/landing-zone/tailoring-alz)

## Next steps

Subscription vending simplifies and standardizes the subscription creation process and places it under the governance of the organization. Implement subscription vending automation to help your application teams access application landing zones faster and onboard workloads quicker. For more information, see:

- [Bicep modules](https://github.com/Azure/bicep-registry-modules/tree/main/avm/ptn/lz/sub-vending)
- [Terraform modules](https://registry.terraform.io/modules/Azure/avm-ptn-alz-sub-vending/azure)
- [Subscription vending overview](/azure/cloud-adoption-framework/ready/landing-zone/design-area/subscription-vending)
- [Establish common subscription vending product lines](/azure/cloud-adoption-framework/ready/landing-zone/design-area/subscription-vending-product-lines)
- [Azure landing zone overview](/azure/cloud-adoption-framework/ready/landing-zone/)
