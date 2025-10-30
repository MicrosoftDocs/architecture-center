---
title: Management and governance architecture design
description: Get an overview of Azure management and governance technologies, guidance offerings, solution ideas, and reference architectures.
author: claytonsiemens77
ms.author: pnp
ms.date: 06/16/2023
ms.topic: concept-article
ms.subservice: architecture-guide
---

# Management and governance architecture design

Management and governance includes critical tasks like:

- The monitoring, auditing, and reporting of security and business requirements.
- Implementing backup, disaster recovery, and high availability.
- Ensuring compliance with internal requirements and external regulations.
- The protection of sensitive data.

Azure provides a wide range of services to help you with management and governance. Here are a few examples:  

- [Azure Attestation](https://azure.microsoft.com/services/azure-attestation). Remotely verify the trustworthiness of a platform and the integrity of the binaries running inside it.
- [Azure confidential ledger](https://azure.microsoft.com/services/azure-confidential-ledger). Store and process confidential data with confidence.
- [Azure Purview](https://azure.microsoft.com/services/purview). Govern, protect, and manage your data.
- [Azure Policy](https://azure.microsoft.com/services/azure-policy). Achieve real-time cloud compliance at scale with consistent resource governance.
- [Azure Stack](https://azure.microsoft.com/products/azure-stack). Place technologies and services in appropriate locations, based on your business requirements. Meet custom compliance, sovereignty, and data gravity requirements.
- [Azure Backup](https://azure.microsoft.com/services/backup). Define backup policies and provide protection for a wide range of enterprise workloads.
- [Azure Site Recovery](https://azure.microsoft.com/services/site-recovery). Keep your business running with built-in disaster recovery.
- [Azure Archive Storage](https://azure.microsoft.com/services/storage/archive). Store rarely accessed data.
- [Azure Monitor](https://azure.microsoft.com/services/monitor). Get full observability into your applications, infrastructure, and network.
- [Azure Update Manager](https://azure.microsoft.com/products/azure-update-management-center/). Centrally manage updates and compliance at scale.

## Introduction to management and governance on Azure

If you're new to management and governance on Azure, the best way to learn more is with [Microsoft Learn training](/training/?WT.mc_id=learnaka), a free online training platform. Microsoft Learn provides interactive training for Microsoft products and more.

Here are some resources to get you started:

- Learning path: [Manage information protection and governance](/training/paths/m365-compliance-information)
- Module: [Design an enterprise governance strategy](/training/modules/enterprise-governance)
- Module: [Design a solution for backup and disaster recovery](/training/modules/design-solution-for-backup-disaster-recovery)

## Path to production

The following sections provide links to reference architectures in some key management and governance categories:

### Backup

- [Azure Backup architecture and components](/azure/backup/backup-architecture?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)
- [Support matrix for Azure Backup](/azure/backup/backup-support-matrix?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)
- [Backup cloud and on-premises workloads to cloud](/azure/backup/guidance-best-practices?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)

### Disaster recovery

- [Azure to Azure disaster recovery architecture](/azure/site-recovery/azure-to-azure-architecture)
- [Support matrix for Azure VM disaster recovery between Azure regions](/azure/site-recovery/azure-to-azure-support-matrix)
- [Integrate Azure ExpressRoute with disaster recovery for Azure VMs](/azure/site-recovery/azure-vm-disaster-recovery-with-expressroute)
- [Move Azure VMs to another Azure region](/azure/site-recovery/azure-to-azure-move-overview)
- [Business continuity and disaster recovery (BCDR) for Azure VMware Solution enterprise-scale scenario](/azure/cloud-adoption-framework/scenarios/azure-vmware/eslz-business-continuity-and-disaster-recovery)

### High availability

- [High availability enterprise deployment using App Service Environment](../../web-apps/app-service-environment/architectures/app-service-environment-high-availability-deployment.yml)
- [Baseline zone-redundant web application](../../web-apps/app-service/architectures/baseline-zone-redundant.yml)
- [Deploy highly available NVAs](../../networking/guide/network-virtual-appliance-high-availability.md)
- [Highly available SharePoint farm](../../solution-ideas/articles/highly-available-sharepoint-farm.yml)
- [Recommendations for using availability zones and regions](/azure/well-architected/reliability/regions-availability-zones)

### Compliance and governance

- [Manage virtual machine compliance](../../example-scenario/security/virtual-machine-compliance.yml)

### Hybrid management

- [Azure Arc hybrid management and deployment for Kubernetes clusters](../../hybrid/arc-hybrid-kubernetes.yml)
- [Back up files and applications on Azure Stack Hub](/azure/backup/backup-mabs-files-applications-azure-stack)
- [Enable virtual machine protection in Azure Site Recovery](/azure-stack/operator/protect-virtual-machines)
- [Hybrid availability and performance monitoring](../../hybrid/hybrid-perf-monitoring.yml)

### Update management

- [Plan deployment for updating Windows VMs in Azure](../../example-scenario/wsus/index.yml)

## Best practices

The Azure Well-Architected Framework is a set of guiding tenets that you can use to improve the quality of your architectures. For management and governance best practices, see:

- [Regulatory compliance](/azure/architecture/framework/security/design-regulatory-compliance)
- [Administrative account security](/azure/architecture/framework/security/design-admins)

For more information, see:

- [Design area: Management for Azure environments](/azure/cloud-adoption-framework/ready/landing-zone/design-area/management?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)
- [Governance best practices](/security/compass/governance)

## Stay current with management and governance

Get the latest updates on [Azure management](https://azure.microsoft.com/updates/?category=management-tools) and [Azure governance](https://azure.microsoft.com/updates/?query=governance) technologies.

## Additional resources

Following are a few more management and governance architectures to consider:

- [Management and monitoring for an Azure VMware Solution enterprise-scale scenario](/azure/cloud-adoption-framework/scenarios/azure-vmware/eslz-management-and-monitoring)
- [Computer forensics chain of custody in Azure](../../example-scenario/forensics/index.yml)

### AWS or Google Cloud professionals

- [AWS to Azure services comparison - Management and governance](../../aws-professional/index.md#management-and-governance)
- [Google Cloud to Azure services comparison - Management](../../gcp-professional/services.md#management)
