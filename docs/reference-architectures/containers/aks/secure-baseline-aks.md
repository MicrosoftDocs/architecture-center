---
title: Baseline architecture for an Azure Kubernetes Service (AKS) cluster
description: Reference architecture for a baseline infrastructure that deploys an Azure Kubernetes Service (AKS) cluster with focus on security.
author: PageWriter-MSFT
ms.date: 07/19/2020
ms.topic: reference-architecture
ms.service: architecture-center
ms.category:
  - containers
  - kubernetes
  - aks
ms.subservice: reference-architecture
ms.custom: seojul20, containers
---

# Baseline architecture for an Azure Kubernetes Service (AKS) cluster
In this reference architecture, we’ll build a baseline infrastructure that
deploys an Azure Kubernetes Service (AKS) cluster with focus on security. This
article includes recommendations for networking, security, identity, management,
and monitoring of the cluster based on an organization’s business requirements.

![GitHub logo](../../../_images/github.png) An implementation of this architecture is available
on [GitHub: Azure Kubernetes Service (AKS) Secure Baseline Reference Implementation](https://github.com/mspnp/aks-secure-baseline). You can use it as a
starting point and configure it as per your needs.

## Case study – Contoso Bicycle
----------------------------

This architecture is built for a fictitious company, Contoso Bicycle. The
company is a small and fast-growing startup that provides online web services to
its clientele in the west coast, North America. The web services were deployed
to the cloud from the get-go. They have no on-premises datacenters or legacy
applications. Here's the brief cloud profile:

- Have several workloads running and operating in Azure.
- Use Azure Active Directory for identity management.
- Knowledgeable about containers and have considered them for application development. 
- Aware of Kubernetes as a well-known container orchestration.
- Researched AKS as a possibility. 

The IT teams need guidance about architectural recommendations for running their web services in an AKS cluster.

### Organization structure

Contoso Bicycle has a single IT Team with these sub teams.

![Org Pic]()

#### Architecture team

Work with the line of business from idea through deployment into production.
They understand all aspects of the Azure components: ￼function, integration,
controls, and monitoring capabilities. The team evaluates those aspects for
functional, security, and compliance requirements. They coordinate and have
representation from other teams. Their workflow aligns with Contoso's SDL process.

#### Development team

Responsible for developing Contoso’s web services. They rely on the guidance
from the architecture team about implementing cloud design patterns. They own and run the integration and deployment pipeline for the web services.

#### Security team

Review Azure services and workloads from the lens of security. Incorporate Azure
service best practices in configurations. They review choices for authentication, authorization, network connectivity, encryption, and key management and, or rotation. Also, they have monitoring requirements for any proposed service.

#### Identity team

Responsible for identity and access management for the Azure environment. They
work with the Security and Architecture teams for use of Azure Active Directory,
role-based access controls, and segmentation. Also, monitoring service
principles for service access and application level access.

#### Networking team

Make sure that different architectural components can talk to each other in a secure manner. They manage the hub and spoke network topologies and IP space allocation.

#### Operations team

Responsible for the infrastructure deployment and day-to-day operations of the
Azure environment.

### Business requirements

Here are the requirements based on an initial [Well-Architected
Framework review](https://docs.microsoft.com/assessments/?mode=pre-assessment&session=local).

#### Reliability

- Global presence: The customer base is focused on the West Coast of North
America.

- Business continuity: The workloads need to be highly available at a minimum
cost. They have a Recovery Time Objective (RTO) of 4 hours.

- On-premises connectivity: They don’t need to connect to on-premises datacenters or
legacy applications.

#### Performance efficiency

The web service’s host should have these capabilities.

- Auto scaling: Automatically scale to handle the demands of expected traffic
patterns. The web service is unlikely to experience a high-volume scale event.
The scaling methods shouldn't drive up the cost.

- Right sizing: Select hardware size and features that are suited for the web
service and are cost effective.

- Growth: Ability to expand the workload or add adjacent workloads as the product
matures and gains market adoption.

- Monitoring: Emit telemetry metrics to get insights into the performance and
scaling operations. Integration with Azure Monitor is preferred.

- Workload-based scaling: Allow granular scaling per workload and independent
scaling between different partitions in the workload.

#### Security

- Identity management: Contoso is an existing Microsoft 365 user. They rely
heavily on Azure Active Directory as their control plane for identity.

- Certificate: They must expose all web services through SSL and aim for
end-to-end encryption, as much as possible.

- Network: They have existing workloads running in Azure Virtual Networks. They
would like to minimize direct exposure to Azure resources to the public
internet. Their existing architecture runs with regional hub and spoke
topologies. This way, the network can be expanded in the future and also provide workload isolation.
All web applications require a web application firewall (WAF) service to help
govern HTTP traffic flows.

- Secrets management: They would like to use a secure store for sensitive
information.

- Container registry: Currently not using a registry and are looking for guidance.

- Container scanning: They know the importance of container scanning but
are concerned about added cost. The information isn't sensitive, but would like the option to scan in the future.

#### Operational excellence

- Logging, monitoring, metrics, alerting: They use Azure Monitor for their
existing workloads. They would like to use it for AKS, if possible.

- Automated deployments: They understand the importance of automation. They build
automated processes for all infrastructure so that environments and workloads
can easily be recreated consistently and at any time.

#### Cost optimization

- Cost center: There’s only one line-of-business. So, all costs are billed to a
single cost center.

- Budget and alerts: They have certain planned budgets. They want to be alerted
when certain thresholds like 50%, 75%, and 90% of the plan has been reached.

### Design and technology choices

-   Deploy the AKS cluster into an existing Azure Virtual Network spoke. Use the
    existing Azure Firewall in the regional hub for securing outgoing traffic
    from the cluster.

-   Traffic from public facing website is required to be encrypted. This encryption is
    implemented with Azure Application Gateway with integrated web
    application firewall (WAF).

-   Use Traefik as the Kubernetes ingress controller.

-   The workload is stateless. No data will be persisted inside the cluster.

-   Given there's only one line-of-business, there's a single workload. Azure
    Network Policy will be enabled for future use.

-   Azure Container Registry will be used for the container image registry. The cluster will access the registry through Azure Private Link.

-   To stay up to date with OS and security patches, have tools ￼to help
    the restart of nodes when needed.

-   AKS will be integrated with Azure Active Directory for role-based access control. This choice is aligned with the strategy of using identity as an operational control plane.

-   Azure Monitor will be used for logging, metrics, monitoring, and alerting to
    use the existing knowledge of Log Analytics.

-   Azure Key Vault will be used to store all secret information including SSL certificates. Key Vault data will be mounted by using Azure Key Vault with Secrets Store Container Storage Interface (CSI) driver.

-   Two node pools will be used in AKS. The system node pool will be used for
    critical system pods. The second node pool will be used for the
    application workload.

-   To make sure the workload is scaled properly, requests and limits will be
    enforced by assigning quotas for the Horizontal Pod Autoscaling (HPA). AKS cluster autoscaler will be enabled so that additional nodes are automatically provisioned if pods can’t be scheduled.

## Network topology
-------------------------------------------------
This architecture uses a hub-spoke network topology. The hub and spoke(s) are
deployed in separate virtual networks connected through
[peering](https://docs.microsoft.com/azure/virtual-network/virtual-network-peering-overview).
Some advantages of this topology are:

-   Segregated management. It allows for a way to apply governance and control
    the blast radius. It also supports the concept of landing zone with
    separation of duties.

-   A natural choice for workloads that span multiple subscriptions.

-   It makes the architecture extensible. To accommodate new features or
    workloads, new spokes can be added instead of redesigning the network
    topology.

-   Certain resources, such as a firewall and DNS can be shared across networks.

![Network Topology](_images/secure-baseline-architecture.png)

### Hub 

The hub virtual network is the central point of connectivity and observability.
Within the network, three subnets are deployed.

#### Subnet to host Azure Firewall

[Azure Firewall](https://docs.microsoft.com/azure/firewall/) is firewall as
a service. The firewall instance secures outbound network traffic. Without
this layer of security, the flow might communicate with a malicious
third-party service that could exfiltrate sensitive company data.

#### Subnet to host a gateway

This subnet is a placeholder for a VPN or ExpressRoute gateway. The gateway
provides connectivity between the routers in the on-premises network and the
virtual network.

#### Subnet to host Azure Bastion

This subnet is a placeholder for [Azure
Bastion](https://docs.microsoft.com/azure/bastion/bastion-overview). You can
use Bastion to securely access Azure resources without exposing the
resources to the internet. This subnet is used for management and operations only.

### Spoke

The spoke virtual network will contain the AKS cluster and other related
resources. The spoke has three subnets:

#### Subnet to host Azure Application Gateway 

Azure [Application
Gateway](https://docs.microsoft.com/azure/application-gateway/overview) is a
web traffic load balancer operating at Layer 7. The reference implementation
uses the Application Gateway v2 SKU that enables [Web Application
Firewall](https://docs.microsoft.com/azure/application-gateway/waf-overview) (WAF).
WAF secures incoming traffic from common web traffic attacks. The instance
has a public frontend IP configuration that receives user requests. By
design, Application Gateway requires a dedicated subnet.

#### Subnet to host the ingress resources

To route and distribute traffic, Traefik is the ingress controller that
is going to fulfill the Kubernetes ingress resources.

#### Subnet to host the cluster nodes

AKS maintains two separate groups of nodes (or node pools). The *system node
pool* hosts pods that run core cluster services. The *user node pool* runs
the Contoso workload and the ingress controller to facilitate inbound
communication to the workload. The workload is a simple ASP.NET application.

For additional information, [Hub-spoke network topology in
Azure](https://docs.microsoft.com/azure/architecture/reference-architectures/hybrid-networking/hub-spoke).

## Plan the IP addresses
-------------------------------------------------
![Network Topology](_images/baseline-network-topology.png)

The address space of the virtual network should be large enough to hold all
subnets. Account for all entities that will receive traffic. IP addresses for
those entities will be allocated from the subnet address space. Consider these
points.
- Upgrade

    AKS updates nodes regularly to make sure the underlying virtual machines are
up to date on security features and other system patches. During an upgrade
process, AKS creates a node that temporarily hosts the pods, while the
upgrade node is cordoned and drained. That temporary node is assigned an IP
address from the cluster subnet.

    For pods, you might need additional addresses depending on your strategy.
For rolling updates, you'll need addresses for the temporary pods that run the workload while the actual pods are updated. If you use
the replace strategy, pods are removed, and the new ones are created. So,
addresses associated with the old pods are reused.

- Scalability

    Take into consideration the node count of all system and user nodes and
their maximum scalability limit. Suppose you want to scale out by 400%. You'll need four times the number of addresses for all those scaled-out nodes.

    In this architecture, each pod can be contacted directly. So, each pod
needs an individual address. Pod scalability will impact the address
calculation. That decision will depend on your choice about the number of
pods you want to grow.

- Azure Private Link addresses

    Factor in the addresses that are required for communication with other Azure
services over Private Link. In this architecture, we have two addresses
assigned for the links to Azure Container Registry and Key Vault.

- [Certain addresses are reserved](https://docs.microsoft.com/azure/virtual-network/virtual-networks-faq#are-there-any-restrictions-on-using-ip-addresses-within-these-subnets)
    for use by Azure. They can't be assigned.

The preceding list isn't exhaustive. If your design has other resources that
will impact the number of available IP addresses, accommodate those addresses.

This architecture is designed for a single workload. For multiple workloads, you
may want to isolate the user node pools from each other and from the system node
pool. That choice may result in more subnets that are smaller in size. Also, the
ingress resource might be more complex. You might need multiple ingress
controllers that will require extra addresses.

For the complete set of considerations for this architecture, see [AKS baseline
Network
Topology](https://github.com/mspnp/reference-architectures/blob/fcp/aks-baseline/aks/secure-baseline/networking-readme.md#aks-baseline-network-topology).

For information related to planning IP for an AKS cluster, see [Plan IP
addressing for your
cluster](https://docs.microsoft.com/azure/aks/configure-azure-cni#plan-ip-addressing-for-your-cluster).

## Configure compute for the base cluster
-------------------------------------------------
In AKS, each node pool maps to a virtual machine scale set. Nodes are VMs in
each node pool. Consider using a smaller VM size for the system node pool to
minimize costs. This reference implementation deploys the system node pool with
three DS2_v2 nodes. That size is sufficient to meet the expected load of the
system pods. The OS disk is 512 GB.

For the user node pool, here are some considerations:

-   Choose larger node sizes to pack the maximum number of pods set on a node.
    It will minimize the footprint of services that run on all nodes, such as
    monitoring and logging.

-   Deploy at least two nodes. That way, the workload will have a high
    availability pattern with two replicas. With AKS, you can change the node
    count without recreating the cluster.

-   Actual node sizes for your workload will depend on the requirements
    determined by the design team. Based on the [requirements of the Contoso
    Bicycle company](#business-requirements), we chose DS4_v2 for the production workload. To lower costs
    one could drop the size to DS3_v2, which is the minimum recommendation.

-   When planning capacity for your cluster, assume that your workload can
    consume up to 80% of each node; the remaining 20% is reserved for AKS
    services.

-   The maximum pods per node, is set to 30, which is also the default.
    Increasing this value can impact performance because of an unexpected node
    failure or expected node maintenance events.

## Integrate Azure Active Directory for the cluster
------------------------------------------------

Securing access to and from the cluster is critical. Think from the cluster’s
perspective when you're making security choices:

-   *Outside-in access*. Authorize only those external entities that are allowed
    access to the Kubernetes API server and Azure Resource Manager.

-   *Inside-out access*. Authorize only those resources that the cluster is
    allowed access.

There are two ways to manage access: Service Principals or Managed Identities
for Azure resources.

Of the two ways, Azure Managed Identities is recommended. With Service
Principals there's an overhead for managing and rotating secrets without which
the cluster will not be accessible. With managed identities, Azure Active
Directory (Azure AD) handles the authentication and timely rotation of secrets.

It’s recommended that Managed Identities is enabled so that the cluster can interact with external Azure resources through Azure AD. This setting can only be enabled during cluster creation. Even if Azure AD isn't used immediately, you can incorporate it later. 

As an example for the inside-out case, let’s study the use of managed identities
when the cluster needs to pull images from a container registry. This action requires the
cluster to get the credentials of the registry. One way is to store that
information in the form of Kubernetes Secrets object and use `imagePullSecrets` to
retrieve the secret. That approach isn't recommended because of security
complexities. Not only do you need prior knowledge of the secret but also
disclosure of that secret through the DevOps pipeline. Another reason is the
operational overhead of managing the rotation of the secret. Instead, grant
`acrPull` access to the managed identity of the cluster to your registry. This
approach addresses those concerns.

In this architecture, the cluster accesses Azure resources that are secured by
Azure AD and do operations that support managed identities. Assign role-based access control (RBAC)
and permissions to the cluster’s managed identities, depending on
the operations that the cluster intends to do. The cluster
will authenticate itself against the resource and consequently be allowed or
denied access. Here are some examples from this reference implementation where
Azure RBAC built-in roles have been assigned to the cluster.

-   [Network Contributor](https://docs.microsoft.com/azure/role-based-access-control/built-in-roles#network-contributor).
    The cluster’s ability to control the spoke virtual network. This Role
    Assignment allows AKS cluster system assigned identity to work with the
    dedicated subnet for the Internal Ingress Controller services.

-   [Monitoring Metrics Publisher](https://docs.microsoft.com/azure/role-based-access-control/built-in-roles#monitoring-metrics-publisher).
    The cluster’s ability to send metrics to Azure Monitor.

-   [AcrPull](https://docs.microsoft.com/azure/role-based-access-control/built-in-roles#acrpull).
    The cluster’s ability to pull images from the specified Azure Container
    Registries.

Azure AD integration also simplifies security for outside-in access. Suppose a
user wants to use kubectl. As an initial step, sends the `az aks get-credentials`
command to get the credentials of the cluster. Azure AD will authenticate the
user’s identity against the Azure Resource Manager RBAC roles that are allowed
to get cluster credentials. For more information, see [Available cluster roles permissions](https://docs.microsoft.com/azure/aks/control-kubeconfig-access#available-cluster-roles-permissions).

### Associate Kubernetes RBAC to Azure Active Directory

Kubernetes supports role-based access control (RBAC) through:

-   A set of permissions. Defined by a `Role` or `ClusterRole` object for
    cluster-wide permissions.

-   Bindings that assign users and groups who are allowed to do the actions.
    Defined by a `RoleBinding` or `CluserRoleBinding` object.

Kubernetes has some built-in roles such as cluster-admin, edit, view, and so on.
Bind those roles to Azure Active Directory users and groups to use enterprise
directory to manage access. For more information, see [Use Kubernetes RBAC with
Azure AD integration](https://docs.microsoft.com/azure/aks/azure-ad-rbac).

There’s also an option of using Azure RBAC roles instead of the Kubernetes
built-in roles. For more information, see [Azure RBAC
roles](https://docs.microsoft.com/azure/aks/manage-azure-rbac).

## Integrate Azure Active Directory for the workload
-------------------------------------------------

Similar to having Azure Managed Identities for the entire cluster, you can
assign managed identities at the pod level. A pod managed identity allows the
hosted workload to access resources through Azure Active Directory. For example,
the workload stores files in the Azure Storage. When it needs to access those
files, the pod will authenticate itself against the resource.

In this reference implementation, managed pod identities is facilitated through
[aad-pod-identity](https://github.com/Azure/aad-pod-identity).

## Deploy Ingress resources
------------------------

Kubernetes Ingress resources route and distribute incoming traffic to the
cluster. There are two portions of Ingress resources:

- Internal load balancer. Managed by AKS. This load balancer exposes the
    ingress controller through a private static IP address. It serves as single
    point of contact that receives inbound flows.

    In this architecture, Azure Load Balancer is used. It’s placed outside the
cluster; in a subnet dedicated for ingress resources. It receives traffic
from Azure Application Gateway and that communication is over TLS. For
information about TLS encryption for inbound traffic, see [Ingress traffic flow](#ingress-traffic-flow).

- Ingress controller. We have chosen Traefik. It runs in the user node pool in
    the cluster. It receives traffic from the internal load balancer, terminates
    TLS, and forwards it to the workload pods over HTTP.

    The ingress controller is a critical component of cluster. Consider these points
when configuring this component.

- As part of your design decisions, choose a scope within which the ingress
    controller will be allowed operate. For example, you might allow the
    controller to only interact with the pods that run a specific workload.

- Avoid placing replicas on the same node to spread out the load and
    ensure business continuity if a node does down. Use
    `podAntiAffinity` for this purpose.

- Constrain pods to be scheduled only on the user node pool by using
    `nodeSelectors`. This setting will isolate workload and system pods.

- Open ports and protocols that allow specific entities to send traffic to the
    ingress controller. In this architecture, Traeffik only receives traffic
    from Azure Application Gateway.

- Ingress controller should send signals that indicate the health of pods.
    Configure `readinessProbe` and `livenessProbe` settings that will monitor the
    health of the pods at the specified interval.

- Consider restricting the ingress controller’s access to specific resources
    and the ability to perform certain actions. That can be implemented through
    Kubernetes RBAC permissions. For example, in this architecture, Traefik has
    been granted permissions to watch, get, and list services and endpoints. by
    using rules in the Kubernetes `ClusterRole` object.

### Router settings

The ingress controller uses routes to determine where to send traffic. Routes
specify the source port at which the traffic is received and information about
the destination ports and protocols.

Here’s an example from this architecture:

Traefik uses the Kubernetes provider to configure routes. The `annotations`, `tls`, 
and `entrypoints` indicate that routes will be served over HTTPS. The `middlewares`
specifies that only traffic from the Azure Application Gateway subnet is
allowed. The responses will use gzip encoding if the client accepts. Because
Traefik does TLS termination, communication with the backend services is over
HTTP.

```
apiVersion:networking.k8s.io/v1beta1
kind: Ingress	
metadata:	
  name: aspnetapp-ingress	
  namespace: a0008	
  annotations:	
    kubernetes.io/ingress.class: traefik-internal	
    traefik.ingress.kubernetes.io/router.entrypoints: websecure	
    traefik.ingress.kubernetes.io/router.tls: "true"	
    traefik.ingress.kubernetes.io/router.tls.options: default	
    traefik.ingress.kubernetes.io/router.middlewares: app-gateway-snet@file, gzip-compress@file	
spec:	
  # ingressClassName: "traefik-internal"	
  tls:	
  - hosts:	
      - bu0001a0008-00.aks-ingress.contoso.com	
  rules:	
  - host: bu0001a0008-00.aks-ingress.contoso.com	
    http:	
      paths:	
      - path: /	
        backend:	
          serviceName: aspnetapp-service	
          servicePort: http	
```

## Secure the network flow
-----------------------

Network flow, in this context, can be categorized as:

-   **Ingress traffic**. From the client to the workload running in the cluster.

-   **Egress traffic**. From a pod or node in the cluster to an external
    service.

-   **Pod-to-pod traffic**. Communication between pods. This traffic includes communication
    between the ingress controller and the workload. Also, if your workload is
    composed of multiple applications deployed to the cluster, communication
    between those applications would fall into this category.

-   **Management traffic**. Traffic that goes between the client and the
    Kubernetes API server.

![Cluster traffic flow](_images/traffic-flow.png)

This architecture has several layers of security to secure all types of traffic.

### Ingress traffic flow

The architecture only accepts TLS encrypted requests from the client. TLS v1.2
is the minimum allowed version with a restricted set of cyphers. Server Name
Indication (SNI) strict is enabled. End-to-end TLS is set up through Application
Gateway by using two different TLS certificates, as shown in this image.

![TLS termination](_images/tls-termination.png)

1.  The client sends an HTTPS request to the domain name: bicycle.contoso.com.
    That name is associated with through a DNS A record to the public IP address
    of Azure Application Gateway. This traffic is encrypted to make sure that
    the traffic between the client browser and gateway cannot be inspected or
    changed.

2.  Application Gateway has an integrated web application firewall (WAF) and
    negotiates the TLS handshake for bicycle.contoso.com, allowing only secure
    ciphers. Application Gateway is a TLS termination point, as it is required
    to process WAF inspection rules, and execute routing rules that forward the
    traffic to the configured backend. The TLS certificate is stored in Azure
    Key Vault. It’s accessed using a user-assigned managed identity integrated
    with Application Gateway. For information about that feature, see [TLS
    termination with Key Vault
    certificates](https://docs.microsoft.com/azure/application-gateway/key-vault-certs).

3.  The traffic moves from Application Gateway to the backend, the traffic is
    encrypted again with another TLS certificate (wildcard for
    \*.aks-ingress.contoso.com) as it’s forwarded to the internal load balancer.
    This re-encryption makes sure unsecure traffic doesn’t flow into the cluster
    subnet.

4.  The ingress controller receives the encrypted traffic through the load
    balancer. The controller is another TLS termination point for
    \*.aks-ingress.contso.com and forwards the traffic to the workload pods over
    HTTP. The certificates are stored in Azure Key Vault and mounted into the
    cluster using the Container Storage Interface (CSI) driver. For more
    information, see Add secret management.

You can implement end-to-end TLS traffic all at every hop the way through to the
workload pod. Be sure to measure the performance, latency, and operational
impact when making the decision to secure pod-to-pod traffic.

### Egress traffic flow

For zero-trust control and the ability to inspect traffic, all egress traffic
from the cluster moves through Azure Firewall. You can implement that choice
using user-defined routes (UDRs). The next hop of the route is the [private IP
address](https://docs.microsoft.com/azure/virtual-network/virtual-network-ip-addresses-overview-arm#private-ip-addresses)
of the Azure Firewall. Here, Azure Firewall decides whether to block or allow
the egress traffic. That decision is based on the specific rules defined in the Azure Firewall or
the built-in threat intelligence rules.

An exception to the zero-trust control is when the cluster needs to communicate
with other Azure resources. For instance, the cluster needs to pull an updated
image from the container registry. The recommended approach is by using  [Azure
Private Link](https://docs.microsoft.com/azure/private-link/private-link-overview).
The advantage is that specific subnets reach the service directly. Also, traffic
between the cluster and the service isn't exposed to public internet. A
downside is that Private Link needs additional configuration instead of using
the target service over its public endpoint. Also, not all Azure services or
SKUs support Private Link. For those cases, consider enabling a Service Endpoint
on subnet to access the service.

If Private Link or Service Endpoints are not an option, you can reach other
services through their public endpoints, and control access through Azure
Firewall rules and the firewall built into the target service. Because this
traffic will go through the static IP address of the firewall, that address can
be added the service’s IP allow list. One downside is that Azure Firewall will
need to have additional rules to make sure only traffic from specific subnet is
allowed.

### Pod-to-pod traffic

By default, a pod can accept traffic from any other pod in the cluster.
Kubernetes `NetworkPolicy` is used to restrict network traffic between pods. Apply
policies judiciously, otherwise you might have a situation where a critical
network flow is blocked. *Only* allow specific communication paths, as needed,
such as traffic between the ingress controller and workload. For more
information, see Network policies.

Enable network policy when the cluster is provisioned because it can't be added later. There are a few choices for technologies that
implement `NetworkPolicy`. Azure Network Policy is recommended, which requires
Azure Container Networking Interface (CNI), see the note below. Other options
include Calico Network Policy, a well-known open-source option. Consider Calico
if you need to manage cluster-wide network policies. Calico isn't covered under standard Azure support.

For information, see [Differences between Azure Network Policy and Calico
policies and their capabilities](https://docs.microsoft.com/azure/aks/use-network-policies#differences-between-azure-and-calico-policies-and-their-capabilities).

>[!NOTE]
> AKS supports two different networking models: kubenet and Azure Container
Networking Interface (CNI).

> CNI is more advanced of the two models. CNI is required for enabling Azure
Network Policy. In this model, every pod gets an IP address from the subnet
address space. Resources within the same network (or peered
resources) can access the pods directly through their IP address. NAT isn't
needed for routing that traffic. So, CNI performant because there aren’t
additional network overlays. It also offers better security control because
it enables the use Azure Network Policy.

> In general, CNI is recommended. CNI offers granular control by teams and the
resources they control. Also, CNI allows for more scaled pods than kubenet.

> Carefully consider the choice otherwise, the cluster will need to be
redeployed.

> For information about the models, see [Compare network
models](https://docs.microsoft.com/azure/aks/concepts-network#compare-network-models).

### Management traffic

As part of running the cluster, the Kubernetes API server will receive traffic
from resources that want to do management operations on the cluster, such as
requests to create resources or the scale the cluster. Examples of those
resources include the build agent pool in a DevOps pipeline, a Bastion subnet,
and node pools themselves. Instead of accepting this management traffic from all
IP addresses, use AKS’s Authorized IP Ranges feature to only allow traffic from
your authorized IP ranges to the API server.

For more information, see [Define API server authorized IP ranges](https://docs.microsoft.com/azure/aks/api-server-authorized-ip-ranges).


