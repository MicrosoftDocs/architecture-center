
This article provides a foundational reference architecture for a workload deployed on Azure virtual machines (VMs). 

The example workload assumed by this architecture is a tired-web application that's deployed on separate set of VMs. 

However, the primary focus of that architecture isn't the application. Instead it provides guidance for configuring and deploying the infrastructure components with which the application interacts. These components include compute, storage, networking, monitoring and more. This architecture serves as a starting point for an Infrastructure-as-a-Service (IaaS) workload. The data tier is intentionally excluded from this guidance, to maintain the focus on the infrastructure. 

## Article layout

|Architecture| Technology design decisions|Workload concerns|
|---|---|---|
|&#9642; [Architecture diagram](#architecture) <br>&#9642; [Workload resources](#workload-resources) <br> &#9642; [Supporting resources](#workload-supporting-resources) <br> &#9642; [User flows](#user-flows) <br> |&#9642; [VM design choices](#virtual-machine-design-choices)<br> &#9642; [Disks](#disks) <br> &#9642; [Networking](#networking) <br> &#9642; [Monitoring](#monitoring) | &#9642; [Operations](#os-patching) <br> &#9642; [Reliability](#reliability) <br> &#9642; [Security](#security) <br> &#9642; [Cost Optimization](#cost-optimization)|

> [!TIP]
> ![GitHub logo](../_images/github.svg) The best practices described in this architecture are demonstrated by a [**reference implementation**](https://github.com/mspnp/iaas-baseline). 
> The implementation includes an application that's a small test harness that will exercise the infrastructure set up end-to-end. 


## Architecture

:::image type="content" source="./media/vm-baseline-architecture.svg" alt-text="Virtual machine baseline architectural diagram" lightbox="./media/vm-baseline-architecture.png":::

#### Workload resources

- **Azure virtual machine** (VM) serves as the compute resource for the application and is distributed across availability zones. For illustrative purposes, a combination of both Windows and Linux images is used. 

    **Azure Virtual Machine Scale Sets** in Flexible orchestration mode is used to provision and manages the virtual machines individually.

    The sample application can be represented in two tiers, each requiring its own compute.  

    1. Frontend runs the web server and receives user requests.
    1. Backend runs business logic to process those requests. 

    Both compute are stateless to reduce complexity during scaling operations. Temporary state can be stored on [disks](#managed-disks). This layout may be extended to include a database tier for storing state from the frontend and backend compute. That tier is outside the scope of this architecture.

- **Azure Virtual Network** provides a private network for all workload resources. The network is segmented into subnets, which serve as isolation boundaries.

- **Azure Application Gateway Standard_v2** is the single point of ingress routing requests to the frontend servers. This SKU has integrated Azure Web Application Firewall (WAF) for added security. 

- **Azure Load Balancer** routes traffic from the frontend tier to the backend servers. The load balancer distributes traffic to VMs across zones.  

- **Azure Key Vault** stores application secrets and certificates used for end-to-end TLS communication. 

#### Workload supporting resources

- **Azure Bastion** provides secured operational access to the VMs over Remote Desktop Protocol (RDP) and Secure Shell (SSH).   

- **Azure Application Insights** collects logs and metrics from the application. 

- **Azure Log Analytics** is the monitoring data sink that collects logs and metrics from the Azure resources and Application Insights. A storage account is provisioned as part of the workspace. 

### User flows

There are two types of users that interact with the workload resources.

##### Workload user

1. The user accesses the web site by using the exposed public IP address of Azure Application Gateway. 

1. Application Gateway receives HTTPS traffic, decrypts data using an external certificate for WAF inspection, and re-encrypts it using the internal wildcard certificate for transport to the web tier.
 
1. Application Gateway balances traffic across the three zones in the frontend and connects to a VM in the pool of web tier VMs, on behalf of the user session.

1. The frontend web app decrypts the received request using the internal certificate for inspection, then re-encrypts the data for transport to the backend tier. 

1. The frontend tier connects to Azure Load Balancer, which forwards the request to a VM in the backend tier pool.

1. The backend VM decrypts the request using the internal certificate. Then, the backend tier returns the result to the frontend, which returns the result to the Application Gateway, and it finally returns the result to the user.

##### Operations user

1. The operations user logs into the Azure portal.
1. The user accesses the Azure Bastion service and remotely connects to the desired VM for troubleshooting using the appropriate tool.

## Virtual machine design choices

When selecting SKUs, it's important to have a baseline performance expectation. The decision-making process will be influenced by several characteristics, including:

- CPU, memory, and disk input/output operations per second (IOPS)
- Storage volumes
- Processors architecture
- Operating system (OS)

For instance, if you're migrating a workload from an on-premises environment to the cloud, the OS should be a key consideration. In an on-premises setup, the OS operates on a disk with a fixed capacity. However, in Azure, the OS footprint will impact your choice of VM and disk SKUs.

For information about the supported VM SKUs, see [Sizes for virtual machines in Azure](/azure/virtual-machines/sizes).

##### VM connectivity

To enable a VM to communicate with the virtual network, you need Network interfaces (NICs). If you require multiple NICs for your VM, be aware that a maximum number of NICs is defined for each VM size.

If the workload needs low latency, take advantage of **accelerated networking** supported by Azure VM NICs. For more information, see [Benefits of accelerated networking](/azure/virtual-network/accelerated-networking-overview?tabs=redhat#benefits).

##### Virtual Machine Scale Sets with flexible orchestration

VMs are provisioned as part of Virtual Machine Scale Sets (VMSS) with [Flexible orchestration](/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-orchestration-modes#scale-sets-with-flexible-orchestration). VMSSs are logical groupings of VMs that can be identical or of multiple types to meet capacity needs. They allow lifecycle management of machines, network interfaces, and disks using standard Azure VM APIs and commands.

Flexible orchestration mode in VMSS facilitates operations at scale and offers better control and granular scaling decisions.

Fault domains configuration is needed to limit the impact of physical hardware failures, network outages, or power interruptions. With VMSS, Azure evenly spreads instances across fault domains for resilience against a single hardware or infrastructure issue.

It's recommended that you offload fault domain allocation to Azure for maximum instance spreading, enhancing resilience and availability.

##### OS patching
You can use Maintenance Configurations to control and manage updates for both Windows and Linux VMs. Maintenance Configurations provides a centralized view of the patch status of your VMs, and you can schedule patching to occur during a maintenance window that you define based on three supported scopes. For more information, check out the [Maintenance Configuration scopes](/azure/virtual-machines/maintenance-configurations#scopes).

## Disks
To run the OS and application components, **Storage Area Network (SAN) volumes** are required. In Azure, these volumes or disks are attached to the VM. Use **Ephemeral OS disks for the OS** and **managed disks for data storage**.

Azure provides a range of options in terms of performance, tunability, and cost. Start with Premium SSD for most production workloads. The choice is linked to the VM SKU. SKUs that support Premium SSD contain 's' in the resource name, for example 'Dsv4' but not 'Dv4.'

For more information about the disk options with metrics such as capacity, IOPS, throughput and others, see [Disk type comparison](/azure/virtual-machines/disks-types#disk-type-comparison).

Consider disk characteristics and performance expectations when selecting a disk. 

- **VM SKU limitations**: Disks operate within the VM they're attached to, which have IOPS and throughput limits. Ensure the disk doesn't cap the VM's limits and vice versa. Select the disk size, performance, and VM capabilities (core, CPU, memory) that optimally run the application component. Avoid overprovisioning because it impacts cost.

- **Configuration changes**: Some disk performance and capacity configurations can be changed while a VM is running. However, many changes may require re-provisioning and rebuilding disk content, affecting workload availability. Therefore, carefully plan disk and VM SKU selection to minimize availability impact and rework.

- **Ephemeral OS disks**: These should not store application components or state. Provision OS disks as [ephemeral disks](/azure/virtual-machines/ephemeral-os-disks). Use managed disks only if OS files need to be persisted.

    The capacity of ephemeral OS disks depends on the chosen VM SKU. Ensure your OS image disk size is less than the SKU's available cache or temp disk. The remaining space can be used for temporary storage.

- **Disk performance**. Pre-provisioning disk space based on peak load is common, but it can lead to underutilized resources because most workloads don't sustain peak load.

    Monitor your workload's usage patterns, noting spikes or sustained high-read operations, and factor these into your VM and managed disk SKU selection.     
    
    You can adjust performance on demand by changing [performance tiers](/azure/virtual-machines/disks-change-performance#what-tiers-can-be-changed). or using the [bursting features](/azure/virtual-machines/disk-bursting) offered in some managed disks SKUs. 

    While overprovisioning reduces the need for bursting, it can lead to unused capacity that you're paying for. Ideally, combine both features for optimal results.

- **Tune caching for the workload**. Configure cache settings for all disks based on application component usage.

    Components that mainly perform read operations don't require high disk transactional consistency. Those components can benefit from read-only caching. Write-heavy components requiring high disk transactional consistency often have caching disabled.

    Using read-write caching could cause data loss if the VM crashes and is generally not recommended for most data disk scenarios.

In this architecture, both backend and frontend VMs utilize Standard HDD LRS (//?).

- The OS disks of all virtual machines are ephemeral and located on the cache disk, which also has the Windows page file.

- Each virtual machine has its own Premium SSD P3 managed disk, providing a base provisioned throughput suitable for the workload.

## Networking 

This architecture deploys the workload in a single virtual network (VNet). Network controls are a significant part of this architecture, and described in the [Security](#security) section. 

:::image type="content" source="./media/vm-baseline-network.svg" alt-text="IaaS baseline architectural diagram" lightbox="./media/vm-baseline-network.png":::

It can be integrated with an enterprise topology. That example is shown in [Virtual machine baseline architecture in an Azure landing zone](./vm-baseline-landing-zone.yml).

##### Virtual network

One of the initial decisions relates to the network address range. Keep in mind the anticipated network growth during the capacity planning phase. The network should be large enough the growth, which may need extra networking constructs. For instance, the VNet should have the capacity to accommodate the additional VMs that result from a scaling operation.

Conversely, _right-size your address space_. An excessively large virtual network may lead to underutilization. It's important to note that once the VNet is created, the address range cannot be modified.

In this architecture, the address space is set to /21, a decision based on the projected growth.

##### Subnetting considerations

Within the VNet, subnets are carved out based on functionality and security requirements.

- Subnet to host the Application Gateway, which serves as the reverse proxy. By design, the Application Gateway needs a dedicated subnet.
- Subnet to host the internal load balancer for distributing traffic to backend VMs.
- Subnets to host the workload VMs. These are divided according to the tiers of the application.
- Subnet for the Bastion host to facilitate operational access to the workload VMs. By design, the Bastion host needs a dedicated subnet.
- Subnet to host private endpoints created to access other Azure resources over Private Links. While dedicated subnets are not mandatory for these endpoints, they are highly recommended. 

Similar to VNets, subnets must be right-sized. For instance, you might want to leverage the maximum limit of VMs supported by Flex orchestration to meet the application's scaling needs. The workload subnets should be capable of accommodating that limit. Another use case involves VM upgrades, which might require temporary IP addresses.

##### Ingress traffic

Two public IP addresses are used. One for Azure Application Gateway that serves as the reverse proxy. Users connect using that public IP address. The reverse proxy directs ingress traffic to the private IPs of the VMs. The other address is for operational access through Azure Bastion.

The Azure Load Balancer is placed between the frontend and the backend to distribute traffic to the backend VMs.

##### Egress traffic

Virtual Machine Scale Sets (VMSS) with Flexible orchestration requires that VM instances to have outbound connectivity for communication over the internet. To enable that use case, here are some approaches:

VMSS with Flexible orchestration requires VM instances to have outbound internet connectivity. This architecture uses Standard SKU Azure Load Balancer with outbound rules defined from the VM instances. 

Azure Load Balancer supports zone redundancy. This option allows you to use the public IP(s) of your load balancer to provide outbound internet connectivity for the VMs. The outbound rules allow you to explicitly define SNAT(source network address translation) ports. The rules allow you to scale and tune this ability through manual port allocation. Manually allocating SNAT port based on the backend pool size and number of frontendIPConfigurations can help avoid SNAT exhaustion. 

It's recommended that you allocate ports based on the maximum number of backend instances. If more instances are added than remaining SNAT ports allowed, VMSS scaling operations might be blocked, or the new VMs won't receive sufficient SNAT ports.

Calculate ports per instance as: `Number of frontend IPs * 64K / Maximum number of backend instances`

There are other options such as deploying a NAT Gateway resource attached to the subnet. Another way is to use Azure Firewall or another NVA with a custom UDR as the next hop through the firewall. Those options are described in [Alternatives](#alternatives).



##### DNS resolution

Azure DNS is used as the foundational service for all resolution use cases. For example, resolving fully qualified domain names (FQDN) associated with the workload VMs.

Azure Private DNS zones are used for resolving requests to the private endpoints used to access the named Private link resources.

## Monitoring

This architecture has a monitoring stack that's decoupled from the utility of the workload. The focus is primarily on the data sources and collection aspects. 

> For a comprehensive view on observability, refer to Azure Well-Architected Framework's perspective. See [OE:07 Recommendations for designing and creating an observability framework](/azure/well-architected/operational-excellence/observability).

Metrics and logs are generated at various data sources, providing observability insights at various altitudes:

- **Underlying infrastructure and components** such as virtual machines, virtual networks, and storage services. Azure platform logs provide information about operations and activities within the Azure platform.
- **Application level** provides insights into the performance and behavior of the applications running on your system.

Azure Log Analytics workspace is the recommended monitoring data sink used to collect logs and metrics from the Azure resources and Application Insights. 

:::image type="content" source="./media/vm-baseline-monitoring.svg" alt-text="VM monitoring data flow  diagram" lightbox="./media/vm-baseline-monitoring.png":::

### Infrastructure-level monitoring
This table links to logs and metrics collected by Azure Monitor and the available alerts help you proactively address issues before they impact users.

| Azure resource | Metrics and logs | Alerts |
| -------------- | ---------------- | ------ |
|Application Gateway | [Application Gateway metrics and logs descriptions](/azure/application-gateway/monitor-application-gateway-reference) | [Application Gateway alerts](/azure/application-gateway/high-traffic-support#alerts-for-application-gateway-v2-sku-standard_v2waf_v2) |
| Application Insights | [Application Insights metrics and logging API](/azure/azure-monitor/app/api-custom-events-metrics) | [Application Insights alerts](/azure/azure-monitor/alerts/alerts-smart-detections-migration) |
| Blob Storage | [Azure Blob Storage metrics and logs descriptions](/azure/storage/blobs/monitor-blob-storage-reference) | [Blob storage alerts](/azure/storage/blobs/monitor-blob-storage?tabs=azure-portal#alerts) |
| Key Vault | [Key Vault metrics and logs descriptions](/azure/key-vault/general/monitor-key-vault-reference) | [Key vault alerts](/azure/key-vault/general/monitor-key-vault#alerts) |
| Public IP address | [Public IP address metrics and logs descriptions](/azure/virtual-network/ip-services/monitor-public-ip) | [Public IP address metrics alerts](/azure/virtual-network/ip-services/monitor-public-ip#alerts) |
| Virtual networks | [Virtual network metrics and logs reference](/azure/virtual-network/monitor-virtual-network-reference) | [Virtual network alerts](/azure/virtual-network/monitor-virtual-network#alerts) |
| VM/VMSS | [VM metrics and logs reference](/azure/virtual-machines/monitor-vm-reference) | [VM alerts and tutorials](/azure/virtual-machines/monitor-vm#alerts) |
| Web Application Firewall | [Web Application Firewall metrics and logs descriptions](/azure/web-application-firewall/ag/application-gateway-waf-metrics) | [Web Application Firewall alerts](/azure/web-application-firewall/ag/application-gateway-waf-metrics#configure-alerts-in-azure-portal) |

For more information on the cost of collecting metrics and logs, see [Log Analytics cost calculations and options](/azure/azure-monitor/logs/cost-logs) and [Pricing for Log Analytics workspace](https://azure.microsoft.com/pricing/details/monitor/). Metric and log collection costs are greatly impacted by the nature of the workload, and the frequency and number of metrics and logs collected.

##### Virtual machines data

The [VM insights](/azure/azure-monitor/vm/vminsights-overview) agent collects data from VMs and VM scale sets, providing an inventory of all VM resources and enabling base monitoring. 

[Azure boot diagnostics](/azure/virtual-machines/boot-diagnostics) is enabled to observe the state of their VM as it is booting up by collecting serial log information and screenshots. The data is collected in a managed storage account that's accessible through Azure portal for troubleshooting and can be exported. For more information, see [the Azure CLI vm boot-diagnostics get-boot-log command](/cli/azure/vm/boot-diagnostics?view=azure-cli-latest#az-vm-boot-diagnostics-get-boot-log).

A custom storage account can be used for greater control over access permissions and log retention. 

The [Azure Monitor Agent (AMA)](/azure/azure-monitor/agents/agents-overview) deployed to VMs collects monitoring data from the guest OS, with OS-specific [Data Collection Rules (DCR)](/azure/azure-monitor/agents/data-collection-rule-azure-monitor-agent) applied to each VM. The DCRs collect performance counters, OS logs, change tracking, dependency tracking, and web server HTTP logs. As the scale set grows, newly allocated VMs are configured with the AMA settings enforced by a built-in Azure Policy assignment.

The [Azure Monitor Agent (AMA)](/azure/azure-monitor/agents/agents-overview) is deployed to VMs to collect monitoring data from the guest operating system. AMA supports [Data Collection Rules (DCR)](/azure/azure-monitor/agents/data-collection-rule-azure-monitor-agent), which enables targeted and granular data collection for a machine or subset(s) of machines. DCR allows filtering rules and data transformations to reduce the overall data volume being uploaded, thus lowering ingestion and storage costs significantly.


##### Networking

Application Gateway and Azure Load Balancer use health probes to detect endpoint status. If a probe fails, new inbound connections to the unhealthy instance are stopped, while outbound connectivity remains unaffected. Health probes are set up to perform a simple HTTP test checking for a file's existence, returning an HTTP 200 to the load balancer, if successful.

##### Managed disks

Disk metrics depend on your workload, requiring a mix of key metrics. Monitoring should consider both the Azure platform and guest OS perspectives on managed disks. 

The Azure platform perspective represents the metrics that a SAN operator would view, regardless of what workloads are connected. The guest OS perspective represents the metrics that the workload operator would view, regardless of the underlying disk technology. In Azure, workload teams have the responsibility of monitoring both as part of their solution.

From the platform perspective, data disk performance metrics (IOPS and throughput) can be viewed individually or collectively for all VM-attached disks. Use Storage IO utilization metrics for troubleshooting or alerting on potential disk capping. If using bursting for cost optimization, monitor Credits Percentage metrics to identify opportunities for further optimization.

From the guest OS perspective, VM Insights is recommended for key metrics on attached disks, such as logical disk space used, and the OS kernel's perspective on disk IOPS and throughput. Combining these with platform performance metrics can help isolate OS or application throughput issues.

### Application-level monitoring

Even though the reference implementation doesn't deploy an application, [Application Insights](/azure/azure-monitor/app/app-insights-overview) is provisioned for extensibility purposes. It's used to collect data from application and send that data to Log Analytics workspace. 

It also monitors the performance and health. You can view trends of performance data, running processes on individual machines, and dependencies between machines. 

The [Application Health extension](/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-health-extension) is deployed to VMs to monitor the binary health state of each VM instance in the scale set, and perform instance repairs if necessary by using Automatic Instance Repairs. It tests for the same file as the Application Gateway and Azure Load Balancer health probe to check if the application is responsive.

## Reliability 

Workload design should incorporate reliability assurances in application code, infrastructure, and operations. The following sections illustrate some strategies to make sure the workload is resilient to failures and is able to recover if there are outages at the infrastructure level. 

The strategies used in architecture are based on the [Reliability design review checklist given in Azure Well-Architected Framework](/azure/well-architected/reliability/checklist). The sections are annotated with recommendations from that checklist.

Because there's no application deployed, resiliency in application code is beyond the scope of this architecture. We recommend that you review all recommendations given in the checklist and adopt them in your workload, if applicable.

##### Prioritize the reliability assurances per user flow

> Refer to Well-Architected Framework: [RE:02 - Recommendations for identifying and rating flows](/azure/well-architected/reliability/identify-flows).

In most designs, there are multiple user flows, each with its own set of business requirements. Not all these flows require the highest level of assurances. Segmentation is recommended as a reliability strategy. Each segment can be managed independently, ensuring one segment doesn't impact others and the right level of resiliency in each tier. This approach also makes the system flexible.  

In this architecture, segmentation is implemented by application tiers. Separate VM scale sets are provisioned for the frontend and backend tiers. This separation enables independent scaling of each tier, allowing for implementation of design patterns based on their specific requirements, among other benefits. 

##### Identify the potential failure points

> Refer to Well-Architected Framework: [RE:03 - Recommendations for performing failure mode analysis](/azure/well-architected/reliability/failure-mode-analysis).

Every architecture is susceptible to failures. The exercise of failure mode analysis allows you to anticipate failures and be prepared with mitigations. Here are some potential failure points in this architecture:

| Component | Risk | Likelihood | Effect/Mitigation/Note | Outage |
|-----------|------|------------|------------------------|--------|
| Microsoft Entra ID | Misconfiguration | Medium | Ops users unable to sign in. No downstream effect. Help desk reports configuration issue to identity team. | None |
| Azure App Gateway | Misconfiguration | Medium | Misconfigurations should be caught during deployment. If these happen during a configuration update, DevOps team must roll back changes. Most deployments that use the v2 SKU take around 6 minutes to provision. However it can take longer depending on the type of deployment. For example, deployments across multiple Availability Zones with many instances can take more than 6 minutes. | Full |
| Azure App Gateway | DDoS attack | Medium | Potential for disruption. Microsoft manages DDoS (L3 and L4) protection. Potential risk of effect from L7 attacks. | Full |
| Azure Storage | Service outage | Low | Full workload outage. Dependent on Microsoft to remediate. | Full |
| Azure Storage | Regional outage | Very low | Full workload outage as this is being deployed to a single region. Recovery time objectives (RTOs) are lower in the front-end but while higher in backend where managed disk are needed. Recovery point objectives (RPOs) to be determined during reliability testing. | Full |
| Azure Storage | Availability zone outage | Low | No effect. The workload is deployed into 3 different zones overprovisioned to support a full zone outage. | None |
| Azure VMSS | Service outage | Low | Potential workload outage in case of unhealthy Virtual Machine instances requires auto-repair to kick off. Dependent on Microsoft to remediate. | Potential outage |
| Azure VMSS | Availability zone outage | Low | No effect. VMSS has been deployed as zone redundant. | None |

##### Reliability targets

> Refer to Well-Architected Framework: [RE:04 - Recommendations for defining reliability targets](/azure/well-architected/reliability/metrics).

To make design decisions, it's important to calculate the reliability targets, such as the composite Service Level Objectives (SLOs) of the workload. This involves understanding the Service Level Agreements (SLAs) provided by Azure services used in the architecture. Workload SLOs must not be higher than the SLAs guaranteed by Azure. Carefully examine each component, from VMs and their dependencies, networking, and storage options.

Here's an example calculation.

**Operation flow**

|Component  |SLO  |SLO with Zones  |Downtime per week  |Downtime per month  |Downtime per year  |
|------------|-----------|---------|---------|---------|---------|
|Microsoft Entra ID | 99.99% |99.99% |0d 0h 0m 58s |0d 0h 4m 22s |0d 0h 52m 33s  |
|Azure Bastion | 99.95% |99.95% |0d 0h 4m 51s |0d 0h 21m 53s |0d 4h 22m 47s  |
|VMSS Frontend | 99.99% |100% |0d 0h 0m 0s |0d 0h 0m 0s |0d 0h 0m 0s |
|VMSS Backend | 99.99% |100% |0d 0h 0m 0s |0d 0h 0m 0s |0d 0h 0m 0s |

**Composite SLO: 99.94% | Downtime per year: 0d 5h 15m 20s**

**App User FLow**

|Component  |SLO  |SLO with Zones  |Downtime per week  |Downtime per month  |Downtime per year  |
|------------|-----------|---------|---------|---------|---------|
|Azure Application Gateway |99.95% |99.99999999% |0d 0h 0m 0s |0d 0h 0m 0s |0d 0h 0m 0s  |
|Azure Internal Load Balancer |99.99% |100% |0d 0h 0m 0s |0d 0h 0m 0s |0d 0h 0m 0s |
|VMSS Frontend |99.99% |100% |0d 0h 0m 0s |0d 0h 0m 0s |0d 0h 0m 0s |
|VMSS Backend |99.99% |100% |0d 0h 0m 0s  |0d 0h 0m 0s  |0d 0h 0m 0s |
|Managed Disk |99.90% |99.9999999% |0d 0h 0m 0s |0d 0h 0m 0s |0d 0h 0m 0s |
|Azure KeyVault |99.99% |99.99% |0d 0h 0m 58s |0d 0h 4m 22s |0d 0h 52m 33s |

**Composite SLO: 99.98% | Downtime per year: 0d 0h 52m 53s**

In the preceding example, reliability of VMs and the dependencies are included. For instance, disks associated with VMs. The SLAs associated with disk storage impact the overall reliability.

There are some challenges when calculating the composite SLO. It's important to note that different tiers of service may come with different SLAs, and these often include financially backed guarantees that set reliability targets. Finally there might be components that don't have SLAs defined. For example, in terms of networking, Network Interface Cards (NICs) might not have their own SLAs, they do operate within VNets. However, VNets themselves do not have SLAs.

The business requirements and their targets must be clearly defined and factored into the calculation. Be aware of the service limits and additional constraints imposed by the organization. If your subscription is shared with other workloads, this could impact the resources available for your VMs. The workload might be allowed to use a limited number of cores available for the VMs. Understanding the resource usage of your subscription can help you design your VMs more effectively.

##### Redundancy

> Refer to Well-Architected Framework: [RE:05 - Recommendations for designing for redundancy](/azure/well-architected/reliability/redundancy).

This architecture uses zone-redundancy for several components. Each zone is made up of one or more datacenters with independent power, cooling, and networking. Having instances run in separate zones protects the application against data center failures.

- VMs are automatically spread across Availability Zones.  VMs are also placed in separate fault domains. This makes sure all VMs aren't updated at the same time.

    Azure VM scale sets allocate specified number of instances and distribute them evenly across Availability Zones and Fault Domains. This is achieved through the _maximum spread_ capability, which is recommended.

    Consider a scenario where there are three Availability Zones. If you have three instances, each instance is allocated to a different Availability Zone and placed in a different Fault Domain. Azure guarantees that only one Fault Domain is updated at a time in each Availability Zone. However, there could be a situation all three Fault Domains in three Availability Zones are updated simultaneously. All zones and domains will be impacted. Having atleast two instances in each zone provides a buffer during upgrades.

- Managed disks can only be attached to a VM in the same region. Their availability typically impacts the availability of the VM. For single-region deployments, disks can be configured for redundancy within a datacenter; locally Redundant Storage (LRS) or zone-Redundant Storage (ZRS). LRS is sufficient as it supports [zonal failure mitigations](/azure/virtual-machines/disks-redundancy#locally-redundant-storage-for-managed-disks). For workloads that need even less time to recover from failure, ZRS is a recommended. It requires a recovery strategy to take advantage of Availability Zones. Ideally pre-provision compute in alternate Availability Zones ready to recover from a zonal failure. 

    In this architecture, data disks are configured as LRS because all tiers are stateless. Recovery strategy is to redeploy the solution.

- A zone-redundant Application Gateway or Standard Load Balancer can route traffic to VMs across zones using a single IP address, ensuring continuity even in the event of zone failures. These services use health probes to check VM availability. As long as one zone in the region remains operational, routing continues despite potential failures in other zones. However, inter-zone routing may have higher latency compared to intra-zone routing.

- Azure offers zone-redundant services, which are distributed across multiple zones for better reliability. Azure global resources are always available and can switch to another region if necessary. In this architecture, Key Vault is zone-redundant, while the foundational Identity Provider, Microsoft Entra ID, is global.

##### Scaling strategy

> Refer to Well-Architected Framework: [RE:06 - Recommendations for designing a reliable scaling strategy](/azure/well-architected/reliability/redundancy).

Your scaling operations should be reliable so that when a degraded condition is detected additional resources are provisioned immediately. One strategy is overprovisioning. This is achieved by having sufficient horizontal capacity. This strategy involves understanding the maximum amount of work that the workload will handle. However, it's not just about having extra capacity. It's also about ensuring that your resources aren't underprovisioned. The VM should be right-sized for the work it's expected to handle.

Another strategy is to use autoscaling capabilities for the VM scale sets. Be sure to do adequate performance testing to set the threshold for CPU, memory, and others. When those thresholds are reached, new instances are immediately provisioned.

#### Self-healing and recoverability

> Refer to Well-Architected Framework: [Recommendations for self-healing and self-preservation](/azure/well-architected/reliability/self-preservation).

[Application Health extension](/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-health-extension) is deployed to VMs to detect unresponsive VMs and applications. For those instances, repair actions are automatically triggered. 

## Security

This architecture illustrates some of the security assurances given in the [Security design review checklist given in Azure Well-Architected Framework](/azure/well-architected/security/checklist). The sections are annotated with recommendations from that checklist.

Security isn't just technical controls. It's highly recommended that you follow the entire checklist to understand the operational aspects of the Security pillar. 


##### Segmentation

> Refer to Well-Architected Framework: [SE:04 - Recommendations for building a segmentation strategy](/azure/well-architected/security/segmentation).

- **Network segmentation**. Workload resources are placed in a VNet, which provides isolation from the internet. Within the VNet, subnets can be used as trust boundaries. _Colocate related resources needed for handling a transaction in one subnet_. In this architecture, the VNet is divided into subnets based on the logical grouping of the application and purpose of various Azure services used as part of the workload.

    The advantage of subnet segmentation is that you can place security controls at the perimeter that controls traffic flowing in and out of the subnet, thereby restricting access to the workload resources.

- **Identity segmentation**. Assign distinct roles to different identities with just-enough permissions to do their task. This architecture [Microsoft Entra ID](/entra/fundamentals/whatis) managed identities to segment access to resources.
 

##### Identity and access management

> Refer to Well-Architected Framework: [SE:05 - Recommendations for identity and access management](/azure/well-architected/security/identity-access).

[Microsoft Entra ID](/entra/fundamentals/whatis) recommended for authentication and authorization of both users and services. Workload resources such as VMs authenticate themselves by using their assigned managed identities to other resources. These identities, based on Microsoft Entra ID service principals, are automatically managed. 

In this architecture, [user-assigned managed identities](/entra/managed-identities-azure-resources/overview#managed-identity-types) are used by Azure Application Gateway, front VMs, and backend VMs to access Azure Key Vault and Azure Storage account for boot diagnostics. Those managed identities are configured during deployment and used for authenticating against Key Vault. Access policies on Key Vault are configured to only accept requests from the preceding managed identities.

>[!IMPORTANT]
> The baseline architecture uses only user-assigned managed identities. Even though you may specify a system-assigned managed identity in a Bicep or ARM template with no error, they cannot be used in a Flex VMSS configuration. The Azure portal however will respond with the appropriate error. 

##### Network controls

> Refer to Well-Architected Framework: [SE:06 - Recommendations for networking and connectivity](/azure/well-architected/security/networking).

- **Ingress traffic**. The workload VMs aren't directly exposed to the public internet. Each VM has a private IP address. Workload users connect using that public IP address of Azure Application Gateway.

    Additional security is provided through [Web Application Firewall](/azure/application-gateway/waf-overview) that's integrated with Application Gateway. It has rules that _inspect inbound traffic_ and can take an appropriate action. WAF tracks Open Web Application Security Project (OWASP) vulnerabilities preventing known attacks.  

- **Egress traffic**. There are no controls on outbound traffic. It's highly recommended that all outbound internet traffic flows through a single firewall. This firewall is usually a central service provided by organization. That use case is shown in [Virtual machine baseline architecture in an Azure landing zone](./vm-baseline-landing-zone.yml).

- **East-west traffic**. Traffic flow between the subnets is restricted by applying granular security rules. 

    [Network security groups (NSGs)](/azure/virtual-network/network-security-groups-overview) are placed to restrict traffic between subnets based on parameters such as IP address range, ports, and protocols. [Application security groups (ASG)](/azure/virtual-network/application-security-groups) are placed on frontend and backend VMs. They are used with NSGs  filter traffic to and from the VMs.  

- **Operational traffic**. It's recommended that secure operational access to workload is provided through Azure Bastion, which removes the need for public IP. In this architecture, that communication is over SSH that's supported by both Windows and Linux VMs. Entra ID is integrated with SSH for both types of VMs by using the //extension. That integration allows operator's identity to be authenticated and authorized through Entra ID.

    Alternatively, use a separate VM as a jumpbox in the subnet in that has the workload resources. The operator will access the jumpbox through the Bastion host. Then, log in to the VMs behind the load balancer from the jumpbox.  

    In both cases, appropriate NSG rules should be applied to restrict traffic. Security can be further enhanced with RBAC permissions and [just-in-time (JIT) VM access](/azure/defender-for-cloud/just-in-time-access-overview), a feature of Microsoft Defender for Cloud, which allows temporary inbound access to selected ports.

- **Private connectivity to PaaS services**. Communication between the VMs and Azure Key Vault is over Private Links. This service requires private endpoints, which are placed in a separate subnet.

- **DDoS protection**. Azure provides basic DDoS protection by default. Consider enabling [Azure DDoS Protection](/azure/virtual-network/ddos-protection-overview) on the public IP exposed by Application Gateway to detect threats. DDoS Protection also provides alerting, telemetry, and analytics through Azure Monitor. For more information, see [Azure DDoS Protection: Best practices and reference architectures](/azure/security/fundamentals/ddos-best-practices).

##### Encryption

> Refer to Well-Architected Framework: [SE:07 - Recommendations for data encryption](/azure/well-architected/security/encryption).

- **Data in transit**. User traffic to and from the frontend VMs is encyrpted using external and internal TLS certificates. Traffic between the frontend and backend VMs is also encrypted using internal certificate. Both certificates are stored in [Azure Key Vault](/azure/key-vault/general/overview): 
    - **app.contoso.com**: An external certificate used by clients and Application Gateway for secure public Internet traffic.
    - ***.worload.contoso.com**: A wildcard certificate used by the infrastructure components for secure internal traffic.

- **Data at rest**. Log data is stored in managed disk temporarily. That data is automatically encrypted by using platform-provided encryption in Azure Storage. 

##### Secret management

> Refer to Well-Architected Framework: [SE:09 - Recommendations for protecting application secrets](/azure/well-architected/security/application-secrets).

:::image type="content" source="./media/vm-baseline-certificates.svg" alt-text="Diagram that shows TLS termination and certificates used." lightbox="./media/vm-baseline-certificates.png":::

[Azure Key Vault](/azure/key-vault/general/overview) provides secure management of secrets, including TLS certificates. In this architecture, the TLS certificates are stored in the Key Vault and retrieved during the provisioning process by the managed identities of Application Gateway and the VMs. After the initial setup, these resources will only access the Key Vault when the certificates are refreshed.

The VMs use the [Azure Key Vault VM extension](/azure/virtual-machines/extensions/key-vault-linux) to automatically refresh the monitored certificates. If any changes are detected in the local certificate store, the extension retrieves and installs the corresponding certificates from the Key Vault. The extension supports certificate content types PKCS #12 and PEM.

> [!IMPORTANT]
> It is your responsibility to ensure your locally stored certificates are rotated regularly. See [Azure Key Vault VM extension for Linux](/azure/virtual-machines/extensions/key-vault-linux) or [Azure Key Vault VM extension for Windows](/azure/virtual-machines/extensions/key-vault-windows) for more details. 


## Cost Optimization

Workload requirements must be fulfilled keeping in my the cost constraints. This section describes  some options for optimizing costs. The strategies used in architecture are based on the [Cost Optimization design review checklist given in Azure Well-Architected Framework](/azure/well-architected/cost-optimization/checklist). The sections are annotated with recommendations from that checklist.


##### Component cost

> Refer to Well-Architected Framework: [CO:07 - Recommendations for optimizing component costs](/azure/well-architected/cost-optimization/optimize-component-costs).

Select VM images that are optimized for the workload instead of using general-purpose images. In this architecture, relatively small VM images are chosesn for both Windows and Linux, which are approximately 30GB each. With smaller images, VM SKUs with disks are also smaller, leading to lower costs and also faster deployment, boot times, reduced resource consumption. A side benefit is security because of the reduced surface area. 

Implementing log rotation with size limits is another cost saving strategy. It allows for using small data disks, which can result in lower costs. The implementation of this architecture uses 4GB disks.

The use of ephemeral OS disks can also lead to cost savings and improved performance. These disks are designed to use VM resources that you're already paying for, because they are installed on the cache disk provisioned with the VM. It eliminates storage costs associated with traditional persistent disks. Because these disks are temporary, there are no costs associated with long-term data storage.

##### Flow cost

> Refer to Well-Architected Framework: [CO:09 - Recommendations for optimizing flow costs](/azure/well-architected/cost-optimization/optimize-flow-costs).

Choose compute resources based on the criticality of the flow. For workflows that can tolerate interruptions, consider using [Spot VMs](/azure/architecture/guide/spot/spot-eviction) with VM scale setsFlexible Orchestration mode. This approach can be particularly effective for hosting low-priority flows on lower-priority VMs. This strategy allows for cost optimization while still meeting the requirements of different workflows.

##### Scaling cost

> Refer to Well-Architected Framework: [CO:12 - Recommendations for optimizing scaling costs](/azure/well-architected/cost-optimization/optimize-scaling-costs).

If the main cost driver is the number of instances, it may be more cost-effective to scale up by increasing the size or performance of the VMs. This approach can lead to cost savings in several areas:

- **Software licensing**. Larger VMs can handle more workload, potentially reducing the number of software licenses required.
- **Maintenance time**: Managing fewer, larger VMs can reduce operational costs.
- **Load balancing**: Fewer VMs can result in lower costs for load balancing. For example, in this architecture tere are multiple layers of load balancing, such as an Application Gateway at the front and an internal load balancer in the middle. Load balancing costs would increase if higher number of instances need to be managed.
- **Storage**. In case of stateful applications, more instances need more attached managed disks, increasing cost of storage.

## Alternatives

##### Egress traffic

This architecture uses Azure Load Balancer with outbound rules for egress traffic. There are some alternatives to use load balancer:

- **Deploy a NAT Gateway resource attached to the subnet.**

    This option simplifies outbound Internet connectivity. When configured on a subnet, all outbound connectivity uses the NAT gateway's static public IP addresses. NAT Gateway doesn't depend on individual compute instances such as VMs or a single physical gateway device. Software defined networking makes a NAT gateway highly resilient.

    NAT gateway can be deployed and operate out of individual availability zones. A single zonal NAT gateway resource can be configured to subnets that contain virtual machines that span multiple availability zones. If the zone that NAT gateway is deployed in goes down, then outbound connectivity across all virtual machine instances associated with the NAT gateway will also go down. This setup doesn't provide the best method of zone-resiliency.

    To overcome that situation, create a _zonal stack_ per availability zone. This stack consists of VM instances, a NAT gateway resource with public IP addresses or prefix on a subnet all in the same zone (NAT gateway and availability zones - Azure NAT Gateway). Failure of outbound connectivity due to a zone outage is isolated to the affected zone. The outage won't affect the other zonal stacks where other NAT gateways are deployed with their own subnets and zonal public IPs. Creating zonal stacks for each availability zone within a region is the most effective method for building zone-resiliency against outages for NAT gateway.


- **Use Azure Firewall or another Network Virtual Appliance (NVA) with a custom User Defined Route (UDR) as the next hop through firewall**.

    


## Next steps

See product documentation for details on specific Azure services:

- [Azure Virtual Machines](/azure/virtual-machines)
- [Azure Virtual Machine Scale Sets](/azure/virtual-machine-scale-sets/)

## Related resources

IaaS reference architectures showing options for the data tier:

- [Windows N-tier application using SQL Server on Azure](/azure/architecture/reference-architectures/n-tier/n-tier-sql-server)



----

## Dump zone




- Platform perspective

    The data disk performance (IOPS and throughput) metrics can be looked at individually (per disk) or rolled up to all disks attached to a VM. Both perspectives can be critical in troubleshooting a performance issue, as both the individual disks and the VM can cap total performance. 

    To troubleshoot suspected or alert on pending disk capping, use the *Storage IO utilization* metrics, which provide consumed percentage of the provisioned throughput for both virtual machines and disks. If your architecture uses bursting for cost optimization, then you'll want to monitor your *Credits Percentage* metrics. Running out of credits can be an expected result, as consistently having left over credits is a sign that further cost optimization could occur on that disk. Meaning if you are using bursting as part of your cost optimization strategy, you should monitor how many credits you're consistently leaving unused and see if you can choose a lower performance tier.


- Guest OS perspective

    VM Insights is recommended for getting key metrics from an operating system perspective on attached disks. This is where you'll report or alert on disk/drive metrics like *logical disk space used*, and the operating system kernel's own perspective on disk IOPS and throughput. Combining these performance metrics with the platform performance metrics can help isolate OS or even application throughput issues on your disks vs platform bottlenecks.