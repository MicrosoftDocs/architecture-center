Replatform AIX workloads to Azure

This article provides a general replatform migration approach that can use either serverless architecture patterns with Azure Functions, or retain a serverful model with Azure Virtual Machines (VMs). 

Companies should consider a replatform migration strategy for AIX workloads as a first option to maximize the Return on Investment (ROI) in legacy application migrations to Azure.

Replatform migrations require minimal changes to move workloads into Azure-native architectures, while delivering similar cloud-native benefits to a Refactor migration. The benefits to the business include lower TCO, greater business agility, and increased operational resiliency from automated scalability.  

# Architecture - replatformed

![A diagram of a software company  Description automatically generated](media/image4.png)

*Download a [Visio file](https://arch-center.azureedge.net/[file-name].vsdx) of this architecture.*

This architecture illustrates a general replatform migration approach that can use either serverless architecture patterns or retain a serverful model.  The selection between these two depends on the existing applications' portability  _and_ the team's workflow preference and technology roadmap. 

The company retains the Oracle Database in this phase but it is now replatformed to RHEL (Redhat Enterprise Linux) operating system on Azure Virtual Machines, but switched from WebSphere to JBoss EAP on the fully managed Azure App Service.

## Workflow

Mapping the original workflow to the components in this replatformed architecture, we now see:

User requests and inbound API integrations hit the Azure Application Gateway on TCP/443 (HTTPS), which now also provides Web Application Firweall (WAF) functionality before reverse proxying requests to various services hosted on RedHat JBoss EAP (1)

Java Web Services then interrogate the Oracle Database (TCP/1521), with synchronous web requests now being responded to in < 50 ms.

Asynchronous requests – such as a batch task – still place a record in the database table which continues to act as a queue within the application layer. <br>_Note: The team plans to move this to Azure Storage Queue in a future release and unlock 24/7 access to running analysis jobs._ 

Batch processing at night is no longer required to limit the impact on system performance during business hours.  The cron job previously written in KSH was ported to bash, running on a separate RHEL server in an Azure Virtual Machine Scale Set (VMSS). The cron job runs every 15 minutes, including on system boot, to query the queue in the Oracle database. Jobs are run one at a time per-host, with VMSS used to parallelize long-running analysis jobs.

Email alerts were switched to use Azure Communication Service via the az CLI tool (docs), with authentication of the Virtual Machine leveraging Azure system-assigned Managed Identities (e.g. az login --identity).

Completed analysis jobs have their results posted to an Azure Files share via secure SMBv3 (TCP/445), also leveraging system-assigned Managed Identities.

## Components

**Azure Entra ID**: Improves security by removing network-based trust, and leveraging system-assigned Managed Identities.  

**Azure App Service**: removes the need to administer an operating system and server, increasing operational efficiency and business agility.

**Azure App Gateway**: scalable, managed, web application firewall and reverse proxy.

**Azure Files**: data reports published via a managed service.

<kbd>Azure F</kbd>unction<kbd>i</kbd>le<kbd>s</kbd>:  <kbd>Azure</kbd> Functions is an event-driven, serverless <kbd>compute</kbd> platform that helps you develop more efficiently using the programming language of your choice. 

**Azure Virtual Machine**: The Oracle database and SAS analysis nodes require a VM.

**Azure Compute Gallery**: Images for the Oracle database and SAS analysis nodes are pre-built and stored in two Azure Compute Galleries, one in our primary region (Canada Central), and one in our DR region (Canada East) 

**Azure Communication Service**: Simple email delivery, with a CLI utility it was a direct replacement for the mailx command on AIX

## Alternatives

An alternative that is often considered is a complete serverful architecture, retaining all middleware components as-is.  

While this would be closer to a “like for like” mandate under which many IT organizations operate, it would cost a similar amount to execute the migration but would not provide the same business benefit as the prior method.  Specifically, the customer would not achieve the following benefits:<br>

**licensing savings** - would retain WebSphere, and add more RHEL nodes

**operational efficiencies** - would retain same number of servers to maintain

**business agility** - reporting remains limited to nights only and there would be no auto-scaling powered 24/7 analysis

# Architecture - original

![](media/image3.png)

*Download a [Visio file](https://arch-center.azureedge.net/[file-name].vsdx) of this architecture.*

The original workload running on AIX is a key input to determine if a replatform migration strategy is feasible for a given migration budget. In this example, we’ll evaluate a monolith Java application running on IBM WebSphere (1) as well as batch processing from SAS that is orchestrated by a series of KSH (Korn Shell) scripts (2).  Both application workloads are supported by an Oracle Database running on a separate AIX host (3).

## Workflow

User requests and inbound API integrations hit the on-premises F5 load balancer on TCP/443 (HTTPS) and then reverse proxy to various Java Web Services hosted on IBM WebSphere.

Java Web Services then interrogate the Oracle Database via TCP/1521, with synchronous web requests being responded to in < 1sec, but > 300ms in most cases according to testing and [weblog analysis](https://guides.tidal.cloud/analyze-logs.html).

Asynchronous requests, (e.g. to schedule a batch task) place a record in an Oracle table which acts as a queue within the application layer. 

Nightly batch processing is required to limit the impact on system performance during business hours.  A cron job written in KSH queries the queue in the Oracle database to pick up SAS analysis jobs that need to be run.

Email alerts are sent to users and administrators via SMTP (TCP/25) to inform them of job start and completion time, as well as success or failure.

Completed analysis jobs have their results posted to a shared drive via NFS (TCP+UDP/111,2049) for collection via SMBv3 (TCP/445)

# Scenario Details

Working backward from a customer's desired outcomes leads to a transformative, application-centric, migration path to the cloud. A replatform migration is possible when the majority of the application code is written in a language that can be supported by cloud-native services, such as serverless architectures and container orchestrators.

In this scenario, the Java application code was analyzed by [Tidal Accelerator](https://tidalcloud.com/accelerator/) and found to be compatible with JBoss EAP. Rebuilding the application via Azure DevOps Pipelines (or GitHub Actions) early in the project as a pilot allowed the customer to establish continuous integration and delivery (CI/CD) powered agility directly into a managed service (Azure App Service). This would not have been possible in their on-premises WebSphere environment.

The decision to retain the Oracle database in this phase was driven primarily by the amount of PL/SQL discovered by Tidal Accelerator during the analysis phase.  In line with the customer’s technology roadmap, development cycles and the business direction that is captured in the Application Owner interview, future efforts will include migration from Oracle DB on RHEL to a fully managed Azure PostgreSQL database, adoption of Azure Storage Queues, and fully on-demand SAS job execution.

![](media/image1.png)

Application Owner Interview player in Tidal Accelerator

## Potential Use Cases

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

## Operational Excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

By empowering the product team to self-support themselves in Azure, the client was able to reduce the time to resolution of reported incident tickets.  Additionally, the bounce-count of tickets (the count of tickets being assigned from one group to another) was reduced to zero as one product team could now support the entire application stack in Azure.

## Performance Efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

Adopting Azure App Service where possible allowed the client to automatically [Scale up, and Scale out](/azure/app-service/manage-scale-up) their compute requirements in line with the user demand for these application components.  This elasticity ensured that the performance of the application was consistent in peak times, while also being cost efficient. 

## Contributors

_This article is maintained by Microsoft. It was originally written by the following contributors._

Principal author:

[Richard Berry ](https://www.linkedin.com/in/richardberryjr/)| Sr. Program Manager

## Next steps

For more information about using Tidal Accelerator solution,  

      contact [microsoft@tidalcloud.com. ](mailto:microsoft@tidalcloud.com?subject=Tidal%20Accelerator%20Inquiry)

For more information about migrating to Azure,  contact [legacy2azure@microsoft.com](mailto:legacy2azure@microsoft.com).

## Related resources

[High availability and disaster recovery scenarios for IaaS apps](/azure/architecture/example-scenario/infrastructure/iaas-high-availability-disaster-recovery)

[Multi-tier web application built for HA/DR](/azure/architecture/example-scenario/infrastructure/multi-tier-app-disaster-recovery)

[Multi-region N-tier application](/azure/architecture/reference-architectures/n-tier/multi-region-sql-server)

[Run a Linux VM on Azure](/azure/architecture/reference-architectures/n-tier/linux-vm)

