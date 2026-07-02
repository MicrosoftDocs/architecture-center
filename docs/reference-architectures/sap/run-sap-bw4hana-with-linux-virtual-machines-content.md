The following example focuses on the SAP BW/4HANA application tier. This application tier suits small-scale production environments of SAP BW/4HANA on Azure that require high availability (HA).

## Architecture

:::image type="complex" border="false" source="./images/sap-bw4hana.svg" alt-text="Diagram that shows the SAP BW/4HANA with Linux virtual machines architecture." lightbox="./images/sap-bw4hana.svg":::
   Diagram that shows an on-premises datacenter that connects with a bidirectional arrow to a hub virtual network via a VPN or Azure ExpressRoute. The hub virtual network, an SAP workload virtual network, Microsoft Power BI, and Azure Backup and Azure Site Recovery are inside the Azure network. The hub virtual network contains a gateway and Azure Bastion, and connects with a bidirectional arrow to the SAP workload virtual network. The SAP workload virtual network contains an application tier subnet, a delegated storage subnet, and a database subnet that connects to Azure Managed Disks and the delegated storage subnet. The application tier subnet contains Azure Load Balancer, an SAP Web Dispatcher pool, an SAP application servers pool, an SAP Central Services cluster, a network security group (NSG), and Internet Small Computer Systems Interface (iSCSI) target virtual machines (VMs). The database subnet contains the SAP HANA database. The delegated storage subnet contains Azure NetApp Files. The gateway connects to Azure Standard Load Balancer with a dotted line, which also connects to the SAP Web Dispatcher pool, the SAP applications servers pool, the SAP Central Services cluster, and the database subnet.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/sap-bw4hana.vsdx) of this architecture.*

### Workflow

The following workflow corresponds to the previous diagram:

1. Data packets flow through the on-premises network gateway that passes through the Azure ExpressRoute carrier's premises.

1. The data packets enter the Microsoft Azure network from the ExpressRoute carrier's network onto the Azure hub virtual network.

1. If the data packets meet perimeter Azure Virtual Network security requirements, they connect to the spoke virtual network that contains the SAP application servers and database.

1. The encrypted data packets reach the SAP Web Dispatcher servers, where they're decrypted.

1. Application servers use the decrypted packets, perform the business logic, request data from the SAP HANA database, and generate annual transaction volume information.

1. The system returns the data retrieval and analysis results to the user along the same path as the original inquiry.

### Components

- [Virtual Network](/azure/well-architected/service-guides/virtual-network) securely connects Azure resources to each other and to an on-premises environment. In this architecture, multiple virtual networks are [peered together](/azure/virtual-network/virtual-network-peering-overview).

- The application tier uses [Linux virtual machines (VMs)](../n-tier/linux-vm.yml) in the following SAP application components:

  - SAP BusinessObjects (BOBJ) server pool

  - SAP Web Dispatcher pool
  
  - Application servers pool
  
  - SAP Central Services cluster

- [Azure Load Balancer](/azure/well-architected/service-guides/azure-load-balancer) distributes network traffic across backend resources. In this architecture, an internal [load balancer](/azure/load-balancer/load-balancer-overview) directs traffic to VMs in the application subnet. This example uses [SAP Web Dispatcher](https://help.sap.com/saphelp_nwce72/helpdata/en/48/8fe37933114e6fe10000000a421937/content.htm?no_cache=true) and Azure Load Balancer for HA. Use these services to scale out for capacity extension, or choose Azure Application Gateway or a partner product. Select the option based on traffic type and required functionality, such as TLS termination and forwarding.

- [Network security groups (NSGs)](/azure/virtual-network/network-security-groups-overview) filter and control network traffic in Azure virtual networks. In this architecture, NSGs attach to a subnet or to the NICs on a VM and restrict incoming, outgoing, and intrasubnet virtual network traffic.

- [Azure Bastion](/azure/bastion/bastion-overview) provides secure remote access to Azure VMs through the Azure portal. In this architecture, Azure Bastion provides secure access to Azure VMs without a jump box or a public IP address and reduces internet-facing exposure.

- [Azure managed disks](/azure/virtual-machines/disks-types) provide persistent block storage for Azure VMs. In this architecture, Azure managed disks provide data persistence for VMs that run SAP workloads. Use Azure Premium SSDs or Azure Ultra Disk Storage.

- [Azure NetApp Files](/azure/well-architected/service-guides/azure-netapp-files) provides fully managed, high-performance file storage for cloud workloads. In this architecture, Azure NetApp Files supports shared storage for high-performance scenarios that host SAP HANA data and log files when you use a cluster. Azure NetApp Files is fully managed and scalable for demanding workloads. It provides bare-metal performance, submillisecond latency, and integrated data management for:

  - SAP HANA.

  - High-performance computing.

  - Line-of-business applications.

  - High-performance file sharing.

  - Virtual desktop infrastructure.

- [Power BI](/power-bi/fundamentals/power-bi-overview) is a business analytics service that provides data analysis and visualization capabilities. In this architecture, Power BI accesses and visualizes SAP BW/4HANA data from your Windows desktop by using [SAP BW Connector](/power-bi/connect-data/desktop-sap-bw-connector). Power BI Desktop imports data from SAP sources, such as SAP BW/4HANA, for analysis and visualization. Power BI provides a business context or a semantics layer over raw data, which complements the SAP BOBJ universe.

- [Azure Backup](/azure/backup/backup-overview) provides backup and recovery services for Azure workloads. In this architecture, Azure Backup serves as an SAP Backint-certified data protection solution for SAP HANA in single-instance and scale-up deployments and protects Azure VMs that have general workloads.

- [Azure Site Recovery](/azure/site-recovery/site-recovery-overview) orchestrates disaster recovery (DR) for workloads that run on Azure and on-premises. In this architecture, Azure Site Recovery forms part of an automated DR solution for multitier SAP NetWeaver application deployments. For more information about the capabilities and restrictions of this solution, see [Support matrix for Azure VM DR between Azure regions](/azure/site-recovery/azure-to-azure-support-matrix).

### Alternatives

This architecture includes multiple components that you can substitute with other Azure services or approaches, depending on your workload's functional and nonfunctional requirements. Consider the following alternatives and their trade-offs.

- To help protect SAP global host files for SAP Central Services and the SAP transport directory, deploy [Network File System (NFS)](/azure/sap/workloads/high-availability-guide-suse-nfs) servers in a failover cluster configuration.

- To protect global host files for Central Services, use [SIOS clustering solutions](https://us.sios.com/solutions/cloud-high-availability/azure) instead of NFS or Azure NetApp Files.

- [Application Gateway](/azure/application-gateway/features) is a web traffic load balancer. It provides TLS termination, a web application firewall (WAF), and other high-availability and scalability features. You can use it as a [gateway for the SAP Fiori front end](https://www.linkedin.com/pulse/internet-facing-sap-fiori-access-azure-firewall-gateway-apparao-sanam) in some SAP production deployments.

## Scenario details

SAP BW/4HANA is an enterprise data warehouse solution that's designed for the cloud and optimized for SAP HANA. This architecture focuses on the SAP BW/4HANA application tier, and suits high-availability, small-scale production environments.

This example workload uses a similar deployment approach to [SAP NetWeaver (Windows) for AnyDB on VMs](../../guide/sap/sap-netweaver.md) and [SAP S/4HANA for Linux VMs on Azure](../../guide/sap/sap-s4hana.md). The application layer deploys by using scalable VMs.

The simplified network layout demonstrates best-practice architectural principles for a [hub-spoke topology-based](../../networking/architecture/hub-spoke.yml) Azure enterprise deployment.

> [!NOTE]
> For more information about deployment considerations for SAP workloads on Azure, see the [SAP on Azure planning and deployment checklist](/azure/sap/workloads/deployment-checklist).
>
> For more information about the data persistence layer, see [Run SAP HANA on Linux VMs](./run-sap-hana-for-linux-virtual-machines.yml).

### Potential use cases

This scenario is relevant to the following use cases:

- Deployment of an SAP application layer that's separate from the DBMS layer

- DR scenarios

- SAP application tier deployments

## Recommendations

You can apply the following recommendations to most scenarios. Many recommendations for [SAP S/4HANA on Azure](../../guide/sap/sap-s4hana.md) also apply to SAP BW/4HANA deployments. Follow these recommendations unless you have a specific requirement that overrides them.

### VMs

For more information about SAP support for Azure VM types and throughput metrics, see [SAP applications on Azure: Supported products and Azure VM types](https://launchpad.support.sap.com/#/notes/1928533).

> [!IMPORTANT]
> To access SAP notes, open or sign in to your SAP Service Marketplace account.

For more information about VM certification for SAP HANA scale-out deployments, see the [SAP HANA hardware directory](https://www.sap.com/dmc/exp/2014-09-02-hana-hardware/enEN/).

### Application servers pool

In an application servers pool, you can adjust the number of VMs based on your requirements. [Azure is certified](/azure/sap/workloads/certifications) to run SAP BW/4HANA on Red Hat Enterprise Linux and SUSE Linux Enterprise.

Use SMLG to manage and load-balance logon groups for Advanced Business Application Programming application servers. Use SM61 to manage batch server groups. Use RZ12 to manage Remote Function Calls (RFC) groups.

SMLG transactions use the Central Services message server's load-balancing capability to distribute incoming sessions and workload to the SAP application servers pool for SAP GUIs and RFC traffic.

### SAP Central Services cluster

This example shows a highly available cluster that uses Azure NetApp Files as a shared file-storage solution. High availability for the Central Services cluster requires shared storage. Azure NetApp Files provides a simple, highly available option that doesn't need Linux cluster infrastructure. Alternatively, set up a highly available [NFS service](/azure/sap/workloads/high-availability-guide-suse#setting-up-a-highly-available-nfs-server).

The application server VMs support multiple IP addresses per NIC. This feature [uses virtual host names for installations](https://launchpad.support.sap.com/#/notes/962955). Virtual host names decouple SAP services from the physical host names and simplify migration between physical hosts.

Application servers connect to Central Services on Azure by using Central Services or Enqueue Replication Server (ERS) virtual host names. Assign these host names to the load balancer's cluster front-end IP address configuration. Load balancers support multiple front-end IP addresses so that you can bind Central Services and ERS virtual IP addresses to one load balancer.

#### Multi-SID installation

Azure supports HA for multisystem ID (multi-SID) installations in Linux and Windows clusters that host Central Services (ASCS/SCS). For more information about Pacemaker cluster deployments, see the Azure multi-SID documentation for:

- [Windows](/azure/sap/workloads/sap-ascs-ha-multi-sid-wsfc-shared-disk)
- [Red Hat Linux](/azure/sap/workloads/high-availability-guide-rhel-multi-sid)
- [SUSE Linux](/azure/sap/workloads/high-availability-guide-suse-multi-sid)

#### Proximity placement groups

To reduce network latency between VMs, this example architecture uses a [proximity placement group](/azure/sap/workloads/proximity-placement-scenarios). This group applies a location constraint to VM deployments and minimizes the physical distance between them. 

#### Azure Virtual Machine Scale Sets

To provide maximum spread across available fault-domains, place VMs in availability zones or regions by using [Azure Virtual Machine Scale Sets](/azure/sap/workloads/virtual-machine-scale-set-sap-deployment-guide?tabs=scaleset-portal).

### Database

SAP BW/4HANA is designed for the SAP HANA database platform. Azure provides the following scalability and deployment options:

- To achieve HA in a scale-up SAP HANA deployment, the database tier uses multiple Linux VMs in a cluster.

- Some VMs support a [scale-out deployment of SAP HANA](/azure/sap/workloads/planning-supported-configurations#sap-hana-scale-out-scenarios).  
  
- The SAP HANA hardware directory provides a list of VM SKUs that support online analytical processing and online transaction processing workloads for scale-up and scale-out configurations.

### Storage

This example uses [Premium SSDs](/azure/virtual-machines/disks-types#premium-ssd) for nonshared application server storage. This example uses [Azure NetApp Files](/azure/sap/workloads/high-availability-guide-suse-nfs) for cluster shared storage.

[Premium SSD v2](https://azure.microsoft.com/updates?id=general-availability-azure-premium-ssd-v2-disk-storage) is designed for performance-critical workloads like SAP. For more information about this solution's benefits and limitations, see [Deploy a Premium SSD v2](/azure/virtual-machines/disks-deploy-premium-v2).

[Ultra Disk Storage](/azure/virtual-machines/disks-enable-ultra-ssd) reduces disk latency for performance-critical applications like SAP database servers. To compare block storage options in Azure, see [Azure managed disk types](/azure/virtual-machines/disks-types).

[Standard managed disks aren't supported](https://launchpad.support.sap.com/#/notes/1928533).

Use Azure [cool and archive access tiers](/azure/storage/blobs/access-tiers-overview) as a backup data store. These tiers offer cost-effective storage for archived and infrequently accessed data.

### Networking

To provide logical isolation and security boundaries for an SAP landscape, deploy a [hub-spoke topology](../../networking/architecture/hub-spoke.yml). For more information about networking, see the [SAP S/4HANA reference architecture](../../guide/sap/sap-s4hana.md).

The hub virtual network provides a central point of connectivity to an on-premises network. Spoke virtual networks [peer](/azure/virtual-network/virtual-network-peering-overview) with the hub and isolate workloads. Traffic flows between the on-premises datacenter and the hub by using a gateway connection.

You can include one or more ExpressRoute circuits that connect on-premises networks to Azure. You can reduce network bandwidth demand and overhead by using a VPN.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

#### Availability

Highly available infrastructure relies on resource redundancy. Design a system that meets a resiliency target based on the application's intended service level. Align the architecture with the resiliency target and the intended service level. To select an appropriate solution, see the [service level agreements for online services](https://www.microsoft.com/licensing/docs/view/Service-Level-Agreements-SLA-for-Online-Services).

To maximize application availability, deploy redundant resources in an availability set or across availability zones. For more information, see the [SAP S/4HANA reference architecture](../../guide/sap/sap-s4hana.md#availability-considerations).

##### Load Balancer

[Load Balancer](https://azure.microsoft.com/blog/azure-load-balancer-new-distribution-mode) is a layer 4 network transmission service. In cluster configurations, Load Balancer directs traffic to the primary service instance or to a healthy node during a fault. Use [Load Balancer](/azure/load-balancer/load-balancer-overview) for SAP scenarios because it offers security and blocks outgoing traffic from the back-end pool, unless you turn on [outbound connectivity to public endpoints](/azure/sap/workloads/high-availability-guide-standard-load-balancer-outbound-connections). For outbound connectivity, you can use [Azure NAT Gateway](/azure/nat-gateway/nat-overview). Load Balancer is zone-aware when you deploy SAP workloads in Azure availability zones.

##### Web Dispatcher

SAP Web Dispatcher serves as an HTTP(S) load balancer for SAP traffic across SAP application servers. To achieve [HA](https://help.sap.com/docs/SAP_NETWEAVER_750/683d6a1797a34730a6e005d1e8de6f22/489a9a6b48c673e8e10000000a42189b.html) for Web Dispatcher, Load Balancer implements either a failover cluster or a parallel Web Dispatcher. For more information, see [SAP Web Dispatcher](https://help.sap.com/docs/SAP_NETWEAVER_750/683d6a1797a34730a6e005d1e8de6f22/488fe37933114e6fe10000000a421937.html).

Web Dispatcher offers extra-layer services, known as layer 7 services, for TLS termination and other offloading functions.

You don't need another load balancer for SAP GUI traffic from clients that connect to an SAP server by using DIAG protocol or RFC. Central Services balances the load by using [logon groups](https://help.sap.com/docs/SUPPORT_CONTENT/si/3362959490.html) in the SAP application server.

To address security concerns in internet-facing communications, use a stand-alone solution in a perimeter network.

You can install SAP Web Dispatcher in the ASCS instance. If you choose this option, SAP installs [Integrated Web Dispatcher](https://help.sap.com/docs/SLTOOLSET/00b4e4853ef3494da20ebcaceb181d5e/2e708e2d42134b4baabdfeae953b24c5.html) within the ASCS instance, so you don't need a separate Web Dispatcher instance or dedicated resources. Size the instance to account for the extra workload on ASCS.

##### Central Services

To protect [ASCS HA](/azure/sap/workloads/planning-supported-configurations#high-availability-for-sap-central-service) on Azure Linux VMs, use a high-availability extension (HAE) for Linux. HAEs deliver Linux clustering software and OS-specific integration components for implementation.

To avoid a cluster split-brain problem, set up cluster node fencing by using an Internet Small Computer Systems Interface fencing block device. Alternatively, use an [Azure fence agent](/azure/sap/workloads/high-availability-guide-rhel-pacemaker).

##### Other application servers in the application servers tier

To achieve HA for SAP primary application servers and other application servers, load-balance traffic in the application servers pool.

#### Backup

Use Backup to protect VM contents for SAP ASCS and application servers. Backup provides independent, isolated backups that help guard against accidental data loss. Backups are stored in a [Recovery Services vault](/azure/backup/backup-azure-recovery-services-vault-overview) that manages recovery points. Backup offers quick configuration and scaling, optimized backups, and data restoration.

Database-tier backup varies depending on whether SAP HANA is deployed on [VMs](./run-sap-hana-for-linux-virtual-machines.yml).

#### DR

Azure supports multiple [DR solutions](/azure/sap/workloads/planning-supported-configurations#disaster-recovery-scenario) depending on your requirements. SAP application servers don't store business data, so you can create them in a secondary region before you shut them down. Schedule or manually replicate SAP application server software updates and configuration changes to the DR environment. You can also deploy a VM in the DR region to run Central Services, which doesn't store business data.

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

SAP uses User Management Engine to control role-based access and authorization within SAP applications and databases. For more information, see the
[Security guide SAP BW/4HANA](https://help.sap.com/docs/SAP_BW4HANA/d3b558c9e49d4eb495c99c63a0ae549a/4f0b56878a585f86e10000000a42189b.html).

The [SAP S/4HANA reference architecture](../../guide/sap/sap-s4hana.md#security-considerations) includes other SAP BW/4HANA infrastructure security considerations.

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

Business service reliability, performance, and operability determine how you construct an IT solution. Use these metrics to scale a solution up or down in the following component categories:

- **Compute.** Analyze compute resource consumption in business-critical periods and adjust VM size to align with demand. To further reduce compute overhead, turn off unnecessary application servers during low-usage periods, such as overnight.

- **Storage.** Configure backup retention policies to remove or archive older backup images to lower-cost storage tiers, such as cool storage.

- **Networking.** SAP BW/4HANA systems typically interact with other SAP systems. Plan how data moves between systems and design the virtual network to optimize data transmission cost. For more information about cost optimization and virtual network design, see [Architecture best practices for Virtual Network](/azure/well-architected/service-guides/virtual-network).

- **Business continuity and DR.** To reduce recovery costs, use [Site Recovery](/azure/site-recovery/site-recovery-overview) to replicate VM disks in a recovery region or zone without a standby VM.

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

#### Monitoring

To maximize the availability and performance of applications and services, use [Azure Monitor](/azure/azure-monitor/fundamentals/overview). Azure Monitor includes Azure Monitor Logs and Application Insights to collect and analyze telemetry. It can help you maximize the performance and availability of your cloud and on-premises resources and applications. You can use Azure Monitor to monitor infrastructure and application anomalies, send alerts to admins, and automate reactions to predefined conditions.

To learn how Azure Monitor for SAP can help you manage the availability and performance of SAP services, see [Azure Monitor for SAP solutions](/azure/sap/monitor/about-azure-monitor-sap-solutions). Azure Monitor for SAP provides initial metrics and telemetry for monitoring. Metric definitions are stored as SQL queries in JSON, and you can modify them to meet your requirements.

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

SAP BW/4HANA completes real-time data warehousing tasks. SAP application servers maintain continuous communication with database servers, which minimizes latency between the application VMs and the database, and improves application performance. Use disk caching and server placement to further reduce latency.

For performance-critical applications that run on a database platform, including SAP HANA, use [Ultra Disk Storage](/azure/virtual-machines/disks-enable-ultra-ssd). Review current Ultra Disk Storage capabilities to confirm that they meet your requirements, especially when you use resiliency features such as availability sets, availability zones, or cross-region replication. Alternatively, you can use [Premium SSDs](/azure/virtual-machines/windows/disks-types#premium-ssd) and turn on [Write Accelerator](/azure/virtual-machines/how-to-enable-write-accelerator) for the log volume. Write Accelerator improves write latency and it's compatible with M-series VMs.

To reduce the physical distance between application and database tiers, use a proximity placement group. [Scripts and utilities](https://github.com/Azure/SAP-on-Azure-Scripts-and-Utilities) are available on GitHub.

To optimize interserver communication, use [Accelerated Networking](https://azure.microsoft.com/blog/linux-and-windows-networking-performance-enhancements-accelerated-networking/) on supported VMs, including D/DSv2, D/DSv3, E/ESv3, F/FS, FSv2, and Ms/Mms. In all SAP implementations, Accelerated Networking is required, especially when you use Azure NetApp Files.

To achieve high I/O per second and disk-bandwidth throughput, follow [performance optimization](/azure/virtual-machines/premium-storage-performance) guidance for Azure storage layout. For example, combine multiple disks into a striped disk volume to improve I/O performance. To accelerate data retrieval, turn on the read cache for infrequently changed data.

#### Scalability

This example architecture describes a small, scalable, production-level deployment. Azure offers [a range of VM sizes](https://launchpad.support.sap.com/#/notes/1928533) for scaling up and scaling out at the SAP application layer. You can scale up or down within the same cloud deployment.

## Deploy this scenario

Use the open-source [SAP deployment automation framework](/azure/sap/automation/deployment-framework) on Azure to deploy, install, and maintain SAP environments. Use the tool to deploy SAP HANA and SAP NetWeaver with AnyDB landscapes on SAP-supported operating systems in any Azure region. The framework automates infrastructure deployment by using Terraform and configures operating systems and SAP applications by using Ansible. This approach helps you configure and manage SAP environments consistently at scale.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Ben Trinh](https://www.linkedin.com/in/bentrinh) | Principal Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [About SAP HANA database backup in Azure VMs](/azure/backup/sap-hana-database-about)
- [Azure managed disks](/azure/virtual-machines/managed-disks-overview)
- [High availability for SAP NetWeaver on Azure VMs](/azure/sap/workloads/high-availability-guide-suse-netapp-files)
- [Installation of SAP HANA on Azure VMs](/azure/sap/workloads/hana-get-started)
- [VMs in Azure](/azure/virtual-machines/overview)
- [Load Balancer documentation](/azure/load-balancer)
- [NSGs](/azure/virtual-network/network-security-groups-overview)
- [Set up DR for a multitier SAP NetWeaver app deployment](/azure/site-recovery/site-recovery-sap)
- [Use Azure to host and run SAP workload scenarios](/azure/sap/workloads/get-started)
- [Use SAP Business Warehouse connector in Power BI Desktop](/power-bi/connect-data/desktop-sap-bw-connector)
- [What is Azure Bastion?](/azure/bastion/bastion-overview)
- [What is Load Balancer?](/azure/load-balancer/load-balancer-overview)
- [What is Virtual Network?](/azure/virtual-network/virtual-networks-overview)
- [What is Power BI?](/power-bi/fundamentals/power-bi-overview)

## Related resources

- [Run a Linux VM on Azure](../n-tier/linux-vm.yml)
- [Run SAP HANA for Linux VMs in a scale-up architecture on Azure](./run-sap-hana-for-linux-virtual-machines.yml)
- [SAP S/4HANA in Linux on Azure](../../guide/sap/sap-s4hana.md)