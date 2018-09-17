---
title: "Azure Virtual Datacenter Concepts: Framework overview" 
description: An overview of the Azure Virtual Datacenter framework.
author: telmosampaio
---

# What is Azure Virtual Datacenter?

Azure Virtual Datacenter is a framework used to accelerate the adoption of Azure by enterprises that want to move their application estate to a cloud-based architecture while preserving key aspects of their current IT governance and taking advantage of cloud computing’s agility. 

There are very real, underlying differences between hosting in the cloud and running in a traditional datacenter. Achieving the level of governance in the cloud environment that you experience in a traditional datacenter requires a sound understanding of why you do what you do today, and how that is achieved in Azure.

Unlike your existing on-premises datacenter environment, the Azure public cloud operates using shared physical infrastructure and a software-defined environment abstraction. The Azure Virtual Datacenter framework allows you to structure isolated workloads in the Azure multitenant environment that meet your governance policies.

Governing your workloads requires integrating management processes, regulatory requirements, and security processes within a cloud environment. The Azure Virtual Datacenter framework provides basic guidance for creating an organization's separation of roles, responsibilities, and policies in the cloud. 

## Essential Concepts

A virtual datacenter is an isolated environment (like a building with walls) for cloud-hosted resources (like servers and networks) that support the application of organizational policies (like security and compliance). It starts with an Azure tenant, a representation of your organization in Azure; and a subscription, the doorway to the environment for deploying Azure resources and services.

A key tenet of the Azure Virtual Datacenter framework is to place as little trust as possible in the surrounding hosting environment. Therefore, the virtual datacenter must impose isolation, security, and compliance measures within its environment just as a physical datacenter would. The main difference is how these measures are implemented. Azure Virtual Datacenter relies on the following essential components:
 
![Compliance with security and policy is the foundation of the Azure Virtual Datacenter approach to trust, where automated auditing capabilities uncover potential issues.](/images/vdc-components.svg)

* **Software-defined networking** provides virtual abstractions for your physical network elements, such as network topologies, firewalls, intrusion detection mechanisms, load balancers, and routing policy. You can create, configure, and manage [network topologies, support isolation, and provision perimeter networks](networking-virtual-datacenter.md).

* **Identity management and role-based access control (RBAC)** govern [access to the computing, networking, data, and applications](/azure/active-directory/) in a virtual datacenter. Based on the least privilege model of access control, the virtual datacenter denies access to resources by default. Access must be explicitly granted to specific users, groups, or applications performing particular roles. 

* **Encryption** of data in transit, at rest, and in process is a requirement for most workloads in the enterprise today. Encryption isolates confidential information from the rest of the environment, including the underlying platform. Even virtual machines are booted with encryption. This conservative approach may not be needed for all Azure hosting scenarios but is a foundation of the virtual datacenter's intentionally strict trust model.

* **Compliance** drives trust and enables the enterprise to align with industry standards, legal and regulatory requirements, and security concerns. Azure infrastructure and services meet a broad set of international, industry-specific, and country-specific [compliance standards](https://www.microsoft.com/en-us/TrustCenter/Compliance/default.aspx). To help ensure the safety of your data, Microsoft also verifies how compliance is achieved through rigorous third-party audits that validate Azure’s adherence to standards-mandated security controls. In addition, virtual datacenters make extensive use of automated compliance monitoring, logging, and reporting systems, operational rigor, [transparency through audit reports](https://www.microsoft.com/en-us/trustcenter/about/transparency), and aggressive testing methods such as [red teaming](https://azure.microsoft.com/en-us/blog/red-teaming-using-cutting-edge-threat-simulation-to-harden-the-microsoft-enterprise-cloud/).

### A logical isolation for multiple workspaces

The virtual datacenter exists as a conceptual namespace grouping together all the resources you use within the virtual datacenter. This namespace serves as the virtual walls isolating your resources from other tenants on the platform and from the external Internet.

Workloads such as line-of business applications are hosted in separate, isolated workspaces. These workspaces provide the required infrastructure and management services to securely deploy workload resources and are quickly and easily instantiated to preserve developer agility. Workspaces adhere to the virtual datacenter's access control and policy standards, which can be augmented with additional workspace-specific rules. Workspaces are configured by policy to route all external traffic through the central IT infrastructure, where organizational policies can be applied. Multiple workloads can be deployed to a single workspace, or in separate, isolated workspaces. 
 
## A shared infrastructure of trust

To use a virtual datacenter as a trusted datacenter extension, you need to know the level of control you have over your resources and the degree of trust you place in specific elements of the platform. The underlying Azure platform takes on all the responsibilities for physical infrastructure maintenance and security. In a traditional on-premises datacenter, your organization would assume these responsibilities. In addition to handing off responsibility for the physical assets involved in a running a datacenter, you also need to be sure that you can [trust the Azure platform](https://www.microsoft.com/en-us/trustcenter) to provide you with the controls and management tools to build secure solutions in the multitenant cloud. 

### A global platform

Azure organizes its platform capabilities into geographic regions. Each contains one or more datacenters located in relative proximity to each other to support robust high availability and disaster recovery scenarios. A world map shows Azure datacenters (as of August 2018) on most every continent. This reach enables you to deliver your solutions close to your customers and employees and compete in even more geographic markets.
  
[The Azure platform is supported by a growing network of Azure-managed datacenters around the world.](images/concepts2-regions.png)

Azure datacenters contain physical network, compute, and storage devices like any traditional physical datacenter, just at hyper-scale. So at some level, the same facility maintenance, security, and access control requirements you already apply in your physical datacenter also apply to Azure datacenters. The main difference is that those requirements are managed by the Azure datacenter staff, rather than your own teams.

Because of Azure's global reach, data sovereignty can be an important concern that you didn't have to deal with when only maintining your on-premises infrastructure. Governance policies can be applied to your Azure subscriptions to ensure that resources are deployed only to regions that meet your data residency requirements. To see which Azure region is right for you, see the [Azure datacenters website](https://azure.microsoft.com/overview/datacenters).

### A regional infrastructure

For business continuity and disaster recovery scenarios, each Azure region is paired with complementary geo-political regions (for example, North Europe and West Europe regions). Regional pairs (with the exception of Brazil South and Southeast Asia/East Asia) offer the same data-residency and sovereignity for both members of the pair. Replicating resources across paired regions reduces the likelihood of natural disasters, civil unrest, power outages, or physical network outages affecting both regions at once.

Azure further breaks down regions into multiple [availability zones](/azure/availability-zones/az-overview)—low-latency, connected environments supporting highly available applications. Availability zones help protect against any potential outage within a specific datacenter in a region.

By default, resources in a virtual datacenter exist within a single Azure region, allowing components to connect with greater security and with minimum network latency. Just as you might replicate your physical datacenter to provide a high-availability infrastructure, instances of a virtual datacenter can be created in multiple regions. Applications executing within a workspace can take advantage of all Azure [high-availability features](../resiliency/high-availability-azure-applications.md) within a region and across regions. For example, using [Global VNet Peering](https://azure.microsoft.com/updates/global-vnet-peering-preview/), it is possible to extend the virtual datacenter across regions. Features such as SQL Database geo-replication also help to keep multiple instances of workloads in sync and available.
 
## Trust through isolation

One of the most basic resources in Azure is the virtual network (VNet). A VNet represents an isolated set of IP address spaces, similar to your on-premises network. You can create several VNets, and be assured that traffic does not pass from one VNet to another, unless you connect them using a peering connection, or VPN. Different Azure resources can be placed in VNet, such as VMs, AppService Environments, and service endpoints for Storage accounts, Azure KeyVault, SQLDB, and CosmosDB. 

VMs in a VNet are able to connect to the public Internet automatically, unless you secure that connectivity using a Network Security Group (NSG). Traffic initiated from the Internet to the VMs is only possible if the VM is associated with a Public IP address (PIP), an external load balancer (ELB) or an AppGateway. VNets can also be connected to your on-premises datacenters by using either a VPN connection, or an ExpressRoute circuit. 

VNets, VMs, load balancers, PIPs, and other Azure resources can be further secured by configuring locks. Read-only or delete locks can be placed on individual resources and collections called resource groups. For example, central IT administrators might apply a read-only lock to a virtual network, allowing users and other resources to use but not modify the network. Or a workspace owner could apply a delete lock to a virtual machine in the workspace to allow DevOps teams to configure the resource but not delete it.

Regardless of the level of isolation and security applied to a resource group or resource, any attempt to access, modify, or delete a resource leaves an audit trail. Azure Activity Log records all resource activity, including actions, actors, and if an action was successful.

Another way to isolate resources is to enable [just in time access control](/azure/security-center/security-center-just-in-time) of virtual machines. This recommended feature limits the amount of time a management endpoint attached to a virtual machine remains open. Locking down inbound traffic in this way is particularly important for any virtual machines used to perform broad management functions within the virtual datacenter.

As with an on-premises datacenter, regular security tests should be run against Azure–hosted resources, using both automated processes and manual review. These tests should always include port scanning, penetration testing, and fuzz testing. [Azure Security Center](https://azure.microsoft.com/en-us/services/security-center/) provides threat prevention, detection, and response capabilities that are built in to Azure, including and includes risk-mitigation tools such as endpoint protection for virtual machine anti-malware protection.

See also
* [Introduction to Azure Security](/azure/security/azure-security)
* [Isolation in the Public Cloud](/azure/security/azure-isolation)
* [Azure network security](/azure/security/azure-network-security)
* [Azure Virtual Machine security overview](/azure/security/security-virtual-machines-overview)
* [Azure Storage security guide](/azure/storage/common/storage-security-guide?toc=/azure/storage/files/toc.json)
* [Microsoft Trust Center: Design and operational security](https://www.microsoft.com/en-us/trustcenter/security/designopsecurity)

## Trust through encryption

The Azure Virtual Datacenter model makes global encryption a critical priority. All data must be encrypted at all times—while in transit and at rest.

[Azure Key Vault](https://azure.microsoft.com/services/key-vault/) is the primary mechanism for storing and managing the keys, secrets, and certificates associated with encryption, authentication, and cryptographic non-repudiation processes within a virtual datacenter.

All cryptographic keys, connection strings, certificates, and other secrets used by applications or resources in a virtual datacenter must be stored and managed as well. Key Vault supports a FIPS 140-2 Level 2-validated hardware security model (HSM), and allows you to [generate keys using your on-premises HSM and securely transfer them to Key Vault](/azure/key-vault/key-vault-hsm-protected-keys). 

Keys stored in Key Vault can also be used to encrypt storage assets, and to help secure PaaS services or individual applications. For example, a database connection string can be stored in Key Vault instead of an application's configuration files or environment variables. Authorized applications and services within Azure Virtual Datacenter can use, but not modify, keys stored in Key Vault. Only key owners can make changes to keys stored in Key Vault.

### Data in transit

The Azure Virtual Datacenter model uses encryption to enforce isolation of data as it moves between:

* On-premises networks and the virtual datacenter. Data passes through either an encrypted site-to-site virtual private network (VPN) connection or an isolated, private ExpressRoute.

* Applications running in a different virtual datacenter (that is, from one virtual datacenter to another).

* Applications running in the same Azure virtual datacenter.

* Platform services, including both internal and external endpoints—storage accounts, databases, and management APIs.

In these scenarios, the Azure Virtual Datacenter approach is to use the SSL/TLS protocols to exchange data between both the virtual datacenter and application components. All network traffic has some degree of encryption applied at all times. In addition, all communication between internal Azure components within the virtual datacenter are protected using SSL/TLS, enforced by a firewall in the central IT infrastructure.

### Data at rest

Data at rest is also encrypted, including data stored on [Azure Storage](https://azure.microsoft.com/services/storage/) and in relational databases, which may offer additional encryption. For example, Azure SQL Database includes [Transparent Data Encryption (TDE)](/azure/sql-database/sql-database-security-overview).

The central IT infrastructure uses Azure Storage for several tasks, such as storing logs. [Azure Storage Service Encryption (SSE)](/azure/storage/common/storage-service-encryption) provides encryption at rest for all Azure Storage services by encrypting data before writing it to storage. SSE decrypts the data immediately prior to retrieval. SSE-enabled Azure Storage accounts can handle encryption, decryption, and key management in a totally transparent fashion. All data is encrypted using 256-bit AES encryption, and both Microsoft-managed and customer-managed encryption keys are supported. 

Virtual machine disk image encryption is also a critical part of ensuring isolation and virtual machine security within a shared tenant environment. The Azure Virtual Datacenter model depends on the platform's ability to securely create, host, and access virtual machines with encrypted disks. Azure supports two models for encrypting virtual machines: 

* For virtual machines created in Azure, you can use [Azure Disk Encryption](/azure/security/azure-security-disk-encryption). The BitLocker feature of Windows and the DM-Crypt feature of Linux provide volume encryption for the operating system and data disks. The Azure Marketplace contains hundreds of preconfigured virtual machine images that you can quickly deploy and encrypt.

* You can also use pre-encrypted virtual machines created using your on-premises Hyper-V hosts, using DM-Crypt or BitLocker with your internal policies and configuration. After validating an image on-premises, you can then upload the relevant internally managed keys to your Key Vault instance, then deploy the pre-encrypted VHD disk images as Azure virtual machines.

### Data in process

Another near-term addition to the Azure platform is support for [Confidential Computing](https://azure.microsoft.com/en-us/blog/introducing-azure-confidential-computing/) through Trusted Execution Environments (TEE) using technologies such as enclaves. Intel Secure Guard Extensions (SGX) and other enclave technologies allow developers to create secure, trusted execution environments. Enclaves provide an encrypted area for data and code that can only be processed by CPU-based security mechanisms in the process-embedded TEE. 
Microsoft is also investing in cryptographic research. For example, [homomorphic encryption (HE)](https://www.microsoft.com/en-us/research/project/homomorphic-encryption/) can be used to encrypt stored data so that storage can be outsourced to an untrusted cloud. Applications can make use of HE data as is without first decrypting it. For more information about using HE in a bioinformatics context, see the paper from Microsoft Research, [Manual for Using Homomorphic Encryption for Bioinformatics](https://www.microsoft.com/en-us/research/publication/manual-for-using-homomorphic-encryption-for-bioinformatics/).

See also
* [Encryption in the Microsoft Cloud](https://www.microsoft.com/en-us/download/details.aspx?id=55848)
* [What is Azure Key Vault?](/azure/key-vault/key-vault-whatis)
* [Azure Storage Service Encryption for Data at Rest](/azure/storage/common/storage-service-encryption)
* [Azure Disk Encryption for Windows and Linux IaaS VMs](/azure/security/azure-security-disk-encryption)

## Trust through identity 

In the multitenant cloud environment, a tenant provides the first layer of isolation through identity by association with Azure Active Directory (Azure AD). Azure AD isolates identity information and provides authentication for accessing a subscription and its resources. Azure AD can also support [Azure Multi-Factor Authentication (MFA)](/azure/multi-factor-authentication/multi-factor-authentication), which provides a highly recommended second layer of authentication security. 

Azure AD roles are essential for a virtual datacenter using Role-Based Access Control (RBAC). RBAC is used for controlling management access to resources such as services, virtual machines, storage, and databases. RBAC can enable access to a resource for an individual Azure AD user or group, or an Azure AD role. However, the settings within a resource are often governed by that resource's internal configuration, not RBAC. For example, access to the guest operating system of a virtual machine is configured within the operating system.

In a virtual datacenter, you can create multiple Azure AD instances to provide additional layers of access isolation. Federation with other existing Azure AD instances is supported as is integration with an existing on-premises deployment of Active Directory or other external identity services.

### Roles and RBAC

Virtual datacenters, like their physical counterparts, need groups of people to take on assorted responsibilities or roles, and these roles need access to various resources. Some roles aren’t needed—facilities management and physical security, for example. But many other virtual datacenter responsibilities such as network security and operations work much like they do in a physical datacenter.

To manage access to resources efficiently and securely, Azure Virtual Data Center implements RBAC. Jobs and responsibilities are organized into Azure AD roles, to which users are assigned.

By defining organizational roles, you can specify the access rights to specific Azure resources and give subscription management rights to users and groups assigned to a role. The scope of a role can encompass an Azure subscription, resource group, or single resource level. RBAC also supports the inheritance of permissions, so a role assigned at a parent level also grants access to the children contained within it.

RBAC gives you a way to assign different teams to various management tasks within a virtual datacenter. Central IT control over core access and security features can be paired with a distributed approach to access that gives software developers and other teams large amounts of control over specific workloads.

### The least privilege access model

Azure Virtual Data Center emphasizes the least privilege model of access control. Access to resources is denied by default and must be explicitly granted. Using RBAC, you can grant users, groups, and even applications only the access they need to perform a job. For example, you can fine-tune RBAC settings to permit one employee to manage only the virtual machines in a subscription while another can manage only databases in the same subscription.

Besides using RBAC roles to implement a least privilege access model, [Azure AD Privileged Identity Management (PIM)](/azure/active-directory/privileged-identity-management/azure-pim-resource-rbac) lets you specify roles that can be activated Just in Time (JIT), forcing users to request elevation prior to using management rights over Azure resources.  
 
## Trust through compliance, logs and reporting

When it comes to compliance, logs, and reporting, Microsoft is building products to make customers’ lives easier. Microsoft provides a portfolio of services that help your enterprise monitor security, compliance, and change management for both Azure and on-premises resources. The virtual datacenter framework uses multiple services from this portfolio to create a holistic view of your datacenter.

### Azure Policy

[Azure Policy](/azure/azure-policy/azure-policy-introduction) is a service e you can use to create and manage policies used to enforce different rules and effects over resources, so that those resources stay compliant with your own enterprise control set. Policies can be used to restrict what resources can be created in an Azure subscription, what Azure regions can be used, and what tags must be applied to resources.

The Virtual Datacenter frameworks defines a process on how to define policies based on your enterprise’s control sets. Keep in mind that not all controls in a control set can be mapped to policies alone. Some controls need to be implemented as a combination of policies, RBAC roles, and other Azure constructs.

### Azure Security Center

### Log Analytics

### Compliance Manager

The Azure platform has the largest compliance portfolio in the industry and continues to grow every year. However, while Microsoft implements compliance measures at the platform level, you must also do your part within the applications you create on the platform.

The Microsoft [Compliance Manager](https://servicetrust.microsoft.com/) tool provides transparency into the controls managed by the platform and the controls you are responsible for managing. The tool also helps you understand compliance for those controls. Whether that involves a configuration on the platform such as encryption or multi-factor authentication or a knowledgebase article on a process like role assignments, the goal is the same. 

> [!div class="nextstepaction"]
> [Compose trustworhty datacenter](trustworthy-datacenter.md)