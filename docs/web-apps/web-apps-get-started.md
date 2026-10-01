---
title: Get Started with Web App Architecture Design
description: Get started with web app architecture design on Azure. Explore web app technologies, guidance, solution ideas, and reference architectures.
author: anaharris-ms
ms.author: pnp
ms.update-cycle: 1095-days
ms.date: 06/17/2026
ms.topic: concept-article
ms.subservice: category-get-started
ai-usage: ai-assisted
---

# Get started with web app architecture design

Many web apps need to be always available from anywhere in the world and usable from any device or screen size. Web apps must be secure, flexible, and scalable to meet spikes in demand.

To help you choose an Azure web app hosting option, see [Choose an Azure compute service](/azure/architecture/guide/technology-choices/compute-decision-tree).

## Azure services for web apps

Azure provides a range of services for creating, hosting, and monitoring web apps:

- [Azure App Service](/azure/app-service/overview): Create enterprise-ready web and mobile apps for any platform or device and deploy them on a scalable cloud infrastructure.

- [Azure Web Application Firewall](/azure/web-application-firewall/overview): Provides powerful protection for web apps.

- [Azure Monitor](/azure/azure-monitor/fundamentals/overview): Provides full observability into your applications, infrastructure, and network. Azure Monitor includes [Application Insights](/azure/azure-monitor/app/app-insights-overview), which provides application performance management and monitoring for live web apps.

- [Azure SignalR Service](/azure/azure-signalr/signalr-overview): Add real-time web functionality.

- [Web App for Containers](/azure/app-service/quickstart-custom-container): Run containerized web apps on Windows and Linux.

- [Azure Service Bus](/azure/service-bus-messaging/service-bus-messaging-overview): Integrate with other web apps by using loosely coupled event-driven patterns.

## Architecture

:::image type="complex" source="app-service/_images/baseline-app-service-architecture.svg" alt-text="Diagram that shows a baseline Azure App Service architecture that has zone redundancy and high availability (HA)." lightbox="app-service/_images/baseline-app-service-architecture.svg" border="false":::
    The diagram shows a virtual network that has three subnets. One subnet contains Azure Application Gateway with Azure Web Application Firewall. A user points to this subnet. The second subnet contains private endpoints for Azure platform as a service (PaaS) solutions. The third subnet contains a virtual interface for Azure App Service network integration. Azure Application Gateway communicates with Azure App Service via a private endpoint. Azure App Service shows a zone-redundant configuration. Azure App Service uses virtual network integration and private endpoints to communicate with Azure SQL Database, Azure Key Vault, and Azure Storage. Private DNS zones link to the virtual network. Azure DDoS Protection secures the virtual network. Microsoft Entra ID provides identity and access control. Application Insights and Azure Monitor serve monitoring purposes.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/web-app-services.vsdx) of this architecture.*

The previous diagram demonstrates a typical baseline web app implementation. For real-world solutions that you can build in Azure, see [Web app architectures](#web-app-architectures).

## Explore web app architectures and guides

The articles in this section include guides and fully developed architectures that you can deploy in Azure and expand to production-grade solutions. Solution ideas demonstrate implementation patterns and possibilities to consider as you plan your web app proof-of-concept (POC) development. These articles can help you decide how to use web app technologies in Azure.

[!INCLUDE [web-apps-get-started](../includes/web-apps-get-started-include.md)]

## Organizational readiness

Organizations at the beginning of the cloud adoption process can use the [Cloud Adoption Framework for Azure](/azure/cloud-adoption-framework/) to access proven guidance that accelerates cloud adoption.

To help ensure the quality of your web app solution on Azure, follow the guidance in the [Azure Well-Architected Framework](/azure/well-architected/). The Azure Well-Architected Framework provides prescriptive guidance for organizations that seek architectural excellence and describes how to design, provision, and monitor cost-optimized Azure solutions. For web app-specific guidance, see the following Azure Well-Architected Framework service guides:

- [Azure App Service](/azure/well-architected/service-guides/app-service-web-apps)
- [Azure API Management](/azure/well-architected/service-guides/azure-api-management)
- [Azure Functions](/azure/well-architected/service-guides/azure-functions)

## Best practices

Follow these best practices to improve the reliability, security, cost effectiveness, performance, and operational quality of your web app workloads on Azure.

- [Characteristics of modern web apps](/dotnet/architecture/modern-web-apps-azure/modern-web-applications-characteristics): An overview of the expectations and design principles for modern web apps, including scalability, modularity, and cloud-hosted architecture.

- [Architecture best practices for Azure App Service](/azure/well-architected/service-guides/app-service-web-apps): Azure Well-Architected Framework guidance for Azure App Service that covers reliability, security, cost optimization, operational excellence, and performance efficiency.

- [Azure App Service deployment best practices](/azure/app-service/deploy-best-practices): Guidance for deployment sources, build pipelines, deployment mechanisms, and deployment slot strategies for Azure App Service.

- [Security baseline for Azure App Service](/security/benchmark/azure/baselines/app-service-security-baseline): Security controls and recommendations for Azure App Service based on the Microsoft cloud security benchmark. It covers network security, identity management, and data protection.

## Stay current with web apps

Azure web app services evolve to address modern application challenges. Stay informed about the latest [updates and features](https://azure.microsoft.com/updates/).

To stay current with key web app services, see the following resource:

- [Azure updates for web app products and features](https://azure.microsoft.com/updates/?filters=%5B%22API+Management%22%2C%22App+Configuration%22%2C%22App+Service%22%2C%22Azure+Communication+Services%22%2C%22Azure+Maps%22%2C%22Azure+SignalR+Service%22%2C%22Azure+Web+PubSub%22%2C%22Content+Delivery+Network%22%2C%22Notification+Hubs%22%2C%22Static+Web+Apps%22%2C%22Web+App+for+Containers%22%5D)

### Other resources

The following resources can help you discover more about web app architecture design:

- [Azure App Service networking features](/azure/app-service/networking-features): An overview of inbound and outbound networking features available in Azure App Service. It includes access restrictions, private endpoints, virtual network integration, hybrid connections, and App Service Environment networking.

- [Migrate a web app by using Azure API Management](../example-scenario/apps/apim-api-scenario.yml): An example scenario for using Azure API Management to migrate a legacy web application.

## Amazon Web Services (AWS) or Google Cloud professionals

To help you get started quickly, the following articles compare Azure web app options to other cloud services and provide migration guidance.

### Service comparison

- [AWS to Azure services comparison - Web apps](/azure/architecture/aws-professional/#web-applications)
- [Google Cloud to Azure services comparison - Application services](/azure/architecture/gcp-professional/services#application-services)

### Migration guidance

If you're migrating from another cloud platform, see the following articles:

- [Migrate a workload from AWS to Azure](/azure/migration/migrate-workload-from-aws-introduction)
- [Migrate from AWS Application Load Balancer to Azure Application Gateway](/azure/application-gateway/application-load-balancing-aws-to-azure-how-to)
