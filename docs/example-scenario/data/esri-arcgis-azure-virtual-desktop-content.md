This architecture shows how you can deploy Esri ArcGIS Pro in Azure Virtual Desktop to support the hyperscale of Azure. The architecture also includes back-end components like ArcGIS Enterprise to build a complete system on Azure.

*ArcGIS® is a trademark of its company. No endorsement is implied by the use of this mark.*

## Architecture

The following diagram presents a high-level architecture for deploying ArcGIS components on Azure.

:::image type="content" source="media/virtual-desktop-gis-azure-network.png" alt-text="Diagram that shows an architecture for deploying ArcGIS components on Azure." lightbox="media/virtual-desktop-gis-azure-network.png":::

*Download a [Visio file](https://arch-center.azureedge.net/AVD-GIS-Azure-Network.vsdx) of this architecture.*

### Workflow

- This solution is deployed to a single region with storage, GIS desktop, GIS back end, and Azure Virtual Desktop resource groups. Each resource group contains one subnet, and all subnets are in one virtual network. All components are in a single Azure subscription.  This architecture is a three-tier deployment.
- The application endpoints are in the on-premises network.
- The Azure Virtual Desktop control plane handles web access, gateway, broker, diagnostics, and extensibility components like REST APIs.
- You manage Azure Active Directory Domain Services (Azure AD DS) and Azure Active Directory (Azure AD), Azure subscriptions, virtual networks, [Azure Files or Azure NetApp Files](/azure/virtual-desktop/store-fslogix-profile), and the Azure Virtual Desktop host pools and workspaces.
- GIS analysts, administrators, and editors connect to Azure Virtual Desktop via a Remote Desktop Protocol (RDP) session. From there, ArcGIS Pro is accessed and takes advantage of the GPUs for light, medium, and heavy workflows. *Light* refers to a 2D workflow, *medium* refers to a more demanding 2D workflow, and *heavy* refers to a 2D or 3D workflow that requires GPUs. GIS administrators can also use ArcGIS Pro to publish services and administer the enterprise geodatabase. Finally, GIS editors can maintain the vector and raster layers.
- The desktop VMs are based on [N-Series VMs](https://azure.microsoft.com/pricing/details/virtual-machines/series/#:~:text=The%20N-series%20is%20a%20family%20of%20Azure%20Virtual,has%20three%20different%20offerings%20aimed%20at%20specific%20workloads%3A). Example VM SKUs for ArcGIS Pro: 
  - Heavy: Standard_NV16as_v4. 16 CPU, 56 GB.
  - Medium: Standard_NV8as_v4. 8 CPU, 28 GB.
  - Light: Standard_NV4as_v4. 4 CPU, 14 GB.

  For details on the VMs, see [NV-Series](/azure/virtual-machines/nv-series). The preceding groupings allow administrators to size the VMs based on workflows as opposed to VM capabilities. For example, end users see **GIS-Heavy-pool**, which indicates that the VM is for power users that need 3D-intensive workflows. 
 
  Administrators can also make it possible to publish new versions of ArcGIS Pro by using semantic versioning. For example, as new versions of ArcGIS Pro are available, like ArcGIS Pro 3.0, the new version can be published in the Remote Desktop tool. As a result, users can pick that new version when they're ready to upgrade without having to perform the upgrade themselves. The GPU drivers can be included in the creation of the images that the deployments are based on.

  :::image type="content" source="media/arcgis-rdp.png" alt-text="Screenshot that shows ArcGIS and VMs in Remote Desktop.":::
  
- Web GIS users can also take advantage of this solution by accessing ArcGIS Enterprise administrative interfaces either in the browser in the Azure Virtual Desktop RDP session or via their local browser (if ArcGIS is published as public facing). The Azure application gateway routes the traffic to the correct endpoint for the ArcGIS server roles. As with ArcGIS Pro, the latency between the browsers and the back end are minimized. 
- You can deploy the enterprise geodatabase in Azure SQL Managed Instance. ArcGIS Pro users can then create, manage, and edit the geodatabase from an RDP session. During the creation of the Azure Virtual Desktop image, administrators can include the ODBC drivers so users don't have to install them on the Azure Virtual Desktop VMs.
- Azure NetApp Files supports fast access to the ArcGIS Server configuration store and directories. You can use Azure Files and Azure Storage, but Azure NetApp Files costs less for large deployments. Additionally, you can use Azure NetApp Files to store Portal for ArcGIS items and raster images, lidar data, and so on.

### Components

- [Azure NetApp Files](https://azure.microsoft.com/services/netapp) is an enterprise-class, high-performance, metered file Network Attached Storage (NAS) service.  
- [Azure Monitor](https://azure.microsoft.com/services/monitor) is a collection of tools that provides visibility into the state of your system. It helps you understand how your cloud-native services are performing and proactively identifies problems that affect them.
- [Azure Policy](https://azure.microsoft.com/services/azure-policy) helps you enforce organizational standards and assess compliance at scale. Through its compliance dashboard, it provides an aggregated view of the overall state of the environment and the ability to drill down to per-resource, per-policy granularity. It also helps you bring your resources to compliance via bulk remediation for existing resources and automatic remediation for new resources. 
- [Azure Active Directory (Azure AD)](https://azure.microsoft.com/services/active-directory) enterprise identity service provides single sign-on, multifactor authentication, and conditional access to guard against 99.9 percent of cybersecurity attacks. 
- [Active Directory Domain Services (AD DS)](https://azure.microsoft.com/services/active-directory-ds) enables you to store directory data and make that data available to network users and administrators. AD DS stores information about user accounts, like names, passwords, and phone numbers, and enables other authorized users on the same network to access that information. This data store, also known as the *directory*, contains information about Active Directory objects. These objects typically include shared resources like servers, volumes, printers, and the network user and computer accounts.

  Security is integrated with Active Directory through sign-in authentication and controlled access to objects in the directory. With a single network sign-in, administrators can manage directory data and organization throughout their network, and authorized network users can access resources anywhere on the network.

- [Azure Virtual Desktop](https://azure.microsoft.com/services/virtual-desktop) is a desktop and application virtualization service that runs on Azure. This service is free and managed by Microsoft as a platform as a service (PaaS) offering, saving you money on licensing and infrastructure costs. It's a flexible cloud virtual desktop infrastructure (VDI) platform that delivers virtual desktops and remote apps with maximum control and improved security.
- [Azure SQL Managed Instance](https://azure.microsoft.com/products/azure-sql/database)  is a PaaS version of SQL Server. It's an intelligent and scalable relational database service.
- [Azure Application Gateway](https://azure.microsoft.com/services/application-gateway) is an application delivery controller-as-a-service offering that provides layer-7 load balancing, security, and web application firewall functionality. 
- [FSLogix](/fslogix) enhances and enables user profile management for Windows remote computing environments. It allows users to roam between remote computing session hosts, minimize sign-in times for virtual desktop environments, and optimize file I/O between the host/client and the remote profile store.  

  For information about FSLogix Profile Container, Azure Files, and Azure NetApp Files best practices, see [FSLogix for the enterprise](/azure/architecture/example-scenario/wvd/windows-virtual-desktop-fslogix).
- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network) enables you to create your own private network infrastructure in the cloud. 
- [ArcGIS Pro](https://www.esri.com/en-us/arcgis/products/arcgis-pro/overview) is Esri's professional desktop GIS application. It enables power users to explore, geovisualize, and analyze data. It includes 2D and 3D capabilities and runs best on Azure high performance computing VMs, like those in the NV-Series. You can scale the use of ArcGIS by using Azure Virtual Desktop.  
- [ArcGIS Enterprise](https://enterprise.arcgis.com/en/get-started/latest/windows/what-is-arcgis-enterprise-.htm) is a platform for mapping and geovisualization, analytics, and data management that hosts data, applications, and custom low-code or no-code applications. It works with ArcGIS Pro or ArcGIS Desktop (not included here because it has been replaced by ArcGIS Pro). ArcGIS Enterprise isn't part of this reference architecture, but you can extend the architecture to include it.  
- [Portal for ArcGIS](https://enterprise.arcgis.com/en/portal) is part of the base deployment. It provides the ability to share maps, scenes, apps, and other geospatial information within an organization. With this front-end interface, anyone in the organization can make a map, find layers, and perform queries with very little training.  
- [ArcGIS Server](https://enterprise.arcgis.com/en/server/latest/get-started/windows/what-is-arcgis-for-server-.htm) is back-end server software that's deployed with ArcGIS Enterprise or in a standalone deployment with ArcGIS Enterprise. ArcGIS Server receives requests from clients to draw maps, run tools, query data, and so on. It also has a management plane that enables administrators to start, stop, and delete services.
- [ArcGIS Server configuration store](https://enterprise.arcgis.com/en/server/10.6/administer/windows/about-the-configuration-store.htm) contains system configuration information so that, as ArcGIS Server scales to other machines, it can share that information.  
- [Enterprise geodatabase](https://enterprise.arcgis.com/en/server/latest/manage-data/windows/enterprise-geodatabases-and-arcgis-enterprise.htm) is a geospatial database designed to host vector and raster data. It can be deployed in many database management systems. In this architecture, the enterprise geodatabase is stored in Azure SQL Managed Instance. 

### Alternatives

- You can use [ArcGIS Enterprise Builder](https://enterprise.arcgis.com/en/get-started/latest/windows/arcgis-enterprise-builder.htm) to set up a base ArcGIS Enterprise deployment on a single machine or multiple machines. 
- Although Azure Files and Azure Blob Storage are fine for many enterprises, Azure NetApp Files might be better suited for GIS because of large raster image files, Portal for ArcGIS items, shapefiles, lidar datasets, file geodatabases, and other geospatial data types that require fast access.  
- You can add other ArcGIS Enterprise server roles, like Raster Analytics Server, GeoAnalytics Server, GeoEvent Server, Knowledge Server, and Mission Server, to this base deployment as needed. You can also use newer technologies, like ArcGIS Enterprise on Kubernetes, as a replacement for or supplement to ArcGIS Enterprise. GPU-based VMs for Drone2Map, CityEngine, and SURE for ArcGIS can also take advantage of these VMs. For more information, see [ArcGIS Enterprise server roles](https://enterprise.arcgis.com/en/get-started/latest/windows/additional-server-deployment.htm#:~:text=In%20the%20base%20ArcGIS%20Enterprise%20deployment%2C%20ArcGIS%20GIS,reference%20your%20own%20data%20sources%2C%20such%20as%20geodatabases.).
- To increase capacity, you can use multiple Azure subscriptions in a hub-and-spoke architecture and connect them via virtual network peering. Also, you can use Azure landing zones to lay down the initial services. For more information, see [What is an Azure landing zone?](/azure/cloud-adoption-framework/ready/landing-zone).

## Scenario details

Esri's technology is a geographic information system (GIS) that contains capabilities for the visualization, analysis, and data management of geospatial data. Esri's core technology is called *the ArcGIS platform*. It includes capabilities for mapping, spatial analysis, 3D GIS, imagery and remote sensing, data collection and management, and field operations. For more information, see the [ArcGIS page](https://www.esri.com/en-us/arcgis/about-arcgis/overview) on the Esri website. 

A desktop app called *ArcGIS Pro* is a key part of the technology. It's a 64-bit professional desktop GIS. GIS analysts can use it to perform spatial analysis and edit spatial data. GIS administrators can use it to create and publish geospatial services.

### Potential use cases

Esri's ArcGIS and virtual desktop solutions are frequently used for:

- Security and regulation applications like utilities (energy), healthcare, and government.
- Elastic workforce needs like remote work, mergers and acquisition, short-term employees, contractors, and partner access.
- Employees like bring your own device (BYOD) users, mobile users, and branch workers. 
- Specialized workloads like land management (facilities and real estate), design and engineering, legacy apps, and software testing.

Although GIS has been implemented in Azure for many years, it has typically included only the back-end components. That implementation introduces latency between the client and server components. Organizations have been able to deploy desktop GIS on VMs from Azure Marketplace, but that deployment is for thick clients and isn't very scalable. This architecture addresses both challenges.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview). 

Ideally, the latency between the end user and the RDP session needs to be around 200 ms or less. This latency helps to ensure that, when ArcGIS Pro users interact with maps and perform measurements or edits, the interactive edits and the tooltips appear quickly enough. The [Azure Virtual Desktop Experience Estimator](https://azure.microsoft.com/services/virtual-desktop/assessment) can provide a quick assessment of connection round-trip time (RTT) from your location, through the Azure Virtual Desktop service, and to each Azure region in which you can deploy virtual machines. 

When you use a remote Windows session, your network's available bandwidth greatly affects the quality of your experience. The following table lists the minimum recommended bandwidths for a smooth user experience. These recommendations are based on the guidelines in [Remote Desktop workloads](/windows-server/remote/remote-desktop-services/remote-desktop-workloads).

|Workload type  |Recommended bandwidth  |
|---------|---------|
|Light     | 1.5 Mbps         |
|Medium     |3 Mbps         |
|Heavy     |  5 Mbps        |
|Power      |  15 Mbps        |

Keep in mind that the stress put on your network depends on both your app workload's output frame rate and your display resolution. If either the frame rate or display resolution increases, the bandwidth requirement also rises. For example, a light workload with a high-resolution display requires more available bandwidth than a light workload with regular or low resolution.

Ideally, all components in the preceding architecture diagram are deployed in a single region to minimize latency between components. However, for large organizations, a multi-region deployment is necessary and supported. Another component to consider is [Azure Front Door](https://azure.microsoft.com/services/frontdoor), which routes users to the closest region.  

Another significant benefit of this architecture is that the latency between it and Esri's SaaS offerings, like ArcGIS Velocity and ArcGIS Image, is also reduced for ArcGIS Pro users and web browser users. All components of the ArcGIS platform are in the cloud.

### Scalability

You can scale this architecture in many ways. You can scale the VMs for the back end or the desktops (both CPU and GPUs) in, out, up, or down. You can also deploy Azure Virtual Desktop on individual VMs or multi-session VMs. Azure Virtual Desktop can scale hundreds or thousands of VMs. For more information, see  [Windows 10 or Windows 11 Enterprise multi-session remote desktops](/mem/intune/fundamentals/azure-virtual-desktop-multi-session).

### Testing

You can test your system's latency by using the [Connection Experience Indicator](https://bramwolfs.com/2020/03/11/connection-experience-indicator-for-rds-wvd). You can use [Esri's ArcGIS Pro Performance Assessment Tool](https://pro.arcgis.com/en/pro-app/latest/get-started/pro-performance-tool-overview.htm) to test the performance. Esri also recommends [tools for testing ArcGIS Enterprise](https://community.esri.com/t5/implementing-arcgis-blog/performance-engineering-load-testing-arcgis/ba-p/1070106#:~:text=Performance%20Engineering%20is%20the%20practice%20of%20proactively%20testing%2C,components%20%28e.g.%20map%20service%20composition%29%20of%20a%20Site.). [Azure Load Testing](https://azure.microsoft.com/services/load-testing) can also be helpful.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal authors:

 - [Matt Hallenborg](https://www.linkedin.com/in/matt-hallenborg) | (Senior Cloud Solution Architect)
 - [Ron Vincent](https://www.linkedin.com/in/ron-vincent-8958145) | (Senior Program Manager)

Other contributor:

 - [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414) | (Technical Writer)
 
*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps
 
- [Create a managed image of a generalized VM in Azure](/azure/virtual-machines/windows/capture-image-resource) 
- [Prepare an Azure Virtual Desktop image with this script](https://github.com/The-Virtual-Desktop-Team/Virtual-Desktop-Optimization-Tool)
- [Download and install FSLogix](/FSLogix/install-ht)
- [Create a golden image in Azure](/azure/virtual-desktop/set-up-golden-image)
- [Create an Azure Virtual Desktop host pool](/azure/virtual-desktop/create-host-pools-azure-marketplace?tabs=azure-portal)
- [Create an Azure SQL Managed Instance](/azure/azure-sql/managed-instance/instance-create-quickstart?view=azuresql)
- [Install ArcGIS Server](https://enterprise.arcgis.com/en/server/latest/install/windows/welcome-to-the-arcgis-for-server-install-guide.htm)
- [Install Portal for ArcGIS](https://enterprise.arcgis.com/en/portal/latest/install/windows/welcome-to-the-portal-for-arcgis-installation-guide.htm) 
- [Install NVIDIA GPU drivers on N-Series VMs running Windows](/azure/virtual-machines/windows/n-series-driver-setup)
- [Assess Azure SQL Managed Instance via SSMS](https://www.jamesserra.com/archive/2020/04/accessing-managed-instance-via-ssms) 
- [Configure public endpoint in Azure SQL Managed Instance](/azure/azure-sql/managed-instance/public-endpoint-configure?view=azuresql)
- [Connect to Microsoft SQL Server from ArcGIS](https://pro.arcgis.com/en/pro-app/latest/help/data/geodatabases/manage-sql-server/connect-sqlserver.htm)
- [Create Enterprise Geodatabase](https://pro.arcgis.com/en/pro-app/latest/tool-reference/data-management/create-enterprise-geodatabase.htm)
- [Best practices for tuning ArcGIS Enterprise](https://enterprise.arcgis.com/en/server/latest/administer/windows/tuning-your-arcgis-server-site.htm)
- [Configure highly available ArcGIS Enterprise](https://enterprise.arcgis.com/en/portal/latest/administer/windows/configure-highly-available-system.htm)
- [Esri GIS mapping software, location intelligence, and spatial analytics](https://www.esri.com/en-us/home)

## Related resources

- [Azure Virtual Desktop for the enterprise](../wvd/windows-virtual-desktop.yml)
- [FSLogix for the enterprise - best practices documentation](../wvd/windows-virtual-desktop-fslogix.yml)
- [Multiple forests with AD DS and Azure AD](../wvd/multi-forest.yml)
