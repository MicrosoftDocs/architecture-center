[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This solution architecture illustrates how a user request flows through an SAP landscape that's built on high-performance Azure Virtual Machines and an in-memory HANA database, which runs on HANA Large Instances for unparalleled scalability and performance.

## Potential use cases

This system takes advantage of OS clustering for database performance, high availability using HANA system replication, and a full disaster recovery (DR) configuration for guaranteed system availability.

## Architecture

![Architecture diagram shows Front-end route, through Primary Azure Region to OS Clustering, to DR storage replication in DR Azure Region.](../media/sap-s4-hana-on-hli-with-ha-and-dr.svg)

*Download a [Visio file](https://arch-center.azureedge.net/sap-s4-hana-on-hli-with-ha-and-dr.vsdx) of this architecture.*

### Dataflow

1. In this example, an on-premises SAP user executes a sales order via Fiori interface, custom interface, or other.
1. Azure high-speed ExpressRoute gateway is used to connect to Azure Virtual Machines.
1. Request flows into highly available ABAP SAP Central Services (ASCS) and then through application servers, which run on Azure Virtual Machines. This availability set offers a 99.95 percent uptime SLA.
1. Request is sent from App Server to SAP HANA running on primary large instance blades.
1. Primary and secondary blades are clustered at OS level for 99.99 percent availability, and data replication is handled through HANA System Replication in synchronous mode (HSR) from primary to secondary enabling zero RPO.
1. In-memory data of SAP HANA is persisted to high-performance NFS storage.
1. Data from NFS storage is periodically backed up in seconds, using built-in storage snapshots on the local storage, with no impact to database performance.
1. Persistent data volume on secondary storage is replicated to dedicated DR system through a dedicated backbone network for HANA storage replication.
1. Large instance on DR side can be used for nonproduction to save costs by mounting both the QA storage and DR replicated volume (read-only).

### Components

* [SAP HANA on Azure Large Instances](https://azure.microsoft.com/services/virtual-machines/sap-hana): SAP HANA on Azure (Large Instances) runs on dedicated blade servers located in a Microsoft Azure datacenter. This feature is specific to the database server.
* [NFS storage for Azure HANA large instances](https://azure.microsoft.com/services/storage/files): The Azure high-performance NFS storage system offers the unmatched capability to perform snapshot backups, and replication to secondary storage.  In addition, HANA Large Instances are the only cloud infrastructure to provide storage volume encryption.
* SAP on Azure requires that you run your SAP workloads on certified Microsoft Azure [Virtual Machines](https://azure.microsoft.com/services/virtual-machines). SAP requires at least two vCPUs and a ratio of 6:1 between memory and vCPU.
* Microsoft Azure [Premium Storage](https://azure.microsoft.com/services/storage/disks) provides improved throughput and less variability in I/O latencies. For improved performance, [Premium Storage](https://azure.microsoft.com/services/storage/disks) uses solid-state disk (SSD) in Azure Storage nodes and read cache that's backed by the local SSD of an Azure compute node.
* [ExpressRoute (front end)](https://azure.microsoft.com/services/expressroute): Azure ExpressRoute used on the front end (see diagram) provides secure, high-bandwidth connectivity to establish reliable connections between your network and the Microsoft Azure network.
* [ExpressRoute (back end)](https://azure.microsoft.com/services/expressroute): Azure ExpressRoute used on the back end (see diagram) enables you to communicate between your Azure components in the Azure Datacenter and your SAP HANA on Azure (Large Instances) systems. The cost of the back-end ExpressRoute is included in your SAP HANA on Azure (Large Instances).

## Next steps

* [Getting started](/azure/virtual-machines/workloads/sap/get-started)
* [High-performance NFS storage for SAP HANA Large Instances](/azure/virtual-machines/workloads/sap/hana-overview-architecture)
* [SAP Certifications for Azure](/azure/virtual-machines/workloads/sap/sap-certifications)
* [Premium Storage: high-performance storage for Azure Virtual Machine workloads](/azure/storage/storage-premium-storage)
* [ExpressRoute overview](https://azure.microsoft.com/services/expressroute)
* [Back end Network to HANA Large Instances](/azure/virtual-machines/workloads/sap/hana-overview-architecture)
