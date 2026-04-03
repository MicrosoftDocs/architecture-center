This reference architecture shows how you can use Azure to re-engineer a z/OS mainframe batch application to deliver a secure, scalable, and highly available system in the cloud using Azure. Because of ever evolving business needs, data and applications need to deliver and scale without affecting your infrastructure. Re-engineering to the cloud can help businesses in finance, health, insurance, and retail minimize their product or feature delivery times, and reduce costs.

## Mainframe Architecture

The first diagram shows the architecture of a typical batch application running on a z/OS mainframe.

:::image type="content" source="media/mainframe-batch-application-diagram.svg" alt-text="Diagram of a typical batch application running on a z/OS mainframe." lightbox="media/mainframe-batch-application-diagram.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/us-1858749-pr-3417-mainframe-batch-application-example.vsdx) of this architecture.*

### Workflow

1. Mainframe batch processes can be triggered at a scheduled time using an Operation, Planning, and Control (OPC) Scheduler. They can also be triggered by a message placed in a message queue, like a message that announces that a file was created.
1. A mainframe direct-access storage device (DASD) is used to store input and output files; for example, flat files that are required by the application. You can trigger the batch process by creating a file on the DASD storage.
1. The batch process is an execution of a set of jobs, like a job internally running a user or system program to do a specific task. Usually, batch processes are run without user interaction. All batch jobs on a mainframe are executed under the control of a Job Execution System (JES).
1. Programs in batch processes can read/write data from:

    - A file-based database like Virtual Storage Access Method (VSAM).
    - A relational database like Db2 or Informix.
    - A non-relational database like Information Management System (IMS).
    - A message queue.

1. The output of the job execution can be monitored through an OPC scheduler or Tivoli Workload Scheduler (TWS). A System Display and Search Facility (SDSF) in the JES is also used on the mainframe to check job execution status.
1. The management tier provides the following services:

    - Source control, like Endevor or Changeman.
    - Security, like Resource Access Control Facility (RACF). This security provides authentication for running batches, accessing files, and accessing the database.
    - Output management that supports the storage and search of job execution logs.

## Azure architecture

The second diagram shows how you can use Azure services to re-engineer a similar application with added capabilities and flexibility.

:::image type="content" source="media/azure-reengineered-mainframe-batch-application-architecture.svg" alt-text="Diagram of a batch application re-engineered using Azure services. Multiple example services are included." lightbox="media/azure-reengineered-mainframe-batch-application-architecture.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/azure-reengineered-mainframe-batch-application-architecture.vsdx) of this architecture.*

### Workflow

1. Use one of the following triggers to start the Azure batch process.

    - Use the **Azure Databricks** job scheduler or **Azure Function** scheduler.
    - Create a recurring batch process task with **Azure Logic Apps**.
    - Use a storage event, like the creation or deletion of a file in **Azure Blob** or **File storage**.
    - Use a message-based trigger, like the arrival of a message on the **Azure Service Bus**.
    - Create an **Azure Data Factory** trigger.

1. Store files migrated from the mainframe by using Azure Blob Storage or Azure Files. Batch processes re-engineered on Azure can read/write data from this storage.
1. Azure provides various services to implement a mainframe batch workload. Select specific services that are based on your business requirements. For example, compute power required, total execution time, the ability to split mainframe batch process into smaller units, and cost sensitivity.

    1. Azure Databricks is an Apache Spark-based analytics platform. Jobs can be written in the R, Python, Java, Scala, and Spark SQL languages. It provides a compute environment with fast cluster start times, auto termination, and autoscaling. It has built-in integration with Azure storage like Azure Blob Storage and Azure Data Lake storage. Use Azure Databricks if you need to process large amounts of data in a short time. It's also a good choice if you need to run Extract, Transform, and Load (ETL) workloads.
    2. AKS provides an infrastructure to implement a service-based application architecture. It might not be cost effective for a single application. You can refactor your mainframe application using Java Spring Boot. The best way to run Spring Boot apps on Azure is to use Azure Spring Apps, a fully managed Spring service. Java developers can use it to easily build and run Spring Boot Microservices on Azure.

       > [!IMPORTANT]
       > Azure Spring Apps is retired as of March 31, 2028. We recommend [Azure Container Apps](/azure/container-apps/overview) and [Azure Kubernetes Service (AKS)](/azure/aks/what-is-aks) as the replacement services. For more information, see [Azure Spring Apps retirement announcement](/azure/spring-apps/basic-standard/retirement-announcement).

    3. You can re-engineer your mainframe batch application using .NET or Java. Batch provides the infrastructure to run this application at scale. It creates and manages a pool of virtual machines (VMs), installs the applications, and then schedules jobs to run on the VMs. There's no cluster or job scheduler software to install, manage, or scale. Write applications in any programming language supported by Windows or Linux.
    4. You can re-engineer short running COBOL or PL/1 batch programs. For these programs, use Azure services like Functions, WebJobs, or Logic Apps.

1. Azure provides various data services to store and retrieve data.

    - You can migrate mainframe relational databases like Db2 and Informix with minimal changes to the Azure relational database offerings' visibility. For example, relational database services like Azure SQL VM, Azure SQL DB, or Azure SQL MI. You can also use any open-source Relational Database Management System (RDBMS) like Azure PostgreSQL. The selection of an Azure database depends on the type of workload, cross-database queries, two-phase commit requirements, and many other factors.
    - You can migrate mainframe non-relational databases like IMS, Integrated Data Management System (IDMS), or VSAM to Azure Cosmos DB. Azure Cosmos DB provides fast response times, automatic and instant scalability, and guaranteed speed at any scale. It's a cost-effective option for unpredictable or sporadic workloads of any size or scale. Developers can easily get started without having to plan for or manage capacity.
    - You can use Azure Managed Redis to speed up a re-engineered application.

1. Applications, the OS, and Azure resources can use agents to send logs and metrics to **Azure Monitor Logs**.

    - **Application Insight** monitors your migrated application. It automatically detects performance anomalies and includes powerful analytics tools to help you diagnose issues.
    - **Azure Log Analytics** helps store, index, query, and derive analytics from the log data collected.

    You can use the output of Log Analytics and Application Insights to create alerts and dashboards, or export to external services. You can also use the output to do an action like the scaling of a VM.

1. This tier provides Azure services for source control, security, and output management. These services might consist of Azure DevOps and Microsoft Entra ID.

### Components

This solution uses the following components.

#### Network and identity

- [Azure ExpressRoute](/azure/well-architected/service-guides/azure-expressroute) is a connectivity service that extends your on-premises networks into the Microsoft cloud over a private connection from a connectivity provider. By using ExpressRoute, you can establish connections to Microsoft cloud services like Microsoft Azure and Microsoft 365. In this architecture, ExpressRoute provides secure, high-bandwidth connectivity between on-premises mainframe environments and Azure services.

- [Azure VPN Gateway](/azure/vpn-gateway/vpn-gateway-about-vpngateways) is a specific type of virtual network gateway that's used to send encrypted traffic between an Azure virtual network and an on-premises location over the public internet. In this architecture, VPN Gateway provides an alternative connectivity option for accessing Azure resources when ExpressRoute isn't available.

- [Microsoft Entra ID](/entra/fundamentals/whatis) is an identity and access management service that can sync with an on-premises directory. In this architecture, Microsoft Entra ID provides authentication and authorization services for users and applications that access the reengineered batch system.

#### Application

- [Logic Apps](/azure/logic-apps/logic-apps-overview) is a cloud service that helps you create and run automated recurring tasks and processes on a schedule. You can call services inside and outside Azure like HTTP or HTTPS endpoints. You can also post messages to Azure services like Service Bus, or get files uploaded to a file share. In this architecture, Logic Apps provides workflow orchestration and scheduling capabilities for triggering and coordinating batch processes.

- [Service Bus](/azure/service-bus-messaging/service-bus-messaging-overview) is a cloud messaging service that you can use for messaging between a user interface and back-end services. This system can decouple applications and services and increase reliability and use. In this architecture, Service Bus provides reliable messaging capabilities for triggering batch processes and coordinating between different components of the reengineered system.

- [Azure Databricks](/azure/well-architected/service-guides/azure-databricks-security) is an Apache Spark-based analytics platform and cloud-based data engineering tool that's used for processing and transforming large amounts of data. You can then explore that data through machine learning models. In this architecture, Azure Databricks provides high-performance compute capabilities for processing large-scale batch workloads with fast cluster start times and autoscaling.

- [Azure Spring Apps](/azure/spring-apps/basic-standard/overview) is a fully managed service for deploying, managing, and running Spring microservices on Azure. It supports both Java and .NET Core. In this architecture, Azure Spring Apps provides a platform for running reengineered mainframe applications written in Java Spring Boot as microservices.

- [Azure Kubernetes Service (AKS)](/azure/well-architected/service-guides/azure-kubernetes-service) is a managed Kubernetes service that simplifies deploying a managed Kubernetes cluster in Azure by offloading the operational overhead to Azure. In this architecture, AKS provides container orchestration capabilities for running reengineered batch applications in a scalable, microservices-based architecture.

- [Azure Batch](/azure/batch/batch-technical-overview) is a cloud service designed to run general-purpose batch computing in the cloud across many VMs that can scale based on the workload. It supports ETL or AI use cases where multiple tasks are implemented in parallel, independent from each other. In this architecture, Batch provides scalable compute infrastructure for running reengineered mainframe batch jobs across multiple VMs.

- [Azure Functions](/azure/well-architected/service-guides/azure-functions-security) is a serverless compute service that you can use to run small pieces of code. By using Functions, the cloud infrastructure provides all the up-to-date servers that you need to keep your application running at scale. In this architecture, Functions provides serverless compute for short-running batch programs that are originally written in COBOL or PL/1.

- [Azure App Service](/azure/well-architected/service-guides/app-service-web-apps) is a fully managed platform for building, deploying, and scaling web apps and APIs. By using [WebJobs](/azure/app-service/webjobs-create), a feature of App Service, you can code reusable background business logic as web jobs. In this architecture, App Service with WebJobs provides a platform for running background batch processing tasks.

- [Azure Managed Redis](/azure/redis/overview) is a fully managed in-memory caching service that enables applications by using a high volume of back-end data to scale and deliver highly optimized performance by integrating with an in-memory data store like Redis. In this architecture, Azure Managed Redis provides high-speed caching to improve the performance of reengineered batch applications.

#### Storage

Azure storage provides multiple tiers of hot, cool, and archive data. Effective usage of these storage tiers can give you a price-to-performance advantage.

- [Azure Cosmos DB](/azure/well-architected/service-guides/cosmos-db) is a fully managed NoSQL database service that you can use to migrate non-tabular data from the mainframes. In this architecture, Azure Cosmos DB provides globally distributed NoSQL database services for migrating mainframe non-relational databases like IMS, IDMS, and VSAM.

- [Azure Files](/azure/well-architected/service-guides/azure-files) is a fully managed file share service that provides simple, secure, and serverless enterprise-grade cloud file shares. Azure Files is especially useful for reengineered mainframe solutions. It provides an effective add-on for the managed SQL storage. In this architecture, Azure Files provides shared file storage that multiple batch processing nodes can access.

- [Azure Queue Storage](/azure/well-architected/service-guides/queue-storage/reliability) is a cost-effective, durable message queueing service for large workloads. In this architecture, Queue Storage provides reliable message queuing for coordinating batch job execution and workflow management.

- [Azure SQL](/azure/azure-sql/) is a fully managed family of services for SQL Server. You can migrate and use the relational data efficiently with other Azure services like Azure SQL Managed Instance or SQL Server on Azure Virtual Machines. In this architecture, Azure SQL provides managed relational database services for migrated mainframe databases like Db2 and Informix.

- [Blob Storage](/azure/well-architected/service-guides/azure-blob-storage) is a scalable and secure object storage service for cloud-native workloads, archives, data lakes, high-performance computing, and machine learning. In this architecture, Blob Storage provides scalable object storage for batch input files, output data, and intermediate processing results.

- [Azure Table Storage](/azure/storage/tables/table-storage-overview) is a NoSQL key-value store for rapid development by using large semi-structured datasets. In this architecture, Table Storage provides fast NoSQL storage for batch processing metadata and lookup data.

#### Monitoring

- [Azure Monitor](/azure/azure-monitor/overview) is a monitoring service that delivers a comprehensive solution for collecting, analyzing, and acting on telemetry from cloud and on-premises environments. It contains Application Insights, Azure Monitor Logs, and Log Analytics features. In this architecture, Azure Monitor provides end-to-end monitoring and observability for the reengineered batch applications, including performance metrics, logs, and alerts.

#### Management

- [Azure DevOps](/azure/devops/user-guide/what-is-azure-devops) is a set of development tools that help you reengineer mainframe applications on Azure during every phase of software development and team collaboration. In this architecture, Azure DevOps provides comprehensive DevOps capabilities for source control, continuous integration/continuous deployment (CI/CD), and project management throughout the mainframe reengineering process. DevOps provides the following services:

  - [Azure Artifacts](/azure/devops/artifacts/start-using-azure-artifacts?view=azure-devops) is a package management service that supports Maven, npm, Python, and NuGet package feeds from public or private sources. In this architecture, Azure Artifacts manages dependencies and libraries required for the reengineered mainframe applications.

  - [Azure Boards](/azure/devops/boards/get-started/what-is-azure-boards?view=azure-devops) is an agile project management tool that provides work item tracking, sprint planning, visualization, and reporting capabilities. In this architecture, Azure Boards helps manage the mainframe reengineering project by tracking development tasks, user stories, and migration milestones.

  - [Azure Pipelines](/azure/devops/pipelines/get-started/what-is-azure-pipelines?view=azure-devops) is a CI/CD service that supports multiple languages, platforms, and cloud environments, including containers and Kubernetes. In this architecture, Azure Pipelines automates the build, test, and deployment processes for reengineered mainframe applications.

  - [Azure Repos](/azure/devops/repos/get-started/what-is-repos?view=azure-devops) is a cloud-hosted Git repository service that provides unlimited private repositories with collaborative pull requests and advanced file management. In this architecture, Azure Repos provides version control for the reengineered application code and configuration files.

  - [Azure Test Plans](/azure/devops/test/overview?view=azure-devops) is a test management service that provides manual testing, exploratory testing, and user acceptance testing capabilities. In this architecture, Azure Test Plans ensures the quality and functionality of reengineered mainframe applications through comprehensive testing workflows.

## Scenario details

Mainframes are primarily used for processing large amounts of data. Batch processing is a way of processing a high volume of transactions that are grouped together, and then making bulk updates against the database. Once triggered, they require minimal to no user interaction. For example, mainframe systems make it possible for banks and other financial institutions to do end-of-quarter processing and produce reports, like quarterly stock or pension statements.

### Potential use cases

This solution is ideal for the finance, insurance, healthcare, and retail industries. Use this architecture to re-engineer mainframe applications on Azure. The architecture works best for:

- Resource-intensive mainframe batch applications.
- Batch applications that need high compute during a certain time, like end of month, quarter, or year.
- Mainframe batch processes that are repetitive and not resource-intensive but might need utilization by external systems.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

- You can use Azure Monitor and Application Insights, in addition to Log Analytics, to monitor the health of an Azure resource. Set alerts to proactively manage your resource health.
- For more information on resiliency in Azure, see [Designing reliable Azure applications](/azure/architecture/framework/resiliency/app-design).

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

- This reference architecture uses ExpressRoute for a private and efficient connection to Azure from the on-premises environment. However, you can also create a [site to site VPN](/azure/vpn-gateway/tutorial-site-to-site-portal).
- You can authenticate Azure resources by using Microsoft Entra ID. You can manage permissions with Azure role-based access control (Azure RBAC).
- Database services in Azure support various security options like Data Encryption at Rest.
- For more information on designing secure solutions, see [Azure security documentation](/azure/security).

### Cost Optimization

Cost Optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

Use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator/) to estimate costs for Azure resources.

See [Azure mainframes batch application](https://azure.com/e/c7fa52f13c2f4806ac05316813ed97a0) for an example cost estimate of services.

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

- The batch architecture in this article uses multi-node computing or PaaS services, which provide high availability.
- Azure database services support zone redundancy, and you can design them to fail over to a secondary node if there's an outage or during a maintenance window.

### Performance Efficiency

Performance Efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

- The following Azure services in this architecture have autoscaling capabilities:

    - Azure Databricks
    - AKS
    - Spring Apps
    - Batch
    - Azure Functions
    - Logic Apps

- For more information on autoscaling in Azure, see the [autoscaling guide](../../best-practices/auto-scaling.md).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal author:

 - [Ashish Khandelwal](https://www.linkedin.com/in/ashish-khandelwal-839a851a3/) | Principal Engineering Architecture Manager
 
*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- For more information, contact datasqlninja@microsoft.com.
- See the [Azure database migration guides](https://datamigration.microsoft.com).

## Related resource

- [High-volume batch transaction processing](process-batch-transactions.yml)
