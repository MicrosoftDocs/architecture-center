[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This solution provides a multilayered approach for protecting virtual machines (VMs) in Azure. Users need to connect to VMs for management and administrative purposes. It's critical to minimize the attack surface that connectivity creates.

This solution achieves non-persistent granular access to VMs by incorporating several protection mechanisms. It aligns with the *principle of least privilege (PoLP)* and the concept of *separation of duties*. To reduce exposure to attacks, this solution locks down inbound traffic to VMs, but it makes VM connections accessible when needed. Implementing this type of protection minimizes the risk of many popular cyber attacks on VMs, such as brute-force attacks and distributed denial-of-service (DDoS) attacks.

This solution uses many Azure services and features including:

- Azure Active Directory (Azure AD) Privileged Identity Management (PIM).
- The just-in-time (JIT) VM access feature of Microsoft Defender for Cloud.
- Azure Bastion.
- Azure role-based access control (Azure RBAC) custom roles.
- Azure AD Conditional Access, optionally.

## Potential use cases

*Defense in depth* is the main idea behind this architecture. This strategy challenges users with several lines of defense before granting the users access to VMs. The goal is to ensure that:

- Each user is legitimate.
- Each user has legal intentions.
- Communication is secure.
- Access to VMs in Azure is only provided when needed.

The defense in depth strategy and the solution in this article apply to many scenarios:

- An administrator needs to access an Azure VM under these circumstances:

  - The administrator needs to troubleshoot an issue, investigate behavior, or apply a critical update.
  - The administrator uses Remote Desktop Protocol (RDP) to access a Windows VM or secure shell (SSH) to access a Linux VM.
  - The access should include the minimum number of permissions that the work requires.
  - The access should be valid for only a limited time.
  - After the access expires, the system should lock down the VM access to prevent malicious access attempts.

- Employees need access to a remote workstation that's hosted in Azure as a VM. The following conditions apply:

  - The employees should access the VM only during work hours.
  - The security system should consider requests to access the VM outside work hours unnecessary and malicious.

- Users would like to connect to Azure VM workloads. The system should approve connections that are only from managed and compliant devices.

- A system has experienced a tremendous number of brute-force attacks:

  - These attacks have targeted Azure VMs on RDP and SSH ports 3389 and 22.
  - The attacks have tried to guess the credentials.
  - The solution should prevent access ports such as 3389 and 22 from being exposed to the internet or on-premises environments.

## Architecture

:::image type="content" source="../media/multilayered-protection-azure-vm-architecture-diagram.svg" alt-text="Architecture diagram showing how a user gains temporary access to an Azure V M." border="false" lightbox="../media/multilayered-protection-azure-vm-architecture-diagram-lightbox.png":::

*Download a [Visio file][Visio version of architecture diagram] of this architecture.*

## Dataflow

1. **Authentication and access decisions**: The user is authenticated against Azure AD for access to the Azure portal, Azure REST APIs, Azure PowerShell, or the Azure CLI. If authentication succeeds, an Azure AD Conditional Access policy takes effect. That policy verifies whether the user meets certain criteria. Examples include using a managed device or signing in from a known location. If the user fulfills the criteria, Conditional Access grants the user access to Azure through the Azure portal or another interface.

1. **Identity-based just-in-time access**: During authorization, Azure AD PIM assigns the user a custom role of type *eligible*. The eligibility is limited to required resources and is a *time-bound* role, not a *permanent* one. Within a specified time frame, the user requests activation of this role through the Azure PIM interface. That request can trigger other actions, such as starting an approval workflow or prompting the user for multifactor authentication to verify identity. In an approval workflow, another person needs to approve the request. Otherwise the user isn't assigned the custom role and can't continue to the next step.

1. **Network based just-in-time access**: After authentication and authorization, the custom role is temporarily linked to the user's identity. The user then requests JIT VM access. That access opens a connection from the Azure Bastion subnet on port 3389 for RDP or port 22 for SSH. The connection runs directly to the VM network interface card (NIC) or the VM NIC subnet. Azure Bastion opens an internal RDP session by using that connection. The session is limited to the Azure virtual network and isn't exposed to the public internet.

1. **Connecting to the Azure VM**: The user accesses Azure Bastion by using a temporary token. Through this service, the user establishes an indirect RDP connection to the Azure VM. The connection only works for a limited amount of time.

### Components

This solution uses the following components:

- [Azure Virtual Machines][Azure Virtual Machines] is an infrastructure-as-a-service (IaaS) offer. You can use Virtual Machines to deploy on-demand, scalable computing resources. In production environments that use this solution, deploy your workloads on Azure VMs. Then eliminate unnecessary exposure to your VMs and Azure assets.

- [Azure AD][Azure AD] is a cloud-based identity service that controls access to Azure and other cloud apps.

- [PIM][Privileged Identity Management (PIM)] is an Azure AD service that manages, controls, and monitors access to important resources. In this solution, this service:

  - Limits permanent administrator access to standard and custom privileged roles.
  - Provides just-in-time identity-based access to custom roles.

- [JIT VM access][Just-in-time (JIT) VM access] is a feature of Defender for Cloud that provides just-in-time network-based access to VMs. This feature adds a deny rule to the Azure network security group that protects the VM network interface or the subnet that contains the VM network interface. That rule minimizes the attack surface of the VM by blocking unnecessary communication to the VM. When a user requests access to the VM, the service adds a temporary allow rule to the network security group. Because the allow rule has higher priority than the deny rule, the user can connect to the VM. Azure Bastion works best for connecting to the VM. But the user can also use a direct RDP or SSH session.

- [Azure RBAC][Azure RBAC] is an authorization system that provides fine-grained access management of Azure resources.

- [Azure RBAC custom roles][Azure RBAC custom roles] provide a way to expand on Azure RBAC built-in roles. You can use them to assign permissions at levels that meet your organization's needs. These roles support PoLP. They grant only the permissions that a user needs for the user's purpose. To access a VM in this solution, the user gets permissions for:

  - Using Azure Bastion.
  - Requesting JIT VM access in Defender for Cloud.
  - Reading or listing VMs.

- [Azure AD Conditional Access][Azure AD Conditional Access] is a tool that Azure AD uses to control access to resources. Conditional Access policies support the [zero trust][Zero Trust] security model. In this solution, the policies ensure that only authenticated users get access to Azure resources.

- [Azure Bastion][Azure Bastion] provides secure and seamless RDP and SSH connectivity to VMs in a network. In this solution, Azure Bastion connects users who use Microsoft Edge or another internet browser for HTTPS, or secured traffic on port 443. Azure Bastion sets up the RDP connection to the VM. RDP and SSH ports aren't exposed to the internet or the user's origin.

  Azure Bastion is optional in this solution. Users can connect directly to Azure VMs by using the RDP protocol. If you do configure Azure Bastion in an Azure virtual network, set up a separate subnet called `AzureBastionSubnet`. Then associate a network security group with that subnet. In that group, specify a source for HTTPS traffic such as the user's on-premises IP classless inter-domain routing (CIDR) block. By using this configuration, you block connections that don't come from the user's on-premises environment.
  
  ## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal author:

 - [Husam Hilal](https://www.linkedin.com/in/husamhilal/) | Senior Cloud Solution Architect
 
*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Activate my Azure resource roles in Privileged Identity Management][Activate my Azure resource roles in Privileged Identity Management]
- [Understanding just-in-time (JIT) VM access][Understanding just-in-time (JIT) VM access]
- [Configure Bastion and connect to a Windows VM through a browser][Configure Bastion and connect to a Windows VM through a browser]
- [Secure user sign-in events with Azure AD Multi-Factor Authentication][Secure user sign-in events with Azure AD Multi-Factor Authentication]

## Related resources

- [Hybrid security monitoring via Microsoft Defender for Cloud and Microsoft Sentinel](../../hybrid/hybrid-security-monitoring.yml)
- [Security considerations for highly sensitive IaaS apps in Azure][Security considerations for highly sensitive IaaS apps in Azure]
- [Azure Active Directory IDaaS in Security Operations][Azure Active Directory IDaaS in Security Operations]

[Activate my Azure resource roles in Privileged Identity Management]: /azure/active-directory/privileged-identity-management/pim-resource-roles-activate-your-roles
[Azure Active Directory IDaaS in Security Operations]: ../../example-scenario/aadsec/azure-ad-security.yml
[Azure AD]: https://azure.microsoft.com/services/active-directory
[Azure AD Conditional Access]: /azure/active-directory/conditional-access/overview
[Azure Bastion]: /azure/bastion
[Azure RBAC]: /azure/role-based-access-control/overview
[Azure RBAC custom roles]: /azure/role-based-access-control/custom-roles
[Azure Virtual Machines]: https://azure.microsoft.com/services/virtual-machines
[Configure Bastion and connect to a Windows VM through a browser]: /azure/bastion/tutorial-create-host-portal
[Just-in-time (JIT) VM access]: /azure/security-center/security-center-just-in-time
[Privileged Identity Management (PIM)]: /azure/active-directory/privileged-identity-management
[Understanding just-in-time (JIT) VM access]: /azure/security-center/just-in-time-explained
[Secure user sign-in events with Azure AD Multi-Factor Authentication]: /azure/active-directory/authentication/tutorial-enable-azure-mfa
[Security considerations for highly sensitive IaaS apps in Azure]: ../../reference-architectures/n-tier/high-security-iaas.yml
[Visio version of architecture diagram]: https://arch-center.azureedge.net/US-1880866-multilayered-protection-azure-vm-architecture-diagram.vsdx
[Zero Trust]: https://www.microsoft.com/security/business/zero-trust
