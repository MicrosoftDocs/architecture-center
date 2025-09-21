> [!IMPORTANT]
> Microservices with AKS and Azure DevOps is a variant of [Design a CI/CD pipeline using Azure DevOps](/azure/devops/pipelines/architectures/devops-pipelines-baseline-architecture). This article focuses on the AKS-specific facets of deploying AKS applications with Azure Pipelines.

## Potential use cases

Use Azure Pipelines to deploy AKS applications.

## Architecture

:::image type="complex" source="media/aks-cicd-azure-pipelines-architecture.svg" lightbox="media/aks-cicd-azure-pipelines-architecture.svg" alt-text="Architecture diagram of an AKS CI/CD pipeline using Azure Pipelines." border="false":::
    Architecture diagram of an Azure pipeline. The diagram shows the following steps: 1. An engineer pushing code changes to an Azure DevOps Git repository. 2. An Azure DevOps PR pipeline is getting triggered. This pipeline shows the following tasks: linting, restoring, building, and unit tests. 3. An Azure DevOps CI pipeline is getting triggered. This pipeline shows the following tasks: get secrets, linting, restore, build, unit tests, integration tests, publishing build artifacts and publishing container images. 3. A container image being published to a non-production Azure Container Registry. 4. An Azure DevOps CD pipeline is getting triggered. This pipeline shows the following tasks: deploy to staging, acceptance tests, promote container image, manual intervention, and release. 5. Shows the CD pipeline deploying to a staging environment. 6. Shows the container image being promoted to the production Azure Container Registry. 7 Shows the CD pipeline released to a production environment. 8. Shows Container Insights forwarding telemetry to Azure Monitor. 9. Shows an operator monitoring the pipeline, taking advantage of Azure Monitor, Azure Application Insights and Azure Analytics Workspace.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/azure-devops-ci-cd-aks-architecture.vsdx) of this architecture.*

### Dataflow

1. A pull request (PR) to Azure Repos Git or GitHub repository triggers a PR pipeline. This pipeline runs fast quality checks. The checks include:
   - Building the code, which may require pulling dependencies from a dependency management system.
   - The use of tools to analyze the code, such as static code analysis, linting, and [security scanning](/azure/defender-for-cloud/episode-fifty-nine).
   - Unit tests
     
   If any of the checks fail, the pipeline run ends, and the developer will have to make the required changes. If all checks pass, the pipeline should require a PR review. If the PR review fails, the pipeline ends, and the developer will have to make the required changes. If all the checks and PR reviews pass, the PR will successfully merge.

2. A merge to Azure Repos Git triggers a CI pipeline. This pipeline runs the same tasks as the PR pipeline with some important additions. The CI pipeline runs integration tests. If the integration tests require secrets, the pipeline gets those [secrets from Azure Key Vault](/azure/devops/pipelines/release/azure-key-vault). If any of the checks fail, the pipeline ends and the developer will have to make the required changes. 
3. The result of a successful run of this pipeline is the creation and publishing of a container image in a non-production Azure Container Registry.
4. The completion of the CI pipeline [triggers the CD pipeline](/azure/devops/pipelines/process/pipeline-triggers).
5. The CD pipeline deploys a YAML template to the staging AKS environment. The template specifies the container image from the non-production environment. The pipeline then performs acceptance tests against the staging environment to validate the deployment. A manual validation task is run if the tests succeed, requiring a person to validate the deployment and resume the pipeline. The manual validation step is optional. Some organizations will automatically deploy. If any of the checks fail, the pipeline ends and the developer will have to make the required changes.
6. If the manual intervention is resumed, the CD pipeline promotes the image from the non-production Azure Container Registry to the production registry.
7. The CD pipeline deploys a YAML template to the production AKS environment. The template specifies the container image from the production environment.
8. Container Insights periodically forwards performance metrics, inventory data, and health state information from container hosts and containers to Azure Monitor.

   Azure Monitor collects observability data such as logs and metrics so that an operator can analyze health, performance, and usage data. Application Insights collects all application-specific monitoring data, such as traces. Azure Log Analytics is used to store all that data.
9. Both container images in Azure Container Registry and running containers in Azure Kubernetes Service are scanned by [Microsoft Defender for Containers](/azure/defender-for-cloud/defender-for-containers-introduction). 

### Components

- [Container Insights](/azure/azure-monitor/containers/container-insights-overview) collects logs and metrics and logs and forwards them to Azure Monitor.
- [Azure Container Registry](/azure/container-registry/container-registry-intro) is a managed, private container registry service on Azure. Use Container Registry to store private container images. In this architecture, this is where the compute platform pulls the application's container image from.
- [Azure Kubernetes Service](/azure/well-architected/service-guides/azure-kubernetes-service) is a managed Kubernetes service where Azure handles critical tasks, like health monitoring and maintenance. In this architecture, this is the compute platform for the application.
- [Defender for DevOps](/azure/defender-for-cloud/azure-devops-extension) performs static analysis and helps you gain visibility of security postures across multiple pipelines in AKS development and deployment.
- [Defender for Containers](/azure/defender-for-cloud/defender-for-containers-introduction) performs vulnerability assessment of containers published to Azure Container Registry and running containers in Azure Kubernetes Service. 

## Next steps

- To learn about the AKS product roadmap, see [Azure Kubernetes Service (AKS) Roadmap on GitHub](https://github.com/Azure/AKS/projects/1).
- If you need a refresher in Kubernetes, complete the [Introduction to Kubernetes on Azure learning path](/training/paths/intro-to-kubernetes-on-azure).

## Related resources

- To learn about hosting Microservices on AKS, see [Microservices architecture on Azure Kubernetes Service (AKS)](../../reference-architectures/containers/aks-microservices/aks-microservices.yml).
- Follow the [Azure Kubernetes Service solution journey](../../reference-architectures/containers/aks-start-here.md).
