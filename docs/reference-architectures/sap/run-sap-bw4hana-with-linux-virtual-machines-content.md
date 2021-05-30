


SAP BW/4HANA is an enterprise data warehouse solution designed for the cloud and optimized for the SAP HANA platform. The following example focuses specifically
on the SAP BW/4HANA application tier and is suitable for a small-scale production environment of SAP BW/4HANA on Azure where high availability is a priority.

This example workload also draws on the foundation of the SAP on Azure reference architectures for [SAP NetWeaver (Windows) for AnyDB on virtual machines](./sap-netweaver.yml) and [SAP S/4HANA for Linux virtual machines on Azure](./sap-s4hana.yml). A similar deployment approach is used for SAP BW/4HANA workloads in that the application layer is deployed using virtual machines that can be changed in size to accommodate your organization's needs.

The network layout has been simplified to demonstrate recommended architectural principals for an Azure enterprise deployment based on a [hub-spoke topology](../hybrid-networking/hub-spoke.yml).

> [!NOTE]
> Many deployment considerations apply when deploying SAP workloads on Azure. For more ideas and further information, see the [SAP on Azure planning and deployment checklist](/azure/virtual-machines/workloads/sap/sap-deployment-checklist).

For details about the data persistence layer, see:

- [Run SAP HANA on Azure (Large Instances)](./hana-large-instances.yml)

- [Run SAP HANA on Linux virtual machines](./run-sap-hana-for-linux-virtual-machines.yml)

## Relevant use cases

This scenario is relevant to the following use cases:

- Deployment of the SAP application layer separate from the DBMS layer

- Disaster recovery (DR) scenarios

- Deployments of the SAP application tier

## Architecture

![Reference architecture shows a set of proven practices for running SAP HANA in a high-availability, scale-up environment that supports disaster recovery on Azure](./images/sap-bw4hana.png)

### Components

This architecture makes use of the following components:

- [Azure Virtual Network](/azure/virtual-network/virtual-networks-overview) (VNet) securely connects Azure resources to each other and to an on-premises environment. In this architecture, multiple VNets are [peered together](/azure/virtual-network/virtual-network-peering-overview).

- [Linux virtual machines](/azure/virtual-machines/workloads/sap/get-started) are used for the application tier, including the SAP BusinessObjects (BOBJ) server pool, the SAP Web Dispatcher pool, the application servers pool, and the SAP Central Services cluster.

- [Availability sets](/azure/virtual-machines/windows/tutorial-availability-sets) group two or more virtual machines across Azure host clusters to achieve high availability and a higher [service-level agreement](https://azure.microsoft.com/support/legal/sla/virtual-machines) (SLA).

- [Availability Zones](/azure/virtual-machines/workloads/sap/sap-ha-availability-zones) improve workload availability by distributing its servers across more than one datacenter within an Azure region.

- [Load balancers](/azure/load-balancer/) direct traffic to virtual machines in the application subnet. For high availability, this example uses [SAP Web Dispatcher](https://help.sap.com/saphelp_nwce72/helpdata/en/48/8fe37933114e6fe10000000a421937/content.htm?no_cache=true) and [Azure Standard Load Balancer](/azure/load-balancer/load-balancer-overview). These two services also support capacity extension by scaling out, or you can use Azure Application Gateway or other partner products, depending on the traffic type and required functionality you need, such as Secure Sockets Layer (SSL) termination and forwarding.

- [Network security groups](/azure/virtual-network/security-overview) (NSGs) attach to a subnet or to the network interface cards (NICs) on a virtual machine and are used to restrict incoming, outgoing, and intra-subnet traffic in the virtual network.

- [Azure Bastion](/azure/bastion/bastion-overview) provides secure access through the Azure portal to virtual machines running in Azure without the use of a jumpbox and its associated public IP address, thereby limiting internet-facing exposure.

- [Azure Managed Disks.](/azure/virtual-machines/windows/managed-disks-overview) Premium or Ultra storage disks are recommended. These storage types provide data persistence for virtual machines with the SAP workload.

- [Azure NetApp Files](/azure/virtual-machines/workloads/sap/high-availability-guide-suse-netapp-files) supports shared storage when using a cluster or when you need high-performance storage capable of hosting SAP HANA data and log files. Its a fully managed and scalable enough to meet the demands of most applications. It gives bare-metal performance, sub-millisecond latency, and integrated data management for your complex enterprise workloads on SAP HANA, high-performance computing, LOB applications, high-performance file shares, and virtual desktop infrastructure.

- [Power BI](/power-bi/fundamentals/power-bi-overview) enables users to access and visualize SAP BW/4HANA data from their Windows desktop. Note that installation requires the [SAP BW Connector](/power-bi/desktop-sap-bw-connector) (implementation 2.0).

- [Azure Backup](/azure/virtual-machines/workloads/sap/sap-hana-backup-guide) is an SAP Backint-certified data protection solution for SAP HANA in single-instance and scale-up deployments. Azure Backup also protects Azure Virtual Machines with general workloads.

- [Azure Site Recovery](/azure/site-recovery/site-recovery-sap) is recommended as part of an automated disaster recovery solution for a multitier SAP NetWeaver application deployment. The [support matrix](/azure/site-recovery/azure-to-azure-support-matrix) details the capabilities and restrictions of this solution.

- [Microsoft Power BI Desktop](/power-bi/connect-data/desktop-sap-bw-connector) imports data from various SAP sources, such as SAP BW/4HANA, for analysis and visualization. Power BI also complements SAP BusinessObjects Universe by offering a business context or a semantics layer over the raw information.

### Alternatives

- To help protect SAP global host files for SAP Central Services and the SAP transport directory, you can deploy [Network File Shares](/azure/virtual-machines/workloads/sap/high-availability-guide-suse-nfs) (NFS) servers in a failover cluster configuration.

- [SIOS Protection Suite](https://us.sios.com/solutions/cloud-high-availability/azure/), available in Azure Marketplace, can be used to protect the global host files for Central Services instead of NFS or Azure NetApp Files.

- [Azure Application Gateway](/azure/application-gateway/features) is a web traffic load balancer that provides SSL termination, a Web Application Firewall (WAF) service, and other handy high-availability and scalability features—all in one service. Some SAP deployments have used it as a [gateway for the SAP Fiori front end](https://www.linkedin.com/pulse/internet-facing-sap-fiori-access-azure-firewall-gateway-apparao-sanam/) in their production landscape.

## Recommendations

This architecture is designed for high availability, scalability, and resilience. For the best results on Azure, consider the recommendations in this section. In addition, many of the recommendations for running SAP S/4HANA on Azure also apply to SAP BW/4HANA deployments. For details about SAP S/4HANA on Azure, see the [reference architecture](./sap-s4hana.yml).

### Virtual machines

For details about SAP support for Azure virtual machine types and throughput metrics (SAPS), see [SAP Note 1928533](https://launchpad.support.sap.com/#/notes/1928533), “SAP Applications on Azure: Supported Products and Azure Virtual Machine Types.” (To access this and other SAP notes, an SAP Service Marketplace account is required.)

For information about whether a virtual machine type has been certified for scale-out deployments of SAP HANA, see the “Scale-out” column in the [SAP HANA Hardware Directory](https://www.sap.com/dmc/exp/2014-09-02-hana-hardware/enEN/iaas.html#categories=Microsoft%20Azure).

### Application servers pool

In application servers pool, you can adjust the number of virtual machines based on your requirements. [Azure is certified](/azure/virtual-machines/workloads/sap/sap-certifications) to run SAP BW/4HANA on Red Hat Enterprise Linux and SUSE Linux Enterprise.

To manage logon groups for ABAP application servers, it’s common to use the SMLG transaction to load-balance logon users, SM61 for batch server groups, RZ12 for RFC groups, and more. These transactions use the load-balancing capability within the message server of Central Services to distribute incoming sessions or workload among SAP application servers pool for SAP GUIs and RFC traffic.

### SAP Central Services cluster

This example depicts a highly available cluster that uses Azure NetApp Files as a shared file storage solution. High availability for the Central Services cluster requires shared storage, and NetApp Files provides a simple option so you don’t have to deploy the Linux cluster infrastructure. An alternative is to set up a highly available [NFS service](/azure/virtual-machines/workloads/sap/high-availability-guide-suse#setting-up-a-highly-available-nfs-server).

You can also deploy Central Services to a single virtual machine with Premium managed disks and get a 99.9-percent availability [SLA](https://azure.microsoft.com/support/legal/sla/virtual-machines/v1_9/).

The virtual machines used for the application servers support multiple IP addresses per NIC. This feature supports the SAP recommended practice of using
virtual host names for installations as outlined in [SAP Note 962955](https://launchpad.support.sap.com/#/notes/962955). Virtual host names decouple the SAP services from the physical host names and make it easier to migrate services from one physical host to another. This principal also applies to cloud virtual machines.

Application servers are connected to the highly available Central Services on Azure through the virtual host names of the Central Services or ERS services. These host names are assigned to the cluster front-end IP configuration of the load balancer. A load balancer supports multiple front-end IPs, so both the Central Services and ERS virtual IPs (VIPs) can be bound to one load balancer.

#### Multi-SID installation

Azure also supports high availability in a [multi-SID installation](/azure/virtual-machines/workloads/sap/sap-ascs-ha-multi-sid-wsfc-shared-disk) of the Linux and Windows clusters that host Central Services (ASCS/SCS). For details about deploying to a Pacemaker cluster, see the Azure multi-SID documentation for [Windows](/azure/virtual-machines/workloads/sap/sap-ascs-ha-multi-sid-wsfc-shared-disk), [Red Hat Linux](/azure/virtual-machines/workloads/sap/high-availability-guide-rhel-multi-sid), or [SUSE Linux](/azure/virtual-machines/workloads/sap/high-availability-guide-suse-multi-sid).

#### Proximity placement groups

This example architecture also uses a [proximity placement group](/azure/virtual-machines/workloads/sap/sap-proximity-placement-scenarios)
to reduce network latency between virtual machines. This type of group places a location constraint on virtual machine deployments and minimizes the physical distance between them. The group’s placement varies as follows:

- In a single SID installation, you should place all Central Services and application servers in the proximity placement group anchored by the SAP HANA database.

- In a multi-SID installation, you have the freedom to associate the Central Services and application servers with any proximity placement group (but just one) that is anchored by SAP HANA containers of different SIDs.

### Database

SAP BW/4HANA is designed for the SAP HANA database platform. Azure provides three scalability and deployment options:

- [In a scale-up SAP HANA deployment](./run-sap-hana-for-linux-virtual-machines.yml), the database tier uses two or more Linux
    virtual machines in a cluster to achieve high availability.

- A [scale-out deployment of SAP HANA](/azure/virtual-machines/workloads/sap/sap-planning-supported-configurations#sap-hana-scale-out-scenarios) is supported for some virtual machine types.

- [Azure Large Instances](./hana-large-instances.yml) for SAP HANA, Revision 4, are special-purpose physical servers, certified to meet SAP HANA Tailored Datacenter Integration (TDI) standards, and located in a Microsoft Azure datacenter.

### Storage

This example uses [Premium managed disks](/azure/virtual-machines/windows/disks-types#premium-ssd)
for the non-shared storage of the application servers and [Azure NetApp Files](/azure/virtual-machines/workloads/sap/high-availability-guide-suse-nfs) for cluster shared storage.

Standard managed disks are not supported, as stated in [SAP Note 1928533](https://launchpad.support.sap.com/#/notes/1928533). The use of standard storage is not recommended for any SAP installations.

For the backup data store, we recommend using Azure [cool and archive access tiers](/azure/storage/blobs/storage-blob-storage-tiers). These storage tiers are cost-effective ways to store long-lived data that is infrequently accessed.

## Networking

Although not required, a [hub-spoke topology](../hybrid-networking/hub-spoke.yml) is commonly deployed to provide logical isolation and security boundaries for an SAP landscape. For other networking details, refer to the [SAP S/4HANA reference architecture](./sap-s4hana.yml).

The hub VNet acts as a central point of connectivity to an on-premises network. The spokes are VNets that [peer](/azure/virtual-network/virtual-network-peering-overview) with the hub, and they can be used to isolate workloads. Traffic flows between the on-premises datacenter and the hub through a gateway connection.

Most customer implementations include one or more ExpressRoute circuits connecting on-premises networks to Azure. For less network bandwidth demand, VPN is a lower cost alternative.

## Performance

SAP BW/4HANA is designed for real-time data warehousing tasks. SAP application servers carry on constant communications with the database servers, so minimizing latency from the application virtual machines to the database contributes to better application performance. Disk caching and server placement are two strategies that help reduce latency between these two components.

For performance-critical applications running on any database platforms, including SAP HANA, use [Premium managed disks](/azure/virtual-machines/windows/disks-types#premium-ssd) and enable [Write Accelerator](/azure/virtual-machines/windows/how-to-enable-write-accelerator) for the log volume. Write Accelerator is available for M-series virtual machines and improves write latency. However, when available, use [Ultra managed disks](/azure/virtual-machines/linux/disks-enable-ultra-ssd) in place of Premium disks without Write Accelerator. Ultra disk capabilities continue to evolve. To see if these disks meet your requirements, review the latest information about the service scope of [ultra disks](/azure/virtual-machines/linux/disks-enable-ultra-ssd), especially if your implementation includes Azure resiliency features such as availability sets, Availability Zones, and cross-region replication.

To help performance by reducing the physical distance between the applications and database, use a proximity placement group, as mentioned earlier. [Scripts and utilities](https://github.com/msftphleiten/proximity-placement-groups) are available on GitHub.

To optimize inter-server communications, use [Accelerated Networking](https://azure.microsoft.com/blog/linux-and-windows-networking-performance-enhancements-accelerated-networking/), which is available for supported virtual machines, including D/DSv2, D/DSv3, E/ESv3, F/FS, FSv2, and Ms/Mms. In all SAP implementations, Accelerated Networking is required—especially when Azure NetApp Files is used.

To achieve high IO per second and disk bandwidth throughput, the common practices in storage volume [performance optimization](/azure/virtual-machines/linux/premium-storage-performance) apply to Azure storage layout. For example, combining multiple disks together to create a striped disk volume improves IO performance. Enabling the read cache on storage content that changes infrequently enhances the speed of data retrieval.

## Scalability

This example architecture describes a small, production-level deployment with the flexibility to scale based on your requirements.

At the SAP application layer, Azure offers a wide range of virtual machine sizes for scaling up and scaling out. For an inclusive list, see [SAP Note 1928533](https://launchpad.support.sap.com/#/notes/1928533). As we continue to certify more virtual machines types, you can scale up or down in the same cloud deployment.

## Availability

Resource redundancy is the general theme in highly available infrastructure solutions. If your organization has a less stringent SLA, use single-instance virtual machines with Premium disks, which offer an [uptime SLA](https://buildazure.com/2016/11/24/single-instance-vms-now-with-99-9-sla/).

To maximize application availability, you can deploy redundant resources in an availability set or across [Availability Zones](/azure/virtual-machines/workloads/sap/sap-ha-availability-zones). For more information, refer to the [SAP S/4HANA reference architecture](./sap-s4hana.yml#availability-considerations).

This architecture places virtual machines that perform the same role into an availability set. This configuration helps meet [SLAs](https://azure.microsoft.com/support/legal/sla/virtual-machines) by guarding against downtime caused by Azure infrastructure maintenance and unplanned outages. Two or more virtual machines per availability set are required to get a higher SLA.

### Azure Load Balancer

[Azure Load
Balancer](https://azure.microsoft.com/blog/azure-load-balancer-new-distribution-mode/) is a network transmission layer service (layer 4) and is used in cluster setups to direct traffic to the primary service instance or the healthy node in case of a fault. We recommend using [Azure Standard Load Balancer](/azure/load-balancer/load-balancer-standard-overview) for all SAP scenarios because it offers by-design security implementation and blocks outgoing traffic from the back-end pool unless you enable [outbound connectivity to public endpoints](/azure/virtual-machines/workloads/sap/high-availability-guide-standard-load-balancer-outbound-connections).

Also, if you elect to deploy SAP workloads in [Azure Availability Zones](/azure/virtual-machines/workloads/sap/sap-ha-availability-zones), the Standard Load Balancer is zone-aware.

### Web Dispatcher

This sample design shows the use of the SAP Web Dispatcher simply as an HTTP(s) load-balancing mechanism for SAP traffic among the SAP application servers. To achieve [high availability](https://help.sap.com/viewer/683d6a1797a34730a6e005d1e8de6f22/7.5.4/489a9a6b48c673e8e10000000a42189b.html?q=parallel%20web%20dispatcher) for the Web Dispatcher component, Azure Load Balancer implements either the failover cluster or the parallel Web Dispatcher setup. See [SAP Web Dispatcher](https://help.sap.com/doc/saphelp_nw70ehp2/7.02.16/48/8fe37933114e6fe10000000a421937/frameset.htm) in the SAP documentation.

As a software load balancer, Web Dispatcher offers application layer services (referred to as *layer 7* in the ISO networking model) capable of SSL termination and other offloading functions.

For traffic from SAP GUI clients connecting an SAP server via DIAG protocol or Remote Function Calls (RFC), the Central Services message server balances the load through SAP application server [logon groups](https://wiki.scn.sap.com/wiki/display/SI/ABAP+Logon+Group+based+Load+Balancing).
No additional load balancer is needed.

The Web Dispatcher component is used as a load balancer for SAP traffic among the SAP application servers. To achieve [high availability of the SAP Web Dispatcher](https://help.sap.com/doc/saphelp_nw73ehp1/7.31.19/en-US/48/9a9a6b48c673e8e10000000a42189b/frameset.htm), Azure Load Balancer implements either the failover cluster or the parallel Web Dispatcher setup.

For internet facing communications a stand-alone solution in DMZ would be the recommended architecture to satisfy security concerns.

[Embedded Web Dispatcher](https://help.sap.com/viewer/00b4e4853ef3494da20ebcaceb181d5e/LATEST/en-US/2e708e2d42134b4baabdfeae953b24c5.html) on ASCS is a special option, and proper sizing due to additional workload on ASCS should be taken into account.

### Central Services

To protect the [availability of SAP Central Services](/azure/virtual-machines/workloads/sap/sap-planning-supported-configurations#high-availability-for-sap-central-service) (ASCS) on Azure Linux virtual machines, you must use the appropriate high availability extension (HAE) for your selected Linux distribution. HAE delivers Linux clustering software and OS-specific integration components for implementation.

To avoid a cluster split-brain problem, you can set up cluster node fencing using an iSCSI STONITH Block Device (SBD), as this example shows, or the [Azure Fence Agent](/azure/virtual-machines/workloads/sap/high-availability-guide-rhel-pacemaker). The improved Azure Fence Agent provides significantly faster service failover compared to the previous version of the agent for Red Hat and SUSE environments.

### Other application servers in the application servers tier

For the SAP primary application servers and any additional application servers, high availability is achieved by load balancing traffic within the pool of application servers.

## Disaster recovery

Azure supports a variety of [disaster recovery
options](/azure/virtual-machines/workloads/sap/sap-planning-supported-configurations#disaster-recovery-scenario)
depending on your requirements. SAP application servers do not contain business data, so a simple strategy is to create SAP application servers in a secondary region and then shut them down. SAP application server software updates and configuration changes should be replicated to the disaster recovery side either manually or on a schedule. You can build a virtual machine in the disaster recovery region to run the Central Services role, which also does not persist business data. For details, refer to the [SAP S/4HANA reference architecture](./sap-s4hana.yml).

## Monitoring

To maximize the availability and performance of applications and services, use [Azure Monitor](/azure/azure-monitor/overview), a comprehensive solution for collecting, analyzing, and acting on telemetry from your cloud and on-premises environments.

To provide SAP-based monitoring of resources and service performance of the SAP infrastructure, use the [Azure SAP Enhanced Monitoring](/azure/virtual-machines/workloads/sap/deployment-guide#d98edcd3-f2a1-49f7-b26a-07448ceb60ca) extension. For details, see [SAP Note 2191498](https://launchpad.support.sap.com/#/notes/2191498), “SAP on Linux with Azure: Enhanced Monitoring.”

[Azure Monitor](/azure/azure-monitor/overview), which now includes Azure Log Analytics and Azure Application Insights, provides sophisticated tools for collecting and analyzing telemetry so you can maximize the performance and availability of your cloud and on-premises resources and applications. Azure Monitor can be used to monitor and alert administrators of infrastructure and application anomalies and to automate reactions to predefined conditions.
 
To provide SAP-based monitoring of resources and service performance of the SAP infrastructure, use the [Azure SAP Enhanced Monitoring](/azure/virtual-machines/workloads/sap/deployment-guide) extension. This extension feeds Azure monitoring statistics into the SAP application for operating system monitoring and DBA Cockpit functions. SAP enhanced monitoring is a mandatory prerequisite to run SAP on Azure. For details, see [SAP note 2191498](https://launchpad.support.sap.com/#/notes/2191498) – "SAP on Linux with Azure: Enhanced Monitoring." (To access the SAP notes, you must have an SA Service Marketplace account.)
 
The future direction for an Azure-native, end-to-end monitoring solution for SAP BW/4HANA is [Azure Monitor for SAP](/azure/virtual-machines/workloads/sap/azure-monitor-overview). Note that this is currently inPublic Preview and is only available in a limited set of regions, so you should carefully evaluate if it meets your requirements.
 
Azure Monitor for SAP provides a comprehensive initial set of metrics and telemetry for monitoring, and the metric definitions are stored as SQL queries in JSON and can be modified to meet your requirements. The starting set of metrics is available on GitHub [here](https://github.com/Azure/AzureMonitorForSAPSolutions/blob/master/sapmon/content/SapHana.json).

## Backup

For the SAP ASCS and application servers, we recommend using Azure Backup to protect the virtual machine contents. Azure Backup provides independent, isolated backups to help guard against accidental destruction of original data. Backups are stored in a [Recovery Services vault](/azure/backup/backup-azure-recovery-services-vault-overview) that offers built-in management of recovery points. Configuration and scalability are simple, backups are optimized, and you can easily restore as needed.

Backup of the database tier varies depending on whether SAP HANA is deployed on [virtual machines](./run-sap-hana-for-linux-virtual-machines.yml) or [Azure Large Instances](./hana-large-instances.yml). See the [management and operations considerations](./run-sap-hana-for-linux-virtual-machines.yml) for SAP HANA on Linux virtual machines.

## Security

SAP has its own User Management Engine (UME) to control role-based access and authorization within the SAP application and databases. For details, see the
[Security Guide SAP BW∕4HANA](https://help.sap.com/viewer/d3b558c9e49d4eb495c99c63a0ae549a/1.0.4/en-US).

The [SAP S/4HANA reference architecture](./sap-s4hana.yml#security-considerations) provides additional infrastructure security considerations that apply to SAP BW/4HANA.
