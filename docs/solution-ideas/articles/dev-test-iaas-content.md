> [!IMPORTANT]
> CI/CD with DevTest Labs is a variant of [Design a CI/CD pipeline using Azure DevOps](../../example-scenario/apps/devops-dotnet-baseline.yml). This article focuses on the specifics of deploying to a DevTest Labs staging environments.

DevTest Labs allow you to provision Windows and Linux environments by using reusable templates and artifacts. These environments can be useful for developers, but can also be used in CI/CD pipelines for provisioning staging environments. See [Azure DevTest Labs scenarios](/azure/devtest-labs/devtest-lab-guidance-get-started) to see if DevTest labs is a good fit for your scenario.

This article describes a high-level DevOps workflow for deploying application changes using continuous integration (CI) and continuous deployment (CD) practices using Azure Pipelines. A DevTest Labs environment is used for the staging environment.

## Architecture

:::image type="complex" source="../media/azure-pipelines-devtest-variant-architecture.svg" lightbox="../media/azure-pipelines-devtest-variant-architecture.svg" alt-text="Architecture diagram of a CI/CD pipeline using Azure Pipelines that uses Azure DevTest Labs for a staging environment." border="false"::: 
Architecture diagram of an Azure pipeline deploying to Azure Virtual Machines. The diagram shows the following steps: 1. A DevTest Labs staging environment is pre-created for the CI/CD pipeline. 2. An engineer pushing code changes to an Azure DevOps Git repository. 3. An Azure DevOps PR pipeline getting triggered. This pipeline shows the following tasks: linting, restore, build, and unit tests. 4. An Azure DevOps CI pipeline getting triggered. This pipeline shows the following tasks: get secrets, linting, restore, build, unit tests, integration tests and publishing artifacts. 4. An Azure DevOps CD pipeline getting triggered. This pipeline shows the following tasks: download artifacts, deploy to staging, tests, manual intervention, and release. 5. Shows the CD pipeline deploying to an Azure DevTest Labs staging environment. 6. Shows the CD pipeline releasing to a production environment. 7. Shows an operator monitoring the pipeline, taking advantage of Azure Monitor, Azure Application Insights and Azure Analytics Workspace.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/azure-pipelines-iaas-variant-architecture.vsdx) of this architecture.*

### Dataflow

This section assumes you have read [Azure Pipelines baseline architecture](../../example-scenario/apps/devops-dotnet-baseline.yml#dataflow) and only focuses on the specifics of deploying a workload to Azure DevTest Labs for staging.

1. **PR pipeline** - *Same as the baseline*

1. **CI pipeline** - *Same as the baseline*

1. **CD pipeline trigger** - *Same as the baseline*

1. **CD create DevTest Labs staging environment** - This step creates the DevTest Labs environment which acts as the staging environment. The step includes:

    - Create Azure DevTest Labs environment in a staging subscription.
    - Deploy an ARM template to the DevTest Labs environment. Virtual Machine images can be stored in a shared image gallery.
    - Perform any post deployment steps to properly configure the staging environment.

1. **CD release to staging** - Same as the baseline with one exception. The staging environment is a DevTest Labs environment.

1. **CD release to production** - *Same as the baseline*

1. **Monitoring** - *same as the baseline*

### Components

This section assumes you have read [Azure Pipelines baseline architecture components section](../../example-scenario/apps/devops-dotnet-baseline.yml#components) and only focuses on the specifics of deploying a workload to Azure DevTest Labs for staging.

- [Azure DevTest Labs](/azure/devtest-labs/devtest-lab-overview) is a service for creating, using, and managing environments used for development, testing and deployment purposes. The service allows you to easily deploy pre-configured environments in a cost-effictive manner.

### Alternatives

- An alternative to creating the DevTest Labs staging environment as part of the CD process, you can pre-create the environment outside of the pipeline. This will have the positive benefit of speeding up the pipeline. This alternative will stop the ability to tear down the environment after the pipeline is complete, increasing the cost.

- In situations where VM Image Builder and a Shared Image Gallery don't work, you can set up an [image factory](/azure/devtest-labs/image-factory-create) to build VM images from the CI/CD pipeline and distribute them automatically to any Azure DevTest Labs registered to those images. For more information, see [Run an image factory from Azure DevOps](/azure/devtest-labs/image-factory-set-up-devops-lab).

- Additional environments, beyond staging could be created and deployed to as part of the CD pipeline. These environments could support activities like performance testing and user acceptance testing.

## Considerations

This section assumes you have read the [considerations section in Azure Pipelines baseline architecture](../../example-scenario/apps/devops-dotnet-baseline.yml#considerations) and only focuses on the specifics of deploying a workload to Azure DevTest Labs for staging.

### Cost Optimization

- Consider using [Azure DevTest Labs policies and procedures to control costs](/azure/devtest-labs/devtest-lab-overview#lab-policies-and-procedures-to-control-costs)

### Operational Excellence 

- Consider implementing environments beyond just staging and production to enable things like rollbacks, manual acceptance testing, and performance testing. The act of using staging as the rollback environment keeps you from being able to use that environment for other purposes.

## Next steps

- [Create a lab in Azure DevTest Labs](/azure/lab-services/tutorial-create-custom-lab)
- [Integrate DevTest Labs into Azure Pipelines](/azure/devtest-labs/devtest-lab-integrate-ci-cd)

## Related resources

- [CI/CD baseline architecture with Azure Pipelines](../../example-scenario/apps/devops-dotnet-baseline.yml)
- [CI/CD for IaaS applications](./cicd-for-azure-vms.yml)

