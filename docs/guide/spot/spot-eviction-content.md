Spot VMs provide access to compute capacity at significant discounts and are an attractive solution for cost savings. In this article, you'll find recommendations for architecting interruptible workloads with Azure Spot virtual machines (VMs) and a sample implementation you can deploy.

The cost-saving potential of Spot VMs creates a range of new possibilities. The goal of this article is to help you harness those possibilities. It's important to understand what Spot VMs are and identify the right workload candidates. Spots VMs are only recommended for interruptible workloads. Hosting interruptible workloads on Spot VMs requires knowledge of eviction, pricing, and orchestration best practices.

## Understand Spot VMs

A basic VM is an operating system (OS). Azure hardware (servers and hypervisors) deploys and manages VMs with the compute capacity needed. The VM can exist without compute capacity. It just won't be able do anything. Regular ("pay-as-you-go") VMs and spot VMs are identical. There's no difference other than their access priority to underlying hardware and the guarantees around that access.

**(1) Low priority access** - Regular ("pay-as-you-go") VMs and spot VMs are the same technology. They just access priority to compute capacity. Spot VMs have low-priority access to compute capacity. Regular VMs have high-priority access.  Regular VMs can access compute capacity whenever they need it. Spot VMs can only use what the regular VMs don't. Spot VMs can only run and stay running when there's spare compute capacity.

**(2) No SLAs** - Spot VMs don't have an SLA once created. They can lose access to compute capacity at any time. The loss of access to compute capacity is called an eviction. Spot VMs are cheaper because of the eviction possibility. Whenever Azure needs the capacity back, an eviction notice will be sent and evict the VM based on the eviction policy selected for the spot VM at the time of creation. The minimum notice for an eviction notification is 30 seconds. We'll talk more about this notification below.

## Understand interruptible workloads

Spot VMs are a great compute option for interruptible workloads. Interruptible workloads run processes that can be stopped suddenly and resumed later without harm. Interruptible workloads have a few common characteristics. They have minimal time constraints, low organizational priority, and short processing times. Some examples are of interruptible workloads are:

- Message queues
- Batch processing applications
- Background processes
- Data analytics
- CI/CD agents for non-production environments

Spot VMs shouldn’t be the single source of compute capacity for non-interruptible workloads. These feature of non-interruptible workloads:

- Service level agreements (SLAs)
- Sticky sessions requirements
- Stateful workloads

With a basic understanding of interruptible workloads, it's important to understand eviction before starting with spot VMs.

## Understand eviction

Spot VMs are cheaper because they can be evicted. Eviction is when the VM is forced to leave its underlying hardware. This happens when a regular VM needs the specific hardware that the spot VM is using. The hardware that a VM needs is determined by its location and size (processing power, memory, and storage capacity).

Spot VMs have two configuration options that affect eviction. You set the eviction type and eviction policy when you create Spot VMs. Eviction type determines when eviction occurs. Eviction policy determines what eviction does. Let's address each in more detail.

**(1) Eviction type** - Eviction is caused by capacity changes or price change. The way these affect spot VMs depends on the eviction type chosen when the VM was created. Eviction type defines the conditions of eviction. The eviction types are "capacity only eviction" and "price or capacity eviction".

*Capacity only eviction* - The capacity only eviction type triggers an eviction occurs when excess capacity disappears. Use the capacity only eviction type to create more reliability.

*Price or capacity eviction* - The price or capacity eviction type triggers an eviction when excess capacity disappears or the cost of the VM exceeds your max price. When you create spot VM, you set a maximum price. The price or capacity eviction type accounts for the maximum price and triggers and eviction even if capacity exists. Use the price or capacity eviction type to save more money.

**(2) Eviction policy** - The eviction policy chose for a spot VM affects its orchestration. By orchestration, we mean the process of handling an eviction. We cover orchestration in detail below. The eviction policies are the "Stop/Deallocate policy" and "Delete policy".

***Stop/Deallocate policy*** - The Stop/Deallocate eviction policy is best when the workload can wait for release capacity within the same location and VM type.

The Stop/Deallocate policy stops the VM and ends its lease with the underlying compute capacity. Stopping and deallocating a spot VM is the same as stopping and deallocating a regular VM. The VM remains accessible in Azure, and you can redeploy the same VM later.

The effect of the Stop/Deallocate policy is losing compute capacity and all non-static IP addresses. The VM data disks remain and still incur charges. The VM occupies cores in the subscription. For more information, see [VM power states and billing](/azure/virtual-machines/states-billing#power-states-and-billing).

VMs cannot be moved from their region or zone even when stopped and deallocated. You can simulate movement by replicating the VM, deploy it to a new location, and deleting the original VM.

***Delete policy*** - Use the "Delete" policy if the workload can change location or VM size. Changing location and or VM type allows the VM to redeploy faster.

The Delete policy deletes the VM and any data disk. The VM doesn't occupy cores in subscriptions.

For more information on eviction policies, see [eviction policy](/azure/virtual-machines/spot-vms#eviction-policy).

## Understand spot pricing

The Spot VMs discount depends on VM size, region of deployment, and operating system. The price of spot VMs fluctuates with demand. The table below gives examples of the cost difference between spot VMs and pay-as-you-go VMs:

| VM size | OS | Region | Spot price (USD) | Pay-as-you-go price (USD) |
| --- | --- | --- | --- | --- |
|**D1 v2** | Windows<br><br><br>RHEL | East US<br>West US<br><br>East US<br>West US | $55.15<br>$18.93<br><br>$65.11<br>$50.81 | $91.98<br>$91.98<br><br>$97.09<br>$94.90
|**E2a v4**| Windows<br><br><br>RHEL | East US<br>West US<br><br>East US<br>West US | $23.87<br>$25.40<br><br>$53.00<br>$54.02 | $159.14<br>169.36<br><br>$135.78<br>$146.00|

For more information, see:

- [Spot VM pricing](/azure/virtual-machines/spot-vms#pricing)
- [Spot VM pricing tool](https://azure.microsoft.com/pricing/spot-advisor/)

## Recommendations

## Design for flexibility

Workloads on Spot VMs need flexibility. Your orchestration to switch VM types, VM sizes, regions, zone, and resume work later, if possible.

- **Deletion also removes the disks. Data disks persists with deallocation.**
- Cost of keeping data.
- Business logic should account.
- These are the same considerations involved in Spot VM creation.

## Find the right VM

We recommend identifying a few VM types that have the power to run the application and fit within budget constraints. It will give your orchestration more options to choose from and find spare compute capacity faster.

You should filter VMs min vCPUs/Cores and/or min RAM, and max price to find the right spot VM SKU for you that will derive in a list of possible SKUs.

### Prepare for immediate eviction

**HOW DO YOU PREPARE FOR AN IMMEDIATE EVICTION?**
- Orchestration a VM in place for immediate eviction. 
- Orchestration - started VM, first 


### Continuously monitor for eviction

Monitoring is the key to workload reliability on spot VMs. Spot VMs have no SLA after creation and can be evicted at any time. The best way to improve workload reliability on spot VMs is knowing in advance when they're going to be evicted. With this information, you can trigging automation for a graceful shutdown and orchestrate a replacement.

We recommend monitoring the Scheduled Events for each VM. Each VM has a REST endpoint that provides information about upcoming infrastructure maintenance. These are called Schedule Events, and evictions qualify as a Scheduled Event. You can query the Scheduled Event information via a static, non-routable IP address `169.254.169.254`. Workloads using spot VMs need to query the endpoint frequently enough take action. It is recommended to query the endpoint every second.

The `Preempt` signal indicates an scheduled eviction. The automation trigger should listen for this signal and begin the shutdown and subsequent orchestration.

For more information, see:

- [Scheduled Events](/azure/virtual-machines/windows/scheduled-events)
- [Scheduled Event types](/azure/virtual-machines/linux/scheduled-events#event-scheduling)
- [Endpoint querying frequency](/azure/virtual-machines/linux/scheduled-events#polling-frequency)
- [Application Insights telemetry](/azure/azure-monitor/app/data-model)


### Plan for multiple simultaneous evictions

You should architect the workload to withstand multiple simultaneous evictions. The workload could lose 10% compute capacity, and it will have a significant effect on the throughput of the application.

**ARCHITECT A SOLUTION WITH PARALLEL PROCESSING? EVENT DRIVEN AUTOSCALE FUNCTIONS? WHERE DOES THE AUTOMATION TRIGGER COME FROM: QUEUE, NET WORKER, OR APPLICATION INSIGHTS?**

### Design for a graceful shutdown

An ideal shutdown implements logic to shutdown in under 10 seconds. The telemetry should trigger infrastructure automation to recover the compute capacity and resume operations. Azure Monitor alerts tha trigger an Azure Function is one of several ways to automate the orchestration.

The shutdown process should release resources, drain connections, and flush event logs. It's a good practice to save the context by creating checkpoints regularly. Doing so will create a more efficient recovery strategy, which is to recover from the latest well-known checkpoint instead of starting all over on processing.

### Build indempotency

We recommend designing idempotent consumers. Evictions can lead to forced shutdowns despite efforts to ensure graceful shutdowns. Forced shutdowns can terminate processes before completion. Idempotent consumers can receive the same message more than once and the outcome remains the same.

For more information, see [idempotency](/azure/architecture/serverless/event-hubs-functions/resilient-design#idempotency).


### Orchestrate eviction recovery

Recovery is the process of replacing a Spot VM after an eviction. Application architecture and logic should be able to recover from a previous backup or checkpoint if necessary.

The eviction policy of the evicted Spot VM affects the replacement process.

**(1) Replace VMs** - You'll need a plan to replace evicted VMs. The plan has to account for the eviction policy of the VM. A Spot VM with a *Stop/Deallocate policy* will need to be reallocated. A Spot VM with a Delete policy will need to be recreated. The different between reallocation and recreation affect when and where Spot VM replacements

***When using an Azure Spot Instance, what is the best way to have it reallocate when it is evicted?***

- ***Stopped / Deallocated VM*** - A stopped / deallocated Spot VM remains accessible in Azure. The VM, a packaged OS, loses its compute capacity, but the VM package remains in Azure. You cannot move VMs between datacenters/zones. The reallocation of a stopped / deallocated VM has to be in the same region and zone it was in. You can replicate, deploy, and delete to simulate movement.

If your workload was designed around **deallocate** then you'll need a mechanism to be made aware of when your compute instance can come back online. **WHAT MECHANISM DO YOU RECOMMEND?**

- ***Deleted VM*** - A deleted Spot VM is removed from Azure. A replacement needs to be *created* and assigned compute capacity, not just reallocated. Deletion allows the orchestration to deploy replacement spot VMs to new zones and regions. This deployment flexibility can help your workload find spare compute capacity faster than a stopped / deallocated VM. Stopped / deallocated VMs have to wait for spare compute capacity in the same zone it was created in. You'll need a process to monitor for evictions external to the application and initiative remediation by deploying to alternative regions or SKUs.

**(2) Conduct health check** - It's a good idea to transition into a warmup state to ensure the workload is healthy and ready to start. After the application *warmup* state is completed, you could consider internally transitioning into the *processing* state.

### Conduct testing

We recommend simulating eviction events to test orchestration in dev/test environments.

For more information, see [simulate eviction](/azure/virtual-machines/linux/spot-cli#simulate-an-eviction).

## Example scenario

The example scenario is for a queue processing application. It uses a producer-consumer dataflow. The scripts in the scenario are illustrative. They aren't the key to success on SpotVMs. The most important aspect of the example is the continuous integration / continuous development (CI/CD) pipeline to orchestrate the spot VMs. The scenario does a one-time push to deploy the ARM template for the example, but a push/pull mechanism should be in place to enable orchestration.

The bicep template deploys an Ubuntu image (22_04-lts-gen2) on a Standard_D2s_v3 VM with a premium managed disk and local redundant storage (LRS). These configurations meet the needs of this application and aren't general recommendations for your applications.

![Diagram of the example scenario architecture](./media/spot-vm-arch.png)

1. **VM application definition:** The VM application definition is created in the Azure Compute Gallery. It defines the application name, location, operating system, and metadata. The application version is a numbered version of the VM application definition. The application version is an instantiation of the VM application. It needs to be in the same region as the spot VM. The application version links to the source application package in the storage account.
1. **Storage account:**  The storage account stores the source application package. In this architecture, it's a compressed tar file named `worker-0.1.0.tar.gz`. It contains two . One i the `orchestrate.sh` powershell script that installs the .NET worker application.
1. **Spot VM:** The spot VM deploys. It must be in the same region as the application version. It downloads `worker-0.1.0.tar.gz` to the VM after deployment.
1. **Storage Queue:** The other service running in the .NET worker contains message queue logic. Azure AD grants the spot VM access to the storage queue with a user assigned identity using RBAC.
1. **.Net worker application:** The orchestrate.sh script installs a .NET worker application that runs two background services.
1. **Query metadata endpoint:** An API request is sent to a static non-routable IP address 169.254.169.254​ in the VM. The API request queries the metadata endpoint for the VM from the Metadata Service endpoint.
1. **Application Insights:** The listens for the preempt eviction signal. For more information, see [enable live metrics from .NET application](/azure/azure-monitor/app/live-stream#enable-live-metrics-using-code-for-any-net-application).


## Deploy this scenario

An implementation of this guidance is available on [GitHub: Interruptible workloads on Azure Spot VM](https://github.com/mspnp/interruptible-workload-on-spot). You can use that implementation to explore the topics addressed above in this article.

## Next step

 See the Azure Well-Architected Framework's [cost optimization guidance for Virtual Machines](/azure/architecture/framework/services/compute/virtual-machines/virtual-machines-reviewcost-optimization).
 Explore [VM Applications](/azure/virtual-machines/vm-applications) as part of your workload orchestration.

## Extra content

request for compute capacity by on demand VM. If none, then Azure infrastructure claims compute capacity is available. A preempt event type will be logged on the metadata endpoint. The response identifies the VM to be evicted. Information available.

### Spot VM states

The diagram below visualizes the following states:

- Stopped or Deleted (eviction policy based)
- Running (based on capacity and max price you set)

![State diagram depicting how Azure VM Spot VM and scale sets behaves depending on policy, capacity and price.](./media/spot-state-diagram.png)



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


- **Simulation** - It's possible to [simulate an eviction event](/azure/virtual-machines/spot-portal#simulate-an-eviction.md) when Azure needs the capacity back. We recommend you become familiar with this concept so that you can simulate interruptions from dev/test environments to guarantee your workload is fully interruptible before deploying to production.

### Events

[Azure Scheduled Events](/azure/virtual-machines/windows/scheduled-events) is a metadata service in Azure that signal about forthcoming events associated to the Virtual Machine resource type. The general recommendation when using Virtual Machines is to routinely query this endpoint to discover when maintenance will occur, so you're given the opportunity to prepare for disruption. One of the platform event types being scheduled that you'll want to notice is `Preempt` as this signals the imminent eviction of your spot instance. This event is scheduled with a maximum amount of time of 30 seconds in the future. Given that, you must assume that you're going to have less than that amount of time to limit the impact to your running workload. The recommended practice here is to check this endpoint based on the periodicity your workload mandates (such as every 10 seconds) to attempt having a graceful interruption.

## The workload

One common workload type for Azure Spot VMs is queue processing applications. The reference implementation guide contains a simple, asynchronous queue-processing worker (C#, .NET) implemented in combination with [Azure Queue Storage](/azure/storage/queues/storage-queues-introduction). This implementation demonstrates how to query the [Azure Scheduled Events REST](/azure/virtual-machines/linux/scheduled-events) endpoint, as mentioned above.

### Planning for workload interruption

#### Application states

When architecting reliable and interruptible workloads, you'll want to focus on four main stages during the workload's lifecycle. These stages will translate into changes of states within your application.

- **Start**: After the application _warmup_ state is completed, you could consider internally transitioning into the _processing_ state. One important thing to consider is if there was a forced shutdown previously, then there might be some incomplete processing and we recommend that you implement idempotency as applicable. Additionally, it's good practice to save the context by creating checkpoints regularly. Doing so will create a more efficient recovery strategy, which is to recover from the latest well-known checkpoint instead of starting all over on processing.

- **Shutdown**: Your application is in the _processing_ state and at the same time an eviction event is triggered by the Azure infrastructure. Compute capacity must be collected from Azure Spot instances, and as a result, an eviction notice will take place in your VM instance, which your application was actively monitoring for. At this time, your application will change its state to _evicted_ and implement the logic you've programmed that responds to the eviction notice. It will gracefully shut down in under 30 seconds (best to target 10 or less seconds) by releasing resources such as draining connections and event log flushing, or it will prepare to be forcedly deallocated or deleted based on your **Eviction Policy**. In the latter configuration, as a general rule, you can't persist any progress or data on the file system, because disks are being removed along with the Azure VM.

- **Recover**: In this stage, your workload is _redeployed_ or _recreated_ depending on your **Eviction Policy**. During recovery, these possible states are detected based on your scenario. You can implement the logic to deal with a prior forced shutdown, so your application is able to recover from a previous backup or checkpoint if necessary.

- **Resume**: The application is about to continue processing after a best effort to recover the context prior to eviction. It's a good idea to transition into a _warmup_ state to ensure the workload is healthy and ready to start.

![A workload lifecycle diagram depicting the four possible stages interruptible workloads should contemplate during their lifetime.](./media/lifecycle-spot-virtual-machine.png)

> [!NOTE]
> The aforementioned states are just a reduced list of possible conditions for a reliable interruptible workload. You might find other states that are convenient for modeling the lifecycle of your own workloads.

#### System states

The implementation uses a **Distributed Producer Consumer** system type, where the interruptible workload represents a batch processing application acting as the consumer. Since you'd mainly consider Azure Spot VMs for cost optimization, we recommend looking into the issues that can arise with this kind of solution and architect mitigations to avoid wasting excess compute cycles. One class of examples would be concurrency problems.

* [Deadlock](https://wikipedia.org/wiki/Producer%E2%80%93consumer_problem)
* [Starvation](https://wikipedia.org/wiki/Scheduling_(computing)#Scheduling_disciplines), by evaluating which scheduling system you're using and avoiding a solution would lead to starvation. For example, a fixed-priority preemptive scheduling system isn't advised for max priority queues that are never expected to be emptied.

In general, we recommend that you always take edge cases and common pitfalls associated to the system types you're building into account. Design their architectures to maximize the system type's expected behavior will benefit while running on top of Azure Spot VMs.

> [!NOTE]
> The reference implementation follows the simple concurrency strategy: **do nothing**. Since you're going to deploy a single interruptible workload instance (consumer) and produce a moderate and discrete number of messages, there would be no expectations of a deadlock or starvation as a system state. One recommendation to prevent your system from running into such states is to consider handling them if detected at the time of workload orchestration.

#### Orchestration

Orchestration in this context is about workload recovery after eviction.  Your choice of **delete** or **deallocate** will influence how you architect your solution to "resume operations" after your instance(s) have been evicted.  If your workload was designed around **delete** you'll need a process to monitor for evictions external to the application and initiative remediation by deploying to alternative regions or SKUs.  

Either way, the end goal is the same.  The interruptible workload begins executing on an Azure Spot VM at startup time.

It will be helpful to kick off the application after eviction or the first time the Azure Spot VM gets deployed. This way, the application will be able to continue processing messages without human intervention from the queue once started. Once the application is running, it will transition through the `Recover`, `Resume`, and `Start` application stages.

By design, the orchestration could have more or less responsibilities like running after the machine has started up, downloading the workload package from an Azure Storage Account, decompressing files, executing the process, coordinating how many instances are going to be running in parallel, system recovery, and more.

Consider using [VM Applications](/azure/virtual-machines/vm-applications) to package and distribute your interruptible workloads as part of your orchestration process. This mechanism allows for VMs to be defined, declaratively, with the specific workload in mind.  Using VM Applications can simplify your pipelines and provide a helpful separation of concerns between the management of Spot VM instances and the instantiation of the workload on those instances.  The implementation in GitHub demonstrates this.

![A diagram depicting the Azure Spot VM infrastructure at orchestration time.](./media/spot-orchestration-diagram.png)

Another important orchestration related aspect to understand is how to scale your workload within a single VM instance, so it's using its resources efficiently.  Many workloads will span multiple VMs, but this guidance is still applicable to each VM within that system.

- **Scale up strategy**

    If your workload is built with no artificial constraints and it will grow to consume available resources in your VM instance without exhausting them. You'll want to ensure that it's running a singleton of the workload and let it organically request resources as designed. If you design your application to consume all available resources, this will give you compute SKU flexibility to include smaller or larger SKUs in your application.  You may find running mixed SKUs in your solution common.

    ![A diagram depicting the Azure Spot VM infrastructure orchestration scale up strategy.](./media/spot-orchestration-scale-up-diagram.png)

- **Scale out strategy**

    Alternatively, if the workload resources specs are limited by design and it can't grow to consume VM resources, ensure your VM is the right size to orchestrate multiple whole instances of your workload. Doing so will ensure there's no wasted over-provisioning of compute resources in your Spot VM.  This will impact your workload orchestration strategy.

    ![A diagram depicting the Azure Spot VM infrastructure orchestration scale out strategy.](./media/spot-orchestration-scale-out-diagram.png)
