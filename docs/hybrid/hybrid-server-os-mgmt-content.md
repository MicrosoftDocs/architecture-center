This reference architecture illustrates how to design a hybrid Windows Admin Center solution to manage workloads that are hosted on-premises and in Microsoft Azure. This architecture includes two scenarios:

- Windows Admin Center deployed to a virtual machine (VM) in Azure.
- Windows Admin Center deployed to a server (physical or virtual) on-premises.

## Architecture

The first diagram illustrates Windows Admin Center deployed to a VM in Azure.

![Deploy Windows Admin Center to a VM in Azure. Use VPN or ExpressRoute to manage on-premises VMs.][architectural-diagram-azure]

The second diagram illustrates Windows Admin Center deployed on-premises.

![Deploy Windows Admin Center to a VM on-premises. Use Azure network adapter to integrate with resources in Azure.][architectural-diagram-onprem]

*Download a [Visio file][architectural-diagram-visio-source] of all architectures diagrams in this article.*

### Workflow

The architecture consists of the following:

- **On-premises corporate network**. A private local area network that runs within an organization.
- **On-premises corporate firewall**. An organizational firewall configured to allow users access to the Windows Admin Center gateway when the gateway is deployed on-premises.
- **Windows VM**. A Windows VM installed with the Windows Admin Center gateway that hosts web services that users can connect to.
- **Azure AD app**. An app used for all points of Azure integration in Windows Admin Center, including Azure Active Directory (Azure AD) authentication to the gateway.
- **Managed nodes**. Nodes managed by Windows Admin Center, which might include physical servers running Azure Stack, or Windows Server or virtual machines running Windows Server.
- **VPN or ExpressRoute**. A Site-to-Site (S2S) VPN or ExpressRoute to manage nodes on-premises when Windows Admin Center is deployed in Azure.
- **Azure network adapter**. An adapter for a Point-to-Site (P2S) VPN to Azure when Windows Admin Center is deployed on-premises. Windows Admin Center can automatically deploy the adapter and also create an Azure gateway.
- **Domain Name System (DNS)**. A DNS record that users reference to connect to the Windows Admin Center gateway.

### Components

- [Windows Admin Center](/windows-server/manage/windows-admin-center/understand/what-is) is a browser-based management tool set that gives you full control over all aspects of your server infrastructure and is particularly useful for managing servers on private networks that are not connected to the Internet. It accesses servers through the Windows Admin Center gateway that's installed on Windows Server or on domain-joined Windows 10. The gateway can be installed on-premises or on an Azure VM that runs Windows.
- [Azure ExpressRoute](https://azure.microsoft.com/products/expressroute) creates private connections between Azure datacenters and infrastructure on premises or in a colocation environment.
- [Azure Virtual Network](https://azure.microsoft.com/products/virtual-network) provides secure network infrastructure in the cloud.
- [Azure Virtual Machines](https://azure.microsoft.com/products/virtual-machines) provides Linux and Windows virtual machines. In this solution, you can use it to provide a Windows VM to run Windows Admin Center.

## Scenario details

### Potential use cases

Typical uses for this architecture include:

- Organizations that want to manage individual Windows Server instances, Hyper-Converged Infrastructure or Hyper-V VMs that run on-premises and in Microsoft Azure.
- Organizations that want to manage Windows Server instances hosted by other cloud providers.

## Recommendations

The following recommendations apply for most scenarios. Follow these recommendations unless you have a specific requirement that overrides them.

### Installation types

You have multiple options when deploying Windows Admin Center, including installing on a Windows 10 PC, a Windows server, or an Azure VM. The deployment type you choose will depend on your business requirements.

The on-premises installation types are:

![Installation types when deploying Windows Admin Center on-premises. Deployment options depend on your business requirements.][onprem-installation-type]

- **Option 1: Local Client.** Deploy Windows Admin Center on a Windows 10 client. This is ideal for quick deployments, testing, and improvised or small-scale scenarios.
- **Option 2: Gateway Server.** Install on a designated gateway server running Windows Server 2016, Windows Server 2019, or later, and access from any client browser with connectivity to the gateway server.
- **Option 3: Managed Server.** Install directly on a managed server running Windows Server 2016, Windows Server 2019, or later to enable the server to manage itself or a cluster in which the managed server is a member node. This is great for distributed branch office scenarios.
- **Option 4: Failover Cluster.** Deploy in a failover cluster to enable high availability of the gateway service. This is great for production environments to ensure management service resiliency.

Because Windows Admin Center has no cloud service dependencies, some organizations might choose to deploy Windows Admin Center to an on-premises system for managing on-premises computers and then enable hybrid services over time. However, many organizations prefer to take advantage of service offerings in Azure and other cloud platforms that are integrated with Windows Admin Center.

Deploying Windows Admin Center on an Azure VM provides gateway functionality similar to Windows Server 2016 and Windows Server 2019. However, Azure also enables additional features for Azure VMs. Refer to [Reliability](#reliability) for more information about the benefits of deploying Windows Admin Center to Azure VMs.

### Automated deployment

Microsoft provides an .msi file that you use to deploy Windows Admin Center to an on-premises VM. The .msi file installs Windows Admin Center and automatically generates a self-signed certificate or associates an existing certificate based on your preference.

> [!TIP]
> For more information about using the .msi file to deploy Windows Admin Center, refer to [Install Windows Admin Center][wac-deploy-install].

When implementing Windows Admin Center on an Azure VM, Microsoft provides the **Deploy-Windows Admin CenterAzVM.ps1** script to automatically deploy all required resources. In this scenario, the script deploys a new Azure VM with Windows Admin Center installed and opens port 443 on the public IP address. The script can also deploy Windows Admin Center to an existing Azure VM. When running the script, you can use variables to specify the resource group, virtual network name, VM name, location, and many other options.

> [!IMPORTANT]
> Prior to deployment, upload the certificate to an Azure Key Vault. Alternatively, you can use the Azure portal to generate a certificate.

> [!TIP]
> For more information about using the **Deploy-Windows Admin CenterAzVM.ps1** script to deploy Windows Admin Center to an Azure VM, refer to [Deploy Windows Admin Center in Azure][wac-deploy-script].

> [!TIP]
> For more information about the manual steps required to deploy Windows Admin Center to an Azure VM, refer to [Deploy manually on an existing Azure virtual machine][wac-deploy-manual].

### Topology recommendations

While you can implement Windows Admin Center on any existing or new VM that's on-premises or hosted in Azure, Microsoft recommends deploying Windows Admin Center gateway on a Windows Server 2019 Azure VM. The automated deployment option discussed earlier allows you to implement Windows Admin Center on an Azure VM more quickly while still safeguarding your environment. Instead of deploying Windows Admin Center on an on-premises VM, you can minimize the configuration changes required for an on-premises firewall and network.

> [!IMPORTANT]
> Managing nodes on-premises requires a connection (such as S2S VPN or ExpressRoute) from Azure to on-premises.

When deployed on-premises, you can use Windows Admin Center to build the hybrid connection to Azure. The hybrid connection, called an *Azure network adapter*, is a P2S VPN to Azure that allows Windows Admin Center to access hybrid cloud features. This process also automatically creates an Azure gateway for the VPN connection. For more information, refer to [About Point-to-Site VPN][about-p2s-vpn].

> [!IMPORTANT]
> You must have an Azure virtual network in Azure before creating an Azure network adapter.

You should also configure the Windows Admin Center gateway for high availability. This will help ensure that management of systems and services remain available during unexpected failures. Azure provides multiple service offerings for these scenarios regardless of whether Windows Admin Center gateway is deployed to an on-premises or Azure VM. Refer to *Availability Considerations* for more information.

### Certificate recommendations

Windows Admin Center gateway is a web-based tool that uses a Secure Sockets Layer (SSL) certificate to encrypt web traffic for administrators who are using the gateway. Windows Admin Center allows you to use an SSL certificate that a trusted third-party certification authority (CA) created from a self-signed certificate. You will receive a warning when trying to connect from a browser if you choose the latter option. As a result, we recommend that you only use self-signed certificates for test environments.

> [!TIP]
> To learn how other Microsoft customers have used Windows Admin Center to improve their productivity and reduce costs, refer to [Windows Admin Center Case Studies][wac-case-studies].

### Administrative recommendations

Deploying Windows Admin Center on a local Windows 10 client is great for quick-start tests, and ad-hoc or small-scale scenarios. However, for production scenarios with multiple administrators, we recommend Windows Server. When deployed on Windows Server, Windows Admin Center provides a centralized management hub for your server environment with additional capabilities such as smart card authentication, conditional access, and multi-factor authentication. For more information about controlling access to Windows Admin Center, refer to [User Access Options with Windows Admin Center][user-access-options].

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

Reliability ensures that your application can meet the commitments that you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

- You can help ensure high availability of the Windows Admin Center gateway service by deploying it in an active/passive model on a failover cluster. In this scenario, only one instance of the Windows Admin Center gateway service is active. If one of the nodes in the cluster fails, the Windows Admin Center gateway service seamlessly fails over to another node.
  > [!CAUTION]
  > Deploying Windows Admin Center on a Windows 10 client computer doesn't provide high availability because gateway functionality isn't included with the Windows 10 deployment. Deploy the Windows Admin Center gateway to Windows Server 2016 or Windows Server 2019.
- To help ensure high availability of Windows Admin Center data in case of a node failure, configure a Cluster Shared Volume (CSV) into which Windows Admin Center will store persistent data that all the nodes in the cluster access. You can deploy the failover cluster for Windows Admin Center gateway by using an automated deployment script. The **Install-WindowsAdminCenterHA.ps1** script automatically deploys the failover cluster, configures IP addresses for the cluster service, installs Windows Admin Center gateway, configures the port number for the gateway service, and configures the web service with the appropriate certificate.
  > [!TIP]
  > For more information about using the automated deployment script, refer to [Deploy Windows Admin Center with high availability][wac-deploy-ha].

- Deploying Windows Admin Center gateway to an Azure VM provides additional high-availability options. For example, by using availability sets you can provide VM redundancy and availability within an Azure datacenter by distributing the VMs across multiple hardware nodes. You can also use availability zones in Azure, which provide datacenter fault tolerance. Availability zones are unique physical locations that span datacenters within an Azure region. This helps ensure that Azure VMs have independent power, cooling, and networking. For more information on high availability, refer to [Availability options for virtual machines in Azure][azure-vm-availability] and [High availability and disaster recovery for IaaS apps][iaas-ha-dr].

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

- Deploying Windows Admin Center provides your organization with a centralized management interface for your server environment. By controlling access to Windows Admin Center, you can improve the security of your management landscape.
- Windows Admin Center provides multiple features to help secure your management platform. For starters, Windows Admin Center gateway authentication can use local groups,  Active Directory Domain Services (AD DS), and cloud-based Azure AD. You can also enforce smart card authentication by specifying an additional required group for smart card-based security groups. And, by requiring Azure AD authentication for the gateway, you can use other Azure AD security features such as conditional access and Azure Active Directory Multi-Factor Authentication.
- Access to the Windows Admin Center gateway doesn't imply access to the target servers that are made visible by the gateway. To manage a target server, users must connect with credentials that grant administrator privileges on the servers they want to manage. However, some users might not need administrative access to perform their responsibilities. In this scenario, you can use role-based access control (RBAC) in Windows Admin Center to provide these users with limited access to servers rather than granting them full administrative access.
  > [!NOTE]
  > If you deployed Local Administrator Password Solution (LAPS) in your environment, use LAPS credentials through Windows Admin Center to authenticate with a target server.
- In Windows Admin Center, RBAC works by configuring each managed server with a Windows PowerShell *Just Enough Administration* endpoint. This endpoint defines the roles, including which parts of the system each role can manage and which users are assigned to the roles. When a user connects to the endpoint, RBAC creates a temporary local administrator account to manage the system on their behalf and automatically removes the account when the user stops managing the server through the Windows Admin Center. For more information, refer to [Just Enough Administration][azure-jet].
- Windows Admin Center also provides visibility into the management actions performed in your environment. Windows Admin Center records events by logging actions to the **Microsoft-ServerManagementExperience** event channel in the event log of the managed server. This allows you to audit actions that administrators perform, and helps you troubleshoot Windows Admin Center issues and review usage metrics. For more information on auditing, refer to [Use event logging in Windows Admin Center to gain insight into management activities and track gateway usage][wac-logging].

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

- For on-premises deployments, Windows Admin Center costs nothing beyond the cost of the Windows operating system, which requires valid Windows Server or Windows 10 licenses.
- For Azure deployments, plan for costs associated with deploying Windows Admin Center to an Azure VM. Some of these costs might include the VM, storage, static or public IP addresses (if enabled), and any networking components required for integration with on-premises environments. In addition, you might need to plan for the cost of purchasing non-Microsoft CA certificates.

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

#### Manageability

- Access to the Windows Admin Center management tool set depends on the installation type. For example, in a local client scenario, you would open the Windows Admin Center from the **Start** menu and connect to it from a client web browser by accessing `https://localhost:6516`. In other scenarios where you deploy the Windows Admin Center gateway to a Window Server, you can connect to the Windows Admin Center gateway from a client web browser by accessing the server name URL, such as `https://servername.contoso.com`, or the URL of the cluster name.
- When deployed on Windows Server, Windows Admin Center provides a centralized point of management for your server environment. Windows Admin Center provides management tools for many common scenarios and tools, including:
  - Certificate management
  - Event Viewer
  - File Explorer
  - Network settings
  - Remote Desktop Connection
  - Windows PowerShell
  - Firewall management
  - Registry editing
  - Enabling and disabling roles and features
  - Managing installed apps and devices
  - Managing scheduled tasks
  - Configuring local users and groups
  - Managing Windows services
  - Managing storage
  - Managing Windows Update

For a complete list of server management capabilities, refer to [Manage Servers with Windows Admin Center][wac-manage-servers].

  > [!IMPORTANT]
  > Windows Admin Center doesn't replace all Remote Server Administration Tools (RSAT), such as Internet Information Services (IIS), because there is no equivalent management capability for it in Windows Admin Center.

  > [!NOTE]
  > Windows Admin Center provides a subset of Server Manager features for managing Windows 10 client PCs.

- Windows Admin Center provides support for managing failover clusters and cluster resources, managing Hyper-V VMs and virtual switches, and managing Windows Server Storage Replica. In addition to using Windows Admin Center to manage and monitor an existing Hyper-Converged Infrastructure, you can also use Windows Admin Center to deploy a new Hyper-Converged Infrastructure. By using a multistage workflow, Windows Admin Center guides you through installing features, configuring networking, creating a cluster, and deploying Storage Spaces Direct and Software-Defined Networking. For more information, refer to [Manage Hyper-Converged Infrastructure with Windows Admin Center][wac-manage-hyper-converged].
  > [!NOTE]
  > You can use Windows Admin Center to manage Microsoft Hyper-V Server 2016 or Microsoft Hyper-V Server 2019 (the free Microsoft virtualization product).

- The Azure hybrid services tool in Windows Admin Center provides a centralized location for all the integrated Azure services. You can use Azure hybrid services to protect VMs in Azure and on-premises with cloud-based backup and disaster recovery. You can also extend on-premises capacity with storage and compute in Azure, and you can simplify network connectivity to Azure. With the help of cloud-intelligent Azure management services, you can centralize monitoring, governance, configuration, and security across your applications, network, and infrastructure.

![Windows Admin Center provides a centralized location of all the integrated Azure services. You can use the Azure hybrid services tool to manage the hybrid features of VMs in Azure and on-premises.][azure-hybrid-services-tool]

  > [!TIP]
  > For more information on Azure integration, refer to [Connecting Windows Server to Azure hybrid services][azure-hybrid-services].

  > [!IMPORTANT]
  > The Azure AD app requires Azure integration in Windows Admin Center.

#### DevOps

- Windows Admin Center was built for extensibility so that Microsoft and other developers can build tools and solutions beyond the current offerings. Windows Admin Center provides an extensible platform in which each connection type and tool is an extension that you can install, uninstall, and update individually. Microsoft offers a software development kit (SDK) that enables developers to build their own tools for Windows Admin Center.
- You can build Windows Admin Center extensions using modern web technologies&mdash;including HTML5, CSS, Angular, TypeScript, and jQuery&mdash;to manage target servers via Windows PowerShell or Windows Management Instrumentation. You can also manage target servers, services, and devices over different protocols such as Representational State Transfer (REST) by building a Windows Admin Center gateway plugin.
  > [!TIP]
  > For more information about using the SDK to develop extensions for Windows Admin Center, refer to [Extensions for Windows Admin Center][wac-sdk].

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Mike Martin](https://www.linkedin.com/in/techmike2kx) | Senior Cloud Solution Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

More about Azure Automation:

- [Install Windows Admin Center](/windows-server/manage/windows-admin-center/deploy/install)
- [Preview: Use Windows Admin Center in the Azure portal to manage a Windows Server VM](/windows-server/manage/windows-admin-center/azure/manage-vm)
- [Manually deploy Windows Admin Center in Azure for managing multiple servers](/windows-server/manage/windows-admin-center/azure/deploy-wac-in-azure)
- [Connect hybrid machines to Azure from Windows Admin Center](/azure/azure-arc/servers/onboard-windows-admin-center)

## Related resources

- [Connect standalone servers by using Azure Network Adapter](/azure/architecture/hybrid/azure-network-adapter)
- [Use Azure Stack HCI stretched clusters for disaster recovery](/azure/architecture/hybrid/azure-stack-hci-dr)
- [Manage configurations for Azure Arc-enabled servers](/azure/architecture/hybrid/azure-arc-hybrid-config)
- [Use Azure Stack HCI switchless interconnect and lightweight quorum for remote office or branch office](/azure/architecture/hybrid/azure-stack-robo)

[architectural-diagram-azure]: ./images/hybrid-server-os-mgmt-wac-azure.svg
[architectural-diagram-onprem]: ./images/hybrid-server-os-mgmt-wac-onprem.svg
[architectural-diagram-visio-source]: https://arch-center.azureedge.net/hybrid-server-os-mgmt.vsdx
[onprem-installation-type]: ./images/hybrid-server-os-mgmt-wac-onprem-install-type.svg
[wac-case-studies]: /windows-server/manage/windows-admin-center/understand/case-studies
[user-access-options]: /windows-server/manage/windows-admin-center/plan/user-access-options
[wac-deploy-install]: /windows-server/manage/windows-admin-center/deploy/install
[wac-deploy-script]: /windows-server/manage/windows-admin-center/azure/deploy-wac-in-azure
[wac-deploy-manual]: /windows-server/manage/windows-admin-center/azure/deploy-wac-in-azure#deploy-manually-on-an-existing-azure-virtual-machine
[about-p2s-vpn]: /azure/vpn-gateway/point-to-site-about
[wac-deploy-ha]: /windows-server/manage/windows-admin-center/deploy/high-availability
[azure-vm-availability]: /azure/virtual-machines/windows/availability
[iaas-ha-dr]: ../example-scenario/infrastructure/iaas-high-availability-disaster-recovery.yml
[wac-manage-servers]: /windows-server/manage/windows-admin-center/use/manage-servers
[wac-manage-hyper-converged]: /windows-server/manage/windows-admin-center/use/manage-hyper-converged
[azure-hybrid-services-tool]: ./images/hybrid-server-os-mgmt-wac-azure-hybrid-services-tool.png
[azure-hybrid-services]: /windows-server/manage/windows-admin-center/azure
[azure-jet]: /powershell/scripting/learn/remoting/jea/overview?view=powershell-7
[wac-logging]: /windows-server/manage/windows-admin-center/use/logging
[wac-sdk]: /windows-server/manage/windows-admin-center/extend/extensibility-overview
