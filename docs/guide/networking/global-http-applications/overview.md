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

Most modern applications rely on the HTTP and HTTPS protocols for application delivery. <!-- TODO more intro -->

Global applications frequently use Azure Front Door. Azure Front Door is a highly available service, with an industry-leading SLA. Further, teams throughout Microsoft rely on Front Door to accelerate the delivery of HTTP traffic in a secure and reliable manner to customers. However, like all cloud-based services, Azure Front Door is not immune to occasional outages. We spend a great deal of effort to avoid these issues, and to fix them and learn from them whenever they happen. For most customers, the reliability and resiliency built into the Front Door platform is more than enough to meet their business requirements. Nonetheless, a subset of customers might have mission-critical solutions that require them to minimize the risk and impact of downtime.

You can switch between Azure Front Door and other application delivery services during an outage or a disaster. However, these architectures need to be carefully considered. They introduce complexity, and bring significant costs and limitations. Further, they might inhibit your ability to use some important features of Azure Front Door.

In this article, we describe the factors that you need to consider when planning a mission-critical global HTTP application architecture with Azure Front Door.

## Understand your use of Azure Front Door

- Front Door has many features
- It's important to understand which features you use and rely on
- The exact set of features that you use might dictate the approach you follow

## Azure Front Door's resiliency

- AFD already is a highly available service and we continue to invest in ongoing improvements to 

## Automated failover architecture

> [!WARNING]
> Implementing a multi-CDN architecture can be complex and costly. Due to potential caveats that may arise with utilizing multiple CDNs, we suggest consulting with a Microsoft cloud solutions architect, FastTrack for Azure engineers, or site reliability engineering team to determine which choice is best for your needs. 

## Next steps

There are other industry solutions to achieve high availability with CDNs services, but we wanted to start by advising the most expedient and less complex solutions that are within Azure’s ecosystem. Nonetheless, please leverage your Microsoft Cloud Solutions Architects or Fast Track engineers to help you determine which solution is best for your organization.
