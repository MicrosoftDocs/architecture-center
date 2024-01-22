This article outlines key factors to consider when designing a proof of concept (POC) for migrating workloads from a mainframe to the cloud. Historically, mainframes are the backbone of the banking, aviation, and retail industries. Mainframes support complex and mission-critical operations. In pursuit of enhanced scalability, cost efficiency, and technical agility, many organizations are transferring mainframe workloads to the cloud.

*Challenge*: The journey from a mainframe to the cloud, while promising, is complex and requires planning. No two mainframes are alike. They differ in their architecture, workload characteristics, software stack, and internal and external integrations. The migration process varies in terms of the scope, methodology, and benchmarks for success.

*Solution*: To address these challenges, a POC is a critical step on the migration roadmap. A well-conceived POC has clear objectives and success metrics. It paves the way for a seamless transition to the cloud. Treat a POC as a trial demonstration and also as a comprehensive project that's complete with estimations, planning, and learning. This article helps you steer your POC in a direction that's custom to your environment and optimized in scope. You shouldn't need multiple POCs for a single migration.

## Architecture

The following diagram shows an example architecture for migrating workloads from a mainframe to the cloud.

:::image type="content" source="./images/mainframe-proof.svg" alt-text="Diagram that shows an example architecture for migrating workloads from a mainframe to the cloud." border="false" lightbox="./images/mainframe-proof.svg":::
*Download a [Visio file](https://arch-center.azureedge.net/mainframe-proof.vsdx) of this architecture.*

## Identify the right solution pattern

A solution pattern is a predefined approach that you can adapt to address the unique challenges within the context of your operations. In the early stages of the POC process, it's important to align a workload with an appropriate solution pattern that's based on your business and technical requirements. Identifying the right solution pattern is an iterative approach, and gaining familiarity with the common solution patterns is a prerequisite. As you gather business and technical criteria, you can refine and confirm your solution pattern selection.

Microsoft has four mainframe transformation solution patterns for migrating mainframe workloads to Azure: migrate, transform, re-envision, and extend.

:::image type="content" source="./images/solution-patterns.png" alt-text="Diagram that shows the four solution patterns: migrate, transform, re-envision, and extend." border="false" lightbox="./images/solution-patterns.png":::

- *Migrate*: Use this pattern to relocate the existing mainframe workload to Azure without altering the original codebase. You can use compilers that enable the legacy workloads to operate in the Azure environment.

- *Transform*: Use this pattern to refactor the existing legacy code into a modern language, such as Java or .NET. The restructured workload is designed to operate on contemporary platforms and use cloud-native technologies.
- *Re-envision*: Use this pattern to perform a complete overhaul of the mainframe workload. Incorporate modern development practices such as DevOps, containerization, and serverless computing to rebuild the workload for Azure.
- *Extend*: Use this pattern to integrate Azure services into a mainframe workload to improve it. Use REST APIs and integration platforms to expose a mainframe workload and its data to cloud-based services.

The best solution pattern is often a blend of these patterns and possibly other strategies, like in-place modernization or colocation. Tailor the strategies to meet specific migration goals and complement your existing technology stack.

In the initial assessment phase, examine common characteristics of your mainframe workloads to help inform your strategy. To define the POC scope, consider factors such as hardware specifications, application details, integration methods, and data structures. The following table describes characteristics to look for.

| Component | Common characteristics |
|---|---|
| Applications | Programming languages and associated metadata|
| Application-specific roadmaps | Decisions about whether to maintain, enhance, migrate, or eliminate applications |
| Data structures | File types, datasets, and database technologies                               |
| Dependencies| Inter-application and data dependencies, backups, and archival strategies |
| Hardware | MIPS (million instructions per second), MSUs (million service units), and LPARs (logical partitions)|
| Integration types | Methods such as file transfers, message queues, sockets, APIs, replication, and change data capture (CDC) |
| Security | Implemented protocols such as RACF, ACF2, and top secret                           |
| Support | Skillsets within a technical team for maintaining the migrated environment |

As you prepare for the POC, you should review case studies that mirror your workload's environment. Assess the methodologies that were used. Determine time frame estimates and costs associated with each potential solution to create a comparative analysis. Include common characteristics that are in the previous table.

## Define criteria to select a workload

When you define workloads for a POC, consider the viability and the effect of the resulting migration. Choose workloads that demonstrate the immediate benefits of a POC and can also transition into full-scale migration. Treat a POC as a pilot, so you can extract value in terms of cost, business functionality, and technical advancement. Take advantage of a POC so you can quickly and efficiently migrate to the cloud.

### Define business criteria

To select a workload, define the business criteria. Identify the key business factors and requirements that influence workloads for a POC. This step ensures that the workload you select aligns with your strategic business goals and drivers, such as cost reduction or critical-system modernization. Evaluate business criteria to determine workloads that offer the highest value and lowest risk and to effectively use resources during the migration process.

#### Understand business drivers

Determine the underlying motives that drive the need for modernizing mainframe workloads. These motives include cost efficiencies, operational improvements, and strategic objectives. Align business drivers to demonstrate clear benefits, which helps secure stakeholder buy-in and justify investments in the migration project.

**Understand the criticality of workloads.** Workload criticality is a measure of the importance of a workload to the business. Understand the criticality of workloads to help build a roadmap for modernization. Carefully determine the areas that you need to validate in a workload. For example, you might select a workload for a POC, and the initial phase of migration might draw several dependencies to mission-critical workloads. This new information might require you to include the dependencies in the scope, which drastically increases the complexity and risk of the migration.

**Prioritize workloads by the degree of associated risk.** Prioritize workloads by the use risks or current constraints of the environment. For example, retiring workload support resources or unsupported technical components are driving factors to prioritize workloads for migration and reduce risk.

**Prepare personnel.** It's important to identify the right support resources and make them available to personnel so you can validate the success of the POC. Group workloads by department to help limit the number of teams that are involved in the initial scope.

#### Establish POC goals

To establish POC goals, set clear objectives for the POC in terms of technical validation, business benefits, and strategic alignment. Objectives help to guide the decision-making process. Choose workloads that demonstrate the POC's objectives and provide measurable outcomes that support the business case for migration. Consider the following examples of POC goals.

- *Reduce or exit a datacenter*: When you downsize or exit a datacenter, it's crucial to assess how the existing distributed and midrange systems interface with the mainframe. Use the resulting information to help pinpoint which workloads are best-suited for the POC. Choose workloads that are distributed and sensitive to latency so you can optimize and potentially accelerate the modernization process.

- *Reduce mainframe consumption*: Map workload usage for the POC to decrease the mainframe's operational footprint. This method helps to prevent further investment in capacity and sets the foundation for a cost-effective, streamlined operational environment.
- *Optimize the procurement model*: A procurement model refers to the specific approach and terms under which an organization acquires and pays for its mainframe resources, both fixed and variable costs. Cost savings depend on the procurement model that's in place for the mainframe. The mainframe is a mix of fixed and variable costs, so it's essential to understand where variability lies within the model so you can save money.
- *Align with the mainframe refresh schedule*: Coordinate your POC workload selection with your organization's mainframe refresh schedule. Prioritize workloads that reduce mainframe usage. This strategy aims to sync with hardware updates for optimal financial and operational efficiency.

#### Evaluate technical partners

Choosing the right partners for participation in the POC and any following migration phases is a critical step that significantly affects the project's duration, effort, and cost.

**Ensure continuity with your implementation partners.** It's important to work with the same partners from start to finish. They can be from your company, or they can be outside vendors. Maintain the same team so you can use their POC findings for later stages. Changing partners can cause problems because the new team isn't familiar with the completed work.

**Use institutional knowledge.** Work with teams that already know your systems. These people, your employees or employees from other companies, know your system best. They can help plan the POC, pick the right tests, and determine the success criteria. Their knowledge helps ensure that the POC works for your business.

### Define technical criteria

From a technical standpoint, it's important to identify the technical components in a mainframe ecosystem that present complexity in a migration. Define a scope that represents those complexities. It's important to address complexity at the POC stage. You can eliminate risk in the subsequent modernization stages and identify solution components for optimal design and architecture. When you select workloads for a migration POC, consider the following technical factors.

**Choose the right technology mix.** Choose workloads or subsets that include various technologies. For instance, assembler programs might constitute a small part of the total codebase but they might be crucial because of their intensive usage. In this example, the solution must cater to the unique demands of assembler language and its usage.

**Select various compilation parameters.** Select programs with diverse compilation parameters, such as COBOL and PL/I, to ensure minimal compatibility issues. These parameters test the POC against potential compatibility issues. Rehosting, refactoring, or other modernization strategies are scrutinized for tool or platform efficacy and customization options.

**Identify capability usage.** Pay special attention to batch processes and job control language (JCL) use cases. Identify and understand the specific functions of mainframe utilities, like sort editors or file editors, that might not have direct equivalents in modern solutions. Identify these utilities to help avoid unexpected challenges. Workload programmers often take advantage of the various capabilities that these utilities provide. Not all capabilities provide a direct map to a modernized solution.

**List integration patterns to test.** It's important to test integration patterns so you can ensure that the modernized workload performs the same as or better than the legacy environment. Determine the most important factors to validate in the POC phase based on the usage, criticality, and unique nature of the integration. Test the crucial integration patterns, such as patterns that are used among various workloads, datasets, and systems, including MQ with CICS, batch processes, and secure file transfers.

**Understand utilities and packaged software.** You need to migrate essential mainframe utilities and packaged software to Azure-based equivalents. Determine first-party or third-party solutions that can replicate or replace current mainframe functionalities. For example, the mainframe workloads and data might adhere to security rules that are set up within Resource Access Control Facility (RACF) and Access Control Facility 2 (ACF2), among others. When these workloads are hosted on Azure, the security requirements need to be adapted to adhere to Microsoft Entra ID. Consider the following utilities and services:

- Azure DevOps
- Azure Monitor
- Content storage
- Distribution
- Microsoft Entra ID
- Printers
- Reports
- Schedulers

**Define deliverables.** Define the deliverables to provide at the end of the POC. We recommend the following deliverables.

- *An architecture overview*: Provide a detailed architecture model with a deployment view. Ideally, you should align the model with established Azure architecture patterns. For an example overview, see [Azure mainframe and midrange architecture concepts and patterns](/azure/architecture/mainframe/mainframe-midrange-architecture).

- *Azure landing zone artifacts*: Include scripts and other resources for the Azure landing zone that you can repurpose for broader use.
- *Modernized code and setup*: Host the updated source code on GitHub. Include the setup scripts, configuration details, and parameters.
- *Supporting documentation*: Deliver comprehensive documentation that includes nonfunctional requirements, design blueprints, and test plans. You should customize these factors to fit the scope of the POC.

## Design the target environment

As you prepare to migrate mainframe workloads, data, and utilities to Azure, carefully select and design the appropriate Azure services. Azure offers a comprehensive yet flexible environment that you can use to tailor your target architecture. Implement a consumption-based model to dynamically scale your workload and meet business demands.

When you adopt an Azure pay-as-you-go model, consider the following factors.

**Performance.** Mainframe workloads typically have specific performance requirements. The performance requirements include processing large volumes of data within a specific time frame and accommodating a high volume of concurrent users. Define these performance benchmarks in your POC to ensure that the Azure solution meets or exceeds the legacy system's performance and user experience. For instance, validate the handling of heavy batch processing, simultaneous user access, and low-latency transactions.

**Scale.** In the POC phase, verify that the proposed solution can scale vertically (increasing the power of existing instances) and horizontally (adding more instances). Scaling enables you to evaluate how the solution manages increased loads and transaction volumes in conjunction with the solution patterns and products that you consider.

**File-processing patterns.** Identify and test various file-processing patterns during the POC. You should assess the file volume, size, and types, such as the virtual storage access method (VSAM), generation data groups (GDGs), physical sequential datasets, and key-sequenced datasets (KSDSs). Also assess file operations, like sequential and keyed reads. For example, determine how the Azure solution manages and catalogs GDG files in a cloud environment. Similarly, if you migrate databases, test for database operation patterns and capabilities.

**Microsoft support.** The Microsoft Legacy Modernization team has Azure Core Engineering (ACE) resources, such as Global Black Belts, Data Ninjas, and Cloud Solution Architects. For a solution platform design, you can use the [mainframe landing zone accelerator](https://github.com/lapate/azure-mainframe-landing-zone-public). The Microsoft Mainframe Modernization team can also help to define an architecture that's specific to a solution path. Use their guidance to accelerate deployment and improve the solution in Azure.

## Define POC exit criteria

It's important to define success criteria for a POC so you can determine whether the POC achieves its goals and objectives. Success criteria are measurable and specific indicators that you use to evaluate the effectiveness of the POC.

Define success criteria to identify key performance indicators (KPIs). These criteria help to gauge the effectiveness of the POC. They also serve as a benchmark to compare the project's alignment with business goals and stakeholder expectations. To design your success and exit criteria, consider the following guidance.

- *Verify deliverables*: Review, finalize, and accept all source code, configuration files, setup parameters, and documentation. Examples include the projected architecture, Azure landing zone scripts, design documents, nonfunctional requirements, and test plans.

- *Finalize the Azure target environment*: Confirm that the Azure environment is fully defined and prepared for the migration and implementation process.
- *Validate the assessment roadmap*: Review the recommendations from the assessment phase. Adjust the recommendations as necessary based on the POC results.
- *Establish workload-specific KPIs*: Set explicit success criteria for workload performance, including response times, job execution durations, and other critical technical KPIs.
- *Document migration insights*: Record all findings, challenges, and strategies that are related to an effective data migration, based on the lessons learned from the POC.
- *Evaluate project parameters*: Reassess and confirm the project's estimation, timeline, and the composition of the teams, including the customers, system integrators, partners, and cloud providers. Amend the business case accordingly.
- *Review technical resources*: Update a list of necessary software, tools, and accelerators in accordance with the initial assessment phase recommendations and any new insights that are gained during the POC.
- *Present an executive summary*: Prepare and deliver a comprehensive presentation of the POC outcomes and lessons learned. Set expectations about the upcoming phases for senior management or the steering committee.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Shelby Howard](https://www.linkedin.com/in/shelbyhoward) | Senior Specialist, Global Black Belt Mainframe and Midrange Modernization Solutions
- [Venkataraman Ramakrishnan](https://www.linkedin.com/in/venkataramanr) | Senior Technical Program Manager, Azure Core Engineering
Mainframe and Midrange Modernization Solutions

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Mainframe application migration strategies](/azure/cloud-adoption-framework/infrastructure/mainframe-migration/application-strategies)

- To provide feedback or receive assistance, contact the [Microsoft Legacy Modernization ACE team](mailto:legacy2azure@microsoft.com). Along with Microsoft Certified Partners, the Legacy Modernization ACE team works with the world's top public and private sector organizations to modernize their legacy platforms.

  For more information about partners, see [Migration partners](https://techcommunity.microsoft.com/t5/azure-migration-and/mainframe-to-azure-partners/ba-p/3764426).

## Related resources

- [Azure mainframe and midrange architecture concepts and patterns](mainframe-midrange-architecture.md)
