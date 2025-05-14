[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This solution describes a secure and resilient deployment pattern for Azure SQL Managed Instance (MI) highlighting how Azure Managed Hardware Security Module (HSM) is used to store the customer managed Transparent Data Encryption (TDE) protector keys.

## Architecture

:::image type="complex" border="false" source="./media/sqlmi-managedhsm.svg" alt-text="Diagram that shows the Secure and Resilient Azure SQL Managed Instance (MI) architecture." lightbox="./media/sqlmi-managedhsm.svg":::
   A Visio diagram representing a secure and resilient deployment of Azure SQL Managed Instance (MI) configured for cross-region replication to store the Transparent Data Encryption (TDE) protector keys using Azure Managed Hardware Security Model (HSM) with private endpoints.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/sqlmanagedmi-managedhsm.vsdx) of this architecture.*

### Workflow

The following workflow corresponds to the previous diagram:

1. Azure SQL Managed Instance (MI) is configured with availability groups to a secondary region (unpaired) which replicates the data for disaster recovery.
2. Managed HSM is configured with a cross-region pool which replicates the key material and permissions to the vault in the secondary region (unpaired) automatically.
3. Data plane traffic from the SQL Managed Instance transits through the private endpoint of the Managed HSM.
4. Managed HSM uses Traffic Manager, which routes the traffic to the closest vault by choosing the closest, operational vault.
5. Management plane traffic from the Azure SQL Managed Instance, if the managed instance needs to check permissions on a key, transits using the Azure backbone.

### Components

- [Azure SQL Managed Instance](/azure/well-architected/service-guides/azure-sql-managed-instance/reliability) is the database target for the TDE protector keys.

- [Azure Key Vault Managed HSM](/azure/key-vault/managed-hsm) is used to securely vault the TDE protector keys and to provide cross-region resiliency.

- [Private Endpoint](/azure/private-link/private-endpoint-overview) is the network interface that uses a private IP address from the private virtual network securing communication between resources.

- [Azure Private DNS](/azure/dns/private-dns-overview) provides native cross-region name resolution resiliency for Managed HSM, in the case of a regional outage of the service.

## Scenario details

A customer needs to meet strict Service Level Agreement (SLA) thresholds for their mission-critical system while maintaining full functionality of the listed services. They're using Azure SQL Managed Instance and with TDE enabled using a customer managed key model. They need to store the protector key in a vault that supports their choice of regions and meets all compliance and security requirements, including the use of private endpoints to access the vault.

### Potential use cases

- The customer is using two unpaired regions (this use case could also be used with paired regions). The primary SQL Managed Instance is in one region with failover groups configured to the SQL MI in the secondary region.
- The customer is using a managed HSM in the primary region with a cross-region replica in the secondary region. When a cross-region replica is enabled, a traffic manager instance is created. The Traffic Manager instance handles the routing of traffic to the local vault if both vaults are operational or to the vault that is operational in the event one is unavailable.
- The customer is using two custom DNS zones to support a private endpoint for the managed HSM in each region.
- The customer enabled TDE on the user databases using the customer managed key model, storing the protector key in the managed HSM.
- The customer uses this design to provide the maximum resiliency possible.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Laura Grob](https://www.linkedin.com/in/laura-grob/) | Principal Cloud Solution Architect
- [Michael Piskorski](https://www.linkedin.com/in/mike-piskorski-1451272/) | Senior Cloud Solution Architect
- [Armen Kaleshian](https://www.linkedin.com/in/akaleshian/) | Principal Cloud Solution Architect

## Next steps

- [A Comprehensive Guide to Azure Managed HSM for Regulated Industries - Microsoft Community Hub](https://techcommunity.microsoft.com/t5/azure-infrastructure-blog/a-comprehensive-guide-to-azure-managed-hsm-for-regulated/ba-p/4100749)
- [Local RBAC built-in roles for Azure Key Vault Managed HSM | Microsoft Learn](/azure/key-vault/managed-hsm/built-in-roles)
- [Enable multi-region replication on Azure Managed HSM | Microsoft Learn](/azure/key-vault/managed-hsm/multi-region-replication)
- [Configure Azure Key Vault Managed HSM with private endpoints | Microsoft Learn](/azure/key-vault/managed-hsm/private-link)
- [Azure Key Vault Managed HSM recovery overview | Microsoft Learn](/azure/key-vault/managed-hsm/recovery?tabs=azure-cli)
- [Key sovereignty, availability, performance, and scalability in Managed HSM | Microsoft Learn](/azure/key-vault/managed-hsm/managed-hsm-technical-details)
- [Best practices for securing Azure Key Vault Managed HSM | Microsoft Learn](/azure/key-vault/managed-hsm/best-practices)
- [Azure Key Vault security overview | Microsoft Learn](/azure/key-vault/general/security-features)
- [About keys - Azure Key Vault | Microsoft Learn](/azure/key-vault/keys/about-keys)
- [How to generate & transfer HSM-protected keys – BYOK – Azure Key Vault | Microsoft Learn](/azure/key-vault/keys/hsm-protected-keys-byok?tabs=azure-cli)
- [Azure Key Vault availability and redundancy - Azure Key Vault | Microsoft Learn](/azure/key-vault/general/disaster-recovery-guidance)
