---
title: Windows Virtual Desktop at enterprise scale
titleSuffix: Azure Example Scenarios
description: Explore Windows Virtual Desktop, and learn to build virtual desktop infrastructure solutions at enterprise scale.
author: GitHubAlias
ms.date: 07/16/2020
ms.topic: example-scenario
ms.service: architecture-center
ms.subservice: example-scenario
ms.custom:
- fcp
---

# Use Microsoft FSLogix at enterprise scale

This article provides insights on how to proactively design, size, and implement Microsoft FSLogix Profiles at large enterprise scale and shows how to avoid performance problems in production. This document is an extension of the [Windows Virtual Desktop at enterprise scale](./windows-virtual-desktop.md) article.

[FSLogix](https://docs.microsoft.com/fslogix/) is a set of solutions that enhance, enable, and simplify non-persistent Windows computing environments. FSLogix solutions are appropriate for Virtual environments in both public and private clouds. FSLogix solutions may also be used to create more portable computing sessions when using physical devices.

Combining FSLogix with Windows Virtual Desktop as desktop virtualization solution on Azure we recommend to store your profiles on either [Azure Files or Azure NetApp Files](https://docs.microsoft.com/en-us/azure/virtual-desktop/store-fslogix-profile) to leverage another Azure platform service that requires zero infrastructure – all to simplify management of your storage environment. 

## FSLogix filter-driver architecture

It's common to copy a profile to and from the network, when a user signs in and out of a remote environment. Because user profiles can often be large, sign in and sign out times often became unacceptable. To the operating system, FSLogix Containers redirect user profiles to a network location. Profiles are placed in VHDx files and mounted at run time. Mounting and using the profile on the network eliminates delays often associated with solutions that copy files.

The conceptual architecture diagram below shows how FSLogix works within the operating system. The agent needs to be installed in the VDI image. After you are done that, two filter-drivers inject into the operating system. By setting various registry (or ADMX) entries, you will be able to place a VHDx container on a file system/SMB share location.

<!---
Add the png here.
!--->

## When to use Profile Container and Office Container

FSLogix [Profile Container](https://docs.microsoft.com/en-us/fslogix/configure-profile-container-tutorial) and [Office Container](https://docs.microsoft.com/en-us/fslogix/configure-office-container-tutorial) are the Microsoft recommended and supported tools for 'roaming' user profiles in Windows Virtual Desktop.

The Office Container is a subset of Profile Container. Although all of the benefits of Office Container are also delivered from in a Profile Container, there are times when it may be beneficial to use them together. It's important to completely understand the configuration process, especially when using them together. 

Profile Container is used to redirect the full user profile. Profile Container is used in non-persistent, virtual environments, such as Virtual Desktops. When using Profile Container the entire user profile, except for data that is [excluded](https://docs.microsoft.com/en-us/fslogix/manage-profile-content-cncpt).

There are several reasons why Profile Container and Office Container may be used together. You can find them [here](https://docs.microsoft.com/en-us/fslogix/profile-container-office-container-cncpt) if you are interested in using them together. 

> [!NOTE]
> The recommendation in Windows Virtual Desktop is to always use Profile Container without Office Container as this is the most simple, and therefore the most robust solution.

## Multiple Profile Connections

[Concurrent or multiple connections](https://docs.microsoft.com/fslogix/configure-concurrent-multiple-connections-ht) refers to a user connection to multiple sessions, in multiple hosts, or the same hosts, concurrently, using the same profile.  This should not be confused with the term multi-session, which refers to an operating system which supports multiple users to connect simultaneously.

> [!NOTE]
> Concurrent or multiple connections are always discouraged in Windows Virtual Desktop. Best practice is to create a different profile location for each session (host pool).

Be aware of the following limitations if you decide to move forward with a multiple-connection deployment.

- OneDrive does not support multiple connection environments using any profile-roaming technology. 
- Using OneDrive with multiple profile connections configured could also cause data loss. 
- Outlook has limited support.
- End users MUST be educated as to what to expect, as using [read only containers](https://docs.microsoft.com/fslogix/configure-concurrent-multiple-connections-ht#concurrent-connections-with-profile-container-and-office-container) result in a unique experience that a user, without proper context, may experience as data loss.

### Performance requirements

In terms of overall profile size, limitations or quotas for FSLogix depend on the storage fabric used to store user profile VHDx files, and size limitations of the VHD/VHDx format.
The following table gives an example of how any resources an FSLogix profile needs to support each user. Requirements can vary widely depending on the user, applications, and activity on each profile, so you should expect that your actual usage may vary significantly from what is listed here.
The example in this table is of a single user, but can be used to estimate requirements for the total number of users in your environment. For example, you'd need around 1,000 IOPS for 100 users, and around 5,000 IOPS during sign-in and sign-out, if a large number of users login during a short period of time creating a 'login storm'.

|Resource              |Requirement|
|----------------------|-----------|
|Steady state IOPS     |data       |
|Sign in/sign out IOPS |50         |

## Storage options for FSLogix profile containers

Azure offers multiple storage solutions that you can use to store your FSLogix profile container. This article compares storage solutions that Azure offers for Windows Virtual Desktop FSLogix user profile containers. We recommend storing FSLogix profile containers on Azure Files or Azure NetApp Files for most of our customers.

[Storage spaces direct (S2D)](https://docs.microsoft.com/en-us/windows-server/remote/remote-desktop-services/rds-storage-spaces-direct-deployment) is supported in this scenario as well, hence it's an self-managed storage solution which we are not covering in this article. We think that customer can get most value out of either Azure Files or Azure NetApp Files while simplifying management of Windows Virtual Desktop. 
The following article [here](https://docs.microsoft.com/en-us/azure/virtual-desktop/store-fslogix-profile) compares the different managed-storage solutions Azure Storage offers in more detail for Windows Virtual Desktop FSLogix profile container user profiles.

## Best practices

### General storage

Some general best practices on FSLogix Profile Containers. 

- For optimal performance, the storage solution and the FSLogix profile container should be in the same data center location.
- Exclude the VHD(X) files for Profile Containers from Anti Virus (AV) scanning.
- We recommend to use separate profile containers per host pool.

### Azure Files

A couple of important things to keep in mind on using Azure Files.

- Storage account name cannot be larger than 15 characters
- Azure Files storage account must be in the same region as the session host VMs.
- Azure Files permissions should match permissions described in Requirements - Profile Containers.
- The storage account containing the master image must be in the same region and subscription where the VMs are being provisioned.
- Private link for Azure storage could be used to improve the network latency from your session hosts to your storage account. This is also beneficial in hybrid scenarios with ExpressRoute connectivity. 
- You can pre-provision space to your Azure Files Premium share to accommodate more IOPs for your users proactively. This leaves you in a position to use more IOPs during the first initial logon of users. 
- There's as well a built-in bursting mechanism that gives you 3 times more the amount of IOPs for the first 60 minutes of a session for Premium Azure Files only. 
Azure Files sync can be used to replicate existing Profile Containers into Azure Files easily. 
- With the FSLogix [ObjectSpecific](https://docs.microsoft.com/en-us/fslogix/configure-per-user-per-group-ht) – per group setting, you can filter different Azure Files storage accounts to accommodate more users. The maximum limit of IOPs per storage account doesn't mean you cannot stack them. This applies to both personal and pooled host pool scenarios. The architecture drawing below explains it in more detail. 
- You are able to use multiple storage accounts in one Azure vNET. It's possible to e.g. assign via AD groups different network shares to specific groups of users in your environment. 

<!--
Insert png here
-->

You can leverage the guidance below and further optimize for your WVD scenario. Detailed information of Azure Files on performance targets ([Standard](https://docs.microsoft.com/en-us/azure/storage/files/storage-files-scale-targets#file-share-and-file-scale-targets), [Premium](https://docs.microsoft.com/en-us/azure/storage/files/storage-files-planning#understanding-provisioning-for-premium-file-shares)) and [pricing](https://azure.microsoft.com/en-us/pricing/details/storage/files/) is available to help you further fine tune the file share solution.

|Workload  |Examples                     |Recommended tier                |
|----------|-----------------------------|--------------------------------|
|Light     |Data entry                   |Less than 200 concurrent active users: Standard </br>More than 200 concurrent active users: Premium |
|Medium    |Casual users, LoB apps       |Premium file shares             |
|Heavy     |Software engineers, content creation|Premium file shares             |
|Power     |CAD, 3D, machine learning    |Premium file shares             |

### Azure NetApp Files

Azure NetApp Files has been proven to be a great managed storage solution for FSLogix Profiles and Windows Virtual Desktop. The low latency and the high amount of IOPs is a great mixture for enterprises at scale. 
Currently, there's an IP connection limitation of 1000 IP connections per vNET active, this applies per virtual machine and not per session. Please read the guidance below to proactively design your environment, or use [this](https://docs.microsoft.com/en-us/azure/azure-netapp-files/solutions-windows-virtual-desktop) article for more information.

#### Pooled scenarios

If the WVD Windows 10 Multi-session user per vCPU [recommendations](https://docs.microsoft.com/en-us/windows-server/remote/remote-desktop-services/virtual-machine-recs) holds true for the D32as_v4 VM size, more than 120,000 users would fit within 1,000 virtual machines before broaching the 1,000 IP limit, as shown in the following figure.

<!--
Third picture
-->

#### Personal scenarios

users are mapped to specific desktop pods and each pod has just under 1,000 virtual machines, leaving room for IP addresses propagating from the management VNET. Azure NetApp Files can easily handle 900+ personal desktops per single-session host pool, the actual number of virtual machines being equal to 1,000 minus the number of management hosts found in the Hub VNET.

<!--
Fourth picture
-->

## Storage permissions

The following NTFS permissions are recommended to use. For correct and secure use, user permissions must be created to allow permissions to create and use a profile, while not allowing access to other users profiles. The Profile Container storage permissions can also be found [here](https://docs.microsoft.com/en-us/fslogix/fslogix-storage-config-ht).

|User Account   |Folder   |Permissions  |
|------|-----|-------|
|Users      |This Folder Only  |Modify  |
|Creator/Owner  |Subfolders and Files Only  |Modify   |
|Administrator (optional) |This Folder, Subfolders, and Files |Full Control |

## Storage exclusions

We recommend to keep native profile folder locations in the FSLogix profile container. However, it could be beneficial in some scenarios to exclude folders to be more efficient with e.g. temp or caching data. Below are common FSLogix exclusions. 

### Teams exclusions

Using Teams with a non-persistent setup also requires a profile caching manager for efficient Teams runtime data sync. This ensures that the appropriate user-specific information (for example, user data, profile, and settings) is cached during the user session. Make sure data in these two folders are synced:

- C:\Users\username\AppData\Local\Microsoft\IdentityCache (%localAppdata%\Microsoft\IdentityCache)
- C:\Users\username\AppData\Roaming\Microsoft\Teams (%appdata%\Microsoft\Teams)
 
## Antivirus exclusions

Make sure to configure the following Antivirus exclusions for FSLogix Profile Container – virtual hard drives. Make sure to pass the following information against your security team. 

### Exclude files

- ProgramFiles%\FSLogix\Apps\frxdrv.sys
- %ProgramFiles%\FSLogix\Apps\frxdrvvt.sys
- %ProgramFiles%\FSLogix\Apps\frxccd.sys
- %TEMP%\*.VHD
- %TEMP%\*.VHDX
- %Windir%\TEMP\*.VHD
- %Windir%\TEMP\*.VHDX
- \\storageaccount.file.core.windows.net\share\*\*.VHD
- \\storageaccount.file.core.windows.net\share\*\*.VHDX

### Exclude Processes

- %ProgramFiles%\FSLogix\Apps\frxccd.exe
- %ProgramFiles%\FSLogix\Apps\frxccds.exe
- %ProgramFiles%\FSLogix\Apps\frxsvc.exe

## Best practice settings for enterprises - cheatsheet

The following settings are commonly used by our customers and seem to be very beneficial for their desktop virtualization use-case.

|Setting    |Value    |Reason    |
|-----------|---------|----------|
|DeleteLocalProfileWhenVHDShouldApply |1    |This setting avoids errors while logon in with an existing local profile. It removes the profile first if any already exists.    |
|SizeInMBs    |3000    |Specifies the size of newly created VHD(X) in number of MBs. Default of 30000 = 30 GB   |
|VolumeType   |VHDx    |More capabilities for PowerShell and maintenance    | 
|FlipFlopProfileDirectoryName |1    |Makes it easier to search for the specific profile container -user folder on the network share.    |

## Using Cloud Cache

Cloud Cache in an addon to FSLogix uses a local cache to service all reads from a redirected Profile or Office Container, after the first read. Cloud Cache also allows the use of multiple remote locations, which are all continually updated during the user session, creating true real-time profile replication. Using Cloud Cache can insulate users from short-term loss of connectivity to remote profile containers as the local cache is able to service many profile operations. In case of a provider failure, Cloud Cache  provides business continuity 

Because the Local Cache file will service most IO requests, the performance of the Local Cache file will define the user experience. It is critical that the storage used for the Local Cache file be high-performing and highly available. It is also suggested that any storage used for the local cache file be physically attached storage, or have reliability and performance characteristics that meet or exceed high-performing physically attached storage.

Cloud Cache is only one of many options that may be considered for busines continuity when using Profile Containers.  Cloud Cache provides real-time duplication of the user profile, that will actively fail-over if connectivity to a Cloud Cache provider is lost.  There are a number of considerations when implementing Cloud Cache.

- Cloud Cache provides real-time profile high availability
- Cloud Cache can insulate users from short-term connectivity issues to remote Cloud Cache providers by servicing read/writes from local cache
- Cloud Cache enables the use of Azure Page Blob storage via REST API
- Cloud Cache can be an effective profile tool when configuring multi-geo environments
- Cloud Cache requires significant performant and highly available host-attached storage (or equivalent) to support local cache
- Cloud Cache is executed on the host, utilizing processor, memory, network and storage resources
- When used as a solution for High Availability, Cloud Cache requires multiple, full copies of the user profile, in addition to the local cache file

Because of the resource utilization, it may be more cost effective to consider alternate backup/disaster recovery solutions for FSLogix profile containers.  Cloud Cache is generally utilized when one of the Cloud Cache features provides unique value, such as real-time profile high availability.  If an environment can be adequately services with an alternate form of backup, it is often more economical than Cloud Cache.

## Disaster recovery

Large multi-national Windows Virtual Desktop deployments could require availability of the users profile across different regions. Therefore it's important to have the same profile available in the Azure region of the host pool. 

1. Azure Files offers the option to do storage account failover against the other region as replication mechanism. This is only supported for the standard storage account type using GRS (Geo-Redundent Storage). 
Other options to use are AzCopy or any other file copy mechanism such as RoboCopy. 
1. Azure NetApp Files offers cross-region replication, with this feature you are able to replicate your FSLogix file share to another region over the Azure backbone.

## Backup and restore

Making regular backups of your Windows profiles could be beneficial in different situations. Scenario's when the users accidentally removes data and wants to restore, profile corruption and data corruption due to malware infections could be an indicator to have your data safely stored on Azure. 

Azure Files Premium integrates with Azure Backup and is supported. Azure NetApp Files offers a similar snapshot mechanism to make copies of your FSLogix Profile Containers. 

## Maintenance

As explained earlier in this article, FSLogix Profile Containers works with virtual disks. The virtual hard disks are in the VHD or VHDx file (both are supported with this tool) format. By default, the disks created will be in Dynamically Expanding format rather than Fixed format. This could result in situations where you size of the disk is higher than the actual files that are inside the virtual disk. Therefore it's common to do maintenance on shrinking the virtual hard disks on e.g. monthly basis, which can be possible via a script that has been created to decrease the amount of your profiles.

This script is designed to work at Enterprise scale to reduce the size of thousands of disks in the shortest time possible. This script can be run from any machine in your environment it does not need to be run from a file server hosting the disks. It does not need the Hyper-V role installed.

This tool is multi-threaded and will take advantage of multiple CPU cores on the machine from which you run the script. It is not advised to run more than 2x the threads of your available cores on your machine. You could also use the number of threads to throttle the load on your storage.

Download the tool [here](https://github.com/FSLogix/Invoke-FslShrinkDisk).

> [!NOTE]
> This script is not supported by the Microsoft product group. It's community driven. This script does not support reducing the size of a Fixed file format.

## Next steps

TBD
