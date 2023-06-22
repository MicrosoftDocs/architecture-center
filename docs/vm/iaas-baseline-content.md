
This article provides a foundational reference architecture for an Infrastructure-as-a-Service (IaaS) workload. The intent is to showcase a typical lift-and-shift use case in which an application is rehosted from on-premises to Azure without any code changes.  

The focus of this architecture isn't that application. Instead it provides guidance for configuring and deploying the infrastructure components with which the application interacts. This includes the components such as compute, storage, networking, monitoring and more. 

On-premises architecture are designed with a Capital Expense (CAPEX) mindset. When migrating to the cloud, take advantage of the elastic nature of the cloud services. Certain configurations that worked on-premises can be cost optimized on Azure. Do rigorous testing to establish a baseline that's inline with the expectation of the on-premises systems but can be easily extended to adapt to the changes in business requirements.

> [!TIP]
> ![GitHub logo](../_images/github.svg) The best practices described in this architecture are demonstrated by a [**reference implementation**](). Consider the implementation as your first step towards production for a lift-and-shift application.
> The implementation includes an application that's a small test harness that will exercise the infrastructure set up end-to-end. 



## Architecture

:::image type="content" source="./media/iaas-baseline-architecture.png" alt-text="IaaS baseline architectural diagram" lightbox="./media/iaas-baseline-architecture.png":::

*Download a [Visio file](https://microsoft-my.sharepoint.com/:u:/r/personal/josev_microsoft_com/_layouts/15/doc2.aspx?sourcedoc=%7B07ba5bba-c61b-4b5e-bd37-1d4c20adf6b3%7D&action=view&share=IQG6W7oHG8ZeS703HUwgrfazAfcpYv2OBI9EIkxS8W1jamA&cid=12c82ef1-48e5-4fdf-b442-c52eb52ea874) of this architecture.*

//TODO: Load final Visio into blob storage (ie: https://arch-center.azureedge.net/iaas-baseline.vsdx)  
//TODO: Refresh all images from Visio and convert to .svg  
//TODO: Create thumbnail for browser  

#### Workload resources

- **Azure Virtual Machine** (VM) serves as the compute needed for the application. For illustrative purposes, there's a mix of both Windows and Linux images. The VMs are spread across availability zones so that the application is resilient to data center failures within a zone.  

- **Azure Virtual Machine Scale Sets** in Flexible orchestration mode provisions and manages the virtual machines individually. This mode was chosen because of the ease of operations, for example automatically spreading VMs across fault domains. Also, scaling demands of the application are met by provisioning more or decommissioning VMs, as needed. For more information, see [Scale sets with Flexible orchestration](/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-orchestration-modes#scale-sets-with-flexible-orchestration).

- **Azure Virtual Network** provides a private network for all workload resources. The network is segmented into subnets that act as isolation boundaries.

- **Azure Application Gateway Standard_v2** is the single point of ingress. It routes user requests to front end servers.  

    This SKU has integrated Azure Web Application Firewall (WAF) that inspects incoming requests to check for OWASP vulnerabilities.

    It also supports cross-zone redundancy.

- **Azure Load Balancer** routes traffic from the frontend tier to the backend servers. The load balancer has zonal redundancy to enable distribution to VMs across zones.  

- **Azure Key Vault** stored certificates used for end-to-end TLS communication by the workload. It also stores application secrets. 

#### Workload supporting resources

- **Azure Bastion** provides operational access to the VMs over Remote Desktop Protocol (RDP) and Secure Shell (SSH). Communication is over a private connection that prevents the VMs from being exposed through public IP addresses.  

- **Azure Application Insights** collects logs and metrics from the application. 

- **Azure Log Analytics** is the monitoring data sink that collects logs and metrics from the Azure resources and Application Insights. A storage account is provisioned as part of the workspace. 

### Workflow

<!-- FOR DRAFT REFERENCE ONLY - TO BE REMOVED -->
THIS DIAGRAM IS TEMPORARY FOR REFERENCE ONLY:
:::image type="content" source="./media/iaas-baseline-architecture-temp.png" alt-text="IaaS baseline architectural diagram" lightbox="./media/iaas-baseline-architecture-temp.png":::
<!-- FOR DRAFT REFERENCE ONLY - TO BE REMOVED -->

##### Workload user

1. Workload user browses to the web site via public IP address and connects to Azure Application Gateway. 
1. Application Gateway receives HTTPS traffic and uses the external certificate to decrypt data for inspection by WAF. If data passes the WAF test, Application Gateway encrypts the data using the internal wildcard certificate for transport to the web tier. 
1. The zone-redundant Application Gateway balances traffic across the three zones in the frontend. Application Gateway connects to a VM in the pool of web tier VMs, on behalf of the user session.
1. The front-end web tier is the first layer of the three-tier application, with VMs hosted in three availability zones. The front-end VM that receives the request uses the internal certificate to decrypt data for inspection, then encrypts the data for transport to the back-end tier based on the request. 
1. The front-end web app connects to the zone-redundant back-end Azure Load Balancer. Load Balancer connects to a VM in the pool of zone-redundant API tier VMs, forwarding the call to the API app.
1. The back-end VM that receives the request uses the internal certificate to decrypt data for inspection, then encrypts the data for transport to the data tier based on the request.
1. The back-end API app makes an API call to the data tier, which returns a result set to the API app. The API app returns the result to the web tier app. The web tier app returns the result to the Application Gateway, which returns it to the user.

##### Operations user

1. Operations user signs in to Azure portal.
1. The operations user accesses Azure Bastion service, then remotes into desired VM for troubleshooting using the appropriate tool.
1. TBD 

## Compute layout and design choices

The sample application can be represented in two tiers, each requiring its own compute.  

1. Frontend runs the web server and receives user requests.
1. Backend runs business logic to process those requests. 

Both compute are stateless to reduce complexity during scaling operations. Temporary state can be stored on [disks](#managed-disks). This layout may be extended to include a database tier for storing state from the frontend and backend compute. That tier is outside the scope of this architecture.

##### VM SKUs

When migrating an existing workload to the cloud, have a baseline expectation for performance that matches your on-premises servers. This will impact the capabilities you choose for virtual machines on Azure, such as:

- CPU, memory, and disk input/output operations per second (IOPS)
- Storage volumes
- Processors architecture
- Operating system (OS)

As an example of changes to the architecture in the cloud from on-premises, consider the OS. The OS ran on a disk with fixed capacity. In Azure, the OS footprint influences your choice in VM and disk SKUs.

For information about the supported VM SKUs, see [Sizes for virtual machines in Azure](/azure/virtual-machines/sizes).

##### VM connectivity

To enable a VM to communicate with the virtual network, you need Network interfaces (NICs).

On-premises servers can have virtualized networking where hosts connect to external networks through virtual switches. The switches have policies in place that control traffic going in and out of the servers.

If the workload needs low latency, that set up can be a disadvantage because the policy processing requires an extra hop at the switch. Azure VM NICs support **accelerated networking**. The processing is directly offloaded by the VM NIC to the underlying hardware. This results in lower latency and the CPU can process the payload faster. For more information, see [Benefits of accelerated networking](/azure/virtual-network/accelerated-networking-overview?tabs=redhat#benefits).

If you require multiple NICs for your VM, be aware that a maximum number of NICs is defined for each VM size.

//This is disabled on the NIC.

##### Disks

Storage area network (SAN) volumes are needed to run the operating system and application components. They can be used to run the OS or store temporary data. In Azure, these volumes or disks, are _attached_ to the VM. **Ephemeral OS disks** are recommended for OS. **Managed disks** are recommended for data storage.

Azure offers options varying in performance, tunability, and cost. Most production workloads should start with Premium SSD. The choice is tied to the VM SKU. VM SKUs that support Premium SSD contain 's' in the resource name, for example 'Dsv4' but not 'Dv4.'

For more information about the disk options with metrics such as capacity, IOPS, throughput and others, see [Disk type comparison](/azure/virtual-machines/disks-types#disk-type-comparison).

When choosing the appropriate disk, keep in mind the disk characteristics and performance expectations. 

Here are some considerations:

- **The limitations of the VM SKU**. Disks run in context the VM to which its attached. VMs have limits for both IOPS and throughput across all attached disks. A disk must not impose a cap on the attached VM's limits, and vice versa. Determine the required disk size and performance along with the VM core, CPU, and memory capabilities. Then, choose and test SKU combinations that will run the application component optimally on that VM instance.

    Don't overprovision either resource because the overall cost will be impacted.

- **Configuration changes**. You can change certain disk performance and capacity configurations while a VM instance is running. However, many changes might require a complete re-provisioning and rebuilding of content on the disk. Bringing a VM down to make a disk change might impact the availability of the workload. Take a "measure twice, cut once" approach to disk and virtual machine SKU selection in your architecture planning to minimize availability impact and rework.

//{CHAD} What's the workaround for the use case that requires re-provisioning. Include something about scaling? 

- **Ephemeral OS disks**. OS disks must not store application components or state. OS disks should be provisioned as [ephemeral disks](/azure/virtual-machines/ephemeral-os-disks). Managed disks can be considered only when OS files need to be persisted. 

    Ephemeral OS disks capacity is based on the selected virtual machine SKU. Your OS image's expected disk size should be less than the available cache or temp disk available on the SKU. Remaining space can be used for temporary storage. 

- **Disk performance**. It's a common practice to pre-provision disk space based on peak load. However, most workloads don't sustain peak load, which might lead to under utilized resources. 

    Monitor the workload's usage patterns. For example, you might notice a spike during certain times. At other times, there might be sustained high-read operations. Factor in this pattern when you select VM and managed disk SKUs. 
    
    You can change the performance on demand by changing the [performance tiers](/azure/virtual-machines/disks-change-performance#what-tiers-can-be-changed). Another way is to take advantage of the [bursting features](/azure/virtual-machines/disk-bursting) offered in some managed disks SKUs. 

    Over provisioning will need less bursting, however, the tradeoff is unused provisioned capacity that you pay for. To get the best results, combine the two features if possible.

- **Tune caching for the workload**. All disks should have their cache setting configured based on the application component usage. 
     
    Application components that mostly do read operations don't require high disk transactional consistency and can benefit from read-only caching. Components that are write heavy, require high disk transactional consistency. For these disks, caching is often disabled.
    
    Read-write caching for workload components could lead to data loss in the event of a virtual machine crash and is generally not recommended for most data disk scenarios.

In this architecture, the both backend and frontend VMs use Standard HDD LRS. //this seems to be off. 

- All virtual machine OS disks are ephemeral, and are placed on the cache disk. This places the Windows page file on the same ephemeral disk.
- Each virtual machine has its own Premium SSD P3 managed disk attached, giving a base provisioned throughput suitable for our workload.


##### Virtual Machine Scale Sets with flexible orchestration

In this architecture, VMs are provisioned as part of **Virtual Machine Scale Sets (VMSS) with [Flexible orchestration](/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-orchestration-modes#scale-sets-with-flexible-orchestration)** to facilitate operations at scale. VMSS represent a logical organization of VMs. The expected capacity can be met by allocating identical VMs or multiple virtual machine types. You can manage the machine lifecycle, including network interfaces and disks using the standard Azure VM APIs and commands.

Another benefit is that the flexible orchestration mode of VMSS allows for better control and more granular scaling decisions.

One important factor to consider in your IaaS baseline is the configuration of fault domains. Fault domains provides a way to limit the impact of potential physical hardware failures, network outages, or power interruptions. When using VMSS, Azure evenly spreads instances across fault domains. The even spreading ensures that a single hardware or infrastructure issue does not affect all instances.

In the IaaS baseline for VMSS flexible orchestration, it is recommended to let Azure manage the allocation of fault domains. This allows Azure to maximize spreading of instances, providing greater resilience and availability.

## Networking 

This architecture uses a single virtual network (VNet) in which the workload resources are deployed. The purpose is to demonstrate basic controls needed to restrict traffic while maintaining focus on the compute layer. In an enterprise setup, this VNet can be integrated with an organization-provided topology. That example is shown in [Infrastructure as a Service (IaaS) baseline in Azure landing zones](./iaas-baseline-landing-zone.yml).

:::image type="content" source="./media/iaas-baseline-network-topology.png" alt-text="IaaS baseline architectural diagram" lightbox="./media/iaas-baseline-network-topology.png":::


##### Virtual network

One of the initial decisions is the **network address range**. Keep in mind the expected growth of the network as you do capacity planning for the entire workload. The _network should be large enough_ to accomodate that growth, which might need extra networking constructs. For example, the VNet should be able to fit the additional VMs as a result of a scaling operation.

Conversely, _right-size your address space_. A virtual network that's too large might be underutilized. Once you create the VNet, you can't change the address range.

In this architecture, the address space is set to /21 based on the expected growth. 

##### Network isolation

In the VNet, **carve out subnets based on functionality and security requirements**. 

Subnets can be used as trust boundaries. _Colocate related resources needed for handling a transaction in one subnet_. Another strategy is to group by roles. In this architecture, these subnets are created based on the logical grouping of the application and purpose of various Azure services used as part of the workload.

- **Subnet to host Application Gateway** that acts as the reverse proxy. By design, Application Gateway requires a dedicated subnet.
- **Subnet to host internal load balancer** to distribute traffic to backend VMs.
- **Subnets to host the workload VMs**. They are divided as per the tiers of the application. 
- **Subnet for the Bastion host** to allow operational access to the workload VMs. By design, Bastion host requires a dedicated subnet.
- **Subnet to host private endpoints** that are created to reach other Azure resources over Private Links. Dedicated subnets aren't required for these endpoints but are highly recommended. 

_Restrict traffic flow between the subnets_ by applying granular security rules.

Place [network security groups (NSGs)](/azure/virtual-network/network-security-groups-overview) to restrict traffic based on parameters such as IP address range, ports, and protocols. In this architecture, the following rules are implemented.

//TODO: review rules and add details from the actual implementation

Use [Application security groups (ASG)](/azure/virtual-network/application-security-groups) with NSGs. They enable you to specify named entities for IP address ranges. The benefit is that you don't need to change NSG rules if you want to modify addresses. It's also easier to review the rules.

Two ASGs are used in this scenario:

- WebFrontend ASG - The network interface of the frontend VMs are assigned to this ASG. The AGS is referenced in NSGs to filter traffic to and from the frontend VMs.
- ApiBackend ASG - The network interface of the backend VMs are assigned to this ASG. The AGS is referenced in NSGs to filter traffic to and from the frontend VMs.

//TODO: review these rules and add details from the actual implementation

Similar to VNets,  _subnets must be right-sized_. For example, you might want to take advantage of the maximum limit of the VMs supported by Flex orchestration to meet the scaling needs of the application. The workload subnets should be able to hold that limit. Another use case is VM upgrades. You might need temporary IP addresses when a VM is upgraded. 

##### Ingress traffic

**Don't expose the workload VMs directly to the public internet**. Instead, _give each VM a private IP address_.   

In this architecture, two public IP addresses are needed. One for Azure Application Gateway that's used as the reverse proxy. Clients connect using that public IP address. The reverse proxy directs ingress traffic to the private IPs of the VMs.

The other address is for operational access through Azure Bastion (described in [Operational traffic](#operational-traffic)).

Additional security is provided through [Web Application Firewall](/azure/application-gateway/waf-overview) that's integrated with Application Gateway. It has rules that _inspect inbound traffic_ and can take an appropriate action. WAF tracks Open Web Application Security Project (OWASP) vulnerabilities preventing known attacks.  

You'll need a load balancer to _distrubute incoming traffic across all VMs_. Azure Load Balancer is placed between the frontend and the backend to distribute traffic to the backend VMs.


##### Egress traffic

Virtual Machine Scale Sets (VMSS) with Flexible orchestration requires that VM instances to have outbound connectivity for communication over the internet. To enable that use case, here are some approaches:

- **Deploy a NAT Gateway resource attached to the subnet.**

    This option simplifies outbound Internet connectivity. When configured on a subnet, all outbound connectivity uses the NAT gateway's static public IP addresses. NAT Gateway doesn't depend on individual compute instances such as VMs or a single physical gateway device. Software defined networking makes a NAT gateway highly resilient.

    NAT gateway can be deployed and operate out of individual availability zones. A single zonal NAT gateway resource can be configured to subnets that contain virtual machines that span multiple availability zones. If the zone that NAT gateway is deployed in goes down, then outbound connectivity across all virtual machine instances associated with the NAT gateway will also go down. This setup doesn't provide the best method of zone-resiliency.

    To overcome that situation, create a _zonal stack_ per availability zone. This stack consists of VM instances, a NAT gateway resource with public IP addresses or prefix on a subnet all in the same zone (NAT gateway and availability zones - Azure NAT Gateway). Failure of outbound connectivity due to a zone outage is isolated to the affected zone. The outage won't affect the other zonal stacks where other NAT gateways are deployed with their own subnets and zonal public IPs. Creating zonal stacks for each availability zone within a region is the most effective method for building zone-resiliency against outages for NAT gateway.

- **Use a Standard SKU Azure Load Balancer with outbound rules defined from the VM instances.**

    Azure Load Balacer supports zone redundancy. This option allows you to use the public IP(s) of your load balancer to provide outbound internet connectivity for the VMs. The outbound rules allow you to explicitly define SNAT(source network address translation) ports. The rules allow you to scale and tune this ability through manual port allocation. Manually allocating SNAT port based on the backend pool size and number of frontendIPConfigurations can help avoid SNAT exhaustion. 

    It's recommended that you allocate ports based on the maximum number of backend instances. If more instances are added than remaining SNAT ports allowed, VMSS scaling operations might be blocked, or the new VMs won't receive sufficient SNAT ports.

    Calculate ports per instance as: `Number of frontend IPs * 64K / Maximum number of backend instances`

- **Use Azure Firewall or another Network Virtual Appliance (NVA) with a custom User Defined Route (UDR) as the next hop through firewall**.

    This use case is shown in [Infrastructure as a Service (IaaS) baseline in Azure landing zones](./iaas-baseline-landing-zone.yml).

This architecture uses Azure Load Balancer with outbound rules.

##### Operational traffic

**Operational access to the workload VMs should always be secured**. _Azure Bastion is recommended_ for this purpose. Bastion host in the workload VNet provides Remote Desktop Protocol (RDP) and Secure Shell (SSH) access to the workload VMs. This approach can be considered to optimize costs.

However, _provisioning a separate VM as a jumpbox is recommended_. The jumpbox should be placed in a separate subnet in the VNet where the workload resources are provisioned. The operator will access the jumpbox through the Bastion host. Then, log into the VMs behind the load balancer from the jumpbox. 

In either approach, use appropriate NSG rules on the subnets to restrict traffic. For example, in the first approach, subnets for the workload VMs should allow traffic from Bastion. In the second approach, the jumpbox should only receive traffic from Bastion. The workload subnets should allow traffic from that jumpbox. 

You can further harden security through _RBAC permissions with just-in-time (JIT)_, a feature of Microsoft Defender for Cloud. The feature uses NSGs to allow inbound access to the selected ports for a specified amount of time. After that time expires, the ports deny all inbound traffic. For more information about JIT access, see [Understanding just-in-time (JIT) VM access](/azure/defender-for-cloud/just-in-time-access-overview).

##### Private connectivity with PaaS services

Communication between the VMs and other Azure services should be over a private network. Private links are recommended. For this connectivity, you need to create private endpoints to communicate with those services. Private endpoints should be placed in a separate subnet. 

##### DNS resolution

Azure DNS is used as the foundational service for all resolution use cases. For example, resolving fully qualified domain names (FQDN) associated with the workload VMs.

Azure Private DNS zones is used for resolving requests to the private endpoints used to access the named Private link resources.


## Identity and access management

[Azure Active Directory (Azure AD)](/azure/active-directory/) is recommended for authenication of all actors, both users and software components such as services. Use [Azure Role Based Access Control (RBAC)](/azure/role-based-access-control/overview) for authorization of all actors accessing resources, and implementation of the [principle of least privilege](/azure/active-directory/develop/secure-least-privileged-access) when applying roles and permissions to actors. 

In the workload, services will need to communicate with other services. For example, VMs need to reach Key Vault to get certificates. To make sure that access is secure, the service needs to authenticate its identity to the other service. Using managed identity is recommended. Managed identities are based on Azure Active Directory service principals internally, but much easier to use due to the automatic management of the service principal object.

These services in this architecture use [user-assigned managed identities](/azure/active-directory/managed-identities-azure-resources/overview#managed-identity-types). The identities are created and assigned during deployment. 

- **Azure Application Gateway** uses its user-assigned managed identity to access Azure Key Vault and retrieve external and internal TLS certificates. The external certificate is used for encrypting traffic to/from the user, and the internal certificate is used to encrypt traffic to/from the front-end web tier.

- **Front-end web tier and back-end API tier VMs** use their own user-assigned managed identities to access Azure Key Vault and retrieve the internal TLS certificate. The internal certificate is used for encrypting traffic between frontend and backend VMs. VMs also use their managed identity to access the Azure Storage account issued during deployment, which is used to store boot diagnostics.

// It's a good place to add some example of how to continue to use managed identity for extension cases. Like Backend servers would need managed identity for getting secrets from KV for database connection purposes. 

## Secret management

[Azure Key Vault](/azure/key-vault/general/overview) provides secure management of secrets. This architecture uses Key Vault to store the TLS certificates used by the various actors for encrypting and decrypting data in transit between layers. 

The managed identities configured during deployment are used by Application Gateway and the VMs for Key Vault authentication and authorization. Key Vault access policy is configured to allow the managed identities to retrieve the certificate properties. The VMs also use the [Azure Key Vault VM extension](/azure/virtual-machines/extensions/key-vault-linux) for automatic refresh of monitored certificates. If changes are detected in the local certificate store, the extension retrieves and installs the corresponding certificates in Key Vault. The extension supports certificate content types PKCS #12, and PEM. 

> [!IMPORTANT]
> It is your responsibility to ensure your locally stored certificates are rotated regularly. See [Azure Key Vault VM extension for Linux](/azure/virtual-machines/extensions/key-vault-linux) or [Azure Key Vault VM extension for Windows](/azure/virtual-machines/extensions/key-vault-windows) for more details. 

The certificates stored in Key Vault are identified by the following common names:
- **app.contoso.com**: An external certificate used by clients and Application Gateway for secure public Internet traffic
- ***.worload.contoso.com**: A wildcard certificate used by the infrastructure components for secure internal traffic.

It's also a good idea to use Key Vault for storage of secrets used for database encryption. For more information, see [Configure Azure Key Vault Integration for SQL Server on Azure VMs](/azure/azure-sql/virtual-machines/windows/azure-key-vault-integration-configure). We also recommend that you store application secrets, such as database connection strings, in Key Vault.

## Monitoring

:::image type="content" source="./media/iaas-baseline-monitoring.png" alt-text="IaaS monitoring data flow  diagram" lightbox="./media/iaas-baseline-monitoring.png":::

*Download a [Visio file](https://arch-center.azureedge.net/xxx.vsdx) that contains the drawings in this architecture.*

### Overview

Monitoring processes and components are discussed here primarily from a data collection perspective. Where appropriate, the following subsections may provide links to options for data analysis by the respective log and metrics consumption tools. As mentioned previously, Azure Log Analytics workspace is the monitoring data sink used in this architecture to collect logs and metrics from the Azure resources and Application Insights. A Log Analytics workspace is the recommended way to capture all monitoring data in one place, for analyzing and correlation.

Throughout each section, we assume that 2 types of data will be collected from various layers of the architecture that can be useful for diagnosing to understand performance, doing debugging, and many other activities:

- **Metrics:** numerical values that describe an aspect of a system at a particular point in time for specific values being monitored, such as CPU percent, I/O metrics, etc. This type of data can be also useful for making auto scaling configuration decisions.
- **Logs**: recorded system events that capture data over time for the purpose of trend analysis, which can be very useful for debugging and understanding performance. For example, web servers create log files which provide the ability to analyze traffic patterns. 

Monitoring data is generated at multiple levels, all of which can be sources of important metrics and log files: 

- the application level
- the operating system where the application is running
- the underlying infrastructure and components on which your system runs, like virtual machines, virtual networks, and storage services
- the Azure platform logs 

The following sections will cover the services and considerations for collecting monitoring data across all of these levels.

### Azure Monitor 

As mentioned, the two pillars of observability we are interested in are metrics and logs, both of which are collected by Azure Monitor. You define [diagnostic settings in Azure Monitor](/azure/azure-monitor/essentials/diagnostic-settings?tabs=portal#activity-log-settings) to send Azure platform metrics and logs to the Log Analytics Workspace:

- Azure Monitor Metrics is a time-series database, optimized for analyzing time-stamped data. Azure Monitor collects metrics at regular intervals. Metrics are identified with a timestamp, a name, a value, and one or more defining labels. They can be aggregated using algorithms, compared to other metrics, and analyzed for trends over time. 
- Azure Monitor Logs can contain different types of data, be structured or free-form text, and they contain a timestamp. Azure Monitor stores structured and unstructured log data of all types in Azure Monitor logs. 

See [Azure Monitor metrics and logs overview](/azure/azure-monitor/data-platform#observability-data-in-azure-monitor) for a general discussion on observability data, including metrics and logs. See [Azure Monitor metric and log alerts](/azure/azure-monitor/alerts/alerts-overview) for the data source alerts available in Azure Monitor, which can help you proactively address issues before they impact users.

Azure resources also allow you to proactively capture logs and metrics for that service, and subscribe to alerts. The following table links to additional details for the Azure resources included in this reference architecture:

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

For more information on the cost of collecting metrics and logs, see [Log Analytics cost calculations and options](/azure/azure-monitor/logs/cost-logs) and [Pricing for Log Analytics workspace](https://azure.microsoft.com/pricing/details/monitor/). Note that metric and log collection costs are greatly impacted by the nature of the workload, and the frequency and number of metrics and logs collected.

##### Application Insights

[Application Insights](/azure/azure-monitor/app/app-insights-overview) is an extension of Azure Monitor and provides Application Performance Monitoring (also known as "APM") features. APM tools are useful to monitor applications from development, through test, and into production to proactively understand how an application is performing, as well as reactively review application execution data to determine the cause of an incident.

Application Insights enables [distributed tracing](/azure/azure-monitor/app/distributed-tracing-telemetry-correlation#enable-distributed-tracing), providing a performance profiler that works like call stacks for cloud and microservices architectures. Application Insights can monitor each component separately and detect which component is responsible for failures or performance degradation by using distributed telemetry correlation.

Azure Monitor provides two experiences for consuming distributed trace data: the transaction diagnostics view for a single transaction/request and the application map view to show how systems interact.

##### VM insights

[VM insights](/azure/azure-monitor/vm/vminsights-overview) is also a feature of Azure Monitor. It provides a quick and easy method for monitoring the client workloads on your virtual machines and virtual machine scale sets. It displays an inventory of your existing VMs and provides a guided experience to enable base monitoring for them. 

It also monitors the performance and health of your virtual machines and virtual machine scale sets by collecting data on their running processes and dependencies on other resources. You can view trends of performance data, running processes on individual machines, and dependencies between machines. 

To get started, see [Tutorial: Enable monitoring with VM insights for Azure virtual machine](/azure/azure-monitor/vm/tutorial-monitor-vm-enable-insights). Enabling VM insights also installs the Azure Monitoring Agent, as discussed in one of the following sections.

### Azure Load Balancer health probes

The Application Gateway and Azure Load Balancer services require a health probe to detect the endpoint status. The probe is configured by specifying a request protocol, port, and probe interval. The configuration of the health probe and probe responses determines which VM instances receive new connections. When a health probe fails, the load balancer stops sending new connections to the respective unhealthy instance. Outbound connectivity isn't affected, only inbound.

You use health probes to:
- detect the failure of an application and allow the VM to be removed from rotation
- generate a custom response to Azure Load Balancer for more advanced scenarios
- probe for flow control to manage load or planned downtime

In the reference implementation, health probes are configured to do a simple HTTP test for the existence of a file to see if the application is responding. If the request is successful, an HTTP 200 will be returned to Application Gateway or Azure Load Balancer. 

### Managed disks

Your workload will dictate your final metrics to monitor on disks, but most IaaS architectures will have some mix of the following common key metrics. Beyond these, you’ll want to bring in items that represent where your application is most sensitive. 

When designing your monitoring solution be aware that there is an Azure platform perspective on managed disks and there is the Guest OS perspective on the managed disks. The Azure-platform perspective represents the type of metrics that a SAN operator would view, regardless of what workloads are connected. The guest-perspective represents the type of metrics that the workload operator would view, regardless of the underlying disk technology. In Azure, workload teams have the responsibility of monitoring both as part of their solution.

##### Platform perspective

The data disk performance (IOPS and throughput) metrics can be looked at individually (per disk) or rolled up to all disks attached to a VM. Both perspectives can be critical in troubleshooting a potential performance issue, as both the individual disks and the VM can cap total performance. 

To troubleshoot suspected or alert on pending disk capping, use the *Storage IO utilization* metrics, which provide consumed percentage of the provisioned throughput for both virtual machines and disks. If your architecture uses bursting for cost optimization, then you’ll want to monitor your *Credits Percentage* metrics. Running out of credits can be expected result, as consistently having left over credits is a sign that further cost optimization could occur on that disk. Meaning if you are using bursting as part of your cost optimization strategy, you should monitor how many credits you're consistently leaving unused and see if you can choose a lower performance tier.

##### Guest OS perspective

VM Insights is recommended for getting key metrics from an operating system perspective on attached disks. This is where you'll report or alert on disk/drive metrics like *logical disk space used*, and the operating system kernel's own perspective on disk IOPS and throughput. Combining these performance metrics with the platform performance metrics can help isolate OS or even application throughput issues on your disks vs platform bottlenecks.

### Virtual Machines

See [Monitor Azure virtual machines](/azure/virtual-machines/monitor-vm) for description of the monitoring data that's generated by Azure virtual machines (VMs), and a discussion of how to use the features of Azure Monitor to analyze and alert you about this data.

##### Azure Monitor Agent

The [Azure Monitor Agent (AMA)](/azure/azure-monitor/agents/agents-overview) is deployed to VMs to collect monitoring data from the guest operating system. Azure Monitor agent supports [Data Collection Rules (DCR)](/azure/azure-monitor/agents/data-collection-rule-azure-monitor-agent), which enables targeted and granular data collection for a machine or subset(s) of machines. DCR allows filtering rules and data transformations to reduce the overall data volume being uploaded, thus lowering ingestion and storage costs significantly.

The table below lists the types of data you can currently collect with the Azure Monitor Agent and where you can send that data:

| Data source | Destinations | Description |
|:---|:---|:---|
| Performance | Azure Monitor Metrics (Public preview)<sup>1</sup> - Insights.virtualmachine namespace<br>Log Analytics workspace - [Perf](/azure/azure-monitor/reference/tables/perf) table | Numerical values measuring performance of different aspects of operating system and workloads |
| Windows event logs (including sysmon events) | Log Analytics workspace - [Event](/azure/azure-monitor/reference/tables/Event) table | Information sent to the Windows event logging system |
| Syslog | Log Analytics workspace - [Syslog](/azure/azure-monitor/reference/tables/syslog)<sup>2</sup> table | Information sent to the Linux event logging system |
|	Text logs and Windows IIS logs	|	Log Analytics workspace - custom table(s) created manually |	[Collect text logs with Azure Monitor Agent](data-collection-text-log.md)	|

//TODO: consider adding details about the data collection rules implemented in the RI. Highlight differences between the frontend and backend DCR definitions. See tutorials:  
//        [Tutorial: Enable monitoring with VM insights for Azure virtual machine](/azure/azure-monitor/vm/tutorial-monitor-vm-enable-insights)  
//        [Tutorial: Collect guest logs and metrics from Azure virtual machine](/azure/azure-monitor/vm/tutorial-monitor-vm-guest)  

##### Application Health extension

The [Application Health extension](/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-health-extension) is also deployed to the VMs. The Application Health extension is used by VMSS to monitor the binary health state of each VM instance in the scale set, and perform instance repairs if necessary by using Automatic Instance Repairs. The Application Health extension tests for the existence of the same file as the Application Gateway and Azure Load Balancer health probe, to determine if the application is responding.

##### VM Boot diagnostics

[Azure boot diagnostics](/azure/virtual-machines/boot-diagnostics) is a debugging feature for Azure virtual machines (VM) that allows diagnosis of VM boot failures. Boot diagnostics enables a user to observe the state of their VM as it is booting up by collecting serial log information and screenshots. The diagnostics data is saved to a storage account.

//TODO: guidance for RI. Boot diagnostics in managed storage (and transfer later) or using a custom storage account


<!-- Jose's original monitoring contribution 
### Monitoring 

:::image type="content" source="./media/iaas-baseline-monitoring.png" alt-text="IaaS network data flow  diagram" lightbox="./media/iaas-baseline-monitoring.png":::
*Download a [Visio file](https://arch-center.azureedge.net/xxx.vsdx) of this architecture.*

The information that the monitoring process uses comes from several sources: at the application level, the operating system where the application is running, the underlying infrastructure and components on which your system runs, like virtual machines, virtual networks, and storage services; as well as the Azure platform logs can all be sources of important metrics and other diagnostic data.

See [Monitor Azure virtual machines](/azure/virtual-machines/monitor-vm) for description of the monitoring data that's generated by Azure virtual machines (VMs), and a discussion of how to use the features of Azure Monitor to analyze and alert you about this data.

##### VM insights (will we using other insights?)

VM insights is a feature of Azure Monitor that quickly gets you started monitoring your virtual machines. You can view trends of performance data, running processes on individual machines, and dependencies between machines. VM insights installs the [Azure Monitor agent (AMA)](/azure/azure-monitor/agents/agents-overview) to collect monitoring data from the guest operating system. Azure Monitor agent supports [Data Collection Rules (DCR)](/azure/azure-monitor/agents/data-collection-rule-azure-monitor-agent), which enables targeted and granular data collection for a machine or subset(s) of machines. DCR allows filtering rules and data transformations to reduce the overall data volume being uploaded, thus lowering ingestion and storage costs significantly.

###### Data Collection Rules (DCR)

The table below lists the types of data you can currently collect with the Azure Monitor Agent and where you can send that data.

| Data source | Destinations | Description |
|:---|:---|:---|
| Performance | Azure Monitor Metrics (Public preview)<sup>1</sup> - Insights.virtualmachine namespace<br>Log Analytics workspace - [Perf](/azure/azure-monitor/reference/tables/perf) table | Numerical values measuring performance of different aspects of operating system and workloads |
| Windows event logs (including sysmon events) | Log Analytics workspace - [Event](/azure/azure-monitor/reference/tables/Event) table | Information sent to the Windows event logging system |
| Syslog | Log Analytics workspace - [Syslog](/azure/azure-monitor/reference/tables/syslog)<sup>2</sup> table | Information sent to the Linux event logging system |
|	Text logs and Windows IIS logs	|	Log Analytics workspace - custom table(s) created manually |	[Collect text logs with Azure Monitor Agent](data-collection-text-log.md)	|

//TODO: consider adding details about the data collection rules implemented in the RI. Highlight differences between the frontend and backend DCR definitions
//    see tutorails:
//        [Tutorial: Enable monitoring with VM insights for Azure virtual machine](/azure/azure-monitor/vm/tutorial-monitor-vm-enable-insights)
//        [Tutorial: Collect guest logs and metrics from Azure virtual machine](/azure/azure-monitor/vm/tutorial-monitor-vm-guest)

##### VM Boot diagnostics

[Azure boot diagnostics](/azure/virtual-machines/boot-diagnostics) is a debugging feature for Azure virtual machines (VM) that allows diagnosis of VM boot failures. Boot diagnostics enables a user to observe the state of their VM as it is booting up by collecting serial log information and screenshots. The diagnostics data is saved to a storage account.

//TODO: guidance for RI. Boot diagnostics in managed storage (and transfer later) or using a custom storage account

##### Platform logs

[Azure platform logs](/azure/azure-monitor/essentials/platform-logs-overview) provide detailed diagnostic and auditing information for Azure resources and the Azure platform they depend on. Although they're automatically generated, you need to configure certain platform logs to be forwarded to one or more destinations to be retained. You define [diagnostic settings in Azure Monitor](/azure/azure-monitor/essentials/diagnostic-settings?tabs=portal#activity-log-settings) to send Azure platform metrics and logs to the Log Analitycs Workspace.

- [Metrics](/azure/azure-monitor/essentials/metrics-supported). Numerical values that are automatically collected at regular intervals and describe some aspect of a resource at a particular time. Platform metrics are automatically generated and collected in Azure Monitor Metrics.
- [Resource logs](/azure/azure-monitor/essentials/resource-logs). Provide insight into operations that were performed within an Azure resource (the data plane). Operation examples might be getting a secret from a key vault or making a request to a database. Resource logs are generated automatically, but you must create a diagnostic setting to send them to Azure Monitor Logs.
- [Activity log](/azure/azure-monitor/essentials/activity-log?tabs=powershell). Provides insight into the operations on each Azure resource in the subscription from the outside (the management plane) in addition to updates on Service Health events. Use the Activity log to determine the what, who, and when for any write operations (PUT, POST, DELETE) taken on the resources in your subscription. There's a single activity log for each Azure subscription.

##### Workload metrics and instrumentation

[Application Insights](/azure/azure-monitor/app/app-insights-overview) is an extension of Azure Monitor and provides Application Performance Monitoring (also known as "APM") features. APM tools are useful to monitor applications from development, through test, and into production to proactively understand how an application is performing, as well as reactively review application execution data to determine the cause of an incident.

Application Insights enables [distributed tracing](/azure/azure-monitor/app/distributed-tracing-telemetry-correlation#enable-distributed-tracing), providing a performance profiler that works like call stacks for cloud and microservices architectures. Application Insights can monitor each component separately and detect which component is responsible for failures or performance degradation by using distributed telemetry correlation.

Azure Monitor provides two experiences for consuming distributed trace data: the transaction diagnostics view for a single transaction/request and the application map view to show how systems interact.

//TODO: Add app insights guidance specific to this scenario

##### Health probes
##### Platform metrics
##### Logs

##### Log analytic workspace


// Jose's original monitoring contribution -->













***
***

## Dump zone


## Redundancy

#### Redundancy in disks

Managed disks are a regional resource and can only be attached to a virtual machine in the same region. Managed disks can be either LRS or ZRS. For most IaaS architectures, LRS is sufficient for data disks. ZRS is a good candidate for workloads that require lower RTO and RPO options on data disks, but requires a recovery strategy designed to advantage of availability zones and ideally pre-provisioned compute in alternate availability zones ready to recover from a zonal failure. ZRS also introduces an added bit of write latency that should be validated in your workload. Even LRS disks have [zonal failure mitigations](/azure/virtual-machines/disks-redundancy#locally-redundant-storage-for-managed-disks), but only ZRS is capable of achieving zero RPO.

Some specialty workloads, such as SQL Server Always On, can write data to multiple zones. Likewise, custom applications that you write can also follow that strategy and achieving multi-zone redundancy while still using LRS disks. Architecting your IaaS application to take advantage of the flexibility and raw storage access can be a boon for the overall reliability of your workload.

In this architecture, data disks are configured as LRS as no state is persisted locally on any tiers, and the DR playbook for this architecture is redeploy.

- Azure Managed disks themselves do not have a financially backed SLA, no matter what tier is selected. Their availability typically impacts the availability of the virtual machines they are attached to or worse, they do not, but still impact the availability of the workload.

## Scalability

## Patching and updates

## Security

#### Disk encryption

##### Azure disk storage encryption

At the infrastructure level, managed disks, by default are encrypted-at-rest with a platform-managed encryption solution (PMK). Unless your compliance requires an alternative, using this platform-managed encryption is recommended for most architectures. For situations that require the use of customer-managed encryption solutions (CMK) or even double encryption (PMK + CMK), you'll need to introduce a Disk Encryption Set and an Azure Key Vault for your key encryption key (KEK) into the solution architecture as a critical regional component. Disk encryption is applied at the individual disk level, so one virtual machine can support multiple combinations of disk encryption configurations to fit workload requirements. All disk encryption at the platform level is completely transparent to the virtual machine's OS.

Azure disk storage encryption does not encrypt VM temp disks, ephemeral OS disks, disk caches, nor the SAN connection (encryption-at-flow) to disk storage. To extend encryption to the virtual machine's ephemeral disks and the SAN connection, use Encryption at host.

##### Azure disk encryption (ADE)

At the operating system level, there is no default encryption applied. OS-level encryption is provided by solutions such as DM-Crypt on Linux and BitLocker on Windows Server. If your solution absolutely requires OS-level/managed encryption on OS and/or data disks, it is recommended to manage these native OS encryption methods though the ADE virtual machine extension. This scenario is relatively niche and is not covered in the IaaS baseline architecture as it is not a common concern for many architectures.

- PMK is used for server-side encryption, encryption at host nor ADE are enabled.

##### Strategy

Let your security and compliance requirements dictate your disk encryption strategy. Tradeoffs for introducing CMK in Azure disk storage encryption or ADE are additional critical infrastructure components to monitor and manage, additional cost, and potential impact to RTO related to human-error, backups, and failover. Most general-purpose IaaS solutions will find PMK Azure disk storage sufficient; extend to use CMK and/or encryption at host for added broad compliance coverage only when necessary.

## Cost optimization

It's recommended that bursting features of managed disks are considered as part of your SKU selection and cost optimization strategy for IaaS infrastructure. The free bursting credit feature of Premium SSD should be used to achieve desired performance characteristics without the need for excessive over-provisioning.

Balance between disk and VM skus. Don't overprovision either resource because the overall cost will be impacted.

#### Azure reservations

Many IaaS workloads have prolonged expected deployment durations, often years. Ensure your IaaS lifecycle, resource SKUs, and disk needs are available to your cloud FinOps team for inclusion in your organization's pre-purchase reservation scopes.

Resources in this architecture that can benefit from Azure reservations:

- [Azure managed disks](/azure/virtual-machines/disks-reserved-capacity)



##### Zone redundancy

Availability zones are unique physical locations within an Azure region. Each zone is made up of one or more datacenters with independent power, cooling, and networking. The physical separation of availability zones within a region limits the impact to applications and data from zone failures

By replicating VMs across availability zones, you can protect your applications and data from a zone failure. This is how Azure meets the industry-best [VM uptime service-level agreement (SLA)](https://azure.microsoft.com/support/legal/sla/virtual-machines/v1_9). For more information, see [Building solutions for high availability using availability zones](../high-availability/building-solutions-for-high-availability.yml).

##### Update domains

Spreading resources across availability zones also protects an application from planned maintenance. When VMs are distributed across three availability zones, they are, in effect, spread across three update domains. The Azure platform recognizes this distribution across update domains to ensure that VMs in different zones aren't updated at the same time.


### Business continuity and disaster recovery (BCDR)



##### Guidance for PaaS and other components

With zone-redundant services, the distribution of the workload is a feature of the service and is handled by Azure. Azure automatically replicates the resource across zones without requiring your intervention. For example, zone-redundant load balancer, Azure Application Gateway, virtual private network (VPN), zone-redundant storage.

Using Application Gateway or a Standard Load Balancer configured as zone-redundant, traffic can be routed to VMs located across zones with a single IP address, which will survive zone failures. The load frontend IP can be used to reach all (non-impacted) VMs no matter the zone. One or more availability zones can fail and the data path survives as long as one zone in the region remains healthy.

### Compute

#### Virtual Machine Scale Sets with flexible orchestration

In this baseline architecture we are using Virtual Machine Scale Sets (VMSS) with Flexible orchestration to facilitate the operation of virtual machines at cloud scale. Unlike uniform VMSS, with flexible orchestration Azure enables you to allocate and manage VMs individually. You have full control over the virtual machine lifecycle, as well as network interfaces and disks using the standard Azure VM APIs and commands. At the same time, by joining VM to a flexible VMSS, you get an orchestration layer that facilitates achieving high availability at scale with identical or multiple virtual machine types. Flexible orchestration offers high availability guarantees (up to 1000 VMs) by spreading VMs across fault domains in a region or within an Availability Zone. This enables you to scale out your application while maintaining fault domain isolation that is essential to run quorum-based or stateful workloads, including:

##### Scale out with standard Azure virtual machines

Virtual Machine Scale Sets in Flexible Orchestration mode manage standard Azure VMs. You have full control over the virtual machine lifecycle, as well as network interfaces and disks using the standard Azure VM APIs and commands. Individual instances are compatible with the standard Azure IaaS VM API commands, Azure management features such as Azure Resource Manager resource tagging RBAC permissions, Azure Backup, or Azure Site Recovery.


##### Instance naming
When you create a VM and add it to a Flexible scale set, you have full control over instance names within the Azure Naming convention rules. When VMs are automatically added to the scale set via autoscaling, you provide a prefix and Azure appends a unique number to the end of the name.

##### Automatic instance repairs

Enabling automatic instance repairs for Azure Virtual Machine Scale Sets helps achieve high availability for applications by maintaining a set of healthy instances. The Application Health extension or Load balancer health probes may find that an instance is unhealthy. Automatic instance repairs will automatically perform instance repairs by deleting the unhealthy instance and creating a new one to replace it. Automatic instance repair feature relies on health monitoring of individual instances in a scale set. VM instances in a scale set can be configured to emit application health status using either the Application Health extension or Load balancer health probes. If an instance is found to be unhealthy, then the scale set performs repair action by deleting the unhealthy instance and creating a new one to replace it.

*Terminate notification and automatic repairs* If the terminate notification feature is enabled on a scale set, then during automatic repair operation, the deletion of an unhealthy instance follows the terminate notification configuration. A terminate notification is sent through Azure metadata service – scheduled events – and instance deletion is delayed during the configured delay timeout. However, the creation of a new instance to replace the unhealthy one doesn't wait for the delay timeout to complete.



### DevOps

##### OS patching
##### Packaging/publishing workload artifacts
##### Guest OS config

#### Use Infrastructure as Code (IaC)

Choose an idempotent declarative method over an imperative approach, where possible. Instead of writing a sequence of commands that specify configuration options, use declarative syntax that describes the resources and their properties. One option is an [Azure Resource Manager (ARM)](/azure/azure-resource-manager/templates/overview) templates. Another is Terraform.

Make sure as you provision resources as per the governing policies. For example, when selecting the right VM sizes, stay within the cost constraints, availability zone options to match the requirements of your application.

If you need to write a sequence of commands, use [Azure CLI](/cli/azure/what-is-azure-cli). These commands cover a range of Azure services and can be automated through scripting. Azure CLI is supported on Windows and Linux. Another cross-platform option is Azure PowerShell. Your choice will depend on preferred skillset.

Store and version scripts and template files in your source control system.








## Recommendations

The following recommendations apply for most scenarios. Follow these recommendations unless you have a specific requirement that overrides them.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

Availability zones provide high resiliency within a single region. If you need even higher availability, consider replicating the application across two regions. For more information, see [Run an N-tier application in multiple Azure regions for high availability](../reference-architectures/n-tier/multi-region-sql-server.yml).

Not all regions support availability zones, and not all VM sizes are supported in all zones. Run the following Azure CLI command to find the supported zones for each VM size within a region:

```azurecli
az vm list-skus --resource-type virtualMachines --zone false --location eastus -o table
```

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

#### DDoS protection

The Azure platform provides basic DDoS protection by default. This basic protection is targeted at protecting the Azure infrastructure. Although basic DDoS protection is automatically enabled, we recommend using [Azure DDoS Protection](/azure/virtual-network/ddos-protection-overview). DDoS Protection uses adaptive tuning, based on your application's network traffic patterns, to detect threats. This practice allows it to apply mitigations against DDoS attacks that might go unnoticed by the infrastructure-wide DDoS policies. DDoS Protection also provides alerting, telemetry, and analytics through Azure Monitor. For more information, see [Azure DDoS Protection: Best practices and reference architectures](/azure/security/fundamentals/ddos-best-practices).

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

- Data transfers between availability zones in a region are not free. If your workload is multi-region or there are transfers across availability zones, then expect additional bandwidth cost. For more information, see [Traffic across billing zones and regions](/azure/architecture/framework/cost/design-regions?branch=master#traffic-across-billing-zones-and-regions).

- Create budgets to stay within the cost constraints identified by the organization. One way is to create budgets through Azure Cost Management. You can also create alerts to get notifications when certain thresholds are exceeded. For more information, see [Create a budget using a template](/azure/cost-management-billing/costs/quick-create-budget-template).

- [Azure Cost Management](/azure/cost-management-billing/costs/)

#### Virtual Machine Scale Sets

The Virtual Machine Scale Sets resource is available on all Windows VM sizes. You're charged only for the Azure VMs that you deploy, and for any additional underlying infrastructure resources consumed, such as storage and networking. There are no incremental charges for the Virtual Machine Scale Sets service.

For single VMs pricing options, see [Windows VMs pricing](https://azure.microsoft.com/pricing/details/virtual-machines/windows).

#### Load Balancer

You're charged only for the number of configured load-balancing and outbound rules. Inbound NAT rules are free. There's no hourly charge for the standard load balancer when no rules are configured.

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

- Use tags when you create the workload resourcess. Tags are useful in creating custom reports to track the incurred costs. Tags give the ability to track the total of expenses and map any cost to a specific resource or team. Also, if the environment is shared between teams, build chargeback reports per consumer to identify metered costs for shared cloud services.

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).



## Next steps

See product documentation for details on specific Azure services:

- [Azure Virtual Machines](/azure/virtual-machines)
- [Azure Virtual Machine Scale Sets](/azure/virtual-machine-scale-sets/)

## Related resources

IaaS reference architectures showing options for the data tier:

- [IaaS: Web application with relational database](/azure/architecture/high-availability/ref-arch-iaas-web-and-db)
- [Windows N-tier application using SQL Server on Azure](/azure/architecture/reference-architectures/n-tier/n-tier-sql-server)
