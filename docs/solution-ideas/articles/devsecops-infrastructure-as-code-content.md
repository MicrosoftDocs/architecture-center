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

1. Configure the GitHub Actions workflow process to test the IaC by using locally generated infrastructure states and plans.

1. Configure GitHub Actions to scan for code quality and security problems. Scan using your own custom-built GitHub CodeQL queries or other security tooling to analyze IaC templates and detect potential security vulnerabilities. If a vulnerability is detected, GitHub sends alerts to the organization or to repository owners and maintainers.

1. The IaC tool provisions and modifies resources for each environment by tailoring size, instance count, and other properties. You can run automated integration tests for IaC on provisioned resources.

1. When a manual update to the infrastructure is necessary, the designated administrator access is elevated to perform the modifications. After modification, the elevated access is removed. You should also log a GitHub Issue for reconciliation of the IaC. The reconciliation steps and approaches depend on the specific IaC tools.

1. SecOps continuously monitors and defends against security threats and vulnerabilities. Azure Policy enforces cloud governance.

1. When an anomaly is detected, a GitHub Issue is automatically logged so that it can be resolved.

### Components

- [GitHub](https://github.com) is a code-hosting platform for version control and collaboration. In this architecture, it stores IaC templates and serves as the central [repository](https://docs.github.com/github/creating-cloning-and-archiving-repositories/about-repositories) for development, testing, and governance workflows.

- [GitHub Actions](https://github.com/features/actions) is a continuous integration and continuous deployment (CI/CD) automation tool that enables workflows to build, test, and deploy code directly from GitHub repositories. In this architecture, GitHub Actions automates unit testing, security scanning, and infrastructure provisioning for IaC pipelines.

- [GitHub Advanced Security](https://github.com/advanced-security) is a suite of security features that includes static analysis and vulnerability detection for code stored in GitHub. In this architecture, it enhances IaC security by scanning templates and raising alerts about misconfigurations or risks.

- [CodeQL](https://codeql.github.com) is a semantic code analysis engine that enables custom queries to detect vulnerabilities and misconfigurations in code. In this architecture, CodeQL scans repository artifacts to identify potential security problems before deployment.

  > [!NOTE]
  > CodeQL does not natively support scanning of all IaC files, such as Terraform. However, you can use the [CodeQL IaC Extractor](https://github.com/advanced-security/codeql-extractor-iac/) community project or vendor-provided alternatives like Aqua Security's [Trivy](https://github.com/aquasecurity/trivy).

- [Terraform](https://www.terraform.io) is an open-source infrastructure automation tool developed by HashiCorp that enables declarative provisioning across cloud environments. In this architecture, Terraform provisions and modifies Azure resources based on IaC definitions and supports test-driven development workflows.

- [Microsoft Defender for Cloud](/azure/defender-for-cloud/defender-for-cloud-introduction) is a security management platform that provides threat protection across hybrid cloud workloads. In this architecture, it continuously monitors deployed infrastructure for vulnerabilities.

- [Microsoft Sentinel](/azure/sentinel/overview) is a cloud-native security information and event management (SIEM) and security orchestration automated response (SOAR) solution that uses AI and analytics to detect and respond to threats. In this architecture, Microsoft Sentinel monitors infrastructure activity and raises alerts or GitHub Issues when anomalies are detected.

- [Azure Policy](/azure/governance/policy/overview) is a governance service that enforces rules and compliance across Azure resources. In this architecture, Azure Policy validates IaC deployments against organizational and workload standards and blocks noncompliant configurations. For example, if your project is about to deploy a virtual machine that has an unrecognized SKU, Azure Policy alerts you and stops the deployment.

- [Azure Monitor](/azure/azure-monitor/fundamentals/overview) is a telemetry and observability platform that collects performance metrics and activity logs from Azure resources. In this architecture, Azure Monitor detects irregular conditions in infrastructure and triggers alerts so triage and remediation can start.

## Scenario details

Conceptually, the DevSecOps for IaC is similar to [DevSecOps for application code on Azure Kubernetes Service (AKS)](../../guide/devsecops/devsecops-on-aks.yml). But you need a different set of pipelines and tools to manage and automate continuous integration and continuous delivery for IaC.

When you adopt IaC, it's important to create automation tests as you develop the code. These tests reduce the complexity of testing IaC when your workload scales. You can use local infrastructure configuration states like Terraform states and plans for [test-driven development](/azure/cloud-adoption-framework/ready/considerations/test-driven-development). These configuration states emulate the actual deployments. You can run integration tests for IaC on actual infrastructure deployments by using the [Azure Resource Graph REST API](/rest/api/azure-resourcegraph/).

PaC is another important method to deliver infrastructure that complies with regulations and corporate governance. You can add [PaC workflows](/azure/governance/policy/concepts/policy-as-code) into your pipelines to automate cloud governance.

Securing infrastructure early in the development stage reduces the risks of misconfigured infrastructure that exposes points for attack after deployment. You can integrate static code analysis tools like Snyk or Aqua Security Trivy by using GitHub's CodeQL to scan for security vulnerabilities in infrastructure code. This process is similar to static application security testing.

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
