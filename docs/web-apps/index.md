---
title: Web architecture design
description: Get an overview of Azure web app technologies, guidance, solution ideas, and reference architectures.
author: claytonsiemens77
ms.author: pnp
ms.date: 06/14/2023
ms.topic: concept-article
ms.subservice: architecture-guide
---

# Web applications architecture design

Many web apps are expected to be available all day, every day from anywhere in the world, and usable from virtually any device or screen size. Web applications must be secure, flexible, and scalable to meet spikes in demand.

This article provides an overview of Azure web app technologies, guidance, solution ideas, and reference architectures contained in the Azure Architecture Center.

Azure provides a wide range of tools and capabilities for creating, hosting, and monitoring web apps. These are just some of the key web app services available in Azure:

- [Azure App Service](/azure/well-architected/service-guides/app-service-web-apps) enables you to easily create enterprise-ready web and mobile apps for any platform or device and deploy them on a scalable cloud infrastructure.
- [Azure Web Application Firewall](https://azure.microsoft.com/services/web-application-firewall) provides powerful protection for web apps.
- [Azure Monitor](https://azure.microsoft.com/services/monitor) provides full observability into your applications, infrastructure, and network. Monitor includes [Application Insights](/azure/azure-monitor/app/app-insights-overview), which provides application performance management and monitoring for live web apps.
- [Azure SignalR Service](https://azure.microsoft.com/services/signalr-service) enables you to easily add real-time web functionalities.
- [Web App for Containers](https://azure.microsoft.com/services/app-service/containers) enables you to run containerized web apps on Windows and Linux.
- [Azure Service Bus](https://azure.microsoft.com/services/service-bus/) enables you to integrate with other web apps using loosely coupled event-driven patterns.

## Introduction to web apps on Azure

If you're new to creating and hosting web apps on Azure, the best way to learn more is with [Microsoft Learn training](/training/). This free online platform provides interactive training for Microsoft products and more.

These are a few good starting points to consider:

- [Create Azure App Service web apps](/training/paths/create-azure-app-service-web-apps/)
- [Deploy and run a containerized web app with Azure App Service](/training/modules/deploy-run-container-app-service/)

## Path to production

Consider these patterns, guidelines, and architectures as you plan and implement your deployment:

- [Basic web application](app-service/architectures/basic-web-app.yml)
- [Baseline zone-redundant web application](app-service/architectures/baseline-zone-redundant.yml)
- [Common web application architectures](/dotnet/architecture/modern-web-apps-azure/common-web-application-architectures)
- [Design principles for Azure applications](../guide/design-principles/index.md)
- [Enterprise deployment using App Service Environment](../web-apps/app-service-environment/architectures/app-service-environment-standard-deployment.yml)
- [High availability enterprise deployment using App Service Environment](../web-apps/app-service-environment/architectures/app-service-environment-high-availability-deployment.yml)

## Best practices

For a good overview, see [Characteristics of modern web applications](/dotnet/architecture/modern-web-apps-azure/modern-web-applications-characteristics).

For more information specific to Azure App Service, see:

- [Architecture best practices for Azure App Service (Web Apps)](/azure/well-architected/service-guides/app-service-web-apps)
- [App Service deployment best practices](/azure/app-service/deploy-best-practices)
- [Azure security baseline for App Service](/security/benchmark/azure/baselines/app-service-security-baseline)

## Web app architectures

The following sections, organized by category, provide links to sample web app architectures.

### Modernization

- [Choose between traditional web apps and single-page apps](/dotnet/architecture/modern-web-apps-azure/choose-between-traditional-web-and-single-page-apps)
- [ASP.NET architectural principles](/dotnet/architecture/modern-web-apps-azure/architectural-principles)
- [Common client-side web technologies](/dotnet/architecture/modern-web-apps-azure/common-client-side-web-technologies)
- [Development process for Azure](/dotnet/architecture/modern-web-apps-azure/development-process-for-azure)
- [Azure hosting recommendations for ASP.NET Core web apps](/dotnet/architecture/modern-web-apps-azure/azure-hosting-recommendations-for-asp-net-web-apps)

### Multi-tier apps

- [Multi-tier web application built for HA/DR](../example-scenario/infrastructure/multi-tier-app-disaster-recovery.yml)

### Scalability

- [Baseline web application with zone redundancy](../web-apps/app-service/architectures/baseline-zone-redundant.yml)

### Security

- [Improved-security access to multitenant web apps from an on-premises network](../web-apps/guides/networking/access-multitenant-web-app-from-on-premises.yml)
- [Protect APIs with Application Gateway and API Management](../web-apps/api-management/architectures/protect-apis.yml)

### SharePoint

- [Highly available SharePoint farm](../solution-ideas/articles/highly-available-sharepoint-farm.yml)

## Stay current with web development

Get the latest [updates on Azure web app products and features](https://azure.microsoft.com/updates/?filters=%5B%22API+Management%22%2C%22App+Configuration%22%2C%22App+Service%22%2C%22Azure+Communication+Services%22%2C%22Azure+Maps%22%2C%22Azure+SignalR+Service%22%2C%22Azure+Web+PubSub%22%2C%22Content+Delivery+Network%22%2C%22Notification+Hubs%22%2C%22Static+Web+Apps%22%2C%22Web+App+for+Containers%22%5D).

## Additional resources

### Example solutions

Here are some additional implementations to consider:

- [App Service networking features](/azure/app-service/networking-features)
- [Migrate a web app using Azure APIM](../example-scenario/apps/apim-api-scenario.yml)

### AWS or Google Cloud professionals

- [AWS to Azure services comparison - Web applications](/azure/architecture/aws-professional/index#web-applications)
- [Google Cloud to Azure services comparison - Application services](/azure/architecture/gcp-professional/services#application-services)
