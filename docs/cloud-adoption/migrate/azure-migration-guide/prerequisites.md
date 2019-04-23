---
title: "CAF: Prerequisites for the Simple Migration Journey"
description: Prerequisites for the Simple Migration Journey
author: matticusau
ms.author: mlavery
ms.date: 4/4/2019
ms.topic: conceptual
ms.service: azure-portal
ms.custom: "fasttrack-new"
---

::: zone target="chromeless"

# Prerequisites

::: zone-end

::: zone target="docs"

# Prerequisites before migrating to Azure

::: zone-end

Before starting any migration, the environment must be prepared for the coming changes. The resources provided within this section of the guide will assist you in achieving this objective.

# [Narrative](#tab/Narrative)

As a customer you may find you have several reasons for migrating to Azure. These may range from removing risks associated with legacy hardware, reducing capital expense, freeing up datacenter space, looking for a quick cloud return on investment (ROI).

- **Eliminate legacy hardware.** You may have applications hosted on infrastructure reaching its end of life or support, either on-premises or with a hosting provider. Migration to the cloud offers an attractive remediation to the challenge as the ability to migrate "as-is" allows the team to quickly resolve the current infrastructure lifecycle challenge, while then turning attention to the long term planning of application lifecycle and optimization to take advantage of the cloud.
- **Reduce capital expense.** Hosting your own server infrastructure requires considerable investment in hardware, software, electricity, and personal. Migrating to a cloud solution can provide significant reductions in capital expense. To achieve the best capital expense reductions, a redesign of the solution may be required, however an "as-is" migration is a great first step.
- **Free up datacenter space.** You may become an Azure customer through the need to expand your datacenter capacity and one way to do this is to use the cloud as an extension of your on-premises services.
- **Quick cloud return on investment.** Getting a return on investment (ROI) is much easier with cloud solutions as the overall infrastructure costs are shared across customers. The cloud payment model provides a great way to realize ROI.

Each of the above scenarios may be entry points to then extend your cloud footprint using another scenario.

## Migration characteristics

Prior to this migration the digital estate will consist of mostly on-premises hosted infrastructure, possibly with hosting business critical applications. After a successful migration your data estate may look very much how it did on-premises but with the infrastructure hosted in cloud resources. Alternatively the ideal data estate will be a variation of your current data estate as it will have aspects of your on-premises infrastructure with components which have been refactored to optimize and take advantage of the cloud platform.

The focus of this migration journey is to realize:

- Remediation of legacy hardware end-of-life.
- Reduction of capital expense.
- Realization of return on investment.

> [!NOTE]
> An additional benefit realized through this migration journey, is the additional software support model for Windows 2008/2008 R2 and SQL Server 2008/2008 R2. For more information, see:
>
> - [Windows Server 2008/2008 R2](/cloud-platform/windows-server-2008).
> - [SQL Server 2008/2008 R2](/sql-server/sql-server-2008).

# [When to use this approach](#tab/Approach)

This guide has been designed largely for rehost ("lift and shift") migrations, however many principals apply to Replatform or Refactor migrations.

If your goal is simply to move existing applications to the cloud, first, identify existing applications that would not require substantial modification to run in Azure App Service. These apps should be the first candidates for Cloud-Optimized. Then, for the apps that still cannot move to Windows Containers and PaaS such as App Service or orchestrators like Azure Service Fabric, migrate those to VMs (IaaS).

But, keep in mind that correctly configuring, securing, and maintaining VMs requires much more time and IT expertise compared to using PaaS services in Azure. If you are considering Azure Virtual Machines, make sure that you take into account the ongoing maintenance effort required to patch, update, and manage your VM environment. Azure Virtual Machines is IaaS.

## Learn more

- [Cloud Adoption Framework migration considerations](../migration-considerations/prerequisites/index.md)
- [The Five Rs of rationalization](../../digital-estate/5-rs-of-rationalization.md)

# [Planning checklist](#tab/Checklist)

Before starting a migration there are a number of activities you will need to complete. The exact details of these activities will vary depending on the environment you are migrating, however as a general rule the following checklist may apply:

> [!div class="checklist"]
>
> - **Identify stakeholders:** Identify the key people who will have a role to play or stake in the outcome of the migration
> - **Identify key milestones:** To effectively plan the migration timelines identify the key milestones to be met.
> - **Identify the migration strategy:**: Determine which of the 5 Rs of rationalization you will use.
> - **Assess your technical fit:** Validate the technical readiness and suitability for migration.
> - **Migrate your services:** Perform the actual migration.
> - **Post-migration:** Understand what is required after you migrate your environment to Azure.

Assuming you choose a rehost approach to migration, the following child activities will be relevant:

> [!div class="checklist"]
>
> - **Governance alignment:** Has a consensus been achieved regarding alignment of governance with the migration foundation.
> - **Network:** A network approach should be selected and aligned to IT security requirement.
> - **Identity:** A hybrid identity approach should be aligned to fit the identity management and cloud adoption plan.

::: zone target="docs"

## Learn more

- [The 5 Rs of rationalization](../../digital-estate/5-rs-of-rationalization.md)
- [Cloud Adoption Framework planning checklist](../migration-considerations/prerequisites/planning-checklist.md)

::: zone-end

# [Create a landing zone](#tab/Landingzone)

As you prepare to migrate, an important step is to create the landing zone by setting up Azure infrastructure in preparation for migration. During this time your business will run in a hybrid environment. Generally there are 6 broad areas which you should think about when preparing your landing zone:

> [!div class="checklist"]
>
> - **Step 1: Azure subscriptions.** How will you purchase Azure, and interact with the Azure platform and services?
> - **Step 2: Hybrid identity.** How will you manage and control access to on-premises and Azure resources after migration? How do you extend or move identity management to the cloud?
> - **Step 3: Design for resilience.** How will you ensure that its apps and infrastructure are resilient if outages and disasters occur?
> - **Step 4: Design a network infrastructure.** How should you design a networking infrastructure, and establish connectivity between its on-premises data center and Azure?
> - **Step 5: Consider security.** How will you secure the hybrid/Azure deployment?
> - **Step 6: Plan for governance.** How will you keep the deployment aligned with security and governance requirements?

The key elements for each of the above steps are described in the following sections. For more details on setting up a landing zone please see [Deploy a migration infrastructure](../azure-best-practices/contoso-migration-infrastructure.md) which shows how the fictional company Contoso prepares for a migration.

## Step 1: Buy and subscribe to Azure

This steps includes the following considerations:

> [!div class="checklist"]
>
> - **Buy Azure** which subscription model will best suit your needs, Pay-as-you-go or  Enterprise Agreement.
> - **Manage subscriptions** Will you be using multiple subscriptions or a single subscription.
> - **Examine licensing** Which methodology best suits your needs Azure Hybrid Benefit, Licenses Mobility, Reserved VM instances.

## Step 2: Hybrid identity

Using identity and access management (IAM) is important in giving and controlling user access to Azure resources. Some considerations are:

> [!div class="checklist"]
>
> - **Extend identity** Using your on-premises Activity Directory and extending this to Azure Activity Directory.
> - **New identity** Creating a new identity within Azure Active Directory which is separate to on-premises identity services and dedicated to securing your Azure resources.
> - **Office 365 identity** Do you already have Office 365 as this includes Azure Activity Directory and may be enhanced to include your Azure identity needs.

## Step 3: Design for resilience

Designing your environment to be resilient in the event of disasters or outages is essential and consists of:

> [!div class="checklist"]
>
> - **Regions** The choice of region is important. Regions are organized into geographies, with geographical boundaries providing data residency, sovereignty, and compliance. Each Azure region is paired with a different region for resiliency. Not all products are available in each region.
> - **Availability** Availability Sets helps you protect apps and data from local outages within a data center. Availability Zones helps you protect apps and data from failures affecting an entire data center within a region.
> - **Backups** Much like on-premises backups are essential to ensure you protect data. Azure Backup supports both locally redundant storage (LRS) and geo-redundant storage (GRS) to provide the level of protection you require.
> - **Disaster Recovery** Azure Site Recovery helps ensure business continuity by keeping business apps and workloads running during regional outages.

## Step 4: Design a network infrastructure

With a regional design in place you are then ready to consider designing a network strategy.

> [!div class="checklist"]
>
> - **Plan hybrid network connectivity** When working with a hybrid solution the network design must bridge between on-premises and cloud services while maintaining a high level of security and compliance. There are many options for bridging the networks such as VPN and VPN with ExpressRoute.
> - **Design the Azure network infrastructure** This is important to ensure the hybrid solution is secure and scalable. This includes considering network peering, hub-to-hub for cross region access, and hub-to-spoke within a region.
> - **Set up DNS** Domain Name Resolution can be configured to use either Azure DNS, custom VM with DNS, or your on-premises DNS in a hybrid solution.

## Step 5: Consider security

Security is crucial in the cloud, and Azure provides a wide array of security tools and capabilities. These help you to create secure solutions, on the secure Azure platform. There are a few aspects to consider:

> [!div class="checklist"]
>
> - **Azure Security Center** Azure Security Center provides unified security management and advanced threat protection across hybrid cloud workloads. With Security Center, you can apply security policies across your workloads, limit your exposure to threats, and detect and respond to attacks.
> - **Network security groups (NSGs)** An NSG is a filter (firewall) that contains a list of security rules which, when applied, allow or deny network traffic to resources connected to Azure VNets.
> - **Data encryption** Azure Disk Encryption is a capability that helps you encrypt your Windows and Linux IaaS virtual machine disks.

## Step 6: Plan for governance

Azure provides a range of governance controls across services and the Azure platform. As you configure identity and access control, you will start to include governance and security in place. Broadly, there are three areas you will need to consider:

> [!div class="checklist"]
>
> - **Policy**: Azure Policy applies and enforces rules and effects over your resources, so that resources stay compliant with corporate requirements and SLAs.
> - **Locks**: Azure allows you to lock subscriptions, resources groups, and other resources, so that they can only be modified by those with authority to do so.
> - **Tags**: Resources can be controlled, audited, and managed with tags. Tags attach metadata to resources, providing information about resources or owners.

## Learn more

- [Deploy a migration infrastructure](../azure-best-practices/contoso-migration-infrastructure.md)
