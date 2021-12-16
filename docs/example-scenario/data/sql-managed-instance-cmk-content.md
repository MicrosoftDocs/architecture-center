This example architecture describes how customers can manage their own Transparent Data Encryption (TDE) keys for SQL Managed Instances in a cross-region, auto-failover group using using Azure Key Vault. When using customer-managed keys (CMK), also referred to as Bring Your Own Key (BYOK), the customer is responsible for the security, availability, and optional rotation of the keys.This is a critical responsibility because if the key is lost, the [databases and backups are permanently lost](source) as well. This article will detail the process and provide options so that you have all the information you need to be able to make an informed decision about which method is optimal for your business.

## Potential use cases

Because of the nature of [how TDE works](source), losing the key would be disastrous. Any database that is critical to your business would be a potential use case for securing your customer-managed TDE keys. 


## Architecture

![](./media/mesh.png)

>For greater redundancy of the TDE keys, SQL Managed Instance is configured to use the Key Vault in the same region as ir for primary, and the Key Vault in the remote region as secondary.

>The secondary Key Vault instance, while in a remote region, has a [Private Endpoint](https://docs.microsoft.com/azure/private-link/private-endpoint-overview) in the same region as the SQL instance. So, as far as a SQL Instance is concerned, requests made to both primary and secondary Key Vaults are logically within the same VNET and region. Many organizations choose to use Private Endpoint over accessing the public endpoint, therefore, this is the recommended method.

Flow

1. Every 10 minutes, SQL Managed Instance will check to make sure it can access the TDE wrapper at the Key Vault defined as primary. 

2. If a Key Vault becomes unavailable, and is set as the primary on a SQL Instance, that instance will check the Key Vault set as secondary. If that Key Vault is also unavailable, SQL Managed Instance will mark the databases as "inaccessible" (source).

### Components

- [Azure Key Vault](https://azure.microsoft.com/services/key-vault/)
- [Azure SQL Managed Instance](https://docs.microsoft.com/azure/azure-sql/managed-instance/)
- [Private Link Service](https://docs.microsoft.com/azure/private-link/)


### Alternatives
- The alternative to Customer-Managed TDE keys is Service-Managed TDE Keys. Microsoft handles securing and rotating the keys for you and the entire process is abstracted away from the customer. 

- An alternative to having an Azure KeyVault in two regions is to just have one in a single region. SQL Managed Instance will have no problem accessing keys from a Vault in another region. You can still use Private Endpoint. The traffic to Key Vault is extremely small and infrequent so any latency would not be noticed. SQL only [queries the Vault to see if the key exists](source) and does not copy the meterial down.

## Considerations

### Key Management Considerations
Your method of Key Rotation will differ depending on what you are using to create your TDE asymmetric keys. When you bring your own TDE wrapper key, you have to decide how you will create this key. Your options are:

1. Have Azure Key Vault create the key. This option ensures that the private key material never leaves Azure Key Vault and cannot be seen by any human or system. While the private key is not exportable, it can be backed up and restored to another Azure Key Vault. This is important to know because in order to have the same key material in multiple Key Vaults as required by this design, you will have to use the bakup / restore feature.  There are several limitation with this option. Both Key Vaults must be in the same Azure [geography](source) or the restore will not work. The only way around this is to keep the Key Vaults in separate subscriptions and [move the subscription to another region](source). 

2. Generate the asymmetric keys offline using a utility such as OpenSSL and import the key into Azure Key Vault. When you import a key into Key Vault, you can [mark is as exportable](source) so you can either throw away the keys once you've imported them into Key Vault or you can store them somewhere else (on-prem, another Key Vault, etc.). This option gives you the most flexibility but can be the least secure without properly ensuring the keys don't get in the wrong hands. The system generating the keys and the method used to place the keys in Azure Key Vault are not controlled by Azure. This process can be automated using [Azure DevOps](https://docs.microsoft.com/azure/devops/), [Azure Automation](https://docs.microsoft.com/azure/automation/), or any orchestration tool of your choice.


3. Use a [supported on-premises Hardware Security Module (HSM)](https://docs.microsoft.com/en-us/azure/key-vault/keys/hsm-protected-keys#supported-hsms) to generate your keys. Using a supported HSM, you can import keys into Azure Key Vault, securely. The same-geography limitation does not apply here. This option provides an extremely high level of safety of your keys because the key material would be in three separate places (2 Key Vaults in Azure and on-prem). This option also provides the same level of flexibility, if you have a supported HSM.

### Availability
By adding Azure Key Vault to your architecture, it becomes a critical component and at least one of the Key Vaults in the design must be accessible. Additionally, the keys necessary for TDE must be accessible. Azure Monitor Insights provides comprehansive monitoring of Azure Key Vault. More information can be found here: [source](https://docs.microsoft.com/en-us/azure/azure-monitor/insights/key-vault-insights-overview)


### Operations
When moving from service-managed keys to customer-managed keys, your operations will be:

- [Securing the key](source)
- [Rotating the key](source)
- [Backing up the key](source)
- [Monitoring the keys and Key Vaults](link)

### Performance
- SQL Managed Instance auto-failover groups [perform significantly better when using paired regions](source) as opposed to not using paired regions.

- Because SQL MI only checks to see if the key exists, and only does that every 10 minutes, SQL MI does not require region-affinity with Key Vault. Where your TDE keys are located will have no bearing on performance.

### Scalability
Scaling is also of no concern in regards to managing your TDE keys. The request size and frequency is so small that you will not need to scale.

### Security
The biggest security consideration is ensuring you keep your TDE wrapper key safe and always available to SQL. The result of [losing the key would be disastrous](source). For this reason, Microsoft recommends using service-managed keys to take this responsibility off the customer.


### Resiliency
Each SQL Instance is configured to use two Key Vaults. If SQL Instance's primary TDE key is unavailable or inaccessible, it will attempt to find the key with a matching thumbprint in the secondary Key Vault.


### DevOps
Azure DevOps can be used to automate the process used for [Key Rotation](source) using [Azure Piplines](https://docs.microsoft.com/azure/devops/pipelines/).


## Deploy This Scenario
This scenario can be deployed by using the following ARM templates:
- [SQL Managed Instance](https://github.com/Azure/azure-quickstart-templates/tree/master/quickstarts/microsoft.sql/sql-managed-instance-azure-environment).
- [Azure Key VAult](https://github.com/Azure/azure-quickstart-templates/tree/master/quickstarts/microsoft.keyvault)



## Pricing
The additional costs of managing your own TDE keys, outside of added operational costs are:

- [Azure KeyVault Pricing](https://azure.microsoft.com/en-us/pricing/details/key-vault/)
- [Private Endpoint Pricing](https://azure.microsoft.com/pricing/details/private-link/#pricing)
- Optional [Azure DevOps Pricing](https://azure.microsoft.com/en-gb/pricing/details/devops/azure-devops-services/)
- Optional [Azure Automation Pricing](https://azure.microsoft.com/en-us/pricing/details/automation/#pricing)
