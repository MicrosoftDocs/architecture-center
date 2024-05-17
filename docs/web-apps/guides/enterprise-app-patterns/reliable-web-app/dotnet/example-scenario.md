---
title: Reliable Web App pattern for .NET example scenario
description: Learn about the Reliable Web App pattern for .NET through an example scenario
author: stephen-sumner    
ms.author: ssumner
ms.reviewer: ssumner
ms.date: 04/28/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
azureCategories:
    - web
    - developer-tools
    - devops
products:
  - azure
categories:
  - web
---

# Reliable Web App pattern for .NET

This article provides an example scenario for implementing the [Reliable Web App pattern for .NET](./guidance-content.md). It follows the journey of a fictional company called Relecloud and its migration to the cloud.

> [!TIP]
> ![GitHub logo](../../../../../_images/github.svg) The **[reference implementation](aka.ms/eap/rwa/dotnet/)** represents the final result of the migration and implementation of the Reliable Web App pattern.

## Business scenario

The fictional company Relecloud sells tickets through its on-premises web application. Relecloud has a positive sales forecast and anticipates increased demand on their ticketing web app. To meet this demand, they defined the goals for the web application:

- Apply low-cost, high-value code changes
- Reach a service level objective (SLO) of 99.9%
- Adopt DevOps practices
- Create cost-optimized environments
- Improve reliability and security

Relecloud's on-premises infrastructure wasn't a cost-effective solution to reach these goals. So, they decided that migrating their web application to Azure was the most cost effective way to achieve their immediate and future objectives.

## Choose the right services

Before the move to the cloud, Relecloud's ticketing web app was an on-premises, monolithic, ASP.NET app. It ran on two virtual machines and had a Microsoft SQL Server database. The web app suffered from common challenges in scalability and feature deployment. This starting point, their business goals, and SLO drove their service choices.

### Application platform

Relecloud chose [Azure App Service](/azure/app-service/overview) as the application platform for the following reasons:

- *High service level agreement (SLA):* It has a high SLA that meets the production environment SLO of 99.9%.

- *Reduced management overhead:* It's a fully managed solution that handles scaling, health checks, and load balancing.

- *.NET support:* It supports the version of .NET that the application is written in.

- *Containerization capability:* The web app can converge on the cloud without containerizing, but the application platform also supports containerization without changing Azure services

- *Autoscaling:* The web app can automatically scale up, down, in, and out based on user traffic and settings.

### Identity management

Relecloud chose [Microsoft Entra ID](/entra/fundamentals/whatis) for the following reasons:

- *Authentication and authorization:* The application needs to authenticate and authorize call center employees.

- *Scalable:* It scales to support larger scenarios.

- *User-identity control:* Call center employees can use their existing enterprise identities.

- *Authorization protocol support:* It supports OAuth 2.0 for managed identities.

### Database

The web app used SQL Server on-premises, and Relecloud wanted to use the existing database schema, stored procedures, and functions. Several SQL products are available on Azure, but Relecloud chose [Azure SQL Database](/azure/azure-sql/azure-sql-iaas-vs-paas-what-is-overview?view=azuresql) for the following reasons:

- *Reliability:* The general-purpose tier provides a high SLA and multi-region redundancy. It can support a high user load.

- *Reduced management overhead:* It provides a managed SQL database instance.

- *Migration support:* It supports database migration from on-premises SQL Server.

- *Consistency with on-premises configurations:* It supports the existing stored procedures, functions, and views.

- *Resiliency:* It supports backups and point-in-time restore.

- *Expertise and minimal rework:* SQL Database takes advantage of in-house expertise and requires minimal work to adopt.

### Application performance monitoring

Relecloud chose to use Application Insights for the following reasons:

- *Integration with Azure Monitor:* It provides the best integration with Azure Monitor.

- *Anomaly detection:* It automatically detects performance anomalies.

- *Troubleshooting:* It helps you diagnose problems in the running app.

- *Monitoring:* It collects information about how users are using the app and allows you to easily track custom events.

- *Visibility gap:* The on-premises solution didn't have application performance monitoring solution. Application Insights provides easy integration with the application platform and code.

### Cache

Relecloud's web app load is heavily skewed toward viewing concerts and venue details. It added Azure Cache for Redis for the following reasons:

- *Reduced management overhead:* It's a fully managed service.

- *Speed and volume:* It has high-data throughput and low latency reads for commonly accessed, slow changing data.

- *Diverse supportability:* It's a unified cache location for all instances of the web app to use.

- *External data store:* The on-premises application servers performed VM-local caching. This setup didn't offload highly frequented data, and it couldn't invalidate data.

- *Nonsticky sessions:* Externalizing session state supports nonsticky sessions.

### Load balancer

Relecloud needed a layer-7 load balancer that could route traffic across multiple regions. Relecloud needed a multi-region web app to meet the SLO of 99.9%. Relecloud chose [Azure Front Door](/azure/frontdoor/front-door-overview) for the following reasons:

- *Global load balancing:* It's a layer-7 load balancer that can route traffic across multiple regions.

- *Web application firewall:* It integrates natively with Azure Web Application Firewall.

- *Routing flexibility:* It allows the application team to configure ingress needs to support future changes in the application.

- *Traffic acceleration:* It uses anycast to reach the nearest Azure point of presence and find the fastest route to the web app.

- *Custom domains:* It supports custom domain names with flexible domain validation.

- *Health probes:* The application needs intelligent health probe monitoring. Azure Front Door uses responses from the probe to determine the best origin for routing client requests.

- *Monitoring support:* It supports built-in reports with an all-in-one dashboard for both Front Door and security patterns. You can configure alerts that integrate with Azure Monitor. It lets the application log each request and failed health probes.

- *DDoS protection:* It has built-in layer 3-4 DDoS protection.

- *Content delivery network:* It positions Relecloud to use a content delivery network. The content delivery network provides site acceleration.

### Web application firewall

Relecloud needed to protect the web app from web attacks. They used Azure Web Application Firewall for the following reasons:

- *Global protection:* It provides improved global web app protection without sacrificing performance.

- *Botnet protection:* The team can monitor and configure to address security concerns from botnets.

- *Parity with on-premises:* The on-premises solution was running behind a web application firewall managed by IT.

- *Ease of use:* Web Application Firewall integrates with Azure Front Door.

### Configuration storage

Relecloud wanted to replace file-based configuration with a central configuration store that integrates with the application platform and code. They added App Configuration to the architecture for the following reasons:

- *Flexibility:* It supports feature flags. Feature flags allow users to opt in and out of early preview features in a production environment without redeploying the app.

- *Supports Git pipeline:* The source of truth for configuration data needed to be a Git repository. The pipeline needed to update the data in the central configuration store.

- *Supports managed identities:* It supports managed identities to simplify and help secure the connection to the configuration store.

### Secrets manager

Relecloud's on-premises web app stored secrets in code configuration files, but it's a better security practice to externalize secrets. While [managed identities](/entra/architecture/service-accounts-managed-identities) are the preferred solution for connecting to Azure resources, Relecloud had application secrets they needed to manage. Relecloud used Key Vault for the following reasons:

- *Encryption:* It supports encryption at rest and in transit.

- *Managed identities:* The application services can use managed identities to access the secret store.

- *Monitoring and logging:* It facilitates audit access and generates alerts when stored secrets change.

- *Integration:* It provides native integration with the Azure configuration store (App Configuration) and web hosting platform (App Service).

### Storage solution

On-premises, the web app had disk storage mounted to each web server, but the team wanted to use an external data storage solution. Relecloud chose [Azure Blob Storage](/azure/storage/blobs/storage-blobs-introduction) for the following reasons:

- *Secure access:* The web app can eliminate endpoints for accessing storage exposed to the public internet with anonymous access.

- *Encryption:* It encrypts data at rest and in transit.

- *Resiliency:* It supports zone-redundant storage (ZRS). Zone-redundant storage replicates data synchronously across three Azure availability zones in the primary region. Each availability zone is in a separate physical location that has independent power, cooling, and networking. This configuration should make the ticketing images resilient against loss.

### Endpoint security

Relecloud used Private Link for the following reasons:

- *Enhanced security communication:* It lets the application privately access services on the Azure platform and reduces the network footprint of data stores to help protect against data leakage.

- *Minimal effort:* The private endpoints support the web app platform and database platform the web app uses. Both platforms mirror existing on-premises configurations for minimal change.

### Network security

Relecloud adopted a hub and spoke network topology and wanted to put shared network security services in the hub. Azure Firewall improves security by inspecting all outbound traffic from the spokes to increase network security. Relecloud needed Azure Bastion for secure deployments from a jump host in the DevOps subnet.

## Design web app architecture

Relecloud identified the services on the critical path of availability. They used Azure SLAs for availability estimates. Based on the composite SLA calculation, Relecloud needed a multi-region architecture to meet the SLO of 99.9%. Relecloud chose a hub and spoke network topology to increase the security of their multi-region deployment at reduced cost and management overhead.

## Update code and configurations

Relecloud updated the application and code and configurations according to the Reliable Web App pattern guidance. They introduced three design patterns: Retry, Circuit Breaker, and Cache-Aside to improve the reliability and performance efficiency of their ticketing web app. They also implemented the key updates of the Reliable Web App pattern. The reference implementation