---
title: Run SAP HANA for Linux virtual machines in a scale-up architecture on Azure
description: This reference architecture shows a set of proven practices for running SAP HANA in a high-availability, scale-up environment that supports disaster recovery on Azure. 
author: maggsl
ms.date: 06/05/2020
ms.topic: reference-architecture
ms.service: architecture-center
ms.category:
  - databases  
ms.subservice: reference-architecture
ms.custom: SAP, Windows
---

# Run SAP HANA for Linux virtual machines in a scale-up architecture on Azure

This reference architecture shows a set of proven practices for running SAP HANA
in a high-availability, scale-up environment that supports disaster recovery on
Azure. This implementation focuses on the database layer and is designed to
support various SAP applications, such as S/4HANA and SAP BW/4HANA.

![Reference architecture for SAP BW/4HANA](./images/sap-hana-scaleup.png)

**NOTE:** Deploying this reference architecture requires appropriate licensing
of SAP products and other non-Microsoft technologies.

## Architecture

This reference architecture describes a common production system. You can choose
the virtual machine sizes to accommodate your organization's needs. This
configuration can also be reduced to a single virtual machine.

The architecture includes the following components:

**Azure Virtual Network (VNet).** The
[VNet](https://docs.microsoft.com/azure/virtual-network/virtual-networks-overview)
service securely connects Azure resources to each other. In this architecture, a
VNet connects to an on-premises environment through a gateway deployed in the
hub of a [hub-spoke
topology](https://docs.microsoft.com/azure/architecture/reference-architectures/hybrid-networking/hub-spoke).
The spoke is the VNet used for the SAP applications and the database tiers.

**SAP HANA.** For high availability, SAP HANA runs on two or more Linux virtual
machines. SAP HANA System Replication (HSR) is used to replicate data between
the primary and secondary (replica) SAP HANA systems. HSR is also used for
cross-region or cross-zone disaster recovery.

**Availability sets.** Virtual machines providing the same service are grouped
into a highly available [availability
set](https://docs.microsoft.com/azure/virtual-machines/windows/tutorial-availability-sets)
for a higher [service-level
agreement](https://azure.microsoft.com/support/legal/sla/virtual-machines)
(SLA). For even higher availability, consider [Availability
Zones](https://docs.microsoft.com/azure/virtual-machines/workloads/sap/sap-ha-availability-zones).

**Load balancers.** To direct traffic to virtual machines in the database tier,
[Azure Standard Load
Balancer](https://docs.microsoft.com/azure/load-balancer/load-balancer-overview)
is used. This option supports [Availability
Zones](https://docs.microsoft.com/azure/load-balancer/load-balancer-standard-availability-zones)
for scenarios that need higher application availability (not shown in this
architecture).

**Network security groups.** To restrict incoming, outgoing, and intra-subnet
traffic in the virtual network, you can define [network security
groups](https://docs.microsoft.com/azure/virtual-network/security-overview)
(NSGs) for subnets or individual virtual machines.

**Storage.** Azure Premium managed disks provide the recommend storage for the
SAP executables and the SAP HANA data and logs. Other [storage
configurations](https://docs.microsoft.com/azure/virtual-machines/workloads/sap/hana-vm-operations-storage)
are available, such as Ultra disk and Azure NetApp Files.

## Recommendations

This architecture describes a small, production-level deployment that can scale
up in the number and size of virtual machines, based on your business
requirements. These recommendations are intended as a starting point.

### SAP HANA

SAP HANA is deployed on virtual machines in this reference architecture. Azure
offers single-node scale up to 11.5 terabytes (TB) on virtual machines and
single-node scale up to 24 TB on [Azure Large
Instances](https://docs.microsoft.com/azure/architecture/reference-architectures/sap/hana-large-instances).
The [SAP Certified and Supported SAP HANA Hardware
Directory](https://www.sap.com/dmc/exp/2014-09-02-hana-hardware/enEN/iaas.html#categories=Microsoft%20Azure)
lists the virtual machines that are certified for the SAP HANA database. For
details about SAP support for virtual machine types and throughput metrics
(SAPS), see [SAP Note
1928533](https://launchpad.support.sap.com/#/notes/1928533). (To access this and
other SAP notes, an SAP Service Marketplace account is required.)

Microsoft and SAP jointly certify a range of virtual machine sizes for SAP HANA
workloads. For example, smaller deployments can run on an M-series virtual
machine with 192 GB of RAM. To support the largest SAP HANA memory sizes on
virtual machines—up to 11.5 TB—you can use the [Azure M-series
v2](https://docs.microsoft.com/azure/virtual-machines/mv2-series) (Mv2) virtual
machines. The M208 virtual machine types achieve approximately 260,000 SAPS, and
the M416 virtual machine types achieve approximately 488,000 SAPS.

The physical distance between the application and database tiers can impact
performance, especially for SAP applications that require frequent communication
with the database. We recommend using Azure [proximity placement
groups](https://docs.microsoft.com/azure/virtual-machines/workloads/sap/sap-proximity-placement-scenarios)
for virtual machines deployed in availability sets. Proximity placement groups
ensure that the virtual machines reside in the same datacenter to minimize
application latency (but note that Azure Site Recovery does not support the
replication of virtual machines in proximity placement groups). [Scripts and
utilities](https://github.com/msftphleiten/proximity-placement-groups) are
available on GitHub.

### Load balancer

We recommend using the Standard Load Balancer and enabling [high availability
ports](https://docs.microsoft.com/azure/load-balancer/load-balancer-ha-ports-overview).
This setup avoids the need to configure load-balancing rules for many SAP ports.
With [Standard Load
Balancer](https://docs.microsoft.com/azure/load-balancer/load-balancer-overview#why-use-azure-load-balancer),
you can also create a high availability solution across [Azure Availability
Zones](https://docs.microsoft.com/azure/availability-zones/az-overview).
Alternatively, you can use Azure Basic Load Balancer—it’s offered at no charge
but does not support zones and has no SLA.

For SAP HANA database clusters, you must enable Direct Server Return (DSR), also
known as Floating IP. This feature allows the server to respond to the IP
address of the load balancer front end. This direct connection keeps the load
balancer from becoming the bottleneck in the path of data transmission. If
virtual machines in the back-end pool require public outbound connectivity,
additional
[configuration](https://docs.microsoft.com/azure/virtual-machines/workloads/sap/high-availability-guide-standard-load-balancer-outbound-connections)
is required.

### Networking

We recommend using a [hub-spoke
topology](https://docs.microsoft.com/azure/architecture/reference-architectures/hybrid-networking/shared-services),
where the hub VNet acts as a central point of connectivity to an on-premises
network. The spokes are VNets that peer with the hub, and they can be used to
isolate workloads. Traffic flows between the on-premises datacenter and the hub
through a gateway connection.

#### Availability Zones

As mentioned, you can increase application availability by using [Availability
Zones](https://docs.microsoft.com/azure/virtual-machines/workloads/sap/sap-ha-availability-zones).

#### Subnets and NSGs

The database subnet includes an NSG that defines access policies for all the
virtual machines within this subnet. To control the flow of traffic between the
servers in a subnet, set up NSGs using either the [Azure
portal](https://docs.microsoft.com/azure/virtual-network/tutorial-filter-network-traffic),
[PowerShell](https://docs.microsoft.com/azure/virtual-network/tutorial-filter-network-traffic-powershell),
or [Azure
CLI](https://docs.microsoft.com/azure/virtual-network/tutorial-filter-network-traffic-cli).

For added control, you can also associate the SAP HANA subnet with [application
security
groups](https://docs.microsoft.com/azure/virtual-network/application-security-groups).

## Performance considerations

This implementation uses Azure managed disks. To achieve high input/output
operations per second (IOPS) and disk bandwidth throughput, the common practices
in storage volume [performance
optimization](https://docs.microsoft.com/azure/virtual-machines/linux/premium-storage-performance)
also apply to Azure storage layout. For example, combining multiple disks
together to create a striped disk volume improves IO performance, although if
you later resize the virtual machines, you may need a corresponding change to
the disk configuration.

Enabling the read cache on storage content that changes infrequently enhances
the speed of data retrieval. See also recommendations about [storage
configurations](https://docs.microsoft.com/azure/virtual-machines/workloads/sap/hana-vm-operations-storage)
for various virtual machine sizes when running SAP HANA.

To meet the intensive IOPS and transfer bandwidth demands of SAP HANA, [ultra
disk
storage](https://docs.microsoft.com/azure/virtual-machines/linux/disks-enable-ultra-ssd)
provides the best IO performance. You can dynamically change the performance of
ultra disks and independently configure metrics like IOPS and MB/s without
rebooting your virtual machine.

For details about SAP HANA performance requirements, see [SAP Note 1943937](https://launchpad.support.sap.com/#/notes/1943937), "Hardware Configuration Check Tool."

**Note:** As specified in [SAP Note
2731110](https://launchpad.support.sap.com/#/notes/2731110), do not place any
network virtual appliance (NVA) in between the application and the database
layers for any SAP application stack. Doing so introduces significant data
packets processing time and unacceptably slows application performance.

## Scalability considerations

This architecture runs SAP HANA on virtual machines that can scale up to 11.5 TB
in one instance.

If your workload exceeds the maximum virtual machine size, Microsoft offers
[Azure Large
Instances](https://docs.microsoft.com/azure/virtual-machines/workloads/sap/hana-overview-architecture)
for SAP HANA. Rev. 4 of these physical servers is located in an Azure datacenter
and, as of this writing, provides up to 24 TB of memory capacity for a single
instance.

A multi-node configuration is also possible with a total memory capacity of up
to 48 TB for online transaction processing (OLTP) applications and 96 TB for
online analytical processing (OLAP) applications. For example, you can deploy
SAP HANA in a scale-out configuration with standby on virtual machines—running
either [Red Hat Enterprise
Linux](https://docs.microsoft.com/azure/virtual-machines/workloads/sap/sap-hana-scale-out-standby-netapp-files-rhel)
or [SUSE Linux Enterprise
Server](https://docs.microsoft.com/azure/virtual-machines/workloads/sap/sap-hana-scale-out-standby-netapp-files-suse)—using
[Azure NetApp
Files](https://docs.microsoft.com/azure/azure-netapp-files/azure-netapp-files-introduction/)
for the shared storage volumes.

## Availability considerations

This reference architecture depicts a highly available SAP HANA database system
consisting of two virtual machines. The database tier's SAP HANA native system
replication feature provides either manual or automatic failover between
replicated nodes:

- For manual failover, deploy more than one SAP HANA instance and use SAP HSR.

- For automatic failover, use both HSR and Linux High Availability Extension
    (HAE) for your Linux distribution. Linux HAE provides the Pacemaker cluster
    services to the SAP HANA resources, detecting failure events and
    orchestrating the failover of errant services to the healthy node.

For SAP HANA high availability on Linux, create a [Pacemaker
cluster](https://docs.microsoft.com/azure/virtual-machines/workloads/sap/sap-hana-high-availability-rhel#create-a-pacemaker-cluster).
This option is available for both [SUSE Linux Enterprise
Server](https://docs.microsoft.com/azure/virtual-machines/workloads/sap/high-availability-guide-suse-pacemaker)
and [Red Hat Enterprise
Linux](https://docs.microsoft.com/azure/virtual-machines/workloads/sap/high-availability-guide-rhel-pacemaker).

This architecture uses Linux clustering to detect system failures and facilitate
automatic failover. A storage-based or cloud-based fencing mechanism ensures
that a failed system is isolated or shut down to avoid a cluster split-brain
condition.

## Disaster recovery considerations

In this architecture, HSR is used for database replication to a database
instance in the secondary region. It’s optional to use a cluster in the
secondary region, but doing so can improve SAP HANA availability after a
disaster recovery failover.

In addition to a local, two-node high availability implementation, HSR supports
multi-tier and
[multitarget](https://help.sap.com/viewer/6b94445c94ae495c83a19646e7c3fd56/2.0.03/ba457510958241889a459e606bbcf3d3.html)
replication, allowing for inter-zone and inter-region replication. Multitarget
replication is available for SAP HANA 2.0 SPS 03 and later.

Disaster recovery failover is a manual process.

### Virtual network peering

To support disaster recovery in this architecture, virtual networks in the
secondary region have their traffic directed over ExpressRoute to the
on-premises gateway and then routed back to Azure, destined for services in the
primary region.

You can also use [virtual network
peering](https://docs.microsoft.com/azure/architecture/reference-architectures/hybrid-networking/hub-spoke),
where multiple virtual networks are [peered
together](https://docs.microsoft.com/azure/virtual-network/virtual-network-peering-overview)
to provide network segmentation and isolation for the services deployed on
Azure. Through network peering, services in disparate networks in one region can
connect with each other. Global network peering bridges virtual networks in
remote regions.

### Azure NetApp Files

As an option, [Azure NetApp
Files](https://docs.microsoft.com/azure/virtual-machines/workloads/sap/hana-vm-operations-storage)
can be used to provide a scalable and high-performance storage solution for SAP
HANA data and log files. It’s also a good solution for Linux cluster shared
storage—for example, when building Pacemaker clusters for (A)SCS. Azure NetApp
Files makes it easy to provision file shares for Linux workloads without the
effort of deploying an NFS file server, and it helps simplify the SAP landscape.

Azure NetApp Files supports snapshots for fast backup, recovery, and local
replication. For cross-region content replication, you can use the [NetApp Cloud
Sync
Service](https://azuremarketplace.microsoft.com/marketplace/apps/netapp.cloud-sync-service?tab=Overview),
rsync, or another copy function.

### Azure Site Recovery

You can use [Azure Site
Recovery](https://docs.microsoft.com/azure/site-recovery/site-recovery-sap)
to automatically replicate your production configuration in a secondary
location. Then, to extend your recovery plans, you can use customized
[deployment
scripts](https://docs.microsoft.com/azure/site-recovery/site-recovery-runbook-automation).
For example, Site Recovery first deploys the virtual machines in availability
sets and then runs your custom scripts to attach the existing (prebuilt) load
balancer (which already has the back-end pool defined), to the network interface
card (NIC) of the failover virtual machines. An example of the custom Site
Recovery Automation Runbooks script is available on
[GitHub](https://github.com/Azure/azure-quickstart-templates/tree/master/asr-automation-recovery).

**NOTE:** As of this writing, Site Recovery does not support the replication of
virtual machines in proximity placement groups. Make sure to verify your target
region’s [resource
capacity](https://docs.microsoft.com/azure/site-recovery/azure-to-azure-common-questions#capacity).
Like all Azure services, Site Recovery continues to add features and
capabilities. For the latest information about Azure-to-Azure replication, see
the [support
matrix](https://docs.microsoft.com/azure/site-recovery/azure-to-azure-support-matrix).

## Management and operations considerations

### Backup

SAP HANA data can be backed up in many ways. After migrating to Azure, you can
continue to use any existing partner backup solutions you already have. Azure
provides two native approaches to backup—[SAP HANA file-level
backup](https://docs.microsoft.com/azure/virtual-machines/workloads/sap/sap-hana-backup-file-level)
and Azure Backup for SAP HANA over the Backint interface.

For SAP HANA file-level backup, you can use your tool of choice, such as hdbsql
or SAP HANA Studio, and store the backup files on a local disk volume. A common
mount point for this backup volume is /hana/backup. Your backup policies will
define the data retention period on the volume. As soon as the backup is taken,
a scheduled task should copy the backup files to Azure Blob storage for
safekeeping. The local backup files are kept for expedient recovery.

Azure Backup offers a simple, enterprise-grade solution for workloads running on
virtual machines. [Azure Backup for SAP
HANA](https://docs.microsoft.com/azure/virtual-machines/workloads/sap/sap-hana-backup-guide)
provides full integration with the SAP HANA backup catalog and guarantees
database-consistent, full or point-in-time recoveries. Azure Backup is
[BackInt-certified](https://nam06.safelinks.protection.outlook.com/?url=https%3A%2F%2Fwww.sap.com%2Fdmc%2Fexp%2F2013_09_adpd%2FenEN%2F%23%2Fd%2Fsolutions%3Fid%3D8f3fd455-a2d7-4086-aa28-51d8870acaa5&data=02%7C01%7Cv-nanra%40microsoft.com%7C464909a9e6814c7df8b708d7b00b3076%7C72f988bf86f141af91ab2d7cd011db47%7C0%7C0%7C637171434407652805&sdata=4I57ZoGuqRVi0ffx8QaSs9rXZyzX0xEzY%2BkzkuXneKk%3D&reserved=0)
by SAP. See also the [Azure Backup
FAQ](https://docs.microsoft.com/azure/backup/backup-azure-backup-faq).

### Monitoring

To monitor your workloads on Azure, [Azure
Monitor](https://docs.microsoft.com/azure/azure-monitor/overview) offers a
comprehensive solution for collecting, analyzing, and acting on telemetry from
your cloud and on-premises environments.

To provide SAP-based monitoring of resources and service performance of the SAP
infrastructure, the [Azure SAP Enhanced
Monitoring](https://docs.microsoft.com/azure/virtual-machines/workloads/sap/deployment-guide#d98edcd3-f2a1-49f7-b26a-07448ceb60ca)
Extension is used. This extension feeds Azure monitoring statistics into the SAP
application for operating system monitoring and DBA Cockpit functions. SAP
enhanced monitoring is a mandatory prerequisite for running SAP on Azure. For
details, see [SAP Note
2191498](https://launchpad.support.sap.com/#/notes/2191498), “SAP on Linux with
Azure: Enhanced Monitoring.”

## Security considerations

Many security measures are used to protect the confidentiality, integrity, and
availability of an SAP landscape. For example, to secure user access, SAP has
its own User Management Engine (UME) to control role-based access and
authorization within the SAP application and databases. For details, see [SAP
HANA Security—An Overview](https://archive.sap.com/documents/docs/DOC-62943).

For data at rest, encryption provides security as follows:

- Along with the SAP HANA native encryption technology, consider using an
    encryption solution from a partner that supports customer-managed keys.

- To encrypt virtual machine disks, you can use [Azure Disk
    Encryption](https://docs.microsoft.com/azure/virtual-machines/linux/disk-encryption-overview).
    The solution also works with Azure Key Vault to help you control and manage
    the disk-encryption keys and secrets in your key vault subscription.

- Data in Azure physical storage is automatically encrypted at rest with an
    Azure-managed key.

**NOTE:** Do not use the SAP HANA data-at-rest encryption with Azure Disk
Encryption on the same storage volume. Also, operating system boot disks for
Linux virtual machines do not support Azure Disk Encryption, nor does Site
Recovery yet support Azure Disk Encryption-attached data disks on Linux.

## Communities

Communities can answer questions and help you set up a successful deployment.
Consider the following:

- [Azure Forum](https://azure.microsoft.com/support/forums/)

- [SAP Community](https://www.sap.com/community.html)

- [Stack Overflow SAP](http://stackoverflow.com/tags/sap/info)
