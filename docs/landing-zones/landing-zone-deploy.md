---
title: Deploy Azure landing zones
description: Learn about the deployment options for platform and application landing zones in Azure.
author: RobBagby
ms.author: robbag
ms.date: 01/09/2025
ms.topic: conceptual
ms.service: azure-architecture-center
ms.subservice: architecture-guide
categories:
  - management-and-governance
  - devops
  - networking
  - security
azureCategories:
  - devops
  - hybrid
  - management-and-governance
  - networking
  - security
products:
  - azure
  - azure-resource-manager
  - azure-policy
  - azure-rbac
  - azure-virtual-network
---

# Deploy Azure landing zones

This article discusses the options available to you to deploy platform and application landing zones. Platform landing zones provide centralized services used by workloads. Application landing zones are environments deployed for the workloads themselves.

> [!IMPORTANT]
> For more information about platform versus application landing zones definitions and implementations, see [What is an Azure landing zone?](/azure/cloud-adoption-framework/ready/landing-zone/#platform-landing-zones-vs-application-landing-zones) in the Cloud Adoption Framework for Azure.

This article covers the deployment options for platform and application landing zones.

## Platform landing zone approaches

The following platform deployment options provide an opinionated approach to deploy and operate the [Azure landing zone conceptual architecture](/azure/cloud-adoption-framework/ready/landing-zone/#azure-landing-zone-architecture) as detailed in the Cloud Adoption Framework. Depending upon customizations, the resulting architecture might not be the same for all the deployment options listed here. The differences between the platform deployment options are based on how they use different technologies, take different approaches, and are customized differently.


### Standard deployment options

Standard deployment options address typical enterprise Azure usage.

| Azure platform landing zone deployment option | Description |
| :-------------------------------------------- | :---------- |
| [Azure portal deployment](/azure/cloud-adoption-framework/ready/landing-zone/#platform-landing-zone-accelerator) | An Azure portal-based deployment that provides a full implementation of the [Azure landing zone conceptual architecture](/azure/cloud-adoption-framework/ready/landing-zone/#platform-landing-zone-accelerator), along with opinionated configurations for key components, such as management groups and policies. |
| [Bicep deployment](./bicep/landing-zone-bicep.md) | A modular, infrastructure-as-code based deployment where each Bicep module encapsulates a core capability of the [Azure landing zone conceptual architecture](/azure/cloud-adoption-framework/ready/landing-zone/#platform-landing-zone-accelerator). While the modules can be deployed individually, the design proposes the use of orchestrator modules to encapsulate the complexity of deploying different topologies with the modules. Bicep deployment supports Azure public cloud, Azure China 21Vianet regions, and Azure US Government clouds. |
| [Terraform deployment](./terraform/landing-zone-terraform.md) | This infrastructure-as-code based deployment provides a Terraform orchestrator module and also allows you to deploy each platform capability individually or as a whole. |

### Variants and specializations

While the [standard platform deployment options](#standard-enterprise-deployment-options) address typical enterprise Azure usage, there are some deployment options that focus on specific specializations.

| Deployment option | Description |
| --- | ---|
| [Sovereign landing zone](/industry/sovereignty/slz-overview) | The sovereign landing zone is a variant of the Azure landing zones intended for organizations that need advanced sovereign controls. |

#### Partner implementations

Partner programs such as the [Azure Migrate and Modernize](/azure/cloud-adoption-framework/ready/landing-zone/partner-landing-zone#option-1---azure-migrate-and-modernize) can help you design and implement your platform landing zone specific to your organization's needs. Those implementations start with the [Azure landing zone conceptual architecture](/azure/cloud-adoption-framework/ready/landing-zone/#platform-landing-zone-accelerator) and help design configurations specific to your cloud adoption strategy, organizational topology, and desired outcomes.

#### Enterprise policy as code (EPAC) for policy management

[Enterprise policy as code (EPAC)](https://azure.github.io/enterprise-azure-policy-as-code/) is an alternative method to deploy, manage, and operate Azure Policy across your organization's Azure estate. You can use EPAC instead of the preceding [platform options](#platform-landing-zone-approaches) to manage the policies in an Azure landing zones environment. For more information on the integration approach, see [Integrate EPAC with Azure landing zones](https://azure.github.io/enterprise-azure-policy-as-code/integrating-with-alz/).

Enterprise policy as code is best suited for more advanced and mature DevOps and infrastructure-as-code customers. However, customers of any size can use EPAC if they want to after they assess it. To ensure that you're aligned, first see [Who should use EPAC?](https://azure.github.io/enterprise-azure-policy-as-code/#who-should-use-epac).

> [!NOTE]
> Compare the lifecycle and flexibility of the two approaches before you decide on what approach you use long term.  Begin by evaluating the native policy management that's provided in the default implementation described in the [standard platform options](#standard-enterprise-deployment-options). If that implementation doesn't seem like it's ideal for your governance needs, then perform an MVP or proof of concept using EPAC. It's important that you compare options, validate, and confirm your choice before implementing an approach, as it's a complex process to change policy governance methods once established.

### Operate Azure landing zones

After you deploy the platform landing zone, you need to operate and maintain it. For more information, see the guidance on how to [Keep your Azure landing zone up to date](/azure/cloud-adoption-framework/ready/landing-zone/design-area/keep-azure-landing-zone-up-to-date).

### Azure governance visualizer

[Azure governance visualizer](./azure-governance-visualizer-accelerator.yml) is intended to help you get a holistic overview on your technical Azure governance implementation by connecting the dots and providing sophisticated reports.

## Subscription vending

After the platform landing zone and governance strategy is in place, the next step is to establish consistency on how subscriptions are created and operationalized for workload owners. Subscription democratization is a [design principle](/azure/cloud-adoption-framework/ready/landing-zone/design-principles#subscription-democratization) of Azure landing zones that uses subscriptions as units of management and scale. This approach accelerates application migrations and new application development.

[Subscription vending](/azure/cloud-adoption-framework/ready/landing-zone/design-area/subscription-vending) standardizes the process platform teams use for workload teams to request subscriptions and platform teams to deploy and govern those subscriptions. It enables application teams to get access to Azure in a consistent and governed method, ensuring requirements gathering is complete.

It's also common for organizations to have multiple different styles of subscriptions that can be vended into their tenant, often referred to as "product lines" in the industry. See [Establish common subscription vending product lines](/azure/cloud-adoption-framework/ready/landing-zone/design-area/subscription-vending-product-lines) for recommended "product lines" for your organization.

To get started, follow the implementation guidance in [Subscription vending implementation guidance](./subscription-vending.yml). Then, review following infrastructure-as-code modules, which provide flexibility to fit your implementation needs.

| Deployment option | Description |
| :---------------- | :-----------|
| [Bicep subscription vending](https://github.com/Azure/bicep-registry-modules/tree/main/avm/ptn/lz/sub-vending) | The subscription vending Bicep modules are designed to orchestrate the deployment of the individual application landing zones based on per workload configuration. They can be executed manually or as part of automation. |
| [Terraform subscription vending](https://registry.terraform.io/modules/Azure/lz-vending/azurerm/latest) | These modules use Terraform to orchestrate the deployment of the individual application landing zones. |

## Application landing zone architectures

Application landing zones consist of one or more subscriptions that are deployed as approved destinations for application team-owned resources of a workload. A workload can take advantage of services deployed in platform landing zones or it can be isolated from those centralized resources. The application landing zones should be used for centrally managed applications, decentralized workloads owned by application teams, and centrally managed hosting platforms such as Azure Kubernetes Service (AKS) that could host applications for multiple business units. Unless forced by abnormal constraints, application landing zone subscriptions only contain resources from a single workload or logical application boundary, such as its lifecycle or its criticality classification.

Workload teams communicate their workload's requirements through a formal process established by the platform team. The platform team generally deploys an empty subscription that's enrolled with all required governance. A workload architect then designs a solution that works within the constraints of that application landing zone and take advantage of shared platform features (such a firewalls and cross-premisis routing), where practical.

It's possible that an architect can adapt a reference architecture that isn't specifically designed with an application landing zone in mind. However, Microsoft Learn also contains application and data platform guidance for workload teams that specifically addresses application landing zone contexts. Platform teams should be made aware of the guidance that's available to workload teams so the platform team can anticipate the workload types and characteristics that might be present in the organization.

| Application landing zone architecture | Description |
| --- | --- |
| [Azure App Service environment](/azure/cloud-adoption-framework/scenarios/app-platform/app-services/landing-zone-accelerator) | Proven recommendations and considerations across both multitenant and App Service environment use cases with a reference implementation. |
| [Azure API Management (APIM)](../example-scenario/integration/app-gateway-internal-api-management-function.yml) | Proven recommendations and considerations for deploying an internal API Management instance as part of a reference implementation. The scenario uses Azure Application Gateway to provide secure ingress control and uses Azure Functions as the back end. |
| [Azure Arc for hybrid and multicloud scenarios](/azure/cloud-adoption-framework/scenarios/hybrid/enterprise-scale-landing-zone) | Azure Arc-enabled servers, Kubernetes, and Azure Arc-enabled SQL Managed Instance. |
| [Azure Container Apps](/azure/cloud-adoption-framework/scenarios/app-platform/container-apps/landing-zone-accelerator) | This Azure Container Apps guidance outlines the strategic design path and defines the target technical state for deploying Azure Container Apps. A dedicated workload teams owns and operates this platform. |
| [Azure Data Factory](../databases/architecture/azure-data-factory-on-azure-landing-zones-baseline.yml) | Learn how to take a traditional [medallion lakehouse](/azure/databricks/lakehouse/medallion) and host it within an application landing zone. |
| [Azure OpenAI chat workload](../ai-ml/architecture/azure-openai-baseline-landing-zone.yml) | Outlines how to integrate a typical [Azure OpenAI chat application](../ai-ml/architecture/baseline-openai-e2e-chat.yml) within Azure landing zones to utilize centralized shared resources while adhering to governance and cost efficiency, offering guidance for workload teams on deployment and management. |
| [Azure Kubernetes Service (AKS)](/azure/cloud-adoption-framework/scenarios/app-platform/aks/landing-zone-accelerator) | Guidance and related infrastructure as code templates that represent the strategic design path and target technical state for an AKS deployment running within an application landing zone. |
| [Azure Red Hat OpenShift](/azure/cloud-adoption-framework/scenarios/app-platform/azure-red-hat-openshift/landing-zone-accelerator) | An open-source collection of Terraform templates that represent an optimal Azure Red Hat OpenShift deployment that includes Azure and Red Hat resources. |
| [Azure Synapse Analytics](../example-scenario/analytics/synapse-analytics-landing-zone.yml) | An architectural approach to prepare application landing zones for a typical enterprise deployment of Azure Synapse Analytics. |
| [Azure Virtual Desktop](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/enterprise-scale-landing-zone) | ARM, Bicep, and Terraform templates that should be referenced when designing Azure Virtual Desktop deployments, including creation of host pools, networking, storage, monitoring, and add-ons. |
| [Azure Virtual Machines](../virtual-machines/baseline-landing-zone.yml) | This architecture extends the guidance from the [Azure virtual machine (VM) baseline architecture](../virtual-machines/baseline.yml) to an application landing zone, with guidance on subscription setup, patch compliance, and other organizational governance concerns. |
| [Azure VMware Solution](/azure/cloud-adoption-framework/scenarios/azure-vmware/enterprise-scale-landing-zone) | ARM, Bicep, and Terraform templates that are useful when designing VMware deployments, including Azure VMware Solution private cloud, jump box, networking, monitoring, and add-ons. |
| [Citrix on Azure](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/landing-zone-citrix/citrix-enterprise-scale-landing-zone) | Design guidelines for the Cloud Adoption Framework for Citrix Cloud in an Azure enterprise-scale landing zone cover for many design areas. |
| [Red Hat Enterprise Linux (RHEL) on Azure](/azure/cloud-adoption-framework/scenarios/app-platform/azure-red-hat-enterprise-linux/landing-zone-accelerator) | The Landing Zone for Red Hat Enterprise Linux (RHEL) on Azure is an open-source collection of architectural guidance and reference implementation recommendations used design RHEL-based workloads on Microsoft Azure. |
| [High performance compute (HPC) workloads](/azure/cloud-adoption-framework/scenarios/azure-hpc/azure-hpc-landing-zone-accelerator) | An end-to-end HPC cluster solution in Azure that uses tools like Terraform, Ansible, and Packer. It addresses Azure landing zone best practices, including implementing identity, jump box access, and autoscale. |
| [Mission-critical workloads](../reference-architectures/containers/aks-mission-critical/mission-critical-landing-zone.yml) | Addresses how a workload classified as mission-critical should be designed to run within an application landing zone. |
| [SAP workloads](/azure/cloud-adoption-framework/scenarios/sap/enterprise-scale-landing-zone) | Provides guidance and recommendations for SAP workloads aligned to Azure landing zone best practices. Provides recommendations for creating infrastructure components like compute, networking, storage, monitoring, and build of SAP systems. |

Workloads are often a collection of various technologies and classifications. We recommend that you review related reference material for all the technologies in your workload. For example, comprehending the guidance from Azure OpenAI chat and the Azure API Management is important to understand if your generative AI scenario would benefit from adding an API gateway.

## Next step

> [!div class="nextstepaction"]
> [Design your subscription vending solution](./subscription-vending.yml)
