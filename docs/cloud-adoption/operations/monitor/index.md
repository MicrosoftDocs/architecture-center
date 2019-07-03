---
title: Cloud monitoring guide
titleSuffix: Microsoft Cloud Adoption Framework for Azure
description: Overview of Azure Monitor and System Center Operations Manager
services: azure-monitor
keywords: 
author: mgoedtel
ms.author: magoedte
ms.date: 06/26/2019
ms.service: architecture-center
ms.subservice: enterprise-cloud-adoption
---

# Cloud monitoring guide: Introduction

The cloud presents a fundamental shift in the way that enterprises procure and use technology resources. In the past, enterprises assumed ownership and responsibility of all levels of technology from infrastructure to software. Now, the cloud offers the potential to transform the way enterprises use technology by provisioning and consuming resources as needed.

While the cloud offers nearly unlimited flexibility in terms of design choices, enterprises seek proven and consistent methodology for the adoption of cloud technologies.  Each enterprise has different goals and timelines for cloud adoption, making a one-size-fits-all approach to adoption nearly impossible.

![Cloud adoption strategies](./media/monitoring-management-guidance-cloud-and-on-premises/introduction-cloud-adoption.png)

This digital transformation is also enabling an opportunity to modernize your infrastructure, workloads, and applications. Depending on business strategy and objectives, adopting a hybrid cloud model is likely part of the migration journey from on-premises to fully operating in the cloud. During this transformative journey, IT teams are challenged to not only adopt and realize rapid value from the cloud, but also understand how to effectively monitor the application or service migrating to Azure and continue delivering effective IT operations/DevOps.  

Interest is increasing with stakeholders to leverage cloud-based SaaS monitoring and management tools and therefore, understand what our services and solutions deliver in order to achieve end-to-end visibility, reduce costs, and focus less on infrastructure and maintenance of traditional software-based IT operations tools.  

However, IT would prefer to continue leveraging the tools they have made significant investment in to support their service operations processes to monitor both, with the eventual goal of transitioning to a SaaS based offering.  This choice is not only because it takes time planning, resources, and funding to switch.  It is also due to confusion when trying to understand our strategy and which products or Azure services are appropriate or applicable to achieve desired state.  

The goal of this guide is to provide a detailed reference to help enterprise information technology (IT) managers, business decision makers, application architects, and application developers understand:

* Our monitoring platforms with an overview and comparison of their capabilities
* Which is the best-fit solution for monitoring hybrid, private, and Azure native workloads
* Recommended monitoring approach for both infrastructure and applications as a whole from end-to-end, including deployable solutions for these common workloads migrating to Azure

This guide is not a how-to guide for using or configuring individual Azure services and solutions, but this guide will reference those sources when applicable or available.  After reading this guide, you will understand how to successfully operate a workload following recommended practices and patterns.  

It is important to note that while the first version of this document is focused on key fundamentals about monitoring a cloud solution, we intend to revise it frequently. We will expand its scope to include prescribed monitoring of the resources and dependencies supporting them. Future iterations will align with the Azure Architecture Center’s reference architectures for common workloads.  We will start with an Azure VM workload and expand to include microservices, basic to highly available web applications, and other scenarios.  As new features or enhancements are introduced with our services and solutions, this guide will adapt and evolve to incorporate those changes.  

## Audience

The audience for the Cloud Monitoring Guide includes enterprise administrators, IT operations, IT security and compliance, application architects, workload development owners, and workload operations owners.

## How this guide is structured

This article is part of a series that are meant to be read together and in order.

* Introduction (this article)
* [Overview of the Azure monitoring platform](./platform-overview.md)
* [Monitoring Azure cloud applications](./cloud-app-howto.md)
* [Collecting the right data](./data-collection.md)
* [Alerting](./alert.md)

## Products and services

A selection of software and services are available to monitor and manage a variety of resources hosted in Azure, your corporate network, or other cloud providers.  They are:

* System Center Operations Manager
* Azure Monitor, which now includes Log Analytics and Application Insights.
* Azure Blueprints and Policy
* Azure Automation
* Azure Logic Apps
* Azure Event Hubs

A large part of this guide discusses and contrasts Azure Monitor to System Center Operations Manager.

## Next steps

> [!div class="nextstepaction"]
> [Overview of the Azure monitoring platform](./platform-overview.md)
