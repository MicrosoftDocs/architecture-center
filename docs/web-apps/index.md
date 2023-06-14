---
title: Web architecture design
description: Get an overview of Azure web app technologies, guidance, solution ideas, and reference architectures.
author: martinekuan
ms.author: architectures
ms.date: 07/25/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure-app-service
  - azure-web-application-firewall
  - azure-monitor
  - azure-webapp-containers
  - azure-signalr-service
categories:
  - web
ms.custom: fcp
---

# Web applications architecture design

Today's web apps are expected to be available all day, every day from anywhere in the world, and usable from virtually any device or screen size. Web applications must be secure, flexible, and scalable to meet spikes in demand.

This article provides an overview of Azure web app technologies, guidance, solution ideas, and reference architectures.

Azure provides a wide range of tools and capabilities for creating, hosting, and monitoring web apps. These are just some of the key web app services available in Azure:

- [Azure App Service](https://azure.microsoft.com/services/app-service) enables you to easily create enterprise-ready web and mobile apps for any platform or device and deploy them on a scalable cloud infrastructure.
- [Azure Web Application Firewall](https://azure.microsoft.com/services/web-application-firewall) provides powerful protection for web apps.
- [Azure Monitor](https://azure.microsoft.com/services/monitor) provides full observability into your applications, infrastructure, and network. Monitor includes [Application Insights](/azure/azure-monitor/app/app-insights-overview), which provides application performance management and monitoring for live web apps.
- [Azure SignalR Service](https://azure.microsoft.com/services/signalr-service) enables you to easily add real-time web functionalities.
- [Static Web Apps](https://azure.microsoft.com/services/app-service/static) provides streamlined full-stack development, from source code to global high availability.
- [Web App for Containers](https://azure.microsoft.com/services/app-service/containers) enables you to run containerized web apps on Windows and Linux.

## Introduction to web apps on Azure

If you're new to creating and hosting web apps on Azure, the best way to learn more is with [Microsoft Learn training](/training/?WT.mc_id=learnaka). This free online platform provides interactive training for Microsoft products and more.

These are a few good starting points to consider:

- [Create Azure App Service web apps](/training/paths/create-azure-app-service-web-apps)
- [Deploy and run a containerized web app with Azure App Service](/training/modules/deploy-run-container-app-service)
- [Azure Static Web Apps](/training/paths/azure-static-web-apps)

## Path to production

Consider these patterns, guidelines, and architectures as you plan and implement your deployment:

- [Basic web application](../../reference-architectures/app-service-web-app/basic-web-app.yml)
- [Common web application architectures](/dotnet/architecture/modern-web-apps-azure/common-web-application-architectures)
- [Design principles for Azure applications](../../guide/design-principles/index.md)
- [Design and implementation patterns - Cloud Design Patterns](../../patterns/category/design-implementation.md)
- [Enterprise deployment using App Services Environment](../../reference-architectures/enterprise-integration/ase-standard-deployment.yml)
- [High availability enterprise deployment using App Services Environment](../../reference-architectures/enterprise-integration/ase-high-availability-deployment.yml)

## Best practices

For a good overview, see [Characteristics of modern web applications](/dotnet/architecture/modern-web-apps-azure/modern-web-applications-characteristics).

For information specific to Azure App Service, see:

- [Azure App Service and operational excellence](/azure/architecture/framework/services/compute/azure-app-service/operational-excellence)  
- [App Service deployment best practices](/azure/app-service/deploy-best-practices)
- [Security recommendations for App Service](/azure/app-service/security-recommendations)
- [Azure security baseline for App Service](/security/benchmark/azure/baselines/app-service-security-baseline)

## Web app architectures

The following sections, organized by category, provide links to sample web app architectures.

### E-commerce

- [E-commerce front end](../../example-scenario/apps/ecommerce-scenario.yml)
- [Intelligent product search engine for e-commerce](../../example-scenario/apps/ecommerce-search.yml)
- [Scalable order processing](../../example-scenario/data/ecommerce-order-processing.yml)
- [E-commerce website running in secured App Service Environment](../../web-apps/idea/ecommerce-website-running-in-secured-ase.yml)
- [Scalable e-commerce web app](../../web-apps/idea/scalable-ecommerce-web-app.yml)
- [Scalable Episerver marketing website](../../solution-ideas/articles/digital-marketing-episerver.yml)
- [Scalable Sitecore marketing website](../../solution-ideas/articles/digital-marketing-sitecore.yml)

### Healthcare

- [Clinical insights with Microsoft Cloud for Healthcare](../../example-scenario/mch-health/medical-data-insights.yml)
- [Consumer health portal on Azure](../../example-scenario/digital-health/health-portal.yml)
- [Virtual health on Microsoft Cloud for Healthcare](../../example-scenario/mch-health/virtual-health-mch.yml)

### Modernization

- [Choose between traditional web apps and single-page apps](/dotnet/architecture/modern-web-apps-azure/choose-between-traditional-web-and-single-page-apps)
- [ASP.NET architectural principles](/dotnet/architecture/modern-web-apps-azure/architectural-principles)
- [Common client-side web technologies](/dotnet/architecture/modern-web-apps-azure/common-client-side-web-technologies)
- [Development process for Azure](/dotnet/architecture/modern-web-apps-azure/development-process-for-azure)
- [Azure hosting recommendations for ASP.NET Core web apps](/dotnet/architecture/modern-web-apps-azure/azure-hosting-recommendations-for-asp-net-web-apps)

### Multi-tier apps

- [Multi-tier app service with private endpoint](../../example-scenario/web/multi-tier-app-service-private-endpoint.yml)
- [Multi-tier app service with service endpoint](../../reference-architectures/app-service-web-app/multi-tier-app-service-service-endpoint.yml)
- [Multi-tier web application built for HA/DR](../../example-scenario/infrastructure/multi-tier-app-disaster-recovery.yml)

### Multi-region apps

- [Highly available multi-region web application](../../reference-architectures/app-service-web-app/multi-region.yml)
- [Multi-region web app with private connectivity to database](../../example-scenario/sql-failover/app-service-private-sql-multi-region.yml)

### Scalability

- [Scalable and secure WordPress on Azure](../../example-scenario/infrastructure/wordpress.yml)
- [Scalable cloud applications and site reliability engineering (SRE)](../../example-scenario/apps/scalable-apps-performance-modeling-site-reliability.yml)
- [Scalable web application](../../reference-architectures/app-service-web-app/scalable-web-app.yml)
- [Scalable Umbraco CMS web app](../../solution-ideas/articles/medium-umbraco-web-app.yml)

### Security

- [Improved-security access to multitenant web apps from an on-premises network](../../example-scenario/security/access-multitenant-web-app-from-on-premises.yml)
- [Protect APIs with Application Gateway and API Management](../../reference-architectures/apis/protect-apis.yml)

### SharePoint

- [Highly available SharePoint farm](../../solution-ideas/articles/highly-available-sharepoint-farm.yml)
- [Hybrid SharePoint farm with Microsoft 365](../../solution-ideas/articles/sharepoint-farm-microsoft-365.yml)

## Stay current with web development

Get the latest [updates on Azure web app products and features](https://azure.microsoft.com/updates/?category=web).

## Additional resources

### Example solutions

Here are some additional implementations to consider:

- [Eventual consistency between multiple Power Apps instances](/azure/architecture/guide/power-platform/eventual-consistency)
- [App Service networking features](/azure/app-service/networking-features)
- [IaaS: Web application with relational database](../../high-availability/ref-arch-iaas-web-and-db.yml)
- [Migrate a web app using Azure APIM](../../example-scenario/apps/apim-api-scenario.yml)
- [Sharing location in real time using low-cost serverless Azure services](../../example-scenario/signalr/index.yml)
- [Serverless web application](../../reference-architectures/serverless/web-app.yml)
- [Web application monitoring on Azure](../../reference-architectures/app-service-web-app/app-monitoring.yml)
- [Web app private connectivity to Azure SQL Database](../../example-scenario/private-web-app/private-web-app.yml)

### AWS or Google Cloud professionals

- [AWS to Azure services comparison - Web applications](/azure/architecture/aws-professional/services#web-applications)
- [Google Cloud to Azure services comparison - Application services](/azure/architecture/gcp-professional/services#application-services)