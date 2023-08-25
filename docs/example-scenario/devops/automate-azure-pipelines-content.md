This article explains how to automate the process of creating developer, test, and production environments for continuous deployment. Key automation components include Azure Logic Apps, the Azure DevOps Services REST API, and Azure Pipelines.

## Architecture

:::image type="content" source="./media/automate-azure-pipelines.svg" alt-text="Architecture diagram that shows how to use the Azure DevOps Services REST API and Logic Apps to automate the setup of a DevOps pipeline." border="false" lightbox="./media/automate-azure-pipelines.svg":::

*Download a [Visio file](https://arch-center.azureedge.net/automate-azure-pipelines.vsdx) of this architecture.*

### Dataflow

1. A developer creates a starter project in Visual Studio by using a preloaded template, such as a .NET Angular workload. In that Visual Studio solution, the developer also creates a project for an Azure resource group. That project uses an Azure Resource Manager (ARM) template to deploy an Azure App Service plan, an App Service instance, and Application Insights.
1. A YAML file for a multistage pipeline specifies how to build and publish the solution.
1. The developer uses `git push` to copy the solution to an Azure Repos repository.
1. In response to the Git command, Azure DevOps Services dispatches a notification via a webhook.
1. The webhook triggers a logic app.
1. The logic app determines whether the push command was in the main branch or a feature branch of the repository. If the logic app detects a commit in the main branch, it searches for pipelines that correspond to the repository.
1. If a pipeline for the repository already exists in Azure Pipelines, the logic app uses the Azure DevOps Services REST API to update the pipeline. If no pipeline exists, the logic app creates one.
1. The multistage pipeline builds, publishes, and deploys an artifact to Azure resources. The published artifact has a .NET Angular zip folder that's ready for deployment to the App Service instance. The artifact also contains ARM templates and parameter files that provision the Azure infrastructure.
1. The multistage pipeline deploys the artifact to an Azure staging environment.
1. The multistage pipeline deploys the artifact to an Azure production environment.

The solution reduces labor by automatically provisioning pipelines in Azure Pipelines. Those pipelines provision infrastructure in Azure and automatically deploy artifacts. The solution also reduces the feedback loop from code to customer. As the following screenshot shows, developers can see their changes in production within minutes.

:::image type="content" source="./media/staging-environment-automate-pipelines.png" alt-text="Screenshot of an Azure Pipelines page that shows the progress of a multistage pipeline in a staging environment.":::

### Components

- [Azure DevOps Services](https://azure.microsoft.com/products/devops) is a collection of technologies that you can use for agile planning, continuous integration (CI), continuous delivery (CD), and monitoring of applications.
- [Azure Pipelines](https://azure.microsoft.com/products/devops/pipelines) is a service in Azure DevOps Services. Azure Pipelines provides a way to build, test, package, and release application and infrastructure code.
- [Azure Repos](https://azure.microsoft.com/products/devops/repos) is a service in Azure DevOps Services. Azure Repos supplies version control tools for managing code.
- The [Azure DevOps Services REST API](/rest/api/azure/devops) provides a way for you to create, retrieve, update, or delete access to Azure resources. This solution uses the API to automate the process of setting up pipelines.
- [Logic Apps](https://azure.microsoft.com/products/logic-apps) is a cloud-based platform that you can use to create and run automated workflows to integrate apps, data, services, and systems.
- [App Service](https://azure.microsoft.com/products/app-service) is a fully managed platform for building, deploying, and scaling web apps. In this solution, App Service deploys .NET Angular workloads.
- [Azure Monitor](https://azure.microsoft.com/products/monitor) shows the availability, performance, and usage of your web applications.
- [Application Insights](/azure/azure-monitor/app/app-insights-overview) is a feature of Monitor that provides code-level monitoring of application usage, availability, and performance. In this solution, Application Insights gathers telemetry from a .NET Angular app.

### Alternatives

In the Azure portal, you can use the **Deployment Center** page of your App Service app to manage app deployment. But with this alternative, you first have to provision infrastructure. For more information, see [Deployment Center](/azure/app-service/deploy-continuous-deployment). The solution in this article takes a code-first approach that provisions infrastructure through code. A code-first approach also offers you the flexibility that you need to use any kind of Azure workload.

## Scenario details

The process of setting up pipelines in Azure for continuous deployment can involve numerous tedious steps. Common tasks include setting up build definitions, release definitions, branch policies, control gates, and ARM templates. When engineering teams repeat these steps for every app that they build, the effort can take them days and involve considerable work.

To reduce *toil*, or manual work that's tedious, you can automate the process of building CI/CD pipelines. The solution in this article uses the Azure DevOps Services REST API and service hooks for this purpose. When you use these tools, an event like the first push into a repository can set off a series of steps. Those steps can construct the entire development path for the repository.

You can adjust this solution to meet your needs. For instance, the build steps in pipelines vary with the type of workload that you use. Also, each team has a preferred number of environments within Azure subscriptions that depend on internal systems and business scenarios. These factors affect the number of stages that you need in the pipelines.

When you use this solution, your developers can see their changes in minutes. Also, developers no longer need to repeatedly set up pipelines to create developer, test, and production environments in Azure. Instead, your engineering team can focus on projects that create value for your customers.

This solution offers many benefits. Teams that use the solution:

- Save time and money by eliminating repetitive tasks.
- Can focus on core priorities.
- Reduce operational efforts.
- Can easily replicate pipelines.
- Accelerate their products' time to market.

### Potential use cases

This solution is industry agnostic. Any team that builds software can use this solution. Typical use cases include:

- Microservices design patterns.
- Repeatable workload deployment.
- Platform and product development.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

This solution uses Logic Apps and the Azure DevOps Services REST API. The availability of the solution is compliant with the [SLA guarantees of these Azure services](https://www.microsoft.com/licensing/docs/view/Service-Level-Agreements-SLA-for-Online-Services).

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

- When you define your pipeline in a YAML file, you can't include some features, such as approval gates. Instead, you need to manually configure these features.
- When you configure sensitive parameters in a multistage-pipeline YAML template, use variable groups.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

The core services in this solution include the Azure DevOps Services REST API and Logic Apps.

- Use of the Azure DevOps Services REST API isn't billed separately. Instead, this service is included as part of the Azure DevOps Services platform.
- The logic apps that you invoke with `git commit` can run on any available Logic Apps plan. The base pricing of the logic app depends on the type of plan that you choose. For this solution, we recommend that you use a standard plan. For more information about pricing, see [Logic Apps pricing](https://azure.microsoft.com/pricing/details/logic-apps).

## Deploy this scenario

You can find source code, deployment files, and instructions for testing this scenario on GitHub:

- [Deploy an orchestrator logic app in Azure](https://github.com/mspnp/multi-stage-azure-pipeline-automation)
- [Deploy a .NET Angular workload](https://github.com/mspnp/multi-stage-azure-pipeline-automation-app)

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributor.*

Principal author:

- [Rajkumar (Raj) Balakrishnan](https://www.linkedin.com/in/raj-microsoft) | Digital Cloud Solution Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Build a CI/CD pipeline for chatbots with ARM templates](../apps/devops-cicd-chatbot.yml)
- [CI/CD baseline architecture with Azure Pipelines](../apps/devops-dotnet-baseline.yml)
- [The DevOps journey at Microsoft](https://azure.microsoft.com/solutions/devops/devops-at-microsoft)
- [Create a build pipeline with Azure Pipelines](/training/modules/create-a-build-pipeline)
- [What is Azure Pipelines?](/azure/devops/pipelines/get-started/what-is-azure-pipelines)
- [Use Azure Pipelines](/azure/devops/pipelines/get-started/pipelines-get-started)
- [What is Azure DevOps?](/azure/devops/user-guide/what-is-azure-devops)
- [Azure DevOps Services REST API Reference](/rest/api/azure/devops)
- [What is Azure Logic Apps?](/azure/logic-apps/logic-apps-overview)
- [What is Azure Repos?](/azure/devops/repos/get-started/what-is-repos)

## Related resources

- [Build and deploy apps on AKS using DevOps and GitOps](../../guide/aks/aks-cicd-github-actions-and-gitops.yml)
- [DevTest and DevOps for microservice solutions](../../solution-ideas/articles/dev-test-microservice.yml)
- [DevTest and DevOps for IaaS solutions](../../solution-ideas/articles/dev-test-iaas.yml)
- [DevTest and DevOps for PaaS solutions](../../solution-ideas/articles/dev-test-paas.yml)
- [Gridwich Azure DevOps setup](../../reference-architectures/media-services/set-up-azure-devops.yml)
