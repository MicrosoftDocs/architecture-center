[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This solution describes a secure and resilient deployment pattern for Azure SQL Managed Instance. It highlights how Azure Key Vault Managed HSM is used to store the customer-managed transparent data encryption (TDE) protector keys.

## Architecture

:::image type="complex" border="false" source="../media/azure-sql-managed-instance-architecture.svg" alt-text="Diagram that shows the secure and resilient SQL Managed Instance architecture." lightbox="../media/azure-sql-managed-instance-architecture.svg":::
   The diagram includes two key sections, the primary region and the secondary region. The primary region has a subsection that includes SQL Managed Instance, availability zones, and a subnet with a network security group (NSG). The primary region has another subsection that includes a subnet with an NSG, a Managed HSM primary region private endpoint, another private endpoint, a load balancer, and a Managed HSM pool. Each subsection has a virtual network and resource groups. A private DNS zone for mHSM is also in the primary region. The secondary region replicates the primary region's resources. An arrow labeled management plane points from SQL Managed Instance to Traffic Manager in the external global resources section. An arrow labeled cross-region data replication points from the SQL Managed Instance subsection in the primary region to the same subsection in the secondary region. An arrow labeled cross-region replication points from the Managed HSM pool subsection in the primary region to the same subsection in the secondary region. In each region, an arrow labeled data plane points from SQL Managed Instance to the private endpoint and then to Traffic Manager. In each region, an arrow labeled management plane points from SQL Managed Instance to Traffic Manager. In each region, an arrow points from Traffic Manager to the Managed HSM pool, which indicates that Traffic Manager redirects to the closest mHSM.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/azure-sql-managed-instance-architecture.vsdx) of this architecture.*

### Workflow

The following workflow corresponds to the previous diagram:

1. SQL Managed Instance is configured with availability groups in the secondary nonpaired region to replicate the data for disaster recovery.

1. Managed HSM is configured with a cross-region pool. This pool automatically replicates the key material and permissions to the vault in the secondary nonpaired region.

1. Data plane traffic from SQL Managed Instance flows through the private endpoint of Managed HSM.

1. Managed HSM uses Azure Traffic Manager to route the traffic to the closest operational vault.

1. If the managed instance needs to check permissions on a key, it sends a management plane request over the Azure backbone network.

### Components

- [SQL Managed Instance](/azure/well-architected/service-guides/azure-sql-managed-instance/reliability) is a platform-as-a-service (PaaS) offering that's almost completely compatible with the latest SQL Server Enterprise Edition database engine. It provides a native virtual network implementation that improves security and provides a beneficial business model for existing SQL Server customers. You can use SQL Managed Instance to migrate your on-premises applications to the cloud with minimal modifications to applications and databases.

  SQL Managed Instance also provides comprehensive PaaS capabilities, including automatic patching and version updates, automated backups, and high availability. These features significantly reduce management overhead and total cost of ownership. In this architecture, SQL Managed Instance is the database that uses the TDE protector keys.

- [Managed HSM](/azure/key-vault/managed-hsm/overview) is a fully managed cloud service that provides high availability, single-tenancy, and compliance with industry standards. Managed HSM is designed to safeguard cryptographic keys for cloud applications. It uses Federal Information Processing Standards 140-2 Level 3-validated HSMs. Managed HSM is one of several key management solutions in Azure. In this architecture, Managed HSM securely stores the TDE protector keys and provides cross-region resiliency.

- An [Azure private endpoint](/azure/private-link/private-endpoint-overview) serves as a network interface that securely connects PaaS services, such as Azure Storage, Azure SQL Database, and Azure Key Vault to a virtual network via a private IP address. This feature eliminates the need for public internet exposure, which enhances security by keeping traffic within the Azure backbone network. It also uses the customer virtual network for added protection. In this architecture, an Azure private endpoint ensures that traffic between services flows through a private virtual network.

- [Azure Private DNS](/azure/dns/private-dns-overview) provides seamless name resolution for private endpoints, which enables resources within a virtual network to access Azure services privately. It allows them to use fully qualified domain names instead of public IP addresses, which enhances security and accessibility. When a private endpoint is created, a corresponding Domain Name System (DNS) record is automatically registered in the linked private DNS zone. A private DNS zone ensures that traffic to the service remains within the Azure backbone network. This approach improves security, performance, and compliance by avoiding exposure to the public internet. If a regional service outage occurs, Azure Private DNS provides native cross-region name resolution resiliency for Managed HSM. In this architecture, services use Azure Private DNS to communicate with each other via their private network addresses.

## Scenario details

In this solution, a customer aims to meet strict service-level agreement thresholds for their mission-critical system while ensuring full functionality of the listed services. To achieve this goal, they use SQL Managed Instance with a customer-managed TDE protector key. The key is stored in a vault that supports their chosen regions and meets all compliance and security requirements. Private endpoint access is also enforced for enhanced protection.

### Potential use cases

- A customer uses two paired or nonpaired regions. The primary SQL Managed Instance is located in one region, and failover groups are configured to connect it with the SQL Managed Instance in the secondary region.

- A customer uses a Managed HSM instance in a primary region with a cross-region replica in a secondary region. When a cross-region replica is enabled, a Traffic Manager instance is created. The Traffic Manager instance handles the routing of traffic to the local vault if both vaults are operational or to the vault that's operational if one vault is unavailable.

- A customer uses two custom DNS zones to support a private endpoint for a Managed HSM instance in each region.

- A customer-enabled TDE on user databases uses a customer-managed key model, and stores a protector key in Managed HSM.

- A customer uses this design to provide the maximum resiliency possible.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Laura Grob](https://www.linkedin.com/in/laura-grob/) | Principal Cloud Solution Architect
- [Armen Kaleshian](https://www.linkedin.com/in/akaleshian/) | Principal Cloud Solution Architect
- [Michael Piskorski](https://www.linkedin.com/in/mike-piskorski-1451272/) | Senior Cloud Solution Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [A comprehensive guide to Managed HSM for regulated industries](https://techcommunity.microsoft.com/t5/azure-infrastructure-blog/a-comprehensive-guide-to-azure-managed-hsm-for-regulated/ba-p/4100749)
- [Local role-based access control built-in roles for Managed HSM](/azure/key-vault/managed-hsm/built-in-roles)
- [Enable multiregion replication on Managed HSM](/azure/key-vault/managed-hsm/multi-region-replication)
- [Configure Managed HSM with private endpoints](/azure/key-vault/managed-hsm/private-link)
- [Managed HSM recovery overview](/azure/key-vault/managed-hsm/recovery)
- [Key sovereignty, availability, performance, and scalability in Managed HSM](/azure/key-vault/managed-hsm/managed-hsm-technical-details)
- [Best practices for securing Managed HSM](/azure/key-vault/managed-hsm/best-practices)
- [Key Vault security overview](/azure/key-vault/general/security-features)
- [About Key Vault keys](/azure/key-vault/keys/about-keys)
- [Generate and transfer HSM-protected keys](/azure/key-vault/keys/hsm-protected-keys-byok)
- [Key Vault availability and redundancy](/azure/key-vault/general/disaster-recovery-guidance)
