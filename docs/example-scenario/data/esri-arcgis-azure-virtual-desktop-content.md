This architecture shows how you can deploy Esri ArcGIS Pro in Azure Virtual Desktop to support the hyperscale of Azure. The architecture also includes back-end components like ArcGIS Enterprise to build a complete system on Azure.

*ArcGIS® is a trademark of its company. No endorsement is implied by the use of this mark.*

## Architecture

The following diagram presents a high-level architecture for deploying ArcGIS components on Azure.

:::image type="content" source="media/virtual-desktop-gis-azure-network.png" alt-text="Diagram that shows an architecture for deploying ArcGIS components on Azure." lightbox="media/virtual-desktop-gis-azure-network.png":::

*Download a [Visio file](https://arch-center.azureedge.net/AVD-GIS-Azure-Network.vsdx) of this architecture.*

### Workflow

- This solution is deployed to a single region with storage, GIS desktop, GIS back end, and Azure Virtual Desktop resource groups. Each resource group contains one subnet, and all subnets are in one virtual network. All components are in a single Azure subscription. This architecture is a three-tier deployment.
- The Azure Virtual Desktop control plane handles web access, gateway, broker, diagnostics, and extensibility components like REST APIs.
- You manage Microsoft Entra Domain Services and Microsoft Entra ID, Azure subscriptions, virtual networks, [Azure Files or Azure NetApp Files](/azure/virtual-desktop/store-fslogix-profile), and the Azure Virtual Desktop host pools and workspaces.
- GIS analysts, administrators, and editors connect to Azure Virtual Desktop via a Remote Desktop Protocol (RDP) session. From there, ArcGIS Pro is accessed and takes advantage of the GPUs for light, medium, and heavy workflows. *Light* refers to a 2D workflow, *medium* refers to a more demanding 2D workflow, and *heavy* refers to a 2D or 3D workflow that requires GPUs. GIS administrators can also use ArcGIS Pro to publish services and administer the enterprise geodatabase. Finally, GIS editors can maintain the vector and raster layers.

  Administrators can also make it possible to publish new versions of ArcGIS Pro by using semantic versioning. For example, as new versions of ArcGIS Pro are available, like ArcGIS Pro 3.0, the new version can be published in the Remote Desktop tool. As a result, users can pick that new version when they're ready to upgrade without having to perform the upgrade themselves. The GPU drivers can be included in the creation of the images that the deployments are based on, or use the Azure VM extension to install the GPU driver.

  :::image type="content" source="media/arcgis-rdp.jpg" alt-text="Screenshot that shows ArcGIS and VMs in Remote Desktop.":::

- Web GIS users can also take advantage of this solution by accessing ArcGIS Enterprise administrative interfaces either in the browser in the Azure Virtual Desktop RDP session or via their local browser (if ArcGIS is published as public facing). The Azure application gateway routes the traffic to the correct endpoint for the ArcGIS server roles. As with ArcGIS Pro, the latency between the browsers and the back end are minimized.
- You can deploy the enterprise geodatabase in Azure SQL Managed Instance. ArcGIS Pro users can then create, manage, and edit the geodatabase from an RDP session. During the creation of the Azure Virtual Desktop image, administrators can include the ODBC drivers so users don't have to install them on the Azure Virtual Desktop VMs.
- Azure NetApp Files supports fast access to the ArcGIS Server configuration store and directories. You can use Azure Files and Azure Storage, but Azure NetApp Files costs less for large deployments. Also, you can use Azure NetApp Files to store data such as Portal for ArcGIS items and raster images, and lidar data.

### Components

- [Azure NetApp Files](/azure/well-architected/service-guides/azure-netapp-files) is an enterprise-class, high-performance, metered file Network-attached storage (NAS) service. In this architecture, it stores ArcGIS Server configuration data, raster images, lidar datasets, and other geospatial files.
- [Azure Monitor](/azure/azure-monitor/overview) is a collection of tools that provides visibility into the state of your system. In this architecture, Azure Monitor provides visibility into system performance and helps identify and resolve problems that affect your workload's components.
- [Azure Policy](/azure/governance/policy/overview) is a governance tool that enforces rules and standards across Azure resources. In this architecture, it ensures compliance with workload policies, such as resource tagging, location restrictions, and security configurations. Through its compliance dashboard, it provides an aggregated view of the overall state of the environment and the ability to drill down to per-resource, per-policy granularity.
- [Microsoft Entra ID](/entra/fundamentals/whatis) is an enterprise identity service that provides single sign-on, multifactor authentication, and other identity services to protect against cybersecurity threats. In this architecture, it secures user access to Azure Virtual Desktop and other services.
- [Active Directory Domain Services (AD DS)](/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview) is a directory service that provides traditional domain-based identity services like group policies and Kerberos authentication. It stores directory data and makes that data available to network users and administrators. AD DS stores information about user accounts, like names, passwords, and phone numbers, and enables other authorized users on the same network to access that information.

- [Azure Virtual Desktop](/azure/virtual-desktop/overview) is a desktop and application virtualization service that delivers Windows desktops and apps remotely. In this architecture, Azure Virtual Desktop hosts ArcGIS Pro on GPU-enabled VMs so that users can run intensive GIS workflows from anywhere.
- [Azure SQL Managed Instance](/azure/well-architected/service-guides/azure-sql-managed-instance/reliability) is a managed SQL Server instance that includes built-in high availability and scalability. In this architecture, SQL Managed Instance stores the enterprise geodatabase, which enables ArcGIS Pro users to manage and edit spatial data in a secure and scalable environment.
- [Azure Application Gateway](/azure/well-architected/service-guides/azure-application-gateway) is an application delivery controller-as-a-service offering that provides layer-7 load balancing, security, and web application firewall functionality. In this architecture, it distributes incoming requests to ArcGIS Server roles, which ensures efficient traffic routing and protection against common web vulnerabilities.
- [FSLogix](/fslogix/overview-what-is-fslogix) is a profile container solution that improves the user experience in virtual desktop environments. In this architecture, it enables fast logins and persistent user profiles for Azure Virtual Desktop users. It also allows users to roam between remote computing session hosts and optimize file input/output (I/O) between the host or client and the remote profile store.

  For more information about FSLogix Profile Container, Azure Files, and Azure NetApp Files best practices, see [FSLogix configuration examples](/fslogix/concepts-configuration-examples).
- [Azure Virtual Network](/azure/well-architected/service-guides/virtual-network) is a private cloud-based network that you can use to build your own secure network infrastructure in Azure. It enables secure communication between Azure resources through private IP addresses. In this architecture, Virtual Network connects all components, such as virtual desktops, databases, and storage, within a secure and isolated network.
- [ArcGIS Pro](https://www.esri.com/arcgis/products/arcgis-pro/overview) is Esri's professional desktop GIS application for spatial analysis, mapping, and data editing. In this architecture, it runs on GPU-enabled Azure Virtual Desktop VMs, which allows users to perform advanced 2D and 3D geospatial tasks and publish services. It runs best on Azure high-performance computing VMs, like the NV-Series. You can scale the use of ArcGIS by using Azure Virtual Desktop.
- [ArcGIS Enterprise](https://enterprise.arcgis.com/en/get-started/latest/windows/what-is-arcgis-enterprise-.htm) is a comprehensive GIS platform for managing and sharing spatial data and services. In this architecture, you can add ArcGIS Enterprise to extend capabilities for hosting maps, apps, and spatial analytics across the organization, it works with ArcGIS Pro.
- [Portal for ArcGIS](https://enterprise.arcgis.com/en/portal) is a web-based interface for sharing and managing GIS content within ArcGIS Enterprise. In this architecture, it enables users to create, organize, and share maps, scenes, and apps securely within the organization. Portal for ArcGIS is part of the base deployment.
- [ArcGIS Server](https://enterprise.arcgis.com/en/server/latest/get-started/windows/what-is-arcgis-for-server-.htm) is back-end server software that's deployed with ArcGIS Enterprise or in a standalone deployment with ArcGIS Enterprise. In this architecture, it handles requests from users and applications, such as to draw maps, run tools, or query data. Its configuration and data is stored in Azure NetApp Files. It also has a management plane that enables administrators to start, stop, and delete services.
- [Enterprise geodatabase](https://enterprise.arcgis.com/en/server/latest/manage-data/windows/enterprise-geodatabases-and-arcgis-enterprise.htm) is a multi-user spatial database that supports versioning, replication, and advanced data models. You can deploy this database in many database management systems. In this architecture, it's hosted in SQL Managed Instance and serves as the authoritative data source for ArcGIS Pro and other GIS tools.

## Scenario details

Esri's technology is a geographic information system (GIS) that contains capabilities for the visualization, analysis, and data management of geospatial data. Esri's core technology is called *the ArcGIS platform*. It includes capabilities for mapping, spatial analysis, 3D GIS, imagery and remote sensing, data collection and management, and field operations.

A desktop app called *ArcGIS Pro* is a key part of the technology. It's a 64-bit professional desktop GIS. GIS analysts can use it to perform spatial analysis and edit spatial data. GIS administrators can use it to create and publish geospatial services.

### Potential use cases

Esri's ArcGIS and virtual desktop solutions are frequently used for:

- Security and regulation applications like utilities (energy), healthcare, and government.
- Elastic workforce needs like remote work, mergers and acquisition, short-term employees, contractors, and partner access.
- Employees like bring your own device (BYOD) users, mobile users, and branch workers.
- Specialized workloads like land management (facilities and real estate), design and engineering, legacy apps, and software testing.

Although GIS has been implemented in Azure for many years, it has typically included only the back-end components. That implementation introduces latency between the client and server components. Organizations have been able to deploy desktop GIS on Azure VMs from the [Microsoft Marketplace](https://marketplace.microsoft.com/marketplace/apps?search=ArcGIS), but that deployment is for thick clients and isn't very scalable. This architecture addresses both challenges.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

#### Azure Virtual Desktop pooled vs. personal desktops

- **Pooled host pools** are ideal for users with similar workloads who don't need persistent desktops. Multiple users share VMs, which reduces the total number of VMs required and lowers costs.
- **Personal host pools** assign dedicated VMs to individual users. Use this option for users who require persistent environments or have specialized software needs.

#### Right-size GPU-enabled VMs

GPU-enabled VMs are the largest cost driver in this architecture. Match VM SKUs to actual workload requirements:

| Workload | Recommended approach |
| :------- | :------------------- |
| Light (2D viewing) | Use smaller GPU SKUs like NV4ads_V710_v5 or consider multi-session pooling |
| Medium (editing) | Use mid-tier SKUs like NC8as_T4_v3; pool four users per VM in multi-session |
| Heavy (3D visualization) | Use larger SKUs like NV18ads_A10_v5; limit to three users per VM |

#### Scaling and automation

- **Start VM on Connect**: Enable this feature to start session host VMs only when users need them, rather than running them continuously.
- **Autoscale**: Configure [Azure Virtual Desktop autoscaling](/azure/virtual-desktop/autoscale-scaling-plan) to automatically scale the number of session hosts based on demand, reducing costs during off-peak hours.
- **Scheduled scaling**: Define scaling schedules that align with business hours to shut down or deallocate VMs during nights and weekends.

#### Storage optimization

- **Azure NetApp Files**: For large deployments with high I/O requirements, Azure NetApp Files can be more cost-effective than Azure Files Premium. Evaluate your storage needs and choose the appropriate tier (Standard, Premium, or Ultra).
- **FSLogix profile containers**: Store user profiles in Azure NetApp Files or Azure Files to reduce the need for larger OS disks on session hosts.

#### Reserved instances and savings plans

- Use [Azure Reserved Virtual Machine Instances](/azure/cost-management-billing/reservations/save-compute-costs-reservations) for predictable, always-on workloads to save up to 72% compared to pay-as-you-go pricing.
- Consider [Azure Savings Plans](/azure/cost-management-billing/savings-plan/savings-plan-compute-overview) for flexible compute commitments across VM families.

#### Monitoring and optimization

- Use [Microsoft Cost Management](/azure/cost-management-billing/costs/overview-cost-management) to track spending and set budgets.
- Monitor VM utilization with [Azure Monitor](/azure/azure-monitor/vm/vminsights-overview) to identify underutilized or oversized resources.
- Review [Azure Advisor cost recommendations](/azure/advisor/advisor-cost-recommendations) regularly to identify optimization opportunities.

For a cost estimate based on your specific requirements, use the [Azure Pricing Calculator](https://azure.microsoft.com/pricing/calculator/).

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

When you use a remote Windows session, your network's available bandwidth greatly affects the quality of your experience. The following table lists the minimum recommended bandwidths for a smooth user experience. These recommendations are based on the guidelines in [Remote Desktop workloads](/windows-server/remote/remote-desktop-services/remote-desktop-workloads).

| Workload type | Recommended bandwidth |
| :------------ | :-------------------- |
| Light         | 1.5 Mbps              |
| Medium        | 3 Mbps                |
| Heavy         | 5 Mbps                |

Keep in mind that the stress put on your network depends on both your app workload's output frame rate and your display resolution. If either the frame rate or display resolution increases, the bandwidth requirement also rises. For example, a light workload with a high-resolution display requires more available bandwidth than a light workload with regular or low resolution. Ideally, the latency between the end user and the RDP session needs to be around 200 ms or less. This latency helps to ensure that, when ArcGIS Pro users interact with maps and perform measurements or edits, the interactive edits and the tooltips appear quickly enough.

Another significant benefit of this architecture is that the latency between it and Esri's SaaS offerings, like ArcGIS Velocity and ArcGIS Image, is also reduced for ArcGIS Pro users and web browser users. All components of the ArcGIS SaaS platform ArcGIS Online are in the cloud.

#### Scalability

You can scale this architecture in many ways. You can scale the VMs for the back end or the desktops (both CPU and GPUs) in, out, up, or down. You can also deploy Azure Virtual Desktop on individual VMs or multi-session VMs. Azure Virtual Desktop can scale hundreds or thousands of VMs.

#### Testing

You can test your system's latency by using the [Connection Experience Indicator](https://bramwolfs.com/2023/11/10/connection-experience-indicator-for-rds-wvd/). You can use [Esri's ArcGIS Pro Performance Assessment Tool](https://pro.arcgis.com/en/pro-app/latest/get-started/pro-performance-tool-overview.htm) to test the performance. Esri also recommends [tools for testing ArcGIS Enterprise](https://community.esri.com/t5/implementing-arcgis-blog/performance-engineering-load-testing-arcgis/ba-p/1070106). [Azure Load Testing](/azure/app-testing/load-testing/overview-what-is-azure-load-testing) can also be helpful.

### ArcGIS Pro virtual machine sizing guidelines for Azure Virtual Desktop and Remote Desktop Services

Whether you're running your session host virtual machines on Remote Desktop Services or Azure Virtual Desktop, different types of workloads require different virtual machine configurations. The examples in this article are generic guidelines, and you should only use them for initial performance estimates. For the best possible experience, optimize and scale your deployment depending on your users' needs.

ArcGIS Pro should use Windows 11 multisession VMs to provide additional flexibility and greater return on investment. It is necessary to allocate the appropriate VM types to give each user enough resources such as GPU, CPU, and RAM. Always consider the number of connections and limit the simultaneous user access to each VM to avoid oversaturation and hindering performance.

### Workloads

Users can run different types of workloads on the session host virtual machines. The following table shows examples of a range of workload types to help you estimate what size your virtual machines need to be. After you set up your virtual machines, continually monitor their actual usage and adjust their size accordingly. If you end up needing a bigger or smaller virtual machine, scale your existing deployment up or down.

The following table describes each ArcGIS workload. *Example users* are the types of users that might find each workload most helpful.

| Workload type | Example user workflows | Activity |
| :--- | :--- | :--- |
| Light | Simple 2-D map display, navigation, and querying. Combining and presenting data prepared by others. | Viewing |
| Medium | 2-D and 3-D map display, navigation, querying, and editing. Moderate use of GP tools. Compilation of presentation of data from multiple sources into a simple map layout. | Editing |
| Heavy | 2-D and 3-D map display, navigation, querying, and editing. Advanced use of symbology including transparency, and dynamic labeling. Heavy 2-D and 3-D analysis involving visibility, and line of sight. | Visualizing |

### Single-session recommendations

*Single-session* scenarios are when there's only one user signed in to a session host virtual machine at any one time. For example, if you use personal host pools in Azure Virtual Desktop, you're using a single-session scenario.

The following table provides examples for single-session ArcGIS Pro scenarios:

| Workload type | Example Azure virtual machine SKU | Activity |
| :--- | :--- | :--- |
| Light | NV4ads_V710_v5, NV8ads_V710_v5 | Viewing |
| Medium | NV12ads_V710_v5, NC4as_T4_v3, NC8as_T4_v3, NV6ads_A10_v5 | Editing |
| Heavy | NC16as_T4_v3, NV12ads_A10_v5, NV18ads_A10_v5 | Visualizing |

### Multi-session recommendations

*Multi-session* scenarios are when there's more than one user signed in to a session host at any one time. For example, when you use pooled host pools in Azure Virtual Desktop with the Windows 11 Enterprise multi-session operating system (OS), that's a multi-session deployment.

The following table provides examples for multi-session ArcGIS Pro scenarios:

| Workload type | Example Azure virtual machine SKU | Maximum users per VM | Activity |
| :--- | :--- | :--- | :--- |
| Light | NV18ads_A10_v5, NC16as_T4_v3, NV24ads_V710_v5 | 6 | Viewing |
| Medium | NV18ads_A10_v5, NC16as_T4_v3, NV24ads_V710_v5 | 4 | Editing |
| Heavy | NV18ads_A10_v5, NC16as_T4_v3, NV24ads_V710_v5 | 3 | Visualizing |

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Matt Hallenborg](https://www.linkedin.com/in/matt-hallenborg/) | Senior Cloud Solution Architect
- [Ron Vincent](https://www.linkedin.com/in/ron-vincent-8958145/) | Senior Program Manager

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- You can use the [ArcGIS Pro for Mission Landing Zone](https://github.com/Azure/missionlz/tree/main/src/add-ons/arcgis-pro) to deploy ArcGIS Pro on Azure Virtual Desktop. The implementation in the repository includes SCCA-compliant infrastructure, GPU-enabled VMs, Azure NetApp Files, and FSLogix pre-configured for rapid proof-of-concept deployments.
- You can use [ArcGIS Enterprise Builder](https://enterprise.arcgis.com/en/get-started/latest/windows/arcgis-enterprise-builder.htm) to set up a base ArcGIS Enterprise deployment on a single machine or multiple machines.

## Related resource

- [Azure Virtual Desktop landing zone design guide](../../landing-zones/azure-virtual-desktop/design-guide.md)
