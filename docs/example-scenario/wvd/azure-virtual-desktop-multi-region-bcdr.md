---
title: Multi-Region Business Continuity and Disaster Recovery (BCDR) for Azure Virtual Desktop
description: Learn which options and scenarios are possible to design and implement an effective multi-region BCDR strategy for Azure Virtual Desktop.
author: IgorPagliai
ms.author: igorpag
ms.date: 04/22/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
ms.category:
  - windows-virtual-desktop
categories:
  - compute
  - hybrid
  - windows-virtual-desktop
products:
  - azure-active-directory
  - azure-active-directory-domain
  - azure-rbac
  - azure-virtual-machines
  - windows-virtual-desktop
ms.custom:
  - fcp
---

# Multi-Region Business Continuity and Disaster Recovery (BCDR) for Azure Virtual Desktop

Azure Virtual Desktop (AVD) is a comprehensive desktop and app virtualization service running on Microsoft Azure that helps enable a secure remote desktop experience, helping organizations strengthen business resilience. It delivers simplified management, Windows 10/11 Enterprise multi-session and optimizations for Microsoft 365 Apps for enterprise. Azure Virtual Desktop (AVD) also allows you to deploy and scale your Windows desktops and apps on Azure in minutes, providing integrated security and compliance features to help you keep your apps and data secure.
As you progress on your journey of enabling remote working for your organization with Azure Virtual Desktop, it is important to understand the disaster recovery capabilities and best practices to strengthen reliability across regions, to keep data safe and employees productive.
This article will provide you with considerations on Business Continuity and Disaster Recovery (BCDR) prerequisites, deployment steps, and best practices. Diverse options and strategies will be discussed, and reference architectures will be offered. This will enable you to prepare a successful BCDR plan, helping you bring more resilience to your business during planned and un-planned downtime events.
Disasters and outages can be of several types and have different impact: resiliency and recovery will be discussed in depth for both local and region-wide events, also including recovery of the service in a different remote Azure region (Geo Disaster Recovery - Geo-DR).
Architecting AVD for resiliency and availability, before BCDR, is also critical. Providing maximum local resiliency will reduce the impact of failure events and will reduce the requirement to execute recovery procedures. In this document, high-availability will also be considered, and best-practices provided.

## Azure Virtual Desktop Control Plane

Azure Virtual Desktop (AVD) offers BCDR for its control plane to preserve customer metadata during outages. When an outage occurs in a region, the service infrastructure components will fail over to the secondary location and continue functioning as normal. You can still access service-related metadata, and users can still connect to available hosts. End-user connections will stay online if the tenant environment or hosts remain accessible. [Location of AVD metadata](https://docs.microsoft.com/azure/virtual-desktop/data-locations) is different from location of Host Pool Session Host VMs (Virtual Machines) deployment: it is possible and supported to locate AVD metadata in one of the supported regions and deploy VMs in a different location. No additional action is required by customers.

:::image type="content" source="images/avd-logical-architecture.png" alt-text="Logical Architecture of Azure Virtual Desktop.":::

## Reference Architecture Goals and Scope

The main goal of this reference architecture is to ensure maximum availability, resiliency and geo-disaster recovery capability minimizing data loss (RPO - recovery point objective) for important selected user data, and recovery time (RTO = Recovery Time Objective).

:::image type="content" source="images/rpo-rto-diagram.png " alt-text="Considering RTO and RPO image.":::

The proposed solution will provide local high-availability, protection from a single Availability Zone (AZ) failure and protection from an entire Azure region failure. It will rely on a redundant deployment in a different Azure region (secondary) to recover the service (geo disaster recovery). While it is still a recommended good practice, AVD and the technology used to build BCDR do not require Azure regions to be [paired](https://docs.microsoft.com/azure/availability-zones/cross-region-replication-azure). If the network latency permits, primary and secondary locations can be any Azure region combination.

To reduce the impact of single Availability Zone (AZ) failure, it is still recommended to leverage AZ resiliency to improve high availability:

- At the [compute](https://docs.microsoft.com/azure/virtual-desktop/faq#can-i-set-availability-options-when-creating-host-pools-) layer spreading the AVD Session Hosts across different AZ.
- At the [storage](https://docs.microsoft.com/azure/storage/common/storage-redundancy) layer using zone-resiliency, whenever possible and available.
- At the [networking](https://docs.microsoft.com/azure/vpn-gateway/create-zone-redundant-vnet-gateway) layer deploying zone-resilient Express Route and VPN (virtual private networks) gateways.
- For each dependency, for example for Active Directory Domain Controllers (AD DC) and other external resources accessed by AVD users.

Depending on the number of AZ used, customers should evaluate over-provisioning the number of Session Hosts to compensate for the loss of one zone: in this case, even with (n-1) zones available, user experience and performances will be ensured.

> [!NOTE]
> Azure AZ should be considered a high-availability feature that can improve resiliency but should not be considered a disaster recovery solution able to protect from region wide disasters.  

:::image type="content" source="images/azure-az-picture.png " alt-text="Picture showing Azure Zones, Datacenters and Geographies.":::

For the storage part, due to the many possible combinations of types, replication options, service capabilities, and availability restrictions in some regions, FSLogix Cloud Cache will be used over specific storage replication mechanisms. OneDrive is not covered and assumed to be highly redundant and globally available.
In the remaining part of this content, a reference architecture will be produced for the two different AVD Host Pool types, and observations will also be provided to compare with other solutions:

- **Personal**
  - In this type of Host Pool, a user will have permanently assigned a Session Host, and should never change. Since personal, this VM (virtual machine) can store user data, then the assumption is that the state needs to be preserved and protected with replication and backup techniques.
- **Pooled**
  - Users will get temporarily assigned one of the available Session Host VM from the Pool, directly through Desktop Application Group (DAG), or using Remote Apps. VM will be essentially stateless, user data and profile will be stored in external storage, and/or in OneDrive.

Cost implications will be discussed and included, without diminishing the primary goal, that is providing an effective geo-DR deployment with minimal data loss.
For additional BCDR details, it is possible to review the documentation below:

  [BCDR for Azure Virtual Desktop - Cloud Adoption Framework | Microsoft Docs](https://docs.microsoft.com/azure/cloud-adoption-framework/scenarios/wvd/eslz-business-continuity-and-disaster-recovery)

  [Azure Virtual Desktop Disaster Recovery Plan | Microsoft Docs](https://docs.microsoft.com/azure/virtual-desktop/disaster-recovery)

## Prerequisites

Core infrastructure needs to be deployed and available in the primary and the secondary Azure region . For guidance on the possible network topology to use, it is possible to leverage the Azure [Cloud Adoption Framework](https://docs.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/design-area/network-topology-and-connectivity) (CAF) material:

[Traditional Hub&Spoke](https://docs.microsoft.com/azure/cloud-adoption-framework/ready/azure-best-practices/traditional-azure-networking-topology)

:::image type="content" source="images/networking-hub-and-spoke.png " alt-text="Traditional Hub and Spoke Networking model.":::

[Azure Virtual WAN](https://docs.microsoft.com/azure/cloud-adoption-framework/ready/azure-best-practices/virtual-wan-network-topology)

:::image type="content" source="images/networking-virtual-wan.png " alt-text="Modern Azure Virtual WAN  Networking model.":::

In both models, both the primary AVD Host Pool and the secondary DR environment will be deployed inside different “*spoke*” Virtual Networks (VNETs), connected to each “*hub*” in the same region: one in the primary and one in the secondary locations, connectivity between the two will be established.
The “*hub*” will also provide eventual hybrid connectivity to on-premises resources and firewall services, identity resources (Active Directory Domain Controllers, etc.), management resources (Log Analytics, etc.).
Any additional line-of-business applications and dependent resource availability must be also considered when failed over to the secondary location.

## Active-Active vs. Active-Passive

If distinct sets of users have different BCDR requirements, it is recommended to use multiple Host Pools with different configurations. For example: users using a mission critical application may have assigned a fully redundant Host Pool with Geo-DR capabilities, while for dev/test users can use a separate Host Pool with no DR at all.

For each single AVD Host Pool, a BCDR strategy can be based on Active-Active or Active-Passive model. In this context, we assume the same set of users in one geographic location is served by a specific Host Pool. 

- **Active-Active**
  - For each Host Pool in the primary region, a second Host Pool is deployed in the secondary region.
  - This configuration will provide almost zero RTO and RPO with an additional cost.
  - Administrator intervention is not required, and no failover is needed. During normal operations, that is not in presence of an Azure outage, the secondary Host Pool does provide the users access to AVD resources.
  - Each Host Pool has its own storage account/s if user profiles must be persisted.
  - Depending on the user’s physical location and connectivity available, latency should be evaluated: for some Azure regions, for example West Europe and North Europe, the difference can be negligible accessing either the primary or secondary regions. It is recommended to validate this scenario using the [Azure Virtual Desktop Experience Estimator](https://azure.microsoft.com/services/virtual-desktop/assessment) tool.
  - Users will be assigned to different Application Groups (Desktop and/or Remote Apps) in both the primary Host Pool and in the secondary Host Pool, then they will see duplicate entries in their AVD client feed. To avoid confusion, it is recommended to use separate AVD Workspaces with clear names and labels that will reflect the purpose of each resource. Users should be informed about the usage of these resources.
  
:::image type="content" source="images/avd-multiple-workspaces.png " alt-text="Picture explaining usage of multiple workspaces.":::

  - If storage is required to manage FSLogix Profile and Office containers, Cloud Cache is the solution used to ensure almost zero RPO.
    - To avoid profile conflicts, users should not be permitted to access both Host Pools at the same time.
    - Due to the active-active nature of this scenario, users should be educated on how to use these resources in the proper way.

- **Active-Passive**
  - For each Host Pool in the primary region, a second Host Pool is deployed in the secondary region, as in the previous case.
    - The amount of compute resources active in the secondary region is generally reduced compared to the primary region, depending on the budget available. Automatic scaling could be used to provide more compute capacity but will require some additional time and Azure capacity is not guaranteed.
  - This configuration will provide higher RTO, compared to the active-active approach, but will be less expensive.
  - Administrator intervention is required to execute a failover procedure in presence of an Azure outage. The secondary Host Pool does not generally provide the users with access to AVD resources, only the primary Host Pool does.
  - Each Host Pool has its own storage account/s if user profiles must be persisted.
  - Users will leverage AVD with optimal latency and performance, will eventually be  affected only in case of an Azure outage. It is recommended to validate this scenario using the [Azure Virtual Desktop Experience Estimator](https://azure.microsoft.com/services/virtual-desktop/assessment) tool, performances should be acceptable, even if degraded, also for the secondary DR environment.
  - Users will be assigned to only one set of Application Groups (Desktop and/or Remote Apps). During normal operations, these will be in the primary Host Pool. During an outage, and after a failover, users will be assigned to Application Groups in the secondary Host Pool. No duplicate entries will be shown in the user AVD client feed, then the same workspace can be used, everything will be transparent to the users.  
  - If storage is required to manage FSLogix Profile and Office containers, Cloud Cache is the solution used to ensure almost zero RPO.
    - To avoid profile conflicts, users should not be permitted to access both Host Pools at the same time. Since this is an active-passive scenario, administrators will be able to enforce this behavior at the Application Group level: only after a failover procedure will users be able to access each Application Group in the secondary Host Pool. Access will be revoked in the primary Host Pool Application Group and (re)assigned  to an Application Group in the secondary Host Pool.
    - Failover should be executed for all Application Groups, otherwise users using different Application Groups in different Host Pools could still cause profile conflicts if not effectively managed.
  - It is technically possible to allow a specific subset of users to selectively failover to the secondary Host Pool, thus providing limited active-active behavior and test failover capability. It is also possible to failover only specifics Application Groups, but users should be educated not to use resources from different Host Pools at the same time.

For specific circumstances, a single Host Pool can be created with a mix of Session Hosts located in different   regions. The advantage of this solution is to have a single Host Pool, then no need to duplicate definitions and assignments for Desktop and Remote Apps. This solution unfortunately presents several disadvantages:

- For Pooled Host Pools, it is not possible to force a user to a Session Host in the same region.
- A user could experience higher latency and not optimal performances connecting to a Session Host in a remote region.
- In case storage is required for user profiles, complex configuration would be required to manage assignment for Session Hosts in the primary region, and Session Hosts in the secondary region.
- Drain Mode could be used to temporarily disable access to Session Hosts located in the secondary region but would introduce more complexity, management overhead and inefficient use of resources
- Session Hosts located in the secondary regions can be maintained in an offline state but will introduce more complexity and management overhead.











## Prerequisites2

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
