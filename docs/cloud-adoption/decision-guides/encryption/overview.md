---
title: "CAF: Encryption" 
titleSuffix: Microsoft Cloud Adoption Framework for Azure
ms.service: architecture-center
ms.subservice: enterprise-cloud-adoption
ms.custom: governance
ms.date: 02/11/2019
description: Learn about encryption as a core service in Azure migrations.
author: rotycenh
---

# Encryption decision guide

Encrypting data protects it against unauthorized access. Properly implemented encryption policy provides additional layers of security for your cloud-based workloads and guards against attackers and other unauthorized users from both inside and outside your organization and networks.

While encrypting resources is generally desirable, encryption does have costs that can increase latency and overall resource usage. For demanding workloads, striking the correct balance between encryption and performance is essential.

![Plotting encryption options from least to most complex, aligned with jump links below](../../_images/discovery-guides/discovery-guide-encryption.png)

Jump to: [Key management](#key-management) | [Data encryption](#data-encryption) | [Learn more](#learn-more)

The inflection point when determining a cloud encryption strategy focuses on corporate policy and compliance mandates.

There are multiple ways to implement encryption in a cloud environment, with varying cost and complexity. Corporate policy and third-party compliance are the biggest drivers when planning an encryption strategy. Most cloud-based solutions provide standard mechanisms for encrypting data, whether at rest or in transit. However, for policies and compliance requirements that demand tighter controls, such as standardized secrets and key management, encryption in-use, or data specific encryption, you will likely need to implement a complex solution.

## Key management

Modern key management systems should offer support for storing keys using hardware security modules (HSMs) for increased protection. Thus, a key management system is critical to your organization's ability to create and store cryptographic keys, important passwords, connection strings, and other IT confidential information.

When planning a cloud migration, the following table describes how you can store and manage encryption keys, certificates, and secrets, which are critical for creating secure and manageable cloud deployments:

| Question | Cloud Native | Hybrid | On-premises |
|---------------------------------------------------------------------------------------------------------------------------------------|--------------|--------|-------------|
| Does your organization lack centralized key and secret management?                                                                    | Yes          | No     | No          |
| Will you need to limit the creation of keys and secrets to devices to your on-premises hardware, while using these keys in the cloud? | No           | Yes    | No          |
| Does your organization have rules or policies in place that would prevent keys and secrets from being stored offsite?                | No           | No     | Yes         |

### Cloud native

With cloud native key management, all keys and secrets are generated, managed, and stored in a cloud-based vault. This approach simplifies many IT tasks related to key management.

Cloud native key management assumptions: Using a cloud native key management system assumes the following:

- You trust the cloud key management solution with creating, managing, and hosting your organization's secrets and keys.
- You enable all on-premises applications and services that rely on accessing encryption services or secrets to access the cloud key management system.

### Hybrid (bring your own key)

With a bring-your-own-key approach, you generate keys on dedicated HSM hardware within your on-premises environment, then transfer the keys to a secure cloud key management system for use with cloud resources.

Hybrid key management assumptions: Using a hybrid key management system assumes the following:

- You trust the underlying security and access control infrastructure of the cloud platform for hosting and using your keys and secrets.
- You are required by regulatory or organizational policy to keep the creation and management of your organization's secrets and keys on-premises.

### On-premises (hold your own key)

In certain scenarios, there may be regulatory, policy, or technical reasons why you can't store keys on a key management system provided by a public cloud service. In these cases, you must maintain keys using on-premises hardware, and provision a mechanism to allow cloud-based resource to access these keys for encryption purposes. Note that a hold your own key approach may not be compatible with all cloud services.

On-premises key management assumptions: Using an on-premises key management system assumes the following:

- You are required by regulatory or organizational policy to keep the creation, management, and hosting of your organization's secrets and keys on-premises.
- Any cloud-based applications or services that rely on accessing encryption services or secrets can access the on-premises key management system.

## Data encryption

There are several different states of data with different encryption needs to consider when planning your encryption policy:

| Data state | Data |
|-----|-----|
| Data in transit | Internal network traffic, internet connections, connections between datacenters or virtual networks |
| Data at rest    | Databases, files, virtual drives, PaaS storage |
| Data in use     | Data loaded in RAM or in CPU caches |

### Data in transit

Data in transit is data moving between resources on the internal, between datacenters or external networks, or over the internet.

Encrypting data in transit is usually done by requiring SSL/TLS protocols for traffic. Traffic transiting between your cloud-hosted resources to external network or the public internet should always be encrypted. PaaS resources generally also enforce SSL/TLS encryption to traffic by default. Whether you enforce encryption for traffic between IaaS resources hosted inside your virtual networks is a decision for your Cloud Adoption Team and workload owner and is generally recommended.

**Encrypting data in transit assumptions**. Implementing proper encryption policy for data in transit assumes the following:

- All publicly accessible endpoints in your cloud environment will communicate with the public internet using SSL/TLS protocols.
- When connecting cloud networks with on-premises or other external network over the public internet, use encrypted VPN protocols.
- When connecting cloud networks with on-premises or other external network using a dedicated WAN connection such as ExpressRoute, you will use a VPN or other encryption appliance on-premises paired with a corresponding virtual VPN or encryption appliance deployed to your cloud network.
- If you have sensitive data that shouldn't be included in traffic logs or other diagnostics reports visible to IT staff, you will encrypt all traffic between resources in your virtual network.

### Data at rest

Data at rest represents any data not being actively moved or processed, including files, databases, virtual machine drives, PaaS storage accounts, or similar assets. Encrypting stored data protects virtual devices or files against unauthorized access either from external network penetration, rogue internal users, or accidental releases.

PaaS storage and database resources generally enforce encryption by default. IaaS virtual resources can be secured through virtual disk encryption using cryptographic keys stored in your key management system.

Encryption for data at rest also encompasses more advanced database encryption techniques, such as column-level and row level encryption, which provides much more control over exactly what data is being secured.

Your overall policy and compliance requirements, the sensitivity of the data being stored, and the performance requirements of your workloads should determine which assets require encryption.

**Encrypting Data at Rest Assumptions**. Encrypting data at rest assumes the following:

- You are storing data that is not meant for public consumption.
- Your workloads can accept the added latency cost of disk encryption.

### Data in use

Encryption for data in use involves securing data in nonpersistent storage, such as RAM or CPU caches. Use of technologies such as full memory encryption, enclave technologies, such as Intel's Secure Guard Extensions (SGX). This also includes cryptographic techniques, such as homomorphic encryption that can be used to create secure, trusted execution environments.

**Encrypting data in use assumptions**. Encrypting data in use assumes the following:

- You are required to maintain data ownership separate from the underlying cloud platform at all times, even at the RAM and CPU level.

## Learn more

See the following for more information about encryption and key management in the Azure platform.

- [Azure encryption overview](/azure/security/security-azure-encryption-overview). A detailed description of how Azure uses encryption to secure both data at rest and data in transit.
- [Azure Key Vault](/azure/key-vault/key-vault-overview). Key Vault is the primary key management system for storing and managing cryptographic keys, secrets, and certificates within Azure.
- [Confidential computing in Azure](/solutions/confidential-compute). Azure's confidential computing initiative provides tools and technology to create trusted execution environments or other encryption mechanisms to secure data in use.

## Next steps

Learn how Software Defined Networks provide virtualized networking capabilities for cloud deployments.

> [!div class="nextstepaction"]
> [Which Software Defined Network pattern is best for my deployment?](../software-defined-network/overview.md)
