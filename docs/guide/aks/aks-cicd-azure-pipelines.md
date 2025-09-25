---
title: Build a CI/CD Pipeline for AKS Apps by Using Azure Pipelines
description: Learn how to build a CI/CD pipeline for AKS apps by using Azure Pipelines, with integrated testing, staging, and production deployment.
author: francisnazareth
ms.author: fnazaret
ms.date: 09/15/2025
ms.topic: conceptual
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

Azure Pipelines orchestrates deployment activities to AKS as part of your repeatable application delivery plan. You can integrate your build and release processes into a pipeline to reduce the risk of human error, accelerate release cycles, and improve overall software quality. This article describes how to use Azure Pipelines to implement CI/CD, to push application updates to your AKS clusters.

## Architecture

:::image type="complex" source="media/aks-cicd-azure-pipelines-architecture.svg" lightbox="media/aks-cicd-azure-pipelines-architecture.svg" alt-text="Architecture diagram of an AKS CI/CD pipeline that uses Azure Pipelines." border="false":::
    The flow goes from left to right. It starts with step 1, where an engineer pushes code changes to an Azure Repos Git repository. In step 2, An Azure Pipelines PR pipeline gets triggered. This pipeline includes the following tasks: Restore, build, unit tests, PR review, and code analysis, including lint, security scan, and other tools. In step 3, an Azure Pipelines CI pipeline gets triggered. This pipeline includes the following tasks: Get secrets, lint, restore, build, unit tests, integration tests, publish build artifacts, and publish container images. In step 3, a container image is published to a nonproduction Azure container registry. In step 4, an Azure Pipelines CD pipeline gets triggered. This pipeline includes the following tasks: Deploy to staging, acceptance tests, promote container image, manual intervention, and release. In step 5, the CD pipeline deploys to a staging environment that includes AKS and a Defender agent. In step 6, the container image is promoted to the production Azure container registry. In step 7, the CD pipeline is released to a production environment that includes AKS and a Defender agent. In step 8, Container Insights forwards telemetry to Azure Monitor. A section that includes an operator, Azure Monitor, Application Insights, a Log Analytics workspace, and Defender for Containers represents step 9. Dashed lines go from the line between steps 2 and 3, the line between steps 2 and 4, and the line between steps 4 and the staging and production environments back to the engineer.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/azure-devops-ci-cd-aks-architecture.vsdx) of this architecture.*

### Dataflow

1. A pull request (PR) to either an Azure Repos Git repository or a GitHub repository triggers a PR pipeline.

   This pipeline runs quality checks, including the following operations:
   
   - Building code, which might require pulling dependencies from a dependency management system
   - Using tools to analyze the code, such as static code analysis, linting, and [security scanning](/azure/defender-for-cloud/cli-cicd-integration)
   - Performing unit tests
     
   If any checks fail, the pipeline run ends, and the developer must make the required changes. If all checks pass, the pipeline requires a PR review. If the PR review fails, the pipeline ends, and the developer must make the required changes. A successful pipeline run results in a successful PR merge.

1. A merge to Azure Repos Git triggers a CI pipeline. This pipeline runs the same tasks as the PR pipeline and adds integration tests.

   If the integration tests require [secrets](/azure/devops/pipelines/release/azure-key-vault), the pipeline gets them from Azure Key Vault, a resource dedicated to this environment's CI pipeline.

   If any checks fail, the pipeline ends, and the developer must make the required changes.
1. A successful CI pipeline run creates and publishes a container image in a nonproduction Azure container registry.
1. The completion of the CI pipeline [triggers the CD pipeline](/azure/devops/pipelines/process/pipeline-triggers).
1. The CD pipeline deploys a YAML template to the staging AKS environment. This is a "push" deployment of the YAML, and can be done with `kubectl` or `helm`.  The template references the container image from the nonproduction registry.

   The pipeline then performs acceptance tests against the staging environment to validate the deployment. If the tests succeed, the pipeline can include a manual validation task to validate the deployment and resume the pipeline. Some workloads might deploy automatically. If any checks fail, the pipeline ends, and the developer must make the required changes.
1. When an individual resumes the manual intervention, the CD pipeline promotes the image from the nonproduction Azure container registry to the production registry.
1. The CD pipeline deploys a YAML template to the production AKS environment. The template specifies the container image from the production registry.
1. Container Insights periodically forwards performance metrics, inventory data, and health state information from container hosts and containers to Azure Monitor.
1. Azure Monitor collects observability data, such as logs and metrics, so that an operator can analyze health, performance, and usage data. Application Insights collects application-specific monitoring data, such as traces. A Log Analytics workspace stores all the data.

    [Microsoft Defender for Containers](/azure/defender-for-cloud/defender-for-containers-introduction) continuously monitors the AKS clusters, container images, and workloads for security threats, vulnerabilities, and compliance problems. It integrates with both the container registry scanning during the CI process and runtime protection in the AKS environments.

    The Defender agent, deployed as a DaemonSet on AKS cluster nodes, collects security telemetry from the runtime environment and forwards threat detection data to Defender for Containers for analysis and alerting.

### Components

- [Azure Pipelines](/azure/devops/pipelines/get-started/what-is-azure-pipelines) is a component of Azure DevOps that automatically builds, tests, and deploys code to its compute target. In this architecture, it creates and tests container images, uploads them to Container Registry, and deploys them in AKS.

- [Container Insights](/azure/azure-monitor/containers/container-insights-overview) is an Azure Monitor feature that provides monitoring for containerized environments. In this architecture, it continuously monitors the deployed AKS workloads in both staging and production environments. It collects performance metrics, logs, and health data from containers and forwards this observability data to Azure Monitor for analysis and alerting.

- [Key Vault](/azure/key-vault/general/overview) is a cloud service for securely storing and accessing secrets, such as API keys, passwords, certificates, or cryptographic keys. In this architecture, the pipeline gets secrets required for testing the code from Key Vault.

- [Azure Monitor](/azure/azure-monitor/fundamentals/overview) is a monitoring solution that collects, analyzes, and responds to telemetry from cloud and on-premises environments. In this architecture, it serves as the central observability platform that receives logs and metrics from Container Insights to provide monitoring and alerting for the AKS clusters and CI/CD pipeline operations.

- [Azure Container Registry](/azure/container-registry/container-registry-intro) is a managed, private container registry service on Azure. Container Registry stores private container images. In this architecture, the compute platform pulls the application's container image from Container Registry.

- [AKS](/azure/well-architected/service-guides/azure-kubernetes-service) is a managed Kubernetes service where Azure handles critical tasks, like health monitoring and maintenance. In this architecture, it serves as the compute platform for the application.

- [Microsoft Defender for DevOps](/azure/defender-for-cloud/azure-devops-extension) is a security solution that integrates into development and deployment pipelines to provide continuous security monitoring and analysis. In this architecture, Defender for DevOps performs static analysis and provides visibility of security postures across multiple pipelines in AKS development and deployment.

- [Defender for Containers](/azure/defender-for-cloud/defender-for-containers-introduction) is a cloud-native solution that enhances, monitors, and maintains the security of containerized assets throughout CI/CD pipelines. In this architecture, it scans container images in the registry for vulnerabilities during the CI process and provides runtime threat protection for the AKS clusters and workloads in both staging and production environments.

- A [Defender agent](/azure/defender-for-cloud/defender-for-containers-introduction#sensor-based-capabilities) is a security monitoring component deployed as a DaemonSet on AKS cluster nodes. In this architecture, it runs on each node in both staging and production clusters to collect runtime security telemetry, detect threats, and forward security events to Defender for Containers for centralized analysis and alerting.

## Alternatives


The scenario presented here has a few alternatives for you to consider as part of your own implementation.

### Pull-based model (GitOps)

This scenario shows a push-based model to deploy resources in AKS. Push-based deployments work best when you need deterministic updates to your clusters. Pipelines actively initiate deployments, monitor their success, and take direct action if deployments fail. This approach is often an important characteristic of safe deployment practices in workloads. Push-based deployments also suit multiple deployment targets, such as blue-green environments, where you need a highly controlled rollout pattern within a single cluster or across clusters.

Alternatively, pull-based deployments rely on clusters to fetch and apply updates. This pattern decouples deployment logic from the pipeline, which allows individual clusters to reconcile against a desired state stored in a central location, such as a Git repository (in GitOps workflows) or an artifact registry. Pull-based deployments work best for environments that prioritize consistency, auditability, and self-healing. The source of truth lives externally, often in version-controlled systems, so clusters continuously monitor and apply updates to match this desired state. This approach reduces the risk of drift. If a cluster experiences a failure or becomes unavailable, it can self-reconcile after it comes back online without requiring redeployment from a central pipeline. For more information, see [GitOps for AKS](/azure/architecture/example-scenario/gitops-aks/gitops-blueprint-aks).

To enhance this system, use [Azure Monitor managed service for Prometheus](/azure/azure-monitor/metrics/prometheus-metrics-overview) and [Azure Managed Grafana](/azure/managed-grafana/overview). Azure Monitor managed service for Prometheus collects metrics from AKS clusters and forwards them to Azure Monitor, which provides observability for application performance monitoring and alerting beyond the standard Azure Monitor metrics. Azure Managed Grafana provides advanced visualization capabilities. You can create dashboards that visualize pipeline health, AKS cluster performance, and application metrics in a unified view.

## Next steps

- [CI/CD baseline architecture that uses Azure Pipelines](/azure/devops/pipelines/architectures/devops-pipelines-baseline-architecture).
- [Training: Introduction to Kubernetes on Azure](/training/paths/intro-to-kubernetes-on-azure).

## Related resources

- [Microservices architecture on AKS](../../reference-architectures/containers/aks-microservices/aks-microservices.yml).
- [AKS solution journey](../../reference-architectures/containers/aks-start-here.md)
