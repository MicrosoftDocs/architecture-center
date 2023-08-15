---
title: Deploy Azure landing zones
description: Learn about the deployment options for platform and application landing zones in Azure.
author: robbagby
categories:
  - management-and-governance
  - devops
  - networking
  - security
ms.author: robbag
ms.date: 09/20/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: guide
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
> For more information about platform versus application landing zones definitions, see [What is an Azure landing zone?](/azure/cloud-adoption-framework/ready/landing-zone/#platform-vs-application-landing-zones) in the Cloud Adoption Framework for Azure documentation.

This article covers common roles and responsibilities for differing cloud operating models. It also lists deployment options for platform and application landing zones.

## Cloud operating model roles and responsibilities

The Cloud Adoption Framework describes four [common cloud operating models](/azure/cloud-adoption-framework/operating-model/compare). [Azure identity and access for landing zones](/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones#rbac-recommendations) recommends five role definitions (Roles) to consider if your organization's cloud operating model requires customized role-based access control. If your organization has more decentralized operations, the Azure [built-in roles](/azure/role-based-access-control/role-definitions-list) might be sufficient.

The following table outlines the key roles for each of the cloud operating models.

| Role | Decentralized operations | Centralized operations | Enterprise operations | Distributed operations |
| --- | --- | --- | --- | --- |
| Azure platform owner (such as the built-in Owner role) | [Workload team](/azure/cloud-adoption-framework/organize/cloud-adoption) | [Central cloud strategy](/azure/cloud-adoption-framework/organize/cloud-strategy) | [Enterprise architect](/azure/cloud-adoption-framework/organize/cloud-strategy) in [Cloud Center of Excellence (CCoE)](/azure/cloud-adoption-framework/organize/cloud-center-of-excellence) | Based on portfolio analysis. See [Business alignment](/azure/cloud-adoption-framework/manage/considerations/business-alignment) and [Business commitments](/azure/cloud-adoption-framework/manage/considerations/commitment). |
| Network management (NetOps) | [Workload team](/azure/cloud-adoption-framework/organize/cloud-adoption) | [Central IT](/azure/cloud-adoption-framework/organize/central-it) | [Central Networking](/azure/cloud-adoption-framework/organize/central-it) in [CCoE](/azure/cloud-adoption-framework/organize/cloud-center-of-excellence) | [Central Networking for each distributed team](/azure/cloud-adoption-framework/organize/central-it) + [CCoE](/azure/cloud-adoption-framework/organize/cloud-center-of-excellence). |
| Security operations (SecOps) | [Workload team](/azure/cloud-adoption-framework/organize/cloud-adoption) | [Security operations center (SOC)](/azure/cloud-adoption-framework/organize/cloud-security-operations-center) | [CCoE](/azure/cloud-adoption-framework/organize/cloud-center-of-excellence) + [SOC](/azure/cloud-adoption-framework/organize/cloud-security-operations-center) | Mixed. See [Define a security strategy](/azure/cloud-adoption-framework/strategy/define-security-strategy). |
| Subscription owner | [Workload team](/azure/cloud-adoption-framework/organize/cloud-adoption) | [Central IT](/azure/cloud-adoption-framework/organize/central-it) | [Central IT](/azure/cloud-adoption-framework/organize/central-it) + [Application Owners](/azure/cloud-adoption-framework/organize/central-it) | [CCoE](/azure/cloud-adoption-framework/organize/cloud-center-of-excellence) + [Application Owners](/azure/cloud-adoption-framework/organize/central-it). |
| Application owners (DevOps, AppOps) | [Workload team](/azure/cloud-adoption-framework/organize/cloud-adoption) | [Workload team](/azure/cloud-adoption-framework/organize/cloud-adoption) | [Central IT](/azure/cloud-adoption-framework/organize/central-it) + [Application Owners](/azure/cloud-adoption-framework/organize/central-it) | [CCoE](/azure/cloud-adoption-framework/organize/cloud-center-of-excellence) + [Application Owners](/azure/cloud-adoption-framework/organize/central-it). |

## Platform

The following options provide an opinionated approach to deploy and operate the [Azure landing zone conceptual architecture](/azure/cloud-adoption-framework/ready/landing-zone#azure-landing-zone-conceptual-architecture) as detailed in the Cloud Adoption Framework. Depending upon customizations, the resulting architecture might not be the same for all the options listed here. The differences between the options are how you deploy the architecture. They use differing technologies, take different approaches, and are customized differently.

| Deployment option | Description |
| --- | ---|
| [Azure landing zone Portal accelerator](/azure/cloud-adoption-framework/ready/landing-zone/#azure-landing-zone-accelerator) | An Azure portal-based deployment provides a full implementation of the conceptual architecture, along with opinionated configurations for key components, such as management groups and policies. |
| [Azure landing zone Terraform accelerator](terraform/landing-zone-terraform.md) | This accelerator provides an orchestrator module and also allows you to deploy each capability individually or in part. |
| [Azure landing zone Bicep accelerator](bicep/landing-zone-bicep.md) | A modular accelerator where each module encapsulates a core capability of the [Azure landing zone conceptual architecture](/azure/cloud-adoption-framework/ready/landing-zone#azure-landing-zone-conceptual-architecture). While the modules can be deployed individually, the design proposes the use of orchestrator modules to encapsulate the complexity of deploying different topologies with the modules. |

After you deploy the landing zone, you need to plan to operate it and maintain it. For more information, see how to [keep your Azure landing zone up to date](/azure/cloud-adoption-framework/govern/resource-consistency/keep-azure-landing-zone-up-to-date).

## Subscription vending

After the platform landing zone is in place, the next step is to create and operationalize application landing zones for workload owners. Subscription democratization is a [design principle](/azure/cloud-adoption-framework/ready/landing-zone/design-principles) of Azure landing zones that uses subscriptions as units of management and scale. This approach accelerates application migrations and new application development.

[Subscription vending](/azure/cloud-adoption-framework/ready/landing-zone/design-area/subscription-vending) standardizes the process you use to request, deploy, and govern subscriptions. It enables application teams to deploy their workloads faster. To get started, see [Subscription vending implementation guidance](/azure/architecture/landing-zones/subscription-vending). Then review the following infrastructure-as-code modules. They provide flexibility to fit your implementation needs.

| Deployment option | Description |
| --- | ---|
| [Bicep subscription vending](https://github.com/Azure/bicep-lz-vending) | The subscription vending Bicep module is designed to accelerate deployment of the individual landing zones (also known as subscriptions) within an Azure Active Directory tenant on Enterprise Agreement (EA), Microsoft Customer Agreement (MCA), and Microsoft Partner Agreement (MPA) billing accounts. |
| [Terraform subscription vending](https://registry.terraform.io/modules/Azure/lz-vending/azurerm/latest) | The subscription vending Terraform module is designed to accelerate deployment of the individual landing zones (also known as subscriptions) within an Azure Active Directory tenant on EA, MCA, and MPA billing accounts |

## Application

Application landing zones are one or more subscriptions that are deployed as environments for workloads or applications. These workloads can take advantage of services deployed in platform landing zones. The application landing zones can be centrally managed applications, decentralized workloads, or technology platforms such as Azure Kubernetes Service (AKS) that host applications.

You can use the following options to deploy and manage applications or workloads in an application landing zone.

| Application | Description |
| --- | --- |
| [AKS landing zone accelerator](/azure/cloud-adoption-framework/scenarios/app-platform/aks/landing-zone-accelerator) | An open-source collection of Azure Resource Manager (ARM), Bicep, and Terraform templates that represent the strategic design path and target technical state for an AKS deployment. |
| [Azure App Service landing zone accelerator](/azure/cloud-adoption-framework/scenarios/app-platform/app-services/landing-zone-accelerator) | Proven recommendations and considerations across both multitenant and App Service environment use cases with a reference implementation for ASEv3-based deployment. |
| [Azure API Management landing zone accelerator](/azure/cloud-adoption-framework/scenarios/app-platform/api-management/landing-zone-accelerator) | Proven recommendations and considerations for deploying APIM management with a reference implementation showcasing Azure Application Gateway with an internal APIM instance-backed Azure Functions as back end. |
| [SAP on Azure landing zone accelerator](/azure/cloud-adoption-framework/scenarios/sap/enterprise-scale-landing-zone) | Terraform and Ansible templates that accelerate SAP workload deployments by using Azure landing zone best practices, including the creation of infrastructure components like compute, networking, storage, monitoring, and build of SAP systems. |
| [HPC landing zone accelerator](/azure/cloud-adoption-framework/scenarios/azure-hpc/azure-hpc-landing-zone-accelerator) | An end-to-end HPC cluster solution in Azure that uses tools like Terraform, Ansible, and Packer. It addresses Azure landing zone best practices, including implementing identity, jumpbox access, and autoscale. |
| [Azure VMware Solution landing zone accelerator](/azure/cloud-adoption-framework/scenarios/azure-vmware/enterprise-scale-landing-zone) | ARM, Bicep, and Terraform templates that accelerate VMware deployments, including Azure VMware Solution private cloud, jumpbox, networking, monitoring, and add-ons. |
| [Azure Virtual Desktop landing zone accelerator](/azure/cloud-adoption-framework/scenarios/wvd/enterprise-scale-landing-zone) | ARM, Bicep, and Terraform templates that accelerate Azure Virtual Desktop deployments, including creation of host pools, networking, storage, monitoring, and add-ons. |
| [Azure Red Hat OpenShift landing zone accelerator](/azure/cloud-adoption-framework/scenarios/app-platform/azure-red-hat-openshift/landing-zone-accelerator) | An open-source collection of Terraform templates that represent an optimal Azure Red Hat OpenShift deployment that includes Azure and Red Hat resources. |
| [Azure Arc landing zone accelerator for hybrid and multicloud](/azure/cloud-adoption-framework/scenarios/hybrid/enterprise-scale-landing-zone) | Azure Arc-enabled servers, Kubernetes, and Azure Arc-enabled SQL Managed Instance. See the Jumpstart ArcBox overview. |
| [Azure Spring Apps landing zone accelerator](/azure/cloud-adoption-framework/scenarios/app-platform/spring-apps/landing-zone-accelerator) | Azure Spring Apps landing zone accelerator is intended for an application team that builds and deploys Spring Boot applications in a typical landing enterprise zone design. As the workload owner, use architectural guidance provided in this accelerator to achieve your target technical state with confidence. |
| [Enterprise-scale landing zone for Citrix on Azure](/azure/cloud-adoption-framework/scenarios/wvd/landing-zone-citrix/citrix-enterprise-scale-landing-zone) | Design guidelines for the Cloud Adoption Framework for Citrix Cloud in an Azure enterprise-scale landing zone cover for many design areas. |
