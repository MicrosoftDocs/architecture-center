This architecture demonstrates a way to provide file shares in the cloud to on-premises users and applications that also access files on Windows Server.

## Architecture

:::image type="content" source="media/azure-files-on-premises-authentication.svg" alt-text="Azure architecture to provide desktops, both on-premises and cloud-based, for a company with many branches." border="false" lightbox="media/azure-files-on-premises-authentication.svg":::

*Download a [Visio file](https://arch-center.azureedge.net/US-1893117-azure-files-on-premises-authentication.vsdx) of this architecture.*

### Workflow

1. This solution synchronizes the on-premises AD DS and the cloud-based Azure AD. Synchronizing makes users more productive by providing a common identity for accessing both cloud and on-premises resources.

   Azure AD Connect is the on-premises Microsoft application that does the synchronizing. For more information about Azure AD Connect, see [What is Azure AD Connect?](/azure/active-directory/hybrid/whatis-azure-ad-connect) and [Azure AD Connect sync: Understand and customize synchronization](/azure/active-directory/hybrid/how-to-connect-sync-whatis).
1. Azure Virtual Network provides a virtual network in the cloud. For this solution, it has at least two subnets, one for Azure DNS, and one for a private endpoint to access the file share.
1. Either VPN or Azure ExpressRoute provides secure connections between the on-premises network and the virtual network in the cloud. If you use VPN, create a gateway by using Azure VPN Gateway. If you use ExpressRoute, create an ExpressRoute virtual network gateway. For more information, see [What is VPN Gateway?](/azure/vpn-gateway/vpn-gateway-about-vpngateways) and [About ExpressRoute virtual network gateways](/azure/expressroute/expressroute-about-virtual-network-gateways).
1. Azure Files provides a file share in the cloud. This requires an Azure Storage account. For more information about file shares, see [What is Azure Files?](/azure/storage/files/storage-files-introduction).
1. A private endpoint provides access to the file share. A private endpoint is like a network interface card (NIC) inside a subnet that attaches to an Azure service. In this case, the service is the file share. For more information about private endpoints, see [Use private endpoints for Azure Storage](/azure/storage/common/storage-private-endpoints).
1. The on-premises DNS server resolves IP addresses. However, Azure DNS resolves the Azure file share Fully Qualified Domain Name (FQDN). All DNS queries to Azure DNS originate from the virtual network. There's a DNS proxy inside the virtual network to route these queries to Azure DNS. For more information, see [On-premises workloads using a DNS forwarder](/azure/private-link/private-endpoint-dns#on-premises-workloads-using-a-dns-forwarder).

   You can provide the DNS proxy on a Windows or Linux server, or you can use Azure Firewall. For information on the Azure Firewall option, which has the advantage that you don't have to manage a virtual machine, see [Azure Firewall DNS settings](/azure/firewall/dns-settings).
1. The on-premises custom DNS is configured to forward DNS traffic to Azure DNS via a conditional forwarder. Information on conditional forwarding is also found in [On-premises workloads using a DNS forwarder](/azure/private-link/private-endpoint-dns#on-premises-workloads-using-a-dns-forwarder).
1. The on-premises AD DS authenticates access to the file share. This is a four-step process, as described in [Part one: enable AD DS authentication for your Azure file shares](/azure/storage/files/storage-files-identity-ad-ds-enable)

### Components

- [Azure Storage](https://azure.microsoft.com/product-categories/storage) is a set of massively scalable and secure cloud services for data, apps, and workloads. It includes [Azure Files](https://azure.microsoft.com/services/storage/files), [Azure Table Storage](https://azure.microsoft.com/services/storage/tables), and [Azure Queue Storage](https://azure.microsoft.com/services/storage/queues).
- [Azure Files](https://azure.microsoft.com/services/storage/files) offers fully managed file shares in an Azure Storage account. The files are accessible from the cloud or on-premises. Windows, Linux, and macOS deployments can mount Azure file shares concurrently. File access uses the industry standard Server Message Block (SMB) protocol.
- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network) is the fundamental building block for private networks in Azure. It provides the environment for Azure resources, such as virtual machines, to securely communicate with each other, with the internet, and with on-premises networks.
- [Azure ExpressRoute](https://azure.microsoft.com/services/expressroute) extends on-premises networks into the Microsoft cloud over a private connection.
- [Azure VPN Gateway](https://azure.microsoft.com/services/vpn-gateway) connects on-premises networks to Azure through site-to-site VPNs, in much the same way as you connect to a remote branch office. The connectivity is secure and uses the industry-standard protocols Internet Protocol Security (IPsec) and Internet Key Exchange (IKE).
- [Azure Private Link](https://azure.microsoft.com/services/private-link) provides private connectivity from a virtual network to Azure platform as a service (PaaS), customer-owned, or Microsoft partner services. It simplifies the network architecture and secures the connection between endpoints in Azure by eliminating data exposure to the public internet.
- A private endpoint is a network interface that uses a private IP address from your virtual network. You can use private endpoints for your Azure Storage accounts to allow clients on a virtual network to access data over a private link.
- [Azure Firewall](https://azure.microsoft.com/services/azure-firewall) is a managed, cloud-based network security service that protects your Azure Virtual Network resources. It's a fully stateful firewall as a service with built-in high availability and unrestricted cloud scalability. You can configure Azure Firewall to act as a DNS proxy. A DNS proxy is an intermediary for DNS requests from client virtual machines to a DNS server.

## Scenario details

Consider the following common situation. An on-premises Windows Server provides files to users and applications. Windows Server Active Directory Domain Services (AD DS) secures the files, and there's an on-premises DNS server. Everything is on the same private network.

Now suppose that the need arises to have file shares in the cloud.

The architecture that's described here shows how to use Azure to satisfy this need, and how to do it at low cost, and by continuing to use the on-premises network, AD DS, and DNS.

In this architecture, Azure Files provides the file share. Site-to-site VPN or Azure ExpressRoute provides secure connections between the on-premises network and Azure virtual network. Users and applications use the connections to access the files. Azure Active Directory (Azure AD) and Azure DNS cooperate with on-premises AD DS and DNS to secure the access.

In short, if you're in the described situation, you can provide cloud files to your on-premises users at low cost, and continue to provide secure file access with your on-premises AD DS and DNS.

### Potential use cases

- The file server moves to the cloud, but the users must remain on-premises.
- Applications that are migrated to the cloud need to access on-premises files, and also files that are migrated to the cloud.
- You need to reduce costs by moving file storage to the cloud.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

Reliability ensures that your application can meet the commitments that you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

- Azure Storage always stores multiple copies of your data in the same zone, so that it's protected from planned and unplanned outages. There are options for creating additional copies in other zones or regions. For more information, see [Azure Storage redundancy](/azure/storage/common/storage-redundancy).
- Azure Firewall has built-in high availability. For more information, see [Azure Firewall Standard features](/azure/firewall/features).

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

These articles have security information for Azure components:

- [Azure security baseline for Azure Storage](/security/benchmark/azure/baselines/storage-security-baseline)
- [Azure security baseline for Azure Private Link](/security/benchmark/azure/baselines/private-link-security-baseline)
- [Azure security baseline for Virtual Network](/security/benchmark/azure/baselines/virtual-network-security-baseline)
- [Azure security baseline for Azure Firewall](/security/benchmark/azure/baselines/firewall-security-baseline)

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

To estimate the cost of Azure products and configurations, use the Azure [Pricing calculator](https://azure.microsoft.com/pricing/calculator).

These articles have pricing information for Azure components:

- [Azure Files pricing](https://azure.microsoft.com/pricing/details/storage/files)
- [Azure Private Link pricing](https://azure.microsoft.com/pricing/details/private-link)
- [Virtual Network pricing](https://azure.microsoft.com/pricing/details/virtual-network)
- [Azure Firewall pricing](https://azure.microsoft.com/pricing/details/azure-firewall)

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

- Your Azure Storage accounts contain all of your Azure Storage data objects, including file shares. A storage account provides a unique namespace for its data, a namespace that's accessible from anywhere in the world over HTTP or HTTPS. For this architecture, your storage account contains file shares that are provided by Azure Files. For best performance, we recommend the following:
  - Don't put databases, blobs, and so on, in storage accounts that contain file shares.
  - Have no more than one highly active file share per storage account. You can group file shares that are less active into the same storage account.
  - Use SSD-based storage rather than HDD. For more information about the scalability and performance of file shares, see [Azure Files scalability and performance targets](/azure/storage/files/storage-files-scale-targets).
  - Don't select a general-purpose v1 storage account, because it lacks important features. The storage account types are described in [Storage account overview](/azure/storage/common/storage-account-overview).
  - Pay attention to size, speed, and other limitations. For this information, refer to [Azure subscription and service limits, quotas, and constraints](/azure/azure-resource-manager/management/azure-subscription-service-limits).
- There's little you can do to improve the performance of non-storage components, except to be sure that your deployment honors the limits, quotas, and constraints that are described in [Azure subscription and service limits, quotas, and constraints](/azure/azure-resource-manager/management/azure-subscription-service-limits).
- For scalability information for Azure components, see [Azure subscription and service limits, quotas, and constraints](/azure/azure-resource-manager/management/azure-subscription-service-limits).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Rudnei Oliveira](https://www.linkedin.com/in/rudnei-r-oliveira-69443523) | Senior Customer Engineer

## Next steps

- [Quickstart: Create a virtual network using the Azure portal](/azure/virtual-network/quick-create-portal)
- [What is VPN Gateway?](/azure/vpn-gateway/vpn-gateway-about-vpngateways)
- [Tutorial: Create and manage a VPN gateway using Azure portal](/azure/vpn-gateway/tutorial-create-gateway-portal)
- [Azure enterprise cloud file share](/azure/architecture/hybrid/azure-files-private)
- [Azure Virtual Network concepts and best practices](/azure/virtual-network/concepts-and-best-practices)
- [Planning for an Azure Files deployment](/azure/storage/files/storage-files-planning)
- [Use private endpoints for Azure Storage](/azure/storage/common/storage-private-endpoints)
- [Azure Private Endpoint DNS configuration](/azure/private-link/private-endpoint-dns)
- [Azure Firewall DNS settings](/azure/firewall/dns-settings)
- [Compare self-managed Active Directory Domain Services, Azure Active Directory, and managed Azure Active Directory Domain Services](/azure/active-directory-domain-services/compare-identity-solutions)

## Related resources

- [Hybrid file share with disaster recovery for remote and local branch workers](hybrid-file-share-dr-remote-local-branch-workers.yml)
- [Azure enterprise cloud file share](../../hybrid/azure-files-private.yml)
- [Using Azure file shares in a hybrid environment](../../hybrid/azure-file-share.yml)
- [Hybrid file services](../../hybrid/hybrid-file-services.yml)
