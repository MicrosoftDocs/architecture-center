---
title: Deploy Azure Landing Zones
description: Learn about deployment options for both platform and application landing zones in Azure to help ensure governance at scale.
author: jtracey93
ms.author: jatracey
ms.date: 12/15/2025
ms.topic: conceptual
ms.subservice: architecture-guide
---

# Deploy Azure landing zones

This article describes the options available to help you deploy both a platform landing zone and application landing zones. A platform landing zone provides centralized services that workloads use. Application landing zones are environments deployed for the workloads themselves.

> [!IMPORTANT]
> For more information about definitions of the platform landing zone and its connected application landing zones, see [Platform landing zone versus application landing zones](/azure/cloud-adoption-framework/ready/landing-zone/#platform-landing-zones-vs-application-landing-zones).

## Choose a platform landing zone approach

The following platform deployment options provide an opinionated approach to deploy and operate the [Azure landing zone reference architecture](/azure/cloud-adoption-framework/ready/landing-zone/#azure-landing-zone-architecture) as described in the Cloud Adoption Framework for Azure. The resulting architecture can vary based on the customizations, so it might not be the same for all the deployment options listed in this article. The differences between the platform deployment options are based on their use of different technologies, approaches, and customizations.

### Standard deployment options

Standard deployment options address typical enterprise Azure usage.

| Azure platform landing zone deployment option | Description | Azure public clouds | Azure sovereign clouds like US Government and 21Vianet |
| :--- | :--- | :--- | :--- |
| The Azure portal deployment | An Azure portal-based deployment that provides a complete implementation of the [Azure landing zone reference architecture](/azure/cloud-adoption-framework/ready/landing-zone/#azure-landing-zone-architecture) and opinionated configurations for key components, including management groups and policies. | Supported | Not supported. <br><br> You can deploy individual resources by using the Azure portal. But this approach doesn't provide a unified, guided experience across resources. |
| [Bicep deployment](https://azure.github.io/Azure-Landing-Zones/bicep/gettingstarted/) | An infrastructure as code (IaC) deployment that uses [Azure verified modules](https://azure.github.io/Azure-Verified-Modules/) and provides a customizable way to deploy a platform landing zone by using Bicep. | Supported | Not supported. <br><br> You can use the [Bicep code](https://github.com/Azure/alz-bicep-accelerator/tree/main/templates) as a starting point to build a custom implementation that follows [Azure platform landing zone](/azure/cloud-adoption-framework/ready/landing-zone/design-areas) best practices. For more information about what customizations the code requires, see the [Azure sovereign cloud deployments](#azure-sovereign-cloud-deployments) section. |
| [Terraform deployment](https://azure.github.io/Azure-Landing-Zones/terraform/gettingstarted/) | An IaC deployment that uses [Azure verified modules](https://azure.github.io/Azure-Verified-Modules/) and provides a customizable way to deploy a platform landing zone by using Terraform. | Supported | Not supported. <br><br> You can use the [Terraform code](https://github.com/Azure/alz-terraform-accelerator/tree/main/templates/platform_landing_zone) as a starting point to build a custom implementation that follows [Azure platform landing zone](/azure/cloud-adoption-framework/ready/landing-zone/design-areas) best practices. For more information about what customizations the code requires, see the [Azure sovereign cloud deployments](#azure-sovereign-cloud-deployments) section. |

You can also review the [implementation options for Azure landing zones](/azure/cloud-adoption-framework/ready/landing-zone/implementation-options) to help you choose the best deployment option for your organization.

#### Azure sovereign cloud deployments

The Azure portal, Bicep, and Terraform deployment options are supported for Azure public, global, and commercial cloud offerings. If you need to deploy into other Azure clouds, such as Azure Infrastructure Services for US Government Clouds or Microsoft Azure operated by 21Vianet, your platform team needs to make manual configuration changes to the deployment assets. Only the Bicep and Terraform deployment options can be modified to accommodate these changes. Consider the following cloud-specific limitations and configuration requirements:

- **Azure Policy definitions, initiatives, and assignments:** Not all Azure policies are available across all clouds, so you need to remove unsupported policies before deployment.

- **API versions for some resources:** Specific API versions might not exist in some clouds, so you need to adjust resource API versions before deployment.

- **Resource availability:** Some resources might not exist in some clouds. For example, Azure DDoS Protection plans aren't available in Azure in China. You need to remove these resources before deployment.

The [Azure landing zone architecture](/azure/cloud-adoption-framework/ready/landing-zone/#azure-landing-zone-architecture) is valid and supported in all Azure clouds. But the deployment for that architecture isn't provided in an automated solution that works across all clouds. If you want automated deployment support for these clouds, [request the feature](https://github.com/Azure/Enterprise-Scale/issues/new?template=FEATURE_REQUEST.md).

### Variants and specializations

The [standard platform deployment options](#standard-deployment-options) meet the requirements of most organizations across all industries and sizes. For other scenarios, see the following tailored architectures and deployment options to help you deploy your platform landing zone quickly.

The following options provide specialized platform landing zone implementations that you can use instead of the [standard deployment options](#standard-deployment-options).

| Platform landing zone variant | Description |
| :--- | :--- |
| Sovereign landing zone | The [sovereign landing zone](/industry/sovereign-cloud/sovereign-public-cloud/sovereign-landing-zone/overview-slz) is a specialized implementation of the [Azure landing zone reference architecture](/azure/cloud-adoption-framework/ready/landing-zone/#azure-landing-zone-architecture) that's designed specifically for organizations that have stringent regulatory, compliance, and data residency requirements that focus on sovereignty. It includes tailored configurations and policies to help meet these needs while still adhering to the core design principles and design areas of Azure landing zones. |

#### Partner implementations

Partner programs like [Azure Accelerate](/azure/cloud-adoption-framework/ready/landing-zone/partner-landing-zone#option-1---azure-accelerate) can help you design and implement a platform landing zone that meets your organization's needs. Those implementations start with the [Azure landing zone reference architecture](/azure/cloud-adoption-framework/ready/landing-zone/#azure-landing-zone-architecture) and design configurations that are specific to your cloud adoption strategy, organizational topology, and goals.

#### Enterprise policy as code for policy management

[Enterprise policy as code (EPAC)](https://azure.github.io/enterprise-azure-policy-as-code/) is an alternative method to deploy, manage, and operate Azure Policy across your organization's Azure estate. You can use EPAC instead of the [standard platform options](#standard-deployment-options) to manage the policies in an Azure landing zone environment. For more information about the integration approach, see [Integrate EPAC with Azure landing zones](https://azure.github.io/enterprise-azure-policy-as-code/integrating-with-alz-overview/).

EPAC is best suited for more advanced DevOps and IaC customers, but organizations of any scale can use EPAC after they assess it. For more information, see [Who should use EPAC?](https://azure.github.io/enterprise-azure-policy-as-code/#who-should-use-epac)

> [!NOTE]
> Compare the life cycle and flexibility of the two approaches before you decide on what approach to use long term. Begin by evaluating the native policy management in the [default implementation](#standard-deployment-options). If that implementation doesn't meet your governance needs, then do a minimum viable product or proof of concept by using EPAC. It's important that you compare options, validate your findings, and confirm your choice before you implement an approach because it's difficult to change policy governance methods after you establish them.

### Operate Azure landing zones

After you deploy the platform landing zone, you need to operate and maintain it. For more information, see [Keep your Azure landing zone up to date](/azure/cloud-adoption-framework/ready/landing-zone/design-area/keep-azure-landing-zone-up-to-date).

### Azure governance visualizer

[Azure governance visualizer](./azure-governance-visualizer-accelerator.yml) can help you get a holistic overview of your technical Azure governance implementation by connecting the dots and providing sophisticated reports.

## Subscription vending

After the platform landing zone and governance strategy are in place, establish a consistent approach to how you create and operationalize subscriptions for workload owners. [Subscription democratization](/azure/cloud-adoption-framework/ready/landing-zone/design-principles#subscription-democratization) is an Azure landing zones design principle that uses subscriptions as units of management and scale. This approach accelerates application migrations and new application development.

[Subscription vending](/azure/cloud-adoption-framework/ready/landing-zone/design-area/subscription-vending) standardizes the process that platform teams use for workload teams to request subscriptions and platform teams to deploy and govern those subscriptions. It lets application teams access Azure in a consistent and governed way, which helps ensure that teams meet all of the requirements.

Organizations often have different styles of subscriptions that can be vended into their tenant, commonly called *product lines*. For more information, see [Establish common subscription vending product lines](/azure/cloud-adoption-framework/ready/landing-zone/design-area/subscription-vending-product-lines).

To get started, follow the [subscription vending implementation guidance](./subscription-vending.md). Then review the following IaC modules, which provide flexibility to fit your implementation needs.

| Deployment option | Description |
| :---------------- | :-----------|
| [Bicep subscription vending](https://github.com/Azure/bicep-registry-modules/tree/main/avm/ptn/lz/sub-vending) | The subscription vending Bicep modules are designed to orchestrate the deployment of an individual application landing zone. |
| [Terraform subscription vending](https://aka.ms/lz-vending/tf) | This approach uses Terraform to orchestrate the deployment of an individual application landing zone. |

You can use all deployment options to manually deploy an application landing zone, but they're most effective as part of an automated process.

## Application landing zone architectures

Application landing zones are designated areas within one or more subscriptions, specifically set up as approved destinations for resources that application teams manage for a specific workload. A workload can take advantage of services in the platform landing zone or remain isolated from those centralized resources. Use application landing zones for centrally managed applications, decentralized workloads that application teams own, and centrally managed hosting platforms like Azure Kubernetes Service (AKS) that can host applications for multiple business units. Unless unusual circumstances constrain application landing zone subscriptions, they typically include resources from only a single workload or logical application boundary, like its life cycle or criticality classification.

Workload teams communicate their workload's requirements through a formal process that the platform team establishes. The platform team generally deploys an empty subscription that's enrolled with all required governance. Then a workload architect designs a solution that works within the constraints of that application landing zone and takes advantage of shared platform features, like firewalls and cross-premises routing, when practical.

It's possible for an architect to adapt a reference architecture that isn't designed specifically with an application landing zone in mind. But Microsoft Learn also contains application and data platform guidance for workload teams that specifically addresses application landing zone contexts. Make the platform teams aware of the guidance that's available to the workload teams so that the platform team can anticipate the workload types and characteristics that might be in the organization.

| Application landing zone architecture | Description |
| --- | --- |
| [Azure App Service environment](/azure/cloud-adoption-framework/scenarios/app-platform/app-services/landing-zone-accelerator) | Proven recommendations and considerations across both multitenant and App Service environment use cases with a reference implementation. |
| [Azure API Management](../example-scenario/integration/app-gateway-internal-api-management-function.yml) | Proven recommendations and considerations for how to deploy an internal API Management instance as part of a reference implementation. The scenario uses Azure Application Gateway to help provide secure ingress control and uses Azure Functions as the back end. |
| [Azure Arc for hybrid and multicloud scenarios](/azure/cloud-adoption-framework/scenarios/hybrid/enterprise-scale-landing-zone) | Guidance for servers, Kubernetes, and Azure SQL Managed Instance enabled by Azure Arc. |
| [Azure Container Apps](/azure/cloud-adoption-framework/scenarios/app-platform/container-apps/landing-zone-accelerator) | Guidance that outlines the strategic design path and defines the target technical state for deploying Container Apps. A dedicated workload team owns and operates this platform. |
| [Azure Data Factory](../databases/architecture/azure-data-factory-on-azure-landing-zones-baseline.yml) | Guidance about how to host a [medallion lakehouse](/azure/databricks/lakehouse/medallion) within an application landing zone. |
| [Microsoft Foundry chat workload](../ai-ml/architecture/baseline-microsoft-foundry-landing-zone.yml) | Guidance about how to integrate a typical [Foundry chat architecture](../ai-ml/architecture/baseline-microsoft-foundry-chat.yml) within an application landing zone while using centralized platform landing zone resources for shared services, governance, and cost efficiency. It provides guidance for workload teams about infrastructure and agent deployment and management.|
| [AKS](/azure/cloud-adoption-framework/scenarios/app-platform/aks/landing-zone-accelerator) | Guidance and related IaC templates that represent the strategic design path and target technical state for an AKS deployment that runs within an application landing zone. |
| [Azure Red Hat OpenShift](/azure/cloud-adoption-framework/scenarios/app-platform/azure-red-hat-openshift/landing-zone-accelerator) | An open-source collection of Terraform templates that represent an optimal Azure Red Hat OpenShift deployment that includes Azure and Red Hat resources. |
| [Azure Virtual Desktop](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/enterprise-scale-landing-zone) | Azure Resource Manager, Bicep, and Terraform templates that you should reference when you design Azure Virtual Desktop deployments. These templates include the creation of host pools, networking, storage, monitoring, and add-ons. |
| [Azure Virtual Machines](../virtual-machines/baseline-landing-zone.yml) |  An architecture that extends the guidance from the [Virtual Machines baseline architecture](../virtual-machines/baseline.yml) to an application landing zone. It provides guidance about subscription setup, patch compliance, and other organizational governance concerns. |
| [Azure VMware Solution](/azure/cloud-adoption-framework/scenarios/azure-vmware/enterprise-scale-landing-zone) | Resource Manager, Bicep, and Terraform templates that you can use to help design Azure VMware Solution deployments. These deployments include Azure VMware Solution private cloud, jump box, networking, monitoring, and add-ons. |
| [Citrix on Azure](/azure/cloud-adoption-framework/scenarios/azure-virtual-desktop/landing-zone-citrix/citrix-enterprise-scale-landing-zone) | Design guidelines for the Cloud Adoption Framework for Citrix Cloud in an Azure enterprise-scale landing zone that includes many design areas. |
| [Red Hat Enterprise Linux (RHEL) on Azure](/azure/cloud-adoption-framework/scenarios/app-platform/azure-red-hat-enterprise-linux/landing-zone-accelerator) | An open-source collection of architectural guidance and reference implementation recommendations that you can use to design RHEL-based workloads on Azure. |
| [High performance compute (HPC) workloads](/azure/cloud-adoption-framework/scenarios/azure-hpc/azure-hpc-landing-zone-accelerator) | An end-to-end HPC cluster solution in Azure that uses tools like Terraform, Ansible, and Packer. It addresses Azure landing zone best practices, which include identity implementation, jump box access, and autoscaling. |
| [Mission-critical workloads](../reference-architectures/containers/aks-mission-critical/mission-critical-intro.yml) | Addresses how to design a mission-critical workload to run within an application landing zone. |
| [SAP workloads](/azure/cloud-adoption-framework/scenarios/sap/enterprise-scale-landing-zone) | Provides guidance and recommendations for SAP workloads that align with Azure landing zone best practices. Provides recommendations for how to create infrastructure components like compute, networking, storage, monitoring, and the build of SAP systems. |

Workloads often consist of different technologies and classifications. We recommend that you review related reference materials for all the technologies in your workload. For example, it's essential to understand the guidance from Foundry Models chat and API Management to determine whether your generative AI scenario can benefit from incorporating an API gateway.

## Next step

- [Design your subscription vending solution](./subscription-vending.md)
