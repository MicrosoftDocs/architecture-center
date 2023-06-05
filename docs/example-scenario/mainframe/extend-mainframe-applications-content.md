This architecture shows how legacy mainframe and midrange terminal-based applications (such as TN-3270) and data can be extended to Azure without any changes to the existing mainframe and midrange application landscape. There are multiple ways in which this scenario can be achieved. The solution discussed in this article uses Azure services like Kubernetes service (AKS), platforms like Power Platform, and Micro Focus Verastream Host Integrator (VHI).

## Legacy IBM z/OS architecture

:::image type="content" source="media/extend-mainframe-source-zos-architecture.png" alt-text="Diagram that shows the mainframe architecture before extending to Azure." lightbox="media/extend-mainframe-source-zos-architecture.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/extend-mainframe-applications-to-azure-architecture.vsdx) of this architecture.*

### Workflow

1. Data is input over TCP/IP, including TN3270 and HTTP(S).

1. Data is input into the mainframe via standard mainframe protocols.

1. Receiving applications can be either batch or online systems.

1. Business applications written in COBOL, PL/I, or Assembler (or compatible languages) run in environments enabled for batch and online.

1. Data and database services commonly used are hierarchical and network database systems, data files, and relational database types enabled within the environment.

1. Common services enabled include program execution, I/O operations, error detection, and protection within the environment.

1. Middleware and utility services manage services like tape storage, queueing, output, and web services within the environment.

1. Operating systems provide the specific interface between the engine and the software it's running.

1. The partitions used are needed to run separate workloads or to segregate work types within the environment.

## Mainframe architecture extended to Azure

:::image type="content" source="media/extend-mainframe-architecture-to-azure.png" alt-text="Diagram that shows the mainframe architecture after extending to Azure." lightbox="media/extend-mainframe-architecture-to-azure.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/extend-mainframe-applications-to-azure-architecture.vsdx) of this architecture.*

### Workflow

The following workflow corresponds to the preceding diagram:

1. Data is typically input from users, either from the internet or an intranet.

1. User access to the application is now enabled via a web-based presentation layer with the help of an application created with Power Apps, and validation is integrated with Azure Active Directory for a seamless sign-on experience. If validated, the user can access a specific Power Apps when they sign in to the Power Platform. User access is enabled using the Mainframe ID and password, which is validated against the mainframe with Verastream. (The 2b and 3b flow is an [alternative](#alternatives) workflow addressed later in this article.)

1. Application functionality is enabled by defining custom connectors. The custom connector definitions contain the corresponding Verastream APIs configured in Verastream Host Integrator software.

1. (Optional) Azure API Management. (For more information, see [Alternatives](#alternatives).)

1. Traffic is distributed evenly across multiple runtime servers with the help of a load balancer. The workload is dynamically balanced for optimal performance under high transaction volumes.

1. You can deploy and configure the VHI Server software by using one of these options:

   - Azure VMs (Windows or Linux)

   - VHI Session server in Linux containers (to be managed later by AKS)

   Multiple runtime environments help with workload management and also help provide failover protection. For example, when a service outage occurs on any runtime server, the remaining servers automatically provide uninterrupted failover protection. The Verastream management console provides an interface to manage the extended server environment. It lets administrators remotely configure, deploy, and monitor resources. Users and groups from the directory server can be added to the Administrator, Developer, and User authorization profiles. You can use Azure VM bastion hosts to provide admin access to the VMs, which improves security by minimizing open ports.

1. Verastream services that run on the Azure Virtual Machines or Linux Docker containers (to be managed later by AKS) will then connect to the on-premises Mainframe Transaction Processing Application over TN3270 protocol with SSL/TLS. RACF, Top Secret, and ACF2-based protocols will continue to be used for host access, which is facilitated by Azure ExpressRoute.

1. Azure Application Monitor and Application Insights can be used to monitor Power Platform, the application APIs, Verastream services, session pools, and security. Verastream comes with a fully configurable ability to view and report all pertinent information to third-party SNMP or JMX management tools, which can be used by Azure Monitor and Azure Application Insights.

1. Azure Site Recovery is used for disaster recovery of the VMs.

### Components

- [Power Platform](https://powerplatform.microsoft.com) increases agility across your organization by helping you build low-code apps that modernize processes and solve tough challenges.

- [Azure API Management](https://azure.microsoft.com/services/api-management) provides a hybrid, multicloud management platform for APIs across all environments. APIs enable digital experiences, simplify application integration, underpin new digital products, and make data and services reusable and universally accessible.

- [Azure Monitor](https://azure.microsoft.com/services/monitor) helps maximize the availability and performance of your applications and services. It's a comprehensive solution for collecting, analyzing, and acting on customer data from your cloud and on-premises environments. This information helps you understand how your applications perform and proactively identify issues that affect them and the resources they depend on.

- [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines) is one of several Azure services that provide on-demand, scalable computing resources. With Azure VMs, you get the flexibility of virtualization without having to buy and maintain physical hardware.

- [Microsoft Azure Virtual Network](https://azure.microsoft.com/services/virtual-network) is the fundamental building block for Azure private networks. Virtual Network lets many types of Azure resources, such as VMs, communicate with each other, the internet, and on-premises networks. Virtual Network is similar to a traditional network that you'd operate in your own datacenter but offers Azure infrastructure benefits like scalability, availability, and isolation.

- [Azure ExpressRoute](https://azure.microsoft.com/services/expressroute) extends an on-premises network into Microsoft cloud services over a private connection, facilitated by a connectivity provider. With ExpressRoute, you can establish connections to Microsoft cloud services, such as Microsoft Azure and Office 365.

- [Azure Kubernetes Service (AKS)](https://azure.microsoft.com/services/kubernetes-service) simplifies deploying managed Kubernetes clusters in Azure by offloading the operational overhead to Azure. AKS helps you deploy and manage the containerized components in this architecture, including your custom-made web UI applications. Because Kubernetes masters are managed by Azure, you only manage and maintain the agent nodes.

### Alternatives

- (2b in the [previous image](#mainframe-architecture-extended-to-azure).) As an alternative to Power Apps, which is a low-code or no-code option, you can develop a custom-made web UI application with programming languages like C#, Angular JS, or Java using IDEs like Visual Studio or Eclipse.

- (3b in the [previous image](#mainframe-architecture-extended-to-azure).) These UI applications can be deployed on AKS and App Service Environments as well. These applications can then either directly connect to the APIs hosted on the Verastream Host Integrator runtime environments or connect via the Azure API Management.

- (4 in the [previous image](#mainframe-architecture-extended-to-azure).) Azure API Management (optional) lets you publish the Verastream services as APIs and manage them with policies. Doing so helps control the number of incoming calls, direct traffic, and set usage quotas at different levels. This method is an alternative to directly connecting to the services running on Verastream Host Integrator runtime environments.

## Scenario details

As part of Power Platform, Power Apps is an intuitive, collaborative, and extensible platform of low-code tools that makes it easy to create efficient and flexible solutions. With Power Apps, production-ready apps with less code can be created with custom connectors or out-of-the-box connectors.

Micro Focus' VHI is a powerful integration platform that simplifies mainframe and host-based application functionality into a component form, web-service, such as RESTful and SOAP-based web services. It then deploys them natively on an Azure VM (Windows or Linux), or via a Linux Docker container runtime environment (Verastream Host Integrator).

:::image type="content" source="media/extend-mainframe-vhi-design-tool.png" alt-text="Diagram that shows the Verastream Host Integrator UI." lightbox="media/extend-mainframe-vhi-design-tool.png" border="false":::

This architecture is focused on extending a COBOL-CICS screen application workload to the Azure platform by using two approaches:

- Verastream Host Integrator and Azure Power Apps (low-code or no-code approach)

- Verastream Host Integrator and Visual Studio or Eclipse IDEs for developing a web-based UI and deploying the application natively on Azure using App Service Environments or Kubernetes service

This integration doesn't require any changes in the mainframe or midrange platform.

End users can now access the same business functionality that was originally available using mainframe and midrange terminals from outside the mainframe and midrange environment, such as from a mobile or desktop screen using web browsers.

Power Platform Power Apps offers a low-code or no-code option to create a web-based UI that will in turn connect to the above developed services.

This solution is essentially a no-changes-needed approach with respect to the application on mainframe and midrange environments because Verastream services integrate to the existing mainframe and midrange-based application over TN3270 protocols, similar to how a business user would.

### Potential use cases

Many scenarios can benefit from the extend-to-Azure architecture, including these use cases:

- Enable direct access to legacy applications through smartphones and tablets via web browsers for users in the field to improve productivity.
- Maintain a competitive edge by expanding your user base and offering to the entire internet instead of just call center users.
- Automate workflows between applications, implementing seamless business processes without making changes to existing legacy applications.
- Enable automated application testing. VHI can use encapsulated application business logic as reusable services to support continuous integration and continuous deployment (CI/CD) practices that respond to ever-growing business demands to deliver applications on time, with minimal bugs.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

- You can deploy this architecture in multiple regions.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

- Use single sign-on to access the Power Platform by using Azure Active Directory and authentication via LDAP, which is supported by VHI. Any host-based security implementations (such as RACF, TopSecret, or ACF-2) remain fully active.
- VHI accommodates end-to-end security using TLS and SSH. Host-to-server and server-to-client communications can be secured. Public key cryptography helps protect all data passed between client web applications and the Verastream runtime server. FIPS-validated crypto libraries enhance compliance with data-protection guidelines defined by the U.S. National Institute of Standards and Technology. While a requirement for many government IT systems, these security standards benefit private-sector organizations as well.
- This solution uses an Azure network security group (NSG) to manage traffic between Azure resources. For more information, see [Network security groups](/azure/virtual-network/network-security-groups-overview).
- [Azure Bastion](/azure/bastion/bastion-overview) maximizes admin access security by minimizing open ports. Bastion provides secure and seamless RDP/SSH connectivity to virtual network VMs directly from the Azure portal over TLS.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

- Azure provides cost optimization by running on Windows VMs or Linux containers (to be managed later by AKS). Doing so lets you shut down the VMs or containers when they're not in use and script a schedule for known usage patterns. Azure focuses on avoiding unnecessary costs by identifying the right number or resource types, analyzing spend over time, and scaling to meet business needs without overspending.
- For compute, use [Azure Reservations](/azure/cost-management-billing/reservations/save-compute-costs-reservations) and [Azure savings plan for compute](https://azure.microsoft.com/pricing/offers/savings-plan-compute/#benefits-and-features) with a one-year or three-year contract and receive significant savings off pay-as-you-go prices. In many cases, you can further reduce your costs with reserved instance size flexibility.
- Azure provides various licensing options for the Power Apps platform as well, which can be controlled and managed with respect to the total number of users, sign-ins that are allowed, and page views.

Use [Azure Pricing Calculator](https://azure.microsoft.com/pricing/calculator) to estimate the cost of implementing the solution.

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

- With the extend-target architecture, you have full flexibility with your deployment options in development and production. This transformation supports both the immediate adoption of the cloud and the adoption of both DevOps and Agile working principles.
- Holistic Monitoring in Azure Monitor can be plugged in to get full observability across the integrated solution. As part of the Azure Monitor suite, Azure Application Insights is recommended due to its direct integration capabilities to monitor Power Apps, the VMs and Linux containers using Docker on Azure and for the services, VHI session pools, and security. The Verastream Management console provides an interface to configure the reporting of pertinent information to Azure Monitor.

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

- Performance efficiency is built into this solution because of the load balancers. When multiple runtime servers are deployed, the workload is dynamically balanced for optimal performance under high-transaction volumes. If a service outage occurs on any runtime server, the remaining servers automatically provide uninterrupted failover protection.
- At the VHI level, the platform manages sessions using session pooling and emphasis on a low ratio of sessions to users. Verastream scales seamlessly across multiple runtime servers to deliver rapid response and 24/7 reliability.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Jim Dugan](https://www.linkedin.com/in/jdugan1/) | Principal TPM
- [Venkat Ramakrishnan](https://www.linkedin.com/in/venkataramanr/) | Senior TPM

Other contributor:

- [Bhaskar Bandam](https://www.linkedin.com/in/bhaskar-bandam-75202a9) | Senior TPM

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Verastream Host Integrator | Micro Focus](https://www.microfocus.com/en-us/products/verastream-host-integrator/overview)
- [VHI data sheet](https://www.microfocus.com/pnx/media/data-sheet/verastream_host_integrator_data_sheet.pdf)
- [Power Platform](https://powerplatform.microsoft.com)
- [Azure Kubernetes Service documentation](/azure/aks)
- [Virtual machines in Azure](/azure/virtual-machines/overview)
- [What is Azure Virtual Network?](/azure/virtual-network/virtual-networks-overview)
- [Azure Monitor](https://azure.microsoft.com/services/monitor)

For more information, contact [legacy2azure@microsoft.com](mailto:legacy2azure@microsoft.com).

## Related resources

- [General mainframe refactor to Azure](general-mainframe-refactor.yml)
- [Azure mainframe and midrange architecture design](../../mainframe/mainframe-midrange-architecture.md)
- [Make the switch from mainframes to Azure](/azure/cloud-adoption-framework/infrastructure/mainframe-migration/migration-strategies)
