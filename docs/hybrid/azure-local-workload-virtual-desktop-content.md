This article describes how to choose and set up an Azure Virtual Desktop for Azure Local solution. Use this architecture to save time and effort when you deploy and manage your Azure Virtual Desktop for Azure Local solution.

Before you begin, understand the [Azure Local baseline reference architecture](azure-stack-hci-baseline.yml) so that you can get familiar with the design choices for the physical machines that deliver the compute, storage, and networking capabilities.

This article focuses on workload-specific design considerations, requirements, and scale limitations. Combine this guide with the existing [Azure Local catalog](https://azurestackhcisolutions.azure.microsoft.com/#catalog) and [Azure Local Sizer](https://azurestackhcisolutions.azure.microsoft.com/#/sizer) when you design an Azure Virtual Desktop for Azure Local solution.

For guidelines and recommendations about how to deploy highly available and resilient Azure Local instances, see [Azure Well-Architected Framework perspective on Azure Local](/azure/well-architected/service-guides/azure-stack-hci).

## Article layout

| Architecture | Design decisions | Azure Well-Architected Framework approach|
|---|---|---|
|&#9642; [Architecture](#architecture) <br>&#9642; [Workflow](#workflow) <br>&#9642;  [Components](#components) <br>&#9642; [Product overview](#product-overview) <br>&#9642; [Deploy this scenario](#deploy-this-scenario) <br>&#9642; [ARM templates](#arm-templates)|&#9642; [Workload design considerations](#workload-design-considerations)<br> &#9642; [User profiles and storage management](#manage-user-profiles-and-storage) <br> &#9642; [Session types](#session-types)  <br> &#9642; [Supported deployment configurations](#supported-deployment-configurations)|&#9642; [Reliability](#reliability) <br> &#9642; [Security](#security) <br> &#9642; [Cost Optimization](#cost-optimization) <br> &#9642; [Operational Excellence](#operational-excellence) <br> &#9642; [Performance Efficiency](#performance-efficiency)|

## Architecture

The following architecture shows a high-level overview of the Azure Virtual Desktop for Azure Local solution.

:::image type="content" source="images/azure-local-workload-virtual-desktop.svg" alt-text="Diagram that shows a reference architecture to deploy Azure Virtual Desktop on Azure Local." lightbox="images/azure-local-workload-virtual-desktop.svg" border="false":::

*Download a [PowerPoint file](https://arch-center.azureedge.net/virtual-desktop-azure-local.pptx) of this architecture.*

### Workflow

The steps in this workflow provide an overview of the end-to-end service, starting with the communication from the client device to the Azure Virtual Desktop cloud service. This workflow corresponds to the preceding diagram.

1. **A user device initiates connection:** An on-premises or remote user device runs the Azure Virtual Desktop client and initiates a connection to the Azure Virtual Desktop service in Azure.

1. **Microsoft Entra ID authenticates the user:**
   - *User authentication:* The Azure Virtual Desktop service in Azure interacts with [Microsoft Entra ID](https://www.microsoft.com/security/business/identity-access/microsoft-entra-id) to authenticate the user and perform a token exchange during sign in.

   - *Hybrid identity synchronization:* A hybrid identity synchronization occurs between the on-premises Active Directory Domain Services (AD DS) server and cloud-based Microsoft Entra ID. This process helps ensure that user identities are available for local authentication (for session hosts on Azure Local) and cloud access. This operation continuously runs in the background to keep the on-premises AD DS and Microsoft Entra ID in sync.

   - *The session host connects to on-premises AD DS:* The selected Azure Virtual Desktop session host connects to the on-premises AD DS server for user credential validation and applies any necessary group policies to configure the user's environment appropriately.

1. **The Azure Virtual Desktop agent communicates with Azure Virtual Desktop in Azure:** The Azure Virtual Desktop agent that's installed on the session host virtual machine (VM) communicates with the Azure Virtual Desktop service in Azure to manage session brokering, handle user sessions, and provide metering and diagnostics data.

1. **The Azure Arc agent manages the infrastructure:** The Azure Arc agent that runs on the session host VM helps provide security, governance, and monitoring capabilities. The Azure Resource Bridge component of the Azure Local instance orchestrates the Azure Arc VM lifecycle management operations.

1. **User profiles are stored in FSLogix containers:** [FSLogix containers](/fslogix/tutorial-configure-profile-containers) integrate with Azure Virtual Desktop to manage and roam user profiles and personalization. An ideal storage location for these profiles is on a dedicated network-attached storage (NAS) or Server Message Block (SMB) file share off the Azure Local instance or within the Storage Spaces Direct (S2D) pool on the Azure Local instance. This configuration provides efficient profile management and quick load times during user sessions.

### Components

These architecture resources are similar to the baseline reference architecture. For more information, see [Azure Local deployment resources](azure-stack-hci-baseline.yml#components).

## Product overview

The following sections provide an overview of Azure Virtual Desktop for Azure Local, Azure Arc VMs, and the benefits of the solution. For more information, see [Azure Virtual Desktop for Azure Local documentation](/azure/virtual-desktop/azure-stack-hci-overview).

### Azure Virtual Desktop for Azure Local

Azure Virtual Desktop for Azure Local is a desktop and application virtualization solution that combines the flexibility of Azure Virtual Desktop with the performance and reliability of Azure Local. You can use this setup to deliver secure, scalable virtual desktops and applications via your existing on-premises infrastructure.

### VMs in Azure Virtual Desktop

Azure Virtual Desktop uses Azure Arc VMs that run Windows to host remote end user sessions. Understand the specific requirements of the remote end user sessions so that you can accurately size your VMs and ultimately drive the design considerations for your Azure Virtual Desktop workloads.

> [!NOTE]
> In this article, all references to VMs refer to [Azure Arc VMs](/azure-stack/hci/manage/azure-arc-vm-management-overview).

Importantly, Azure Arc VMs maintain full compliance with Azure Virtual Desktop, which helps ensure that you can run these workloads without any compatibility problems. Azure Arc VMs also offer enhanced capabilities such as hybrid management, centralized policy enforcement, and integration with Azure services. You can create non-Azure Arc VMs, but they lack advanced management features and integration benefits.

### Benefits

Use Azure Virtual Desktop for Azure Local to take advantage of the following benefits:

- **Improve performance** for Azure Virtual Desktop users in areas that have poor connectivity to the Azure public cloud by giving them session hosts closer to their location.

- **Meet data locality requirements** by keeping application and user data on-premises.
- **Improve access to legacy on-premises apps and data sources** by keeping desktops and apps in the same location.
- **Reduce cost and improve user experience** by using Windows 10 and Windows 11 Enterprise multi-session, which provides multiple concurrent interactive sessions.
- **Simplify your virtual desktop infrastructure (VDI) deployment and management**, compared to traditional on-premises VDI solutions, by using the Azure portal.
- **Achieve the best performance** by using [RDP Shortpath](/azure/virtual-desktop/rdp-shortpath) for low-latency user access.
- **Deploy the latest fully patched images efficiently** by using [Azure Marketplace images](/azure-stack/hci/manage/virtual-machine-image-azure-marketplace).

### Key considerations

Consider the following key points when you deploy Azure Virtual Desktop for Azure Local:

- Each host pool must only contain session hosts on Azure or on Azure Local. You can't mix session hosts that are on Azure and Azure Local in the same host pool. The following diagram shows the logical separation of components.

  :::image type="content" source="images/azure-local-workload-virtual-desktop-logical-separation.svg" alt-text="Diagram that shows the logical separation for the components that run in Azure and Azure Local." lightbox="images/azure-local-workload-virtual-desktop-logical-separation.svg" border="false":::

- Azure Virtual Desktop for Azure Local connects to the Azure cloud via agents. The agents provide features such as extra governance, monitoring, and lifecycle management services, and identity management.

- Azure Local supports many types of hardware and on-premises networking capabilities, so performance and user density might vary compared to session hosts that run on Azure. Azure Virtual Desktop VM sizing guidelines are broad, so you should use them to initially estimate performance and to monitor your workload after deployment.
- You can only join session hosts on Azure Local to an AD DS domain.

## Workload design considerations

When you build an Azure Virtual Desktop for Azure Local solution, consider these key design elements:

- [Workload types](#azure-virtual-desktop-workload-types)
- [User profiles and storage management](#manage-user-profiles-and-storage)
- [Session types](#session-types)

### Azure Virtual Desktop workload types

Session host VMs in an Azure Virtual Desktop for Azure Local environment can accommodate a wide range of workload types, each with specific resource requirements. To help estimate the optimal sizing for your VMs, the following table presents examples of various [workload categories](/windows-server/remote/remote-desktop-services/virtual-machine-recs).

| Workload type | Example users                 | Example apps                                                                                         |
|---------------|-------------------------------|------------------------------------------------------------------------------------------------------|
| Light         | Users that do basic data entry tasks | Database entry applications, command-line interfaces                                                 |
| Medium        | Consultants and market researchers | Database entry applications, command-line interfaces, Word, static web pages               |
| Heavy         | Software engineers or content creators | Database entry applications, command-line interfaces, Word, static web pages, Outlook, PowerPoint, dynamic web pages, software development |
| Power         | Graphic designers, 3D model makers, or machine learning researchers | Database entry applications, command-line interfaces, Word, static web pages, Outlook, PowerPoint, dynamic web pages, photo and video editing, computer-aided design, computer-aided manufacturing |

> [!NOTE]
> Workload types, such as light, medium, heavy, and power, are indicative. We recommend that you use simulation tools and industry benchmarks, such as [LoginVSI](https://www.loginvsi.com/), to test your deployment by using stress tests and real-life usage simulations. The information in this article is based on point-in-time hardware data from solution builders and the latest Azure Local operating system specifications. Sizing estimates can change over time if these factors change.

## Manage user profiles and storage

Manage user profiles and storage efficiently in Azure Virtual Desktop to help ensure a consistent user experience. A user profile contains data elements about the individual, including configuration information like desktop settings, persistent network connections, and application settings.

[FSLogix](/azure/virtual-desktop/fslogix-profile-containers) is a Microsoft-recommended solution for profile management in virtual desktop environments. It helps simplify and enhance the user experience. FSLogix provides a robust and scalable approach to handle user profiles and helps ensure fast sign-in times and a consistent user experience across sessions. [FSLogix](/fslogix/overview-what-is-fslogix) uses profile containers to store user profiles in virtual hard disk files that are located either on the Azure Local instance itself or on a separate Azure or SMB-compatible file share. This method isolates user profiles, which helps prevent conflicts and helps ensure a personalized experience for each user. It also enhances security and performance. FSLogix integrates with Azure Virtual Desktop, which optimizes the management and performance of user profiles in single-session and multi-session environments.

When you deploy Azure Virtual Desktop for Azure Local, you can install FSLogix in one of two configurations to effectively manage user profiles.

### Use a separate file share

- **Location:** You can store FSLogix profiles on a dedicated file share within your on-premises environment. You can host this file share on an existing file server, NAS, or a dedicated storage solution that you configure to serve the Azure Local instance.

- **Benefits:** A separate file share provides centralized and scalable profile management. This approach is ideal for larger environments in which centralizing profile storage helps simplify management and improve scalability.

- **Considerations:** Network performance and latency are crucial. The file share must be highly accessible and have minimal latency to help ensure quick sign-in times and a consistent user experience. A robust network infrastructure helps support this setup.

- **Recommendation for large deployments:** If you want to scale beyond on-premises storage capacities, you can use cloud-based storage solutions like [Azure Files](/azure/storage/files/storage-files-introduction) or [Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-introduction). These options provide high availability, consistent performance, and simpler management. They also alleviate storage constraints on the Azure Local instance. They can offer better scalability and flexibility compared to on-premises file share solutions. When you use a cloud-based storage solution, consider network latency and bandwidth and throughput requirements and considerations.

### Use the same Azure Local instance

- **Location:** You can install FSLogix directly on the same Azure Local instance that hosts the Azure Virtual Desktop infrastructure. You can store the profile containers on the instance's storage.

- **Benefits:** This setup benefits from the high performance and low latency of local storage resources. This approach can provide faster access to profile data, which can improve the user experience. It also consolidates resources, which simplifies the deployment architecture.

- **Considerations:** This approach offers simplicity and performance benefits, but it might limit scalability compared to using a separate file share. This option is more appropriate for smaller deployments or environments. In smaller deployments, the storage capacity and performance of the Azure Local instance can manage the extra load of the profile share without affecting the performance of the session hosts. If you use this option, the Azure Local storage capacity and performance requirements increase. So consider using all-flash storage, such as all solid-state drive (SSD) or all Non-Volatile Memory Express (NVMe), rather than hybrid storage to improve storage performance.

## Session types

In Azure Virtual Desktop, user sessions can be classified into single-session and multi-session modes. Each mode offers different performance and user experience options.

- **Single-session mode:** Each VM hosts one user session, which is similar to a traditional VDI model in which each user has their own desktop experience. Single-session mode is ideal for [workloads that demand high performance](#azure-virtual-desktop-workload-types) and custom configurations or for applications that don't work well in shared environments.

- **Multi-session mode:** A single VM hosts multiple user sessions simultaneously. This mode optimizes cost efficiency and scalability because users share resources like CPU, memory, and storage. Multi-session mode is ideal for scenarios in which users need access to standard applications or [lighter workloads](#azure-virtual-desktop-workload-types), like task workers or shared workstations, because it consolidates resources across many users.

### Session type considerations

A single-session Azure Virtual Desktop for Azure Local can be resource-intensive because it requires dedicated resources for each individual user. In contrast, Windows 10 and Windows 11 multi-session allows multiple users to share the same VM and its resources. The multi-session method improves efficiency. Windows 10 and Windows 11 multi-session are available exclusively through Azure Virtual Desktop, so it offers a compelling advantage in both cost savings and user experience. Use Windows 10 or Windows 11 multi-session to support more users per VM and reduce overall resource consumption while delivering a familiar, high-quality desktop experience.

The following sections outline the key factors that you should consider when you choose between single-session or multi-session environments.

#### Cost

- **Single-session environment:**
  - Each user gets a dedicated VM.
  - Consistent performance without resource competition.
  - Requires provisioning VMs for peak individual user demand.
  - Significantly increases resource requirements per user.

- **Multi-session environment:**
  - Multiple users share a single VM's resources.
  - Dynamically allocates resources based on current user needs.
  - Optimizes resource usage, which reduces demand per user.
  - Increases user density on each node, which leads to cost savings.
  - Potential for minor performance variability, but efficiencies generally outweigh this potential problem.

#### User experience

- **Single-session environment:**
  - Provides complete performance isolation between users.
  - Ideal for consistent performance needs and resource-intensive applications.
  - Eliminates the impact of one user's activities on another's experience.

- **Multi-session environment:**
  - Maintains software isolation but could have hardware resource contention.
  - Balances high-quality experience for typical office tasks and general applications with lower costs.

#### User customization

- **Single-session environment:**
  - Provides highly personalized setups for individual users.
  - Users can install and configure their own applications and settings.
  - Critical for scenarios that require specific software versions or custom configurations.

- **Multi-session environment:**
  - Customization is limited to maintain stability for all users.
  - Administrators manage software installations and updates to avoid conflicts.
  - Restricts the level of personalization achievable by individual users.
  - Focuses on providing a consistent environment for all users.

### Recommendation

Single-session Azure Virtual Desktop for Azure Local offers dedicated resources, performance isolation, and extensive user customization, but these benefits come with higher resource demands. If you prioritize efficient scaling and cost savings, you should use Windows 10 or Windows 11 multi-session. Multi-session deployments share resources across users,  which provides a compelling solution if you want to maximize your virtual desktop environments while maintaining high performance.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

Implement this guidance to help maintain availability during disruptions. Adopt best practices for high availability, backup, monitoring, and automated recovery to help ensure reliable access to virtual desktops.

- **Implement multi-machine instances for high availability:** You must ensure high availability in Azure Virtual Desktop for Azure Local deployments. To minimize downtime that individual machine failures cause, deploy multiple machines in your instances. Azure Local supports clustering across physical machines, which means that virtual desktops can continue to operate even if one node goes offline. For business-critical or mission-critical use cases, we recommend that you deploy multiple instances of a workload or service across two or more separate Azure Local instances, ideally in separate physical locations. This redundancy also enables load balancing, which distributes virtual desktop session hosts (Azure Arc VMs) across available physical machines within a single Azure Local instance. For more information, see [Recommendations for designing for redundancy](/azure/well-architected/reliability/redundancy) and [Recommendations for highly available multi-region design](/azure/well-architected/reliability/highly-available-multi-region-design).

- **Plan and regularly test backup and restore procedures:** To safeguard against data loss, configure Azure Backup or similar backup solutions to regularly snapshot VMs and user profiles. Backup schedules help ensure minimal data loss if corruption or accidental deletion occurs. Backup schedules provide a safety net for user data and configurations. Azure Site Recovery can also replicate VMs to an Azure region, which provides another recovery capability if an unplanned problem or disaster occurs. For more information, see [Backup cloud and on-premises workloads to cloud](/azure/backup/guidance-best-practices).

- **Implement monitoring and alerting:** You must configure health monitoring for Azure Local and Azure Virtual Desktop VMs. Configure Azure Monitor to track metrics, such as CPU, memory, and storage usage, and to send alerts when thresholds are breached. Use health monitoring to proactively mitigate any potential problem before it affects users. Improperly monitored systems can directly affect reliability. For more information, see [Recommendations for designing and creating a monitoring system](/azure/well-architected/operational-excellence/observability).

- **Test failover and disaster recovery regularly:** Test failover and disaster recovery plans to help ensure effective and up-to-date recovery processes. Test these procedures to help identify gaps and minimize downtime if a failover occurs. Simulate various failure scenarios, such as power outages, hardware failures, and network problems, to validate your failover strategies. For more information, see [Recommendations for designing a disaster recovery strategy](/azure/well-architected/reliability/disaster-recovery).

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

Use this guidance to help safeguard valuable data and maintain user trust. Implement robust identity protection, network controls, and data encryption to help create a secure virtual desktop environment.

- **Enable Microsoft Entra multifactor authentication (MFA):**  When users access Azure Virtual Desktop resources, MFA adds an extra layer of security. Users must provide verification methods beyond just a password. MFA reduces the risk of unauthorized access because of compromised credentials. Microsoft Entra ID offers built-in MFA capabilities that integrate with Azure Virtual Desktop, including deployments on Azure Local. For more information, see [Recommendations for identity and access management](/azure/well-architected/security/identity-access).

- **Regularly update and patch Azure Virtual Desktop:** To help mitigate security vulnerabilities, keep VMs, operating systems, and software up to date. Use tools like Azure Update Manager to automate patching for your Azure Local instance and Azure Virtual Desktop session host VMs. Regular updates should include operating systems, applications, and security solutions to maintain a strong defense against threats. For more information, see [Recommendations for establishing a security baseline](/azure/well-architected/security/establish-baseline).

- **Protect against threats and vulnerabilities:** Use Microsoft Defender for Cloud to help protect your Azure Local instances from threats and vulnerabilities. This service helps improve the security posture of your Azure Local environment and can protect against existing and evolving threats. For more information, see [Recommendations for threat analysis](/azure/well-architected/security/threat-model).

- **Network isolation:** Isolate networks if needed. For example, you can provision multiple logical networks that use separate VLANs and network address ranges. When you use this approach, ensure that the management network can reach each logical network and virtual local area network (VLAN). This approach helps ensure that Azure Local instance nodes can communicate with the VLAN networks through the top-of-rack switches or gateways. You must use this configuration to manage the workload and to enable the infrastructure management agents to communicate with the workload guest operating system.

### Cost Optimization

Cost Optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

Use this guidance to help minimize hardware cost while optimizing the user experience and performance for each session.

- **Optimize VM sizing for cost efficiency:** To maximize available physical resources, rightsize VMs based on usage patterns. Monitor CPU and memory usage over time so that you can adjust VM resources to best match the workload requirements. Efficient VM resource allocation provides a return on investment for your Azure Local hardware costs. For more information, see [Recommendations for aligning usage to billing increments](/azure/well-architected/cost-optimization/align-usage-to-billing-increments).  

- **Use automatic VM guest operating system patching for Azure Arc VMs:** This feature helps reduce the overhead of manual patching and the associated maintenance costs. This approach helps make the system more secure and optimizes resource allocation, which contributes to overall cost efficiency. For more information, see [Recommendations for optimizing personnel time](/azure/well-architected/cost-optimization/optimize-personnel-time).

- **Choose a single-session or multi-session setup:** Azure Virtual Desktop offers single-session or multi-session setups, where each VM hosts either one or multiple user sessions. You can choose the setup that best suits your needs. Single-session Azure Virtual Desktop for Azure Local can be resource-intensive because it requires dedicated resources for each individual user. In contrast, multi-session allows multiple users to share the same VM and its resources, which makes it a more cost-effective option. Windows 10 and Windows 11 multi-session are available exclusively through Azure Virtual Desktop. For more information, see [Recommendations for optimizing scaling costs](/azure/well-architected/cost-optimization/optimize-scaling-costs).

- **Consolidate cost monitoring:** Use Azure Local Insights to consolidate monitoring costs, and use Update Manager for Azure Local to do patching. Insights uses Azure Monitor to provide rich metrics and alerting capabilities. To simplify the task of keeping your instances up to date, the lifecycle manager integrates with Update Manager to consolidate update workflows for various components into a single experience. To optimize resource allocation and contribute to overall cost efficiency, use Azure Monitor and Update Manager. For more information, see [Recommendations for consolidation](/azure/well-architected/cost-optimization/consolidation).

- **Plan for initial workload capacity and growth:** When you plan your Azure Local deployment, create a cost model to consider your initial workload capacity, resiliency requirements, and future growth considerations. Consider whether a [two-node or three-node storage switchless architecture](azure-stack-hci-switchless.yml) can reduce cost. For example, you might eliminate the need to obtain storage-class network switches. Extra storage-class network switches can be an expensive component of new Azure Local instance deployments. Instead, you can use existing switches for management and compute networks, which simplify the infrastructure. If your workload capacity and resiliency needs don't scale beyond a three-node configuration, consider whether you can use existing switches for the management and compute networks. Use the three-node storage switchless architecture to deploy Azure Local. For more information, see [Recommendations for creating a cost model](/azure/well-architected/cost-optimization/cost-model).

- **Implement Azure Virtual Desktop autoscaling:**  To optimize resource usage and costs, use the autoscale feature to scale available session hosts up or down according to a schedule. The elasticity of autoscaling avoids unnecessary hardware resource usage and helps to ensure that adequate capacity is available during peak usage. To reduce overall spending without compromising user experience, configure autoscaling based on demand fluctuations.

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

Use this guidance to create reliable processes to deploy, manage, and monitor Azure Virtual Desktop for Azure Local instances effectively. These processes help ensure smooth operations in production environments. You can also automate routine tasks and set up robust monitoring so that you can streamline operations and reduce the risk of downtime.

- **Take advantage of simplified provisioning and management in Azure:** The cloud-based deployment in Azure provides a wizard-driven interface that explains how to create an Azure Local instance. Similarly, Azure simplifies the process of managing Azure Local instances and Azure Arc VMs. You can use the Azure Resource Manager template (ARM template) to automate the portal-based deployment of the Azure Local instance. This template provides consistency and automation to deploy Azure Local at scale. The template is crucial for business-critical workloads, such as retail stores or manufacturing sites, that require an Azure Local instance. For more information, see [Recommendations for enabling automation](/azure/well-architected/operational-excellence/enable-automation).

- **Create strict change control procedures:**  Change control procedures require that you test and validate all changes in a representative test environment before you implement changes to production. All changes that are submitted to the weekly change advisory board process must include specific criteria for a change to be reviewed or approved. The submitted changes must include an implementation plan or link to source code, a risk level score, a rollback plan, post-release tests, and clear success criteria. For more information, see [Recommendations for safe deployment practices](/azure/well-architected/operational-excellence/safe-deployments).

- **Use automation capabilities for VMs:** Azure Local provides a wide range of automation capabilities to manage workloads.

  - Use the Azure Arc extension for updates to manage VM operating system updates. Use Update Manager to update Azure Local instance machines.
  
  - Use Azure Local Azure CLI commands from one of the Azure Local machines or remotely via Cloud Shell or a management computer.
  - Integrate with Azure Automation and Azure Arc to get a wide range of automation scenarios for VM workloads through Azure Arc extensions.

  For more information, see [Recommendations for using infrastructure as code](/azure/well-architected/operational-excellence/infrastructure-as-code-design).

- **Configure robust monitoring and logging:** Use [Azure Local Insights](/azure-stack/hci/manage/monitor-hci-single-23h2) and [Azure Virtual Desktop Insights](/azure/virtual-desktop/whats-new-insights) to capture detailed metrics and logs for the platform and workload. These insights help identify performance problems and improve operational response times.

### Performance Efficiency

Performance Efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

- **Use load balancing for optimal performance:** To prevent any single VM from being a bottleneck, distribute network traffic evenly across Azure Virtual Desktop instances. Load balancers help improve responsiveness by evenly distributing user sessions, which is especially important during peak times. Azure Virtual Desktop supports built-in load balancing algorithms that manage user session distribution effectively. *Breadth-first* load balancing assigns new user sessions to the session host that has the least number of connections, which helps create an even distribution. *Depth-first* load balancing fills one session host to capacity before it moves to the next. This approach can improve efficiency during periods of low usage. For more information, see [Configure host pool load balancing in Azure Virtual Desktop](/azure/virtual-desktop/configure-host-pool-load-balancing).

- **Optimize performance for Azure Virtual Desktop:**

  - *Use high-performance storage solutions:* Use high-speed storage options, such as NVMe or SSDs, to reduce latency and improve input/output operations per second (IOPS) for Azure Virtual Desktop for Azure Local. For more information, see [Recommendations for selecting the right services](/azure/well-architected/performance-efficiency/select-services).

  - *Take advantage of Storage Spaces Direct (S2D):* Azure Local uses S2D to pool the available storage from all physical machines, which provides high-performance and resilient storage for your workloads. Define performance targets that are numerical values based on your workload performance requirements. You should implement performance targets for all workload flows. For more information, see [Recommendations for defining performance targets](/azure/well-architected/performance-efficiency/performance-targets).

  - *Do performance testing:* Conduct regular performance testing in an environment that matches the production environment. To detect drift or degradation over time, compare results against your performance targets and performance baseline values. Your tests should include network latency considerations, such as the network communication path of the remote users. For more information, see [Recommendations for performance testing](/azure/well-architected/performance-efficiency/performance-test).

## Deploy this scenario

### Prerequisites

For Azure Virtual Desktop requirements and supported components, such as operating systems, virtual networks, and identity providers, see [Prerequisites for Azure Virtual Desktop](/azure/virtual-desktop/prerequisites). That article also includes a list of the [supported Azure regions](/azure/virtual-desktop/prerequisites#azure-regions) in which you can deploy host pools, workspaces, and application groups. You can store the metadata for the host pool in these regions. You can place session hosts in any Azure region and on-premises by using [Azure Local](/azure/virtual-desktop/azure-stack-hci-overview). For more information, see [Data locations for Azure Virtual Desktop](/azure/virtual-desktop/data-locations).

### Supported deployment configurations

Your Azure Local instances must run [version 23H2](/azure/azure-local/release-information-23h2) at a minimum. After the instance is deployed and ready, you can use the following 64-bit operating system images for your session host's Azure Arc VMs:

- Windows 11 Enterprise multi-session
- Windows 11 Enterprise
- Windows 10 Enterprise multi-session
- Windows 10 Enterprise
- Windows Server 2022
- Windows Server 2019

To use session hosts on Azure Local with Azure Virtual Desktop, you also need to:

1. **License and activate the VMs.** To activate Windows 10 or Windows 11 Enterprise multi-session and Windows Server 2022 Datacenter: Azure Edition, use [Azure verification for VMs](/azure-stack/hci/deploy/azure-verification). For all other operating system images, such as Windows 10 and Windows 11 Enterprise or other editions of Windows Server, you should continue to use existing activation methods. For more information, see [Activate Windows Server VMs on Azure Local](/azure-stack/hci/manage/vm-activate).

1. **Install the Azure Connected Machine agent on the VMs** so they can communicate with [Azure Instance Metadata Service](/azure/virtual-machines/instance-metadata-service), which is a [required endpoint for Azure Virtual Desktop](/azure/virtual-desktop/required-fqdn-endpoint). The [Azure Connected Machine agent](/azure/azure-arc/servers/agent-overview) automatically installs when you add session hosts via the Azure portal, as part of the process to [deploy Azure Virtual Desktop](/azure/virtual-desktop/deploy-azure-virtual-desktop) or [add session hosts to a host pool](/azure/virtual-desktop/add-session-hosts-host-pool).

After you complete these steps, users can connect to the session hosts via the same [Remote Desktop clients](/azure/virtual-desktop/connect-azure-virtual-desktop) that they use for Azure Virtual Desktop.

### Deployment methods

You can use the following resources to deploy Azure Virtual Desktop for Azure Local:

- The Azure portal
- Azure PowerShell
- Azure CLI

Follow the [deployment steps](/azure/virtual-desktop/deploy-azure-virtual-desktop), including the prerequisites and how to create a host pool, workspace, application group, and assignment.

#### ARM templates

Use [ARM templates](/azure/azure-resource-manager/templates/overview) to streamline the Azure Virtual Desktop workload deployment. ARM templates help provide automation, consistency, and repeatability when you deploy Azure resources.

For an example ARM template and parameter file to deploy an Azure Local instance, see the [Azure Stack HCI 23H2 cluster ARM template](https://github.com/Azure/azure-quickstart-templates/tree/master/quickstarts/microsoft.azurestackhci/create-cluster-2-node-switched-custom-storageip).

For a foundation to build and manage your Azure Virtual Desktop deployments, see the [Azure Virtual Desktop for Azure Local ARM template](https://github.com/Azure/RDS-Templates/blob/master/ARM-wvd-templates/HCI/QuickDeploy/CreateHciHostpoolQuickDeployTemplate.json).

#### Terraform

You can use Terraform to deploy Azure Local instances, logical networks, and Azure Arc VMs. No providers can deploy Azure Virtual Desktop. The following Terraform providers can deploy Azure Local components:

- **Azure Local instance:** [Azure/avm-res-azurestackhci-cluster/azurerm](https://registry.terraform.io/modules/Azure/avm-res-azurestackhci-cluster/azurerm)

- **Logical network:** [Azure/avm-res-azurestackhci-logicalnetwork/azurerm](https://registry.terraform.io/modules/Azure/avm-res-azurestackhci-logicalnetwork/azurerm)

- **VM:** [Azure/avm-res-azurestackhci-virtualmachineinstance/azurerm](https://registry.terraform.io/modules/Azure/avm-res-azurestackhci-virtualmachineinstance/azurerm)

For a consolidated list of recent feature updates, see [What's new in Azure Virtual Desktop](/azure/virtual-desktop/whats-new).

## Next steps

- [Azure Virtual Desktop for Azure Local](/azure/virtual-desktop/azure-stack-hci-overview)
- [What is Azure Local monitoring?](/azure-stack/hci/concepts/monitoring-overview)
- [Protect VM workloads with Site Recovery on Azure Local](/azure-stack/hci/manage/azure-site-recovery)
- [Training: Introduction to Azure Arc-enabled servers](/training/modules/intro-to-arc-for-servers)
- [Training: Introduction to Azure Arc-enabled data services](/training/modules/intro-to-arc-enabled-data-services)

## Related resources

- [Hybrid architecture design](hybrid-start-here.md)
- [Azure hybrid options](../guide/technology-choices/hybrid-considerations.yml)
- [Optimize administration of SQL Server instances in on-premises and multicloud environments by using Azure Arc](azure-arc-sql-server.yml)

