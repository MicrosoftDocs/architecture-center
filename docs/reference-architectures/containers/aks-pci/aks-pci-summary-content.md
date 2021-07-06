The Azure Well-Architected Framework is a set of guiding tenets that can be used to assess a solution through the quality  pillars of architecture excellence: 
- [Cost Optimization](#cost-optimization)
- [Operational Excellence](#operational-excellence)
- [Performance Efficiency](#performance-efficiency)
- [Reliability](#reliability)
- [Security](#security)

> This article ends this series. Read the [introduction](aks-pci-intro.yml).

This guidance provided in this series incorporate Well-Architected principles in all design choices. This article summarizes those choices.  The [GitHub: Azure Kubernetes Service (AKS) Baseline Cluster for Regulated Workloads](https://github.com/mspnp/aks-baseline-regulated) implementation demonstrates those principles, as applicable. 

PCI DSS 3.2.1 workloads demand the rigor of being a well-architected solution. While aligning the  infrastructure with PCI requirements is critical, compliance doesn't stop at the hosting infrastructure.Not addressing the quality pillars, specifically Security, can jeopardize compliance. Well-architected solutions combine both the infrastructure and workload perspective to arrive at the rigor necessary for achieving compliant outcomes.

## Security

Follow the fundamental guidance provided in the [Security design principles](/azure/architecture/framework/security/security-principles). Best practices for a regulated environment are summarized in these sections.

### Governance
The governance implementation is driven by the compliance requirements PCI-DSS 3.2.1. This influences the technical controls for maintaining segmentation, accessing resources, detecting vulnerabilities, and most importantly protecting customer data. 

#### Enterprise segmentation strategy

To maintain complete isolation, we recommend that the regulated infrastructure is deployed in a standalone subscription. If you have multiple subscriptions that are necessary for compliance, consider grouping them under a management group hierarchy that applies the relevant Azure Policies uniformly across your in-scope subscriptions. With in the subscription, apply related Azure Policies at a subscription level to capture the broad policies that should apply to all clusters in the cardholder data environment (CDE), and at the resource group level to capture policies that apply to a specific cluster instance. These policies build the core guardrails of a landing zone.

Isolate the PCI workload (in-scope) from other (out-of-scope) workloads in terms of operations and connectivity. You can create isolation through by deploying separate clusters. Or, use segmentation strategies to maintain the separation. For example, the cluster use separate node pools so that workloads never share a node VM.

#### Policy enforcement

Enforce security controls by enabling Azure Policies. For example in this regulated architecture, you can prevent misconfiguration of the cardholder data environment. You can apply an Azure policy that doesn't allow public IP allocations on the VM nodes. Such allocations are detected and reported or blocked

For information about policies you can enable for AKS, see 
[Azure Policy built-in definitions for Azure Kubernetes Service](/azure/aks/policy-reference).

Azure provides several built-in policies for most services. Review these [Azure Policy built-in policy definitions](/azure/governance/policy/samples/built-in-policies) and apply them as appropriate. 

#### Compliance monitoring
Compliance must be systematically monitored and maintained. Regular compliance attestations are performed. Knowing whether your cloud resources are in compliance, will help prepare for attestations and audit. 

Take advantage the regulatory compliance dashboard provided by Azure Security Center. By continuously monitoring the dashboard, you can keep track of the compliance status of your workload. 

![Compliance dashboard](.\images\regulatory-compliance-pci.png)

### Network security
In a hub and spoke topology, having separate virtual networks for each entity provides basic segmentation in the networking footprint. Each network is further segmented into subnets. 

The AKS cluster is forms the core of the the cardholder data environment (CDE). This shouldn't be accessible from public IP addresses and connectivity must be secured. Typical flows in and out of CDE can be categorized as:

- Inbound traffic to the cluster.
- Outbound traffic from the cluster.
- In-cluster traffic between pods. 

To meet the requirements of a regulated environment, the cluster is deployed as a private cluster. In this mode traffic to and from the public internet is restricted. Even communication with the AKS-managed Kubernetes API server is private. Security is further enhanced with strict network controls and IP firewall rules. 

- Network Security Groups (NSG) to secure communication between resources within a network.
- Azure Firewall to filter any outbound traffic between cloud resources, the internet, and on-premises.
- Azure Application Gateway integrated with Web Application Framework (WAF) to filter all inbound traffic from the internet is intercepted by Azure Application Gateway. 
- Kubernetes NetworkPolicy to allow only certain paths between the pods in the cluster. 
- Private Link to other Azure PaaS services, such as Azure Key Vault and Azure Container Registry to do operational tasks.

There are monitoring process in place to make sure traffic flows as expected and any anomaly is detected and reported.

For details on network security, see [Network segmentation](/azure/architecture/reference-architectures/containers/aks-pci/aks-pci-network).

### Data security

PCI-DSS 3.2.1 requires that all cardholder data (CHD) is never clear whether in transit or in storage. 

Because this architecture and the implementation are focused on infrastructure and not the workload, data management is not demonstrated. Here are some well-architected recommendations.

#### Data at rest

The data must be encrypted using industry standard encryption algorithms. 

- Don't store data in the cardholder environment. 
- Encrypt outside the storage layer.
- Write only encrypted data into storage medium.
- Don't store the keys in the storage layer.

All data in Azure Storage encrypted and decrypted by using strong cryptography. Self-managed encryption keys are preferred. 

If you need to store data temporarily, apply same considerations to that data. Enabling the [host-encryption feature](/azure/aks/enable-host-encryption) of AKS is strongly recommended. You can enforce encryption of temporary data with built-in Azure Policies.

When you're choosing a storage technology, explore the retention features. Make sure all data is safely removed when the configured time expires. 

The standard also requires that sensitive authentication data (SAD) not stored. Make sure that the data is not exposed in logs, file names, cache and other data.

#### Data in transit

All communication with entities that interact with the cardholder data environment (CDE) must be over encrypted channels. 

- Only HTTPS traffic must be allowed to flow into the CDE. In this architecture, Azure Application Gateway denies all traffic over port 80.
- Preferably don't encrypt and decrypt data outside the CDE. If you do, consider that entity to be a part of the CDE.
- Within the CDE, provide secure communication between pods with mTLS. You can choose to implement a service mesh for this purpose.
- Only allow secure ciphers and TLS 1.2 or later.

### Identity

Follow these security principles when designing your access policies.

- Start with Zero-Trust policies. Make exceptions as needed.
- Grant the least set of privileges just enough to complete a task.
- Minimize standing access.  

Kubernetes role-based access control (RBAC) manages permissions to the Kubernetes API. AKS supports those Kubernetes roles. AKS is fully integrated with Azure Active Directory (Azure AD). You can assign Azure AD identities to the roles and also to use many capabilities. 

#### Zero-Trust access
Kubernetes RBAC, Azure RBAC, and Azure services implement deny all by default. Override that setting with caution, allowing access to only those entities who need it. Another area for implementing Zero-Trust is to disable SSH access to the cluster nodes. 

### Least privileges
You can use managed identities for Azure resources and pods and scope them to the expected tasks. For example, Azure Application Gateway must have permissions to get secrets (TLS certificates) from Azure Key Vault. It must not have permissions to modify secrets.

### Minimize standing access
Minimize standing access by using [Just-In-Time AD group membership](/azure/aks/managed-aad#use-conditional-access-with-azure-ad-and-aks). Harden the control with [Conditional Access Policies in Azure AD](/azure/aks/managed-aad#use-conditional-access-with-azure-ad-and-aks). This option supports many use cases, such as, multifactor authentication, restrict authentication to devices that are managed by your Azure AD tenant, or block non-typical sign-in attempts.

## Secret management

Store secrets, certificates, keys, passwords, outside of CDE. You can use the native Kubernetes secrets or a managed key store, such as Azure Key Vault. Using a managed store will help in secret management tasks, such as key rotation, certificate renewal, and so on.

Make sure access to the key store has a balance of network and access controls. By enabling managed identities, the cluster has to authenticate itself against Key Vault to get access. Also, the connectivity to the key store must not be over the public internet. Use a private network, such as Private Link.

##  Operational Excellence

Follow the fundamental guidance provided in the [Operational excellence principles](/azure/architecture/framework/devops/principles). Best practices for a regulated environment are summarized in these sections.

### Separation of roles

Enforcing clear segregation of duties for regulated environments is key. Have definitions of roles and responsibility based on the needs of the workload and interaction with the cardholder data environment (CDE). For instance, you might need an infrastructure operator (or SRE) role for operations related to the cluster and dependent services. The role is responsible for maintaining security, isolation, deployment, and observability. Formalize those definitions and decide the permissions those roles need. For example, SREs are highly privileged for cluster access but need read access to workload namespaces.

### Workload isolation

PCI-DSS 3.2.1 requires isolation of the PCI workload from other workloads in terms of operations. In this implementation, the in-scope and out-of-scope workloads are segmented in two separate user node pools. Application developers	for in-scope and developers for out-of-scope workloads might have different set of permissions. Also, there will be separate quality gates. For example, the in-scope code is subject to upholding compliance and attestation while the out-of-scope isn't. There's also a need to have separate build pipelines and release management processes. 

### Operational metadata
Requirement 12 of the PCI DSS 3.2.1 standard requires you to maintain information about workload inventory and personnel access documentation. Using Azure Tags is strongly recommended because you can collate environment information with Azure resources, resource groups, and subscriptions. 

Maintain information about approved solutions that as part of the infrastructure and workload. This includes a list of VM images, databases, third-party solutions of your choice that you bring to the CDE. You can even automate that process by building a service catalog. It provides self-service deployment using those approved solutions in a specific configuration, which adheres to ongoing platform operations. 

### Observability
To fulfill Requirement 10, observability into the cardholder data environment (CDE) is critical for compliance. Activity logs provide information about, operations related to account and secret management; diagnostic setting management; server management; and other resource access operations. All logs are recorded with date, time, identity, and other detailed information. Retain logs for up to a year for in storage accounts for long-term archival and auditing.

Make sure logs are only accessed by roles that need them. Log Analytics and Azure Sentinel support various role-based access controls to manage audit trail access. 

### Response and remediation

The Azure monitoring services, Azure Monitor and Azure Security Center, can generate notifications or alerts when they detect anomalous activity. Those alerts include context information such as severity, status, and activity time. As alerts are generated, have a remediation strategy and review progress. Centralizing data a SIEM solution is recommended because integrating data can provide rich alert context.

From the Security alerts view in Azure Security Center, you have access to all alerts that Azure Security Center detects on your resources. Have a triage process to  address the issue. Work with your security team to understand how relevant alerts will be made available to the workload owner(s).


## Performance Efficiency 

Follow the fundamental guidance provided in the [Performance efficiency principles](/azure/architecture/framework/scalability/principles). Best practices for a regulated environment are summarized in these sections.

### Scaling
	
Observing how the environment adjusts to changing demands will indicate the expected runtime behavior of the environment under high load. Autoscaling resources in the workload will minimize human interaction in the CDE. An added security benefit is reducing the attack surface at all times. You can maximize the benefit, by taking advantage of resources that support the scale-to-zero approach. For example AKS supports scaling down the user node pools to 0. For more information, see [Scale User node pools to 0](/azure/aks/scale-cluster#scale-user-node-pools-to-0).
	
### Partitioning
	
Partitioning is a key factor for performance efficiency in regulated workloads. Having discrete components allows for crisp definition of responsibility and helps in precise controls, such as network policies. Similar to any segmentations strategy, partitioning isolates components and controls the impact of blast radius on unexpected failures or system compromise.
	
### Shared-nothing architecture
	
The shared-nothing architecture is designed to remove contention between colocated workloads. Also, this is a strategy for removing single points of failure. In a regulated environment, components are required to be isolated logical or physical boundaries. This aligns with the shared-nothing architecture resulting in  scalability benefits. Also, allows for targeting of relevant security controls and tighter auditing capabilities of the various components.
	
### Lightweight frameworks
	
Complexity of workloads is hard to document and to audit. Strive for simplicity because of the performance benefits and ease of auditing regulatory requirements. Evaluate choices that have more breath than is needed because that increases the attack surface area and potential for misuse, misconfiguration.

## Reliability
The reliability of regulated environment needs to be predictable so that they can be explained consistently for auditing purposes. Follow the fundamental guidance provided in the [Reliability principles](/azure/architecture/framework/resiliency/overview). Best practices for a regulated environment are summarized in these sections.

	
### Recovery Targets and Disaster Recovery
	
Due to the sensitive nature of the data handled in regulated workloads, recovery targets, Recovery Point Objective (RPO), are critical to define. What is acceptable loss of cardholder data (CHD)? Recovery efforts within the cardholder data environment (CDE) are still subject to the standard requirements. Expect failures and have a clear recovery plan for those failures that align with roles, responsibilities, and justified data access. Live-site site issues are not justification for deviating from any regulations.
	
This is especially important in a full disaster recovery situation. Have clear disaster recovery documentation about that adheres to the requirements and minimizes unexpected CDE or CHD access. After recovery, always review the recovery process steps to ensure no unexpected access occurred and document business justifications for those instances.
	
### Recovery
	
Adding resilience and recovery strategies to your architecture can prevent the need for adhoc access to the CDE. The system should be able to self-recover at the defined RPO without the need for direct human intervention. This way you can eliminate unnecessary exposure of CHD, even to those individuals that are authorized to have emergency access. The recovery process must be auditable. 
	
### Address security-related risks
	
Review security risks because they can be a source of workload downtime and data loss. The investments in security also have impact on workload reliability.
	
### Operational process
	
Reliability extends to all operational processes in and adjacent to the CDE. Well defined, automated, and tested processes for concern like image building and jump box management factor into a well-architected solution.

## Cost Optimization

Because of the compliance requirements and strict security controls, a clear tradeoff is cost. We recommend, that you establish initial estimates by using the [Pricing Calculator](https://azure.microsoft.com/pricing/calculator/).

Here's a high-level representation of the cost impact of the main resources used by this architecture.

![Cost management](.\images\cost-analysis.png)

The main drivers are the virtual machine scale sets that make up the node pools and Azure Firewall. Another contributor is Log Analytics. There are also incremental costs associated with Azure Defender depending on your choice of plans.

Have a clear understanding of what constitutes the price of a service. Azure tracks metered usage. Here's a drilldown of Azure Firewall for this architecture.  

![Cost management -- Azure Firewall example](.\images\firewall-cost.png)

The cost associated with some resources, such as Azure Firewall, can be spread across multiple business units and/or applications. Another way to optimize cost might be to host a multi-tenant cluster within an organization, maximizing density with workload diversity. This approach is _not_ recommended for regulated workloads. Always prioritize compliance and segmentation over cost benefits.

To keep within the budget constraints, some ways to control cost are by adjusting the Azure Application Gateway infrastructure, setting the instance count for autoscaling, and reducing the log output as long as they still meet the audit trail required by PCI-DSS 3.2.1. Always evaluate those choices against the tradeoffs on other aspects of the design that allow you to meet your SLA. For example, are you  still able to scale appropriately to meet spikes in traffic. 

As you create groups of Azure resources, apply tags so that they can tracked for cost. Use cost management tools like [Azure Advisor](/azure/advisor/advisor-cost-recommendations) and [Azure Cost Management](/azure/cost-management-billing/costs/cost-mgt-best-practices) for tracking and analyzing cost. 



