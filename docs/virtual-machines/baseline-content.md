
This article provides a foundational reference architecture for a workload deployed on Azure Virtual Machines (VMs).

The example workload assumed by this architecture is an internet-facing multi-tier web application that's deployed on separate sets of VMs. VMs are provisioned as part virtual machine scale set deployments. This architecture can be used for these scenarios:

- **Private applications**. These include internal line-of-business applications or commercial off-the-shelf (COTS) solutions.
- **Public applications**. These are internet-facing applications. This architecture isn't for high-performance computing (HPC), mission-critical workloads, latency-sensitive applications, or other highly specialized use cases.

However, the primary focus of this architecture isn't the application. Instead, the article provides guidance for configuring and deploying the infrastructure components with which the application interacts. These components include compute, storage, networking, monitoring and more. This architecture serves as a starting point for an Infrastructure-as-a-Service (IaaS)-hosted workload. The data tier is intentionally excluded from this guidance, to maintain the focus on the infrastructure.

## Article layout


|Architecture| Design decisions|Well-Architected Framework approaches|
|---|---|---|
|&#9642; [Architecture diagram](#architecture) <br>&#9642; [Workload resources](#workload-resources) <br> &#9642; [Supporting resources](#workload-supporting-resources) <br> &#9642; [User flows](#user-flows) <br> |&#9642; [VM design choices](#virtual-machine-design-choices)<br> &#9642; [Disks](#disks) <br> &#9642; [Networking](#network-layout) <br> &#9642; [Monitoring](#monitoring) <br> &#9642; [Update management](#update-management) |  <br> &#9642; [Reliability](#reliability) <br> &#9642; [Security](#security) <br> &#9642; [Cost Optimization](#cost-optimization)|

> [!TIP]
> ![GitHub logo](../_images/github.svg) The best practices described in this architecture are demonstrated by a [**reference implementation**](https://github.com/mspnp/iaas-baseline).
> The implementation includes an application that's a small test harness that will exercise the infrastructure setup end-to-end.

## Architecture

:::image type="content" source="./media/baseline-architecture.svg" alt-text="Virtual machine baseline architectural diagram" lightbox="./media/baseline-architecture.png":::

For information about these resources, see Azure product documentation listed in [Related links](#related-links).

### Workload resources

- **Azure Virtual Machine** (VM) serves as the compute resource for the application and is distributed across availability zones. For illustrative purposes, a combination of both Windows and Linux VMs are used.

    **Azure Virtual Machine Scale Sets** in Flexible orchestration mode is used to provision and manage the virtual machines.

    The sample application can be represented in two tiers, each requiring its own compute.

    1. Frontend runs the web server and receives user requests.
    1. Backend runs runs another web server acting as a web API that exposes a single endpoint where the business logic is executed.

    The frontend VMs have data disks (Premium_LRS) attached, which could be used to deploy stateless application. The backend VMs persists data to [local disks](#managed-disks) as part of its operation. This layout may be extended to include a database tier for storing state from the frontend and backend compute. That tier is outside the scope of this architecture.

- **Azure Virtual Network** provides a private network for all workload resources. The network is segmented into subnets, which serve as isolation boundaries.

- **Azure Application Gateway** is the single point of ingress routing requests to the frontend servers. The selected SKU has integrated Azure Web Application Firewall (WAF) for added security.

- **Azure internal Load Balancer** routes traffic from the frontend tier to the backend servers.

- **Azure Load Balancer** Standard SKU provides outbound internet access to the VMs using three public IP addresses.

- **Azure Key Vault** stores the certificates used for end-to-end TLS communication. It could also be used for application secrets.

### Workload supporting resources

- **Azure Bastion** provides secured operational access to the VMs over secure protocols.

- **Azure Application Insights** collects logs and metrics from the application. Because the application isn't the focus of this architecture, log collection isn't demonstrated in the implementation.

- **Azure Log Analytics** is the monitoring data sink that collects logs and metrics from the Azure resources and Application Insights. A storage account is provisioned as part of the workspace.

### User flows

There are two types of users who interact with the workload resources: Workload user and Operator. These flows are shown the architecture diagram. 

#### Workload user

1. The user accesses the web site by using the exposed public IP address of Azure Application Gateway.

1. Application Gateway receives HTTPS traffic, decrypts data using an external certificate for WAF inspection, and re-encrypts it using the internal wildcard certificate for transport to the frontend.

1. Application Gateway balances traffic across frontend VMs and connects to a frontend VM.

1. The selected frontend VM communicates to a backend VM by using the private IP address of the Load Balancer, not the IP of any individual VM.

1. The backend VM decrypts the request using the internal certificate. After processing the request, the backend returns the result to the frontend, which returns the result to the Application Gateway, and it finally returns the result to the user.

#### Operator

The VMs in this architecture may require direct access by operators but it's recommended that remote access is minimized through automation and access is monitored. The access might be for break-fix situations, troubleshooting, or part of an automated deployment process. This architecture doesn't have public IPs for control plane access. Azure Bastion acts as a serverless gateway, enabling operations to access via SSH or RDP. This setup ensures secure and efficient access management.

1. The operator logs into the Azure portal or az-cli.
1. The operator accesses the Azure Bastion service and remotely connects to the desired VM.

## Virtual machine design choices

When selecting SKUs, it's important to have a baseline performance expectation. The decision-making process will be influenced by several characteristics, including:

- CPU, memory, and disk input/output operations per second (IOPS)
- Processors architecture
- Operating system (OS) image size

For instance, if you're migrating a workload from an on-premises environment that uses Intel processor machines, choose VM SKUs that support Intel processors. 

For information about the supported VM SKUs, see [Sizes for virtual machines in Azure](/azure/virtual-machines/sizes).


##### VM connectivity

To enable private communication between a VM and other devices in a particular Virtual Network, one of its subnets is bound to the VM's Network interface (NIC). If you require multiple NICs for your VM, be aware that a maximum number of NICs is defined for each VM size.

If the workload needs low latency communication between VMs in the virtual network, take advantage of **accelerated networking** supported by Azure VM NICs. For more information, see [Benefits of accelerated networking](/azure/virtual-network/accelerated-networking-overview?tabs=redhat#benefits).

##### Virtual Machine Scale Sets with flexible orchestration

VMs are provisioned as part of Azure Virtual Machine Scale Sets with [Flexible orchestration](/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-orchestration-modes#scale-sets-with-flexible-orchestration). Virtual Machine Scale Sets are logical groupings of VMs that can be identical or of multiple types to meet business needs. They allow lifecycle management of machines, network interfaces, and disks using standard Azure VM APIs and commands.

Flexible orchestration mode facilitates operations at scale and helps with granular scaling decisions.

Fault domains configuration is needed to limit the effect of physical hardware failures, network outages, or power interruptions. With scale sets, Azure evenly spreads instances across fault domains for resilience against a single hardware or infrastructure issue.

It's recommended that you offload fault domain allocation to Azure for maximum instance spreading, enhancing resilience and availability.


## Disks

To run the OS and application components, storage disks are attached to the VM. Consider using **Ephemeral disks for the OS** and **managed disks for data storage**.

Azure provides a range of options in terms of performance, tunability, and cost. Start with Premium SSD for most production workloads. The choice is linked to the VM SKU. SKUs that support Premium SSD contain 's' in the resource name, for example 'Dsv4' but not 'Dv4.'

For more information about the disk options with metrics such as capacity, IOPS, throughput and others, see [Disk type comparison](/azure/virtual-machines/disks-types#disk-type-comparison).

Consider disk characteristics and performance expectations when selecting a disk.

- **VM SKU limitations**. Disks operate within the VM they're attached to, which have IOPS and throughput limits. Ensure the disk doesn't cap the VM's limits and vice versa. Select the disk size, performance, and VM capabilities (core, CPU, memory) that optimally run the application component. Avoid overprovisioning because it impacts cost.

- **Configuration changes**. Some disk performance and capacity configurations can be changed while a VM is running. However, many changes may require reprovisioning and rebuilding disk content, affecting workload availability. Therefore, carefully plan disk and VM SKU selection to minimize availability impact and rework.

- **Ephemeral OS disks**. Provision OS disks as [ephemeral disks](/azure/virtual-machines/ephemeral-os-disks). Use managed disks only if OS files need to be persisted. Avoid using ephemeral disks for storing application components and state. 

    The capacity of ephemeral OS disks depends on the chosen VM SKU. Ensure your OS image disk size is less than the SKU's available cache or temp disk. The remaining space can be used for temporary storage.

- **Disk performance**. Pre-provisioning disk space based on peak load is common, but it can lead to underutilized resources because most workloads don't sustain peak load.

    Monitor your workload's usage patterns, noting spikes or sustained high-read operations, and factor these into your VM and managed disk SKU selection.

    You can adjust performance on demand by changing [performance tiers](/azure/virtual-machines/disks-change-performance#what-tiers-can-be-changed). or using the [bursting features](/azure/virtual-machines/disk-bursting) offered in some managed disks SKUs.

    While overprovisioning reduces the need for bursting, it can lead to unused capacity that you're paying for. Ideally, combine both features for optimal results.

- **Tune caching for the workload**. Configure cache settings for all disks based on application component usage.

    Components that mainly perform read operations don't require high disk transactional consistency. Those components can benefit from read-only caching. Write-heavy components requiring high disk transactional consistency often have caching disabled.

    Using read-write caching could cause data loss if the VM crashes and isn't recommended for most data disk scenarios.

In this architecture,

- The OS disks of all virtual machines are ephemeral and located on the cache disk.

    The workload application in the frontend (Linux) and backend (Windows Server) are tolerant to individual VM failures and both use small images (around 30GiB), such attributes make them eligible for using Ephemeral OS disks created as part of the VM local storage (cache partition) instead of Persistent OS disk that are saved in remote Azure storage resources. This incurs no storage cost for OS disks and also improves performance by providing lower latencies and reducing the VM deployment time.

- Each virtual machine has its own Premium SSD P1 managed disk, providing a base provisioned throughput suitable for the workload.

## Network layout

This architecture deploys the workload in a single virtual network. Network controls are a significant part of this architecture, and described in the [Security](#security) section.

:::image type="content" source="./media/baseline-network.svg" alt-text="Virtual machine baseline showing the network layout" lightbox="./media/baseline-network.png":::

This layout can be integrated with an enterprise topology. That example is shown in [Virtual machine baseline architecture in an Azure landing zone](./baseline-landing-zone.yml).

##### Virtual network

One of the initial decisions relates to the network address range. Keep in mind the anticipated network growth during the capacity planning phase. The network should be large enough to sustain the growth, which may need extra networking constructs. For instance, the virtual network should have the capacity to accommodate the other VMs that result from a scaling operation.

Conversely, _right-size your address space_. An excessively large virtual network may lead to underutilization. It's important to note that once the virtual network is created, the address range can't be modified.

In this architecture, the address space is set to /21, a decision based on the projected growth.

##### Subnetting considerations

Within the virtual network, subnets are carved out based on functionality and security requirements.

- Subnet to host the Application Gateway, which serves as the reverse proxy. Application Gateway requires a dedicated subnet.
- Subnet to host the internal load balancer for distributing traffic to backend VMs.
- Subnets to host the workload VMs, one for frontend and one for backend. These subnets are created according to the tiers of the application.
- Subnet for the Bastion host to facilitate operational access to the workload VMs. By design, the Bastion host needs a dedicated subnet.
- Subnet to host private endpoints created to access other Azure resources over Private Links. While dedicated subnets aren't mandatory for these endpoints, they're highly recommended.

Similar to VNets, subnets must be right-sized. For instance, you might want to apply the maximum limit of VMs supported by Flex orchestration to meet the application's scaling needs. The workload subnets should be capable of accommodating that limit. Another use case to take into consideration is VM OS upgrades, which might require temporary IP addresses. Right-sizing gives your the desired level of segmentation by making sure similar resources are grouped so that meaningful security rules through NSGs can be applied to the subnet boundaries. Other segmentation strategies are described in [Security: Segmentation](#segmentation).

##### Ingress traffic

Two public IP addresses are used for ingress flows. One for Azure Application Gateway that serves as the reverse proxy. Users connect using that public IP address. The reverse proxy load balances ingress traffic to the private IPs of the VMs. The other address is for operational access through Azure Bastion.

The Azure internal Load Balancer is placed between the frontend and the backend to distribute traffic to the backend VMs.

:::image type="content" source="./media/baseline-network-ingress.svg" alt-text="Virtual machine baseline showing ingress flow" lightbox="./media/baseline-network-ingress.png":::

##### Egress traffic

Azure Virtual Machine Scale Sets with Flexible orchestration don't have outbound internet connectivity by default, it must be explicitly defined in your architecture. To enable that use case, here are some approaches:

This architecture uses Standard SKU Azure Load Balancer with outbound rules defined from the VM instances. Azure Load Balancer was chosen because it's zone redundant.

:::image type="content" source="./media/baseline-network-egress.svg" alt-text="Virtual machine baseline showing ingress flow" lightbox="./media/baseline-network-egress.png":::

This configuration allows you to use the public IP(s) of your load balancer to provide outbound internet connectivity for the VMs. The outbound rules allow you to explicitly define SNAT(source network address translation) ports. The rules allow you to scale and tune this ability through manual port allocation. Manually allocating SNAT port based on the backend pool size and number of frontendIPConfigurations can help avoid SNAT exhaustion.

It's recommended that you allocate ports based on the maximum number of backend instances. If more instances are added than remaining SNAT ports allowed, VMSS scaling operations might be blocked, or the new VMs won't receive sufficient SNAT ports.

Calculate ports per instance as: `Number of frontend IPs * 64K / Maximum number of backend instances`

There are other options such as deploying a NAT Gateway resource attached to the subnet. Another way is to use Azure Firewall or another NVA with a custom UDR as the next hop through the firewall. That option is shown in [Virtual machine baseline architecture in an Azure landing zone](./baseline-landing-zone.yml).

##### DNS resolution

Azure DNS is used as the foundational service for all resolution use cases. For example, resolving fully qualified domain names (FQDN) associated with the workload VMs. In this architecture, the VMs use the DNS values set in the virtual network configuration, which is Azure DNS.

Azure Private DNS zones are used for resolving requests to the private endpoints used to access the named Private link resources.

## Monitoring

This architecture has a monitoring stack that's decoupled from the utility of the workload. The focus is primarily on the data sources and collection aspects.

> For a comprehensive view on observability, refer to Azure Well-Architected Framework's perspective. See [OE:07 Recommendations for designing and creating a monitoring system](/azure/well-architected/operational-excellence/observability).

Metrics and logs are generated at various data sources, providing observability insights at various altitudes:

- **Underlying infrastructure and components** such as virtual machines, virtual networks, and storage services. Azure platform logs provide information about operations and activities within the Azure platform.

- **Application level** provides insights into the performance and behavior of the applications running on your system.

Azure Log Analytics workspace is the recommended monitoring data sink used to collect logs and metrics from the Azure resources and Application Insights.

This image shows the monitoring stack for the baseline with components for collecting data from infrastructure and application, data sinks, and various consumption tools for analysis and visualization. The implementation deploys some components, such as Application Insights, VM Boot Diagnostics, Azure Log Analytics. Other components are depicted to showcase the extensibility options, such as Dashboards, Alerts.

:::image type="content" source="./media/baseline-monitoring.svg" alt-text="Baseline monitoring data flow diagram" lightbox="./media/baseline-monitoring.png":::


### Infrastructure-level monitoring
This table links to logs and metrics collected by Azure Monitor and the available alerts help you proactively address issues before they impact users.

| Azure resource | Metrics and logs | Alerts |
| -------------- | ---------------- | ------ |
|Application Gateway | [Application Gateway metrics and logs description](/azure/application-gateway/monitor-application-gateway-reference) | [Application Gateway alerts](/azure/application-gateway/high-traffic-support#alerts-for-application-gateway-v2-sku-standard_v2waf_v2) |
| Application Insights | [Application Insights metrics and logging API](/azure/azure-monitor/app/api-custom-events-metrics) | [Application Insights alerts](/azure/azure-monitor/alerts/alerts-smart-detections-migration) |
|Bastion|[Bastion metrics](/azure/bastion/howto-metrics-monitor-alert)|
| Key Vault | [Key Vault metrics and logs descriptions](/azure/key-vault/general/monitor-key-vault-reference) | [Key vault alerts](/azure/key-vault/general/monitor-key-vault#alerts) |
|Standard Load Balancer|[Load balancer logs and metrics](/azure/load-balancer/load-balancer-standard-diagnostics)|[Load Balancer alerts](/azure/load-balancer/load-balancer-standard-diagnostics#configure-alerts-for-multi-dimensional-metrics)
| Public IP address | [Public IP address metrics and logs description](/azure/virtual-network/ip-services/monitor-public-ip) | [Public IP address metrics alerts](/azure/virtual-network/ip-services/monitor-public-ip#alerts) |
| Virtual networks | [Virtual network metrics and logs reference](/azure/virtual-network/monitor-virtual-network-reference) | [Virtual network alerts](/azure/virtual-network/monitor-virtual-network#alerts) |
| VM and scale sets | [VM metrics and logs reference](/azure/virtual-machines/monitor-vm-reference) | [VM alerts and tutorials](/azure/virtual-machines/monitor-vm#alerts) |
| Web Application Firewall | [Web Application Firewall metrics and logs description](/azure/web-application-firewall/ag/application-gateway-waf-metrics) | [Web Application Firewall alerts](/azure/web-application-firewall/ag/application-gateway-waf-metrics#configure-alerts-in-azure-portal) |

For more information on the cost of collecting metrics and logs, see [Log Analytics cost calculations and options](/azure/azure-monitor/logs/cost-logs) and [Pricing for Log Analytics workspace](https://azure.microsoft.com/pricing/details/monitor/). Metric and log collection costs are greatly impacted by the nature of the workload, and the frequency and number of metrics and logs collected.

##### Virtual machines

[Azure boot diagnostics](/azure/virtual-machines/boot-diagnostics) is enabled to observe the state of the VMs during boot by collecting serial log information and screenshots. In this architecture, that data can be accessed through Azure portal and the [the Azure CLI vm boot-diagnostics get-boot-log command](/cli/azure/vm/boot-diagnostics?view=azure-cli-latest#az-vm-boot-diagnostics-get-boot-log). The data is managed by Azure and you have no control or access to the underlying storage resource. However, if your business requirements demand for more control, you can provision your own storage account to store boot diagnostics.

The VMs have [Azure Monitor Agent (AMA)](/azure/azure-monitor/agents/agents-overview) deployed, which collect monitoring data from the guest OS, with OS-specific [Data Collection Rules (DCR)](/azure/azure-monitor/agents/data-collection-rule-azure-monitor-agent) applied to each VM. The DCRs collect performance counters, OS logs, change tracking, dependency tracking, and web server HTTP logs. DCR allows filtering rules and data transformations to reduce the overall data volume being uploaded, thus lowering ingestion and storage costs significantly. As the scale set grows, newly allocated VMs are configured with the AMA settings enforced by a built-in Azure Policy assignment.

[VM insights](/azure/azure-monitor/vm/vminsights-overview) offers an efficient way to monitor VMs and scale sets. It gathers data from Log Analytics workspaces and provides predefined workbooks for performance data trending. This data can be viewed per VM or aggregated across multiple VMs via Azure Monitor.

Application Gateway and the internal Load Balancer use health probes to detect endpoint status of the VMs before sending traffic.

##### Networking

In this architecture, log data is collected from several networking components that participate in the flow. These include Application Gateway, load balancers, Bastion. Also, networking security components such as virtual networks, Network Security Groups (NSGs), public IP addresses, and Private Links.

##### Managed disks

Disk metrics depend on your workload, requiring a mix of key metrics. Monitoring should combine these perspectives to isolate OS or application throughput issues.

- The Azure platform perspective represents the metrics that indicate the Azure service, regardless of the workload that's connected to it. Disk performance metrics (IOPS and throughput) can be viewed individually or collectively for all VM-attached disks. Use Storage IO utilization metrics for troubleshooting or alerting on potential disk capping. If using bursting for cost optimization, monitor Credits Percentage metrics to identify opportunities for further optimization.

- The guest OS perspective represents metrics that the workload operator would view, regardless of the underlying disk technology. VM Insights is recommended for key metrics on attached disks, such as logical disk space used, and the OS kernel's perspective on disk IOPS and throughput. 

### Application-level monitoring

Even though the reference implementation doesn't deploy an application, [Application Insights](/azure/azure-monitor/app/app-insights-overview) is provisioned as an Application Performance Metrics (APM) for extensibility purposes. It's used to collect data from application and send that data to Log Analytics workspace. It also can visualize that data from the workload applications.

The [Application Health extension](/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-health-extension) is deployed to VMs to monitor the binary health state of each VM instance in the scale set, and perform instance repairs if necessary by using scale set Automatic Instance Repair. It tests for the same file as the Application Gateway and Azure Internal Load Balancer health probe to check if the application is responsive.

## Update management

VMs need to be updated and patched regularly so that they don't weaken the security posture of the workload. Automatic and periodic VM assessments are recommended for early discovery and application of patches.

##### Microsoft-managed infrastructure updates

Azure VMs provide the option of automatic VM guest patching. When this service is enabled, VMs are evaluated periodically and available patches are classified. It's recommended that Assessment Mode is enabled to allow daily evaluation for pending patches. On-demand assessment can be done, however, that doesn't trigger application of patches. If Assessment Mode isn't enabled, have manual ways of detecting pending updates.

For governance, consider the [Require automatic OS image patching on Virtual Machine Scale Sets](https://portal.azure.com/#blade/Microsoft_Azure_Policy/PolicyDetailBlade/definitionId/%2Fproviders%2FMicrosoft.Authorization%2FpolicyDefinitions%2F465f0161-0087-490a-9ad9-ad6217f4f43a) Azure Policy.

Only the patches that are classified as _Critical_ or _Security_, are applied automatically across all Azure regions. Define custom update management processes that apply other patches.

Automatic patching can put a burden on the system and can be disruptive because VMs use resources and may reboot during updates. Over-provisioning is recommended for load management. Deploy VMs in different Availability Zones to avoid concurrent updates and maintain at least two instances per zone for high availability. VMs in the same region might receive different patches, which should be reconciled over time.

Be aware of the tradeoff on cost associated with overprovisioning.

Health checks are included as part of automatic VM guest patching. These checks verify successful patch application and detect issues.

If there are custom processes for applying patches, use private repositories for patch sources. This gives you better control in testing the patches to make sure the update doesn't negatively impact performance or security.

For more information, see [Automatic VM guest patching for Azure VMs](/azure/virtual-machines/automatic-vm-guest-patching).

##### Operating system (OS) updates

When doing OS upgrades, have a golden image that's tested. Consider using Azure Compute Gallery for publishing those images. This allows for better control and efficiency in managing updates. Have a process in place that automatically installs the image when needed.

Retire VM images before they reach their End-of-life (EOL) to reduce surface area.

It's recommended that you use [Update Management in Azure Automation](/azure/automation/update-management/overview) to manage OS updates for your Windows and Linux virtual machines in Azure. Updates are installed by runbooks in Azure Automation.

Your automation process should account for overprovision with extra capacity. 

## Reliability

This architecture uses availability zones as a foundational element to address reliability concerns.

In this setup, individual VMs are tied to a single zone. In the event of a failure, these VMs can be readily replaced with other VM instances by the Virtual Machine Scale Sets.

All other components in this architecture are either:

- Zone redundant, meaning they're replicated across multiple zones for high availability, such as Application Gateway, public IPs.
- Zone resilient implying they can withstand zone failures, such as Key Vault.
- Regional or global resources that are available across regions or globally, such as Microsoft Entra ID.

Workload design should incorporate reliability assurances in application code, infrastructure, and operations. The following sections illustrate some strategies to make sure the workload is resilient to failures and is able to recover if there are outages at the infrastructure level.

The strategies used in architecture are based on the [Reliability design review checklist given in Azure Well-Architected Framework](/azure/well-architected/reliability/checklist). The sections are annotated with recommendations from that checklist.

Because there's no application deployed, resiliency in application code is beyond the scope of this architecture. We recommend that you review all recommendations given in the checklist and adopt them in your workload, if applicable.

##### Prioritize the reliability assurances per user flow

In most designs, there are multiple user flows, each with its own set of business requirements. Not all these flows require the highest level of assurances. Segmentation is recommended as a reliability strategy. Each segment can be managed independently, ensuring one segment doesn't impact others and the right level of resiliency in each tier. This approach also makes the system flexible. 

In this architecture, segmentation is implemented by application tiers. Separate scale sets are provisioned for the frontend and backend tiers. This separation enables independent scaling of each tier, allowing for implementation of design patterns based on their specific requirements, among other benefits.

> Refer to Well-Architected Framework: [RE:02 - Recommendations for identifying and rating flows](/azure/well-architected/reliability/identify-flows).

##### Identify the potential failure points

Every architecture is susceptible to failures. The exercise of failure mode analysis allows you to anticipate failures and be prepared with mitigations. Here are some potential failure points in this architecture:

| Component | Risk | Likelihood | Effect/Mitigation/Note | Outage |
|-----------|------|------------|------------------------|--------|
| Microsoft Entra ID | Misconfiguration | Medium | Ops users unable to sign in. No downstream effect. Help desk reports configuration issue to identity team. | None |
| Azure App Gateway | Misconfiguration | Medium | Misconfigurations should be caught during deployment. If these errors happen during a configuration update, DevOps team must roll back changes. Most deployments that use the v2 SKU take around 6 minutes to provision. However it can take longer depending on the type of deployment. For example, deployments across multiple Availability Zones with many instances can take more than 6 minutes. | Full |
| Azure Application Gateway | DDoS attack | Medium | Potential for disruption. Microsoft manages DDoS (L3 and L4) protection. Potential risk of effect from L7 attacks. | Full |
| Azure Virtual Machine Scale Sets | Service outage | Low | Potential workload outage if there are unhealthy VM instances that triggers autorepair. Dependent on Microsoft to remediate. | Potential outage |
| Azure Virtual Machine Scale Sets | Availability zone outage | Low | No effect. Scale sets have been deployed as zone redundant. | None |

> Refer to Well-Architected Framework: [RE:03 - Recommendations for performing failure mode analysis](/azure/well-architected/reliability/failure-mode-analysis).

##### Reliability targets

To make design decisions, it's important to calculate the reliability targets, such as the composite Service Level Objectives (SLOs) of the workload. This involves understanding the Service Level Agreements (SLAs) provided by Azure services used in the architecture. Workload SLOs must not be higher than the SLAs guaranteed by Azure. Carefully examine each component, from VMs and their dependencies, networking, and storage options.

Here's an example calculation where the main goal was to provide with an approximate composite SLO.

While this is rough guideline, it is important to remark that you should arrive to something similar and cannot expect getting a higher maximum composite SLO for the same flows shared below, unless you make modifications to this architecture.

**Operation flow**

|Component  |SLO  |
|------------|-----------|
|Microsoft Entra ID | 99.99% |
|Azure Bastion | 99.95% |

**Composite SLO: 99.94% | Downtime per year: 0d 5h 15m 20s**

**App User Flow**

|Component  |SLO  |
|------------|-----------|
|Azure Application Gateway |99.95% |
|Azure Load Balancer (internal) |99.99% |
|Frontend VMs using premium storage (composite SLO)|99.70% |
|Backend VMs using premium storage (composite SLO)|99.70% |

**Composite SLO: 99.34% | Downtime per year: 2d 9h 42m 18s**

In the preceding example, reliability of VMs and the dependencies are included. For instance, disks associated with VMs. The SLAs associated with disk storage impact the overall reliability.

There are some challenges when calculating the composite SLO. It's important to note that different tiers of service may come with different SLAs, and these often include financially backed guarantees that set reliability targets. Finally, there might be components of the architecture that don't have SLAs defined. For example, in terms of networking, Network Interface Cards (NICs) and virtual networks don't have their own SLAs.

The business requirements and their targets must be clearly defined and factored into the calculation. Be aware of the service limits and other constraints imposed by the organization. If your subscription is shared with other workloads, this could impact the resources available for your VMs. The workload might be allowed to use a limited number of cores available for the VMs. Understanding the resource usage of your subscription can help you design your VMs more effectively.

> Refer to Well-Architected Framework: [RE:04 - Recommendations for defining reliability targets](/azure/well-architected/reliability/metrics).

##### Redundancy

This architecture uses zone-redundancy for several components. Each zone is made up of one or more datacenters with independent power, cooling, and networking. Having instances run in separate zones protects the application against data center failures.

- Azure Virtual Machine Scale Sets allocate specified number of instances and distribute them evenly across Availability Zones and Fault Domains. This is achieved through the _maximum spread_ capability, which is recommended. Spreading VM instances across Fault Domains makes sure all VMs aren't updated at the same time.

    Consider a scenario where there are three Availability Zones. If you have three instances, each instance is allocated to a different Availability Zone and placed in a different Fault Domain. Azure guarantees that only one Fault Domain is updated at a time in each Availability Zone. However, there could be a situation all three Fault Domains hosting your VMs across the three Availability Zones are updated simultaneously. All zones and domains are impacted. Having at least two instances in each zone provides a buffer during upgrades.

- Managed disks can only be attached to a VM in the same region. Their availability typically impacts the availability of the VM. For single-region deployments, disks can be configured for redundancy to withstand zonal failures. In this architecture, data disks are configured ZRS on the backend VMs. It requires a recovery strategy to take advantage of Availability Zones. Recovery strategy is to redeploy the solution. Ideally pre-provision compute in alternate Availability Zones ready to recover from a zonal failure. 

- A zone-redundant Application Gateway or Standard Load Balancer can route traffic to VMs across zones using a single IP address, ensuring continuity even in the event of zone failures. These services use health probes to check VM availability. As long as one zone in the region remains operational, routing continues despite potential failures in other zones. However, inter-zone routing may have higher latency compared to intra-zone routing.

    All public IPs used in this architecture are zone-redundant.

- Azure offers zone-resilient services for better reliability, such as Key Vault.

- Azure global resources are always available and can switch to another region if necessary, such as the foundational Identity Provider, Microsoft Entra ID.

> Refer to Well-Architected Framework: [RE:05 - Recommendations for designing for redundancy](/azure/well-architected/reliability/redundancy).

##### Scaling strategy

Your scaling operations should be reliable so that when a degraded condition is detected, extra resources are provisioned immediately. One strategy is overprovisioning. This is achieved by having sufficient horizontal capacity. This strategy involves understanding the maximum amount of work that the workload will handle. However, it's not just about having extra capacity. It's also about ensuring that your resources aren't underprovisioned. The VM should be right-sized for the work it's expected to handle.

Another strategy is to use autoscaling capabilities for the scale sets. Be sure to do adequate performance testing to set the threshold for CPU, memory, and others. When those thresholds are reached, new instances are immediately provisioned.

> Refer to Well-Architected Framework: [RE:06 - Recommendations for designing a reliable scaling strategy](/azure/well-architected/reliability/redundancy).

#### Self-healing and recoverability

[Automatic instance repairs](/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-automatic-instance-repairs) is enabled in the Virtual Machine Scale Sets to automate recovery from VM failures. The [Application Health extension](/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-health-extension) is deployed to VMs to support detecting unresponsive VMs and applications. For those instances, repair actions are automatically triggered.

> Refer to Well-Architected Framework: [Recommendations for self-healing and self-preservation](/azure/well-architected/reliability/self-preservation).

## Security

This architecture illustrates some of the security assurances given in the [Security design review checklist given in Azure Well-Architected Framework](/azure/well-architected/security/checklist). The sections are annotated with recommendations from that checklist.

Security isn't just technical controls. It's highly recommended that you follow the entire checklist to understand the operational aspects of the Security pillar.

##### Segmentation

- **Network segmentation**. Workload resources are placed in a virtual network, which provides isolation from the internet. Within the virtual network, subnets can be used as trust boundaries. _Colocate related resources needed for handling a transaction in one subnet_. In this architecture, the virtual network is divided into subnets based on the logical grouping of the application and purpose of various Azure services used as part of the workload.

    The advantage of subnet segmentation is that you can place security controls at the perimeter that controls traffic flowing in and out of the subnet, thereby restricting access to the workload resources.

- **Identity segmentation**. Assign distinct roles to different identities with just-enough permissions to do their task. This architecture uses [Microsoft Entra ID](/entra/fundamentals/whatis) managed identities to segment access to resources.

- **Resource segmentation**. The application is segmented by tiers into separate scale sets, which ensures that application components aren't colocated.  

> Refer to Well-Architected Framework: [SE:04 - Recommendations for building a segmentation strategy](/azure/well-architected/security/segmentation).

##### Identity and access management

[Microsoft Entra ID](/entra/fundamentals/whatis) is recommended for authentication and authorization of both users and services. 

Access to VMs requires a user account, controlled by Microsoft Entra ID authentication and backed by security groups. This architecture supports this by deploying Microsoft Entra ID authentication extension to all VMs. It's recommended that human users use their corporate identities in their organization's Microsoft Entra ID tenant, and any service principal-based access isn't  shared across functions.

Workload resources such as VMs authenticate themselves by using their assigned managed identities to other resources. These identities, based on Microsoft Entra ID service principals, are automatically managed. For example, Key Vault extension are installed on VMs, which allows VMs to boot with up certificates in place. In this architecture, [user-assigned managed identities](/entra/identity/managed-identities-azure-resources/overview#managed-identity-types) are used by Azure Application Gateway, frontend VMs, and backend VMs to access Azure Key Vault. Those managed identities are configured during deployment and used for authenticating against Key Vault. Access policies on Key Vault are configured to only accept requests from the preceding managed identities.

The baseline architecture uses a mix of system-assigned and user-assigned managed identities. These identities are needed to use Microsoft Entra ID for authorization purposes when accessing other Azure resources.

> Refer to Well-Architected Framework: [SE:05 - Recommendations for identity and access management](/azure/well-architected/security/identity-access).

##### Network controls

- **Ingress traffic**. The workload VMs aren't directly exposed to the public internet. Each VM has a private IP address. Workload users connect using the public IP address of Azure Application Gateway.

    More security is provided through [Web Application Firewall](/azure/application-gateway/waf-overview) that's integrated with Application Gateway. It has rules that _inspect inbound traffic_ and can take an appropriate action. WAF tracks Open Web Application Security Project (OWASP) vulnerabilities preventing known attacks.

- **Egress traffic**. There are no controls on outbound traffic besides the outbound NSG rules on the virtual machine subnets. It's highly recommended that all outbound internet traffic flows through a single firewall. This firewall is usually a central service provided by organization. That use case is shown in [Virtual machine baseline architecture in an Azure landing zone](./baseline-landing-zone.yml).

- **East-west traffic**. Traffic flow between the subnets is restricted by applying granular security rules.

    [Network security groups (NSGs)](/azure/virtual-network/network-security-groups-overview) are placed to restrict traffic between subnets based on parameters such as IP address range, ports, and protocols. [Application security groups (ASG)](/azure/virtual-network/application-security-groups) are placed on frontend and backend VMs. They're used with NSGs to filter traffic to and from the VMs.

- **Operational traffic**. It's recommended that secure operational access to workload is provided through Azure Bastion, which removes the need for public IP. In this architecture, that communication is over SSH that's supported by both Windows and Linux VMs. Microsoft Entra ID is integrated with SSH for both types of VMs by using the corresponding VM extension. That integration allows operator's identity to be authenticated and authorized through Microsoft Entra ID.

    Alternatively, use a separate VM as a jump box, deployed to its own subnet, where you can install your choice of admin and troubleshooting tools. The operator accesses the jump box through the Bastion host. Then, sign in to the VMs behind the load balancer from the jump box.

    In this architecture, operational traffic is protected using NSG rules to restrict traffic and [just-in-time (JIT) VM access](/azure/defender-for-cloud/just-in-time-access-overview) is enabled on the VMs. This feature of Microsoft Defender for Cloud, allows temporary inbound access to selected ports. 
   
    For enhanced security, use [Microsoft Entra Privileged Identity Management (PIM)](/entra/id-governance/privileged-identity-management/pim-configure). PIM is a service in Microsoft Entra ID that enables you to manage, control, and monitor access to important resources in your organization. PIM provides time-based and approval-based role activation to mitigate the risks of excessive, unnecessary, or misused access permissions on resources that you care about.

- **Private connectivity to PaaS services**. Communication between the VMs and Azure Key Vault is over Private Links. This service requires private endpoints, which are placed in a separate subnet.

- **DDoS protection**. Consider enabling [Azure DDoS Protection](/azure/virtual-network/ddos-protection-overview) on the public IPs exposed by Application Gateway and the Bastion Host to detect threats. DDoS Protection also provides alerting, telemetry, and analytics through Azure Monitor. For more information, see [Azure DDoS Protection: Best practices and reference architectures](/azure/security/fundamentals/ddos-best-practices).

> Refer to Well-Architected Framework: [SE:06 - Recommendations for networking and connectivity](/azure/well-architected/security/networking).

##### Encryption

- **Data in transit**. User traffic between users and the Azure Application Gateway public IP is encrypted using the external certificate. Traffic between the application gateway and the frontend VMs, and between the frontend and backend VMs is encrypted using an internal certificate. Both certificates are stored in [Azure Key Vault](/azure/key-vault/general/overview):
    - **app.contoso.com**: An external certificate used by clients and Application Gateway for secure public Internet traffic.
    - ***.workload.contoso.com**: A wildcard certificate used by the infrastructure components for secure internal traffic.

- **Data at rest**. Log data is stored in managed disk attached to VMs. That data is automatically encrypted by using platform-provided encryption on Azure.

> Refer to Well-Architected Framework: [SE:07 - Recommendations for data encryption](/azure/well-architected/security/encryption).

##### Secret management

:::image type="content" source="./media/baseline-certificates.svg" alt-text="Diagram that shows TLS termination and certificates used." lightbox="./media/baseline-certificates.png":::

[Azure Key Vault](/azure/key-vault/general/overview) provides secure management of secrets, including TLS certificates. In this architecture, the TLS certificates are stored in the Key Vault and retrieved during the provisioning process by the managed identities of Application Gateway and the VMs. After the initial setup, these resources will only access the Key Vault when the certificates are refreshed.

The VMs use the [Azure Key Vault VM extension](/azure/virtual-machines/extensions/key-vault-linux) to automatically refresh the monitored certificates. If any changes are detected in the local certificate store, the extension retrieves and installs the corresponding certificates from the Key Vault. The extension supports certificate content types PKCS #12 and PEM.

> [!IMPORTANT]
> It is your responsibility to ensure your locally stored certificates are rotated regularly. See [Azure Key Vault VM extension for Linux](/azure/virtual-machines/extensions/key-vault-linux) or [Azure Key Vault VM extension for Windows](/azure/virtual-machines/extensions/key-vault-windows) for more details.


> Refer to Well-Architected Framework: [SE:09 - Recommendations for protecting application secrets](/azure/well-architected/security/application-secrets).

## Cost Optimization

Workload requirements must be fulfilled keeping in mind the cost constraints. This section describes some options for optimizing costs. The strategies used in architecture are based on the [Cost Optimization design review checklist given in Azure Well-Architected Framework](/azure/well-architected/cost-optimization/checklist). The sections are annotated with recommendations from that checklist.

##### Component cost

Select VM images that are optimized for the workload instead of using general-purpose images. In this architecture, relatively small VM images are chosen for both Windows and Linux, which are 30GB each. With smaller images, VM SKUs with disks are also smaller, leading to lower costs and also faster deployment, boot times, reduced resource consumption. A side benefit is security because of the reduced surface area.

Implementing log rotation with size limits is another cost saving strategy. It allows for using small data disks, which can result in lower costs. The implementation of this architecture uses 4 GB disks.

The use of ephemeral OS disks can also lead to cost savings and improved performance. These disks are designed to use VM resources that you're already paying for, because they're installed on the cache disk provisioned with the VM. It eliminates storage costs associated with traditional persistent disks. Because these disks are temporary, there are no costs associated with long-term data storage.

> Refer to Well-Architected Framework: [CO:07 - Recommendations for optimizing component costs](/azure/well-architected/cost-optimization/optimize-component-costs).

##### Flow cost

Choose compute resources based on the criticality of the flow. For flows that are specifically designed to tolerate indeterminate-length, consider using [Spot VMs](/azure/architecture/guide/spot/spot-eviction) with Virtual Machine Scale Sets Flexible Orchestration mode. This approach can be effective for hosting low-priority flows on lower-priority VMs. This strategy allows for cost optimization while still meeting the requirements of different flows.

> Refer to Well-Architected Framework: [CO:09 - Recommendations for optimizing flow costs](/azure/well-architected/cost-optimization/optimize-flow-costs).

##### Scaling cost

If the main cost driver is the number of instances, it may be more cost-effective to scale up by increasing the size or performance of the VMs. This approach can lead to cost savings in several areas:

- **Software licensing**. Larger VMs can handle more workload, potentially reducing the number of software licenses required.
- **Maintenance time**: Managing fewer, larger VMs can reduce operational costs.
- **Load balancing**: Fewer VMs can result in lower costs for load balancing. For example, in this architecture there are multiple layers of load balancing, such as an Application Gateway at the front and an internal load balancer in the middle. Load balancing costs would increase if higher number of instances need to be managed.
- **Disk storage**. If there are stateful applications, more instances need more attached managed disks, increasing cost of storage.

> Refer to Well-Architected Framework: [CO:12 - Recommendations for optimizing scaling costs](/azure/well-architected/cost-optimization/optimize-scaling-costs).

##### Operational costs

Automatic VM guest patching reduces the overhead of manual patching and the associated maintenance costs. Not only does this make the system more secure but also optimizes resource allocation, contributing to overall cost efficiency.

> Refer to Well-Architected Framework: [CO:13 - Recommendations for optimizing personnel time](/azure/well-architected/cost-optimization/optimize-scaling-costs).

## Deploy this scenario

A deployment for this reference architecture is available on GitHub.

> [!div class="nextstepaction"]
> [Implementation: Azure Virtual Machine baseline architecture](https://github.com/mspnp/iaas-baseline/#deploy-the-reference-implementation)


## Related links

See product documentation for details on specific Azure services:

- [Azure Virtual Machines](/azure/virtual-machines)
- [Azure Virtual Machine Scale Sets](/azure/virtual-machine-scale-sets/)
- [Azure Virtual Network](/azure/virtual-network/)
- [Azure Application Gateway Standard_v2](/azure/application-gateway/overview-v2)
- [Azure Load Balancer](/azure/load-balancer/)
- [Azure Key Vault](/azure/key-vault/general/)
- [Azure Bastion](/azure/bastion/)
- [Azure Application Insights](/azure/azure-monitor/app/app-insights-overview)
- [Azure Log Analytics](/azure/azure-monitor/logs/log-analytics-overview)

## Next step

Review the IaaS reference architectures showing options for the data tier:

- [Windows N-tier application using SQL Server on Azure](/azure/architecture/reference-architectures/n-tier/n-tier-sql-server)
