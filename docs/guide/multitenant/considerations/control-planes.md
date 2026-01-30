---
title: Considerations for Multitenant Control Planes
description: Learn about the responsibilities of control planes in multitenant solutions and how to design a control plane that meets your needs.
author: johndowns
ms.author: pnp
ms.date: 06/12/2025
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom:
 - arb-saas
---

# Considerations for multitenant control planes

A multitenant solution has multiple *planes*, and each plane has its own responsibilities. The *data plane* enables users and clients to interact with a system. The *control plane* manages higher-level tasks, like access control, provisioning, and system maintenance, across all tenants to support platform administrators' tasks.

:::image type="complex" source="media/control-planes/control-planes.png" alt-text="Diagram that shows a logical system design. A single control plane provides management across multiple tenant-specific data planes." lightbox="media/control-planes/control-planes.png" border="false":::
The diagram has several tenant data planes. A control plan spans all tenant data planes. Tenant onboarding and management takes place in the control plane. Application access takes place in the tenant data planes.
:::image-end:::

This article provides information about the responsibilities of control planes and how to design a control plane that meets your needs.

For example, consider a bookkeeping system for managing financial records. Multiple tenants store their financial records in the system. When users access the system to view and enter their financial records, they use the data plane. The data plane is likely the primary application component for your solution. Tenants typically view it as the main interface for using the system as intended.

In contrast, the control plane onboards new tenants, creates databases for each tenant, and performs other management and maintenance operations. Without a control plane, administrators must rely on manual processes. In some cases, data plane and control plane tasks become entangled, which overcomplicates solutions.

Many complex systems include a control plane. For example, the Azure control plane, [Azure Resource Manager](/azure/azure-resource-manager/management/overview), is a set of APIs, tools, and back-end components that deploy and configure Azure resources. And the [Kubernetes control plane](https://kubernetes.io/docs/concepts/overview/components/#control-plane-components) manages many tasks, like the placement of Kubernetes pods on worker nodes. Almost all software as a service (SaaS) solutions have a control plane to handle cross-tenant tasks.

When you design multitenant solutions, you need to consider control planes. The following sections describe how to scope and design a control plane.

## Responsibilities of a control plane

There's no single template for a control plane or its responsibilities. Your solution's requirements and architecture dictate what your control plane needs to do and how it works. In some multitenant solutions, the control plane has a wide range of responsibilities and is a complex system in its own right. In other multitenant solutions, the control plane has only basic responsibilities.

In general, a control plane might have many of the following core responsibilities:

- **Resource management:** It provisions and manages system resources that serve the workload, including tenant-specific resources. The control plane might [invoke and orchestrate a deployment pipeline](../approaches/deployment-configuration.md#tenant-lists-as-configuration-or-data) or run deployment operations directly.

- **Resource configuration:** It [reconfigures shared resources](#manage-shared-components) to recognize new tenants. For example, the control plane might configure network routing to ensure that incoming traffic [reaches the correct tenant's resources](map-requests.yml), or you might need to scale your resource capacity.
- **Tenant configuration:** It stores and manages the configuration of each tenant.
- **Tenant life cycle management:** It handles [tenant life cycle events](tenant-life-cycle.md), including onboarding, relocating, and offboarding tenants.
- **Telemetry:** It tracks each tenant's use of your features and the performance of the system.
- **Consumption tracking:** It [measures and aggregates each tenant's resource consumption](measure-consumption.md). Consumption metrics might inform your billing systems or support resource governance.

If you use the [fully multitenant model](tenancy-models.md#fully-multitenant-deployments) and don't deploy tenant-specific resources, a basic control plane might only track tenants and their associated metadata. For example, when a new tenant signs up to your service, the control plane could update the appropriate records in a database so that the rest of the system can serve the new tenant's requests.

In contrast, if your solution uses a deployment model that requires tenant-specific infrastructure, like the [automated single-tenant model](tenancy-models.md#automated-single-tenant-deployments), your control plane might have more responsibilities. It might need to deploy or reconfigure Azure infrastructure when you onboard a new tenant. In this scenario, the control plane likely interacts with the control planes for other tools, like Resource Manager or the Kubernetes control plane.

Advanced control planes might take on more responsibilities:

- **Automated maintenance operations:** It performs common maintenance operations, including deleting or archiving old data, creating and managing database indexes, and rotating secrets and cryptographic certificates.

- **Tenant placement:** It allocates tenants to existing deployments or stamps based on criteria such as stamp usage targets, tenant requirements, and [bin-packing strategies](../approaches/resource-organization.md#bin-packing).
- **Tenant rebalancing:** It rebalances existing tenants across deployment stamps as their usage changes.
- **Customer activity tracking:** It integrates with external customer management solutions, like Dynamics 365, to track customer activity. 

## Scope a control plane

Carefully consider how much effort to spend on building a control plane for your solution. A control plane doesn't directly provide immediate customer value, which can make it difficult to justify engineering effort on designing and building a high-quality control plane. However, as your system grows and scales, you increasingly need automated management and operations to keep up with your growth.

In certain situations, you might not need a full control plane. This approach might work if your system has fewer than 10 tenants. Your team can take on the control plane's responsibilities and use manual operations and processes to onboard and manage tenants. However, you should still have a process and maintain a central location to track your tenants and their configurations.

> [!TIP]
> If you don't create a full control plane, you should still apply a systematic approach to your management procedures:
>
> - Document your processes thoroughly.
> - Create and reuse scripts for your management operations when possible.
> 
> If you need to automate processes in the future, your documentation and scripts can form the basis of your control plane.

As you grow beyond a few tenants, you can benefit from tracking each tenant and applying monitoring across your fleet of resources and tenants. You might notice that your team spends an increasing amount of time and effort on tenant management. Or you might notice bugs or operational problems because of inconsistencies in how team members perform management tasks. If these situations occur, consider building a more comprehensive control plane to take on these responsibilities.

> [!NOTE]
> If you provide self-service tenant management, you need a control plane early in your journey. You might choose to create a basic control plane and automate only some of the most commonly used functionality. You can progressively add more capabilities over time.

## Design a control plane

After you determine the requirements and the scope of your control plane, you need to design and architect it. A control plane is an important component, and it deserves the same level of planning as any other part of your architecture.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

A control plane functions as its own system, so you should consider all five pillars of the [Well-Architected Framework](/azure/well-architected/) when you design one. The following sections highlight particular areas to focus on.

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

Control planes often serve as mission-critical components. You must plan the appropriate level of resiliency and reliability that your control plane needs.

Consider the impact of a control plane outage. In extreme cases, an outage might make your entire solution unavailable. Even if your control plane isn't a single point of failure, an outage might cause the following problems:

- Your system can't onboard new tenants, which might affect your sales and business growth.

- Your system can't manage existing tenants, which results in more calls to your support team.
- You can't measure the consumption of tenants or bill them for their usage, which results in lost revenue.
- You can't disable or reconfigure a tenant in response to a security incident.
- Maintenance debt accumulates, which results in long-term damage to the system. For example, if your solution requires nightly cleanup of old data, your disks could get full or your performance could degrade.

Define [service-level objectives](/azure/well-architected/reliability/metrics) for your control plane, including availability targets, the recovery time objective (RTO), and the recovery point objective (RPO). The objectives that you set for your control plane might differ from objectives that you offer your customers.

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

Control planes are often highly privileged systems. Security problems within a control plane can have catastrophic consequences. Depending on its design and functionality, a control plane might be vulnerable to many different types of attacks, including the following types:

- **Unauthorized access to secrets:** A control plane might have access to keys and secrets for all tenants. An attacker who has access to your control plane could gain access to any tenant's data or resources.

- **Abuse of deployment capabilities:** A control plane can often deploy new resources to Azure. Attackers could exploit your control plane to deploy their own resources into your subscriptions and potentially incur extensive charges.
- **Denial of service:** If an attacker successfully disables your control plane, immediate and long-term damage to your system and business can occur. For potential consequences of control plane downtime, see [Reliability](#reliability).

When you design and implement a control plane, you must follow security best practices and create a comprehensive threat model. This model should identify and mitigate potential threats and security problems in your solution.

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

A control plane is a critical component, so you should carefully consider how you deploy and operate it in production.

Like other parts of your solution, you should deploy nonproduction instances of your control plane so that you can thoroughly test their functionality. If your control plane performs deployment operations, consider how your nonproduction control planes interact with your Azure environment and which Azure subscription to deploy nonproduction resources to. Plan how to clean up test resources quickly so that they don't accumulate charges accidentally.

Also plan how to govern your team's access to your control plane. Grant only the permissions that team members need to perform their duties. This approach helps prevent security incidents and reduce the effect of accidental misconfiguration.

## Components

There's no single template for building a control plane. The components that you design and build depend on your requirements. Most control planes consist of APIs and background worker components. In some solutions, a control plane also includes a user interface, which your team or even your customers might use.

### Isolate your control plane from tenant workloads

You should separate your control plane's resources from resources that serve your tenants' data planes. For example, use separate database servers, application servers, and other components. Keep control plane resources in a dedicated Azure resource group, separate from tenant-specific resources.

Control plane isolation provides the following advantages:

- You can configure scaling separately. For example, your control plane might have consistent resource requirements, and your tenants' resources might scale elastically depending on their needs.

- A clear separation creates a [bulkhead](../../../patterns/bulkhead.yml) between your control planes and data planes, which helps prevent [noisy neighbor problems](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml) from spreading across your solution.
- Control planes are typically highly privileged systems that have high levels of access. Control plane isolation reduces the likelihood of a security vulnerability allowing attackers to elevate their permissions across your entire system.
- You can deploy separate networking and firewall configurations. Data planes and control planes usually require different types of network access.

## Orchestrate sequences of long-running operations

Control planes often perform long-running operations that require coordination between multiple systems. These operations can also have complex failure modes, so you must choose technologies that support long-running operations or workflows.

For example, when you onboard a new tenant, your control plane might run the following actions in sequence:

1. **Deploy a new database.** This Azure deployment operation might take several minutes to complete.

1. **Update your tenant metadata catalog.** This action might involve running a command against an Azure SQL database.
1. **Send a welcome email to the new tenant.** This action invokes a non-Microsoft API to send the email.
1. **Update your billing system to prepare to invoice the new tenant.** This action invokes a non-Microsoft API that occasionally fails.
1. **Update your customer relationship management (CRM) system to track the new tenant.** This action invokes a non-Microsoft API.

If any step in the sequence fails, consider how to respond:

- Retry the failed operation. For example, if your Azure SQL command in step 2 fails with a transient error, you could retry it.

- Continue to the next step. For example, you might decide that you can allow the update to your billing system to fail because your sales team can manually add the customer later.
- Abandon the workflow and trigger a manual recovery process.

Also consider the user experience for each failure scenario.

## Manage shared components

A control plane needs to recognize any components that are shared rather than dedicated to specific tenants. Some components might be shared among all tenants within a stamp. Other components might be shared among all stamps in a region, or even shared globally across all regions and stamps. When you onboard, reconfigure, or offboard a tenant, your control plane needs to know how to handle these shared components.

Some shared components require reconfiguration when tenants are added or removed. For example, suppose you have a globally shared Azure Front Door profile. If you add a tenant that has a custom domain name, your control plane might need to update the profile's configuration to route requests for that domain name to the correct application. Similarly, when a tenant is offboarded, your control plane might need to remove the custom domain name from the Azure Front Door profile to avoid [subdomain takeover attacks](domain-names.md#dangling-dns-and-subdomain-takeover-attacks).

Shared components might have complex scaling rules that your control plane needs to follow. For example, if you use a [bin-packing](../approaches/resource-organization.md#bin-packing) approach to deploy your tenants' databases, the control plane must assign each new database to an Azure SQL elastic pool.

You might determine that you need to increase the resources allocated to your pool for every tenth database that you add. When you add or remove a tenant, your control plane needs to re-evaluate the pool's configuration and decide whether to change the pool's resources. When you reach the maximum number of databases that you can assign to a single elastic pool, you need to create a new pool and use that pool for new tenant databases. Your control plane must manage each of these shared components, including scaling and reconfiguring them when changes occur.

When your control plane manages shared components, it's important to be aware of race conditions, which can occur when multiple operations happen in parallel. For example, if you onboard a new tenant at the same time that you offboard a different tenant, you need to ensure that your ultimate end state is consistent and meets your scaling requirements.

## Use multiple control planes

In a complex environment, you might need to use multiple control planes that manage different areas. Many multitenant solutions follow the [Deployment Stamps pattern](../../../patterns/deployment-stamp.yml) and shard tenants across multiple stamps. In this pattern, you might create separate control planes for global and stamp responsibilities.

> [!TIP]
> Coordinating across multiple control planes adds complexity, so try to minimize the number of control planes that you build. Most solutions need only one control plane.

### Global control planes

A global control plane typically handles the overall management and tracking of tenants. A global control plane can have the following responsibilities:

- **Tenant placement:** The global control plane determines which stamp a tenant should use. It might make this determination based on factors like the tenant's region, each stamp's capacity usage, and the tenant's service-level requirements.

- **Tenant onboarding and life cycle management:** These responsibilities include tracking all tenants across deployments.

### Stamp control planes

Each deployment stamp includes its own stamp control plane, which manages the tenants and resources allocated to that stamp. A stamp control plane can have the following responsibilities:

- **Tenant resource provisioning:** It creates and manages tenant-specific resources within the stamp, like databases and storage containers.

- **Shared resource management:** It monitors the consumption of [shared resources](#manage-shared-components) and deploys new instances when they approach their maximum capacity.
- **Maintenance operations:** It handles tasks within the stamp, like database index management and cleanup operations.

Each stamp's control plane coordinates with the global control plane. For example, if a new tenant signs up, the global control plane might initially select a stamp for the tenant's resources. Then the global control plane prompts the stamp's control plane to create the necessary resources for the tenant.

The following diagram shows how two control planes might coexist in a single system.

:::image type="complex" source="media/control-planes/global-stamp-control-planes.png" alt-text="Diagram that shows a logical system design. The design has a global control plane and stamp control planes." lightbox="media/control-planes/global-stamp-control-planes.png" border="false":::
The diagram has three stamps with control planes. Each stamp has three tenant data planes. A global control plane spans all three stamps. Tenant placement takes place in the global control plane. Tenant onboarding takes place in the stamp control planes. And application access takes place in the tenant data planes.
:::image-end:::

### Tenant control planes

Tenants might use a tenant-level control plane to manage their own logical or physical resources. A tenant control plane can have the following responsibilities:

- **Configuration management:** It handles tenant-specific configuration, like user access.

- **Tenant-initiated maintenance operations:** It supports operations like backing up data or downloading previous backups.
- **Update management:** It performs updates if you allow tenants to [control their own updates to their applications](updates.md).

The following diagram shows a complex system that has a global control plane, stamp control planes, and tenant control planes.

:::image type="complex" source="media/control-planes/global-stamp-tenant-control-planes.png" alt-text="Diagram that shows a logical system design. The design has a global control plane, stamp control planes, and tenant control planes." lightbox="media/control-planes/global-stamp-tenant-control-planes.png" border="false":::
The diagram has three stamps with control planes. Each stamp has three tenant data planes and three tenant control planes. A global control plane spans all three stamps. Tenant placement takes place in the global control plane. Tenant onboarding takes place in the stamp control planes. Tenant configuration takes place in the tenant control planes. And application access takes place in the tenant data planes.
:::image-end:::

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [John Downs](https://www.linkedin.com/in/john-downs/) | Principal Software Engineer, Azure Patterns & Practices

Other contributors:

- [Bohdan Cherchyk](https://www.linkedin.com/in/cherchyk) | Senior Customer Engineer, FastTrack for Azure
- [Landon Pierce](https://www.linkedin.com/in/landon-pierce/) | Customer Engineer, FastTrack for Azure
- [Daniel Scott-Raynsford](https://www.linkedin.com/in/dscottraynsford) | Partner Technology Strategist
- [Arsen Vladimirskiy](https://www.linkedin.com/in/arsenv) | Principal Customer Engineer, FastTrack for Azure

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next step

Consider how you [measure consumption](measure-consumption.md) by tenants in your solution.

## Related resources

- [Architectural considerations overview](overview.yml) 
- [Architectural approaches for control planes in multitenant solutions](../approaches/control-planes.md)
