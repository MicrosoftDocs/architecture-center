The architecture uses AKS to implement compute clusters of the applications that process high-volume batches of transactions. The applications receive the transactions in messages from Service Bus topics or queues. The topics and queues can be at Azure datacenters in different geographic regions, and multiple AKS clusters can read input from them.

> [!Note]
> This architecture suits a type of batch transaction processing that, on IBM mainframes, is often implemented by using the IBM MQ family of message-oriented middleware.

## Architecture

:::image type="content" source="media/process-batch-transactions.svg" alt-text="Diagram of an architecture implemented by using AKS and Service Bus." lightbox="media/process-batch-transactions.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/process-batch-transactions.vsdx) of this architecture.*

### Workflow

The numbered circles in the diagram correspond to the numbered steps in the following list.

1. The architecture uses Service Bus topics and queues to organize the batch processing input and to pass it downstream for processing.
1. Azure Load Balancer, a Layer 4 (TCP, UDP) load balancer, distributes incoming traffic among healthy instances of services defined in a load-balanced set. Load balancing and management of connections optimize processing.
1. The AKS cluster worker nodes listen to Service Bus queue endpoints for input.
1. The Java nodes use Java Message Service to connect to Service Bus, and Java interfaces like Java Database Connectivity to connect to other data sources. They use other Java APIs as needed.
1. The recoverable transactions run along with the business code for each batch step.
1. The batch infrastructure uses Azure accelerated networking for speed.
1. Azure Managed Redis, Azure Cosmos DB, and Azure Stream Analytics provide working storage if needed.
1. The permanent data layer uses Azure Data Factory for data integration and Azure SQL Managed Instance, business critical performance tier, for high availability. The permanent storage is loosely coupled for easy switching to other database technologies, and for optimization of storage organization (using shards or partitions, for example).
1. The data solutions (transitional and permanent) use the Azure Storage geo-redundant storage (GRS) option to protect against catastrophic failures.

### Components

- [Azure Bastion](/azure/bastion/bastion-overview) is a platform as a service (PaaS) that provides private and fully managed Remote Desktop Protocol (RDP) and Secure Shell (SSH) access to virtual machines (VMs). In this architecture, Azure Bastion enables secure administrative access to the VMs without exposing them to the public internet.

- [Azure Blob Storage](/azure/well-architected/service-guides/azure-blob-storage) is a cloud object storage service that provides scalable and secure REST-based object storage for cloud-native workloads, archives, data lakes, high-performance computing, and machine learning. In this architecture, Blob Storage provides scalable storage for batch processing input, output, and intermediate data files.

- [Azure Managed Redis](/azure/redis/overview) provides an in-memory data store based on Redis Enterprise software. In this architecture, Azure Managed Redis provides high-speed temporary storage for batch processing state and intermediate results.

- [Azure Cosmos DB](/azure/well-architected/service-guides/cosmos-db) is a globally distributed multiple-model NoSQL database that has open APIs for any scale. In this architecture, Azure Cosmos DB provides scalable NoSQL storage for batch processing metadata and working data.

- [Azure Databricks](/azure/well-architected/service-guides/azure-databricks-security) is an Apache Spark-based analytics platform that provides big data analytics services. In this architecture, Azure Databricks can be used for advanced analytics and machine learning on batch processing results.

- [Azure ExpressRoute](/azure/well-architected/service-guides/azure-expressroute) is a connectivity service that provides private connections between Azure datacenters and on-premises infrastructure. In this architecture, ExpressRoute enables high-bandwidth, low-latency connectivity for batch processing applications that need to access on-premises data sources.

- [Azure Files](/azure/well-architected/service-guides/azure-files) is a cloud file storage service that provides simple, secure, and serverless enterprise-grade file shares in the cloud. You use the industry-standard Server Message Block (SMB) and Network File System (NFS) protocols to access the shares. In this architecture, Azure Files provides shared file storage for batch processing applications that require file-based data access.

- [Azure Kubernetes Service (AKS)](/azure/well-architected/service-guides/azure-kubernetes-service) is a managed Kubernetes service for deploying and managing containerized applications. In this architecture, AKS provides the container orchestration platform for running batch processing applications at scale.

- [Load Balancer](/azure/well-architected/service-guides/azure-load-balancer) is a load balancing service that provides low-latency layer-4 (TCP, UDP) load balancing capabilities to balance traffic between VMs, and across multitiered hybrid apps. In this architecture, Load Balancer distributes incoming traffic among healthy batch processing instances to optimize performance.

- [Azure managed disks](/azure/virtual-machines/managed-disks-overview) are high-performance, highly durable block storage volumes for VMs. There are three disk storage options for the cloud: Azure Ultra Disk Storage, Azure Premium SSD, and Azure Standard SSD. In this architecture, Azure managed disks provide persistent storage for batch processing applications and temporary data.

- [Azure network interface](/azure/networking/fundamentals/networking-overview) is a component that connects a VM to the internet and to Azure and on-premises resources. You can give each child VM its own network interface and IP address. In this architecture, network interfaces enable connectivity between batch processing VMs and the Service Bus messaging system. For more information about network interfaces, see [Create, change, or delete a network interface](/azure/virtual-network/virtual-network-network-interface).

- [Azure SQL](/azure/azure-sql/) is a family of SQL cloud databases that provides a unified experience for your entire SQL portfolio and a wide range of deployment options from the edge to the cloud. In this architecture, Azure SQL provides relational database services for batch processing applications.

- [Azure Storage](/azure/well-architected/service-guides/storage-accounts/reliability) is a cloud storage service that provides multiple storage solutions, including blob, file, queue, and table storage. The GRS option of Azure Storage copies your data synchronously three times within a single physical location in the primary region and then copies it asynchronously to a single physical location in the secondary region. For more information, see [Azure Storage redundancy](/azure/storage/common/storage-redundancy). In this architecture, Azure Storage with GRS provides highly durable storage for batch processing data and protects against catastrophic failures.

- [Azure Virtual Machines](/azure/well-architected/service-guides/virtual-machines) is a cloud computing service that provides the flexibility of virtualization without having to provide and maintain the hardware that hosts it. The operating system choices include Windows and Linux. In this architecture, Virtual Machines provides the compute infrastructure for batch processing applications and supporting services.

  A VM created with accelerated networking uses single root input/output virtualization (SR-IOV), which improves its networking performance. For more information, see [Create a Windows VM with accelerated networking by using Azure PowerShell](/azure/virtual-network/create-vm-accelerated-networking-powershell) and [Overview of SR-IOV](/windows-hardware/drivers/network/overview-of-single-root-i-o-virtualization--sr-iov-). In this architecture, accelerated networking enhances the network performance of VMs that handle high-volume batch transactions.

- [Azure Virtual Network](/azure/well-architected/service-guides/virtual-network) is a cloud networking service that provides a secure private network in the cloud. It can connect VMs to one another, to the internet, and to on-premises networks. In this architecture, Virtual Network provides secure network isolation for the batch processing infrastructure and enables communication between AKS clusters and other Azure services.

- [Data Factory](/azure/data-factory/introduction) is a cloud-based data integration service that is fully managed and serverless for preparing and transforming all your data at scale. Data Factory supports the [Parquet format](/azure/data-factory/format-parquet). This support enables efficient columnar data processing for batch operations. In this architecture, Data Factory orchestrates data integration workflows for batch processing input and output.

- [Log Analytics](/azure/well-architected/service-guides/azure-log-analytics) is a tool in the Azure portal that you can use to edit and run log queries on [Azure Monitor](/azure/azure-monitor/overview) logs. In this architecture, Log Analytics provides centralized logging and monitoring capabilities for batch processing operations.

- [Service Bus](/azure/well-architected/service-guides/service-bus/reliability) is a cloud messaging service that provides reliable cloud messaging as a service (MaaS) and simple hybrid integration. In this architecture, Service Bus delivers transaction messages to AKS clusters and ensures reliable message processing for batch workloads.

- [SQL Managed Instance](/azure/well-architected/service-guides/azure-sql-managed-instance/reliability) is a managed database service that provides a secure and always up-to-date SQL instance in the cloud. In this architecture, SQL Managed Instance provides high-availability database services with a business-critical performance tier for permanent data storage.

- [Stream Analytics](/azure/stream-analytics/stream-analytics-introduction) is a service that provides real-time analytics for fast-moving streams of data from applications and devices. In this architecture, Stream Analytics processes streaming data from batch operations for real-time monitoring and analytics.

## Scenario details

On Azure, you can implement batch transaction processing—such as posting payments to accounts—by using an architecture based on Microsoft Azure Kubernetes Service (AKS) and Azure Service Bus. This type of architecture provides the transaction processing speed, scaling, and reliability required for high-volume batch processing.

Typically, a message remains queued until its transaction completes, allowing for recovery if there's a failure. Also, you can replicate topics and queues to other regions, to share workloads and to continue processing even if a region fails.

### Potential use cases

The solution is ideal for the finance, education, and science industries. This architecture is for high-volume processing of batches of transactions, especially independent transactions that can be processed in parallel. It's therefore a likely candidate for use in migrating mainframe batch processing. Possible applications are:

- Processing of financial transactions, such as payroll, orders, and payments.
- Processing of experimental data gathered by scientific instruments.
- Other mainframe batch processing.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

- [Azure Site Recovery](https://azure.microsoft.com/services/site-recovery/) disaster recovery service protects against major outages. It's dependable, cost-effective, and easy to deploy.
- Availability sets for VMs ensure that enough VMs are available to meet mission-critical batch process needs.
- Service Bus, AKS, and Azure SQL Managed Instance provide high availability and recoverability across geographic regions.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

- All the components within the Service Bus batch architecture work with Azure security components, such as Microsoft Entra ID, Virtual Network, and encryption.

### Cost Optimization

Cost Optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

To estimate costs for your implementation of this solution, use the [Pricing calculator](https://azure.microsoft.com/pricing/calculator/).

The autoscale features of AKS clusters—and other Azure Platform as a Service (PaaS) features that provide scaling on demand—keep costs at a minimum.

Here are pricing considerations for specific components:

- Most enterprises already have a Microsoft Active Directory implementation. If not, [Microsoft Entra ID P1 or P2](https://azure.microsoft.com/services/active-directory/) is low cost.
- [Windows VM pricing](https://azure.microsoft.com/pricing/details/virtual-machines/windows/) and [Linux VM pricing](https://azure.microsoft.com/pricing/details/virtual-machines/linux/) depend on your compute capacity.
- For Premium SSD or Ultra managed storage disks pricing, see [Managed Disks pricing](https://azure.microsoft.com/pricing/details/managed-disks/).
- There are no upfront costs for [Azure SQL Database](https://azure.microsoft.com/pricing/details/sql-database/single/); you pay for resources as used.
- For [ExpressRoute](https://azure.microsoft.com/pricing/details/expressroute/), you pay a monthly port fee and outbound data transfer charges.
- [Azure Storage](https://azure.microsoft.com/pricing/details/storage/) costs depend on data redundancy options and volume.
- [Azure Files](https://azure.microsoft.com/pricing/details/storage/files/) pricing depends on many factors: data volume, data redundancy, transaction volume, and the number of file sync servers that you use.
- For SSD managed disk pricing, see [Managed Disks](https://azure.microsoft.com/pricing/details/managed-disks/) pricing.
- For [Site Recovery](https://azure.microsoft.com/pricing/details/site-recovery/), you pay for each protected instance.
- These services are free with your Azure subscription, but you pay for usage and traffic:
  - [Load Balancer](https://azure.microsoft.com/pricing/details/load-balancer/).
  - Your activity run volume determines the cost of [Data Factory](https://azure.microsoft.com/pricing/details/data-factory/).
  - For [Azure Virtual Network](https://azure.microsoft.com/pricing/details/virtual-network), IP addresses carry a nominal charge.
  - Outbound data transfer volume determines [Azure Bastion](https://azure.microsoft.com/pricing/details/azure-bastion/) costs.

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

- [Azure Resource Manager templates (ARM templates)](https://azure.microsoft.com/services/arm-templates/) provide a configuration language to describe your resources in templates that you can use for scripted deployment. The templates also provide monitoring and alerting capabilities.

### Performance Efficiency

Performance Efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

- The architecture is designed to accommodate parallel processing of independent transactions.
- Service Bus, AKS, and other Azure PaaS features provide high performance for transaction processing, computing, and data storage.
- Service Bus, AKS, and other Azure PaaS features dynamically scale as needed.

## Next steps

- To learn more about AKS, read: [Azure Kubernetes Service solution journey](../../reference-architectures/containers/aks-start-here.md).
- To learn more about Service Bus, read: [Service Bus queues, topics, and subscriptions](/azure/service-bus-messaging/service-bus-queues-topics-subscriptions).

## Related resources

- Techniques used in this architecture:
  - [Azure Service Bus Geo-disaster recovery](/azure/service-bus-messaging/service-bus-geo-dr).
  - [Use geo-redundancy to design highly available applications](/azure/storage/common/geo-redundant-design?tabs=current).
  - [What are ARM templates?](/azure/azure-resource-manager/templates/overview)
- Azure reference architectures:
  - [Micro Focus Enterprise Server on Azure VMs](./micro-focus-server.yml).
  - [Unisys mainframe migration](../../reference-architectures/migration/unisys-mainframe-migration.yml).
