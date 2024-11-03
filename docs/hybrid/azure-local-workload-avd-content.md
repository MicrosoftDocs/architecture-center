This workload reference architecture document aims to provide customer guidance on selecting and setting up an Azure Virtual Desktop workload for Azure Local, thereby streamlining the Edge solution procurement process. By leveraging trusted Reference Architectures (RAs) from Microsoft, customers can minimize the time and effort required to deploy and manage their infrastructure.

Central to this, this guide factors in workload specific design considerations, requirements, and scale limitations, offering customers a complementary tool to the existing [Azure Local catalog](https://aka.ms/hci-catalog#catalog) and [Azure Local Sizer](https://aka.ms/hci-catalog#sizer) in designing their solution.

For additional information, this document is also best used in conjunction with [Azure Local baseline reference architecture](azure-stack-hci-baseline.yml) and [Azure Local Well-Architected Framework service guide](/azure/well-architected/service-guides/azure-stack-hci), which provides guidelines and recommendations for how to deploy highly available and resilient Azure Local instances.

## Article layout

| Architecture | Design decisions | Well-Architected Framework approach|
|---|---|---|
|&#9642; [Architecture](#architecture) <br>&#9642; [Product Overview](#Product-overview) <br>&#9642;  [Platform resources](#platform-resources) <br>&#9642; [Platform-supporting resources](#platform-supporting-resources) <br>&#9642; [Deploy this scenario](#deploy-this-scenario) <br>|&#9642; [Cluster design choices](#cluster-design-choices)<br> &#9642; [Physical disk drives](#physical-disk-drives) <br> &#9642; [Network design](#network-design) <br> &#9642; [Monitoring](#monitoring) <br> &#9642; [Update management](#update-management)|&#9642; [Reliability](#reliability) <br> &#9642; [Security](#security) <br> &#9642; [Cost optimization](#cost-optimization) <br> &#9642; [Operational excellence](#operational-excellence) <br> &#9642; [Performance efficiency](#performance-efficiency)|

> [!TIP]
> ![GitHub logo](../_images/github.svg) This [Azure Virtual Desktop on Azure Local template](https://github.com/Azure/RDS-Templates/blob/master/ARM-wvd-templates/HCI/QuickDeploy/CreateHciHostpoolQuickDeployTemplate.json) demonstrates how to use an Azure Resource Management template (ARM template) and parameter file to deploy Azure Virtual Desktop session hosts deployed on Azure Local with simple configurations.

## Architecture

:::image type="complex" source="images/azure-local-workload-avd.png" alt-text="Diagram that shows a reference architecture for deploying Azure Virtual Desktop on Azure Local" lightbox="images/azure-local-workload-avd.png" border="false":::
    Diagram that shows a reference architecture for deploying Azure Virtual Desktop on Azure Local.
:::image-end:::

The diagram above provides a high-level overview of the Azure Virtual Desktop for Azure Local solution. Summarily, here are the key elements in the visual above:

1. **User Device Initiates Connection**
   - User devices (either on-premises or remote) run the Azure Virtual Desktop client and initiate a connection to the Azure Virtual Desktop service in Azure.

2. **User Authentication via Microsoft Entra ID**
   - The Azure Virtual Desktop service in Azure interacts with [Microsoft Entra ID (formerly Azure Active Directory)](https://www.microsoft.com/en-sg/security/business/identity-access/microsoft-entra-id) to authenticate the user and perform a token exchange during login. 

   - **Hybrid Identity Synchronization**: A hybrid identity sync occurs between the on-prem AD DS (Active Directory Domain Services) server and the cloud-based Microsoft Entra ID, ensuring that user identities are synchronized and available for both local authentication (for session hosts on Azure Local) and cloud access. Note that this step operates continuously in the background to keep the on-premises AD DS and Microsoft Entra ID in sync.

   - **Session Host Connects to On-Prem AD DS**: The selected Azure Virtual Desktop session host connects to the on-premises AD DS server for user credential validation and applies any necessary group policies to configure the user's environment appropriately.

3. **Azure Virtual Desktop Agent Communication**
   - The Azure Virtual Desktop agent installed on the session host VM communicates with the Azure Virtual Desktop service in Azure to manage session brokering, handle user sessions, and provide metering and diagnostics data.

4. **Azure Arc Agent's Infrastructure Management**
   - The Azure Arc agent running on the session host VM provides additional governance, monitoring, and lifecycle management services for the underlying infrastructure on the Azure Local cluster.

5. **User Profile Storage with FSLogix**
   - Microsoft recommends using [FSLogix containers](https://learn.microsoft.com/en-us/fslogix/tutorial-configure-profile-containers) with Azure Virtual Desktop to manage and roam user profiles and personalization. These profiles are preferably stored on a dedicated NAS/SMB file share off the Azure Local cluster or within the Storage Spaces Direct (S2D) pool on the Azure Local cluster, allowing for efficient profile management and quick load times during user sessions.


## Product Overview
# Azure Virtual Desktop

Azure Virtual Desktop is a comprehensive cloud-based Virtual Desktop Infrastructure (VDI) solution tailored for the demands of remote and hybrid work. It delivers a secure and seamless remote desktop experience, accessible from anywhere, while providing employees with the best virtualized experience. It is the only solution fully optimized for Windows 11 and Windows 10 multi-session capabilities. With built-in security features, Azure Virtual Desktop helps protect your organization's applications and data, ensuring compliance with industry standards. It streamlines the deployment and management of virtual desktops, giving administrators flexibility and control over configuration. Additionally, Azure Virtual Desktop reduces costs through consumption-based pricing and optimizes existing virtualization investments, ensuring you only pay for what you use.

# Azure Local

Azure Local is Microsoft’s hybrid distributed infrastructure solution that can be used to deploy and manage Windows and Linux virtual machines (VMs) or containerized workloads and their storage. This hybrid infrastructure seamlessly integrates on-premises systems to Azure for cloud-based services, monitoring, and management. Azure Local provides the flexibility and cost-efficiency of cloud infrastructure while meeting specialized workload requirements that cannot reside in the public cloud due to regulatory or performance needs. Through Azure Arc integration, it offers centralized management, cloud-driven deployment, and monitoring of clusters, making it an ideal solution for hybrid environments.

# Azure Virtual Desktop for Azure Local

Azure Virtual Desktop for Azure Local is a robust desktop and application virtualization solution that combines the flexibility of Azure Virtual Desktop with the performance and reliability of Azure Local. This setup allows customers to deliver secure, scalable virtual desktops and applications, leveraging their existing on-premises infrastructure. Azure Virtual Desktop for Azure Local has been selected as a high-priority workload as it allows us to compete in the desktop virtualization market against established solutions like VMware Horizon and Citrix DaaS. Notably, Citrix will also support Azure Virtual Desktop for Azure Local, further expanding the options available for customers seeking integrated solutions. This collaboration highlights the flexibility of the platform, and strengthens our ability to offer competitive solutions to customers looking for both Citrix and Azure Virtual Desktop as part of their infrastructure.

# Virtual Machines in Azure Virtual Desktop

In Azure Virtual Desktop, customers leverage Windows virtual machines to host remote end user sessions. Understanding the specific requirements of these workloads is crucial for accurately sizing your virtual machines (VMs), and ultimately drives the design considerations for the Azure Virtual Desktop workloads. It is important to clarify that our references to VMs throughout this page refer to Arc VMs, which represent the key use case for customers, especially when deploying on 23H2 Azure Local or newer. Importantly, Arc VMs maintain full compliance with Azure Virtual Desktop, ensuring that customers can run these workloads without any compatibility issues. Arc VMs also offer enhanced capabilities such as hybrid management, centralized policy enforcement, and seamless integration with Azure services, making them ideal for modern, scalable environments. While customers can still create regular VMs, these lack the advanced management features and integration benefits provided by Arc, resulting in a more limited and isolated deployment experience.

# Benefits

By using Azure Virtual Desktop for Azure Local, you can:

- **Improve performance** for Azure Virtual Desktop users in areas with poor connectivity to the Azure public cloud by giving them session hosts closer to their location.
- **Meet data locality requirements** by keeping app and user data on-premises. For more information, see [Data locations for Azure Virtual Desktop](https://learn.microsoft.com/azure/virtual-desktop/data-locations).
- **Improve access to legacy on-premises apps and data sources** by keeping desktops and apps in the same location.
- **Reduce cost and improve user experience** with Windows 10 and Windows 11 Enterprise multi-session, which allows multiple concurrent interactive sessions.
- **Simplify your VDI deployment and management** compared to traditional on-premises VDI solutions by using the Azure portal.
- **Achieve the best performance** by using [RDP Shortpath](https://learn.microsoft.com/en-us/azure/virtual-desktop/rdp-shortpath?tabs=managed-networks) for low-latency user access.
- **Deploy the latest fully patched images quickly and easily** using [Azure Marketplace images](https://learn.microsoft.com/en-us/azure-stack/hci/manage/virtual-machine-image-azure-marketplace).