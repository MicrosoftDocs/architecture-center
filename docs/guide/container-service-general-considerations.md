---
title: General considerations for choosing an Azure container service 
description: Get a quick overview of common feature-level considerations that can help you choose an Azure container service. Part two of a series. 
author: julie-ng
ms.author: julng
ms.date: 01/02/2024
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure-kubernetes-service
  - azure-container-apps
  - azure-app-service
categories:
  - containers
---

# General architectural considerations for choosing an Azure container service

This article guides you through the process of choosing an Azure container service. It provides a overview of feature-level considerations that are common and critical for some workloads. It can help you make decisions to ensure that your workload meets requirements for reliability, security, cost optimization, operational excellence, and performance efficiency.

> [!note]
> This article is part two in a series that starts with [Choose an Azure container service](choose-azure-container-service.md). We strongly recommended that you read that overview article first to get a context for these architectural considerations.

## Overview

The considerations in this article are divided into four categories:

[Architectural and network considerations](#architectural-considerations)

- Operating system support
- Network address spaces
- Understanding traffic flow
- Subnet planning 
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
- Vertical infrastructure scalability
- Horizontal infrastructure scalability
- Application scalability
- Observability
- Azure Well-Architected Framework for Operational Excellence

[Reliability considerations](#reliability)

- Service-level agreements
- Redundancy via availability zones
- Health checks and self-healing
- Zero-downtime application deployments
- Resource limits
- Well-Architected Framework for Reliability

 Note that this article focuses on a subset of Azure container services that offer a mature feature set for web applications and APIs, networking, observability, developer tools, and operations: Azure Kubernetes Service (AKS), Azure Container Apps, and Web App for Containers. For a complete list of all Azure container services, see [the container services product category page](https://azure.microsoft.com/products/category/containers/).

> [!note]
> In this guide, the term *workload* refers to a collection of application resources that support a business goal or the execution of a business process. A workload uses with multiple components, like APIs and data stores, that work together to deliver specific end-to-end functionality.

## Architectural considerations

This section describes architectural decisions that are difficult to reverse or correct without requiring significant downtime or re-deployment. Keeping this in mind is especially relevant for fundamental components like networking and security.

These considerations aren't specific to Well-Architected Framework pillars. However, they deserve extra scrutiny and evaluation against businesses requirements when you choose an Azure container service.

### Operating system support

Most containerized applications run in Linux containers, which are supported by all Azure container services. Your options are more limited for workload components that require Windows containers.

| |  Container Apps | AKS | Web App for Containers |
|---|--|--|--|
| **Linux support** | ✅ | ✅ | ✅ |
| **Windows support** | ❌ | ✅ | ✅ |
| **Mixed OS support** | ❌ | ✅ | ❌* |

*Mixed OS support for Web App for Containers requires separate Azure App Service plans for Windows and Linux.

## Networking considerations

It's impportant to understand networking design early in your planning processes due to security and compliance constraints and imposed guidelines. In general, the major differences among the Azure services covered in this guide depend on whether simplicity or configurability is prioritized:

- Container Apps is a PaaS offering that provides many Azure-managed networking features, like service discovery and internal managed domains. Workload teams that need a bit more configurability might be able to take advantage of workload/dedicated profiles rather than resorting to AKS to meet their networking requirements.
- AKS is the most configurable of the three services and provides the most control over network flow. For example, it provides custom ingress controllers and the control of intra-cluster traffic via Kubernetes network policies. These implementations, however, are customer managed, so they increase operational overhead.
- Web App for Containers is feature of App Service, so the networking concepts, especially private networking integration, are very specifiec to App Service. It will be familiar to workload teams that already use App Service. Teams without App Service experience that want a more familiar Azure virtual network integration are encouraged to consider Container Apps.

Keep in mind that networking is a foundational infrastructure layer. Changes in design are often difficult without workload re-deployment, which can lead to downtime. Therefore, review this section carefully before you narrow down your Azure container service selection if your workload has specific networking requirements.

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

- Multiple co-located workloads.  
- Private and/or public ingress.  
- An access-controlled flow of east-west traffic in a cluster (for  Container Apps and AKS) or within a virtual network (for all Azure container services).

### Subnet planning

Ensuring that you have a subnet that's large enough to include instances of your application for your workload isn't the only factor that dictates the network footprint where these applications are deployed.

| |  Container Apps| AKS | Web App for Containers |
|---|--|--|---|
| **Support for co-located workloads within subnet*** | ❌* | ✅ | N/A* |

*This describes a best practice, not a technical limitation.

For  Container Apps, subnet integration applies only to a single Container Apps environment. Each Container Apps environment is constrained to a single ingress IP, public or private. 

Each Container Apps environment is meant only for a single workload in which dependent applications are co-located. Therefore, additional Azure networking appliances for ingress load balancing must be introduced if you need both public and private ingress. Examples include Azure Application Gateway and Azure Front Door. Also, if you have multiple workloads that need to be segregated, additional Container Apps environments are required, so an additional subnet must be allocated for each environment.

AKS provides granular east-west network flow control within the cluster in the form of Kubernetes network policy. This flow control enables you to host multiple workloads within the same subnet, which you can't do in Container Apps. As a consequence, AKS has a steeper adoption curve but more configurability options.

For Web App for Containers, there are no constraints on how many apps you can integrate with a single subnet, as long as the subnet is large enough. There are no best practices for access control between web apps in the same virtual network. Each web app independently manages access control for east-west or north-south traffic from the virtual network or internet, respectively.

> [!note]
> You can't resize subnets that have resources deployed in them. Take extra care when you plan your network to avoid needing to redeploy entire workload components, which can lead downtime.

### Number of ingress IPs available

The following table takes the previous subnet planning section into consideration to define how many IPs can be exposed for an arbitrary number of applications that are hosted in a single deployment of an Azure container service.

| | Container Apps | AKS | Web App for Containers |
|---|---|---|---|
| **Number of ingress IPs** | 1 | Many | App Service Environment: 1<br>No App Service Environment: Many |

Container Apps allows one IP per environment, public or private. AKS allows any number of IPs, public or private. Web App for Containers, outside of an App Service Environment, allows one public IP for all apps within an App Service plan and multiple, different private IPs that use Azure private endpoints.

It's important to note that web apps that are integrated into an App Service Environment only receive traffic through the single ingress IP that's associated with the App Service Environment, whether it's public or private.

### User-defined routes and NAT gateway support

If a workload requires user-defined routes (UDR) and NAT gateway capabilities for granular networking control, Container Apps requires isolated infrastructure via [workload profiles](/azure/container-apps/workload-profiles-overview), which are available only in the Container Apps dedicated / workload profiles plan. 

AKS and Web App for Containers implement these two networking features through standard virtual network functionality or virtual network integration, respectively. To elaborate, AKS node pools and Web App for Containers in an App Service Environment are already direct virtual network resources. Web App for Containers that aren't in an App Service Environment support UDR and NAT gateway via [virtual network integration](/azure/app-service/overview-vnet-integration). With virtual network integration, the resource technically doesn't reside directly in the virtual network, but all of its outbound access flows through the virtual network, and the network's associated rules affect traffic as expected.

| | Container Apps | AKS | Web App for Containers|
|---|---|--|--|
| **UDR support** | Consumption plan: ❌<br>Dedicated plan: ✅ | ✅ | ✅ |
| **NAT gateway support** | Consumption plan: ❌<br>Dedicated plan: ✅ | ✅ | ✅| |

### Private networking integration

For workloads that require strict Layer 4 private networking for both ingress and egress, you should consider Container Apps, AKS, and the single-tenant App Service Environment SKU, where workloads are deployed into a self-managed virtual network, providing the customary granular private networking controls.

| | Container Apps| AKS| Web App for Containers|
|---|--|--|---|
| **Private ingress into a virtual network** | ✅ | ✅ | Via [private endpoint](/azure/app-service/networking/private-endpoint) |
| **Private egress from a virtual network** | ✅ | ✅ | Via [virtual network](/azure/app-service/overview-vnet-integration) integration |
| **Fully suppressed public endpoint** | ✅ | ✅ | [ASE only](/azure/app-service/environment/networking?source=recommendations#addresses) |

##### Private networking with Web App for Containers

Web App for Containers has additional networking features that aren't surfaced in the same way by the other Azure services described in this article. To implement strict private networking requirements, workload teams need to familiarize themselves with these networking concepts. Carefully review these networking features: 
- [Private endpoint](/azure/private-link/private-endpoint-overview) 
- [Virtual network integration](/azure/app-service/overview-vnet-integration)

If you want a PaaS solution and prefer networking concepts that are shared across multiple Azure solutions, you should consider Container Apps.

### Protocol coverage

An important consideration for the hosting platform is the networking protocols that are supported for incoming application requests (ingress). Web App for Containers is the strictest option, supporting only HTTP and HTTPS. Container Apps additionally allows incoming TCP connections. AKS is the most flexible, supporting unconstrained use of TCP and UDP on self-selected ports.

| | Container Apps| AKS| Web App for Containers|
|---|--|--|--|
| **Protocol and port support** | HTTP (port 80)* <br>HTTPS (port 443)*<br>TCP (ports 1-65535, except 80 and 443) | TCP (any port)<br>UDP (any port) | HTTP (port 80)<br>HTTPS (port 443) |
| **WebSocket support** | ✅ | ✅ | ✅ |
| **HTTP/2 support** | ✅ | ✅ | ✅ |

*In the Container Apps environment, HTTP/S can be exposed on any port for intra-cluster communication. In that scenario, built-in Container Apps HTTP features like CORS and session affinity don't apply.

Both Container Apps and Web App for Containers support TLS 1.2 for their built-in HTTPS ingress.

### Load balancing

With Container Apps and Web App for Containers, Azure manages both the Layer 4 and Layer 7 load balancers.

AKS, however, uses a shared responsibility model in which Azure manages the underlying Azure infrastructure that the workload team configures by using the Kubernetes API. For Layer 7 load balancing in AKS, you can choose an Azure managed option, like [Application Gateway for Containers](/azure/application-gateway/for-containers/overview), or deploy and self-manage an ingress controller of your choice.

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

Container Apps also provides public ingress FQDNs. However, Container Apps goes further by allowing the app FQDN to be exposed and restricting traffic only within the environment. This functionality makes it easier to manage east-west communication and enable components like Dapr.

AKS requires the deployment of Kubernetes services as defined by the Kubernetes API, which are used to expose applications to the network in an addressable way. Because Kubernetes deployments aren't initially discoverable from within or outside of the cluster, additional configuration is required. 

> [!important]
> Only Container Apps and AKS provide service discovery through internal DNS schemes within their respective environments. This functionality can simplify DNS configurations across dev/test and production environments. For example, you can create these environments with arbitrary service names that have to be unique only within the environment or cluster, so they can be the same across dev/test and production. With Web App for Containers, service names must be unique across different environments to avoid conflicts with Azure DNS. 

### Custom domains and managed TLS

Both Container Apps and Web App for Containers provide out-of-the-box solutions for custom domains and certificate management.

| | Container Apps| AKS| Web App for Containers|
|---|--|--|--|
| **Configure custom domains** | Out of the box | BYO | Out of the box |
| **Managed TLS for Azure FQDNs** | Out of the box | N/A | Out of the box |
| **Managed TLS for custom domains** | [In preview](/azure/container-apps/custom-domains-managed-certificates?pivots=azure-portal) | BYO | Out of the box or BYO |

AKS requires workload teams to set up their own ingress controllers, configure custom domain names on the cluster and DNS, and manage their own certificates. Teams considering AKS can use the CNCF [cert-manager]( https://www.cncf.io/projects/cert-manager/) to manage TLS certificates, and nginx or Traefik for ingress.

### Mutual TLS

Another alternative for restricting incoming traffic is mutual TLS (mTLS). Manual TLS is a security protocol that ensures that both the client and server in communication are authenticated. To accomplish authentication, both parties exchange and verify certificates before any data is transmitted.

Web App for Containers has built-in support for mTLS for incoming client connections. However, the application needs to validate the certificate by accessing the `X-ARR-ClientCert` HTTP header that the App Service platform forwards.

Container Apps also has built-in support for mTLS. It forwards the client certificate to the application in the HTTP header `X-Forwarded-Client-Cert`. You can also easily enable automatic mTLS for internal communication between apps in a single environment.

AKS doesn't provide out-of-the-box mTLS. Workload teams should consider installing a service mesh to accomplish mTLS.

### Service-specific networking concepts

The preceding sections describe some of the most common considerations to take into account. For more details and to learn more about networking features that are specific to individual Azure container services, see these articles:

- [Networking in Container Apps](/azure/container-apps/networking)
- [Networking concepts for AKS](/azure/aks/concepts-network)
- [App Service networking features](/azure/app-service/networking-features)

The preceding sections focus on network design. Continue to the next section to learn more about networking security and securing network traffic.

## Security considerations

Failure to address security risks can lead to unauthorized access, data breaches, or leaks of sensitive information. Containers offer an encapsulated environment for your application. The hosting systems and underlying network overlays, however, require additional guardrails. Your choice of Azure container service needs to support your specific requirements for securing each application individually and implement proper security measures to prevent unauthorized access and mitigate the risk of attacks.

### Security comparison overview

Most Azure services, including Container Apps, AKS, and Web App for Containers, integrate with key security offerings, including Key Vault and managed identities.

AKS provides more configurability, at the expense of the additional overhead of running a Kubernetes cluster. Although AKS provides unique features like network policies, part of the reason it offers more security features is because its attack surface is larger. For example, AKS surfaces Kubernetes components, including the control plane and virtual machine nodes, which in turn require additional security protection.

For a detailed comparison, carefully review the following considerations to ensure that your workload security requirements can be met.

### Kubernetes control plane security

AKS offers the most flexibility of the three options considered in this article, providing full access to the Kubernetes API to customize container orchestration. This access to the Kubernetes API, however, also represents a significant attack surface, and you need to secure it. 

> [!Important] 
> Note this section isn't relevant for Web App for Containers, which uses the  Azure Resource Manager API as its control plane.

#### Identity-based security

Customers are responsible for securing identity-based access to the API. Out of the box, Kubernetes provides its own authentication and authorization management system, which also needs to be secured with access controls. 

To take advantage of a single plane of glass for identity and access management on Azure, it's a best practice to [disable Kubernetes-specific local accounts](/azure/aks/manage-local-accounts-managed-azure-ad) and instead [implement AKS-managed Microsoft Entra integration](/azure/aks/enable-authentication-microsoft-entra-id) together with [Azure RBAC for Kubernetes](/azure/aks/manage-azure-rbac). If you implement this best practice, administrators don't need to perform identity and access management on multiple platforms.

| | Container Apps | AKS|
|---|--|--|
| **Kubernetes API access controls** | No access | Full access |

Customers who use Container Apps don't have access to the Kubernetes API, which is secured by Microsoft. 

#### Network-based security

If you want to restrict network access to the Kubernetes control plane, you need to use AKS, which provides two options. The first option is to use [private AKS clusters](/azure/aks/private-clusters#create-a-private-aks-cluster), which use Azure Private Link between the API server's private network and the AKS cluster's private network. The second option is [API Server VNet integration (preview)](/azure/aks/api-server-vnet-integration), where the API server is integrated into a delegated subnet. See the documentation to learn more.

There are consequences to implementing network-restricted access to the Kubernetes API. Most notably, management can be performed only from within the private network, which means you need to deploy self-hosted agents for Azure DevOps or GitHub Actions. To learn about other limitations, see the feature-specific documentation.

| | Container Apps | AKS|
|---|--|--|
| **Kubernetes API network security** | Not configurable in PaaS | Configurable: public IP or private  IP |

These considerations don't apply to Container Apps. Because it's PaaS, Microsoft abstracts away the underlying infrastructure.

### Data plane network security

The following networking features can be used to control access to, from, and within a workload.

#### Securing intra-cluster traffic by using network policies

Some security postures require network traffic segregation *within* an environment, for example when you use multi-tenant environments to host multiple or multi-tiered applications. In these scenarios, you should choose AKS and implement network policies, a cloud-native technology that enables granular configuration of Layer 4 networking within Kubernetes clusters.

| | Container Apps| AKS| Web App for Containers|
|---|--|--|--|
| **Network policies** | Consumption plan: ❌<br>Dedicated plan: ❌ | ✅ | ❌ |

Of the three Azure services described in this article, AKS is the only one that supports further workload isolation within the cluster.  Network policies aren't supported in Container Apps or Web App for Containers.

#### Network security groups

In all scenarios, you can regulate networking communication within the wider virtual network by using network security groups, enables you to use Layer 4 traffic rules that regulate ingress and egress at the virtual network level.

| | Container Apps| AKS| Web App for Containers|
|---|--|--|--|
| **Network security groups** | Consumption plan: ✅<br>Dedicated plan: ✅ | ✅ | ✅ VNet-integrated apps: egress only |

#### Built-in IP restrictions for ingress

Container Apps and Web App for Containers don't require virtual network integration, so they provide built-in source IP restrictions for ingress traffic. If you use AKS, you need to implement a bring-your-own solution to achieve similar traffic filtering.  

| | Container Apps| AKS| Web App for Containers|
|---|--|--|--|
| **Built-in ingress IP restrictions** | ✅ | ❌ | ✅ |

## Application-level security

You need to secure workloads not just at the network and infrastructure level, but also at the workload and application level. Azure container solutions integrate with Azure security offerings to help standardize security implementation and controls for your applications.

### Key Vault integration

It's a best practice to store and manage secrets, keys, and certificates in a key management solution like Azure Key Vault, which provides enhanced security for these components. Instead of storing and configuring secrets in code or in an Azure compute service, all applications should integrate with Key Vault.

Key Vault integration enables application developers to focus on their application code. All three of the Azure container services desribed in this article can automatically sync secrets from the Key Vault service and provide them to the application, typically as environment variables or mounted files.

| | Container Apps| AKS| Web App for Containers|
|---|--|--|--|
| **Key Vault integration** | ✅ | ✅ | ✅ |

For more information, see:

- [Manage secrets in Azure Container Apps](/azure/container-apps/manage-secrets?tabs=azure-portal#reference-secret-from-key-vault)
- [Integrate Key Vault with AKS](/azure/aks/csi-secrets-store-driver)
- [Use Key Vault references as app settings in Azure App Service](/azure/app-service/app-service-key-vault-references)

### Managed identity support

It's a best practice to use managed identities to access Azure resources without using secrets, for example, pull images from Azure Container Registry without using a user name and password.

Azure container services provide managed identity support, configurable out of the box for Container Apps and Web App for Containers. AKS provides integrated managed identity support for the Kubernetes control plane, Azure Container Registry image management, and cluster add-ons. Managed identity for AKS applications is provided through [Workload ID](/azure/aks/workload-identity-overview). Workload ID is more complex than the implementations for providing managed identities to application code in the other Azure services described in this article.

| | Container Apps| AKS| Web App for Containers|
|---|--|--|--|
| **Infrastructure managed identity support** | N/A | ✅ | N/A |
| **Container-pull managed identity support** | ✅ | ✅ | ✅ |
| **Application managed identity support** | ✅ | ✅ | ✅ |

For more information, see:

- [Use a managed identity in AKS](/azure/aks/use-managed-identity)
- [Managed identities in Azure Container Apps](/azure/container-apps/managed-identity)
- [How to use managed identities for App Service](/azure/app-service/overview-managed-identity)

### Threat protection and vulnerability assessments with Defender for Containers

Threat protection against vulnerabilities is also important. It's a best practice to use Microsoft Defender for Containers. Currently, runtime support is available only for AKS. Vulnerability assessments are supported in Azure container registries, so they can be used by any Azure container service, not just the ones described in this article.

| | Container Apps| AKS| Web App for Containers|
|---|--|--|--|
| **Runtime threat protection** | ❌ | ✅ | ❌ |

For more information, see [Containers support matrix in Defender for Cloud](/azure/defender-for-cloud/support-matrix-defender-for-containers).

Note that container image vulnerability assessments aren't real-time scans. The Azure container registry is scanned at regular intervals.

## Security baselines

In general, most Azure container services integrate Azure security offerings. AKS is more configurable, in part because its attack surface is larger. Overall, keep in mind that a security feature set is just a small part of implmenting cloud security. For more information about implementing security for container services, see the following service-specific security baselines:

- [Azure security baseline for Container Apps](/security/benchmark/azure/baselines/azure-container-apps-security-baseline)
- [Azure security baseline for Azure Kubernetes Service](/security/benchmark/azure/baselines/azure-kubernetes-service-aks-security-baseline)
- [Azure security baseline for App Service](/security/benchmark/azure/baselines/app-service-security-baseline)

The security baselines cover other Azure integrations, including hardware encryption and logging, that are out of scope for this article.

## Well-Architected Framework for Security

This article focuses on the main differences among the container services features in Azure. For more complete security guidance about AKS, see [Well-Architected Framework review - AKS](/azure/well-architected/service-guides/azure-kubernetes-service).

## Operational considerations

To successfully run a workload in production, teams need to implement operational excellence practices, including centralized logging, monitoring, scalability, regular updates and patching, and image management.

In general, AKS provides the most configurability and therefore the most diversity and complexity for operational tasks. Azure, however, assumes many operational responsibilities, such as updates for PaaS offerings like Container Apps and Web App for Containers.

### Updates and patches

You need to ensure that your application's underlying OS is updated and regularly patched. Keep in mind, however, that with every update there's a risk of failure. This section and the next one desribe the main considerations for the three container services with regard to the shared responsibility between customer and platform.

AKS is a hybrid IaaS and PaaS solution, so the workload team, not Microsoft, is responsible for upgrading clusters' control and application planes. Azure provides the updated images for the node OS and control plane components, but customers are responsible for triggering or scheduling the updates. See the AKS day-2 operations guide to learn about [patching and upgrading AKS clusters](/azure/architecture/operator-guides/aks/aks-upgrade-practices).

Container Apps and Web App for Containers are PaaS solutions. Azure is responsible for managing updates and patches, so customers can avoid the complexity of AKS upgrade management.

| | Container Apps| AKS| Web App for Containers|
|---|--|--|--|
| **Control plane updates** | Platform | Customer | Platform |
| **Host updates and patches** | Platform | Customer | Platform |
| **Container image updates and patches** | Customer | Customer | Customer |

For more information, see:

- [Upgrade options for AKS clusters](/azure/aks/upgrade-cluster)
- [Upgrade AKS node images](/azure/aks/node-image-upgrade)

### Container image updates

Regardless of the Azure container solution, customers are always responsible for their own container images. If there are security patches for container base images, it's your responsibility to rebuild your images. To get alerts about these vulnerabilities, use [Defender for Containers](/azure/defender-for-cloud/defender-for-containers-introduction) for containers that are hosted in Container Registry.

## Scalability

Scaling is used to adjust resource capacity to meet demands, adding more capacity to ensure performance and removing unused capacity to save money. When you choose a container solution, you need to consider infrastructure constraints and scaling strategies.

### Vertical infrastructure scalability

*Vertical scaling* refers to the ability to increase or decrease existing infrastructure, that is, compute CPU and memory. Different workloads require different amounts of compute resources. When you choose an Azure container solution, you need to be aware of the hardware SKU offerings that are available to a particular Azure service. They vary and can impose additional constraints.

For AKS, review the [sizes for virtual machines in Azure](/azure/virtual-machines/sizes) documentation and the [per-region AKS restrictions](/azure/aks/quotas-skus-regions).

These articles provide details about SKU offerings for the other two services:

- [Workload profiles types in Container Apps](/azure/container-apps/workload-profiles-overview)
- [App Service pricing](https://azure.microsoft.com/pricing/details/app-service/linux/)

### Horizontal infrastructure scalability

*Horizontal scaling* refers to the ability to increase or decrease capacity via new infrastructure, like VM nodes. During scaling increases or decreases, the Container Apps consumption tier abstracts the underlying virtual machines. For the remaining Azure container services, you manage the horizontal scaling strategy by using the standard Azure Resource Manager API.

Note that scaling out and in includes re-balancing of instances, so it also poses a downtime risk. The risk is smaller than the corresponding risk with vertical scaling. Nevertheless, workload teams are always responsible for ensuring that their applications can handle failure and for implementing graceful startups and shutdowns of their applications to avoid downtime.

| | Container Apps| AKS| Web App for Containers|
|---|--|--|--|
| **Infrastructure scale in and out** | Consumption plan: N/A<br>Dedicated plan: configurable | Configurable | Configurable |
| **Flexible hardware provisioning** | Consumption plan: N/A<br>Dedicated plan: abstracted with workload profiles | Any VM SKU | Abstracted. See [App Service plan](/azure/app-service/overview-hosting-plans). |

> [!important]
> The hardware provisioning options available through the Container Apps Dedicated plan (workload profiles) and Web App for Containers (App Service plans) aren't as flexible as AKS. You need to familiarize yourself with the SKUs available in each service to ensure that your needs are met.

### Application scalability

The typical measure on which to trigger scaling of infrastructure and applications is resource consumption: CPU and memory. Some container solutions can scale container instance count on metrics with application-specific context, like HTTP requests. For example, AKS and Container Apps can scale container instances based on message queues via KEDA and many other metrics via its scalers. These capabilities provide flexibility when you're choosing the scalability strategy for your application. Web App for Containers relies on the scalability options provided by Azure. (See the following table.) Web App for Containers doesn't support custom scaler configurations like KEDA. 

| | Container Apps| AKS| Web App for Containers|
|---|--|--|--|
| **Container scale out** | HTTP, TCP, or Metrics-based (CPU, memory, event-driven) | Metrics-based (CPU, memory, or custom) | Manual, metrics-based, or automatic (preview) |
| **Event Driven scalability** | Yes, Cloud Native | Yes, Cloud Native, additional config required | Yes, Azure resource specific |

## Observability

### Workload instrumentation

Applications can be complex and multi-tiered, and thus gathering metrics can be challenging. Containerized workloads can integrate with Azure Monitor for metrics in two ways:

- **Autoinstrumentation**: zero code changes required.
- **Manual instrumentation**: *small* code changes required to integrate and configure SDK and/or client.

 | | Container Apps| AKS| Web App for Containers|
  |---|--|--|--|
  | **Autoinstrumentation via platform** | ❌ | ❌ | **Partial Support*** |
  | **Autoinstrumentation via agent** | ❌ | **Partial Support*** | n/a |
  | **Manual instrumentation** | via SDK or Open Telemetry | via SDK or Open Telemetry | via SDK or Open Telemetry |

\*AKS and Web App for Containers supports autoinstrumentation for certain combinations of Linux and Windows workloads depending on application language. See the autoinstrumentation support documentation for details.

Instrumentation within the application code itself is the responsibility of application developers and thus independent of any Azure container solution. Your workload can use solutions such as:

- Application Insights SDKs
- Open Telemetry distributions

### Logs

All the Azure container services provide application and platform logs functionality. Application logs are console logs generated by your workload while platform logs are events happening on the platform level - outside the scope of your application - such as scaling, deployments, etc. 

The main differences between the container services logging are in platform logging: what gets logged and how they’re organized internally. Azure Monitor is the main logging service in Azure that these services integrate into. Azure Monitor has a concept of “resource logs” which separates logs coming from different sources into categories. A practical way to see which logs are available from each Azure service is to look at what resource logs categories are available for each of these services.

| | Container Apps| AKS| Web App for Containers|
|---|--|--|--|
| **Support for log streaming (real-time streaming)** | ✅ | ✅ | **✅** |
| **Support for Azure Monitor** | ✅ | ✅ | ✅ |
| **Azure Monitor resource logs** | ConsoleSystem | Kubernetes API Server, Audit, Scheduler, Cluster Autoscaler and more… | ConsoleLogs, HTTPLogs, EnvironmentPlatformLogs and more… |

For a more detailed description of each of the resource logs in the table above, check the referenced links. A short summary of the logging capabilities of the container services:

- **Container Apps abstracts all its internal Kubernetes logs into two simple categories. One called** ***Console***** logs which contains the** **workload container logs and a second** ***System***** category which contains all platform-related** **logs.** 
- **AKS provides all Kubernetes-related logs and granular control on what can be logged or not. It also retains full compatibility with Kubernetes client tools for log streaming such as** ***kubectl***
- **Web App for Containers has many different categories of resource logs since its platform (App Service) is not exclusively running container workloads. However, for container-specific operations managing its internal Docker platform there is the** ***AppServicePlatformLogs***** log category. Another important** **log category is** ***AppServiceEnvironmentPlatformLogs*** **which contains events such as scaling and configuration changes**

## Azure Well-Architected Framework for Operational Excellence

This article focusses on the main differences between the container services features in Azure. If you want to explore the full Operational Excellence guidance for each service available in the Azure Well-Architected Framework, check out these references:

- **AKS**: [Azure Well-Architected Framework review for Azure Kubernetes Service (AKS) - Microsoft Azure Well-Architected Framework | Microsoft Learn](/azure/well-architected/service-guides/azure-kubernetes-service)
- **Web App for Containers**: [Azure App Service and operational excellence - Microsoft Azure Well-Architected Framework | Microsoft Learn](/azure/well-architected/service-guides/azure-app-service/operational-excellence)

## Reliability

Reliability refers to the ability of a system to react to failures and remain fully functional. At an application software level, workloads should implement best practices, e.g. caching, retry, circuit breaker patterns and health checks. At the infrastructure level, Azure is responsible for handling physical failures in data centers, e.g., hardware failures and power outages. Failures can still happen, and workload teams should select the appropriate Azure service tier and apply necessary minimum instance configuration to leverage automatic failovers between availability zones.

To choose the appropriate service tier customers need to understand how service level agreements (SLAs) and availability zones (AZs) work.

### Service Level Agreements

Reliability is commonly measured by business driven metrics such as service level agreements (SLA) or recovery metrics like recovery time objective (RTO). 

Azure has many different SLAs, depending on the Azure specific service. It is important to understand that there is no such thing as a 100% service level, because failures can always occur in software, hardware and in nature, e.g., storms, earthquakes, etc. An SLA is not a guarantee but rather a financially backed agreement of service availability.

For the latest SLAs and details, please[ download the latest Service Level Agreement for Microsoft Online Services (WW) document](https://www.microsoft.com/licensing/docs/view/Service-Level-Agreements-SLA-for-Online-Services?lang=1) from the Microsoft licensing website.

#### Azure free vs. paid tiers

Generally, free tiers of Azure services do not offer an SLA, which makes them cost effective choices for non-production environments. For production environments, however, it is best practice to choose a paid tier with an SLA.

#### Additional factors for Azure Kubernetes Service

Azure Kubernetes Service (AKS) has different SLAs for different components and configurations: 

- **Control plane**: the Kubernetes API server has a separate SLA
- **Data plane**: the node pools use the underlying VM SKU SLAs 
- **Availability zones**: there are different SLAs for both planes depending on whether the AKS cluster has availability zones enabled *and* running multiple instances across AZs.

Please note that when choosing multiple Azure services, composite SLAs may differ from and be lower than individual service SLAs.

### Redundancy with Availability Zones

**Availability Zones** are distinct data centers with independent electric power, cooling, etc. within the same region. This redundancy increases the tolerance of failures without customers having to implement multi-region architectures. 

Azure has availability zones in every country/region in which Azure operates a datacenter region. To allow multiple instances of containers to spread across availability, be sure to select the corresponding SKUs, service tiers, and region that offer availability zone support.

| **Feature** | **Container Apps** | **AKS** | **Web Apps** |
|---|--|--|--|
| **Availability Zone Support** | Full | Full | Full |

For example, any application or infrastructure configured to run one single instance will become unavailable if a problem occurs in that availability zone where the corresponding hardware is hosted. To fully use availability zone support, workloads should also deploy with a minimum configuration of three instances of the container, spread across the zones.

### Health checks and self-healing

Having health check endpoints is crucial to a reliable workload because that is how an application can tell its host if it is healthy or not. But building those endpoints is half of the solution, the other half is to control what/how the hosting platform does when there are failures.

To better distinguish between different types of health probes, let’s borrow the concept from built-in types of probes from Kubernetes: 

- **Startup:** Checks if your application has successfully started
- **Readiness**: Checks to see if the application is ready to handle incoming requests
- **Liveness**: Checks if your application is still running and responsive

Another important consideration is how often those health checks are requested from the application (internal granularity). If you have a large interval between them, you might continue to serve the traffic until the instance is deemed unhealthy. 

Most applications support health check using the HTTP(S) protocol. However, some might need other protocols such as TCP or gRPC to perform those checks. Keep this in mind when designing your health check system.

| | Container Apps| AKS| Web App for Containers|
|---|--|--|--|
| **Startup probes** | ✅ | ✅ | Partial support |
| **Readiness probes** | ✅ | ✅ | ❌ |
| **Liveness probes** | ✅ | ✅ | ✅ |
| **Interval granularity** | Second | Second | 1 minute |
| **Protocol support** | HTTP(S)TCP | HTTP(S)TCPgRPC | HTTP(S) |

**Web App for Containers** is the simplest implementation and has some important considerations:

- Its startup probes are built-in and cannot be changed. Internally it will send a HTTP request in the starting port of your container and any response back from your application will be considered a successful start.
- It doesn’t support readiness probes. If the startup probe was successful, this container instance will be added to the pool of “healthy” instances.
- It sends the health check at 1-minute intervals, this cannot be changed.
- The minimum configurable threshold you can set for your unhealthy instance to be removed from the internal load balancing mechanism is 2 minutes. That means your “unhealthy” instance will be getting traffic for at least 2 minutes after it fails a health check. The default value for this setting is 10 minutes

Container Apps and AKS, on the other hand, are much more flexible and offer similar options (since Container Apps is based on an internal Kubernetes platform). In comparison to AKS, Container Apps lacks the following options for health checking:

- gRPC support
- Named ports
- *Exec* commands<br>

#### Auto-healing

Identifying a bad container instance and stop sending traffic to it is one thing. But what can be done about the faulty instance after that? “Auto-healing” is the process of restarting the application in an attempt to recover from an unhealthy state. These are the differences between the Azure container services in that regard:

- **Web App for Containers**: there is no option to restart a container instance right after a health check fails. If it keeps failing for one hour, then it is replaced by a new instance. There is another feature called “*Auto-healing*” to monitor and restart instances not directly related to health checks but looking at different metrics of the application (such as memory limit, HTTP requests duration or status codes)
- **Container Apps** and** AKS** will automatically try to restart the container instance if the *liveness* probe reaches the defined failure threshold.

### Zero downtime application deployments

The ability to deploy and replace applications without having any downtime for the users is a crucial aspect for a reliable workload. All three Azure container services covered by this article support zero downtime deployments although in different ways.

| | Container Apps| AKS| Web App for Containers|
|---|--|--|--|
| **Zero downtime strategy** | Rolling update | Rolling update+All other Kubernetes strategies | Slots |

- **Web App for Containers**: it has a concept of slots, which are placeholders where you can deploy new versions of your containers and test them before sending to the Production slot. Each slot has its own separate host name, configuration, and binaries from the Production slot. However, this feature needs to be implemented and is not configured out-of-the-box.
- **Container Apps**: by default, any container deployed to Container Apps will have zero downtime (works like a Kubernetes rolling update) and you also have the possibility to validate and test them before sending to Production by using multiple revisions direct access
- **AKS**: the default deployment strategy in Kubernetes is called rolling update, which will start new instances of your container in parallel with the existing and only after kill the old ones after the new are started, resulting in no downtime. However, you can also choose among other deployment strategies available in Kubernetes.

### Resource limits

Another important aspect of having a reliable shared environment is how you control the resource usage (like CPU or memory) of your containers, to avoid a single application taking over all the resources leaving other applications in a bad state.

| | Container Apps| AKS| Web App for Containers|
|---|--|--|--|
| **Resource limits (CPU/Memory)** | Per app/container | Per app/containerPer namespace | Per App Service Plan |

- **Web App for Containers:** You can host multiple applications (containers) within a single App Service Plan. For example, you might allocate a plan with 2 CPU cores and 4 GiB RAM and there you can run multiple web apps with containers. However, you can not restrict one of these apps to take certain amount of CPU or memory. They all will compete for the same resources of the App Service Plan. If you want to isolate your application resources, you will need to create additional App Service Plans.
- **Container Apps: You can set CPU and Memory limits per application within your environment. However, the choice of CPU and Memory must match one of the allowed combinations from the official documentation. For example, you can’t set 1 vCPU + 1 GiB memory, it needs to be 1 vCPU + 2 GiB memory. An Container Apps environment is analogue to a Kubernetes namespace.**
- **AKS: You are free to choose your own combination of vCPU and Memory as long as your nodes have the hardware for it. Additionally, you can limit resources in the namespace level if you want to segment your cluster that way.**

### Azure Well-Architected Framework for Reliability

This article focusses on the main differences between the container services features in Azure. If you want to explore the full reliability guidance for each service available in the Azure Well-Architected Framework, check out these references:

- **AKS**: [Azure Well-Architected Framework review for Azure Kubernetes Service (AKS) - Microsoft Azure Well-Architected Framework | Microsoft Learn](/azure/well-architected/service-guides/azure-kubernetes-service)
- **Container Apps**: [Reliability in Container Apps | Microsoft Learn](/azure/reliability/reliability-azure-container-apps?tabs=azure-cli)
- **Web App for Containers**: [Azure App Service and reliability - Microsoft Azure Well-Architected Framework | Microsoft Learn](/azure/well-architected/service-guides/azure-app-service/reliability)

## Conclusion

Well-architected solutions set the foundations for successful workloads, which require conscious research and decision making. While architecture can be adjusted as a workload grows and teams progress on their cloud journeys, some decisions, especially around networking are difficult to reverse without significant downtime or re-deployments.

In general, when comparing various Azure container services, a theme emerges: Azure Kubernetes Service (AKS) offers the greatest configurability at cost of additional operational overhead. Workload teams who, for example, have less operations experience or prefer to focus on developer features, may prefer a PaaS service and are encouraged to explore Container Apps.

Although Container Apps and Web App for Containers are both PaaS offerings with similar levels of Microsoft managed infrastructure, a key difference is that Container Apps is closer to Kubernetes and offers additional cloud native capabilities around service discovery, event driven autoscaling, Dapr integration, and more. However, teams with existing App Service experience who do not need these capabilities and are familiar with App Service specific networking and deployment models may prefer Web App for Containers. 

Be aware that generalizations can help narrow down the list of Azure containers services to explore. But it is also important to verify a service fit by examining individual requirements in detail and matching them to Azure service specific feature sets. 

## Next steps

To learn more about the services covered in this article, please review their documentation.

[Azure Kubernetes Service (AKS) documentation | Microsoft Learn](/azure/aks/)

[Container Apps documentation | Microsoft Learn](/azure/container-apps/)

[Azure App Service documentation - Azure App Service | Microsoft Learn](/azure/app-service/)

## Contributors

**Principal authors**

- Andre Dewes. 
- Xuhong Liu. 
- Marcos Martinez.
- Julie Ng.

**Contributors**

- Martin Gjoshevski. 
- Don High.
- Nelly Kiboi.  
- Faisal Mustafa.
- Walter Myers.
- Sonalika Roy. 
- Paolo Salvatori. 
- Victor Santana.

