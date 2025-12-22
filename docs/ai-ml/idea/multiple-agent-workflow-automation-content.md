[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This architecture describes a process automation system that uses multiple specialized AI agents to coordinate and run organizational tasks automatically.

Multiple AI agents collaborate through a central API orchestrator to build scalable automation pipelines. Custom software that uses Microsoft Agent Framework defines the agent and orchestration behavior, and you deploy the agents in Azure Container Apps where they use Azure AI services.

This article focuses on the infrastructure and DevOps aspects of managing multiple-agent systems on Azure. It covers continuous integration, data persistence, agent coordination, and automated deployment processes for enterprise-grade task automation.

## Architecture

:::image type="complex" border="false" source="./_images/multiple-agent-workflow-automation.svg" alt-text="Diagram that shows a typical multiple-agent architecture." lightbox="./_images/multiple-agent-workflow-automation.svg":::
   The diagram shows six numbered workflow steps across multiple Azure services. In step one, users access the Azure App Service website to submit automation requests. In step two, the App Service website sends requests to the Container Apps API agent orchestration layer, which breaks down tasks and determines the required AI agents. Step three shows how the Container Apps API connects to the Microsoft Foundry GPT-4o model to coordinate specialized AI agents that collaborate on task operations. In step four, the Container Apps API stores and retrieves task data, plans, and historical information in Azure Cosmos DB for persistence and learning. In step five, the GitHub source repository triggers automated builds that create Docker container images. In step six, Docker builds are pushed to Azure Container Registry, which stores versioned images for both the App Service website and the Container Apps API components.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/multiple-agent-workflow-automation.vsdx) of this architecture.*

### Workflow

The following workflow corresponds to the previous diagram:

1. Employees access the web front end to request and manage automated solutions. They submit tasks that have specific requirements and parameters through the web interface.

1. The Azure App Service website receives the user request from the front end and calls an API hosted in Container Apps. The API processes the incoming task and determines which specialized AI agents to use. The API separates the task into component parts for multiple-agent coordination.

1. The Container Apps API connects to a Microsoft Foundry-hosted GPT-4o model. The API orchestrates multiple specialized AI agents to handle different aspects of the task. Agents collaborate to plan, perform, and validate the required tasks.

1. Azure Cosmos DB stores all data related to current and past plans and solutions. It maintains historical task data and patterns for learning and optimization purposes. It also persists agent decisions and outcomes for future reference.

1. Azure Container Registry manages images for the front-end website and back-end API. This registry also maintains versioned container images for rollback capabilities.

1. The GitHub source repository triggers automatic builds of website and API server images on code updates. Docker then builds and deploys the updated container images to the registry.

### Components

- [App Service](/azure/well-architected/service-guides/app-service-web-apps) is a platform as a service (PaaS) solution that provides a scalable web hosting environment for applications. In this architecture, the App Service website serves as the front-end interface for users to request and manage automated solutions. It provides a responsive web experience for submitting tasks and tracking their progress.

- [Container Apps](/azure/well-architected/service-guides/azure-container-apps) is a serverless container platform that lets you run microservices and containerized applications on a serverless platform. In this architecture, the Container Apps API serves as the central orchestration layer that processes user requests, coordinates multiple AI agents, and manages the completion state of tasks. It hosts the custom code that your software team develops by using Agent Framework.

- [Foundry](/azure/ai-foundry/what-is-azure-ai-foundry) is a unified Azure PaaS offering for enterprise AI operations, model builders, and application development. It combines production-grade infrastructure with developer-friendly interfaces, which lets developers focus on building applications rather than managing infrastructure. In this architecture, Foundry provides the foundation for deploying and managing AI models in chat interface and serves as the gateway to connected AI services, like Foundry Agent Service.

  [Foundry Agent Service](/azure/ai-foundry/agents/overview) is a managed runtime service that connects the core pieces of Foundry, like models, tools, and frameworks, into a single agentic runtime. It manages conversations, orchestrates tool calls, enforces content safety, and integrates with identity, networking, and observability systems. In this architecture, the application invokes Foundry Agent Service to power the agent conversations.

- [Azure Cosmos DB](/azure/well-architected/service-guides/cosmos-db) is a globally distributed, multiple-model database service that provides low latency and elastic scalability. In this architecture, Azure Cosmos DB stores all data related to current and past automation plans and solutions. The Container Apps API writes data when it creates new plans or runs tasks. The API reads data when users access their automation history via the App Service website.

- [Container Registry](/azure/container-registry/container-registry-intro) is a managed Docker registry service that stores and manages container images. In this architecture, Container Registry manages images for both the front-end website and the back-end API. This setup ensures consistent deployment and version control of the multiple-agent system components across environments.

### Alternatives

This architecture includes a component that you can substitute with another Azure service or approach, depending on your workload's functional and nonfunctional requirements. Consider the following alternative and trade-offs.

#### Agent orchestration

**Current approach:** This solution uses custom agent code, written with the Agent Framework SDK, to orchestrate agents and their interactions. Container Apps serves as the central orchestrator compute that runs the code. The code coordinates the multiple AI agents that operate on active workflows. This code-first solution provides maximum control over agent behavior, orchestration logic, and compute scale.

**Alternative approach:** Use Foundry Agent Service to define agents and connect them individually to relevant knowledge stores and tools. In this no-code solution, you define agent behavior and agent relationships through a system prompt. Foundry Agent Service hosts and manages the agents, so you don't control the compute that runs the agents.

Consider this alternative if your workload has the following characteristics:

- You don't require deterministic agent orchestration. You can sufficiently define agent behavior, including knowledge store access and tool use, through a system prompt.

- You don't require full control of your agents' compute.

- You only need tools reachable via HTTPS, and Foundry Agent Service supports your knowledge stores.

If your organization has mixed requirements, you can use a hybrid approach. Use Foundry Agent Service for standard workflows and Container Apps for critical or highly customized processes that require more control.

## Scenario details

This custom, multiple-agent automation engine addresses the challenge of coordinating complex, cross-departmental business processes that traditionally require significant manual oversight and coordination. Organizations often struggle with tasks that span multiple areas of expertise, demand consistent performance across teams, and require audit trails to support compliance.

This solution uses custom-coded, specialized AI agents that collaborate to divide complex organizational tasks into manageable components. Each agent applies its specific knowledge and capabilities. The system manages sophisticated workflows that otherwise require human coordination across multiple departments. The architecture scales through containerized deployment, preserves learning via persistent data storage, and supports continuous improvement through automated integration and delivery pipelines.

You can also apply this architecture to code modernization and legacy system migration, which includes challenges like technical complexity and business continuity requirements. Legacy systems often lack proper documentation, use outdated programming languages, and contain critical business logic that you must preserve. The multiple-agent approach coordinates specialized expertise across technical translation, business analysis, quality assurance, and documentation generation.

### Potential use cases

Consider the following potential use cases for multiple-agent workflow automation.

#### Code modernization and migration

- **Legacy SQL query translation:** Coordinate multiple specialized agents to translate SQL queries across different database dialects while you preserve business logic and performance characteristics.

   - A SQL analysis agent identifies dialect-specific constructs.
   
   - A translation agent converts syntax to the target platform.
   
   - A validation agent tests query equivalence.
    
   - A documentation agent generates migration notes.
    
  This approach addresses the common challenge of maintaining functional equivalence when you migrate from platforms like Oracle to Azure SQL Database or Azure Database for PostgreSQL.

- **Legacy application modernization:** Orchestrate agents that specialize in code analysis, business logic extraction, architecture assessment, and modernization planning. Agents collaborate to analyze legacy codebases, extract embedded business rules, assess technical debt, generate modernization roadmaps, and create documentation that captures institutional knowledge often lost during transitions.

- **Database schema migration:** Coordinate agents for schema analysis, data type mapping, constraint translation, and validation testing. The multiple-agent system accurately translates complex database structures, relationships, and business rules while it maintains data integrity and performance requirements.

#### Enterprise process automation

- **Employee onboarding orchestration:** Coordinate IT provisioning, human resources (HR) documentation, facility access, training schedules, and compliance requirements across multiple departments.

- **Contract management workflow:** Automate legal review, procurement approval, financial analysis, and vendor communication for complex business agreements.

- **Incident response coordination:** Orchestrate technical remediation, stakeholder communication, documentation, and post-incident analysis across IT, security, and business teams.

#### Financial services and compliance

- **Regulatory compliance automation:** Coordinate data collection, analysis, reporting, and submission across multiple regulatory frameworks simultaneously.

- **Loan processing pipeline:** Automate credit analysis, risk assessment, documentation review, and approval workflows that include multiple specialist teams.

- **Audit preparation management:** Coordinate evidence gathering, documentation preparation, stakeholder interviews, and compliance verification across business units.

#### Healthcare and research

- **Clinical trial management:** Orchestrate patient recruitment, regulatory compliance, data collection, safety monitoring, and reporting across research teams.

- **Patient care coordination:** Automate scheduling, treatment planning, insurance verification, and care team communication for complex medical cases.

- **Medical equipment procurement:** Coordinate clinical requirements, technical specifications, vendor evaluation, and regulatory approval processes.

#### Manufacturing and supply chain

- **Product launch coordination:** Orchestrate design finalization, manufacturing setup, quality assurance, marketing preparation, and distribution planning.

- **Supplier onboarding process:** Automate qualification assessments, contract negotiations, system integrations, and performance monitoring setup.

- **Quality incident management:** Coordinate investigation, root cause analysis, corrective actions, and supplier communication for problems with quality.

## Multiple-agent orchestration patterns

When you design multiple-agent automation systems, consider how agents must coordinate to accomplish complex workflows. This architecture uses a custom orchestrator that manages agent interactions, but the coordination patterns that you choose significantly affect system performance and reliability.

Sequential patterns suit dependent tasks like document approval workflows. Concurrent patterns suit independent operations like data collection from multiple sources. Group chat patterns enable collaborative problem-solving. Handoff patterns give specialized agents the ability to handle different workflow phases. For more information about how to implement these coordination strategies, see [AI agent orchestration patterns](/azure/architecture/ai-ml/guide/ai-agent-design-patterns). This article provides architectural patterns and implementation considerations for various multiple-agent scenarios.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

For more information about the costs of running this scenario, see the [preconfigured estimate in the Azure pricing calculator](https://azure.com/e/b00c1854756f4687a4fcbe0916951aba).

Pricing varies by region and usage, so you can't predict exact costs in advance. Most Azure resources in this infrastructure follow usage-based pricing models. But Container Registry incurs a daily fixed cost for each registry.

## Deploy this scenario

To deploy an implementation of this architecture, follow the [steps in the GitHub repo](https://github.com/microsoft/Multi-Agent-Custom-Automation-Engine-Solution-Accelerator).

### Code modernization implementation

For specific implementation of the multiple-agent workflows that perform SQL query modernization, see [Modernize your code implementation](https://github.com/microsoft/Modernize-your-code-solution-accelerator). This implementation demonstrates how multiple AI agents coordinate to translate SQL queries between different database dialects. It also generates documentation and validation reports throughout the process.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Solomon Pickett](https://www.linkedin.com/in/gregory-solomon-pickett-307560130/) | Software Engineer II

Other contributors:

- [Anish Arora](https://www.linkedin.com/in/aniarora/) | Senior Software Engineer
- [Malory Rose](https://www.linkedin.com/in/malory-rose-8aa503135/) | Senior Software Engineer
- [Mark Taylor](https://www.linkedin.com/in/mark-taylor-5043351/) | Principal Software Engineer

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Overview of the Agent Framework architecture](/semantic-kernel/frameworks/agent/agent-architecture)
- [Foundry Agent Service documentation](/azure/ai-foundry/agents/overview)
