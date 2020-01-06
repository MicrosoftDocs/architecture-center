---
title: Designing resilient Azure applications
description: 
author: david-stanford
ms.date: 10/16/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: cloud-design-principles
ms.custom: How have you ensured that your application is resilient to failures? 
---

# Designing resilient Azure applications

Building *resiliency* (recovering from failures) and *availability* (running in a healthy state without significant downtime) into your apps begins with gathering requirements. For example, how much downtime is acceptable? How much does potential downtime cost your business? What are your customer's availability requirements? How much do you invest in making your application highly available? What is the risk versus the cost?

## Determine subscription and service requirements

Choose the right subscription and service features for your app by working through these tasks:

- **Evaluate requirements against [Azure subscription and service limits](/azure/azure-subscription-service-limits/).** *Azure subscriptions* have limits on certain resource types, such as number of resource groups, cores, and storage accounts. If your application requirements exceed Azure subscription limits, create another Azure subscription and provision sufficient resources there. Individual Azure services have consumption limits &mdash; for example, limits on storage, throughput, number of connections, requests per second, and other metrics. Your application will fail if it attempts to use resources beyond these limits, resulting in service throttling and possible downtime for affected users. Depending on the specific service and your application requirements, you can often avoid these limits by scaling up (for example, choosing another pricing tier) or scaling out (such as adding new instances).
- **Determine how many storage accounts you need.** Azure allows a specific number of storage accounts per subscription. For more information, see [Azure subscription and service limits, quotas, and constraints](/azure/azure-subscription-service-limits/#storage-limits).
- **Select the right service tier for Azure SQL Database.** If your application uses Azure SQL Database, select the appropriate service tier. If the tier cannot handle your application's database transaction unit (DTU) requirements, your data use will be throttled. For more information on selecting the correct service plan, see [SQL Database options and performance: Understand what's available in each service tier](/azure/sql-database/sql-database-service-tiers/).
- **Provision sufficient request units (RUs) in Azure Cosmos DB**. With Azure Cosmos DB, you pay for the throughput you provision and the storage you consume on an hourly basis. The cost of all database operations is normalized as RUs, which abstracts the system resources such as CPU, IOPS, and memory. For more information, see [Request Units in Azure Cosmos DB](/azure/cosmos-db/request-units).

## Resiliency strategies

This section describes some common resiliency strategies. Most of these strategies are not limited to a particular technology. The descriptions summarize the general idea behind each technique and include links to further reading.

- **Implement resiliency patterns** for remote operations, where appropriate. If your application depends on communication between remote services, follow [design patterns](/azure/architecture/patterns/category/resiliency) for dealing with transient failures.

- **Retry transient failures.** These can be caused by momentary loss of network connectivity, a dropped database connection, or a timeout when a service is busy. Often, a transient failure can be resolved by retrying the request.

  - For many Azure services, the client software development kit (SDK) implements automatic retries in a way that is transparent to the caller. See [Retry guidance for specific services](/azure/architecture/best-practices/retry-service-specific).
  - Or implement the [Retry pattern](/azure/architecture/patterns/retry) to help the application handle anticipated, temporary failures transparently when it tries to connect to a service or network resource.

- **Use a circuit breaker** to handle faults that might take a variable amount of time to fix. The [Circuit Breaker pattern](/azure/architecture/patterns/circuit-breaker) can prevent an application from repeatedly trying an operation that is likely to fail. The circuit breaker wraps calls to a service and tracks the number of recent failures. If the failure count exceeds a threshold, the circuit breaker starts returning an error code without calling the service. This gives the service time to recover and helps avoid cascading failures.
- **Isolate critical resources.** Failures in one subsystem can sometimes cascade, resulting in failures in other parts of the application. This can happen if a failure prevents resources such as threads or sockets from being freed, leading to resource exhaustion. To avoid this, you can partition a system into isolated groups so that a failure in one partition does not bring down the entire system.

    Here are some examples of this technique, which is sometimes called the [Bulkhead pattern](/azure/architecture/patterns/bulkhead):

  - Partition a database (for example, by tenant), and assign a separate pool of web server instances for each partition.
  - Use separate thread pools to isolate calls to different services. This helps to prevent cascading failures if one of the services fails. For an example, see the Netflix [Hystrix library](https://medium.com/netflix-techblog/introducing-hystrix-for-resiliency-engineering-13531c1ab362).
  - Use [containers](https://en.wikipedia.org/wiki/Operating-system-level_virtualization) to limit the resources available to a particular subsystem.

      ![Diagram of the Bulkhead pattern](/azure/architecture/framework/_images/bulkhead.png)

- **Apply [*compensating transactions*](/azure/architecture/patterns/compensating-transaction)**. A compensating transaction is a transaction that undoes the effects of another completed transaction. In a distributed system, it can be difficult to achieve strong transactional consistency. Compensating transactions help to achieve consistency by using a series of smaller, individual transactions that can be undone at each step. For example, to book a trip, a customer might reserve a car, a hotel room, and a flight. If one of these steps fails, the entire operation fails. Instead of trying to use a single distributed transaction for the entire operation, you can define a compensating transaction for each step.
- **Implement asynchronous operations, whenever possible.** Synchronous operations can monopolize resources and block other operations while the caller waits for the process to complete. Design each part of your application to allow for asynchronous operations, whenever possible. For more information on how to implement asynchronous programming in C\#, see [Asynchronous Programming](/dotnet/articles/csharp/async).

## Plan for usage patterns

Identify differences in requirements during critical and non-critical periods. Are there certain critical periods when the system must be available? For example, a tax-filing application can't fail during a filing deadline and a video streaming service shouldn't lag during a live event. In these situations, weigh the cost against the risk.

- To ensure uptime and meet service-level agreements (SLAs) in critical periods, plan redundancy across several regions in case one fails, even if it costs more.
- Conversely, during non-critical periods, run your application in a single region to minimize costs.
- In some cases, you can mitigate additional expenses by using modern serverless techniques that have consumption-based billing.

## Identify distinct workloads

Cloud solutions typically consist of multiple application *workloads*. A workload is a distinct capability or task that is logically separated from other tasks in terms of business logic and data storage requirements. For example, an e-commerce app might have the following workloads:

- Browse and search a product catalog.
- Create and track orders.
- View recommendations.

Each workload has different requirements for availability, scalability, data consistency, and disaster recovery. Make your business decisions by balancing cost versus risk for each workload.

Also decompose workloads by service-level objective. If a service is composed of critical and less-critical workloads, manage them differently and specify the service features and number of instances needed to meet their availability requirements.

## Managing third party services

If your application has dependencies on third-party services, identify how these services can fail and what effect failures will have on your application.

A third-party service might not include monitoring and diagnostics. Log calls to these services and correlate them with your application's health and diagnostic logging using a unique identifier. For more information on proven practices for monitoring and diagnostics, see [Monitoring and diagnostics guidance](/azure/architecture/best-practices/monitoring).

See the [Health Endpoint Monitoring pattern](/azure/architecture/patterns/health-endpoint-monitoring) for a solution to track this with code samples.

## Monitoring third-party services

If your application has dependencies on third-party services, identify where and how these services can fail and what effect those failures will have on your application. Keep in mind the service-level agreement (SLA) for the third-party service and the effect it might have on your disaster recovery plan.

A third-party service might not provide monitoring and diagnostics capabilities, so it's important to log your invocations of them and to correlate them with your application's health and diagnostic logging using a unique identifier. For more information on proven practices for monitoring and diagnostics, see [Monitoring and diagnostics guidance](/azure/architecture/best-practices/monitoring).

## Load balancing

To load balance traffic across regions requires a traffic management solution. Azure provides [Azure Traffic Manager](https://azure.microsoft.com/services/traffic-manager). You can also take advantage of third-party services that provide similar traffic management capabilities.

Proper load-balancing allows you to meet availability requirements and to minimize costs associated with availability.

- **Use load-balancing to distribute requests.** Load-balancing distributes your application's requests to healthy service instances by removing unhealthy instances from rotation. If your service uses Azure App Service or Azure Cloud Services, it's already load-balanced for you. However, if your application uses Azure VMs, you need to provision a load-balancer. For more information, see [What is Azure Load Balancer?](/azure/load-balancer/load-balancer-overview/)

  You can use Azure Load Balancer to:

  - Load-balance incoming Internet traffic to your VMs. This configuration is known as a [*public Load Balancer*](/azure/load-balancer/load-balancer-overview#publicloadbalancer).
  - Load-balance traffic across VMs inside a virtual network. You can also reach a Load Balancer front end from an on-premises network in a hybrid scenario. Both scenarios use a configuration that is known as an [*internal Load Balancer*](/azure/load-balancer/load-balancer-overview#internalloadbalancer).
  - Port forward traffic to an itemized port on specific VMs with inbound network address translation (NAT) rules.
  - Provide [outbound connectivity](/azure/load-balancer/load-balancer-outbound-connections) for VMs inside your virtual network by using a public Load Balancer.

- **Balance loads across regions with a traffic manager, such as Azure Traffic Manager.** To load-balance traffic across regions requires a traffic management solution, and Azure provides [Traffic Manager](https://azure.microsoft.com/services/traffic-manager/). You can also take advantage of third-party services that provide similar traffic-management capabilities.

## Failure mode analysis

Failure mode analysis (FMA) is a process for building resiliency into a system, by identifying possible failure points in the system. The FMA should be part of the architecture and design phases, so that you can build failure recovery into the system from the beginning.
*Failure mode analysis* (FMA) builds resiliency into a system by identifying possible failure points and defining how the application responds to those failures. The FMA should be part of the architecture and design phases, so failure recovery is built into the system from the beginning. The goals of an FMA are to:

- Determine what types of failures an application might experience and how the application detects those failures.
- Capture the potential effects of each type of failure and determine how the app responds.
- Plan for logging and monitoring the failure and identify recovery strategies.

Here are some examples of failure modes and detection strategies for a specific failure point &mdash; a call to an external web service:

| Failure mode           | Detection strategy           |
|------------------------|------------------------------|
| Service is unavailable | HTTP 5xx                     |
| Throttling             | HTTP 429 (Too Many Requests) |
| Authentication         | HTTP 401 (Unauthorized)      |
| Slow response          | Request times out            |

For more information about the FMA process, with specific recommendations for Azure, see [Failure mode analysis][failure-mode-analysis].

## Operating in multiple regions

If your application is deployed to a single region, in the rare event the entire region becomes unavailable, your application will also be unavailable. This may be unacceptable under the terms of your application's SLA. If so, consider deploying your application and its services across multiple regions. A multi-region deployment can use an active-active pattern (distributing requests across multiple active instances) or an active-passive pattern (keeping a "warm" instance in reserve, in case the primary instance fails)

Many failures are manageable within the same Azure region. However, in the unlikely event of a region-wide service disruption, the locally redundant copies of your data aren't available. If you've enabled geo-replication, there are three additional copies of your blobs and tables in a different region. If Microsoft declares the region lost, Azure remaps all the DNS entries to the secondary region.

> [!NOTE]
> This process occurs only for region-wide service disruptions and is not within your control. Consider using [Azure Site Recovery](/azure/site-recovery/) to achieve better RPO and RTO. Using Site Recovery, you decide what is an acceptable outage and when to fail over to the replicated VMs.

>[!NOTE]
>The selection of the Resource Group location is important. In the event of a regional outage, you will be unable to control resources inside that Resource Group, regardless of what region those resources are actually in (i.e., the resources in the other region(s) will continue to function, but management plane operations will be unavailable.

Your response to a region-wide service disruption depends on your deployment and your disaster recovery plan.

- As a cost-control strategy, for non-critical applications that don't require a guaranteed recovery time, it might make sense to redeploy to a different region.
- For applications that are hosted in another region with deployed roles but don't distribute traffic across regions (*active/passive deployment*), switch to the secondary hosted service in the alternate region.
- For applications that have a full-scale secondary deployment in another region (*active/active deployment*), route traffic to that region.

To learn more about recovering from a region-wide service disruption, see [Recover from a region-wide service disruption](/azure/architecture/resiliency/recovery-loss-azure-region).

### VM recovery

For critical apps, plan for recovering VMs in the event of a region-wide service disruption.

- Use Azure Backup or another backup method to create cross-region backups that are application consistent. (Replication of the Backup vault must be configured at the time of creation.)
- Use Site Recovery to replicate across regions for one-click application failover and failover testing.
- Use Traffic Manager to automate user traffic failover to another region.

To learn more, see [Recover from a region-wide service disruption, Virtual machines](/azure/architecture/resiliency/recovery-loss-azure-region#virtual-machines).

### Storage recovery

To protect your storage in the event of a region-wide service disruption:

- Use geo-redundant storage.
- Know where your storage is geo-replicated. This affects where you deploy other instances of your data that require regional affinity with your storage.
- Check data for consistency after failover and, if necessary, restore from a backup.

To learn more, see [Designing highly available applications using RA-GRS](/azure/storage/common/storage-designing-ha-apps-with-ragrs).

### SQL Database and SQL Server

Azure SQL Database provides two types of recovery:

- Use geo-restore to restore a database from a backup copy in another region. For more information, see [Recover an Azure SQL database using automated database backups](/azure/sql-database/sql-database-recovery-using-backups).
- Use active geo-replication to fail over to a secondary database. For more information, see [Creating and using active geo-replication](/azure/sql-database/sql-database-active-geo-replication).

For SQL Server running on VMs, see [High availability and disaster recovery for SQL Server in Azure Virtual Machines](/azure/virtual-machines/windows/sql/virtual-machines-windows-sql-high-availability-dr/).

<!-- links -->
[failure-mode-analysis]: /azure/architecture/resiliency/failure-mode-analysis