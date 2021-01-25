---
title: Overview of a hybrid environment
description: Includes guidance and recommendations that apply each of the five pillars in a hybrid and multi-cloud environment.
author: v-aangie
ms.date: 01/07/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
ms.custom:
---

# Overview of a hybrid environment

Customer environments are becoming increasingly complex, with many applications often running on different hardware across on-premises, multicloud, and the edge. Managing these disparate environments at scale, ensuring uncompromised security, and enabling developer agility are critical to success. 

Azure uniquely helps you meet these challenges, giving you the flexibility to innovate anywhere in your hybrid environment while operating seamlessly and securely. The Well-Architected Framework includes a hybrid description for each of the five pillars: cost optimization, operational excellence, performance efficiency, reliability, and security.

Adopting a hybrid model offers multiple solutions, enabling you to extend Azure management to any infrastructure, run Azure data services anywhere, and Modernize your datacenters in your hybrid environment.

## Extend Azure management to any infrastructure

Use *Azure Arc enabled infrastructure* to extend Azure management to any infrastructure in a hybrid environment. Key features of Azure Arc enabled infrastructure are:

- **Unified Operations** <!--CAF Overlap... Link off to https://review.docs.microsoft.com/en-us/azure/cloud-adoption-framework/scenarios/unified-operations/unified-operations?branch=pr-en-us-884 -->
   - Organize resources such as virtual machines, Kubernetes clusters and Azure services deployed across your entire IT environment.
   - Manage and govern resources with a single pane of glass from Azure.
   - Integrated with Azure Lighthouse for managed service provider support.

- **Adopt cloud practices**
   - Easily adopt DevOps techniques such as infrastructure as code.
   - Empower developers with self-service and choice of tools.
   - Standardize change control with configuration management systems, such as GitOps and DSC.

## Run Azure data services anywhere

Use *Azure Arc enabled data services* to run Azure data services anywhere in a hybrid environment. Key features of Azure Arc enabled data services are:

- Run Azure data services on any Kubernetes cluster deployed on any hardware.
- Gain cloud automation benefits, always up-to-date innovation in Azure data services, unified management of your on-premises and cloud data assets with a cloud billing model across both environments.
- Azure SQL Database and Azure PostgreSQL Hyperscale are the first set of Azure data services that are Azure Arc enabled.
 
## Modernize your datacenters

Use the *Azure Stack family* to modernize your datacenter in a hybrid environment. Key features of the Azure Stack family are:

- Extend Azure to your datacenter with Azure Stack Hub. Build and run cloud apps on premises, in connected or disconnected scenarios, to meet regulatory or technical requirements.
- Use Azure Stack HCI to run virtualized workloads on premises and easily connect to Azure to access cloud management and security services.
- Build and run your intelligent edge solutions on Azure Stack Edge, an Azure managed appliance to run machine learning models and compute at the edge to get results quickly—and close to where data is being generated. Easily transfer the full data set to Azure for further analysis or archive.
 
## Next steps

>[!div class="nextstepaction"]
>[Cost optimization](/azure/architecture/framework/hybrid/hybrid-cost)