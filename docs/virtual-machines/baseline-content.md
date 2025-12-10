This article provides a foundational reference architecture for a workload deployed on Azure Virtual Machines.

The example workload assumed by this architecture is an internet-facing multi-tier web application that is deployed on separate sets of virtual machines (VMs). VMs are provisioned as part of Azure Virtual Machine Scale Sets deployments. This architecture can be used for these scenarios:

- **Private applications**. These applications include internal line-of-business applications or commercial off-the-shelf solutions.
- **Public applications**. These applications are internet-facing applications. This architecture isn't for high-performance computing, mission-critical workloads, applications highly affected by latency, or other specialized use cases.

The primary focus of this architecture isn't the application. Instead, this article provides guidance for configuring and deploying the infrastructure components with which the application interacts. These components include compute, storage, networking, and monitoring components.

This architecture serves as a starting point for an infrastructure as a service (IaaS)-hosted workload. The data tier is intentionally excluded from this guidance to maintain the focus on the compute infrastructure.

## Article layout

| Architecture | Design decision | Well-Architected Framework approach|
|---|---|---|
|&#9642; [Architecture diagram](#architecture) <br>&#9642; [Workload resources](#workload-resources) <br> &#9642; [Supporting resources](#workload-supporting-resources) <br> &#9642; [User flows](#user-flows) <br> |&#9642; [VM design choices](#vm-design-choices)<br> &#9642; [Disks](#disks) <br> &#9642; [Networking](#network-layout) <br> &#9642; [Monitoring](#monitoring) <br> &#9642; [Update management](#update-management) |  <br> &#9642; [Reliability](#reliability) <br> &#9642; [Security](#security) <br> &#9642; [Cost Optimization](#cost-optimization)|

> [!TIP]
> ![GitHub logo](../_images/github.svg) This [reference implementation](https://github.com/mspnp/iaas-baseline) demonstrates the best practices described in this article.
> The implementation includes an application that's a small test harness to exercise the infrastructure setup from end to end.

## Architecture

:::image type="content" source="./media/baseline-architecture.svg" alt-text="Virtual machine baseline architectural diagram." lightbox="./media/baseline-architecture.svg":::

*Download a [Visio file](https://arch-center.azureedge.net/baseline-architecture.vsdx) of this architecture.*

For more information about these resources, see Azure product documentation listed in [Related resources](#related-resources).

### Components

This architecture consists of several Azure services for both workload resources and workload supporting resources. The services for each and their roles are described in the following sections.

#### Workload resources

- [Azure Virtual Machines](/azure/well-architected/service-guides/virtual-machines) is an IaaS offering that provides scalable compute resources. In this architecture, VMs provide scalable and distributed processing across availability zones for both Windows and Linux workloads.

  [Azure Virtual Machine Scale Sets](/azure/well-architected/service-guides/virtual-machines) is a service that enables automatic deployment, scaling, and management of a group of identical VMs. In this architecture, it provisions and maintains the front-end and back-end compute resources by using Flexible orchestration mode.

  The sample application uses two tiers, and each tier requires its own compute.

  - The front end runs the web server and receives user requests.
  - The back end runs another web server that functions as a web API that exposes a single endpoint where the business logic runs.

  The front-end VMs have data disks (Premium_LRS) attached, which can be used to deploy a stateless application. The back-end VMs persist data to Premium_ZRS [local disks](#managed-disks) as part of its operation. You can extend this layout to include a database tier for storing state from the front-end and back-end compute. That tier is outside the scope of this architecture.

- [Azure Virtual Network](/azure/well-architected/service-guides/virtual-network) is a networking service that enables secure communication between Azure resources and on-premises environments. In this architecture, it isolates resources into subnets for security and traffic control.

- [Azure Application Gateway](/azure/well-architected/service-guides/azure-application-gateway) is a web traffic layer-7 load balancer that enables you to manage traffic to your web applications. It's the single point of ingress that routes requests to the front-end servers. In this architecture, it balances traffic to front-end VMs and includes a web application firewall (WAF) for protection.

- [Azure Load Balancer](/azure/well-architected/service-guides/azure-load-balancer) is a layer-4 load balancing service for User Datagram Protocol (UDP) and Transmission Control Protocol (TCP) traffic. In this architecture, the public load balancer distributes outbound traffic and supports source network address translation (SNAT). The internal load balancer routes traffic from the front-end tier to the back-end servers to ensure high availability and scalability within the virtual network.

  The Standard SKU provides outbound internet access to the VMs by using three public IP addresses.

- [Azure Key Vault](/azure/key-vault/general/overview) is a service for managing secrets, keys, and certificates. In this architecture, it stores Transport Layer Security (TLS) certificates that Application Gateway uses. It can also be used for installing certificates in the VMs or for getting application secrets by code deployed on the VMs.

#### Workload supporting resources

- [Azure Bastion](/azure/bastion/bastion-overview) is a managed service that provides Remote Desktop Protocol (RDP) and Secure Shell (SSH) access to VMs without exposing public IP addresses. In this architecture, it enables just-in-time operational access to VMs through a dedicated subnet.

- [Application Insights](/azure/well-architected/service-guides/application-insights) is an application performance management (APM) service that collects telemetry for availability, performance, and usage analysis. In this architecture it's deployed as a ready endpoint for future application telemetry, but the reference implementation doesn't emit or collect custom application logs because the application layer isn't in scope.

- [Log Analytics](/azure/well-architected/service-guides/azure-log-analytics) is a centralized telemetry store for metrics and logs queried with Kusto Query Language. In this architecture, it serves as the monitoring data sink that aggregates platform logs, VM insights data, and Application Insights telemetry for analysis, alerting, and dashboards. A storage account is provisioned as part of the workspace.

#### User flows

There are two types of users who interact with the workload resources: the **workload user** and **operator**. The flows for these users are shown in the preceding architecture diagram.

##### Workload user

1. The user accesses the website by using the exposed public IP address of Application Gateway.

1. Application Gateway receives HTTPS traffic, decrypts data using an external certificate for WAF inspection, and re-encrypts it using the internal wildcard certificate for transport to the front end.

1. Application Gateway balances traffic across front-end VMs and forwards the request to a front-end VM.

1. The selected front-end VM communicates to a back-end VM by using the private IP address of the load balancer, not the IP of any individual VM. This communication is also encrypted using the internal wildcard certificate.

1. The back-end VM decrypts the request using the internal certificate. After the back end processes the request, it returns the result to the front end, which returns the result to the application gateway, and it finally returns the result to the user.

##### Operator

The VMs in this architecture might require direct access by operators, but we recommend that remote access is minimized through automation and that access is monitored. The access might be for break-fix situations, troubleshooting, or part of an automated deployment process. This architecture doesn't have public IPs for control plane access. Azure Bastion acts as a serverless gateway, enabling operations to access VMs via SSH or RDP. This setup ensures secure and efficient access management.

1. The operator signs into the Azure portal or Azure CLI.
1. The operator accesses the Azure Bastion service and remotely connects to the desired VM.

## VM design choices

When selecting SKUs, it's important to have a baseline performance expectation. Several characteristics influence the decision-making process, including:

- CPU, memory, and disk input/output operations per second (IOPS).
- Processors architecture.
- Operating system (OS) image size.

For instance, if you're migrating a workload from an on-premises environment that requires Intel processor machines, choose VM SKUs that support Intel processors.

For information about the supported VM SKUs, see [Sizes for virtual machines in Azure](/azure/virtual-machines/sizes).

#### Bootstrapping
 
VMs often need to be bootstrapped, which is a process in which VMs are prepared and tuned to run the application. Common bootstrapping tasks include, installing certificates, configuring remote access, installing packages, tuning and hardening the OS configuration, and formatting and mounting data disks. It's important to automate the bootstrapping process as much as possible, so that the application can start on the VM without delay or manual intervention. Here are the recommendations for automation:

- **Virtual machine extensions**. These extensions are Azure Resource Manager objects that are managed through your Infrastructure-as-Code (IaC) deployment. This way, any failure is reported as a failed deployment that you can take action on. If there isn't an extension for your bootstrapping needs, create custom scripts. It's recommended that you run the scripts through the Azure Custom Script Extension.

    Here are some other extensions that can be used to automatically install or configure functionality on the VMs.

    - [Azure Monitor Agent (AMA)](/azure/azure-monitor/agents/agents-overview ) collects monitoring data from the guest OS and delivers it to Azure Monitor.
    - The Azure Custom Script Extension ([Windows](/azure/virtual-machines/extensions/custom-script-windows), [Linux](/azure/virtual-machines/extensions/custom-script-linux)) Version 2 downloads and runs scripts on Azure virtual machines (VMs). This extension is useful for automating post-deployment configuration, software installation, or any other configuration or management tasks.
    - Azure Key Vault virtual machine extension ([Windows](/azure/virtual-machines/extensions/key-vault-windows), [Linux](/azure/virtual-machines/extensions/key-vault-linux)) provides automatic refresh of certificates stored in a Key Vault by detecting changes and installing the corresponding certificates.
    - [Application Health extension with Virtual Machine Scale Sets](/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-health-extension) are important when Azure Virtual Machine Scale Sets does automatic rolling upgrades. Azure relies on health monitoring of the individual instances to do the updates. You can also use the extension to monitor the application health of each instance in your scale set and perform instance repairs using Automatic Instance Repairs.
    - Microsoft Entra ID and OpenSSH ([Windows](/entra/identity/devices/howto-vm-sign-in-azure-ad-windows), [Linux](/entra/identity/devices/howto-vm-sign-in-azure-ad-linux)) integrate with Microsoft Entra authentication. You can now use Microsoft Entra ID as a core authentication platform and a certificate authority to SSH into a Linux VM by using Microsoft Entra ID and OpenSSH certificate-based authentication. This functionality allows you to manage access to VMs with Azure role-based access control (Azure RBAC) and Conditional Access policies.

- **Agent-based configuration**. Linux VMs can use a lightweight native desired state configuration available through cloud-init on various Azure provided VM images. The configuration is specified and versioned with your IaC artifacts. Bringing your own configuration management solution is another way. Most solutions follow a declarative-first approach to bootstrapping, but do support custom scripts for flexibility. Popular choices include Desired State Configuration for Windows, Desired State Configuration for Linux, Ansible, Chef, Puppet, and others. All of these configuration solutions can be paired with VM extensions for a best-of-both experience. 

In the reference implementation, all bootstrapping is done through VM extensions and custom scripts, including a custom script for automating data disk formatting and mounting. 

> Refer to Well-Architected Framework: [RE:02 - Recommendations for automation design](/azure/well-architected/operational-excellence/enable-automation?branch=main#bootstrapping).

#### VM connectivity

To enable private communication between a VM and other devices in a particular virtual network, the VM's network interface card (NIC) is connected to one of the subnets of the virtual network. If you require multiple NICs for your VM, know that a maximum number of NICs is defined for each VM size.

If the workload needs low latency communication between VMs in the virtual network, consider accelerated networking, which is supported by Azure VM NICs. For more information, see [Benefits of accelerated networking](/azure/virtual-network/accelerated-networking-overview?tabs=redhat#benefits).

#### Virtual Machine Scale Sets with Flexible orchestration

VMs are provisioned as part of Virtual Machine Scale Sets with [Flexible orchestration](/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-orchestration-modes#scale-sets-with-flexible-orchestration). Virtual Machine Scale Sets are logical groupings of VMs that are used to meet business needs. The types of VMs in a grouping can be identical or different. They let you manage the lifecycle of machines, network interfaces, and disks using standard Azure VM APIs and commands.

Flexible orchestration mode facilitates operations at scale and helps with granular scaling decisions.

Fault domain configuration is needed to limit the effect of physical hardware failures, network outages, or power interruptions. With scale sets, Azure evenly spreads instances across fault domains for resilience against a single hardware or infrastructure issue.

We recommend that you offload fault domain allocation to Azure for maximum instance spreading, enhancing resilience and availability.

## Disks

To run the OS and application components, storage disks are attached to the VM. Consider using ephemeral disks for the OS and managed disks for data storage.

Azure provides a range of options in terms of performance, versatility, and cost. Start with Premium SSD for most production workloads. Your choice depends on the VM SKU. SKUs that support Premium SSD contain an *s* in the resource name, for example *Dsv4* but not *Dv4*.

For more information about the disk options with metrics such as capacity, IOPS, and throughput, see [Disk type comparison](/azure/virtual-machines/disks-types#disk-type-comparison).

Consider disk characteristics and performance expectations when selecting a disk.

- **VM SKU limitations**. Disks operate within the VM they're attached to, which have IOPS and throughput limits. Ensure the disk doesn't cap the VM's limits and vice versa. Select the disk size, performance, and VM capabilities (core, CPU, memory) that optimally run the application component. Avoid overprovisioning because it affects cost.

- **Configuration changes**. You can change some disk performance and capacity configurations while a VM is running. However, many changes can require reprovisioning and rebuilding disk content, affecting workload availability. Therefore, carefully plan disk and VM SKU selection to minimize availability impact and rework.

- **Ephemeral OS disks**. Provision OS disks as [ephemeral disks](/azure/virtual-machines/ephemeral-os-disks). Use managed disks only if OS files need to be persisted. Avoid using ephemeral disks for storing application components and state.

    The capacity of Ephemeral OS disks depends on the chosen VM SKU. Ensure your OS image disk size is less than the SKU's available cache or temporary disk. You can use the remaining space for temporary storage.

- **Disk performance**. Pre-provisioning disk space based on peak load is common, but it can lead to underutilized resources because most workloads don't sustain peak load.

    Monitor your workload's usage patterns, noting spikes or sustained high-read operations, and factor these patterns into your VM and managed disk SKU selection.

    You can adjust performance on demand by changing [performance tiers](/azure/virtual-machines/disks-change-performance#what-tiers-can-be-changed) or by using the [bursting features](/azure/virtual-machines/disk-bursting) offered in some managed disk SKUs.

    While overprovisioning reduces the need for bursting, it can lead to unused capacity that you're paying for. Ideally, combine both features for optimal results.

- **Tune caching for the workload**. Configure cache settings for all disks based on application component usage.

    Components that mainly perform read operations don't require high-disk transactional consistency. Those components can benefit from read-only caching. Write-heavy components requiring high-disk transactional consistency often have caching disabled.

    Using read-write caching could cause data loss if the VM crashes and isn't recommended for most data disk scenarios.

In this architecture:

- The OS disks of all VMs are ephemeral and located on the cache disk.

    The workload application in the front end (Linux) and back end (Windows Server) are tolerant to individual VM failures and both use small images (around 30 GB). Such attributes make them eligible for using Ephemeral OS disks created as part of the VM local storage (cache partition) instead of Persistent OS disk that is saved in remote Azure storage resources. This situation incurs no storage cost for OS disks and also improves performance by providing lower latencies and reducing the VM deployment time.

- Each VM has its own Premium SSD P1 managed disk, providing a base provisioned throughput suitable for the workload.

## Network layout

This architecture deploys the workload in a single virtual network. Network controls are a significant part of this architecture and are described in the [Security](#security) section.

:::image type="content" source="./media/baseline-network.svg" alt-text="Virtual machine baseline showing the network layout." lightbox="./media/baseline-network.svg":::

This layout can be integrated with an enterprise topology. That example is shown in [Virtual machine baseline architecture in an Azure landing zone](./baseline-landing-zone.yml).

#### Virtual network

One of your initial network layout decisions relates to the network address range. Keep in mind the anticipated network growth during the capacity planning phase. The network should be large enough to sustain the growth, which might need extra networking constructs. For instance, the virtual network should have the capacity to accommodate the other VMs that result from a scaling operation.

Conversely, right-size your address space. An excessively large virtual network can lead to underutilization. After the virtual network is created, you can't modify the address range.

In this architecture, the address space is set to */21*, a decision based on the projected growth.

#### Subnetting considerations

Within the virtual network, subnets are divided based on functionality and security requirements, as described here:

- A subnet to host the application gateway, which serves as the reverse proxy. Application Gateway requires a dedicated subnet.
- A subnet to host the internal load balancer for distributing traffic to back-end VMs.
- Subnets to host the workload VMs, one for front end and one for back end. These subnets are created according to the tiers of the application.
- A subnet for the Azure Bastion host to facilitate operational access to the workload VMs. By design, the Azure Bastion host needs a dedicated subnet.
- A subnet to host private endpoints created to access other Azure resources over Azure Private Link. While dedicated subnets aren't mandatory for these endpoints, we recommended them.

Similar to virtual networks, subnets must be right-sized. For instance, you might want to apply the maximum limit of VMs supported by Flexible orchestration to meet the application's scaling needs. The workload subnets should be capable of accommodating that limit.

Another use case to consider is VM OS upgrades, which might require temporary IP addresses. Right-sizing gives you the desired level of segmentation by making sure similar resources are grouped so that meaningful security rules through network security groups (NSGs) can be applied to the subnet boundaries. For more information, see [Security: Segmentation](#segmentation).

#### Ingress traffic

Two public IP addresses are used for ingress flows. One address is for Application Gateway that serves as the reverse proxy. Users connect using that public IP address. The reverse proxy load balances ingress traffic to the private IPs of the VMs. The other address is for operational access through Azure Bastion.

:::image type="content" source="./media/baseline-network-ingress.svg" alt-text="Diagram of a virtual machine baseline that shows ingress flow." lightbox="./media/baseline-network-ingress.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/baseline-network-ingress.vsdx) of this architecture.*

#### Egress traffic

This architecture uses standard SKU Load Balancer with outbound rules defined from the VM instances. Load Balancer was chosen because it's zone redundant.

:::image type="content" source="./media/baseline-network-egress.svg" alt-text="Diagram of a virtual machine baseline that shows ingress flow." lightbox="./media/baseline-network-egress.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/baseline-network-egress.vsdx) of this architecture.*

This configuration lets you use the public IP addresses of your load balancer to provide outbound internet connectivity for the VMs. The outbound rules let you explicitly define SNAT ports. The rules let you scale and tune this ability through manual port allocation. Manually allocating the SNAT port based on the back-end pool size and number of `frontendIPConfigurations` can help avoid SNAT exhaustion.

We recommend that you allocate ports based on the maximum number of back-end instances. If more instances are added than remaining SNAT ports allow, Virtual Machine Scale Sets scaling operations might be blocked, or the new VMs don't receive sufficient SNAT ports.

Calculate ports per instance as: `Number of front-end IPs * 64K / Maximum number of back-end instances`.

There are other options you can use, such as deploying an Azure NAT Gateway resource attached to the subnet. Another option is to use Azure Firewall or another Network Virtual Appliance with a custom user-defined route (UDR) as the next hop through the firewall. That option is shown in [Virtual machine baseline architecture in an Azure landing zone](./baseline-landing-zone.yml).

#### DNS resolution

Azure DNS is used as the foundational service for all resolution use cases, for example, resolving fully qualified domain names (FQDN) associated with the workload VMs. In this architecture, the VMs use the DNS values set in the virtual network configuration, which is Azure DNS.

Azure private DNS zones are used for resolving requests to the private endpoints used to access the named Private Link resources.

## Monitoring

This architecture has a monitoring stack that is decoupled from the utility of the workload. The focus is primarily on the data sources and collection aspects.

> [!NOTE]
> For a comprehensive view on observability, see [OE:07 Recommendations for designing and creating a monitoring system](/azure/well-architected/operational-excellence/observability).

Metrics and logs are generated at various data sources, providing observability insights at various altitudes:

- **Underlying infrastructure and components** are considered, such as VMs, virtual networks, and storage services. Azure platform logs provide information about operations and activities within the Azure platform.

- **The application level** provides insights into the performance and behavior of the applications running on your system.

The Log Analytics workspace is the recommended monitoring data sink used to collect logs and metrics from the Azure resources and Application Insights.

This image shows the monitoring stack for the baseline with components for collecting data from the infrastructure and application, data sinks, and various consumption tools for analysis and visualization. The implementation deploys some components, such as Application Insights, VM boot diagnostics, and Log Analytics. Other components are depicted to showcase the extensibility options, such as dashboards and alerts.

:::image type="content" source="./media/baseline-monitoring.svg" alt-text="Baseline monitoring data flow diagram." lightbox="./media/baseline-monitoring.svg":::

*Download a [Visio file](https://arch-center.azureedge.net/baseline-monitoring.vsdx) of this architecture.*

### Infrastructure-level monitoring

This table links to logs and metrics collected by Azure Monitor. The available alerts help you proactively address issues before they affect users.

| Azure resource | Metrics and logs | Alerts |
| -------------- | ---------------- | ------ |
|Application Gateway | [Application Gateway metrics and logs description](/azure/application-gateway/monitor-application-gateway-reference) | [Application Gateway alerts](/azure/application-gateway/high-traffic-support#alerts-for-application-gateway-v2-sku-standard_v2waf_v2) |
| Application Insights | [Application Insights metrics and logging API](/azure/azure-monitor/app/api-custom-events-metrics) | [Application Insights alerts](/azure/azure-monitor/alerts/alerts-smart-detections-migration) |
|Azure Bastion|[Azure Bastion metrics](/azure/bastion/howto-metrics-monitor-alert)|
| Key Vault | [Key Vault metrics and logs descriptions](/azure/key-vault/general/monitor-key-vault-reference) | [Key Vault alerts](/azure/key-vault/general/monitor-key-vault#alerts) |
|Standard Load Balancer|[Load balancer logs and metrics](/azure/load-balancer/load-balancer-standard-diagnostics)|[Load Balancer alerts](/azure/load-balancer/load-balancer-standard-diagnostics#configure-alerts-for-multi-dimensional-metrics)
| Public IP address | [Public IP address metrics and logs description](/azure/virtual-network/ip-services/monitor-public-ip) | [Public IP address metrics alerts](/azure/virtual-network/ip-services/monitor-public-ip#alerts) |
| Virtual Network | [Virtual network metrics and logs reference](/azure/virtual-network/monitor-virtual-network-reference) | [Virtual network alerts](/azure/virtual-network/monitor-virtual-network#alerts) |
| Virtual Machines and Virtual Machine Scale Sets | [VM metrics and logs reference](/azure/virtual-machines/monitor-vm-reference) | [VM alerts and tutorials](/azure/virtual-machines/monitor-vm#alerts) |
| Web Application Firewall | [Web Application Firewall metrics and logs description](/azure/web-application-firewall/ag/application-gateway-waf-metrics) | [Web Application Firewall alerts](/azure/web-application-firewall/ag/application-gateway-waf-metrics#configure-alerts-in-azure-portal) |

For more information on the cost of collecting metrics and logs, see [Log Analytics cost calculations and options](/azure/azure-monitor/logs/cost-logs) and [Pricing for Log Analytics workspace](https://azure.microsoft.com/pricing/details/monitor/). The nature of the workload and the frequency and number of metrics and logs collected greatly affect the metric and log collection costs.

##### Virtual machines

[Azure boot diagnostics](/azure/virtual-machines/boot-diagnostics) is enabled to observe the state of the VMs during boot by collecting serial log information and screenshots. In this architecture, that data can be accessed through Azure portal and the [Azure CLI vm boot-diagnostics get-boot-log command](/cli/azure/vm/boot-diagnostics?view=azure-cli-latest#az-vm-boot-diagnostics-get-boot-log). Azure manages the data. You have no control or access to the underlying storage resource. But if your business requirements demand more control, you can provision your own storage account to store boot diagnostics.

[VM insights](/azure/azure-monitor/vm/vminsights-overview) offers an efficient way to monitor VMs and scale sets. It gathers data from Log Analytics workspaces and provides predefined workbooks for performance data trending. This data can be viewed per VM or aggregated across multiple VMs.

Application Gateway and the internal load balancer use health probes to detect the endpoint status of the VMs before sending traffic.

##### Networking

In this architecture, log data is collected from several networking components that participate in the flow. These components include Application Gateway, load balancers, and Azure Bastion. They also include networking security components such as virtual networks, NSGs, public IP addresses, and Private Link.

##### Managed disks

Disk metrics depend on your workload, requiring a mix of key metrics. Monitoring should combine these perspectives to isolate OS or application throughput issues.

- The Azure platform perspective represents the metrics that indicate the Azure service, regardless of the workload that is connected to it. Disk performance metrics (IOPS and throughput) can be viewed individually or collectively for all VM-attached disks. Use storage IO utilization metrics for troubleshooting or alerting on potential disk capping. If you use bursting for cost optimization, monitor credits percentage metrics to identify opportunities for further optimization.

- The guest OS perspective represents metrics that the workload operator would view, regardless of the underlying disk technology. VM insights is recommended for key metrics on attached disks, such as logical disk space used, and the OS kernel's perspective on disk IOPS and throughput.

### Application-level monitoring

Even though the reference implementation doesn't make use of it, [Application Insights](/azure/azure-monitor/app/app-insights-overview) is provisioned as an APM for extensibility purposes. Application Insights  collects data from an application and sends that data to the Log Analytics workspace. It also can visualize that data from the workload applications.

The [application health extension](/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-health-extension) is deployed to VMs to monitor the binary health state of each VM instance in the scale set, and perform instance repairs if necessary by using scale set automatic instance repair. It tests for the same file as the Application Gateway and the internal Azure load balancer health probe to check if the application is responsive.

## Update management

VMs need to be updated and patched regularly so that they don't weaken the security posture of the workload. We recommend automatic and periodic VM assessments for early discovery and application of patches.

### Infrastructure updates

Azure updates its platform periodically to enhance the reliability, performance, and security of the host infrastructure for virtual machines. These updates include patching software components in the hosting environment, upgrading networking components or decommissioning hardware, and more. For more information about the update process, see [Maintenance for virtual machines in Azure](/azure/virtual-machines/maintenance-and-updates).

If an update doesn’t require a reboot, the VM is paused while the host is updated, or the VM is live-migrated to an already updated host. If maintenance requires a reboot, you’re notified of the planned maintenance. Azure also provides a time window in which you can start the maintenance, at your convenience. For more information about the self-maintenance window and how to configure the available options, see [Handling planned maintenance notifications](/azure/virtual-machines/maintenance-notifications).

Some workloads might not tolerate even few seconds of a VM freezing or disconnection for maintenance. For greater control over all maintenance activities, including zero-impact and rebootless updates, see [Maintenance Configurations](/azure/virtual-machines/maintenance-configurations). Creating a Maintenance Configuration gives you the option to skip all platform updates and apply the updates at your convenience. When this custom configuration is set, Azure skips all non-zero-impact updates, including rebootless updates. For more information, see [Managing platform updates with Maintenance Configurations](/azure/virtual-machines/maintenance-configurations)

### Operating system (OS) image upgrades

When doing OS upgrades, have a golden image that's tested. Consider using Azure Shared Image Gallery and Azure Compute Gallery for publishing your custom images. You should have a process in place that upgrades batches of instances in a rolling manner each time a new image is published by the publisher.

Retire VM images before they reach their end-of-life to reduce surface area.

Your automation process should account for overprovision with extra capacity.

You can use [Azure Update Management](/azure/update-manager/overview) to manage OS updates for your Windows and Linux virtual machines in Azure.Azure Update Manager provides a SaaS solution to manage and govern software updates to Windows and Linux machines across Azure, on-premises, and multicloud environments.

### Guest OS patching

Azure VMs provide the option of automatic VM guest patching. When this service is enabled, VMs are evaluated periodically and available patches are classified. It's recommended that Assessment Mode is enabled to allow daily evaluation for pending patches. On-demand assessment can be done, however, that doesn't trigger application of patches. If Assessment Mode isn't enabled, have manual ways of detecting pending updates.

Only the patches that are classified as *critical* or *security* are applied automatically across all Azure regions. Define custom update management processes that apply other patches.

For governance, consider the [Require automatic OS image patching on Virtual Machine Scale Sets](https://portal.azure.com/#blade/Microsoft_Azure_Policy/PolicyDetailBlade/definitionId/%2Fproviders%2FMicrosoft.Authorization%2FpolicyDefinitions%2F465f0161-0087-490a-9ad9-ad6217f4f43a) Azure Policy.

Automatic patching can put a burden on the system and can be disruptive because VMs use resources and might reboot during updates. Over-provisioning is recommended for load management. Deploy VMs in different Availability Zones to avoid concurrent updates and maintain at least two instances per zone for high availability. VMs in the same region might receive different patches, which should be reconciled over time.

Be aware of the tradeoff on cost associated with overprovisioning.

Health checks are included as part of automatic VM guest patching. These checks verify successful patch application and detect issues.

If there are custom processes for applying patches, use private repositories for patch sources. Doing so gives you better control in testing the patches to make sure the update doesn't negatively affect performance or security.

For more information, see [Automatic VM guest patching for Azure VMs](/azure/virtual-machines/automatic-vm-guest-patching).

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

This architecture uses availability zones as a foundational element to address reliability concerns.

In this setup, individual VMs are tied to a single zone. If a failure occurs, these VMs can be readily replaced with other VM instances by using Virtual Machine Scale Sets.

All other components in this architecture are either:

- Zone redundant, meaning they're replicated across multiple zones for high availability, such as Application Gateway or public IPs.
- Zone resilient, implying they can withstand zone failures, such as Key Vault.
- Regional or global resources that are available across regions or globally, such as Microsoft Entra ID.

Workload design should incorporate reliability assurances in application code, infrastructure, and operations. The following sections illustrate some strategies to make sure the workload is resilient to failures and is able to recover if there are outages at the infrastructure level.

The strategies used in architecture are based on the [Reliability design review checklist given in Azure Well-Architected Framework](/azure/well-architected/reliability/checklist). The sections are annotated with recommendations from that checklist.

Because no application is deployed, resiliency in application code is beyond the scope of this architecture. We recommend that you review all recommendations in the checklist and adopt them in your workload, if applicable.

#### Prioritize the reliability assurances per user flow

In most designs, there are multiple user flows, each with its own set of business requirements. Not all of these flows require the highest level of assurances, so segmentation is recommended as a reliability strategy. Each segment can be managed independently, ensuring that one segment doesn't affect others and providing the right level of resiliency in each tier. This approach also makes the system flexible.

In this architecture, application tiers implement the segmentation. Separate scale sets are provisioned for the front-end and back-end tiers. This separation enables independent scaling of each tier, allowing for implementation of design patterns based on their specific requirements, among other benefits.

> Refer to Well-Architected Framework: [RE:02 - Recommendations for identifying and rating flows](/azure/well-architected/reliability/identify-flows).

#### Identify the potential failure points

Every architecture is susceptible to failures. The exercise of failure mode analysis lets you anticipate failures and be prepared with mitigations. Here are some potential failure points in this architecture:

| Component | Risk | Likelihood | Effect/Mitigation/Note | Outage |
|-----------|------|------------|------------------------|--------|
| Microsoft Entra ID | Misconfiguration | Medium | Ops users unable to sign in. No downstream effect. Help desk reports configuration issue to identity team. | None |
| Application Gateway | Misconfiguration | Medium | Misconfigurations should be caught during deployment. If these errors happen during a configuration update, DevOps team must roll back changes. Most deployments that use the v2 SKU take around 6 minutes to provision. However it can take longer depending on the type of deployment. For example, deployments across multiple availability zones with many instances can take more than 6 minutes. | Full |
| Application Gateway | DDoS attack | Medium | Potential for disruption. Microsoft manages DDoS (L3 and L4) protection. Potential risk of effect from L7 attacks. | Full |
| Virtual Machine Scale Sets | Service outage | Low | Potential workload outage if there are unhealthy VM instances that trigger autorepair. Dependent on Microsoft to remediate. | Potential outage |
| Virtual Machine Scale Sets | Availability zone outage | Low | No effect. Scale sets are deployed as zone redundant. | None |

> Refer to Well-Architected Framework: [RE:03 - Recommendations for performing failure mode analysis](/azure/well-architected/reliability/failure-mode-analysis).

#### Reliability targets

To make design decisions, it's important to calculate the reliability targets, such as the composite service-level objectives (SLOs) of the workload. Doing so involves understanding the service-level agreements (SLAs) provided by Azure services used in the architecture. Workload SLOs must not be higher than the SLAs guaranteed by Azure. Carefully examine each component, from VMs and their dependencies, networking, and storage options.

Here's an example calculation where the main goal is to provide an approximate composite SLO. While this is a rough guideline, you should arrive at something similar. You shouldn't get a higher maximum composite SLO for the same flows unless you make modifications to the architecture.

**Operation flow**

| Component  | SLO  |
|------------|-----------|
| Microsoft Entra ID | 99.99% |
| Azure Bastion | 99.95% |

**Composite SLO: 99.94% | Downtime per year: 0d 5h 15m 20s**

**App user flow**

| Component  |SLO  |
|------------|-----------|
| Application Gateway |99.95% |
| Azure Load Balancer (internal) |99.99% |
| Front-end VMs using premium storage (composite SLO)|99.70% |
| Back-end VMs using premium storage (composite SLO)|99.70% |

**Composite SLO: 99.34% | Downtime per year: 2d 9h 42m 18s**

In the preceding example, reliability of VMs and the dependencies are included, such as disks associated with VMs. The SLAs associated with disk storage affect the overall reliability.

There are some challenges when calculating the composite SLO. Different service tiers might have different SLAs, and these SLAs often include financially backed guarantees that set reliability targets. Finally, there might be components of the architecture that don't have SLAs defined. For example, in terms of networking, NICs and virtual networks don't have their own SLAs.

The business requirements and their targets must be clearly defined and factored into the calculation. Be aware of the service limits and other constraints imposed by the organization. Sharing your subscription with other workloads could affect the resources available for your VMs. The workload might be allowed to use a limited number of cores available for the VMs. Understanding the resource usage of your subscription can help you design your VMs more effectively.

> Refer to Well-Architected Framework: [RE:04 - Recommendations for defining reliability targets](/azure/well-architected/reliability/metrics).

#### Redundancy

This architecture uses zone-redundancy for several components. Each zone is made up of one or more datacenters with independent power, cooling, and networking. Having instances run in separate zones protects the application against datacenter failures.

- Virtual Machine Scale Sets allocates a specified number of instances and distributes them evenly across availability zones and fault domains. This distribution is achieved through the *maximum spread* capability, which we recommend. Spreading VM instances across fault domains makes sure all VMs aren't updated at the same time.

  Consider a scenario where there are three availability zones in your Azure region. If you have three instances, each instance is allocated to a different availability zone and placed in a different fault domain. Azure guarantees that only one fault domain is updated at a time in each availability zone. However, there could be a situation in which all three fault domains hosting your VMs across the three availability zones are updated simultaneously. All zones and domains are affected. Having at least two instances in each zone provides a buffer during upgrades.

- Managed disks can only be attached to a VM in the same region. Their availability typically affects the availability of the VM. For single-region deployments, disks can be configured for redundancy to withstand zonal failures. In this architecture, data disks are configured zone-redundant storage (ZRS) on the back-end VMs. It requires a recovery strategy to take advantage of availability zones. The recovery strategy is to redeploy the solution. Ideally pre-provision compute in alternate availability zones ready to recover from a zonal failure.

- A zone-redundant Application Gateway or standard load balancer can route traffic to VMs across zones using a single IP address, ensuring continuity even if zone failures occur. These services use health probes to check VM availability. As long as one zone in the region remains operational, routing continues despite potential failures in other zones. However, inter-zone routing might have higher latency compared to intra-zone routing.

  All public IPs used in this architecture are zone redundant.

- Azure offers zone-resilient services for better reliability, such as Key Vault.

- Azure global resources are always available and can switch to another region if necessary, such as the foundational identity provider, Microsoft Entra ID.

> Refer to Well-Architected Framework: [RE:05 - Recommendations for designing for redundancy](/azure/well-architected/reliability/redundancy).

#### Scaling strategy

To prevent service level degradation and failures, ensure reliable scaling operations. Scale the workload horizontally (scale out), vertically (scale up), or use a combination of both those approaches. Use [Azure Monitor Autoscale](/azure/azure-monitor/autoscale/autoscale-overview) to provision enough resources to support the demand on your application without allocating more capacity than needed and incurring unnecessary costs. 

Autoscale allows you to define different profiles based on different event types, such as time, schedule, or metrics. Metrics-based profiles can use built-in metrics (host-based) or more detailed metrics (in-guest VM metrics) that requires installing the Azure Monitor Agent to collect them. Every profile contains rules for scale-out (increase) and scale-in (decrease). Consider exploring all different scaling scenarios based on designed profiles and evaluate them for potential loop conditions that can cause a series of opposing scale events. Azure Monitor will attempt to mitigate this situation by waiting for the cooldown period before it scales again. 

Although Azure Virtual Machine Scale Sets in Flexible mode supports heterogeneous environments, autoscaling of multiple profiles isn't supported. Consider creating different scale sets to manage them separately if you plan to use autoscale with more than one type of VM. 

Consider other aspects such as bootstrapping, graceful shutdowns, installing the workload and all its dependencies, and disk management when creating or deleting VMs instances. 

Stateful workloads might require extra management for managed disks that need to live beyond a workload instance. Design your workload for data management under scaling events for consistency, synchronization, replication, and integrity of the workload’s data. For those scenarios, consider [adding prepopulated disks to scale sets](/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-attached-disks#adding-pre-populated-data-disks-to-an-existing-scale-set). For use cases where scaling is used to prevent bottlenecks when accessing data, plan for partitioning and sharding. For more information, see [Autoscale best practices](/azure/azure-monitor/autoscale/autoscale-best-practices#autoscale-best-practices).

> Refer to Well-Architected Framework: [RE:06 - Recommendations for designing a reliable scaling strategy](/azure/well-architected/reliability/scaling).

#### Self-healing and recoverability

[Automatic instance repairs](/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-automatic-instance-repairs) is enabled in the Virtual Machine Scale Sets to automate recovery from VM failures. The [application health extension](/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-health-extension) is deployed to VMs to support detecting unresponsive VMs and applications. For those instances, repair actions are automatically triggered.

> Refer to Well-Architected Framework: [Recommendations for self-healing and self-preservation](/azure/well-architected/reliability/self-preservation).

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

Security doesn't only refer to technical controls. We recommend that you follow the entire checklist to understand the operational aspects of the Security pillar.

#### Segmentation

- **Network segmentation**. Workload resources are placed in a virtual network, which provides isolation from the internet. Within the virtual network, subnets can be used as trust boundaries. *Colocate related resources needed for handling a transaction in one subnet*. In this architecture, the virtual network is divided into subnets based on the logical grouping of the application and purpose of various Azure services used as part of the workload.

    The advantage of subnet segmentation is that you can place security controls at the subnet perimeter to manage the flow of traffic in and out, which restricts access to workload resources.

- **Identity segmentation**. Assign distinct roles to different identities with just-enough permissions to do their task. This architecture uses identities managed by [Microsoft Entra ID](/entra/fundamentals/whatis) to segment access to resources.

- **Resource segmentation**. The application is segmented by tiers into separate scale sets, which ensures that application components aren't colocated.  

> Refer to Well-Architected Framework: [SE:04 - Recommendations for building a segmentation strategy](/azure/well-architected/security/segmentation).

#### Identity and access management

We recommend [Microsoft Entra ID](/entra/fundamentals/whatis) for authentication and authorization of both users and services.

Access to VMs requires a user account, controlled by Microsoft Entra ID authentication and backed by security groups. This architecture provides support by deploying Microsoft Entra ID authentication extension to all VMs. We recommend that human users use their corporate identities in their organization's Microsoft Entra ID tenant. Also, ensure that any service principal-based access isn't shared across functions.

Workload resources, such as VMs, authenticate themselves by using their assigned managed identities to other resources. These identities, based on Microsoft Entra ID service principals, are automatically managed.

For example, Key Vault extensions are installed on VMs, which boot up the VMs with certificates in place. In this architecture, [user-assigned managed identities](/entra/identity/managed-identities-azure-resources/overview#managed-identity-types) are used by Application Gateway, front-end VMs, and back-end VMs to access Key Vault. Those managed identities are configured during deployment and used for authenticating against Key Vault. Access policies on Key Vault are configured to only accept requests from the preceding managed identities.

The baseline architecture uses a mix of system-assigned and user-assigned managed identities. These identities are required to use Microsoft Entra ID for authorization purposes when accessing other Azure resources.

> Refer to Well-Architected Framework: [SE:05 - Recommendations for identity and access management](/azure/well-architected/security/identity-access).

#### Network controls

- **Ingress traffic**. The workload VMs aren't directly exposed to the public internet. Each VM has a private IP address. Workload users connect using the public IP address of Application Gateway.

    More security is provided through [Web Application Firewall](/azure/application-gateway/waf-overview) that is integrated with Application Gateway. It has rules that inspect inbound traffic and can take appropriate action. WAF tracks Open Web Application Security Project (OWASP) vulnerabilities preventing known attacks.

- **Egress traffic**. There are no controls on outbound traffic except the outbound NSG rules on the VM subnets. We recommend that all outbound internet traffic flows through a single firewall. This firewall is usually a central service provided by an organization. That use case is shown in [Virtual machine baseline architecture in an Azure landing zone](./baseline-landing-zone.yml).

- **East-west traffic**. Traffic flow between the subnets is restricted by applying granular security rules.

    [Network security groups (NSGs)](/azure/virtual-network/network-security-groups-overview) are placed to restrict traffic between subnets based on parameters such as IP address range, ports, and protocols. [Application security groups (ASG)](/azure/virtual-network/application-security-groups) are placed on front-end and back-end VMs. They're used with NSGs to filter traffic to and from the VMs.

- **Operational traffic**. We recommend that secure operational access to a workload is provided through Azure Bastion, which removes the need for a public IP. In this architecture, that communication is over SSH and is supported by both Windows and Linux VMs. Microsoft Entra ID is integrated with SSH for both types of VMs by using the corresponding VM extension. That integration allows an operator's identity to be authenticated and authorized through Microsoft Entra ID.

    Alternatively, use a separate VM as a jump box, deployed to its own subnet, where you can install your choice of admin and troubleshooting tools. The operator accesses the jump box through the Azure Bastion host. Then, they sign in to the VMs behind the load balancer from the jump box.

    In this architecture, operational traffic is protected using NSG rules to restrict traffic, and [just-in-time (JIT) VM access](/azure/defender-for-cloud/just-in-time-access-overview) is enabled on the VMs. This feature of Microsoft Defender for Cloud allows temporary inbound access to selected ports.

    For enhanced security, use [Microsoft Entra Privileged Identity Management (PIM)](/entra/id-governance/privileged-identity-management/pim-configure). PIM is a service in Microsoft Entra ID that lets you manage, control, and monitor access to important resources in your organization. PIM provides time-based and approval-based role activation to mitigate the risks of excessive, unnecessary, or misused access permissions on resources that you care about.

- **Private connectivity to platform as a service (PaaS) services**. Communication between the VMs and Key Vault is over Private Link. This service requires private endpoints, which are placed in a separate subnet.

- **DDoS protection**. Consider enabling [Azure DDoS Protection](/azure/virtual-network/ddos-protection-overview) on the public IPs exposed by Application Gateway and the Azure Bastion Host to detect threats. DDoS Protection also provides alerting, telemetry, and analytics through Monitor. For more information, see [Azure DDoS Protection: Best practices and reference architectures](/azure/security/fundamentals/ddos-best-practices).

> Refer to Well-Architected Framework: [SE:06 - Recommendations for networking and connectivity](/azure/well-architected/security/networking).

#### Encryption

- **Data in transit**. User traffic between users and the Application Gateway public IP is encrypted using the external certificate. Traffic between the application gateway and the front-end VMs, and between the front-end and back-end VMs is encrypted using an internal certificate. Both certificates are stored in [Key Vault](/azure/key-vault/general/overview):
  - `app.contoso.com`: An external certificate used by clients and Application Gateway for secure public internet traffic.
  - `*.workload.contoso.com`: A wildcard certificate used by the infrastructure components for secure internal traffic.

- **Data at rest**. Log data is stored in a managed disk attached to VMs. That data is automatically encrypted by using platform-provided encryption on Azure.

> Refer to Well-Architected Framework: [SE:07 - Recommendations for data encryption](/azure/well-architected/security/encryption).

#### Secret management

:::image type="content" source="./media/baseline-certificates.svg" alt-text="Diagram that shows TLS termination and certificates used." lightbox="./media/baseline-certificates.png":::

*Download a [Visio file](https://arch-center.azureedge.net/baseline-certificates.vsdx) of this architecture.*

[Key Vault](/azure/key-vault/general/overview) provides secure management of secrets, including TLS certificates. In this architecture, the TLS certificates are stored in the Key Vault and retrieved during the provisioning process by the managed identities of Application Gateway and the VMs. After the initial setup, these resources only access Key Vault when the certificates are refreshed.

The VMs use the [Key Vault VM extension](/azure/virtual-machines/extensions/key-vault-linux) to automatically refresh the monitored certificates. If any changes are detected in the local certificate store, the extension retrieves and installs the corresponding certificates from Key Vault. The extension supports certificate content types PKCS #12 and PEM.

> [!IMPORTANT]
> It is your responsibility to ensure your locally stored certificates are rotated regularly. For more information, see [Azure Key Vault VM extension for Linux](/azure/virtual-machines/extensions/key-vault-linux) or [Azure Key Vault VM extension for Windows](/azure/virtual-machines/extensions/key-vault-windows).

> Refer to Well-Architected Framework: [SE:09 - Recommendations for protecting application secrets](/azure/well-architected/security/application-secrets).

### Cost Optimization

Cost Optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

#### Component cost

Select VM images that are optimized for the workload instead of using general-purpose images. In this architecture, relatively small VM images are chosen for both Windows and Linux, which are 30 GB each. With smaller images, VM SKUs with disks are also smaller, leading to lower costs, reduced resource consumption, and faster deployment and boot times. A benefit is enhanced security because of the reduced surface area.

Implementing log rotation with size limits is another cost-saving strategy. It allows for using small data disks, which can result in lower costs. The implementation of this architecture uses 4-GB disks.

The use of Ephemeral OS disks can also lead to cost savings and improved performance. These disks are designed to use VM resources that you already pay for because they're installed on the cache disk provisioned with the VM. It eliminates storage costs associated with traditional persistent disks. Because these disks are temporary, there are no costs associated with long-term data storage.

> Refer to Well-Architected Framework: [CO:07 - Recommendations for optimizing component costs](/azure/well-architected/cost-optimization/optimize-component-costs).

#### Flow cost

Choose compute resources based on the criticality of the flow. For flows that are designed to tolerate an indeterminate length, consider using [spot VMs](/azure/architecture/guide/spot/spot-eviction) with Virtual Machine Scale Sets Flexible orchestration mode. This approach can be effective for hosting low-priority flows on lower-priority VMs. This strategy allows for cost optimization while still meeting the requirements of different flows.

> Refer to Well-Architected Framework: [CO:09 - Recommendations for optimizing flow costs](/azure/well-architected/cost-optimization/optimize-flow-costs).

#### Scaling cost

If the main cost driver is the number of instances, it might be more cost-effective to scale up by increasing the size or performance of the VMs. This approach can lead to cost savings in several areas:

- **Software licensing**. Larger VMs can handle more workload, potentially reducing the number of software licenses required.
- **Maintenance time**: Fewer, larger VMs can reduce operational costs.
- **Load balancing**: Fewer VMs can result in lower costs for load balancing. For example, in this architecture there are multiple layers of load balancing, such as an application gateway at the front and an internal load balancer in the middle. Load balancing costs would increase if a higher number of instances need to be managed.
- **Disk storage**. If there are stateful applications, more instances need more attached managed disks, increasing cost of storage.

> Refer to Well-Architected Framework: [CO:12 - Recommendations for optimizing scaling costs](/azure/well-architected/cost-optimization/optimize-scaling-costs).

#### Operational costs

Automatic VM guest patching reduces the overhead of manual patching and the associated maintenance costs. Not only does this action help make the system more secure, but it also optimizes resource allocation, contributing to overall cost efficiency.

> Refer to Well-Architected Framework: [CO:13 - Recommendations for optimizing personnel time](/azure/well-architected/cost-optimization/optimize-personnel-time).

## Deploy this scenario

A deployment for this reference architecture is available on GitHub.

> [!div class="nextstepaction"]
> [Implementation: Azure Virtual Machines baseline architecture](https://github.com/mspnp/iaas-baseline/#deploy-the-reference-implementation)

## Related resources

See product documentation for details on specific Azure services:

- [Azure Virtual Machines](/azure/virtual-machines)
- [Azure Virtual Machine Scale Sets](/azure/virtual-machine-scale-sets/)
- [Azure Virtual Network](/azure/virtual-network/)
- [Azure Application Gateway Standard_v2](/azure/application-gateway/overview-v2)
- [Azure Load Balancer](/azure/load-balancer/)
- [Azure Key Vault](/azure/key-vault/general/)
- [Azure Bastion](/azure/bastion/)
- [Application Insights](/azure/azure-monitor/app/app-insights-overview)
- [Log Analytics](/azure/azure-monitor/logs/log-analytics-overview)

## Next step

Review the IaaS reference architectures that show options for the data tier:

- [Windows N-tier application using SQL Server on Azure](/azure/architecture/reference-architectures/n-tier/n-tier-sql-server)
