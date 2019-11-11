---
title: Application design for DevOps
description: Describes considerations that you should take into account while doing application design to optimize for DevOps.
author: UmarMohamedUsman
ms.date: 11/01/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: cloud-design-principles
ms.custom: fasttrack-edit 
---

# Application design for DevOps

## Infrastructure as code

Infrastructure as Code (IaC) is the management of infrastructure (networks, virtual machines, load balancers, and connection topology) in a descriptive model, using the same versioning as DevOps team uses for source code. The most reliable deployment processes are automated and idempotent — that is, repeatable to produce the same results.

IaC may use a declarative (functional) approach or an imperative (procedural) approach (or a combination of both).

* [Resource Manager templates](/azure/azure-resource-manager/template-deployment-overview) or [Terraform](/azure/virtual-machines/windows/infrastructure-automation#terraform) are some examples of a declarative approach.
* [Azure PowerShell](/powershell/azure/?view=azps-2.8.0) or [Azure CLI](/cli/azure/?view=azure-cli-latest) scripts are some examples of imperative approach.

To automate infrastructure deployment, you can use [Azure DevOps Services](/azure/virtual-machines/windows/infrastructure-automation#azure-devops-services), [Jenkins](/azure/virtual-machines/windows/infrastructure-automation#jenkins), or other CI/CD solutions.

## Dependency tracking

Use Azure Resource Manager templates to define dependencies for resources that are deployed in the same template. For a given resource, there can be other resources that must exist before the resource is deployed. For example, a SQL server must exist before attempting to deploy a SQL database. You define this relationship by marking one resource as dependent on the other resource. Resource Manager evaluates the dependencies between resources, and deploys them in their dependent order.

[Define the order for deploying resources in Azure Resource Manager Templates](/azure/azure-resource-manager/resource-group-define-dependencies)

## Limits

Azure Resource Manager (ARM) enforces limits and quotas on how many resources of each type you can provision per Azure Subscription, and even per Azure Region. Some limits are a hard maximum, while others are a soft limit that can be increases upon request through a support case at no charge. When working with Virtual Machines, App Service, Storage Accounts, Databases, and other resources in Azure you can easily hit up against these limits, so it’s important to know they exist and how to work around them.

[Azure subscription and service limits, quotas, and constraints](/azure/azure-subscription-service-limits#app-service-limits)

## Tagging and resource naming

Organizing cloud-based assets in ways that aid operational management and support accounting requirements is a common challenge that faces large cloud adoption efforts. By applying well-defined naming and metadata tagging conventions to cloud-hosted resources, IT staff can quickly find and manage resources. Well-defined names and tags also help to align cloud usage costs with business teams by using chargeback and showback accounting mechanisms.

The Azure Architecture Center's [naming rules and restrictions for Azure resources](/azure/architecture/best-practices/resource-naming) guidance provides general recommendations and platform limitations.

[Recommended naming and tagging conventions](/azure/cloud-adoption-framework/ready/azure-best-practices/naming-and-tagging)

## Workload isolation

The term _workload_ is typically defined as an arbitrary unit of functionality, such as an application or service. In the cloud a workload not only encompasses all the artifacts, but it also includes the cloud resources as well. This enables you to define a workload in terms of code artifacts and the necessary cloud resources, thus further enabling you to isolate workloads. You can isolate workloads by the way resources are organized, by network topology, or by other attributes. A _basic workload_ is typically defined as a single web application or a virtual network (VNet) with virtual machine (VM).

The goal of workload isolation is to associate a workload's specific resources to a team, so that the team can independently manage all aspects of those resources. This isolation enables DevOps to perform continuous integration and continuous delivery (CI/CD).

[Deploy a basic workload in Azure](/azure/cloud-adoption-framework/infrastructure/virtual-machines/basic-workload)

## Orchestration system

Because of their small size and application orientation, containers are well suited for agile delivery environments and microservice-based architectures. The task of automating and managing a large number of containers and how they interact is known as orchestration. While there are multiple container orchestrators available, it's critical to select the right container orchestrator based on your workload requirements, the team's skill set, timeline to ramp up and support production workload. One of the popular container orchestration systems is [Kubernetes](https://azure.microsoft.com/topic/what-is-kubernetes/) and Azure provides a managed kubernetes cluster using [Azure Kubernetes Service (AKS) service](/azure/aks/intro-kubernetes)

## Containerization

Containers make it easy for you to continuously build and deploy applications. By orchestrating the deployment of those containers using Azure Kubernetes Service, you can achieve replicable, manageable clusters of containers.

By setting up a continuous build to produce your container images and orchestration, Azure DevOps increases the speed and reliability of your deployment.

[CI/CD for Containers](https://azure.microsoft.com/solutions/architecture/cicd-for-containers/)