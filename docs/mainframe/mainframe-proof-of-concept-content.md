# Mainframe workload migration proof of concept

This guide outlines key factors to consider when designing a proof of concept (POC) for migrating workloads from mainframes to the cloud. Historically, mainframes are the backbone of banking, aviation, and retail industries and support complex and mission-critical operations. In pursuit of enhanced scalability, cost efficiency, and technical agility, many organizations are now moving mainframe workloads to the cloud.

*Challenge*: The journey from a mainframe to the cloud, while promising, is complex and requires planning. No two mainframes are alike. They differ in their architecture, workload characteristics, software stack, internal integrations, and external integrations. The migration process varies widely when it comes to the scope, methodology, and benchmarks for success.

*Solution*: To address these challenges, a POC is a critical step on the migration roadmap. A well-conceived POC has clear objectives and success metrics. It paves the way for a seamless transition to the cloud. Treat a POC not just as a trial but as a comprehensive project that's complete with estimations, planning, and learning. The purpose of this guide is to steer your POC in a direction that's both custom fit to your environment and optimized in scope. You shouldn't need multiple POCs for a single migration.

## Identify the right solution pattern

A solution pattern is a predefined approach that can be adapted to address a customer's unique challenges within the context of their operations. In the early stages of the POC process, it's important to align the workload with an appropriate solution pattern that's based on the business and technical requirements. Identifying the right solution pattern is an iterative approach, and gaining familiarity with the common solution patterns is a prerequisite. As you gather business and technical criteria, you can refine and confirm your solution pattern selection.

Microsoft has four mainframe transformation solution patterns for migrating mainframe workloads to Azure: migrate, transform, re-envision, and extend.

[![Diagram that shows the four solution patterns: migrate, transform, re-envision, and extend.](./media/mainframe-solution-patterns.svg)](./media/mainframe-solution-patterns.svg)

- *Migrate*: Use this pattern to relocate the existing mainframe workload to Azure without altering the original codebase. You can use compilers that enable the legacy workloads to operate in the Azure environment.

- *Transform*: Use this pattern to refactor the existing legacy code into a modern language, such as Java or .NET. The restructured workload is designed to operate on contemporary platforms and use cloud-native technologies.
- *Re-envision*: Use this pattern to perform a complete overhaul of the mainframe workload. Incorporate modern development practices such as DevOps, containerization, and serverless computing to rebuild the workload for Azure.
- *Extend*: Use this pattern to integrate Azure services into a mainframe workload to improve it. Use REST APIs and integration platforms to expose a mainframe workload and its data to cloud-based services.

The best solution pattern is often a blend of these solution patterns and possibly other strategies, like in-place modernization or colocation. You need to tailor the strategies to meet specific migration goals and complement the existing technology stack.

In an initial assessment phase, examine common characteristics of your mainframe workload to help inform your strategy. Factors such as hardware specifications, application details, integration methods, and data structures are crucial for defining the POC scope. The following table describes characteristics to look for.

| Components | Common characteristics |
|---|---|
| Hardware | MIPS (million instructions per second), MSUs (million service units), LPARs (logical partitions)|
| Application | Programming languages and associated metadata|
| Application-specific roadmap | Decisions about whether to maintain, enhance, migrate, or eliminate |
| Integration types | Methods such as file transfers, message queues, sockets, APIs, replication, and change data capture (CDC) |
| Data structures | File types, datasets, database technologies                               |
| Dependencies| Inter-application and data dependencies, backups, and archival strategies |
| Security | Implemented protocols, such as RACF, ACF2, and Topsecret                           |
| Support | Skill sets within the technical team for maintaining the migrated environment |

As you prepare for the POC, you should review case studies that mirror your environment. Assess the methodologies that were used. Determine time frame estimates and costs associated with each potential solution to create a comparative analysis. Include common characteristics that are in the previous table. The POC and subsequent migration are specific to the chosen solution pattern.

## Define workload selection criteria

When you define workloads for a POC, consider the viability and the effect of the resulting migration. Aim to choose workloads that not only demonstrate the immediate benefits of a POC but also transition into full-scale migration. By treating a POC as a pilot, you can extract value in terms of cost, business functionality, and technical advancement. You can use a POC to quickly and efficiently perform cloud adoption.

### Define business criteria for workload selection

To select a workload, define the business criteria. Identify the key business factors and requirements that influence workloads for a POC. This step ensures that the workload you select aligns with the strategic business goals and drivers, such as cost reduction or critical-system modernization. This method helps determine workloads that offer the highest value and lowest risk, and it facilitates a more effective use of resources during the migration process.

#### Understand business drivers

Determine the underlying motives that drive the need for modernizing mainframe workloads. These motives include cost efficiencies, operational improvements, and strategic objectives. Align business drivers to demonstrate clear benefits, which helps secure stakeholder buy-in and justify investments in the migration project.

**Understand the criticality of workloads.** Workload criticality is a measure of the importance of a workload to the business. Understand the criticality of workloads to help you build a roadmap for modernization, which follows the POC. Carefully determine the right focus on the solution(s) that need proving. For example, you might select a workload for a POC, and the initial phase of migration might draw several dependencies to mission-critical workloads. This scenario might require you to include the dependencies in the scope, which drastically increases the complexity and risk of the migration.

**Prioritize workloads by the degree of associated risk.** Prioritize workloads by the use risks or current constraints of the environment. For example, retiring workload support resources, unsupported technical components, or business changes are driving factors to prioritize workloads for migration and reduce risk.

**Prepare personnel.** It’s important to identify the right support resources and make them available so you can validate the success of the POC. Group workloads by department to help limit the number of teams that are involved in the initial scope.

#### Establish POC goals

To establish POC goals, set clear objectives for the POC in terms of technical validation, business benefits, and strategic alignment. This method helps to guide the decision-making process. Choose workloads that demonstrate the POC's objectives and provide measurable outcomes that support the business case for migration. Examples of POC goals include:

- *Datacenter reduction or exit*: When you downsize or exit a datacenter, it's crucial to assess how the existing distributed and midrange systems interface with the mainframe. This evaluation helps to pinpoint which workloads are best-suited for the POC. Target workloads that are distributed and sensitive to latency to amplify the effect and potentially accelerate the modernization process and pave the way for a self-funded roadmap.

- *Mainframe consumption reduction*: Map workload usage for the POC to decrease the mainframe's operational footprint. This method helps to prevent further investment in capacity and sets the foundation for a cost-effective, streamlined operational environment.
- *Procurement model optimization*: A procurement model refers to the specific approach and terms under which an organization acquires and pays for its mainframe resources, both fixed and variable costs. Cost savings depend on the procurement model that's in place for the mainframe. The mainframe is a mix of fixed and variable costs, so it's essential to understand where variability lies within the model so you can realize cost savings.
- *Mainframe refresh alignment*: Coordinate your POC workload selection with your organization's mainframe refresh schedule. Prioritize workloads that reduce mainframe usage. This strategy aims to sync with hardware updates for optimal financial and operational efficiency.

#### Evaluate technical partners

Choosing the right partners for participation in the POC and any following migration phases is a critical step that significantly affects the project’s duration, effort, and cost. Consider the following recommendations when you select technical partners.

**Ensure continuity with your implementation partners.** It's important to work with the same partners from start to finish. They can be from your company or they can be outside vendors. Maintain the same team so you can use what they learn in the POC for later stages. Changing partners can cause problems because the new team might not understand the work that's complete.

**Use institutional knowledge.** Use the teams that already know your systems. These people, your employees or employees from other companies, know your system best. They can help plan the POC, pick the right tests, and determine the success criteria. Their knowledge helps ensure that the POC works for your business.

### Define technical criteria for workload(s) selection

From a technical standpoint, it’s important to identify the technical components in a mainframe ecosystem that present complexity in a migration and select a scope that is representative of those complexities. It's important to address complexity at this stage to derisk the subsequent stages of modernization along with identifying solution components for optimal design and architecture. Here are the technical factors that you should consider alongside the business aspects when selecting workload(s) for a migration POC.

**Pick the right technology mix.** Choose workloads or subsets that include various technologies. For instance, assembler programs might constitute a small part of the total codebase but typically are crucial due to their intensive usage. The chosen solution must cater to the unique demands of assembler language and its usage.

**Select different compilation parameters.** Select programs with diverse compilation parameters, such as COBOL and PL/I, to ensure minimal compatibility issues. This variety tests the POC against potential compatibility issues. Rehosting, refactoring, or other modernization strategies are scrutinized for tool or platform efficacy and customization options.

**Identify capability usage.** Pay special attention to batch processes and job control language (JCL) use cases. Identify and understand the specific functions of mainframe utilities like SORT or File Editors that might not have direct equivalents in modern solutions. Identifying these utilities helps avoid unexpected challenges later on. Workload programmers often taken advantage of the different capabilities provided by these utilities and not all capabilities have a direct map to the modernized solution.

**List integration patterns to test.** Testing integration patterns is important to ensure that the modernized workload works the same or better than the legacy environment. You need to determine what would be the most appropriate to prove out in the POC phase based on the usage, criticality, and unique nature of the type of integration. Focus on testing crucial integration patterns, such as between different workloads, data sets, and systems, including MQ with CICS, batch processes, secure file transfers, and others.

**Understand utilities and packaged software.** Acknowledge the need to migrate essential mainframe utilities and packaged software to Azure-based equivalents. Be clear about the need for both first-party and third-party solutions to replicate or replace current mainframe functionalities. For example, the mainframe workloads and data would be adhering to the security rules set up within RACF (Resource Access Control Facility) and ACF2 (Access Control Facility 2), among others. When these workloads are hosted on Azure, the security requirements would need to be adapted, adhered to using Microsoft Entra ID. Here are some utilities to consider:

- Microsoft Entra ID
- Azure DevOps
- Azure Monitor
- Scheduler
- Report
- Content storage
- Distribution
- Printer

**Define deliverables.** Define the deliverables to be provided at the end of the POC. We recommend the following deliverables:

- *Architecture overview*: Provide a detailed architecture model with a deployment view, ideally aligned with established Azure architecture patterns. For an example, see [Azure mainframe and midrange architecture concepts and patterns](/azure/architecture/mainframe/mainframe-midrange-architecture).
- *Azure landing zone artifacts*: Include scripts and other resources for the Azure Landing Zone that can be repurposed for broader use.
- *Modernized code and setup*: Host the updated source code on GitHub, complete with setup scripts, configuration details, and parameters.
- *Supporting documentation*: Deliver comprehensive documentation that includes nonfunctional requirements, design blueprints, and test plans. You should customize these factors to fit the scope of the POC.

## Design the target environment

As you prepare to migrate mainframe workloads, data, and utilities to Azure, it's crucial to carefully select and design the appropriate Azure services. Azure offers a comprehensive yet flexible environment that allows you to tailor your target architecture to dynamically scale and meet business demands using a consumption-based model. When adopting Azure’s pay-as-you-go model, consider the following factors in your design.

**Consider the performance aspects.** Mainframe workloads typically have specific performance requirements. The performance requirements include processing large volumes of data within specific time frame and accommodating a high volume of concurrent users. Define these performance benchmarks in your POC to ensure the chosen Azure solution meets or exceeds the legacy system's performance and user experience. For instance, validate the handling of heavy batch processing, simultaneous user access, and low-latency transactions.

**Design to scale.** In the POC phase, verify that the proposed solution can scale both vertically (increasing the power of existing instances) and horizontally (adding more instances). It allows you to evaluate how well the solution manages increased loads and transaction volumes with the chosen solution pattern(s) and products under consideration.

**Test file processing patterns.** Identify and test various file processing patterns during the POC. You should include assessing file volume, size, and types such as Virtual Storage Access Method (VSAM), Generation Data Group (GDG), Physical Sequential (PS), Key-Sequenced Data Set (KSDS), along with file operations like sequential and keyed reads. For example, determine how the Azure solution manages and catalogs GDG files in the cloud environment. Similarly, if migrating databases, include testing for database operation patterns and capabilities.

**Find Microsoft support.** The Microsoft Legacy Modernization team has Azure Core Engineering resources, Global Black Belts, Data Ninjas, and Cloud Solution Architects. You can use the [Mainframe landing zone accelerator](https://github.com/lapate/azure-mainframe-landing-zone-public) with a subset of partners for a POC. The Microsoft Mainframe Modernization team can also help to define an architecture specific to a solution path. Their help can accelerate deployment and improve the solution in Azure.

## Define proof of concept exit criteria

Defining success criteria is crucial for a Proof of Concept (PoC) because it helps to determine whether the PoC achieves its goals and objectives. Success criteria are measurable and specific indicators that are used to evaluate the effectiveness of a PoC. By defining success criteria, you can identify the key performance indicators (KPIs) to measure the success of the PoC. These criteria aren't only essential in gauging the PoC's effectiveness but also serve as a benchmark against the project's alignment with business goals and stakeholder expectations. Here's a checklist for designing your success and exit criteria:

- *Verification of deliverables*: Ensure you review, finalize, and accept all source code, configuration files, setup parameters, and documentation. Examples include the projected 'To-Be' architecture, Azure landing zone scripts, design documents, nonfunctional requirements, and test plans.
- *Finalization of the Azure target environment*: Confirm that the 'To-Be' Azure environment is fully defined and prepared for the actual migration and implementation process.
- *Assessment roadmap validation*: Review the recommendations made during the Assessment phase, adjusting them as necessary based on the PoC outcomes.
- *Establish workload-specific KPIs*: Set explicit success criteria for workload performance, including response times, job execution durations, and other critical technical Key Performance Indicators.
- *Documentation of migration insights*: Record all findings, challenges, and strategies required for an effective data migration, based on the learnings from the PoC.
- *Evaluation of project parameters*: Reassess and confirm the project's estimation, timeline, and the composition of the teams involved, including the customer, System Integrators (SIs), partners, and cloud providers. Amend the business case accordingly if necessary.
- *Review of technical resources*: Update the list of necessary software, tools, and accelerators in accordance with the initial Assessment phase's recommendations and any new insights gained during the PoC.
- *Executive summary presentation*: Prepare and deliver a comprehensive presentation of the PoC outcomes, lessons learned. Set expectations for the upcoming phases to senior management or the steering committee.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Shelby Howard](https://www.linkedin.com/in/shelbyhoward) | Senior Specialist, Global Black Belt Mainframe and Midrange Modernization Solutions
- [Venkataraman Ramakrishnan](https://www.linkedin.com/in/venkataramanr) | Senior Technical Program Manager, Azure Core Engineering
Mainframe and Midrange Modernization Solutions

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

To conclude, a POC with well-defined outcomes and success criteria can ensure success for Mainframe Modernization and Workload Migration. For more information on mainframe modernization solutions, architectural concepts, best practice, see:

- [Mainframe application migration strategies](/azure/cloud-adoption-framework/infrastructure/mainframe-migration/application-strategies)

Reach out to the Microsoft Legacy Modernization Azure Core Engineering (ACE) team for your feedback, further assistance, and information (`legacy2azure@microsoft.com`). The Legacy Modernization ACE team works with the world’s top public and private sector organizations to modernize their legacy platforms along with the right Microsoft Certified Partner. For more information on partners, see [Migration partners.](https://techcommunity.microsoft.com/t5/azure-migration-and/mainframe-to-azure-partners/ba-p/3764426)

## Related resources

- [Azure mainframe and midrange architecture concepts and patterns](mainframe-midrange-architecture.md)
