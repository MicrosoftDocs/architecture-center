---
title: Design Principles for Azure Applications
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

* **[Design for self healing](self-healing.md)**. In a distributed system, failures happen. You can just design your application to be self-healing when failures happen.

* **[Make all things redundant](redundancy.md)**. Build redundancy into your application to avoid having single points of failure.

* **[Minimize coordination](minimize-coordination.yml)**. Minimize coordination between application services to achieve scalability.

* **[Design to scale out](scale-out.md)**. You can design your application to scale horizontally, adding or removing new instances as demand requires.

* **[Partition around limits](partition.md)**. Use partitioning to work around database, network, and compute limits.

* **[Design for operations](design-for-operations.md)**. You can design your application so the operations team has the necessary tools.

* **[Use managed services](managed-services.md)**. When possible, use platform as a service (PaaS) rather than infrastructure as a service (IaaS).

  * **[Use an identity service](identity.md)**. Use an identity as a service (IDaaS) platform instead of building or operating your own.

* **[Use the best data store for the job](/azure/architecture/guide/design-principles/use-best-data-store)**. You can pick the storage technology that is the best fit for your data and how it will be used.

* **[Design for evolution](design-for-evolution.md)**. All successful applications change over time. An evolutionary design is key for continuous innovation.

* **[Build for the needs of business](build-for-business.md)**. A business requirement must justify every design decision.
