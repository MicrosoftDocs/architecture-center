---
title: "Draft Document"
# Pandora-managed document — edit freely, chunks sync automatically
---

# Storage architecture design <!-- pandora:chunkId=category-architecture-design -->


## Architecture <!-- pandora:chunkId=architecture -->


## Explore Storage architectures and guides <!-- pandora:chunkId=explore-category-architectures-and-guides -->

The articles in this section include fully developed architectures that you can deploy in Azure and expand to production-grade solutions and guides. These can help you make important decisions about how you use Storage technologies in Azure. Solution ideas demonstrate implementation patterns and possibilities to consider as you plan your Storage proof-of-concept development.

### Storage architecture guides

**Technology choices** - These articles help you evaluate and select the best Storage technologies for your workload requirements:

- [ISSUE: Need to verify the correct URL for the storage technology choice guide at /azure/architecture/guide/technology-choices/storage-options] - Compare Azure Storage services and select the right option for your workload data requirements.

**Blob Storage** - Guidance for using Azure Blob Storage in your solutions:

- [Authorize access to blobs using Microsoft Entra ID](/azure/storage/blobs/authorize-access-azure-active-directory) - Configure identity-based access control for blob data using Microsoft Entra ID.
- [Security recommendations for Blob Storage](/azure/storage/blobs/security-recommendations) - Implement security best practices for protecting blob data.
- [Performance and scalability checklist for Blob Storage](/azure/storage/blobs/storage-performance-checklist) - Optimize blob storage performance and scale for your workload.

**Data Lake Storage** - Guidance for using Azure Data Lake Storage Gen2:

- [Best practices for using Azure Data Lake Storage Gen2](/azure/storage/blobs/data-lake-storage-best-practices) - Design and operate Data Lake Storage Gen2 for analytics workloads.
- [Azure Policy Regulatory Compliance controls for Azure Data Lake Storage Gen1](/azure/data-lake-store/security-controls-policy) - Apply compliance controls to Data Lake Storage Gen1 deployments.

**Azure Files** - Guidance for deploying and managing Azure Files:

- [Planning for an Azure Files deployment](/azure/storage/files/storage-files-planning) - Plan your Azure Files deployment including performance, networking, and identity requirements.
- [Overview of Azure Files identity-based authentication options for SMB access](/azure/storage/files/storage-files-active-directory-overview) - Configure Active Directory or Microsoft Entra ID authentication for file shares.
- [Disaster recovery and storage account failover](/azure/storage/common/storage-disaster-recovery-guidance) - Implement disaster recovery strategies for Azure Files.
- [About Azure file share backup](/azure/backup/azure-file-share-backup-overview) - Protect file shares with Azure Backup integration.

**Azure NetApp Files** - Guidance for enterprise file storage with Azure NetApp Files:

- [Solution architectures using Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-solution-architectures) - Explore reference architectures for common Azure NetApp Files scenarios.
- [Storage hierarchy of Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-understand-storage-hierarchy) - Understand capacity pools, volumes, and storage tiers.
- [Service levels for Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-service-levels) - Select the appropriate service level for your performance requirements.
- [Understand data protection and disaster recovery options in Azure NetApp Files](/azure/azure-netapp-files/data-protection-disaster-recovery-options) - Implement backup, replication, and disaster recovery for NetApp Files.
- [Guidelines for Azure NetApp Files network planning](/azure/azure-netapp-files/azure-netapp-files-network-topologies) - Design network connectivity for Azure NetApp Files deployments.
- [Quickstart: Set up Azure NetApp Files and NFS volume](/azure/azure-netapp-files/azure-netapp-files-quickstart-set-up-account-create-volumes) - Deploy your first Azure NetApp Files volume.

**Queue Storage** - Guidance for reliable messaging with Azure Queue Storage:

- [Authorize access to queues using Microsoft Entra ID](/azure/storage/queues/authorize-access-azure-active-directory) - Configure identity-based access control for queue data.
- [Performance and scalability checklist for Queue Storage](/azure/storage/queues/storage-performance-checklist) - Optimize queue storage performance for messaging workloads.

**Table Storage** - Guidance for NoSQL data storage with Azure Table Storage:

- [Authorize access to tables using Microsoft Entra ID (preview)](/azure/storage/tables/authorize-access-azure-active-directory) - Configure identity-based access control for table data.
- [Performance and scalability checklist for Table storage](/azure/storage/tables/storage-performance-checklist) - Optimize table storage performance and scale.
- [Design scalable and performant tables](/azure/storage/tables/table-storage-design) - Design table schemas for optimal performance and scalability.
- [Design for querying](/azure/storage/tables/table-storage-design-for-query) - Optimize table design for common query patterns.

**Disk Storage** - Guidance for block storage with Azure managed disks:

- [Server-side encryption of Azure Disk Storage](/azure/virtual-machines/disk-encryption) - Understand encryption at rest for managed disks.
- [Azure Disk Encryption for Windows VMs](/azure/virtual-machines/windows/disk-encryption-overview) - Implement full disk encryption for Windows virtual machines.
- [Azure premium storage: design for high performance](/azure/virtual-machines/premium-storage-performance) - Design for optimal performance with premium managed disks.
- [Scalability and performance targets for VM disks](/azure/virtual-machines/disks-scalability-targets) - Understand disk performance limits and scaling characteristics.

### Storage architectures

[ISSUE: Need Azure Architecture Center TOC for Storage category to populate this section with production-ready architecture links. Expected entries from /azure/architecture/example-scenario/, /azure/architecture/reference-architectures/, and /azure/architecture/solution-ideas/ filtered for Storage category.]

These production-ready architectures demonstrate end-to-end Storage solutions that you can deploy and customize:

- [Using Azure file shares in a hybrid environment](/azure/architecture/hybrid/azure-file-share) - Deploy Azure Files for hybrid cloud file sharing scenarios.
- [Azure files accessed on-premises and secured by AD DS](/azure/architecture/example-scenario/hybrid/azure-files-on-premises-authentication) - Integrate Azure Files with on-premises Active Directory for secure hybrid access.
- [Enterprise file shares with disaster recovery](/azure/architecture/example-scenario/file-storage/enterprise-file-shares-disaster-recovery) - Deploy enterprise file shares with built-in disaster recovery using Azure NetApp Files.
- [Hybrid file services](/azure/architecture/hybrid/hybrid-file-services) - Implement hybrid file services spanning on-premises and Azure.

### Storage solution ideas

[ISSUE: Need Azure Architecture Center TOC for Storage category to populate this section with solution idea links. Expected entries from /azure/architecture/solution-ideas/articles/ filtered for Storage category.]

These solution ideas demonstrate implementation patterns and possibilities to explore:

[ASSUMPTION: The example solutions listed in the author's document represent solution ideas, though they may need to be supplemented with additional entries from the Architecture Center TOC when available.]

## Learn about Storage on Azure <!-- pandora:chunkId=learn-about-category-on-azure -->


## Learning paths by role (OPTIONAL) <!-- pandora:chunkId=learning-paths-by-role -->


## Organizational readiness <!-- pandora:chunkId=organizational-readiness -->


## Best practices <!-- pandora:chunkId=best-practices -->


## OPTIONAL: Operations guide <!-- pandora:chunkId=optional-operations-guide -->


## Stay current with {category} <!-- pandora:chunkId=stay-current-with-category -->


## Additional resources <!-- pandora:chunkId=additional-resources -->


## OPTIONAL: Hybrid [and multi-cloud] <!-- pandora:chunkId=optional-hybrid-and-multi-cloud -->


## OPTIONAL: {Specialized topic 1} <!-- pandora:chunkId=optional-specialized-topic-1 -->


## OPTIONAL: {Specialized topic 2} <!-- pandora:chunkId=optional-specialized-topic-2 -->


## AWS or Google Cloud professionals (OPTIONAL) <!-- pandora:chunkId=aws-or-google-cloud-professionals -->

