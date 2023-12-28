---
title: General considerations for choosing an Azure container service 
description: Get a quick overview of common feature-level considerations that can help you choose an Azure container service. Part two of a series. 
author: julie-ng
ms.author: julng
ms.date: 12/29/2023
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

Successful architectures require that planning and design decisions are made to ensure workload requirements are met and ensure quality around reliability, security, cost optimization, operational excellence, and performance efficiency.

## Overview

Use this article to get a quick overview of common feature level considerations that can be deal-breakers for some workloads when choosing an Azure container service. 

> [!note]
> This article builds upon the “Choose an Azure container service” overview article. It’s strongly recommended to first read that overview article for additional context to architectural considerations.

The considerations in this article are divided into four categories:

[Architectural and network considerations]

- Operating system support
- Network address spaces
- Understanding traffic flow
- Subnet planning 
- Number of ingress IPs available
- User Defined Routes and NAT Gateway support
- Private networking integration
- Protocol coverage
- Load balancing
- Service discovery
- Custom domains and managed TLS
- Mutual TLS
- Azure service-specific networking concepts

[Security considerations]

- Securing intra cluster traffic with network policies
- Network Security Groups
- Key Vault Integration
- Managed identity support
- Threat protection and vulnerability assessments with Defender for Containers
- Security Baselines
- Azure Well-Architected Framework for Security 

[Operational considerations]

- Updates and patches
- Container image updates
- Infrastructure vertical scalability
- Infrastructure horizontal scalability
- Application scalability
- Observability
- Azure Well-Architected Framework for Operational Excellence

[Reliability considerations] 

- Service Level Agreements
- Redundancy with Availability Zones
- Health checks and self-healing
- Zero downtime application deployments
- Resource limits
- Azure Well-Architected Framework for Reliability

Please note that this article focuses on a subset of Azure container services that offer a mature feature set around web applications and APIs, networking, observability, developer tools, and operations: Azure Kubernetes Service, Azure Container Apps, and Web App for Containers. For a complete list of all Azure container services, please see [the container services product category page](https://azure.microsoft.com/products/category/containers/).

> [!note]
> In this guide, the term *workload* refers to a collection of application resources that support a common business goal or the execution of a common business process, with multiple components, such as APIs and data stores, working together to deliver specific end-to-end functionality.

## Architectural considerations

This section explores architectural decisions that are **difficult to reverse or pivot without** **causing** **significant downtime or re-deployment**. This is especially relevant for fundamental components like networking and security.

These considerations are not specific to Well Architected Framework pillars. However, they deserve extra scrutiny and evaluation against businesses requirements when deciding on an Azure container service.

### Operating system support

Most containerized applications run in Linux containers, which are supported by all Azure container services. Workload components that require Windows containers are limited in choices.

| | **ACA** | **AKS** | **Web App for Containers** |
|---|:---:|:---:|:---:|
| **Linux OS support** | ✅ | ✅ | ✅ |
| **Windows OS support** | ❌ | ✅ | ✅ |
| **Mixed OS support** | ❌ | ✅ | ❌* |

\*mixed OS support for Web App requires separate App Service Plans for Windows and Linux.

## Networking considerations

Networking design is important to understand up front due to security and compliance constraints and guidelines imposed. In general, the major differences between the Azure services covered in this guide will depend on preference around simplicity and configurability:

- Azure Container Apps is a PaaS offering with many Azure managed networking features, such as service discovery and internal managed domains. Workload teams who need a bit more configurability may be able to take advantage of workload/dedicated profiles before resorting to AKS to meet all networking requirements.
- Azure Kubernetes Service (AKS) is the most configurable of the three services and offers the greatest control over network flow, for example custom ingress controllers or controlling intra-cluster traffic with Kubernetes network policies. These implementations, however, are customer managed and thus also increase operational overhead.
- Web App for Containers is part of the App Service offering and thus the networking concepts, especially private networking integration are very App Service specific. This will feel familiar to workload teams already using App Service. Teams without App Service experience looking for a more familiar Azure virtual network integration are encouraged to explore Azure Container Apps.

Keep in mind that networking is a foundational infrastructure layer. Changes in design are often difficult without workload re-deployment, which can lead to downtime. Therefore, review this section carefully if your workload has specific networking requirements before narrowing down your Azure container service selection.

### Network address spaces

Integrating applications into virtual networks requires some IP address planning to ensure enough IP addresses are available for container instances. When sizing, plan also for additional addresses for updates, blue/green deployments, and similar situations when extra instances are deployed, which will consume additional IP addresses.

| | **ACA** | **AKS** | **Web App for Containers** |
|---|:---:|:---:|:---:|
| **Dedicated subnet(s)** | Consumption plan: optionalDedicated plan: required | required | optional |
| **IP Address requirements** | Consumption plan: [See](/azure/container-apps/networking?tabs=azure-cli)[See Consumption only environment](/azure/container-apps/networking?tabs=azure-cli)Dedicated plan: See Workload Profile Environment | [See Azure virtual networks for AKS](/azure/aks/concepts-network) | [See App Service Subnet requirements](/azure/app-service/overview-vnet-integration) |

Please note Azure Kubernetes Service (AKS) requirements depend on the chosen network plugin. Some network plugins for AKS require broader IP reservations, which is outside the scope of this article. For more information, see network concepts for Azure Kubernetes Services (AKS).

### Understanding traffic flow

Understanding the types of traffic flow required for a solution can affect the network design depending on the chosen Azure service.

The following sections detail different networking constraints. These constraints would affect your need to deploy additional subnets depending on the need for multiple co-located workloads, a need for private and/or public ingress, and a need for an access-controlled flow of East-West traffic in a cluster (for ACA and AKS) or within a Virtual Network (all Azure container services).

### Subnet planning

Having a subnet large enough to include instances of your application for your workload is not the only factor that dictates the network footprint where these applications are deployed.

| | **ACA** | **AKS** | **Web App for Containers** |
|---|:---:|:---:|:---:|
| **Support for co-located workloads within** **subnet*** | ❌* | ✅ | N/A* |

*** This** **describes** **the best practice, not a technical limitation.**

For ACA, subnet integration only applies to a single ACA environment. Each ACA environment is constrained to a single ingress IP, public or private. Each ACA environment is only meant for a single workload in which dependent applications are co-located within that environment. Therefore, additional Azure networking appliances around ingress load balancing must be introduced if there’s a need for both public and private ingress, for example Azure Application Gateway or Azure Front Door. Furthermore, if you have multiple workloads that need to be segregated, additional ACA environment(s) are required and thus, an additional subnet must be allocated for each environment.

AKS offers granular East-West network flow control within the cluster in the form of Kubernetes Network Policy. Unlike ACA, this allows you to host multiple workloads within the same subnet. This translates to a steeper adoption curve for AKS, but more configurability options.

For Web App for Containers, there are no constraints on how many apps you can integrate with a single subnet if the subnet is large enough. There are no best practices around access control between different Web Apps in the same virtual network. Each Web App independently manages access control for East-West or North-South traffic from the virtual network or Internet, respectively.

**Note**: It is not possible to resize subnets with resources deployed in them. Take extra care in planning your network in advance to avoid having to redeploy entire workload components with possible downtime.

### Number of ingress IPs available

With the prior subnet planning section in mind, the following chart pays special attention to how many IPs can be exposed for an arbitrary number of applications hosted within a single deployment of an Azure container service.

| | **ACA** | **AKS** | **Web App for Containers** |
|---|:---:|:---:|:---:|
| **Number of ingresses IPs** | 1 | Many | ASE: 1Non-ASE: Many |

ACA allows one IP per environment, public or private. AKS allows for any number of IPs, public or private. Web App for Containers in a non-ASE environment allows for 1 public IP for all apps within an App Service Plan and multiple, different private IPs using Azure Private Endpoints. 

It’s important to note that Web Apps integrated into an ASE will only receive traffic through the single ingress IP associated with the ASE, whether it be public or private.

### User Defined Routes and NAT Gateway support

If a workload requires user defined routes (UDR) and NAT gateway capabilities for granular networking control, ACA requires isolated infrastructure via workload profiles, which are only available in the ACA dedicated/workload profiles Plan. AKS and Web App for Containers make use of these two networking features through standard virtual network functionality or virtual network integration, respectively. To elaborate, AKS node pools and Web App for Containers in an ASE environment already reside as direct virtual network resources, while Web App for Containers in a non-ASE environment will support UDR and NAT gateway via Virtual  Network Integration With Virtual Network integration, your resource technically does not reside directly in the virtual network but all its outbound access flows through the virtual network and the network’s associated rules affect traffic as expected.

| | **ACA** | **AKS** | **Web App for Containers** |
|---|:---:|:---:|:---:|
| **UDR Support** | Consumption plan: ❌Dedicated plan: ✅ | ✅ | ✅ |
| **NAT Gateway support** | Consumption plan: ❌Dedicated plan: ✅ | ✅ | ✅ |

### Private networking integration

Workloads that require strict layer 4 private networking for both ingress and egress should explore ACA, AKS, and the single-tenant App Service Environment (ASE) SKU, where workloads are deployed *into* a self-managed virtual network, offering the granular and customary private networking controls.

| | **ACA** | **AKS** | **Web App for Containers** |
|---|:---:|:---:|:---:|
| **Private** **ingress** **into** **a** **virtual network** | ✅ | ✅ | via Private Endpoint feature |
| **Private** **egress** **from** **a** **virtual network** | ✅ | ✅ | via virtual network integration feature |
| **Fully suppressed public endpoint** | ✅ | ✅ | ASE Only |

##### Private Networking with Web App for Containers

Web App for Containers has additional networking features which are not surfaced in the same fashion by the other Azure services in this article. Workload teams must familiarize themselves with these networking concepts to implement strict private networking requirements. Please carefully review these networking features, e.g. Private Endpoint and Virtual Network integration.

Customers who want a PaaS solution and prefer networking concepts shared across multiple Azure solutions should consider ACA.

### Protocol coverage

One important consideration for the hosting platform is what networking protocols are supported for the incoming application requests (ingress). While Web App for Containers is the strictest option supporting only HTTP and HTTPS, ACA additionally allows incoming TCP connections and AKS is the most flexible supporting unconstrained usage of TCP and UDP on self-selected ports.

| | **ACA** | **AKS** | **Web App for Containers** |
|---|:---:|:---:|:---:|
| **Protocol** **and port** **support** | HTTP (port 80)\*HTTPS (port 443)\*TCP (ports 1-65535, except 80 and 443) | TCP (any port)UDP (any port) | HTTP (port 80)HTTPS (port 443) |
| **WebSocket support** | ✅ | ✅ | ✅ |
| **HTTP/2 support** | ✅ | ✅ | ✅ |

* Within the ACA Environment, HTTP/S can be exposed on any port for intra cluster communication. In this scenario, ACA built-in HTTP features such as CORS and session affinity will not apply.

Both ACA and Web App for Containers support TLS 1.2 for their built-in HTTPS ingress.

### Load balancing

When using ACA and Web App for Containers, Azure manages both the layer 4 and layer 7 load balancers.

AKS however leverages a shared responsibility model where Azure manages the underlying Azure infrastructure that is configured by the workload team using the Kubernetes API. For layer 7 load balancing in AKS, workload teams can choose an Azure managed option, e.g. App Gateway for Containers or deploy and self-manage an ingress controller of their choice.

| | **ACA** | **AKS** | **Web App for Containers** |
|---|:---:|:---:|:---:|
| **L4 Load Balancer** | Azure managed | *Shared* *responsibility* | Azure managed |
| **L7 Load Balancer** | Azure managed | *Shared or* *self-managed* | Azure managed |

### Service discovery

In cloud architectures, runtimes can be removed and recreated at any time to rebalance resources, so instance IP addresses regularly change. Such architecture leverages fully qualified domain names (FQDNs) for reliable and consistent communication.

| | **ACA** | **AKS** | **Web App for Containers** |
|---|:---:|:---:|:---:|
| **Service Discovery** | Azure managed FQDN | Kubernetes configurable | Azure managed FQDN |

Azure Web Apps for Containers provide public ingress fully qualified domain names (FQDNs) out of the box without additional DNS configuration (north-south communication). However, there is no built-in mechanism to facilitate or restrict traffic between other apps (west-east communication).

Azure Container Apps (ACA) also provides public ingress FQDNs. However, ACA goes further by allowing the app FQDN to be exposed and restricting traffic only within the same environment. This makes it easier to manage east-west communication and enable components such as Dapr.

AKS requires the deployment of Kubernetes services as defined by the Kubernetes API, which are used to expose applications to the network in an addressable way. This entails additional configuration, as Kubernetes deployments are not initially discoverable within or outside the cluster. 

***\*Important note****

Only ACA and AKS offer service discovery through internal DNS schemes within their respective environments. This can simplify DNS configurations across dev/test and prod. For example, these environments can be created with arbitrary service names which only have to be unique within the environment or cluster and thus they can be the same across dev/test and prod. For Web App for Containers, service names must be unique across different environments to avoid conflicts with Azure DNS. 

### Custom domains and managed TLS

Both ACA and Web App for Containers offer out of the box (OOTB) solutions for custom domains and certificate management.

| | **ACA** | **AKS** | **Web App for Containers** |
|---|:---:|:---:|:---:|
| **Configure Custom Domains** | OOTB | DIY | OOTB |
| **Managed TLS for Azure FQDNs** | OOTB | N/A | OOTB |
| **Managed TLS for custom domains** | In preview | DIY | OOTB or BYO |

AKS requires workload teams to set up their own ingress controllers, configure custom domain names on the cluster and DNS, and manage their own certificates. Teams considering AKS can use CNCF projects, for example the popular cert-managerto manage TLS certificates, nginx or Traefik for ingress needs.

### Mutual TLS

Another alternative to restrict incoming traffic is by using mutual TLS (mTLS): a security protocol that ensures that both the client and server in communication are authenticated. This is achieved by both parties exchanging and verifying certificates before any data is transmitted.

Web App for Containers has built-in support for mTLS for incoming client connections. However, it is the responsibility of the application to validate that certificate by accessing the *X-ARR-ClientCert* HTTP header that the App Service platform forwards.

ACA also has built-in support for mTLS and it forwards the client certificate to the application in the HTTP header *X-Forwarded-Client-Cert.* Additionally, you can enable automatic mTLS for internal communication between the apps within the same environment effortlessly.

AKS does not provide out of the box experience for mTLS, as such workload teams should consider installing a service mesh to accomplish this.

### Azure service-specific networking concepts

The topics above are just a selection of the most common topics to consider. For more details and to learn more about Azure container service specific networking features, please see these Azure service specific guides:

- ACA - Networking environment in Azure Container Apps
- AKS - Network concepts for applications in Azure Kubernetes Service (AKS)
- Web App for Containers - App Service networking features

The topics above focus on network design. Continue to the next section on security considerations to learn more about networking security and securing network traffic.

## Security considerations

Security is of the utmost importance for every workload. Failure to address security risks could lead to unauthorized access, data breaches, or leakage of sensitive information. Containers offer an encapsulated environment for your application. The hosting systems and underlying network overlays, however, require additional guardrails. Your Azure container service selection needs to support your specific requirements on how to secure each application individually and implement proper security measures to prevent unauthorized access and mitigate the risk of attacks.

### Security comparison overview

When it comes to workload security, most Azure services including ACA, AKS, and Web App integrate with key security offerings including Azure Key Vault and Managed Identities.

AKS offers more configurability at the cost of additional overhead of running a Kubernetes cluster. While AKS offers unique features like network policies, it is also important to understand that in part, it offers more security features because its attack surface is greater. For example, AKS surfaces Kubernetes components including the control plane and virtual machine nodes, which in turn require additional security protection.

For a detailed comparison, review the considerations below carefully to ensure your workload security requirements can be met.

## Kubernetes Control Plane Security

AKS offers the most flexibility with full access to the Kubernetes API to customize container orchestration. This access to the Kubernetes API, however, also represents a significant attack surface and thus must be secured by customers. 

Important – please note this section is not relevant for Web App for Containers, which uses the ARM API as its control plane.

#### **Identity based security**

Customers are responsible for securing identity based access to the API. Out of the box, Kubernetes provides its own authentication and authorization management system, which also needs to be secured with access controls. 

To leverage a single plane of glass for identity and access management on Azure, it is best practice to [disable Kubernetes specific local accounts](/azure/aks/manage-local-accounts-managed-azure-ad) and instead [implement AKS-managed Microsoft Entra integration](/azure/aks/enable-authentication-microsoft-entra-id) and combine with [Azure RBAC for Kubernetes](/azure/aks/manage-azure-rbac). In this way, administrators do not have to perform IAM on multiple platforms. 

| | **ACA** | **AKS** |
|---|:---:|:---:|
| **Kubernetes API Access Controls** | No Access | Full Access |

<br>Customers who use ACA do not have access to the Kubernetes API, which is secured by Microsoft. 

#### **Network** **Based** **Security**

Customers who wish to restrict network access to the Kubernetes control plane must use AKS, which offers two options. The first option is to use [private AKS clusters](/azure/aks/private-clusters?tabs=azure-portal), which uses private link between the API Server’s private network and the AKS cluster’s private network. The second option is [API Server VNet integration (preview)](/azure/aks/api-server-vnet-integration), where the API server is integrated into a delegated subnet. Please review the documentation to learn more.

There are consequences to network restricted access to the Kubernetes API, most notably, management can only be performed from within the private network, which means customers need to deploy their self-hosted agents for Azure DevOps or GitHub Actions. See the feature specific documentation for further limitations.

| | **ACA** | **AKS** |
|---|:---:|:---:|
| **Kubernetes API** **Network Security** | Not configurable in PaaS | Configurable: public IP or private  IP |

<br>These considerations do not apply to ACA as a PaaS where Microsoft abstracts away the underlying infrastructure.

## Data Plane Network Security

The following networking features can be used to control access to, from and within a workload.

### Securing intra cluster traffic with network policies

Some security postures require network traffic segregation *within* an environment, for example when in multi-tenant environments hosting multiple or multi-tiered applications. In these scenarios, customers should choose AKS and leverage network polices, a cloud native technology that enables granular configuration of layer 4 networking within a Kubernetes cluster.

| | **ACA** | **AKS** | **Web App for Containers** |
|---|:---:|:---:|:---:|
| **Network Policies** | Consumption plan: ❌Dedicated plan: ❌ | ✅ | ❌ |

AKS is the only Azure service in this guide that supports further workload isolation *within* the cluster.  Network policies are not supported in ACA and Web Apps.

### Network Security Groups

In all scenarios, it’s possible to regulate networking communication within the wider virtual network via Network Security Groups (NSG), which allows for L4 traffic rules regulating ingress and egress at the virtual network level.

| | **ACA** | **AKS** | **Web App for Containers** |
|---|:---:|:---:|:---:|
| **Network Security Groups** | Consumption plan: ✅Dedicated plan: ✅ | ✅ | ✅ VNet integrated apps – egress only |

**Built-in IP** **restrictions for** **ingress**

ACA and Web App for Containers don’t require virtual network integration; consequently, they offer built-in source IP restrictions for ingress traffic. AKS requires a bring-your-own solution to achieve similar traffic filtering.  

| | **ACA** | **AKS** | **Web App for Containers** |
|---|:---:|:---:|:---:|
| **Built-in** **ingress IP** **restrictions** | ✅ | ❌ | ✅ |

## Application-level Security

It is important to secure workloads not just at the network and infrastructure level, but also at the workload and application level. Azure container solutions integrate with Azure security offerings to help standardize security implementation and controls for your applications.

### Key Vault Integration

It is best practice to securely store and manage secrets, keys, and certificates in a key management solution like Azure Key Vault. Instead of storing and configuring secrets in code or in an Azure compute service, all applications should integrate with Key Vault.

Key Vault integration allows application developers to focus on their application code. All of these Azure services can automatically sync secrets from the Key Vault service and offer them to the application, typically as environment variables or as mounted files.

| | **ACA** | **AKS** | **Web App for Containers** |
|---|:---:|:---:|:---:|
| **Key Vault integration** | ✅ | ✅ | ✅ |

### Managed identity support

It is best practice to use managed identities to access Azure resources without secrets, e.g., pull images from Azure Container Registry without a username and password.

Azure container services offer managed identity support, configurable out of the box for ACA and Web App for Containers. For AKS, Azure offers integrated managed identity support for the Kubernetes control plane, ACR image management, and cluster add-ons. Managed identity for AKS applications is provided through the [Workload Identity](/azure/aks/workload-identity-overview) feature. Workload identities are relatively more complex than how managed identities are provided to application code in the other Azure services in this guide.

| | **ACA** | **AKS** | **Web App for Containers** |
|---|:---:|:---:|:---:|
| **Infrastructure Managed Identity support** | N/A | ✅ | N/A |
| **Container** **Pull Managed** **Identity support** | ✅ | ✅ | ✅ |
| **Application Managed Identity support** | ✅ | ✅ | ✅ |

### Threat protection and vulnerability assessments with Defender for Containers

Threat protection against vulnerabilities is also important and it is best practice to leverage Microsoft Defender for Containers. Currently runtime support is only available for AKS. Vulnerability assessments are supported in Azure Container Registries and thus can be used by any Azure container service, not just the ones mentioned in this guide.

Below is an overview of these security related capabilities with links to move information.

| | **ACA** | **AKS** | **Web App for Containers** |
|---|:---:|:---:|:---:|
| **Runtime threat protection** | ❌ | ✅ | ❌ |

Please note Container Image Vulnerability Assessments are not real time scans, but rather the Azure Container Registry is scanned at regular intervals.

## Security Baselines

In general, most Azure container services integrate Azure security offerings. AKS is more configurable, in part because its attack surface is larger. Overall, please keep in mind a security feature set is but a small piece of cloud security excellence. To understand the wider security picture, please review the following service specific security baselines:

- Azure security baseline for Azure Container Apps
- Azure security baseline for Azure Kubernetes Service
- Azure security baseline for App Service

The security baselines cover more Azure integrations, including hardware encryption, logging, etc., which are out of scope for this guide.

## Azure Well-Architected Framework for Security

This article focusses on the main differences between the container services features in Azure. If you want to explore the full Security guidance for each service available in the Azure Well-Architected Framework, check out these references:

- **AKS**: [Azure Well-Architected Framework review for Azure Kubernetes Service (AKS) - Microsoft Azure Well-Architected Framework | Microsoft Learn](/azure/well-architected/service-guides/azure-kubernetes-service)

## Operational considerations

To successfully run a workload in production, teams need to implement operational excellence practices including centralized logging, monitoring, scalability, regular updates/patching, image management and more. 

In general, AKS offers the most configurability and thus has the greatest operational task diversity and complexity. In contrast, Azure will assume many operational responsibilities e.g. updates for PaaS offerings like ACA and Web App.

### Updates and patches

Ensuring that your application’s underlying OS is updated and regularly patched is of utmost importance. Keep in mind, however, that with every update there is a risk of failure. Below are the main considerations for the Azure container services as they pertain to a shared responsibility between customer and platform.

AKS is a hybrid IaaS/PaaS solution and thus the workload team, not Microsoft, is responsible for upgrading their clusters’ control and application planes. As a managed Kubernetes service, Azure will provide the updated images for the Node OS and control plane components, but customers are responsible for triggering or scheduling the updates. Review the AKS day 2 operations guide to understand how to [Patch and upgrade AKS clusters](/azure/architecture/operator-guides/aks/aks-upgrade-practices).

ACA and Web App for Containers are PaaS solutions and thus Azure is responsible for and will manage updates and patches for customers without additional version complexity compared to AKS.

| | **ACA** | **AKS** | **Web App for Containers** |
|---|:---:|:---:|:---:|
| **Control Plane Updates** | Platform | Customer | Platform |
| **Host Updates/Patches** | Platform | Customer | Platform |
| **Container Image Updates/Patches** | Customer | Customer | Customer |

### Container image updates

Irrespective of the Azure container solution, customers are always responsible for their own container images. Thus, if there are security patches for container base images, it is the responsibility of customers to rebuild their images. To be alerted of such vulnerabilities, customers should use [Microsoft Defender for Containers](/azure/defender-for-cloud/defender-for-containers-introduction) for containers hosted in Azure Container Registry.

## Scalability

Scaling is used to adjust resource capacity to meet the current demands, adding more capacity to ensure performance and removing unused capacity to save on costs. When choosing a container solution, it is important to consider the infrastructure constraints and scaling strategies. 

#### **Infrastructure** **vertical** **scalability**

Vertical scaling refers to the ability to increase or decrease existing infrastructure, e.g. compute CPU and memory. Different workloads will require different amounts of compute resources. When choosing an Azure container solution, it is important to be aware of the hardware SKU offerings available to a particular Azure service as they vary and can pose additional constraints. See the articles below for more details on SKU offerings for each:

For Azure Kubernetes Service, review the [sizes for virtual machines in Azure](/azure/virtual-machines/sizes) documentation paired with [per-region AKS restrictions](/azure/aks/quotas-skus-regions) documentation.

[Workload profiles types in Azure Container Apps](/azure/container-apps/workload-profiles-overview)

[App Service Pricing](https://azure.microsoft.com/en-us/pricing/details/app-service/linux/)

#### **Infrastructure** **horizontal** **scalability**

Horizontal scaling refers to the ability to increase or decrease capacity via new infrastructure, e.g. VM nodes. When scaling in and out, ACA Consumption tier will abstract the underlying virtual machines. For the remaining Azure container services, the horizontal scaling strategy is managed through the standard Azure Resource Manager API.

Please note scaling out and in includes re-balancing of instances and thus also poses a downtime risk, which is smaller than with vertical scaling. Nevertheless, workload teams are always responsible for ensuring their applications can handle failure as well as implementing graceful startups and shutdowns of their applications to avoid downtime.

| | **ACA** | **AKS** | **Web App for Containers** |
|---|:---:|:---:|:---:|
| **Infrastructure scale in/out** | Consumption plan: N/ADedicated plan: configurable | configurable | configurable |
| **Flexible Hardware Provisioning** | Consumption plan: N/ADedicated plan: Abstracted with workload profiles | Any VM SKU | Abstracted -<br>service plans |

**\*Important note***

The hardware provisioning options available through ACA Dedicated (workload profiles) and Web App for Containers (App Service Plans) are not as flexible as AKS. It’s important to familiarize yourself with the SKUs available in each to ensure your needs are met.

#### **Application Scalability**

The typical measure on which to trigger scaling of infrastructure and applications is via resource consumption, e.g., CPU and memory. Some container solutions can scale container instance count on metrics with application-specific context, such as HTTP request. For example, AKS and ACA can scale container instances based on message queues via KEDA and many other metrics via its scalers, which provides great flexibility when you are deciding what is the best scalability strategy for your application. Web App for Containers relies on the scalability options provided in Azure platform (check the table below for more details and references on them) and does not support custom scalers configurations such as KEDA. 

| | **ACA** | **AKS** | **Web App for Containers** |
|---|:---:|:---:|:---:|
| **Container** **scale out** | HTTP, TCP, or Metrics-based (CPU, memory, event-driven) | Metrics-based (CPU, memory, or custom) | Manual, metrics-based, or automatic (preview) |
| **Event Driven scalability** | Yes, Cloud Native | Yes, Cloud Native, additional config required | Yes, Azure resource specific |

## Observability

### Workload instrumentation

Applications can be complex and multi-tiered, and thus gathering metrics can be challenging. Containerized workloads can integrate with Azure Monitor for metrics in two ways:

- **Autoinstrumentation**: zero code changes required.
- **Manual instrumentation**: *small* code changes required to integrate and configure SDK and/or client.

  | | **ACA** | **AKS** | **Web App for Containers** |
  |---|:---:|:---:|:---:|
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

| | **ACA** | **AKS** | **Web App for Containers** |
|---|:---:|:---:|:---:|
| **Support for log streaming (real-time streaming)** | ✅ | ✅ | **✅** |
| **Support** **for** **Azure Monitor** | ✅ | ✅ | ✅ |
| **Azure Monitor** **resource** **logs** | ConsoleSystem | Kubernetes API Server, Audit, Scheduler, Cluster Autoscaler and more… | ConsoleLogs, HTTPLogs, EnvironmentPlatformLogs and more… |

For a more detailed description of each of the resource logs in the table above, check the referenced links. A short summary of the logging capabilities of the container services:

- **ACA** **abstracts all its internal** **Kubernetes logs into two simple categories. One called** ***Console***** logs which contains the** **workload** **container logs** **and a second** ***System***** category which contains all platform-related** **logs.** 
- **AKS** **provides all** **Kubernetes-related logs** **and granular control on what can be logged or not. It also retains full compatibility with** **Kubernetes client tools** **for log streaming such as** ***kubectl***
- **Web App for Containers** **has many different categories of resource logs** **since its platform (App Service) is not exclusively running container workloads. However, for container-specific operations managing its internal Docker platform there is the** ***AppServicePlatformLogs***** log category. Another important** **log category is** ***AppServiceEnvironmentPlatformLogs*** **which contains** **events such as** **scaling and configuration** **changes**

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

| **Feature** | **ACA** | **AKS** | **Web Apps** |
|---|:---:|:---:|:---:|
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

| | **ACA** | **AKS** | **Web App for Containers** |
|---|:---:|:---:|:---:|
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

ACA and AKS, on the other hand, are much more flexible and offer similar options (since ACA is based on an internal Kubernetes platform). In comparison to AKS, ACA lacks the following options for health checking:

- gRPC support
- Named ports
- *Exec* commands<br>

#### Auto-healing

Identifying a bad container instance and stop sending traffic to it is one thing. But what can be done about the faulty instance after that? “Auto-healing” is the process of restarting the application in an attempt to recover from an unhealthy state. These are the differences between the Azure container services in that regard:

- **Web App for Containers**: there is no option to restart a container instance right after a health check fails. If it keeps failing for one hour, then it is replaced by a new instance. There is another feature called “*Auto-healing*” to monitor and restart instances not directly related to health checks but looking at different metrics of the application (such as memory limit, HTTP requests duration or status codes)
- **ACA** and** AKS** will automatically try to restart the container instance if the *liveness* probe reaches the defined failure threshold.

### Zero downtime application deployments

The ability to deploy and replace applications without having any downtime for the users is a crucial aspect for a reliable workload. All three Azure container services covered by this article support zero downtime deployments although in different ways.

| | **ACA** | **AKS** | **Web App for Containers** |
|---|:---:|:---:|:---:|
| **Zero downtime strategy** | Rolling update | Rolling update+All other Kubernetes strategies | Slots |

- **Web App for Containers**: it has a concept of slots, which are placeholders where you can deploy new versions of your containers and test them before sending to the Production slot. Each slot has its own separate host name, configuration, and binaries from the Production slot. However, this feature needs to be implemented and is not configured out-of-the-box.
- **ACA**: by default, any container deployed to ACA will have zero downtime (works like a Kubernetes rolling update) and you also have the possibility to validate and test them before sending to Production by using multiple revisions direct access
- **AKS**: the default deployment strategy in Kubernetes is called rolling update, which will start new instances of your container in parallel with the existing and only after kill the old ones after the new are started, resulting in no downtime. However, you can also choose among other deployment strategies available in Kubernetes.

### Resource limits

Another important aspect of having a reliable shared environment is how you control the resource usage (like CPU or memory) of your containers, to avoid a single application taking over all the resources leaving other applications in a bad state.

| | **ACA** | **AKS** | **Web App for Containers** |
|---|:---:|:---:|:---:|
| **Resource limits (CPU/Memory)** | Per app/container | Per app/containerPer namespace | Per App Service Plan |

- **Web App for Containers:** You can host multiple applications (containers) within a single App Service Plan. For example, you might allocate a plan with 2 CPU cores and 4 GiB RAM and there you can run multiple web apps with containers. However, you can not restrict one of these apps to take certain amount of CPU or memory. They all will compete for the same resources of the App Service Plan. If you want to isolate your application resources, you will need to create additional App Service Plans.
- **ACA:** **You can set** **CPU and Memory** **limits** **per application within your environment.** **However, the** **choice of CPU and Memory must match** **one of the allowed combinations from the official documentation. For example, you can’t set** **1 vCPU** **+** **1 GiB memory, it needs to be 1 vCPU + 2 GiB memory. An ACA environment is analogue to a Kubernetes namespace.**
- **AKS:** **You are free to** **choose your own combination of** **vCPU and Memory** **as long as your** **nodes have** **the hardware for it. Additionally, you can limit resources in the** **namespace level if you want to** **segment** **your cluster that way.**

### Azure Well-Architected Framework for Reliability

This article focusses on the main differences between the container services features in Azure. If you want to explore the full reliability guidance for each service available in the Azure Well-Architected Framework, check out these references:

- **AKS**: [Azure Well-Architected Framework review for Azure Kubernetes Service (AKS) - Microsoft Azure Well-Architected Framework | Microsoft Learn](/azure/well-architected/service-guides/azure-kubernetes-service)
- **ACA**: [Reliability in Azure Container Apps | Microsoft Learn](/azure/reliability/reliability-azure-container-apps?tabs=azure-cli)
- **Web App for Containers**: [Azure App Service and reliability - Microsoft Azure Well-Architected Framework | Microsoft Learn](/azure/well-architected/service-guides/azure-app-service/reliability)

## Conclusion

Well-architected solutions set the foundations for successful workloads, which require conscious research and decision making. While architecture can be adjusted as a workload grows and teams progress on their cloud journeys, some decisions, especially around networking are difficult to reverse without significant downtime or re-deployments.

In general, when comparing various Azure container services, a theme emerges: Azure Kubernetes Service (AKS) offers the greatest configurability at cost of additional operational overhead. Workload teams who, for example, have less operations experience or prefer to focus on developer features, may prefer a PaaS service and are encouraged to explore Azure Container Apps.

Although ACA and Web App for Containers are both PaaS offerings with similar levels of Microsoft managed infrastructure, a key difference is that ACA is closer to Kubernetes and offers additional cloud native capabilities around service discovery, event driven autoscaling, Dapr integration, and more. However, teams with existing App Service experience who do not need these capabilities and are familiar with App Service specific networking and deployment models may prefer Web App for Containers. 

Be aware that generalizations can help narrow down the list of Azure containers services to explore. But it is also important to verify a service fit by examining individual requirements in detail and matching them to Azure service specific feature sets. 

## Next Steps

To learn more about the services covered in this article, please review their documentation.

[Azure Kubernetes Service (AKS) documentation | Microsoft Learn](/azure/aks/)

[Azure Container Apps documentation | Microsoft Learn](/azure/container-apps/)

[Azure App Service documentation - Azure App Service | Microsoft Learn](/azure/app-service/)

## Contributors

**Principal Authors**

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

