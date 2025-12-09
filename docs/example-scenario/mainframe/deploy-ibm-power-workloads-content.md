[Skytap on Azure](https://azuremarketplace.microsoft.com/marketplace/apps/skytapinc.skytap-on-azure-main1) is a cloud infrastructure as a service (IaaS) that you can use to run [IBM Power](https://www.ibm.com/power) workloads such as AIX, IBM i (AS/400), and Linux on Power together with x86 workloads natively on Azure. Skytap doesn't require refactoring, rearchitecting, or replatforming, so you can easily move traditional workloads to Azure.

If you deploy Skytap on Azure, use [Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-introduction) for file storage. You can scale storage allocations up or down at any time without service interruptions. You can also dynamically adjust storage service-level performance requirements.

For more information, see [Migrate IBM i series to Azure with Skytap](/azure/architecture/example-scenario/mainframe/migrate-ibm-i-series-to-azure-with-skytap).

## Architecture

:::image type="content" source="media/deploy-ibm-power-workloads.svg" alt-text="Diagram of an example scenario that demonstrates how to use Azure NetApp Files with workloads in Skytap on Azure." lightbox="media/deploy-ibm-power-workloads.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/deploy-ibm-power-workloads.vsdx) of this architecture.*

### Workflow

This architecture demonstrates how to use Azure NetApp Files with workloads in Skytap on Azure. The following workflow corresponds to the previous diagram:

1. Use an Azure VPN gateway or an Azure ExpressRoute circuit to connect to the private network.
1. Set up an Azure NetApp Files capacity pool and a share from the Azure portal.
1. Mount the share on AIX, IBM i, or Linux on Power-based workloads in Skytap on Azure.
1. Use shares as primary storage, and share files across platforms and Azure-native deployments.

### Components

The architecture uses these components:

- [Skytap on Azure](https://azuremarketplace.microsoft.com/marketplace/apps/skytapinc.skytap-on-azure-main1) is a service in Azure that natively runs IBM Power and x86 traditional workloads on hardware in Azure datacenters. If your organization runs IBM Power-based AIX, IBM i, or Linux operating systems (OS), you can use Skytap on Azure to migrate workloads to Azure with minimal upfront effort.

- [Azure NetApp Files](/azure/well-architected/service-guides/azure-netapp-files) is an Azure-native, enterprise-class, high-performance file storage service. Azure NetApp Files provides volumes as a service that you can use to create NetApp accounts, capacity pools, and volumes. You can select service and performance levels and manage data protection and replication across zones and regions.

- [ExpressRoute](/azure/well-architected/service-guides/azure-expressroute) extends your on-premises networks into the Microsoft cloud over a private connection with the help of a connectivity provider. You can use ExpressRoute to establish connections to Microsoft cloud services, such as Microsoft Azure and Microsoft 365.

- [Azure virtual machines (VMs)](/azure/well-architected/service-guides/virtual-machines) are an on-demand, scalable computing resource that Azure offers. Typically, you use a VM when you need more control over a computing environment than what other resources provide.

- [Azure VPN Gateway](/azure/vpn-gateway/vpn-gateway-about-vpngateways) connects your on-premises networks to Azure through site-to-site VPNs in a process similar to the one that you use to set up and connect to a remote branch office. This configuration provides secure connections that use the industry-standard protocols Internet Protocol Security (IPsec) and Internet Key Exchange (IKE).

### Alternatives

- Azure Blob Storage
- Azure Files

## Scenario details

### Potential use cases

You can use Azure NetApp Files for scenarios that need network file storage in the cloud and for the following use cases:

- **Scalable and resilient file share service**: A scalable and resilient file share service is a robust storage solution that can grow alongside your data needs and keep your information safe. Use a file share service to add storage capacity in real time when you need it to improve performance. You can also incorporate replication for built-in data resiliency to ensure that data is always accessible. Azure NetApp Files provides a reliable and adaptable platform for sharing and storing your mission-critical workload files that are hosted on the IBM Power platform.

- **Critical backups**: You can use [the AIX `mksysb` command](https://www.ibm.com/docs/aix/7.2?topic=m-mksysb-command) to create bootable backups of your system's core so that you can migrate to new hardware or restore your system after a crash. The `mksysb` command captures the root volume group and settings by saving it to a file that you can use to restore the systems base image or a few files. Azure NetApp Files provides a scalable, cost-effective way to store these backups in the Azure cloud.

- **Centralized data storage**: You can use Azure NetApp Files to create a shared storage pool that multiple AIX systems can access through Network File System (NFS). This shared storage pool includes user home directories, application data, or project files across your network. You often use a shared storage pool for distributed applications.

- **High availability**: For failover capabilities, you can integrate Azure NetApp Files with AIX clustering solutions like PowerHA SystemMirror. If one server goes down, clients can seamlessly access data from another server that hosts the same NFS repository in Azure NetApp Files.

- **SAP global transport directory**: The [SAP global transport directory](https://techcommunity.microsoft.com/t5/running-sap-applications-on-the/designing-sap-global-transport-directory-using-anf-in-azure/ba-p/2621547) (_/usr/sap/trans_) is a shared location that resides on the global domain controller of an SAP transport management system (TMS). Depending on requirements, you might have one global transport directory or multiple transport directories. You can use this directory as an NFS share that's hosted in the Azure cloud on Azure NetApp Files. Use the directory to share files with multiple clients across a network. Azure NetApp Files provides resiliency and performance in this scenario.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

Skytap on Azure provides a standard 99.95% availability service-level objective (SLO) for the platform and logical partitions (LPARs).

Azure NetApp Files provides a [standard 99.99% availability service-level agreement (SLA)](https://azure.microsoft.com/support/legal/sla/netapp/v1_1) for all tiers and supported regions. Azure NetApp Files also supports provisioning volumes in [availability zones](/azure/azure-netapp-files/use-availability-zones) that you choose, and supports HA deployments across zones for added data protection if there's a zone outage.

For improved recovery point objective and recovery time objective (RPO/RTO) SLAs, integrated data protection with [snapshots](/azure/azure-netapp-files/snapshots-introduction) and [backup](/azure/azure-netapp-files/backup-introduction) are available with the service. Additionally, [cross-region replication](/azure/azure-netapp-files/snapshots-introduction#how-volumes-and-snapshots-are-replicated-cross-region-for-dr) provides disaster recovery benefits across Azure regions.

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

Azure NetApp Files provides an extra level of security by keeping [volumes and data traffic within your virtual networks](/azure/azure-netapp-files/faq-security#can-the-network-traffic-between-the-azure-vm-and-the-storage-be-encrypted) and not providing a publicly addressable endpoint. All [data is encrypted at rest](/azure/azure-netapp-files/faq-security#can-the-storage-be-encrypted-at-rest) always. You can also use [NFS Kerberos](/azure/azure-netapp-files/understand-data-encryption) to encrypt data in transit.

Azure NetApp Files provides support for standard NFSv4.1 security measures, such as name strings, limited firewall port exposure, [LDAP integration](/azure/azure-netapp-files/configure-ldap-extended-groups), and [NFSv4.1 ACLs](/azure/azure-netapp-files/configure-access-control-lists).

The [Azure Policy](/azure/governance/policy/overview) can help you enforce organizational standards and assess compliance at scale. Azure NetApp Files supports Azure Policy through [custom and built-in policy definitions](/azure/azure-netapp-files/azure-policy-definitions).

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

Understand the [Azure NetApp Files cost model](/azure/azure-netapp-files/azure-netapp-files-cost-model) to help you manage your cloud spend.

Billing for Azure NetApp Files is based on provisioned storage capacity, which you allocate by creating capacity pools.

#### Capacity requirement fluctuations

If your capacity pool size requirements fluctuate, consider resizing your volumes and capacity pools to balance cost with your variable capacity and performance needs. You can resize with no disruption to your workloads.

#### Performance requirement fluctuations

If your capacity pool size requirements are consistent but performance requirements fluctuate, consider dynamically changing the [service level](/azure/azure-netapp-files/azure-netapp-files-service-levels) of a volume. Azure NetApp Files has multiple service levels to provide the best blend of performance to cost optimization for your cloud needs. For instance, if your workloads are busy only at certain times in the quarter, apply the Premium or Ultra service levels to maximize your performance. Or if your workload occasionally goes stagnant, nondisruptively adjust the service level of the volume to Standard to reduce costs.

#### Automatically tier cold data

Azure NetApp Files has a Standard storage service level with [cool access](/azure/azure-netapp-files/cool-access-introduction). You can use this feature to tier cold data and reduce object storage cost. Cool access automatically moves cold blocks to Azure Blob storage and automatically returns them to the active file system when a client requests them.

You can also provision and deprovision various types of capacity pools throughout the month to provide just-in-time performance and reduce costs during periods when you don't need high performance.

#### Pricing

Determine which Azure NetApp Files service level (Standard, Premium, or Ultra) that you need based on your capacity and performance requirements. Use the [Azure Pricing calculator](https://azure.microsoft.com/pricing/calculator) to evaluate the costs for these components:

- Skytap on Azure components
- Azure NetApp Files
- ExpressRoute circuits and VPN gateways
- Virtual networks

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

Azure NetApp Files offers the ability to dynamically scale up performance service levels or scale down performance [service levels](/azure/azure-netapp-files/azure-netapp-files-service-levels) without disruption as your workload needs change.

Service levels include:

- Standard: 16MiB/s per 1 TiB
- Premium: 64MiB/s per 1 TiB
- Ultra: 128MiB/s per 1 TiB

If you need more performance than the capacity permits, consider setting the [manual Quality of Service (QoS)](/azure/azure-netapp-files/manage-manual-qos-capacity-pool) type on the capacity pool to maximize the allowed throughput on the volume.

Use Azure NetApp Files to control costs based on required performance for your application workload.

For requirements related to your throughput and capacity, see:

- [Performance considerations for Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-performance-considerations)

- [Skytap service limits](https://help.skytap.com/overview-service-limits.html)

#### Skytap at scale

To scale compute performance, you can add capacity to LPARs that run in Skytap on Azure. You can also dynamically scale storage for Azure NetApp Files volumes. [Automatic QoS](/azure/azure-netapp-files/azure-netapp-files-performance-considerations) automatically scales performance. For more granular control of each volume, use [manual QoS](/azure/azure-netapp-files/azure-netapp-files-performance-considerations#manual-qos-volume-quota-and-throughput) to control the performance of each volume separately for your capacity pools.

Azure NetApp Files volumes are available in [Ultra, Premium, Standard and Flexible service levels](/azure/azure-netapp-files/azure-netapp-files-service-levels#supported-service-levels). When you choose the tier that best suits your performance requirements, consider that available performance bandwidth [scales with the size of a volume](https://docs.netapp.com/us-en/bluexp-azure-netapp-files/task-manage-volumes.html). You can [change the service level of a volume](https://docs.netapp.com/us-en/occm37/task_manage_anf.html) at any time without disruption to storage operations. For more information about the Azure NetApp Files cost model, see [Pricing examples](/azure/azure-netapp-files/azure-netapp-files-cost-model#pricing-examples).

To get started, see the [Azure NetApp Files performance calculator](https://azure.github.io/azure-netapp-files/calc/).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors

- [Abhishek Jain](https://www.linkedin.com/in/abhishek141088/) | Cloud Solutions Architect, Skytap
- [Jason Scott](https://www.linkedin.com/in/jasonpaulscott/) | Director of Field Technical Sales, Skytap

Other contributors:

- [Justin Parisi](https://www.linkedin.com/in/jmparisi/) | Technical Marketing Engineer, Azure NetApp Files

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [About Skytap](https://www.skytap.com/about-us/)
- [Skytap help and documentation](https://help.skytap.com/)
- [What is Azure NetApp Files?](/azure/azure-netapp-files/azure-netapp-files-introduction)
- [Understand NAS concepts in Azure NetApp Files | Microsoft Learn](/azure/azure-netapp-files/network-attached-storage-concept)
- [Understand data protection and disaster recovery options in Azure NetApp Files | Microsoft Learn](/azure/azure-netapp-files/data-protection-disaster-recovery-options)

## Related resources

- [Migrate AIX workloads to Azure with Skytap](/azure/architecture/example-scenario/mainframe/migrate-aix-workloads-to-azure-with-skytap)
- [Migrate IBM i series to Azure with Skytap](/azure/architecture/example-scenario/mainframe/migrate-ibm-i-series-to-azure-with-skytap)
