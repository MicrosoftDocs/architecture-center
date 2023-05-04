<!-- cSpell:ignore wordpress -->

WordPress is a versatile and popular content management system, used for creating websites of all sizes and purposes. From small personal blogs to large-scale corporate sites and e-commerce stores, WordPress offers a range of functionalities and customizations to suit different needs. However, due to its varying sizes and use cases, WordPress also has different hosting requirements, depending on factors such as traffic volume and storage needs.

This section will cover deploying WordPress on Azure and provide guidance on what to consider and implement to ensure a secure, scalable, and cost-effective installation.

## General WordPress security&performance tips

WordPress is a popular target for hackers, and websites running on the platform can be vulnerable to security threats such as malware and phishing attacks. To address these risks, the following tips can help to create a more secure and better-performing WordPress installation.

Regardless of the hosting architecture, whether it's VM, AppService, or any other, these tips are universally applicable.

### Use Web Application Firewall

Using a web application firewall (WAF) in front of WordPress installation is a crucial step in securing the website against common web-based attacks. A WAF acts as a filter between the website and the internet, monitoring incoming traffic and blocking malicious requests that can exploit vulnerabilities in your website's code. It can protect your website from a range of attacks, including SQL injections, cross-site scripting (XSS), and cross-site request forgery (CSRF).

Azure Front Door is Microsoft’s modern cloud Content Delivery Network (CDN) that provides fast, reliable, and secure access between your users and your applications’ static and dynamic web content across the globe. Azure Web Application Firewall (WAF) on Azure Front Door provides centralized protection for your web applications. WAF defends your web services against common exploits and vulnerabilities.

### Remove unused plugins and themes

Removing unused plugins and themes is an important step in keeping your WordPress website secure and optimizing its performance. Even if you're not actively using a plugin or theme, it can still pose a security risk by providing an entry point for hackers to exploit vulnerabilities in outdated or unmaintained code. Additionally, having too many plugins and themes installed on your website can slow down its performance by increasing the load time and server resource usage. Therefore, it's best practice to remove any unused plugins and themes to reduce the attack surface and improve website performance.

### Offload static content away from PHP processor

Offloading static content, such as images, videos, and CSS files, away from the PHP processor is essential for optimizing website performance and reducing server load. When a user visits a website, the server processes the PHP code and generates HTML content dynamically, which can be resource-intensive. However, static assets like images and CSS files don't change frequently and can be served directly from the server's file system or a content delivery network (CDN) without the need for PHP processing. By offloading these assets, you can reduce the load on the server's CPU and RAM, resulting in faster page load times, improved website performance, and better user experience.

Additionally, serving static assets from a [Azure Front Door](/azure/frontdoor/front-door-overview) allows users to access them from servers closer to their geographic location, further reducing latency and improving website speed. In summary, offloading static content away from the PHP processor is a crucial step in optimizing website performance and reducing server load.

> [!NOTE]
> To lock an origin with Azure Front Door via Private Endpoint is required Front Door in SKU Premium. [Learn more about origin via Private Link](/azure/frontdoor/private-link)

#### CDN cache invalidation

One of the challenges that arises when caching on a CDN side with large WordPress installations is cache invalidation. Whenever a new event occurs, such as publishing a new article, updating an existing page, or adding a new comment, the cache in the CDN for the affected page must be invalidated. This requires implementing some logic to discover all affected URLs by the change, including dynamically generated pages such as categories and archives, and invalidate them in the CDN cache. Depending on the installed theme and plugins, even a minor change may affect every page.

An easy way to implement some discovery logic could be through a plugin that enables manual triggering of cache invalidation for all URLs. However, this could cause traffic peaks to WordPress when all URLs are invalidated at once. [Example implementation on GitHub](https://github.com/vjirovsky/pr-crisis-wp-website/blob/master/wordpress/wp-content/plugins/azure-invalidate-cdn/plugin.php)

### Enable Two-Factor Authentication (2FA)

One way to enable 2FA for your WordPress installation is through the use of a plugin such a [MiniOrange authentication plugin](https://wordpress.org/plugins/miniorange-2-factor-authentication/). This plugin allows, among other methods, to use the Microsoft Authenticator as provider for 2FA method before gaining access to your WordPress site. This can greatly increase the security of your installation and help protect against unauthorized access or attacks.

### Disable XML-RPC access

XML-RPC is a remote protocol that allows third-party applications to interact with your website's server. However, this protocol is also a common target for hackers who use it to launch brute force attacks or exploit vulnerabilities in the CMS.

One way to disable XML-RPC is by setting up a deny rule for URL `/xmlrpc.php` in the Azure Front Door component.

### Restrict access to administration

By default, the WordPress administration panel is accessible to anyone with the correct URL `/wp-login.php` or `/wp-admin` and login credentials. This means that hackers and other malicious actors can attempt to guess your login details, perform a session hijacking, launch brute force attacks, or exploit some vulnerabilities in the WordPress to gain access.
 Web Application Firewall can help to prevent some these attack, but many administrators prefers to restrict access to WordPress administration on network level.

An example, how to achieve this restriction, could be blocking any access to private URLs on Azure Front Door component and introduce a new internal access via Internal Application Gateway/Load Balancer accessible from private network via Hub&spoke network topology. Internal Application Gateway supports Web Application Firewall rules (as well as Azure Front Door) providing protection to WordPress installation also for internal access. In case the risk of attack from internal access is acceptable, there could be used Internal Load Balancer (*OSI layer 4*).

[![Example architecture diagram describing blocking public access to administration and introducing an internal access via VPN in Hub&spoke topology](media/wordpress-architecture-restrict-ntw.png)](media/wordpress-architecture-restrict-ntw.png#lightbox)

In some cases, certain WordPress plugins may require that the URL `/wp-admin/admin-ajax.php` be publicly accessible and removed from this deny rule.

### Store secrets in Azure Key Vault

To ensure the security of WordPress deployments on Azure, it is recommended to store secrets such as database passwords and SSL certificates in Azure Key Vault. Azure Key Vault is a cloud-based service that provides secure storage and management of cryptographic keys, certificates, and secrets.

By storing secrets in Key Vault, they can be securely accessed by authorized applications and services without the need to store them in plain text within the WordPress container image or in application code.

## Hosting challenges of WordPress

WordPress application architecture gives rise to several hosting challenges, including:

- **Scalability** -  a hosting architecture must be capable of scaling out during peak traffic periods.
- **Read&Write-Many storage** - by default, WordPress stores all static assets, plugin, and theme source codes in the `/wp-content/` directory, which must be readable and writable from all nodes during scale-out.
- **IOPS storage class** - WordPress consists of 1000+ tiny `.php` files that are referenced, loaded, and executed by PHP processor during incoming requests. Loading numerous small files can result in overhead and is often slower than loading one file with the same size (depending on the selected protocol).
- **Cache invalidation** - when a new activity occurs in the application, such as publishing a new article, the cache must be invalidated across all nodes.
- **Building cache time** - for the first user of a given node, the response time may be slower until the cache is built.

## WordPress hosting options on Azure

WordPress can be run on a few different Azure services - from managed PaaS service WordPress on App Service, through Azure Kubernetes Service (AKS) to Virtual Machine (VM). The size of the installation is a important factor for decision. For small to medium installations, maanged App Service can be a suitable and cost-effective option. However, for larger installations you should consider AKS or VM hosting.

### WordPress on App Service

[WordPress on App Service (on Linux)](/azure/app-service/quickstart-wordpress) is a fully managed solution provided by Microsoft, designed to help you quickly and easily deploy a WordPress installation. This solution is ideal for small to medium-sized WordPress installations, as it provides the scalability, reliability, and security of the Azure platform without the need for complex configuration or management. It automatically takes care of tasks such as automatic updates, backups, and monitoring to ensure that your site is always available.

[More details about this deployment architecture](/azure/architecture/example-scenario/infrastructure/wordpress-appservice)

### Storage-intensive solutions

For large WordPress installations, it may become necessary to use a storage solution with a higher IOPS class and low latency, in order to accommodate the storage requirements. It is important to select a persistent storage solution that offers a Read&Write-Many mode, as the storage will be shared between all nodes.

One of the storage solution meeting these requirements is [Azure NetApp Files](/azure/azure-netapp-files/). In addition to these capabilities, Also, Azure NetApp provides additional features such as data protection, backup and restore, cross-region replication and disaster recovery.

In container way of deployment, the WordPress could be deployed within **Azure Kubernetes Service (AKS)** and connected with Azure NetApp Files storage via Kubernetes CSI driver. [More details about AKS deployment architecture](/azure/architecture/example-scenario/infrastructure/wordpress-container)

Another way to host WordPress with such advanced storage solution like Azure NetApp Files is hosting on **Virtual Machines (VM)** and mount storage via NFS protocol. [More details about VM deployment architecture](/azure/architecture/example-scenario/infrastructure/wordpress-iaas)

### Immutable WordPress container

Alternative approach to traditional hosting methods is to deploy WordPress into an immutable container, with both advantages and limitations. Source code and all resources within immutable containers are fixed and cannot be modified after deployment, so all changes need to be made in a new version of the container image (including updating WordPress core, installing a new plugin, etc.). While this approach ensures consistency and simplifies rollbacks, it brings some overhead about building deployment pipeline for all changes. Additionally, immutable containers may have limitations on persistent storage options, which could require develop a solution for handling media files and other data. Despite these limitations, immutable container deployments can offer benefits in terms of security, scalability, and portability.

An immutable containerized version of WordPress can be deployed and hosted on a variety of platforms, including Azure Container App, Azure Kubernetes Service, and Azure App Service with custom container image.

The container image can be hosted in Azure Container Registry.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

[Vaclav Jirovsky](https://www.linkedin.com/in/vaclavjirovsky) | Cloud Solution Architect

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


Microsoft Learn modules:

- [Introduction to Azure Front Door](/training/modules/intro-to-azure-front-door)
- [Configure Azure Load Balancer](/training/modules/configure-azure-load-balancer)
- [Implement Azure Key Vault](/training/modules/implement-azure-key-vault)
- [Introduction to Azure Virtual Networks](/training/modules/introduction-to-azure-virtual-networks)

## Related resources

- [Ten design principles for Azure applications](../../guide/design-principles/index.md)
- [Scalable cloud applications and site reliability engineering](../../example-scenario/apps/scalable-apps-performance-modeling-site-reliability.yml)

<!-- links -->

[docs-nsg]: /azure/virtual-network/security-overview
[security]: /azure/security
