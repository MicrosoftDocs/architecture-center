---
title: General considerations for choosing an Azure container service 
description: Get a quick overview of common feature-level considerations that can help you choose an Azure container service. Part two of a series. 
author: MarcosMMartinez
ms.author: mamartin
ms.date: 01/03/2024
ms.topic: conceptual
ms.subservice: architecture-guide
ms.custom:
  - arb-containers
products:
  - azure-kubernetes-service
  - azure-container-apps
  - azure-app-service
categories:
  - containers
---

# General architectural considerations for choosing an Azure container service

This article guides you through the process of choosing an Azure container service. It provides an overview of feature-level considerations that are common and critical for some workloads. It can help you make decisions to ensure that your workload meets requirements for reliability, security, cost optimization, operational excellence, and performance efficiency.

> [!note]
> This article is part two in a series that starts with [Choose an Azure container service](choose-azure-container-service.md). We strongly recommend that you read that overview article first to get a context for these architectural considerations.

## Overview

The considerations in this article are divided into four categories:

[Architectural and network considerations](#architectural-considerations)

- Operating system support
- Network address spaces
- Understanding traffic flow
- Planning subnets
- Number of ingress IPs available
- User-defined routes and NAT gateway support
- Private networking integration
- Protocol coverage
- Load balancing
- Service discovery
- Custom domains and managed TLS
- Mutual TLS
- Networking concepts for specific Azure services 

[Security considerations](#security-considerations)

- Providing security for intra-cluster traffic by using network policies
- Network security groups
- Azure Key Vault integration
- Managed identity support
- Threat protection and vulnerability assessments with Defender for Containers
- Security baselines
- Azure Well-Architected Framework for Security

[Operational considerations](#operational-considerations)

- Updates and patches 
- Container image updates 
- Vertical infrastructure scalability
- Horizontal infrastructure scalability
- Application scalability
- Observability
- Well-Architected Framework for Operational Excellence

[Reliability considerations](#reliability)

- Service-level agreements
- Redundancy via availability zones
- Health checks and self-healing
- Zero-downtime application deployments
- Resource limits
- Well-Architected Framework for Reliability

Note that this article focuses on a subset of Azure container services that offer a mature feature set for web applications and APIs, networking, observability, developer tools, and operations: Azure Kubernetes Service (AKS), AKS Automatic, Azure Container Apps, and Web App for Containers. For a complete list of all Azure container services, see [the container services product category page](https://azure.microsoft.com/products/category/containers/).

> [!NOTE]
> Some sections distinguish AKS Standard from AKS Automatic. If a section does not distinguish between the two, feature parity is assumed.

## Architectural considerations

This section describes architectural decisions that are difficult to reverse or correct without requiring significant downtime or re-deployment. It's especially necessary to keep this consideration in mind for fundamental components like networking and security.

These considerations aren't specific to Well-Architected Framework pillars. However, they deserve extra scrutiny and evaluation against businesses requirements when you choose an Azure container service.

> [!NOTE]
> AKS Automatic is a more opinionated solution than AKS Standard. Some out of the box features cannot be disabled. This guide does not call out these features. For up to date information on these constraints, and Standard vs Automatic feature comparison see: [AKS Automatic and Standard feature comparison](/azure/aks/intro-aks-automatic#aks-automatic-and-standard-feature-comparison).

### Operating system support

Most containerized applications run in Linux containers, which are supported by all Azure container services. Your options are more limited for workload components that require Windows containers.

| |  Container Apps | AKS | AKS Automatic | Web App for Containers |
|---|--|--|--|--|
| **Linux support** | ✅ | ✅ | ✅ |✅ |
| **Windows support** | ❌ | ✅ | ❌|✅ |
| **Mixed OS support** | ❌ | ✅ | ❌| ❌* |

*Mixed OS support for Web App for Containers requires separate Azure App Service plans for Windows and Linux.

## Networking considerations

It's important to understand networking design early in your planning processes due to security and compliance constraints and imposed guidelines. In general, the major differences among the Azure services covered in this guide depend on preference:

- [Container Apps](https://azure.microsoft.com/products/container-apps) is a PaaS offering that provides many Azure-managed networking features, like service discovery, internal managed domains, and virtual network controls.
- [AKS](https://azure.microsoft.com/products/kubernetes-service/) is the most configurable of the three services and provides the most control over network flow. For example, it provides custom ingress controllers and the control of intra-cluster traffic via Kubernetes network policies. Workload teams can take advantage of various Azure managed [networking add-ons](/azure/aks/integrations), as well as install and operate any add-ons from the broader Kubernetes ecosystem.
- [Web App for Containers](https://azure.microsoft.com/products/app-service/containers/) is feature of [App Service](/azure/well-architected/service-guides/app-service-web-apps). Thus, the networking concepts, especially private networking integration, are very specific to App Service. This service will be familiar to workload teams that already use App Service. Teams that don't have experience with App Service and that want a more familiar Azure virtual network integration are encouraged to consider Container Apps.

Keep in mind that networking is a foundational infrastructure layer. It's often difficult to make changes in design without re-deploying the workload, which can lead to downtime. Therefore, if your workload has specific networking requirements, review this section carefully before you narrow down your Azure container service selection.

### Network address spaces

When you integrate applications into virtual networks, you need to do some IP address planning to ensure that enough IP addresses are available for container instances. During this process, plan for additional addresses for updates, blue/green deployments, and similar situations in which extra instances are deployed, which consumes additional IP addresses.

| |  Container Apps | AKS | Web App for Containers |
|---|---|---|---|
| **Dedicated subnets** | Consumption plan: optional<br>Dedicated plan: required | Required | Optional |
| **IP address requirements** | Consumption plan: See [Consumption-only environment](/azure/container-apps/networking#subnet).<br>Dedicated plan: See [Workload profiles environment](/azure/container-apps/networking#subnet). | See [Azure virtual networks for AKS](/azure/aks/concepts-network). | See [App Service subnet requirements](/azure/app-service/overview-vnet-integration). |

Note that AKS requirements depend on the chosen network plug-in. Some network plug-ins for AKS require broader IP reservations. Details are outside the scope of this article. For more information, see [Networking concepts for AKS](/azure/aks/concepts-network).

### Understanding traffic flow

The types of traffic flow required for a solution can affect the network design.

The following sections provide information about various networking constraints. These constraints affect your need to deploy additional subnets, depending on whether you require:

- Multiple colocated workloads.  
- Private and/or public ingress.  
- An access-controlled flow of east-west traffic in a cluster (for Container Apps and AKS) or within a virtual network (for all Azure container services).

### Subnet planning

Ensuring that you have a subnet that's large enough to include instances of your application for your workload isn't the only factor that dictates the network footprint where these applications are deployed.

| |  Container Apps| AKS | Web App for Containers |
|---|--|--|---|
| **Support for colocated workloads within a subnet*** | ❌* | ✅ | N/A* |

*This describes a best practice, not a technical limitation.

For Container Apps, subnet integration applies only to a single Container Apps environment. Each Container Apps environment is constrained to a single ingress IP, public or private. 

Each Container Apps environment is meant only for a single workload in which dependent applications are colocated. Therefore, you need to introduce additional Azure networking appliances for ingress load balancing if you need both public and private ingress. Examples include Azure Application Gateway and Azure Front Door. Also, if you have multiple workloads that need to be segregated, additional Container Apps environments are required, so an additional subnet must be allocated for each environment.

AKS provides granular east-west network flow control within the cluster in the form of Kubernetes network policy. This flow control enables you to segment multiple workloads with different network security boundaries within the same cluster.

For Web App for Containers, there are no constraints on how many apps you can integrate with a single subnet, as long as the subnet is large enough. There are no best practices for access control between web apps in the same virtual network. Each web app independently manages access control for east-west or north-south traffic from the virtual network or internet, respectively.

> [!note]
> You can't resize subnets that have resources deployed in them. Take extra care when you plan your network to avoid needing to redeploy entire workload components, which can lead to downtime.

### Number of ingress IPs available

The following table takes the previous subnet planning section into consideration to define how many IPs can be exposed for an arbitrary number of applications that are hosted in a single deployment of an Azure container service.

| | Container Apps | AKS | Web App for Containers |
|---|---|---|---|
| **Number of ingress IPs** | One | Many | App Service Environment: One<br>No App Service Environment: Many |

Container Apps allows one IP per environment, public or private. AKS allows any number of IPs, public or private. Web App for Containers, outside of an App Service Environment, allows one public IP for all apps within an App Service plan and multiple, different private IPs that use Azure private endpoints.

It's important to note that web apps that are integrated into an App Service Environment only receive traffic through the single ingress IP that's associated with the App Service Environment, whether it's public or private.

### User-defined routes and NAT gateway support

If a workload requires user-defined routes (UDRs) and NAT gateway capabilities for granular networking control, Container Apps requires the use of [workload profiles](/azure/container-apps/workload-profiles-overview). UDR and NAT gateway compatibility is not available in the consumption-only plan for ACA. 

AKS and Web App for Containers implement these two networking features through standard virtual network functionality or virtual network integration, respectively. To elaborate, AKS node pools and Web App for Containers in an App Service Environment are already direct virtual network resources. Web App for Containers that aren't in an App Service Environment support UDRs and NAT gateway via [virtual network integration](/azure/app-service/overview-vnet-integration). With virtual network integration, the resource technically doesn't reside directly in the virtual network, but all of its outbound access flows through the virtual network, and the network's associated rules affect traffic as expected.

| | Container Apps| AKS| Web App for Containers|
|---|---|--|--|
| **UDR support** | Consumption-only plan: ❌<br>Workload profile plan: ✅ | ✅ | ✅ |
| **NAT gateway support** | Consumption-only plan: ❌<br>Workload profile plan: ✅ | ✅ | ✅|

### Private networking integration

For workloads that require strict Layer 4 private networking for both ingress and egress, you should consider Container Apps, AKS, and the single-tenant App Service Environment SKU, where workloads are deployed into a self-managed virtual network, providing the customary granular private networking controls.

| | Container Apps| AKS| Web App for Containers|
|---|--|--|---|
| **Private ingress into a virtual network** | ✅ | ✅ | Via [private endpoint](/azure/app-service/networking/private-endpoint) |
| **Private egress from a virtual network** | ✅ | ✅ | Via [virtual network](/azure/app-service/overview-vnet-integration) integration |
| **Fully suppressed public endpoint** | ✅ | ✅ | [App Service Environment only](/azure/app-service/environment/networking#addresses) |

##### Private networking with Web App for Containers

Web App for Containers provides additional networking features that aren't surfaced in the same way by the other Azure services described in this article. To implement strict private networking requirements, workload teams need to familiarize themselves with these networking concepts. Carefully review these networking features: 
- [Private endpoint](/azure/private-link/private-endpoint-overview) 
- [Virtual network integration](/azure/app-service/overview-vnet-integration)

If you want a PaaS solution and prefer networking concepts that are shared across multiple Azure solutions, you should consider Container Apps.

### Protocol coverage

An important consideration for the hosting platform is the networking protocols that are supported for incoming application requests (ingress). Web App for Containers is the strictest option, supporting only HTTP and HTTPS. Container Apps additionally allows incoming TCP connections. AKS is the most flexible, supporting unconstrained use of TCP and UDP on self-selected ports.

| | [Container Apps](/azure/container-apps/ingress-overview)| AKS| [Web App for Containers](/azure/app-service/networking-features#app-service-ports)|
|---|--|--|--|
| **Protocol and port support** | HTTP (port 80)* <br>HTTPS (port 443)*<br>TCP (ports 1-65535, except 80 and 443) | TCP (any port)<br>UDP (any port) | HTTP (port 80)<br>HTTPS (port 443) |
| **WebSocket support** | ✅ | ✅ | ✅ |
| **HTTP/2 support** | ✅ | ✅ | ✅ |

*In the Container Apps environment, [HTTP/S can be exposed on any port](/azure/container-apps/ingress-overview#additional-tcp-ports) for intra-cluster communication. In that scenario, built-in Container Apps HTTP features like CORS and session affinity don't apply.

Both Container Apps and Web App for Containers support TLS 1.2 for their built-in HTTPS ingress.

### Load balancing

With Container Apps and Web App for Containers, Azure fully abstracts away the Layer 4 and Layer 7 load balancers.

In contrast AKS uses a shared responsibility model in which Azure manages the underlying Azure infrastructure that the workload team configures by interfacing with the Kubernetes API. For Layer 7 load balancing in AKS, you can choose an Azure-managed options, for example the [AKS managed application routing add-on](/azure/aks/app-routing) or the [Application Gateway for Containers](/azure/application-gateway/for-containers/overview), or deploy and self-manage an ingress controller of your choice.

| | Container Apps| AKS| Web App for Containers|
|---|--|--|--|
| **Layer 4 load balancer** | Azure-managed | Shared responsibility | Azure-managed |
| **Layer 7 load balancer** | Azure-managed | Shared or self-managed | Azure-managed |

### Service discovery

In cloud architectures, runtimes can be removed and re-created at any time to rebalance resources, so instance IP addresses regularly change. These architectures use fully qualified domain names (FQDNs) for reliable and consistent communication.

| | Container Apps| AKS| Web App for Containers|
|---|--|--|--|
| **Service discovery** | Azure-managed FQDN | Kubernetes configurable | Azure-managed FQDN |

Web Apps for Containers provides public ingress (north-south communication) FQDNs out of the box. No additional DNS configuration is required. However, there's no built-in mechanism to facilitate or restrict traffic between other apps (east-west communication).

Container Apps also provides public ingress FQDNs. However, Container Apps goes further by allowing the app FQDN to be exposed and [restricting traffic only within the environment](/azure/container-apps/networking). This functionality makes it easier to manage east-west communication and enable components like Dapr.

Kubernetes deployments are not initially discoverable within or from outside the cluster. You must create Kubernetes services as defined by the Kubernetes API, which then expose applications to the network in an addressable way.

> [!important]
> Only Container Apps and AKS provide service discovery through internal DNS schemes within their respective environments. This functionality can simplify DNS configurations across dev/test and production environments. For example, you can create these environments with arbitrary service names that have to be unique only within the environment or cluster, so they can be the same across dev/test and production. With Web App for Containers, service names must be unique across different environments to avoid conflicts with Azure DNS. 

### Custom domains and managed TLS

Both Container Apps and Web App for Containers provide out-of-the-box solutions for custom domains and certificate management.

| | Container Apps| AKS| Web App for Containers|
|---|--|--|--|
| **Configure custom domains** | Out of the box | BYO | Out of the box |
| **Managed TLS for Azure FQDNs** | Out of the box | N/A | Out of the box |
| **Managed TLS for custom domains** | [In preview](/azure/container-apps/custom-domains-managed-certificates) | BYO | Out of the box or BYO |

AKS users are responsible for managing DNS, cluster configurations and TLS certificates for their custom domains. Although AKS does not offer managed TLS, customers can leverage software from the Kubernetes ecosystem, for example the popular [cert-manager](https://www.cncf.io/projects/cert-manager/) to manage TLS certificates.

### Mutual TLS

Another alternative for restricting incoming traffic is mutual TLS (mTLS). Mutual TLS is a security protocol that ensures that both the client and server in communication are authenticated. To accomplish authentication, both parties exchange and verify certificates before any data is transmitted.

Web App for Containers has built-in mTLS support for incoming client connections. However, the application needs to validate the certificate by [accessing the `X-ARR-ClientCert` HTTP header](/azure/app-service/app-service-web-configure-tls-mutual-auth#access-client-certificate) that the App Service platform forwards.

Container Apps also has built-in support for mTLS. It forwards the client certificate to the application in the HTTP header [X-Forwarded-Client-Cert](/azure/container-apps/client-certificate-authorization). You can also easily enable [automatic mTLS for internal communication between apps](/azure/container-apps/networking#mtls) in a single environment.

Mutual TLS in AKS can be implemented through the [Istio-based service mesh as a managed add-on](/azure/aks/istio-about), which includes mTLS capabilities for incoming client connections and intra cluster communication between services. Workload teams could also choose to install and manage another service mesh offering from the Kubernetes ecosystem. These options make mTLS implementation in Kubernetes the most flexible.

### Service-specific networking concepts

The preceding sections describe some of the most common considerations to take into account. For more details and to learn more about networking features that are specific to individual Azure container services, see these articles:

- [Networking in Container Apps](/azure/container-apps/networking)
- [Networking concepts for AKS](/azure/aks/concepts-network)
- [App Service networking features](/azure/app-service/networking-features)

The preceding sections focus on network design. Continue to the next section to learn more about networking security and securing network traffic.

## Security considerations

Failure to address security risks can lead to unauthorized access, data breaches, or leaks of sensitive information. Containers offer an encapsulated environment for your application. The hosting systems and underlying network overlays, however, require additional guardrails. Your choice of Azure container service needs to support your specific requirements for securing each application individually and provide proper security measures to prevent unauthorized access and mitigate the risk of attacks.

### Security comparison overview

Most Azure services, including Container Apps, AKS, and Web App for Containers, integrate with key security offerings, including Key Vault and managed identities.

Of the services in this guide, AKS offers the most configurability and extensibility in part by surfacing underlying components, which often can be secured via configuration options. For example, customers can disable local accounts to the Kubernetes API server or turn on automatic updates to underlying nodes via configuration options. 

AKS Automatic clusters come with a hardened default configuration, with many cluster, application, and networking security settings enabled by default. These initial configurations don't just reduce deployment time, but also give users a standardized configuration that is pre-validated and thus gives users a solid foundation for day 2 operational responsibilities. This foundation helps shorten the learning curve of long-term cluster management for teams that are new to the technology.

For a detailed comparison, carefully review the following considerations to ensure that your workload security requirements can be met.

### Kubernetes control plane security

AKS offers the most flexibility of the three options considered in this article, providing full access to the Kubernetes API so that you can customize container orchestration. This access to the Kubernetes API, however, also represents a significant attack surface, and you need to secure it. 

> [!Important] 
> Note that this section isn't relevant for Web App for Containers, which uses the  Azure Resource Manager API as its control plane.

#### Identity-based security

Customers are responsible for securing identity-based access to the API. Out of the box, Kubernetes provides its own authentication and authorization management system, which also needs to be secured with access controls. 

To take advantage of a single plane of glass for identity and access management on Azure, it's a best practice to [disable Kubernetes-specific local accounts](/azure/aks/manage-local-accounts-managed-azure-ad) and instead [implement AKS-managed Microsoft Entra integration](/azure/aks/enable-authentication-microsoft-entra-id) together with [Azure RBAC for Kubernetes](/azure/aks/manage-azure-rbac). If you implement this best practice, administrators don't need to perform identity and access management on multiple platforms.

| | Container Apps | AKS|
|---|--|--|
| **Kubernetes API access controls** | No access | Full access |

Customers who use Container Apps don't have access to the Kubernetes API. Microsoft provides security for this API. 

#### Network-based security

If you want to restrict network access to the Kubernetes control plane, you need to use AKS, which provides two options. The first option is to use [private AKS clusters](/azure/aks/private-clusters#create-a-private-aks-cluster), which use Azure Private Link between the API server's private network and the AKS cluster's private network. The second option is [API Server VNet integration (preview)](/azure/aks/api-server-vnet-integration), where the API server is integrated into a delegated subnet. See the documentation to learn more.

There are consequences to implementing network-restricted access to the Kubernetes API. Most notably, management can be performed only from within the private network. Typically this means you need to deploy self-hosted agents for Azure DevOps or GitHub Actions. To learn about other limitations, see the product-specific documentation.

| | Container Apps | AKS|
|---|--|--|
| **Kubernetes API network security** | Not configurable in PaaS | Configurable: public IP or private  IP |

These considerations don't apply to Container Apps. Because it's PaaS, Microsoft abstracts away the underlying infrastructure.

### Data plane network security

The following networking features can be used to control access to, from, and within a workload.

#### Using network policies to provide security for intra-cluster traffic

Some security postures require network traffic segregation *within* an environment, for example when you use multitenant environments to host multiple or multi-tiered applications. In these scenarios, you should choose AKS and implement [network policies](/azure/aks/use-network-policies), a cloud-native technology that enables granular configuration of Layer 4 networking within Kubernetes clusters.

| | Container Apps| AKS| Web App for Containers|
|---|--|--|--|
| **Network policies** | Consumption plan: ❌<br>Dedicated plan: ❌ | ✅ | ❌ |

Of the three Azure services described in this article, AKS is the only one that supports further workload isolation within the cluster.  Network policies aren't supported in Container Apps or Web App for Containers.

#### Network security groups

In all scenarios, you can regulate networking communication within the wider virtual network by using network security groups, which enables you to use Layer 4 traffic rules that regulate ingress and egress at the virtual network level.

| | Container Apps| AKS| Web App for Containers|
|---|--|--|--|
| **Network security groups** | Consumption plan: ✅<br>Dedicated plan: ✅ | ✅ | ✅ VNet-integrated apps: egress only |

#### Built-in IP restrictions for ingress

Container Apps and Web App for Containers provide built-in source IP restrictions for ingress traffic for individual applications. AKS can achieve the same functionality, but requires Kubernetes native functionality through the [Kubernetes Service api-resource](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.31/#service-v1-core) where you can set values for _loadBalancerSourceRanges_.

| | Container Apps| AKS | Web App for Containers|
|---|--|--|--|
| **Built-in ingress IP restrictions** | ✅ | ❌* | ✅ |
| **Resource consumption** | - | Consumes cluster resources | - |

> [!NOTE]
> AKS offers ingress IP restrictions, but it's a Kubernetes native feature and not Azure Native like the other services. 

## Application-level security

You need to secure workloads not just at the network and infrastructure level, but also at the workload and application level. Azure container solutions integrate with Azure security offerings to help standardize security implementation and controls for your applications.

### Key Vault integration

It's a best practice to store and manage secrets, keys, and certificates in a key management solution like Key Vault, which provides enhanced security for these components. Instead of storing and configuring secrets in code or in an Azure compute service, all applications should integrate with Key Vault.

Key Vault integration enables application developers to focus on their application code. All three of the Azure container services described in this article can automatically sync secrets from the Key Vault service and provide them to the application, typically as environment variables or mounted files.

| | Container Apps| AKS| Web App for Containers|
|---|--|--|--|
| **Key Vault integration** | ✅ | ✅ | ✅ |

For more information, see:

- [Manage secrets in Azure Container Apps](/azure/container-apps/manage-secrets?tabs=azure-portal#reference-secret-from-key-vault)
- [Integrate Key Vault with AKS](/azure/aks/csi-secrets-store-driver)
- [Use Key Vault references as app settings in Azure App Service](/azure/app-service/app-service-key-vault-references)

### Managed identity support

Managed Identity can be used by applications to authenticate to Microsoft Entra ID protected services without having to use keys or secrets. Container Apps and Web App for Container offer built-in, Azure native support for application level managed identity. Application level managed identity support for AKS is accomplished through [Entra Workload ID](/azure/aks/workload-identity-overview). AKS also requires infrastructure-related managed identity to allow cluster operations for the Kubelet, control plane, and various AKS add-ons.

| | Container Apps| AKS| Web App for Containers|
|---|--|--|--|
| **Infrastructure managed identity support** | N/A | ✅ | N/A |
| **Container-pull managed identity support** | ✅ | ✅ | ✅ |
| **Application managed identity support** | ✅ | ✅ | ✅ |

For more information, see:

- [Use a managed identity in AKS](/azure/aks/use-managed-identity)
- [Microsoft Entra Workload ID with AKS](/azure/aks/workload-identity-overview)
- [Managed identities in Azure Container Apps](/azure/container-apps/managed-identity)
- [How to use managed identities for App Service](/azure/app-service/overview-managed-identity)

### Threat protection and vulnerability assessments with Defender for Containers

Threat protection against vulnerabilities is also important. It's a best practice to use [Defender for Containers](/azure/defender-for-cloud/defender-for-containers-introduction). Vulnerability assessments are supported in Azure container registries, so they can be used by any Azure container service, not just the ones described in this article. Defender for Containers runtime protection, however, is available only for AKS.

As AKS exposes the native Kubernetes API, cluster security also can be evaluated with Kubernetes specific security tooling from the Kubernetes ecosystem.

| | Container Apps| AKS| Web App for Containers|
|---|--|--|--|
| **Runtime threat protection** | ❌ | ✅ | ❌ |

For more information, see [Containers support matrix in Defender for Cloud](/azure/defender-for-cloud/support-matrix-defender-for-containers).

Note that container image vulnerability assessments aren't real-time scans. The Azure Container Registry is scanned at regular intervals.

## Security baselines

In general, most Azure container services integrate Azure security offerings.  Overall, keep in mind that a security feature set is just a small part of implementing cloud security. For more information about implementing security for container services, see the following service-specific security baselines:

- [Azure security baseline for Container Apps](/security/benchmark/azure/baselines/azure-container-apps-security-baseline)
- [Azure security baseline for Azure Kubernetes Service](/security/benchmark/azure/baselines/azure-kubernetes-service-aks-security-baseline)
- [Azure security baseline for App Service](/security/benchmark/azure/baselines/app-service-security-baseline)

> [!NOTE]
> AKS Automatic clusters are configured with [specific security settings](/azure/aks/intro-aks-automatic#security-and-policies). Ensure those are aligned with your workload needs.

## Well-Architected Framework for Security

This article focuses on the main differences among the container services features described here. 

For more complete security guidance about AKS, see [Well-Architected Framework review - AKS](/azure/well-architected/service-guides/azure-kubernetes-service).

## Operational considerations

To successfully run a workload in production, teams need to implement operational excellence practices, including centralized logging, monitoring, scalability, regular updates and patching, and image management.

### Updates and patches

It is important that an application's underlying OS is updated and regularly patched. Keep in mind, however, that with every update there's a risk of failure. This section and the next one describe the main considerations for the three container services with regard to the shared responsibility between the customer and the platform.

As a managed Kubernetes service, AKS will provide the updated images for the node OS and control plane components. But workload teams are responsible for applying updates to their clusters. You can manually trigger updates or leverage the [cluster auto-upgrade channels](/azure/aks/auto-upgrade-cluster) feature to ensure your clusters are up to date. See the AKS day-2 operations guide to learn about [patching and upgrading AKS clusters](/azure/architecture/operator-guides/aks/aks-upgrade-practices).

Container Apps and Web App for Containers are PaaS solutions. Azure is responsible for managing updates and patches, so customers can avoid the complexity of AKS upgrade management.

| | Container Apps| AKS| AKS Automatic| Web App for Containers|
|---|--|--|--|--|
| **Control plane updates** | Platform | [Customer](/azure/aks/upgrade-cluster) | Platform | Platform |
| **Host updates and patches** | Platform | [Customer](/azure/aks/node-image-upgrade) | Platform | Platform |
| **Container image updates and patches** | Customer | Customer | Customer | Customer |

### Container image updates

Regardless of the Azure container solution, customers are always responsible for their own container images. If there are security patches for container base images, it's your responsibility to rebuild your images. To get alerts about these vulnerabilities, use [Defender for Containers](/azure/defender-for-cloud/defender-for-containers-introduction) for containers that are hosted in Container Registry.

## Scalability

Scaling is used to adjust resource capacity to meet demands, adding more capacity to ensure performance and removing unused capacity to save money. When you choose a container solution, you need to consider infrastructure constraints and scaling strategies.

### Vertical infrastructure scalability

*Vertical scaling* refers to the ability to increase or decrease existing infrastructure, that is, compute CPU and memory. Different workloads require different amounts of compute resources. When you choose an Azure container solution, you need to be aware of the hardware SKU offerings that are available for a particular Azure service. They vary and can impose additional constraints.

For AKS, review the [sizes for virtual machines in Azure](/azure/virtual-machines/sizes) documentation and the [per-region AKS restrictions](/azure/aks/quotas-skus-regions).

These articles provide details about SKU offerings for the other two services:

- [Workload profiles in Container Apps](/azure/container-apps/workload-profiles-overview)
- [App Service pricing](https://azure.microsoft.com/pricing/details/app-service/linux/)

### Horizontal infrastructure scalability

*Horizontal scaling* refers to the ability to increase or decrease capacity via new infrastructure, like VM nodes. During scaling increases or decreases, the Container Apps consumption tier abstracts the underlying virtual machines. For the remaining Azure container services, you manage the horizontal scaling strategy by using the standard Azure Resource Manager API.

Note that scaling out and in includes re-balancing of instances, so it also creates a risk of downtime. The risk is smaller than the corresponding risk with vertical scaling. Nevertheless, workload teams are always responsible for ensuring that their applications can handle failure and for implementing graceful startups and shutdowns of their applications to avoid downtime.

| | Container Apps| AKS| Web App for Containers|
|---|--|--|--|
| **Infrastructure scale in and out** | Consumption plan: N/A<br>Dedicated plan: configurable | Configurable | Configurable |
| **Flexible hardware provisioning** | Consumption plan: N/A<br>Dedicated plan: abstracted with workload profiles | Any VM SKU | Abstracted. See [App Service plan](/azure/app-service/overview-hosting-plans). |

> [!important]
> The hardware provisioning options available through the Container Apps Dedicated plan (workload profiles) and Web App for Containers (App Service plans) aren't as flexible as AKS. You need to familiarize yourself with the SKUs available in each service to ensure that your needs are met.

### Application scalability

The typical measure on which to trigger scaling of infrastructure and applications is resource consumption: CPU and memory. Some container solutions can scale container instance count on metrics with application-specific context, like HTTP requests. For example, AKS and Container Apps can scale container instances based on message queues via KEDA and many other metrics via its [scalers](https://keda.sh/docs/2.12/scalers/). These capabilities provide flexibility when you're choosing the scalability strategy for your application. Web App for Containers relies on the scalability options provided by Azure. (See the following table.) Web App for Containers doesn't support custom scaler configurations like KEDA.

| | Container Apps| AKS| Web App for Containers|
|---|--|--|--|
| **Container scale out** | [HTTP, TCP, or metrics-based (CPU, memory, event-driven)](/azure/container-apps/scale-app). | [Metrics-based (CPU, memory, or custom)](/azure/aks/concepts-scale). | [Manual, metrics-based](), or [automatic (preview)](/azure/app-service/manage-automatic-scaling). |
| **Event-driven scalability** | Yes. Cloud-native. | Yes. Cloud-native. Additional configuration required. | Yes. Azure-resource specific. |

AKS Automatic enables the Horizontal Pod Autoscaler, Kubernetes Event Driven Autoscaling (KEDA), and Vertical Pod Autoscaler (VPA) by default.

## Observability

### Workload instrumentation

Gathering metrics for complex or multi-tiered applications can be challenging. To get metrics, you can integrate containerized workloads with Azure Monitor in two ways:

- **Automatic instrumentation**. No code changes required.
- **Manual instrumentation**. Minimal code changes required to integrate and configure the SDK and/or client.

 | | Container Apps| AKS| Web App for Containers|
  |---|--|--|--|
  | **Automatic instrumentation via platform** | ❌ | ❌ | Partial support* |
  | **Automatic instrumentation via agent** | ❌ | Partial support* | N/A |
  | **Manual instrumentation** | Via SDK or OpenTelemetry | Via SDK or OpenTelemetry | Via SDK or OpenTelemetry |

*AKS and Web App for Containers support automatic instrumentation for certain configurations of Linux and Windows workloads, depending on the application language. For more information, see these articles:

- [Automatic instrumentation supported environments, languages, and resource providers](/azure/azure-monitor/app/codeless-overview#supported-environments-languages-and-resource-providers)
- [Zero instrumentation application monitoring for Kubernetes](/azure/azure-monitor/app/kubernetes-codeless)

Instrumentation within application code is the responsibility of application developers, so it's independent of any Azure container solution. Your workload can use solutions like:

- [Application Insights SDKs](/azure/azure-monitor/app/app-insights-overview#supported-languages)
- [OpenTelemetry distributions](/azure/azure-monitor/app/opentelemetry-add-modify)

### Logs and Metrics

All Azure container services provide application and platform log and metric functionality. Application logs are console logs generated by your workload. Platform logs capture events that occur at the platform level, outside the scope of your application, like scaling and deployments. Metrics are numerical values that describe some aspect of a system at a point in time, allowing you to monitor and alert on system performance and health.

Azure Monitor is the main logging and metrics service in Azure that integrates with these services. Azure Monitor uses [resource logs](/azure/azure-monitor/essentials/resource-logs) to separate logs from different sources into categories and collects metrics to provide insights into resource performance. One way to determine which logs and metrics are available from each Azure service is to look at the resource log categories and available metrics for each of the services.

|     | Container Apps | AKS | AKS Automatic | Web App for Containers |
| --- | --- | --- | --- | --- |
| **Support for log streaming** | ✅   | ✅   | ✅   | ✅   |
| **Support for Azure Monitor** | ✅   | ✅   | ✅   | ✅   |
| **Azure Monitor resource logs** | [Console](/azure/container-apps/logging#container-console-logs) and [System](/azure/container-apps/logging#system-logs) | [Kubernetes API server, Audit, Scheduler, Cluster Autoscaler, and more](/azure/aks/monitor-aks#aks-control-planeresource-logs) | Same as AKS | [ConsoleLogs, HTTPLogs, EnvironmentPlatformLogs, and more](/azure/app-service/monitor-app-service-reference#resource-logs) |
| **Metric collection and monitoring** | Metrics via Azure Monitor; custom metrics via [Dapr metrics](/azure/container-apps/dapr-overview#observability) | Metrics via Azure Monitor; custom metrics via Prometheus (requires manual setup) | Preconfigured Managed Prometheus for metrics collection and Managed Grafana for visualization; metrics via Azure Monitor | Metrics via Azure Monitor |
| **Preconfigured Prometheus and Grafana** | ❌   | Requires manual setup | ✅ Managed Prometheus and Managed Grafana are preconfigured by default. | ❌   |

**Container Apps** abstracts all of its internal Kubernetes logs into two categories: Console logs, which contain workload container logs, and System logs, which contain all platform-related logs. For metrics, Container Apps integrates with Azure Monitor to collect standard metrics and supports custom metrics through Dapr integration for advanced scenarios.

**AKS** provides Kubernetes-related logs and granular control over what gets logged. AKS retains full compatibility with Kubernetes client tools for log streaming, such as kubectl. For metrics, AKS integrates with Azure Monitor to collect cluster and node metrics. Custom metrics collection using Prometheus and visualization with Grafana are possible but require manual setup and configuration.

**AKS Automatic** comes preconfigured with specific monitoring tools. It uses Managed Prometheus for metrics collection and Managed Grafana for visualization. Cluster and application metrics are automatically collected and can be visualized. AKS Automatic also integrates with Azure Monitor for log and metric collection.

**Web App for Containers** provides several categories of resource logs because its platform (App Service) isn't exclusively for container workloads. For container-specific operations that manage its internal Docker platform, it provides the AppServicePlatformLogs log category. Another important category is AppServiceEnvironmentPlatformLogs, which logs events like scaling and configuration changes. Metrics are collected via Azure Monitor, allowing you to monitor application performance and resource utilization.


### Well-Architected Framework for Operational Excellence

This article focuses on the main differences among the container services features described here. See these articles to review the complete Operational Excellence guidance for the following services:

- [AKS](/azure/well-architected/service-guides/azure-kubernetes-service)
- [Web App for Containers](/azure/well-architected/service-guides/azure-app-service/operational-excellence)

## Reliability

*Reliability* refers to the ability of a system to react to failures and remain fully functional. At the application-software level, workloads should implement best practices like caching, retry, circuit breaker patterns, and health checks. At the infrastructure level, Azure is responsible for handling physical failures, like hardware failures and power outages, in datacenters. Failures can still happen. Workload teams should select the appropriate Azure service tier and apply necessary minimum-instance configurations to implement automatic failovers between availability zones.

To choose the appropriate service tier, you need to understand how service-level agreements (SLAs) and availability zones work.

### Service-level agreements

Reliability is commonly measured by [business-driven metrics](/azure/well-architected/resiliency/business-metrics) like SLAs or recovery metrics like recovery time objectives (RTOs). 

Azure has many SLAs for specific services. There's no such thing as a 100% service level, because failures can always occur in software and hardware, and in nature, for example, storms and earthquakes. An SLA isn't a guarantee but rather a financially backed agreement of service availability.

For the latest SLAs and details, [download the latest SLA for Microsoft Online Services document](https://www.microsoft.com/licensing/docs/view/Service-Level-Agreements-SLA-for-Online-Services) from the Microsoft licensing website.

#### Free vs. paid tiers

Generally, free tiers of Azure services don't offer an SLA, which makes them cost-effective choices for non-production environments. For production environments, however, it's a best practice to choose a paid tier that has an SLA.

#### Additional factors for AKS

AKS has different SLAs for different components and configurations: 

- **Control plane**. The Kubernetes API server has a separate SLA.
- **Data plane**. Node pools use the underlying VM SKU SLAs. 
- **Availability zones**. There are different SLAs for the two planes, depending on whether the AKS cluster has availability zones enabled *and* running multiple instances across availability zones.

Note that when you use multiple Azure services, [composite SLOs](/azure/well-architected/reliability/metrics#define-composite-slo-targets) might differ from and be lower than individual service SLAs.

### Redundancy with availability zones

[Availability zones](/azure/reliability/availability-zones-overview#availability-zones) are distinct datacenters that have independent electric power, cooling, and so on, within a single region. The resulting redundancy increases the tolerance of failures without requiring you to implement multi-region architectures.

Azure has availability zones in every country/region in which Azure operates a datacenter region. To allow multiple instances of containers to cross availability zones, be sure to select SKUs, service tiers, and regions that provide availability zone support.

| Feature| Container Apps | AKS | Web App for Containers |
|---|--|--|--|
| **Availability zone support** | Full | Full | Full |

For example, an application or infrastructure that's configured to run a single instance becomes unavailable if a problem occurs in the availability zone where the hardware is hosted. To fully use availability zone support, you should deploy workloads with a minimum configuration of three instances of the container, spread across zones.

### Health checks and self-healing

Health check endpoints are crucial to a reliable workload. But building those endpoints is only half of the solution. The other half is controlling what the hosting platform does, and how, when there are failures.

To better distinguish among types of health probes, take a look at the built-in types of [probes from Kubernetes](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/):

- **Startup**. Checks whether the application successfully started.
- **Readiness**. Checks whether the application is ready to handle incoming requests.
- **Liveness**. Checks whether the application is still running and responsive.

Another important consideration is how often those health checks are requested from the application (internal granularity). If you have a long interval between these requests, you might continue to serve traffic until the instance is deemed unhealthy.

Most applications support health checks via the HTTP(S) protocol. However, some might need other protocols, like TCP or gRPC, to perform those checks. Keep this in mind when you design your health check system.

| | [Container Apps](/azure/container-apps/health-probes)| AKS| [Web App for Containers](/azure/app-service/monitor-instances-health-check)|
|---|--|--|--|
| **Startup probes** | ✅ | ✅ | Partial support |
| **Readiness probes** | ✅ | ✅ | ❌ |
| **Liveness probes** | ✅ | ✅ | ✅ |
| **Interval granularity** | Seconds | Seconds | 1 minute |
| **Protocol support** | HTTP(S)<br>TCP | HTTP(S)<br>TCP<br>gRPC | HTTP(S) |

Health checks are easiest to [implement in Web App for Containers](/azure/app-service/monitor-instances-health-check#enable-health-check). There are some important considerations:

- Its startup probes are built in and can't be changed. It sends an HTTP request to the starting port of your container. Any response from your application is considered a successful start.
- It doesn't support readiness probes. If the startup probe is successful, the container instance is added to the pool of healthy instances.
- It sends the health check at one-minute intervals. You can't change the interval.
- The minimum threshold that you can set for an unhealthy instance to be removed from the internal load balancing mechanism is two minutes. The unhealthy instance gets traffic for at least two minutes after it fails a health check. The default value for this setting is 10 minutes.

Container Apps and AKS, on the other hand, are much more flexible and offer similar options. In terms of specific differences, AKS provides the following options for performing health checks, which are not available in Container Apps:

- [gRPC support](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/#define-a-grpc-liveness-probe)
- [Named ports](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/#use-a-named-port)
- [Exec commands](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/#define-a-liveness-command)

#### Auto-healing

To identify a bad container instance and stop sending traffic to it is a start. The next step is to implement auto-healing. *Auto-healing* is the process of restarting the application in an attempt to recover from an unhealthy state. Here's how the three container services compare:

- In Web App for Containers, there's no option to restart a container instance immediately after a [health check fails](/azure/app-service/monitor-instances-health-check#what-app-service-does-with-health-checks). If the instance keeps failing for one hour, it's replaced by a new instance. There's another feature, called [auto-healing](/azure/app-service/overview-diagnostics#auto-healing), that monitors and restarts instances. It's not directly related to health checks. It uses various application metrics, like memory limits, HTTP request duration, and status codes.
- Container Apps and AKS automatically try to restart a container instance if the liveness probe reaches the defined failure threshold.

### Zero-downtime application deployments

The ability to deploy and replace applications without causing any downtime for users is crucial for a reliable workload. All three of the container services that are described in this article support zero-downtime deployments, but in different ways.

| | Container Apps| AKS| Web App for Containers|
|---|--|--|--|
| **Zero-downtime strategy** | [Rolling update](/azure/container-apps/revisions#zero-downtime-deployment) | [Rolling update, plus all other Kubernetes strategies](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#strategy) | [Deployment slots](/azure/app-service/deploy-staging-slots) |

Please note that the application architectures must also support zero-downtime deployment. See [Azure Well-Architected Framework](/azure/well-architected/) for guidance.

### Resource limits

Another important component of a reliable shared environment is your control over the resource usage (like CPU or memory) of your containers. You need to avoid scenarios in which a single application takes up all the resources and leaves other applications in a bad state.

| | Container Apps| AKS| Web App for Containers|
|---|--|--|--|
| **Resource limits (CPU or memory)** | Per app/container | Per app/container<br>Per namespace | Per App Service plan |

- **Web App for Containers**: You can host multiple applications (containers) in a single App Service plan. For example, you might allocate a plan with two CPU cores and 4 GiB of RAM in which you can run multiple web apps in containers. You can't, however, restrict one of the apps to a certain amount of CPU or memory. They all compete for the same App Service plan resources. If you want to isolate your application resources, you need to create additional App Service plans.
- **Container Apps**: You can set CPU and memory limits per application in your environment. You're restricted, however, to a set of [allowed combinations of CPU and memory](/azure/container-apps/containers#configuration). For example, you can't configure one vCPU and 1 GiB of memory, but you can configure one vCPU and 2 GiB of memory. A Container Apps environment is analogous to a Kubernetes namespace.
- **AKS**: You can choose [any combination of vCPU and memory](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/), as long as your nodes have the hardware to support it. You can also limit resources at the [namespace level](https://kubernetes.io/docs/tasks/administer-cluster/manage-resources/quota-memory-cpu-namespace/) if you want to segment your cluster that way.

### Well-Architected Framework for Reliability

This article focuses on the main differences among the container services features in Azure. If you want to review the complete reliability guidance for a specific service, see these articles:

- [Well-Architected Framework review for AKS](/azure/well-architected/service-guides/azure-kubernetes-service)
- [Reliability in Container Apps](/azure/reliability/reliability-azure-container-apps)
- [Azure App Service and reliability](/azure/well-architected/service-guides/azure-app-service/reliability)

## Conclusion

Well-architected solutions set the foundations for successful workloads. Although architectures can be adjusted as a workload grows and teams progress on their cloud journeys, some decisions, especially around networking, are difficult to reverse without significant downtime or re-deployment.

In general, when you compare Azure container services, a theme emerges: AKS surfaces the most underlying infrastructure, thus offering the greatest control and configurability, while AKS Automatic offers a balance between control and simplicity by automating many operational tasks. 

The amount of operational overhead and complexity is highly variable for AKS workloads. Some teams can greatly reduce the operational overhead by using Microsoft managed add-ons and extensions, as well as auto-upgrade features. Other customers may prefer full control of the cluster in order to leverage full extensibility of Kubernetes and the CNCF ecosystem. For example, although Microsoft offers Flux as a managed GitOps extension, many teams choose instead to setup and operate ArgoCD on their own.

Workload teams that, for example, do not require CNCF applications, have less operations experience or prefer to focus on application features might prefer a PaaS offering. We recommend that they first consider Container Apps.

Although Container Apps and Web App for Containers are both PaaS offerings that provide similar levels of Microsoft-managed infrastructure, a key difference is that Container Apps is closer to Kubernetes and provides additional cloud-native capabilities for service discovery, event-driven autoscaling, [Dapr](https://dapr.io/) integration, and more. However, teams that don't need these capabilities and are familiar with App Service networking and deployment models might prefer Web App for Containers. 

Generalizations can help you narrow down the list of Azure container services to consider. But keep in mind that you also need to verify your choice by examining individual requirements in detail and matching them to service-specific feature sets.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Andre Dewes](https://www.linkedin.com/in/andre-dewes-480b5b62/) | Senior Customer Engineer
- [Xuhong Liu](https://www.linkedin.com/in/xuhong-l-5937159b/) | Senior Service Engineer
- [Marcos Martinez](https://www.linkedin.com/in/marcosmarcusm/) | Senior Service Engineer  
- [Julie Ng](https://www.linkedin.com/in/julie-io/) | Senior Engineer 

Other contributors:

- [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414/) | Technical Writer 
- [Martin Gjoshevski](https://www.linkedin.com/in/martin-gjoshevski/) | Senior Customer Engineer
- [Don High](https://www.linkedin.com/in/donhighdevops/) |  Principal Customer Engineer
- [Nelly Kiboi](https://www.linkedin.com/in/nellykiboi/)  | Service Engineer 
- [Faisal Mustafa](https://www.linkedin.com/in/faisalmustafa/) |  Senior Customer Engineer
- [Walter Myers](https://www.linkedin.com/in/waltermyersiii/) | Principal Customer Engineering Manager
- [Sonalika Roy](https://www.linkedin.com/in/sonalika-roy-27138319/) | Senior Customer Engineer
- [Paolo Salvatori](https://www.linkedin.com/in/paolo-salvatori/) |  Principal Customer Engineer
- [Victor Santana](https://www.linkedin.com/in/victorwelascosantana/) |  Principal Customer Engineer

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [AKS documentation](/azure/aks/)
- [Container Apps documentation](/azure/container-apps/)
- [App Service documentation](/azure/app-service/)

## Related resources

- [AKS - Plan your design and operations](../reference-architectures/containers/aks-start-here.md)
- [Deploy microservices with Azure Container Apps](../example-scenario/serverless/microservices-with-container-apps.yml)
