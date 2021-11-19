---
title: Security in a hybrid workload
description: Includes guidance and recommendations that apply to the Security pillar in a hybrid and multi-cloud workload.
author: v-aangie
ms.date: 02/19/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
ms.custom:
  - e2e-hybrid
---

# Security in a hybrid workload

Security is one of the most important aspects of any architecture. Particularly in hybrid and multicloud environments, an architecture built on good security practices should be resilient to attacks and provide confidentiality, integrity, and availability. To assess your workload using the tenets found in the Microsoft Azure Well-Architected Framework, see the [Microsoft Azure Well-Architected Review](/assessments/?id=azure-architecture-review&mode=pre-assessment).

Microsoft Defender for Cloud can monitor on-premises systems, Azure VMs, Azure Monitor resources, and even VMs hosted by other cloud providers. To support that functionality, the standard fee-based tier of Microsoft Defender for Cloud is needed. We recommend that you use the 30-day free trial to validate your requirements. Defender for Cloud's operational process won't interfere with your normal operational procedures. Instead, it passively monitors your deployments and provides recommendations based on the security policies you enable.

Microsoft Sentinel can help simplify data collection across different sources, including Azure, on-premises solutions, and across clouds using built-in connectors. Microsoft Sentinel works to collect data at cloud scale—across all users, devices, applications, and infrastructure, both on-premises and in multiple clouds.

## Azure Architecture Center (AAC) resources

- [Hybrid Security Monitoring using Microsoft Defender for Cloud and Microsoft Sentinel](../../hybrid/hybrid-security-monitoring.yml)
- [DevSecOps in Azure](../../solution-ideas/articles/devsecops-in-azure.yml)
- [Optimize administration of SQL Server instances in on-premises and multi-cloud environments by leveraging Azure Arc](../../hybrid/azure-arc-sql-server.yml)
- [Implement a secure hybrid network](../../reference-architectures/dmz/secure-vnet-dmz.yml)
- [Securely managed web applications](../../example-scenario/apps/fully-managed-secure-apps.yml)

## Principles

### Azure Arc management security capabilities

- Access unique Azure security capabilities such as Microsoft Defender for Cloud.
- Centrally manage access for resources with Role-Based Access Control.
- Centrally manage and enforce compliance and simplify audit reporting with Azure Policy.

### Azure Arc enabled data services security capabilities

- Protect your data workloads with Microsoft Defender for Cloud in your environment, using the advanced threat protection and vulnerability assessment features for unmatched security.
- Set security policies, resource boundaries, and role-based access control for various data workloads seamlessly across your hybrid infrastructure.

### Azure Stack HCI

- **Protection in transit**. Storage Replica offers built-in security for its replication traffic. This includes packet signing, AES-128-GCM full data encryption, support for Intel AES-NI encryption acceleration, and pre-authentication integrity man-in-the-middle attack prevention.
   - Storage Replica also utilizes Kerberos AES256 for authentication between the replicating nodes.
- **Encryption at rest**. Azure Stack HCI supports BitLocker Drive Encryption for its data volumes, thus facilitating compliance with standards such as FIPS 140-2 and HIPAA.
- **Integration with a range of Azure services that provide more security advantages**. You can integrate virtualized workloads that run on Azure Stack HCI clusters with Azure services such as Microsoft Defender for Cloud.
- **Firewall-friendly configuration**. Storage Replica traffic requires a limited number of open ports between the replicating nodes.

## Design

### Azure Arc enabled servers

**Implement Azure Monitor**

Use Azure Monitor to monitor your VMs, virtual machine scale sets, and Azure Arc machines at scale. Azure Monitor analyzes the performance and health of your Windows and Linux VMs. It also monitors their processes and dependencies on other resources and external processes. It includes support for monitoring performance and application dependencies for VMs that are hosted on-premises or in another cloud provider.

**Implement Microsoft Sentinel**

Use Microsoft Sentinel to deliver intelligent security analytics and threat intelligence across the enterprise. This provides a single solution for alert detection, threat visibility, proactive hunting, and threat response. Microsoft Sentinel is a scalable, cloud-native, security information event management (SIEM) and security orchestration automated response (SOAR) solution that enables several scenarios including:

- Collect data at cloud scale across all users, devices, applications, and infrastructure, both on-premises and in multiple clouds.
- Detect previously undetected threats and minimize false positives.
- Investigate threats with artificial intelligence and hunt for suspicious activities at scale.
- Respond to incidents rapidly with built-in orchestration and automation of common tasks.

### **Azure Stack HCI**

A stretched Azure Stack HCI cluster relies on Storage Replica to perform synchronous storage replication between storage volumes hosted by the two groups of nodes in their respective physical sites. If a failure affects the availability of the primary site, the cluster automatically transitions its workloads to nodes in the surviving site to minimize potential downtime.

## Monitor

- Across products: Integrate with Microsoft Sentinel and Microsoft Defender for Cloud.
- Bring Microsoft Defender for Cloud to your on-premises data and servers with Arc.
- Set security policies, resource boundaries, and RBAC for workloads across the hybrid infrastructure.
- Set the correct admin roles to read, modify, re-onboard, and delete a machine.
