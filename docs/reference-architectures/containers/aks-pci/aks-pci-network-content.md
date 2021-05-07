This article describes the considerations for an Azure Kubernetes Service (AKS) cluster that runs a workload in compliance with the Payment Card Industry Data Security Standard (PCI-DSS). 

> This article describes the responsibilities of a workload owner in how the workload interacts with the infrastructure. This article is part of a series. Read the [introduction](aks-pci-intro.yml) here.

![GitHub logo](../../../_images/github.png) [GitHub: Azure Kubernetes Service (AKS) Baseline Cluster for Regulated Workloads](https://github.com/mspnp/aks-baseline-regulated) demonstrates the regulated infrastructure. This implementation provides a microservices application. It's included to help you experience the infrastructure and illustrate the network and security controls. The application does not represent or implement an actual PCI DSS workload.

> [!IMPORTANT]
>
> The guidance in this article and the above-mentioned reference implementation builds on the [AKS baseline architecture](/azure/architecture/reference-architectures/containers/aks/secure-baseline-aks). That architecture based on a hub and spoke topology. The hub virtual network contains the firewall to control egress traffic, gateway traffic from on-premises networks, and a third network for maintainence. The spoke virtual network contains the AKS cluster that provides the card holder environment (CDE) and hosts the PCI DSS workload. 

## Build and Maintain a Secure Network and Systems
The hub and spoke topology in the baseline is a natural choice for a PCI DSS infrastructure. Network controls are placed in both hub and spoke networks and follow the Microsoft zero-trust model. The controls can be tuned with least-privilege to secure traffic giving access on a need-to-know basis. In addition, several defense-in-depth approaches can be applied by adding controls at each network hop. 

# [Requirement 1](#tab/tab-id-1)

[**Requirement 1**](#requirement-11establish-and-implement-firewall-and-router-configuration-standards-that-include-the-following)&mdash;Install and maintain a firewall configuration to protect cardholder data.

|Requirement|Responsibility|
|---|---|
|[Requirement 1.1](#requirement-11establish-and-implement-firewall-and-router-configuration-standards-that-include-the-following)|Establish and implement firewall and router configuration standards.|
|[Requirement 1.2](#requirement-12build-firewall-and-router-configurations-that-restrict-connections-between-untrusted-networks-and-any-system-components-in-the-cardholder-data-environment)|Build firewall and router configurations that restrict connections between untrusted networks and any system components in the cardholder data environment.|
|[Requirement 1.3](#requirement-13prohibit-direct-public-access-between-the-internet-and-any-system-component-in-the-cardholder-data-environment)|Prohibit direct public access between the Internet and any system component in the cardholder data environment.|
|[Requirement 1.4](#requirement-14install-personal-firewall-software-or-equivalent-functionality-on-any-portable-computing-devices-that-connect-to-the-internet-when-outside-the-network--and-which-are-also-used-to-access-the-cde)|Install personal firewall software or equivalent functionality on any portable computing devices (including company and/or employee-owned) that connect to the Internet when outside the network (for example, laptops used by employees), and which are also used to access the CDE. |
|[Requirement 1.5](#requirement-15ensure-that-security-policies-and-operational-procedures-for-managing-firewalls-are-documented-in-use-and-known-to-all-affected-parties)|Ensure that security policies and operational procedures for managing firewalls are documented, in use, and known to all affected parties.|
# [Requirement 2](#tab/tab-id-2)

[**Requirement 2**](#requirement-2do-not-use-vendor-supplied-defaults-for-system-passwords-and-other-security-parameters)&mdash;Do not use vendor-supplied defaults for system passwords and other security parameters.

|Requirement|Responsibility|
|---|---|
|[Requirement 2.1](#requirement-21always-change-vendor-supplied-defaults-and-remove-or-disable-unnecessary-default-accounts-before-installing-a-system-on-the-network)|Always change vendor-supplied defaults and remove or disable unnecessary default accounts before installing a system on the network.|
|[Requirement 2.2](#requirement-22develop-configuration-standards-for-all-system-components)|Develop configuration standards for all system components. Assure that these standards address all known security vulnerabilities and are consistent with industry-accepted system hardening standards.|
|[Requirement 2.3](#requirement-23encrypt-all-non-console-administrative-access-using-strong-cryptography)|Encrypt all non-console administrative access using strong cryptography.|
|[Requirement 2.4](#requirement-24maintain-an-inventory-of-system-components-that-are-in-scope-for-pci-dss)|Maintain an inventory of system components that are in scope for PCI DSS.|
|[Requirement 2.5](#requirement-25ensure-that-security-policies-and-operational-procedures-for-managing-vendor-defaults-and-other-security-parameters-are-documented-in-use-and-known-to-all-affected-parties)|Ensure that security policies and operational procedures for managing vendor defaults and other security parameters are documented, in use, and known to all affected parties.|
|[Requirement 2.6](#requirement-26shared-hosting-providers-must-protect-each-entitys-hosted-environment-and-cardholder-data)|Shared hosting providers must protect each entity’s hosted environment and cardholder data.|

***

### Requirement 1.1&mdash;Establish and implement firewall and router configuration standards that include the following:

#### Requirement 1.1.1

A formal process for approving and testing all network connections and changes to the firewall and router configurations.

##### Your responsibilities
      
Don't implement configurations manually. Instead, use Infrastructure as code (IaC). With IaC, infrastructure is managed through a descriptive model that uses a versioning system. IaC model generates the same environment every time it's applied. Common examples of IaC are Azure Resource Manager or Terraform.

Have a gated approval process that involves people and processes to approve changes to any network configuration. Have detailed documentation that describes the process. 

<Ask Chad: to give input around can the approval process be automated, who should be responsible and how is that incorporated in the pipeline.>

#### Requirement 1.1.2
Current network diagram that identifies all connections between the cardholder data environment and other networks, including any wireless networks

##### Your responsibilities

As part of your documentation, maintain a network flow diagram that shows the incoming and outgoing traffic with specific controls.

This image shows the network diagram of the reference implementation.

:::image type="content" source="./images/network-topology-small.png" alt-text="Network topology" lightbox="./images/network-topology.png":::

**Figure 1.1.2 - Network flow**

The description of this flow is in the following sections. 

#### Requirement 1.1.3
Current diagram that shows all cardholder data flows across systems and networks.
##### Your responsibilities
As part of your documentation, include a data flow diagram that shows how data is protected at rest and in transit.

<Ask Chad: need a data diagram for this requirement>

#### Requirement 1.1.4
Requirements for a firewall at each Internet connection and between any demilitarized zone (DMZ) and the internal network zone.

##### Your responsibilities
      
For a PCI DSS infrastructure, you're responsible for securing the card holder environment (CDE) by using firewalls to block unauthorized access into and out of the network with the CDE. Firewalls must be configured properly for a strong security posture. Firewall settings must be applied to:
- Communication between the colocated components within the cluster.
- Communication between the workload and other components in trusted networks.
- Communication between the workload and public internet.

This architecture uses different firewall technologies to inspect traffic flowing in both direction to and from the cluster that hosts the CDE: 

-  Azure Application Gateway integrated web application firewall (WAF) is used as the traffic router and for securing inbound (ingress) traffic to the cluster. 

- Azure Firewall is used to secure all outbound (egress) traffic from any network and its subnets. 

   As part of processing a transaction or management operations, the cluster will need to communicate with external entities. For example, communication with the AKS control plane, getting windows and package updates, workload's interaction with external APIs, and others. Some of those interactions might be over HTTP and should be considered as attack vectors. Those vectors are targets for a man-in-the-middle attack that can result in data exfilteration. Adding firewall to egress traffic mitigates that threat. 

#### Requirement 1.1.5
Description of groups, roles, and responsibilities for management of network components.

##### Your responsibilities

You'll need to provide controls on the network flows and the components involved. The resulting infrastructure will have several network segments, each with many controls, and each control with a purpose. Make sure your documentation not only has the breadth of coverage from network planning to all configurations but also has the details on ownership. Have clear lines of responsibility and the roles are responsible for them. 

For example, who is responsible for the goverance of securing network between Azure and the internet. In an enterprise, the IT team is responsible for configuration and maintenance of Azure Firewall rules, Web Application Firewall (WAF), Network Security Groups (NSG), and other cross-network traffic. They might also be responsible for enterprise-wide virtual network and subnet allocation and IP address planning.

At the workload level, a cluster operator is responsible for maintaining zero-trust through network policies. Also, responsibilities might include communication with the Azure control plane, Kubernetes APIs, monitoring technologies, and others.

Make sure only access rights are given only to the parties responsible in each case. 

#### Requirement 1.1.6
Documentation of business justification and approval for use of all services, protocols, and ports allowed, including documentation of security features implemented for those protocols considered to be insecure.

##### Your responsibilities

Have detailed documentation that describes the services, protocols, and ports used in the network controls. Make sure you include justification for the controls. Here are some examples from the the reference implementation for Azure Firewall. Firewall rules must be scoped exclusively to their related resources. That is, only traffic from specific sources is allowed to go to specific FQDN targets. Here are some cases to allow traffic.

|Rule|Protocol:Port|Source|Destination|Justification
|---|---|---|---|---|
|Allow network time protocol (NTP) traffic.|UDP:123|AKS node pools||To support time synchronization between servers.|
|Allow secure communication between the nodes and the control plane.|HTTPS:443|Authorized IP address ranges assigned to the cluster node pools| List of FDQN targets in the AKS control plane. This is specified with the AzureKubernetesService FQDN tag.|The nodes need access to the control plane for management tools, state and configuration information, and information about which nodes can be scaled.|
|Allow secure communication between Flux and GitHub.|HTTPS:443|AKS node pools|github.com,api.github.com|Flux is a third-party integration that runs on the nodes. It synchronizes cluster configuration with a private GitHub repository.|

For information about the required ports, official documentation for the Azure service.

#### Requirement 1.1.7
Requirement to review firewall and router rule sets at least every six months.

##### Your responsibilities

Have processes that regularly review the network configurations and the scoped rules. This will make sure the security assurances are current and valid.

<Ask Chad: What are the things to look for and review>

#### Requirement 1.2&mdash;Build firewall and router configurations that restrict connections between untrusted networks and any system components in the cardholder data environment. 

##### Your responsibilities
In this architecture, the AKS cluster _is_ the cardholder data environment (CDE). That cluster is deployed as a private cluster for maximum security. In a private cluster, network traffic between the AKS-managed Kubernetes API server and your node pools is private. The API server virtual network has a Azure Private Link service. Your cluster subnet exposes a private endpoint, which interacts with that Private link service.

When processing card holder data (CHD), the cluster needs to interact securely with trusted networks and untrusted networks when necessary. Networks, with which the cluster interacts, are trusted networks. In this architecture, both the hub and spoke networks are considered to be trusted networks within the security perimeter.

Unstrusted networks are networks outside that perimeter. This category includes the public internet, the corporate network, virtual networks in Azure or other cloud platform. In this architecture, the virtual network that hosts the image builder is untrusted because it has no part to play in CHD handling. The CDE's interaction with such networks should be secured as per the requirements. With this private cluster, you can use Azure Virtual Network, Nework Security Group (NSG), and other built-in features to secure the entire environment.

For information about private clusters, see [Create a private Azure Kubernetes Service cluster](https://docs.microsoft.com/en-us/azure/aks/private-clusters).

<Ask Chad: What about the case where I don't want to use a private cluster. What are the added responsibilities w.r.t API service (and others). Need a case to say with private cluster things are just easier. >

#### Requirement 1.2.1
Restrict inbound and outbound traffic to that which is necessary for the cardholder data environment, and specifically deny all other traffic.

##### Your responsibilities
By design, Azure Virtual Network cannot be directly reached by the public internet. All inbound (or _ingress_) traffic must go through an intermediate traffic router. However, all components in the network can reach public endpoints. That outbound (or _egress_) traffic must be explicitly secured.

-  Azure Application Gateway integrated web application firewall (WAF) intercepts all ingress traffic and routes inspected traffic to the cluster. 

   This traffic can originate from trusted or untrusted networks. Application Gateway is provisioned in a subnet of the spoke network and secured by a network security group (NSG). As traffic flows in, WAF rules allow or deny, and route traffic to the configured backend. For example, Application Gateway protects the CDE by denying this type of traffic: 
    - All traffic that is not TLS-encrypted. 
    - Traffic outside the port range for control plane communication from the Azure infrastructure. 
    - Health probes requests that are sent by entities other than the internal load balancer in the cluster. 

- Azure Firewall is used to secure all outbound (egress) traffic from trusted and untrusted networks. 

   Firewall is provisioned in a subnet of the hub network. To enforce Firewall as the single egress point, user-defined routes (UDRs) are used on subnets that are capable of generating egress traffic. This includes subnets in untrusted networks such as the image builder virtual network. After the traffic reaches Firewall, several scoped rules are applied that allow traffic from specific sources to go to specific targets.

   For more information, see  [Use Azure Firewall to protect Azure Kubernetes Service (AKS) Deployments](/azure/firewall/protect-azure-kubernetes-service).

The cluster will need to access other Azure services over the public internet. For example, get certificates from the managed key store, pull images from a container registry, communicate with the API server. Those interactions must be secured. Because this architecture uses a private cluster, the network path to the API server is over Private Link. You can use Private Links for other services such as Azure Key Vault and Azure Container Registry to do the preceding tasks.

In addition to firewall rules and private networks, Nework Security Group (NSG) flows are also secured through rules. Here some examples from this architecture where the CDE is protected by denying traffic:
- The NSGs, on subnets that have node pools, deny any SSH access to its nodes.
- The NSG, on the subnet that has the jump box for running management tools, denies all traffic except from  Azure Bastion in the hub network.
- The NSGs, on subnets that have the private endpoints to  Azure Key Vault and Azure Container Registry, deny all traffic except from the internal load balancer and the traffic over Private Link.

#### Requirement 1.2.2
Secure and synchronize router configuration files.

##### Your responsibilities

Use ARM templates (or similar) to have a record of the resources deployed.

<Ask Chad: What about GitOps and Flux capacitor, start up security>

#### Requirement 1.2.3

Install perimeter firewalls between all wireless networks and the cardholder data environment, and configure these firewalls to deny or, if traffic is necessary for business purposes, permit only authorized traffic between the wireless environment and the cardholder data environment.

##### Your responsibilities

The AKS nodes and the node pools must not be reachable from wireless networks. Also, requests to the Kubernetes API server must be denied. Access to those components is restricted to authorized and secured subnets.

In general, limit access to on-premises traffic to the spoke network.  

#### Requirement 1.3&mdash;Prohibit direct public access between the Internet and any system component in the cardholder data environment. 

##### Your responsibilities
The AKS cluster has system node pools that host critical system pods. Even on the user node pools, there are pods that run other services that participate in cluster operations. For example, Flux to synchronize cluster configuration to a Github repository, the ingress controller to route traffic to the workload pods, and others. Regardless of the type of node pool, all nodes must be protected. 

Another critical system component is the API server that is used to do native Kubernetes tasks, such as maintain the state of the cluster and configuration. This endpoint must not be exposed. An advantage of using a private cluster is that endpoint isn't exposed by default.

For information about private clusters, see [Create a private Azure Kubernetes Service cluster](https://docs.microsoft.com/en-us/azure/aks/private-clusters).

#### Requirement 1.3.1

Implement a DMZ to limit inbound traffic to only system components that provide authorized publicly accessible services, protocols, and ports.

##### Your responsibilities

Here are some best practices:
- Do not configure public IP addresses on the node pool nodes. 
- Do not have a public load balancer in front of the nodes. Traffic within the cluster must be routed through internal load balancers. 
- Only expose internal load balancers to Azure Application Gateway integrated with Web Application Firewall(WAF). 
- Do not expose the API server to the internet. When you run the cluster in private mode, the endpoint is not exposed and communication between the node pools and the API server is over a private network.

Users can implement a DMZ to protect AKS clusters, as other services. For information about Cloud DMZ Design and Implementation steps, see [Cloud DMZ](/azure/cloud-adoption-framework/decision-guides/software-defined-network/cloud-dmz).

#### Requirement 1.3.2

Limit inbound Internet traffic to IP addresses within the DMZ.

##### Your responsibilities

In the AKS cluster, have an network security group (NSG) on the subnet with the internal load balancer. Configure rules to only accept traffic from subnet that has Azure Application Gateway integrated with Web Application Firewall(WAF).


#### Requirement 1.3.3

Implement anti-spoofing measures to detect and block forged source IP addresses from entering the network. 

##### Azure responsibilities

Azure implements network filtering to prevent spoofed traffic and restrict incoming and outgoing traffic to trusted platform components.

#### Requirement 1.3.4

Do not allow unauthorized outbound traffic from the cardholder data environment to the Internet.

##### Your responsibilities

Here are ways in which you can block unauthorized outbound traffic:

- Enforce all outbound (egress) traffic from the AKS cluster to go through Azure Firewall. Have user-defined routes (UDRs) on cluster subnets. This includes subnets with system and user node pools. 
- Limit outbound traffic by adding network security groups (NSG)s on subnets with node pools.

AKS requires some public internet access to access the Azure-managed control plane. For example, the cluster wants to send metrics and logs to Azure Monitor. You can set scoped rules by specifying the source and destination FQDN targets or FQDN tags. While using tags makes it easier to set the rules, some tags might include more targets than you need making the rule overly permissive. Review the tags to make sure it has just the right targets you need.

For details More details is available at: [Control egress traffic for cluster nodes in Azure Kubernetes Service (AKS)](/azure/aks/limit-egress-traffic).

#### Requirement 1.3.5

Permit only “established” connections into the network.

##### Azure responsibilities

Azure implements network filtering to prevent spoofed traffic and restrict incoming and outgoing traffic to trusted platform components.  Azure network is segregated to separate customer traffic from management traffic.


#### Requirement 1.3.6

Place system components that store cardholder data (such as a database) in an internal network zone, segregated from the DMZ and other untrusted networks.

##### Your responsibilities

Expose your storage systems only over a private network, for instance using Private Link. Also, restrict access from the nodepool subnet(s) that require it. Keep state out of the cluster and in its own dedicated security zone. 

Microsoft Azure uses network segregation and NAT to separate customer traffic from management traffic.


#### Requirement 1.3.7

Do not disclose private IP addresses and routing information to unauthorized parties.

##### Your responsibilities

A private AKS cluster keeps DNS records off the public internet. Use an internal DNS zone for routing between the subnet that has Azure Application Gateway integrated with Web Application Firewall(WAF) and the subnet that has the internal load balancer. Ensure all HTTP responses do not include any private IP information in headers or body. Ensure logs that may contain IP and DNS records are not exposed outside of operational needs.

<Ask Chad: Two questions: 1. I couldn't find an internal DNS zone between waf and ilb. 2. yesterday we discussed that private DNS zone is in the hub. In the spoke resource group i see exactly those private DNS zones. None in the hub. What am I missing>

### Requirement 1.4&mdash;Install personal firewall software or equivalent functionality on any portable computing devices that connect to the Internet when outside the network , and which are also used to access the CDE. 

##### Your responsibilities

The private cluster is managed by the AKS control plane. You don't have access to nodes directly. For doing administrative tasks you'll need to use management tools such as kubectl from a separate compute resource. An option is to use an air-gapped jump box where you can run the commands. Also inbound and outbound traffic from the jump box must be restricted and secure. If VPN is used for access, make sure the client machine is managed by corporate policy and all conditional access policies are in place.

In this architecture, that jump box is in a separate subnet in the spoke network. Inbound access to the jump box is restricted by using a network security group (NSG) that only allows access through Azure Bastion over SSH. 

To run certain commands on the jump box, you'll will need to reach public endpoints. For example, endpoints managed by Azure managment plane. That outbound traffic must be secure. Similar to other components in the spoke network, outbound traffic from the jump box is restricted by using a user-defined route (UDR) that forces HTTPs  traffic to go through Azure Firewall.

### Requirement 1.5&mdash;Ensure that security policies and operational procedures for managing firewalls are documented, in use, and known to all affected parties.

##### Your responsibilities

It's critical that you maintain thorough documentation about the process and policies. Especially when managing Azure Firewall rules that segments the AKS cluster. People operating regulated enviroments must be educated, informed, and incentivized to support the security assurances. This is particularly important for people with accounts granted broad administrative privileges.

***

## Requirement 2&mdash;Do not use vendor-supplied defaults for system passwords and other security parameters

### Requirement 2.1&mdash;Always change vendor-supplied defaults and remove or disable unnecessary default accounts before installing a system on the network. 

#### Your responsibilities

Default settings provided by vendors must be changed. Default settings are common attack vectors and make the system prone to attacks. Here are some considerations:
- Disable administrator access on the container registry.
- Ensure jump boxes and build agents follow user management procedures - removing needed system users.
- Do not generate or provide SSH key access to nodes to administrator user. If emergency access is necessary, use Azure recovery process to get JIT access.

#### Azure responsibilities

Azure Active Directory has password policies that are enforced on the new passwords supplied by users. If you change a password, validation of older password is required. Administrator reset passwords are required to be changed upon subsequent login.


#### Requirement 2.1.1

For wireless environments connected to the cardholder data environment or transmitting cardholder data, change ALL wireless vendor defaults at installation, including but not limited to default wireless encryption keys, passwords, and SNMP community strings.

##### Your responsibilities

TBD

### Requirement 2.2&mdash;Develop configuration standards for all system components. 

#### Your responsibilities

Implement the recommendations in Azure Security Benchmark. It provides a single consolidated view of Azure security recommendations covering industry framework such as CIS, NIST, PCI-DSS, and others. Use Azure Security Center features and Azure Policy to help track against the standards. Azure Security Benchmark is the default intiative for Azure Security Center. Consider building additional automated checks in Azure Policy and Azure Tenant Security Solution (AzTS).

For more information, see [Azure security benchmark](/security/benchmark/azure/introduction).

#### Azure responsibility
Azure provides security configuration standards that are consistent with industry-accepted hardening standards.  The standards and are reviewed at least annually.


#### Requirement 2.2.1

Implement only one primary function per server to prevent functions that require different security levels from co-existing on the same server. (For example, web servers, database servers, and DNS should be implemented on separate servers.) 

##### Your responsibilities

The key strategy is to provide the required level of segmentation. One way is to deploy in-scope and out-of-scope components in separate clusters. The down side is increased costs for the added infrastructure and the maintenance overhead. Another approach is to colocate all components in a shared cluster. Use segmentation strategies to maintain the separation. For example, have separate node pools within a cluster. 

In the reference implementation, the second approach is demonstrated with a microservices application deployed to a single cluster. The application has  two sets of services; one set has in-scope pods and the other is out-of-scope. Both sets are spread across two user node pools. With the use of Kubernetes taints, in-scope and out-of-scope pods are deployed to separate node pools and they never share a node VM.

For container technologies, that segmentation is provided by default because only one instance of a container is responsible for one function in the system.

The workload should use Pod Managed Identity. It must not inhert any cluster-level or node-level identity. 

Use external storage instead of on-node (in-cluster) storage where possible. Keep cluster pods reserved exclusively for work that must be performed as part of the operation of card holder data processing. For example, don't use the cluster also as your build agents, or for unrelated workloads.


#### Requirement 2.2.2

Enable only necessary services, protocols, daemons, etc., as required for the function of the system.

##### Your responsibilities

Don't enable features that are not necessary. For example, enabling managed identity on ACR if ACR isn't going to use that feature.

Make sure all rules, configured in Azure Firewall and Network Security Groups (NSG), restrict by protocol and port in addition to source and destination.

For components Where you have complete control, for instance jump boxes, build agents, and others, remove all necessary system services from the images.
<Ask Chad: necessary? need to understand>

For components, where you only have visibility such as  AKS nodes, document what Azure installs on the nodes. 

Consider using DaemonSets to provide any additional auditing necessary for these cloud-controlled components.

#### Requirement 2.2.3

Implement additional security features for any required services, protocols, or daemons that are considered to be insecure.

##### Your responsibilities

App Gatway should only support TLS 1.2 and approved ciphers.
App Gateway should not respond to port 80 (unless performing a redirect in the gateway. Do not perform redirects at the application level).
If additional node-level OS hardening deemed required, that work must be performed via sufficently prividledge DaemonSets. Because of the risk involved (security and stability), implementing these will have to be performed by the customer.

#### Requirement 2.2.4

 Configure system security parameters to prevent misuse.

##### Your responsibilities

All Azure Services should ahear to the Azure CIS Benchmark controls, and exceptions documented.
People should be trained on the security features of each component and be able to demonstrate related settings across the platform services.

#### Requirement 2.2.5

 Configure system security parameters to prevent misuse.

##### Your responsibilities

Do not install anything on a JumpBox, Build Agent, or cluster (DaemonSet, Pods, etc) that does not belong to fullfill the needs of the operation of the workload or a tool that provides observability for compliance requirements (security agents). Ensure there is a process to detect the installation of the same.

### Requirement 2.3&mdash;Encrypt all non-console administrative access using strong cryptography.

#### Your responsibilities

All administrative access to the cluster should be conole-based. Do not expose the cluster's control plane via any management dashboard product, outside of the built-in experience in the Azure Portal.

### Requirement 2.4&mdash;Maintain an inventory of system components that are in scope for PCI DSS.

#### Your responsibilities

Ensure all Azure Resources are tagged with being in or out of scope, to allow a querying for resources on demand. Audit/maintain that tag. Also maintain a snapshot of that documentation periodically.

### Requirement 2.5&mdash;Ensure that security policies and operational procedures for managing vendor defaults and other security parameters are documented, in use, and known to all affected parties.

#### Your responsibilities

People/Process/Training/Documentation


### Requirement 2.6&mdash;Shared hosting providers must protect each entity’s hosted environment and cardholder data.

#### Your responsibilities

https://docs.microsoft.com/compliance/regulatory/offering-PCI-DSS


## Next

Protect stored cardholder data. Encrypt transmission of cardholder data across open, public networks

> [!div class="nextstepaction"]
> [Protect Cardholder Data](aks-pci-data.yml)