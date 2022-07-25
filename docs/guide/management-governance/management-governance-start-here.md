---
title: Management and governance architecture design
description: Get an overview of Azure management and governance technologies, guidance offerings, solution ideas, and reference architectures.
author: EdPrice-MSFT
ms.author: edprice
ms.date: 07/27/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure-attestation
  - azure-purview
  - azure-policy
  - azure-stack
  - azure-backup
categories:
  - management-and-governance
  - hybrid
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
- [Azure Purview](https://azure.microsoft.com/services/purview). Govern, protect, and manage your data estate.
- [Azure Policy](https://azure.microsoft.com/services/azure-policy). Achieve real-time cloud compliance at scale with consistent resource governance.
- [Azure Stack](https://azure.microsoft.com/products/azure-stack). Locate technologies and services based on your business requirements. Meet custom compliance, sovereignty, and data gravity requirements.
- [Azure Backup](https://azure.microsoft.com/services/backup). Define backup policies and provide protection for a wide range of enterprise workloads.
- [Azure Site Recovery](https://azure.microsoft.com/services/site-recovery). Keep your business running with built-in disaster recovery service.
- [Azure Archive Storage](https://azure.microsoft.com/services/storage/archive). Store rarely accessed data.
- [Azure Monitor](https://azure.microsoft.com/services/monitor). Get full observability into your applications, infrastructure, and network.

## Introduction to management and governance on Azure

If you're new to management and governance on Azure, the best way to learn more is with [Microsoft Learn](/learn/?WT.mc_id=learnaka), a free online training platform. Microsoft Learn provides interactive training for Microsoft products and more.

Here are some resources to get you started:

- Learning path: [Manage information protection and governance](/learn/paths/m365-compliance-information) 
- Module: [Design an enterprise governance strategy](/learn/modules/enterprise-governance)
- Module: [Design a solution for backup and disaster recovery](/learn/modules/design-solution-for-backup-disaster-recovery)

## Path to production

The following sections provide links to reference architectures in some key management and governance categories:

### Backup

- [Azure Backup architecture and components](/azure/backup/backup-architecture)
- [Support matrix for Azure Backup](/azure/backup/backup-support-matrix)
- [Backup cloud and on-premises workloads to cloud](/azure/backup/guidance-best-practices)

### Disaster recovery

- [Azure to Azure disaster recovery architecture](/azure/site-recovery/azure-to-azure-architecture)
- [Support matrix for Azure VM disaster recovery between Azure regions](/azure/site-recovery/azure-to-azure-support-matrix?toc=https%3A%2F%2Fdocs.microsoft.com%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Fdocs.microsoft.com%2Fazure%2Farchitecture%2Fbread%2Ftoc.json)
- [Integrate ExpressRoute with disaster recovery for Azure VMs](/azure/site-recovery/azure-vm-disaster-recovery-with-expressroute?toc=https%3A%2F%2Fdocs.microsoft.com%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Fdocs.microsoft.com%2Fazure%2Farchitecture%2Fbread%2Ftoc.json)
- [Recover from a region-wide service disruption](/azure/architecture/resiliency/recovery-loss-azure-region)
- [Move Azure VMs to another Azure region](/azure/site-recovery/azure-to-azure-move-overview?toc=https%3A%2F%2Fdocs.microsoft.com%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Fdocs.microsoft.com%2Fazure%2Farchitecture%2Fbread%2Ftoc.json)
- [Business continuity and disaster recovery (BCDR) for Azure VMware Solution enterprise-scale scenario](/azure/cloud-adoption-framework/scenarios/azure-vmware/eslz-business-continuity-and-disaster-recovery?toc=https%3A%2F%2Fdocs.microsoft.com%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Fdocs.microsoft.com%2Fazure%2Farchitecture%2Fbread%2Ftoc.json)
- [Enterprise-scale disaster recovery](/azure/architecture/solution-ideas/articles/disaster-recovery-enterprise-scale-dr)
- [SMB disaster recovery with Azure Site Recovery](/azure/architecture/solution-ideas/articles/disaster-recovery-smb-azure-site-recovery)
- [SMB disaster recovery with Double-Take DR](/azure/architecture/solution-ideas/articles/disaster-recovery-smb-double-take-dr)
- [Disaster recovery for enterprise bots](/azure/architecture/solution-ideas/articles/enterprise-chatbot-disaster-recovery)
- [Use Azure Stack HCI stretched clusters for disaster recovery](/azure/architecture/hybrid/azure-stack-hci-dr)

### High availability

- [Build high availability into your BCDR strategy](/azure/architecture/solution-ideas/articles/build-high-availability-into-your-bcdr-strategy)
- [High availability and disaster recovery scenarios for IaaS apps](/azure/architecture/example-scenario/infrastructure/iaas-high-availability-disaster-recovery)
- [High availability enterprise deployment using App Service Environment](/architecture/reference-architectures/enterprise-integration/ase-high-availability-deployment)
- [Highly available multi-region web application](/azure/architecture/reference-architectures/app-service-web-app/multi-region)
- [Deploy highly available NVAs](/azure/architecture/reference-architectures/dmz/nva-ha)
- [Highly available SharePoint farm](/azure/architecture/solution-ideas/articles/highly-available-sharepoint-farm)
- [Run a highly available SharePoint Server 2016 farm in Azure](/azure/architecture/reference-architectures/sharepoint)
- [Build solutions for high availability using availability zones](/azure/architecture/high-availability/building-solutions-for-high-availability)

### Compliance and governance

- [Manage virtual machine compliance](/azure/architecture/example-scenario/security/virtual-machine-compliance)
- [Custom data sovereignty and data gravity requirements](/azure/architecture/solution-ideas/articles/data-sovereignty-and-gravity)
- [End-to-end governance in Azure when using CI/CD](/azure/architecture/example-scenario/governance/end-to-end-governance-in-azure)
- [Introduction of an AKS regulated cluster for PCI-DSS 3.2.1](/azure/architecture/reference-architectures/containers/aks-pci/aks-pci-intro)

### Hybrid management

- [Azure Arc hybrid management and deployment for Kubernetes clusters](/azure/architecture/hybrid/arc-hybrid-kubernetes)
- [Azure Automation in a hybrid environment](/azure/architecture/hybrid/azure-automation-hybrid)
- [Azure Automation update management](/azure/architecture/hybrid/azure-update-mgmt)
- [Back up files and applications on Azure Stack Hub](/azure/architecture/hybrid/azure-stack-backup)
- [Disaster recovery for Azure Stack Hub virtual machines](/azure/architecture/hybrid/azure-stack-vm-disaster-recovery)
- [Hybrid availability and performance monitoring](/azure/architecture/hybrid/hybrid-perf-monitoring)
- [Manage configurations for Azure Arc-enabled servers](/azure/architecture/hybrid/azure-arc-hybrid-config)
- [Manage hybrid Azure workloads using Windows Admin Center](/azure/architecture/hybrid/hybrid-server-os-mgmt)

### Update management

- [Plan deployment for updating Windows VMs in Azure](/azure/architecture/example-scenario/wsus)
- [Azure Automation update management](/azure/architecture/hybrid/azure-update-mgmt)

## Best practices

The Azure Well-Architected Framework is a set of guiding tenets that you can use to improve the quality of your architectures. For management and governance best practices, see:

- [Regulatory compliance](/azure/architecture/framework/security/design-regulatory-compliance)
- [Administrative account security](/azure/architecture/framework/security/design-admins)

For additional guidance, see:

- [Design area: Management for Azure environments](/azure/cloud-adoption-framework/ready/landing-zone/design-area/management?toc=https%3A%2F%2Fdocs.microsoft.com%2Fen-us%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Fdocs.microsoft.com%2Fen-us%2Fazure%2Farchitecture%2Fbread%2Ftoc.json)
- [Governance best practices](/security/compass/governance)


## Stay current with management and governance

Get the latest updates on [Azure management](https://azure.microsoft.com/updates/?category=management-tools) and [Azure governance](https://azure.microsoft.com/updates/?query=governance%20management) technologies.

## Additional resources

Following are a few more management and governance architectures to consider: 

- [Archive on-premises data to the cloud](/azure/architecture/solution-ideas/articles/backup-archive-on-premises)
- [Management and monitoring for an Azure VMware Solution enterprise-scale scenario](/azure/cloud-adoption-framework/scenarios/azure-vmware/eslz-management-and-monitoring?toc=https%3A%2F%2Fdocs.microsoft.com%2Fen-us%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Fdocs.microsoft.com%2Fen-us%2Fazure%2Farchitecture%2Fbread%2Ftoc.json)
- [Computer forensics chain of custody in Azure](/azure/architecture/example-scenario/forensics)
- [Deploy a line-of-business application using Azure App Service Environment v3](/azure/architecture/example-scenario/apps/line-of-business-internal-app-service-environment-v3)
- [Centralized app configuration and security](/azure/architecture/solution-ideas/articles/appconfig-key-vault)


### AWS or Google Cloud professionals

- [AWS to Azure services comparison - Management and governance](/azure/architecture/aws-professional/services#management-and-governance)
- [Google Cloud to Azure services comparison - Management](/azure/architecture/gcp-professional/services#management)