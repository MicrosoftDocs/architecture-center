---
title: N-tier application with SQL Server
description: >-
  How to implement a multi-tier architecture on Azure, for availability, security, scalability, and manageability.

author: MikeWasson
ms.date: 07/19/2018
---

# N-tier application with SQL Server

This reference architecture shows how to deploy VMs and a virtual network configured for an N-tier application, using SQL Server on Windows for the data tier. [**Deploy this solution**.](#deploy-the-solution) 

![[0]][0]

*Download a [Visio file][visio-download] of this architecture.*

## Architecture 

The architecture has the following components:

* **Resource group.** [Resource groups][resource-manager-overview] are used to group resources so they can be managed by lifetime, owner, or other criteria.

* **Virtual network (VNet) and subnets.** Every Azure VM is deployed into a VNet that can be segmented into multiple subnets. Create a separate subnet for each tier. 

* **Application gateway**. [Azure Application Gateway](/azure/application-gateway/) is a layer 7 load balancer. In this architecture, it routes HTTP requests to the web front end. Application Gateway also provides a [web application firewall](/azure/application-gateway/waf-overview) (WAF) that protects the application from common exploits and vulnerabilities. 

* **NSGs.** Use [network security groups][nsg] (NSGs) to restrict network traffic within the VNet. For example, in the 3-tier architecture shown here, the database tier does not accept traffic from the web front end, only from the business tier and the management subnet.

* **Virtual machines**. For recommendations on configuring VMs, see [Run a Windows VM on Azure](./windows-vm.md) and [Run a Linux VM on Azure](./linux-vm.md).

* **Availability sets.** Create an [availability set][azure-availability-sets] for each tier, and provision at least two VMs in each tier. This makes the VMs eligible for a higher [service level agreement (SLA)][vm-sla] for VMs. 

* **VM scale set** (not shown). A [VM scale set][vmss] is an alternative to using an availability set. A scale sets makes it easy to scale out the VMs in a tier, either manually or automatically based on predefined rules.

* **Load balancers.** Use [Azure Load Balancer][load-balancer] to distribute network traffic from the web tier to the business tier, and from the business tier to SQL Server.

* **Public IP address**. A public IP address is needed for the application to receive Internet traffic.

* **Jumpbox.** Also called a [bastion host]. A secure VM on the network that administrators use to connect to the other VMs. The jumpbox has an NSG that allows remote traffic only from public IP addresses on a safe list. The NSG should permit remote desktop (RDP) traffic.

* **SQL Server Always On Availability Group.** Provides high availability at the data tier, by enabling replication and failover. It uses Windows Server Failover Cluster (WSFC) technology for failover.

* **Active Directory Domain Services (AD DS) Servers**. The computer objects for the failover cluster and its associated clustered roles are created in Active Directory Domain Services (AD DS).

* **Cloud Witness**. A failover cluster requires more than half of its nodes to be running, which is known as having quorum. If the cluster has just two nodes, a network partition could cause each node to think it's the master node. In that case, you need a *witness* to break ties and establish quorum. A witness is a resource such as a shared disk that can act as a tie breaker to establish quorum. Cloud Witness is a type of witness that uses Azure Blob Storage. To learn more about the concept of quorum, see [Understanding cluster and pool quorum](/windows-server/storage/storage-spaces/understand-quorum). For more information about Cloud Witness, see [Deploy a Cloud Witness for a Failover Cluster](/windows-server/failover-clustering/deploy-cloud-witness). 

* **Azure DNS**. [Azure DNS][azure-dns] is a hosting service for DNS domains, providing name resolution using Microsoft Azure infrastructure. By hosting your domains in Azure, you can manage your DNS records using the same credentials, APIs, tools, and billing as your other Azure services.

## Recommendations

Your requirements might differ from the architecture described here. Use these recommendations as a starting point. 

### VNet / Subnets

When you create the VNet, determine how many IP addresses your resources in each subnet require. Specify a subnet mask and a VNet address range large enough for the required IP addresses, using [CIDR] notation. Use an address space that falls within the standard [private IP address blocks][private-ip-space], which are 10.0.0.0/8, 172.16.0.0/12, and 192.168.0.0/16.

Choose an address range that does not overlap with your on-premises network, in case you need to set up a gateway between the VNet and your on-premise network later. Once you create the VNet, you can't change the address range.

Design subnets with functionality and security requirements in mind. All VMs within the same tier or role should go into the same subnet, which can be a security boundary. For more information about designing VNets and subnets, see [Plan and design Azure Virtual Networks][plan-network].

### Load balancers

Do not expose the VMs directly to the Internet, but instead give each VM a private IP address. Clients connect using the public IP address  associated with the Application Gateway.

Define load balancer rules to direct network traffic to the VMs. For example, to enable HTTP traffic, create a rule that maps port 80 from the front-end configuration to port 80 on the back-end address pool. When a client sends an HTTP request to port 80, the load balancer selects a back-end IP address by using a [hashing algorithm][load-balancer-hashing] that includes the source IP address. In that way, client requests are distributed across all the VMs.

### Network security groups

Use NSG rules to restrict traffic between tiers. For example, in the 3-tier architecture shown above, the web tier does not communicate directly with the database tier. To enforce this, the database tier should block incoming traffic from the web tier subnet.  

1. Deny all inbound traffic from the VNet. (Use the `VIRTUAL_NETWORK` tag in the rule.) 
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
   > 

When a SQL client tries to connect, the load balancer routes the connection request to the primary replica. If there is a failover to another replica, the load balancer automatically routes subsequent requests to a new primary replica. For more information, see [Configure an ILB listener for SQL Server Always On Availability Groups][sql-alwayson-ilb].

During a failover, existing client connections are closed. After the failover completes, new connections will be routed to the new primary replica.

If your application makes significantly more reads than writes, you can offload some of the read-only queries to a secondary replica. See [Using a Listener to Connect to a Read-Only Secondary Replica (Read-Only Routing)][sql-alwayson-read-only-routing].

Test your deployment by [forcing a manual failover][sql-alwayson-force-failover] of the availability group.

### Jumpbox

Do not allow RDP access from the public Internet to the VMs that run the application workload. Instead, all RDP access to these VMs must come through the jumpbox. An administrator logs into the jumpbox, and then logs into the other VM from the jumpbox. The jumpbox allows RDP traffic from the Internet, but only from known, safe IP addresses.

The jumpbox has minimal performance requirements, so select a small VM size. Create a [public IP address] for the jumpbox. Place the jumpbox in the same VNet as the other VMs, but in a separate management subnet.

To secure the jumpbox, add an NSG rule that allows RDP connections only from a safe set of public IP addresses. Configure the NSGs for the other subnets to allow RDP traffic from the management subnet.

## Scalability considerations

[VM scale sets][vmss] help you to deploy and manage a set of identical VMs. Scale sets support autoscaling based on performance metrics. As the load on the VMs increases, additional VMs are automatically added to the load balancer. Consider scale sets if you need to quickly scale out VMs, or need to autoscale.

There are two basic ways to configure VMs deployed in a scale set:

- Use extensions to configure the VM after it is provisioned. With this approach, new VM instances may take longer to start up than a VM with no extensions.

- Deploy a [managed disk](/azure/storage/storage-managed-disks-overview) with a custom disk image. This option may be quicker to deploy. However, it requires you to keep the image up to date.

For additional considerations, see [Design considerations for scale sets][vmss-design].

> [!TIP]
> When using any autoscale solution, test it with production-level workloads well in advance.

Each Azure subscription has default limits in place, including a maximum number of VMs per region. You can increase the limit by filing a support request. For more information, see [Azure subscription and service limits, quotas, and constraints][subscription-limits].

## Availability considerations

If you are not using VM scale sets, put VMs in the same tier into an availability set. Create at least two VMs in the availability set to support the [availability SLA for Azure VMs][vm-sla]. For more information, see [Manage the availability of virtual machines][availability-set]. 

The load balancer uses [health probes][health-probes] to monitor the availability of VM instances. If a probe cannot reach an instance within a timeout period, the load balancer stops sending traffic to that VM. However, the load balancer will continue to probe, and if the VM becomes available again, the load balancer resumes sending traffic to that VM.

Here are some recommendations on load balancer health probes:

* Probes can test either HTTP or TCP. If your VMs run an HTTP server, create an HTTP probe. Otherwise create a TCP probe.
* For an HTTP probe, specify the path to an HTTP endpoint. The probe checks for an HTTP 200 response from this path. This can be the root path ("/"), or a health-monitoring endpoint that implements some custom logic to check the health of the application. The endpoint must allow anonymous HTTP requests.
* The probe is sent from a [known IP address][health-probe-ip], 168.63.129.16. Make sure you don't block traffic to or from this IP address in any firewall policies or network security group (NSG) rules.
* Use [health probe logs][health-probe-log] to view the status of the health probes. Enable logging in the Azure portal for each load balancer. Logs are written to Azure Blob storage. The logs show how many VMs on the back end are not receiving network traffic due to failed probe responses.

If you need higher availability than the [Azure SLA for VMs][vm-sla] provides, consider replication the application across two regions, using Azure Traffic Manager for failover. For more information, see [Multi-region N-tier application for high availability][multi-dc].  

## Security considerations

Virtual networks are a traffic isolation boundary in Azure. VMs in one VNet cannot communicate directly with VMs in a different VNet. VMs within the same VNet can communicate, unless you create [network security groups][nsg] (NSGs) to restrict traffic. For more information, see [Microsoft cloud services and network security][network-security].

Consider adding a network virtual appliance (NVA) to create a DMZ between the Internet and the Azure virtual network. NVA is a generic term for a virtual appliance that can perform network-related tasks, such as firewall, packet inspection, auditing, and custom routing. For more information, see [Implementing a DMZ between Azure and the Internet][dmz].

Encrypt sensitive data at rest and use [Azure Key Vault][azure-key-vault] to manage the database encryption keys. Key Vault can store encryption keys in hardware security modules (HSMs). For more information, see [Configure Azure Key Vault Integration for SQL Server on Azure VMs][sql-keyvault]. It's also recommended to store application secrets, such as database connection strings, in Key Vault.

We recommend enabling [DDoS Protection Standard](/azure/virtual-network/ddos-protection-overview), which provides additional DDoS mitigation for resources in a VNet. Although basic DDoS protection is automatically enabled as part of the Azure platform, DDoS Protection Standard provides mitigation capabilities that are tuned specifically to Azure Virtual Network resources.  

## Deploy the solution

A deployment for this reference architecture is available on [GitHub][github-folder]. Note that the entire deployment can take up to two hours, which includes running the scripts to configure AD DS, the Windows Server failover cluster, and the SQL Server availability group.

### Prerequisites

[!INCLUDE [ref-arch-prerequisites.md](../../../includes/ref-arch-prerequisites.md)]

### Deploy the solution

1. Run the following command to create a resource group.

    ```bash
    az group create --location <location> --name <resource-group-name>
    ```

2. Run the following command to create a Storage account for the Cloud Witness.

    ```bash
    az storage account create --location <location> \
      --name <storage-account-name> \
      --resource-group <resource-group-name> \
      --sku Standard_LRS
    ```

3. Navigate to the `virtual-machines\n-tier-windows` folder of the reference architectures GitHub repository.

4. Open the `n-tier-windows.json` file. 

5. Search for all instances of "witnessStorageBlobEndPoint" and replace the placeholder text with the name of the Storage account from step 2.

    ```json
    "witnessStorageBlobEndPoint": "https://[replace-with-storageaccountname].blob.core.windows.net",
    ```

6. Run the following command to list the account keys for the storage account.

    ```bash
    az storage account keys list \
      --account-name <storage-account-name> \
      --resource-group <resource-group-name>
    ```

    The output should look like the following. Copy the value of `key1`.

    ```json
    [
    {
        "keyName": "key1",
        "permissions": "Full",
        "value": "..."
    },
    {
        "keyName": "key2",
        "permissions": "Full",
        "value": "..."
    }
    ]
    ```

7. In the `n-tier-windows.json` file, search for all instances of "witnessStorageAccountKey" and paste in the account key.

    ```json
    "witnessStorageAccountKey": "[replace-with-storagekey]"
    ```

8. In the `n-tier-windows.json` file, search for all instances of `[replace-with-password]` and `[replace-with-sql-password]` replace them with a strong password. Save the file.

    > [!NOTE]
    > If you change the adminstrator user name, you must also update the `extensions` blocks in the JSON file. 

9. Run the following command to deploy the architecture.

    ```bash
    azbb -s <your subscription_id> -g <resource_group_name> -l <location> -p n-tier-windows.json --deploy
    ```

For more information on deploying this sample reference architecture using Azure Building Blocks, visit the [GitHub repository][git].


<!-- links -->
[dmz]: ../dmz/secure-vnet-dmz.md
[multi-dc]: multi-region-sql-server.md
[n-tier]: n-tier.md
[azure-administration]: /azure/automation/automation-intro
[azure-availability-sets]: /azure/virtual-machines/virtual-machines-windows-manage-availability#configure-each-application-tier-into-separate-availability-sets
[azure-cli]: /azure/virtual-machines-command-line-tools
[azure-dns]: /azure/dns/dns-overview
[azure-key-vault]: https://azure.microsoft.com/services/key-vault
[bastion host]: https://en.wikipedia.org/wiki/Bastion_host
[cidr]: https://en.wikipedia.org/wiki/Classless_Inter-Domain_Routing
[chef]: https://www.chef.io/solutions/azure/
[git]: https://github.com/mspnp/template-building-blocks
[github-folder]: https://github.com/mspnp/reference-architectures/tree/master/virtual-machines/n-tier-windows
[nsg]: /azure/virtual-network/virtual-networks-nsg
[operations-management-suite]: https://www.microsoft.com/server-cloud/operations-management-suite/overview.aspx
[plan-network]: /azure/virtual-network/virtual-network-vnet-plan-design-arm
[private-ip-space]: https://en.wikipedia.org/wiki/Private_network#Private_IPv4_address_spaces
[public IP address]: /azure/virtual-network/virtual-network-ip-addresses-overview-arm
[puppet]: https://puppetlabs.com/blog/managing-azure-virtual-machines-puppet
[sql-alwayson]: https://msdn.microsoft.com/library/hh510230.aspx
[sql-alwayson-force-failover]: https://msdn.microsoft.com/library/ff877957.aspx
[sql-alwayson-getting-started]: https://msdn.microsoft.com/library/gg509118.aspx
[sql-alwayson-ilb]: /azure/virtual-machines/windows/sql/virtual-machines-windows-portal-sql-alwayson-int-listener
[sql-alwayson-listeners]: https://msdn.microsoft.com/library/hh213417.aspx
[sql-alwayson-read-only-routing]: https://technet.microsoft.com/library/hh213417.aspx#ConnectToSecondary
[sql-keyvault]: /azure/virtual-machines/virtual-machines-windows-ps-sql-keyvault
[vm-sla]: https://azure.microsoft.com/support/legal/sla/virtual-machines
[vnet faq]: /azure/virtual-network/virtual-networks-faq
[wsfc-whats-new]: https://technet.microsoft.com/windows-server-docs/failover-clustering/whats-new-in-failover-clustering
[Nagios]: https://www.nagios.org/
[Zabbix]: https://www.zabbix.com/
[Icinga]: https://www.icinga.org/
[visio-download]: https://archcenter.blob.core.windows.net/cdn/vm-reference-architectures.vsdx
[0]: ./images/n-tier-sql-server.png "N-tier architecture using Microsoft Azure"
[resource-manager-overview]: /azure/azure-resource-manager/resource-group-overview 
[vmss]: /azure/virtual-machine-scale-sets/virtual-machine-scale-sets-overview
[load-balancer]: /azure/load-balancer/
[load-balancer-hashing]: /azure/load-balancer/load-balancer-overview#load-balancer-features
[vmss-design]: /azure/virtual-machine-scale-sets/virtual-machine-scale-sets-design-overview
[subscription-limits]: /azure/azure-subscription-service-limits
[availability-set]: /azure/virtual-machines/virtual-machines-windows-manage-availability
[health-probes]: /azure/load-balancer/load-balancer-overview#load-balancer-features
[health-probe-log]: /azure/load-balancer/load-balancer-monitor-log
[health-probe-ip]: /azure/virtual-network/virtual-networks-nsg#special-rules
[network-security]: /azure/best-practices-network-security
