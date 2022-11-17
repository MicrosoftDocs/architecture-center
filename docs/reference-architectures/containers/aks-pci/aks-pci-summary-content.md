The Azure Well-Architected Framework is a set of guiding tenets that can be used to assess a solution through the quality pillars of architecture excellence:

- [Cost Optimization](#cost-optimization)
- [Operational Excellence](#operational-excellence)
- [Performance Efficiency](#performance-efficiency)
- [Reliability](#reliability)
- [Security](#security)

> This article ends this series. Read the [introduction](aks-pci-intro.yml).

This guidance provided in this series incorporates Well-Architected principles in all design choices. This article summarizes those choices. The [GitHub: Azure Kubernetes Service (AKS) Baseline Cluster for Regulated Workloads](https://github.com/mspnp/aks-baseline-regulated) implementation demonstrates those principles, as applicable.

PCI DSS 3.2.1 workloads demand the rigor of being a well-architected solution. Although aligning the infrastructure with PCI requirements is critical, compliance doesn't stop at the hosting infrastructure. Not addressing the quality pillars, specifically security, can jeopardize compliance. Well-architected solutions combine both the infrastructure and workload perspectives to arrive at the rigor necessary for achieving compliant outcomes.

## Security

Follow the fundamental guidance provided in the [Security design principles](/azure/architecture/framework/security/security-principles). Best practices for a regulated environment are summarized in these sections.

### Governance

The governance implementation is driven by the compliance requirements in PCI-DSS 3.2.1. This influences the technical controls for maintaining segmentation, accessing resources, detecting vulnerabilities, and most importantly protecting customer data.

#### Enterprise segmentation strategy

To maintain complete isolation, we recommend deploying the regulated infrastructure in a standalone subscription. If you have multiple subscriptions that are necessary for compliance, consider grouping them under a management group hierarchy that applies the relevant Azure policies uniformly across your in-scope subscriptions. Within the subscription, apply related Azure policies at a subscription level to capture the broad policies that should apply to all clusters in the cardholder data environment (CDE). Apply related Azure policies at the resource group level to capture policies that apply to a specific cluster instance. These policies build the core guardrails of a landing zone.

Isolate the PCI workload (in-scope) from other (out-of-scope) workloads in terms of operations and connectivity. You can create isolation by deploying separate clusters. Or, use segmentation strategies to maintain the separation. For example, the clusters use separate node pools so that workloads never share a node virtual machine (VM).

#### Policy enforcement

Enforce security controls by enabling Azure policies. For example, in this regulated architecture, you can prevent misconfiguration of the cardholder data environment. You can apply an Azure policy that doesn't allow public IP allocations on the VM nodes. Such allocations are detected and reported or blocked.

For information about policies you can enable for AKS, see
[Azure Policy built-in definitions for Azure Kubernetes Service](/azure/aks/policy-reference).

Azure provides several built-in policies for most services. Review these [Azure Policy built-in policy definitions](/azure/governance/policy/samples/built-in-policies) and apply them as appropriate.

#### Compliance monitoring

Compliance must be systematically monitored and maintained. Regular compliance attestations are performed. Knowing whether your cloud resources are in compliance will help prepare for attestations and audit.

Take advantage the regulatory compliance dashboard in Microsoft Defender for Cloud. By continuously monitoring the dashboard, you can keep track of the compliance status of your workload.

:::image type="content" source="./images/regulatory-compliance-pci.png" alt-text="Example compliance monitoring" border ="true":::

### Network security

In a hub-spoke topology, having separate virtual networks for each entity provides basic segmentation in the networking footprint. Each network is further segmented into subnets.

The AKS cluster forms the core of the CDE. It shouldn't be accessible from public IP addresses, and connectivity must be secured. Typical flows in and out of CDE can be categorized as:

- Inbound traffic to the cluster.
- Outbound traffic from the cluster.
- In-cluster traffic between pods.

To meet the requirements of a regulated environment, the cluster is deployed as a private cluster. In this mode, traffic to and from the public internet is restricted. Even communication with the AKS-managed Kubernetes API server is private. Security is further enhanced with strict network controls and IP firewall rules.

- Network Security Groups (NSGs) to help secure communication between resources within a network.
- Azure Firewall to filter any outbound traffic between cloud resources, the internet, and on-premises.
- Azure Application Gateway integrated with Azure Web Application Framework to filter all inbound traffic from the internet that Azure Application Gateway intercepts.
- Kubernetes NetworkPolicy to allow only certain paths between the pods in the cluster.
- Azure Private Link to connect to other Azure platform as a service (PaaS) services, such as Azure Key Vault and Azure Container Registry for operational tasks.

Monitoring processes are in place to make sure that traffic flows as expected and that any anomaly is detected and reported.

For details on network security, see [Network segmentation](./aks-pci-network.yml).

### Data security

PCI-DSS 3.2.1 requires that all cardholder data (CHD) is never clear, whether in transit or in storage.

Because this architecture and the implementation are focused on infrastructure and not the workload, data management is not demonstrated. Here are some well-architected recommendations.

#### Data at rest

The data must be encrypted through industry-standard encryption algorithms.

- Don't store data in the cardholder environment.
- Encrypt outside the storage layer.
- Write only encrypted data into the storage medium.
- Don't store the keys in the storage layer.

All data in Azure Storage is encrypted and decrypted by using strong cryptography. Self-managed encryption keys are preferred.

If you need to store data temporarily, apply the same considerations to that data. We strongly recommend enabling the [host-encryption feature](/azure/aks/enable-host-encryption) of AKS. You can enforce encryption of temporary data with built-in Azure policies.

When you're choosing a storage technology, explore the retention features. Make sure all data is safely removed when the configured time expires.

The standard also requires that sensitive authentication data (SAD) is not stored. Make sure that the data is not exposed in logs, file names, cache, and other data.

#### Data in transit

All communication with entities that interact with the CDE must be over encrypted channels.

- Only HTTPS traffic must be allowed to flow into the CDE. In this architecture, Azure Application Gateway denies all traffic over port 80.
- Preferably, don't encrypt and decrypt data outside the CDE. If you do, consider that entity to be a part of the CDE.
- Within the CDE, provide secure communication between pods with mTLS. You can choose to implement a service mesh for this purpose.
- Only allow secure ciphers and TLS 1.2 or later.

### Identity

Follow these security principles when you're designing access policies:

- Start with Zero-Trust policies. Make exceptions as needed.
- Grant the least privileges--just enough to complete a task.
- Minimize standing access.

Kubernetes role-based access control (RBAC) manages permissions to the Kubernetes API. AKS supports those Kubernetes roles. AKS is fully integrated with Azure Active Directory (Azure AD). You can assign Azure AD identities to the roles and also take advantage of other capabilities.

#### Zero-Trust access

Kubernetes RBAC, Azure RBAC, and Azure services implement *deny all* by default. Override that setting with caution, allowing access to only those entities who need it. Another area for implementing Zero-Trust is to disable SSH access to the cluster nodes.

### Least privileges

You can use managed identities for Azure resources and pods and scope them to the expected tasks. For example, Azure Application Gateway must have permissions to get secrets (TLS certificates) from Azure Key Vault. It must not have permissions to modify secrets.

### Minimizing standing access

Minimize standing access by using [just-in-time Azure AD group membership](/azure/aks/managed-aad#use-conditional-access-with-azure-ad-and-aks). Harden the control with [Conditional Access Policies in Azure AD](/azure/aks/managed-aad#use-conditional-access-with-azure-ad-and-aks). This option supports many use cases, such as multifactor authentication, restricting authentication to devices that are managed by your Azure AD tenant, or blocking atypical sign-in attempts.

## Secret management

Store secrets, certificates, keys, and passwords outside the CDE. You can use the native Kubernetes secrets or a managed key store, such as Azure Key Vault. Using a managed store will help in secret management tasks, such as key rotation and certificate renewal.

Make sure access to the key store has a balance of network and access controls. When you enable managed identities, the cluster has to authenticate itself against Key Vault to get access. Also, the connectivity to the key store must not be over the public internet. Use a private network, such as Private Link.

## Operational Excellence

Follow the fundamental guidance provided in the [Operational Excellence principles](/azure/architecture/framework/devops/principles). Best practices for a regulated environment are summarized in these sections.

### Separation of roles

Enforcing clear segregation of duties for regulated environments is key. Have definitions of roles and responsibilities based on the needs of the workload and interaction with the CDE. For instance, you might need an infrastructure operator or site reliability engineer (SRE) role for operations related to the cluster and dependent services. The role is responsible for maintaining security, isolation, deployment, and observability. Formalize those definitions and decide the permissions that those roles need. For example, SREs are highly privileged for cluster access but need read access to workload namespaces.

### Workload isolation

PCI-DSS 3.2.1 requires isolation of the PCI workload from other workloads in terms of operations. In this implementation, the in-scope and out-of-scope workloads are segmented in two separate user node pools. Application developers for in-scope and developers for out-of-scope workloads might have different sets of permissions. Also, there will be separate quality gates. For example, the in-scope code is subject to upholding compliance and attestation, whereas the out-of-scope code isn't. There's also a need to have separate build pipelines and release management processes.

### Operational metadata

Requirement 12 of the PCI DSS 3.2.1 standard requires you to maintain information about workload inventory and personnel access documentation. We strongly recommend using Azure tags because you can collate environment information with Azure resources, resource groups, and subscriptions.

Maintain information about approved solutions that are part of the infrastructure and workload. This includes a list of VM images, databases, and third-party solutions of your choice that you bring to the CDE. You can even automate that process by building a service catalog. It provides self-service deployment by using those approved solutions in a specific configuration, which adheres to ongoing platform operations.

### Observability

To fulfill Requirement 10, observability into the CDE is critical for compliance. Activity logs provide information about operations related to account and secret management, diagnostic setting management, server management, and other resource access operations. All logs are recorded with date, time, identity, and other detailed information. Retain logs for up to a year by configuring [data retention and archive policies](/azure/azure-monitor/logs/data-retention-archive) in Azure Monitor Logs.

Make sure logs are only accessed by roles that need them. Log Analytics and Microsoft Sentinel support various role-based access controls to manage audit trail access.

### Response and remediation

The Azure monitoring services, Azure Monitor and Microsoft Defender for Cloud, can generate notifications or alerts when they detect anomalous activity. Those alerts include context information such as severity, status, and activity time. As alerts are generated, have a remediation strategy and review progress. We recommend centralizing data in a security information and event management (SIEM) solution because integrating data can provide rich alert context.

From the **Security alerts** view in Microsoft Defender for Cloud, you have access to all alerts that Microsoft Defender for Cloud detects on your resources. Have a triage process to address the issue. Work with your security team to understand how relevant alerts will be made available to the workload owners.

## Performance Efficiency

Follow the fundamental guidance provided in the [Performance Efficiency principles](/azure/architecture/framework/scalability/principles). Best practices for a regulated environment are summarized in these sections.

### Scaling

Observing how the environment adjusts to changing demands will indicate the expected runtime behavior of the environment under high load. Autoscaling resources in the workload will minimize human interaction in the CDE. An added security benefit is reducing the attack surface at all times. You can maximize the benefit by taking advantage of resources that support the scale-to-zero approach. For example, AKS supports scaling down the user node pools to 0. For more information, see [Scale user node pools to 0](/azure/aks/scale-cluster#scale-user-node-pools-to-0).

### Partitioning

Partitioning is a key factor for performance efficiency in regulated workloads. Having discrete components allows for crisp definition of responsibility and helps in precise controls, such as network policies. Similar to any segmentation strategy, partitioning isolates components and controls the impact of blast radius on unexpected failures or system compromise.

### Shared-nothing architecture

The shared-nothing architecture is designed to remove contention between colocated workloads. Also, this is a strategy for removing single points of failure. In a regulated environment, components are required to be isolated by logical or physical boundaries. This aligns with the shared-nothing architecture, resulting in scalability benefits. Also, it allows for targeting of relevant security controls and tighter auditing capabilities of the various components.

### Lightweight frameworks

Complexity of workloads is hard to document and to audit. Strive for simplicity because of the performance benefits and ease of auditing regulatory requirements. Evaluate choices that have more breath than is needed, because that increases the attack surface area and the potential for misuse or misconfiguration.

## Reliability

The reliability of regulated environments needs to be predictable so that they can be explained consistently for auditing purposes. Follow the fundamental guidance provided in the [reliability principles](/azure/architecture/framework/resiliency/principles). Best practices for a regulated environment are summarized in these sections.

### Recovery targets and disaster recovery

Due to the sensitive nature of the data handled in regulated workloads, recovery targets and recovery point objectives (RPOs) are critical to define. What is acceptable loss of CHD? Recovery efforts within the CDE are still subject to the standard requirements. Expect failures and have a clear recovery plan for those failures that align with roles, responsibilities, and justified data access. Live-site issues are not justification for deviating from any regulations. This is especially important in a full disaster recovery situation. Have clear disaster recovery documentation that adheres to the requirements and minimizes unexpected CDE or CHD access. After recovery, always review the recovery process steps to ensure that no unexpected access occurred. Document business justifications for those instances.

### Recovery

Adding resilience and recovery strategies to your architecture can prevent the need for ad hoc access to the CDE. The system should be able to self-recover at the defined RPO without the need for direct human intervention. This way, you can eliminate unnecessary exposure of CHD, even to those individuals who are authorized to have emergency access. The recovery process must be auditable.

### Addressing security-related risks

Review security risks because they can be a source of workload downtime and data loss. The investments in security also have an impact on workload reliability.

### Operational processes

Reliability extends to all operational processes in and adjacent to the CDE. Well-defined, automated, and tested processes for concerns like image building and jump box management factor into a well-architected solution.

## Cost Optimization

Follow the fundamental guidance provided in the [Cost Optimization principles](/azure/architecture/framework/cost/overview).

Because of the compliance requirements and strict security controls, a clear tradeoff is cost. We recommend, that you establish initial estimates by using the [Pricing Calculator](https://azure.microsoft.com/pricing/calculator/).

Here's a high-level representation of the cost impact of the main resources that this architecture uses.

![Diagram of cost management in the architecture.](.\images\cost-analysis.png)

The main drivers are the virtual machine scale sets that make up the node pools and Azure Firewall. Another contributor is Log Analytics. There are also incremental costs associated with Microsoft Defender for Cloud, depending on your choice of plans.

Have a clear understanding of what constitutes the price of a service. Azure tracks metered usage. Here's a drilldown of Azure Firewall for this architecture.

![Diagram that illustrates cost management in an Azure Firewall example.](.\images\firewall-cost.png)

The cost associated with some resources, such as Azure Firewall, can be spread across multiple business units and/or applications. Another way to optimize cost might be to host a multitenant cluster within an organization, maximizing density with workload diversity. We do *not* recommend this approach for regulated workloads. Always prioritize compliance and segmentation over cost benefits.

To keep within the budget constraints, some ways to control cost are by adjusting the Azure Application Gateway infrastructure, setting the instance count for autoscaling, and reducing the log output as long as they still meet the audit trail required by PCI-DSS 3.2.1. Always evaluate those choices against the tradeoffs on other aspects of the design that allow you to meet your SLA. For example, are you still able to scale appropriately to meet spikes in traffic.

As you create groups of Azure resources, apply tags so that they can be tracked for cost. Use cost management tools like [Azure Advisor](/azure/advisor/advisor-cost-recommendations) and [Azure Cost Management](/azure/cost-management-billing/costs/cost-mgt-best-practices) for tracking and analyzing cost.
