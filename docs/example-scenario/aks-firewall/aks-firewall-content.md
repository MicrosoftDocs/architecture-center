In a production environment, communications with a Kubernetes cluster should be protected using a firewall that monitors and controls the incoming and outgoing network traffic based on a predetermined set of security rules. A firewall typically establishes a barrier between a trusted network and an untrusted network, such as the Internet. The [Azure Firewall](/azure/firewall/overview) can be deployed and used in a hub virtual network and used to inspect, allow, or block the ingress and egress traffic to and from one or more [Azure Kubernetes Services](/azure/aks/) clusters hosted by one or more spoke virtual networks peered to the hub virtual network. By default, AKS clusters have unrestricted outbound internet access. This level of network access allows nodes and services running in the AKS cluster to access external resources as needed. If you wish to restrict egress traffic, a limited number of ports and addresses must be accessible to maintain healthy cluster maintenance tasks. The simplest solution to securing the outbound traffic from a Kubernetes cluster such as AKS lies in using a software firewall that can control outbound traffic based on domain names. Azure Firewall, for example, can restrict outbound HTTP and HTTPS traffic based on the FQDN of the destination. You can also configure your preferred firewall and security rules to allow these required ports and addresses. For more information, see [Control egress traffic for cluster nodes in Azure Kubernetes Service (AKS)](/azure/aks/limit-egress-traffic). In ingress, you should enable [Threat intelligence-based filtering](/azure/firewall/threat-intel) on the Azure Firewall in the perimeter network to alert and deny traffic from/to known malicious IP addresses and domains. Azure Firewall is fully integrated with Azure Monitor for logging incoming and outgoing traffic processed by the firewall. For more information, see [Azure Firewall threat intelligence-based filtering](https://docs.microsoft.com/en-us/azure/firewall/threat-intel).
A web application firewall (WAF) should be used to protect any AKS-hosted web applications and services from common threats such as SQL injection, cross-site scripting, and other web exploits using Open Web Application Security Project (OWASP) rules and custom rules. An Azure WAF policy can be applied to web applications fronted by [Azure Application Gateway](/azure/web-application-firewall/ag/ag-overview) or [Azure Front Door](/azure/web-application-firewall/afds/afds-overview). In addition, you should enable [Azure DDOS Protection Standard](https://docs.microsoft.com/en-us/azure/ddos-protection/ddos-protection-overview) on the virtual networks where Azure Kubernetes Service (AKS) clusters are deployed for protection against DDoS attacks.

## Potential use cases

Use [Terraform](https://www.terraform.io/intro/index.html) and [Azure DevOps](/azure/devops/pipelines/get-started/what-is-azure-pipelines?view=azure-devops) to automate the deployment of a private [Azure Kubernetes Service cluster](https://docs.microsoft.com/en-us/azure/aks/private-clusters) in a hub and spoke network topology where [Azure Firewall](/azure/firewall/overview) is used to control the inbound and outbound traffic using [DNAT rules, network rules, and application rules](/azure/firewall/rule-processing) and protect workloads using [threat intelligence-based filtering](/azure/firewall/threat-intel).

## Architecture

![Architecture Diagram](./media/aks-firewall.png)

*Download an [SVG](./media/aks-firewall.svg)*

Companion Terraform modules deploy a new virtual network with four subnets:

- AksSubnet: Hosts the AKS cluster
- VmSubnet: Hosts a jump-box virtual machine and private endpoints
- AppGatewaySubnet: Hosts Application Gateway WAF2
- AzureBastionSubnet: Azure Bastion

The Azure Kubernetes Service (AKS) cluster uses a user-defined managed identity to create additional resources, like load balancers and managed disks in Azure. The ARM template allows you to deploy an AKS cluster with the following features:

- [Container Storage Interface (CSI) drivers for Azure disks and Azure Files](/azure/aks/csi-storage-drivers)
- [AKS-managed AAD integration](/azure/aks/managed-aad)
- [Azure RBAC for Kubernetes Authorization](/azure/aks/manage-azure-rbac)
- [Managed identity in place of a service principal](/azure/aks/use-managed-identity)
- [Azure Active Directory pod-managed identities](/azure/aks/use-azure-ad-pod-identity)
- [Azure Network Policies](/azure/aks/use-network-policies)
- [Azure Monitor for containers add-on](/azure/azure-monitor/containers/container-insights-enable-new-cluster)
- [Application Gateway Ingress Controller add-on](https://azure.github.io/application-gateway-kubernetes-ingress/)
- [Dynamic allocation of IPs and enhanced subnet support](/azure/aks/configure-azure-cni#dynamic-allocation-of-ips-and-enhanced-subnet-support-preview)

The AKS cluster is composed of the following:

- System node pool that hosts only critical system pods and services. The worker nodes have node taint that prevents application pods from beings scheduled on this node pool.
- User node pool that hosts user workloads and artifacts.

A virtual machine (VM) is deployed in the same virtual network that is hosting the AKS cluster. When you deploy Azure Kubernetes Service as a private cluster, this VM can be used by system administrators to manage the cluster via the [Kubernetes command-line tool](https://kubernetes.io/docs/tasks/tools/). The boot diagnostics logs of the virtual machine are stored in an Azure Storage account.

An Azure Bastion host provides secure and seamless SSH connectivity to the jump-box VM, directly in the Azure portal over SSL. Azure Container Registry (ACR) is used to build, store, and manage container images and artifacts (such as Helm charts).

The architecture includes an [Azure Firewall](/azure/firewall/overview) that is used to control the inbound and outbound traffic using [DNAT rules, network rules, and application rules](/azure/firewall/rule-processing) and protect workloads using [threat intelligence-based filtering](/azure/firewall/threat-intel). The Azure Firewall and Bastion are deployed to a hub virtual network peered with the virtual network that hosts the private AKS cluster. A route table and user-defined routes are used to route the outbound traffic from the private AKS cluster to the Azure Firewall.

A Key Vault is used as a secret store by workloads that run on Azure Kubernetes Service (AKS) to retrieve keys, certificates, and secrets via a client library, [Secrets Store CSI Driver](/azure/aks/csi-secrets-store-driver), or [Dapr](https://docs.dapr.io/developing-applications/building-blocks/secrets/secrets-overview/). [Azure Private Link](/azure/private-link/private-link-overview) enables AKS workloads to access Azure PaaS Services, such as Key Vault, over a private endpoint in the virtual network.

The sample topology includes the following private endpoints:

- A private endpoint to the Blob Storage account
- A private endpoint to Azure Container Registry (ACR)
- A private endpoint to Key Vault
- If you opt for a private AKS cluster, a private endpoint to the API server of the Kubernetes cluster

The architecture also includes the following Private DNS Zones for the name resolution of the FQDN of a PaaS service to the private IP address of the associated private endpoint:

- A Private DNS Zone for the name resolution of the private endpoint to the Azure Blob Storage account
- A Private DNS Zone for the name resolution of the private endpoint to Azure Container Registry (ACR)
- A Private DNS Zone for the name resolution of the private endpoint to Azure Key Vault
- If you deploy the cluster as private, a Private DNS Zone for the name resolution of the private endpoint to the Kubernetes Server API

A Virtual Network Link exists between the hub and spoke virtual networks hosting the AKS cluster and the above Private DNS Zones. A Log Analytics workspace is used to collect the diagnostics logs and metrics from the following sources:

- Azure Kubernetes Service cluster
- Jump-box virtual machine
- Azure Application Gateway
- Azure Key Vault
- Azure network security groups

### Components

- [Azure Firewall](/azure/firewall/overview) is a cloud-native and intelligent network firewall security service that provides the best of breed threat protection for your cloud workloads running in Azure. It's a fully stateful, firewall as a service with built-in high availability and unrestricted cloud scalability. It provides both east-west and north-south traffic inspection.

- [Azure Container Registry](/azure/container-registry/container-registry-intro) is a managed, private Docker registry service based on the open-source Docker Registry 2.0. You can use Azure container registries with your existing container development and deployment pipelines, or use Azure Container Registry Tasks to build container images in Azure. Build on demand, or fully automate builds with triggers, such as source code commits and base image updates.

- [Azure Kubernetes Services](/azure/aks/) simplifies deploying a managed Kubernetes cluster in Azure by offloading the operational overhead to Azure. As a hosted Kubernetes service, Azure handles critical tasks, like health monitoring and maintenance. Since Kubernetes masters are managed by Azure, you only manage and maintain the agent nodes.

- [Azure Key Vault](/azure/key-vault/general/overview/) securely stores and controls access to secrets like API keys, passwords, certificates, and cryptographic keys. Azure Key Vault also lets you easily provision, manage, and deploy public and private Transport Layer Security/Secure Sockets Layer (TLS/SSL) certificates, for use with Azure and your internal connected resources.

- [Azure Bastion](/azure/bastion/bastion-overview) is a fully managed platform as a service (PaaS) that you provision inside your virtual network. Azure Bastion provides secure and seamless Remote Desktop Protocol (RDP) and secure shell (SSH) connectivity to the VMs in your virtual network, directly from the Azure portal over TLS.

- [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines/) provides on-demand, scalable computing resources that give you the flexibility of virtualization, without having to buy and maintain the physical hardware.

- [Azure Virtual Network](/azure/virtual-network/virtual-networks-overview) is the fundamental building block for Azure private networks. With Virtual Network, Azure resources (like VMs) can securely communicate with each other, the internet, and on-premises networks. An Azure Virtual Network is similar to a traditional network that's on premises, but it includes Azure infrastructure benefits, such as scalability, availability, and isolation.

- [Virtual Network Interfaces](/azure/virtual-network/virtual-network-network-interface) let Azure virtual machines communicate with the internet, Azure, and on-premises resources. You can add several network interface cards to one Azure VM, so that child VMs can have their own dedicated network interface devices and IP addresses.

- [Azure Managed Disks](/azure/virtual-machines/windows/managed-disks-overview) provides block-level storage volumes that Azure manages on Azure VMs. The available types of disks are Ultra disks, Premium solid-state drives (SSDs), Standard SSDs, and Standard hard disk drives (HDDs).

- [Azure Blob Storage](/azure/storage/blobs/storage-blobs-introduction) is Microsoft's object storage solution for the cloud. Blob storage is optimized for storing massive amounts of unstructured data. Unstructured data is data that doesn't adhere to a particular data model or definition, such as text or binary data.

- [Azure Private Link](/azure/private-link/private-link-overview) enables you to access Azure PaaS services (for example, Azure Blob Storage and Key Vault) and Azure hosted customer-owned/partner services, over a private endpoint in your virtual network.

### Alternatives

You can use a third-party firewall from the Azure marketplace In place of the [Azure Firewall](/azure/firewall/overview). In this case, it's your responsibility to properly configure the firewall to inspect, allow, or deny the inbound and outbound traffic from the AKS cluster.

## Considerations

Although some of the following considerations are not fully pertaining to multitenancy in Azure Kubernetes Service (AKS), we believe they are essential requirements when deploying this solution. This includes our security, performance, availability and reliability, storage, scheduler, service mesh, and monitoring considerations.

### Security considerations

Although the security considerations are not fully pertaining to multitenancy in AKS, we believe they are essential requirements when deploying this solution.

#### Network security

- Create a [private endpoint](https://azure.microsoft.com/services/private-link/) for any PaaS service that is used by AKS workloads, such as Key Vault, Service Bus, or Azure SQL Database. This is so that the traffic between the applications and these services isn't exposed to the public internet. For more information, see [What is Azure Private Link](/azure/private-link/private-link-overview).
- Configure your Kubernetes Ingress resource to expose workloads via HTTPS, and use a separate subdomain and digital certificate for each tenant. The [Application Gateway Ingress Controller (AGIC)](/azure/application-gateway/ingress-controller-overview) will automatically configure the [Azure Application Gateway](/azure/application-gateway/overview) listener for secure socket layer (SSL) termination.
- Configure [Azure Application Gateway](/azure/application-gateway/overview) to use a [Web Application Firewall Policy](/azure/application-gateway/waf-overview) to protect public-facing workloads (that are running on AKS) from malicious attacks.
- For integration with existing virtual networks or on-premises networks, use Azure CNI networking in AKS. This network model also allows greater separation of resources and controls in an enterprise environment.
- Use network policies to segregate and secure intra-service communications by controlling which components can communicate with each other. By default, all pods in a Kubernetes cluster can send and receive traffic without limitations. To improve security, you can use Azure Network Policies or Calico Network Policies to define rules that control the traffic flow between different microservices. For more information, see [Network Policy](/azure/aks/use-network-policies).
- Don't expose remote connectivity to your AKS nodes. Create a bastion host, or jump box, in a management virtual network. Use the bastion host to securely route traffic into your AKS cluster to remote management tasks.
- Consider using a [private AKS cluster](/azure/aks/private-clusters) in your production environment, or at least secure access to the API server, by using [authorized IP address ranges](/azure/aks/api-server-authorized-ip-ranges) in Azure Kubernetes Service.
- Implement the following guidelines to secure the environment described in this article:
  - [Azure security baseline for Azure Firewall](https://docs.microsoft.com/en-us/security/benchmark/azure/baselines/firewall-security-baseline)
  - [Azure security baseline for Azure Kubernetes Service](https://docs.microsoft.com/en-us/security/benchmark/azure/baselines/aks-security-baseline)
  - [Azure security baseline for Azure Bastion](https://docs.microsoft.com/en-us/security/benchmark/azure/baselines/bastion-security-baseline)
  - [Azure security baseline for Azure DDoS Protection Standard](https://docs.microsoft.com/en-us/security/benchmark/azure/baselines/ddos-protection-security-baseline)

#### Authentication and authorization

- Deploy AKS clusters with Azure AD integration. For more information, see [AKS-managed Azure Active Directory integration](/azure/aks/managed-aad). Using Azure AD centralizes the identity management component. Any change in user account or group status is automatically updated in access to the AKS cluster. Use [Roles](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#role-and-clusterrole) or [ClusterRoles](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#role-and-clusterrole) and [Bindings](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#rolebinding-and-clusterrolebinding) to scope users or groups to the least number of permissions needed.
- Use Kubernetes RBAC to define the permissions that users or groups have to resources in the cluster. Create roles and bindings that assign the least number of permissions required. [Integrate Kubernetes RBAC with Azure AD](/azure/aks/azure-ad-rbac) so any change in user status or group membership is automatically updated and access to cluster resources is current.
- Use Azure RBAC to define the minimum required permissions that users or groups have to AKS resources in one or more subscriptions. For more information, see [Kubernetes RBAC](/azure/aks/operator-best-practices-identity#use-kubernetes-role-based-access-control-kubernetes-rbac) and [Use Azure RBAC for Kubernetes authorization](/azure/aks/manage-azure-rbac).

- Consider using [AAD Pod Identity](/azure/aks/use-azure-ad-pod-identity) to assign a managed identity for an Azure resource to individual microservices, which they can then use to access managed resources (such as Azure Key Vault, SQL Database, Service Bus, and Cosmos DB), without the need to store and retrieve use connection strings or credentials from Kubernetes secrets.
- Consider using the [Secret Store CSI Driver for Azure Key Vault](/azure/key-vault/general/key-vault-integrate-kubernetes) to access secrets, such as credentials and connections strings from Key Vault, rather than from Kubernetes secrets.
- Consider using the [Dapr Secrets Stores](https://v1-rc2.docs.dapr.io/developing-applications/building-blocks/secrets/secrets-overview/) building block, with the [Azure Key Vault store with Managed Identities on Kubernetes](https://v1-rc2.docs.dapr.io/operations/components/setup-secret-store/supported-secret-stores/azure-keyvault-managed-identity/), to retrieve secrets (such as credentials and connection strings) from Key Vault.

#### Workload and cluster

- Securing access to the Kubernetes API-Server is one of the most important things you can do to secure your cluster. Integrate Kubernetes role-based access control (Kubernetes RBAC) with Azure Active Directory to control access to the API server. These controls let you secure AKS the same way that you secure access to your Azure subscriptions.
- Limit access to actions that containers can perform. Use [Pod Security Policy](https://kubernetes.io/docs/concepts/policy/pod-security-policy/) to enable the fine-grained authorization of pod creation and updates. Provide the least number of permissions, and avoid the use of root / privileged escalation. For more best practices, see [Secure pod access to resources](/azure/aks/developer-best-practices-pod-security#secure-pod-access-to-resources).
- Whenever possible, avoid running containers as a root user.
- Use the [AppArmor](https://kubernetes.io/docs/tutorials/clusters/apparmor/) Linux kernel security module to limit the actions that containers can do.
- Regularly upgrade your AKS clusters to the latest Kubernetes version to take advantage of new features and bug fixes.
- AKS automatically downloads and installs security fixes on each Linux node, but it doesn't automatically reboot the node if necessary. Use [kured](https://github.com/weaveworks/kured) to watch for pending reboots, cordon and drain nodes, and finally, apply your updates. For Windows Server nodes, regularly run an AKS upgrade operation to safely cordon and drain pods and to deploy any updated nodes.
- Consider using HTTPS and gRPC secure transport protocols for all intra-pod communications and to use a more advanced authentication mechanism that does not require you to send the plain credentials on every request, like OAuth or JWT. Secure intra-service communication can be achieved by leveraging a service mesh, like [Istio](https://istio.io/), [Linkerd](https://linkerd.io/), [Consul](https://www.consul.io/), or [Open Service Mesh](https://openservicemesh.io/), or by using [Dapr](https://v1-rc2.docs.dapr.io/developing-applications/building-blocks/service-invocation/service-invocation-overview/).

#### Azure Container Registry

- Scan your container images for vulnerabilities, and only deploy images that have passed validation. Regularly update the base images and application runtime, then redeploy workloads in the AKS cluster. Your deployment workflow should include a process to scan container images, by using tools such as [Prisma Cloud](https://docs.prismacloudcompute.com/docs/) or [Aqua](https://www.aquasec.com/), and then you can only allow verified images to be deployed.
- As you use base images for application images, use automation to build new images when the base image is updated. Because those base images typically include security fixes, update any downstream application container images. For more information about base image updates, see [Automate image builds on base image update with Azure Container Registry Tasks](/azure/container-registry/container-registry-tutorial-base-image-update).

### Performance considerations

Although the performance considerations are not fully pertaining to multitenancy in Azure Kubernetes Service (AKS), we believe they are essential requirements when deploying this solution:

- For low latency workloads, consider deploying a dedicated node pool in a proximity placement group. When deploying your application in Azure, spreading Virtual Machine (VM) instances across regions or availability zones creates network latency, which may impact the overall performance of your application. A proximity placement group is a logical grouping that's used to make sure Azure compute resources are physically located close to each other. Some use cases (such as gaming, engineering simulations, and high-frequency trading (HFT)) require low latency and tasks that complete quickly. For high-performance computing (HPC) scenarios such as these, consider using [proximity placement groups](/azure/virtual-machines/co-location#proximity-placement-groups) (PPG) for your cluster's node pools.
- Always use smaller container images, as it helps you to create faster builds. Smaller images are also less vulnerable to attack vectors, because of a reduced attack surface.
- Use Kubernetes autoscaling to dynamically scale out the number of worker nodes of an AKS cluster when the traffic increases. With [Horizontal Pod Autoscaler](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/) and a cluster autoscaler, node and pod volumes get adjusted dynamically in real-time, to match the traffic condition and to avoid downtimes that are caused by capacity issues. For more information, see [Automatically scale a cluster to meet application demands on Azure Kubernetes Service (AKS)](/azure/aks/cluster-autoscaler).

### Availability and reliability considerations

Although the availability and reliability considerations are not fully pertaining to multitenancy in Azure Kubernetes Service (AKS), we believe they are essential requirements when deploying this solution. Consider the following ways to optimize availability for your AKS cluster and workloads.

#### Containers

- Use Kubernetes health probes to check that your containers are alive and healthy:

  - The [livenessProbe](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/#define-a-liveness-command) indicates whether the container is running. If the liveness probe fails, the [kubelet](https://kubernetes.io/docs/reference/command-line-tools-reference/kubelet/) kills the container, and the container is subjected to its restart policy.
  - The [readinessProbe](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/#define-readiness-probes) indicates whether the container is ready to respond to requests. If the readiness probe fails, the endpoints controller removes the pod's IP address from the endpoints of all services that match the pod. The default state of readiness before the initial delay is Failure.
  - The [startup probe](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/#define-startup-probes) indicates whether the application within the container is started. All other probes are disabled if a startup probe is provided, until it succeeds. If the startup probe fails, the [kubelet](https://kubernetes.io/docs/reference/command-line-tools-reference/kubelet/) kills the container, and the container is subjected to its restart policy.

- Resource contention can affect service availability. Define container resource constraints so that no single container can overwhelm the cluster memory and CPU resources. You can use AKS diagnostics to identify any issues in the cluster.
- Use the resource limit to restrict the total resources allowed for a container, so one particular container can't starve others.

#### Container registry

- We suggest storing container images in Azure Container Registry, and then geo-replicate the registry to each AKS region using [Azure Container Registry geo-replication](/azure/container-registry/container-registry-geo-replication). Geo-replication is a feature of Premium SKU ACR registries.
- Scan your container images for vulnerabilities, and only deploy images that have passed validation. Regularly update the base images and application runtime, and then redeploy your workloads in the AKS cluster.
- Limit the image registries that pods and deployments can use. Only allow trusted registries, where you validate and control the images that are available.
- As you use base images for application images, use automation to build new images, when the base image is updated. Because those base images typically include security fixes, update any downstream application container images.
- Leverage [ACR Tasks](/azure/container-registry/container-registry-tasks-overview) in Azure Container Registry to automate OS and framework patching for your Docker containers. ACR Tasks supports automated build execution, when a container's base image is updated, such as when you patch the OS or application framework in one of your base images.

#### Intra-region resiliency

- Consider deploying the node pools of your AKS cluster, across all the [Availability Zones](/azure/aks/availability-zones) within a region, and use an [Azure Standard Load Balancer](/azure/load-balancer/load-balancer-overview) or [Azure Application Gateway](/azure/application-gateway/overview) in front of your node pools. This topology provides better resiliency, in case of an outage of a single datacenter. This way, cluster nodes are distributed across multiple datacenters, in three separate Availability Zones within a region.
- Enable [zone redundancy in Azure Container Registry](/azure/container-registry/zone-redundancy), for intra-region resiliency and high availability.
- Use [Pod Topology Spread Constraints](https://kubernetes.io/docs/concepts/workloads/pods/pod-topology-spread-constraints/) to control how pods are spread across your AKS cluster among failure-domains, such as regions, availability zones, and nodes.
- Consider using Uptime SLA for AKS clusters that host mission-critical workloads. [Uptime SLA](/azure/aks/uptime-sla) is an optional feature to enable a financially backed, higher SLA for a cluster. Uptime SLA guarantees 99.95% availability of the Kubernetes API server endpoint, for clusters that use Availability Zones. And it guarantees 99.9% availability for clusters that don't use Availability Zones. AKS uses master node replicas across update and fault domains, in order to ensure the SLA requirements are met.

#### Disaster recovery and business continuity

- Consider deploying your solution to at least [two paired Azure regions](/azure/best-practices-availability-paired-regions) within a geography. You should also adopt a global load balancer, such as [Azure Traffic Manager](/azure/traffic-manager/traffic-manager-overview) or [Azure Front Door](/azure/frontdoor/front-door-overview), with an active/active or active/passive routing method, in order to guarantee business continuity and disaster recovery.
- Make sure to script, document, and periodically test any regional failover process in a QA environment, to avoid unpredictable issues if a core service is affected by an outage in the primary region.
- These tests are also meant to validate if the DR approach meets the RPO/RTO targets, in conjunction to eventual manual processes and interventions that are needed for a failover.
- Make sure you test fail-back procedures, to understand if they work as expected.
- Store your container images in [Azure Container Registry](/azure/container-registry/container-registry-intro), and geo-replicate the registry to each AKS region. For more information, see [Geo-replication in Azure Container Registry](/azure/container-registry/container-registry-geo-replication).
- Where possible, don't store service state inside the container. Instead, use an Azure platform as a service (PaaS) that supports multi-region replication.
- If you use Azure Storage, prepare and test how to migrate your storage from the primary region to the backup region.

### Storage considerations

Although the storage considerations are not fully pertaining to multitenancy in Azure Kubernetes Service (AKS), we believe they are essential requirements when deploying this solution:

- Consider deploying your AKS cluster with [ephemeral OS disks](/azure/aks/cluster-configuration#ephemeral-os) that provide lower read/write latency, along with faster node scaling and cluster upgrades.
- Understand the needs of your application to pick the right storage. Use high performance, SSD-backed storage for production workloads. Plan for a network-based storage system, such as [Azure Files](/azure/storage/files/storage-files-introduction), when multiple pods need to concurrently access the same files. For more information, see [Storage options for applications in Azure Kubernetes Service (AKS)](/azure/aks/concepts-storage).
- Each node size supports a maximum number of disks. Different node sizes also provide different amounts of local storage and network bandwidth. Plan for your application demands to deploy the appropriate size of nodes.
- To reduce management overhead and let you scale, don't statically create and assign persistent volumes. Use dynamic provisioning. In your storage classes, define the appropriate reclaim policy to minimize unneeded storage costs, once pods are deleted.

### Multitenancy considerations

- Design AKS clusters for multitenancy. Kubernetes provides features that let you logically isolate teams and workloads in the same cluster. The goal should be to provide the least number of privileges, scoped to the resources that each team needs. A [Namespace](/azure/aks/concepts-clusters-workloads#namespaces) in Kubernetes creates a logical isolation boundary.
- Use logical isolation to separate teams and projects. Try to minimize the number of physical AKS clusters that you deploy to isolate teams or applications. The logical separation of clusters usually provides a higher pod density than physically isolated clusters.
- Use dedicated node pools, or dedicated AKS clusters, whenever you need to implement a strict physical isolation. For example, you can dedicate a pool of worker nodes or an entire cluster, to a team or a tenant in a multitenant environment.

### Scheduler considerations

Although some of the scheduler considerations are not fully pertaining to multitenancy in Azure Kubernetes Service (AKS), we believe they are essential requirements when deploying this solution:

- Make sure you review and implement the [best practices](/azure/aks/best-practices), for cluster operators and application developers to build and run applications successfully on Azure Kubernetes Service (AKS).
- Plan and apply [resource quotas](https://kubernetes.io/docs/concepts/policy/resource-quotas/) at the namespace level, for all namespaces. If pods don't define resource requests and limits, then reject the deployment. Monitor resource usage, and then adjust quotas as needed. When several teams or tenants share an AKS cluster with a fixed number of nodes, resource quotas can be used to assign a fair share of resources to each team or tenant.
- Adopt [Limit Ranges](https://kubernetes.io/docs/concepts/policy/limit-range/) to constrain resource allocations (to pods or containers) in a namespace, in terms of CPU and memory.
- Explicitly define resource [requests and limits](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) for CPU and memory usage, for your pods in the YAML manifests or Helm charts that you use to deploy applications. When you specify the resource request for containers in a pod, the Kubernetes scheduler uses this information to decide which node to place the pod on. When you specify a resource limit (such as the CPU or memory) for a container, the kubelet enforces those limits so that the running container can't use more of that resource than the limit you set.
- To maintain the availability of applications, define [Pod Disruption Budgets](https://kubernetes.io/docs/tasks/run-application/configure-pdb/), to make sure that a minimum number of pods are available in the cluster.
- [Priority classes](https://kubernetes.io/docs/concepts/configuration/pod-priority-preemption/) can be used to indicate the importance of a pod. If a pod cannot be scheduled, the scheduler tries to preempt (evict) lower priority pods, in order to make scheduling of the pending pod possible.
- Use Kubernetes [taints and tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) to place resource-intensive applications on specific nodes, and to avoid noisy neighbor issues. Keep node resources available for workloads that require them, and don't allow other workloads to be scheduled on the nodes.
- Control the scheduling of pods on nodes, by using node selectors, node affinity, or inter-pod affinity. Use inter-pod [affinity and anti-affinity](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#affinity-and-anti-affinity) settings to colocate pods that have chatty communications, to place pods on different nodes, and to avoid running multiple instances of the same pod kind on the same node.

### Service mesh considerations

Although the service mesh considerations are not fully pertaining to multitenancy in AKS, we believe they are essential requirements when deploying this solution:

- Consider using an open-source service mesh (like [Istio](https://istio.io/), [Linkerd](https://linkerd.io/), [Consul](https://www.consul.io/), or [Open Service Mesh](https://openservicemesh.io/)) in your AKS cluster, in order to improve the observability, reliability, and security for your microservices, via mutual TLS. You can also implement traffic-splitting strategies (such blue/green deployments and canary deployments). In short, a service mesh is a dedicated infrastructure layer for making service-to-service communication safe, fast, and reliable. For more information, see:

  - [Install and use Istio in Azure Kubernetes Service (AKS)](/azure/aks/servicemesh-istio-install?pivots=client-operating-system-linux)
  - [Install Linkerd in Azure Kubernetes Service (AKS)](/azure/aks/servicemesh-linkerd-install?pivots=client-operating-system-linux)
  - [Install and use Consul in Azure Kubernetes Service (AKS)](/azure/aks/servicemesh-consul-install?pivots=client-operating-system-linux)
  - [Open Service Mesh AKS add-on](/azure/aks/open-service-mesh-about)

- Consider adopting [Dapr](https://dapr.io) to build resilient, microservice stateless and stateful applications. You can use any programming language and developer framework.

### DevOps considerations

- Deploy your workloads to Azure Kubernetes Service (AKS), with a [Helm](https://helm.sh/) chart in a CI/CD pipeline, by using a DevOps system, such as [GitHub Actions](https://docs.github.com/en/actions) or [Azure DevOps](https://azure.microsoft.com/services/devops/). For more information, see [Build and deploy to Azure Kubernetes Service](/azure/devops/pipelines/ecosystems/kubernetes/aks-template?view=azure-devops).
- Introduce A/B testing and canary deployments in your application lifecycle management, to properly test an application before making it available for all users. There are several techniques that you can use to split the traffic across different versions of the same service.
- As an alternative, you can use the traffic-splitting capabilities that are provided by a service mesh implementation. For more information, see:</p>

  - [Linkerd Traffic Split](https://linkerd.io/2.10/features/traffic-split/)
  - [Istio Traffic Management](https://istio.io/latest/docs/concepts/traffic-management/)

- Use Azure Container Registry or another container registry (like Docker Hub), to store the private Docker images that are deployed to the cluster. AKS can authenticate with Azure Container Registry, by using its Azure AD identity.

### Monitoring considerations

Although the monitoring considerations are not fully pertaining to multitenancy in Azure Kubernetes Service (AKS), we believe they are essential requirements when deploying this solution:

- Use [Container insights](/azure/azure-monitor/containers/container-insights-overview) to monitor the health status of the AKS cluster and workloads.
- Configure all the PaaS services (such as Azure Container Registry and Key Vault) to collect diagnostics logs and metrics, to [Azure Monitor Log Analytics](/azure/azure-monitor/logs/log-analytics-overview).

## Deploy this scenario

The source code for this scenario is available on [GitHub](https://github.com/paolosalvatori/private-aks-cluster-terraform-devops) and under [Azure Samples](https://github.com/azure-samples/private-aks-cluster-terraform-devops). This solution is open source and provided with a [MIT License](https://github.com/paolosalvatori/private-aks-cluster-terraform-devops/blob/master/LICENSE).

### Prerequisites

For online deployments, you must have an existing Azure account. If you need one, create a [free Azure account](https://azure.microsoft.com/free/?WT.mc_id=A261C142F) before you begin. There are some requirements you need to complete before we can deploy Terraform modules using Azure DevOps.

- Store the Terraform state file to an Azure storage account. For more information on how to create to use a storage account to store remote Terraform state, state locking, and encryption at rest, see [Store Terraform state in Azure Storage](https://docs.microsoft.com/en-us/azure/developer/terraform/store-state-in-azure-storage?tabs=azure-cli)
- Create an Azure DevOps Project. For more information, see [Create a project in Azure DevOps](https://docs.microsoft.com/en-us/azure/devops/organizations/projects/create-project?view=azure-devops&tabs=preview-page)
- Create an [Azure DevOps Service Connection](https://docs.microsoft.com/en-us/azure/devops/pipelines/library/service-endpoints?view=azure-devops&tabs=yaml) to your Azure subscription. No matter you use Service Principal Authentication (SPA) or an Azure-Managed Service Identity when creating the service connection, make sure that the service principal or managed identity used by Azure DevOps to connect to your Azure subscription is assigned the owner role on the entire subscription.

### Deployment to Azure

1. Make sure you have your Azure subscription information handy.

2. Start by cloning the [workbench GitHub repository](https://github.com/paolosalvatori/private-aks-cluster-terraform-devops):

   ```git
   git clone https://github.com/paolosalvatori/private-aks-cluster-terraform-devops.git
   ```

3. Follow the instructions provided in the [README.md file](https://github.com/paolosalvatori/private-aks-cluster-terraform-devops/blob/master/README.md).

### Fix the routing issue

When you deploy an Azure Firewall into a hub virtual network and your private AKS cluster in a spoke virtual network, and you want to use the Azure Firewall to control the egress traffic using network and application rule collections, you need to make sure to properly configure the ingress traffic to any public endpoint exposed by any service running on AKS to enter the system via one of the public IP addresses used by the Azure Firewall. In order to route the traffic of your AKS workloads to the Azure Firewall in the hub virtual network, you need to create and associate a route table to each subnet hosting the worker nodes of your cluster and create a user-defined route to forward the traffic for `0.0.0.0/32` CIDR to the private IP address of the Azure firewall and specify `Virtual appliance` as `next hop type`. For more information, see [Tutorial: Deploy and configure Azure Firewall using the Azure portal](https://docs.microsoft.com/en-us/azure/firewall/tutorial-firewall-deploy-portal#create-a-default-route).

When you introduce an Azure firewall to control the egress traffic from your private AKS cluster, you need to configure the internet traffic to go throught one of the public Ip address associated to the Azure Firewall in front of the Public Standard Load Balancer used by your AKS cluster. This is where the problem occurs. Packets arrive on the firewall's public IP address, but return to the firewall via the private IP address (using the default route). To avoid this problem, create an additional user-defined route for the firewall's public IP address as shown in the picture below. Packets going to the firewall's public IP address are routed via the Internet. This avoids taking the default route to the firewall's private IP address.

![Firewall](media/firewall-lb-asymmetric.png)

For more information, see:

- [Restrict egress traffic from an AKS cluster using Azure firewall](https://docs.microsoft.com/en-us/azure/aks/limit-egress-traffic#restrict-egress-traffic-using-azure-firewall)
- [Integrate Azure Firewall with Azure Standard Load Balancer](https://docs.microsoft.com/en-us/azure/firewall/integrate-lb)

### Azure DevOps Self-Hosted Agent

If you plan to use [Azure DevOps](https://docs.microsoft.com/en-us/azure/devops/?view=azure-devops), you can't use [Azure DevOps Microsoft-hosted agents](https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/agents?view=azure-devops&tabs=browser#microsoft-hosted-agents) to deploy your workloads to a private AKS cluster as they don't have access to its API server. In order to deploy workloads to your private SAKS cluster you need to provision and use an [Azure DevOps self-hosted agent](https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/agents?view=azure-devops&tabs=browser#install) in the same virtual network of your private AKS cluster or in peered virtual network. In this latter case, make sure to the create a virtual network link between the Private DNS Zone of the AKS cluster in the node resource group and the virtual network that hosts the Azure DevOps self-hosted agent. You can deploy a single [Windows](https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/v2-windows?view=azure-devops) or [Linux](https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/v2-linux?view=azure-devops) Azure DevOps agent using a virtual machine, or use a virtual machine scale set (VMWSS). Azure virtual machine scale set agents are a form of self-hosted agents that can be auto-scaled to meet your demands. This elasticity reduces your need to run dedicated agents all the time. Unlike Microsoft-hosted agents, you have flexibility over the size and the image of machines on which agents run. You specify a virtual machine scale set, a number of agents to keep on standby, a maximum number of virtual machines in the scale set, and Azure Pipelines manages the scaling of your agents for you. For more information, see [Azure virtual machine scale set agents](https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/scale-set-agents?view=azure-devops). As an alternative, you can set up a self-hosted agent in Azure Pipelines to run inside a Windows Server Core (for Windows hosts), or Ubuntu container (for Linux hosts) with Docker and deploy it as a pod with one or multiple replicas in your private AKS cluster.
In this case, if the subnets hosting the node pools of your private AKS cluster are configured to route the egress traffic to an Azure Firewall via a route table and user-defined route, make sure to create the proper application and network rules to allow the agent to access external sites to download and install tools like [Docker](https://www.docker.com/), [kubectl](https://kubectl.docs.kubernetes.io/guides/introduction/kubectl/), [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli), and [Helm](https://helm.sh/) to the agent virtual machine. For more informations, see [Run a self-hosted agent in Docker](https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/docker?view=azure-devops) and [Build and deploy Azure DevOps Pipeline Agent on AKS](https://github.com/ganrad/Az-DevOps-Agent-On-AKS). The [cd-self-hosted-agent](./pipelines/cd-self-hosted-agent.yml) pipeline in this sample deploys a [self-hosted Linux agent](https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/v2-linux?view=azure-devops) as an Ubuntu Linux virtual machine in the same virtual network hosting the private AKS cluster. The pipeline uses a Terraform module under the [agent](./agent) folder to deploy the virtual machine. Make sure to specify values for the variables in the [cd-self-hosted-agent](./pipelines/cd-self-hosted-agent.yml) and in the [agent.tfvars](./tfvars/agent/agent.tfvars). The following picture represents the network topology of Azure DevOps and self-hosted agent.

![Architecture](media/self-hosted-agent.png)

### Use Azure Firewall in front of the Public Standard Load Balancer of the AKS cluster

The resource definiton in the Terraform modules make use of the [lifecycle](https://www.terraform.io/docs/language/meta-arguments/lifecycle.html) meta-argument to customize the actions when Azure resources get changed changes outside of Terraform control. The [ignore_changes](https://www.terraform.io/docs/language/meta-arguments/lifecycle.html#ignore_changes) argument is used to instruct Terraform to ignore updates to given resource properties such as tags. The Azure Firewall Policy resource definition contains a lifecycle block to prevent Terraform to fix the resource when a rule collection or a single rule gets created, updated, or deleted. Likewise, the Azure Route Table contains a a lifecycle block to prevent Terraform to fix the resource when a user-defined route gets created, deleted, or updated. This allows to manage the DNAT, Application, and Network rules of an Azure Firewall Policy and the user-defined routes of an Azure Route Table outside of Terraform control.

The sample contains an Azure DevOps CD pipeline that shows how you can deploy a workload to a private AKS cluster using an [Azure DevOps Pipelines](https://docs.microsoft.com/en-us/azure/devops/pipelines/get-started/what-is-azure-pipelines?view=azure-devops) that runs on a [Self-hosted Agent](https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/agents?tabs=browser). The sample deploys the Bitnami [redmine](https://artifacthub.io/packages/helm/bitnami/redmine) project management web application using a public [Helm](https://helm.sh/) chart. The following diagram shows the network topology of the sample:

![Public Standard Load Balancer](media/firewall-public-load-balancer.png)

The message flow can be described as follows:

1. A request for the AKS-hosted web application is sent to a public IP exposed by the Azure Firewall via a public IP configuration. Both the public IP and public IP configuration are dedicated to this workload.
2. An [Azure Firewall DNAT rule](https://docs.microsoft.com/en-us/azure/firewall/tutorial-firewall-dnat) is used to to translate the Azure Firewall public IP address and port to the public IP and port used by the workload in the `kubernetes` public Standard Load Balancer of the AKS cluster in the node resource group.
3. The request is sent by the load balancer to one of the Kubernetes service pods running on one of the agent nodes of the AKS cluster.
4. The response message is sent back to the original caller via a user-defined with the Azure Firewall public IP as address prefix and Internet as next hope type.
5. Any workload-initiated outbound call is routed to the private IP address of the Azure Firewall by the default user-defined route with `0.0.0.0/0` as address prefix and virtual appliance as next hope type.

For more information, see [Use Azure Firewall in front of the Public Standard Load Balancer of the AKS cluster](https://github.com/paolosalvatori/private-aks-cluster-terraform-devops#Use-Azure-Firewall-in-front-of-the-Public-Standard-Load-Balancer-of-the-AKS-cluster).

### Use Azure Firewall in front of an internal Standard Load Balancer

In this scenario, an ASP.NET Core application is hosted as a service by an Azure Kubernetes Service cluster and fronted by an [NGINX ingress controller](https://kubernetes.github.io/ingress-nginx/). The [NGINX ingress controller](https://kubernetes.github.io/ingress-nginx/) is exposed via an internal load balancer with a private  IP address in the spoke virtual network that hosts the AKS cluster. For more information, see [Create an ingress controller to an internal virtual network in Azure Kubernetes Service (AKS)](https://docs.microsoft.com/en-us/azure/aks/ingress-internal-ip). When you deploy an NGINX ingress controller or more in general a `LoadBalancer` or `ClusterIP` service with the `service.beta.kubernetes.io/azure-load-balancer-internal: "true"` annotation in the metadata section, an internal standard load balancer called `kubernetes-internal` gets created under the node resource group. For more information, see [Use an internal load balancer with Azure Kubernetes Service (AKS)](https://docs.microsoft.com/en-us/azure/aks/internal-lb). As shown in the picture below, the test web application is exposed via the Azure Firewall using a dedicated Azure public IP.  

![Internal Standard Load Balancer](media/firewall-internal-load-balacer.png)

The message flow can be described as follows:

1. A request for the AKS-hosted test web application is sent to a public IP exposed by the Azure Firewall via a public IP configuration. Both the public IP and public IP configuration are dedicated to this workload.
2. An [Azure Firewall DNAT rule](https://docs.microsoft.com/en-us/azure/firewall/tutorial-firewall-dnat) is used to to translate the Azure Firewall public IP address and port to the private IP address and port used by the NGINX ingress conroller in the internal Standard Load Balancer of the AKS cluster in the node resource group.
3. The request is sent by the internal load balancer to one of the Kubernetes service pods running on one of the agent nodes of the AKS cluster.
4. The response message is sent back to the original caller via a user-defined with `0.0.0.0/0` as address prefix and virtual appliance as next hope type.
5. Any workload-initiated outbound call is routed to the private IP address of the user-defined route.

For more information, see [Use Azure Firewall in front of an internal Standard Load Balancer](https://github.com/paolosalvatori/private-aks-cluster-terraform-devops#Use-Azure-Firewall-in-front-of-an-internal-Standard-Load-Balancer).

## Pricing

The cost of this architecture depends on configuration aspects, like the following:

- Service tiers
- Scalability, meaning the number of instances that are dynamically allocated by services to support a given demand
- Automation scripts
- Your disaster recovery level

After you assess these aspects, go to the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate your costs. Also, for more pricing optimization options, see the [Principles of cost optimization](../../framework/cost/overview.md) in the Microsoft Azure Well-Architected Framework.

## Next steps

### Azure Firewall

- [What is Azure Firewall?](https://docs.microsoft.com/en-us/azure/firewall/overview)
- [Azure Firewall Policy rule sets](https://docs.microsoft.com/en-us/azure/firewall/policy-rule-sets)
- [Configure Azure Firewall rules](https://docs.microsoft.com/en-us/azure/firewall/rule-processing)
- [Azure Firewall DNS Proxy details](https://docs.microsoft.com/en-us/azure/firewall/dns-details)
- [Azure Firewall Premium features](https://docs.microsoft.com/en-us/azure/firewall/premium-features)
- [Azure Firewall threat intelligence-based filtering](https://docs.microsoft.com/en-us/azure/firewall/threat-intel)

### Azure Kubernetes Service

- [Create a private Azure Kubernetes Service cluster](https://github.com/paolosalvatori/private-aks-cluster)
- [Best practices for multitenancy and cluster isolation](/azure/aks/operator-best-practices-cluster-isolation)
- [Best practices for basic scheduler features in Azure Kubernetes Service (AKS)](/azure/aks/operator-best-practices-scheduler)
- [Best practices for advanced scheduler features](/azure/aks/operator-best-practices-advanced-scheduler)
- [Best practices for authentication and authorization](/azure/aks/operator-best-practices-advanced-scheduler)
- [Best practices for cluster security and upgrades in Azure Kubernetes Service (AKS)](/azure/aks/operator-best-practices-cluster-security)
- [Best practices for container image management and security in Azure Kubernetes Service (AKS)](/azure/aks/operator-best-practices-container-image-management)
- [Best practices for network connectivity and security in Azure Kubernetes Service (AKS)](/azure/aks/operator-best-practices-network)
- [Best practices for storage and backups in Azure Kubernetes Service (AKS)](/azure/aks/operator-best-practices-storage)
- [Best practices for business continuity and disaster recovery in Azure Kubernetes Service (AKS)](/azure/aks/operator-best-practices-multi-region)
- [Azure Kubernetes Services (AKS) day-2 operations guide](../../operator-guides/aks/day-2-operations-guide.md)

### Azure Application Gateway

- [Overview of WebSocket support in Application Gateway](/azure/application-gateway/application-gateway-websocket#websocket-enabled-backend)
- [Configure end to end TLS by using Application Gateway with PowerShell](/azure/application-gateway/application-gateway-end-to-end-ssl-powershell)
- [How an Application Gateway works](/azure/application-gateway/how-application-gateway-works)

### Azure Application Gateway Ingress Controller

- [What is Application Gateway Ingress Controller?](/azure/application-gateway/ingress-controller-overview)
- [Documentation for Application Gateway Ingress Controller](https://azure.github.io/application-gateway-kubernetes-ingress/)
- [Annotations for Application Gateway Ingress Controller](/azure/application-gateway/ingress-controller-annotations)
- [Certificate issuance with LetsEncrypt.org](https://azure.github.io/application-gateway-kubernetes-ingress/how-tos/lets-encrypt/)
- [Tutorial: Enable the Ingress Controller add-on (preview) for a new AKS cluster with a new Application Gateway instance](/azure/application-gateway/tutorial-ingress-controller-add-on-new)
- [Tutorial: Enable Application Gateway Ingress Controller add-on for an existing AKS cluster with an existing Application Gateway through Azure CLI (Preview)](/azure/application-gateway/tutorial-ingress-controller-add-on-existing)
- [Difference between Helm deployment and AKS Add-On](/azure/application-gateway/ingress-controller-overview#difference-between-helm-deployment-and-aks-add-on)

### Azure Application Gateway WAF

- [What is Azure Web Application Firewall on Azure Application Gateway?](/azure/web-application-firewall/ag/ag-overview)
- [Web Application Firewall CRS rule groups and rules](/azure/web-application-firewall/ag/application-gateway-crs-rulegroups-rules?tabs=owasp31)
- [Custom rules for Web Application Firewall v2 on Azure Application Gateway](/azure/web-application-firewall/ag/custom-waf-rules-overview)
- [Quickstart: Create an Azure WAF v2 on Application Gateway using an ARM template](/azure/web-application-firewall/ag/quick-create-template)
- [Microsoft.Network/ApplicationGatewayWebApplicationFirewallPolicies Resource Type](/azure/templates/microsoft.network/applicationgatewaywebapplicationfirewallpolicies)
- [Create and use Web Application Firewall v2 custom rules on Application Gateway](/azure/web-application-firewall/ag/create-custom-waf-rules)
- [az network application-gateway waf-policy Azure CLI commands](/cli/azure/network/application-gateway/waf-policy)
- [Enable Web Application Firewall using the Azure CLI](/azure/web-application-firewall/ag/tutorial-restrict-web-traffic-cli)
- [Configure per-site WAF policies using Azure PowerShell](/azure/web-application-firewall/ag/per-site-policies)
- [Create Web Application Firewall policies for Application Gateway](/azure/web-application-firewall/ag/create-waf-policy-ag#migrate-to-waf-policy)

## Related resources

### Architectural guidance

- [Azure Kubernetes Service (AKS) solution journey](../../reference-architectures/containers/aks-start-here.md)
- [AKS cluster best practices](/Azure/aks/best-practices?toc=https%3A%2F%2Fdocs.microsoft.com%2Fen-us%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Fdocs.microsoft.com%2Fen-us%2Fazure%2Farchitecture%2Fbread%2Ftoc.json)
- [Azure Kubernetes Services (AKS) day-2 operations guide](../../operator-guides/aks/day-2-operations-guide.md)
- [Choosing a Kubernetes at the edge compute option](../../operator-guides/aks/choose-kubernetes-edge-compute-option.md)

### Reference architectures

- [Baseline architecture for an Azure Kubernetes Service (AKS) cluster](../../reference-architectures/containers/aks/secure-baseline-aks.yml)
- [Microservices architecture on Azure Kubernetes Service (AKS)](../../reference-architectures/containers/aks-microservices/aks-microservices.yml)
- [Advanced Azure Kubernetes Service (AKS) microservices architecture](../../reference-architectures/containers/aks-microservices/aks-microservices-advanced.yml)
- [CI/CD pipeline for container-based workloads](../apps/devops-with-aks.yml)
- [Building a telehealth system on Azure](../apps/telehealth-system.yml)
