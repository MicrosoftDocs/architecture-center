# Web architecture design

Modern web applications have higher user expectations and greater demands than ever before. Today's web apps are expected to be available 24/7 from anywhere in the world, and usable from virtually any device or screen size. Web applications must be secure, flexible, and scalable to meet spikes in demand. 

Azure provides a wide range of tools and capabilities for creating, hosting, and monitoring web apps. These are just some of the key web app services available in Azure:

- [Azure App Service](https://azure.microsoft.com/services/app-service). Quickly and easily create enterprise-ready web and mobile apps for any platform or device, and deploy them on a scalable and reliable cloud infrastructure.
- [Azure Web Application Firewall](https://azure.microsoft.com/services/web-application-firewall). A cloud-native web application firewall service that provides powerful protection for web apps.
- [Azure Monitor](https://azure.microsoft.com/services/monitor). Full observability into your applications, infrastructure, and network, including [Application Insights](/azure/azure-monitor/app/app-insights-overview).
- [Azure SignalR Service](https://azure.microsoft.com/services/signalr-service). Add real-time web functionalities easily.
- [Static Web Apps](https://azure.microsoft.com/services/app-service/static). Streamlined full-stack development from source code to global high availability.
- [Web App for Containers](/services/app-service/containers). Run containerized web apps on Windows and Linux.

## Introduction to web apps on Azure

If you're new to creating and hosting web apps on Azure, the best way to learn more is with [Microsoft Learn](https://docs.microsoft.com/learn/?WT.mc_id=learnaka), a free online training platform. Microsoft Learn provides interactive training for Microsoft products and more. 

Here are a few good starting points to consider:
- Learning path: 
   - [Create Azure App Service web apps](/learn/paths/create-azure-app-service-web-apps)
- Modules: 
   - [Deploy and run a containerized web app with Azure App Service](/learn/modules/deploy-run-container-app-service)
   - [Azure Static Web Apps](/learn/paths/azure-static-web-apps)

## Path to production

Consider these patterns, guidelines, and architectures as you plan and implement your deployment:
- [Basic web application](/azure/architecture/reference-architectures/app-service-web-app/basic-web-app)
- [Common web application architectures](/dotnet/architecture/modern-web-apps-azure/common-web-application-architectures?toc=https%3A%2F%2Fdocs.microsoft.com%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Fdocs.microsoft.com%azure%2Farchitecture%2Fbread%2Ftoc.json)
- [Design principles for Azure applications](/azure/architecture/guide/design-principles)
- [Design and implementation patterns - Cloud Design Patterns](/azure/architecture/patterns/category/design-implementation) 
- [Enterprise deployment using App Services Environment](/azure/architecture/reference-architectures/enterprise-integration/ase-standard-deployment)
- [High availability enterprise deployment using App Services Environment](/azure/architecture/reference-architectures/enterprise-integration/ase-high-availability-deployment)

## Best practices 
 
For a good overview, see [Characteristics of modern web applications](https://docs.microsoft.com/dotnet/architecture/modern-web-apps-azure/modern-web-applications-characteristics?toc=https%3A%2F%2Fdocs.microsoft.com%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Fdocs.microsoft.com%2Fazure%2Farchitecture%2Fbread%2Ftoc.json)

For information specific to Azure App Service, see these resources: 
- [Azure App Service and operational excellence](/azure/architecture/framework/services/compute/azure-app-service/operational-excellence)  
- [App Service deployment best practices](/azure/app-service/deploy-best-practices?toc=https%3A%2F%2Fdocs.microsoft.com%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Fdocs.microsoft.com%2Fazure%2Farchitecture%2Fbread%2Ftoc.json)
- [Security recommendations for App Service](/azure/app-service/security-recommendations?toc=https%3A%2F%2Fdocs.microsoft.com%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Fdocs.microsoft.com%2Fazure%2Farchitecture%2Fbread%2Ftoc.json)
- [Azure security baseline for App Service](/security/benchmark/azure/baselines/app-service-security-baseline?toc=https%3A%2F%2Fdocs.microsoft.com%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Fdocs.microsoft.com%2Fazure%2Farchitecture%2Fbread%2Ftoc.json)

## Web app architectures

### E-commerce 

- [E-commerce front end](/azure/architecture/example-scenario/apps/ecommerce-scenario)
- [Intelligent product search engine for e-commerce](/azure/architecture/example-scenario/apps/ecommerce-search)
- [Scalable order processing](/azure/architecture/example-scenario/data/ecommerce-order-processing)
- [E-commerce website running in secured App Service Environment](/azure/architecture/solution-ideas/articles/ecommerce-website-running-in-secured-ase)
- [Scalable e-commerce web app](/azure/architecture/solution-ideas/articles/scalable-ecommerce-web-app)
- [Scalable Episerver marketing website](/azure/architecture/solution-ideas/articles/digital-marketing-episerver)
- [Scalable Sitecore marketing website](/azure/architecture/solution-ideas/articles/digital-marketing-sitecore)
- [Simple digital marketing website](/azure/architecture/solution-ideas/articles/digital-marketing-smb)

### Healthcare 

- [Clinical insights with Microsoft Cloud for Healthcare](/azure/architecture/example-scenario/mch-health/medical-data-insights)
- [Consumer health portal on Azure](/azure/architecture/example-scenario/digital-health/health-portal)
- [Virtual health on Microsoft Cloud for Healthcare](/azure/architecture/example-scenario/mch-health/virtual-health-mch)

### Multi-tier apps

- [Multi-tier app service with private endpoint](/azure/architecture/example-scenario/web/multi-tier-app-service-private-endpoint)
- [Multi-tier app service with service endpoint](/azure/architecture/reference-architectures/app-service-web-app/multi-tier-app-service-service-endpoint)
- [Multi-tier web application built for HA/DR](/azure/architecture/example-scenario/infrastructure/multi-tier-app-disaster-recovery)

### Multi-region apps 

- [Highly available multi-region web application](/azure/architecture/reference-architectures/app-service-web-app/multi-region)
- [Multi-region web app with private connectivity to database](/azure/architecture/example-scenario/sql-failover/app-service-private-sql-multi-region)

### Scalability 

- [Scalable and secure WordPress on Azure](/azure/architecture/example-scenario/infrastructure/wordpress)
- [Scalable cloud applications and site reliability engineering (SRE)](/azure/architecture/example-scenario/apps/scalable-apps-performance-modeling-site-reliability)
- [Scalable web application](/azure/architecture/reference-architectures/app-service-web-app/scalable-web-app)
- [Scalable Umbraco CMS web app](/azure/architecture/solution-ideas/articles/medium-umbraco-web-app)
- [Scalable web apps with Azure Redis Cache](/azure/architecture/solution-ideas/articles/scalable-web-apps)

### Security 

- [Improved-security access to multitenant web apps from an on-premises network](/azure/architecture/example-scenario/security/access-multitenant-web-app-from-on-premises)
- [Protect APIs with Application Gateway and API Management](/azure/architecture/reference-architectures/apis/protect-apis)

### Modernization 

- [Choose between traditional web apps and single-page apps](/dotnet/architecture/modern-web-apps-azure/choose-between-traditional-web-and-single-page-apps?toc=https%3A%2F%2Fdocs.microsoft.com%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Fdocs.microsoft.com%2Fazure%2Farchitecture%2Fbread%2Ftoc.json)
- [ASP.NET architectural principles](/dotnet/architecture/modern-web-apps-azure/architectural-principles?toc=https%3A%2F%2Fdocs.microsoft.com%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Fdocs.microsoft.com%2Fazure%2Farchitecture%2Fbread%2Ftoc.json)
- [Common client-side web technologies](/dotnet/architecture/modern-web-apps-azure/common-client-side-web-technologies?toc=https%3A%2F%2Fdocs.microsoft.com%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Fdocs.microsoft.com%2Fazure%2Farchitecture%2Fbread%2Ftoc.json)
- [Development process for Azure](https://docs.microsoft.com/dotnet/architecture/modern-web-apps-azure/development-process-for-azure?toc=https%3A%2F%2Fdocs.microsoft.com%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Fdocs.microsoft.com%2Fazure%2Farchitecture%2Fbread%2Ftoc.json)
- [Azure hosting recommendations for ASP.NET Core web apps](/dotnet/architecture/modern-web-apps-azure/azure-hosting-recommendations-for-asp-net-web-apps?toc=https%3A%2F%2Fdocs.microsoft.com%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Fdocs.microsoft.com%2Fazure%2Farchitecture%2Fbread%2Ftoc.json)

### SharePoint

- [Highly available SharePoint farm](/azure/architecture/solution-ideas/articles/highly-available-sharepoint-farm)
- [Hybrid SharePoint farm with Microsoft 365](/azure/architecture/solution-ideas/articles/sharepoint-farm-microsoft-3650)

## Stay current with web development

Get the latest [updates on Azure web app products and features](https://azure.microsoft.com/updates/?category=web).

## Additional resources

### Example solutions

Here are some additional implementations to consider:

- [Simple branded website](/azure/architecture/solution-ideas/articles/simple-branded-website)
- [Build web and mobile applications](/azure/architecture/solution-ideas/articles/webapps)
- [Eventual consistency between multiple Power Apps instances](/azure/architecture/reference-architectures/power-platform/eventual-consistency)
- [App Service networking features](/azure/app-service/networking-features?toc=https%3A%2F%2Fdocs.microsoft.com%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Fdocs.microsoft.com%2Fazure%2Farchitecture%2Fbread%2Ftoc.json)
- [IaaS: Web application with relational database](/azure/architecture/high-availability/ref-arch-iaas-web-and-db)
- [Migrate a web app using Azure APIM](/azure/architecture/example-scenario/apps/apim-api-scenario)
- [Sharing location in real time using low-cost serverless Azure services](/azure/architecture/example-scenario/signalr)
- [Serverless web application](/azure/architecture/reference-architectures/serverless/web-app)
- [Web application monitoring on Azure](/azure/architecture/reference-architectures/app-service-web-app/app-monitoring)
- [Web app private connectivity to Azure SQL Database](/azure/architecture/example-scenario/private-web-app/private-web-app)
- [Dynamics Business Central as a service on Azure](/azure/architecture/solution-ideas/articles/business-central)
- [Real-time presence with Microsoft 365, Azure, and Power Platform](/azure/architecture/solution-ideas/articles/presence-microsoft-365-power-platform)

### AWS or Google Cloud professionals

- [AWS to Azure services comparison - Web applications](/azure/architecture/aws-professional/services#web-applications)
- [Google Cloud to Azure services comparison - Application services](/azure/architecture/gcp-professional/services#application-services)
