---
title: Security in a hybrid environment
description: Describes considerations for security in a hybrid environment.
author: v-aangie
ms.date: 01/07/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
ms.custom:
---

# Security in a hybrid environment

Security includes protecting applications and data from threats.

## Azure Architecture Center (AAC) resources

- [Hybrid Security Monitoring using Azure Security Center and Azure Sentinel](/azure/architecture/hybrid/hybrid-security-monitoring)
- [DevSecOps in Azure](/azure/architecture/solution-ideas/articles/devsecops-in-azure)
- [Optimize administration of SQL Server instances in on-premises and multi-cloud environments by leveraging Azure Arc](/azure/architecture/hybrid/azure-arc-sql-server)

## Principals

### Azure Arc management security capabilities

- Access unique Azure security capabilities such as Azure Security Center.
- Centrally manage and access<!--CAF Overlap--> for resources with Role Based Access Control.
- Centrally manage and enforce compliance and simplify audit reporting with Azure Policy.<!--CAF Overlap-->
 
### Azure Arc enabled data services security capabilities

- Protect your data workloads with Azure Security Center in your environment, using the advanced threat protection and vulnerability assessment features for unmatched security. 
- Set security policies, resource boundaries, and role-based access control for various data workloads seamlessly across your hybrid infrastructure.<!--CAF Overlap-->

### Azure Stack HCI

- **Protection in transit**. Storage Replica offers built-in security for its replication traffic, which includes packet signing, AES-128-GCM full data encryption, support for Intel AES-NI encryption acceleration, and pre-authentication integrity man-in-the-middle attack prevention.
   - Storage Replica also utilizes Kerberos AES256 for authentication between the replicating nodes.
- **Encryption at rest**. Azure Stack HCI supports BitLocker Drive Encryption for its data volumes, thus facilitating compliance with standards such as FIPS 140-2 and HIPAA.
- **Integration with a range of Azure services that provide additional security advantages**. You can integrate virtualized workloads running on Azure Stack HCI clusters with such Azure services as Azure Security Center.
- **Firewall-friendly configuration**. Storage Replica traffic requires a limited number of open ports between the replicating nodes.

## Design

### Azure Arc enabled servers

**Implement Azure Monitor**

Use Azure Monitor to monitor your VMs, virtual machine scale sets, and Azure Arc machines at scale<!--"at scale" CAF Overlap-->. Azure Monitor analyzes the performance and health of your Windows and Linux VMs and monitors their processes and dependencies on other resources and external processes. It includes support for monitoring performance and application dependencies for VMs that are hosted on-premises or in another cloud provider.

**Implement Azure Sentinel**

Use Azure Sentinel to deliver intelligent security analytics and threat intelligence across the enterprise, providing a single solution for alert detection, threat visibility, proactive hunting, and threat response. Azure Sentinel is a scalable, cloud-native, security information event management (SIEM) and security orchestration automated response (SOAR) solution that enables several scenarios including:
- Collect data at cloud scale across all users, devices, applications, and infrastructure, both on-premises and in multiple clouds.<!--CAF Overlap-->
- Detect previously undetected threats and minimize false positives.<!--CAF Overlap-->
- Investigate threats with artificial intelligence and hunt for suspicious activities at scale.<!--CAF Overlap-->
- Respond to incidents rapidly with built-in orchestration and automation of common tasks.
 
### **Azure Stack HCI**

A stretched Azure Stack HCI cluster relies on Storage Replica to perform synchronous storage replication between storage volumes hosted by the two groups of nodes in their respective physical sites. If a failure affects the availability of the primary site, the cluster automatically transitions its workloads to nodes in the surviving site to minimize potential downtime.

## Monitor

- Across products: Integrate with Azure Sentinel, Azure Defender.
- Bring Azure Security Center to your on-prem data and servers with Arc.
- Set security policies, resource boundaries, and RBAC for workloads across the hybrid infra.<!--CAF Overlap-->
- Proper admin roles for read, modify, re-onboard, and delete a machine,<!--CAF Overlap-->
 
## Optimize

### Arc servers 
- Implement change tracking and inventory with Azure Automation Change Tracking and Inventory for Arc enabled servers.<!--CAF Overlap-->
- Network configurations.<!--CAF Overlap-->
 
