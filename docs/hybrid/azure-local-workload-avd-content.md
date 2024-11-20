This workload reference architecture provides guidance on how to select and set up an **Azure Virtual Desktop for Azure Local**. By using this reference architecture, you can minimize the time and effort required to deploy and manage your Azure Virtual Desktop for Azure Local solution.

Before you begin, it's important that you first read and understand the [Azure Local baseline reference architecture](azure-stack-hci-baseline.yml), so that you can get familiar with the design choices for the physical machines that deliver the compute, storage, and networking capabilities.

This guide looks at workload specific design considerations, requirements, and scale limitations, offering you a complementary tool to the existing [Azure Local catalog](https://aka.ms/hci-catalog#catalog) and [Azure Local Sizer](https://aka.ms/hci-catalog#sizer) when designing an Azure Virtual Desktop for Azure Local solution.

For more information, review the [Azure Local Well-Architected Framework service guide](/azure/well-architected/service-guides/azure-stack-hci), which provides guidelines and recommendations for how to deploy highly available and resilient Azure Local instances.

## Article layout

| Architecture | Design decisions | Well-Architected Framework approach|
|---|---|---|
|&#9642; [Architecture](#architecture) <br>&#9642; [Workflow](#workflow) <br>&#9642;  [Components](#components) <br>&#9642; [Product Overview](#product-overview) <br>&#9642; [Deploy this scenario](#deploy-this-scenario) <br>&#9642; [ARM Templates](#arm-templates)|&#9642; [Workload design considerations](#workload-design-considerations)<br> &#9642; [User profiles and storage management](#user-profiles-and-storage-management) <br> &#9642; [Session types](#session-types)  <br> &#9642; [Supported deployment configurations](#supported-deployment-configurations)|&#9642; [Reliability](#reliability) <br> &#9642; [Security](#security) <br> &#9642; [Cost optimization](#cost-optimization) <br> &#9642; [Operational excellence](#operational-excellence) <br> &#9642; [Performance efficiency](#performance-efficiency)|

## Architecture

:::image type="complex" source="images/azure-local-workload-avd.png" alt-text="Diagram that shows a reference architecture for deploying Azure Virtual Desktop on Azure Local" lightbox="images/azure-local-workload-avd.png" border="false":::
    Diagram that shows a reference architecture for deploying Azure Virtual Desktop on Azure Local.
:::image-end:::

Architecture diagram showing a high-level overview of the Azure Virtual Desktop for Azure Local solution.

### Workflow

The steps outlined in the workflow section provide an overview of the end to end service, starting with the communication from the client device to the Azure Virtual Desktop cloud service. Correlate the workflow steps with the numbers in the architecture diagram.

1. **User device initiates connection**
   - User devices (either on-premises or remote) run the Azure Virtual Desktop client and initiate a connection to the Azure Virtual Desktop service in Azure.

2. **User authentication via Microsoft Entra ID**
   - The Azure Virtual Desktop service in Azure interacts with [Microsoft Entra ID (formerly Azure Active Directory)](https://www.microsoft.com/security/business/identity-access/microsoft-entra-id) to authenticate the user and perform a token exchange during login.

   - **Hybrid identity synchronization**: A hybrid identity sync occurs between the on-prem AD DS (Active Directory Domain Services) server and the cloud-based Microsoft Entra ID, ensuring that user identities are synchronized and available for both local authentication (for session hosts on Azure Local) and cloud access. This step operates continuously in the background to keep the on-premises AD DS and Microsoft Entra ID in sync.

   - **Session host connects to on premises AD DS**: The selected Azure Virtual Desktop session host connects to the on-premises AD DS server for user credential validation and applies any necessary group policies to configure the user's environment appropriately.

3. **Azure Virtual Desktop agent communication**
   - The Azure Virtual Desktop agent installed on the session host VM communicates with the Azure Virtual Desktop service in Azure to manage session brokering, handle user sessions, and provide metering and diagnostics data.

4. **Azure Arc agent infrastructure management**
   - The Azure Arc agent running on the session host VM provides security, governance and monitoring capabilities. Arc VM lifecycle management operations are orchestrated using the Azure Resource Bridge (ARB) component of the Azure Local instance.

5. **User profile storage with FSLogix**
   - Microsoft recommends using [FSLogix containers](/fslogix/tutorial-configure-profile-containers) with Azure Virtual Desktop to manage and roam user profiles and personalization. These profiles are preferably stored on a dedicated NAS/SMB file share off the Azure Local instance or within the Storage Spaces Direct (S2D) pool on the Azure Local instance, allowing for efficient profile management and quick load times during user sessions.

## Components

The architecture resources remain mostly unchanged from the baseline reference architecture. For more information, see the [platform resources and platform supporting resources](/azure/architecture/hybrid/azure-stack-hci-baseline#components) used for Azure Local deployments.

## Product overview

The following three sections provide an overview of Azure Virtual Desktop for Azure Local, Arc VMs, and the benefits of the solution. If you require additional information, refer to the [Azure Virtual Desktop for Azure Local documentation](/azure/virtual-desktop/azure-stack-hci-overview).

### Azure Virtual Desktop for Azure Local

Azure Virtual Desktop for Azure Local is a robust desktop and application virtualization solution that combines the flexibility of Azure Virtual Desktop with the performance and reliability of Azure Local. This setup allows you to deliver secure, scalable virtual desktops and applications, using your existing on-premises infrastructure.

### Virtual Machines in Azure Virtual Desktop

In Azure Virtual Desktop, Arc virtual machines (VMs) running Windows are used to host remote end user sessions. Understanding the specific requirements of these workloads is crucial for accurately sizing your virtual machines (VMs), and ultimately drives the design considerations for the Azure Virtual Desktop workloads. Note that all references to VMs in this article is referring to the use of [Arc VMs](/azure-stack/hci/manage/azure-arc-vm-management-overview).

Importantly, Arc VMs maintain full compliance with Azure Virtual Desktop, ensuring that you can run these workloads without any compatibility issues. Arc VMs also offer enhanced capabilities such as hybrid management, centralized policy enforcement, and seamless integration with Azure services. While you can create non-Arc VMs, they lack the advanced management features and integration benefits provided by Arc.

### Benefits

By using Azure Virtual Desktop for Azure Local, you can:

- **Improve performance** for Azure Virtual Desktop users in areas with poor connectivity to the Azure public cloud by giving them session hosts closer to their location.
- **Meet data locality requirements** by keeping app and user data on-premises.
- **Improve access to legacy on-premises apps and data sources** by keeping desktops and apps in the same location.
- **Reduce cost and improve user experience** with Windows 10 and Windows 11 Enterprise multi-session, which allows multiple concurrent interactive sessions.
- **Simplify your VDI deployment and management** compared to traditional on-premises VDI solutions by using the Azure portal.
- **Achieve the best performance** by using [RDP Shortpath](/azure/virtual-desktop/rdp-shortpath?tabs=managed-networks) for low-latency user access.
- **Deploy the latest fully patched images quickly and easily** using [Azure Marketplace images](/azure-stack/hci/manage/virtual-machine-image-azure-marketplace).

### Key Considerations

Key points to consider when deploying Azure Virtual Desktop for Azure Local include:

- Each host pool must only contain session hosts on Azure or on Azure Local. You cannot mix session hosts on Azure and on Azure Local in the same host pool, as shown in the logical separation diagram:

:::image type="complex" source="images/azure-local-workload-avd-logical-separation.png" alt-text="Diagram that shows the logical separation for the components that run in Azure and Azure Local." lightbox="images/azure-local-workload-avd-logical-separation.png" border="false":::
    Diagram that shows the logical separation for the components that run in Azure and Azure Local.
:::image-end:::

- Azure Virtual Desktop for Azure Local is connected to Azure cloud via agents to provide features such as additional governance, monitoring, lifecycle management services, and identity management.
- Azure Local supports many types of hardware and on-premises networking capabilities, so performance and user density might vary compared to session hosts running on Azure. Azure Virtual Desktop's virtual machine sizing guidelines are broad, so you should use them for initial performance estimates and monitor after deployment. More details in the sections to follow.
- You can only join session hosts on Azure Local to an Active Directory Domain Services domain.

## Deploy this scenario

### Prerequisites

For a general idea of what is required and supported, such as operating systems (OSs), virtual networks, and identity providers, review [Prerequisites for Azure Virtual Desktop](/azure/virtual-desktop/prerequisites). That article also includes a list of the [supported Azure regions](/azure/virtual-desktop/prerequisites#azure-regions) in which you can deploy host pools, workspaces, and application groups. This list of regions is where the metadata for the host pool can be stored. However, session hosts can be located in any Azure region and on-premises with [Azure Local](/azure/virtual-desktop/azure-stack-hci-overview). For more information about the types of data and locations, see [Data locations for Azure Virtual Desktop](/azure/virtual-desktop/data-locations).

### Supported deployment configurations

Your Azure Local instances must be running a minimum of [version 23H2](/azure-stack/hci/release-information). Once the instance is deployed and ready, you can use the following 64-bit operating system images for your session hosts Arc VMs:

- Windows 11 Enterprise multi-session
- Windows 11 Enterprise
- Windows 10 Enterprise multi-session
- Windows 10 Enterprise
- Windows Server 2022
- Windows Server 2019

To use session hosts on Azure Local with Azure Virtual Desktop, you also need to:

- **License and activate the virtual machines.** For activating Windows 10 and Windows 11 Enterprise multi-session, and Windows Server 2022 Datacenter: Azure Edition, use [Azure verification for VMs](/azure-stack/hci/deploy/azure-verification). For all other OS images (such as Windows 10 and Windows 11 Enterprise, and other editions of Windows Server), you should continue to use existing activation methods. For more information, see [Activate Windows Server VMs on Azure Local](/azure-stack/hci/manage/vm-activate).
- Install the [Azure Connected Machine agent](/azure/azure-arc/servers/agent-overview) on the virtual machines so they can communicate with [Azure Instance Metadata Service](/azure/virtual-machines/instance-metadata-service), which is a [required endpoint for Azure Virtual Desktop](/azure/virtual-desktop/required-fqdn-endpoint). The Azure Connected Machine agent is automatically installed when you add session hosts using the Azure portal, as part of the process to [Deploy Azure Virtual Desktop](/azure/virtual-desktop/deploy-azure-virtual-desktop) or [Add session hosts to a host pool](/azure/virtual-desktop/add-session-hosts-host-pool).

Finally, users can connect using the same [Remote Desktop clients](/azure/virtual-desktop/users/remote-desktop-clients-overview) as Azure Virtual Desktop.

### Deployment methods

Deploying Azure Virtual Desktop for Azure Local can be done using the following means:

- [Azure Portal](/azure/virtual-desktop/deploy-azure-virtual-desktop?tabs=portal)
- [Azure CLI](/azure/virtual-desktop/deploy-azure-virtual-desktop?tabs=cli)
- [Azure PowerShell](/azure/virtual-desktop/deploy-azure-virtual-desktop?tabs=powershell)

A detailed guide is available in the links above, whereby users are guided stepwise through the prerequisites, host pool, workspace, application group, and assignment creation.

#### ARM templates

The Azure Virtual Desktop workload deployment can be streamlined significantly using [ARM (Azure Resource Manager)](/azure/azure-resource-manager/templates/overview) templates, which provide automation, consistency, and repeatability when deploying Azure resources.

An example ARM template and parameter file to deploy an Azure Local instance is [here](https://github.com/Azure/azure-quickstart-templates/tree/master/quickstarts/microsoft.azurestackhci/create-cluster-2-node-switched-custom-storageip).

This [ARM template for Azure Virtual Desktop for Azure Local](https://github.com/Azure/RDS-Templates/blob/master/ARM-wvd-templates/HCI/QuickDeploy/CreateHciHostpoolQuickDeployTemplate.json) serves as a foundation for building and managing your Azure Virtual Desktop deployments.

#### Terraform

Terraform can be used to deploy Azure Local instances, logical networks, and Arc VMs. However there isn't a provider that can deploy Azure Virtual Desktop at this time. Here are the links to the Terraform providers for Azure Local:

- **Azure Local instance**: [Azure/avm-res-azurestackhci-cluster/azurerm | Terraform Registry](https://registry.terraform.io/modules/Azure/avm-res-azurestackhci-cluster/azurerm)

- **Logical network**: [Azure/avm-res-azurestackhci-logicalnetwork/azurerm | Terraform Registry](https://registry.terraform.io/modules/Azure/avm-res-azurestackhci-logicalnetwork/azurerm)

- **Virtual machine**: [Azure/avm-res-azurestackhci-virtualmachineinstance/azurerm | Terraform Registry](https://registry.terraform.io/modules/Azure/avm-res-azurestackhci-virtualmachineinstance/azurerm)

For a consolidated list of recent feature updates, see [What's new in Azure Virtual Desktop? - Azure | Microsoft Learn](/azure/virtual-desktop/whats-new).

## Workload design considerations

When building an Azure Virtual Desktop for Azure Local solution, there are three key design elements to consider:

- [Workload types](#azure-virtual-desktop-workload-types)
- [User profiles and storage management](#user-profiles-and-storage-management)
- [Session types](#session-types)

### Azure Virtual Desktop workload types

Session host virtual machines in an Azure Virtual Desktop for Azure Local environment can accommodate a wide range of workload types, each with specific resource requirements. To help estimate the optimal sizing for your virtual machines, the following table presents examples of various [workload categories](/windows-server/remote/remote-desktop-services/virtual-machine-recs).

| Workload Type | Example Users                 | Example Apps                                                                                         |
|---------------|-------------------------------|------------------------------------------------------------------------------------------------------|
| Light         | Users doing basic data entry tasks | Database entry applications, command-line interfaces                                                 |
| Medium        | Consultants and market researchers | Database entry applications, command-line interfaces, Microsoft Word, static web pages               |
| Heavy         | Software engineers, content creators | Database entry applications, command-line interfaces, Microsoft Word, static web pages, Microsoft Outlook, Microsoft PowerPoint, dynamic web pages, software development |
| Power         | Graphic designers, 3D model makers, machine learning researchers | Database entry applications, command-line interfaces, Microsoft Word, static web pages, Microsoft Outlook, Microsoft PowerPoint, dynamic web pages, photo and video editing, computer-aided design (CAD), computer-aided manufacturing (CAM) |

>[!NOTE]
>Workload types (light/medium/heavy/power) are indicative. We recommend that you use simulation tools and industry benchmarks such as [LoginVSI](https://www.loginvsi.com/) to test your deployment with both stress tests and real-life usage simulations. Also, the information provided here is based on point-in-time hardware data from solution builders and the latest Azure Local OS specifications. Sizing estimates can change over time due to changes in these factors.

## User profiles and storage management

In Azure Virtual Desktop, managing user profiles and storage efficiently is pivotal for ensuring a seamless user experience. A user profile contains data elements about the individual, including configuration information like desktop settings, persistent network connections, and application settings.

[**FSLogix**](/azure/virtual-desktop/fslogix-profile-containers) is Microsoft’s recommended solution for profile management in virtual desktop environments, designed to simplify and enhance user experience. It provides a robust and scalable approach for handling user profiles, ensuring fast login times and consistent user experience across sessions. [FSLogix uses profile containers](/fslogix/overview-what-is-fslogix) to store user profiles in Virtual Hard Disks (VHD) files located either on the Azure Local instance itself or on a separate Azure or SMB-compatible file share. This method isolates user profiles, preventing conflicts and ensuring a personalized experience for each user. It also enhances security and performance by maintaining profile independence. Additionally, FSLogix integrates seamlessly with Azure Virtual Desktop, optimizing the management and performance of user profiles in both single and multi-session environments.

When you deploy Azure Virtual Desktop for Azure Local, FSLogix can be installed in one of two configurations to effectively manage user profiles:

### 1. Separate File Share

1. **Location**: FSLogix profiles can be stored on a dedicated file share within your on-premises environment. This file share can be hosted on an existing file server, network-attached storage (NAS), or a dedicated storage solution configured to serve the Azure Local instance.
2. **Benefits**: Using a separate file share allows for centralized and scalable profile management. This approach is ideal for larger environments where centralizing profile storage ensures easier management and scalability.
3. **Considerations**: Network performance and latency are crucial. The file share must be highly accessible with minimal latency to ensure quick login times and seamless user experience. Ensuring robust network infrastructure is essential to support this setup.
4. **Recommendation for large deployments**: For organizations looking to scale beyond on-premises storage capacities, cloud-based storage solutions like [Azure Files](/azure/storage/files/storage-files-introduction) or [Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-introduction) can be used. These options provide high availability, robust performance, and simplified management, while alleviating storage constraints on the Azure Local instance. They can also offer better scalability and flexibility compared to on-premises file shares solutions. Consider network latency, bandwidth and through-put requirements and considerations when using a cloud based storage solution.

### 2. Same Azure Local instance

1. **Location**: FSLogix can be installed directly on the same Azure Local instance that hosts the Azure Virtual Desktop infrastructure. The profile containers can be stored on the instance's storage.
1. **Benefits**: This setup benefits from the high performance and low latency of local storage resources, which can enhance user experience by providing faster access to profile data. It also simplifies the deployment architecture by consolidating resources.
1. **Considerations**: While this approach offers simplicity and performance benefits, it might limit scalability compared to using a separate file share. This option is more appropriate for smaller deployments or environments where the storage capacity and performance of the Azure Local instance can manage the additional load of the profile share, without affecting the performance of the session hosts. Because the selection of this option increases the Azure Local storage capacity and performance requirements, consider using an all-flash (all SSD or all NVMe) to provide increased storage performance, compared to hybrid storage.

## Session types

In Azure Virtual Desktop, user sessions can be classified into single-session and multi-session modes, each offering different performance and user experience options:

- **Single-session**: Each virtual machine (VM) hosts one user session, which is similar to a traditional virtual desktop infrastructure (VDI) model where each user has their own desktop experience. Single-session is ideal for [workloads that demand high performance](#azure-virtual-desktop-workload-types), custom configurations, or applications that do not work well in shared environments.

- **Multi-session**: A single VM hosts multiple user sessions simultaneously. This is optimized for cost-efficiency and scalability, where resources like CPU, memory, and storage are shared across users. Multi-session is suited for scenarios where users need access to standard applications or [lighter workload](#azure-virtual-desktop-workload-types), like task workers or shared workstations, as it consolidates resources across many users.

### Considerations between session types

Running single-session Azure Virtual Desktop for Azure Local can be resource-intensive, as it requires dedicated resources for each individual user. In contrast, Windows 10/11 multi-session allows multiple users to share the same virtual machine (VM) and its resources, making it a far more efficient option. Given that Windows 10 and 11 multi-session are available exclusively through Azure Virtual Desktop, it offers a compelling advantage in both cost savings and user experience. Leading with Windows 10/11 multi-session enables organizations to maximize their infrastructure by supporting more users per VM, reducing overall resource consumption while delivering a familiar, high-quality desktop experience.

The following section outlines the key factors that organizations should consider when selecting between single or multi-session environments.

#### 1. Cost savings

- **Single-session environment**:
  - Each user gets a dedicated virtual machine (VM).
  - Ensures consistent performance without resource competition.
  - Requires provisioning VMs for peak individual user demand.
  - Significantly increases resource requirements per user.

- **Multi-session environment**:
  - Multiple users share a single VM's resources.
  - Dynamically allocates resources based on current user needs.
  - Optimizes resource usage, reducing demand per user.
  - Increases user density on each node, leading to cost savings.
  - Potential for minor performance variability, but efficiencies generally outweigh this.

#### 2. Enhanced user experience

- **Single-session environment**:
  - Provides complete performance isolation between users.
  - Ideal for consistent performance needs and resource-intensive applications.
  - Eliminates impact of one user's activities on another's experience.

- **Multi-session environment**:
  - Maintains software isolation but could have hardware resource contention.
  - Balances high-quality experience for typical office tasks and general applications with lower costs.

#### 3. User customization

- **Single-session environment**:
  - Allows highly personalized setups for individual users.
  - Users can install and configure their own applications and settings.
  - Critical for scenarios requiring specific software versions or custom configurations.

- **Multi-session environment**:
  - Customization is limited to maintain stability for all users.
  - Administrators manage software installations and updates to avoid conflicts.
  - Restricts the level of personalization achievable by individual users.
  - Focuses on providing a consistent environment for all users.

### Recommendation

While single-session Azure Virtual Desktop for Azure Local offers dedicated resources, performance isolation, and extensive user customization, these benefits come with higher resource demands. **Organizations that prioritize efficient scaling and cost savings should consider Windows 10/11 multi-session as the optimal choice.** By sharing resources across users, multi-session deployments provide a compelling solution for businesses seeking to maximize their virtual desktop environments while maintaining high performance.

## Well-Architected Framework considerations

To help improve your Azure Virtual Desktop for Azure Local deployments, consider reviewing and implementing the recommendations from the five pillars of the Azure Well-Architected Framework. These are a set of guiding tenets that you can use to improve the reliability and quality of your workload solutions. For more information, see [Azure Well-Architected Framework perspective on Azure Stack HCI](/azure/well-architected/service-guides/azure-stack-hci).

### Reliability

Reliability ensures that your Azure Virtual Desktop for Azure Local deployment can consistently meet performance commitments of your end users, while maintaining availability in the face of disruptions. By adopting best practices in high availability, backup, monitoring, and automated recovery, you can ensure reliable access to virtual desktops.

#### Reliability considerations include

- **Implement multi-machine instances for high availability**: It is crucial to ensure high availability for Azure Virtual Desktop for Azure Local deployments. To minimize downtime caused by individual machine failures, deploy multiple machines in your instances. Azure Local supports clustering across physical machines, which means that virtual desktops can continue to operate even if one node goes offline. For business-critical or mission-critical use cases, we recommend that you deploy multiple instances of a workload or service across two or more separate Azure Local instances, ideally in separate physical locations. This redundancy also enables load balancing, which distributes virtual desktop session hosts (_Arc VMs_) across available physical machines within a single Azure Local instance. Refer to the following links for details on [recommendations for designing for redundancy](/azure/well-architected/reliability/redundancy) and [recommendations for highly available multi-region design](/azure/well-architected/reliability/highly-available-multi-region-design).
- **Plan and regularly test backup and restore procedures**: To safeguard against data loss, Azure Backup or similar backup solutions should be configured to regularly snapshot VMs and user profiles. Backup schedules ensure minimal data loss in the event of corruption or accidental deletion, providing a safety net for user data and configurations. Azure Site Recovery can also replicate virtual machines to an Azure region, providing another recovery capability in the event of an unplanned issue or disaster. For more information, see [backup cloud and on-premises workloads to cloud](/azure/backup/guidance-best-practices).

- **Implement monitoring and alerting**: Configuring health monitoring for Azure Local and Azure Virtual Desktop VMs is essential. Azure Monitor can be configured to track metrics such as CPU, memory, and storage usage, sending alerts when thresholds are breached. Health monitoring enables proactive mitigation of any potential issues before it impacts users. This item is covered in the Operational Excellence pillar, but can directly impact reliability if systems are not monitored effectively. To learn more, review [recommendations for designing and creating a monitoring system](/azure/well-architected/operational-excellence/observability).

- **Regularly test failover and disaster recovery**: Regular testing of failover and disaster recovery plans ensures that your recovery processes are effective and up-to-date. Testing these procedures helps identify gaps to help minimize downtime in the event of a failover. It is beneficial to simulate various failure scenarios such as power outages, hardware failures, and network issues, to validate your failover strategies. Learn more about [recommendations for designing a disaster recovery strategy](/azure/well-architected/reliability/disaster-recovery).

For more information, see [Well-Architected Framework Reliability principles](/azure/well-architected/reliability/checklist).

### Security

Security is fundamental to protecting your Azure Virtual Desktop for Azure Local environment from deliberate threats and unauthorized access, safeguarding valuable data and user trust. By implementing robust identity protection, network controls, and data encryption, you can create a secure virtual desktop experience that mitigates risks of attacks and data breaches.

#### Security considerations include

- **Enable multifactor authentication (MFA)**:  When users access Azure Virtual Desktop resources, Multi-Factor Authentication (MFA) adds an extra layer of security by requiring them to provide verification methods beyond just a password. MFA significantly reduces the risk of unauthorized access due to compromised credentials. Microsoft Entra ID (_formerly Azure Active Directory_) offers built-in MFA capabilities that integrate seamlessly with Azure Virtual Desktop, including deployments on Azure Local. For more information, see [recommendations for identity and access management.](/azure/well-architected/security/identity-access)

- **Regularly update and patch Virtual Desktops**: To mitigate security vulnerabilities, it's crucial to keep virtual machines operating systems and software up to date. Use tools like Azure Update Manager to automate patching your Azure Local instance and Azure Virtual Desktop session host VMs. Regular updates should include operating systems, applications, and security solutions to maintain a strong defense against threats. For more information, see [recommendations for establishing a security baseline](/azure/well-architected/security/establish-baseline).

- **Protect against threats and vulnerabilities**: Use Defender for Cloud to protect your Azure Local instances from threats and vulnerabilities. This service helps improve the security posture of your Azure Local environment and can protect against existing and evolving threats. For additional information, see [recommendations for threat analysis](/azure/well-architected/security/threat-model)

- **Network isolation**: Isolate networks if needed. For example, you can provision multiple logical networks that use separate VLANs and network address ranges. When you use this approach, ensure that the management network can reach each logical network and VLAN so that Azure Local instance nodes can communicate with the VLAN networks through the ToR switches or gateways. This configuration is required for management of the workload, such as allowing infrastructure management agents to communicate with the workload guest OS.

For more information, see [Well-Architected Framework Security design principles.](/azure/well-architected/security/checklist)

### Cost Optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. On Azure Virtual Desktop for Azure Local, this is crucial in minimizing hardware cost while maximizing the user experience and performance for each session.

#### Cost Optimization considerations include

- **Optimize VM sizing for cost efficiency**: To maximize available physical resources, right-size VMs based on usage patterns. Monitor CPU and memory usage over time so that you can adjust VM resources to best match the workload requirements. Efficient VM resource allocation provides a return on investment for your Azure Local hardware costs. For more information, see [recommendations for aligning usage to billing increments](/azure/well-architected/cost-optimization/align-usage-to-billing-increments).  

- **Automatic VM guest OS patching for Azure Arc VMs**: This feature helps reduce the overhead of manual patching and the associated maintenance costs. Not only does this action help make the system more secure, but it also optimizes resource allocation and contributes to overall cost efficiency. For more information, review [recommendations for optimizing personnel time](/azure/well-architected/cost-optimization/optimize-personnel-time)

- **Single vs multi-session types**: Azure Virtual Desktop offers you the option of single or multi-session setups, whereby each VM hosts either one or multiple user sessions respectively. Depending on your needs, you have the flexibility to choose either. However, running single-session Azure Virtual Desktop for Azure Local can be resource-intensive, as it requires dedicated resources for each individual user. In contrast, multi-session allows multiple users to share the same VM and its resources, making it a far more cost-effective option. Given that Windows 10 and 11 multi-session are available exclusively through Azure Virtual Desktop, it offers a compelling advantage in both cost savings and user experience. For more information, see [recommendations for optimizing scaling costs](/azure/well-architected/cost-optimization/optimize-scaling-costs).

- **Cost monitoring consolidation**: To consolidate monitoring costs, use Azure Local Insights and patch using Update Manager for Azure Local. Insights uses Azure Monitor to provide rich metrics and alerting capabilities.  To simplify the task of keeping your instances up to date, the lifecycle manager integrates with Update Manager to consolidate update workflows for various components into a single experience. To optimize resource allocation and contribute to overall cost efficiency, use Monitor and Update Manager. For more information, see [recommendations for consolidation](/azure/well-architected/cost-optimization/consolidation).

- **Initial workload capacity and growth**: When you plan your Azure Local deployment, create a cost model to consider your initial workload capacity, resiliency requirements, and future growth considerations. [Consider whether two or three-node storage switchless architecture](azure-stack-hci-switchless.yml) can reduce cost, such as removing the need to procure storage-class network switches. Procuring extra storage-class network switches can be an expensive component of new Azure Local instance deployments. Instead, you can use existing switches for management and compute networks, which simplify the infrastructure. If your workload capacity and resiliency needs don't scale beyond a three-node configuration, consider if you can use existing switches for the management and compute networks; and use the three-node storage switchless architecture to deploy Azure Local. For more information, see [recommendations for creating a cost model](/azure/well-architected/cost-optimization/cost-model).

- **Implement Azure Virtual Desktop auto-scaling**:  To optimize resource usage and costs, use Autoscale to scale available session hosts up or down according to a schedule. The elasticity of auto-scaling avoids the unnecessary use of hardware resources and helps to ensure that adequate capacity is available during peak usage. To reduce overall spending without compromising user experience, configure auto-scaling based on demand fluctuations. For more information, see [Well-Architected Framework Cost Optimization design principles](/azure/well-architected/cost-optimization/checklist).

### Operational Excellence

Operational excellence focuses on creating reliable processes to deploy, manage, and monitor Azure Virtual Desktop for Azure Local instances effectively, ensuring smooth operations in production environments. By building well-defined workflows, automating routine tasks, and setting up robust monitoring, you can streamline operations and reduce the risk of downtime.

#### Operational Excellence considerations include

- **Simplified provisioning and management experience integrated with Azure**: The cloud-based deployment in Azure provides a wizard-driven interface that shows you how to create an Azure Local instance. Similarly, Azure simplifies the process of managing Azure Local instances and Azure Arc VMs. You can automate the portal-based deployment of the Azure Local instance by using the ARM template. This template provides consistency and automation to deploy Azure Local at scale. To run business-critical workloads, the template is crucial in retail stores or manufacturing sites that require an Azure Local instance. For more information, see [recommendations for enabling automation](/azure/well-architected/operational-excellence/enable-automation).

- **Strict change control procedures**:  Before implementation in production, change control procedures require that all changes are tested and validated in a representative test environment. All changes that are submitted to the weekly change advisory board process must include an implementation plan or link to source code, risk level score, rollback plan, post-release tests, and clear success criteria for a change to be reviewed or approved. For more information, see [Recommendations for safe deployment practices](/azure/well-architected/operational-excellence/safe-deployments).

- **Automation capabilities for Virtual Machines**: Azure Local provides a wide range of automation capabilities for managing workloads such as:

  - Virtual Machine OS updates using Azure Arc Extension for Updates and Azure Update Manager to update Azure Local instance machines.
  - Local Azure CLI commands from one of the Azure Local machines or remotely using Cloud Shell, or a management computer.
  - Integration with Azure Automation and Azure Arc facilitates a wide range of automation scenarios for VM workloads through Azure Arc extensions.

  For more information, see [recommendations for using infrastructure as code](/azure/well-architected/operational-excellence/infrastructure-as-code-design).

- **Strict change control procedures**:  Before implementation in production, change control procedures should require that all changes are tested and validated in a representative test environment. All changes that are submitted to the weekly change advisory board process must include an implementation plan or link to source code, risk level score, rollback plan, post-release tests, and clear success criteria for a change to be reviewed or approved. For more information, see [Recommendations for safe deployment practices](/azure/well-architected/operational-excellence/safe-deployments).  

- **Configure robust monitoring and logging**: Use [Azure Local Insights](/azure-stack/hci/manage/monitor-hci-single-23h2) and [Azure Virtual Desktop Insights](/azure/virtual-desktop/whats-new-insights), to capture detailed metrics and logs for the platform and workload. These insights help identify performance issues and improve operational response times.

For more information, see [Well-Architected Framework Operational Excellence Design Principles](/azure/architecture/framework/operational-excellence/checklist).

### Performance Efficiency

Performance efficiency ensures that your Azure Virtual Desktop for Azure Local deployment can handle user demand effectively, especially during peak usage times. Scaling resources to meet concurrent user needs while optimizing for cost and responsiveness is crucial in maintaining high performance.

#### Performance Efficiency considerations include

- **Use load balancing for optimal performance**: To prevent any single VM from being a bottleneck, distribute network traffic evenly across Azure Virtual Desktop instances. Load balancers help improve responsiveness by evenly distributing user sessions, which is especially important during peak times. Azure Virtual Desktop supports built-in load balancing algorithms that manage user session distribution effectively. Breadth-First Load Balancing assigns new user sessions to the session host with the least number of connections, promoting an even distribution. Depth-First Load Balancing fills up one session host before moving on to the next, which can be efficient during low usage periods. To learn how to configure host pool load balancing in Azure Virtual Desktop, see [Configure host pool load balancing in Azure Virtual Desktop](/azure/virtual-desktop/configure-host-pool-load-balancing).

- **Optimize performance for Azure Virtual Desktops**:

  - **High-performance storage solutions**: Use high-speed storage options, such as NVMe or SSDs to reduce latency and improve input/output operations per second (IOPS) for your Azure Virtual Desktops for Azure Local. For more information, see [recommendations for selecting the right services](/azure/well-architected/performance-efficiency/select-services).

  - **Storage Spaces Direct (S2D)**: Azure Local uses Storage Spaces Direct (S2D) to pool the available storage from all physical machines, providing high-performance and resilient storage for your workloads. Define performance targets that are numerical values based on your workload performance requirements. You should implement performance targets for all workload flows. For more information, see [recommendations for defining performance targets](/azure/well-architected/performance-efficiency/performance-targets)

  - **Performance testing**: Conduct regular performance testing in an environment that matches the production environment. Compare results against your performance targets and performance baselines values, to detect drift or degradation over time. Your tests should include network latency considerations, such as the network communication path of the remote users. For more information, see [recommendations for performance testing](/azure/well-architected/performance-efficiency/performance-test).

For more information, see [Well-Architected Framework Performance Efficiency Design Principles](/azure/architecture/framework/performance-efficiency/checklist).

## Related resources

- [Hybrid architecture design](hybrid-start-here.md)
- [Azure hybrid options](../guide/technology-choices/hybrid-considerations.yml)
- [Azure Automation in a hybrid environment](azure-automation-hybrid.yml)
- [Azure Automation State Configuration](../example-scenario/state-configuration/state-configuration.yml)
- [Optimize administration of SQL Server instances in on-premises and multicloud environments by using Azure Arc](azure-arc-sql-server.yml)

## Next steps

Product documentation:

- [Azure Local version 23H2 release information](/azure-stack/hci/release-information-23h2)
- [AKS on Azure Local](/azure/aks/hybrid/aks-whats-new-23h2)
- [Azure Virtual Desktop for Azure Local](/azure/virtual-desktop/azure-stack-hci-overview)
- [What is Azure Local monitoring?](/azure-stack/hci/concepts/monitoring-overview)
- [Protect VM workloads with Site Recovery on Azure Local](/azure-stack/hci/manage/azure-site-recovery)
- [Azure Monitor overview](/azure/azure-monitor/overview)
- [Azure Update Manager overview](/azure/update-manager/guidance-migration-automation-update-management-azure-update-manager)
- [What is Azure Backup?](/azure/backup/backup-overview)

Product documentation for specific Azure services:

- [Azure Local](https://azure.microsoft.com/products/azure-stack/hci/)
- [Azure Arc](https://azure.microsoft.com/products/azure-arc)
- [Azure Key Vault](https://azure.microsoft.com/products/key-vault)
- [Azure Blob Storage](https://azure.microsoft.com/products/storage/blobs/)
- [Monitor](https://azure.microsoft.com/products/monitor)
- [Azure Policy](https://azure.microsoft.com/products/azure-policy)
- [Azure Container Registry](https://azure.microsoft.com/products/container-registry)
- [Microsoft Defender for Cloud](https://azure.microsoft.com/products/defender-for-cloud)
- [Azure Site Recovery](https://azure.microsoft.com/products/site-recovery)
- [Backup](https://azure.microsoft.com/products/backup)

Microsoft Learn training modules:

- [Configure Monitor](/training/modules/configure-azure-monitor)
- [Design your site recovery solution in Azure](/training/modules/design-your-site-recovery-solution-in-azure)
- [Introduction to Azure Arc-enabled servers](/training/modules/intro-to-arc-for-servers)
- [Introduction to Azure Arc-enabled data services](/training/modules/intro-to-arc-enabled-data-services)
- [Introduction to AKS](/training/modules/intro-to-azure-kubernetes-service)
- [Keep your virtual machines updated](/training/modules/keep-your-virtual-machines-updated)
