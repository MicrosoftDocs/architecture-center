This article describes how to expose and protect a workload that runs in Azure Kubernetes Service (AKS) by using Azure Front Door, Azure Web Application Firewall, and an Azure Private Link service in a more secure manner. This architecture uses the NGINX ingress controller to expose a web application. The NGINX ingress controller is configured to use a private IP address as a front-end IP configuration of the AKS internal load balancer. The deployment provides end-to-end Transport Layer Security (TLS) encryption.

## Architecture

:::image type="complex" border="false" source="./media/aks-front-door.svg" alt-text="Diagram that shows an architecture that securely exposes and protects a workload that runs in AKS." lightbox="./media/aks-front-door.svg":::
   The image is a complex architectural diagram of a Microsoft Azure-based network infrastructure. It's divided into multiple sections that have various components connected by arrows that indicate data flow or connections. One section contains an icon that represents administrators, platform engineers, and developers that connects to an icon that represents a public IP address. This icon then connects to Azure Bastion host. An icon that represents application users connects via HTTPS to Azure Front Door, to Private Link service, to the internal load balancer icon, to the Ingress-basic icon, and finally to httpbin-tls. This section also has icons that represent Azure DNS zone and Web Application Firewall policy. Another section contains a map key of the icons for monitoring, Secure Socket Shell traffic, HTTP/S traffic, outbound traffic, private connections, and virtual network link. A section labeled Private DNS zones contains icons for Private DNS zones that are linked to specific domain names and has a dotted line that connects from a box labeled Virtual network 10.0.0.0/8. Icons that represent Kubernetes monitoring, Azure Managed Grafana, and Monitor workspace point to a large dashed box labeled Virtual network 10.0.0.0/8. This box contains six smaller dashed boxes. The first box, labeled Azure Bastion Host 10.243.2.0/24, contains an icon that represents the Azure Bastion service. The second box, labeled ApiServerSubnet10.243.0.0/27, contains an icon that represents the API server. The third box, labeled UserSubnet10.241.0.0/16, contains an icon that represents the user agent pool. The user agent pool icon points to an icon that represents Azure NAT Gateway. The fourth box, labeled Private Link service, contains icons that represent the jump box virtual machine and private endpoints. The private endpoints icon points to icons that represent the storage account, Key Vault, and Azure Container Registry. The fifth box, labeled SystemSubnet10.240.0.0/16, contains icons that represent the internal load balancer and the system agent pool. The internal load balancer points to an icon that represents Azure NAT Gateway. A dotted arrow points to an icon that represents a public IP address which then points to an icon that represents the internet. The sixth box, labeled PodSubnet10.242.0.0/16, contains icons that represent ingress-basic, httpbin-tls, and kube-system. A dotted line connects this box to the UserSubnet box and to the Azure NAT Gateway icon.
:::image-end:::

*The Grafana logo is a trademark of its respective company. No endorsement is implied by the use of this mark.*

*Download a [Visio file](https://arch-center.azureedge.net/aks-front-door.vsdx) of this architecture.*

### Workflow

The following diagram shows the steps for the message flow during deployment and runtime.

:::image type="complex" border="false" source="./media/flow.svg" alt-text="Diagram that shows the steps for the message flow during deployment and runtime." lightbox="./media/flow.svg":::
   The diagram has five primary sections. The top section isn't enclosed. The bottom four sections are enclosed in dotted rectangles. Those four rectangles are enclosed in a dotted rectangle that's labeled AksVnet 10.0.0.0/8. The top section has a logo that represents administrators and platform engineers. An arrow points from this logo to the logo that represents Azure Key Vault to indicate that a certificate for the custom domain store.test.com is generated and saved in an Azure key vault. In step two, an arrow points from the administrator and platform engineer logo to the AksVnet 10.0.0.0/8 section to indicate that a platform engineer specifies the necessary information in the main.bicepparams Bicep parameters file and deploys the Bicep modules to create the Azure resources. In step three, an arrow labeled SecretProviderClass and Secrets Store CSI Driver points to the logo that represents the TLS secret. In step four, this section shows an arrow from the digital certificate to Azure Front Door store.test.com to indicate that it reached its destination.
:::image-end:::

#### Deployment workflow

You can use one of the following methods to deploy the [NGINX ingress controller](https://docs.nginx.com/nginx-ingress-controller/intro/overview/):

- **Managed NGINX ingress controller:** Deploy a managed NGINX ingress controller by using the [application routing add-on for AKS](/azure/aks/app-routing). The deployment configures the managed NGINX ingress controller to use a private IP address as a front-end IP address configuration of the `kubernetes-internal` internal load balancer. For more information, see [Configure NGINX ingress controller to support Azure private DNS zone with application routing add-on](/azure/aks/create-nginx-ingress-private-controller).

- **Unmanaged NGINX ingress controller:** Install an unmanaged NGINX ingress controller via Helm. The deployment script configures the unmanaged NGINX ingress controller to use a private IP address as a front-end IP address configuration of the `kubernetes-internal` internal load balancer. For more information, see [Create an ingress controller by using an internal IP address](/azure/aks/ingress-basic#create-an-ingress-controller-using-an-internal-ip-address).

The following workflow corresponds to the previous diagram:

1. A security engineer generates a certificate for the custom domain that the workload uses and saves it in an Azure key vault. You can obtain a valid certificate from a well-known [certification authority](https://en.wikipedia.org/wiki/Certificate_authority).

1. A platform engineer specifies the necessary information in the `main.bicepparams` Bicep parameters file and deploys the Bicep modules to create the Azure resources. The necessary information includes:

   - A prefix for the Azure resources.

   - The name and resource group of the existing key vault that holds the TLS certificate for the workload hostname and the Azure Front Door custom domain.

   - The name of the certificate in the key vault.

   - The name and resource group of the DNS zone that's used to resolve the Azure Front Door custom domain.

1. The [deployment script](/azure/azure-resource-manager/bicep/deployment-script-bicep) creates the following objects in the AKS cluster:

   - The [NGINX ingress controller](https://docs.nginx.com/nginx-ingress-controller/intro/overview/) via Helm if you use an unmanaged NGINX ingress controller.

   - A Kubernetes [deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) and [service](https://kubernetes.io/docs/concepts/services-networking/service/) for the sample [httpbin](https://httpbin.org/) web application.

   - A Kubernetes [ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) object to expose the web application via the NGINX ingress controller.

   - A [SecretProviderClass](/azure/aks/aksarc/secrets-store-csi-driver) custom resource that retrieves the TLS certificate from the specified key vault by using the user-defined managed identity of the [Key Vault provider for Secrets Store CSI Driver](/azure/aks/csi-secrets-store-driver). This component creates a Kubernetes secret that contains the TLS certificate that the ingress object references.

1. An Azure Front Door [secret resource](/azure/templates/microsoft.cdn/profiles/secrets) is used to manage and store the TLS certificate that's in the key vault. This certificate is used by the [custom domain](/azure/templates/microsoft.cdn/profiles/customdomains) that's associated with the Azure Front Door endpoint. The Azure Front Door profile uses a user-assigned managed identity with the *Key Vault Administrator* role assignment to retrieve the TLS certificate from Key Vault.

> [!NOTE]
> At the end of the deployment, you need to approve the private endpoint connection before traffic can pass to the origin privately. For more information, see [Secure your origin with Private Link in Azure Front Door Premium](/azure/frontdoor/private-link). To approve private endpoint connections, use the Azure portal, the Azure CLI, or Azure PowerShell. For more information, see [Manage a private endpoint connection](/azure/private-link/manage-private-endpoint).

#### Runtime workflow

The following steps describe the message flow for a request that an external client application initiates during runtime. This workflow corresponds to the orange numbers in the previous diagram.

1. The client application uses its custom domain to send a request to the web application. The DNS zone that's associated with the custom domain uses a [CNAME record](https://en.wikipedia.org/wiki/CNAME_record) to redirect the DNS query for the custom domain to the original hostname of the Azure Front Door endpoint.

1. Azure Front Door traffic routing occurs in several stages. Initially, the request is sent to one of the [Azure Front Door points of presence](/azure/frontdoor/edge-locations-by-region). Then Azure Front Door uses the configuration to determine the appropriate destination for the traffic. Various factors can influence the routing process, such as the Azure Front Door caching, web application firewall (WAF), routing rules, rules engine, and caching configuration. For more information, see [Routing architecture overview](/azure/frontdoor/front-door-routing-architecture).

1. Azure Front Door forwards the incoming request to the [Azure private endpoint](/azure/private-link/private-endpoint-overview) that's connected to the [Private Link service](/azure/private-link/private-link-service-overview) that exposes the AKS-hosted workload.

1. The request is sent to the Private Link service.

1. The request is forwarded to the *kubernetes-internal* AKS internal load balancer.

1. The request is sent to one of the agent nodes that hosts a pod of the managed or unmanaged NGINX ingress controller.

1. One of the NGINX ingress controller replicas handles the request.

1. The NGINX ingress controller forwards the request to one of the workload pods.

### Components

- A public or private [AKS cluster](https://azure.microsoft.com/services/kubernetes-service) is composed of the following node pools:

  - A *system node pool* in a dedicated subnet. The default node pool hosts only critical system pods and services. The system nodes have a node taint, so application pods can't be scheduled on this node pool.

  - A *user node pool* that hosts user workloads and artifacts in a dedicated subnet.

- The deployment requires [Azure role-based access control (Azure RBAC) role assignments](/azure/role-based-access-control/role-assignments), which include:

  - A *Grafana Admin* role assignment on Azure Managed Grafana for the Microsoft Entra user whose `objectID` is defined in the `userId` parameter. The *Grafana Admin* role grants full control over the instance. This control includes managing role assignments and viewing, editing, and configuring data sources. For more information, see [How to share access to Azure Managed Grafana](/azure/managed-grafana/how-to-share-grafana-workspace).

  - A *Key Vault Administrator* role assignment on the existing Key Vault resource that contains the TLS certificate for the user-defined managed identity that the [Key Vault provider for Secrets Store CSI Driver](/azure/aks/csi-secrets-store-driver) uses. This assignment provides access to the CSI driver so that it can read the certificate from the source key vault.

- [Azure Front Door Premium](/azure/frontdoor/front-door-overview) is a Layer-7 global load balancer and modern cloud content delivery network. It provides fast, reliable, and enhanced security access between your users' and your applications' static and dynamic web content across the globe. You can use Azure Front Door to deliver your content by using the Microsoft global edge network. The network has hundreds of [global and local points of presence](/azure/frontdoor/edge-locations-by-region) distributed around the world. So you can use points of presence that are close to your enterprise and consumer customers. 

   In this solution, Azure Front Door is used to expose an AKS-hosted sample web application via a [Private Link service](/azure/private-link/private-link-service-overview) and the [NGINX ingress controller](https://docs.nginx.com/nginx-ingress-controller/intro/overview/). Azure Front Door is configured to expose a custom domain for the Azure Front Door endpoint. The custom domain is configured to use the Azure Front Door secret that contains a TLS certificate that's read from [Key Vault](/azure/key-vault/general/overview).

- [Azure Web Application Firewall](/azure/web-application-firewall/afds/afds-overview) protects the AKS-hosted applications that are exposed via [Azure Front Door](/azure/frontdoor/front-door-overview) from common web-based attacks, such as the [Open Web Application Security Project (OWASP)](https://owasp.org) vulnerabilities, SQL injections, and cross-site scripting. This cloud-native, pay-as-you-use technology doesn't require licensing. Azure Web Application Firewall provides protection for your web applications and defends your web services against common exploits and vulnerabilities.

- An [Azure DNS zone](/azure/dns/dns-overview) is used for the name resolution of the Azure Front Door custom domain. You can use Azure DNS to host your DNS domain and manage your DNS records.

  - The [CNAME](/azure/templates/microsoft.network/dnszones/cname) record is used to create an alias or pointer from one domain name to another. You can configure a [CNAME record](https://en.wikipedia.org/wiki/CNAME_record) to redirect DNS queries for the custom domain to the original hostname of the Azure Front Door endpoint.

  - The [Text (TXT)](/azure/templates/microsoft.network/dnszones/txt) record contains the validation token for the custom domain. You can use a TXT record within a DNS zone to store arbitrary text information that's associated with a domain.

- A [Private Link service](/azure/private-link/private-link-service-overview) is configured to reference the *kubernetes-internal* internal load balancer of the AKS cluster. When you enable Private Link to your origin in Azure Front Door Premium, Azure Front Door creates a private endpoint from an Azure Front Door-managed regional private network. You receive an Azure Front Door private endpoint request at the origin for your approval. For more information, see [Secure your origin with Private Link in Azure Front Door Premium](/azure/frontdoor/private-link).

- [Azure Virtual Network](/azure/well-architected/service-guides/virtual-network) is used to create a single virtual network with six subnets:

  - *SystemSubnet* is used for the agent nodes of the system node pool.

  - *UserSubnet* is used for the agent nodes of the user node pool.
  
  - *PodSubnet* is used to dynamically allocate private IP addresses to pods when the AKS cluster is configured to use [Azure content networking interface](/azure/aks/configure-azure-cni) with [dynamic IP address allocation](/azure/aks/configure-azure-cni-dynamic-ip-allocation).
  
  - *ApiServerSubnet* uses [API server virtual network integration](/azure/aks/api-server-vnet-integration) to project the API server endpoint directly into this delegated subnet where the AKS cluster is deployed.

  - *AzureBastionSubnet* is used for the [Azure Bastion host](/azure/bastion/bastion-overview).

  - *VmSubnet* is used for the jump box virtual machine (VM) that connects to the private AKS cluster and for the private endpoints.

- A [user-assigned managed identity](/entra/identity/managed-identities-azure-resources/overview) is used by the AKS cluster to create more resources like load balancers and managed disks in Azure.

- [Azure Virtual Machines](/azure/virtual-machines/overview) is used to create an optional jump box VM in the VM subnet.

- An [Azure Bastion host](/azure/bastion/bastion-overview) is deployed in the AKS cluster virtual network to provide Secure Socket Shell connectivity to the AKS agent nodes and VMs.

- An [Azure Storage account](/azure/storage/common/storage-account-overview) is used to store the boot diagnostics logs of both the service provider and service consumer VMs. Boot diagnostics is a debugging feature that you can use to view console output and screenshots to diagnose the VM status.

- [Azure Container Registry](/azure/container-registry/container-registry-intro) is used to build, store, and manage container images and artifacts.

- [Key Vault](/azure/key-vault/general/overview) is used to store secrets, certificates, and keys. Pods can use [Key Vault provider for Secrets Store CSI Driver](https://github.com/Azure/secrets-store-csi-driver-provider-azure) to mount secrets, certificates, and keys as files.

  For more information, see [Use the Key Vault provider for Secrets Store CSI Driver in an AKS cluster](/azure/aks/csi-secrets-store-driver) and [Provide an identity to access the Key Vault provider for Secrets Store CSI Driver](/azure/aks/csi-secrets-store-identity-access).

  In this project, an existing Key Vault resource contains the TLS certificate that the ingress Kubernetes object and the custom domain of the Azure Front Door endpoint use.

- An [Azure private endpoint](/azure/private-link/private-endpoint-overview) and an [Azure private DNS zone](/azure/dns/private-dns-overview) are created for each of the following resources:

  - Container Registry
  - Key Vault
  - A Storage account

- [Azure network security groups (NSGs)](/azure/virtual-network/network-security-groups-overview) are used to filter inbound and outbound traffic for the subnets that host VMs and Azure Bastion hosts.

- An [Azure Monitor workspace](/azure/azure-monitor/essentials/azure-monitor-workspace-overview) is a unique environment for data that [Monitor](/azure/azure-monitor/essentials/data-platform-metrics) collects. Each workspace has its own data repository, configuration, and permissions. Azure Monitor Logs workspaces contain logs and metrics data from multiple Azure resources, whereas Monitor workspaces contain metrics related to [Prometheus](/azure/azure-monitor/essentials/prometheus-metrics-overview) only.

  You can use managed service for Prometheus to collect and analyze metrics at scale by using a Prometheus-compatible monitoring solution that's based on [Prometheus](https://prometheus.io/). You can use the [Prometheus query language (PromQL)](https://prometheus.io/docs/prometheus/latest/querying/basics/) to analyze and alert on the performance of monitored infrastructure and workloads without having to operate the underlying infrastructure.

- An [Azure Managed Grafana](/azure/managed-grafana/overview) instance is used to visualize the [Prometheus metrics](/azure/azure-monitor/containers/prometheus-metrics-enable) that the Bicep module-deployed [AKS](/azure/aks/intro-kubernetes) cluster generates. You can connect your [Monitor workspace](/azure/azure-monitor/essentials/azure-monitor-workspace-overview) to [Azure Managed Grafana](/azure/managed-grafana/overview) and use a set of built-in and custom Grafana dashboards to visualize Prometheus metrics. Grafana Enterprise supports Azure Managed Grafana, which provides extensible data visualizations. You can quickly and easily deploy Grafana dashboards that have built-in high availability. You can also use Azure security measures to control access to the dashboards.

- An [Azure Monitor Logs](/azure/azure-monitor/logs/log-analytics-workspace-overview) workspace is used to collect the diagnostic logs and metrics from Azure resources, which include:

  - AKS clusters
  - Key Vault
  - Azure NSGs
  - Container Registry
  - Storage accounts

- A [Bicep deployment script](/azure/azure-resource-manager/bicep/deployment-script-bicep) is used to run a Bash script that creates the following objects in the AKS cluster:

  - A Kubernetes [deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) and [service](https://kubernetes.io/docs/concepts/services-networking/service/) for the sample [httpbin](https://httpbin.org/) web application.

  - A Kubernetes [ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) object to expose the web application via the NGINX ingress controller.

  - A [SecretProviderClass](/azure/aks/aksarc/secrets-store-csi-driver) custom resource that retrieves the TLS certificate from the specified key vault by using the user-defined managed identity of the [Key Vault provider for Secrets Store CSI Driver](/azure/aks/csi-secrets-store-driver). This component creates a Kubernetes secret that contains the TLS certificate referenced by the ingress object.

  - (Optional) [NGINX ingress controller](https://docs.nginx.com/nginx-ingress-controller/intro/overview/) via Helm if you opted to use an unmanaged NGINX ingress controller.

  - (Optional) [Cert-manager](https://cert-manager.io/docs/)
  
  - (Optional) [Prometheus and Grafana](https://artifacthub.io/packages/helm/prometheus-community/kube-prometheus-stack)

### Alternatives

To automatically create a managed Private Link service to the AKS cluster load balancer, you can use the [Private Link service](/azure/private-link/private-link-service-overview) feature. To provide private connectivity, you must create private endpoint connections to your service. You can use annotations to expose a Kubernetes service via a Private Link service. The architecture in this article manually creates a Private Link service to reference the cluster Azure Load Balancer.

## Scenario details

This scenario uses [Azure Front Door Premium](/azure/frontdoor/front-door-overview), [end-to-end TLS encryption](/azure/frontdoor/end-to-end-tls), [Azure Web Application Firewall](/azure/web-application-firewall/afds/afds-overview), and a [Private Link service](/azure/private-link/private-link-service-overview) to securely expose and protect a workload that runs in [AKS](/azure/aks/intro-kubernetes).

This architecture uses the Azure Front Door TLS and Secure Sockets Layer (SSL) offload capability to terminate the TLS connection and decrypt the incoming traffic at the Front Door. The traffic is reencrypted before it's forwarded to the origin, which is a web application that's hosted in an AKS cluster. HTTPS is configured as the forwarding protocol on Azure Front Door when Azure Front Door connects to the AKS-hosted workload that's configured as an origin. This practice enforces end-to-end TLS encryption for the entire request process, from the client to the origin. For more information, see [Secure your origin with Private Link in Azure Front Door Premium](/azure/frontdoor/private-link).

The [NGINX ingress controller](https://docs.nginx.com/nginx-ingress-controller/intro/overview/) exposes the AKS-hosted web application. The NGINX ingress controller is configured to use a private IP address as a front-end IP configuration of the `kubernetes-internal` internal load balancer. The NGINX ingress controller uses HTTPS as the transport protocol to expose the web application. For more information, see [Create an ingress controller by using an internal IP address](/azure/aks/ingress-basic#create-an-ingress-controller-using-an-internal-ip-address).

The [AKS](/azure/aks/intro-kubernetes) cluster is configured to use the following features:

- [API server virtual network integration](/azure/aks/api-server-vnet-integration) provides network communication between the API server and the cluster nodes. This feature doesn't require a private link or tunnel. The API server is available behind an internal load balancer VIP in the delegated subnet. The cluster nodes are configured to use the delegated subnet. You can use API server virtual network integration to help ensure that the network traffic between your API server and your node pools remains on the private network only. AKS clusters that have API server virtual network integration provide many advantages. For example, you can enable or disable public network access or private cluster mode without redeploying the cluster. For more information, see [Create an AKS cluster with API server virtual network integration](/azure/aks/api-server-vnet-integration).

- [Azure NAT Gateway](/azure/virtual-network/nat-gateway/nat-overview) manages outbound connections that AKS-hosted workloads initiate. For more information, see [Create a managed or user-assigned NAT gateway for your AKS cluster](/azure/aks/nat-gateway).

### Potential use cases

This scenario provides a solution to meet security and compliance requirements for a web application or REST API that runs in AKS.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

Some of the following considerations aren't specifically related to the use of [Azure Front Door](/azure/frontdoor/front-door-overview), [Azure Web Application Firewall](/azure/web-application-firewall/afds/afds-overview), and a [Private Link service](/azure/private-link/private-link-service-overview) to improve the security of an AKS cluster. But the security, performance, availability, reliability, storage, and monitoring considerations are essential requirements of this solution.

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

These recommendations are essential for single-tenant AKS solutions and aren't specific to multitenant AKS solutions, where the reliability targets are higher because of the number of users and workloads that rely on the system. Consider the following recommendations to optimize the availability of your AKS cluster and workloads.

#### Intra-region resiliency

- Deploy the node pools of your AKS cluster across all [availability zones](/azure/aks/availability-zones) in a region.

- Enable [zone redundancy in Container Registry](/azure/container-registry/zone-redundancy) for intra-region resiliency and high availability.

- Use [topology spread constraints](https://kubernetes.io/docs/concepts/workloads/pods/pod-topology-spread-constraints) to control how you spread pods across your AKS cluster among failure domains like regions, availability zones, and nodes.

- Use the Standard or Premium tier for your production AKS clusters. These tiers include the [uptime service-level agreement (SLA) feature](/azure/aks/uptime-sla), which guarantees 99.95% availability of the Kubernetes API server endpoint for clusters that use [availability zones](/azure/aks/availability-zones) and 99.9% availability for clusters that don't use availability zones. For more information, see [Free, Standard, and Premium pricing tiers for AKS cluster management](/azure/aks/free-standard-pricing-tiers).

- Enable [zone redundancy](/azure/reliability/availability-zones-overview) if you use Container Registry to store container images and Oracle Cloud Infrastructure (OCI) artifacts. Container Registry supports optional zone redundancy and [geo-replication](/azure/container-registry/container-registry-geo-replication). Zone redundancy provides resiliency and high availability to a registry or replication resource (replica) in a specific region. Geo-replication replicates registry data across one or more Azure regions to provide availability and reduce latency for regional operations.

#### Disaster recovery and business continuity

- Consider deploying your solution to two regions. Use the [paired Azure region](/azure/best-practices-availability-paired-regions) as the second region.

- Script, document, and periodically test regional failover processes in a quality assurance (QA) environment.

- Test failback procedures to validate that they work as expected.

- Store your container images in [Container Registry](/azure/container-registry/container-registry-intro). Geo-replicate the registry to each region where you deploy your AKS solution.

- If possible, don't store service state in a container. Instead, store service state in an Azure platform as a service (PaaS) storage solution that supports multiregion replication. This approach improves resiliency and simplifies disaster recovery because you can preserve each service's critical data across regions.

- If you use Storage, prepare and test processes to migrate your storage from the primary region to the backup region.

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

- Use a WAF to protect AKS-hosted web applications and services that expose a public HTTPS endpoint. You need to provide protection from common threats like SQL injection, cross-site scripting, and other web exploits. Follow OWASP rules and your own custom rules. [Azure Web Application Firewall](/azure/web-application-firewall/overview) provides improved centralized protection of your web applications from common exploits and vulnerabilities. You can deploy an Azure WAF by using [Azure Application Gateway](/azure/web-application-firewall/ag/ag-overview), [Azure Front Door](/azure/web-application-firewall/afds/afds-overview), or [Azure Content Delivery Network](/azure/web-application-firewall/cdn/cdn-overview).

- Use [Azure DDoS Protection](/azure/ddos-protection/ddos-protection-overview) and application design best practices to defend against workload distributed denial-of-service (DDoS) attacks. Azure protects its infrastructure and services against DDoS attacks. This protection helps ensure the availability of regions, availability zones, and services. You should also protect your workload's public endpoints from DDoS attacks at Layer 4 and Layer 7. You can enable [Azure DDOS Protection](/azure/ddos-protection/manage-ddos-protection) on perimeter virtual networks.

- Use the [Azure Web Application Firewall rate-limit rule for Azure Front Door](/azure/web-application-firewall/afds/waf-front-door-rate-limit) to manage and control the number of requests that you allow from a specific source IP address to your application within a defined rate-limit duration. Use this feature to help enforce rate-limiting policies and help ensure that you protect your application from excessive traffic or potential abuse. Configure the rate-limit rule to maintain optimal application performance and security and provide fine-grained control of request limits.

- Configure the WAF policy that's associated with Azure Front Door to prevention mode. In prevention mode, the WAF policy analyzes incoming requests and compares them to the configured rules. If a request matches one or more rules that are set to deny traffic when satisfied, the WAF policy blocks the malicious traffic from reaching your web applications. This measure helps ensure that you protect your applications against potential vulnerabilities and unauthorized access attempts. For more information, see [Azure Web Application Firewall on Azure Front Door](/azure/web-application-firewall/afds/afds-overview).

- Create an [Azure private endpoint](/azure/private-link/private-link-service-overview) for any PaaS service that AKS workloads use, like [Key Vault](/azure/key-vault/general/overview), [Azure Service Bus](/azure/service-bus-messaging/service-bus-messaging-overview), and [Azure SQL Database](/azure/azure-sql/database/sql-database-paas-overview). The traffic between the applications and these services isn't exposed to the public internet. Traffic between the AKS cluster virtual network and an instance of a PaaS service via a private endpoint travels the Microsoft backbone network but doesn't pass by the Azure firewall. A private endpoint provides security and protection against data leakage. For more information, see [What is Private Link?](/azure/private-link/private-link-overview).

- Use a [WAF policy](/azure/application-gateway/waf-overview) to help protect public-facing AKS-hosted workloads from attacks when you use [Application Gateway](/azure/application-gateway/overview) in front of the AKS cluster.

- Use [Kubernetes network policies](https://kubernetes.io/docs/concepts/services-networking/network-policies/) to control which components can communicate with each other. This control segregates and helps secure intraservice communications. By default, all pods in a Kubernetes cluster can send and receive traffic without limitations. To improve security, you can use Azure network policies or Calico network policies to define rules that control the traffic flow between various microservices. Use Azure network policies to help enforce network-level access control. Use Calico network policies to implement fine-grained network segmentation and security policies in your AKS cluster. For more information, see [Secure traffic between pods by using network policies in AKS](/azure/aks/use-network-policies).

- Don't expose remote connectivity to your AKS nodes. Create an Azure Bastion host, or jump box, in a management virtual network. Use the Azure Bastion host to route traffic to your AKS cluster.

- Consider using a [private AKS cluster](/azure/aks/private-clusters) in your production environment. Or, at a minimum, use [authorized IP address ranges](/azure/aks/api-server-authorized-ip-ranges) in AKS to secure access to the API server. When you use authorized IP address ranges on a public cluster, allow all the egress IP addresses in the Azure firewall network rule collection. In-cluster operations consume the Kubernetes API server.

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

- Use the [cluster autoscaler](/azure/aks/cluster-autoscaler), [Kubernetes event-driven Autoscaling](https://keda.sh/), and the [horizontal pod autoscaler](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/) to scale the number of pods and nodes based on traffic conditions.

- Set proper resource [requests and limits](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) for pods to optimize resource allocation and improve application density. For more information, see [Best practices for resource management in AKS](/azure/aks/developer-best-practices-resource-management).

- Use [ResourceQuota](https://kubernetes.io/docs/reference/kubernetes-api/policy-resources/resource-quota-v1/) objects to set quotas for memory and CPU usage in namespaces. This configuration helps prevent noisy neighbor problems and improve application density. For more information, see [Set limit range in a namespace](https://kubernetes.io/docs/reference/kubernetes-api/policy-resources/limit-range-v1/).

- Implement the [vertical pod autoscaler](/azure/aks/vertical-pod-autoscaler) to analyze and set CPU and memory resources that pods require. This approach optimizes resource allocation.

- Choose the appropriate [VM size](/azure/virtual-machines/sizes) for node pools based on workload requirements.

- Create multiple [node pools](/azure/aks/use-multiple-node-pools) with different VM sizes for specific workloads. Use node labels, node selectors, and affinity rules to optimize resource allocation.

- [Stop node pools](/azure/aks/start-stop-nodepools) or [scale down AKS clusters](/azure/aks/start-stop-cluster) when you don't use them.

- Take advantage of cost management tools, such as [Azure Advisor](/azure/advisor/advisor-overview), [Azure reservations](/azure/cost-management-billing/reservations/save-compute-costs-reservations), and [Azure savings plans](/azure/cost-management-billing/savings-plan/savings-plan-compute-overview) to monitor and optimize costs.

- Consider using [spot node pools](/azure/aks/spot-node-pool) to benefit from unused capacity in Azure and reduce cost.

- Use tools like [Kubecost](https://www.kubecost.com/) to monitor and govern AKS costs.

- Use Azure tags to associate AKS resources with specific workloads or tenants to improve cost tracking and management.

For more information, see [Cost optimization](/azure/well-architected/service-guides/azure-kubernetes-service#cost-optimization) and [Optimize costs in AKS](/azure/aks/best-practices-cost).

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

#### DevOps

- Use a [Helm](https://helm.sh) chart in a continuous integration and continuous delivery pipeline to deploy your workloads to AKS.

- Use A/B testing and canary deployments in your application lifecycle management to properly test an application before you make it available to users.

- Use [Container Registry](/azure/container-registry/container-registry-intro) or a non-Microsoft registry, such as [Harbor](https://goharbor.io/) or [Docker Hub](https://hub.docker.com/), to store private container images that are deployed to the cluster.

- Test ingress and egress on your workloads in a separate preproduction environment that mirrors the network topology and firewall rules of your production environment.

#### Monitoring

- Use [container insights](/azure/azure-monitor/containers/container-insights-overview) to monitor the health status of the AKS cluster and workloads.

- Use [managed service for Prometheus](/azure/azure-monitor/essentials/prometheus-metrics-overview) to collect and analyze metrics at scale by using a Prometheus-compatible monitoring solution that's based on the [Prometheus](https://prometheus.io/) project from Cloud Native Computing Foundation.

- Connect your managed service for Prometheus to an [Azure Managed Grafana](/azure/managed-grafana/overview) instance to use it as a data source in a Grafana dashboard. You then have access to multiple prebuilt dashboards that use Prometheus metrics, and you can create custom dashboards.

- Configure all PaaS services, such as Container Registry and Key Vault, to collect diagnostic logs and metrics in an [Azure Monitor Logs](/azure/azure-monitor/logs/log-analytics-workspace-overview) workspace.

## Deploy this scenario

The source code for this scenario is available in [GitHub](https://github.com/Azure-Samples/aks-front-door-end-to-end-tls). This open-source solution is licensed under the [MIT License](https://github.com/Azure-Samples/aks-front-door-end-to-end-tls/blob/main/LICENSE.md).

### Prerequisites

- An active [Azure subscription](/azure/guides/developer/azure-developer-guide#understanding-accounts-subscriptions-and-billing). If you don't have one, create a [free Azure account](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn) before you begin.

- [Visual Studio Code](https://code.visualstudio.com/) and the [Bicep extension](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-bicep) on one of the [supported platforms](https://code.visualstudio.com/docs/supporting/requirements#_platforms).

- Azure CLI version 2.58.0 or later. For more information, see [Install Azure CLI](/cli/azure/install-azure-cli).

- An existing [Key Vault](/azure/key-vault/general/overview) resource with a valid TLS certificate for the sample web application.

- An existing [Azure DNS zone](/azure/dns/dns-zones-records) for the name resolution of the [Azure Front Door custom domain](/azure/frontdoor/front-door-custom-domain) via a [CNAME record](https://en.wikipedia.org/wiki/CNAME_record).

### Deployment to Azure

1. Clone the [workbench GitHub repository](https://github.com/Azure-Samples/aks-front-door-end-to-end-tls).

   ```git
   git clone https://github.com/Azure-Samples/aks-front-door-end-to-end-tls.git
   ```

1. Follow the instructions in the [README file](https://github.com/Azure-Samples/aks-front-door-end-to-end-tls/blob/master/README.md). You need your Azure subscription information for this step.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Paolo Salvatori](https://www.linkedin.com/in/paolo-salvatori) | Principal Service Engineer

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [AKS cluster best practices](/azure/aks/best-practices)
- [Azure Web Application Firewall on Azure Front Door](/azure/web-application-firewall/afds/afds-overview)
- [Best practices for advanced scheduler features](/azure/aks/operator-best-practices-advanced-scheduler)
- [Best practices for authentication and authorization](/azure/aks/operator-best-practices-identity)
- [Best practices for basic scheduler features in AKS](/azure/aks/operator-best-practices-scheduler)
- [Best practices for business continuity and disaster recovery in AKS](/azure/aks/operator-best-practices-multi-region)
- [Best practices for cluster security and upgrades in AKS](/azure/aks/operator-best-practices-cluster-security)
- [Best practices for container image management and security in AKS](/azure/aks/operator-best-practices-container-image-management)
- [Best practices for network connectivity and security in AKS](/azure/aks/operator-best-practices-network)
- [Best practices for storage and backups in AKS](/azure/aks/operator-best-practices-storage)
- [Best practices for Azure Front Door](/azure/frontdoor/best-practices)
- [Origins and origin groups in Azure Front Door](/azure/frontdoor/origin)
- [Routing architecture overview](/azure/frontdoor/front-door-routing-architecture)
- [Secure your origin with Private Link in Azure Front Door Premium](/azure/frontdoor/private-link)
- [Traffic acceleration](/azure/frontdoor/front-door-traffic-acceleration)
- [Understand Azure Front Door billing](/azure/frontdoor/billing)
- [What is a rule set in Azure Front Door?](/azure/frontdoor/front-door-rules-engine)
- [What is Azure Front Door?](/azure/frontdoor/front-door-overview)

## Related resources

- [Advanced AKS microservices architecture](../../reference-architectures/containers/aks-microservices/aks-microservices-advanced.yml)
- [AKS day-2 operations guide](../../operator-guides/aks/day-2-operations-guide.md)
- [AKS solution journey](../../reference-architectures/containers/aks-start-here.md)
- [Baseline architecture for an AKS cluster](../../reference-architectures/containers/aks/baseline-aks.yml)
- [Best practices for multitenancy and cluster isolation](../../guide/multitenant/service/aks.md)
- [Microservices architecture on AKS](../../reference-architectures/containers/aks-microservices/aks-microservices.yml)
