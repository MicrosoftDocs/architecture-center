This article provides a basic architecture intended for learning about running web applications on Azure App Service in a single region.

> [!IMPORTANT]
> This architecture isn't meant to be used for production applications. It serves as an introductory setup for learning and proof of concept (POC) purposes. When designing your production Azure App Service application, see the [Baseline highly available zone-redundant web application](./baseline-zone-redundant.yml).

## Architecture

:::image type="complex" source="../_images/basic-app-service-architecture-flow.svg" lightbox="../_images/basic-app-service-architecture-flow.svg" alt-text="Diagram that shows a basic App Service architecture." border="false":::
    The diagram shows an Azure App Service connecting directly to an Azure SQL Database. The diagram also shows Azure App Insights and Azure Monitor.
:::image-end:::
*Figure 1: Basic Azure App Service architecture*

*Download a [Visio file](https://arch-center.azureedge.net/basic-app-service-architecture-flow.vsdx) of this architecture.*

### Workflow

1. A user issues an HTTPS request to the App Service's default domain on `azurewebsites.net`. This domain automatically points to your App Service's built-in public IP. The TLS connection is established from the client directly to app service. Azure fully managed the certificate.
1. Easy Auth, a feature of Azure App Service, ensures that the user accessing the site is authenticated with Microsoft Entra ID.
1. Your application code deployed to App Service handles the request. For example, that code might connect to an Azure SQL Database instance, using a connection string configured in the App Service configured as an app setting.
1. The information about original request to App Service and the call to Azure SQL Database are logged in Application Insights.

### Components

- [Microsoft Entra ID](/entra/fundamentals/whatis) is a cloud-based identity and access management service that provides authentication and authorization capabilities. In this architecture, it integrates with App Service through Easy Auth to ensure authentication for users that access the web application. It simplifies the authentication process without requiring significant code changes.
- [App Service](/azure/well-architected/service-guides/app-service-web-apps) is a managed platform for building, deploying, and scaling web applications. In this architecture, it hosts the web application code, handles HTTPS requests on the default `azurewebsites.net` domain, and connects to Azure SQL Database via configured connection strings.
- [Azure Monitor](/azure/azure-monitor/overview) is a monitoring service that collects, analyzes, and acts on telemetry data from cloud and on-premises environments. In this architecture, it captures and stores information about requests to App Service and calls to SQL Database through Application Insights integration.
- [SQL Database](/azure/well-architected/service-guides/azure-sql-database-well-architected-framework) is a managed relational database service that provides SQL Server capabilities in the cloud. In this architecture, it serves as the data storage layer that the App Service application connects to via connection strings configured as app settings.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).

The [components](#components) listed in this architecture link to Azure Well-Architected service guides. Service guides detail recommendations and considerations for specific services. This section extends that guidance by highlighting key Azure Well-Architected Framework recommendations and considerations that apply to this architecture. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).

This *basic architecture* isn't intended for production deployments. The architecture favors simplicity and cost efficiency over functionality to allow you to evaluate and learn Azure App Service. The following sections outline some deficiencies of this basic architecture, along with recommendations and considerations.

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

Because this architecture isn't designed for production deployments, the following outlines some of the critical reliability features that are omitted in this architecture:

- The App Service Plan is configured for the `Standard` tier, which doesn't have [Azure availability zone](/azure/reliability/availability-zones-overview) support. The App Service becomes unavailable in the event of any issue with the instance, the rack, or the datacenter hosting the instance.
- The Azure SQL Database is configured for the `Basic` tier, which doesn't support [zone-redundancy](/azure/azure-sql/database/high-availability-sla#general-purpose-service-tier-zone-redundant-availability). This means that data isn't replicated across Azure availability zones, risking loss of committed data in the event of an outage.
- Deployments to this architecture might result in downtime with application deployments, as most deployment techniques require all running instances to be restarted. Users might experience 503 errors during this process. This deployment downtime is addressed in the baseline architecture through [deployment slots](/azure/app-service/deploy-best-practices#use-deployment-slots). Careful application design, schema management, and application configuration handling are necessary to support concurrent slot deployment. Use this POC to design and validate your slot-based production deployment approach.
- Autoscaling isn't enabled in this basic architecture. To prevent reliability issues due to lack of available compute resources, you'd need to overprovision to always run with enough compute to handle max concurrent capacity.

See how to overcome these reliability concerns in the [reliability section in the Baseline highly available zone-redundant web application](/azure/architecture/web-apps/app-service/architectures/baseline-zone-redundant#reliability).

If the workload requires a multi-region active-active or active-passive architecture, see the following resource:

- [Multi-region App Service app approaches for disaster recovery](../../guides/multi-region-app-service/multi-region-app-service.yml) for guidance on deploying your App Service-hosted workload across multiple regions.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

Because this architecture isn’t designed for production deployments, the following outlines some of the critical security features that were omitted in this architecture, along with other reliability recommendations and considerations:

- This basic architecture doesn't implement network privacy. The data and management planes for the resources, such as the Azure App Service and Azure SQL Server, are reachable over the public internet. Omitting private networking significantly increases the attack surface of your architecture. To see how implementing private networking ensures the following security features, see the [networking section of the Baseline highly available zone-redundant web application](/azure/architecture/web-apps/app-service/architectures/baseline-zone-redundant#networking):

  - A single secure entry point for client traffic
  - Network traffic is filtered both at the packet level and at the DDoS level.
  - Data exfiltration is minimized by keeping traffic in Azure by using Private Link
  - Network resources are logically grouped and isolated from each other through network segmentation.

- This basic architecture doesn't include a deployment of the [Azure Web Application Firewall](/azure/web-application-firewall/overview). The web application isn't protected against common exploits and vulnerabilities. See the [baseline implementation](/azure/architecture/web-apps/app-service/architectures/baseline-zone-redundant#ingress-to-app-services) to see how the Web Application Firewall can be implemented with Azure Application Gateway in an Azure App Services architecture.

- This basic architecture stores secrets such as the Azure SQL Server connection string in App Settings. While app settings are encrypted, when moving to production, consider storing secrets in Azure Key Vault for increased governance. An even better solution is to use managed identity for authentication and not have secrets stored in the connection string.

- Leaving remote debugging and Kudu endpoints enabled while in development or the proof of concept phase is fine. When you move to production, you should disable unnecessary control plane, deployment, or remote access.

- Leaving local authentication methods for FTP and SCM site deployments enabled is fine while in the development or proof of concept phase. When you move to production, you should disable local authentication to those endpoints.

- You don't need to enable [Microsoft Defender for App Service](/azure/defender-for-cloud/defender-for-app-service-introduction) in the proof of concept phase. When moving to production, you should enable Defender for App Service to generate security recommendations. These should be implemented to increase your security posture and to detect multiple threats to your App Service.

- Azure App Service includes an SSL endpoint on a subdomain of `azurewebsites.net` at no extra cost. HTTP requests are redirected to the HTTPS endpoint by default. For production deployments, a custom domain is typically used with Application Gateway or API Management in front of your App Service deployment..

- Use the [integrated authentication mechanism for App Service ("EasyAuth")](/azure/app-service/overview-authentication-authorization). EasyAuth simplifies the process of integrating identity providers into your web app. It handles authentication outside your web app, so you don't have to make significant code changes.

- Use managed identity for workload identities. Managed identity eliminates the need for developers to manage authentication credentials. The basic architecture authenticates to SQL Server via password in a connection string. Consider using [managed identity to authenticate to Azure SQL Server](/azure/app-service/tutorial-connect-msi-sql-database).

For some other security considerations, see [Secure an app in Azure App Service](/azure/app-service-web/web-sites-security).

### Cost Optimization

Cost Optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

This architecture optimizes for cost through the many trade-offs against the other pillars of the Well-Architected Framework specifically to align with the learning and proof-of-concept goals of this architecture. The cost savings compared to a more production-ready architecture, such as the [Baseline highly available zone-redundant web application](./baseline-zone-redundant.yml), mainly result from the following choices.

- Single App Service instance, with no autoscaling enabled
- Standard pricing tier for Azure App Service
- No custom TLS certificate or static IP
- No web application firewall (WAF)
- No dedicated storage account for application deployment
- Basic pricing tier for Azure SQL Database, with no backup retention policies
- No Microsoft Defender for Cloud components
- No network traffic egress control through a firewall
- No private endpoints
- Minimal logs and log retention period in Log Analytics

To view the estimated cost of this architecture, see the [Pricing calculator estimate](https://azure.com/e/a5e725c0fda44d4286fd1836976f56f8) using this architecture's components. The cost of this architecture can usually be further reduced by using an [Azure Dev/Test subscription](https://azure.microsoft.com/pricing/offers/dev-test/), which would be an ideal subscription type for proof of concepts like this.

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

The following sections provide guidance around configuration, monitoring, and deployment of your App Service application.

#### App configurations

Because the basic architecture isn't intended for production, it uses [App Service configuration](/azure/app-service/configure-common) to store configuration values and secrets. Storing secrets in App Service configuration is fine for the PoC phase. You aren't using real secrets and don't require secrets governance that production workloads require.

The following are configuration recommendations and considerations:

- Start by using App Service configuration to store configuration values and connection strings in proof of concept deployments. App settings and connection strings are encrypted and decrypted just before being injected into your app when it starts.
- When you move into production phase, store your secrets in Azure Key Vault. The use of Azure Key Vault improves the governance of secrets in two ways:
  - Externalizing your storage of secrets to Azure Key Vault allows you to centralize your storage of secrets. You have one place to manage secrets.
  - Using Azure Key Vault, you're able to log every interaction with secrets, including every time a secret is accessed.
- When you move into production, you can maintain your use of both Azure Key Vault and App Service configuration by [using Key Vault references](/azure/app-service/app-service-key-vault-references).

#### Containers

The basic architecture can be used to deploy supported code directly to Windows or Linux instances. Alternatively, App Service is also a container hosting platform to run your containerized web application. App Service offers various built-in containers. Custom or multi-container apps help fine-tune the runtime environment or support code languages not natively supported. This approach requires the introduction of a container registry.

#### Control plane

During the POC phase, get comfortable with Azure App Service's control plane as exposed through the Kudu service. This service exposes common deployment APIs, such as ZIP deployments, exposes raw logs and environment variables.

If using containers, be sure to understand Kudu's ability to Open an SSH session to a container to support advanced debugging capabilities.

#### Diagnostics and monitoring

During the proof of concept phase, it's important to get an understanding of what logs and metrics are available to be captured. The following are recommendations and considerations for monitoring in the proof of concept phase:

- Enable [diagnostics logging](/azure/app-service-web/web-sites-enable-diagnostic-log) for all items log sources. Configuring the use of all diagnostic settings helps you understand what logs and metrics are provided for you out of the box and any gaps you'll need to close using a logging framework in your application code. When you move to production, you should eliminate log sources that aren't adding value and are adding noise and cost to your workload's log sink.
- Configure logging to use Azure Log Analytics. Azure Log Analytics provides you with a scalable platform to centralize logging that is easy to query.
- Use [Application Insights](/azure/application-insights/app-insights-overview) or another Application Performance Management (APM) tool to emit telemetry and logs to monitor application performance.

#### Deployment

The following lists guidance around deploying your App Service application.

- Follow the guidance in [CI/CD for Azure Web Apps with Azure Pipelines](/azure/architecture/solution-ideas/articles/azure-devops-continuous-integration-and-continuous-deployment-for-azure-web-apps) to automate the deployment of your application. Start building your deployment logic in the PoC phase. Implementing CI/CD early in the development process allows you to quickly and safely iterate on your application as you move toward production.
- Use [ARM templates](/azure/azure-resource-manager/resource-group-overview#resource-groups) to deploy Azure resources and their dependencies. It's important to start this process in the PoC phase. As you move toward production, you want the ability to automatically deploy your infrastructure.
- Use different ARM Templates and integrate them with Azure DevOps services. This setup lets you create different environments. For example, you can replicate production-like scenarios or load testing environments only when needed and save on cost.

For more information, see the DevOps section in [Azure Well-Architected Framework](/azure/architecture/framework/devops/overview).

### Performance Efficiency

Performance Efficiency is the ability of your workload to meet the demands placed on it by users in an efficient manner. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

Because this architecture isn't designed for production deployments, the following outlines some of the critical performance efficiency features that were omitted in this architecture, along with other recommendations and considerations.

An outcome of your proof of concept should be SKU selection that you estimate is suitable for your workload. Your workload should be designed to efficiently meet demand through horizontal scaling by adjusting the number of compute instances deployed in the App Service Plan. Do not design the system to depend on changing the compute SKU to align with demand.

- The App Service in this basic architecture doesn't have automatic scaling implemented. The service doesn't dynamically scale out or in to efficiently keep aligned with demand.
  - The Standard tier does support [auto scale settings](/azure/azure-monitor/autoscale/autoscale-get-started) to allow you to configure rule-based autoscaling. Part of your POC process should be to arrive at efficient autoscaling settings based on your application code's resource needs and expected usage characteristics.
  - For production deployments, consider Premium tiers that support [automatic autoscaling](/azure/app-service/manage-automatic-scaling) where the platform automatically handles scaling decisions.
- Follow the [guidance to scale up individual databases with no application downtime](/azure/sql-database/sql-database-single-database-scale) if you need a higher service tier or performance level for SQL Database.

## Next steps

> [!div class="nextstepaction"]
> [Deploy Azure App Service with an SQL Database](/azure/app-service/tutorial-dotnetcore-sqldb-app)

## Related resources

- [Baseline zone-redundant web application](./baseline-zone-redundant.yml)
- [Multi-region App Service app approaches for disaster recovery](../../guides/multi-region-app-service/multi-region-app-service.yml)

Product documentation:

- [App Service overview](/azure/app-service/overview)
- [Azure Monitor overview](/azure/azure-monitor/overview)
- [Azure App Service plan overview](/azure/app-service/overview-hosting-plans)
- [Overview of Log Analytics in Azure Monitor](/azure/azure-monitor/logs/log-analytics-overview)
- [What is Microsoft Entra ID?](/entra/fundamentals/whatis)
- [What is Azure SQL Database?](/azure/azure-sql/database/sql-database-paas-overview)

Microsoft Learn modules:

- [Configure and manage Azure Monitor](/training/modules/azure-monitor)
- [Configure Microsoft Entra ID](/training/modules/configure-azure-active-directory)
- [Configure Azure Monitor](/training/modules/configure-azure-monitor)
- [Deploy and configure servers, instances, and databases for Azure SQL](/training/modules/azure-sql-deploy-configure)
- [Explore Azure App Service](/training/modules/introduction-to-azure-app-service)
- [Host a web application with Azure App Service](/training/modules/host-a-web-app-with-azure-app-service)
- [Host your domain on Azure DNS](/training/modules/host-domain-azure-dns)
- [Implement Azure Key Vault](/training/modules/implement-azure-key-vault)
- [Manage users and groups in Microsoft Entra ID](/training/modules/manage-users-and-groups-in-aad)
