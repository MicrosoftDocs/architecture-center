Digital transformation is imperative for any business that wants to stay competitive in today's marketplace. This transformation demands timely access to data and data insights, which drive new business processes and client experiences. However, it can also affect existing applications and data in ways that might be overlooked or misunderstood.

To meet the demand for streamlined access, you can adopt integration approaches that take advantage of REST APIs based on industry standards. This architecture extends mainframe applications to Azure without disruptions or modifications to existing mainframe applications. IBM z/OS Connect is a component of IBM Z and Cloud Modernization Stack. It provides more reliable and secure connectivity between applications on Azure and applications and data on z/OS. IBM z/OS Connect helps integrate and provide access to the data and services on the mainframe.

## Architecture

The following architecture shows how IBM Z and Cloud Modernization Stack provide a low-code solution to extend mainframe subsystems via standards-based REST APIs.

:::image type="complex" source="./media/extend-mainframes.svg" alt-text="Diagram that shows an architecture that extends mainframe subsystems via REST APIs." lightbox="./media/extend-mainframes.svg" border="false":::
The diagram is divided into the cloud environment and the on-premises environment. The Microsoft edge routers and local edge routers connect via an ExpressRoute circuit. The cloud environment contains the Red Hat OpenShift Container Platform, which IBM Z and Cloud Modernization Stack, which contains z/OS Connect. z/OS Connect contains Designer and Server. This entire component connects to custom connectors and REST APIs. The custom connectors connect to Power Apps, which connects to external users and Microsoft Entra ID. Microsoft Entra ID connects to external users and applications and App Service environments. The REST APIs connect to API Management, which connects to applications and App Service environments. Applications and App Service environments also connect to external users. The cloud environment also contains Azure Monitor, Application Insights, and Azure Site Recovery.

The on-premises environment hosts the IBM zSeries mainframe. On-premises web interface users and on-premises admin and users connect to a box that contains several components. These components include communications standards, integration middleware, z/OS applications, data and databases, test logical partitions, production logical partitions, and Hypervisor. Integration middleware includes middleware, environment integrators, and other services, such as tape storage and monitoring. z/OS applications include Customer Information Control System and Information Management System transaction processing monitors, business applications, and shared business services. Data and databases include relational databases, hierarchical databases, and data files.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/extend-mainframes-to-digital-channels-by-using-standards-based-rest-apis.vsdx) of this architecture.*

### Workflow

The following workflow corresponds to the previous diagram.

To create and deploy APIs for mainframe applications by using a contract-first approach, do the following steps:

1. Import an OpenAPI v3 (OAS3) declarative JSON API schema file into the [z/OS Connect Designer](https://www.ibm.com/docs/cloud-paks/z-modernization-stack/2023.4?topic=concepts-what-is-zos-connect-designer).

1. Use the z/OS Connect Designer to [map your API and z/OS assets](https://www.ibm.com/docs/cloud-paks/z-modernization-stack/2023.4?topic=designer-mapping-your-rest-api-operations-zos-assets).
1. Test the functionality of the APIs by interacting with core z/OS applications. Push the mappings into source control management.
1. Build a web archive file, and deploy it in [the z/OS Connect Server image](https://www.ibm.com/docs/zos-connect/3.0.0?topic=zos-connect-server-image).
1. Import the OAS3 specification into [Azure API Management](https://azure.microsoft.com/products/api-management/), establish a connection with the z/OS Connect Server, and configure that connection to be a back end in API Management.
1. Enable and enforce API authentication and authorization mechanisms by using Microsoft Entra ID for enhanced security. For more information, see [Authentication and authorization to APIs in API Management](/azure/api-management/authentication-authorization-overview).
1. Microsoft Entra ID is validated from Power Apps.
1. Use Azure monitoring for the application and all components of the solution. For example, you can use Azure alerting for notifications.
1. Use Azure Site Recovery and Azure high availability for all application components in the cloud environment.

To access mainframe applications through Azure, do the following steps:

1. Sign in to Microsoft Entra ID (**step 6**) to get access to client applications. The client applications also communicate with Microsoft Entra ID for authentication and authorization of access to resources.

1. Access client applications, such as Power Apps or a custom web app (**step 7**). These applications access the mainframe applications through REST API access to IBM Z and Cloud Modernization Stack.

IT staff use Azure tools to monitor the system and implement disaster recovery measures through Site Recovery:

1. Deploy new or enhanced applications (**step 7**) to consume the REST API interfaces that API Management exposes.

1. Use Azure Monitor and Application Insights (**step 8**) to monitor Microsoft Power Platform, application APIs, and security aspects.
1. Use Site Recovery for disaster recovery (**step 9**).

### Components

- [Red Hat OpenShift](https://www.redhat.com/technologies/cloud-computing/openshift) reduces the friction of developing, modernizing, deploying, running, and managing applications. In this architecture, Red Hat OpenShift delivers a consistent experience across public cloud, on-premises, hybrid cloud, and edge architectures.

- [IBM Z and Cloud Modernization Stack](https://www.ibm.com/products/z-and-cloud-modernization-stack) provides simple and more secure access to mainframe applications and data through APIs. This architecture enables modern [DevOps for IBM Z](https://www.ibm.com/z/devops) with industry-standard tooling and modern languages to expand your talent pool.

- [IBM z/OS Connect](https://www.ibm.com/products/zos-connect) is a middleware solution that provides more secure connectivity between cloud-native applications and IBM z/OS systems. In this architecture, IBM z/OS Connect integrates and uses data and services that reside on the mainframe, while embracing modern technologies and open standards.

- [API Management](/azure/well-architected/service-guides/azure-api-management) provides a hybrid, multicloud management platform for APIs across all environments. This architecture uses APIs to enable digital experiences, simplify application integration, support new digital products, and make data and services reusable and accessible.

- [Azure App Service](/azure/well-architected/service-guides/app-service-web-apps) is a fully managed platform that you can use to build, deploy, and scale web apps. In this architecture, App Service supports various programming languages and frameworks, which provides seamless integration with Azure services. It also provides autoscaling and high availability features to simplify app deployment and management.

- [Microsoft Power Platform](/power-platform) enables you to rapidly implement low-code application development on Azure to modernize processes and solve challenges. In this architecture, Microsoft Power Platform enhances the ability to quickly develop and deploy applications.

- [Azure Monitor](/azure/azure-monitor/overview) helps maximize the availability and performance of applications and services. This architecture uses Azure Monitor to collect, analyze, and act on information from cloud and on-premises environments. This information helps you identify problems and understand how your applications perform.

- [Azure ExpressRoute](/azure/well-architected/service-guides/azure-expressroute) extends on-premises networks into the Microsoft Cloud over a private connection that a connectivity provider facilitates. In this architecture, ExpressRoute establishes connections to Microsoft Cloud services, such as Microsoft Azure and Microsoft 365.

- [Site Recovery](/azure/site-recovery/site-recovery-overview) is a disaster recovery solution that helps protect and recover applications and workloads that run on virtual or physical machines. This architecture uses Site Recovery to provide business continuity and minimize downtime during planned or unplanned outages.

### Alternatives

Instead of an ExpressRoute gateway, you can use an Azure VPN gateway. A VPN gateway enables more secure site-to-site connectivity. It connects an on-premises network to an Azure virtual network through encrypted tunnels. For more information, see [What is Azure VPN Gateway?](/azure/vpn-gateway/vpn-gateway-about-vpngateways).

## Scenario details

You can deploy IBM Z and Cloud Modernization Stack and z/OS Connect on Azure via Azure Resource Manager templates. You can use this solution to build REST APIs for z/OS applications and data while adhering to OpenAPI standards. You can also scale business-critical APIs and take advantage of IBM Z benefits. Seamless integration with API management solutions like [API Management](https://azure.microsoft.com/products/api-management/) ensures effective API governance. You can integrate APIs with web applications or Microsoft Power Platform for efficient data exchange and integration.

[z/OS Connect Designer](https://www.ibm.com/docs/cloud-paks/z-modernization-stack/2023.2?topic=concepts-what-is-zos-connect-designer) features an intuitive web user interface that provides a low-code approach that's designed to create APIs for IBM Z. This graphical interface reduces development time and the learning curve for new developers who use z/OS Connect.

[Power Apps](/power-apps/powerapps-overview) in [Microsoft Power Platform](https://www.microsoft.com/power-platform) is a low-code or no-code option to create a web-based user interface that connects to the previously mentioned developed services. This architecture shows both a low-code Power Apps client and a custom web app client.

### Potential use cases

Configure mainframe application access via REST APIs for the following scenarios:

- **Front-end applications:** Front-end applications written in Java, Java EE, .NET Framework, C, and C++ can use REST APIs for mainframe applications. These applications can share business logic and units of work with back-end Customer Information Control System applications that use COBOL, PL/I, and other languages. This integration provides communication between the front-end and back-end systems for efficient data exchange and processing.

- **Hybrid solutions with citizen developers:** REST APIs in mainframe applications help citizen developers within enterprises build hybrid solutions. Citizen developers can use mainframe APIs and other APIs within their organization to create innovative applications and integrations. This democratization of API access provides faster development cycles and promotes collaboration among teams.

REST APIs in mainframe applications provide opportunities for modernization and expansion while preserving the essential business logic and data integrity of the mainframe systems. REST APIs in mainframe applications support several front-end technologies and empower citizen developers.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

- [Red Hat OpenShift Container Platform](https://www.redhat.com/technologies/cloud-computing/openshift) provides automated deployment capabilities that help you deploy applications consistently and reliably.

- Reliability is a fundamental pillar of IBM z/OS Connect. z/OS Connect manages high-transaction volumes and handles many concurrent connections. The solution's scalability extends both horizontally and vertically so that it can accommodate the evolving demands of expanding workloads.

- API Management enhances reliability by supporting multi-region deployments across Azure, which provides geographic redundancy. It also integrates seamlessly with IBM z/OS Connect to expose mainframe services as REST APIs, which enables consistent and dependable access to critical workloads.

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

- Microsoft Entra ID provides various security features and capabilities to help protect identities, applications, and data. It also provides authentication and authorization of users and applications. The integration of Microsoft Entra ID with OAuth enables more secure authentication and authorization for applications.

- IBM zSystems provide robust security capabilities for DevSecOps to mitigate business risks, safeguard application data, and help ensure long-term security for your systems.

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

- IBM Z and Cloud Modernization Stack and Azure DevOps reduce the need for custom z/OS tooling. You can implement the same continuous integration and continuous delivery (CI/CD) toolchain and practices across your entire enterprise.

- Azure provides various licensing options for the Power Apps platform. Azure manages these options depending on the total number of users, allowed sign-ins, and page views.

Use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator/) to estimate the cost of implementing your solution.

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

- Use Azure DevOps to drive the development and modernization of z/OS applications by integrating it with IBM Z and Cloud Modernization Stack. This approach enhances agility, accelerates delivery cycles, and boosts developer productivity.

- Modernize COBOL, PL/I, Java, or assembler programs by using your preferred integrated development environments, while also adopting modern languages like Python, Node.js, and Go on z/OS. The flexibility to use familiar tools alongside newer technologies helps transition to new technologies, build efficient workflows, and address technical debt across the development lifecycle.

- [IBM z/OS Connect](https://www.ibm.com/products/zos-connect) facilitates access to back-end application functions by converting them into microservices that have accessible APIs. IBM z/OS Connect enables other applications to interact with these services at scale, while also providing API management and monitoring capabilities.

- [Red Hat OpenShift Container Platform](https://www.redhat.com/technologies/cloud-computing/openshift/container-platform) streamlines deployment processes, provides robust monitoring capabilities, facilitates CI/CD features, and integrates with existing operational tools and processes.

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

- z/OS Connect handles multiple API requests concurrently via the parallel processing capabilities of IBM Z. This parallel processing uses system resources and reduces response times for API calls, which enhance performance.

- Performance efficiency is a core strength of IBM z/OS Connect. It handles high transaction volumes and manages concurrent connections. The solution's scalability expands both horizontally and vertically so that it can adapt to the evolving demands of workloads.

- API Management enhances performance efficiency by automatically scaling out its infrastructure based on incoming traffic and demand. This dynamic scaling ensures consistent response times and reliable throughput, even during traffic spikes, which helps maintain a seamless experience for API consumers without over-provisioning resources.
## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Bhaskar Bandam](https://www.linkedin.com/in/bhaskar-bandam-75202a9) | Senior Technical Program Manager
- [Ivan Dovgan](https://www.linkedin.com/in/ivandov) | Chief Architect

Other contributors:

- [Jim Dugan](https://www.linkedin.com/in/jdugan1) | Principal Technical Program Manager
- Madhu Ananthapadmanabh | Z Hybrid Cloud Integration Solution Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

For more information, [contact the Legacy Migrations Engineering team](mailto:legacy2azure@microsoft.com).

- [Azure DevOps services](https://azure.microsoft.com/products/devops)
- [IBM Z and Cloud Modernization Stack](https://www.ibm.com/products/z-and-cloud-modernization-stack)
- [Azure DevOps for Z systems](https://www.ibm.com/support/pages/system/files/inline-files/Azure-DBB%20Integration%20v2g.pdf)
- [Microsoft Power Platform](https://www.microsoft.com/power-platform)
