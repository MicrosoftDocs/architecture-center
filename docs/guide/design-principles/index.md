---
title: Design principles for Azure applications
description: Follow these design principles to make your Azure application more scalable, resilient, and manageable.
author: martinekuan
ms.author: architectures
ms.date: 07/19/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: guide
categories:
  - management-and-governance
products:
  - azure
ms.custom:
  - seojan19
  - guide
---

# Ten design principles for Azure applications

Follow these design principles to make your application more scalable, resilient, and manageable.

* **[Design for self healing](self-healing.md)**. In a distributed system, failures happen. Design your application to be self healing when failures occur.

* **[Make all things redundant](redundancy.md)**. Build redundancy into your application, to avoid having single points of failure.

* **[Minimize coordination](minimize-coordination.yml)**. Minimize coordination between application services to achieve scalability.

* **[Design to scale out](scale-out.md)**. Design your application so that it can scale horizontally, adding or removing new instances as demand requires.

* **[Partition around limits](partition.md)**. Use partitioning to work around database, network, and compute limits.

* **[Design for operations](design-for-operations.md)**. Design your application so that the operations team has the tools they need.

* **[Use managed services](managed-services.md)**. When possible, use platform as a service (PaaS) rather than infrastructure as a service (IaaS).

  * **[Use an identity service](identity.md)**. Use an identity as a service (IDaaS) platform instead of building or operating your own.

* **[Use the best data store for the job](/azure/architecture/guide/design-principles/use-best-data-store)**. Pick the storage technology that is the best fit for your data and how it will be used.

* **[Design for evolution](design-for-evolution.md)**. All successful applications change over time. An evolutionary design is key for continuous innovation.

* **[Build for the needs of business](build-for-business.md)**. Every design decision must be justified by a business requirement.
