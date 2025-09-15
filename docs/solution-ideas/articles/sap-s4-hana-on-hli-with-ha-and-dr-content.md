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
1. Primary and secondary blades are clustered at OS level for 99.99 percent availability, and data replication is handled through HANA System Replication (HSR) in synchronous mode from primary to secondary enabling zero RPO.
1. In-memory data of SAP HANA is persisted to high-performance NFS storage.
1. Data from NFS storage is periodically backed up in seconds, using built-in storage snapshots on the local storage, with no impact to database performance.
1. Persistent data volume on secondary storage is replicated to dedicated DR system through a dedicated backbone network for HANA storage replication.
1. Large instance on DR side can be used for nonproduction to save costs by mounting both the QA storage and DR replicated volume (read-only).

### Components

* [SAP HANA on Azure Large Instances](/azure/sap/large-instances/hana-overview-architecture) is a dedicated bare-metal infrastructure service that runs SAP HANA on dedicated blade servers. In this architecture, it serves as the high-performance, in-memory database layer for SAP workloads. It enables scalability and availability through OS-level clustering and HANA System Replication.
* [NFS storage for Azure HANA Large Instances](/azure/sap/workloads/planning-guide-storage-azure-files) is a high-performance NFS optimized for SAP workloads. In this architecture, it persists in-memory data from SAP HANA and supports rapid snapshot backups and encrypted volume replication to secondary storage. HANA Large Instances uniquely provide storage volume encryption as part of their high-performance NFS storage system.
* [Azure Virtual Machines](/azure/well-architected/service-guides/virtual-machines) is an infrastructure as a service (IaaS) offering that provides scalable compute resources. In this architecture, virtual machines host SAP application servers and central services, which ensures high availability and compliance with SAP performance requirements. SAP on Azure requires you to run SAP workloads on certified Microsoft Azure virtual machines. SAP also requires at least two vCPUs and a 6:1 ratio between memory and vCPU.
* [Azure Premium SSD](/azure/well-architected/service-guides/azure-disk-storage) is a high-performance disk storage option for Azure virtual machines. In this architecture, [Premium SSD](/azure/virtual-machines/disks-types) improves input/output (I/O) throughput and reduce latency variability for SAP workloads by using solid-state drives (SSDs) in Azure Storage nodes and a read cache that's backed by the local SSD of an Azure compute node.
* [ExpressRoute (front end)](/azure/well-architected/service-guides/azure-expressroute) provides private, high-bandwidth connectivity between on-premises networks and Azure. In this architecture, it securely connects SAP users to Azure-hosted SAP services, which ensures reliable and low-latency access.
* [ExpressRoute (back end)](/azure/well-architected/service-guides/azure-expressroute) enables private communication between Azure components and SAP HANA Large Instances. In this architecture, it supports internal data flows and replication across the Azure datacenter and SAP infrastructure, with costs included in the SAP HANA service.

## Next steps

* [Getting started](/azure/virtual-machines/workloads/sap/get-started)
* [High-performance NFS storage for SAP HANA Large Instances](/azure/virtual-machines/workloads/sap/hana-overview-architecture)
* [SAP Certifications for Azure](/azure/virtual-machines/workloads/sap/sap-certifications)
* [Premium Storage: high-performance storage for Azure Virtual Machine workloads](/azure/storage/storage-premium-storage)
* [ExpressRoute overview](https://azure.microsoft.com/services/expressroute)
* [Back end Network to HANA Large Instances](/azure/virtual-machines/workloads/sap/hana-overview-architecture)
