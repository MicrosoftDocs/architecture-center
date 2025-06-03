[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This solution describes a secure and resilient deployment pattern for Azure SQL Managed Instance. It highlights how Azure Managed Hardware Security Module is used to store the customer-managed Transparent Data Encryption (TDE) protector keys.

## Architecture

:::image type="complex" border="false" source="../media/azure-sql-managed-instance-architecture.svg" alt-text="Diagram that shows the secure and resilient SQL Managed Instance architecture." lightbox="../media/azure-sql-managed-instance-architecture.svg":::
   The diagram includes five key sections. The first section is the primary region. This region includes SQL Managed Instance, availability zones, and a subnet with NSG. An arrow labeled Management plane points to the Global resources section. An arrow labeled Cross-region data replication points from the first section to the second section, which is the secondary nonpaired region. The second section contains SQL Managed Instance, availability zones, and a subnet with NSG. The third section has two subsections. One subsection contains a subnet with NSG and an HSM primary region private endpoint. The adjacent section contains a private endpoint, load balancer, and managed HSM pool. The fourth section has two subsections. One subsection contains a subnet with NSG, a private endpoint, and an HSM primary region private endpoint. The adjacent subsection contains the load balancer and a managed HSM pool. An arrow labeled Cross-region replication points from the previous section to this section. The fifth section is for global resources and contains the Azure Traffic Manager. An arrow that represents the Traffic Manager redirecting to the closest mHSM points to the fourth section. A double-sided arrow labeled Data plane points from Azure Traffic Manager section to the fourth section. An arrow points from the second section to the Traffic Manager section.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/azure-sql-managed-instance-architecture.vsdx) of this architecture.*

### Workflow

The following workflow corresponds to the previous diagram:

1. SQL Managed Instance is configured with availability groups in the secondary nonpaired region to replicate the data for disaster recovery.

1. Azure Managed HSM is configured with a cross-region pool. This pool automatically replicates the key material and permissions to the vault in the secondary nonpaired region.

1. Data plane traffic from SQL Managed Instance transits through the private endpoint of Managed HSM.

1. Managed HSM uses Azure Traffic Manager, which routes the traffic to the closest vault by choosing the closest operational vault.

1. If the managed instance needs to check permissions on a key, management plane traffic from SQL Managed Instance transits by using the Azure backbone.

### Components

- [SQL Managed Instance](/azure/well-architected/service-guides/azure-sql-managed-instance/reliability) is a platform-as-a-service (PaaS) offering that is almost fully compatible with the latest Enterprise Edition SQL Server database engine. In this architecture, SQL Managed Instance is the database target for the TDE protector keys. It provides a native virtual network implementation that addresses common security concerns and features a business model that's advantageous for existing SQL Server customers. Customers can use SQL Managed Instance to migrate their on-premises applications to the cloud with minimal modifications to applications and databases. SQL Managed Instance also provides comprehensive PaaS capabilities, including automatic patching and version updates, automated backups, and high availability. These features significantly reduce management overhead and total cost of ownership.

- [Azure Key Vault Managed HSM](/azure/key-vault/managed-hsm/overview) is a fully managed, highly available, single-tenant, standards-compliant cloud service. In this architecture, Managed HSM is used to securely vault the TDE protector keys and to provide cross-region resiliency. Managed HSM is designed to safeguard cryptographic keys for cloud applications. It uses Federal Information Processing Standards 140-2 Level 3-validated HSMs. It's one of several key management solutions in Azure.

- [A private endpoint](/azure/private-link/private-endpoint-overview) is a network interface that securely connects your PaaS services, such as Azure Storage, Azure SQL Database, and Key Vault to your virtual network via a private IP address. This service eliminates the need for public internet exposure, which enhances security by keeping traffic within the Azure backbone network. It also uses the customer virtual network for added protection.

- [Azure Private DNS](/azure/dns/private-dns-overview) provides seamless name resolution for private endpoints, which enables resources within a virtual network to access Azure services privately. It allows them to use fully qualified domain names instead of public IP addresses, which enhances security and accessibility. When a private endpoint is created, a corresponding Domain Name System (DNS) record is automatically registered in the linked private DNS zone. Using a private DNS zone ensures that traffic to the service remains within the Azure backbone network. This approach improves security, performance, and compliance by avoiding exposure to the public internet. It provides native cross-region name resolution resiliency for Managed HSM, if a regional service outage occurs.

## Scenario details

In this solution, a customer aims to meet strict service-level agreement thresholds for their mission-critical system while ensuring full functionality of the listed services. To achieve this goal, they use SQL Managed Instance with a customer-managed TDE protector key that's stored in a vault that supports their chosen regions and meets all compliance and security requirements, including private endpoint access.

### Potential use cases

- The customer uses two nonpaired regions. This use case could also be used with paired regions. The primary SQL Managed Instance is in one region with failover groups configured to the SQL managed instance in the secondary region.

- The customer uses a managed HSM in the primary region with a cross-region replica in the secondary region. When a cross-region replica is enabled, a traffic manager instance is created. The Traffic Manager instance handles the routing of traffic to the local vault if both vaults are operational or to the vault that is operational if one is unavailable.

- The customer uses two custom DNS zones to support a private endpoint for the managed HSM in each region.

- The customer-enabled TDE on the user databases uses the customer managed key model, and stored the protector key in the managed HSM.

- The customer uses this design to provide the maximum resiliency possible.

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
- [Enable multiregion replication on Azure Managed HSM](/azure/key-vault/managed-hsm/multi-region-replication)
- [Configure Managed HSM with private endpoints](/azure/key-vault/managed-hsm/private-link)
- [Managed HSM recovery overview](/azure/key-vault/managed-hsm/recovery?tabs=azure-cli)
- [Key sovereignty, availability, performance, and scalability in Managed HSM](/azure/key-vault/managed-hsm/managed-hsm-technical-details)
- [Best practices for securing Managed HSM](/azure/key-vault/managed-hsm/best-practices)
- [Azure Key Vault security overview](/azure/key-vault/general/security-features)
- [About Key Vault keys](/azure/key-vault/keys/about-keys)
- [Generate and transfer HSM-protected keys](/azure/key-vault/keys/hsm-protected-keys-byok?tabs=azure-cli)
- [Key Vault availability and redundancy](/azure/key-vault/general/disaster-recovery-guidance)
