This example scenario discusses a [highly available](https://docs.microsoft.com/azure/architecture/framework/resiliency/overview) solution for a jump server solution running on Azure using an open-source tool called Apache Guacamole, which similar functionalities from [Azure Bastion](https://docs.microsoft.com/en-us/azure/bastion/bastion-overview)

Apache Guacamole is a clientless remote desktop gateway that supports standard protocols like VNC, RDP, and SSH. Clientless means your clients don't need to install anything but just use a web browser to remotely access your fleet of VMs.

For more information about Guacamole and the internal components, visit its [architecture page](https://guacamole.apache.org/doc/gug/guacamole-architecture.html).

To offer high availability, this solution:

* Make use of [Availability Sets](https://docs.microsoft.com/en-us/azure/virtual-machines/availability#availability-sets) for Virtual Machines ensuring 99.95% of SLA
* Use Azure Database for MySQL, a highly available, scalable, managed database as service guarantees a [99.99% SLA](https://docs.microsoft.com/en-us/azure/mysql/concepts-high-availability).

The environment to be built will leverage the usage of Azure Database for MySQL (DBaaS), Azure Load Balancer, and Virtual Machines with [Nginx as Reverse Proxy](https://docs.nginx.com/nginx/admin-guide/web-server/reverse-proxy/), [Tomcat as Application Service](https://tomcat.apache.org/), and the [Certbot](https://certbot.eff.org/) to get free SSL certificates from [Let's Encrypt](https://letsencrypt.org/).

## Potential use cases

* Access your computers from any device: As Guacamole requires only a reasonably-fast, standards-compliant browser, Guacamole will run on many devices, including mobile phones and tablets.
* Keep a computer in the “cloud”: Computers hosted on virtualized hardware are more resilient to failures, and with so many companies now offering on-demand computing resources, Guacamole is a perfect way to access several machines that are only accessible over the internet.
* Provide easy access to a group of people: Guacamole allows you to centralize access to a large group of machines, and specify on a per-user basis which machines are accessible. Rather than remember a list of machines and credentials, users need only log into a central server and click on one of the connections listed.
* Adding HTML5 remote access to your existing infrastructure: As Guacamole is an API, not just a web application, the core components and libraries provided by the Guacamole project can be used to add HTML5 remote access features to an existing application. You need not use the main Guacamole web application; you can write (or integrate with) your own rather easily.

## Architecture

The drawing below refers to the suggested architecture. This architecture includes a public load balancer that receives external accesses and directs them to two virtual machines in the web layer. The web layer communicates with the data layer where we have a MySQL database responsible for storing login information, accesses, and connections.

[![Diagram of the reference architecture Apache Guacamole on Azure](media/azure-architecture-guacamole.png)](media/azure-architecture-guacamole.png#lightbox)

Download a Visio file of this architecture

## Dataflow

1. Users start the connection over the Internet
2. The connection from the user is established with the Azure Public Load Balancer 
3. The Azure Public Load Balancer receives external access and directs the traffic for the two virtual machines in the Web Tier
4. The Web Tier communicates with Azure Database for MySQL in the Data Tier which is responsible for storing login information, accesses, and connections
5. The connection is established with the target clients through SSH, VNC, or RDP protocol

## Components

- [Azure Load Balancer](https://azure.microsoft.com/services/load-balancer): A service to distribute load (incoming network traffic) across a group of backend resources or servers
- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network): The fundamental building block for your private network in Azure
- [Public IP Addresses](https://docs.microsoft.com/en-us/azure/virtual-network/ip-services/public-ip-addresses): A service to allow Internet resources to communicate inbound to Azure resources
- [Network Security Group](https://docs.microsoft.com/azure/virtual-network/network-security-groups-overview): A service to filter network traffic to and from Azure resources in an Azure virtual network
- [Azure Availability Set](https://docs.microsoft.com/azure/virtual-machines/availability-set-overview): A logical grouping of VMs that allows Azure to understand how your application is built to provide for redundancy and availability
- [Azure Database for MySQL](https://azure.microsoft.com/en-us/services/mysql/): A fully managed MySQL Database as a Service 

## Alternatives

Customers who doesn't need this high level of control using their own solution can implement a solution similar to this leveraging the usage of [Azure Bastion](https://azure.microsoft.com/services/azure-bastion/), a fully managed service that provides secure and seamless Remote Desktop Protocol (RDP) and Secure Shell Protocol (SSH) access to VMs without any exposure through public IP addresses. 

## Considerations

The following considerations apply to this scenario.

### Reliability

The solution's resiliency depends on the failure modes of individual services like Virtual Machines, Azure Database for MySQL, and Azure Load Balancer Azure. For more information, see [Resiliency checklist](https://docs.microsoft.com/azure/architecture/checklist/resiliency-per-service) for specific Azure services.

Consider the information [available here](https://docs.microsoft.com/azure/architecture/framework/resiliency/design-checklist) when designing for reliability, and also this guide about [Azure Resiliency](https://docs.microsoft.com/en-us/azure/availability-zones/overview).

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
  
