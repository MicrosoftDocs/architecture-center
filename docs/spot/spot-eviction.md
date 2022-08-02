---
title: Azure Virtual Machine Spot Eviction
description: Learn about Spot Eviction and how to architect for and handle eviction notices. 
author: ju-shim
ms.author: jushiman
ms.date: 08/01/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - power-platform
  - power-apps
categories:
  - integration
  - web
  - devops
---

# Azure Virtual Machine Spot Eviction

You can take advantage of Azure's unused capacity at a significant cost savings by using Spot virtual machines (VM) and scale sets. However, at any point in time when Azure needs the capacity back, the Azure infrastructure will evict Azure Spot VMs. Therefore, Azure Spot VMs are great for workloads that can handle interruptions like batch processing jobs, dev/test environments, and large compute workloads. This guide is meant to walk you through Azure Spot Eviction fundamentals and help you design a solution to support workload interruptions.

## Cost

Azure provisions its spare capacity along all its offered regions so it can respond on demand when new resources are created. While that capacity remains idle, you have an opportunity to deploy VMs in your subscription at [discount prices and capped at pay-as-you-go prices using Azure Spot VMs and virtual machine scale sets](https://azure.microsoft.com/pricing/spot-advisor/).

Keeping operational expenses under control is common practice when running solutions on the cloud and the [cost optimizations pillar from the Well Architected Framework](/azure/architecture/framework/cost/overview) can help you find the right strategy for your architecture.

## Purpose

While the number one reason to choose Azure Spot is the significant cost savings at the infrastructure level, keep in mind that you need to build reliable **interruptible** workloads that can run on top of this Azure managed service.

The goal is to design a framework that is fault tolerant and resilient, so that it's capable of being unexpectedly and reliably interrupted. Successful designs have workloads that are able to deal with high levels of uncertainty at the time of being deployed and can recover after being forcedly shut down. Even better, they can gracefully shut down with under 30 seconds of notification prior to eviction.

## Potential workloads

Some good candidates to run on top of Azure Spot VMs are:

- Batch processing applications
- Workloads that aren't time critical for background processing jobs
- Large workloads that aren't required to finish in a certain period of time (ex. data analytics)
- Tasks that are optional or have lower priority (ex. spawning a CI/CD agent for a dev/test environment)
- Short lived jobs that can lose their progress repeatedly without having an effect on the end result

Azure Virtual Machine Scale Sets are also offered with priority **Spot** and is an underlying service that will represent nodes for an Azure Kubernetes Service (AKS) cluster. As a result, stateless applications and opportunistic scale-out scenarios are possible candidates to build with Azure Spot virtual machine scale sets in mind if they're meant to run from an AKS cluster. The AKS use case is out of scope in this reference implementation.

Avoid using Azure Spot if:

- Your application is under a strict SLA that could be compromised by compute interruptions
- You're planning to provision sticky session solutions
- Your workload isn't designed to be interrupted
- Your workload is stateful by nature

## Considerations

We recommend that any `production` workloads keep a guaranteed number of Azure VM instances with **Regular Priority** in addition to VMs with **Spot priority**. This way you can optimize your costs and remain in compliance with your application SLA. If your workload is capable of being consistently interrupted and it doesn't need an SLA, you might consider going full **Spot Priority** even in `production`.

Azure Spot VM and scale sets are compute infrastructure as a service (IaaS) available in Azure that serves without an SLA once created. This means that it can be terminated at any moment with *up to* 30 seconds of notification. In other words, at any point in time when Azure needs the capacity back, the Azure infrastructure will evict the service by deallocating or deleting the resources based on your configured eviction policy.

You're acquiring unused (if any) ephemeral compute capacity that offers no high availability guarantees. Given that, Azure Spot VM and scale sets are a limited resource that won’t always be at your disposal.

## Spot VM states

Azure Spot VM and scale sets instances will transition states and your workload must be able to behave accordingly. The diagram below visualizes the following states:

1. Stopped or Deleted (eviction policy based)
1. Running (based on capacity and max price you set)

<!--- new diagram here --->
![State diagram depicting how Azure VM Spot VM and scale sets behaves depending on policy, capacity ad price.](/media/spot-state-diagram.png)

The following table breaks down the expected outcome and state for a Spot VM based on the VMs current state, the input it receives from the Azure infrastructure, and the conditions you set (price limits and eviction policy).

| Current State  | Input   | Conditions                                                                     | Next State | Output                                                                                                               |
|----------------|---------|------------------------------------------------------------------------------- |------------|----------------------------------------------------------------------------------------------------------------------|
| *              | Deploy  | Max Price >= Current Price and Capacity = Available                            | Running    | You pay the Max Price you set and underlying disks                                                                  |
| Running        | Evict   | Max Price =  -1            and Capacity = Available                            | Running    | You pay the VM Price and underlying disks                                                                           |
| Running        | Evict   |                                Capacity = Unavailable and Policy = Deallocate  | Stopped     | Compute capacity gets deallocated while you pay for underlying disk. It's possible to restart the machine          |
| Running        | Evict   |                                Capacity = Unavailable and Policy = Delete      | Deleted    | You're not charged at this point since disks are deleted                                                            |
| Running        | Evict   | Max Price <  Current Price                            and Policy = Deallocate  | Stopped     | You pay for underlying disk and can restart the machine                                                             |
| Running        | Evict   | Max Price <  Current Price                            and Policy = Delete      | Delete     | You're not charged at this point since disks are deleted                                                            |
| Stopped         | Restart | Max Price <  Current Price                            and Policy = Deallocate  | Stopped     | You pay for underlying disk and can restart the machine                                                             |
| Stopped         | Restart | Max Price <  Current Price                            and Policy = Delete      | Delete     | You're not charged at this point since disks are deleted                                                            |
| Stopped         | Restart | Max Price >= Current Price and Capacity = Available                            | Running    | You pay the Max Price you set and underlying disks                                                                  |

> [!IMPORTANT]
> If a constraint capacity event occurs at a particular location and/or the current market price surpass the Max Price you set, the Azure infrastructure will collect its compute capacity for the Azure Spot VM according to your configured **Eviction Policy**. If you configured your Azure Spot VM for **deallocation** under an eviction event, it's the application operator's responsibility to automatically or manually restart the Azure Spot VM once the capacity becomes available.

## Concepts

There are several important considerations when building on top of Azure Spot VM instances. 

### Subscription Limits

There are 20 cores per subscription by default. Some subscriptions aren't supported. Take a look at the list of supported types for more information. <!--- Insert link to list here. --->

### Eviction

There are several conditions that affect an eviction. The following list goes into detail on every element you should consider.

1. **Rate** - The rate is nothing more but the chances of being evicted at a specific location. It's common to choose the location based on the eviction rate by SKU. To help with the selection process, query the [pricing history view in the Azure portal](/azure/virtual-machines/spot-vms#pricing-and-eviction-history) in addition to [Azure Spot advisor](https://azure.microsoft.com/pricing/spot-advisor/).

1. **Type** - You can choose between **Max Price or Capacity** or **Capacity Only**.
    1. **Capacity** - When using Azure Spot virtual machine scale sets with **Manual** scaling, a good practice is to enable the **Try to Restore** option if your policy eviction is **Deallocate**. If the Azure infrastructure evicted and took back capacity, this configuration looks for those clusters that have the most spare capacity. If space capacity is located, the configuration will attempt to redeploy your deallocated instances on top of them. This configuration provides your Azure Spot virtual machine scale sets with better chances of surviving next time an eviction event kicks in. When configured with **Autoscale**, this option isn't available as this implements its own logic to reallocate instances.
        1. VM Configuration: as flexible as choosing the SKU, the better are chances to allocate Azure Spot VM and scale sets. Some SKU(s) like B-series or Promo versions of any size aren't supported.
        1. Location: same as in SKU, if your workload can run from any region, it improves the chances to be deployed as well as with fewer chances of being deallocated if you choose carefully considering the eviction rates. Take into account that Microsoft Azure China 21Vianet isn't supported.
        1. Time of the day, weekends, seasons, and other time based considerations are important factors when making a final decision between Azure Spot over regular VMs and scale sets.
    1. **Current VM Price vs Max Price** (you set): if you're willing to pay up to the **Pay as you go** rate, it's possible to prevent being evicted based on pricing reasons by setting the **Max Price** to `-1`, which is known as **Eviction Type Capacity Only**. If pricing is a constraint for your business organization goals, **Eviction Type Max Price or Capacity Only** is recommended instead, and in this case you can adjust the right **Max Price** at any moment by taking into account that changing this value requires to deallocate the VM or scale set first to take effect. If you choose the latter, it's a good idea to analyze the price history, and **Eviction Rate** for the regions you're targeting.

1. **Policy**:
    1. Delete
        1. You free up the Cores from your Subscription
        1. You're not longer charged for the disk as they get deleted along with the Azure Spot VM
        1. Shared subscriptions or multiple workloads using Azure Spot VM instances can befitted from the policy
    1. Deallocate
        1. Change VM state to the stopped-deallocated state
        1. Allowing you to redeploy it later.
        1. You're still being charge for the underlying disks
        1. It consumes Cores quota from your Subscription

1. **Simulation** - It's possible to [simulate an eviction event](/azure/virtual-machines/spot-portal#simulate-an-eviction.md) when Azure needs the capacity back. We recommend you become familiar with this concept so that you can simulate interruptions from dev/test environments to guarantee your workload is fully interruptible before deploying to production.

### Events

[Azure Scheduled Events](/azure/virtual-machines/windows/scheduled-events.md) is a metadata service in Azure that signal about forthcoming events associated to the Virtual Machine resource type. The general recommendation when using Virtual Machines is to routinely query this endpoint to discover when maintenance will occur, so you're given the opportunity to prepare for disruption. One of the platform event types being scheduled that you'll want to notice is `Preempt` as this signals the imminent eviction of your spot instance. This event is scheduled with a minimum amount of time of 30 seconds in the future. Given that, you must assume that you're going to have less than that amount of time to limit the impact. The recommended practice here is to check this endpoint based on the periodicity your workload mandates (every 10 seconds) to attempt having a graceful interruption.

### Metadata APIs

You can use the [Retail Rates Prices API](/rest/api/cost-management/retail-prices/azure-retail-prices) to get retail prices for all Azure services.


## The Workload

One workload types to consider for Azure Spot VMs are [Batch processing apps](/azure/batch). This reference implementation guide contains a simple asynchronously queue-processing worker (C#, .NET 6) implemented in combination with [Azure Queue Storage](/azure/storage/queues/storage-queues-introduction). This guide demonstrates how to query the [Azure Scheduled Events REST](/virtual-machines/linux/scheduled-events) endpoint. The endpoint allows your workload to receive a signal prior to eviction so that it can anticipate the disruption event, prepare for the interruption, and limit its impact.

### Planning for being Fault Tolerant

#### Application states

When building reliable and interruptible workloads, you'll be focused on four main stages during the workload lifecycle. These stages will translate into changes of states within your application.

1. **Start**: After the application `warmup` state is completed, you could consider internally transitioning into the `processing` state. One important thing to consider is if there was a forced shutdown previously, then there might be some incomplete processing and we recommend that you implement idempotency as applicable. Additionally, it's good practice to save the context by creating checkpoints regularly. Doing so will create a more efficient recovery strategy, which is to recover from the latest well-known checkpoint instead of starting all over on processing.

1. **Shutdown**: Your application is in the `processing` state and at the same time an eviction event is triggered by the Azure infrastructure. Compute capacity must be collected from Azure Spot instances, and as a result, an eviction notice will take place in your application. At this time, your application will change its state to `evicted` and implement the logic that responds to the eviction notice. It will gracefully shut down within 30 secs by releasing resources such us draining connections and event logging, or it will prepare to be forcedly deallocated or deleted based on your **Eviction Policy**. In the latter configuration, as a general rule, you can't persist any progress or data on the file system, because disks are being removed along with the Azure VM.

1. **Recover**: In this stage, your workload is `redeployed` or `recreated` depending on your **Eviction Policy**. During recovery, these possible states are detected based on your scenario. You can implement the logic to deal with a prior forced shutdown, so your application is able to recover from a previous backup or checkpoint if necessary.

1. **Resume**: The application is about to continue processing after a best effort to recover the context prior to eviction. It's good idea to transition into a `warmup` state to ensure the workload is healthy and ready to start.

<!--- new diagram here --->
![A workload lifecycle diagram depicting the four possible stages interruptible workloads should contemplate during their lifetime]()

> [!NOTE]
> The aforementioned states are just a reduced list of possible valid conditions for a reliable interruptible workload. You might find other states that are convenient for your own workloads.

#### System states

In this reference implementation you'll notice we're using a **Distributed Producer Consumer** system type, where the interruptible workload is nothing but a batch processing app acting as the consumer. Since you're mainly considering Azure Spot VMs to save costs, we recommend looking into the issues that can arise with this kind of solution and get them mitigated to avoid wasting compute cycles. One example is the concurrency problems we show below.

1. Deadlock
1. Starvation

In general, we recommend that you always take edge cases and common pitfalls associated to the system types you're building into account. Design their architectures to be good citizens while running on top of Azure Spot VMs.

> [!NOTE]
> This reference implementation follows the simple concurrency strategy: **Do-Nothing**. Since you're going to deploy a single interruptible workload instance (consumer) and produce a moderate and discrete amount of messages, do not expect a `Deadlock` or `Starvation` as system states. One recommendation to prevent your system from running into such states is to consider handling them if detected at the time of **Orchestration** as another mitigation strategy. However, we will not explore that process in this reference implementation.

#### Orchestration

As mentioned in the previous section, the orchestration can be scoped to coordinate at the application level or beyond to implement broader capabilities, like system recovery. However, this reference implementation is focused specifically on scheduling the interruptible workload into the Azure Spot VM operating system, thereby executing the worker app at the VM startup time.

It will be helpful to kick off the application after eviction or the first time the Azure Spot VM gets deployed. This way, the application will be able to continue processing messages without human intervention from the queue once started. Once the application is running, it will transition through the `Recover`, `Resume`, and `Start` application states.

By design, this [bash script](https://github.com/mspnp/interruptible-workload-on-spot/blob/a497c29cc57bf499878d2860e37ed41ac27ef4be/orchestrate.sh) runs after the machine has started up. It downloads the workload package from an Azure Storage Account for file shares, decompresses the files, and executes the process.

<!--- IMAGE HERE: Depict the Azure Spot VM infrastructure at orchestration time --->

Another important orchestration related aspect to understand is how to scale your workload within a single VM instance, so it's more resource efficient.

- **Scale up strategy**

    In this reference implementation, your workload is built with no artificial constraints and will grow to consume available resources in your VM instance without exhausting them. From the orchestration point of view, you want to ensure that it's running a SINGLETON of the workload and let it organically request resources as designed.

    <!--- IMAGE HERE: Depict the Azure Spot VM infrastructure orchestration scale up strategy --->

- **Scale out strategy**

    Alternatively, if the workload resources specs are limited by design and it can't grow to consume VM resources, ensure your VM is the right size to orchestrate multiple whole instances of your workload. Doing so will ensure there's no wasted over-provisioning of compute resources in your Spot VM.

    <!--- IMAGE HERE: Depict the Azure Spot VM infrastructure orchestration scale out strategy --->

### Installation

#### Prerequisites

1. An Azure subscription. You can [open an account for free](https://azure.microsoft.com/free).

1. Have [Azure CLI](/cli/azure/install-azure-cli) installed or you can use [Azure Cloud Shell](https://shell.azure.com).

    1. Log in:

        ```bash
        az login
        ```

    1. Ensure you have latest version:

       ```bash
       az upgrade
       ```

1. (Optional) Download [JQ](https://stedolan.github.io/jq/download/).

1. Generate new SSH keys by following the instructions from [Create and manage SSH keys for authentication to a Linux VM in Azure](/azure/virtual-machines/linux/create-ssh-keys-detailed). Alternatively, quickly execute the following command:

   ```bash
   ssh-keygen -m PEM -t rsa -b 4096 -C "azureuser@vm-spot" -f ~/.ssh/opsvmspots.pem
   ```

1. Ensure you have **read-only** access to the private key.

   ```bash
   chmod 400 ~/.ssh/opsvmspotkeys.pem
   ```

1. Download [.NET 6.0 SDK](https://dotnet.microsoft.com/download/dotnet/6.0).

> [!NOTE]
> The steps shown here and elsewhere in this reference implementation use Bash shell commands. On Windows, you can [install Windows Subsystem for Linux](/windows/wsl/install#install) to run Bash. Then enter the following command in PowerShell or Windows Command Prompt and restart your machine: `wsl --install`

#### Expected results

Following the steps in this guide will result in the creation of the following Azure resources that will be used throughout this reference implementation.

| Object | Purpose |
|---|---|
| A Resource Group | Contains all of your organization's related networking, and compute resources. |
| A single Azure Spot VM instance | Based on how flexible you can be with your selected Azure VM size, the Spot VM instance gets deployed so that your interruptible workloads can be installed and executed from there. In this Reference Implementation, the `Standard_D2s_v3` size was chosen and the VM is assigned a System Managed Identity to give it Azure RBAC permissions as a Storage Queue Consumer. |
| A Virtual Network | The private virtual network that provides internet connectivity to the Azure VM so it can be accessed. For more information, see [virtual networks and VMs in Azure](/azure/virtual-network/network-overview). For VNET enabled VMs like this, the [Azure scheduled events metadata service](/azure/virtual-machines/linux/scheduled-events) is available from a static non-routable IP. |
| A Network Card Interface | There must be a NIC that will allow the interconnection between a virtual machine and a virtual network subnet. |
| A Spot VM Subnet | The subnet that the VM is assigned thought its NIC. The subnet allows the NIC to be assigned with a private IP address within the configured network address prefix. |
| A Bastion Subnet | The subnet that the Azure Bastion is assigned to. The subnet supports applying NSG rules to support expected traffic flows, like opening `port 22` against the Spot VM private IP. |
| An Azure Bastion | Allows you to securely communicate over the internet from your local computer to the Azure Spot VM. |
| A Public IP address | The public IP address of the Azure Bastion host. |
| A Storage Account (diagnostics) | Stores the Azure Spot VM boot diagnostics. |
| A Storage Account (queue) | A component of the interruptible workload and that represents work to be completed. |

<!--- new diagram here --->
![Depict the Azure Spot VM infrastructure diagram after deployment]()

> [!NOTE]
> The expected resources for the Spot instance you're about to create are equal to what you would create for a regular Azure virtual machine. Nothing is changed except for the selected **Priority**, which is set to **Spot** instead of **Regular** for our purposes.

#### Planning

At this point in the guide, you should have learned that flexibility is key. As an Architect, you should look for any opportunity for flexibility that aligns with your organizations business goals when it comes to budget, while simultaneously meeting the non-functional requirements at the capacity level for your workload.

1. Get acquainted with the VM sizes Azure can offer you pick out some of them. The following command list VM SKUs in the `US East 2` region that have no more than `8` cores. It also excludes result that doesn't support Azure Spot VM and scale set instances:

   > [!NOTE:]
   > When creating your own interruptible workload, ensure you choose the right size for your compute requirements. Include the filters in the following query or consider using the [VM selector tool](https://azure.microsoft.com/pricing/vm-selector/).

   ```bash
   az vm list-sizes -l eastus2 --query "sort_by([?numberOfCores <=\`8\` && contains(name,'Standard_B') == \`false\` && contains(name,'_Promo') == \`false\`].{Name:name, Cores:numberOfCores, RamMB:memoryInMb, DiskSizeMB:resourceDiskSizeInMb}, &Cores)" --output table
   ```

   The command above should display a similar output to the following:

   ```output
   Name                  Cores    RamMB    DiskSizeMB
   --------------------  -------  -------  ------------
   Standard_D1_v2        1        3584     51200
   Standard_F1           1        2048     16384
   ...
   Standard_D2_v2        2        7168     102400
   Standard_D11_v2       2        14336    102400
   ...
   Standard_D12_v2       4        28672    204800
   Standard_F4           4        8192     65536
   ...
   Standard_NC6s_v3      6        114688   344064
   Standard_NV6          6        57344    389120
   ...
   Standard_E8as_v4      8        65536    131072
   Standard_D4           8        28672    409600
   ...
   ```

1. Before laying out an infrastructure proposal, you have to be aware about pricing. You can navigate to the [Azure Spot advisor](https://azure.microsoft.com/pricing/spot-advisor/) to compare your options from the previous step and apply other budget related filters to help you finalize your selections. Alternatively, if you had installed [JQ](https://stedolan.github.io/jq/download/) you could execute the following command:

   ```bash
   curl -X GET 'https://prices.azure.com/api/retail/prices?api-version=2021-10-01-preview&$filter=serviceName%20eq%20%27Virtual%20Machines%27%20and%20priceType%20eq%20%27Consumption%27%20and%20armRegionName%20eq%20%27eastus2%27%20and%20contains(productName,%20%27Linux%27)%20and%20contains(skuName,%20%27Low%20Priority%27)%20eq%20false' --header 'Content-Type: application/json' --header 'Accept: application/json' | jq -r '.Items | sort_by(.skuName) | group_by(.armSkuName) | [["Sku Retail[$/Hour] Spot[$/Hour] Savings[%]"]] + [["-------------------- ------------ ------------ ------------"]] + map([.[0].armSkuName, .[0].retailPrice, .[1].retailPrice, (100-(100*(.[1].retailPrice / .[0].retailPrice)))]) | .[] | @tsv' | column -t
   ```

   > [!NOTE]
   > You could modify this query by changing the filter. For example, you can indicate the VM sizes you're mostly interested in as well as specific regions.

   You should get a similar output to the following:

   ```output
   Sku                        Retail[$/Hour]  Spot[$/Hour]  Savings[%]
   --------------------       ------------    ------------  ------------
   Standard_DC16ds_v3         1.808           0.7232        60
   Standard_DC16s_v3          1.536           0.6144        60
   Standard_DC1ds_v3          0.113           0.0452        60
   ...
   Standard_NC48ads_A100_v4   7.346           2.9384        60
   Standard_NC96ads_A100_v4   14.692          5.8768        60
   Standard_ND96amsr_A100_v4  32.77           16.385        50
   ```

   > [!NOTE]
   > Provided you have chosen a **Max Price and Capacity** eviction policy, it's good practice to regularly use the [Azure Retail Prices API](/rest/api/cost-management/retail-prices/azure-retail-prices) to check whether the **Max Price** you set is doing well against **Current Price**. You might want to consider scheduling this query, responding with **Max Price** changes, as well as gracefully deallocate the VM accordingly.

#### Clone the repository

1. Clone this repository:

   ```bash
   git clone https://github.com/mspnp/interruptible-workload-on-spot.git
   ```

1. Navigate to the interruptible-workload-on-spot folder:

   ```bash
   cd ./interruptible-workload-on-spot/
   ```

#### Deploy the Azure Spot VM

1. Create the Azure Spot VM resource group:

   ```bash
   az group create -n rg-vmspot -l centralus
   ```

1. Create the Azure Spot VM deployment:

   ```bash
   az deployment group create -g rg-vmspot -f main.bicep
   ```

#### Package the workload

1. Navigate to the sample worker folder:

   ```bash
   cd ./src
   ```

1. Build the sample worker:

   ```bash
   dotnet build -c Release
   ```

1. Navigate to the output folder:

   ```bash
   cd ./bin/Release/net6.0/
   ```

1. Package the worker sample:

   ```bash
   zip -r worker.zip *
   ```

#### Clean up

1. Delete the Azure Spot VM resource group:

   ```bash
   az group delete -n rg-vmspot -y
   ```

### Troubleshooting

#### Remote SSH using Bastion into the Spot VM

1. SSH into the new Spot VM. For detailed steps, see [connect to a Linux VM](/azure/virtual-machines/linux-vm-connect?tabs=Linux).

   ```bash
   az network bastion ssh -n bh -g rg-vmspot --username azureuser --ssh-key ~/.ssh/opsvmspots.pem --auth-type ssh-key --target-resource-id $(az vm show -g rg-vmspot -n vm-spot --query id -o tsv)
   ```

#### Manually copy the **worker.zip** file into the Spot VM

1. Open a tunnel using Bastion between your machine and the remote Spot VM:

   ```bash
   az network bastion tunnel -n bh -g rg-vmspot --target-resource-id $(az vm show -g rg-vmspot -n vm-spot --query id -o tsv) --resource-port 22 --port 50022
   ```

1. Copy the file using SSH copy:

   ```bash
   scp -i ~/.ssh/opsvmspots.pem -P 50022 src/bin/Release/net6.0/worker.zip azureuser@localhost:~/.
   ```