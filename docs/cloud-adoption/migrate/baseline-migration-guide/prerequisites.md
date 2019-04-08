---
<<<<<<< HEAD:docs/cloud-adoption/migrate/baseline-migration-guide/pre-requisites.md
title: "CAF: Pre-requisites before starting the Simple Migration Journey"
description: Pre-requisites before starting the Simple Migration Journey
author: matticusau
ms.author: mlavery
=======
title: "CAF: Prerequisites before starting the Simple Migration Journey"
description: Prerequisites before starting the Simple Migration Journey
author: BrianBlanchard
>>>>>>> caf/migrate-v1:docs/cloud-adoption/migrate/baseline-migration-guide/prerequisites.md
ms.date: 4/14/2019
ms.topic: conceptual
ms.service: azure-portal
ms.custom: "fasttrack - new"
---

<<<<<<< HEAD:docs/cloud-adoption/migrate/baseline-migration-guide/pre-requisites.md
::: zone target="chromeless"

# Pre-requisites

::: zone-end

::: zone target="docs"

# Pre-requisites before migrating to Azure
=======
# Prerequisites before migrating to Azure
>>>>>>> caf/migrate-v1:docs/cloud-adoption/migrate/baseline-migration-guide/prerequisites.md

::: zone-end

Prior to beginning any migrations, the environment must be prepared for the coming changes. The resources provided within this section of the guide will assist you in achieving this objective.

# [Narrative](#tab/Narrative)

As a customer you may find you have several motivating factors for migrating to Azure. These may range from removing risks associated with legacy hardware, reducing CapEx, freeing up datacenter space, looking for a quick cloud return on investment (ROI).

* **legacy hardware** - You may have applications hosted on infrastructure reaching it's end of life or support, either on-premises or with a hosting provider. Migration to the cloud offers an attractive remediation to the challenge as the ability to migrate "as-is" allows the team to quickly resolve the current infrastructure life cycle challenge, while then turning attention to the long term planning of application life cycle and optimization to take advantage of the cloud.
* **reduce CapEx** - Hosting your own server infrastructure requires considerable investment in hardware, software, electricity, and personal. Migrating to a cloud solution can provide significant reductions in CapEx. To achieve the best CapEx reductions a redesign of the solution may be required, however an "as-is" migration is a great first step.
* **Freeing up Datacenter space** - You may become an Azure customer though the need to expand your datacenter capacity and one way to do this is to leverage the cloud as an extension of your on-premises services.
* **Quick cloud ROI** - Getting a "return on investment" (ROI) is much easier with cloud solutions as the overall infrastructure costs are shared across customers. The cloud payment model provides a great way to realise ROI.

Each of the above scenarios may be entry points to then extend your cloud footprint utilizing another scenario.

## Migration Characteristics

Prior to this migration the digital estate will consist of mostly on-premises hosted infrastructure, possibly with hosting business critical applications. After a successful migration your data estate may look very much how it did on-premises but with the infrastructure hosted in cloud resources. Alternatively the ideal data estate will be a variation of your current data estate as it will have aspects of your on-premises infrastructure with components which have been refactored to optimize and take advantage of the cloud platform.

The focus of this migration journey is to realise:

* Remediation of legacy hardware end-of-life
* Reduce CapEx
* Realizing ROI

> [!Note]
> An additional benefit realized through this migration journey, is the additional software support model for Windows 2008/2008 R2 and SQL Server 2008/2008 R2. For further information please see:
>
> * [Windows Server 2008/2008 R2](https://www.microsoft.com/en-us/cloud-platform/windows-server-2008).
> * [SQL Server 2008/2008 R2](https://www.microsoft.com/en-us/sql-server/sql-server-2008).

# [When to use this approach](#tab/Approach)

This guide has been designed largely for Rehost ("lift and shift") migrations, however many principals apply to Replatform or Refactor migrations.

If your goal is simply to move existing applications to the cloud, first, identify existing applications that would not require substantial modification to run in Azure App Service. These apps should be the first candidates for Cloud-Optimized. Then, for the apps that still cannot move to Windows Containers and PaaS such as App Service or orchestrators like Azure Service Fabric, migrate those to VMs (IaaS).

But, keep in mind that correctly configuring, securing, and maintaining VMs requires much more time and IT expertise compared to using PaaS services in Azure. If you are considering Azure Virtual Machines, make sure that you take into account the ongoing maintenance effort required to patch, update, and manage your VM environment. Azure Virtual Machines is IaaS.

## Learn More

* [CAF: Migration Theory](https://review.docs.microsoft.com/en-us/azure/architecture/cloud-adoption/migrate/theory/pre-requisites/?branch=caf%2Fmigrate-v1)
* [CAF: 5 Rs of Rationalization](https://docs.microsoft.com/en-gb/azure/architecture/cloud-adoption/digital-estate/5-rs-of-rationalization)

# [Planning Checklist](#tab/Checklist)

Before starting a migration there are a number of activities you will need to complete. The exact details of these activities will vary depending on the environment you are migrating, however as a general rule the following checklist may apply:

> [!div class="checklist"]
> * **Identify stakeholders**: Identify the key people who will have a role to play or stake in the outcome of the migration
> * **Identify key milestones**: To effectively plan the migration timelines identify the key milestones to be met.
> * **Identify the migration strategy**: Determine which of the 5 Rs of rationalization you will use.
> * **Assess your technical fit**: Validate the technical readiness and suitability for migration.
> * **Migrate your services**: Perform the actual migration.
> * **Post Migration**: Understand what is required after you migrate your environment to Azure.

Assuming you choose a "rehost" approach to migration the following child activities will be relevant:

> [!div class="checklist"]
> * **Governance alignment**: Has a consensus been achieved regarding alignment of governance with the migration foundation.
> * **Network**: A network approach should be selected and aligned to IT security requirement.
> * **Identity**: A hybrid identity approach should be aligned to fit the identity management and cloud adoption plan.

::: zone target="docs"

## Learn More

* [CAF: 5 Rs of Rationalization](https://docs.microsoft.com/en-gb/azure/architecture/cloud-adoption/digital-estate/5-rs-of-rationalization)
* [CAF: Planning Checklist](https://review.docs.microsoft.com/en-us/azure/architecture/cloud-adoption/migrate/theory/pre-requisites/planning-checklist?branch=caf%2Fmigrate-v1)

::: zone-end
