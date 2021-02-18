
[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

DevOps and Kubernetes are better together. Implementing secure DevOps together with Kubernetes on Azure, you can achieve the balance between speed and security and deliver code faster at scale. Put guardrails around the development processes using CI/CD with dynamic policy controls and accelerate feedback loop with constant monitoring. Use Azure Pipelines to deliver fast while ensuring enforcement of critical policies with Azure Policy. Azure provides you real-time observability for your build and release pipelines, and the ability to apply compliance audit and reconfigurations easily.

## Architecture

![Architecture diagram](../media/secure-devops-for-kubernetes.png)
*Download an [SVG](../media/secure-devops-for-kubernetes.svg) of this architecture.*

<!-- markdownlint-disable MD033 -->

## Data Flow

1. Developers rapidly iterate, test, and debug different parts of an application together in the same Kubernetes cluster.
1. Code is merged into a GitHub repository, after which automated builds and tests are run by Azure Pipelines.
1. Release pipeline automatically executes pre-defined deployment strategy with each code change.
1. Kubernetes clusters are provisioned using tools like Helm charts that define the desired state of app resources and configurations.
1. Container image is pushed to Azure Container Registry.
1. Cluster operators define policies in Azure Policy to govern deployments to the AKS cluster.
1. Azure Policy audits requests from the pipeline at the AKS control plane level.
1. App telemetry, container health monitoring, and real-time log analytics are obtained using Azure Monitor.
1. Insights used to address issues and fed into next sprint plans.

## Components

* Source code is hosted on [GitHub Enterprise](https://help.github.com/en/github), where developers can collaborate within your organization and the open-source communities. GitHub Enterprise offers advanced security features to identify vulnerabilities in the code you write and in open-source dependencies
* [Azure Pipelines](/azure/devops/pipelines/get-started/pipelines-get-started?view=azure-devops) is a service that provides Continuous Integration and Continuous Delivery jobs, to build and release your application automatically.
* Host your Docker container images on [Azure Container Registry](/azure/container-registry/container-registry-concepts). This service includes container image scanning with the integration with Azure Security Center.
* [Azure Kubernetes Service](/azure/aks/intro-kubernetes) offers a Kubernetes cluster that is fully managed by Azure, to ensure availability and security of your infrastructure.
* [Azure Policy](/azure/governance/policy/overview) lets you create, assign, and manage policies. These policies enforce different rules and effects over your resources, so those resources stay compliant with your corporate standards and service level agreements. It integrates with Azure Kubernetes Service too.
* Using [Azure Monitor](/azure/azure-monitor/overview) lets you get insights on the availability and performance of your application and infrastructure. It also gives you access to signals to monitor your solution's health and spot abnormal activity early.

## Next Steps

- To learn about hosting Microservices on AKS, see [Microservices architecture on Azure Kubernetes Service (AKS)](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/containers/aks-microservices/aks-microservices).
- The see the AKS product roadmap, see [Azure Kubernetes Service Roadmap on GitHub](https://github.com/Azure/AKS/projects/1).

## Related articles

- If you need a refresher in Kubernetes, complete the [Azure Kubernetes Service Workshop](https://docs.microsoft.com/en-us/learn/modules/aks-workshop/) to deploy a multi-container application to Kubernetes on Azure Kubernetes Service (AKS).

- [Build and deploy to Azure Kubernetes Service](/azure/devops/pipelines/ecosystems/kubernetes/aks-template?view=azure-devops)
