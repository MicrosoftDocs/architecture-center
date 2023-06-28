<!-- cSpell:ignore wordpress -->

WordPress is a versatile and popular content management system that's used to create websites of all sizes and purposes. From small personal blogs to large-scale corporate sites and e-commerce stores, WordPress offers a range of functionalities and customizations to suit different needs. However, due to its installations' varying sizes and use cases, WordPress also has unique hosting requirements that depend on factors such as traffic volume and storage needs.

This article covers WordPress deployments on Azure. It provides guidance on what to consider and implement to help ensure a secure, scalable, and cost-effective installation.

## General WordPress security and performance tips

Because of its overwhelming popularity, WordPress is a target for hackers. Websites that run on the platform can be vulnerable to security threats such as malware and phishing attacks. The following tips can help you address these risks by creating a more secure and better-performing WordPress installation.

Whether you use a virtual machine (VM) or Azure App Service for your hosting architecture or some other solution, these tips are universally applicable.

### Use Azure Web Application Firewall

Web Application Firewall helps secure your website against common web-based attacks. It acts as a filter between your website and the internet. In this capacity, Web Application Firewall monitors incoming traffic and blocks malicious requests that can exploit vulnerabilities in your website's code. Web Application Firewall helps protect your website from a range of attacks, including SQL injections, cross-site scripting (XSS), and cross-site request forgery (CSRF).

You should use Web Application Firewall on Azure Front Door to get centralized protection for your web applications. Azure Front Door is a content delivery network that helps provide users across the globe with fast, reliable, and secure access to your applications' static and dynamic web content. Deploying Web Application Firewall on Azure Front Door helps to defend your web services against common exploits and vulnerabilities.

### Remove unused plug-ins and themes

You should remove unused plug-ins and themes from your WordPress installation. This step is important for keeping your WordPress website secure and optimizing its performance. Even a plug-in or theme that you don't actively use can pose a security risk by providing an entry point for hackers to exploit vulnerabilities in outdated or unmaintained code. Also, having lots of plug-ins and themes installed on your website can slow down its performance by increasing load time and server resource usage.

### Offload static content away from the PHP processor

To reduce the load on your PHP processor, you should offload static content, such as images, videos, and CSS files. Offloading static content helps to optimize website performance and reduce server load. When a user visits a website, the server processes PHP code and generates HTML content dynamically. This process is resource intensive. However, static content doesn't change frequently, so you can serve static content directly from a server file system or a content delivery network. By offloading these assets, you can reduce the load on your server's CPU and RAM. This configuration results in faster page load times, improved website performance, and a better user experience.

There are also other benefits to serving static resources from a content delivery network service such as [Azure Front Door](/azure/frontdoor/front-door-overview). For instance, when you offload static content, you can reduce latency and increase website speed by placing servers close to users' geographic locations.

> [!NOTE]
> To secure an origin with Azure Front Door by using a private endpoint, you need to use the Premium SKU of Azure Front Door. For more information, see [Secure your origin with Private Link](/azure/frontdoor/private-link).

#### Content delivery network cache invalidation

For large WordPress installations that use a content delivery network, such as Azure Front Door or Azure Content Delivery Network, you need to implement cache invalidation logic. Whenever a new event occurs, you need to invalidate the cache in the content delivery network for the affected page. Examples of events include publishing a new article, updating an existing page, and adding a comment. The invalidation logic needs to locate all the URLs that the change affects. Specifically, the logic needs to find and invalidate dynamically generated pages, such as categories and archives, in the content delivery network cache. With some installed themes and plug-ins, even a minor change can affect every page.

An easy way to implement discovery logic is to use a plug-in that enables manual triggering of cache invalidation for all URLs. But invalidating all URLs at once can cause traffic to spike at your WordPress site. For an example of cache invalidation logic for Content Delivery Network, see the [Flush Azure cache and deploy hook](https://github.com/vjirovsky/pr-crisis-wp-website/blob/master/wordpress/wp-content/plugins/azure-invalidate-cdn/plugin.php) implementation on GitHub.

### Enable two-factor authentication

Two-factor authentication increases the security of your installation and helps protect your admin accounts from unauthorized access and attacks. To take advantage of two-factor authentication, you can use a plug-in such as the [miniOrange authentication plug-in](https://wordpress.org/plugins/miniorange-2-factor-authentication). Among other features, this plug-in provides a way for you to configure Microsoft Authenticator as a two-factor authentication method for users who sign in to your WordPress site as administrators.

### Disable XML-RPC access

XML-RPC is a remote protocol that provides a way for third-party applications to interact with your website's server. However, this protocol is also a common target for hackers, who use it to launch brute force attacks or exploit vulnerabilities in your content management system. If you use Azure Front Door, you can disable XML-RPC by setting up a deny rule for URLs with the format `/xmlrpc.php`.

### Restrict access to the administration panel

By default, your WordPress administration panel is accessible to anyone with your account credentials and the correct URL, which has the format `/wp-login.php` or `/wp-admin`. As a result, hackers and other malicious actors can attempt to guess your credentials, perform a session hijacking, launch brute force attacks, or exploit vulnerabilities in WordPress to gain access.

Web Application Firewall can help prevent some attacks, but many administrators prefer to restrict access to the WordPress administration panel on the network level.

For example, you can block access to private URLs in Azure Front Door. You can then use Azure Application Gateway to provide internal access from a private network that uses a hub-and-spoke topology. Internal instances of Application Gateway support Web Application Firewall rules and Azure Front Door rules. These rules help protect your WordPress installation from internal attacks. If you can tolerate the risk of an internal attack, you can use an internal instance of Azure Load Balancer instead of Application Gateway. Load Balancer operates at layer four of the Open Systems Interconnection (OSI) model.

:::image type="content" source="media/wordpress-architecture-restrict-network-level.png" alt-text="Architecture diagram that shows blocked public access to a WordPress administration panel. A VPN in a hub-and-spoke topology provides internal access." lightbox="media/wordpress-architecture-restrict-network-level.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/azure-wordpress.vsdx) of this architecture.*

Certain WordPress plug-ins require URLs with the format `/wp-admin/admin-ajax.php` to be publicly accessible and removed from this deny rule.

### Store secrets in Azure Key Vault

To help ensure the security of WordPress deployments on Azure, we recommend that you store secrets, such as database passwords and TLS or SSL certificates, in Key Vault. This cloud-based service helps provide secure storage and management of cryptographic keys, certificates, and secrets.

Key Vault helps your authorized applications and services to securely access secrets. You don't need to store them in plain text within your WordPress container image or in application code.

### Tune performance

To optimize WordPress performance, you should tune various settings and use plug-ins. The following plug-ins can be useful for debugging WordPress installations:

- [Query Monitor](https://wordpress.org/plugins/query-monitor) provides a breakdown of the time that's spent on each SQL query and other actions. Examples include PHP errors, hooks and actions, block editor blocks, enqueued scripts and stylesheets, and HTTP API calls.
- [Laps](https://github.com/Rarst/laps) provides a breakdown of how time is spent on WordPress page loads.

## Hosting challenges of WordPress

With the WordPress application architecture, there are several hosting challenges, including:

- **Scalability**. A hosting architecture must be able to scale out during peak traffic periods.
- **ReadWriteMany (RWX) storage**. By default, WordPress stores all static assets, plug-ins, and theme source code in the `/wp-content/` directory. During a scale-out, all nodes must be able to read from and write to that directory.
- **The input/output operations per second (IOPS) storage class**. WordPress consists of over 1,000 tiny .php files that the PHP processor references, loads, and runs during incoming requests. With some protocols, loading numerous small files can increase overhead. Overall performance is then slower than loading one file with the same total size. As a result, the storage solution needs to support high IOPS.
- **Cache invalidation**. When there's new activity in the application, such as when you publish a new article, you need to invalidate the cache across all nodes.
- **The time to build the cache**. For the first user of a given node, the response time can be slow until the cache is built.

## WordPress hosting options on Azure

WordPress can run on App Service, Azure Kubernetes Service (AKS), and Azure Virtual Machines. The size of the installation is an important factor in the host that you select. For small to medium installations, App Service is a cost-effective option. However, for larger installations, you should consider AKS or VM hosting.

### WordPress on App Service

Microsoft provides a fully managed solution for running WordPress on App Service on Linux VMs. The solution:

- Is designed to help you quickly and easily deploy a WordPress installation.
- Is ideal for small to medium-sized WordPress installations.
- Provides the scalability, reliability, and security of the Azure platform without the need for complex configuration or management.
- Performs automatic updates, backups, and monitoring to help ensure that your site is always available.

For more information, see the following resources:

- [Create a WordPress site](/azure/app-service/quickstart-wordpress)
- [WordPress on App Service](../../example-scenario/wordpress-app-service.yml)

### Storage-intensive workloads

Large WordPress installations can be storage intensive. In these scenarios, you should use a storage solution with a high-IOPS class and low latency. We recommend [Azure NetApp Files](/azure/azure-netapp-files). Azure NetApp Files can support storage-intensive WordPress deployments. It also provides extra features such as data protection, backup and restore, cross-region replication, and disaster recovery.

For a container deployment of WordPress, you should use AKS. With Azure NetApp Files, implement storage via a Kubernetes Container Storage Interface (CSI) driver. Azure NetApp Files offers a `ReadWriteMany` mode so that all the nodes can read from and write to the same storage. For more information, see [AKS WordPress architecture](../../example-scenario/infrastructure/wordpress-container.yml).

For a large WordPress installation that runs on VMs, you should mount Azure NetApp Files via the network file system (NFS) protocol. For more information, see [WordPress on VMs](../../example-scenario/infrastructure/wordpress-iaas.yml).

### Immutable WordPress container

An alternative approach to traditional hosting methods is to deploy WordPress into an immutable container. This approach has advantages and disadvantages. The source code and all resources within immutable containers are fixed and can't be modified after deployment. You need to make all changes, including new plug-in installations or WordPress core updating, in a new version of the container image. While this approach helps ensure consistency and simplifies rollbacks, you have to build a deployment pipeline to make changes. Also, immutable containers can be limited in the persistent storage options that they offer. You might need to develop a solution for handling media files and other data. Despite these limitations, immutable container deployments offer benefits in terms of security, scalability, and portability.

You can deploy an immutable containerized version of WordPress on various platforms, including Azure Container Apps, AKS, and App Service with a custom container image. You can host the container image in Azure Container Registry.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Vaclav Jirovsky](https://www.linkedin.com/in/vaclavjirovsky) | Cloud Solution Architect

Other contributors:

- Adrian Calinescu | Sr. Cloud Solution Architect

## Next steps

Product documentation:

- [What is Azure Front Door?](/azure/frontdoor/front-door-overview)
- [What is Azure Web Application Firewall?](/azure/web-application-firewall/overview)
- [About Azure Key Vault](/azure/key-vault/general/overview)
- [What is Azure Load Balancer?](/azure/load-balancer/load-balancer-overview)
- [What is Azure Application Gateway?](/azure/application-gateway/overview)
- [What is Azure Virtual Network?](/azure/virtual-network/virtual-networks-overview)
- [What is Azure Firewall?](/azure/firewall/overview)
- [What is VPN Gateway?](/azure/vpn-gateway/vpn-gateway-about-vpngateways)

Training modules:

- [Introduction to Azure Front Door](/training/modules/intro-to-azure-front-door)
- [Configure Azure Load Balancer](/training/modules/configure-azure-load-balancer)
- [Implement Azure Key Vault](/training/modules/implement-azure-key-vault)
- [Introduction to Azure Virtual Networks](/training/modules/introduction-to-azure-virtual-networks)

## Related resources

- [Ten design principles for Azure applications](../design-principles/index.md)
- [Scalable cloud applications and site reliability engineering](../../example-scenario/apps/scalable-apps-performance-modeling-site-reliability.yml)
