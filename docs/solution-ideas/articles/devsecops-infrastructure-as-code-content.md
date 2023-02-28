[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This solution idea illustrates the DevSecOps pipeline using GitHub for IaC and how to govern the workflow for operation excellence, security, and cost optimization.

*Terraform is a trademark of Hashicorp. No endorsement is implied by the use of this mark.*

## Architecture

:::image type="content" source="../media/devsecops-for-iac.png" alt-text="Diagram that shows the architecture for DevSecOps for IaC." lightbox="../media/devsecops-for-iac.png":::

*Download a [Visio file](https://arch-center.azureedge.net/devsecops-for-iac.vsdx) of this architecture.*

### Dataflow

1. With test driven development, you check in code changes for infrastructure definitions, like IaC templates, into GitHub repositories. You develop unit tests, integration tests, and PaC at the same time to test the quality of IaC.
2. Pull requests (PRs) trigger automated unit testing through GitHub Actions.
3. You configure the GitHub Actions workflow process to test the IaC with locally deployed infrastructure states and plans.
4. You configure GitHub Actions to scan for code quality and security issues. You then use security scanning tools built on GitHub's CodeQL to scan for security vulnerabilities on the IaC. If a vulnerability is detected, GitHub sends alerts to the organization or to repository owners and maintainers.
5. The IaC tool provisions and modifies resources for each environment, tailoring size, instance count, and other properties. You can run automated integration tests for IaC on provisioned resources.
6. When a manual update to the infrastructure is necessary, the designated administrator access is elevated to perform the modifications. After modification, the elevated access is removed, and an issue should be logged into GitHub for reconciliation of the IaC. The reconciliation steps and possibility depend on the specific IaC tools.
7. SecOps continuously monitors and defends against security threats and vulnerabilities. Azure Policy enforces cloud governance.
8. When an anomaly is detected, an issue should be automatically raised in GitHub for rectifications.

### Components

- [GitHub](https://github.com) is a code-hosting platform for version control and collaboration. A GitHub source-control [repository](https://docs.github.com/github/creating-cloning-and-archiving-repositories/about-repositories) contains all project files and their revision history. Developers can work together to contribute, discuss, and manage code in the repository.
- [GitHub Actions](https://github.com/features/actions) provides a suite of build and release workflows that covers continuous integration (CI), automated testing, and container deployments.
- [GitHub Advanced Security](https://github.com/advanced-security) provides features to secure your IaC. It requires another license.
- [CodeQL](https://codeql.github.com) provides security scanning tools that run on static code to detect infrastructure misconfigurations.
- [Terraform](https://www.terraform.io) is a partner product developed by HashiCorp that allows infrastructure automation on Azure and other environments.
- [Microsoft Defender for Cloud](https://azure.microsoft.com/services/defender-for-cloud) provides unified security management and advanced threat protection across hybrid cloud workloads.
- [Microsoft Sentinel](https://azure.microsoft.com/services/microsoft-sentinel) is a cloud-native SIEM and security orchestration automated response (SOAR) solution. It uses advanced AI and security analytics to help you detect and respond to threats across your enterprise.
- [Azure Policy](https://azure.microsoft.com/services/azure-policy) helps teams manage and prevent IT issues through policy definitions that can enforce rules for cloud resources. For example, if your project is about to deploy a virtual machine with an unrecognized SKU, Azure Policy alerts you to the problem and stops the deployment.
- [Azure Monitor](https://azure.microsoft.com/services/monitor) collects and analyzes app telemetry, such as performance metrics and activity logs. When this service identifies irregular conditions, it alerts apps and personnel.

## Scenario details

Conceptually, the DevSecOps for infrastructure as code (IaC) is similar to [DevSecOps for application code on AKS](../../guide/devsecops/devsecops-on-aks.yml). But you need a different set of pipelines and tools to manage and automate continuous integration and continuous delivery (CI/CD) for IaC.

When you adopt IaC, it's important to create automation tests as you develop the code. These tests reduce the complexity of testing IaC when your workload scales. You can use local infrastructure configuration states like Terraform states and plans to develop [test-driven development (TDD) for IaC](/azure/cloud-adoption-framework/ready/considerations/test-driven-development). These configuration states emulate the actual deployments. You can run integration tests for IaC on actual infrastructure deployments using the [Azure Resource Graph REST API](/rest/api/azure-resourcegraph/).

Policy as Code (PaC) is also an important method to deliver infrastructure that's compliant to regulations and corporate governance. You can add [PaC workflows](/azure/governance/policy/concepts/policy-as-code) into your pipelines to automate cloud governance.

Securing infrastructure early in the development stage reduces the risks of misconfiguring infrastructure that opens up points for attack after deployment. You can integrate static code analysis tools for infrastructure like Synk, or Aquasecurity tfsec by using GitHub’s CodeQL, to scan security issues in infrastructure code. This process is similar to Static Application Security Testing (SAST).

When the infrastructure is deployed and operational, cloud configuration drifts can be difficult to resolve, especially in production environments.

Set up dedicated service principals to deploy or modify cloud infrastructure for production environments. Then remove all other access that allows manual configuration of the environment. In the event you need manual configurations, elevate access for the designated administrator, and then remove elevated access once the change is modified. You should configure Azure Monitor to raise an issue in GitHub for developers to reconcile the changes. However, manual configuration should be avoided if possible.

It's important to continuously monitor the cloud environment for threats and vulnerabilities to prevent security incidents. You can use Threat protection and security information and event management (SIEM) tools to detect abnormal traffic. These tools automatically alert security administrators and raise an issue in GitHub for attention.

### Potential use cases

You're part of a central team of IaC developers that uses a multicloud strategy for the fictional company Contoso. You want to deploy cloud infrastructure into a new Azure landing zone, using DevSecOps for IaC to ensure the security and quality of deployments. You also want to track and audit all modifications to the infrastructure.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Vito Chin](https://www.linkedin.com/in/vitochin) | SR Cloud Solution Architect
- [Yee Shian Lee](https://www.linkedin.com/in/yeeshian) | SR Cloud Solution Architect

## Next steps

- Consider the preferred [IaC tools](https://azure.microsoft.com/solutions/devsecops/#overview) to use for DevSecOps and ensure that they come with extensions to perform IaC security scanning.
- Consider the preferred IaC language or templates, [Bicep](/azure/azure-resource-manager/bicep/overview?tabs=bicep) or [Terraform on Azure](/azure/developer/terraform).
- [The GitHub Guide to Organizations](https://www.scribd.com/document/513270621/github-guide-to-organizations)
- [Use GitHub Actions to connect to Azure](/azure/developer/github/connect-from-azure?tabs=azure-portal%2Cwindows)
- [GitHub Actions](https://docs.github.com/en/actions)
- [Innovation Security](/azure/cloud-adoption-framework/secure/innovation-security)
- [AzOps for ARM templates](https://github.com/Azure/AzOps)
- [Terraform Landing Zones Module and Solutions](https://github.com/aztfmod)
- [Introduction to infrastructure as code using Bicep](/training/modules/introduction-to-infrastructure-as-code-using-bicep)

## Related resources

- [Build a CI/CD pipeline for chatbots with ARM templates](../../example-scenario/apps/devops-cicd-chatbot.yml)
- [DevSecOps in GitHub](../../solution-ideas/articles/devsecops-in-github.yml)
- [Enterprise infrastructure as code using Bicep and Azure Container Registry](../../guide/azure-resource-manager/advanced-templates/enterprise-infrastructure-bicep-container-registry.yml)
- [GitOps for Azure Kubernetes Service](../../example-scenario/gitops-aks/gitops-blueprint-aks.yml)
- [Tenancy models to consider for a multitenant solution](../../guide/multitenant/considerations/tenancy-models.yml)
