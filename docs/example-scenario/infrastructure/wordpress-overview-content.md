<!-- cSpell:ignore wordpress -->

WordPress is a free, open-source content management system that powers over 40% of all websites on the internet. It allows users to create and manage websites without requiring advanced technical skills or coding knowledge. WordPress is highly customizable and offers a vast library of themes and plugins to extend its functionality. It is also supported by a large community of developers and users who contribute to its ongoing development and improvement. With its ease of use and flexibility, WordPress has become a popular choice for businesses and individuals alike who want to build a website quickly and easily. 

This section will cover deploying WordPress on Azure and provide guidance on what to consider and implement to ensure a secure, scalable, and cost-effective installation.

## General WordPress security&performance tips

WordPress is a popular target for hackers, and websites running on the platform can be vulnerable to security threats such as malware and phishing attacks. To address these risks, the following tips can help to create a more secure and better-performing WordPress installation.

Regardless of the hosting architecture, whether it's VM, AppService, or any other, these tips are universally applicable.

###  Use Web Application Firewall

Using a web application firewall (WAF) in front of WordPress installation is a crucial step in securing the website against common web-based attacks. A WAF acts as a filter between the website and the internet, monitoring incoming traffic and blocking malicious requests that can exploit vulnerabilities in your website's code. It can protect your website from a range of attacks, including SQL injections, cross-site scripting (XSS), and cross-site request forgery (CSRF). 

Azure Front Door is Microsoft’s modern cloud Content Delivery Network (CDN) that provides fast, reliable, and secure access between your users and your applications’ static and dynamic web content across the globe. Azure Web Application Firewall (WAF) on Azure Front Door provides centralized protection for your web applications. WAF defends your web services against common exploits and vulnerabilities. It keeps your service highly available for your users and helps you meet compliance requirements.

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


## Hosting challenges of WordPress

WordPress application architecture gives rise to several hosting challenges, including:

- **Scalability** -  a hosting architecture must be capable of scaling out during peak traffic periods.
- **Read&Write-Many storage** - by default, WordPress stores all static assets, plugin, and theme source codes in the `/wp-content/` directory, which must be readable and writable from all nodes during scale-out.
- **IOPS storage class** - WordPress consists of 1000+ tiny `.php` files that are referenced, loaded, and executed during requests. Loading numerous small files can result in overhead and is often slower than loading one file with the same size (depending on the selected protocol).
- **Cache invalidation** - when a new activity occurs in the application, such as publishing a new article, the cache must be invalidated across all nodes.
- **Slow response** - for the first user of a given node, the response time may be slower until the cache is built.

## WordPress hosting options on Azure
TODO: some decision tree

### WP AppService

### Containers

### IaaS options


### Immutable WordPress container


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
