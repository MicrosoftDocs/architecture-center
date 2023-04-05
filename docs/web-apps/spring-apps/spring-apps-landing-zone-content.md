
This reference architecture provides guidance for deploying Spring Boot applications as an Azure Spring Apps workload. 

In this scenario, your organization expects the workload to use federated resources managed by central teams (platform), such as networking for on-premises connectivity, identity access management, and policies. This guidance assumes that the organization has adopted Azure landing zones to apply consistent governance and save costs across multiple workloads.

> [!IMPORTANT]
> 
> This reference architecture is part of the [**Azure Spring Apps landing zone accelerator**](/azure/cloud-adoption-framework/scenarios/app-platform/spring-apps/landing-zone-accelerator) guidance. The best practices are intended for a **workload owner** who wants to meet the preceding expectations.
>
> The workload is deployed in an _Azure application landing zone_ subscription provisioned by the organization. As the workload owner, you own resources in this subscription. 
>
> The workload is dependent on _Azure platform landing zones_ subscriptions for shared resources. The platform teams own these resources. However, you are accountable for driving requirements with those team so that workload can function as expected. This guidance annotates those requirements as **Platform team**.
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
<<TBD: Why was this tier chosen?-- Provide some enterprise-y justifications.>>

- **Azure Application Gateway Standard_v2** is the load balancer that distributes incoming web traffic. This SKU has integrated Azure Web Application Firewall (WAF) that inspects traffic for Open Web Application Security Project (OWASP) vulnerabilities.

- **Azure Virtual Machine (VM)** acts as jump box for management operations. 

- **Azure Database for MySQL** stores application data. 
<<TBD: Why is the database in a separate scenario with the application? Also why is PostGres mentioned in the image?>>

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

TBD

## Networking considerations

In this design, the workload is dependent on federated resources in the platform landing zone for accessing on-premises resources, controlling egress traffic, and so on.

### Network topology

The platform team decides the network topology for the entire organization. Hub-spoke topology is assumed in this architecture. 

- **Hub virtual network**

    The [Connectivity subscription](/azure/cloud-adoption-framework/ready/azure-best-practices/connectivity-to-azure) contains a hub virtual network shared by the entire organization. It contains [these networking resources](#platform-team-owned-resources) that are owned and maintained by the platform team. These resources are in scope for this architecture:

    - **Azure Firewall** used for controlling outbound traffic to the internet.
    - **Azure Bastion** used to securing access to the management jump box.

- **Spoke virtual network**

    The application landing zone has at least a preprovisioned virtual network. You own these resources in this network. are owned and maintained by the platform team. For example, the load balancer that's used to route and protect inbound HTTP/s connections to Azure Spring Apps from the internet.

    The preprovisioned virtual network and peerings must be able to support the expected growth of the workload. Estimate the size needed to run your workload and evaluate the requirements with the platform team regularly. For information, see [Virtual network requirements](/azure/spring-apps/how-to-deploy-in-azure-virtual-network#virtual-network-requirements).

    > [!IMPORTANT]
    > 
    > **Platform team**
    >
    > - Provide distinct addresses for virtual networks that participate in peerings. 
    >
    > - Allocate IP address spaces that are large enough to contain the runtime and deployments resources, and support scalability.

### VNet injection and subnetting

Azure Spring Apps is deployed using [vnet-injection](/azure/spring-apps/how-to-deploy-in-azure-virtual-network) to isolate the application from systems in private networks, other Azure services, and even the service runtime. Inbound and outbound traffic from the application is allowed or denied based on network rules. 

Isolation is achieved through subnets. You're responsible for allocating subnets in the virtual network. Azure Spring Apps requires two dedicated subnets:

- Service runtime
- Spring Boot applications

Each subnet requires a dedicated Azure Spring Apps cluster. Multiple clusters can't share the same subnets. 

The minimum size of each subnet is /28. The actual size depends on the number of application instances that Azure Spring Apps can support. For information, see [Using smaller subnet ranges](/azure/spring-apps/how-to-deploy-in-azure-virtual-network#using-smaller-subnet-ranges).

> [!WARNING]
> 
> The selected subnet size can't overlap with the existing virtual network address space, and shouldn't overlap with any peered or on-premises subnet address ranges.

### Load balancing
TBD

### Network controls

Inbound traffic to the spoke virtual network from the internet is restricted by Azure Application Gateway with Web Application Firewall (WAF). WAF rules are allow or deny  HTTP/s connections. 

Traffic within the network is controlled by using Network security groups (NSGs) on subnets. NSGs filter traffic as per the configured IP addresses and ports. In this design, NSGs are placed on all subnets.

All public connectivity to Azure services are controlled by using private endpoints, such as access to the Azure Key Vault and the database. Even though the Connectivity subscription has private DNS zones, provision your own Azure Private DNS zones for supporting the services are accessed with private endpoints.   

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
>
> - Create UDRs for custom routes.
> - Assign Azure policies that will block the application team from creating subnets that don't have the new route table.
> - Give adequate role-based access control (RBAC) permissions to the application team so that they can extend the routes based on the requirements of the workload.


## Identity and access management

TBD

## Monitoring considerations

TBD

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

