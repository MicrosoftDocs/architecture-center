[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]
 
This solution uses Azure virtual machines (VMs) to replicate the behavior of an on-premises Distributed File System (DFS) Namespace failover cluster. 

## Architecture

:::image type="content" border="false" source="../media/dfs-azure-vms.svg" alt-text="Diagram that shows how to deploy a DFS Namespaces failover cluster." lightbox="../media/dfs-azure-vms.svg":::

*Download a [Visio file](https://arch-center.azureedge.net/dfs-azure-vms.vsdx) of this architecture.*

### Dataflow
 
1. The client sends a request to the Domain Name System (DNS) in order to reach the destination path.
1. The DNS has the authority to resolve the request.
1. The DNS sends the response back to the client.
1. The client sends the request to the destination IP that it received from the DNS.
1. The load balancer, taking into account health probe results, exposes the requested resource.

### Components
 
* [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines). VMs run as workers, performing compute tasks. In this architecture, there are three VMs in a virtual network. Two of them are failover cluster VMs. The other one is dedicated to cluster management. The VMs use two shared disks. One is a quorum disk, and the other one is dedicated to the DFS Namespaces share.
* [Azure Disk Storage](https://azure.microsoft.com/products/storage/disks). Designed for use with Azure Virtual Machines and Azure VMware Solution, Azure Disk Storage delivers high-performance, high-durability block storage for mission-critical applications.
* [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network). Virtual Network provides IP connectivity between the compute resources and the other cloud services, beyond what any native InfiniBand or RDMA communication provides.
* [Azure Load Balancer](https://azure.microsoft.com/products/load-balancer). Load balancing is the process of evenly distributing incoming network traffic across a group of back-end resources or servers. This standard load balancer is the entry point for client requests.
 
## Scenario details

This solution uses Azure VMs to replicate the behavior of an on-premises DFS Namespace failover cluster. It provides all the traditional components of a failover system. DFS Namespaces is a role service in Windows Server that you can use to group shared folders that are located on different servers into one or more logically structured namespaces. You can use it to give users a virtual view of shared folders. These elements make up a DFS namespace:

- **Namespace server.** A namespace server hosts a namespace. The namespace server can be a member server or a domain controller.
- **Namespace root.** The namespace root is the starting point of the namespace, for example, `\\contoso.com\documentation`.
- **Folder.** Folders enable you to create the structure and hierarchy for a namespace. When users browse a folder that has folder targets in the namespace, the client computer receives a referral that transparently redirects the client computer to the folder targets.
- **Folder targets.** A folder target is the UNC path of a shared folder or another namespace that's associated with a folder in a namespace.
 
Servers that run the following operating systems can host multiple domain-based namespaces in addition to a single standalone namespace:

- Windows Server 2022
- Windows Server 2019
- Windows Server 2016
- Windows Server 2012 R2
- Windows Server 2012
- Windows Server 2008 R2 Datacenter and Enterprise editions
- Windows Server Semi-Annual Channel

There are various ways to create a high-availability environment. One possibility is to add a [second namespace server](/windows-server/storage/dfs-namespaces/add-namespace-servers-to-a-domain-based-dfs-namespace) in another availability zone or region. You can [deploy the second namespace server on Azure](/azure/virtual-machines/windows/quick-create-portal). 

For disaster recovery, another approach is to provide protection for your instances by using [Azure Site Recovery](/azure/site-recovery/site-recovery-overview). With Azure Site Recovery, you can provide protection for your workloads to help ensure business continuity by using a native disaster recovery strategy.

Failover clusters use a voting system with a quorum to determine failover and to prevent split-brain conditions, in which the system can't determine which hosts should run which workloads. In the cluster, the quorum is defined as half the total nodes. After a fault, the nodes vote on whether to stay online. If fewer nodes than the number defined by the quorum vote yes, the nodes are removed. 

This solution uses a quorum system that's based on a quorum disk. Another approach is to use a [cloud witness](/windows-server/failover-clustering/deploy-cloud-witness), a quorum witness that uses Azure to provide a vote on cluster quorum. A cloud witness solution uses [Azure Blob Storage](https://azure.microsoft.com/products/storage/blobs) to read or write to a blob file in the same way that quorum disks are used for split-brain resolution. 

Azure assigns IP addresses to VMs dynamically when it creates the VMs. The DHCP service is automatically provided by Azure for each subnet, so you don't need to run a DHCP service on a VM. 

Running a DHCP service in a virtual network [isn't supported](/azure/virtual-network/virtual-networks-faq#what-protocols-can-i-use-within-vnets). Therefore, you need to assign an IP address for the role. For a failover cluster, you need to assign an IP address for the cluster DFS namespace shared roles. This IP address is the public IP address for the load balancer that's used in the solution. In this solution, when a client attempts to reach the share, the next hop is the load balancer.

### Potential use cases
 
You can use DFS Namespaces to easily distribute shared folders in your organization via a centralized point of management. For more information, see [2.5.2 DFS Use Cases](/openspecs/windows_protocols/ms-fsmod/b9527bb7-5280-4901-bc9b-97513996955a).

## Recommendations
 
If you're ready to migrate your services to modernize your infrastructure, you can move your [DFS Namespaces by using Azure Files](/azure/storage/files/files-manage-namespaces?tabs=azure-portal).

## Example

For scenarios where Universal Naming Convention (UNC) paths need to be kept, see our [example in GitHub](https://github.com/Azure/dfs-namespace-cluster-examples/blob/main/dfs-namespace-cluster-example.md).

## Contributors
 
*This article is maintained by Microsoft. It was originally written by the following contributors.*
 
Principal author:
 
- [Tommaso Sacco](https://www.linkedin.com/in/tommasosaccoit) | CSA-E Azure Core

Other contributor:

- [Marcos Motta](https://www.linkedin.com/in/marcos-augusto-motta-dos-santos-junior-b8b17328/) | Cloud Solution Architect
- [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414) | Technical Writer
 
*To see non-public LinkedIn profiles, sign in to LinkedIn.* 

## Next steps
 
- [DFS Namespaces overview](/windows-server/storage/dfs-namespaces/dfs-overview)
- [Virtual machines in Azure](/azure/virtual-machines/overview)
- [What is Azure Virtual Network?](/azure/virtual-network/virtual-networks-overview)
 
## Related resources
 
* [Networking architecture design](../../guide/networking/networking-start-here.md)
* [Build applications on the Microsoft Cloud](../../guide/microsoft-cloud/overview.md)
* [Storage architecture design](../../guide/storage/storage-start-here.md)
* [Run a Windows VM on Azure](../../reference-architectures/n-tier/windows-vm.yml)
