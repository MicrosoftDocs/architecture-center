[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Azure Web Apps is a fast and simple way to create web apps using ASP.NET, Java, Node.js, Python, and other languages and frameworks. Deliver value faster to your customers with a continuous integration and continuous deployment (CI/CD) pipeline that pushes each of your changes automatically to Web Apps.

## Potential use cases

Azure Web Apps offer numerous benefits that include:

* Highly secure web apps development.
* Multilingual and versatile framework.
* Global scale with high availability.
* Quick analytics and actionable insights.
* Secure integration with other SaaS apps.

## Architecture

![Architecture diagram](../media/azure-devops-cicd-for-azure-web-apps.png)

*Download a [Visio file](https://arch-center.azureedge.net/azure-devops-cicd-for-web-apps.vsdx) of this architecture.*

### Dataflow

1. Change application source code.
1. Commit application code and Web Apps web.config file.
1. Continuous integration triggers application build and unit tests.
1. Continuous deployment trigger orchestrates deployment of application artifacts with environment-specific parameters.
1. Deployment to Web Apps.
1. Azure Application Insights collects and analyzes health, performance, and usage data.
1. Review health, performance, and usage information.
1. Update backlog item.

### Components

* [Azure Monitor](https://azure.microsoft.com/products/monitor/): Detect, triage, and diagnose issues in your web apps and services using [Application Insights](/azure/azure-monitor/app/app-insights-overview), an extension of Azure Monitor.
* [Web Apps](https://azure.microsoft.com/services/app-service/web): Quickly create and deploy mission critical Web apps at scale.
* [Azure DevOps](https://azure.microsoft.com/services/devops): Services for teams to share code, track work, and ship software.
* [Visual Studio](https://www.visualstudio.com/vs/azure): A creative launch pad for viewing and editing code, then debugging, building, and publishing apps for Android, iOS, Windows, the web, and the cloud.

## Deploy this scenario

* [Deploy to Azure using the DevOps Starter](https://ms.portal.azure.com/#create/Microsoft.AzureProject)

## Pricing

* [Customize and get pricing estimates](https://azure.com/e/b96a4a9dbf804edabc83d00b41ffb245)

## Contributors

*This article is maintained by Microsoft.*

## Next steps

* [Performance monitoring with Application Insights](/azure/application-insights/app-insights-detect-triage-diagnose)
* [Use Azure DevOps to deploy to an Azure Web App](/aspnet/core/host-and-deploy/azure-apps)
* [Git on Azure DevOps](/azure/devops/repos/git/gitquickstart)
* [Deploy to App Service using Azure Pipelines](/azure/app-service/deploy-azure-pipelines)
* [Deploy to Azure Web App for Containers using Visual Studio and Azure DevOps](/azure/devops/pipelines/apps/cd/deploy-docker-webapp)
