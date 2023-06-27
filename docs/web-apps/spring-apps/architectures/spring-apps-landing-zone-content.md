This reference architecture deploys the [**baseline architecture**](spring-apps-multi-zone.yml) in Azure landing zones.

In this scenario, your organization expects the workload to use federated resources managed by central teams (platform), such as networking for on-premises connectivity, identity access management, and policies. This guidance assumes that the organization has adopted Azure landing zones to apply consistent governance and save costs across multiple workloads.


> [!IMPORTANT]
> 
> This reference architecture is part of the [**Azure Spring Apps landing zone accelerator**](/azure/cloud-adoption-framework/scenarios/app-platform/spring-apps/landing-zone-accelerator) guidance. The best practices are intended for a **workload owner** who wants to meet the preceding expectations.
>
> The workload is deployed in an _Azure application landing zone_ subscription provisioned by the organization. As the workload owner, you own the resources in this subscription. 
>
> The workload depends on _Azure platform landing zones_ subscriptions for shared resources. The platform teams own these resources. However, you are accountable for driving requirements with those team so that your workload can function as expected. This guidance annotates those requirements as **Platform team**.
> 
> We highly recommend that you understand the concept of [Azure landing zones](/azure/cloud-adoption-framework/ready/landing-zone/).

The design choices made in this architecture are covered in the key technical design areas for this accelerator. For details, see [**Azure Spring Apps landing zone accelerator**](/azure/cloud-adoption-framework/scenarios/app-platform/spring-apps/landing-zone-accelerator). 

> [!TIP]
> ![GitHub logo](../../../_images/github.svg) The architecture is backed by an [**example implementation**](https://github.com/Azure/azure-spring-apps-landing-zone-accelerator#azure-spring-apps-landing-zone-accelerator) that illustrates some of those choices. The implementation can be used as your first step towards production.


## Architecture

:::image type="content" source="../_images/spring-apps-reference-architecture-landing-zone.svg" alt-text="Diagram that shows an Azure Spring Apps workload in a landing zone." lightbox="../_images/spring-apps-reference-architecture-landing-zone.png":::

Typical uses for this architecture include:

- Private applications: Internal applications deployed in hybrid cloud environments.
- Public applications: Externally facing applications.

The use cases are similar except for their security and network traffic rules. 


### Components

Here are the components of this architecture listed by ownership to help determine your responsibilities and what you share with the platform teams of the organization. For product documentation about Azure services, see [Related resources](#related-resources). 

##### Application team-owned resources

Your team provisions and owns these resources.

- **Azure Spring Apps Standard** hosts your Java Spring Boot applications in Azure. 

- **Azure Application Gateway Standard_v2** is the reverse proxy that routes incoming web traffic to Azure Spring Apps. This SKU has integrated Azure Web Application Firewall (WAF) that inspects traffic for Open Web Application Security Project (OWASP) vulnerabilities.

- **Azure Virtual Machine (VM)** acts as jump box for management operations. 

- **Azure Database for MySQL** stores application data. 

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

The reference implementation includes a sample application that illustrates a typical microservices application hosted in an Azure Spring Apps instance. For more information, see [PetClinic store sample](/azure/spring-apps/quickstart-sample-app-introduction). 

##### Service discovery

In a microservices pattern, service registry capability must be supported for routing user requests and service-to-service communication. 

Services should be able to communicate with other services. When new instances are spawned, they're added to the registry so that they can be dynamically discovered. In this architecture, [Managed Spring Cloud Service Registry (OSS)](/azure/spring-apps/how-to-service-registration) is enabled for Azure Spring Apps. This service maintains a registry of live app instances, enables client-side load-balancing, and decouples service providers from clients without relying on DNS.

Azure Spring Apps implement the [Gateway Routing](/azure/architecture/patterns/gateway-routing) pattern, which that provides a single point of entry for external traffic. The gateway routes incoming requests to the active service instances found in the registry. In this design, the pattern is implemented with open-source implementation of [Spring Cloud Gateway](https://spring.io/projects/spring-cloud-gateway). It offers a feature set that includes authentication/authorization, resiliency features, rate limiting, and others. 

##### Configuration server

For microservices, configuration data must be separated from the code. In this architecture, [Azure Spring Apps Config Server](/azure/spring-apps/how-to-config-server) enables the management of resources and through a pluggable repository that supports local storage and Git repositories.


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

##### Network topology

The platform team decides the network topology. Hub-spoke topology is assumed in this architecture. 

- **Hub virtual network**

    The [Connectivity subscription](/azure/cloud-adoption-framework/ready/azure-best-practices/traditional-azure-networking-topology) contains a hub virtual network shared by the entire organization. It contains [these networking resources](#platform-team-owned-resources) that are owned and maintained by the platform team. These resources are in scope for this architecture:

    - **Azure Firewall** used for controlling outbound traffic to the internet.
    - **Azure Bastion** used to securing access to the management jump box.

- **Spoke virtual network**

    The application landing zone has at least one preprovisioned virtual network that's peered to the hub network. You own the resources in this network. For example, the load balancer that's used to route and protect inbound HTTP/s connections to Azure Spring Apps from the internet.

    The preprovisioned virtual network and peerings must be able to support the expected growth of the workload. Estimate the virtual network size and evaluate the requirements with the platform team regularly. For information, see [Virtual network requirements](/azure/spring-apps/how-to-deploy-in-azure-virtual-network#virtual-network-requirements).

    > [!IMPORTANT]
    > 
    > **Platform team**
    > - Assign the Azure Spring Apps Resource Provider `Owner` rights on the created virtual network.
    > - Provide distinct addresses for virtual networks that participate in peerings. 
    > - Allocate IP address spaces that are large enough to contain the runtime and deployments resources, and support scalability.

##### VNet injection and subnetting

Azure Spring Apps is deployed using [vnet-injection](/azure/spring-apps/how-to-deploy-in-azure-virtual-network) to isolate the application from the Internet, systems in private networks, other Azure services, and even the service runtime. Inbound and outbound traffic from the application is allowed or denied based on network rules. 

Isolation is achieved through subnets. You're responsible for allocating subnets in the spoke virtual network. Azure Spring Apps requires two dedicated subnets for:

- Service runtime
- Spring Boot applications

These subnets must be dedicated to a single Azure Spring Apps instance. Multiple instances can't share the same subnets. 

The minimum size of each subnet is /28. The actual size depends on the number of application instances that Azure Spring Apps can support. For information, see [Using smaller subnet ranges](/azure/spring-apps/how-to-deploy-in-azure-virtual-network#using-smaller-subnet-ranges).

> [!WARNING]
> 
> The selected subnet size can't overlap with the existing virtual network address space, and shouldn't overlap with any peered or on-premises subnet address ranges.


##### Network controls

Inbound traffic to the spoke virtual network from the internet is restricted by Azure Application Gateway with Web Application Firewall (WAF). WAF rules allow or deny  HTTP/s connections. 

Traffic within the network is controlled by using Network security groups (NSGs) on subnets. NSGs filter traffic as per the configured IP addresses and ports. In this design, NSGs are placed on all the subnets. For example, the Bastion subnet allows HTTPS traffic from the internet, gateway services, load balancers, and the virtual network. Only  RDP and SSH communication to the virtual networks is allowed from the subnet.								

Private links are used to control connectivity between Spring Apps and other Azure services, such as access to the Azure Key Vault and the database. The private endpoints are placed in a separate subnet. 

Application host Domain Name Service (DNS) records should be stored in Azure Private DNS to ensure continued availability during a geographic failure.

Even though the Connectivity subscription has private DNS zones, provision your own Azure Private DNS zones for supporting the services are accessed with private endpoints.   

> [!IMPORTANT]
> 
> **Platform team**
>
> - Delegate the Azure Private DNS zones to the application team. 
> - In the hub network, set the DNS servers value to Default (Azure-provided) to support private DNS zones managed by the application team.

Outbound traffic from virtual network must be restricted to prevent data exfiltration attacks. This traffic is routed through the centralized Azure Firewall (next hop) that allows or denies the flow using fully qualified domain name (FQDN).

> [!IMPORTANT]
> 
> **Platform team**
> - Create UDRs for custom routes.
> - Assign Azure policies that will block the application team from creating subnets that don't have the new route table.
> - Give adequate role-based access control (RBAC) permissions to the application team so that they can extend the routes based on the requirements of the workload.


## Identity and access management

The workload's identity implementation must align with the organizational best practices so that the application doesn't violate organizational security or governance boundaries. 

> Refer to [Azure Spring Apps landing zone accelerator: Identity and access management](/azure/cloud-adoption-framework/scenarios/app-platform/spring-apps/identity-and-access-management).

Azure Active Directory (Azure AD) is recommended for authenticating users and services that interact with the Azure Spring Apps instance.

It's recommended that Azure AD managed identities are enabled for the application so that it can authenticate itself to other services. In this architecture, system-assigned managed identities are used for ease of management.  

For authorization, use Azure Role Based Access Control (RBAC) by applying the principle of least privilege when granting permissions.


## Monitoring considerations

The Azure landing zone platform provides shared observability resources as part of the Management subscriptions. However, provisioning your own monitoring resources is recommended to simplify the overall management of the workload. 

> Refer to [Azure Spring Apps landing zone accelerator: Monitor operations](/azure/cloud-adoption-framework/scenarios/app-platform/spring-apps/management).

This architecture provisions these resources:

- Azure Application Insights is the Application Performance Monitoring (APM) and is fully integrated into the service through a Java agent. This agent provides visibility into all the deployed applications and dependencies without requiring extra code. 
- Azure Log Analytics workspace as the unified sink for all logs and metrics collected from Azure services and the application.

Configure Azure Spring Apps instance to send diagnostics logs from the application to the provisioned Log Analytics workspace. For more information, see [Monitor applications end-to-end](/azure/spring-apps/quickstart-monitor-end-to-end-enterprise).

Collect logs and metrics for other Azure services. For example, the jump box has boot diagnostics is enabled so capture events when the virtual machine is booting. 

[Configure diagnostic settings](/azure/azure-monitor/essentials/diagnostic-settings) to send resource logs for all other Azure resources to a Log Analytics workspace. Resource logs aren't collected until they're routed to a destination. Each Azure resource requires its own diagnostic setting.

##### Correlating data from multiple workspaces

Logs and metrics generated by the workload and its infrastructure components are saved in the workload’s Log Analytics workspace. But, logs and metrics generated by centralized services, such as Active Directory and Firewall, are saved to a central Log Analytics workspace managed by platform teams. Correlating data from different sinks can lead to complexities.

Suppose in a user flow, the workload has dependencies on the centralized services. Part of the data might be collected at the workload level and exported to the central Log Analytics workspace where it's correlated with platform logs.

However, other entries might only exist at the workload’s workspace due to issues like data volume, format interoperability, or security constraints. Uncorrelated log entries that exist across two or more workspaces for a single user flow can make it more difficult to troubleshoot some issues, requiring these teams to work together to troubleshoot application incidents.
	
To help with this type of collaboration, familiarize yourself well in advance with the procedures set up by your organization. For example, when a security incident occurs, the workload-level administrators may be asked to review their systems’ logs for signs of malicious activity or provide copies of their logs to incident handlers for further analysis. When workload administrators are troubleshooting application issues, they may need help from platform administrators to correlate log entries from enterprise networking, security, or other platform services.

> [!IMPORTANT]
> 
> **Platform team**
>
> - Grant role-based access control (RBAC) to query and read log sinks for relevant platform resources.
> - Enable logs for AzureFirewallApplicationRule, AzureFirewallNetworkRule, AzureFirewallDnsProxy because the application team needs to monitor traffic flows from the application and requests to the DNS server.
> - Giving the application team enough permission to do their operations.

> Refer to [Azure Spring Apps landing zone accelerator: Monitor operations](/azure/cloud-adoption-framework/scenarios/app-platform/spring-apps/management).

##### Health probes

Azure Application Gateway uses [health probes](/azure/application-gateway/application-gateway-probe-overview) to make sure that incoming traffic is routed to responsive backend instances. 

Azure Spring Apps Readiness, Liveness and Startup probes are recommended. If there's a failure, these probes can help in graceful termination.

For more information, see [How to configure health probes](/azure/spring-apps/how-to-configure-health-probes-graceful-termination).

## Security considerations

The centralized teams provide networking and identity controls as part of the platform. However, the workload should have security affordances to reduce the attack surface.

> Refer to [Azure Spring Apps landing zone accelerator: Security](/azure/cloud-adoption-framework/scenarios/app-platform/spring-apps/security).

##### Data at rest

Data at rest should be encrypted.

The application itself is stateless. Any data is persisted in an external database, in this case Azure Database for MySQL. This service encrypts the data, including backups, and temporary files created while running queries.


##### Data in transit

Data in transit should be encrypted.  

Traffic between the user's browser and Azure Application Gateway must be encrypted to make sure it's not changed in transit. In this architecture, Azure Application Gateway only accepts HTTPS traffic and negotiates TLS handshake. This check is enforced through NSG rules on the Application Gateway subnet. The TLS certificate is loaded directly during deployment. 

Traffic from Application Gateway to the Spring Apps instance is re-encrypted to make sure only secure traffic reaches the application. The Spring Apps runtime receives that traffic and this is the TLS termination point. From here on, inter-service communication within the application and isn't encrypted. However, communication with other Azure PaaS services and the runtime is over TLS.

You can choose to implement [end-to-end TLS communication through Azure Spring Apps](/azure/spring-apps/how-to-enable-ingress-to-app-tls). Consider the tradeoffs.  There might be an impact on latency and operations. 

Data in transit should be inspected for vulnerabilities. 

Web application firewall (WAF) is integrated with Application Gateway and further inspects traffic blocking OWASP vulnerabilities. You can configure WAF to detect, monitor, and log threat alerts. Or, you can set up WAF to blocks intrusions and attacks detected by the rules.


##### DDoS protection

Distributed denial of service (DDoS) can take down a system by overburdening it with requests. 

Basic DDoS Protection is enabled at the infrastructure level for all Azure services to defend against such attacks. Consider upgrading to Azure DDoS Protection Service to take advantage of features such as monitoring, alerts, the ability set thresholds for the application. 

For more information, see [Azure DDoS Protection Service frequently asked questions](/azure/ddos-protection/ddos-faq).


##### Secret management

Microsoft's Zero Trust security approach requires secrets, certificates, and credentials to be stored in a secure vault. The recommended service is Azure Key Vault.

There are alternate ways to store secrets depending on the Azure service and intent. For example, in this architecture:

- Certificates are loaded during deployment. 
- The connection to MySQL is implemented using [Service Connector](/azure/service-connector/quickstart-portal-spring-cloud-connection).


## Cost optimization strategies

Because of the nature of distributed system design, infrastructure sprawl is a reality. This reality results in unexpected and uncontrollable costs. Azure Spring Apps is built using components that scale so that it can meet demand and optimize cost. The foundation of this architecture is the Azure Kubernetes Service (AKS). The service is designed to reduce the complexity and operational overhead of managing Kubernetes, which includes efficiencies in the operational cost of the cluster.

You can deploy different applications and application types to a single instance of Azure Spring Apps. The service supports autoscaling of applications triggered by metrics or schedules that can improve utilization and cost efficiency.

You can also use Application Insights and Azure Monitor to lower operational cost. With the visibility provided by the comprehensive logging solution, you can implement automation to scale the components of the system in real time. You can also analyze log data to reveal inefficiencies in the application code that you can address to improve the overall cost and performance of the system.

## Deploy this scenario

A deployment for this reference architecture is available at [Azure Spring Apps Landing Zone Accelerator](https://github.com/Azure/azure-spring-apps-landing-zone-accelerator#azure-spring-apps-landing-zone-accelerator) on GitHub. 

The artifacts in this repository provide a foundation that you can customize for your environment. The implementation provisions a hub network with shared resources such as Azure Firewall for illustrative purposes. This grouping can be mapped to separate landing zone subscriptions to keep workload and platform functions separate.  

The deployment uses Terraform templates. To deploy the architecture, follow the [step-by-step instructions](https://github.com/Azure/azure-spring-apps-landing-zone-accelerator/tree/main/Scenarios/ASA-Secure-Baseline/Terraform).


## Upgrade to the Enterprise tier

You might want to consider the Azure Spring Apps Enterprise tier, if you want managed VMware Tanzu® support for your live deployments. 

For example, [VMware Tanzu® Service Registry](/azure/spring-apps/how-to-enterprise-service-registry) is integrated for Azure Spring Apps, which allows for service discovery and registration.

For gateway routing, you can switch to [VMware Spring Cloud Gateway](/azure/spring-apps/how-to-use-enterprise-spring-cloud-gateway). It offers a feature set that includes authentication/authorization, resiliency features, rate limiting, and others. 

In the Enterprise tier, [Application Configuration Service for Tanzu®](/azure/spring-apps/how-to-enterprise-application-configuration-service) enables the management of Kubernetes-native ConfigMap resources that are populated from properties defined in one or more Git repositories.

There are other VMware services supported on this tier. For more information, see [Enterprise tier in Azure Marketplace](/azure/spring-apps/how-to-enterprise-marketplace-offer).

The reference implementation supports Azure Spring Apps Enterprise SKU as a deployment option. In this option, there are some  architecture changes. It uses an instance of Azure Database for PostgreSQL flexible server deployed with VNet integration and Azure Cache for Redis with private endpoint. The sample application is [Fitness Store app](/azure/spring-apps/quickstart-sample-app-acme-fitness-store-introduction).

## Related resources

For product documentation on the Azure services used in this architecture, see these articles.

- [Azure Spring Apps Enterprise](/azure/spring-apps/overview#enterprise-plan)
- [Azure Application Gateway v2](/azure/application-gateway/overview-v2)
- [Azure Database for MySQL](/azure/mysql/overview)
- [Azure Key Vault](/azure/key-vault/)
- [Virtual Networks](/azure/virtual-network/)
- [Route tables](/azure/virtual-network/virtual-networks-udr-overview) 

For more scenarios, see these articles.

- [Deploy Azure Spring Apps to multiple regions](spring-apps-multi-region.yml)
- [Expose Azure Spring Apps through a reverse proxy](../guides/spring-cloud-reverse-proxy.yml)
- 
## Next steps

Review the design areas of the [Azure Spring Apps landing zone accelerator](/azure/cloud-adoption-framework/scenarios/app-platform/spring-apps/landing-zone-accelerator).





