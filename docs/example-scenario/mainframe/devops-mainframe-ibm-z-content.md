Azure DevOps can help you develop and modernize your z/OS applications that use IBM Z and Cloud Modernization Stack. Doing so can result in increased agility and enable developers to work faster and more pruductively. You can modify your existing COBOL, PL/I, Java, or assembler programs by using any integrated development environment (IDE). And you can take advantage of the benefits of programming languages like Python, Node.js, and Go, which can run on z/OS. This approach enables you to easily adapt to new languages while still retaining the flexibility to work with preferred IDEs.

The Azure DevOps Git-based code repository and agent-based Azure pipelines can integrate with IBM Dependency Based Build (DBB) solutions on IBM zSystems for mainframe application development and build processes. DBB, available through the Wazi Code component of IBM Z and Cloud Modernization Stack, complements Azure DevOps by providing intelligent build, link, and edit capabilities. The combination enables developers working on large, complex applications to develop, build, and deliver in an agile manner.

## Azure DevOps

Azure DevOps provides developer services to help teams plan work, collaborate on code development, and build and deploy applications. Developers can work in the cloud by using Azure DevOps Services or on-premises by using Azure DevOps Server. (Azure DevOps Services was previously known as Visual Studio Team Services.)  

Azure DevOps provides integrated features that you can access through your web browser or IDE client. You can use one or more of the following services, dependig on your business needs: 

- [Azure Repos](https://azure.microsoft.com/products/devops/repos) provides Git repositories or Team Foundation Version Control for source control of your code.
- [Azure Pipelines](https://azure.microsoft.com/products/devops/pipelines/) provides build and release services to support continuous integration and continuous delivery (CI/CD) of your apps.
- [Azure Boards](https://azure.microsoft.com/products/devops/boards/) provides a suite of Agile tools to support planning and tracking of work, code defects, and problems by using Kanban and Scrum methods.
- [Azure Test Plans](https://azure.microsoft.com/products/devops/test-plans/) provides tools to test your apps, including manual/exploratory testing and continuous testing.  
- [Azure Artifacts](https://azure.microsoft.com/products/devops/artifacts/) enables teams to share Maven, npm, and NuGet packages from public and private sources and integrate package sharing into CI/CD pipelines. By using Azure Artifacts to manage COBOL files, you can ensure that all developers in your organization have access to the correct versions of files and their dependencies.

## Azure DevOps architecture for z/OS

The purpose of this architecture is to help you get started with building Azure DevOps pipelines that run Git-based IBM DBBs on z/OS. Although Azure DevOps is primarily used by distributed applications, many organizations are looking for consolidated solutions that integrate with modern IBM mainframe development workflows. 

You can use Azure Boards, which is independent of platform, to manage mainframe-based sprints. Azure DevOps runs CI pipelines that can construct and deploy mainframe applications that run either in batch or online mode, with or without Db2 and MQ. 

By integrating [IBM UrbanCode Deploy](https://www.ibm.com/docs/en/urbancode-deploy/7.1.1?topic=overview-urbancode-deploy) into Azure pipelines, you can get a comprehensive CI/CD pipeline for on-premises, cloud, or hybrid platforms that encompasses z/OS applications. The IBM Z and Cloud Modernization Stack includes various capabilities to modernize mainframe applications, based on the Red Hat OpenShift platform. For development and test purposes, IBM Wazi includes Wazi Code (IDEs, DBB), Wazi Analyze, and Wazi Sandbox, which together provide mainframe developers with a cloud-native experience that doesn't require application installation.

:::image type="content" source="media/devops-mainframe-ibm-stack.png" alt-text="Diagram that shows an architecture for integrating Azure DevOps into IBM z/OS applications." lightbox="media/devops-mainframe-ibm-stack.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/devops-mainframe-ibm-stack.vsdx) of this architecture.*

### Workflow

1. The z/OS application source code is migrated into a Git-based source code management (SCM) system. 
1. Azure Boards streamlines work item creation, assignment, status monitoring, and progress tracking.  
1. Wazi Code simplifies the development of mainframe applications.  
1. Wazi Analyze can be used for code analysis and dependency resolution.
1. Unit testing of code changes can be tested manually against a developer-owned Wazi Sandbox environment.  
1. Code changes are committed back to the Git repository from the web-based IDE. 
1. Code changes pushed to the repository trigger a build via Azure Pipelines.   
1. Automated builds, deployments, and tests are run against a containerized z/OS environment within the Wazi Sandbox. 
1. In Azure Artifacts, successful builds are systematically stored to provide a reliable and centralized repository for versioned artifacts.  
1. Production release scenarios follow a typical Git-based release automation process, starting with branching/tagging Git commits to be used in production.  
1. When automation is triggered on release branches or tags, it initiates production deployment based on change management guidelines and the approval process in your on-premises z/OS environments located within their datacenter.

### Components

- [Azure DevOps](https://azure.microsoft.com/products/devops) – Azure DevOps provides developer services to support teams to plan work, collaborate on code development, and build and deploy applications. Developers can work in the cloud using Azure DevOps Services or on-premises using Azure DevOps Server. Azure DevOps Server was formerly known as Visual Studio Team Foundation Server (TFS).  
- [IBM Z and Cloud Modernization Stack](https://www.ibm.com/products/z-and-cloud-modernization-stack) - Provide simple and highly secure access to mainframe applications and data through APIs in minutes. Embrace modern enterprise DevOps with industry-standard tooling and modern languages that expands your talent pool.   
- The [Wazi components](https://www.ibm.com/docs/en/cloud-paks/z-modernization-stack/2022.3?topic=overview-whats-in-z-cloud-modernization-stack) available in IBM Z and Cloud Modernization Stack provide modern experiences for analyzing, developing, and testing mainframe applications in an isolated way, implementing the DevOps philosophy for developers to gain speed and flexibility. 
- [Red Hat OpenShift Container Platform](https://www.redhat.com/en/technologies/cloud-computing/openshift) - Red Hat OpenShift brings together tested and trusted services to reduce the friction of developing, modernizing, deploying, running, and managing applications. Built on Kubernetes, it delivers a consistent experience across public cloud, on-premise, hybrid cloud, or edge architecture. 
- [Azure Virtual Networks](https://docs.microsoft.com/azure/virtual-network/virtual-networks-overview) - Azure Virtual Network (VNet) is the fundamental building block for your private network in Azure. VNet enables many types of Azure resources, such as Azure Virtual Machines (VM), to securely communicate with each other, the internet, and on-premises networks. VNet is similar to a traditional network that you'd operate in your own data center but brings with it additional benefits of Azure's infrastructure such as scale, availability, and isolation. 
- [Azure ExpressRoute](https://docs.microsoft.com/azure/expressroute/expressroute-introduction) - ExpressRoute lets you extend your on-premises networks into the Microsoft cloud over a private connection facilitated by a connectivity provider. With ExpressRoute, you can establish connections to Microsoft cloud services, such as Microsoft Azure and Office 365. 

### Alternatives

- [Virtual Private Network (VPN) Gateway](https://azure.microsoft.com/products/vpn-gateway): A VPN Gateway can be used to securely connect on-premises networks to Azure over the public internet using an encrypted connection. This can provide a secure and cost-effective option for organizations that do not require the high bandwidth and low latency of ExpressRoute.

## Scenario details

- Wazi Code provides an in-browser integrated developer environment (IDE) that you can use to code, build, and debug Cobol, PL/1, Assembler, Java, REXX, and JCL applications. With this approach, you can easily modify mainframe applications while taking advantage of new programming languages including Python, Node.js, and Go that can all run on IBM z/OS.  
- [DevOps for zSystems](https://www.ibm.com/z/devops) integrated with [Azure DevOps](https://azure.microsoft.com/products/devops/) (git-based code repository and pipelines) solutions span Azure services and z/OS environments to orchestrate the development, integration, and deployment of applications across IBM zSystems and Azure. 
- IBM zSystems development organizations are no longer siloed in terms of tools or processes. Adopting ADO and adapting to IBM Dependency Based Build blends mainframe repositories into a single source code repository across technology stacks, and an integrated change management and  approval process with synergies around auditing, reporting as well across the enterprise.
- Solutions from Azure and IBM enable organizations to free themselves from the restrictions and increasing costs of legacy tools to focus on effective project management. IBM and Azure drive and accelerate transformations to the hybrid cloud, so Z organizations can deliver solutions quickly and efficiently.

### Potential use cases  

Many scenarios can benefit from the Azure DevOps for mainframe applications. Possibilities include the following cases:  

- Customer can achieve an end-to-end CI/CD pipeline for their on-prem, cloud or hybrid platform that includes z/OS applications. 
- Mainframe teams work in parallel with the enterprise’s distributed development teams and follow a single standard and common tooling for DevOps and SDLC across the enterprise.  
- Provide consistent and familiar developer experience for z/OS applications along with flexible dev & test infrastructure on Azure. 
- Accelerating application development and development lifecycles of mainframe applications

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability 

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](https://learn.microsoft.com/azure/architecture/framework/resiliency/overview). 

- Azure DevOps provides CI/CD pipelines that allow you to automate the build, testing, and deployment of your application. This helps ensure that your application is always up-to-date and reliable. 
- Azure DevOps provides collaboration tools that allow your team to work together effectively. This can help improve the reliability of your application by ensuring that everyone is working towards a common goal. 
- RedHat OpenShift Container Platform (OCP) provides automated deployment capabilities, which can help ensure that your applications are deployed consistently and reliably. 
- Application developers lower the risk in code changes across the application development lifecycle when using a standard and consistent approach to building, testing, and deploying applications across Azure and IBM zSystems. 
- Azure DevOps and IBM Z and Cloud Modernization Stack enables application modernization with fit for purpose workload placement across the environments, reducing risk involved in full migration scenarios. 

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](https://learn.microsoft.com/azure/architecture/framework/security/overview).

- Azure DevOps allows you to control access to your resources and data using role-based access control (RBAC). This helps ensure that only authorized users can access your resources. For more information, see [security best practices](/azure/devops/organizations/security/security-best-practices?view=azure-devops).  
- Azure DevOps integrates with Azure Security Center, which provides additional security insights and recommendations. This can help you identify potential security issues and take steps to address them. 
- Enhance and extend your current DevSecOps practices by leveraging the robust security capabilities of IBM zSystems. By doing so, you can effectively mitigate business risks, safeguard application data, and ensure long-term security for your systems. 

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview). 

- Azure DevOps provides automation capabilities that help you reduce the time and effort required for manual tasks. By automating tasks, you can optimize costs and improve efficiency. 
- Azure DevOps integrates with other Azure services, such as Azure Monitor and Azure Advisor, which can help you optimize costs by providing insights into resource usage and recommendations for cost optimization. Use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator/) to estimate the cost of implementing the solution. 
- IBM Z and Cloud Modernization Stack and Azure DevOps reduce the need for bespoke z/OS tooling by allowing organizations to implement the same CI/CD toolchain and practices as the rest of their enterprise. 

### Operational excellence 

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

- Azure DevOps is a powerful platform that provides a comprehensive set of tools for managing the entire software development lifecycle. When used in conjunction with Azure, it can help organizations achieve operational excellence by streamlining their development and deployment processes, improving collaboration, and ensuring that applications are delivered quickly and reliably. Overall, by leveraging the power of Azure DevOps, organizations can achieve operational excellence by improving collaboration, automating key tasks, monitoring performance, and streamlining the software development and deployment process. 
- Wazi Sandbox, a personal z/OS environment can be provisioned on Azure, with all of the required z/OS resources (IMS and CICS, for example) for developers to work in isolation, execute initial builds, and conduct early tests to verify the correct execution after code changes.

## Performance efficiency 

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

- Ensure performance and stability of multi-tenant integration test environments by leveraging isolated Wazi Sandbox instances to perform build and test operations earlier in the software development lifecycle.  
- Azure DevOps is a comprehensive set of tools and services that can help organizations improve their performance efficiency in several ways. Azure DevOps provides a robust CI/CD pipeline that can help automate the build, test, and deployment process. This can help reduce the time required to deploy new features and bug fixes, improve the overall quality of the application, and reduce the risk of errors during deployment.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal authors:
- [Bhaskar Bandam](https://www.linkedin.com/in/bhaskar-bandam-75202a9/) | Transformation Specialist 
- [Ivan Dovgan](https://www.linkedin.com/in/ivandov/) | Senior Software Architect 
- [Bhuvi Vatsey](https://www.linkedin.com/in/bvatsey/) | Modernization Specialist 

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

For more information, contact legacy2azure@microsoft.com 

- Azure DevOps documentation 
- IBM Z and Cloud Modernization Stack 
- Technical White Paper on Azure DevOps for z Systems - [Azure-DBB Integration v2g.pdf (ibm.com)]()  

## Related resources 
