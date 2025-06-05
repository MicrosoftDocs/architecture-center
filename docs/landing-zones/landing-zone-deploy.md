---
title: Deploy Azure Landing Zones
description: Learn about deployment options for both platform and application landing zones in Azure to help ensure governance and cost efficiency.
author: jtracey93
ms.author: jatracey
ms.date: 02/25/2025
ms.topic: conceptual
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

This article describes the options available to help you deploy both platform and application landing zones. Platform landing zones provide centralized services that workloads use. Application landing zones are environments deployed for the workloads themselves.

> [!IMPORTANT]
> For more information about definitions and implementations for platform landing zones versus application landing zones, see [What is an Azure landing zone?](/azure/cloud-adoption-framework/ready/landing-zone/#platform-landing-zones-vs-application-landing-zones).


## Choose a platform landing zone approach

The following platform deployment options provide an opinionated approach to deploy and operate the [Azure landing zone conceptual architecture](/azure/cloud-adoption-framework/ready/landing-zone/#azure-landing-zone-architecture) as described in the Cloud Adoption Framework for Azure. The resulting architecture can vary based on the customizations, so it might not be the same for all the deployment options listed in this article. The differences between the platform deployment options are based on their use of different technologies, approaches, and customizations.

### Standard deployment options

Standard deployment options address typical enterprise Azure usage.

| Azure platform landing zone deployment option | Description |
| :-------------------------------------------- | :---------- |
| The Azure portal deployment | The Azure portal-based deployment provides a full implementation of the [Azure landing zone conceptual architecture](/azure/cloud-adoption-framework/ready/landing-zone/#azure-landing-zone-architecture) and opinionated configurations for key components, such as management groups and policies. |
| [Bicep deployment](./bicep/landing-zone-bicep.md) | A modular deployment that's based on infrastructure as code (IaC), where each Bicep module encapsulates a core capability of the [Azure landing zone conceptual architecture](/azure/cloud-adoption-framework/ready/landing-zone/#azure-landing-zone-architecture). These modules can be deployed individually, but the design recommends that you use orchestrator modules to encapsulate the complexity of deploying different topologies with the modules. Bicep deployment supports the Azure public cloud, Azure operated by 21Vianet regions, and Azure Infrastructure Services for US Government Clouds. |
| [Terraform deployment](https://azure.github.io/Azure-Landing-Zones/terraform/) | An IaC-based deployment that uses Azure-verified modules for platform landing zones and provides a customizable way to deploy Azure landing zones with Terraform. |

### Variants and specializations

The [standard platform deployment options](#standard-deployment-options) address typical enterprise Azure usage, but some deployment options focus on specific specializations. For instance, a [sovereign landing zone](/industry/sovereignty/slz-overview) is a variant of the Azure landing zone designed for organizations that require advanced sovereign controls.

#### Partner implementations

Partner programs such as [Azure Migrate and Modernize](/azure/cloud-adoption-framework/ready/landing-zone/partner-landing-zone#option-1---azure-migrate-and-modernize) can help you design and implement a platform landing zone that's specific to your organization's needs. Those implementations start with the [Azure landing zone conceptual architecture](/azure/cloud-adoption-framework/ready/landing-zone/#azure-landing-zone-architecture) and design configurations that are specific to your cloud adoption strategy, organizational topology, and desired outcomes.

#### Enterprise policy as code for policy management

[Enterprise policy as code (EPAC)](https://azure.github.io/enterprise-azure-policy-as-code/) is an alternative method to deploy, manage, and operate Azure Policy across your organization's Azure estate. You can use EPAC instead of the [standard platform options](#standard-deployment-options) to manage the policies in an Azure landing zone environment. For more information about the integration approach, see [Integrate EPAC with Azure landing zones](https://azure.github.io/enterprise-azure-policy-as-code/integrating-with-alz/).

EPAC is best suited for more advanced DevOps and IaC customers. However, organizations of any scale can use EPAC after they assess it. For more information, see [Who should use EPAC?](https://azure.github.io/enterprise-azure-policy-as-code/#who-should-use-epac).

> [!NOTE]
> Compare the lifecycle and flexibility of the two approaches before you decide on what approach to use long term. Begin by evaluating the native policy management in the [default implementation](#standard-deployment-options). If that implementation doesn't suit your governance needs, then perform an MVP or proof of concept by using EPAC. It's important that you compare options, validate your findings, and confirm your choice before you implement an approach because it's difficult to change policy governance methods after you establish them.

### Operate Azure landing zones

After you deploy the platform landing zone, you need to operate and maintain it. For more information, see [Keep your Azure landing zone up to date](/azure/cloud-adoption-framework/ready/landing-zone/design-area/keep-azure-landing-zone-up-to-date).

### Azure governance visualizer

[Azure governance visualizer](./azure-governance-visualizer-accelerator.yml) can help you get a holistic overview of your technical Azure governance implementation by connecting the dots and providing sophisticated reports.

## Subscription vending

After the platform landing zone and governance strategy is in place, the next step is to establish consistency about how subscriptions are created and operationalized for workload owners. [Subscription democratization](/azure/cloud-adoption-framework/ready/landing-zone/design-principles#subscription-democratization) is a design principle of Azure landing zones that uses subscriptions as units of management and scale. This approach accelerates application migrations and new application development.

[Subscription vending](/azure/cloud-adoption-framework/ready/landing-zone/design-area/subscription-vending) standardizes the process that platform teams use for workload teams to request subscriptions and platform teams to deploy and govern those subscriptions. It allows application teams to access Azure in a consistent and governed way, which helps ensure that requirements gathering is complete.

Organizations often have various styles of subscriptions that can be vended into their tenant, commonly referred to as *product lines*. For more information, see [Establish common subscription vending product lines](/azure/cloud-adoption-framework/ready/landing-zone/design-area/subscription-vending-product-lines).

To get started, follow the [subscription vending implementation guidance](./subscription-vending.yml). Then review the following IaC modules, which provide flexibility to fit your implementation needs.

| Deployment option | Description |
| :---------------- | :-----------|
| [Bicep subscription vending](https://github.com/Azure/bicep-registry-modules/tree/main/avm/ptn/lz/sub-vending) | The subscription vending Bicep modules are designed to orchestrate the deployment of the individual application landing zones based on the configuration of each workload. They can be performed manually or as part of the automation process. |
| [Terraform subscription vending](https://registry.terraform.io/modules/Azure/lz-vending/azurerm/latest) | Modules use Terraform to orchestrate the deployment of the individual application landing zones. |

## Application landing zone architectures

Application landing zones are designated areas within one or more subscriptions, specifically set up as approved destinations for resources that application teams manage for a specific workload. A workload can take advantage of services in platform landing zones or remain isolated from those centralized resources. Use application landing zones for centrally managed applications, decentralized workloads that application teams own, and centrally managed hosting platforms such as Azure Kubernetes Service (AKS) that could host applications for multiple business units. Unless constrained by unusual circumstances, application landing zone subscriptions typically include resources from only a single workload or logical application boundary, such as its lifecycle or criticality classification.

Workload teams communicate their workload's requirements through a formal process that the platform team establishes. The platform team generally deploys an empty subscription that's enrolled with all required governance. Then a workload architect designs a solution that works within the constraints of that application landing zone and takes advantage of shared platform features, such as firewalls and cross-premises routing, when practical.

It's possible for an architect to adapt a reference architecture that isn't designed specifically with an application landing zone in mind. However, Microsoft Learn also contains application and data platform guidance for workload teams that specifically addresses application landing zone contexts. Make the platform teams aware of the guidance that's available to the workload teams so that the platform team can anticipate the workload types and characteristics that might be in the organization.

| Application landing zone architecture | Description |
| --- | --- |
| [Azure App Service environment](/azure/cloud-adoption-framework/scenarios/app-platform/app-services/landing-zone-accelerator) | Proven recommendations and considerations across both multitenant and App Service environment use cases with a reference implementation. |
| [Azure API Management](../example-scenario/integration/app-gateway-internal-api-management-function.yml) | Proven recommendations and considerations for how to deploy an internal API Management instance as part of a reference implementation. The scenario uses Azure Application Gateway to help provide secure ingress control and uses Azure Functions as the back end. |
| [Azure Arc for hybrid and multicloud scenarios](/azure/cloud-adoption-framework/scenarios/hybrid/enterprise-scale-landing-zone) | Guidance for servers, Kubernetes, and Azure SQL Managed Instance enabled by Azure Arc. |
| [Azure Container Apps](/azure/cloud-adoption-framework/scenarios/app-platform/container-apps/landing-zone-accelerator) | Guidance that outlines the strategic design path and defines the target technical state for deploying Container Apps. A dedicated workload team owns and operates this platform. |
| [Azure Data Factory](../databases/architecture/azure-data-factory-on-azure-landing-zones-baseline.yml) | Guidance about how to host a [medallion lakehouse](/azure/databricks/lakehouse/medallion) within an application landing zone. |
| [Azure OpenAI Service chat workload](../ai-ml/architecture/azure-openai-baseline-landing-zone.yml) | Guidance about how to integrate a typical [Azure OpenAI chat application](../ai-ml/architecture/baseline-openai-e2e-chat.yml) within Azure landing zones to use centralized shared resources while adhering to governance and cost efficiency. It provides guidance for workload teams about deployment and management.|
| [AKS](/azure/cloud-adoption-framework/scenarios/app-platform/aks/landing-zone-accelerator) | Guidance and related IaC templates that represent the strategic design path and target technical state for an AKS deployment that runs within an application landing zone. |
| [Azure Red Hat OpenShift](/azure/cloud-adoption-framework/scenarios/app-platform/azure-red-hat-openshift/landing-zone-accelerator) | An open-source collection of Terraform templates that represent an optimal Azure Red Hat OpenShift deployment that includes Azure and Red Hat resources. |
| [Azure Synapse Analytics](../example-scenario/analytics/synapse-analytics-landing-zone.yml) | An architectural approach to prepare application landing zones for a typical enterprise deployment of Azure Synapse Analytics. |
| [Azure Virtual Desktop](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/enterprise-scale-landing-zone) | Azure Resource Manager (ARM), Bicep, and Terraform templates that you should reference when you design Azure Virtual Desktop deployments, which includes the creation of host pools, networking, storage, monitoring, and add-ons. |
| [Azure Virtual Machines](../virtual-machines/baseline-landing-zone.yml) |  An architecture that extends the guidance from the [Virtual Machines baseline architecture](../virtual-machines/baseline.yml) to an application landing zone. It provides guidance about subscription setup, patch compliance, and other organizational governance concerns. |
| [Azure VMware Solution](/azure/cloud-adoption-framework/scenarios/azure-vmware/enterprise-scale-landing-zone) | ARM, Bicep, and Terraform templates that you can use to help design Azure VMware Solution deployments. These deployments include Azure VMware Solution private cloud, jump box, networking, monitoring, and add-ons. |
| [Citrix on Azure](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/landing-zone-citrix/citrix-enterprise-scale-landing-zone) | Design guidelines for the Cloud Adoption Framework for Citrix Cloud in an Azure enterprise-scale landing zone that includes many design areas. |
| [Red Hat Enterprise Linux (RHEL) on Azure](/azure/cloud-adoption-framework/scenarios/app-platform/azure-red-hat-enterprise-linux/landing-zone-accelerator) | An open-source collection of architectural guidance and reference implementation recommendations that you can use to design RHEL-based workloads on Microsoft Azure. |
| [High performance compute (HPC) workloads](/azure/cloud-adoption-framework/scenarios/azure-hpc/azure-hpc-landing-zone-accelerator) | An end-to-end HPC cluster solution in Azure that uses tools like Terraform, Ansible, and Packer. It addresses Azure landing zone best practices, which includes identity implementation, jump box access, and autoscaling. |
| [Mission-critical workloads](../reference-architectures/containers/aks-mission-critical/mission-critical-landing-zone.yml) | Addresses how to design a mission-critical workload to run within an application landing zone. |
| [SAP workloads](/azure/cloud-adoption-framework/scenarios/sap/enterprise-scale-landing-zone) | Provides guidance and recommendations for SAP workloads aligned to Azure landing zone best practices. Provides recommendations for how to create infrastructure components like compute, networking, storage, monitoring, and the build of SAP systems. |

Workloads often consist of various technologies and classifications. We recommend that you review related reference materials for all the technologies in your workload. For example, understanding the guidance from Azure OpenAI chat and API Management is crucial to determine if your generative AI scenario can benefit from incorporating an API gateway.

## Next step

- [Design your subscription vending solution](./subscription-vending.yml)
