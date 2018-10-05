---
title: Resiliency checklist
description: Checklist that provides guidance for resiliency concerns during design.
author: petertaylor9999
ms.date: 01/10/2018
ms.custom: resiliency, checklist
---
# Resiliency checklist

Resiliency is the ability of a system to recover from failures and continue to function, and is one of the [pillars of software quality](../guide/pillars.md). Designing your application for resiliency requires planning for and mitigating a variety of failure modes that could occur. Use this checklist to review your application architecture from a resiliency standpoint. Also review the [Resiliency checklist for specific Azure services](./resiliency-per-service.md).

## Requirements

**Define your customer's availability requirements.** Your customer will have availability requirements for the components in your application and this will affect your application's design. Get agreement from your customer for the availability targets of each piece of your application, otherwise your design may not meet the customer's expectations. For more information, see [Designing resilient applications for Azure](../resiliency/index.md).

## Application Design

**Perform a failure mode analysis (FMA) for your application.** FMA is a process for building resiliency into an application early in the design stage. For more information, see [Failure mode analysis][fma]. The goals of an FMA include:  

* Identify what types of failures an application might experience.
* Capture the potential effects and impact of each type of failure on the application.
* Identify recovery strategies.
  

**Deploy multiple instances of services.** If your application depends on a single instance of a service, it creates a single point of failure. Provisioning multiple instances improves both resiliency and scalability. For [Azure App Service](/azure/app-service/app-service-value-prop-what-is/), select an [App Service Plan](/azure/app-service/azure-web-sites-web-hosting-plans-in-depth-overview/) that offers multiple instances. For Azure Cloud Services, configure each of your roles to use [multiple instances](/azure/cloud-services/cloud-services-choose-me/#scaling-and-management). For [Azure Virtual Machines (VMs)](/azure/virtual-machines/virtual-machines-windows-about/?toc=%2fazure%2fvirtual-machines%2fwindows%2ftoc.json), ensure that your VM architecture includes more than one VM and that each VM is included in an [availability set][availability-sets].   

**Use autoscaling to respond to increases in load.** If your application is not configured to scale out automatically as load increases, it's possible that your application's services will fail if they become saturated with user requests. For more details, see the following:

* General: [Scalability checklist](./scalability.md)
* Azure App Service: [Scale instance count manually or automatically][app-service-autoscale]
* Cloud Services: [How to auto scale a cloud service][cloud-service-autoscale]
* Virtual Machines: [Automatic scaling and virtual machine scale sets][vmss-autoscale]

**Use load balancing to distribute requests.** Load balancing distributes your application's requests to healthy service instances by removing unhealthy instances from rotation. If your service uses Azure App Service or Azure Cloud Services, it is already load balanced for you. However, if your application uses Azure VMs, you will need to provision a load balancer. See the [Azure Load Balancer](/azure/load-balancer/load-balancer-overview/) overview for more details.

**Configure Azure Application Gateways to use multiple instances.** Depending on your application's requirements, an [Azure Application Gateway](/azure/application-gateway/application-gateway-introduction/) may be better suited to distributing requests to your application's services. However, single instances of the Application Gateway service are not guaranteed by an SLA so it's possible that your application could fail if the Application Gateway instance fails. Provision more than one medium or larger Application Gateway instance to guarantee availability of the service under the terms of the [SLA](https://azure.microsoft.com/support/legal/sla/application-gateway/).

**Use Availability Sets for each application tier.** Placing your instances in an [availability set][availability-sets] provides a higher [SLA](https://azure.microsoft.com/support/legal/sla/virtual-machines/). 

**Consider deploying your application across multiple regions.** If your application is deployed to a single region, in the rare event the entire region becomes unavailable, your application will also be unavailable. This may be unacceptable under the terms of your application's SLA. If so, consider deploying your application and its services across multiple regions. A multi-region deployment can use an active-active pattern (distributing requests across multiple active instances) or an active-passive pattern (keeping a "warm" instance in reserve, in case the primary instance fails). We recommend that you deploy multiple instances of your application's services across regional pairs. For more information, see [Business continuity and disaster recovery (BCDR): Azure Paired Regions](/azure/best-practices-availability-paired-regions).

**Use Azure Traffic Manager to route your application's traffic to different regions.**  [Azure Traffic Manager][traffic-manager] performs load balancing at the DNS level and will route traffic to different regions based on the [traffic routing][traffic-manager-routing] method you specify and the health of your application's endpoints. Without Traffic Manager, you are limited to a single region for your deployment, which limits scale, increases latency for some users, and causes application downtime in the case of a region-wide service disruption.

**Configure and test health probes for your load balancers and traffic managers.** Ensure that your health logic checks the critical parts of the system and responds appropriately to health probes.

* The health probes for [Azure Traffic Manager][traffic-manager] and [Azure Load Balancer][load-balancer] serve a specific function. For Traffic Manager, the health probe determines whether to fail over to another region. For a load balancer, it determines whether to remove a VM from rotation.      
* For a Traffic Manager probe, your health endpoint should check any critical dependencies that are deployed within the same region, and whose failure should trigger a failover to another region.  
* For a load balancer, the health endpoint should report the health of the VM. Don't include other tiers or external services. Otherwise, a failure that occurs outside the VM will cause the load balancer to remove the VM from rotation.
* For guidance on implementing health monitoring in your application, see [Health Endpoint Monitoring Pattern](https://msdn.microsoft.com/library/dn589789.aspx).

**Monitor third-party services.** If your application has dependencies on third-party services, identify where and how these third-party services can fail and what effect those failures will have on your application. A third-party service may not include monitoring and diagnostics, so it's important to log your invocations of them and correlate them with your application's health and diagnostic logging using a unique identifier. For more information on proven practices for monitoring and diagnostics, see [Monitoring and Diagnostics guidance][monitoring-and-diagnostics-guidance].

**Ensure that any third-party service you consume provides an SLA.** If your application depends on a third-party service, but the third party provides no guarantee of availability in the form of an SLA, your application's availability also cannot be guaranteed. Your SLA is only as good as the least available component of your application.

**Implement resiliency patterns for remote operations where appropriate.** If your application depends on communication between remote services, follow [design patterns](../patterns/category/resiliency.md) for dealing with transient failures, such as [Retry Pattern][retry-pattern], and [Circuit Breaker Pattern][circuit-breaker]. 

**Implement asynchronous operations whenever possible.** Synchronous operations can monopolize resources and block other operations while the caller waits for the process to complete. Design each part of your application to allow for asynchronous operations whenever possible. For more information on how to implement asynchronous programming in C#, see [Asynchronous Programming with async and await][asynchronous-c-sharp].

## Data management

**Understand the replication methods for your application's data sources.** Your application data will be stored in different data sources and have different availability requirements. Evaluate the replication methods for each type of data storage in Azure, including [Azure Storage Replication](/azure/storage/storage-redundancy/) and [SQL Database Active Geo-Replication](/azure/sql-database/sql-database-geo-replication-overview/) to ensure that your application's data requirements are satisfied.

**Ensure that no single user account has access to both production and backup data.** Your data backups are compromised if one single user account has permission to write to both production and backup sources. A malicious user could purposely delete all your data, while a regular user could accidentally delete it. Design your application to limit the permissions of each user account so that only the users that require write access have write access and it's only to either production or backup, but not both.

**Document your data source fail over and fail back process and test it.** In the case where your data source fails catastrophically, a human operator will have to follow a set of documented instructions to fail over to a new data source. If the documented steps have errors, an operator will not be able to successfully follow them and fail over the resource. Regularly test the instruction steps to verify that an operator following them is able to successfully fail over and fail back the data source.

**Validate your data backups.** Regularly verify that your backup data is what you expect by running a script to validate data integrity, schema, and queries. There's no point having a backup if it's not useful to restore your data sources. Log and report any inconsistencies so the backup service can be repaired.

**Consider using a storage account type that is geo-redundant.** Data stored in an Azure Storage account is always replicated locally. However, there are multiple replication strategies to choose from when a Storage Account is provisioned. Select [Azure Read-Access Geo Redundant Storage (RA-GRS)](/azure/storage/storage-redundancy/#read-access-geo-redundant-storage) to protect your application data against the rare case when an entire region becomes unavailable.

> [!NOTE]
> For VMs, do not rely on RA-GRS replication to restore the VM disks (VHD files). Instead, use [Azure Backup][azure-backup].   
>
>

## Security

**Implement application-level protection against distributed denial of service (DDoS) attacks.** Azure services are protected against DDos attacks at the network layer. However, Azure cannot protect against application-layer attacks, because it is difficult to distinguish between true user requests from malicious user requests. For more information on how to protect against application-layer DDoS attacks, see the "Protecting against DDoS" section of [Microsoft Azure Network Security](https://download.microsoft.com/download/C/A/3/CA3FC5C0-ECE0-4F87-BF4B-D74064A00846/AzureNetworkSecurity_v3_Feb2015.pdf) (PDF download).

**Implement the principle of least privilege for access to the application's resources.** The default for access to the application's resources should be as restrictive as possible. Grant higher level permissions on an approval basis. Granting overly permissive access to your application's resources by default can result in someone purposely or accidentally deleting resources. Azure provides [role-based access control](/azure/active-directory/role-based-access-built-in-roles/) to manage user privileges, but it's important to verify least privilege permissions for other resources that have their own permissions systems such as SQL Server.

## Testing

**Perform failover and failback testing for your application.** If you haven't fully tested failover and failback, you can't be certain that the dependent services in your application come back up in a synchronized manner during disaster recovery. Ensure that your application's dependent services failover and fail back in the correct order.

**Perform fault-injection testing for your application.** Your application can fail for many different reasons, such as certificate expiration, exhaustion of system resources in a VM, or storage failures. Test your application in an environment as close as possible to production, by simulating or triggering real failures. For example, delete certificates, artificially consume system resources, or delete a storage source. Verify your application's ability to recover from all types of faults, alone and in combination. Check that failures are not propagating or cascading through your system.

**Run tests in production using both synthetic and real user data.** Test and production are rarely identical, so it's important to use blue/green or a canary deployment and test your application in production. This allows you to test your application in production under real load and ensure it will function as expected when fully deployed.

## Deployment

**Document the release process for your application.** Without detailed release process documentation, an operator might deploy a bad update or improperly configure settings for your application. Clearly define and document your release process, and ensure that it's available to the entire operations team. 

**Automate your application's deployment process.** If your operations staff is required to manually deploy your application, human error can cause the deployment to fail. 

**Design your release process to maximize application availability.** If your release process requires services to go offline during deployment, your application will be unavailable until they come back online. Use the [blue/green](https://martinfowler.com/bliki/BlueGreenDeployment.html) or [canary release](https://martinfowler.com/bliki/CanaryRelease.html) deployment technique to deploy your application to production. Both of these techniques involve deploying your release code alongside production code so users of release code can be redirected to production code in the event of a failure.

**Log and audit your application's deployments.** If you use staged deployment techniques such as blue/green or canary releases there will be more than one version of your application running in production. If a problem should occur, it's critical to determine which version of your application is causing a problem. Implement a robust logging strategy to capture as much version-specific information as possible.

**Have a rollback plan for deployment.** It's possible that your application deployment could fail and cause your application to become unavailable. Design a rollback process to go back to a last known good version and minimize downtime. 

## Operations

**Implement best practices for monitoring and alerting in your application.** Without proper monitoring, diagnostics, and alerting, there is no way to detect failures in your application and alert an operator to fix them. For more information, see [Monitoring and Diagnostics guidance][monitoring-and-diagnostics-guidance].

**Measure remote call statistics and make the information available to the application team.**  If you don't track and report remote call statistics in real time and provide an easy way to review this information, the operations team will not have an instantaneous view into the health of your application. And if you only measure average remote call time, you will not have enough information to reveal issues in the services. Summarize remote call metrics such as latency, throughput, and errors in the 99 and 95 percentiles. Perform statistical analysis on the metrics to uncover errors that occur within each percentile.

**Track the number of transient exceptions and retries over an appropriate timeframe.** If you don't track and monitor transient exceptions and retry attempts over time, it's possible that an issue or failure could be hidden by your application's retry logic. That is, if your monitoring and logging only shows success or failure of an operation, the fact that the operation had to be retried multiple times due to exceptions will be hidden. A trend of increasing exceptions over time indicates that the service is having an issue and may fail. For more information, see [Retry service specific guidance][retry-service-guidance].

**Implement an early warning system that alerts an operator.** Identify the key performance indicators of your application's health, such as transient exceptions and remote call latency, and set appropriate threshold values for each of them. Send an alert to operations when the threshold value is reached. Set these thresholds at levels that identify issues before they become critical and require a recovery response.

**Ensure that more than one person on the team is trained to monitor the application and perform any manual recovery steps.** If you only have a single operator on the team who can monitor the application and kick off recovery steps, that person becomes a single point of failure. Train multiple individuals on detection and recovery and make sure there is always at least one active at any time.

**Ensure that your application does not run up against [Azure subscription limits](/azure/azure-subscription-service-limits/).** Azure subscriptions have limits on certain resource types, such as number of resource groups, number of cores, and number of storage accounts.  If your application requirements exceed Azure subscription limits, create another Azure subscription and provision sufficient resources there.

**Ensure that your application does not run up against [per-service limits](/azure/azure-subscription-service-limits/).** Individual Azure services have consumption limits &mdash; for example, limits on storage, throughput, number of connections, requests per second, and other metrics. Your application will fail if it attempts to use resources beyond these limits. This will result in service throttling and possible downtime for affected users. Depending on the specific service and your application requirements, you can often avoid these limits by scaling up (for example, choosing another pricing tier) or scaling out (adding new instances).  

**Design your application's storage requirements to fall within Azure storage scalability and performance targets.** Azure storage is designed to function within predefined scalability and performance targets, so design your application to utilize storage within those targets. If you exceed these targets your application will experience storage throttling. To fix this, provision additional Storage Accounts. If you run up against the Storage Account limit, provision additional Azure Subscriptions and then provision additional Storage Accounts there. For more information, see [Azure Storage Scalability and Performance Targets](/azure/storage/storage-scalability-targets/).

**Select the right VM size for your application.** Measure the actual CPU, memory, disk, and I/O of your VMs in production and verify that the VM size you've selected is sufficient. If not, your application may experience capacity issues as the VMs approach their limits. VM sizes are described in detail in [Sizes for virtual machines in Azure](/azure/virtual-machines/virtual-machines-windows-sizes/?toc=%2fazure%2fvirtual-machines%2fwindows%2ftoc.json).

**Determine if your application's workload is stable or fluctuating over time.** If your workload fluctuates over time, use Azure VM scale sets to automatically scale the number of VM instances. Otherwise, you will have to manually increase or decrease the number of VMs. For more information, see the [Virtual Machine Scale Sets Overview](/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-overview/).

**Select the right service tier for Azure SQL Database.** If your application uses Azure SQL Database, ensure that you have selected the appropriate service tier. If you select a tier that is not able to handle your application's database transaction unit (DTU) requirements, your data use will be throttled. For more information on selecting the correct service plan, see [SQL Database options and performance: Understand what's available in each service tier](/azure/sql-database/sql-database-service-tiers/).

**Create a process for interacting with Azure support.** If the process for contacting [Azure support](https://azure.microsoft.com/support/plans/) is not set before the need to contact support arises, downtime will be prolonged as the support process is navigated for the first time. Include the process for contacting support and escalating issues as part of your application's resiliency from the outset.

**Ensure that your application doesn't use more than the maximum number of storage accounts per subscription.** Azure allows a maximum of 200 storage accounts per subscription. If your application requires more storage accounts than are currently available in your subscription, you will have to create a new subscription and create additional storage accounts there. For more information, see [Azure subscription and service limits, quotas, and constraints](/azure/azure-subscription-service-limits/#storage-limits).

**Ensure that your application doesn't exceed the scalability targets for virtual machine disks.** An Azure IaaS VM supports attaching a number of data disks depending on several factors, including the VM size and type of storage account. If your application exceeds the scalability targets for virtual machine disks, provision additional storage accounts and create the virtual machine disks there. For more information, see [Azure Storage Scalability and Performance Targets](/azure/storage/storage-scalability-targets/#scalability-targets-for-virtual-machine-disks)

## Telemetry

**Log telemetry data while the application is running in the production environment.** Capture robust telemetry information while the application is running in the production environment or you will not have sufficient information to diagnose the cause of issues while it's actively serving users. For more information, see [Monitoring and Diagnostics][monitoring-and-diagnostics-guidance].

**Implement logging using an asynchronous pattern.** If logging operations are synchronous, they might block your application code. Ensure that your logging operations are implemented as asynchronous operations.

**Correlate log data across service boundaries.** In a typical n-tier application, a user request may traverse several service boundaries. For example, a user request typically originates in the web tier and is passed to the business tier and finally persisted in the data tier. In more complex scenarios, a user request may be distributed to many different services and data stores. Ensure that your logging system correlates calls across service boundaries so you can track the request throughout your application.

## Azure Resources

**Use Azure Resource Manager templates to provision resources.** Resource Manager templates make it easier to automate deployments via PowerShell or the Azure CLI, which leads to a more reliable deployment process. For more information, see [Azure Resource Manager overview][resource-manager].

**Give resources meaningful names.** Giving resources meaningful names makes it easier to locate a specific resource and understand its role. For more information, see [Naming conventions for Azure resources](../best-practices/naming-conventions.md)

**Use role-based access control (RBAC).** Use RBAC to control access to the Azure resources that you deploy. RBAC lets you assign authorization roles to members of your DevOps team, to prevent accidental deletion or changes to deployed resources. For more information, see [Get started with access management in the Azure portal](/azure/active-directory/role-based-access-control-what-is/)

**Use resource locks for critical resources, such as VMs.** Resource locks prevent an operator from accidentally deleting a resource. For more information, see [Lock resources with Azure Resource Manager](/azure/azure-resource-manager/resource-group-lock-resources/)

**Choose regional pairs.** When deploying to two regions, choose regions from the same regional pair. In the event of a broad outage, recovery of one region is prioritized out of every pair. Some services such as Geo-Redundant Storage provide automatic replication to the paired region. For more information, see [Business continuity and disaster recovery (BCDR): Azure Paired Regions](/azure/best-practices-availability-paired-regions)

**Organize resource groups by function and lifecycle.**  In general, a resource group should contain resources that share the same lifecycle. This makes it easier to manage deployments, delete test deployments, and assign access rights, reducing the chance that a production deployment is accidentally deleted or modified. Create separate resource groups for production, development, and test environments. In a multi-region deployment, put resources for each region into separate resource groups. This makes it easier to redeploy one region without affecting the other region(s).

## Next steps

- [Resiliency checklist for specific Azure services](./resiliency-per-service.md)
- [Failure mode analysis](../resiliency/failure-mode-analysis.md)


<!-- links -->
[app-service-autoscale]: /azure/monitoring-and-diagnostics/insights-how-to-scale/
[asynchronous-c-sharp]: /dotnet/articles/csharp/async
[availability-sets]:/azure/virtual-machines/virtual-machines-windows-manage-availability/
[azure-backup]: https://azure.microsoft.com/documentation/services/backup/
[circuit-breaker]: ../patterns/circuit-breaker.md
[cloud-service-autoscale]: /azure/cloud-services/cloud-services-how-to-scale/
[fma]: ../resiliency/failure-mode-analysis.md
[load-balancer]: /azure/load-balancer/load-balancer-overview/
[monitoring-and-diagnostics-guidance]: ../best-practices/monitoring.md
[resource-manager]: /azure/azure-resource-manager/resource-group-overview/
[retry-pattern]: ../patterns/retry.md
[retry-service-guidance]: ../best-practices/retry-service-specific.md
[traffic-manager]: /azure/traffic-manager/traffic-manager-overview/
[traffic-manager-routing]: /azure/traffic-manager/traffic-manager-routing-methods/
[vmss-autoscale]: /azure/virtual-machine-scale-sets/virtual-machine-scale-sets-autoscale-overview/
