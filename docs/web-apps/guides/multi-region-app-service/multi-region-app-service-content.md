When you deploy an Azure App Service web app into a single region that, due to disaster or outage, becomes unavailable, you run the risk of your application becoming unavailable. To ensure that your application continues to be available when the region is unavailable, you can implement a multi-region architecture. With a multi-region architecture, you create an identical deployment in a secondary Azure region. With a secondary region deployment, you can replicate your data to recover last application state; and can replicate other solution components as well.

This article describes three multi-region architectural approaches that are commonly used for both App Service and App Service Environments.

## Approaches to consider

Business continuity plans are influenced by two key metrics:

- Recovery time objective (RTO), which is the maximum tolerable downtime during a disaster.
- Recovery point objective (RPO), which is the maximum tolerable data loss during a disaster.

For more information on recovery objectives like RTO and RPO, see [Recovery objectives](/azure/reliability/disaster-recovery-overview#recovery-objectives) and [Recommendations for defining reliability targets](/azure/well-architected/reliability/metrics).

With the Azure platform, you can design multi-region application solutions in different ways. This article describes architectures that support different RTO and RPO requirements, and have other tradeoffs for cost, and complexity:
 
| Metric | [Active-active](#active-active-architecture) | [Active-passive](#active-passive-architecture) | [Passive/cold](#passive-cold-architecture)|
|-|-|-|-|
| RTO | Real-time or seconds| Minutes | Hours |
| RPO | Real-time or seconds| Minutes | Hours |
| Cost | $$$ | $$ | $ |
| Scenarios | Mission-critical apps | High-priority apps | Low-priority apps |
| Ability to serve multi-region user traffic | Yes | No | No |
| Code deployment | CI/CD pipelines preferred | CI/CD pipelines preferred | Backup and restore |
| Creation of new App Service resources during downtime | Not required | Not required | Required |

While the three approaches described here are common, they aren't the only way to achieve a multi-region solution in Azure. Adapt the solutions to meet your own requirements.

>[!NOTE]
> Your application most likely depends on other services in Azure, such as Azure SQL Database, Azure Storage accounts, and message queues. When you design a disaster recovery strategy, you need to consider each of these dependent Azure services as well.
>
> To learn more about multi-region solutions for Azure services, see [Azure service reliability guides](/azure/reliability/overview-reliability-guidance).

## Monitoring

It's important that you configure monitoring and alerts for your web apps so that your team gets timely notifications during a region failure. Azure Application Insights availability tests provide a way to monitor an application's availability. For more information, see [Application Insights availability tests](/azure/azure-monitor/app/availability-overview).

## Deployment

Multi-region solutions can be complex to deploy and configure. It's important that instances in each region are kept in sync.

To manage the deployment and configuration of Azure resources like App Service, use an infrastructure-as-Code (IaC) mechanism. In a complex deployment across multiple regions, to manage the regions independently and to keep the configuration synchronized across regions in a reliable manner requires a predictable, testable, and repeatable process. Consider an IaC tool such as [Bicep](/azure/azure-resource-manager/bicep/overview), [Azure Resource Manager templates](/azure/azure-resource-manager/management/overview) or [Terraform](/azure/developer/terraform/overview).

You should also configure your CI/CD pipelines to deploy your code, including when you use multiple regions. Consider using [Azure Pipelines](/azure/devops/pipelines/get-started/what-is-azure-pipelines) or [GitHub Actions](https://docs.github.com/actions). For more information, see [Continuous deployment to Azure App Service](/azure/app-service/deploy-continuous-deployment).

## Active-active architecture

In an active-active architecture, identical web apps are deployed in two separate regions. Azure Front Door is used to route traffic to both the active regions:

:::image type="content" source="../_images/active-active-architecture.png" alt-text="Diagram that shows an active-active deployment of App Service." border="false" :::

Each region's App Service applications use the same configuration, including pricing tier and instance count.

**During normal operations**,  public traffic direct to the App Service app is blocked. Traffic is instead routed though Azure Front Door to both active regions. This approach helps you to ensure that requests are inspected by the Azure Front Door web application firewall (WAF), or that they otherwise are secured or managed centrally.

**During a region failure**, if one of the regions goes offline, the Azure Front Door health probes detect the faulty origin and reconfigure the routes so that traffic is sent exclusively to the region that remains online. 

**During a faulty region recovery (failback)**, the Azure Front Door health probes detect the healthy origin and restore normal traffic routing.

### Recommendations

- To meet an RPO of zero for application content, use a CI/CD solution to deploy application files to both web apps.

-  Where possible, store application state outside of the App Service file system such as in a database or Azure Storage. Configure those components to meet your geo-redundancy requirements.

   > [!TIP]
   > If your application actively modifies the file system, and your App Service app region [has a paired region](/azure/reliability/cross-region-replication-azure#azure-paired-regions), you can reduce the RPO for your file system by writing to a [mounted Azure Storage share](/azure/app-service/configure-connect-to-azure-storage) instead of writing directly to the web app's */home* content share. Then, use the Azure Storage redundancy features ([GZRS](/azure/storage/common/storage-redundancy#geo-zone-redundant-storage) or [GRS](/azure/storage/common/storage-redundancy#geo-redundant-storage)) for your mounted share, which has an [RPO of about 15 minutes](/azure/storage/common/storage-redundancy#redundancy-in-a-secondary-region).

### Considerations

- **Low RTO:** The RTO during such a geo-failover depends on how soon the health probes detect the faulty region. By default, probes check every 30 seconds, but [you can configure a different probe frequency](/azure/frontdoor/health-probes).

- **Load balancing and failover:** This approach uses Azure Front Door for global load balancing, traffic distribution, and failover. Azure provides other load balancing options, such as Azure Traffic Manager. For a comparison of the various options, see [Load-balancing options - Azure Architecture Center](/azure/architecture/guide/technology-choices/load-balancing-overview).

### Deploy active-active App Service web apps

Follow these steps to create an active-active approach for your web apps by using App Service: 

1. Create two App Service plans in two different Azure regions. Identically configure the two App Service plans.

1. Create two instances of your web app, with one in each App Service plan.

1. Create an Azure Front Door profile with:

    - An endpoint.
    - An origin group with two origins, each with a priority of 1. The equal priority values tell Azure Front Door to route traffic to the applications in both regions equally (active-active).
    - A route. 

1. [Limit network traffic to the web apps only from the Azure Front Door instance](/azure/app-service/app-service-ip-restrictions#restrict-access-to-a-specific-azure-front-door-instance). 

1. Setup and configure all other backend Azure service, such as databases, storage accounts, and authentication providers. 

1. Deploy code to both the web apps with [continuous deployment](/azure/app-service/deploy-continuous-deployment).

The [Create a highly available multi-region app in Azure App Service](/azure/app-service/tutorial-multi-region-app) tutorial shows you how to set up an *active-passive* architecture. To deploy an active-active approach, follow the same steps but with one exception: In Azure Front Door, configure both origins in the origin group to have a priority of 1.

## Active-passive architecture

In an active-passive architecture, identical web apps are deployed in two separate regions. Azure Front Door is used to route traffic to one region only (the *active* region).

:::image type="content" source="../_images/active-passive-architecture.png" alt-text="A diagram showing an active-passive architecture of Azure App Service." border="false" :::

**During normal operations**, Azure Front Door routes traffic to the primary region only. Public traffic directly to the App Service apps is blocked.

**During a region failure**, if the primary region becomes inactive, Azure Front Door health probes detect the faulty origin and begins traffic routing to the origin in the secondary region. The secondary region then becomes the active region. Once the secondary region becomes active, the network load triggers preconfigured autoscale rules to scale out the secondary web app.

**During a faulty region recovery (failback)**, Azure Front Door automatically directs traffic back to the primary region, and the architecture is back to active-passive as before.

   >[!NOTE]
   >You might need to scale up the pricing tier for the secondary region manually, if it doesn't already have the needed features to run as the active region. For example, [autoscaling requires Standard tier or higher](https://azure.microsoft.com/pricing/details/app-service/windows/).

### Recommendations

- To meet an RPO of zero for application content, use a CI/CD solution to deploy application files to both web apps.

-  Where possible, store application state outside of the App Service file system such as in a database or Azure Storage. Configure those components to meet your geo-redundancy requirements.

   >[!TIP]
   >If your application actively modifies the file system, and your App Service app region [has a paired region](/azure/reliability/cross-region-replication-azure#azure-paired-regions), you can reduce the RPO for your file system by writing to a [mounted Azure Storage share](/azure/app-service/configure-connect-to-azure-storage) instead of writing directly to the web app's */home* content share. Then, use the Azure Storage redundancy features ([GZRS](/azure/storage/common/storage-redundancy#geo-zone-redundant-storage) or [GRS](/azure/storage/common/storage-redundancy#geo-redundant-storage)) for your mounted share, which has an [RPO of about 15 minutes](/azure/storage/common/storage-redundancy#redundancy-in-a-secondary-region).

### Considerations

- **Cost controls:** Identical App Service apps are deployed in two separate regions. To save cost, the secondary App Service plan is configured to have fewer instances and/or be in a lower pricing tier. There are three possible approaches:

    - **Preferred:** The secondary App Service plan has the same pricing tier as the primary, with the same number of instances or fewer. This approach ensures parity in both feature and VM sizing for the two App Service plans. The RTO during a geo-failover only depends on the time to scale out the instances.

    - **Less preferred:**  The secondary App Service plan has the same pricing tier type (such as PremiumV3) but smaller VM sizing, with lesser instances. For example, the primary region might be in P3V3 tier while the secondary region is in P1V3 tier. This approach still ensures feature parity for the two App Service plans, but the lack of size parity might require a manual scale-up when the secondary region becomes the active region. The RTO during a geo-failover depends on the time to both scale up and scale out the instances.

    - **Least-preferred:** The secondary App Service plan has a different pricing tier than the primary and lesser instances. For example, the primary region might be in P3V3 tier while the secondary region is in S1 tier. Make sure that the secondary App Service plan has all the features your application needs in order to run. Differences in features availability between the two might cause delays to your web app recovery. The RTO during a geo-failover depends on the time to both scale up and scale out the instances.

- **Autoscale** should be configured in the secondary region in case traffic is redirected and there's a sudden influx of requests. It’s advisable to have similar autoscale rules in both active and passive regions.

- **Load balancing and failover:** This approach uses Azure Front Door for global load balancing, traffic distribution, and failover. Azure provides other load balancing options, such as Azure Traffic Manager. For a comparison of the various options, see [Load-balancing options - Azure Architecture Center](/azure/architecture/guide/technology-choices/load-balancing-overview).

### Deploy active-passive App Service web apps

Follow these steps to create an active-passive approach for your web apps by using App Service: 

1. Create two App Service plans in two different Azure regions. The secondary App Service plan might be provisioned using one of the approaches mentioned previously.

1. Configure autoscaling rules for the secondary App Service plan so that it scales to the same instance count as the primary when the primary region becomes inactive.

1. Create two instances of your web app, with one in each App Service plan. 

1. Create an Azure Front Door profile with:

    - An endpoint.

    - An origin group with two origins:
      
      - An origin with a priority of 1 for the application in the primary region.
      - A second origin with a priority of 2 for the application in secondary region.
      
      The difference in priority tells Azure Front Door to prefer the primary region when it's online (thus active-passive).

    - A route. 

1. [Limit network traffic to the web apps only from the Azure Front Door instance](/azure/app-service/app-service-ip-restrictions#restrict-access-to-a-specific-azure-front-door-instance). 

1. Setup and configure all other backend Azure service, such as databases, storage accounts, and authentication providers. 

1. Deploy code to both the web apps with [continuous deployment](/azure/app-service/deploy-continuous-deployment).

[Tutorial: Create a highly available multi-region app in Azure App Service](/azure/app-service/tutorial-multi-region-app) shows you how to set up an *active-passive* architecture.

## Passive-cold architecture

In a passive/cold architecture, your web app is deployed into a single primary region. Application files, and some databases, are backed up into an Azure Storage account. Backups are replicated to another region. If the primary region is unavailable, you manually deploy another app into a second region and restore from the backup.

> [!NOTE]
> Passive-cold approaches rely on manual intervention during a region failure, and often result in significant downtime and data loss. For most production-grade solutions, you should consider an active-active or active-passive solution.

### Cross-region replication

This approach uses [App Service backup](/azure/app-service/manage-backup) to regularly back up the web app to an Azure Storage account in the same region. You configure cross-region replication of your backups by configuring the storage account.

The approach you use to configure cross-region replication depends on whether your region has a pair. For more information, see [Azure paired regions](/azure/reliability/cross-region-replication-azure#azure-paired-regions) and [Regions with availability zones and no region pair](/azure/reliability/cross-region-replication-azure#regions-with-availability-zones-and-no-region-pair).

# [Regions with a pair](#tab/paired-regions)

Use [RA-GZRS](/azure/storage/common/storage-redundancy#geo-zone-redundant-storage) replication, if it's available. RA-GZRS offers both synchronous zone redundancy within a region and asynchronous in a secondary region. It also [provides read-only access within the secondary region](/azure/storage/common/storage-redundancy#read-access-to-data-in-the-secondary-region), which is essential to ensure you can retrieve backups when the storage account's primary region becomes unavailable.

If RA-GZRS isn't available, configure the account as [RA-GRS](/azure/storage/common/storage-redundancy#geo-redundant-storage).

Both RA-GZRS and RA-GRS have an [RPO of about 15 minutes](/azure/storage/common/storage-redundancy#redundancy-in-a-secondary-region).

For more information on designing your applications to take advantage of geo-redundant storage, see [Use geo-redundancy to design highly available applications](/azure/storage/common/geo-redundant-design).

# [Regions without a pair](#tab/non-paired-regions)

You need to replicate your app backups to a storage account in a different region. [Azure storage object replication](/azure/storage/blobs/object-replication-overview) enables you to configure automatic replication of blobs between two storage accounts, even if they're in different regions. Azure Storage manages the replication process for you automatically.

Object replication doesn't guarantee how quickly data is replicated. However, you can [check the replication status of a blob](/azure/storage/blobs/object-replication-configure#check-the-replication-status-of-a-blob).

If you need to control the frequency of data replication between storage accounts, you can use a tool like [AzCopy](/azure/storage/common/storage-use-azcopy-v10) to explicitly copy the backup files between storage accounts in different regions. AzCopy is a tool, not a service, so you need to configure it to run by using Azure Automation or another compute platform:

---

### Region-down experience

If the primary region is unavailable, you must detect the region loss. For more information, see [Monitoring](#monitoring).

To prepare the secondary region to receive traffic, deploy all required App Service resources and dependent resources by using the backups from the Azure Storage account in your secondary region.

### Considerations

- **High RTO:** Because this process requires manual detection and response, the RTO for this scenario could be hours or even days. To minimize your RTO, build and test a comprehensive playbook outlining all the steps required to restore your web app backup to another Azure region.

   Even after you've created your application in the secondary region, you might need to deal with complexities like DNS records and TLS certificates. Ensure that you've planned each step that's required to send traffic to your secondary region, and test your plans regularly.

- **High RPO:** Backups can be scheduled to occur up to once per hour. If your primary application goes offline, the backup you restore into a secondary region might be outdated. Your RPO depends on the frequency of your backups as well as how quickly those backups are replicated between regions.

### How-to steps

The steps you use to configure a passive-cold deployment depends on whether your region has a pair. For more information, see [Azure paired regions](/azure/reliability/cross-region-replication-azure#azure-paired-regions) and [Regions with availability zones and no region pair](/azure/reliability/cross-region-replication-azure#regions-with-availability-zones-and-no-region-pair).

# [Regions with a pair](#tab/paired-regions)

The steps to create a passive-cold region for your web app in App Service are as follows: 

1. Create an Azure storage account in the same region as your web app. Choose Standard performance tier and select redundancy as geo-redundant storage (GRS) or geo-zone-redundant storage (GZRS).

1. Enable RA-GRS or RA-GZRS (read access for the secondary region).

1. [Configure custom backup](/azure/app-service/manage-backup) for your web app. You might decide to set a schedule for your web app backups, such as hourly.

1. Verify that the web app backup files can be retrieved in the secondary region of your storage account.

# [Regions without a pair](#tab/non-paired-regions)

The steps to create a passive-cold region for your web app in App Service are as follows: 

1. Create an Azure storage account in the same region as your web app. Choose Standard performance tier and select redundancy as zone-redundant storage (ZRS) if it's available.

1. [Configure custom backup](/azure/app-service/manage-backup) for your web app. You might decide to set a schedule for your web app backups, such as hourly.

1. Create a second Azure storage account in a different region. Choose Standard performance tier and select redundancy as locally redundant storage (LRS).

1. Configure object replication on the container in the primary storage account so that it replicates to a container in the secondary storage account.

1. Verify that the web app backup files can be retrieved in the secondary region of your storage account.

---

## Next steps

Review Azure App Service reference architectures:
- For a single-region zone-redundant application, see [Baseline highly available zone-redundant web application](../../app-service/architectures/baseline-zone-redundant.yml).
- For an active/passive multi-region application, see [Highly available multi-region web application](../../app-service/architectures/multi-region.yml).
