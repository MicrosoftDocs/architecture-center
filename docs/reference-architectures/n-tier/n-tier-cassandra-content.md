This reference architecture shows how to deploy virtual machines (VMs) and a virtual network configured for an [N-tier](../../guide/architecture-styles/n-tier.yml) application, using Apache Cassandra on Linux for the data tier.

## Architecture

[![Diagram that shows the N-tier architecture using Microsoft Azure.](./images/n-tier-cassandra.svg)](./images/n-tier-cassandra.svg)

*Download a [Visio file][visio-download] of this architecture.*

### Workflow

The architecture has the following components.

#### General

- **Resource group**. [Resource groups][resource-manager-overview] are used to group Azure resources so they can be managed by lifetime, owner, or other criteria.

- **Availability zones**. [Availability zones](/azure/availability-zones/az-overview) are physical locations within an Azure region. Each zone consists of one or more datacenters with independent power, cooling, and networking. By placing VMs across zones, the application becomes resilient to failures within a zone.

#### Networking and load balancing

- **Virtual network and subnets**. Every Azure VM is deployed into a virtual network that can be segmented into subnets. Create a separate subnet for each tier.

- **Application gateway**. [Application Gateway](/azure/application-gateway/) is a layer 7 load balancer. In this architecture, it routes HTTP requests to the web front end. Application Gateway also provides a [web application firewall](/azure/application-gateway/waf-overview) (WAF) that protects the application from common exploits and vulnerabilities.

- **Load balancers**. Use [Azure Standard Load Balancer][load-balancer] to distribute network traffic from the web tier to the business tier.

- **Network security groups** (NSGs). Use [NSGs][nsg] to restrict network traffic within the virtual network. For example, in the three-tier architecture shown here, the database tier does not accept traffic from the web front end, only from the business tier and the management subnet.

- **DDoS Protection**. Although the Azure platform provides basic protection against distributed denial of service (DDoS) attacks, we recommend using [Azure DDoS Network Protection][ddos], which has enhanced DDoS mitigation features. See the [Security](#security) considerations.

- **Azure DNS**. [Azure DNS][azure-dns] is a hosting service for DNS domains. It provides name resolution using Microsoft Azure infrastructure. By hosting your domains in Azure, you can manage your DNS records using the same credentials, APIs, tools, and billing as your other Azure services.

#### Virtual machines

- **Apache Cassandra database**. Provides high availability at the data tier, by enabling replication and failover.

- **OpsCenter**. Deploy a monitoring solution such as [DataStax OpsCenter](https://docs.datastax.com/en/opscenter/6.1/opsc/about_c.html) to monitor the Cassandra cluster.

- **Jumpbox**. Also called a [bastion host]. A secure VM on the network that administrators use to connect to the other VMs. The jumpbox has an NSG that allows remote traffic only from public IP addresses on a safe list. The NSG should permit remote desktop (RDP) traffic.

## Recommendations

Your requirements might differ from the architecture described here. Use these recommendations as a starting point.

### Virtual machines

For recommendations on configuring the VMs, see [Run a Linux VM on Azure](./linux-vm.yml).

### Virtual network

When you create the virtual network, determine how many IP addresses your resources in each subnet require. Specify a subnet mask and a network address range large enough for the required IP addresses, using [CIDR] notation. Use an address space that falls within the standard [private IP address blocks][private-ip-space], which are 10.0.0.0/8, 172.16.0.0/12, and 192.168.0.0/16.

Choose an address range that doesn't overlap with your on-premises network, in case you need to set up a gateway between the VNet and your on-premises network later. Once you create the VNet, you can't change the address range.

Design subnets with functionality and security requirements in mind. All VMs within the same tier or role should go into the same subnet, which can be a security boundary. For more information about designing VNets and subnets, see [Plan and design Azure Virtual Networks][plan-network].

### Application Gateway

For information about configuring Application Gateway, see [Application Gateway configuration overview](/azure/application-gateway/configuration-overview).

### Load balancers

Do not expose the VMs directly to the Internet. Instead, give each VM a private IP address. Clients connect using the IP address associated with the Application Gateway.

Define load balancer rules to direct network traffic to the VMs. For example, to enable HTTP traffic, create a rule that maps port 80 from the front-end configuration to port 80 on the back-end address pool. When a client sends an HTTP request to port 80, the load balancer selects a back-end IP address by using a [hashing algorithm][load-balancer-hashing] that includes the source IP address. Client requests are distributed across all the VMs.

### Network security groups

Use NSG rules to restrict traffic between tiers. For example, in the three-tier architecture shown above, the web tier does not communicate directly with the database tier. To enforce this, the database tier should block incoming traffic from the web tier subnet.

1. Deny all inbound traffic from the VNet. (Use the `VIRTUAL_NETWORK` tag in the rule.)
2. Allow inbound traffic from the business tier subnet.
3. Allow inbound traffic from the database tier subnet itself. This rule allows communication between the database VMs, which is needed for database replication and failover.
4. Allow ssh traffic (port 22) from the jumpbox subnet. This rule lets administrators connect to the database tier from the jumpbox.

Create rules 2 &ndash; 4 with higher priority than the first rule, so they override it.

### Cassandra

We recommend [DataStax Enterprise][datastax] for production use, but these recommendations apply to any Cassandra edition. For more information on running DataStax in Azure, see [DataStax Enterprise Deployment Guide for Azure][cassandra-in-azure].

Configure nodes in rack-aware mode. Map fault domains to racks in the `cassandra-rackdc.properties` file.

You don't need a load balancer in front of the cluster. The client connects directly to a node in the cluster.

The deployment scripts for this architecture use name resolution to initialize the seed node for intra-cluster communication (gossip). To enable name resolution, the deployment creates an Azure Private DNS zone with A records for the Cassandra nodes. Depending on your initialization scripts, you might be able to use the static IP address instead.

> [!NOTE]
> Azure Private DNS is currently in public preview.

### Jumpbox

Don't allow ssh access from the public Internet to the VMs that run the application workload. Instead, all ssh access to these VMs must come through the jumpbox. An administrator logs into the jumpbox, and then logs into the other VM from the jumpbox. The jumpbox allows ssh traffic from the Internet, but only from known, safe IP addresses.

The jumpbox has minimal performance requirements, so select a small VM size. Create a [public IP address] for the jumpbox. Place the jumpbox in the same VNet as the other VMs, but in a separate management subnet.

To secure the jumpbox, add an NSG rule that allows ssh connections only from a safe set of public IP addresses. Configure the NSGs for the other subnets to allow ssh traffic from the management subnet.

## Considerations

### Scalability

#### Scale sets

For the web and business tiers, consider using [Virtual Machine Scale Sets][vmss], instead of deploying separate VMs into an availability set. A scale set makes it easy to deploy and manage a set of identical VMs, and autoscale the VMs based on performance metrics. As the load on the VMs increases, additional VMs are automatically added to the load balancer.

There are two basic ways to configure VMs deployed in a scale set:

- Use extensions to configure the VM after it's deployed. With this approach, new VM instances may take longer to start up than a VM with no extensions.

- Deploy a [managed disk](/azure/storage/storage-managed-disks-overview) with a custom disk image. This option may be quicker to deploy. However, it requires you to keep the image up-to-date.

For more information, see [Design considerations for scale sets][vmss-design].

> [!TIP]
> When using any autoscale solution, test it with production-level workloads well in advance.

#### Subscription limits

Each Azure subscription has default limits in place, including a maximum number of VMs per region. You can increase the limit by filing a support request. For more information, see [Azure subscription and service limits, quotas, and constraints][subscription-limits].

#### Application Gateway

Application Gateway supports fixed capacity mode or autoscaling mode. Fixed capacity mode is useful for scenarios with consistent and predictable workloads. Consider using autoscaling mode for workloads with variable traffic. For more information, see [Autoscaling and Zone-redundant Application Gateway v2][app-gw-scaling].

### Performance efficiency

To get the best performance from Cassandra on Azure VMs, see the recommendations in [Run Apache Cassandra on Azure VMs](../../best-practices/cassandra.md).

### Availability

Availability zones provide the best resiliency within a single region. If you need even higher availability, consider replicating the application across two regions.

Not all regions support availability zones, and not all VM sizes are supported in all zones. Run the following Azure CLI command to find the supported zones for each VM size within a region:

```bash
az vm list-skus --resource-type virtualMachines --zone false --location <location> \
    --query "[].{Name:name, Zones:locationInfo[].zones[] | join(','@)}" -o table
```

If you deploy this architecture to a region that does not support availability zones, put the VMs for each tier inside an *availability set*. VMs within the same availability are deployed across multiple physical servers, compute racks, storage units, and network switches for redundancy. Scale sets automatically use *placement groups*, which act as an implicit availability set.

When deploying to availability zones, use the Standard SKU of Azure Load Balancer and the v2 SKU of Application Gateway. These SKUs support cross-zone redundancy. For more information, see:

- [Standard Load Balancer and Availability Zones](/azure/load-balancer/load-balancer-standard-availability-zones)
- [Autoscaling and Zone-redundant Application Gateway v2][app-gw-scaling]
- [How does Application Gateway support high availability and scalability?](/azure/application-gateway/application-gateway-faq#how-does-application-gateway-support-high-availability-and-scalability)

A single Application Gateway deployment can run multiple instances of the gateway. For production workloads, run at least two instances.

#### Cassandra cluster

For the Cassandra cluster, the failover scenarios depend on the consistency levels used by the application and the number of replicas. For consistency levels and usage in Cassandra, see [Configuring data consistency][cassandra-consistency] and [Cassandra: How many nodes are talked to with Quorum?][cassandra-consistency-usage] Data availability in Cassandra is determined by the consistency level used by the application and the replication mechanism. For replication in Cassandra, see [Data Replication in NoSQL Databases Explained][cassandra-replication].

#### Health probes

Application Gateway and Load Balancer both use health probes to monitor the availability of VM instances.

- Application Gateway always uses an HTTP probe.
- Load Balancer can test either HTTP or TCP. Generally, if a VM runs an HTTP server, use an HTTP probe. Otherwise, use TCP.

If a probe can't reach an instance within a timeout period, the gateway or load balancer stops sending traffic to that VM. The probe continues to check and will return the VM to the back-end pool if the VM becomes available again.

HTTP probes send an HTTP GET request to a specified path and listen for an HTTP 200 response. This path can be the root path ("/"), or a health-monitoring endpoint that implements some custom logic to check the health of the application. The endpoint must allow anonymous HTTP requests.

For more information about health probes, see:

- [Load Balancer health probes](/azure/load-balancer/load-balancer-custom-probe-overview)
- [Application Gateway health monitoring overview](/azure/application-gateway/application-gateway-probe-overview)

For considerations about designing a health probe endpoint, see [Health Endpoint Monitoring pattern](../../patterns/health-endpoint-monitoring.yml).

### Cost optimization

Use the [Azure Pricing Calculator][azure-pricing-calculator] to estimates costs. Here are some other considerations.

#### Virtual machine scale sets

Virtual machine scale sets are available on all Linux VM sizes. You are only charged for the Azure VMs you deploy, as well as any additional underlying infrastructure resources consumed such as storage and networking. There are no incremental charges for the Virtual Machine Scale Sets service itself.

For single VMs pricing options See [Linux VMs pricing][Linux-vm-pricing].

#### Load balancers

You are charged only for the number of configured load-balancing and outbound rules. Inbound NAT rules are free. There is no hourly charge for the Standard Load Balancer when no rules are configured.

For more information, see the cost section in [Microsoft Azure Well-Architected Framework][WAF-cost].

### Security

Virtual networks are a traffic isolation boundary in Azure. VMs in one VNet can't communicate directly with VMs in a different VNet. VMs within the same VNet can communicate, unless you create [network security groups][nsg] (NSGs) to restrict traffic. For more information, see [Microsoft cloud services and network security][network-security].

For incoming Internet traffic, the load balancer rules define which traffic can reach the back end. However, load balancer rules don't support IP safe lists, so if you want to add certain public IP addresses to a safe list, add an NSG to the subnet.

**DMZ**. Consider adding a network virtual appliance (NVA) to create a DMZ between the Internet and the Azure virtual network. NVA is a generic term for a virtual appliance that can perform network-related tasks, such as firewall, packet inspection, auditing, and custom routing. For more information, see [Implementing a DMZ between Azure and the Internet][dmz].

**Encryption**. Encrypt sensitive data at rest and use [Azure Key Vault][azure-key-vault] to manage the database encryption keys. Key Vault can store encryption keys in hardware security modules (HSMs). It's also recommended to store application secrets, such as database connection strings, in Key Vault.

**DDoS protection**. The Azure platform provides basic DDoS protection by default. This basic protection is targeted at protecting the Azure infrastructure as a whole. Although basic DDoS protection is automatically enabled, we recommend using [Azure DDoS Network Protection][ddos]. Network Protection uses adaptive tuning, based on your application's network traffic patterns, to detect threats. This allows it to apply mitigations against DDoS attacks that might go unnoticed by the infrastructure-wide DDoS policies. Network Protection also provides alerting, telemetry, and analytics through Azure Monitor. For more information, see [Azure DDoS Protection: Best practices and reference architectures][ddos-best-practices].

### Operational excellence

Since all the main resources and their dependencies are in the same virtual network in this architecture, they are isolated in the same basic workload. That fact makes it easier to associate the workload's specific resources to a DevOps team, so that the team can independently manage all aspects of those resources. This isolation enables DevOps Teams and Services to perform continuous integration and continuous delivery (CI/CD).

Also, you can use different deployment templates and integrate them with [Azure DevOps Services][az-devops] to provision different environments in minutes, for example to replicate production like scenarios or load testing environments only when needed, saving cost.

In this scenario, your virtual machines are configured by using Virtual Machine Extensions, since they offer the possibility of installing certain additional software, such as Apache Cassandra. In particular, the Custom Script Extension allows the download and execution of arbitrary code on a Virtual Machine, allowing unlimited customization of the Operating System of an Azure VM. VM Extensions are installed and executed only at VM creation time. That means if the Operating System gets configured incorrectly at a later stage, it will require a manual intervention to move it back to its correct state. Configuration Management Tools can be used to address this issue.

Consider using the [Azure Monitor][azure-monitor] to Analyze and optimize the performance of your infrastructure, Monitor and diagnose networking issues without logging into your virtual machines. Application Insights is actually one of the components of Azure Monitor, which gives you rich metrics and logs to verify the state of your complete Azure landscape. Azure Monitor will help you to follow the state of your infrastructure.

Make sure not only to monitor your compute elements supporting your application code, but your data platform as well, in particular your databases, since a low performance of the data tier of an application could have serious consequences.

In order to test the Azure environment where the applications are running, it should be version-controlled and deployed through the same mechanisms as application code, then it can be tested and validated using DevOps testing paradigms too.

For more information, see the Operational Excellence section in [Microsoft Azure Well-Architecture Framework][WAF-devops].

## Next steps

- [Microsoft Learn module: Tour the N-tier architecture style](/training/modules/n-tier-architecture/)

<!-- links -->

[arm-template]: /azure/azure-resource-manager/resource-group-overview#resource-groups
[WAF-devops]: /azure/architecture/framework/devops/overview
[az-devops]: /azure/virtual-machines/windows/infrastructure-automation#azure-devops-services
[azbb-template]: https://github.com/mspnp/template-building-blocks/wiki/overview
[WAF-cost]: /azure/architecture/framework/cost/overview
[app-gw-scaling]: /azure/application-gateway
[azure-dns]: /azure/dns/dns-overview
[azure-key-vault]: https://azure.microsoft.com/services/key-vault
[azure-monitor]: https://azure.microsoft.com/services/monitor/
[bastion host]: https://en.wikipedia.org/wiki/Bastion_host
[cassandra-in-azure]: https://downloads.datastax.com/#enterprise
[cassandra-consistency]: https://docs.datastax.com/en/cassandra/2.0/cassandra/dml/dml_config_consistency_c.html
[cassandra-replication]: http://highscalability.com/blog/2012/7/9/data-replication-in-nosql-databases.html
[cassandra-consistency-usage]: https://medium.com/@foundev/cassandra-how-many-nodes-are-talked-to-with-quorum-also-should-i-use-it-98074e75d7d5#.b4pb4alb2
[cidr]: https://en.wikipedia.org/wiki/Classless_Inter-Domain_Routing
[azure-pricing-calculator]: https://azure.microsoft.com/pricing/calculator
[datastax]: https://www.datastax.com/products/datastax-enterprise
[ddos-best-practices]: /azure/security/fundamentals/ddos-best-practices
[ddos]: /azure/virtual-network/ddos-protection-overview
[dmz]: ../dmz/secure-vnet-dmz.yml
[Linux-vm-pricing]: https://azure.microsoft.com/pricing/details/virtual-machines/linux
[load-balancer-hashing]: /azure/load-balancer/components#load-balancing-rules
[load-balancer]: /azure/load-balancer/load-balancer-get-started-internet-arm-cli
[network-security]: /azure/best-practices-network-security
[nsg]: /azure/virtual-network/virtual-networks-nsg
[plan-network]: /azure/virtual-network/virtual-network-vnet-plan-design-arm
[private-ip-space]: https://en.wikipedia.org/wiki/Private_network#Private_IPv4_address_spaces
[public IP address]: /azure/virtual-network/virtual-network-ip-addresses-overview-arm
[resource-manager-overview]: /azure/azure-resource-manager/resource-group-overview
[subscription-limits]: /azure/azure-subscription-service-limits
[visio-download]: https://arch-center.azureedge.net/vm-reference-n-tier-cassandra.vsdx
[vmss-design]: /azure/virtual-machine-scale-sets/virtual-machine-scale-sets-design-overview
[vmss]: /azure/virtual-machine-scale-sets/virtual-machine-scale-sets-overview
