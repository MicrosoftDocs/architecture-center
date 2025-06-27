---
title: Considerations for Multitenant Control Planes
description: Learn about the responsibilities of control planes in multitenant solutions and how to design a control plane that meets your needs.
author: johndowns
ms.author: pnp
ms.date: 06/12/2025
ms.topic: conceptual
ms.subservice: architecture-guide
ms.custom:
 - arb-saas
---

# Considerations for multitenant control planes

A multitenant solution has multiple *planes*, and each plane has its own responsibilities. The *data plane* enables users and clients to interact with a system. The *control plane* manages higher-level tasks, like access control, provisioning, and system maintenance, across all tenants to support platform administrators' tasks.

:::image type="content" source="media/control-planes/control-planes.png" alt-text="Diagram that shows a logical system design. A single control plane provides management across multiple tenant-specific data planes." lightbox="media/control-planes/control-planes.png" border="false":::

This article provides information about the responsibilities of control planes and how to design a control plane that meets your needs.

For example, consider a bookkeeping system for managing financial records. Multiple tenants store their financial records in the system. When users access the system to view and enter their financial records, they use the data plane. The data plane is likely the primary application component for your solution. Your tenants probably think of it as the way to use the system for its intended purpose.

In contrast, the control plane onboards new tenants, creates databases for each tenant, and performs other management and maintenance operations. Without a control plane, administrators must rely on manual processes. In some cases, data plane and control plane tasks become entangled, which overcomplicates the solution.

Many complex systems include control planes. For example, the Azure control plane, [Azure Resource Manager](/azure/azure-resource-manager/management/overview), is a set of APIs, tools, and back-end components that deploy and configure Azure resources. And the [Kubernetes control plane](https://kubernetes.io/docs/concepts/overview/components/#control-plane-components) manages many tasks, like the placement of Kubernetes pods on worker nodes. Almost all software as a service (SaaS) solutions have a control plane to handle cross-tenant tasks.

When you design multitenant solutions, you need to consider control planes. The following sections describe how to scope and design a control plane.

## Responsibilities of a control plane

There's no single template for a control plane or its responsibilities. Your solution's requirements and architecture dictate what your control plane needs to do and how it works. In some multitenant solutions, the control plane has a wide range of responsibilities and is a complex system in its own right. In other multitenant solutions, the control plane has only basic responsibilities.

In general, a control plane might have many of the following core responsibilities:

- **Resource management:** It provisions and manages system resources that serve the workload, including tenant-specific resources. The control plane might [invoke and orchestrate a deployment pipeline](../approaches/deployment-configuration.yml#tenant-lists-as-configuration-or-data) or run deployment operations directly.

- **Resource configuration:** It [reconfigures shared resources](#manage-shared-components) to recognize new tenants. For example, the control plane might configure network routing to ensure that incoming traffic [reaches the correct tenant's resources](map-requests.yml), or you might need to scale your resource capacity.
- **Tenant configuration:** It stores and manages the configuration of each tenant.
- **Tenant lifecycle management:** It handles [tenant life cycle events](tenant-lifecycle.md), including onboarding, relocating, and offboarding tenants.
- **Telemetry:** It tracks each tenant's use of your features and the performance of the system.
- **Consumption tracking:** It [measures and aggregates each tenant's resource consumption](measure-consumption.md). Consumption metrics might inform your billing systems or support resource governance.

If you use the [fully multitenant tenancy model](tenancy-models.yml#fully-multitenant-deployments) and don't deploy tenant-specific resources, a basic control plane might only track tenants and their associated metadata. For example, when a new tenant signs up to your service, the control plane could update the appropriate records in a database so that the rest of the system can serve the new tenant's requests.

In contrast, if your solution uses a deployment model that requires tenant-specific infrastructure, like the [automated single-tenant model](tenancy-models.yml#automated-single-tenant-deployments), your control plane might have more responsibilities. It might need to deploy or reconfigure Azure infrastructure when you onboard a new tenant. In this scenario, the control plane likely interacts with the control planes for other tools, like Azure Resource Manager or the Kubernetes control plane.

Advanced control planes might take on more responsibilities:

- **Automated maintenance operations:** It performs common maintenance operations, including deleting or archiving old data, creating and managing database indexes, and rotating secrets and cryptographic certificates.

- **Tenant placement:** It allocates tenants to existing deployments or stamps based on criteria such as stamp usage targets, tenant requirements, and [bin packing strategies](../approaches/resource-organization.yml#bin-packing).
- **Tenant rebalancing:** It rebalances existing tenants across deployment stamps as their usage changes.
- **Customer activity tracking:** It integrates with external customer management solutions, like Dynamics 365, to track customer activity. 

## Scope a control plane

Carefully consider how much effort to spend on building a control plane for your solution. A control planes doesn't directly provide immediate customer value, which can make it difficult to justify engineering effort on designing and building a high-quality control plane. However, as your system grows and scales, you increasingly need automated management and operations to keep up with your growth.

In certain situations, you might not need a full control plane. This approach might work if your system has less than 10 tenants. Your team can take on the control plane's responsibilities and use manual operations and processes to onboard and manage tenants. However, you should still have a process and maintain a central location to track your tenants and their configurations.

> [!TIP]
> If you don't create a full control plane, you should still apply a systematic approach to your management procedures:
>
> - Document your processes thoroughly.
> - Create and reuse scripts for your management operations when possible.
> 
> If you need to automate the processes in the future, your documentation and scripts can form the basis of your control plane.

As you grow beyond a few tenants, you'll likely benefit from tracking each tenant and applying monitoring across your fleet of resources and tenants. You might notice that your team spends an increasing amount of time and effort on tenant management. Or you might notice bugs or operational problems because of inconsistencies in how team members perform management tasks. If these situations occur, consider building a more comprehensive control plane to take on these responsibilities.

> [!NOTE]
> If you provide self-service tenant management, you need a control plane early in your journey. You might choose to create a basic control plane and automate only some of the most commonly used functionality. You can progressively add more capabilities over time.

## Design a control plane

After you determine the requirements and the scope of your control plane, you need to design and architect it. A control plane is an important component, and it deserves the same level of planning as any other part of your architecture.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

A control plane functions as its own system, so you should consider all five pillars of the [Azure Well-Architected Framework](/azure/well-architected/) when you design one. The following sections highlight particular areas to focus on.

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

Control planes often serve as mission-critical components. You must plan the appropriate level of resiliency and reliability that your control plane needs.

Consider the impact of a control plane outage. In extreme cases, an outage might make your entire solution unavailable. Even if your control plane isn't a single point of failure, an outage might cause the following problems:

- Your system can't onboard new tenants, which might affect your sales and business growth.

- Your system can't manage existing tenants, which results in more calls to your support team.
- You can't measure the consumption of tenants or bill them for their usage, which results in lost revenue.
- You can't disable or reconfigure a tenant in response to a security incident.
- Maintenance debt accumulates, which results in long-term damage to the system. For example, if your solution requires nightly cleanup of old data, your disks could get full or your performance could degrade.

Define [service-level objectives](/azure/well-architected/reliability/metrics) for your control plane, including availability targets, the recovery time objective (RTO), and the recovery point objective (RPO). The objectives that you set for your control plane might differ from those that you offer your customers.

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

Control planes are often highly privileged systems. Security problems within a control plane can have catastrophic consequences. Depending on its design and functionality, a control plane might be vulnerable to many different types of attacks, including the following types:

- A control plane might have access to keys and secrets for all tenants. An attacker who has access to your control plane might be able to gain access to any tenant's data or resources.

- A control plane can often deploy new resources to Azure. Attackers might be able to exploit your control plane to deploy their own resources into your subscriptions, potentially incurring extensive charges.
- If an attacker successfully brings your control plane offline, there can be immediate and long-term damage to your system and to your business. See [Reliability](#reliability) for example consequences of a control plane being unavailable.

When you design and implement a control plane, it's essential that you follow security best practices and create a comprehensive threat model to document and mitigate potential threats and security problems in your solution. For more information, see the [Azure Well-Architected Framework guidance for building secure solutions](/azure/well-architected/security/).

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

Because a control plane is a critical component, you should carefully consider how you deploy and operate it in production.

Like other parts of your solution, you should deploy non-production instances of your control plane so that you can thoroughly test its functionality. If your control plane performs deployment operations, consider how your non-production control planes interact with your Azure environment, and which Azure subscription you deploy non-production resources to. Also, plan how you clean up test resources quickly so that they don't accumulate charges accidentally.

You should also plan how you govern your team's access to your control plane. Follow best practices for granting only the permissions that team members need to perform their duties. In addition to helping to avoid security incidents, this approach helps to reduce the effect of accidental misconfiguration.

### Components

There's no single template for a control plane, and the components that you design and build depend on your requirements. Commonly, a control plane consists of APIs and background worker components. In some solutions, a control plane might also include a user interface, which your team or even your customers might use.

#### Isolate your control plane from tenant workloads

It's a good practice to separate your control plane's resources from those used to serve your tenants' data planes. For example, you should consider using separate database servers, application servers, and other components. It's often a good idea to keep your control plane's resources in a separate Azure resource group from those that contain tenant-specific resources.

By isolating your control plane from tenants' workloads, you gain several advantages:

- You can configure scaling separately. For example, your control plane might have consistent resource requirements, and your tenants' resources might scale elastically depending on their needs.

- There's a [bulkhead](../../../patterns/bulkhead.yml) between your control and data planes, which helps to prevent [noisy neighbor problems](../../../antipatterns/noisy-neighbor/noisy-neighbor.yml) from spreading between the planes of your solution.
- Control planes are typically highly privileged systems that have high levels of access. By separating the control plane from data planes, you reduce the likelihood that a security vulnerability might allow attackers to elevate their permissions across your entire system.
- You can deploy separate networking and firewall configurations. Data planes and control planes usually require different types of network access.

#### Orchestrate sequences of long-running operations

The operations that a control plane performs are often long-running and involve coordination between multiple systems. The operations can also have complex failure modes. When you design your control plane, it's important to use a suitable technology for coordinating long-running operations or workflows.

For example, suppose that, when you onboard a new tenant, your control plane runs the following actions in sequence:

1. **Deploy a new database.** This action is an Azure deployment operation. It might take several minutes to complete.

1. **Update your tenant metadata catalog.** This action might involve running a command against an Azure SQL database.
1. **Send a welcome email to the new tenant.** This action invokes a third-party API to send the email.
1. **Update your billing system to prepare to invoice the new tenant.** This action invokes a third-party API. You've noticed that it intermittently fails.
1. **Update your customer relationship management (CRM) system to track the new tenant.** This action invokes a third-party API.

If any step in the sequence fails, you need to consider what to do, such as:

- Retry the failed operation. For example, if your Azure SQL command in step 2 fails with a transient error, you could retry it.

- Continue to the next step. For example, you might decide that it's acceptable if the update to your billing system fails, because your sales team can manually add the customer later.
- Abandon the workflow and trigger a manual recovery process.

You also need to consider what the user experience is like for each failure scenario.

## Manage shared components

A control plane needs to be aware of any components that aren't dedicated to specific tenants, but instead are shared. Some components might be shared among all tenants within a stamp. Other components might be shared among all stamps in a region, or even shared globally across all regions and stamps. Whenever a tenant is onboarded, reconfigured, or offboarded, your control plane needs to know what to do with these shared components.

Some shared components might need to be reconfigured whenever a tenant is added or removed. For example, suppose you have a globally shared Azure Front Door profile. If you add a tenant with a custom domain name, your control plane might need to update the profile's configuration to route requests for that domain name to the correct application. Similarly, when a tenant is offboarded, your control plane might need to remove the custom domain name from the Azure Front Door profile to avoid [subdomain takeover attacks](domain-names.yml#dangling-dns-and-subdomain-takeover-attacks).

Shared components might have complex scaling rules that your control plane needs to follow. For example, suppose that you follow a [bin packing](../approaches/resource-organization.yml#bin-packing) approach to deploy your tenants' databases. When a new tenant is onboarded, you add a new Azure SQL database for that tenant, and then you assign it to an Azure SQL elastic pool. You might have determined that you need to increase the resources allocated to your pool for every tenth database that you add. When you add or remove a tenant, your control plane needs to re-evaluate the pool's configuration and decide whether to change the pool's resources. When you reach the maximum number of databases that you can assign to a single elastic pool, you need to create a new pool and start to use that pool for new tenant databases. Your control plane needs to take responsibility for managing each of these shared components, scaling and reconfiguring them whenever something changes.

When your control plane manages shared components, it's important to be aware of race conditions, which can occur when multiple operations happen in parallel. For example, if you onboard a new tenant at the same time that you offboard a different tenant, you need to ensure that your ultimate end state is consistent and meets your scaling requirements.

## Use multiple control planes

In a complex environment, you might need to use multiple control planes, each with different areas of responsibility. Many multitenant solutions follow the [Deployment Stamps pattern](../../../patterns/deployment-stamp.yml) and shard tenants across multiple stamps. When you use this pattern, you might create separate control planes for global and stamp responsibilities.

> [!TIP]
> Coordinating across multiple control planes is complex, so try to minimize the number of control planes that you build. Most solutions need only one control plane.

### Global control planes

A global control plane is typically responsible for the overall management and tracking of tenants. A global control plane might have the following responsibilities:

- **Tenant placement.** The global control plane determines which stamp a tenant should use. It might make this determination based on factors like the tenant's region, each stamp's capacity utilization, and the tenant's service level requirements.

- **Tenant onboarding and life cycle management.** These responsibilities include tracking all tenants across all deployments.

### Stamp control planes

A stamp control plane is deployed into each deployment stamp and is responsible for the tenants and resources allocated to that stamp. A stamp control plane might have these responsibilities:

- **Creating and managing tenant-specific resources within the stamp**, like databases and storage containers.

- [**Managing shared resources**](#manage-shared-components), including monitoring the consumption of shared resources and deploying new instances when they're approaching their maximum capacity.
- **Performing maintenance operations within the stamp**, like database index management and cleanup operations.

Each stamp's control plane coordinates with the global control plane. For example, suppose a new tenant signs up. The global control plane is initially responsible for selecting a stamp for the tenant's resources. Then, the global control plane prompts the stamp's control plane to create the necessary resources for the tenant.

The following diagram shows an example of how the two control planes might coexist in a single system:

:::image type="content" source="media/control-planes/global-stamp-control-planes.png" alt-text="Diagram that shows a logical system design. The design has a global control plane and stamp control planes." lightbox="media/control-planes/global-stamp-control-planes.png" border="false":::

### Tenant control planes

Tenants might use a tenant-level control plane to manage their own logical or physical resources. A tenant control plane might have the following responsibilities:

- **Management of tenant-specific configuration**, like user access.

- **Tenant-initiated maintenance operations**, like backing up data or downloading a previous backup.
- **Update management**, if you allow tenants to [control their own updates to their applications](updates.md).

The following diagram shows a complex system that has a global control plane, stamp control planes, and a control plane for each tenant:

:::image type="content" source="media/control-planes/global-stamp-tenant-control-planes.png" alt-text="Diagram that shows a logical system design. The design has a global control plane, stamp control planes, and a control plane for each tenant." lightbox="media/control-planes/global-stamp-tenant-control-planes.png" border="false":::

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

 * [John Downs](https://linkedin.com/in/john-downs) | Principal Software Engineer

Other contributors:

 * [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414) | Technical Writer
 * [Bohdan Cherchyk](https://linkedin.com/in/cherchyk) | Senior Customer Engineer, FastTrack for Azure
 * [Landon Pierce](https://www.linkedin.com/in/landon-pierce-a84b37b6) | Customer Engineer, FastTrack for Azure
 * [Daniel Scott-Raynsford](https://linkedin.com/in/dscottraynsford) | Partner Technology Strategist
 * [Arsen Vladimirskiy](https://linkedin.com/in/arsenv) | Principal Customer Engineer, FastTrack for Azure

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next step

- [Azure Well-Architected Framework](/azure/well-architected/)

## Related resources 

- [Architectural considerations overview](overview.yml) 
- [Architectural approaches for control planes in multitenant solutions](../approaches/control-planes.md)
