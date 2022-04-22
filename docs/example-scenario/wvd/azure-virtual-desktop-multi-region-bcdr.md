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

## Considerations & Recommendations

### AVD General

This reference architecture is based on an active-passive model with an additional AVD Host Pool that will be created in the secondary region. This additional Host Pool can be created inside the same Workspace or different one, depending on the model.
Using this approach will require maintaining the alignment and updating to keep both host pools in sync and to the same level  the configuration of both Host Pools. Specifically, in addition to a new Host Pool for the secondary DR region:

- New distinct Application Groups (and related applications) must be created for the new Host Pool.
- During the failover, user assignments to the primary Host Pool must be revoked and manually re-assigned to the new one.

There are some limits for AVD resources, so it is highly recommended to check the article Azure Virtual Desktop [service limits](https://docs.microsoft.com/azure/azure-resource-manager/management/azure-subscription-service-limits#azure-virtual-desktop-service-limits).
For diagnostics and monitoring, we do recommend using the same Log Analytics workspace for both the primary and secondary Host Pool.

### Compute

- For deployment of both Host Pools in the primary and secondary DR regions, it is highly recommended to leverage Azure Availability Zones (AZ) and spread the VM fleet over all available zones. If not available in the local region, Azure Availability Set (AS) can be used.
- The *Golden Image* used for Host Pool deployment in the secondary DR region should be the same used for the primary. It is highly recommended to store  images in [Azure Compute Gallery](https://docs.microsoft.com/azure/virtual-machines/shared-image-galleries) and configure multiple image replicas in both the primary and the secondary locations . Each image replica can sustain a parallel deployment of a maximum number of VMs, more than one maybe required, based on your desired deployment batch size, as described in this [article](https://docs.microsoft.com/azure/virtual-machines/shared-image-galleries#scaling).

:::image type="content" source="images/azure-compute-gallery.png " alt-text="Diagram for Azure Compute Gallery and Image replicas.":::

- Not all the Session Host VMs in the secondary DR locations must be active and running all the time (Pooled Pools). A sufficient number of VMs must be initially created, and after that, using auto-scale mechanism like [Scaling Plans](https://docs.microsoft.com/azure/virtual-desktop/autoscale-scaling-plan), it is possible to maintain majority of compute resources in off-line/deallocated state to reduce costs.
- As a variation from the previous point, it is also possible to create Session Hosts in the secondary region only when needed using automation: this will optimize costs but will require a longer recovery time (RTO) depending on the mechanism used. This approach will not permit failover tests without a new deployment and will not permit selective failover for specifics group of users.

> [!IMPORTANT]
> Each Session Host VM must be powered on for few hours at least one time every 90 days (about 3 months) to refresh AVD token necessary to connect to the AVD control plane. Security patches and application updates should be also routinely applied.

- Having Session Hosts in offline (*deallocated*) state in the secondary region will not guarantee capacity to be available in case of a primary region wide disaster. This is also true if new Session Hosts will be deployed on-demand when needed, and in the case of [Azure Site Recovery](https://docs.microsoft.com/azure/site-recovery/azure-to-azure-common-questions?#how-do-we-ensure-capacity-in-the-target-region) usage. Compute capacity can be guaranteed if:
  - Session Hosts will be kept in an active state in the secondary region.
  - Use the new Azure feature [On-demand Capacity Reservation](https://docs.microsoft.com/azure/virtual-machines/capacity-reservation-overview).

> [!NOTE]
> Azure Reserved Instances (RI) does not provide guaranteed capacity but can integrate with On-demand Capacity Reservation to reduce the cost.

- Since Cloud Cache will be used:
  - It is recommended to leverage Premium tier for the Session Host VM OS managed disk.
  - It is recommended to move the [Cloud Cache](https://docs.microsoft.com/azure/virtual-machines/capacity-reservation-overview) to the temporary VM drive to leverage local SSD storage.

### Storage

In the reference architecture provided in this article, at least two separate storage accounts will be used for each AVD Host Pool: one for FSLogix Profile container and one for Office container data. One additional storage account required for MSIX packages. The following considerations apply:

- [Azure Files](https://docs.microsoft.com/azure/storage/files/storage-files-introduction) Share and [Azure NetApp Files](https://docs.microsoft.com/azure/azure-netapp-files/azure-netapp-files-introduction) (ANF) are the recommended storage alternatives.
- Azure File Share can provide zone resiliency through the usage of Zone-Replicated Storage resiliency option (ZRS), which is recommended if available in the region.
- Geo-Redundant Storage (GRS) feature cannot be leveraged in the following situations:
  - A non-paired region is required; the region pairs for GRS are fixed and cannot be changed.
  - GRS is not available for Premium tier, which is often used in AVD.
  - RPO and RTO are higher compared to FSLogix Cloud Cache mechanism.
  - It is not easy to test failover and failback in a production environment.
- ANF has some important limitations that need to be considered:
  - At the time of writing this document, it does not provide zone-resiliency, then Azure File Share should be the preferred option if resiliency requirement is more important than performances.
  - ANF is also not “zonal”, that is user cannot specify in which zone to deploy.
  - ANF cannot be used in conjunction to zone-redundant VPN and Express Route gateways, which are normally recommended from a networking resiliency perspective (see details [here](https://docs.microsoft.com/azure/azure-netapp-files/azure-netapp-files-network-topologies#supported-network-topologies)).
  - ANF cannot be used in conjunction to Azure Virtual WAN (see details [here](https://docs.microsoft.com/azure/azure-netapp-files/azure-netapp-files-network-topologies#supported-network-topologies)).
- ANF provides its own [cross-region replication mechanism](https://docs.microsoft.com/azure/azure-netapp-files/cross-region-replication-introduction), with the following limitations:
  - Not available in all regions.
  - Region pairs are fixed.
  - Failover is not transparent, and failback requires storage reconfiguration.
- Limits
  - There are limits in the size, IOPS, bandwidth MB/s for both Azure File Share and ANF storage accounts and volumes: if necessary, in AVD is possible to use more than one for the same Host Pool using [Per-Group settings](https://docs.microsoft.com/fslogix/configure-per-user-per-group-ht) in FSLogix but require additional planning and configuration.

The storage account used for MSIX application packages should be distinct from the other accounts used for Profile and Office containers. The following Geo-DR options are available, the latter is recommended:

- **One single storage account with GRS enabled, in the primary region**
  - Secondary region is fixed, then not suitable for local access in case of storage account failover (RA-GRS is not possible for Azure Files).
- **Two separate storage accounts, one in the primary region and one in the secondary region**
  - ZRS is recommended for at least the primary region, do not use GRS.
  - Each Host Pool in each region will have local storage access to MSIX packages with low latency.
  - MSIX packages must be copied twice in both locations and registered twice in both Host Pools. Users need to be assigned to the Application Groups twice. 

### FSLogix

The following FSLogix configuration and features are recommended:

- If Profile container content needs to have separate BCDR management and different requirements compared to Office container, it is recommended to split them (see details here):
  - Office Container is generally cached content only that can be rebuilt/re-populated from the sources in case of a disaster. If this is the case, customers can consider not protecting with backups to reduce costs.
  - Using different storage accounts, backup can be enabled only on the Profile Container, or have different settings (retention period, storage used, frequency, RTO/RPO).
- [Cloud Cache](https://docs.microsoft.com/fslogix/cloud-cache-resiliency-availability-cncpt) is a FSLogix component that allows you to specify multiple profile storage locations and asynchronously replicate profile data, without relying on underlying storage replication mechanisms. If the first storage location fails, or is not reachable, Cloud Cache will automatically failover to use the secondary, thus effectively adding a resiliency layer. Cloud Cache will be used to replicate both Profile and Office containers between different storage accounts in the primary and secondary regions.

:::image type="content" source="images/cloud-cache-general.png " alt-text="Picture representing high-level view of Cloud Cache.":::

- Cloud Cache must be enabled twice in the Session Host VM registry, once for [Profile Container](https://docs.microsoft.com/fslogix/configure-cloud-cache-tutorial#configuring-cloud-cache-for-profile-container) and once for [Office Container](https://docs.microsoft.com/fslogix/configure-cloud-cache-tutorial#configuring-cloud-cache-for-office-container). It is theoretically possible to not enable Cloud Cache for Office Container, but this may cause a data misalignment between the primary and the secondary DR region in case of failover and failback. This scenario should be carefully tested before being used in production. 
- Cloud Cache mechanism is compatible with both [profile split](https://docs.microsoft.com/fslogix/profile-container-office-container-cncpt) (Profile Container vs. Office Container) and [Per-Group](https://docs.microsoft.com/fslogix/configure-per-user-per-group-ht) settings. The latter requires careful design and planning of Active Directory Groups and membership: it must be ensured that every user will be part of exactly one Group and that Group used to grant access to Host Pools.
- Cloud Cache locations (*CCDLocations* parameter) specified in the registry for the Host Pool in the secondary DR region will be reverted in order, compared to the settings in the primary region (see [here](https://docs.microsoft.com/fslogix/configure-cloud-cache-tutorial) for additional details).

An example of the Cloud Cache configuration, and related registry keys, is reported below:

**Primary Region = North Europe**
- Profile container storage account URI = **\\northeustg1\profiles**
  - Registry Key path = **HKEY_LOCAL_MACHINE > SOFTWARE > FSLogix > Profiles**
  - *CCDLocations* value = **type=smb,connectionString=\\northeustg1\profiles;type=smb,connectionString=\\westeustg1\profiles**

:::image type="content" source="images/fslogix-cc-registry-keys.png " alt-text="Screenshot of Cloud Cache registry keys.":::

- Office container storage account URI = **\\northeustg2\odcf**
  - Registry Key path = **HKEY_LOCAL_MACHINE > SOFTWARE >Policy > FSLogix > ODFC**
  - *CCDLocations* value = **type=smb,connectionString=\\northeustg2\odfc;type=smb,connectionString=\\westeustg2\odfc**

:::image type="content" source="images/fslogix-cc-registry-keys-office.png " alt-text="Screenshot of Cloud Cache registry keys for Office Container.":::

> [!NOTE]
> In the print screens above, not all the recommended registry keys for FSLogix and Cloud Cache are reported for brevity and simplicity. Please follow [this](https://docs.microsoft.com/azure/architecture/example-scenario/wvd/windows-virtual-desktop-fslogix) article for complete details.

**Secondary Region = West Europe**

- Profile container storage account URI = **\\westeustg1\profiles**
  - Registry Key path = **HKEY_LOCAL_MACHINE > SOFTWARE > FSLogix > Profiles**
  - CCDLocations value = **type=smb,connectionString=\\westeustg1\profiles;type=smb,connectionString=\\northeustg1\profiles**
- Office container storage account URI = **\\westeustg2\odcf** 
  - Registry Key path = **HKEY_LOCAL_MACHINE > SOFTWARE >Policy > FSLogix > ODFC**
  - CCDLocations value = **type=smb,connectionString=\\westeustg2\odfc;type=smb,connectionString=\\northeustg2\odfc** 

### Cloud Cache Replication

The Cloud Cache configuration and replication mechanism suggested above will guarantee profile data replication between different regions with minimal data loss. Since the same (user profile) file can be opened in ReadWrite mode by only one process, concurrent access should be avoided, thus users should not open a connection to both Host Pools at the same time. 
In the diagram below what would happen is explained in detail:

:::image type="content" source="images/cloud-cache-replication-diagram.png" alt-text="High-level overview of Cloud Cache replication flow.":::

1. AVD user will launch AVD client and will open a published application (Desktop or Remote App) assigned on the primary region Host Pool.
2. FSLogix will retrieve the user Profile and Office containers and mount the underlying storage VHD/X from the storage account located in the primary region.
3. At the same time, Cloud Cache component will initialize replication between the files in the primary region and the files in the secondary region. To do this, Cloud Cache in the primary region will acquire an exclusive R/W lock on these files.
4. Now the same AVD user wants to launch an additional published application (Desktop or Remote App) assigned on the secondary region Host Pool.
5. The FSLogix component running on the AVD Session Host in the secondary region will try to mount the user profile VHD/X files from the local storage account but will fail since these files are locked by the Cloud Cache component running on AVD Session Host in the primary region.
6. In the default FSLogix and Cloud Cache configuration, the user will be not allowed to logon and an error will be tracked in FSLogix diagnostic logs (*ERROR_LOCK_VIOLATION 33 (0x21)*).

:::image type="content" source="images/fslogix-log.png" alt-text="Print screen of FSLogix diagnostic log.":::

### Identity

One of the most important dependencies that AVD needs to be always available is user identity. To access virtual desktops and remote apps from your session hosts, your users need to be able to authenticate. [Azure Active Directory](https://docs.microsoft.com/azure/active-directory/fundamentals/active-directory-whatis) (Azure AD or AAD) is Microsoft's centralized cloud identity service that enables this capability. Azure AD is always used to authenticate users for Azure Virtual Desktop. Session hosts can be joined to the same Azure AD tenant, or to an Active Directory domain using [Active Directory Domain Services](https://docs.microsoft.com/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview) (AD DS) or Azure Active Directory Domain Services (Azure AD DS), providing you with a choice of flexible configuration options.

- **Azure Active Directory**
  - It is a global multi-region and resilient service with 99,99% high-availability [SLA](https://azure.microsoft.com/support/legal/sla/active-directory/v1_1/), no additional action is required in this context as part of an AVD BCDR plan.
- **Active Directory Domain Services**
  - For AD DS to be resilient and highly available, even in case of a region wide disaster, it is recommended to deploy at least two Domain Controllers (DC) in the primary Azure region, in different Availability Zones (AZ) if available, and ensure proper replication with the infrastructure in the secondary region and eventually on-premises. At least one additional DC should be created in the secondary region with Global Catalog and DNS roles.
- **Azure Active Directory (AD) Connect**
  - If you are using Azure AD with AD DS and then [Azure AD Connect](https://docs.microsoft.com/azure/active-directory/hybrid/whatis-azure-ad-connect) to synchronize user identity data between AD DS and Azure AD, then resiliency and recovery of this service should be also considered in case of protection from a permanent disaster. 
  - High availability and disaster recovery can be provided installing a second instance of the service in the secondary region and enabling [Staging Mode](https://docs.microsoft.com/azure/active-directory/hybrid/plan-connect-topologies#staging-server) (hot-standby mode).
  - In case of recovery, the administrator will be required to promote the secondary instance taking it out of staging mode following the exact procedure as placing a server into staging mode.

:::image type="content" source="images/ad-connect-configuration-wizard.png" alt-text="Print screen of AD Connect configuration wizard.":::

- **Azure Active Directory Domain Services**
  - Can be used in some scenarios as an alternative to AD DS.
  - It offers 99,9% high-availability [SLA](https://azure.microsoft.com/support/legal/sla/active-directory-ds/v1_0/).
  - If geo disaster recovery is in scope for the specific customer scenario, it is highly recommended to deploy an additional replica in the secondary Azure region using [Replica Set](https://docs.microsoft.com/azure/active-directory-domain-services/tutorial-create-replica-set). This feature can be used also to increase high-availability in the primary region.

## Architecture Diagrams

### Personal Host Pool




## Next steps

- [Azure Virtual Desktop documentation](/azure/virtual-desktop/)
- [Deploy Azure AD-joined virtual machines in Azure Virtual Desktop](/azure/virtual-desktop/deploy-azure-ad-joined-vm)

## Related resources

- [Azure Virtual Desktop for the enterprise](windows-virtual-desktop.yml)
- [Integrate on-premises AD domains with Azure AD](../../reference-architectures/identity/azure-ad.yml)
