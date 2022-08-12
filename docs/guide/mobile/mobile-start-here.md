---
title: Mobile architecture design
description: Review resources to help you learn about mobile development and back-end infrastructure on Azure. Includes solution ideas and reference architectures.
author: EdPrice-MSFT
ms.author: architectures
ms.date: 08/15/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure-app-service
  - vs-app-center
  - xamarin
  - azure-communication-services
  - azure-notification-hubs
categories:
  - mobile
  - developer-tools
---

# Mobile architecture design

The Azure platform can help you quickly build Android, iOS, and Windows apps that fit your business needs. You can use Azure to power your apps with intelligent back-end services and automate your development lifecycle to ship faster and with more confidence.

These are just some of the services that Azure provides to help you with mobile development and back-end infrastructure:

- [Azure App Service](https://azure.microsoft.com/services/app-service). Build and host web apps, mobile back ends, and RESTful APIs in the programming language of your choice without managing infrastructure. Use [Mobile Apps](https://azure.microsoft.com/services/app-service/mobile), a feature of App Service, to create mobile apps for any device.

- [Visual Studio App Center](https://azure.microsoft.com/services/app-center). Build, test, release, and monitor your mobile apps.

- [Xamarin](https://azure.microsoft.com/features/xamarin). Quickly create cloud-powered mobile apps.

- [Azure Communication Services](https://azure.microsoft.com/services/communication-services). Use a set of rich communication APIs, video APIs, and SMS APIs to deploy your applications across any device, on any platform.

- [Azure Notification Hubs](https://azure.microsoft.com/services/notification-hubs). Use this massively scalable mobile push notification engine for sending notifications to iOS, Android, Windows, or Kindle devices.

- [Azure Maps](https://azure.microsoft.com/services/azure-maps). Easily incorporate location-based data into mobile solutions.

- [Azure Cognitive Services](https://azure.microsoft.com/services/cognitive-services). Add cognitive capabilities to apps by using APIs and AI services.

## Path to production

Azure provides various options for development platforms and back-end services.

To learn about single-platform, cross-platform, and hybrid development frameworks, see [Choose a mobile development framework](/azure/developer/mobile-apps/choose-mobile-framework).

For information about source-code management, see [Cloud-hosted mobile application source code management](/azure/developer/mobile-apps/serverless-compute?toc=https%3A%2F%2Freview.docs.microsoft.com%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Freview.docs.microsoft.com%2Fazure%2Farchitecture%2Fbread%2Ftoc.json).

To start exploring options for other back-end services, see these articles:

- [Build mobile back-end components with compute services](/azure/developer/mobile-apps/serverless-compute?toc=https%3A%2F%2Freview.docs.microsoft.com%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Freview.docs.microsoft.com%2Fazure%2Farchitecture%2Fbread%2Ftoc.json) 
- [Add authentication and manage user identities in your mobile apps](/azure/developer/mobile-apps/authentication?toc=https%3A%2F%2Freview.docs.microsoft.com%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Freview.docs.microsoft.com%2Fazure%2Farchitecture%2Fbread%2Ftoc.json)

## Best practices

Automate your development lifecycle to ship faster and with more confidence. See these articles for information about CI/CD:

- [Automate the lifecycle of your apps with continuous build and integration](/azure/developer/mobile-apps/continuous-integration)
- [Automate the deployment and release of your mobile applications with continuous delivery services](/azure/developer/mobile-apps/continuous-delivery)

## Architectures for mobile apps

The following sections provide links to reference architectures in some key categories.

### Storage

- [Store, sync, and query mobile application data from the cloud](/azure/developer/mobile-apps/data-storage)
- [Cloud storage for highly secure, durable, scalable apps with Azure Storage](/azure/developer/mobile-apps/azure-storage)

### Scalability

- [Scalable web and mobile applications using Azure Database for MySQL](../../solution-ideas/articles/scalable-web-and-mobile-applications-using-azure-database-for-mysql.yml)
- [Scalable web and mobile applications using Azure Database for PostgreSQL](../../solution-ideas/articles/scalable-web-and-mobile-applications-using-azure-database-for-postgresql.yml)

### Scenario-specific apps

- [Custom mobile workforce app](../../solution-ideas/articles/custom-mobile-workforce-app.yml)
- [Modern customer support portal](../../solution-ideas/articles/modern-customer-support-portal-powered-by-an-agile-business-process.yml)
- [Social app for mobile and web with authentication](../../solution-ideas/articles/social-mobile-and-web-app-with-authentication.yml)
- [Task-based consumer mobile app](../../solution-ideas/articles/task-based-consumer-mobile-app.yml)

## Stay current with mobile development on Azure

Get the latest updates on [Azure mobile development services and features](https://azure.microsoft.com/updates/?category=mobile).

## Additional resources

### Example solutions

Following are a few more architectures to consider:

- [Add a mobile front end to a legacy app](../../solution-ideas/articles/adding-a-modern-web-and-mobile-frontend-to-a-legacy-claims-processing-application.yml)
- [Azure Communication Services architecture design](../../guide/mobile/azure-communication-services-architecture.yml)
- [Analyze and understand mobile application use](/azure/developer/mobile-apps/analytics)

#### AWS professionals

- [AWS to Azure services comparison - Mobile services](../../aws-professional/services.md#mobile-services)
