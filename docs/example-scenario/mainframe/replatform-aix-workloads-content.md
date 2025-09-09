This article describes a migration approach to replatform your AIX workloads to the cloud. You can use Azure Functions for a serverless architecture or use Azure Virtual Machines to retain a serverful model. 

Consider a replatform migration strategy for AIX workloads to maximize your return on investment (ROI) when you migrate legacy applications to Azure. Replatform migrations require minimal changes but deliver cloud-native benefits that are similar to a refactor migration.

The benefits of a replatform migration include:

- A reduced total cost of ownership (TCO).
- Improved business agility.
- Improved operational resiliency.


## Architecture (replatformed)

:::image type="content" source="media/aix-azure-replatform.svg" alt-text="Diagram of the replatformed architecture." lightbox="media/aix-azure-replatform.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/aix-azure-replatform.vsdx) of this architecture.*

### Workflow

This workflow corresponds to the preceding architecture.

1. User requests and inbound API integrations transfer to Azure Application Gateway on TCP/443 (HTTPS), which provides a web application firewall (WAF) functionality. Application Gateway sends the requests, as reverse proxy requests, to various services that are hosted on Red Hat JBoss Enterprise Application Platform (EAP).

1. Java Web Services interrogates the Oracle database (TCP/1521). The synchronous web request response time is less than 50 milliseconds (ms).

1. An asynchronous request, such as scheduling a batch task, places a record in a database table that acts as a queue within the application layer. 

   > [!NOTE]
   > In the future, Azure Queue Storage will replace the database table, so you can always have access to running analysis jobs.

1. The cron job, written in KornShell (ksh) script, is ported to Bash and runs on a separate Red Hat Enterprise Linux (RHEL) server in Azure Virtual Machine Scale Sets. The cron job runs every 15 minutes, including on system startup, to query the queue in the Oracle database. Jobs run one at a time per host. Virtual Machine Scale Sets parallelizes long-running analysis jobs. This solution doesn't require off-peak batch processing to limit the effect on system performance during business hours.

1. Azure Communication Services sends email alerts via the Azure CLI tool (docs). Azure system-assigned managed identities, such as `az login --identity`, authenticate the virtual machine (VM).

1. The analysis job results go to an Azure Files share via secure SMBv3 (TCP/445), which also uses system-assigned managed identities.

### Components

- [Application Gateway](/azure/well-architected/service-guides/azure-application-gateway) is a web traffic load balancer and application delivery controller that is a fully managed and scalable service that provides web application firewall and reverse proxy functionality. In this architecture, Application Gateway provides secure external access to the replatformed applications with built-in web application firewall protection and Secure Sockets Layer (SSL) termination.

- [Azure App Service](/azure/well-architected/service-guides/app-service-web-apps) is a fully managed platform for building, deploying, and scaling web applications. It eliminates the need to administer an operating system and server, which increases operational efficiency and business agility. In this architecture, App Service hosts the replatformed Java applications by using Red Hat JBoss EAP, which replaces the original WebSphere middleware from the AIX environment.

- [Azure Communication Services](/azure/communication-services/overview) is a cloud-based communication platform that sends emails via a command-line interface (CLI) utility. This service replaces the `mailx` command on AIX. In this architecture, Azure Communication Services provides email notification capabilities for the replatformed applications. It replaces the traditional AIX mailx functionality with a modern cloud-based communication solution.

- [Azure Compute Gallery](/azure/virtual-machines/azure-compute-gallery) is an image management service that builds and stores images for the Oracle database and Statistical Analysis System (SAS) analysis nodes. There is one gallery in the primary region and one gallery in the disaster recovery region. In this architecture, Azure Compute Gallery provides centralized image management for the Oracle database and SAS analysis VMs. This management ensures consistent deployments across primary and disaster recovery regions.

- [Azure Files](/azure/well-architected/service-guides/azure-files) is a fully managed file share service in the cloud that provides data reports that are published via a managed service. In this architecture, Azure Files provides shared storage for analysis job results and data reports. These results and reports are accessible via secure SMBv3 protocol by using system-assigned managed identities.

- [Azure Functions](/azure/well-architected/service-guides/azure-functions-security) is an event-driven, serverless compute platform that's used to efficiently develop code in the specified programming language. In this architecture, Azure Functions provides serverless compute capabilities for processing events and running analysis tasks, eliminating the need for dedicated server management while enabling automatic scaling based on demand.

- [Microsoft Entra ID](/entra/fundamentals/whatis) is a cloud-based enterprise identity and access management service that eliminates network-based trust and provides system-assigned managed identities. In this architecture, Microsoft Entra ID provides secure authentication and authorization for all Azure services and enables the use of managed identities to eliminate the need for stored credentials.

- [Virtual Machines](/azure/well-architected/service-guides/virtual-machines) is a cloud computing service that provides on-demand, scalable virtual machines. In this architecture, Virtual Machines hosts the Oracle database and SAS analysis workloads on RHEL operating systems. It also provides the compute infrastructure for data processing and analysis tasks.

### Alternatives

An alternative is a complete serverful architecture that retains all middleware components as is.  

This solution is similar to the original architecture, which fulfills a *like for like* mandate under which many IT organizations operate. This alternative solution also costs about the same as the original architecture but doesn't provide the benefits that the replatformed architecture provides. For example:

- Licensing savings: The alternative solution retains WebSphere and adds more RHEL nodes.

- Operational efficiency: The alternative solution retains the same number of servers to maintain.

- Business agility: With the alternative solution, reporting remains limited to nights only with no autoscaling-powered, all-day analysis.

## Scenario details

Choose a serverless or serverful model depending on the portability of your existing applications and your team's workflow preference and technology roadmap. 

Like the [original architecture](#architecture-original), the [replatformed architecture](#architecture-replatformed) has an Oracle database, but it's replatformed to a RHEL operating system on Azure Virtual Machines. For the fully managed Azure App Service in the replatformed architecture, Red Hat JBoss EAP replaces the WebSphere Java application.

## Architecture (original)

:::image type="content" source="media/aix-azure-original.svg" alt-text="Diagram of the original architecture." lightbox="media/aix-azure-original.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/aix-azure-original.vsdx) of this architecture.*

### Workflow

This workflow corresponds to the preceding architecture.

1. User requests and inbound API integrations transfer to the on-premises F5 load balancer on TCP/443 (HTTPS) and then reverse proxy to various IBM WebSphere-hosted Java Web Services.

1. Java Web Services interrogates the Oracle database via TCP/1521. In most cases, the synchronous web request response time is less than 1 second (sec) but more than 300 ms according to testing and [weblog analysis](https://guides.tidal.cloud/analyze-logs.html).

1. An asynchronous request, such as scheduling a batch task, places a record in an Oracle database table that acts as a queue within the application layer. 

1. A cron job, written in ksh script, queries the queue in the Oracle database and picks up SAS analysis jobs to run. The customer must do batch processing at night to limit the effect on system performance during business hours.

1. Email alerts notify users and administrators via SMTP (TCP/25) of the job start and completion times and success or failure results.

1. The analysis job results go to a shared drive via NFS (TCP+UDP/111,2049) for collection via SMBv3 (TCP/445).

## Scenario details

This original architecture evaluates a monolith Java application that runs on IBM WebSphere and evaluates batch processing from SAS that ksh scripts orchestrate. An Oracle database that runs on a separate AIX host supports both application workloads.

Consider your original workload that runs on AIX to determine if a replatform migration strategy suits your migration budget. Work backwards from your desired outcomes to determine a transformative, application-centric migration path to the cloud. Ensure that most of your application code is written in a language that cloud-native services, such as serverless architectures and container orchestrators, support.

In this scenario, [Tidal Accelerator](https://tidalcloud.com/accelerator/) analyzed the Java application code and determined its compatibility with JBoss EAP. Early in the project, Azure Pipelines or GitHub Actions is used to rebuild the application as a pilot. The customer can then establish agility from continuous integration and continuous delivery (CI/CD) pipelines in a managed service, such as Azure App Service. The customer can't get this capability in their on-premises WebSphere environment.

This example retains the Oracle database in this phase because of the amount of PL/SQL that Tidal Accelerator discovered during the analysis phase. The customer's future endeavors include migrating from the Oracle database on RHEL to a fully managed Azure Database for PostgreSQL database, adopting Azure Queue Storage, and running fully on-demand SAS jobs. These efforts align with the customer’s technology roadmap, development cycles, and the business direction that was determined in the Application Owner interview. The following screenshot shows an interview in Tidal Accelerator.

:::image type="content" source="media/aix-interview.png" alt-text="Screenshot of an interview in Tidal Accelerator." lightbox="media/aix-interview.png":::

### Potential use cases

You can use this architecture for AIX to Azure migrations that cover data analytics, customer relationship management (CRM), mainframe integration layers in a hybrid cloud configuration, and other custom software solutions in inventory and warehouse management scenarios.

You can use this architecture for traditional application workloads with technologies like:

- Oracle Siebel
- Oracle E-Business Suite
- SAS
- IBM BPM

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

This architecture uses Azure Site Recovery to mirror the database Azure VMs to a secondary Azure region for quick failover and disaster recovery if an entire Azure region fails. Similarly, Azure Files uses geo-redundant storage.

Data-processing nodes use zone-redundant (RA-ZRS) managed disks to provide resiliency during zone outages. During an entire region outage, you can reprovision data-processing nodes in a different region from their VM image within the redundant Azure Compute Gallery.

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

This architecture adopts an immutable infrastructure approach to application deployments and proactively scans code in Azure pipelines to help secure sensitive data in production. It incorporates a *shift left* approach for security scanning and frequently runs CI/CD pipeline-enabled deployments to improve software current adherence and reduce technical debt.

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

This solution removes as many serverful components as possible, which reduces operating costs by more than 70%. This architecture reduces compute and software licensing costs. 

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

The product team supports themselves in Azure, which reduces the resolution time for reported incident tickets. Additionally, the bounce count for tickets, or the number of tickets that are assigned from one group to another, is zero because one product team supports the entire application stack in Azure.

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

The customer adopts Azure App Service where possible so they can automatically [scale up and scale out](/azure/app-service/manage-scale-up) their compute requirements to align with application demand. This elasticity ensures consistent application performance during peak times. This approach is also cost efficient. 

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

[Richard Berry](https://www.linkedin.com/in/richardberryjr/)| Sr. Program Manager

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

For more information about using a Tidal Accelerator solution, [contact the Microsoft Tidal Cloud team](mailto:microsoft@tidalcloud.com?subject=Tidal%20Accelerator%20Inquiry).

For more information about migrating to Azure, [contact the Legacy Migrations Engineering team](mailto:legacy2azure@microsoft.com).

## Related resources

- [Multi-tier web application built for high availability and disaster recovery](../infrastructure/multi-tier-app-disaster-recovery.yml)
- [Run a Linux VM on Azure](../../reference-architectures/n-tier/linux-vm.yml)
