This article describes best practices for how to build on Azure Spot Virtual Machines. Spot virtual machines (spot VMs) provide access to compute capacity at lower prices than regular VMs. This discount makes them a good option for organizations that want to optimize costs. But the savings come with a trade-off. Spot VMs can be evicted at any time, which means that they lose access to compute resources. Workloads that run on spot VMs must be able to handle these interruptions in compute. The appropriate workload and a flexible orchestration mechanism are the keys to success. The following recommendations describe how to build on spot VMs.

## Understand spot VMs

On a technical level, spot VMs are the same as regular VMs. They use the same images, hardware, and disks that translate to the same performance. The key difference between spot VMs and regular VMs is their priority and availability. Spot VMs have no priority to access compute capacity, and they have no availability guarantees after they access that compute capacity.

- **No priority access.** Regular VMs have priority access to compute capacity. They access compute capacity when they request it. However, spot VMs only deploy when there's spare compute capacity. And they only continue to run when a regular VM doesn't need the underlying hardware.

- **No availability guarantee.** Spot VMs don't have any availability guarantees or service-level agreements (SLAs). Spot VMs can lose access to compute capacity immediately, or anytime after deployment or eviction. Spot VMs are cheaper because they can be evicted. When Azure needs the compute capacity back, an eviction notice is sent and evicts the spot VM. Azure provides a minimum of 30-seconds advance notice before the actual eviction occurs. For more information, see [Continuously monitor for eviction](#continuously-monitor-for-eviction).

## Understand spot VM pricing

Spot VMs can be up to 90% cheaper than regular pay-as-you-go VMs. The discount varies based on demand, VM size, deployment region, and the operating system. To get a cost savings estimate, see [Azure Spot Virtual Machines pricing tool](https://azure.microsoft.com/pricing/spot-advisor/) and [Spot Virtual Machines pricing overview](/azure/virtual-machines/spot-vms#pricing). You can also query the [Azure retail prices API](/rest/api/cost-management/retail-prices/azure-retail-prices) to programmatically obtain the spot pricing for any SKU.

## Understand interruptible workloads

Spot VMs are ideal for interruptible workloads, which share several common characteristics. Interruptible workloads have minimal to no time constraints, low organizational priority, and short processing times. They run processes that can stop suddenly and resume later without harming essential organizational processes. Examples of interruptible workloads are batch processing applications, data analytics, and workloads that create a continuous integration and continuous deployment agent for a nonproduction environment. These features compare to regular or mission-critical workloads that have SLAs, sticky sessions, and stateful data.

You can use spot VMs in non-interruptible workloads, but they shouldn't be the only source of compute capacity. Use as many regular VMs as you need to meet your uptime requirements.

## Understand eviction
  
Spot VMs have no SLAs after creation, and they can lose access to compute at any time. We call this compute loss an *eviction*. Compute supply and demand drive evictions. When the demand for a specific VM size exceeds a specific level, Azure evicts spot VMs to make compute available to regular VMs. Demand is location specific. For example, an increase in demand in region A doesn't affect spot VMs in region B.

Spot VMs have two configuration options that affect eviction. These configurations are the *eviction type* and *eviction policy* of the spot VM. You set these configurations when you create the spot VM. The eviction type defines the conditions of an eviction. The eviction policy determines what eviction does to your spot VM.

### Eviction type

Capacity changes or price changes cause evictions. The way capacity and price changes affect spot VMs depends on the eviction type that you choose when the VM is created. The type of eviction defines the conditions of an eviction. The eviction types are *capacity-only eviction* and *price or capacity eviction*.

- **Capacity-only eviction:** This eviction type triggers an eviction when excess compute capacity is no longer available. By default, the price is capped at the pay-as-you-go rate. Use this eviction type when you don't want to pay more than the pay-as-you-go VM price.

- **Price or capacity eviction:** This eviction type has two triggers. Azure evicts a spot VM when excess compute capacity is no longer available or the cost of the VM exceeds the maximum price that you set. This eviction type allows you to set a maximum price far less than the pay-as-you-go price. Use this eviction type to set your own price cap.

### Eviction policy

The eviction policy that you choose for a spot VM affects its orchestration. Orchestration is the process of handling an eviction and is discussed later in this article. The eviction policies are the *Stop/Deallocate policy* and the *Delete policy*.

**Stop/Deallocate policy:** The Stop/Deallocate policy is ideal when the workload can wait for release capacity within the same location and VM type. The Stop/Deallocate policy stops the VM and ends its lease with the underlying hardware. Stopping and deallocating a spot VM is the same as stopping and deallocating a regular VM. The VM remains accessible in Azure, and you can restart the same VM later. The VM loses compute capacity and nonstatic IP addresses with the Stop/Deallocate policy. However, the VM data disks remain and continue to incur charges. The VM also occupies cores in the subscription. VMs can't be moved from their region or zone even when they're stopped or deallocated. For more information, see [Power states and billing](/azure/virtual-machines/states-billing#power-states-and-billing).

**Delete policy:** Use the Delete policy if the workload can change location or VM size. Changing the location or VM size allows the VM to redeploy faster. The Delete policy deletes the VM and any data disk. The VM doesn't occupy cores in subscriptions. For more information, see [Eviction policy](/azure/virtual-machines/spot-vms#eviction-policy).

## Design for flexible orchestration

Orchestration is the process of replacing a spot VM after an eviction. It's the foundation for building a reliably interruptible workload. A good orchestration system has built-in flexibility. Flexibility means designing your orchestration to have options, use multiple VM sizes, deploy to different regions, have eviction awareness, and account for different eviction scenarios to improve workload reliability and speed.

### Design for speed

For a workload that runs on spot VMs, compute capacity is crucial. Because of the potential for eviction, ensure that you understand the allocated compute time so that you can make informed design decisions that prioritize workload speed. Generally, you should optimize the compute time that you have. Build a VM image that has all the required software preinstalled. Preinstalled software helps minimize the time between eviction and a fully operational application. Avoid using compute time on processes that don't contribute to the workload purpose. For example, a workload for data analytics should focus most of its compute time on data processing and as little time as possible on gathering eviction metadata. Eliminate nonessential processes from your application.

### Use multiple VM sizes and locations

To increase flexibility, build an orchestration to use multiple types and sizes of VMs. The goal is to give your orchestration options to replace an evicted VM. Azure has different types and sizes of VMs that provide similar capabilities for about the same price. Filter for the minimum vCPUs or cores, the minimum RAM for VMs, and the maximum price. This process helps you find multiple VMs that fit in your budget and have enough power to run your workload.

Each type of VM has an eviction rate that's expressed as a percentage range, such as 0%-5%, 5%-10%, 10%-15%, 15%-20%, or 20+%. Eviction rates can vary across regions. You might find a better eviction rate for the same type of VM in a different region. You can find the eviction rates for each type of VM in the portal under the **Basics** tab. Next to **Size**, select **View pricing history** or **See all sizes**. You can also programmatically get spot VM data by using Azure Resource Graph.

In your orchestration system, consider using the spot placement score feature to evaluate the likelihood of success for individual spot deployments.

For more information, see the following resources:

- [Eviction rates](/azure/virtual-machines/spot-vms#pricing-and-eviction-history)
- [Resource Graph](/azure/virtual-machines/spot-vms#azure-resource-graph)
- [Spot placement score](/azure/virtual-machine-scale-sets/spot-placement-score)

### Use the most flexible eviction policy

The eviction policy of the evicted spot VM affects the replacement process. For example, a Delete policy is more flexible than a Stop/Deallocate policy.

- **Consider the Delete policy first:** Use a Delete policy if your workload can handle it. Deletion allows the orchestration to deploy replacement spot VMs to new zones and regions. This deployment flexibility could help your workload find spare compute capacity faster than a stopped or deallocated VM. Stopped or deallocated VMs have to wait for spare compute capacity in the same zone that they were created in. For the Delete policy, you need an external process to monitor for evictions and orchestrate deployments to various regions, use different VM SKUs, or both.

- **Understand the Stop/Deallocate policy:** The Stop/Deallocate policy has less flexibility than the Delete policy. The spot VMs must stay in the same region and zone. You can't move a stopped or deallocated VM to another location. Because the VMs have a fixed location, you need something in place to reallocate the VM when compute capacity becomes available. There's no way to predict the availability of compute capacity. So you should use an automated schedule pipeline to attempt a redeployment after an eviction. An eviction should trigger the schedule pipeline, and the redeployment attempts should continuously check for compute capacity until it becomes available.

| Policy | When to use the policy |
| --- | --- |
| Delete policy | - Ephemeral compute and data <br><br> - Don't want to pay for data disks <br><br> - Minimal budget |
| Stop/Deallocate policy | - Need a specific VM size <br><br> - Can't change location <br><br> - Long application installation process <br><br> - Indefinite wait time <br><br> - Not driven by cost savings alone |

### Continuously monitor for eviction

Monitoring is the key to workload reliability on spot VMs. Spot VMs have no SLA after creation and can be evicted at any time. The best way to improve workload reliability on spot VMs is to anticipate when they're going to be evicted. If you have this information, you can attempt a workload graceful shutdown and trigger automation to orchestrate the replacement.

- **Use Scheduled Events:** Use the Scheduled Events service for each VM. Azure sends signals to VMs when infrastructure maintenance is going to affect them. Evictions qualify as infrastructure maintenance. Azure sends out the `Preempt` signal to all VMs at a minimum of 30 seconds before they're evicted. The Scheduled Events service allows you to capture this `Preempt` signal by querying an endpoint at the static, nonroutable IP address `169.254.169.254`.

- **Use frequent queries:** Query the Scheduled Events endpoint often enough to orchestrate a graceful shutdown. You can query the Scheduled Events endpoint up to every second, but a one-second frequency might not be necessary for all use cases. These queries must come from an application that runs on the spot VM. The query can't come from an external source. As a result, the queries consume VM compute capacity and steal processing power from the main workload. You need to balance those competing priorities to meet your specific situation.

- **Automate orchestration:** After you collect the `Preempt` signal, your orchestration should act on that signal. Given the time constraints, the `Preempt` signal should attempt a graceful shutdown of your workload and start an automated process that replaces the spot VM. For more information, see the following resources:

  - [Scheduled Events](/azure/virtual-machines/windows/scheduled-events)
  - [Scheduled event types](/azure/virtual-machines/linux/scheduled-events#event-scheduling)
  - [Endpoint querying frequency](/azure/virtual-machines/linux/scheduled-events#polling-frequency)

### Build a deployment system

Your orchestration needs an automated pipeline to deploy new spot VMs after eviction. The pipeline should run outside the interruptible workload to help ensure permanence. The deployment pipeline should work according to the eviction policy that you choose for your spot VMs.

For a Delete policy, we recommend that you build a pipeline that uses different VM sizes and deploys to different regions. For a Stop/Deallocate policy, the deployment pipeline needs two distinct actions. For the initial creation of a VM, the pipeline needs to deploy the correct size VMs to the correct location. For an evicted VM, the pipeline needs to try to restart the VM until it works. A combination of Azure Monitor alerts and Azure functions is one way to automate a deployment system. The pipeline could use bicep templates. They're declarative and idempotent and represent a best practice for infrastructure deployment.

### Prepare for immediate eviction

It's possible for Azure to evict a spot VM as soon as you create it and before your workload runs. In some cases, there might be enough capacity to create a spot VM, but it won't last. Spot VMs have no availability guarantees, or SLAs, after creation. Your orchestration needs to account for immediate evictions. The `Preempt` signal provides a minimum of 30-seconds advance notice of the eviction.

Incorporate VM health checks into your orchestration to prepare for immediate evictions. Orchestration for immediate evictions can't depend on the Scheduled Events `Preempt` signal. Only the VM itself can query the `Preempt` signal, and there's not enough time to start an application, query the Scheduled Events endpoint, and gracefully shut down. So the health check needs to reside outside the workload environment. The health checks need to monitor the status of the spot VM and start the deployment pipeline to replace the spot VM when the status changes to *deallocating* or *stopping*.

### Plan for multiple simultaneous evictions

If you run a cluster of spot VMs, architect the workload to withstand multiple simultaneous evictions. Multiple spot VMs in the workload can be evicted at the same time. A simultaneous eviction of multiple VMs could affect the throughput of the application. To prevent this situation, your deployment pipeline should be able to gather signals from multiple VMs and deploy multiple replacement VMs simultaneously.

### Design for a graceful shutdown

The VM shutdown process should be less than 30 seconds and allow your VM to shut down before an eviction. The amount of time the shutdown should take depends on how frequently your workload queries the Scheduled Events endpoint. The more often you query the endpoint, the longer the shutdown process can take. The shutdown process should release resources, drain connections, and flush event logs. You should regularly create and save checkpoints to retain the context and build a more efficient recovery strategy. The checkpoint is just information about what processes or transactions the next VM needs to start on. They should indicate if the VM should resume where the previous VM left off or if the new VM should revert the changes and start the entire process again. Store the checkpoints outside the spot VM environment, like in a storage account.

### Test the orchestration

Simulate eviction events to test orchestration in dev/test environments. For more information, see [Simulate eviction](/azure/virtual-machines/linux/spot-cli#simulate-an-eviction).

### Design an idempotent workload

We recommend that you design an idempotent workload. The outcome of processing an event more than one time should be the same as processing it once. Evictions can result in forced shutdowns, despite efforts to ensure graceful shutdowns. Forced shutdowns can terminate processes before completion. Idempotent workloads can receive the same message more than one time without changing the outcome. For more information, see [Idempotency](/azure/architecture/serverless/event-hubs-functions/resilient-design#idempotency).

### Use an application warmup period

Most interruptible workloads run applications. Applications need time to install and to start up. They also need time to connect to external storage and gather information from checkpoints. Have an application warmup period before you allow it to start processing. During the warmup period, the application should start, establish connections, and prepare to contribute. Only allow an application to start processing data after you validate the health of the application.

:::image type="content" source="./media/lifecycle-spot-virtual-machine.png" alt-text="Diagram of the workload lifecycle with an application warmup period." border="false" lightbox="./media/lifecycle-spot-virtual-machine.png":::

### Configure user-assigned managed identities

Assign user-assigned managed identities to streamline the authentication and authorization process. User-assigned managed identities let you avoid putting credentials in code and aren't tied to a single resource like system-assigned managed identities. The user-assigned managed identities contain permissions and access tokens from Microsoft Entra ID that can be reused and assigned to spot VMs during orchestration. Token consistency across spot VMs helps streamline orchestration and simplifies the access to workload resources that the spot VMs have.

If you use system-assigned managed identities, a new spot VM might get a different access token from Microsoft Entra ID. If you need to use system-assigned managed identities, make the workloads resilient to `403 Forbidden Error` responses. Your orchestration needs to get tokens from Microsoft Entra ID with the correct permissions. For more information, see [Managed identities](/entra/identity/managed-identities-azure-resources/overview).

## Example scenario

The example scenario deploys a queue processing application that qualifies as an interruptible workload. The scripts in the scenario serve as examples. The scenario guides you through a one-time, manual push to deploy resources. This implementation doesn't have a deployment pipeline. However, a deployment pipeline is essential to automate the orchestrating process. The following diagram shows the architecture of the example scenario.

:::image type="content" source="./media/spot-virtual-machine-architecture.svg" alt-text="Diagram that shows the example scenario architecture." border="false" lightbox="./media/spot-virtual-machine-architecture.svg":::

[Download a Visio file](https://arch-center.azureedge.net/spot-virtual-machine-architecture.vsdx) of this architecture.

The following workflow corresponds to the previous diagram:

1. **VM application definition:** The VM application definition is created in the Azure compute gallery. It defines the application name, location, operating system, and metadata. The application version is a numbered version of the VM application definition. The application version represents the VM application. It needs to be in the same region as the spot VM. The application version links to the source application package in the storage account.

1. **Storage account:**  The storage account stores the source application package. In this architecture, it's a compressed tar file named `worker-0.1.0.tar.gz`. It contains two files. One file is the `orchestrate.sh` bash script that installs the .NET worker application.

1. **Spot VM:** The spot VM deploys. It must be in the same region as the application version. It downloads `worker-0.1.0.tar.gz` to the VM after deployment. The bicep template deploys an Ubuntu image on a standard family VM. These configurations meet the needs of this application and aren't general recommendations for your applications.

1. **Storage queue:** The other service that runs in the .NET worker contains message queue logic. Microsoft Entra ID grants the spot VM access to the storage queue in Azure Queue Storage with a user-assigned identity by using role-based access control.

1. **.NET worker application:** The `orchestrate.sh` script installs a .NET worker application that runs two background services. The first service queries the Scheduled Events endpoint, looks for the `Preempt` signal, and sends this signal to the second service. The second service processes messages from the storage queue and listens for the `Preempt` signal from the first service. When the second service receives the signal, it interrupts storage queue processing and begins to shut down.

1. **Query Scheduled Events endpoint:** An API request is sent to a static nonroutable IP address `169.254.169.254`. The API request queries the Scheduled Events endpoint for infrastructure maintenance signals.

1. **Application Insights:** The architecture uses Application Insights only for learning purposes. It's not an essential component of interruptible workload orchestration, but allows you to validate the telemetry from the .NET worker application. The .NET worker application sends telemetry to Application Insights. For more information, see [Enable live metrics from the .NET application](/azure/azure-monitor/app/live-stream#enable-live-metrics-using-code-for-any-net-application).

## Next step

> [!div class="nextstepaction"]
> [Spot Virtual Machines](/azure/virtual-machines/spot-vms)

## Related resources

- [Architectural approaches for cost management and allocation in a multitenant solution](../../guide/multitenant/approaches/cost-management-allocation.md)
- [Run a Windows VM on Azure](../../reference-architectures/n-tier/windows-vm.yml)
- [Run a Linux VM on Azure](../../reference-architectures/n-tier/linux-vm.yml)
