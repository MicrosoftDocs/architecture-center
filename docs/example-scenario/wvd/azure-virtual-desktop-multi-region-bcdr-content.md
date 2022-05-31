# Multi-Region Business Continuity and Disaster Recovery (BCDR) for Azure Virtual Desktop

Azure Virtual Desktop is a comprehensive desktop and app virtualization service running on Microsoft Azure. Virtual Desktop helps enable a secure remote desktop experience that helps organizations strengthen business resilience. It delivers simplified management, Windows 10 and 11 Enterprise multi-session, and optimizations for Microsoft 365 Apps for enterprise. With Virtual Desktop, you can deploy and scale your Windows desktops and apps on Azure in minutes, providing integrated security and compliance features to help keep your apps and data secure.

As you continue to enable remote work for your organization with Virtual Desktop, it's important to understand its disaster recovery capabilities and best practices. These practices strengthen reliability across regions to keep data safe and employees productive. This article provides you with considerations on Business Continuity and Disaster Recovery (BCDR) prerequisites, deployment steps, and best practices. You'll learn about options, strategies, and reference architectures. The content present in this document enables you to prepare a successful BCDR plan, and can help you bring more resilience to your business during planned and unplanned downtime events.

There are several types of disasters and outages, and each can have a different impact. Resiliency and recovery are discussed in depth for both local and region-wide events, including recovery of the service in a different remote Azure region. This type of recovery is called Geo Disaster Recovery. It's critical to build your Virtual Desktop architecture for resiliency and availability. You should provide maximum local resiliency to reduce the impact of failure events. This resiliency also reduces the requirements to execute recovery procedures. This article also provides information about high-availability and best-practices.

## Virtual Desktop Control Plane

Virtual Desktop offers BCDR for its control plane to preserve customer metadata during outages. When an outage occurs in a region, the service infrastructure components fail over to the secondary location and continue functioning as normal. You can still access service-related metadata, and users can still connect to available hosts. End-user connections stay online if the tenant environment or hosts remain accessible. [Data locations for Azure Virtual Desktop](https://docs.microsoft.com/azure/virtual-desktop/data-locations) are different from the location of the host pool session host virtual machines (VMs) deployment. It's possible to locate Virtual Desktop metadata in one of the supported regions, and then deploy VMs in a different location. No additional action is required by customers.

:::image type="content" source="images/avd-logical-architecture.png" alt-text="Diagram that shows the logical architecture of Virtual Desktop." lightbox="images/avd-logical-architecture.png":::

## Goals and Scope

The goals of this guide are to:

- Ensure maximum availability, resiliency, and geo-disaster recovery capability while minimizing data loss for important selected user data.
- Minimize recovery time.

These objectives are also known as the Recovery Point Objective (RPO) and the Recovery Time Objective (RTO).

:::image type="content" source="images/rpo-rto-diagram.png " alt-text="Diagram that shows an example of RTO and RPO.":::

The proposed solution provides local high-availability, protection from a single availability zone failure, and protection from an entire Azure region failure. It relies on a redundant deployment in a different, or secondary, Azure region to recover the service. While it's still a good practice, Virtual Desktop and the technology used to build BCDR don't require Azure regions to be [paired](/azure/availability-zones/cross-region-replication-azure). Primary and secondary locations can be any Azure region combination, if the network latency permits it.

To reduce the impact of a single availability zone failure, use resiliency to improve high availability:

- At the [compute](https://docs.microsoft.com/azure/virtual-desktop/faq#can-i-set-availability-options-when-creating-host-pools-) layer, spread the Virtual Desktop session hosts across different availability zones.
- At the [storage](https://docs.microsoft.com/azure/storage/common/storage-redundancy) layer, use zone resiliency whenever possible.
- At the [networking](https://docs.microsoft.com/azure/vpn-gateway/create-zone-redundant-vnet-gateway) layer, deploy zone-resilient Azure ExpressRoute and virtual private network (VPN) gateways.
- For each dependency, review the impact of a single zone outage and plan mitigations. For example, deploy Active Directory Domain Controllers (AD DC) and other external resources accessed by Virtual Desktop users across multiple zones.

Depending on the number of availability zones you use, evaluate over-provisioning the number of Session Hosts to compensate for the loss of one zone. For example, even with (n-1) zones available, you can ensure user experience and performance.

> [!NOTE]
> Azure availability zones are a high-availability feature that can improve resiliency. However, do not consider them a disaster recovery solution able to protect from region wide disasters.  

:::image type="content" source="images/azure-az-picture.png " alt-text="Image that shows Azure zones, datacenters, and geographies.":::

Because of the possible combinations of types, replication options, service capabilities, and availability restrictions in some regions, the [Cloud Cache](/fslogix/cloud-cache-resiliency-availability-cncpt) component from [FSLogix](https://docs.microsoft.com/fslogix/overview) is used over specific storage replication mechanisms.

OneDrive isn't covered in this article. For more information on redundancy and high-availability, see [SharePoint and OneDrive data resiliency in Microsoft 365](/compliance/assurance/assurance-sharepoint-onedrive-data-resiliency).

For the remainder of this article, you're going to create a reference architecture for the two different Virtual Desktop host pool types. There are also observations provided to compare with other solutions:

- **Personal**
  - In this type of host pool, a user has a permanently assigned session host, which should never change. Since it's personal, this VM can store user data. The assumption is to use replication and backup techniques to preserve and protect the state.
- **Pooled**
  - Users are temporarily assigned one of the available session host VMs from the pool, either directly through a desktop application group or by using remote apps. VMs are stateless and user data and profiles are stored in external storage or OneDrive.

Cost implications are discussed, but the primary goal is providing an effective geo disaster recovery deployment with minimal data loss.
For more BCDR details, see the following resources:

  [BCDR for Azure Virtual Desktop - Cloud Adoption Framework | Microsoft Docs](/azure/cloud-adoption-framework/scenarios/wvd/eslz-business-continuity-and-disaster-recovery)

  [Azure Virtual Desktop Disaster Recovery Plan | Microsoft Docs](/azure/virtual-desktop/disaster-recovery)

## Prerequisites

Deploy the core infrastructure and make sure it's available in the primary and the secondary Azure region. For guidance on your network topology, you can use the Azure [Cloud Adoption Framework](/azure/cloud-adoption-framework/ready/landing-zone/design-area/network-topology-and-connectivity) material:

[Traditional Hub & Spoke](/azure/cloud-adoption-framework/ready/azure-best-practices/traditional-azure-networking-topology)

:::image type="content" source="images/networking-hub-and-spoke.png " alt-text="Traditional Hub and Spoke Networking model.":::

[Azure Virtual WAN](/azure/cloud-adoption-framework/ready/azure-best-practices/virtual-wan-network-topology)

:::image type="content" source="images/networking-virtual-wan.png " alt-text="Modern Azure Virtual WAN  Networking model.":::

In both models, deploy the primary Virtual Desktop host pool and the secondary disaster recovery environment inside different *spoke* virtual networks and connect them to each *hub* in the same region. Place one hub in the primary location, one hub in the secondary location, and then establish connectivity between the two.

The *hub* eventually provides hybrid connectivity to on-premises resources, firewall services, identity resources like Active Directory Domain Controllers (AD DC), and management resources like Log Analytics.

You should consider any additional line-of-business applications and dependent resource availability when failed over to the secondary location.

## Active-Active vs. Active-Passive

If distinct sets of users have different BCDR requirements, Microsoft recommends that you use multiple host pools with different configurations. For example, users with a mission critical application might assign a fully redundant host pool with geo disaster recovery capabilities. However, dev/test users can use a separate host pool with no disaster recovery at all.

For each single Virtual Desktop host pool, you can base your BCDR strategy on an Active-Active or Active-Passive model. In this context, it's assumed that the same set of users in one geographic location is served by a specific host pool.

- **Active-Active**
  - For each host pool in the primary region, you deploy a second host pool in the secondary region.
  - This configuration provides almost zero RTO, and RPO has an additional cost.
  - You don't require administrator intervention or failover. During normal operations, the secondary host pool provides the users access to Virtual Desktop resources.
  - Each host pool has its own storage account for persistent user profiles.
  - You should evaluate latency based on the user’s physical location and connectivity available. For some Azure regions, such as West Europe and North Europe, the difference can be negligible when accessing either the primary or secondary regions. You can validate this scenario using the [Azure Virtual Desktop Experience Estimator](https://azure.microsoft.com/services/virtual-desktop/assessment) tool.
  - Users are assigned to different application groups, like Desktop and Remote Apps, in both the primary and secondary host pools. In this case, they'll see duplicate entries in their Virtual Desktop client feed. To avoid confusion, use separate Virtual Desktop Workspaces with clear names and labels that reflect the purpose of each resource. Inform your users about the usage of these resources.
  
:::image type="content" source="images/avd-multiple-workspaces.png " alt-text="Picture that explains the usage of multiple workspaces.":::

- If you need storage to manage FSLogix Profile and Office containers, use Cloud Cache to ensure almost zero RPO.
  - To avoid profile conflicts, don't permit users to access both host pools at the same time.
  - Due to the active-active nature of this scenario, you should educate your users on how to use these resources in the proper way.

- **Active-Passive**
  - Like active-active, for each host pool in the primary region, you deploy a second host pool in the secondary region.
    - The amount of compute resources active in the secondary region is reduced compared to the primary region, depending on the budget available. You can use automatic scaling to provide more compute capacity, but it requires additional time, and Azure capacity isn't guaranteed.
  - This configuration provides higher RTO when compared to the active-active approach, but it's less expensive.
  - You need administrator intervention to execute a failover procedure if there's an Azure outage. The secondary host pool doesn't normally provide the users with access to Virtual Desktop resources.
  - Each host pool has its own storage accounts for persistent user profiles.
  - Users that consume Virtual Desktop services with optimal latency and performance are affected only if there's an Azure outage. You should validate this scenario by using the [Azure Virtual Desktop Experience Estimator](https://azure.microsoft.com/services/virtual-desktop/assessment) tool. Performance should be acceptable, even if degraded, for the secondary disaster recovery environment.
  - Users are assigned to only one set of Application Groups, like Desktop and Remote Apps. During normal operations, these apps are in the primary host pool. During an outage, and after a failover, users are assigned to Application Groups in the secondary host pool. No duplicate entries are shown in the user's Virtual Desktop client feed, they can use the same workspace, and everything is transparent for them.  
  - If you need storage to manage FSLogix Profile and Office containers, use Cloud Cache to ensure almost zero RPO.
    - To avoid profile conflicts, don't permit users to access both host pools at the same time. Since this is an active-passive scenario, administrators can enforce this behavior at the application group level. Only after a failover procedure is the user able to access each application group in the secondary host pool. Access is revoked in the primary host pool application group and reassigned to an application group in the secondary host pool.
    - Execute a failover for all application groups, or users using different application groups in different host pools might cause profile conflicts if not effectively managed.
  - It's possible to allow a specific subset of users to selectively failover to the secondary host pool, and provide limited active-active behavior and test failover capability. It's also possible to failover specific application groups, but you should educate your users to not use resources from different host pools at the same time.

For specific circumstances, You can create a single host pool with a mix of session hosts located in different regions. The advantage of this solution is that if you have a single host pool, then there's no need to duplicate definitions and assignments for Desktop and Remote Apps. Unfortunately, this solution has several disadvantages.

- For pooled host pools, it isn't possible to force a user to a session host in the same region.
- A user might experience higher latency and suboptimal performance when connecting to a session host in a remote region.
- If you require storage for user profiles, you need a complex configuration to manage assignments for session hosts in the primary and secondary regions.
- You can use drain mode to temporarily disable access to session hosts located in the secondary region. But this method introduces more complexity, management overhead, and inefficient use of resources.
- You can maintain session hosts in an offline state in the secondary regions, but it introduces more complexity and management overhead.

## Considerations and recommendations

### General

This approach is based on an active-passive model with an additional Virtual Desktop host pool that you create in the secondary region. You can create this host pool inside the same workspace or a different one, depending on the model.

This approach requires you to maintain the alignment and updates, keeping both host pools in sync and at the same configuration level. In addition to a new host pool for the secondary disaster recovery region, you need:

- To create new distinct application groups and related applications for the new host pool.
- To revoke user assignments to the primary host pool, and then manually reassign them to the new host pool during the failover.

There are some limits for Virtual Desktop resources, so you should check the article Azure Virtual Desktop [service limits](/azure/azure-resource-manager/management/azure-subscription-service-limits#azure-virtual-desktop-service-limits).

For diagnostics and monitoring, use the same Log Analytics workspace for both the primary and secondary host pool.

### Compute

- For deployment of both host pools in the primary and secondary disaster recovery regions, you should use Azure availability zones and spread your VM fleet over all available zones. If availability zones aren't available in the local region, you can use an Azure availability set.
- The *Golden Image* you use for host pool deployment in the secondary disaster recovery region should be the same you use for the primary. You should store images in [Azure Compute Gallery](/azure/virtual-machines/shared-image-galleries) and configure multiple image replicas in both the primary and the secondary locations. Each image replica can sustain a parallel deployment of a maximum number of VMs, and you might require more than one based on your desired deployment batch size. For more information,  see [Store and share images in an Azure Compute Gallery](/azure/virtual-machines/shared-image-galleries#scaling).

:::image type="content" source="images/azure-compute-gallery.png " alt-text="Diagram that shows Azure Compute Gallery and Image replicas.":::

- Not all the session host VMs in the secondary disaster recovery locations must be active and running all the time. You must initially create a sufficient number of VMs, and after that, use an auto-scale mechanism like [Scaling Plans](/azure/virtual-desktop/autoscale-scaling-plan). With these mechanisms, it's possible to maintain most compute resources in an off-line or deallocated state to reduce costs.
- It's also possible to use automation to create session hosts in the secondary region only when needed. This method optimizes costs, but depending on the mechanism you use, might require a longer RTO. This approach won't permit failover tests without a new deployment, and won't permit selective failover for specific groups of users.

> [!IMPORTANT]
> You must power on each session host VM for few hours at least one time every 90 days to refresh the Virtual Desktop token needed to connect to the Virtual Desktop control plane. You should also routinely apply security patches and application updates.

- Having session hosts in an offline, or *deallocated*, state in the secondary region won't guarantee that capacity is available if there's a primary region-wide disaster. It also applies if new session are deployed on-demand when needed, and with [Azure Site Recovery](/azure/site-recovery/azure-to-azure-common-questions?#how-do-we-ensure-capacity-in-the-target-region) usage. Compute capacity can be guaranteed if:
  - Session hosts are kept in an active state in the secondary region.
  - You use the new Azure feature [On-demand Capacity Reservation](/azure/virtual-machines/capacity-reservation-overview).

> [!NOTE]
> Azure Reserved Virtual Machine Instances do not provide guaranteed capacity, but they can integrate with On-demand Capacity Reservation to reduce the cost.

- Since you use Cloud Cache:
  - You should use the premium tier for the session host VM OS managed disk.
  - You should move the [Cloud Cache](/fslogix/cloud-cache-configuration-reference#cachedirectory) to the temporary VM drive and use local SSD storage.

### Storage

In the reference architecture provided in this article, you use at least two separate storage accounts for each Virtual Desktop host pool. One is for the FSLogix Profile container, and one is for the Office container data. You also need one additional storage account for [MSIX](/azure/virtual-desktop/what-is-app-attach) packages. The following considerations apply:

- You can use [Azure Files](/azure/storage/files/storage-files-introduction) Share and [Azure NetApp Files](https://docs.microsoft.com/azure/azure-netapp-files/azure-netapp-files-introduction) as storage alternatives.
- Azure File Share can provide zone resiliency by using the zone-replicated storage resiliency option, if it's available in the region.
- You can't use the geo-redundant storage feature in the following situations:
  - If you require a non-paired region. The region pairs for geo-redundant storage are fixed and can't be changed.
  - If you're using the premium tier.
- RPO and RTO are higher compared to FSLogix Cloud Cache mechanism.
- It isn't easy to test failover and failback in a production environment.
- Azure NetApp Files has some important limitations that you should consider:
  - At this time, it doesn't provide zone-resiliency. If the resiliency requirement is more important than performance, use Azure File Share.
  - Azure NetApp Files isn't *zonal*, meaning the user can't specify which zone to deploy in.
  - You can't use Azure NetApp Files in conjunction with zone-redundant VPN and ExpressRoute gateways, which you might normally use for networking resiliency. For more information, see [Supported network topologies](/azure/azure-netapp-files/azure-netapp-files-network-topologies#supported-network-topologies).
  - ANF can't be used in conjunction to Azure Virtual WAN (see details [here](https://docs.microsoft.com/azure/azure-netapp-files/azure-netapp-files-network-topologies#supported-network-topologies)).
- ANF provides its own [cross-region replication mechanism](https://docs.microsoft.com/azure/azure-netapp-files/cross-region-replication-introduction), with the following limitations:
  - Not available in all regions.
  - Region pairs are fixed.
  - Failover isn't transparent, and failback requires storage reconfiguration.
- Limits
  - There are limits in the size, IOPS, bandwidth MB/s for both [Azure File Share](https://docs.microsoft.com/azure/storage/files/storage-files-scale-targets) and [ANF](https://docs.microsoft.com/azure/azure-netapp-files/azure-netapp-files-service-levels) storage accounts and volumes: if necessary, in Virtual Desktop is possible to use more than one for the same host pool using [Per-Group settings](https://docs.microsoft.com/fslogix/configure-per-user-per-group-ht) in FSLogix but require additional planning and configuration.

The storage account used for MSIX application packages should be distinct from the other accounts used for Profile and Office containers. The following Geo-DR options are available, the latter is recommended:

- **One single storage account with GRS enabled, in the primary region**
  - Secondary region is fixed, then not suitable for local access if there's storage account failover (RA-GRS isn't possible for Azure Files).
- **Two separate storage accounts, one in the primary region and one in the secondary region**
  - ZRS is recommended for at least the primary region, don't use GRS.
  - Each host pool in each region will have local storage access to MSIX packages with low latency.
  - MSIX packages must be copied twice in both locations and registered twice in both host pools. Users need to be assigned to the Application Groups twice. 

### FSLogix

The following FSLogix configuration and features are recommended:

- If Profile container content needs to have,  separate BCDR management and different requirements compared to Office container, it's recommended to split them (see details here):
  - Office Container is cached content only that can be rebuilt/re-populated from the sources if there's a disaster. If so, customers can consider not protecting with backups to reduce costs.
  - Using different storage accounts, backup can be enabled only on the Profile Container, or have different settings (retention period, storage used, frequency, RTO/RPO).
- [Cloud Cache](https://docs.microsoft.com/fslogix/cloud-cache-resiliency-availability-cncpt) is a FSLogix component that allows you to specify multiple profile storage locations and asynchronously replicate profile data, without relying on underlying storage replication mechanisms. If the first storage location fails, or isn't reachable, Cloud Cache will automatically failover to use the secondary, thus effectively adding a resiliency layer. Cloud Cache will be used to replicate both Profile and Office containers between different storage accounts in the primary and secondary regions.

:::image type="content" source="images/cloud-cache-general.png " alt-text="Picture representing high-level view of Cloud Cache.":::

- Cloud Cache must be enabled twice in the Session Host VM registry, once for [Profile Container](https://docs.microsoft.com/fslogix/configure-cloud-cache-tutorial#configuring-cloud-cache-for-profile-container) and once for [Office Container](https://docs.microsoft.com/fslogix/configure-cloud-cache-tutorial#configuring-cloud-cache-for-office-container). It's theoretically possible to not enable Cloud Cache for Office Container, but this might cause a data misalignment between the primary and the secondary DR region if there's failover and failback. This scenario should be carefully tested before being used in production. 
- Cloud Cache mechanism is compatible with both [profile split](https://docs.microsoft.com/fslogix/profile-container-office-container-cncpt) (Profile Container vs. Office Container) and [Per-Group](https://docs.microsoft.com/fslogix/configure-per-user-per-group-ht) settings. The latter requires careful design and planning of Active Directory Groups and membership: it must be ensured that every user will be part of exactly one Group and that Group used to grant access to host pools.
- Cloud Cache locations (*CCDLocations* parameter) specified in the registry for the host pool in the secondary DR region will be reverted in order, compared to the settings in the primary region (see [here](https://docs.microsoft.com/fslogix/configure-cloud-cache-tutorial) for additional details).

An example of the Cloud Cache configuration, and related registry keys, is reported below:

**Primary Region = North Europe**
- Profile container storage account URI = **\\northeustg1\profiles**
  - Registry Key path = **HKEY_LOCAL_MACHINE > SOFTWARE > FSLogix > Profiles**
  - *CCDLocations* value = **type=smb,connectionString=\\northeustg1\profiles;type=smb,connectionString=\\westeustg1\profiles**

:::image type="content" source="images/fslogix-cc-registry-keys.png" alt-text="Screenshot of Cloud Cache registry keys." lightbox="images/fslogix-cc-registry-keys.png":::

- Office container storage account URI = **\\northeustg2\odcf**
  - Registry Key path = **HKEY_LOCAL_MACHINE > SOFTWARE >Policy > FSLogix > ODFC**
  - *CCDLocations* value = **type=smb,connectionString=\\northeustg2\odfc;type=smb,connectionString=\\westeustg2\odfc**

:::image type="content" source="images/fslogix-cc-registry-keys-office.png" alt-text="Screenshot of Cloud Cache registry keys for Office Container." lightbox="images/fslogix-cc-registry-keys-office.png":::

> [!NOTE]
> In the screenshots above, not all the recommended registry keys for FSLogix and Cloud Cache are reported for brevity and simplicity. Please follow [this](https://docs.microsoft.com/azure/architecture/example-scenario/wvd/windows-virtual-desktop-fslogix) article for complete details.

**Secondary Region = West Europe**

- Profile container storage account URI = **\\westeustg1\profiles**
  - Registry Key path = **HKEY_LOCAL_MACHINE > SOFTWARE > FSLogix > Profiles**
  - CCDLocations value = **type=smb,connectionString=\\westeustg1\profiles;type=smb,connectionString=\\northeustg1\profiles**
- Office container storage account URI = **\\westeustg2\odcf** 
  - Registry Key path = **HKEY_LOCAL_MACHINE > SOFTWARE >Policy > FSLogix > ODFC**
  - CCDLocations value = **type=smb,connectionString=\\westeustg2\odfc;type=smb,connectionString=\\northeustg2\odfc** 

### Cloud Cache Replication

The Cloud Cache configuration and replication mechanism suggested above will guarantee profile data replication between different regions with minimal data loss. Since the same (user profile) file can be opened in ReadWrite mode by only one process, concurrent access should be avoided, thus users shouldn't open a connection to both host pools at the same time. 
In the diagram below what would happen is explained in detail:

:::image type="content" source="images/cloud-cache-replication-diagram.png" alt-text="High-level overview of Cloud Cache replication flow." lightbox="images/cloud-cache-replication-diagram.png":::

1. Virtual Desktop user will launch Virtual Desktop client and will open a published application (Desktop or Remote App) assigned on the primary region host pool.
2. FSLogix will retrieve the user Profile and Office containers and mount the underlying storage VHD/X from the storage account located in the primary region.
3. At the same time, Cloud Cache component will initialize replication between the files in the primary region and the files in the secondary region. To do this, Cloud Cache in the primary region will acquire an exclusive R/W lock on these files.
4. Now the same Virtual Desktop user wants to launch an additional published application (Desktop or Remote App) assigned on the secondary region host pool.
5. The FSLogix component running on the Virtual Desktop Session Host in the secondary region will try to mount the user profile VHD/X files from the local storage account but will fail since these files are locked by the Cloud Cache component running on Virtual Desktop Session Host in the primary region.
6. In the default FSLogix and Cloud Cache configuration, the user will be not allowed to sign-in and an error will be tracked in FSLogix diagnostic logs (*ERROR_LOCK_VIOLATION 33 (0x21)*).

:::image type="content" source="images/fslogix-log.png" alt-text="Screenshot of FSLogix diagnostic log." lightbox="images/fslogix-log.png":::

### Identity

One of the most important dependencies that Virtual Desktop needs to be always available is user identity. To access virtual desktops and remote apps from your session hosts, your users need to be able to authenticate. [Azure Active Directory](https://docs.microsoft.com/azure/active-directory/fundamentals/active-directory-whatis) (Azure AD) is Microsoft's centralized cloud identity service that enables this capability. Azure AD is always used to authenticate users for Azure Virtual Desktop. Session hosts can be joined to the same Azure AD tenant, or to an Active Directory domain using [Active Directory Domain Services](https://docs.microsoft.com/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview) (AD DS) or Azure Active Directory Domain Services (Azure AD DS), providing you with a choice of flexible configuration options.

- **Azure Active Directory**
  - It's a global multi-region and resilient service with 99.99% high-availability [SLA](https://azure.microsoft.com/support/legal/sla/active-directory/v1_1/), no additional action is required in this context as part of an Virtual Desktop BCDR plan.
- **Active Directory Domain Services**
  - For AD DS to be resilient and highly available, even if there's a region wide disaster, it's recommended to deploy at least two Domain Controllers (DC) in the primary Azure region, in different Availability Zones (AZ) if available, and ensure proper replication with the infrastructure in the secondary region and eventually on-premises. At least one additional DC should be created in the secondary region with Global Catalog and DNS roles. A reference architecture is provided in [this](https://docs.microsoft.com/azure/architecture/reference-architectures/identity/adds-extend-domain) article. 
- **Azure Active Directory (AD) Connect**
  - If you're using Azure AD with AD DS and then [Azure AD Connect](https://docs.microsoft.com/azure/active-directory/hybrid/whatis-azure-ad-connect) to synchronize user identity data between AD DS and Azure AD, then resiliency and recovery of this service should be also considered if there's protection from a permanent disaster. 
  - High availability and disaster recovery can be provided installing a second instance of the service in the secondary region and enabling [Staging Mode](https://docs.microsoft.com/azure/active-directory/hybrid/plan-connect-topologies#staging-server) (hot-standby mode).
  - If there's recovery, the administrator will be required to promote the secondary instance taking it out of staging mode following the exact procedure as placing a server into staging mode.

:::image type="content" source="images/ad-connect-configuration-wizard.png" alt-text="Screenshot of AD Connect configuration wizard.":::

- **Azure Active Directory Domain Services**
  - Can be used in some scenarios as an alternative to AD DS.
  - It offers 99.9% high-availability [SLA](https://azure.microsoft.com/support/legal/sla/active-directory-ds/v1_0/).
  - If geo disaster recovery is in scope for the specific customer scenario, it's highly recommended to deploy an additional replica in the secondary Azure region using [Replica Set](https://docs.microsoft.com/azure/active-directory-domain-services/tutorial-create-replica-set). This feature can be used also to increase high-availability in the primary region.

## Architecture Diagrams

### Personal host pool

:::image type="content" source="images/avd-personal-host-pool-diagram.png" alt-text="Reference BCDR architecture for Personal host pool." lightbox="images/avd-personal-host-pool-diagram.png":::

### Pooled host pool

:::image type="content" source="images/avd-pooled-host-pool-diagram.png" alt-text="Reference BCDR architecture for Pooled host pool." lightbox="images/avd-pooled-host-pool-diagram.png":::

## Failover and Failback

### Personal host pool Scenario

> [!NOTE]
> In this section only active-passive model will be covered since active-active wouldn't require any failover or administrator intervention.

Failover and failback for Personal host pool is different since there's no Cloud Cache and external storage used for Profile and Office containers. FSLogix technology can still be used to save containers data out from the Session Host, and/or OneDrive can be used to save what matters for the users but isn't considered in this article.  For more information, see the article [Redirect and move Windows known folders to OneDrive](https://docs.microsoft.com/onedrive/redirect-known-folders). Additionally, there will be no secondary host pool in the DR region, then no need to create additional workspaces and Virtual Desktop resources to replicate and keep aligned. The same Session Host VMs will be replicated using Azure native technology called Azure Site Recovery (Azure Site Recovery).

Azure Site Recovery can be used in several different scenarios, the one required for Virtual Desktop is Azure-to-Azure DR as described in the article and diagram below:

[Azure to Azure disaster recovery architecture in Azure Site Recovery](https://docs.microsoft.com/azure/site-recovery/azure-to-azure-architecture)

:::image type="content" source="images/asr-dr-scenario.png" alt-text="Diagram for Azure Site Recovery Azure-to-Azure DR.":::

The following considerations and recommendations apply:

- Azure Site Recovery failover isn't automatic, it must be triggered by an administrator using the Portal or [Powershell/API](https://docs.microsoft.com/azure/site-recovery/azure-to-azure-powershell).
- The entire Azure Site Recovery configuration and operations can be scripted and automated using [PowerShell](https://docs.microsoft.com/azure/site-recovery/azure-to-azure-powershell).
- Azure Site Recovery has a declared RTO inside its [Service Level Agreement](https://azure.microsoft.com/support/legal/sla/site-recovery/v1_2/) (SLA) paper of two hours. Most of the times, Azure Site Recovery can failover VMs within minutes.
- Azure Site Recovery can be used with Azure Backup, as documented in [this article](https://docs.microsoft.com/azure/site-recovery/site-recovery-backup-interoperability) for more information and limitations to be aware.
- Azure Site Recovery must be enabled at VM level, there's no direct integration in the Virtual Desktop portal experience. Failover and failback must be triggered as well at single VM level.
- Azure Site Recovery provides test failover capability in a separate subnet for general Azure VMs: it isn't recommended/supported to use this feature for Virtual Desktop VMs since you'll have two identical Virtual Desktop Session Hosts calling back home (Virtual Desktop Control Plane) at the same time.
- Azure Site Recovery doesn't maintain Virtual Machine (VM) “extensions” when replicating it. If you enabled/used any custom extension for Virtual Desktop Session Host VMs, you'll have to re-enable after failover or failback. The Virtual Desktop built-in extensions "*joindomain*” and “*Microsoft.PowerShell.DSC*” are only used at Session Host VM creation time, then it's safe to lose them after a first failover.
- Be sure to review [this article](https://docs.microsoft.com/azure/site-recovery/azure-to-azure-support-matrix) and check requirements, limitations, and compatibility matrix for Azure Site Recovery Azure-to-Azure DR scenario, specifically the supported OS versions.
- When failover a VM from one region to another, the VM starts up in the target disaster recovery region in an unprotected state. Failback is possible but user must [reprotect](https://docs.microsoft.com/azure/site-recovery/azure-to-azure-how-to-reprotect) VMs in the secondary region, and then enable replication back to the primary region.
- Periodical testing of failover and failback procedures should be executed, and an exact list of steps and recovery actions documented based on the specific Virtual Desktop environment.

> [!NOTE]
> Azure Site Recovery is now integrated with [On-Demand Capacity Reservation](https://azure.microsoft.com/blog/guarantee-capacity-access-with-ondemand-capacity-reservations-now-in-preview/). With this integration, you can use the power of capacity reservations with Site Recovery to reserve compute capacity in the disaster recovery (DR) region and guarantee your failovers. When you assign a capacity reservation group (CRG) for your protected VMs, Site Recovery will failover the VMs to that CRG. Additionally, a compute SLA gets added to the existing Site Recovery’s Recovery Time Objective (RTO) SLA of 2 hours.

### Pooled host pool Scenario

One of the desired characteristics of an active-active DR model is the lack of required administrator intervention to recover the service if there's an outage. Failover procedure should be necessary only in an active-passive architecture, then this section will refer only to this specific use case.
In active-passive model, the secondary DR region should be idle, with minimal resources (pre)configured and active, and configuration kept aligned with the primary region. If there's failover, reassignments for all users to all Desktop (DAG) and Application Groups for Remote Apps in the secondary DR host pool will happen at the same time.

It's theoretically possible to have an active-active model and partial failover. If the host pool is only used to provide DAG, then it's sufficient to partition the users in multiple non-overlapping Active Directory Groups and reassign the Group to DAG in the primary or secondary DR host pools. It shouldn't be permitted to a user to have access to both host pools at the same time. If there's multiple Application Groups and Applications, user groups used to assign users might easily overlap, in this case it would be difficult to implement an active-active strategy. Whenever a user starts a Remote App in the primary host pool, the user profile is loaded by FSLogix on a Session Host VM, then trying to do the same on the secondary host pool might cause a conflict on the underlying profile disk.

> [!WARNING]
> By default, FSLogix [registry settings](https://docs.microsoft.com/fslogix/profile-container-configuration-reference#profiletype) will prohibit concurrent access to the same user profile from multiple sessions. In this BCDR scenario it is highly recommended to do not change this behavior and leave value to ‘0’ for registry key **ProfileType**.

Before providing the list of steps for failover and failback, here's the initial situation and configuration assumptions:

- The host pools in the primary region and secondary DR regions are aligned on the configuration, including Cloud Cache.
- In the host pools, both Desktop (DAG1) and Remote App Application Groups (APPG2, APPG3), are offered to users.
- On the host pool in the primary region, AD User Groups GRP1, GRP2 and GRP3 are used to assign users to DAG1, APPG2 and APPG3. These groups might have overlapping user memberships, but since the model used here's active-passive with full failover, it doesn't represent a problem.

When failover happens, after either a planned or unplanned disaster, the list of steps is documented below:

1. On the primary host pool, for all Application Groups (DAG1, APPG2, APPG3) remove user assignment by the groups GRP1, GRP2 and GRP3.
2. Force disconnection for all connected users from the primary host pool.
3. On the secondary host pool, where the same Application Groups are configured, grant user access to DAG1, APPG2, APPG3 using groups GRP1, GRP2, GRP3.
4. Review and eventually adjust capacity of the host pool in the secondary region. Here, you might want to rely on Auto-Scale plan to automatically power on Session Hosts, or you might want to manually start immediately the necessary resources.

**Failback** steps and flow are similar, and the entire process can be executed multiple times. Cloud Cache and the configuration of storage accounts will ensure that Profile and Office containers data will be replicated. Before failback, it must be ensured that the host pool configuration and compute resources will be recovered. For the storage part, if there's data loss in the primary region, Cloud Cache will replicate back Profile and Office container data from the secondary region storage.

It's also possible to implement a Test Failover plan with a few configuration changes, without impacting the production environment:

- Create a few new User Accounts in Active Directory not previously used for production.
- Create a new Active Directory Group GRP-TEST and assign users.
- Assign access to (DAG1, APPG2, APPG3) using GRP-TEST.
- Give instructions to users in GRP-TEST to test applications.
- Execute (test) the failover procedure, just using GRP-TEST to remove access from the primary host pool and grant access to the secondary DR pool.

Finally, these are some important recommendations:

- It's highly recommended to automate the failover process using PowerShell, AZ CLI, or other available API/tool.
- The entire failover and failback procedure should be tested extensively and periodically.
- A regular configuration alignment check should be conducted to ensure host pools in the primary and secondary DR region are in sync.

## Backup

As part of the assumption for this guide, we assumed profile split and data separation between Profile Containers and Office Containers.
FSLogix does permit this configuration, and the usage of separate storage accounts. Once in separate storage accounts, different backup policies can be used:

- For Office Container, if the content does represent only cached data that could be easily rebuilt from on-line data store (Office 365), it isn't necessary to backup.
- If necessary to backup Office container data, it could be done using a less expensive storage and/or different backup frequency and retention period.
- For Personal host pool type, backup should be executed at the Session Host VM level, if data is stored locally.
- If OneDrive is used, along with known folder redirection, the requirement to save data inside the container might disappear.

> [!NOTE]
> OneDrive backup is not considered in this article and scenario.

- Without a specific additional required, backup for the storage in the primary region should be enough, backup of DR environment isn't normally used.
- For Azure Files Share, the recommended solution is [Azure Backup](https://docs.microsoft.com/azure/backup/azure-file-share-backup-overview).
  - For the vault [resiliency type](https://docs.microsoft.com/azure/storage/common/storage-redundancy), ZRS is recommended if off-site/region backup storage isn't strictly required, otherwise GRS should be considered.
- For Azure NetApp Files (ANF) provides its own recommended backup solution, currently in preview and can provide ZRS storage resiliency.
  - Feature [availability](https://docs.microsoft.com/azure/azure-netapp-files/backup-requirements-considerations) in the region must be checked, along with requirements and limitations.
- The separate storage accounts used for MSIX should be also covered by backup if the application packages repositories can't be easily rebuilt.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

**Principal authors:**

- [Ben Martin Baur](https://www.linkedin.com/in/ben-martin-baur) | Cloud Solution Architect
- [Igor Pagliai](https://www.linkedin.com/in/igorpag) | FastTrack for Azure (FTA) Principal Engineer

**Other contributors:**

- [Jason Martinez](https://www.linkedin.com/in/jason-martinez-502766123) | Technical Writer

## Next steps

- To learn about FSLogix, see [FSLogix for the enterprise](https://docs.microsoft.com/azure/architecture/example-scenario/wvd/windows-virtual-desktop-fslogix).
- To learn about Cloud Cache resiliency and availability, see [Cloud Cache to create resiliency and availability](https://docs.microsoft.com/fslogix/cloud-cache-resiliency-availability-cncpt)

## Related resources

- [Architecting Azure applications for resiliency and availability](https://docs.microsoft.com/azure/architecture/reliability/architect)
- [BCDR for Azure Virtual Desktop - Cloud Adoption Framework](https://docs.microsoft.com/azure/cloud-adoption-framework/scenarios/wvd/eslz-business-continuity-and-disaster-recovery)
- [Azure Virtual Desktop disaster recovery plan](https://docs.microsoft.com/azure/virtual-desktop/disaster-recovery)
- [Azure Virtual Desktop for the enterprise](windows-virtual-desktop.yml)
