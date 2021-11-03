
This reference architecture demonstrates a multi-layer approach to protect VM access in Azure. While connecting to VMs in Azure is necessary for management and administration, it is critical to focus on reducing the attack surface, that connectivity creates, as much as possible. This reference architecture consists of multiple protection mechanisms to achieve a non-persistent granular access to desired VMs following the principles of least privilege and separation of duties. It also locks down the inbound traffic to desired VMs, reducing exposure to attacks while providing easy access to connect to VMs when needed. This level of protection minimizes the chance of many popular cyber attacks on VMs, such as brute-force attacks, DDoS attacks, and others.

This architecture leverages a spectrum of Azure services and features including: Azure AD Privileged Identity Management (PIM), Azure Security Center's Just-In-Time (JIT) Virtual Machine (VM) access, Azure Bastion, Azure RBAC Custom Roles, and optionally Azure AD Conditional Access.

## Potential use cases

The main idea behind this architecture is to apply **Defense in Depth** strategy by challenging users with multi lines of defense before the user is able to access the VM. The goal is to construct enough assurance that the user is legitimate, and the intensions are legal, and the communication is secure to access a Virtual Machine in Azure only when needed. 

In real world production environment, once you've deployed your workloads in Azure specifically on IaaS Virtual Machines, you will need to eliminate any unnecessary exposure to your VMs and Azure assets.

These other uses cases have similar design patterns:

- While your VMs are running in Azure, you will get in situation where an administrator needs to access a VM (RDP if Windows, SSH if LINUX/UNIX) may be to troubleshoot an issue, investigate a certain behavior, or apply a critical update. You need to ensure that you give your administrator the least privileges and allow the access to the VM for a limited time to complete the work. After that, the VM access need to be locked down to prevent any malicious attempt to access the VM.

- Your company employees needs access to remote workstation that is hosted in Azure as a VM. You need to ensure they access the VM only during work hours only. Any other request to access the VMs outside of the work hours is considered unnecessary and malicious.

- You only allow connecting to your Azure VMs from a managed and compliant device, you need to ensure that before allowing users to connect to your workloads in Azure VMs.

- You have seen tremendous number of brute-force attacks targeting your VMs in Azure on RDP and SSH ports 3389 and 22, trying to guess the credentials. You need to eliminate having access ports (3389 and 22) exposed to the Internet or even your on-premises environment.

## Architecture

_Architecture diagram goes here_

The original Visio diagram for the architecture above is available to download _here_.

Below are the defenses that can be built to achieve secure access to VMs:

1. **Authentication and access decisions**: The user is authenticated against Azure AD for access to Azure Portal, Azure REST API, Azure PowerShell or Azure CLI. If authentication is successful, an Azure AD Conditional Access Policy takes effect. That policy verifies whether the user meets certain criteria. Examples include using a managed device or signing in from a known location. If the user fulfills the criteria, Conditional Access grants the user access to Azure through the Azure portal or another interface.

1. **Identity-based just-in-time access**: During the authorization process, the user gets a custom role assignment of type *eligible* through Azure AD PIM. With this type of role, the user needs to activate the role to access the protected resources. The eligibility is not *permanent*. Instead, it's *time-bound*, meaning the user can only activate the role within specified start and end dates.

With this custom role, the user only gets permission to access a limited number of required resources. For example, to access a VM, the user would get permissions for:

- Using Azure Bastion.
- Requesting JIT VM-Access in Azure Security Center
- Reading or listing VMs.

The user requests activation of the custom role through the Azure PIM interface. That request can trigger other actions. Examples include starting an approval workflow or prompting the user for multifactor authentication to verify identity. In an approval workflow, another person needs to approve the request. Otherwise the user isn't assigned the custom role and can't proceed to the next step.

1. **Network based Just-in-Time Access**: After authentication and authorization, the custom role is temporarily linked to the user's identity. The user can then request JIT VM access. That access opens a connection from the Azure Bastion subnet on port 3389 for Remote Desktop Protocol (RDP) or port 22 for secure shell (SSH). The connection runs directly to the VM network interface card (NIC) or the VM NIC subnet. By using that connection, Azure Bastion can open an internal RDP session that's limited to the Azure virtual network and isn't exposed to the public internet.

When you configure Azure Bastion in an Azure virtual network, you need to set up a separate subnet called AzureBastionSubnet. You can then associate a network security group with that subnet. In that group, you can specify a source for HTTPS (443) traffic such as the user's on-premises IP CIDR block. With this configuration, you block connections that don't come from the user's on-premises environment.

4. **Connecting to Azure Virtual Machine**: Now the user should be able to use his temporary token to access Azure Bastion and use it to indirectly remote (RDP) into the Azure VM that is desired. After the temporary time-windows is expired, the user no longer will be able to connect to the VM/s.
 
### Components

The components of this architecture are listed below:

- [Azure Active Directory (Azure AD) Privileged Identity Management (PIM)](https://docs.microsoft.com/en-us/azure/active-directory/privileged-identity-management/). We use it to limit permanent administrator access to standard and custom privileged roles. In this specific case, we used it to enable just-in-time identity-based access to a custom role.

- [Azure Security Center's just-in-time (JIT) Virtual Machine Access](https://docs.microsoft.com/en-us/azure/security-center/security-center-just-in-time). We use it to enable just-in-time network-based access to the desired VM/s.  This service, once enabled, adds a deny rule on the Azure Network Security Group (NSG) that protects the VM network interface or the subnet where the VM network interface lives. That will block all unnecessary management communication to the VM, which minimizes the attack surface of the VM. Once the user request access to the VM, a temporary time-bound allow rule, that has higher priority than the deny rule, is added to the same NSG. That will allow the user to connect to the VM either through Azure Bastion, or RDP/SSH directly depending how it is configured. The Azure Bastion option is the recommended approach.

- [Azure RBAC Custom Roles](https://docs.microsoft.com/en-us/azure/role-based-access-control/custom-roles). We use custom roles to follow the principle of least privileges, that will grant minimal required permissions to the user to allow performing the required task, but not further. The required permissions in this reference architecture are read/list virtual machines, request just-in-time VM access in Azure Security Center and connect to the virtual machine via Azure Bastion.

- [Azure AD Conditional Access Policy](https://docs.microsoft.com/en-us/azure/active-directory/conditional-access/overview). We use this feature of Azure AD to ensure only authenticated users that passed specific challenges in the Conditional Access Policy were permitted to access the Azure resources. This mechanism is part of [Zero Trust](https://www.microsoft.com/en-us/security/business/zero-trust) model.

- [Azure Bastion](https://docs.microsoft.com/en-us/azure/bastion/). We use this service to enable users to connect using the Internet Browser (i.e. Microsoft Edge) on port 443 (HTTPS), and the service itself will initiate the RDP connection to the VM, thus RDP/SSH ports will not be exposed to the Internet or wherever the user is coming from. While the integration is recommended, it is optional, and can easily drawn out from this architecture and use RDP protocol to connect to the VM in Azure directly.

## Next steps

These are recommended articles and will complement the broader recommended security practices:

* [Hybrid Security Monitoring using Azure Security Center and Azure Sentinel](/azure/architecture/hybrid/hybrid-security-monitoring)
* [Security considerations for highly sensitive IaaS apps in Azure](/azure/architecture/reference-architectures/n-tier/high-security-iaas)
* [Azure Active Directory IDaaS in Security Operations](/azure/architecture/example-scenario/aadsec/azure-ad-security)

## Related resources

These resources will help you with understanding the components of this architecture:

* [Activate my Azure resource roles in Privileged Identity Management](https://docs.microsoft.com/en-us/azure/active-directory/privileged-identity-management/pim-resource-roles-activate-your-roles)
* [Understanding just-in-time (JIT) VM access
](https://docs.microsoft.com/en-us/azure/security-center/just-in-time-explained)
* [Configure Bastion and connect to a Windows VM through a browser](https://docs.microsoft.com/en-us/azure/bastion/tutorial-create-host-portal)
* [Secure user sign-in events with Azure AD Multi-Factor Authentication](https://docs.microsoft.com/en-us/azure/active-directory/authentication/tutorial-enable-azure-mfa)

<!---
![image.](https://user-images.githubusercontent.com/13895622/116135227-b73cac00-a685-11eb-92d3-003350ba6604.png)
---!>