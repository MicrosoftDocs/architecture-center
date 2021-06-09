## Monitoring

### Enable Network Watcher and Traffic Analytics

Observability into your network is critical for compliance. [Network Watcher](https://docs.microsoft.com/azure/network-watcher/network-watcher-monitoring-overview), combined with [Traffic Analysis](https://docs.microsoft.com/azure/network-watcher/traffic-analytics) will help provide a perspective into traffic traversing your networks. This reference implementation does not deploy NSG Flow Logs or Traffic Analysis by default. These features depend on a regional Network Watcher resource being installed on your subscription. Network Watchers are singletons in a subscription, and there is no reasonable way to include them in these specific ARM templates and account for both pre-existing network watchers (which might exist in a resource group you do not have RBAC access to) and non-preexisting situations. We strongly encourage you to enable [NSG flow logs](https://docs.microsoft.com/azure/network-watcher/network-watcher-nsg-flow-logging-overview) on your AKS Cluster subnets, build agent subnets, Azure Application Gateway, and other subnets that may be a source of traffic into and out of your cluster. Ensure you're sending your NSG Flow Logs to a **V2 Storage Account** and set your retention period in the Storage Account for these logs to a value that is at least as long as your compliance needs (e.g. 90 days).

In addition to Network Watcher aiding in compliance considerations, it's also a highly valuable network troubleshooting utility. As your network is private and heavy with flow restrictions, troubleshooting network flow issues can be time consuming. Network Watcher can help provide additional insight when other troubleshooting means are not sufficient.

If you do not have Network Watchers and NSG Flow Logs enabled on your subscription, consider doing so via Azure Policy at the Subscription or Management Group level to provide consistent naming and region selection. See the [Deploy network watcher when virtual networks are created](https://portal.azure.com/#blade/Microsoft_Azure_Policy/PolicyDetailBlade/definitionId/%2Fproviders%2FMicrosoft.Authorization%2FpolicyDefinitions%2Fa9b99dd8-06c5-4317-8629-9d86a3c6e7d9) policy combined with the [Flow logs should be enabled for every network security group](https://portal.azure.com/#blade/Microsoft_Azure_Policy/PolicyDetailBlade/definitionId/%2Fproviders%2FMicrosoft.Authorization%2FpolicyDefinitions%2F27960feb-a23c-4577-8d36-ef8b5f35e0be) policy.


## Security 

### Network

In a hub and spoke topology, having separate virtual networks for each entity provides basic segmentation in the networking footprint. Each network is further segmented into subnets. 

Typical flows in and out of various network boundaries are:

- Inbound traffic to the cluster.
- Outbound traffic from the cluster.
- In-cluster traffic between pods. 

While Azure Virtual Networks (VNets) don't allow incoming traffic into the network, the resources in the network can reach out to the public internet. Consider these network controls to restrict the preceding flows:

Use Network Security Groups (NSG) to secure communication between resources within a VNet.
Use Application Security Groups (ASGs) to define traffic rules for the underlying VMs that run the workload.
Use Azure Firewall to filter traffic flowing between cloud resources, the internet, and on-premise.
Place resources in a single VNet, if you don't need to operate in multiple regions.
If you need to be in multiple regions, have multiple VNets that are connected through peering.
For advanced configurations, use a hub-spoke topology. A VNet is designated as a hub in a given region for all the other VNets as spokes in that region.
