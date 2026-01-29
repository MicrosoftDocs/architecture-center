---
title: Use Azure Kubernetes Service (AKS) in a Multitenant Solution
description: Learn about the features of Azure Kubernetes Service (AKS) that you can use when you work with multitenant systems. See guidance and examples for how to use AKS in a multitenant solution.
author: griffinbird
ms.author: begriff
ms.date: 01/14/2026
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom:
  - arb-saas
  - arb-containers
---

# Use Azure Kubernetes Service (AKS) in a multitenant solution

[Azure Kubernetes Service (AKS)](/azure/aks/what-is-aks) makes it simple to deploy a managed Kubernetes cluster in Azure because it offloads operational overhead to the Azure cloud platform. As a hosted Kubernetes service, AKS handles critical tasks like health monitoring, maintenance, and control plane management.

You can share AKS clusters across multiple tenants in different ways. You can run diverse applications in the same cluster, or you can run multiple instances of the same application—one instance for each customer—in a shared cluster. Both scenarios are examples of *multitenancy*. Kubernetes doesn't have a built-in concept of users or tenants, but it provides features that help you manage different tenancy requirements.

This article describes AKS features that help you build multitenant systems. For more information, see [Best practices for Kubernetes multitenancy](https://kubernetes.io/docs/concepts/security/multi-tenancy).

## Multitenancy types

To determine how to share an AKS cluster across multiple tenants, first evaluate the available patterns and tools. Multitenancy in Kubernetes clusters has two main categories, but many variations exist. [Two common use cases for multitenancy](https://kubernetes.io/docs/concepts/security/multi-tenancy/#use-cases) include multiple teams and multiple customers.

### Multiple teams

A common form of multitenancy involves sharing a cluster between multiple teams within an organization. Each team deploys, monitors, and operates one or more workloads. These workloads typically communicate with each other and with other internal and external applications on the same cluster or other hosting platforms. They also communicate with services, like relational databases, NoSQL repositories, or messaging systems, which are hosted in the same cluster or run as platform as a service (PaaS) solutions on Azure.

In this scenario, team members access Kubernetes resources in one of the following ways:

- Directly through tools like [kubectl](https://kubernetes.io/docs/reference/kubectl)

- Indirectly through GitOps controllers like [Flux](https://fluxcd.io) and [Argo CD](https://argo-cd.readthedocs.io/en/stable)

- Through other release automation tools

For more information, see [Multiple teams](https://kubernetes.io/docs/concepts/security/multi-tenancy/#multiple-teams).

### Multiple customers

Another common form of multitenancy involves software as a service (SaaS) vendors or a service provider that runs multiple instances of a workload for their customers. Each instance serves a separate tenant. Customers access only their application, not the AKS cluster, and typically don't know that their application runs on Kubernetes. Cost optimization is a critical concern in this model. To ensure strong isolation between tenant workloads, service providers use Kubernetes policies like [resource quotas](https://kubernetes.io/docs/concepts/policy/resource-quotas) and [network policies](https://kubernetes.io/docs/concepts/services-networking/network-policies).

For more information, see [Multiple customers](https://kubernetes.io/docs/concepts/security/multi-tenancy/#multiple-customers).

## Isolation models

According to [Kubernetes documentation](https://kubernetes.io/docs/concepts/security/multi-tenancy/#isolation), multiple users and workloads, also known as *tenants*, share a multitenant Kubernetes cluster. This definition includes Kubernetes clusters that different teams or divisions within an organization share, and clusters that host multiple customer instances of a SaaS application.

Cluster multitenancy provides an alternative to managing many single-tenant dedicated clusters. Operators must isolate tenants from each other to limit the damage that a compromised or malicious tenant can inflict on the cluster or other tenants.

When multiple users or teams share a cluster that has a fixed number of nodes, one team might consume more than its fair share of resources. To prevent this problem, admins can use [resource quotas](https://kubernetes.io/docs/concepts/policy/resource-quotas).

Multitenancy has two categories based on the level of isolation and trust:

- **Soft multitenancy** applies within a single enterprise where different teams or departments trust each other. Isolation focuses on workload integrity, resource management across teams, and defense against accidental problems or security attacks.

- **Hard multitenancy** applies when tenants don't trust each other and require strict isolation for both security and resource consumption.

When you plan to build a multitenant AKS cluster, consider the following [Kubernetes](https://kubernetes.io/docs/concepts/security/multi-tenancy) isolation layers:

- Cluster
- Namespace
- Node pool or node
- Pod
- Container

Also consider the security implications of sharing resources among multiple tenants. For example, scheduling pods from different tenants on the same node reduces the number of machines needed in the cluster. But you might need to prevent certain workloads from sharing nodes. So you might not allow untrusted external code to run on the same node as containers that process sensitive information.

Kubernetes doesn't guarantee perfectly secure isolation between tenants, but it provides features that are sufficient for many use cases. As a best practice, separate each tenant and its Kubernetes resources into dedicated namespaces. Use [Kubernetes role-based access control (RBAC)](https://kubernetes.io/docs/reference/access-authn-authz/rbac) and [network policies](https://kubernetes.io/docs/concepts/services-networking/network-policies) to enforce tenant isolation. The following diagram shows a typical SaaS provider model that hosts multiple instances of the same application on a single cluster, one instance for each tenant. Each instance runs in a separate namespace.

:::image type="complex" border="false" source="./media/aks/namespaces.png" alt-text="Diagram that shows a SaaS provider model that hosts multiple instances of the same application on the same cluster." lightbox="./media/aks/namespaces.png":::
The diagram shows three tenant namespaces. Each namespace contains four sections: deployment, service, ingress, and secret. The deployment section contains pods. The service section contains a clusterIP. The ingress section contains annotations, a hostname, a TLS certificate, and rules. The secret section contains a TLS certificate.
:::image-end:::

AKS provides several ways to design and build multitenant solutions. Each method has trade-offs for infrastructure deployment, network topology, and security. Your choice affects isolation level, implementation effort, operational complexity, and cost. Apply tenant isolation in the control plane, data plane, or both, based on your requirements.

## Control plane isolation

Control plane isolation prevents tenants from accessing or affecting each other's resources, like pods and services. Tenants also don't affect the performance of other tenants' applications. To implement control plane isolation, segregate each tenant's workload and its Kubernetes resources into a separate namespace. For more information, see [Control plane isolation](https://kubernetes.io/docs/concepts/security/multi-tenancy/#control-plane-isolation).

According to the [Kubernetes documentation](https://kubernetes.io/docs/concepts/security/multi-tenancy/#namespaces), a [namespace](https://kubernetes.io/docs/reference/glossary/?fundamental=true#term-namespace) is an abstraction that supports isolation of resource groups within a single cluster. Use namespaces to isolate tenant workloads that share a Kubernetes cluster.

- Namespaces let tenant workloads exist in their own virtual workspace without affecting each other's work. Separate teams within an organization can use namespaces to isolate their projects because they can use the same resource names in different namespaces without conflict.

- [RBAC roles and role bindings](https://kubernetes.io/docs/reference/access-authn-authz/rbac) are namespace-scoped resources that restrict tenant users and processes to resources and services only in their namespaces. Teams can define roles to group permissions or abilities under a single name. They assign these roles to user and service accounts to ensure that only authorized identities access the resources in a given namespace.

- [Resource quotas](https://kubernetes.io/docs/concepts/policy/resource-quotas) for CPU and memory are namespaced objects. Use them to isolate workloads that share the same cluster from consuming excessive system resources. This method ensures that each tenant application has the resources that it needs and avoids [noisy neighbor problems](/azure/architecture/antipatterns/noisy-neighbor/noisy-neighbor) that can affect other tenant applications in the cluster.

- [Network policies](https://kubernetes.io/docs/concepts/services-networking/network-policies) are namespaced objects that control which network traffic a tenant application can send and receive. Use network policies to segregate workloads that share the same cluster from a networking perspective.

- Team applications that run in different namespaces can use separate [service accounts](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account) to access resources within the same cluster, external applications, or managed services.

- Namespaces improve control plane performance. When you organize workloads in a shared cluster into multiple namespaces, the Kubernetes API has fewer items to search when it runs operations. This approach reduces API server latency and increases control plane throughput.

For more information about isolation at the namespace level, see the following resources:

- [Namespaces](https://kubernetes.io/docs/concepts/security/multi-tenancy/#namespaces)
- [Access controls](https://kubernetes.io/docs/concepts/security/multi-tenancy/#access-controls)
- [Quotas](https://kubernetes.io/docs/concepts/security/multi-tenancy/#quotas)

## Data plane isolation

Data plane isolation ensures that tenant pods and workloads remain separate from each other. For more information, see [Data plane isolation](https://kubernetes.io/docs/concepts/security/multi-tenancy/#data-plane-isolation).

### Network isolation

When you run multitenant, microservices-based applications in Kubernetes, you control which components can communicate with each other. By default, all pods in an AKS cluster can send and receive traffic without restrictions, including communication with other applications on the same cluster. To improve security, define network rules to control traffic flow. In Kubernetes, network policy defines access policies for communication between pods. Use [network policies](https://kubernetes.io/docs/concepts/services-networking/network-policies) to segregate communications between tenant applications on the same cluster.

AKS provides the following ways to implement network policies:

- **Azure network policies:** An Azure-native implementation for network policies.

- **[Calico network policies](https://docs.tigera.io/calico/latest/network-policy/get-started/calico-policy/calico-network-policy):** An open-source network and network security solution from [Tigera](https://www.tigera.io).

- **[Azure CNI Powered by Cilium](/azure/aks/azure-cni-powered-by-cilium):** An extended Berkeley Packet Filter (eBPF)-based networking solution that provides enhanced network policy performance and advanced capabilities, including layer-7 filtering. This approach requires Kubernetes 1.29 or later.

Azure network policies and Calico network policies both use Linux iptables by default to enforce policies. These implementations translate network policies into sets of allowed and disallowed IP address pairs, then program them as iptables filter rules. Azure CNI Powered by Cilium uses eBPF programs loaded into the Linux kernel for policy enforcement, which improves performance and eliminates the overhead of iptables and kube-proxy. You can also set up eBPF support for Calico. All three options support both the [Azure CNI](/azure/aks/configure-azure-cni) network plug-in and [Azure CNI Overlay](/azure/aks/azure-cni-overlay) mode.

For more information, see [Secure traffic between pods by using network policies in AKS](/azure/aks/use-network-policies) and [Network isolation](https://kubernetes.io/docs/concepts/security/multi-tenancy/#network-isolation).

### Service mesh

Service meshes provide advanced traffic management, security, and observability capabilities for microservices communication in multitenant AKS clusters. Service meshes operate at layer 7. They provide fine-grained control over service-to-service communication beyond what network policies provide at layers 3 and 4.

AKS includes an [Istio-based service mesh feature](/azure/aks/istio-about) that manages the Istio control plane's life cycle, scaling, and configuration. Service meshes provide several key capabilities for multitenant scenarios:

- **Identity and authentication:** Service meshes provide mutual TLS (mTLS) to automatically encrypt and authenticate communication between services. Each service receives a cryptographic identity based on its namespace and service account, which provides the foundation for enforcing tenant boundaries.

- **Authorization policies:** You can define fine-grained authorization policies that control which services communicate with each other based on service identity, namespace, or custom attributes. For example, enforce that tenant A's front end only calls tenant A's back-end services to prevent cross-tenant service access.

- **Traffic management:** Service meshes provide advanced traffic routing capabilities that support multitenant deployments:

  - Canary deployments and A/B testing

  - Traffic splitting to gradually roll out updates to specific tenant namespaces

  - Request routing based on headers or other attributes to direct tenant traffic

  - Circuit breaking and retry policies to prevent cascading failures across tenant workloads

  To enforce tenant isolation, you must combine these features with tenant separation patterns:

  - Isolate tenants in separate namespaces.

  - Apply consistent labeling strategies.

  - Configure path-based or host-based routing rules.

  - Deploy separate ingress gateways per tenant when needed.

  - Create explicit routing policies that target specific tenant namespaces or labels.

- **Observability:** Service meshes automatically generate metrics, logs, and distributed traces for all service-to-service communication. This visibility helps you troubleshoot multitenant problems and identify noisy neighbor problems.

- **Layer-7 security policies:** Service meshes enforce policies based on HTTP methods, paths, and headers, unlike network policies that operate only on IP addresses and ports. For example, restrict tenant services to perform only GET requests to specific API endpoints.

When you implement service meshes in multitenant environments, consider the following factors:

- Plan for the resource overhead that service meshes add to each pod because of sidecar proxies. Size nodes and set resource quotas for tenant namespaces accordingly.

- Apply Istio authorization policies at the namespace level to enforce tenant isolation boundaries.

- Configure explicit default-deny authorization policies to enforce tenant isolation. By default, all traffic is allowed.

- Use separate Istio ingress gateways per tenant tier (basic, standard, premium) to provide different levels of traffic management and security.

For more information, see [Deploy the Istio-based service mesh feature for AKS](/azure/aks/istio-deploy-addon).

### Storage isolation

Azure provides managed PaaS data repositories like [Azure SQL Database](/azure/azure-sql/database/sql-database-paas-overview) and [Azure Cosmos DB](/azure/cosmos-db/introduction), along with other storage services that you can use as [persistent volumes](/azure/aks/concepts-storage#volumes) for your workloads. Tenant applications that run on a shared AKS cluster can [share a database or file store](/azure/architecture/guide/multitenant/approaches/storage-data#shared-multitenant-databases-and-file-stores) or use [dedicated data repositories and storage resources](/azure/architecture/guide/multitenant/approaches/storage-data#multitenant-app-with-dedicated-databases-for-each-tenant). For more information, see [Architectural approaches for storage and data in multitenant solutions](/azure/architecture/guide/multitenant/approaches/storage-data).

AKS workloads can use persistent volumes to store data. You can create [persistent volumes](/azure/aks/concepts-storage#volumes) as Kubernetes resources backed by Azure Storage. Manually create and assign data volumes to pods directly, or let AKS automatically create them by using [persistent volume claims](/azure/aks/concepts-storage#persistent-volume-claims). AKS includes built-in storage classes to create persistent volumes that [Azure managed disks](/azure/virtual-machines/disks-types), [Azure Files](/azure/storage/files/storage-files-planning), and [Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-service-levels) support. For more information, see [Storage options for applications in AKS](/azure/aks/concepts-storage). Avoid using local storage on agent nodes via [emptyDir](https://kubernetes.io/docs/concepts/storage/volumes/#emptydir) and [hostPath](https://kubernetes.io/docs/concepts/storage/volumes/#hostpath) for security and resiliency reasons.

When AKS [built-in storage classes](/azure/aks/azure-csi-driver-volume-provisioning#use-a-persistent-volume-for-storage) don't fit your tenants' needs, create custom [storage classes](https://kubernetes.io/docs/concepts/storage/storage-classes) to address their specific requirements. These requirements include volume size, storage SKU, a service-level agreement (SLA), backup policies, and the pricing tier.

For example, create a custom storage class for each tenant and use it to apply tags to persistent volumes in their namespaces for cost chargeback. For more information, see [Use Azure tags in AKS](https://techcommunity.microsoft.com/blog/fasttrackforazureblog/use-azure-tags-in-azure-kubernetes-service-aks/3611583).

For more information, see [Storage isolation](https://kubernetes.io/docs/concepts/security/multi-tenancy/#storage-isolation).

### Node isolation

Configure tenant workloads to run on separate agent nodes to avoid [noisy neighbor problems](/azure/architecture/antipatterns/noisy-neighbor/noisy-neighbor) and reduce the risk of information disclosure. Create a separate cluster or dedicated node pool for tenants that have strict requirements for isolation, security, regulatory compliance, and performance.

To restrict tenant pods to specific nodes or node pools, use [taints and tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration), [node labels](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#built-in-node-labels), [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector), and [node affinity](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity).

AKS provides workload isolation at multiple levels:

- **Kernel level:** AKS can run tenant workloads in lightweight virtual machines (VMs) on shared agent nodes and by using [pod sandboxing](#pod-sandboxing) based on [Kata Containers](https://katacontainers.io/).

- **Physical level:** You can host tenant applications on dedicated clusters or node pools.

- **Hardware level:** You can run tenant workloads on [Azure dedicated hosts](#azure-dedicated-host) that guarantee that agent node VMs run on dedicated physical machines. This hardware isolation ensures that no other VMs share the dedicated hosts, which provides an extra layer of tenant workload isolation.

Combine these techniques as needed. For example, run per-tenant clusters and node pools in an [Azure dedicated host group](#azure-dedicated-host) to achieve both workload segregation and physical isolation at the hardware level. You can also create shared or per-tenant node pools that support [Federal Information Process Standards (FIPS)](#fips), [confidential VMs](#confidential-vms), or [host-based encryption](#host-based-encryption).

Use node isolation to easily associate and charge back the cost of a set of nodes or node pool to a single tenant. Your choice depends on your solution's tenancy model. For more information, see [Node isolation](https://kubernetes.io/docs/concepts/security/multi-tenancy/#node-isolation).

## Tenancy models

AKS provides different types of node isolation and tenancy models.

### Automated single-tenant deployments

In this model, deploy a dedicated set of resources for each tenant, as shown in the following example.

:::image type="complex" border="false" source="./media/aks/automated-single-tenant-deployments.png" alt-text="Diagram that shows three tenants, each with separate deployments." lightbox="./media/aks/automated-single-tenant-deployments.png":::
The diagram shows three tenants. Each tenant has its own deployment. Each deployment contains an AKS cluster and a database.
:::image-end:::

Each tenant workload runs in a dedicated AKS cluster and accesses a distinct set of Azure resources. This model typically relies on [infrastructure as code (IaC)](/devops/deliver/what-is-infrastructure-as-code) tools. To automate on-demand deployment of tenant-dedicated resources, use [Bicep](/azure/azure-resource-manager/bicep/overview), [Azure Resource Manager](/azure/azure-resource-manager/management/overview), [Terraform](/azure/developer/terraform/overview), or [Resource Manager REST APIs](/rest/api/resources). Use this approach when you need to provision separate infrastructure for each customer. When you plan your deployment, consider the [Deployment Stamps pattern](../../../patterns/deployment-stamp.yml).

This approach provides the following benefits:

- Each tenant AKS cluster has a separate API server, which guarantees isolation across tenants for security, networking, and resource consumption. An attacker who gains control of a container only accesses the containers and mounted volumes that belong to a single tenant. Use full-isolation tenancy models for customers that have high regulatory compliance requirements.

- Tenants don't affect each other's system performance, so this approach prevents [noisy neighbor problems](/azure/architecture/antipatterns/noisy-neighbor/noisy-neighbor). This consideration includes traffic against the API server, which is a shared critical component in any Kubernetes cluster. Custom controllers that generate unregulated, high-volume traffic against the API server can cause cluster instability, which leads to request failures, timeouts, and API retry storms. Use the [uptime SLA](/azure/aks/free-standard-pricing-tiers#uptime-sla-terms-and-conditions) feature to scale out the control plane of an AKS cluster to meet traffic demand. But provisioning a dedicated cluster might be better for customers that have strong workload isolation requirements.

- You can roll out updates and changes progressively across tenants to reduce the likelihood of system-wide outages. Azure costs are easily attributed to individual tenants because every resource is dedicated to a single tenant.

- Using Azure CNI Overlay across all tenant clusters simplifies IP address planning and lets you reuse the same pod CIDR space across multiple isolated clusters.

This approach has the following risks:

- Every tenant uses dedicated resources, which increases cost.

- Ongoing maintenance is time consuming because you must repeat maintenance activities across multiple AKS clusters, with one cluster for each tenant. To manage this complexity, automate your operational processes and apply changes progressively through your environments. Plan how to query and manipulate data across multiple deployments for operations like reporting and analytics across your entire estate.

### Fully multitenant deployments

In a fully multitenant deployment, a single application serves the requests of all tenants, and all Azure resources are shared, including the AKS cluster. In this context, you only have one infrastructure to deploy, monitor, and maintain. All tenants use the resource, as shown in the following diagram.

:::image type="complex" border="false" source="./media/aks/fully-multitenant-deployments.png" alt-text="A diagram that shows three tenants that use a single shared deployment." lightbox="./media/aks/fully-multitenant-deployments.png":::
The diagram shows three tenants. All tenants point to shared resources, which include an AKS cluster and a database.
:::image-end:::

This approach provides the following benefits:

- Lower operating costs from shared components. To handle the traffic that all tenants generate, you might need to deploy a larger AKS cluster and use a higher SKU for shared data repositories.

This approach has the following risks:

- A single application handles all tenant requests. Design and implement security measures to prevent tenants from flooding the application with calls. These calls can slow down the entire system and affect all tenants.

- Highly variable traffic requires cluster autoscaling. Configure the AKS cluster autoscaler to adjust the number of pods and agent nodes based on system resource usage like CPU and memory. Alternatively, scale pods and cluster nodes based on custom metrics, like the number of pending requests or metrics from an external messaging system that uses the [Kubernetes-based Event Driven Autoscaler (KEDA)](https://keda.sh).

- Data separation between tenants requires careful implementation. Separate the data for each tenant and implement safeguards to prevent data leakage between tenants.

- Cost tracking and attribution to individual tenants based on actual usage is complex. [Track and associate Azure costs](/azure/architecture/guide/multitenant/considerations/measure-consumption) to individual tenants. Non-Microsoft solutions, like [Kubecost](https://www.apptio.com/products/kubecost), can help you calculate and break down costs across different teams and tenants.

- Maintenance is simpler with a single deployment because you only update one set of Azure resources and maintain a single application. But any changes to infrastructure or application components can affect the entire customer base.

- Shared resources are more likely to reach Azure resource scale limits. To avoid reaching resource quota limits, distribute your tenants across multiple Azure subscriptions.

### Horizontally partitioned deployments

Horizontal partitioning shares some solution components across all tenants and deploys dedicated resources for individual tenants. For example, build a single multitenant Kubernetes application and then create individual databases, one for each tenant, as shown in the following diagram.

:::image type="complex" border="false" source="./media/aks/horizontally-partitioned-deployments.png" alt-text="A diagram that shows three tenants. Each tenant uses a dedicated database and a single, shared Kubernetes application." lightbox="./media/aks/horizontally-partitioned-deployments.png":::
The diagram shows three tenants. The tenants point to a deployment that includes a shared AKS cluster and three separate databases.
:::image-end:::

This approach provides the following benefits:

- Horizontally partitioned deployments help mitigate [noisy neighbor problems](/azure/architecture/antipatterns/noisy-neighbor/noisy-neighbor). Use this approach when specific components generate most of your Kubernetes application's load and you can deploy the components separately for each tenant. For example, if your databases handle high-query loads, a single tenant that sends excessive requests affects only their own database. Other tenants' databases and shared components, like the application tier, remain unaffected.

This approach has the following risks:

- You must automate deployment and management for components, especially the components that a single tenant uses.

- This model might not provide the required level of isolation for customers that can't share resources with other tenants for internal policy or compliance reasons.

### Vertically partitioned deployments

To take advantage of the benefits of single-tenant and fully multitenant models, use a hybrid model that vertically partitions tenants across multiple AKS clusters or node pools. This approach provides the following advantages over the previous two tenancy models:

- You can use a combination of single-tenant and multitenant deployments. For example, most of your customers can share an AKS cluster and database on a multitenant infrastructure. And you can deploy single-tenant infrastructures for customers who require higher performance and isolation.

- You can deploy tenants to multiple regional AKS clusters that have different configurations. Use this technique when you have tenants spread across different geographies.

You can implement different variations of this tenancy model. For example, you can offer your multitenant solution with tiered pricing that provides different functionality levels. Each tier can provide an incremental level of performance and isolation for resource sharing, performance, network, and data segregation. Consider the following example tiers:

- **Basic tier:** A single, shared multitenant Kubernetes application serves all tenant requests. All Basic-tier tenants share one or more databases.

- **Standard tier:** Each tenant has a dedicated Kubernetes application that runs in a separate namespace. This approach provides isolation for security, networking, and resource consumption. Each tenant application shares the same AKS cluster and node pool with other Standard-tier tenants.

- **Premium tier:** Each tenant application runs in a dedicated node pool or AKS cluster. This approach guarantees a higher SLA, better performance, and stronger isolation. Cost is based on the number and SKU of agent nodes that host the tenant application. To isolate distinct tenant workloads, [pod sandboxing](#pod-sandboxing) provides an alternative to dedicated clusters or node pools.

The following diagram shows a scenario where tenants A and B run on a shared AKS cluster, and tenant C runs on a separate AKS cluster.

:::image type="complex" border="false" source="./media/aks/vertically-partitioned-aks-clusters.png" alt-text="Diagram that shows three tenants. Tenants A and B share an AKS cluster. Tenant C has a dedicated AKS cluster." lightbox="./media/aks/vertically-partitioned-aks-clusters.png":::
The diagram shows three tenants. Tenant A and B point to deployment 1, which contains an AKS cluster and a database. Tenant C points to deployment 2, which contains an AKS cluster and a database.
:::image-end:::

The following diagram shows a scenario where tenants A and B run on the same node pool, and tenant C runs on a dedicated node pool.

:::image type="complex" border="false" source="./media/aks/vertically-partitioned-node-pools.png" alt-text="Diagram that shows three tenants. Tenants A and B share a node pool. Tenant C has a dedicated node pool." lightbox="./media/aks/vertically-partitioned-node-pools.png":::
The diagram shows three tenants and a deployment. The deployment contains node pool 1, node pool 2, an AKS cluster, and two databases. Tenant A and B use node pool 1 and a shared database. Tenant C uses node pool 2 and its own dedicated database.
:::image-end:::

This model can also provide different SLAs for different tiers. For example, the Basic tier can provide 99.90% uptime, the Standard tier can provide 99.95% uptime, and the Premium tier can provide 99.99% uptime. As the application owner, you define and own these SLAs. To implement a higher SLA, use services and features that enable higher availability targets.

This approach provides the following benefits:

- Shared infrastructure reduces costs. Deploy shared clusters and node pools for Basic-tier and Standard-tier tenants. This approach uses lower-cost VM sizes for agent nodes and provides better density. For Premium-tier tenants, you can deploy AKS clusters and node pools with a higher VM size and a maximum number of pod replicas and nodes at a higher price.

- Isolate system services on dedicated node pools. Run system services like [CoreDNS](https://kubernetes.io/docs/tasks/administer-cluster/coredns), [Konnectivity](https://kubernetes.io/docs/tasks/extend-kubernetes/setup-konnectivity), or [Application Gateway for Containers (AGC)](/azure/application-gateway/for-containers/overview) on system-mode node pools. To run tenant applications on one or more user-mode node pools, use [taints and tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration), [node labels](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#built-in-node-labels), [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector), and [node affinity](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity).

- Dedicate node pools to shared resources. To run shared resources, use [taints and tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration), [node labels](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#built-in-node-labels), [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector), and [node affinity](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity). For example, you can have an ingress controller or messaging system on a dedicated node pool that has a specific VM size, autoscaler settings, and availability zone support.

This approach has the following risks:

- Your Kubernetes application must support both multitenant and single-tenant deployments.

- Customer migration from shared infrastructure to dedicated infrastructure requires careful planning.

- Management and monitoring of multiple AKS clusters requires centralized monitoring and a consistent strategy.

## Autoscaling

To meet the traffic demand that tenant applications generate, turn on the [cluster autoscaler](/azure/aks/cluster-autoscaler) to scale the agent nodes of AKS. Autoscaling helps systems remain responsive in the following circumstances:

- Traffic load increases during specific work hours or periods.

- Tenant workloads or heavy shared loads are deployed to a cluster.

- Agent nodes become unavailable because of availability zone outages.

When you turn on autoscaling for a node pool, specify minimum and maximum node counts based on expected workload sizes. The maximum node count ensures sufficient capacity for all tenant pods in the cluster, across all namespaces.

As traffic increases, the cluster autoscaler adds new agent nodes to prevent pods from going into a pending state because of CPU or memory shortages.

As load decreases, the cluster autoscaler removes agent nodes in a node pool within the configured boundaries, which reduces operational costs.

Pod autoscaling scales pods automatically based on resource demands. [HorizontalPodAutoscaler](https://kubernetes.io/docs/concepts/workloads/autoscaling/horizontal-pod-autoscale) scales pod replicas based on CPU, memory, or custom metrics. [KEDA](https://keda.sh) scales containers based on events from external systems that tenant applications use, like [Azure Event Hubs](https://keda.sh/docs/2.7/scalers/azure-event-hub) or [Azure Service Bus](https://keda.sh/docs/2.7/scalers/azure-service-bus).

[Vertical Pod Autoscaler (VPA)](/azure/aks/vertical-pod-autoscaler) adjusts CPU and memory allocated to pods, which reduces the number of nodes required to run tenant applications. Fewer nodes reduce total cost and help avoid [noisy neighbor problems](/azure/architecture/antipatterns/noisy-neighbor/noisy-neighbor).

For better resource allocation and isolation between tenants, assign [capacity reservation groups](/azure/aks/use-capacity-reservation-groups) to node pools.

## Maintenance

To reduce downtime risk for tenant applications during cluster or node pool upgrades, schedule AKS [planned maintenance](/azure/aks/planned-maintenance) during off-peak hours. To minimize workload impact, schedule weekly maintenance windows to update the control plane of AKS clusters that run tenant applications and node pools. Specify one or more weekly maintenance windows on your cluster by defining a day or time range. All maintenance operations occur within the scheduled windows.

## Security

The following sections describe security best practices for multitenant AKS solutions.

### Cluster access

When you share an AKS cluster between multiple teams within an organization, implement the [principle of least privilege](https://en.wikipedia.org/wiki/Principle_of_least_privilege) to isolate different tenants from one another. Give users access only to their Kubernetes namespaces and resources when you use tools like [kubectl](https://kubernetes.io/docs/reference/kubectl), [Helm](https://helm.sh), [Flux](https://fluxcd.io), or [Argo CD](https://argo-cd.readthedocs.io/en/stable).

For more information about authentication and authorization with AKS, see the following articles:

- [Access and identity options for AKS](/azure/aks/concepts-identity)
- [AKS-managed Microsoft Entra integration](/azure/aks/enable-authentication-microsoft-entra-id)
- [Kubernetes RBAC with Microsoft Entra ID in AKS](/azure/aks/azure-ad-rbac)

### Workload identity

Workload identity is a critical security requirement for multitenant AKS clusters. When multiple tenant applications share an AKS cluster, each tenant's workloads must authenticate to Azure resources by using separate, isolated identities to prevent cross-tenant access and credential sharing.

In a multitenant cluster, workload identity prevents several critical security risks:

- **Credential sharing:** Without workload identity, tenant applications share service principals or store credentials in secrets, which increases the risk of cross-tenant access.

- **Privilege escalation:** A compromised tenant workload can access other tenants' Azure resources through shared credentials.

- **Credential exposure:** Service principal credentials in Kubernetes secrets are vulnerable to accidental disclosure or unauthorized access.

Workload identity integrates with Kubernetes service accounts. When you create a namespace for a tenant, you create a dedicated Kubernetes service account and annotate it with the client ID of that tenant's Azure managed identity. The AKS cluster uses its OIDC issuer endpoint to federate with Microsoft Entra ID, which establishes a trust relationship. Pods that use the annotated service account automatically receive short-lived tokens that exchange for Microsoft Entra access tokens, which enables secure Azure resource access.

For more information about implementation steps and code examples, see [Use Microsoft Entra Workload ID with AKS](/azure/aks/workload-identity-overview) and [Deploy and configure Workload ID on AKS](/azure/aks/workload-identity-deploy-cluster).

### Pod sandboxing

AKS [pod sandboxing](/azure/aks/use-pod-sandboxing) provides an isolation boundary between container applications and the shared kernel and compute resources of the container host, like CPU, memory, and networking. Pod sandboxing complements other security measures and data protection controls to help tenant workloads secure sensitive information and meet regulatory, industry, or governance compliance requirements, like Payment Card Industry Data Security Standard (PCI DSS), International Organization for Standardization (ISO) 27001, and Health Insurance Portability and Accountability Act (HIPAA).

Separate clusters or node pools provide strong isolation for tenant workloads of different teams or customers. This approach works well for many organizations and SaaS solutions. But a single cluster with shared VM node pools is more efficient in some scenarios, like when you run untrusted and trusted pods together or colocate DaemonSets with privileged containers for faster local communication and functional grouping.

Pod sandboxing provides strong tenant application isolation on shared cluster nodes without requiring separate clusters or node pools. Unlike other isolation methods, pod sandboxing runs any container unmodified inside an enhanced security VM boundary without code recompilation or compatibility problems.

To provide hardware-enforced isolation, pod sandboxing on AKS is based on [Kata containers](https://katacontainers.io) that run on the [Azure Linux container host for AKS](/azure/aks/use-azure-linux) stack. Kata containers run on a security-hardened Azure hypervisor. Each Kata pod runs in a nested, lightweight VM with its own kernel. The Kata VM uses resources from the parent VM node. You can run many Kata containers in a single guest VM while standard containers continue to run in the parent VM. This approach provides a strong isolation boundary in a shared AKS cluster.

Consider the following constraints of pod sandboxing on AKS:

- Pod sandboxing is supported only on Linux node pools that use Azure Linux 3.0 or later and Generation 2 VMs that support nested virtualization.

- Kata containers might not reach the same input/output operations per second (IOPS) performance as traditional containers on Azure Files and high-performance local solid-state drives (SSDs).

- Microsoft Defender for Containers doesn't support security assessments of Kata runtime pods.

- Host-network access isn't supported.

For more information, see the following articles:

- [Pod sandboxing by using AKS](/azure/aks/use-pod-sandboxing)
- [Support for Kata VM isolated containers on AKS for pod sandboxing](https://techcommunity.microsoft.com/blog/appsonazureblog/preview-support-for-kata-vm-isolated-containers-on-aks-for-pod-sandboxing/3751557)

### Azure Dedicated Host

[Azure Dedicated Host](/azure/virtual-machines/dedicated-hosts) provides physical servers dedicated to a single Azure subscription with hardware isolation at the physical-server level. You can provision dedicated hosts within a region, availability zone, and fault domain, and place VMs directly into them.

Dedicated Host with AKS provides the following benefits:  

- **Hardware isolation:** No other VMs run on your dedicated hosts, which provides an extra isolation layer for tenant workloads. You deploy dedicated hosts in the same datacenters as other nonisolated hosts. They share the same network and underlying storage infrastructure.

- **Maintenance control:** You control when Azure platform maintenance occurs. Choose a maintenance window to reduce service impact and ensure availability and privacy of tenant workloads.

Dedicated Host helps SaaS providers ensure that tenant applications meet regulatory, industry, and governance compliance requirements for securing sensitive information. For more information, see [Add Dedicated Host to an AKS cluster](/azure/aks/use-azure-dedicated-hosts).

### Node autoprovisioning

Node autoprovisioning is a managed AKS feature that dynamically provisions and manages nodes based on pending pod requirements. When the Kubernetes scheduler marks pods as unschedulable, node autoprovisioning automatically creates appropriately configured nodes to run those workloads. Use this capability in multitenant deployments where tenants have diverse infrastructure requirements.

Node autoprovisioning improves multitenant cluster operations in the following ways:

- **Dynamic tenant-specific node types:** Node autoprovisioning provisions the appropriate VM size for each tenant's workload requirements. For example, if Tenant A deploys GPU-intensive workloads and Tenant B runs memory-intensive applications, node autoprovisioning creates GPU-optimized nodes for Tenant A and memory-optimized nodes for Tenant B.

- **Cost optimization:** Tenants consume compute resources only when they have active workloads. Node autoprovisioning scales down or removes nodes when tenant pods are deleted, so you don't pay for idle capacity.

- **Availability zone placement:** Node autoprovisioning can provision nodes in specific availability zones to meet tenant latency or data residency requirements based on pod topology constraints.

- **Simplified node pool management:** Node autoprovisioning provisions nodes on-demand based on actual tenant workload requirements. You don't need to preprovision multiple node pools for different tenant tiers that have different VM sizes.

- **Better resource utilization:** Node autoprovisioning provides intelligent bin-packing across dynamically created nodes. This feature reduces wasted capacity compared to static node pools. Use this approach when you run many small tenant workloads that have varying resource profiles.

To enable node autoprovisioning on your AKS cluster and define workload requirements, use the following Kubernetes-native configurations:

- Use pod resource requests and limits to specify CPU and memory requirements for tenant workloads.

- Apply node selectors or node affinity rules to tenant pods when specific VM families are required.

- Use topology spread constraints to control pod distribution across availability zones.

- Apply taints and tolerations to restrict workloads to appropriately provisioned nodes.

Node autoprovisioning is built on the open-source [Karpenter](https://karpenter.sh) project. AKS provides a managed experience with life cycle management, upgrades, and Azure-specific optimizations. Most users should use node autoprovisioning as a managed feature. For more information, see [Node autoprovisioning](/azure/aks/node-auto-provisioning).

If you require advanced customization beyond what node autoprovisioning provides, you can self-host Karpenter directly on AKS. This approach provides full control over Karpenter configuration but requires you to manage the life cycle and upgrades. For more information, see [AKS Karpenter provider](https://github.com/Azure/karpenter-provider-azure).

### Confidential VMs

Use [confidential VMs](/azure/aks/use-cvm) to add one or more node pools to your AKS cluster to address tenants' strict isolation, privacy, and security requirements. [Confidential VMs](https://techcommunity.microsoft.com/t5/azure-confidential-computing/azure-confidential-vms-using-sev-snp-dcasv5-ecasv5-are-now/ba-p/3573747) use a hardware-based [trusted execution environment](https://en.wikipedia.org/wiki/Trusted_execution_environment).

[AMD Secure Encrypted Virtualization-Secure Nested Paging (SEV-SNP)](https://www.amd.com/system/files/TechDocs/SEV-SNP-strengthening-vm-isolation-with-integrity-protection-and-more.pdf) confidential VMs deny the hypervisor and other host-management code access to VM memory and state, which adds a layer of defense and in-depth protection against operator access. For more information, see [Use confidential VMs in an AKS cluster](/azure/aks/use-cvm).

### FIPS

[FIPS 140-3](https://csrc.nist.gov/publications/detail/fips/140/3/final) is a US government standard that defines minimum security requirements for cryptographic modules in information technology (IT) products and systems. [FIPS compliance](/azure/compliance/offerings/offering-fips-140-2) ensures the use of validated cryptographic modules for encryption, hashing, and other security-related operations.

Configure [FIPS for AKS node pools](/azure/aks/enable-fips-nodes) to enhance tenant workload isolation, privacy, and security. FIPS-enabled node pools help meet regulatory and industry compliance requirements by employing robust cryptographic algorithms and mechanisms. Use this approach to strengthen the security posture of your multitenant AKS environments.

### Bring your own key (BYOK) for Azure disks

Azure Storage encrypts data in a storage account at rest, including the operating system (OS) and data disks of an AKS cluster. By default, Azure encrypts data through Microsoft-managed keys. For more control over encryption keys, supply customer-managed keys for encryption at rest of the OS and data disks of your AKS clusters. For more information, see the following articles:

- [BYOK for Azure managed disks in AKS](/azure/aks/azure-disk-customer-managed-keys)
- [Server-side encryption of Azure Disk Storage](/azure/virtual-machines/disk-encryption)

### Host-based encryption

[Host-based encryption](/azure/aks/enable-host-encryption) on AKS further strengthens tenant workload isolation, privacy, and security by encrypting data at rest on underlying host machines. This feature protects sensitive tenant information from unauthorized access. When you turn on end-to-end encryption, temporary disks and ephemeral OS disks are encrypted with platform-managed keys.

In AKS, OS and data disks use server-side encryption with platform-managed keys by default. The disk caches are encrypted at rest through platform-managed keys. You can specify your own [key encryption key](/azure/security/fundamentals/encryption-atrest) to encrypt the [data protection key](/azure/security/fundamentals/encryption-atrest) by using envelope encryption, also known as *wrapping*. The disk caches are also encrypted via the [BYOK](/azure/aks/azure-disk-customer-managed-keys) that you specify.

Host-based encryption provides an extra security layer for multitenant environments. Each tenant's data in OS and data disk caches is encrypted at rest with either customer-managed or platform-managed keys, depending on the selected disk encryption type. For more information, see the following articles:

- [Host-based encryption on AKS](/azure/aks/enable-host-encryption)
- [BYOK with Azure disks in AKS](/azure/aks/azure-disk-customer-managed-keys)
- [Server-side encryption of Azure Disk Storage](/azure/virtual-machines/disk-encryption)

## Networking

The following sections describe networking best practices for multitenant AKS solutions.

### Network topology for multitenant clusters

When you design a network topology for multitenant AKS deployments, your choice between Azure CNI Standard and Azure CNI Overlay affects how you scale tenant workloads and manage IP address space.

Traditional Azure CNI assigns virtual network IP addresses to both nodes and pods. This approach can exhaust available IP address space in large multitenant deployments. Azure CNI Overlay assigns virtual network IP addresses only to nodes, while pods use a separate overlay CIDR. Azure CNI Overlay reduces the risk of virtual network IP address exhaustion and lets you deploy more tenant workloads within the same virtual network address space.

Use Azure CNI Standard for multitenant scenarios in the following cases:

- External systems need direct routable access to pod IP addresses (uncommon for most SaaS multitenancy patterns).

- You use advanced AKS features that don't support Overlay mode.

- Your virtual network has sufficient IP address space and you have few tenant clusters.

Use Azure CNI Overlay for multitenant scenarios in the following cases:

- You deploy multiple dedicated clusters (one per tenant or per tenant tier).

- You deploy multiple AKS clusters in the same virtual network (common for per-tenant or per-tier cluster models).

- You run high pod density in shared clusters with many tenant namespaces.

- You deploy multiple environments (development, staging, production) per tenant.

- IP address space is constrained or you need to reserve virtual network IP addresses for other Azure resources.

- You need to standardize infrastructure templates across many tenant deployments.

When you deploy an automated single-tenant deployment model (dedicated cluster for each tenant), Azure CNI Overlay lets you reuse the same pod CIDR (for example, 10.244.0.0/16) across multiple tenant clusters. This approach eliminates the need to plan, allocate, and track unique pod CIDRs per tenant. You can standardize IaC templates across all tenants. Tenant onboarding is faster because you don't need to coordinate CIDR assignments. This consistent configuration also simplifies troubleshooting and reduces configuration errors.

Azure CNI Overlay provides the same tenant isolation as Azure CNI Standard. Both topologies support all three network policy engines: Azure network policies, Calico, and Azure CNI Powered by Cilium. You can enforce namespace-level network isolation between tenants with either option.

Azure CNI Overlay uses source network address translation (SNAT) to convert tenant pod IP addresses to the node IP address when traffic leaves the cluster. If you need to identify traffic by tenant for external systems or firewall rules, use the following methods to implement tenant-specific egress controls:

- Create dedicated node pools for each tenant and use specific node labels.

- Deploy Azure NAT Gateway that uses multiple public IP addresses and assign different IPs to different node pools.

- Configure Azure Firewall by using user-defined routes (UDRs) that direct tenant traffic through specific rules.

For more information, see [Configure Azure CNI Overlay networking in AKS](/azure/aks/azure-cni-overlay).

### Restrict network access to the API server

In Kubernetes, the API server receives requests to do cluster actions, like creating resources or scaling nodes. When you share an AKS cluster across multiple teams, protect control plane access by using one of the following solutions.

### Private AKS clusters

A private AKS cluster keeps network traffic between your API server and node pools within your virtual network. AKS provides two approaches for private API server access:

- **API Server virtual network integration:** This approach projects the API server endpoint into a delegated subnet in your cluster's virtual network. The API server uses an internal load balancer. Nodes communicate directly with the API server's private IP address. You can allow or block public network access without redeploying the cluster.

- **Private clusters with Azure Private Link:** This approach uses Private Link to create a private endpoint without a public IP address. The API server is accessed only through the private endpoint. You must configure Domain Name System (DNS) through private DNS zones.

  A private AKS cluster restricts control plane access to resources in the same virtual network or connected through virtual network peering, virtual private network, or Azure ExpressRoute. For more information, see [Create a private AKS cluster](/azure/aks/private-clusters).

### Authorized IP address ranges

[Authorized IP address ranges](/azure/aks/api-server-authorized-ip-ranges) improve cluster security and minimize attacks. This approach restricts control plane access on a public AKS cluster to a specific list of IP addresses and CIDR ranges. The API server remains publicly exposed, but only the specified IP addresses have access.

### Private Link integration

[Private Link service](/azure/private-link/private-link-service-overview) is an infrastructure component that lets applications connect privately to services through an [Azure private endpoint](/azure/private-link/private-endpoint-overview). The private endpoint is defined in a virtual network and connects to the front-end IP configuration of an [Azure Load Balancer](/azure/load-balancer/load-balancer-overview) instance. [Private Link](/azure/private-link/private-link-overview) lets service providers securely deliver services to tenants who connect from Azure or on-premises without data exfiltration risks.

Use [Private Link service integration](https://cloud-provider-azure.sigs.k8s.io/topics/pls-integration) to give tenants private connectivity to their AKS-hosted workloads without exposing any public endpoints on the internet.

For more information, see [Multitenancy and Private Link](/azure/architecture/guide/multitenant/service/private-link).

### Reverse proxies

A [reverse proxy](https://en.wikipedia.org/wiki/Reverse_proxy) sits in front of tenant applications to secure, filter, and route incoming requests. It functions as a load balancer and an [API gateway](/azure/architecture/microservices/design/gateway). Reverse proxies support features like load balancing, Secure Sockets Layer (SSL) termination, and layer-7 routing to increase security, performance, and reliability. Popular reverse proxies for Kubernetes include the following implementations:

- [NGINX Ingress Controller](https://kubernetes.github.io/ingress-nginx) is a reverse proxy server that supports load balancing, SSL termination, and layer-7 routing. The Ingress NGINX project retires in March 2026.

- [Traefik Kubernetes Ingress provider](https://doc.traefik.io/traefik/reference/install-configuration/providers/kubernetes/kubernetes-ingress) is a Kubernetes Ingress controller that manages access to cluster services by supporting the ingress specification.

- [HAProxy Kubernetes Ingress Controller](https://www.haproxy.com/documentation/kubernetes-ingress) is a reverse proxy for Kubernetes that supports Transport Layer Security (TLS) termination, URL-path-based routing, and other standard features.

- [Application Gateway for Containers](/azure/application-gateway/for-containers/overview) is a managed application delivery controller (ADC) that provides layer-7 load balancing for AKS-hosted applications. It provides advanced routing capabilities, SSL termination, and web application firewall (WAF) features to protect tenant applications from common web vulnerabilities and attacks. Application Gateway for Containers replaces [AGIC](/azure/application-gateway/ingress-controller-overview). Use Application Gateway for Containers for new deployments. You can use existing AGIC deployments, but you should plan to migrate to Application Gateway for Containers.

When you use an AKS-hosted reverse proxy to secure and handle incoming requests to multiple tenant applications, consider the following recommendations:
- Host the reverse proxy on a dedicated node pool configured to use a VM size that has high network bandwidth and [accelerated networking](/azure/virtual-network/accelerated-networking-overview) turned on.

- Configure the node pool that hosts your reverse proxy for autoscaling.

- Define an autoscaling policy so that ingress controller pods can instantly scale to match traffic fluctuations. This approach avoids increased latency and timeouts for tenant applications.

- Consider sharding incoming traffic to tenant applications, across multiple ingress controller instances, to increase scalability and segregation.

When you use [Application Gateway for Containers](/azure/application-gateway/for-containers/overview), consider the following best practices:

- Deploy separate Application Gateway for Containers instances for different tenant tiers to provide isolation and different service levels. Use the Kubernetes Gateway API role-oriented model, where infrastructure operators manage gateway resources and tenants manage their HTTPRoute resources in their own namespaces.

- Configure cross-namespace routing to let a shared gateway route traffic to back-end services across multiple tenant namespaces while maintaining namespace isolation.

- Use elastic autoscaling, which eliminates the need to manually configure capacity planning.

### Integration with Azure Front Door

[Azure Front Door](/azure/frontdoor/front-door-overview) is a global layer-7 load balancer and cloud content delivery network that provides access between users and web applications. Use Azure Front Door features like request acceleration, SSL termination, response caching, WAF at the edge, URL-based routing, rewrite, and redirections when you expose AKS-hosted multitenant applications to the public internet.

For example, use Azure Front Door to manage multiple custom domains, one for each tenant, and route all traffic to an AKS-hosted multitenant application configured with a single hostname. You can terminate SSL connections at the edge before you route traffic to the back-end application.

:::image type="complex" border="false" source="./media/aks/front-door-and-aks.png" alt-text="Diagram that shows how Azure Front Door and AKS connect." lightbox="./media/aks/front-door-and-aks.png":::
The diagram shows Azure Front Door and AKS. Three hosts point to Azure Front door: invoices.fabrikam.com, payments.worldwideimporters.com, and pay.tailwind.com. Another host called contoso.com points from Azure Front Door to AKS.
:::image-end:::

Configure Azure Front Door to modify the [request origin host header](/azure/frontdoor/front-door-backend-pool#origin-host-header) to match the back-end application's domain name. Azure Front Door propagates the original `Host` header through the `X-Forwarded-Host` header, which the multitenant application code can use to [map the incoming request to the correct tenant](../considerations/map-requests.yml).

[Azure Web Application Firewall](/azure/web-application-firewall/afds/afds-overview) on Azure Front Door provides centralized protection for web applications. Use Azure Web Application Firewall to defend AKS-hosted tenant applications that expose a public endpoint on the internet from malicious attacks.

Configure Azure Front Door Premium to privately connect to tenant applications that run on an AKS cluster through an internal load balancer by using [Private Link](/azure/private-link/private-link-service-overview). For more information, see [Connect Azure Front Door Premium to an internal load balancer origin via Private Link](/azure/frontdoor/standard-premium/how-to-enable-private-link-internal-load-balancer).

### Outbound connections

When AKS-hosted applications connect to many databases or external services, the cluster risks SNAT port exhaustion. [SNAT ports](/azure/load-balancer/load-balancer-outbound-connections#what-are-snat-ports) generate unique identifiers to maintain distinct traffic flows from applications on the same compute resources. Running multiple tenant applications on a shared AKS cluster can generate many outbound calls, which can cause SNAT port exhaustion. AKS clusters can handle outbound connections in three ways:

- **[Azure Load Balancer](/azure/load-balancer/load-balancer-overview):** AKS provisions a Standard SKU load balancer for egress traffic management by default. But the default configuration might not meet all scenario requirements if public IP addresses are disallowed or if extra hops are required for egress. The public load balancer is created with a default public IP address that [outbound rules](/azure/load-balancer/outbound-rules) use. You can use outbound rules to explicitly define SNAT for a public standard load balancer. This configuration lets you use the public IP addresses of your load balancer to provide outbound internet connectivity for your back-end instances. To avoid [SNAT port exhaustion](/azure/load-balancer/troubleshoot-outbound-connection), configure the outbound rules of the public load balancer to use more public IP addresses.

  For more information, see [Use the front-end IP address of a load balancer for outbound via outbound rules](/azure/load-balancer/load-balancer-outbound-connections#outboundrules).

- **[Azure NAT Gateway](/azure/nat-gateway/nat-overview):** Configure an AKS cluster to use Azure NAT Gateway to route egress traffic from tenant applications. Azure NAT Gateway supports up to 64,512 outbound User Datagram Protocol (UDP) and Transmission Control Protocol (TCP) traffic flows per public IP address, with a maximum of 16 IP addresses. To avoid SNAT port exhaustion when you use Azure NAT Gateway to handle outbound connections from an AKS cluster, associate more public IP addresses or a [public IP address prefix](/azure/virtual-network/ip-services/public-ip-address-prefix) with the gateway.

  For more information, see [Azure NAT Gateway considerations for multitenancy](/azure/architecture/guide/multitenant/service/nat-gateway).

- **[UDR](/azure/aks/egress-outboundtype):** Customize an AKS cluster's egress route to support custom network scenarios, like scenarios that disallow public IP addresses and require the cluster to sit behind a network virtual appliance (NVA). When you configure a cluster for [UDR](/azure/aks/egress-outboundtype#outbound-type-of-userdefinedrouting), AKS doesn't automatically configure egress paths. You must configure the egress paths. For example, route egress traffic through an [Azure firewall](/azure/aks/limit-egress-traffic#restrict-egress-traffic-using-azure-firewall).

  Deploy the AKS cluster into an existing virtual network that has a preconfigured subnet and establish explicit egress. Send egress traffic to an appliance, like a firewall, gateway, or proxy. The appliance does network address translation (NAT) by using its assigned public IP address.

If you don't need to route egress through a hub network or security appliance, use Azure NAT Gateway to avoid SNAT port exhaustion.

## Monitoring

[Monitor Kubernetes clusters by using Azure Monitor and cloud-native tools](/azure/azure-monitor/containers/monitor-kubernetes) to observe the health and performance of AKS clusters and tenant workloads. Azure Monitor collects [logs and metrics](/azure/aks/monitor-aks-reference), telemetry analysis, and alerting to proactively detect problems. Use [Azure Managed Grafana](/azure/managed-grafana/quickstart-managed-grafana-portal) to visualize this data.

## Costs

Cost governance is the process of continuously implementing policies to control costs. You can use native Kubernetes tooling to manage and govern resource usage and consumption and to proactively monitor and optimize the underlying infrastructure. When you calculate per-tenant costs, consider costs associated with any resource that tenant applications use. How you charge tenants depends on your solution's tenancy model. The following list describes tenancy model costs in more detail:

- **Fully multitenant:** When a single multitenant application serves all tenant requests, track resource consumption and the number of requests that each tenant generates. Charge your customers accordingly.

- **Dedicated cluster:** When a cluster is dedicated to a single tenant, it's easy to charge the costs of Azure resources back to the customer. The total cost of ownership (TCO) depends on many factors, including VM count and size, network traffic costs, public IP addresses, load balancers, and storage services that the tenant solution uses, like managed disks or Azure Files. Tag an AKS cluster and its resources in the node resource group to simplify cost charging. For more information, see [Add tags to the cluster](/azure/aks/use-tags).

- **Dedicated node pool:** Apply an Azure tag to a new or existing node pool dedicated to a single tenant. The tag applies to each node in the node pool and persists through upgrades. Tags also apply to new nodes added to a node pool during scale-out operations. Tags help with policy tracking and cost charging. For more information, see [Add tags to node pools](/azure/aks/use-tags#add-tags-to-node-pools).

- **Other resources:** Use tags to associate dedicated resource costs with a specific tenant. Tag public IP addresses, files, and disks by using a Kubernetes manifest. These tags preserve their Kubernetes-assigned values even if you update them through other methods. When you remove public IP addresses, files, or disks through Kubernetes, their tags are also removed. Tags on resources that Kubernetes doesn't track remain unaffected. For more information, see [Add tags by using Kubernetes](/azure/aks/use-tags#add-tags-using-kubernetes).

The [AKS cost analysis feature](/azure/aks/cost-analysis) provides a way to deploy a cost allocation tool based on the open-source OpenCost project. The feature displays detailed cost allocation scoped to Kubernetes constructs like clusters and namespaces and to Azure compute, network, and storage resources.

Use open-source tools like [KubeCost](https://www.apptio.com/products/kubecost/?src=kc-com) to monitor and govern costs for an AKS cluster. Scope cost allocation to a deployment, service, label, pod, or namespace to support flexible chargeback or showback to cluster users.

For more information, see the following articles:

- [Cost governance with Kubecost](/azure/cloud-adoption-framework/scenarios/app-platform/aks/cost-governance-with-kubecost)
- [Architectural approaches for cost management and allocation in a multitenant solution](/azure/architecture/guide/multitenant/approaches/cost-management-allocation)
- [Overview of the Cost Optimization pillar](/azure/well-architected/cost-optimization)

## Governance

When multiple tenants share the same infrastructure, managing data privacy, compliance, and regulatory requirements can become complicated. Implement strong security measures and data governance policies. Shared AKS clusters increase the risk of data breaches, unauthorized access, and noncompliance with data protection regulations. Each tenant might have unique data governance requirements and compliance policies, which makes it difficult to ensure data security and privacy.

[Defender for Containers](/azure/defender-for-cloud/defender-for-containers-introduction) is a cloud-native container security solution that provides threat detection and protection for Kubernetes environments. Use this service to enhance data governance and compliance when you host multiple tenants in a Kubernetes cluster. Defender for Containers protects sensitive data, detects and responds to threats by analyzing container behavior and network traffic, and helps meet regulatory requirements. It provides auditing, log management, and report generation to demonstrate compliance to regulators and auditors.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Paolo Salvatori](https://www.linkedin.com/in/paolo-salvatori/)

Other contributors:

- [Bohdan Cherchyk](https://www.linkedin.com/in/cherchyk/) | Senior Customer Engineer
- [Sam Cogan](https://www.linkedin.com/in/samcogan82/) | Senior Cloud Solutions Architect
- [John Downs](https://www.linkedin.com/in/john-downs/) | Principal Software Engineer - Azure Patterns & Practices
- [Ben Griffin](https://www.linkedin.com/in/bengriffin1/) | Senior Partner Solution Architect
- [Chad Kittel](https://www.linkedin.com/in/chadkittel/)  | Principal Software Engineer - Azure Patterns & Practices
- [Arsen Vladimirskiy](https://www.linkedin.com/in/arsenv/) | Principal Customer Engineer

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Related resource

- [Resources for architects and developers of multitenant solutions](../related-resources.md)
