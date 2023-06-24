---
title: Deploy Azure landing zones
description: Deployment options for platform and application landing zones in Azure.
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

This article discusses the options for deploying both platform and application landing zones. Platform landing zones provide centralized services used by workloads, whereas application landing zones are environments deployed for the workloads.

> [!IMPORTANT]
> For more information about platform vs. application landing zones definitions, see the article [What is an Azure landing zone?](/azure/cloud-adoption-framework/ready/landing-zone/#platform-vs-application-landing-zones) in the Cloud Adoption Framework (CAF) documentation.

The article covers typical roles and responsibilities for different cloud operating models. It continues by listing deployment options for platform and application landing zones.

## Cloud operating model roles and responsibilities

The Cloud Adoption Framework describes four [common cloud operating models](/azure/cloud-adoption-framework/operating-model/compare). The [Azure identity and access for landing zones](/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones#rbac-recommendations) recommends five role definitions (Roles) you should consider if your organization's cloud operating model requires customized Role Based Access Control (RBAC). If your organization has more decentralized operations, the Azure [built-in roles](/azure/role-based-access-control/role-definitions-list) may be sufficient.

The table below outlines the critical roles of each cloud operating model.

| Role | Decentralized operations | Centralized operations | Enterprise operations | Distributed operations |
| --- | --- | --- | --- | --- |
| Azure platform owner (such as the built-in Owner role) | [Workload team](/azure/cloud-adoption-framework/organize/cloud-adoption) | [Central cloud strategy](/azure/cloud-adoption-framework/organize/cloud-strategy) | [Enterprise architect](/azure/cloud-adoption-framework/organize/cloud-strategy) in [CCoE](/azure/cloud-adoption-framework/organize/cloud-center-of-excellence)  | Based on portfolio analysis - see [Business alignment](/azure/cloud-adoption-framework/manage/considerations/business-alignment) and [Business commitments](/azure/cloud-adoption-framework/manage/considerations/commitment) |
| Network management (NetOps) | [Workload team](/azure/cloud-adoption-framework/organize/cloud-adoption) | [Central IT](/azure/cloud-adoption-framework/organize/central-it) | [Central Networking](/azure/cloud-adoption-framework/organize/central-it) in [CCoE](/azure/cloud-adoption-framework/organize/cloud-center-of-excellence) | [Central Networking for each distributed team](/azure/cloud-adoption-framework/organize/central-it) + [CCoE](/azure/cloud-adoption-framework/organize/cloud-center-of-excellence) |
| Security operations (SecOps) | [Workload team](/azure/cloud-adoption-framework/organize/cloud-adoption) | [Security operations center (SOC)](/azure/cloud-adoption-framework/organize/cloud-security-operations-center) | [CCoE](/azure/cloud-adoption-framework/organize/cloud-center-of-excellence) + [SOC](/azure/cloud-adoption-framework/organize/cloud-security-operations-center) | Mixed - see: [Define a security strategy](/azure/cloud-adoption-framework/strategy/define-security-strategy) |
| Subscription owner | [Workload team](/azure/cloud-adoption-framework/organize/cloud-adoption) | [Central IT](/azure/cloud-adoption-framework/organize/central-it) | [Central IT](/azure/cloud-adoption-framework/organize/central-it) + [Application Owners](/azure/cloud-adoption-framework/organize/central-it) | [CCoE](/azure/cloud-adoption-framework/organize/cloud-center-of-excellence) + [Application Owners](/azure/cloud-adoption-framework/organize/central-it) |
| Application owners (DevOps, AppOps) | [Workload team](/azure/cloud-adoption-framework/organize/cloud-adoption) | [Workload team](/azure/cloud-adoption-framework/organize/cloud-adoption) | [Central IT](/azure/cloud-adoption-framework/organize/central-it) + [Application Owners](/azure/cloud-adoption-framework/organize/central-it) | [CCoE](/azure/cloud-adoption-framework/organize/cloud-center-of-excellence) + [Application Owners](/azure/cloud-adoption-framework/organize/central-it) |

## Platform

The options below provide an opinionated approach to deploy and operate the [Azure landing zone conceptual architecture](/azure/cloud-adoption-framework/ready/landing-zone#azure-landing-zone-conceptual-architecture) as detailed in the Cloud Adoption Framework (CAF). It's important to note that, depending upon customizations, the resulting architecture might not be the same for all the options listed below. The differences between the options are how you deploy the architecture. They use different technologies, take different approaches and are customized differently.

| Deployment option | Description |
| --- | ---|
| [Azure landing zone Portal accelerator](/azure/cloud-adoption-framework/ready/landing-zone/#azure-landing-zone-accelerator) | An Azure portal-based deployment that provides a full implementation of the conceptual architecture, along with opinionated configurations for key components such as management groups and policies. |
| [Azure landing zone Terraform accelerator](terraform/landing-zone-terraform.md) | This accelerator provides an orchestrator module but allows you to deploy each capability individually or in part. |
| [Azure landing zone Bicep accelerator](bicep/landing-zone-bicep.md)  | A modular accelerator where each module encapsulates a core capability of the [Azure landing zone conceptual architecture](/azure/cloud-adoption-framework/ready/landing-zone#azure-landing-zone-conceptual-architecture). While the modules can be deployed individually, the design proposes the use of orchestrator modules to encapsulate the complexity of deploying different topologies with the modules. |

In addition, after deploying the landing zone, you will need to plan to operate and maintain it.  Review the guidance on how to [Keep your Azure landing zone up to date](/azure/cloud-adoption-framework/govern/resource-consistency/keep-azure-landing-zone-up-to-date).

## Subscription Vending

Once the platform landing zone is in place, the next step is to create and operationalize application landing zones for workload owners. Subscription democratization is a [design principle](/azure/cloud-adoption-framework/ready/landing-zone/design-principles) of Azure landing zones that use subscriptions as units of management and scale. This approach accelerates application migrations and new application development.

[Subscription vending](/azure/cloud-adoption-framework/ready/landing-zone/design-area/subscription-vending) standardizes the requesting, deploying, and governing subscriptions, enabling application teams to deploy their workloads faster. To get started, see [subscription vending implementation guidance](/azure/architecture/landing-zones/subscription-vending), then review the following infrastructure-as-code modules. They provide flexibility to fit your implementation needs.

| Deployment option | Description |
| --- | ---|
| [Bicep Subscription Vending](https://github.com/Azure/bicep-lz-vending) | The Subscription Vending Bicep module is designed to accelerate deployment of the individual landing zones (aka Subscriptions) within an Azure Active Directory Tenant on EA, MCA & MPA billing accounts. |
| [Terraform Subscription Vending](https://registry.terraform.io/modules/Azure/lz-vending/azurerm/latest) | The Subscription Vending Terraform module is designed to accelerate deployment of the individual landing zones (aka Subscriptions) within an Azure Active Directory Tenant on EA, MCA & MPA billing accounts |

## Application

Application landing zones are one or more subscriptions deployed as environments for workloads or applications. These workloads can take advantage of services deployed in platform landing zones. The application landing zones can be centrally managed applications, decentralized workloads, or technology platforms such as Azure Kubernetes Service that host applications.

You can use the options below to deploy and manage applications or workloads in an application landing zone.

| Application | Description |
| --- | --- |
| [AKS landing zone accelerator](/azure/cloud-adoption-framework/scenarios/app-platform/aks/landing-zone-accelerator) | An open-source collection of ARM, Bicep, and Terraform templates that represent the strategic design path and target technical state for an Azure Kubernetes Service (AKS) deployment. |
| [Azure App Service landing zone accelerator](/azure/cloud-adoption-framework/scenarios/app-platform/app-services/landing-zone-accelerator) | Proven recommendations and considerations across both multi-tenant and App Service Environment use cases with a reference implementation for ASEv3-based deployment  |
| [Azure API Management landing zone accelerator](/azure/cloud-adoption-framework/scenarios/app-platform/api-management/landing-zone-accelerator) | Proven recommendations and considerations for deploying APIM management with a reference implementation showcasing App Gateway with internal APIM instance-backed Azure Functions as backend. |
| [SAP on Azure landing zone accelerator](/azure/cloud-adoption-framework/scenarios/sap/enterprise-scale-landing-zone) | Terraform and Ansible templates that accelerate SAP workload deployments using Azure Landing Zone best practices, including the creation of Infrastructure components like Compute, Networking, Storage, Monitoring & build of SAP systems. |
| [HPC landing zone accelerator](/azure/cloud-adoption-framework/scenarios/azure-hpc/azure-hpc-landing-zone-accelerator) | An end-to-end HPC cluster solution in Azure using tools like Terraform, Ansible, and Packer. It addresses Azure Landing Zone best practices, including implementing identity, Jump-box access, and autoscale. |
| [Azure VMware Solution landing zone accelerator](/azure/cloud-adoption-framework/scenarios/azure-vmware/enterprise-scale-landing-zone) | ARM, Bicep, and Terraform templates that accelerate VMware deployments, including AVS private cloud, jump box, networking, monitoring and add-ons. |
| [Azure Virtual Desktop Landing Zone Accelerator](/azure/cloud-adoption-framework/scenarios/wvd/enterprise-scale-landing-zone) | ARM, Bicep, and Terraform templates that accelerate Azure Virtual Desktop deployments, including the creation of host pools, networking, storage, monitoring and add-ons. |
| [Azure Red Hat OpenShift landing zone accelerator](/azure/cloud-adoption-framework/scenarios/app-platform/azure-red-hat-openshift/landing-zone-accelerator) | An open source collection of Terraform templates that represent an optimal Azure Red Hat OpenShift (ARO) deployment that is comprised of both Azure and Red Hat resources. |
| [Azure Arc landing zone accelerator for hybrid and multicloud](/azure/cloud-adoption-framework/scenarios/hybrid/enterprise-scale-landing-zone) | Arc enabled Servers, Kubernetes, and Arc-enabled SQL Managed Instance see the Jumpstart ArcBox overview. |
| [Azure Spring Apps landing zone accelerator](/azure/cloud-adoption-framework/scenarios/app-platform/spring-apps/landing-zone-accelerator) | Azure Spring Apps landing zone accelerator is intended for an application team that is building and deploying Spring Boot applications in a typical landing enterprise zone design. As the workload owner, use the architectural guidance provided in this accelerator to achieve your target technical state. |
| [Enterprise-scale landing zone for Citrix on Azure](/azure/cloud-adoption-framework/scenarios/wvd/landing-zone-citrix/citrix-enterprise-scale-landing-zone) | Design guidelines for the Cloud Adoption Framework for Citrix Cloud in an Azure enterprise-scale landing zone cover for several design areas. |

