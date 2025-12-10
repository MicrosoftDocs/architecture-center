[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This architecture shows a process automation system that uses multiple AI agents. The agents are deployed into Azure Container Apps and use Azure AI services. This architecture's agents and orchestration behavior are defined in custom software with Microsoft Agent Framework. The architecture hosts specialized multiple AI agents that coordinate and run organizational tasks automatically.

This article highlights the infrastructure and DevOps aspects of how to manage multiple-agent systems on Azure, including continuous integration, data persistence, and agent coordination.

The architecture describes how to build scalable automation pipelines in which multiple AI agents collaborate through a central API orchestrator. It supports persistent learning and automated deployment processes for enterprise-grade task automation.

## Architecture

:::image type="complex" border="false" source="./_images/multiple-agent-workflow-automation.svg" alt-text="Diagram that shows a typical multiple-agent architecture." lightbox="./_images/multiple-agent-workflow-automation.svg":::
   The diagram shows six numbered workflow steps across multiple Azure services. In step one, users access the App Service website to submit automation requests. In step two, the App Service website sends requests to the Container Apps API agent orchestration layer, which breaks down tasks and determines the required AI agents. Step three shows how the Container Apps API connects to the Azure AI Foundry GPT-4o model to coordinate specialized AI agents that collaborate on task operations. In step four, the Container Apps API stores and retrieves task data, plans, and historical information in Azure Cosmos DB for persistence and learning. In step five, the GitHub source repository triggers automated builds that create Docker container images. In step six, Docker builds are pushed to Azure Container Registry, which stores versioned images for both the App Service website and the Container Apps API components.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/multiple-agent-workflow-automation.vsdx) of this architecture.*

### Workflow

The following workflow corresponds to the previous diagram:

1. Employees access the web front end to request and manage automated solutions. Tasks are submitted through the web interface with specific requirements and parameters.

1. The Azure App Service website receives the user request from the front end and calls an API hosted in Container Apps. That API processes the incoming task and determines which specialized AI agents are needed. The task is broken down into component parts for multiple-agent coordination.

1. The Container Apps API connects to an Azure AI Foundry-hosted GPT-4o model. Multiple specialized AI agents are orchestrated to handle different aspects of the task. Agents collaborate to plan, carry out, and validate the tasks to be done.

1. Azure Cosmos DB stores all data related to current and past plans and solutions. Historical task data and patterns are maintained for learning and optimization purposes. Agent decisions and outcomes are persisted for future reference.

1. Azure Container Registry manages images for the front-end website and back-end API. This registry also maintains versioned container images for rollback capabilities.

1. The GitHub source repository triggers automatic builds of website and API server images on code updates. Docker then builds and deploys the updated container images to the registry.

### Components

- [App Service](/azure/well-architected/service-guides/app-service-web-apps) is a platform as a service solution that provides a scalable web hosting environment for applications. In this architecture, the App Service website serves as the front-end interface for users to request and manage automated solutions. It provides a responsive web experience for submitting tasks and tracking their progress.

- [Container Apps](/azure/well-architected/service-guides/azure-container-apps) is a serverless container platform that enables you to run microservices and containerized applications on a serverless platform. In this architecture, the Container Apps API serves as the central orchestration layer that processes user requests, coordinates multiple AI agents, and manages the completion state of tasks. It hosts the custom-developed code created by your software team that uses Microsoft Agent Framework.

- [Azure AI Foundry](/azure/ai-foundry/what-is-azure-ai-foundry) is a managed AI service that provides access to advanced language models for natural language processing and generation. In this architecture, Azure AI Foundry provides models as a service for the Microsoft Agent Framework-based agents to invoke.

- [Azure Cosmos DB](/azure/well-architected/service-guides/cosmos-db) is a globally distributed, multiple-model database service that provides low latency and elastic scalability. In this architecture, Azure Cosmos DB stores all data related to current and past automation plans and solutions. The Container Apps API writes data when new plans are created or tasks are run. The API reads data when users access their automation history via the App Service website.

- [Container Registry](/azure/container-registry/) is a managed Docker registry service that stores and manages container images. In this architecture, Container Registry manages images for both the front-end website and back-end API. This setup ensures consistent deployment and version control of the multiple-agent system components across environments.

## Scenario details

This custom, multiple-agent automation engine addresses the challenge of coordinating complex, cross-departmental business processes that traditionally required significant manual oversight and coordination. Organizations often struggle with tasks that span multiple areas of expertise, demand consistent performance across teams, and require audit trails to support compliance.

This solution uses custom-coded, specialized AI agents that collaborate to break down complex organizational tasks into manageable components. Each agent contributes domain-specific knowledge and capabilities. This approach enables the system to manage sophisticated workflows that would otherwise require human coordination across multiple departments. The architecture scales through containerized deployment, preserves learning via persistent data storage, and supports continuous improvement through automated integration and delivery pipelines.

Other applications of this architecture are in code modernization and legacy system migration, where organizations face the dual challenge of technical complexity and business continuity requirements. Legacy systems often lack proper documentation, contain outdated programming languages, and embed critical business logic that must be preserved during migration. The multiple-agent approach works by coordinating specialized expertise across technical translation, business analysis, quality assurance, and documentation generation.

### Potential use cases

Consider the following potential use cases for multiple-agent workflow automation.

#### Code modernization and migration

**Legacy SQL query translation:** Coordinate multiple specialized agents to translate SQL queries across different database dialects while you preserve business logic and performance characteristics. A SQL analysis agent identifies dialect-specific constructs. A translation agent converts syntax to the target platform. A validation agent tests query equivalence. A documentation agent generates migration notes. This approach addresses the common challenge of maintaining functional equivalence when you migrate from platforms like Oracle to Azure SQL Database or PostgreSQL.

**Legacy application modernization:** Orchestrate agents that specialize in code analysis, business logic extraction, architecture assessment, and modernization planning. Agents collaborate to analyze legacy codebases, extract embedded business rules, assess technical debt, generate modernization roadmaps, and create comprehensive documentation that captures institutional knowledge often lost during transitions.

**Database schema migration:** Coordinate agents for schema analysis, data type mapping, constraint translation, and validation testing. The multiple-agent system ensures that complex database structures, relationships, and business rules are accurately translated while it maintains data integrity and performance requirements.

#### Enterprise process automation

**Employee onboarding orchestration:** Coordinate IT provisioning, HR documentation, facility access, training schedules, and compliance requirements across multiple departments.

**Contract management workflow:** Automate legal review, procurement approval, financial analysis, and vendor communication for complex business agreements.

**Incident response coordination:** Orchestrate technical remediation, stakeholder communication, documentation, and post-incident analysis across IT, security, and business teams.

#### Financial services and compliance

**Regulatory compliance automation:** Coordinate data collection, analysis, reporting, and submission across multiple regulatory frameworks simultaneously.

**Loan processing pipeline:** Automate credit analysis, risk assessment, documentation review, and approval workflows that include multiple specialist teams.

**Audit preparation management:** Coordinate evidence gathering, documentation preparation, stakeholder interviews, and compliance verification across business units.

#### Healthcare and research

**Clinical trial management:** Orchestrate patient recruitment, regulatory compliance, data collection, safety monitoring, and reporting across research teams.

**Patient care coordination:** Automate scheduling, treatment planning, insurance verification, and care team communication for complex medical cases.

**Medical equipment procurement:** Coordinate clinical requirements, technical specifications, vendor evaluation, and regulatory approval processes.

#### Manufacturing and supply chain

**Product launch coordination:** Orchestrate design finalization, manufacturing setup, quality assurance, marketing preparation, and distribution planning.

**Supplier onboarding process:** Automate qualification assessments, contract negotiations, system integrations, and performance monitoring setup.

**Quality incident management:** Coordinate investigation, root cause analysis, corrective actions, and supplier communication for problems with quality.

## Alternatives

This architecture includes multiple components that you can substitute with other Azure services or approaches, depending on your workload's functional and nonfunctional requirements. Consider the following alternatives and trade-offs.

### Agent orchestration

**Current approach:** This solution uses custom agent code, written with the Microsoft Agent Framework SDK, to orchestrate agents and their interactions. Container Apps serves as the central orchestrator compute that runs the code. The code coordinates the multiple AI agents that operate on active workflows. This approach is a code-first solution that provides maximum control over agent behavior, orchestration logic, and compute scale.

**Alternative approach:** Use Azure AI Foundry Agent Service to define agents and connect them individually to relevant knowledge stores and tools. This approach is a no-code solution where you define agent behavior and agent relationships through a system prompt. The agents are hosted on your behalf, and you have no control over the compute that runs the agents.

Consider this alternative if your workload has the following characteristics:

- You don't require deterministic agent orchestration. You can sufficiently define agent behavior, including knowledge store access and tool use, through a system prompt.

- You don't require full control of your agents' compute.

- You only need HTTPS-accessible tools, and your knowledge stores are compatible with Foundry Agent Service.

For organizations that have mixed requirements, a hybrid approach can be effective. Standard workflows use Foundry Agent Service while critical or highly customized processes use self-hosted orchestration on Container Apps.

## Multi-agent orchestration patterns

When you design multi-agent automation systems, consider how agents must coordinate to accomplish complex workflows. This architecture uses a custom orchestrator that manages agent interactions, but the coordination patterns that you choose significantly affect system performance and reliability. Sequential patterns suit dependent tasks like document approval workflows. Concurrent patterns suit independent operations like data collection from multiple sources. Group chat patterns enable collaborative problem-solving. Handoff patterns give specialized agents the ability to handle different workflow phases. For detailed guidance about how to implement these coordination strategies, see [AI agent orchestration patterns](/azure/architecture/ai-ml/guide/ai-agent-design-patterns). This article provides architectural patterns and implementation considerations for various multi-agent scenarios.

## Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

For more information about the costs of running this scenario, see the preconfigured estimate in the [Azure pricing calculator](https://azure.com/e/82efdb5321cc4c58aafa84607f68c24a).

Pricing varies by region and usage, so it's not possible to predict exact costs in advance. Most Azure resources in this infrastructure follow usage-based pricing models. But Container Registry incurs a daily fixed cost for each registry.

## Deploy this scenario

To deploy an implementation of this architecture, follow the steps in the [GitHub repo](https://github.com/microsoft/Multi-Agent-Custom-Automation-Engine-Solution-Accelerator).

### Code modernization implementation

For specific implementation of the multi-agent workflows that carry out SQL query modernization, see [Modernize your code implementation](https://github.com/microsoft/Modernize-your-code-solution-accelerator). It demonstrates how multiple AI agents coordinate to translate SQL queries between different database dialects. It also generates documentation and validation reports throughout the process.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Solomon Pickett](https://www.linkedin.com/in/gregory-solomon-pickett-307560130/) | Software Engineer II

Other contributor:

- [Mark Taylor](https://www.linkedin.com/in/mark-taylor-5043351/) | Principal Software Engineer

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Overview of the Agent architecture](/semantic-kernel/frameworks/agent/agent-architecture) that uses Microsoft Agent Framework
- [Foundry Agent Service documentation](/azure/ai-foundry/agents/overview)
