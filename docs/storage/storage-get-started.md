---
title: Get Started with Storage Architecture Design
description: Get started with Azure storage architecture design by comparing storage service types, reviewing reference architectures, and applying readiness guidance.
ms.author: csiemens
author: claytonsiemens77
ms.update-cycle: 1095-days
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom: arb-data
ai-usage: ai-assisted
ms.date: 03/25/2026

---

# Get started with storage architecture design

Azure Storage provides a foundation for persisting, backing up, and sharing data across cloud workloads. It offers object storage for unstructured data, managed file shares for enterprise applications, and durable queues for asynchronous messaging, with the reliability, security, and performance that modern architectures require.

Azure Storage includes the following data services:

- [Azure Blob Storage](https://azure.microsoft.com/products/storage/blobs/) is a massively scalable object store for text and binary data. It supports big data analytics through Azure Data Lake Storage Gen2.

- [Azure Files](https://azure.microsoft.com/products/storage/files/) is a fully managed file share service for cloud or on-premises deployments.

- [Azure NetApp Files](https://azure.microsoft.com/products/netapp/) is a high‑performance, enterprise-grade file storage service designed for high performance and low latency.

- [Azure Queue Storage](https://azure.microsoft.com/products/storage/queues/) is a messaging store that enables reliable communication between application components.

- [Azure Table Storage](https://azure.microsoft.com/products/storage/tables/) is a NoSQL key-value store for schemaless storage of structured data.

- [Azure Disk Storage](https://azure.microsoft.com/products/storage/disks/) is a block-level storage service that provides durable, high-performance disks for Azure virtual machines (VMs).

To evaluate and compare Azure storage services for your workload, see [Storage options](/azure/architecture/guide/technology-choices/storage-options).

## Architecture

:::image type="complex" border="false" source="images/storage-get-started-diagram.svg" alt-text="Diagram that shows a baseline Azure storage architecture within an Azure subscription." lightbox="images/storage-get-started-diagram.svg":::
   Diagram that shows the solution journey for storage on Azure, which starts with learning and organizational readiness, then moves to selecting the appropriate Azure Storage services before it advances to implementation guidance and production deployment. A workload client connects to the Azure subscription boundary through VPN, Azure ExpressRoute, or a public IP address. Inside the subscription, a virtual network contains network ingress control like Azure Front Door, Azure Application Gateway, or Azure Load Balancer, along with a compute layer and an Azure Storage grouping. The storage grouping organizes services into three categories: general purpose, file share, and data migration and hybrid. General purpose includes Blob Storage, Data Lake Storage Gen2, Azure Files, Storage Queue, and Table Storage. File share includes Azure NetApp Files. Data migration and hybrid includes Azure Data Box, Azure Data Box Edge, Azure Managed Lustre, and Elastic SAN. Private endpoints connect the compute layer to the storage services. The subscription also includes Azure Bastion, public IP addresses, Azure DNS, user-defined routes (UDRs), network and application security groups, and managed identities. Cross‑cutting platform services include Microsoft Entra ID, Microsoft Cost Management, Azure Monitor, Microsoft Defender for Cloud, and Microsoft Purview.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/storage-get-started-diagram.vsdx) of this architecture.*

The previous diagram demonstrates a typical basic or baseline storage implementation. For real-world solutions that you can build in Azure, see [Storage architectures](#storage-architectures).

## Explore storage architectures and guides

The articles in this section include fully developed architectures that you can deploy in Azure and expand to production-grade solutions and guides. These articles can help you decide how to use Azure Storage technologies in Azure. Solution ideas demonstrate implementation patterns and possibilities to consider as you plan your storage proof-of-concept (POC) development.

### Storage guides

**Technology choices:** The following articles help you evaluate and select the best storage technologies for your workload requirements:

- [Storage options](/azure/architecture/guide/technology-choices/storage-options). Compare Azure storage services and select the right option for your workload data requirements.

### Storage architectures

The following production-ready architectures demonstrate end-to-end Azure Storage solutions that you can deploy and customize:

- [Azure file shares in a hybrid environment](/azure/architecture/hybrid/azure-file-share). Deploy Azure file shares alongside on-premises file servers in a hybrid configuration.

- [Azure files secured by Active Directory Domain Services (AD DS)](/azure/architecture/example-scenario/hybrid/azure-files-on-premises-authentication). Implement on-premises access to Azure Files with AD DS authentication.

- [Hybrid file services](/azure/architecture/hybrid/hybrid-file-services). Implement hybrid file services spanning on-premises and Azure environments.

#### Azure NetApp Files solutions

- [Enterprise file shares with disaster recovery (DR)](/azure/architecture/example-scenario/file-storage/enterprise-file-shares-disaster-recovery). Deploy enterprise file share infrastructure with built-in DR by using Azure NetApp Files.

- [Moodle deployment with Azure NetApp Files](/azure/architecture/example-scenario/file-storage/moodle-azure-netapp-files). Deploy Moodle with Azure NetApp Files for scalable, high-performance file storage.

- [Oracle Database with Azure NetApp Files](/azure/architecture/example-scenario/file-storage/oracle-azure-netapp-files). Run Oracle databases on Azure by using Azure NetApp Files for storage.

- [SQL Server on VMs with Azure NetApp Files](/azure/architecture/example-scenario/file-storage/sql-server-azure-netapp-files). Deploy SQL Server on Azure Virtual Machines with Azure NetApp Files for high-performance storage.

### Storage solution ideas

The following solution ideas demonstrate implementation patterns and possibilities to explore:

**Mainframe data storage:** Explore solutions for transferring and replicating mainframe data to Azure:

- [Back up mainframe file and tape to Azure by using Luminex](/azure/architecture/example-scenario/mainframe/luminex-mainframe-file-tape-transfer). Transfer mainframe file and tape data to Azure by using Luminex CloudConnect.

- [Mainframe file replication on Azure](/azure/architecture/solution-ideas/articles/mainframe-azure-file-replication). Replicate mainframe files to Azure with high fidelity and minimal disruption.

- [BMC AMI Cloud mainframe modernization](/azure/architecture/example-scenario/mainframe/mainframe-modernization-bmc-ami-cloud). Modernize mainframe workloads by using BMC AMI Cloud.

- [Move mainframe archive data to Azure](/azure/architecture/example-scenario/mainframe/move-archive-data-mainframes). Move mainframe archive data to Azure to reduce storage costs and improve accessibility.

## Learn about storage on Azure

[Microsoft Learn](/training/?WT.mc_id=learnaka) provides free online training resources for Azure storage technologies. The platform provides videos, tutorials, and interactive labs for specific products and services, along with learning paths organized by job role.

The following resources provide foundational knowledge for storage implementations on Azure:

- **Developer: [Store data in Azure](/training/paths/store-data-in-azure/)**. Learn the fundamentals of data storage on Azure, including how to choose storage approaches and how to work with different storage services.

- **Developer: [Develop solutions that use Blob storage](/training/paths/develop-solutions-that-use-blob-storage/)**. Create Blob Storage resources, manage data through the blob storage lifecycle, and work with the Blob Storage client library.

- **Administrator: [AZ-104: Implement and manage storage in Azure](/training/paths/az-104-manage-storage/)**. Set up storage accounts, Blob Storage, Azure Files, and storage security.

- **Data engineer: [Large-Scale Data Processing with Data Lake Storage Gen2](/training/paths/data-processing-with-azure-adls/). Set up Data Lake Storage Gen2, upload data, and secure your storage account.

## Organizational readiness

Organizations that start their cloud adoption can use the [Cloud Adoption Framework for Azure](/azure/cloud-adoption-framework/) to access proven guidance that accelerates cloud adoption. For cloud-scale Azure Storage guidance, see [Cloud-scale analytics](/azure/cloud-adoption-framework/scenarios/cloud-scale-analytics).

To help ensure the quality of your storage solution on Azure, follow the [Azure Well-Architected Framework](/azure/well-architected/). The Well-Architected Framework provides prescriptive guidance for organizations that seek architectural excellence and describes how to design, provision, and monitor cost-optimized Azure solutions.

For storage-specific guidance, see the following Well-Architected Framework service guides:

- [Architecture best practices for Blob Storage](/azure/well-architected/service-guides/azure-blob-storage)
- [Architecture best practices for Azure Files](/azure/well-architected/service-guides/azure-files)
- [Architecture best practices for Azure NetApp Files](/azure/well-architected/service-guides/azure-netapp-files)
- [Architecture best practices for Azure Disk Storage](/azure/well-architected/service-guides/azure-disk-storage)

## Best practices

Best practices for storage help you optimize costs, performance, security, and reliability. Depending on the Azure Storage technology that you use, see the following resources.

### Blob Storage

- [Authorize access to blobs by using Microsoft Entra ID](/azure/storage/blobs/authorize-access-azure-active-directory). Set up identity-based access control for blob data.

- [Security recommendations for Blob Storage](/azure/storage/blobs/security-recommendations). Implement security best practices for blob storage workloads.

- [Performance and scalability checklist for Blob Storage](/azure/storage/blobs/storage-performance-checklist). Optimize blob storage for high-performance scenarios.

### Azure Data Lake Storage

- [Best practices for using Data Lake Storage Gen2](/azure/storage/blobs/data-lake-storage-best-practices). Design and operate Data Lake Storage for analytics workloads.

- [Azure Policy Regulatory Compliance controls for Azure Data Lake Storage Gen1](/azure/data-lake-store/security-controls-policy). Apply compliance controls to Data Lake Storage Gen1.

### Azure Files

- [Plan for an Azure Files deployment](/azure/storage/files/storage-files-planning). Design Azure Files infrastructure for your requirements.

- [Overview of Azure Files identity-based authentication options for SMB access](/azure/storage/files/storage-files-active-directory-overview). Set up Active Directory integration for file shares.

- [DR and storage account failover](/azure/storage/common/storage-disaster-recovery-guidance). Plan for regional failures and account failover.

- [Azure file share backup](/azure/backup/azure-file-share-backup-overview). Implement backup protection for Azure Files.

### Azure NetApp Files

- [Solution architectures by using Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-solution-architectures). Explore reference architectures for Azure NetApp Files.

- [Storage hierarchy of Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-understand-storage-hierarchy). Learn about capacity pools, volumes, and quotas.

- [Service levels for Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-service-levels). Select the appropriate performance tier for your workload.

- [Learn about data protection and DR options in Azure NetApp Files](/azure/azure-netapp-files/data-protection-disaster-recovery-options). Implement backup and replication strategies.

- [Guidelines for Azure NetApp Files network planning](/azure/azure-netapp-files/azure-netapp-files-network-topologies). Design network connectivity for Azure NetApp Files.

- [Quickstart: Set up Azure NetApp Files and NFS volume](/azure/azure-netapp-files/azure-netapp-files-quickstart-set-up-account-create-volumes). Deploy your first Azure NetApp Files volume.

- [Performance considerations for Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-performance-considerations). Optimize Azure NetApp Files for performance requirements.

### Queue Storage

- [Authorize access to queues by using Microsoft Entra ID](/azure/storage/queues/authorize-access-azure-active-directory). Set up identity-based access for queue operations.

- [Performance and scalability checklist for Queue Storage](/azure/storage/queues/storage-performance-checklist). Optimize queue performance for high-throughput scenarios.

### Table Storage

- [Authorize access to tables by using Microsoft Entra ID (preview)](/azure/storage/tables/authorize-access-azure-active-directory). Set up identity-based access for table operations.

- [Performance and scalability checklist for Table storage](/azure/storage/tables/storage-performance-checklist). Optimize table storage for performance.

- [Design scalable and performant tables](/azure/storage/tables/table-storage-design). Apply design patterns for efficient table storage.

- [Design for querying](/azure/storage/tables/table-storage-design-for-query). Structure tables for optimal query performance.

- [Azure Storage table design patterns](/azure/storage/tables/table-storage-design-patterns). Implement proven design patterns for table storage scenarios.

### Azure Disk Storage

- [Server-side encryption of Azure Disk Storage](/azure/virtual-machines/disk-encryption). Learn about encryption options for managed disks.

- [Azure Disk Encryption for Windows VMs](/azure/virtual-machines/windows/disk-encryption-overview). Implement full disk encryption for Windows VMs.

- [Azure premium storage: design for high performance](/azure/virtual-machines/premium-storage-performance). Optimize disk performance for demanding workloads.

- [Scalability and performance targets for VM disks](/azure/virtual-machines/disks-scalability-targets). Learn about disk performance limits and sizing.

## Stay current with storage

Azure storage services evolve to address modern data challenges. Stay informed about the latest [updates and features](https://azure.microsoft.com/updates/).

To stay current with key Azure Storage services, see the following articles:

- [What's new in Azure Files?](/azure/storage/files/files-whats-new). New features and updates for Azure Files.

- [What's new in Azure NetApp Files?](/azure/azure-netapp-files/whats-new). New features and updates for Azure NetApp Files.

- [What's new in Azure Disk Storage?](/azure/virtual-machines/disks-whats-new). New capabilities and updates for Azure managed disks.

## Other resources

Storage is a broad category and covers a range of solutions. The following resources can help you discover more about Azure.

To plan for your storage needs, see [Review your storage options](/azure/cloud-adoption-framework/ready/considerations/storage-options).

### Hybrid storage

Most organizations need a hybrid approach to storage because their data resides both on-premises and in the cloud. Organizations typically [extend on-premises storage solutions to the cloud](/azure/architecture/hybrid/hybrid-file-services). To connect environments, organizations must [choose a hybrid network architecture](/azure/architecture/reference-architectures/hybrid-networking/).

Review the following key hybrid storage scenarios:

- [Azure enterprise cloud file share](/azure/architecture/hybrid/azure-files-private). Deploy a serverless Azure file share with private endpoint access in an enterprise environment.

- [Use Azure file shares in a hybrid environment](/azure/architecture/hybrid/azure-file-share). Deploy Azure file shares alongside on-premises file servers in a hybrid configuration.

- [Azure files accessed on-premises and secured by AD DS](/azure/architecture/example-scenario/hybrid/azure-files-on-premises-authentication). Implement on-premises access to Azure Files with Active Directory authentication.

- [Enterprise file shares with DR](/azure/architecture/example-scenario/file-storage/enterprise-file-shares-disaster-recovery). Deploy enterprise file share infrastructure with built-in DR by using Azure NetApp Files.

- [Hybrid file services](/azure/architecture/hybrid/hybrid-file-services). Implement hybrid file services spanning on-premises and Azure environments.

- [Guidelines for Azure NetApp Files network planning](/azure/azure-netapp-files/azure-netapp-files-network-topologies). Design network connectivity for Azure NetApp Files in hybrid scenarios.

### Data migration

Data migration planning helps you choose the right strategy and tools for moving data to Azure Storage. Organizations can migrate data from on-premises systems, other cloud providers, or scale existing storage infrastructure.

- [Azure Storage migration overview](/azure/storage/common/storage-migration-overview). Evaluate migration strategies and tools for moving data to Azure Storage.

- [Data transfer for large datasets](/azure/storage/common/storage-solution-large-dataset-low-network). Choose the right transfer method for large-scale data migration scenarios with limited network bandwidth.

- [Azure Data Box documentation](/azure/databox/). Transfer large volumes of data to Azure when network transfer isn't practical.

## Amazon Web Services (AWS) or Google Cloud professionals

To help you ramp up quickly, the following articles compare Azure storage options to other cloud services:

### Service comparison

- [Compare AWS and Azure Storage services](/azure/architecture/aws-professional/storage): Service mapping and comparison between AWS and Azure storage offerings.

- [Google Cloud to Azure services comparison](/azure/architecture/gcp-professional/services#storage): Service mapping and comparison between Google Cloud and Azure storage offerings.
