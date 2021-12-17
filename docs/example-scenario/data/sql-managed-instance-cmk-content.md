This article describes how you can manage your own Transparent Data Encryption (TDE) keys for SQL managed instances in a cross-region auto-failover group by using Azure Key Vault. When you use customer-managed keys (CMK), also referred to as bring your own key (BYOK), you're responsible for the security, availability, and optional rotation of the keys. These responsibilities are critical because if the key is lost, the databases and backups are also permanently lost. This article describes the key management process and provides options so that you have the information you need to make an informed decision about the best process for your business.

## Potential use cases

Because of [how TDE works](/sql/relational-databases/security/encryption/transparent-data-encryption?view=azuresqldb-mi-current), losing a key is disastrous. Any database that's critical to your business is a potential use case for securing your customer-managed TDE keys. 

## Architecture

:::image type="content" border="false" source="./media/sql-managed-instance-cmk.png" alt-text="Diagram that shows an architecture for managing T D E keys." lightbox="./media/sql-managed-instance-cmk.png":::

*Download a [Visio file](https://arch-center.azureedge.net/sql-mi-cmk.vsdx) of this architecture.*

For greater redundancy of the TDE keys, Azure SQL Managed Instance is configured to use the key vault in its own region as the primary and the key vault in the remote region as the secondary.

The secondary key vault instance, while in a remote region, has a [private endpoint](/azure/private-link/private-endpoint-overview) in the same region as the SQL managed instance. So, as far as a SQL managed instance is concerned, requests made to both primary and secondary key vaults are logically within the same virtual network and region. Many organizations use a private endpoint rather than accessing the public endpoint. We recommend that you use a private endpoint.

### Dataflow

1. Every 10 minutes, SQL Managed Instance checks to make sure it can access the TDE wrapper at the key vault that's defined as primary. 

2. If a key vault becomes unavailable and is set as the primary on a SQL Managed Instance, that instance checks the key vault that's set as secondary. If that key vault is also unavailable, SQL Managed Instance marks the databases as "inaccessible." 

### Components

- [Key Vault](https://azure.microsoft.com/services/key-vault/) is a cloud service for storing and accessing secrets with enhanced security. In this architecture, it's used to store keys used by TDE. You can also use it to create keys. 
- [SQL Managed Instance](https://docs.microsoft.com/azure/azure-sql/managed-instance/) is a managed instance in Azure that's based on the latest stable version of SQL Server. In this architecture, the key management process is applied to data stored in SQL Managed Instance. 
- [Azure Private Link](/azure/private-link/) enables you to access Azure PaaS services and Azure-hosted services over a private endpoint in your virtual network. 

### Alternatives
-  Instead of using customer-managed TDE keys, you can use service-managed TDE keys. When you use service-managed keys, Microsoft handles securing and rotating the keys. The entire process is abstracted away from you. 

- An alternative to having key vaults in two regions is to just have one in a single region. SQL Managed Instance can access keys from a vault that's in another region. You can still use private endpoint. The traffic to Key Vault is low and infrequent, so any latency isn't noticeable. SQL Managed Instance only queries the vault to see if the key exists. It doesn't copy the material.

## Considerations

Your method of key rotation will differ depending on what you're using to create your TDE asymmetric keys. When you bring your own TDE wrapper key, you have to decide how you'll create this key. Your options are:

- Use Key Vault to create the keys. This option ensures that the private key material never leaves Key Vault and can't be seen by any human or system. The private keys aren't exportable, but they can be backed up and restored to another key vault. This point is important. In order to have the same key material in multiple key vaults, as required by this design, you have to use the backup and restore feature. This option has several limitations. Both key vaults must be in the same Azure geography. If they aren't, the restore won't work. The only way around this limitation is to keep the key vaults in separate subscriptions and move one subscription to another region. 

- Generate the asymmetric keys offline by using a utility like OpenSSL and then import the keys into Key Vault. When you import a key into Key Vault, you can [mark it as exportable](/cli/azure/keyvault/key?view=azure-cli-latest#az_keyvault_key_create-optional-parameters). If you do that, you can either throw away the keys after you import them into Key Vault or you can store them somewhere else, like on-premises or in another key vault. This option gives you the most flexibility. However, it can be the least secure if you don't properly ensure the keys don't get into the wrong hands. The system generating the keys and the method used to place the keys in Key Vault aren't controlled by Azure. You can automate this process by using [Azure DevOps](/azure/devops), [Azure Automation](/azure/automation), or another orchestration tool.

- Use a [supported on-premises hardware security module (HSM)](/azure/key-vault/keys/hsm-protected-keys#supported-hsms) to generate your keys. By using a supported HSM, you can import keys into Key Vault with improved security. The same-geography limitation described earlier doesn't apply when you use an HSM. This option provides a high level of safety for your keys because the key material is in three separate places (two key vaults in Azure and on-premises). This option also provides the same level of flexibility, if you use a supported HSM.

### Availability
When you add Key Vault to your architecture, it becomes a critical component. At least one of the key vaults in the design must be accessible. Additionally, the keys necessary for TDE must be accessible. Azure Monitor insights provides comprehensive monitoring of Key Vault. For more information, see [Monitoring your key vault service](/azure/azure-monitor/insights/key-vault-insights-overview).


### Operations
When you move from service-managed keys to customer-managed keys, your operations will be:

- [Storing keys with enhanced security](/azure/key-vault/general/security-features)
- [Rotating keys](/azure/azure-sql/database/transparent-data-encryption-byok-key-rotation)
- [Backing up keys](/azure/key-vault/general/backup?tabs=azure-cli#design-considerations)
- [Monitoring keys and key vaults](/azure/azure-monitor/insights/key-vault-insights-overview)

### Performance
SQL Managed Instance auto-failover groups [perform significantly better when you use paired regions](/azure/azure-sql/database/auto-failover-group-overview?tabs=azure-powershell#using-geo-paired-regions).

SQL Managed Instances only checks to see if the key exists, and it only does that every 10 minutes. Therefore, SQL Managed Instances doesn't require region-affinity with Key Vault. The location of your TDE keys has no effect on performance.

### Scalability
When it comes to managing your TDE keys, scaling isn't a concern. The request size and frequency are so small that you won't need to scale.

### Security
The biggest security consideration is ensuring you keep your TDE wrapper key safe and always available to SQL Managed Instances. Losing a key is disastrous. Microsoft recommends that you use service-managed keys so that you don't have to worry about losing keys.


### Resiliency
Each SQL managed instance is configured to use two key vaults. If the SQL Managed Instance primary TDE key is unavailable or inaccessible, the instance will attempt to find a key with a matching thumbprint in the secondary key vault.

### DevOps
You can use [Azure Pipelines](/azure/devops/pipelines/) in Azure DevOps to automate the [key rotation process](/azure/azure-sql/database/transparent-data-encryption-byok-key-rotation).


## Deploy this scenario
You can deploy this scenario by using these ARM templates:
- [SQL Managed Instance](https://github.com/Azure/azure-quickstart-templates/tree/master/quickstarts/microsoft.sql/sql-managed-instance-azure-environment)
- [Azure Key Vault](https://github.com/Azure/azure-quickstart-templates/tree/master/quickstarts/microsoft.keyvault)

## Pricing
For information about the additional costs of managing your own TDE keys, outside of added operational costs, see these resources:

- [Azure Key Vault pricing](https://azure.microsoft.com/pricing/details/key-vault)
- [Private endpoint pricing](https://azure.microsoft.com/pricing/details/private-link/#pricing)

For information about the optional components, see these resources:
- [Azure DevOps pricing](https://azure.microsoft.com/en-gb/pricing/details/devops/azure-devops-services/)
- [Azure Automation pricing](https://azure.microsoft.com/en-us/pricing/details/automation/#pricing)

## Next steps
- [Encryption of backup data using customer-managed keys](/azure/backup/encryption-at-rest-with-cmk)
- [What is Azure SQL Managed Instance?](/azure/azure-sql/managed-instance/sql-managed-instance-paas-overview)
- [Azure Key Vault basic concepts](/azure/key-vault/general/basic-concepts)

## Related resources
- [Secure data solutions](/azure/architecture/data-guide/scenarios/securing-data-solutions)
- [High availability for Azure SQL Database and SQL Managed Instance](/azure/azure-sql/database/high-availability-sla)
- [Web app private connectivity to Azure SQL database](/azure/architecture/example-scenario/private-web-app/private-web-app)