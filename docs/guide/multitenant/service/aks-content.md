[Kubernetes](https://kubernetes.io/docs/concepts/overview/what-is-kubernetes/) is an extensible, open-source platform for managing containerized applications and and their associated networking and storage components. Kubernetes focuses on the application workloads, not the underlying infrastructure components. Kubernetes provides a declarative approach to deployments, backed by a robust set of APIs for management operations. Kubernetes has a large and rapidly growing ecosystem. Kubernetes services, support, and tools are widely available. The [Cloud Native Computing Foundation](https://www.cncf.io/) (CNCF) owns and maintains the Kubernetes project.

You can build and run modern, portable, containerized and microservices-based applications, using Kubernetes to orchestrate and manage the availability of the application components. Kubernetes supports both stateless and stateful applications as teams progress through the adoption of microservices-based applications.

As an open platform, Kubernetes allows you to build your applications with your preferred programming language, OS, libraries, or messaging bus. Existing continuous integration and continuous delivery (CI/CD) tools can integrate with Kubernetes to schedule and deploy releases.

[Azure Kubernetes Service](/azure/aks/intro-kubernetes) (AKS) simplifies deploying a managed Kubernetes cluster in Azure by offloading the operational overhead to the Azure cloud platform. As a hosted Kubernetes service, Azure handles critical tasks, like health monitoring and maintenance. The Azure platform manages the AKS control plane, and you only pay for the AKS nodes that run your applications.

## Features of Azure Kubernetes Service (AKS) that support multitenancy

AKS clusters can be shared across multiple tenants in different scenarios and ways. In some cases, diverse applications can run in the same cluster, while in other cases, multiple instances of the same application can run in the same shared cluster, one for each tenant. All these types of sharing are frequently described using the umbrella term multitenancy. Kubernetes does not have a first-class concept of end-users or tenants. Still, it provides several features to help you manage different tenancy requirements.

### Multitenancy types

The first step to determining how to share an AKS cluster across multiple tenants is understanding your scenario to evaluate the patterns and tools at your disposal. In general, multitenancy in Kubernetes clusters falls into two main categories, though many variations are still possible.

#### Multiple teams

A common form of multitenancy is to share a cluster between multiple teams within an organization, each of whom can deploy, monitor, and operate one or more solutions. These workloads frequently need to communicate with each other and with other internal or external applications located on the same cluster or other hosting platforms.
In addition, these workloads need to communicate with services such as a relational database, a NoSQL repository, or a messaging system hosted in the same cluster or running as PaaS services on Azure.
In this scenario, members of the teams often have direct access to Kubernetes resources via tools such as [kubectl](https://kubernetes.io/docs/reference/kubectl/), or indirect access through GitOps controllers, such as [Flux](https://fluxcd.io/) and [Argo CD](https://argo-cd.readthedocs.io/en/stable/), or other types of release automation tools. There is often some level of trust between members of different teams, but Kubernetes policies such as RBAC, [resource quotas](https://kubernetes.io/docs/concepts/policy/resource-quotas/), and [network policies](https://kubernetes.io/docs/concepts/services-networking/network-policies/) are essential to safely and fairly share clusters.

#### Multiple customers

Another common form of multitenancy frequently involves a Software-as-a-Service (SaaS) vendor or a service provider running multiple instances of a workload for their customers. In this scenario, the customers do not have direct access to the AKS cluster but only to their application. More, they don't even know that their application runs on Kubernetes. Cost optimization is frequently a critical concern, and service providers use Kubernetes policies such as [resource quotas](https://kubernetes.io/docs/concepts/policy/resource-quotas/) and [network policies](https://kubernetes.io/docs/concepts/services-networking/network-policies/) to ensure that the workloads are strongly isolated from each other.

## Azure Kubernetes Architecture

A [Kubernetes](/azure/aks/intro-kubernetes) cluster consists of a [control plane](https://kubernetes.io/docs/concepts/overview/components/#control-plane-components) that runs Kubernetes system services and a [data plane](https://kubernetes.io/docs/concepts/overview/components/#node-components) consisting of worker nodes where tenant workloads are executed as pods.

When you create an AKS cluster, a control plane is automatically created and configured. This control plane is provided at no cost as a managed Azure resource abstracted from the user. You only pay for the nodes attached to the AKS cluster. The control plane and its resources reside only on the region where you created the cluster. Likewise, an [Azure Kubernetes Service](/azure/aks/intro-kubernetes) cluster is composed of two components:

- [Control plane](/azure/aks/concepts-clusters-workloads#control-plane): provides the core Kubernetes services and orchestration of application workloads.
- [Agent nodes](/azure/aks/concepts-clusters-workloads#nodes-and-node-pools): agent nodes are Linux or Windows Azure virtual machines that run tenant workloads and Kubernetes node components such as [kubelet](https://kubernetes.io/docs/concepts/overview/components/#kubelet), [kube-proxy](https://kubernetes.io/docs/concepts/overview/components/#kube-proxy), and [container runtime](https://kubernetes.io/docs/concepts/overview/components/#container-runtime).

![Kubernetes control plane and node components](./media/aks/control-plane-and-nodes.png)

### Control plane

The control plane layer is automatically provisioned and configured whenever you deploy an AKS cluster. If you opt for the free tier, this is provided at no cost. Alternatively, you can create an AKS cluster with the Uptime SLA that enables a financially backed, higher SLA for the control plane. [Uptime SLA](/azure/aks/uptime-sla) is a paid feature and is enabled per cluster. Uptime SLA pricing is determined by the number of discrete clusters, and not by the size of the individual clusters. Clusters with Uptime SLA, also regarded as Paid tier in AKS REST APIs, come with greater amount of control plane resources and automatically scale to meet the load of your cluster. Uptime SLA guarantees 99.95% availability of the Kubernetes API server endpoint for clusters that use Availability Zones and 99.9% of availability for clusters that don't use Availability Zones. The control plane and its resources reside only on the region where you created the cluster.

The control plane includes the following core Kubernetes components:

| Component | Description |  
| ----------------- | ------------- |  
| *kube-apiserver*  | The API server is how the underlying Kubernetes APIs are exposed. This component provides the interaction for management tools, such as `kubectl` or the Kubernetes dashboard. |  
| *etcd* | To maintain the state of your Kubernetes cluster and configuration, the highly available *etcd* is a key value store within Kubernetes.                                      |  
| *kube-scheduler*  | When you create or scale applications, the Scheduler determines what nodes can run the workload and starts them.                                                                                    |  
| *kube-controller-manager* | The Controller Manager oversees a number of smaller Controllers that perform actions such as replicating pods and handling node operations.  |  

AKS provides a single-tenant control plane, with a dedicated API server that is shared by all the workloads running on the AKS cluster. For architectural best practices, see [Azure Well-Architected Framework review - Azure Kubernetes Service (AKS)][/azure/architecture/framework/services/compute/azure-kubernetes-service/azure-kubernetes-service].

### Nodes and node pools

To run your applications and supporting services, you need one or more Kubernetes *agent nodes*. An AKS cluster is composed of at least one node, an Azure virtual machine (VM) that runs the following [Kubernetes node components](https://kubernetes.io/docs/concepts/overview/components/#node-components).

| Component | Description |  
| ----------------- | ------------- |  
| `kubelet` | The Kubernetes agent that processes the orchestration requests from the control plane along with scheduling and running the requested containers. |  
| *kube-proxy* | Handles virtual networking on each node. The proxy routes network traffic and manages IP addressing for services and pods. |  
| *container runtime* | Allows containerized applications to run and interact with additional resources, such as the virtual network and storage. AKS clusters using Kubernetes version 1.19+ for Linux node pools use `containerd` as their container runtime. Beginning in Kubernetes version 1.20 for Windows node pools, `containerd` can be used in preview for the container runtime, but Docker is still the default container runtime. AKS clusters using prior versions of Kubernetes for node pools use Docker as their container runtime. |  

![Azure virtual machine and supporting resources for a Kubernetes node](./media/aks/aks-node-resource-interactions.png)

The Azure VM size for your nodes defines the storage CPUs, memory, size, and type available (such as high-performance SSD or regular HDD). Plan the node size around whether your applications may require large amounts of CPU and memory or high-performance storage. You can manually or automatically scale out the number of nodes in your AKS cluster to meet demand.

In AKS, the VM image for your cluster's nodes is based on Ubuntu Linux or Windows Server. When you create an AKS cluster or scale out the number of nodes, the Azure platform automatically creates and configures the requested number of VMs. Agent nodes are billed as standard VMs, so any VM size discounts (including [Azure reservations](/azure/cost-management-billing/reservations/save-compute-costs-reservations)) are automatically applied.

In Azure Kubernetes Service (AKS), nodes of the same configuration are grouped into [node pools](/azure/aks/use-multiple-node-pools). In an AKS cluster, you can create multiple node pools with different VM sizes for various purposes, tenants, and workloads and use taints and node labels to place applications on a specific node pool to avoid the [noisy neighbor issue](/azure/architecture/antipatterns/noisy-neighbor/noisy-neighbor). Using different VM sizes for different node pools allows you to optimize costs. For more information, see [Create and manage multiple node pools for a cluster in Azure Kubernetes Service (AKS)](/azure/aks/use-multiple-node-pools).

## Isolation models

A multitenant Kubernetes cluster is shared by multiple users and workloads that are commonly referred to as "tenants." This definition includes Kubernetes clusters that different teams or divisions share within an organization. It also contains clusters that are shared by per-customer instances of a software-as-a-service (SaaS) application. Cluster multitenancy is an alternative to managing many single-tenant dedicated clusters. The operators of a multitenant Kubernetes cluster must isolate tenants from each other. This isolation minimizes the damage that a compromised or malicious tenant can do to the cluster and to other tenants. When several users or teams share the same cluster with a fixed number of nodes, there is a concern that one team could use more than its fair share of resources. [Resource Quotas](https://kubernetes.io/docs/concepts/policy/resource-quotas) is a tool for administrators to address this concern.

When you plan to build a multitenant [Azure Kubernetes Service](/azure/aks/intro-kubernetes) (AKS) cluster, you should consider the layers of resource isolation and multitenancy provided by [Kubernetes](https://kubernetes.io/docs/concepts/security/multi-tenancy/): cluster, namespace, node, pod, and container. In addition, you should consider the security implications of sharing different resources among multiple tenants. For example, scheduling pods from different tenants on the same node could reduce the number of machines needed in the cluster. On the other hand, you might need to prevent specific workloads from being colocated. For example, you might not allow untrusted code from outside your organization to run on the same node as containers that process sensitive information.

Although Kubernetes cannot guarantee perfectly secure isolation between tenants, it does offer features that may be sufficient for specific use cases. As a best practice, you should separate each tenant and its Kubernetes resources into their namespaces. You can then use [Kubernetes role-based access control](https://kubernetes.io/docs/reference/access-authn-authz/rbac) (RBAC) and [Network Policies](https://kubernetes.io/docs/concepts/services-networking/network-policies/) to enforce tenant isolation. For example, the following picture shows the typical SaaS Provider Model that hosts multiple instances of the same application on the same cluster, one for each tenant. Each application lives in a separate namespace.

![Multitenancy](./media/aks/namespaces.png)

There are several ways to design and build multitenant solutions with [Azure Kubernetes Service](/azure/aks/intro-kubernetes) (AKS). Each of these methods comes with its own set of tradeoffs in terms of infrastructure deployment, network topology, and security that impact the isolation level, implementation effort, operational complexity, and cost. You can apply tenant isolation in the control and data planes based on your requirements.

## Control plane isolation

Isolation at the control plane level guarantees that different tenants cannot access or affect each others' resources, such as pods and services, and cannot impact the performance of other tenants' applications.

### Namespaces

In Kubernetes, a [namespace](https://kubernetes.io/docs/reference/glossary/?fundamental=true#term-namespace) is an abstraction used to support isolation of groups of resources within a single cluster. This isolation has two key dimensions:

1. Object names within a namespace can overlap with names in other namespaces, similar to files in folders. This feature allows tenants to name their resources without worrying about any name collisions with other tenants sharing the same cluster. This happens for example when multiple instances of the same application, one for each tenant, are deployed on the same cluster.
2. Many Kubernetes security policies are scoped to namespaces. For example, [RBAC Roles](https://kubernetes.io/docs/reference/access-authn-authz/rbac/) and [Network Policies](https://kubernetes.io/docs/concepts/services-networking/network-policies/) are namespace-scoped resources. Using RBAC, Users and Service Accounts can be restricted to a namespace.

In a multi-tenant environment, a namespace helps segment a tenant's workload into a logical and distinct management unit. A common practice is to isolate every workload in its namespace, even if the same tenant operates multiple workloads. This approach guarantees better isolation at the security level, as each workload can use a separate identity to access resources in the same cluster or downstream PaaS services.

### Access controls

Another type of isolation at the control plane level is Kubernetes role-based access control. Suppose teams or their workloads could access or modify each other's API resources. In that case, they could change, tamper, or even delete resources of other tenants. They could also read sensitive data such as credentials and connection strings to access data from downstream data repositories. Hence, it is critical to guarantee that each tenant has the appropriate access only to the resources in their namespaces. This approach is known as [Principle of Least Privilege](https://en.wikipedia.org/wiki/Principle_of_least_privilege). It consists in granting user principals, managed identities, and service accounts precisely the permissions they need to do their job and no more.

Role-based access control (RBAC) is commonly used to enforce authorization in the Kubernetes control plane, for both users and workloads (service accounts). [Roles](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#role-and-clusterrole) and [role bindings](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#rolebinding-and-clusterrolebinding) are Kubernetes objects that are used at a namespace level to enforce access control in your application. [Cluster roles](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#role-and-clusterrole) and [cluster role bindings](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#rolebinding-and-clusterrolebinding) can be used to authorize access to cluster-level objects, though these are less useful for multi-tenant clusters.

When you enable [AKS-managed Azure Active Directory integration](https://docs.microsoft.com/en-us/azure/aks/managed-aad) you can use Azure AD users, groups, or service principals as subjects in [Kubernetes RBAC](https://kubernetes.io/docs/reference/access-authn-authz/rbac/). In addition, you can use Azure RBAC, built-in roles, or custom roles to authorize Azure AD users and identities to access Kubernetes API resources at the namespace and cluster level. For more information, see [Use Azure RBAC for Kubernetes Authorization](https://docs.microsoft.com/en-us/azure/aks/manage-azure-rbac).

In a multi-team environment, you can use RBAC to restrict tenants' access to the appropriate namespaces and ensure that cluster-wide resources can only be accessed or modified by privileged users such as cluster administrators. 

If you end up granting users or service accounts more permissions than necessary, you can solve this issue by refactoring and splitting namespaces into finer-grained namespaces.

### Quotas

Kubernetes workloads consume node resources, like CPU and memory. In a multitenant environment, you can use [Resource Quotas](/docs/concepts/policy/resource-quotas/) to manage resource usage of tenant workloads and avoid the [noisy neighbor issue](/azure/architecture/antipatterns/noisy-neighbor/noisy-neighbor). For the multiple teams use case, where tenants have access to the Kubernetes API, you can use resource quotas
to limit the number of API resources (for example, the number of Pods or the number of ConfigMaps) that a tenant can create. Limits on object count ensure fairness and aim to avoid [noisy neighbor issues](/azure/architecture/antipatterns/noisy-neighbor/noisy-neighbor) from affecting other tenants that share a control plane.

Resource quotas are namespaced objects. By mapping tenants to distinct namespaces, cluster administrators can use resource quotas to ensure that a tenant cannot monopolize a cluster's resources, such as agent nodes' CPU, memory, and network bandwidth, or overwhelm its control plane. In addition, while Kubernetes resource quotas only apply within a single namespace, some namespace management tools allow groups of namespaces to share the same quotas, giving administrators far more flexibility with less effort than built-in quotas.

Quotas prevent a single tenant from consuming more than their allocated share of resources, minimizing the [noisy neighbor issue](/azure/architecture/antipatterns/noisy-neighbor/noisy-neighbor), where one tenant negatively impacts the performance of other tenants' workloads.

When you apply a resource quota to a namespace, Kubernetes requires you to specify resource requests and limits for each container. Limits represent the upper bound for the number of resources a container can consume. Containers that attempt to consume resources that exceed the configured limits will either be throttled or killed based on the resource type. When resource requests are set lower than limits, each container is guaranteed the requested amount, but there may still be some potential for impact across workloads.

Resource quotas cannot protect against all kinds of resource sharing, such as network traffic. Node isolation may be a better solution for this problem.

## Data plane isolation

Data plane isolation ensures that pods and workloads for different tenants are sufficiently isolated from one another.

### Network isolation

When you run modern, microservices-based applications in Kubernetes, you often want to control which components can communicate with each other. You should apply the [Principle of Least Privilege](https://en.wikipedia.org/wiki/Principle_of_least_privilege) to how traffic can flow between pods in an Azure Kubernetes Service (AKS) cluster. 

By default, all pods in a Kubernetes cluster are allowed to communicate with each other, and all network traffic is unencrypted. This approach can quickly lead to security vulnerabilities where traffic is accidentally or maliciously sent to an unintended destination or gets intercepted by a workload on a compromised agent node.

You can control service-to-service communications using [Network Policies](/docs/concepts/services-networking/network-policies/), which restrict communication between pods using namespace labels or IP address ranges. In a multitenant environment where strict network isolation between tenants is required,  we recommend starting with a default policy that denies communication between pods and creating another rule that allows all pods to query the DNS server for name resolution. With such a default policy in place, you can begin adding more permissive rules that allow for communication within a namespace. 

Network policies require a [CNI plugin](https://kubernetes.io/docs/concepts/extend-kubernetes/compute-storage-net/network-plugins/#cni) that supports the implementation of network policies. Azure Kubernetes Service (AKS) provides two ways to implement network policies. You can choose a network policy option when you create a new AKS cluster. You can't change a policy option after provisioning the cluster:
Azure has its implementation for network policies, called Azure Network Policies.
[Calico Network Policies](https://projectcalico.docs.tigera.io/security/calico-network-policy) is an open-source network and network security solution founded by [Tigera](https://www.tigera.io/).
Both implementations use Linux IPTables to enforce the specified policies. Network policies are translated into sets of allowed and disallowed IP pairs. These pairs are then programmed as IPTable filter rules. You can use Azure Network Policies only with AKS clusters configured the [Azure CNI](/azure/aks/configure-azure-cni) network plugin, while Calico Network Policies support both [Azure CNI](/azure/aks/configure-azure-cni) and [kubenet](https://docs.microsoft.com/en-us/azure/aks/use-network-policies). For more information, see [/azure/aks/use-network-policies](/azure/aks/use-network-policies).

You can implement more advanced network isolation by using a service mesh like [Istio](https://istio.io/), [Linkerd](https://linkerd.io/), or [Open Service Mesh](https://openservicemesh.io/), which provides Layer 7 network policies based on workload identity. These higher-level policies can make it easier to manage namespace-based multi-tenancy, primarily when multiple namespaces are dedicated to a single tenant. They frequently also offer encryption using mutual TLS, protecting your data even in the presence of a compromised node, and work across dedicated or virtual clusters. However, they can be significantly more complex to manage and may not be appropriate for all users.

### Storage isolation

Azure provides a rich set of managed, platform-as-a-service (PaaS) data repositories such as [Azure SQL Database](/azure/azure-sql/database/sql-database-paas-overview) and [Azure Cosmos DB](/azure/cosmos-db/introduction) that you can use as [persistent volumes](/azure/aks/concepts-storage#volumes) for your workloads. In a multitenant scenario, different tenant applications running on AKS can [share a database or file store](/azure/architecture/guide/multitenant/approaches/storage-data#shared-multitenant-databases-and-file-stores), or they can use [a dedicated data repository and storage resource](/azure/architecture/guide/multitenant/approaches/storage-data#multitenant-app-with-dedicated-databases-for-each-tenant). For more information on different strategies and approaches to manage data in a multitenant scenario, see [Architectural approaches for storage and data in multitenant solutions](https://docs.microsoft.com/en-us/azure/architecture/guide/multitenant/approaches/storage-data).

Workloads running on [Azure Kubernetes Service](/azure/aks/intro-kubernetes) (AKS) can also use persistent volumes to store data. On Azure, you can create [persistent volumes](/azure/aks/concepts-storage#volumes) as Kubernetes resources backed by Azure Storage. You can manually create data volumes and assign them to pods directly or have AKS automatically create them using [persistent volume claims](/azure/aks/concepts-storage#persistent-volume-claims). AKS provides built-in storage classes to create persistent volumes backed by [Azure Disks](/azure/virtual-machines/disks-types), [Azure Files](/azure/storage/files/storage-files-planning), [Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-service-levels). For more information, see [Storage options for applications in Azure Kubernetes Service (AKS)](/azure/aks/concepts-storage). For security and resiliency reasons, you should avoid using local storage on agent nodes via [emptyDir](https://kubernetes.io/docs/concepts/storage/volumes/#emptydir) and [hostPath](https://kubernetes.io/docs/concepts/storage/volumes/#emptydir).

[Storage classes](https://kubernetes.io/docs/concepts/storage/storage-classes/) allow you to describe custom storage classes to meet different tenants needs in terms of service level agreement (SLA), backup policies, pricing tier. For more information on built-in AKS storage classes and custom classes, see [Storage classes](/azure/aks/concepts-storage#storage-classes).

Pods can request storage using a [persistent volume claim](https://kubernetes.io/docs/concepts/storage/persistent-volumes/). A persistent volume claim is a namespaced resource, which enables isolating portions of the storage system and dedicating it to tenants within the shared Kubernetes cluster. However, it is important to note that a PersistentVolume is a cluster-wide resource and has a lifecycle independent of workloads and namespaces.

For example, you can configure a separate storage class for each tenant and use this to strengthen isolation. If a storage class is shared, you should set a [reclaim policy of `Delete`](https://kubernetes.io/docs/concepts/storage/storage-classes/#reclaim-policy) to ensure that a persistent volume cannot be reused across different namespaces.

### Node Isolation

Node isolation is another technique that you can use to isolate tenant workloads from each other. With node isolation, a set of agent nodes is dedicated to running only the pods of a particular tenant. This configuration reduces the  [noisy neighbor issue](/azure/architecture/antipatterns/noisy-neighbor/noisy-neighbor), as all the pods running on a given node will belong to a single tenant. TThe risk of information disclosure and data tampering is lower with node isolation because an attacker that manages to get control of a container will only have access to the containers and volumes mounted that belong to a single tenant.

Although workloads from different tenants are running on different nodes, it is important to be aware that the kubelet and (unless using virtual control planes) the API service are still shared services. A skilled attacker could use the permissions assigned to the kubelet or other pods running on the node to move laterally within the cluster and gain access to tenant workloads running on other nodes. If this is a major concern, consider implementing compensating controls such as seccomp, AppArmor or SELinux or explore using sandboxed containers or creating separate clusters for each tenant.

Node isolation is a little easier to reason about from a billing standpoint than sandboxing containers since you can charge back per node rather than per pod. It also has fewer compatibility and performance issues and may be easier to implement than sandboxing containers. For example, nodes for each tenant can be configured with taints so that only pods with the corresponding toleration can run on them. A mutating webhook could then be used to automatically add [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) and node affinities to pods deployed into tenant namespaces so that they run on a specific set of nodes designated for that tenant.

Node isolation can be implemented using an [pod node selectors](https://kubernetes.io//docs/concepts/scheduling-eviction/assign-pod-node/) or a [Virtual Kubelet](https://github.com/virtual-kubelet).

## TODO

- taints, node affinities and node selectors
- one identity for each namespace
- multiple service proxies
- front door
- nginx
- application gateway
- azure private link service
- monitoring
- devops