
The Azure Well-Architected Framework is a set of guiding tenets that can be used to assess a solution through the quality  pillars of architecture excellence: Cost Optimization, Operational Excellence, Performance Efficiency, Reliability, and Security. 

> This article is part of a series. Read the [introduction](aks-pci-intro.yml).

This guidance provided in this series incorporate Well-Architected principles in all design choices. This article summarizes those choices.  The [GitHub: Azure Kubernetes Service (AKS) Baseline Cluster for Regulated Workloads](https://github.com/mspnp/aks-baseline-regulated) implementation demonstrates those principles, as applicable. 

> [!IMPORTANT]
>
> This article is work in progress. Check back on updates.
>

## Security

In a hub and spoke topology, having separate virtual networks for each entity provides basic segmentation in the networking footprint. Each network is further segmented into subnets. 

Typical flows in and out of various network boundaries are:

- Inbound traffic to the cluster.
- Outbound traffic from the cluster.
- In-cluster traffic between pods. 

While Azure Virtual Networks (VNets) don't allow incoming traffic into the network, the resources in the network can reach out to the public internet. Consider these network controls to restrict the preceding flows:

Use Network Security Groups (NSG) to secure communication between resources within a VNet.
Use Application Security Groups (ASGs) to define traffic rules for the underlying VMs that run the workload.
Use Azure Firewall to filter traffic flowing between cloud resources, the internet, and on-premise.

As your workloads, system security agents, and other components are deployed, consider adding even more NSG rules that help define the type of traffic that should and should not be traversing those subnet boundaries. Because each nodepool lives in its own subnet, you can apply more specific rules based on known/expected traffic patterns of your workload.

### Expanded NetworkPolicies

Not all user-provided namespaces in this reference implementation use a zero-trust network. For example `cluster-baseline-settings` does not. We provide an example of zero-trust networks in `a0005-i` and `a0005-o` as your reference implementation of the concept. All namespaces (other than `kube-system`, `gatekeeper-system`, and other AKS-provided namespaces) should have a maximally restrictive NetworkPolicy applied. What those policies will be will be based on the pods running in those namespaces. Ensure your accounting for readiness, liveliness, and startup probes and also accounting for metrics gathering by `oms-agent`.  Consider standardizing on ports across your workloads so that you can provide a consistent NetworkPolicy and even Azure Policy for allowed container ports.

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

## Reliability

## Cost Optimization

### Workload isolation
The main theme of the PCI standard is to isolate the PCI workload from other workloads in terms of operations and connectivity. In this series we differentiate between those concepts as:

- In-scope&mdash;The PCI workload, the environment in which it resides, and operations.

- Out-of-scope&mdash;Other workloads that may share services but are isolated from the in-scope components.

The key strategy is to provide the required level of segmentation. One way is to deploy in-scope and out-of-scope components in separate clusters. The down side is increased costs for the added infrastructure and the maintenance overhead. Another approach is to colocate all components in a shared cluster. Use segmentation strategies to maintain the separation. 

In the reference implementation, the second approach is demonstrated with a microservices application deployed to a single cluster. The application has  two sets of services; one set has in-scope pods and the other is out-of-scope. Both sets are spread across two user node pools. With the use of Kubernetes taints, in-scope and out-of-scope pods are deployed to separate nodes and they never share a node VM.

### Management Groups
This reference implementation is expected to be deployed in a standalone subscription. As such, Azure Policies are applied at a relatively local scope (subscription or resource group). If you have multiple subscriptions that will be under regulatory compliance, consider grouping them under a management group hierarchy that applies the relevant Azure Policies uniformly across your in-scope subscriptions.


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