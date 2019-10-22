---
title: Modelling your cloud costs
description: Describes strategies to model your cloud costs
author: david-stanford
ms.date: 10/21/2019
ms.topic: article
ms.service: architecture-center
ms.subservice: cloud-design-principles
ms.custom: 
---

# Modelling your cloud costs

Mapping your organization's hierarchy to business units' cloud consumption needs is likely one of the first requirements for business leaders to understand the value of cloud. Most importantly, it allows business leaders to have a structured view on how cloud services are being governed and consumed. The cloud provider enables creating hierarchies and groupings (via management groups, subscriptions, resource groups, etc.) across the services you utilize. Mapping these logical groupings with your organizational structure will help define where cloud services are deployed and how they are governed.

## Treat resources as a utility

The cloud is all about change. Your resources in the cloud are virtual, and unless built for durability should be considered ephemeral. Your provider may reboot or replace your resources for troubleshooting or updates. Mapping resources as 1 to 1 drop in replacement for on-prem resources is not recommended. Understanding the utility nature of cloud services and your business service level requirements is critical to modelling your costs.

## Leverage reserved capacity

There are a number of Azure resources you can reserve as prepaid capacity for a period of time, generally one or three years, at a substantial discount off of the standard rate. Taking advantage of these reservation discounts requires understanding the resource requirements and usage patterns for your workloads to ensure you are reserving capacity at a scope and scale that provides the best value. Azure provides tools to help analyze resource usage and make recommendations for reservations.

## Low-priority VMs

Some workloads such as highly parallel Batch processing jobs can be run on low-priority VMs which take advantage of surplus capacity in Azure at a much lower cost. Development and testing of large-scale solutions, or supplementing baseline capacity are great uses for low-priority VMs.  

## Platform as a service

Azure provides a wide range of platform-as-a-service (PaaS) offerings such as Azure App Services, CosmosDB, and Service Bus. Leveraging these services can greatly reduce the time and cost of managing application infrastructure, and improve developer efficiency.

## Estimating & comparing costs

From real experience, it is not easy to estimate costs before migrating to the cloud. In many cases the initial calculation of cloud resource costs will be quite inaccurate if you rely on methods used for on-premises estimation. These methods may make cloud resources appear to be much more expensive than on-premises, or may show that cloud is cheaper but miss capturing some service costs in the calculation.

- Let us first look at the scenario when cloud estimates appear to be much more costly than on-premises. In most cases, if you build your own datacenter using best-practices your costs may appear comparable to cloud. However most estimates of on-premises resource costs fail to correctly account for factors such as cooling, electricity, IT and facilities labor costs, physical security, and disaster recovery. To be sure that your calculations accurately reflect all costs, we strongly suggest you check with the Total Cost of Ownership (TCO) Calculator for Azure (https://azure.microsoft.com/pricing/tco/calculator/)  

- As for the second pitfall it is easy to forget to add or choose the right storage type for the solution, or skip networking costs such as large data downloads. Smaller and cheaper VM sizes may be chosen which cannot provide the performance required for a workload.   

There are number of experts in the market within the Microsoft Partner eco-system who have real experience with complex projects. However even for them it can be difficult to accurately predict real cloud service costs for very large projects. It is a good practice to use proof-of-concept deployments to help refine cost estimates.

## Standardization

Ensure that your cloud environments are integrated into any IT-related operational processes, from the provisioning of users and their application access through to your business continuity & disaster recovery processes. This process mapping may uncover areas where additional cloud spend is needed, either to achieve the desired business outcomes or to adapt processes to take advantage of new cloud capabilities.

## Education

The cloud brings a new set of capabilities and tools for your organization's technical staff and business users. Identify training requirements & associated costs for technical staff to perform cloud migration projects and application development or re-architecture. Also include training initiatives to enable ongoing cloud management skills such as identity management, security configuration, systems monitoring and automation.

Ensure that staff have access to ongoing training and relevant announcements for the duration of your investment, as the pace of change in cloud means new capabilities and tooling updates are released continuously. Real experience of many customers across the globe shows that after attending specific cloud training and passing dedicated [Microsoft Exams](https://www.microsoft.com/learning/exam-list.aspx) (AZ, MS, MB etc,) costs decrease as increased knowledge leads to more optimal usage of the services.

Consider onboarding offerings that may be available for free for your organization to leverage, such as [FastTrack for Azure](https://azure.microsoft.com/programs/azure-fasttrack/partners/), to help speed up your adoption, build your confidence in the platform and set you up for success.

## Governance

You will need to think about how to implement cloud cost governance controls (Azure Policy, Resource Tags, Budgets), including the Enterprise Scaffold (more details and links to [docs](/azure/cost-management/tutorial-acm-create-budgets?toc=/azure/billing/TOC.json)