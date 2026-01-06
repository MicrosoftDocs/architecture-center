This article provides a recommended baseline infrastructure architecture to deploy an Azure Kubernetes Service (AKS) cluster. It follows our design principles and aligns with AKS [architectural best practices](/azure/well-architected/service-guides/azure-kubernetes-service) from the [Azure Well-Architected Framework](/azure/well-architected/). The article guides multiple distinct interdisciplinary groups, like networking, security, and identity teams, when they deploy this general-purpose infrastructure.

This architecture doesn't focus on a workload. It concentrates on the AKS cluster itself. This information is the minimum recommended baseline for most AKS clusters. It integrates with Azure services that deliver observability, provide a network topology that supports multi-regional growth, and secure in-cluster traffic.

Your business requirements influence the target architecture and can vary between application contexts. Consider the architecture as your starting point for preproduction and production stages.

Kubernetes is a broad ecosystem that extends beyond Azure and Microsoft technologies. When you deploy an AKS cluster, you're responsible for many decisions about how to design and operate the cluster. Running an AKS cluster involves closed-source components from various vendors, including Microsoft, along with open-source components from the Kubernetes ecosystem. The landscape changes frequently, so revisit decisions regularly. When you adopt Kubernetes, you acknowledge that your workload needs its capabilities and that your workload team is prepared to invest on an ongoing basis.

You can use an implementation of this architecture on [GitHub: AKS baseline reference implementation](https://github.com/mspnp/aks-baseline) as an alternative starting point and configure it to meet your needs.

> [!NOTE]
> The reference architecture requires knowledge of Kubernetes and its concepts. If you need a refresher, see the [Intro to Kubernetes](/training/paths/intro-to-kubernetes-on-azure/) and [Develop and deploy applications on Kubernetes](/training/paths/develop-deploy-applications-kubernetes/) training paths.

:::row:::
    :::column:::

      #### Networking configuration
      [Network topology](#network-topology)\
      [Plan the IP addresses](#plan-the-ip-addresses)\
      [Deploy ingress resources](#deploy-ingress-resources)
    :::column-end:::
    :::column:::

      #### Cluster compute
      [Compute for the base cluster](#configure-compute-for-the-base-cluster)\
      [Container image reference](#container-image-reference)\
      [Policy management](#policy-management)
    :::column-end:::
    :::column:::

      #### Identity management
      [Integrate Microsoft Entra ID for the cluster](#integrate-microsoft-entra-id-for-the-cluster)\
      [Integrate Microsoft Entra ID for the workload](#integrate-microsoft-entra-id-for-the-workload)
    :::column-end:::
:::row-end:::

:::row:::
   :::column:::

      #### Secure data flow
      [Secure the network flow](#secure-the-network-flow)\
      [Add secret management](#add-secret-management)
    :::column-end:::
   :::column:::

      #### Business continuity
      [Scalability](#node-and-pod-scalability)\
      [Cluster and node availability](#business-continuity-decisions)\
      [Availability zones](#availability-zones)
      [Multiple regions](#multiple-regions)
    :::column-end:::
    :::column:::

      #### Operations
      [Cluster and workload CI/CD pipelines](#cluster-and-workload-operations)\
      [Cluster health and metrics](#monitor-and-collect-metrics)\
      [Cost management and reporting](#cost-management)
    :::column-end:::
:::row-end:::

## Architecture

:::image type="complex" border="false" source="images/aks-baseline-architecture.svg" alt-text="Architecture diagram that shows a hub-spoke network topology." lightbox="images/aks-baseline-architecture.svg":::
   The diagram shows two connected virtual networks. The hub virtual network contains Azure Firewall, Azure Bastion, and a gateway subnet to on-premises. The spoke virtual network contains several subnets, the AKS cluster, and node pools. Virtual network peering connects the hub and spoke virtual networks through a bidirectional link. Arrows point from Key Vault and Container Registry to Private Link endpoints subnet. An arrow points from Azure Bastion subnet (management) to the internal load balancer in the spoke virtual network. An arrow points from the on-premises network to the on-premises gateway. A bidirectional arrow labeled virtual network peering points from the hub virtual network to the remote office spoke. An arrow points from the internet to the Azure Application Gateway subnet. An arrow points form the AKS cluster to the Azure Monitor workspace section that includes metrics and Managed Prometheus.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/aks-baseline-architecture.vsdx) of this architecture.*

For more information, see [Hub-spoke network topology in Azure](../../../networking/architecture/hub-spoke.yml).

### Network topology

This architecture uses a hub-and-spoke network topology. Deploy the hub and spokes in separate virtual networks that are connected through [virtual network peering](/azure/virtual-network/virtual-network-peering-overview). This topology has several advantages:

- Enable segregated management. You can apply governance and adhere to the principle of least privilege (PoLP). It also supports the concept of an [Azure landing zone](/azure/cloud-adoption-framework/ready/landing-zone/) with a separation of duties.

- Minimize direct exposure of Azure resources to the public internet.

- Provide regional hub-and-spoke topologies. You can expand hub-and-spoke network topologies in the future and provide workload isolation.

- Employ a web application firewall service to help inspect HTTP traffic flow for all web applications.

- Provide support for workloads that span multiple subscriptions.

- Make the architecture extensible. To accommodate new features or workloads, you can add new spokes instead of redesigning the network topology.

- Support sharing resources, like a firewall and Domain Name System (DNS) zones, across networks.

- Align with the [Azure enterprise-scale landing zone](/azure/cloud-adoption-framework/ready/landing-zone/implementation-options).

### Hub virtual network

The hub virtual network is the central point of connectivity and observability. In this architecture, the hub contains the following features:

- Azure Firewall with global firewall policies that your central IT teams define to enforce organization-wide rules

- Azure Bastion, which establishes a secure tunnel into the private network perimeter so that you can perform cluster management operations

- A gateway subnet for VPN connectivity

- Azure Monitor for network observability

Within the network, the architecture has three subnets.

#### Subnet to host Azure Firewall

[Azure Firewall](/azure/firewall/overview) is a managed firewall service. The Azure Firewall instance secures outbound network traffic. Without this layer of security, the traffic might communicate with a malicious, non-Microsoft service that could exfiltrate sensitive workload data. Use [Azure Firewall Manager](/azure/firewall-manager/overview) to centrally deploy and configure multiple Azure Firewall instances and manage Azure Firewall policies for this *hub virtual network* architecture type.

#### Subnet to host a gateway

This subnet is a placeholder for a VPN gateway or an Azure ExpressRoute gateway. The gateway provides connectivity between the routers in your on-premises network and the virtual network.

#### Subnet to host Azure Bastion

This subnet is used for [Azure Bastion](/azure/bastion/bastion-overview). You can use Azure Bastion to securely access Azure resources without exposing the resources to the internet. This architecture uses Azure Bastion to securely connect to the AKS cluster's API server for management operations. The subnet is for management and operations only.

### Spoke virtual network

The spoke virtual network contains the AKS cluster and other related resources. The spoke has the following subnets.

#### Subnet to host Azure Application Gateway

[Azure Application Gateway](/azure/application-gateway/overview) is a web traffic load balancer that operates at Layer 7. The reference implementation uses the Application Gateway v2 SKU that enables [Azure Web Application Firewall](/azure/web-application-firewall/ag/ag-overview). Web Application Firewall secures incoming traffic from common web traffic attacks, including bots. The instance has a public front-end IP configuration that receives user requests. By design, Application Gateway requires a dedicated subnet.

#### Subnet to host the ingress resources

To route and distribute traffic, [Traefik](https://doc.traefik.io/traefik/) is the ingress controller that fulfills the Kubernetes ingress resources. The Azure internal load balancers exist in this subnet. For more information, see [Use an internal load balancer with AKS](/azure/aks/internal-lb).

#### Subnet to host the cluster nodes

AKS maintains two node pools, which are separate groups of nodes. The system node pool hosts pods that run core cluster services. The user node pool runs your workload and the ingress controller to enable inbound communication to the workload.

#### Subnet to host Azure Private Link endpoints

Create Azure Private Link connections for [Azure Container Registry](/azure/container-registry/container-registry-intro) and [Azure Key Vault](/azure/key-vault/general/overview) so that users can access these services via a [private endpoint](/azure/private-link/private-endpoint-overview) within the spoke virtual network. Private endpoints don't require a dedicated subnet. You can also place private endpoints in the hub virtual network. In the baseline implementation, the endpoints are deployed to a dedicated subnet within the spoke virtual network. This approach reduces traffic that passes through the peered network connection. It keeps the resources that belong to the cluster in the same virtual network. You can also apply granular security rules at the subnet level by using network security groups (NSGs).

For more information, see [Private Link deployment options](../../../networking/guide/private-link-hub-spoke-network.md#choose-the-best-private-link-deployment-configuration).

#### Subnet for the AKS API server

You can configure an AKS cluster to use [API server virtual network integration](/azure/aks/api-server-vnet-integration), which projects the API server endpoint into a delegated subnet in your virtual network. This configuration ensures that all traffic between the API server, node pools, and connected clients remain entirely within your private network. It's a *private cluster*.

All communication between the AKS-managed Kubernetes API server and clients (both cluster-internal and external clients) is restricted to a trusted network.

With a private cluster, you can use NSGs and other built-in network controls to secure your environment. This configuration prohibits any unauthorized public access between the internet and the environment. For more information, see [Create a private AKS cluster](/azure/aks/private-clusters).

## Plan the IP addresses

:::image type="complex" border="false" source="images/aks-baseline-network-topology.svg" alt-text="Diagram that shows the network topology of the AKS cluster." lightbox="images/aks-baseline-network-topology.svg":::
  The diagram shows a simple AKS hub-spoke network topology. The hub has Azure Firewall, Azure Bastion, and a gateway. The spoke has subnets for Application Gateway, ingress, nodes, API server, and private endpoints. Arrows show inbound traffic from the internet to Application Gateway, then to the internal load balancer, ingress controller, and workload pods. Outbound arrows go from the cluster to Azure Firewall. Arrows from private endpoints go to Azure services like Container Registry and Key Vault.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/aks-baseline_network_topology.vsdx) of this architecture.*

This reference architecture uses multiple networking approaches, each of which requires an IP address space:

- Your Azure virtual network that you use for resources like cluster nodes, the cluster's API server, private endpoints for Azure services, and Application Gateway.

- The cluster uses [Azure Container Networking Interface (CNI) Overlay](/azure/aks/azure-cni-overlay), which allocates IP addresses to pods from a separate address space to your Azure virtual network.

### Virtual network IP address space

The address space of your Azure virtual network should be large enough to hold all of your subnets. Account for all entities that receive traffic. Kubernetes allocates IP addresses for the entities from the subnet address space. Consider the following points when you plan your Azure virtual network's IP addresses:

- **Upgrades:** AKS updates nodes regularly to make sure that the underlying VMs are up-to-date on security features and other system patches. During an upgrade process, AKS creates a node that temporarily hosts the pods, while the upgrade node is cordoned and drained. That temporary node receives an IP address from the cluster subnet. Ensure that you have sufficient address space for the temporary node IP addresses.

  In this architecture, pods are allocated IP addresses from within the Azure CNI Overlay pod address space, including during rolling updates. This approach reduces the overall number of IP addresses used from your Azure virtual network compared to other Kubernetes networking approaches.

- **Scalability:** Consider the total number of system and user nodes and their maximum scalability limits. For example, if you want to scale out by 400%, you need four times the number of addresses for all the scaled-out nodes.

  Because this architecture uses Azure CNI Overlay, the scalability of your pods doesn't affect your virtual network's address space.

- **Private Link addresses:** Factor in the addresses that are required for communication with other Azure services over Private Link. This architecture has two addresses assigned for the links to Container Registry and Key Vault.

- **Private cluster API server addresses:** API server virtual network integration helps you to project the AKS API server as an endpoint inside your virtual network. This feature requires a [minimum subnet size](/azure/aks/api-server-vnet-integration), so ensure that you meet these prerequisites during your network planning.

- **Reserved IP addresses:** Azure reserves [specific addresses](/azure/virtual-network/virtual-networks-faq#are-there-any-restrictions-on-using-ip-addresses-within-these-subnets) for its uses. They can't be assigned.

The preceding list isn't exhaustive. If your design has other resources that affect the number of available IP addresses, accommodate those addresses.

This architecture is designed for a single workload. In a production AKS cluster, always separate the system node pool from the user node pool. When you run multiple workloads on the cluster, you might want to isolate the user node pools from each other. This isolation results in more subnets that are smaller in size. The ingress resource might also be more complex. As a result, you might need multiple ingress controllers that each require extra IP addresses.

### Pod IP address space

Azure CNI Overlay assigns IP addresses to pods by using a dedicated address space, which is separate from the address space that you use in your virtual network. Use an IP address space that doesn't overlap with your virtual network or any peered virtual networks. But if you create multiple AKS clusters, you can safely use the same pod address space on each cluster.

Each node receives a /24 address space for its pods. It's important to ensure that the pod address space is sufficiently large. Allow for as many /24 blocks as you need for the number of nodes in your cluster. Remember to include any temporary nodes created during upgrades or scale-out operations. For example, if you use a /16 address space for your classless inter-domain routing (CIDR) range, your cluster can grow to a maximum of about 250 nodes.

Each node supports up to 250 pods, and this limit includes any pods that are temporarily created during upgrades.

### Other IP address space considerations

For the complete set of networking considerations for this architecture, see [AKS baseline network topology](https://github.com/mspnp/aks-baseline/blob/main/network-team/topology.md). For more information about how to plan IP addressing for an AKS cluster, see [Configure Azure CNI networking in AKS](/azure/aks/configure-azure-cni).

## Add-ons and preview features

Kubernetes and AKS continuously evolve, with faster release cycles than software for on‑premises environments. This baseline architecture depends on specific AKS preview features and AKS add-ons. Consider the following differences between preview features and add-ons:

- The AKS team describes preview features as *shipped and improving* because many of the preview features stay in that state for only a few months before they move to the general availability (GA) phase.

- AKS [add-ons and extensions](/azure/aks/integrations#add-ons) provide extra, supported functionality. AKS manages their installation, configuration, and life cycle.

The baseline architecture doesn't include every preview feature or add-on. Instead, it includes only the ones that add significant value to a general-purpose cluster. As these features come out of preview, this baseline architecture is revised accordingly. There are some other preview features or AKS add-ons that you might want to evaluate in preproduction clusters. These features can improve your security, manageability, or other requirements. With non-Microsoft add-ons, you must install and maintain them, which includes tracking available versions and installing updates after you upgrade a cluster's Kubernetes version.

## Container image reference

The cluster might contain the workload and several other images, like the ingress controller. Some of those images might reside in public registries. Consider the following points when you pull the images into your cluster:

- Authenticate the cluster to pull the image.

- If you use a public image, import a public image into the container registry that aligns with your service-level objective (SLO). Otherwise, the image might be subject to unexpected availability problems. If the image is unavailable when you need it, operational problems can occur. Consider the following benefits of using a private container registry, like Container Registry, instead of a public registry:

  - You can block unauthorized access to your images.
  - You don't have public-facing dependencies.
  - You can access image pull logs to monitor activities and triage connectivity problems.
  - You can take advantage of integrated container scanning and image compliance.

- Pull images from authorized registries. You can enforce this restriction through Azure Policy. In this reference implementation, the cluster only pulls images from the dedicated Container Registry instance that deploys with the cluster.

<a name='configure-compute-for-the-base-cluster'></a>

## Configure compute for the base cluster

In AKS, each node pool usually maps to a virtual machine scale set. Nodes are virtual machines (VMs) in each node pool.

Consider using a smaller VM size for the system node pool to minimize costs. This reference implementation deploys the system node pool with three D2dv5 nodes. That size is sufficient to meet the expected load of the system pods. The operating system ephemeral disk is 64 GB.

When you plan capacity for a user node pool, consider the following recommendations:

- Choose larger node sizes to pack the maximum number of pods set on a node. Large nodes minimize the footprint of services that run on all nodes, like monitoring and logging.

- Select the appropriate VM type if you have specific workload requirements. For example, you might need a memory-optimized product for some workloads, or a GPU-accelerated product for others. For more information, see [Sizes for VMs in Azure](/azure/virtual-machines/sizes/overview).

- Deploy at least two nodes so that the workload has a high availability pattern with two replicas. With AKS, you can change the node count without recreating the cluster.

- Plan the actual node sizes for your workload based on the requirements that your design team determines. Based on the business requirements, this architecture uses the D4dv5 SKU for the production workload.

- Assume that your workload consumes up to 80% of each node when you plan capacity for your cluster. The remaining 20% is reserved for AKS services.

- Set the maximum pods for each node based on your capacity planning. If you try to establish a capacity baseline, start with a value of 30. Adjust that value based on the requirements of the workload, the node size, and your IP address constraints.

### Select an operating system

Most AKS clusters use Linux as the operating system for their node pools. In this reference implementation, we use [Azure Linux](/azure/aks/use-azure-linux), which is a lightweight, hardened Linux distribution that's tuned for Azure. You can choose another Linux distribution like Ubuntu if you prefer or if Azure Linux doesn't meet your requirements. If you choose a different operating system, ensure that the OS disk is sized appropriately for that image. Some distributions require more space than Azure Linux, so you might need to increase the disk size to avoid deployment or runtime problems.

If your workload is composed of mixed technologies, you can use different operating systems in different node pools. But if you don't need different operating systems, we recommend that you use a single operating system for all workload node pools to reduce operational complexity.
 
<a name='integrate-microsoft-entra-id-for-the-cluster'></a>
## Integrate Microsoft Entra ID for the cluster

Securing access to and from the cluster is critical. Apply security controls based on how they affect the cluster:

- *Inside-out access:* Consider AKS access to Azure components like networking infrastructure, Container Registry, and Key Vault. Authorize only the resources that the cluster should be allowed to access.

- *Outside-in access:* Provide identities access to the Kubernetes cluster. Authorize only those external entities that are allowed access to the Kubernetes API server and Azure Resource Manager.

### AKS access to Azure components

There are two ways to manage AKS to Azure access through Microsoft Entra ID: *service principals* or *managed identities* for Azure resources.

Of the two methods to manage AKS access to Azure, we recommend managed identities. With service principals, you must manage and rotate secrets, either manually or programmatically. With managed identities, Microsoft Entra ID manages and performs the authentication and timely rotation of secrets for you.

We recommend that you enable and use [managed identities in AKS](/azure/aks/use-managed-identity) so that the cluster can interact with external Azure resources through Microsoft Entra ID. If you don't use Microsoft Entra ID integration immediately, you can add it later.

By default, the cluster uses two primary identities: the *cluster identity* and the *kubelet identity*. The AKS control plane components use the *cluster identity* to manage cluster resources, including ingress load balancers, and AKS managed public IP addresses. The *kubelet identity* authenticates with Container Registry. Some add-ons also support authentication by using a managed identity.

You should use managed identities when the cluster needs to pull images from a container registry. This action requires the cluster to get the registry credentials. If you don't use a managed identity, you might store that information in a Kubernetes secret and use `imagePullSecrets` to retrieve it. We don't recommend this approach because it introduces security complexities, including the need to know the secret in advance and to store it in the DevOps pipeline. It also adds operational overhead because you must rotate the secret. To address these concerns, grant `AcrPull` access to the kubelet managed identity of the cluster to your registry.

In this architecture, the cluster accesses Azure resources that Microsoft Entra ID secures and the cluster performs operations that support managed identities. Assign Azure role-based access control (Azure RBAC) and permissions to the cluster's managed identities, depending on the operations that the cluster does. The cluster authenticates itself to Microsoft Entra ID and then is allowed or denied access based on the roles assigned to it. Here are some examples from this reference implementation where Azure built-in roles are assigned to the cluster:

- The [Network Contributor role](/azure/role-based-access-control/built-in-roles#network-contributor) manages the cluster's ability to control the spoke virtual network. With this role assignment, the AKS cluster system-assigned identity can work with the dedicated subnet for the internal ingress controller service and AKS private API server.

- The [Private DNS Zone Contributor role](/azure/role-based-access-control/built-in-roles/networking#private-dns-zone-contributor) manages the cluster's ability to link the zone directly to the spoke virtual network that hosts the cluster. A private cluster keeps DNS records off the public internet by using a private DNS zone. But it's still possible to create a private AKS cluster with a public DNS address. We recommend that you *explicitly* prohibit this feature by setting `enablePrivateClusterPublicFQDN` to `false` to prevent disclosure of your control plane's private IP address. Consider using Azure Policy to enforce the use of private clusters without public DNS records.

- The [Monitoring Metrics Publisher role](/azure/role-based-access-control/built-in-roles#monitoring-metrics-publisher) manages the cluster's ability to send metrics to Azure Monitor.

- The [AcrPull role](/azure/role-based-access-control/built-in-roles#acrpull) manages the cluster's ability to pull images from the specified Container Registry instances.

### Cluster access

Microsoft Entra integration also simplifies security for outside-in access. For example, you might want to use kubectl. As an initial step, you can run the `az aks get-credentials` command to get the credentials of the cluster. Microsoft Entra ID authenticates your identity against the Azure roles that are allowed to get cluster credentials. For more information, see [Available cluster roles permissions](/azure/aks/control-kubeconfig-access#available-permissions-for-cluster-roles).

AKS supports Kubernetes access through Microsoft Entra ID by using Microsoft Entra ID as an identity provider integrated with native Kubernetes RBAC or by using native Azure RBAC to control cluster access. The following sections detail both approaches.

#### Associate Kubernetes RBAC with Microsoft Entra ID

Kubernetes supports RBAC through the following API objects:

- A set of permissions that you define by using a `Role` or `ClusterRole` object for cluster-wide permissions.

- Bindings that assign users and groups who have permission to do the actions. Define bindings by using a `RoleBinding` or `ClusterRoleBinding` object.

Kubernetes has some built-in roles like cluster-admin, edit, and view. Bind those roles to Microsoft Entra users and groups to use the enterprise directory to manage access. For more information, see [Use Kubernetes RBAC with Microsoft Entra integration](/azure/aks/azure-ad-rbac).

Be sure that you include the Microsoft Entra groups for cluster and namespace access in your [Microsoft Entra access reviews](/entra/id-governance/access-reviews-overview).

#### Use Azure RBAC for Kubernetes authorization

We recommend that you use Azure RBAC and Azure role assignments to enforce authorization checks on the cluster. This authorization approach integrates with Microsoft Entra authentication. You can assign roles at the management group, subscription, or resource group scopes. All clusters under the scope then inherit a consistent set of role assignments with respect to who has permissions to access the objects on the Kubernetes cluster.

We don't recommend using Kubernetes-native RBAC with [ClusterRoleBindings and RoleBindings](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#rolebinding-and-clusterrolebinding).

For more information, see [Azure RBAC for Kubernetes authorization](/azure/aks/manage-azure-rbac).

#### Local accounts

AKS supports native [Kubernetes user authentication](https://kubernetes.io/docs/reference/access-authn-authz/authentication/#users-in-kubernetes). We don't recommend that you use this method to provide user access to clusters. This method is certificate-based and performed externally to your primary identity provider, which makes your centralized user access control and governance difficult. Always manage access to your cluster by using Microsoft Entra ID, and configure your cluster to explicitly prohibit local account access.

In this reference implementation, local cluster accounts access is explicitly prohibited when the system deploys the cluster.

<a name='integrate-microsoft-entra-id-for-the-workload'></a>

## Integrate Microsoft Entra ID for the workload

Similar to having an Azure system-assigned managed identity for the entire cluster, you can assign managed identities at the pod level. A workload identity enables the hosted workload to access resources through Microsoft Entra ID. For example, suppose that the workload stores files in Azure Storage. When it needs to access those files, the pod authenticates itself against the resource as an Azure managed identity.

In this reference implementation, [Microsoft Entra Workload ID on AKS](/azure/aks/workload-identity-overview) provides the managed identities for pods. This approach integrates with the Kubernetes-native capabilities to federate with external identity providers. For more information, see [Workload identity federation](/entra/workload-id/workload-identity-federation).

## Select a networking model

[!INCLUDE [kubenet retirement](~/reusable-content/ce-skilling/azure/includes/aks/includes/preview/retirement/kubenet-retirement-callout.md)]

AKS supports multiple networking models, including kubenet, CNI, and Azure CNI Overlay. The CNI models are the more advanced models, and provide high performance. When they communicate between pods, the performance of CNI is similar to the performance of VMs in a virtual network. CNI also provides enhanced security control because it enables the use of Azure network policy. We recommend a CNI-based networking model.

In the nonoverlay CNI model, every pod gets an IP address from the subnet address space. Resources within the same network (or peered resources) can access the pods directly through their IP address. Network address translation (NAT) isn't needed to route that traffic.

In this reference implementation, we use Azure CNI Overlay. It only allocates IP addresses from the node pool subnet for the nodes and uses an optimized overlay layer for pod IPs. Because Azure CNI Overlay uses fewer virtual network IP addresses than many other approaches, we recommend it for IP address-constrained deployments.

For more information about the models, see [Configure Azure CNI Overlay networking in AKS](/azure/aks/azure-cni-overlay#choosing-a-network-model-to-use) and [Best practices for network connectivity and security in AKS](/azure/aks/operator-best-practices-network#choose-the-appropriate-network-model).

<a name='deploy-ingress-resources'></a>

## Deploy ingress resources

Kubernetes ingress resources handle routing and distributing for incoming traffic to the cluster. There are two parts of ingress resources:

- **The internal load balancer that AKS manages:** The load balancer exposes the ingress controller through a private static IP address. It serves as single point of contact that receives inbound flows.

  This architecture uses Azure Load Balancer. Load Balancer is outside the cluster in a subnet dedicated for ingress resources. It receives traffic from Application Gateway and that communication is over transport layer security (TLS). For more information about TLS encryption for inbound traffic, see the [Ingress traffic flow](#ingress-traffic-flow) section.

- **The ingress controller:** This example uses Traefik. It runs in the user node pool in the cluster. It receives traffic from the internal load balancer, terminates TLS, and forwards it to the workload pods over HTTP.

The ingress controller is a critical component of the cluster. Consider the following points when you configure this component.

- Constrain the ingress controller to a specific scope of operations as part of your design decisions. For example, you might allow the controller to only interact with the pods that run a specific workload.

- Avoid placing replicas on the same node to spread out the load and help ensure business continuity if a node fails. Use `podAntiAffinity` for this purpose.

- Constrain pods to be scheduled only on the user node pool by using `nodeSelectors`. This setting isolates workload and system pods.

- Open ports and protocols that let specific entities send traffic to the ingress controller. In this architecture, Traefik only receives traffic from Application Gateway.

- Configure `readinessProbe` and `livenessProbe` settings that monitor the health of the pods at the specified interval. The ingress controller should send signals that indicate the health of pods.

- Consider restricting the ingress controller's access to specific resources and limiting the actions that it can perform. You can implement that restriction through Kubernetes RBAC permissions. For example, in this architecture, Traefik is granted permissions to watch, get, and list services and endpoints by using rules in the Kubernetes `ClusterRole` object.

> [!NOTE]
> Choose an appropriate ingress controller based on your requirements, workload, team's skill set, and the supportability of the technology options. Most importantly, your ingress controller must meet your SLO expectation.
>
> Traefik is an open-source option for a Kubernetes cluster and is in this architecture for illustrative purposes. It shows non-Microsoft product integration with Azure services. For example, the implementation shows how to integrate Traefik with Microsoft Entra Workload ID and Key Vault.
>
> You can also use [Application Gateway Ingress Controller](/azure/application-gateway/ingress-controller-overview), which integrates well with AKS. Application Gateway provides benefits beyond its role as an ingress controller. It serves as the virtual network entry point for your cluster and can observe traffic entering the cluster. Use Application Gateway if your application requires a web application firewall. It also enables TLS termination.

### Router settings

The ingress controller uses routes to determine where to send traffic. Routes specify the source port at which the traffic is received and information about the destination ports and protocols.

Here's an example from this architecture:

Traefik uses the Kubernetes provider to configure routes. The `annotations`, `tls`, and `entrypoints` options indicate that routes are served over HTTPS. The `middlewares` option specifies that only traffic from the Application Gateway subnet is allowed. The responses use gzip encoding if the client accepts. Because Traefik does TLS termination, communication with the back-end services is over HTTP.

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: aspnetapp-ingress
  namespace: a0008
  annotations:
    kubernetes.io/ingress.allow-http: "false"
    kubernetes.io/ingress.class: traefik-internal
    traefik.ingress.kubernetes.io/router.entrypoints: websecure
    traefik.ingress.kubernetes.io/router.tls: "true"
    traefik.ingress.kubernetes.io/router.tls.options: default
    traefik.ingress.kubernetes.io/router.middlewares: app-gateway-snet@file, gzip-compress@file
spec:
  tls:
  - hosts:
      - bu0001a0008-00.aks-ingress.contoso.com
  rules:
  - host: bu0001a0008-00.aks-ingress.contoso.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: aspnetapp-service
            port:
              number: 80
```

## Secure the network flow

In this architecture, the network flow includes the following types of traffic:

- **Ingress traffic** from the client to the workload that runs in the cluster.

- **Egress traffic** from a pod or node in the cluster to an external service.

- **Pod-to-pod traffic** between pods. This traffic includes communication between the ingress controller and the workload. If your workload is composed of multiple applications deployed to the cluster, communication between those applications also falls into this category.

- **Management traffic** between the client and the Kubernetes API server.

:::image type="complex" border="false" source="images/traffic-flow.svg" alt-text="Diagram that shows the cluster traffic flow." lightbox="images/traffic-flow.svg":::
  The diagram illustrates three distinct traffic patterns within the architecture.  The hub has Azure Firewall, Azure Bastion, a gateway, and Azure Monitor. The spoke has the AKS cluster with Application Gateway at the entry. Green arrows show inbound traffic from the internet through Application Gateway, internal load balancer, ingress controller, and to workload pods. Orange arrows show pod-to-pod traffic within the cluster. Red arrows show outbound traffic from the cluster to Azure Firewall. Arrows from private endpoints point to Container Registry and Key Vault.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/secure-baseline-aks-traffic-flow.vsdx) of this architecture.*

This architecture has several layers of security to secure all types of traffic.

### Ingress traffic flow

The architecture only accepts TLS encrypted requests from the client. TLS v1.2 is the minimum allowed version with a restricted set of ciphers. Server Name Indication (SNI) strict matching is enabled. End-to-end TLS is set up through Application Gateway by using two different TLS certificates, as shown in the following diagram.

:::image type="complex" border="false" source="images/tls-termination.svg" alt-text="Diagram that shows TLS termination." lightbox="images/tls-termination.svg":::
  The diagram shows an end-to-end TLS traffic flow from client to workload. A client sends HTTPS traffic to Application Gateway. An arrow from Key Vault to Application Gateway shows certificate retrieval. Application Gateway terminates TLS, then re-encrypts traffic (HTTPS) to the internal load balancer. Another arrow from Key Vault to the ingress controller shows certificate retrieval via CSI driver. The internal load balancer forwards encrypted traffic to the ingress controller, which terminates TLS. A final arrow shows HTTP traffic from the ingress controller to workload pods. Each TLS termination point is marked.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/secure-baseline-aks-tls-termination.vsdx) of this architecture.*

1. The client sends an HTTPS request to the domain name: `bicycle.contoso.com`. That name is associated with a DNS A record to the public IP address of Application Gateway. This traffic is encrypted to help ensure that the traffic between the client browser and gateway can't be inspected or changed.

1. Application Gateway has an integrated web application firewall and negotiates the TLS handshake for `bicycle.contoso.com`, allowing only secure ciphers. Application Gateway is a TLS termination point, which is important because Application Gateway's web application firewall needs to inspect the plaintext request and response. Key Vault stores the TLS certificate. The cluster accesses it with a user-assigned managed identity that integrates with Application Gateway. For more information, see [TLS termination with Key Vault certificates](/azure/application-gateway/key-vault-certs).

   Application Gateway processes web application firewall inspection rules and runs routing rules that forward the traffic to the configured back end.

1. As traffic moves from Application Gateway to the back end, it's encrypted again with another TLS certificate, which is a wildcard for `*.aks-ingress.contoso.com`, because it forwards to the internal load balancer. This re-encryption helps ensure that unsecured traffic doesn't flow into the cluster subnet.

1. The ingress controller receives the encrypted traffic through the load balancer. The controller is another TLS termination point for `*.aks-ingress.contoso.com` and forwards the traffic to the workload pods over HTTP. The certificates are stored in Key Vault, and the Container Storage Interface (CSI) driver mounts them into the cluster. For more information, see [Add secret management](#add-secret-management).

You can implement end-to-end TLS traffic at every hop through the workload pod. Be sure to measure the performance, latency, and operational effects when making the decision to secure pod-to-pod traffic. For most single-tenant clusters, with proper control plane RBAC and mature software development life cycle practices, it's sufficient to TLS encrypt up to the ingress controller and protect with Web Application Firewall. This approach minimizes overhead in workload management and overhead because of poor network performance. Your workload and compliance requirements dictate where you perform [TLS termination](/azure/application-gateway/ssl-overview#tls-termination).

### Egress traffic flow

In this architecture, we recommend that all egress traffic from the cluster go through Azure Firewall. You can also use your own similar network virtual appliance. We don't recommend other egress options, like [Azure NAT Gateway](/azure/nat-gateway/nat-gateway-resource) or an [HTTP proxy](/azure/aks/http-proxy) because they don't provide network traffic inspection. For Zero Trust control and the ability to inspect traffic, send all egress traffic through Azure Firewall. Implement this configuration with user-defined routes (UDRs). The next hop of the route is the [private IP address](/azure/virtual-network/ip-services/private-ip-addresses) of Azure Firewall. Azure Firewall decides whether to block or allow the egress traffic based on the rules that you define in Azure Firewall or the built-in threat intelligence rules.

An alternative to Azure Firewall is to use the AKS HTTP proxy feature. All traffic that leaves the cluster goes to the IP address of the HTTP proxy, which forwards the traffic or drops it.

For either method, review the required [egress network traffic rules](/azure/aks/limit-egress-traffic) for AKS.

> [!NOTE]
> If you use a public load balancer as your public point for ingress traffic and egress traffic through Azure Firewall using UDRs, you might see an [asymmetric routing scenario](/azure/aks/limit-egress-traffic#allow-inbound-traffic-through-azure-firewall). This architecture uses internal load balancers in a dedicated ingress subnet behind Application Gateway. This design choice enhances security and also eliminates asymmetric routing concerns. Or you can route ingress traffic through Firewall before or after Application Gateway, but this approach isn't necessary for most situations, and we don't recommend it. For more information about asymmetric routing, see [Integrate Firewall with an Azure standard load balancer](/azure/firewall/integrate-lb#asymmetric-routing).

An exception to the Zero Trust control is when the cluster needs to communicate with other Azure resources. For example, the cluster might need to pull an updated image from the container registry or secrets from Key Vault. In these scenarios, we recommend that you use [Private Link](/azure/private-link/private-link-overview).

The advantage is that specific subnets reach the service directly, and the traffic between the cluster and the services doesn't go over the internet. A downside is that Private Link needs extra configuration instead of using the target service over its public endpoint. Also, not all Azure services or products support Private Link. For those cases, consider enabling a [virtual network service endpoint](/azure/virtual-network/virtual-network-service-endpoints-overview) on the subnet to access the service.

If Private Link or service endpoints aren't an option, you can reach other services through their public endpoints and control access through Azure Firewall rules and the firewall built into the target service. Because this traffic goes through the static IP addresses of the firewall, you can add those addresses to the service's IP allow list.

One downside is that Azure Firewall then needs more rules to make sure it allows only traffic from a specific subnet. Factor in those addresses when you plan to use multiple IP addresses for egress traffic with Azure Firewall. Otherwise, you could reach port exhaustion. For more information about how to plan for multiple IP addresses, see [Create an Azure Firewall with multiple IP addresses](/azure/firewall/quick-create-multiple-ip-bicep).

### Pod-to-pod traffic

By default, a pod can accept traffic from any other pod in the cluster. Use Kubernetes `NetworkPolicy` to restrict network traffic between pods. Apply policies carefully, or you might have a situation where a critical network flow is blocked. *Only* allow specific communication paths, as needed, like traffic between the ingress controller and workload. For more information, see [Network policies](/azure/aks/use-network-policies).

Enable network policy when you set up the cluster because you can't add it later. You have a few choices for technologies that implement `NetworkPolicy`. We recommend Azure network policy, which requires Azure CNI. Other options include Calico network policy, a well-known open-source option. Consider Calico if you need to manage cluster-wide network policies. Calico isn't covered under standard Azure support.

For more information, see [Differences between Azure network policy engines](/azure/aks/use-network-policies#differences-between-network-policy-engines-cilium-azure-npm-and-calico).

### Management traffic

As part of running the cluster, the Kubernetes API server receives traffic from resources that want to do management operations on the cluster, like requests to create resources to scale the cluster. Examples of those resources include the build agent pool in a DevOps pipeline, an Azure Bastion instance within the Azure Bastion subnet, and the node pools themselves. Instead of accepting this management traffic from all IP addresses, we recommend that you set up a private AKS cluster.

For more information, see [Define API server-authorized IP ranges](/azure/aks/api-server-authorized-ip-ranges).

We recommend that you deploy your AKS cluster as a private cluster. All control plane and node pool traffic remain on your private network and isn't exposed to the public internet. This reference implementation sets up a private cluster by using API server virtual network integration.

Private traffic to a private AKS cluster might originate from the spoke virtual network, from peered networks, or from private endpoints in remote networks. Although the AKS nodes naturally live in the spoke, clients doing administrative tasks require a dedicated network path to reach the AKS API server privately. You can establish this connectivity in the following ways:

- Use Azure Bastion to open a tunnel to the AKS API server.
- Connect to a jump-box VM through Azure Bastion.

In the reference implementation, we use Azure Bastion to tunnel to the AKS API server when performing cluster management operations.

Lower environments might consider relaxing this private cluster recommendation for convenience. But production AKS clusters should always be deployed as private clusters for a secure deployment baseline.

## Add secret management

Store secrets in a managed key store, like Key Vault. The advantage is that a managed key store handles secret rotation. It provides strong encryption and an access audit log. It also keeps core secrets out of the deployment pipeline. In this architecture, a Key Vault firewall is enabled and configured, and Private Link is in place when resources in Azure connect to Key Vault to access secrets and certificates.

Key Vault is well integrated with other Azure services. Use the built-in feature of those services to access secrets. For more information about how Application Gateway accesses TLS certificates for the ingress flow, see the [Ingress traffic flow](#ingress-traffic-flow) section.

The Azure RBAC permission model for Key Vault enables you to assign the workload identities to either the Key Vault Secrets User or Key Vault Reader role assignment, and access the secrets. For more information, see [Access Key Vault by using Azure RBAC](/azure/key-vault/general/rbac-guide).

### Access cluster secrets

You must use workload identities to allow a pod to access secrets from a specific store. To facilitate the retrieval process, use a [secrets store CSI driver](https://github.com/kubernetes-sigs/secrets-store-csi-driver). When the pod needs a secret, the driver connects with the specified store, retrieves a secret on a volume, and mounts that volume in the cluster. The pod can then get the secret from the volume file system.

The CSI driver has many providers to support various managed stores. This implementation uses the [Key Vault with secrets store CSI driver](/azure/aks/csi-secrets-store-driver). The add-on retrieves the TLS certificate from Key Vault and loads the driver in the pod that runs the ingress controller. This operation occurs during pod creation, and the volume stores both public and the private keys.

## Workload storage

The workload in this architecture is stateless. If you must store state, we recommend that you persist it outside the cluster. Guidance for workload state is outside the scope of this article.

For more information, see [Storage options for applications in AKS](/azure/aks/concepts-storage).

## Policy management

An effective way to manage an AKS cluster is to enforce governance through policies. Kubernetes implements policies through Open Policy Agent (OPA) Gatekeeper. For AKS, deliver policies through Azure Policy. Each policy applies to all clusters in its scope. OPA Gatekeeper handles policy enforcement in the cluster and it logs all policy checks. The policy changes aren't immediately reflected in your cluster, so expect some delays.

To manage your AKS clusters, you can use Azure Policy in several ways:

- Prevent or restrict the deployment of AKS clusters in a resource group or subscription. Apply standards for your organization. For example, you can follow a naming convention or specify a tag.

- Secure your AKS cluster through Azure Policy for Kubernetes.

A common example of where a policy can be useful is around governance and validation of container images. Container images can be a source of vulnerabilities, and some organizations require that untrusted container images are validated by using a container image scanning tool, and then approved, before they can be used in a production cluster. You can enforce this process by using Azure Policy, and block untrusted container images from being deployed to the cluster. For more information, see the [Quarantine pattern](../../../patterns/quarantine.yml).

When you set policies, apply them based on the requirements of the workload. Consider these factors:

- Decide whether to set a collection of policies, known as *initiatives*, or to choose individual policies. Azure Policy provides two built-in initiatives: basic and restricted. Each initiative is a collection of built-in policies applicable to an AKS cluster. We recommend that you select an initiative *and* choose other policies for the cluster and the resources, like Container Registry, Application Gateway, or Key Vault, which interact with the cluster. Choose policies based on the requirements of your organization.

- Decide if you want to **Audit** or **Deny** the action. In **Audit** mode, the action is allowed but flagged as **Non-Compliant**. Have processes to check noncompliant states at a regular cadence and take necessary action. In **Deny** mode, the action is blocked because it violates the policy. Be careful when you choose Deny mode because it can be too restrictive for the workload to function.

- Decide if you have areas in your workload that shouldn't be compliant by design. Azure Policy can specify Kubernetes namespaces that are exempt from policy enforcement. We recommend that you still apply policies in **Audit** mode so that you're aware of those instances.

- Decide if you have requirements that aren't covered by the built-in policies. You can create a custom Azure Policy definition that applies your custom OPA Gatekeeper policies. Don't apply custom policies directly to the cluster. For more information, see [Create and assign custom policy definitions](/azure/aks/use-azure-policy#create-and-assign-a-custom-policy-definition).

- Decide if you have organization-wide requirements. If so, add those policies at the management group level. Your cluster should also assign its own workload-specific policies, even if your organization has generic policies.

- Decide if you must assign Azure policies to specific scopes. Ensure that the *production* policies are also validated against your *preproduction* environment. Otherwise, when you deploy to your production environment, you might run into unexpected extra restrictions that you didn't account for in preproduction.

This reference implementation enables Azure Policy when the AKS cluster is created. The restrictive initiative is assigned in **Audit** mode to gain visibility into noncompliance.

The implementation also sets extra policies that aren't part of any built-in initiatives. Those policies are set in **Deny** mode. For example, there's a policy in place to make sure images are only pulled from the deployed Container Registry instance.

Consider creating your own custom initiatives. Combine the policies that are applicable for your workload into a single assignment.

To observe how Azure Policy functions from within your cluster, you can access the pod logs for all pods in the `gatekeeper-system` namespace and the logs for the `azure-policy` and `azure-policy-webhook` pods in the `kube-system` namespace.
 
<a name="node-and-pod-scalability"></a>
## Node and pod scalability

With increasing demand, Kubernetes can scale out by adding more pods to existing nodes, through horizontal pod autoscaling. When Kubernetes can no longer schedule more pods, the number of nodes must be increased through AKS cluster autoscaling. A complete scaling solution must have ways to scale both pod replicas and the node count in the cluster.

There are two approaches: autoscaling or manual scaling.

Both the autoscaling and manual approach require you to monitor and set alerts on CPU usage or custom metrics. For pod scaling, your application operator can increase or decrease the number of pod replicas by adjusting the `ReplicaSet` through Kubernetes APIs. For cluster scaling, one method is to be notified when the Kubernetes scheduler fails. Another way is to watch for pending pods over time. You can adjust the node count through the Azure CLI or the Azure portal.

We recommend that you use the autoscaling approach because some of the manual mechanisms are built into the autoscaler.

As a general method, start by performance testing with a minimum number of pods and nodes. Use those values to establish the baseline expectation. Then, use a combination of performance metrics and manual scaling to locate bottlenecks and understand the application's response to scaling. Finally, use this data to set the parameters for autoscaling.

### Horizontal Pod Autoscaler

The [Horizontal Pod Autoscaler (HPA)](https://kubernetes.io/docs/concepts/workloads/autoscaling/horizontal-pod-autoscale/) is a Kubernetes resource that scales the number of pods.

In the HPA resource, we recommend that you set the minimum and maximum replica count. The values constrain the autoscaling bounds.

  The HPA can scale based on CPU usage, memory usage, and custom metrics. Only CPU usage is provided natively. The `HorizontalPodAutoscaler` definition specifies target values for the metrics. For instance, the spec sets the target CPU usage. While pods are running, the HPA controller uses the Kubernetes Metrics API to check each pod's CPU usage. It compares that value against the target usage and calculates a ratio. It then uses the ratio to determine whether pods are overallocated or underallocated. It relies on the Kubernetes scheduler to assign new pods to nodes or remove pods from nodes.

A race condition might occur, like when the HPA checks before a scaling operation finishes. So, the outcome could be an incorrect ratio calculation. For more information, see [Cooldown of scaling events](/azure/aks/concepts-scale#cooldown-of-scaling-events).

If your workload is event-driven, a popular open-source option is [Kubernetes event-driven autoscaling (KEDA)](https://keda.sh/). Consider KEDA if an event source, like message queue, drives your workload, rather than your workload being CPU-bound or memory-bound. KEDA supports many event sources or scalers. Use the list of event sources that KEDA can scale at [KEDA scalers](https://keda.sh/#scalers). The list includes the [Azure Monitor scaler](https://keda.sh/docs/latest/scalers/azure-monitor/), which is a convenient way to scale KEDA workloads based on Azure Monitor metrics.

### Cluster autoscaler

The [cluster autoscaler](/azure/aks/cluster-autoscaler) is an AKS add-on component that scales the number of nodes in a node pool. Add it during cluster provisioning. You need a separate cluster autoscaler for each user node pool.

The Kubernetes scheduler triggers the cluster autoscaler. When the Kubernetes scheduler fails to schedule a pod because of resource constraints, the autoscaler automatically sets up a new node in the node pool. Conversely, the cluster autoscaler checks the unused capacity of the nodes. If the node doesn't run at an expected capacity, the pods are moved to another node, and the unused node is removed.

When you enable the autoscaler, set the maximum and minimum node count. The recommended values depend on the performance expectation of the workload, how much you want the cluster to grow, and cost implications. The minimum number is the reserved capacity for that node pool. In this reference implementation, the minimum value is set to two because of the simplicity of the workload.

For the system node pool, the recommended minimum value is three.

 
<a name="business-continuity-decisions"></a>
## Business continuity decisions

To maintain business continuity, define the SLO for the infrastructure and your application. For more information, see [Recommendations for defining reliability targets](/azure/well-architected/reliability/metrics). Review the service-level agreement (SLA) conditions for AKS in the latest [SLA for online services](https://www.microsoft.com/licensing/docs/view/Service-Level-Agreements-SLA-for-Online-Services) article.

### Cluster nodes

To meet the minimum level of availability for workloads, you need multiple nodes in a node pool. If a node fails, another node in the same node pool and cluster can continue running the application. For reliability, we recommend three nodes for the system node pool. For the user node pool, start with no fewer than two nodes. If you need higher availability or capacity, set up more nodes.

Isolate your application from the system services by placing it in a separate node pool, referred to as a *user node pool*. This way, Kubernetes services run on dedicated nodes and don't compete with your workload. We recommend that you use tags, labels, and taints to identify the node pool and schedule your workload. Ensure that your system node pool is tainted with the [CriticalAddonsOnly taint](/azure/aks/use-system-pools#system-and-user-node-pools) to prevent application pods from being scheduled on system node pools.

Regular upkeep tasks on your cluster, like timely updates, are crucial for reliability. Also, we recommend that you monitor the health of the pods through probes.

### Pod availability

- **Specify pod resource requirements:** We recommended that you specify pod resource requirements in your deployments. The scheduler can then appropriately schedule the pod. Reliability is greatly reduced if your pods can't be scheduled.

- **Set pod disruption budgets:** This setting determines how many replicas in a deployment can come down during an update or upgrade event. For more information, see [Pod disruption budgets](/azure/aks/operator-best-practices-scheduler#plan-for-availability-using-pod-disruption-budgets).

  Configure multiple replicas in the deployment to handle disruptions like hardware failures. For planned events like updates and upgrades, a disruption budget can help ensure the required number of pod replicas exist to handle expected application load.

- **Set resource quotas on the workload namespaces:** The resource quota on a namespace helps ensure that pod requests and limits are properly set on a deployment. For more information, see [Enforce resource quotas](/azure/aks/operator-best-practices-scheduler#enforce-resource-quotas).

  > [!NOTE]
  > If you set resources quotas at the cluster level, problems can occur if you deploy non-Microsoft workloads that don't have proper requests and limits. When you set quotas at the namespace level, it ensures that they only apply to your workload components.

- **Set pod requests and limits:** Set requests and limits to enable Kubernetes to efficiently allocate CPU and memory resources to the pods. It gives you higher container density on a node. Requests and limits can also increase your reliability while reducing your costs because of better hardware usage.

  To estimate the limits for a workload, test and establish a baseline. Start with equal values for requests and limits. Then gradually tune those values until you establish the threshold that causes instability in the cluster.

  You can specify requests and limits in your deployment manifests. For more information, see [Set pod requests and limits](/azure/aks/developer-best-practices-resource-management#define-pod-resource-requests-and-limits).

 
<a name="availability-zones"></a>
### Availability zones

To protect against some types of outages, use [availability zones](/azure/aks/availability-zones) if the region supports them. Both the control plane components and the nodes in the node pools are then *zone-redundant*, which means they're spread across multiple zones. If an entire zone is unavailable, a node in another zone within the region is still available. Each node pool maps to a separate virtual machine scale set, which manages node instances and scalability. The AKS service manages scale set operations and configuration. Here are some considerations when you enable multiple zones:

- **Entire infrastructure:** Choose a region that supports availability zones. For more information, see [Limitations](/azure/aks/reliability-availability-zones-configure#limitations). To have an uptime SLA, you need to choose the Standard or Premium tier. The uptime SLA is greater when you use availability zones.

- **Cluster:** You can only set availability zones when you create the node pool. They can't be changed later. The node sizes should be supported in all zones so that the expected distribution is possible. The underlying virtual machine scale set provides the same hardware configuration across zones.

    Zone redundancy not only applies to node pools, but the control plane as well. The AKS control plane spans the zones requested, like the node pools. If you don't use zone support in your cluster, the control plane components aren't guaranteed to spread across availability zones.

- **Dependent resources:** To achieve the resiliency benefit of using availability zones, all service dependencies must also support zones. If a dependent service doesn't support zones, it's possible that a zone failure can cause that service to fail.

    For example, suppose your workload uses a database that isn't zone-resilient. If a failure occurs, the AKS node might move to another zone, but the database doesn't move with the node to that zone, so your workload is disrupted.

For simplicity in this architecture, AKS is deployed to a single region with node pools that span availability zones one, two, and three. Other resources of the infrastructure, like Azure Firewall and Application Gateway, are also deployed to the same region with multiple zone support. Geo-replication is enabled for Container Registry.

 
<a name="multiple-regions"></a>
### Multiple regions

When you enable availability zones, it isn't enough coverage in the unlikely event that an entire region fails. To gain higher availability, run multiple AKS clusters in different regions.

- Prefer [paired regions](/azure/reliability/regions-paired#paired-regions) when they're available. A benefit of using paired regions is reliability during platform updates. Azure makes sure that only one region in the pair is updated at a time. [Some regions don't have pairs](/azure/reliability/cross-region-replication-azure). If your region isn't paired, you can still deploy a multi-region solution by selecting other regions to use. Consider using a continuous integration and continuous delivery (CI/CD) pipeline, which you configure to orchestrate recovery from a region failure. Specific DevOps tools like Flux can make the multi-region deployments easier.

- Provide the location where the redundant service has its secondary instance if an Azure resource supports geo-redundancy. For example, by enabling geo-replication for Container Registry, it automatically replicates images to the selected Azure regions. It also provides continued access to images even if the primary region experiences an outage.

- Choose a traffic router that can distribute traffic across zones or regions, depending on your requirement. This architecture deploys Load Balancer because it can distribute nonweb traffic across zones. If you need to distribute traffic across regions, consider Azure Front Door. For other options, see [Choose a load balancer](../../../guide/technology-choices/load-balancing-overview.md).

> [!NOTE]
> The [AKS baseline for multiregion clusters example scenario](../aks-multi-region/aks-multi-cluster.yml) extends the architecture in this article to include multiple regions in an active-active and highly available configuration.

### Disaster recovery

Ideally, if a failure occurs in the primary region, you can quickly create a new instance in another region. Consider the following recommendations:

- Use multiple regions. If your primary region has a paired region, use that pair. If not, select regions based on your data residency and latency requirements.

- Use a nonstateful workload that you can replicate efficiently. If you must store state in the cluster, which we don't recommend, be sure you back up the data frequently in another region.

- Integrate the recovery strategy, like replicating to another region, as part of the DevOps pipeline to meet your SLO.

- Set up each Azure service by using features that support disaster recovery. For example, in this architecture, Container Registry is enabled for geo-replication. If a region fails, you can still pull images from the replicated region.

- Deploy your infrastructure as code, including your AKS cluster and any other components you need. If you need to deploy into another region, you can reuse the scripts or templates to create an identical instance.

#### Cluster backup

For many architectures, you can set up a new cluster and return it to operating state through GitOps-based [cluster bootstrapping](#cluster-bootstrapping), followed by application deployment. But if there's critical resource state, like config maps, jobs, and secrets that can't be captured within your bootstrapping process, consider your recovery strategy. We recommend that you run stateless workloads in Kubernetes. If your architecture involves disk-based state, you must also consider your recovery strategy for that content.

When cluster backup must be a part of your recovery strategy, you must install a solution that matches your business requirements within the cluster. This agent is responsible for pushing cluster resource state out to a destination of your choosing and coordinating Azure disk-based, persistent volume snapshots.

VMware [Velero](https://velero.io/) is an example of a common Kubernetes backup solution that you can install and manage directly. Or you can use the [AKS backup extension](/azure/backup/azure-kubernetes-service-cluster-backup) to provide a managed Velero implementation. The AKS backup extension supports backing up both Kubernetes resources and persistent volumes, with schedules and backup scope externalized as vault configuration in Azure Backup.

The reference implementation doesn't implement backup, which involves extra Azure resources to manage, monitor, purchase, and secure. These resources might include an Azure Storage account, an Azure Backup vault and configuration, and the [trusted access feature](/azure/aks/trusted-access-feature). Instead, GitOps combined with the intent to run stateless workload is the recovery solution.

Choose and validate a backup solution that meets your business objective, which includes your defined recovery-point objective and recovery-time objective. Define your recovery process in a team runbook and practice it for all business-critical workloads.

### Kubernetes API server SLA

You can use AKS as a free service, but that tier doesn't provide a financially backed SLA. To obtain an SLA, you must choose the [Standard tier](/azure/aks/free-standard-pricing-tiers). We recommend that all production clusters use the Standard tier. Reserve the Free tier for preproduction clusters, and the Premium tier for [mission-critical workloads](/azure/well-architected/mission-critical/mission-critical-overview) only. When you use Azure availability zones, the Kubernetes API server SLA is higher. Your node pools and other resources are covered under their own SLAs.

For more information about specific SLAs for each service, see [SLA for online services](https://www.microsoft.com/licensing/docs/view/Service-Level-Agreements-SLA-for-Online-Services).

### Trade-off

There's a cost-to-availability trade-off for deploying the architecture across zones and especially regions. Some replication features, like geo-replication in Container Registry, are available in premium SKUs, which is more expensive. For multi-region deployments, the cost also increases because bandwidth charges apply when traffic moves across regions.

Also, expect a small amount of extra network latency in node communication between zones, and more significant latency in communication between regions. Measure the effect of this architectural decision on your workload.

### Test with simulations and forced failovers

Test your solution's reliability through forced failover testing with simulated outages. Simulations can include stopping a node, bringing down all AKS resources in a particular zone to simulate a zonal failure, or invoking an external dependency failure. You can also use Azure Chaos Studio to simulate various types of outages in Azure and on the cluster.

For more information, see [Chaos Studio](/azure/chaos-studio/chaos-studio-overview).

<a id='monitor-and-collect-metrics'></a>
<a id='monitor-and-collect-logs-and-metrics'></a>

<a name='monitor-and-collect-metrics'></a>

## Monitor and collect logs and metrics

We recommend the Azure Monitor [Kubernetes monitoring services](/azure/azure-monitor/containers/kubernetes-monitoring-overview) to monitor the performance of container workloads because you can view events in real time. Azure Monitor captures container logs from the running pods and aggregates them for viewing. It also collects information from the metrics API about memory and CPU usage to monitor the health of running resources and workloads. You can also use Azure Monitor to monitor performance as the pods scale. It includes telemetry that's critical for monitoring, analysis, and visualization of the collected data.

### Enable log collection from pods

The [ContainerLogV2 log schema](/azure/azure-monitor/containers/container-insights-logs-schema) is designed to capture container logs from Kubernetes pods in a streamlined approach. Log entries are consolidated into the `ContainerLogV2` table in an Azure Log Analytics workspace.

In an AKS cluster, there are two primary methods for configuring pod log collection. Both approaches let you customize settings. You can filter namespaces, adjust collection intervals, enable or prohibit specific features (like `ContainerLogV2` or `ContainerLogV2-HighScale`), and specify which data streams to collect.

- If you require centralized, reusable monitoring configurations across multiple clusters or prefer cluster configuration to be externalized in Azure-native resources, use [data collection rules (DCRs)](/azure/azure-monitor/data-collection/data-collection-rule-overview). DCRs are Azure resources that the Azure Resource Manager control plane manages natively, and you can include them in Bicep files. The reference implementation uses DCRs.

- Alternatively, you can define monitoring by using ConfigMaps, which are nonconfidential Kubernetes YAML objects configured through the Kubernetes API control plane. The Azure Monitor Agent that runs on the cluster monitors for ConfigMap objects. It uses predefined settings to determine which data to collect.

When both methods are enabled, ConfigMap settings take precedence over DCRs. Avoid mixing ConfigMap and DCR configuration for container log collection, because it can result in hard-to-troubleshoot logging problems.

### Alerts and Prometheus metrics

Outages and malfunctions pose significant risks to workload applications, which makes it essential to proactively identify problems related to your infrastructure's health and performance. When you monitor your environment and act on what you learn, you reduce disruptions and improve the reliability of your solution. To anticipate potential failure conditions in your cluster, enable [the recommended Prometheus alert rules for Kubernetes](/azure/azure-monitor/containers/kubernetes-metric-alerts).

Most workloads hosted in pods emit Prometheus metrics. Azure Monitor can integrate with Prometheus. You can view the application and workload metrics collected from containers, pods, nodes, and the cluster.

Some non-Microsoft solutions integrate with Kubernetes, like Datadog, Grafana, or New Relic. So if your organization already uses these solutions, you can take advantage of them.

### Azure infrastructure and Kubernetes control plane logs

With AKS, Azure manages some of the core Kubernetes services. Azure implements the logs for the AKS control plane components as [resource logs](/azure/azure-monitor/platform/resource-logs). These options can help you troubleshoot cluster problems, and they have a relatively low log density. We recommend that you enable the following options on most clusters:

- `ClusterAutoscaler`: Gain observability into the scaling operations through logging. For more information, see [Retrieve cluster autoscaler logs and status](/azure/aks/cluster-autoscaler#retrieve-cluster-autoscaler-logs-and-status).

- `KubeControllerManager`: Gain observability into the interaction between Kubernetes and the Azure control plane.

- `kube-audit-admin`: Gain observability into activities that modify your cluster. There's no need to enable both `kube-audit` and `kube-audit-admin` because `kube-audit` is a superset that also includes nonmodify (read) operations.

- `guard`: Capture Microsoft Entra ID and Azure RBAC audits.

It might be helpful for you to enable other log categories, like `KubeScheduler` or `kube-audit`, during early cluster or workload life cycle development. The added cluster autoscaling, pod placement and scheduling, and similar data can help you troubleshoot cluster or workload operations concerns. But if you keep the extended troubleshooting logs on full time after your troubleshooting needs end, you might be incurring unnecessary costs to ingest and store the data in Azure Monitor.

Azure Monitor includes a set of existing log queries to start with, but you can also use them as a foundation to help build your own queries. As your library grows, you can save and reuse log queries by using one or more [query packs](/azure/azure-monitor/logs/query-packs). Your custom library of queries provides greater observability into the health and performance of your AKS clusters. It supports achieving your SLOs.

For more information about monitoring best practices for AKS, see [Monitor AKS with Azure Monitor](/azure/aks/monitor-aks).

### Network metrics

Basic, cluster-level networking metrics are available through native [platform and Prometheus metrics](/azure/aks/monitor-aks#aks-monitoring-data-metrics-logs-integrations). You can further use AKS [node network metrics](/azure/aks/monitor-aks#aks-node-network-metrics-monitoring) to expose network metrics at the node level by using Prometheus metrics. Most clusters should include network observability to provide extra network troubleshooting capabilities and to detect unexpected network usage or problems at the node level.

The reference implementation uses Azure Monitor, which also collects some network-related metrics. The reference implementation prohibits directly collecting some network metrics from Azure Monitor, and instead collects the network observability metrics by using an Azure Monitor workspace with [managed Prometheus](/azure/azure-monitor/metrics/prometheus-metrics-overview).

For workloads that are highly sensitive to Transmission Control Protocol (TCP) or User Datagram Protocol (UDP) packet loss, latency, or DNS pressure, the pod-level network metrics are important. In AKS, you can access these detailed metrics by using the [Advanced Container Networking Services](/azure/aks/container-network-observability-guide) feature. Most workloads don't require this depth of network observability. You shouldn't enable advanced network observability unless your pods demand a highly optimized network, with sensitivity down to the packet level.

### Cost optimization for logging

The reference implementation configures the `ContainerLogV2` table to use the Basic plan as a starting point. Microsoft Defender for Containers and the alerts created for the reference implementation don't query this table, so the Basic plan is likely to be cost effective because it reduces ingestion costs.

As your log volume and query requirements evolve, select the most cost-effective table plan for your needs. If the solution becomes read-intensive, where queries frequently scan table data, the default Analytics plan might be more suitable. The Analytics plan eliminates query charges, which optimizes for scenarios where query activity outweighs ingestion costs. When you monitor usage patterns and adjust table plans as needed, you can achieve a balance between cost and functionality for your monitoring solution.

For more information, see [Select a table plan based on data usage in a Log Analytics workspace](/azure/azure-monitor/logs/logs-table-plans).

### Enable self-healing

Monitor the health of pods by setting [liveness and readiness probes](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/). If Kubernetes detects an unresponsive pod, it restarts the pod. A liveness probe determines if the pod is healthy. If Kubernetes detects an unresponsive pod, it restarts the pod. A readiness probe determines if the pod is ready to receive requests and traffic.

> [!NOTE]
> AKS has an [automatic node repair feature](/azure/aks/node-auto-repair) that provides built-in self-healing for infrastructure nodes.

### Routine updates for AKS clusters

Part of day-2 operations for Kubernetes clusters is to perform routine platform and operating system updates. There are three layers of updates to address on every AKS cluster:

- The Kubernetes version (like Kubernetes 1.32.3 to 1.32.7 or Kubernetes 1.32.7 to 1.33.1), which might come with Kubernetes API changes and deprecations. Version changes at this layer affect the whole cluster.

- The virtual hard disk (VHD) image on each node, which combines operating system updates and AKS component updates. These updates are tested against the cluster's Kubernetes version. Version changes at this layer are applied at the node pool level and don't affect the Kubernetes version.

- The operating system's own native update process, like Windows Update or `apt`. The operating system vendor supplies these updates directly and they aren't tested against the cluster's Kubernetes version. Version changes at this layer affect a single node and don't affect the Kubernetes version.

Each of these layers is independently controlled. You decide how each layer is handled for your workload's clusters. Choose how often each AKS cluster, its node pools, or its nodes are updated (the *cadence*). Also, pick what days or times to apply the updates (your *maintenance window*). Choose whether updates install manually or automatically or not at all. Just like the workload that runs on your cluster needs a safe deployment practice, so do the updates to your clusters.

For a comprehensive perspective about patching and upgrading, see [AKS patch and upgrade guidance](/azure/architecture/operator-guides/aks/aks-upgrade-practices) in the [AKS day-2 operations guide](/azure/architecture/operator-guides/aks/day-2-operations-guide). Use the following information for baseline recommendations as it relates to this architecture.

#### Immutable infrastructure

Workloads that operate AKS clusters as immutable infrastructure don't automatically or manually update their clusters. Set the [node image upgrade](/azure/aks/auto-upgrade-node-os-image#channels-for-node-os-image-upgrades) to `none` and the [cluster automatic upgrade](/azure/aks/auto-upgrade-cluster#cluster-autoupgrade-channels) to `none`. In this configuration, you're solely responsible for all upgrades at all layers.

When an update that you want becomes available, you must do the following steps:

1. Test the update in a preproduction environment and evaluate its compatibility on a new cluster.

1. Deploy a production replica stamp that includes the updated AKS version and node pool VHDs.

1. When the new production cluster is ready, drain the old cluster and eventually decommission it.

Immutable infrastructure with regular deployments of new infrastructure is the only situation in which a production cluster shouldn't have an in-place upgrade strategy applied to it. All other clusters should have an in-place upgrade strategy.

#### In-place upgrades

Workloads that don't operate AKS clusters as immutable infrastructure should regularly update their running clusters to address all three layers. Align your update process to your workload's requirements. Use the following recommendations as a starting point for designing your routine update process.

- Schedule the [planned maintenance](/azure/aks/planned-maintenance) feature of AKS so that you can control upgrades on your cluster. This feature enables you to perform the updates, an inherently risky operation, at a controlled time to reduce the effect of an unexpected failure.

- Configure [pod disruption budgets](https://kubernetes.io/docs/tasks/run-application/configure-pdb/) such that your application remains stable during rolling upgrades. But don't configure the budgets to be so aggressive that they block node upgrades from happening, because most upgrades require a cordon and drain process on each node.

- Confirm Azure resource quota and resource availability. In-place upgrades deploy new instances of nodes, known as *surge nodes*, before old nodes are removed. This means Azure quota and IP address space must be available for the new nodes. A [surge value](/azure/aks/upgrade-aks-node-pools-rolling#customize-node-surge) of 33% is a good starting point for most workloads.

- Test compatibility with tooling, like service meshes or security agents that you added to your cluster. Also, test your workload components, like ingress controllers, service meshes, and your workload pods. Run tests in a preproduction environment.

##### In-place upgrades for nodes

Use the `NodeImage` automatic upgrade channel for node OS image upgrades. This channel configures your cluster to update the VHD on each node with node-level updates. Microsoft tests the updates against your AKS version. For Windows nodes, the updates happen about once per month. For Linux nodes, the updates happen about once per week.

- The upgrades never change your AKS or Kubernetes version, so Kubernetes API compatibility isn't a concern.

- When you use `NodeImage` as the upgrade channel, it respects your planned maintenance window, which you should set for at least once per week. Set it no matter what node image operating system you use to help ensure timely application of updates.

- These updates include operating system-level security, compatibility, and functional updates, operating system configuration settings, and AKS component updates.

- Image releases and their included component version numbers are tracked by using the [AKS release tracker](/azure/aks/release-tracker).

If the security requirements for your cluster demand a more aggressive patching cadence and your cluster can tolerate the potential interruptions, use the `SecurityPatch` upgrade channel instead. Microsoft also tests these updates. The updates are only published if there are security upgrades that Microsoft considers important enough to release before the next scheduled node image upgrade. When you use the `SecurityPatch` channel, you also get the updates that the `NodeImage` channel received. The `SecurityPatch` channel option still honors your maintenance windows, so be sure your maintenance window has more frequent gaps (like daily or every other day) to support these unexpected security updates.

Most clusters that do in-place upgrades should avoid the `None` and `Unmanaged` node image upgrade channel options.

##### In-place updates to the cluster

Kubernetes is a rapidly evolving platform, and regular updates bring important security fixes and new capabilities. It's important that you remain current with Kubernetes updates. You should stay within the [two most recent versions (N-2)](/azure/aks/supported-kubernetes-versions). It's critical to upgrade to the latest version of Kubernetes because new versions are released frequently.

Most clusters should be able to perform in-place AKS version updates with enough caution and rigor. The risk of performing an in-place AKS version upgrade can mostly be mitigated through sufficient preproduction testing, quota validation, and pod disruption budget configuration. But any in-place upgrade can result in unexpected behavior. If in-place upgrades are deemed too risky for your workload, we recommended you use a [blue-green deployment of AKS clusters](/azure/architecture/guide/aks/blue-green-deployment-for-aks) approach instead of following the remaining recommendations.

We recommend that you avoid the [cluster automatic upgrade](/azure/aks/auto-upgrade-cluster) feature when you first deploy a Kubernetes cluster. Use a manual approach, which provides you with the time to test a new AKS cluster version in your preproduction environments before the updates hit your production environment. This approach also achieves the greatest level of predictability and control. But you must be diligent about monitoring for new updates to the Kubernetes platform, and quickly adopting new versions as they release. It's better to adopt a 'stay current' mindset over a [long-term support](/azure/aks/long-term-support) approach.

> [!WARNING]
> We don't recommend automatically patching or updating a production AKS cluster, even with minor version updates, unless you test those updates in your lower environments first. For more information, see [Regularly update to the latest version of Kubernetes](/azure/aks/operator-best-practices-cluster-security#regularly-update-to-the-latest-version-of-kubernetes) and [Upgrade an AKS cluster](/azure/aks/upgrade-options).

You can receive notifications when a new AKS version is available for your cluster by using the [AKS system for Azure Event Grid](/azure/event-grid/event-schema-aks). The reference implementation deploys this Event Grid system so that you can subscribe to the `Microsoft.ContainerService.NewKubernetesVersionAvailable` event from your eventstream notification solution. Review the [AKS release notes](https://github.com/Azure/AKS/releases) for specific compatibility concerns, behavior changes, or feature deprecations.

You might eventually reach the point of confidence with Kubernetes releases, AKS releases, your cluster, its cluster-level components, and the workload, to explore the automatic upgrade feature. For production systems, it's rare to move beyond `patch`. Also, when you automatically upgrade your AKS version, check the AKS version setting in your infrastructure as code (IaC) so that the two don't get out of sync. Configure your planned maintenance window to support the automatic upgrade operation.

### Security monitoring

Monitor your container infrastructure for both active threats and potential security risks. For more information, see the following resources:

- [Microsoft Defender for Containers](/azure/defender-for-cloud/defender-for-containers-deployment-overview) identifies and remediates Defender for Cloud recommendations for your container images.
- Defender for Containers regularly [scans your container images for vulnerabilities](/azure/defender-for-cloud/defender-for-containers-introduction#vulnerability-assessment).
- Defender for Containers also generates [real-time security alerts for suspicious activities](/azure/defender-for-cloud/defender-for-containers-introduction#run-time-protection-for-kubernetes-nodes-and-clusters).
- [Security concepts for applications and clusters in AKS](/azure/aks/concepts-security) details information about how container security protects the entire end-to-end pipeline from build to the application workloads running in AKS.

## Cluster and workload operations

For cluster and workload operations (DevOps) considerations, see the [Operational Excellence design principles](/azure/well-architected/operational-excellence/principles) pillar.

### Cluster bootstrapping

After you set up your cluster, it's a working cluster, but you might have more steps to do before you can deploy workloads. The process of preparing your cluster is called *bootstrapping*. Bootstrapping often consists of deploying prerequisite images onto cluster nodes, creating namespaces, and doing other tasks that fulfill the requirements of your organization's use case.

To speed up the transition from a newly set up cluster to a properly configured one, you must define your unique bootstrapping process and prepare relevant assets in advance. For example, if you use a service mesh like [Linkerd](https://linkerd.io/2.16/getting-started/) or [Consul Connect](https://developer.hashicorp.com/consul/docs/connect), you typically deploy the mesh before application workloads can be scheduled. Before you set up the cluster, you must validate that the service mesh's images exist in a previously created container registry. This validation helps prevent deployment delays or failures.

You can configure the bootstrapping process by using one of the following methods:

- [GitOps Flux v2 cluster extension](/azure/azure-arc/kubernetes/tutorial-use-gitops-flux2)
- Pipelines
- Self-configuration with Flux or Argo CD, for example

> [!NOTE]
> Any of these methods work with any cluster topology, but we recommend the GitOps Flux v2 cluster extension for fleets because of uniformity and easier governance at scale. When you run only a few clusters, GitOps might be overly complex. You might instead opt to integrate the process into one or more deployment pipelines to ensure that bootstrapping takes place. Use the method that best aligns with your organization and team objectives.

One of the main advantages of using the GitOps Flux v2 cluster extension for AKS is that there's effectively no gap between a provisioned cluster and a bootstrapped cluster. It sets up the environment with a solid management foundation going forward, and it also supports including the bootstrapping as resource templates to align with your IaC strategy.

Finally, when you use the GitOps Flux v2 cluster extension, kubectl isn't required for any part of the bootstrapping process. You can reserve kubectl-based access for emergency break-fix situations. Between templates for Azure resource definitions and the bootstrapping of manifests via the GitOps extension, you can perform all normal configuration activities without the need to use kubectl.

### Isolate workload responsibilities

Divide the workload by teams and types of resources to individually manage each portion.

Start with a basic workload that contains the fundamental components and build on it. An initial task is to configure networking. Set up virtual networks for the hub and spokes and also subnets within those networks. For example, a spoke has separate subnets for system and user node pools, ingress resources, and the private AKS API server. Deploy a subnet for Azure Firewall in the hub.

Another task is to integrate the basic workload with Microsoft Entra ID.

### Use IaC

Choose an idempotent declarative method over an imperative approach, where possible. Instead of writing a sequence of commands that specify configuration options, use declarative syntax that describes the resources and their properties. The reference implementation uses [Bicep](/azure/azure-resource-manager/bicep/overview), but you can choose to use Terraform or [Azure Resource Manager templates (ARM templates)](/azure/azure-resource-manager/templates/overview) instead.

Be sure to set up resources per the governing policies. For example, when you select VM sizes, stay within the cost constraints and availability zone options to match the requirements of your application. You can also use Azure Policy to enforce your organization's policies for these decisions.

If you need to write a sequence of commands, use the [Azure CLI](/cli/azure/what-is-azure-cli). These commands cover a range of Azure services and you can automate them through scripting. Windows and Linux support the Azure CLI. Another cross-platform option is Azure PowerShell. Your choice depends on your preferred skill set.

Store and version your scripts and template files in your source control system.

### Workload CI/CD

Pipelines for workflow and deployment must be able to build and deploy applications continuously. Updates must deploy safely and quickly and roll back in case there are problems.

Your deployment strategy needs to include a reliable and an automated continuous delivery pipeline. Deploy changes in your workload container images to the cluster automatically.

In this architecture, [GitHub Actions](https://github.com/marketplace?type=actions) manages the workflow and deployment. Other popular options include [Azure DevOps Services](/azure/virtual-machines/infrastructure-automation#azure-devops-services) and [Jenkins](/azure/developer/jenkins/overview).

### Cluster CI/CD

:::image type="complex" border="false" source="images/workload-ci-cd.svg" alt-text="Diagram that shows workload CI/CD." lightbox="images/workload-ci-cd.svg":::
   The diagram shows the CI/CD workflow from left to right. On the left, an Infrastructure as code icon represents the declarative configuration stored in source control. A horizontal arrow labeled Deploy points from the infrastructure as code to a central box labeled GitOps. This box contains Azure Pipelines, GitHub Actions, and Jenkins Pipelines. From the GitOps box, an arrow labeled Sync points to an AKS icon.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/secure-baseline-aks-workload-ci-cd.vsdx) of this architecture.*

Instead of using an imperative approach like kubectl, use tools that automatically sync cluster and repository changes. To manage the workflow, like the release of a new version and validation on that version before deploying to production, consider a GitOps flow.

An essential part of the CI/CD flow is bootstrapping a newly provisioned cluster. A GitOps approach is useful because it lets operators declaratively define the bootstrapping process as part of the IaC strategy and see the configuration reflected in the cluster automatically.

When you use GitOps, an agent is deployed in the cluster to make sure that the state of the cluster is coordinated with configuration stored in your private Git repo. One such agent is [Flux](https://fluxcd.io/flux/concepts/), which uses one or more operators in the cluster to trigger deployments inside Kubernetes. Flux does the following tasks:

- Monitors all configured repositories
- Detects new configuration changes
- Triggers deployments
- Updates the correct running configuration based on those changes

You can also set policies that govern how the changes are deployed.

The following example diagram shows how to automate cluster configuration with GitOps and Flux.

:::image type="complex" border="false" source="images/gitops-flow.svg" alt-text="Diagram that shows the GitOps flow." lightbox="images/gitops-flow.svg":::
  The diagram illustrates the GitOps workflow with four numbered steps from left to right. At the far left, a developer icon with a laptop appears as Step 1, where the user pushes IaC changes to a Git repository. Step 2 shows the Git repository connecting via an arrow labeled git clone --mirror to a Flux icon inside the AKS cluster boundary. Step 3 shows an arrow labeled kubectl apply that points from from the Flux icon to the Kubernetes API server icon within the cluster. Step 4 displays a red circle with a diagonal line between the developer and the Kubernetes API server with a crossed‑out kubectl label.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/secure-baseline-aks-gitops-flow.vsdx) of this architecture.*

1. A developer commits changes to source code, like configuration YAML files, which are stored in a Git repository. The changes are then pushed to a Git server.

1. Flux runs in a pod alongside the workload. Flux has read-only access to the Git repository to make sure that Flux is only applying changes as requested by developers.

1. Flux recognizes changes in configuration and applies those changes by using kubectl commands.

1. Developers don't have direct access to the Kubernetes API through kubectl.

You can have branch policies on your Git server so that multiple developers can then approve changes through a pull request before the change is applied to production.

While you can configure GitOps and Flux manually, we recommend the GitOps with Flux v2 cluster extension for AKS.

### Workload and cluster deployment strategies

Deploy *any* change, like architecture components, workload, and cluster configuration, to at least one preproduction AKS cluster. When you do so, it simulates the change and might identify problems before they're deployed to production.

Run tests and validations at each stage before you continue to the next stage. It helps ensure that you can push updates to the production environment in a highly controlled way and minimize disruption from unanticipated deployment problems. The deployment should follow a similar pattern as production, by using the same GitHub Actions pipeline or Flux operators.

Advanced deployment techniques, like [blue-green deployment](https://martinfowler.com/bliki/BlueGreenDeployment.html), A/B testing, and [canary releases](https://martinfowler.com/bliki/CanaryRelease.html), require extra processes and potentially extra tooling. [Flagger](https://github.com/fluxcd/flagger) is a popular open-source solution to help solve for advanced deployment scenarios.

## Cost management

Start by reviewing the cost optimization design checklist and list of recommendations outlined in [Well-Architected Framework for AKS](/azure/well-architected/service-guides/azure-kubernetes-service#cost-optimization). Use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate costs for the services you use in the architecture. For other best practices, see [Cost Optimization](/azure/architecture/framework/cost/overview).

Consider using [AKS cost analysis](/azure/aks/cost-analysis) for granular cluster infrastructure cost allocation by Kubernetes-specific constructs.

### Provision

- Understand where your costs come from. There are minimal costs associated with AKS in deployment, management, and operations of the Kubernetes cluster itself. What affects the cost are the VM instances, storage, log data, and networking resources consumed by the cluster. Consider choosing cheaper VMs for system node pools. The [Ddv5](/azure/virtual-machines/sizes/general-purpose/ddv5-series) series is a typical VM type for the system node pool, and the reference implementation uses the Standard_D2d_v5 SKU.

- Don't use the same configuration for dev/test and production environments. Production workloads have extra requirements for high availability and are typically more expensive. This configuration isn't necessary in the dev/test environment.

- Add an uptime SLA for production workloads. But there are savings for clusters designed for dev/test or experimental workloads where availability isn't required to be guaranteed. For example, your SLO might be sufficient. Also, if your workload supports it, consider using dedicated spot node pools that run [spot VMs](/azure/virtual-machines/spot-vms).

    For nonproduction workloads that include Azure SQL Database or Azure App Service as part of the AKS workload architecture, evaluate if you're eligible to use [Azure Dev/Test subscriptions](https://azure.microsoft.com/pricing/dev-test/) and receive service discounts.

- Provision a cluster with the minimum number of nodes, and enable the cluster autoscaler to monitor and make sizing decisions instead of starting with an oversized cluster to meet scaling needs.

- Set pod requests and limits to let Kubernetes allocate node resources with higher density so that you use the full capacity of the nodes.

- Consider that when you enable diagnostics on the cluster, it can increase the cost.

- Commit to one-year or three-year Azure Reserved Virtual Machine Instances to reduce the node costs if your workload must exist for a long period of time. For more information, see [Save costs with Azure Reserved Virtual Machine Instances](/azure/virtual-machines/prepay-reserved-vm-instances).

- Use tags when you create node pools. Tags help when you create custom reports to track incurred costs. You can use tags to track the total expenses and map any cost to a specific resource or team. If the cluster is shared between teams, build chargeback reports for each consumer to identify metered costs for shared cloud services. For more information, see [Specify a taint, label, or tag for a node pool](/azure/aks/create-node-pools).

- Expect extra bandwidth costs if your workload is multi-region and you replicate data between regions. For more information, see [Bandwidth pricing](https://azure.microsoft.com/pricing/details/bandwidth/).

- Create budgets to stay within the cost constraints that your organization identifies. You can create budgets through Microsoft Cost Management. You can also create alerts to get notifications when specific thresholds are exceeded. For more information, see [Create a budget by using a template](/azure/cost-management-billing/costs/quick-create-budget-template).

### Monitor

You can monitor the entire cluster and the cost of compute, storage, bandwidth, logs, and the firewall. Azure provides the following options to monitor and analyze costs:

- [Azure Advisor](/azure/advisor/advisor-get-started)
- [Cost Management](/azure/cost-management-billing/costs/reporting-get-started)

Monitor your costs in real time or on a regular schedule so that you can take action before the end of the month, when costs are already calculated. Monitor the monthly trends over time to stay within budget.

To make data-driven decisions, pinpoint which resource, at a granular level incurs the most cost. Also, have a good understanding of the meters that calculate resource usage. For example, by analyzing metrics, you can determine whether the platform is oversized. You can see the usage meters in Azure Monitor metrics.

### Optimize

Follow the recommendations from Azure Advisor. Explore other ways to optimize:

- Enable the cluster autoscaler to detect and remove underused nodes in the node pool.

  > [!IMPORTANT]
  > Making rapid or frequent changes to cluster autoscaler settings, like the minimum and maximum node counts for a node pool, to control costs might lead to unintended or counterproductive outcomes. For example, if `scale-down-unneeded-time` is set to 10 minutes, and the minimum and maximum node settings are modified every five minutes based on workload characteristics, the number of nodes never reduces. It's because the calculation of the unneeded time for each node resets when the cluster autoscaler settings are refreshed.

- Choose a lower SKU for the node pools, if your workload supports it.

- If the application doesn't require burst scaling, consider rightsizing the cluster by analyzing performance metrics over time.

- If your workload supports it, scale your user node pools to zero nodes when there's no expectation for them to run. If there are no workloads left scheduled to run in your cluster, consider using the AKS start/stop feature to shut down all compute, which includes your system node pool and the AKS control plane.

For more information, see [AKS pricing](https://azure.microsoft.com/pricing/details/kubernetes-service/).

## Next steps

- [AKS roadmap on GitHub](https://github.com/orgs/Azure/projects/685)
- [AKS landing zone accelerator](/azure/cloud-adoption-framework/scenarios/app-platform/aks/landing-zone-accelerator)

## Related resources

- [Advanced AKS microservices architecture](../aks-microservices/aks-microservices-advanced.yml)
- [Microservices architecture on AKS](../aks-microservices/aks-microservices.yml)
- [Use Azure Firewall to help protect an AKS cluster](../../../guide/aks/aks-firewall.yml)
- [GitOps for AKS](../../../example-scenario/gitops-aks/gitops-blueprint-aks.yml)
- [Data streaming by using AKS](../../../solution-ideas/articles/data-streaming-scenario.yml)
