---
title: Azure AD join for Azure Virtual Desktop
description: Learn how to configure Azure AD domain join for Azure Virtual Desktop host VMs without using Active Directory Domain Services domain controllers.
author: TomHickling
ms.author: thhickli
ms.date: 07/08/2022
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
  - entra
  - azure-rbac
  - azure-virtual-machines
  - azure-virtual-desktop
ms.custom:
  - kr2b-contr-experiment
  - fcp
---

# Azure AD join for Azure Virtual Desktop

Azure Active Directory (Azure AD) provides many benefits for organizations, such as modern authentication protocols, single sign-on (SSO), and support for [FSLogix](/fslogix/overview) user profiles. Azure Virtual Desktop virtual machine (VM) session hosts can join directly to Azure AD. Joining directly to Azure AD removes an earlier need to use Active Directory Domain Services (AD DS) domain controllers.

Originally, Azure Virtual Desktop domain join needed both Azure AD and AD DS domain controllers. Traditional Windows Server AD DS domain controllers were on-premises machines, Azure VMs, or both. Azure Virtual Desktop accessed the controllers over a site-to-site virtual private network (VPN) or Azure ExpressRoute. Alternatively, [Azure Active Directory Domain Services](/azure/active-directory-domain-services) platform-as-a-service (PaaS) provided AD DS in Azure and supported trust relationships to existing on-premises AD DS. Users had to sign in to both Azure AD and AD DS.

Applications, Server Message Block (SMB) storage, and other services that Azure Virtual Desktop hosts consume might still require AD DS. But Azure Virtual Desktop itself no longer requires AD DS. Removing this requirement reduces cost and complexity.

Azure AD domain join for Azure Virtual Desktop provides a modern approach for smartcards, FIDO2, authentication protocols like Windows Hello for Business, and future capabilities. Azure AD domain join also opens up the possibility of decommissioning Active Directory, since Azure Virtual Directory host pools no longer require Active Directory.

This article describes how to configure Azure AD domain join for Azure Virtual Desktop, along with some troubleshooting tips. For most Windows Azure Virtual Desktop clients, the Azure AD join configuration consists of two steps, deploying the host pool and enabling user access. For non-Windows Azure Virtual Desktop clients and other cases that need further configuration, see [Protocol and client options](#protocol-and-client-options).

## Prerequisites

Azure Virtual Desktop Azure AD domain join has some limitations:

- Azure AD join is only supported on Azure Virtual Desktop for Azure Resource Manager. Azure Virtual Desktop Classic isn't supported.

- Azure Virtual Desktop supports Azure AD join for both personal and pooled host pools.

- Azure Files now supports Azure AD as a [Kerberos](https://en.wikipedia.org/wiki/Kerberos_(protocol)) realm. This allows you to create an Azure Files share to store the FSLogix profiles and to configure it to support Azure AD authentication. FSLogix is the technology that enables and manages roaming user profiles in a pooled host pool scenario. The added support for FSLogix profiles combines the cost optimization of using a pooled environment shared among users with the key benefits of Azure AD-joined VMs. There is no line-of-sight to a domain controller, it's a simplified deployment, and you get enhanced management with Intune. 

   The new Azure AD functionality leveraged in this solution allows Azure AD to issue Kerberos tickets to access Service Message Block (SMB) shares. This removes the need to have access to a domain controller from the session host VM and network share. You can now store your FSLogix user profiles on Azure Files shares and access them from Azure AD-joined VMs. This functionality currently requires you to have hybrid identities, managed in Active Directory. 

- The session hosts must be Windows 10 Enterprise version 2004 or later.

## Step 1: Deploy an Azure AD join host pool

To deploy an Azure AD host pool, follow the instructions in [Create a host pool](/azure/virtual-desktop/create-host-pools-azure-marketplace). On the **Create a host pool** screen, on the **Virtual Machines** tab, under **Domain to join**, select **Azure Active Directory**.

:::image type="content" source="images/azure-ad-join.png" alt-text="Screenshot that shows Azure Virtual Desktop with both directory options.":::

To see an option to enroll VMs with Intune, select **Azure Active Directory**. Select **Yes** if you want to enroll the VM with Intune.

Intune can apply policies, distribute software, and help you manage VMs. For more information about Intune as part of Microsoft Endpoint Manager, see [Getting started with Microsoft Endpoint Manager](https://techcommunity.microsoft.com/t5/intune-customer-success/getting-started-with-microsoft-endpoint-manager/ba-p/2497614).

:::image type="content" source="images/intune-enroll.png" alt-text="Screenshot that shows Azure Virtual Desktop with the Intune enroll option selected.":::

During deployment, a new extension called **AADLoginForWindows** creates Azure AD join and Intune enrollment, if it's selected.

:::image type="content" source="images/extension.png" alt-text="Screenshot that shows Azure Virtual Desktop with Azure AD deployment completed.":::

You can also add session hosts to an existing host pool. Then you can have them Azure AD joined and Intune enrolled.

After you create host pool VMs, you can see the VMs by going to **Azure AD** and selecting **Devices**.

:::image type="content" source="images/azure-ad-devices.png" alt-text="Screenshot that shows Azure Virtual Desktop session host virtual machines listed in Azure A D devices.":::

To confirm Azure AD registrations, go to **Azure Active Directory** > **Devices** > **Audit Logs** and select **Register device**.

:::image type="content" source="images/audit-log.png" alt-text="Screenshot that shows Azure AD audit logs displaying Azure Virtual Desktop session host device registrations.":::

VMs also appear in the [MEM portal](https://endpoint.microsoft.com/#blade/Microsoft_Intune_DeviceSettings/DevicesMenu/overview), in the **Devices** section.

:::image type="content" source="images/mem-devices.png" alt-text="Screenshot that shows Azure Virtual Desktop session host virtual machines listed in M E M devices.":::

If a VM doesn't appear or you want to confirm enrollment, sign in to the VM locally. Then open a command prompt app to run the following command:

```shell
dsregcmd /status
```

The output displays the VM's Azure AD join status.

:::image type="content" source="images/command-output.png" alt-text="Screenshot that shows shell output from the command.":::

Azure AD registration logs are in Event Viewer on the local client. You can view them by navigating to **Applications and Services Logs** > **Microsoft** > **Windows** > **User Device Registration** > **Admin**.

> [!NOTE]
> In earlier AD DS scenarios, you were able to manually deploy session host VMs in all types of subscriptions, even when they were connected to different Azure ADs. VMs had no dependency on Azure AD. They only needed network line of sight to AD DS domain controllers that synchronized user objects to Azure Virtual Desktops' Azure AD.
>
> With Azure AD join, be sure to create VMs in the same subscription as your other Azure Virtual Desktop objects. Host VMs automatically join the subscription of the Azure AD that deploys them and they inherit the Azure AD as their identity providers. This means they that have the same user identities as the Azure AD. There's no way to specify a different Azure AD for host VMs. VMs also automatically enroll in the Intune tenant associated with Azure ADs.

## Step 2: Enable user access

In the next step, you enable sign-in access to the VMs. These VMs are Azure objects, and the authentication mechanism is Azure AD. You can manage user sign-in permission through Azure role-based access control (RBAC).

Users must be in the Azure Virtual Desktop [Desktop application group](/azure/virtual-desktop/manage-app-groups) to sign in to VMs. For Azure AD join, the same users and groups that are in the Desktop application group must also be added to the **Virtual Machine User Login** RBAC role. This role isn't an [Azure Virtual Desktop role](/azure/virtual-desktop/rbac), but an Azure role with **Log in to Virtual Machine** DataAction permission.

:::image type="content" source="images/sign-in-role.png" alt-text="Screenshot that shows the Azure Virtual Desktop required role for V M sign-in.":::

Choose the scope for this role.

- Assigning the role at the **VM level** means you have to assign the role for every VM that you add.
- Assigning the role at the **resource group level** means the role automatically applies to all VMs within a resource group.
- Assigning the role at the **Subscription level** means users can sign in to all VMs within a subscription.

Setting roles once at the resource group level might be the best option. This approach eliminates the need to assign roles for every VM. It also helps you avoid assigning roles at the top level of subscriptions.

To assign the **Virtual Machine User Login** role:

1. In the Azure portal, go to your chosen scope, for example the resource group, and select **Access control (IAM)**.

   :::image type="content" source="images/resource-group.png" alt-text="Screenshot that shows Azure resource group Access control.":::

1. At the top of the screen, select **+ Add** > **Add role assignment**.

1. Under **Role**, select **Virtual Machine User Login**, and under **Select**, select the same user group that's assigned to the Desktop Application Group.

   :::image type="content" source="images/user-login-role.png" alt-text="Screenshot that shows applying the required V M user login role.":::

The user group now appears under **Virtual Machine User Login**.

:::image type="content" source="images/role-applied.png" alt-text="Screenshot that shows the Azure Virtual Desktop V M user login role applied.":::

If you don't assign this role, users get an error message when they try to sign in via the Windows client.

:::image type="content" source="images/other-user-error.png" alt-text="Screenshot that shows the Azure Virtual Desktop Azure A D Other User error in the Windows client.":::

Web client users get an error that looks different.

:::image type="content" source="images/oops-error.png" alt-text="Screenshot that shows the Azure Virtual Desktop Azure A D Oops error in the web client.":::

### Local Admin access

To give a user local administrative access to a VM, add the user to the **Virtual Machine Administrator Login** role. This role has a **Log in to Virtual Machine as administrator** DataAction permission that enables administrative access.

:::image type="content" source="images/admin-role.png" alt-text="Screenshot that shows the Azure Virtual Desktop Azure A D administrator role permission.":::

## Protocol and client options

By default, host pool access only works from the [Windows Azure Virtual Desktop client](/azure/virtual-desktop/user-documentation/connect-windows-7-10?toc=/azure/virtual-desktop/toc.json&bc=/azure/virtual-desktop/breadcrumb/toc.json). To access host pool VMs, your local computer must be:

- Azure AD-joined or hybrid Azure AD-joined to the same Azure AD tenant as the session host.
- Running Windows 10 version 2004 or later, and also Azure AD-registered to the same Azure AD tenant as the session host.

Host pool access uses the Public Key User-to-User (PKU2U) protocol for authentication. To sign in to the VM, the session host and the local computer must have the PKU2U protocol enabled. For Windows 10 version 2004 or later machines, if the PKU2U protocol is disabled, enable it in the Windows registry as follows:

1. Navigate to **HKLM\\SYSTEM\\CurrentControlSet\\Control\\Lsa\\pku2u**.
1. Set **AllowOnlineID** to **1**.

   :::image type="content" source="images/registry.png" alt-text="Screenshot that shows the Azure Virtual Desktop registry setting, which enables the P K U 2 U protocol.":::

If your client computers use Group Policy, also enable the Group Policy Option:

1. Navigate to **Computer Configuration\\Policies\\Windows Settings\\Security Settings\\Local Policies\\Security Options**.

1. Under **Policy**, set **Network security: Allow PKU2U authentication requests to this computer to use online identities** to **Enabled**.

   :::image type="content" source="images/pku2u-protocol.png" alt-text="Screenshot that shows Azure Virtual Desktop Group Policy, which enables the P K U 2 U protocol.":::

If you're using other Azure Virtual Desktop clients, such as Mac, iOS, Android, web, the Store client, or pre-version 2004 Windows 10, enable the [RDSTLS protocol](/openspecs/windows_protocols/ms-rdpbcgr/83d1186d-cab6-4ad8-8c5f-203f95e192aa). Enable this protocol by adding a new [custom RDP Property](/azure/virtual-desktop/customize-rdp-properties) to the host pool, *targetisaadjoined:i:1*. Azure Virtual Desktop then uses this protocol instead of PKU2U.

:::image type="content" source="images/rdp-protocol.png" alt-text="Screenshot that shows Azure Virtual Desktop R D P Property, which enables other clients than Windows.":::

Now you have an Azure Virtual Desktop host pool where session hosts are joined only to Azure AD. You're a step closer to modern management for your Azure Virtual Desktop estate.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Tom Hickling](https://www.linkedin.com/in/tomhickling) | Senior Product Manager, Azure Virtual Desktop Engineering

Other contributor:

- [Grace Picking](https://www.linkedin.com/in/grace-picking/) | Senior Product Manager, Azure Active Directory Engineering

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Azure Virtual Desktop documentation](/azure/virtual-desktop)
- [Deploy Azure AD-joined virtual machines in Azure Virtual Desktop](/azure/virtual-desktop/deploy-azure-ad-joined-vm)

## Related resources

- [Azure Virtual Desktop for the enterprise](windows-virtual-desktop.yml)
- [Integrate on-premises AD domains with Azure AD](../../reference-architectures/identity/azure-ad.yml)
