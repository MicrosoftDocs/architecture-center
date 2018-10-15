---
title: "Enterprise Cloud Adoption: Operate"
description: A process within Cloud Migration that focuses on operating assets moved to the cloud
author: BrianBlanchard
ms.date: 10/11/2018
---

# Enterprise Cloud Adoption: Process Overview for operating cloud assets

Cloud migration significantly impacts the daily operations of an IT department, broadening the scope of IT operations as organizations move to the cloud. Cloud adoption creates new management challenges for IT teams. Instead of utilizing disjointed solutions for individual IT operations, organizations may want to take advantage of cloud-scale infrastructure to simplify deployment through unified IT management as a service. Management capabilities such as monitoring, backup, automation, and so forth are delivered as a service from the cloud that connects all of the servers in all environments (on-premises, Azure, and other clouds), allowing IT staff to centrally manage operations.

The following table outlines tasks to be covered in this section of the Migration guide:

|Function  |On-premises function  |Cloud function  |
|---------|---------|---------|
|Health monitoring     |Use various tools to monitor applications and provide Root Cause Analysis (RCA) of failures         |Gain visibility into the health and performance of  apps, infrastructure, and data in Azure with cloud monitoring tools such as Azure Monitor, Log Analytics, and Application Insights         |
|Security operations (SecOps)     |Use Security Information and Event Management (SIEM) tools to analyze events; ensure event logs are audited regularly         |Use products like Azure Security Center to prevent, detect, and respond to threats         |
|Data backup     |Use on-premises tools to create disk- or tape-based data backups         |Protect business data with Azure backup and take advantage of automatic storage management, unlimited scaling, data encryption, application consistent backup and many more capabilities         |
|Scalability     |Acquire equipment, Add and provision additional hardware instances (servers) in the datacenter; ensure proper operation and network connectivity         |Configure scale up/out options to automatically respond to spikes by enabling scale, reliability, and resiliency         |
|Business continuity/disaster recovery     |Use custom scripts to failover to alternate datacenters         |Turn on tools such as Azure Site Recovery to perform script-driven orderly failover and recovery of applications and storage         |
|Network configuration and optimization     |Use various tools and manual efforts to analyze and optimize network performance         |Ensure hybrid network connections such as V-Nets and MPLS routers (“ExpressRoute”) are appropriately tuned and load balanced         |
|Identity provisioning and De-provisioning     |Maintain user directory, for example, Active Directory; ensure appropriate user access to resources; enable/enforce single sign-on (SSO)         |Extend directory to cloud and possibly utilize alternate forms of authentication for specific applications and resources         |

This list is neither exhaustive nor conclusive; rather, it is illustrative of the types of issues an operations staff will want to address.