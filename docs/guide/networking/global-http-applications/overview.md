---
title: Mission-critical global HTTP applications
titleSuffix: Azure Architecture Center
description: Learn how to develop highly resilient global HTTP applications.
author: johndowns
ms.author: jodowns
ms.date: 02/15/2023
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure
categories:
  - management-and-governance
ms.category:
  - fcp
ms.custom:
  - checklist
  - guide
---

# Mission-critical global HTTP applications

Azure Front Door is a highly available service, with an industry-leading 99.99% uptime SLA. Further, teams throughout Microsoft rely on Front Door to accelerate the delivery of HTTP/S traffic in a secure and reliable manner to customers. However, like all cloud-based services, Front Door is not immune to occasional outages. We spend a great deal of effort to avoid these issues, and to fix them and learn from them whenever they happen. For most customers, the reliability and resiliency built into the Front Door platform is more than enough to meet their business requirements. Nonetheless, a subset of customers might have mission-critical solutions that require them to minimize the risk and impact of downtime. These customers can consider using approaches to switch between Front Door and other application delivery services during an outage and/or disaster. However, these options come with significant costs and limitations, and they might inhibit your ability to use some important Front Door features with third party providers.

> [!WARNING]
> Implementing a multi-CDN architecture can be complex and costly. Due to potential caveats that may arise with utilizing multiple CDNs, we suggest consulting with a Microsoft cloud solutions architect, FastTrack for Azure engineers, or site reliability engineering team to determine which choice is best for your needs. 

## Next steps

There are other industry solutions to achieve high availability with CDNs services, but we wanted to start by advising the most expedient and less complex solutions that are within Azure’s ecosystem. Nonetheless, please leverage your Microsoft Cloud Solutions Architects or Fast Track engineers to help you determine which solution is best for your organization.
