---
title: Storage architecture design
description: Get an overview of Azure Storage technologies, guidance offerings, solution ideas, and reference architectures.  
author: claytonsiemens77
ms.author: pnp 
ms.date: 02/13/2026
ms.topic: concept-article
ms.subservice: architecture-guide
ai-usage: ai-assisted
ms.custom: 
- overview
- fcp
--- 

# Storage architecture design

The Azure Storage platform is the Microsoft cloud storage solution for modern data storage scenarios.

The Azure Storage platform includes the following data services:

- [Azure Blob Storage](https://azure.microsoft.com/services/storage/blobs): A massively scalable object store for text and binary data. Also includes support for big data analytics through Azure Data Lake Storage Gen2.
- [Azure Files](https://azure.microsoft.com/services/storage/files): Managed file shares for cloud or on-premises deployments.
- [Azure NetApp Files](https://azure.microsoft.com/products/netapp/): An Azure native, first-party, enterprise-class, high-performance file storage service.
- [Azure Queue Storage](https://azure.microsoft.com/services/storage/queues): A messaging store for reliable messaging between application components.
- [Azure Table Storage](https://azure.microsoft.com/services/storage/tables): A NoSQL store for schemaless storage of structured data.
- [Azure Disk Storage](https://azure.microsoft.com/services/storage/disks): Block-level storage volumes for Azure VMs.

## Architecture

:::image type="complex" border="false" source="_images/storage-get-started-diagram.png" alt-text="Diagram that shows the storage solution journey on Azure." lightbox="_images/storage-get-started-diagram.png":::
   Diagram showing the solution journey for storage on Azure. The journey starts with learning and organizational readiness, then moves to selecting the appropriate Azure Storage services based on workload requirements, including Blob Storage, Azure Files, Azure NetApp Files, Queue Storage, Table Storage, and Disk Storage, followed by implementation guidance and production deployment.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/storage-get-started-diagram.vsdx) of this architecture.*

The diagram above demonstrates a typical baseline Storage implementation on Azure. The Azure Storage platform includes multiple data services: Blob Storage for object storage and big data analytics, Azure Files and Azure NetApp Files for managed file shares, Queue Storage for reliable messaging, Table Storage for NoSQL data, and Disk Storage for VM volumes. Refer to the [architectures](#explore-storage-architectures-and-guides) provided in this article to find real-world solutions that you can build in Azure.

## Explore Storage architectures and guides

The articles in this section include fully developed architectures that you can deploy in Azure and expand to production-grade solutions and guides. These can help you make important decisions about how you use Storage technologies in Azure. Solution ideas demonstrate implementation patterns and possibilities to consider as you plan your Storage proof-of-concept development.

### Storage architecture guides

**Technology choices** - These articles help you evaluate and select the best Storage technologies for your workload requirements:

- [Storage options](/azure/architecture/guide/technology-choices/storage-options) - Compare Azure storage services and select the right option for your workload data requirements.

### Storage architectures

These production-ready architectures demonstrate end-to-end Storage solutions that you can deploy and customize:

- [Azure file shares in a hybrid environment](/azure/architecture/hybrid/azure-file-share) - Deploy Azure file shares alongside on-premises file servers in a hybrid configuration.
- [Azure files secured by AD DS](/azure/architecture/example-scenario/hybrid/azure-files-on-premises-authentication) - Implement on-premises access to Azure Files with Active Directory authentication.
- [Hybrid file services](/azure/architecture/hybrid/hybrid-file-services) - Implement hybrid file services spanning on-premises and Azure environments.

**Azure NetApp Files solutions**

- [Enterprise file shares with disaster recovery](/azure/architecture/example-scenario/file-storage/enterprise-file-shares-disaster-recovery) - Deploy enterprise file share infrastructure with built-in disaster recovery using Azure NetApp Files.
- [Moodle deployment with Azure NetApp Files](/azure/architecture/example-scenario/file-storage/moodle-azure-netapp-files) - Deploy Moodle with Azure NetApp Files for scalable, high-performance file storage.
- [Oracle Database with Azure NetApp Files](/azure/architecture/example-scenario/file-storage/oracle-azure-netapp-files) - Run Oracle databases on Azure using Azure NetApp Files for storage.
- [SQL Server on VMs with Azure NetApp Files](/azure/architecture/example-scenario/file-storage/sql-server-azure-netapp-files) - Deploy SQL Server on Azure Virtual Machines with Azure NetApp Files for high-performance storage.

**Mainframe storage**

- [Back up mainframe file and tape to Azure by using Luminex](/azure/architecture/example-scenario/mainframe/luminex-mainframe-file-tape-transfer) - Transfer mainframe file and tape data to Azure by using Luminex CloudConnect.
- [Mainframe file replication on Azure](/azure/architecture/solution-ideas/articles/mainframe-azure-file-replication) - Replicate mainframe files to Azure with high fidelity and minimal disruption.
- [BMC AMI Cloud mainframe modernization](/azure/architecture/example-scenario/mainframe/mainframe-modernization-bmc-ami-cloud) - Modernize mainframe workloads by using BMC AMI Cloud.
- [Move mainframe archive data to Azure](/azure/architecture/example-scenario/mainframe/move-archive-data-mainframes) - Move mainframe archive data to Azure to reduce storage costs and improve accessibility.


## Learn about Storage on Azure

[Microsoft Learn](/training/?WT.mc_id=learnaka) provides free online training resources for Azure Storage technologies. The platform offers videos, tutorials, and hands-on labs for specific products and services, along with learning paths organized by job role.

The following resources provide foundational knowledge for Storage implementations on Azure:

### Learning paths by role

- **Developer**: [Store data in Azure](/training/paths/store-data-in-azure) - Learn the fundamentals of data storage on Azure, including choosing storage approaches and working with different storage services.
- **Developer**: [Develop solutions that use Blob storage](/training/paths/develop-solutions-that-use-blob-storage/) - Create Blob Storage resources, manage data through the blob storage lifecycle, and work with the Azure Blob Storage client library.
- **Administrator**: [AZ-104: Implement and manage storage in Azure](/training/paths/az-104-manage-storage/) - Configure storage accounts, Azure Blob Storage, Azure Files, and storage security.
- **Data engineer**: [Large-Scale Data Processing with Azure Data Lake Storage Gen2](/training/paths/data-processing-with-azure-adls/) - Set up Azure Data Lake Storage Gen2, upload data, and secure your storage account.

## Organizational readiness

Organizations that are beginning their cloud adoption can use the [Cloud Adoption Framework](/azure/cloud-adoption-framework/) for proven guidance designed to accelerate cloud adoption. To evaluate which Azure storage services fit your workload requirements, see [Review your storage options](/azure/cloud-adoption-framework/ready/considerations/storage-options).

To help assure the quality of your Storage solution on Azure, we recommend following the [Azure Well-Architected Framework (WAF)](/azure/well-architected/). WAF provides prescriptive guidance for organizations seeking architectural excellence and discusses how to design, provision, and monitor cost-optimized Azure solutions. For Storage-specific guidance, see the Azure Well-Architected Framework service guides for:

- [Azure Blob Storage](/azure/well-architected/service-guides/azure-blob-storage)
- [Azure Files](/azure/well-architected/service-guides/azure-files)
- [Azure NetApp Files](/azure/well-architected/service-guides/azure-netapp-files)
- [Azure Disk Storage](/azure/well-architected/service-guides/azure-disk-storage)

## Best practices

Depending on the Storage technology you use, see the following best practices resources:

### Blob Storage

See the following guides for information about Blob Storage:

- [Authorize access to blobs using Microsoft Entra ID](/azure/storage/blobs/authorize-access-azure-active-directory) - Configure identity-based access control for blob data.
- [Security recommendations for Blob Storage](/azure/storage/blobs/security-recommendations) - Implement security best practices for blob storage workloads.
- [Performance and scalability checklist for Blob Storage](/azure/storage/blobs/storage-performance-checklist) - Optimize blob storage for high-performance scenarios.

### Azure Data Lake Storage

See the following guides for information about Data Lake Storage:

- [Best practices for using Azure Data Lake Storage Gen2](/azure/storage/blobs/data-lake-storage-best-practices) - Design and operate Data Lake Storage for analytics workloads.
- [Azure Policy Regulatory Compliance controls for Azure Data Lake Storage Gen1](/azure/data-lake-store/security-controls-policy) - Apply compliance controls to Data Lake Storage Gen1.

### Azure Files

See the following guides for information about Azure Files:

- [Planning for an Azure Files deployment](/azure/storage/files/storage-files-planning) - Design Azure Files infrastructure for your requirements.
- [Overview of Azure Files identity-based authentication options for SMB access](/azure/storage/files/storage-files-active-directory-overview) - Configure Active Directory integration for file shares.
- [Disaster recovery and storage account failover](/azure/storage/common/storage-disaster-recovery-guidance) - Plan for regional failures and account failover.
- [About Azure file share backup](/azure/backup/azure-file-share-backup-overview) - Implement backup protection for Azure Files.

### Azure NetApp Files

See the following guides for information about Azure NetApp Files:

- [Solution architectures using Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-solution-architectures) - Explore reference architectures for Azure NetApp Files.
- [Storage hierarchy of Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-understand-storage-hierarchy) - Understand capacity pools, volumes, and quotas.
- [Service levels for Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-service-levels) - Select the appropriate performance tier for your workload.
- [Understand data protection and disaster recovery options in Azure NetApp Files](/azure/azure-netapp-files/data-protection-disaster-recovery-options) - Implement backup and replication strategies.
- [Guidelines for Azure NetApp Files network planning](/azure/azure-netapp-files/azure-netapp-files-network-topologies) - Design network connectivity for Azure NetApp Files.
- [Quickstart: Set up Azure NetApp Files and NFS volume](/azure/azure-netapp-files/azure-netapp-files-quickstart-set-up-account-create-volumes) - Deploy your first Azure NetApp Files volume.
- [Performance considerations for Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-performance-considerations) - Optimize Azure NetApp Files for performance requirements.

### Queue Storage

See the following guides for information about Queue Storage:

- [Authorize access to queues using Microsoft Entra ID](/azure/storage/queues/authorize-access-azure-active-directory) - Configure identity-based access for queue operations.
- [Performance and scalability checklist for Queue Storage](/azure/storage/queues/storage-performance-checklist) - Optimize queue performance for high-throughput scenarios.

### Table Storage

See the following guides for information about Table Storage:

- [Authorize access to tables using Microsoft Entra ID (preview)](/azure/storage/tables/authorize-access-azure-active-directory) - Configure identity-based access for table operations.
- [Performance and scalability checklist for Table storage](/azure/storage/tables/storage-performance-checklist) - Optimize table storage for performance.
- [Design scalable and performant tables](/azure/storage/tables/table-storage-design) - Apply design patterns for efficient table storage.
- [Design for querying](/azure/storage/tables/table-storage-design-for-query) - Structure tables for optimal query performance.
- [Azure Storage table design patterns](/azure/storage/tables/table-storage-design-patterns) - Implement proven design patterns for table storage scenarios.

### Azure Disk Storage

See the following guides for information about Azure managed disks:

- [Server-side encryption of Azure Disk Storage](/azure/virtual-machines/disk-encryption) - Understand encryption options for managed disks.
- [Azure Disk Encryption for Windows VMs](/azure/virtual-machines/windows/disk-encryption-overview) - Implement full disk encryption for Windows virtual machines.
- [Azure premium storage: design for high performance](/azure/virtual-machines/premium-storage-performance) - Optimize disk performance for demanding workloads.
- [Scalability and performance targets for VM disks](/azure/virtual-machines/disks-scalability-targets) - Understand disk performance limits and sizing.

## Stay current with Storage

Azure Storage services are evolving to address modern data challenges. You can get the latest updates on [Azure products and features](https://azure.microsoft.com/updates/).

To stay current with key Storage services, see:

- [Azure Storage updates](https://azure.microsoft.com/updates/?filter=storage) - Latest updates across all Azure Storage products and features.

## Additional resources

Storage is a broad category and covers a range of solutions. The following resources can help you discover more about Azure.

To plan for your storage needs, see [Review your storage options](/azure/cloud-adoption-framework/ready/considerations/storage-options).

## Hybrid storage

The vast majority of organizations need a hybrid approach to storage because their data is hosted both on-premises and in the cloud. Organizations often [extend on-premises storage solutions to the cloud](/azure/architecture/hybrid/hybrid-file-services). To connect environments, organizations must [choose a hybrid network architecture](/azure/architecture/reference-architectures/hybrid-networking/index).

Key hybrid storage scenarios:

- [Azure enterprise cloud file share](/azure/architecture/hybrid/azure-files-private) - Deploy a serverless Azure file share with private endpoint access in an enterprise environment.
- [Using Azure file shares in a hybrid environment](/azure/architecture/hybrid/azure-file-share) - Deploy Azure file shares alongside on-premises file servers in a hybrid configuration.
- [Azure files accessed on-premises and secured by AD DS](/azure/architecture/example-scenario/hybrid/azure-files-on-premises-authentication) - Implement on-premises access to Azure Files with Active Directory authentication.
- [Enterprise file shares with disaster recovery](/azure/architecture/example-scenario/file-storage/enterprise-file-shares-disaster-recovery) - Deploy enterprise file share infrastructure with built-in disaster recovery using Azure NetApp Files.
- [Hybrid file services](/azure/architecture/hybrid/hybrid-file-services) - Implement hybrid file services spanning on-premises and Azure environments.
- [Guidelines for Azure NetApp Files network planning](/azure/azure-netapp-files/azure-netapp-files-network-topologies) - Design network connectivity for Azure NetApp Files in hybrid scenarios.

## AWS or Google Cloud professionals

These articles can help you ramp up quickly by comparing Azure Storage options to other cloud services:

- [Compare AWS and Azure Storage services](/azure/architecture/aws-professional/storage) - Service mapping and comparison between AWS and Azure storage offerings.
- [Google Cloud to Azure services comparison - Storage](/azure/architecture/gcp-professional/services#storage) - Service mapping and comparison between Google Cloud and Azure storage offerings.
