This architecture demonstrates one way to provide file shares in the cloud to on-premises users and applications that access files on Windows Server through a private endpoint.

## Architecture

:::image type="content" source="media/azure-files-on-premises-authentication.svg" alt-text="Azure architecture to provide desktops, both on-premises and cloud-based, for a company with many branches." border="false" lightbox="media/azure-files-on-premises-authentication.svg":::

*Download a [Visio file](https://arch-center.azureedge.net/US-1893117-azure-files-on-premises-authentication.vsdx) of this architecture.*

### Workflow

1. This solution synchronizes the on-premises AD DS and the cloud-based Microsoft Entra ID. Synchronizing makes users more productive by providing a common identity for accessing both cloud and on-premises resources.

   Microsoft Entra Connect is the on-premises Microsoft application that does the synchronizing. For more information about Microsoft Entra Connect, see [What is Microsoft Entra Connect?](/entra/identity/hybrid/connect/whatis-azure-ad-connect) and [Microsoft Entra Connect Sync: Understand and customize synchronization](/entra/identity/hybrid/connect/how-to-connect-sync-whatis).
1. Azure Virtual Network provides a virtual network in the cloud. For this solution, it has at least two subnets, one for Azure DNS, and one for a private endpoint to access the file share.
1. Either VPN or Azure ExpressRoute provides secure connections between the on-premises network and the virtual network in the cloud. If you use VPN, create a gateway by using Azure VPN Gateway. If you use ExpressRoute, create an ExpressRoute virtual network gateway. For more information, see [What is VPN Gateway?](/azure/vpn-gateway/vpn-gateway-about-vpngateways) and [About ExpressRoute virtual network gateways](/azure/expressroute/expressroute-about-virtual-network-gateways).
1. Azure Files provides a file share in the cloud. This requires an Azure Storage account. For more information about file shares, see [What is Azure Files?](/azure/storage/files/storage-files-introduction).
1. A private endpoint provides access to the file share. A private endpoint is like a network interface card (NIC) inside a subnet that attaches to an Azure service. In this case, the service is the file share. For more information about private endpoints, see [Use private endpoints for Azure Storage](/azure/storage/common/storage-private-endpoints).
1. The on-premises DNS server resolves IP addresses. However, Azure DNS resolves the Azure file share Fully Qualified Domain Name (FQDN). All DNS queries to Azure DNS originate from the virtual network. There's a DNS proxy inside the virtual network to route these queries to Azure DNS. For more information, see [On-premises workloads using a DNS forwarder](/azure/private-link/private-endpoint-dns#on-premises-workloads-using-a-dns-forwarder).

   You can provide the DNS proxy on a Windows or Linux server, or you can use Azure Firewall. For information on the Azure Firewall option, which has the advantage that you don't have to manage a virtual machine, see [Azure Firewall DNS settings](/azure/firewall/dns-settings).
1. The on-premises custom DNS is configured to forward DNS traffic to Azure DNS via a conditional forwarder. Information on conditional forwarding is also found in [On-premises workloads using a DNS forwarder](/azure/private-link/private-endpoint-dns#on-premises-workloads-using-a-dns-forwarder).
1. The on-premises AD DS authenticates access to the file share. This is a four-step process, as described in [Part one: enable AD DS authentication for your Azure file shares](/azure/storage/files/storage-files-identity-ad-ds-enable)

### Components

- [Azure Storage](/azure/storage/common/storage-introduction) is a set of massively scalable and secure cloud services for data, apps, and workloads. It includes [Azure Files](/azure/well-architected/service-guides/azure-files), [Azure Table Storage](/azure/storage/tables/table-storage-overview), and [Azure Queue Storage](/azure/well-architected/service-guides/queue-storage/reliability). In this architecture, Azure Storage provides the underlying infrastructure for Azure Files. It hosts the cloud-based file shares that on-premises users access.
- [Azure Files](/azure/well-architected/service-guides/azure-files) is a managed file storage service that provides file shares within an Azure Storage account. The files can be accessed from the cloud or on-premises. Windows, Linux, and macOS deployments can mount Azure file shares concurrently. File access uses the industry standard Server Message Block (SMB) protocol. In this architecture, Azure Files hosts the actual file shares that on-premises Windows Server environments securely access by using AD DS authentication.
- [Azure Virtual Network](/azure/well-architected/service-guides/virtual-network) is the fundamental building block for private networks in Azure. In this architecture, it provides the environment for Azure resources, such as virtual machines, to securely communicate with each other, with the internet, and with on-premises networks.
- [Azure ExpressRoute](/azure/well-architected/service-guides/azure-expressroute) is a service that extends on-premises networks into the Microsoft cloud through a private, dedicated connection. In this architecture, ExpressRoute ensures secure and reliable connectivity for accessing Azure-based file shares from on-premises systems.
- [Azure VPN Gateway](/azure/vpn-gateway/vpn-gateway-about-vpngateways) is a networking service that connects on-premises networks to Azure by using site-to-site VPNs, similar to connecting to a remote branch office. In this architecture, it provides an alternative to ExpressRoute for securely accessing Azure Files over Internet Protocol Security (IPsec) and Internet Key Exchange (IKE) protocols.
- [Azure Private Link](/azure/private-link/private-link-overview) is a networking service that enables private connectivity from a virtual network to Azure platform as a service (PaaS), customer-owned, or Microsoft partner services. It simplifies this network architecture and secures the connection between endpoints in Azure by eliminating data exposure to the public internet.
- A private endpoint is a network interface that uses a private IP address from your virtual network. You can use private endpoints for your Azure Storage accounts to allow clients on a virtual network to access data over a private link.
- [Azure Firewall](/azure/well-architected/service-guides/azure-firewall) is a managed, cloud-based network security service that protects your Azure Virtual Network resources. It's a fully stateful firewall service that has built-in high availability and unrestricted cloud scalability. In this architecture, you can configure Azure Firewall as a DNS proxy to simplify DNS management and eliminate the need for a dedicated virtual machine. A DNS proxy serves as an intermediary for DNS requests from client virtual machines to a DNS server.

## Scenario details

Consider the following common scenario: an on-premises computer running Windows Server is used to provide file shares for users and applications. Active Directory Domain Services (AD DS) is used to help secure the files, and an on-premises DNS server manages network resources. Everything operates within the same private network.

Now assume that you need to extend file shares to the cloud.

The architecture described here demonstrates how Azure can meet this need cost-effectively while maintaining the use of your on-premises network, AD DS, and DNS.

In this setup, Azure Files is used to host the file shares. A site-to-site VPN or Azure ExpressRoute provides enhanced-security connections between the on-premises network and Azure Virtual Network. Users and applications access the files via these connections. Microsoft Entra ID and Azure DNS work together with on-premises AD DS and DNS to help ensure secure access.

In summary, if this scenario applies to you, you can provide cloud-based file shares to your on-premises users at a low cost while maintaining enhanced-security access via your existing AD DS and DNS infrastructure.

### Potential use cases

- The file server moves to the cloud, but the users must remain on-premises.
- Applications that are migrated to the cloud need to access on-premises files, and also files that are migrated to the cloud.
- You need to reduce costs by moving file storage to the cloud.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

- Azure Storage always stores multiple copies of your data in the same zone, so that it's protected from planned and unplanned outages. There are options for creating additional copies in other zones or regions. For more information, see [Azure Storage redundancy](/azure/storage/common/storage-redundancy).
- Azure Firewall has built-in high availability. For more information, see [Azure Firewall Standard features](/azure/firewall/features).

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

These articles have security information for Azure components:

- [Azure security baseline for Azure Storage](/security/benchmark/azure/baselines/storage-security-baseline)
- [Azure security baseline for Azure Private Link](/security/benchmark/azure/baselines/azure-private-link-security-baseline)
- [Azure security baseline for Virtual Network](/security/benchmark/azure/baselines/virtual-network-security-baseline)
- [Azure security baseline for Azure Firewall](/security/benchmark/azure/baselines/firewall-security-baseline)

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

To estimate the cost of Azure products and configurations, use the Azure [Pricing calculator](https://azure.microsoft.com/pricing/calculator).

These articles have pricing information for Azure components:

- [Azure Files pricing](https://azure.microsoft.com/pricing/details/storage/files)
- [Azure Private Link pricing](https://azure.microsoft.com/pricing/details/private-link)
- [Virtual Network pricing](https://azure.microsoft.com/pricing/details/virtual-network)
- [Azure Firewall pricing](https://azure.microsoft.com/pricing/details/azure-firewall)

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

- Your Azure Storage accounts contain all of your Azure Storage data objects, including file shares. A storage account provides a unique namespace for its data, a namespace that's accessible from anywhere in the world over HTTP or HTTPS. For this architecture, your storage account contains file shares that are provided by Azure Files. For best performance, we recommend the following practices:
  - Don't put databases, blobs, and so on, in storage accounts that contain file shares.
  - Have no more than one highly active file share per storage account. You can group file shares that are less active into the same storage account.
  - If your workload requires large amounts of IOPS, extremely fast data transfer speeds, or very low latency, then you should choose premium (FileStorage) storage accounts. A standard general-purpose v2 account is appropriate for most SMB file share workloads. For more information about the scalability and performance of file shares, see [Azure Files scalability and performance targets](/azure/storage/files/storage-files-scale-targets).
  - Don't use a general-purpose v1 storage account, because it lacks important features. Instead, [upgrade to a general-purpose v2 storage account](/azure/storage/common/storage-account-upgrade). The storage account types are described in [Storage account overview](/azure/storage/common/storage-account-overview).
  - Pay attention to size, speed, and other limitations. Refer to [Azure subscription and service limits, quotas, and constraints](/azure/azure-resource-manager/management/azure-subscription-service-limits).
- There's little you can do to improve the performance of non-storage components, except to be sure that your deployment honors the limits, quotas, and constraints that are described in [Azure subscription and service limits, quotas, and constraints](/azure/azure-resource-manager/management/azure-subscription-service-limits).
- For scalability information for Azure components, see [Azure subscription and service limits, quotas, and constraints](/azure/azure-resource-manager/management/azure-subscription-service-limits).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Rudnei Oliveira](https://www.linkedin.com/in/rudnei-oliveira-69443523/) | Senior Azure Security Engineer

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
- [Compare self-managed Active Directory Domain Services, Microsoft Entra ID, and managed Microsoft Entra Domain Services](/entra/identity/domain-services/compare-identity-solutions)

## Related resources

- [Azure enterprise cloud file share](../../hybrid/azure-files-private.yml)
- [Using Azure file shares in a hybrid environment](../../hybrid/azure-file-share.yml)
- [Hybrid file services](../../hybrid/hybrid-file-services.yml)
