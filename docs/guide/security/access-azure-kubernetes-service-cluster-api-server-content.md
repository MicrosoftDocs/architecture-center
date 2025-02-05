This guide outlines options for connecting to the API server of your Azure Kubernetes Service (AKS) cluster. In a standard AKS cluster, the API server is exposed over the internet. In a private AKS cluster, you can only connect from a device with network access to the private cluster.

Planning API server access is a day-zero activity, and your access method depends on your deployment scenario.

## AKS API server access

To manage an AKS cluster, you interact with its API server. It’s essential to restrict API server access to only necessary users. Granular access can be provided by integrating the AKS cluster with Microsoft Entra ID. Administrators can use role-based access control (RBAC) to manage access, placing users and identities in Entra groups and assigning appropriate roles and permissions. Microsoft Entra authentication is enabled in AKS clusters via OpenID Connect. For more information, see these resources:

- [AKS-managed Microsoft Entra integration](/azure/aks/managed-aad)
- [Integrate Microsoft Entra ID for the cluster](/azure/architecture/reference-architectures/containers/aks/baseline-aks#integrate-azure-active-directory-for-the-cluster)

> [!NOTE]
> You can enhance AKS cluster security by allowing only authorized IP address ranges to access the API server. For more information, see [Secure access to the API server using authorized IP address ranges in Azure Kubernetes Service (AKS)](/azure/aks/api-server-authorized-ip-ranges).

[Azure DDoS Protection](/azure/ddos-protection/ddos-protection-overview), combined with application design best practices, offers enhanced mitigation features against DDoS attacks. You should enable [Azure DDOS Protection](/azure/ddos-protection/ddos-protection-overview) on any perimeter virtual network.

## Access AKS cluster over the internet

When you create a nonprivate cluster that resolves to the API server's fully qualified domain name (FQDN), it's assigned a public IP address by default. You can connect to your cluster using the Azure portal or a shell such as Azure CLI, PowerShell, or Command Prompt.

> [!NOTE]
> For more information about using the Kubernetes command-line client 'kubectl' to connect to a cluster over the internet, see [Connect to the cluster](/azure/aks/learn/quick-kubernetes-deploy-cli#connect-to-the-cluster).

## Azure Cloud Shell

Cloud Shell is a shell built into the Azure portal. You can manage and connect to Azure resources from Cloud Shell as you would from PowerShell or Azure CLI. For more information, see [Overview of Azure Cloud Shell](/azure/cloud-shell/overview).

## Access AKS private cluster

They're are several ways to connect to an AKS private cluster. Planning access is a day-zero activity based on your scenario's needs and limitations. You can connect to your private cluster using the following components and services:

- Jump box deployed into a subnet as your operations workstation. This can be [stand-alone, persistent virtual machines (VMs)](/azure/virtual-machines/managed-disks-overview) in an [availability set](/azure/virtual-machines/availability-set-overview). You can also use [Azure Virtual Machine Scale Sets](/azure/virtual-machine-scale-sets/overview).
- [Azure Bastion](/azure/bastion/bastion-overview).
- [Virtual private network (VPN)](/azure/vpn-gateway/vpn-gateway-about-vpngateways).
- [Azure ExpressRoute](/azure/expressroute/expressroute-introduction).
- Azure CLI [aks command invoke](/azure/aks/command-invoke#limitations).
- [Cloud Shell](/azure/cloud-shell/private-vnet) instance that's deployed into a subnet that's connected to the API server for the cluster.
- [Azure Virtual Desktop](/azure/virtual-desktop/overview). If your team connects remotely from various operating systems, you can use this service to provide access to Windows VMs that you use as jump boxes.
- Azure Container Instances and an [OpenSSH](https://docs.linuxserver.io/images/docker-openssh-server)-compatible Secure Shell (SSH) client.

> [!NOTE]
> SSH, Remote Desktop Protocol (RDP), and Remote Desktop Services (RDS) are alternative protocols for remotely controlling jump boxes.

## Azure Bastion

Azure Bastion is a PaaS offering that enables secure RDP or SSH connections to a VM within your virtual network, without requiring a public IP address on the VM. When connecting to a private AKS cluster, you can use Azure Bastion to access a jump box in the hub virtual network, while the AKS cluster resides in a spoke network. A virtual network peering is used to connect the hub and spoke network. The jump box can resolve the AKS API server's FQDN using Azure Private Endpoint, a private DNS zone, and a DNS A record. This setup ensures that the API server's FQDN is only resolvable within the virtual network, providing a trusted connection to the private AKS cluster.

> [!NOTE]
> The availability and redundancy of your jump boxes are critical for continuous access to your private AKS cluster. To ensure this, place your jump boxes in availability sets and use Virtual Machine Scale Sets with a few VM instances. For more information, see these resources:
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

### Troubleshoot connection problems

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
  > When you create a private AKS cluster, a private DNS zone is created that has a virtual network link to the virtual network that hosts the private AKS cluster.

## Improve security

To further secure AKS workloads and your jump boxes, you can use just-in-time (JIT) access and a privileged access workstation (PAW).

To secure AKS workloads and your jump boxes, use just-in-time (JIT) access and a privileged access workstation (PAW). JIT access, part of Microsoft Defender for Cloud, reduces the threat landscape by blocking inbound traffic to your jump box and allowing access only for a specified time when needed. After the time expires, the access is automatically revoked. For more information about JIT access, see [Understanding just-in-time (JIT) VM access](/azure/defender-for-cloud/just-in-time-access-overview).

PAWs are hardened devices that provide high security for operators by blocking common attack vectors like email and web browsing. It's difficult to compromise PAWs, because they block many common attack vectors such as email and web browsing. For more information about PAWs, see [Securing devices as part of the privileged access story](/security/compass/privileged-access-devices).

## Virtual Private Network (VPN)

A VPN connection provides hybrid connectivity from your on-premises environment to Azure enabling access to a private AKS cluster. The API server of the private cluster isn't reachable outside your virtual networks. With a VPN, you can connect to your virtual network in Azure over an encrypted tunnel, then access your jump box and, from there, connect to the private cluster's API server.

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

## ExpressRoute

ExpressRoute provides connectivity to your AKS private cluster from an on-premises environment. ExpressRoute uses Border Gateway Protocol (BGP) to exchange routes between your on-premises network and Azure creating a path between IaaS resources and on-premises workstations. ExpressRoute offers a dedicated, isolated connection with consistent bandwidth and latency, making it ideal for enterprise environments.

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

## Run aks command invoke

With an AKS private cluster, you can connect from a VM that has access to the API server. Using the Azure CLI `aks command invoke`, you can run commands like `kubectl` or `helm` remotely via the Azure API. This creates a transient pod in the cluster, which lasts only during the command. The `aks command invoke` serves as an alternative connection method if you lack a VPN, ExpressRoute, or peered virtual network. Ensure your cluster and node pool have sufficient resources to create the transient pod.

For more information, see [Use command invoke to access a private Azure Kubernetes Service (AKS) cluster](/azure/aks/command-invoke#limitations).

## Connect Cloud Shell to a subnet

When you deploy Cloud Shell into a virtual network you control, you can interact with resources inside that network. Deploying Cloud Shell into a subnet you manage enables connectivity to the API server of an AKS private cluster. This allows you to connect to the private cluster. For more information, see [Deploy Cloud Shell into an Azure virtual network](/azure/cloud-shell/private-vnet).

## Use SSH and Visual Studio Code for testing

SSH securely manages and accesses files on a remote host using public-private key pairs. From your local machine, you can use SSH with the Visual Studio Code Remote - SSH extension to connect to a jump box in your virtual network. The encrypted SSH tunnel terminates at the public IP of the jump box, making it easy to modify Kubernetes manifest files.

To learn how to connect to your jump box via SSH, see [Remote development over SSH](https://code.visualstudio.com/docs/remote/ssh-tutorial).

If you can't connect to your VM over SSH to manage your private cluster:

- Check the inbound network security group rule for the VM subnet. The default network security group rule blocks all inbound traffic from outside Azure, so create a new rule allowing SSH traffic from your local machine's public IP.
- Check the certificate location. Check for correct placement of the certificates. The private key should be in the `C:\Users\User\.ssh\id_rsa` directory on your local machine. The public key should be placed in the `~/.ssh/id_rsa.pub` file on the VM in Azure.

> [!NOTE]
> We recommend that you:
>
> - Avoid using a public IP address to connect to resources in production environments. Public IPs should only be used in development or testing. In such cases, create an inbound network security group rule to allow traffic from your local machine's public IP. For more information about network security group rules, see [Create, change, or delete a network security group](/azure/virtual-network/manage-network-security-group).
> - Refrain from using SSH to connect directly to AKS nodes or containers. Instead, use a dedicated external management solution. This is especially important when considering the use of `aks command invoke`, which creates a transient pod within your cluster for proxied access.

> [!NOTE]
> For more information about network security groups and AKS, see [Network security groups](https://learn.microsoft.com/en-us/azure/aks/concepts-network#network-security-groups).

## Conclusion

- You can access your AKS cluster's API server over the internet if the public FQDN is enabled.
- Cloud Shell is a built-in command-line shell in the Azure portal that you can use to connect to an AKS cluster.
- For more secure access, use Azure Bastion and a private endpoint.
- VPNs and ExpressRoute provide hybrid connectivity to your private AKS cluster.
- If no external connectivity solution is available, you can use `aks command invoke` remotely.
- Cloud Shell can also be deployed directly into a virtual network you manage to access the private cluster.
- Using Visual Studio Code with SSH on a jump box encrypts the connection and simplifies modifying manifest files, though it exposes a public IP address in your environment.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Ayobami Ayodeji](https://www.linkedin.com/in/ayobamiayodeji) | Program Manager 2
- [Ariel Ramirez](https://www.linkedin.com/in/arielramirez99) | Senior Consultant
- [Bahram Rushenas](https://www.linkedin.com/in/bahram-rushenas-306b9b3) | Incubation Architect

Other contributors:

- [Shubham Agnihotri](https://www.linkedin.com/in/shubham-agnihotri8) | Consultant

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

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
