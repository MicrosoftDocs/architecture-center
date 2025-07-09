[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This solution idea illustrates the DevSecOps pipeline that uses GitHub for infrastructure as code (IaC). It also describes how to govern the workflow for operational excellence, security, and cost optimization.

*Terraform is a trademark of Hashicorp. No endorsement is implied by the use of this mark.*

## Architecture

:::image type="complex" border="false" source="../media/devsecops-for-iac.svg" alt-text="Diagram that shows the architecture for DevSecOps for IaC." lightbox="../media/devsecops-for-iac.svg":::
   The diagram shows an architecture that uses DevSecOps for IaC. Arrows create a linear flow from a user icon that's labeled IaC and tests and policy as code to icons that represent GitHub repos, GitHub Actions, GitHub Advanced Security, Terraform, and Azure Resource Manager. A dotted line that's labeled configuration drifts and reconciliation points from Azure Resource Manager back to GitHub repos. A box to the right of the flow diagram includes Microsoft Defender for Cloud, Microsoft Sentinel, Azure Policy, and Azure Monitor. A dotted line that's labeled governance reconciliation points from this box back to GitHub repos.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/devsecops-for-iac.vsdx) of this architecture.*

### Dataflow

The following dataflow corresponds to the previous diagram:

1. Use test-driven development to check code changes for infrastructure definitions, like IaC templates, into GitHub repositories. You develop unit tests, integration tests, and policy as code (PaC) at the same time to test the quality of the IaC.

1. Pull requests trigger automated unit testing through GitHub Actions.

1. Configure the GitHub Actions workflow process to test the IaC by using locally deployed infrastructure states and plans.

1. Configure GitHub Actions to scan for code quality and security problems. Create your own custom-built GitHub CodeQL queries to analyze IaC templates and detect potential security vulnerabilities. If a vulnerability is detected, GitHub sends alerts to the organization or to repository owners and maintainers.

1. The IaC tool provisions and modifies resources for each environment by tailoring size, instance count, and other properties. You can run automated integration tests for IaC on provisioned resources.

1. When a manual update to the infrastructure is necessary, the designated administrator access is elevated to perform the modifications. After modification, the elevated access is removed. You should also log a GitHub Issue for reconciliation of the IaC. The reconciliation steps and approaches depend on the specific IaC tools.

1. SecOps continuously monitors and defends against security threats and vulnerabilities. Azure Policy enforces cloud governance.

1. When an anomaly is detected, a GitHub Issue is automatically logged so that it can be resolved.

### Components

- [GitHub](https://github.com) is a code-hosting platform for version control and collaboration. A GitHub source-control [repository](https://docs.github.com/github/creating-cloning-and-archiving-repositories/about-repositories) contains all project files and their revision history. Developers can work together to contribute, discuss, and manage code in the repository.

- [GitHub Actions](https://github.com/features/actions) provides a suite of build and release workflows that covers continuous integration, automated testing, and container deployments.

- [GitHub Advanced Security](https://github.com/advanced-security) provides features to secure your IaC. It requires another license.

- [CodeQL](https://codeql.github.com) provides security scanning tools that run on static code to detect infrastructure misconfigurations.

- [Terraform](https://www.terraform.io) is a partner product developed by HashiCorp that allows infrastructure automation on Azure and other environments.

- [Microsoft Defender for Cloud](/azure/defender-for-cloud/defender-for-cloud-introduction) provides unified security management and advanced threat protection across hybrid cloud workloads.

- [Microsoft Sentinel](/azure/sentinel/overview) is a cloud-native security information and event management (SIEM) and security orchestration automated response (SOAR) solution. It uses advanced AI and security analytics to help you detect and respond to threats across your enterprise.

- [Azure Policy](/azure/governance/policy/overview) helps teams manage and prevent IT problems by using policy definitions that can enforce rules for cloud resources. For example, if your project is about to deploy a virtual machine that has an unrecognized SKU, Azure Policy alerts you to the problem and stops the deployment.

- [Azure Monitor](/azure/azure-monitor/fundamentals/overview) collects and analyzes app telemetry, such as performance metrics and activity logs. When this service identifies irregular conditions, it alerts apps and personnel.

## Scenario details

Conceptually, the DevSecOps for IaC is similar to [DevSecOps for application code on Azure Kubernetes Service (AKS)](../../guide/devsecops/devsecops-on-aks.yml). But you need a different set of pipelines and tools to manage and automate continuous integration and continuous delivery for IaC.

When you adopt IaC, it's important to create automation tests as you develop the code. These tests reduce the complexity of testing IaC when your workload scales. You can use local infrastructure configuration states like Terraform states and plans for [test-driven development](/azure/cloud-adoption-framework/ready/considerations/test-driven-development). These configuration states emulate the actual deployments. You can run integration tests for IaC on actual infrastructure deployments by using the [Azure Resource Graph REST API](/rest/api/azure-resourcegraph/).

PaC is another important method to deliver infrastructure that complies with regulations and corporate governance. You can add [PaC workflows](/azure/governance/policy/concepts/policy-as-code) into your pipelines to automate cloud governance.

Securing infrastructure early in the development stage reduces the risks of misconfigured infrastructure that exposes points for attack after deployment. You can integrate static code analysis tools like Synk or Aqua Security tfsec by using GitHub's CodeQL to scan for security vulnerabilities in infrastructure code. This process is similar to static application security testing.

When the infrastructure is deployed and operational, cloud configuration drifts can be difficult to resolve, especially in production environments.

Set up dedicated service principals to deploy or modify cloud infrastructure for production environments. Then remove all other access that allows manual configuration of the environment. If you need manual configurations, elevate access for the designated administrator, and then remove elevated access after the change is made. You should configure Azure Monitor to raise a GitHub Issue so that developers can reconcile the changes. Avoid manual configuration if possible.

It's important to continuously monitor the cloud environment for threats and vulnerabilities to help prevent security incidents. You can use threat protection and SIEM tools to detect abnormal traffic. These tools automatically alert security administrators and raise a GitHub Issue.

### Potential use cases

You're part of a central team of IaC developers that uses a multicloud strategy for the fictional company Contoso. You want to deploy cloud infrastructure into a new Azure landing zone by using DevSecOps for IaC to help ensure the security and quality of deployments. You also want to track and audit all modifications to the infrastructure.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Vito Chin](https://www.linkedin.com/in/vitochin) | Senior Cloud Solution Architect
- [Yee Shian Lee](https://www.linkedin.com/in/yeeshian) | Senior Cloud Solution Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- Consider the preferred [IaC tools](https://azure.microsoft.com/solutions/devsecops/#overview) to use for DevSecOps and ensure that they come with extensions to perform IaC security scanning.
- Consider the preferred IaC language or templates, [Bicep](/azure/azure-resource-manager/bicep/overview?tabs=bicep) or [Terraform on Azure](/azure/developer/terraform).
- [The GitHub guide to organizations](https://www.scribd.com/document/513270621/github-guide-to-organizations)
- [Use GitHub Actions to connect to Azure](/azure/developer/github/connect-from-azure?tabs=azure-portal%2Cwindows)
- [GitHub Actions](https://docs.github.com/en/actions)
- [What do we mean by Zero Trust compliance?](/security/zero-trust/develop/identity-zero-trust-compliance)
- [AzOps for Azure Resource Manager templates](https://github.com/Azure/AzOps)
- [Terraform landing zones module and solutions](https://github.com/aztfmod)
- [Introduction to IaC using Bicep](/training/modules/introduction-to-infrastructure-as-code-using-bicep)

## Related resources

- [GitOps for AKS](../../example-scenario/gitops-aks/gitops-blueprint-aks.yml)
- [Tenancy models to consider for a multitenant solution](../../guide/multitenant/considerations/tenancy-models.md)
