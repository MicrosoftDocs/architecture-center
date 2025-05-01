[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This solution describes a secure and resilient deployment pattern for Azure SQL Managed Instance (MI) highlighting how Azure Managed Hardware Security Module (HSM) is used to store the customer managed Transparent Data Encryption (TDE) protector keys.

## Architecture

:::image type="complex" border="false" source="./images/sqlmi-managedhsm.svg" alt-text="Diagram that shows the Secure and Resilient Azure SQL Managed Instance (MI) architecture." lightbox="./images/sqlmi-managedhsm.svg":::
   A Visio diagram representing a secure and resilient deployment of Azure SQL Managed Instance (MI) configured for cross-region replication to store the Transparent Data Encryption (TDE) protector keys using Azure Managed Hardware Security Model (HSM) with private endpoints.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/sqlmanagedmi-managedhsm.vsdx) of this architecture.*

### Workflow

The following workflow corresponds to the previous diagram:

1.	Azure SQL Managed Instance (MI) is configured with availability groups to a secondary region (unpaired) which replicates the data for disaster recovery.
2.	Managed HSM is configured with a cross-region pool which replicates the key material and permissions to the vault in the secondary region (unpaired) automatically.
3.	Data plane traffic from the SQL Managed Instance transits through the private endpoint of the Managed HSM. Managed HSM uses a Traffic Manager which routes the traffic to the closest vault.
4.	The traffic manager checks the health status of each vault and routes traffic to the closest operational vault.
5.	Management plane traffic from the Azure SQL Managed Instance, if the managed instance needs to check permissions on a key, transits using the Azure backbone to Traffic Manager which routes the request to the closest operational vault.

### Components

#### Azure SQL Managed Instance
Azure SQL Managed Instance is a Platform as a Service (PaaS) offering that boasts nearly 100% compatibility with the latest Enterprise Edition SQL Server database engine. It provides a native virtual network (VNet) implementation that addresses common security concerns and features a business model advantageous for existing SQL Server customers. SQL Managed Instance enables these customers to migrate their on-premises applications to the cloud with minimal modifications to applications and databases. Additionally, SQL Managed Instance offers comprehensive PaaS capabilities, including automatic patching and version updates, automated backups, and high availability. These features significantly reduce management overhead and total cost of ownership (TCO).

#### Azure Managed HSM
Azure Key Vault Managed Hardware Security Module (HSM) is a fully managed, highly available, single-tenant, standards-compliant cloud service. The service is designed to safeguard cryptographic keys for cloud applications, utilizing Federal Information Processing Standards (FIPS) 140-2 Level 3 validated HSMs. It's one of several key management solutions in Azure.

#### Private Endpoints
Azure Private Endpoint is a network interface that securely connects your PaaS services (such as Azure Storage, SQL Database, and Key Vault) to your VNet using a private IP address. The use of this service eliminates the need for public internet exposure, enhancing security by ensuring that traffic remains within the Azure backbone network while using the customer VNet for added security. 

#### Private DNS Zones
Azure Private DNS Zones enable seamless name resolution for private endpoints, allowing resources within a VNet to access Azure services privately using their fully qualified domain names (FQDN) instead of public IP addresses. When a private endpoint is created, a corresponding Domain Name System (DNS) record (such as privatelink.database.windows.net for Azure SQL) is automatically registered in the linked private DNS zone. Using a private DNS zone ensures that traffic to the service remains within the Azure backbone network, improving security, performance, and compliance by avoiding exposure to the public internet.

## Scenario details

A customer needs to meet strict Service Level Agreement (SLA) thresholds for their mission-critical system while maintaining full functionality of the listed services. They're using Azure SQL Managed Instance and with TDE enabled using a customer managed key model. They need to store the protector key in a vault that supports their choice of regions and meets all compliance and security requirements, including the use of private endpoints to access the vault.

### Potential use cases

1.	The customer is using two unpaired regions. The primary SQL Managed Instance is in one region with failover groups configured to the SQL MI in the secondary region. 
2.	The customer is using a managed HSM in the primary region with a cross-region replica in the secondary region. When a cross-region replica is enabled, a traffic manager instance is created. The Traffic Manager instance handles the routing of traffic to the local vault if both vaults are operational or to the vault that is operational in the event one is unavailable.
3.	The customer is using two custom DNS zones to support a private endpoint for the managed HSM in each region.
4.	The customer enabled TDE on the user databases using the customer managed key model, storing the protector key in the managed HSM. 
5.	The customer uses this design to provide the maximum resiliency possible.

## Contributors

•	Michael Piskorski
•	Armen Kaleshian
•	Laura Grob

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

<!-- List the primary authors alphabetically by last name. -->

- [Laura Grob](https://www.linkedin.com/in/ProfileURL/) | Title, such as "Cloud Solution Architect"
- [Michael Piskorski](https://www.linkedin.com/in/ProfileURL/) | Title, such as "Cloud Solution Architect"
- [Armen Kaleshian](https://www.linkedin.com/in/ProfileURL/) | Title, such as "Cloud Solution Architect"

## Next steps

<!--
- Add a bulleted list of links to third-party or Microsoft topics that can help customers build the workload.
- Link formats: 
  - Make Learn links site relative (for example, /azure/<feature>/<article-name>).
  - Start third-party links with `https://` and omit `en-us` unless the links don't work without it.
  - Omit a trailing slash, unless that is how the final URL renders after redirects.
-->

## Related resources

