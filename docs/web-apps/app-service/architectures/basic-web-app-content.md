This article provides a basic architecture to help you learn about running web applications on Azure App Service in a single region.

> [!IMPORTANT]
> This architecture isn't meant for production applications. It serves as an introductory setup for learning and proof-of-concept (POC) purposes. To design a production App Service application, see [Baseline highly available zone-redundant web application](./baseline-zone-redundant.yml).

## Architecture

:::image type="complex" source="../_images/basic-app-service-architecture-flow.svg" lightbox="../_images/basic-app-service-architecture-flow.svg" alt-text="Diagram that shows a basic App Service architecture." border="false":::
    The diagram shows a user that issues an HTTPS request. An arrow points to a section that contains App Service built-in authentication, App Service, an App Service instance, and managed identity. An arrow points from this section to Azure SQL Database. The Identity section includes Microsoft Entra ID. The Monitoring section includes Application Insights and Azure Monitor.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/basic-app-service-architecture-flow.vsdx) of this architecture.*

### Workflow

The following workflow corresponds to the preceding diagram.

1. A user issues an HTTPS request to the App Service default domain on `azurewebsites.net`. This domain automatically points to the built-in public IP address of your App Service application. The transport layer security (TLS) connection is established from the client directly to App Service. Azure fully manages the certificate.

1. Easy Auth, which is a feature of App Service, ensures that the user who accesses the site is authenticated by using Microsoft Entra ID.

1. Your application code deployed to App Service handles the request. For example, that code might connect to an Azure SQL Database instance by using a connection string that's configured in App Service as an app setting.

1. The information about the original request to App Service and the call to SQL Database is logged in Application Insights.

### Components

- [Microsoft Entra ID](/entra/fundamentals/whatis) is a cloud-based identity and access management service that provides authentication and authorization capabilities. In this architecture, it integrates with App Service through Easy Auth to ensure authentication for users who access the web application. It also simplifies the authentication process without requiring significant code changes.

- [App Service](/azure/well-architected/service-guides/app-service-web-apps) is a managed platform for building, deploying, and scaling web applications. In this architecture, it hosts the web application code, handles HTTPS requests on the default `azurewebsites.net` domain, and connects to SQL Database via configured connection strings.

- [Azure Monitor](/azure/azure-monitor/overview) is a monitoring service that collects, analyzes, and acts on telemetry data from cloud and on-premises environments. In this architecture, it captures and stores information about requests to App Service and calls to SQL Database through Application Insights integration.

- [SQL Database](/azure/well-architected/service-guides/azure-sql-database-well-architected-framework) is a managed relational database service that provides SQL Server capabilities in the cloud. In this architecture, it serves as the data storage layer, which enables the App Service application to connect via connection strings that are defined in app settings.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

The [components](#components) listed in this architecture link to Well-Architected service guides. Service guides detail recommendations and considerations for specific services. This section extends that guidance by highlighting key [Well-Architected Framework](/azure/well-architected/) recommendations and considerations that apply to this architecture.

This basic architecture is designed for evaluation and learning purposes only. It prioritizes simplicity and cost efficiency over production-grade functionality. The following sections highlight key limitations of this architecture and provide recommendations and considerations to help you plan for more robust deployments.

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

This architecture isn't designed for production deployments. The following critical reliability features are omitted in this architecture:

- The App Service plan is configured for the Standard tier, which doesn't include support for [Azure availability zones](/azure/reliability/availability-zones-overview). App Service becomes unavailable if a problem occurs with the instance, the rack, or the datacenter that hosts the instance.

- SQL Database is configured for the Basic tier, which doesn't support [zone-redundancy](/azure/azure-sql/database/high-availability-sla#general-purpose-service-tier-zone-redundant-availability). As a result, data isn't replicated across Azure availability zones, which risks loss of committed data if an outage occurs.

- Deployments to this architecture might result in downtime for application deployments because most deployment techniques require all running instances to be restarted. Users might experience 503 errors during this process. This deployment downtime is addressed in the baseline architecture through [deployment slots](/azure/app-service/deploy-best-practices#use-deployment-slots). Careful application design, schema management, and application configuration handling are necessary to support concurrent slot deployment. Use this POC to design and validate your slot-based production deployment approach.

- Autoscaling isn't enabled in this basic architecture. To avoid reliability problems caused by insufficient compute resources, you must overprovision to ensure enough capacity to handle maximum concurrent demand.

For more information about how to overcome these reliability concerns, see [Baseline highly available zone-redundant web application - Reliability](/azure/architecture/web-apps/app-service/architectures/baseline-zone-redundant#reliability).

If the workload requires a multi-region active-active or active-passive architecture, see [Multi-region App Service app approaches for disaster recovery](../../guides/multi-region-app-service/multi-region-app-service.yml).

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

This architecture isn't designed for production deployments. The following critical security features were omitted in this architecture, along with other reliability recommendations and considerations:

- This basic architecture doesn't implement network privacy. The data and management planes for the resources, such as App Service and Azure SQL Server, are reachable over the public internet. Omitting private networking significantly increases the attack surface of your architecture. For more information about how implementing private networking ensures the following security features, see [Baseline highly available zone-redundant web application – Networking](/azure/architecture/web-apps/app-service/architectures/baseline-zone-redundant#networking). Implementing private networking helps mitigate these risks by providing the following security features:

  - A single secure entry point for client traffic.

  - Network traffic is filtered at both the packet level and the distributed denial-of-service (DDoS) level.

  - Data exfiltration is minimized by keeping traffic in Azure by using Azure Private Link.

  - Network resources are logically grouped and isolated from each other through network segmentation.

- This basic architecture doesn't include a deployment of [Azure Web Application Firewall](/azure/web-application-firewall/overview). The web application isn't protected against common exploits and vulnerabilities. To see how Azure Web Application Firewall can be implemented with Azure Application Gateway in an App Services architecture, see the [baseline implementation](/azure/architecture/web-apps/app-service/architectures/baseline-zone-redundant#ingress-to-app-services).

- This basic architecture stores secrets such as the SQL Server connection string in App Settings. App settings are encrypted by default. However, when you move to production, consider storing secrets in Azure Key Vault for increased governance. For stronger security and reduced secret management overhead, consider using managed identity for authentication instead of embedding secrets in connection strings.

- Remote debugging and Kudu endpoints can remain enabled during development or the POC phase. When you move to production, you should disable unnecessary control plane, deployment, or remote access.

- Local authentication methods for file transfer protocol (FTP) and source control management (SCM) site deployments can remain enabled during the development or POC phase. When you move to production, you should disable local authentication to those endpoints.

- You don't need to enable [Microsoft Defender for App Service](/azure/defender-for-cloud/defender-for-app-service-introduction) in the POC phase. When you move to production, you should enable Defender for App Service to generate security recommendations. You should implement these recommendations to increase your security posture and to detect multiple threats to your App Service deployment.

- App Service includes a Secure Sockets Layer (SSL) endpoint on a subdomain of `azurewebsites.net` at no extra cost. HTTP requests are redirected to the HTTPS endpoint by default. For production deployments, a custom domain is typically used with Application Gateway or API Management in front of your App Service deployment.

- Use the [integrated authentication mechanism for App Service](/azure/app-service/overview-authentication-authorization). Easy Auth simplifies the process of integrating identity providers into your web app. It handles authentication outside your web app, so you don't have to make significant code changes.

- Use managed identity for workload identities. Managed identity eliminates the need for developers to manage authentication credentials. The basic architecture authenticates to SQL Server by using a password in a connection string. Consider using [managed identity to authenticate to SQL Server](/azure/app-service/tutorial-connect-msi-sql-database).

For more information, see [Secure an app in App Service](/azure/app-service-web/web-sites-security).

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

This architecture optimizes for cost through the many trade-offs against the other pillars of the Well-Architected Framework. These trade-offs are specifically made to align with the learning and POC goals of this architecture. The cost savings compared to a more production-ready architecture, such as the [baseline highly available zone-redundant web application](./baseline-zone-redundant.yml), mainly result from the following choices:

- A single App Service instance, with no autoscaling enabled

- Standard pricing tier for App Service

- No custom TLS certificate or static IP address

- No web application firewall (WAF)

- No dedicated storage account for application deployment

- Basic pricing tier for SQL Database, with no backup retention policies

- No Microsoft Defender for Cloud components

- No network traffic egress control through a firewall

- No private endpoints

- Minimal logs and log retention period in Azure Monitor Logs

To view the estimated cost of this architecture, see the [pricing calculator estimate](https://azure.com/e/a5e725c0fda44d4286fd1836976f56f8) that uses this architecture's components. The cost of this architecture can usually be further reduced by using an [Azure Dev/Test subscription](https://azure.microsoft.com/pricing/offers/dev-test/), which would be an ideal subscription type for POCs like this.

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

The following sections provide guidance about the configuration, monitoring, and deployment of your App Service application.

#### App configurations

Because the basic architecture isn't intended for production, it uses [App Service configuration](/azure/app-service/configure-common) to store configuration values and secrets. You can store secrets in App Service configuration during the POC phase. You don't use real secrets and don't require secrets governance that production workloads require.

Consider the following configuration recommendations and considerations:

- Start by using App Service configuration to store configuration values and connection strings in POC deployments. App settings and connection strings are encrypted and decrypted immediately before being injected into your app when it starts.

- When you move to production, store your secrets in Key Vault. Key Vault improves the governance of secrets in two ways:

  - Externalizing your secrets to Key Vault provides a single, centralized location for secure secret management.

  - By using Key Vault, you can log every interaction with secrets, including every time a secret is accessed.

- When you move to production, you can maintain your use of both Key Vault and App Service configuration by using [Key Vault references](/azure/app-service/app-service-key-vault-references).

#### Containers

You can use the basic architecture to deploy supported code directly to Windows or Linux instances. Alternatively, App Service is also a container hosting platform that you can use to run your containerized web application. App Service provides various built-in containers. Custom or multiple-container apps help fine-tune the runtime environment or support code languages that aren't natively supported. This approach requires the introduction of a container registry.

#### Control plane

During the POC phase, familiarize yourself with the App Service control plane, which is accessible through the Kudu service. This service provides common deployment APIs, such as ZIP deployments, and it exposes raw logs and environment variables.

If you use containers, ensure that you understand Kudu's ability to open a Secure Shell (SSH) session to a container to support advanced debugging capabilities.

#### Diagnostics and monitoring

During the POC phase, it's important to get an understanding of what logs and metrics are available for capture. Consider the following recommendations and ideas for monitoring in the POC phase:

- Enable [diagnostics logging](/azure/app-service-web/web-sites-enable-diagnostic-log) for all items log sources. Configuring the use of all diagnostic settings helps you understand what logs and metrics are provided for you out of the box and helps you identify any gaps you need to close by using a logging framework in your application code. When you move to production, eliminate log sources that don't add value but add noise and cost to your workload's log sink.

- Configure logging to use Azure Log Analytics. Azure Log Analytics provides you with a scalable platform to centralize logging that's easy to query.

- Use [Application Insights](/azure/application-insights/app-insights-overview) or another application performance management (APM) tool to emit telemetry and logs to monitor application performance.

#### Deployment

The following points provide guidance for how to deploy your App Service application:

- Follow the guidance in [CI/CD for Azure Web Apps with Azure Pipelines](/azure/architecture/solution-ideas/articles/azure-devops-continuous-integration-and-continuous-deployment-for-azure-web-apps) to automate the deployment of your application. Start building your deployment logic in the POC phase. Implementing continuous integration and continuous delivery (CI/CD) early in the development process allows you to quickly and safely iterate on your application as you move toward production.

- Use [Azure Resource Manager templates (ARM templates)](/azure/azure-resource-manager/resource-group-overview#resource-groups) to deploy Azure resources and their dependencies. It's important to start this process in the POC phase. As you move toward production, you want the ability to automatically deploy your infrastructure.

- Use different ARM templates and integrate them with Azure DevOps Services. This setup lets you create different environments. For example, you can replicate production-like scenarios or load testing environments only when needed and save on cost.

For more information, see the [Operational Excellence design principles](/azure/well-architected/operational-excellence/principles).

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

Because this architecture isn't designed for production deployments, this section outlines some of the critical performance efficiency features that were omitted in this architecture, along with other recommendations and considerations.

An outcome of your POC should be a SKU selection that you estimate is suitable for your workload. Design your workload to efficiently meet demand through horizontal scaling by adjusting the number of compute instances deployed in the App Service plan. Don't design the system to depend on changing the compute SKU to align with demand.

- The App Service deployment in this basic architecture doesn't have automatic scaling implemented. The service doesn't dynamically scale out or scale in to efficiently stay aligned with demand.

  - The Standard tier supports [autoscale settings](/azure/azure-monitor/autoscale/autoscale-get-started) to allow you to configure rule-based autoscaling. As part of your POC process, determine efficient autoscaling settings tailored to your application code's resource requirements and expected usage patterns.

  - For production deployments, consider Premium tiers that support [autoscaling](/azure/app-service/manage-automatic-scaling) where the platform automatically handles scaling decisions.

- Follow the [guidance to scale up individual databases with no application downtime](/azure/sql-database/sql-database-single-database-scale) if you need a higher service tier or performance level for SQL Database.

## Next steps

Deployment tutorials:

- [Deploy App Service with a SQL Database](/azure/app-service/tutorial-dotnetcore-sqldb-app)
- [Deploy and configure servers, instances, and databases for Azure SQL](/azure/devops/pipelines/targets/azure-sqldb)

Product documentation:

- [App Service overview](/azure/app-service/overview)
- [Azure Monitor overview](/azure/azure-monitor/fundamentals/overview)
- [App Service plan overview](/azure/app-service/overview-hosting-plans)
- [Overview of Log Analytics in Azure Monitor](/azure/azure-monitor/logs/log-analytics-overview)
- [What is Microsoft Entra ID?](/entra/fundamentals/what-is-entra)
- [What is SQL Database?](/azure/azure-sql/database/sql-database-paas-overview)

Microsoft Learn modules:

- [Secure Azure by using Microsoft Defender for Cloud and Microsoft Sentinel](/training/paths/secure-azure-using-microsoft-defender-cloud-sentinel)
- [Understand Microsoft Entra ID](/training/modules/understand-azure-active-directory)
- [Configure Azure Monitor](/training/modules/monitor-azure-vm-using-diagnostic-data)
- [Explore App Service](/training/modules/introduction-to-azure-app-service)
- [Host a web application with App Service](/training/modules/host-a-web-app-with-azure-app-service)
- [Host your domain on Azure DNS](/training/modules/host-domain-azure-dns)
- [Implement Key Vault](/training/modules/implement-azure-key-vault)
- [Manage users and groups in Microsoft Entra ID](/training/modules/manage-users-and-groups-in-aad)

## Related resources

- [Baseline zone-redundant web application](./baseline-zone-redundant.yml)
- [Multi-region App Service app approaches for disaster recovery](../../guides/multi-region-app-service/multi-region-app-service.yml)
