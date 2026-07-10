---
title: Multiple-region Architectures for Azure App Service Disaster Recovery
description: Learn about multiple-region architectures and how you can use them to deploy web apps across multiple regions for disaster recovery and replication.
author: changsam
ms.author: pnp
ms.date: 07/09/2026
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom: arb-web
---

# Multiple-region architectures for Azure App Service disaster recovery

App Service deploys web apps into a single region. Within that region, App Service is highly available, especially if you use features like availability zones. This level of availability is often sufficient. However, a regional outage or disaster can still make the app unavailable. To help maintain availability, you can implement a multiple-region architecture. A multiple-region architecture deploys identical but independent instances of your application to multiple Azure regions. You can use a secondary deployment to recover application state and replicate other solution components. This article describes three multiple-region architectural approaches for App Service and App Service Environment.

## Recovery objectives and approach comparison

Two key metrics influence business continuity plans:

- **Recovery time objective (RTO).** The maximum tolerable downtime during a disaster.
- **Recovery point objective (RPO).** The maximum tolerable data loss during a disaster.

For more information about disaster recovery (DR) objectives like RTO and RPO, see [Recovery objectives](/azure/reliability/concept-business-continuity-high-availability-disaster-recovery#recovery-objectives) and [Recommendations for defining reliability targets](/azure/well-architected/reliability/metrics).

You can design multiple-region application solutions in different ways. This article describes active-active, active-passive, and passive-cold architectures. These architectures support different RTO and RPO requirements and involve different cost and complexity trade-offs.
 
| Metric | [Active-active](#active-active-architecture) | [Active-passive](#active-passive-architecture) | [Passive-cold](#passive-cold-architecture)|
|-|-|-|-|
| RTO | Real-time or seconds | Minutes | Hours |
| RPO | Real-time or seconds | Minutes | Hours |
| Cost | High | Medium | Low |
| Scenarios | Mission-critical apps | High-priority apps | Low-priority apps |
| Ability to serve multiple-region user traffic | Yes | No | No |
| Code deployment | CI/CD pipelines preferred | CI/CD pipelines preferred | Backup and restore |
| Creation of new App Service resources during downtime | Not required | Not required | Required |

These architectures are common, but you can design multiple-region solutions in many different ways. Adapt the available solutions to meet your own requirements.

>[!NOTE]
> Your application might depend on other Azure services, like Azure SQL Database, Azure Storage, Azure Key Vault, and message queues. Consider these Azure services in your DR strategy design. For more information about multiple-region solutions for Azure services, see [Azure service reliability guides](/azure/reliability/overview-reliability-guidance).

## Monitor multiple-region web apps

Configure monitoring and alerts for your web apps so that your team receives timely notifications during a regional outage. Application Insights availability tests provide automated availability monitoring for apps. For more information, see [Application Insights availability tests](/azure/azure-monitor/app/availability).

## Deploy and synchronize across regions

Multiple-region solutions can be complex to deploy and configure. Keep each region's applications in sync, including application deployment and configuration. The following practices keep regional deployments consistent and recoverable:

- **Infrastructure as code.** Use infrastructure as code to manage the deployment and configuration of Azure resources like App Service. In a complex, multiple-region deployment, manage regions independently. To maintain configuration sync, design a predictable, testable, and repeatable process. This process is especially important during an outage, when you might be unable to manually reconcile resources in the affected region. In this scenario, you can use an infrastructure-as-code tool like [Bicep](/azure/azure-resource-manager/bicep/overview) or [Terraform](/azure/developer/terraform/overview).

- **Continuous integration and continuous delivery (CI/CD) pipelines.** Configure CI/CD pipelines by using [Azure Pipelines](/azure/devops/pipelines/get-started/what-is-azure-pipelines) or [GitHub Actions](https://docs.github.com/actions) to deploy code across multiple regions, including deployment scheduling, so that each region receives the same application build. For more information, see [Continuous deployment to App Service](/azure/app-service/deploy-continuous-deployment).

## Recommendations

The following recommendations apply to active-active and active-passive solutions: 

- To meet an RPO of zero for application content, use a CI/CD solution to deploy application files to both web apps.

- Where possible, store application state outside the App Service file system, for example in a database or by using Azure Storage. Configure these components to meet your geo-redundancy requirements.

   > [!TIP]
   > If your application modifies the file system, and your App Service app region has a [paired region](/azure/reliability/regions-paired#azure-paired-regions), reduce the file system RPO by writing to a [mounted Azure Storage share](/azure/app-service/configure-connect-to-azure-storage) instead of writing to the web app's `/home` content share. Use [geo-zone-redundant storage (GZRS)](/azure/storage/common/storage-redundancy#geo-zone-redundant-storage) or [geo-redundant storage (GRS)](/azure/storage/common/storage-redundancy#geo-redundant-storage) for the mounted share. Replication to the secondary region is asynchronous, so include possible replication lag and storage-account failover in your recovery design.

## Active-active architecture

Active-active architectures spread incoming traffic across identical web apps in multiple separate regions. Azure Front Door routes traffic to all active regions. In each region, App Service uses the same configuration, including pricing tier and instance count. 

The following diagram shows an active-active architecture in two regions.

:::image type="complex" border="false" source="../_images/active-active-architecture.svg" alt-text="Diagram that shows an active-active deployment of Azure App Service." lightbox="../_images/active-active-architecture.svg":::
   Diagram that shows an active-active deployment of Azure App Service during normal operations. Traffic flows from the browser and through Azure Front Door to region 1 and region 2. Traffic can't bypass Azure Front Door. Both regions are active. In both regions, traffic flows through the App Service plan to the web app during normal operations.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/active-active-architecture.vsdx) of this architecture.*

- **During normal operations:** Direct public traffic to App Service is blocked. Instead, traffic is routed to both active regions through Azure Front Door. A web application firewall inspects or centrally secures or manages requests.

- **During a regional outage:** Azure Front Door health probes detect the faulty origin and reconfigure routing so that traffic is sent only to the operational region. 

- **During failback:** Azure Front Door health probes detect the recovered origin and restore normal traffic routing.

### Considerations

- **Low RTO:** During a geo-failover, RTO depends on how quickly health probes detect an unavailable region. By default, probes run every 30 seconds, but you can [configure a different probe frequency](/azure/frontdoor/health-probes).

- **Load balancing and failover:** This approach uses Azure Front Door for global load balancing, traffic distribution, and failover. Azure provides other load-balancing options, such as Azure Traffic Manager. For a comparison of the available options, see [Load-balancing options](/azure/architecture/guide/technology-choices/load-balancing-overview).

- **Capacity planning:** During normal operations, incoming traffic is spread among the applications in different regions. During a geo-failover, all incoming traffic is sent to the operational region. Configure all regions to accept increased traffic volumes, or apply scaling policies to dynamically adjust their capacities.

### Deploy active-active App Service web apps

Follow these steps to create an active-active approach for your web apps by using App Service: 

1. Create and configure two identical App Service plans in two different Azure regions.

1. Create an instance of your web app in each App Service plan.

1. Create an Azure Front Door profile that has:

    - An endpoint.
    
    - An origin group with two origins, each with a priority of 1. The equal priority values tell Azure Front Door to equally route traffic to the applications in both regions based on latency measurements.
    
    - A route.

1. [Restrict network traffic to the web apps so that only the Azure Front Door instance can send network traffic to them](/azure/app-service/app-service-ip-restrictions#restrict-access-to-a-specific-azure-front-door-instance). 

1. Set up and configure back-end Azure services, such as databases, storage accounts, and authentication providers.

1. Deploy code to both web apps by using continuous deployment.

For steps to set up an *active-passive* architecture, see [Create a highly available multiple-region app in App Service](/azure/app-service/tutorial-multi-region-app). To deploy an active-active approach, follow the same steps, but configure both origins in the origin group to have a priority of 1.

## Active-passive architecture

Active-passive architectures use identical web apps in multiple separate regions, but Azure Front Door routes traffic to only one active region at a time.

The following diagram shows an active-passive architecture in two regions.

:::image type="complex" border="false" source="../_images/active-passive-architecture.svg" alt-text="Diagram that shows the Azure App Service passive architecture." lightbox="../_images/active-passive-architecture.svg":::
   Diagram that shows the Azure App Service passive architecture during normal operations. Traffic can't bypass Azure Front Door. Region 1 is active. Region 2 is passive. Traffic flows from the browser and through Azure Front Door to region 1. In region 1, traffic flows through the App Service plan to the web app. During normal operations, traffic doesn't flow to region 2.
:::image-end:::

- **During normal operations:** Azure Front Door routes traffic only to the primary region. Direct public traffic to the App Service apps is blocked.

- **During a region failure:** Azure Front Door health probes detect the faulty origin and route traffic to the secondary region. The secondary region then becomes the active region. When the secondary region becomes active, the network load triggers preconfigured autoscale rules that scale out the secondary web app.

- **During failback:** Azure Front Door automatically directs traffic back to the primary region, and the architecture returns to an active-passive configuration.

   >[!NOTE]
   >If the secondary region isn't configured to run as the active region, you might need to manually adjust the pricing tier. For example, [autoscaling requires Standard tier or higher](https://azure.microsoft.com/pricing/details/app-service/windows/).

### Considerations

- **Cost controls:** Identical App Service apps are deployed in two separate regions. To reduce overhead, configure fewer instances in the secondary App Service plan and consider a lower pricing tier. Consider the following approaches:

    - **Preferred:** Use a secondary App Service plan with the same pricing tier as the primary region and the same number of instances or fewer. This approach maintains parity in features and virtual machine (VM) sizes between the two App Service plans. During a geo-failover, your RTO depends in part on the time required to scale out instances.

    - **Less preferred:** Use a secondary App Service plan in the same pricing tier family as the primary App Service plan, but with a smaller VM size and fewer instances. For example, the primary region might use P3V3 while the secondary region uses P1V3. This approach maintains feature parity between the two App Service plans. However, without VM size parity, you might need to scale up manually when the secondary region becomes active. During a geo-failover, your RTO depends on the time required to scale up and scale out instances.

    - **Least preferred:** Use a secondary App Service plan in a different pricing tier than the primary region, with fewer instances. For example, the primary region might use P3V3 while the secondary region uses S1. Check that the secondary App Service plan includes the features that your application requires. Differences in feature availability can delay web app recovery. During a geo-failover, your RTO depends in part on the time required to scale up and scale out instances.

- **Autoscale:** Configure autoscale in the secondary region in case traffic redirects there unexpectedly, which might result in a sudden influx of requests. Use similar autoscale rules in both active and passive regions.

- **Load balancing and failover:** This approach uses Azure Front Door for global load balancing, traffic distribution, and failover. Azure provides other load-balancing services, like Azure Traffic Manager.

### Deploy active-passive App Service web apps

Follow these steps to create an active-passive approach for your web apps by using App Service: 

1. Create two App Service plans in different Azure regions. Configure the secondary App Service plan by using one of the approaches in [Considerations](#considerations-1).

1. Configure autoscaling rules for the secondary App Service plan so that it scales to match the primary App Service plan's instance count when the primary region becomes unavailable.

1. Create an instance of your web app in each App Service plan.

1. Create an Azure Front Door profile with:

    - An endpoint.

    - An origin group with the following:
      
      - An origin with a priority of 1 for the application in the primary region.
      
      - An origin with a priority of 2 for the application in the secondary region.
      
      The priority values cause Azure Front Door to route traffic to the primary region when it's available, which creates an active-passive architecture.

    - A route. 

1. Restrict network traffic to the web apps so that only the Azure Front Door instance can send network traffic to them.

1. Set up and configure back-end Azure services, such as databases, storage accounts, and authentication providers.

1. Deploy code to the web apps by using [continuous deployment](/azure/app-service/deploy-continuous-deployment).

For more information, see [Create a highly available multi-region app in App Service](/azure/app-service/tutorial-multi-region-app).

## Passive-cold architecture

Passive-cold architectures deploy web apps into a single primary region. Back up application files to a resource outside your App Service plans in another region, such as Azure Storage. Configure backup and cross-region recovery separately for each dependent database by using the database service's native capabilities.

If the primary region becomes unavailable, deploy an app into a second region and restore from the backup.

> [!NOTE]
> Passive-cold approaches often rely on manual intervention during region failure, which can result in significant downtime and data loss. For most production-grade solutions, consider an active-active or active-passive solution.

### Cross-region replication

This approach uses [App Service backup](/azure/app-service/manage-backup) to regularly back up the web app to Azure Storage. In this approach, configure Azure Storage to use [custom backups](/azure/app-service/manage-backup#automatic-vs-custom-backups) instead of automatic backups.

The approach you use to configure cross-region backups depends on whether your region has a pair. For more information, see [Azure paired regions](/azure/reliability/regions-paired).

- **In regions with a pair:** Where possible, use [read-access GZRS (RA-GZRS)](/azure/storage/common/storage-redundancy#geo-zone-redundant-storage) replication. RA-GZRS provides synchronous zone redundancy in the primary region and asynchronously copies data to the secondary region, where Azure Storage uses locally redundant storage (LRS). It also [provides read-only access in the secondary region](/azure/storage/common/storage-redundancy#read-access-to-data-in-the-secondary-region) so that you can retrieve backups when the primary region becomes unavailable.

  If RA-GZRS isn't available, use [RA-GRS](/azure/storage/common/storage-redundancy#geo-redundant-storage).

  These options replicate data asynchronously, so the RPO varies. Monitor Last Sync Time to understand current replication lag. If the workload requires an RPO of 15 minutes or less for block blobs, consider [Geo Priority Replication](/azure/storage/common/storage-redundancy-priority-replication) and review its SLA eligibility and exclusions.

  For more information about designing your applications to take advantage of GRS, see [Use geo-redundancy to design highly available applications](/azure/storage/common/geo-redundant-design).

- **In regions without a pair:** Replicate your app backups to a storage account in another region. [Azure Storage object replication](/azure/storage/blobs/object-replication-overview) automatically replicates blobs between storage accounts, even across different regions. Azure Storage manages the replication process.

  Object replication doesn't guarantee replication speed. However, you can [check the replication status of a blob](/azure/storage/blobs/object-replication-configure#check-the-replication-status-of-a-blob).

  If you need control over replication frequency, use a tool like [AzCopy](/azure/storage/common/storage-use-azcopy-v10) to copy backup files between storage accounts in different regions. AzCopy is a tool rather than a service. Configure it to run by using Azure Automation or another compute platform.

### Region-outage experience

If the primary region is unavailable, you're responsible for detecting the region outage. For more information, see [Monitoring](#monitor-multiple-region-web-apps).

To prepare the secondary region to receive traffic, deploy the required App Service resources and dependent resources by using the backups from the secondary region's Azure Storage account.

### Considerations

- **High RTO:** This process requires you to detect and respond to a region outage, so your RTO depends on your response time and recovery process. The RTO for this scenario could be hours or even days. To reduce RTO, build and test a recovery process to restore your web app backup to another Azure region.

   After you restore your application in the secondary region, you might need to address dependencies like DNS records and TLS certificates. Include these steps in your recovery process, and test the process regularly.

- **High RPO:** Custom backups can be scheduled as frequently as every two hours. If your primary application becomes unavailable, the backup you restore in the secondary region might be outdated. Your RPO depends on your backup frequency and the time required to replicate backups between regions.

### Deploy passive-cold App Service web apps

The process you follow to configure a passive-cold deployment depends on whether your region has a pair. For more information, see [Azure paired regions](/azure/reliability/regions-paired#azure-paired-regions).

- **In regions with a pair:** Follow these steps to create a passive-cold deployment for your web app in App Service: 

  1. Create an Azure Storage account in the same region as your web app. Select the Standard performance tier.

  1. To provide read access for the secondary region, select RA-GRS or RA-GZRS.

  1. Configure custom backups for your web app. Custom backups can be scheduled as frequently as every two hours.

  1. Verify that you can retrieve the web app backup files from the secondary region of your storage account.

- **In regions without a pair:** Follow these steps to create a passive-cold deployment for your web app in App Service:

  1. Create an Azure Storage account in the same region as your web app. Select the Standard performance tier and, if it's available, choose zone-redundant storage (ZRS).

  1. Configure custom backups for your web app. Custom backups can be scheduled as frequently as every two hours.

  1. Create a second Azure Storage account in another region. Select the Standard performance tier and choose locally redundant storage.

  1. Configure object replication on the container in the primary storage account so that it replicates to a container in the secondary storage account.

  1. Verify that you can retrieve the web app backup files from the container in the secondary storage account.

## Related resources

- [Baseline highly available zone-redundant web application](../../app-service/architectures/baseline-zone-redundant.yml)