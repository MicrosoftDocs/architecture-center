This article describes how to choose and set up an Azure Virtual Desktop on Azure Local solution. Use this architecture to simplify deployment and management of an Azure Virtual Desktop on Azure Local solution.

Before you start, review the [Azure Local baseline reference architecture](azure-local-baseline.yml) to familiarize yourself with the design choices for the physical machines that deliver the compute, storage, and networking capabilities.

This article focuses on workload-specific design considerations, requirements, and scale limitations. Combine this guide with the existing [Azure Local catalog](https://azurelocalsolutions.azure.microsoft.com/#catalog) and [Azure Local sizer](https://azurelocalsolutions.azure.microsoft.com/#/sizer) when you design an Azure Virtual Desktop on Azure Local solution.

For guidelines and recommendations about how to deploy highly available and resilient Azure Local instances, see [Architecture best practices for Azure Local](/azure/well-architected/service-guides/azure-local).

## Architecture

The following architecture shows a high-level overview of an Azure Virtual Desktop on Azure Local solution.

:::image type="complex" source="images/azure-virtual-desktop-azure-local.svg" alt-text="Diagram that shows a reference architecture to deploy Azure Virtual Desktop on Azure Local." lightbox="images/azure-virtual-desktop-azure-local.svg" border="false":::
   At the top of the diagram, a control plane box contains the Azure portal, an Azure Resource Manager template (ARM template) and Bicep templates, and the Azure CLI and tools. Below the control plane is another box that contains Azure services, including Microsoft Entra ID, Azure Virtual Desktop, Azure Site Recovery, Azure Backup, Azure Policy, Azure Monitor, Azure File Sync, Azure Update Manager, Azure Key Vault, Microsoft Defender for Cloud, and other Azure services that integrate via Azure Arc. Below the Azure services box is a box that contains Active Directory Domain Services (AD DS) and a box that contains Azure Virtual Desktop client and user devices. In the lower half of the diagram, a large box indicates an Azure Local instance. Inside of that box are Azure Local virtual machines (VMs), Azure Virtual Desktop session hosts, including the agents for Azure Virtual Desktop and Azure Arc, and Azure Local version releases, including Hyper-V, Azure Arc resource bridge, Storage Spaces Direct (S2D), and user profiles. To the right of the Azure Local instance box is a box that contains user profiles and network-attached storage (NAS) or Server Message Block (SMB) file share. An arrow labeled one points from the user devices to Azure Virtual Desktop and indicates session initiation. Another bidirectional arrow that indicates a Remote Desktop Protocol (RDP) Shortpath or User Datagram Protocol (UDP) Direct connection connects user devices and Azure Virtual Desktop session hosts. A bidirectional arrow labeled two connects Microsoft Entra ID to Azure Virtual Desktop and indicates user authentication and token exchange during sign-in. Another bidirectional arrow connects Microsoft Entra ID and AD DS, which performs hybrid identity sync between on-premises AD DS and cloud-based Microsoft Entra ID for local authentication and cloud access. User credential validation and group policy application flow to and from AD DS and the Azure Virtual Desktop session hosts in the Azure Local instance. An arrow labeled three points from the Azure Virtual Desktop session hosts to Azure Virtual Desktop to indicate session brokering, user sessions, metering, and diagnostics. A bidirectional arrow labeled four connects other Azure services and the Azure Arc agent. It shows how the Azure Arc agent integrates for extra governance, monitoring, and life cycle management. Bidirectional arrows labeled five connect user profiles inside and outside of the Azure Local instance section and Azure Virtual Desktop session hosts. The system preferably stores user profiles in a dedicated NAS or SMB file share. It can also store them in an S2D pool on the Azure Local instance.
:::image-end:::

*Download a [PowerPoint file](https://arch-center.azureedge.net/azure-virtual-desktop-azure-local.pptx) of this architecture.*

### Workflow

The following workflow corresponds to the previous diagram. The steps in this workflow provide an overview of an Azure Virtual Desktop on Azure Local solution. It starts with communication from the client device to the Azure Virtual Desktop cloud service.

1. **A user device initiates a connection.** An on-premises or remote user device runs the Azure Virtual Desktop client and initiates a connection to the Azure Virtual Desktop service in Azure.

1. **Microsoft Entra ID authenticates the user.**

   - *User authentication:* The Azure Virtual Desktop service in Azure interacts with [Microsoft Entra ID](https://www.microsoft.com/security/business/identity-access/microsoft-entra-id) to authenticate the user and exchange tokens during sign in.

   - *Hybrid identity:* When you use hybrid identities, the on-premises Active Directory Domain Services (AD DS) server and cloud-based Microsoft Entra ID sync. This process helps ensure that user identities are available for local authentication, like for session hosts on Azure Local, and for cloud access. This operation continuously runs in the background to keep the on-premises AD DS and Microsoft Entra ID in sync. After initial authentication with Microsoft Entra ID, the selected Azure Virtual Desktop session host connects to the on-premises AD DS server for user credential validation and applies necessary group policies to configure the user's environment as intended.
   
   - *Cloud-only identity:* For Microsoft Entra ID-joined session hosts, user authentication and session host assignment happen within Microsoft Entra ID.

1. **The Azure Virtual Desktop agent communicates with Azure Virtual Desktop in Azure.** The Azure Virtual Desktop agent installed on the session host virtual machine (VM) communicates with the Azure Virtual Desktop service in Azure to manage session brokering, handle user sessions, and provide metering and diagnostics data.

1. **The Azure Arc agent manages the infrastructure.** The Azure Arc agent that runs on the session host VM helps provide security, governance, and monitoring capabilities. The Azure resource bridge component of the Azure Local instance orchestrates the Azure Local VM life cycle management operations.

1. **FSLogix containers store user profiles.** [FSLogix containers](/fslogix/how-to-configure-profile-containers) integrate with Azure Virtual Desktop to manage and roam user profiles and personalization. An ideal storage location for these profiles is on a dedicated network-attached storage (NAS) or Server Message Block (SMB) file share off the Azure Local instance or within the Storage Spaces Direct (S2D) pool on the Azure Local instance. This configuration provides efficient profile management and quick load times during user sessions.

### Components

These architecture resources are similar to the baseline reference architecture. For more information, see [Azure Local deployment resources](azure-local-baseline.yml#components).

## Scenario details

The following sections provide an overview of Azure Virtual Desktop on Azure Local, Azure Local VMs, and the benefits of the solution. For more information, see [Azure Virtual Desktop on Azure Local](/azure/virtual-desktop/azure-local-overview).

### Azure Virtual Desktop on Azure Local

Azure Virtual Desktop on Azure Local is a desktop and application virtualization solution that combines the flexibility of Azure Virtual Desktop with the performance and reliability of Azure Local. You can use this setup to deliver secure, scalable virtual desktops and applications via your existing on-premises infrastructure.

### VMs in Azure Virtual Desktop

Azure Virtual Desktop uses Azure Local VMs that run Windows to host remote user sessions. Understand the specific requirements of the remote user sessions so that you can accurately size your VMs and drive the design considerations for your Azure Virtual Desktop workloads.

> [!NOTE]
> In this article, all references to VMs refer to [Azure Local VMs](/azure/azure-local/manage/azure-arc-vm-management-overview).

Azure Local VMs maintain full compliance with Azure Virtual Desktop, which helps ensure that you can run these workloads without any compatibility problems. Azure Local VMs also provide enhanced capabilities like hybrid management, centralized policy enforcement, and integration with Azure services. You can create VMs not managed by Azure Local, but they lack advanced management features and integration benefits.

### Benefits

Use Azure Virtual Desktop on Azure Local to take advantage of the following benefits:

- **Improve performance** for Azure Virtual Desktop users in areas that have poor connectivity to the Azure public cloud by giving them session hosts closer to their location.

- **Meet data locality requirements** by keeping application and user data on-premises.

- **Improve access to legacy on-premises apps and data sources** by keeping desktops and apps in the same location.

- **Reduce cost and improve user experience** by using Windows 10 and Windows 11 Enterprise multi-session editions, which provide multiple concurrent interactive sessions.

- **Simplify your virtual desktop infrastructure (VDI) deployment and management**, compared to traditional on-premises VDI solutions, by using the Azure portal.

- **Achieve the best performance** by using [Remote Desktop Protocol (RDP) Shortpath](/azure/virtual-desktop/rdp-shortpath) for low-latency user access.

- **Deploy the latest fully patched images efficiently** by using [Microsoft Marketplace images](/azure/azure-local/manage/virtual-machine-image-azure-marketplace).

### Key considerations

Consider the following key points when you deploy Azure Virtual Desktop on Azure Local:

- Each host pool must only contain session hosts on Azure or on Azure Local. You can't mix session hosts that are on Azure and Azure Local in the same host pool, but you can have both Azure and Azure Local host pools in the same subscription.

- Azure Virtual Desktop on Azure Local connects to the Azure cloud via agents. The agents provide features like extra governance, monitoring, and life cycle management services, and identity management.

- Azure Local supports many types of hardware and on-premises networking capabilities, so performance and user density might vary compared to session hosts that run on Azure. Azure Virtual Desktop VM sizing guidelines are broad, so use them as a reference point to initially estimate performance and to monitor your workload after deployment.

## Workload design considerations

When you build an Azure Virtual Desktop on Azure Local solution, consider these key design elements:

- [Workload types](#azure-virtual-desktop-workload-types)
- [User profiles and storage management](#manage-user-profiles-and-storage)
- [Session types](#session-types)

### Azure Virtual Desktop workload types

Session host VMs in an Azure Virtual Desktop on Azure Local environment can accommodate a range of workload types that each have specific resource requirements. To help estimate the optimal sizing for your VMs, the following table presents examples of various [workload categories](/windows-server/remote/remote-desktop-services/session-host-virtual-machine-sizing-guidelines).

| Workload type | Example users | Example apps |
|---------------|---------------|--------------|
| Light | Users that do basic data entry tasks | Database entry applications, command-line interfaces |
| Medium | Consultants and market researchers | Database entry applications, command-line interfaces, Word, static web pages |
| Heavy | Software engineers or content creators | Database entry applications, command-line interfaces, Word, static web pages, Outlook, PowerPoint, dynamic web pages, software development |
| Power | Graphic designers, 3D model makers, or machine learning researchers | Database entry applications, command-line interfaces, Word, static web pages, Outlook, PowerPoint, dynamic web pages, photo and video editing, computer-aided design, computer-aided manufacturing |

> [!NOTE]
> Light, medium, heavy, and power workload types are intended only as examples. We recommend that you use simulation tools and industry benchmarks, like [LoginVSI](https://www.loginvsi.com), to test your deployment by using stress tests and real-life usage simulations. The information in this article is based on point-in-time hardware data from solution builders and the latest Azure Local operating system specifications. Sizing estimates can change over time if these factors change.

### Manage user profiles and storage

Manage user profiles and storage efficiently in Azure Virtual Desktop to help ensure a consistent user experience. A user profile contains data about the individual, including configuration information like desktop settings, persistent network connections, and application settings.

We recommend that you use [FSLogix](/fslogix/overview-what-is-fslogix) for profile management in virtual desktop environments. It provides a reliable, scalable approach to handling user profiles and helps ensure fast sign-in times and a consistent user experience across sessions. FSLogix uses [profile containers](/azure/virtual-desktop/fslogix-profile-containers) to store user profiles in virtual hard disk files located on the Azure Local instance or on a separate Azure or SMB-compatible file share. This method isolates user profiles, which helps prevent conflicts and ensures a personalized experience for each user. FSLogix integrates with Azure Virtual Desktop, which optimizes the management and performance of user profiles in single-session and multiple-session environments.

When you deploy Azure Virtual Desktop on Azure Local, you can install FSLogix in one of two configurations to effectively manage user profiles.

#### Use a separate file share

- **Location:** You can store FSLogix profiles on a dedicated file share within your on-premises environment. You can host this file share on an existing file server, NAS, or a dedicated storage solution that you configure to serve the Azure Local instance.

- **Benefits:** A separate file share provides centralized and scalable profile management. This approach is ideal for larger environments in which centralized profile storage helps simplify management and improve scalability.

- **Considerations:** Network performance and latency are crucial. The file share must provide high availability and minimal latency to help ensure quick sign-in times and a consistent user experience. A reliable network infrastructure helps support this setup.

- **Recommendation for large deployments:** If you want to scale beyond on-premises storage capacities, you can use cloud-based storage solutions like [Azure Files](/azure/storage/files/storage-files-introduction) or [Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-introduction). These options provide high availability, consistent performance, and simpler management, while also alleviating storage constraints on the Azure Local instance. They can provide better scalability and flexibility compared to on-premises file share solutions. When you use a cloud-based storage solution, consider network latency, bandwidth, and throughput requirements compared to on-premises options.

#### Use the same Azure Local instance

- **Location:** You can install FSLogix directly on the same Azure Local instance that hosts the Azure Virtual Desktop infrastructure. You can store the profile containers on the instance's storage.

- **Benefits:** This setup benefits from the high performance and low latency of local storage resources. This approach can provide faster access to profile data, which improves the user experience. It also consolidates resources, which simplifies the deployment architecture.

- **Considerations:** This approach provides simplicity and performance benefits, but it might limit scalability compared to using a separate file share. This option is more suitable for smaller deployments or environments. In smaller deployments, the storage capacity and performance of the Azure Local instance can manage the extra load of the profile share without affecting session host performance.

   If you use this option, the Azure Local storage capacity and performance requirements increase. So consider using all-flash storage, like all solid-state drive (SSD) or all Non-Volatile Memory Express (NVMe), rather than hybrid storage to improve storage performance.

### Session types

In Azure Virtual Desktop, you can classify user sessions into single-session or multiple-session types. Each type provides different performance and user experience options.

- **Single-session:** Each VM hosts one user session at a time, which is similar to a traditional VDI model in which each user has their own desktop experience. Single-session mode is ideal for [workloads that require high performance](#azure-virtual-desktop-workload-types) and custom configurations or for applications that don't work well in shared environments.

- **Multiple-session:** A single VM can host multiple user sessions simultaneously. This mode optimizes cost efficiency and scalability because users share resources like CPU, memory, and storage. Multiple-session environments are ideal when users need access to standard applications or [lighter workloads](#azure-virtual-desktop-workload-types), like task workers or shared workstations, because it consolidates resources across many users.

#### Session type considerations

A single-session Azure Virtual Desktop on Azure Local environment can be resource-intensive because it requires dedicated resources for each user. By comparison, Windows 10 and Windows 11 Enterprise multi-session editions support multiple user sessions concurrently on the same VM, which improves resource efficiency. Windows 10 and Windows 11 Enterprise multi-session editions provide cost savings and user experience advantages.

The following sections outline the key factors to consider when you choose between single-session or multiple-session environments.

##### Cost

- **Single-session environment:**
  - A dedicated VM for each user
  - Consistent performance without resource competition
  - Provisioned VMs for peak user demand
  - Increased resource requirements for each user

- **Multiple-session environment:**
  - Shared VM resources for multiple users
  - Dynamic resource allocation based on current user needs
  - Increased user density on each node, which maximizes resource utilization
  - Potential for minor performance variability, but efficiencies generally outweigh this potential problem

##### User experience

- **Single-session environment:**
  - Provides complete performance isolation between users
  - Ideal for consistent performance needs and resource-intensive applications
  - Eliminates the impact of one user's activities on another user's experience

- **Multiple-session environment:**
  - Maintains software isolation but might have hardware resource contention
  - Balances high-quality experience for typical office tasks and general applications with lower costs

##### User customization

- **Single-session environment:**
  - Provides highly personalized setups for each user.
  - Users can install and configure their own applications and settings.
  - Critical for scenarios that require specific software versions or custom configurations.

- **Multiple-session environment:**
  - Customization is limited to maintain stability for all users.
  - Administrators manage software installations and updates to avoid conflicts.
  - Restricts the level of personalization that each user can achieve.
  - Focuses on providing a consistent environment for all users.

#### Recommendation

Single-session Azure Virtual Desktop on Azure Local provides dedicated resources, performance isolation, and extensive user customization at the expense of higher resource requirements. If resource optimization is a higher priority, multiple-session deployments can maximize resource utilization while maintaining high performance.

## Considerations

These considerations implement the pillars of the Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

Implement this guidance to help maintain availability during disruptions. Adopt best practices for high availability, backup, monitoring, and automated recovery to help ensure reliable access to virtual desktops.

- **Implement multiple-machine instances for high availability.** You must ensure high availability in Azure Virtual Desktop on Azure Local deployments. To minimize downtime that individual machine failures cause, deploy multiple machines in your instances. Azure Local supports clustering across physical machines, which means that virtual desktops can continue to operate even if one node goes offline. 

   For business-critical or mission-critical use cases, we recommend that you deploy multiple instances of a workload or service across two or more separate Azure Local instances, ideally in separate physical locations. This redundancy also allows load balancing, which distributes virtual desktop session hosts, like Azure Local VMs, across available physical machines within a single Azure Local instance. For more information, see [Architecture strategies for designing for redundancy](/azure/well-architected/reliability/redundancy).

- **Plan and regularly test backup and restore procedures.** To safeguard against data loss, configure Azure Backup or similar backup solutions to regularly snapshot VMs and user profiles. Backup schedules help ensure minimal data loss if corruption or accidental deletion occurs. Backup schedules provide a safety net for user data and configurations. Azure Site Recovery can also replicate VMs to an Azure region, which provides another recovery capability if an unplanned problem or disaster occurs. For more information, see [Back up cloud and on-premises workloads to the cloud](/azure/backup/guidance-best-practices).

- **Implement monitoring and alerting.** You must set up health monitoring for Azure Local and Azure Virtual Desktop VMs. Configure Azure Monitor to track metrics like CPU, memory, and storage usage and to send alerts when VMs breach thresholds. Use health monitoring to proactively mitigate potential problems before they affect users. Improperly monitored systems can directly affect reliability. For more information, see [Architecture strategies for designing a monitoring system](/azure/well-architected/operational-excellence/observability).

- **Test failover and disaster recovery regularly.** Test failover and [disaster recovery](/azure/azure-local/manage/disaster-recovery-overview) plans to help ensure effective and up-to-date recovery processes. Test these procedures to help identify gaps and minimize downtime if a failover occurs. Simulate various failure scenarios, like power outages, hardware failures, and network problems, to validate your failover strategies. For more information, see [Architecture strategies for disaster recovery](/azure/well-architected/reliability/disaster-recovery).

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

Use this guidance to help safeguard valuable data and maintain user trust. Implement reliable identity protection, network controls, and data encryption to help create a secure virtual desktop environment.

- **Turn on Microsoft Entra multifactor authentication (MFA).** When users access Azure Virtual Desktop resources, MFA adds an extra layer of security. Users must provide verification methods beyond a password. MFA reduces the risk of unauthorized access because of compromised credentials. Microsoft Entra ID provides built-in MFA capabilities that integrate with Azure Virtual Desktop, including deployments on Azure Local. For more information, see [Architecture strategies for identity and access management](/azure/well-architected/security/identity-access).

- **Update and patch Azure Virtual Desktop regularly.** To help mitigate security vulnerabilities, keep VMs, operating systems, and software up-to-date. Use tools like Azure Update Manager to automate patching for your Azure Local instance and Azure Virtual Desktop session host VMs. Regular updates should include operating systems, applications, and security solutions to maintain a strong defense against threats. For more information, see [Architecture strategies for establishing a security baseline](/azure/well-architected/security/establish-baseline).

- **Protect against threats and vulnerabilities.** Use Microsoft Defender for Cloud to help protect your Azure Local instances from threats and vulnerabilities. This service helps improve the security posture of your Azure Local environment and can protect against existing and evolving threats. For more information, see [Architecture strategies for threat analysis](/azure/well-architected/security/threat-model).

- **Isolate networks.** Isolate networks if needed. For example, you can provision multiple logical networks that use separate virtual local area networks (VLANs) and network address ranges. When you use this approach, ensure that the management network can reach each logical network VLAN. This approach helps ensure that Azure Local instance nodes can communicate with the VLAN networks through top-of-rack (ToR) switches or gateways. You must use this configuration to manage the workload and allow the infrastructure management agents to communicate with the workload guest operating system.

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

Use this guidance to help minimize hardware cost while optimizing the user experience and performance for each session.

- **Optimize VM sizing for cost efficiency.** To maximize available physical resources, rightsize VMs based on usage patterns. Monitor CPU and memory usage over time so that you can adjust VM resources to best match the workload requirements. Efficient VM resource allocation provides a return on investment (ROI) for your Azure Local hardware costs. For more information, see [Architecture strategies for aligning usage to billing increments](/azure/well-architected/cost-optimization/align-usage-to-billing-increments).

- **Use automatic VM guest operating system patching for Azure Local VMs.** This feature helps reduce the overhead of manual patching and the associated maintenance costs. This approach helps improve system security and optimizes resource allocation, which contributes to overall cost efficiency. For more information, see [Architecture strategies for optimizing personnel time](/azure/well-architected/cost-optimization/optimize-personnel-time).

- **Choose a single-session or multiple-session setup.** Azure Virtual Desktop provides single-session or multiple-session setups in which each VM hosts either one or multiple user sessions. You can choose the setup that best suits your needs. Single-session Azure Virtual Desktop on Azure Local can be resource-intensive because it requires dedicated resources for each user. By comparison, multiple-session environments allow multiple users to share the same VM and its resources, which makes it a more cost-effective option. Windows 10 and Windows 11 Enterprise multi-session editions are available exclusively through Azure Virtual Desktop. For more information, see [Architecture strategies for optimizing scaling costs](/azure/well-architected/cost-optimization/optimize-scaling-costs).

- **Consolidate cost monitoring.** Use Azure Monitor Insights for Azure Local to consolidate monitoring costs, and use Update Manager for Azure Local to do patching. Insights uses Azure Monitor to provide detailed metrics and alerting capabilities. To simplify keeping your instances up-to-date, the life cycle manager integrates with Update Manager to consolidate update workflows for various components into a single experience. To optimize resource allocation and contribute to overall cost efficiency, use Azure Monitor and Update Manager. For more information, see [Architecture strategies for consolidation](/azure/well-architected/cost-optimization/consolidation).

- **Plan for initial workload capacity and growth.** When you plan your Azure Local deployment, create a cost model to consider your initial workload capacity, resiliency requirements, and future growth considerations. Consider whether a [two-node or three-node storage switchless architecture](azure-local-switchless.yml) can reduce costs. For example, you might eliminate the need to obtain storage-class network switches. Extra storage-class network switches can add significant cost to new Azure Local instance deployments. You can instead use existing switches for management and compute networks. This approach simplifies the infrastructure.

   If your workload capacity and resiliency needs don't scale beyond a three-node configuration, consider whether you can use existing switches for the management and compute networks. Use the three-node storage switchless architecture to deploy Azure Local. For more information, see [Architecture strategies for creating a cost model](/azure/well-architected/cost-optimization/cost-model).

- **Implement Azure Virtual Desktop autoscaling.** To optimize resource usage and costs, use the autoscale feature to scale available session hosts up or down according to a schedule. The elasticity of autoscaling avoids unnecessary hardware resource usage and helps ensure adequate capacity during peak usage. To reduce overall spending without compromising user experience, configure autoscaling based on demand fluctuations.

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

Use this guidance to create reliable processes to deploy, manage, and monitor Azure Virtual Desktop on Azure Local instances effectively. These processes help ensure smooth operations in production environments. You can also automate routine tasks and set up monitoring so that you can simplify operations and reduce the risk of downtime.

- **Take advantage of simplified provisioning and management in Azure.** The cloud-based deployment in Azure provides a wizard-driven interface that explains how to create an Azure Local instance. Similarly, Azure simplifies the process of managing Azure Local instances and Azure Local VMs. You can use the Azure Resource Manager template (ARM template) to automate the portal-based deployment of the Azure Local instance. This template provides consistency and automation to deploy Azure Local at scale. The template is crucial for business-critical workloads, like retail stores or manufacturing sites, that require an Azure Local instance. For more information, see [Architecture strategies for setting up automation](/azure/well-architected/operational-excellence/enable-automation).

- **Create strict change control procedures.** Change control procedures require you to test and validate all changes in a representative test environment before you implement changes to production. All changes submitted to the weekly change advisory board process must include specific criteria for a change to be reviewed or approved. The submitted changes must include an implementation plan or link to source code, a risk-level score, a rollback plan, post-release tests, and clear success criteria. For more information, see [Architecture strategies for safe deployment practices](/azure/well-architected/operational-excellence/safe-deployments).

- **Use automation capabilities for VMs.** Azure Local provides a range of automation capabilities to manage workloads.

  - Use the Azure Arc extension for updates to manage VM operating system updates. Use Update Manager to update Azure Local instance machines.
  
  - Use the Azure CLI to run Azure Local commands from an Azure Local machine or remotely via Azure Cloud Shell or a management computer.
  
  - Integrate with Azure Automation and Azure Arc to get a range of automation scenarios for VM workloads through Azure Arc extensions.

  For more information, see [Architecture strategies for using infrastructure as code (IaC)](/azure/well-architected/operational-excellence/infrastructure-as-code-design).

- **Set up monitoring and logging.** Use [Insights for Azure Local](/azure/azure-local/manage/monitor-single-23h2) and [Insights for Azure Virtual Desktop](/azure/virtual-desktop/whats-new-insights) to capture detailed metrics and logs for the platform and workload. These insights help identify performance problems and improve operational response times.

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

- **Use load balancing for optimal performance.** To prevent any single VM from being a bottleneck, distribute network traffic evenly across Azure Virtual Desktop instances. Load balancers help improve responsiveness by evenly distributing user sessions, which is especially important during peak times. 

   Azure Virtual Desktop supports built-in load balancing algorithms that manage user session distribution effectively. *Breadth-first load balancing* assigns new user sessions to the session host that has the least number of connections, which helps create an even distribution. *Depth-first load balancing* fills one session host to capacity before it continues to the next session host. This approach can improve efficiency during periods of low usage. For more information, see [Configure host pool load balancing in Azure Virtual Desktop](/azure/virtual-desktop/configure-host-pool-load-balancing).

- **Optimize performance for Azure Virtual Desktop.**

  - *Use high-performance storage solutions.* Use high-speed storage options, like NVMe or SSDs, to reduce latency and improve input/output operations per second (IOPS) for Azure Virtual Desktop on Azure Local. For more information, see [Architecture strategies for selecting the right services](/azure/well-architected/performance-efficiency/select-services).

  - *Take advantage of S2D.* Azure Local uses S2D to pool the available storage from all physical machines, which provides high-performance and resilient storage for your workloads. Define performance targets that are numerical values based on your workload performance requirements. Implement performance targets for all workload flows. For more information, see [Architecture strategies for defining performance targets](/azure/well-architected/performance-efficiency/performance-targets).

  - *Do performance testing.* Conduct regular performance testing in an environment that matches the production environment. To detect drift or degradation over time, compare results against your performance targets and baseline values. Your tests should include network latency considerations, like the network communication path of the remote users. For more information, see [Architecture strategies for performance testing](/azure/well-architected/performance-efficiency/performance-test).

## Deploy this scenario

The following sections describe the prerequisites that you need to deploy an Azure Virtual Desktop on Azure Local solution, supported deployment configurations, and methods for deployment.

### Prerequisites

For Azure Virtual Desktop requirements and supported components, like operating systems, virtual networks, and identity providers, see [Prerequisites for Azure Virtual Desktop](/azure/virtual-desktop/prerequisites). The article also includes a list of the [supported Azure regions](/azure/virtual-desktop/prerequisites#azure-regions) in which you can deploy host pools, workspaces, and application groups. You can store the metadata for the host pool in these regions. You can place session hosts in any Azure region and on-premises by using [Azure Local](/azure/virtual-desktop/azure-local-overview). For more information, see [Data locations for Azure Virtual Desktop](/azure/virtual-desktop/data-locations).

### Supported deployment configurations

Your Azure Local instances must run [version 23H2](/azure/azure-local/release-information-23h2) or later. After the instance is deployed and ready, you can use the following 64-bit operating system images for your session host Azure Local VMs:

- Windows 11 Enterprise multi-session
- Windows 11 Enterprise
- Windows 10 Enterprise multi-session
- Windows 10 Enterprise
- Windows Server 2022
- Windows Server 2019

To use session hosts on Azure Local with Azure Virtual Desktop, you also need to take the following steps:

1. **License and activate the VMs.** To activate Windows 10 or Windows 11 Enterprise multi-session and Windows Server 2022 Datacenter: Azure Edition, use [Azure verification for VMs](/azure/azure-local/deploy/azure-verification). For all other operating system images, including Windows 10 and Windows 11 Enterprise or other editions of Windows Server, continue to use existing activation methods. For more information, see [Activate Windows Server VMs on Azure Local](/azure/azure-local/manage/vm-activate).

1. **Install the Azure Connected Machine agent on the VMs** so that they can communicate with [Azure Instance Metadata Service](/azure/virtual-machines/instance-metadata-service). This service is a [required endpoint for Azure Virtual Desktop](/azure/virtual-desktop/required-fqdn-endpoint). The [Azure Connected Machine agent](/azure/azure-arc/servers/agent-overview) automatically installs when you add session hosts via the Azure portal, as part of the process to [deploy Azure Virtual Desktop](/azure/virtual-desktop/deploy-azure-virtual-desktop) or [add session hosts to a host pool](/azure/virtual-desktop/add-session-hosts-host-pool).

After you complete these steps, users can connect to the session hosts via the same [Remote Desktop clients](/azure/virtual-desktop/connect-azure-virtual-desktop) that they use for Azure Virtual Desktop.

### Deployment methods

You can use the following resources to deploy Azure Virtual Desktop on Azure Local:

- The Azure portal
- Azure PowerShell
- The Azure CLI

Follow the [deployment steps](/azure/virtual-desktop/deploy-azure-virtual-desktop), including the prerequisites and how to create a host pool, workspace, application group, and assignment.

#### ARM templates

Use [ARM templates](/azure/azure-resource-manager/templates/overview) to simplify the Azure Virtual Desktop workload deployment. ARM templates help provide automation, consistency, and repeatability when you deploy Azure resources.

For an example ARM template and parameter file to deploy an Azure Local instance, see the [Azure Local instance ARM template](https://github.com/Azure/azure-quickstart-templates/tree/master/quickstarts/microsoft.azurestackhci/create-cluster-2-node-switched-custom-storageip).

For a foundation to build and manage your Azure Virtual Desktop deployments, see the [Azure Virtual Desktop on Azure Local ARM template](https://github.com/Azure/RDS-Templates/blob/master/ARM-wvd-templates/HCI/QuickDeploy/CreateHciHostpoolQuickDeployTemplate.json).

#### Terraform

You can use Terraform to deploy Azure Local instances, logical networks, and Azure Local VMs. No providers can deploy Azure Virtual Desktop. The following Terraform providers can deploy Azure Local components:

- **Azure Local instance:** [Azure/avm-res-azurestackhci-cluster/azurerm](https://registry.terraform.io/modules/Azure/avm-res-azurestackhci-cluster/azurerm/latest)

- **Logical network:** [Azure/avm-res-azurestackhci-logicalnetwork/azurerm](https://registry.terraform.io/modules/Azure/avm-res-azurestackhci-logicalnetwork/azurerm/latest)

- **VM:** [Azure/avm-res-azurestackhci-virtualmachineinstance/azurerm](https://registry.terraform.io/modules/Azure/avm-res-azurestackhci-virtualmachineinstance/azurerm/latest)

For a consolidated list of recent feature updates, see [What's new in Azure Virtual Desktop](/azure/virtual-desktop/whats-new).

## Next steps

- [Azure Virtual Desktop on Azure Local](/azure/virtual-desktop/azure-local-overview)
- [Azure Local monitoring overview](/azure/azure-local/concepts/monitoring-overview)
- [Protect VM workloads by using Site Recovery on Azure Local](/azure/azure-local/manage/azure-site-recovery)
- [Azure Arc overview](/azure/azure-arc/overview)
- [Upload, download, and manage data by using Azure Storage Explorer](/training/modules/upload-download-and-manage-data-with-azure-storage-explorer)

## Related resources

- [Hybrid architecture design](hybrid-start-here.md)
- [Azure hybrid options](../guide/technology-choices/hybrid-considerations.yml)
- [Optimize administration of SQL Server instances in on-premises and multicloud environments by using Azure Arc](azure-arc-sql-server.yml)
