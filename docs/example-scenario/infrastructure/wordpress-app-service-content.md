This article describes a solution for small to medium-sized WordPress installations. The solution provides the scalability, reliability, and security of the Azure platform without the need for complex configuration or management. For solutions for larger or storage-intensive installations, see [WordPress hosting options on Azure](../../guide/infrastructure/wordpress-overview.yml#wordpress-hosting-options-on-azure).

## Architecture

:::image type="content" source="media/wordpress-app-service.png" alt-text="Architecture diagram of WordPress on Azure App Service. Azure Front Door routes traffic to web apps. Azure Database for MySQL stores dynamic content." lightbox="media/wordpress-app-service.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/azure-wordpress-app-service.vsdx) of this architecture.*

> [!NOTE]
> You can extend this solution by implementing tips and recommendations that aren't specific to any particular WordPress hosting method. For general tips for deploying a WordPress installation, see [WordPress on Azure](../../guide/infrastructure/wordpress-overview.yml).

### Dataflow

This scenario covers a scalable installation of [WordPress that runs on Azure App Service](/azure/app-service/quickstart-wordpress).

- Users access the front-end website through Azure Front Door with Azure Web Application Firewall enabled.
- Azure Front Door distributes requests across the App Service web apps that WordPress runs on. Azure Front Door retrieves any data that isn't cached from the WordPress web apps.
- The WordPress application uses a service endpoint to access a flexible server instance of Azure Database for MySQL. The WordPress application retrieves dynamic information from the database.
- Locally redundant high availability is enabled for Azure Database for MySQL via a standby server in the same availability zone.
- All static content is hosted in Azure Blob Storage.

### Components

- [App Service](/azure/well-architected/service-guides/app-service-web-apps) is a platform as a service (PaaS) offering that provides a framework for building, deploying, and scaling web apps. In this architecture, App Service hosts the WordPress application.

- [Azure Database for MySQL - flexible server](/azure/well-architected/service-guides/azure-db-mysql-cost-optimization) is a managed relational database service based on the open-source MySQL database engine. In this architecture, the database option stores WordPress data.

- [Azure DDoS Protection](/azure/ddos-protection/ddos-protection-overview) is a network security service that provides enhanced DDoS mitigation features. In this architecture, DDoS Protection helps defend against DDoS attacks against the public IP address.

- [Azure Front Door](/azure/well-architected/service-guides/azure-front-door) is a modern cloud content delivery network and global load balancer. In this architecture, Azure Front Door is the application entry point for web users.

- [Azure Virtual Network](/azure/well-architected/service-guides/virtual-network) is a networking service that provides a way for deployed resources to communicate with each other, the internet, and on-premises networks. In this solution, Azure App Service and backend components are only reachable through private connections in the virtual network.

- [Blob Storage](/azure/well-architected/service-guides/azure-blob-storage) is a scalable, optimized object storage service. In this architecture, Blob Storage hosts all static content for the WordPress application.

- [Network security groups (NSGs)](/azure/virtual-network/network-security-groups-overview) are security features that use a list of security rules to allow or deny inbound or outbound network traffic based on source or destination IP address, port, and protocol. In this architecture, NSG rules restrict traffic flow between the application components in the subnets.

- [WordPress on App Service template](/azure/app-service/quickstart-wordpress) is a managed solution template for hosting WordPress on App Service. In this architecture, the template provides a preconfigured WordPress deployment that includes App Service and the other Azure services described in this section.

### Alternatives

- You can use [Azure Managed Redis](/azure/redis/overview) to host a key-value cache for WordPress performance optimization plug-ins. The cache can be shared among the App Service web apps.
- Instead of Azure Front Door, you can use Content Delivery Network to deliver web content to users.

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
- When you use a content delivery network to cache all responses, you gain a small availability benefit. Specifically, when the origin doesn't respond, you can still access content. But caching doesn't provide a complete availability solution.
- You can replicate Blob Storage to a paired region for data redundancy across multiple regions. For more information, see [Azure Storage redundancy](/azure/storage/common/storage-disaster-recovery-guidance).
- To increase Azure Database for MySQL availability, enable same-zone high availability. This feature creates a standby server in the same availability zone as the primary server. You need to use the General Purpose or Business Critical compute tier to enable same-zone high availability. For more information, see the [high availability options](/azure/mysql/flexible-server/concepts-high-availability) that apply to your needs.

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

Consider the following recommendations when you deploy this solution:

- Use Azure Web Application Firewall on Azure Front Door to help protect the virtual network traffic that flows into the front-end application tier. For more information, see [Azure Web Application Firewall on Azure Front Door](/azure/web-application-firewall/afds/afds-overview).
- Don't allow outbound internet traffic to flow from the database tier.
- Don't allow public access to private storage.

For more information about WordPress security, see [General WordPress security and performance tips](../../guide/infrastructure/wordpress-overview.yml#general-wordpress-security-and-performance-tips) and [Azure security documentation][security].

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

Review the following cost considerations when you deploy this solution:

- **Traffic expectations (GB/month)**. Your traffic volume is the factor that has the greatest effect on your cost. The amount of traffic that you receive determines the number of App Service instances that you need and the price for outbound data transfer. The traffic volume also directly correlates with the amount of data that's provided by your content delivery network, where outbound data transfer costs are cheaper.
- **Amount of hosted data**. It's important to consider the amount of data that you host in Blob Storage. Storage pricing is based on used capacity.
- **Write percentage**. Consider how much new data you write to your website and host in Azure Storage. Determine whether the new data is needed. For multi-region deployments, the amount of new data that you write to your website correlates with the amount of data that's mirrored across your regions.
- **Static versus dynamic content**. Monitor your database storage performance and capacity to determine whether a cheaper SKU can support your site. The database stores dynamic content, and the content delivery network caches static content.
- **App Service optimization**. For general tips for optimizing App Service costs, see [Azure App Service and cost optimization](/azure/well-architected/services/compute/azure-app-service/cost-optimization).

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

This scenario hosts the WordPress front end in App Service. You should enable the autoscale feature to automatically scale the number of App Service instances. You can set an autoscale trigger to respond to customer demand. You can also set a trigger that's based on a defined schedule. For more information, see [Get started with autoscale in Azure](/azure/azure-monitor/autoscale/autoscale-get-started).

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

- [Load balance your web service traffic with Azure Front Door](/training/modules/create-first-azure-front-door)
- [Implement Azure Key Vault](/training/modules/implement-azure-key-vault)
- [Introduction to Azure Virtual Network](/training/modules/introduction-to-azure-virtual-networks)

## Related resources

- [Ten design principles for Azure applications](../../guide/design-principles/index.md)
- [Scalable cloud applications and site reliability engineering](../../example-scenario/apps/scalable-apps-performance-modeling-site-reliability.yml)

<!-- links -->

[security]: /azure/security
