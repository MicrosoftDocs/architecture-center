---
title: Data protection in Azure
description: Explore data protection considerations in Azure. Classify, protect, and monitor sensitive data assets using access control, encryption, and logging.
author: v-aangie
ms.date: 09/10/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-storage
categories:
  - management-and-governance
  - security
ms.custom:
  - article
---

# Data protection considerations

Classify, protect, and monitor sensitive data assets using access control, encryption, and logging in Azure. Provide controls on data at rest and in transit.

## Checklist
**How are you managing encryption for this workload?**
***
> [!div class="checklist"]
> - Use identity based storage access controls.
> - Use built-in features for data encryption for Azure services.
> - Classify all stored data and encrypt it.
> - Protect data moving over a network through encryption at all points so that it's not accessed unauthorized users.
> - Store keys in managed key vault service with identity-based access control and audit policies.
> - Rotate keys and other secrets frequently.

## Azure security benchmark

The Azure Security Benchmark includes a collection of high-impact security recommendations you can use to help secure the services you use in Azure:

> ![GitHub logo](../../_images/benchmark-security.svg) The questions in this section are aligned to the Azure Security Benchmarks [Data Protection](/azure/security/benchmarks/security-controls-v2-data-protection).

## Reference architecture
Here are some reference architectures related to secure storage:

- [Using Azure file shares in a hybrid environment](../../hybrid/azure-file-share.yml)

- [DevSecOps in Azure](../../solution-ideas/articles/devsecops-in-azure.yml)

## Next steps

We recommend that you review the practices and tools implemented as part of the development cycle.

> [!div class="nextstepaction"]
> [Data protection](./design-storage.md)

## Related links

> Back to the main article: [Security](./overview.md)
