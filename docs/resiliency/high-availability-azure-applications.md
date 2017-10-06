---
title: High availability for Azure applications
description: Technical overview and in-depth information about designing and building applications for high availability on Microsoft Azure.
author: adamglick
ms.date: 05/31/2017
---
[!INCLUDE [header](../_includes/header.md)]
# High availability for applications built on Microsoft Azure
A highly available application absorbs fluctuations in availability, load, and temporary failures in dependent services and hardware. The application continues to perform acceptably, as defined by business requirements or application service-level agreements (SLAs).

## Azure high-availability features
Azure has many built-in platform features that support highly available applications. This section describes some of those key features.

### Fabric controller
The Azure fabric controller provisions and monitors the condition of Azure compute instances. The fabric controller monitors the status of the hardware and software of the host and guest machine instances. When it detects a failure, it maintains SLAs by automatically relocating the VM instances. The concept of fault and upgrade domains further supports the compute SLA.

When multiple Cloud Service role instances are deployed, Azure deploys these instances to different fault domains. A fault domain boundary is essentially a different hardware rack in the same region. Fault domains reduce the probability that a localized hardware failure interrupts the service of an application. You cannot manage the number of fault domains of your worker roles or web roles. The fabric controller uses dedicated resources that are separate from Azure-hosted applications. It requires 100 percent uptime because it serves as the nucleus of the Azure system. It monitors and manages role instances across fault domains.

The following diagram shows Azure shared resources that the fabric controller deploys and manages across different fault domains.

![Simplified view of fault domain isolation](./images/high-availability-azure-applications/fault-domain-isolation.png)

While fault domains are physical separations to mitigate failure, upgrade domains are logical units of instance separation that determine which instances of a service will be upgraded at a specific time. By default, five upgrade domains are defined for your hosted service deployment. However, you can change that value in the service definition file. For example, if you have eight instances of your web role, there are two instances in three upgrade domains and two instances in one upgrade domain. Azure defines the update sequence based on the number of upgrade domains. For more information, see [Update a cloud service](/azure/cloud-services/cloud-services-update-azure-service/).

### Features in other services
In addition to the platform features that support high availability of compute resources, Azure embeds high-availability features in its other services. For example, Azure Storage maintains at least three replicas of all data in your Azure storage account. It also enables geo-replication to store copies of your data in a secondary region. The Azure Content Delivery Network allows blobs to be cached around the world for redundancy, scalability, and lower latency. Azure SQL Database maintains multiple replicas as well.

For a deeper discussion of Azure platform availability features, see [Resiliency technical guidance](index.md). Also see [Best practices for designing large-scale services on Windows Azure](https://azure.microsoft.com/blog/best-practices-for-designing-large-scale-services-on-windows-azure/).

Although Azure provides multiple features that support high availability, it's important to understand their limitations:

* For compute, Azure guarantees that your roles are available and running, but it cannot detect whether your application is running or overloaded.
* For Azure SQL Database, data is replicated synchronously within the region. You can choose active geo-replication, which allows up to four additional database copies in the same region (or different regions). While these database replicas are not point-in-time backups, SQL Database does provide point-in-time backup capabilities. For more information, see [Recover an Azure SQL Database using automated data backups: Point-in-time restore](/azure/sql-database/sql-database-recovery-using-backups#point-in-time-restore).
* For Azure Storage, table data and blob data are replicated by default to an alternate region. However, you cannot access the replicas until Microsoft chooses to fail over to the alternate site. A region failover occurs only during a prolonged region-wide service disruption, and there is no SLA for geo-failover time. It's also important to note that any data corruption quickly spreads to the replicas. For these reasons, you must supplement platform availability features with application-specific availability features, including the blob snapshot feature to create point-in-time backups of blob data.

### Availability sets for Azure Virtual Machines
This document primarily focuses on cloud services, which use a platform-as-a-service (PaaS) model. There are also specific availability features for Azure Virtual Machines, which use an infrastructure-as-a-service (IaaS) model. To achieve high availability with Virtual Machines, you must use availability sets, which serve a similar function to fault and upgrade domains. Within an availability set, Azure positions the virtual machines in a way that prevents localized hardware faults and maintenance activities from bringing down all the machines in that group. Availability sets are required to achieve the Azure SLA for the availability of Virtual Machines.

The following diagram shows two availability sets for web and SQL Server virtual machines, respectively.

![Availability sets for Azure Virtual Machines](./images/high-availability-azure-applications/availability-set-for-azure-virtual-machines.png)

> [!NOTE]
> In the preceding diagram, SQL Server is installed and running on virtual machines. This is different from Azure SQL Database, which provides a database as a managed service.
> 
> 

## Application strategies for high availability
Most application strategies for high availability involve either redundancy or the removal of hard dependencies between application components. Application design should support fault tolerance during sporadic downtime of Azure or third-party services. The following sections describe application patterns for improving the availability of your cloud services.

### Asynchronous communication and durable queues
To increase availability in Azure applications, consider asynchronous communication between loosely coupled services. In this pattern, messages are written to either storage queues or Azure Service Bus queues for later processing. When a message is written to the queue, control immediately returns to the sender. Another service of the application (typically implemented as a worker role) processes the message. If the processing service stops working, the messages accumulate in the queue until the processing service is restored. There is no direct dependency between the front-end sender and the message processor. This eliminates synchronous service calls that can cause bottlenecks in distributed applications.

A variation of this pattern stores information about failed database calls in Azure Storage (blobs, tables, or queues) or Service Bus queues. For example, a synchronous call within an application to another service (such as Azure SQL Database) fails repeatedly. You might be able to serialize that request into durable storage. At some later point when the service or database is back online, the application can resubmit the request from storage. The difference in this model is that the intermediate location is used only during failures, not as a regular part of the application workflow.

In both scenarios, asynchronous communication and intermediate storage prevent a downed back-end service from bringing down the entire application. Queues serve as a logical intermediary. For more information on choosing between queuing services, see [Azure queues and Azure Service Bus queues &mdash; compared and contrasted](/azure/service-bus-messaging/service-bus-azure-and-service-bus-queues-compared-contrasted/).

### Fault detection and retry logic
A key aspect of the design of highly available applications is the use of retry logic within code to gracefully handle a service that is temporarily unavailable. Recent versions of SDKs for both Azure Storage and Azure Service Bus natively support retries. For more information on providing custom retry logic for your application, see the [Retry pattern](../patterns/retry.md).

### Reference data pattern for high availability
Reference data is the read-only data of an application. This data provides the business context within which the application generates transactional data during a business operation. The integrity of transactional data depends on a snapshot of the reference data at the time the transaction was completed.

Reference data is necessary for the proper operation of the application. Various applications create and maintain reference data; master data management (MDM) systems often perform this function. These systems are responsible for the life cycle of the reference data. Examples of reference data include product catalog, employee master, parts master, and equipment master. Reference data can also originate from outside the organization, for example, postal codes or tax rates. Strategies for increasing the availability of reference data are typically less difficult than those for transactional data. Reference data has the advantage of being mostly immutable.

Azure web and worker roles that consume reference data can be made autonomous at runtime by deploying the reference data along with the application. This approach is ideal if the size of the local storage allows such a deployment. Embedded SQL databases, NoSQL databases, or XML files deployed locally help with the autonomy of Azure compute scale units. However, you should have a mechanism to update the data in each role without requiring redeployment. To do this, place any updates to the reference data at a cloud storage endpoint (for example, Azure Blob storage or SQL Database). Add code to each role that downloads the data updates into the compute nodes at role startup. Alternatively, add code that allows an administrator to perform a forced download into the role instances.

To increase availability, the roles should also contain a set of reference data in case storage is down. Roles can start with a basic set of reference data until the storage resource becomes available for the updates.

![Application high availability through autonomous compute nodes](./images/high-availability-azure-applications/application-high-availability-through-autonomous-compute-nodes.png)

With this pattern, new deployments or role instances may take longer to start if you are deploying or downloading large amounts of reference data. This tradeoff might be acceptable for the autonomy of having the reference data immediately available on each role, rather than depending on external storage services.

### Transactional data pattern for high availability
Transactional data is the data that the application generates in a business context. Transactional data is a combination of the set of business processes that the application implements and the reference data that supports these processes. Examples of transactional data can include orders, advanced shipping notices, invoices, and customer relationship management (CRM) opportunities. Transactional data is supplied to external systems for record keeping or for further processing.

Reference data can change within the systems that are responsible for that data. Therefore, transactional data must save the point-in-time reference data context to minimize external dependencies for its semantic consistency. For example, a product may be removed from the catalog several months after an order is fulfilled. Storing as much reference data context as possible with the transaction is recommended. This approach preserves the semantics associated with the transaction, even if the reference data changes after the transaction is captured.

As mentioned previously, architectures that use loose coupling and asynchronous communication can provide higher levels of availability. This is true for transactional data as well, but the implementation is more complex. Traditional transactional patterns usually rely on the database for guaranteeing the transaction. When you introduce intermediate layers, the application code must correctly handle the data at various layers to ensure sufficient consistency and durability.

The following sequence describes a workflow that separates the capture of transactional data from its processing:

1. Web compute node: Present reference data.
2. External storage: Save intermediate transactional data.
3. Web compute node: Complete the end-user transaction.
4. Web compute node: Send the completed transactional data with its reference data context to temporary durable storage that is guaranteed to give a predictable response.
5. Web compute node: Signal the end-user completion of the transaction.
6. Background compute node: Extract the transactional data, process it further if necessary, and send it to its final storage location in the current system.

The following diagram shows one possible implementation of this design in an Azure-hosted cloud service.

![High availability through loose coupling](./images/disaster-recovery-high-availability-azure-applications/application-high-availability-through-loose-coupling.png)

The dashed arrows in the preceding diagram indicate asynchronous processing. The front-end web role is not aware of this asynchronous processing. This leads to the storage of the transaction at its final destination with reference to the current system. Due to the latency that this asynchronous model introduces, the transactional data is not immediately available for query. Therefore, each unit of the transactional data needs to be saved in a cache or a user session to meet the immediate UI needs.

The web role is autonomous from the rest of the infrastructure. Its availability profile is a combination of the web role and the Azure queue and not the entire infrastructure. In addition to high availability, this approach allows the web role to scale horizontally, independent of the back-end storage. This high-availability model can have an impact on the economics of operations. Additional components like Azure queues and worker roles can affect monthly usage costs.

The previous diagram shows one implementation of this decoupled approach to transactional data. There are many other possible implementations. The following list provides some alternatives:

* A worker role might be placed between the web role and the storage queue.
* A Service Bus queue can be used instead of an Azure Storage queue.
* The final destination might be Azure Storage or a different database provider.
* Azure Cache can be used at the web layer to provide the immediate caching requirements after the transaction.

### Scalability patterns
It's important to note that the scalability of a cloud service directly affects availability. If increased load causes your service to be unresponsive, the user perception is that the application is down. Follow proven practices for scalability based on your expected application load and future expectations. Maximizing scale involves many considerations, such as single versus multiple storage accounts, sharing across multiple databases, and caching strategies. For in-depth information about these patterns, see [Best practices for designing large-scale services on Microsoft Azure](https://azure.microsoft.com/blog/best-practices-for-designing-large-scale-services-on-windows-azure/).

## Next steps
This series of documents covers disaster recovery and high availability for applications built on Microsoft Azure. The next article in the series is [Disaster recovery for applications built on Microsoft Azure](disaster-recovery-azure-applications.md).

