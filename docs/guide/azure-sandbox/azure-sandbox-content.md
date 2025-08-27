Azure Sandbox is a collection of interdependent [cloud computing](https://azure.microsoft.com/overview/what-is-cloud-computing) configurations for implementing common [Azure](https://azure.microsoft.com/overview/what-is-azure) services on a single [subscription](/azure/azure-glossary-cloud-terminology#subscription). This collection provides a flexible and cost effective sandbox environment for experimenting with Azure services and capabilities.

Depending on your Azure offer type and region, a fully provisioned Azure Sandbox environment can be expensive to run. You can reduce costs by stopping or deallocating virtual machines (VMs) when not in use or by skipping optional configurations that you don't plan to use.
  
## Architecture

:::image type="content" source="images/create-azure-sandbox.svg" alt-text="Diagram that shows the Azure Sandbox environment." lightbox="images/create-azure-sandbox.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/create-an-azure-sandbox.vsdx) of this architecture.*

### Components

You can deploy each of the following sandbox configurations or only the ones that you need:

## 🧩 Azure Sandbox architecture components

- [Active Directory Domain Services](/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview) is a Windows Server VM that runs Active Directory Domain Services (AD DS). In this architecture, it provides centralized authentication, domain joining for VMs, and policy management across the sandbox environment.

- [Application virtual network](/azure/virtual-network/virtual-networks-overview) is a separate virtual network that hosts application workloads and databases. In this architecture, it provides network isolation for test applications while enabling secure communication with shared services through virtual network peering.

- [Azure Bastion](/azure/bastion/bastion-overview) is a managed service that provides secure RDP and SSH access to VMs without public IP addresses. In this architecture, it enables secure remote access to sandbox VMs directly through the Azure portal while minimizing the attack surface.

- [Azure Database for MySQL Flexible Server](/azure/mysql/flexible-server/overview) is a managed MySQL database service with private networking support. In this architecture, it provides a database platform for testing open-source applications while demonstrating private endpoint connectivity patterns.

- [Azure Files](/azure/well-architected/service-guides/azure-files) is a fully managed file share service accessible via SMB protocol. In this architecture, it provides shared storage for both Windows and Linux VMs, hosting scripts, configuration files, and enabling cross-platform file sharing scenarios.

- [Azure Firewall](/azure/well-architected/service-guides/azure-firewall) is a cloud-native firewall service with threat intelligence. In this architecture, it controls traffic between virtual networks and the internet, enforcing network segmentation and security policies across the sandbox environment.

- [Azure SQL Database](/azure/well-architected/service-guides/azure-sql-database-well-architected-framework) is a fully managed relational database service. In this architecture, it demonstrates modern cloud-native database patterns and is accessed via private endpoints to simulate secure enterprise architectures.

- [Azure Virtual WAN](/azure/virtual-wan/virtual-wan-about) is a networking service that provides secure remote connectivity. In this architecture, it offers point-to-site VPN access for developers and administrators who need full network connectivity to sandbox resources from remote locations.

- [Linux jump box](/azure/virtual-machines/linux/overview) is a domain-joined Linux VM preloaded with DevOps tools including Azure CLI, PowerShell, and Terraform. In this architecture, it serves as a DevOps automation platform and demonstrates cross-platform domain integration scenarios.

- [Shared services virtual network](/azure/virtual-network/virtual-networks-overview) is a dedicated virtual network that hosts centralized infrastructure services. In this architecture, it provides the network foundation for domain controllers, DNS services, and shared security services that support the entire sandbox environment.

- [SQL Server on Azure Virtual Machines](/azure/azure-sql/virtual-machines/windows/sql-server-on-azure-vm-iaas-what-is-overview) is a Windows VM that runs SQL Server with full administrative control. In this architecture, it supports testing of legacy applications and custom SQL configurations that require specific database engine features.

- [Windows Server jump box](/azure/architecture/patterns/jump-box) is a domain-joined Windows VM with administrative tools including RSAT, Azure Storage Explorer, and SQL Server Management Studio. In this architecture, it provides a secure management platform for administering sandbox resources and demonstrates traditional Windows administration patterns.

## Deploy the sandbox

The Azure Sandbox environment requires the following prerequisites:

- A [Microsoft Entra ID](https://azure.microsoft.com/products/active-directory) tenant
- An [Azure subscription](https://azure.microsoft.com/support/legal/offer-details)
- The appropriate [Azure role-based access control (RBAC)](/azure/role-based-access-control/overview) role assignments
- A [service principal](/cli/azure/create-an-azure-service-principal-azure-cli)
- A [configured client environment](https://github.com/Azure-Samples/azuresandbox#configure-client-environment)

For more information about how to prepare for a sandbox deployment, see [Prerequisites](https://github.com/Azure-Samples/azuresandbox#prerequisites).

To integrate [AzureSandbox](https://github.com/Azure-Samples/azuresandbox) with an [Azure landing zone](/azure/cloud-adoption-framework/ready/landing-zone), consider the following strategies:

- Place the sandbox subscription in the *Sandboxes* management group.
- Keep the sandbox isolated from your private network.
- Audit sandbox subscription activity.
- Limit sandbox access, and remove access when it's no longer required.
- Decommission sandboxes after an expiration period to control costs.
- Create a budget on sandbox subscriptions to control costs.

For more information, see [Landing zone sandbox environments](/azure/cloud-adoption-framework/ready/considerations/sandbox-environments).

To deploy Azure Sandbox, go to the [AzureSandbox](https://github.com/Azure-Samples/azuresandbox) GitHub repository and begin with [Getting started](https://github.com/Azure-Samples/azuresandbox#getting-started). For more information about how to deploy your sandbox environment, see [Default Sandbox Deployment](https://github.com/Azure-Samples/azuresandbox#perform-default-sandbox-deployment) and [known issues](https://github.com/Azure-Samples/azuresandbox#known-issues).

## Use cases

A sandbox is ideal for accelerating Azure projects. After you deploy your sandbox environment, you can add services and capabilities. You can use the sandbox for activities like:

- Self-learning
- Hackathons
- Testing
- Development
- Tabletop exercises
- Red team/blue team simulations
- Incident response drills

> [!IMPORTANT]
> Azure Sandbox isn't intended for production use. The deployment uses some best practices, but others intentionally aren't used in favor of simplicity and cost.

## Capabilities

Foundational prerequisites can block experimentation with certain Azure services or capabilities. A sandbox environment can accelerate your project by provisioning many of the mundane core infrastructure components. You can focus on the services or capabilities that you need to work with.

For example, you can use the following capabilities and configurations that the Azure Sandbox environment provides.

- Connect to a Windows jump box VM from the internet.
  - Option 1: Internet-facing access by using a web browser and Azure Bastion
  - Option 2: Point-to-site VPN connectivity through Virtual WAN
  
- Use a preconfigured Active Directory Domain Services local domain as a domain administrator.
  - Preconfigured integrated DNS server
  - Preconfigured integration with Azure private DNS zones
  - Preconfigured integration with Azure Private Link private endpoints

- Use an Azure Files preconfigured file share.

- Use a Windows jumpbox VM as a developer workstation.
  - Domain joined to local domain
  - Administer Active Directory and DNS with preinstalled Windows Server Remote Server Administration Tools (RSAT)
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

- Use a preconfigured SQL database or Azure Database for MySQL Flexible Server through private endpoints.

## Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

> [!IMPORTANT]
> Sandbox environments represent an attack surface that can be exploited. To reduce risk, consider the following security best practices.

- Implement strong authentication in the Microsoft Entra ID tenant associated with Azure subscriptions used to provision sandbox environments. Follow the recommendations in [SE:05 - Recommendations for identity and access management](/azure/well-architected/security/identity-access).
  - Use multifactor authentication (MFA) for all users.
  - Use Conditional Access policies to restrict access to sandbox environments.
  - Use integrated Microsoft Entra authentication to authorize access to Azure platform as a service (PaaS) services like SQL Database and Azure Storage.

- Start with a [least privilege approach](/azure/well-architected/security/identity-access#role-assignment) to authorize sandbox use.
  - Limit `Owner` Azure RBAC role assignments to sandbox subscription owners.
  - Limit `Contributor` Azure RBAC role assignments to sandbox subscription users.
  - Use Microsoft Entra Privileged Identity Management (PIM) to manage privileged Azure RBAC role assignments scoped to sandbox subscriptions, such as `Owner`, `Contributor`, and `User Access Administrator`.

- Maintain your [data classification](/azure/well-architected/security/data-classification) compliance. For example, avoid hosting personally identifiable information (PII) or other sensitive data in a sandbox environment. If you must use sensitive data, use synthetic data or de-identified data.

Also, consider the [Secure Futures Initiative](https://www.microsoft.com/microsoft-cloud/resources/secure-future-initiative) principles when you're designing and implementing sandbox environments. The [AzureSandbox](https://github.com/Azure-Samples/azuresandbox) implementation on GitHub showcases many of these principles.

### Secure by design

- Limit the use of [shared secrets](/azure/well-architected/security/application-secrets#preshared-keys) and use Azure Key Vault to secure them when required. When you have to use shared secrets, use managed identities at run time to retrieve from Key Vault. If secrets must be persisted, ensure that they're encrypted and not stored in plain text. Never echo secrets to the console or to log files, and never check secrets into source control.

- Set an expiration date for Key Vault secrets.

- When you select a guest operating system (OS) for VMs, only use OSs that are currently supported and eligible to receive security updates.

### Secure by default

- Use encryption as recommended by [SE:07 - Recommendations for data encryption](/azure/well-architected/security/encryption).
  - Ensure that cryptographic protocols and algorithms, such as TLS 1.2 or higher and SHA-256 or higher, are up to date.
  - Consider using host encryption or Azure Disk Encryption for encryption of data in transit. For managed disks attached to VMs, data is encrypted at rest by default.
- Avoid the use of public IP addresses. Use Azure Bastion for secure remote access to VMs.
- Use private endpoints to communicate with Azure services.
- Disable public network access to Azure services like Storage and SQL Database.
- Disable [default outbound access](/azure/virtual-network/ip-services/default-outbound-access) and use [Azure Firewall threat intelligence-based filtering](/azure/firewall/threat-intel).

### Secure operations

- Enable [Microsoft Defender for Cloud CSPM](/azure/defender-for-cloud/concept-cloud-security-posture-management) on sandbox subscriptions.

- Enable [Azure Update Manager](/azure/update-manager/overview) on all VMs that are used in sandbox environments. Set a regular patching schedule.

  - For SQL Server VMs, [enable first-party updates](/azure/update-manager/configure-wu-agent#enable-updates-for-other-microsoft-products) in Windows Update to ensure that SQL Server is patched.
  
- Monitor activity and diagnostic logs with [Azure Monitor](/azure/azure-monitor/overview) and [Microsoft Sentinel](/azure/sentinel/overview).

- Decommission individual sandbox resources and whole sandboxes that are no longer in use.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributor.*

Principal author:

- [Roger Doherty](https://www.linkedin.com/in/roger-doherty-805635b/)

 *To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Develop and test on Azure](https://azure.microsoft.com/solutions/dev-test/#overview)
- [Microsoft Cloud Adoption Framework](/azure/cloud-adoption-framework/)
- [Cloud Adoption Framework Azure setup guide](/azure/cloud-adoption-framework/ready/azure-setup-guide)
- [Microsoft Azure Well-Architected Framework](/azure/well-architected/)

## Related resources

- [Technology choices for Azure solutions](../technology-choices/technology-choices-overview.md)
- [Best practices for cloud applications](../../best-practices/index-best-practices.md)
- [Build applications on the Microsoft Cloud](../microsoft-cloud/overview.md)
