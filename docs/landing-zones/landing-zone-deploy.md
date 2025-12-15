---
title: Deploy Azure landing zones
description: Learn about deployment options for both platform and application landing zones in Azure to help ensure governance at scale.
author: jtracey93
ms.author: jatracey
ms.date: 12/15/2025
ms.topic: concept-article
ms.subservice: architecture-guide
---

# Deploy Azure landing zones

This article describes the options available to help you deploy both a platform landing zone and application landing zones. A platform landing zone provides centralized services that workloads use. Application landing zones are environments deployed for the workloads themselves.

> [!IMPORTANT]
> For more information about definitions of the platform landing zone and its connected application landing zones, see [What is an Azure landing zone?](/azure/cloud-adoption-framework/ready/landing-zone/#platform-landing-zones-vs-application-landing-zones).

## Choose a platform landing zone approach

The following platform deployment options provide an opinionated approach to deploy and operate the [Azure landing zone reference architecture](/azure/cloud-adoption-framework/ready/landing-zone/#azure-landing-zone-architecture) as described in the Cloud Adoption Framework for Azure. The resulting architecture can vary based on the customizations, so it might not be the same for all the deployment options listed in this article. The differences between the platform deployment options are based on their use of different technologies, approaches, and customizations.

### Standard deployment options

Standard deployment options address typical enterprise Azure usage.

| Azure platform landing zone deployment option | Description | Azure public clouds | Azure sovereign clouds like US Government and 21Vianet |
| :--- | :--- | :--- | :--- |
| The Azure portal deployment | The Azure portal-based deployment provides a full implementation of the [Azure landing zone reference architecture](/azure/cloud-adoption-framework/ready/landing-zone/#azure-landing-zone-architecture) and opinionated configurations for key components, such as management groups and policies. | Supported | Not supported. <br><br> You can deploy individual resources by using the Azure portal. However, this approach doesn't provide a unified, guided experience across resources. |
| [Bicep deployment](https://aka.ms/alz/acc/bicep) | An Infrastructure as Code (IaC) deployment that uses [Azure verified modules](https://aka.ms/avm) that provides a customizable way to deploy a platform landing zone with Bicep. | Supported | Not supported. <br><br> You can use the [Bicep code](https://github.com/Azure/alz-bicep-accelerator/tree/main/templates) as a starting point to build your custom implementation following our [Azure platform landing zone](/azure/cloud-adoption-framework/ready/landing-zone/design-areas) best practices. For more information about what customizations are required to the code, see the [Azure sovereign cloud deployments](#azure-sovereign-cloud-deployments) section. |
| [Terraform deployment](https://aka.ms/alz/acc/tf) | An Infrastructure as Code (IaC) deployment that uses [Azure verified modules](https://aka.ms/avm) that provides a customizable way to deploy a platform landing zone with Terraform. | Supported | Not supported. <br><br> You can use the [Terraform code](https://github.com/Azure/alz-terraform-accelerator/tree/main/templates/platform_landing_zone) as a starting point to build your custom implementation following our [Azure platform landing zone](/azure/cloud-adoption-framework/ready/landing-zone/design-areas) best practices. For more information about what customizations are required to the code, see the [Azure sovereign cloud deployments](#azure-sovereign-cloud-deployments) section. |

You can also review the additional guidance in [implementation options for Azure landing zones](/azure/cloud-adoption-framework/ready/landing-zone/implementation-options) to help you choose the best deployment option for your organization.

#### Azure sovereign cloud deployments

The three deployment options are supported for Azure public, global, and commercial cloud offerings. If you need to deploy into other Azure clouds, such as Azure Government or Microsoft Azure operated by 21Vianet, the deployment assets need manual configuration changes by your platform team. Only the Bicep and Terraform deployment options can be modified to accommodate these changes. Consider the following cloud-specific limitations and configuration requirements:

- **Azure Policy definitions, initiatives, and assignments:** Not all Azure policies are available across all clouds, so you need to remove unsupported policies before deployment.

- **API versions for some resources:** Specific API versions might not exist in some clouds, so you need to adjust resource API versions before deployment.

- **Resource availability:** Some resources might not exist in some clouds. For example, Azure DDoS Protection plans aren't available in Azure in China. You need to remove these resources before deployment.

The [Azure landing zone architecture](/azure/cloud-adoption-framework/ready/landing-zone/#azure-landing-zone-architecture) is valid and supported in all Azure clouds. However, the deployment for that architecture isn't provided in an automated solution that works across all clouds. If you want automated deployment support for these clouds, [request the feature](https://github.com/Azure/Enterprise-Scale/issues/new?template=FEATURE_REQUEST.md).

### Variants and specializations

The [standard platform deployment options](#standard-deployment-options) meet the requirements of most, if not all, organizations across all industries and sizes. However, in some scenarios we have provided pre-tailored architectures and deployment options to help you accelerate further in deploying your platform landing zone.

The following options provide specialized platform landing zone implementations that you can use instead of the [standard deployment options](#standard-deployment-options).

| Platform landing zone variant | Description |
| :--- | :--- |
| Sovereign landing zone | The [Sovereign landing zone](https://aka.ms/sovereign/slz) is a specialized implementation of the [Azure landing zone reference architecture](/azure/cloud-adoption-framework/ready/landing-zone/#azure-landing-zone-architecture) that's designed specifically for organizations that have stringent regulatory, compliance, and data residency requirements with a focus around sovereignty. It includes tailored configurations and policies to help meet these needs while still adhering to the core design principles and design areas of Azure landing zones. |

#### Partner implementations

Partner programs such as [Azure Migrate and Modernize](/azure/cloud-adoption-framework/ready/landing-zone/partner-landing-zone#option-1---azure-migrate-and-modernize) can help you design and implement a platform landing zone that's specific to your organization's needs. Those implementations start with the [Azure landing zone reference architecture](/azure/cloud-adoption-framework/ready/landing-zone/#azure-landing-zone-architecture) and design configurations that are specific to your cloud adoption strategy, organizational topology, and desired outcomes.

#### Enterprise policy as code for policy management

[Enterprise policy as code (EPAC)](https://azure.github.io/enterprise-azure-policy-as-code/) is an alternative method to deploy, manage, and operate Azure Policy across your organization's Azure estate. You can use EPAC instead of the [standard platform options](#standard-deployment-options) to manage the policies in an Azure landing zone environment. For more information about the integration approach, see [Integrate EPAC with Azure landing zone](https://azure.github.io/enterprise-azure-policy-as-code/integrating-with-alz-overview/).

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
| [Bicep subscription vending](https://aka.ms/lz-vending/bicep) | The subscription vending Bicep modules, built upon [Azure verified modules](https://aka.ms/avm), are designed to orchestrate the deployment of the individual application landing zones. It can be deployed manually or as part of an automation process (recommended). |
| [Terraform subscription vending](https://aka.ms/lz-vending/tf) | The subscription vending Bicep modules, built upon [Azure verified modules](https://aka.ms/avm), are designed to orchestrate the deployment of the individual application landing zones. It can be deployed manually or as part of an automation process (recommended). |

## Application landing zone architectures

Application landing zones are designated areas within one or more subscriptions, specifically set up as approved destinations for resources that application teams manage for a specific workload. A workload can take advantage of services in the platform landing zone or remain isolated from those centralized resources. Use application landing zones for centrally managed applications, decentralized workloads that application teams own, and centrally managed hosting platforms such as Azure Kubernetes Service (AKS) that could host applications for multiple business units. Unless constrained by unusual circumstances, application landing zone subscriptions typically include resources from only a single workload or logical application boundary, such as its lifecycle or criticality classification.

Workload teams communicate their workload's requirements through a formal process that the platform team establishes. The platform team generally deploys an empty subscription that's enrolled with all required governance. Then a workload architect designs a solution that works within the constraints of that application landing zone and takes advantage of shared platform features, such as firewalls and cross-premises routing, when practical.

It's possible for an architect to adapt a reference architecture that isn't designed specifically with an application landing zone in mind. However, Microsoft Learn also contains application and data platform guidance for workload teams that specifically addresses application landing zone contexts. Make the platform teams aware of the guidance that's available to the workload teams so that the platform team can anticipate the workload types and characteristics that might be in the organization.

| Application landing zone architecture | Description |
| --- | --- |
| [Azure App Service environment](/azure/cloud-adoption-framework/scenarios/app-platform/app-services/landing-zone-accelerator) | Proven recommendations and considerations across both multitenant and App Service environment use cases with a reference implementation. |
| [Azure API Management](../example-scenario/integration/app-gateway-internal-api-management-function.yml) | Proven recommendations and considerations for how to deploy an internal API Management instance as part of a reference implementation. The scenario uses Azure Application Gateway to help provide secure ingress control and uses Azure Functions as the back end. |
| [Azure Arc for hybrid and multicloud scenarios](/azure/cloud-adoption-framework/scenarios/hybrid/enterprise-scale-landing-zone) | Guidance for servers, Kubernetes, and Azure SQL Managed Instance enabled by Azure Arc. |
| [Azure Container Apps](/azure/cloud-adoption-framework/scenarios/app-platform/container-apps/landing-zone-accelerator) | Guidance that outlines the strategic design path and defines the target technical state for deploying Container Apps. A dedicated workload team owns and operates this platform. |
| [Azure Data Factory](../databases/architecture/azure-data-factory-on-azure-landing-zones-baseline.yml) | Guidance about how to host a [medallion lakehouse](/azure/databricks/lakehouse/medallion) within an application landing zone. |
| [Microsoft Foundry chat workload](../ai-ml/architecture/baseline-azure-ai-foundry-landing-zone.yml) | Guidance about how to integrate a typical [Microsoft Foundry chat architecture](../ai-ml/architecture/baseline-azure-ai-foundry-chat.yml) within an application landing zone while using centralized platform landing zone resources for shared services, governance, and cost efficiency. It provides guidance for workload teams about infrastructure and agent deployment and management.|
| [AKS](/azure/cloud-adoption-framework/scenarios/app-platform/aks/landing-zone-accelerator) | Guidance and related IaC templates that represent the strategic design path and target technical state for an AKS deployment that runs within an application landing zone. |
| [Azure Red Hat OpenShift](/azure/cloud-adoption-framework/scenarios/app-platform/azure-red-hat-openshift/landing-zone-accelerator) | An open-source collection of Terraform templates that represent an optimal Azure Red Hat OpenShift deployment that includes Azure and Red Hat resources. |
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
