---
title: Build a CI/CD Pipeline for AKS Apps by Using Azure Pipelines
description: Learn how to build a CI/CD pipeline for AKS apps by using Azure Pipelines, with integrated testing, staging, and production deployment.
author: francisnazareth
ms.author: fnazaret
ms.date: 09/29/2025
ms.topic: concept-article
ms.subservice: architecture-guide
ms.category:
 - containers
 - devops
 - developer-tools
ms.custom:
 - acom-architecture
 - microservices
 - devops
 - kubernetes
 - e2e-aks
 - arb-containers
ai-usage: ai-assisted
---

# Build a CI/CD pipeline for AKS apps by using Azure Pipelines

> [!IMPORTANT]
> This article describes a version of the [continuous integration and continuous deployment (CI/CD) baseline architecture](/azure/devops/pipelines/architectures/devops-pipelines-baseline-architecture). It focuses specifically on deploying Azure Kubernetes Service (AKS) applications by using Azure Pipelines.

Azure Pipelines orchestrates deployment activities to AKS as part of a repeatable application delivery plan. You can integrate your build and release processes into a pipeline to reduce the risk of human error, accelerate release cycles, and improve overall software quality. This article describes how to use Azure Pipelines to implement CI/CD and push application updates to AKS clusters.

## Architecture

:::image type="complex" source="media/aks-cicd-azure-pipelines-architecture.svg" lightbox="media/aks-cicd-azure-pipelines-architecture.svg" alt-text="Architecture diagram of an AKS CI/CD pipeline that uses Azure Pipelines." border="false":::
    The flow goes from left to right. It starts with step 1, where an engineer pushes code changes to an Azure Repos Git repository and an Azure Pipelines PR pipeline gets triggered. This pipeline includes the following tasks: Restore, build, unit tests, PR review, and code analysis that includes lint, security scan, and other tools. In step 2, an Azure Pipelines CI pipeline gets triggered. This pipeline includes the following tasks: Get secrets, lint, restore, build, unit tests, integration tests, publish build artifacts, and publish container images. In step 3, a container image is published to a nonproduction Azure container registry. In step 4, an Azure Pipelines CD pipeline gets triggered. This pipeline includes the following tasks: Deploy to staging, acceptance tests, promote container image, optional manual intervention, and release. In step 5, the CD pipeline deploys to a staging environment that includes AKS. In step 6, the container image is promoted to the production Azure container registry. In step 7, the CD pipeline is released to a production environment that includes AKS. In step 8, Azure Monitor managed service for Prometheus forwards telemetry to Azure Monitor. Step 9 is represented by a section that includes an operator, Azure Monitor, Azure Monitor managed service for Prometheus, a Log Analytics workspace, Microsoft Security DevOps, key vaults, Azure Managed Grafana, and Defender for Cloud. A dashed line goes from step 1 to Microsoft Security DevOps. Multiple dashed lines go from step 2, step 4, and the line between steps 4 and the staging and production environments back to the engineer.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/azure-devops-ci-cd-aks-architecture.vsdx) of this architecture.*

### Dataflow

The following dataflow corresponds to the previous diagram:

1. A pull request (PR) to either an Azure Repos Git repository or a GitHub repository triggers a PR pipeline.

   This pipeline runs quality checks, including the following operations:
   
   - Building code, which might require pulling dependencies from a dependency management system
   - Using tools to analyze the code, such as static code analysis, linting, and [security scanning](/azure/defender-for-cloud/azure-devops-extension)
   - Performing unit tests
     
   If any checks fail, the pipeline run ends, and the developer must make the required changes. If all checks pass, the pipeline requires a PR review. If the PR review fails, the pipeline ends, and the developer must make the required changes. A successful pipeline run results in a successful PR merge.

1. A merge to Azure Repos Git triggers a CI pipeline. This pipeline runs the same tasks as the PR pipeline and adds integration tests.

   If the integration tests require [secrets](/azure/devops/pipelines/release/azure-key-vault), the pipeline gets them from Azure Key Vault, a resource dedicated to this environment's CI pipeline.

   If any checks fail, the pipeline ends, and the developer must make the required changes.
1. A successful CI pipeline run creates and publishes a container image in a nonproduction Azure container registry. [Defender for Containers](/azure/defender-for-cloud/defender-for-container-registries-introduction) scans the container images when they're pushed to Azure Container Registry and reports the image vulnerabilities to Microsoft Defender for Cloud. Optionally, the container images might be [signed](/azure/container-registry/container-registry-content-trust) to ensure the integrity of the container image.
1. The completion of the CI pipeline [triggers the CD pipeline](/azure/devops/pipelines/process/pipeline-triggers).
1. The CD pipeline deploys a YAML template to the staging AKS environment that includes a [Defender agent](/azure/defender-for-cloud/tutorial-enable-containers-azure). This deployment uses a push model and runs via either kubectl or Helm. The template references the container image from the nonproduction registry.

   The pipeline performs acceptance tests against the staging environment to validate the deployment. If the tests succeed, the pipeline might include a manual validation task to validate the deployment and resume the pipeline. Some workloads deploy automatically. If any checks fail, the pipeline ends, and the developer must make the required changes.
1. When an individual resumes the manual intervention, the CD pipeline promotes the image from the nonproduction Azure container registry to the production registry. [Defender for Containers](/azure/defender-for-cloud/defender-for-containers-introduction) scans the container images when they're pushed to Container Registry and reports the image vulnerabilities to Microsoft Defender for Cloud.
1. The CD pipeline deploys a YAML template to the production AKS environment that includes a Defender agent. The template specifies the container image from the production registry.
1. [Azure Monitor managed service for Prometheus](/azure/azure-monitor/metrics/prometheus-metrics-overview) periodically forwards performance metrics, inventory data, and health state information from container hosts and containers to Azure Monitor.
1. A Log Analytics workspace stores all data. Azure Monitor provides multiple tools to analyze the data collected by other features. Various [Grafana dashboards](/azure/managed-grafana/overview) combine different sets of Kubernetes telemetry. Application Insights collects application-specific monitoring data, such as traces.

   Defender for Containers performs periodic scans of containers that run in AKS and of container images stored in Container Registry. Defender for Containers also provides real-time threat protection for supported containerized environments and generates alerts for suspicious activities. This information helps identify security problems and improve the security of containers.

### Components

- [Azure Pipelines](/azure/devops/pipelines/get-started/what-is-azure-pipelines) is a component of Azure DevOps that automatically builds, tests, and deploys code to its compute target. In this architecture, it creates and tests container images, uploads them to Container Registry, and deploys them in AKS.

- [Azure Monitor managed service for Prometheus](/azure/azure-monitor/metrics/prometheus-metrics-overview) is an Azure feature that provides monitoring for containerized environments. In this architecture, it collects performance metrics, logs, and health data from containers and forwards this observability data to Azure Monitor for analysis and alerting.

- [Key Vault](/azure/key-vault/general/overview) is a cloud service for storing and accessing secrets, such as API keys, passwords, certificates, or cryptographic keys. In this architecture, the pipeline gets secrets required for testing the code from Key Vault.

- [Azure Monitor](/azure/azure-monitor/fundamentals/overview) is a monitoring solution that collects, analyzes, and responds to telemetry from cloud and on-premises environments. In this architecture, it serves as the central observability platform that provides monitoring and alerting for the AKS clusters and CI/CD pipeline operations.
  
- [Container Registry](/azure/container-registry/container-registry-intro) is a managed, private container registry service on Azure. Container Registry stores private container images. In this architecture, the compute platform pulls the application's container image from Container Registry.

- [AKS](/azure/well-architected/service-guides/azure-kubernetes-service) is a managed Kubernetes service where Azure handles critical tasks, like health monitoring and maintenance. In this architecture, it serves as the compute platform for the application.

- [Microsoft Security DevOps Azure DevOps extension](/azure/defender-for-cloud/azure-devops-extension) lets you embed security scanning directly in your CI/CD workflows. In this architecture, Microsoft Security DevOps performs static analysis and provides visibility of security postures across multiple pipelines in AKS development and deployment. Microsoft Security DevOps is part of [Microsoft Defender for Cloud DevOps security](/azure/defender-for-cloud/defender-for-devops-introduction), which provides comprehensive visibility, posture management, and threat protection across multicloud environments.

## Alternatives

Cosider the following alternatives for your implementation.

### Pull-based model (GitOps)

This scenario shows a push-based model to deploy resources in AKS. Push-based deployments work best when you need deterministic updates to your clusters. Pipelines actively initiate deployments, monitor their success, and take direct action if deployments fail. This approach is often an important characteristic of safe deployment practices in workloads. Push-based deployments also suit multiple deployment targets, such as blue-green environments, where you need a highly controlled rollout pattern within a single cluster or across clusters.

Alternatively, pull-based deployments rely on clusters to fetch and apply updates. This pattern decouples deployment logic from the pipeline, which allows individual clusters to reconcile against a desired state stored in a central location, such as a Git repository in GitOps workflows or an artifact registry. Pull-based deployments work best for environments that prioritize consistency, auditability, and self-healing. The source of truth lives externally, often in version-controlled systems, so clusters continuously monitor and apply updates to match this desired state. This approach reduces the risk of drift. If a cluster experiences a failure or becomes unavailable, it can self-reconcile after it comes back online without requiring redeployment from a central pipeline.

The GitOps pull model also removes the need for pipelines to access clusters directly or use associated deployment credentials, which eliminates an attack vector. Clusters only need read-only access to the source repository. For more information, see [GitOps for AKS](/azure/architecture/example-scenario/gitops-aks/gitops-blueprint-aks).

### CI/CD pipeline built with GitHub Actions

You can replace Azure Pipelines with [GitHub Actions for AKS](/azure/aks/kubernetes-action). GitHub Actions is a CI/CD platform that you can use to automate your build, test, and deployment pipeline. Consider using a [starter workflow](/azure/aks/kubernetes-action#next-steps) for AKS and customize it according to your CI/CD requirements.

## Next steps

- For a complete set of services based on Azure Monitor that monitor the health and performance of different layers in Kubernetes infrastructure and applications that depend on it, see [Kubernetes monitoring in Azure Monitor](/azure/azure-monitor/containers/kubernetes-monitoring-overview).
- [CI/CD baseline architecture that uses Azure Pipelines](/azure/devops/pipelines/architectures/devops-pipelines-baseline-architecture)
- [Training: Introduction to Kubernetes on Azure](/training/paths/intro-to-kubernetes-on-azure)

## Related resources

- [Microservices architecture on AKS](../../reference-architectures/containers/aks-microservices/aks-microservices.yml)
- [AKS solution journey](../../reference-architectures/containers/aks-start-here.md)
