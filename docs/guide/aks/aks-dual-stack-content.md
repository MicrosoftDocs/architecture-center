This example baseline infrastructure deploys an Azure Kubernetes Service (AKS) cluster to multiple regions on a dual-stack network by using both IPv4 and IPv6 addresses.

## Architecture

:::image type="content" source="media/dual-stack-inline.png" alt-text="Diagram shows a dual-stack configuration with IPv4 and IPv6 traffic." lightbox="images/dual-stack-expanded.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/aks-dual-stack.vsdx) of this architecture.*

### Dataflow

This example uses a NAT64 proxy for the ingress controller to translate external traffic to either IPv4 or IPv6. It can be added to or removed from an existing infrastructure with minimal changes. Only one ingress needs to be changed.

When clients establish connections to the service, they get service IP addresses from the closest DNS server. They get the IPv6 value from the AAAA record and the IPv4 value from the A record of the domain name. The closest DNS server can be a global DNS server for clients from the internet. For clients inside an Azure virtual network with a custom DNS resolution rule, the closest server can be an Azure private DNS server.

There are two options in this example architecture:

- AKS Services running IPv4
- AKS Services running IPv6

#### AKS Services running IPv4

- **IPv4 traffic** (black line): Azure Load Balancer directs IPv4 traffic to the corresponding services in the virtual network as follows:

  1\. Traffic from the public internet or external network reaches IPv4 on Azure Load Balancer.

  2\. The load balancer forwards traffic to the AKS ingress dedicated for IPv4 traffic.

  3\. The AKS ingress acts as a reverse proxy to direct traffic to a Kubernetes service.

  4\. Each Kubernetes service distributes traffic to its application.

  5\. Applications can securely store and retrieve data to and from Azure storage services in the Azure infrastructure.
  
  6\. Azure Container Registry can quickly and securely deliver application images.

- **IPv6 traffic** (orange line): Load Balancer directs IPv6 traffic as follows:

  1a. IPv6 reaches the IPv6 option on Load Balancer.

  1b. The load balancer forwards traffic to the IPv6 ingress where a NAT64 proxy translates its address. You can use a server like Nginx for this translation.

  1c. The IPv6 ingress directs traffic to IPv4 addresses. It's now IPv4 traffic with more metadata, which includes the IPv6 source address.
  
  2-6. The dataflow from 2 to 6 is the same as in the IPv4 dataflow.

#### AKS Services running IPv6

Alternatively, AKS main traffic can run on top of IPv6, and IPv4 ingress serves as the NAT46 proxy.

### Components

The example consists of the following components:

- **Dual-stack** [Azure Kubernetes Service](https://azure.microsoft.com/products/kubernetes-service) is a managed Kubernetes cluster hosted in the Azure cloud. Azure manages the Kubernetes API service. You only manage the agent nodes. Dual-stack AKS needs to run on a dual-stack Azure Virtual Network.

- **Dual-stack** [Azure Virtual Network](https://azure.microsoft.com/products/virtual-network) provides highly secure virtual network environments on Azure infrastructure. By default, Azure Virtual Network supports IPv4 only. Enable IPv6 during the deployment process.

- [Azure Network Security Group](/azure/virtual-network/network-security-groups-overview) filters traffic between Azure resources in an Azure virtual network.

- [Azure DNS](https://azure.microsoft.com/products/dns) zones provide domain name resolution service for clients. Both IPv4 and IPv6 clients can connect to the same domain name without noticing any difference.

- [Azure Load Balancer](https://azure.microsoft.com/solutions/load-balancing-with-azure) and [Azure network interface](/azure/virtual-network/virtual-network-network-interface) are automatically created by AKS after Kubernetes's ingresses are deployed.

- [Azure Container Registry](https://azure.microsoft.com/products/container-registry) stores private container images that can be run in the AKS cluster.

- [Azure Key Vault](https://azure.microsoft.com/services/key-vault) stores and manages security keys for AKS services.

### Alternatives

Another approach is to separate each functional service. There's one AKS service listening for IPv6 ingress and one AKS service listening for IPv4 ingress. This approach helps avoid a NAT64 hop for IPv6 traffic and vice versa.

This approach seems more like a natural Kubernetes approach that offers better performance. However, if you use this approach in a microservice architecture with lots of services, it doesn't support good code maintenance because each service is duplicated. The main approach can distribute the performance hit by using persistent connections.

When AKS can fully support dual-stack deployment at the service layer, you can remap only IPv6 ingress in the main approach while the alternative approach needs more maintenance.

## Scenario details

Due to IPv4 address exhaustion, IPv6 was introduced in 1995 and became an internet standard in 2017. It's estimated that more than 50 percent of traffic in the United States is over IPv6. The IPv4 and IPv6 protocols aren't compatible. Your infrastructure runs on either an IPv4 network or an IPv6 network. This example workload describes several configurations to run dual-stack networking in the Azure Kubernetes Service. For more information, see [Dual-stack kubenet networking](/azure/aks/configure-kubenet-dual-stack).

Due to current [limitations](/azure/aks/configure-kubenet-dual-stack#expose-the-workload-via-a-loadbalancer-type-service), traffic has to be proxied to the same IP version before processing. Configure ingress as `externalTrafficPolicy: Local`. Once the limitations are addressed, you can create an AKS service that uses the mode `RequireDualStack` or `PreferDualStack`. Each Kubernetes service can handle dual-stack traffic.

After your [Azure Application Gateway](/azure/application-gateway/overview-v2) supports dual-stack networking, an HTTP client can use it in place of a standard load balancer. This configuration benefits from the gateway's [Azure Web Application Firewall](/azure/web-application-firewall/afds/waf-front-door-create-portal) and simplifies the deployment.

This article focuses on enabling dual-stack IP addresses for your network infrastructure. You should be familiar with the [AKS Baseline architecture](/azure/architecture/reference-architectures/containers/aks/baseline-aks), a starting point for AKS infrastructure. The AKS baseline describes features like Azure Active Directory (Azure AD) workload identity, ingress and egress restrictions, resource limits, and other secure AKS infrastructure configurations.

### Potential use cases

IPv6 enables direct node-to-node addressing, which improves connectivity, eases connection management, and reduces routing overhead. These capabilities are useful to enable Internet of Things in the following industries:

- Automotive
- Energy
- Healthcare
- Manufacturing
- Telecommunications

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

The *reliability* of a system is the ability to recover from failures while ensuring system availability.

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

Consider deploying AKS across [availability zones](/azure/aks/availability-zones). This approach helps protect applications against planned maintenance events and unplanned outages.

Azure offers three availability zones for each supported region. Run AKS in at least two of them. If each application has at least two pods across zones, the solution ensures that, if one zone is offline, the other zone still serves end-users without disruption.

If you want better resilience, consider [multi-regions AKS](/azure/architecture/reference-architectures/containers/aks-multi-region/aks-multi-cluster), where each region also supports dual-stack networking.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

Azure provides an [end-to-end security pipeline](/azure/aks/concepts-security) from build to application workloads running AKS.

You can also use [Azure Firewall](/azure/firewall/overview), [Azure Network Security Group](/azure/virtual-network/network-security-groups-overview), and [Azure Web Application Firewall](/azure/web-application-firewall/afds/waf-front-door-create-portal) to enhance network security across network layers.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

Use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate costs.

This AKS architecture with dual-stack networking helps to absorb the cost of handling IPv6 traffic to the existing infrastructure. You can deploy IPv6 ingress on the same AKS without any changes to the current configuration. You don't pay more for the IPv6 traffic handler. This approach has a significant effect when your workloads run in multiple availability zones or multiple regions.

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

Following guidance from the operational excellence pillar, the solution also works as a plugin to existing systems. You can add this solution to support IPv6 traffic or disable it without affecting your existing system. You can also monitor the solution by using the existing mechanism for AKS without managing extra infrastructure components.

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

This solution offers two performance advantages:

- IPv6 traffic and IPv4 traffic share the same computing resources. Resource reuse helps you scale the computing resources instead of dealing with IPv6 and IPv4 resources separately.
- IPv6 and IPv4 ingresses can scale independently, which maximizes performance.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

[Andy Nguyen](https://www.linkedin.com/in/anh-nguyen-37150465) | Senior Software Engineer

Other contributor:

[Senthil Chandran](https://www.linkedin.com/in/senthilchandran) | Principal Software Engineering Manager

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Create, change, or delete a network interface](/azure/virtual-network/virtual-network-network-interface)
- [Introduction to Container registries in Azure](/azure/container-registry/container-registry-intro)
- [Network security groups](/azure/virtual-network/network-security-groups-overview)
- [Overview of DNS zones and records](/azure/dns/dns-zones-records)
- [Protect AKS with Azure Firewall](/azure/firewall/protect-azure-kubernetes-service)
- [Use dual-stack kubenet networking in Azure Kubernetes Service](/azure/aks/configure-kubenet-dual-stack)
- [What is Azure Load Balancer?](/azure/load-balancer/load-balancer-overview)

## Related resources

- [AKS baseline cluster](../../reference-architectures/containers/aks/baseline-aks.yml)
- [Microservices architecture on AKS](../../reference-architectures/containers/aks-microservices/aks-microservices.yml)
- [Advanced microservices on AKS](../../reference-architectures/containers/aks-microservices/aks-microservices-advanced.yml)
- [AKS baseline for multi-region cluster](../../reference-architectures/containers/aks-multi-region/aks-multi-cluster.yml)
- [Build and deploy apps on AKS](../aks/aks-cicd-github-actions-and-gitops.yml)
