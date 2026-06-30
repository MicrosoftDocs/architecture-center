---
title: Get Started with DevOps Architecture Design
description: Learn about DevOps and how to implement DevOps solutions on Azure by using services such as Azure DevOps, Azure Pipelines, Azure Monitor, and Azure DevTest Labs.
author: claytonsiemens77
ms.author: pnp
ms.update-cycle: 1095-days
ms.date: 06/22/2026
ms.topic: concept-article
ms.subservice: category-get-started
ai-usage: ai-generated
---

# Get started with DevOps architecture design

[DevOps](/devops/what-is-devops) integrates development, quality assurance (QA), and IT operations into a unified culture and set of processes for delivering software. By adopting DevOps practices, teams can deliver higher-quality solutions faster and respond to changing business requirements with greater agility.

## Azure services for DevOps

Azure provides a range of operations and services for DevOps.

### DevOps operations

- [Continuous integration (CI)](/devops/develop/what-is-continuous-integration): The practice of frequently merging all developer code into a central codebase and performing automated build and test processes. The objectives are to quickly discover and correct code problems, streamline deployment, and ensure code quality.

- [Continuous delivery (CD)](/devops/deliver/what-is-continuous-delivery): The practice of automatically building, testing, and deploying code to production-like environments. The objective is to ensure that code is always ready to deploy. Adding CD to create a full CI/CD pipeline helps you detect code defects as soon as possible. It also ensures that properly tested updates can be released in a short time.

- Continuous deployment: A process that automatically takes any updates that pass through the CI/CD pipeline and deploys them into production. Continuous deployment requires robust automatic testing and advanced process planning. It might not be appropriate for all teams.

- Continuous monitoring: The process and technology required to incorporate monitoring across each phase of DevOps and IT operations lifecycles. Monitoring helps ensure the health, performance, and reliability of your application and infrastructure as the application moves from development to production. Continuous monitoring builds on the concepts of CI and CD.

### DevOps services

- [Azure DevOps](/azure/devops/user-guide/what-is-azure-devops): Plan, develop, and deliver software faster with integrated DevOps services, including version control, CI/CD pipelines, and package management.

- [Azure Pipelines](/azure/devops/pipelines/get-started/what-is-azure-pipelines): Automate build, test, and deployment processes with cloud-hosted CI/CD pipelines for any platform or language.

- [GitHub Actions](https://docs.github.com/actions): Automate software workflows directly from your GitHub repository with native CI/CD, testing, and deployment capabilities.

- [Azure Monitor](/azure/azure-monitor/fundamentals/overview): Monitor, analyze, and optimize application and infrastructure performance with comprehensive observability and diagnostics.

## Architecture

:::image type="complex" border="false" source="images/devops-get-started-diagram.svg" alt-text="Diagram that shows the DevOps solution journey on Azure." lightbox="images/devops-get-started-diagram.svg":::
   The diagram shows a DevOps workflow that uses GitHub and Azure services. The workflow starts with an infrastructure team icon, which points to a GitHub repository icon. An arrow points from the repository to the branch. An arrow points from the branch to a pull request (PR). An arrow points from the PR to GitHub Actions test and plan. An arrow points from test and plan to an approval process. An arrow points from the approval process to merge. An arrow points from merge to a GitHub Actions deployment. An arrow points from GitHub Actions deployment to an Azure resources section, which includes Azure Key Vault, Azure Kubernetes Service (AKS), and a managed identity. A Terraform-specific section includes the schedule and GitHub Actions drift and detect. An arrow points from the drift detection section to the Azure resources section, where the actual infrastructure state is compared with the desired state defined in code.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/devops-get-started-diagram.vsdx) of this architecture.*

The previous diagram demonstrates a typical basic or baseline DevOps implementation. For real-world solutions that you can build in Azure, see [DevOps architectures](#devops-architectures).

## Explore DevOps guides, architectures, and solution ideas

The articles in this section include guides and fully developed architectures that you can deploy in Azure and expand to production-grade solutions. Solution ideas demonstrate implementation patterns and possibilities to consider as you plan your DevOps proof-of-concept (POC) development. These articles can help you decide how to use DevOps technologies in Azure.

### DevOps guides

The following articles help you evaluate and select the best DevOps technologies for your workload requirements.

#### CI/CD implementation

- [Build a CI/CD pipeline for Azure Kubernetes Service (AKS) apps by using Azure Pipelines](../aks/aks-cicd-azure-pipelines.md): Implement CI/CD for Azure Kubernetes Service (AKS) applications by using Azure Pipelines with security scanning and monitoring.

- [Build a CI/CD pipeline for microservices on Kubernetes with Azure DevOps and Helm](../../microservices/ci-cd-kubernetes.yml): Design CI/CD pipelines for microservices architectures on Azure Kubernetes Service (AKS) by using Azure DevOps and Helm charts.

#### DevSecOps

- [DevSecOps on Azure Kubernetes Service (AKS)](../devsecops/devsecops-on-aks.md): Embed security controls and best practices across DevOps lifecycle stages for Azure Kubernetes Service (AKS)-hosted workloads.

### DevOps architectures

The following production-ready architectures demonstrate end-to-end DevOps solutions that you can deploy and customize.

#### CI/CD pipelines

- [CI/CD baseline architecture with Azure Pipelines](/azure/devops/pipelines/architectures/devops-pipelines-baseline-architecture): Build a CI/CD pipeline by using Azure Pipelines to deploy application changes to staging and production environments.

- [Automate API deployments with APIOps](../../example-scenario/devops/automated-api-deployments-apiops.yml): Apply GitOps and DevOps techniques to API deployment by using Azure API Management and Azure DevOps.

- [Manage Microsoft 365 tenant configuration by using Microsoft365DSC and Azure DevOps](../../example-scenario/devops/manage-microsoft-365-tenant-configuration-microsoft365dsc-devops.yml): Track and automate changes to Microsoft 365 tenant configurations by using Azure DevOps and PowerShell DSC.

#### GitOps

- [GitOps for Azure Kubernetes Service (AKS)](../../example-scenario/gitops-aks/gitops-blueprint-aks.yml): Implement GitOps principles to operate and manage Azure Kubernetes Service (AKS) clusters by using Flux or Argo CD.

#### Deployment patterns

- [Blue-green deployment of Azure Kubernetes Service (AKS) clusters](../aks/blue-green-deployment-for-aks.yml): Deploy Azure Kubernetes Service (AKS) clusters by using a blue-green deployment strategy with infrastructure as code (IaC) and CI/CD pipelines.

### DevOps solution ideas

The following DevOps solution ideas demonstrate implementation patterns and possibilities to explore:

- [DevSecOps for IaC](../../solution-ideas/articles/devsecops-infrastructure-as-code.yml): Implement a DevSecOps pipeline by using GitHub for IaC with governance for operational excellence, security, and cost optimization.

- [Enable DevSecOps with Azure and GitHub](../../solution-ideas/articles/devsecops-in-github.yml): Build a DevSecOps pipeline by using GitHub-native tooling integrated with Azure services for security scanning and deployment.

## Organizational readiness

Organizations at the beginning of the cloud adoption process can use the [Cloud Adoption Framework for Azure](/azure/cloud-adoption-framework/) to access proven guidance that accelerates cloud adoption.

- [DevOps considerations for Azure landing zones](/azure/cloud-adoption-framework/ready/considerations/devops-principles-and-practices): Define your DevOps framework, establish metrics, plan your implementation journey, and select your DevOps toolchain.

To help ensure the quality of your DevOps solution on Azure, follow the guidance in the [Azure Well-Architected Framework](/azure/well-architected/). The Well-Architected Framework provides prescriptive guidance for organizations that seek architectural excellence and describes how to design, provision, and monitor cost-optimized Azure solutions.

## Best practices

Follow these best practices to improve the security, reliability, performance, and operational quality of your DevOps workloads on Azure.

### DevOps

- [Make your Azure DevOps secure](/azure/devops/organizations/security/security-overview): Comprehensive security guidance for Azure DevOps, including network protection, Zero Trust implementation, access control, and service-level security measures.

- [Shift left to make testing fast and reliable](/devops/develop/shift-left-make-testing-fast-reliable): Guidance for shifting testing earlier in the development cycle, including test pyramids, fast feedback loops, and reliable test practices.

- [Shift right to test in production](/devops/deliver/shift-right-test-production): Guidance for production testing practices, including canary releases, feature flags, and fault injection.

- [Migrate from Team Foundation Version Control (TFVC) to Git](/azure/devops/repos/git/import-from-tfvc): Guidance for migrating source control from Team Foundation Version Control to Git repositories in Azure DevOps.

- [Reliability guides by service](/azure/reliability/overview-reliability-guidance): Service-specific guidance for building reliable solutions on Azure.

- [Monitor your Azure cloud estate](/azure/cloud-adoption-framework/manage/monitor): Plan, configure, and optimize monitoring across Azure environments by using Azure Monitor, Microsoft Defender for Cloud, Microsoft Sentinel, and other tools.

- [Reliability best practices in Azure Monitor](/azure/azure-monitor/fundamentals/best-practices-reliability): Guidance for monitoring application reliability by using Azure Monitor.

- [Overview of the Microsoft cloud security benchmark](/security/benchmark/azure/overview): Recommendations for securing cloud solutions on Azure, aligned with industry frameworks such as NIST and PCI.

- [DevOps security](/security/benchmark/azure/mcsb-v2-devops-security): Security controls for DevOps processes, including static application security testing, vulnerability management, threat modeling, and software supply chain security.

- [Azure identity management and access control security best practices](/azure/security/fundamentals/identity-management-best-practices): Best practices for implementing identity management and access control by using Microsoft Entra ID.

- [Azure security best practices and patterns](/azure/security/fundamentals/best-practices-and-patterns): A collection of security best practices for designing, deploying, and managing cloud solutions on Azure.

- [Azure operational security checklist](/azure/security/fundamentals/operational-checklist): A checklist that covers operational security practices for Azure deployments.

- [Secure development best practices on Azure](/azure/security/develop/secure-dev-overview): Best practices for building secure applications on Azure, including the security development lifecycle.

### Azure Artifacts

- [Best practices for Azure Artifacts](/azure/devops/artifacts/concepts/best-practices): Guidelines for creating, publishing, and consuming packages in Azure Artifacts, including feed management and retention policies.

### Azure Resource Manager

- [Azure Resource Manager template (ARM template) best practices](/azure/azure-resource-manager/templates/best-practices): Recommended practices for constructing Azure Resource Manager templates (ARM templates), including parameter design, resource dependencies, and API versioning.

- [Best practices for Bicep](/azure/azure-resource-manager/bicep/best-practices): Recommendations for developing Bicep files, including naming conventions, resource definitions, and output security.

## Stay current with DevOps

Azure DevOps services evolve to address modern development and operations challenges. Stay informed about the latest [updates and features](https://azure.microsoft.com/updates/).

To stay current with key DevOps services, see the following articles:

- [Azure DevOps roadmap](/azure/devops/release-notes/features-timeline)
- [Azure DevOps documentation - what's new?](/azure/devops/release-notes/docswhatsnew/)
- [What's new in Azure Monitor documentation](/azure/azure-monitor/fundamentals/whats-new)

## Other resources

DevOps is a broad category and covers a range of solutions. The following resources can help you discover more about Azure services that support DevOps implementations.

### Microsoft Fabric CI/CD

In Microsoft Fabric, you achieve CI/CD by connecting your Fabric workspace to a Git repository (Azure DevOps or GitHub) for version control and branch-based workflows. You manage continuous deployment by using deployment pipelines.

- [Microsoft Fabric Git integration](/fabric/cicd/git-integration/intro-to-git-integration): Connect your Fabric workspace to Azure DevOps or GitHub for version control and CI.

- [Introduction to deployment pipelines](/fabric/cicd/deployment-pipelines/intro-to-deployment-pipelines): Promote content across development, test, and production environments by using deployment pipelines.

## Amazon Web Services (AWS) or Google Cloud professionals

To help you get started quickly, the following articles compare Azure DevOps options to other cloud services and provide migration guidance.

### Service comparison

- [Azure for AWS professionals - DevOps and application monitoring](../../aws-professional/index.md#devops-and-application-monitoring)
- [Google Cloud to Azure services comparison - DevOps and application monitoring](../../gcp-professional/services.md#devops-and-application-monitoring)

### Migration guidance

If you're migrating from another cloud platform, see the following article:

- [Migrate a workload from Amazon Web Services (AWS) to Azure](/azure/migration/migrate-workload-from-aws-introduction)
