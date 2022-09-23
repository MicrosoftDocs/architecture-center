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

This article discusses the options available to you to deploy both platform and application landing zones. Platform landing zones provide centralized services used by workloads whereas application landing zones are environments deployed for the workloads themselves.

> [!IMPORTANT]
> For more information about platform vs. application landing zones definitions, see the article [What is an Azure landing zone?](/azure/cloud-adoption-framework/ready/landing-zone/#platform-vs-application-landing-zones) in the Cloud Adoption Framework (CAF) documentation.

The article begins by covering common roles and responsibilities for differing cloud operating models. It continues by listing deployment options for platform and application landing zones.

## Cloud operating model roles and responsibilities

The Cloud Adoption Framework describes four [common cloud operating models](/azure/cloud-adoption-framework/operating-model/compare). [Azure identity and access for landing zones](/azure/cloud-adoption-framework/ready/landing-zone/design-area/identity-access-landing-zones#rbac-recommendations) recommends five role definitions (roles) you should consider when designing custom roles for your access management solution for landing zone deployments.

The table below outlines the key roles for each of the cloud operating models.

| Persona | Decentralized operations | Centralized operations | Enterprise operations | Distributed operations |
| --- | --- | --- | --- | --- |
| Azure platform owner (such as the built-in Owner role) | - | - | - | - |
| Network management (NetOps) | - | - | - | - |
| Security operations (SecOps) | - | - | - | - |
| Subscription owner | - | - | - | - |
| Application owners (DevOps, AppOps) | - | - | - | - |

## Platform

You can use the options below to deploy and manage the core platform capabilities of the [Azure landing zone conceptual architecture](/azure/cloud-adoption-framework/ready/landing-zone/#azure-landing-zone-conceptual-architecture) as detailed in the Cloud Adoption Framework (CAF). It's important to note that, depending upon customizations, the resulting architecture will be the same for all the options listed below. The differences between the options are how you deploy the architecture. They use differing technologies, take different approaches and are customized differently.

| Deployment option | Description |
| --- | ---|
| [Terraform module](terraform/landing-zone-terraform.md) |  The terraform solution provides an opinionated approach to deploy and operate the [Azure landing zone conceptual architecture](/azure/cloud-adoption-framework/ready/landing-zone#azure-landing-zone-conceptual-architecture). This solution provides an orchestrator module, but also allows you to deploy each capability individually or in part.|
| [Bicep modules](bicep/landing-zone-bicep.md)  | A modularized solution written in Azure Bicep. Each module encapsulates a core capability of the [Azure landing zone conceptual architecture](/azure/cloud-adoption-framework/ready/landing-zone#azure-landing-zone-conceptual-architecture). While the modules can be deployed individually, the design proposes the use of orchestrator modules to encapsulate the complexity of deploying different topologies with the modules. |

## Application

You can use the options below to deploy and manage applications or workloads in an application landing zone.

| Application | Description |
| --- | --- |
| [AKS landing zone accelerator](/azure/cloud-adoption-framework/scenarios/app-platform/aks/landing-zone-accelerator) | Build a scalable Azure Kubernetes Service (AKS) cluster. |
| [Azure App Service landing zone accelerator](/azure/cloud-adoption-framework/scenarios/app-platform/app-services/landing-zone-accelerator) | Build and deploy Azure App Service at scale. |
| [Azure API Management landing zone accelerator](/azure/cloud-adoption-framework/scenarios/app-platform/api-management/landing-zone-accelerator) | Build a scalable API Management infrastructure. |
| [SAP on Azure landing zone accelerator](/azure/cloud-adoption-framework/scenarios/sap/enterprise-scale-landing-zone) | |
| [Azure VMware Solution landing zone accelerator](/azure/cloud-adoption-framework/scenarios/azure-vmware/enterprise-scale-landing-zone) | |
| [Azure Virtual Desktop Landing Zone Accelerator](/azure/cloud-adoption-framework/scenarios/wvd/enterprise-scale-landing-zone) | |
| [Azure Red Hat OpenShift landing zone accelerator](/azure/cloud-adoption-framework/scenarios/app-platform/azure-red-hat-openshift/landing-zone-accelerator) | Accelerate deployment of Azure Red Hat OpenShift clusters. |
| [Azure Arc landing zone accelerator for hybrid and multicloud](/azure/cloud-adoption-framework/scenarios/hybrid/enterprise-scale-landing-zone) | |
