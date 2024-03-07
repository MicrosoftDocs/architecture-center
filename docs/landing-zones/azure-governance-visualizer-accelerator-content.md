Organizations can use the Azure Governance Visualizer to capture pertinent governance information about their Azure tenants. The tool captures:

- Management group hierarchy.
- Policy information, such as custom policy definitions, orphaned custom policy definitions, and policy assignments.
- Role-based access control (RBAC) information, such as custom role definitions, orphaned custom role definitions, and role assignments.
- Azure security and best practice analysis.
- Microsoft Entra ID insights.

The Azure Governance Visualizer accelerator runs the visualizer in an automated way through Azure Pipelines or GitHub Actions. The visualizer outputs the summary as HTML, MD, and CSV files. Ideally, the generated HTML report is made easily accessible to authorized users in the organization. This article shows you how to automate running the Azure Governance Visualizer and host the reporting output securely and cost effectively on the Web Apps feature of Azure App Service.

An example implementation is available on GitHub at [Azure Governance Visualizer accelerator](https://github.com/Azure/Azure-Governance-Visualizer-Accelerator).

## Architecture

![Diagram showing the architecture of the Azure Governance Visualizer accelerator.](images/azure-governance-visualizer-accelerator-architecture.svg)

*Download a [Visio file](https://arch-center.azureedge.net/azure-governance-visualizer-accelerator.vsdx) of this architecture.*

## Data flow

The solution architecture implements the following workflow:

1. A timer triggers the GitHub Actions flow.
1. The flow makes an OpenID Connect connection to Azure. It then runs the Azure Governance Visualizer tool. The tool collects the required insights in the form of HTML, MD, and CSV reports.
1. The reports are pushed to the GitHub repository.
1. The HTML output of the Azure Governance Visualizer tool is published to App Service.

### User flow

This flow explains how a user can use the tool:

1. The user browses to the App Service URL to access the HTML report of the visualizer. The user is required to authenticate through Microsoft Entra ID authorization.
1. The user can review the insights provided by the visualizer.

## Components

The accelerator is based on a GitHub template repository that consists of the following components:

- [Microsoft Entra ID](https://azure.microsoft.com/products/active-directory) is an enterprise identity service that provides single sign-on, multifactor authentication, and conditional access.
- [Azure App Service](https://azure.microsoft.com/services/app-service) is a fully managed platform for creating and deploying cloud applications. It lets you define a set of compute resources for a web app to run, deploy web apps, and configure deployment slots.
- [GitHub](https://docs.github.com/) is a popular SaaS offering from Microsoft that is frequently used by developers to build, ship, and maintain their software projects.
- [GitHub Actions](/azure/developer/github/github-actions) provides continuous integration and continuous deployment capabilities in this architecture.

## Alternatives

- The Azure Governance Visualizer is a PowerShell script, which can be run directly on a local machine. The visualizer can be configured to run as part of GitHub Actions or Azure DevOps pipeline to receive up-to-date information about your environment. The visualizer produces a wiki as an output that can be published in GitHub or Azure DevOps.

- The visualizer can also be hosted on any other hosting platform that is secure and also cost-effective, like [Azure Static Web Apps](/azure/static-web-apps/overview).

## Scenario details

Azure Governance Visualizer is a PowerShell-based script that iterates your Azure Tenant´s Management Group hierarchy down to subscription level. It captures most relevant Azure governance capabilities, such as Azure Policy, RBAC, Microsoft Entra ID, and Blueprints. From the collected data, Azure Governance Visualizer visualizes all of this information in an easy to navigate HTML report.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

Restricting the reporting HTML to only those users authorized to view this data is important. This data is a gold mine for both insider and external threats, as it exposes your Azure landscape, including security controls.

- Use Microsoft Entra authentication to restrict access to authorized individuals. Consider using Web Apps authentication to provide this service. In the accelerator, the deployment configures to Web Apps and actively verifies that authentication is enabled before deploying.

- Consider applying network security controls to expose the site to your team only over a [private endpoint](/azure/private-link/private-endpoint-overview). And to restrict traffic, consider using the IP restrictions of Web Apps.

- Enable access logging on the Azure web app to be able to audit access. Configure the Azure web app to send those logs to a Log Analytics workspace.

- Ensure secure communication is enabled on the Azure web app. In the accelerator, only HTTPS and FTPs are allowed, and the minimum version of TLS is configured as 1.2.

- Consider using [Microsoft Defender for Cloud's Microsoft Defender for App Service](/azure/defender-for-cloud/defender-for-app-service-introduction).

- Use the [latest versions of the runtime stack](/azure/app-service/language-support-policy?tabs=windows) of the Azure web app.

- Make sure to rotate the secret of this service principal regularly and monitor its activity. To gather all the required information, the visualizer deployed by the accelerator depends on a service principal with Microsoft Entra ID permissions.

For more information about security controls, see [Azure security baseline for App Service](/security/benchmark/azure/baselines/app-service-security-baseline).

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

- The B1 (Basic) tier is used for the deployed Azure web app in App Service. App Service hosts the HTML output of the Azure Governance Visualizer tool so it's lightweight.

- The accelerator only deploys one instance of App Service, but you can choose to deploy more if needed.

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

- The accelerator consists mainly of an Azure web app that hosts the HTML output of the visualizer tool. We recommend you enable the diagnostic settings of the web app to monitor traffic, access audit logs, metrics, and more.

- It's important to monitor the performance of the web app. Doing so helps to identify if you need to scale up or scale out depending on the amount of visualizer usage.

- It's also important to always run the [latest versions of the runtime stack](/azure/app-service/language-support-policy?tabs=windows) of the Azure web app.

- The Azure Governance Visualizer updates versions regularly with new features, bug fixes, or improvements. In the accelerator, a dedicated GitHub workflow handles the update process. There's a configurable option to update the visualizer's code automatically or manually by just opening a pull request with changes you can review and merge.

- The accelerate code might get updated with new settings on the App Service bicep code or with new instructions for the visualizer prerequisites. In the accelerator, a dedicated GitHub workflow handles this update process. There's a configurable option to update the visualizer's code automatically or manually by just opening a pull request with changes you can review and merge.

## Deploy this scenario

To deploy this scenario, see [Azure Governance Visualizer accelerator](https://github.com/Azure/Azure-Governance-Visualizer-Accelerator).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Seif Bassem](https://www.linkedin.com/in/seif-bassem) | Cloud Solution Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Azure Governance Visualizer accelerator](https://github.com/Azure/Azure-Governance-Visualizer-Accelerator)
- [Azure Governance Visualizer](https://github.com/Azure/Azure-Governance-Visualizer)

## Related resources

- [Azure landing zones - Bicep modules design considerations](../landing-zones/bicep/landing-zone-bicep.md)
- [Azure landing zone overview](/azure/cloud-adoption-framework/ready/landing-zone/)
