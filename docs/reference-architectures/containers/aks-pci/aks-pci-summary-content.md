
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