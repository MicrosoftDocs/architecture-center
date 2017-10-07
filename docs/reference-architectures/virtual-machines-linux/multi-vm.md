---
title: Run load-balanced VMs on Azure for scalability and availability
description: >-
  How to run multiple Linux VMs on Azure for scalability and availability.

author: MikeWasson

ms.date: 11/22/2016

pnp.series.title: Linux VM workloads
pnp.series.next: n-tier
pnp.series.prev: single-vm
---
# Run load-balanced VMs for scalability and availability

This reference architecture shows a set of proven practices for running several Linux virtual machines (VMs) behind a load balancer, to improve availability and scalability. This architecture can be used for any stateless workload, such as a web server, and is a building block for deploying N-tier applications. [**Deploy this solution**.](#deploy-the-solution) 

![[0]][0]

## Architecture

This architecture builds on the one shown in [Run a Linux VM on Azure][single vm]. The recommendations there also apply to this architecture.

In this architecture, a workload is distributed across several VM instances. There is a single public IP address, and Internet traffic is distributed to the VMs using a load balancer. This architecture can be used for a single-tier application, such as a stateless web application or storage cluster. It's also a building block for N-tier applications. 

The architecture has the following components: 

* **Availability set**. The [availability set][availability set] contains the VMs. This makes the VMs eligible for the [availability service level agreement (SLA) for Azure VMs][vm-sla]. For the SLA to apply, you need a minimum of two VMs in the same availability set. 
* **Virtual network (VNet) and subnet.** Every VM in Azure is deployed into a VNet that is further divided into subnets.
* **Azure Load Balancer**. The [load balancer] distributes incoming Internet requests to the VM instances. The load balancer includes some related resources:
  * **Public IP address**. A public IP address is needed for the load balancer to receive Internet traffic.
  * **Front-end configuration**. Associates the public IP address with the load balancer.
  * **Back-end address pool**. Contains the network interfaces (NICs) for the VMs that will receive the incoming traffic.
* **Load balancer rules**. Used to distribute network traffic among all the VMs in the back-end address pool. 
* **Network address translation (NAT) rules**. Used to route traffic to a specific VM. For example, to enable remote desktop protocol (RDP) to the VMs, create a separate NAT rule for each VM. 
* **Network interfaces (NICs)**. Each VM has a NIC to connect to the network.
* **Storage**. If you are not using [managed disks](/azure/storage/storage-managed-disks-overview), storage accounts hold the VM images and other file-related resources, such as VM diagnostic data captured by Azure.

You can download a [Visio file](https://aka.ms/arch-diagrams) of this architecture.

> [!NOTE]
> Azure has two different deployment models: [Resource Manager][resource-manager-overview] and classic. This article uses Resource Manager, which Microsoft recommends for new deployments.
>

## Recommendations

Your requirements might differ from the architecture described here. Use these recommendations as a starting point. 


### Availability set recommendations

Create at least two VMs in the availability set, to support the [availability SLA for Azure VMs][vm-sla]. The Azure load balancer also requires that load-balanced VMs belong to the same availability set.

Each Azure subscription has default limits in place, including a maximum number of VMs per region. You can increase the limit by filing a support request. For more information, see [Azure subscription and service limits, quotas, and constraints][subscription-limits].  

### Network recommendations

Place the VMs within the same subnet. Do not expose the VMs directly to the Internet, but instead give each VM a private IP address. Clients connect using the public IP address of the load balancer.

### Load balancer recommendations

Add all VMs in the availability set to the back-end address pool of the load balancer.

Define load balancer rules to direct network traffic to the VMs. For example, to enable HTTP traffic, create a rule that maps port 80 from the front-end configuration to port 80 on the back-end address pool. When a client sends an HTTP request to port 80, the load balancer selects a back-end IP address by using a [hashing algorithm][load balancer hashing] that includes the source IP address. In that way, client requests are distributed across all the VMs. 

To route traffic to a specific VM, use NAT rules. For example, to enable RDP to the VMs, create a separate NAT rule for each VM. Each rule should map a distinct port number to port 3389, the default port for RDP. For example, use port 50001 for "VM1," port 50002 for "VM2," and so on. Assign the NAT rules to the NICs on the VMs. 

### Storage account recommendations

Create separate Azure storage accounts for each VM to hold the virtual hard disks (VHDs), in order to avoid hitting the input/output operations per second [(IOPS) limits][vm-disk-limits] for storage accounts.

> [!IMPORTANT]
> We recommend the use of [managed disks](/azure/storage/storage-managed-disks-overview). Managed disks do not require a storage account. You simply specify the size and type of disk and it is deployed in a highly available way. Our [reference architectures](/azure/architecture/reference-architectures/) do not currently deploy managed disks but the [template building blocks](https://github.com/mspnp/template-building-blocks/wiki) will be updated to deploy managed disks in version 2.

Create one storage account for diagnostic logs. This storage account can be shared by all the VMs.

## Scalability considerations

To scale out, provision additional VMs and put them in the load balancer's back-end address pool.  

> [!TIP]
> When you add a new VM to an availability set, make sure to create a NIC for the VM, and add the NIC to the back-end address pool on the load balancer. Otherwise, Internet traffic won't be routed to the new VM.
> 
> 

### VM scale sets

Another option for scaling is to use a [virtual machine scale set][vmss]. VM scale sets help you to deploy and manage a set of identical VMs. Scale sets support autoscaling based on performance metrics. As the load on the VMs increases, additional VMs are automatically added to the load balancer. Consider scale sets if you need to quickly scale out VMs, or need to autoscale. 

By default, scale sets use "overprovisioning," which means the scale set initially provisions more VMs than you ask for, then deletes the extra VMs. This improves the overall success rate when provisioning the VMs. If you are not using [managed disks] (/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-managed-disks), we recommend no more than 20 VMs per storage account with overprovisioning enabled, or no more than 40 VMs with overprovisioning disabled.  

There are two basic ways to configure VMs deployed in a scale set: 

- Use extensions to configure the VM after it is provisioned. With this approach, new VM instances may take longer to start up than a VM with no extensions.

- Deploy a [managed disk](/azure/storage/storage-managed-disks-overview) with a custom disk image. This option may be quicker to deploy. However, it requires you to keep the image up to date.  

For additional considerations, see [Designing VM Scale Sets For Scale][vmss-design].

> [!TIP]
> When using any autoscale solution, test it with production-level work loads well in advance. 
> 
> 

## Availability considerations

The availability set makes your application more resilient to both planned and unplanned maintenance events.

* *Planned maintenance* occurs when Microsoft updates the underlying platform, sometimes causing VMs to be restarted. Azure makes sure the VMs in an availability set are not all restarted at the same time. At least one is kept running while others are restarting.
* *Unplanned maintenance* happens if there is a hardware failure. Azure makes sure that VMs in an availability set are provisioned across more than one server rack. This helps to reduce the impact of hardware failures, network outages, power interruptions, and so on.

For more information, see [Manage the availability of Linux virtual machines][availability set]. The following video also has a good overview of availability sets: [How Do I Configure an Availability Set to Scale VMs][availability set ch9]. 

> [!WARNING]
> Make sure to configure the availability set when you provision the VM. Currently, there is no way to add a Resource Manager VM to an availability set after the VM is provisioned.
> 
 

The load balancer uses [health probes] to monitor the availability of VM instances. If a probe cannot reach an instance within a timeout period, the load balancer stops sending traffic to that VM. However, the load balancer will continue to probe, and if the VM becomes available again, the load balancer resumes sending traffic to that VM.

Here are some recommendations on load balancer health probes:

* Probes can test either HTTP or TCP. If your VMs run an HTTP server, create an HTTP probe. Otherwise create a TCP probe.
* For an HTTP probe, specify the path to an HTTP endpoint. The probe checks for an HTTP 200 response from this path. This can be the root path ("/"), or a health-monitoring endpoint that implements some custom logic to check the health of the application. The endpoint must allow anonymous HTTP requests.
* The probe is sent from a [known][health-probe-ip] IP address, 168.63.129.16. Make sure you don't block traffic to or from this IP in any firewall policies or network security group (NSG) rules.
* Use [health probe logs][health probe log] to view the status of the health probes. Enable logging in the Azure portal for each load balancer. Logs are written to Azure Blob storage. The logs show how many VMs on the back end are not receiving network traffic due to failed probe responses.

## Manageability considerations

With multiple VMs, it is important to automate processes so they are reliable and repeatable. You can use [Azure Automation][azure-automation] to automate deployment, OS patching, and other tasks. [Azure Automation][azure-automation] is an automation service based on Windows Powershell that can be used for this. Example automation scripts are available from the [Runbook Gallery] on TechNet.

## Security considerations

Virtual networks are a traffic isolation boundary in Azure. VMs in one VNet cannot communicate directly to VMs in a different VNet. VMs within the same VNet can communicate, unless you create [network security groups][nsg] (NSGs) to restrict traffic. For more information, see [Microsoft cloud services and network security][network-security].

For incoming Internet traffic, the load balancer rules define which traffic can reach the back end. However, load balancer rules don't support IP safe lists, so if you want to add certain public IP addresses to a safe list, add an NSG to the subnet.

## Deploy the solution

A deployment for this architecture is available on [GitHub][github-folder]. It includes a VNet, NSG, load balancer, and two VMs. It can be deployed with either Windows or Linux VMs. To deploy the architecture, follow these steps: 

1. Click the button below:<br><a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fmspnp%2Freference-architectures%2Fmaster%2Fvirtual-machines%2Fmulti-vm%2Fazuredeploy.json" target="_blank"><img src="http://azuredeploy.net/deploybutton.png"/></a>
2. Once the link has opened in the Azure portal, you must enter values for some of the settings: 
   * The **Resource group** name is already defined in the parameter file, so select **Create new** and enter `ra-multi-vm-rg` in the text box.
   * Select the region from the **Location** drop down box.
   * Do not edit the **Template Root Uri** or the **Parameter Root Uri** text boxes.
   * Select either **windows** or **linux** in the **Os Type** drop down box. 
   * Review the terms and conditions, then click the **I agree to the terms and conditions stated above** checkbox.
   * Click the **Purchase** button.
3. Wait for the deployment to complete.
4. The parameter files include a hard-coded administrator user name and password, and it is strongly recommended that you immediately change both. Click the VM named `ra-multi-vm1` in the Azure portal. Then, click **Reset password** in the **Support + troubleshooting** blade. Select **Reset password** in the **Mode** dropdown box, then select a new **User name** and **Password**. Click the **Update** button to save the new user name and password. Repeat for the VM named `ra-multi-vm2`.




<!-- Links -->
[n-tier-linux]: n-tier.md
[single vm]: single-vm.md

[naming conventions]: /azure/guidance/guidance-naming-conventions

[availability set]: /azure/virtual-machines/virtual-machines-linux-manage-availability
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
[visio-download]: http://download.microsoft.com/download/1/5/6/1569703C-0A82-4A9C-8334-F13D0DF2F472/RAs.vsdx
[vm-disk-limits]: /azure/azure-subscription-service-limits#virtual-machine-disk-limits
[vm-sla]: https://azure.microsoft.com/support/legal/sla/virtual-machines/v1_2/
[vmss]: /azure/virtual-machine-scale-sets/virtual-machine-scale-sets-overview
[vmss-design]: /azure/virtual-machine-scale-sets/virtual-machine-scale-sets-design-overview
[vmss-quickstart]: https://azure.microsoft.com/documentation/templates/?term=scale+set
[0]: ./images/multi-vm-diagram.png "Architecture of a multi-VM solution on Azure comprising an availability set with two VMs and a load balancer"