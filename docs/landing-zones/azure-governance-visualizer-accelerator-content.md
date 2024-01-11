The [Azure Governance Visualizer Accelerator](https://github.com/Azure/Azure-Governance-Visualizer-Accelerator) is a GitHub repository that contains guidance and code for running the [Azure Governance Visualizer](https://github.com/azure/azure-governance-visualizer) in a GitHub pipeline.

The Azure Governance Visualizer is a repository containing a PowerShell script that captures pertinent governance information about your Azure Tenant, including the following:

- Management group hierarchy.
- Policy information such as custom policy definitions, orphaned custom policy definitions, and policy assignments.
- RBAC information such as custom role definitions, orphaned custom role definitions, and role assignments.
- Azure security and best practice analysis.
- Microsoft Entra ID insights.

The visualizer outputs the summary as html, md, and csv files. Ideally, the visualizer would be run periodically as a pipeline and would output the results to a location where authorized users could easily view the governance information.

The Azure Governance Visualizer Accelerator provides guidance and code for running the Azure Governance Visualizer in GitHub Actions and publishes the results to an Azure App Service.

## Architecture

[![Diagram showing the architecutre of the Azure Governance Visualizer accelerator.](images/AzGovViz-accelerator-architecture.png)](images/AzGovViz-accelerator-architecture.png)
*Figure 1. Azure Governance Visualizer accelerator architecture.*

## Workflow

### Data flow

The solution architecture implements the following workflow:

1. The user prepares all the prerequisites needed by either running the provided powerShell commands or through the portal.
2. A GitHub workflow is triggered to deploy the needed Azure infrastructure including an Azure App Services.
3. A GitHub workflow is triggered to deploy the Azure Governance Visualizer (AzGovViz) tool. This workflow will run the tool once its deployed to start collecting all the needed insights from your tenant.
4. The output of the AzGovViz tool in HTML format is published to the created Azure App Service which is protected by Entra ID authentication.

### User flow

This flow explains how a uer would use the tool:

1. The user browses to the Azure App Service URl to access the html report of the visualizer.
2. The user can start drilling down through the various insights provided by the visualizer.

## Components

The accelerator is based on a GitHub template repository that consists of the following:

- [Microsoft Entra ID](https://azure.microsoft.com/products/active-directory) is an enterprise identity service that provides single sign-on, multifactor authentication, and conditional access.output.
- [Azure App Service](https://azure.microsoft.com/services/app-service) is a fully managed platform for creating and deploying cloud applications. It lets you define a set of compute resources for a web app to run, deploy web apps, and configure deployment slots.
- [GitHub](https://docs.github.com/) is a popular SaaS offering from Microsoft that's frequently used by developers to build, ship, and maintain their software projects
- [GitHub Actions](https://learn.microsoft.com/azure/developer/github/github-actions) provides continuous integration and continuous deployment capabilities in this architecture.

## Alternatives

The Azure Governance Visualizer is a powerShell script which can be run directly on a local machine or configured to be run as part of a GitHub Action or Azure DevOps pipeline to always receive up-to-date information about your environment. The visualizer produces a wiki as an output that can be published in GitHub or Azure DevOps.

## Scenario

Azure Governance Visualizer is a PowerShell based script that iterates your Azure Tenant´s Management Group hierarchy down to Subscription level. It captures most relevant Azure governance capabilities such as Azure Policy, RBAC, Microsoft Entra ID and Blueprints and a lot more. From the collected data, Azure Governance Visualizer visualizes all of this information in an easy to navigate HTML report.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](https://learn.microsoft.com/azure/architecture/framework).

### Cost optimization

Cost optimization is about reducing unnecessary expenses and improving operational efficiencies. For more information, see Overview of the [cost optimization pillar](https://learn.microsoft.com/azure/architecture/framework/cost/overview).

- Azure App Service: The F1 (free) tier is used for the deployed Azure App Service. This app service will host the HTML output of the Azure Governance Visualizer tool so its very lightweight. The accelerator only deploys one instance of Azure App Service but you can choose to deploy more if needed.

### Security

- **Data collection :** The visualizer is using least-privilege roles to collect the needed information from your tenant, service principals are used to iterate through your tenant and resources to collect this information. Microsoft Entra ID is used to grant thos privileges to the service principles.

- **Data visualization :** The output of the visualizer is published to an Azure App Service that is implementing the security best practices. The app service is also protected by Entra ID authentication so you can grant access to the output to the right users and groups.

### Operational excellence

This accelerator has four GitHub workflows:

1. *DeployAzGovVizAccelerator :* This workflow is responsible for deploying the Azure App Service and configure Entra ID authentication.
2. *DeployAzGovViz :* This workflow is responsible for deploying the Azure Governance Visualizer tool to your tenant, collect the needed information and finally publish the tool output to the deployed Azure App Services.
3. *SyncAccelerator :* This workflow is responsible for checking for any new updates to the accelerator code itself, like the Azure App Service and if any change is detected a pull request will be created to be reviewed.
4. *SyncAzGovViz :* This workflow is responsible for checking for any new version of the Azure Governance Visualizer tool and if any new version is found, it will be update either automatically or through a pull request.

## Prerequisites

The accelerator requires some prerequisites to be configured before deploying:

- **Service principals:** Multiple service principals are required to run the Azure Governance Visualizer tool with the necessary permissions and to configure Microsoft Entra ID authentication for the Azure App Service to access the tool output securely.
- **Private GitHub repository:** Azure Governance Visualizer requires the creation of a private GitHub repository to host the output of the tool. Multiple GitHub actions secrets and variables are required to properly and securely configure continuous deployment to your Azure environment via OpenID Connect.
- **Azure requirements:** Azure resource group creation to host the Azure App Service and the needed least-privilege Azure role-based access controls.

## Deployment

The deployment of the accelerator is implemented through four GitHub actions. The GitHub actions use the secrets and variables defined in the prerequisites stage to:

- Deploy an App Service Plan and an Azure Web app to a resource group.
- Configure Microsoft Entra ID authentication on the Azure Web app.
- Deploy the Azure Governance Visualizer PowerShell script with the needed configuration.
- Publish the output of the tool to the Azure Web app so it's securely accessed.
- Schedule a recurring GitHub Action to check and sync newer versions of Azure Governance Visualizer.
- Schedule a recurring GitHub Action to check and sync newer versions of Azure Governance Visualizer accelerator

## Deploy this scenario

To deploy this scenario, please navigate to this [Azure Governance Visualizer accelerator](https://github.com/Azure/Azure-Governance-Visualizer-Accelerator).

## Contributors

This article is maintained by Microsoft. It was originally written by the following contributors.

Principal author:

Seif Bassem | Cloud Solution Architect

## Next steps

From the collected data AzGovViz provides visibility on your **HierarchyMap**, creates a **TenantSummary** on Management Groups and Subscriptions. Some of the information exposed by the tool:

- Azure Policy
- Role-Based Access Control (RBAC)
- Blueprints
- Hierarchy of Management Groups
- Subscriptions, Resources & Defender
- Networking
- Diagnostics
- Limits
- Microsoft Microsoft Entra ID
- Consumption
- Change tracking

For more information, see:

- [Azure Governance Visualizer accelerator](https://github.com/Azure/Azure-Governance-Visualizer-Accelerator)
- [Azure Governance Visualizer](https://github.com/JulianHayward/Azure-MG-Sub-Governance-Reporting)
