This guide describes various options for connecting to the API server of your Azure Kubernetes Service (AKS) cluster. With a standard AKS cluster, the API server is exposed over the internet. If you create a private AKS cluster, you can only connect to the API server from a device that has network connectivity to your private cluster.

Planning access to your API server is a day-zero activity. How you choose to access the API server depends on your deployment scenario.

## AKS API server access

To manage an AKS cluster, you interact with its API server. It's critical to lock down access to the API server and to grant access only to users who need it. You can provide granular access by integrating your AKS cluster with Azure Active Directory (Azure AD). Administrators can then use role-based access control (RBAC) to restrict access. Through RBAC, administrators can place users and identities in Azure AD groups and assign appropriate roles and permissions to the groups. Azure AD authentication is provided to AKS clusters with OpenID Connect. For more information, see these resources:

- [AKS-managed Azure Active Directory integration](/azure/aks/managed-aad)
- [Integrate Azure Active Directory for the cluster](/azure/architecture/reference-architectures/containers/aks/baseline-aks#integrate-azure-active-directory-for-the-cluster)

> [!NOTE]
> You can further lock down your AKS cluster by allowing only authorized IP address ranges to communicate with the API server. For more information, see [Secure access to the API server using authorized IP address ranges in Azure Kubernetes Service (AKS)](/azure/aks/api-server-authorized-ip-ranges).

[Azure DDoS Protection Standard](/azure/ddos-protection/ddos-protection-overview), combined with application-design best practices, provides enhanced DDoS mitigation features to provide more defense against DDoS attacks. You should enable [Azure DDOS Protection Standard](/azure/ddos-protection/ddos-protection-overview) on any perimeter virtual network.

## Access the AKS cluster over the internet

When you create a non-private cluster that resolves to the API server's fully qualified domain name (FQDN), the API server is assigned a public IP address by default. You can then use the Azure portal to connect to your cluster, or you can use a shell like the Azure CLI, PowerShell, or Command Prompt.

> [!NOTE]
> For detailed information about using the Kubernetes command-line client `kubectl` to connect to a cluster over the internet, see [Connect to the cluster](/azure/aks/learn/quick-kubernetes-deploy-cli#connect-to-the-cluster).

## Azure Cloud Shell

Cloud Shell is a shell that's built into the Azure portal. You can manage and connect to Azure resources from Cloud Shell the same way you do from PowerShell or the Azure CLI. For more information, see [Overview of Azure Cloud Shell](/azure/cloud-shell/overview).

## Access an AKS private cluster

There are many ways to connect to an AKS private cluster. Planning how to access your AKS private cluster is a day-zero activity that depends on your scenario's needs and limitations. You can connect to your private cluster by using the following components and services:

- A jump box. You can deploy a jump box into a subnet and use it as your operations workstation. For the jump box, you can use [stand-alone, persistent virtual machines (VMs)](/azure/virtual-machines/managed-disks-overview) in an [availability set](/azure/virtual-machines/availability-set-overview). You can also use [Azure Virtual Machine Scale Sets](/azure/virtual-machine-scale-sets/overview).
- [Azure Bastion](/azure/bastion/bastion-overview).
- A [virtual private network (VPN)](/azure/vpn-gateway/vpn-gateway-about-vpngateways).
- [Azure ExpressRoute](/azure/expressroute/expressroute-introduction).
- Azure CLI [aks command invoke](/azure/aks/command-invoke#limitations) for managing AKS.
- A [Cloud Shell](/azure/cloud-shell/private-vnet) instance that's deployed into a subnet that's connected to the API server for the cluster.
- [Azure Virtual Desktop](/azure/virtual-desktop/overview). If your team connects remotely from various operating systems, you can use this service to provide access to Windows VMs that you use as jump boxes.
- Azure Container Instances and an [OpenSSH](https://docs.linuxserver.io/images/docker-openssh-server)-compatible Secure Shell (SSH) client.

> [!NOTE]
> SSH, Remote Desktop Protocol (RDP), and Remote Desktop Services (RDS) are alternative protocols that you can use to control jump boxes remotely.

### Use Azure Bastion

Azure Bastion is a platform as a service (PaaS) offering that you deploy within your virtual network to connect to a VM in that network, such as a jump box. To connect, you use RDP or SSH from a browser within the Azure portal. The Transport Layer Security (TLS) protocol protects the connection. Usually there's a public IP address that's associated with the VM's network interface card (NIC). That address provides a way to connect to the VM. When you use Azure Bastion, you no longer need to associate a public IP address with your jump box.

When you connect to the API server of your AKS cluster, it's best to use a trusted connection. One option is to use Azure Bastion to connect to a jump box that's inside your Azure environment. In this scenario, the jump box resides in the hub virtual network. The private AKS cluster resides in a spoke virtual network. A virtual network peering connects the hub and spoke networks.

The jump box can resolve the FQDN of the API server by using Azure Private Endpoint, a private DNS zone, and a DNS A record inside the private DNS zone. By using the AKS private cluster and the private endpoint, you ensure that the API server FQDN can be resolved only from within your virtual network. With a private cluster, the browser needs to run on a machine that has access to the virtual network of the AKS private cluster. For more information, see [Subnet to host Azure Bastion](/azure/architecture/reference-architectures/containers/aks/baseline-aks#subnet-to-host-azure-bastion).

> [!NOTE]
> The availability and redundancy of your jump box is critical. You should always be able to reach your jump box. Likewise, you should always be able to reach your private AKS cluster. To achieve availability and redundancy for your jump boxes, put them in availability sets and use Virtual Machine Scale Sets with a small number of VM instances. For more information, see these resources:
>
> - [Availability sets overview](/azure/virtual-machines/availability-set-overview)
> - [What are virtual machine scale sets?](/azure/virtual-machine-scale-sets/overview)

:::image type="content" source="./images/access-azure-kubernetes-service-cluster-api-server-bastion-architecture.png" alt-text="Architecture diagram that shows the traffic route from a user to a private AKS cluster. The traffic flows through Azure Bastion and a jump box." lightbox="./images/access-azure-kubernetes-service-cluster-api-server-bastion-architecture.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/US-1956833-access-azure-kubernetes-service-cluster-api-server-architecture.vsdx) of this architecture.*

#### Dataflow

1. A user attempts to connect to a jump box by using Azure Bastion and an HTML5 browser with TLS encryption.
1. The user chooses from the portal whether to use RDP or SSH to connect to the jump box.
1. The user signs in to the jump box through Azure Bastion. The attempt to connect to the AKS private cluster is made from this jump box. The hub virtual network has a virtual network link to the AKS private DNS zone to resolve the FQDN of the private cluster.
1. The hub virtual network and the spoke virtual network communicate with each other by using a virtual network peering.
1. To reach the private AKS cluster, the traffic enters the Azure backbone. A private endpoint establishes a private, isolated connection to the private AKS cluster.
1. The traffic reaches the API server of the private AKS cluster. The user can then manage pods, nodes, and applications.

> [!NOTE]
> The FQDN of your private cluster can still be resolved from outside your virtual network if you don't explicitly disable the public FQDN. For information about disabling the public FQDN of your AKS private cluster, see [Disable public FQDN on an existing cluster](/azure/aks/private-clusters#disable-public-fqdn-on-an-existing-cluster).

#### Troubleshoot connection problems

If you can't connect to your private cluster:

- Check the virtual network peering. This mechanism provides network-to-network connectivity between two virtual networks. For traffic to flow between those two networks, you need to establish the virtual network peering between them. When you establish a virtual network peering, a route is placed in the system route table of the virtual network. That route provides a path for reaching the destination address space. For more information about troubleshooting virtual network peerings, see [Create, change, or delete a virtual network peering](/azure/virtual-network/virtual-network-manage-peering#before-you-begin).

  > [!NOTE]
  > You don't need a virtual network peering if your jump box is in the same virtual network as the private endpoint and your AKS private cluster.

- Check the virtual network link to the private DNS zone. Virtual network links provide a way for VMs that are inside virtual networks to connect to a private DNS zone and resolve the DNS records inside the zone. If you can't connect to your private AKS cluster or can't resolve the FQDN of the private cluster, check whether your virtual network has a virtual network link to your private DNS zone. The name of the private DNS zone should have the following format:

  `privatelink.<region>.azmk8s.io`

  For more information about troubleshooting virtual network links, see these resources:

  - [Virtual network peering](/azure/aks/private-clusters#virtual-network-peering)
  - [What is a virtual network link?](/azure/dns/private-dns-virtual-network-links)

  > [!NOTE]
  > You don't need a virtual network link if your jump box is in the same virtual network as the private endpoint and your AKS private cluster. When you create a private AKS cluster, a private DNS zone is created that has a virtual network link to the virtual network that hosts the private AKS cluster.

#### Improve security

To further secure AKS workloads and your jump boxes, you can use just-in-time (JIT) access and a privileged access workstation (PAW).

The JIT access feature of Microsoft Defender for Cloud reduces the threat landscape. Attackers often target the RDP and SSH ports that you use to connect to your jump box. The JIT access feature uses network security groups or Azure Firewall to block all inbound traffic to your jump box. If a user tries to connect to the jump box with appropriate RBAC permissions, this feature configures the network security groups or Azure Firewall to allow inbound access to the selected ports for a specified amount of time. After that time expires, the ports deny all inbound traffic. For more information about JIT access, see [Understanding just-in-time (JIT) VM access](/azure/defender-for-cloud/just-in-time-access-overview).

PAWs are hardened physical devices that provide the highest possible security configuration for operators. To adopt a good privileged-access strategy, use a PAW to connect to your jump box and AKS cluster. It's difficult to compromise PAWs, because they block many common attack vectors such as email and web browsing. For more information about PAWs, see [Securing devices as part of the privileged access story](/security/compass/privileged-access-devices).

### Use a VPN

A VPN connection provides hybrid connectivity from your on-premises environment to Azure. You need connectivity to your internal virtual network infrastructure to access an AKS private cluster. The API server of the private cluster can't be reached outside your virtual networks.

A VPN makes it possible for you to reach your private AKS cluster. When you use a VPN connection, you can reach your virtual network infrastructure in Azure over an encrypted tunnel. After you connect to the virtual network gateway, you can reach your jump box. From there, you can connect to your private cluster's API server.

:::image type="content" source="./images/access-azure-kubernetes-service-cluster-api-server-vpn-architecture.png" alt-text="Architecture diagram that shows traffic flow from a user to a private AKS cluster. The route includes a VPN gateway, an IPsec tunnel, and a jump box." lightbox="./images/access-azure-kubernetes-service-cluster-api-server-vpn-architecture.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/US-1956833-access-azure-kubernetes-service-cluster-api-server-architecture.vsdx) of this architecture.*

#### Dataflow

1. A user initiates RDP or SSH traffic to the jump box from an on-premises workstation.
1. Jump box traffic leaves the customer edge routers and VPN appliance. The traffic uses an encrypted IPsec tunnel to traverse the internet.
1. Jump box traffic reaches the virtual network gateway in Azure, which is the ingress and egress point of the Azure virtual network infrastructure.
1. After traffic moves past the virtual network gateway, it reaches the jump box. The attempt to connect to the AKS private cluster is made from the jump box. The hub virtual network has a virtual network link to the AKS private DNS zone to resolve the FQDN of the private cluster.
1. The hub virtual network and the spoke virtual network communicate with each other by using a virtual network peering.
1. To reach the private AKS cluster, the traffic enters the Azure backbone. A private endpoint establishes a private, isolated connection to the private AKS cluster.
1. The traffic reaches the API server of the private AKS cluster. The user can then manage pods, nodes, and applications.

### Use ExpressRoute

ExpressRoute is another option that you can use to establish connectivity to your AKS private cluster from an on-premises environment. ExpressRoute uses Border Gateway Protocol (BGP) to exchange routes between your on-premises network, your instances in Azure, and Microsoft public addresses. This exchange gives infrastructure as a service (IaaS) resources in Azure and on-premises workstations a path to each other. ExpressRoute provides a dedicated and isolated connection while maintaining consistent bandwidth and latency for enterprise environments.

:::image type="content" source="./images/access-azure-kubernetes-service-cluster-expressroute-architecture.png" alt-text="Architecture diagram that shows the traffic route from a user to a private AKS cluster. The route includes ExpressRoute and a jump box." lightbox="./images/access-azure-kubernetes-service-cluster-expressroute-architecture.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/US-1956833-access-azure-kubernetes-service-cluster-api-server-architecture.vsdx) of this architecture.*

#### Dataflow

1. A user initiates RDP or SSH traffic to the jump box from an on-premises workstation.
1. Jump box traffic leaves the customer edge routers and travels on a fiber connection to the meet-me location, where the ExpressRoute circuit resides. The traffic reaches the Microsoft Enterprise Edge (MSEE) devices there. Then it enters the Azure fabric.
1. Jump box traffic reaches the ExpressRoute gateway, which is the ingress and egress point of the Azure virtual network infrastructure.
1. The traffic reaches the jump box. The attempt to connect to the AKS private cluster is made from the jump box. The hub virtual network has a virtual network link to the AKS private DNS zone to resolve the FQDN of the private cluster.
1. The hub virtual network and the spoke virtual network communicate with each other by using a virtual network peering.
1. To reach the private AKS cluster, the traffic enters the Azure backbone. A private endpoint establishes a private, isolated connection to the private AKS cluster.
1. The traffic reaches the API server of the private AKS cluster. The user can then manage pods, nodes, and applications.

> [!NOTE]
> ExpressRoute requires a third-party connectivity provider to provide a peering connection to the MSEE routers. ExpressRoute traffic isn't encrypted. For more information, see [What is Azure ExpressRoute?](/azure/expressroute/expressroute-introduction).

### Run aks command invoke

With an AKS private cluster, you connect to the private cluster from a VM that has access to the API server of the cluster. You can use the Azure CLI command `aks command invoke` to remotely run commands such as `kubectl` or `helm` on your AKS private cluster through the Azure API. When you use `aks command invoke`, a transient pod is created in a specific namespace within the cluster. The pod only exists for the life of the command. From within the transient pod, you can run commands on your private cluster.

You can use `aks command invoke` as an alternate way of connecting to your private cluster if you don't have a VPN, ExpressRoute, an external connectivity solution, or a virtual network that's peered directly to the cluster's virtual network. Before you use `aks command invoke`, check the resources that are available to your cluster and node pool. Insufficient resources can prevent the transient pod from being created.

For more information, see [Use command invoke to access a private Azure Kubernetes Service (AKS) cluster](/azure/aks/command-invoke#limitations).

### Connect Cloud Shell to a subnet

When you deploy Cloud Shell into a virtual network that you control, you can interact with resources inside that virtual network. A Cloud Shell instance is usually deployed into a container that's within a virtual network that Microsoft manages. That container can't interact with resources in other virtual networks. But if you deploy an AKS private cluster, you can connect Cloud Shell to a subnet that you manage that has connectivity to the cluster's API server. Then you can connect to the private cluster. For more information, see [Deploy Cloud Shell into an Azure virtual network](/azure/cloud-shell/private-vnet).

### Use SSH and Visual Studio Code for testing

SSH is a protocol that provides a way to securely manage and access files on a remote host. As part of the authentication process, SSH uses public-private key pairs.

From your local machine, you can use SSH and the Visual Studio Code Remote - SSH extension to connect to a jump box that's in your virtual network. The SSH tunnel is encrypted, and the connection terminates on the public IP address that's attached to the jump box. This approach makes it easy to modify Kubernetes manifest files.

To learn how to connect to your jump box via SSH, see [Remote development over SSH](https://code.visualstudio.com/docs/remote/ssh-tutorial).

If you can't connect to your VM over SSH to manage your private cluster:

- Check the inbound network security group rule for the VM subnet. When you connect to your VM in Azure over SSH, the network security group that's attached to the VM subnet or NIC has a default rule. That rule blocks all inbound internet traffic that originates outside Azure. To overcome this obstacle, create a new inbound network security group rule. Configure the new rule to allow SSH traffic that originates from the public IP address of your local machine.
- Check the certificate location. When you use SSH, check for correct placement of the certificates. The private key should be in the `C:\Users\User\.ssh\id_rsa` directory on your local machine. The public key should be placed in the `~/.ssh/id_rsa.pub` file on the VM in Azure.

> [!NOTE]
> We recommend that you:
>
> - Don't use a public IP address to connect to resources in a production environment. Use public IP addresses only in development and testing scenarios. As discussed earlier in this section, you need to create an inbound network security group rule in such environments. That rule should allow traffic from the public IP address of your local machine to enter the environment. For more information about network security group rules, see [Create, change, or delete a network security group](/azure/virtual-network/manage-network-security-group).
> - Don't use SSH to connect directly to your AKS nodes or containers. In other words, don't use the management target system as the management tool, because this approach isn't reliable. It's better to use a dedicated solution that's external to your cluster. Keep this point in mind when you evaluate whether `aks command invoke` is appropriate for your deployment, because using that command creates a transient pod within your cluster for proxied access.

## Conclusion

- You can access the API server of your AKS cluster over the internet if the public FQDN isn't disabled.
- Cloud Shell is a built-in command-line shell in the Azure portal that you can use to connect to an AKS cluster.
- For a more secure and locked-down way to access your private cluster, use Azure Bastion and a private endpoint.
- VPNs and ExpressRoute both help facilitate hybrid connectivity to your private AKS cluster.
- You can run `aks command invoke` remotely to connect to your AKS private cluster if you don't have an external connectivity solution.
- You can deploy Cloud Shell directly into a virtual network that you manage. Cloud Shell can access your private cluster from a virtual network that you manage.
- You can use Visual Studio Code and SSH to connect to a jump box. This approach encrypts the connection to your jump box, gives you access to your private cluster from within the VM, and makes it easy to modify manifest files in development scenarios. But this way of connecting exposes a public IP address in your environment.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Ayobami Ayodeji](https://www.linkedin.com/in/ayobamiayodeji) | Program Manager 2
- [Ariel Ramirez](https://www.linkedin.com/in/arielramirez99) | Consultant
- [Bahram Rushenas](https://www.linkedin.com/in/bahram-rushenas-306b9b3) | Incubation Architect

Other contributors:

- [Shubham Agnihotri](https://www.linkedin.com/in/shubham-agnihotri8) | Consultant

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [What is Azure Bastion?](/azure/bastion/bastion-overview)
- [Get started with OpenSSH](/windows-server/administration/openssh/openssh_install_firstuse)
- [What is a private endpoint?](/azure/private-link/private-endpoint-overview)
- [What is Azure ExpressRoute?](/azure/expressroute/expressroute-introduction)
- [What is VPN Gateway?](/azure/vpn-gateway/vpn-gateway-about-vpngateways)

## Related resources

- [Baseline architecture for an Azure Kubernetes Service (AKS) cluster](/azure/architecture/reference-architectures/containers/aks/baseline-aks)
- [Advanced Azure Kubernetes Service (AKS) microservices architecture](../../reference-architectures/containers/aks-microservices/aks-microservices-advanced.yml)
- [Azure Kubernetes Service (AKS) architecture design](../../reference-architectures/containers/aks-start-here.md)