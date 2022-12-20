[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]
 
This article describes how to deploy a Distributed File System (DFS) Namespaces failover cluster by using Azure virtual machines (VMs).

## Architecture

image

*Download a [Visio file](https://arch-center.azureedge.net/dfs-azure-vms.vsdx) of this architecture.*

### Dataflow
 
1. The client sends a request to DNS in order to reach the destination path.
1. The DNS have the authority to resolve the request.
1. DNS response was sent back to the client.
1. The client sends the request to the destination IP received from the DNS.
1. The load balancer, in according to the health probe availability, expose the requested resource.

### Components
 
* [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines) runs as workers, performing the compute tasks. Creation of three Azure VMs in a virtual network, 2 of those are involved as failover cluster vms, the other one is dedicated for the cluster management.The Azure Virtual Machines will use 2 shared disks. one as a quorum disk, the other one is dedicated for the DFS Namespaces share.
* [Azure Disks](https://azure.microsoft.com/products/storage/disks) Designed for use with Azure Virtual Machines and VMware's Azure Solution (premiere), Azure Disk Storage delivers high-performance, high durability block storage for your mission-critical applications.
* [Virtual Network](https://azure.microsoft.com/services/virtual-network) provides IP connectivity between the compute resources and the other cloud services, above and beyond any native Infiniband or RDMA communication.
* [Azure Load Balancer](https://azure.microsoft.com/products/load-balancer/#overview) Load balancing refers to evenly distributing load (incoming network traffic) across a group of backend resources or servers. This Load Balancer Standard is entry point for the clients request.
 
## Scenario details
 
The goal of this proposed solution is to **replicate** with Azure Services the behavior of a DFS Namespace failover cluster on-premises using all the **classic components of a failover system**. DFS (Distributed File System) Namespaces is a role service in Windows Server that enables you to group shared folders located on different servers into one or more logically structured namespaces. Is useful to give users a virtual view of shared folders. Here's a description of the elements that make up a DFS namespace:

- **Namespace server** - A namespace server hosts a namespace. You can place the Namespace server as a member server or a domain controller in your organization.
- **Namespace root** - The namespace root is the starting point of the namespace, for example \\\\contoso.com\\documentation.
- **Folder** - Thanks to folder you can create the structure and hierarchy for the namespace. When users browse a folder that has folder targets in the namespace, the client computer receives a referral that transparently redirects the client computer to the folder targets.
- **Folder targets** - A folder target is the UNC path of a shared folder or another namespace that is associated with a folder in a namespace.
 
Servers that are running the following operating systems can host multiple domain-based namespaces in addition to a single stand-alone namespace.

- Windows Server 2022
- Windows Server 2019
- Windows Server 2016
- Windows Server 2012 R2
- Windows Server 2012
- Windows Server 2008 R2 Datacenter and Enterprise Editions
- Windows Server (Semi-Annual Channel)

### Potential use cases
 
Thanks to the DFS Namespace we can distribute in easiest way shared folders in our organization with a single centralized point of management. More information about use cases [here](https://learn.microsoft.com/openspecs/windows_protocols/ms-fsmod/b9527bb7-5280-4901-bc9b-97513996955a).

## Considerations
 
In order to obtain an **High Availability** Environment we can achieve this goal in different way. One possibility is to add a [second namespace server][https://learn.microsoft.com/windows-server/storage/dfs-namespaces/add-namespace-servers-to-a-domain-based-dfs-namespace] in another availability zone or region. You can deploy the **second namespace server** in [azure][https://learn.microsoft.com/en-us/azure/virtual-machines/windows/quick-create-portal]. 

For disaster recovery purpose another approach is to protect our instances with [Azure Site Recovery][https://learn.microsoft.com/azure/site-recovery/site-recovery-overview]. With our **Azure Site Recovery** solution, we can protect our workload in Azure to ensure business continuity with a native disaster recovery strategy supported in Azure.

Failover clusters works with **vote**. uses a voting system with quorum to determine failover and to prevent a split-brain condition. In the cluster, the quorum is defined as half of the total nodes. **After a fault, the nodes vote to stay online. If less than the quorum amount votes yes, those nodes are removed**. In the proposed solution is used a quorum system based on **quorum disk**. Another approach following is to use a [Cloud Witness][https://learn.microsoft.com/en-us/windows-server/failover-clustering/deploy-cloud-witness] for a Failover Cluster, a Microsoft native services as arbitration point. **Cloud Witness** solution uses Azure Blob Storage to read/write a blob file in the same way how quorum disk are used in case of split-brain resolution. 

Azure assigns IP to virtual machines dynamically during the creation.  For failover purpose the cluster, need to assign an IP for the cluster DFS Namespace shared roles. Running a DHCP Service in Azure [isn't supported](https://learn.microsoft.com/azure/virtual-network/virtual-networks-faq#what-protocols-can-i-use-within-vnets). The DHCP service is provided by Azure for each subnet automatically. There's no need to run a DHCP service on a VM. Therefore, it's necessary to assign an IP for the role and this IP will be the public IP for the load balancer used in the solution. Following this solution, when a client try to reach the share the next hope will be the load balancer that dynamically.
 
## Recommendations
 
If you are ready to migrate our services in Azure with the purpose to **modernize the infrastructure** with all the new Azure services we can move our [DFS Namespaces using Azure Files][https://learn.microsoft.com/azure/storage/files/files-manage-namespaces?tabs=azure-portal].

## Contributors
 
*This article is maintained by Microsoft. It was originally written by the following contributors.*
 
Principal author:
 
 * [Tommaso Sacco](https://www.linkedin.com/in/tommasosaccoit/) | CSA-E Azure Core

line 

## Next steps
 
* Learn more about [DFS Namespaces overview](https://learn.microsoft.com/windows-server/storage/dfs-namespaces/dfs-overview)
 
## Related resources
 
* [Networking](/docs/guide/networking/networking-start-here.md)
* [Microsoft Cloud](/docs/guide/microsoft-cloud/overview.md)
* [Storage](/docs/guide/storage/storage-start-here.md)
