[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This architecture shows a multi-agent AI automation system deployed using Azure container services and AI platforms. It describes a foundational configuration that leverages specialized AI agents to coordinate and execute complex organizational tasks automatically. This article assumes that you have a basic understanding of containerized applications and AI orchestration concepts. The article primarily highlights the infrastructure and DevOps aspects of how to manage multi-agent systems on Azure, including continuous integration, data persistence, and agent coordination. For more information about designing AI agent architectures, see Multi-agent systems design patterns.

The architecture demonstrates how to build scalable automation pipelines where multiple AI agents collaborate through a central API orchestrator, with persistent learning capabilities and automated deployment processes for enterprise-grade task automation.

## Architecture

:::image type="complex" border="false" source="./_images/Multi-agent-workflow-automation.png" alt-text="Diagram that shows a typical multi-agent architecture." lightbox="./_images/Multi-agent-workflow-automation.png":::
   <Long description that ends with a period.>
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/multi-agent-workflow-automation.vsdx) of this architecture.*

### Workflow

The following workflow corresponds to the preceding diagram:

1. User Input & Task Specification: Users access the Web Front-end to request and manage automated solutions
Tasks are submitted through the web interface with specific requirements and parameters

2. Task Processing & Orchestration: App Service Website receives the user request from the frontend
Container App API processes the incoming task and determines which specialized AI agents are needed
Task is broken down into component parts for multi-agent coordination

3. Agent Coordination & AI Processing: Container App API connects to Azure AI Foundry GPT-4o model
Multiple specialized AI agents are orchestrated to handle different aspects of the task
Agents collaborate to plan, execute, and validate the automated solution

4. Data Storage & Retrieval: Azure Cosmos DB stores all data related to current and past plans/solutions
Historical task data and patterns are maintained for learning and optimization
Agent decisions and outcomes are persisted for future reference

5. Container Management & Deployment: Container Registry manages images for frontend website and backend API
Ensures consistent deployment of agent services across environments
Maintains versioned container images for rollback capabilities

6. CI/CD Pipeline & Automation: Source Repository (GitHub) triggers automatic updates when code changes
Docker builds and deploys updated container images to the registry
Website and API server images are generated automatically on code updates
Continuous integration ensures rapid deployment of improvements

### Components

- [Azure App Service](https://azure.microsoft.com/en-us/products/app-service/) is a platform as a service (PaaS) solution that provides a scalable web hosting environment for applications. In this architecture, App Service Website serves as the frontend interface where users can request and manage automated solutions, providing a responsive web experience for task submission and monitoring.

- [Azure Container App](https://azure.microsoft.com/en-us/products/container-apps/)is a serverless container platform that enables you to run microservices and containerized applications on a serverless platform. In this architecture, the Container App API serves as the central orchestration layer that processes user requests, coordinates multiple AI agents, and manages the execution of complex automated tasks.

- [Azure AI Foundry](https://azure.microsoft.com/en-us/products/ai-foundry/) is a managed AI service that provides access to advanced language models for natural language processing and generation. In this architecture, the GPT-4o model powers the specialized AI agents that collaborate to plan, execute, and validate automated solutions based on user input and business requirements.

- [Azure Cosmos DB](https://azure.microsoft.com/en-us/products/cosmos-db/) is a globally distributed, multi-model database service that provides guaranteed low latency and elastic scalability. In this architecture, Cosmos DB stores all data related to current and past automation plans and solutions, enabling agents to learn from historical patterns and maintain consistency across task executions.

- [Azure Container Registry](https://azure.microsoft.com/en-us/products/container-registry/) is a managed Docker registry service that stores and manages container images. In this architecture, Container Registry manages images for both the frontend website and backend API, ensuring consistent deployment and version control of the multi-agent system components across environments.

## Scenario details

This custom, multi-agent automation engine addresses the challenge of coordinating complex, multi-departmental business processes that traditionally require significant manual oversight and coordination. Organizations often struggle with tasks that span multiple domains of expertise, require consistent execution across different teams, and need to maintain audit trails for compliance purposes.

This solution uses custom coded, specialized AI agents that work collaboratively to break down complex organizational tasks into manageable components. Each agent brings domain-specific knowledge and capabilities, enabling the system to handle sophisticated workflows that would typically require human coordination across multiple departments. The architecture ensures scalability through containerized deployment, maintains learning through persistent data storage, and provides continuous improvement through automated CI/CD pipelines.

### Potential use cases

Enterprise Process Automation

Employee Onboarding Orchestration: Coordinate IT provisioning, HR documentation, facility access, training schedules, and compliance requirements across multiple departments
Contract Management Workflow: Automate legal review, procurement approval, financial analysis, and vendor communication for complex business agreements
Incident Response Coordination: Orchestrate technical remediation, stakeholder communication, documentation, and post-incident analysis across IT, security, and business teams

Financial Services & Compliance

Regulatory Compliance Automation: Coordinate data collection, analysis, reporting, and submission across multiple regulatory frameworks simultaneously
Loan Processing Pipeline: Automate credit analysis, risk assessment, documentation review, and approval workflows involving multiple specialist teams
Audit Preparation Management: Coordinate evidence gathering, documentation preparation, stakeholder interviews, and compliance verification across business units

Healthcare & Research

Clinical Trial Management: Orchestrate patient recruitment, regulatory compliance, data collection, safety monitoring, and reporting across research teams
Patient Care Coordination: Automate scheduling, treatment planning, insurance verification, and care team communication for complex medical cases
Medical Equipment Procurement: Coordinate clinical requirements, technical specifications, vendor evaluation, and regulatory approval processes

Manufacturing & Supply Chain

Product Launch Coordination: Orchestrate design finalization, manufacturing setup, quality assurance, marketing preparation, and distribution planning
Supplier Onboarding Process: Automate qualification assessments, contract negotiations, system integrations, and performance monitoring setup
Quality Incident Management: Coordinate investigation, root cause analysis, corrective actions, and supplier communication for quality issues


### Alternatives

If you don't require the full flexibility and control of self-hosted agent orchestration, you can implement Azure AI Foundry's managed agent services to benefit from reduced operational complexity. You could use Azure AI Foundry Agent Hub with pre-built orchestration templates that handle agent coordination automatically. The Container App API and Cosmos DB can use the same configurations as the original architecture.

The benefits of using managed agent services include reduced development time and operational overhead. If you don't have specific business requirements for custom agent logic or complex integration patterns, use Azure AI Foundry's managed approach to eliminate the need for building custom orchestration frameworks. This approach also helps ensure that multi-agent workflows scale automatically and benefit from built-in monitoring capabilities.

Alternatively, if you require maximum control over agent behavior and have complex enterprise integration requirements, consider implementing self-hosted Semantic Kernel orchestration. This approach provides complete customization of agent logic, specialized plugin development, and the ability to integrate with legacy systems or proprietary protocols. While this increases development complexity, it offers greater flexibility for organizations with unique automation requirements or strict compliance needs.

For organizations with mixed requirements, a hybrid approach can be effective where standard workflows use Azure AI Foundry's managed services while critical or highly customized processes use self-hosted orchestration through the same Container App API interface.

## Cost Optimization

Cost Optimization is about reducing unnecessary expenses and improving operational efficiencies. For more information, see Design review checklist for Cost Optimization.

For information about the costs of running this scenario, see this preconfigured [estimate in the Azure pricing calculator](https://azure.com/e/86d0eefbe4dd4a23981c1d3d4f6fe7ed).

Pricing varies per region and usage, so it isn't possible to predict exact costs for your usage. The majority of the Azure resources used in this infrastructure are on usage-based pricing tiers. However, Azure Container Registry has a fixed cost per registry per day.

## Deploy this scenario

To deploy the reference implementation for this architecture, follow the steps in the [GitHub repo](https://github.com/microsoft/Multi-Agent-Custom-Automation-Engine-Solution-Accelerator).

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Solomon Pickett](https://www.linkedin.com/in/ProfileURL/) | Software Engineer II


Other contributors:

- [Mark Taylor](https://www.linkedin.com/in/mark-taylor-5043351/) | Principal Software Engineer


*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Overview of Agent Architecture](https://learn.microsoft.com/en-us/semantic-kernel/frameworks/agent/agent-architecture?pivots=programming-language-csharp)


