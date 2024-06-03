For more information about how to migrate Skytap to Azure, see [Migrate IBM i Series to Azure with Skytap](https://learn.microsoft.com/azure/architecture/example-scenario/mainframe/migrate-ibm-i-series-to-azure-with-skytap).

[Skytap on Azure](https://azuremarketplace.microsoft.com/marketplace/apps/skytapinc.skytap-on-azure-main1) is a cloud infrastructure-as-a-service (Iaas) designed to run [IBM Power](https://www.ibm.com/power) workloads (AIX, IBM i (AS/400), Linux on Power) together with x86 workloads natively in Azure. Skytap provides a simple path to Azure for traditional workloads because it doesn't require refactoring, rearchitecting or re-platforming.

If you deploy Skytap on Azure, [Azure NetApp Files](https://learn.microsoft.com/azure/azure-netapp-files/azure-netapp-files-introduction) is an excellent file storage option. You can use Azure NetApp Files to scale storage allocations up or down at any time without service interruptions. You can also dynamically adjust storage service-level performance requirements.

## Architecture

:::image type="content" source="" alt-text="" lightbox="" border="false":::

*Download a [Visio file]() of this architecture.*

### Workflow

This example scenario demonstrates how to use Azure Netapp Files with workloads on Skytap on Azure. The following workflow corresponds to the above diagram:

1. Connect to the private network using VPN Gateway or ExpressRoute.
1. Set up an Azure Netapp Files capacity pool and share from Azure portal.
1. Mount the share on AIX, IBMi, or Linux on Power based workloads in Skytap on Azure.
1. Use shares as primary storage. Share files across platforms and Azure native deployments.

### Components

The architecture uses these components:

- [Skytap on Azure](https://azuremarketplace.microsoft.com/marketplace/apps/skytapinc.skytap-on-azure-main1) is a service in Azure that natively runs IBM Power and x86 traditional workloads on hardware in Azure datacenters. Organizations of any size that run IBM Power based AIX, IBM i, or Linux operating systems (OS) can migrate them to Azure with little upfront effort.

- [Azure NetApp Files](https://azure.microsoft.com/products/netapp/) is an Azure native, first-party, enterprise-class, high-performance file storage service. It provides volumes as a service for which you can create NetApp accounts, capacity pools, and volumes. You can select service and performance levels and manage data protection and replication across zones and regions.

- [ExpressRoute](https://azure.microsoft.com/products/expressroute/) lets you extend your on-premises networks into the Microsoft cloud over a private connection with the help of a connectivity provider. You can use ExpressRoute to establish connections to Microsoft cloud services, such as Microsoft Azure and Microsoft 365.

- [Azure VMs](https://azure.microsoft.com/products/virtual-machines) are one of several types of on-demand, scalable computing resources that Azure offers. Typically, you choose a virtual machine (VM) when you need more control over the computing environment than the other choices offer.

- [Azure VPN](https://azure.microsoft.com/products/vpn-gateway/) connects your on-premises networks to Azure through site-to-site VPNs in a similar way that you set up and connect to a remote branch office. The connectivity is secure and uses the industry-standard protocols Internet Protocol Security (IPsec) and Internet Key Exchange (IKE).

### Alternatives

- Azure Blob Storage
- Azure Files

## Scenario details

### Potential use cases

Azure NetApp Files can be used for the following use cases, but is an option in nearly any scenario where networked file storage in the cloud is needed.

- **Scalable and resilient file service**: A scalable and resilient file share service is a robust storage solution that can grow alongside your data needs and keep your information safe. It can add storage capacity and performance in real-time, as needed, and ensures data is always accessible via replication and built-in data resiliency. Azure NetApp Files provides a reliable and adaptable platform for sharing and storing your files for mission critical workloads hosted on the IBM Power platform.

- **Critical backups using mksyb for AIX**: Use [mksysb](https://www.ibm.com/docs/aix/7.2?topic=m-mksysb-command) for AIX to create bootable backups of your system's core, which allows you to restore it after crashes or migrate to new hardware. It captures the root volume group and settings, saving it to a file which can be used to restore either the systems base image or a few files. Azure NetApp Files provides a scalable, cost-effective way to store these backups in the Azure cloud.

- **Centralized Data Storage**: Azure NetApp Files allows you to create a shared storage pool accessible by multiple AIX systems vis NFS. This includes user home directories, application data, or project files across your network **,** which is a common use case in distributed applications.

- **High Availability**: Azure NetApp Files shared repositories can be integrated with AIX clustering solutions like PowerHA SystemMirror, providing failover capabilities. If one server goes down, clients can seamlessly access data from another server hosting the same NFS repository in Azure NetApp Files.

- **SAP Global Transport Directory**: The [SAP global transport directory](https://techcommunity.microsoft.com/t5/running-sap-applications-on-the/designing-sap-global-transport-directory-using-anf-in-azure/ba-p/2621547)(_/usr/sap/trans_) is a shared location residing on the global domain controller of an SAP transport management system (TMS). Depending on requirements, you might have one global transport directory or multiple transport directories. This directory can be presented as an NFS share hosted in the Azure cloud on Azure NetApp Files to allow sharing to multiple clients across a network. Using Azure NetApp files is best suited for this scenario for its blend of resiliency and performance.

## Considerations

Azure NetApp Files contains a set of features that provides design considerations based on the pillars of the [Azure Well-Architected Framework](https://learn.microsoft.com/azure/architecture/framework), which is a set of guiding tenets used to improve the quality of a workload.

### Reliability

Reliability ensures your application(s) meet the commitments you make to your customers. For more information, see the [Overview of the Reliability pillar](https://learn.microsoft.com/azure/architecture/framework/resiliency/overview).

Skytap on Azure provides a standard 99.95% availability SLO for the platform and logical partitions (LPARs).

Azure NetApp Files provides a [standard 99.99% availability SLA](https://azure.microsoft.com/support/legal/sla/netapp/v1_1) for all tiers and supported regions. Azure NetApp Files also supports provisioning volumes in [availability zones](https://learn.microsoft.com/azure/azure-netapp-files/use-availability-zones) that you choose, and supports HA deployments across zones for added data protection in the event of a zone outage.

For improved RPO/RTO SLAs, integrated data protection with [snapshots](https://learn.microsoft.com/azure/azure-netapp-files/snapshots-introduction) and [backup](https://learn.microsoft.com/azure/azure-netapp-files/backup-introduction) are available with the service. Additionally, [cross-region replication](https://learn.microsoft.com/en-us/azure/azure-netapp-files/snapshots-introduction#how-volumes-and-snapshots-are-replicated-cross-region-for-dr) provides disaster recovery benefits across Azure regions.

### Security

Security provides assurance against deliberate attacks and abuse of valuable data and systems. For more information, see [Overview of the Security pillar](https://learn.microsoft.com/azure/architecture/framework/security/overview).

Azure NetApp Files provides a level of security because [volumes and data traffic stay within your virtual networks](https://learn.microsoft.com/azure/azure-netapp-files/faq-security#can-the-network-traffic-between-the-azure-vm-and-the-storage-be-encrypted) and does not provide a publicly addressable endpoint. All [data is encrypted at rest](https://learn.microsoft.com/azure/azure-netapp-files/faq-security#can-the-storage-be-encrypted-at-rest) at all times. You can also choose to encrypt data-in-transit via [NFS Kerberos](https://learn.microsoft.com/azure/azure-netapp-files/understand-data-encryption).

Additionally, Azure NetApp Files provides support for standard NFSv4.1 security measures, such as name strings, limited firewall port exposure, [LDAP integration](https://learn.microsoft.com/azure/azure-netapp-files/configure-ldap-extended-groups) and [NFSv4.1 ACLs](https://learn.microsoft.com/azure/azure-netapp-files/configure-access-control-lists).

The [Azure Policy](https://learn.microsoft.com/azure/governance/policy/overview) can help you enforce organizational standards and assess compliance at scale. Azure NetApp Files supports Azure Policy via [custom and built-in policy definitions](https://learn.microsoft.com/azure/azure-netapp-files/azure-policy-definitions).

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

Understanding the [Azure NetApp Files cost model](https://learn.microsoft.com/azure/azure-netapp-files/azure-netapp-files-cost-model) can help you manage your cloud spend.

Azure NetApp Files billing is based on provisioned storage capacity, which you allocate by creating capacity pools.

#### Dynamic capacity adjustments

If your capacity pool size requirements fluctuate (for example, because of variable capacity or performance needs), consider resizing your volumes and capacity pools to balance cost with your capacity and performance needs. This can be done with no disruption to your workloads.

#### Performance when you need it without interruption

If your capacity pool size requirements remain the same, but performance requirements fluctuate, consider dynamically changing the [service level](https://learn.microsoft.com/azure/azure-netapp-files/azure-netapp-files-service-levels) of a volume. Azure NetApp Files offers multiple service levels to provide the best blend of performance to cost optimization for your cloud needs. Are your workloads only busy at certain times in the quarter? Apply the Premium or Ultra service levels to maximize your performance. Does your workload go stagnant at times? Non-disruptively adjust the service level of the volume to Standard to reduce costs.

#### Automatically tier cold data to lower cost storage

Azure NetApp Files also offers a way to tier cold data to lower cost S3 object storage when using the Standard storage service level by way of [cool access](https://learn.microsoft.com/azure/azure-netapp-files/cool-access-introduction). Cold blocks get automatically moved to S3, and when they are requested again by a client, they are automatically brought back to the active file system.

More savings can be seen when you provision and de-provision capacity pools of different types throughout the month, providing just-in-time performance and reducing costs during periods when you don't need high performance.

#### Pricing

You can determine which Azure NetApp Files service level (Standard, Premium, or Ultra) you need based on your capacity and performance requirements. Then, use the [Azure Pricing calculator](https://azure.microsoft.com/pricing/calculator) to evaluate the costs for these components:

- Skytap on Azure components
- Azure NetApp Files
- ExR circuits and gateways
- Virtual network

### Performance efficiency

[Performance efficiency](https://learn.microsoft.com/azure/architecture/framework/scalability/overview) is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

Azure NetApp Files offers the ability to dynamically scale up or scale down performance [service levels](https://learn.microsoft.com/azure/azure-netapp-files/azure-netapp-files-service-levels) as your workloads dictate without disruption.

Service levels include:

- Standard – 16MiB/s per 1TiB
- Premium – 64MiB/s per 1TiB
- Ultra – 128MiB/s per 1TiB

If more performance is needed than the capacity allows, consider setting [manual QoS](https://learn.microsoft.com/azure/azure-netapp-files/manage-manual-qos-capacity-pool) on the capacity pool to maximize the allowed throughput on the volume.

Performance efficiency in Azure NetApp Files allows you to easily control costs based on required performance for your application workload.

### Considerations

Depending on your requirements for throughput and capacity, keep the following considerations in mind:

- [Performance considerations for Azure NetApp Files](https://learn.microsoft.com/azure/azure-netapp-files/azure-netapp-files-performance-considerations)

- [Skytap Service limits](https://help.skytap.com/overview-service-limits.html)

## Skytap at Scale

You can easily scale compute performance by adding capacity to LPARs running in Skytap on Azure.

You can also dynamically scale storage of Azure NetApp Files volumes. If you use [automatic QoS](https://learn.microsoft.com/azure/azure-netapp-files/azure-netapp-files-performance-considerations), performance is scaled at the same time. For more granular control of each volume, you can control the performance of each volume separately by using [manual QoS](https://learn.microsoft.com/azure/azure-netapp-files/azure-netapp-files-performance-considerations#manual-qos-volume-quota-and-throughput) for your capacity pools.

Azure NetApp Files volumes are available in [Ultra, Premium, and Standard performance tiers](https://learn.microsoft.com/azure/azure-netapp-files/azure-netapp-files-service-levels#supported-service-levels). Choose the tier that best suits your performance requirements, taking into account that available performance bandwidth [scales with the size of a volume](https://learn.microsoft.com/azure/azure-netapp-files/azure-netapp-files-service-levels#throughput-limits). You can [change the service level of a volume](https://docs.netapp.com/cloud-manager-azure-netapp-files/task-manage-volumes.html#:~:text=Change%20the%20volume%E2%80%99s%20service%20level%201%20Open%20the,service%20level%20that%20you%20want.%204%20Click%20Change.) at any time without disruption to storage operations. For more information about the Azure NetApp Files cost model, see these [pricing examples](https://learn.microsoft.com/azure/azure-netapp-files/azure-netapp-files-cost-model#pricing-examples).

Check out the [Azure NetApp Files Performance Calculator](https://cloud.netapp.com/azure-netapp-files/sizer) to get started.

## Contributors

### Principal Authors

[Abishek Jain](https://www.linkedin.com/in/abhishek141088/) – Cloud Solutions Architect, Skytap

[Jason Scott](https://www.linkedin.com/in/jasonpaulscott/) – Director of Field Technical Sales, Skytap

### Other contributors

[Justin Parisi](https://www.linkedin.com/in/jmparisi/) – Technical Marketing Engineer, Azure NetApp Files

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Migrate AIX workloads to Azure with Skytap - Azure Example Scenarios | Microsoft Learn](https://learn.microsoft.com/azure/architecture/example-scenario/mainframe/migrate-aix-workloads-to-azure-with-skytap)

- [Migrate IBM i series to Azure with Skytap - Azure Example Scenarios | Microsoft Learn](https://learn.microsoft.com/azure/architecture/example-scenario/mainframe/migrate-ibm-i-series-to-azure-with-skytap)

- [Skytap help and documentation](https://help.skytap.com/)

- [What is Azure NetApp Files](https://learn.microsoft.com/azure/azure-netapp-files/azure-netapp-files-introduction)

## Related resources

- [About Skytap](https://www.skytap.com/about-us/)

- [Understand NAS concepts in Azure NetApp Files | Microsoft Learn](https://learn.microsoft.com/azure/azure-netapp-files/network-attached-storage-concept)

- [Understand data protection and disaster recovery options in Azure NetApp Files | Microsoft Learn](https://learn.microsoft.com/azure/azure-netapp-files/data-protection-disaster-recovery-options)