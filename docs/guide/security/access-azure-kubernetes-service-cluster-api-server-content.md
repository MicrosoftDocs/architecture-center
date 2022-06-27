This guide describes various options for connecting to the API server of your Azure Kubernetes Service (AKS) cluster or private AKS cluster. In the general case, the API server of an AKS cluster is exposed over the internet. With a private AKS cluster, you can only connect to the API server from a device that has network connectivity to that private AKS cluster. Planning access to your API server is a day-zero activity. How you choose to access the API server depends on your deployment scenario.

## AKS API server access

To manage an AKS cluster, you interact with its API server. It's critical to lock down access to the API server and only grant access to those who need it. You can provide granular access by integrating your AKS cluster with Azure Active Directory (Azure AD). Administrators can then use role-based access control (RBAC) to restrict access. Through RBAC, administrators can place users and identities in Azure AD groups and assign appropriate roles and permissions to the groups. Azure AD authentication is provided to AKS clusters with OpenID Connect. For more information, see [AKS-managed Azure Active Directory integration](https://docs.microsoft.com/en-us/azure/aks/managed-aad) or [Integrate Azure Active Directory for the cluster](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/containers/aks/secure-baseline-aks#integrate-azure-active-directory-for-the-cluster).

> [!NOTE]
> You can further lock down your AKS cluster by only allowing authorized IP address ranges to communicate with the API Server. For more information, see [Secure access to the API server using authorized IP address ranges in Azure Kubernetes Service (AKS)](https://docs.microsoft.com/en-us/azure/aks/api-server-authorized-ip-ranges).

## Access the AKS cluster over the internet

When you create a non-private cluster that resolves to the API server's fully qualified domain name (FQDN), the API server is assigned a public IP address by default. You can then use the Azure portal to connect to your cluster, or you can use a shell like the Azure CLI, PowerShell, or Command Prompt.

> [!NOTE]
> For detailed information about using the Kubernetes command-line client `kubectl` to connect to a cluster over the internet, see [Connect to the cluster](https://docs.microsoft.com/en-us/azure/aks/learn/quick-kubernetes-deploy-cli#connect-to-the-cluster).

## Azure Cloud Shell

Azure Cloud Shell is a shell that's built into the Azure portal. You can manage and connect to Azure resources from Cloud Shell the same way you would from PowerShell or the Azure CLI. For more information, see [Azure Cloud Shell](https://docs.microsoft.com/en-us/azure/cloud-shell/overview).

## Access an AKS private cluster

There are many ways to connect to an AKS private cluster. Planning how to access your AKS private cluster is a day-zero activity that depends on your scenario's needs and limitations. You can connect to your private cluster by using:

- A jumpbox. You can deploy a jumpbox into a subnet and use it as your on-premises workstation. As your jumpbox, you can use [stand-alone, persistent VMs](https://docs.microsoft.com/en-us/azure/virtual-machines/dedicated-hosts) in an [availability set](https://docs.microsoft.com/en-us/azure/virtual-machines/availability-set-overview). You can also use [Azure Virtual Machine Scale Sets](https://docs.microsoft.com/en-us/azure/virtual-machine-scale-sets/overview).
- [Azure Bastion](https://docs.microsoft.com/en-us/azure/bastion/bastion-overview).
- A [virtual private network (VPN)](https://docs.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-about-vpngateways).
- [Azure ExpressRoute](https://docs.microsoft.com/en-us/azure/expressroute/expressroute-introduction).
- The Azure CLI [aks command invoke](https://docs.microsoft.com/en-us/azure/aks/command-invoke#limitations) command for managing AKS.
- A [Cloud Shell](https://docs.microsoft.com/en-us/azure/cloud-shell/private-vnet) instance that's deployed into a subnet that has connectivity to the cluster's API server.
- [Azure Virtual Desktop](https://docs.microsoft.com/en-us/azure/virtual-desktop/overview)
- Azure Container Instances and an [OpenSSH](https://docs.linuxserver.io/images/docker-openssh-server)-compatible SSH client.

> [!NOTE]
> Secure Shell Protocol (SSH), Remote Desktop Protocol (RDP), and Remote Desktop Services (RDS) are alternative protocols that you can use to remotely control jumpboxes.

## Azure Bastion

Azure Bastion is a platform as a service (PaaS) service that you deploy within your virtual network to connect to a VM in that network, such as a jumpbox. To connect, you use RDP or SSH from a browser within the Azure portal. The Transport Layer Security (TLS) protocol protects the connection. Usually there's a public IP address that's associated with the VM's network interface card. That address provides a way to connect to the VM. When you use Azure Bastion, you no longer need to associate a public IP address with your jumpbox.

When you connect to your AKS cluster's API server, it's best to use a trusted connection. One option is using Bastion to connect to a jumpbox that's inside your Azure environment. In this scenario, the jumpbox resides in the hub virtual network. The private AKS cluster resides in a spoke virtual network. A virtual network peering connects the hub and spoke networks. The jumpbox can resolve the API server's FQDN by using Azure Private Endpoint, a private DNS zone, and a DNS A record inside the private DNS zone. The AKS private cluster and the private endpoint ensure the API server FQDN can only be resolved from within your virtual network. Private clusters require that the browser runs on a machine that has access to the AKS private cluster's virtual network. For more information, see [Azure Bastion with AKS](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/containers/aks/secure-baseline-aks#subnet-to-host-azure-bastion).

> [!NOTE]
> The availability and redundancy of your jumpbox is critical. You should always be able to reach your jumpbox. Likewise, you should always be able to reach your private AKS cluster. To achieve availability and redundancy for your jumpboxes, put them in availability sets and use Virtual Machine Scale Sets with a small number of VM instances. For more information, see [Availability sets](https://docs.microsoft.com/en-us/azure/virtual-machines/availability-set-overview) and [Virtual Machine Scale Sets](https://docs.microsoft.com/en-us/azure/virtual-machine-scale-sets/overview).

### Dataflow

1. A user attempts to connect to a jumpbox by using Azure Bastion and an HTML5 browser with TLS encryption.
1. The user chooses from the portal whether to use RDP or SSH to connect to the jumpbox.
1. The user signs in to the jumpbox through Azure Bastion. The attempt to connect to the AKS private cluster is made from this jumpbox. The hub virtual network has a virtual network link to the AKS private DNS zone to resolve the FQDN of the private cluster.
1. The hub virtual network and the spoke virtual network communicate with each other by using a virtual network peering.
1. To reach the private AKS cluster, the traffic enters the Azure backbone. A private endpoint establishes a private, isolated connection to the private AKS cluster.
1. The traffic reaches the API server of the private AKS cluster. The user can manage pods, nodes, and applications.

> [!NOTE]
> The FQDN of your private cluster is still resolvable from outside your virtual network if you don't explicitly disable the public FQDN. For information about disabling the public FQDN of your AKS private cluster, see [Disable public FQDN on an existing cluster](https://docs.microsoft.com/en-us/azure/aks/private-clusters#disable-public-fqdn-on-an-existing-cluster).

If you can't connect to your private cluster, check the following parts of your environment:

- The virtual network peering. This mechanism provides network-to-network connectivity between two virtual networks. For traffic to flow between those two networks, you need to successfully establish the virtual network peering between them. WHen you establish a virtual network peering, a route is placed in the system route table of the virtual network. That route provides a path for reaching the destination address space. For more information about troubleshooting virtual network peerings, see [Create, change, or delete a virtual network peering](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-network-manage-peering#before-you-begin).

  > [!NOTE]
  > You don't need a virtual network peering if your jumpbox is in the same virtual network as the private endpoint and your AKS private cluster.

- The virtual network link to the private DNS zone. Virtual network links provide a way for VMs that are inside virtual networks to connect to a private DNS zone and resolve the DNS records inside the zone. If you can't connect to your private AKS cluster or can't resolve the FQDN of the private cluster, check whether your virtual network has a virtual network link to your private DNS zone. The name of the private DNS zone should be in the following format:

  `privatelink.<region>.azmk8s.io`

  For more information about troubleshooting virtual network links, see [Virtual network peering](https://docs.microsoft.com/en-us/azure/aks/private-clusters#virtual-network-peering) and [What is a virtual network link?](https://docs.microsoft.com/en-us/azure/dns/private-dns-virtual-network-links).

  > [!NOTE]
  > You don't need a virtual network link if your jumpbox is in the same virtual network as the private endpoint and your AKS private cluster. When you create a private AKS cluster, a private DNS zone is created that has a virtual network link to the virtual network that hosts the private AKS cluster.

To further secure AKS workloads and your jumpboxes, you can use just-in-time (JIT) access and Privileged Access Workstation (PAW).

The JIT access feature of Microsoft Defender for Cloud reduces the threat landscape. Attackers often target the RDP and SSH ports that you use to connect to your jumpbox. The JIT access feature uses network security groups or Azure Firewall to block all inbound traffic to your jumpbox. If a user tries to connect to the jumpbox with appropriate RBAC permissions, this feature configures the network security groups or Azure Firewall to allow inbound access to the selected ports for a specified amount of time. After that time expires, the ports deny all inbound traffic. For more information about JIT access, see [Just-In-Time VM access](https://docs.microsoft.com/en-us/azure/defender-for-cloud/just-in-time-access-overview).

PAWs are hardened physical devices that provide the highest possible security configuration for operators. Using a PAW to connect to your jumpbox and AKS cluster forms a good privileged access strategy. It's difficult to compromise PAWs, because they block many common attack vectors such as email or web browsing. For more information about PAWs, see [Securing devices as part of the privileged access story](https://docs.microsoft.com/en-us/security/compass/privileged-access-devices).

## VPN

A VPN connection provides hybrid connectivity from your on-premises environment into Azure. You need connectivity to your internal virtual network infrastructure to access an AKS private cluster. The private cluster's API server isn't reachable from outside your virtual networks.

A VPN makes it possible for you to reach your private AKS cluster. When you use a VPN connection, you can reach your virtual network infrastructure in Azure over an encrypted tunnel. After you connect to the virtual network gateway, you can reach your jumpbox. From there, you can connect to your private cluster's API server.

### Dataflow

1. A user initiates RDP or SSH traffic to the jumpbox from an on-premises workstation.
1. Jumpbox traffic leaves the customer edge routers and VPN appliance. The traffic uses an encrypted IPsec tunnel to traverse the internet.
1. Jumpbox traffic reaches the virtual network gateway in Azure, which is the ingress and egress point of the Azure virtual network infrastructure.
1. After traffic passes the virtual network gateway, it reaches the jumpbox. The attempt to connect to the AKS private cluster is made from this jumpbox. The hub virtual network has a virtual network link to the AKS private DNS zone to resolve the FQDN of the private cluster.
1. The hub virtual network and the spoke virtual network communicate with each other by using a virtual network peering.
1. To reach the private AKS cluster, the traffic enters the Azure backbone. A private endpoint establishes a private, isolated connection to the private AKS cluster.
1. The traffic reaches the API server of the private AKS cluster. The user can manage pods, nodes, and applications.

## ExpressRoute

ExpressRoute is another option that you can use to establish connectivity to your AKS private cluster from an on-premises environment. ExpressRoute uses Border Gateway Protocol (BGP) to exchange routes between your on-premises network, your instances in Azure, and Microsoft public addresses. This exchange gives IaaS resources in Azure and on-premises workstations a path to each other. ExpressRoute provides a dedicated and isolated connection while maintaining consistent bandwidth and latency for enterprise environments.

### Dataflow

1. A user initiates RDP or SSH traffic to the jumpbox from an on-premises workstation.
1. Jumpbox traffic leaves the customer edge routers and rides a fiber connection into the meet-me location, where the ExpressRoute circuit resides. The traffic reaches the Microsoft Enterprise Edge (MSEE) devices there. Then it enters the Azure fabric.
1. Jumpbox traffic reaches the ExpressRoute gateway, which is the ingress and egress point of the Azure virtual network infrastructure.
1. The traffic reaches the jumpbox. The attempt to connect to the AKS private cluster is made from this jumpbox. The hub virtual network has a virtual network link to the AKS private DNS zone to resolve the FQDN of the private cluster.
1. The hub virtual network and the spoke virtual network communicate with each other by using a virtual network peering.
1. To reach the private AKS cluster, the traffic enters the Azure backbone. A private endpoint establishes a private, isolated connection to the private AKS cluster.
1. The traffic reaches the API server of the private AKS cluster. The user can manage pods, nodes, and applications.

> [!NOTE]
> ExpressRoute requires a third-party connectivity provider to provide a peering connection to the MSEE routers. ExpressRoute traffic isn't encrypted. For more information, see [What is Azure ExpressRoute?](https://docs.microsoft.com/en-us/azure/expressroute/expressroute-introduction).

## The aks command invoke command

With an AKS private cluster, you have to connect to the private cluster from a VM that has access to the cluster's API server. You can use the Azure CLI command `az aks command invoke` to remotely run commands such as `kubectl` or `helm` on your AKS private cluster through the Azure API. When you use `az aks command invoke`, a transient pod is created in a specific namespace within the cluster. The pod only exists for the life of the command. From within the transient pod, you can run commands on your private cluster.

You can use `aks command invoke` as an alternative to connect to your private cluster if you don't have a VPN, ExpressRoute, an external connectivity solution, or a virtual network that's peered directly to the cluster's virtual network. Before you use `aks command invoke`, check the resources that are available to your cluster and node pool. Insufficient resources can prevent the transient pod from being created

For more information, see [Use command invoke to access a private Azure Kubernetes Service (AKS) cluster](https://docs.microsoft.com/en-us/azure/aks/command-invoke#limitations).

## Connect Azure Cloud Shell to a subnet

When you deploy Cloud Shell into a virtual network that you control, you can interact with resources inside that virtual network. A Cloud Shell instance is usually deployed into a container that's within a virtual network that Microsoft manages. That container can't interact with resources in other virtual networks. But if you deploy an AKS private cluster, you can connect Cloud Shell to a subnet that you manage that has connectivity to the cluster's API server. Then you can connect to the private cluster. For more information, see [Deploy Cloud Shell into an Azure virtual network](https://docs.microsoft.com/en-us/azure/cloud-shell/private-vnet).


