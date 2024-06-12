Azure Sandbox is a collection of interdependent [cloud computing](https://azure.microsoft.com/overview/what-is-cloud-computing) configurations for implementing common [Azure](https://azure.microsoft.com/overview/what-is-azure) services on a single [subscription](/azure/azure-glossary-cloud-terminology#subscription). This collection provides a flexible and cost effective sandbox environment for experimenting with Azure services and capabilities.

Depending on your Azure offer type and region, a fully provisioned Azure Sandbox environment can be expensive to run. You can reduce costs by stopping or deallocating virtual machines (VMs) when not in use, or by skipping optional configurations that you don't plan to use.
  
## Architecture

[![Diagram that shows the Azure Sandbox environment.](images/create-azure-sandbox.svg)](images/create-azure-sandbox.svg#lightbox)

*Download a [Visio file](https://arch-center.azureedge.net/create-an-azure-sandbox.vsdx) of this architecture.*

### Components

You can deploy all the following sandbox configurations, or just the ones you need.

- Shared services virtual network, [Azure Bastion](https://azure.microsoft.com/products/azure-bastion), and Active Directory domain controller
- Application virtual network, Windows Server jump box, Linux jump box, and [Azure Files](https://azure.microsoft.com/products/storage/files) share
- [SQL Server on Azure Virtual Machines](https://azure.microsoft.com/products/virtual-machines/sql-server)
- [Azure SQL Database](https://azure.microsoft.com/products/azure-sql/database)
- [Azure Database for MySQL Flexible Server](/azure/mysql/flexible-server/overview)
- [Azure Virtual WAN](https://azure.microsoft.com/products/virtual-wan) and point-to-site VPN

## Deploy the sandbox

The Azure Sandbox environment requires the following prerequisites:

- A [Microsoft Entra ID](https://azure.microsoft.com/products/active-directory) tenant
- An [Azure subscription](https://azure.microsoft.com/support/legal/offer-details)
- The appropriate [Azure role-based access control (RBAC)](/azure/role-based-access-control/overview) role assignments
- A [service principal](/cli/azure/create-an-azure-service-principal-azure-cli)
- A [configured client environment](https://github.com/Azure-Samples/azuresandbox#configure-client-environment)

For more information about how to prepare for a sandbox deployment, see [Prerequisites](https://github.com/Azure-Samples/azuresandbox#prerequisites).

To integrate [AzureSandbox](https://github.com/Azure-Samples/azuresandbox) with an [Azure landing zone](/azure/cloud-adoption-framework/ready/landing-zone) consider doing the following:

- Place the sandbox subscription in the *Sandboxes* management group.
- Keep the sandbox isolated from your private network.
- Audit sandbox subscription activity.
- Limit sandbox access, and remove access when it is no longer required.
- Decommission sandboxes after an expiration period to control costs.
- Create a budget on sandbox subscriptions to control costs.

See [Landing zone sandbox environments](/azure/cloud-adoption-framework/ready/considerations/sandbox-environments) for more information.

To deploy Azure Sandbox, go to the [AzureSandbox](https://github.com/Azure-Samples/azuresandbox) GitHub repository and begin with [Getting started](https://github.com/Azure-Samples/azuresandbox#getting-started). See [Default Sandbox Deployment](https://github.com/Azure-Samples/azuresandbox#perform-default-sandbox-deployment) to deploy your Azure Sandbox environment. For more information, see [Known issues](https://github.com/Azure-Samples/azuresandbox#known-issues).

## Use cases

A sandbox is ideal for accelerating Azure projects. After you deploy your sandbox environment, you can add services and capabilities. You can use the sandbox for activities like:

- Self-learning
- Hackathons
- Testing
- Development
- Tabletop exercises
- Red Team / Blue Team simulations
- Incident response drills

> [!IMPORTANT]
> Azure Sandbox isn't intended for production use. The deployment uses some best practices, but others intentionally aren't used in favor of simplicity and cost.

## Capabilities

Have you ever wanted to experiment with a particular Azure service or capability, but were blocked by all the foundational prerequisites? A sandbox environment can accelerate your project by provisioning many of the mundane core infrastructure components. You can focus on just the services or capabilities you need to work with.

For example, you can use the following capabilities and configurations that the Azure Sandbox environment provides:

- Connect to a Windows jump box VM from the internet.
  - Option 1: Internet-facing access by using a web browser and Azure Bastion
  - Option 2: Point-to-site VPN connectivity via Azure Virtual WAN
  
- Use a preconfigured Active Directory Domain Services local domain as a domain administrator.
  - Preconfigured integrated DNS server
  - Preconfigured integration with Azure private DNS zones
  - Preconfigured integration with Azure Private Link private endpoints.

- Use an Azure Files preconfigured file share.

- Use a Windows jumpbox VM as a developer workstation.
  - Domain joined to local domain
  - Administer Active Directory and DNS with preinstalled Windows Server Remote Server Administration Tools
  - Visual Studio Code preinstalled with Remote-SSH into a Linux jump box
  - Azure Storage Explorer, AzCopy, and Azure Data Studio preinstalled
  - SQL Server Management Studio preinstalled
  - MySQL Workbench preinstalled

- Use a Linux jump box VM as a DevOps agent.
  - Domain joined to local domain using Winbind
  - Azure CLI, PowerShell, and Terraform preinstalled
  - Dynamic CIFS mount to Azure Files preconfigured file share

- Use a preconfigured SQL Server VM.
  - Domain joined to local domain

- Use a preconfigured Azure SQL database or Azure Database for MySQL Flexible Server through private endpoints.

## Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

> [!IMPORTANT]
> Sandbox environments represent an attack surface that can be exploited. To reduce risk, consider the following security best practices.

- Implement strong authentication in the Microsoft Entra ID tenant associated with Azure subscriptions used to provision sandbox environments, following recommendations in [SE:05 - Recommendations for identity and access management](/azure/well-architected/security/identity-access).
  - Use multi-factor authentication (MFA) for all users.
  - Use conditional access policies to restrict access to sandbox environments.
  - Use integrated Microsoft Entra authentication to authorize access to Azure PaaS services like Azure SQL Database and Azure Storage.

- Start with a [least privilege approach](/azure/well-architected/security/identity-access#role-assignment) to authorize sandbox use.
  - Limit `Owner` Azure RBAC role assignments to sandbox subscription owners.
  - Limit `Contributor` Azure RBAC role assignments to sandbox subscription users.
  - Use Microsoft Entra privileged identity management (PIM) to manage privileged Azure RBAC role assignments scoped to  sandbox subscriptions (e.g. `Owner`, `Contributor`, `User Access Administrator`).

- Maintain your [data classification](/azure/well-architected/security/data-classification) compliance. For example, avoid hosting personally identifiable information (PII) or other sensitive data in a sandbox environment. If you must use sensitive data, use synthetic data or data that has been de-identified.

Also, consider these [Secure Futures Initiative](https://www.microsoft.com/microsoft-cloud/resources/secure-future-initiative) principles when designing and implementing sandbox environments. The [AzureSandbox](https://github.com/Azure-Samples/azuresandbox) implementation on GitHub showcases many of these.

### Secure by design

- Limit the use of [shared secrets](/azure/well-architected/security/application-secrets#preshared-keys) and secure them using Azure Key Vault when required. When shared secrets must be used, retrieve them at runtime from Azure Key Vault using managed identities. If secrets must be persisted, ensure they are encrypted and not stored in plain text. Never echo secrets to the console or to log files, and never check secrets into source control.
- Set an expiration date for Key Vault secrets.
- When selecting a guest operating system for virtual machines, only use operating systems that are currently supported and eligible to receive security updates.

### Secure by default

- Use encryption as recommended by [SE:07 - Recommendations for data encryption](/azure/well-architected/security/encryption).
  - Ensure that cryptographic protocols and algorithms are up-to-date (e.g. TLS 1.2 or higher, SHA-256 or higher).
  - For managed disks attached to virtual machines, data is encrypted at rest by default. Consider using host encryption or Azure Disk Encryption for encryption in transit.
- Avoid the use of public IPs. Use Azure Bastion for secure remote access to virtual machines.
- Use private endpoints to communicate with Azure services.
- Disable public network access to Azure services like Azure Storage and Azure SQL Database.

### Secure operations

- Enable Microsoft Defender for Cloud CSPM on sandbox subscriptions.
- Enable Azure Update Manager on all virtual machines used in sandbox environments, and set a regular patching schedule.
  - For SQL Server virtual machines, enable first-party updates in Windows Update to ensure that SQL Server is patched.
- Monitor activity and diagnostic logs with Azure Monitor and/or Azure Sentinel.
- Decommission sandboxes that are no longer in use.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributor.*

Principal author:

- [Roger Doherty](https://www.linkedin.com/in/roger-doherty-805635b/)

 *To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Develop and test on Azure](https://azure.microsoft.com/solutions/dev-test/#overview)
- [Microsoft Cloud Adoption Framework](/azure/cloud-adoption-framework)
- [Cloud Adoption Framework Azure setup guide](/azure/cloud-adoption-framework/ready/azure-setup-guide)
- [Microsoft Azure Well-Architected Framework](/azure/architecture/framework)

## Related resources

- [Technology choices for Azure solutions](../technology-choices/technology-choices-overview.md)
- [Best practices for cloud applications](../../best-practices/index-best-practices.md)
- [Build applications on the Microsoft Cloud](../microsoft-cloud/overview.md)
