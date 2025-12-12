This architecture shows a microservices application deployed to Azure Kubernetes Service (AKS). It describes a basic AKS configuration that you can use as the starting point for most deployments. This article assumes that you have a basic understanding of Kubernetes. It highlights the infrastructure and developer operations (DevOps) aspects of how to manage microservices on AKS. For production deployments, this architecture recommends that you use Azure CNI powered by Cilium as the networking solution. This service provides improved performance, built-in network policy enforcement, and enhanced observability through its Extended Berkeley Packet Filter (eBPF)-based data plane. For more information about how to design microservices, see [Microservices architecture design](../../../guide/architecture-styles/microservices.md).

## Architecture

:::image type="complex" border="false" source="./images/microservices-architecture.svg" alt-text="Diagram that shows the microservices on AKS reference architecture." lightbox="./images/microservices-architecture.svg":::
   The diagram shows the microservices on the AKS reference architecture. It depicts an application composed of multiple microservices deployed to AKS. The Cilium logo between the AKS cluster and the virtual network represents Azure CNI powered by Cilium, which provides the networking layer with eBPF-based data plane for improved performance and network policy enforcement. The request flow uses the publisher-subscriber, competing consumers, and gateway routing cloud design patterns. The flow starts with the client application sending a JSON payload over HTTPS to the load balancer's public fully qualified domain name to schedule a drone pickup. The load balancer routes the request to the ingestion microservice, which processes and queues delivery requests in an Azure Service Bus queue. The workflow microservice then consumes messages from the Service Bus queue and sends HTTPS requests to multiple microservices. These services include the drone scheduler, delivery, and package microservices. The delivery microservice stores data in Azure Managed Redis, and the package microservice stores data in MongoDB. An HTTPS GET request returns the delivery status. It passes through the load balancer to the delivery microservice, which reads data from Azure Managed Redis.
:::image-end:::

*Helm is a trademark of the Cloud Native Computing Foundation (CNCF). No endorsement is implied by the use of this mark.*

*Download a [Visio file](https://arch-center.azureedge.net/microservices-architecture.vsdx) of this architecture.*

For an example of a more advanced microservice that's built on the [AKS baseline architecture](https://github.com/mspnp/aks-baseline), see the [advanced AKS microservices architecture](./aks-microservices-advanced.yml).

### Data flow

This request flow implements the [Publisher-Subscriber](/azure/architecture/patterns/publisher-subscriber), [Competing Consumers](/azure/architecture/patterns/competing-consumers), and [Gateway Routing](/azure/architecture/patterns/gateway-routing) cloud design patterns.

The following data flow corresponds to the previous diagram:

1. The client application sends a JSON payload over HTTPS to the public fully qualified domain name (FQDN) of the load balancer (managed ingress controller) to schedule a drone pickup.

   - The managed ingress controller routes the request to the ingestion microservice.

   - The ingestion microservice processes the request and queues delivery requests in an Azure Service Bus queue.

1. The workflow microservice takes the following actions:

   - Consumes message information from the Service Bus message queue

   - Sends an HTTPS request to the delivery microservice, which passes data to external data storage in Azure Managed Redis

   - Sends an HTTPS request to the drone scheduler microservice

   - Sends an HTTPS request to the package microservice, which passes data to external data storage in MongoDB

1. An HTTPS GET request returns the delivery status. This request passes through the managed ingress controller into the delivery microservice. Then the delivery microservice reads data from Azure Managed Redis.

### Components

- [AKS](/azure/well-architected/service-guides/azure-kubernetes-service) is a managed Kubernetes service that hosts and orchestrates the microservices containers. In this architecture, AKS provides the runtime platform for deploying, scaling, and managing the drone delivery application's microservices.

- [Azure CNI powered by Cilium](/azure/aks/azure-cni-powered-by-cilium) is the recommended networking solution to connect directly to an Azure virtual network. In this architecture, it assigns IP addresses from the virtual network to pods and provides built-in network policy capabilities and traffic visibility.

- An ingress server exposes HTTP and HTTPS routes to services inside a cluster. In this architecture, a [managed NGINX-based ingress controller](/azure/aks/app-routing) is used through an application routing add-on. The ingress controller implements the [API gateway](#api-gateway) pattern for microservices.

- External data stores, like [Azure SQL Database](/azure/well-architected/service-guides/azure-sql-database-well-architected-framework) or [Azure Cosmos DB](/azure/well-architected/service-guides/cosmos-db), are used by stateless microservices to write their data and other state information. In this architecture, [Azure Cosmos DB](/azure/cosmos-db/), [Azure Managed Redis](/azure/redis/overview), [Azure DocumentDB](/azure/documentdb/overview) and [Service Bus](/azure/service-bus-messaging/service-bus-messaging-overview) serve as data stores or places to store state.

- [Microsoft Entra ID](/entra/fundamentals/whatis) is a cloud-based identity and access management service that provides authentication and authorization capabilities for the AKS cluster and deployed workloads. AKS requires Microsoft Entra ID integration to provide a [managed identity](/azure/aks/use-managed-identity) for accessing Azure Container Registry and provisioning Azure resources like load balancers and managed disks. Each workload deployed on the AKS cluster requires an identity to access Microsoft Entra-protected resources, like Azure Key Vault and Microsoft Graph. This architecture uses [Microsoft Entra Workload ID](/azure/aks/workload-identity-overview) to integrate with Kubernetes and provide secure identities for workloads. Alternatively, you can use managed identities or application credentials for workload authentication.

- [Container Registry](/azure/container-registry/container-registry-tasks-overview) is a managed service that can store private container images, which are deployed to a cluster. AKS can authenticate with Container Registry by using its Microsoft Entra identity. Microservice container images are built and pushed to Container Registry. In this architecture, Container Registry stores the private container images for the microservices that get deployed to the AKS cluster.

- [Azure Pipelines](/azure/devops/pipelines/get-started/what-is-azure-pipelines) is part of the Azure DevOps suite and runs automated builds, tests, and deployments. A [continuous integration and continuous deployment (CI/CD)](/azure/architecture/microservices/ci-cd) approach is highly recommended in microservice environments. Various teams can independently build and deploy microservices to AKS by using Azure Pipelines. In this architecture, Azure Pipelines builds and deploys the drone delivery microservices to AKS.

- [Helm](https://helm.sh/) is a package manager for Kubernetes that provides a mechanism to bundle and standardize Kubernetes objects into a single unit that you can publish, deploy, version, and update. In this architecture, Helm packages the drone delivery microservices for deployment to AKS.

- [Azure Monitor](/azure/azure-monitor/fundamentals/overview) is a monitoring platform that collects and stores metrics and logs, application telemetry, and platform metrics for Azure services. In this architecture, Azure Monitor integrates with AKS to collect metrics from controllers, nodes, and containers.

- [Application Insights](/azure/azure-monitor/app/app-insights-overview) is a performance monitoring tool that monitors microservices and containers. It can provide observability into microservices, which includes traffic flow, end-to-end latency, and error percentage. It can show the health of the microservices and the relationships between them on a single application map. In this architecture, Application Insights monitors the health and performance of the drone delivery microservices and shows their relationships on an application map.  

### Alternatives

[Azure Container Apps](/azure/container-apps/) is a managed serverless platform that delivers a Kubernetes-based experience without requiring infrastructure management. It serves as a simpler alternative to AKS for hosting microservices when you don't need direct access to Kubernetes or its APIs and don't require control over the cluster infrastructure.

Instead of the managed ingress gateway in AKS, you can use alternatives like Application Gateway for Containers, an Istio ingress gateway, or non-Microsoft solutions. For more information, see [Ingress in AKS](/azure/aks/concepts-network-ingress).

You can store container images in non-Microsoft container registries like Docker Hub.

For networking, while this architecture recommends [Azure CNI powered by Cilium](/azure/aks/azure-cni-powered-by-cilium) for its performance and built-in policy enforcement, you can use alternative networking solutions like Azure CNI Overlay for specific scenarios.

> [!IMPORTANT]
> If you require Windows nodes in your microservices architecture, review Cilium's current **Linux-only** limitation and plan appropriately for mixed OS pools. For more information, see [Azure CNI powered by Cilium limitations](/azure/aks/azure-cni-powered-by-cilium#limitations).

For microservices that must maintain state information, [Dapr](/azure/aks/dapr-overview) provides an abstraction layer for managing microservice state.

You can use GitHub Actions to build and deploy microservices, or choose non-Microsoft CI/CD solutions like Jenkins.

Microservice observability can be achieved with alternative tools like [Kiali](https://kiali.io/).

## Scenario details

A fictitious company called Fabrikam, Inc., manages a fleet of drone aircraft. Businesses register with the service, and users can request a drone to pick up goods for delivery. When a customer schedules a pickup, the back-end system assigns a drone and notifies the user with an estimated delivery time. When the delivery is in progress, the customer can track the drone's location with a continuously updated estimated delivery time.

### Potential use cases

Adopt the following best practices from the scenario to architect complex microservices-based applications in AKS:

- Complex web applications
- Business logic developed by using microservice design principles

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).

### Design

This reference architecture is focused on microservices, but many of the recommended practices apply to other workloads that run on AKS.

#### Microservices

A microservice is a loosely coupled, independently deployable unit of code. Microservices typically communicate through well-defined APIs and are discoverable through some form of service discovery. The Kubernetes service object is a typical way to model microservices in Kubernetes.

#### Data storage

In a microservices architecture, services shouldn't share data storage solutions. Each service should manage its own dataset to avoid hidden dependencies among services. Data separation helps avoid unintentional coupling between services. This process can happen when services share the same underlying data schemas. When services manage their own data stores, they can use the correct data store for their particular requirements. For more information, see [Data considerations for microservices](../../../microservices/design/data-considerations.md).

Avoid storing persistent data in local cluster storage because that method binds the data to the node. Instead, use an external service like SQL Database or Azure Cosmos DB. Another option is to mount a persistent data volume to a solution by using Azure Disk Storage or Azure Files. For more information, see [Storage options for applications in AKS](/azure/aks/concepts-storage).

#### Networking and network policy

For production microservices deployments on AKS, use [Azure CNI powered by Cilium](/azure/aks/azure-cni-powered-by-cilium) as the networking solution. This approach provides several benefits for microservices architectures:

- **Performance and scalability:** The eBPF-based data plane improves service routing performance and supports larger clusters that have lower latency compared to traditional networking solutions.

- **Network policy enforcement:** Cilium enforces Kubernetes NetworkPolicy resources without requiring a separate network policy engine like Azure Network Policy Manager or Calico. This integration simplifies cluster configuration and reduces operational overhead.

- **Observability:** The eBPF data plane provides visibility into network traffic, including Domain Name System (DNS) queries, pod-to-pod flows, and service-to-service communication. This visibility helps troubleshoot microservice interactions and identify performance bottlenecks.

- **Flexible IP address management:** Azure CNI powered by Cilium supports both virtual network routed and overlay pod IP address assignment models based on your workload's network architecture requirements.

When you implement network policies for microservices, follow a zero trust architecture principle by explicitly defining which services can communicate with each other. Start with deny-all policies and selectively allow only necessary traffic between microservices. For more information, see [Best practices for network policies in AKS](/azure/aks/use-network-policies).

#### API gateway

API gateways are a general [microservices design pattern](https://microservices.io/patterns/apigateway.html). An API gateway sits between external clients and the microservices. The gateway serves as a reverse proxy and routes requests from clients to microservices. An API gateway might also perform various cross-cutting tasks like authentication, Secure Sockets Layer (SSL) termination, and rate limiting. For more information, see the following resources:

- [Use API gateways in microservices](/azure/architecture/microservices/design/gateway)

- [Choose an API gateway technology](/azure/architecture/microservices/design/gateway#choose-an-api-gateway-technology)

In Kubernetes, an ingress controller primarily handles the functionality of an API gateway. The ingress and ingress controller work in conjunction to take the following actions:

- Route client requests to the correct back-end microservices. This routing provides a single endpoint for clients and helps decouple clients from services.

- Aggregate multiple requests into a single request to reduce chattiness between the client and the back end.

- Offload functionality from the back-end services, like SSL termination, authentication, IP address restrictions, or client rate limiting (known as *throttling*).

There are ingress controllers for reverse proxies, which include NGINX, HAProxy, Traefik, and Azure Application Gateway. AKS provides multiple managed ingress options. You can choose from a [managed NGINX-based ingress controller](/azure/aks/app-routing) through the application routing add-on or Application Gateway for Containers. Or you can choose an Istio ingress gateway as the ingress controller. For more information, see [Ingress in AKS](/azure/aks/concepts-network-ingress).

Kubernetes has replaced ingress resources with the more advanced and versatile Gateway API. Ingress controllers and the Gateway API are Kubernetes objects that manage traffic routing and load balancing. Designed to be generic, expressive, extensible, and role oriented, the Gateway API is a modern set of APIs for defining level-4 and level-7 routing rules in Kubernetes.

The ingress controller operates as the edge router or reverse proxy. A reverse proxy server is a potential bottleneck or single point of failure, so we recommend that you deploy at least two replicas to help ensure high availability.

#### When to choose ingress controllers or the Gateway API

Ingress resources are suitable for the following use cases:

- Ingress controllers are easy to set up and are suited for smaller and less complex Kubernetes deployments that prioritize easy configuration.

- If you currently have ingress controllers configured in your Kubernetes cluster and they meet your requirements effectively, you don't need to transition to the Kubernetes Gateway API immediately.

Use the Gateway API when the following factors apply:

- When you deal with complex routing configurations, traffic splitting, and advanced traffic management strategies. Kubernetes Gateway API Route resources provide the flexibility required in these cases.

- If networking requirements need custom solutions or the integration of non-Microsoft plug-ins. The Kubernetes Gateway API's approach, based on custom resource definitions, can provide enhanced extensibility.

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

#### Partition microservices

Use namespaces to organize services within the cluster. Every object in a Kubernetes cluster belongs to a namespace. It's a good practice to use namespaces to organize the resources in the cluster.

Namespaces help prevent naming collisions. When multiple teams deploy microservices into the same cluster, with possibly hundreds of microservices, managing them in a single namespace becomes difficult. Namespaces also let you do the following actions:

- Apply resource constraints to a namespace so that the total set of pods assigned to that namespace can't exceed the resource quota of the namespace.

- Apply policies at the namespace level, which include role-based access control (RBAC) and security policies.

When multiple teams develop and deploy microservices, namespaces provide a convenient mechanism to control areas that each team can deploy to. For example, Kubernetes [RBAC policies](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#role-and-clusterrole) grant development team A access only to namespace A, and grant development team B access only to namespace B.

For a microservices architecture, consider organizing the microservices into bounded contexts and creating namespaces for each bounded context. For example, all microservices related to the *Order Fulfillment* bounded context can go into the same namespace. Alternatively, create a namespace for each development team.

Place utility services into their own separate namespace. For example, you might deploy cluster monitoring tools like Elasticsearch and Prometheus to a monitoring namespace.

#### Health probes

Kubernetes defines three types of health probes that a pod can expose:

- **Readiness probe:** Tells Kubernetes whether the pod is ready to accept requests.

- **Liveness probe:** Tells Kubernetes whether a pod should be removed and a new instance started.
  
- **Startup probe:** Tells Kubernetes whether the pod is started.

To understand probes, first review how a service works in Kubernetes. A service has a label selector that matches a set of zero or more pods. Kubernetes load balances traffic to the pods that match the selector. Only pods that start successfully and are healthy receive traffic. If a container crashes, Kubernetes terminates the pod and schedules a replacement.

Sometimes a pod isn't ready to receive traffic, even if it starts successfully. For example, there might be initialization tasks underway, like when the application that runs in the container loads data into memory or reads configuration files. You can use a startup probe for these slow-starting containers. This approach helps prevent Kubernetes from terminating them before they have a chance to fully initialize.

Liveness probes check whether a pod is running but not working properly and needs a restart. For instance, if a container handles HTTP requests but suddenly stops responding without crashing, the liveness probe detects this event and triggers a restart of the pod. If you set up a liveness probe, it notices when a container isn't responding and prompts Kubernetes to restart the pod if the container repeatedly fails the probe.

Consider the following points when you design probes for microservices:

- If your code has a long startup time, a liveness probe might report a failure before the startup finishes. To delay the start of a liveness probe, use the startup probe, or use the `initialDelaySeconds` setting with the liveness probe.

- A liveness probe only helps if restarting the pod is likely to restore it to a healthy state. You can use a liveness probe to mitigate memory leaks or unexpected deadlocks, but don't restart a pod that you expect to fail again immediately.

- Sometimes readiness probes check dependent services. For example, if a pod has a dependency on a database, the probe might check the database connection. But this approach can create unexpected problems. An external service might be temporarily unavailable. This unavailability causes the readiness probe to fail for all the pods in your service, which results in their removal from load balancing. This removal creates cascading failures upstream.

  A better approach is to implement retry handling within your service so that your service can recover correctly from transient failures. As an alternative, the [Istio service mesh](/azure/aks/istio-about) can implement retry handling, error tolerance, and circuit breakers. This approach creates resilient architecture that can handle microservice failures.
  
For troubleshooting microservice health problems, use the network observability features in [Advanced Container Networking Services](/azure/aks/advanced-container-networking-services-overview). The eBPF data plane captures detailed network flow information between microservices, which helps you identify connectivity problems, DNS resolution problems, or network policy misconfigurations that might affect service health.

#### Resource constraints

Resource contention can affect the availability of a service. Define [resource constraints for containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) so that a single container can't overwhelm the cluster resources, like memory and CPU. For non-container resources, like threads or network connections, consider using the [Bulkhead pattern](../../../patterns/bulkhead.yml) to isolate resources.

Use [resource quotas](https://kubernetes.io/docs/concepts/policy/resource-quotas/) to limit the total resources allowed for a namespace. This limitation ensures that front-end services doesn't consume resources that back-end services need, and back-end services don't consume resources that front-end services need. Resource quotas can help allocate resources within the same cluster to multiple microservice development teams.

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

#### TLS and SSL encryption

In many implementations, the ingress controller is used for SSL termination. As part of deploying the ingress controller, you must create or import a Transport Layer Security (TLS) certificate. Only use self-signed certificates for development and test purposes. For more information, see [Set up a custom domain name and SSL certificate with the application routing add-on](/azure/aks/app-routing-dns-ssl).

For production workloads, get signed certificates from trusted certificate authorities.

You might also need to rotate your certificates depending on your organization's policies. You can use Key Vault to rotate certificates that microservices use. For more information, see [Configure certificate automatic rotation in Key Vault](/azure/key-vault/certificates/tutorial-rotate-certificates).

#### Network segmentation and policies

Implement network segmentation between microservices by using Kubernetes NetworkPolicy resources. When you use [Azure CNI powered by Cilium](/azure/aks/azure-cni-powered-by-cilium), the eBPF data plane enforces network policies.

Follow these best practices for network policies in microservices architectures:

- **Apply zero trust principles.** Start with deny-all network policies at the namespace level and explicitly allow only required traffic between microservices.

- **Segment by bounded context.** Create namespaces for each bounded context in your microservices architecture and apply network policies to control traffic between these contexts.

- **Control egress traffic.** Use network policies to restrict outbound traffic from microservices to only approved external services and endpoints.

- **Monitor policy effectiveness.** Use the observability features of the Cilium eBPF data plane to monitor network policy enforcement and identify blocked traffic that might indicate misconfigurations or security problems.

#### RBAC

When multiple teams develop and deploy microservices at the same time, AKS RBAC mechanisms can provide granular control and filtering of user actions. You can either use Kubernetes RBAC or Azure RBAC with Microsoft Entra ID to control access to the cluster resources. For more information, see [Access and identity options for AKS](/azure/aks/concepts-identity#azure-role-based-access-control).

#### Authentication and authorization

Microservices can require the consuming services or users to authenticate and authorize access to the microservice by using certificates, credentials, and RBAC mechanisms. You can use Microsoft Entra ID to implement [OAuth 2.0 tokens for authorization](/entra/architecture/auth-oauth2). Service meshes like the [Istio service mesh](/azure/aks/istio-about) also provide authorization and authentication mechanisms for microservices, which include OAuth token validation and token-based routing.

#### Secrets management and application credentials

Applications and services often need credentials that let them connect to external services like Azure Storage or SQL Database. The challenge is to keep these credentials safe and prevent leaks.

For Azure resources, use managed identities when possible. A managed identity is like a unique ID for an application or service that's stored in Microsoft Entra ID. It uses this identity to authenticate with an Azure service. The application or service has a service principal created for it in Microsoft Entra ID and authenticates by using OAuth 2.0 tokens. The code that runs within the process can transparently get the token. This approach helps ensure that you don't need to store any passwords or connection strings. To use managed identities, you can assign Microsoft Entra identities to individual pods in AKS by using [Microsoft Entra Workload ID](/azure/aks/workload-identity-overview).

Even when you use managed identities, you might still need to store some credentials or other application secrets. This storage is necessary for Azure services that don't support managed identities, non-Microsoft services, or API keys. You can use the following options to help store secrets more securely:

- **Key Vault:** In AKS, you can mount one or more secrets from Key Vault as a volume. The volume reads the secrets from Key Vault. The pod can then read the secrets like a regular volume. For more information, see [Use the Key Vault provider for Secrets Store CSI Driver in an AKS cluster](/azure/aks/csi-secrets-store-driver). The pod authenticates itself by using either a workload identity or a user-assigned or system-assigned managed identity. For more information, see [Connect your Azure identity provider to the Key Vault Secrets Store CSI Driver in AKS](/azure/aks/csi-secrets-store-identity-access).

- **HashiCorp Vault:** Microsoft Entra managed identities let Kubernetes applications authenticate with HashiCorp Vault. You can [deploy the vault to Kubernetes](https://developer.hashicorp.com/vault/tutorials/kubernetes/kubernetes-azure-aks). Consider running it in a separate dedicated cluster from your application cluster.

- **Kubernetes secrets:** Another option is to use Kubernetes secrets. This option is the easiest to configure but the least secure. Secrets are stored in *etcd*, which is a distributed key-value store. AKS [encrypts etcd at rest](https://github.com/Azure/kubernetes-kms#azure-kubernetes-service-aks). Microsoft manages the encryption keys.

Use a solution like Key Vault to get the following advantages:

- Centralized control of secrets
- Encryption of secrets at rest
- Centralized key management
- Access control of secrets
- Key life cycle management
- Auditing

This architecture uses a managed identity for microservices to authenticate to Key Vault and access secrets.

#### Container and orchestrator security

The following recommended practices can help secure your pods and containers:

- **Monitor for threats.** Monitor for threats by using [Microsoft Defender for Containers](/azure/defender-for-cloud/defender-for-containers-introduction) or a non-Microsoft capability. If you host containers on a virtual machine (VM), use [Microsoft Defender for Servers](/azure/security-center/defender-for-servers-introduction) or a non-Microsoft capability. You can also integrate logs from the [Container Monitoring solution in Azure Monitor](/azure/azure-monitor/insights/containers) to [Microsoft Sentinel](/azure/sentinel/) or an existing security information and event management (SIEM) solution.

- **Monitor vulnerabilities.** Continuously monitor images and running containers for known vulnerabilities by using [Microsoft Defender for Cloud](/azure/security-center/container-security) or a non-Microsoft solution.

- **Automate image patching.** Use [Container Registry tasks](/azure/container-registry/container-registry-tasks-overview) to automate image patching. A container image is built up from layers. The base layers include the OS image and application framework images, like ASP.NET Core or Node.js. The base images are typically created upstream from the application developers, and other project maintainers maintain them. When these images are patched upstream, you must update, test, and redeploy your own images so that you don't leave any known security vulnerabilities. Container Registry tasks can help automate this process.

- **Store images in a trusted private registry.** Use a trusted private registry like Container Registry or Docker Trusted Registry to store images. Use a validating admission webhook in Kubernetes to help ensure that pods can only retrieve images from the trusted registry.

- **Apply the principle of least privilege.** Don't run containers in privileged mode. Privileged mode gives a container access to all devices on the host. When possible, avoid running processes as root inside containers. Containers don't provide total isolation from a security standpoint, so it's better to run a container process as a non-privileged user.

### Deployment CI/CD considerations

Consider the following goals of a robust CI/CD process for a microservices architecture:

- Each team can build and deploy the services that it owns independently, without affecting or disrupting other teams.

- Before a new version of a service is deployed to production, it's deployed to development, test, and Q&A environments for validation. Quality gates are enforced at each stage.

- A new version of a service can be deployed side by side with the previous version.

- Sufficient access control policies are in place.

- For containerized workloads, you can trust the container images that are deployed to production.

For more information about the challenges, see [CI/CD for microservices architectures](../../../microservices/ci-cd.yml).

Using a service mesh like Istio can help with CI/CD processes, like canary deployments, A/B testing of microservices, and staged rollouts with percentage-based traffic splits.

For more information about specific recommendations and best practices, see [Build a CI/CD pipeline for microservices on Kubernetes with Azure DevOps and Helm](../../../microservices/ci-cd-kubernetes.yml).

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

Use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate costs.

Consider the following points for some of the services used in this architecture.

#### AKS

- In the [Free tier](/azure/aks/free-standard-pricing-tiers), there are no costs associated for AKS in deployment, management, and operations of the Kubernetes cluster. You only pay for the VM instances, storage, and networking resources that your Kubernetes cluster consumes.

- Consider using [the Horizontal Pod Autoscaler (HPA)](/azure/aks/concepts-scale#horizontal-pod-autoscaler) to automatically scale microservices in or scale them out depending on load.

- Configure [the Cluster Austoscaler (CA)](/azure/aks/concepts-scale#cluster-autoscaler) to scale the nodes in or scale them out depending on load.

- Consider using [spot nodes](/azure/aks/spot-node-pool) to host noncritical microservices.

- Review the [cost optimization best practices for AKS](/azure/aks/best-practices-cost).

- To estimate the cost of the required resources, use the [AKS calculator](https://azure.microsoft.com/pricing/calculator/?service=kubernetes-service).

#### Azure Load Balancer

You're charged only for the number of configured load-balancing and outbound rules. Inbound network address translation rules are free. There's no hourly charge for the Standard Load Balancer when no rules are configured. For more information, see [Azure Load Balancer pricing](https://azure.microsoft.com/pricing/details/load-balancer).

#### Azure Pipelines

This reference architecture uses Azure Pipelines for CI/CD tasks. Azure provides the pipeline as an individual service. You're allowed a free Microsoft-hosted job with 1,800 minutes for each month for CI/CD and one self-hosted job with unlimited minutes for each month. Extra jobs incur more costs. For more information, see [Azure DevOps services pricing](https://azure.microsoft.com/pricing/details/devops/azure-devops-services).

#### Azure Monitor

For Log Analytics, you're charged for data ingestion and retention. For more information, see [Azure Monitor pricing](https://azure.microsoft.com/pricing/details/monitor).

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

This reference architecture includes [Bicep files](/azure/azure-resource-manager/bicep/overview) for provisioning cloud resources and their dependencies. You can use [Azure Pipelines](/azure/devops/user-guide/what-is-azure-devops#azure-pipelines) to deploy these Bicep files and quickly set up different environments, like replicating production scenarios. This approach helps you save costs by provisioning load testing environments only when needed.

Consider following the workload isolation criteria to structure your Bicep file. A workload is typically defined as an arbitrary unit of functionality. For example, you can have a separate Bicep file for the cluster and then another file for the dependent services. You can use Azure DevOps to perform CI/CD with workload isolation because each workload is associated and managed by its own team.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Francis Simy Nazareth](https://www.linkedin.com/in/francis-simy-nazereth-971440a/) | Senior Technical Specialist

Other contributors:

- [Alessandro Vozza](https://www.linkedin.com/in/alessandrovozza) | Senior Technical Specialist

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Use a service principal with AKS](/azure/aks/kubernetes-service-principal)
- [Container protection in Defender for Cloud](/azure/defender-for-cloud/defender-for-containers-introduction)
- [Plan Defender for Servers deployment](/azure/security-center/defender-for-servers-introduction)
- [Container Monitoring solution in Azure Monitor](/azure/azure-monitor/insights/containers)
- [Microsoft Sentinel](/azure/sentinel/)
- [Defender for Cloud](/azure/security-center/container-security)
- [Automate container image builds and maintenance by using Container Registry tasks](/azure/container-registry/container-registry-tasks-overview)

## Related resources

- [Advanced AKS microservices architecture](./aks-microservices-advanced.yml).
- [CI/CD for microservices architectures](../../../microservices/ci-cd.yml)
- [CI/CD for microservices on Kubernetes](../../../microservices/ci-cd-kubernetes.yml)
