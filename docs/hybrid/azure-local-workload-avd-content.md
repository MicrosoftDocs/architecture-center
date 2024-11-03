This workload reference architecture document aims to provide customer guidance on selecting and setting up an Azure Virtual Desktop workload for Azure Local, thereby streamlining the Edge solution procurement process. By leveraging trusted Reference Architectures (RAs) from Microsoft, customers can minimize the time and effort required to deploy and manage their infrastructure.

Central to this, this guide factors in workload specific design considerations, requirements, and scale limitations, offering customers a complementary tool to the existing [Azure Local catalog](https://aka.ms/hci-catalog#catalog) and [Azure Local Sizer](https://aka.ms/hci-catalog#sizer) in designing their solution.

For additional information, this document is also best used in conjunction with [Azure Local baseline reference architecture](azure-stack-hci-baseline.yml) and [Azure Local Well-Architected Framework service guide](/azure/well-architected/service-guides/azure-stack-hci), which provides guidelines and recommendations for how to deploy highly available and resilient Azure Local instances.

## Article layout

| Architecture | Design decisions | Well-Architected Framework approach|
|---|---|---|
|&#9642; [Architecture](#architecture) <br>&#9642; [Product Overview](#Product-overview) <br>&#9642;  [Platform resources](#platform-resources) <br>&#9642; [Platform-supporting resources](#platform-supporting-resources) <br>&#9642; [Deploy this scenario](#deploy-this-scenario) <br>|&#9642; [Workload Types](#workload-types)<br> &#9642; [User profiles and storage](#user-profiles-and-storage) <br> &#9642; [Session Types](#session-types) <br> &#9642; [Sample Workload Use Case](#sample-workload-use-case) <br> &#9642; [Update management](#update-management)|&#9642; [Reliability](#reliability) <br> &#9642; [Security](#security) <br> &#9642; [Cost optimization](#cost-optimization) <br> &#9642; [Operational excellence](#operational-excellence) <br> &#9642; [Performance efficiency](#performance-efficiency)|

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

# Deploy this Scenario

## Prerequisites

For a general idea of what is required and supported, such as operating systems (OSs), virtual networks, and identity providers, review [Prerequisites for Azure Virtual Desktop](https://learn.microsoft.com/azure/virtual-desktop/prerequisites). That article also includes a list of the [supported Azure regions](https://learn.microsoft.com/en-us/azure/virtual-desktop/prerequisites#azure-regions) in which you can deploy host pools, workspaces, and application groups. This list of regions is where the metadata for the host pool can be stored. However, session hosts can be located in any Azure region and on-premises with [Azure Local](https://learn.microsoft.com/en-us/azure/virtual-desktop/azure-stack-hci-overview). For more information about the types of data and locations, see [Data locations for Azure Virtual Desktop](https://learn.microsoft.com/azure/virtual-desktop/data-locations).

## Supported deployment configurations

Your Azure Local clusters need to be running a minimum of [version 23H2](https://learn.microsoft.com/en-us/azure-stack/hci/release-information) and [registered with Azure](https://learn.microsoft.com/en-us/azure-stack/hci/deploy/register-with-azure). Once your cluster is ready, you can use the following 64-bit operating system images for your session hosts that are in support:

- Windows 11 Enterprise multi-session
- Windows 11 Enterprise
- Windows 10 Enterprise multi-session
- Windows 10 Enterprise
- Windows Server 2022
- Windows Server 2019

To use session hosts on Azure Local with Azure Virtual Desktop, you also need to:

- **License and activate the virtual machines.** For activating Windows 10 and Windows 11 Enterprise multi-session, and Windows Server 2022 Datacenter: Azure Edition, use [Azure verification for VMs](https://learn.microsoft.com/en-us/azure-stack/hci/deploy/azure-verification). For all other OS images (such as Windows 10 and Windows 11 Enterprise, and other editions of Windows Server), you should continue to use existing activation methods. For more information, see [Activate Windows Server VMs on Azure Local](https://learn.microsoft.com/azure/virtual-desktop/activate-windows-server-vms).
- **Install the [Azure Connected Machine agent](https://learn.microsoft.com/en-us/azure/azure-arc/servers/agent-overview)** on the virtual machines so they can communicate with [Azure Instance Metadata Service](https://learn.microsoft.com/en-us/azure/virtual-machines/instance-metadata-service), which is a [required endpoint for Azure Virtual Desktop](https://learn.microsoft.com/en-us/azure/virtual-desktop/required-fqdn-endpoint). The Azure Connected Machine agent is automatically installed when you add session hosts using the Azure portal as part of the process to [Deploy Azure Virtual Desktop](https://learn.microsoft.com/en-us/azure/virtual-desktop/deploy-azure-virtual-desktop) or [Add session hosts to a host pool](https://learn.microsoft.com/en-us/azure/virtual-desktop/add-session-hosts-host-pool).

Finally, users can connect using the same [Remote Desktop clients](https://learn.microsoft.com/en-us/azure/virtual-desktop/users/remote-desktop-clients-overview) as Azure Virtual Desktop.

## Deployment Methods

Deploying Azure Virtual Desktop for Azure Local can be done using the following means:

- [Azure Portal](https://learn.microsoft.com/en-us/azure/virtual-desktop/deploy-azure-virtual-desktop?tabs=portal)
- [Azure CLI](https://learn.microsoft.com/en-us/azure/virtual-desktop/deploy-azure-virtual-desktop?tabs=cli)
- [Azure PowerShell](https://learn.microsoft.com/en-us/azure/virtual-desktop/deploy-azure-virtual-desktop?tabs=powershell)

A detailed guide is available in the links above, whereby users are guided stepwise through the prerequisites, host pool, workspace, application group, and assignment creation.

### ARM Templates and Terraform

Additionally, the Azure Virtual Desktop workload deployment can be streamlined significantly by leveraging [ARM (Azure Resource Manager)](https://github.com/Azure/RDS-Templates/blob/master/ARM-wvd-templates/HCI/QuickDeploy/CreateHciHostpoolQuickDeployTemplate.json), which facilitates automation, consistency, and repeatability in deploying Azure resources.

[ARM templates](https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/overview) help define the infrastructure and configuration for your Azure deployment, enabling consistent deployment of Azure Virtual Desktop for Azure Local by automating the creation and configuration of resources. The following [Quick-Deploy ARM template for Azure Virtual Desktop for Azure Local](https://github.com/Azure/RDS-Templates/blob/master/ARM-wvd-templates/HCI/QuickDeploy/CreateHciHostpoolQuickDeployTemplate.json) serves as a foundation for automation. While we do not anticipate further updates to this template unless necessary to address critical issues or integrate significant advancements, this serves as a versatile starting point for building and managing your Azure Virtual Desktop deployments.

Note that this ARM template has already been validated on Azure CLI; while PowerShell may be possible, this has not been fully validated. Similarly, the Terraform templates can be found here:

- **lnet**: [Azure/avm-res-azurestackhci-logicalnetwork/azurerm | Terraform Registry](https://registry.terraform.io/modules/Azure/avm-res-azurestackhci-logicalnetwork/azurerm)
- **VM**: [Azure/avm-res-azurestackhci-virtualmachineinstance/azurerm | Terraform Registry](https://registry.terraform.io/modules/Azure/avm-res-azurestackhci-virtualmachineinstance/azurerm)

Users can also find the ARM template and parameter file for the Azure Local 23H2 cluster [here](https://github.com/Azure/azure-quickstart-templates/tree/master/quickstarts/microsoft.azurestackhci/create-cluster-2-node-switched-custom-storageip).

For a consolidated list of recent feature updates, see [What's new in Azure Virtual Desktop? - Azure | Microsoft Learn](https://learn.microsoft.com/azure/virtual-desktop/whats-new).

# Workload Design Considerations

In building out an Azure Virtual Desktop for Azure Local solution, there are several key design elements to consider - workload types, user profile management, and session types.

## Azure Virtual Desktop Workload Types

Session host virtual machines in an Azure Virtual Desktop for Azure Local environment can accommodate a wide range of workload types, each with specific resource requirements. To assist in estimating the optimal sizing for your virtual machines, the following table presents examples of various [workload categories](https://learn.microsoft.com/en-us/windows-server/remote/remote-desktop-services/virtual-machine-recs).

| Workload Type | Example Users                 | Example Apps                                                                                         |
|---------------|-------------------------------|------------------------------------------------------------------------------------------------------|
| Light         | Users doing basic data entry tasks | Database entry applications, command-line interfaces                                                 |
| Medium        | Consultants and market researchers | Database entry applications, command-line interfaces, Microsoft Word, static web pages               |
| Heavy         | Software engineers, content creators | Database entry applications, command-line interfaces, Microsoft Word, static web pages, Microsoft Outlook, Microsoft PowerPoint, dynamic web pages, software development |
| Power         | Graphic designers, 3D model makers, machine learning researchers | Database entry applications, command-line interfaces, Microsoft Word, static web pages, Microsoft Outlook, Microsoft PowerPoint, dynamic web pages, photo and video editing, computer-aided design (CAD), computer-aided manufacturing (CAM) |

Please note that the workload types (light/medium/heavy/power) are indicative. We recommend you use simulation tools and industry benchmarks such as [LoginVSI](https://www.loginvsi.com/) to test your deployment with both stress tests and real-life usage simulations. Additionally, the information provided herein is based on point-in-time hardware data from solution builders and the latest Azure Local OS specifications. Sizing estimates may change over time due to changes in these factors.

## User Profiles and Storage

In Azure Virtual Desktop, managing user profiles and storage efficiently is pivotal for ensuring a seamless user experience. A user profile contains data elements about the individual, including configuration information like desktop settings, persistent network connections, and application settings.

[**FSLogix**](https://learn.microsoft.com/en-us/azure/virtual-desktop/fslogix-profile-containers) is Microsoft’s recommended solution for profile management in virtual desktop environments, designed to simplify and enhance user experience. It provides a robust and scalable approach for handling user profiles, ensuring fast login times and consistent user experience across sessions. [FSLogix uses profile containers](https://learn.microsoft.com/en-us/fslogix/overview-what-is-fslogix) to store user profiles in Virtual Hard Disks (VHD) files located either on the Azure Local cluster itself or on a separate Azure or SMB-compatible file share. This method isolates user profiles, preventing conflicts and ensuring a personalized experience for each user, while also enhancing security and performance by maintaining profile independence. Additionally, FSLogix integrates seamlessly with Azure Virtual Desktop, optimizing the management and performance of user profiles in both single and multi-session environments.

When deploying Azure Virtual Desktop for Azure Local, FSLogix can be installed in one of two configurations to effectively manage user profiles:

### 1. Separate File Share

1. **Location**: FSLogix profiles can be stored on a dedicated file share within your on-premises environment. This file share can be hosted on an existing file server, network-attached storage (NAS), or a dedicated storage solution configured to serve the Azure Local cluster.
2. **Benefits**: Using a separate file share allows for centralized and scalable profile management. This approach is ideal for larger environments where centralizing profile storage ensures easier management and scalability.
3. **Considerations**: Network performance and latency are crucial. The file share must be highly accessible with minimal latency to ensure quick login times and seamless user experience. Ensuring robust network infrastructure is essential to support this setup.
4. **Recommendation for Large Deployments**: For organizations looking to scale beyond on-premises storage capacities, cloud-based storage solutions like [Azure Files](https://learn.microsoft.com/en-us/azure/storage/files/storage-files-introduction) or [Azure NetApp Files](https://learn.microsoft.com/en-us/azure/azure-netapp-files/azure-netapp-files-introduction) can be leveraged. These options provide high availability, robust performance, and simplified management, while alleviating storage constraints on the Azure Local cluster. They can also offer better scalability and flexibility compared to local on-prem file shares.

### 2. Same Azure Local Cluster

1. **Location**: FSLogix can be installed directly on the same Azure Local cluster that hosts the Azure Virtual Desktop infrastructure. The profile containers can be stored on the cluster's storage.
2. **Benefits**: This setup benefits from the high performance and low latency of local storage resources, which can enhance user experience by providing faster access to profile data. It also simplifies the deployment architecture by consolidating resources.
3. **Considerations**: While this approach offers simplicity and performance benefits, it might limit scalability compared to using a separate file share. It is more suitable for smaller deployments or environments where the Azure Local cluster’s storage capacity and performance can handle the additional load without impacting other workloads. Note that leveraging this option will increase the Azure Local storage requirements on the hardware specifications.

## Session Types

In Azure Virtual Desktop, user sessions can be classified into single-session and multi-session modes, each offering different performance and user experience options:

- **Single-Session**: Each virtual machine (VM) hosts one user session, effectively providing a dedicated environment. This is similar to a traditional virtual desktop infrastructure (VDI) model where each user has their own desktop experience. Single-session is ideal for workloads that demand high performance, custom configurations, or applications that do not work well in shared environments.

- **Multi-Session**: A single VM hosts multiple user sessions simultaneously. This is optimized for cost-efficiency and scalability, where resources like CPU, memory, and storage are shared across users. Multi-session is suited for scenarios where users need access to standard applications or lighter workloads, like task workers or shared workstations, as it consolidates resources across many users.

### Considerations Between Session Types

Running single-session Azure Virtual Desktop for Azure Local can be resource-intensive, as it requires dedicated resources for each individual user. In contrast, Windows 10/11 multi-session allows multiple users to share the same virtual machine (VM) and its resources, making it a far more efficient option. Given that Windows 10 and 11 multi-session is available exclusively through Azure Virtual Desktop, it offers a compelling advantage in both cost savings and user experience. Leading with Windows 10/11 multi-session enables organizations to maximize their infrastructure by supporting more users per VM, reducing overall resource consumption while delivering a familiar, high-quality desktop experience.

The following section outlines the key factors that organizations should consider when selecting between single or multi-session environments.

### 1. Cost Savings

- **Single-Session Environment**:
  - Each user gets a dedicated virtual machine (VM).
  - Ensures consistent performance without resource competition.
  - Requires provisioning VMs for peak individual user demand.
  - Significantly increases resource requirements per user.

- **Multi-Session Environment**:
  - Multiple users share a single VM's resources.
  - Dynamically allocates resources based on current user needs.
  - Optimizes resource usage, reducing demand per user.
  - Increases user density on each node, leading to cost savings.
  - Potential for minor performance variability, but efficiencies generally outweigh this.

### 2. Enhanced User Experience

- **Single-Session Environment**:
  - Provides complete performance isolation between users.
  - Ideal for consistent performance needs and resource-intensive applications.
  - Eliminates impact of one user's activities on another's experience.

- **Multi-Session Environment**:
  - Maintains software isolation but may have hardware resource contention.
  - Offers a familiar Windows 10/11 desktop environment.
  - Balances high-quality experience for typical office tasks and general applications with lower costs.

### 3. User Customization

- **Single-Session Environment**:
  - Allows highly personalized setups for individual users.
  - Users can install and configure their own applications and settings.
  - Critical for scenarios requiring specific software versions or custom configurations.

- **Multi-Session Environment**:
  - Customization is limited to maintain stability for all users.
  - Administrators manage software installations and updates to avoid conflicts.
  - Restricts the level of personalization achievable by individual users.
  - Focuses on providing a consistent environment for all users.

### Recommendation

While single-session Azure Virtual Desktop for Azure Local offers dedicated resources, performance isolation, and extensive user customization, these benefits come with significantly higher resource demands. **Organizations that prioritize efficient scaling and cost savings should consider Windows 10/11 multi-session as the optimal choice.** By sharing resources across users, reducing infrastructure costs, and delivering a familiar user experience, multi-session deployments provide a compelling solution for businesses seeking to maximize their virtual desktop environments while maintaining high performance. Thus, we recommend that customers pursue the Windows 10/11 multi-session setup for their Azure Virtual Desktop for Azure Local use case.

## Sample Workload Use Case for Azure Virtual Desktop

In this section, we provide a sample workload use-case for Azure Virtual Desktop for Azure Local based on the published [Azure Virtual Desktop user density guide](https://learn.microsoft.com/en-us/windows-server/remote/remote-desktop-services/virtual-machine-recs) that customers may reference when building out a solution.

- **Use Case**
  - **Session Type**: Multi-session
  - **Workload Type**: Medium workload
  - **User Count**: 2,000 users

The multi-session use case is chosen over the single session use case given that most customers utilize this setup. This configuration coupled with Windows 11 Enterprise Multi-session offers an ideal setup for medium workloads, where applications have modest demands in terms of CPU and memory usage. Multi-session capabilities are a significant value proposition especially for Azure Virtual Desktop for Azure Local, enabling efficient resource utilization and cost savings by serving multiple users from a shared pool of resources. Key reasons for selecting this setup include:

1. **General Business Applications**: Multi-session VMs are well-suited for running productivity applications like Microsoft Office, web browsers, and line-of-business applications that do not require high individual user resources.
2. **Cost Effective Solution**: Multi-session setups provide a cost-effective solution for environments with many concurrent users, such as call centers or customer support teams, where many users typically engage in lightweight tasks.

For the recommended use case above, here are the minimum hardware cluster level requirements:

**Multi-Session, Medium Workload, 2,000 Users**
| Physical Cores | Total vCPUs | Total Memory (TB) | Total OS Storage (TB) | Profile Container Storage (TB) |
|----------------|-------------|-------------------|-----------------------|-------------------------------|
| 140            | 280         | 0.7               | 2.0                   | 60.0                          |


Note that this is purely a sample guidance for reference and has not been validated. Additionally, the Node and Cluster Storage (TB) values do not include the Profile Container storage requirements, as the recommendation is that user profiles are stored on a separate file share off the Azure Local cluster for resiliency (e.g., if the cluster goes down, customers have another dormant host pool on a different cluster for high availability, and the user profiles remain secure).

Additionally, these numbers assume 50% concurrency and a 2:1 oversubscription rate (vCPUs to physical cores).
