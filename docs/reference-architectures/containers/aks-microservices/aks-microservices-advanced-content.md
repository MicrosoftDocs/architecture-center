This reference architecture describes several configurations to consider when you run microservices on Azure Kubernetes Service (AKS). This article discusses network policy configuration, pod autoscaling, and distributed tracing across a microservice-based application.

This architecture builds on the [AKS baseline architecture](/azure/architecture/reference-architectures/containers/aks/baseline-aks), which serves as a starting point for AKS infrastructure. The AKS baseline describes infrastructural features like Microsoft Entra Workload ID, ingress and egress restrictions, resource limits, and other secure AKS infrastructure configurations. These features aren't covered in this article. We recommend that you familiarize yourself with the AKS baseline architecture before you proceed with the microservices content.

## Architecture

:::image type="complex" border="false" source="images/aks-microservices-advanced-production-deployment.svg" alt-text="Network diagram that shows a hub-spoke network that has two peered virtual networks and the Azure resources that this architecture uses." lightbox="images/aks-microservices-advanced-production-deployment.svg":::
  An arrow labeled peering connects the two main sections of the diagram: spoke and hub. Requests pass from the public internet into a box labeled subnet that contains Azure Application Gateway with a web application firewall (WAF) in the spoke network. Another box labeled subnet in the spoke network section contains a user node pool and a system node pool inside of a smaller box that represents AKS. A dotted line passes from the Application Gateway with WAF subnet, through an ingress, and to an ingestion flow and a scheduler microservice. Dotted lines and arrows connect ingestion workflows with the scheduler, package, and delivery microservices. A dotted arrow points from the workflow to the Azure Firewall subnet in the hub network section. In the system node pool box, an arrow points from the Secrets Store CSI Driver to an Azure Key Vault icon located outside of the spoke network. Advanced Container Networking Services fetches node-level and pod-level data and ingests it to Azure Monitor for end-to-end visibility. A Cilium icon represents the Azure CNI powered by Cilium plug-in that manages networking in Kubernetes clusters. An icon that represents Azure Container Registry also connects to the AKS subnet. Arrows point from icons that represent a node-managed identity, Flux, and Kubelet to the Azure Firewall subnet in the hub network. A dotted line connects Azure Firewall to services, including Azure Cosmos DB, Azure DocumentDB, Azure Service Bus, Azure Managed Redis, Azure Monitor, Azure Cloud Services, and fully qualified domain names (FQDNs). These services and FQDNs are outside the hub network. The hub network also contains a box that represents a subnet that contains Azure Bastion.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/aks-microservices-advanced-production-deployment.vsdx) of this architecture.*

If you prefer to start with a more basic microservices example on AKS, see [Microservices architecture on AKS](./aks-microservices.yml).

### Workflow

This request flow implements the [Publisher-Subscriber](/azure/architecture/patterns/publisher-subscriber), [Competing Consumers](/azure/architecture/patterns/competing-consumers), and [Gateway Routing](/azure/architecture/patterns/gateway-routing) cloud design patterns.

The following workflow corresponds to the previous diagram:

1. An HTTPS request is submitted to schedule a drone pickup. The request passes through Azure Application Gateway into the ingestion web application, which runs as an in-cluster microservice in AKS.

1. The ingestion web application produces a message and sends it to the Azure Service Bus message queue.

1. The back-end system assigns a drone and notifies the user. The workflow microservice does the following tasks:

   - Consumes message information from the Service Bus message queue.

   - Sends an HTTPS request to the delivery microservice, which passes data to Azure Managed Redis external data storage.

   - Sends an HTTPS request to the drone scheduler microservice.

   - Sends an HTTPS request to the package microservice, which passes data to Azure DocumentDB external data storage.

   - Advanced Container Networking Services policies (Cilium NetworkPolicy) govern service-to-service traffic inside the cluster, and the data plane transparently enforces optional inter-node pod encryption (WireGuard). Advanced Container Networking Services isn't enabled by default. It fetches node-level and pod-level data and ingests it into Azure Monitor for end-to-end visibility.

1. The architecture uses an HTTPS GET request to return delivery status. This request passes through Application Gateway into the delivery microservice.

1. The delivery microservice reads data from Azure Managed Redis.

### Components
  
- [AKS](/azure/well-architected/service-guides/azure-kubernetes-service) is a managed Kubernetes platform that delivers managed clusters for deploying and scaling containerized applications. When you use AKS, Azure manages the Kubernetes API server. The cluster operator can access and manage the Kubernetes nodes or node pools. This architecture uses the following AKS infrastructure features:

  - [AKS-managed Microsoft Entra ID for Azure role-based access control (Azure RBAC)](/azure/aks/enable-authentication-microsoft-entra-id) is a feature that integrates Microsoft Entra ID with AKS to enforce identity-based access control. In this architecture, it ensures secure, centralized authentication and authorization for cluster users and workloads.

  - [Azure CNI powered by Cilium](/azure/aks/azure-cni-powered-by-cilium) is the recommended networking solution to connect directly to an Azure virtual network. In this architecture, it assigns IP addresses from the virtual network to pods while providing built-in network policy capabilities and traffic visibility.

  - [Advanced Container Networking Services](/azure/aks/advanced-container-networking-services-overview) is a suite of managed networking capabilities for AKS that provides network observability and enhanced in-cluster security:

    - Container Network Observability uses Extended Berkeley Packet Filter (eBPF)-based tooling, like Hubble and Retina, to collect Domain Name System (DNS) queries, pod-to-pod and pod-to-service flows, packet drops, and other metrics. It works across Cilium and non-Cilium Linux data planes. It also integrates with Azure Monitor managed service for Prometheus and Azure Managed Grafana for visualization and alerting. In this architecture, Container Network Observability diagnoses policy misconfigurations, DNS latency or errors, and traffic imbalances across microservices.

    - Container Network Security applies to clusters that use Azure CNI powered by Cilium. It enforces Cilium NetworkPolicy resources, including fully qualified domain name (FQDN)-based egress filtering, to implement zero trust network segmentation and reduce operational overhead. In this architecture, in-cluster FQDN policies work with Azure Firewall or Azure NAT Gateway to enforce least-privilege egress while simplifying policy maintenance.

  - [The Azure Policy add-on for AKS](/azure/aks/use-azure-policy) is a built-in extension that brings governance and compliance controls directly into your AKS clusters. It applies governance rules across AKS resources by using Azure Policy. In this architecture, it enforces compliance by validating configurations and restricting unauthorized deployments.

  - [Managed NGINX ingress with the application routing add-on](/azure/aks/app-routing) is a feature in AKS that helps you expose your applications to the internet by using HTTP or HTTPS traffic. It provides a preconfigured NGINX ingress controller for AKS. In this architecture, it handles traffic routing to services and enables exposure of pods to Application Gateway.

  - [System and user node pool separation](/azure/aks/use-system-pools#system-and-user-node-pools) is an architectural practice that divides cluster nodes into two distinct types of node pools and isolates AKS infrastructure components from application workloads. In this architecture, security and resource efficiency are enhanced by dedicating node pools to specific operational roles.

  - [Workload ID](/azure/aks/workload-identity-overview) is a secure and scalable way for Kubernetes workloads to access Azure resources by using Microsoft Entra ID without needing secrets or credentials stored in the cluster. Workload ID enables AKS workloads to securely access Azure resources by using federated identity. In this architecture, it eliminates the need for secrets and improves security posture through identity-based access.

- [Application Gateway](/azure/well-architected/service-guides/azure-application-gateway) is an Azure-managed service that provides layer-7 load balancing and web application firewall (WAF) capabilities. In this architecture, it exposes the ingestion microservice as a public endpoint and balances incoming web traffic to the application.

- [Azure Firewall](/azure/well-architected/service-guides/azure-firewall) is an Azure-managed service that delivers intelligent, cloud-native network security and threat protection. In this architecture, it controls outbound communications from microservices to external resources, which allows only approved FQDNs as egress traffic.

- [Azure Private Link](/azure/private-link/private-link-overview) is an Azure-managed service that enables private connectivity to Azure platform as a service (PaaS) offerings via the Microsoft backbone network. In this architecture, it assigns private IP addresses to access Azure Container Registry and Azure Key Vault from AKS node pools through private endpoints.

- [Azure Virtual Network](/azure/well-architected/service-guides/virtual-network) is an Azure-managed service that provides isolated and secure environments to run applications and virtual machines (VMs). In this architecture, it uses a peered hub-spoke topology. The hub network hosts Azure Firewall and Azure Bastion. The spoke network contains AKS system and user node pool subnets, along with the Application Gateway subnet.

#### External storage and other components

- [Azure Managed Redis](/azure/redis/overview) is an Azure-managed service that provides a high-performance, in-memory data store for caching, session storage, and real-time data access. In this architecture, the delivery microservice uses Azure Managed Redis as the state store and [side cache](/azure/architecture/patterns/cache-aside) to improve speed and responsiveness during heavy traffic.

- [Container Registry](/azure/container-registry/container-registry-intro) is an Azure-managed service that stores private container images for deployment in AKS. In this architecture, it holds the container images for microservices, and AKS authenticates with it by using its Microsoft Entra managed identity. You can also use other registries, like Docker Hub.

- [Azure Cosmos DB](/azure/well-architected/service-guides/cosmos-db) is an Azure-managed, globally distributed NoSQL, relational, and vector database service. In this architecture, Azure Cosmos DB and [Azure DocumentDB](/azure/documentdb/overview) serve as external data stores for each microservice.

- [Key Vault](/azure/key-vault/general/overview) is an Azure-managed service that securely stores and manages secrets, keys, and certificates. In this architecture, Key Vault stores credentials that microservices use to access Azure Cosmos DB and Azure Managed Redis.

- [Azure Monitor](/azure/azure-monitor/fundamentals/overview) is an Azure-managed observability platform that collects metrics, logs, and telemetry across services. In this architecture, it [enables monitoring](/azure/azure-monitor/containers/kubernetes-monitoring-enable) of the application, alerting, dashboarding, and root cause analysis for failures across AKS and integrated services.

  Container Network Observability for Advanced Container Networking Services uses Hubble for flow visibility and Retina for curated network telemetry. These tools integrate with managed observability back ends, like Azure Monitor managed service for Prometheus and Azure Managed Grafana, for troubleshooting and service-level objective (SLO) reporting.

- [Service Bus](/azure/well-architected/service-guides/service-bus/reliability) is an Azure-managed messaging service that supports reliable and asynchronous communication between distributed applications. In this architecture, Service Bus serves as the queueing layer between the ingestion and workflow microservices, which enables decoupled and scalable message exchange.

#### Other operations support system components

- [Flux](/azure/azure-arc/kubernetes/conceptual-gitops-flux2) is an Azure-supported, open-source, and extensible continuous delivery solution for Kubernetes that enables [GitOps in AKS](/azure/architecture/example-scenario/gitops-aks/gitops-blueprint-aks). In this architecture, Flux automates deployments by syncing application manifest files from a Git repository, which ensures consistent and declarative delivery of microservices to the AKS cluster.

- [Helm](https://helm.sh) is a Kubernetes-native package manager that bundles Kubernetes objects into a single unit for publishing, deploying, versioning, and updating. In this architecture, Helm is used to package and deploy microservices to the AKS cluster.

- [Key Vault Secrets Store CSI Driver provider](/azure/aks/csi-secrets-store-driver) is an Azure-integrated driver that enables AKS clusters to mount secrets from Key Vault by using [CSI volumes](https://kubernetes-csi.github.io/docs/). In this architecture, secrets are mounted directly into microservice containers, which allows secure retrieval of credentials for Azure Cosmos DB and Azure Managed Redis.

### Alternatives

Instead of using an application routing add-on, you can use alternatives like [Application Gateway for Containers](/azure/application-gateway/for-containers/overview) and the [Istio gateway add-on](/azure/aks/istio-deploy-ingress). For a comparison of ingress options in AKS, see [Ingress in AKS](/azure/aks/concepts-network-ingress). Application Gateway for Containers is an evolution of the Application Gateway ingress controller and provides extra features like traffic splitting and weighted round-robin load balancing.

You can use ArgoCD as the GitOps tool instead of Flux. Both [Flux](/azure/azure-arc/kubernetes/tutorial-use-gitops-flux2) and [ArgoCD](/azure/azure-arc/kubernetes/tutorial-use-gitops-argocd) are available as cluster extensions.

Instead of storing credentials for Azure Cosmos DB and Azure Managed Redis in key vaults, we recommend that you use managed identities to authenticate because password-free authentication mechanisms are more secure. For more information, see [Use managed identities to connect to Azure Cosmos DB from an Azure VM](/entra/identity/managed-identities-azure-resources/tutorial-vm-managed-identities-cosmos) and [Authenticate a managed identity by using Microsoft Entra ID to access Service Bus resources](/azure/service-bus-messaging/service-bus-managed-service-identity). Azure Managed Redis also supports [authentication by using managed identities](/azure/redis/entra-for-authentication).

## Scenario details
  
In this example, Fabrikam, Inc., a fictitious company, manages a fleet of drone aircraft. Businesses register with the service, and users can request a drone to pick up goods for delivery. When a customer schedules a pickup, the back-end system assigns a drone and notifies the user with an estimated delivery time. The customer can track the drone's location and see a continuously updated estimated time of arrival while the delivery is in progress.

## Recommendations

You can apply the following recommendations to most scenarios. Follow these recommendations unless you have a specific requirement that overrides them.

### Managed NGINX ingress with application routing add-on

API [Gateway Routing](../../../patterns/gateway-routing.yml) is a general [microservices design pattern](/azure/architecture/microservices/design/gateway). An API gateway functions as a reverse proxy that routes requests from clients to microservices. The Kubernetes *ingress* resource and the *ingress controller* handle most API gateway functionality by performing the following actions:

- Routing client requests to the correct back-end services to provide a single endpoint for clients and help decouple clients from services

- Aggregating multiple requests into a single request to reduce chatter between the client and the back end

- Offloading functionality like Secure Sockets Layer (SSL) termination, authentication, IP address restrictions, and client rate-limiting or throttling from the back-end services

Ingress controllers simplify traffic ingestion into AKS clusters, improve safety and performance, and save resources. This architecture uses the [managed NGINX ingress with the application routing add-on](/azure/aks/app-routing) for ingress control.

We recommend that you use the [ingress controller with an internal (private) IP address](/azure/aks/create-nginx-ingress-private-controller) and an internal load balancer and integrate to Azure private DNS zones for host name resolution of microservices. Configure the private IP address or host name of the ingress controller as the back-end pool address in Application Gateway. Application Gateway receives traffic on the public endpoint, performs WAF inspections, and routes the traffic to the ingress private IP address.

Configure the ingress controller with a [custom domain name and SSL certificate](/azure/aks/app-routing-dns-ssl) so that the traffic is end-to-end encrypted. Application Gateway receives traffic on the HTTPS listener. After WAF inspections, Application Gateway routes traffic to the HTTPS endpoint of the ingress controller. Configure all microservices to use custom domain names and SSL certificates, which secures inter-microservice communication within the AKS cluster.

Multitenant workloads or a single cluster that supports development and testing environments might require more ingress controllers. The application routing add-on supports advanced configurations and customizations, including [multiple ingress controllers within the same AKS cluster](/azure/aks/app-routing-nginx-configuration) and using annotations to configure ingress resources.

### Networking and network policy

Use Azure CNI powered by Cilium. The eBPF data plane has suitable routing performance and supports any size cluster. Cilium natively enforces Kubernetes NetworkPolicy and provides rich traffic observability. For more information, see [Configure Azure CNI powered by Cilium in AKS](/azure/aks/azure-cni-powered-by-cilium).

> [!IMPORTANT]
> If you require Windows nodes in your microservices architecture, review Cilium's current **Linux-only** limitation and plan appropriately for mixed OS pools. For more information, see [Azure CNI powered by Cilium limitations](/azure/aks/azure-cni-powered-by-cilium#limitations).

For specific IP address management needs, Azure CNI powered by Cilium supports both virtual network-routed and overlay pod IP models. For more information, see [Azure CNI powered by Cilium](/azure/aks/azure-cni-powered-by-cilium).

### Zero trust network policies

Network policies specify how AKS pods communicate with each other and with other network endpoints. By default, all ingress and egress traffic is allowed to and from pods. When you design how your microservices communicate with each other and with other endpoints, consider following a *zero trust principle*, where access to any service, device, application, or data repository requires explicit configuration. Define and enforce Kubernetes NetworkPolicy (implemented by Advanced Container Networking Services/Cilium) to segment traffic between microservices and restrict egress to only allowed FQDNs.

One strategy to implement a zero trust policy is to create a network policy that denies all ingress and egress traffic to all pods within the target namespace. The following example shows a *deny all* policy that applies to all pods located in the `backend-dev` namespace.

```yaml
apiVersion: cilium.io/v2
kind: CiliumNetworkPolicy
metadata:
  name: deny-all
  namespace: backend-dev
spec:
  endpointSelector: {}  # Applies to all pods in the namespace
  ingress:
  - fromEntities: []
  egress:
  - toEntities: []
```

After a restrictive policy is in place, begin to define specific network rules to allow traffic into and out of each pod in the microservice. In the following example, the Cilium network policy is applied to any pod in the `backend-dev` namespace that has a label that matches `app.kubernetes.io/component: backend`. The policy denies any traffic unless it's sourced from a pod that has a label that matches `app.kubernetes.io/part-of: dronedelivery`.

```yaml
apiVersion: cilium.io/v2
kind: CiliumNetworkPolicy
metadata:
  name: package-v010-dev-np-allow-ingress-traffic
  namespace: backend-dev
spec:
  endpointSelector:
    matchLabels:
      app.kubernetes.io/component: backend
  ingress:
  - fromEndpoints:
    - matchLabels:
        app.kubernetes.io/part-of: dronedelivery
    toPorts:
    - ports:
      - port: "80"
        protocol: TCP
```

For more information about Kubernetes network policies and more examples of potential default policies, see [Network policies in the Kubernetes documentation](https://kubernetes.io/docs/concepts/services-networking/network-policies). For best practices for network policies in AKS, see [Use network policies in AKS](/azure/aks/network-policy-best-practices).

When you use [Azure CNI powered by Cilium](/azure/aks/azure-cni-powered-by-cilium), Kubernetes NetworkPolicy is enforced by Cilium. For specialized requirements, Azure provides other network policy engines, including Azure network policy manager and Calico. We recommend Cilium as the default network policy engine.

### Resource quotas

Admins use resource quotas to reserve and limit resources across a development team or project. You can set resource quotas on a namespace and use them to set limits on the following resources:

- Compute resources, like central processing units (CPUs), memory, and graphics processing units (GPUs)

- Storage resources, including the number of volumes or amount of disk space for a specific storage class

- Object count, like the maximum number of secrets, services, or jobs that can be created

After the cumulative total of resource requests or limits passes the assigned quota, no further deployments are successful.

Resource quotas ensure that the total set of pods assigned to the namespace can't exceed the resource quota of the namespace. The front end can't use all of the resources for the back-end services, and the back end can't use all of the resources for the front-end services.

When you define resource quotas, all pods created in the namespace must provide limits or requests in their pod specifications. If they don't provide these values, the deployment is rejected.

The following example shows a pod specification that sets resource quota requests and limits:

```yml
requests:
  cpu: 100m
  memory: 350Mi
limits:
  cpu: 200m
  memory: 500Mi
```

For more information about resource quotas, see the following articles:

- [Enforce resource quotas](/azure/aks/operator-best-practices-scheduler#enforce-resource-quotas)
- [Resource quotas](https://kubernetes.io/docs/concepts/policy/resource-quotas/)

### Autoscaling

Kubernetes supports *autoscaling* to increase the number of pods allocated to a deployment or to increase the nodes in the cluster to increase the total available compute resources. Autoscaling is a self-correcting autonomous feedback system. You can scale pods and nodes manually, but autoscaling minimizes the chances of services reaching resource limits at high loads. An autoscaling strategy must account for both pods and nodes.

#### Cluster autoscaling

The Cluster Autoscaler (CA) scales the number of nodes. If pods can't be scheduled because of resource constraints, the CA provisions more nodes. You define a minimum number of nodes to keep the AKS cluster and your workloads operational and a maximum number of nodes for heavy traffic. The CA checks every few seconds for pending pods or empty nodes and scales the AKS cluster appropriately.

The following example shows the CA configuration from the cluster's Bicep template:

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

The following lines in the Bicep template set example minimum and maximum nodes for the CA:

```bicep
minCount: 2
maxCount: 5
```

#### Horizontal pod autoscaling

The Horizontal Pod Autoscaler (HPA) scales pods based on observed CPU, memory, or custom metrics. To configure horizontal pod scaling, you specify target metrics and the minimum and maximum number of replicas in the Kubernetes deployment pod specification. Load test your services to determine these numbers.

The CA and the HPA work together, so enable both autoscaler options in your AKS cluster. The HPA scales the application, while CA scales the infrastructure.

The following example sets resource metrics for the HPA:

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

The HPA looks at actual resources consumed or other metrics from running pods. The CA provisions nodes for pods that aren't scheduled yet. As a result, CA looks at the requested resources, as specified in the pod specification. Use load testing to fine-tune these values.

For more information, see [Scaling options for applications in AKS](/azure/aks/concepts-scale).

#### Vertical pod autoscaling

The [Vertical Pod Autoscaler (VPA)](/azure/aks/use-vertical-pod-autoscaler) automatically adjusts the CPU and memory requests for your pods to match the usage patterns of your workloads. When it's configured, the VPA automatically sets resource requests and limits on containers for each workload based on past usage. The VPA makes CPU and memory available for other pods and helps ensure effective utilization of your AKS clusters.

In this architecture, the VPA increases the CPU and memory requests and limits for microservices based on their past usage. For example, if the workflow microservice consumes more CPU compared to other microservices, the VPA can monitor this usage and increase the CPU limits for the workflow microservice.

#### Kubernetes Event-Driven Autoscaling

The [Kubernetes Event-Driven Autoscaling (KEDA)](/azure/aks/keda-about) add-on enables event-driven autoscaling to scale your microservice to meet demand in a sustainable and cost-efficient manner. For example, KEDA can scale up microservices when the number of messages in the Service Bus queue surpasses specific thresholds.

In the Fabrikam drone delivery scenario, KEDA scales out the workflow microservice depending on the Service Bus queue depth and based on the ingestion microservice output. For a list of KEDA scalers for Azure services, see [Integrations with KEDA on AKS](/azure/aks/keda-integrations).

### Health probes

Kubernetes load balances traffic to pods that match a label selector for a service. Only pods that start successfully and are healthy receive traffic. If a container crashes, Kubernetes removes the pod and schedules a replacement. Kubernetes defines three types of health probes that a pod can expose:

- The readiness probe tells Kubernetes whether the pod is ready to accept requests.

- The liveness probe tells Kubernetes whether a pod should be removed and a new instance started.

- The startup probe tells Kubernetes whether the pod is started.

The liveness probes handle pods that are still running but are unhealthy and should be recycled. For example, if a container that serves HTTP requests hangs, the container doesn't crash, but it stops serving requests. The HTTP liveness probe stops responding, which alerts Kubernetes to restart the pod.

Sometimes a pod might not be ready to receive traffic, even though the pod starts successfully. For example, the application that runs in the container might be performing initialization tasks. The readiness probe indicates whether the pod is ready to receive traffic.

Microservices should expose endpoints in their code that facilitate health probes, with delay and timeout tailored specifically to the checks that they perform. The [HPA formula](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/#algorithm-details) relies on the pod's ready phase, so it's crucial that health probes exist and are accurate.

### Monitoring

Monitoring is essential in a microservices architecture to detect anomalies, diagnose problems, and understand service dependencies. [Application Insights](/azure/azure-monitor/app/app-insights-overview), part of Azure Monitor, provides application performance monitoring (APM) for applications written in .NET, Node.js, Java, and many other languages.
Azure provides several integrated capabilities for end-to-end visibility:

- [Azure Monitor managed service for Prometheus](/azure/azure-monitor/metrics/prometheus-metrics-overview) collects and alerts on infrastructure and workload metrics.

- The [Live Data feature in Container insights](/azure/azure-monitor/containers/container-insights-livedata-overview) monitors AKS clusters, nodes, and containers for health and resource usage.

- [Azure Managed Grafana](/azure/managed-grafana/overview) visualizes metrics and dashboards for clusters and microservices.

[Advanced Container Networking Services](/azure/aks/advanced-container-networking-services-overview) observability complements these tools by providing deep, eBPF-based visibility into the network behavior of AKS clusters. It captures DNS latency, pod-to-pod and service flows, network policy drops, and level-7 protocol metrics like HTTP status codes and response times. This telemetry integrates with Azure Monitor managed service for Prometheus for metrics and Azure Managed Grafana for dashboards. The Cilium eBPF data plane provides flow-level visibility and troubleshooting. When combined with Advanced Container Networking Services and Azure Monitor, this capability delivers end-to-end network observability. This integration enables detection of network bottlenecks, policy misconfigurations, and communication problems that traditional APM might miss.

> [!TIP]
> Combine Advanced Container Networking Services network data with Azure Monitor telemetry for a complete view of application and infrastructure health. You can also integrate Application Insights with AKS [without making code changes](/azure/azure-monitor/app/kubernetes-codeless) to correlate application performance with cluster and network insights.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

Consider the following points when you plan for security:

- Use [deployment safeguards](/azure/aks/deployment-safeguards) in the AKS cluster. Deployment safeguards enforce Kubernetes best practices in your AKS cluster through Azure Policy controls.

- Integrate security scanning into the microservice build and deployment pipelines. Manage your DevOps environment by using [Microsoft Defender for Cloud DevOps security](/azure/defender-for-cloud/defender-for-devops-introduction). Use [agentless code scanning](/azure/defender-for-cloud/agentless-code-scanning) and run [static code analysis tools](/azure/defender-for-cloud/cli-cicd-integration) as part of continuous integration and continuous deployment (CI/CD) pipelines so that you can identify and address the microservice code vulnerabilities as part of the build and deployment processes.

- An AKS pod authenticates itself by using a *workload identity* that's stored in Microsoft Entra ID. You should use a workload identity because it doesn't require a client secret.

- When you use managed identities, the application can quickly get Azure Resource Manager OAuth 2.0 tokens when it runs. It doesn't need passwords or connection strings. In AKS, you can assign identities to individual pods by using [Workload ID](/azure/aks/workload-identity-overview).

- Each service in the microservice application should be assigned a unique workload identity to facilitate least-privileged Azure RBAC assignments. Only assign identities to services that require them.

- In cases where an application component requires Kubernetes API access, ensure that application pods are configured to use a service account with appropriately scoped API access. For more information, see [Manage Kubernetes service accounts](/azure/aks/concepts-identity#kubernetes-service-accounts).

- Not all Azure services support Microsoft Entra ID for data plane authentication. To store credentials or application secrets for those services, for non-Microsoft services, or for API keys, use Key Vault. It provides centralized management, access control, encryption at rest, and auditing for all keys and secrets.

- In AKS, you can mount one or more secrets from Key Vault as a volume. The pod can then read the Key Vault secrets just like a regular volume. For more information, see [Use the Key Vault provider for Secrets Store CSI Driver in an AKS cluster](/azure/aks/csi-secrets-store-driver). We recommend that you maintain separate key vaults for each microservice.

[Advanced Container Networking Services](/azure/aks/advanced-container-networking-services-overview) provides in-cluster network segmentation and zero trust controls for AKS clusters. Use Cilium network policies on [Azure CNI powered by Cilium](/azure/aks/azure-cni-powered-by-cilium) to implement layer-3 and layer-4 segmentation within the cluster. Advanced Container Networking Services security extends this foundation by adding advanced capabilities:

- FQDN-based egress filtering to restrict outbound traffic to approved domains.

- Level-7-aware policies for protocols like HTTP and gRPC Remote Procedure Call (gRPC) to validate and control application-level communication.

- WireGuard encryption to secure pod-to-pod traffic and protect sensitive data in transit.

  These features work alongside perimeter defenses like network security groups (NSGs) and Azure Firewall to deliver a layered security approach that enforces traffic control from within the cluster.

- If the microservice needs to communicate with resources, like external URLs outside of the cluster, control the access through Azure Firewall. If the microservice doesn't need to make any outbound calls, use [network isolated clusters](/azure/aks/network-isolated).

- Enable [Microsoft Defender for Containers](/azure/defender-for-cloud/defender-for-containers-introduction) to provide security posture management, vulnerability assessment for microservices, runtime threat protection, and other security features.

#### Networking data plane and policy engines

Cilium on AKS is currently supported for Linux nodes and enforces NetworkPolicy in the data plane. Be aware of policy caveats like `ipBlock` usage with node IP addresses and pod IP addresses and that host-networked pods use a host identity. Pod-level policies don't apply. Align AKS and Cilium versions with the supported version matrix. For more information, see [Azure CNI powered by Cilium limitations](/azure/aks/azure-cni-powered-by-cilium#limitations).

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

- The [Cost Optimization section in the Well-Architected Framework](/azure/architecture/framework/cost/overview) describes cost considerations.

- Use the [Azure pricing calculator](https://azure.com/e/149812331b124489ad0ae69e1ad3b118) to estimate costs for your specific scenario.

- In the Free tier, AKS has no costs associated with deployment, management, and operations of the Kubernetes cluster. You only pay for the VM instances, storage, and networking resources that the cluster consumes. Cluster autoscaling can significantly reduce the cost of the cluster by removing empty or unused nodes.

- Consider using the Free tier of AKS for development workloads, and use the [Standard and Premium tiers](/azure/aks/free-standard-pricing-tiers) for production workloads.

- Consider enabling [AKS cost analysis](/azure/aks/cost-analysis) for granular cluster infrastructure cost allocation by Kubernetes-specific constructs.

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

Consider the following points when you plan for manageability:

- Manage the AKS cluster infrastructure via an automated deployment pipeline, like [GitHub Actions](https://github.com/features/actions) workflows.

- The workflow file deploys the infrastructure only, not the workload, into the already-existing virtual network and Microsoft Entra configuration. Deploying the infrastructure and the workload separately lets you address distinct life cycle and operational concerns.

- Consider your workflow as a mechanism to deploy to another region if there's a regional failure. Build the pipeline so that you can deploy a new cluster in a new region with parameter and input changes.

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

Consider the following points when you plan for scalability:

- Don't combine autoscaling and imperative or declarative management of the number of replicas. If both users and an autoscaler attempt to change the number of replicas, unexpected behavior can occur. When the HPA is enabled, reduce the number of replicas to the minimum number that you want to deploy.

- A side effect of pod autoscaling is that pods might be created or evicted frequently when the application scales in or scales out. To mitigate these effects, do the following actions:

  - Use readiness probes to let Kubernetes know when a new pod is ready to accept traffic.

  - Use pod disruption budgets to limit how many pods can be evicted from a service at a time.

- If there's a large number of outbound flows from the microservice, consider using [network address translation (NAT) gateways](/azure/aks/nat-gateway) to avoid source network address translation (SNAT) port exhaustion.

- Multitenant or other advanced workloads might have node pool isolation requirements that demand more and likely smaller subnets. For more information, see [Add node pools that have unique subnets](/azure/aks/node-pool-unique-subnet). Organizations have different standards for their hub-spoke implementations. Be sure to follow your organizational guidelines.

- Consider using [Azure CNI with overlay networking](/azure/aks/concepts-network-cni-overview) to conserve network address space.

## Next steps

- [Introduction to AKS](/azure/aks/what-is-aks)
- [What is Virtual Network?](/azure/virtual-network/virtual-networks-overview)
- [What is Private Link?](/azure/private-link/private-link-overview)
- [What is Application Gateway?](/azure/application-gateway/overview)
- [What is Azure Bastion?](/azure/bastion/bastion-overview)
- [Introduction to Key Vault](/azure/key-vault/general/overview)
- [Introduction to Container Registry](/azure/container-registry/container-registry-intro)
- [Azure Monitor overview](/azure/azure-monitor/fundamentals/overview)
- [Advanced Container Networking Services](/azure/aks/advanced-container-networking-services-overview)

## Related resources

- [Baseline architecture for an AKS cluster](../aks/baseline-aks.yml)
- [Design, build, and operate microservices on Azure with Kubernetes](../../../guide/architecture-styles/microservices.md)
- [Microservices architecture on AKS](./aks-microservices.yml)
- [Build a CI/CD pipeline for microservices on Kubernetes](../../../microservices/ci-cd-kubernetes.yml)
