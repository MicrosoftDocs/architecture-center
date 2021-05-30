


This reference architecture shows how to connect an on-premises standalone server to Microsoft Azure virtual networks by using the Azure Network Adapter that you deploy through Windows Admin Center (WAC). Azure Network Adapter creates a secured virtual connection over the internet, thereby extending your on-premises network into Azure.

![Use Azure VPN to connect a standalone server to an Azure virtual network by deploying an Azure Network Adapter using Windows Admin Center. You then can manage the Azure virtual machines (VMs) from the standalone server by using the VMs private IP address.][architectual-diagram]

![Deploy an Azure Network Adapter using Windows Admin Center to connect a standalone server via Azure VPN to a corporate network's Azure virtual network, a branch office, or another cloud provider's network. You then can use the standalone server to manage the Azure VMs via their private IP addresses, from any locations.][architectual-diagram-large]

*Download a [Visio file][architectual-diagram-visio-source] of these architectures.*

## Architecture

The architecture consists of the following components:

- **On-premises network**. This is an organization's private local area network (LAN).
- **Branch office**. This is a private LAN in a remote branch office that connects through a corporate wide area network (WAN).
- **Other cloud provider**. This is a private virtual network that a cloud provider offers, which connects through a virtual private network (VPN).
- **Windows Server with Windows Admin Center installed**. The server that you use to deploy the Azure Network Adapter.
- **Windows Server (standalone)**. The server on which the Azure Network Adapter is installed. This server can be on a branch-office network or in a different cloud provider's network.
- **Azure Virtual Network (VNet)**. The virtual servers, and other services and components, for the Azure VPN Gateway that reside in the same virtual network inside Azure.
- **Azure VPN Gateway**. The VPN Gateway service that enables you to connect the virtual network to the on-premises network or standalone servers through a VPN appliance or Azure Network Adapters. For more information, refer to [Connect an on-premises network to a Microsoft Azure virtual network][1]. There are several pricing tiers, or stock keeping units (SKUs), available for VPN gateways, and each SKU supports different requirements based on the types of workloads, throughputs, features, and service-level agreements (SLAs). The VPN gateway includes the following components:
  - **Virtual network gateway (active)**. This Azure resource provides a virtual VPN appliance for the virtual network, and it's responsible for routing traffic back and forth between the on-premises network and the virtual network.
  - **Virtual network gateway (passive)**. This Azure resource provides a virtual VPN appliance for the virtual network, and it's the standby instance of the active Azure VPN Gateway. For more information, refer to [About Azure VPN gateway redundancy][2].
  - **Gateway subnet**. The virtual network gateway is held in its own subnet, which is subject to various requirements that the following Recommendations section details.
  - **Connection**. The connection has properties that specify the connection type, such as Internet Protocol security (IPsec), and the key shared with the on-premises VPN appliance to encrypt traffic.
- **Cloud application**. This is the application that is hosted in Azure, and it can include multiple tiers with multiple subnets that connect through Azure load balancers. For more information about the application infrastructure, refer to [Running Windows VM workloads][reference-architecture-windows-vm] and [Running Linux VM workloads][reference-architecture-linux-vm].
- **Internal load balancer**. Network traffic from the VPN gateway is routed to the cloud application through an internal load balancer, which is in the application's production subnet.
- **Azure Bastion**. Azure Bastion allows you to log into VMs in the Azure virtual network by using Secure Shell (SSH) or Remote Desktop Protocol (RDP), without exposing the VMs directly to the internet. If you lose VPN connectivity, you can still use Azure Bastion to manage your VMs in the Azure virtual network. However, the management of on-premises servers through Azure Bastion is not supported.

## Recommendations

The following recommendations apply for most scenarios. Follow these recommendations unless you have a specific requirement that overrides them.

### Connect a standalone server

To connect a standalone server through the WAC, you must add the server to the managed-servers list in the dedicated server's WAC installation. After you add the server to that list, you can select the server for which you want to install the Azure Network Adapter, and then select **Network** from the tools followed by the "+ Add Azure Network Adapter (Preview)" option in the **Network** pane.

> [!TIP]
> If you do not see the "+ Add Azure Network Adapter (Preview)" option in your browser window, you might need to enlarge your window, or you might observe an **Action** button with a drop-down caret. Select the drop-down caret to access the option and add the Azure Network Adapter.
>

When you select the **+ Add Azure Network Adapter (Preview)** option, the **Add Azure Network Adapter** configuration blade opens in a browser window. There are several options you can configure within this blade.

> [!NOTE]
> If you haven't previously authenticated from the WAC against the Azure tenant that you want to use, an authentication dialog will appear. Provide your tenant's authentication information to proceed. The user credentials that you use to authenticate must have sufficient permissions to create the Azure resources you'll configure during subsequent steps.
>

The following information is necessary:

| Field | Value | Additional information |
| :-- | :-- | :-- |
| **Subscription** | Select from drop-down | This field lists only subscriptions assigned to your tenant. |
| **Location** | Select from drop-down | Select an Azure region for your deployment. |
| **Virtual Network** | Select from drop-down or use the provided hyperlink to [Create a new Virtual Network in Azure Portal][3] | Depending on your selection, the field's contents will vary. If the Virtual Network exists, you'll observe a hyperlink that you can follow to review the Virtual Network in the Azure portal. If the selected VNet already contains a VNet Gateway, an additional hyperlink to that Azure resource will be provided. |
| **Gateway Subnet** | Subnet prefix, such as 10.0.1.0/24 | Depending on the selected Virtual Network, this field will vary. If the selected VNet contains no subnet labeled **GatewaySubnet**, the field will be prefilled with a subnet prefix that includes the address range and subnet mask. If the selected VNet already contains a VNet Gateway, an additional hyperlink to that Azure resource will be provided. |
| **Gateway SKU** | Select from drop-down | For more information, refer to the [Gateway SKUs][4]. |
| **Client Address Space** | Subnet prefix, such as 192.168.1.0/24 | The field will be prefilled with a subnet prefix that includes the address range and subnet mask, and it's the network that will be used between the server to which you add the Azure Network Adapter and the Azure VPN Gateway. It must have an address range that doesn't overlap with any of the address ranges that are used on-premises or in any of the connected Azure Virtual Networks. |
| **Authentication Certificate** | Select one of the options | The "Auto-generated Self-signed root and client Certificate" option is preselected and works best in most scenarios. When you select the "Use own root and client certificate" option, you must provide two files: a root certificate (.cer) and a client certificate (.pfx), and then the password for the client certificate.

Once you complete all necessary fields, the **Create** button becomes active, and you should select it to begin your Azure Network Adapter's deployment to the selected server.

The deployment process has two major parts, the first of which is the deployment and selection of the Azure VPN Gateway. If you need to deploy your Azure VPN Gateway first, allow for 25 to 45 minutes for the deployment to complete, as some configurations can take that long to deploy. The WAC will provide information about the deployment's progress. The second part is the actual installation of the Azure Network Adapter, which can take 10 minutes, and the WAC will notify you about the installation  progress, as well.

Once the deployment begins, you can change the focus of the WAC by selecting other tools or servers. The deployment process continues in the background.

If you select the **Auto-generated Self-signed root and client Certificate** option, Azure creates the two required certificates for you automatically and stores them in the selected server's certificate store. You can use the **Certificates** tool in the WAC to find them, and then you can locate a root certificate in the Local Machine/Root container. The certificate's name begins with **Windows Admin Center-Created-vpngw** and contains the additional **P2SRoot** string. The string's tail includes a timestamp encoded with the certificate's creation date. This certificate will also be stored in the Local Machine/CA container.
The second certificate is stored in the Local Machine/My container. The name of this certificate starts with **Windows Admin Center-Created-vpngw** and contains the additional **P2SClient** string. The string's tail includes a timestamp encoded with the certificate's creation date.

After the deployment finishes, the selected server's **Networks** tool is updated with the new Azure Network Adapter, which automatically starts after the deployment ends and indicates an active status. You can select the adapter to activate the **More** drop-down list, which you can select to disconnect or delete the adapter. On the actual server, the Azure Network Adapter is installed as a VPN connection. The adapter's name begins with **Windows Admin CenterVPN-** followed by a random three-digit number.

When the Azure Network Adapter is installed and connected, you can use this new network connection to connect directly to the Azure VNets and their systems. This type of connection is typically used to establish a remote-desktop session via an Azure VM's internal IP address rather than by using the VM's public IP address.  

### Using a dedicated WAC server

For a centralized administration, we recommend that you use a dedicated Windows Admin Server installation, from which you can add other servers. This approach means that none of the administered servers requires additional software. For more information about WAC, refer to [Microsoft docs][5].

### Prepare a dedicated VNet

In some scenarios, the Azure Network Adapter's installation interface might not meet your needs with respect to naming conventions or the pricing tier. To avoid this conflict, you can create the requisite Azure resources before you deploy the adapter. During the deployment, you select the already existing resources instead of creating them through the installation interface.

> [!NOTE]
> Make sure you select the correct VPN Gateway SKU, as not all of them support the VPN connection that comes with the Azure Network Adapter. The installation dialog offers you VpnGw1, VpnGw2, and VpnGw3. Currently, the adapter doesn't support the zone-redundant versions of the VPN Gateway.
>

## Scalability considerations

- VPN Gateway SKU:
  - The [VPN Gateway SKU][4] you're selecting determines how many connections it can take in parallel, as well as the bandwidth that is available to all of those connections. The number of concurrent connections varies from 250 to 1,000 when you're using the **P2S IKEv2/OpenVPN** option. IKE refers to *IPsec Key Exchange*. It's advisable to begin with VpnGw1 and scale out later if you need more connections. If you need to switch the VPN Gateway generation, you need to install a new gateway and deploy a new Azure Network Adapter to connect to it.
- Connect multiple standalone servers:
  - You can use the WAC to deploy the Azure Network Adapter to as many servers as you need, and you also can also add multiple Azure Network Adapters to a single server to connect to different Azure VNets. Once the initial deployment of the VPN Gateway is complete, you can configure subsequent servers to use the same gateway by selecting the existing gateway in the installation interface.
  - Standalone servers can be located on the same network, on a branch-office network, or on a different cloud-based network. You can use the network connection that you've established, such as your corporate WAN or a dedicated VPN to a different cloud provider, if the required network ports are available through these connections. For more information, refer to the "Security considerations" section in this article.
- Azure Site-to-Site connection:
  - The Azure Network Adapter is a single installation on a single server, but if you want to connect several servers, you could face a significant administrative effort. However, you can avoid this effort by connecting your on-premises systems using the [Azure Site-2-Site][7] connection (S2S) method, which connects an existing on-premises network to an Azure VNet and its subnets. At this connection's core is an Azure VPN Gateway through which you can connect a local, on-premises VPN gateway with the remote Azure VPN Gateway. This secure connection allows the two network segments to  communicate transparently with each other.

## Availability considerations

- The Azure Network Adapter only supports an active-passive configuration of the Azure VPN Gateway. During the adapter's configuration, you can point to an existing [active-active Azure VPN gateway][8]. The setup will reconfigure the gateway to the active-passive configuration. A manual gateway reconfiguration to the active-active state is possible, but the Azure Network Adapter won't connect to this gateway.
  > [!WARNING]
  > Configuring an Azure Network Adapter against an existing Azure VPN Gateway with an active-active configuration will reconfigure the gateway to active-passive. This will impact all existing VPN connections to this gateway. Changing from active-active configuration to active-standby configuration will cause a drop of one of the two IPsec VPN tunnels for each connection. *Do not proceed* without evaluating your overall connection requirements and consulting with your network administrators.
  >

## Manageability considerations

- Administrative account:
  - The WAC is the core tool that you use to deploy the Azure Network Adapter and configure account handling. For more information about the available options, refer to [User access options with Windows Admin Center][9]. You can configure an individual account per server connection.
    > [!NOTE]
    > The dialog box in which you configure the administrative account per server will validate your credentials when you select **Continue**. To open the dialog box, in the WAC, select the row with the applicable server name, and then select **Manage as**. *Do not* select the hyperlink that represents the server, as it'll connect you to that server immediately.
    >

  - Additionally, you must configure a user account for the Azure connection by opening the **Settings** dialog box in the WAC and modifying the account section. You also can switch users or log out of a user's session in the **Settings** dialog box.
- Azure Recovery Vault integration:
  - When you install Azure Network Adapter on a standalone server, you then can consider that server a port for your business continuity. You can integrate that server into your back-up and disaster-recovery procedures by using Azure Recovery Vault services that you configure by selecting **Azure Backup** in the **Tools** section of the WAC. Azure Backup helps protect your Windows server from corruptions, attacks, or disasters by backing up your server directly to Microsoft Azure.

## Security considerations

- Required network ports:
  - Network ports for PowerShell remoting must be open if you want to use the WAC to deploy the Azure Network Adapter.
  - PowerShell Remoting uses [Windows Remote Management][10] (WinRM). For more information, refer to [PowerShell Remoting Security Considerations][11] and [PowerShell Remoting default settings][12].
  - In some scenarios, you're required to use additional authentication methods. WAC can use PowerShell in conjunction with the Credential Security Support Provider protocol (CredSSP) to connect to remote servers. For more information, refer to [PowerShell Remoting and CredSSP][13] and how [Windows Admin Center uses CredSSP][14].
  - PowerShell Remoting (and WinRM) use the following ports:
    | Protocol | Port |
    | :-- | :-- |
    | HTTP | 5985 |
    | HTTPS | 5986 |
  - How you connect to the server on which the Windows Admin Center (WAC) is installed depends on your WAC's installation type. The default port varies and can be port 6516 when installed on Windows 10 or port 443 when installed on Windows Server. For more information, refer to [Install Windows Admin Center][15].
- Azure Security Center integration:
  - To help protect the server on which the Azure Network Adapter is installed, you can integrate the server to Azure Security Center by selecting **Azure Security Center** from the **Tools** section in WAC. During the integration, you must select an existing Azure Log Analytics workspace or create a new one. You'll be billed separately for each server that you integrate with Azure Security Center. For more information, refer to [Azure Security Center pricing][16].

## DevOps considerations

- Azure Automation:
  - The WAC gives you access to the PowerShell code that creates the Azure Network Adapter, and you can review it by selecting the **Network** tool, and then selecting the **View PowerShell scripts** icon at the top of the WAC page. The script's name is **Complete-P2SVPNConfiguration**, and it's implemented as a PowerShell function. The code is digitally signed and ready to be reused, and you can integrate it into [Azure Automation][17] by configuring additional services inside the Azure portal.

## Cost considerations

- Azure Pricing Calculator:
  - Using the Azure Network Adapter doesn't actually cost anything, as it's a component that you deploy to an on-premises system. The Azure VPN Gateway, as part of the solution, does generate additional costs, as does the use of additional services, such as Azure Recovery Vault or Azure Security Center. For more information about actual costs, refer to the [Azure Pricing Calculator][18]. It's important to note that actual costs vary by Azure region and your individual contract. Contact a Microsoft sales representative for additional information about pricing.
- Egress costs:
  - There are additional costs associated with outbound Inter-VNet data transfers, and they're dependent on your VPN Gateway's SKU and the actual amount of data you're using. For more information, refer to the [Azure Pricing Calculator][18]. It's important to note that actual costs vary by Azure region and your individual contract. Contact a Microsoft sales representative for additional information about pricing.

## Next steps

- Learn more about Azure Network Adapter in the blog article, [Top 10 Networking Features in Windows Server 2019][20].
- Learn more about [Point-to-Site VPN][21].
- Download the [Windows Admin Center][22].

[architectual-diagram]: ./images/azure-network-adapter.png
[architectual-diagram-large]: ./images/azure-network-adapter-large.png
[architectual-diagram-visio-source]: https://arch-center.azureedge.net/azure-network-adapter.vsdx
[1]: /office365/enterprise/connect-an-on-premises-network-to-a-microsoft-azure-virtual-network
[2]: /azure/vpn-gateway/vpn-gateway-highlyavailable#about-azure-vpn-gateway-redundancy
[3]: https://portal.azure.com/#create/Microsoft.VirtualNetwork-ARM
[4]: /azure/vpn-gateway/vpn-gateway-about-vpn-gateway-settings#gwsku
[5]: /windows-server/manage/windows-admin-center/overview
[6]: /azure/vpn-gateway/vpn-gateway-about-vpn-gateway-settings#gwsku
[7]: /azure/vpn-gateway/vpn-gateway-howto-site-to-site-resource-manager-portal
[8]: /azure/vpn-gateway/vpn-gateway-highlyavailable#active-active-azure-vpn-gateway
[9]: /windows-server/manage/windows-admin-center/plan/user-access-options
[10]: /windows/win32/winrm/portal
[11]: /powershell/scripting/learn/remoting/winrmsecurity?view=powershell-7
[12]: /powershell/scripting/learn/remoting/winrmsecurity?view=powershell-7#powershell-remoting-default-settings
[13]: /powershell/scripting/learn/remoting/ps-remoting-second-hop?view=powershell-7#credssp
[14]: /windows-server/manage/windows-admin-center/understand/faq#does-windows-admin-center-use-credssp
[15]: /windows-server/manage/windows-admin-center/deploy/install
[16]: /azure/security-center/security-center-pricing
[17]: /azure/automation/
[18]: https://azure.microsoft.com/pricing/calculator/
[19]: https://azure.microsoft.com/pricing/calculator/
[20]: https://techcommunity.microsoft.com/t5/networking-blog/top-10-networking-features-in-windows-server-2019-3-azure/ba-p/339780
[21]: /azure/vpn-gateway/point-to-site-about
[22]: https://www.microsoft.com/en-us/evalcenter/evaluate-windows-admin-center
[reference-architecture-windows-vm]: ../reference-architectures/n-tier/windows-vm.yml
[reference-architecture-linux-vm]: ../reference-architectures/n-tier/linux-vm.yml
