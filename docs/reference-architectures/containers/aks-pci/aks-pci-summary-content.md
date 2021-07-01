
The Azure Well-Architected Framework is a set of guiding tenets that can be used to assess a solution through the quality  pillars of architecture excellence: 
- [Cost Optimization](#cost-optimization)
- Operational Excellence
- Performance Efficiency
- Reliability
- [Security](#security)

> This article ends this series. Read the [introduction](aks-pci-intro.yml).

This guidance provided in this series incorporate Well-Architected principles in all design choices. This article summarizes those choices.  The [GitHub: Azure Kubernetes Service (AKS) Baseline Cluster for Regulated Workloads](https://github.com/mspnp/aks-baseline-regulated) implementation demonstrates those principles, as applicable. 

> [!IMPORTANT]
>
> This article is work in progress. Check back on updates.
>

## Security

### Governance
The governance implementation is driven by the compliance requirements PCI-DSS 3.2.1. This influences the technical controls for maintaining segmentation, accessing resources, detecting vulnerabilities, and most importantly protecting customer data. 

#### Enterprise segmentation strategy

To maintain complete isolation, we recommend that the regulated infrastructure is deployed in a standalone subscription. If you have multiple subscriptions that are necessary for compliance, consider grouping them under a management group hierarchy that applies the relevant Azure Policies uniformly across your in-scope subscriptions. With in the subscription, apply Azure Policies at a relatively local scope subscription or resource group. These policies build the guardrails of a landing zone.

#### Policy enforcement

Enforce security controls by enabling Azure Policies. For example in this regulated architecture, you can prevent misconfiguration of the cardholder data environment. You can apply an Azure policy that doesn't allow public IP allocations on the VM nodes. Such allocations are detected and reported or blocked

For information about policies you can enable for AKS, see 
[Azure Policy built-in definitions for Azure Kubernetes Service](/azure/aks/policy-reference).

Azure provides several built-in policies for most services. Review these [Azure Policy built-in policy definitions](azure/governance/policy/samples/built-in-policies) and apply them as appropriate. 

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

For details on network security, see [Network segmentation](aks-pci-network).

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

All communication with entitties that interact with the cardholder data enviroment (CDE) must be over encrypted channels. 

- Only HTTPS traffic must be allowed to flow into the CDE. In this architecture, Azure Application Gateway denies all traffic over port 80.
- Preferably don't encrypt and decrypt data outside the CDE. If you do, consider that entity to be a part of the CDE.
- Within the CDE, provide secure communication between pods with mTLS. You can choose to implement a service mesh for this purpose.
- Only allow secure ciphers and TLS 1.2 or later.

### Identity

Follow these security principles when designing your access policies.

-  Start with Zero-Trust policies. Make exceptions as needed and document them in detail.
- Least privilege. 

Kubernetes role-based access control (RBAC) that manages permissions to the Kubernetes API. AKS supports the Kubernetes roles. AKS is fully integrated with Azure Active Directory (Azure AD) that allows you to use many capabilities. 

- You can add Azure AD users for Kubernetes RBAC. 
- You can use managed identities for Azure resources and pods and scope them to the expected tasks. For example, Azure Application Gateway must have permissions to get secrets (TLS certificates) from Azure Key Vault. It must not have permissions to modify secrets.
- Don't have standing access. Consider using [Just-In-Time AD group membership](/azure/aks/managed-aad#use-conditional-access-with-azure-ad-and-aks).
- Harden access management with [Conditional Access Policies in Azure AD](/azure/aks/managed-aad#use-conditional-access-with-azure-ad-and-aks). This option supports many use cases, such as, multifactor authentication, restrict authentication to devices that are managed by your Azure AD tenant, or block non-typical sign-in attempts.

- Disable SSH access to the cluster nodes. 

## Secret management

## Secure DevOps

## Security monitoring

## Threat analysis

### Key management

Source all secrets, certificates and keys, in a managed key store. This will help in secret management tasks, such as key rotation, certificate renewal, and so on. Azure Key Vault is a good choice for this purpose. 

In a non-regulated environment, Azure Key Vault can be accessed through its public endpoint. Regulated standards, such as PCI-DSS, requires complete isolation of system components from the internet. So, when possible, communicate with Key Vault over a private network by using Private Link. For example, a common way to mount secrets on cluster pods is by using Secrets Store CSI Driver for Kubernetes. For that, the Secrets Store CSI Driver needs to get secrets from Key Vault and can do so over Private Link. 

There are cases when Private Link is not supported or access is restricted. Azure Application Gateway gets the public-facing TLS certificate stored in Azure Key Vault. However, Azure Application Gateway cannot communicate with Key Vault instances that are restricted through Private Link. You can use a hybrid model, This reference implementation deploys Azure Key Vault in a hybrid model, supporting Private Link and public access specifically to allow integration with Application Gateway. If this model is not suitable for your business requirements, move the secret management process to Application Gateway for public-facing TLS certificates. It might add overhead but Key Vault instance will be completely isolated.

For information, see [Create an application gateway with TLS termination using the Azure CLI](https://docs.microsoft.com/azure/application-gateway/tutorial-ssl-cli).

##  Operational Excellence

### Enable Network Watcher and Traffic Analytics

Observability into your network is critical for compliance. [Network Watcher](https://docs.microsoft.com/azure/network-watcher/network-watcher-monitoring-overview), combined with [Traffic Analysis](https://docs.microsoft.com/azure/network-watcher/traffic-analytics) will help provide a perspective into traffic traversing your networks. This reference implementation does not deploy NSG Flow Logs or Traffic Analysis by default. These features depend on a regional Network Watcher resource being installed on your subscription. Network Watchers are singletons in a subscription, and there is no reasonable way to include them in these specific ARM templates and account for both pre-existing network watchers (which might exist in a resource group you do not have RBAC access to) and non-preexisting situations. We strongly encourage you to enable [NSG flow logs](https://docs.microsoft.com/azure/network-watcher/network-watcher-nsg-flow-logging-overview) on your AKS Cluster subnets, build agent subnets, Azure Application Gateway, and other subnets that may be a source of traffic into and out of your cluster. Ensure you're sending your NSG Flow Logs to a **V2 Storage Account** and set your retention period in the Storage Account for these logs to a value that is at least as long as your compliance needs (e.g. 90 days).

In addition to Network Watcher aiding in compliance considerations, it's also a highly valuable network troubleshooting utility. As your network is private and heavy with flow restrictions, troubleshooting network flow issues can be time consuming. Network Watcher can help provide additional insight when other troubleshooting means are not sufficient.

If you do not have Network Watchers and NSG Flow Logs enabled on your subscription, consider doing so via Azure Policy at the Subscription or Management Group level to provide consistent naming and region selection. See the [Deploy network watcher when virtual networks are created](https://portal.azure.com/#blade/Microsoft_Azure_Policy/PolicyDetailBlade/definitionId/%2Fproviders%2FMicrosoft.Authorization%2FpolicyDefinitions%2Fa9b99dd8-06c5-4317-8629-9d86a3c6e7d9) policy combined with the [Flow logs should be enabled for every network security group](https://portal.azure.com/#blade/Microsoft_Azure_Policy/PolicyDetailBlade/definitionId/%2Fproviders%2FMicrosoft.Authorization%2FpolicyDefinitions%2F27960feb-a23c-4577-8d36-ef8b5f35e0be) policy.

## Performance Efficiency 
Your platform must achieve the goals expected by your customers, so following the base guidance offered by the Well-Architected framework will solve for that level of concern. However, from a regulated perspective the principals set forth in Well-Architected Framework have benefits beyond customer expectation.
	
### Scaling
	
Documenting how your platform adjusts to changing demand, is one component of documenting the expected runtime behavior of your environment. Auto-scaling the resources in the workload will minimize human interaction within the CDE. An added benefit of auto scaling is you're ensuring that your surface area of your workload is at its minimum at all times. Minimizing surface area presents less targets of opportunity. Likewise, if your CDE can take advantage of resources that support "scale to zero", this benefit is magnified even more.
	
### Partitioning
	
While partitioning is often a solid strategy in performance efficiency, it can also be seen as a boon to regulated workloads in a few ways.  Having discrete components allows for crisp definition of responsibility and clear application of concepts like network policies. Isolating components provides blast radius impact control on any unexpected failures or worse, system compromise.
	
### Shared-nothing architecture
	
A core principal of performance efficiency speaks to the shared-nothing architecture. While Kubernetes, by design, is a platform in and of itself -- designed to run co-located workloads, the principal still holds true. Isolation of components in your CDE will not only yield the scalability benefits detailed in Well-Architected, but also provide logical or physical boundaries between components, which allows for targeting of relevant security controls and tighter auditing capabilities of the various components.
	
### Lightweight frameworks
	
Complexity of workloads is hard to document, hard to audit. While performance is also benefited from preferring simplicity in solutions, your regulatory requirements will also benefit from the simplicity. Using a solution that has significantly more breath than is needed exposes yourself to additional surface area for attack or misuse/misconfiguration.

## Reliability
Many workloads benefit from reliability, but regulated workloads need to be predictable by their vary nature. They need to perform the way the system was intendend (documented) and needs to be explainable at all times. Hiccups in operations are contraindicates of a workload that has invested in reliability.
	
### Recovery Targets and Disaster Recovery
	
Due to the sensitive nature of the data handled in regulated workloads, recovery targets, specifically RPO, are critical to define. What is acceptable loss of CHD? Investment in reliability might only be matched by the investment in security.  Recovery efforts within the CDE are not processes that get to "skip" the PCI requirements, because it's a unexpected event. Expect failures and have a clear recovery plan for those failures that align with roles, responsibilities, and justified data access. Live-site site issues are not justification for deviating from any regulations.
	
This is especially true in full disaster recovery situation. Those events are stressful by their very nature. Having documented disaster recovery plans that still adhere to the requirements will minimize the need to document unexpected CDE or CHD access. After recovery, always review the recovery process steps to ensure no unexpected access occurred and document business justifications for any that did occur.
	
### Recovery
	
Adding resilience and recovery strategies to your architecture can prevent the need for ad-hoc access to the CDE. When the system is able to self-recover at the defined RPO without the need for direct human intervention, and done so in an auditable way, you've help eliminate unnecessary exposure of CHD, even to those individuals that are authorized to have access for situations like this.
	
### Address security-related risks
	
Beyond the general obvious potential involved with security risks, security risks can also be a source of workload downtime and data loss. The necessary investments in security will translate into workload reliability in this regard.
	
### Operational process
	
Reliability isn't just a workload runtime concern, it extends to all operational processes in and adjacent to the CDE. Well defined, automated, and tested processes for concern like image building and jumpbox management factor into a well-architected solution.

## Cost Optimization

Because of the compliance requirements and strict security controls, a clear tradeoff is cost. We recommend, that you establish initial estimates by using the [Pricing Calculator](https://azure.microsoft.com/pricing/calculator/).

Here's a high-level represenation of the cost impact of the main resources used by this architecture.

![Cost management](.\images\cost-analysis.png)

The main drivers are the AKS node pools and the underlying virtual machine scale sets and Azure Firewall. Another contributor is Log Analytics. There are also incremental costs associated with Azure Defender depending on your choice of plans.

Have a clear understanding of what constitutes the price of a service. Azure tracks metered usage. Here's a drilldown of Azure Firewall for this architecture.  

![Cost management -- Azure Firewall example](.\images\firewall-cost.png)

The cost associated with some resources, such as Azure Firewall, can be spread across multiple business units and/or applications. Another way to optimize cost might be to host a multi-tenant cluster within an organization, maximizing density with workload diversity. This approach is _not_ recommended for regulated workloads. Always prioritize compliance and segmentation over cost benefits.

There are other ways to lower costs, consider:

- Reserved instances?
<ask chad>

As you create groups of Azure resources, apply tags so that they can tracked for cost. Use cost management tools like [Azure Advisor](/azure/advisor/advisor-cost-recommendations) and [Azure Cost Management](/azure/cost-management-billing/costs/cost-mgt-best-practices) for tracking and analyzing cost. 





### Workload isolation
The main theme of the PCI standard is to isolate the PCI workload from other workloads in terms of operations and connectivity. In this series we differentiate between those concepts as:

- In-scope&mdash;The PCI workload, the environment in which it resides, and operations.

- Out-of-scope&mdash;Other workloads that may share services but are isolated from the in-scope components.

The key strategy is to provide the required level of segmentation. One way is to deploy in-scope and out-of-scope components in separate clusters. The down side is increased costs for the added infrastructure and the maintenance overhead. Another approach is to colocate all components in a shared cluster. Use segmentation strategies to maintain the separation. 

In the reference implementation, the second approach is demonstrated with a microservices application deployed to a single cluster. The application has  two sets of services; one set has in-scope pods and the other is out-of-scope. Both sets are spread across two user node pools. With the use of Kubernetes taints, in-scope and out-of-scope pods are deployed to separate nodes and they never share a node VM.




## Security Center
View considerations…
Enterprise onboarding to Security Center
The Security Center onboarding in this reference implementation is relatively simplistic. Organizations inboard in Security Center and Azure Policy typically in a more holistic and governed fashion. Review the Azure Security Center Enterprise Onboarding Guide for a complete end-to-end perspective on protecting your workloads (regulated and non) with Azure Security Center. This addresses enrollment, data exports to your SIEM or ITSM solution, Logic Apps for responding to alerts, building workflow automation, etc. All things that go beyond the base architecture of any one AKS solution, and should be addressed at the enterprise level.

Create triage process for alerts
From the Security alerts view in Azure Security Center (or via Azure Resource Graph), you have access to all alerts that Azure Security Center detects on your resources. You should have a triage process in place address or defer detected issues. Work with your security team to understand how relevant alerts will be made available to the workload owner(s).


Customer-managed OS and data disk encryption
While OS and data disks (and their caches) are already encrypted at rest with Microsoft-managed keys, for additional control over encryption keys you can use customer-managed keys for encyption at rest for both the OS and the data disks in your AKS cluster. This reference implementation doesn't actually use any disks in the cluster, and the OS disk is ephemeral. But if you use non-ephemeral OS disks or add data disks, consider using this added security solution.

Read more about Bing your own keys (BYOK) with Azure disks.

Consider using BYOK for any other disks that might be in your final solution, such as your Azure Bastion-fronted jumpboxes. Please note that your SKU choice for VMs will be limited to only those that support this feature, and regional availability will be restricted as well.

Note, we enable an Azure Policy alert detecting clusters without this feature enabled. The reference implementation will trip this policy alert because there is no diskEncryptionSetID provided on the cluster resource. The policy is in place as a reminder of this security feature that you might wish to use. The policy is set to "audit" not "block."

Host-based encryption
You can take OS and data disk encryption one step further and also bring the encryption up to the Azure host. Using Host-Based Encryption means that the temp disks now will be encrypted at rest using platform-managed keys. This will then cover encryption of the VMSS ephemeral OS disk and temp disks. Your SKU choice for VMs will be limited to only those that support this feature, and regional availability will be restricted as well. This feature is currently in preview. See more details about VM support for host-based encryption.

Note, like above, we enable an Azure Policy detecting clusters without this feature enabled. The reference implementation will trip this policy alert because this feature is not enabled on the agentPoolProfiles. The policy is in place as a reminder of this security feature that you might wish to use once it is GA. The policy is set to "audit" not "block."


Cluster Backups (State and Resources)
While we generally discourage any storage of state within a cluster, you may find your workload demands in-cluster storage. Regardless if that data is in compliance scope or not, you'll often require a robust and secure process for backup and recovery. You may find a solution like Azure Backup (for Azure Disks and Azure Files), Veeam Kasten K10, or VMware Velero instrumental in achieving any PersistantVolumeClaim backup and recovery strategies.

As a bonus, your selected backup system might also handle Kubernetes resource (Deployments, ConfigMaps, etc) snapshots/backups. While Flux may be your primary method to reconcile your cluster back to a well-known state, you may wish to supplement with a solution like this to provide alternative methods for critical system recovery techniques (when reconcile or rebuild is not an option). A tool like this can also be a key source of data for drift detection and cataloging system state changes over time; akin to how File Integrity Monitoring solves for file-system level drift detection, but at the Kubernetes resource level.

All backup process needs to classify the data contained within the backup. This is true of data both within and external to your cluster. If the data falls within regulatory scope, you'll need extend your compliance boundaries to the lifecycle and destination of the backup -- which will be outside of the cluster. Consider geographic restrictions, encryption at rest, access controls, roles and responsibilities, auditing, time-to-live, and tampering prevention (check-sums, etc) when designing your backup system. Backups can be a vector for malicious intent, with a bad actor compromising a backup and then forcing an event in which their backup is restored.

Lastly, in-cluster backup systems usually depend on begin run as highly-privileged during its operations; so consider the risk vs benefit when deciding to bring an agent like this into your cluster. Some agent's might overlap with another management solution you've brought to your cluster already for security concerns; evaluate what is the minimum set of tooling you'll need to accomplish this task and not introduce additional exposure/management into your cluster.