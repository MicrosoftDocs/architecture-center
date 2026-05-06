This article describes an architecture for small to medium-sized WordPress installations on Azure. The architecture uses Azure App Service to host WordPress and managed Azure services for the database, networking, and content delivery layers. For larger or storage-intensive installations, see [WordPress hosting options on Azure](../../guide/infrastructure/wordpress-overview.yml#wordpress-hosting-options-on-azure).

## Architecture

:::image type="complex" border="false" source="media/wordpress-app-service.svg" alt-text="Architecture diagram of WordPress on App Service. Azure Front Door routes traffic to web apps. Azure Database for MySQL stores dynamic content." lightbox="media/wordpress-app-service.svg":::
   On the left, an arrow points from the internet to Azure Front Door with Azure Web Application Firewall. A dashed arrow labeled static web content points from Azure Blob Storage in the storage account section to Azure Front Door with Azure Web Application Firewall. An arrow points from Azure Front Door with Azure Web Application Firewall to App Service. An arrow points from App Service to the private endpoint. An arrow points from this line to Blob Storage. An arrow points from the private endpoint to Azure Database for MySQL flexible server (primary). An arrow points from the primary server to premium storage. A dashed arrow labeled locally redundant synchronous replication of data and logs points from the primary server's premium storage to the standby server's premium storage. An arrow points from Azure Database for MySQL flexible server (standby) to its premium storage. At the top, a dashed arrow labeled linked points from the private DNS zone to the virtual network.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/wordpress-app-service.vsdx) of this architecture.*

> [!NOTE]
> You can extend this solution by implementing tips and recommendations that aren't specific to any WordPress hosting method. For more information about how to deploy a WordPress installation, see [WordPress on Azure](../../guide/infrastructure/wordpress-overview.yml).

### Data flow

This scenario covers a scalable installation of [WordPress that runs on App Service](/azure/app-service/quickstart-wordpress).

The following data flow corresponds to the previous diagram:

- Users access the front-end website through Azure Front Door with Azure Web Application Firewall enabled.

- Azure Front Door distributes requests across the App Service web apps that run WordPress. If the requested content isn't cached, Azure Front Door retrieves it from the web apps.

- The WordPress application connects to Azure Database for MySQL flexible server through a private endpoint and retrieves dynamic content from the database.

- Azure Database for MySQL supports high availability via a standby server.

- All static content is hosted in Azure Blob Storage.

### Components

- [App Service](/azure/well-architected/service-guides/app-service-web-apps) is a platform as a service (PaaS) offering for building, deploying, and scaling web apps. In this architecture, App Service hosts the WordPress application.

- [Azure Database for MySQL flexible server](/azure/well-architected/service-guides/azure-database-for-mysql) is a managed relational database service based on the open-source MySQL database engine. In this architecture, it stores WordPress data.

- [Azure DDoS Protection](/azure/ddos-protection/ddos-protection-overview) is a network security service that provides enhanced distributed denial-of-service (DDoS) mitigation features. In this architecture, DDoS Protection helps defend the public IP address from DDoS attacks.

- [Azure Front Door](/azure/well-architected/service-guides/azure-front-door) is a content delivery network and global load balancer. In this architecture, Azure Front Door serves as the application entry point for web users.

- [Azure Virtual Network](/azure/well-architected/service-guides/virtual-network) is a network service that enables Azure resources to communicate with each other, the internet, and on-premises networks while providing segmentation and isolation. In this architecture, App Service and back-end components are only reachable through private connections in the virtual network.

- [Blob Storage](/azure/well-architected/service-guides/azure-blob-storage) is an object storage service optimized for large amounts of unstructured data. In this architecture, Blob Storage hosts all static content for the WordPress application.

- [Network security groups (NSGs)](/azure/virtual-network/network-security-groups-overview) use security rules to allow or deny network traffic by source or destination IP address, port, and protocol. In this architecture, NSG rules restrict traffic flow between subnets.

- [WordPress on App Service template](/azure/app-service/quickstart-wordpress) is a managed solution template for hosting WordPress on App Service. In this architecture, the template provides a preconfigured WordPress deployment that includes App Service and the other Azure services described in this section.

### Alternatives

Use [Azure Managed Redis](/azure/redis/overview) to host a key-value cache for WordPress performance optimization plugins. The cache can be shared across App Service web apps.

## Scenario details

This example scenario applies to small to medium-sized WordPress installations.

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

- Configure [automated backups](/azure/mysql/flexible-server/concepts-backup-restore) for Azure Database for MySQL. Define a retention period that aligns with your recovery point objectives (RPOs). Test your restoration process periodically to verify backup reliability.

- App Service provides built-in load balancing and health checks. These features help you maintain availability when an App Service web app fails.

- Azure Front Door can serve cached responses when the origin is temporarily unavailable. This capability limits availability loss but doesn't replace a complete availability solution.

- You can replicate Blob Storage to a paired region for data redundancy across multiple regions. For more information, see [Azure Storage redundancy](/azure/storage/common/storage-disaster-recovery-guidance).

- To increase Azure Database for MySQL availability, enable high availability. Same-zone high availability creates a standby server in the same availability zone as the primary server. For stronger fault isolation, use zone-redundant high availability, which places the standby server in a different availability zone. Use the General Purpose or Business Critical compute tier to enable high availability. For more information, see the [high availability options](/azure/mysql/flexible-server/concepts-high-availability) that meet your needs.

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

Consider the following recommendations when you deploy this solution:

- Use Azure Web Application Firewall on Azure Front Door to protect virtual network traffic that flows into the front-end application tier. For more information, see [Azure Web Application Firewall on Azure Front Door](/azure/web-application-firewall/afds/afds-overview).

- Use private endpoints for all back-end services, including Azure Database for MySQL and Blob Storage. Private endpoints keep traffic within the virtual network and prevent exposure to the public internet. For more information, see [Azure Private Link](/azure/private-link/private-link-overview).

- Block outbound internet traffic from the database tier.

- Block public access to private storage.

- Keep WordPress core, themes, and plugins updated to their latest versions to address known security vulnerabilities. Uninstall plugins and themes that you no longer need.

- Restrict access to the WordPress admin panel (`/wp-admin`) by creating [Azure Web Application Firewall custom rules](/azure/web-application-firewall/afds/waf-front-door-custom-rules) on Azure Front Door. Use the `RequestUri` match condition to match `/wp-admin` paths, combined with an IP address condition to allow access only from known IP address ranges. App Service access restrictions apply to the entire site, not individual URL paths, so they don't suit path-specific controls.

For more information about WordPress security, see [General WordPress security and performance tips](../../guide/infrastructure/wordpress-overview.yml#general-wordpress-security-and-performance-tips) and [Azure security documentation](/azure/security).

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

Review the following cost considerations when you deploy this solution:

- **Traffic expectations in GB per month:** Your traffic volume affects your cost the most. The traffic that you receive determines the number of App Service instances that you need and the price for outbound data transfer. Serving content through Azure Front Door can reduce outbound data transfer costs.

- **Hosted data:** Consider the data that you host in Blob Storage. Storage pricing depends on used capacity.

- **Write percentage:** Consider how much new data you write to your website and host in Storage. Determine whether you need new data. For multiregion deployments, the new data that you write to your website correlates with the data that replicates across your regions.

- **Static versus dynamic content:** Monitor your database storage performance and capacity to determine whether a lower-cost SKU supports your site. The database stores dynamic content, and Azure Front Door caches static content.

- **App Service optimization:** For more information about how to optimize App Service costs, see [Cost Optimization](/azure/well-architected/service-guides/app-service-web-apps#cost-optimization).

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

Consider the following recommendations when you deploy this solution:

- Enable [Application Insights](/azure/azure-monitor/app/app-insights-overview) to monitor application performance, availability, and usage patterns. Use the monitoring data to identify and resolve problems before they affect users.

- Use [deployment slots](/azure/app-service/deploy-staging-slots) in App Service to stage WordPress core upgrades. Deploy the new version to a staging slot and validate theme and plugin compatibility before you swap into production. Back up the Azure Database for MySQL instance before the swap because WordPress automatically applies schema migrations against the shared database when an admin signs in after an upgrade.

- Automate your infrastructure deployments by using Bicep or Terraform. Infrastructure as code (IaC) helps you maintain consistency across environments and rebuild environments reliably.

- Set up [Azure Monitor alerts](/azure/azure-monitor/alerts/alerts-overview) for key metrics, such as App Service CPU utilization, database connection counts, and response times. Use alerts to respond to operational problems before they affect users.

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

Consider the following recommendations when you deploy this solution:

- Enable the autoscale feature in App Service to automatically scale the number of instances. You can set an autoscale trigger to respond to customer demand or based on a schedule. For more information, see [Get started with autoscale in Azure](/azure/azure-monitor/autoscale/autoscale-get-started).

- Use [Azure Managed Redis](/azure/redis/overview) to cache Hypertext Preprocessor (PHP) session data and frequently accessed WordPress objects. Offload these items from the database to reduce query load and improve page load times.

- Configure Azure Front Door caching rules to serve static assets from edge locations. Cache at the edge to reduce latency for users who are geographically distant from the App Service region.

- Use the latest supported PHP version in App Service for performance and security improvements. Verify that your WordPress version and plugins are compatible before you upgrade.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Vaclav Jirovsky](https://www.linkedin.com/in/vaclavjirovsky) | Cloud Solution Architect

Other contributors:

- Adrian Calinescu | Senior Cloud Solution Architect
- [Andrew Cardy](https://www.linkedin.com/in/andrewcardy/) | Senior Software Engineer

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

Product documentation:

- [What is Azure Front Door?](/azure/frontdoor/front-door-overview)
- [What is Azure Web Application Firewall?](/azure/web-application-firewall/overview)
- [What is Blob Storage?](/azure/storage/blobs/storage-blobs-overview)
- [Azure Database for MySQL flexible server](/azure/mysql/flexible-server/overview)
- [What is Virtual Network?](/azure/virtual-network/virtual-networks-overview)
- [About Azure Key Vault](/azure/key-vault/general/overview)
- [Quickstart: Create a WordPress site](/azure/app-service/quickstart-wordpress)
- [What is DDoS Protection?](/azure/ddos-protection/ddos-protection-overview)

Microsoft training modules:

- [Implement Key Vault](/training/modules/implement-azure-key-vault)
- [Introduction to Virtual Network](/training/modules/introduction-to-azure-virtual-networks)

## Related resources

- [Ten design principles for Azure applications](../../guide/design-principles/index.md)
- [Scalable cloud applications and site reliability engineering](../../example-scenario/apps/scalable-apps-performance-modeling-site-reliability.yml)
