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
1. Azure Cache for Redis, Azure Cosmos DB, and Azure Stream Analytics provide working storage if needed.
1. The permanent data layer uses Azure Data Factory for data integration and Azure SQL Managed Instance, business critical performance tier, for high availability. The permanent storage is loosely coupled for easy switching to other database technologies, and for optimization of storage organization (using shards or partitions, for example).
1. The data solutions (transitional and permanent) use the Azure Storage geo-redundant storage (GRS) option to protect against catastrophic failures.

### Components

The architecture uses these components:

- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network/) provides a secure private network in the cloud. It can connect virtual machines (VMs) to one another, to the internet, and to on-premises networks.
- [Azure ExpressRoute](https://azure.microsoft.com/services/expressroute/) provides private connections between Azure datacenters and on-premises infrastructure.
- [Azure Bastion](https://azure.microsoft.com/services/azure-bastion/) provides private and fully managed RDP and SSH access to VMs.
- [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines/) provides the flexibility of virtualization without having to provide and maintain the hardware that hosts it. The operating system choices include Windows and Linux.
- A VM created with accelerated networking uses single root I/O virtualization (SR-IOV), greatly improving its networking performance. For more information, see [Create a Windows VM with accelerated networking using Azure PowerShell](/azure/virtual-network/create-vm-accelerated-networking-powershell) and [Overview of Single Root I/O Virtualization (SR-IOV)](/windows-hardware/drivers/network/overview-of-single-root-i-o-virtualization--sr-iov-).
- An Azure network interface connects a VM to the internet, and to Azure and on-premises resources. As shown in this architecture, you can give each child VM its own network interface and IP address. For more information on network interfaces, see [Create, change, or delete a network interface](/azure/virtual-network/virtual-network-network-interface).
- [Azure Managed Disks](https://azure.microsoft.com/pricing/details/managed-disks/) are high-performance, highly durable block storage for VMs. There are four disk storage options for the cloud: Ultra Disk Storage, Premium SSD, Standard SSD, and Standard HDD.
- [Azure Kubernetes Service (AKS)](https://azure.microsoft.com/services/kubernetes-service/) is a fully managed Kubernetes service for deploying and managing containerized applications.
- [Service Bus](https://azure.microsoft.com/services/service-bus/) provides reliable cloud messaging as a service (MaaS) and simple hybrid integration.
- [Azure load balancing services](https://azure.microsoft.com/products/azure-load-balancing/) provides scaling for high availability and high performance. This architecture uses [Load Balancer](https://azure.microsoft.com/services/load-balancer/). It provides low-latency Layer 4 (TCP, UDP) load balancing capabilities to balance traffic between VMs, and across multi-tiered hybrid apps.
- [Azure Cache for Redis](https://azure.microsoft.com/services/cache/) is a lightning-fast and fully managed in-memory caching service for sharing  data and state among compute resources.
- [Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db/) is a fast NoSQL database with open APIs for any scale.
- [Azure Stream Analytics](https://azure.microsoft.com/services/stream-analytics/) provides real-time analytics on fast-moving streams of data from applications and devices.
- [Azure Databricks](https://azure.microsoft.com/services/databricks/) is a fast, easy, and collaborative big data analytics service based on Apache Spark<sup>TM</sup>.
- [Azure SQL](https://azure.microsoft.com/services/azure-sql/) is a family of SQL cloud databases that provides a unified experience for your entire SQL portfolio, and a wide range of deployment options from edge to cloud.
- [Azure SQL Managed Instance](https://azure.microsoft.com/services/azure-sql/sql-managed-instance/), part of the Azure SQL service portfolio, is a  managed, secure, and always up-to-date SQL instance in the cloud.
- [Data Factory](https://azure.microsoft.com/services/data-factory/) is a fully managed and serverless data integration solution for preparing, and transforming all your data at scale.
- Data Factory supports the Parquet file data format. For more information, see [Parquet format in Azure Data Factory](/azure/data-factory/format-parquet).
- Log Analytics is a tool in the Azure portal used to edit and run log queries on [Azure Monitor](https://azure.microsoft.com/services/monitor/) logs. For more information, see [Overview of Log Analytics in Azure Monitor](/azure/azure-monitor/logs/log-analytics-overview).
- The geo-redundant storage (GRS) option of [Azure Storage](https://azure.microsoft.com/services/storage/) copies your data synchronously three times within a single physical location in the primary region, then copies it asynchronously to a single physical location in the secondary region. For more information, see [Azure Storage redundancy](/azure/storage/common/storage-redundancy).
- [Azure Blob Storage](https://azure.microsoft.com/services/storage/blobs/) is massively scalable and secure REST-based object storage for cloud-native workloads, archives, data lakes, high-performance computing, and machine learning.
- [Azure Files](https://azure.microsoft.com/services/storage/files/) provides simple, secure, and serverless enterprise-grade file shares in the cloud. You use the industry-standard Server Message Block (SMB) and Network File System (NFS) protocols to access the shares.

## Scenario details

On Azure, you can implement batch transaction processing—such as posting payments to accounts—by using an architecture based on Microsoft Azure Kubernetes Service (AKS) and Azure Service Bus. This type of architecture provides the transaction processing speed, scaling, and reliability required for high-volume batch processing.

Typically, a message remains queued until its transaction completes, allowing for recovery if there's a failure. Also, you can replicate topics and queues to other regions, to share workloads and to continue processing even if a region fails.

### Potential use cases

The solution is ideal for the finance, education, and science industries. This architecture is for high-volume processing of batches of transactions, especially independent transactions that can be processed in parallel. It's therefore a likely candidate for use in migrating mainframe batch processing. Possible applications are:

- Processing of financial transactions, such as payroll, orders, and payments.
- Processing of experimental data gathered by scientific instruments.
- Other mainframe batch processing.

## Considerations

The following considerations, based on the [Azure Well-Architected Framework](https://www.microsoft.com/azure/partners/well-architected), apply to this solution:

### Availability

- [Azure Site Recovery](https://azure.microsoft.com/services/site-recovery/) disaster recovery service protects against major outages. It's dependable, cost-effective, and easy to deploy.
- Availability sets for VMs ensure that enough VMs are available to meet mission-critical batch process needs.
- Service Bus, AKS, and Azure SQL Managed Instance provide high availability and recoverability across geographic regions.

### Operational

- [Azure Resource Manager templates (ARM templates)](https://azure.microsoft.com/services/arm-templates/) provide a configuration language to describe your resources in templates that you can use for scripted deployment. The templates also provide monitoring and alerting capabilities.

### Performance efficiency

- The architecture is designed to accommodate parallel processing of independent transactions.
- Service Bus, AKS, and other Azure PaaS features provide high performance for transaction processing, computing, and data storage.

### Scalability

- Service Bus, AKS, and other Azure PaaS features dynamically scale as needed.

### Security

- All the components within the Service Bus batch architecture work with Azure security components, such as Azure Active Directory, Virtual Network, and encryption.

### Cost optimization

To estimate costs for your implementation of this solution, use the [Pricing calculator](https://azure.microsoft.com/pricing/calculator/).

The autoscale features of AKS clusters—and other Azure Platform as a Service (PaaS) features that provide scaling on demand—keep costs at a minimum.

Here are pricing considerations for specific components:

- Most enterprises already have a Microsoft Active Directory implementation. If not, [Azure Active Directory Premium](https://azure.microsoft.com/services/active-directory/) is low cost.
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

## Next steps

- To learn more about AKS, read: [Azure Kubernetes Service solution journey](../../reference-architectures/containers/aks-start-here.md).
- To learn more about Service Bus, read: [Service Bus queues, topics, and subscriptions](/azure/service-bus-messaging/service-bus-queues-topics-subscriptions).

## Related resources

- Techniques used in this architecture:
  - [Azure Service Bus Geo-disaster recovery](/azure/service-bus-messaging/service-bus-geo-dr).
  - [Use geo-redundancy to design highly available applications](/azure/storage/common/geo-redundant-design?tabs=current).
  - [What are ARM templates?](/azure/azure-resource-manager/templates/overview)
- Azure reference architectures:
  - [Migrate IBM mainframe applications to Azure with TmaxSoft OpenFrame](../../solution-ideas/articles/migrate-mainframe-apps-with-tmaxsoft-openframe.yml).
  - [Refactor IBM z/OS mainframe Coupling Facility (CF) to Azure](../../reference-architectures/zos/refactor-zos-coupling-facility.yml).
  - [Micro Focus Enterprise Server on Azure VMs](./micro-focus-server.yml).
  - [Unisys mainframe migration](../../reference-architectures/migration/unisys-mainframe-migration.yml).
