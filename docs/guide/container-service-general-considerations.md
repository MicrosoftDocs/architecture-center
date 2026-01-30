---
title: Architectural Considerations for Choosing an Azure Container Service
description: Get a quick overview of common feature-level considerations that can help you choose an Azure container service. Part two of a series.
author: r-kayongo
ms.author: rkayongo
ms.date: 06/20/2025
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom: arb-containers
---

# Architectural considerations for choosing an Azure container service

This article describes how to choose an Azure container service. It provides an overview of feature-level considerations that are common and critical for some workloads. It can help you make decisions to ensure that your workload meets requirements for reliability, security, cost optimization, operational excellence, and performance efficiency.

> [!NOTE]
> This article is part two in a series. We strongly recommend that you read [part one](choose-azure-container-service.md) first to get context for these architectural considerations.

## Overview

The considerations in this article are divided into the following four categories:

[Architectural and network considerations](#architectural-considerations)

- Operating system (OS) support
- Network address space
- Traffic flow analysis
- Subnet planning  
- Available ingress IP addresses
- User-defined routes (UDRs) and NAT gateway support
- Private networking integration
- Protocol coverage
- Load balancing
- Service discovery
- Custom domains and managed Transport Layer Security (TLS)
- Mutual TLS (mTLS)
- Advanced container networking for Azure Kubernetes Service (AKS)
- Networking concepts for specific Azure services

[Security considerations](#security-considerations)

- Network policies for intra-cluster traffic security 
- Network security groups (NSGs)
- Azure Key Vault integration
- Managed identity support
- Threat protection and vulnerability assessments with Microsoft Defender for Containers
- Security baselines
- Azure Well-Architected Framework for security

[Operational considerations](#operational-considerations)

- Updates and patches
- Container image updates
- Vertical infrastructure scalability
- Horizontal infrastructure scalability
- Application scalability
- Observability
- Well-Architected Framework for operational excellence

[Reliability considerations](#reliability)

- Service-level agreements (SLAs)
- Redundancy through availability zones
- Health checks and self-healing
- Zero-downtime application deployments
- Resource limits
- Well-Architected Framework for reliability

This article focuses on a subset of Azure container services that provide a mature feature set for web applications and APIs, networking, observability, developer tools, and operations. These services include AKS, AKS Automatic, Azure Container Apps, and Web App for Containers. For a full list of Azure container services, see [Container services](https://azure.microsoft.com/products/category/containers/).

> [!NOTE]
> Some sections differentiate AKS Standard from AKS Automatic. If no differences are mentioned in a section, you can assume that it has the same features as the other deployment models.

## Architectural considerations

This section covers architectural decisions that are difficult to reverse or correct without significant downtime or redeployment. It's especially important to carefully evaluate fundamental components like networking and security before you finalize them.

These considerations aren't specific to Well-Architected Framework pillars. However, they require extra scrutiny and evaluation against business requirements when you choose an Azure container service.

> [!NOTE]
> AKS Automatic takes a more opinionated approach than AKS Standard, which means that it has some built-in features that can't be turned off. This guide doesn't describe those features. For more information, see [AKS Automatic and Standard feature comparison](/azure/aks/intro-aks-automatic#aks-automatic-and-standard-feature-comparison).

### OS support

Most containerized applications run in Linux containers, which all Azure container services support. However, options are more limited for workload components that require Windows containers.

| Feature | Container Apps | AKS | AKS Automatic | Web App for Containers |
|---|---|---|---|---|
| Linux support      | ✅ | ✅ | ✅ | ✅  |
| Windows support    | ❌ | ✅ | ❌ | ✅  |
| Mixed OS support   | ❌ | ✅ | ❌ | ❌* |

*Requires separate Azure App Service plans for Windows and Linux

## Networking considerations

It's important to understand networking design early in your planning processes because of security and compliance constraints and imposed guidelines. In general, the key differences among the Azure services covered in this guide depend on your preference. Consider the following services:

- [Container Apps](https://azure.microsoft.com/products/container-apps) is a platform as a service (PaaS) offering that provides Azure-managed networking features like service discovery, internal managed domains, and virtual network controls.

- [AKS](https://azure.microsoft.com/products/kubernetes-service/) is the most configurable of the three services and provides the most control over network flow. For example, AKS provides custom ingress controllers and the control of intra-cluster traffic via Kubernetes network policies. Workload teams can take advantage of various Azure-managed [networking add-ons](/azure/aks/integrations) and install and operate any add-ons from the Kubernetes ecosystem.

- [Web App for Containers](https://azure.microsoft.com/products/app-service/containers/) is feature of [App Service](/azure/well-architected/service-guides/app-service-web-apps). Its networking model, especially for private network integration, closely follows the architecture of App Service. This architecture is familiar to workload teams that use App Service. For teams without prior App Service experience that prefer a more conventional Azure virtual network integration, we recommend Container Apps.

Networking is a foundational infrastructure layer. It's often difficult to make changes in design without redeploying the workload, which can result in downtime. If your workload has specific networking requirements, review this section carefully before you narrow down your Azure container service selection.

### Network address spaces

When you integrate applications into virtual networks, you need to plan IP addresses to ensure that container instances have enough. During this process, allocate extra IP addresses to accommodate updates, blue-green deployments, and similar scenarios. These events might temporarily deploy extra instances that use more addresses than usual.

| Feature or requirement | Container Apps | AKS | Web App for Containers |
|---|---|---|---|
| Dedicated subnets | - Consumption plan: optional <br><br> - Dedicated plan: required | Required | Optional |
| IP address requirements | - Consumption plan. See [Consumption-only environment](/azure/container-apps/networking#subnet).<br><br> - Dedicated plan. See [Workload profiles environment](/azure/container-apps/networking#subnet). | See [Azure virtual networks for AKS](/azure/aks/concepts-network). | See [App Service subnet requirements](/azure/app-service/overview-vnet-integration). |

AKS requirements depend on your chosen network plug-in. Some network plug-ins for AKS require broader IP address reservations. That information is beyond the scope of this article. For more information, see [Networking concepts for AKS](/azure/aks/concepts-network).

### Understand traffic flow

The types of traffic flow required for a solution can affect the network design.

The following sections describe various networking constraints. These constraints influence whether you need to deploy extra subnets, depending on your requirements for the following configurations:

- Multiple colocated workloads

- Private ingress, public ingress, or both

- An access-controlled flow of east-west traffic in a cluster for Container Apps and AKS, or within a virtual network for all Azure container services

### Subnet planning

A subnet must be large enough to include application instances, but capacity isn't the only factor that determines the network footprint for deploying these workloads.

| Capability | Container Apps | AKS | Web App for Containers |
|---|---|---|---|
| Support for colocated workloads within a subnet* | ❌* | ✅ | Not available* |

*A best practice, not a technical limitation

For Container Apps, subnet integration applies only to a single Container Apps environment. Each Container Apps environment is constrained to a single ingress IP address, either public or private.

Each Container Apps environment is meant only for a single workload in which dependent applications are colocated. Therefore, you need to introduce extra Azure networking appliances for ingress load balancing if you need both public and private ingress. Examples include Azure Application Gateway and Azure Front Door. If multiple workloads require segregation, you must provision extra Container Apps environments and allocate a separate subnet for each environment.

AKS provides granular east-west network flow control within the cluster via Kubernetes network policy. This flow control enables you to segment multiple workloads with different network security boundaries within the same cluster.

For Web App for Containers, there are no constraints on the number of apps that you can integrate with a single subnet if the subnet has sufficient capacity. There are no best practices for access control between web apps in the same virtual network. Each web app independently manages access control for east-west or north-south traffic from the virtual network or internet, respectively.

> [!NOTE]
> You can't resize subnets that have resources deployed in them. Carefully plan your network to avoid redeploying entire workload components, which can result in downtime.

### Ingress IP address availability

The following table incorporates the previous subnet planning section to define the number of IP addresses that can be exposed. It applies to an arbitrary number of applications hosted within a single deployment of an Azure container service.

| Capability | Container Apps | AKS | Web App for Containers |
|---|---|---|---|
| The number of ingress IP addresses | One | Many | - App Service environment: One<br><br> - No App Service environment: Many |

Container Apps supports one IP address for each environment, either public or private. AKS supports any number of public or private IP addresses. Web App for Containers, when used outside an App Service environment, allows one public IP address for each App Service plan and multiple distinct private IP addresses via Azure private endpoints.

Keep in mind that web apps that are integrated into an App Service environment only receive traffic through the single ingress IP address that's associated with the App Service environment, whether it's public or private.

### UDRs and NAT gateway support

If a workload requires UDRs and NAT gateway capabilities for granular networking control, Container Apps requires the use of [workload profiles](/azure/container-apps/workload-profiles-overview). UDR and NAT gateway compatibility isn't available in the consumption-only plan for Container Apps.

AKS and Web App for Containers implement these two networking features through standard virtual network functionality or virtual network integration, respectively. AKS node pools and Web App for Containers in an App Service environment are already direct virtual network resources. Web App for Containers that aren't in an App Service environment support UDRs and NAT gateway via [virtual network integration](/azure/app-service/overview-vnet-integration). With virtual network integration, the resource technically doesn't reside directly in the virtual network. However, all of its outbound access flows through the virtual network, and the network's associated rules affect traffic as expected.

| Capability | Container Apps | AKS | Web App for Containers |
|---|---|---|---|
| UDR support | - Consumption-only plan: ❌<br><br> - Workload profile plan: ✅ | ✅ | ✅ |
| NAT gateway support | - Consumption-only plan: ❌<br><br> - Workload profile plan: ✅ | ✅ | ✅ |

### Private networking integration

For workloads that require strict Layer 4 private networking for both ingress and egress, you should consider Container Apps, AKS, and the single-tenant App Service environment SKU, where workloads are deployed into a self-managed virtual network. This deployment provides customary granular private networking controls.

| Networking capability | Container Apps | AKS | Web App for Containers |
|---|---|---|---|
| Private ingress into a virtual network | ✅ | ✅ | Via [private endpoint](/azure/app-service/networking/private-endpoint) |
| Private egress from a virtual network | ✅ | ✅ | Via [virtual network](/azure/app-service/overview-vnet-integration) integration |
| Fully suppressed public endpoint | ✅ | ✅ | [An App Service environment only](/azure/app-service/environment/networking#addresses) |

##### Private networking with Web App for Containers

Web App for Containers provides extra networking capabilities that aren't presented in the same way as other Azure services covered in this article. To implement strict private networking requirements, workload teams should become familiar with these networking concepts. Carefully review the following networking features:

- [Private endpoints](/azure/private-link/private-endpoint-overview)
- [Virtual network integration](/azure/app-service/overview-vnet-integration)

If you want a PaaS solution and prefer networking concepts that are shared across multiple Azure solutions, consider Container Apps.

### Protocol coverage

An important consideration for the hosting platform is the networking protocols that are supported for incoming application requests (ingress). Web App for Containers is the strictest option and only [supports HTTP and HTTPS](/azure/app-service/networking-features#app-service-ports). Container Apps also [allows incoming Transmission Control Protocol (TCP) connections](/azure/container-apps/ingress-overview). AKS is the most flexible and supports unconstrained use of TCP and User Datagram Protocol (UDP) on self-selected ports.

| Network and protocol support | Container Apps| AKS | Web App for Containers |
|---|---|---|---|
| Protocol and port support | - HTTP (port 80)* <br><br> - HTTPS (port 443)*<br><br> - TCP (ports 1 to 65535, except 80 and 443) | - TCP (any port)<br><br> - UDP (any port) | - HTTP (port 80)<br><br>- HTTPS (port 443) |
| WebSocket support | ✅ | ✅ | ✅ |
| HTTP/2 support | ✅ | ✅ | ✅ |

*In the Container Apps environment, [HTTP or HTTPS can be exposed on any port](/azure/container-apps/ingress-overview#additional-tcp-ports) for intra-cluster communication. In that scenario, built-in Container Apps HTTP features like cross-origin resource sharing and session affinity don't apply.

Both Container Apps and Web App for Containers support TLS 1.2 for their built-in HTTPS ingress.

### Load balancing

With Container Apps and Web App for Containers, Azure fully abstracts the Layer 4 and Layer 7 load balancers.

In contrast, AKS uses a shared responsibility model. In this model, Azure manages the underlying Azure infrastructure that the workload team configures by interfacing with the Kubernetes API. For Layer 7 load balancing in AKS, you can choose an Azure-managed option, such as the [AKS-managed application routing add-on](/azure/aks/app-routing), [Application Gateway for Containers](/azure/application-gateway/for-containers/overview), or deploy and self-manage an ingress controller of your choice.

| Load balancer | Container Apps | AKS | Web App for Containers |
|---|---|---|---|
| Layer 4 load balancer | Azure-managed | Shared responsibility | Azure-managed |
| Layer 7 load balancer | Azure-managed | Shared or self-managed | Azure-managed |

### Advanced Container Networking Services for AKS

Advanced Container Networking Services (ACNS) equips AKS with advanced networking capabilities that go beyond what's available in Container Apps or Web App for Containers. These capabilities provide powerful observability and enhanced security designed for dynamic, containerized environments.

- **Container network observability:**

  ACNS uses Hubble's control plane to deliver intuitive, in-depth insights into network behavior. With easy-to-consume node-level and pod-level metrics and comprehensive flow logs, you can quickly pinpoint problems and optimize performance. This built-in observability reduces the need for external monitoring setups and lowers the learning curve typically associated with Kubernetes network diagnostics.

- **Container network security:**

  For clusters that use Azure Container Networking Interface powered by Cilium, ACNS provides fully qualified domain name (FQDN) filtering. Instead of managing static, IP address-based security policies, you can define policies based on domain names. This dynamic approach simplifies policy management and also aligns with modern, zero trust security models. This approach makes it easier for you to enforce robust security without constant manual updates.

For more information, see the following resources:

- [What is container network observability?](/azure/aks/container-network-observability-guide)
- [What is container network security?](/azure/aks/container-network-security-concepts)

### Service discovery

In cloud architectures, runtimes can be removed and recreated at any time to rebalance resources, so instance IP addresses regularly change. These architectures use FQDNs for reliable and consistent communication.

| Service discovery mechanism | Container Apps | AKS | Web App for Containers |
|---|---|---|---|
| Service discovery | Azure-managed FQDN | Kubernetes configurable | Azure-managed FQDN |

Web App for Containers provides public ingress (north-south communication) FQDNs by default. No extra DNS configuration is required. However, there's no built-in mechanism to facilitate or restrict traffic between other apps (east-west communication).

Container Apps also provides public ingress FQDNs. However, Container Apps goes further by allowing the app FQDN to be exposed and [restricting traffic only within the environment](/azure/container-apps/networking). This functionality makes it easier to manage east-west communication and enable components like Dapr.

Kubernetes deployments aren't inherently discoverable from within or outside the cluster. To expose applications to the network in an addressable way, you must define and create Kubernetes services as specified by the Kubernetes API.

> [!IMPORTANT]
> Only Container Apps and AKS provide service discovery through internal Domain Name System (DNS) schemes within their respective environments. This functionality can simplify DNS configurations across dev/test and production environments. For example, you can create these environments with arbitrary service names that have to be unique only within the environment or cluster. They can be the same across dev/test and production environments. With Web App for Containers, service names must be unique across different environments to avoid conflicts with Azure DNS.

### Custom domains and managed TLS

Both Container Apps and Web App for Containers provide built-in solutions for custom domains and certificate management.

| Custom domain and TLS support | Container Apps | AKS | Web App for Containers |
|---|---|---|---|
| Configure custom domains | Default feature | Bring your own (BYO) | Default feature |
| Managed TLS for Azure FQDNs | Default feature | Not available | Default feature |
| Managed TLS for custom domains | Default feature | BYO | Default feature or BYO |

AKS users are responsible for managing DNS, cluster configurations, and TLS certificates for their custom domains. AKS doesn't provide managed TLS, but customers can use software from the Kubernetes ecosystem, such as [cert-manager](https://www.cncf.io/projects/cert-manager/), to manage TLS certificates.

### mTLS

Another alternative for restricting incoming traffic is mTLS. This security protocol ensures that both the client and server in communication are authenticated. To accomplish authentication, both parties exchange and verify certificates before any data is transmitted.

Web App for Containers has built-in mTLS support for incoming client connections. However, the application needs to validate the certificate by [accessing the `X-ARR-ClientCert` HTTP header](/azure/app-service/app-service-web-configure-tls-mutual-auth#access-the-client-certificate) that the App Service platform forwards.

Container Apps also has built-in support for mTLS. It forwards the client certificate to the application in the HTTP header [X-Forwarded-Client-Cert](/azure/container-apps/client-certificate-authorization). You can also easily enable [automatic mTLS for internal communication between apps](/azure/container-apps/mtls) in a single environment.

You can implement mTLS in AKS through the [Istio-based service mesh as a managed add-on](/azure/aks/istio-about). This add-on includes mTLS capabilities for incoming client connections and intra-cluster communication between services. Workload teams can also choose to install and manage another service mesh offering from the Kubernetes ecosystem. These options make mTLS implementation in Kubernetes the most flexible.

### Service-specific networking concepts

The preceding sections describe some of the most common considerations to take into account for network design. For more information about networking features that are specific to individual Azure container services, see the following articles:

- [Networking in Container Apps](/azure/container-apps/networking)
- [App Service networking features](/azure/app-service/networking-features)

The preceding sections focus on network design. Continue to the next section to learn more about networking security and securing network traffic.

## Security considerations

Failure to address security risks can result in unauthorized access, data breaches, or leaks of sensitive information. Containers provide an encapsulated environment for your application. However, the hosting systems and underlying network overlays require extra guardrails. Your choice of Azure container service needs to support your specific requirements for securing each application individually and provide proper security measures to prevent unauthorized access and mitigate the risk of attacks.

### Security comparison overview

Most Azure services, including Container Apps, AKS, and Web App for Containers, integrate with key security offerings, including Key Vault and managed identities.

Of the services in this guide, AKS provides the most configurability and extensibility in part by surfacing underlying components, which often can be secured by using configuration options. For example, you can use configuration options to disable local accounts to the Kubernetes API server or turn on automatic updates to underlying nodes.

AKS Automatic clusters come with a hardened default configuration and have many cluster, application, and networking security settings enabled by default. These initial configurations don't only reduce deployment time but also give users a standardized configuration that's prevalidated. This configuration gives users a solid foundation for day-2 operational responsibilities. This foundation helps shorten the learning curve of long-term cluster management for teams that are new to the technology.

For a detailed comparison, carefully review the following considerations to ensure that your workload security requirements can be met.

### Kubernetes control plane security

AKS provides the most flexibility of the three options considered in this article. It provides full access to the Kubernetes API so that you can customize container orchestration. However, this access to the Kubernetes API also represents a significant attack surface that you need to secure.

> [!IMPORTANT]
> This section isn't relevant for Web App for Containers, which uses the Resource Manager API as its control plane.

#### Identity-based security

You're responsible for securing identity-based access to the API. Kubernetes provides its own authentication and authorization management system. This system needs to be secured with access controls.

To take advantage of a single plane of glass for identity and access management on Azure, it's a best practice to [disable Kubernetes-specific local accounts](/azure/aks/manage-local-accounts-managed-azure-ad) and instead [implement AKS-managed Microsoft Entra integration](/azure/aks/enable-authentication-microsoft-entra-id) together with [Azure role-based access control (Azure RBAC) for Kubernetes](/azure/aks/manage-azure-rbac). If you implement this best practice, administrators don't need to perform identity and access management on multiple platforms.

| Kubernetes API access | Container Apps | AKS |
|---|---|---|
| Kubernetes API access controls | No access | Full access |

You don't have access to the Kubernetes API if you use Container Apps. Microsoft provides security for this API.

#### Network-based security

If you want to restrict network access to the Kubernetes control plane, you need to use AKS, which provides two options. The first option is to use [private AKS clusters](/azure/aks/private-clusters#create-a-private-aks-cluster), which use Azure Private Link between the API server's private network and the AKS cluster's private network. The second option is [API server virtual network integration](/azure/aks/api-server-vnet-integration) where the API server is integrated into a delegated subnet.

There are consequences to implementing network-restricted access to the Kubernetes API. Most notably, management can be performed only from within the private network. Typically, you need to deploy self-hosted agents for Azure DevOps or GitHub Actions. To learn about other limitations, see the product-specific documentation.

| Kubernetes API access control | Container Apps | AKS |
|---|---|---|
| Kubernetes API network security | Not configurable in PaaS | Configurable by using a public or private IP address |

ACNS enhances data plane security in AKS. For clusters that use Azure Container Networking Interface powered by Cilium, ACNS introduces container network security through FQDN filtering. Instead of managing static, IP address-based security policies, you can define dynamic policies based on FQDNs. This approach simplifies policy management, reduces administrative overhead, and supports a zero trust model by ensuring that only traffic to trusted domains is allowed.

> [!NOTE]
> ACNS security features require Kubernetes version 1.29 or later and are available only on clusters that use the Cilium data plane.

These considerations don't apply to Container Apps. Because it's PaaS, Microsoft abstracts the underlying infrastructure.

### Data plane network security

The following networking features can be used to control access to, from, and within a workload.

#### Network policies for intra-cluster traffic security

Some security postures require network traffic segregation *within* an environment. For example, this segregation is often necessary when you use multitenant environments to host multiple or multiple-tiered applications. In these scenarios, select AKS and implement [network policies](/azure/aks/use-network-policies), which are cloud-native features that enable granular configuration of Layer 4 networking within Kubernetes clusters.

| Network policy support | Container Apps | AKS | Web App for Containers |
|---|---|---|---|
| Network policies | Consumption plan: ❌<br><br> Dedicated plan: ❌ | ✅ | ❌ |

Of the three Azure services described in this article, AKS is the only service that supports further workload isolation within the cluster. Network policies aren't supported in Container Apps or Web App for Containers.

#### NSGs

In all scenarios, you can regulate networking communication within the wider virtual network by using NSGs. This approach enables you to use Layer 4 traffic rules that regulate both ingress and egress at the virtual network level.

| NSG support | Container Apps | AKS | Web App for Containers |
|---|---|---|---|
| NSGs | - Consumption plan: ✅<br><br> - Dedicated plan: ✅ | ✅ | ✅ Virtual network-integrated apps, egress only |

#### Built-in IP address restrictions for ingress

Container Apps and Web App for Containers provide built-in source IP address restrictions for ingress traffic for individual applications. AKS can achieve the same functionality but requires Kubernetes-native functionality through the [Kubernetes service api-resource](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.31/#service-v1-core) where you can set values for *loadBalancerSourceRanges*.

| Network access control and resource impact | Container Apps | AKS | Web App for Containers |
|---|---|---|---|
| Built-in ingress IP address restrictions | ✅ | ❌ | ✅ |
| Resource consumption | - | Consumes cluster resources | - |

> [!NOTE]
> AKS supports ingress IP address restrictions, but you use Kubernetes-native features to implement this capability rather than Azure-native controls, unlike other Azure services.

## Application-level security

You need to secure workloads not only at the network and infrastructure level, but also at the workload and application level. Azure container solutions integrate with Azure security offerings to help standardize security implementation and controls for your applications.

### Key Vault integration

It's a best practice to store and manage secrets, keys, and certificates in a key management solution like Key Vault to provide enhanced security for these components. Instead of storing and configuring secrets in code or in an Azure compute service, all applications should integrate with Key Vault.

Key Vault integration enables application developers to focus on their application code. All three of the Azure container services described in this article can automatically synchronize secrets from the Key Vault service and provide them to the application, typically as environment variables or mounted files.

| Secrets integration | Container Apps | AKS | Web App for Containers |
|---|---|---|---|
| Key Vault integration | ✅ | ✅ | ✅ |

For more information, see the following resources:

- [Manage secrets in Container Apps](/azure/container-apps/manage-secrets?tabs=azure-portal#reference-secret-from-key-vault)
- [Integrate Key Vault with AKS](/azure/aks/csi-secrets-store-driver)
- [Use Key Vault references as app settings in App Service](/azure/app-service/app-service-key-vault-references)

### Managed identity support

Applications can use managed identities to authenticate to Microsoft Entra ID protected services without having to use keys or secrets. Container Apps and Web App for Container provide built-in, Azure-native support for application-level managed identity. Application-level managed identity support for AKS is achieved through [Microsoft Entra Workload ID](/azure/aks/workload-identity-overview). AKS also requires infrastructure-related managed identity to allow cluster operations for the Kubelet, control plane, and various AKS add-ons.

| Managed identity report | Container Apps | AKS | Web App for Containers |
|---|---|---|---|
| Infrastructure-managed identity support | Not available | ✅ | Not available |
| Container-pull managed identity support | ✅ | ✅ | ✅ |
| Application-managed identity support | ✅ | ✅ | ✅ |

For more information, see the following resources:

- [Use a managed identity in AKS](/azure/aks/use-managed-identity)
- [Workload ID with AKS](/azure/aks/workload-identity-overview)
- [Managed identities in Container Apps](/azure/container-apps/managed-identity)
- [Managed identities for App Service](/azure/app-service/overview-managed-identity)

### Threat protection and vulnerability assessments with Defender for Containers

Threat protection against vulnerabilities is also important. It's a best practice to use [Defender for Containers](/azure/defender-for-cloud/defender-for-containers-introduction). Vulnerability assessments are supported in Azure container registries. As a result, any Azure container service can use them, not only the ones described in this article. However, Defender for Containers runtime protection is only available for AKS.

As AKS exposes the native Kubernetes API, cluster security can also be evaluated with Kubernetes-specific security tooling from the Kubernetes ecosystem.

| Security features | Container Apps | AKS | Web App for Containers |
|---|---|---|---|
| Runtime threat protection | ❌ | ✅ | ❌ |

For more information, see [Containers support matrix in Microsoft Defender for Cloud](/azure/defender-for-cloud/support-matrix-defender-for-containers).

Container image vulnerability assessments aren't real-time scans. The Azure container registry is scanned at regular intervals.

## Security baselines

Most Azure container services typically integrate Azure security offerings. Keep in mind that a security feature set is only a small part of implementing cloud security. For more information about how to implement security for container services, see the following service-specific security baselines:

- [Azure security baseline for Container Apps](/security/benchmark/azure/baselines/azure-container-apps-security-baseline)
- [Azure security baseline for AKS](/security/benchmark/azure/baselines/azure-kubernetes-service-aks-security-baseline)
- [Azure security baseline for App Service](/security/benchmark/azure/baselines/app-service-security-baseline)

> [!NOTE]
> AKS Automatic clusters are configured with [specific security settings](/azure/aks/intro-aks-automatic#security-and-policies). Ensure that those settings are aligned with your workload needs.

## Well-Architected Framework for security

This article focuses on key differences among container service features.

For more complete security guidance about AKS, see [AKS best practices](/azure/well-architected/service-guides/azure-kubernetes-service).

## Operational considerations

To successfully run a workload in production, you need to implement operational excellence practices, including centralized logging, monitoring, scalability, regular updates and patching, and image management.

### Updates and patches

It's important that an application's underlying OS is updated and regularly patched. However, every update poses a failure risk. This section and the next section describe the key considerations for the three container services regarding the shared responsibility between the customer and the platform.

As a managed Kubernetes service, AKS provides the updated images for the node OS and control plane components. But workload teams are responsible for applying updates to their clusters. You can manually trigger updates or use the [cluster automatic-upgrade channels](/azure/aks/auto-upgrade-cluster) feature to ensure that your clusters are up-to-date. For more information about the AKS day-2 operations guide, see [Patch and upgrade AKS clusters](/azure/architecture/operator-guides/aks/aks-upgrade-practices).

Container Apps and Web App for Containers are PaaS solutions. Azure is responsible for managing updates and patches, so you can avoid the complexity of AKS upgrade management.

| Update responsibility | Container Apps | AKS | AKS Automatic | Web App for Containers |
|---|---|---|---|---|
| Control plane updates | Platform | [Customer](/azure/aks/upgrade-cluster) | Platform | Platform |
| Host updates and patches | Platform | [Customer](/azure/aks/node-image-upgrade) | Platform | Platform |
| Container image updates and patches | Customer | Customer | Customer | Customer |

### Container image updates

Regardless of the Azure container solution, you're responsible for your own container images. If there are security patches for container base images, it's your responsibility to rebuild your images. To get alerts about these vulnerabilities, use [Defender for Containers](/azure/defender-for-cloud/defender-for-containers-introduction) for Azure Container Registry containers.

## Scalability

Scaling is used to adjust resource capacity to meet demands. It adds more capacity to ensure performance and removes unused capacity to save money. When you choose a container solution, you need to consider infrastructure constraints and scaling strategies.

### Vertical infrastructure scalability

*Vertical scaling* refers to the ability to increase or decrease existing infrastructure, like compute CPU and memory. Different workloads require different amounts of compute resources. When you choose an Azure container solution, you need to be aware of the hardware SKU offerings that are available for a specific Azure service. These offerings vary and can impose extra constraints.

For AKS, review the [sizes for virtual machines (VMs) in Azure](/azure/virtual-machines/sizes) documentation and the [AKS restrictions for each region](/azure/aks/quotas-skus-regions).

The following articles provide details about SKU offerings for Container Apps and App Service:

- [Workload profiles in Container Apps](/azure/container-apps/workload-profiles-overview)
- [App Service pricing](https://azure.microsoft.com/pricing/details/app-service/linux/)

### Horizontal infrastructure scalability

*Horizontal scaling* refers to the ability to increase or decrease capacity by adding or removing infrastructure components, like VM nodes. During scaling increases or decreases, the Container Apps Consumption tier abstracts the underlying VMs. For the remaining Azure container services, you manage the horizontal scaling strategy by using the standard Resource Manager API.

Scaling out and in includes rebalancing instances, so it creates a risk of downtime. The risk is smaller than the corresponding risk with vertical scaling. Regardless, you're responsible for ensuring that your applications can handle failure. You're also responsible for implementing graceful startups and shutdowns of your applications to avoid downtime.

| Infrastructure flexibility | Container Apps | AKS | Web App for Containers |
|---|---|---|---|
| Infrastructure scale-in and scale-out | - Consumption plan: Not available<br><br> - Dedicated plan: Configurable | Configurable | Configurable |
| Flexible hardware provisioning | - Consumption plan: Not available <br><br> - Dedicated plan: Abstracted with workload profiles | Any VM SKU | Abstracted, see [App Service plan](/azure/app-service/overview-hosting-plans) |

> [!IMPORTANT]
> The hardware provisioning options available through the Container Apps Dedicated plan (workload profiles) and Web App for Containers (App Service plans) aren't as flexible as AKS. You need to familiarize yourself with the SKUs available in each service to ensure that your needs are met.

### Application scalability

Scaling of infrastructure and applications is typically triggered by resource consumption, such as CPU and memory. Some container solutions can also scale the number of container instances based on application-specific metrics, such as HTTP requests. For example, AKS and Container Apps can scale container instances based on message queues via Kubernetes event-driven autoscaling (KEDA) and many other metrics via its [scalers](https://keda.sh/docs/2.12/scalers/). These capabilities provide flexibility when you choose the scalability strategy for your application. Web App for Containers relies on the scalability options that Azure provides. Web App for Containers doesn't support custom scaler configurations like KEDA.

| Scalability model | Container Apps | AKS | Web App for Containers |
|---|---|---|---|
| Container scale-out | [HTTP, TCP, or metrics-based (CPU, memory, or event-driven)](/azure/container-apps/scale-app) | [Metrics-based (CPU, memory, or custom)](/azure/aks/concepts-scale) | [Manual, metrics-based](/azure/app-service/manage-scale-up#scale-instance-count-manually-or-by-schedule), or [automatic](/azure/app-service/manage-automatic-scaling) |
| Event-driven scalability | Yes. Cloud-native. | Yes. Cloud-native. Extra configuration required. | Yes. Azure-resource specific. |

AKS Automatic enables the horizontal pod autoscaler, KEDA, and vertical pod autoscaler by default.

## Observability

### Workload instrumentation

Gathering metrics for complex or multiple-tiered applications can be challenging. To get metrics, you can integrate containerized workloads with Azure Monitor in the following ways:

- **Automatic instrumentation:** No code changes required

- **Manual instrumentation:** Minimal code changes required to integrate and configure the SDK and client

  | Instrumentation method | Container Apps | AKS | Web App for Containers |
  |---|---|---|---|
  | Automatic instrumentation via platform | ❌ | ❌ | Partial support* |
  | Automatic instrumentation via agent | ❌ | Partial support* | Not available |
  | Manual instrumentation | Via SDK or OpenTelemetry | Via SDK or OpenTelemetry | Via SDK or OpenTelemetry |

*AKS and Web App for Containers support automatic instrumentation for specific configurations of Linux and Windows workloads, depending on the application language. For more information, see the following articles:

- [Automatic instrumentation supported environments, languages, and resource providers](/azure/azure-monitor/app/codeless-overview#supported-environments-languages-and-resource-providers)
- [Automatic instrumentation application monitoring for Kubernetes](/azure/azure-monitor/app/kubernetes-codeless)

Instrumentation within application code is the responsibility of application developers, so it's independent of any Azure container solution. Use the following solutions for your workload:

- [Application Insights SDKs](/azure/azure-monitor/app/app-insights-overview#supported-languages)
- [OpenTelemetry distributions](/azure/azure-monitor/app/opentelemetry-add-modify)

### Logs and metrics

All Azure container services provide application and platform log and metric functionality. Application logs are console logs that your workload generates. Platform logs capture events that occur at the platform level, outside the scope of your application, like scaling and deployments. Metrics are numerical values that describe some aspect of a system at a point in time. Metrics help you monitor and alert on system performance and health.

Azure Monitor is the key logging and metrics service in Azure that integrates with these services. Azure Monitor uses [resource logs](/azure/azure-monitor/essentials/resource-logs) to separate logs from different sources into categories and collects metrics to provide insights into resource performance. One way to determine which logs and metrics are available from each Azure service is to review the resource log categories and available metrics for each of the services.

| Observability features | Container Apps | AKS | AKS Automatic | Web App for Containers |
| --- | --- | --- | --- | --- |
| Support for log streaming | ✅   | ✅   | ✅   | ✅   |
| Support for Azure Monitor | ✅   | ✅   | ✅   | ✅   |
| Azure Monitor resource logs | - [Console](/azure/container-apps/logging#container-console-logs) <br><br> - [System](/azure/container-apps/logging#system-logs) | [Kubernetes API server, Audit, Scheduler, and Cluster Autoscaler](/azure/aks/monitor-aks#aks-control-planeresource-logs) | Same as AKS | [ConsoleLogs, HTTPLogs, and EnvironmentPlatformLogs](/azure/app-service/monitor-app-service-reference#resource-logs) |
| Metric collection and monitoring | Metrics via Azure Monitor. Custom metrics via [Dapr metrics](/azure/container-apps/dapr-overview#observability). | Metrics via Azure Monitor. Custom metrics via Prometheus (requires manual setup). | Preconfigured Managed Prometheus for metrics collection and Managed Grafana for visualization. Metrics via Azure Monitor. | Metrics via Azure Monitor |
| Preconfigured Prometheus and Grafana | ❌ | Requires manual setup. | Managed Prometheus and Managed Grafana are preconfigured by default. | ❌ |

Consider metrics and logs for the following services:

- **Container Apps** abstracts all of its internal Kubernetes logs into two categories: console logs, which contain workload container logs, and system logs, which contain all platform-related logs. For metrics, Container Apps integrates with Azure Monitor to collect standard metrics and supports custom metrics through Dapr integration for advanced scenarios.

- **AKS** provides Kubernetes-related logs and granular control over what gets logged. AKS retains full compatibility with Kubernetes client tools for log streaming, such as kubectl. For metrics, AKS integrates with Azure Monitor to collect both cluster and node metrics. You can collect custom metrics by using Prometheus and visualize them with Grafana, but this action requires manual setup and configuration.

- **AKS Automatic** comes preconfigured with specific monitoring tools. It uses Managed Prometheus for metrics collection and Managed Grafana for visualization. Cluster and application metrics are automatically collected and can be visualized. AKS Automatic also integrates with Azure Monitor to collect logs and metrics.

- **Web App for Containers** provides several categories of resource logs because its platform (App Service) isn't exclusively for container workloads. For container-specific operations that manage its internal Docker platform, it provides the `AppServicePlatformLogs` log category. Another important category is `AppServiceEnvironmentPlatformLogs`, which logs events like scaling and configuration changes. Metrics are collected via Azure Monitor, which allows you to monitor application performance and resource usage.

### Well-Architected Framework for operational excellence

This article focuses on the key differences among the container services features. Review the complete operational excellence guidance for the following services:

- [AKS](/azure/well-architected/service-guides/azure-kubernetes-service)
- [Web App for Containers](/azure/well-architected/service-guides/azure-app-service/operational-excellence)

## Reliability

*Reliability* refers to the ability of a system to react to failures and remain fully functional. At the application-software level, workloads should implement best practices like caching, retries, circuit breaker patterns, and health checks. At the infrastructure level, Azure is responsible for handling physical failures, like hardware failures and power outages, in datacenters. Failures can still occur. Workload teams should select the appropriate Azure service tier and apply necessary minimum-instance configurations to implement automatic failovers between availability zones.

To choose the appropriate service tier, you need to understand how SLAs and availability zones work.

### SLAs

Reliability is commonly measured by [business-driven metrics](/azure/well-architected/resiliency/business-metrics) like SLAs or recovery metrics like recovery-time objectives.

Azure provides many SLAs for specific services. There's no such thing as total service availability because failures can occur in software, hardware, or even natural events like storms and earthquakes. An SLA isn't a guarantee but a financially backed commitment to a defined level of availability.

For SLAs and details, [download the latest SLA for Microsoft online services document](https://www.microsoft.com/licensing/docs/view/Service-Level-Agreements-SLA-for-Online-Services).

#### Free tiers versus paid tiers

Generally, free tiers of Azure services don't provide an SLA, which makes them cost-effective choices for nonproduction environments. However, it's a best practice for production environments to choose a paid tier that has an SLA.

#### Extra factors for AKS

AKS has different SLAs for different components and configurations:

- **Control plane:** The Kubernetes API server has a separate SLA.

- **Data plane:** Node pools use the underlying SLAs for VM SKUs.

- **Availability zones:** There are different SLAs for the two planes, depending on whether the AKS cluster has availability zones enabled *and* whether multiple instances run across availability zones.

When you use multiple Azure services, [composite service-level objectives](/azure/well-architected/reliability/metrics#define-composite-slo-targets) might differ from and be lower than individual SLAs.

### Redundancy with availability zones

[Availability zones](/azure/reliability/availability-zones-overview#availability-zones) are distinct datacenters that have independent electric power and cooling within a single region. The resulting redundancy increases the tolerance of failures without requiring you to implement multiregion architectures.

Azure has availability zones in every country or region in which it operates a datacenter region. To allow multiple instances of containers to cross availability zones, be sure to select SKUs, service tiers, and regions that provide availability zone support.

| Feature | Container Apps | AKS | Web App for Containers |
|---|---|---|---|
| Availability zone support | Full | Full | Full |

For example, an application or infrastructure that's configured to run a single instance becomes unavailable if a problem occurs in the availability zone where the hardware is hosted. To take full advantage of availability zone support, deploy workloads with a minimum of three container instances distributed across zones.

### Health checks and self-healing

Health check endpoints are crucial to a reliable workload. But building those endpoints is only half of the solution. The other half is controlling how the hosting platform responds when failures occur.

To better understand types of Kubernetes health probes, consider the following [built-in options](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/):

- **Startup:** Checks whether the application successfully starts

- **Readiness:** Checks whether the application is ready to handle incoming requests

- **Liveness:** Checks whether the application is running and responsive

Another important consideration is how often those health checks are requested from the application, or its *internal granularity*. If you have a long interval between these requests, you might continue to serve traffic until the instance is deemed unhealthy.

Most applications support health checks via the HTTP or HTTPS protocol. However, some applications might need other protocols, like TCP or gRPC, to perform those checks. Keep this consideration in mind when you design your health check system.

| Health check capabilities | [Container Apps](/azure/container-apps/health-probes) | AKS | [Web App for Containers](/azure/app-service/monitor-instances-health-check) |
|---|---|---|---|
| Startup probes | ✅ | ✅ | Partial support |
| Readiness probes | ✅ | ✅ | ❌ |
| Liveness probes | ✅ | ✅ | ✅ |
| Interval granularity | Seconds | Seconds | 1 minute |
| Protocol support | - HTTP and HTTPS <br><br> - TCP | - HTTP and HTTPS <br><br> - TCP<br><br> - gRPC | HTTP and HTTPS |

Health checks are easiest to [implement in Web App for Containers](/azure/app-service/monitor-instances-health-check#enable-health-check). Consider the following factors:

- Its startup probes are built-in and can't be changed. It sends an HTTP request to the starting port of your container. Any response from your application is considered a successful start.

- It doesn't support readiness probes. If the startup probe is successful, the container instance is added to the pool of healthy instances.

- It sends the health check at one-minute intervals. You can't change the interval.

- The minimum threshold that you can set for an unhealthy instance to be removed from the internal load balancing mechanism is two minutes. The unhealthy instance gets traffic for at least two minutes after it fails a health check. The default value for this setting is 10 minutes.

Alternatively, Container Apps and AKS are much more flexible and provide similar options. In terms of specific differences, AKS provides the following options for performing health checks, which aren't available in Container Apps:

- [gRPC support](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/#define-a-grpc-liveness-probe)
- [Named ports](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/#use-a-named-port)
- [Exec commands](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/#define-a-liveness-command)

#### Automatic healing

Identifying a bad container instance and stopping traffic to it is only the start. The next step is to implement automatic healing. *Automatic healing* is the process of restarting the application to attempt to recover from an unhealthy state. Consider how the following container services compare:

- In Web App for Containers, there's no option to restart a container instance immediately after a [health check fails](/azure/app-service/monitor-instances-health-check#what-app-service-does-with-health-checks). If the instance continues to fail for one hour, a new instance replaces it. [Automatic healing](/azure/app-service/overview-diagnostics#auto-healing) monitors and restarts instances. It's not directly related to health checks. Automatic healing uses various application metrics, like memory limits, HTTP request duration, and status codes.

- Container Apps and AKS automatically try to restart a container instance if the liveness probe reaches the defined failure threshold.

### Zero-downtime application deployments

The ability to deploy and replace applications without causing any downtime for users is crucial for a reliable workload. All three of the container services that are described in this article support zero-downtime deployments but in different ways.

| Deployment strategy | Container Apps | AKS | Web App for Containers |
|---|---|---|---|
| Zero-downtime strategy | [Rolling update](/azure/container-apps/revisions#zero-downtime-deployment) | [Rolling update, plus all other Kubernetes strategies](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#strategy) | [Deployment slots](/azure/app-service/deploy-staging-slots) |

The application architectures must also support zero-downtime deployment.

### Resource limits

Another important component of a reliable shared environment is your control over the resource usage, like CPU or memory, of your containers. You need to avoid scenarios in which a single application uses all the resources and leaves other applications in a bad state.

| Resource scoping | Container Apps | AKS | Web App for Containers |
|---|---|---|---|
| Resource limits (CPU or memory) | For each app and container | For each app, container, and namespace | For each App Service plan |

- **Web App for Containers:** You can host multiple applications (containers) in a single App Service plan. For example, you might allocate a plan with two CPU cores and 4 gibibyte (GiB) of RAM in which you can run multiple web apps in containers. However, you can't restrict one of the apps to a specific amount of CPU or memory. They all compete for the same App Service plan resources. If you want to isolate your application resources, you need to create extra App Service plans.

- **Container Apps:** You can set CPU and memory limits for each application in your environment. However, you're restricted to a set of [allowed combinations of CPU and memory](/azure/container-apps/containers#configuration). For example, you can't configure one vCPU and 1 GiB of memory, but you can configure one vCPU and 2 GiB of memory. A Container Apps environment serves a similar purpose to a Kubernetes namespace.

- **AKS:** You can choose any [combination of vCPU and memory](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) as long as your nodes have the hardware to support it. You can also limit resources at the [namespace level](https://kubernetes.io/docs/tasks/administer-cluster/manage-resources/quota-memory-cpu-namespace/) if you want to segment your cluster that way.

### Well-Architected Framework for reliability

This article focuses on the key differences among the container services features in Azure. If you want to review the complete reliability guidance for a specific service, see the following articles:

- [Well-Architected Framework review for AKS](/azure/well-architected/service-guides/azure-kubernetes-service)
- [Reliability in Container Apps](/azure/reliability/reliability-azure-container-apps)
- [App Service and reliability](/azure/well-architected/service-guides/azure-app-service/reliability)

## Conclusion

Well-architected solutions create the foundation for successful workloads. Architecture decisions can evolve as workloads grow and teams progress in their cloud journeys. Some choices, especially those related to networking, are difficult to reverse without significant downtime or redeployment.

When you compare Azure container services, a clear theme emerges. AKS exposes the most underlying infrastructure, which provides maximum control and configurability. AKS Automatic balances control and simplicity by automating many operational tasks.

The amount of operational overhead and complexity varies widely for AKS workloads. Some teams significantly reduce overhead by using Microsoft-managed add-ons, extensions, and automatic-upgrade features. Other teams prefer full cluster control to take advantage of Kubernetes' full extensibility and the CNCF ecosystem. For example, while Microsoft provides Flux as a managed GitOps extension, many teams choose to set up and operate ArgoCD on their own.

Workload teams that don't require CNCF applications, have less experience in operations, or prefer to focus on application features might prefer a PaaS offering. We recommend that they first consider Container Apps.

Container Apps and Web App for Containers are both PaaS offerings that provide similar levels of Microsoft-managed infrastructure. However, Container Apps is closer to Kubernetes and provides extra cloud-native capabilities for service discovery, event-driven autoscaling, and [Dapr](https://dapr.io/) integration. Teams that don't need these features and are familiar with App Service networking and deployment models might prefer Web App for Containers.

Generalizations can help narrow down the list of Azure container services for consideration. However, you should also verify your choice by reviewing individual requirements in detail and matching them to service-specific features.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Andre Dewes](https://www.linkedin.com/in/andre-dewes-480b5b62/) | Senior Customer Engineer
- [Xuhong Liu](https://www.linkedin.com/in/xuhong-l-5937159b/) | Senior Service Engineer
- [Marcos Martinez](https://www.linkedin.com/in/marcosmarcusm/) | Senior Service Engineer  
- [Julie Ng](https://www.linkedin.com/in/julie-io/) | Senior Engineer

Other contributors:

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
- [App Service documentation](/azure/app-service/)
- [Container Apps documentation](/azure/container-apps/)

## Related resources

- [Deploy microservices with Container Apps](../example-scenario/serverless/microservices-with-container-apps.yml)
- [Plan your design and operations](../reference-architectures/containers/aks-start-here.md)
