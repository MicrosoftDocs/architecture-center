This article compares networking modes for Azure Kubernetes Service (AKS) and Amazon Elastic Kubernetes Service (Amazon EKS). The article describes how to improve connection security to the managed API server of an AKS cluster, and the different options to restrict public network access.

[!INCLUDE [eks-aks](includes/eks-aks-include.md)]

## Amazon EKS networking modes

With [Amazon Virtual Private Cloud (Amazon VPC)](https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html), you can launch Amazon Web Services (AWS) resources into a virtual network composed of public and private [subnets](https://docs.aws.amazon.com/vpc/latest/userguide/configure-subnets.html), or ranges of IP addresses in the VPC. A public subnet hosts resources that must be connected to the internet, and a private subnet hosts resources that aren't connected to the public internet. Amazon EKS can provision managed node groups in both public and private subnets.

Endpoint access control lets you configure whether the API Server endpoint is reachable from the public internet or through the VPC. EKS provides several ways to [control access to the cluster endpoint](https://docs.aws.amazon.com/eks/latest/userguide/cluster-endpoint.html). You can enable the default public endpoint, a private endpoint, or both endpoints simultaneously. When you enable the public endpoint, you can add Classless Inter-Domain Routing (CIDR) restrictions to limit the client IP addresses that can connect to the public endpoint.

How Amazon EKS nodes connect to the managed Kubernetes control plane is determined by which endpoint setting is configured for the cluster. You can change the endpoint settings anytime through the Amazon EKS console or the API. For more information, see [Amazon EKS cluster endpoint access control](https://docs.aws.amazon.com/eks/latest/userguide/cluster-endpoint.html).

### Public endpoint only

Exposing the control plane via a public endpoint is the default mode for new Amazon EKS clusters. When only the public endpoint for the cluster is enabled, Kubernetes API requests that originate from within the Amazon VPC, such as worker node to control plane communication, leave the VPC but don't leave Amazon's network. For nodes to connect to the control plane, they must use a public IP address and a route to an internet gateway, or a route to a network address translation (NAT) gateway where they can use the NAT gateway's public IP address.

### Public and private endpoints

When both the public and private endpoints are enabled, Kubernetes API requests from within the VPC communicate to the control plane via the Amazon EKS-managed Elastic Network Interfaces (ENIs) in the VPC. The cluster API server is accessible from the internet.

### Private endpoint only

When only the private endpoint is enabled, all traffic to the cluster API server, such as `kubectl` or `helm` commands, must come from within the cluster's VPC or a [connected network](https://docs.aws.amazon.com/whitepapers/latest/aws-vpc-connectivity-options/introduction.html). Public access to the API server from the internet is disabled. You can implement this access mode by using [AWS Virtual Private Network (AWS VPN)](https://docs.aws.amazon.com/vpn/index.html) or [AWS DirectConnect](https://docs.aws.amazon.com/directconnect/latest/UserGuide/Welcome.html) to the VPC. To restrict access to the endpoint without AWS VPN or DirectConnect, you can add CIDR restrictions to the public endpoint to limit connections without setting up more networking.

If you have disabled public access for your cluster’s Kubernetes API server endpoint, you can access the Kubernetes API server endpoint in one of the following ways:

- **Connected network**: Connect your network to the VPC with an [AWS transit gateway](https://docs.aws.amazon.com/vpc/latest/tgw/what-is-transit-gateway.html) or other [connectivity options](https://docs.aws.amazon.com/aws-technical-content/latest/aws-vpc-connectivity-options/introduction.html) and then use a computer in the connected network. You must ensure that your Amazon EKS control plane security group contains rules to allow ingress traffic on port 443 from your connected network.
- **Amazon EC2 bastion host**: You can launch an Amazon EC2 instance into a public subnet in your cluster’s VPC and then log in via SSH into that instance to run `kubectl` commands. For more information, see [Linux bastion hosts on AWS](https://aws.amazon.com/quickstart/architecture/linux-bastion/). You must ensure that your Amazon EKS control plane security group contains rules to allow ingress traffic on port 443 from your bastion host. For more information, see [View Amazon EKS security group requirements for clusters](https://docs.aws.amazon.com/eks/latest/userguide/sec-group-reqs.html). When you configure `kubectl` for your bastion host, be sure to use AWS credentials that are already mapped to your cluster’s RBAC configuration, or add the [IAM principal](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html#iam-term-principal) that your bastion will use to the RBAC configuration before you remove endpoint public access. For more information, see [Grant IAM users and roles access to Kubernetes APIs](https://docs.aws.amazon.com/eks/latest/userguide/grant-k8s-access.html) and [Unauthorized or access denied (kubectl)](https://docs.aws.amazon.com/eks/latest/userguide/troubleshooting.html#unauthorized).
- **AWS Cloud9 IDE**:  AWS Cloud9 is a cloud-based integrated development environment (IDE) that lets you write, run, and debug your code with just a browser. You can create an AWS Cloud9 IDE in your cluster’s VPC and use the IDE to communicate with your cluster. For more information, see [Creating an environment in AWS Cloud9](https://docs.aws.amazon.com/cloud9/latest/user-guide/create-environment.html). You must ensure that your Amazon EKS control plane security group contains rules to allow ingress traffic on port 443 from your IDE security group. For more information, see [View Amazon EKS security group requirements for clusters](https://docs.aws.amazon.com/eks/latest/userguide/sec-group-reqs.html). When you configure `kubectl` for your AWS Cloud9 IDE, be sure to use AWS credentials that are already mapped to your cluster’s RBAC configuration, or add the IAM principal that your IDE will use to the RBAC configuration before you remove endpoint public access. For more information, see [Grant IAM users and roles access to Kubernetes APIs](https://docs.aws.amazon.com/eks/latest/userguide/grant-k8s-access.html) and [Unauthorized or access denied (kubectl)](https://docs.aws.amazon.com/eks/latest/userguide/troubleshooting.html#unauthorized).

For more information on connectivity options, see [Accessing a Private Only API Server](https://docs.aws.amazon.com/eks/latest/userguide/cluster-endpoint.html#private-access).

## AKS network access to the API server

There are two options to secure network access to the Kubernetes API in AKS, a private AKS cluster or authorized IP ranges.

### Private AKS cluster

A [private AKS cluster](/azure/aks/private-clusters) ensures that network traffic between the API server and the agent nodes remains within the virtual network. In a private AKS cluster, the control plane or API server has internal IP addresses that are defined in the [RFC1918 - Address Allocation for Private Internet](https://tools.ietf.org/html/rfc1918) document. By using a private cluster, you can ensure network traffic between your API server and your node pools remains only on the private network.

In a private AKS cluster, the API server has an internal IP address that's only accessible via an Azure [private endpoint](/azure/private-link/private-endpoint-overview) located in the same virtual network. Any virtual machine (VM) in the same virtual network can privately communicate with the control plane via this private endpoint. The control plane or API server is hosted in the Azure-managed subscription, while the AKS cluster and its node pools are in the customer's subscription.

When you provision a private AKS cluster, AKS by default creates a private FQDN with a private DNS zone and an additional public FQDN with a corresponding `A` record in Azure public DNS. The agent nodes continue to use the `A` record in the private DNS zone to resolve the private IP address of the private endpoint for communication to the API server.

The following diagram illustrates a private AKS cluster configuration.

![Diagram that shows a private AKS cluster.](./media/private-aks-cluster.png)

*Download a [Visio file](https://arch-center.azureedge.net/eks-to-aks-networking-private-cluster.vsdx) of this architecture.*

To provision a private AKS cluster, the AKS resource provider creates a private fully qualified domain name (FQDN) for the node resource group in a private DNS zone. Optionally, AKS can also create a public FQDN with a corresponding address (`A`) record in the Azure public DNS zone. The agent nodes use the `A` record in the private DNS zone to resolve the private endpoint IP address for communication to the API server.

The AKS resource provider can create the private DNS zone in the node resource group, or you can create the private DNS zone and pass its resource ID to the provisioning system. You can create a private cluster when you use [Terraform with Azure](/azure/developer/terraform/overview), [Bicep](/azure/azure-resource-manager/bicep/overview?tabs=bicep), [ARM templates](/azure/azure-resource-manager/templates/overview), [Azure CLI](/cli/azure), [Azure PowerShell module](/powershell/azure), or [Azure REST API](/rest/api/azure/) to create the cluster.

You can enable a public FQDN for the API server during provisioning or by using the [az aks update](/cli/azure/aks#az-aks-update) command with the ` --enable-public-fqdn` parameter on existing clusters. If you enable the public FQDN, any VM that accesses the server, such as an Azure DevOps self-hosted agent or a GitHub Actions self-hosted runner, must be in the same virtual network that hosts the cluster, or in a network connected via [virtual network peering](/azure/virtual-network/virtual-network-peering-overview) or [site-to-site VPN](/azure/vpn-gateway/vpn-gateway-about-vpngateways).

For a private AKS cluster, you disable the public FQDN of the API server. To communicate with the private control plane, a VM must be in the same virtual network, or in a peered virtual network with a [virtual network link](/azure/dns/private-dns-virtual-network-links) to the [private DNS zone](/azure/dns/private-dns-overview). The `A` record in the private DNS zone resolves the FQDN of the API server to the private endpoint IP address that communicates with the underlying control plane. For more information, see [Create a private Azure Kubernetes Service cluster](/azure/aks/private-clusters).

#### Private cluster deployment options

The AKS resource provider exposes the following parameters to customize private AKS cluster deployment:

- `authorizedIpRanges` (string) specifies allowed IP ranges in CIDR format.
- `disableRunCommand` (Boolean) specifies whether or not to disable the `run` command for the cluster.
- `enablePrivateCluster` (Boolean) specifies whether or not to create the cluster as private.
- `enablePrivateClusterPublicFQDN` (Boolean) specifies whether or not to create another, public FQDN for the private cluster.
- `privateDnsZone` (string) specifies a private DNS zone in the node resource group. If you don't specify a value, the resource provider creates the zone. You can specify the following values:
  - `System` is the default value.
  - `None` defaults to public DNS, so AKS doesn't create a private DNS zone.
  - `<Your own private DNS zone resource ID>` uses a private DNS zone you create in the format `privatelink.<region>.azmk8s.io` or `<subzone>.privatelink.<region>.azmk8s.io.`

The following table shows the DNS configuration options for deploying a private AKS cluster:

|**Private DNS zone options**|`enablePrivateClusterPublicFQDN: true`|`enablePrivateClusterPublicFQDN: false`|
|---|---|---|
|**System**|Agent nodes, and any other VMs in the AKS cluster virtual network or any virtual network connected to the private DNS zone, use the private DNS zone `A` record to resolve the private IP address of the private endpoint.<br><br>Any other VM uses the public FQDN of the API server.|Agent nodes, and any other VMs in the AKS cluster virtual network or any virtual network connected to the private DNS zone, use the private DNS zone `A` record to resolve the private IP address of the private endpoint.<br><br>No public API server FQDN is available.|
|**None**|All the VMs, including agent nodes, use the public FQDN of the API server available via an `A` record in an Azure-managed public DNS zone.|Wrong configuration. The private AKS cluster needs at least a public or a private DNS zone for the name resolution of the API server.|
|**Your own private DNS zone resource ID**|Agent nodes, and any other VMs in the AKS cluster virtual network or any virtual network connected to the private DNS zone, use the private DNS zone `A` record to resolve the private IP address of the private endpoint.<br><br>Any other VMs use the public FQDN of the API server.|Agent nodes, and any other VMs in the AKS cluster virtual network or any virtual network connected to the private DNS zone, use the private DNS zone `A` record to resolve the private IP address of the private endpoint.<br><br>No public API server FQDN is available.|

#### Private cluster connectivity and management

In a private AKS cluster, the API server endpoint has no public IP address. There are several options for establishing network connectivity to the private cluster:

1. Create a virtual machine in the same virtual network as the AKS cluster using the [`az vm create`](/cli/azure/vm#az-vm-create) command with the `--vnet-name` flag.
2. Use a virtual machine in a separate virtual network and set up [virtual network peering](/azure/virtual-network/virtual-network-peering-overview) with the AKS cluster virtual network.
3. Configure an [Azure ExpressRoute or VPN](/azure/expressroute/expressroute-about-virtual-network-gateways) to connect to the cluster virtual network.
4. Create an [Azure Private Endpoint](/azure/private-link/private-endpoint-overview) connection inside another virtual network.
5. Use a [Cloud Shell](https://learn.microsoft.com/en-us/azure/cloud-shell/vnet/overview) instance deployed into a subnet that's connected to the API server for the cluster.

Using the Azure CLI, you can make use of the [az aks command invoke](/cli/azure/aks/command?view=azure-cli-latest#az-aks-command-invoke) command to access private clusters without the need for configuring a VPN or Express Route. This command allows you to remotely invoke commands, such as `kubectl` and `helm`, on your private cluster through the Azure API, without having to directly connect to the cluster. To use `command invoke`, you need to have the necessary permissions set up for the `Microsoft.ContainerService/managedClusters/runcommand/action` and `Microsoft.ContainerService/managedclusters/commandResults/read` actions.

In the Azure portal, you can utilize the `Run command` feature to run commands on your private cluster. This feature actually utilizes the `command invoke` functionality to execute commands on your cluster. The pod created by the `Run command` feature provides `kubectl` and `helm` tools for managing your cluster. Additionally, it supports Bash with tools like `jq`, `xargs`, `grep`, and `awk` available.

You can use [Azure Bastion](/azure/bastion/bastion-overview) in the same virtual network or a peered virtual network to connect to a jump box management virtual machine. Azure Bastion is a fully managed platform as a service (PaaS) that lets you connect to a VM by using your browser and the Azure portal. Azure Bastion provides secure and seamless Remote Desktop Protocol (RDP) or Secure Shell (SSH) VM connectivity over Transport Layer Security (TLS) directly from the Azure portal. When VMs connect via Azure Bastion, they don't need a public IP address, agent, or special client software.

### API Server VNet Integration

An Azure Kubernetes Service (AKS) cluster configured with [API Server VNet Integration](https://techcommunity.microsoft.com/blog/fasttrackforazureblog/create-an-azure-kubernetes-service-aks-cluster-with-api-server-vnet-integration-/3644002) projects the API server endpoint directly into a delegated subnet in the VNet where AKS is deployed. API Server VNet Integration enables network communication between the API server and the cluster nodes without requiring a private link or tunnel. The API server is available behind an internal load balancer VIP in the delegated subnet, which the nodes are configured to utilize. By using API Server VNet Integration, you can ensure network traffic between your API server and your node pools remains on the private network only.

The control plane or API server is in an AKS-managed Azure subscription. Your cluster or node pool is in your Azure subscription. The server and the virtual machines that make up the cluster nodes can communicate with each other through the API server VIP and pod IPs that are projected into the delegated subnet.

API Server VNet Integration is supported for public or private clusters. You can add or remove public access after cluster provisioning. Unlike non-VNet integrated clusters, the agent nodes always communicate directly with the private IP address of the API server internal load balancer (ILB) IP without using DNS. All node to API server traffic is kept on private networking, and no tunnel is required for API server to node connectivity. Out-of-cluster clients needing to communicate with the API server can do so normally if public network access is enabled. If public network access is disabled, you should follow the same private DNS setup methodology as standard [private clusters](/azure/aks/private-clusters). For more information, see [Create an Azure Kubernetes Service cluster with API Server VNet Integration](/azure/aks/api-server-vnet-integration).

### Authorized IP ranges

The second option to improve cluster security and minimize attacks to the API server is to use [authorized IP ranges](/azure/aks/api-server-authorized-ip-ranges). Authorized IPs restrict access to the control plane of a public AKS cluster to a known list of IP addresses and CIDRs. When you use this option, the API server is still publicly exposed, but access is limited. For more information, see [Secure access to the API server using authorized IP address ranges in Azure Kubernetes Service (AKS)](/azure/aks/api-server-authorized-ip-ranges).

The following `az aks update` Azure CLI command authorizes IP ranges:

 ```azurecli-interactive
  az aks update \
      --resource-group myResourceGroup \
      --name myAKSCluster \
      --api-server-authorized-ip-ranges  73.140.245.0/24
  ```

## AKS connectivity considerations

When considering AKS connectivity, there are several important considerations to keep in mind. Here are some key points to be aware of:

- An AKS private cluster offers enhanced security and isolation compared to authorized IPs. However, it is not possible to convert an existing public AKS cluster into a private cluster. Instead, authorized IPs can be enabled for any existing AKS cluster.
- Authorized IP ranges cannot be applied to a private API server endpoint. They only apply to the public API server.
- Private clusters do not support Azure DevOps-hosted agents. It is recommended to use self-hosted agents instead.
- For Azure Container Registry to function with a private AKS cluster, a private link must be set up for the container registry in the cluster virtual network. Alternatively, peering can be established between the Container Registry virtual network and the private cluster's virtual network.
- The limitations of Azure Private Link service apply to private clusters.
- If the private endpoint in the customer subnet of a private cluster is deleted or modified, the cluster will cease to function.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Paolo Salvatori](https://www.linkedin.com/in/paolo-salvatori) | Principal Service Engineer
- [Martin Gjoshevski](https://www.linkedin.com/in/martin-gjoshevski) | Senior Service Engineer
- [Laura Nicolas](https://www.linkedin.com/in/lauranicolasd) | Senior Cloud Solution Architect

Other contributors:

- [Chad Kittel](https://www.linkedin.com/in/chadkittel) | Principal Software Engineer
- [Ed Price](https://www.linkedin.com/in/priceed) | Senior Content Program Manager
- [Theano Petersen](https://www.linkedin.com/in/theanop) | Technical Writer

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [AKS for Amazon EKS professionals](index.md)
- [Kubernetes identity and access management](workload-identity.yml)
- [Kubernetes monitoring and logging](monitoring.yml)
- [Storage options for a Kubernetes cluster](storage.md)
- [Cost management for Kubernetes](cost-management.yml)
- [Kubernetes node and node pool management](node-pools.yml)
- [Cluster governance](governance.md)

## Related resources

The following references provide links to documentation and automation samples to deploy AKS clusters with a secured API:

- [Create a Private AKS cluster with a Public DNS Zone](https://github.com/Azure/azure-quickstart-templates/tree/master/demos/private-aks-cluster-with-public-dns-zone)
- [Create a private Azure Kubernetes Service cluster using Terraform and Azure DevOps](https://github.com/azure-samples/private-aks-cluster-terraform-devops)
- [Create a public or private Azure Kubernetes Service cluster with Azure NAT Gateway and Azure Application Gateway](https://github.com/Azure-Samples/aks-nat-agic)
- [Use Private Endpoints with a Private AKS Cluster](https://github.com/azure-samples/private-aks-cluster)
- [Introduction to Azure Private Link](/learn/modules/introduction-azure-private-link/)
- [Introduction to Secure Network Infrastructure with Azure network security](/learn/paths/secure-networking-infrastructure)
