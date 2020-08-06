---
title: Windows Virtual Desktop at enterprise scale
titleSuffix: Azure Example Scenarios
description: Explore Windows Virtual Desktop, and learn to build virtual desktop infrastructure solutions at enterprise scale.
author: doodlemania2
ms.date: 07/16/2020
ms.topic: example-scenario
ms.service: architecture-center
ms.subservice: example-scenario
ms.custom:
- fcp
---
Azure Solutions Center – Microsoft FSLogix at enterprise scale
Purpose
Provide insights on how to proactively design, size and implement Microsoft FSLogix Profiles at larger Enterprise scale – to avoid performance problems in production. 
What is FSLogix? 
FSLogix is a set of solutions that enhance, enable, and simplify non-persistent Windows computing environments. FSLogix solutions are appropriate for Virtual environments in both public and private clouds. FSLogix solutions may also be used to create more portable computing sessions when using physical devices.
When to use which product? 

	•	When to use Profile Containers
	•	When to use Office Container
	•	When to use Profile and Office Container
	•	Cloud Cache for what scenario? 
	•	Should I use FSLogix Profiles for Pooled and/or Personal host pools? 
FSLogix filter-driver architecture
To the operating system, FSLogix Containers redirect user profiles to a network location. Profiles are placed in VHD(X) files and mounted at run time. It's common to copy a profile to and from the network, when a user signs in and out of a remote environment. Because user profiles can often be large, sign in and sign out times often became unacceptable. Mounting and using the profile on the network eliminates delays often associated with solutions that copy files.
See below how FSLogix operates to the operating system in a more architectural concept. The agent needs to be installed in the VDI image. After you are done that, two filter-drivers inject into the operating system. By setting various of registry (or ADMX) settings, you will be able to place a VHD(x) container on a file system/SMB share location.

Common settings for enterprises
The following settings are commonly used by our customers and seem to be very beneficial for their desktop virtualization use-case. 
	•	SizeInMBs
Type DWORD
Default Value 30000
Data values and use Specifies the size of newly created VHD(X) in number of MBs. Default of 30000 = 30 GB
	•	VolumeType
Type REG_SZ
Default Value "vhd"
Data values and use A value of "vhd" means that newly created files should be of type VHD. A value of "vhdx" means that newly created files should be of type VHDX.
	•	FlipFlopProfileDirectoryName
Type DWORD
Default Value 0
Data values and use
When set to '1' the SID folder is created as "%username%%sid%" instead of the default "%sid%%username%". This setting has the same effect as setting SIDDirNamePattern = "%username%%sid%" and SIDDirNameMatch = "%username%%sid%".
	•	DeleteLocalProfileWhenVHDShouldApply
Type DWORD
Default Value 0
Data values and use
0: no deletion. 1: delete local profile if exists and matches the profile being loaded from VHD.
NOTE: Use caution with this setting. When the FSLogix Profiles system determines a user should have a FSLogix profile, but a local profile exists, Profile Container permanently deletes the local profile. The user will then be signed in with an FSLogix profile.
Performance requirements
The (internal) rule of the thumb is that one user consumes an average of:
	•	Between 1,5 - 15 IOPs on average
	•	During the initial creation of the profile container and default profile copying process the IOPs are ~10 times more. 
	•	Between ~0.8 - 1.6 MBps  (depending on the type of workload)
	•	Between 5 GB – 30 GB of profile storage inside the VHD(x)
Storage options for FSLogix profile containers
Azure offers multiple storage solutions that you can use to store your FSLogix profile container. This article compares storage solutions that Azure offers for Windows Virtual Desktop FSLogix user profile containers. We recommend storing FSLogix profile containers on Azure Files for most of our customers.
The following article here compare the storage solutions Azure Storage offers for Windows Virtual Desktop FSLogix profile container user profiles.
Storage permissions
The following NTFS permissions are recommended to use. Users won’t be able to make any changes to other FSLogix Profile Container folders. 
General storage best practices
Some general best practices on FSLogix Profile Containers: 
	•	For optimal performance, the storage solution and the FSLogix profile container should be in the same data center location.
	•	Exclude the VHD(X) files for Profile Containers from Anti Virus (AV) scanning
	•	We recommend to use separate profile containers per host pool
Azure Files best practices
Some best practices on using Azure Files:
	•	Storage account name cannot be larger than 15 characters
	•	Azure Files storage account must be in the same region as the session host VMs.
	•	Azure Files permissions should match permissions described in Requirements - Profile Containers.
	•	The storage account containing the master image must be in the same region and subscription where the VMs are being provisioned.
You can leverage the guidance below and further optimize for your WVD scenario. Detailed information of Azure Files on performance targets (Standard, Premium) and pricing is available to help you further fine tune the file share solution.
	•	Workload type
	•	File Tiers
	•	Light
	•	Less than 200 concurrent active users: Standard file shares
	•	
	•	More than 200 concurrent active users: Premium file shares. You may also consider using Standard file shares with multiple shares if you are scaling up from existing Standard file shares or plan to manage scale out for cost efficiency. 
	•	Medium
	•	Premium file shares
	•	Heavy
	•	Premium file shares
	•	Power
	•	Premium file shares
Azure NetApp Files best practices
Some best practices on using Azure NetApp Files:
	•	IP connection limitation of 1000 connections per vNET. 
Antivirus exclusions
Make sure to configure the following Antivirus exclusions for FSLogix Profile Container.
	•	Exclude Files: 
	•	%ProgramFiles%\FSLogix\Apps\frxdrv.sys
	•	%ProgramFiles%\FSLogix\Apps\frxdrvvt.sys
	•	%ProgramFiles%\FSLogix\Apps\frxccd.sys
	•	%TEMP%\*.VHD
	•	%TEMP%\*.VHDX
	•	%Windir%\TEMP\*.VHD
	•	%Windir%\TEMP\*.VHDX
	•	\\server\share\*\*.VHD
	•	\\server\share\*\*.VHDX
	•	Exclude Processes
	•	%ProgramFiles%\FSLogix\Apps\frxccd.exe
	•	%ProgramFiles%\FSLogix\Apps\frxccds.exe
	•	%ProgramFiles%\FSLogix\Apps\frxsvc.exe
Disaster recovery
Replication options for FSLogix and Cloud Cache – when to use what? 
https://docs.microsoft.com/en-us/azure/storage/common/storage-disaster-recovery-guidance
Backup and restore
Maintenance
