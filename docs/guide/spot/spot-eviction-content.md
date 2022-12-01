Spot virtual machines (VMs) provide access to compute capacity at significant discounts compared to regular VMs. They're an attractive solution for organizations looking to optimize costs, but there's a tradeoff. Spot VMs can lose their access to compute at any time. We call this process an eviction. Workloads running on spot VMs must be able to handle interruptions in compute and maintain reliability. The best candidates for spot VMs are what we call "interruptible workloads." Interruptible workloads run processes that can stop suddenly and resume anytime after without harming essential organizational processes.

This article shows you how to pick the right workload for spot VMs and orchestrate reliability in the midst of evictions. We discuss how to handle compute interruptions and best practices for replacing lost compute capacity. At the end, you'll find a sample implementation of an interruptible workload that you can see how spot VMs work.

Here are our recommendations for architecting reliably interruptible workloads on spot VMs.

## Understand spot virtual machines

At a technical level, spot VMs are the same as regular VMs. They use the same images, hardware, and disks that translate to the same performance. The difference between spot and regular VMs comes down to priority and availability. Spot VMs have a lower priority than regular VMs when it comes to accessing compute capacity and no availability guarantees after their creation. Let's discuss priority and availability in more detail.

**Low priority.** Spot VMs have low-priority access to compute capacity. Regular VMs have high-priority access to compute capacity. High-priority access means regular VMs can get compute capacity whenever they need it. Low-priority access means spot VMs only deploy when there's spare compute capacity, and they only stay running when a higher-priority VM doesn't need the underlying hardware.

**No availability guarantee.** Spot VMs don't have any availability or up-time guarantees after you create them. They have no service-level agreements (SLAs). Spot VMs can lose access to compute capacity at any time (eviction). Spot VMs are cheaper because of the eviction possibility. Whenever Azure needs the compute capacity back, an eviction notice is sent and evicts the spot VM. Azure provides a minimum of 30-seconds advance notice before the actual eviction takes place. For more information, see continuously monitor for eviction below.

## Understand spot virtual machine pricing

Spot VMs can be up to 90 percent cheaper than regular (pay-as-you-go) VMs. The discount varies based on demand, VM size, region of deployment, and operating system. We recommend you use the Azure Spot VM pricing tool to get an estimate of the cost savings. For more information, see:

- [Azure Spot VM pricing tool](https://azure.microsoft.com/pricing/spot-advisor/)
- [Spot VM pricing overview](/azure/virtual-machines/spot-vms#pricing)

## Understand interruptible workloads

Interruptible workloads present the ideal use case for spot VMs. Interruptible workloads have a few common characteristics. They have minimal to no time constraints, low organizational priority, and short processing times. They run processes that can stop suddenly and resume later without harming essential organizational processes. Examples of interruptible workloads are batch processing applications, data analytics, and workloads that create a continuous integration-continuous deployment agent for a non-production environment. These features contrast with regular or mission-critical workloads that have service level agreements (SLAs), sticky sessions, and stateful data. The table provides examples for both workload types.

|     | Interruptible workload features | Regular workload features
| --- | --- | --- |
| **Features** | - Minimal to no time constraints <br> - Low organizational priority <br> - Short processing times | - Service level agreements (SLAs) <br>- Sticky sessions requirements <br>- Stateful workloads |

You can use spot VM in non-interruptible workloads, but they shouldn’t be the single source of compute capacity. Use as many regular VMs as you need to meet your uptime requirements. Mixing spot and regular VMs can help optimize costs while meeting service level agreements.

With a basic understanding of interruptible workloads, it's important to understand eviction before starting with spot VMs.

## Understand eviction

Spot VMs have no service level agreements after they're created and can lose their access to hardware at any time. The loss of compute capacity is called eviction. Eviction is driven by supply and demand. When the demand for a specific piece of hardware exceeds a certain level, Azure evicts spot VMs to make this hardware available to regular, pay-as-you-go VMs. The demand for hardware is location specific. For example, a demand increase in region A won't affect spot VMs in region B.

Spot VMs have two configuration options that affect eviction. These configurations are the "eviction type" and "eviction policy" of the spot VM. You set these configurations when you create the spot VM. The "eviction type" defines the conditions of an eviction. The "eviction policy" determines what eviction does to your spot VM. Let's address each in more detail.

**Eviction type.**  Eviction is caused by capacity changes or price changes. The way these affect spot VMs depends on the eviction type chosen when the VM was created. Eviction type defines the conditions of an eviction. The eviction types are "capacity only eviction" and "price or capacity eviction".

*Capacity only eviction* - This eviction type triggers an eviction when excess compute capacity disappears. By default, the price is capped at the pay-as-you-go rate. Use this eviction type when you're willing to pay up to the pay-as-you-go VM price.

*Price or capacity eviction* - This eviction type has two triggers. Azure evicts a spot VM when excess compute capacity disappears or the cost of the VM exceeds the max price you set. This eviction type allows you to set a maximum price well below the pay-as-you-go price. Use this eviction type to set your own price cap.

**Eviction policy.** The eviction policy chosen for a spot VM affects its orchestration. By orchestration, we mean the process of handling an eviction. We cover orchestration in detail below. The eviction policies are the "Stop/Deallocate policy" and "Delete policy".

*Stop/Deallocate policy* - The Stop/Deallocate eviction policy is best when the workload can wait for release capacity within the same location and VM type. The Stop/Deallocate policy stops the VM and ends its lease with the underlying hardware. Stopping and deallocating a spot VM is the same as stopping and deallocating a regular VM. The VM remains accessible in Azure, and you can restart the same VM later. With the Stop/Deallocate policy, the VM loses compute capacity and non-static IP addresses. However, the VM data disks remain and still incur charges. The VM also occupies cores in the subscription. VMs can't be moved from their region or zone even when stopped/deallocated. For more information, see [VM power states and billing](/azure/virtual-machines/states-billing#power-states-and-billing).

*Delete policy* - Use the "Delete policy" if the workload can change location or VM size. Changing location and/or VM size allows the VM to redeploy faster. The Delete policy deletes the VM and any data disk. The VM doesn't occupy cores in subscriptions. For more information on eviction policies, see [eviction policy](/azure/virtual-machines/spot-vms#eviction-policy).

## Design flexible orchestration

Orchestration is the process of replacing a spot VM after an eviction. It's the foundation of building a reliably interruptible workload. A good orchestration system has built-in flexibility. By flexibility, we mean designing your orchestration to have options, use multiple VM sizes, deploy to different regions, be eviction aware, and account for different eviction scenarios. to improve workload reliability and speed.

Below we've outlined recommendations to help you create a flexible orchestration for your interruptible workload.

**Design for speed.** For a workload running on spot VMs, compute capacity is a treasure. The imminent potential for eviction should elevate your appreciation for compute time allotted and should translate to meaningful design decisions that prioritize workload speed. In general, we recommend optimizing the compute time you have. You should build a VM image with all the required software pre-installed. Pre-installed software will help minimize the time between eviction and a fully running application. You want to avoid using compute time on processes that don't contribute to workload purpose. A workload for data analytics, for example, should focus most compute time on data processing and as little as possible on gathering eviction metadata. Eliminate non-essential processes from your application.

**Use multiple VM sizes and locations.** We recommend building an orchestration to use multiple VM types and sizes to increase flexibility. The goal is to give your orchestration options to replace an evicted VM. Azure has different VM types and sizes that provide similar capabilities for around the same price. You should filter VMs min vCPUs/Cores and/or min RAM, and max price to find multiple VMs that have the power to run your workload and fit within your budget. Each VM type has an eviction rate expressed as a percentage range (0-5%, 5-10%, 10-15%, 15-20%, 20+%). The eviction rates can vary across regions. You might find a better eviction rate for the same VM type in a different region. You can find the eviction rates for each VM type in the portal under the "Basics" tab. Select the "Size" links ("View pricing history" or "See all sizes"). You can also programmatically get spot VM data using Azure Resource Graph. For more information, see:

- [Eviction rates](/azure/virtual-machines/spot-vms#portal)
- [Azure Resource Graph](/azure/virtual-machines/spot-vms#azure-resource-graph)

**Use the most flexible eviction policy.** The eviction policy of the evicted spot VM affects the replacement process. A delete eviction policy is more flexible than a stopped/deallocated eviction policy. We recommend considering a delete policy first to see if it fits your workload needs.

*Consider the delete policy first* - We recommend using a delete eviction policy if your workload can handle it. Deletion allows the orchestration to deploy replacement spot VMs to new zones and regions. This deployment flexibility could help your workload find spare compute capacity faster than a stopped/deallocated VM. Stopped/deallocated VMs have to wait for spare compute capacity in the same zone it was created in. You'll need a process to monitor for evictions external to the application and initiative remediation by deploying to alternative regions or SKUs.

*Understand the stopped/deallocated policy* - The stopped/deallocated policy has less flexibility than the delete policy. The spot VMs must stay in the same region and zone. You can't move a stopped/deallocated VM to another location. Because the VMs have a fixed location, you'll need something in place to reallocate the VM when compute capacity becomes available. There's no way to predict when compute capacity will be available. So we recommend using an automated schedule pipeline to attempt a redeployment after an eviction. An eviction should trigger the schedule pipeline, and the redeployment attempts should continuously check for compute capacity until it becomes available.

| Policy | When | |
| --- | --- | --- |
| Delete | Ephemeral compute and data <br> Don't want to pay for data disks <br> Minimal budget| |
| Stopped/Deallocated | Need a specific VM size <br> Can't change location <br> Long application installation process | Indefinite wait time <br> Not driven by cost savings alone

**Continuously monitor for eviction.** Monitoring is the key to workload reliability on spot VMs. Spot VMs have no SLA after creation and can be evicted at any time. The best way to improve workload reliability on spot VMs is to anticipate when they're going to be evicted. With this information, you could attempt a workload graceful shutdown and trigger automation that orchestrates the replacement.

*Use Scheduled Events* - We recommend using the Scheduled Events service for each VM. Azure has different infrastructure maintenance types, and each type generates a distinct signal. Evictions qualify as infrastructure maintenance and send out the `Preempt` signal to all affected VMs. A service called Schedule Events allows you to capture the `Preempt` signal for VM. The Scheduled Events service provides a queryable endpoint at a static, non-routable IP address `169.254.169.254`. Azure infrastructure generates the `Preempt` signal for affected VMs at a minimum 30 seconds before an eviction. You might not query the endpoint the second `Preempt` signal arrives, so you need to build your orchestration around these constraints.

*Use frequent queries* - We recommend querying the endpoint often enough to orchestrate a graceful shutdown. You can query the Scheduled Events endpoint up to every second for the most, but one-second frequency might not be necessary for all use cases. Queries must come from an application running on the spot VM. The query can't come from an external source. As a result, the queries will consume VM compute capacity and steal processing power from the main workload. You'll need to balance those competing priorities to meet your specific situation.

*Automate orchestration* - Once you collect the `Preempt` signal, your orchestration should act on that signal. Given the time constraints, the `Preempt` signal should attempt a graceful shutdown of your workload and start an automated process that replaces the spot VM. For more information, see:

- [Scheduled Events](/azure/virtual-machines/windows/scheduled-events)
- [Scheduled Event types](/azure/virtual-machines/linux/scheduled-events#event-scheduling)
- [Endpoint querying frequency](/azure/virtual-machines/linux/scheduled-events#polling-frequency)

**Build a deployment system.** Your orchestration needs an automated pipeline to deploy new spot VMs when evicted. The pipeline should run outside the interruptible workload itself to ensure permanence. The way the deployment pipeline should work depends on the eviction policy you've selected for your spot VMs.

For a delete policy, we recommend building a pipeline that uses different VM sizes and deploys to different regions. For a stop/deallocated policy, the deployment pipeline will need two distinct actions. For the initial creation of a VM, the pipeline needs to deploy the right size VMs to the right location. For an evicted VM, the pipeline needs to try to restart the VM until it works. A combination of Azure Monitor alerts and Azure Functions is one of several ways to automate a deployment system. The pipeline could use bicep templates. They're declarative and idempotent and represent a best practice for infrastructure deployment.

**Prepare for immediate eviction.** It's possible that your spot VM will be designated for eviction as soon as it's created and even before your workload is executed. Just because there was capacity to create a spot VM, doesn't mean it will persist. Spot VMs have no availability guarantees (SLAs) after creation. Your orchestration needs to account for immediate evictions. The `Preempt` signal will still provide a minimum of 30-seconds advance notice of the eviction.

We recommend incorporating VM health checks into your orchestration to prepare for immediate evictions. Orchestration for immediate evictions can't rely on the Schedule Events `Preempt` signal. It needs to be outside the workload infrastructure. There's not enough time to start an application, query the Schedule Events endpoint, and gracefully shutdown. The health checks need to watch the status of the spot VM and start the deployment pipeline to replace the spot VM when the status changes to deallocating or stopping. It can't use the `Preempt` signal. Only the VM itself can query the `Preempt` signal.

**Plan for multiple simultaneous evictions.** If you're running a cluster of spot VMs, you should architect the workload to withstand multiple simultaneous evictions. Multiple spot VMs in the workload could be evicted at the same time. A simultaneous eviction of multiple VMs could affect the throughput of the application. To avoid this situation, your deployment pipeline should be able to gather signals from multiple VMs and deploy multiple replacement VMs simultaneously.

**Design for a graceful shutdown.** The VM shutdown processes should be less than 30 seconds and allow your VM to shut down before an eviction. The amount of time the shutdown should take depends on how frequently your workload queries the Scheduled Events endpoint. The more often you query the endpoint, the longer the shutdown process can be. The shutdown process should release resources, drain connections, and flush event logs. You should regularly create and save checkpoints to save the context and build a more efficient recovery strategy. The checkpoint is just information about what processes or transactions the next VM needs to start on. They should indicate if the VM should resume where the previous VM left off or if the new VM should roll back the changes and start the entire process again. You should store the checkpoints outside the spot VM environment. A storage account would work.

**Test the orchestration.** We recommend simulating eviction events to test orchestration in dev/test environments. For more information, see [simulate eviction](/azure/virtual-machines/linux/spot-cli#simulate-an-eviction).

**Design an idempotent workload.** We recommend designing an idempotent workload. The outcome of processing an event more than once should be the same as processing it once. Evictions can lead to forced shutdowns despite efforts to ensure graceful shutdowns. Forced shutdowns can terminate processes before completion. Idempotent workloads can receive the same message more than once and the outcome remains the same. For more information, see [idempotency](/azure/architecture/serverless/event-hubs-functions/resilient-design#idempotency).

**Use an application warmup period.** Most interruptible workloads run applications. Applications need time to install and time to boot. They need time to connect to external storage and gather information from checkpoints. We recommend having an application warmup period before allowing it to start processing. During the warmup period, the application should be booting, connecting, and preparing to contribute. You should only allow an application to start processing data after you've validated the health of the application.

![Diagram of the workload lifecycle with an application warmup period](./media/lifecycle-spot-virtual-machine.png)

**Configure user-assigned managed identities.** We recommend using user-assigned managed identities to streamline the authentication and authorization process. User-assigned managed identities let avoid putting credentials in code and aren't tied to a single resource like system-assigned managed identities. The user-assigned managed identities contain permissions and access tokens from Azure Active Directory that can be reused and assigned to spot VMs during orchestration. Token consistency across spot VMs helps streamline orchestration and the access to workload resources the spot VMs have.

With system-assigned managed identities, a new spot VM might get a different access token from Azure Active Directory. If you need to use system-assigned managed identities, we recommend making the workloads resilient to `403 Forbidden Error` responses. Your orchestration will need to get tokens from Azure Active Directory with the right permissions. For more information, see [managed identities](/azure/active-directory/managed-identities-azure-resources/overview).

## Example scenario

We built an example scenario for Spot VMs. It deploys a queue processing application that qualifies as an interruptible workload. The scripts in the scenario are illustrative. The scenario walks you through a one-time, manual push to deploy resources. We haven't provided a deployment pipeline with this implementation. But a deployment pipeline is essential to automating the orchestrating process. Below we is an diagram of the architecture and details about its components.

[![Diagram of the example scenario architecture](./media/spot-vm-arch.png)](./media/spot-vm-arch.png)

1. **VM application definition:** The VM application definition is created in the Azure Compute Gallery. It defines the application name, location, operating system, and metadata. The application version is a numbered version of the VM application definition. The application version is an instantiation of the VM application. It needs to be in the same region as the spot VM. The application version links to the source application package in the storage account.
1. **Storage account:**  The storage account stores the source application package. In this architecture, it's a compressed tar file named `worker-0.1.0.tar.gz`. It contains two files. One file is the `orchestrate.sh` bash script that installs the .NET worker application.
1. **Spot VM:** The spot VM deploys. It must be in the same region as the application version. It downloads `worker-0.1.0.tar.gz` to the VM after deployment. The bicep template deploys an Ubuntu image on a Standard family VM. These configurations meet the needs of this application and aren't general recommendations for your applications.
1. **Storage Queue:** The other service running in the .NET worker contains message queue logic. Azure AD grants the spot VM access to the storage queue with a user assigned identity using RBAC.
1. **.Net worker application:** The orchestrate.sh script installs a .NET worker application that runs two background services. The first service queries the Schedule Events endpoint and looks for the `Preempt` signal and sends this signal to the second service. The second service processes messages from the storage queue and listens for the `Preempt` signal from the first service. When the second service receives the signal, it interrupts storage queue processing and begins to shut down.
1. **Query Scheduled Events endpoint:** An API request is sent to a static non-routable IP address 169.254.169.254. The API request queries the Scheduled Event endpoint for infrastructure maintenance signals.
1. **Application Insights:** The architecture uses Application Insights only for learning purposes. It's not an essential component of interruptible workload orchestration. We've included it as a way for you to validate the telemetry from the .NET worker application. We've configured the .NET worker application to send telemetry to Application Insights. For more information, see [enable live metrics from .NET application](/azure/azure-monitor/app/live-stream#enable-live-metrics-using-code-for-any-net-application).

## Deploy this scenario

![GitHub logo](../../_images/github.png) We created a GitHub repository called [interruptible workload on spot](https://github.com/mspnp/interruptible-workload-on-spot) with templates, scripts, and step-by-step instructions to deploy this architecture. You'll find more technical details about the architecture and engineering artifacts in this repository.

## Next step

For more information on Spot Virtual Machines, see [Azure Spot Virtual Machines](/azure/virtual-machines/spot-vms).
