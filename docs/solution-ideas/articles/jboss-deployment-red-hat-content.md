[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Red Hat and Microsoft partnered to create a comprehensive and secure infrastructure on Azure. It's an open source project that Red Hat continually enhances to support versatile and seamless team workflows, on-premises and in the cloud. It can be fully managed or self-managed.

_The Red Hat logos are trademarks of Red Hat, Inc. No endorsement is implied by the use of these marks._

## Potential use cases

JBoss EAP is suitable for these uses:

- Modernizing existing applications
- Developing new cloud-native applications
- Integrating applications for data management and analytics
- Integrating software from independent software vendors and cloud providers

## Architecture

:::image type="content" source="../media/jboss-deployment-red-hat.png" alt-text="Architecture to implement the Red Hat JBoss Enterprise Application Platform (JBoss EAP) on Azure." lightbox="../media/jboss-deployment-red-hat.png":::

*Download a [Visio file](https://arch-center.azureedge.net/jboss-deployment-red-hat.vsdx) of this architecture.*

### Dataflow

- Development Flow

  With multiple options available for deploying and upgrading applications and microservices that run in ARO, development teams can choose the process flow that works best for them. The options include:

  - Have ARO pull from an Azure Container Registry OCI distribution instance  that houses container images created in an external continuous integration and continuous delivery (CI/CD) pipeline.
  - Run Helm charts, which give directions on application deployment and dependencies.
  - Use ARO capabilities, such as build-to-deploy CI/CD pipelines that include GitOps capabilities.

- Administration Flow

  A site reliability engineering (SRE) team monitors the health of all the components that underpin the ARO cluster.  Administrators can focus on optimizing the performance and data flow for application users. You can consolidate measurements by using Azure Monitor or a third party monitoring solution that supports Azure and ARO.

- Application Data Flow

  Client requests originate from outside the application and pass through Microsoft Azure Load Balancer before entering the ARO cluster. Once a request enters the ARO cluster through the ingress gateway, it's sent to the appropriate application service and then given to an individual instance for processing. The application instance can authenticate by using Azure Active Directory. It can also access secrets stored by Azure Key Vault to get the credentials it needs to connect to external services or data stores like Azure Cosmos DB. When processing is finished, the response is passed back to the requesting client.

### Components

- [Azure Active Directory (Azure AD)](https://azure.microsoft.com/services/active-directory) is a multi-tenant identity and access management service that can synchronize with an on-premises directory.
- [Azure App Service](https://azure.microsoft.com/services/app-service) is a fully managed service for building, deploying, and scaling web apps. You can build apps using .NET, .NET Core, Node.js, Java, Python, or PHP. Apps can run in containers or on Windows or Linux. In a mainframe migration, the front-end screens or web interface can be coded as HTTP-based REST APIs. They can be segregated and can be stateless to orchestrate a microservices-based system. For more information on web APIs, see [RESTful web API design](../../best-practices/api-design.md).
- [Azure Container Registry](https://azure.microsoft.com/services/container-registry) can build, store, and manage container images and artifacts for all types of container deployments.
- [Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db) is a globally distributed, multi-model database that enables your solutions to elastically and independently scale throughput and storage across any number of geographic regions. It offers comprehensive service level agreements (SLAs) to guarantee throughput, latency, availability, and consistency.
- [Azure Key Vault](https://azure.microsoft.com/services/key-vault) safeguards cryptographic keys, passwords, and other secrets that Azure and third-party apps and services use.
- [Azure Load Balancer](https://azure.microsoft.com/services/load-balancer) is a layer 4 (TCP, UDP) load balancer. For more information, see [What is Azure Load Balancer?](/azure/load-balancer/load-balancer-overview)
- [Azure Monitor](https://azure.microsoft.com/services/monitor) collects, analyzes, and acts on telemetry from your Azure and on-premises environments.
- [Azure Pipelines](https://azure.microsoft.com/services/devops/pipelines) automatically builds and tests code projects. It combines continuous integration (CI) and continuous delivery (CD). By using these practices, Azure Pipelines constantly and consistently tests and builds code and ships it to any target. For more information, see [What is Azure Pipelines?](/azure/devops/pipelines/get-started/what-is-azure-pipelines)
- [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines) VMs are on-demand, scalable computing resources that give you the flexibility of virtualization but eliminate the maintenance demands of physical hardware. The operating system choices include Windows and Linux.
- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network) is a secure private network in the cloud. It connects VMs to one another, to the internet, and to on-premises networks.
- [Red Hat on Azure](https://azure.microsoft.com/overview/linux-on-azure/red-hat) is a set of secure, reliable, flexible hybrid cloud environments on Azure, supported by a global user support service from Azure and Red Hat. The environments include [Azure Red Hat OpenShift](https://azure.microsoft.com/services/openshift) and [Red Hat JBoss Enterprise Application Platform (JBoss EAP)](https://azuremarketplace.microsoft.com/marketplace/apps/redhat.jboss-eap-rhel).
- [Azure Red Hat OpenShift](https://azure.microsoft.com/services/openshift) provides highly available, fully managed OpenShift clusters on demand, monitored and operated jointly by Microsoft and Red Hat. Kubernetes is at the core of Red Hat OpenShift. OpenShift brings added-value features to complement Kubernetes, making it a turnkey container platform as a service (PaaS) with a significantly improved developer and operator experience.
- [Red Hat JBoss Enterprise Application Platform (JBoss EAP)](https://azuremarketplace.microsoft.com/marketplace/apps/redhat.jboss-eap-rhel) is an application platform that delivers enterprise-grade security, performance, and scalability. It can run on-premises, virtual, or in private, public, or hybrid clouds.

## Solution details

Red Hat and Microsoft partnered to create a comprehensive and secure infrastructure on Azure. It's an open source project that Red Hat continually enhances to support versatile and seamless team workflows, on-premises and in the cloud. It can be fully managed or self-managed.

Azure Red Hat OpenShift (ARO) provides highly available OpenShift clusters on demand. The Red Hat JBoss Enterprise Application Platform (JBoss EAP) is an application platform that runs on ARO. It streamlines and simplifies the development and deployment of a diverse range of applications and delivers enterprise-grade security, performance, and scalability. The central console on JBoss EAP bolsters administrative productivity with an easy-to-navigate interface that supports large-scale domain configurations.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

 * [Michael Yen-Chi Ho](https://www.linkedin.com/in/yenchiho) | Senior Program Manager

## Next steps

### Red Hat on Azure

- [CDEPLOYING A RED HAT ENTERPRISE LINUX 8 IMAGE AS A VIRTUAL MACHINE ON MICROSOFT AZURE](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html-single/deploying_red_hat_enterprise_linux_8_on_public_cloud_platforms/index)
- [Azure Red Hat OpenShift documentation](/azure/openshift)

### JBoss

- [Red Hat JBoss EAP on Azure](/azure/developer/java/ee/jboss-on-azure)
- [USING JBOSS EAP IN MICROSOFT AZURE](https://access.redhat.com/documentation/en-us/red_hat_jboss_enterprise_application_platform/7.0/html/using_jboss_eap_in_microsoft_azure/index)
- [Monoliths to microservices: App Transformation](https://github.com/SpektraSystems/Red-Hat-Modernize-Apps/tree/master/docs) (GitHub)

### Case studies

- [Alpega Group is improving sustainability in the transport industry with a container solution managed by Microsoft and Red Hat](https://customers.microsoft.com/story/1342697026461181048-alpega-group-professional-services-azure-english-austria)
- [VINCI Energies: The scalable benefits of running native applications in the cloud](https://customers.microsoft.com/story/1340822776599403898-vinci-energies-energy-microsoft365-en-netherlands)
- [From farm to datacenter: Norwegian dairy producer lowers costs, improves operations using Azure](https://customers.microsoft.com/story/820925-tine-manufacturing-azure)

### Data sheets

- [Red Hat JBoss EAP on Azure](https://www.redhat.com/rhdc/managed-files/cl-eap-on-azure-datasheet-f26716wg-202101-en.pdf)
- [Red Hat OpenShift Container Platform](https://www.redhat.com/rhdc/managed-files/cl-red-hat-openshift-container-platform-datasheet-f28985-202106.pdf)
- [Achieve more for less with Microsoft Azure Red Hat OpenShift](https://www.redhat.com/rhdc/managed-files/pa-microsoft-aro-cost-savings-brief-f27533-202103-en.pdf)

## Related resources

- [Banking system cloud transformation on Azure](../..//example-scenario/banking/banking-system-cloud-transformation.yml)
- [SAS on Azure architecture guide](../../guide/sas/sas-overview.yml)
- [Azure Kubernetes Service (AKS) architecture design](../../reference-architectures/containers/aks-start-here.md)
