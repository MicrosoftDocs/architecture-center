---
title: Azure AD join for Azure Virtual Desktop
description: Learn how to configure Azure AD domain join for Azure Virtual Desktop host VMs without using Active Directory Domain Services domain controllers.
author: TomHickling
ms.author: thhickli
ms.date: 11/02/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
ms.category:
  - windows-virtual-desktop
categories:
  - compute
  - hybrid
  - identity
  - windows-virtual-desktop
products:
  - azure-active-directory
  - azure-active-directory-domain
  - azure-rbac
  - azure-virtual-machines
  - azure-virtual-desktop
ms.custom:
  - fcp
---

# Azure AD join for Azure Virtual Desktop

Azure Active Directory (Azure AD) provides many benefits for organizations, such as modern authentication protocols, single sign-on (SSO), and support for [FSLogix](/fslogix/overview) user profiles. Azure Virtual Desktop virtual machine (VM) session hosts can join directly to Azure AD. Joining directly to Azure AD removes the previous need to use Active Directory Domain Services (AD DS) domain controllers.

Originally, Azure Virtual Desktop domain join needed both Azure AD and AD DS domain controllers. Traditional Windows Server AD DS domain controllers were on-premises machines, Azure VMs, or both. Azure Virtual Desktop accessed the controllers over a site-to-site virtual private network (VPN) or Azure ExpressRoute. Alternatively, [Azure Active Directory Domain Services](/azure/active-directory-domain-services) platform-as-a-service (PaaS) provided AD DS in Azure and supported trust relationships to existing on-premises AD DS. Users had to sign in to both Azure AD and AD DS.

Other services that Azure Virtual Desktop hosts consume, such as applications and Server Message Block (SMB) storage, might still require AD DS. But Azure Virtual Desktop itself no longer requires AD DS. Removing this requirement reduces cost and complexity.

Azure AD domain join for Azure Virtual Desktop provides a modern approach for smartcards, FIDO2, authentication protocols like Windows Hello for Business, and future capabilities. Azure AD domain join also opens up the possibility of decommissioning Active Directory, since Azure Virtual Directory host pools no longer require Active Directory.

This article describes how to configure Azure AD domain join for Azure Virtual Desktop, along with some troubleshooting tips. For most Windows Azure Virtual Desktop clients, the Azure AD join configuration consists of two steps, deploying the host pool and enabling user access. For non-Windows Azure Virtual Desktop clients and other cases that need further configuration, see [Protocol and client options](#protocol-and-client-options).

## Prerequisites

There are a few limitations for Azure Virtual Desktop Azure AD domain join:

- Azure AD join is only supported on Azure Virtual Desktop for Azure Resource Manager. Azure Virtual Desktop Classic isn't supported.

- Only personal host pools are currently supported. This limitation isn't in multisession pooled host pools, but in Azure Files. Azure Files currently doesn't support Azure AD as a [Kerberos](https://en.wikipedia.org/wiki/Kerberos_(protocol)) realm, only Active Directory. This lack of Kerberos support prevents FSLogix from working. FSLogix is the technology that manages roaming user profiles in a pooled host pool scenario.

- The session hosts must be Windows 10 Enterprise version 2004 or later.

## Step 1: Deploy an Azure AD join host pool

To deploy an Azure AD host pool, follow the instructions in [Create a host pool](/azure/virtual-desktop/create-host-pools-azure-marketplace). On the **Create a host pool** screen, on the **Virtual Machines** tab, under **Domain to join**, select **Azure Active Directory**.

:::image type="content" source="images/azure-ad-join.png" alt-text="Screenshot of Azure Virtual Desktop with both directory options.":::

Selecting **Azure Active Directory** presents the option to enroll the VMs with Intune. Select **Yes** if you want to enroll the VM with Intune.

Intune can apply policies, distribute software, and help you manage VMs. For more information about Intune as part of Microsoft Endpoint Manager, see [Getting started with Microsoft Endpoint Manager](https://techcommunity.microsoft.com/t5/intune-customer-success/getting-started-with-microsoft-endpoint-manager/ba-p/2497614).

:::image type="content" source="images/intune-enroll.png" alt-text="Screenshot of Azure Virtual Desktop with the Intune enroll option selected.":::

In the deployment, a new extension called **AADLoginForWindows** creates the Azure AD join and the Intune enrollment if selected.

:::image type="content" source="images/extension.png" alt-text="Screenshot of Azure Virtual Desktop with Azure AD deployment completed.":::

You can also add session hosts to an existing host pool and have them Azure AD joined and Intune enrolled.

After you create the host pool VMs, you can see the VMs in **Azure AD** > **Devices**.

:::image type="content" source="images/azure-ad-devices.png" alt-text="Screenshot of Azure Virtual Desktop session host virtual machines listed in Azure A D devices.":::

To confirm Azure AD registrations, go to **Azure Active Directory** > **Devices** > **Audit Logs** and look for **Register device**.

:::image type="content" source="images/audit-log.png" alt-text="Screenshot of Azure AD audit logs showing Azure Virtual Desktop session host device registrations.":::

The VMs also appear in the [MEM portal](https://endpoint.microsoft.com/#blade/Microsoft_Intune_DeviceSettings/DevicesMenu/overview), in the **Devices** section.

:::image type="content" source="images/mem-devices.png" alt-text="Screenshot of Azure Virtual Desktop session host virtual machines listed in M E M devices.":::

If a VM doesn't appear or you want to confirm enrollment, sign in to the VM locally and at a command prompt, run the following command:

```shell
dsregcmd /status
```

The output shows the VM's Azure AD join status.

:::image type="content" source="images/command-output.png" alt-text="Screenshot of the shell output from the command.":::

On the local client, the Azure AD registration logs are in Event Viewer at **Applications and Services Logs** > **Microsoft** > **Windows** > **User Device Registration** > **Admin**.

> [!NOTE]
> With the previous, AD DS scenario, you could manually deploy session host VMs in a separate subscription connected to a different Azure AD if necessary. The VMs had no dependency on Azure AD. The VMs only needed network line of sight to an AD DS domain controller in a domain that synchronized user objects to the Azure Virtual Desktops' Azure AD.
>
> Azure AD join doesn't support this scenario. The host VMs automatically join to the Azure AD of the subscription that deploys the VMs. The deployment inherits that Azure AD as an identity provider, and uses the user identities that the Azure AD holds. There's no way to specify a different Azure AD for the host VMs. So be sure to create the VMs in the same subscription as all the other Azure Virtual Desktop objects. The VMs also automatically enroll into the Intune tenant associated with the Azure AD.

## Step 2: Enable user access

In the next step, you enable sign-in access to the VMs. These VMs are Azure objects, and the authentication mechanism is Azure AD. You manage user sign-in permission through Azure role-based access control (RBAC).

In Azure Virtual Desktop, users must be in the Azure Virtual Desktop [Desktop application group](/azure/virtual-desktop/manage-app-groups) to sign in to the VMs. For Azure AD join, the same users and groups that are in the Desktop application group must also be added to the **Virtual Machine User Login** RBAC role. This role isn't a [Azure Virtual Desktop role](/azure/virtual-desktop/rbac), but an Azure role with the **Log in to Virtual Machine** DataAction permission.

:::image type="content" source="images/sign-in-role.png" alt-text="Screenshot that shows the Azure Virtual Desktop required role for V M sign-in.":::

Choose the scope for this role.

- Assigning the role at the **VM level** means you have to assign the role for each VM you add.
- Assigning the role at the **resource group level** means the role automatically applies to all VMs in that resource group.
- Assigning the role at the **Subscription level** means users can sign in to all VMs in the subscription.

Setting the role once at the resource group level might be the best option. This approach prevents having to assign the role for every VM, but avoids assigning it at the top level of the subscription.

To assign the **Virtual Machine User Login** role:

1. In the Azure portal, go to your chosen scope, for example the resource group, and select **Access control (IAM)**.

   :::image type="content" source="images/resource-group.png" alt-text="Screenshot showing Azure resource group Access control.":::

1. At the top of the screen, select **+ Add** > **Add role assignment**.

1. Under **Role**, select **Virtual Machine User Login**, and under **Select**, select the same user group that's assigned to the Desktop Application Group.

   :::image type="content" source="images/user-login-role.png" alt-text="Screenshot that shows applying the required V M user login role.":::

The user group now appears under **Virtual Machine User Login**.

:::image type="content" source="images/role-applied.png" alt-text="Screenshot showing the Azure Virtual Desktop V M user login role applied.":::

If you don't assign this role, users get an error message when they try to sign in via the Windows client.

:::image type="content" source="images/other-user-error.png" alt-text="Screenshot of the Azure Virtual Desktop Azure A D Other User error in the Windows client.":::

Web client users get a different-looking error.

:::image type="content" source="images/oops-error.png" alt-text="Screenshot of the Azure Virtual Desktop Azure A D Oops error in the web client.":::

### Local Admin access

To give a user local administrative access to the VM, also add the user to the **Virtual Machine Administrator Login** role. This role has a **Log in to Virtual Machine as administrator** DataAction permission that enables administrative access.

:::image type="content" source="images/admin-role.png" alt-text="Screenshot that shows the Azure Virtual Desktop Azure A D administrator role permission.":::

## Protocol and client options

By default, host pool access only works from the [Windows Azure Virtual Desktop client](/azure/virtual-desktop/user-documentation/connect-windows-7-10?toc=/azure/virtual-desktop/toc.json&bc=/azure/virtual-desktop/breadcrumb/toc.json). To access host pool VMs, your local computer must be:

- Azure AD-joined or hybrid Azure AD-joined to the same Azure AD tenant as the session host.
- Running Windows 10 version 2004 or later, and also Azure AD-registered to the same Azure AD tenant as the session host.

Host pool access uses the Public Key User to User (PKU2U) protocol for authentication. To sign in to the VM, the session host and the local computer must have the PKU2U protocol enabled. For Windows 10 version 2004 or later machines, if the PKU2U protocol is disabled, enable it in the Windows registry as follows:

1. Navigate to **HKLM\\SYSTEM\\CurrentControlSet\\Control\\Lsa\\pku2u**.
1. Set **AllowOnlineID** to **1**.

   :::image type="content" source="images/registry.png" alt-text="Screenshot of the Azure Virtual Desktop registry setting to enable the P K U 2 U protocol.":::

If your client computers use Group Policy, also enable the Group Policy Option:

1. Navigate to **Computer Configuration\\Policies\\Windows Settings\\Security Settings\\Local Policies\\Security Options**.

1. Under **Policy**, set **Network security: Allow PKU2U authentication requests to this computer to use online identities** to **Enabled**.

   :::image type="content" source="images/pku2u-protocol.png" alt-text="Screenshot of Azure Virtual Desktop Group Policy to enable the P K U 2 U protocol.":::

If you're using other Azure Virtual Desktop clients, such as Mac, iOS, Android, web, the Store client, or pre-version 2004 Windows 10, enable the [RDSTLS protocol](/openspecs/windows_protocols/ms-rdpbcgr/83d1186d-cab6-4ad8-8c5f-203f95e192aa). Enable this protocol by adding a new [custom RDP Property](/azure/virtual-desktop/customize-rdp-properties) to the host pool, *targetisaadjoined:i:1*. Azure Virtual Desktop then uses this protocol instead of PKU2U.

:::image type="content" source="images/rdp-protocol.png" alt-text="Screenshot of Azure Virtual Desktop R D P Property to enable other clients than Windows.":::

Now you have an Azure Virtual Desktop host pool where the session hosts are joined only to Azure AD. You're a step closer to modern management for your Azure Virtual Desktop estate.

## Next steps

- [Azure Virtual Desktop documentation](/azure/virtual-desktop/)
- [Deploy Azure AD-joined virtual machines in Azure Virtual Desktop](/azure/virtual-desktop/deploy-azure-ad-joined-vm)

## Related resources

- [Azure Virtual Desktop for the enterprise](windows-virtual-desktop.yml)
- [Integrate on-premises AD domains with Azure AD](../../reference-architectures/identity/azure-ad.yml)
