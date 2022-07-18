This example scenario describes a [high-availability](https://docs.microsoft.com/azure/architecture/framework/resiliency/overview) solution for a jump server solution that runs on Azure. It uses an open-source tool called Apache Guacamole, which has functionality that's similar to that of [Azure Bastion](https://docs.microsoft.com/en-us/azure/bastion/bastion-overview).

Apache Guacamole is a clientless remote desktop gateway that supports standard protocols like Virtual Network Computing (VNC), Remote Desktop Protocol (RDP), and
Secure Shell (SSH). Because it's clientless, your users don't need to install anything. They just use a web browser to remotely access your virtual machines (VMs).

For more information about Guacamole and its internal components, see [Implementation and architecture](https://guacamole.apache.org/doc/gug/guacamole-architecture.html).

disclaimer 

To provide high availability, this solution:

* Uses [availability sets](/azure/virtual-machines/availability#availability-sets) for VMs. For service-level agreements (SLAs), see [SLAs for Virtual Machines](https://azure.microsoft.com/support/legal/sla/virtual-machines/v1_9).
* Uses Azure Database for MySQL, a high-availability, scalable, managed database. For SLAs, see [SLAs for Azure Database for MySQL](https://azure.microsoft.com/support/legal/sla/mysql/v1_2).

The solution also uses:
- Azure Load Balancer.
-  VMs with [NGINX as a reverse proxy](https://docs.nginx.com/nginx/admin-guide/web-server/reverse-proxy).
- [Tomcat as an application service](https://tomcat.apache.org).
- [Certbot](https://certbot.eff.org) to get free Secure Sockets Layer (SSL) certificates from [Let's Encrypt](https://letsencrypt.org/).

## Potential use cases

* Access your computers from any device. Because Guacamole requires only a reasonably fast standards-compliant browser, Guacamole runs on many devices, including mobile phones and tablets.
* Keep a computer in the cloud. Computers hosted on virtualized hardware are more resilient to failures. With so many companies now offering on-demand computing resources, Guacamole is a perfect way to access machines that are accessible only over the internet.
* Provide easy access to a group of people. You can use Guacamole to centralize access to a large group of machines and specify on a per-user basis which machines are accessible. Rather than remember a list of machines and credentials, users only need to  sign in to a central server and select one of the listed connections.
* Add HTML5 remote access to your existing infrastructure. Because Guacamole is an API and not just a web application, you can use the core components and libraries provided by the Guacamole project to add HTML5 remote access features to an existing application. You don't need to use the main Guacamole web application. You can write or integrate with your own fairly easily.

## Architecture

The architecture includes a public load balancer that receives external access requests and directs them to two VMs in the web layer. The web layer communicates with the data layer, where a MySQL database stores sign-in information, access events, and connections.

[![Diagram that shows a reference architecture for using Apache Guacamole on Azure.](media/azure-architecture-guacamole.png)](media/azure-architecture-guacamole.png#lightbox)

*Download a [Visio file](https://arch-center.azureedge.net/azure-architecture-guacamole.vsdx) of this architecture.*

## Dataflow

1. A user initiates a connection over the internet.
2. The connection from the user is established with the Azure public load balancer.
3. The Azure public load balancer receives external access and directs the traffic for the two VMs in the web tier.
4. The web tier communicates with Azure Database for MySQL in the data tier. This database stores sign-in information, access events, and connections.
5. The connection is established with the target clients via SSH, VNC, or RDP protocol.

## Components

- [Azure Load Balancer](https://azure.microsoft.com/services/load-balancer): A service for distributing load (incoming network traffic) across a group of back-end resources or servers.
- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network): The fundamental building block for your private network on Azure.
- [Public IP addresses](/azure/virtual-network/ip-services/public-ip-addresses): A service that allows internet resources to communicate inbound to Azure resources.
- [Network security groups](/azure/virtual-network/network-security-groups-overview): A service that filters network traffic traveling to and from Azure resources in an Azure virtual network.
- [Availability set](/azure/virtual-machines/availability-set-overview): A logical grouping of VMs that allows Azure to provide redundancy and availability.
- [Azure Database for MySQL](https://azure.microsoft.com/services/mysql): A fully managed MySQL database as a service.

## Alternatives

If you don't need as much control as the solution described here provides, you can use [Azure Bastion](https://azure.microsoft.com/services/azure-bastion), a fully managed service that offers high-security RDP and SSH access to VMs without any exposure through public IP addresses.

## Considerations

The following considerations apply to this scenario.

### Reliability

This solution's resiliency depends on the failure modes of individual services like Azure Virtual Machines, Azure Database for MySQL, and Azure Load Balancer. For more information, see [Resiliency checklist for specific Azure services](/azure/architecture/checklist/resiliency-per-service).

Consider the information [available here](/azure/architecture/framework/resiliency/design-checklist) when designing for reliability, and also this guide about [Azure Resiliency](/azure/availability-zones/overview).

Levarage the business continuity and disaster recovery guidance [published here](https://docs.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/design-area/management-business-continuity-disaster-recovery).

For Azure Virtual Machines (Web Tier) the usage of [availability sets](https://docs.microsoft.com/azure/virtual-machines/availability-set-overview#what-is-an-availability-set) ensures a logical grouping of VMs that allows Azure to understand how your application is built to provide for redundancy and availability. We recommended that two or more VMs are created within an availability set to provide for a highly available application and to meet the [99.95% Azure SLA](https://azure.microsoft.com/support/legal/sla/virtual-machines).

Regarding the Azure Database for MySQL (Data Tier), since it's a managed database as a service, its architecture is optimized for built-in high availability with [99.99% availability](https://docs.microsoft.com/en-us/azure/mysql/concepts-high-availability)

### Security

The usage of [Azure Web Application Firewall](https://docs.microsoft.com/azure/web-application-firewall/overview) helps protect your application from common vulnerabilities. This Application Gateway option uses Open Web Application Security Project (OWASP) rules to prevent attacks like cross-site scripting, session hijacks, and other exploits. You could consider adding this to this solution.

Make sure to leverage the [Azure Network Security Groups](https://docs.microsoft.com/azure/virtual-network/network-security-groups-overview) to filter network traffic to and from Azure resources in an Azure virtual network as an additional protection layer.

Additionally, consider the [Private Link for Azure Database for MySQL](https://docs.microsoft.com/azure/mysql/single-server/concepts-data-access-security-private-link). Private Link allows you to connect to PaaS services in Azure via a private endpoint. Azure Private Link essentially brings Azure services inside your private Virtual Network (VNet). The PaaS resources can be accessed using the private IP address just like any other resource in the VNet.

Follow [these security guidelines](https://docs.microsoft.com/azure/security/fundamentals/overview) when you implement this solution.

### Cost optimization

To better understand the cost of running this scenario on Azure, use the [pricing calculator](https://azure.microsoft.com/pricing/calculator).

* [Linux Virtual Machines Pricing](https://azure.microsoft.compricing/details/virtual-machines/linux/)
* [Azure Database for MySQL pricing](https://azure.microsoft.com/pricing/details/mysql/server/)
* [Load Balancer pricing](https://azure.microsoft.com/pricing/details/load-balancer/)
* [Azure Reserved Virtual Machine Instances](https://azure.microsoft.com/pricing/reserved-vm-instances/)

### Operational excellence

Operational excellence applies reliability, predictability, and automated operations process to your architecture to keep an application running in production. Deployments must be reliable and predictable. Automated deployments reduce the chance of human error. 

Leverage the benefits of provisioning resources with [Infrastructure as Code](https://docs.microsoft.com/devops/deliver/what-is-infrastructure-as-code), build, and release with [continuous integration](https://docs.microsoft.com/devops/develop/what-is-continuous-integration) and [continuous delivery](https://docs.microsoft.com/devops/deliver/what-is-continuous-delivery) (CI/CD) pipelines and use automated testing methods.

Read more about the operational excellence [design principles here](https://docs.microsoft.com/azure/architecture/framework/devops/principles).

### Performance Efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. To accomplish this, you should consider the usage of [Azure Virtual Machine Scale Sets](https://docs.microsoft.com/azure/virtual-machine-scale-sets/overview) which allows you to create and manage a group of load balanced VMs. The number of VM instances can automatically increase or decrease in response to demand or a defined schedule.

## Deploy this scenario

Is recommend using the Bash environment in [Azure Cloud Shell](https://docs.microsoft.com/en-us/azure/cloud-shell/quickstart). If you prefer to run on your own Windows, Linux, or macOS, [install](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) the Azure CLI to run referenced commands.

The steps to deploy this scenario [are available here](https://github.com/Azure/Deploying-Apache-Guacamole-on-Azure).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors: 

 - [Ricardo Macedo Martins](https://www.linkedin.com/in/ricmmartins) | Sr. Customer Engineer
 

## Next steps

* [Apache Guacamole oficial docummentation](https://guacamole.apache.org/doc/gug/administration.html)
 
## Related resources

* [Azure Bastion](https://azure.microsoft.com/en-us/services/azure-bastion/)
* [Azure Bastion Documentation](https://docs.microsoft.com/en-us/azure/bastion/bastion-overview)
  
