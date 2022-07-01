Esri's technology is a Geographic Information System (GIS) that contains many important capabilities around visualization, analysis, data management, etc. of geospatial data. Esri’s core technology is called the ArcGIS platform which includes capabilities around mapping, spatial analysis, 3D GIS, imagery & remote sensing, data collection and management, and field operations. See [here](https://www.esri.com/en-us/arcgis/about-arcgis/overview) for more information. A key part of the technology includes a desktop software app called ArcGIS Pro which is a 64-bit professional desktop GIS.  It allows GIS Analysts to perform spatial analysis and edit spatial data while also allowing GIS administrators to create and publish geospatial services. In this architecture, we will show how ArcGIS Pro can be deployed in Azure Virtual Desktop for the purpose of supporting enterprise customers at the hyperscale of Azure. The architecture also includes backend components such as ArcGIS Enterprise so as to build a complete system in Azure.

## Relevant use cases

Most demand for Esri’s ArcGIS and virtual desktop solutions from:

- Security and regulation applications such as utilities, healthcare, and government.
- Elastic workforce needs like remote work, mergers and acquisition, short-term employees, contractors, and partner access. 
- Specific employees like bring your own device (BYOD) and mobile users, and branch workers. 
- Specialized workloads like land management, design and engineering, legacy apps, and software development test.

While GIS has been implemented in Azure for many years, it has typically only included the backend components which naturally introduces latency between the client and server components. Also, customers have been able to deploy desktop GIS on VMs from the Azure Marketplace, but this has also been done for a handful of thick clients which is not very scalable. This reference architecture will address both challenges. 

## Architecture

Provided here is a high-level architecture for deploying ArcGIS components in Azure.

diagram 

- This solution is deployed into a single region with storage, GIS desktop, GIS backend, storage, and Azure Virtual Desktop (AVD) resource groups. Each resource group contains one subnet, all of which are in one virtual network. All components are in a single Azure subscription.  This architecture is a three-tier deployment. 
- The application endpoints are in the customer's on-premises network. 
- The Azure Virtual Desktop control plane handles Web Access, Gateway, Broker, Diagnostics, and extensibility components like REST APIs.
- The customer manages AD DS and Azure AD, Azure subscriptions, virtual networks, [Azure Files or Azure NetApp Files](/azure/virtual-desktop/store-fslogix-profile), and the Azure Virtual Desktop host pools and workspaces.
- GIS Analysts/Administrators/Editors connect to AVD via an RDP session. From there, ArcGIS Pro can be accessed and take advantage of the GPUs for Light, Medium and Heavy workflows. Light refers to a 2D workflow, Medium refers to more demanding 2D workflow and Heavy refers to a 2D/3D workflow that requires GPUs. GIS Administrators can also take advantage of ArcGIS Pro to publish services and administer the enterprise geodatabase. Lastly, GIS editors can maintain the vector and raster layers.
- The desktop VMs are based on [N-Series VMs](https://azure.microsoft.com/pricing/details/virtual-machines/series/#:~:text=The%20N-series%20is%20a%20family%20of%20Azure%20Virtual,has%20three%20different%20offerings%20aimed%20at%20specific%20workloads%3A). Example VM SKUs for ArcGIS Pro: 
  - Heavy =  Standard_NV16as_v4  16CPU x 56GB 
  - Medium =  Standard_NV8as_v4   8CPU x 28 GB 
  - Light =  Standard_NV4as_v4   4CPU X 14 GB 

  See [here](/azure/virtual-machines/nv-series) for details on the VMs. These groupings allow administrators to size the VMs based on workflows and opposed to VM capabilities. For example, the end users would see “ArcGIS Pro Heavy” which would indicate it’s for power users that need 3D intensive workflows. Administrators can also make it possible to publish new versions of ArcGIS Pro using semantic versioning. For example, as new versions of ArcGIS Pro become available, such as ArcGIS Pro 3.0, this new version can be published in the Remote Desktop tool. As a result, users can pick that new version when they are ready to upgrade without having to perform the upgrade themselves. The GPU drivers can be included in the creation of the images which these deployments are based on.

  screenshot 

- Web GIS users can also take advantage of this solution by accessing ArcGIS Enterprise administrative interfaces either in the browser in the AVD RDP session or via their local browser (if it is published as public facing). The Azure Application Gateway will route the traffic to the correct endpoint for the ArcGIS server roles. As with ArcGIS Pro, the latency between the browsers and backend are minimized. 
- The Enterprise Geodatabase can be deployed in Azure SQL Managed Instance. ArcGIS Pro users can then create, manage, and edit the geodatabase from the RDP session. During the creation of the Azure Virtual Desktop image creation process, administrators can include the ODBC drivers so users don’t have to install them on the AVD VMs.
- Azure NetApp Files can support fast access to the ArcGIS Server configuration store and directories. While Azure Files and Azure Storage can also be taken advantage of, Azure NetApp Files cost less for large deployments as compared to Azure Files and Azure Storage. Additionally, Azure NetApp Files can be added for storing Portal for ArcGIS items and raster images, LiDAR data, etc.   
- To increase capacity, the customer can use multiple Azure subscriptions in a hub-spoke architecture design and connect them via virtual network peering. Also, Azure Landing Zones can be utilized to lay down the initial services. See [here](/azure/cloud-adoption-framework/ready/landing-zone. [check indent]

## Esri Components

- [ArcGIS Pro](https://www.esri.com/en-us/arcgis/products/arcgis-pro/overview) is Esri’s professional desktop GIS application. It allows power users to explore, geovisualize, and analyze data. It includes 2D and 3D capabilities and runs best on Azure High Performance Compute VMs such as the NV series. The use of ArcGIS can be scaled using Azure Virtual Desktop.  
- [ArcGIS Enterprise](https://enterprise.arcgis.com/en/get-started/latest/windows/what-is-arcgis-enterprise-.htm) is a platform for mapping and geovisualization, analytics and data management which hosts data, applications, and custom low-code/no-code applications. It works along with the desktop GIS called ArcGIS Pro or ArcGIS Desktop (not included here because it has been supplanted by ArcGIS Pro). ArcGIS Enterprise is not part of this reference architecture but the architecture could be extended to include it.  
- [Portal for ArcGIS](https://enterprise.arcgis.com/en/portal) is also part of the base deployment. It includes the ability to share maps, scenes, apps and other geospatial information within an enterprise organization. With this front-end interface, anyone in the enterprise can make a map, find layers, perform queries, etc. with very little training.  
- [ArcGIS Server](https://enterprise.arcgis.com/en/server/latest/get-started/windows/what-is-arcgis-for-server-.htm) is a back-end server software that is either deployed with ArcGIS Enterprise or in a standalone deployment with ArcGIS Enterprise. The purpose of the ArcGIS Server is to receive requests from clients which then draws the maps, runs tools, queries the data, etc. It also has a management plane that allows administrative users to start, stop, delete, etc. the services. 
- [ArcGIS Server Configuration store](https://enterprise.arcgis.com/en/server/latest/get-started/windows/what-is-arcgis-for-server-.htm) is a store that contains information so that as ArcGIS Server scales to other machines it can share the configuration of how the system is configured.  
- [Enterprise Geodatabase](https://enterprise.arcgis.com/en/server/latest/manage-data/windows/enterprise-geodatabases-and-arcgis-enterprise.htm) is a geospatial database specifically designed to host vector and raster data. It can be deployed in many databases management systems. In this reference architecture, the enterprise geodatabase is stored in Azure SQL Managed Instance. 
- Other server roles of ArcGIS Enterprise such as Raster Analytics Server, GeoAnalytics Server, GeoEvent Server, Knowledge Server, Mission Server, etc. can be added to this base deployment as needed. Likewise, newer technologies such as ArcGIS Enterprise for Kubernetes can also be included as part of this architecture as a replacement for ArcGIS Enterprise or as a supplement. GPU based VMs for Drone2Map, CityEngine, and SURE for ArcGIS can also take advantage of these VMs. [is this a bullet? ]

## Microsoft Components

- [Azure NetApp Files](https://azure.microsoft.com/services/netapp) is an enterprise-class, high-performance, metered file Network Attached Storage (NAS) service.  
- [Azure Monitor](https://docs.microsoft.com/dotnet/architecture/cloud-native/azure-monitor) is an umbrella name for a collection of tools designed to provide visibility into the state of your system. It helps you understand how your cloud-native services are performing and proactively identifies issues affecting them.
- [Azure Policy](https://docs.microsoft.com/azure/governance/policy/overview) helps to enforce organizational standards and to assess compliance at-scale. Through its compliance dashboard, it provides an aggregated view to evaluate the overall state of the environment, with the ability to drill down to the per-resource, per-policy granularity. It also helps to bring your resources to compliance through bulk remediation for existing resources and automatic remediation for new resources. The [Azure Active Directory](https://azure.microsoft.com/services/active-directory/?OCID=AID2200277_SEM_95e2fa41149910bb0870986a6493e4ef:G:s&ef_id=95e2fa41149910bb0870986a6493e4ef:G:s&msclkid=95e2fa41149910bb0870986a6493e4ef#overview) (Azure AD) enterprise identity service provides single sign-on, multifactor authentication, and conditional access to guard against 99.9 percent of cybersecurity attacks. 
- [Active Directory Domain Services](https://docs.microsoft.com/en-us/azure/active-directory-domain-services/overview) (AD DS) provides the methods for storing directory data and making this data available to network users and administrators. AD DS stores information about user accounts, such as names, passwords, phone numbers, and enables other authorized users on the same network to access this information. This data store, also known as the directory, contains information about Active Directory objects. These objects typically include shared resources such as servers, volumes, printers, and the network user and computer accounts. 

Security is integrated with Active Directory through logon authentication and access control to objects in the directory. With a single network logon, administrators can manage directory data and organization throughout their network, and authorized network users can access resources anywhere on the network. [check paragraphing]

- [Azure Virtual Desktop](https://azure.microsoft.com/services/virtual-desktop) is a desktop and application virtualization service that runs in the Azure cloud.  This service is free to use and is managed by Microsoft as a Platform as a Service (PaaS) offering, saving customers on licensing and infrastructure costs. It is a flexible cloud virtual desktop infrastructure (VDI) platform that securely delivers virtual desktops and remote apps with maximum control. 
- [Azure SQL Managed Instance](https://azure.microsoft.com/products/azure-sql/database)  is a PaaS version of SQL Server and is an intelligent, scalable, relational database service. 
- [Azure Application Gateway](https://docs.microsoft.com/azure/application-gateway/overview) is an application delivery controller-as-a-service offering that provides layer 7 load balancing, security, and web application firewall functionality. 
- [FSlogix](https://docs.microsoft.com/fslogix) enhances and enables user profile management for Windows remote computing environment. It allows users to roam between remote computing session hosts, minimize sign in times for virtual desktop environment, optimize file IO between host/client and remote profile store, etc.  

  For more information about FSLogix Profile Container - Azure Files and Azure NetApp Files best practices, see [FSLogix for the enterprise](https://docs.microsoft.com/azure/architecture/example-scenario/wvd/windows-virtual-desktop-fslogix)

## Key considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework). from template 

### Latency and bandwidth considerations

Implementation of this solution has shown that ideally the latency between the end-user and the RDP session needs to ideally be around 200ms or less. This is ideal because as ArcGIS Pro users interact with the map and perform measurements or edits, the interactive edits responsiveness and the tooltips appear sufficiently fast enough.  The  Azure [Virtual Desktop Experience Estimator](https://azure.microsoft.com/services/virtual-desktop/assessment/#estimation-tool) can provide you with a quick assessment of connection round trip time (RTT) from your current location, through the Azure Virtual Desktop service, to each Azure region in which you can deploy virtual machines. 

When using a remote Windows session, your network's available bandwidth greatly impacts the quality of your experience. The following table lists the minimum recommended bandwidths for a smooth user experience. These recommendations are based on the guidelines in [Remote Desktop workloads](https://docs.microsoft.com/windows-server/remote/remote-desktop-services/remote-desktop-workloads).


|Workload type  |Recommended bandwidth  |
|---------|---------|
|Light     | 1.5 Mbps         |
|Medium     |3 Mbps         |
|Heavy     |  5 Mbps        |
|Power      |  15 Mbps        |

Keep in mind that the stress put on your network depends on both your app workload's output frame rate and your display resolution. If either the frame rate or display resolution increases, the bandwidth requirement will also rise. For example, a light workload with a high-resolution display requires more available bandwidth than a light workload with regular or low resolution.

### Network

Ideally all components in the above diagram are deployed in a single region so as to minimize latency between the components. However, for large organizations, a multi-region deployment will be necessary and is supported. An additional component to consider is [Azure Front Door](https://docs.microsoft.com/azure/frontdoor/front-door-overview) which would route the user to the closest region.  

Another significant benefit of this architecture is that the latency between it and Esri’s SaaS offerings such as ArcGIS Velocity and ArcGIS Image are also reduced not only for ArcGIS Pro users, but also for web browser users. All components of the ArcGIS platform are in the cloud.

### Storage

Although Azure Files and Azure Storage (blob) are fine for many enterprise, Azure NetApp Files may be better suited for GIS because of large raster image files, Portal for ArcGIS items, shapefiles, LiDAR datasets, File Geodatabases, and other geospatial data types that require fast access.  

### Testing

The system's latency can be tested with the Connection Experience Indicator which can be found [here](https://bramwolfs.com/2020/03/11/connection-experience-indicator-for-rds-wvd). Esri's ArcGIS Pro Performance Assessment Tool can be downloaded from [here](https://pro.arcgis.com/en/pro-app/latest/get-started/pro-performance-tool-overview.htm) to test the performance. Also, Esri recommends tools for testing ArcGIS Enterprise [here](https://community.esri.com/t5/implementing-arcgis-blog/performance-engineering-load-testing-arcgis/ba-p/1070106#:~:text=Performance%20Engineering%20is%20the%20practice%20of%20proactively%20testing%2C,components%20%28e.g.%20map%20service%20composition%29%20of%20a%20Site.). Likewise, [Azure Load Testing](https://azure.microsoft.com/services/load-testing) can assist.

### Scaling 

There are many ways to scale this reference architecture. They include scaling in or out and up and down the VMs for the backend or the desktops (both CPU and GPUs). Also, AVD can be deployed on individual VMs or in multi-session VMs. AVD can scale from hundreds to thousands of VMs. See [here](/mem/intune/fundamentals/azure-virtual-desktop-multi-session).

## Next steps
 
- [Azure Virtual Desktop for the enterprise](/azure/architecture/example-scenario/wvd/windows-virtual-desktop) 
- [Create a managed image of a generalized VM in Azure](/azure/virtual-machines/windows/capture-image-resource) 
- Prepare an AVD Image with this [script](https://minhaskamal.github.io/DownGit/#/home?url=https://github.com/shawntmeyer/WVD/tree/master/Image-Build/Customizations)
- [Download and Install FSLogix](https://docs.microsoft.com/FSLogix/install-ht)
- [Create golden image in Azure](/azure/virtual-desktop/set-up-golden-image)
- [Create AVD host pool](/azure/virtual-desktop/create-host-pools-azure-marketplace?tabs=azure-portal)
- [Create an Azure SQL Managed Instance](/azure/azure-sql/managed-instance/instance-create-quickstart?view=azuresql)
- [Install ArcGIS Server](https://enterprise.arcgis.com/en/server/latest/install/windows/welcome-to-the-arcgis-for-server-install-guide.htm)
- [Install Portal for ArcGIS](https://enterprise.arcgis.com/en/portal/latest/install/windows/welcome-to-the-portal-for-arcgis-installation-guide.htm) 
- [Install NVIDIA GPU drivers on N-Series VMs running Windows](/azure/virtual-machines/windows/n-series-driver-setup)
- [Assessing Azure SQL Managed Instance vis SSMS](https://www.jamesserra.com/archive/2020/04/accessing-managed-instance-via-ssms) 
- [Configure public endpoint in Azure SQL Managed Instance}(/azure/azure-sql/managed-instance/public-endpoint-configure?view=azuresql)
- [Connect to Microsoft SQL Server from ArcGIS](https://pro.arcgis.com/en/pro-app/latest/help/data/geodatabases/manage-sql-server/connect-sqlserver.htm)
- [Create Enterprise Geodatabase](https://pro.arcgis.com/en/pro-app/latest/tool-reference/data-management/create-enterprise-geodatabase.htm)

## Alternatives

- [Use the ArcGIS Enterprise Builder](https://enterprise.arcgis.com/en/get-started/latest/windows/arcgis-enterprise-builder.htm)
- Additional ArcGIS Enterprise server roles can be added to this base deployment. See [here](https://enterprise.arcgis.com/en/get-started/latest/windows/additional-server-deployment.htm#:~:text=In%20the%20base%20ArcGIS%20Enterprise%20deployment%2C%20ArcGIS%20GIS,reference%20your%20own%20data%20sources%2C%20such%20as%20geodatabases.) for more information.

## Additional resources

- [FSLogix for the enterprise - best practices documentation](/azure/architecture/example-scenario/wvd/windows-virtual-desktop-fslogix)
- For multiple AD forests architecture, read [Multiple AD Forests Architecture in Azure Virtual Desktop](/azure/architecture/example-scenario/wvd/multi-forest)
- [Tune ArcGIS Enterprise using best practices](https://enterprise.arcgis.com/en/server/latest/administer/windows/tuning-your-arcgis-server-site.htm)
- [Configure highly available ArcGIS Enterprise](https://enterprise.arcgis.com/en/portal/latest/administer/windows/configure-highly-available-system.htm)