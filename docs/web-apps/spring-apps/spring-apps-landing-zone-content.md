
This reference architecture provides guidance for deploying Spring Boot applications as an Azure Spring Apps workload. 

In this scenario, your organization expects the workload to use federated resources managed by central teams (platform), such as networking for on-premises connectivity, identity access management, and policies. This guidance assumes that the organization has adopted Azure landing zones to apply consistent governance and save costs across multiple workloads.

> [!IMPORTANT]
> 
> This reference architecture is part of the [**Azure Spring Apps landing zone accelerator**](/azure/cloud-adoption-framework/scenarios/app-platform/spring-apps/landing-zone-accelerator) guidance. The best practices are intended for a **workload owner** who wants to meet the preceding expectations.
>
> The workload is deployed in an _Azure application landing zone_ subscription provisioned by the organization. As the workload owner, you own the resources in this subscription. 
>
> The workload depends on _Azure platform landing zones_ subscriptions for shared resources. The platform teams own these resources. However, you are accountable for driving requirements with those team so that workload can function as expected. This guidance annotates those requirements as **Platform team**.
> 
> We highly recommend that you understand the concept of [Azure landing zones](/azure/cloud-adoption-framework/ready/landing-zone/).

The design choices made in this architecture are covered in the key technical design areas for this accelerator. For details, see [**Azure Spring Apps landing zone accelerator**](/azure/cloud-adoption-framework/scenarios/app-platform/spring-apps/landing-zone-accelerator). 

> [!TIP]
> ![GitHub logo](../../_images/github.svg) The architecture is backed by an [**example implementation**](https://github.com/Azure/azure-spring-apps-landing-zone-accelerator#azure-spring-apps-landing-zone-accelerator) that illustrates some of those choices. The implementation can be used as your first step towards production.


## Architecture

:::image type="content" source="./_images/spring-apps-reference-architecture-landing-zone.svg" alt-text="Diagram that shows an Azure Spring Apps workload in a landing zone." lightbox="./_images/spring-apps-reference-architecture-landing-zone.png":::

Typical uses for this architecture include:

- Private applications: Internal applications deployed in hybrid cloud environments.
- Public applications: Externally facing applications.

The use cases are similar except for their security and network traffic rules. This architecture is designed to support the nuances of each.

### Components

Here are the components of this architecture listed by ownership to help determine your responsibilities and that you share with the platform teams of the organization. For product documentation about Azure services, see [Related resources](#related-resources). 

##### Application team-owned resources

Your team provisions and owns these resources.

- **Azure Spring Apps Enterprise** hosts your Java Spring Boot applications in Azure. This tier is composed of the VMware Tanzu® Build Service™, Application Configuration Service for VMware Tanzu®, VMware Tanzu® Service Registry, Spring Cloud Gateway for VMware Tanzu®, and API portal for VMware Tanzu®. 

- **Azure Application Gateway Standard_v2** is the load balancer that distributes incoming web traffic. This SKU has integrated Azure Web Application Firewall (WAF) that inspects traffic for Open Web Application Security Project (OWASP) vulnerabilities.

- **Azure Virtual Machine (VM)** acts as jump box for management operations. 

- **Azure Database for PostGres** stores application data. 

- **Azure Key Vault** stores secrets and configuration, such as connection string to the database. 

- **Azure Log Analytics** is the monitoring sink that stores logs and metrics from the application and the Azure services.

- **Azure Application Insights** is used as an Application Performance Management (APM) tool to collect all application monitoring data and store it directly within Log Analytics.

##### Platform team-owned resources

This architecture assumes these resources are preprovisioned. The central teams of the organization own and maintain the resources. Your application depends on these services to reduce operational overhead and optimize cost.

- **Azure Firewall** inspects and restricts egress traffic.

- **Azure Bastion** provides secure access to the management jump box.

- **Azure ExpressRoute** provides private connectivity from on-premises to Azure infrastructure.

- **Azure DNS** provides cross-premises name resolution.

- **VPN gateway**	connects the application with remote teams in your on-premises network.

## Application considerations

The reference implementation includes a sample application that illustrates a typical microservices application hosted in an Azure Spring Apps instance. For more information, see [Fitness store sample](/azure/spring-apps/quickstart-sample-app-acme-fitness-store-introduction). 

##### Service discovery

In a microservices pattern, service registry capability must be supported for routing and service-to-service communication. 

Services should be able to communicate with other services. When new instances are spawned, they are added to the registry so that they can be dynamically discovered. In this architecture, [VMware Tanzu® Service Registry](/azure/spring-apps/how-to-enterprise-service-registry) is enabled for Azure Spring Apps. 

Most microservices need [Gateway Routing](/azure/architecture/patterns/gateway-routing) that provides a single point of entry for external traffic. The gateway routes incoming requests to the active service instances found in the registry. In this design, [Spring Cloud Gateway](/azure/spring-apps/how-to-use-enterprise-spring-cloud-gateway) was chosen. It offers a feature set that includes authentication/authorization, resiliency features, rate limiting, and others. 

##### Configuration server

For microservices, configuration data must be separated from the code. In this architecture, because the Enterprise tier was chosen, such data is stored externally as native Kubernetes ConfigMap resources and accessed by [Application Configuration Service for Tanzu](/azure/spring-apps/how-to-enterprise-application-configuration-service).  

##### Load balancing
TBD

##### Redundancy

You can use availability zones when creating an Azure Spring Apps service instance. 

With this feature, Azure Spring Apps automatically distributes fundamental resources across logical sections of underlying Azure infrastructure. This distribution provides a higher level of availability and protects against hardware failures or planned maintenance events.

Zone redundancy ensures that underlying VM nodes are distributed evenly across all availability zones but doesn't guarantee even distribution of app instances. If an app instance fails because its located zone goes down, Azure Spring Apps creates a new app instance for this app on a node in another availability zone.

If you enable your own resource in Azure Spring Apps, such as your own persistent storage, enable zone redundancy for the resource. For more information, see [How to enable your own persistent storage in Azure Spring Apps](/azure/spring-apps/how-to-custom-persistent-storage-with-standard-consumption).

Availability zones aren't supported in all regions. To see which regions support availability zones, see [Azure regions with availability zone support](/azure/reliability/availability-zones-service-support#azure-regions-with-availability-zone-support).


##### Scalability

Azure Spring Apps provides [autoscaling](/azure/spring-apps/how-to-setup-autoscale) capabilities out of the box, allowing apps to scale based on metric thresholds or during a specific time window. Autoscaling is recommended when apps need to scale up or scale out in response to changing demand.

Azure Spring Apps also supports scaling your applications [manually](/azure/spring-apps/how-to-scale-manual) using CPU, Memory/GB per instance and App instance counts. This type of scaling is suitable for one time scaling activity that you may want to perform for certain apps. Ensure you adjust these parameters based on your application's scaling needs while also understanding the maximum limits supported by each of these attributes. 

> [!IMPORTANT] 
> This feature is different from the [manual scale](https://learn.microsoft.com/en-us/azure/spring-apps/how-to-setup-autoscale#set-up-autoscale-settings-for-your-application-in-the-azure-portal) option that is available as part of the auto scale setting.

## Networking considerations

In this design, the workload is dependent on resources owned by the platform team for accessing on-premises resources, controlling egress traffic, and so on.

> Refer to [Azure Spring Apps landing zone accelerator: Network topology and connectivity](/azure/cloud-adoption-framework/scenarios/app-platform/spring-apps/network-topology-and-connectivity).

### Network topology

The platform team decides the network topology. Hub-spoke topology is assumed in this architecture. 

- **Hub virtual network**

    The [Connectivity subscription](/azure/cloud-adoption-framework/ready/azure-best-practices/connectivity-to-azure) contains a hub virtual network shared by the entire organization. It contains [these networking resources](#platform-team-owned-resources) that are owned and maintained by the platform team. These resources are in scope for this architecture:

    - **Azure Firewall** used for controlling outbound traffic to the internet.
    - **Azure Bastion** used to securing access to the management jump box.

- **Spoke virtual network**

    The application landing zone has at least one preprovisioned virtual network that's peered to the hub network. You own these resources in this network. For example, the load balancer that's used to route and protect inbound HTTP/s connections to Azure Spring Apps from the internet.

    The preprovisioned virtual network and peerings must be able to support the expected growth of the workload. Estimate the virtual network size and evaluate the requirements with the platform team regularly. For information, see [Virtual network requirements](/azure/spring-apps/how-to-deploy-in-azure-virtual-network#virtual-network-requirements).

    > [!IMPORTANT]
    > 
    > **Platform team**
    > - Assign the Azure Spring Apps Resource Provider `Owner` rights on the created virtual network
    > - Provide distinct addresses for virtual networks that participate in peerings. 
    > - Allocate IP address spaces that are large enough to contain the runtime and deployments resources, and support scalability.

### VNet injection and subnetting

Azure Spring Apps is deployed using [vnet-injection](/azure/spring-apps/how-to-deploy-in-azure-virtual-network) to isolate the application from the Internet, systems in private networks, other Azure services, and even the service runtime. Inbound and outbound traffic from the application is allowed or denied based on network rules. 

Isolation is achieved through subnets. You're responsible for allocating subnets in the spoke virtual network. Azure Spring Apps requires two dedicated subnets:

- Service runtime
- Spring Boot applications

Each subnet requires a dedicated Azure Spring Apps cluster. Multiple clusters can't share the same subnets. 

The minimum size of each subnet is /28. The actual size depends on the number of application instances that Azure Spring Apps can support. For information, see [Using smaller subnet ranges](/azure/spring-apps/how-to-deploy-in-azure-virtual-network#using-smaller-subnet-ranges).

> [!WARNING]
> 
> The selected subnet size can't overlap with the existing virtual network address space, and shouldn't overlap with any peered or on-premises subnet address ranges.



### Network controls

Inbound traffic to the spoke virtual network from the internet is restricted by Azure Application Gateway with Web Application Firewall (WAF). WAF rules allow or deny  HTTP/s connections. 

Traffic within the network is controlled by using Network security groups (NSGs) on subnets. NSGs filter traffic as per the configured IP addresses and ports. In this design, NSGs are placed on all the subnets.

//TODO: Validate NSG configuration against the codebase

Private endpoints are used to control public connectivity to all Azure services, such as access to the Azure Key Vault and the database. Even though the Connectivity subscription has private DNS zones, provision your own Azure Private DNS zones for supporting the services are accessed with private endpoints.   

> [!IMPORTANT]
> 
> **Platform team**
>
> - Delegate the Azure Private DNS zones to the application team. 
>
> - In the hub network, set the DNS servers value to Default (Azure-provided) to support private DNS zones managed by the application team.

Outbound traffic from virtual network must be restricted to prevent data exfiltration attacks. This traffic is routed through the centralized Azure Firewall (next hop) that allows or denies the flow using fully qualified domain name (FQDN).

> [!IMPORTANT]
> 
> **Platform team**
> - Create UDRs for custom routes.
> - Assign Azure policies that will block the application team from creating subnets that don't have the new route table.
> - Give adequate role-based access control (RBAC) permissions to the application team so that they can extend the routes based on the requirements of the workload.


## Identity and access management

TBD

## Monitoring considerations

The Azure landing zone platform provides shared observability resources as part of the Management subscriptions. However, provisioning your own resources is recommended to simplify the overall management of the workload. 

This architecture provisions these monitoring resources:

- Azure Application Insights to collect all application monitoring data.
- Azure Log Analytics workspace as the unified sink for all logs and metrics collected from Azure services and the application.

Configure Azure Spring Apps instance to send diagnostics logs from the application to the provisioned Log Analytics workspace. For more information, see [Monitor applications end-to-end](/azure/spring-apps/quickstart-monitor-end-to-end-enterprise).

Collect logs and metrics for other Azure services. For example, the jump box has boot diagnostics is enabled so capture events when the virtual machine is booting. 

Work with the platform team to configure Azure Firewall such that logs and metrics related to your workload are sent to your Log Analytics workspace. 

**Platform team**

- Grant role-based access control (RBAC) to query and read log sinks for relevant platform resources.
- Enable logs for AzureFirewallApplicationRule, AzureFirewallNetworkRule, AzureFirewallDnsProxy because the application team needs to monitor traffic flows from the application and requests to the DNS server.
- Giving the application team enough permission to do their operations.

> Refer to [Azure Spring Apps landing zone accelerator: Monitor operations](/azure/cloud-adoption-framework/scenarios/app-platform/spring-apps/management).

##### Health probes

//TODO: Health probes configured?

## Security considerations

TBD

## Cost optimization strategies

TBD

## Deploy this scenario

A deployment for this reference architecture is available at [Azure Spring Apps Landing Zone Accelerator](https://github.com/Azure/azure-spring-apps-landing-zone-accelerator#azure-spring-apps-landing-zone-accelerator) on GitHub. The deployment uses Terraform templates. To deploy the architecture, follow the [step-by-step instructions](https://github.com/Azure/azure-spring-apps-landing-zone-accelerator/tree/main/Scenarios/ASA-Secure-Baseline/Terraform).


## Related resources

For product documentation on the Azure services used in this architecture, see these articles.

- [Azure Spring Apps Enterprise](/azure/spring-apps/overview#enterprise-plan)
- [Azure Application Gateway v2](/azure/application-gateway/overview-v2)
- [Azure Database for MySQL](/azure/mysql/overview)
- [Azure Key Vault](/azure/key-vault/)
- [Virtual Networks](/azure/virtual-network/)
- [Route tables](/azure/virtual-network/virtual-networks-udr-overview) 


## Next steps

Review the design areas of the [Azure Spring Apps landing zone accelerator](/azure/cloud-adoption-framework/scenarios/app-platform/spring-apps/landing-zone-accelerator).

## Related resources

- [Deploy Azure Spring Apps to multiple regions](spring-apps-multi-region.yml)
- [Expose Azure Spring Apps through a reverse proxy](spring-cloud-reverse-proxy.yml)

