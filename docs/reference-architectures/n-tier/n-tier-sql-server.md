---
title: Windows N-tier application with SQL Server
titleSuffix: Azure Reference Architectures
description: Implement a multi-tier architecture on Azure for availability, security, scalability, and manageability.
author: MikeWasson
ms.date: 08/21/2019
ms.topic: reference-architecture
ms.service: architecture-center
ms.subservice: reference-architecture
---

# Windows N-tier application on Azure with SQL Server

This reference architecture shows how to deploy virtual machines (VMs) and a virtual network configured for an [N-tier](../../guide/architecture-styles/n-tier.md) application, using SQL Server on Windows for the data tier. [**Deploy this solution**](#deploy-the-solution).

[![N-tier architecture using Microsoft Azure](./images/n-tier-sql-server.png)](./images/n-tier-sql-server.png)

*Download a [Visio file][visio-download] of this architecture.*

## Architecture

The architecture has the following components.

### General

- **Resource group**. [Resource groups][resource-manager-overview] are used to group Azure resources so they can be managed by lifetime, owner, or other criteria.

- **Availability zones**. [Availability zones](/azure/availability-zones/az-overview) are physical locations within an Azure region. Each zone consists of one or more datacenters with independent power, cooling, and networking. By placing VMs across zones, the application becomes resilient to failures within a zone.

### Networking and load balancing

- **Virtual network and subnets**. Every Azure VM is deployed into a virtual network that can be segmented into subnets. Create a separate subnet for each tier.

- **Application gateway**. [Application Gateway](/azure/application-gateway/) is a layer 7 load balancer. In this architecture, it routes HTTP requests to the web front end. Application Gateway also provides a [web application firewall](/azure/application-gateway/waf-overview) (WAF) that protects the application from common exploits and vulnerabilities.

- **Load balancers**. Use [Azure Standard Load Balancer][load-balancer] to distribute network traffic from the web tier to the business tier, and from the business tier to SQL Server.

- **Network security groups** (NSGs). Use [NSGs][nsg] to restrict network traffic within the virtual network. For example, in the three-tier architecture shown here, the database tier does not accept traffic from the web front end, only from the business tier and the management subnet.

- **DDoS Protection**. Although the Azure platform provides basic protection against distributed denial of service (DDoS) attacks, we recommend using [DDoS Protection Standard][ddos], which has enhanced DDoS mitigation features. See [Security considerations](#security-considerations).

- **Azure DNS**. [Azure DNS][azure-dns] is a hosting service for DNS domains. It provides name resolution using Microsoft Azure infrastructure. By hosting your domains in Azure, you can manage your DNS records using the same credentials, APIs, tools, and billing as your other Azure services.

### Virtual machines

- **SQL Server Always On Availability Group**. Provides high availability at the data tier, by enabling replication and failover. It uses Windows Server Failover Cluster (WSFC) technology for failover.

- **Active Directory Domain Services (AD DS) Servers**. The computer objects for the failover cluster and its associated clustered roles are created in Active Directory Domain Services (AD DS).

- **Cloud Witness**. A failover cluster requires more than half of its nodes to be running, which is known as having quorum. If the cluster has just two nodes, a network partition could cause each node to think it's the master node. In that case, you need a *witness* to break ties and establish quorum. A witness is a resource such as a shared disk that can act as a tie breaker to establish quorum. Cloud Witness is a type of witness that uses Azure Blob Storage. To learn more about the concept of quorum, see [Understanding cluster and pool quorum](/windows-server/storage/storage-spaces/understand-quorum). For more information about Cloud Witness, see [Deploy a Cloud Witness for a Failover Cluster](/windows-server/failover-clustering/deploy-cloud-witness).

- **Jumpbox**. Also called a [bastion host]. A secure VM on the network that administrators use to connect to the other VMs. The jumpbox has an NSG that allows remote traffic only from public IP addresses on a safe list. The NSG should permit remote desktop (RDP) traffic.

## Recommendations

Your requirements might differ from the architecture described here. Use these recommendations as a starting point.

### Virtual machines

For recommendations on configuring the VMs, see [Run a Windows VM on Azure](./windows-vm.md).

### Virtual network

When you create the virtual network, determine how many IP addresses your resources in each subnet require. Specify a subnet mask and a network address range large enough for the required IP addresses, using [CIDR] notation. Use an address space that falls within the standard [private IP address blocks][private-ip-space], which are 10.0.0.0/8, 172.16.0.0/12, and 192.168.0.0/16.

Choose an address range that does not overlap with your on-premises network, in case you need to set up a gateway between the virtual network and your on-premises network later. Once you create the virtual network, you can't change the address range.

Design subnets with functionality and security requirements in mind. All VMs within the same tier or role should go into the same subnet, which can be a security boundary. For more information about designing virtual networks and subnets, see [Plan and design Azure Virtual Networks][plan-network].

### Application Gateway

For information about configuring Application Gateway, see [Application Gateway configuration overview](/azure/application-gateway/configuration-overview).

### Load balancers

Don't expose the VMs directly to the Internet, but instead give each VM a private IP address. Clients connect using the public IP address associated with the Application Gateway.

Define load balancer rules to direct network traffic to the VMs. For example, to enable HTTP traffic, map port 80 from the front-end configuration to port 80 on the back-end address pool. When a client sends an HTTP request to port 80, the load balancer selects a back-end IP address by using a [hashing algorithm][load-balancer-hashing] that includes the source IP address. Client requests are distributed across all the VMs in the back-end address pool.

### Network security groups

Use NSG rules to restrict traffic between tiers. In the three-tier architecture shown above, the web tier does not communicate directly with the database tier. To enforce this rule, the database tier should block incoming traffic from the web tier subnet.

1. Deny all inbound traffic from the virtual network. (Use the `VIRTUAL_NETWORK` tag in the rule.)
2. Allow inbound traffic from the business tier subnet.
3. Allow inbound traffic from the database tier subnet itself. This rule allows communication between the database VMs, which is needed for database replication and failover.
4. Allow RDP traffic (port 3389) from the jumpbox subnet. This rule lets administrators connect to the database tier from the jumpbox.

Create rules 2 &ndash; 4 with higher priority than the first rule, so they override it.

### SQL Server Always On Availability Groups

We recommend [Always On Availability Groups][sql-alwayson] for SQL Server high availability. Prior to Windows Server 2016, Always On Availability Groups require a domain controller, and all nodes in the availability group must be in the same AD domain.

Other tiers connect to the database through an [availability group listener][sql-alwayson-listeners]. The listener enables a SQL client to connect without knowing the name of the physical instance of SQL Server. VMs that access the database must be joined to the domain. The client (in this case, another tier) uses DNS to resolve the listener's virtual network name into IP addresses.

Configure the SQL Server Always On Availability Group as follows:

1. Create a Windows Server Failover Clustering (WSFC) cluster, a SQL Server Always On Availability Group, and a primary replica. For more information, see [Getting Started with Always On Availability Groups][sql-alwayson-getting-started].
2. Create an internal load balancer with a static private IP address.
3. Create an availability group listener, and map the listener's DNS name to the IP address of an internal load balancer.
4. Create a load balancer rule for the SQL Server listening port (TCP port 1433 by default). The load balancer rule must enable *floating IP*, also called Direct Server Return. This causes the VM to reply directly to the client, which enables a direct connection to the primary replica.

   > [!NOTE]
   > When floating IP is enabled, the front-end port number must be the same as the back-end port number in the load balancer rule.
   >

When a SQL client tries to connect, the load balancer routes the connection request to the primary replica. If there is a failover to another replica, the load balancer automatically routes new requests to a new primary replica. For more information, see [Configure an ILB listener for SQL Server Always On Availability Groups][sql-alwayson-ilb].

During a failover, existing client connections are closed. After the failover completes, new connections will be routed to the new primary replica.

If your application makes significantly more reads than writes, you can offload some of the read-only queries to a secondary replica. See [Using a Listener to Connect to a Read-Only Secondary Replica (Read-Only Routing)][sql-alwayson-read-only-routing].

Test your deployment by [forcing a manual failover][sql-alwayson-force-failover] of the availability group.

### Jumpbox

Don't allow RDP access from the public Internet to the VMs that run the application workload. Instead, all RDP access to these VMs should go through the jumpbox. An administrator logs into the jumpbox, and then logs into the other VM from the jumpbox. The jumpbox allows RDP traffic from the Internet, but only from known, safe IP addresses.

The jumpbox has minimal performance requirements, so select a small VM size. Create a [public IP address] for the jumpbox. Place the jumpbox in the same virtual network as the other VMs, but in a separate management subnet.

To secure the jumpbox, add an NSG rule that allows RDP connections only from a safe set of public IP addresses. Configure the NSGs for the other subnets to allow RDP traffic from the management subnet.

## Scalability considerations

### Scale sets

For the web and business tiers, consider using [virtual machine scale sets][vmss] instead of deploying separate VMs. A scale set makes it easy to deploy and manage a set of identical VMs, and autoscale the VMs based on performance metrics. As the load on the VMs increases, additional VMs are automatically added to the load balancer. Consider scale sets if you need to quickly scale out VMs, or need to autoscale.

There are two basic ways to configure VMs deployed in a scale set:

- Use extensions to configure the VM after it's deployed. With this approach, new VM instances may take longer to start up than a VM with no extensions.

- Deploy a [managed disk](/azure/storage/storage-managed-disks-overview) with a custom disk image. This option may be quicker to deploy. However, it requires you to keep the image up-to-date.

For more information, see [Design considerations for scale sets][vmss-design].

> [!TIP]
> When using any autoscale solution, test it with production-level workloads well in advance.

### Subscription limits

Each Azure subscription has default limits in place, including a maximum number of VMs per region. You can increase the limit by filing a support request. For more information, see [Azure subscription and service limits, quotas, and constraints][subscription-limits].

### Application Gateway

Application Gateway supports fixed capacity mode or autoscaling mode. Fixed capacity mode is useful for scenarios with consistent and predictable workloads. Consider using autoscaling mode for workloads with variable traffic. For more information, see [Autoscaling and Zone-redundant Application Gateway v2][app-gw-scaling]

## Availability considerations

Availability zones provide the best resiliency within a single region. If you need even higher availability, consider replicating the application across two regions, using Azure Traffic Manager for failover. For more information, see [Multi-region N-tier application for high availability][multi-dc].

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

### Health probes

Application Gateway and Load Balancer both use health probes to monitor the availability of VM instances.

- Application Gateway always uses an HTTP probe.
- Load Balancer can test either HTTP or TCP. Generally, if a VM runs an HTTP server, use an HTTP probe. Otherwise, use TCP.

If a probe can't reach an instance within a timeout period, the gateway or load balancer stops sending traffic to that VM. The probe continues to check and will return the VM to the back-end pool if the VM becomes available again.

HTTP probes send an HTTP GET request to a specified path and listen for an HTTP 200 response. This path can be the root path ("/"), or a health-monitoring endpoint that implements some custom logic to check the health of the application. The endpoint must allow anonymous HTTP requests.

For more information about health probes, see:

- [Load Balancer health probes](/azure/load-balancer/load-balancer-custom-probe-overview)
- [Application Gateway health monitoring overview](/azure/application-gateway/application-gateway-probe-overview)

For considerations about designing a health probe endpoint, see [Health Endpoint Monitoring pattern](../../patterns/health-endpoint-monitoring.md).

## Security considerations

Virtual networks are a traffic isolation boundary in Azure. By default, VMs in one virtual network can't communicate directly with VMs in a different virtual network. However, you can explicitly connect virtual networks by using [virtual network peering](/virtual-network/virtual-network-peering-overview).

**NSGs**. Use [network security groups][nsg] (NSGs) to restrict traffic to and from the internet. For more information, see [Microsoft cloud services and network security][network-security].

**DMZ**. Consider adding a network virtual appliance (NVA) to create a DMZ between the Internet and the Azure virtual network. NVA is a generic term for a virtual appliance that can perform network-related tasks, such as firewall, packet inspection, auditing, and custom routing. For more information, see [Implementing a DMZ between Azure and the Internet][dmz].

**Encryption**. Encrypt sensitive data at rest and use [Azure Key Vault][azure-key-vault] to manage the database encryption keys. Key Vault can store encryption keys in hardware security modules (HSMs). For more information, see [Configure Azure Key Vault Integration for SQL Server on Azure VMs][sql-keyvault]. It's also recommended to store application secrets, such as database connection strings, in Key Vault.

**DDoS protection**. The Azure platform provides basic DDoS protection by default. This basic protection is targeted at protecting the Azure infrastructure as a whole. Although basic DDoS protection is automatically enabled, we recommend using [DDoS Protection Standard][ddos]. Standard protection uses adaptive tuning, based on your application's network traffic patterns, to detect threats. This allows it to apply mitigations against DDoS attacks that might go unnoticed by the infrastructure-wide DDoS policies. Standard protection also provides alerting, telemetry, and analytics through Azure Monitor. For more information, see [Azure DDoS Protection: Best practices and reference architectures][ddos-best-practices].

## Deploy the solution

A deployment for this reference architecture is available on [GitHub][github-folder]. The entire deployment can take up to an hour, which includes running the scripts to configure AD DS, the Windows Server failover cluster, and the SQL Server availability group.

If you specify a region that supports availability zones, the VMs are deployed into availability zones. Otherwise, the VMs are deployed into availability sets. For a list of regions that support availability zones, see [Services support by region](/azure/availability-zones/az-overview#services-support-by-region).

### Prerequisites

[!INCLUDE [ref-arch-prerequisites.md](../../../includes/ref-arch-prerequisites.md)]

### Deployment steps

1. Navigate to the `virtual-machines\n-tier-windows` folder of the reference architectures GitHub repository.

1. Open the `n-tier-windows.json` file.

1. In the `n-tier-windows.json` file, search for all instances of `[replace-with-password]` and `[replace-with-safe-mode-password]` and replace them with a strong password. Save the file.

    > [!NOTE]
    > If you change the administrator user name, you must also update the `extensions` blocks in the JSON file.

1. Run the following command to deploy the architecture.

    ```azurecli
    azbb -s <your subscription_id> -g <resource_group_name> -l <location> -p n-tier-windows.json --deploy
    ```

1. When the deployment is complete, open the Azure portal and navigate to the resource group. Find the storage account that begins with 'sqlcw'. This is the storage account that will be used for the cluster's cloud witness. Navigate into the storage account, select **Access Keys**, and copy the value of `key1`. Also copy the name of the storage account.

1. Open the `n-tier-windows-sqlao.json` file.

1. In the `n-tier-windows-sqlao.json` file, search for all instances of `[replace-with-password]` and `[replace-with-sql-password]` and replace them with a strong password.

    > [!NOTE]
    > If you change the administrator user name, you must also update the `extensions` blocks in the JSON file.

1. In the `n-tier-windows-sqlao.json` file, search for all instances of `[replace-with-storageaccountname]` and `[replace-with-storagekey]` and replace them with the values from step 5. Save the file.

1. Run the following command to configure SQL Server Always On.

    ```azurecli
    azbb -s <your subscription_id> -g <resource_group_name> -l <location> -p n-tier-windows-sqlao.json --deploy
    ```

## Next steps

- [Microsoft Learn module: Tour the N-tier architecture style](/learn/modules/n-tier-architecture/)

<!-- links -->
[app-gw-scaling]: /azure/application-gateway/application-gateway-autoscaling-zone-redundant
[azure-dns]: /azure/dns/dns-overview
[azure-key-vault]: https://azure.microsoft.com/services/key-vault
[bastion host]: https://en.wikipedia.org/wiki/Bastion_host
[cidr]: https://en.wikipedia.org/wiki/Classless_Inter-Domain_Routing
[ddos-best-practices]: /azure/security/azure-ddos-best-practices
[ddos]: /azure/virtual-network/ddos-protection-overview
[dmz]: ../dmz/secure-vnet-dmz.md
[github-folder]: https://github.com/mspnp/reference-architectures/tree/master/virtual-machines/n-tier-windows
[load-balancer-hashing]: /azure/load-balancer/load-balancer-overview#fundamental-load-balancer-features
[load-balancer]: /azure/load-balancer/load-balancer-standard-overview
[multi-dc]: multi-region-sql-server.md
[n-tier]: n-tier.md
[network-security]: /azure/best-practices-network-security
[nsg]: /azure/virtual-network/virtual-networks-nsg
[plan-network]: /azure/virtual-network/virtual-network-vnet-plan-design-arm
[private-ip-space]: https://en.wikipedia.org/wiki/Private_network#Private_IPv4_address_spaces
[public IP address]: /azure/virtual-network/virtual-network-ip-addresses-overview-arm
[resource-manager-overview]: /azure/azure-resource-manager/resource-group-overview
[sql-alwayson-force-failover]: https://msdn.microsoft.com/library/ff877957.aspx
[sql-alwayson-getting-started]: https://msdn.microsoft.com/library/gg509118.aspx
[sql-alwayson-ilb]: /azure/virtual-machines/windows/sql/virtual-machines-windows-portal-sql-alwayson-int-listener
[sql-alwayson-listeners]: https://msdn.microsoft.com/library/hh213417.aspx
[sql-alwayson-read-only-routing]: https://technet.microsoft.com/library/hh213417.aspx#ConnectToSecondary
[sql-alwayson]: https://msdn.microsoft.com/library/hh510230.aspx
[sql-keyvault]: /azure/virtual-machines/virtual-machines-windows-ps-sql-keyvault
[subscription-limits]: /azure/azure-subscription-service-limits
[visio-download]: https://archcenter.blob.core.windows.net/cdn/vm-reference-architectures.vsdx
[vmss-design]: /azure/virtual-machine-scale-sets/virtual-machine-scale-sets-design-overview
[vmss]: /azure/virtual-machine-scale-sets/virtual-machine-scale-sets-overview
