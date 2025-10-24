[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This solution offers a multilayered strategy for protecting virtual machines (VMs) in Azure, ensuring accessibility while minimizing the attack surface for management and administrative purposes.

Aligned with Microsoft's security recommendation, this solution incorporates several protection mechanisms offered by Microsoft Azure and Entra services, adhering to the principles of secure by design, secure by default, and secure operations.

- **Secure by design**. The solution achieves non-persistent granular access to virtual machines by implementing the principle of least privilege and the concept of separation of duties. This ensures that authorization to the virtual machines is granted only for legitimate reasons, reducing the risk of unauthorized access.

- **Secure by default**. Inbound traffic to virtual machines is locked down, allowing connectivity only when needed. This default security posture minimizes exposure to many popular cyber-attacks such as brute-force and distributed denial-of-service (DDoS) attacks.

- **Secure operations**. It's critical to implement continuous monitoring and invest in improving of security controls to meet current and future threats. Use various Azure services and features such as Microsoft Entra Privileged Identity Management (PIM), the just-in-time (JIT) VM access feature of Microsoft Defender for Cloud, Azure Bastion, Azure role-based access control (Azure RBAC) custom roles. Optionally you should consider Microsoft Entra Conditional Access to regulate access to Azure resources and Azure Key Vault for storing virtual machine local passwords if not integrated with Entra ID or Active Directory Domain Services.

## Potential use cases

*Defense in depth* is the premise behind this architecture. This strategy challenges users with several lines of defense before granting the users access to VMs. The goal is to ensure that:

- Each user is verified.
- Each user has legitimate intentions.
- Communication is secure.
- Access to VMs in Azure is only provided when needed.

The defense in depth strategy and the solution in this article apply to many scenarios:

- An administrator needs to access an Azure VM under these circumstances:

  - The administrator needs to troubleshoot an issue, investigate behavior, or apply a critical update.
  - The administrator uses Remote Desktop Protocol (RDP) to access a Windows VM or secure shell (SSH) to access a Linux VM.
  - The access should include the minimum number of permissions required for performing the task.
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

:::image type="content" source="../media/multilayered-protection-azure-vm-architecture-diagram.svg" alt-text="Architecture diagram showing how a user gains temporary access to an Azure V M." border="false" lightbox="../media/multilayered-protection-azure-vm-architecture-diagram.svg":::

*Download a [Visio file][Visio version of architecture diagram] of this architecture.*

## Dataflow

1. **Authentication and access decisions**: The user is authenticated against Microsoft Entra ID to access the Azure portal, Azure REST APIs, Azure PowerShell, or the Azure CLI. If authentication succeeds, a Microsoft Entra Conditional Access policy takes effect. That policy verifies whether the user meets certain criteria. Examples include using a managed device or signing in from a known location. If the user fulfills the criteria, Conditional Access grants the user access to Azure through the Azure portal or another interface.

2. **Identity-based just-in-time access**: During authorization, Microsoft Entra PIM assigns the user a custom role of type *eligible*. The eligibility is limited to required resources and is a *time-bound* role, not a *permanent* one. Within a specified time frame, the user requests activation of this role through the Azure PIM interface. That request can trigger other actions, such as starting an approval workflow or prompting the user for multifactor authentication to verify identity. In an approval workflow, another person needs to approve the request. Otherwise the user isn't assigned the custom role and can't continue to the next step.

3. **Network based just-in-time access**: After authentication and authorization, the custom role is temporarily linked to the user's identity. The user then requests JIT VM access. That access opens a connection from the Azure Bastion subnet on port 3389 for RDP or port 22 for SSH. The connection runs directly to the VM network interface card (NIC) or the VM NIC subnet. Azure Bastion opens an internal RDP session by using that connection. The session is limited to the Azure virtual network and isn't exposed to the public internet.

4. **Connecting to the Azure VM**: The user accesses Azure Bastion by using a temporary token. Through this service, the user establishes an indirect RDP connection to the Azure VM. The connection only works for a limited amount of time. The user might retrieve the password from an Azure Key Vault, if the password was stored as a secret in the Key Vault, and sufficient Azure RBAC permissions are configured to limit access to the appropriate user account.

### Components

This solution uses the following components:

- [Azure Virtual Machines][Azure Virtual Machines] is an infrastructure as a service (IaaS) offering that provides scalable compute resources. In this architecture, Azure VMs host production workloads while minimizing exposure to threats through layered security controls.

- [Microsoft Entra ID][Microsoft Entra ID] is a cloud-based identity service that manages access to Azure and other cloud applications. In this architecture, it authenticates users and enforces access policies to ensure secure entry into Azure resources.

- [Microsoft Entra PIM][Privileged Identity Management (PIM)] is a service that controls and monitors privileged access to resources. In this architecture, PIM limits permanent admin access to standard and custom privileged roles and enables just-in-time (JIT) identity-based access to custom roles.

- [JIT VM access][Just-in-time (JIT) VM access] is a Defender for Cloud feature that restricts network access to VMs. In this architecture, JIT minimizes the attack surface by applying deny rules and only allowing temporary access when requested. When a user requests access to the VM, the service adds a temporary allow rule to the network security group. Because the allow rule has higher priority than the deny rule, the user can connect to the VM. Azure Bastion works best for connecting to the VM. But the user can also use a direct RDP or SSH session.

- [Azure RBAC][Azure RBAC] is an authorization system for managing access to Azure resources. In this architecture, [Azure RBAC custom roles][Azure RBAC custom roles] enforce the principle of least privilege by granting only necessary permissions for VM access. You can use them to assign permissions at levels that meet your organization's needs. To access a VM in this solution, the user gets permissions for the following actions:

  - Using Azure Bastion
  - Requesting JIT VM access in Defender for Cloud
  - Reading or listing VMs

- [Microsoft Entra Conditional Access][Microsoft Entra Conditional Access] is a policy-based access control tool. In this architecture, Conditional Access ensures that only authenticated users from trusted devices or locations can access Azure resources. Conditional Access policies support the [Zero Trust][Zero Trust] security model.

- [Azure Bastion][Azure Bastion] is a managed service that provides RDP and SSH connectivity to VMs over HTTPS. In this architecture, Azure Bastion connects users who use Microsoft Edge or another internet browser for HTTPS, or secured traffic on port 443. Azure Bastion sets up the RDP connection to the VM. RDP and SSH ports aren't exposed to the internet or the user's origin.

  Azure Bastion is optional in this solution. Users can connect directly to Azure VMs by using the RDP protocol. If you do configure Azure Bastion in an Azure virtual network, set up a separate subnet called `AzureBastionSubnet`. Then associate a network security group with that subnet. In that group, specify a source for HTTPS traffic such as the user's on-premises IP classless inter-domain routing (CIDR) block. This configuration blocks connections that don't come from the user's on-premises environment.
  
- [Key Vault][Azure Key Vault] is a service for storing secrets, keys, and certificates. In this architecture, Key Vault stores VM passwords as secrets and integrates with Azure Bastion to allow retrieval by authorized users. You should configure the secret Azure RBAC so that only the user account that accesses the VM can retrieve it. Retrieving the password value from the key vault can be done through Azure APIs (such as using the Azure CLI) or from the Azure portal.

  ## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

 - [Husam Hilal](https://www.linkedin.com/in/husamhilal/) | Senior Cloud Solution Architect
 
*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Activate my Azure resource roles in Privileged Identity Management][Activate my Azure resource roles in Privileged Identity Management]
- [Understanding just-in-time (JIT) VM access][Understanding just-in-time (JIT) VM access]
- [Configure Bastion and connect to a Windows VM through a browser][Configure Bastion and connect to a Windows VM through a browser]
- [Secure user sign-in events with Microsoft Entra multifactor authentication][Secure user sign-in events with Azure AD Multi-Factor Authentication]

## Related resource

- [Azure Virtual Machines baseline architecture][Azure Virtual Machines baseline]

[Activate my Azure resource roles in Privileged Identity Management]: /entra/id-governance/privileged-identity-management/pim-resource-roles-activate-your-roles
[Microsoft Entra ID]:/entra/fundamentals/whatis
[Microsoft Entra Conditional Access]: /entra/identity/conditional-access/overview
[Azure Bastion]: /azure/bastion/bastion-overview
[Azure Key Vault]: /azure/key-vault/general/overview
[Azure RBAC]: /azure/role-based-access-control/overview
[Azure RBAC custom roles]: /azure/role-based-access-control/custom-roles
[Azure Virtual Machines]: /azure/well-architected/service-guides/virtual-machines
[Configure Bastion and connect to a Windows VM through a browser]: /azure/bastion/tutorial-create-host-portal
[Just-in-time (JIT) VM access]: /azure/security-center/security-center-just-in-time
[Privileged Identity Management (PIM)]: /entra/id-governance/privileged-identity-management/
[Understanding just-in-time (JIT) VM access]: /azure/security-center/just-in-time-explained
[Secure user sign-in events with Microsoft Entra multifactor authentication]: /entra/identity/authentication/tutorial-enable-azure-mfa
[Visio version of architecture diagram]: https://arch-center.azureedge.net/US-1880866-multilayered-protection-azure-vm-architecture-diagram.vsdx
[Zero Trust]: /security/zero-trust/zero-trust-overview
[Azure Virtual Machines baseline]: /azure/architecture/virtual-machines/baseline
