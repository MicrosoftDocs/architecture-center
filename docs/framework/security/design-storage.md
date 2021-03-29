---
title: Data protection in Azure
description: Design considerations about securing and encrypting data storage in Azure.
author: v-aangie
ms.date: 09/17/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
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
 
## In this section

Follow these questions to assess the workload at a deeper level.

|Assessment|Description|
|---|---|
|[**Do you use industry standard encryption algorithms?**](design-storage-encryption.md)|Avoid using custom encryption algorithms or direct cryptography in your workload.|
|[**How is data at rest protected?**](design-storage-encryption.md#data-at-rest)|Classify your data at rest and use encryption.|
|[**How is data in transit secured?**](design-storage-encryption.md#data-in-transit)|Use encrypted network channels (TLS/HTTPS) for all client/server communication.|
|[**How to authenticate access to your storage**](design-storage-keys.md)|Use identity based storage access controls to enable fine-grained role-based access controls over storage resources.|
|[**Where are workload secrets (keys, certificates) stored?**](design-storage-keys.md#key-storage)|Store keys and secrets in managed key vault service. |

## Azure security benchmark

The Azure Security Benchmark includes a collection of high-impact security recommendations you can use to help secure the services you use in Azure:

> ![GitHub logo](../../_images/benchmark-security.svg) The questions in this section are aligned to the Azure Security Benchmarks [Data Protection](/azure/security/benchmarks/security-control-data-protection).

## Reference architecture
Here are some reference architectures related to secure storage:

- [Using Azure file shares in a hybrid environment](../../hybrid/azure-file-share.yml)

- [DevSecOps in Azure](../../solution-ideas/articles/devsecops-in-azure.yml)

## Related links

> Back to the main article: [Security](./overview.md)