---
title: Azure Governance Visualizer Deployment Guidance
description: Analyze and streamline cloud governance for compliance and operational insights across your organization by using Azure Governance Visualizer.
author: sebassem
ms.author: sebassem
ms.date: 03/01/2026
ms.topic: concept-article
ms.subservice: architecture-guide
---

# Use Azure Governance Visualizer to optimize cloud governance

This article describes how to deploy Azure Governance Visualizer. Organizations can use the visualizer to capture pertinent governance information, like management group hierarchies, policy information, and security analysis, and access the output in multiple formats. This article shows you how to automate the visualizer, and how to host the output securely and cost effectively on the Web Apps feature of Azure App Service.

## Architecture

:::image type="complex" border="false" source="./images/azure-governance-visualizer-accelerator-architecture.svg" alt-text="Diagram that shows the deployed Azure Governance Visualizer architecture." lightbox="./images/azure-governance-visualizer-accelerator-architecture.svg":::
   Diagram that shows an Azure Governance Visualizer deployment. A user accesses an App Service instance that hosts the HTML output, and Microsoft Entra ID controls access. Inside GitHub, GitHub Actions runs Azure Governance Visualizer, pushes results to GitHub repos, and publishes the HTML output to App Service. The workflow uses Microsoft Entra ID, Microsoft Graph, and Azure Resource Manager, and it collects governance data such as management groups, subscriptions, resource groups and resources, Azure Policy definitions, assignments, compliance, exemptions, and remediation, Azure RBAC custom roles and role assignments, Microsoft Defender for Cloud plans, and network, diagnostics, limits, and cost management data.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/azure-governance-visualizer-accelerator-architecture.vsdx) of this architecture.*

## Data flow

The following data flow corresponds to the previous diagram:

1. A timer triggers the GitHub Actions flow.

1. The flow connects to Azure. Azure Governance Visualizer compiles the output into HTML, MD, or CSV format.

1. The files are pushed to the GitHub repository.

1. The HTML output is published to the App Service instance.

1. The user authenticates by using Microsoft Entra ID.

1. The user accesses the HTML output by using the App Service instance.

## Components

- [Microsoft Entra ID](/entra/fundamentals/what-is-entra) is an enterprise identity service that protects against cybersecurity threats by using single sign-on, multifactor authentication. In this architecture, it's used for secure authentication and authorization to the Azure Governance Visualizer web app for a specific Microsoft Entra ID group.

- [App Service](/azure/well-architected/service-guides/app-service-web-apps) is a fully managed platform to create and deploy cloud applications. You can use App Service to define compute resources for web apps, to configure deployment slots, and to deploy web apps. In this architecture, it's used to host Azure Governance Visualizer output for secure and smooth access across the organization.

- [GitHub](https://docs.github.com/) is a web-based software to build, ship, and maintain software projects. In this architecture, it's used to host the infrastructure as code for the solution, and to host the GitHub actions that are used to deploy and maintain it.

- [GitHub Actions](/azure/developer/github/github-actions) is a continuous integration and continuous delivery platform to automate your build, test, and deployment pipeline. In this architecture, it's used to deploy and update Azure Governance Visualizer.

## Alternatives

Azure Governance Visualizer is a PowerShell script that can be run directly on a local machine. To receive up-to-date information about your environment, configure the visualizer to run as part of GitHub Actions. The visualizer outputs a wiki that you can publish in GitHub or Azure DevOps.

## Scenario details

Azure Governance Visualizer iterates your organization's management group hierarchy down to the subscription level. It captures most relevant Azure governance capabilities, such as Azure Policy, Azure role-based access control (Azure RBAC), Microsoft Entra ID, and Azure Blueprints. The visualizer outputs this information.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

- Restrict access to the output to only authorized users. The data contains your Azure landscape, including security controls, and might be valuable to cybercriminals.

- You can use Web Apps authentication to restrict access. The deployment code in GitHub configures Web Apps and actively verifies that authentication is turned on before deployment.

- Apply network security controls to expose the site to your team only over a [private endpoint](/azure/private-link/private-endpoint-overview). Restrict traffic by using the IP address restrictions available in Web Apps.

- Audit access by using web app access logging. Configure the web app to send access logs to an Azure Monitor Logs workspace.

- Turn on secure communication on the web app. Secure communication uses only HTTPS and File Transfer Protocol Secure and requires a minimum Transport Layer Security version of 1.2.

- Consider using [Microsoft Defender for App Service](/azure/defender-for-cloud/defender-for-app-service-introduction).

- Use the [latest runtime stack versions](/azure/app-service/language-support-policy?tabs=windows) for the web app.

- Rotate the service principal secret regularly and monitor its activity. To gather the required information, Azure Governance Visualizer depends on a service principal with Microsoft Entra ID permissions.

For more information about security controls, see [Azure security baseline for App Service](/security/benchmark/azure/baselines/app-service-security-baseline).

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

- Use the B1 (Basic) tier for the deployed App Service web app. App Service hosts the HTML output so it requires a lightweight configuration. You can host Azure Governance Visualizer on any other secure, cost-effective hosting platform.

- Use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate the costs of the Azure components in this solution.

- The sample in GitHub deploys only one App Service instance, but you can deploy as many as you need.

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

- To monitor operational data like traffic, access audit logs, and metrics, configure the web app's diagnostics settings.

- Monitor web app performance and usage to determine when to adjust scaling.

- Use the latest runtime stack versions for the web app.

- Azure Governance Visualizer updates regularly with new features, bug fixes, and improvements. Updates might include new App Service Bicep settings or revised prerequisite instructions. A GitHub workflow manages updates. You can configure it to update automatically or you can review the changes in a pull request.

## Deploy this scenario

To deploy this scenario, see the [Azure Governance Visualizer Accelerator GitHub repository](https://github.com/Azure/Azure-Governance-Visualizer-Accelerator).

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Seif Bassem](https://www.linkedin.com/in/seif-bassem) | Cloud Solution Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Azure Governance Visualizer Accelerator GitHub repository](https://github.com/Azure/Azure-Governance-Visualizer-Accelerator)
- [Azure Governance Visualizer Open Source project](https://github.com/Azure/Azure-Governance-Visualizer)
- [What is an Azure landing zone?](/azure/cloud-adoption-framework/ready/landing-zone/)