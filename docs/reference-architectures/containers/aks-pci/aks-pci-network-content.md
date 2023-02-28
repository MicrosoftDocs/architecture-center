This article describes the networking considerations for an Azure Kubernetes Service (AKS) cluster that's configured in accordance with the Payment Card Industry Data Security Standard (PCI-DSS 3.2.1).

> This article is part of a series. Read the [introduction](aks-pci-intro.yml).

The main theme of the PCI-DSS 3.2.1 standard is security. The hub-spoke topology is a natural choice for setting up a regulated environment. It's easier to create an infrastructure that allows secure communications. Network controls are placed in both hub-spoke networks and follow the Microsoft zero-trust model. The controls can be tuned with least-privilege to secure traffic, giving access on a need-to-know basis. In addition, you can apply several defense-in-depth approaches by adding controls at each network hop.

When you're hosting a workload in a Kubernetes, it's not sufficient to rely on traditional network constructs, such as firewall rules. There are also Kubernetes-native constructs that control the flow of traffic within the cluster, such as the  `NetworkPolicy` resource. We highly recommend that you refer to the Kubernetes documentation to understand the core concepts about isolated pods, and ingress and egress policies.

> [!IMPORTANT]
>
> The guidance and the accompanying implementation builds on the [AKS baseline architecture](/azure/architecture/reference-architectures/containers/aks/baseline-aks). That architecture is based on a hub-spoke topology. The hub virtual network contains the firewall to control egress traffic, gateway traffic from on-premises networks, and a third network for maintenance. The spoke virtual network contains the AKS cluster that provides the card-holder environment (CDE), and hosts the PCI DSS workload.
>
> ![GitHub logo](../../../_images/github.png) [GitHub: Azure Kubernetes Service (AKS) Baseline Cluster for Regulated Workloads](https://github.com/mspnp/aks-baseline-regulated) demonstrates a regulated infrastructure. The implementation illustrates the use of various network and security controls within your CDE. This includes both network controls native to Azure and controls native to Kubernetes. It also includes an application just to demonstrate the interactions between the environment and a sample workload. The focus of this article is the infrastructure. The sample isn't indicative of an actual PCI-DSS 3.2.1 workload.

## Build and maintain a secure network and systems

### **Requirement 1**&mdash;Install and maintain a firewall configuration to protect cardholder data.

#### AKS feature support

AKS supports deploying a cluster in a private virtual network as a private cluster. Communication between the cluster and AKS-managed Kubernetes API server is over a trusted network. With a private cluster you can use  Azure Virtual Network, Network Security Group (NSG), and other built-in network controls to secure the entire cardholder data environment (CDE). This will prohibit any unauthorized public access between the internet and the environment. For details about how to provision such a cluster, see [Create a private Azure Kubernetes Service cluster](/azure/aks/private-clusters).

Azure Firewall can be integrated with AKS and can limit outbound traffic from the cluster, which is a key component of the CDE. The configuration is made easy with an AKS FQDN Tag. The recommended process is provided in [Use Azure Firewall to protect Azure Kubernetes Service (AKS) Deployments](/azure/firewall/protect-azure-kubernetes-service).

AKS clusters require some public internet access. Limit outbound traffic to the internet using Azure Firewall and NSGs on the cluster subnet. For information, see [Control egress traffic for cluster nodes in Azure Kubernetes Service (AKS)](/azure/aks/limit-egress-traffic).

AKS optionally supports the ability to define an [HTTP proxy](/azure/aks/http-proxy), which can be utilized for additional outbound traffic control and monitoring for the cluster. The cluster nodes use the specified HTTP proxy configuration for routing outbound traffic. Also, a MutatingWebhook is registered to inject the proxy information into the pods at creation time, so it is recommended that workloads can inherit the same proxy information. Pods can override proxy information, so it is recommended to use an HTTP proxy in addition to an Azure Firewall.

AKS clusters should be created with the NetworkPolicy plugin. In AKS, you have the option between Azure or Calico, as your Network Policy plugin. With Calico Network Policy, you could either use Kubenet or Azure CNI. For the Azure Network Policy, you can only use Azure CNI (not Kubenet). Network Policies for Windows nodes are supported with Calico only. Both Azure and [Calico](https://www.tigera.io/project-calico/) Network Policy plugins are open source. For further information about Project Calico, see the [comprehensive PCI solution whitepaper](https://www.tigera.io/lp/kubernetes-pci-compliance/?utm_campaign=calicocloud&utm_medium=digital&utm_source=microsoft_aks_pciwhitepaper), which addresses many of the firewall requirements below.

#### Your responsibilities

|Requirement|Responsibility|
|---|---|
|[Requirement 1.1](#requirement-11)|Establish and implement firewall and router configuration standards.|
|[Requirement 1.2](#requirement-12)|Build firewall and router configurations that restrict connections between untrusted networks and any system components in the cardholder data environment.|
|[Requirement 1.3](#requirement-13)|Prohibit direct public access between the Internet and any system component in the cardholder data environment.|
|[Requirement 1.4](#requirement-14)|Install personal firewall software or equivalent functionality on any portable computing devices (including company and/or employee-owned) that connect to the Internet when outside the network (for example, laptops used by employees), and which are also used to access the CDE. |
|[Requirement 1.5](#requirement-15)|Ensure that security policies and operational procedures for managing firewalls are documented, in use, and known to all affected parties.|

### Requirement 1.1

Establish and implement firewall and router configuration standards that include the following:

#### Requirement 1.1.1

A formal process for approving and testing all network connections and changes to the firewall and router configurations.

##### Your responsibilities

Don't implement configurations manually, such as by using the Azure portal or the Azure CLI directly. We recommend using Infrastructure as Code (IaC). With IaC, infrastructure is managed through a descriptive model that uses a versioning system. The IaC model generates the same environment every time it's applied. Common examples of IaC are Azure Resource Manager or Terraform. If IaC is not an option, have a well-documented process for tracking, implementing, and safely deploying firewall rule changes. More details are provided as part of [Requirement 11.2](./aks-pci-monitor.yml#requirement-112).

You'll need to use a combination of various network controls, including Azure Firewall, network security groups (NSGs), and the Kubernetes `NetworkPolicy` resource.

Minimize the number of people who can access and modify network controls. Define roles and clear responsibilities to teams. For example, an organization's network team will validate the changes per the governance policies set by IT teams. Have a gated approval process that involves people and processes to approve changes to any network configuration. The process should include a step for testing all network controls. Have detailed documentation that describes the process.

#### Requirement 1.1.2

Current network diagram that identifies all connections between the cardholder data environment and other networks, including any wireless networks

##### Your responsibilities

As part of your documentation, maintain a network flow diagram that shows the incoming and outgoing traffic with security controls. This includes traffic flow from other networks including any wireless network to the CDE. The diagram should also show flows within the cluster. There are some specific requirements for diagrams, they should show the intrusion sensors. The controls for

This image shows the network diagram of the reference implementation.

:::image type="content" source="./images/network-topology-small.svg" alt-text="Diagram of the network topology." lightbox="./images/network-topology-small.svg":::

*Download a [Visio file](https://arch-center.azureedge.net/aks-pci-network.vsdx) of this diagram.*

**Figure 1.1.2 - Network flow**

The description of this flow is in the following sections.

You can [view the topology of an Azure virtual network](/azure/network-watcher/view-network-topology) if you have  Azure Network Watcher. You can view all of the resources in a virtual network, the resources associated to resources in a virtual network, and the relationships between the resources.

#### Requirement 1.1.3

Current diagram that shows all cardholder data flows across systems and networks.

##### Your responsibilities

As part of your documentation, include a data flow diagram that shows how data is protected at rest and in transit.

The diagram should show how data flows to and from the workload and what information is passed from one resource to another. Make sure the diagram is kept current. Add a step as part of the change management process, to update the data flow diagram.

Because this architecture is focused on the infrastructure and *not* the workload, we have omitted illustrations here.

#### Requirement 1.1.4

Requirements for a firewall at each Internet connection and between any demilitarized zone (DMZ) and the internal network zone.

##### Your responsibilities

Have a clear definition of what defines the boundary of a DMZ. For example, the cardholder data environment (CDE) is within a DMZ secured by firewall, network policy, and other controls. For more information, see [Cloud DMZ](/azure/cloud-adoption-framework/decision-guides/software-defined-network/cloud-dmz).

For a PCI DSS infrastructure, you're responsible for securing the CDE by using network controls to block unauthorized access into and out of the network with the CDE. Network controls must be configured properly for a strong security posture, and they must be applied to:

- Communication between the colocated components within the cluster.
- Communication between the workload and other components in trusted networks.
- Communication between the workload and public internet.

This architecture uses different firewall technologies to inspect traffic flowing in both directions, to and from the cluster that hosts the CDE:

- Azure Application Gateway integrated web application firewall (WAF) is used as the traffic router and for securing inbound (ingress) traffic to the cluster.

- Azure Firewall is used to secure all outbound (egress) traffic from any network and its subnets.

   As part of processing a transaction or management operations, the cluster will need to communicate with external entities. For example, the cluster might require communication with the AKS control plane, getting Windows and package updates, and the workload's interaction with external APIs. Some of those interactions might be over HTTP and should be considered as attack vectors. Those vectors are targets for a man-in-the-middle attack that can result in data exfiltration. Adding a firewall to egress traffic mitigates that threat.

   We recommend that even pod-to-pod communication is TLS-encrypted. This practice is shown in the reference implementation with the use of a mTLS mesh.

- NSGs are added to secure traffic between the cluster and other components within the infrastructure. For example, in the reference implementation, there are NSGs on the subnet with node pools that block any SSH access attempts. Only traffic from the virtual network is allowed.

   As you add components to the architecture, consider adding more NSGs that allow or deny traffic types at subnet boundaries. Because each node pool is in a dedicated subnet, apply more specific rules based on expected traffic patterns of your workload.

- Kubernetes `NetworkPolicy`

   By default, there are no restrictions on pod-to-pod communication. You need to apply `NetworkPolicy` on in-cluster communications, starting with a zero-trust network and opening paths as needed. The reference implementation demonstrates zero-trust networks in the `a0005-i` and `a0005-o` namespaces.  All namespaces (except `kube-system`, `gatekeeper-system`, and other AKS-provided namespaces) have restrictive `NetworkPolicy` applied. The policy definition depends on the pods running in those namespaces. Make sure you open paths for readiness, liveliness, and startup probes. Also, open the path to `oms-agent` so that node-level metrics can be sent. Consider standardizing ports across the workloads so that you can provide a consistent `NetworkPolicy` and Azure Policy for the allowed container ports.

#### Requirement 1.1.5

Description of groups, roles, and responsibilities for management of network components.

##### Your responsibilities

You'll need to provide controls on the network flows and the components involved. The resulting infrastructure will have several network segments, each with many controls, and each control with a purpose. Make sure your documentation not only has the breadth of coverage from network planning to all configurations but also has the details on ownership. Have clear lines of responsibility and the roles that are responsible for them.

For example, know who is responsible for the governance of securing network between Azure and the internet. In an enterprise, the IT team is responsible for configuration and maintenance of Azure Firewall rules, Web Application Firewall (WAF), NSGs, and other cross-network traffic. They might also be responsible for enterprise-wide virtual network and subnet allocation, and IP address planning.

At the workload level, a cluster operator is responsible for maintaining Zero-Trust through network policies. Also, responsibilities might include communication with the Azure control plane, Kubernetes APIs, and monitoring technologies.

Always start with a deny-all strategy. Give permission only when there's a business need or a role justification.

#### Requirement 1.1.6

Documentation of business justification and approval for use of all services, protocols, and ports allowed, including documentation of security features implemented for those protocols considered to be insecure.

##### Your responsibilities

Have detailed documentation that describes the services, protocols, and ports used in the network controls. Deny all except for explicitly allowed ports. Document business justification and documented security features if the use of insecure protocols can't be avoided. Here are some examples from the reference implementation for Azure Firewall. Firewall rules must be scoped exclusively to their related resources. That is, only traffic from specific sources is allowed to go to specific FQDN targets. Here are some cases to allow traffic.

|Rule|Protocol:Port|Source|Destination|Justification
|---|---|---|---|---|
|Allow secure communication between the nodes and the control plane.|HTTPS:443|Authorized IP address ranges assigned to the cluster node pools| List of FQDN targets in the AKS control plane. This is specified with the `AzureKubernetesService` FQDN tag.|The nodes need access to the control plane for management tools, state and configuration information, and information about which nodes can be scaled.|
|Allow secure communication between Flux and GitHub.|HTTPS:443|AKS node pools|github.com,api.github.com|Flux is a third-party integration that runs on the nodes. It synchronizes cluster configuration with a private GitHub repository.|

#### Requirement 1.1.7

Requirement to review firewall and router rule sets at least every six months.

##### Your responsibilities

Have processes at least every six months to review the network configurations and the scoped rules. This will make sure the security assurances are current and valid. Make sure you review these configurations:

- Azure Firewall rules.
- NSG rules.
- Azure Application Gateway and WAF rules.
- Native Kubernetes network policies.
- Firewall controls on the applicable Azure resources. For example, this architecture uses a rule on Azure Container Registry that only allows traffic from a private endpoint.
- Any other network controls you have added to the architecture.

#### Requirement 1.2

Build firewall and router configurations that restrict connections between untrusted networks and any system components in the cardholder data environment.

##### Your responsibilities

In this architecture, the AKS cluster is a key component of the cardholder data environment (CDE). We strongly recommend that the cluster is deployed as a private cluster for enhanced security. In a private cluster, network traffic between the AKS-managed Kubernetes API server and your node pools is private. The API server is exposed via a Private Endpoint in the cluster's network.

You can also choose a public cluster, but however, this design isn't recommended for clusters containing regulated workloads. The API server will be exposed to the internet. The DNS record will always be discoverable. So, you need to have controls to keep the cluster API protected from public access. If using a public cluster is required, then the recommended approach is to have tight controls through Kubernetes role-based access controls (RBAC), paired with the AKS Authorized IP ranges feature to restrict who can access the AKS API Server. However, this solution isn't recommended for clusters containing regulated workloads.

When processing card holder data (CHD), the cluster needs to interact with networks that are considered to be trusted and untrusted. In this architecture, both the hub-spoke networks within the perimeter of PCI-DSS 3.2.1 workload are considered to be trusted networks.

Untrusted networks are networks outside that perimeter. This category includes the other hubs and spokes that might be on the same infrastructure, but are outside the workload perimeter, public internet, the corporate network, or virtual networks in Azure or another cloud platform. In this architecture, the virtual network that hosts the image builder is untrusted because it has no part to play in CHD handling. The CDE's interaction with such networks should be secured as per the requirements. With this private cluster, you can use Azure Virtual Network, an NSG, and other built-in features to secure the entire environment.

For information about private clusters, see [Create a private Azure Kubernetes Service cluster](/azure/aks/private-clusters).

#### Requirement 1.2.1

Restrict inbound and outbound traffic to that which is necessary for the cardholder data environment, and specifically deny all other traffic.

##### Your responsibilities

By design, Azure Virtual Network cannot be directly reached by the public internet. All inbound (or *ingress*) traffic must go through an intermediate traffic router. However, all components in the network can reach public endpoints. That outbound (or *egress*) traffic must be explicitly secured allowing only secure ciphers and TLS 1.2 or later.

-  Azure Application Gateway integrated WAF intercepts all HTTP(S) ingress traffic and routes inspected traffic to the cluster.

   This traffic can originate from trusted or untrusted networks. Application Gateway is provisioned in a subnet of the spoke network and secured by an NSG. As traffic flows in, WAF rules allow or deny, and route traffic to the configured backend. For example, Application Gateway protects the CDE by denying this type of traffic:
    - All traffic that is not TLS-encrypted.
    - Traffic outside the port range for control plane communication from the Azure infrastructure.
    - Health probes requests that are sent by entities other than the internal load balancer in the cluster.

- Azure Firewall is used to secure all outbound (egress) traffic from trusted and untrusted networks.

   Azure Firewall is provisioned in a subnet of the hub network. To enforce Azure Firewall as the single egress point, user-defined routes (UDRs) are used on subnets that are capable of generating egress traffic. This includes subnets in untrusted networks, such as the image builder virtual network. After the traffic reaches Azure Firewall, several scoped rules are applied that allow traffic from specific sources to go to specific targets.

   For more information, see [Use Azure Firewall to protect Azure Kubernetes Service (AKS) Deployments](/azure/firewall/protect-azure-kubernetes-service).

- Optionally, it's possible to use an HTTP proxy for monitoring and securing outbound (egress) traffic, from the cluster to external resources.

   In addition to a firewall, some organizations might want to use an HTTP proxy to have additional controls on egress. We recommend you to still have the user-defined routes go to the firewall and to limit egress traffic to just go to the HTTP proxy. With this setup, if a pod tries to override the proxy, then the firewall can still block egress traffic.
   
   For more information, see [HTTP proxy support in Azure Kubernetes Service](/azure/aks/http-proxy).

The cluster might require access other services over the public internet. If you use a third-party antimalware software, it will need to get the virus definitions from a server over the public internet.

Interactions with endpoints of other Azure services are over the Azure backbone. For example, as part of the regular operations, the cluster will need to get certificates from the managed key store, pull images from a container registry, and so on. Ensure those interactions are private and secure using [Azure Private Link](/azure/private-link/private-link-overview).

In addition to firewall rules and private networks, NSG flows are also secured through rules. Here some examples from this architecture where the CDE is protected by denying traffic:
- The NSGs, on subnets that have node pools, deny any SSH access to its nodes. Have a process in place for just-in-time emergency access while still maintaining the deny-all principle.
- The NSG, on the subnet that has the jump box for running management tools, denies all traffic except from Azure Bastion in the hub network.
- The NSGs, on subnets that have the private endpoints to Azure Key Vault and Azure Container Registry, deny all traffic except from the internal load balancer and the traffic over Azure Private Link.

#### Requirement 1.2.2

Secure and synchronize router configuration files.

##### Your responsibilities

Have a mechanism to detect the delta between the actual deployed state and the desired state. Infrastructure as Code (IaC) is a great choice for that purpose. For example, Azure Resource Manager templates have a record of the desired state.

The deployment assets, such as ARM templates, must be source-controlled so that you have the history of all changes. Collect information from Azure activity logs, deployment pipeline logs, and Azure deployment logs. Those sources will help you keep a trail of deployed assets.

In the cluster, network controls such as Kubernetes network policies should also follow the source-controlled flow. In this implementation, Flux is used as the GitOps operator. When you're synchronizing a cluster configuration such as network policies, your Git history combined with Flux and API logs can be a configuration history source.

#### Requirement 1.2.3

Install perimeter firewalls between all wireless networks and the cardholder data environment, and configure these firewalls to deny or, if traffic is necessary for business purposes, permit only authorized traffic between the wireless environment and the cardholder data environment.

##### Your responsibilities

The AKS nodes and the node pools must not be reachable from wireless networks. Also, requests to the Kubernetes API server must be denied. Access to those components is restricted to authorized and secured subnets.

In general, limit access from on-premises traffic to the spoke network.

#### Requirement 1.3

Prohibit direct public access between the Internet and any system component in the cardholder data environment.

##### Your responsibilities

AKS cluster node pools operate within the virtual network and isolated from public networks such as the internet. Maintain isolation by preventing the association of public IPs to cluster nodes, and by applying NSG rules on the cluster subnets to make sure internet traffic is blocked. For information about controlled access, see the [DMZ section](#requirement-131).

The AKS cluster has system node pools that host critical system pods. Even on the user node pools, there are pods that run other services that participate in cluster operations. For example, pods might run Flux to synchronize cluster configuration to a GitHub repository, or the ingress controller to route traffic to the workload pods. Regardless of the type of node pool, all nodes must be protected.

Another critical system component is the API server that is used to do native Kubernetes tasks, such as maintain the state of the cluster and configuration. An advantage of using a private cluster is that API server endpoint isn't exposed by default. For information about private clusters, see [Create a private Azure Kubernetes Service cluster](/azure/aks/private-clusters).

Interactions with other endpoints must also be secured. One way is by restricting communications over a private network. For instance, have the cluster pull images from Azure Container Registry over a private link.

#### Requirement 1.3.1

Implement a DMZ to limit inbound traffic to only system components that provide authorized publicly accessible services, protocols, and ports.

##### Your responsibilities

Here are some best practices:

- Do not configure public IP addresses on the node pool nodes.
- Use Azure Policy to ensure Kubernetes don't expose a public load balancer. Traffic within the cluster must be routed through internal load balancers.
- Only expose internal load balancers to Azure Application Gateway integrated with WAF.
- All network controls should specify source, destination, port, and protocol restrictions, where applicable.
- Do not expose the API server to the internet. When you run the cluster in private mode, the endpoint is not exposed and communication between the node pools and the API server is over a private network.

Users can implement a perimeter network to protect AKS clusters. For information, see [Cloud DMZ](/azure/cloud-adoption-framework/decision-guides/software-defined-network/cloud-dmz).

#### Requirement 1.3.2

Limit inbound Internet traffic to IP addresses within the DMZ.

##### Your responsibilities

In the cluster network, have an NSG on the subnet with the internal load balancer. Configure rules to only accept traffic from subnet that has Azure Application Gateway integrated with WAF. Within the AKS cluster, use Kubernetes `NetworkPolicies` to restrict ingress traffic to the pods.

#### Requirement 1.3.3

Implement anti-spoofing measures to detect and block forged source IP addresses from entering the network.

##### Azure responsibilities

Azure implements network filtering to prevent spoofed traffic and restrict incoming and outgoing traffic to trusted platform components.

#### Requirement 1.3.4

Do not allow unauthorized outbound traffic from the cardholder data environment to the Internet.

##### Your responsibilities

Here are ways in which you can block unauthorized outbound traffic:

- Enforce all outbound (egress) traffic from the AKS cluster to go through Azure Firewall by using user-defined routes (UDRs) on all cluster subnets. This includes subnets with system and user node pools.
- Limit outbound traffic by adding NSGs on subnets with node pools.
- Use Kubernetes `NetworkPolicies` to restrict egress traffic from the pods.
- Use a service mesh to handle additional policies. For example, if you only allow TLS-encrypted traffic between pods, the service mesh proxy can handle the TLS verification. That example is demonstrated in this implementation. Envoy is deployed as the proxy.
- Prevent addition of public IP addresses to the networks within the CDE unless by subnets explicitly authorized, such as the Firewall subnets.
- Use an HTTP proxy, in addition to Azure Firewall, to limit outbound (egress) traffic from the AKS cluster to the internet.
- Use [Azure Monitor Private Link Service](/azure/azure-monitor/logs/private-link-security) (AMPLS) to have logs from Container insights sent over a secure, private connection to Azure Monitor. Understand the impact of [enabling AMPLS](/azure/azure-monitor/logs/private-link-security#private-link-access-modes-private-only-vs-open).

> [!NOTE]
> You can use Kubernetes `NetworkPolicies` to restrict ingress and egress traffic to and from the pods.

For details, see [Control egress traffic for cluster nodes in Azure Kubernetes Service (AKS)](/azure/aks/limit-egress-traffic).

#### Requirement 1.3.5

Permit only "established" connections into the network.

##### Azure responsibilities

Azure implements network filtering to prevent spoofed traffic and restrict incoming and outgoing traffic to trusted platform components. The Azure network is segregated to separate customer traffic from management traffic.

#### Requirement 1.3.6

Place system components that store cardholder data (such as a database) in an internal network zone, segregated from the DMZ and other untrusted networks.

##### Your responsibilities

Expose your storage systems only over a private network, for instance by using Private Link. Also, restrict access from the node pool subnet(s) that require it. Keep state out of the cluster and in its own dedicated security zone.

#### Requirement 1.3.7

Do not disclose private IP addresses and routing information to unauthorized parties.

##### Your responsibilities

To meet this requirement, a public AKS cluster is not an option. A private cluster keeps DNS records off the public internet by using a private DNS zone. However, it's still possible to [Create a private AKS cluster with a Public DNS address](/azure/aks/private-clusters#create-a-private-aks-cluster-with-a-public-dns-address). So, it's recommended to *explicitly* disable this feature by setting `enablePrivateClusterPublicFQDN` to `false` to prevent disclosure of your control plane's private IP address. Consider using Azure Policy to enforce the use of private clusters without public DNS records.

Also, use a private DNS zone for routing between the subnet that has Azure Application Gateway integrated with WAF, and the subnet that has the internal load balancer. Ensure that no HTTP responses include any private IP information in the headers or body. Ensure that logs that might contain IP and DNS records are not exposed outside of operational needs.

An Azure service that's connected through Private Link doesn't have a public DNS record exposing your IP addresses. Your infrastructure should make optimal use of Private Link.

### Requirement 1.4

Install personal firewall software or equivalent functionality on any portable computing devices that connect to the Internet when outside the network, and which are also used to access the CDE.

##### Your responsibilities

The private cluster is managed by the AKS control plane. You don't have access to nodes directly. For doing administrative tasks you'll need to use management tools such as kubectl from a separate compute resource. An option is to use an air-gapped jump box where you can run the commands. Also inbound and outbound traffic from the jump box must be restricted and secure. If VPN is used for access, make sure the client machine is managed by corporate policy and all conditional access policies are in place.

In this architecture, that jump box is in a separate subnet in the spoke network. Inbound access to the jump box is restricted by using an NSG that only allows access through Azure Bastion over SSH.

To run certain commands on the jump box, you'll need to reach public endpoints. For example, endpoints managed by the Azure management plane. That outbound traffic must be secure. Similar to other components in the spoke network, outbound traffic from the jump box is restricted by using a UDR that forces HTTPs  traffic to go through Azure Firewall.

### Requirement 1.5

Ensure that security policies and operational procedures for managing firewalls are documented, in use, and known to all affected parties.

##### Your responsibilities

It's critical that you maintain thorough documentation about the process and policies. This is especially true when you're managing Azure Firewall rules that segment the AKS cluster. People operating regulated environments must be educated, informed, and incentivized to support the security assurances. This is particularly important for people with accounts that are granted broad administrative privileges.

### **Requirement 2**&mdash;Do not use vendor-supplied defaults for system passwords and other security parameters.

#### Your responsibilities

|Requirement|Responsibility|
|---|---|
|[Requirement 2.1](#requirement-21)|Always change vendor-supplied defaults and remove or disable unnecessary default accounts before installing a system on the network.|
|[Requirement 2.2](#requirement-22)|Develop configuration standards for all system components. Assure that these standards address all known security vulnerabilities and are consistent with industry-accepted system hardening standards.|
|[Requirement 2.3](#requirement-23)|Encrypt all non-console administrative access using strong cryptography.|
|[Requirement 2.4](#requirement-24)|Maintain an inventory of system components that are in scope for PCI DSS.|
|[Requirement 2.5](#requirement-25)|Ensure that security policies and operational procedures for managing vendor defaults and other security parameters are documented, in use, and known to all affected parties.|
|[Requirement 2.6](#requirement-26)|Shared hosting providers must protect each entity's hosted environment and cardholder data.|

Do not use vendor-supplied defaults for system passwords and other security parameters

### Requirement 2.1

Always change vendor-supplied defaults and remove or disable unnecessary default accounts before installing a system on the network.

#### Your responsibilities

Default settings provided by vendors must be changed. Default settings are common attack vectors and make the system prone to attacks. Here are some considerations:
- Disable administrator access on the container registry.
- Ensure that jump boxes and build agents follow user management procedures, removing needed system users.
- Do not generate or provide SSH key access to nodes to administrator user. If emergency access is necessary, use the Azure recovery process to get just-in-time access.

#### Azure responsibilities

Azure Active Directory has password policies that are enforced on the new passwords supplied by users. If you change a password, validation of older password is required. Administrator reset passwords are required to be changed upon subsequent login.

#### Requirement 2.1.1

For wireless environments connected to the cardholder data environment or transmitting cardholder data, change ALL wireless vendor defaults at installation, including but not limited to default wireless encryption keys, passwords, and SNMP community strings.

##### Your responsibilities

This architecture and the implementation aren't designed to do on-premises or corporate network to cloud transactions over wireless connections. For considerations, refer to the guidance in the official PCI-DSS 3.2.1 standard.

### Requirement 2.2

Develop configuration standards for all system components.

#### Your responsibilities

Implement the recommendations in the Azure security benchmark. It provides a single, consolidated view of Azure security recommendations, covering industry frameworks such as CIS, NIST, PCI-DSS 3.2.1, and others. Use Microsoft Defender for Cloud features and Azure Policy to help track against the standards. Azure security benchmark is the default initiative for Microsoft Defender for Cloud. Consider building additional automated checks in Azure Policy and Azure Tenant Security Solution (AzTS).

Document the desired configuration state of all components in the CDE, especially for AKS nodes, jump box, build agents, and other components that interact with the cluster.

For more information, see [Azure security benchmark](/security/benchmark/azure/introduction).

#### Azure responsibility

Azure provides security configuration standards that are consistent with industry-accepted hardening standards. The standards are reviewed at least annually.

#### Requirement 2.2.1

Implement only one primary function per server to prevent functions that require different security levels from co-existing on the same server. (For example, web servers, database servers, and DNS should be implemented on separate servers.)

##### Your responsibilities

The key strategy is to provide the required level of segmentation. One way is to deploy in-scope and out-of-scope components in separate clusters. Understand that this results in increased costs for the added infrastructure and the maintenance overhead. Another approach is to co-locate all components in a shared cluster. Use segmentation strategies to maintain the separation. For example, have separate node pools within a cluster.

In the reference implementation, the second approach is demonstrated with a microservices application deployed to a single cluster. The application has two sets of services: one set has in-scope pods, and the other is out-of-scope. Both sets are spread across two user node pools. With the use of Kubernetes taints, in-scope and out-of-scope pods are deployed to separate node pools, and they never share a node VM.

For container technologies, that segmentation is provided by default because only one instance of a container is responsible for one function in the system.

The workload should use pod-managed identity. It must not inherit any cluster-level or node-level identity.

Use external storage instead of on-node (in-cluster) storage where possible. Keep cluster pods reserved exclusively for work that must be performed as part of the operation of card holder data processing. Move the out-of-scope operations outside the cluster. This guidance applies to build agents, unrelated workloads, or activities such as having a jump box inside the cluster.

#### Requirement 2.2.2

Enable only necessary services, protocols, daemons, etc., as required for the function of the system.

##### Your responsibilities

Review the features and the implications before enabling them. Default settings might include features you don't need, and those features might need visibility into the workload. An example of this is the ciphers in the default SSL policy for Azure Application Gateway. Check if the policy is overly permissive. The recommendation is to create a custom policy by selecting only the ciphers you need.

For components where you have complete control, remove all unnecessary system services from the images (for example jump boxes and build agents).

For components where you only have visibility, such as AKS nodes, document what Azure installs on the nodes. Consider using `DaemonSets` to provide any additional auditing necessary for these cloud-controlled components.

#### Requirement 2.2.3

Implement additional security features for any required services, protocols, or daemons that are considered to be insecure.

##### Your responsibilities

Application Gateway has an integrated WAF, and negotiates the TLS handshake for the request sent to its public endpoint, allowing only secure ciphers. The reference implementation only supports TLS 1.2 and approved ciphers.

Suppose you have a legacy device that needs to interact with the CDE through Azure Application Gateway. For that, Application Gateway must enable an insecure protocol. Document that exception and monitor if that protocol is used beyond that legacy device. Disable that protocol immediately after that legacy interaction is discontinued.

Also, Application Gateway must not respond to requests on port 80. Do not perform redirects at the application level. This reference implementation has an NSG rule on that blocks port 80 traffic. The rule is on the subnet with Application Gateway.

If a workload in your cluster cannot adhere to organizational policy around security compliance profiles or other controls (for example, limits and quotas), then make sure the exception is documented. You must monitor to ensure that only expected functionality is performed.

#### Requirement 2.2.4

Configure system security parameters to prevent misuse.

##### Your responsibilities

All Azure services used in the architecture must follow the recommendations provided by [Azure security benchmark](/security/benchmark/azure/introduction). These recommendations give you a starting point for selecting specific security configuration settings. Also, compare your configuration against the baseline implementation for that service. For more information about the security baselines, see [Security baselines for Azure](/security/benchmark/azure/security-baselines-overview).

The Open Policy Agent admission controller works in conjunction with Azure Policy to detect and prevent misconfigurations on the cluster. Suppose there's an organizational policy that doesn't allow public IP allocations on the nodes. When such an allocation is detected, it's marked for audit or denied based on the action specified in the policy definition.

At the infrastructure level, you can apply restrictions on the type and configuration of Azure resources. Use Azure Policy to prevent those cases. In this reference implementation, there's a policy that denies the creation of AKS clusters that aren't private.

Routinely ensure all exceptions are documented and reviewed.

##### Azure responsibilities

Azure ensures that only authorized personnel are able to configure Azure platform security controls, by using multi-factor access controls and a documented business need.

#### Requirement 2.2.5

Remove all unnecessary functionality, such as scripts, drivers, features, subsystems, file systems, and unnecessary web servers.

##### Your responsibilities

Don't install software on jump boxes or build agents that don't participate in the processing of a transaction or provide observability for compliance requirements, such as security agents. This recommendation also applies to the cluster entities, such as `DaemonSet` and pods. Make sure all installations are detected and logged.

### Requirement 2.3

Encrypt all non-console administrative access using strong cryptography.

#### Your responsibilities

All administrative access to the cluster should be done by using the console. Do not expose the cluster's control plane.

##### Azure responsibilities

Azure ensures the use of strong cryptography is enforced when accessing the hypervisor infrastructure. It ensures that customers using the Microsoft Azure Management Portal are able to access their service/IaaS consoles with strong cryptography.

### Requirement 2.4

Maintain an inventory of system components that are in scope for PCI DSS.

#### Your responsibilities

All Azure resources used in the architecture must be tagged properly. The tags help in data classification and indicate whether the service is in-scope or out-of-scope. Meticulous tagging will allow you to query for resources, keep an inventory, help track costs, and set alerts. Also maintain a snapshot of that documentation periodically.

Avoid tagging in-scope or out-of-scope resources at a granular level. As the solution evolves, out-of-scope resources might become in-scope even if they indirectly interact or are adjacent to the card holder data. These resources are subject to audit, and could be part of a representative sample during audit. Consider tagging at a higher level, at the subscription and cluster level.

For information about tagging considerations, see [Resource naming and tagging decision guide](/azure/cloud-adoption-framework/decision-guides/resource-tagging/).

Tag in-cluster objects by applying Kubernetes labels. This way you can organize objects, select a collection of objects, and report inventory.

### Requirement 2.5

Ensure that security policies and operational procedures for managing vendor defaults and other security parameters are documented, in use, and known to all affected parties.

#### Your responsibilities

It's critical that you maintain thorough documentation about the processes and policies. Personnel should be trained in the security features and configuration settings of each Azure resource. People operating regulated environments must be educated, informed, and incentivized to support the security assurances. This is particularly important for admin accounts that are granted broad administrative privileges.

### Requirement 2.6

Shared hosting providers must protect each entity's hosted environment and cardholder data.

#### Your responsibilities

Azure provides security assurances for any hosted environment components that are shared. It's highly recommended that you treat your AKS nodes as a dedicated host for this workload. That is, all compute should be in a single tenant model and not shared with other workloads you may operate.

If complete compute isolation is desired at the Azure infrastructure level, you can [Add Azure Dedicated Host to an Azure Kubernetes Service (AKS) cluster](/azure/aks/use-azure-dedicated-hosts). This offering provides _physical_ servers dedicated to your workload, allowing you to place AKS nodes directly into these provisioned hosts. This architectural choice has significant cost & capacity planning impact and is not typical for most scenarios.

## Next steps

Protect stored cardholder data. Encrypt transmission of cardholder data across open, public networks.

> [!div class="nextstepaction"]
> [Protect cardholder data](aks-pci-data.yml)

## Related resources

- [Azure Kubernetes Service (AKS) architecture design](/azure/architecture/reference-architectures/containers/aks-start-here)
- [Introduction of an AKS regulated cluster for PCI-DSS 3.2.1 (Part 1 of 9)](/azure/architecture/reference-architectures/containers/aks-pci/aks-pci-intro)
- [Architecture of an AKS regulated cluster for PCI-DSS 3.2.1 (Part 2 of 9)](/azure/architecture/reference-architectures/containers/aks-pci/aks-pci-ra-code-assets)
- [Baseline architecture for an Azure Kubernetes Service (AKS) cluster](/azure/architecture/reference-architectures/containers/aks/secure-baseline-aks)
- [AKS baseline for multiregion clusters](/azure/architecture/reference-architectures/containers/aks-multi-region/aks-multi-cluster)
