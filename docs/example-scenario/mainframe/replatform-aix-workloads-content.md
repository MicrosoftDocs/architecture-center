This article describes a replatform migration approach. You can use Azure Functions for a serverless architecture or use Azure Virtual Machines to retain a serverful model. 

Consider a replatform migration strategy for AIX workloads as your first option to maximize the return on investment (ROI) in legacy application migrations to Azure.

Replatform migrations require minimal changes to move workloads into Azure-native architectures but deliver cloud-native benefits that are similar to a refactor migration.

The benefits include:

- A reduced total cost of ownership (TCO).
- Improved business agility.
- Improved operational resiliency due to automated scalability.  

# Architecture - replatformed

![Diagram of the replatformed architecture.](media/image4.png)

*Download a [Visio file](https://arch-center.azureedge.net/[file-name].vsdx) of this architecture.*

This architecture shows a general replatform migration approach that can use either serverless architecture patterns or retain a serverful model. The model that you choose depends on the portability of your existing applications and your team's workflow preference and technology roadmap. 

Like the [original architecture](#architecture---original), the replatformed architecture has an Oracle database but it's replatformed to a Red Hat Enterprise Linux (RHEL) operating system on Azure Virtual Machines. For the fully managed Azure App Service in the replatformed architecture, Red Hat JBoss Enterprise Application Platform (EAP) replaces the WebSphere Java application.
inadvertently
## Workflow

This workflow corresponds to the preceding architecture.

1. User requests and inbound API integrations go to Azure Application Gateway on TCP/443 (HTTPS), which provides a web application firewall (WAF) functionality. Application Gateway sends the requests, as reverse proxy requests, to various services that are hosted on Red Hat JBoss Enterprise Application Platform (EAP).

1. Java Web Services interrogates the Oracle database (TCP/1521). The synchronous web request response time is less than 50 milliseconds (ms).

1. Asynchronous requests, such as batch tasks, place a record in the database table which acts as a queue within the application layer. 

   > [!NOTE]
   > In a future release, Azure Queue Storage will replace the database  table, so you can always have access to running analysis jobs.

1. The cron job, written in Korn shell (ksh) script, is ported to bash and runs on a separate RHEL server in Azure Virtual Machine Scale Sets. The cron job runs every 15 minutes, including on system boot, to query the queue in the Oracle database. Jobs run one at a time per host. Virtual Machine Scale Sets parallelizes long-running analysis jobs. You no longer have to do batch processing during off-peak hours to limit the effect on system performance during business hours.

1. Azure Communication Service sends email alerts via the Azure CLI tool (docs). Azure system-assigned managed identities, such as `az login --identity`, authenticate the virtual machine (VM).

1. The analysis job results are posted to an Azure Files share via secure SMBv3 (TCP/445), which also uses system-assigned managed identities.

## Components

**Microsoft Entra ID** eliminates network-based trust and provides system-assigned managed identities, which improves security.

**Azure App Service** eliminates the need to administer an operating system and server, which increases operational efficiency and business agility.

**Application Gateway** scalable, managed, web application firewall and reverse proxy.

**Azure Files** provides data reports  that are published via a managed service.

**Azure Functions** is an event-driven, serverless compute platform that you can use to efficiently develop code in the programming language of your choice. 

An **Azure VM** is used by the Oracle database and SAS analysis nodes.

**Azure Compute Gallery** builds and stores images for the Oracle database and SAS analysis nodes. There are two galleries: one in the primary region (Canada Central) and one in the disaster recovery region (Canada East).

**Communication Services** sends emails with a CLI utility. This service replaces the `mailx` command on AIX.

## Alternatives

A potential alternative is a complete serverful architecture that retains all middleware components as is.  

This solution is similar to the original architecture, which fulfills a *like for like* mandate under which many IT organizations operate. This alternative solution also costs about the same as the original architecture but doesn't provide the benefits that the replatformed architecture provides. For example:

- Licensing savings: The alternative solution retains WebSphere and adds more RHEL nodes.

- Operational efficiencies: The alternative solution retains the same number of servers to maintain.

- Business agility: With the alternative solution, reporting remains limited to nights only and there's no autoscaling-powered 24/7 analysis.

# Architecture - original

![](media/image3.png)

*Download a [Visio file](https://arch-center.azureedge.net/[file-name].vsdx) of this architecture.*

The original workload running on AIX is a key input to determine if a replatform migration strategy is feasible for a given migration budget. In this example, we’ll evaluate a monolith Java application running on IBM WebSphere (1) as well as batch processing from SAS that is orchestrated by a series of KSH (Korn Shell) scripts (2).  Both application workloads are supported by an Oracle Database running on a separate AIX host (3).

## Workflow

1. User requests and inbound API integrations hit the on-premises F5 load balancer on TCP/443 (HTTPS) and then reverse proxy to various Java Web Services hosted on IBM WebSphere.

1. Java Web Services then interrogate the Oracle Database via TCP/1521, with synchronous web requests being responded to in < 1sec, but > 300ms in most cases according to testing and [weblog analysis](https://guides.tidal.cloud/analyze-logs.html).

1. Asynchronous requests, (e.g. to schedule a batch task) place a record in an Oracle table which acts as a queue within the application layer. 

1. Nightly batch processing is required to limit the impact on system performance during business hours.  A cron job written in KSH queries the queue in the Oracle database to pick up SAS analysis jobs that need to be run.

1. Email alerts are sent to users and administrators via SMTP (TCP/25) to inform them of job start and completion time, as well as success or failure.

1. Completed analysis jobs have their results posted to a shared drive via NFS (TCP+UDP/111,2049) for collection via SMBv3 (TCP/445)

# Scenario details

Working backward from a customer's desired outcomes leads to a transformative, application-centric, migration path to the cloud. A replatform migration is possible when the majority of the application code is written in a language that can be supported by cloud-native services, such as serverless architectures and container orchestrators.

In this scenario, the Java application code was analyzed by [Tidal Accelerator](https://tidalcloud.com/accelerator/) and found to be compatible with JBoss EAP. Rebuilding the application via Azure DevOps Pipelines (or GitHub Actions) early in the project as a pilot allowed the customer to establish continuous integration and delivery (CI/CD) powered agility directly into a managed service (Azure App Service). This would not have been possible in their on-premises WebSphere environment.

The decision to retain the Oracle database in this phase was driven primarily by the amount of PL/SQL discovered by Tidal Accelerator during the analysis phase.  In line with the customer’s technology roadmap, development cycles and the business direction that is captured in the Application Owner interview, future efforts will include migration from Oracle DB on RHEL to a fully managed Azure PostgreSQL database, adoption of Azure Storage Queues, and fully on-demand SAS job execution.

![](media/image1.png)

Application Owner Interview player in Tidal Accelerator

## Potential use cases

The architecture presented in this document has been used for AIX to Azure migrations that cover data analytics, CRM, and mainframe integration layers in a hybrid cloud configuration, as well as other custom software solutions in inventory and warehouse management scenarios.

Specific technologies in traditional application workloads where this is applicable, include:

Oracle Siebel

Oracle eBusiness Suite

SAS

IBM BPM

# Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).

## Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

This architecture uses Azure Site Recovery to mirror the database Azure VMs to a secondary Azure region for quick failover and DR if an entire Azure region fails.  Similarly, Georedundant storage is used for all Azure Files. <br><br>For data processing nodes, zone redundant (RA-ZRS) managed disks are used to provide resiliency in the face of a zone outage.  In the case of an entire region outage, data processing nodes can be reprovisioned in another region from their Virtual Machine Image within our redundant Azure Compute Gallery.

## Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

Adopting an immutable infrastructure approach to application deployments together with proactive code scanning in Azure DevOps pipelines improved the security posture of sensitive customer data in production.  This “shift left” of security scanning and the more frequent deployments that were enabled by CI/CD pipelines resulted in greater software currency adherence and less technical debt.

## Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

By removing as many serverful components as possible, this solution was able to reduce operating costs by over 70%.  These savings were found via reduced compute and software licensing costs. 

## Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

By empowering the product team to self-support themselves in Azure, the client was able to reduce the time to resolution of reported incident tickets.  Additionally, the bounce-count of tickets (the count of tickets being assigned from one group to another) was reduced to zero as one product team could now support the entire application stack in Azure.

## Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

Adopting Azure App Service where possible allowed the client to automatically [Scale up, and Scale out](/azure/app-service/manage-scale-up) their compute requirements in line with the user demand for these application components.  This elasticity ensured that the performance of the application was consistent in peak times, while also being cost efficient. 

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

[Richard Berry](https://www.linkedin.com/in/richardberryjr/)| Sr. Program Manager

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

For more information about using Tidal Accelerator solution, contact [microsoft@tidalcloud.com](mailto:microsoft@tidalcloud.com?subject=Tidal%20Accelerator%20Inquiry).

For more information about migrating to Azure,  contact [legacy2azure@microsoft.com](mailto:legacy2azure@microsoft.com).

## Related resources

- [High availability and disaster recovery scenarios for IaaS apps](/azure/architecture/example-scenario/infrastructure/iaas-high-availability-disaster-recovery)
- [Multi-tier web application built for HA/DR](/azure/architecture/example-scenario/infrastructure/multi-tier-app-disaster-recovery)
- [Multi-region N-tier application](/azure/architecture/reference-architectures/n-tier/multi-region-sql-server)
- [Run a Linux VM on Azure](/azure/architecture/reference-architectures/n-tier/linux-vm)

