The solution demonstrates how to enhance performance, availability, and improve data management, resource utilization of databases and shared file systems by utilizing [Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-introduction) as the storage solution for Siemens Teamcenter Product Lifecycle Management (PLM).  Azure NetApp Files provides key data backup and redundancy features to improve the availability of your Siemens Teamcenter PLM data. 

**Data backups:** Azure NetApp Files provides two data backup options: snapshots and backup. Snapshots provide a point-in-time backup of data. They allow you to quickly recover data in the event of data loss or corruption. Azure NetApp Files also has a fully managed backup solution. It provides long-term retention and recovery options for snapshots. You can combine snapshots and backups for a comprehensive backup and recovery solution. 

**Data redundancy:** For high-availability purposes Azure NetApp Files offers two key functionalities: availability zone volume placement and cross-zone replication. 

## Architecture

This is a multi-zone deployment of Siemens Teamcenter PLM on Azure NetApp Files, designed to deliver exceptional performance, scalability, and high availability. By harnessing the power of Azure NetApp Files'  volume placement and replication capabilities across multiple [Azure Availability Zones](/azure/reliability/availability-zones-overview#availability-zones), this architecture ensures best performance, data resilience and fault tolerance, allowing organizations to confidently manage their product lifecycle processes with efficiency and reliability. With the ability to seamlessly distribute and replicate data across availability zones, Siemens Teamcenter PLM running on Azure NetApp Files provides a robust foundation for organizations seeking a resilient and scalable PLM solution in the cloud.

image 

link 

Figure 1. Siemens Teamcenter PLM with Azure NetApp Files. Download Visio architecture. 

**Availability zones:** The architecture uses two availability zones and replicates data across zones. This ensures the integrity and availability of data, protecting against potential data loss or corruption. The availability zones enable scalability and allow the Siemens Teamcenter PLM to expand on a user base. This flexibility allows businesses to meet evolving demands without sacrificing availability or performance.

**Resource tier:** Siemens Teamcenter PLM relies heavily on Resource Tier to provide a scalable and reliable platform for managing product data and collaborating across teams and organizations. The *Resource Tier* provides access to resources such as documents, 3D models, and drawings. This tier includes the Master and Failover databases. The databases store database server data and log volumes. The Resource tier also houses the Root FSC file server that stores digital assets (metadata) associated with the product data. It handles CAD files stored on data volumes. 

The architecture centralizes the digital assets and product data in the Root FSC servers and storage volumes in the same availability zone so that users can access the necessary data more quickly and easily. This tier also provides services for managing and maintaining these resources, such as file versioning, revision control, and access permissions, which in many cases leverage Azure NetApp Files storage capabilities to function.

**Storage subnet:** The architecture deploys Azure NetApp Files volumes to the Storage subnet. Azure NetApp provides essential storage for Siemens Teamcenter PLM product data and digital assets. 

**Dataflow:** The databases and the Root FSC servers in the Resource tier store and retrieve data from Azure NetApp Files volumes. The  dataflow between the different tiers of architecture provides efficient and secure access to product data and digital assets, since Azure NetApp Files volumes are hosted directly within the secure confines of the customer VNet, within availability zones. The architecture also ensures scalability and reliability, by virtue of Azure NetApp Files on-demand, non-disruptive scalability and high availability across availability zones.

**Data replication:** The architecture uses SQL Server Always On Availability Groups to synchronously replicate the database across availabilities zones. Azure NetApp Files uses cross-zone replication to asynchronously replicate data across availability zones. 

## Considerations 

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview). Azure NetApp Files provides high availability with [built-in data replication, failover, and disaster recovery capabilities](/azure/azure-netapp-files/snapshots-introduction). This means that your Teamcenter PLM database and CAD files will be always available, even in the event of a regional, zonal or software failure.

NetApp Files provides a standard 99.99% availability [SLA](https://www.microsoft.com/licensing/docs/view/Service-Level-Agreements-SLA-for-Online-Services) for all tiers and all supported regions. Azure NetApp Files also supports provisioning volumes in [availability zones](/azure/azure-netapp-files/use-availability-zones) that you choose, and HA deployments across zones. With Azure NetApp Files, you have two backup options for Siemens Teamcenter PLM data: snapshots and backup. Both snapshots and backup solutions can be used together for a comprehensive backup and recovery solution, ensuring that Siemens Teamcenter PLM data is always protected and available when needed.

**Replicate data across availability zones.** Azure NetApp Files offers two important features: [Availability Zone volume placement](/azure/azure-netapp-files/use-availability-zones) and [cross-zone replication](/azure/azure-netapp-files/cross-zone-replication-introduction). Both contribute to high availability (HA) architectures across availability zones for Siemens Teamcenter Root FSC and Oracle or SQL database servers. 

It is highly recommended to use Availability Zone volume placement to ensure that the Siemens Teamcenter Oracle or SQL database servers, along with their associated data, are located within the same availability zone. This placement enhances performance by reducing network latency and provides fault isolation, enabling seamless failover within the availability zone in case of failure when implemented in combination with Oracle Data Guard or SQL Server Always On Availability Groups.

You should use cross-zone replication when you require data redundancy and high availability across multiple availability zones, and do not want to leverage/require application-level replication. By replicating data using cross-zone replication, any changes made in one availability zone are automatically replicated to volumes in other zones, ensuring data consistency and enabling failover to a secondary zone in case of a zone-level failure. This feature enhances data protection, disaster recovery, and overall system resilience for Siemens Teamcenter Root FSC file data.

**Configure Azure NetApp Files snapshots.** Snapshots provide a point-in-time backup of the data, enabling quick recovery in the event of data loss or corruption. These can be scheduled to occur automatically on a regular basis or taken manually when required. Up to 255 snapshots per volume can be taken with Azure NetApp Files, giving plenty of restore points.

You can set up Azure NetApp Files snapshots via schedule policy or manually in the Azure portal or with the Azure SDK/API. Depending on application consistency requirements, one of the two methods is required.

- *For applications (like Oracle or SQL Server) that require application consistency create snapshots manually.* Since SQL Server and Oracle databases have an application consistency requirement when using storage-based snapshots it is required to ensure correct application-to-storage-snapshot orchestration occurs. This is achieved by enabling an application freeze-snapshot-thaw cycle such that snapshots can be taken consistently, whilst database operation occurs without interruption. Refer to these articles for guidance on [SQL Server snapshot consistency](https://techcommunity.microsoft.com/t5/azure-architecture-blog/managing-sql-server-2022-t-sql-snapshot-backup-with-azure-netapp/ba-p/3654798) or [Oracle snapshot consistency](/azure/azure-netapp-files/azacsnap-introduction) with Azure NetApp Files.
- *Use a snapshot policy for Root FSC file data.* The Root FSC file data hosted on Azure NetApp Files volumes on the other hand does not require any application consistency or orchestration, as those are general file shares. As such it is recommended to use an [Azure NetApp Files snapshot policy](/azure/azure-netapp-files/snapshots-manage-policy) to automatically schedule and initiate snapshots at desired intervals.

**Configure Azure NetApp Files backup.** [Azure NetApp Files backup](/azure/azure-netapp-files/backup-introduction) expands the data protection capabilities of Azure NetApp Files by providing fully managed backup solution for long-term recovery, archive, and compliance. The service stores backups in Azure storage. These backups are independent from volume snapshots that are available for near-term recovery or cloning. You can restore backups taken by the service to new Azure NetApp Files volumes within the region. Azure NetApp Files backup supports both policy-based (scheduled) backups and manual (on-demand) backups.  

**Use NetApp file/folder and volume restore options.** Azure NetApp Files supports (1) file/folder granular restore and (2) volume restore options. Both are beneficial for Siemens Teamcenter PLM data recovery *(see Figure 2)*.

(1) File/folder granular restore allows for the recovery of specific files or folders from a snapshot or backup. This option is useful when only certain data needs to be restored, saving time and storage space. Azure NetApp Files' snapshot feature allows for rapid recovery of data. With snapshots, users can recover data quickly and easily from previous points in time without having to restore it from a backup. This feature can help to quickly restore individual files that may have been accidentally deleted or corrupted.

(2) Volume restore allows for the recovery of an entire volume from a snapshot or backup. This option is useful when an entire volume has been lost or corrupted and a complete restore is necessary (ransomware attack). In the case of Siemens Teamcenter PLM data, this feature can help to quickly restore an entire volume of data, including CAD files, application and database servers, and other critical data.

- *Take regular snapshots.* By taking regular snapshots of the data, users can restore the system to a previous state in a matter of minutes, minimizing any potential downtime and ensuring that critical data is always available when needed. The ability to quickly restore data from snapshots, along with the granular restore and volume restore options, make Azure NetApp Files a reliable and efficient backup and recovery solution for Siemens Teamcenter PLM data.
- *Use file/folder and volume restore from snapshots.* There are three major areas in Siemens Teamcenter PLM architecture where advanced data protection and recoverability are important and where snapshots ensure fast protection and recovery: (1) individual file restores from file repository (file shares), (2) database data consistent backups, and (3) volume restores to recover from virus and ransomware attacks as well as database issues.

image 

Figure 2. Azure NetApp Files snapshot restore options specific to Teamcenter PLM application areas

By using both file/folder granular restore and volume restore options, you have a comprehensive backup and recovery solution with the ability to recover data at both the file/folder and volume levels. This ensures that critical data is always available when needed, minimizing downtime, and maximizing productivity. As such, use (online) snapshots for most restore operations, rather than resorting to offline backups (vaulted snapshots). For more information, see [Azure NetApp files snapshot-based backups](/azure/azure-netapp-files/snapshots-introduction).

**Set up cross-region replication for disaster recovery.** For higher availability, you can replicate the storage volumes to another Azure region by using Azure NetApp Files [cross-region replication (see Figure 3)](/azure/azure-netapp-files/cross-region-replication-introduction). There are two key advantages to replicating the volumes using the Azure NetApp Files replication to replicate storage volumes, compared to application- or host-level replication: (1) no additional load on the application virtual machines or customer virtual network and (2) eliminates the need to continuously run virtual machines in the destination region during normal operation. Azure NetApp Files replicates the storage contents without the use of any compute infrastructure resources, and the destination region doesn't need to run the Teamcenter software continuously. The destination virtual machines don't need to be running to support this scenario.

The typical recovery point objective (RPO) for this solution is less than 20 minutes when the cross-region replication update interval is set to 10 minutes. Recovery time objective (RTO), or the maximum tolerable business application downtime, is determined by factors in bringing up the application and providing access to the data at the second site. The storage portion of the RTO for breaking the peering relationship to activate the destination volume and provide read and write data access in the second site is expected to be complete within a minute. To configure cross-region replication, see [Create volume replication for Azure NetApp Files](/azure/azure-netapp-files/cross-region-replication-create-peering).

image 

Figure 3. Disaster recovery architecture using cross-region replication.

#### Dataflow 

1.	The client tier, web app tier, enterprise tier, and resource tier in the *production* environment use the Azure NetApp Files in the storage tier. 
2.	The applications in their respective tiers use application replication *if needed* to replicate data to an Azure DR region. It’s preferable to use Azure NetApp Files-based cross-region replication *if possible*.
3.	Azure NetApp Files cross-region replication asynchronously replicates the data volumes, including all snapshots, to a DR region to facilitate failover if there's a regional disaster. The destination volumes can all be of standard service levels while replicating to save on cost while not in a DR failover situation.
4.	In case of a disaster the client, web app, enterprise and resource tiers in the *DR environment* leverage the Azure NetApp Files storage tier for data storage and performance in the *DR* environment. In a DR scenario, you should change the Azure NetApp Files (DR) volume in the DR environment premium or ultra tier required for running the applications.
5.	Once the disaster is over, you can initiate a failback event to return the replicated data back to its original region. The failback event replicates changes made to the data back to the original region in stages, including any new snapshots created on the disaster recovery site, with critical data prioritized first. After replication is complete, applications can resume normal operations in the original region.

**Configure database high availability.**  Combining SQL Server Always On Availability Groups or Oracle Data Guard with Azure NetApp Files' availability zone volume placement feature helps build highly available (HA) architectures for these applications.

- *Use SQL Server Always On Availability Groups with Azure NetApp Files.* SQL Server Always On Availability Groups enable synchronous or asynchronous replication of SQL Server databases across availability zones. This ensures data redundancy and failover capabilities within the SQL Server ecosystem. Deploy Azure NetApp Files using availability zone volume placement. Availability zone placement locates the underlying storage for SQL Server databases within the same availability zone as the SQL Server instances.
- *Use Oracle Data Guard with Azure NetApp Files.* Configure Oracle Data Guard to replicate Oracle databases between availability zones for data redundancy and high availability. Use Azure NetApp Files with availability zone volume placement to ensure that the storage supporting the Oracle databases resides within the same availability zone as the Oracle database instances.

### Security 

Security provides assurance against deliberate attacks and the abuse of valuable PLM data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview) in the Azure Well-Architected Framework. Azure NetApp Files provides security features such as [encryption](/azure/azure-netapp-files/faq-security#can-the-storage-be-encrypted-at-rest) and access control. These features help protect Siemens Teamcenter PLM databases from unauthorized access, data breaches, and cyber threats. Azure NetApp Files provides a level of [security](/azure/azure-netapp-files/faq-security#can-the-network-traffic-between-the-azure-vm-and-the-storage-be-encrypted) because data remains in your virtual networks. There's no publicly addressable endpoint. All [data is encrypted at rest](/azure/azure-netapp-files/faq-security#can-the-storage-be-encrypted-at-rest) at all times. 

**Use enhanced file access security.** You can use [SMB share permissions](/azure/azure-netapp-files/faq-smb#can-the-smb-share-permissions-be-changed) and [NTFS access control lists (ACLs)](/azure/azure-netapp-files/azure-netapp-files-create-volumes-smb#ntfs-file-and-folder-permissions), as well as [NFS export policies](/azure/azure-netapp-files/azure-netapp-files-configure-export-policy) and [UNIX permissions and ownership mode](/azure/azure-netapp-files/configure-unix-permissions-change-ownership-mode) or [NFSv4.1 ACLs](/azure/azure-netapp-files/configure-access-control-lists) to enhance file access security.

**Use network security groups.** Apply [Network Security Groups (NSGs)](/azure/virtual-network/network-security-groups-overview) on Azure virtual networks and Azure NetApp Files delegated subnets (configured with [standard network features](/azure/azure-netapp-files/azure-netapp-files-network-topologies#configurable-network-features)).

**Consider encrypting data in transit.** Optionally [enable encrypt data-in-transit](/azure/azure-netapp-files/faq-security#can-the-network-traffic-between-the-azure-vm-and-the-storage-be-encrypted) on any volume exported via NFSv4.1, SMB, or dual-protocol. 

**Use Azure Policy.** [Azure Policy](/azure/governance/policy/overview) can help you enforce organizational standards and assess compliance at scale. Azure NetApp Files supports Azure Policy via [custom and built-in policy definitions](/azure/azure-netapp-files/azure-policy-definitions).

### Cost optimization

Cost optimization is about reducing unnecessary expenses and improving operational efficiency. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview). Azure NetApp Files provides a [cost-effective storage solution with a pay-as-you-go model](/azure/azure-netapp-files/azure-netapp-files-cost-model#calculation-of-capacity-consumption). You only pay for the storage and performance resources that you use, without any upfront investment in hardware or infrastructure.

**Understand the Azure NetApp Files cost model.** Understanding the [cost model for Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-cost-model) can help you manage your expenses. Azure NetApp Files billing is based on provisioned storage capacity, which you allocate by creating capacity pools. Capacity pools are billed monthly based on a set cost per allocated GiB per hour.

**Consider dynamically resizing volumes and capacity pools**. If your capacity pool size requirements fluctuate (for example, because of variable capacity or performance needs), consider [dynamically resizing your volumes and capacity pools](/azure/azure-netapp-files/azure-netapp-files-resize-capacity-pools-or-volumes) to balance cost with your capacity and performance needs.

**Consider dynamically changing the volume tier (service level).** If your capacity pool size requirements remain the same but performance requirements fluctuate, consider [dynamically changing the service level of a volume](/azure/azure-netapp-files/dynamic-change-volume-service-level). You can provision and deprovision capacity pools of different types throughout the month, providing just-in-time performance and reducing costs during periods when you don’t need high performance. It is recommended to use these capabilities when setting up a DR scenario across Azure regions, where the secondary region gets provisioned on the lowest, most cost-effective (standard) tier, and volumes only move volumes to the appropriate performance in case of a disaster/failover event.

**Use cross-region and cross-zone replication.** The use of [cross-region and cross-zone replication](/azure/azure-netapp-files/cross-zone-replication-introduction) takes away the need for host-based replication mechanisms, avoiding virtual machine and software license cost.

Azure NetApp Files also optimizes cost for the [Oracle](https://techcommunity.microsoft.com/t5/azure-architecture-blog/run-your-most-demanding-oracle-workloads-in-azure-without/ba-p/3264545) and [SQL Server](/azure/azure-netapp-files/solutions-benefits-azure-netapp-files-sql-server) database applications, by allowing heavy, storage I/O intensive databases to run on smaller Azure VM SKUs within a series. You should leverage [Azure constrained vCPU SKUs](/azure/virtual-machines/constrained-vcpu) where possible to save on compute and software license cost.

**Understand performance requirements.** Based on your capacity and performance requirements, determine the Azure NetApp Files service level you need (Standard, Premium, or Ultra). Then use the [Azure Pricing calculator](https://azure.microsoft.com/pricing/calculator) to evaluate the costs for these components:

- Siemens Teamcenter PLM on Azure components
- Database on Azure components
- Azure NetApp Files, cross-region replication, and backup
- Managed disk (OS boot disks)
- Networking components

**Use the Azure NetApp Files performance calculator.** The [Azure NetApp Files performance calculator](https://anftechteam.github.io/calc/advanced/) helps you determine the correct Azure NetApp Files storage tier for your cost and performance needs.

**Consult with an Azure Solutions Architect.** It’s recommended to consult an Azure Cloud Solution Architect (CSA) to assist with application sizing and selecting the smallest applicable VM SKU.

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview). Azure NetApp Files for Siemens Teamcenter PLM can help you comply with several of the Azure Well-architected Framework Operational excellence topics:

**Use native monitoring features.** Azure NetApp Files provides [built-in monitoring and diagnostics capabilities](/azure/azure-netapp-files/monitor-azure-netapp-files) that enable you to monitor the performance and health of your Teamcenter PLM application, CAD file shares, and databases. You can set up alerts and notifications for critical events, such as file system capacity and performance issues, and take corrective actions proactively.

**Manage performance.** Azure NetApp Files offers non-disruptive, on-demand [capacity scaling](/azure/azure-netapp-files/azure-netapp-files-resize-capacity-pools-or-volumes) and [service level changes](/azure/azure-netapp-files/dynamic-change-volume-service-level), allowing you to scale up or down quickly as required by your Teamcenter PLM applications, CAD file shares, and databases. This, together with volume resizing or manual QoS settings, helps to [manage the performance](/azure/azure-netapp-files/azure-netapp-files-performance-considerations) and availability of your application.

**Automate infrastructure deployments.** Azure NetApp Files enables you to automate the deployment of your Teamcenter PLM application infrastructure, CAD file shares, and databases. You can use [Azure Resource Manager templates](/azure/azure-netapp-files/azure-netapp-files-sdk-cli#azure-resource-manager-templates) to define and deploy the required resources, such as file shares, storage accounts, virtual machines, and databases, to support your application.

**Test deployments.** Azure NetApp Files provides a reliable and scalable platform for deploying your Teamcenter PLM application code, CAD files, and databases. You can use the [cloning via snapshot restore feature](/azure/azure-netapp-files/snapshots-introduction#restoring-cloning-an-online-snapshot-to-a-new-volume) to create a new volume for testing purposes quickly. This helps to ensure that your application is always up-to-date and stable, and you can test new releases or upgrades quickly and easily.

**Test environments.** Azure NetApp Files allows you to create and manage test environments quickly and easily by [cloning your production data via snapshot restore to a new volume](/azure/azure-netapp-files/snapshots-introduction#restoring-cloning-an-online-snapshot-to-a-new-volume). This helps you to isolate testing activities from production environments and provides a quick and easy way to test disaster recovery scenarios. You can also use the same process to test new releases or upgrades in a non-disruptive manner. This helps to ensure that your application is robust and reliable.

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview). Azure NetApp Files provides high-performance storage with low latency, high throughput, and consistent performance. This means that your Teamcenter PLM [database will be able to handle high volumes of data, users, and transactions without any performance degradation](https://techcommunity.microsoft.com/t5/azure-architecture-blog/run-your-most-demanding-oracle-workloads-in-azure-without/ba-p/3264545). It also means that your CAD files will be able to be accessed and modified quickly and efficiently, which can help improve productivity and collaboration.

**Pick the right compute and performance tiers.** To ensure optimal performance of your Teamcenter PLM environment, use the right Azure VM types and Azure NetApp Files performance tier. Azure NetApp Files volumes are available in three performance tiers (or ‘service level’): [Ultra, Premium, and Standard](/azure/azure-netapp-files/azure-netapp-files-service-levels#supported-service-levels). Choose the tier that best suits your performance requirements, taking into account that available performance bandwidth [scales with the size of a volume](/azure/azure-netapp-files/azure-netapp-files-service-levels#throughput-limits). You can optimize performance by resizing or changing the service level of a volume at any time. For more information about the Azure NetApp Files cost model, see these [pricing examples](/azure/azure-netapp-files/azure-netapp-files-cost-model#pricing-examples).  

The VM type and performance tiers need to meet storage needs of the (1) Siemens Teamcenter servers (Root FSC), (2) database servers, and (3) engineering workstations (*see Figure 2*).

image 

Figure 2: Varied storage tier requirements across infrastructure components.

- *Siemens Teamcenter Servers (Root FSC)* require medium-to-high storage performance for file data management. Depending on volume capacities, the Azure NetApp Files Premium tier is typically recommended unless [performance sizing](https://anftechteam.github.io/calc/advanced) shows otherwise. You should use Azure D or F series VMs for the Root FSC servers. Azure NetApp Files provides high level SLAs to maintain operability and IOPS levels.
- *Database servers ([SQL Server](/azure/azure-netapp-files/solutions-benefits-azure-netapp-files-sql-server) or [Oracle](https://techcommunity.microsoft.com/t5/azure-architecture-blog/run-your-most-demanding-oracle-workloads-in-azure-without/ba-p/3264545))* require minimal latency between it and storage. Azure NetApp Files provides latencies of less than 1 millisecond. You should use E/M-series Azure VMs for your database servers. Where possible, enable [constrained vCPU](/azure/virtual-machines/constrained-vcpu) to save on SKU and license cost. For the most demanding database applications, you should use the Azure NetApp Files Ultra tier unless database [performance sizing](https://anftechteam.github.io/calc/advanced) shows otherwise.
- *Engineering workstations* should use NV series VMs for the engineering workstations and leverage NVIDIA GPUs and NVIDIA GRID technology for desktop accelerated applications and virtual desktops. Azure NetApp Files also optimizes GPU enabled engineering workstations by providing fast and concurrent access to file data to multiple workstations and therefore fostering collaboration. Typically, Azure NetApp Files Standard tier is sufficient for this use case, especially since the standard tier provides same low latency performance experience as the other tiers even at low bandwidth requirements – also in situations with high concurrency (like many users access the volume in parallel).

**Scale your storage capacity.** With Azure NetApp Files, you can easily scale your storage capacity and performance to meet your changing business needs. You can [add or remove capacity and performance resources on-demand, without any downtime or data migration which helps improve TCO](/azure/azure-netapp-files/azure-netapp-files-cost-model#pricing-examples).

Azure NetApp Files provides several features that help to scale on-demand for performance and cost, while ensuring that the changes are transparent to the applications running on top:

1.	[Dynamic service level changes](/azure/azure-netapp-files/dynamic-change-volume-service-level): Azure NetApp Files allows you to change the service level of your volumes on-demand, without any disruption to your applications. This means that you can increase or decrease the performance or capacity of your volumes as required, without impacting the availability of your applications. This helps you to optimize the performance and cost of your storage resources based on your workload requirements.
2.	[Adjusting performance when using ‘auto QoS’](/azure/azure-netapp-files/azure-netapp-files-service-levels#throughput-limit-examples-of-volumes-in-an-auto-qos-capacity-pool): By default, Azure NetApp Files automatically applies Quality of Service (QoS) to your volumes to ensure that they receive the required level of performance. When you resize your volumes, the QoS settings are automatically adjusted to reassign the level of performance. This means that your applications continue to receive the adjusted level of performance as the storage capacity changes.
3.	[Adjusting performance when using 'Manual QoS'](/azure/azure-netapp-files/azure-netapp-files-service-levels#throughput-limit-examples-of-volumes-in-a-manual-qos-capacity-pool): Azure NetApp Files also allows you to manually assign QoS policies to your volumes to ensure that they receive the required level of performance. Without resizing your volumes, you can adjust the QoS settings to optimize the performance and cost of your storage resources. This means that you can fine-tune the performance of your applications based on your workload requirements.

All of these changes are transparent to the Siemens Teamcenter components running on top of Azure NetApp Files. The applications continue to access the volumes in the same way, and the performance and availability are maintained at the required level. This helps you to scale your storage resources on-demand for performance and cost, without disrupting your business operations.

**Run performance test.** Customer deployments and performance validation tests of Azure NetApp Files for Siemens Teamcenter PLM have validated significant decreases in execution times and significant improvements in both read and write times. This results in overall productivity gains and optimizes resource utilization. Use the [Azure NetApp Files Performance Calculator](https://anftechteam.github.io/calc/) to get started with an initial sizing and cost estimation. 

### Potential use cases

**Requirements engineering, model-based systems engineering, and PLM process management:** Azure NetApp Files offers high-performance storage with low latency, enabling faster access to critical data and improving overall system performance. This is particularly important for use cases such as requirements engineering, model-based systems engineering, and PLM process management, which rely heavily on accessing and processing large volumes of data.

**Bill of materials management and product configuration:** Azure NetApp Files also provides flexible storage options that can scale up or down based on changing business needs. This is particularly useful for use cases such as bill of materials management and product configurations, which require significant storage capacity and may experience frequent changes in data volume.

**Product cost management:** Azure NetApp Files provides advanced data protection features, including point-in-time backups and disaster recovery options, which can help ensure data availability and minimize the risk of data loss. This is important for use cases such as product cost management, where accurate and up-to-date data is critical for making informed decisions.

**Development across departments and domains:** Azure NetApp Files contributes to improving development across departments and domains by providing a high-performance, reliable, and scalable storage service for Siemens Teamcenter PLM deployments. With Azure NetApp Files, PLM data can be accessed quickly and easily, allowing for efficient collaboration between different departments and domains.

**Mechanical design management:** Azure NetApp Files can provide high-speed access to large design files, allowing engineers to quickly iterate on designs and make necessary changes. For electronics and electrical CAD management, Azure NetApp Files can provide a centralized location for storing and managing CAD data, making it easy for engineers to collaborate on designs and share data across departments.

**Software design management:** Azure NetApp Files can provide high-performance storage for build artifacts and development environments, enabling fast build and deployment times. 

**Product document management:** Azure NetApp Files can provide a centralized location for storing and managing product documentation, making it easy to access and share information across different teams.

**Product visualization and desktop mockup:** Azure NetApp Files can provide high-speed access to large graphic files and simulations, enabling faster visualization and mockup times. And for simulation process and data management, Azure NetApp Files can provide fast and reliable storage for simulation data, allowing engineers to quickly run simulations and analyze results.

**Product visibility and insight:** Azure NetApp Files enables the delivery of product visibility and insight by providing fast and reliable access to PLM data and analytics, which can help organizations make informed decisions and optimize their product development processes. For example, PLM analytics can provide insights into the performance of products and help identify areas for improvement, while sustainable product development can help organizations track the environmental impact of their products and make more sustainable choices. 

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors: 

- Tilman Schroeder - Cloud Lead Automotive, NetApp
- Geert van Teylingen - Azure NetApp Files Group Product Manager


Other contributors:
 
- Sunita Phanse – Senior Technical Program Manager, Microsoft

line 

## Next steps

To find out more about Azure capabilities related to implementing a robust data management layer for PLM, read the following: 

- Azure Marketplace solutions for Siemens Teamcenter
- Oracle solutions on Azure NetApp Files
- SQL Server solutions on Azure NetApp Files
- Benefits of using Azure NetApp Files for SQL Server Deployment
- Azure Virtual Desktop solutions with Azure NetApp Files
- File sharing solutions with Azure NetApp Files
- Azure Architecture Center solutions with Azure NetApp Files
- Azure NetApp Files Performance Calculator
- Azure Pricing calculator
