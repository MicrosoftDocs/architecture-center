[Skytap on Azure](https://azuremarketplace.microsoft.com/marketplace/apps/skytapinc.skytap-on-azure-main1) is a cloud infrastructure-as-a-service (Iaas) designed to run [IBM Power](https://www.ibm.com/power) workloads such as AIX, IBM i (AS/400), and Linux on Power together with x86 workloads natively in Azure. Skytap doesn't require refactoring, rearchitecting, or replatforming, which provides a simple path to Azure for traditional workloads.

 If you deploy Skytap on Azure, [Azure NetApp Files](https://learn.microsoft.com/azure/azure-netapp-files/azure-netapp-files-introduction) is an excellent file storage option. You can use Azure NetApp Files to scale storage allocations up or down at any time without service interruptions. You can also dynamically adjust storage service-level performance requirements.

For more information about how to migrate Skytap to Azure, see [Migrate IBM i Series to Azure with Skytap](/azure/architecture/example-scenario/mainframe/migrate-ibm-i-series-to-azure-with-skytap).

## Architecture

:::image type="content" source="media/deploy-ibm-power-in-skytap-on-azure.svg" alt-text="Diagram of an example scenario that demonstrates how to use Azure NetApp Files with workloads in Skytap on Azure." lightbox="media/deploy-ibm-power-in-skytap-on-azure.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/deploy-ibm-power-in-skytap-on-azure) of this architecture.*

### Workflow

This example scenario demonstrates how to use Azure NetApp Files with workloads in Skytap on Azure. The following workflow corresponds to the previous diagram:

1. Use VPN Gateway or ExpressRoute to connect to the private network.
1. Set up an Azure NetApp Files capacity pool and share from the Azure portal.
1. Mount the share on AIX, IBMi, or Linux on Power based workloads in Skytap on Azure.
1. Use shares as primary storage. Share files across platforms and Azure native deployments.

### Components

The architecture uses these components:

- [Skytap on Azure](https://azuremarketplace.microsoft.com/marketplace/apps/skytapinc.skytap-on-azure-main1) is a service in Azure that natively runs IBM Power and x86 traditional workloads on hardware in Azure datacenters. Organizations of any size that run IBM Power based AIX, IBMi, or Linux operating systems (OS) can migrate them to Azure with little upfront effort.

- [Azure NetApp Files](https://azure.microsoft.com/products/netapp/) is an Azure native, first-party, enterprise-class, high-performance file storage service. Azure NetApp Files provides Volumes as a service for which you can create NetApp accounts, capacity pools, and volumes. You can select service and performance levels and manage data protection and replication across zones and regions.

- [ExpressRoute](https://azure.microsoft.com/products/expressroute/) lets you extend your on-premises networks into the Microsoft cloud over a private connection with the help of a connectivity provider. You can use ExpressRoute to establish connections to Microsoft cloud services, such as Microsoft Azure and Microsoft 365.

- [Azure VMs](https://azure.microsoft.com/products/virtual-machines) are one of several types of on-demand, scalable computing resources that Azure provides. Typically, you choose a virtual machine (VM) when you need more control over the computing environment than is provided by the other resources.

- [Azure VPN](https://azure.microsoft.com/products/vpn-gateway/) connects your on-premises networks to Azure through site-to-site VPNs in a similar way that you set up and connect to a remote branch office. The connectivity is secure and uses the industry-standard protocols Internet Protocol Security (IPsec) and Internet Key Exchange (IKE).

### Alternatives

- Azure Blob Storage
- Azure Files

## Scenario details

### Potential use cases

You can use Azure NetApp Files for the following use cases, but it is also an option in nearly any scenario in which networked file storage in the cloud is needed.

- **Scalable and resilient file service**: A scalable and resilient file share service is a robust storage solution that can grow alongside your data needs and keep your information safe. It can add storage capacity and performance in real-time, as needed, and ensures that data is always accessible through replication and built-in data resiliency. Azure NetApp Files provides a reliable and adaptable platform for sharing and storing your files for mission-critical workloads hosted on the IBM Power platform.

- **Critical backups**: Use [mksysb](https://www.ibm.com/docs/aix/7.2?topic=m-mksysb-command) for AIX to create bootable backups of your system's core. You can use mksysb to migrate to new hardware or restore your backups after a crash. Mksysb captures the root volume group and settings by saving it to a file that can be used to restore the systems base image or a few files. Azure NetApp Files provides a scalable, cost-effective way to store these backups in the Azure cloud.

- **Centralized data storage**: Azure NetApp Files lets you create a shared storage pool that's accessible by multiple AIX systems through Network File System (NFS). This includes user home directories, application data, or project files across your network, which is a common use case in distributed applications.

- **High availability**: For failover capabilities, you can integrate Azure NetApp Files with AIX clustering solutions like PowerHA SystemMirror. If one server goes down, clients can seamlessly access data from another server that's hosting the same NFS repository in Azure NetApp Files.

- **SAP global transport directory**: The [SAP global transport directory](https://techcommunity.microsoft.com/t5/running-sap-applications-on-the/designing-sap-global-transport-directory-using-anf-in-azure/ba-p/2621547) (_/usr/sap/trans_) is a shared location that resides on the global domain controller of an SAP transport management system (TMS). Depending on requirements, you might have one global transport directory or multiple transport directories. This directory can be described as an NFS share that's hosted in the Azure cloud on Azure NetApp Files to enable sharing to multiple clients across a network. The combination of resiliency and performance makes Azure NetApp Files best suited for this scenario.

## Considerations

Azure NetApp Files contains a set of features that provides design considerations based on the pillars of the [Azure Well-Architected Framework](https://learn.microsoft.com/azure/architecture/framework), which is a set of guiding tenets used to improve the quality of a workload.

### Reliability

Reliability ensures your applications meet the commitments you make to your customers. For more information, see the [Overview of the Reliability pillar](https://learn.microsoft.com/azure/architecture/framework/resiliency/overview).

Skytap on Azure provides a standard 99.95% availability service-level objective (SLO) for the platform and logical partitions (LPARs).

Azure NetApp Files provides a [standard 99.99% availability service-level agreement (SLA)](https://azure.microsoft.com/support/legal/sla/netapp/v1_1) for all tiers and supported regions. Azure NetApp Files also supports provisioning volumes in [availability zones](https://learn.microsoft.com/azure/azure-netapp-files/use-availability-zones) that you choose, and supports HA deployments across zones for added data protection if there's a zone outage.

For improved recovery point objective and recovery time objective (RPO/RTO) SLAs, integrated data protection with [snapshots](https://learn.microsoft.com/azure/azure-netapp-files/snapshots-introduction) and [backup](https://learn.microsoft.com/azure/azure-netapp-files/backup-introduction) are available with the service. Additionally, [cross-region replication](https://learn.microsoft.com/azure/azure-netapp-files/snapshots-introduction#how-volumes-and-snapshots-are-replicated-cross-region-for-dr) provides disaster recovery benefits across Azure regions.

### Security

Security provides assurance against deliberate attacks and abuse of valuable data and systems. For more information, see [Overview of the Security pillar](https://learn.microsoft.com/azure/architecture/framework/security/overview).

Azure NetApp Files provides an extra level of security by keeping [volumes and data traffic within your virtual networks](https://learn.microsoft.com/azure/azure-netapp-files/faq-security#can-the-network-traffic-between-the-azure-vm-and-the-storage-be-encrypted) and not providing a publicly addressable endpoint. All [data is encrypted at rest](https://learn.microsoft.com/azure/azure-netapp-files/faq-security#can-the-storage-be-encrypted-at-rest) at all times. You can also use [NFS Kerberos](https://learn.microsoft.com/azure/azure-netapp-files/understand-data-encryption) to encrypt data in transit.

Additionally, Azure NetApp Files provides support for standard NFSv4.1 security measures, such as name strings, limited firewall port exposure, [LDAP integration](https://learn.microsoft.com/azure/azure-netapp-files/configure-ldap-extended-groups), and [NFSv4.1 ACLs](https://learn.microsoft.com/azure/azure-netapp-files/configure-access-control-lists).

The [Azure Policy](https://learn.microsoft.com/azure/governance/policy/overview) can help you enforce organizational standards and assess compliance at scale. Azure NetApp Files supports Azure Policy through [custom and built-in policy definitions](https://learn.microsoft.com/azure/azure-netapp-files/azure-policy-definitions).

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

Understand the [Azure NetApp Files cost model](https://learn.microsoft.com/azure/azure-netapp-files/azure-netapp-files-cost-model) to help you manage your cloud spend.

Billing for Azure NetApp Files is based on provisioned storage capacity, which you allocate by creating capacity pools.

#### Dynamic capacity adjustments

If your capacity pool size requirements fluctuate for reasons such as variable capacity or performance needs, consider resizing your volumes and capacity pools to balance cost with your capacity and performance needs. You can resize with no disruption to your workloads.

#### Performance when you need it without interruption

If your capacity pool size requirements remain the same but performance requirements fluctuate, consider dynamically changing the [service level](https://learn.microsoft.com/azure/azure-netapp-files/azure-netapp-files-service-levels) of a volume. Azure NetApp Files offers multiple service levels to provide the best blend of performance to cost optimization for your cloud needs. For instance, if your workloads are only busy at certain times in the quarter, apply the Premium or Ultra service levels to maximize your performance. Or if your workload occasionally goes stagnant, nondisruptively adjust the service level of the volume to Standard to reduce costs.

#### Automatically tier cold data to lower cost storage

Azure NetApp Files offers a way to tier cold data to lower cost S3 object storage when you use the Standard storage service level by using [cool access](https://learn.microsoft.com/azure/azure-netapp-files/cool-access-introduction). Cold blocks are automatically moved to S3, and when a client requests them again, the cold blocks are automatically brought back to the active file system.

When you provision and deprovision capacity pools of different types throughout the month, just-in-time performance is enabled and costs are reduced during periods when you don't need high performance.

#### Pricing

You can determine which Azure NetApp Files service level (Standard, Premium, or Ultra) you need based on your capacity and performance requirements. Use the [Azure Pricing calculator](https://azure.microsoft.com/pricing/calculator) to evaluate the costs for these components:

- Skytap on Azure components
- Azure NetApp Files
- ExpressRoute circuits and gateways
- Virtual network

### Performance efficiency

[Performance efficiency](https://learn.microsoft.com/azure/architecture/framework/scalability/overview) is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

Azure NetApp Files offers the ability to dynamically scale up performance service levels or scale down performance [service levels](https://learn.microsoft.com/azure/azure-netapp-files/azure-netapp-files-service-levels) without disruption as your workload needs change.

Service levels include:

- Standard – 16MiB/s per 1 TiB
- Premium – 64MiB/s per 1 TiB
- Ultra – 128MiB/s per 1 TiB

If more performance is needed than the capacity allows, consider setting [manual QoS](https://learn.microsoft.com/azure/azure-netapp-files/manage-manual-qos-capacity-pool) on the capacity pool to maximize the allowed throughput on the volume.

Performance efficiency in Azure NetApp Files lets you control costs based on required performance for your application workload.

### Considerations

Depending on your requirements for throughput and capacity, consider the following:

- [Performance considerations for Azure NetApp Files](https://learn.microsoft.com/azure/azure-netapp-files/azure-netapp-files-performance-considerations)

- [Skytap service limits](https://help.skytap.com/overview-service-limits.html)

## Skytap at Scale

You can scale compute performance by adding capacity to LPARs that run in Skytap on Azure.

You can also dynamically scale storage of Azure NetApp Files volumes. If you use [automatic QoS](https://learn.microsoft.com/azure/azure-netapp-files/azure-netapp-files-performance-considerations), performance is scaled at the same time. For more granular control of each volume, use [manual QoS](https://learn.microsoft.com/azure/azure-netapp-files/azure-netapp-files-performance-considerations#manual-qos-volume-quota-and-throughput) to control the performance of each volume separately for your capacity pools.

Azure NetApp Files volumes are available in [Ultra, Premium, and Standard performance tiers](https://learn.microsoft.com/azure/azure-netapp-files/azure-netapp-files-service-levels#supported-service-levels). Choose the tier that best suits your performance requirements by taking into account that available performance bandwidth [scales with the size of a volume](https://learn.microsoft.com/azure/azure-netapp-files/azure-netapp-files-service-levels#throughput-limits). You can [change the service level of a volume](https://docs.netapp.com/cloud-manager-azure-netapp-files/task-manage-volumes.html#:~:text=Change%20the%20volume%E2%80%99s%20service%20level%201%20Open%20the,service%20level%20that%20you%20want.%204%20Click%20Change.) at any time without disruption to storage operations. For more information about the Azure NetApp Files cost model, see [pricing examples](https://learn.microsoft.com/azure/azure-netapp-files/azure-netapp-files-cost-model#pricing-examples).

Check out the [Azure NetApp Files Performance Calculator](https://cloud.netapp.com/azure-netapp-files/sizer) to get started.

## Contributors

### Principal Authors

- [Abishek Jain](https://www.linkedin.com/in/abhishek141088/) – Cloud Solutions Architect, Skytap

- [Jason Scott](https://www.linkedin.com/in/jasonpaulscott/) – Director of Field Technical Sales, Skytap

### Other contributors

- [Justin Parisi](https://www.linkedin.com/in/jmparisi/) – Technical Marketing Engineer, Azure NetApp Files

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Migrate AIX workloads to Azure with Skytap - Azure Example Scenarios | Microsoft Learn](https://learn.microsoft.com/azure/architecture/example-scenario/mainframe/migrate-aix-workloads-to-azure-with-skytap)

- [Migrate IBM i series to Azure with Skytap - Azure Example Scenarios | Microsoft Learn](https://learn.microsoft.com/azure/architecture/example-scenario/mainframe/migrate-ibm-i-series-to-azure-with-skytap)

- [Skytap help and documentation](https://help.skytap.com/)

- [What is Azure NetApp Files?](https://learn.microsoft.com/azure/azure-netapp-files/azure-netapp-files-introduction)

## Related resources

- [About Skytap](https://www.skytap.com/about-us/)

- [Understand NAS concepts in Azure NetApp Files | Microsoft Learn](https://learn.microsoft.com/azure/azure-netapp-files/network-attached-storage-concept)

- [Understand data protection and disaster recovery options in Azure NetApp Files | Microsoft Learn](https://learn.microsoft.com/azure/azure-netapp-files/data-protection-disaster-recovery-options)
