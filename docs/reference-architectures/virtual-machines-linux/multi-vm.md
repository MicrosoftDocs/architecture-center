---
title: Run load-balanced VMs on Azure for scalability and availability
description: >-
  How to run multiple Linux VMs on Azure for scalability and availability.

author: telmosampaio

ms.date: 09/07/2017

pnp.series.title: Linux VM workloads
pnp.series.next: n-tier
pnp.series.prev: single-vm
---

# Run load-balanced VMs for scalability and availability

This reference architecture shows a set of proven practices for running several Linux virtual machines (VMs) in a scale set behind a load balancer, to improve availability and scalability. This architecture can be used for any stateless workload, such as a web server, and is a building block for deploying n-tier applications. [**Deploy this solution**.](#deploy-the-solution)

![[0]][0]

*Download a [Visio file][visio-download] of this architecture.*

## Architecture

This architecture builds on the one shown in [Run a Linux VM on Azure][single vm]. The recommendations there also apply to this architecture.

In this architecture, a workload is distributed across several VM instances. There is a single public IP address, and Internet traffic is distributed to the VMs using a load balancer. This architecture can be used for a single-tier application, such as a stateless web application.

The architecture has the following components:

* **Resource group.** [*Resource groups*][resource-manager-overview] are used to group resources so they can be managed by lifetime, owner, and other criteria.
* **Virtual network (VNet) and subnet.** Every VM in Azure is deployed into a VNet that is further divided into subnets.
* **Azure Load Balancer**. The [load balancer] distributes incoming Internet requests to the VM instances. 
* **Public IP address**. A public IP address is needed for the load balancer to receive Internet traffic.
* **VM scale set**. A [VM scale set][vm-scaleset] is a set of identical VMs used to host a workload. Scale sets allow the number of VMs to be scaled in or out manually, or based on predefined rules.
* **Availability set**. The [availability set][availability set] contains the VMs, making the VMs eligible for a higher [service level agreement (SLA)][vm-sla]. For the higher SLA to apply, the availability set must include a minimum of two VMs. Availability sets are implicit in scale sets. If you create VMs outside a scale set, you need to create the availability set independently.
* **Managed disks**. Azure Managed Disks manage the virtual hard disk (VHD) files for the VM disks. 
* **Storage**. Create an Azure Storage acount to hold diagnostic logs for the VMs.

## Recommendations

Your requirements might differ from the architecture described here. Use these recommendations as a starting point. 

### Availability and scalability recommendations

An option for availability and scalability is to use a [virtual machine scale set][vmss]. VM scale sets help you to deploy and manage a set of identical VMs. Scale sets support autoscaling based on performance metrics. As the load on the VMs increases, additional VMs are automatically added to the load balancer. Consider scale sets if you need to quickly scale out VMs, or need to autoscale.

By default, scale sets use "overprovisioning," which means the scale set initially provisions more VMs than you ask for, then deletes the extra VMs. This improves the overall success rate when provisioning the VMs. If you are not using [managed disks](/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-managed-disks), we recommend no more than 20 VMs per storage account with overprovisioning enabled, or no more than 40 VMs with overprovisioning disabled.

There are two basic ways to configure VMs deployed in a scale set:

- Use extensions to configure the VM after it is provisioned. With this approach, new VM instances may take longer to start up than a VM with no extensions.

- Deploy a [managed disk](/azure/storage/storage-managed-disks-overview) with a custom disk image. This option may be quicker to deploy. However, it requires you to keep the image up to date.

For additional considerations, see [Design considerations for scale sets][vmss-design].

> [!TIP]
> When using any autoscale solution, test it with production-level workloads well in advance.

If you do not use a scale set, consider at least using an availability set. Create at least two VMs in the availability set, to support the [availability SLA for Azure VMs][vm-sla]. The Azure load balancer also requires that load-balanced VMs belong to the same availability set.

Each Azure subscription has default limits in place, including a maximum number of VMs per region. You can increase the limit by filing a support request. For more information, see [Azure subscription and service limits, quotas, and constraints][subscription-limits].

### Network recommendations

Place the VMs within the same subnet. Do not expose the VMs directly to the Internet, but instead give each VM a private IP address. Clients connect using the public IP address of the load balancer.

If you need to log into the VMs behind the load balancer, consider adding a single VM as a bastion host/jumpbox with a public IP address you can log into. And then log into the VMs behind the load balancer from the jumpbox. Alternatively, configure inbound NAT rules in the load balancer for the same purpose. However, having a jumpbox is a better solution when you are hosting n-tier workloads, or multiple workloads.

### Load balancer recommendations

Add all VMs in the availability set to the back-end address pool of the load balancer.

Define load balancer rules to direct network traffic to the VMs. For example, to enable HTTP traffic, create a rule that maps port 80 from the front-end configuration to port 80 on the back-end address pool. When a client sends an HTTP request to port 80, the load balancer selects a back-end IP address by using a [hashing algorithm][load balancer hashing] that includes the source IP address. In that way, client requests are distributed across all the VMs.

To route traffic to a specific VM, use NAT rules. For example, to enable RDP to the VMs, create a separate NAT rule for each VM. Each rule should map a distinct port number to port 3389, the default port for RDP. For example, use port 50001 for "VM1," port 50002 for "VM2," and so on. Assign the NAT rules to the NICs on the VMs.

### Storage account recommendations

Create separate Azure storage accounts for each VM to hold the virtual hard disks (VHDs), in order to avoid hitting the input/output operations per second [(IOPS) limits][vm-disk-limits] for storage accounts.

We recommend the use of [managed disks](/azure/storage/storage-managed-disks-overview) with [premium storage][premium]. Managed disks do not require a storage account. You simply specify the size and type of disk and it is deployed in a highly available way.

Create one storage account for diagnostic logs. This storage account can be shared by all the VMs. This can be an unmanaged storage account using standard disks.

## Availability considerations

The availability set makes your application more resilient to both planned and unplanned maintenance events.

* *Planned maintenance* occurs when Microsoft updates the underlying platform, sometimes causing VMs to be restarted. Azure makes sure the VMs in an availability set are not all restarted at the same time. At least one is kept running while others are restarting.
* *Unplanned maintenance* happens if there is a hardware failure. Azure makes sure that VMs in an availability set are provisioned across more than one server rack. This helps to reduce the impact of hardware failures, network outages, power interruptions, and so on.

For more information, see [Manage the availability of virtual machines][availability set]. The following video also has a good overview of availability sets: [How Do I Configure an Availability Set to Scale VMs][availability set ch9].

> [!WARNING]
> Make sure to configure the availability set when you provision the VM. Currently, there is no way to add a Resource Manager VM to an availability set after the VM is provisioned.

The load balancer uses [health probes] to monitor the availability of VM instances. If a probe cannot reach an instance within a timeout period, the load balancer stops sending traffic to that VM. However, the load balancer will continue to probe, and if the VM becomes available again, the load balancer resumes sending traffic to that VM.

Here are some recommendations on load balancer health probes:

* Probes can test either HTTP or TCP. If your VMs run an HTTP server, create an HTTP probe. Otherwise create a TCP probe.
* For an HTTP probe, specify the path to an HTTP endpoint. The probe checks for an HTTP 200 response from this path. This can be the root path ("/"), or a health-monitoring endpoint that implements some custom logic to check the health of the application. The endpoint must allow anonymous HTTP requests.
* The probe is sent from a [known][health-probe-ip] IP address, 168.63.129.16. Make sure you don't block traffic to or from this IP in any firewall policies or network security group (NSG) rules.
* Use [health probe logs][health probe log] to view the status of the health probes. Enable logging in the Azure portal for each load balancer. Logs are written to Azure Blob storage. The logs show how many VMs on the back end are not receiving network traffic due to failed probe responses.

## Manageability considerations

With multiple VMs, it is important to automate processes so they are reliable and repeatable. You can use [Azure Automation][azure-automation] to automate deployment, OS patching, and other tasks.

## Security considerations

Virtual networks are a traffic isolation boundary in Azure. VMs in one VNet cannot communicate directly to VMs in a different VNet. VMs within the same VNet can communicate, unless you create [network security groups][nsg] (NSGs) to restrict traffic. For more information, see [Microsoft cloud services and network security][network-security].

For incoming Internet traffic, the load balancer rules define which traffic can reach the back end. However, load balancer rules don't support IP safe lists, so if you want to add certain public IP addresses to a safe list, add an NSG to the subnet.

## Deploy the solution

A deployment for this architecture is available on [GitHub][github-folder]. It includes a VNet, NSG, and three VMs in a scale set behind a load balancer, described below:

  * A virtual network with a single subnet named **web** used to host the VMs.
  * A VM scale set that contains VMs running the latest version of Windows Server 2016 Datacenter Edition. Autoscale is enabled.
  * A load balancer that sits in front of the VM scale set.
  * An NSG with incoming rules to allow HTTP traffic to the VM scale set.

### Prerequisites

Before you can deploy the reference architecture to your own subscription, you must perform the following steps.

1. Clone, fork, or download the zip file for the [AzureCAT reference architectures][ref-arch-repo] GitHub repository.

2. Make sure you have the Azure CLI 2.0 installed on your computer. To install the CLI, follow the instructions in [Install Azure CLI 2.0][azure-cli-2].

3. Install the [Azure building blocks][azbb] npm package.

4. From a command prompt, bash prompt, or PowerShell prompt, login to your Azure account by using one of the commands below, and follow the prompts.

  ```bash
  az login
  ```

### Deploy the solution using azbb

To deploy the sample single VM workload, follow these steps:

1. Navigate to the `virtual-machines\multi-vm\parameters\linux` folder for the repository you downloaded in the pre-requisites step above.

2. Open the `multi-vm-v2.json` file and enter a username and SSH key between the quotes, as shown below, then save the file.

  ```bash
  "adminUsername": "",
  "sshPublicKey": "",
  ```

3. Run `azbb` to deploy the VMs as shown below.

  ```bash
  azbb -s <subscription_id> -g <resource_group_name> -l <location> -p multi-vm-v2.json --deploy
  ```

For more information on deploying this sample reference architecture, visit our [GitHub repository][git].

<!-- Links -->
[github-folder]: http://github.com/mspnp/reference-architectures/tree/master/virtual-machines/multi-vm
[ref-arch-repo]: https://github.com/mspnp/reference-architectures
[n-tier-linux]: ../virtual-machines-linux/n-tier.md
[n-tier-windows]: n-tier.md
[single vm]: single-vm.md
[premium]: /azure/storage/common/storage-premium-storage
[naming conventions]: /azure/guidance/guidance-naming-conventions
[vm-scaleset]: /azure/virtual-machine-scale-sets/virtual-machine-scale-sets-overview
[availability set]: /azure/virtual-machines/virtual-machines-windows-manage-availability
[availability set ch9]: https://channel9.msdn.com/Series/Microsoft-Azure-Fundamentals-Virtual-Machines/08
[azure-automation]: https://azure.microsoft.com/documentation/services/automation/
[azure-cli]: /azure/virtual-machines-command-line-tools
[azure-automation]: /azure/automation/automation-intro
[bastion host]: https://en.wikipedia.org/wiki/Bastion_host
[github-folder]: https://github.com/mspnp/reference-architectures/tree/master/virtual-machines/multi-vm
[health probe log]: /azure/load-balancer/load-balancer-monitor-log
[health probes]: /azure/load-balancer/load-balancer-overview#load-balancer-features
[health-probe-ip]: /azure/virtual-network/virtual-networks-nsg#special-rules
[load balancer]: /azure/load-balancer/load-balancer-get-started-internet-arm-cli
[load balancer hashing]: /azure/load-balancer/load-balancer-overview#load-balancer-features
[network-security]: /azure/best-practices-network-security
[nsg]: /azure/virtual-network/virtual-networks-nsg
[resource-manager-overview]: /azure/azure-resource-manager/resource-group-overview 
[Runbook Gallery]: /azure/automation/automation-runbook-gallery#runbooks-in-runbook-gallery
[subscription-limits]: /azure/azure-subscription-service-limits
[visio-download]: https://archcenter.azureedge.net/cdn/vm-reference-architectures.vsdx
[vm-disk-limits]: /azure/azure-subscription-service-limits#virtual-machine-disk-limits
[vm-sla]: https://azure.microsoft.com/support/legal/sla/virtual-machines/v1_2/
[vmss]: /azure/virtual-machine-scale-sets/virtual-machine-scale-sets-overview
[vmss-design]: /azure/virtual-machine-scale-sets/virtual-machine-scale-sets-design-overview
[vmss-quickstart]: https://azure.microsoft.com/documentation/templates/?term=scale+set
[VM-sizes]: https://azure.microsoft.com/documentation/articles/virtual-machines-windows-sizes/
[0]: ./images/multi-vm-diagram.png "Architecture of a multi-VM solution on Azure comprising an availability set with two VMs and a load balancer"
[azure-cli-2]: /azure/install-azure-cli?view=azure-cli-latest
[azbb]: https://github.com/mspnp/template-building-blocks/wiki/Install-Template-Building-Blocks-Version-2-(Linux)
[git]: https://github.com/mspnp/reference-architectures/tree/master/virtual-machines/multi-vm