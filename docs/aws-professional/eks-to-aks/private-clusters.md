---
title: Enhance Network Access Security to Kubernetes
description: Understand networking options to help securely access the Kubernetes API server, and compare options in Amazon EKS and Azure Kubernetes Service (AKS).
author: francisnazareth
ms.author: fnazaret
ms.date: 01/28/2025
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom:
  - arb-containers
ms.collection:
  - migration
  - aws-to-azure
---

# Enhance network access security to Kubernetes

This article compares networking modes for Azure Kubernetes Service (AKS) and Amazon Elastic Kubernetes Service (EKS). It describes how to improve connection security to the managed API server of an AKS cluster. It also includes options to restrict public network access.

[!INCLUDE [eks-aks](includes/eks-aks-include.md)]

## Amazon EKS networking modes

You can use [Amazon Virtual Private Cloud (VPC)](https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html) to launch Amazon Web Services (AWS) resources into a virtual network that has public and private [subnets](https://docs.aws.amazon.com/vpc/latest/userguide/configure-subnets.html). The subnets are ranges of IP addresses within the VPC. A public subnet hosts resources that connect to the internet. A private subnet hosts resources that don't connect to the public internet. Amazon EKS can provision managed node groups in both public and private subnets.

Endpoint access control lets you configure whether the API server endpoint is reachable from the public internet or through the VPC. Amazon EKS provides several ways to [control access to the cluster endpoint](https://docs.aws.amazon.com/eks/latest/userguide/cluster-endpoint.html). You can enable the default public endpoint, a private endpoint, or both endpoints simultaneously. When you enable the public endpoint, you can add Classless Inter-Domain Routing (CIDR) restrictions to limit the client IP addresses that can connect to the public endpoint.

The cluster's endpoint setting determines how Amazon EKS nodes connect to the managed Kubernetes control plane. You can change the endpoint settings through the Amazon EKS console or the API. For more information, see [Amazon EKS cluster endpoint access control](https://docs.aws.amazon.com/eks/latest/userguide/cluster-endpoint.html).

### Public endpoint only

The default mode for new Amazon EKS clusters exposes the control plane via a public endpoint. When only the public endpoint for the cluster is enabled, Kubernetes API requests that originate from within the VPC leave the VPC but don't leave Amazon's network. These requests include communication from the worker node to the control plane. Nodes connect to the control plane via a public IP address and a route to an internet gateway. Or they can use a route to a network address translation (NAT) gateway, where they can use the NAT gateway's public IP address.

### Public and private endpoints

When you enable both the public and private endpoints, Kubernetes API requests from within the VPC communicate to the control plane via the Amazon EKS-managed elastic network interfaces (ENIs) in the VPC. The cluster API server is reachable from the internet.

### Private endpoint only

When you enable only the private endpoint, all traffic to the cluster API server, such as `kubectl` or `helm` commands, must come from within the cluster's VPC or a [connected network](https://docs.aws.amazon.com/whitepapers/latest/aws-vpc-connectivity-options/introduction.html). Public access to the API server from the internet is disabled. To implement this access mode, use [AWS Virtual Private Network (VPN)](https://docs.aws.amazon.com/vpn/index.html) or [AWS DirectConnect](https://docs.aws.amazon.com/directconnect/latest/UserGuide/Welcome.html) to the VPC. To restrict access to the endpoint without AWS VPN or DirectConnect, you can add CIDR restrictions to the public endpoint to limit connections without setting up more networking.

If you disable public access for your cluster's Kubernetes API server endpoint, you can access the Kubernetes API server endpoint in one of the following ways:

- **Connected network:** Connect your network to the VPC by using an [AWS transit gateway](https://docs.aws.amazon.com/vpc/latest/tgw/what-is-transit-gateway.html), and then use a computer in the connected network. Or you can use other [connectivity options](https://docs.aws.amazon.com/aws-technical-content/latest/aws-vpc-connectivity-options/introduction.html). Ensure that your Amazon EKS control plane security group contains rules to allow ingress traffic on port 443 from your connected network.

- **Amazon EC2 bastion host:** You can launch an Amazon EC2 instance in a public subnet in your cluster's VPC. Sign in to that instance via Secure Shell (SSH) to run `kubectl` commands. Ensure that your Amazon EKS control plane security group contains rules to allow ingress traffic on port 443 from your bastion host. For more information, see [View Amazon EKS security group requirements for clusters](https://docs.aws.amazon.com/eks/latest/userguide/sec-group-reqs.html). <br><br> When you configure `kubectl` for your bastion host, use AWS credentials that map to your cluster's role-based access control (RBAC) configuration. Or you can add the [AWS Identity and Access Management (IAM) principal](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html#iam-term-principal) that your bastion uses to the RBAC configuration before you remove endpoint public access. For more information, see [Grant IAM users and roles access to Kubernetes APIs](https://docs.aws.amazon.com/eks/latest/userguide/grant-k8s-access.html) and [Unauthorized or access denied (kubectl)](https://docs.aws.amazon.com/eks/latest/userguide/troubleshooting.html#unauthorized).
- **AWS Cloud9 IDE:**  AWS Cloud9 is a cloud-based integrated development environment (IDE) that you can use to write, run, and debug your code with a browser only. You can create an AWS Cloud9 IDE in your cluster's VPC and use the IDE to communicate with your cluster. For more information, see [Create an environment in AWS Cloud9](https://docs.aws.amazon.com/cloud9/latest/user-guide/create-environment.html). Ensure that your Amazon EKS control plane security group contains rules to allow ingress traffic on port 443 from your IDE security group. For more information, see [View Amazon EKS security group requirements for clusters](https://docs.aws.amazon.com/eks/latest/userguide/sec-group-reqs.html). <br><br> When you configure `kubectl` for your AWS Cloud9 IDE, use AWS credentials that map to your cluster's RBAC configuration. Or you can add the IAM principal that your IDE uses to the RBAC configuration before you remove endpoint public access. For more information, see [Grant IAM users and roles access to Kubernetes APIs](https://docs.aws.amazon.com/eks/latest/userguide/grant-k8s-access.html) and [Unauthorized or access denied (kubectl)](https://docs.aws.amazon.com/eks/latest/userguide/troubleshooting.html#unauthorized).

For more information about connectivity options, see [Access a private-only API server](https://docs.aws.amazon.com/eks/latest/userguide/cluster-endpoint.html#private-access).

## AKS network access to the API server

To secure network access to the Kubernetes API in AKS, you can use a private AKS cluster or authorized IP address ranges.

### Private AKS cluster

A [private AKS cluster](/azure/aks/private-clusters) helps ensure that network traffic between the API server and the agent nodes remains within the virtual network. In a private AKS cluster, the control plane or API server has [internal IP addresses](https://tools.ietf.org/html/rfc1918). A private cluster helps ensure that network traffic between your API server and your node pools remains only on the private network.

In a private AKS cluster, the API server has an internal IP address that's only reachable via an Azure [private endpoint](/azure/private-link/private-endpoint-overview) that's located in the same virtual network. Virtual machines (VMs) in the same virtual network can privately communicate with the control plane via this private endpoint. The control plane or API server is hosted in the Azure-managed subscription. The AKS cluster and its node pools are in the customer's subscription.

The following diagram shows a private AKS cluster configuration.

:::image type="complex" source="./media/private-cluster.svg" border="false" lightbox="./media/private-cluster.svg" alt-text="Diagram that shows a private AKS cluster configuration.":::
The main section of the diagram is labeled Microsoft global network. All components are in this section except on-premises DNS, which is in the on-premises network. The Azure region has two Azure internal DNS resolvers. The first resolver has a DNS subnet, gateway subnet, and firewall subnet. These components are within a hub virtual network. The bind conditional forwarder in the DNS subnet has ingoing and outgoing arrows to the on-premises DNS. The firewall subnet connects to the public internet. The second resolver has a cluster subnet that consists of a private endpoint and node pool. These components are in a spoke virtual network. The private endpoint connects to an external API server or primary server. Private DNS zone connects to both resolvers via a linked virtual network. Virtual network peering goes from the resolver that has the cluster subnet to the other resolver. Azure ExpressRoute is associated with the gateway subnet and the on-premises network.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/eks-to-aks-networking-private-cluster.vsdx) of this architecture.*

To provision a private AKS cluster, the AKS resource provider creates a private fully qualified domain name (FQDN) for the node resource group in a private Domain Name System (DNS) zone. Optionally, AKS can also create a public FQDN that has a corresponding address `A` record in the Azure public DNS zone. The agent nodes use the `A` record in the private DNS zone to resolve the private endpoint IP address for communication to the API server.

The AKS resource provider can create the private DNS zone in the node resource group, or you can create the private DNS zone and pass its resource ID to the provisioning system. To create a private cluster, you can use [Terraform with Azure](/azure/developer/terraform/overview), [Bicep](/azure/azure-resource-manager/bicep/overview), [Azure Resource Manager templates](/azure/azure-resource-manager/templates/overview), the [Azure CLI](/cli/azure), the [Azure PowerShell module](/powershell/azure), or the [Azure REST API](/rest/api/azure/).

You can enable a public FQDN for the API server during provisioning or by using the [az aks update](/cli/azure/aks#az-aks-update) command with the ` --enable-public-fqdn` parameter on existing clusters. If you enable the public FQDN, VMs that access the server must be in the same virtual network that hosts the cluster or in a network that's connected via [virtual network peering](/azure/virtual-network/virtual-network-peering-overview) or [site-to-site VPN](/azure/vpn-gateway/vpn-gateway-about-vpngateways). Examples of these VMs include an Azure DevOps self-hosted agent or a GitHub Actions self-hosted runner.

For a private AKS cluster, disable the public FQDN of the API server. To communicate with the private control plane, a VM must be in the same virtual network or in a peered virtual network that has a [virtual network link](/azure/dns/private-dns-virtual-network-links) to the [private DNS zone](/azure/dns/private-dns-overview). The `A` record in the private DNS zone resolves the FQDN of the API server to the private endpoint IP address that communicates with the underlying control plane. For more information, see [Create a private AKS cluster](/azure/aks/private-clusters).

#### Private cluster deployment options

The AKS resource provider exposes the following parameters to customize private AKS cluster deployments:

- The `authorizedIpRanges` string specifies allowed IP address ranges in CIDR format.

- The `disableRunCommand` Boolean specifies whether to disable the `run` command for the cluster.
- The `enablePrivateCluster` Boolean specifies whether to create the cluster as private.
- The `enablePrivateClusterPublicFQDN` Boolean specifies whether to create another public FQDN for the private cluster.
- The `privateDnsZone` string specifies a private DNS zone in the node resource group. If you don't specify a value, the resource provider creates the zone. You can specify the following values:
  - `System` is the default value.

  - `None` defaults to public DNS, so AKS doesn't create a private DNS zone.
  - `<Your own private DNS zone resource ID>` uses a private DNS zone that you create in the format `privatelink.<region>.azmk8s.io` or `<subzone>.privatelink.<region>.azmk8s.io`.

The following table shows the DNS configuration options to deploy a private AKS cluster:

|**Private DNS zone options**|`enablePrivateClusterPublicFQDN: true`|`enablePrivateClusterPublicFQDN: false`|
|---|---|---|
|**System**|Agent nodes, and any other VMs in the AKS cluster virtual network or in any virtual network that's connected to the private DNS zone, use the private DNS zone `A` record to resolve the private IP address of the private endpoint.<br><br>Other VMs use the public FQDN of the API server.|Agent nodes, and any other VMs in the AKS cluster virtual network or in any virtual network that's connected to the private DNS zone, use the private DNS zone `A` record to resolve the private IP address of the private endpoint.<br><br>No public API server FQDN is available.|
|**None**|All VMs, including agent nodes, use the public FQDN of the API server via an `A` record in an Azure-managed public DNS zone.|Wrong configuration. The private AKS cluster needs at least a public or a private DNS zone for the name resolution of the API server.|
|**Your own private DNS zone resource ID**|Agent nodes, and any other VMs in the AKS cluster virtual network or in any virtual network that's connected to the private DNS zone, use the private DNS zone `A` record to resolve the private IP address of the private endpoint.<br><br>Other VMs use the public FQDN of the API server.|Agent nodes, and any other VMs in the AKS cluster virtual network or in any virtual network that's connected to the private DNS zone, use the private DNS zone `A` record to resolve the private IP address of the private endpoint.<br><br>No public API server FQDN is available.|

#### Private cluster connectivity and management

In a private AKS cluster, the API server endpoint has no public IP address. You can use one of the following options to establish network connectivity to the private cluster:

- Create a VM in the same virtual network as the AKS cluster that uses the [`az vm create`](/cli/azure/vm#az-vm-create) command with the `--vnet-name` flag.

- Use a VM in a separate virtual network, and set up [virtual network peering](/azure/virtual-network/virtual-network-peering-overview) with the AKS cluster virtual network.
- Configure an [Azure ExpressRoute or VPN gateway](/azure/expressroute/expressroute-about-virtual-network-gateways) to connect to the cluster virtual network.
- Create an [Azure private endpoint](/azure/private-link/private-endpoint-overview) connection inside another virtual network.
- Use an [Azure Cloud Shell](/azure/cloud-shell/vnet/overview) instance that's deployed in a subnet that's connected to the API server for the cluster.

Use the Azure CLI to run the [az aks command invoke](/cli/azure/aks/command#az-aks-command-invoke) command to access private clusters without configuring a VPN or ExpressRoute gateway. Use this command to remotely invoke other commands, such as `kubectl` and `helm`, on your private cluster through the Azure API, without directly connecting to the cluster. To use `command invoke`, set up the necessary permissions for the `Microsoft.ContainerService/managedClusters/runcommand/action` and `Microsoft.ContainerService/managedclusters/commandResults/read` actions.

In the Azure portal, you can use the `Run command` feature to run commands on your private cluster. This feature employs the `command invoke` functionality to run commands on your cluster. The pod that the `Run command` feature creates provides `kubectl` and `helm` tools to manage your cluster. The `Run command` also provides a Bash environment within the pod that includes tools like `jq`, `xargs`, `grep`, and `awk`.

You can use [Azure Bastion](/azure/bastion/bastion-overview) in the same virtual network or a peered virtual network to connect to a jump box management VM. Azure Bastion is a fully managed platform as a service (PaaS) that you can use to connect to a VM via your browser and the Azure portal. Azure Bastion provides Remote Desktop Protocol (RDP) or SSH VM connectivity over Transport Layer Security (TLS) directly from the Azure portal. When VMs connect via Azure Bastion, they don't need a public IP address, agent, or special client software.

### API Server VNet Integration

An AKS cluster that's configured with [API Server VNet Integration](https://techcommunity.microsoft.com/blog/fasttrackforazureblog/create-an-azure-kubernetes-service-aks-cluster-with-api-server-vnet-integration-/3644002) projects the API server endpoint directly into a delegated subnet. The subnet is in the virtual network where AKS is deployed. API Server VNet Integration enables network communication between the API server and the cluster nodes, without a private link or tunnel. The API server is available behind an internal load balancer VIP that's in the delegated subnet. The nodes are configured to use the internal load balancer VIP. Use API Server VNet Integration to ensure that network traffic between your API server and your node pools remains on the private network only.

The control plane or API server is in an AKS-managed Azure subscription. Your cluster or node pool is in your Azure subscription. The server and the VMs that make up the cluster nodes can communicate with each other through the API server VIP and pod IP addresses that are projected into the delegated subnet.

You can use API Server VNet Integration with public clusters and private clusters. You can add or remove public access after cluster provisioning. Unlike clusters that don't have virtual network integration, the agent nodes always communicate directly with the private IP address of the API server internal load balancer IP without using DNS. Traffic that goes from the node to the API server traffic is on private networking. And API server-to-node connectivity doesn't require a tunnel. Out-of-cluster clients can communicate with the API server normally if public network access is enabled. If public network access is disabled, follow the same private DNS setup methodology as standard [private clusters](/azure/aks/private-clusters). For more information, see [Create an AKS cluster with API Server VNet Integration](/azure/aks/api-server-vnet-integration).

### Authorized IP address ranges

You can also use [authorized IP address ranges](/azure/aks/api-server-authorized-ip-ranges) to improve cluster security and minimize attacks to the API server. Authorized IP address ranges restrict access to the control plane of a public AKS cluster to a known list of IP addresses and CIDRs. When you use this option, the API server is still publicly exposed, but access is limited.

The following `az aks update` Azure CLI command authorizes IP address ranges:

 ```azurecli-interactive
  az aks update \
      --resource-group myResourceGroup \
      --name myAKSCluster \
      --api-server-authorized-ip-ranges  73.140.245.0/24
  ```

## AKS connectivity considerations

Consider the following key points for AKS connectivity:

- An AKS private cluster provides enhanced security and isolation compared to authorized IP address ranges. However, you can't convert an existing public AKS cluster to a private cluster. Instead, you can enable authorized IP address ranges for any existing AKS cluster.

- You can't apply authorized IP address ranges to a private API server endpoint. They only apply to the public API server.
- Private clusters don't support Azure DevOps-hosted agents. You should use self-hosted agents instead.
- For Azure Container Registry to function with a private AKS cluster, you must set up a private link for the container registry in the cluster virtual network. Alternatively, you can establish peering between the Container Registry virtual network and the private cluster's virtual network.
- The limitations of Azure Private Link apply to private clusters.
- If the private endpoint in the customer subnet of a private cluster is deleted or modified, the cluster stops functioning.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Paolo Salvatori](https://www.linkedin.com/in/paolo-salvatori/) | Principal Service Engineer
- [Martin Gjoshevski](https://www.linkedin.com/in/martin-gjoshevski/) | Senior Service Engineer
- [Laura Nicolas](https://www.linkedin.com/in/lauranicolasd/) | Senior Cloud Solution Architect

Other contributors:

- [Chad Kittel](https://www.linkedin.com/in/chadkittel/) | Principal Software Engineer - Azure Patterns & Practices
- [Ed Price](https://www.linkedin.com/in/priceed/) | Senior Content Program Manager
- [Theano Petersen](https://www.linkedin.com/in/theanop/) | Technical Writer

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Create a private AKS cluster with a public DNS zone](https://github.com/Azure/azure-quickstart-templates/tree/master/demos/private-aks-cluster-with-public-dns-zone)
- [Use Azure Firewall to help protect an AKS cluster](../../guide/aks/aks-firewall.yml)
- [Training: Introduction to Private Link](/learn/modules/introduction-azure-private-link/)
- [Training: Introduction to secure network infrastructure with Azure network security](/learn/paths/secure-networking-infrastructure)

## Related resources

- [AKS for Amazon EKS professionals](index.md)
- [Kubernetes identity and access management](workload-identity.md)
- [Kubernetes monitoring and logging](monitoring.md)
- [Storage options for a Kubernetes cluster](storage.md)
- [Cost management for Kubernetes](cost-management.md)
- [Kubernetes node and node pool management](node-pools.md)
- [Cluster governance](governance.md)
