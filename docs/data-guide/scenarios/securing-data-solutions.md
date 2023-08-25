---
title: Secure data solutions
description: Learn about data protection, access control, auditing, and Azure services and tools that help you secure data assets.
author: martinekuan
ms.author: architectures
categories: azure
ms.date: 07/25/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
azureCategories:
  - analytics
  - compute
  - databases
  - management and governance
  - security
  - storage
products:
  - azure-sql-database
  - azure
  - azure-firewall
  - azure-monitor
  - defender-for-cloud
ms.custom:
  - guide
---

# Secure data solutions

For many organizations, making data accessible in the cloud, particularly when transitioning from working exclusively in on-premises data stores, can cause some concern around increased accessibility to that data and new ways in which to secure it.

## Challenges

- Centralizing the monitoring and analysis of security events stored in numerous logs
- Implementing encryption and authorization management across your applications and services
- Ensuring that centralized identity management works across all your solution components, whether on-premises or in the cloud

## Data protection

The first step to protecting information is identifying what to protect. Develop clear, simple, and well-communicated guidelines to identify, protect, and monitor the most important data assets anywhere they reside. Establish the strongest protection for assets that have a disproportionate impact on your organization's mission or profitability. These types of assets are known as high value assets (HVAs). Perform stringent analysis of HVA lifecycle and security dependencies, and establish appropriate security controls and conditions. Similarly, identify and classify sensitive assets, and define the technologies and processes to automatically apply security controls.

After you've identified the data you need to protect, consider how to protect the data *at rest* and *in transit*.

- **Data at rest** exists statically on physical media, whether magnetic or optical disk, on-premises or in the cloud.
- **Data in transit** is being transferred between components, locations, or programs, such as over the network, across a service bus (from on-premises to cloud and vice versa), or during an input/output process.

To learn more about protecting your data at rest or in transit, see [Azure data security and encryption best practices](/azure/security/azure-security-data-encryption-best-practices).

## Access control

Central to protecting your data in the cloud is a combination of identity management and access control. Given the variety and type of cloud services, and also the rising popularity of [hybrid clouds](../scenarios/hybrid-on-premises-and-cloud.md), there are several key practices you should follow when it comes to identity and access control:

- Centralize your identity management.
- Enable single sign-on (SSO).
- Deploy password management.
- Enforce multifactor authentication for users.
- Use Azure role-based access control (RBAC).
- Configure conditional access policies. These policies enhance the classic concept of user identity with additional properties related to user location, device type, patch level, and so on.
- Control locations where resources are created by using Azure Resource Manager.
- Actively monitor for suspicious activities.

For more information, see [Azure identity management and access control security best practices](/azure/security/azure-security-identity-management-best-practices).

## Auditing

Beyond the identity and access monitoring previously mentioned, the services and applications that you use in the cloud should generate security-related events that you can monitor. The primary challenge to monitoring these events is handling the quantities of logs. Logs are needed to avoid potential problems or troubleshoot past ones. Cloud-based applications tend to contain many moving parts, most of which generate some level of logging and telemetry. Use centralized monitoring and analysis to help manage and make sense of the large amount of information.

For more information, see [Azure logging and auditing](/azure/security/azure-log-audit).

## Secure data solutions in Azure

The following sections describe various ways of securing data in Azure.

### Encryption

**Virtual machines (VMs)**. Use [Azure disk encryption](/azure/security/fundamentals/azure-disk-encryption-vms-vmss) to encrypt the attached disks on Windows or Linux VMs. This solution integrates with [Azure Key Vault](/azure/key-vault) to control and manage disk-encryption keys and secrets.

**Azure Storage**. Use [Storage service encryption](/azure/storage/common/storage-service-encryption) to automatically encrypt data at rest in Storage. Encryption, decryption, and key management are completely transparent to users. Data can also be secured in transit by using client-side encryption with Key Vault. For more information, see [Client-side encryption and Azure Key Vault for Microsoft Azure Storage](/azure/storage/common/storage-client-side-encryption).

**Azure SQL Database** and **Azure Synapse Analytics**. Use [transparent data encryption](/sql/relational-databases/security/encryption/transparent-data-encryption-azure-sql) (TDE) to perform real-time encryption and decryption of your databases, associated backups, and transaction log files without requiring any changes to your applications. SQL Database can also use [Always Encrypted](/azure/sql-database/sql-database-always-encrypted-azure-key-vault) to help protect sensitive data at rest on the server, during movement between client and server, and while the data is in use. You can use Key Vault to store your Always Encrypted encryption keys.

### Rights management

[Azure Rights Management](/information-protection/understand-explore/what-is-azure-rms) is a cloud-based service that uses encryption, identity, and authorization policies to secure files and email. It works across multiple devices, such as phones, tablets, and PCs. Information can be protected both within your organization and outside your organization because that protection remains with the data, even when it leaves your organization's boundaries.

### Access control

Use [Azure RBAC](/azure/role-based-access-control/overview) to restrict access to Azure resources based on user roles. If you use Active Directory on-premises, you can [synchronize with Azure Active Directory (Azure AD)](/azure/active-directory/active-directory-hybrid-identity-design-considerations-directory-sync-requirements) to provide users with a cloud identity based on their on-premises identity.

Use [conditional access in Azure AD](/azure/active-directory/active-directory-conditional-access-azure-portal) to enforce controls on the access to applications in your environment based on specific conditions. For example, your policy statement could take the form of: *When contractors try to access our cloud apps from networks that aren't trusted, block access*.

[Azure AD privileged identity management](/azure/active-directory/active-directory-privileged-identity-management-configure) can help you manage, control, and monitor your users and the tasks they perform with their admin privileges. This capability is an important step to limiting who in your organization can carry out privileged operations in Azure AD, Azure, Microsoft 365, or software as a service (SaaS) apps. It can also monitor user activity.

### Network

To protect data in transit, always use SSL/TLS when you exchange data across different locations. Sometimes you need to isolate your entire communication channel between your on-premises and cloud infrastructure by using either a virtual private network (VPN) or [ExpressRoute](/azure/expressroute). For more information, see [Extending on-premises data solutions to the cloud](../scenarios/hybrid-on-premises-and-cloud.md).

Use [network security groups](/azure/virtual-network/virtual-networks-nsg) to reduce the number of potential attack vectors. A network security group contains a list of security rules that allow or deny inbound or outbound network traffic based on source or destination IP address, port, and protocol.

Use [virtual network service endpoints](/azure/virtual-network/virtual-network-service-endpoints-overview) to secure Azure SQL or Storage resources, so that only traffic from your virtual network can access these resources.

VMs within an Azure virtual network can securely communicate with other virtual networks by using [virtual network peering](/azure/virtual-network/virtual-network-peering-overview). Network traffic between peered virtual networks is private. Traffic between the virtual networks is kept on the Microsoft backbone network.

For more information, see [Azure network security](/azure/security/azure-network-security)

### Monitoring

[Defender for Cloud](/azure/security-center/security-center-intro) automatically collects, analyzes, and integrates log data from your Azure resources, the network, and connected partner solutions, such as firewall solutions, to detect real threats and reduce false positives.

The [Log Analytics](/azure/log-analytics/log-analytics-overview) feature of Azure Monitor provides centralized access to your logs and helps you analyze that data and create custom alerts.

[Azure SQL Database threat detection](/azure/sql-database/sql-database-threat-detection) detects anomalous activities indicating unusual and potentially harmful attempts to access or exploit databases. Security officers or other designated administrators can receive an immediate notification about suspicious database activities as they occur. Each notification provides details of the suspicious activity and recommends how to further investigate and mitigate the threat.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Zoiner Tejada](https://www.linkedin.com/in/zoinertejada) | CEO and Architect

## Next steps

- [Azure data security and encryption best practices](/azure/security/fundamentals/data-encryption-best-practices)
- [Azure Identity Management and access control security best practices](/azure/security/fundamentals/identity-management-best-practices)
- [Azure security logging and auditing](/azure/security/fundamentals/log-audit)
- [Microsoft Azure Well-Architected Framework - Security](/training/modules/azure-well-architected-security)
- [Prepare for cloud security by using the Microsoft Cloud Adoption Framework for Azure](/training/modules/cloud-adoption-framework-security)
- [Describe basic security capabilities in Azure](/training/modules/describe-basic-security-capabilities-azure)

## Related resources

- [Resilient identity and access management with Azure AD](../../guide/resilience/resilience-overview.yml)
- [Monitor hybrid security using Microsoft Defender for Cloud and Microsoft Sentinel](../../hybrid/hybrid-security-monitoring.yml)
- [Confidential computing on a healthcare platform](../../example-scenario/confidential/healthcare-inference.yml)
- [SQL Managed Instance with customer-managed keys](../../example-scenario/data/sql-managed-instance-cmk.yml)
- [Improved-security access to multitenant web apps from an on-premises network](../../web-apps/guides/networking/access-multitenant-web-app-from-on-premises.yml)
