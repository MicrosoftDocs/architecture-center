This reference architecture describes several configurations to consider when you run microservices on Azure Kubernetes Service (AKS). This article discusses network policy configuration, pod autoscaling, and distributed tracing across a microservice-based application.

This architecture builds on the [AKS baseline architecture](/azure/architecture/reference-architectures/containers/aks/baseline-aks), which Microsoft recommends as the starting point for AKS infrastructure. The AKS baseline describes infrastructural features like Microsoft Entra Workload ID, ingress and egress restrictions, resource limits, and other secure AKS infrastructure configurations. These features aren't covered in this article. We recommend that you become familiar with the AKS baseline architecture before you proceed with the microservices content.

![GitHub logo](../../../_images/github.png) A reference implementation of this architecture is available on [GitHub](https://github.com/mspnp/aks-fabrikam-dronedelivery).

## Architecture

:::image type="complex" border="false" source="images/aks-microservices-advanced-production-deployment.svg" alt-text="Network diagram that shows a hub-spoke network that has two peered virtual networks and the Azure resources that this implementation uses." lightbox="images/aks-microservices-advanced-production-deployment.svg":::
   The diagram contains two main sections, spoke and hub, that are connected by an arrow labeled peering. Requests pass from the public internet into a box labeled subnet that contains Azure Application Gateway with a web application firewall (WAF) in the spoke network. Another box labeled subnet in the spoke network section contains a user node pool and a system node pool inside of a smaller box that represents AKS. A dotted line passes from the Application Gateway with WAF subnet, through an ingress, and to an ingestion flow and a scheduler microservice. Dotted lines and arrows connect ingestion workflows with the scheduler, package, and delivery microservices. A dotted arrow points from the workflow to the Azure Firewall subnet in the hub network section. In the system node pool box, and arrow points from the Secrets Store CSI Driver to an Azure Key Vault icon located outside of the spoke network. An icon that represents Azure Container Registry also connects to the AKS subnet. Arrows point from icons that represent a node-managed identity, Flux, and Kubelet to the Azure Firewall subnet in the hub network. A dotted line connects Azure Firewall to services, including Azure Cosmos DB, API for Mongo DB, Azure Service Bus, Azure Cache for Redis, Azure Monitor, and Azure Cloud Services, and FQDNs. These services and FQDNs are outside of the hub network. The hub network also contains a box that represents a subnet that contains Azure Bastion.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/aks-microservices-advanced-production-deployment.vsdx) of this architecture.*

If you prefer to start with a more basic microservices example on AKS, see [Microservices architecture on AKS](./aks-microservices.yml).

### Workflow

This request flow implements the [Publisher-Subscriber](/azure/architecture/patterns/publisher-subscriber), [Competing Consumers](/azure/architecture/patterns/competing-consumers), and [Gateway Routing](/azure/architecture/patterns/gateway-routing) cloud design patterns. The following workflow corresponds to the previous diagram:

1. An HTTPS request is submitted to schedule a drone pickup. The request passes through Azure Application Gateway into the ingestion web application, which runs as an in-cluster microservice in AKS.

1. The ingestion web application produces a message and sends it to the Azure Service Bus message queue.

1. The back-end system assigns a drone and notifies the user. The workflow microservice:

   - Consumes message information from the Service Bus message queue.
   - Sends an HTTPS request to the delivery microservice, which passes data to Azure Cache for Redis external data storage.
   - Sends an HTTPS request to the drone scheduler microservice.
   - Sends an HTTPS request to the package microservice, which passes data to MongoDB external data storage.

1. The architecture uses an HTTPS GET request to return delivery status. This request passes through Application Gateway into the delivery microservice.

1. The delivery microservice reads data from Azure Cache for Redis.

### Components

This architecture uses the following Azure components:

- **[AKS](/azure/well-architected/service-guides/azure-kubernetes-service)** provides a managed Kubernetes cluster. When you use AKS, Azure manages the Kubernetes API server. The cluster operator can access and manage the Kubernetes nodes or node pools.

   This architecture uses the following AKS infrastructure features:

   - [System and user node pool separation](/azure/aks/use-system-pools#system-and-user-node-pools)
   - [AKS-managed Microsoft Entra ID for role-based access control (RBAC)](/azure/aks/enable-authentication-microsoft-entra-id)
   - [Workload ID](/azure/aks/workload-identity-overview)
   - [Azure Policy add-on for AKS](/azure/aks/use-azure-policy)
   - [Azure Container Networking Interface (CNI)](/azure/aks/configure-azure-cni)
   - [Azure Monitor container insights](/azure/azure-monitor/containers/container-insights-overview)
   - [Managed NGINX ingress with the application routing add-on](/azure/aks/app-routing)

- **[Azure virtual networks](/azure/well-architected/service-guides/virtual-network)** are isolated and highly secure environments for running virtual machines (VMs) and applications. This reference architecture uses a peered hub-spoke virtual network topology. The hub virtual network holds the Azure Firewall and Azure Bastion subnets. The spoke virtual network holds the AKS system and user node pool subnets and the Application Gateway subnet.

- **[Azure Private Link](/azure/private-link/private-link-overview)** allocates specific private IP addresses to access Azure Container Registry and Azure Key Vault through the Microsoft backbone network. Platform as a service solutions like Container Registry and Key Vault are accessed over a private endpoint from the AKS system and user node pool subnet.

- **[Application Gateway](/azure/well-architected/service-guides/azure-application-gateway)** with web application firewall (WAF) load balances web traffic to the web application. In this reference architecture, Application Gateway exposes the ingestion microservice as a public endpoint.

- **[Azure Firewall](/azure/well-architected/service-guides/azure-firewall)** is a cloud-native, intelligent network firewall security service that provides threat protection for your Azure cloud workloads. The firewall allows only approved services and fully qualified domain names (FQDNs) as egress traffic. In this architecture, Azure Firewall controls outbound communications from microservices to resources outside of the virtual network.

**External storage and other components:**

- **[Key Vault](/azure/key-vault/general/overview)** stores and manages security keys for Azure services. Secret values, certificates, and keys can be stored and securely managed using Key Vault. In this scenario, credentials for Azure Cosmos DB and Azure Cache for Redis are stored in Azure key vaults.

- **[Container Registry](/azure/container-registry/container-registry-intro)** stores private container images that can be run in the AKS cluster. AKS authenticates with Container Registry using its Microsoft Entra managed identity. You can also use other container registries like Docker Hub. In this scenario, the container images for microservices are stored here.

- **[Azure Cosmos DB](/azure/well-architected/service-guides/cosmos-db)** is a fully managed NoSQL, relational, and vector database. Microservices are typically stateless and write their state to external data stores. Azure Cosmos DB is a NoSQL database with open-source APIs for MongoDB, PostgreSQL and Cassandra. This architecture uses Azure Cosmos DB and [Azure Cosmos DB for MongoDB](/azure/cosmos-db/mongodb/introduction) as data stores for each microservice.

- **[Service Bus](/azure/well-architected/service-guides/service-bus/reliability)** offers reliable cloud messaging as a service and simple hybrid integration. Service Bus supports asynchronous messaging patterns that are common with microservices applications. In this scenario, Service Bus is used as the asynchronous queueing layer between the ingestion and workflow microservices.

- **[Azure Cache for Redis](/azure/well-architected/service-guides/azure-cache-redis/reliability)** adds a caching layer to the application architecture to improve speed and performance for heavy traffic loads. In this architecture, Azure Cache for Redis is used as the state store and [side-cache](/azure/architecture/patterns/cache-aside) by the delivery microservice.

- **[Azure Monitor](/azure/azure-monitor/containers/kubernetes-monitoring-enable)** collects and stores metrics and logs, including application telemetry and Azure platform and service metrics. You can use this data to monitor the application, set up alerts and dashboards, and perform root cause analysis of failures.

**Other operations support system (OSS) components:**

- **[Helm](https://helm.sh/)**, a package manager for Kubernetes that bundles Kubernetes objects into a single unit that you can publish, deploy, version, and update. In this scenario, microservices are packaged deployed to the AKS cluster using helm commands. 

- **[Key Vault Secret Store CSI provider](/azure/aks/csi-secrets-store-driver)** The Key Vault provider for Secrets Store CSI Driver allows for the integration of a key vault as a secret store with an AKS cluster via a [CSI volume](https://kubernetes-csi.github.io/docs/). In this architecture, the key vault secrets are mounted as a volume in microservice containers, so that credentials for CosmosDB, Azure Cache for Redis, Service Bus etc. can be retrieved by the respective microservices.

- **[Flux](/azure/azure-arc/kubernetes/conceptual-gitops-flux2)**, an open and extensible continuous delivery solution for Kubernetes, enabling [GitOps in AKS](/azure/architecture/example-scenario/gitops-aks/gitops-blueprint-aks).

### Alternatives

Instead of using Application routing add-on, you can use alternatives like [Application gateway for containers](/azure/application-gateway/for-containers/overview), and [Istio gateway add-on](/azure/aks/istio-deploy-ingress). For a comparison of ingress options in AKS, please see [Ingress in AKS](/azure/aks/concepts-network-ingress). Application Gateway for containers is an evolution of Application Gateway ingress controller and provides additional features such as traffic splitting and weighted round-robin load balancing. 

Instead of Flux v2, ArgoCD can be used the GitOps tool. Both [Flux v2](/azure/azure-arc/kubernetes/tutorial-use-gitops-flux2) and [ArgoCD](/azure/azure-arc/kubernetes/tutorial-use-gitops-argocd) are available as cluster extensions.

Instead of storing credentials for Azure Cosmos DB and Azure Cache for Redis in key vaults, it is recommended to connect using Managed identities as password-free authentication mechanisms are more secure. Please find and example of connecting to Cosmos DB using managed identity [here](/entra/identity/managed-identities-azure-resources/tutorial-vm-managed-identities-cosmos), and an example for connecting to Service Bus using managed identity [here](/azure/service-bus-messaging/service-bus-managed-service-identity). Azure Cache for Redis also supports [authentication using managed identity](/azure/azure-cache-for-redis/cache-azure-active-directory-for-authentication). 

## Scenario details

The example [Fabrikam Drone Delivery Shipping App](https://github.com/mspnp/aks-fabrikam-dronedelivery) shown in the preceding diagram implements the architectural components and practices discussed in this article. In this example, Fabrikam, Inc., a fictitious company, manages a fleet of drone aircraft. Businesses register with the service, and users can request a drone to pick up goods for delivery. When a customer schedules a pickup, the backend system assigns a drone and notifies the user with an estimated delivery time. While the delivery is in progress, the customer can track the drone's location with a continuously updated ETA.

## Recommendations

Implement these recommendations when deploying advanced AKS microservices architectures.

### Managed NGINX ingress with application routing add-on

API [Gateway Routing](../../../patterns/gateway-routing.yml) is a general [microservices design pattern](/azure/architecture/microservices/design/gateway). An API gateway acts as a reverse proxy that routes requests from clients to microservices. The Kubernetes *ingress* resource and the *ingress controller* handle most API gateway functionality by:

- Routing client requests to the correct backend services provides a single endpoint for clients and help decouple clients from services.
- Aggregating multiple requests into a single request to reduce chatter between the client and the backend.
- Offloading functionality like SSL termination, authentication, IP restrictions, and client rate-limiting or throttling from the backend services.

Ingress controllers simplify traffic ingestion into AKS clusters, improve safety and performance, and save resources. This architecture uses the [managed NGINX ingress with the application routing add-on](/azure/aks/app-routing) for ingress control. 

It is recommended to use the [ingress controller with internal (private) IP address](/azure/aks/create-nginx-ingress-private-controller) and internal load balancer, and integrate to Azure private DNS zones for host name resolution of microservices. The private IP address (or host name) of ingress controller will be configured as the backend pool address in Application Gateway. Application Gateway receives traffic on the public endpoint, performs WAF inspections, and routes the traffic to ingress private IP address. 

The ingress controller should be configured with a [custom domain name and SSL certificate](/azure/aks/app-routing-dns-ssl), so that the traffic is end-to-end encrypted. Application Gateway receives traffic on the HTTPS listener, and after WAF inspections, routes traffic to the HTTPS endpoint of ingress controller. All microservices should be configured with custom domain names and SSL certificates, so that inter-microservice communication within the AKS cluster is also secured using SSL. 

Multitenant workloads, or a single cluster that supports development and testing environments, could require more ingress controllers. Application routing add-on supports advanced configurations and customizations including [multiple ingress controllers within the same AKS cluster](/azure/aks/app-routing-nginx-configuration), and configuring ingress resources using annotations. 

### Zero-trust network policies

Network policies specify how AKS pods are allowed to communicate with each other and with other network endpoints. By default, all ingress and egress traffic is allowed to and from pods. When designing how your microservices communicate with each other and with other endpoints, consider following a *zero trust principle* where access to any service, device, application, or data repository requires explicit configuration.

One strategy in implementing a zero-trust policy is to create a network policy that denies all ingress and egress traffic to all pods within the target namespace. The following example shows a 'deny all policy' that would apply to all pods located in the backend-dev namespace.

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-all
  namespace: backend-dev
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  - Egress
```

Once a restrictive policy is in place, begin to define specific network rules to allow traffic into and out of each pod in the microservice. In the following example, the network policy is applied to any pod in the backend-dev namespace with a label that matches `app.kubernetes.io/component: backend`. The policy denies any traffic unless sourced from a pod with a label that matches `app.kubernetes.io/part-of: dronedelivery`.

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: package-v010-dev-np-allow-ingress-traffic
  namespace: backend-dev
spec:
  podSelector:
    matchLabels:
      app.kubernetes.io/component: backend
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app.kubernetes.io/part-of: dronedelivery
    ports:
    - port: 80
      protocol: TCP
```

For more information on Kubernetes network policies and additional examples of potential default policies, see [Network Policies in the Kubernetes documentation](https://kubernetes.io/docs/concepts/services-networking/network-policies).

Azure provides three Network Policy engines for [enforcing network policies](/azure/aks/use-network-policies):

- [Cilium for AKS clusters](/azure/aks/azure-cni-powered-by-cilium) that use Azure CNI Powered by Cilium
- Azure Network Policy Manager.
- Calico, an open-source network and network security solution 

[Cilium](/azure/aks/azure-cni-powered-by-cilium) is the recommended Network Policy engine.

### Resource quotas

Resource quotas are a way for administrators to reserve and limit resources across a development team or project. You can set resource quotas on a namespace and use them to set limits on:

- Compute resources, such as CPU and memory, or GPUs.
- Storage resources, including the number of volumes or amount of disk space for a given storage class.
- Object count, such as the maximum number of secrets, services, or jobs that can be created.

Once the cumulative total of resource requests or limits passes the assigned quota, no further deployments are successful.

Resource quotas ensure that the total set of pods assigned to the namespace can't exceed the resource quota of the namespace. The front end can't starve the backend services for resources or vice-versa.

When you define resource quotas, all pods created in the namespace must provide limits or requests in their pod specifications. If they don't provide these values, the deployment is rejected.

The following example shows a pod spec that sets resource quota requests and limits:

```yml
requests:
  cpu: 100m
  memory: 350Mi
limits:
  cpu: 200m
  memory: 500Mi
```

For more information about resource quotas, see:
- [Enforce resource quotas](/azure/aks/operator-best-practices-scheduler#enforce-resource-quotas)
- [Resource quotas](https://kubernetes.io/docs/concepts/policy/resource-quotas/)

### Autoscaling

Kubernetes supports *autoscaling* to increase the number of pods allocated to a deployment or increase the nodes in the cluster to increase the total compute resources available. Autoscaling is a self-correcting autonomous feedback system. Although you can scale pods and nodes manually, autoscaling minimizes the chances of services becoming resource-starved at high loads. An autoscaling strategy must take both pods and nodes into account.

#### Cluster autoscaling

The *cluster autoscaler (CA)* scales the number of nodes. Suppose pods can't be scheduled because of resource constraints; the cluster autoscaler provisions more nodes. You define a minimum number of nodes to keep the AKS cluster and your workloads operational and a maximum number of nodes for heavy traffic. The CA checks every few seconds for pending pods or empty nodes and scales the AKS cluster appropriately.

The following example shows the CA configuration from the Bicep template:

```bicep
autoScalerProfile: {
  'scan-interval': '10s'
  'scale-down-delay-after-add': '10m'
  'scale-down-delay-after-delete': '20s'
  'scale-down-delay-after-failure': '3m'
  'scale-down-unneeded-time': '10m'
  'scale-down-unready-time': '20m'
  'scale-down-utilization-threshold': '0.5'
  'max-graceful-termination-sec': '600'
  'balance-similar-node-groups': 'false'
  expander: 'random'
  'skip-nodes-with-local-storage': 'true'
  'skip-nodes-with-system-pods': 'true'
  'max-empty-bulk-delete': '10'
  'max-total-unready-percentage': '45'
  'ok-total-unready-count': '3'
}
```
The following lines in the Bicep template set example minimum and maximum nodes for the cluster autoscaler:

```bicep
minCount: 2
maxCount: 5
```

#### Horizontal pod autoscaling

The *Horizontal Pod Autoscaler (HPA)* scales pods based on observed CPU, memory, or custom metrics. To configure horizontal pod scaling, you specify target metrics and the minimum and the maximum number of replicas in the Kubernetes deployment pod spec. Load test your services to determine these numbers.

CA and HPA work well together, so enable both autoscaler options in your AKS cluster. HPA scales the application, while CA scales the infrastructure.

The following example sets resource metrics for HPA:

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: delivery-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: delivery
  minReplicas: 2
  maxReplicas: 5
  metrics:
  - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 70
```

HPA looks at actual resources consumed or other metrics from running pods, but the CA provisions nodes for pods that aren't scheduled yet. Therefore, CA looks at the requested resources, as specified in the pod spec. Use load testing to fine-tune these values.

Please refer to [scaling options for applications in AKS](/azure/aks/concepts-scale) for more information on autoscaling options in AKS.

#### Vertical pod autoscaling

The [Vertical Pod Autoscaler (VPA)](/azure/aks/use-vertical-pod-autoscaler) automatically adjusts the CPU and memory requests for your pods to match the usage patterns of your workloads. When configured, the VPA automatically sets resource requests and limits on containers per workload based on past usage. The VPA frees up CPU and Memory for other pods and helps ensure effective utilization of your AKS clusters.

In this architecture, VPA is used to increase the CPU and memory requests and limits for microservices based on their past usage. For example, if the workflow microservice consumes more CPU compared to other microservices, the VPA can monitor this usage and increase the CPU limits for the workflow microservice.

#### Kubernetes Event Driven Autoscaler (KEDA)

The [Kubernetes Event Driven Autoscaler (KEDA)](/azure/aks/keda-about) add-on enablesevent-driven autoscaling to scale your microservice to meet demand in a sustainable and cost-efficient manner. For example, KEDA autoscaler can scale up microservices when the number of messages in the service bus queue increases above certain thresholds.

In the Fabricam drone delivery example, the KEDA autoscaler scales out the workflow microservice depending on the queue depth on service bus queue, based on the ingestion microservice output. For the list of KEDA scalers for Azure services, see [Integrations with KEDA on AKS](/azure/aks/keda-integrations).

### Health probes

Kubernetes load balances traffic to pods that match a label selector for a service. Only pods that started successfully and are healthy receive traffic. If a container crashes, Kubernetes removes the pod and schedules a replacement.

Kubernetes defines three types of health probes that a pod can expose:

- Readiness probe: Tells Kubernetes whether the pod is ready to accept requests.

- Liveness probe: Tells Kubernetes whether a pod should be removed and a new instance started.

- Startup probe: Tells Kubernetes whether the pod is started.

The liveness probes handle pods that are still running but are unhealthy and should be recycled. For example, if a container serving HTTP requests hangs, the container doesn't crash, but it stops serving requests. The HTTP liveness probe stops responding, which informs Kubernetes to restart the pod.

Sometimes, a pod might not be ready to receive traffic, even though the pod started successfully. For example, the application running in the container might be performing initialization tasks. The readiness probe indicates whether the pod is ready to receive traffic.

Microservices should expose endpoints in their code that facilitate health probes, with delay and timeout tailored specifically to the checks they perform. The [HPA formula](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/#algorithm-details) keys almost exclusively off the Ready phase on a pod, so it's critical that health probes exist and are accurate.

### Monitoring

In a microservices application, *Application Performance Management (APM)* monitoring is critical for detecting anomalies, diagnosing issues, and quickly understanding the dependencies between services. [Application Insights](/azure/azure-monitor/app/app-insights-overview), which is part of Azure Monitor, provides APM monitoring for live applications written in .NET Core, Node.js, Java, and many other application languages.

Azure provides various mechanisms for monitoring microservice workloads:

- [Managed Prometheus](/azure/azure-monitor/metrics/prometheus-metrics-overview) for metric collection. Use Prometheus to monitor and alert on the performance of infrastructure and workloads.
- Azure Monitor managed service for Prometheus and Container Insights work together for complete monitoring of your Kubernetes environment.
- [Managed Grafana](/azure/managed-grafana/overview) for cluster and microservice visualization.

To contextualize services telemetry with the Kubernetes world, integrate Azure Monitor telemetry with AKS to collect metrics from controllers, nodes, and containers, as well as container and node logs. Application insights can be integrated with AKS [without code changes](/azure/azure-monitor/app/kubernetes-codeless).

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

Consider the following points when planning for security.

- Use [deployment safeguards](/azure/aks/deployment-safeguards) in the AKS cluster. Deployment safeguards enforce Kubernetes best practices in your AKS cluster through Azure Policy controls.

- Integrate security scanning into the microservice build and deployment pipelines. Manage your DevOps environment using [Microsoft Defender for Cloud DevOps security](/azure/defender-for-cloud/defender-for-devops-introduction), and utilize both [agentless code scanning](/azure/defender-for-cloud/agentless-code-scanning) and [run static code analysis tools](/azure/defender-for-cloud/cli-cicd-integration) as part of CI/CD pipelines so that the microservice code vulnerabilities are identified and addressed as part of both the build and deployment processes. 

- An AKS pod authenticates itself by using a *workload identity* stored in Microsoft Entra ID. Using a workload identity is preferable because it doesn't require a client secret.

- With managed identities, the executing process can quickly get Azure Resource Manager OAuth 2.0 tokens; there is no need for passwords or connection strings. In AKS, you can assign identities to individual pods by using [Workload ID](/azure/aks/workload-identity-overview).

- Each service in the microservice application should be assigned a unique workload identity to facilitate least-privileged RBAC assignments. You should only assign identities to services that require them.

- In cases where an application component requires Kubernetes API access, ensure that application pods are configured to use a service account with appropriately scoped API access. For more information on configuring and managing Kubernetes service account, see [Managing Kubernetes Service Accounts](/azure/aks/concepts-identity#kubernetes-service-accounts).

- Not all Azure services support data plane authentication using Microsoft Entra ID. To store credentials or application secrets for those services, for third-party services, or for API keys, use Key Vault. Key Vault provides centralized management, access control, encryption at rest, and auditing of all keys and secrets.

- In AKS, you can mount one or more secrets from Key Vault as a volume. The pod can then read the Key Vault secrets just like a regular volume. For more information, see [secrets-store-csi-driver-provider-azure](/azure/aks/csi-secrets-store-driver). We recommend maintaining separate key vaults for each microservices. The reference implementation uses separate key vaults for each microservice.

- If the microservice needs to communicate to resources outside cluster (such as external URLs), control the access through Azure Firewall. If there are no outbound calls to be made, use [network isolated clusters](/azure/aks/network-isolated).

- Enable [Microsoft defender for containers](/azure/defender-for-cloud/defender-for-containers-introduction) to provide security posture management, vulnerability assessment for microservices, run-time threat protection and other security features. 

### Cost Optimization

Cost Optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

- The [Cost section in the Microsoft Azure Well-Architected Framework](/azure/architecture/framework/cost/overview) describes cost considerations.

- Use the [Azure pricing calculator](https://azure.com/e/149812331b124489ad0ae69e1ad3b118) to estimate costs for your specific scenario. 

- In the free tier, AKS has no costs associated with deployment, management, and operations of the Kubernetes cluster. You only pay for the VM instances, storage, and networking resources the cluster consumes. Cluster autoscaling can significantly reduce the cost of the cluster by removing empty or unused nodes.

- Consider using the free tier of AKS for development workloads, and using the [standard and premium tiers](/azure/aks/free-standard-pricing-tiers) for production workloads. 

- Consider enabling [AKS cost analysis](/azure/aks/cost-analysis) for granular cluster infrastructure cost allocation by Kubernetes specific constructs.

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

Consider the following points when planning for manageability.

- Manage the AKS cluster infrastructure via an automated deployment pipeline. The [reference implementation](https://github.com/mspnp/aks-fabrikam-dronedelivery) for this architecture provides a [GitHub Actions](https://help.github.com/actions) workflow that you can reference when building your pipeline.

- The workflow file deploys the infrastructure only, not the workload, into the already-existing virtual network and Microsoft Entra configuration. Deploying infrastructure and workload separately lets you address distinct lifecycle and operational concerns.

- Consider your workflow as a mechanism to deploy to another region if there is a regional failure. Build the pipeline so that you can deploy a new cluster in a new region with parameter and input alterations.

### Performance Efficiency

Performance Efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

Consider the following points when planning for scalability.

- Don't combine autoscaling and imperative or declarative management of the number of replicas. Users and an autoscaler both attempting to modify the number of replicas may cause unexpected behavior. When HPA is enabled, reduce the number of replicas to the minimum number you want to be deployed.

- A side-effect of pod autoscaling is that pods may be created or evicted frequently, as scale-out and scale-in events happen. To mitigate these effects:

  - Use readiness probes to let Kubernetes know when a new pod is ready to accept traffic.
  - Use pod disruption budgets to limit how many pods can be evicted from a service at a time.

- If there are a large number of outbound flows from the microservice, consider using [NAT gateways](/azure/aks/nat-gateway) to avoid SNAT port exhaustion.
- Multitenant or other advanced workloads might have node pool isolation requirements that demand more and likely smaller subnets. For more information about creating node pools with unique subnets, see [Add a node pool with a unique subnet](/azure/aks/use-multiple-node-pools). Organizations have different standards for their hub-spoke implementations. Be sure to follow your organizational guidelines.

- Consider using [CNI with overlay networking](/azure/aks/concepts-network-cni-overview) to conserve network address space.

## Next steps

- [Introduction to AKS](/azure/aks/intro-kubernetes)
- [What is Azure Virtual Networks?](/azure/virtual-network/virtual-networks-overview)
- [What is Private Link?](/azure/private-link/private-link-overview)
- [What is Application Gateway?](/azure/application-gateway/overview)
- [What is Azure Bastion?](/azure/bastion/bastion-overview)
- [About Key Vault](/azure/key-vault/general/overview)
- [Introduction to Container Registry](/azure/container-registry/container-registry-intro)
- [Welcome to Azure Cosmos DB](/azure/cosmos-db/introduction)
- [Azure Monitor overview](/azure/azure-monitor/overview)

## Related resources

- [Baseline architecture for an AKS cluster](/azure/architecture/reference-architectures/containers/aks/baseline-aks)
- [Design, build, and operate microservices on Azure with Kubernetes](../../../microservices/index.yml)
- [Microservices architecture on AKS](./aks-microservices.yml)
- [Building a CI/CD pipeline for microservices on Kubernetes](../../../microservices/ci-cd-kubernetes.yml)
