---
title: Securing data solutions
description: 
author: zoinerTejada
ms.date: 11/20/2019
ms.topic: guide
ms.service: architecture-center
ms.subservice: cloud-fundamentals
---

# Securing data solutions

For many, making data accessible in the cloud, particularly when transitioning from working exclusively in on-premises data stores, can cause some concern around increased accessibility to that data and new ways in which to secure it.

## Challenges

- Centralizing the monitoring and analysis of security events stored in numerous logs.
- Implementing encryption and authorization management across your applications and services.
- Ensuring that centralized identity management works across all of your solution components, whether on-premises or in the cloud.

## Data Protection

The first step to protecting information is identifying what to protect. Develop clear, simple, and well-communicated guidelines to identify, protect, and monitor the most important data assets anywhere they reside. Establish the strongest protection for assets that have a disproportionate impact on the organization's mission or profitability. These are known as high value assets, or HVAs. Perform stringent analysis of HVA lifecycle and security dependencies, and establish appropriate security controls and conditions. Similarly, identify and classify sensitive assets, and define the technologies and processes to automatically apply security controls.

Once the data you need to protect has been identified, consider how you will protect the data *at rest* and data *in transit*.

- **Data at rest**: Data that exists statically on physical media, whether magnetic or optical disk, on premises or in the cloud.
- **Data in transit**: Data while it is being transferred between components, locations or programs, such as over the network, across a service bus (from on-premises to cloud and vice-versa), or during an input/output process.

To learn more about protecting your data at rest or in transit, see [Azure Data Security and Encryption Best Practices](/azure/security/azure-security-data-encryption-best-practices).

## Access Control

Central to protecting your data in the cloud is a combination of identity management and access control. Given the variety and type of cloud services, as well as the rising popularity of [hybrid cloud](../scenarios/hybrid-on-premises-and-cloud.md), there are several key practices you should follow when it comes to identity and access control:

- Centralize your identity management.
- Enable Single Sign-On (SSO).
- Deploy password management.
- Enforce multi-factor authentication for users.
- Use role based access control (RBAC).
- Conditional Access Policies should be configured, which enhances the classic concept of user identity with additional properties related to user location, device type, patch level, and so on.
- Control locations where resources are created using resource manager.
- Actively monitor for suspicious activities

For more information, see [Azure Identity Management and access control security best practices](/azure/security/azure-security-identity-management-best-practices).

## Auditing

Beyond the identity and access monitoring previously mentioned, the services and applications that you use in the cloud should be generating security-related events that you can monitor. The primary challenge to monitoring these events is handling the quantities of logs , in order to avoid potential problems or troubleshoot past ones. Cloud-based applications tend to contain many moving parts, most of which generate some level of logging and telemetry. Use centralized monitoring and analysis to help you manage and make sense of the large amount of information.

For more information, see [Azure Logging and Auditing](/azure/security/azure-log-audit).

## Securing data solutions in Azure

### Encryption

**Virtual machines**. Use [Azure Disk Encryption](/azure/security/fundamentals/azure-disk-encryption-vms-vmss) to encrypt the attached disks on Windows or Linux VMs. This solution integrates with [Azure Key Vault](/azure/key-vault/) to control and manage the disk-encryption keys and secrets.

**Azure Storage**. Use [Azure Storage Service Encryption](/azure/storage/common/storage-service-encryption) to automatically encrypt data at rest in Azure Storage. Encryption, decryption, and key management are totally transparent to users. Data can also be secured in transit by using client-side encryption with Azure Key Vault. For more information, see [Client-Side Encryption and Azure Key Vault for Microsoft Azure Storage](/azure/storage/common/storage-client-side-encryption).

**SQL Database** and **Azure Synapse Analytics**. Use [Transparent Data Encryption](/sql/relational-databases/security/encryption/transparent-data-encryption-azure-sql) (TDE)  to perform real-time encryption and decryption of your databases, associated backups, and transaction log files without requiring any changes to your applications. SQL Database can also use [Always Encrypted](/azure/sql-database/sql-database-always-encrypted-azure-key-vault) to help protect sensitive data at rest on the server, during movement between client and server, and while the data is in use. You can use Azure Key Vault to store your Always Encrypted encryption keys.

### Rights management

[Azure Rights Management](/information-protection/understand-explore/what-is-azure-rms) is a cloud-based service that uses encryption, identity, and authorization policies to secure files and email. It works across multiple devices &mdash; phones, tablets, and PCs. Information can be protected both within your organization and outside your organization because that protection remains with the data, even when it leaves your organization's boundaries.

### Access control

Use [role-based access control](/azure/active-directory/role-based-access-control-what-is) (RBAC) to restrict access to Azure resources based on user roles. If you are using Active Directory on-premises, you can [synchronize with Azure AD](/azure/active-directory/active-directory-hybrid-identity-design-considerations-directory-sync-requirements) to provide users with a cloud identity based on their on-premises identity.

Use [Conditional access in Azure Active Directory](/azure/active-directory/active-directory-conditional-access-azure-portal) to enforce controls on the access to applications in your environment based on specific conditions. For example, your policy statement could take the form of: _When contractors are trying to access our cloud apps from networks that are not trusted, then block access_.

[Azure AD Privileged Identity Management](/azure/active-directory/active-directory-privileged-identity-management-configure) can help you manage, control, and monitor your users and what sorts of tasks they are performing with their admin privileges. This is an important step to limiting who in your organization can carry out privileged operations in Azure AD, Azure, Office 365, or SaaS apps, as well as monitor their activities.

### Network

To protect data in transit, always use SSL/TLS when exchanging data across different locations. Sometimes you need to isolate your entire communication channel between your on-premises and cloud infrastructure by using either a virtual private network (VPN) or [ExpressRoute](/azure/expressroute/). For more information, see [Extending on-premises data solutions to the cloud](../scenarios/hybrid-on-premises-and-cloud.md).

Use [network security groups](/azure/virtual-network/virtual-networks-nsg) to reduce the number of potential attack vectors. A network security group contains a list of security rules that allow or deny inbound or outbound network traffic based on source or destination IP address, port, and protocol.

Use [Virtual Network service endpoints](/azure/virtual-network/virtual-network-service-endpoints-overview) to secure Azure SQL or Azure Storage resources, so that only traffic from your virtual network can access these resources.

VMs within an Azure Virtual Network (VNet) can securely communicate with other VNets using [virtual network peering](/azure/virtual-network/virtual-network-peering-overview). Network traffic between peered virtual networks is private. Traffic between the virtual networks is kept on the Microsoft backbone network.

For more information, see [Azure network security](/azure/security/azure-network-security)

### Monitoring

[Azure Security Center](/azure/security-center/security-center-intro) automatically collects, analyzes, and integrates log data from your Azure resources, the network, and connected partner solutions, such as firewall solutions, to detect real threats and reduce false positives.

[Log Analytics](/azure/log-analytics/log-analytics-overview) provides centralized access to your logs and helps you analyze that data and create custom alerts.

[Azure SQL Database Threat Detection](/azure/sql-database/sql-database-threat-detection) detects anomalous activities indicating unusual and potentially harmful attempts to access or exploit databases. Security officers or other designated administrators can receive an immediate notification about suspicious database activities as they occur. Each notification provides details of the suspicious activity and recommends how to further investigate and mitigate the threat.
