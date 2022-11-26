Spot VMs provide access to compute capacity at significant discounts and are an attractive solution for cost savings. In this article, you'll find recommendations for architecting interruptible workloads with Azure Spot virtual machines (VMs) and a sample implementation you can deploy. The goal is to give you the knowledge to make the right design decisions. It's important to understand what Spot VMs are and identify the right workload candidates. Spots VMs are only recommended for workloads that can be interrupted and have no time constraints. Hosting interruptible workloads on Spot VMs requires knowledge of eviction, pricing, and orchestration best practices.

## Understand Spot VMs

A spot VM and a regular, pay-as-you-go VM use the same images, hardware, and disks. They provide the same performance as regular VMs when running. The difference between spot and regular VMs is priority and availability. Spot VMs have a lower priority than regular VMs and no availability guarantees after creation.

**(1) Low priority** - Spot VMs have low-priority access to compute capacity. Regular VMs have high-priority access. High-priority access means regular VMs can access compute capacity whenever they need it. Low-priority access means spot VMs can only deploy when there's spare compute capacity. They only stay running when a higher-priority, regular VM doesn't need the underlying hardware.

**(2) No availability guarantee** - Spot VMs don't have any availability or up-time guarantees after you create them. They have no service-level agreements (SLAs). Spot VMs can lose access to compute capacity at any time. The loss of compute capacity is called an eviction. Spot VMs are cheaper because of the eviction possibility. Whenever Azure needs the capacity back, an eviction notice will be sent and evict the VM based on the eviction policy selected for the spot VM at the time of creation. The minimum notice for an eviction notification is 30 seconds.

## Understand spot pricing

Spot VMs are up to 90 percent cheaper than regular (pay-as-you-go) VMs. The discount varies based on demand, VM size, region of deployment, and operating system. We recommend you use the Azure Spot VM pricing tool to get an estimate of the cost savings. For more information, see:

- [Azure Spot VM pricing tool](https://azure.microsoft.com/pricing/spot-advisor/)
- [Spot VM pricing overview](/azure/virtual-machines/spot-vms#pricing)

## Understand interruptible workloads

Interruptible workloads present the ideal use case for spot VMs. Interruptible workloads have a few common characteristics. They have minimal to no time constraints, low organizational priority, and short processing times. They run processes that can stop suddenly and be resumed later without harming essential organizational processes. These features contrast with regular or mission-critical workloads that have service level agreements (SLAs), sticky sessions, and stateful data. The table provides examples for each category. Spot VMs shouldn’t be the single source of compute capacity for non-interruptible workloads.

|     | Interruptible workload features | Regular workload features
| --- | --- | --- |
| **Features** | - Minimal to no time constraints <br> - Low organizational priority <br> - Short processing times | - Service level agreements (SLAs) <br>- Sticky sessions requirements <br>- Stateful workloads |

With a basic understanding of interruptible workloads, it's important to understand eviction before starting with spot VMs.

## Understand eviction

Spot VMs have no service level agreements after they're created and can lose their access to hardware at any time. The loss of compute capacity is called eviction. Eviction is driven by supply and demand. When the demand for a specific piece of hardware exceeds a certain level, Azure evicts spot VMs to make this hardware available to regular, pay-as-you-go VMs. The demand for hardware is location specific. For example, a demand increase in region A won't affect spot VMs in region B.

Spot VMs have two configuration options that affect eviction. You set the eviction type and eviction policy when you create Spot VMs. Eviction type determines when eviction occurs. Eviction policy determines what eviction does. Let's address each in more detail.

**(1) Eviction type** - Eviction is caused by capacity changes or price change. The way these affect spot VMs depends on the eviction type chosen when the VM was created. Eviction type defines the conditions of eviction. The eviction types are "capacity only eviction" and "price or capacity eviction".

*Capacity only eviction* - This eviction type triggers an eviction when excess compute capacity disappears. By default, the price is capped at the pay-as-you-go rate. Use this eviction type when you're willing to pay up to the pay-as-you-go VM price.

*Price or capacity eviction* - This eviction type has two triggers. Azure evicts a spot VM when excess compute capacity disappears or the cost of the VM exceeds the max price you set. This eviction type allows you to set a maximum price well below the pay-as-you-go price. Use this eviction type to set your own price cap.

**(2) Eviction policy** - The eviction policy chosen for a spot VM affects its orchestration. By orchestration, we mean the process of handling an eviction. We cover orchestration in detail below. The eviction policies are the "Stop/Deallocate policy" and "Delete policy".

*Stop/Deallocate policy* - The Stop/Deallocate eviction policy is best when the workload can wait for release capacity within the same location and VM type. The Stop/Deallocate policy stops the VM and ends its lease with the underlying compute capacity. Stopping and deallocating a spot VM is the same as stopping and deallocating a regular VM. The VM remains accessible in Azure, and you can restart the same VM later. With the Stop/Deallocate policy, the VM loses compute capacity and non-static IP addresses. However, the VM data disks remain and still incur charges. The VM also occupies cores in the subscription. VMs can't be moved from their region or zone even when stopped/deallocated. For more information, see [VM power states and billing](/azure/virtual-machines/states-billing#power-states-and-billing).

*Delete policy* - Use the "Delete" policy if the workload can change location or VM size. Changing location and/or VM size allows the VM to redeploy faster. The Delete policy deletes the VM and any data disk. The VM doesn't occupy cores in subscriptions. For more information on eviction policies, see [eviction policy](/azure/virtual-machines/spot-vms#eviction-policy).

## Design flexible orchestration

Orchestration is the process of replacing a spot VM after an eviction. Orchestration should be as flexible as possible. We recommend building orchestration to use multiple VM sizes and several locations to improve flexibility.

Below we've outlined key orchestration recommendations.

**(1) Use multiple VM sizes and locations** - We recommend building an orchestration to use multiple VM types and sizes to increase flexibility. The goal is to give your orchestration various options to replace an evicted VM. Azure has different VM types and sizes that provide similar capabilities for around the same price. You should filter VMs min vCPUs/Cores and/or min RAM, and max price to find multiple VMs that have the power to run your workload and fit within your budget. Each VM type has an eviction rate expressed as a percentage range (0-5%, 5-10%, 10-15%, 15-20%, 20+%). The eviction rates can vary across regions. You might find a better eviction rate for the same VM type in a different region. You can find the eviction rates for each VM type in the portal under the "Basics" tab. Select the "Size" links ("View pricing history" or "See all sizes"). For more information, see [eviction rates](/azure/virtual-machines/spot-vms#portal).

**(2) Use the most flexible eviction policy** - The eviction policy of the evicted Spot VM affects the replacement process. A delete eviction policy is more flexible than a stopped/deallocated eviction policy. We recommend considering a delete policy first to see if it fits your workload needs.

*Consider the delete policy first* - We recommend using a delete eviction policy if your workload can handle it. Deletion allows the orchestration to deploy replacement spot VMs to new zones and regions. This deployment flexibility could help your workload find spare compute capacity faster than a stopped/deallocated VM. Stopped/deallocated VMs have to wait for spare compute capacity in the same zone it was created in. You'll need a process to monitor for evictions external to the application and initiative remediation by deploying to alternative regions or SKUs.

*Understand the stopped/deallocated policy* - The stopped/deallocated policy has less flexibility than the delete policy. The spot VMs must stay in the same region and zone. You can't move a stopped/deallocated VM to another location. Because the VMs have a fixed location, you'll need something in place to reallocate the VM when compute capacity becomes available. There's no way to predict when compute capacity will be available. So we recommend using an automated schedule pipeline to attempt a redeployment after an eviction. An eviction should trigger the schedule pipeline, and the redeployment attempts should continuously check for compute capacity until it becomes available.

| Policy | When |
| --- | --- |
| Delete | - ephemeral compute and data <br> - don't want to pay for data disks <br> - minimal budget|
| Stopped/Deallocated | - need a specific VM size <br> - infinite wait time <br> - can't change location <br> - not driven by cost savings alone <br> - long installation process |

**(3) Continuously monitor for eviction** - Monitoring is the key to workload reliability on spot VMs. Spot VMs have no SLA after creation and can be evicted at any time. The best way to improve workload reliability on spot VMs is knowing in advance when they're going to be evicted. With this information, you can trigger automation for a graceful shutdown and orchestrate a replacement.

*Use Scheduled Events* - We recommend using the Scheduled Events service for each VM. Azure has different infrastructure maintenance types and each type generates a distinct signal. Evictions qualify as infrastructure maintenance and send out the `Preempt` signal to all affected VMs. A service called Schedule Events allows you to capture the `Preempt` signal for VM. The Scheduled Events service provides a queryable endpoint at a static, non-routable IP address `169.254.169.254`. Azure infrastructure generates the `Preempt` signal for affected VMs at a minimum 30 seconds before an eviction. You might not query the endpoint the second `Preempt` signal arrives, so you need to build your orchestration around these constraints.

*Use frequent queries* - We recommend querying the endpoint often enough to orchestrate a graceful shutdown. You can query the Scheduled Events endpoint up to every second for the most, but one-second frequency might not be necessary for all use cases. Queries must come from an application running on the spot VM. The query can't come from an external source. As a result, the queries will consume VM compute capacity and steal processing power from the main workload. You'll need to balance those competing priorities to meet your specific situation.

*Automate orchestration* - Once you collect the `Preempt` signal, your orchestration should act on that signal. Given the time constraints, the `Preempt` signal should start an automated process that gracefully shutting down your VM and the replace process. For more information, see:

- [Scheduled Events](/azure/virtual-machines/windows/scheduled-events)
- [Scheduled Event types](/azure/virtual-machines/linux/scheduled-events#event-scheduling)
- [Endpoint querying frequency](/azure/virtual-machines/linux/scheduled-events#polling-frequency)
- [Application Insights telemetry](/azure/azure-monitor/app/data-model)

**(4) Build a deploy system** - Your orchestration needs an automated pipeline to deploy new VMs when evicted. The pipeline needs to exist outside the orchestration itself so that it's permanent. The way the deployment pipeline should work depends on the eviction policy. For a delete policy, we recommend building a pipeline that uses different VM sizes and deploys to different regions. For a stop/deallocated policy, the deployment pipeline will need two distinct actions. For the initial creation of a VM, the pipeline needs to deploy the right size VMs to the right location. For an evicted VM, the pipeline needs to try to restart the VM until it works. A combination of Azure Monitor alerts and Azure Functions is one of several ways to automate a deployment system.

**(5) Prepare for immediate eviction** - It's possible that your spot VM will be designated for eviction as soon as it's created. Just because there was capacity to create a spot VM, doesn't mean it will persist. Spot VMs have no permanence guarantees (SLAs) after creation. Your orchestration needs to account for immediate evictions. The `Preempt` signal will still provide a minimum of 30-seconds advance notice of the eviction.

We recommend incorporating VM health checks into your orchestration to prepare for immediate evictions. Orchestration for immediate evictions can't rely on the Schedule Events `Preempt` signal. It needs to be outside the workload infrastructure. There's not enough time to start an application, query the Schedule Events endpoint, and gracefully shutdown. The health checks need to watch the status of the spot VM and start the deployment pipeline to replace the spot VM when the status changes to deallocating or stopping.  It can't use the `Preempt` signal. The `Preempt` signal can only be queried from the VM itself.

**(6) Plan for multiple simultaneous evictions** - If you're running a cluster of spot VMs, you should architect the workload to withstand multiple simultaneous evictions. Multiple spot VMs in the workload could be evicted at the same time. A simultaneous eviction of multiple VMs could affect the throughput of the application. To avoid this situation, your deployment pipeline should be able to gather signals from multiple VMs and deploy multiple replacement VMs simultaneously.

**(7) Design graceful shutdown** - The VM shutdown processes should be lower than 30 seconds and allow your VM to shut down before an eviction. The amount of time the shutdown should take depends on how frequently your workload queries the Scheduled Events endpoint. The more often you query the endpoint, the longer the shutdown process can be. The shutdown process should release resources, drain connections, and flush event logs. You should regularly create and save checkpoints to save the context and build a more efficient recovery strategy. The checkpoint is just information about what processes or transactions need to be worked on by the next VM. They should indicate if the VM should resume where the previous VM left off or if the new VM should roll back the changes and start the whole process again. The checkpoints should be stored somewhere outside of the spot VM infrastructure. A storage account would work.

**(8) Build idempotency** - We recommend designing an idempotent workload. The outcome of processing an event more than once should be the same as processing it once. Evictions can lead to forced shutdowns despite efforts to ensure graceful shutdowns. Forced shutdowns can terminate processes before completion. Idempotent workloads can receive the same message more than once and the outcome remains the same. For more information, see [idempotency](/azure/architecture/serverless/event-hubs-functions/resilient-design#idempotency).

**(9) Design around the application lifecycle** - Most interruptible workloads run applications. While most of our recommendations have focused on the infrastructure, the application itself needs consideration. Applications need time to install and time to boot. They need time to connect to external storage and gather information from checkpoints. We recommend having an application warmup period. During this time, the application isn't involved in processing. It's booting, connecting, and preparing to contribute. You should only allow an application to start processing data after you've validated the health of the application.

**(10) Test orchestration** We recommend simulating eviction events to test orchestration in dev/test environments. For more information, see [simulate eviction](/azure/virtual-machines/linux/spot-cli#simulate-an-eviction).

## Example scenario

We built an example scenario for Spot VMs. It deploys a queue processing application that qualifies as an interruptible workload. The scripts in the scenario are illustrative. The scenario walks you through a one-time, manual push to deploy resources. We haven't provided a deployment pipeline with this implementation, but you should build a pipeline to automate the deployment process.

![Diagram of the example scenario architecture](./media/spot-vm-arch.png)

1. **VM application definition:** The VM application definition is created in the Azure Compute Gallery. It defines the application name, location, operating system, and metadata. The application version is a numbered version of the VM application definition. The application version is an instantiation of the VM application. It needs to be in the same region as the spot VM. The application version links to the source application package in the storage account.
1. **Storage account:**  The storage account stores the source application package. In this architecture, it's a compressed tar file named `worker-0.1.0.tar.gz`. It contains two files. One file is the `orchestrate.sh` PowerShell script that installs the .NET worker application.
1. **Spot VM:** The spot VM deploys. It must be in the same region as the application version. It downloads `worker-0.1.0.tar.gz` to the VM after deployment. The bicep template deploys an Ubuntu image (22_04-lts-gen2) on a Standard_D2s_v3 VM with a premium managed disk and local redundant storage (LRS). These configurations meet the needs of this application and aren't general recommendations for your applications.
1. **Storage Queue:** The other service running in the .NET worker contains message queue logic. Azure AD grants the spot VM access to the storage queue with a user assigned identity using RBAC.
1. **.Net worker application:** The orchestrate.sh script installs a .NET worker application that runs two background services. The first service queries the Schedule Events endpoint and looks for the `Preempt` signal and sends this signal to the second service. The second service processes messages from the storage queue and listens for the `Preempt` signal from the first service. When the second service receives the signal, it interrupts storage queue processing and begins to shut down.
1. **Query Scheduled Events endpoint:** An API request is sent to a static non-routable IP address 169.254.169.254. The API request queries the Scheduled Event endpoint for infrastructure maintenance signals.
1. **Application Insights:** The architecture uses Application Insights only for learning purposes. It's not an essential component of interruptible workload orchestration. We've included it as a way for you to validate the telemetry from the .NET worker application. We've configured the .NET worker application to send telemetry to Application Insights. For more information, see [enable live metrics from .NET application](/azure/azure-monitor/app/live-stream#enable-live-metrics-using-code-for-any-net-application).

## Deploy this scenario

![GitHub logo](../../_images/github.png) We created a GitHub repository called [interruptible workload on spot](https://github.com/mspnp/interruptible-workload-on-spot) with templates, scripts, and step-by-step instructions to deploy this architecture. You'll find more technical details about the architecture and engineering artifacts in this repository.

## Next step

For more information on Spot Virtual Machines, see [Use Azure Spot Virtual Machines](/azure/virtual-machines/spot-vms).
