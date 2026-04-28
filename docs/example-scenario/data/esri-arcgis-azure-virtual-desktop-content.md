This architecture describes how to deploy Esri ArcGIS Pro in Azure Virtual Desktop to support the hyperscale of Azure. The architecture also includes back-end components like ArcGIS Enterprise to build a complete system on Azure.

*ArcGIS® is a trademark of its company. No endorsement is implied by the use of this mark.*

## Architecture

The following diagram presents a high-level architecture for deploying ArcGIS components on Azure.

:::image type="complex" source="media/virtual-desktop-azure-network.svg" alt-text="Diagram that shows an architecture for deploying ArcGIS components on Azure." border="false" lightbox="media/virtual-desktop-azure-network.svg":::
   Diagram that shows a single-region Azure architecture within one subscription. The diagram has two user groups at the bottom: remote desktop users (ArcGIS analysts) on the left and external public users on the right. Above the users, a large box represents the Azure virtual network, which contains four subnets. The desktop subnet on the left contains Windows desktop virtual machines (VMs) and a user profile management component, grouped in the Desktop resource group. Adjacent to it, the Azure Virtual Desktop resource group contains an Azure Virtual Desktop host pool and workspace. The Azure Virtual Desktop service sits above as the control plane. The Esri subnet on the right contains ArcGIS Web Adaptor with ArcGIS Server (Federated), ArcGIS Data Store, and ArcGIS Web Adaptor with Portal, all grouped in the Esri resource group. Azure Application Gateway appears at the entry to the Esri subnet. A SQL subnet contains Azure SQL Managed Instance, and an Azure NetApp Files subnet contains Azure NetApp Files, grouped in the Storage resource group. Arrows show remote desktop users connecting through the Azure Virtual Desktop service to the desktop subnet, and external users connecting through Application Gateway to the Esri subnet.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/AVD-GIS-Azure-Network.vsdx) of this architecture.*

### Workflow

The following workflow corresponds to the previous diagram:

- This solution is deployed to a single region with storage, a geographic information system (GIS) desktop, a GIS back end, and Azure Virtual Desktop resource groups. Each resource group contains one subnet, and all subnets are in one virtual network. All components are in a single Azure subscription. This architecture is a three-tier deployment.

- The Azure Virtual Desktop control plane handles web access, the gateway, the broker, diagnostics, and extensibility components like REST APIs.

- You manage Microsoft Entra Domain Services and Microsoft Entra ID, Azure subscriptions, virtual networks, [Azure Files or Azure NetApp Files](/azure/virtual-desktop/store-fslogix-profile), and the Azure Virtual Desktop host pools and workspaces.

- GIS analysts, administrators, and editors connect to Azure Virtual Desktop via a Remote Desktop Protocol (RDP) session. From Azure Virtual Desktop, ArcGIS Pro is accessed and takes advantage of the GPUs for light, medium, and heavy workflows. *Light* refers to a 2D workflow, *medium* refers to a more demanding 2D workflow, and *heavy* refers to a 2D or 3D workflow that requires GPUs. GIS administrators can also use ArcGIS Pro to publish services and administer the enterprise geodatabase. Finally, GIS editors can maintain the vector and raster layers.

  Administrators can also use semantic versioning to make it possible to publish new versions of ArcGIS Pro. For example, as new versions of ArcGIS Pro are available, like ArcGIS Pro 3.0, the new version can be published in the Remote Desktop tool. Users can pick that new version when they're ready to upgrade without having to perform the upgrade themselves. The GPU drivers can be included in the creation of the images that the deployments are based on, or you can use the Azure Virtual Machines extension to install the GPU driver.

  :::image type="content" source="media/arcgis-rdp.jpg" alt-text="Screenshot that shows ArcGIS and virtual machines in the Remote Desktop tool.":::

- Web GIS users can also use this solution by accessing ArcGIS Enterprise administrative interfaces either in the browser in the Azure Virtual Desktop RDP session or, if ArcGIS is published as public facing, via their local browser. Azure Application Gateway routes the traffic to the correct endpoint for the ArcGIS Server roles. As with ArcGIS Pro, this approach minimizes the latency between the browsers and the back end.

- You can deploy the enterprise geodatabase in Azure SQL Managed Instance. ArcGIS Pro users can then create, manage, and edit the geodatabase from an RDP session. During the creation of the Azure Virtual Desktop image, administrators can include the Open Database Connectivity (ODBC) drivers so that users don't have to install them on the Azure Virtual Desktop virtual machines (VMs).

- Azure NetApp Files supports fast access to the ArcGIS Server configuration store and directories. You can use Azure Files and Azure Storage, but Azure NetApp Files costs less for large deployments. You can also use Azure NetApp Files to store data, such as Portal for ArcGIS items, raster images, and lidar data.

### Components

- [Azure NetApp Files](/azure/well-architected/service-guides/azure-netapp-files) is an enterprise-class, high-performance, metered file network-attached storage (NAS) service. In this architecture, Azure NetApp Files stores ArcGIS Server configuration data, raster images, lidar datasets, and other geospatial files.

- [Azure Monitor](/azure/azure-monitor/overview) is a collection of tools that provides visibility into the state of your system. In this architecture, Azure Monitor provides visibility into system performance and helps identify and resolve problems that affect your workload's components.

- [Azure Policy](/azure/governance/policy/overview) is a governance tool that enforces rules and standards across Azure resources. In this architecture, Azure Policy ensures compliance with workload policies, such as resource tagging, location restrictions, and security configurations. Through its compliance dashboard, it provides an aggregated view of the overall state of the environment and the ability to drill down to per-resource, per-policy granularity.

- [Microsoft Entra ID](/entra/fundamentals/whatis) is an enterprise identity service that provides single sign-on, Microsoft Entra multifactor authentication (MFA), and other identity services to protect against cybersecurity threats. In this architecture, Microsoft Entra ID secures user access to Azure Virtual Desktop and other services.

- [Active Directory Domain Services (AD DS)](/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview) is a directory service that provides traditional domain-based identity services like group policies and Kerberos authentication. AD DS stores directory data and makes that data available to network users and administrators. AD DS stores information about user accounts, like names, passwords, and phone numbers. Authorized users on the same network can access that information.

- [Azure Virtual Desktop](/azure/virtual-desktop/overview) is a desktop and application virtualization service that delivers Windows desktops and apps remotely. In this architecture, Azure Virtual Desktop hosts ArcGIS Pro on GPU-enabled VMs so that users can run intensive GIS workflows from anywhere.

- [SQL Managed Instance](/azure/well-architected/service-guides/azure-sql-managed-instance/reliability) is a managed SQL Server instance that includes built-in high availability and scalability. In this architecture, SQL Managed Instance stores the enterprise geodatabase, so ArcGIS Pro users can manage and edit spatial data in a secure and scalable environment.

- [Application Gateway](/azure/well-architected/service-guides/azure-application-gateway) is an application delivery controller as a service that provides layer-7 load balancing, security, and web application firewall functionality. In this architecture, Application Gateway distributes incoming requests to ArcGIS Server roles to ensure efficient traffic routing and protection against common web vulnerabilities.

- [FSLogix](/fslogix/overview-what-is-fslogix) is a profile container solution that improves the user experience in virtual desktop environments. In this architecture, FSLogix supports fast logins and persistent user profiles for Azure Virtual Desktop users. Users can roam between remote computing session hosts and optimize file input/output (I/O) between the host or client and the remote profile store.

  For more information about FSLogix Profile Container, Azure Files, and Azure NetApp Files best practices, see [FSLogix configuration examples](/fslogix/concepts-configuration-examples).

- [Azure Virtual Network](/azure/well-architected/service-guides/virtual-network) is a private cloud-based network that you can use to build your own secure network infrastructure in Azure. Virtual Network provides secure communication between Azure resources through private IP addresses. In this architecture, Virtual Network connects all components, such as virtual desktops, databases, and storage, within a secure and isolated network.

- [ArcGIS Pro](https://www.esri.com/arcgis/products/arcgis-pro/overview) is the Esri professional desktop GIS application for spatial analysis, mapping, and data editing. In this architecture, ArcGIS Pro runs on GPU-enabled Azure Virtual Desktop VMs, which help users perform advanced 2D and 3D geospatial tasks and publish services. ArcGIS Pro runs best on Azure high-performance computing (HPC) VMs, like the NV-Series. You can use Azure Virtual Desktop to scale ArcGIS usage.

- [ArcGIS Enterprise](https://enterprise.arcgis.com/en/get-started/latest/windows/what-is-arcgis-enterprise-.htm) is a comprehensive GIS platform for managing and sharing spatial data and services. In this architecture, you can add ArcGIS Enterprise to extend capabilities for hosting maps, apps, and spatial analytics across the organization. ArcGIS Enterprise works with ArcGIS Pro.

- [Portal for ArcGIS](https://enterprise.arcgis.com/en/portal) is a web-based interface for sharing and managing GIS content within ArcGIS Enterprise. In this architecture, Portal for ArcGIS helps users create, organize, and share maps, scenes, and apps securely within the organization. Portal for ArcGIS is part of the base deployment.

- [ArcGIS Server](https://enterprise.arcgis.com/en/server/latest/get-started/windows/what-is-arcgis-for-server-.htm) is back-end server software that's deployed with ArcGIS Enterprise or in a standalone deployment with ArcGIS Enterprise. In this architecture, ArcGIS Server handles requests from users and applications, such as to draw maps, run tools, or query data. ArcGIS Server configuration and data are stored in Azure NetApp Files. Administrators can use the ArcGIS Server management plane to start, stop, and delete services.

- An [Enterprise geodatabase](https://enterprise.arcgis.com/en/server/latest/manage-data/windows/enterprise-geodatabases-and-arcgis-enterprise.htm) is a multiuser spatial database that supports versioning, replication, and advanced data models. You can deploy this database in many database management systems. In this architecture, Enterprise geodatabase is hosted in SQL Managed Instance and is the authoritative data source for ArcGIS Pro and other GIS tools.

## Scenario details

The technology from Esri comprises a GIS that contains capabilities for the visualization, analysis, and data management of geospatial data. The core technology is called the *ArcGIS platform*. It includes capabilities for mapping, spatial analysis, 3D GIS, imagery and remote sensing, data collection and management, and field operations.

ArcGIS Pro is a key part of the technology. ArcGIS Pro is a 64-bit professional desktop GIS that GIS analysts can use to perform spatial analysis and edit spatial data. GIS administrators can use ArcGIS Pro to create and publish geospatial services.

### Potential use cases

Esri ArcGIS and virtual desktop solutions are frequently used for:

- Security and regulation applications like healthcare, government, and utilities, for example, energy suppliers.
- Elastic workforce needs like remote work, mergers and acquisitions, short-term employees, contractors, and partner access.
- Employees like bring-your-own-device users, mobile users, and branch workers.
- Specialized workloads like design and engineering, legacy apps, software testing, and land management, for example, facilities and real estate.

Traditional GIS implementations in Azure typically include only the back-end components. That implementation introduces latency between the client and server components. Organizations can deploy desktop GIS on VMs from the [Microsoft Marketplace](https://marketplace.microsoft.com/marketplace/apps?search=ArcGIS), but those deployments require dedicated VMs for individual users and don't scale well. This architecture addresses both challenges.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

#### Azure Virtual Desktop pooled vs. personal desktops

- **Pooled host pools** are ideal for users with similar workloads who don't need persistent desktops. Multiple users share VMs, which reduces the total number of VMs required and lowers costs.

- **Personal host pools** assign dedicated VMs to individual users. Use this option for users who require persistent environments or have specialized software needs.

#### Rightsize GPU-enabled VMs

GPU-enabled VMs are the largest cost driver in this architecture. Match VM SKUs to actual workload requirements.

| Workload | Recommended approach |
| :------- | :------------------- |
| Light (2D viewing) | Use smaller GPU SKUs like NV4ads_V710_v5 or consider multisession pooling |
| Medium (editing) | Use mid-tier SKUs like NC8as_T4_v3; pool four users per VM in multisession |
| Heavy (3D visualization) | Use larger SKUs like NV18ads_A10_v5; limit to three users per VM |

#### Scaling and automation

- **Start VM on Connect:** Turn on this feature to start session host VMs only when users need them, rather than running them continuously.

- **Autoscale:** Configure [Azure Virtual Desktop autoscaling](/azure/virtual-desktop/autoscale-scaling-plan) to automatically scale the number of session hosts based on demand, which reduces costs during off-peak hours.

- **Scheduled scaling:** Define scaling schedules that align with business hours to shut down or deallocate VMs during nights and weekends.

#### Storage optimization

- **Azure NetApp Files:** For large deployments that have high I/O requirements, Azure NetApp Files can be more cost-effective than Azure Files Premium. Evaluate your storage needs and choose the appropriate tier (Standard, Premium, or Ultra).

- **FSLogix profile containers:** Store user profiles in Azure NetApp Files or Azure Files to reduce the need for larger OS disks on session hosts.

#### Reserved instances and savings plans

- Use [Azure Reserved Virtual Machine Instances](/azure/cost-management-billing/reservations/save-compute-costs-reservations) for predictable, always-on workloads to save up to 72% compared to pay-as-you-go pricing.
- Consider [Azure savings plans](/azure/cost-management-billing/savings-plan/savings-plan-overview) for flexible compute commitments across VM families.

#### Monitoring and optimization

- Use [Microsoft Cost Management](/azure/cost-management-billing/costs/overview-cost-management) to track spending and set budgets.
- Monitor VM utilization by using [Azure Monitor](/azure/azure-monitor/vm/vminsights-overview) to identify underutilized or oversized resources.
- Review [Azure Advisor cost recommendations](/azure/advisor/advisor-cost-recommendations) regularly to identify optimization opportunities.

For a cost estimate based on your specific requirements, use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator/).

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

When you use a remote Windows session, your network's available bandwidth affects the quality of your experience. The following table lists the minimum recommended bandwidths for a smooth user experience. These recommendations are based on the guidelines in [Remote Desktop Services workloads](/windows-server/remote/remote-desktop-services/session-host-virtual-machine-sizing-guidelines#workloads).

| Workload type | Recommended bandwidth |
| :------------ | :-------------------- |
| Light         | 1.5 Mbps              |
| Medium        | 3 Mbps                |
| Heavy         | 5 Mbps                |

Remember that the stress put on your network depends on your app workload's output frame rate and on your display resolution. If the frame rate or the display resolution increases, the bandwidth requirement also rises. For example, a light workload with a high-resolution display requires more available bandwidth than a light workload with regular or low resolution. Ideally, the latency between the user and the RDP session needs to be around 200 milliseconds or less. This latency helps ensure that the interactive edits and the tooltips appear quickly enough when ArcGIS Pro users interact with maps and perform measurements or edits.

This architecture also reduces the latency between the Azure infrastructure and Esri software as a service (SaaS) offerings, like ArcGIS Velocity and ArcGIS Image, for ArcGIS Pro users and web browser users. All components of the ArcGIS SaaS platform ArcGIS Online reside in the cloud.

#### Scalability

You can scale this architecture in many ways. You can scale the VMs for the back end or the desktops (both CPU and GPUs) in, out, up, or down. You can also deploy Azure Virtual Desktop on individual VMs or multisession VMs. Azure Virtual Desktop can scale hundreds or thousands of VMs.

#### Testing

You can test your system's latency by using the [Connection Experience Indicator](https://bramwolfs.com/2023/11/10/connection-experience-indicator-for-rds-wvd/). You can use the [Esri ArcGIS Pro Performance Assessment Tool](https://pro.arcgis.com/en/pro-app/latest/get-started/pro-performance-tool-overview.htm) to test the performance. Esri also recommends [tools for testing ArcGIS Enterprise](https://community.esri.com/t5/implementing-arcgis-blog/performance-engineering-load-testing-arcgis/ba-p/1070106). [Azure Load Testing](/azure/app-testing/load-testing/overview-what-is-azure-load-testing) might also be helpful.

### ArcGIS Pro VM sizing guidelines for Azure Virtual Desktop and Remote Desktop Services

Whether you're running your session host VMs on Remote Desktop Services or Azure Virtual Desktop, different types of workloads require different VM configurations. The examples in this article are generic guidelines, and you should only use them for initial performance estimates. For the best possible experience, optimize and scale your deployment depending on your users' needs.

ArcGIS Pro should use Windows 11 Enterprise multisession VMs to provide greater flexibility and return on investment (ROI). Allocate the appropriate VM types to give each user enough resources, such as GPU, CPU, and RAM. To avoid oversaturation and hindering performance, consider the number of connections and limit the simultaneous user access to each VM.

### Workloads

Users can run different types of workloads on the session host VMs. The following table shows examples of a range of workload types to help you estimate your VM sizes. After you set up your VMs, monitor their actual usage and adjust their size accordingly. If you need a bigger or smaller VM, scale your existing deployment up or down.

The following table describes each ArcGIS workload. *Example users* are the types of users who might find each workload most helpful.

| Workload type | Example user workflows | Activity |
| :--- | :--- | :--- |
| Light | Simple 2D map display, navigation, and querying. Combine and present data that others prepare. | Viewing |
| Medium | 2D and 3D map display, navigation, querying, and editing. Moderate use of geoprocessing tools. Compile and present data from multiple sources into a simple map layout. | Editing |
| Heavy | 2D and 3D map display, navigation, querying, and editing. Advanced use of symbology including transparency and dynamic labeling. Heavy 2D and 3D analysis involving visibility and line of sight. | Visualizing |

### Single-session recommendations

In a *single-session* scenario, only one user signs in to a session host VM at a time. For example, if you use personal host pools in Azure Virtual Desktop, you use a single-session scenario.

The following table provides examples for single-session ArcGIS Pro scenarios.

| Workload type | Example Azure VM SKU | Activity |
| :--- | :--- | :--- |
| Light | NV4ads_V710_v5, NV8ads_V710_v5 | Viewing |
| Medium | NV12ads_V710_v5, NC4as_T4_v3, NC8as_T4_v3, NV6ads_A10_v5 | Editing |
| Heavy | NC16as_T4_v3, NV12ads_A10_v5, NV18ads_A10_v5 | Visualizing |

### Multisession recommendations

In *multisession* scenarios, more than one user signs in to a session host at a time. For example, when you use pooled host pools in Azure Virtual Desktop with the Windows 11 Enterprise multisession OS, you use a multisession deployment.

The following table provides examples for multisession ArcGIS Pro scenarios.

| Workload type | Example Azure VM SKU | Maximum users per VM | Activity |
| :--- | :--- | :--- | :--- |
| Light | NV18ads_A10_v5, NC16as_T4_v3, NV24ads_V710_v5 | 6 | Viewing |
| Medium | NV18ads_A10_v5, NC16as_T4_v3, NV24ads_V710_v5 | 4 | Editing |
| Heavy | NV18ads_A10_v5, NC16as_T4_v3, NV24ads_V710_v5 | 3 | Visualizing |

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Matt Hallenborg](https://www.linkedin.com/in/matt-hallenborg/) | Senior Cloud Solution Architect
- [Ron Vincent](https://www.linkedin.com/in/ron-vincent-8958145/) | Senior Program Manager

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- You can use the [ArcGIS Pro for Mission Landing Zone](https://github.com/Azure/missionlz/tree/main/src/add-ons/arcgis-pro) to deploy ArcGIS Pro on Azure Virtual Desktop. The implementation in the repository includes Secure Cloud Computing Architecture (SCCA)-compliant infrastructure, GPU-enabled VMs, Azure NetApp Files, and FSLogix preconfigured for rapid proof-of-concept deployments.

- You can use [ArcGIS Enterprise Builder](https://enterprise.arcgis.com/en/get-started/latest/windows/arcgis-enterprise-builder.htm) to set up a base ArcGIS Enterprise deployment on a single machine or multiple machines.

## Related resource

- [Azure Virtual Desktop landing zone design guide](../../landing-zones/azure-virtual-desktop/design-guide.md)
