> [!IMPORTANT]
> CI/CD for IaaS applications is a variant of [Design a CI/CD pipeline using Azure DevOps](../../example-scenario/apps/devops-dotnet-baseline.yml). This article focuses on the specifics of deploying web applications to Azure Virtual Machines.

Azure Virtual Machines is an option for hosting custom applications when you want flexible and granular management of your compute. Virtual machines (VMs) should be subject to the same level of engineering rigor as Platform-as-a-Service (PaaS) offerings throughout the development lifecycle. For example, implementing automated build and release pipelines to push changes to the VMs.

This article describes a high-level DevOps workflow for deploying application changes to VMs using continuous integration (CI) and continuous deployment (CD) practices using Azure Pipelines.

## Architecture

:::image type="complex" source="../media/azure-pipelines-iaas-variant-architecture.svg" lightbox="../media/azure-pipelines-iaas-variant-architecture.svg" alt-text="Architecture diagram of a CI/CD pipeline using Azure Pipelines." border="false"::: 
Architecture diagram of an Azure pipeline deploying to Azure Virtual Machines. The diagram shows the following steps: 1. An engineer pushing code changes to an Azure DevOps Git repository. 2. An Azure DevOps PR pipeline getting triggered. This pipeline shows the following tasks: linting, restore, build, and unit tests. 3. An Azure DevOps CI pipeline getting triggered. This pipeline shows the following tasks: get secrets, linting, restore, build, unit tests, integration tests and publishing a Web Deploy package as an artifact. 3. An Azure DevOps CD pipeline getting triggered. This pipeline shows the following tasks: download artifacts, deploy to staging, tests, manual intervention, and release. 4. Shows the CD pipeline deploying to a Virtual Machine of Virtual Machine Scale Set. 5. Shows the CD pipeline releasing to a production environment by deploying to a production environment. 6. Shows an operator monitoring the pipeline, taking advantage of Azure Monitor, Azure Application Insights and Azure Analytics Workspace.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/azure-pipelines-iaas-variant-architecture.vsdx) of this architecture.*

### Dataflow

This section assumes you have read [Azure Pipelines baseline architecture](../../example-scenario/apps/devops-dotnet-baseline.yml#dataflow) and only focuses on the specifics of deploying a workload to Azure Virtual Machines.

1. **PR pipeline** - *Same as the baseline*

1. **CI pipeline** - Same as the baseline, except the build artifacts created for deploying a Web App to IaaS is a Web Deploy package

1. **CD pipeline trigger** - *Same as the baseline*

1. **CD release to staging** - Same as the baseline with 2 exceptions: 1) the build artifact that is downloaded is the Web Deploy Package and 2) the package is deployed to a staging Azure Virtual Machine.

1. **CD release to production** - Same as the baseline with 2 exceptions:

    a. The release to production is done by updating Azure Traffic Manager to swap staging and production. This strategy can be accomplished by having a Traffic Manager profile with two endpoints, where production is enabled and staging is disabled. To swap staging and production, disable production and enable staging.  
    b. A rollback can be accomplished by updating Azure Traffic Manager to swap production and staging back.

1. **Monitoring** - *same as the baseline*

### Components

This section assumes you have read [Azure Pipelines baseline architecture components section](../../example-scenario/apps/devops-dotnet-baseline.yml#components) and only focuses on the specifics of deploying a workload to Azure Virtual Machines.

- [Azure Virtual Machines](https://azure.microsoft.com/products/virtual-machines) provide on-demand, high-scale, secure, virtualized infrastructure using Windows or Linux servers. Virtual Machines are used in this architecture to host workloads.

- [Virtual Machine Scale Sets](https://azure.microsoft.com/products/virtual-machine-scale-sets) let you create and manage a group of identical load-balanced VMs. The number of VM instances can automatically increase or decrease in response to demand or a defined schedule. Scale sets can also be used to host workloads.

- [Azure Traffic Manager](https://azure.microsoft.com/products/traffic-manager) is a DNS-based traffic load balancer that you can use to distribute traffic to configured endpoints. In this architecture, Traffic Manager is the single entrypoint for clients and is configured with multiple endpoints, representing the production Virtual Machine and the staging Virtual Machine. The production Virtual Machine endpoint is enabled and staging is disabled.

### Alternatives

This article focuses on the use of Azure Traffic Manager as the load balancer. Azure offers various [Load balancing options](/azure/architecture/guide/technology-choices/load-balancing-overview) that you could consider.

## Considerations

This section assumes you have read the [considerations section in Azure Pipelines baseline architecture](../../example-scenario/apps/devops-dotnet-baseline.yml#considerations) and only focuses on the considerations specifics to deploying a workload to Azure Virtual Machines.

### Operational Excellence

- Because Traffic Manager is DNS-based, client caching of IP addresses introduces latency. Even though you might enable one endpoint and disable another in Traffic Manager, clients will continue to use their cached IP address until the DNS Time-to-live (TTL) expires. Consider [load balancing options](/azure/architecture/guide/technology-choices/load-balancing-overview) that act at layer 4 or layer 7.

- Consider implementing environments beyond just staging and production to enable things like rollbacks, manual acceptance testing, and performance testing. The act of using staging as the rollback environment keeps you from being able to use that environment for other purposes.

## Next steps

- [Integrate DevTest Labs into Azure Pipelines](/azure/devtest-labs/devtest-lab-integrate-ci-cd)
- [Create and deploy VM Applications](/azure/virtual-machines/vm-applications-how-to?tabs=portal)

## Related resources

- [CI/CD baseline architecture with Azure Pipelines](../../example-scenario/apps/devops-dotnet-baseline.yml)
- [Run a Linux VM on Azure](/azure/architecture/reference-architectures/n-tier/linux-vm)
