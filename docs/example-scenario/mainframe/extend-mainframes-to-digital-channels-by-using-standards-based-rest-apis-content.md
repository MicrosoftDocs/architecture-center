Digital transformation is imperative for any business that’s trying to compete in the marketplace. This transformation demands timely access to data and data insights, fueling new business processes and client experiences, which might cause an overlooked or misunderstood effect to existing applications and data. The demand for streamlined access has led to an integration approach that relies on Representational State Transfer (REST) APIs based on industry standards. This architecture shows how IBM Z and Cloud Modernization Stack with standards-based REST APIs achieves a low-code solution for mainframe subsystems.

## Overview

This architecture extends mainframe applications to Azure without disruptions or modifications to existing mainframe applications. IBM z/OS Connect, a component of IBM Z and Cloud Modernization Stack, is used to provide a more reliable and more secure connectivity between applications on Azure and applications and data on z/OS. Its purpose is to integrate and provide access to the data and services available on the mainframe.

## Architecture

:::image type="content" source="./media/extend-mainframes-to-digital-channels-by-using-standards-based-rest-apis.svg" alt-text="A diagram of the responsibility matrix, showing a deployment using an Azure network connection." lightbox="./media/extend-mainframes-to-digital-channels-by-using-standards-based-rest-apis.svg" border="false":::
*Download a [Visio file](https://arch-center.azureedge.net/extend-mainframes-to-digital-channels-by-using-standards-based-rest-apis.vsdx) of this architecture.*

## Workflow

Take the following steps to create and deploy APIs for mainframe applications by using a contract-first approach:

1. Import an OpenAPI v3 (OAS3) declarative JSON API schema file into the z/OS Connect Designer. For more information, see [What is the z/OS Connect Designer?](https://www.ibm.com/docs/en/cloud-paks/z-modernization-stack/2023.4?topic=concepts-what-is-zos-connect-designer)
1. Use z/OS Connect Designer to [Map your API and z/OS Assets](https://www.ibm.com/docs/en/cloud-paks/z-modernization-stack/2023.4?topic=designer-mapping-your-rest-api-operations-zos-assets).
1. Test the functionality of the APIs by interacting with core z/OS applications and push the mappings into source control management (SCM).
1. Build a web archive (WAR) file and run the production in [the z/OS Connect Server image](https://www.ibm.com/docs/en/zos-connect/zos-connect/3.0?topic=concepts-what-is-zos-connect-server-image).
1. Import the OAS3 specification into [API Management](https://azure.microsoft.com/en-us/products/api-management/) and establish a connection with the z/OS Connect Server.
1. Enable and enforce API authentication and authorization mechanisms by using Microsoft Entra ID for enhanced security. For more information, see [Authentication and authorization to APIs in Azure API Management](/azure/api-management/authentication-authorization-overview).
1. Microsoft Entra ID is validated from PowerApps.
1. Utilize Azure monitoring for the application and all of the components which make up this solution.  This could also include Azure Alerting for notification.
1. Utilize Azure Site Recovery (ASR) / Azure high availbity for all application components on the left side of the diagram.

Access mainframe applications through Azure by:

- Signing in to Microsoft Entra ID (step 6 in the image), which provides access to the client application. The client applications also communicate with Microsoft Entra ID for authentication and authorization of access to resources.
- Accessing client applications such as Power Apps or a custom web app (step 7 in the image), which then access the mainframe applications through REST API access to IBM Z and Cloud Modernization Stack.

The steps taken by IT staff to monitor the system with Azure tools and implement disaster recovery measures by using Azure Site Recovery include:

- Deploy new or enhanced applications (step 7 in the image) to consume the REST API interfaces exposed through API Management.
- Use Azure Application Monitor and Application Insights (step 8 in the image) to monitor Power Platform, the application APIs, and security.
- Use Azure Site Recovery for disaster recovery (step 9 in the image).

## Components

- [Red Hat OpenShift](https://www.redhat.com/en/technologies/cloud-computing/openshift) reduces the friction of developing, modernizing, deploying, running, and managing applications. Red Hat OpenShift delivers a consistent experience across public cloud, on-premises, hybrid cloud, and edge architectures.

- [IBM Z and Cloud Modernization Stack](https://www.ibm.com/products/z-and-cloud-modernization-stack) provides simple and more secure access to mainframe applications and data through APIs. You can use modern [DevOps for IBM Z](https://www.ibm.com/z/devops) with industry-standard tooling and modern languages that expand your talent pool.

- [IBM z/OS Connect](https://www.ibm.com/products/zos-connect) is a middleware solution that provides more secure connectivity between cloud-native applications and IBM z/OS systems. It enables organizations to integrate and use data and services residing on the mainframe, while also embracing modern technologies and Open standards.

- [Azure API Management](/azure/api-management/api-management-key-concepts) provides a hybrid, multicloud management platform for APIs across all environments. APIs enable digital experiences, simplify application integration, underpin new digital products, and make data and services reusable and accessible.

- [Azure App Service](/azure/well-architected/service-guides/app-service-web-apps) is a fully managed platform for building, deploying, and scaling web apps. It supports various programming languages and frameworks, offering seamless integration with Azure services. App Service provides autoscaling and high availability, simplifying app deployment and management. [Visual Studio](/visualstudio/get-started/visual-studio-ide) is an integrated development environment (IDE) that you can use to write, edit, debug, and build code, and then deploy your web app.

- [Microsoft Power Platform](/power-platform) increases agility across your organization by allowing you to rapidly implement low-code application development on Azure to modernize processes and solve challenges.

- [Azure Monitor](/azure/azure-monitor/overview) helps maximize the availability and performance of applications and services. It delivers a comprehensive solution for collecting, analyzing, and acting on information from cloud and on-premises environments. This information helps you identify issues and understand how your applications are performing.

- [Azure ExpressRoute](/azure/well-architected/service-guides/azure-expressroute) extends on-premises networks into the Microsoft cloud over a private connection facilitated by a connectivity provider. With ExpressRoute, you can establish connections to Microsoft cloud services, such as Microsoft Azure and Office 365.

- [Azure Site Recovery](/azure/site-recovery/site-recovery-overview) is a disaster recovery solution that helps protect and recover applications and workloads running on virtual or physical machines. It provides business continuity and minimizes downtime during planned or unplanned outages.

## Alternatives

In place of ExpressRoute gateway, you can use the Azure VPN Gateway. The virtual network gateway enables more secure site-to-site connectivity, connecting an on-premises network to Azure virtual network through encrypted tunnels. For more information, see [What is Azure VPN Gateway?](/azure/vpn-gateway/vpn-gateway-about-vpngateways)

## Scenario details

IBM Z and Cloud Modernization Stack and z/OS Connect are easily deployed on Azure via Azure Marketplace or Azure Resource Manager templates. When you use this solution, you can build REST APIs for z/OS applications and data while adhering to OpenAPI standards. This approach allows you to scale business-critical application programming interfaces (APIs) and take advantage of the strengths of IBM Z. Seamless integration with API management solutions like [Azure API Management](https://azure.microsoft.com/en-us/products/api-management/) ensures effective API governance. You can integrate APIs with web applications or Microsoft Power Platform for efficient data exchange and integration.

[z/OS Connect Designer](https://www.ibm.com/docs/en/cloud-paks/z-modernization-stack/2023.2?topic=concepts-what-is-zos-connect-designer) features an intuitive web user interface that provides a low-code approach, built specifically to create APIs for IBM Z. This graphical interface shortens development time and the learning curve for new developers who use z/OS Connect.

[Azure API Management](https://azure.microsoft.com/products/api-management/) is a fully managed service that helps organizations to publish, secure, and manage APIs for their applications. It provides a comprehensive set of tools and features to create, monitor, and control the lifecycle of APIs.

[Microsoft Power Platform](https://www.microsoft.com/power-platform) Power Apps is a low-code or no-code option to create a web-based user interface that connects to the previously mentioned developed services. This architecture illustrates both a low-code Power Apps client and a custom web app client.

## Potential use cases

Benefits from using REST APIs to access mainframe applications include:

- *Frontend applications*: Front-end applications written in Java, Java EE, .NET Framework, and C and C++ can use REST APIs for mainframe applications. These applications can share business logic and units of work with back-end Customer Information Control System (CICS) applications developed in COBOL, PL/I, and other languages. This integration allows for communication between the front-end and back-end systems for efficient data exchange and processing.

- *Hybrid solutions with citizen developers*: REST APIs in mainframe applications help citizen developers within enterprises build hybrid solutions. Citizen developers can use mainframe APIs and other APIs available within their organization to create innovative applications and integrations. This democratization of API access allows for faster development cycles and promotes collaboration between different teams.

REST APIs in mainframe applications offer opportunities for modernization and expansion while preserving the essential business logic and data integrity of the mainframe systems. REST APIs in mainframe applications support an array of front-end technologies and empower citizen developers.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the Reliability pillar](/azure/well-architected/reliability).

- [Red Hat OpenShift Container Platform](https://www.redhat.com/en/technologies/cloud-computing/openshift) provides automated deployment capabilities that help ensure your applications are deployed consistently and reliably.

- Reliability is a fundamental pillar of IBM z/OS Connect. It's engineered to manage high-transaction volumes and handle many concurrent connections. The solution's scalability extends both horizontally and vertically, enabling it to accommodate the evolving demands of expanding workloads.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the Security pillar](/azure/well-architected/security).

- Microsoft Entra ID provides a variety of security features and capabilities to help you protect identities, applications, and data. It also provides authentication and authorization of users and applications. The integration of Microsoft Entra ID with OAuth enables more secure authentication and authorization for applications.

- IBM zSystems provides robust security capabilities for DevSecOps to mitigate business risks, safeguard application data, and help you ensure long-term security for your systems.

### Cost Optimization

Cost Optimization reduces unnecessary expenses and improves operational efficiencies. For more information, see [Overview of the Cost Optimization pillar](/azure/well-architected/cost-optimization).

- IBM Z and Cloud Modernization Stack and Azure DevOps reduce the need for custom z/OS tooling by allowing organizations to implement the same CI/CD toolchain and practices as the rest of their enterprise.

- Azure provides various licensing options for the Power Apps platform, which are managed depending on the total number of users, allowed sign-ins, and page views.

Use the [Pricing calculator](https://azure.microsoft.com/en-us/pricing/calculator/) to estimate the cost of implementing your solution.

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the Operational Excellence pillar](/azure/well-architected/operational-excellence).

- [IBM z/OS Connect](https://www.ibm.com/products/zos-connect) facilitates access to backend application functions, converting them into microservices with accessible APIs. IBM z/OS Connect enables other applications to interact at scale with these services while also providing API management and monitoring capabilities.

- [Red Hat OpenShift Container Platform](https://www.redhat.com/en/technologies/cloud-computing/openshift/container-platform) streamlines deployment processes, bolsters scalability, fortifies security measures, offers robust monitoring capabilities, facilitates continuous integration and delivery, and integrates with existing operational tools and processes.

### Performance Efficiency

Performance Efficiency covers the operations processes that deploy an application and keep it in production. For more information, see [Overview of the Performance Efficiency pillar](/azure/well-architected/performance-efficiency).

- z/OS Connect handles multiple API requests concurrently by using the parallel processing capabilities of IBM Z. This parallel execution enhances performance by using system resources and reducing response times for API calls.
- Performance efficiency is a core strength of IBM z/OS Connect. It handles high transaction volumes and manages concurrent connections. The solution's scalability expands both horizontally and vertically, allowing it to adapt to the evolving demands of workloads.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Bhaskar Bandam](https://www.linkedin.com/in/bhaskar-bandam-75202a9) | Senior Technical Program Manager
- [Ivan Dovgan](https://www.linkedin.com/in/ivandov) | Chief Architect

Other contributors:

- [Jim Dugan](https://www.linkedin.com/in/jdugan1) | Principal Technical Program Manager
- Madhu Ananthapadmanabh | Z Hybrid Cloud Integration solution architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

For more information, contact [legacy2azure@microsoft.com](mailto:legacy2azure@microsoft.com).

- [Azure DevOps Services](https://azure.microsoft.com/products/devops)
- [IBM Z and Cloud Modernization Stack](https://www.ibm.com/products/z-and-cloud-modernization-stack)
- [Technical White Paper on Azure DevOps for z Systems](https://www.ibm.com/support/pages/system/files/inline-files/Azure-DBB%20Integration%20v2g.pdf)
- [Microsoft Power Platform](https://www.microsoft.com/power-platform)
