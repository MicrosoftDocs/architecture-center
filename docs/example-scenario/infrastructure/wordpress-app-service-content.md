This article describes an architecture for small to medium-sized WordPress installations on Azure. The architecture uses Azure App Service to host WordPress and managed Azure services for the database, networking, and content delivery layers. For larger or storage-intensive installations, see [WordPress hosting options on Azure](../../guide/infrastructure/wordpress-overview.yml#wordpress-hosting-options-on-azure).

## Architecture

:::image type="content" source="media/wordpress-app-service.png" alt-text="Architecture diagram of WordPress on Azure App Service. Azure Front Door routes traffic to web apps. Azure Database for MySQL stores dynamic content." lightbox="media/wordpress-app-service.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/azure-wordpress-app-service.vsdx) of this architecture.*

> [!NOTE]
> You can extend this solution by implementing tips and recommendations that aren't specific to any particular WordPress hosting method. For general tips for deploying a WordPress installation, see [WordPress on Azure](../../guide/infrastructure/wordpress-overview.yml).

### Dataflow

This scenario covers a scalable installation of [WordPress that runs on Azure App Service](/azure/app-service/quickstart-wordpress).

- Users access the front-end website through Azure Front Door with Azure Web Application Firewall enabled.
- Azure Front Door distributes requests across the App Service web apps that run WordPress. If the requested content isn't cached, Azure Front Door retrieves it from the web apps.
- The WordPress application connects to Azure Database for MySQL Flexible Server through a private endpoint and retrieves dynamic content from the database.
- Enable high availability for Azure Database for MySQL via a standby server.
- All static content is hosted in Azure Blob Storage.

### Components

- [App Service](/azure/well-architected/service-guides/app-service-web-apps) is a PaaS offering for building, deploying, and scaling web apps. In this architecture, App Service hosts the WordPress application.

- [Azure Database for MySQL - Flexible Server](/azure/well-architected/service-guides/azure-database-for-mysql) is a managed relational database service based on the open-source MySQL database engine. In this architecture, it stores WordPress data.

- [Azure DDoS Protection](/azure/ddos-protection/ddos-protection-overview) is a network security service that provides enhanced DDoS mitigation features. In this architecture, DDoS Protection helps defend against DDoS attacks against the public IP address.

- [Azure Front Door](/azure/well-architected/service-guides/azure-front-door) is a modern cloud content delivery network and global load balancer. In this architecture, Azure Front Door is the application entry point for web users.

- [Azure Virtual Network](/azure/well-architected/service-guides/virtual-network) provides network isolation for deployed resources. In this architecture, App Service and backend components are reachable only through private connections in the virtual network.

- [Blob Storage](/azure/well-architected/service-guides/azure-blob-storage) is an object storage service optimized for large amounts of unstructured data. In this architecture, Blob Storage hosts all static content for the WordPress application.

- [Network security groups](/azure/virtual-network/network-security-groups-overview) use security rules to allow or deny network traffic based on source or destination IP address, port, and protocol. In this architecture, network security group rules restrict traffic flow between subnets.

- [WordPress on App Service template](/azure/app-service/quickstart-wordpress) is a managed solution template for hosting WordPress on App Service. In this architecture, the template provides a preconfigured WordPress deployment that includes App Service and the other Azure services described in this section.

### Alternatives

- You can use [Azure Managed Redis](/azure/redis/overview) to host a key-value cache for WordPress performance optimization plug-ins. The cache can be shared among the App Service web apps.

## Scenario details

This example scenario is appropriate for small to medium-sized installations of WordPress.

### Potential use cases

- Media events that cause traffic surges
- Blogs that use WordPress as their content management system
- Business or e-commerce websites that use WordPress
- Websites that are built by using other content management systems

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

Consider the following recommendations when you deploy this solution:

- App Service provides built-in load balancing and health checks. These features help you maintain availability when an App Service web app fails.
- Azure Front Door can serve cached responses when the origin is temporarily unavailable. This capability provides a limited availability benefit but isn't a complete availability solution.
- You can replicate Blob Storage to a paired region for data redundancy across multiple regions. For more information, see [Azure Storage redundancy](/azure/storage/common/storage-disaster-recovery-guidance).
- To increase Azure Database for MySQL availability, enable high availability. Same-zone high availability creates a standby server in the same availability zone as the primary server. For stronger fault isolation, use zone-redundant high availability, which places the standby server in a different availability zone. You need to use the General Purpose or Business Critical compute tier to enable high availability. For more information, see the [high availability options](/azure/mysql/flexible-server/concepts-high-availability) that apply to your needs.

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

Consider the following recommendations when you deploy this solution:

- Use Azure Web Application Firewall on Azure Front Door to help protect the virtual network traffic that flows into the front-end application tier. For more information, see [Azure Web Application Firewall on Azure Front Door](/azure/web-application-firewall/afds/afds-overview).
- Use private endpoints for all backend services, including Azure Database for MySQL and Blob Storage. Private endpoints keep traffic within the virtual network and prevent exposure to the public internet. For more information, see [Azure Private Link](/azure/private-link/private-link-overview).
- Don't allow outbound internet traffic to flow from the database tier.
- Don't allow public access to private storage.
- Keep WordPress core, themes, and plugins updated to their latest versions to address known security vulnerabilities. Uninstall any plugins and themes that you don't use.
- Restrict access to the WordPress admin panel (`/wp-admin`) by using IP restrictions on App Service or by configuring Azure Front Door rules to limit access to known IP ranges. For more information, see [Azure App Service access restrictions](/azure/app-service/app-service-ip-restrictions).
- Store secrets, such as database connection strings and API keys, in [Azure Key Vault](/azure/key-vault/general/overview). Use Key Vault references in App Service to retrieve secrets without storing them in application settings or code.

For more information about WordPress security, see [General WordPress security and performance tips](../../guide/infrastructure/wordpress-overview.yml#general-wordpress-security-and-performance-tips) and [Azure security documentation][security].

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

Consider the following recommendations when you deploy this solution:

- Enable [Application Insights](/azure/azure-monitor/app/app-insights-overview) to monitor application performance, availability, and usage patterns. Use the monitoring data to identify and resolve issues before they affect users.
- Configure [automated backups](/azure/mysql/flexible-server/concepts-backup-restore) for Azure Database for MySQL. Define a retention period that aligns with your recovery point objectives. Test your restoration process periodically to verify that backups are reliable.
- Use [deployment slots](/azure/app-service/deploy-staging-slots) in App Service to stage updates before you swap them into production. Deployment slots help you validate changes and reduce downtime during deployments.
- Automate your infrastructure deployments by using Azure Resource Manager templates or Bicep. Infrastructure as code helps you maintain consistency across environments and makes it possible to rebuild environments reliably.
- Set up [Azure Monitor alerts](/azure/azure-monitor/alerts/alerts-overview) for key metrics, such as App Service CPU utilization, database connection counts, and response times. Alerts help you respond to operational issues before they affect users.

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

Review the following cost considerations when you deploy this solution:

- **Traffic expectations (GB/month)**. Your traffic volume is the factor that has the greatest effect on your cost. The amount of traffic that you receive determines the number of App Service instances that you need and the price for outbound data transfer. Serving content through Azure Front Door can reduce outbound data transfer costs.
- **Amount of hosted data**. It's important to consider the amount of data that you host in Blob Storage. Storage pricing is based on used capacity.
- **Write percentage**. Consider how much new data you write to your website and host in Azure Storage. Determine whether the new data is needed. For multi-region deployments, the amount of new data that you write to your website correlates with the amount of data that's mirrored across your regions.
- **Static versus dynamic content**. Monitor your database storage performance and capacity to determine whether a lower-cost SKU can support your site. The database stores dynamic content, and Azure Front Door caches static content.
- **App Service optimization**. For general tips for optimizing App Service costs, see [Azure App Service and cost optimization](/azure/well-architected/service-guides/app-service-web-apps#cost-optimization).

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

Consider the following recommendations when you deploy this solution:

- Enable the autoscale feature in App Service to automatically scale the number of instances. You can set an autoscale trigger to respond to customer demand or based on a defined schedule. For more information, see [Get started with autoscale in Azure](/azure/azure-monitor/autoscale/autoscale-get-started).
- Use [Azure Managed Redis](/azure/redis/overview) to cache PHP session data and frequently accessed WordPress objects. Offloading these items from the database reduces query load and improves page load times.
- Configure Azure Front Door caching rules to serve static assets from edge locations. Caching at the edge reduces latency for users who are geographically distant from the App Service region.
- Use the latest supported PHP version in App Service for performance and security improvements. Verify that your WordPress version and plugins are compatible before you upgrade.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Vaclav Jirovsky](https://www.linkedin.com/in/vaclavjirovsky) | Cloud Solution Architect

Other contributors:

- Adrian Calinescu | Senior Cloud Solution Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

Product documentation:

- [What is Azure Front Door?](/azure/frontdoor/front-door-overview)
- [What is Azure Web Application Firewall?](/azure/web-application-firewall/overview)
- [What is Azure Blob Storage?](/azure/storage/blobs/storage-blobs-overview)
- [Azure Database for MySQL - Flexible Server](/azure/mysql/flexible-server/overview)
- [What is Azure Virtual Network?](/azure/virtual-network/virtual-networks-overview)
- [About Azure Key Vault](/azure/key-vault/general/overview)
- [Quickstart: Create a WordPress site](/azure/app-service/quickstart-wordpress)
- [What is Azure DDoS Protection?](/azure/ddos-protection/ddos-protection-overview)

Microsoft training modules:

- [Implement Azure Key Vault](/training/modules/implement-azure-key-vault)
- [Introduction to Azure Virtual Network](/training/modules/introduction-to-azure-virtual-networks)

## Related resources

- [Ten design principles for Azure applications](../../guide/design-principles/index.md)
- [Scalable cloud applications and site reliability engineering](../../example-scenario/apps/scalable-apps-performance-modeling-site-reliability.yml)

<!-- links -->

[security]: /azure/security
