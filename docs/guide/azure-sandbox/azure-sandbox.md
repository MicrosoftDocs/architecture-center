---
title: Azure Sandbox
description: Accelerate your Azure project by using a fully functional sandbox environment that includes virtual networks, virtual machines, and databases.
author: doherty100
ms.author: rdoherty
ms.date: 08/24/2025
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom: arb-devops
---

# Azure Sandbox

Azure Sandbox is a Terraform-based project designed to simplify the deployment of sandbox environments in Azure. It provides a modular and reusable framework for implementing foundational infrastructure, which can accelerate the development of innovative new solutions in Azure.

The Azure Sandbox is composed of modular components that you can deploy individually or together, depending on your needs. Because a fully provisioned environment might be costly, you can manage expenses by stopping or deallocating virtual machines (VMs) when they're not in use or by deploying only the following modules that are essential for your scenario. Costs vary depending on your Azure subscription type and region.
  
## Architecture

:::image type="complex" border="false" source="images/create-azure-sandbox.svg" alt-text="Diagram that shows the Azure Sandbox environment." lightbox="images/create-azure-sandbox.svg":::
   The diagram contains multiple sections arranged vertically. The top section shows an Azure subscription boundary. Inside that is a rectangle that encloses most of the image elements that reads rg-sandbox-01. Automation account and Log Analytics workspace are included in this section. There are two rectangles within the subscription and three smaller rectangles near the bottom. The left rectangle labeled vnet-shared-01 (10.1.0.0/16) contains Azure Bastion host, Azure Firewall, adds1, and vault icons. The right rectangle is labeled vnet-app-01 (10.2.0.0/16) and contains jumpwin1, jumplinux1, mssqlwin1, blob, file, sqlServer, and mysqlServer icons. A bidirectional arrow labeled Peering connects the left and right rectangles. A line labeled Public IP address connects Bastion host to the cloud icon. A line labeled Public IP address connects Azure Firewall to the cloud icon. A line labeled Point-to-site VPN connects vwan-xx (10.3.0./16) to the cloud icon. A bidirectional arrow connects Key vault and the vault icon. A bidirectional arrow connects adds1 and vwan-xx (10.3.0./16). At the bottom are three rectangles that contain icons labeled vhub-xx (10.4.0.0/16), testdb (SQL), and testdb (My). Peering arrows connect these boxes to the vnet-app-01 (10.2.0.0/16) section. A bidirectional arrow connects the snet-privatelink-01 (10.2.2.0/24) section to Storage account.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/create-an-azure-sandbox.vsdx) of this architecture.*

### Components

You can deploy each of the following sandbox configurations or only the configurations that you need:

- [Active Directory Domain Services](/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview) is a Windows Server VM that runs Active Directory Domain Services (AD DS). In this architecture, it provides centralized authentication, domain joining for VMs, and policy management across the sandbox environment.

- [Application virtual network](/azure/virtual-network/virtual-networks-overview) is a separate virtual network that hosts application workloads and databases. In this architecture, it provides network isolation for test applications while enabling secure communication with shared services through virtual network peering.

- [Azure Bastion](/azure/bastion/bastion-overview) is a managed service that provides secure Remote Desktop Protocol (RDP) and Secure Shell (SSH) access to VMs without public IP addresses. In this architecture, it enables secure remote access to sandbox VMs directly through the Azure portal while minimizing the attack surface.

- [Azure Database for MySQL flexible server](/azure/mysql/flexible-server/overview) is a managed MySQL database service that supports private networking. In this architecture, it provides a database platform for testing open-source applications while demonstrating private endpoint connectivity patterns.

- [Azure Files](/azure/well-architected/service-guides/azure-files) is a fully managed file share service that you can access via Server Message Block (SMB) protocol. In this architecture, it provides shared storage for both Windows and Linux VMs while hosting scripts and configuration files.

- [Azure Firewall](/azure/well-architected/service-guides/azure-firewall) is a cloud-native firewall service that provides threat intelligence. In this architecture, it controls traffic between virtual networks and the internet, which enforces network segmentation and security policies across the sandbox environment.

- [Azure SQL Database](/azure/well-architected/service-guides/azure-sql-database-well-architected-framework) is a fully managed relational database service. In this architecture, it demonstrates modern cloud-native database patterns and is accessed via private endpoints to simulate secure enterprise architectures.

- [Azure Virtual WAN](/azure/virtual-wan/virtual-wan-about) is a networking service that provides secure remote connectivity. In this architecture, it provides point-to-site VPN access for developers and administrators who need full network connectivity to sandbox resources from remote locations.

- [Linux jump box](/azure/virtual-machines/linux/overview) is a domain-joined Linux VM that's preloaded with DevOps tools, including Azure CLI, PowerShell, and Terraform. In this architecture, it serves as a DevOps automation platform and demonstrates cross-platform domain integration scenarios.

- [Shared services virtual network](/azure/virtual-network/virtual-networks-overview) is a dedicated virtual network that hosts centralized infrastructure services. In this architecture, it provides the network foundation for domain controllers, Domain Name System (DNS) services, and shared security services that support the entire sandbox environment.

- [SQL Server on Azure Virtual Machines](/azure/azure-sql/virtual-machines/windows/sql-server-on-azure-vm-iaas-what-is-overview) is a Windows VM that runs SQL Server with full administrative control. In this architecture, it supports testing of legacy applications and custom SQL configurations that require specific database engine features.

- [Windows Server jump box](/samples/azure/azure-quickstart-templates/vmss-windows-jumpbox) is a domain-joined Windows VM that provides administrative tools, including Remote Server Administration Tools (RSAT), Azure Storage Explorer, and SQL Server Management Studio. In this architecture, it provides a secure management platform for administering sandbox resources and demonstrates traditional Windows administration patterns.

## Deploy the sandbox

The Azure Sandbox environment requires the following prerequisites:

- A [Microsoft Entra ID](/entra/fundamentals/what-is-entra#microsoft-entra-id) tenant

- An [Azure subscription](https://azure.microsoft.com/support/legal/offer-details)

- The appropriate [Azure role-based access control (Azure RBAC)](/azure/role-based-access-control/overview) role assignments

- A [service principal](/cli/azure/create-an-azure-service-principal-azure-cli)

- A [Terraform execution environment](https://github.com/Azure-Samples/azuresandbox?tab=readme-ov-file#terraform-execution-environment)

For more information about how to prepare for a sandbox deployment, see [Prerequisites](https://github.com/Azure-Samples/azuresandbox?tab=readme-ov-file#prerequisites).

To integrate [AzureSandbox](https://github.com/Azure-Samples/azuresandbox) with an [Azure landing zone](/azure/cloud-adoption-framework/ready/landing-zone), consider the following strategies:

- Place the sandbox subscription in the **Sandboxes** management group.
- Keep the sandbox isolated from your private network.
- Audit sandbox subscription activity.
- Limit sandbox access, and remove access when it's no longer required.
- Decommission sandboxes after an expiration period to control costs.
- Create a budget on sandbox subscriptions to control costs.

For more information, see [Landing zone sandbox environments](/azure/cloud-adoption-framework/ready/considerations/sandbox-environments).

To deploy Azure Sandbox, go to the [AzureSandbox](https://github.com/Azure-Samples/azuresandbox) GitHub repository and begin with [Get started - Interactive execution](https://github.com/Azure-Samples/azuresandbox?tab=readme-ov-file#getting-started-interactive-execution).

## Use cases

A sandbox is ideal for accelerating Azure projects. After you deploy your sandbox environment, you can add services and capabilities. You can use the sandbox for various activities:

- Self-learning
- Hackathons
- Testing
- Development
- Tabletop exercises
- Red team/blue team simulations
- Incident response drills

> [!IMPORTANT]
> Azure Sandbox isn't intended for production use. The deployment uses some best practices, but other best practices intentionally aren't used in favor of simplicity and cost.

## Capabilities

Foundational prerequisites can block experimentation with specific Azure services or capabilities. A sandbox environment can accelerate your project by provisioning many of the mundane core infrastructure components. You can focus on the services or capabilities relevant to your scenario.

For example, you can use the following capabilities and configurations that the Azure Sandbox environment provides.

- Connect to a Windows jump box VM from the internet.

  - **Option 1:** Internet-facing access by using a web browser and Azure Bastion

  - **Option 2:** Point-to-site VPN connectivity through Virtual WAN
  
- Use a preconfigured AD DS local domain as a domain administrator.

  - Preconfigured integrated DNS server

  - Preconfigured integration with Azure private DNS zones

  - Preconfigured integration with Azure Private Link private endpoints

- Use an Azure Files preconfigured file share.

- Use a Windows jump box VM as a developer workstation.

  - Domain joined to local domain

  - Administer Active Directory and DNS with preinstalled Windows Server RSAT

  - Visual Studio Code preinstalled with Remote-SSH into a Linux jump box

  - Storage Explorer and AzCopy preinstalled

  - SQL Server Management Studio preinstalled

  - MySQL Workbench preinstalled

- Use a Linux jump box VM as a DevOps agent.

  - Domain joined to local domain by using Winbind

  - Azure CLI, PowerShell, and Terraform preinstalled

  - Dynamic Common Internet File System (CIFS) mount to Azure Files preconfigured file share

- Use a preconfigured SQL Server VM.

  - Domain joined to local domain

- Use a preconfigured SQL database or Azure Database for MySQL flexible server through private endpoints.

## Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

> [!IMPORTANT]
> Sandbox environments represent an attack surface that can be exploited. To reduce risk, consider the following security best practices.

- Implement strong authentication in the Microsoft Entra ID tenant associated with the Azure subscriptions that you use to provision sandbox environments. Follow the recommendations in [SE:05 - Recommendations for identity and access management](/azure/well-architected/security/identity-access).

  - Use multifactor authentication (MFA) for all users.

  - Use conditional access (CA) policies to restrict access to sandbox environments.

  - Use integrated Microsoft Entra authentication to authorize access to Azure platform as a service (PaaS) services like SQL Database and Azure Storage.

- Start with a [least privilege approach](/azure/well-architected/security/identity-access#role-assignment) to authorize sandbox use.

  - Limit `Owner` Azure RBAC role assignments to sandbox subscription owners and users.

  - Use Microsoft Entra Privileged Identity Management (PIM) to manage privileged Azure RBAC role assignments scoped to sandbox subscriptions, such as `Owner`, `Contributor`, and `User Access Administrator`.

- Maintain your [data classification](/azure/well-architected/security/data-classification) compliance. For example, avoid hosting personal data or other sensitive data in a sandbox environment. If you must use sensitive data, use synthetic data or de-identified data.

Also, consider the [Secure Futures Initiative](https://www.microsoft.com/microsoft-cloud/resources/secure-future-initiative) principles when you design and implement sandbox environments. The [AzureSandbox](https://github.com/Azure-Samples/azuresandbox) implementation on GitHub showcases many of these principles.

### Secure by design

- Limit the use of [shared secrets](/azure/well-architected/security/application-secrets#preshared-keys) and use Azure Key Vault to secure them. When you have to use shared secrets, use managed identities at run time to retrieve them from Key Vault. If secrets must be persisted, ensure that they're encrypted and not stored in plain text. Never echo secrets to the console or to log files, and never check secrets into source control.

- Set an expiration date for Key Vault secrets.

- When you select a guest operating system for VMs, only use operating systems that are currently supported and eligible to receive security updates.

### Secure by default

- Use encryption as recommended by [SE:07 - Recommendations for data encryption](/azure/well-architected/security/encryption).

  - Ensure that cryptographic protocols and algorithms, such as TLS 1.2 or higher and SHA-256 or higher, are up-to-date.

  - Consider using host encryption or Azure Disk Encryption for encryption of data in transit. For managed disks attached to VMs, data is encrypted at rest by default.

- Avoid the use of public IP addresses. Use Azure Bastion for secure remote access to VMs.

- Use private endpoints to communicate with Azure services.

- Disable public network access to Azure services like Key Vault, Azure Storage, and SQL Database.

- Disable [default outbound access](/azure/virtual-network/ip-services/default-outbound-access) and use [Azure Firewall threat intelligence-based filtering](/azure/firewall/threat-intel).

### Secure operations

- Enable [Microsoft Defender Cloud Security Posture Management](/azure/defender-for-cloud/concept-cloud-security-posture-management) on sandbox subscriptions.

- Enable [Azure Update Manager](/azure/update-manager/overview) on all VMs that are used in sandbox environments. Set a regular patching schedule.

  - For SQL Server VMs, [enable updates for other Microsoft products](/azure/update-manager/configure-wu-agent#enable-updates-for-other-microsoft-products) in Windows Update to ensure that SQL Server is patched.
  
- Monitor activity and diagnostic logs by using [Azure Monitor](/azure/azure-monitor/overview) and [Microsoft Sentinel](/azure/sentinel/overview).

- Decommission individual sandbox resources and whole sandboxes that are no longer in use.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Roger Doherty](https://www.linkedin.com/in/roger-doherty-805635b/)

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Set up identity in Azure](/azure/cloud-adoption-framework/ready/azure-setup-guide/identity)
- [Develop and test on Azure](https://azure.microsoft.com/solutions/dev-test/#overview)
- [Microsoft Cloud Adoption Framework](/azure/cloud-adoption-framework/)
- [Azure Well-Architected Framework](/azure/well-architected/)

## Related resources

- [Best practices for cloud applications](../../best-practices/index-best-practices.md)
- [Build applications on the Microsoft Cloud](/microsoft-cloud/dev/overview/introduction)
- [Technology choices for Azure solutions](../technology-choices/technology-choices-overview.md)
