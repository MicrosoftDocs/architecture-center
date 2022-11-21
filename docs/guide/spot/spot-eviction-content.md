Spot VMs provide access to compute capacity at significant discounts and are an attractive solution for cost savings. In this article, you'll find recommendations for architecting interruptible workloads with Azure Spot virtual machines (VMs) and a sample implementation you can deploy.

The cost-saving potential of Spot VMs creates a range of new possibilities for workload design. The goal of this article is to help you give you the knowledge to make the right design decisions. It's important to understand what Spot VMs are and identify the right workload candidates. Spots VMs are only recommended for workloads that can be interrupted and resumed. Hosting interruptible workloads on Spot VMs requires knowledge of eviction, pricing, and orchestration best practices.

## Understand Spot VMs

A basic VM is an operating system (OS). Azure hardware (servers and hypervisors) deploys and manages VMs with the compute capacity needed. The VM can exist without compute capacity. It just won't be able do anything. Regular ("pay-as-you-go") VMs and spot VMs are identical. There's no difference other than their access priority to underlying hardware and the guarantees around that access.

**(1) Low priority access** - Regular ("pay-as-you-go") VMs and spot VMs are the same technology. They just access priority to compute capacity. Spot VMs have low-priority access to compute capacity. Regular VMs have high-priority access.  Regular VMs can access compute capacity whenever they need it. Spot VMs can only use what the regular VMs don't. Spot VMs can only run and stay running when there's spare compute capacity.

**(2) No SLAs** - Spot VMs don't have an SLA once created. They can lose access to compute capacity at any time. The loss of access to compute capacity is called an eviction. Spot VMs are cheaper because of the eviction possibility. Whenever Azure needs the capacity back, an eviction notice will be sent and evict the VM based on the eviction policy selected for the spot VM at the time of creation. The minimum notice for an eviction notification is 30 seconds. We'll talk more about this notification below.

## Understand interruptible workloads

Spot VMs are a compute option for interruptible workloads. Interruptible workloads run processes that can stop suddenly and resumed later without harming essential organizational processes. Interruptible workloads have a few common characteristics. They have minimal time constraints, low organizational priority, and short processing times. Spot VMs shouldn’t be the single source of compute capacity for non-interruptible workloads. These features of non-interruptible workloads have service level agreements (SLAs), sticky sessions requirements, and stateful data requirements. The table provides examples for each category.

| Interruptible workloads | Regular workloads
| --- | --- |
| - Message queues <br>- Batch processing <br>- Background processes <br>- Data analytics <br>- CI/CD agents for non-production environments | - Service level agreements (SLAs) <br>- Sticky sessions requirements <br>- Stateful workloads |

With a basic understanding of interruptible workloads, it's important to understand eviction before starting with spot VMs.

## Understand eviction

Spot VMs are cheaper because they can be evicted. Eviction is when the VM is forced to leave its underlying hardware. Evictions happen when a regular VM needs the specific hardware that the spot VM is using. The hardware that a VM needs is determined by its location and size (processing power, memory, and storage capacity).

Spot VMs have two configuration options that affect eviction. You set the eviction type and eviction policy when you create Spot VMs. Eviction type determines when eviction occurs. Eviction policy determines what eviction does. Let's address each in more detail.

**(1) Eviction type** - Eviction is caused by capacity changes or price change. The way these affect spot VMs depends on the eviction type chosen when the VM was created. Eviction type defines the conditions of eviction. The eviction types are "capacity only eviction" and "price or capacity eviction".

*Capacity only eviction* - The capacity only eviction type triggers an eviction occurs when excess capacity disappears. Use the capacity only eviction type to create more reliability.

*Price or capacity eviction* - The price or capacity eviction type triggers an eviction when excess capacity disappears or the cost of the VM exceeds your max price. When you create spot VM, you set a maximum price. The price or capacity eviction type accounts for the maximum price and triggers and eviction even if capacity exists. Use the price or capacity eviction type to save more money.

**(2) Eviction policy** - The eviction policy chose for a spot VM affects its orchestration. By orchestration, we mean the process of handling an eviction. We cover orchestration in detail below. The eviction policies are the "Stop/Deallocate policy" and "Delete policy".

*Stop/Deallocate policy* - The Stop/Deallocate eviction policy is best when the workload can wait for release capacity within the same location and VM type. The Stop/Deallocate policy stops the VM and ends its lease with the underlying compute capacity. Stopping and deallocating a spot VM is the same as stopping and deallocating a regular VM. The VM remains accessible in Azure, and you can redeploy the same VM later. With the Stop/Deallocate policy, the VM loses compute capacity and non-static IP addresses. But the VM data disks remain and still incur charges, and the VM still occupies cores in the subscription. VMs can't be moved from their region or zone even when stopped/deallocated. You can simulate movement by replicating the VM, deploy it to a new location, and deleting the original VM. For more information, see [VM power states and billing](/azure/virtual-machines/states-billing#power-states-and-billing).

*Delete policy* - Use the "Delete" policy if the workload can change location or VM size. Changing location and or VM type allows the VM to redeploy faster. The Delete policy deletes the VM and any data disk. The VM doesn't occupy cores in subscriptions. For more information on eviction policies, see [eviction policy](/azure/virtual-machines/spot-vms#eviction-policy).

## Understand spot pricing

Spot VMs are up to 90 percent cheaper than regular (pay-as-you-go) VMs. The discount varies based on demand, VM size, region of deployment, and operating system. We recommend you use the Azure Spot VM pricing tool to get an estimate of the cost savings. For more information, see:

- [Azure Spot VM pricing tool](https://azure.microsoft.com/pricing/spot-advisor/)
- [Spot VM pricing overview](/azure/virtual-machines/spot-vms#pricing)

## Understand orchestration

Orchestration is the process of replacing a spot VM after an eviction. Orchestration should be as flexible as possible. We recommend building orchestration to use multiple VM sizes and several locations to improve flexibility. Below are orchestration recommendations you should consider.

**(1) Use multiple VM sizes and locations** - You should identify a few VM sizes that have the power to run your workload and fit within your budget. These VM size options will give your orchestration more options to choose from and find spare compute capacity faster. You should filter VMs min vCPUs/Cores and/or min RAM, and max price to find the right spot VM SKU for you that will derive in a list of possible SKUs.

**(2) Use the most flexible eviction policy** - The eviction policy of the evicted Spot VM affects the replacement process. A delete eviction policy is more flexible than a stopped/deallocated eviction policy.

*Consider the delete policy first* - We recommend using a delete eviction policy if your workload can handle it. Deletion allows the orchestration to deploy replacement spot VMs to new zones and regions. This deployment flexibility can help your workload find spare compute capacity faster than a stopped / deallocated VM. Stopped / deallocated VMs have to wait for spare compute capacity in the same zone it was created in. You'll need a process to monitor for evictions external to the application and initiative remediation by deploying to alternative regions or SKUs.

*Consider simulated movement with stopped/deallocated policy* - The simple reallocation of a Stopped/Deallocated VM has to be in the same region and zone it was in. You'll need a mechanism to be made aware of when your compute instance can come back online. **WHAT MECHANISM DO YOU RECOMMEND?** However, you can simulate movement with a Stopped/Deallocation policy. You can replicate the original VM, deploy it to a new location, and delete the old VM. **WHAT'S THE FASTEST WAY TO DO THIS?**

| Policy | When |
| --- | --- |
| Delete | ? |
| Stopped/Deallocated | ?  |

**WE NEED TO FILL OUT THIS TABLE?**

**(3) Continuously monitor for eviction** - Monitoring is the key to workload reliability on spot VMs. Spot VMs have no SLA after creation and can be evicted at any time. The best way to improve workload reliability on spot VMs is knowing in advance when they're going to be evicted. With this information, you can trigger automation for a graceful shutdown and orchestrate a replacement.

*Use Scheduled Events* - We recommend using the Scheduled Events service for each VM. Azure has different infrastructure maintenance types and each type generates a distinct signal. Evictions qualify as infrastructure maintenance and send out the `Preempt` signal to all affected VMs. A service called Schedule Events allows you to capture the `Preempt` signal for VM. The Scheduled Events service provides a queryable endpoint at a static, non-routable IP address `169.254.169.254`. Azure infrastructure generates the `Preempt` signal for affected VMs at a minimum 30 seconds before an eviction. You might not query the endpoint the second `Preempt` signal arrives, so you need to build your orchestration around these constraints.

*Use frequent queries* - We recommend querying the endpoint often enough to orchestrate a graceful shutdown. You can query the Scheduled Events endpoint up to every second for the most, but one-second frequency might not be necessary for all use cases. **IS THERE A COST ASSOCIATED WITH QUERIES?**

*Automate orchestration* - Once you collect the `Preempt` signal, your orchestration should act on that signal. Given the time constraints, the `Preempt` signal should start an automated process of gracefully shutting down your VM and the replace process. For more information, see:

- [Scheduled Events](/azure/virtual-machines/windows/scheduled-events)
- [Scheduled Event types](/azure/virtual-machines/linux/scheduled-events#event-scheduling)
- [Endpoint querying frequency](/azure/virtual-machines/linux/scheduled-events#polling-frequency)
- [Application Insights telemetry](/azure/azure-monitor/app/data-model)

**(4) Build push/pull system** - **WE NEED TO PROVIDE RECOMMENDATIONS HERE**

**(5) Prepare for immediate eviction** - Your orchestration needs to account for immediate evictions. It's possible that your spot VM will be designated for eviction as soon as it's created. The `Preempt` signal will still provide a minimum of 30-seconds advance notice of the eviction. We recommend building orchestration that can withstand immediate evictions. **HOW DO YOU PREPARE FOR AN IMMEDIATE EVICTION? WHERE SHOULD ORCHESTRATON LOGIC SIT?**

**(6) Plan for multiple simultaneous evictions** - You should architect the workload to withstand multiple simultaneous evictions. The workload could lose 10% compute capacity, and it will have a significant effect on the throughput of the application.

**(7) Design graceful shutdown** - We recommend VM shutdown processes take 10 seconds or less. The shutdown process should release resources, drain connections, and flush event logs. You should regularly create and save checkpoints (**BE MORE SPECIFIC. CHECKPOINTS FOR WHAT?) to save the context and build a more efficient recovery strategy. Orchestration should recover from the latest checkpoint instead of starting all over on processing.

There are several ways to automate a graceful shutdown. You can use Azure Monitor alerts and trigger an Azure Function is one of several ways to automate the orchestration. **IS THIS APPLICABLE TO ORCHESTRATION IN GENERAL?**

**(8) Build idempotency** - We recommend designing an idempotent workload. The outcome of processing an event more than once should be the same as processing it once. Evictions can lead to forced shutdowns despite efforts to ensure graceful shutdowns. Forced shutdowns can terminate processes before completion. Idempotent workloads can receive the same message more than once and the outcome remains the same. For more information, see [idempotency](/azure/architecture/serverless/event-hubs-functions/resilient-design#idempotency).

**(9) Conduct health check** - It's a good idea to transition into a warmup state to ensure the workload is healthy and ready to start. After the application *warmup* state is completed, you could consider internally transitioning into the *processing* state.

**(10) Test orchestration** We recommend simulating eviction events to test orchestration in dev/test environments. For more information, see [simulate eviction](/azure/virtual-machines/linux/spot-cli#simulate-an-eviction).

## Example scenario

We built an example scenario for Spot VMs. It deploys a queue processing application that qualifies as an interruptible workload. The scripts in the scenario are illustrative. The most important aspect of the example is the continuous integration / continuous deployment (CI/CD) pipeline to orchestrate the spot VMs. The scenario does a one-time push to deploy the ARM template for the example, but a push/pull mechanism should be in place to enable orchestration. **WE NEED TO ELABORATE ON THIS IN THE GUIDANCE ABOVE.**

The bicep template deploys an Ubuntu image (22_04-lts-gen2) on a Standard_D2s_v3 VM with a premium managed disk and local redundant storage (LRS). These configurations meet the needs of this application and aren't general recommendations for your applications.

![Diagram of the example scenario architecture](./media/spot-vm-arch.png)

1. **VM application definition:** The VM application definition is created in the Azure Compute Gallery. It defines the application name, location, operating system, and metadata. The application version is a numbered version of the VM application definition. The application version is an instantiation of the VM application. It needs to be in the same region as the spot VM. The application version links to the source application package in the storage account.
1. **Storage account:**  The storage account stores the source application package. In this architecture, it's a compressed tar file named `worker-0.1.0.tar.gz`. It contains two files. One file is the `orchestrate.sh` PowerShell script that installs the .NET worker application.
1. **Spot VM:** The spot VM deploys. It must be in the same region as the application version. It downloads `worker-0.1.0.tar.gz` to the VM after deployment.
1. **Storage Queue:** The other service running in the .NET worker contains message queue logic. Azure AD grants the spot VM access to the storage queue with a user assigned identity using RBAC.
1. **.Net worker application:** The orchestrate.sh script installs a .NET worker application that runs two background services. **WHAT DO THESE SERVICES DO?**
1. **Query Scheduled Events endpoint:** An API request is sent to a static non-routable IP address 169.254.169.254. The API request queries the Scheduled Event endpoint for infrastructure maintenance signals.
1. **Application Insights:** It listens for the `Preempt` signal. **WHAT ELSE DOES AI DO HERE?** For more information, see [enable live metrics from .NET application](/azure/azure-monitor/app/live-stream#enable-live-metrics-using-code-for-any-net-application).

## Deploy this scenario

An implementation of this guidance is available on [GitHub: Interruptible workloads on Azure Spot VM](https://github.com/mspnp/interruptible-workload-on-spot). You can use that implementation to explore the topics addressed above in this article.

## Next step

 See the Azure Well-Architected Framework's [cost optimization guidance for Virtual Machines](/azure/architecture/framework/services/compute/virtual-machines/virtual-machines-reviewcost-optimization).
 Explore [VM Applications](/azure/virtual-machines/vm-applications) as part of your workload orchestration.
