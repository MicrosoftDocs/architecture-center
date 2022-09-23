This article compares networking modes for Azure Kubernetes Service (AKS) networking with Amazon Elastic Kubernetes Service (Amazon EKS). The article describes how to establish a secure connection to the managed API server of an AKS cluster, and the different options to restrict public network access.

> [!NOTE]
> This article is part of a [series of articles](../index.md) that helps professionals who are familiar with Amazon Elastic Kubernetes Service (Amazon EKS) to understand Azure Kubernetes Service (AKS).

## Amazon EKS networking modes

The [Amazon Virtual Private Cloud (Amazon VPC)](https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html) lets you launch Amazon Web Services (AWS0 resources into a virtual network composed of public and private subnets. A [subnet](https://docs.aws.amazon.com/vpc/latest/userguide/configure-subnets.html) is a range of IP addresses in the VPC. A public subnet hosts resources that must be connected to the internet, and a private subnet hosts resources that aren't connected to the public internet. Amazon EKS can provision managed node groups in both public and private subnets.

Endpoint access control lets you configure whether the API Server endpoint is reachable from the public internet or through your VPC. EKS provides two ways to [control access to the cluster endpoint](https://docs.aws.amazon.com/eks/latest/userguide/cluster-endpoint.html). You can enable the default public endpoint, private endpoint, or both endpoints simultaneously. When you enable public endpoint is enabled, you can add Classless Inter-Domain Routing (CIDR) restrictions to limit the client IP addresses that can connect to the public endpoint.

How Amazon EKS nodes connect to the managed Kubernetes control plane is determined by which endpoint setting is configured for the cluster. You can change the endpoint settings anytime through the Amazon EKS console or the API. For more information, see [Amazon EKS cluster endpoint access control](https://docs.aws.amazon.com/eks/latest/userguide/cluster-endpoint.html).

### Public endpoint only

Exposing the control plane via a public endpoint is the default mode for new Amazon EKS clusters. When only the public endpoint for the cluster is enabled, Kubernetes API requests that originate from within the VPC, such as worker node to control plane communication, leave the VPC but don't leave Amazon's network. For nodes to connect to the control plane, they must use a public IP address and a route to an internet gateway, or a route to a network address translation (NAT) gateway where they can use the NAT gateway's public IP address.

### Public and private endpoints

When both the public and private endpoints are enabled, Kubernetes API requests from within the VPC communicate to the control plane via the Amazon EKS-managed Elastic Network Interfaces (ENIs) in the VPC. The cluster API server is accessible from the internet.

### Private endpoint only

When only the private endpoint is enabled, all traffic to the cluster API server, such as kubectl or Helm commands, must come from within the cluster's VPC or a connected network. Public access to the API server from the internet is disabled. You can implement this access mode by using [AWS Virtual Private Network (VPN)](https://docs.aws.amazon.com/vpn/index.html) or [AWS DirectConnect](https://docs.aws.amazon.com/directconnect/latest/UserGuide/Welcome.html)DirectConnect to the VPC. To restrict access to the endpoint without AWS VPN or DirectConnect, add CIDR restrictions to the public endpoint to limit connections to the endpoint without more networking setup.

For more information on connectivity options, see [Accessing a Private Only API Server](https://docs.aws.amazon.com/eks/latest/userguide/cluster-endpoint.html#private-access).

## Network access to an AKS API server

There are two options to secure network access to the Kubernetes API in AKS, a private AKS cluster or authorized IP ranges.

### Private AKS cluster

A private AKS cluster ensures that network traffic between your API server and your node pools remains within your virtual network. In a private AKS cluster, the control plane or API server has an internal IP address only accessible via an [Azure Private Endpoint](/azure/private-link/private-endpoint-overview) located in the same virtual network as the AKS cluster. Any virtual machine (VM) in the same virtual network can privately communicate with the control plane via the private endpoint.

The control plane or API server is hosted in the Azure-managed subscription, while the AKS cluster and its node pools are in the customer's subscription.

![Diagram that shows a private AKS cluster.](./media/private-aks-cluster.png)

When you provision a private AKS cluster, the AKS resource provider creates a private fully-qualified domain name (FQDN) within the node resource group with a private DNS zone, and another public FQDN with a corresponding A record in the Azure public DNS zone. The agent nodes use the A record in the private DNS zone to resolve the private IP address of the private endpoint for communication to the API server. The AKS resource provider can create the private DNS Zone in your cluster's node resource group, or you can create your own private DNS zone and pass its resource id to the provisioning system. You can use [Terraform with Azure](/azure/developer/terraform/overview), [Bicep](/azure/azure-resource-manager/bicep/overview?tabs=bicep), [ARM templates](/azure/azure-resource-manager/templates/overview), [Azure CLI](/cli/azure/), [Azure PowerShell module](/powershell/azure/?view=azps-7.3.0), or [Azure REST API](/rest/api/azure/) to create the cluster.

You enable the public FQDN of the API server by using the [az aks update --enable-public-fqdn](/cli/azure/aks#az-aks-update) command. If you enable the public FQDN, you need to provision any VM that needs access to the API server, such as an Azure DevOps self-hosted agent or a GitHub Actions self-hosted runner, in the same virtual network that hosts the cluster, or in a network connected via [virtual network peering](/azure/virtual-network/virtual-network-peering-overview) or [site-to-site VPN](/azure/vpn-gateway/vpn-gateway-about-vpngateways).

If you disable the public FQDN of the API server to communicate with the private control plane, a VM must be in the same virtual network that hosts the cluster, or in any peered virtual network with a [virtual network link](/azure/dns/private-dns-virtual-network-links) to the [private DNS zone](/azure/dns/private-dns-overview) of the private AKS cluster. The private DNS zone contains an A record that resolves the FQDN of the API server to the private IP address of the private endpoint that communicates with the underlying control plane. For more information, see [AKS Private Cluster](/azure/aks/private-clusters).

You can use the following parameters exposed by the AKS resource provider to customize the deployment of a private AKS cluster:

- `authorizedIpRanges` (string) specifies allowed IP ranges in CIDR format.
- `disableRunCommand` (bool) specifies whether or not to disable the run command for the cluster.
- `enablePrivateCluster` (bool) specifies whether or not to create the cluster as private.
- `enablePrivateClusterPublicFQDN` (bool) specifies whether or not to create an additional public FQDN for a private cluster.
- `privateDnsZone` (string):
  - `system`is the default value. If omitted, the AKS resource type will create a private DNS zone in the node resource group.
  - `None` defaults to public DNS, which means AKS won't create a private DNS zone.
  - `BYO Private DNS Zone resource ID` means you must create a private DNS zone in the format `privatelink.<region>.azmk8s.io` or `<subzone>.privatelink.<region>.azmk8s.io.`

The following table shows the DNS configuration options you can adopt when deploying a private AKS cluster:

|**Private DNS options**|enablePrivateClusterPublicFQDN: true|enablePrivateClusterPublicFQDN: false|
|---|---|---|
|**privateDnsZone: system**|Agent nodes, and any other VMs in the AKS cluster virtual network or in any connected virtual network with a virtual network link with the private DNS zone, use the A record in the private DNS zone to resolve the private IP address of the private endpoint.<br><br>Any other VM uses the public FQDN of the API server.|Agent nodes, and any other VMs in the AKS cluster virtual network or in any connected virtual network use the A record in the private DNS zone to resolve the private IP address of the private endpoint.<br><br>No public API server FQDN is available.|
|**privateDnsZone: BYO Private DNS Zone resource ID**|Agent nodes, and any other VMs in the AKS cluster virtual network or in any connected virtual network use the A record in the private DNS zone to resolve the private IP address of the private endpoint.<br><br>Any other VMs use the public FQDN of the API server.|Agent nodes, and any other VMs in the AKS cluster virtual network or in any connected virtual network with a virtual network link with the private DNS zone, use the A record in the private DNS zone to resolve the private IP address of the private endpoint.<br><br>No public API server FQDN is available.|
|**privateDnsZone: none**|All the VMs, including agent nodes, use the public FQDN of the API server available via an A record in an Azure-managed public DNS zone.|Wrong configuration. The private AKS cluster needs at least a public or a private DNS zone for the name resolution of the API server.|

As mentioned in the previous section, there are several options for establishing network connectivity to the private cluster.

- Create a virtual machine in the same Azure Virtual Network (VNET) as the AKS cluster.
- Use a virtual machine in a separate network and set up [virtual network peering](/azure/virtual-network/virtual-network-peering-overview) with the AKS cluster virtual network.
- Use an [Azure Express Route or VPN](/azure/expressroute/expressroute-about-virtual-network-gateways) connection.
- Use the [az aks command invoke](/azure/aks/command-invoke) Azure CLI command.
- Use an [Azure Private Endpoint](/azure/private-link/private-endpoint-overview) connection.

You can manage a private AKS cluster by using the [kubectl](https://kubernetes.io/docs/reference/kubectl/overview/) command-line tool from a management VM in the same virtual network as the cluster or a peered virtual network.

You can also use [Azure Bastion](/azure/bastion/bastion-overview) in the same virtual network or a peered virtual network to connect to the jumpbox VM you use to administer and control the cluster. Azure Bastion is a fully managed platform as a service (PaaS) that lets you connect to a VM by using your browser and the Azure portal. The Azure Bastion service provides secure and seamless remote desktop protocol (RDP) or secure shell (SSH) connectivity to your VMs directly from the Azure portal over transport layer security (TLS). When you connect via Azure Bastion, VMs don't need a public IP address, agent, or special client software.

You can also use [az aks command invoke](/cli/azure/aks/command?view=azure-cli-latest#az-aks-command-invoke) to run a kubectl or Helm shell command on your private AKS cluster, without having to connect to a jumpbox VM.

### Authorized IP ranges

The second option to improve cluster security and minimize attacks to the API server is using [authorized IPs](/azure/aks/api-server-authorized-ip-ranges). Authorized IPs restrict access to the control plane of a public AKS cluster to a known list of IP addresses and CIDRs. When using this option, the API server is still publicly exposed, but access is limited to a set of IP ranges. For more information, see [Secure access to the API server using authorized IP address ranges in Azure Kubernetes Service (AKS)](/azure/aks/api-server-authorized-ip-ranges).

An [AKS private cluster](/azure/aks/private-clusters) provides higher security and isolation for [authorized IPs](/azure/aks/api-server-authorized-ip-ranges). However, you can't convert an existing public AKS cluster into a private cluster. You can enable authorized IPs for any existing AKS cluster. The following `az aks update` Azure CLI command authorizes IP ranges:

 ```azurecli-interactive
  az aks update \
      --resource-group myResourceGroup \
      --name myAKSCluster \
      --api-server-authorized-ip-ranges  73.140.245.0/24
  ```

## AKS connectivity considerations

- You can't apply authorized IP ranges to a private API server endpoint. Authorized IPs apply only to the public API server.
- Azure Private Link service limitations apply to private clusters.
- Private clusters don't support Azure DevOps Microsoft-hosted agents. Consider using self-hosted agents.
- To enable Azure Container Registry to work with a private AKS cluster, set up a private link for the container registry in the cluster virtual network, or set up peering between the Container Registry virtual network and the private cluster's virtual network.
- You can't convert an existing public AKS cluster into a private cluster.
- If you delete or modify the private endpoint in the customer subnet, the cluster stops functioning.

## Next steps

> [!div class="nextstepaction"]
> [Kubernetes storage options](storage.md)

The following references provide links to documentation and automation samples to deploy AKS clusters with a secured API:

- [Create a Private AKS cluster with a Public DNS Zone](https://github.com/Azure/azure-quickstart-templates/tree/master/demos/private-aks-cluster-with-public-dns-zone)
- [Create a private Azure Kubernetes Service cluster using Terraform and Azure DevOps](https://github.com/azure-samples/private-aks-cluster-terraform-devops)
- [Create a public or private Azure Kubernetes Service cluster with Azure NAT Gateway and Azure Application Gateway](https://github.com/Azure-Samples/aks-nat-agic)
- [Use Private Endpoints with a Private AKS Cluster](https://github.com/azure-samples/private-aks-cluster)
- [Introduction to Azure Private Link](/learn/modules/introduction-azure-private-link/)
- [Introduction to Secure Network Infrastructure with Azure network security](/learn/paths/secure-networking-infrastructure)
