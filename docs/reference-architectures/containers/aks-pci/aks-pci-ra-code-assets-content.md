This article describes a reference architecture for an Azure Kubernetes Service (AKS) cluster that runs a workload in compliance with the Payment Card Industry Data Security Standard (PCI-DSS). This architecture is focused on the infrastructure and _not_ the PCI-DSS workload.

> This article is part of a series. Read the [introduction](aks-pci-intro.yml) here.

The recommendations and examples are extracted from this accompanying reference implementation:

![GitHub logo](../../../_images/github.png) [GitHub: Azure Kubernetes Service (AKS) Baseline Cluster for Regulated Workloads](https://github.com/mspnp/aks-baseline-regulated) demonstrates the regulated infrastructure. This implementation provides a microservices application. It's included to help you experience the infrastructure and illustrate the network and security controls. The application does _not_ represent or implement an actual PCI DSS workload.


![Architecture of an AKS PCI infrastructure](images/regulated-architecture.svg)

That architecture is based on a hub and spoke topology; with one hub and two spokes. The hub virtual network contains the firewall to control egress traffic, gateway traffic from on-premises networks, and a third network for maintenance. There are two spoke virtual networks. One spoke contains the AKS cluster that provides the card-holder environment (CDE), and hosts the PCI DSS workload. The other spoke builds virtual machine images for your workloads.

> [!IMPORTANT]
>
> This article is work in progress. Check back on updates.
>

## Components

> [!IMPORTANT]
>
> The architecture and the implementation builds on the [AKS baseline architecture](/azure/architecture/reference-architectures/containers/aks/secure-baseline-aks). To get the most out of this article, familiarize yourself with the baseline components. In this section, we'll highlight the differences between the two architectures.

**Azure Bastion**

The baseline architecture provided a subnet for Bastion but didn't provision the resource. This architecture adds Bastion in the subnet. It provides secure access to a jump box.

**Azure Virtual Machines (VM)**

The spoke network has an additional compute for a jump box. This machine is intended to run management tools on the AKS cluster, such as kubectl.

**Azure Image Builder**

Provisioned in a separate virtual network. Creates VM images with base security and configuration. In this architecture, it's customized to build secure node images with Ubuntu 18.04-LTS platform (MSFT-provided) image with management tools such as Azure CLI, kubectl and kubelogin, flux CLI.

## Cluster configuration

The baseline architecture has one user node pool and another for the system node pool. The workload runs on all the pods. This architecture has two user node pools and one system node pool. The in-scope and out-of-scope workloads are segmented in two separate user node pools. For more, see [Workload segmentation](#workload-segmentation).

In this architecture, Kubernetes ingress controller inside the cluster is NGINX. In the baseline architecture, we chose Traefik. This change illustrates that the service can be changed based on your choice.

The baseline architecture deployed the AKS cluster in public mode. This means all communication with the AKS-managed Kubernetes API server is over the public internet. This is not acceptable in this architecture because PCI-DSS prohibits public exposure to system components. In this regulated architecture, the cluster is deployed as a private cluster. Network traffic between the Kubernetes API server and your node pools is private. The API server is exposed through a Private Endpoint in the cluster's network. The security is further enhanced with the use of Azure Virtual Network, an NSG, and other built-in features. These are described in [Network configuration](#network-configuration).

## Networking configuration

The hub and spokes are all deployed in separate virtual networks, each in their private address space. Each subnet is isolated with no traffic allowed by default between any two virtual networks. 

A combination of various Azure services and feature and native Kubernetes constructs provide the required level of control. Here are some options used in this architecture.   

![Network configuration](./images/network-topology.svg)

### Strict Network Security Groups (NSGs)

There are several NSGs that control the flow in and out of the cluster. Here are some examples:
- The cluster node pools are placed in their dedicated subnets. For each subnet, there are NSGs that block any SSH access to node VMs and allow traffic from the virtual network. Traffic from the node pools is restricted to the virtual network.
- All inbound traffic fom the internet is intercepted by Azure Application Gateway. NSG rules make sure, for example:
   - Only HTTPS traffic is allowed in. 
   - Traffic from Azure Control Plane is allowed.    
   For details, see [Allow access to a few source IPs](/azure/application-gateway/configuration-infrastructure#network-security-groups).
- On the subnets that have Azure Container Registry agents, NSGs allow only neccessary outbound traffic. For instance, to Azure Key Vault, Azure Active Directory, Azure Monitor, and other services that the container registry needs to talk to.  
- The subnet with the jump box is intended for management operations. The NSG rule only allows SSH access from Azure Bastion in the hub.

As your workloads, system security agents, and other components are deployed, add more NSG rules that help define the type of traffic that should be allowed and traffic shouldn't traverse those subnet boundaries. Because each nodepool lives in its own subnet, observe the traffic patterns, and then apply more specific rules.

### Expanded NetworkPolicies

This architecture attempts to implement Zero-Trust as much as possible. 

Examples of Zero-Trust networks as a concept are demonstrated in the implementation in `a0005-i` and `a0005-o` user-provided namespaces. All namespaces should have restrictive `NetworkPolicy` applied, except `kube-system`, `gatekeeper-system`, and other AKS-provided namespaces. The policy definitions will depend on the pods running in those namespaces. Make sure you're accounting for readiness, liveliness, and startup probes and also allowance for metrics gathered by `oms-agent`. Consider standardizing on ports across your workloads so that you can provide a consistent `NetworkPolicy` and Azure Policy for allowed container ports.

In certain cases, this is not practical for communication within the cluster. Not all user-provided namespaces can use a Zero-Trust network, for instance `cluster-baseline-settings`. 
<Ask Chad: why? example>

## TLS encryption

The baseline architecture provides TLS-encrypted traffic until the workload pod. In this architecture, TLS traffic extends into the cluster and data between pods is encyrpted. TLS trust chain isn't just encrypted, but Certificate Authority (CA) chain is also validated through violation attempts as part of the sample workload.

mTLS is used in the cluster for mesh communication. Sender and receiver pods verify each other before proceeding with the traffic. 

![Network configuration](./images/flow.svg)

The implementation uses Tresor as its TLS certificate provider for mTLS. Consider, well-known providers if you choose to implement mTLS. Some options include CertManager, HashiCorp Vault, Key Vault, or your internal certificate provider. If you use a mesh, ensure it's compatible with certificate provider of your choice.

The ingress controller in this implementation uses a wild-card certificate to handle default traffic when an Ingress resource doesn't contain a specific certificate. This might be acceptable but if the organizational policy doesn't permit using wildcard certificates, you may need to adjust your ingress controller to not support a default certificate. Instead require that even the workload uses their own named certificate. This will impact how Azure Application Gateway performs backend health checks.

### Azure Key Vault network restrictions

All secrets, keys and certificates are stored in Azure Key Vault. Key Vault handles certificate management tasks, such as rotation. Communication with Key Vault is over Private Link. The DNS record associated with Key Vault is in a private DNS zone so that it can't be resolved from the internet. While this enhances security, there are some restrictions.

Azure Application Gateway can't get public-facing TLS certificate from Key Vault instances that are  restricted with Private Link. So, the implementation deploys Key Vault in a hybrid model. It still uses Private Link but also allows public access for Application Gateway integration. 

If this hybrid approach isn't suitable for your deployment, move the certificate management process to Application Gateway. This will add management overhead but the Key Vault instance will be completely isolated. For information, see these articles:
- [Azure Application Gateway and Key Vault integration](/azure/application-gateway/key-vault-certs#how-integration-works)
- [Create an application gateway with TLS termination using the Azure CLI](/azure/application-gateway/tutorial-ssl-cli). 


### DDoS Protection

In general, we recommend that you enable [Azure DDoS Protection Standard](https://docs.microsoft.com/azure/ddos-protection/manage-ddos-protection) for virtual networks with a subnet that contains an Application Gateway with a public IP. The workload won't be burdened with fraudulent requests. Such requests can  cause  service disruption or pose another concurrent attack. Azure DDoS comes at a significant cost, and is typically amortized across many workloads that span many IP addresses. Work with your networking team to coordinate coverage for your workload.


## Identity access management
View considerations…
JIT and Conditional Access Policies
AKS' control plane supports both Azure AD PAM JIT and Conditional Access Policies. We recommend that you minimize standing permissions and leverage JIT access when performing SRE/Ops interactions with your cluster. Likewise, Conditional Access Policies will add additional layers of required authentication validation for privileged access, based on the rules you build.

For more details on using PowerShell to configure conditional access, see Azure AD Conditional Access

Custom Cluster Roles
Regulatory compliance often requires well defined roles, with specific access policies associated with that role. If one person fills multiple roles, they should be assigned the roles that are relevant to all of their job titles. This reference implementation doesn't demonstrate any specific role structure, and matter of fact, everything you did throughout this walkthrough was done with the most privileged role in the cluster. Part of your compliance work must be to define roles and map them allowed Kubernetes actions, scoped as narrow as practical. Even if one person is directly responsible for both the cluster and the workload, craft your Kubernetes ClusterRoles as if there were separate individuals, and then assign that single individual all relevant roles. Minimize any "do it all" roles, and favor role composition to achieve management at scale.


...

> [!IMPORTANT]
>
> Stop here. This article is work in progress. Check back on updates.
>

Additional Azure Policy application




Namespace Limits and Quotas
Team/Organization Role suggestions (coming from the C12 project) and mapping to Azure AD.
Followed by a list of further recommendations that cannot easily be presented in a “one size fits all that are going to be deploying this right from GitHub” solution
Encryption at Host
Azure AD Conditional Access Policies
RBAC JIT Access
Activating Azure Security center at scale (HT: @Yuri Diogenes for his tweet this morning with a link to the enterprise at-scale enrollment docs – perfectly timed!)
OCI artifact signing and validation (this is a stretch goal which we’d like to add before GA – Notary v2 + Azure Policy integration, where are you? 😊)
ACR BYOK Encryption
Azure DDoS (not specifically related to regulated)




## Configuration differences between baseline and regulated architectures

This RI is built directly on top of the AKS Baseline, illustrating the promise that you can start with the AKS Baseline and evolve it into what you need it to be.

:::row:::
   :::column span="":::
      **Design area**
   :::column-end:::
   :::column span="":::
      **AKS baseline architecture**
   :::column-end:::
   :::column span="":::
      **AKS regulated architecture**
   :::column-end:::   
:::row-end:::
:::row:::
   :::column span="":::
      **Architecture**
   :::column-end:::
   :::column span="":::
      ![Placeholder](images/network-topology-small.png)

      **Hub network**
      - Azure Firewall&mdash;Controls egress traffic.
      - Placeholder for Azure Bastion.
      - Placeholder for gateway traffic.

      **Spoke network**
      - AKS cluster hosts the workload.
      - Azure Application Gateway with integrated web application firewall (WAF) controls ingress traffic.

      - Connection with other Azure Container Registry and Azure Key Vault over Private Link.

   :::column-end:::
   :::column span="":::
      ![Placeholder](images/network-topology-small.png)

    **Hub network**
    - Azure Firewall&mdash;Controls egress traffic. There are additional and stricter rules. See **Network**.
    - Azure Bastion&mdash;provides operational access to a jumpbox in the spoke.
    - Placeholder subnet for gateway traffic.

    **Spoke network**
      - AKS cluster hosts the workload. The configuration has been modified. See  **Cluster configuration**.
      - Azure Application Gateway with integrated web application firewall (WAF) controls ingress traffic. There are additional and stricter rules. See **Network**. 
      - Jumpbox&mdash;runs management tools, such as kubectl.

    **Image builder network**
    - Azure Image Builder&mdash; builds secure node images with Ubuntu 18.04-LTS platform (MSFT-provided) image with management tools such as Azure CLI, kubectl and kubelogin, flux CLI.   
   :::column-end:::   
:::row-end:::
***
:::row:::
   :::column span="":::
      **Cluster configuration**
   :::column-end:::
   :::column span="":::
      - Mode&mdash;Public cluster. All communication to the API server is over the internet.
      - Node pools&mdash;1 user node pool; 1 system node pool. The workload runs all all pods. 
      - Ingress controller&mdash;Traeffik.
   :::column-end:::
   :::column span="":::
      - Mode&mdash;Private cluster. Communication between the cluster and the API server is over a private network. The cluster subnet exposes a private endpoint, which interacts with The Private Link service of the API server virtual network.
      - Node pools&mdash; 2 user node pools; 1 system node pool. The in-scope and out-of-scope workloads are segmented in two separate node pools.
      - Ingress controller&mdash;NGINX.
   :::column-end:::   
:::row-end:::
:::row:::
   :::column span="":::
      **Network**
      Firewall rules
      NSG
      WAF
      Network policies
   :::column-end:::
   :::column span="":::
      Firewall rules
      NSG
      WAF
      Network policies
   :::column-end:::
:::row-end:::
:::row:::
   :::column span="":::
      **Data encryption**
   :::column-end:::
   :::column span="":::
   - TLS-encrypted traffic until the workload pod. 
   :::column-end:::
   :::column span="":::
    - TLS-encrypted traffic extends into the cluster for pod-to-pod communication.
    - TLS trust chain certification at all levels. The CA chain is also validated.
   :::column-end:::   
:::row-end:::
:::row:::
   :::column span="":::
      **Operations**
   :::column-end:::
   :::column span="":::
   - ACR
   - AKV 
   :::column-end:::
   :::column span="":::
    - ACR: 
    - TLS trust chain certification at all levels. The CA chain is also validated.
   :::column-end:::   
:::row-end:::
:::row:::
   :::column span="":::
      **Monitoring**
   :::column-end:::
   :::column span="":::
   - TLS-encrypted traffic until the workload pod. 
   :::column-end:::
   :::column span="":::
    - Enhanced focus on Azure Defender.
    - Integrated logs and metrics in Azure Sentinel as the SIEM solution.
   :::column-end:::   
:::row-end:::
:::row:::
   :::column span="":::
      **Workload**
   :::column-end:::
   :::column span="":::
      A simple hello world .NET application.
   :::column-end:::
   :::column span="":::
      A microservices application with two sets of services. One set has in-scope pods for running a PCI-DSS workload. The other is out-of-scope. Both sets are spread across two user node pools. Segmentation is provided with the use of Kubernetes taints. Both sets are deployed to separate nodes and they never share a node VM. For details, see [Workload isolation](#workload-isolation).
   :::column-end:::   
:::row-end:::


## Security control differences between baseline and regulated architectures

This RI is built directly on top of the AKS Baseline, illustrating the promise that you can start with the AKS Baseline and evolve it into what you need it to be.

:::row:::
   :::column span="":::
      **Design area**
   :::column-end:::
   :::column span="":::
      **AKS baseline architecture**
   :::column-end:::
   :::column span="":::
      **AKS regulated architecture**
   :::column-end:::   
:::row-end:::
:::row:::
   :::column span="":::
      **Cluster mode**
   :::column-end:::
   :::column span="":::
      ![Placeholder](images/flow.png)
   :::column-end:::
   :::column span="":::
      ![Placeholder](images/network-topology-small.png)
   :::column-end:::   
:::row-end:::
:::row:::
   :::column span="":::
      **Network**
   :::column-end:::
   :::column span="":::

      - User node pool: 1
        The workload runs all all pods. 

      - System node pool: 1


   :::column-end:::
   :::column span="":::
      - User node pool: 2
        There are two workloads (in-scope and out-of-scope). The workloads are segmented in two separate node pools. For details, see [Workload isolation](#workload-isolation).

      - System node pool: 1

      - Additional compute for a jump box. This VM is used to run management tools.
   :::column-end:::   
:::row-end:::
:::row:::
   :::column span="":::
      **TLS**
   :::column-end:::
   :::column span="":::
      Firewall rules
      NSG
      WAF
      Network policies
   :::column-end:::
   :::column span="":::
      Firewall rules
      NSG
      WAF
      Network policies
   :::column-end:::   
:::row-end:::
:::row:::
   :::column span="":::
      **Malware detection operations**
   :::column-end:::
   :::column span="":::
      Firewall rules
      NSG
      WAF
      Network policies
   :::column-end:::
   :::column span="":::
      Firewall rules
      NSG
      WAF
      Network policies
   :::column-end:::   
:::row-end:::


Key differentiators over Baseline:
- Private AKS API Server, with Azure Bastion-fronted ops access.
- Enhanced focus on Azure Defender for topic
- Introduction of Azure Sentinel into the solution, with call out to SIEMs in general
- Additional Azure Policy application
- Extended retention period on logs to match common 90-day requirements
    - Extended logging validation steps to help a customer acclimate to the logs emitted, including audit (-admin) logs and azure firewall logs
- Enhanced Azure Container Registry topics (Quarantine pattern, subnet-isolated task runner, for example)
- Addresses in-cluster ISV/OSS CNCF solutions like security agents (Falco, Prisma, etc, etc, etc)
- Zero-trust network policies (which are directly tested via violation attempts as part of the sample workload)
- mTLS throughout the sample workload (Baseline TLS was terminated at the ingress controller) – this is an example of something that goes beyond PCI requirements
    - This is implemented via OSM, not as a technology recommendation, but as an implementation detail – we call out plenty of CNCF alternatives there.
	Layer 7 network policies within the mesh, including Service Account-based auth.
    - TLS trust chain certification at all levels, so not just encrypted, but CA chain validated as well.
- Nodepool subnet isolation (for refined Firewall and NSG application), including extended NSGs on the nodepool subnets
- Flux v2 for GitOps (baseline is Flux v1)
- NGINX Ingress Controller (Baseline was Traefik.  This was NOT swapped out because of any technical reason, it was swapped out illustratively to show that customers can bring the solution that fits best for them, as is the promise [read: demand] of Kubernetes)
- Namespace Limits and Quotas
- Team/Organization Role suggestions (coming from the C12 project) and mapping to Azure AD.
- Followed by a list of further recommendations that cannot easily be presented in a “one size fits all that are going to be deploying this right from GitHub” solution
    - Encryption at Host
    - Azure AD Conditional Access Policies
    - RBAC JIT Access
    - Activating Azure Security center at scale (HT: @Yuri Diogenes for his tweet this morning with a link to the enterprise at-scale enrollment docs – perfectly timed!)
    - OCI artifact signing and validation (this is a stretch goal which we’d like to add before GA – Notary v2 + Azure Policy integration, where are you? 😊)
    - ACR BYOK Encryption
    - Azure DDoS (not specifically related to regulated)


### Workload isolation
The main theme of the PCI standard is to isolate the PCI workload from other workloads in terms of operations and connectivity. In this series we differentiate between those concepts as:

- In-scope&mdash;The PCI workload, the environment in which it resides, and operations.

- Out-of-scope&mdash;Other workloads that may share services but are isolated from the in-scope components.

The key strategy is to provide the required level of segmentation. One way is to deploy in-scope and out-of-scope components in separate clusters. The down side is increased costs for the added infrastructure and the maintenance overhead. Another approach is to colocate all components in a shared cluster. Use segmentation strategies to maintain the separation. 

In the reference implementation, the second approach is demonstrated with a microservices application deployed to a single cluster. The application has  two sets of services; one set has in-scope pods and the other is out-of-scope. Both sets are spread across two user node pools. With the use of Kubernetes taints, in-scope and out-of-scope pods are deployed to separate nodes and they never share a node VM.

> [!IMPORTANT]
>
> The reference architecture and implementation have not been certified by an official authority. By completing this series and deploying the code assets, you do not clear audit for PCI DSS. Acquire compliance attestations from third-party auditors.

## Next

Install and maintain a firewall configuration to protect cardholder data. Do not use vendor-supplied defaults for system passwords and other security parameters.

> [!div class="nextstepaction"]
> [Build and Maintain a Secure Network and Systems](aks-pci-network.yml)