# Mainframe workload migration proof of concept

This guide outlines key factors to consider when designing a proof of concept (POC) for migrating workloads from mainframes to the cloud. Historically, mainframes are the backbone of banking, aviation, and retail industries and support complex and mission-critical operations. In pursuit of enhanced scalability, cost efficiency, and technical agility, many organizations are now moving mainframe workloads to the cloud.

*Challenge*: The journey from mainframe to cloud, while promising, is complex and requires planning. No two mainframes are alike. They differ in their architecture, workload characteristics, software stack, internal integrations, and external integrations. As such, the migration process isn't one-size-fits-all with its scope, methodology, and benchmarks for success varying widely.

*Solution*: To address these challenges, a proof of concept is a critical step in the migration roadmap. A well-conceived POC, defined by clear objectives and success metrics, paves the way for a seamless transition to the cloud. It should be treated not just as a trial but as a comprehensive project, complete with estimation, planning, and learning. The purpose of this guide is to steer your POC in a direction that is both custom-fit to your specific environment and optimized in scope. It removes the need for multiple POCs for a single migration.

## Identify the right solution pattern

A solution pattern is a predefined approach that can be adapted to address a customer's unique challenges within the context of their operations. In the early stages of the POC process, it's important to align the chosen workload with an appropriate solution pattern based on both business and technical requirements. Identifying the right solution pattern is an iterative approach, and gaining familiarity with the common solution patterns is a prerequisite. As you gather business and technical criteria, you refine and confirm your solution pattern selection.

Microsoft categorizes four mainframe transformation solution patterns for migrating mainframe workloads to Azure: migrate, transform, re-envision, and extend.

[![Diagram showing the four solution patterns: migrate, transform, re-envision, and extend.](./media/mainframe-solution-patterns.svg)](./media/mainframe-solution-patterns.svg)

*Figure 1. Microsoft’s mainframe transformation solution patterns*

- *Migrate*: This pattern involves relocating the existing mainframe workload to Azure without altering the original codebase, utilizing compilers that allow the legacy workloads to operate in the Azure environment.
- *Transform*: This pattern entails refactoring the existing legacy code into modern languages such as Java or .NET. The restructured workload is designed to operate on contemporary platforms and use cloud-native technologies.
- *Re-envision*: The re-envision pattern involves a complete overhaul of the mainframe workload. It incorporates modern development practices such as DevOps, containerization, and serverless computing to rebuild the workload for Azure.
- *Extend*: Opting for the extend pattern means enhancing the mainframe workloads by integrating Azure services. This pattern involves exposing mainframe workloads and data to cloud-based services using REST APIs and integration platforms.

Determining the most suitable solution pattern often requires a blend of these solution patterns and possibly other strategies like in-place modernization or colocation. You need to tailor the strategies to meet specific migration goals and complement the existing tech stack. Insights you glean from an initial assessment phase, which examines the common characteristics of mainframe workloads, should inform the strategy you select. Factors such as hardware specifications, application details, integration methods, and data structures *(see table 1)* are crucial for defining the POC's scope.

*Table 1: Mainframe components and common characteristics*

| Components | Common characteristics |
|---|---|
| Hardware | MIPS (Million Instructions Per Second), MSUs (Million Service Units), LPARs (Logical Partitions).|
| Application | Programming languages and associated metadata|
| Application-Specific Roadmap | Decisions on whether to maintain, enhance, migrate, or eliminate |
| Integration Types | Methods such as file transfers, message queue, sockets, APIs, replication, and change data capture (CDC) |
| Data Structures | File types, datasets, database technologies                               |
| Dependencies| Inter-application and data dependencies, backup, and archival strategies |
| Security | Implemented protocols, such as RACF, ACF2, Topsecret                           |
| Support | Skill set availability within the technical team for maintaining the migrated environment |

As you prepare for the POC, you should review case studies that mirror your environment and assess the methodologies applied. For a comparative analysis of different solution patterns, develop high-level estimates of time frames and costs associated with each potential solution, drawing on the information in the table provided. The POC and subsequent migration are specific to the chosen solution pattern(s).

## Define workload selection criteria

When defining workloads for a proof of concept (POC), consider both the viability and effect of the resulting migration. Aim to choose workloads that not only demonstrate the immediate benefits of a POC but also transition into full-scale migration. By treating a POC as a pilot, you can extract value in terms of cost, business functionality, and technical advancement. It allows you to set a quicker and more efficient course for cloud adoption.

### Define business criteria for workload selection

Defining business criteria for workload selection involves identifying the key business factors and requirements that influence the workloads you chose for a proof of concept. This step ensures the workload you select aligns with the strategic business goals and drivers, such as cost reduction or critical system modernization. Furthermore, it helps prioritize the efforts towards workloads that offer the highest value and lowest risk, and it facilitates a more effective use of resources during the migration process.

#### Understand business drivers

Understanding business drivers is about comprehending the underlying motives that drive the need for modernizing mainframe workloads. These motives include cost efficiencies, operational improvements, or strategic objectives. This alignment is essential to secure stakeholder buy-in and to justify the investment in the migration project by demonstrating clear business benefits.

**Understand the criticality of the workloads.** Workload criticality is a measure of the importance of a workload to the business. Understanding the criticality of the workloads can help when building the roadmap for modernization that follows the POC. Carefully determine the right focus on the solution(s) that need proving. For example, a workload might be selected for a POC, but the initial phase of migration might draw too many dependencies to mission critical workloads. This scenario might require the dependencies to be included in scope, drastically increasing complexity and risk of the migration.

**Prioritize workloads by degree of associated risk.** Use risks or current constraints of the environment to prioritize workloads. For example, retiring workload support resources, unsupported technical components, or business changes are driving factors to prioritize workloads for migration and reduce risk for the organization.

**Prepare personnel.** It’s important to have the right support resources identified and available to validate the success of the POC. Grouping the workloads by department might help to limit the number of teams involved in the initial scope.

#### Establish the POC goals

Establishing the POC goals means setting clear objectives for what the Proof of Concept aims to achieve in terms of technical validation, business benefits, and strategic alignment. It guides the decision-making process. It helps you choose workloads that demonstrate the POC's objectives and provide measurable outcomes that support the business case for migration. The following are examples of POC goals:

- *Data center reduction or exit*: When aiming to downsize or exit a data center, it's crucial to assess how the existing distributed and midrange systems interface with the mainframe. This evaluation aids in pinpointing which workloads are best suited for the Proof of Concept (POC). Targeting workloads that are distributed and sensitive to latency can amplify the effect, potentially accelerating the modernization process and paving the way for a self-funded roadmap.
- *Mainframe consumption reduction*: This objective is to map workload usage for the POC to decrease the mainframe's operational footprint. It helps to prevent further investment in capacity. This planning sets the foundation for a cost-effective, streamlined operational environment.
- *Procurement model optimization*: A procurement model refers to the specific approach and terms under which an organization acquires and pays for its mainframe resources, encompassing both fixed and variable costs. Cost savings depend on the procurement model in place for the mainframe. Since the mainframe is a mix of fixed and variable costs, it's essential to understand where variability lies within the model so you can realize cost savings.
- *Mainframe refresh alignment*: The goal is to coordinate POC workload selection with the organization's mainframe refresh schedule. It prioritizes workloads that reduce mainframe usage. This strategy aims to sync with hardware updates for optimal financial and operational efficiency.

#### Evaluate technical partners

Choosing the right partners for participation in both the POC and any following migration phases is a critical step that significantly affects the project’s duration, effort, and cost. Consider the following recommendations when selecting technical partners:

**Ensure implementation partner continuity.** It's important to work with the same partners from start to finish. Whether they are from your own company or outside vendors, keeping the same team helps use what they learn in the POC for later stages. Changing partners can cause problems because the new team might not understand the work done before.

**Use institutional knowledge.** Use the teams that already know your systems. These people, whether they are your employees or from another company, know your system best. They can help plan the POC well, pick the right tests, and decide what success looks like. Their knowledge helps ensure the POC works for your business.

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
- Content Storage
- Distribution
- Printer

**Define deliverables.** Define the deliverables to be provided at the end of the POC. We recommend the following deliverables:

- *Architecture overview*: Provide a detailed architecture model with a deployment view, ideally aligned with established Azure architecture patterns. For an example, see [Azure mainframe and midrange architecture concepts and patterns](/azure/architecture/mainframe/mainframe-midrange-architecture).
- *Azure landing zone artifacts*: Include scripts and other resources for the Azure Landing Zone that can be repurposed for broader use.
- *Modernized code and setup*: Host the updated source code on GitHub, complete with setup scripts, configuration details, and parameters.
- *Supporting documentation*: Deliver comprehensive documentation that includes nonfunctional requirements, design blueprints, and test plans. You should customize these factors to fit the scope of the POC.

## Design the target environment

As you prepare to migrate mainframe workloads, data, and utilities to Azure, it's crucial to carefully select and design the appropriate Azure services. Azure offers a comprehensive, yet flexible environment that allows you to tailor your target architecture to dynamically scale and meet business demands using a consumption-based model. When adopting Azure’s pay-as-you-go model, consider the following factors in your design:

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

## Next Steps

To conclude, a Proof of Concept (POC) with well-defined outcomes and success criteria can ensure success for Mainframe Modernization and Workload Migration. For more information on mainframe modernization solutions, architectural concepts, best practice, see:

- [Mainframe application migration strategies](/azure/cloud-adoption-framework/infrastructure/mainframe-migration/application-strategies)
- [Azure mainframe and midrange architecture concepts and patterns](/azure/architecture/mainframe/mainframe-midrange-architecture)

Reach out to the Microsoft Legacy Modernization Azure Core Engineering (ACE) team for your feedback, further assistance, and information (`legacy2azure@microsoft.com`). The Legacy Modernization ACE team works with the world’s top public and private sector organizations to modernize their legacy platforms along with the right Microsoft Certified Partner. For more information on partners, see [Migration partners.](https://techcommunity.microsoft.com/t5/azure-migration-and/mainframe-to-azure-partners/ba-p/3764426)

**Contributors**:

Shelby Howard - [Shelby Howard | LinkedIn](https://www.linkedin.com/in/shelbyhoward/)
Senior Specialist | Global Black Belt
Mainframe and Midrange Modernization Solutions
Microsoft

Venkataraman Ramakrishnan - [Venkataraman Ramakrishnan | LinkedIn](https://www.linkedin.com/in/venkataramanr/)
Senior Technical Program Manager | Azure Core Engineering
Mainframe and Midrange Modernization Solutions
Microsoft