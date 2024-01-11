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

- Guidance on how to prepare and configure the needed prerequisites to deploy the accelerator.
- PowerShell scripts to automate the configuration of your environment.
- GitHub actions to deploy and update the Azure Governance Visualizer tool.
- GitHub actions to deploy and update the accelerator's resources like the Azure Web App hosting the Azure Governance Visualizer output.

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
- Schedule a recurring GitHub Action to check and sync newer versions of Azure Governance Visualizer accelerator.

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
