---
title: Multitenant control planes
titleSuffix: Azure Architecture Center
description: This article describes the considerations for planning a control plane for a multitenant solution.
author: johndowns
ms.author: jodowns
ms.date: 01/09/2023
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure
categories:
  - management-and-governance
ms.category:
  - fcp
ms.custom:
  - guide
---

# Multitenant control planes

You can think about a multitenant solution as having multiple *planes*. Each plane has separate responsibilities. The *data plane* is how end users and clients interact with the system for its intended purpose. The *control plane* is the component that manages higher level aspects across all tenants such as access control, provisioning, and system maintenance: 

![Diagram showing a logical system design, with a single control plane that manages across multiple tenant-specific data planes.](media/control-planes/control-planes.png)

For example, consider a bookkeeping system for managing financial records. Multiple tenants each store their financial records in the system. When end users access the system to view and enter their financial records, they use the *data plane*. This is likely the primary application component for your solution, and your tenants probably think of it as the way to use the system for its intended purpose. The *control plane* is the component that onboards new tenants, creates databases for each tenant, and performs other management and maintenance operations. If the system didn't include a control plane, the administrators would need to run many manual processes instead. Or, the data plane and control plane responsibilities would be mixed together, overcomplicating the solution.

Many complex solutions include control planes. For example, Azure's control plane, [Azure Resource Manager](/azure/azure-resource-manager/management/overview), is a set of APIs, tools, and backend components that are responsible for deploying and configuring Azure resources. The [Kubernetes control plane](https://kubernetes.io/docs/concepts/overview/components/#control-plane-components) manages many concerns, such as the placement of Kubernetes pods on worker nodes. Almost all SaaS (software as a service) solutions have a control plane to work with cross-tenant concerns.

Control planes are critical components to consider when you design your own multitenant solutions. In this article, we discuss the the responsibilities of control planes, and how to scope and design a control plane to meet your needs.

## Responsibilities of a control plane

* There's no single template for a control plane - it depends heavily on your requirements. Some control planes have wide responsibilities, others are quite basic.
* Typically control planes have some core responsibilities, including: provisioning (and deprovisioning) resources; managing tenant configuration; and tracking tenants.
* In simple cases, a control plane might just track tenants and associated metadata, e.g. updating some database records
* In more complex multitenant solutions, it might be responsible for deploying or reconfiguring infrastructure, e.g. creating a new database or even deploying a full set of Azure resources
* Typically controls the tenant lifecycle - onboarding, billing, reconfiguration, offboarding
* Also performs regular automated maintenance operations, e.g. deleting or archiving old data, creating/managing database indexes, rotating keys
* In more complex solutions, a control plane might manage how tenants are allocated to stamps (*placement*), rebalancing stamps, and reconfiguring network traffic routing as required.
* Your solution's control plane likely needs to interact with the control planes for the services you use - e.g. ARM, AKS.
* Control planes provide observability over the tenants' state and performance.
* Interface to or be controlled by external customer management solutions (e.g. Dynamics 365).

## Multiple control planes

* Most solutions probably only need one control plane.
* In a complex environment, you might have multiple control planes, including some or all of:
  * One for global management of all tenants - e.g. onboarding new tenants.
  * One for management of each stamp - e.g. for performing maintenance operations within the stamp.
  * One for each tenant, which the tenants themselves might have access to.

![Diagram showing a logical system design, with a global control plane and stamp-based control planes.](media/control-planes/stamp-control-planes.png)

![Diagram showing a logical system design, with a global control plane, stamp-based control planes, and a control plane for each tenant.](media/control-planes/tenant-control-planes.png)

## Scope a control plane

* Important decision point is how much effort to spend on a control plane.
* When you're starting out, you might have some of the control plane responsibilities handled by manual processes, but have a system to track your tenants and their configuration.
  * If you're only going to have a small number of tenants, and your team is involved in their onboarding processes directly, then maybe you don't need it - effectively, your team can be your control plane.
  * But they might need to keep track of their tenants, and need to monitor across multiple tenants, then some sort of control plane is probably important.
  * Tip - if you decide not to create a control plane, document your processes thoroughly, and create a library of scripts that you use for your management operations. If/when you need to automate them in future, this will form the basis of your control plane and you won't need to reinvent the wheel.
* In any sort of self-service environment, you likely need a control plane early. You might choose to keep it simple and only automate some of the most commonly used functionality.

## Design a control plane

* Control plane operations are often long-running and coordinate multiple elements. For example, onboarding a new tenant might involve these steps:
    * Deploy a new database (Azure deployment operation, which might take several minutes)
    * Update a tenant catalog (SQL database command)
    * Update a CRM system to tell them about the new tenant (REST API call, which might fail)
* Ensure you use a suitable technlogy for coordinating long-running operations or workflows.
* Resiliency is critical. Think about what happens if your control plane is down. Depending on what it does, you might:
   * Be unable to onboard new tenants or manage existing tenants.
   * Accumulate maintenance issues - e.g. if your solution assumes data cleanup is done nightly and it's not, will disks fill up or performance degrade?
   * Lose access to all tenants, bringing your entire solution down, potentially globally.
* In a fully automated multitenant system, CP will invoke pipelines to run deployments - here's an example https://learn.microsoft.com/en-us/azure/architecture/guide/multitenant/approaches/deployment-configuration. Don't need to rebuild a DevOps pipeline inside the CP, but the CP could orchestrate the pipeline.
