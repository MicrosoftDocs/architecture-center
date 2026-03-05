Moodle is an open-source learning management system that requires high-throughput, low-latency access to storage. Many Moodle deployments require easy scalability to adapt to growing demand. This article explains how you can deploy Moodle by using Azure services on Azure Virtual Machine Scale Sets and store user-accessible learning data files in Azure NetApp Files. This article describes a zonal deployment for high availability and cross-zone replication and also gives examples of a single-zone deployment.

## Architecture

For the best user experience, Moodle requires consistent low-latency access to scalable shared storage to meet the demands of office and home workers who use the service. Virtual Machine Scale Sets and Azure NetApp Files capacity pools and volumes can be sized up and down as the demand changes.

:::image type="complex" source="media/azure-netapp-files-moodle-zonal.svg" alt-text="Architecture diagram of Azure NetApp Files for Moodle with cross-zone replication." lightbox="media/azure-netapp-files-moodle-zonal.svg" border="false":::
  A diagram that illustrates the single-region Azure NetApp Files Moodle deployment. Inside of the same Azure region box, there's a second zone that includes disaster recovery versions of Azure NetApp Files. The Azure Traffic Manager routes students to the application in zone one or zone two.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/azure-netapp-files-moodle-zonal.vsdx) of this architecture.*

In addition to the Moodle deployment, the architecture uses Azure NetApp Files cross-zone replication to replicate the data volumes to a secondary zone. [Cross-zone replication](/azure/azure-netapp-files/cross-zone-replication-introduction) uses availability zones to provide high availability in a region and replication to a different zone in the same region. A capacity pool that uses the Standard service level can host the destination data volumes during normal operation.

By using this approach, you don't need to start some components of the setup, like compute and ancillary services, during normal operation. As a result, you won't incur any operational cost for these components. You can also scale down the virtual machine scale sets to the minimum.

Only in a disaster recovery scenario should you start and scale up the necessary components to continue the service using the replicated data volumes. At this time, you can upgrade the service level of the destination Azure NetApp Files volumes to the Premium or Ultra service level if necessary.

After you recover the primary zone, the replication direction is reversed. The primary zone is updated with the changes that are applied during the failover, and the service can be failed back. Users are redirected to the failover zone through [Azure Traffic Manager](/azure/traffic-manager/traffic-manager-overview), which operates at the DNS layer to quickly and efficiently direct incoming DNS requests based on the routing method of your choice.

### Workflow

Students access the Moodle application data through an Azure Application Gateway where they can use Virtual Machine Scale Sets to build a scalable compute platform that runs the Moodle app to host users. Azure NetApp Files serves the content data to the Moodle app. Use a Redis cache for user session caching, locking, and key awareness. Store the learning content, student progress, and internal data in a MySQL database.

1. Insert learning content through a secure VPN gateway directly from the customer datacenter.

1. Students access the content through the application that's deployed on [Virtual Machine Scale Sets](/azure/virtual-machine-scale-sets/overview) through a secure application gateway.

1. You can scale the solution up or down depending on demand by adding or removing virtual machines (VMs) in the scale set and adjusting the [Azure NetApp Files volume service level](/azure/azure-netapp-files/azure-netapp-files-performance-considerations).

### Components

- [Moodle](https://www.moodlecloud.com/) is a free, open-source learning management system. In this architecture, Moodle serves as the core application that delivers educational content and tracks student progress.

- [Azure Database for MySQL Flexible Server](/azure/well-architected/service-guides/azure-db-mysql-cost-optimization) is a managed relational database service. In this architecture, it stores Moodle's structured data, including course content, user profiles, and student progress.

- [Azure Managed Redis](/azure/redis/overview) is a secure, in-memory data store and messaging broker. In this architecture, it improves Moodle performance by caching user sessions, managing locks, and reducing load on the database.

- [Azure Virtual Machine Scale Sets](/azure/well-architected/service-guides/virtual-machines) is an Azure compute service that you can use to deploy and manage a group of identical, load-balanced virtual machines. In this architecture, it hosts the Moodle application and automatically scales the number of VMs up or down based on demand.

- [Azure NetApp Files](/azure/well-architected/service-guides/azure-netapp-files) is a high-performance file storage service. You can use this service to migrate and run the most demanding enterprise-file workloads in the cloud, such as native SMBv3, NFSv3, and NFSv4.1 file shares, databases, data warehouses, and high-performance computing applications. In this architecture, it stores Moodle's learning content and user-uploaded files. It provides scalable, low-latency access and cross-zone replication for high availability and disaster recovery.

### Alternatives

You can deploy the Moodle service by using any NFS-based shared file service that meets your requirements for low latency, high input or output operations per second, and throughput, especially for higher numbers of concurrent users. You can use an NFS service built on top of a set of Linux VMs, but this configuration can cause manageability, scalability, and performance challenges. Azure NetApp Files provides the lowest latency, best performance and scalability, and secure access to NFS shared storage.

#### Alternative deployments by using Azure NetApp Files

This diagram captures an example of a single-region deployment:

:::image type="complex" source="media/azure-netapp-files-moodle-architecture.svg" alt-text="Architecture diagram of Azure NetApp Files for Moodle." lightbox="media/azure-netapp-files-moodle-architecture.svg" border="false":::
    A rectangle denotes an Azure region that contains a virtual network. The virtual network has three smaller rectangles inside of it. Two rectangles are stacked and one is on the right side. The top rectangle denotes a network security group the Moodle, a PHP application, an HTTP server, and a Redis cache that's connected to the third rectangle, which contains the MySQL database. The network security group also includes a DNS router that's connected to an application gateway for Virtual Machine Scale Sets, which is attached to the other rectangle that represents the Azure NetApp Files delegated subnet. That rectangle contains three volumes and related snapshots. Students access the Moodle application through the DNS, and the Azure VPN gateway securely connects the resources to the customer datacenter.
:::image-end:::

This single-region setup provides highly available access to the Moodle application and other components of the configuration.

## Scenario details

This solution applies to Moodle deployments. Organizations that use Moodle span industries including education, business, IT, and finance.

This article outlines a solution that meets Moodle's needs. At the core of the solution is Azure NetApp Files, which is an Azure storage service. You can use this service to migrate and run the most demanding enterprise-scale file workloads in the cloud:

- Native Server Message Block (SMB) version 3, NFSv3, and NFSv4.1 file shares
- Database workloads
- Data warehouse workloads
- High-performance computing applications

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

Azure NetApp Files is built on a bare-metal fleet of redundant, solid-state hardware. The service operates without interruption, even during maintenance operations. For more information about resiliency, see [Fault Tolerance, High Availability, and Resiliency in Azure NetApp Files][Fault Tolerance, High Availability, and Resiliency in Azure NetApp Files].

Azure NetApp Files provides high availability for your stored data. For the Azure NetApp Files availability guarantee, see [SLA for Azure NetApp Files](https://www.microsoft.com/licensing/docs/view/Service-Level-Agreements-SLA-for-Online-Services).

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

For all deployment options, you need to provide a valid Secure Shell (SSH) protocol 2 (SSH-2) RSA public–private key pair. The length should be at least 2,048 bits. Azure doesn't support other key formats such as ED25519 and ECDSA. Azure NetApp Files supports both customer-managed and platform-managed keys. These solutions provide unrestricted access to stored data, meet compliance requirements, and enhance data security. For more information and best practices for Azure NetApp Files security, see [Security FAQs for Azure NetApp Files](/azure/azure-netapp-files/faq-security).

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

For a medium-to-large-sized Moodle deployment of approximately 5,000 users with a 10% concurrency ratio, the recommended throughput is approximately 500 MB/s. This deployment can be built on a Linux-based Standard_D32s_v4 VM infrastructure that uses 8 TB of a P60-managed disk.

Azure NetApp Files provides a more cost-effective solution that uses 4 TiB of Ultra-service level capacity. For larger-scale applications that require more Azure NetApp Files capacity, both the Premium and Standard service levels provide sufficient performance. Use the Premium or Standard service level to improve cost effectiveness.

Use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator/) to estimate costs for Azure resources for your specific requirements. For more information, see [Azure NetApp Files cost model](/azure/azure-netapp-files/azure-netapp-files-cost-model).

For a calculator that computes the Azure NetApp Files performance and total cost of ownership (TCO), see [Azure NetApp Files performance calculator](https://azure.github.io/azure-netapp-files/calc/). Use this calculator to find the optimal balance between capacity, performance, and cost.

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

You can scale this solution up or down as needed:

- Virtual Machine Scale Sets provides automatic scaling of resources. For more information, see [Overview of autoscale with Azure Virtual Machine Scale Sets][Overview of autoscale with Azure virtual machine scale sets].

- You can easily and nonintrusively scale the Azure NetApp Files capacity pools and volumes up and down to meet demand. For more information, see [Resize a capacity pool or a volume][Resize a capacity pool or a volume].

- You can adjust the Azure NetApp Files volume service level, which can be either Standard, Premium, or Ultra. The level that you choose affects the throughput limit of volumes with automatic quality of service. For more information, see [Performance considerations for Azure NetApp Files][Performance considerations for Azure NetApp Files].

## Deploy this scenario

For a deployment guide for Moodle on Azure NetApp Files, see [Azure NetApp Files for NFS storage with Moodle](https://techcommunity.microsoft.com/t5/azure-architecture-blog/azure-netapp-files-for-nfs-storage-with-moodle/ba-p/2300630).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Arnt de Gier](https://www.linkedin.com/in/arntdegier) | Technical Marketing Engineer

## Next steps

- [Moodle Cloud option](https://www.moodlecloud.com/)
- [Azure Moodle directions on GitHub](https://github.com/Azure/Moodle)
- [Moodle docs: Redis cache store](https://docs.moodle.org/501/en/Redis_cache_store)
- [Azure NetApp Files for NFS storage with Moodle](https://techcommunity.microsoft.com/t5/azure-architecture-blog/azure-netapp-files-for-nfs-storage-with-moodle/ba-p/2300630)
- [Solution architectures using Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-solution-architectures)
- [Automatic scaling with Virtual Machine Scale Sets flexible orchestration mode](https://azure.microsoft.com/updates/automatic-scaling-for-vms-with-azure-virtual-machine-scale-sets-flexible-orchestration-mode/)

[Fault Tolerance, High Availability, and Resiliency in Azure NetApp Files]: https://anfcommunity.com/2020/11/05/fault-tolerance-high-availability-and-resiliency-in-azure-netapp-files/
[Overview of autoscale with Azure virtual machine scale sets]: /azure/virtual-machine-scale-sets/virtual-machine-scale-sets-autoscale-overview
[Resize a capacity pool or a volume]: /azure/azure-netapp-files/azure-netapp-files-resize-capacity-pools-or-volumes
[Performance considerations for Azure NetApp Files]: /azure/azure-netapp-files/azure-netapp-files-performance-considerations
