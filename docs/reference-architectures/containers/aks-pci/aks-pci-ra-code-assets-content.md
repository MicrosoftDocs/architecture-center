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

The baseline architecture has one user node pool and another for the system node pool. The workload runs on all the pods. This architecture has two user node pools and one system node pool. The in-scope and out-of-scope workloads are segmented in two separate user node pools. For more, see [Workload segmentation](#workload-isolation).

In this architecture, Kubernetes ingress controller inside the cluster is NGINX. In the baseline architecture, we chose Traefik. This change illustrates that the service can be changed based on your choice.

The baseline architecture deployed the AKS cluster in public mode. This means all communication with the AKS-managed Kubernetes API server is over the public internet. This is not acceptable in this architecture because PCI-DSS prohibits public exposure to system components. In this regulated architecture, the cluster is deployed as a private cluster. Network traffic between the Kubernetes API server and your node pools is private. The API server is exposed through a Private Endpoint in the cluster's network. The security is further enhanced with the use of Azure Virtual Network, an NSG, and other built-in features. These are described in [Network configuration](#networking-configuration).


### Pod security

When describing your workload's security needs, use relevant `securityContext` settings for your containers. This includes basic settings such as like `fsGroup`, `runAsUser` / `runAsGroup`, and setting `allowPriviledgeEscalation` to false (unless required). Be clear about defining and removing Linux capabilities and defining your SELinux options in seLinuxOptions. 

Avoid referencing images by their tags in your deployment manifests. Instead, use the actual image id. That way, you can reliably map container scan results with the actual content running in your cluster. You can enforce it through Azure Policy for image name to include image id pattern in the allowed regular expression. Also follow this guidance when using the Dockerfile FROM command.

### Workload isolation
The main theme of the PCI standard is to isolate the PCI workload from other workloads in terms of operations and connectivity. In this series we differentiate between those concepts as:

- In-scope&mdash;The PCI workload, the environment in which it resides, and operations.

- Out-of-scope&mdash;Other workloads that may share services but are isolated from the in-scope components.

The key strategy is to provide the required level of segmentation. One way is to deploy in-scope and out-of-scope components in separate clusters. The down side is increased costs for the added infrastructure and the maintenance overhead. Another approach is to colocate all components in a shared cluster. Use segmentation strategies to maintain the separation. 

In the reference implementation, the second approach is demonstrated with a microservices application deployed to a single cluster. The application has  two sets of services; one set has in-scope pods and the other is out-of-scope. Both sets are spread across two user node pools. With the use of Kubernetes taints, in-scope and out-of-scope pods are deployed to separate nodes and they never share a node VM.

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

### TLS encryption

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

We strongly recommend that standing access is minimized especially for high-impact accounts, such as SRE/Ops interactions with your cluster. 

The AKS control plane supports both [Azure AD Privileged Access Management (PAM) just-in-time (JIT)](/azure/aks/managed-aad#configure-just-in-time-cluster-access-with-azure-ad-and-aks). [Conditional Access Policies](/azure/aks/managed-aad#use-conditional-access-with-azure-ad-and-aks) can provide additional layers of required authentication validation for privileged access, based on the rules you build.

For more details on using PowerShell to configure conditional access, see [Azure AD Conditional Access](https://github.com/mspnp/aks-baseline-regulated/blob/main/docs/conditional-access.md).

Define roles and set access policies as per the requirements of the role. Map roles to Kubernetes actions scoped as narrow as practical. Avoid roles that span multiple functions. If multiple roles are filled by one person, assign that person all roles that are relevant to the equivalent job functions. So, even if one person is directly responsible for both the cluster and the workload, create your Kubernetes `ClusterRoles` as if there were separate individuals, and then assign that single individual all relevant roles.  

## Azure Policy considerations

Typically, Azure Policies applied do not have workload-tuned settings. In the implementation, we're applying the Kubernetes cluster pod security restricted standards for Linux-based workloads initiative which does not allow tuning of settings. Consider exporting this initiative and customizing its values for your specific workload. You can include all Gatekeeper `deny` Azure Policies under one custom initiative and all `audit` Azure Policies under another initiative to categorize block actions from information-only policies.

Consider including `kube-system` and `gatekeeper-system` to policies in your audit policies for added visibility. Including those namespaces in `deny` policies could cause cluster failure because of an unsupported configuration. 

## Managing images

Use distroless base images for your workloads. With these images, the security surface area is minimized because supplementary images, such as shells, package managers, are removed. A benefit is reduced CVE hit rates.

Azure Container Registry supports images that meet the [Open Container Initiative (OCI) Image Format Specification](https://github.com/opencontainers/image-spec/blob/master/spec.md). This, coupled with an admission controller that supports validating signatures, can ensure that you're only running images that you've signed with your private keys. There are open-source solutions such as SSE Connaisseur or IBM Portieris that integrate those processes. 

Protect container images and other OCI artifacts because they contain the organization's intellectual property. Use customer-managed keys and encrypt the contents of your registries. By default, the data is encrypted at rest with service-managed keys, but customer-managed keys are sometimes required to meet regulatory compliance standards. Store the key in a managed key store such as Azure Key Vault. Because the key is created and owned by you, operations related to key lifecycle, including rotation and management, is your responsibility . For more information, see Learn more at, [Encrypt registry using a customer-managed key](https://aka.ms/acr/CMK).

## Kubernetes API Server operational access

In this architecture, a jump box is provisioned in a dedicated compute runs management tools such as kubectl. To have auditable collaboration in the workflow for live-site issues, (for instance between cluster administrator, workload administrator, and others)  consider a ChatOps approach. One way is to frontend the jump box with Microsoft Teams. That gives you the ability to limit commands executed against the cluster, without necessarily building an operational process based around jump boxes. Also, you may already have an IAM-gated IT automation platform in place in which pre-defined actions can be constructed. Its action runners would then execute within the snet-management-agents subnet while the initial invocation of the actions is audited and controlled in the IT automation platform.

### Build Agents
Pipeline agents should be out-of-scope to the regulated cluster because build processes can be threat vectors. You can even use Kubernetes as your build agent infrastructure but don't run that process within the boundary of the regulated workload runtime.

Your build agents shouldn't have direct access to the  cluster. For example, only give build agents network access to Azure Container Registry to push container images, helm charts, and so on. Then, deploy through GitOps. Also, build and release workflows shouldn't have direct access to your Kubernetes Cluster API (or its nodes).

 ## Monitoring operations

The in-cluster `omsagent` pods running in `kube-system` are the Log Analytics collection agent. They gather telemetry, scrape container stdout and stderr logs, and collect Prometheus metrics. You can tune its collection settings by updating the `container-azm-ms-agentconfig.yaml` ConfigMap file. In this reference implementation, logging is enabled across `kube-system` and all your workloads. By default, `kube-system` is excluded from logging. Ensure you're adjusting the log collection process to achieve balance cost objectives, SRE efficiency when reviewing logs, and compliance needs.

### Security monitoring

Use Azure Security Center to view and remediate security recommendations. Also, view security alerts view on your resources. Enable Azure Defender plans as they apply to various components of the cardholder data environment. 

Have a triage process to address the detected issues. Work with your security team to understand how relevant alerts will be made available to the workload owner(s).

We recommend that you integrate logs so that you're able to  review, analyze, and query data efficiently. Azure provides several technology options. You can use Azure Monitor for Containers to write logs into a Log Analytics workspace. Another option is to integrate data into security information and event management (SIEM) solutions, such as Azure Sentinel. 

As required by the standard, all Log Analytics workspaces are set to a 90-day retention period. Consider setting up continuous export for longer-term storage. Don't store sensitive information in log data. Make sure access to archived log data is subject to same levels of access controls as recent log data.

For a complete end-to-end perspective, see [Azure Security Center Enterprise Onboarding Guide](https://aka.ms/ASCOnboarding). This guide addresses enrollment, data exports to your security information and event management (SIEM) solutions, responding to alerts, building workflow automation, and more. 

> [!IMPORTANT]
>
> Stop here. This article is work in progress. Check back on updates.
>

Key differentiators over Baseline:

- Enhanced Azure Container Registry topics (Quarantine pattern, subnet-isolated task runner, for example)
- Addresses in-cluster ISV/OSS CNCF solutions like security agents (Falco, Prisma, etc, etc, etc)
- Namespace Limits and Quotas
- Followed by a list of further recommendations that cannot easily be presented in a “one size fits all that are going to be deploying this right from GitHub” solution
    - Encryption at Host
    - ACR BYOK Encryption
    - Azure DDoS (not specifically related to regulated)


## Next

Install and maintain a firewall configuration to protect cardholder data. Do not use vendor-supplied defaults for system passwords and other security parameters.

> [!div class="nextstepaction"]
> [Build and Maintain a Secure Network and Systems](aks-pci-network.yml)