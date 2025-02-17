This reference architecture shows a microservices application deployed to Azure Kubernetes Service (AKS). It describes a basic AKS configuration that can be the starting point for most deployments. This article assumes basic knowledge of Kubernetes. The article primarily highlights the infrastructure and DevOps aspects of managing microservices on AKS. For guidance on designing microservices, see [Building microservices on Azure](../../../microservices/index.yml).

![GitHub logo](../../../_images/github.png) A reference implementation of this architecture is available on [GitHub][ri].

## Architecture

:::image type="complex" border="false" source="./images/aks.png" alt-text="Diagram that shows the microservices on AKS reference architecture." lightbox="./images/<file-name-and-extension>":::This diagram shows an application comprised of multiple microservices deployed to Azure Kubernetes services (AKS). 
:::image-end:::

*Download a [Visio file][visio-download] of this architecture.*

If you would prefer to see a more advanced microservices example that is built upon the [AKS Baseline architecture](https://github.com/mspnp/aks-secure-baseline), see [Advanced Azure Kubernetes Service (AKS) microservices architecture](./aks-microservices-advanced.yml)

## Components

The architecture consists of the following components.

**Azure Kubernetes Service (AKS)**. AKS is a managed Kubernetes cluster hosted in the Azure cloud. AKS reduces the complexity and operational overhead of managing Kubernetes by offloading much of that responsibility to Azure. 

**Ingress**. An ingress server exposes HTTP(S) routes to services inside the cluster. The reference implementation uses a [managed Nginx based ingress controller](/azure/aks/app-routing) through an application routing add-on. The ingress controller implements the [API Gateway](#api-gateway) pattern for microservices.

**External data stores**. Microservices are typically stateless and write data & state information to external data stores, such as Azure SQL Database or Azure Cosmos DB. The reference implementation uses [Azure Cosmos DB](/azure/cosmos-db/), [Azure cache for Redis](/azure/azure-cache-for-redis/), [Azure Cosmos DB for MongoDB](/azure/cosmos-db/mongodb/introduction) and [Azure Service Bus](/azure/service-bus-messaging/service-bus-messaging-overview) as data stores. 

**Microsoft Entra ID**. Workloads deployed on an Azure Kubernetes Services (AKS) cluster require Microsoft Entra application credentials or managed identities to access Microsoft Entra protected resources, such as Azure Key Vault and Microsoft Graph. [Microsoft Entra ID](/azure/aks/workload-identity-overview) is also recommended for user authentication in client applications. In the reference architecture, Entra ID managed identities are used by AKS cluster to access other Azure resources such as Azure Container Registry, and is used by microservices to authenticate against Azure Key Vault.

**Azure Container Registry**. Azure Container Registry can be used to store private container images, which are deployed to the cluster. AKS can authenticate with Container Registry using its Microsoft Entra identity. In the reference implementation, microservice container images are built and pushed to Azure Container Registry.  

**Azure Pipelines**. Azure Pipelines are part of the Azure DevOps Services and run automated builds, tests, and deployments. Using a [continuous integration and continuous deployment (CI/CD)](C/azure/architecture/microservices/ci-cd) approach is highly encouraged in microservice environments. Microservices can be independently built and deployed by various teams to AKS using Azure DevOps pipelines. 

**Helm**. Helm is a package manager for Kubernetes that provides a mechanism to bundle and generalize Kubernetes objects into a single unit that can be published, deployed, versioned, and updated. 

**Azure Monitor**. Azure Monitor collects and stores metrics and logs, application telemetry, and platform metrics for the Azure services. Azure Monitor integrates with AKS to collect metrics from controllers, nodes, and containers.

**Azure Application Insights** Azure Application Insights can be used to monitor microservices and containers. It can be used to provide observability to microservices, including traffic flow, end-to-end latency, and error percentage. The health of the microservices and the relationships between them can be displayed on a single application map.  

## Alternatives 

Azure Container Apps can be used as a platform to host microservices in scenarios where fidelity to Kubernetes APIs aren't required. 

Instead of the managed ingress gateway in AKS, you can use Application Gateway for containers, Istio Ingress Gateway, or third party solutions as the ingress controller. Please see [Ingress in AKS](/en-us/azure/aks/concepts-network-ingress) for a comparison of ingress options in AKS. 

Third party container registries such as DockerHub can be used to store container images as well. 

For microservices that need to maintain state information, [DAPR](/azure/aks/dapr-overview) provides a good abstraction layer for microservice state management. 

GitHub actions can be used to build and deploy microservices. You can also third-party CI/CD solutions such as Jenkins. 

Microservice observability can be achieved through alternate tools such as [Kiali](https://kiali.io/) as well. 

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).

### Design

This reference architecture is focused on microservices, although many of the recommended practices apply to other workloads running on AKS.

#### Microservices

A microservice is a loosely coupled, independently deployable unit of code. Microservices typically communicate through well-defined APIs and are discoverable through some form of service discovery. The Kubernetes **Service** object is a natural way to model microservices in Kubernetes. 

#### Data storage

Sharing data storage solutions between microservices is discouraged in microservices architecture. Each service should manage its own data set to avoid hidden dependencies among services. Data separation helps avoid unintentional coupling between services, which can happen when services share the same underlying data schemas. Also, when services manage their own data stores, they can use the right data store for their particular requirements.

For more information, see [Designing microservices: Data considerations](../../../microservices/design/data-considerations.yml).

Microservices in AKS should avoid storing persistent data in local cluster storage because that ties the data to the node. Instead, use an external service such as Azure SQL Database or Azure Cosmos DB. Another option is to mount a persistent data volume to a solution using Azure Disks or Azure Files.

For more information, see [Storage options for application in Azure Kubernetes Service](/azure/aks/concepts-storage).

#### API gateway

API gateways are a general [microservices design pattern](https://microservices.io/patterns/apigateway.html). An *API gateway* sits between external clients and the microservices. API gateway acts as a reverse proxy, routing requests from clients to microservices. An API gateway may also perform various cross-cutting tasks such as authentication, SSL termination, and rate-limiting. For more information, see:

- [Using API gateways in microservices](../../../microservices/design/gateway.yml)
- [Choosing a gateway technology](../../../microservices/design/gateway.yml#choosing-a-gateway-technology)

In Kubernetes, the functionality of an API gateway is primarily handled by an **Ingress controller**. In Kubernetes, the **Ingress controller** can be used to implement the API gateway pattern. In that case, **Ingress** and **Ingress controller** work in conjunction to provide these features:

- Route client requests to the right backend microservices. This routing provides a single endpoint for clients, and helps to decouple clients from services.

- Aggregate multiple requests into a single request, to reduce chattiness between the client and the backend.

- Offload functionality from the backend services, such as SSL termination, authentication, IP restrictions, or client rate limiting (throttling).

There are Ingress controllers for Nginx, HAProxy, Traefik, and Azure Application Gateway, among others. AKS provides multiple managed ingress options. You can choose from [managed Nginx based ingress controller](/azure/aks/app-routing) through application routing add-on, Application Gateway for containers, or Istio Ingress Gateway as the ingress controller. Please see [Ingress in AKS](/en-us/azure/aks/concepts-network-ingress) for a comparison of ingress options. 

Ingress controller operates as the edge router or reverse proxy. A reverse proxy server is a potential bottleneck or single point of failure, so it is recommended to deploy at least two replicas for high availability.

The Ingress controller also has access to the Kubernetes API, so it can make intelligent decisions about routing and load balancing. For example, the Nginx ingress controller bypasses the kube-proxy network proxy.

### Reliability

#### Partitioning microservices

Use namespaces to organize services within the cluster. Every object in a Kubernetes cluster belongs to a namespace. It is a good practice to create namespaces that are more descriptive to help organize the resources in the cluster.

Namespaces help prevent naming collisions. When multiple teams deploy microservices into the same cluster, with possibly hundreds of microservices, it gets hard to manage if they all go into the same namespace. In addition, namespaces allow you to:

- Apply resource constraints to a namespace, so that the total set of pods assigned to that namespace cannot exceed the resource quota of the namespace.

- Apply policies at the namespace level, including RBAC and security policies.

When microservices are developed and deployed by multiple teams, namespaces can be used as a convenient mechanism to control areas to which each team can deploy to. For example, development team A can be given access only to namespace A, and development team B can be given access only to namespace B through kubernetes [role based RBAC policies](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#role-and-clusterrole). 

For a microservices architecture, considering organizing the microservices into bounded contexts, and creating namespaces for each bounded context. For example, all microservices related to the "Order Fulfillment" bounded context could go into the same namespace. Alternatively, create a namespace for each development team.

A good practice is to place utility services into their own separate namespace. For example, you might deploy cluster monitoring tools such as Elasticsearch and Prometheus to a monitoring namespace.

#### Health probes

Kubernetes defines three types of health probes that a pod can expose:

- Readiness probe: Tells Kubernetes whether the pod is ready to accept requests.

- Liveness probe: Tells Kubernetes whether a pod should be removed and a new instance started.
  
- Startup probe: Informs Kubernetes whether the pod is started. 

When thinking about probes, it's useful to recall how a service works in Kubernetes. A service has a label selector that matches a set of (zero or more) pods. Kubernetes load balances traffic to the pods that match the selector. Only pods that started successfully and are healthy receive traffic. If a container crashes, Kubernetes kills the pod and schedules a replacement.

Sometimes, a pod may not be ready to receive traffic, even though the pod started successfully. For example, there may be initialization tasks, where the application running in the container loads things into memory or reads configuration data. To indicate that a pod is healthy but not ready to receive traffic, define a readiness probe.

Liveness probes handle the case where a pod is still running, but is unhealthy and should be recycled. For example, suppose that a container is serving HTTP requests but hangs for some reason. The container doesn't crash, but it has stopped serving any requests. If you define an HTTP liveness probe, the probe will stop responding and that informs Kubernetes to restart the pod.

Here are some considerations when designing probes for microservices:

- If your code has a long startup time, there is a danger that a liveness probe will report failure before the startup completes. To prevent the probe failure, use the `initialDelaySeconds` setting, which delays the probe from starting.

- A liveness probe doesn't help unless restarting the pod is likely to restore it to a healthy state. You can use a liveness probe to mitigate against memory leaks or unexpected deadlocks, but there's no point in restarting a pod that's going to immediately fail again.

- Sometimes readiness probes are used to check dependent services. For example, if a pod has a dependency on a database, the probe might check the database connection. However, this approach can create unexpected problems. An external service might be temporarily unavailable for some reason. That will cause the readiness probe to fail for all the pods in your service, causing all of them to be removed from load balancing, and thus creating cascading failures upstream. A better approach is to implement retry handling within your service, so that your service can recover correctly from transient failures. As an alternative, retry handling, error tolerance, and circuit breakers can be implemented by the [istio service mesh](/azure/aks/istio-about) to create resilient architecture that is tolerant to microservice failures. 

#### Resource constraints

Resource contention can affect the availability of a service. Define [resource constraints for containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/), so that a single container cannot overwhelm the cluster resources (memory and CPU). For non-container resources, such as threads or network connections, consider using the [Bulkhead Pattern](../../../patterns/bulkhead.yml) to isolate resources.

Use [resource quotas](https://kubernetes.io/docs/concepts/policy/resource-quotas/) to limit the total resources allowed for a namespace. That way, the front end can't starve the backend services for resources or vice-versa. Resource quotas can be handy to allocate resources within the same cluster to multiple microservice development teams. 

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

#### TLS/SSL encryption

In common implementations, the Ingress controller is used for SSL termination. So, as part of deploying the Ingress controller, you will need to create or import a TLS certificate. Use of self-signed certificates is recommended only for dev/test purposes. For more information, see 
[Set up a custom domain name and SSL certificate with the application routing add-on](/azure/aks/app-routing-dns-ssl).

For production workloads, get signed certificates from trusted certificate authorities (CA). 

You may also need to rotate your certificates as per the organization's policies. Azure Key Vault can be used to rotate certificates used by microservices. For more information, see [Configure certificate auto-rotation in Key Vault](/azure/key-vault/certificates/tutorial-rotate-certificates).

#### Role-based access control (RBAC)

When multiple teams are working on developing and deploying microservices, AKS role based access control mechanisms can be utilized to control granular filtering of user actions. You can either use Kubernetes RBAC or Azure RBAC with Microsoft Entra ID to control access to the cluster resources. For more information, please see [Access and identity options for Azure Kubernetes Service (AKS)](/azure/aks/concepts-identity#azure-role-based-access-control).

#### Authentication and Authorization

Microservices can demand that the consuming services or users authenticate and authorize access to the microservice, using certificates, credentials, and role based access control mechanisms. Microsoft Entra ID can be used to implement [OAuth 2.0 tokens for authorization](/entra/architecture/auth-oauth2). [Service meshes such as Istio](/azure/aks/istio-about) provides authorization and authentication mechanisms for microservices as well, including OAuth token validation and token based routing. The reference implementation doe snot cover microservice authentication and authorization scenarios.  

#### Secrets management and application credentials

Applications and services often need credentials that allow them to connect to external services such as Azure Storage or SQL Database. The challenge is to keep these credentials safe and not leak them.

For Azure resources, one option is to use managed identities. The idea of a managed identity is that an application or service has an identity stored in Microsoft Entra ID, and uses this identity to authenticate with an Azure service. The application or service has a Service Principal created for it in Microsoft Entra ID, and authenticates using OAuth 2.0 tokens. The executing process code can transparently get the token to use. That way, you don't need to store any passwords or connection strings. You can use managed identities in AKS by assigning Microsoft Entra identities to individual pods, using [Microsoft Entra Workload ID](/azure/aks/workload-identity-overview).

Even with managed identities, you'll probably need to store some credentials or other application secrets, whether for Azure services that don't support managed identities, third-party services, API keys, and so on. Here are some options for storing secrets securely:

- Azure Key Vault. In AKS, you can mount one or more secrets from Key Vault as a volume. The volume reads the secrets from Key Vault. The pod can then read the secrets just like a regular volume. For more information, see the [Use the Azure Key Vault Provider for Secrets Store CSI Driver in an AKS cluster](/azure/aks/csi-secrets-store-driver).

    The pod authenticates itself by using either a workload identity or by using a user or system-assigned managed identity. See [Provide an identity to access the Azure Key Vault Provider for Secrets Store CSI Driver](/azure/aks/csi-secrets-store-identity-access) for more considerations.

- HashiCorp Vault. Kubernetes applications can authenticate with HashiCorp Vault using Microsoft Entra managed identities. You can deploy [Vault itself to Kubernetes](https://developer.hashicorp.com/vault/tutorials/kubernetes/kubernetes-azure-aks). Consider running it in a separate dedicated cluster from your application cluster.

- Kubernetes secrets. Another option is simply to use Kubernetes secrets. This option is the easiest to configure but is the least secure. Secrets are stored in etcd, which is a distributed key-value store. AKS [encrypts etcd at rest](https://github.com/Azure/kubernetes-kms#azure-kubernetes-service-aks). Microsoft manages the encryption keys.

Using a system such as Azure Key Vault provides several advantages, such as:

- Centralized control of secrets.
- Ensuring that all secrets are encrypted at rest.
- Centralized key management.
- Access control of secrets.
- Key lifecycle management
- Auditing

The reference implementation stores credentials such as Cosmos DB connection string in Azure Key Vault. The reference implementation uses managed identity for microservices, to authenticate to Key vault and access azure key vault secrets.  

#### Container and Orchestrator security

These are recommended practices for securing your pods and containers:

- **Threat monitoring:** Monitor for threats using [Microsoft Defender for Containers](/azure/defender-for-cloud/defender-for-containers-introduction) (or 3rd party capabilities). If you're hosting containers on a VM, use [Microsoft Defender for servers](/azure/security-center/defender-for-servers-introduction) or a 3rd party capability. Additionally, you can integrate logs from [Container Monitoring solution in Azure Monitor](/azure/azure-monitor/insights/containers) to [Microsoft Sentinel](/azure/sentinel/) or an existing SIEM solution.

- **Vulnerability monitoring:** Continuously monitor images and running containers for known vulnerabilities using [Microsoft Defender for Cloud](/azure/security-center/container-security) or a 3rd party solution.

- **Automate image patching** using [ACR Tasks](/azure/container-registry/container-registry-tasks-overview), a feature of Azure Container Registry. A container image is built up from layers. The base layers include the OS image and application framework images, such as ASP.NET Core or Node.js. The base images are typically created upstream from the application developers, and are maintained by other project maintainers. When these images are patched upstream, it's important to update, test, and redeploy your own images, so that you don't leave any known security vulnerabilities. ACR Tasks can help to automate this process.

- **Store images in a trusted private registry** such as Azure Container Registry or Docker Trusted Registry. Use a validating admission webhook in Kubernetes to ensure that pods can only pull images from the trusted registry.

- **Apply Least Privilege** principle
  - Don't run containers in privileged mode. Privileged mode gives a container access to all devices on the host.
  - When possible, avoid running processes as root inside containers. Containers do not provide complete isolation from a security standpoint, so it's better to run a container process as a non-privileged user.

### Deployment (CI/CD) considerations

Here are some goals of a robust CI/CD process for a microservices architecture:

- Each team can build and deploy the services that it owns independently, without affecting or disrupting other teams.
- Before a new version of a service is deployed to production, it gets deployed to dev/test/QA environments for validation. Quality gates are enforced at each stage.
- A new version of a service can be deployed side by side with the previous version.
- Sufficient access control policies are in place.
- For containerized workloads, you can trust the container images that are deployed to production.

To learn more about the challenges, see [CI/CD for microservices architectures](../../../microservices/ci-cd.yml).

Use of [service mesh](/azure/aks/istio-about) can aid in CI/CD processes, such as in canary deployments, A/B testing of microservices, and staged rollouts with percentage-based traffic splits.

For specific recommendations and best practices, see [CI/CD for microservices on Kubernetes](../../../microservices/ci-cd-kubernetes.yml).

### Cost Optimization

Cost Optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

Use the [Azure pricing calculator][azure-pricing-calculator] to estimate costs. Other considerations are described in the Cost section in [Microsoft Azure Well-Architected Framework][aaf-cost].

Here are some points to consider for some of the services used in this architecture.

#### Azure Kubernetes Service (AKS)

[In the free tier](/azure/aks/free-standard-pricing-tiers), there are no costs associated for AKS in deployment, management, and operations of the Kubernetes cluster. You only pay for the virtual machines instances, storage, and networking resources consumed by your Kubernetes cluster.

Consider using [horizontal pod autoscaler](/azure/aks/concepts-scale#horizontal-pod-autoscaler) to automatically scale up or down microservices according to load. 

Configure [cluster autoscaler](/azure/aks/concepts-scale#cluster-autoscaler) to scale up or down the number of nodes according to load. 

Consider using [spot nodes](/azure/aks/spot-node-pool) and burstable nodepool types to host non-critical microservices. 

To estimate the cost of the required resources please see the [Container Services calculator][aks-Calculator].

#### Azure Load balancer

You're charged only for the number of configured load-balancing and outbound rules. Inbound NAT rules are free. There's no hourly charge for the Standard Load Balancer when no rules are configured.

For more information, see [Azure Load Balancer Pricing][az-lb-pricing].

#### Azure Pipelines

This reference architecture only uses Azure Pipelines. Azure offers the Azure Pipeline as an individual Service. You're allowed a free Microsoft-hosted job with 1,800 minutes per month for CI/CD and one self-hosted job with unlimited minutes per month, extra jobs have charges. For more information, [see Azure DevOps Services Pricing](https://azure.microsoft.com/pricing/details/devops/azure-devops-services).

#### Azure Monitor

For Azure Monitor Log Analytics, you're charged for data ingestion and retention. For more information, see [Azure Monitor Pricing][az-monitor-pricing].

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

This reference architecture provides [Bicep templates](/azure/azure-resource-manager/bicep/overview?tabs=bicep) for provisioning the cloud resources, and its dependencies. With the use of bicep templates you can use [Azure DevOps Services](/azure/devops/user-guide/services) to provision different environments in minutes, for example to replicate production scenarios. This allows you to save cost and provision load testing environment only when needed.

Consider following the workload isolation criteria to structure your bicep template, a workload is typically defined as an arbitrary unit of functionality; you could, for example, have a separate template for the cluster and then other for the dependent services. Workload isolation enables DevOps to perform continuous integration and continuous delivery (CI/CD), since every workload is associated and managed by its corresponding DevOps team.

## Deploy this scenario

To deploy the reference implementation for this architecture, follow the steps in the [GitHub repo][ri-deploy].

> [!div class="nextstepaction"]
> [AKS Microservices Reference Implementation](https://github.com/mspnp/microservices-reference-implementation)

## Next steps

- [Service principals with Azure Kubernetes Service](/azure/aks/kubernetes-service-principal)
- [Microsoft Defender for Containers](/azure/defender-for-cloud/defender-for-containers-introduction) 
- [Microsoft Defender for servers](/azure/security-center/defender-for-servers-introduction) 
- [Container Monitoring solution in Azure Monitor](/azure/azure-monitor/insights/containers) 
- [Microsoft Sentinel](/azure/sentinel/) or an existing SIEM solution.
- [Microsoft Defender for Cloud](/azure/security-center/container-security) or a 3rd party solution available through the Azure Marketplace.
- [ACR Tasks](/azure/container-registry/container-registry-tasks-overview)

## Related resources

- To work through a more advanced microservices example, see [Advanced Azure Kubernetes Service (AKS) microservices architecture](./aks-microservices-advanced.yml)
- To learn how we measured the performance of this application, see [Performance tuning scenario: Distributed business transactions](../../../performance/distributed-transaction.yml).
- [CI/CD for microservices architectures](../../../microservices/ci-cd.yml)
- [CI/CD for microservices on Kubernetes](../../../microservices/ci-cd-kubernetes.yml) 

[ri]: https://github.com/mspnp/microservices-reference-implementation
[ri-deploy]: https://github.com/mspnp/microservices-reference-implementation/blob/main/deployment.md
[visio-download]: https://arch-center.azureedge.net/aks-reference-architecture.vsdx
[aaf-cost]: /azure/architecture/framework/cost/overview
[azure-pricing-calculator]: https://azure.microsoft.com/pricing/calculator
[DevOps-pricing]: https://azure.microsoft.com/pricing/details/devops/azure-devops-services
[AppGatewayPricing]: https://azure.microsoft.com/pricing/details/application-gateway
[aks-Calculator]: https://azure.microsoft.com/pricing/calculator/?service=kubernetes-service
[az-lb-pricing]: https://azure.microsoft.com/pricing/details/load-balancer
[az-monitor-pricing]: https://azure.microsoft.com/pricing/details/monitor
