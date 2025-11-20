This solution uses [Azure Web Application Firewall (WAF)](/azure/web-application-firewall/ag/ag-overview) to help provide centralized protection for web applications that you deploy on a multitenant Azure Kubernetes Service (AKS) cluster. WAF helps safeguard against common exploits and vulnerabilities.

You can use a [WAF policy](/azure/web-application-firewall/ag/create-waf-policy-ag) on Azure Application Gateway to help protect web applications from malicious attacks, like SQL injection and cross-site scripting. This method helps protect web applications that run on an [AKS cluster](/azure/aks/intro-kubernetes) and are exposed via the [Application Gateway Ingress Controller (AGIC)](/azure/application-gateway/ingress-controller-overview). The WAF policy on Application Gateway is preconfigured with the Open Worldwide Application Security Project (OWASP) Core Rule Set (CRS) and supports other OWASP CRS versions. You can also create custom rules.

## Architecture

:::image type="content" border="false" source="./media/aks-agic.svg" alt-text="Diagram that shows the Application Gateway Ingress Controller solution." lightbox="./media/aks-agic.svg":::

*Download a [Visio file](https://arch-center.azureedge.net/aks-agic-multitenant.vsdx) of this architecture.*

### Workflow

- This architecture uses a companion Azure Resource Manager template (ARM template) to deploy a new virtual network that has four subnets:

  - **AksSubnet** hosts the AKS cluster.
  - **VmSubnet** hosts a jumpbox virtual machine (VM) and private endpoints.
  - **AppGatewaySubnet** hosts Application Gateway WAF2 tier.
  - **AzureBastionSubnet** hosts Azure Bastion.

- The AKS cluster uses a user-defined managed identity to create more resources, such as load balancers and managed disks, in Azure. You can use the ARM template to deploy an AKS cluster that has the following features:

  - [Container Storage Interface (CSI) drivers for Azure disks and Azure Files](/azure/aks/csi-storage-drivers)
  - [AKS-managed Microsoft Entra integration](/azure/aks/managed-aad)
  - [Azure role-based access control (RBAC) for Kubernetes Authorization](/azure/aks/manage-azure-rbac)
  - [A managed identity in place of a service principal](/azure/aks/use-managed-identity)
  - [Microsoft Entra Workload ID](/azure/aks/workload-identity-overview)
  - [Azure network policies](/azure/aks/use-network-policies)
  - [Azure Monitor container insights add-on](/azure/azure-monitor/containers/container-insights-enable-new-cluster)
  - [AGIC add-on](https://azure.github.io/application-gateway-kubernetes-ingress/)
  - [Dynamic allocation of IP addresses and enhanced subnet support](/azure/aks/configure-azure-cni#dynamic-allocation-of-ips-and-enhanced-subnet-support-preview)

- The AKS cluster has the following node pools:

  - The **system node pool** hosts only critical system pods and services. The worker nodes have node taint that prevents application pods from being scheduled on this node pool.
  - The **user node pool** hosts user workloads and artifacts.

- A VM is deployed in the same virtual network that hosts the AKS cluster. When you deploy AKS as a private cluster, system administrators can use this VM to manage the cluster via the [Kubernetes command-line tool](https://kubernetes.io/docs/tasks/tools/). The boot diagnostics logs of the VM are stored in an Azure Storage account.

- An Azure Bastion host provides secure Secure Shell (SSH) connectivity to the jump box VM, directly in the Azure portal via Secure Sockets Layer (SSL). This solution uses Azure Container Registry to build, store, and manage container images and artifacts, such as Helm charts.

- The architecture includes an application gateway that the ingress controller uses. The application gateway is deployed to a dedicated subnet and exposed to the public internet via a public IP address that all tenant workloads share. A WAF policy helps protect tenant workloads from malicious attacks.

  The WAF policy is associated with the application gateway at the root level and at the HTTP listener level. The policy is configured in prevention mode and uses [OWASP 3.1](https://owasp.org/www-project-application-security-verification-standard) to block intrusions and attacks that rules detect. The attacker receives a *403 unauthorized access* exception, and the connection is closed. Prevention mode records these attacks in the WAF logs.

- Workloads that run on AKS use a key vault as a secret store to retrieve keys, certificates, and secrets via a client library, [Secrets Store CSI Driver](/azure/aks/csi-secrets-store-driver), or [Dapr](https://docs.dapr.io/developing-applications/building-blocks/secrets/secrets-overview). [Azure Private Link](/azure/private-link/private-link-overview) enables AKS workloads to access Azure platform as a service (PaaS) solutions, such as Azure Key Vault, over a private endpoint in the virtual network.

- This architecture includes private endpoints to the following components:

  - The Azure Blob Storage account
  - Container Registry
  - Key Vault
  - The API server of the Kubernetes cluster, if you use a private AKS cluster

- The architecture also includes private DNS zones to resolve the fully qualified domain name (FQDN) of a PaaS service to the private IP address of its associated private endpoint. This architecture includes private DNS zones to resolve the private endpoints to the following components:

  - The Blob Storage account
  - Container Registry
  - Key Vault
  - The Kubernetes Server API, if you deploy the cluster as private

- A virtual network link exists between the virtual network that hosts the AKS cluster and the preceding private DNS zones. A Log Analytics workspace collects the diagnostics logs and metrics from the following sources:

  - The AKS cluster
  - The jumpbox VM
  - Application Gateway
  - Key Vault
  - Azure network security groups

### Components

- [Container Registry](/azure/container-registry/container-registry-intro) is a managed, private Docker registry service that's based on the open-source Docker Registry 2.0. You can use Azure container registries with your existing container development and deployment pipelines. Or use Container Registry tasks to build container images in Azure. You can build on demand or fully automate builds with triggers, such as source code commits and base image updates.

- [AKS](/azure/well-architected/service-guides/azure-kubernetes-service) simplifies the deployment of a managed Kubernetes cluster in Azure by offloading the operational overhead to Azure. As a hosted Kubernetes service, Azure handles critical tasks, like health monitoring and maintenance. Azure manages Kubernetes control plane nodes, so you only manage and maintain the agent nodes.

- [Key Vault](/azure/key-vault/general/overview/) helps securely store and control access to secrets, like API keys, passwords, certificates, and cryptographic keys. You can use Key Vault to easily provision, manage, and deploy public and private Transport Layer Security (TLS) or SSL certificates, and use them with Azure and your internal connected resources.

- [Application Gateway](/azure/well-architected/service-guides/azure-application-gateway) is a web traffic load balancer that you can use to manage inbound traffic that goes to downstream web applications and REST APIs. Traditional load balancers operate at the transport layer, which is Open Systems Interconnection (OSI) layer 4, to handle traffic that uses Transmission Control Protocol (TCP) and User Datagram Protocol (UDP). They route traffic based on the source IP address and port to a destination IP address and port. An application gateway is a load balancer at the application layer, which is OSI layer 7.

- [WAF](/azure/application-gateway/waf-overview) is a service that helps provide centralized protection of web applications from common exploits and vulnerabilities. WAF is based on rules from the [OWASP CRS](https://owasp.org/www-project-modsecurity-core-rule-set). You can use WAF to create custom rules that are evaluated for each request that passes through a policy. These rules hold a higher priority than the rest of the rules in the managed rule sets. The custom rules contain a rule name, rule priority, and an array of matching conditions. If the request meets these conditions, WAF allows or blocks the request based on the rule.

- [Azure Bastion](/azure/bastion/bastion-overview) is a fully managed PaaS that you provision inside your virtual network. Azure Bastion provides Remote Desktop Protocol (RDP) and SSH connectivity to the VMs in your virtual network, directly from the Azure portal over TLS.

- [Azure Virtual Machines](/azure/well-architected/service-guides/virtual-machines) provides on-demand, scalable computing resources that give you the flexibility of virtualization without having to buy and maintain the physical hardware.

- [Azure Virtual Network](/azure/well-architected/service-guides/virtual-network) is the fundamental building block for Azure private networks. With Virtual Network, Azure resources, like VMs, can communicate with each other, the internet, and on-premises networks in a more secure manner. An Azure virtual network is similar to a traditional network that's on-premises, but it includes Azure infrastructure benefits, such as scalability, availability, and isolation.

- [Virtual network interfaces](/azure/virtual-network/virtual-network-network-interface) help establish communication between Azure VMs and the internet, Azure, and on-premises resources. You can add several network interface cards to one Azure VM so that child VMs can have their own dedicated network interface devices and IP addresses.

- [Azure managed disks](/azure/virtual-machines/windows/managed-disks-overview) are block-level storage volumes that Azure manages on Azure VMs. The disk types include Azure Ultra Disk Storage, Azure Premium SSD, and Azure Standard SSD.

- [Blob Storage](/azure/well-architected/service-guides/azure-blob-storage) is a Microsoft object storage solution for the cloud. Blob Storage is optimized for storing massive amounts of unstructured data. Unstructured data is data that doesn't adhere to a particular data model or definition, such as text data or binary data.

- [Private Link](/azure/private-link/private-link-overview) provides a private endpoint in your virtual network so that you can access Azure PaaS services, such as Blob Storage and Key Vault, and access Azure-hosted, customer-owned services or partner services.

### Alternatives

When you expose workloads that you host in an AKS cluster, you have several solutions to consider. Instead of using the AGIC, you can use [Application Gateway for Containers](/azure/application-gateway/for-containers/overview) or [managed NGINX ingress with the application routing add-on](/azure/aks/app-routing). These alternatives provide different capabilities to help manage and secure traffic to your AKS cluster.

This architecture installs the [AGIC](https://azure.github.io/application-gateway-kubernetes-ingress) via the [AGIC add-on for AKS](/azure/application-gateway/tutorial-ingress-controller-add-on-new). You can also [install the AGIC via a Helm chart](/azure/application-gateway/ingress-controller-install-existing#install-ingress-controller-as-a-helm-chart). When you create a new setup, you can use one line in the Azure CLI to deploy a new application gateway and a new AKS cluster. This method enables AGIC as an add-on. The add-on is a fully managed service, which provides added benefits, such as automatic updates and increased support. It's also considered a first-class add-on, which provides better integration with AKS. Microsoft supports both deployment methods for the AGIC.

The AGIC add-on is deployed as a pod in your AKS cluster. But there are a few differences between the Helm deployment version and the add-on version of the AGIC. The following list includes the differences between the two versions:

- You can't modify Helm deployment values on the AKS add-on:

  - The `usePrivateIp` property is set to `false` by default. You can't overwrite this value via the `use-private-ip` annotation.
  - The add-on doesn't support the `shared` configuration option.

- The Helm-deployed AGIC supports `ProhibitedTargets`, which means that the AGIC can configure the application gateway specifically for AKS clusters without affecting other existing back ends.
- The AGIC add-on is a managed service, so it automatically updates to the latest version. If you deploy the AGIC via Helm, you must manually update the AGIC.
- You can only deploy one AGIC add-on for each AKS cluster. Each AGIC add-on can only target one Application Gateway instance. For deployments that require more than one AGIC for each cluster, or multiple AGICs that target one Application Gateway instance, you can use the Helm-deployed AGIC.

A single instance of the AGIC can ingest events from multiple Kubernetes namespaces. If the AKS administrator uses the application gateway as an ingress, all namespaces use the same instance of Application Gateway. A single installation of the AGIC monitors accessible namespaces and configures the application gateway that it's associated with. For more information, see [Enable multiple-namespace support in an AKS cluster with the AGIC](/azure/application-gateway/ingress-controller-multiple-namespace-support).

To enable multiple-namespace support, do the following steps:

1. Modify the [helm-config.yaml](/azure/application-gateway/ingress-controller-multiple-namespace-support#sample-helm-configuration-file) file in one of the following ways:

  - Delete the `watchNamespace` key entirely from the [helm-config.yaml](/azure/application-gateway/ingress-controller-multiple-namespace-support#sample-helm-config-file) file to let the AGIC observe all the namespaces.
  - Set `watchNamespace` to an empty string to let the AGIC observe all namespaces.
  - Add multiple namespaces separated by a comma, such as `watchNamespace: default,secondNamespace`, to let the AGIC observe these namespaces exclusively.

2. Apply Helm template changes with this script: `helm install -f helm-config.yaml application-gateway-kubernetes-ingress/ingress-azure`.

After you deploy the AGIC with the ability to observe multiple namespaces, the AGIC does the following actions:

1. Lists ingress resources from all the accessible namespaces
1. Filters ingress resources that are annotated with `kubernetes.io/ingress.class: azure/application-gateway`
1. Composes the combined [Application Gateway configuration](https://github.com/Azure/azure-sdk-for-go/blob/37f3f4162dfce955ef5225ead57216cf8c1b2c70/services/network/mgmt/2016-06-01/network/models.go#L1710-L1744)
1. Applies the configuration to the associated application gateway via [Azure Resource Manager](/azure/azure-resource-manager/management/overview)

## Scenario details

This architecture shares a multitenant Kubernetes cluster among multiple users and workloads that are commonly referred to as *tenants*. This definition includes different teams or divisions within an organization that share Kubernetes clusters. It also includes clusters that are shared by per-customer instances of a software as a service (SaaS) application. Cluster multitenancy is an alternative to managing many single-tenant dedicated clusters. The operators of a multitenant Kubernetes cluster must isolate tenants from each other. This isolation minimizes the damage that a compromised or malicious tenant can do to the cluster and to other tenants. When several users or teams share the same cluster that has a fixed number of nodes, one team might use more resources than they need. Administrators can use [resource quotas](https://kubernetes.io/docs/concepts/policy/resource-quotas) to address this concern.

When you plan to build a multitenant AKS cluster, you should consider the layers of resource isolation that Kubernetes provides, including cluster, namespace, node, pod, and container isolation. You should also consider the security implications of sharing different types of resources among multiple tenants. For example, if you schedule pods from different tenants on the same node, you can reduce the number of machines that you need in the cluster. On the other hand, you might need to prevent certain workloads from being colocated. For example, you might not allow untrusted code from outside your organization to run on the same node as containers that process sensitive information. You can use [Azure Policy](/azure/aks/policy-reference) so that only trusted registries can deploy to AKS.

Kubernetes can't guarantee perfectly secure isolation between tenants, but it does offer features that provide sufficient security for specific use cases. As a best practice, you should separate each tenant and its Kubernetes resources into their own namespaces. You can then use [Kubernetes RBAC](https://kubernetes.io/docs/reference/access-authn-authz/rbac) and [network policies](https://kubernetes.io/docs/concepts/services-networking/network-policies/) to help enforce tenant isolation. For example, the following diagram shows a typical SaaS provider model that hosts multiple instances of the same application on the same cluster, one for each tenant. Each application is in a separate namespace. When tenants need a higher level of physical isolation and guaranteed performance, their workloads can be deployed to a dedicated set of nodes, a dedicated pool, or even a dedicated cluster.

:::image type="content" border="false" source="./media/aks-agic-multitenancy.svg" alt-text="Diagram that shows a multitenancy example." lightbox="./media/aks-agic-multitenancy.svg":::

The [AGIC](/azure/application-gateway/ingress-controller-overview) is a Kubernetes application, so [AKS](/azure/aks/intro-kubernetes) customers can use an [application gateway](/azure/application-gateway/overview) to expose their containerized applications to the internet. The AGIC monitors the Kubernetes cluster that it's hosted on and continuously updates an application gateway so that the selected services are exposed to the internet. The AGIC runs in its own pod on the customer's AKS instance. The AGIC monitors a subset of Kubernetes resources for changes. The state of the AKS cluster is translated to Application Gateway-specific configuration and applied to [Resource Manager](/azure/azure-resource-manager/management/overview). This architecture describes proven practices to deploy a public or private [AKS cluster](/azure/aks/intro-kubernetes) via an [application gateway](/azure/application-gateway/overview) and an [AGIC](/azure/application-gateway/ingress-controller-overview) add-on.

A single instance of the [AGIC](/azure/application-gateway/ingress-controller-multiple-namespace-support) can ingest events from and observe multiple namespaces. If the AKS administrator uses Application Gateway as an ingress, all namespaces use the same instance of Application Gateway. A single installation of AGIC monitors accessible namespaces and configures the application gateway that it's associated with.

### Potential use cases

Use the [AGIC](/azure/application-gateway/ingress-controller-overview) to expose and protect internet-facing workloads that run on an [AKS cluster](/azure/aks/intro-kubernetes) in a multitenant environment.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).

Some of these considerations don't fully pertain to multitenancy in AKS, but they're essential requirements of this solution. These considerations include security, performance, availability, reliability, storage, scheduler, service mesh, and monitoring guidance.

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

These availability and reliability considerations don't fully pertain to multitenancy in AKS, but they're essential requirements of this solution. Consider the following ways to optimize availability for your AKS cluster and workloads.

#### Containers

- Use Kubernetes health probes to check that your containers are alive and healthy:

  - The [livenessProbe](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/#define-a-liveness-command) indicates whether the container is running. If the liveness probe fails, the [kubelet](https://kubernetes.io/docs/reference/command-line-tools-reference/kubelet) terminates the container, and the container is subjected to its restart policy.

  - The [readinessProbe](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/#define-readiness-probes) indicates whether the container is ready to respond to requests. If the readiness probe fails, the endpoint controller removes the pod's IP address from the endpoints of all services that match the pod. The default state of readiness before the initial delay is *failure*.
  - The [startupProbe](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/#define-startup-probes) indicates whether the application within the container is started. If you have a startup probe, all other probes are disabled until the startup probe succeeds. If the startup probe fails, the [kubelet](https://kubernetes.io/docs/reference/command-line-tools-reference/kubelet) terminates the container, and the container is subjected to its restart policy.

- Resource contention can affect service availability. Define container resource constraints so that no single container can overwhelm the cluster memory and CPU resources. You can use AKS diagnostics to identify any problems in the cluster.
- Use the resource limit to restrict the total resources allocated to a container so that one container can't deprive others.

#### Container Registry

- Store container images in Container Registry. Use [Container Registry geo-replication](/azure/container-registry/container-registry-geo-replication) to geo-replicate the registry to each AKS region. Geo-replication is a feature of Premium SKU Container Registry.

- Scan your container images for vulnerabilities. Only deploy images that pass validation. Regularly update the base images and application runtime, and then redeploy your workloads in the AKS cluster.
- Limit the image registries that pods and deployments can use. Restrict access to trusted registries where you can validate and control the images that are available.
- Scan container images for vulnerabilities as part of a continuous integration and continuous delivery (CI/CD) pipeline before you publish images to Container Registry. As you use base images for application images, use automation to build new images when you update the base image. The base images typically include security fixes, so you must update any downstream application container images. We recommend that you integrate [Microsoft Defender for Containers](/azure/defender-for-cloud/defender-for-containers-introduction) into CI/CD workflows. For more information, see [Automate container image builds](/azure/container-registry/container-registry-tutorial-base-image-update).
- Use [Container Registry tasks](/azure/container-registry/container-registry-tasks-overview) to automate OS and framework patching for your Docker containers. Container Registry tasks support an automated build process when you update a container's base image. For example, you might patch the OS or application framework in one of your base images.

#### Intra-region resiliency

- Consider deploying the node pools of your AKS cluster across all the [availability zones](/azure/aks/availability-zones) within a region. Use [Azure Standard Load Balancer](/azure/load-balancer/load-balancer-overview) or [Application Gateway](/azure/application-gateway/overview) in front of your node pools. This topology provides better resiliency if a single datacenter outage occurs. This method distributes cluster nodes across multiple datacenters that reside in three separate availability zones within a region.

- Enable [zone redundancy in Container Registry](/azure/container-registry/zone-redundancy) for intra-region resiliency and high availability.
- Use [pod topology spread constraints](https://kubernetes.io/docs/concepts/workloads/pods/pod-topology-spread-constraints) to control how you spread pods across your AKS cluster among failure domains, such as regions, availability zones, and nodes.
- Consider using an uptime service-level agreement (SLA) for AKS clusters that host mission-critical workloads. An [uptime SLA](/azure/aks/uptime-sla) is an optional feature to enable a financially backed, higher SLA for a cluster. An uptime SLA guarantees 99.95% availability of the Kubernetes API server endpoint for clusters that use availability zones. It guarantees 99.90% availability for clusters that don't use availability zones. AKS uses control plane node replicas across update and fault domains to help meet SLA requirements.

#### Disaster recovery and business continuity

- Consider deploying your solution to at least [two paired Azure regions](/azure/best-practices-availability-paired-regions) within a geography. You should also adopt a global load balancer, such as [Azure Traffic Manager](/azure/traffic-manager/traffic-manager-overview) or [Azure Front Door](/azure/frontdoor/front-door-overview). Combine the load balancer with an active/active or active/passive routing method to help guarantee business continuity and disaster recovery.

- Script, document, and periodically test any regional failover processes in a quality assurance environment. Failover processes help avoid unpredictable problems if an outage in the primary region affects a core service.
- Use failover-process tests to verify whether the disaster recovery approach meets the recovery point objective (RPO) and recovery time objective (RTO) targets. Include manual processes and interventions in your verification.
- Test fail-back procedures to ensure that they work as expected.
- Store your container images in [Container Registry](/azure/container-registry/container-registry-intro). Geo-replicate the registry to each AKS region. For more information, see [Geo-replication in Container Registry](/azure/container-registry/container-registry-geo-replication).
- Avoid storing service state inside a container, where possible. Instead, use an Azure PaaS that supports multiregion replication.
- Prepare and test how to migrate your storage from the primary region to the backup region if you use Azure Storage.
- Consider using [GitOps](/azure/architecture/example-scenario/gitops-aks/gitops-blueprint-aks) to deploy the cluster configuration. GitOps provides uniformity between the primary and disaster recovery clusters and also provides a quick way to rebuild a new cluster if you lose one.
- Consider backup and restore of the cluster configuration by using tools, such as [AKS backup](/azure/backup/azure-kubernetes-service-backup-overview) or [Velero](https://github.com/vmware-tanzu/velero).

#### Service mesh

- Consider using an open-source service mesh, like [Istio](https://istio.io), [Linkerd](https://linkerd.io), or [Consul](https://www.consul.io), in your AKS cluster. A service mesh uses mutual TLS to help improve observability, reliability, and security for your microservices. You can also implement traffic-splitting strategies, such blue/green deployments and canary deployments. A service mesh is a dedicated infrastructure layer that helps make service-to-service communication more safe, fast, and reliable. For more information, see [Istio service mesh AKS add-on](/azure/aks/istio-about).

- Consider adopting [Dapr](https://dapr.io) to build resilient microservice-based applications, whether they're stateless and stateful. You can use any programming language and developer framework.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

The security considerations don't fully pertain to multitenancy in AKS, but they're essential requirements of this solution.

#### Multitenancy

- Design AKS clusters for multitenancy. Kubernetes provides features that you can use to logically isolate teams and workloads in the same cluster. Provide the least number of privileges to the resources that each team needs. A [namespace](/azure/aks/concepts-clusters-workloads#namespaces) in Kubernetes creates a logical isolation boundary.

- Use logical isolation to separate teams and projects. Minimize the number of physical AKS clusters that you deploy to isolate teams or applications. The logical separation of clusters usually provides a higher pod density than physically isolated clusters.
- Use dedicated node pools, or dedicated AKS clusters, whenever you need to implement a strict physical isolation. For example, you can dedicate a pool of worker nodes or an entire cluster to a team or a tenant in a multitenant environment.

   Use a combination of [taints and tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) to control the deployment of pods to a specific node pool. You can only taint a node in AKS at the time of node pool creation. Alternatively, you can use [labels and nodePool selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/) to deploy the workload to specific node pools only.

#### Network security

- Create a [private endpoint](/azure/private-link/private-endpoint-overview) for any PaaS service that your AKS workloads use, such as Key Vault, Azure Service Bus, or Azure SQL Database. A private endpoint helps ensure that the traffic between the applications and these services isn't exposed to the public internet. For more information, see [What is Private Link](/azure/private-link/private-link-overview).

- Configure your Kubernetes ingress resource to expose workloads via HTTPS. Use a separate subdomain and digital certificate for each tenant. The [AGIC](/azure/application-gateway/ingress-controller-overview) automatically configures the [Application Gateway](/azure/application-gateway/overview) listener for SSL termination.
- Configure [Application Gateway](/azure/application-gateway/overview) to use a [WAF policy](/azure/application-gateway/waf-overview) to help protect public-facing workloads that run on AKS from malicious attacks.
- Use Azure CNI networking in AKS to integrate with existing virtual networks or on-premises networks. This network model also allows greater separation of resources and controls in an enterprise environment.
- Use network policies to segregate and secure intra-service communications by controlling which components can communicate with each other. By default, all pods in a Kubernetes cluster can send and receive traffic without limitations. To improve security, you can use Azure network policies or Calico network policies to define rules that control the traffic flow between various microservices. For more information, see [Network policy](/azure/aks/use-network-policies).
- Don't expose remote connectivity to your AKS nodes. Create a bastion host, or jumpbox, in a management virtual network. Use the bastion host to securely route traffic into your AKS cluster to remote management tasks.
- Consider using [authorized IP address ranges](/azure/aks/api-server-authorized-ip-ranges) in AKS to create a [private AKS cluster](/azure/aks/private-clusters) in your production environment. If you can't use a private AKS cluster, at least secure access to the API server.
- Combine [Azure DDoS Protection](/azure/ddos-protection/ddos-protection-overview) with application-design best practices to provide enhanced DDoS mitigation features and extra defense against DDoS attacks. Enable [DDoS Protection](/azure/ddos-protection/ddos-protection-overview) on perimeter virtual networks.

#### Authentication and authorization

- Deploy AKS clusters with Microsoft Entra integration. For more information, see [AKS-managed Microsoft Entra integration](/azure/aks/managed-aad). Microsoft Entra ID centralizes the identity management component.

- Use Kubernetes RBAC to define the permissions that users or groups have to resources in the cluster. Use [roles](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#role-and-clusterrole) or [ClusterRoles](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#role-and-clusterrole) and [bindings](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#rolebinding-and-clusterrolebinding) to scope users or groups to the least number of permissions needed. [Integrate Kubernetes RBAC with Microsoft Entra ID](/azure/aks/azure-ad-rbac) so that any change in user status or group membership automatically updates the access to cluster resources. For more information, see [Kubernetes RBAC](/azure/aks/operator-best-practices-identity#use-kubernetes-role-based-access-control-kubernetes-rbac).
- Use Azure RBAC to define the minimum required permissions that users or groups have to AKS resources in one or more subscriptions. For more information, see [Use Azure RBAC for Kubernetes Authorization](/azure/aks/manage-azure-rbac).
- Use [Microsoft Entra Workload ID](/azure/aks/workload-identity-overview) to assign a managed identity to individual microservices for Azure resource access. The microservice can then access managed resources, such as Key Vault, SQL Database, Service Bus, and Azure Cosmos DB. The microservice doesn't need to store and retrieve connection strings or credentials from Kubernetes secrets.
- Use the [Secrets Store CSI Driver for Key Vault](/azure/key-vault/general/key-vault-integrate-kubernetes) to access secrets, such as credentials and connections string, from Key Vault rather than from Kubernetes secrets.
- Combine the [Dapr secret store](https://docs.dapr.io/developing-applications/building-blocks/secrets/secrets-overview/) building block with the [Key Vault store and managed identities on Kubernetes](https://docs.dapr.io/developing-applications/integrations/azure/azure-authentication/authenticating-azure/) to retrieve secrets, such as credentials and connection strings, from Key Vault.

#### Workload and cluster

- Secure access to the Kubernetes API server to help secure your cluster. Integrate Kubernetes RBAC with Microsoft Entra ID to control access to the API server. Use these controls to help secure AKS the same way that you do for Azure subscription access.

- Limit access to actions that containers can perform. Use the [Pod Security Admission feature](https://kubernetes.io/docs/concepts/security/pod-security-admission/) to enable the fine-grained authorization of pod creation and updates. Provide the least number of permissions, and avoid the use of root or privileged escalation. For more information, see [Secure pod access to resources](/azure/aks/developer-best-practices-pod-security#secure-pod-access-to-resources).
- Avoid running containers as a root user whenever possible.
- Use the [AppArmor](https://kubernetes.io/docs/tutorials/clusters/apparmor) Linux kernel security module to limit the actions that containers can do.
- Upgrade your AKS clusters to the latest Kubernetes version regularly to take advantage of new features and bug fixes.
- Use the [kured](https://kured.dev/) daemonset to watch for pending reboots, cordon and drain nodes, and apply updates. AKS automatically downloads and installs security fixes on each Linux node, but it doesn't automatically reboot the node if necessary. For Windows Server nodes, regularly run an AKS upgrade operation to safely cordon and drain pods and to deploy any updated nodes.
- Consider using HTTPS and gRPC secure transport protocols for all intra-pod communications. And use a more advanced authentication mechanism that doesn't require you to send the plain credentials on every request, like Open Authorization (OAuth) or JSON Web Tokens (JWTs). Establish more secure intra-service communication by using a service mesh, like [Istio](https://istio.io/), [Linkerd](https://linkerd.io), or [Consul](https://www.consul.io). Or you can use [Dapr](https://docs.dapr.io/developing-applications/building-blocks/service-invocation/service-invocation-overview).

#### Container Registry

Scan your container images for vulnerabilities, and only deploy images that pass validation. Regularly update the base images and application runtime. Then redeploy workloads in the AKS cluster. Your CI/CD deployment workflow should include a process to scan container images. You can use [Microsoft Defender for DevOps security](/azure/defender-for-cloud/defender-for-containers-cicd) to scan code for vulnerabilities in your automated pipelines during the build and deploy phases. Alternatively, you can use tools such as [Prisma Cloud](https://www.paloaltonetworks.com/prisma/cloud) or [Aqua](https://www.aquasec.com) to scan and allow only verified images to be deployed.

### Cost Optimization

Cost Optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

The cost of this architecture depends on configuration aspects, such as the following components:

- Service tiers
- Scalability, or the number of instances that services dynamically allocate to support a given demand
- Automation scripts
- Your disaster recovery level

After you assess these aspects, use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate your costs. For more information, see the [Well-Architected Framework principles of Cost Optimization](/azure/architecture/framework/cost/overview).

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

#### Storage

- Consider deploying your AKS cluster with [ephemeral OS disks](/azure/aks/concepts-storage#ephemeral-os-disk) that provide lower read and write latency, along with faster node scaling and cluster upgrades.

- Understand the needs of your application to choose the right storage. Use high-performance, SSD-backed storage for production workloads. Plan for a network-based storage system, such as [Azure Files](/azure/storage/files/storage-files-introduction), when multiple pods need to concurrently access the same files. For more information, see [Storage options for applications in AKS](/azure/aks/concepts-storage).
- Plan for your application demands so that you deploy the appropriate size of nodes. Each node size supports a maximum number of disks. Different node sizes also provide different amounts of local storage and network bandwidth.
- Use dynamic provisioning. To reduce management overhead and enable scaling, don't statically create and assign persistent volumes. In your storage classes, define the appropriate reclaim policy to minimize unnecessary storage costs after you delete pods.

#### DevOps

- Use a DevOps system, such as [GitHub Actions](https://docs.github.com/actions) or [Azure DevOps](https://azure.microsoft.com/services/devops), to deploy your workloads to AKS via a [Helm](https://helm.sh) chart in a CI/CD pipeline. For more information, see [Build and deploy to AKS](/azure/devops/pipelines/ecosystems/kubernetes/aks-template).

- Introduce A/B testing and canary deployments in your application lifecycle management to properly test an application before you introduce it to all users. There are several techniques that you can use to split the traffic across different versions of the same service.
- As an alternative, you can use the traffic-management capabilities that a service mesh provides. For more information, see [Istio traffic management](https://istio.io/latest/docs/concepts/traffic-management/).

- Use Container Registry or another registry store, like Docker Hub, to catalog and serve the private Docker images that you deploy to the cluster. AKS can use its Microsoft Entra identity to authenticate with Container Registry.
- If you need to change settings on Application Gateway, make the change by using the exposed configuration on the ingress controller or other Kubernetes objects, such as using supported annotations. After you link an application gateway to the AGIC, the ingress controller synchronizes and controls nearly all configurations of that gateway. If you directly configure Application Gateway imperatively or through infrastructure as code, the ingress controller eventually overwrites those changes.

#### Monitoring

- Consider Azure-integrated [monitoring options](/azure/aks/monitor-aks) to monitor the health status of the AKS cluster and workloads.

- Configure all the PaaS services, such as Container Registry and Key Vault, to collect diagnostics logs and metrics and send them to [Log Analytics](/azure/azure-monitor/logs/log-analytics-overview).

### Performance Efficiency

Performance Efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

The performance considerations don't fully pertain to multitenancy in  AKS, but they're essential requirements of this solution:

- For low-latency workloads, consider deploying a dedicated node pool in a proximity placement group. When you deploy your application in Azure, VM instances that are spread across regions or availability zones create network latency, which might affect the overall performance of your application. A proximity placement group is a logical grouping that you can use to make sure Azure compute resources are physically located close to each other. Some use cases, such as gaming, engineering simulations, and high-frequency trading, require low latency and tasks that complete quickly. For high-performance computing scenarios such as these, consider using [proximity placement groups](/azure/virtual-machines/co-location#proximity-placement-groups) for your cluster's node pools.

- Always use smaller container images because you can create faster builds. Smaller images are also less vulnerable to attack vectors because of a reduced attack surface.
- Use Kubernetes autoscaling to dynamically scale out the number of worker nodes in an AKS cluster when traffic increases. With the [Horizontal Pod Autoscaler](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale) and a cluster autoscaler, node and pod volumes get adjusted dynamically in real time to match the traffic condition and to avoid downtimes that capacity problems cause. For more information, see [Use the cluster autoscaler in AKS](/azure/aks/cluster-autoscaler).

#### Scheduler

- Review and implement [best practices](/azure/aks/best-practices) for cluster operators and application developers to build and run applications successfully on AKS.

- Plan and apply [resource quotas](https://kubernetes.io/docs/concepts/policy/resource-quotas) at the namespace level for all namespaces. If pods don't define resource requests and limits, then reject the deployment. Monitor resource usage, and then adjust quotas as needed. When several teams or tenants share an AKS cluster that has a fixed number of nodes, you can use resource quotas to assign a fair share of resources to each team or tenant.
- Adopt [limit ranges](https://kubernetes.io/docs/concepts/policy/limit-range) to constrain resource allocations to pods or containers in a namespace, in terms of CPU and memory.
- Define resource [requests and limits](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) explicitly for CPU and memory usage for your pods in the YAML manifests or Helm charts that you use to deploy applications. When you specify the resource request for containers in a pod, the Kubernetes scheduler uses this information to decide which node to place the pod on. When you specify a resource limit for a container, such as the CPU or memory, the kubelet enforces those limits so that the running container can't use more of that resource than the limit you set.
- Maintain the availability of applications by defining [pod disruption budgets](https://kubernetes.io/docs/tasks/run-application/configure-pdb) to make sure that a minimum number of pods are available in the cluster.
- Use [priority classes](https://kubernetes.io/docs/concepts/configuration/pod-priority-preemption) to indicate the importance of a pod. If the scheduler can't schedule a pod, it tries to preempt, or evict, lower-priority pods so it can schedule the pending pod.
- Use Kubernetes [taints and tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) to place resource-intensive applications on specific nodes and to avoid noisy neighbor problems. Keep node resources available for workloads that require them. Don't allow other workloads to be scheduled on the nodes.
- Use node selectors, node affinity, or inter-pod affinity to control the scheduling of pods on nodes. Use inter-pod [affinity and anti-affinity](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#affinity-and-anti-affinity) settings to colocate pods that have chatty communications, to place pods on different nodes, and to avoid running multiple instances of the same kind of pod on the same node.

## Deploy this scenario

The source code for this scenario is available on [GitHub](https://github.com/Azure-Samples/aks-agic). The following diagram shows a demo application that you can find in the [AKS multitenant AGIC GitHub repository](https://github.com/Azure-Samples/aks-multi-tenant-agic).

:::image type="content" border="false" source="./media/aks-agic-sample.svg" alt-text="Diagram that shows the deployment of this AGIC with AKS architecture." lightbox="./media/aks-agic-sample.svg":::

*Download a [Visio file](https://arch-center.azureedge.net/aks-agic-multitenant.vsdx) of this architecture.*

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Paolo Salvatori](https://www.linkedin.com/in/paolo-salvatori) | Principal Service Engineer

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [AKS cluster best practices](/Azure/aks/best-practices?toc=/azure/architecture/toc.json&bc=/azure/architecture/_bread/toc.json)
- [Best practices for basic scheduler features in AKS](/azure/aks/operator-best-practices-scheduler)
- [Create a private AKS cluster](https://github.com/azure-samples/private-aks-cluster)
- [Create WAF policies for Application Gateway](/azure/web-application-firewall/ag/create-waf-policy-ag#migrate-to-waf-policy)
- [Difference between a Helm deployment and the AKS add-on](/azure/application-gateway/ingress-controller-overview#difference-between-helm-deployment-and-aks-add-on)
- [How an application gateway works](/azure/application-gateway/how-application-gateway-works)

## Related resources

- [Baseline architecture for an AKS cluster](../../reference-architectures/containers/aks/baseline-aks.yml)
