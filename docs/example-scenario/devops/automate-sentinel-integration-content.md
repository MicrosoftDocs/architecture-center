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

* Sentinel as a Service: Our development framework integrates service lifecycle management principles. These principles suit simple or complex organizations like Managed Security Service Providers (MSSPs) who run repeatable, standardized actions across multiple customer tenants while combining the power of Azure DevOps & Azure Lighthouse. For example, an organization that needs to publish Sentinel use cases for a new threat actor or ongoing campaign.

* Building SOC use case for Threat detection: Many organizations and threat intelligence platforms rely on Mitre Att&ck content and taxonomy to analyze their Security Posture against advanced tradecraft or Techniques and Tactics Procedures. The solution defines a structured approach for developing threat detection engineering practices, by incorporating Mitre Att&ck terminology within Microsoft Sentinel artifacts development. The following illustration shows a Mitre Att&ck Cloud scenario:

![Diagram of a Mitre Att&ck Cloud scenario](./media/mitre-att&ck-in-sentinel-artifacts-dev.png)

## Architecture

![Architecture diagram for automating Microsoft Sentinel pipeline](./media/automate-sentinel-architecture.png)

> Under the architecture diagram, include this sentence and a link to the Visio file or the PowerPoint file:

_Download a [Visio file](https://arch-center.azureedge.net/[filename].vsdx) of this architecture._

### Dataflow

1. The Scrum Master and product management use Azure DevOps to define Epics, User Stories, and Product Backlog items as part of the project backlog.
   * The Scrum Master and product management use Azure Boards to create the backlog, schedule work in sprints, review the project board, create the repository structure, and set the security rules, as in, the approval workflows, branches, and so on.
   * The Azure Git Repository stores the scripts and the permits to manage Microsoft Sentinel artifacts in the infrastructure as code.
   * Artifacts and Source Control maintain the extensions and update packages or components of the DevSecOps workflow used in our solution, such as Azure Resource Manager Template Toolkit and Powershell Pester.
2. Sentinel Artifacts:
   * Policies: SIEM Engineers use Azure policies in the Reference Architecture, to configure and scale the diagnostic settings of the Azure services. The policies help automate deployment of the Microsoft Sentinel data connectors depending on the OMSIntegration API, such as Azure Key Vault.
   * Connectors: Microsoft Sentinel uses  logical connectors, the Azure Data Connectors to ingest security data (audits or metrics) from supported data sources, such as Azure AD, Azure Resources, Microsoft 365 Defender, or third-party solutions. The main list of Data connectors is managed by the SecurityInsights API; others rely on the OMSIntegration API and are managed with the Azure Policy (diagnostic settings).
   * Managed Identity: Microsoft Sentinel uses managed identity to act on behalf of the MSI while interacting with Playbooks (Logics Apps), or Automation Runbooks and the Key Vault.
   * Automation: Security Operations Center teams use automation during investigations. SOC teams run digital forensics data acquisition procedures with Azure Automation, such as Azure VM Chain of Custody or Advanced eDiscovery for Microsoft 365.
   * Analytics: SOC Analysts or Threat Hunters use built-in or custom analytics rules to analyze and correlate data in Microsoft Sentinel or to trigger playbooks if a threat and incident is identified.
   * Playbooks: Logic Apps run the SecOps repeatable actions, such as assigning an incident, updating an incident, or taking remediation actions, like isolating or containing a VM, revoking a token, or resetting a user password.
   * Threat Hunting: Threat Hunters use proactive threat hunting capabilities that can be coupled with Jupyter notebooks for advanced use cases, such as data processing, data manipulation, data visualization, ML, or Deep Learning.
   * Workbooks: SIEM Engineers use Workbooks Dashboards to visualize trends and statistics and to view the status of a Microsoft Sentinel instance and its sub-components.
   * Threat Intelligence: A specific data connector that fuses Threat Intelligence Platforms feeds with Microsoft Sentinel. Two connectivity methods are supported, TAXII or Graph API (tiIndicators).
3. Azure AD: Identity and Access Management capabilities are delivered to components used in the reference architecture, such as Managed Identities, Service Principal, RBACs for Microsoft Sentinel, Logic Apps, and Automation runbooks.
4. Azure DevOps Pipelines: DevOps engineers use pipelines to create service connections for managing the different Azure subscriptions (Sandbox and Production environments) with CI/CD pipelines. We recommend using approval workflows to prevent unexpected deployments and separated Service Principals if you target multiple subscriptions per Azure environment.
5. Azure Key Vault: SOC Engineers use the key vault to securely store service principal secrets and certificate. The component of the architecture helps enforce the DevSecOps principle of “no secrets in code” when used by Azure DevOps Pipeline service connections.
6. Azure Subscription: The SOC teams use two instances of Microsoft Sentinel in this Reference Architecture, separated within two logical Azure subscriptions to simulate Production and Sandbox environments. You can scale for your needs with other environments, such as Testing, Dev, Preproduction, and so on.

#### Dataflow Example

1. Admin one adds, updates, or deletes an entry in Admin one's fork of the Microsoft 365 config file.
2. Admin one commits and syncs the changes to Admin one's forked repository.
3. Admin one creates a pull request (PR) to merge the changes to the main repository.
4. The build pipeline runs on the PR.

### Components

This architecture makes use of the following components:  

* [Azure Active Directory](https://azure.microsoft.com/services/active-directory/): A multi-tenant, cloud-based service to manage your identity and access controls.
* [Azure DevOps](https://azure.microsoft.com/services/devops/): A cloud service to collaborate on code, build and deploy apps, or plan and track your work.
* [Azure Key Vault](https://azure.microsoft.com/services/key-vault/): A cloud service for securely storing and accessing secrets. A secret is anything that you want to tightly control access to, such as API keys, passwords, certificates, or cryptographic keys.
* [Azure Policy](https://azure.microsoft.com/services/azure-policy/): A service in Azure to create, assign, and manage policy definitions in your Azure environment.
* [Microsoft Sentinel](https://azure.microsoft.com/services/azure-sentinel/):
A scalable, cloud-native, security information and event management (SIEM) and security orchestration, automation, and response (SOAR) solution.
* [Azure Automation](https://azure.microsoft.com/services/automation/): An Azure service for simplifying cloud management through process automation. Use Azure Automation to automate long-running, manual, error-prone, and frequently repeated tasks to increase reliability, efficiency, and time to value for your organization.

### Alternatives

> Use this section to talk about alternative Azure services or architectures that you might consider for this solution. Include the reasons why you might choose these alternatives. Customers find this valuable because they want to know what other services or technologies they can use as part of this architecture.

> What alternative technologies were considered and why didn't we use them?

## Considerations

With security, in general terms, automation increases operations efficiency while saving time for more complex use cases, such as: threat detection engineering, threat intelligence, SOC, and SOAR use cases. While saving time, DevOps teams need to know where they can leverage IaC in the context of Microsoft Sentinel CI/CD in a secure fashion, which introduces the use of specific identities used by non-human accounts in Azure AD called [Service Principals](/azure/active-directory/develop/app-objects-and-service-principals) and [Managed Identities](/azure/active-directory/managed-identities-azure-resources/overview).

The following table summarizes security considerations regarding service principals with the main use cases covered by Microsoft Sentinel and Azure DevOps release pipelines:

| Use case | Requirements (least privilege) | Role assignment duration | Permission scope | Trustee| Security considerations |
| -- | --- | --- | --- | --- | ---------- |
| Enable Sentinel connectors | <ul type="circle"> <li> Security Administrator (see table note two) </li> <li> Owner * </li> <li> Sentinel Contributor </li> <li> Reader </li>| JIT (one-time activation) <br> On purpose (every time a new subscription and connector deploys) | Tenant | SPN | <ul type="circle"> <li> Use Key Vault to store SPN secrets and certificate. </li> <li> Enable SPN auditing. </li> <li> Periodically review permission assignment (Azure PIM for SPN) or suspicious activity for SPN. </li>  <li> Use AAD CA and MFA (when supported) for privileged accounts. </li> <li> Use Azure AD Custom Roles for more granularity. </li> |
| Deploy Sentinel artifacts (workbooks, analytics, rules, threat hunting queries, notebooks, playbooks) | <ul type="circle"> <li> Sentinel Contributor </li> <li> Logic Apps contributor </li> |Permanent | Sentinel's Workspace or Resource Group | SPN | <ul type="circle"> <li> Use ADO Workflow approval and checks to secure pipeline deployment with this SPN. </li>|
| Assign a policy to configure log streaming features to Sentinel|  Resource Policy Contributor ** | On purpose (every time a new subscription and connector deploys) | All subscriptions to be monitored| SPN | <ul type="circle"> <li> Use AAD CA and MFA (when supported) for privileged accounts. </li> |

\* Only concerns Azure AD Diagnostics Settings. <br>
\** Specific connectors need additional permissions granted like "Security Administrator" or "Resource Policy Contributor" to allow streaming their data to Sentinel Workspace: Azure AD; Office365, or M365 Defender, Paas Resources like Azure Key Vault.

### Privileged access model

Microsoft recommends adopting a privileged access model strategy to rapidly lower the risks to your organization from high-impact and high-likelihood attacks on privileged access. In the case of automatic processes in a DevOps model, you must base identity on [Service Principal](/azure/active-directory/develop/app-objects-and-service-principals) identities.

Privileged access should be the top security priority at every organization. Any compromise of these identities creates highly negative impacts to the organization. Privileged identities have access to business-critical assets in an organization, nearly always causing major impacts when attackers compromise these accounts.

Security of privileged access is critically important because it's foundational to all other security assurances. An attacker in control of your privileged accounts can undermine all other security assurances.  

For that reason, we recommend logically spreading the service principals into different levels or tiers following a minimum privilege principle. The following illustration shows how to classify the Service Principals, depending on type of access and where the access is required.

![Architecture diagram for automating Microsoft Sentinel pipeline](./media/sentinel-layered-architecture.png)

#### Level 0 service principals

Level 0 service principals have the highest level of permissions. These service principals entitle someone to perform tenant-wide or root management group administration tasks as a Global Administrator.

For security reasons and manageability, we recommend that you have only one service principal for this level. The permissions for this service principal persist, so it's highly recommended that you grant only the minimum permissions required and keep the account monitored and secured.

The secret or certificate for this account must be stored securely in the Azure Key Vault. We also strongly recommended that the Key Vault be located in a dedicated administrative subscription if possible.

#### Level 1 service principals

Level 1 service principals are elevated permissions limited and scoped to Management Groups at the business organization level. These service principals entitle someone to create subscriptions under the management group in scope.

For security reasons and manageability, we recommend that you have only one service principal for this level. The permissions for this service principal persist, so it's highly recommended that you grant only the minimum permissions required and keep the account monitored and secured.

The secret or certificate for this account must be stored securely in the Azure Key Vault. We also strongly recommended that the Key Vault be located in a dedicated administrative subscription if possible.

#### Level 2 service principals

Level 2 service principals are limited to the subscription level. These service principals entitle someone to perform administrative tasks under a subscription, acting as the subscription Owner.  

For security reasons and manageability, we recommend that you have only one service principal for this level. The permissions for this service principal persist, so it's highly recommended that you grant only the minimum permissions required and keep the account monitored and secured.

The secret or certificate for this account must be stored securely in the Azure Key Vault. We also strongly recommended that the Key Vault be located in a dedicated administrative resource group.

#### Level 3 service principals

Level 3 service principals are limited to the Workload Administrator. In a typical scenario, every workload is contained inside the same Resource Group. This structure limits the service principal permissions to just this Resource Group.

For security reasons and manageability, we recommend that you have only one service principal per workload. The permissions for this service principal persist, so it's highly recommended that you grant only the minimum permissions required and keep the account monitored and secured.

The secret or certificate for this account must be stored securely in the Azure Key Vault. We also strongly recommended that the Key Vault be located in a dedicated administrative resource group.

#### Level 4 service principals

Level 4 service principals are the lowest and most limited level. These service principals entitle someone to perform administrative tasks limited to one resource.

We recommended using managed identities where possible. In the case of non-managed identities, the secret or certificate must be stored securely in the Azure Key Vault where the Level 3 secrets are stored.

> [!NOTE]
> A best practice for organizations that follow the Security Tier approach is to avoid cross-level service principals.

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

Microsoft Sentinel solutions are composed of three main segments, which ensure complete and successful implementation.  

The first segment is the environment definition, which makes up the essential architecture elements. Your main concern with this block is to consider the number of production and non-production environments to be deployed, then how to ensure the implementation is homogeneous in all cases.

The second segment is the Microsoft Sentinel Connector deployment, where you consider the kind of connectors required by the organization and the security requirements to enable them.

The third segment is the Microsoft Sentinel artifacts lifecycle management, which covers coding, deployment, and use or destruction of the components. For example, the Analytic Rules, Playbooks, Workbooks, Threat Hunting, and so on.

Inter-dependencies between artifacts to consider include the following examples:

* Automation rules defined in an Analytics rule
* Workbooks or Analytics that require a new data source or connector
* How to manage updates of existing components like:
  * How to version your artifacts
  * How to identify, test, and deploy an updated or entirely new analytics rule

#### Build, test, and deployment infrastructure

In managing Microsoft Sentinel solutions and DevOps, it's important to consider the connectivity and security aspects of your Enterprise Architecture.

Azure DevOps can use Microsoft-hosted agents or self-hosted agents for build, testing, and deployment activities.
Depending on your organization's requirements, you can use Microsoft-hosted, self-hosted, or a combination of both models.

* Microsoft-hosted agents: This option is the fastest way to work with Azure DevOps agents, because it's a shared infrastructure for your entire organization. For more information on using Microsoft-hosted agents in your pipeline, see [Microsoft-hosted agents](/azure/devops/pipelines/agents/hosted?view=azure-devops&tabs=yaml) Microsoft-hosted agents can work in hybrid-networking environments, granting access for the following [IP ranges](https://www.microsoft.com/download/details.aspx?id=56519)
* Self-hosted agents: This option gives you dedicated resources and more control when installing dependent software for your builds and deployments. Self-hosted agents can work over virtual machines, scale sets, and containers on Azure. For more information on self-hosted agents, see [Azure Pipelines agents](/azure/devops/pipelines/agents/agents?view=azure-devops&tabs=browser#install).

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