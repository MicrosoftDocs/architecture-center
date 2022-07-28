[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This solution demonstrates a multi-layer approach to protect VM access in Azure. While connecting to VMs in Azure is necessary for management and administration, it is critical to focus on reducing the attack surface, that connectivity creates, as much as possible. This reference architecture consists of multiple protection mechanisms to achieve a non-persistent granular access to desired VMs following the principles of least privilege and separation of duties. It also locks down the inbound traffic to desired VMs, reducing exposure to attacks while providing easy access to connect to VMs when needed. This level of protection minimizes the chance of many popular cyber attacks on VMs, such as brute-force attacks, DDoS attacks, and others.

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

:::image type="content" source="../media/double-jit-for-vm-access.png" alt-text="Architecture multilayer protection for accessing Azure Virtual Machine" lightbox="../media/double-jit-for-vm-access.png":::

The original Visio diagram for the architecture above is available to download [here](../media/double-jit-for-vm-access.vsdx).

Below are the defenses that can be built to achieve secure access to VMs:

1. **Authentication & Access Decision**: The first step will start with authenticating the user against Azure AD to access Azure Portal, Azure REST API, Azure PowerShell or Azure CLI. When the authentication occurs an Azure AD Conditional Access Policy will kick in to verify if the user meets certain criteria, such as authenticating from a managed device, or known location, ...etc. If the user matches the specific criteria in the Conditional Access Policy, then the user will be permitted to access the Azure interface (i.e. Azure Portal).

2. **Identity based Just-in-Time Access**: Now as the user is authenticated, it is the time of authorizing the user. The user would have an **eligible** assigned custom role, but not permanent. That is achieved through Azure AD PIM.  

   The custom role only has permissions to access minimal required resources that the user would need. For example: to connect to a VM. In this case, that includes permissions to use Azure Bastion, Request JIT VM-Access in Azure Security Center, and Read/List VMs that the user should be accessing.

   The user needs to claim that custom role through Azure PIM interface. The request to claim the role can be configured to trigger different actions such as Approval Workflow and/or prompting for Multifactor Authentication to verify the user's identity. In the Approval Workflow someone else, who is possibly the owner of the desired resources, need to approve the request. Otherwise the user will not get the custom role assigned, which will prevent the user from proceeding to next steps.

3. **Network based Just-in-Time Access**: At this point, the user is authenticated and authorized with the custom role that is temporarily liked to the user's identity allowing the user to perform this and next step. In this step the user needs to request JIT VM Access, which will open connectivity from the Azure Bastion Subnet on port 3389 (RDP) or port 22 (SSH) to the VM NIC directly or the VM NIC Subnet. That will give Azure Bastion the connectivity it needs to open the internal RDP session that occurs in Azure vNet only, and not open to public Internet. 

    When configuring Azure Bastion in Azure vNet, a seperate subnet called AzureBastionSubnet is required. A specific source of HTTPS (443) traffic can be speficied on a Network Security Group associated with that subnet can be configured. That could be the users on-premises IP CIDR block. The benefit of this configuration, that it will eleminate possibilites of connections coming from locations other than the users on-premises environment.

4. **Connecting to Azure Virtual Machine**: Now the user should be able to use his temporary token to access Azure Bastion and use it to indirectly remote (RDP) into the Azure VM that is desired. After the temporary time-windows is expired, the user no longer will be able to connect to the VM/s.

### Components

The components of this architecture are listed below:

- [Azure Active Directory (Azure AD) Privileged Identity Management (PIM)](/azure/active-directory/privileged-identity-management/). We use it to limit permanent administrator access to standard and custom privileged roles. In this specific case, we used it to enable just-in-time identity-based access to a custom role.

- [Azure Security Center's just-in-time (JIT) Virtual Machine Access](/azure/security-center/security-center-just-in-time). We use it to enable just-in-time network-based access to the desired VM/s.  This service, once enabled, adds a deny rule on the Azure Network Security Group (NSG) that protects the VM network interface or the subnet where the VM network interface lives. That will block all unnecessary management communication to the VM, which minimizes the attack surface of the VM. Once the user request access to the VM, a temporary time-bound allow rule, that has higher priority than the deny rule, is added to the same NSG. That will allow the user to connect to the VM either through Azure Bastion, or RDP/SSH directly depending how it is configured. The Azure Bastion option is the recommended approach.

- [Azure RBAC Custom Roles](/azure/role-based-access-control/custom-roles). We use custom roles to follow the principle of least privileges, that will grant minimal required permissions to the user to allow performing the required task, but not further. The required permissions in this reference architecture are read/list virtual machines, request just-in-time VM access in Azure Security Center and connect to the virtual machine via Azure Bastion.

- [Azure AD Conditional Access Policy](/azure/active-directory/conditional-access/overview). We use this feature of Azure AD to ensure only authenticated users that passed specific challenges in the Conditional Access Policy were permitted to access the Azure resources. This mechanism is part of [Zero Trust](https://www.microsoft.com/security/business/zero-trust) model.

- [Azure Bastion](/azure/bastion/). We use this service to enable users to connect using an Internet browser (i.e. Microsoft Edge) on port 443 (HTTPS), and the service itself will initiate the RDP connection to the VM, thus RDP/SSH ports will not be exposed to the Internet or wherever the user is coming from. While the integration is recommended, it is optional, and can easily drawn out from this architecture and use RDP protocol to connect to the VM in Azure directly.

## Next steps

These are recommended articles and will complement the broader recommended security practices:

* [Hybrid Security Monitoring using Azure Security Center and Azure Sentinel](/azure/architecture/hybrid/hybrid-security-monitoring)
* [Security considerations for highly sensitive IaaS apps in Azure](/azure/architecture/reference-architectures/n-tier/high-security-iaas)
* [Azure Active Directory IDaaS in Security Operations](/azure/architecture/example-scenario/aadsec/azure-ad-security)

## Related resources

These resources will help you with understanding the components of this architecture:

* [Activate my Azure resource roles in Privileged Identity Management](/azure/active-directory/privileged-identity-management/pim-resource-roles-activate-your-roles)
* [Understanding just-in-time (JIT) VM access](/azure/security-center/just-in-time-explained)
* [Configure Bastion and connect to a Windows VM through a browser](/azure/bastion/tutorial-create-host-portal)
* [Secure user sign-in events with Azure AD Multi-Factor Authentication](/azure/active-directory/authentication/tutorial-enable-azure-mfa)
