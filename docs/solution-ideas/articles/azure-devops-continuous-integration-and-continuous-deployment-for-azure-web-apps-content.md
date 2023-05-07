> [!IMPORTANT]
> CI/CD for Azure Web Apps is a variant of [Design a CI/CD pipeline using Azure DevOps](../../example-scenario/apps/devops-dotnet-baseline.yml). This article focuses on the Web Apps-specific facets of deployment.

Azure Web Apps is a fast and simple way to create web apps using ASP.NET, Java, Node.js, Python, and other languages and frameworks. Deliver value faster to your customers with a continuous integration and continuous deployment (CI/CD) pipeline that pushes each of your changes automatically to Azure Web Apps.

## Architecture

:::image type="complex" source="../media/azure-pipelines-app-service-variant-architecture.svg" lightbox="../media/azure-pipelines-app-service-variant-architecture.svg" alt-text="Architecture diagram of a CI/CD pipeline using Azure Pipelines." border="false"::: 
Architecture diagram of an Azure Pipeline deploying to Azure App Services. The diagram shows the following steps: 1. An engineer pushing code changes to an Azure DevOps Git repository. 2. An Azure DevOps PR pipeline getting triggered. This pipeline shows the following tasks: linting, restore, build, and unit tests. 3. An Azure DevOps CI pipeline getting triggered. This pipeline shows the following tasks: get secrets, linting, restore, build, unit tests, integration tests and publishing a Web Deploy package as an artifact. 3. An Azure DevOps CD pipeline getting triggered. This pipeline shows the following tasks: download artifacts, deploy to staging, tests, manual intervention, and release. 4. Shows the CD pipeline deploying to a staging slot in Azure App Services. 5. Shows the CD pipeline releasing to a production environment by swapping the staging and production slots. 6. Shows an operator monitoring the pipeline, taking advantage of Azure Monitor, Azure Application Insights and Azure Analytics Workspace.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/azure-pipelines-app-service-variant-architecture.vsdx) of this architecture.*

### Dataflow

This section assumes you have read [Azure Pipelines baseline architecture](../../example-scenario/apps/devops-dotnet-baseline.yml#dataflow) and only focuses on the considerations specifics to deploying a workload to Azure App Services.

1. **PR pipeline** - *Same as the baseline*

1. **CI pipeline** - Same as the baseline, except the build artifacts created for Web Apps is a Web Deploy package.

1. **CD pipeline trigger** - *Same as the baseline*

1. **CD release to staging** - Same as the baseline with 2 exceptions: 1) the build artifact that is downloaded is the Web Deploy Package and 2) the package is deployed to a staging slot in App Services.

1. **CD release to production** - Same as the baseline with 2 exceptions: 1) the release to production for a Web App swaps the production and staging slot, and 2) the rollback for Web Apps swaps production and staging slots back.

1. **Monitoring** - *same as the baseline*

### Components

This section assumes you have read [Azure Pipelines baseline architecture components section](../../example-scenario/apps/devops-dotnet-baseline.yml#components) and only focuses on the considerations specifics to deploying a workload to Azure App Services.

- [Azure App Service](/azure/app-service/): Azure App Service is an HTTP-based service for hosting web applications, REST APIs, and mobile back ends. Azure Web Apps are actually applications hosted in Azure App Service.

- [Azure Web Apps](https://azure.microsoft.com/services/app-service/web): Quickly create and deploy mission-critical Web apps at scale. Azure Web Apps has many offerings, including [Windows Web Apps](/azure/app-service/overview), [Linux Web Apps](/azure/app-service/overview#app-service-on-linux), and [Web Apps for Containers](https://azure.microsoft.com/products/app-service/containers).

## Considerations

This section assumes you have read the [considerations section in Azure Pipelines baseline architecture](../../example-scenario/apps/devops-dotnet-baseline.yml#considerations) and only focuses on the considerations specifics to deploying a workload to Azure App Services.

### Operational Excellence

- Consider implementing environments beyond just staging and production to enable things like rollbacks, manual acceptance testing, and performance testing. The act of using staging as the rollback environment keeps you from being able to use that environment for other purposes.

## Next steps

* [Get started with continuous deployment to Azure App Service](/azure/app-service/deploy-continuous-deployment)
* [Get started with Git in Azure Repos](/azure/devops/repos/git/gitquickstart)
* [Deploy to App Service using Azure Pipelines](/azure/app-service/deploy-azure-pipelines)
* [Deploy to Azure Web App for Containers](/azure/devops/pipelines/apps/cd/deploy-docker-webapp)
* [Configure continuous deployment with custom containers in Azure App Service](/azure/app-service/deploy-ci-cd-custom-container)
* [Learn about work item integration with Application Insights](/azure/azure-monitor/app/work-item-integration)
* [Link GitHub commits, pull requests, and issues to work items in Azure Boards](/azure/devops/boards/github/link-to-from-github)

## Related resources

- [CI/CD baseline architecture with Azure Pipelines](../../example-scenario/apps/devops-dotnet-baseline.yml)
- [CI/CD for IaaS applications](./cicd-for-azure-vms.yml)
