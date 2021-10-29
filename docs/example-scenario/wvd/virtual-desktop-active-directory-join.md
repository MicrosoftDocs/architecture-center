## Virtual Desktop with Azure AD join

This article discusses how to configure Azure Active Directory (Azure AD) domain join for Azure Virtual Desktop. Joining Virtual Desktop to a domain no longer requires Azure Active Directory Domain Services (AD DS) domain controllers.

Originally, Virtual Desktop domain join required both Azure AD and Active Directory Domain Services (AD DS) domain controllers. AD DS could be in one of two formats:

- Traditional AD DS is part of Windows Server. AD DS domain controllers can be on-premises machines, Azure virtual machines (VMs), or both. Virtual Desktop can access the controllers over a site-to-site virtual private network (VPN) or ExpressRoute. Virtual Desktop needed network line of sight to a domain controller to facilitate domain join and to do user authentication.

- Azure Active Directory Domain Services (Azure AD DS) is a Microsoft managed platform as a service (PaaS) that provides AD DS in Azure. Customers don't manage the VMs for this service. Azure AD DS was originally designed for cloud-only organizations, but now supports trust relationships to existing on-premises AD DS. Azure AD DS has several limitations. For more information, see the [Azure AD DS documentation](/azure/active-directory-domain-services).

In the original scenario, Azure AD authenticated users to the Virtual Desktop and presented the users with a list of resources. Since the session hosts were all AD DS joined, AD DS then prompted users to sign in to AD DS with standard [Kerberos authentication](/windows-server/security/kerberos/kerberos-authentication-overview).

Saving user credentials with the standard Azure AD process keeps credentials for 90 days. The Windows Remote Desktop client caches the AD DS credentials in the local Credential Manager. Once you saved both sets of credentials, the user experience was single sign on (SSO)-like, because users weren't prompted for passwords after the first authentications succeeded. Caching the AD DS credentials is supported only in Windows clients.

The ability to join Virtual Desktop session host VMs to Azure AD removes the requirement for AD DS domain controllers. Removing this requirement reduces costs and complexity. Other services that the Virtual Desktop hosts consume, such as applications and Server Message Block (SMB) storage, might still require AD DS. But AD DS is no longer a requirement for Virtual Desktop itself.

Azure AD domain join supports modern authentication protocols like Windows Hello for Business, smartcards, and FIDO2. This ability provides a modern approach for future capabilities.

The following sections describe how to configure Azure AD domain join for Virtual Desktop, and provide some troubleshooting tips. For most Windows Virtual Desktop clients, the configuration consist of two steps, deploying the host pool and enabling user access. For non-Windows Virtual Desktop clients and other special cases, see [Protocol and client options](#protocol-and-client-options).

## Prerequisites

There are a few limitations for Virtual Desktop Azure AD domain join:

- Azure AD join is only supported on Virtual Desktop for Azure Resource Manager. Virtual Desktop Classic isn't supported.
- Only personal host pools are currently supported. This limitation isn't in multisession pooled host pools, but in Azure Files. Azure Files currently doesn't support Azure AD as a [Kerberos](https://en.wikipedia.org/wiki/Kerberos_(protocol)) realm, only Active Directory. This lack of Kerberos support prevents FSLogix from working. [FSLogix](/fslogix/overview) is the technology that manages roaming user profiles in a pooled host pool scenario.
- The session hosts must be Windows 10 Enterprise version 2004 or later.

### Step 1: Deploy an Azure AD join host pool

To deploy Azure AD host pools, follow the instructions in [Create a host pool](/azure/virtual-desktop/create-host-pools-azure-marketplace), and on the **Virtual Machines** tab, under **Domain to join**, select **Azure Active Directory**.

![Screenshot of Azure Virtual Desktop with both directory options.](images/Azure AD join1.png)

Selecting this option presents the option to also enroll these VMs with Intune.

![Screenshot of Virtual Desktop with the Azure AD option selected.](images/Azure AD join2.png)

In the deployment, a new extension called **AADLoginForWindows** does the Azure AD join and the Intune enrollment if selected.

![Screenshot of Virtual Desktop with Azure AD deployment completed.](images/Azure AD join3.png)

You can also add session hosts to an existing host pool and have them Azure AD joined and Intune enrolled.

After you create the host pool VMs, you can see the VMs in **Azure AD** > **Devices**.

![Azure Virtual Desktop session host V Ms listed in Azure A D devices](images/Azure AD join4.png)

The VMs also appear in the [MEM portal](https://endpoint.microsoft.com/#blade/Microsoft_Intune_DeviceSettings/DevicesMenu/overview) in the **Devices** section.

![Azure Virtual Desktop session host V Ms listed in MEM devices](images/Azure AD join5.png)

Azure AD join opens up all the Intune capabilities to apply policies, distribute software, and manage these VMs. For more information about Intune as part of Microsoft Endpoint Manager, see the [Getting started guide](https://techcommunity.microsoft.com/t5/intune-customer-success/getting-started-with-microsoft-endpoint-manager/ba-p/2497614).

If the VMs don't appear or you want to confirm enrollment, sign in to the VM locally and in a command prompt, run the following command:

```shell
dsregcmd /status
```

The output shows the Azure AD join status of the VM.

![Screenshot of the shell output from the DSREGCMD command showing Azure A D join status of YES.](images/Azure AD join6.png)

You can also confirm Azure AD registrations from the Azure portal. Go to **Azure Active Directory** > **Devices** > **Audit Logs** and look for **Register Device** in the **Activity** column.

![Screenshot of Azure AD audit logs showing Virtual Desktop session host device registrations.](images/Azure AD join7.png)

On the local client, the logs are in Event Viewer at **Applications and Services Logs** > **Microsoft** > **Windows** > **User Device Registration** > **Admin**.

> [!NOTE]
> There's no way to specify a particular Azure AD for the host VMs. The VMs automatically join to the Azure AD of the Azure subscription. The deployment inherits that Azure AD as an indentity provider and uses the user identities that Azure AD holds. 
> 
> With the AD DS scenario, you could manually deploy session host VMs in a separate subscription connected to a separate Azure AD if necessary. The VMs had no dependency on Azure AD, so they could go into any Azure subscription. These VMs only needed network line of sight to an AD DS domain controller in a domain that synchronized user objects to the Virtual Desktop objects' Azure AD.
> 
> Azure AD join doesn't support this scenario. So the VMs need to be in the same subscription as all the other Azure Virtual Desktop objects. The VMs also automatically enroll into the Intune tenant associated with the Azure AD.


## Step 2: Enable user access

In the next step, you enable sign-in access to the VMs. These VMs are Azure objects and the authentication mechanism is Azure AD, so you manage user sign-in permission through Azure role-based access control (RBAC).

To sign in to the VMs themselves, users need to be in the [Desktop Application](/azure/virtual-desktop/manage-app-groups) group, as usual. You also need to add the same Azure AD group that you added to the Virtual Desktop Desktop Application group to the **Virtual Machine User Login** RBAC role. This role isn't a [Virtual Desktop built-in role](/azure/virtual-desktop/rbac), but an Azure role.

This role has the **Log in to Virtual Machine** DataAction permission.

![Screenshot that shows the Virtual Desktop required R B A C role for V M sign in.](images/Azure AD join8.png)

You need to decide the scope to assign this role.

- Assigning the role at the **VM level** means you have to assign the role for each VM you add.
- Assigning the role at the **resource group** level means it automatically applies to all VMs in that resource group.
- Assigning the role at the **Subscription** level means users can sign in to all VMs in the subscription.

Setting the role once at the resource group level might be the best strategy. This approach saves assigning the role for every VM, while not assigning it at the top level of the subscription.

To assign this role:

1. In the Azure portal, go to your chosen scope, for example the resource group, and select **Access control (IAM)**.

   ![Screenshot showing Azure resource group Access control.](images/Azure AD join9.png)

1. At the top of the screen, select **+ Add** > **Add role assignment**.

1. Under **Role**, select **Virtual Machine User Login**, and under **Select**, find the same user group that is assigned to the Desktop Application Group.

   ![Screenshot that shows applying the required V M user login R B A C role.](images/Azure AD join10.png)

The user groups now show under **Virtual Machine User Login**.

![Screenshot showing the Virtual Desktop V M user login R B A C role applied.](images/Azure AD join11.png)

If you don't assign this role, users get an error message when they try to sign in via the Windows client.

![Screenshot of the Virtual Desktop Azure A D Other User error in the Windows client.](images/Azure AD join12.png)

Web client users get a different looking error.

![Screenshot of the Virtual Desktop Azure A D Oops error in the web client.](images/Azure AD join13.png)

### Local Admin access

To give a user local administrative access on the VM, add the user to the **Virtual Machine Administrator Login** role.

This role has one additional **Log in to Virtual Machine as administrator** DataAction permission that enables administrative access.

![Screenshot that shows the Virtual Desktop Azure A D administrator role permission.](images/Azure AD join14.png)

## Protocol and client options

Out of the box, host pool access by default only works from the [Windows Azure Virtual Desktop client](/azure/virtual-desktop/user-documentation/connect-windows-7-10?toc=/azure/virtual-desktop/toc.json&bc=/azure/virtual-desktop/breadcrumb/toc.json]. This access uses the Public Key User to User (PKU2U) protocol for authentication. To sign in to the VM, the session host and the local computer must have the PKU2U protocol enabled.

This access requires that your local computer is either:

- Azure AD-joined to the same Azure AD tenant as the session host.
- Hybrid Azure AD-joined to the same Azure AD tenant as the session host.
- Running Windows 10 version 2004 or later, and also Azure AD-registered to the same Azure AD tenant as the session host.

For Windows 10 version 2004 or later machines, if the PKU2U protocol is disabled, enable it in the Windows registry as follows:

1. Navigate to **HKLM\\SYSTEM\\CurrentControlSet\\Control\\Lsa\\pku2u**.
1. Set **AllowOnlineID** to **1**.

   ![Screenshot of the Virtual Desktop registry setting to enable the PKU2U protocol.](images/Azure AD join15.jpg)

1. If your client computers use Group Policy, also enable the following Group Policy Option:

1. Navigate to **Computer Configuration\\Policies\\Windows Settings\\Security Settings\\Local Policies\\Security Options**

1. Under **Policy**, set **Network security: Allow PKU2U authentication requests to this computer to use online identities** to **Enabled**.

   ![Screenshot of Virtual Desktop Group Policy to enable the PKU2U protocol.](images/Azure AD join16.png)

If you're using any other Virtual Desktop clients, such as macOS, Android, Web, the Store client, or pre-version 2004 Windows 10, enable the [RDSTLS protocol](/openspecs/windows_protocols/ms-rdpbcgr/83d1186d-cab6-4ad8-8c5f-203f95e192aa). Enable this protocol by adding a new [custom RDP Property](/azure/virtual-desktop/customize-rdp-properties), *targetisAzure AD joinoined:i:1*. Virtual Desktop then uses this protocol instead of PKU2U.

![Screenshot of the Virtual Desktop RDP Property to enable other clients than Windows client.](images/Azure AD join17.png)

Now you have a Virtual Desktop host pool where the session hosts are joined only to Azure AD. The host pool no longer requires Active Directory. You're a step closer to modern management for your Virtual Desktop estate. Azure AD provides many benefits for organizations, such as modern authentication protocols, SSO, and support for [FSLogix](/fslogix/overview) user profiles. Azure AD domain join capability also opens up the possibility of decommissioning Active Directory in future.
