---
title: Running Windows VMs for an N-tier architecture
description: >-
  How to implement a multi-tier architecture on Azure, paying particular
  attention to availability, security, scalability, and manageability security.

author: MikeWasson

ms.date: 11/22/2016

pnp.series.title: Windows VM workloads
pnp.series.next: multi-region-application
pnp.series.prev: multi-vm
---

# Run Windows VMs for an N-tier application

This reference architecture shows a set of proven practices for running Windows virtual machines (VMs) for an N-tier application. [**Deploy this solution**.](#deploy-the-solution) 

![[0]][0]

*Download a [Visio file][visio-download] of this architecture.*

## Architecture 

There are many ways to implement an N-tier architecture. The diagram shows a typical 3-tier web application. This architecture builds on [Run load-balanced VMs for scalability and availability][multi-vm]. The web and business tiers use load-balanced VMs.

* **Resource group.** [Resource groups][resource-manager-overview] are used to group resources so they can be managed by lifetime, owner, or other criteria.

* **Virtual network (VNet) and subnets.** Every Azure VM is deployed into a VNet that can be segmented into multiple subnets. Create a separate subnet for each tier. 

* **NSGs.** Use [network security groups][nsg] (NSGs) to restrict network traffic within the VNet. For example, in the 3-tier architecture shown here, the database tier does not accept traffic from the web front end, only from the business tier and the management subnet.

* **Availability sets.** Create an [availability set][azure-availability-sets] for each tier, and provision at least two VMs in each tier. This makes the VMs eligible for a higher [service level agreement (SLA)][vm-sla] for VMs. 

* **VM scale set** (not shown). A [VM scale set][vm-scaleset] is an alternative to using an availability set. A scale sets makes it easy to scale out the VMs in a tier, either manually or automatically based on predefined rules.

* **Azure Load balancers.** The [load balancers][load-balancer] distribute incoming Internet requests to the VM instances. Use a [public load balancer][load-balancer-external] to distribute incoming Internet traffic to the web tier, and an [internal load balancer][load-balancer-internal] to distribute network traffic from the web tier to the business tier.

* **Public IP address**. A public IP address is needed for the public load balancer to receive Internet traffic.

* **Jumpbox.** Also called a [bastion host]. A secure VM on the network that administrators use to connect to the other VMs. The jumpbox has an NSG that allows remote traffic only from public IP addresses on a safe list. The NSG should permit remote desktop (RDP) traffic.

* **Azure DNS**. [Azure DNS][azure-dns] is a hosting service for DNS domains, providing name resolution using Microsoft Azure infrastructure. By hosting your domains in Azure, you can manage your DNS records using the same credentials, APIs, tools, and billing as your other Azure services.

## Recommendations

Your requirements might differ from the architecture described here. Use these recommendations as a starting point. 

### VNet / Subnets

When you create the VNet, determine how many IP addresses your resources in each subnet require. Specify a subnet mask and a VNet address range large enough for the required IP addresses, using [CIDR] notation. Use an address space that falls within the standard [private IP address blocks][private-ip-space], which are 10.0.0.0/8, 172.16.0.0/12, and 192.168.0.0/16.

Choose an address range that does not overlap with your on-premises network, in case you need to set up a gateway between the VNet and your on-premise network later. Once you create the VNet, you can't change the address range.

Design subnets with functionality and security requirements in mind. All VMs within the same tier or role should go into the same subnet, which can be a security boundary. For more information about designing VNets and subnets, see [Plan and design Azure Virtual Networks][plan-network].

For each subnet, specify the address space for the subnet in CIDR notation. For example, '10.0.0.0/24' creates a range of 256 IP addresses. VMs can use 251 of these; five are reserved. Make sure the address ranges don't overlap across subnets. See the [Virtual Network FAQ][vnet faq].

Do not expose the VMs directly to the Internet, but instead give each VM a private IP address. Clients connect using the public IP address of the load balancer.

### Load balancer recommendations

Define load balancer rules to direct network traffic to the VMs. For example, to enable HTTP traffic, create a rule that maps port 80 from the front-end configuration to port 80 on the back-end address pool. When a client sends an HTTP request to port 80, the load balancer selects a back-end IP address by using a [hashing algorithm][load-balancer-hashing] that includes the source IP address. In that way, client requests are distributed across all the VMs.

To route traffic to a specific VM, use NAT rules. For example, to enable RDP to the VMs, create a separate NAT rule for each VM. Each rule should map a distinct port number to port 3389, the default port for RDP. For example, use port 50001 for "VM1," port 50002 for "VM2," and so on. Assign the NAT rules to the NICs on the VMs.

### Network security groups

Use NSG rules to restrict traffic between tiers. For example, in the 3-tier architecture shown above, the web tier does not communicate directly with the database tier. To enforce this, the database tier should block incoming traffic from the web tier subnet.  

1. Create an NSG and associate it to the database tier subnet.
2. Add a rule that denies all inbound traffic from the VNet. (Use the `VIRTUAL_NETWORK` tag in the rule.) 
3. Add a rule with a higher priority that allows inbound traffic from the business tier subnet. This rule overrides the previous rule, and allows the business tier to talk to the database tier.
4. Add a rule that allows inbound traffic from within the database tier subnet itself. This rule allows communication between VMs in the database tier, which is needed for database replication and failover.
5. Add a rule that allows RDP traffic from the jumpbox subnet. This rule lets administrators connect to the database tier from the jumpbox.
   
   > [!NOTE]
   > An NSG has default rules that allow any inbound traffic from within the VNet. These rules can't be deleted, but you can override them by creating higher priority rules.
   > 
   > 

### Jumpbox

The jumpbox will have minimal performance requirements, so select a small VM size for the jumpbox such as Standard A1. 

Create a [public IP address] for the jumpbox. Place the jumpbox in the same VNet as the other VMs, but in a separate management subnet.

Do not allow RDP access from the public Internet to the VMs that run the application workload. Instead, all RDP access to these VMs must come through the jumpbox. An administrator logs into the jumpbox, and then logs into the other VM from the jumpbox. The jumpbox allows RDP traffic from the Internet, but only from known, safe IP addresses.

To secure the jumpbox, create an NSG and apply it to the jumpbox subnet. Add an NSG rule that allows RDP connections only from a safe set of public IP addresses. The NSG can be attached either to the subnet or to the jumpbox NIC. In this case, we recommend attaching it to the NIC, so RDP traffic is permitted only to the jumpbox, even if you add other VMs to the same subnet.

Configure the NSGs for the other subnets to allow RDP traffic from the management subnet.

## Scalability considerations

[VM scale sets][vmss] help you to deploy and manage a set of identical VMs. Scale sets support autoscaling based on performance metrics. As the load on the VMs increases, additional VMs are automatically added to the load balancer. Consider scale sets if you need to quickly scale out VMs, or need to autoscale.

By default, scale sets use "overprovisioning," which means the scale set initially provisions more VMs than you ask for, then deletes the extra VMs. This improves the overall success rate when provisioning the VMs. If you are not using [managed disks](/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-managed-disks), we recommend no more than 20 VMs per storage account with overprovisioning enabled, and no more than 40 VMs with overprovisioning disabled.

There are two basic ways to configure VMs deployed in a scale set:

- Use extensions to configure the VM after it is provisioned. With this approach, new VM instances may take longer to start up than a VM with no extensions.

- Deploy a [managed disk](/azure/storage/storage-managed-disks-overview) with a custom disk image. This option may be quicker to deploy. However, it requires you to keep the image up to date.

For additional considerations, see [Design considerations for scale sets][vmss-design].

> [!TIP]
> When using any autoscale solution, test it with production-level workloads well in advance.

If you do not use a scale set, place VMs in the same tier into an  availability set. Create at least two VMs in the availability set to support the [availability SLA for Azure VMs][vm-sla]. The Azure load balancer also requires that load-balanced VMs belong to the same availability set.

Each Azure subscription has default limits in place, including a maximum number of VMs per region. You can increase the limit by filing a support request. For more information, see [Azure subscription and service limits, quotas, and constraints][subscription-limits].


## Availability considerations

An availability set makes your application more resilient to both planned and unplanned maintenance events.

* *Planned maintenance* occurs when Microsoft updates the underlying platform, sometimes causing VMs to be restarted. Azure makes sure the VMs in an availability set are not all restarted at the same time. At least one is kept running while others are restarting.
* *Unplanned maintenance* happens if there is a hardware failure. Azure makes sure that VMs in an availability set are provisioned across more than one server rack. This helps to reduce the impact of hardware failures, network outages, power interruptions, and so on.

For more information, see [Manage the availability of virtual machines][availability-set]. The following video also provides a good overview of availability sets: [How Do I Configure an Availability Set to Scale VMs][availability-set-ch9].

> [!WARNING]
> Make sure to configure the availability set when you provision the VM. Currently, there is no way to add a Resource Manager VM to an availability set after the VM is provisioned.

The load balancer uses [health probes][health-probes] to monitor the availability of VM instances. If a probe cannot reach an instance within a timeout period, the load balancer stops sending traffic to that VM. However, the load balancer will continue to probe, and if the VM becomes available again, the load balancer resumes sending traffic to that VM.

Here are some recommendations on load balancer health probes:

* Probes can test either HTTP or TCP. If your VMs run an HTTP server, create an HTTP probe. Otherwise create a TCP probe.
* For an HTTP probe, specify the path to an HTTP endpoint. The probe checks for an HTTP 200 response from this path. This can be the root path ("/"), or a health-monitoring endpoint that implements some custom logic to check the health of the application. The endpoint must allow anonymous HTTP requests.
* The probe is sent from a [known IP address][health-probe-ip], 168.63.129.16. Make sure you don't block traffic to or from this IP address in any firewall policies or network security group (NSG) rules.
* Use [health probe logs][health-probe-log] to view the status of the health probes. Enable logging in the Azure portal for each load balancer. Logs are written to Azure Blob storage. The logs show how many VMs on the back end are not receiving network traffic due to failed probe responses.


At the database tier, having multiple VMs does not automatically translate into a highly available database. For a relational database, you will typically need to use replication and failover to achieve high availability. For SQL Server, we recommend using [Always On Availability Groups][sql-alwayson]. 

If you need higher availability than the [Azure SLA for VMs][vm-sla] provides, replicate the application across two regions and use Azure Traffic Manager for failover. For more information, see [Run Windows VMs in multiple regions for high availability][multi-dc].   

## Security considerations

Virtual networks are a traffic isolation boundary in Azure. VMs in one VNet cannot communicate directly with VMs in a different VNet. VMs within the same VNet can communicate, unless you create [network security groups][nsg] (NSGs) to restrict traffic. For more information, see [Microsoft cloud services and network security][network-security].

For incoming Internet traffic, the load balancer rules define which traffic can reach the back end. However, load balancer rules don't support IP safe lists, so if you want to add certain public IP addresses to a safe list, add an NSG to the subnet.

Consider adding a network virtual appliance (NVA) to create a DMZ between the Internet and the Azure virtual network. NVA is a generic term for a virtual appliance that can perform network-related tasks, such as firewall, packet inspection, auditing, and custom routing. For more information, see [Implementing a DMZ between Azure and the Internet][dmz].

## Manageability considerations

Simplify management of the entire system by using centralized administration tools such as [Azure Automation][azure-administration], [Microsoft Operations Management Suite][operations-management-suite], [Chef][chef], or [Puppet][puppet]. These tools can consolidate diagnostic and health information captured from multiple VMs to provide an overall view of the system.

## Deploy the solution

A deployment for this reference architecture is available on [GitHub][github-folder]. 

### Prerequisites

Before you can deploy the reference architecture to your own subscription, you must perform the following steps.

1. Clone, fork, or download the zip file for the [reference architectures][ref-arch-repo] GitHub repository.

2. Make sure you have the Azure CLI 2.0 installed on your computer. To install the CLI, follow the instructions in [Install Azure CLI 2.0][azure-cli-2].

3. Install the [Azure building blocks][azbb] npm package.

  ```bash
  npm install -g @mspnp/azure-building-blocks
  ```

4. From a command prompt, bash prompt, or PowerShell prompt, login to your Azure account by using one of the commands below, and follow the prompts.

  ```bash
  az login
  ```

### Deploy the solution using azbb

To deploy the Windows VMs for an N-tier application reference architecture, follow these steps:

1. Navigate to the `virtual-machines\n-tier-windows` folder for the repository you cloned in step 1 of the pre-requisites above.

2. The parameter file specifies a default adminstrator user name and password for each VM in the deployment. You must change these before you deploy the reference architecture. Open the `n-tier-windows.json` file and replace each **adminUsername** and **adminPassword** field with your new settings.
  
  > [!NOTE]
  > There are multiple scripts that run during this deployment both in the  **VirtualMachineExtension** objects and in the **extensions** settings for some of the **VirtualMachine** objects. Some of these scripts require the administrator user name and password that you have just changed. It's recommended that you review these scripts to ensure that you specified the correct credentials. The deployment may fail if you have not specified the correct credentials.
  > 
  > 

Save the file.

3. Deploy the reference architecture using the **azbb** command line tool as shown below.

  ```bash
  azbb -s <your subscription_id> -g <your resource_group_name> -l <azure region> -p n-tier-windows.json --deploy
  ```

For more information on deploying this sample reference architecture using Azure Building Blocks, visit the [GitHub repository][git].


<!-- links -->
[dmz]: ../dmz/secure-vnet-dmz.md
[multi-dc]: multi-region-application.md
[multi-vm]: multi-vm.md
[n-tier]: n-tier.md
[azbb]: https://github.com/mspnp/template-building-blocks/wiki/Install-Azure-Building-Blocks
[azure-administration]: /azure/automation/automation-intro
[azure-availability-sets]: /azure/virtual-machines/virtual-machines-windows-manage-availability#configure-each-application-tier-into-separate-availability-sets
[azure-cli]: /azure/virtual-machines-command-line-tools
[azure-cli-2]: https://docs.microsoft.com/cli/azure/install-azure-cli?view=azure-cli-latest
[azure-dns]: /azure/dns/dns-overview
[azure-key-vault]: https://azure.microsoft.com/services/key-vault
[bastion host]: https://en.wikipedia.org/wiki/Bastion_host
[cidr]: https://en.wikipedia.org/wiki/Classless_Inter-Domain_Routing
[chef]: https://www.chef.io/solutions/azure/
[git]: https://github.com/mspnp/template-building-blocks
[github-folder]: https://github.com/mspnp/reference-architectures/tree/master/virtual-machines/n-tier-windows
[lb-external-create]: /azure/load-balancer/load-balancer-get-started-internet-portal
[lb-internal-create]: /azure/load-balancer/load-balancer-get-started-ilb-arm-portal
[load-balancer-external]: /azure/load-balancer/load-balancer-internet-overview
[load-balancer-internal]: /azure/load-balancer/load-balancer-internal-overview
[nsg]: /azure/virtual-network/virtual-networks-nsg
[operations-management-suite]: https://www.microsoft.com/server-cloud/operations-management-suite/overview.aspx
[plan-network]: /azure/virtual-network/virtual-network-vnet-plan-design-arm
[private-ip-space]: https://en.wikipedia.org/wiki/Private_network#Private_IPv4_address_spaces
[public IP address]: /azure/virtual-network/virtual-network-ip-addresses-overview-arm
[puppet]: https://puppetlabs.com/blog/managing-azure-virtual-machines-puppet
[ref-arch-repo]: https://github.com/mspnp/reference-architectures
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
[Zabbix]: http://www.zabbix.com/
[Icinga]: http://www.icinga.org/
[visio-download]: https://archcenter.blob.core.windows.net/cdn/vm-reference-architectures.vsdx
[0]: ./images/n-tier-diagram.png "N-tier architecture using Microsoft Azure"