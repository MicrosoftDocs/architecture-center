This article describes the considerations for an Azure Kubernetes Service (AKS) cluster that runs a workload in compliance with the Payment Card Industry Data Security Standard (PCI-DSS). 

> This article describes the responsibilities of a workload owner in how the workload interacts with the infrastructure. This article is part of a series. Read the [introduction](aks-pci-intro.yml) here.

![GitHub logo](../../../_images/github.png) [GitHub: Azure Kubernetes Service (AKS) Baseline Cluster for Regulated Workloads](https://github.com/mspnp/aks-baseline-regulated) demonstrates the regulated infrastructure. This implementation provides a microservices application. It's included to help you experience the infrastructure and illustrate the network and security controls. The application does not represent or implement an actual PCI DSS workload.

> [!IMPORTANT]
>
> The guidance in this article and the above-mentioned reference implementation builds on the [AKS baseline architecture](/azure/architecture/reference-architectures/containers/aks/secure-baseline-aks). That architecture based on a hub and spoke topology. The hub virtual network contains the firewall to control egress traffic, gateway traffic from on-premises networks, and a third network for maintainence. The spoke virtual network contains the AKS cluster that provides the card holder environment (CDE) and hosts the PCI DSS workload. 

## Build and Maintain a Secure Network and Systems
The hub and spoke topology in the baseline is a natural choice for a PCI DSS infrastructure. Network controls are placed in both hub and spoke networks and follow the Microsoft zero-trust model. The controls can be tuned with least-privilege to secure traffic giving access on a need-to-know basis. In addition, several defense-in-depth approaches can be applied by adding controls at each network hop. 

[**Requirement 1**](#requirement-11establish-and-implement-firewall-and-router-configuration-standards-that-include-the-following)&mdash;Install and maintain a firewall configuration to protect cardholder data.

|Requirement|Responsibility|
|---|---|
|[Requirement 1.1](#requirement-11establish-and-implement-firewall-and-router-configuration-standards-that-include-the-following)|Establish and implement firewall and router configuration standards.|
|[Requirement 1.2](#requirement-12build-firewall-and-router-configurations-that-restrict-connections-between-untrusted-networks-and-any-system-components-in-the-cardholder-data-environment)|Build firewall and router configurations that restrict connections between untrusted networks and any system components in the cardholder data environment.|
|[Requirement 1.3](#requirement-13prohibit-direct-public-access-between-the-internet-and-any-system-component-in-the-cardholder-data-environment)|Prohibit direct public access between the Internet and any system component in the cardholder data environment.|
|[Requirement 1.4](#requirement-14install-personal-firewall-software-or-equivalent-functionality-on-any-portable-computing-devices-that-connect-to-the-internet-when-outside-the-network--and-which-are-also-used-to-access-the-cde)|Install personal firewall software or equivalent functionality on any portable computing devices (including company and/or employee-owned) that connect to the Internet when outside the network (for example, laptops used by employees), and which are also used to access the CDE. |
|[Requirement 1.5](#requirement-15ensure-that-security-policies-and-operational-procedures-for-managing-firewalls-are-documented-in-use-and-known-to-all-affected-parties)|Ensure that security policies and operational procedures for managing firewalls are documented, in use, and known to all affected parties.|

***

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
      
For a PCI DSS infrastructure, you're responsible for securing the AKS cluster by using firewalls to block unauthorized access into and out of the cluster. Firewalls must be configured properly for a strong security posture. Firewall settings must be applied to:
- Communication between the colocated components within the cluster.
- Communication between the workload and other components in trusted networks.
- Communication between the workload and public internet.

This architecture uses different firewall technologies to inspect traffic in two directions: 

-  Azure Application Gateway integrated web application firewall (WAF) is used as the traffic router and for securing inbound (ingress) traffic to the cluster. 

- Azure Firewall is used to secure all outbound (egress) traffic from any network and its subnets. 

   As part of processing a transaction or management operations, the cluster will need to communicate with external entities. For example, communication with the AKS control plane, getting windows and package updates, workload's interaction with external APIs, and others. Some of those interactions might be over HTTP and should be considered as attack vectors. Those vectors are targets for a man-in-the-middle attack that can result in data exfilteration. Adding firewall to egress traffic mitigates that threat. 



#### Requirement 1.1.5
Description of groups, roles, and responsibilities for management of network components.

##### Your responsibilities

As per the requirements of the PCI DSS standard, you'll need to provide controls on the network flows and the components involved. The resulting infrastructure will have several network segments, each with many controls, and each control with a purpose. Make sure your documentation not only has the breadth of coverage from network planning to all configurations but also has the details on ownership. Have clear lines of responsibility and the roles are responsible for them. 

For example, who is responsible for the goverance of securing network between Azure and the internet. In an enterprise, the IT team is responsible for configuration and maintenance of Azure Firewall rules, Web Application Firewall (WAF), Network Security Groups (NSG), and other cross-network traffic. They might also be responsible for enterprise-wide virtual network and subnet allocation and IP address planning.

At the workload level, a cluster operator is responsible for maintaining zero-trust through network policies. Also, responsibilities might include communication with the Azure control plane, Kubernetes APIs, monitoring options, and others.

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

<Ask Chad:  >

#### Requirement 1.2.1
Restrict inbound and outbound traffic to that which is necessary for the cardholder data environment, and specifically deny all other traffic.

##### Your responsibilities
By design, Azure Virtual Network cannot be directly reached by the public internet. All inbound (or _ingress_) traffic must go through an intermediate traffic router. However, all components in the network can reach public endpoints. That outbound (or _egress_) traffic must be explicitly secured.

-  Azure Application Gateway integrated web application firewall (WAF) intercepts all ingress traffic and routes inspected traffic to the cluster. 

   This traffic can originate from trusted or untrusted networks. Application Gateway is provisioned in a subnet of the spoke network and secured by a network security group (NSG). As traffic flows in, WAF rules allow or deny, and route traffic to the configured backend. For example, Application Gateway only allows: 
    - TLS-encrypted traffic. 
    - Traffic within a port range for control plane communication from the Azure infrastructure. 
    - Health probes from the internal load balancer. 

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

<Ask Chad: What about GitOps and Flux capacitor>

#### Requirement 1.2.3

Install perimeter firewalls between all wireless networks and the cardholder data environment, and configure these firewalls to deny or, if traffic is necessary for business purposes, permit only authorized traffic between the wireless environment and the cardholder data environment.

##### Your responsibilities

Ensure all Cluster API and Cluster Node access is restricted to authorized subnets, and secure access to those subnets (Azure Bastion, VPN Gateway, etc)

<Ask Chad: Firewall scoped rules?>

#### Requirement 1.3&mdash;Prohibit direct public access between the Internet and any system component in the cardholder data environment. 

##### Your responsibilities
All nodepool nodes must never have public IPs. All nodepool nodes must not directly be exposed via a public load balancer. All nodepool nodes should only be exposed via internal load balancers. Those internal load balancers then should be exposed via a WAF such as Application Gateway. You cluster API should NOT be exposed to the internet, you must run in a Private Cluster configuration.

https//docs.microsoft.com/en-us/azure/aks/private-clusters

#### Requirement 1.3.1

Implement a DMZ to limit inbound traffic to only system components that provide authorized publicly accessible services, protocols, and ports.

##### Your responsibilities

Users can implement a DMZ to protect AKS clusters, as other services. Azure documentation for Cloud DMZ Design and Implementation steps can be found here: https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/decision-guides/software-defined-network/cloud-dmz

Refer to master matrix for general guidelines.

#### Requirement 1.3.2

Limit inbound Internet traffic to IP addresses within the DMZ.

##### Your responsibilities

NSG around internal load balancer should only accept traffic from WAF subnet. Nodepool node subnets should only accept workload traffic from load balancer subnet.

#### Requirement 1.3.3

Implement anti-spoofing measures to detect and block forged source IP addresses from entering the network. 

##### Your responsibilities

TBD

#### Requirement 1.3.4

Do not allow unauthorized outbound traffic from the cardholder data environment to the Internet.

##### Your responsibilities

Limit outbound traffic to the internet and other subnets using Azure Firewall, and Subnet level NSG's. AKS does require some public internet access to access the managed control plane. More details is available at: https://docs.microsoft.com/en-us/azure/aks/limit-egress-traffic

Refer to master matrix for general guidelines.

#### Requirement 1.3.5

Permit only “established” connections into the network.

##### Your responsibilities

TBD

#### Requirement 1.3.6

Place system components that store cardholder data (such as a database) in an internal network zone, segregated from the DMZ and other untrusted networks.

##### Your responsibilities

Require all storage systems to be exposed via Private Link exclusively and restricted to just access from the nodepool subnet(s) that require it. Keep state out of the cluster and in its own dedicated security zone. 

#### Requirement 1.3.7

Do not disclose private IP addresses and routing information to unauthorized parties.

##### Your responsibilities

AKS Private Cluster keeps DNS records off public internet. Use an internal DNS zone for routing between WAF and Load Balancer. Ensure all HTTP responses do not include any private IP information in headers or body. Ensure logs that may contain IP and DNS records are not exposed outside of Ops needs.

### Requirement 1.4&mdash;Install personal firewall software or equivalent functionality on any portable computing devices that connect to the Internet when outside the network , and which are also used to access the CDE. 

##### Your responsibilities

Use air-gapped jump boxes when performing administrative tasks. Connect via Azure Bastion to add seperation between client machine and jump box. If VPN is used for access, ensure client machine is managed by corporate policy and all conditional access policies are in place on those machines.


### Requirement 1.5&mdash;Ensure that security policies and operational procedures for managing firewalls are documented, in use, and known to all affected parties.

##### Your responsibilities

Documentation and Training

***

## Requirement 2&mdash;Do not use vendor-supplied defaults for system passwords and other security parameters

### Requirement 2.1&mdash;Always change vendor-supplied defaults and remove or disable unnecessary default accounts before installing a system on the network. 

#### Your responsibilities

Disable Admin access on ACR.
Ensure Jump Boxes and Build Agents follow user management procedures - removing needed system users.
Do not generate/provide SSH key access to nodes to administrator user. If emergency access is necessary, use Azure recovery process to get JIT access.

#### Requirement 2.1.1

For wireless environments connected to the cardholder data environment or transmitting cardholder data, change ALL wireless vendor defaults at installation, including but not limited to default wireless encryption keys, passwords, and SNMP community strings.

##### Your responsibilities

TBD

#### Requirement 2.1.2

For wireless environments connected to the cardholder data environment or transmitting cardholder data, change ALL wireless vendor defaults at installation, including but not limited to default wireless encryption keys, passwords, and SNMP community strings.

##### Your responsibilities

TBD

### Requirement 2.2&mdash;Develop configuration standards for all system components. 

#### Your responsibilities

Ensure your subscriptions are adhearing to Azure CIS Benchmark 2.0 standards plus any additional industry standards you feel are relevant. Use Azure Security Center's Security Baseline features and Azure Policy to help track against the standards. Consider building additional automated checks where desired in Azure Policy and Azure Tenant Security Solution (AzTS).

#### Requirement 2.2.1

Implement only one primary function per server to prevent functions that require different security levels from co-existing on the same server. (For example, web servers, database servers, and DNS should be implemented on separate servers.) 

##### Your responsibilities

Container technology addresses this requirement by default, as one instance of a container is responsible for one function in the system. Ensure you separate in-scope and out-of-scope processes ideally into separate clusters and related infrastructure, but at a minimum seperate node pools within a cluster. Ensure workloads are using Pod Managed Identity and are not inherting any cluster-level/node-level identity. Use external storage vs on-node (in-cluster) storage where possible. Keep cluster pods reserved exclusively for work that must be performed as part of the operation of card holder data processing -- for example, don't use the cluster also as your build agents, or for unrelated workloads, no matter how small/insignificant.

#### Requirement 2.2.2

Enable only necessary services, protocols, daemons, etc., as required for the function of the system.

##### Your responsibilities

Do not enable features on services that are not necessary. (e.g. enabling managed identity on ACR if ACR isn't going to use that feature).
Ensure all firewall (and NSG) rules restrict by protocol in addition to source/destination.
Where you have complete control (Jump boxes, build agents), remove all necessary system services from the images.
Where you have observer control only (such as AKS nodes), document what Azure installs on the nodes. Consider using DaemonSets to provide any additional auditing necessary for these cloud-controlled components.

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