This article provides a basic architecture intended for learning about running web applications on Azure App Service in a single region.

> [!IMPORTANT]
> This architecture is not meant to be used for production applications. It is intended to be a lightweight architecture you can use for learning purposes. For production Azure App Service applications, see the [Baseline highly available zone-redundant web application](./baseline-zone-redundant.yml).

> [!IMPORTANT]
> ![GitHub logo](../../../_images/github.svg) The guidance is backed by an [example implementation](https://github.com/Azure-Samples/app-service-basic-implementation) which showcases a basic App Service implementation on Azure. This implementation can be used as a basis for learning about working with Azure App Service.

## Architecture

:::image type="complex" source="../_images/basic-app-service-architecture.svg" lightbox="../_images/basic-app-service-architecture.png" alt-text="Diagram that shows a basic App Service architecture.":::
    The diagram shows a Azure App Service connecting directly to an Azure SQL Database. The diagram also shows Azure App Insights and Azure Monitor.
:::image-end:::
*Figure 1: Basic Azure App Service architecture*

*Download a [Visio file](https://arch-center.azureedge.net/web-app-services.vsdx) of this architecture.*

### Workflow

1. A user issues an HTTP request to the App Service's default domain or a mapped custom domain if one is configured.
1. The App Service connects to the Azure SQL Database instance, using a connection string configured in the App Service configured as an app setting.

### Components

- [Microsoft Entra ID](https://azure.microsoft.com/products/active-directory/) is a cloud-based identity and access management service. It provides a single identity control plane to manage permissions and roles for users accessing your web application. It integrates with App Service and simplifies authentication and authorization for web apps.
- [App Service](/azure/well-architected/service-guides/app-service-web-apps) is a fully managed platform for building, deploying, and scaling web applications.
- [Azure Monitor](https://azure.microsoft.com/products/monitor/) is a monitoring service that collects, analyzes, and acts on telemetry data across your deployment.
- [Azure SQL Database](/azure/well-architected/service-guides/azure-sql-database-well-architected-framework) is a managed relational database service for relational data.

## Recommendations and considerations

The [components](#components) listed in this architecture link to Azure Well-Architected service guides. Service guides detail recommendations and considerations for specific services. This section extends that guidance by highlighting key Azure Well-Architected Framework recommendations and considerations that apply to this architecture. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

This *basic architecture* is not intended for production deployments. The architecture favors simlicity and cost efficiency over functionality to allow you to evaluate and learn Azure App Service. The following sections will outline some deficiencies of the basic architecture, along with the recommendations and considerations.

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

Because this architecture isn’t designed for production deployments, the following outlines some of the critical reliability features that were omitted, along with additional reliability recommendations and considerations:

- The App Service Plan is configured for the `Standard` tier which does not have [Azure availability zone](/azure/reliability/availability-zones-overview) support. The App Service will become unavailable in the event of any issue with the instance, the rack, or the datacenter hosting the instance.
- The Azure SQL DB is configured for the `Basic` tier which does not support [zone-redundancy](/azure/azure-sql/database/high-availability-sla#general-purpose-service-tier-zone-redundant-availability). This means that data is not replicated across Azure availability zones, risking loss of committed data in the event of an outage.

See the [reliability section in the Baseline highly available zone-redundant web application](/azure/architecture/web-apps/app-service/architectures/baseline-zone-redundant#reliability) for basline reliability guidance.

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

Because this architecture isn’t designed for production deployments, the following outlines some of the critical performance efficiency features that were omitted, along with additional recommendations and considerations:

- The App Service does not have automatic scaling implemented. The service will not dynamically adjust to meet demand. With increased demand, you will face increased latency and service disruptions.
  - The `Standard` tier, which this implementation is configured for, does support [auto scale settings](/azure/azure-monitor/autoscale/autoscale-get-started) to allow you to configure rule-based autoscaling, however it is not implemented in the basic architecture.
  - For production deployments, consider premium tiers that support [automatic autoscaling](/azure/app-service/manage-automatic-scaling) where the platform automatically handles scaling decisions.
- Limit scaling up and down as much as possible. It can trigger an application restart. Instead, scale out. Select a tier and size that meet your performance requirements under typical load and then scale out the instances to handle changes in traffic volume.
- Follow the [guidance to scale up individual databases with no application downtime](/azure/sql-database/sql-database-single-database-scale) if you need a higher service tier or performance level for SQL Database.

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

The following sections provide guidance around configuration, monitoring, and deployment of your App Service application.

#### App configurations

Because the basic architecture is not intended for production, it uses [App Service configuration](/azure/app-service/configure-common) to store configuration values and secrets. Storing secrets in App Service configuration is fine for the PoC phase. You aren't using real secrets and do not require secrets governance that production workloads require.

The following are configuration recommendations and considerations:

- It is fine to use App Service configuration to store secrets in proof of concept deployments. App settings and connection strings are encrypted and decrypted just before being injected into your app when it starts.
- When you move into production phase, store your secrets in Azure Key Vault. This will improve your governance of secrets in two ways:
  - Externalizing your storage of secrets to Azure Key Vault allows you to centralize your storage of secrets. You have one place to manage secrets.
  - Using Azure Key Vault, you are able to log every interaction with secrets, including every time a secret is accessed.
- When you move into production, you can maintain your use of both Azure Key Vault and App Service configuration by [using Key Vault references](/azure/app-service/app-service-key-vault-references).

#### Diagnostics and monitoring

During the proof of concept phase, it is important to get an understanding of what logs and metrics are available to be captured. The following are recommendations and considerations for monitoring in the proof of concept phase:

- Enable [diagnostics logging](/azure/app-service-web/web-sites-enable-diagnostic-log) for all items, including application logging and web server logging. This will help you understand what logs and metrics you require in a production environment. When you start moving to production, you should filter to capture just what you need.
- Configure logging to use Azure Log Analytics. Azure Log Analytics provides you with a scalable platform to centralize logging that is easy to query.
- Use a service such as [New Relic](https://newrelic.com) or [Application Insights](/azure/application-insights/app-insights-overview) to monitor application performance and behavior under load.

#### Deployment

The following lists guidance around deploying your App Service application.

- Follows the guidance in [CI/CD for Azure Web Apps with Azure Pipelines](/azure/architecture/solution-ideas/articles/azure-devops-continuous-integration-and-continuous-deployment-for-azure-web-apps) to automate the deployment of your application. Start building your deployment logic in the PoC phase. This will allow you to quickly and safely iterate on your application as you move toward production.
- Use [ARM templates](/azure/azure-resource-manager/resource-group-overview#resource-groups) to deploy Azure resources and their dependencies. It is important to start this process in the PoC phase. As you move toward production, you will want the ability to automatically deploy your infrastructure.
- Use different ARM Templates and integrate them with Azure DevOps services. This setup lets you create different environments in minutes. For example, you can replicate production-like scenarios or load testing environments only when needed and save on cost.

For more information, see the DevOps section in [Azure Well-Architected Framework](/azure/architecture/framework/devops/overview).

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

Because this architecture isn’t designed for production deployments, the following outlines some of the critical secuirty features that were omitted, along with additional reliability recommendations and considerations:

- The `basic` architecture does not implement network security. The data and management planes for the resources, such as the Azure App Service and Azure SQL Server, are reachable over the public internet. Omitting network security significantly increases the attack surface of your application. See the [networking section of the Baseline highly available zone-redundant web application](https://learn.microsoft.com/en-us/azure/architecture/web-apps/app-service/architectures/baseline-zone-redundant#networking) to see how implementing network security ensures the following:

  1. A single secure entry point for client traffic
  1. Network traffic is filtered
  1. Data in transit is encrypted end-to-end with TLS
  1. Data exfiltration is minimized by keeping traffic in Azure through the use of Private Link
  1. Network resources are logically grouped and isolated from each other through network segmentation

- The `basic' architecture does not include a deployment of the [Azure Web Application Firewall](/azure/web-application-firewall/overview). The web application is not protected against common exploits and volnerabilities. See the [baseline implementation](/azure/architecture/web-apps/app-service/architectures/baseline-zone-redundant#ingress-to-app-services) to see how the Web Application Firewall can be implemented with Azure Application Gatway in an Azure App Services architecture.

- The `basic` architecture stores secrets such as the Azure SQL Server connection string in App Settings. While app settings are encrypted, consider storing secrets in Azure Key Vault for increased governance.

- Leaving remote debugging enabled while in development or the proof of concept phase is fine. When you move to production, you should disable remote debugging.

- Leaving local authentication methods for FTP and SCM site deployments enabled is fine while in the development or proof of concept phase. When you move to production, you should disable local authentication to those endpoints.

- You do not need to enable [Microsoft Defender for App Service](/azure/defender-for-cloud/defender-for-app-service-introduction) in the proof of concept phase. When moving to production, you should enable Defender for App Service to generates security recommendations you should implement to increase your security posture and to detect multiple threats to your App Service.

- Azure App Service includes an SSL endpoint on a subdomain of `azurewebsites.net` at no extra cost. HTTP requests are redirected to the HTTPS endpoint by default.

- Use the [integrated authentication mechanism for App Service ("EasyAuth")](/azure/app-service/overview-authentication-authorization). EasyAuth simplifies the process of integrating identity providers into your web app. It handles authentication outside your web app, so you don't have to make significant code changes.

- Use managed identity for workload identities. Managed identity eliminates the need for developers to manage authentication credentials. The `basic` architecture authenticates to SQL Server via password in a connection string. Consider using [managed identity to authenticate to Azure SQL Server](/azure/app-service/tutorial-connect-msi-sql-database).

For some other security considerations, see [Secure an app in Azure App Service](/azure/app-service-web/web-sites-security).

## Deploy this scenario

The guidance is backed by an [example implementation](https://github.com/Azure-Samples/app-service-basic-implementation) which showcases a basic App Service implementation on Azure.

## Next steps

> [!div class="nextstepaction"]
> [Baseline highly available zone-redundant web application](/azure/architecture/web-apps/app-service/architectures/baseline-zone-redundant)

## Related resources

- [Ten design principles for Azure applications](../../../guide/design-principles/index.md)
- [Baseline zone-redundant web application](multi-region.yml)
- [Highly available multi-region web application](multi-region.yml)

Tips for troubleshooting your application:

- Use the [troubleshoot blade](https://azure.microsoft.com/updates/self-service-troubleshooting-for-app-service-web-apps-customers) in the Azure portal to find solutions to common problems.
- Enable [log streaming](/azure/app-service-web/web-sites-enable-diagnostic-log#stream-logs) to see logging information in near-real-time.
- The [Kudu dashboard](https://azure.microsoft.com/blog/windows-azure-websites-online-tools-you-should-know-about) has several tools for monitoring and debugging your application. For more information, see [Azure Websites online tools you should know about](https://azure.microsoft.com/blog/windows-azure-websites-online-tools-you-should-know-about) (blog post). You can reach the Kudu dashboard from the Azure portal. Open the blade for your app and select **Tools**, then select **Kudu**.
- If you use Visual Studio, see the article [Troubleshoot a web app in Azure App Service using Visual Studio](/azure/app-service-web/web-sites-dotnet-troubleshoot-visual-studio) for debugging and troubleshooting tips.

Product documentation:

- [About Azure Key Vault](/azure/key-vault/general/overview)
- [App Service overview](/azure/app-service/overview)
- [Azure Monitor overview](/azure/azure-monitor/overview)
- [Azure App Service plan overview](/azure/app-service/overview-hosting-plans)
- [Overview of Log Analytics in Azure Monitor](/azure/azure-monitor/logs/log-analytics-overview)
- [What is Microsoft Entra ID?](/azure/active-directory/fundamentals/active-directory-whatis)
- [What is Azure DNS?](/azure/dns/dns-overview)
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