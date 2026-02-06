This article outlines options for how to connect to the API server of your Azure Kubernetes Service (AKS) cluster. In a standard AKS cluster, the API server is exposed over the internet. In a private AKS cluster, you can only connect to the internet from a device that has network access to the private cluster.

Planning API server access is a day-zero activity, and how you access the server depends on your deployment scenario.

## AKS API server access

To manage an AKS cluster, you interact with its API server. It's essential to limit API server access to only the necessary users. You can provide granular access by integrating the AKS cluster with Microsoft Entra ID. Administrators can manage access by using Azure role-based access control (Azure RBAC). They can also place users and identities in Microsoft Entra groups and assign appropriate roles and permissions. Microsoft Entra authentication is enabled in AKS clusters via OpenID Connect. For more information, see the following resources:

- [Enable Azure managed identity authentication for Kubernetes clusters with kubelogin](/azure/aks/managed-aad)

- [Integrate Microsoft Entra ID for the cluster](/azure/architecture/reference-architectures/containers/aks/baseline-aks#integrate-microsoft-entra-id-for-the-cluster)

> [!NOTE]
> You can enhance AKS cluster security by allowing only [authorized IP address ranges](/azure/aks/api-server-authorized-ip-ranges) to access the API server.

[Azure DDoS Protection](/azure/ddos-protection/ddos-protection-overview), combined with application design best practices, provides enhanced mitigation features against distributed denial-of-service (DDoS) attacks. Enable DDoS Protection on every perimeter virtual network.

## Access an AKS cluster over the internet

When you create a non-private cluster that resolves to the API server's fully qualified domain name (FQDN), it's assigned a public IP address by default. You can connect to your cluster by using the Azure portal or a shell such as Azure CLI, PowerShell, or command prompt.

> [!NOTE]
> You can use the Kubernetes command-line client `kubectl` to [connect to a cluster](/azure/aks/learn/quick-kubernetes-deploy-cli#connect-to-the-cluster) over the internet.

## Cloud Shell

[Azure Cloud Shell](/azure/cloud-shell/overview) is a shell built into the Azure portal. You can manage and connect to Azure resources from Cloud Shell like you can from PowerShell or Azure CLI.

## Access an AKS private cluster

There are several ways to connect to an AKS private cluster. Planning access is a day-zero activity that's based on the needs and limitations of your scenario. You can connect to your private cluster by using the following components and services:

- **A jump box deployed into a subnet as your operations workstation:** This setup can be [stand-alone, persistent virtual machines (VMs)](/azure/virtual-machines/managed-disks-overview) in an [availability set](/azure/virtual-machines/availability-set-overview) or [Azure Virtual Machine Scale Sets](/azure/virtual-machine-scale-sets/overview).

- **Azure Container Instances and an [OpenSSH-compatible client](https://docs.linuxserver.io/images/docker-openssh-server):** Deploy a container instance that runs a Secure Shell (SSH) server, and then use your OpenSSH-compatible client to access the container. This container serves as a jump box within your network to reach your private cluster.

- **[Azure Bastion](/azure/bastion/bastion-overview):** Use Azure Bastion to establish more secure, browser-based remote access to your VMs or jump boxes within your Azure Virtual Network. This access lets you more safely connect to private endpoints like your AKS API server.

- **[Virtual private network (VPN)](/azure/vpn-gateway/vpn-gateway-about-vpngateways):** Create a secure VPN connection that extends your on-premises or remote network into your virtual network. This connection allows you to access your private cluster like you're locally connected.

- **[Azure ExpressRoute](/azure/expressroute/expressroute-introduction):** Use ExpressRoute to build a dedicated, private connection between your on-premises network and Azure. This connection helps ensure more secure and reliable access to your private cluster without using the public internet.

- **Azure CLI [az aks command invoke](/azure/aks/command-invoke#limitations) command:** Perform commands directly on your AKS cluster by using the Azure CLI with the `az aks command invoke` command. This command interacts with the cluster without exposing more network endpoints.

- **[Cloud Shell](/azure/cloud-shell/private-vnet) instance that's deployed into a subnet that's connected to the API server for the cluster:** Deploy Cloud Shell in a subnet that's linked to your cluster’s API server. This approach provides a more secure, managed command-line environment to manage your private cluster.

- **[Azure Virtual Desktop](/azure/virtual-desktop/overview):** Access Azure Virtual Desktop to use Windows or Linux desktops as jump boxes to more securely manage your private cluster from almost anywhere.

> [!NOTE]
> All traffic to the API server is transmitted over Transmission Control Protocol to port 443 via HTTPS. Network security groups (NSGs) or other network firewalls must allow traffic from the origin to the API server's FQDN on port 443 for HTTPS. Traffic allowances should be restricted specifically to the FQDN for the cluster's API server.

## Azure Bastion

Azure Bastion is a platform as a service offering that enables secure Remote Desktop Protocol (RDP) or SSH connections to a VM within your virtual network that doesn't require a public IP address on the VM. When you connect to a private AKS cluster, use Azure Bastion to access a jump box in the hub virtual network.

 Alternatively, you can use SSH, RDP, and Remote Desktop Services to remotely control jump boxes. The AKS cluster resides in a spoke network, which separates it from the jump box. Virtual network peering connects the hub and spoke networks. The jump box can resolve the AKS API server's FQDN by using Azure Private Endpoint, a private DNS zone, and a DNS A record. This setup helps ensure that the API server's FQDN is only resolvable within the virtual network. This configuration provides a trusted connection to the private AKS cluster.

> [!NOTE]
> For continuous access to your private AKS cluster, the availability and redundancy of your jump boxes are crucial. To help ensure this reliability, place your jump boxes in availability sets and use Virtual Machine Scale Sets that have few VM instances. For more information, see the following resources:
>
> - [Availability sets overview](/azure/virtual-machines/availability-set-overview)
> - [What are Virtual Machine Scale Sets?](/azure/virtual-machine-scale-sets/overview)

:::image type="complex" border="false" source="./images/access-azure-kubernetes-service-cluster-api-server-bastion-architecture.svg" alt-text="Architecture diagram that shows the traffic route from a user to a private AKS cluster. The traffic flows through Azure Bastion and a jump box." lightbox="./images/access-azure-kubernetes-service-cluster-api-server-bastion-architecture.svg":::
   Architecture diagram that shows the traffic route from a user to a private AKS cluster. The traffic flows through Azure Bastion and a jump box. First, a user attempts to connect to a jump box by using Azure Bastion and an HTML5 browser with Transport Layer Security encryption. From the portal, the user selects whether to use RDP or SSH to connect to the jump box. They sign in to the jump box through Azure Bastion and attempt to connect to the AKS private cluster from this jump box. The hub virtual network has a virtual network link to the AKS private DNS zone to resolve the FQDN of the private cluster. Both the hub and spoke virtual networks communicate via virtual network peering. To reach the private AKS cluster, traffic enters the Azure backbone where a private endpoint establishes a private, isolated connection to the private AKS cluster. The traffic reaches the API server of the private AKS cluster, which allows the user to manage pods, nodes, and applications.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/US-1956833-access-azure-kubernetes-service-cluster-api-server-architecture.vsdx) of this architecture.*

### Dataflow

1. A user attempts to connect to a jump box by using Azure Bastion and an HTML5 browser with Transport Layer Security encryption.

1. The user chooses from the portal whether to use RDP or SSH to connect to the jump box.

1. The user signs in to the jump box through Azure Bastion. The attempt to connect to the AKS private cluster is made from this jump box. The hub virtual network has a virtual network link to the AKS private DNS zone to resolve the FQDN of the private cluster.

1. The hub virtual network and the spoke virtual network communicate with each other by using virtual network peering.

1. To reach the private AKS cluster, the traffic enters the Azure backbone. A private endpoint establishes a private, isolated connection to the private AKS cluster.

1. The traffic reaches the API server of the private AKS cluster. The user can then manage pods, nodes, and applications.

> [!NOTE]
> The FQDN of your private cluster can be resolved from outside of your virtual network if you don't directly [disable public FQDN on an existing cluster](/azure/aks/private-clusters#disable-a-public-fqdn).

### Troubleshoot connection problems

If you can't connect to your private cluster:

- Check the virtual network peering. This mechanism provides network-to-network connectivity between two virtual networks. For traffic to flow between those two networks, you need to establish the virtual network peering between them. When you establish a virtual network peering, a route is placed in the system route table of the virtual network. That route provides a path for reaching the destination address space. For more information about troubleshooting virtual network peerings, see [Create, change, or delete a virtual network peering](/azure/virtual-network/virtual-network-manage-peering#before-you-begin).

  > [!NOTE]
  > You don't need a virtual network peering if your jump box is in the same virtual network as the private endpoint and the AKS private cluster.

- Check the virtual network link to the private DNS zone. Virtual network links provide a way for VMs that are inside virtual networks to connect to a private DNS zone and resolve the DNS records inside the zone. If you can't connect to your private AKS cluster or can't resolve the FQDN of the private cluster, check whether your virtual network has a virtual network link to your private DNS zone. The name of the private DNS zone should have the `privatelink.<region>.azmk8s.io` format.

  For more information about how to troubleshoot virtual network links, see the following resources:

  - [Virtual network peering](/azure/aks/private-clusters#virtual-network-peering)
  
  - [What is a virtual network link?](/azure/dns/private-dns-virtual-network-links)

  > [!NOTE]
  > When you create a private AKS cluster, a private DNS zone is created that has a virtual network link to the virtual network that hosts the private AKS cluster.

## Improve security

To help secure AKS workloads and your jump boxes, use just-in-time (JIT) access and a Privileged Access Workstation (PAW). JIT access is part of Microsoft Defender for Cloud. It can help minimize the potential attack surface and vulnerabilities by blocking inbound traffic to your jump box and allowing access only for a specified time when needed. After the time expires, the access is automatically revoked. For more information, see [Just-in-time machine access](/azure/defender-for-cloud/just-in-time-access-overview).

PAWs are hardened devices that provide high security for operators by blocking common attack vectors like email and web browsing. For more information, see [Secure devices as part of the privileged access story](/security/compass/privileged-access-devices).

## VPN

A VPN connection provides hybrid connectivity from your on-premises environment to Azure. This connectivity enables access to a private AKS cluster. The API server of the private cluster isn't reachable outside of your virtual networks. With a VPN, you can connect to your virtual network in Azure over an encrypted tunnel, access your jump box, and then connect to the private cluster's API server.

:::image type="complex" border="false" source="./images/access-azure-kubernetes-service-cluster-api-server-vpn-architecture.svg" alt-text="Architecture diagram that shows traffic flow from a user to a private AKS cluster. The route includes a VPN gateway, an Internet Protocol Security tunnel, and a jump box." lightbox="./images/access-azure-kubernetes-service-cluster-api-server-vpn-architecture.svg":::
   Architecture diagram that shows traffic flow from a user to a private AKS cluster. The route includes a VPN gateway, an IPsec tunnel, and a jump box. First, a user initiates RDP or SSH traffic to the jump box from an on-premises workstation. The jump box traffic leaves the customer edge routers and VPN appliance and traverses the internet by using an encrypted IPsec tunnel. After it reaches Azure, the traffic arrives at the virtual network gateway, which is both the ingress and egress point of the Azure virtual network infrastructure. The traffic then reaches the jump box, where the user attempts to connect to the AKS private cluster. The hub virtual network has a virtual network link to the AKS private DNS zone to resolve the FQDN of the private cluster. Virtual network peering facilitates communication between both the hub and spoke virtual networks. To reach the private AKS cluster, the traffic enters the Azure backbone where a private endpoint establishes a private, isolated connection to the cluster. Finally, the traffic reaches the API server of the private AKS cluster, which allows the user to manage pods, nodes, and applications.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/US-1956833-access-azure-kubernetes-service-cluster-api-server-architecture.vsdx) of this architecture.*

### Dataflow

1. A user initiates RDP or SSH traffic to the jump box from an on-premises workstation.

1. The jump box traffic leaves the customer edge routers and VPN appliance. The traffic uses an encrypted Internet Protocol Security tunnel to traverse the internet.

1. The jump box traffic reaches the virtual network gateway in Azure, which is both the ingress and egress point of the Azure virtual network infrastructure.

1. After the traffic moves past the virtual network gateway, it reaches the jump box. The attempt to connect to the AKS private cluster is made from the jump box. The hub virtual network has a virtual network link to the AKS private DNS zone to resolve the FQDN of the private cluster.

1. The hub virtual network and the spoke virtual network communicate with each other by using a virtual network peering.

1. To reach the private AKS cluster, the traffic enters the Azure backbone. A private endpoint establishes a private, isolated connection to the private AKS cluster.

1. The traffic reaches the API server of the private AKS cluster. The user can then manage pods, nodes, and applications.

## ExpressRoute

ExpressRoute provides connectivity to your AKS private cluster from an on-premises environment. ExpressRoute uses Border Gateway Protocol to exchange routes between your on-premises network and Azure. This connection creates a secure path between infrastructure as a service resources and on-premises workstations. ExpressRoute provides a dedicated, isolated connection that has consistent bandwidth and latency, which makes it ideal for enterprise environments.

:::image type="complex" border="false" source="./images/access-azure-kubernetes-service-cluster-expressroute-architecture.svg" alt-text="Architecture diagram that shows the traffic route from a user to a private AKS cluster. The route includes ExpressRoute and a jump box." lightbox="./images/access-azure-kubernetes-service-cluster-expressroute-architecture.svg":::
  Architecture diagram that shows the traffic route from a user to a private AKS cluster. The route includes ExpressRoute and a jump box. First, a user initiates RDP or SSH traffic to the jump box from an on-premises workstation. The jump box traffic leaves the customer edge routers and travels on a fiber connection to the meet-me location where the ExpressRoute circuit resides. The traffic reaches the Microsoft Enterprise Edge (MSEE) devices and then enters the Azure fabric. The jump box traffic reaches the ExpressRoute gateway, which serves as both the ingress and egress point for the Azure virtual network infrastructure. The traffic then reaches the jump box where an attempt to connect to the AKS private cluster is made. The hub virtual network has a virtual network link to the AKS private DNS zone to resolve the FQDN of the private cluster. Both the hub and spoke virtual networks communicate via virtual network peering. To reach the private AKS cluster, the traffic enters the Azure backbone where a private endpoint establishes a private, isolated connection to the cluster. Finally, the traffic reaches the API server of the private AKS cluster, which allows the user to manage pods, nodes, and applications.  
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/US-1956833-access-azure-kubernetes-service-cluster-api-server-architecture.vsdx) of this architecture.*

### Dataflow

1. A user initiates RDP or SSH traffic to the jump box from an on-premises workstation.

1. The jump box traffic leaves the customer edge routers and travels on a fiber connection to the meet-me location where the ExpressRoute circuit resides. The traffic reaches the Microsoft Enterprise Edge (MSEE) devices there. Then it enters the Azure fabric.

1. The jump box traffic reaches the ExpressRoute gateway, which is both the ingress and egress point of the Azure virtual network infrastructure.

1. The traffic reaches the jump box. The attempt to connect to the AKS private cluster is made from the jump box. The hub virtual network has a virtual network link to the AKS private DNS zone to resolve the FQDN of the private cluster.

1. The hub virtual network and the spoke virtual network communicate with each other by using a virtual network peering.

1. To reach the private AKS cluster, the traffic enters the Azure backbone. A private endpoint establishes a private, isolated connection to the private AKS cluster.

1. The traffic reaches the API server of the private AKS cluster. The user can then manage pods, nodes, and applications.

> [!NOTE]
> ExpressRoute requires a non-Microsoft connectivity provider to provide a peering connection to the MSEE routers. [ExpressRoute traffic isn't encrypted](/azure/expressroute/expressroute-introduction).

## Run aks command invoke

With an AKS private cluster, you can connect from a VM that has access to the API server. Use the Azure CLI `aks command invoke` command to run commands like `kubectl` or `helm` remotely via the Azure API. This approach creates a transient pod in the cluster, which lasts only during the command. The `aks command invoke` command serves as an alternative connection method if you lack a VPN, ExpressRoute, or peered virtual network. Ensure that your cluster and node pool have sufficient resources to create the transient pod.

For more information, see [Use command invoke to access a private AKS cluster](/azure/aks/command-invoke).

## Connect Cloud Shell to a subnet

When you deploy Cloud Shell into a virtual network that you control, you can interact with resources inside that network. Deploying Cloud Shell into a subnet that you manage enables connectivity to the API server of an AKS private cluster. This deployment allows you to connect to the private cluster. For more information, see [Deploy Cloud Shell into an Azure virtual network](/azure/cloud-shell/private-vnet).

## Use SSH and Visual Studio Code for testing

SSH securely manages and accesses files on a remote host by using public-private key pairs. From your local machine, you can use SSH with the Visual Studio Code Remote - SSH extension to connect to a jump box in your virtual network. The encrypted SSH tunnel terminates at the public IP address of the jump box, which makes it easy to modify Kubernetes manifest files.

To learn how to connect to your jump box via SSH, see [Remote development over SSH](https://code.visualstudio.com/docs/remote/ssh-tutorial).

If you can't connect to your VM over SSH to manage your private cluster:

- Check the inbound NSG rule for the VM subnet. The default NSG rule blocks all inbound traffic from outside Azure, so create a new rule that allows SSH traffic from your local machine's public IP address.

- Check the certificate location and verify the correct placement of the certificates. Ensure that the private key is in the `C:\Users\User\.ssh\id_rsa` directory on your local machine, and that the public key is located in the `~/.ssh/id_rsa.pub` file on the VM in Azure.

> [!NOTE]
> We recommend that you:
>
> - Avoid using a public IP address to connect to resources in production environments. Only use public IP addresses in development or testing environments. In these scenarios, create an inbound NSG rule to allow traffic from your local machine's public IP address. For more information about NSG rules, see [Create, change, or delete an NSG](/azure/virtual-network/manage-network-security-group).
>
> - Avoid using SSH to connect directly to AKS nodes or containers. Instead, use a dedicated external management solution. This practice is especially important when you use the `aks command invoke` command, which creates a transient pod within your cluster for proxied access.

## Conclusion

- You can access your AKS cluster's API server over the internet if the public FQDN is enabled.

- Cloud Shell is a built-in command-line shell in the Azure portal that you can use to connect to an AKS cluster.

- For more secure access, use Azure Bastion and a private endpoint.

- VPNs and ExpressRoute provide hybrid connectivity to your private AKS cluster.

- If no external connectivity solution is available, you can use `aks command invoke` remotely.

- You can deploy Cloud Shell directly into a virtual network that you manage to access the private cluster.

- You can use Visual Studio Code with SSH on a jump box to encrypt the connection and simplify manifest file modification. However, this approach exposes a public IP address in your environment.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

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
- [What is ExpressRoute?](/azure/expressroute/expressroute-introduction)
- [What is Azure VPN Gateway?](/azure/vpn-gateway/vpn-gateway-about-vpngateways)

## Related resources

- [Baseline architecture for an AKS cluster](../../reference-architectures/containers/aks/baseline-aks.yml)
- [Advanced AKS microservices architecture](../../reference-architectures/containers/aks-microservices/aks-microservices-advanced.yml)
- [AKS architecture design](../../reference-architectures/containers/aks-start-here.md)
