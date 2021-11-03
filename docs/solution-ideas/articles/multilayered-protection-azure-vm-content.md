This solution provides a multilayered approach for protecting virtual machines (VMs) in Azure. Users need to connect to VMs for management and administrative purposes. But it's critical to minimize the attack surface that connectivity creates.

To reduce exposure to attacks, this solution locks down inbound traffic to VMs. But it also provides easy access to VMs when needed. By incorporating several protection mechanisms, this solution achieves non-persistent granular access to VMs. It aligns with the principle of least privilege and the concept of separation of duties. This level of protection minimizes the risk of many popular cyber attacks on VMs, such as brute-force attacks and distributed denial-of-service (DDoS) attacks.

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

In a production environment, after you've deployed your workloads on Azure infrastructure as a service (IaaS) VMs, eliminate unnecessary exposure to your VMs and Azure assets.

These other uses cases have similar design patterns:

- Situations in which VMs are running in Azure and an administrator needs to access a VM. The administrator uses Remote Desktop Protocol (RDP) to access a Windows VM or secure shell (SSH) to access a Linux VM. The access is needed to troubleshoot an issue, investigate behavior, or apply a critical update. The administrator should receive the minimum number of permissions that the work requires. The access should only work for a limited time. After the access expires, the system should lock down the VM access to prevent malicious access attempts.
- Companies with employees who need access to a remote workstation that is hosted in Azure as a VM. The employees should only access the VM during work hours. Requests to access the VM outside work hours should be considered unnecessary and malicious.
- Networks in which users would like to connect to Azure VM workloads. The system should only approve connections from managed and compliant devices.
- Systems that have experienced a tremendous number of brute-force attacks. These attacks have targeted VMs in Azure on RDP and SSH ports 3389 and 22 and have tried to guess the credentials. The solution should prevent access ports such as 3389 and 22 from being exposed to the internet or on-premises environments.

## Architecture

:::image type="content" source="../media/multilayered-protection-azure-vm-architecture-diagram.svg" alt-text="Architecture diagram showing how a user gains temporary access to an Azure V M." border="false" lightbox="../media/multilayered-protection-azure-vm-architecture-diagram-lightbox.png":::

*Download a [Visio file][Visio version of architecture diagram] of this architecture.*

1. **Authentication and access decisions**: The user is authenticated against Azure AD for access to the Azure portal, Azure REST APIs, Azure PowerShell or the Azure CLI. If authentication is successful, an Azure AD Conditional Access policy takes effect. That policy verifies whether the user meets certain criteria. Examples include using a managed device or signing in from a known location. If the user fulfills the criteria, Conditional Access grants the user access to Azure through the Azure portal or another interface.

1. **Identity-based just-in-time access**: During the authorization process, the user gets a custom role assignment of type *eligible* through Azure AD PIM. With this type of role, the user needs to activate the role to access the protected resources. The eligibility is not *permanent*. Instead, it's *time-bound*, meaning the user can only activate the role within specified start and end dates.

   With this custom role, the user can access only the resources that are required for the user's purpose. For example, to access a VM, the user would get permissions for:

   - Using Azure Bastion.
   - Requesting JIT VM access in Defender for Cloud.
   - Reading or listing VMs.

   The user requests activation of the custom role through the Azure PIM interface. That request can trigger other actions. Examples include starting an approval workflow or prompting the user for multifactor authentication to verify identity. In an approval workflow, another person needs to approve the request. Otherwise the user isn't assigned the custom role and can't proceed to the next step.

1. **Network based just-in-time access**: After authentication and authorization, the custom role is temporarily linked to the user's identity. The user can then request JIT VM access. That access opens a connection from the Azure Bastion subnet on port 3389 for RDP or port 22 for SSH. The connection runs directly to the VM network interface card (NIC) or the VM NIC subnet. By using that connection, Azure Bastion can open an internal RDP session that's limited to the Azure virtual network and isn't exposed to the public internet.

   When you configure Azure Bastion in an Azure virtual network, you need to set up a separate subnet called `AzureBastionSubnet`. You can then associate a network security group with that subnet. In that group, you can specify a source for HTTPS, or port 443, traffic such as the user's on-premises IP classless inter-domain routing (CIDR) block. By using this configuration, you block connections that don't come from the user's on-premises environment.

1. **Connecting to the Azure VM**: By using a temporary token, the user accesses Azure Bastion. Through this service, the user establishes an indirect RDP connection to the Azure VM. The connection only works for a limited amount of time.

### Components

This solution uses the following components:

- [Azure AD][Azure AD] is a cloud-based identity service that controls access to Azure and other cloud apps.

- [PIM][Privileged Identity Management (PIM)] is an Azure AD service that you can use to manage, control, and monitor access to important resources. In this solution, this service:

  - Limits permanent administrator access to standard and custom privileged roles.
  - Provides just-in-time identity-based access to custom roles.

- [JIT VM access][Just-in-time (JIT) VM access] is a feature of Defender for Cloud that provides just-in-time network-based access to VMs. This feature adds a deny rule to the Azure network security group that protects the VM network interface or the subnet that contains the VM network interface. That rule minimizes the attack surface of the VM by blocking unnecessary communication to the VM. When a user requests access to the VM, the service adds a temporary allow rule to the network security group. Because the allow rule has higher priority than the deny rule, the user can connect to the VM. Azure Bastion works best for connecting to the VM. But the user can also use a direct RDP or SSH session.

- [Azure RBAC][Azure RBAC] is an authorization system that provides fine-grained access management of Azure resources.

- [Azure RBAC custom roles][Azure RBAC custom roles] provide a way to expand on Azure RBAC built-in roles. You can use them to assign permissions at levels that meet your organization's needs. These roles support the principle of least privilege. They grant only the permissions that a user needs for the user's purpose.

- [Azure AD Conditional Access][Azure AD Conditional Access] is a tool that Azure AD uses to control access to resources. Conditional Access policies support the [zero trust][Zero Trust] security model. In this solution, the policies ensure that only authenticated users get access to Azure resources.

- [Azure Bastion][Azure Bastion] provides secure and seamless RDP and SSH connectivity to VMs in a network. In this solution, Azure Bastion connects users who use an internet browser like Microsoft Edge for HTTPS, or secured traffic on port 443. Azure Bastion initiates the RDP connection to the VM. RDP and SSH ports aren't exposed to the internet or the user's origin. Azure Bastion is optional in this architecture. By using the RDP protocol, users can connect directly to Azure VMs.

## Next steps

- [Activate my Azure resource roles in Privileged Identity Management][Activate my Azure resource roles in Privileged Identity Management]
- [Understanding just-in-time (JIT) VM access][Understanding just-in-time (JIT) VM access]
- [Configure Bastion and connect to a Windows VM through a browser][Configure Bastion and connect to a Windows VM through a browser]
- [Secure user sign-in events with Azure AD Multi-Factor Authentication][Secure user sign-in events with Azure AD Multi-Factor Authentication]

## Related resources

- [Hybrid Security Monitoring using Azure Security Center and Azure Sentinel][Hybrid Security Monitoring using Azure Security Center and Azure Sentinel]
- [Security considerations for highly sensitive IaaS apps in Azure][Security considerations for highly sensitive IaaS apps in Azure]
- [Azure Active Directory IDaaS in Security Operations][Azure Active Directory IDaaS in Security Operations]

[Activate my Azure resource roles in Privileged Identity Management]: https://docs.microsoft.com/en-us/azure/active-directory/privileged-identity-management/pim-resource-roles-activate-your-roles
[Azure Active Directory IDaaS in Security Operations]: /azure/architecture/example-scenario/aadsec/azure-ad-security
[Azure AD]: https://azure.microsoft.com/en-us/services/active-directory/
[Azure AD Conditional Access]: https://docs.microsoft.com/en-us/azure/active-directory/conditional-access/overview
[Azure Bastion]: https://docs.microsoft.com/en-us/azure/bastion
[Azure RBAC]: https://docs.microsoft.com/en-us/azure/role-based-access-control/overview
[Azure RBAC custom roles]: https://docs.microsoft.com/en-us/azure/role-based-access-control/custom-roles
[Configure Bastion and connect to a Windows VM through a browser]: https://docs.microsoft.com/en-us/azure/bastion/tutorial-create-host-portal
[Hybrid Security Monitoring using Azure Security Center and Azure Sentinel]: /azure/architecture/hybrid/hybrid-security-monitoring
[Just-in-time (JIT) VM access]: https://docs.microsoft.com/en-us/azure/security-center/security-center-just-in-time
[Privileged Identity Management (PIM)]: https://docs.microsoft.com/en-us/azure/active-directory/privileged-identity-management
[Understanding just-in-time (JIT) VM access]: https://docs.microsoft.com/en-us/azure/security-center/just-in-time-explained
[Secure user sign-in events with Azure AD Multi-Factor Authentication]: https://docs.microsoft.com/en-us/azure/active-directory/authentication/tutorial-enable-azure-mfa
[Security considerations for highly sensitive IaaS apps in Azure]: /azure/architecture/reference-architectures/n-tier/high-security-iaas
[Visio version of architecture diagram]: https://arch-center.azureedge.net/US-1880866-multilayered-protection-azure-vm-architecture-diagram.vsdx
[Zero Trust]: https://www.microsoft.com/en-us/security/business/zero-trust
