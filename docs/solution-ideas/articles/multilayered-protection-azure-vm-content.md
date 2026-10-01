[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This solution offers a multilayered strategy for protecting virtual machines (VMs) in Azure. The strategy provides accessibility while minimizing the attack surface for management and administrative purposes.

The design combines Microsoft Entra Conditional Access, Microsoft Entra Privileged Identity Management (PIM), Azure role-based access control (Azure RBAC), Microsoft Defender for Cloud just-in-time (JIT) network access, and Azure Bastion to provide tightly controlled temporary access to VMs.

## Architecture

:::image type="complex" source="../media/multilayered-protection-azure-vm-architecture-diagram.svg" alt-text="Architecture diagram that shows a layered approach for providing temporary access to an Azure VM." border="false" lightbox="../media/multilayered-protection-azure-vm-architecture-diagram.svg":::
   The diagram shows a four-step path from no VM access to time-bound access. In Authentication, step 1 sends the user through Microsoft Entra ID and Conditional Access. Policy evaluation grants access to the Azure portal only when conditions are satisfied. In Authorization JIT, which represents step 2, the user requests a custom role through Microsoft Entra PIM. Approval by a manager, multifactor authentication, or both can be required before PIM temporarily assigns a custom role that permits Bastion use, JIT requests, and VM read or list access. In Network access JIT, step 3 sends a JIT request to Defender for Cloud, which temporarily opens approved RDP or SSH ports for an allowed source IP. In Access VM, step 4 routes the user's connection through Azure Bastion in the Azure Bastion subnet to network interfaces and VMs in a workload subnet. Bastion inbound access is limited to specified user IP ranges.
:::image-end:::

*Download a [Visio file][Visio version of architecture diagram] of this architecture.*

### Data flow

The following data flow corresponds to the preceding diagram:

1. **Authentication and access decisions**: The user authenticates against Microsoft Entra ID to access the Azure portal, Azure REST APIs, Azure PowerShell, or the Azure CLI. If authentication succeeds, a Conditional Access policy takes effect. That policy verifies whether the user meets certain criteria, such as using a managed device or signing in from a known location. If the user fulfills the criteria, Conditional Access grants the user access to Azure through the Azure portal or another interface.

2. **Identity-based JIT access**: During authorization, Microsoft Entra PIM assigns the user a custom role of type *eligible*. The eligibility is limited to required resources and is a *time-bound* role, not a *permanent* one. Within a specified time frame, the user requests activation of this role through Microsoft Entra PIM. That request can trigger other actions, such as starting an approval workflow or prompting the user for multifactor authentication to verify identity. In an approval workflow, another person needs to approve the request. If the request is approved, the user is assigned the custom role and continues to the next step.

3. **Network-based JIT access**: After authentication and authorization, the custom role is temporarily linked to the user's identity. The user then requests JIT VM access. That access opens a connection from the Azure Bastion subnet on port 3389 for Remote Desktop Protocol (RDP) or port 22 for Secure Shell (SSH). The connection runs directly to the VM network interface card (NIC) or the VM NIC subnet. Azure Bastion opens an internal RDP session by using that connection. The session is limited to the Azure virtual network and isn't exposed to the public internet.

4. **Connecting to the Azure VM**: The user accesses Azure Bastion by using a temporary token. Through this service, the user establishes an indirect RDP connection to the Azure VM. The connection works only for a limited amount of time. If the password is stored as a secret in Azure Key Vault, and if sufficient Azure RBAC permissions are configured to grant access to the appropriate user account, the user can retrieve the password from Key Vault.

### Components

This solution uses the following components:

- [Azure Virtual Machines][Azure Virtual Machines] is an infrastructure as a service (IaaS) offering that provides scalable compute resources. In this architecture, Azure VMs host production workloads while using layered security controls to minimize exposure to threats.

  Azure VMs include the following built-in protections that are enabled by default or recommended as baseline:
  - The trusted launch feature includes Secure Boot and a virtual Trusted Platform Module (vTPM) for supported generation-2 VMs. Boot-integrity monitoring requires the Guest Attestation extension and Defender for Cloud integration.
  - The Azure hypervisor enforces isolation between VMs.
  - Confidential VMs provide hardware-enforced isolation for sensitive workloads in supported VM sizes, operating systems, and regions.
  
  These capabilities make security intrinsic to compute resources rather than an add-in feature.

- [Azure Virtual Network][Azure Virtual Network] is a logically isolated, customizable network in Azure. This service functions as a private network space that supports secure communication between Azure resources, the internet, and on‑premises networks.

- [Microsoft Entra ID][Microsoft Entra ID] is a cloud-based identity service that manages access to Azure and other cloud applications. In this architecture, Microsoft Entra ID authenticates users and enforces access policies to help ensure secure entry into Azure resources.

- [Microsoft Entra PIM][Privileged Identity Management (PIM)] is a service that controls and monitors privileged access to resources. Microsoft Entra PIM requires Microsoft Entra ID Governance licensing or Microsoft Entra ID P2 licensing. In this architecture, Microsoft Entra PIM limits permanent admin access to standard and custom privileged roles and enables JIT identity-based access to custom roles.

- [JIT VM access][Just-in-time (JIT) VM access] is a Defender for Cloud feature that restricts network access to VMs. JIT VM access requires Microsoft Defender for Servers Plan 2. In this architecture, JIT access minimizes the attack surface by applying deny rules and only allowing temporary access when requested. When an authorized user requests access to the VM, the service adds a temporary allow rule to the network security group. Because the allow rule has higher priority than the deny rule, the user can connect to the VM. Azure Bastion works best for connecting to the VM, but the user can also use a direct RDP or SSH session.

- [Azure RBAC][Azure RBAC] is an authorization system for managing access to Azure resources. In this architecture, [Azure RBAC custom roles][Azure RBAC custom roles] enforce the principle of *least privilege* by granting only necessary permissions for VM access. You can use custom roles to assign permissions at levels that meet your organization's needs. To access a VM in this solution, the user gets permissions for the following actions:

  - Using Azure Bastion
  - Requesting JIT VM access in Defender for Cloud
  - Reading or listing VMs

- [Conditional Access][Microsoft Entra Conditional Access] is a policy-based access control tool. In this architecture, Conditional Access helps ensure that only authenticated users from trusted devices or locations can access Azure resources. Conditional Access policies support the [Zero Trust][Zero Trust] security model.

- [Azure Bastion][Azure Bastion] is a managed service that provides RDP and SSH connectivity to VMs over HTTPS. In this architecture, Azure Bastion connects users who use Microsoft Edge or another internet browser for HTTPS, or secured traffic on port 443. Azure Bastion sets up the RDP connection to the VM. RDP and SSH ports on the target VM aren't exposed to the internet.

  Azure Bastion is optional in this solution, especially if access to the Azure virtual network is private through a virtual private network or Azure ExpressRoute. Users can connect directly to Azure VMs by using RDP or SSH over the private connection.

- [Key Vault][Azure Key Vault] is a service for storing secrets, keys, and certificates. In this architecture, Key Vault stores VM passwords as secrets and integrates with Azure Bastion to allow retrieval by authorized users. Configure Azure RBAC so that only the user account that accesses the VM can retrieve the secret, and set secret expiration and rotation practices for local administrator credentials. Users can retrieve the secret through Azure APIs, by using the Azure CLI, or from the Azure portal.

## Scenario details

This solution aligns with Microsoft security recommendations by incorporating several protection mechanisms that Microsoft Azure and Microsoft Entra services offer. The solution also adheres to the principles of *secure by design*, *secure by default*, and *secure operations*.

- **Secure by design**. The solution achieves nonpersistent granular access to VMs by implementing the principle of least privilege and the concept of *separation of duties*. This approach helps ensure that authorization to the VMs is granted only for legitimate reasons, reducing the risk of unauthorized access.

- **Secure by default**. The solution locks down inbound traffic to VMs by allowing connectivity only when needed. This default security posture minimizes exposure to many popular cyberattacks such as brute-force and distributed denial-of-service (DDoS) attacks.

- **Secure operations**. It's critical to continuously monitor security controls and to invest in their improvement to meet current and future threats. This solution uses various Azure services and features, such as Microsoft Entra PIM, the JIT VM access feature of Defender for Cloud, Azure Bastion, and Azure RBAC custom roles. Conditional Access regulates access to Azure resources. Consider using Key Vault to store VM local passwords if they aren't integrated with Microsoft Entra ID or Microsoft Entra Domain Services.

*Defense in depth* is the premise behind this solution. This strategy challenges users with several lines of defense before granting access to VMs. The controls help:

- Verify each user's identity.
- Authorize each access request for a legitimate business purpose.
- Secure communication.
- Provide access to VMs in Azure only when needed.

### Implement deny by default in Virtual Network

To reduce the attack surface, implement a *deny-by-default* network security model in Virtual Network:

- Associate a network security group with each workload subnet or VM network interface.
- Add only the inbound rules that the workload requires.
- Use the network security groups to provide stateful filtering.
- Use Azure Firewall for centralized policy enforcement.
- Use private endpoints for private connectivity to supported Azure services. Disable public network access on each target service when you need to prevent access through its public endpoint.

### Deploy Azure Bastion in a dedicated subnet

If you configure Azure Bastion in an Azure virtual network by using a Basic, Standard, or Premium SKU, deploy Azure Bastion in a dedicated subnet named `AzureBastionSubnet` with a classless inter-domain routing (CIDR) block of `/26` or larger, such as `/25` or `/24`. Associate a network security group with that subnet. In that group, specify a source for HTTPS traffic such as the user's on-premises public IP CIDR block address space. This configuration blocks connections that don't come from the user's on-premises environment.

### Potential use cases

The defense in depth strategy and the solution in this article apply to many scenarios:

- An administrator needs to access an Azure VM to troubleshoot an issue, investigate behavior, or apply a critical update. The administrator uses RDP to access a Windows VM or SSH to access a Linux VM. Besides these circumstances, the following conditions must be met:
  - The access includes the minimum number of permissions required for performing the task.
  - The access is valid for only a limited time.
  - After the access expires, the system locks down the VM access to prevent malicious access attempts.

- Employees need access to a remote workstation that's hosted as an Azure VM. The following conditions must be met:
  - The employees can access the VM only during work hours.
  - The security system considers requests to access the VM outside work hours unnecessary and malicious.

- Users want to connect to Azure VM workloads. The system approves connections that are from managed and compliant devices only.

- A system experiences frequent brute-force attacks that target Azure VMs on RDP and SSH ports 3389 and 22. The attacks try to guess credentials. The solution keeps these management ports closed by default and temporarily opens them only to approved source IP addresses when access is required.

## Contributors

*Microsoft maintains this article. The following contributor wrote this article.*

Principal author:

- [Husam Hilal](https://www.linkedin.com/in/husamhilal/) | Principal Cloud Solution Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Activate my Azure resource roles in Privileged Identity Management][Activate my Azure resource roles in Privileged Identity Management]
- [Just-in-time machine access in Microsoft Defender for Cloud][Understanding just-in-time (JIT) VM access]
- [Deploy Azure Bastion from the Azure portal][Deploy Azure Bastion from the Azure portal]
- [Secure user sign-in events with Microsoft Entra multifactor authentication][Secure user sign-in events with Microsoft Entra multifactor authentication]

## Related resource

- [Azure Virtual Machines baseline architecture][Azure Virtual Machines baseline]

[Activate my Azure resource roles in Privileged Identity Management]: /entra/id-governance/privileged-identity-management/pim-resource-roles-activate-your-roles
[Microsoft Entra ID]:/entra/fundamentals/what-is-entra
[Microsoft Entra Conditional Access]: /entra/identity/conditional-access/overview
[Azure Bastion]: /azure/bastion/bastion-overview
[Azure Key Vault]: /azure/key-vault/general/overview
[Azure RBAC]: /azure/role-based-access-control/overview
[Azure RBAC custom roles]: /azure/role-based-access-control/custom-roles
[Azure Virtual Machines]: /azure/well-architected/service-guides/virtual-machines
[Azure Virtual Network]: /azure/well-architected/service-guides/virtual-network
[Deploy Azure Bastion from the Azure portal]: /azure/bastion/quickstart-host-portal
[Just-in-time (JIT) VM access]: /azure/defender-for-cloud/enable-just-in-time-access
[Privileged Identity Management (PIM)]: /entra/id-governance/privileged-identity-management/
[Understanding just-in-time (JIT) VM access]: /azure/defender-for-cloud/just-in-time-access-overview
[Secure user sign-in events with Microsoft Entra multifactor authentication]: /entra/identity/authentication/tutorial-enable-azure-mfa
[Visio version of architecture diagram]: https://arch-center.azureedge.net/US-1880866-multilayered-protection-azure-vm-architecture-diagram.vsdx
[Zero Trust]: /security/zero-trust/zero-trust-overview
[Azure Virtual Machines baseline]: ../../virtual-machines/baseline.yml
