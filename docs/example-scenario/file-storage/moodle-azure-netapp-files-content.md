Moodle is one of the most popular and widely adopted free, open-source learning management systems. With more than 30% of the global market share, there are more than [200,000 Moodle users](https://moodle.com/news/200-million-education-resources-on-moodle-sites/) worldwide.

Moodle customers vary across industry verticals spanning educational institutions, enterprises, IT companies, FSI Institutions, and more.
 
Moodle has seen a surge in growth during thee COVID-19 pandemic and is now the market leader in Learning Management Systems. This growth has forced Moodle to explore options to grow the business quickly and to allow customers to deploy their Moodle instances in the cloud quickly and efficiently. Moodle architecture relies on NFSv3 for content storage. 

Azure NetApp Files is a first-party Azure service for migrating and running the most demanding enterprise file-workloads in the cloud: native SMB3 and NFSv3 and NFSv4.1 file shares, databases, data warehouse, and high-performance computing applications. Moodle requires high throughput, low latency access to storage. For scaling to larger numbers of concurrent users there's strong desire to autoscale the performance of the setup to keep up with the high expectations of users.

## Potential use cases

This article explains how Moodle can be deployed using Azure Services on Azure Virtual Machine Scale Sets and using Azure NetApp Files to store the user accessible learning data files in:

- a highly availability setup in a single Azure region,
- a disaster recovery setup between two Azure regions, and
- a highly available service using dual zones in a single region.

## Architecture

Students access the Moodle application data through an Azure Application Gateway where Virtual Machine Scale Sets can be used to build a scalable compute platform running the Moodle app to host users. Azure NetApp Files serves the content data to the Moodle app; a Redis Cache is used for user session caching, locking, and key awareness. The learning content, student progress, and internal data are stored in a MySQL database.

For the best user (learner) experience, Moodle requires consistent low latency access to scalable shared storage to meet the demands of office and home workers using the service. Virtual Machine Scale Sets and Azure NetApp Files capacity pools and volumes can be sized up and down as the demand changes.

- Learning content is inserted through a secure VPN gateway directly from the customer datacenter.
- Students access the content through the application that is deployed on a [Virtual Machine Scale Set](/azure/virtual-machine-scale-sets/overview) through a secure application gateway. 
- The solution can be scaled up or down as demand dictates by adding or removing VMs in the scale set and by adjusting the Azure NetApp Files volume [service level](/azure/azure-netapp-files/azure-netapp-files-performance-considerations).

The following diagram captures an example of a single-region deployment:

:::image type="complex" source="./media/azure-netapp-files-moodle-architecture.png" alt-text="Architecture diagram of Azure NetApp Files for Moodle." border="false":::
    A black-lined rectangle denotes an Azure region that contains a virtual network. The virtual network has multiple three smaller rectangles inside of it: two stacked, and one to the right. The top rectangle denotes a network security group the Moodle, a PHP application, an HTTP server, as well as a Redis Cache connected to the third rectangle: the MySQL database. The network security group also includes with a DNS router connected to an application gateway for the Virtual Machine Scale Sets, which is attached to the Azure other rectangle below representing the Azure NetApp Files delegated subnet that contains three volumes and related snapshots. Student access the Moodle through the DNS, while the Azure VPN gateway securely connects the resources to the customer data center.
:::image-end:::

This single-region setup provides highly available access to the Moodle application and other components of the configuration with an uptime of 99.99%. If you require higher uptime and desire protection against unlikely Azure region failure, you can choose to replicate the Azure NetApp Files data volumes to a second region where only the Azure NetApp Files volumes need to be present.

### Disaster recovery with cross-region replication

The following diagram captures a setup with cross-region replication:

:::image type="complex" source="./media/azure-netapp-files-moodle-secondary-region.png" alt-text="Architecture diagram of Azure NetApp Files for Moodle with cross-region replication." border="false":::
    A diagram that replicates the single-region Azure NetApp Files Moodle deployment. The diagram adds a second black rectangle to the right of the first one, representing a second Azure region. Azure Traffic Manager routes students to either region to access the application. The Azure NetApp Files volumes are replicated to the secondary region for data protection.
:::image-end:::

The Azure NetApp Files volumes are replicated using [cross-region replication](/azure/azure-netapp-files/cross-region-replication-introduction), a storage-based replication engine built into the Azure NetApp Files service. The destination data volumes can be hosted by a capacity pool using the Standard service level during normal operation.

With this approach, some of the components of the setup, like compute and ancillary services, don't have to be started during normal operation. They  therefore don't incur any operational cost. The Virtual Machine Scale Sets can also be scaled down to the minimum.

Only in a disaster recovery scenario do the components need be started and scaled up where required to continue the service using the replicated data volumes. At this time, the service level of the destination Azure NetApp Files volumes can be upgraded to the Premium or Ultra service level if required.

Once the primary region has been recovered, the replication direction is reversed, so the primary region is updated with the changes applied during the failover, and the service can be failed back. Users are redirected to the failover region through [Azure Traffic Manager](/azure/traffic-manager/traffic-manager-overview).

### Disaster recovery using multi-zone configuration

If you require high availability within a region, you can use Azure NetApp Files cross-zone replication to replicate the data volumes to a secondary zone. The same benefits apply regarding the presence of compute and ancillary services which only need to be started up and scaled up in failover situations.

:::image type="complex" source="./media/azure-netapp-files-moodle-zonal.png" alt-text="Architecture diagram of Azure NetApp Files for Moodle with cross-zone replication." border="false":::
    A diagram that replicates the single-region Azure NetApp Files Moodle deployment. Inside of the same Azure region box, there's a second zone that includes DR versions of the Azure NetApp Files. The Azure Traffic Manager routes students to the application in zone one or zone two.
:::image-end:::

### Components

- [Moodle](https://moodle.com/moodlecloud)
- [Azure Database for MySQL](/azure/well-architected/service-guides/azure-db-mysql-cost-optimization)
- [Azure Cache for Redis](/azure/well-architected/service-guides/azure-cache-redis/operational-excellence)
- [Azure Virtual Machine Scale Sets](/azure/well-architected/service-guides/virtual-machines)
- [Azure NetApp Files](/azure/azure-netapp-files)
    - [Cross-region replication](/azure/azure-netapp-files/cross-region-replication-introduction)
    - [Cross-zone replication](/azure/azure-netapp-files/cross-zone-replication-introduction)
- [Azure Traffic Manager](/azure/well-architected/service-guides/traffic-manager/reliability)

## Alternatives

The Moodle service can be deployed using any NFS based shared file service if requirements for very low latency, high IOPS, and throughput are met, especially for higher numbers of concurrent users. Although an NFS service built on top of a set of Linux VMs can be used, this leaves challenges in the realm of manageability, scalability, and performance. Ultimately Azure NetApp Files offers the lowest latency, best performance and scalability, and secure access to NFS shared storage.

## Considerations (pillars)

- **Scalability**
    The solution is scaled up or down using the Virtual Machine Scale Sets automatic scaling of resources, while the Azure NetApp Files data storage can be easily scaled up and down for both capacity and performance.

- **Availability** 
    Azure NetApp Files has a guaranteed availability of 99.99%.

- **Security**
    All deployment options require you to provide a valid SSH protocol 2 (SSH-2) RSA public-private key pairs with a minimum length of 2,048 bits. Other key formats such as ED25519 and ECDSA aren't supported. For more information, see [Azure NetApp Files secuirty FAQs](/azure/azure-netapp-files/azure-netapp-files-faqs#security-faqs).

- **Resiliency**
    Azure NetApp Files is built on a bare metal fleet of redundant solid-state hardware and is designed to operate with interruption even during maintenance operations. Read more about fault tolerance, high availability and resiliency in Azure NetApp Files here.

- **Disaster Recovery**
    The total solution can be built to be more resilient by adding a secondary region. This solution uses Azure NetApp Files cross-region replication to efficiently replicate the NFS volumes to a secondary passive region where the application can be started in the unlikely event of a complete region failure. See [Disaster recovery with cross-region replication](#disaster-recovery-with-cross-region-replication) for more information. 

## Deploy the solution

For a deployment guide for Moodle on Azure NetApp Files, see [Azure NetApp Files for NFS storage with Moodle](https://techcommunity.microsoft.com/t5/azure-architecture-blog/azure-netapp-files-for-nfs-storage-with-moodle/ba-p/2300630).

## Pricing

For a medium-to-large sized Moodle deployment of approximately 5,000 users with a 10% concurrency ratio, the recommended throughput is approximately 500 MB/s. This deployment can be built on a Linux based Standard_D32s_v4 VM infrastructure using 8 TB of P60 managed disk.

Azure NetApp Files offers a more cost-effective solution using 4 TB of Ultra-service level capacity. In case the scale of the application is larger thus requiring more Azure NetApp Files capacity, it's likely that either the Azure NetApp Files Premium or Standard service levels provide sufficient performance, further improving the cost effectiveness.

Use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator/) to estimate costs for Azure resources for your specific requirements. More information  is available in the [Azure NetApp Files cost model](/azure/azure-netapp-files/azure-netapp-files-cost-model).

Azure NetApp Files also offers [a performance and TCO calculator](https://aka.ms/anfcalc), which you can use to find the most optimal balance between capacity, performance, and cost.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

* [Arnt de Gier](https://www.linkedin.com/in/arntdegier) | Technical Marketing Engineer

## Next steps

You can consume Moodle in various models, where typically customers start using the [Moodle Cloud option](https://moodle.com/moodlecloud/). When scaling up or deploying Moodle in Azure quickly and efficiently, use the [Azure Moodle directions on GitHub](https://github.com/Azure/Moodle).

## Related resources

* [Solution architectures using Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-solution-architectures)
* [Moodle docs: Redis cache store](https://docs.moodle.org/311/en/Redis_cache_store#:~:text=Before%20Redis%20is%20available%20as%20a%20cache%20store%2C,as%20an%20application%20or%20session%20level%20cache%20store.)
* [Azure NetApp Files for NFS storage with Moodle](https://techcommunity.microsoft.com/t5/azure-architecture-blog/azure-netapp-files-for-nfs-storage-with-moodle/ba-p/2300630)
* [Automatic scaling with Azure Virtual Machine Scale Sets flexible orchestration mode](https://azure.microsoft.com/updates/automatic-scaling-for-vms-with-azure-virtual-machine-scale-sets-flexible-orchestration-mode/)