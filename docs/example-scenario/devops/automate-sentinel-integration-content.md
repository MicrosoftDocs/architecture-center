Security Operations Center teams experience challenges when integrating Microsoft Sentinel with Azure DevOps. The process involves many steps and the setup can take days with constant repetition. You can automate this part of the development.

Cloud modernization means engineers must constantly learn new skills and techniques for securing and protecting vital business assets. Engineers must build robust and scalable solutions that keep pace with the ever-changing security landscape and business needs. The security solution must be flexible, agile, and carefully planned from the earliest stages of development, known as shift-left.

This article shows you how to automate Microsoft Sentinel integration and deployment operations with Azure DevOps. You implement Azure DevOps using several Sentinel capabilities to secure your deployment. Then, you employ DevSecOps framework to manage and deploy Microsoft Sentinel artifacts at scale.

You can even expand the solution to cover more complex organizations that have multiple entities, subscriptions, and various operating models. Some of the operating models supported by this solution include Local SOC, Global SOC, Cloud Service Provider (CSP), and Managed Security Service Provider (MSSP).

This article supports the following audiences.

* SOC specialists, as in, analysts and threat hunters
* SIEM engineers
* Cybersecurity architects
* Developers

## Potential use cases

Following are the typical use cases for this architecture.

* Rapid prototyping and Proof of Concept - Ideal for security organizations and SOC wanting to improve Cloud threat coverage or modernize their SIEM infrastructure with Infra as Code and Microsoft Sentinel.
* Sentinel as a Service - Our development framework integrates service lifecycle management principles. These principles suit simple or complex teams like MSSPs who run repeatable, standardized actions across multiple customer tenants while combining the power of Azure DevOps & Azure Lighthouse. For example, a team that needs to publish Sentinel use cases for a new threat actor or ongoing campaign.
* Building SOC use case for Threat detection - Many groups and threat intelligence platforms rely on Mitre Att&ck content and taxonomy to analyze their Security Posture against advanced tradecraft or Techniques and Tactics Procedures. The solution defines a structured approach for developing threat detection engineering practices, by incorporating Mitre Att&ck terminology within Microsoft Sentinel artifacts development.

The following illustration shows a Mitre Att&ck Cloud scenario.

![Diagram of a Mitre Att&ck Cloud scenario](./media/mitre-att&ck-in-sentinel-artifacts-dev.png)

*Download a [Visio file](https://arch-center.azureedge.net/US-1902821-automate-sentinel-integration-architecture.vsdx) of this architecture.*

## Architecture

The following diagram shows an Azure DevOps and Microsoft Sentinel Infra as Code (IaC) setup.

![Architecture diagram for automating Microsoft Sentinel pipeline](./media/automate-sentinel-architecture.png)

> Under the architecture diagram, include this sentence and a link to the Visio file or the PowerPoint file:

_Download a [Visio file](https://arch-center.azureedge.net/[filename].vsdx) of this architecture._

### Dataflow

1. The Scrum Master and product management use Azure DevOps to define Epics, User Stories, and Product Backlog items as part of the project backlog.
   * The Scrum Master and product management use Azure Boards to create the backlog, schedule work in sprints, review the project board, create the repository structure, and set the security rules, as in, the approval workflows, branches, and so on.
   * The Azure Git repository stores the scripts and the permits to manage Microsoft Sentinel artifacts in the infrastructure as code.
   * Artifacts and Source Control maintain the extensions and update packages or components of the DevSecOps workflow used in our solution, such as Azure Resource Manager Template Toolkit and Powershell Pester.
2. Sentinel Artifacts:
   * Policies - SIEM engineers use Azure policies in the Reference Architecture, to configure and scale the diagnostic settings of the Azure services. The policies help automate deployment of the Microsoft Sentinel data connectors depending on the OMSIntegration API, such as Azure Key Vault.
   * Connectors - Microsoft Sentinel uses logical connectors, the Azure Data Connectors to ingest security data, as in, audits or metrics, from supported data sources, such as Azure AD, Azure Resources, Microsoft 365 Defender, or third-party solutions. The main list of Data connectors is managed by the SecurityInsights API; others rely on the OMSIntegration API and are managed with the Azure Policy diagnostic settings.
   * Managed Identity - Microsoft Sentinel uses managed identity to act on behalf of the MSI while interacting with playbooks, logic apps, or automation runbooks and the key vault.
   * Automation - Security Operations Center teams use automation during investigations. SOC teams run digital forensics data acquisition procedures with Azure Automation, such as Azure VM Chain of Custody or Advanced eDiscovery for Microsoft 365.
   * Analytics - SOC analysts or threat hunters use built-in or custom analytics rules to analyze and correlate data in Microsoft Sentinel or to trigger playbooks if a threat and incident is identified.
   * Playbooks - Logic apps run the SecOps repeatable actions, such as assigning an incident, updating an incident, or taking remediation actions, like isolating or containing a VM, revoking a token, or resetting a user password.
   * Threat hunting - Threat hunters use proactive threat hunting capabilities that can be coupled with Jupyter notebooks for advanced use cases, such as data processing, data manipulation, data visualization, ML, or Deep Learning.
   * Workbooks - SIEM engineers use Workbooks Dashboards to visualize trends and statistics and to view the status of a Microsoft Sentinel instance and its sub-components.
   * Threat intelligence - A specific data connector that fuses Threat Intelligence Platforms feeds with Microsoft Sentinel. Two connectivity methods are supported, TAXII or Graph API, tiIndicators.
3. Azure AD - Identity and Access Management capabilities are delivered to components used in the reference architecture, such as managed identities, service principal, RBACs for Microsoft Sentinel, logic apps, and automation runbooks.
4. Azure DevOps pipelines - DevOps engineers use pipelines to create service connections for managing the different Azure subscriptions, the Sandbox and Production environments, with CI/CD pipelines. We recommend using approval workflows to prevent unexpected deployments and separated service principals if you target multiple subscriptions per Azure environment.
5. Azure Key Vault - SOC engineers use the key vault to securely store service principal secrets and certificate. The component of the architecture helps enforce the DevSecOps principle of _no secrets in code_ when used by Azure DevOps Pipeline service connections.
6. Azure Subscription - The SOC teams use two instances of Microsoft Sentinel in this reference architecture, separated within two logical Azure subscriptions to simulate Production and Sandbox environments. You can scale for your needs with other environments, such as Testing, Dev, Preproduction, and so on.

#### Dataflow Example

1. Admin one adds, updates, or deletes an entry in Admin one's fork of the Microsoft 365 config file.
2. Admin one commits and syncs the changes to Admin one's forked repository.
3. Admin one creates a pull request to merge the changes to the main repository.
4. The build pipeline runs on the PR.

### Components

This architecture makes use of the following components.  

* [Azure Active Directory](https://azure.microsoft.com/services/active-directory/) - A multi-tenant, cloud-based service to manage your identity and access controls.
* [Azure DevOps](https://azure.microsoft.com/services/devops/) - A cloud service to collaborate on code, build and deploy apps, or plan and track your work.
* [Azure Key Vault](https://azure.microsoft.com/services/key-vault/) - A cloud service for securely storing and accessing secrets. A secret is anything that you want to tightly control access to, such as API keys, passwords, certificates, or cryptographic keys.
* [Azure Policy](https://azure.microsoft.com/services/azure-policy/) - A service in Azure to create, assign, and manage policy definitions in your Azure environment.
* [Microsoft Sentinel](https://azure.microsoft.com/services/azure-sentinel/) -
A scalable, cloud-native, security information and event management (SIEM) and security orchestration, automation, and response (SOAR) solution.
* [Azure Automation](https://azure.microsoft.com/services/automation/) - An Azure service for simplifying cloud management through process automation. Use Azure Automation to automate long-running, manual, error-prone, and frequently repeated tasks. Automation helps increase reliability, efficiency, and time to value for your company.

## Threat definition attack scenarios based on MITRE

This table shows you the terms, definitions, and details on important aspects of attack scenarios.

| Data item | Description | Microsoft Sentinel artifacts |
| -- | --- | --- |
| Title | Descriptive name for the attack scenario, based on attack vector characteristics or technique descriptions | Mitre Manifest |
| MITRE ATT&CK tactics | MITRE ATT&CK tactics related to attack scenario | Mitre Manifest |
| MITRE ATT&CK techniques | MITRE ATT&CK techniques, including the technique or sub-technique ID, related to the attack scenario. | Mitre Manifest |
| Data connector sources | Source of information collected by a sensor or logging system that might be used to collect information relevant to identifying the action being performed, sequence of actions, or the results of those actions by an adversary. | [Sentinel Data Connector](/azure/sentinel/connect-data-sources) or [Custom Log source](/azure/sentinel/connect-custom-logs?tabs=DCG)|
| Description | Information about the technique, what it is, what it's typically used for, how an adversary can take advantage of it, and variations on how it could be used. Includes references to authoritative articles describing technical information related to the technique as well as in the wild use references as appropriate. |
| Detection | High-level analytic process, sensors, data, and detection strategies useful in identifying a technique that's been used by an adversary. This section informs those responsible for detecting adversary behavior, such as network defenders, so they can take an action such as writing an analytic or deploying a sensor. There should be enough information and references to point toward useful defensive methodologies. Detection might not always be possible for a certain technique and should be documented as such. | Analytics Threat Hunting |
| Mitigation | Configurations, tools, or processes that prevent a technique from working or having the desired outcome for an adversary. This section informs those responsible for mitigating against adversaries, such as network defenders or policymakers, to let them take an action such as changing a policy or deploying a tool. Mitigation might not always be possible for a given technique and should be documented as such. |
| Mitigation | Configurations, tools, or processes that prevent a technique from working or having the desired outcome for an adversary. This section describes how to lessen the effects of adversary attacks for network defenders or policymakers. It covers steps for changing a policy or deploying a tool. Mitigation might not always be possible for a certain technique and should be documented as such. | Playbooks Automation runbooks |

## Considerations

With security, in general terms, automation increases operations efficiency while saving time for more complex use cases, such as threat detection engineering, threat intelligence, SOC, and SOAR use cases. While saving time, DevOps teams need to know where they can use IaC securely in the context of Microsoft Sentinel CI/CD. This process introduces the use of specific identities used by non-human accounts in Azure AD called [Service principals](/azure/active-directory/develop/app-objects-and-service-principals) and [Managed identities](/azure/active-directory/managed-identities-azure-resources/overview).

The following table summarizes security considerations for service principals and the main use cases covered by Microsoft Sentinel and Azure DevOps release pipelines.

| Use case | Requirements (least privilege) | Role assignment duration | Permission scope | Trustee| Security considerations |
| -- | --- | --- | --- | --- | ---------- |
| Enable Sentinel connectors | Security Administrator** <br><br> Owner* <br><br> Sentinel Contributor <br><br> Reader | JIT (one-time activation) <br><br> On purpose (every time a new subscription and connector deploys) | Tenant | SPN | Use the key vault to store SPN secrets and certificate. <br><br> Enable SPN auditing. <br><br> Periodically review permission assignment (Azure PIM for SPN) or suspicious activity for SPN. <br><br>Use AAD CA and MFA (when supported) for privileged accounts. <br><br> Use Azure AD Custom Roles for more granularity.  |
| Deploy Sentinel artifacts, such as workbooks, analytics, rules, threat hunting queries, notebooks, and playbooks | Sentinel Contributor <br> Logic Apps contributor  | Permanent | Sentinel's Workspace or Resource Group | SPN | Use ADO Workflow approval and checks to secure pipeline deployment with this SPN. |
| Assign a policy to configure log streaming features to Sentinel|  Resource Policy Contributor ** | On purpose (every time a new subscription and connector deploys) | All subscriptions to be monitored| SPN | Use AAD CA and MFA, when supported, for privileged accounts. |

\* Only concerns Azure AD Diagnostics Settings. <br>
\** Specific connectors need additional permissions like "Security Administrator" or "Resource Policy Contributor" to allow streaming data to Sentinel Workspace, Azure AD, Office365 or M365 Defender, and Paas Resources like Azure Key Vault.

### Privileged access model

Microsoft recommends adopting a privileged access model strategy to rapidly lower the risks to your company from high-impact and high-likelihood attacks on privileged access. In the case of automatic processes in a DevOps model, you must base identity on [Service Principal](/azure/active-directory/develop/app-objects-and-service-principals) identities.

Privileged access should be the top security priority at every company. Any compromise of these identities creates highly negative impacts. Privileged identities have access to business-critical assets, which nearly always causes major impacts when attackers compromise these accounts.

Security of privileged access is critically important because it's foundational to all other security assurances. An attacker in control of your privileged accounts can undermine all other security assurances.  

For that reason, we recommend logically spreading the service principals into different levels or tiers following a minimum privilege principle. The following illustration shows how to classify the service principals, depending on type of access and where the access is required.

![Architecture diagram for automating Microsoft Sentinel pipeline](./media/sentinel-layered-architecture.png)

*Download a [PowerPoint file](https://arch-center.azureedge.net/US-1902821-automate-sentinel-integration-architecture.pptx) of this architecture.*

#### Level 0 service principals

Level 0 service principals have the highest level of permissions. These service principals entitle someone to perform tenant-wide or root management group administration tasks as a Global Administrator.

For security reasons and manageability, we recommend that you have only one service principal for this level. The permissions for this service principal persist, so it's highly recommended that you grant only the minimum permissions required and keep the account monitored and secured.

The secret or certificate for this account must be stored securely in the Azure Key Vault. We also strongly recommended that the Key Vault be located in a dedicated administrative subscription if possible.

#### Level 1 service principals

Level 1 service principals are elevated permissions limited and scoped to Management Groups at the business organization level. These service principals entitle someone to create subscriptions under the management group in scope.

For security reasons and manageability, we recommend that you have only one service principal for this level. The permissions for this service principal persist, so it's highly recommended that you grant only the minimum permissions required and keep the account monitored and secured.

The secret or certificate for this account must be stored securely in the Azure Key Vault. We also strongly recommended that the key vault be located in a dedicated administrative subscription if possible.

#### Level 2 service principals

Level 2 service principals are limited to the subscription level. These service principals entitle someone to perform administrative tasks under a subscription, acting as the subscription Owner.  

For security reasons and manageability, we recommend that you have only one service principal for this level. The permissions for this service principal persist, so it's highly recommended that you grant only the minimum permissions required and keep the account monitored and secured.

The secret or certificate for this account must be stored securely in the Azure Key Vault. We also strongly recommended that the Key Vault be located in a dedicated administrative resource group.

#### Level 3 service principals

Level 3 service principals are limited to the Workload Administrator. In a typical scenario, every workload is contained inside the same Resource Group. This structure limits the service principal permissions to just this Resource Group.

For security reasons and manageability, we recommend that you have only one service principal per workload. The permissions for this service principal persist, so it's highly recommended that you grant only the minimum permissions required and keep the account monitored and secured.

The secret or certificate for this account must be stored securely in the Azure Key Vault. We also strongly recommended that the key vault be located in a dedicated administrative resource group.

#### Level 4 service principals

Level 4 service principals are the lowest and most limited level. These service principals entitle someone to perform administrative tasks limited to one resource.

We recommended using managed identities where possible. In the case of non-managed identities, the secret or certificate must be stored securely in the Azure Key Vault where the Level 3 secrets are stored.

### DevOps

Microsoft Sentinel solutions are composed of three blocks, which ensure complete and successful operations.  

The first block is the environment definition, which makes up the essential architecture elements. Your main concern with this block is to consider the number of production and non-production environments to be deployed, then ensuring the setup is homogeneous in all cases.

The second block is the Microsoft Sentinel Connector deployment, where you consider the kind of connectors required by your team and the security requirements to enable them.

The third block is the Microsoft Sentinel artifacts lifecycle management, which covers coding, deployment, and use or destruction of the components. For example, the analytic rules, playbooks, workbooks, threat hunting, and so on.

Dependencies between artifacts to consider.

* Automation rules defined in an Analytics rule
* Workbooks or analytics that require a new data source or connector
* Managing the updates of existing components
  * How to version your artifacts
  * How to identify, test, and deploy an updated or entirely new analytics rule

### Build, test, and deploy infrastructure

In managing Microsoft Sentinel solutions and DevOps, it's important to consider the connectivity and security aspects of your Enterprise Architecture.

Azure DevOps can use Microsoft-hosted agents or self-hosted agents for build, test, and deploy activities.
Depending on your company's requirements, you can use Microsoft-hosted, self-hosted, or a combination of both models.

* Microsoft-hosted agents - This option is the fastest way to work with Azure DevOps agents, because it's a shared infrastructure for your entire organization. For more information on using Microsoft-hosted agents in your pipeline, see [Microsoft-hosted agents](/azure/devops/pipelines/agents/hosted?view=azure-devops&tabs=yaml) Microsoft-hosted agents can work in hybrid-networking environments, granting access for the following [IP ranges](https://www.microsoft.com/download/details.aspx?id=56519).
* Self-hosted agents - This option gives you dedicated resources and more control when installing dependent software for your builds and deployments. Self-hosted agents can work over virtual machines, scale sets, and containers on Azure. For more information on self-hosted agents, see [Azure Pipelines agents](/azure/devops/pipelines/agents/agents?view=azure-devops&tabs=browser#install).

#### GitHub runners

GitHub can use GitHub-hosted runners or self-hosted runners for activities related to building, testing and deploying.  Depending on your company's needs, you can use GitHub-hosted, self-hosted, or a combination of both models.

**GitHub-hosted runners**

This option is the fastest way to work with GitHub workflows, since it's a shared infrastructure for an entire organization. For more information on GitHub hosted runners, see [About GitHub-hosted runners](https://docs.github.com/en/actions/using-github-hosted-runners/about-github-hosted-runners) GitHub-hosted agents work in hybrid-networking environments, according to certain network requirements. For more information on the network requirements, see [Supported runners and hardware resources](https://docs.github.com/en/actions/using-github-hosted-runners/about-github-hosted-runners#ip-addresses).
  
**Self-hosted runners**

This option gives your company a dedicated resources infrastructure. Self-hosted runners work over Virtual Machines and Containers on Azure and support auto-scaling.

### Considerations for choosing runners

When choosing options for the agents and runners in your Microsoft Sentinel solution, consider the following needs.

* Does your company need dedicated resources for running processes on your Microsoft Sentinel environments?
* Do you want to isolate resources for Production environment DevOps activities from the rest of the environments?
* Does you need to test certain cases that require access to critical resources or resources available only on an internal network?

### Orchestration and automation of release processes

You can set up the deployment process with Azure DevOps or GitHub. Azure DevOps supports using a YAML pipeline or a Release pipeline. For more information on using a YAML pipeline in Azure DevOps, see [Use Azure Pipelines](https://docs.microsoft.com/en-us/azure/devops/pipelines/get-started/pipelines-get-started?view=azure-devops). For more information on using a Release pipeline in Azure DevOps, see [Release pipelines](https://docs.microsoft.com/en-us/azure/devops/pipelines/release/?view=azure-devops). For more information on using GitHub with GitHub Actions, see [Understanding GitHub Actions](https://docs.github.com/en/actions/learn-github-actions/understanding-github-actions).

#### Azure DevOps

You can do the following deployment activities in an Azure DevOps deployment.

* Use a YAML pipeline to automatically trigger pull request approvals or run on-demand.  
* Manage service connections for different environments using Azure DevOps Groups.
* On your critical environments, set up deployment approvals using the service connection feature and Azure DevOps Groups to assign specific user permissions in your team.

#### GitHub

You can do the following deployment activities in a GitHub deployment.

* Use GitHub to create pull requests or deployment activities.  
* Manage service principal credentials by using GitHub Secrets.
* Integrate deployment approval through the workflow that's associated with GitHub.

### Automatic deployment with Microsoft Sentinel infrastructure

You can deploy one or more Microsoft Sentinel environments, depending on your enterprise architecture.

* Organizations that need multiple instances on their Production environment can set up different subscriptions on the same tenant for each geographical location.  
* A centralized instance on the Production environment provides access to one or more organizations on the same tenant.
* Groups that need multiple environments like Production, Pre-Production, Integration, and so on can create and destroy them as needed.

#### Physical versus logical environment definitions

You have two choices in setting up your environment definitions, physical or logical. Both have different options and advantages.

* Physical definition - The elements of the Microsoft Sentinel architecture are defined with the following options for Infrastructure as Code (IaC):
  * Bicep templates
  * Azure Resource Manager (ARM) templates
  * Terraform
* Logical definition - This acts as an abstraction layer for setting up different teams in the group and defining their environments. The definition is set in the deployment pipeline and workflows as input for the build environment using the physical infrastructure layer.

These are some things to think about when defining your logical environments.

* Naming conventions
* Environment identifications
* Connectors and configurations

#### Code Repository

Given the environment approaches shown in the previous section, consider the following GitHub code repository organizations.

* Physical definition - Based on IaC options, think about an approach using individual module definitions linked in the main deployment definition.

The following example shows a how your code might be organized.

![Code example for a physical environment definition](./media/physical-definition-code-format-example.png)

Access to this repository should be restricted to the team that defines the architecture at the physical level, ensuring a homogeneous definition in the Enterprise architecture.

You can adapt the branching and merging strategy to the deployment strategy for each organization. If your team needs to start with the definition, see [Adopt a Git branching strategy](/azure/devops/repos/git/git-branching-guidance?view=azure-devops). 

For more information on Azure ARM templates, see [Using linked and nested templates when deploying Azure resources](/azure/azure-resource-manager/templates/linked-templates?tabs=azure-powershell#linked-template). 

For more information on setting up Bicep environments, see [Install Bicep tools](/azure/azure-resource-manager/bicep/install). For more information on GitHub, see [GitHub flow](https://docs.github.com/en/get-started/quickstart/github-flow).

Logical definitions define a company's environments. The Git repository gathers the different definitions for a company.

The following example shows a how your code might be organized.

![Code example for a logical environment definition](./media/logical-definition-code-format-example.png)

The repository reflects the pull request actions made by different teams. Multiple environments are defined by different teams and approved by the company's owners or approvers.

The privilege level for running an environment deployment is Level two. This level ensures that the Resource Group and the resources are created for the environment with the necessary security and privacy. This level also sets the user permissions on allowed actions in the production environments, Production and Pre-Production.  

Organizations that want environments on demand for testing and development and the ability to then destroy the environments after finishing their testing, can implement an Azure DevOps Pipeline or GitHub Actions. They can set scheduled triggers to destroy the environments as needed using Azure DevOps Events or GitHub Actions.

#### Sentinel Connectors Automatic Configuration  

Microsoft Sentinel Connectors is an essential part of the solution that supports connecting with different elements in the Enterprise Architecture landscape, like Azure AD, Microsoft 365, Microsoft Defenders, Threat Intelligence Platform solutions, and so on.  

When defining an Environment, the connectors configuration makes it possible to set up environments with homogeneous configurations.

Enabling connectors as part of the DevOps model must be supported over the Service Principal level model. This focus enures the right level of privileges as shown in the following table.

| Connector scenario | Privilege access model level | Azure least privilege | Requires workflow approval  |
| ---- | --- | --- | --- |
| Azure Active Directory | Level 0 | Global Admin or Security Admin | Recommended |
| Azure Active Directory Identity Protection | Level 0 | Global Admin or Security Admin | Recommended |
| Microsoft Defender for Identity | Level 0 | Global Admin or Security Admin | Recommended |
| Microsoft Office 365 | Level 0 | Global Admin or Security Admin | Recommended |
| Microsoft Cloud App Security | Level 0 | Global Admin or Security Admin | Recommended |
| Microsoft 365 Defender | Level 0 | Global Admin or Security Admin | Recommended |
| Microsoft Defender for IOT | Level 2 | Contributor | Recommended |
| Microsoft Defender for Cloud | Level 2 | Security Reader | Optional |
| Azure Activity | Level 2 | Subscription Reader | Optional |
| Threat Intelligence Platforms | Level 0 | Global Admin or Security Admin | Recommended |
| Security Events | Level 4 | None | Optional |
| Syslog | Level 4 | None | Optional |
| DNS (preview) | Level 4 | None | Optional |
| Windows Firewall | Level 4 | None | Optional |
| Windows Security Events via AMA | Level 4 | None | Optional |

### Microsoft Sentinel artifacts deployment  

Microsoft Sentinel artifacts is where DevOps gains greater relevance, because each company creates multiple artifacts for preventing and remediating attacks.

Implementing the artifacts can be the responsibility of one team or multiple teams. Automatic build and artifacts deployment is often the most common process requirement and determines the approach and conditions for your agents and runners.

Deploying and managing Microsoft Sentinel artifacts requires using the Microsoft Sentinel REST API. For more information, see [Microsoft Sentinel REST API](/rest/api/securityinsights/). The following diagram shows an Azure DevOps pipeline on an Azure REST API stack.

![Azure DevOps pipeline on Microsoft Sentinel API stack](./media/azure-devops-pipeline-on-sentinel-api-stack.png)

You can also implement your repository using PowerShell.

If your team uses MITRE, consider classifying the different artifacts and specifying the Tactics and Technics for each one. Be sure you include a corresponding metadata file for each artifact type.

For example, if you're creating a new playbook using an Azure ARM template and the file name is _Playbook.arm.json_, you add a JSON file named _Playbook.arm.mitre.json_. The metadata for this file then includes the CSV, JSON, or YAML formats corresponding to the MITRE Tactics or Technics you're using. 

By following this practice, your team can evaluate your MITRE coverage based on the jobs done during setup for the different artifact types you use.

#### Build artifacts

The objective of your build process is to ensure that you generate the highest quality artifacts. The following diagram shows some of the build process actions you can take.

:::image type="content" source="./media/build-artifact-process-lightbox.png" alt-text="Microsoft Sentinel build process." lightbox="./media/build-artifact-process-lightbox.png":::

*Download a [Visio file](https://arch-center.azureedge.net/US-1902821-automate-sentinel-integration-architecture.vsdx) of this architecture.*

* You can base your artifact definition on a descriptive schema in JSON or YAML format and then validate the schema to avoid syntax errors.  
  * Validate your ARM templates using [TTK ARM Template Test Toolkit](/azure/azure-resource-manager/templates/test-toolkit).
  * Validate your YAML and JSON files for custom models using PowerShell.
* Validate your watchlist settings and be sure the CIDR records that you define follow the correct schema, for example, 10.1.0.0/16.  
* Analytic rules, hunting rules, and live stream rules use KQL queries, which you can validate at the level of the syntax.
* The [KQL local validation](https://github.com/Azure/Azure-Sentinel#run-kql-validation-locally) tool is one option.
* The [KQL inline validation](https://github.com/Azure/Azure-Sentinel/blob/master/.azure-pipelines/kqlValidations.yaml) tool is integrated in DevOps pipeline.
* If you're implementing logic based on PowerShell for Azure Automation, you can include syntax validation and unit testing using the following elements:
  * [Pester](https://devblogs.microsoft.com/scripting/what-is-pester-and-why-should-i-care/)
  * [PowerShell Script Analyzer](https://docs.microsoft.com/en-us/powershell/module/psscriptanalyzer/?view=ps-modules)  
* Generate the MITRE manifest metadata report based on the metadata files included with the artifacts.

#### Export Artifacts

Usually, multiple teams work over several Microsoft Sentinel instances to generate necessary artifacts and validate them. With the goal of reusing existing artifacts, your company can set up automatic processes for getting the artifact definitions from existing environments. Automation can also supply information on any artifacts created by different development teams during setup.

The following diagram shows an example artifact extraction process.

:::image type="content" source="./media/artifact-extraction-process-lightbox.png" alt-text="Microsoft Sentinel artifact extraction process." lightbox="./media/artifact-extraction-process-lightbox.png":::

*Download a [Visio file](https://arch-center.azureedge.net/US-1902821-automate-sentinel-integration-architecture.vsdx) of this architecture.*

#### Deploy Artifacts

The objective of your deployment process:

* Reduce time to market
* Increase performance across the multiple teams involved with setting up and managing your solution
* Set up integration testing to evaluate the health of the environment  

Development teams use the process to ensure they can deploy, test, and validate artifact use cases under development. The Architecture and Security Operations Center (SOC) teams validate the pipeline quality on QA environments and work with the integration tests for attack scenarios. On the test cases, a team usually combines different artifacts as analytic rules, remediation playbooks, watchlists, and so on. A part of each use case includes simulating attacks where the entire chain is evaluated from ingestion, detection, and remediation.

The following diagram shows the deployment process sequence that ensures your artifacts are deployed in the right order.

:::image type="content" source="./media/artifact-deployment-process-lightbox.png" alt-text="Microsoft Sentinel artifact deployment process." lightbox="./media/artifact-deployment-process-lightbox.png":::

*Download a [Visio file](https://arch-center.azureedge.net/US-1902821-automate-sentinel-integration-architecture.vsdx) of this architecture.*

Managing Sentinel artifacts as code offer you flexible ways to maintain your operations and automate the deployment in a CI/CD DevOps pipeline.

Microsoft solutions provide automation workflows for the following artifacts.

| Artifact | Automation workflows |
| ---- | --- |
| Watchlists | Code Review <br>Schema validation <br><br>[Deployment](/rest/api/securityinsights/watchlists)<br>Create, Update, Delete watchlists and [items](/rest/api/securityinsights/watchlist-items)|
| Analytics Rules Fusion<br>Microsoft Security<br>ML Behavioral Analytics<br>Anomaly<br>Scheduled | [Code Review](/azure/security/develop/security-code-analysis-overview)<br>KQL Syntax validation<br>Schema validation<br>Pester<br><br>[Deployment](/rest/api/securityinsights/alert-rules)<br>Create, Enable, Update, Delete, Export<br>[Alert templates support](/rest/api/securityinsights/alert-rule-templates) |
| Automation Rules | [Code Review](/azure/security/develop/security-code-analysis-overview) <br>Schema validation<br><br>[Deployment](/rest/api/securityinsights/alert-rules)<br>Create, Enable, Update, Delete, Export |
| Connectors | [Code Review](/azure/security/develop/security-code-analysis-overview)<br>Schema validation<br><br>[Deployment](/rest/api/securityinsights/data-connectors)<br>Actions: Enable, Delete (Disable), Update |
| Hunting Rules | [Code Review](/azure/security/develop/security-code-analysis-overview)<br>KQL Syntax validation<br>Schema validation<br>Pester<br><br>[Deployment](/azure/sentinel/hunting-with-rest-api)<br>Actions: Create, Enable, Update, Delete, Export |
| Playbooks | [Code Review](/azure/security/develop/security-code-analysis-overview)<br>TTK <br><br>[Deployment](/azure/logic-apps/logic-apps-azure-resource-manager-templates-overview) <br>Actions: Create, Enable, Update, Delete, Export |
| Workbooks | [Deployment](/azure/azure-monitor/visualize/workbooks-automate)<br>Actions: Create, Update, Delete |
| Runbooks | [Code Review](/azure/security/develop/security-code-analysis-overview)<br>PowerShell Syntax validation<br>Pester<br><br>[Deployment](/azure/automation/automation-deploy-template-runbook)<br>Actions: Create, Enable, Update, Delete, Export |

Depending on the automation language you choose, some automation capabilities might not be supported. The following diagram shows which automation capabilities are supported by language.

![Supported automation capabilities chart](./media/supported-automation-capabilities.png)

\* Features in development or not yet documented<br>
\** Automation methods supported by [Microsoft Operational Insights](/rest/api/loganalytics/workspaces) or [Microsoft Insights Resource Provider APIs](/azure/templates/microsoft.insights/workbooks?tabs=bicep)

#### Azure Automation

The following diagram shows the components of simplifying Microsoft Sentinel access with managed service identity.

![Azure Sentinel managed service identity diagram](./media/azure-sentinel-managed-service-identity.png)

*Download a [Visio file](https://arch-center.azureedge.net/US-1902821-automate-sentinel-integration-architecture.vsdx) of this architecture.*

If you need to grant access to another resources, using managed identity ensures a unique identity for all critical operations.

Use Azure Automation for setting up playbooks. Use PowerShell scripts for the following complex tasks and automation features.

* Integrating with third-party solutions, where different levels of credentials are required and based on Azure AD or custom credentials
  * Azure AD User Credentials
  * Azure AD Service Principal Credentials
  * Certificate authentication
  * Custom credentials
  * Managed identity
* Implementing a solution that reuses organizational scripts, or solutions that require the use of PowerShell commands to avoid complex translation to playbooks
  * PowerShell-based solutions
  * Python-based solutions
* Implementing solutions on hybrid scenarios, where remediation actions can affect your cloud and on-premises resources

#### Microsoft Sentinel repositories

Experienced DevOps teams might consider managing Microsoft Sentinel in Infra as Code (IaC) with CI/CD pipelines built in Azure DevOps. Product groups understand the challenges customers and partners face in building Azure DevOps Security Architecture, so the following two initiatives can help.  

* Documenting the reference architecture
* Developing a new solution, announced at Ignite 2021, called “Microsoft Sentinel Repositories”.

To support choosing the solution that fits your team's needs, the following table compares the functional and technical criteria.

| Use case and features | Azure DevOps and GitHub custom approach | Microsoft Sentinel repositories |
| ---- | --- | --- |
| We want to quickly start deploying Microsoft Sentinel artifacts without spending time in defining ADO architecture, such as, agents, pipelines, Git, dashboards, Wiki, service principals, RBACs, auditing, and so on.  | Not recommended | Recommended |
| We have small teams and low skill sets to manage the CI/CD pipelines. | Not recommended | Recommended |
| We want to control and manage all security aspects of the CI/CD pipelines. |  Supported | Not supported |
| We need to integrate gates and branching for supervising integration, before allowing developers to trigger deployment pipelines, such as, source control, coding review, rollback, workflow approval, and so on. | Supported | Partially supported |
| We have a customized Git or Repository structure. | Supported | Supported |
| We don't use ARM or Bicep IaC languages to build artifacts. | Supported | Not supported |
| We want to centrally manage the deployment of artifacts to multiple Microsoft Sentinel workspaces in a single Azure AD Tenant. | Supported | Supported |
| We want to integrate or extend CI/CD pipelines across multiple Azure AD Tenants. | Supported | Supported |
| We have playbooks with different parametrization depending on subscription, location, environment, and so on. | Supported | TBD, guidelines to be documented |
| We want to integrate different artifacts on the same repository to compose use cases. | Supported | Supported |
| We want the ability to bulk remove artifacts. | Supported | Not Supported |

### Availability, performance, and scalability

When choosing the architecture for the Azure DevOps Agents in your company for Microsoft Sentinel scenarios, consider the following needs.

* The Production environment might require a dedicated agents pool for operations over the Microsoft Sentinel environment.
* Non-Production environments might share the agent pool with a large number of instances for handling the different demands from the teams, in particular, for CI/CD practices.
  * Attack simulation scenarios are a special case where dedicated agents can be required. Consider whether a dedicated pool is necessary for your testing needs.
* Organizations working on hybrid networking scenarios might consider integrating the agents inside the network.

Organizations can create their own images for agents based on containers. For more information, see [Run a self-hosted agent in Docker](/azure/devops/pipelines/agents/docker?view=azure-devops#create-and-build-the-dockerfile-1)  

#### Microsoft Sentinel cross-tenant management with Azure DevOps

As a Global SOC or Managed Security Service Provider (MSSP), you might have to manage multiple tenants. Azure Lighthouse supports scaled operations across several Azure Active Directory (Azure AD) tenants at once, making your management tasks more efficient. For more information, see [Azure Lighthouse Overview](/azure/lighthouse/overview).

The following scenarios are where cross-tenant management is especially effective.

* Manage Microsoft Sentinel resources [in customer tenants](/azure/sentinel/multiple-tenants-service-providers).
* [Track attacks and view security alerts across multiple tenants](https://techcommunity.microsoft.com/t5/azure-sentinel/using-azure-lighthouse-and-azure-sentinel-to-monitor-across/ba-p/1043899).
* [View incidents](/azure/sentinel/multiple-workspace-view) across multiple Microsoft Sentinel workspaces that are spread across tenants.

#### Methods to onboard customers

You have two options to onboard customers.

#### Manual onboarding using an ARM template

If you don't want to publish an offer to Azure Marketplace as a ‘Service Provider’, or you don't meet all the requirements, you can onboard customers manually by using Azure Resource Manager templates. This is the most likely option in an enterprise scenario, where the same enterprise has multiple tenants.

The following table compares the onboarding methods.

| Consideration | Managed Service offer | ARM templates |
| ---- | --- | --- |
| Requires a [Partner Center account](/azure/marketplace/partner-center-portal/create-account) | Yes | No |
| Requires [Silver or Gold cloud platform competency level](/partner-center/learn-about-competencies) or [Azure Expert MSP](https://partner.microsoft.com/membership/azure-expert-msp) | Yes | No |
| Available to new customers through Azure Marketplace | Yes | No |
| Can limit offer to specific customers | Yes (only with private offers, which can't be used with subscriptions established through a reseller of the Cloud Solution Provider (CSP) program) | Yes |
| Requires customer acceptance in Azure portal | Yes | No |
| Can use automation to onboard multiple subscriptions, resource groups, or customers | No | Yes |
| Immediate access to new built-in roles and Azure Lighthouse features | Not always (generally available after some delay) | Yes |

For more information on publishing Managed Service offers, see [Publish a Managed Service offer to Azure Marketplace](/azure/lighthouse/how-to/publish-managed-services-offers).

For more information on how to create an Azure Resource Manager template, see [Create and deploy Azure Resource Manager templates](/learn/modules/create-deploy-azure-resource-manager-templates/).

The following diagram shows the high-level architecture integration between a Managed Security Service Provider (MSSP) tenant and a Customer's resource provider tenants with Azure Lighthouse and Microsoft Sentinel.

 ![Azure Sentinel managed service identity diagram](./media/azure-lighthouse-for-microsoft-sentinel-architecture.png)

**Identity across multiple tenants**

To manage Microsoft Sentinel with Azure DevOps, evaluate the following design decisions for the components.
| Use case | Pros |
| ---- | --- |
| Global Identity for managing DevOps actions, single service principal | This case applies to Global Deployment processes, which involve all tenants.<br><br>Using unified identity facilitates the access for the different Tenants but could make complex managing approval actions for specific tenants.<br><br> Also is very important the protection mechanism and authorization model for this kind of identity, to avoid usage non-authorized due to the global impact related. |  
| Dedicated Identity for managing DevOps actions, multiple service principals | This case applies when deployment processes are dedicated for each tenant or is requiring approval actions by the tenant. <br><br>In this case, the recommendation for protecting and authorizing this identity usage is the same as in the Global case, even when the impact is reduced.  |

**Code repository organization**

| Use case | Pros |
| ---- | --- |
| Unified Repository with single version of code for all Tenants. | This case facilitates having unified versions for the Code in the repository.<br><br>In this case, with a unified version of the code managing specific version for tenant could require support it over branches for each case. | 
| Unified Repository with specific code folders by tenant. | In complement to the Single Repository case, we can split dedicated artifact under a folder structure by Tenant. |
| Dedicated Repository by Tenant | With this approach we got more isolation at the time of managing code artifacts, facilitating the evolution between tenants with different teams/requirements.<br><br>Consolidating changes, require a process between Repositories which it could require more effort to maintain. |

**Build and deployment processes**

| Use case | Pros |
| ---- | --- |
| Single Build process for all Tenants | When all the different tenants work with the same version of artifacts, this is the simplest option for implementing the generation and package.|
| Build process by Tenant | With the idea of generating different version from the code to be deployed on each tenant. | 
| Global Deployment process for all Tenants | In this case, the deployment for new and updates deployments apply to all tenant, following the same steps during the process. |
| Global Deployment process Tenant by Tenant | In this case, the deployment for new and updates deployments can apply to for one or more tenant, following the same steps during the process. |
| Dedicated Deployment process by Tenant | In this case, the deployment process is adapted to each Tenant. |
 
## Pricing

The cost of the solution varies depending on the following uses.

* The volume of data your company feeds into the Microsoft Sentinel log analytics workspace monthly
* The commitment tier you choose, as in, commitment tier or PAYG
* The retention rate of the data policies at a table or global level

For more information, see [Azure data type retention](https://techcommunity.microsoft.com/t5/azure-sentinel/new-per-data-type-retention-is-now-available-for-azure-sentinel/ba-p/917316).

To calculate pricing, see the [Azure Sentinel pricing calculator](/pricing/details/azure-sentinel/). For more information on the advanced pricing considerations and examples, see [Azure Sentinel billing](/azure/sentinel/azure-sentinel-billing).  

Additional cost can incur if you extend your solution with the following components.
  
* Playbooks - Logic apps and functions runtime. For more information, see [Pricing details](/pricing/details/logic-apps/).  
* Exporting to external storage like ADX, EventHub, or Storage Account.
* ML Workspace and compute used by the Jupyter Notebook component.

## Deploy this scenario

The following section describes the steps for deploying this scenario in the form of a sample use case covering the various DevOps processes.

### Build and release the Microsoft Sentinel framework

You first set up the necessary NuGet components in a dedicated repository where different processes can consume the releases that you generate.

If you're working with Azure DevOps, you can create a component feed to host the different NuGet packages from the Microsoft Sentinel Framework for PowerShell. For more information, see [Get started with Nuget packages](/azure/devops/artifacts/get-started-nuget?view=azure-devops&tabs=windows).

![Create component feed to host Nuget packages](./media/create-new-feed-to-host-nuget-package.png)

If your team chooses a GitHub registry, you can connect it as a NuGet repository, because it's compatible with the feed protocol. For more information, see [Introduction to GitHub packages](https://docs.github.com/en/packages/learn-github-packages/introduction-to-github-packages).

When you have an available NuGet repository, the Azure DevOps Pipeline contains a service connection for NuGet. These screen shots show the configuration for the new service connection that's named Microsoft Sentinel Nuget Framework Connection.

![Create a new service connection](./media/new-service-connection.png)

![Edit a service connection](./media/edit-service-connection.png)

After configuring the feed, you can import the Azure DevOps Pipeline for building the PowerShell framework directly from GitHub in a specific Fork. For more information, see [Build GitHub repositories](/azure/devops/pipelines/repos/github?view=azure-devops&tabs=yaml). In this case, you create a new Pipeline and choose GitHub as the code source.

Another option is to import the Git repository as an Azure DevOps Repository based on Git. In both cases, to import the pipeline, you'd specify the following path.

`src/Build/Framework/ADO/Microsoft.Sentinel.Framework.Build.yml`

Now you can run the pipeline for first time. Then, the framework builds and releases to the NuGet feed.

### Define your Microsoft Sentinel environment

When starting with Microsoft Sentinel and using these samples, you must define the environment or environments in your company, for example, Environment as Code or EaC. You specify the different elements that make up the environment for each case.

The Microsoft Sentinel architecture includes the following elements on Azure.

* Log Analytics Workspace - This workspace is the base for the solution. Security-related information is stored here and the workspace is the engine for the Kusto Query Language.
* Sentinel Solution over the Log Analytics Workspace - This solution extends the capabilities of the Log Analytics workspace for using SIEM and SOAR capabilities.
* Key Vault - The key vault keeps the secrets and keys used during the remediation processes.
* Automation Account - This account is optional and used for the remediation processes. The remediation process you use is based on the PowerShell and Python runbooks. The process includes a system-managed identity that works with different resources according to best practices.
* User Managed Identity - This feature acts as a Sentinel unified identity layer that manages interactions between Microsoft Sentinel playbooks and runbooks.
* Logic App Connections - These are connections for Microsoft Sentinel, the key vault, and automation using the user-managed identity.
* Logic App Connections - These are connections for external resources involved in the remediations processes based on the playbooks.
* Event Hubs - This feature is optional and handles integration between Sentinel and other solutions in NESTLE, such as Splunk, Databricks/ML, and Resilient.
* Storage Account - This feature is optional and handles integration between Sentinel and other solutions in NESTLE, such as Splunk, Databricks/ML, and Resilient.

Using examples from the repository, you can define the environment using JSON files to specify the different logical concepts. The options available for defining the environment can be literal or automatic.

In a literal definition, you specify the name and the elements for each resource in the environment as shown in this example.

```json
{
    {
        "SubscriptionId": "<subscription-identifier-associated-with-service-connection>",
        "Name": "<environment-name>",
        "NamingConvention": "<naming-convention-template-for-automatic-cases>",
        "Location": "<environment-location>",
        "ResourceGroup": {
            "Type": "Literal",
            "ResourceGroupName": "<resource-group-name>"
         }
    },
    "Resources":
    {
        "Sentinel":
        {
            "Type": "Literal",
            "LogAnalyticsWorkspaceName": "<Log-Analytics-workspace-name>",
            "ManagedIdentityName": "<user-managed-identity-name>",
            "SentinelConnectionName": "<Sentinel-API-connection-name>",
            "KeyVaultName": "<Key-Vault-name>",
            "KeyVaultConnectionName": "<Key-Vault-API-connection-name>"
        },
        "Automation":
        {
            "Type": "Literal",
            "AutomationAccountName": "<automation-account-name>",
            "AutomationAccountConnectionName": "<automation-account-API-connection-name>"
        },
        "Integration":
        {
            "Type": "Literal",
            "EventHubNamespaces": [
                "<Event-Hubs-namespace-1-name>",
                "<Event-Hubs-namespace-2-name>",
                "<Event-Hubs-namespace-3-name>",
                "<Event-Hubs-namespace-4-name>",
                "<Event-Hubs-namespace-5-name>",
                "<Event-Hubs-namespace-6-name>",
                "<Event-Hubs-namespace-7-name>",
                "<Event-Hubs-namespace-8-name>",
                "<Event-Hubs-namespace-9-name>",
                "<Event-Hubs-namespace-10-name>",
            ],
            "StorageAccountName": "<storage-account-name>"
        }
    }
}

```
In an automatic definition, naming the elements generates automatically based on naming conventions as shown in this example.

```json
{
    {
        "SubscriptionId": "<subscription-identifier-associated-with-service-connection>",
        "Name": "<environment-name>",
        "NamingConvention": "<naming-convention-template-for-automatic-cases>",
        "Location": "<environment-location>",
        "ResourceGroup": {
            "Type": "Automatic"
        }
    },
    "Resources":
    {
        "Sentinel":
        {
            "Type": "Automatic"
        },
        "Automation":
        {
            "Type": "Automatic"
        },
        "Integration":
        {
            "Type": "Automatic",
            "MaxEventHubNamespaces": 5
        }
    }
}
```

You can find samples in the GitHub repository under the Microsoft Sentinel environments path and use the samples as a reference in preparing your use cases.

### Deploy your Microsoft Sentinel environment

When you have at least one environment defined, you can create the Azure Service Connection to integrate with Azure DevOps. Once you create the Service Connection, be sure you set the linked Service Principal to the Owner role or similar permissions level over the target subscription.

1. Import the pipeline for creating the new environment as defined in this file.

   `src/Release/Sentinel Deployment/ADO/Microsoft.Sentinel.Environment.Deployment.yml`

1. Next, enter the name of the service connection that represents the environment.

   ![Enter the name of the service connection](./media/import-pipeline-to-deploy-sentinel.png)

1. Choose the branch for the environment definition in the repository.  
1. Enter the name of the Azure DevOps service connection for your subscription in the **Azure Environment Connection** field.
1. Enter the name of the environment that a service connection can use to resolve multiple environments in the same subscription.
1. Choose the action to apply to the connectors.
1. Check **Use PowerShell Pre-Release Artifacts** if you want to use the pre-release versions of the PowerShell framework components.

The pipeline includes the following steps as part of the deployment flow.

* Deploy NuGet components
* Connect using NuGet tools with artifacts repository
* Resolve the feed
* Install the required modules
* Get the environment definition
* Validate which resources exists in the destination
* Create log analytics and Microsoft Sentinel if they don't exist 
* Create Microsoft Sentinel over an existing log analytics, an alternative to the previous step
* Create Manage Identity for representing the interaction with Microsoft Sentinel from logic apps
* Create the Azure Key Vault and set the role assignment for managing secrets and keys to the manage identity
* Create, if applicable, the Azure Automation account and enable the system-assigned managed identity if it doesn't exist
* Set the role assignment over the key vault for the system-assigned managed identity
* Create the Azure Event Hubs definitions if they don't exist and set whether the definition includes the integration elements
* Set the role assignment over the key vault for the system-assigned managed identity
* Create the storage account definitions if they don't exist and set whether the definition includes the integration elements
* Set the role assignment over the key vault for the system-assigned managed identity
* Deploy the connector actions
* Deploy the Integration Runbook on the automation account
* Deploy the logic app connections if they're defined as part of the environment

### Destroy a Microsoft Sentinel environment

When the environment is no longer needed, like in the case of a development or testing environment, you can destroy it as defined in this file.

`src/Release/Sentinel Deployment/ADO/Microsoft.Sentinel.Environment.Destroy.yml`

As in deploying the environment pipeline, you must specify the name of the service connection that represents the environment.

### Working with your Microsoft Sentinel environment

Once your environment is ready, you can start creating the artifacts for setting up the different use cases.

1. Export the artifacts from the environment you're working on as defined in this file.

   `src/Release/Artifacts Deployment/ADO/Microsoft.Sentinel.Artifacts.Export.yml`

1. Choose the branch for the environment definition in the repository.

   ![Choose branch for exporting the artifacts](./media/export-artifacts-pipeline.png)

1. Enter the name of the Azure DevOps service connection for the environment being exported in the **Azure Environment Connection** field.
1. Select **Use PowerShell Pre-Release Artifacts** if you want to use the pre-release versions of the PowerShell framework components.
1. Choose the format for the analytic and hunting rules.

   The artifacts output file is available in the results. Once you have the artifacts, you can include the output file in the Git repository.

### Build your artifacts in the Microsoft Sentinel environment

Place your artifacts under the Sentinel Mitre use cases path. Set up your folder structure according to the different types of artifacts.

1. Start the build process as defined in this file.

   `src/Build/Artifacts/ADO/Microsoft.Sentinel.Artifacts.Build.yaml`

1. Choose the branch for the environment definition in the repository.

   ![Choose the branch for building the artifacts](./media/build-artifacts-pipeline.png)

1. Select **Use PowerShell Pre-Release Artifacts** if you want to use the pre-release versions of the PowerShell framework components.

The pipeline is made up of these steps.

* Deploy NuGet components
* Connect the NuGet tools to the NESTLE artifacts Repository
* Resolve the feed
* Install the required modules
* Get the [TTK framework](/azure/azure-resource-manager/templates/test-toolkit) for validating the Azure ARM templates
* Validate the Azure ARM templates
* Validate the PowerShell Runbooks code and do syntax validation
* Run the Pester unit tests if applicable
* Validate the KQL syntax in the hunting and analytic rules

### Deploy your artifacts to the Microsoft Sentinel environment

In deploying your artifacts, you can use the Microsoft Sentinel repositories or the deployment pipeline samples on this repository. For more information, see [Deploy custom content from your repository](/azure/sentinel/ci-cd?tabs=github).

#### Microsoft Sentinel repositories

If you use Microsoft Sentinel repositories, you can set up a release process to include the artifacts in the repository connected to each Microsoft Sentinel instance. Once the artifacts are committed in the repository, some of the steps are automatically done as part of creating the pipeline and enabling the Microsoft Sentinel repositories.

Also, you can customize the deployment processes that the Microsoft Sentinel repositories do based on practices described in this document. One important aspect to consider is the release approval, which you can set up following these approaches.

* Pull request approval at the time of committing the artifacts. For more information, see [Create pull requests](/azure/devops/repos/git/pull-requests?view=azure-devops&tabs=browser)
* Release pipeline approval at the time of running the deployment. For more information, see [Define approvals and checks](/azure/devops/pipelines/process/approvals?view=azure-devops&tabs=check-pass)]

#### Microsoft Sentinel deployment pipeline samples

Using the Microsoft Sentinel deployment pipeline samples, you can set up a release process.

1. Set up your release process as defined in this file.

   `src/Release/Artifacts Deployment/ADO/Microsoft.Sentinel.Artifacts.Deployment.yml`

1. Choose the branch for the environment definition in the repository.

   ![Choose the branch for setting up the release process](./media/set-up-release-pipeline.png)

1. Enter the name of the Azure DevOps service connection for the environment being exported in the **Azure Environment Connection** field.
1. Select **Use PowerShell Pre-Release Artifacts** if you want to use the pre-release versions of the PowerShell framework components.

## Next steps

* To learn about Microsoft Sentinel with DevOps for single-tenant architecture, see [Deploying and Managing Microsoft Sentinel as Code](https://techcommunity.microsoft.com/t5/azure-sentinel/deploying-and-managing-azure-sentinel-as-code/ba-p/1131928)
* To learn about MSSP multi-tenant architecture, see [Combining Azure Lighthouse with Sentinel’s DevOps capabilities](https://techcommunity.microsoft.com/t5/azure-sentinel/combining-azure-lighthouse-with-sentinel-s-devops-capabilities/ba-p/1210966)
* For information on Managed identity with Microsoft Sentinel, see [What’s new: Managed Identity for Microsoft Sentinel Logic Apps connector](https://techcommunity.microsoft.com/t5/azure-sentinel/what-s-new-managed-identity-for-azure-sentinel-logic-apps/ba-p/2068204)
* To learn how to deploy content from a Microsoft Sentinel repository, see [Deploy custom content from your repository](https://docs.microsoft.com/en-us/azure/sentinel/ci-cd?tabs=github)
* To learn about Azure DevOps Security considerations, see:[Default permissions quick reference](/azure/devops/organizations/security/permissions-access?toc=%2Fazure%2Fdevops%2Fget-started%2Ftoc.json&bc=%2Fazure%2Fdevops%2Fget-started%2Fbreadcrumb%2Ftoc.json&view=azure-devops)
* To learn how to protect an Azure DevOps repository, see [Add protection to a repository resource](/azure/devops/pipelines/process/repository-resource?view=azure-devops)
* For information on how to manage Azure DevOps service connection security, see [Service connections in Azure Pipelines](https://docs.microsoft.com/en-us/azure/devops/pipelines/library/service-endpoints?view=azure-devops&tabs=yaml)

## Related resources

* [Azure Active Directory](https://azure.microsoft.com/services/active-directory/)
* [Azure DevOps](https://azure.microsoft.com/services/devops/)
* [Azure Key Vault](https://azure.microsoft.com/services/key-vault/)
* [Azure Policy](https://azure.microsoft.com/services/azure-policy/)
* [Microsoft Sentinel](https://azure.microsoft.com/services/azure-sentinel/)
* [Azure Automation](https://azure.microsoft.com/services/automation/)