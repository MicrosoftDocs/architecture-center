This solution provides best practices for applying availability zones to a web application and Microsoft SQL Server database hosted on virtual machines (VMs).

## Architecture

:::image type="content" source="images/ref-arch-iaas.svg" alt-text="Architecture diagram that shows virtual machines that host web apps and SQL Server databases and are spread over three zones." lightbox="images/ref-arch-iaas.svg":::

*Download a [Visio file](https://arch-center.azureedge.net/ref-arch-iaas.vsdx) of all diagrams in this article.*

### Workflow

The architecture uses resources spread across multiple zones to provide high availability to an Infrastructure as a Service (IaaS) web application that uses a SQL Server database. A zone-redundant instance of Azure Application Gateway routes traffic to VMs within the web tier. A zone-redundant load balancer routes traffic from the VMs in the web tier to the active SQL Server instance. In case of a zone failure, Application Gateway routes to VMs in other available zones. Routing across zones has higher latency than routing within the zone.

If the active SQL Server instance becomes unavailable, either due to a zone failure or local failure, a passive SQL Server instance becomes active. The zone-redundant load balancer detects the failover to the newly active SQL Server instance, and routes traffic to it.

The following diagram illustrates a failure of zone 1.

![Architecture diagram that shows a failure in zone 1.](./images/ref-arch-iaas-zone-one-failure.svg)

The Application Gateway instance is zone-redundant. It isn't affected by the failure of zone 1, and uses health probes to determine the available VMs. With zone 1 unavailable, it routes traffic only to the remaining two zones. The zone-redundant load balancer is also unaffected by the failure of zone 1, and uses health probes to determine the location of the active SQL Server instance. In this example, the load balancer detects that SQL Server is active in zone 3 and routes traffic to it.

Spreading resources across availability zones also protects an application from planned maintenance. When VMs are distributed across three availability zones, they are, in effect, spread across three update domains. The Azure platform recognizes this distribution across update domains to ensure that VMs in different zones aren't updated at the same time.

By replicating VMs across availability zones, you can protect your applications and data from a zone failure. This is how Azure meets the industry-best [VM uptime service-level agreement (SLA)](https://azure.microsoft.com/support/legal/sla/virtual-machines/v1_9). For more information, see [Building solutions for high availability using availability zones](./building-solutions-for-high-availability.yml).

### Components

The architecture uses the following components.

#### General

- [Resource groups](https://azure.microsoft.com/get-started/azure-portal/resource-manager) are used to group Azure resources so they can be managed by lifetime, owner, or other criteria.

- [Availability zones](https://azure.microsoft.com/explore/global-infrastructure/availability-zones) are separate physical locations within an Azure region, each with one or more datacenters that have independent power, cooling, and networking. By placing VMs across zones, the application becomes resilient to failures within a zone.

#### Networking and load balancing

- [Azure Virtual Network](https://azure.microsoft.com/products/virtual-network) is the fundamental building block for private networks in Azure. Every Azure VM is deployed into a virtual network that can be segmented into subnets with one subnet for each tier.

- [Application Gateway](https://azure.microsoft.com/products/application-gateway) is a layer-7 load balancer. In this architecture, a zone-redundant Application Gateway instance routes HTTP requests to the web front end. Application Gateway also provides [Azure Web Application Firewall](https://azure.microsoft.com/products/web-application-firewall), which protects the application from common exploits and vulnerabilities. The v2 SKU of Application Gateway supports cross-zone redundancy. A single Application Gateway deployment can run multiple gateway instances. For production workloads, run at least two. For more information, see [Autoscaling and zone-redundant Application Gateway v2](/azure/application-gateway/application-gateway-autoscaling-zone-redundant) and [How does Application Gateway support high availability and scalability?](/azure/application-gateway/application-gateway-faq#how-does-application-gateway-support-high-availability-and-scalability).

- [Azure Load Balancer](https://azure.microsoft.com/products/load-balancer) is a layer-4 load balancer. In this architecture, a zone-redundant [Azure Standard Load Balancer](/azure/load-balancer/load-balancer-standard-overview) directs network traffic from the web tier to SQL Server. Because a zone-redundant load balancer isn't pinned to a specific zone, the application continues to distribute the network traffic during a zone failure. A zone-redundant load balancer is used to provide availability when the active SQL Server instance becomes unavailable. The standard SKU of Load Balancer supports cross-zone redundancy. For more information, see [Standard Load Balancer and availability zones](/azure/load-balancer/load-balancer-standard-availability-zones).

- [Network security groups](https://azuremarketplace.microsoft.com/marketplace/apps/Microsoft.NetworkSecurityGroup) are used to restrict network traffic within a virtual network. In this architecture, the web tier only accepts traffic from the public IP endpoint. Also, the database tier doesn't accept traffic from any subnet other than the web-tier subnet.

- [Azure DDoS Protection](https://azure.microsoft.com/products/ddos-protection) offers enhanced distributed denial of service (DDoS) mitigation features. The Azure platform provides protection against DDoS, but DDoS Protection supplies additional protection. For more information, see [Security considerations](#ddos-protection).

- [Azure Bastion](https://azure.microsoft.com/services/azure-bastion) provides secure and seamless Remote Desktop Protocol (RDP) and Secure Shell (SSH) access to the VMs within a virtual network. This service provides access while limiting the exposed public IP addresses of the VMs within the virtual network. Azure Bastion provides a cost-effective alternative to a **provisioned** VM to provide access to all VMs within the same virtual network.

#### SQL Server

- A [SQL Server Always On availability group](https://www.microsoft.com/sql-server/sql-server-2019-features) provides high availability at the data tier by enabling replication and failover. It uses Windows Server Failover Cluster (WSFC) technology for failover.

- The [Cloud Witness](/windows-server/failover-clustering/deploy-cloud-witness) feature of SQL Server uses [Azure Blob Storage](https://azure.microsoft.com/products/storage/blobs) to provide a vote on [cluster quorum](/windows-server/storage/storage-spaces/understand-quorum). A failover cluster requires that more than half its nodes are running, a condition known as having quorum. If the cluster has just two nodes, a network partition can cause each node to think it's the primary node. In that case, you need a witness to break ties and establish quorum. A witness is a resource such as a shared disk that can act as a tie breaker to establish quorum. Cloud Witness uses Blob Storage as an arbitration point. Blob Storage must use zone-redundant storage to be unaffected by a zone failure.

## Scenario details

Azure availability zones are separate physical locations within an Azure region, each with one or more datacenters that have independent power, cooling, and networking. The physical separation of availability zones within a region limits the effect of zone failures on applications and data. The reference architecture presented in this article demonstrates best practices for a zonal deployment—a deployment that uses availability zones to increase application availability. A zonal deployment is appropriate for many kinds of applications. The particular example shown here is zonal deployment of a web application that runs on virtual machines (VMs) and uses a SQL Server database.

This approach is used in high availability scenarios where resiliency is very important. With HA architecture, there's a balance between high resiliency, low latency, and cost. This architecture uses redundant resources spread across zones to provide high resiliency. Traffic can be routed between zones to minimize the impact of a zone failure. If a zone does fail, resources in other zones absorb the traffic until the failed zone recovers. This provides a high level of resiliency.

This architecture provides an efficient use of resources, because most of the resources are actively used. All resources, other than the passive SQL Server instance, are used in handling requests. The passive SQL Server instance becomes active only if the active one fails.

The zone-redundant Application Gateway instance and zone-redundant load balancer distribute the traffic to the available resources.

## Recommendations

Your requirements might differ from the architecture described here. Use these recommendations as a starting point.

For recommendations on configuring the VMs, see [Run a Windows VM on Azure](../reference-architectures/n-tier/windows-vm.yml).

For more information about designing virtual networks and subnets, see [Plan and design Azure Virtual Networks](/azure/virtual-network/virtual-network-vnet-plan-design-arm).

### Network security groups

Use network security group rules to restrict traffic between tiers. In this architecture, only the web tier can communicate directly with the database tier. To enforce this rule, the database tier blocks all incoming traffic except for the web-tier subnet.

- Deny all inbound traffic from the virtual network. (Use the VIRTUAL\_NETWORK tag in the rule.)
- Allow inbound traffic from the web-tier subnet.
- Allow inbound traffic from the database-tier subnet itself. This rule allows communication between the database VMs, which is needed for database replication and failover.

Create the second and third rules with higher priority than the first rule, so they override it.

### SQL Server Always On availability groups

We recommend [Always On availability groups](/sql/database-engine/availability-groups/windows/always-on-availability-groups-sql-server?view=sql-server-ver15&preserve-view=true) for SQL Server high availability. Other tiers connect to the database through an [availability group listener](/sql/database-engine/availability-groups/windows/listeners-client-connectivity-application-failover?view=sql-server-ver15&preserve-view=true). The listener enables a SQL client to connect without knowing the name of the physical instance of SQL Server. VMs that access the database must be joined to the domain. The client (in this case, another tier) uses DNS to resolve the listener's virtual network name into IP addresses.

Configure the SQL Server Always On availability group as follows:

- Create a Windows Server Failover Clustering (WSFC) cluster, a SQL Server Always On availability group, and a primary replica. For more information, see [Getting Started with Always On availability groups](/sql/database-engine/availability-groups/windows/getting-started-with-always-on-availability-groups-sql-server?view=sql-server-ver15&preserve-view=true).
- Create an internal load balancer with a static private IP address.
- Create an availability group listener, and map the listener's DNS name to the IP address of an internal load balancer.
- Create a load balancer rule for the SQL Server listening port (TCP port 1433 by default). The load balancer rule must enable floating IP, also called Direct Server Return. This causes the VM to reply directly to the client, which enables a direct connection to the primary replica.

> [!NOTE]
> When floating IP is enabled, the front-end port number must be the same as the back-end port number in the load balancer rule.

When a SQL client tries to connect, the load balancer routes the connection request to the primary replica. If there's a failover to another replica, the load balancer automatically routes new requests to a new primary replica. For more information, see [Configure a load balancer for an availability group on Azure virtual machines running SQL Server](/azure/azure-sql/virtual-machines/windows/availability-group-load-balancer-portal-configure).

A failover closes existing client connections. After the failover is complete, new connections are routed to the new primary replica.

If your application reads significantly more than it writes, redirect some of the read-only queries to a secondary replica. See [Connect to a read-only replica](/sql/database-engine/availability-groups/windows/listeners-client-connectivity-application-failover?view=sql-server-ver15&preserve-view=true#ConnectToSecondary&preserve-view=true).

Test your deployment by [forcing a manual failover](/sql/database-engine/availability-groups/windows/perform-a-forced-manual-failover-of-an-availability-group-sql-server?view=sql-server-ver15&preserve-view=true) of the availability group.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Availability

Availability zones provide high resiliency within a single region. If you need even higher availability, consider replicating the application across two regions, using Azure Traffic Manager for failover. For more information, see [Run an N-tier application in multiple Azure regions for high availability](../reference-architectures/n-tier/multi-region-sql-server.yml).

Not all regions support availability zones, and not all VM sizes are supported in all zones. Run the following Azure CLI command to find the supported zones for each VM size within a region:

```azurecli
az vm list-skus --resource-type virtualMachines --zone false --location eastus -o table
```

The Azure Virtual Machine Scale Sets compute resource automatically uses placement groups, which act as an implicit availability set. For more information about placement groups, see [Working with large Virtual Machine Scale Sets](/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-placement-groups).

#### Health probes

Application Gateway and Load Balancer both use health probes to monitor the availability of VM instances.

- Application Gateway always uses an HTTP probe.
- Load Balancer can probe with either HTTP or TCP. Generally, if a VM runs an HTTP server, use an HTTP probe. Otherwise, use TCP.

If a probe can't reach an instance within a timeout period, the gateway or load balancer stops sending traffic to that VM. The probe continues to check, and returns the VM to the back-end pool when the VM becomes available again.

HTTP probes send an HTTP GET request to a specified path and listen for an HTTP 200 response. This path can be the root path ("/"), or a health-monitoring endpoint that implements custom logic to check the health of the application. The endpoint must allow anonymous HTTP requests.

For more information about health probes, see these resources:

- [Load Balancer health probes](/azure/load-balancer/load-balancer-custom-probe-overview)
- [Application Gateway health monitoring overview](/azure/application-gateway/application-gateway-probe-overview)

For considerations about designing a health probe endpoint, see [Health Endpoint Monitoring pattern](../patterns/health-endpoint-monitoring.yml).

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

Use the [Azure Pricing Calculator](https://azure.microsoft.com/pricing/calculator) to estimate costs. Here are some other considerations.

#### Virtual Machine Scale Sets

The Virtual Machine Scale Sets resource is available on all Windows VM sizes. You're charged only for the Azure VMs that you deploy, and for any additional underlying infrastructure resources consumed, such as storage and networking. There are no incremental charges for the Virtual Machine Scale Sets service.

For single VMs pricing options, see [Windows VMs pricing](https://azure.microsoft.com/pricing/details/virtual-machines/windows).

#### SQL Server

If you choose Azure SQL Database, which is a fully managed platform as a service (PaaS) database engine, you can reduce costs because you don't need to configure an Always On availability group and domain controller machines. There are several deployment options starting from single database up to managed instance, or elastic pools. For more information, see [Azure SQL pricing](https://azure.microsoft.com/pricing/details/sql-database/managed).

For SQL server VM pricing options, see [SQL VMs pricing](https://www.microsoft.com/sql-server/sql-server-2019-pricing).

#### Load Balancer

You're charged only for the number of configured load-balancing and outbound rules. Inbound NAT rules are free. There's no hourly charge for the standard load balancer when no rules are configured.

For more information, see the cost section in [Azure Architecture Framework](/azure/architecture/framework/cost/overview).

#### Application Gateway

Application Gateway should be provisioned with the v2 SKU and can span multiple availability zones. With the v2 SKU, the pricing model is driven by consumption and has two components: an hourly fixed price and a consumption-based cost.

For more information, see the pricing section in [Autoscaling and zone-redundant Application Gateway v2](/azure/application-gateway/application-gateway-autoscaling-zone-redundant#pricing).

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

Virtual networks are a traffic isolation boundary in Azure. By default, VMs in one virtual network can't communicate directly with VMs in a different virtual network. However, you can explicitly connect virtual networks by using [virtual network peering](/azure/virtual-network/virtual-network-peering-overview).

#### Traffic restriction

Use [network security groups](/azure/virtual-network/virtual-networks-nsg) to restrict traffic to and from the internet. For more information, see [Microsoft cloud services and network security](/azure/best-practices-network-security).

#### Perimeter network

Consider adding a network virtual appliance (NVA) to create a perimeter network, also known as a demilitarized zone (DMZ), between the internet and the Azure virtual network. NVA is a generic term for a virtual appliance that can perform network-related tasks, such as firewall, packet inspection, auditing, and custom routing. For more information, see [Network DMZ between Azure and an on-premises datacenter](../reference-architectures/dmz/secure-vnet-dmz.yml).

#### Encryption

Encrypt sensitive data at rest and use [Azure Key Vault](https://azure.microsoft.com/services/key-vault) to manage the database encryption keys. Key Vault can store encryption keys in hardware security modules (HSMs). For more information, see [Configure Azure Key Vault Integration for SQL Server on Azure VMs](/azure/azure-sql/virtual-machines/windows/azure-key-vault-integration-configure). We also recommend that you store application secrets, such as database connection strings, in Key Vault.

#### DDoS protection

The Azure platform provides basic DDoS protection by default. This basic protection is targeted at protecting the Azure infrastructure. Although basic DDoS protection is automatically enabled, we recommend using [Azure DDoS Protection](/azure/virtual-network/ddos-protection-overview). DDoS Protection uses adaptive tuning, based on your application's network traffic patterns, to detect threats. This practice allows it to apply mitigations against DDoS attacks that might go unnoticed by the infrastructure-wide DDoS policies. DDoS Protection also provides alerting, telemetry, and analytics through Azure Monitor. For more information, see [Azure DDoS Protection: Best practices and reference architectures](/azure/security/fundamentals/ddos-best-practices).

## Next steps

- [Tour the N-tier architecture style for your application](/training/modules/n-tier-architecture)
- [Azure resource groups](/azure/azure-resource-manager/management/overview#resource-groups)
- [Azure availability zones](/azure/availability-zones/az-overview#availability-zones)
- [What is Azure Virtual Network?](/azure/virtual-network/virtual-networks-overview)
- [Azure Application Gateway documentation](/azure/application-gateway)
- [What is Azure Web Application Firewall on Azure Application Gateway?](/azure/application-gateway/waf-overview)
- [What is Azure Load Balancer?](/azure/load-balancer/load-balancer-standard-overview)
- [Network security groups](/azure/virtual-network/virtual-networks-nsg)
- [Azure DDoS Protection](/azure/virtual-network/ddos-protection-overview)
- [What is Azure Bastion?](/azure/bastion/bastion-overview)
- [What is an Always On availability group?](/sql/database-engine/availability-groups/windows/overview-of-always-on-availability-groups-sql-server)
- [Cloud Witness](/windows-server/failover-clustering/deploy-cloud-witness)

## Related resources

- [Build solutions for high availability using availability zones on Azure](./building-solutions-for-high-availability.yml)
- [High availability and disaster recovery scenarios for IaaS apps](../example-scenario/infrastructure/iaas-high-availability-disaster-recovery.yml)
- [Multi-tier web application built for HA/DR](../example-scenario/infrastructure/multi-tier-app-disaster-recovery.yml)
