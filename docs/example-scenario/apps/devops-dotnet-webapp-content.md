Using proven continuous integration (CI) and continuous deployment (CD) practices to deploy application or infrastructure changes provides various benefits including:

- **Shorter release cycles** - Automated CI/CD processes allow you to deploy faster than manual practices. Many organizations deploy multiple times per day.
- **Better code quality** - Quality gates in CI pipelines, such as linting and unit testing, result in higher quality code.
- **Decreased risk of releasing** - Proper CI/CD practices dramatically decreases the risk of releasing new features. The deployment can be tested prior to release.
- **Increased productivity** - Automated CI/CD frees developers from working on manual integrations and deployments so they can focus on new features.
- **Enable rollbacks** - While proper CI/CD practices lower the number of bugs or regressions that are released, they still occur. CI/CD can enable automated rollbacks to earlier releases.

This article describes a high-level DevOps workflow for deploying application changes to Azure services such as Azure Functions or Azure Web Apps using CI/CD practices with Azure Pipelines.

> [!NOTE]
> Although this article covers CI/CD for application changes, Azure Pipelines can also be used to build CI/CD pipelines for infrastructure as code (IaC) changes.

## Architecture

:::image type="complex" source="./media/azure-devops-ci-cd-architecture.png" alt-text="Architecture diagram of a CI/CD pipeline using Azure Pipelines"::: 
Architecture diagram of an Azure pipeline. The diagram shows the following steps: 1. An engineer pushing code changes to an Azure DevOps Git repository. 2. An Azure DevOps PR pipeline getting triggered. This pipeline shows the following tasks: linting, restore, build, and unit tests. 3. An Azure DevOps CI pipeline getting triggered. This pipeline shows the following tasks: get secrets, linting, restore, build, unit tests, integration tests and publishing build artifacts. 3. An Azure DevOps CD pipeline getting triggered. This pipeline shows the following tasks: download artifacts, deploy to staging, tests, manual intervention, and release. 4. Shows the CD pipeline deploying to Azure Web Apps or Azure Function Apps running in a staging environment. 5. Shows the CD pipeline releasing to Azure Web Apps or Azure Function Apps running in a production environment. 6. Shows an operator monitoring the pipeline, taking advantage of Azure Monitor, Azure Application Insights and Azure Analytics Workspace.
:::image-end:::

### Components

The architecture uses these components.

##### Azure Repos Git repository

An Azure Repos Git repository serves as the code repository that provides version control and a platform for collaborative projects.

> [!NOTE]
> For product documentation, see [Azure Repos](/azure/devops/repos/?view=azure-devops)

##### Azure Pipelines

Azure Pipelines can be used to build, test, package and release both application and infrastructure code. This example has 3 distinct pipelines with the following responsibilities:

- **Pull Request (PR)** - PR pipelines validates code before allowing a PR to merge through linting, building and unit testing.
- **Continuous Integration (CI)** - CI pipelines run after code is merged. They perform the same validation as PR pipelines, but add integration testing and publish build artifacts if everything succeeds.
- **Continuous Deployment (CD)** - CD pipelines deploy build artifacts, run acceptance tests, and release to production.

> [!NOTE]
> For product documentation, see [Azure Pipelines](https://azure.microsoft.com/services/devops): runs automated builds, tests, and deployments.

##### Azure Web Apps / Azure Function Apps

Azure Web Apps and Azure Function Apps are two options listed in this example for deploying and managing web apps written in various languages like C#, Java, JavaScript, or PHP. There are various other deployment options. These 2 were chosen for this example for simplicity. Both Azure Web Apps and Azure Function Apps are PaaS services that support deployment slots like staging and production. An application can be deployed to a staging slot and released to the production slot.

> [!NOTE]
> For product documentation, see [Web Apps](https://azure.microsoft.com/services/app-service/web/) or [Introduction to Azure Functions](/azure/azure-functions/functions-overview).

##### Azure Key Vault

Azure Key Vault is used to manage secure data for your solution, including secrets, encryption keys, and certificates. In this architecture, it's used to store application secrets. These secrets are accessed through the pipeline. Secrets can be accessed by Azure Pipelines with an [Azure Key Vault task](/azure/devops/pipelines/tasks/deploy/azure-key-vault?view=azure-devops) or by [linking secrets from an Azure key vault](/azure/devops/pipelines/library/variable-groups?view=azure-devops&tabs=yaml#link-secrets-from-an-azure-key-vault).

> [!NOTE]
> For product documentation, see [Key Vault](https://azure.microsoft.com/services/key-vault/).

##### Azure Monitor

An observability resource that collects and stores metrics and logs, application telemetry, and platform metrics for the Azure services. Use this data to monitor the application, set up alerts, dashboards, and perform root cause analysis of failures.

> [!NOTE]
> For product documentation, see [Azure Monitor](https://azure.microsoft.com/services/monitor).

### Dataflow

The data flows through the scenario as follows:

1. A PR to Azure Repos Git triggers a PR Pipeline. This pipeline will run fast quality checks such as linting, building and unit testing the code. If any of the checks fail, the PR won't merge. The result of a successful run of this pipeline is a successful merge of the PR.
1. A merge to Azure Repos Git triggers a CI Pipeline. This pipeline runs the same tasks as the PR pipeline with some important additions. The CI pipeline will run integration tests. These tests will require secrets, so this pipeline will get those secrets from Azure Key Vault. The result of a successful run of this pipeline is the creation and publishing of build artifacts.
1. The completion of the CI pipeline [triggers the CD pipeline](/azure/devops/pipelines/process/pipeline-triggers?view=azure-devops).
1. The CD pipeline downloads the build artifacts created in the CI pipeline and deploys the solution to a staging environment. The pipeline then runs acceptance tests against the staging environment to validate the deployment. If the tests succeed, a [manual validation task](/azure/devops/pipelines/tasks/utility/manual-validation?view=azure-devops&tabs=yaml) is run, requiring a person to validate the deployment and resume the pipeline.
1. If the manual intervention is resumed, the pipeline will release the solution to production.
1. Azure Monitor collects observability data such as, logs and metrics so that an operator can analyze health, performance, and usage data. Application Insights collects all application-specific monitoring data, such as traces. Azure Log Analytics is used to store all that data.

### Alternatives

While this article focuses on Azure DevOps, you could consider these alternatives:

- [Azure DevOps Server](https://azure.microsoft.com/services/devops/server/) (previously known as Team Foundation Server) could be used as an on-premises substitute.

- [Jenkins](/azure/jenkins) is an open source tool used to automate builds and deployments.

- [GitHub Actions](https://github.com/features/actions) allow you to automate your CI/CD workflows directly from GitHub.

- [GitHub Repositories](https://docs.github.com/repositories) can be substituted as the code repository. Azure Pipelines integrates seamlessly with GitHub repositories.

Consider these alternatives to hosting in Azure Web Apps or Azure Function Apps:

- [Azure Virtual Machines](/azure/app-service/choose-web-site-cloud-service-vm) handles workloads that require a high degree of control, or depend on OS components and services that aren't possible with Web Apps (for example, the Windows GAC, or COM).

- [Azure Kubernetes Service (AKS)](/azure/aks) is a managed Kubernetes cluster in Azure. Kubernetes is an open source container orchestration platform.

- [Azure Container Apps](/azure/container-apps/overview) allows you to run containerized applications on a serverless platform.

This [decision tree for Azure compute services](../../guide/technology-choices/compute-decision-tree.yml) can help when choosing the right path to take for a migration.

## Scenario details

Consider Azure DevOps and CI/CD processes for:

- Accelerating application development and development lifecycles.
- Building quality and consistency into an automated build and release process.
- Increasing application stability and uptime.

## Security and Operational Excellence considerations

- Consider using one of the [tokenization tasks](https://marketplace.visualstudio.com/search?term=token&target=VSTS&category=All%20categories&sortBy=Relevance) available in the VSTS marketplace.

- Use [release variables](/azure/devops/pipelines/release/variables) in your release definitions to drive configuration changes of your environments. Release variables can be scoped to an entire release or a given environment. When using variables for secret information, ensure that you select the padlock icon.

- Consider using [Self-hosted agents](/azure/devops/pipelines/agents/agents?view=azure-devops&tabs=browser#install) if you're deploying to resources running in a secured virtual network.

- Consider using [Application Insights](/azure/application-insights/app-insights-overview) and other monitoring tools as early as possible in your release pipeline. Many organizations only begin monitoring in their production environment. By monitoring your other environments, you can identify bugs earlier in the development process and avoid issues in your production environment.

- Consider using [YAML pipelines](/azure/devops/pipelines/get-started/yaml-pipeline-editor?view=azure-devops) instead of the Classic interface. YAML pipelines can be treated like other code. YAML pipelines can be checked in to source control and versioned, for example.

- Consider using [YAML Templates](/azure/devops/pipelines/process/templates?view=azure-devops) to promote reuse and simplify pipelines. For example, PR and CI pipelines are similar. A single parameterized template could be used for both pipelines.

## Cost optimization

Azure DevOps costs depend on the number of users in your organization that require access, along with other factors like the number of concurrent build/releases required and number of test users. For more information, see [Azure DevOps pricing](https://azure.microsoft.com/pricing/details/visual-studio-team-services).

This [pricing calculator](https://azure.com/e/498aa024454445a8a352e75724f900b1) provides an estimate for running Azure DevOps with 20 users.

Azure DevOps is billed on a per-user per-month basis. There might be more charges depending on concurrent pipelines needed, in addition to any additional test users or user basic licenses.

## Next steps

Review the following resources to learn more about CI/CD and Azure DevOps:

- [What is DevOps?](/devops/what-is-devops)
- [DevOps at Microsoft - How we work with Azure DevOps](https://azure.microsoft.com/solutions/devops/devops-at-microsoft)
- [Step-by-step Tutorials: DevOps with Azure DevOps](https://www.azuredevopslabs.com/labs/vstsextend/azuredevopsprojectdotnet)
- [Create a CI/CD pipeline for .NET with Azure DevOps Projects](/azure/devops-project/azure-devops-project-aspnet-core)

## Related resources

- [DevOps Checklist](../../checklist/dev-ops.md)
- [CI/CD for Azure VMs](https://docs.microsoft.com/azure/architecture/solution-ideas/articles/cicd-for-azure-vms)
- [CI/CD for Containers](https://docs.microsoft.com/azure/architecture/solution-ideas/articles/cicd-for-containers)
- [Build a CI/CD pipeline for microservices on Kubernetes](https://docs.microsoft.com/azure/architecture/microservices/ci-cd-kubernetes)
