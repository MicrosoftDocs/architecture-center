[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This solution describes a secure and resilient deployment pattern for Azure SQL Managed Instance. It highlights how Azure Key Vault Managed HSM is used to store the customer-managed transparent data encryption (TDE) protector keys.

## Architecture

:::image type="complex" border="false" source="../media/azure-sql-managed-instance-architecture.svg" alt-text="Diagram that shows the secure and resilient SQL Managed Instance architecture." lightbox="../media/azure-sql-managed-instance-architecture.svg":::
   The diagram has three sections: a primary region, a secondary region, and a global resources section. Each of the regions contains two subnets, and the regions are identical. Each subnet in each region is enclosed in a virtual network. At the top of each subnet is a resource groups icon. Each subnet has a network security group. One subnet in each region contains SQL Managed Instance deployed across availability zones, and Azure Policy at the subnet boundary. The other subnet in each region contains a Managed HSM private endpoint, a second private endpoint, and a load balancer, and a Managed HSM pool outside the subnet. To the left of each region is an icon for a private DNS zone for Managed HSM. The global resources section contains Traffic Manager. A Log Analytics workspace is between the two regions. Arrows point to this workspace from the Managed HSM pool in each region. Five numbered steps identify the workflow. In step 1, an arrow representing cross-region data replication connects SQL Managed Instance in the primary region to SQL Managed Instance in the secondary region. In step 2, an arrow representing cross-region replication connects the Managed HSM pool in the primary region to the Managed HSM pool in the secondary region. Step 3 is labeled data plane. In this step, in each region, an arrow shows traffic flowing from SQL Managed Instance through the Managed HSM private endpoint to Traffic Manager. In step 4, Traffic Manager redirects to closest Managed HSM: an arrow from Traffic Manager points to the Managed HSM pool in each region. Step 5 is labeled management plane. In this step, in each region, an arrow shows SQL Managed Instance sending management plane requests directly to Traffic Manager.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/azure-sql-managed-instance-architecture.vsdx) of this architecture.*

### Workflow

The following workflow corresponds to the previous diagram:

1. A failover group on the primary SQL managed instance replicates all user databases to a secondary SQL managed instance in another region for disaster recovery.

1. Managed HSM is configured with a cross-region pool. This pool automatically replicates the key material and permissions to the vault in the secondary region.

1. Data plane traffic from SQL Managed Instance flows through the private endpoint of Managed HSM.

1. Managed HSM uses a Microsoft-managed Azure Traffic Manager instance to route the traffic to the closest operational vault.

1. If the managed instance needs to check permissions on a key, it sends a management plane request over the Azure backbone network.

### Components

- [SQL Managed Instance](/azure/well-architected/service-guides/azure-sql-managed-instance) is a platform as a service (PaaS) offering that's almost completely compatible with the latest SQL Server Enterprise Edition database engine. It provides a native virtual network implementation that improves security and provides a beneficial business model for existing SQL Server customers. You can use SQL Managed Instance to migrate your on-premises applications to the cloud with minimal modifications to applications and databases.

  SQL Managed Instance also provides comprehensive PaaS capabilities, including automatic patching and version updates, automated backups, and [business continuity capabilities](/azure/azure-sql/managed-instance/business-continuity-high-availability-disaster-recover-hadr-overview). These features significantly reduce management overhead and total cost of ownership. In this architecture, SQL Managed Instance is the database that uses the TDE protector keys.

- [Managed HSM](/azure/key-vault/managed-hsm/overview) is a fully managed cloud service that provides high availability, single-tenancy, and compliance with industry standards. Managed HSM is designed to safeguard cryptographic keys for cloud applications. It uses Federal Information Processing Standards 140-3 Level 3 validated HSMs. Managed HSM is one of several key-management solutions in Azure. In this architecture, Managed HSM securely stores the TDE protector keys and provides cross-region resiliency.

- An [Azure private endpoint](/azure/private-link/private-endpoint-overview) provides a private IP path from a virtual network to services such as Azure Storage, Azure SQL Database, and Key Vault. For this architecture, disable public network access on Managed HSM and use private endpoints in both regions so data-plane traffic stays on the Microsoft backbone network.

- [Azure Private DNS](/azure/dns/private-dns-overview) provides name resolution for private endpoints, which enables resources within a virtual network to access Azure services privately. When a private endpoint is created, a corresponding Domain Name System (DNS) record is automatically registered in the linked private DNS zone. A private DNS zone ensures that traffic to the service remains within the Azure backbone network. This approach improves security, performance, and compliance by avoiding exposure to the public internet. If a regional service outage occurs, Azure Private DNS provides native cross-region name resolution resiliency for Managed HSM. In this architecture, services use Azure Private DNS to communicate with each other via their private network addresses.

- [Azure Policy](/azure/governance/policy) evaluates resources and actions in Azure by comparing the properties of those resources to business rules. These business rules, described in JSON format, are known as *policy definitions*. For this solution, use Azure Policy to enforce customer-managed TDE during the creation or update of an Azure SQL database or Azure SQL managed instance, per the [documented](/azure/azure-sql/database/transparent-data-encryption-byok-overview#azure-policy-for-customer-managed-tde) guidance.

- [Log Analytics workspace](/azure/azure-monitor/logs/log-analytics-workspace-overview) is a data store into which you can collect any type of log data from all of your Azure and non-Azure resources and applications. Workspace configuration options let you manage all of your log data in one workspace to meet the operations, analysis, and auditing needs of different personas in your organization. For this solution, a Log Analytics workspace receives comprehensive logging and telemetry from Managed HSM.

## Scenario details

In this solution, a workload team wants to meet strict service-level objective (SLO) thresholds for their mission-critical system while ensuring full functionality of the required services. To achieve this goal, they use SQL Managed Instance with a customer-managed TDE protector key. The key is stored in a Managed HSM pool that supports the regions they use and meets all compliance and security requirements. Private endpoint access is also enforced to limit network exposure.

For cross-region disaster recovery, a failover group with a customer-managed failover policy is typically preferred so the customer can control failover timing. The failover group replicates user databases as a unit, so related instance-level objects and settings need to be synchronized separately.

### Potential use cases

- An organization uses two paired or nonpaired regions. The primary SQL managed instance is located in one region, and failover groups are configured to connect it with the SQL managed instance in the secondary region.

  This design uses failover-group listener endpoints so applications can keep stable connection strings during failover. Failover groups update the listener DNS record automatically after a geo-failover. But observed reconnection time on the client depends on the client's DNS cache TTL and on application retry logic.

- An organization uses a Managed HSM instance in a primary region with a cross-region replica in a secondary region. When a cross-region replica is enabled, a Traffic Manager instance is created. The Traffic Manager instance handles the routing of traffic to the local vault if both vaults are operational or to the operational vault if one vault is unavailable.

  Replication of key material and permissions is asynchronous and can take [several minutes](/azure/reliability/reliability-managed-hsm#behavior-when-all-regions-are-healthy). Initial extension to a secondary region takes additional provisioning time. Validate Managed HSM availability and capacity in the desired regions before finalizing the resiliency design.

- An organization uses two custom DNS zones to support a private endpoint for a Managed HSM instance in each region.

  In multiregion deployments, a private endpoint and private DNS integration in each region help keep name resolution and data plane traffic within each region.

- An organization enables TDE on user databases with a customer-managed key and stores the protector key in Managed HSM.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Laura Grob](https://www.linkedin.com/in/laura-grob/) | Principal Program Manager
- [Armen Kaleshian](https://www.linkedin.com/in/akaleshian/) | Principal Cloud Solution Architect
- [Michael Piskorski](https://www.linkedin.com/in/mike-piskorski-1451272/) | Senior Cloud Solution Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Control your data in the cloud by using Managed HSM](/azure/key-vault/managed-hsm/mhsm-control-data)
- [Enable multiregion replication on Managed HSM](/azure/key-vault/managed-hsm/multi-region-replication)
- [Configure Managed HSM with private endpoints](/azure/key-vault/managed-hsm/private-link)
- [Managed HSM recovery overview](/azure/key-vault/managed-hsm/recovery)
- [Key sovereignty, availability, performance, and scalability in Managed HSM](/azure/key-vault/managed-hsm/managed-hsm-technical-details)
- [Best practices for securing Managed HSM](/azure/key-vault/managed-hsm/secure-managed-hsm)
- [Key Vault security overview](/azure/key-vault/general/secure-key-vault)
- [Generate and transfer HSM-protected keys](/azure/key-vault/keys/hsm-protected-keys-byok)
- [Key Vault availability and redundancy](/azure/reliability/reliability-key-vault)
- [Azure SQL transparent data encryption with customer-managed key](/azure/azure-sql/database/transparent-data-encryption-byok-overview)
- [Failover groups overview & best practices - Azure SQL Managed Instance](/azure/azure-sql/managed-instance/failover-group-sql-mi)
