Security Operations Center teams experience challenges when integrating Microsoft Sentinel with Azure DevOps. The process involves many steps and the setup can take days with constant repetition. You can automate this part of the development.

Cloud modernization means engineers must constantly learn new skills and techniques for securing and protecting vital business assets. Engineers must build robust and scalable solutions that keep pace with the ever-changing security landscape and business needs. The security solution must be flexible, agile, and carefully planned from the earliest stages of development (shift-left).

This article shows you how to automate Microsoft Sentinel integration and deployment operations with Azure DevOps. You implement Azure DevOps using several Sentinel capabilities to secure your deployment. Then, you employ DevSecOps framework to manage and deploy Microsoft Sentinel artifacts at scale.

You can even expand the solution to cover more complex organizations that have multiple entities, subscriptions, and various operating models. Some of the operating models supported by this solution include: Local SOC, Global SOC, Cloud Service Provider (CSP), and Managed Security Service Provider (MSSP).

The audiences for this article:

* SOC Specialists (Analysts and Threat Hunters)
* SIEM Engineers
* Cybersecurity Architects
* Developers

## Potential use cases

The typical use cases for this architecture include:

* Rapid prototyping and Proof of Concept: Ideal for security organizations and SOC wanting to improve Cloud threat coverage or modernize their SIEM infrastructure with Infra as Code and Microsoft Sentinel.

* Sentinel as a Service: Our development framework integrates service lifecycle management principles. These principles are suitable for simple or complex organizations like Managed Security Service Providers (MSSPs) who run repeatable, standardized actions across multiple customer tenants while combining the power of Azure DevOps & Azure Lighthouse. For example, an organization that needs to publish Sentinel use cases for a new threat actor or ongoing campaign.

* Building SOC use case for Threat detection: Many organizations and threat intelligence platforms rely on Mitre Att&ck content and taxonomy to analyze their Security Posture against advanced tradecraft or Techniques and Tactics Procedures. The solution defines a structured approach for developing threat detection engineering practices, by incorporating Mitre Att&ck terminology within Microsoft Sentinel artifacts development. The following illustration shows a Mitre Att&ck Cloud scenarios:


## Architecture

_Architecture diagram goes here_

> Under the architecture diagram, include this sentence and a link to the Visio file or the PowerPoint file: 

_Download a [Visio file](https://arch-center.azureedge.net/[filename].vsdx) of this architecture._

### Dataflow

1. The Scrum Master and product management use Azure DevOps to define Epics, User Stories, and Product Backlog Items as part of the project backlog.
   * The Scrum Master and product management use Azure Boards to create the backlog, schedule work in sprints, review the project board, create the repository structure, and set the security rules, as in, the approval workflows, branches, and so on.
   * The Azure Git Repository stores the scripts and permits to manage Microsoft Sentinel artifacts in the infrastructure as code.
   * Artifacts and Source Control maintain the extensions and update packages or components of the DevSecOps workflow used in our solution, such as Azure Resource Manager Template Toolkit and Powershell Pester.
2. Sentinel Artifacts:
   * Policies: In our Reference Architecture, to configure at scale the “Diagnostic Settings” of such Azure services SIEM Engineers will use Azure Policy that helps to automate the deployment of the Microsoft Sentinel data connectors depending on OMSIntegration API like “Azure Key Vault”.
   * Connectors: Azure Data Connectors, are logical connectors used by Microsoft Sentinel to ingest security data (audits or metrics) from supported data source like Azure AD, Azure Resources, Microsoft 365 Defender or 3rd party solutions. The main list of Data connectors are managed by SecurityInsights API others rely on OMSIntegration API are managed with Azure Policy (Diagnostic Settings).
   * Managed Identity: Used by Microsoft Sentinel to act on behalf of the MSI while interacting with Playbooks (Logics Apps), or Automation Runbooks, Key Vault.
   * Automation: Support SOC teams during investigations to execute digital forensics data acquisition procedures automated with Azure Automation, like Azure VM Chain of Custody or Advanced eDiscovery for Microsoft 365.
   * Analytics: Built-in or Custom Analytics rules used by SOC Analysts or Threat Hunters to analyze and correlate data in Microsoft Sentinel or trigger playbooks if a threat/incident is identified.
   * Playbooks: Logic Apps used to execute SecOps repeatable actions like assign an incident, update an incident OR remediation actions like isolate or contain a VM, revoke a token, reset a user password.
   * Threat Hunting: Proactive Threat hunting capabilities used by Threat Hunters (can be coupled with Jupyter notebooks for advanced use cases like data processing, data manipulation, data visualization, ML or Deep Learning)
   * Workbooks: Dashboard used by SIEM Engineers to visualize trends, statistics, status of a given Microsoft Sentinel instance and sub-components
   * Threat Intelligence: Is a specific data connector to fuse Threat Intelligence Platforms feeds with Microsoft Sentinel, we have two connectivity methods TAXII or Graph API (tiIndicators)
3. Azure AD: Identity and Access Management capabilities delivered to components used in the reference architecture like Managed Identities, Service Principal, RBACs for Microsoft Sentinel, Logic Apps, Automation runbooks.
4. Azure DevOps Pipelines: Used by the DevOps engineers to create service connection for managing the different Azure subscriptions (environments: Sandbox, Production) with CI/CD pipelines. Note: We highly recommend using approval workflows to prevent unexpected deployments and separated Service Principals if you target multiple subscriptions per Azure “environments”.
5. Azure Key Vault: Used by SOC Engineers to store securely Service Principal’s secrets/certificate, this component of the architecture helps to enforce DevSecOps principle of “no secrets in code” when used by Azure DevOps Pipeline service connections.
6. Azure Subscription: In this Reference Architecture, the SOC teams will use two instances of Microsoft Sentinel separated within two logical Azure subscriptions to simulate Production & Sandbox environments (you can scale at your needs with other environments like Testing, Dev, Preproduction etc…)

Examples:
1. Admin 1 adds, updates, or deletes an entry in Admin 1's fork of the Microsoft 365 config file.
2. Admin 1 commits and syncs the changes to Admin 1's forked repository.
3. Admin 1 creates a pull request (PR) to merge the changes to the main repository.
4. The build pipeline runs on the PR.

### Components

> A bullet list of components in the architecture (including all relevant Azure services) with links to the product service pages. This is for lead generation (what business, marketing, and PG want). It helps drive revenue.

> Why is each component there?
> What does it do and why was it necessary?
> Link the name of the service (via embedded link) to the service's product service page. Be sure to exclude the localization part of the URL (such as "en-US/").

- Examples: 
  - [Azure App Service](https://azure.microsoft.com/services/app-service)
  - [Azure Bot Service](https://azure.microsoft.com/services/bot-service)
  - [Azure Cognitive Services Language Understanding](https://azure.microsoft.com/services/cognitive-services/language-understanding-intelligent-service)
  - [Azure Cognitive Services Speech Services](https://azure.microsoft.com/services/cognitive-services/speech-services)
  - [Azure SQL Database](https://azure.microsoft.com/services/sql-database)
  - [Azure Monitor](https://azure.microsoft.com/services/monitor): Application Insights is a feature of Azure Monitor.
  - [Resource Groups][resource-groups] is a logical container for Azure resources.  We use resource groups to organize everything related to this project in the Azure console.

### Alternatives

> Use this section to talk about alternative Azure services or architectures that you might consider for this solution. Include the reasons why you might choose these alternatives. Customers find this valuable because they want to know what other services or technologies they can use as part of this architecture.

> What alternative technologies were considered and why didn't we use them?

## Considerations

> Are there any lessons learned from running this that would be helpful for new customers?  What went wrong when building it out?  What went right?
> How do I need to think about managing, maintaining, and monitoring this long term?
> Note that you should have at least two of the H3 sub-sections (which are our pillars).

### Availability

> How do I need to think about managing, maintaining, and monitoring this long term?

### Operations

> How do I need to think about operating this solution?

### Performance

> Are there any key performance considerations (past the typical)?

### Scalability

> Are there any size considerations around this specific solution?
> What scale does this work at?
> At what point do things break or not make sense for this architecture?

### Security

> Are there any security considerations (past the typical) that I should know about this? 

### Resiliency

> Are there any key resiliency considerations (past the typical)?

### DevOps

> Are there any key DevOps considerations (past the typical)?

## Deploy this scenario

> (Optional, but greatly encouraged)

> Is there an example deployment that can show me this in action?  What would I need to change to run this in production?

## Pricing

> How much will this cost to run?
> Are there ways I could save cost?
> If it scales linearly, than we should break it down by cost/unit. If it does not, why?
> What are the components that make up the cost?
> How does scale affect the cost?

> Link to the pricing calculator with all of the components in the architecture included, even if they're a $0 or $1 usage.
> If it makes sense, include small/medium/large configurations. Describe what needs to be changed as you move to larger sizes.

## Next steps

> Link to Docs and Learn articles, along with any third-party documentation.
> Where should I go next if I want to start building this?
> Are there any relevant case studies or customers doing something similar?
> Is there any other documentation that might be useful? Are there product documents that go into more detail on specific technologies that are not already linked?

Examples:
* [Azure Kubernetes Service (AKS) documentation](/azure/aks)
* [Azure Machine Learning documentation](/azure/machine-learning)
* [What are Azure Cognitive Services?](/azure/cognitive-services/what-are-cognitive-services)
* [What is Language Understanding (LUIS)?](/azure/cognitive-services/luis/what-is-luis)
* [What is the Speech service?](/azure/cognitive-services/speech-service/overview)
* [What is Azure Active Directory B2C?](/azure/active-directory-b2c/overview)
* [Introduction to Bot Framework Composer](/composer/introduction)
* [What is Application Insights](/azure/azure-monitor/app/app-insights-overview)
 
## Related resources

> Use "Related resources" for related architecture guides and architectures (content on the Azure Architecture Center).

Examples:
  - [Artificial intelligence (AI) - Architectural overview](/azure/architecture/data-guide/big-data/ai-overview)
  - [Choosing a Microsoft cognitive services technology](/azure/architecture/data-guide/technology-choices/cognitive-services)
  - [Chatbot for hotel reservations](/azure/architecture/example-scenario/ai/commerce-chatbot)
  - [Build an enterprise-grade conversational bot](/azure/architecture/reference-architectures/ai/conversational-bot)
  - [Speech-to-text conversion](/azure/architecture/reference-architectures/ai/speech-ai-ingestion)