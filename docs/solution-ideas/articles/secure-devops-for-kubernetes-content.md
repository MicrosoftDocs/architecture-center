[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

DevOps and Kubernetes are better together. By implementing secure DevOps together with Kubernetes on Azure, you can achieve the balance between speed and security and deliver code faster, at scale.

## Potential use cases

Put guardrails around the development processes, by using CI/CD with dynamic policy controls, and then accelerate your feedback loop with constant monitoring. Use Azure Pipelines to deliver fast, while ensuring the enforcement of critical policies, with Azure Policy. Azure provides you real-time observability for your build and release pipelines, and the ability to apply a compliance audit and reconfigurations easily.

## Architecture

:::image type="content" border="false" source="../media/secure-devops-for-kubernetes.png" alt-text="Architecture diagram shows Inner loop to source code through C I / C D pipelines to Helm chart and Azure Container to A K S production cluster." lightbox="../media/secure-devops-for-kubernetes.png":::

*Download a [Visio file](https://arch-center.azureedge.net/secure-devops-for-kubernetes.vsdx) of this architecture.*

### Dataflow

1. Developers rapidly iterate, test, and debug different parts of an application together, in the same Kubernetes cluster.
1. Code is merged into a GitHub repository, after which automated builds and tests are run by Azure Pipelines.
1. Release pipeline automatically executes a pre-defined deployment strategy, with each code change.
1. Kubernetes clusters are provisioned, by using tools like Helm charts that define the desired state of app resources and configurations.
1. Container image is pushed to Azure Container Registry.
1. Cluster operators define policies in Azure Policy, to govern deployments to the AKS cluster.
1. Azure Policy audits requests from the pipeline, at the AKS control-plane level.
1. App telemetry, container health monitoring, and real-time log analytics are obtained using Azure Monitor.
1. Insights are used to address issues and are fed into next sprint plans.

### Components

- [GitHub Enterprise](https://docs.github.com/) hosts the source code, where developers can collaborate within your organization and the open-source communities. GitHub Enterprise offers advanced security features to identify vulnerabilities in the code you write and in open-source dependencies
- [Azure Pipelines](https://azure.microsoft.com/services/devops/pipelines) is a service that provides Continuous Integration and Continuous Delivery jobs, to build and release your application automatically.
- [Azure Container Registry](https://azure.microsoft.com/services/container-registry) hosts your Docker container images. This service includes container image scanning with the integration with Microsoft Defender for Cloud.
- [Azure Kubernetes Service](https://azure.microsoft.com/services/kubernetes-service) offers a Kubernetes cluster that is fully managed by Azure, to ensure availability and security of your infrastructure.
- [Azure Policy](https://azure.microsoft.com/services/azure-policy) lets you create, assign, and manage policies. These policies enforce different rules and effects over your resources, so those resources stay compliant with your corporate standards and service level agreements. It integrates with Azure Kubernetes Service too.
- [Azure Monitor](https://azure.microsoft.com/services/monitor) lets you get insights on the availability and performance of your application and infrastructure. It also gives you access to signals to monitor your solution's health and spot abnormal activity early.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

 * [Uthappa Kattera Chengappa](https://www.linkedin.com/in/uthappa) | Principal Cloud Solution Architect

## Next steps

- To learn about hosting Microservices on AKS, see [Microservices architecture on Azure Kubernetes Service (AKS)](../../reference-architectures/containers/aks-microservices/aks-microservices.yml).
- To see the AKS product roadmap, see [Azure Kubernetes Service Roadmap on GitHub](https://github.com/Azure/AKS/projects/1).

## Related resources

- If you need a refresher in Kubernetes, complete the [Introduction to Kubernetes on Azure learning path](/training/paths/intro-to-kubernetes-on-azure).
- See [Build and deploy to Azure Kubernetes Service](/azure/devops/pipelines/ecosystems/kubernetes/aks-template).

See the related architectures:

- [Azure Kubernetes Service solution journey](../../reference-architectures/containers/aks-start-here.md)
- [Building a telehealth system on Azure](../../example-scenario/apps/telehealth-system.yml)
- [CI/CD for AKS apps with Azure Pipelines](/azure/architecture/guide/aks/aks-cicd-azure-pipelines)
