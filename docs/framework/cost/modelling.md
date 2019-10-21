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

Mapping your organization's hierarchy with each business units' cloud consumption needs is likely one of the first requirements that business leaders care about on their journey of understanding the value of cloud. Most importantly, it allows business leaders to have a structured view on how cloud services are being governed and consumed. The cloud provider often provides different options to build hierarchy and grouping (via management groups, subscriptions, resource groups, etc.) across the cloud services it provides. Being able to map these logical containers with your organization's hierarchy will yield a clear path towards defining where cloud services are deployed and how they are governed.

## Treat resources as a utility

The cloud is all about change. Your resources in the cloud are virtual, and unless built for durability, are to be considered ephemeral. Your provider may reboot or replace your resources for troubleshooting or updates. Mapping resources as 1 to 1 drop in replacement for on-prem resources is not recommended.

## Leverage reserved capacity

## Low-priority VMs

## Platform as a service

## Estimating & comparing costs

From the real experience, it is not easy to estimate cloud cost at the initial step of migration to the cloud. In many cases first calculation of cloud resources is quite inaccurate and relays more on more familiar and common on-prem approach. Two main pitfalls of the initial calculation are: either cloud is much more expensive comparing to on-prem or it is cheaper but some services are missed from the calculation:

- Let us first take a look at the situation when cloud calculation is shocking you comparing to on-prem calculation, being much more costly – in most cases, if you build you on-prem DC using best-practices and guidance, on-prem DC cost would be close to cloud. But you have to be aware that you haven't missed in your on-prem calculation important parts of the solution such: cooling, electricity, IT labor cost, maintain security and disaster recovery etc. In order to be sure that your on-prem calculation contain all important part – we strongly suggest you to check with Total Cost of Ownership (TCO) Calculator for Azure (https://azure.microsoft.com/en-us/pricing/tco/calculator/)

- As for the second pitfall – it is easy to forget to add or choose the right storage type for the solution, or skip networking cost (especially downloading big amount of data – which is chargeable). Or simply – choose the cheaper and smaller VMs which simply cannot provide expected performance for the solution.

Of course, there are number of the real experts on the market within Microsoft Partners eco-system who have real experience with real complex projects. But sometimes in very big and complex project even for them difficult accurately calculate the real cloud services cost. Good thing here is that even the real cost is hardly estimated at the very first theoretical level - first POC (proof of concept) brings a lot of texture and helps to produce more accurate calculation.

## Standardization

Ensure that your Cloud environments are integrated into any IT-related operational processes, from the provisioning of users and their application access through to your business continuity & disaster recovery processes. This process mapping may uncover areas where additional Cloud spend is needed, to facilitate the desired business outcomes in a timely manner or highlight where existing processes can be changes to take advantage of new cloud capabilities and tooling.

## Education

The Cloud brings a new set of technical capabilities and tools for your organization's technical staff, as well as your business users. Identify training requirements & associated costs for technical staff to perform Cloud migration projects and Cloud application development or re-architecture. Also include training initiatives to enable ongoing Cloud management (such as identity management, security configuration and response and systems monitoring and automation) or consider outsourcing alternatives.

Ensure that staff have access to ongoing training and relevant Cloud announcements for the duration of your Cloud investment, as the pace of Cloud will see tooling updates and new capabilities released continuously. Real experience of many customers across the globe shows that after attending specific cloud training and passing dedicated [Microsoft Exams](https://www.microsoft.com/en-us/learning/exam-list.aspx) (AZ, MS, MB etc,) the cost starts to goes down because of more optimal usage of the services based on the received knowledge.

Consider onboarding offerings that may be available for free for your organization to leverage, such as [FastTrack for Azure](https://azure.microsoft.com/en-us/programs/azure-fasttrack/partners/), to help speed up your adoption, build your confidence in the platform and set you up for success.

## Governance

You will need to think about how to implement cloud cost governance controls (Azure Policy, Resource Tags, Budgets), including the Enterprise Scaffold (more details and links to docs) https://docs.microsoft.com/en-us/azure/cost-management/tutorial-acm-create-budgets?toc=/azure/billing/TOC.json