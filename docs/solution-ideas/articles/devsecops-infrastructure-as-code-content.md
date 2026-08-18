[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This solution idea illustrates a DevSecOps pipeline that uses GitHub for infrastructure as code (IaC). By treating infrastructure definitions as the source of truth, workloads can automate validation, security scanning, governance, and compliance throughout the deployment lifecycle.

Standardized deployment patterns, AI-assisted development, code security and configuration scanning, policy-driven governance, and lifecycle management help improve security, increase operational efficiency, reduce configuration drift, and deliver reliable cloud environments.

## Architecture

:::image type="complex" border="false" source="../media/devsecops-for-iac.svg" alt-text="Diagram that shows the architecture for DevSecOps for IaC." lightbox="../media/devsecops-for-iac.svg":::
   The diagram shows an architecture that uses DevSecOps for IaC. Going from left to right, callout 1 has bulleted text "Infrastructure as code and tests" and "Policy as code", and refers to a user icon connected by an arrow labeled "GitHub Copilot" to a GitHub icon. Callout 2 shows an arrow labeled "GitHub repos" pointing from the GitHub icon to a box. Inside the box, callouts 3, 4, and 5 refer to icons labeled GitHub Actions, GitHub Advanced Security, and DevOps Security in Microsoft Defender for Cloud, respectively. Callout 6 has bulleted text "Azure Verified Modules" and "Azure deployment stacks", and shows an arrow pointing from the box to an icon labeled Azure Resource Manager and from there to another box. Callout 7 is in this box along with icons labeled Microsoft Defender for Cloud, Microsoft Sentinel, Azure Policy, and Azure Monitor. A dotted line arrow going left from the bottom of this box points to callout 8. Callout 8 is labeled GitHub Issues and has text "Configuration drifts and reconciliation". A dotted line arrow going left from callout 8 points back up to callout 2. 
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/devsecops-for-iac-avm.vsdx) of this architecture.*

### Data flow

The following data flow corresponds to the preceding diagram:

1. Developers use AI-assisted, test-driven development to create and maintain infrastructure code, reusable modules, tests, and deployment workflows. They develop unit tests, integration tests, and policy as code (PaC) checks alongside infrastructure definitions.

1. Developers check in the IaC, tests, and checks to GitHub repositories to validate quality, security, and compliance before submitting pull requests.

1. Pull requests trigger automated tests in GitHub Actions. This workflow generates and validates deployment previews before deployment.

1. GitHub Advanced Security provides repository-level security checks. The checks include code scanning or dependency review workflows where appropriate, and enable secret scanning and push protection on the repository to detect exposed secrets.

1. A configured DevOps security action scans infrastructure definitions for misconfigurations and reports findings to DevOps security in Microsoft Defender for Cloud. Defender for Cloud correlates those findings with cloud security posture insights to help prioritize remediation before deployment.

1. The deployment pipeline provisions or updates Azure resources by using reusable IaC artifacts from approved infrastructure definitions, such as Azure Verified Modules (AVM). Azure deployment stacks help maintain alignment between deployed resources and source-controlled definitions, and deployment deny settings help reduce configuration drift by restricting out-of-band changes. Approved manual changes are documented and reconciled through source control to preserve Git as the authoritative source of truth.

1. DevSecOps continuously monitors and defends against security threats and vulnerabilities. Azure Policy enforces cloud governance. 

1. Configured automation creates a GitHub Issue when monitoring or security services detect an anomaly. For example, Defender for Cloud might identify a publicly exposed resource that violates security requirements. An Azure Monitor action group or Microsoft Sentinel automation rule can invoke an Azure Logic Apps workflow that creates a GitHub Issue to review and remediate.

### Components

- [GitHub](https://github.com) is a code-hosting platform for version control and collaboration. In this architecture, GitHub stores IaC templates in central [repositories](https://docs.github.com/repositories/creating-and-managing-repositories/about-repositories) for development, testing, governance workflows, and AI-assisted development with GitHub Copilot.

- [GitHub Actions](https://github.com/features/actions) is a continuous integration and continuous deployment (CI/CD) automation tool that enables workflows to build, test, and deploy code directly from GitHub repositories. In this architecture, GitHub Actions automates unit testing, security scanning, and infrastructure provisioning for IaC pipelines.

- [GitHub Advanced Security](https://github.com/security/advanced-security) provides repository-level security capabilities, including secret scanning and dependency vulnerability detection. In this architecture, GitHub Advanced Security helps identify exposed credentials, vulnerable open-source dependencies, and other repository security risks before code is merged and deployed.

- [DevOps security in Defender for Cloud](/azure/defender-for-cloud/defender-for-devops-introduction) centralizes DevOps security findings and correlates them with cloud context. In this architecture, a configured [Microsoft Security DevOps GitHub action](/azure/defender-for-cloud/iac-vulnerabilities) scans IaC artifacts for misconfigurations and reports the findings to Defender for Cloud for prioritization and remediation.

- [Azure Verified Modules (AVM)](https://azure.github.io/Azure-Verified-Modules/) are prebuilt IaC modules maintained by Microsoft. In this architecture, workloads use AVM to deploy reusable resource and pattern modules that align with Azure Well-Architected Framework guidance.

- [Azure deployment stacks](/azure/azure-resource-manager/bicep/deployment-stacks) enable workloads to manage deployed resources as single lifecycle-managed units. Azure deployment stacks help maintain alignment between deployed resources and source-controlled infrastructure definitions, support lifecycle management, and reduce configuration drift by applying governance controls and deny settings.

- [Defender for Cloud](/azure/defender-for-cloud/defender-for-cloud-introduction) is a security management platform that provides threat protection across hybrid cloud workloads. In this architecture, it continuously monitors deployed infrastructure for vulnerabilities and threats, and complements DevOps security findings with runtime security insights.

- [Microsoft Sentinel](/azure/sentinel/overview) is a cloud-native security information and event management (SIEM) and security orchestration automated response (SOAR) solution that uses AI and analytics to detect and respond to threats. In this architecture, Microsoft Sentinel monitors infrastructure activity and raises alerts or GitHub Issues when it detects anomalies.

- [Azure Policy](/azure/governance/policy/overview) evaluates Azure resources against organizational and workload standards. Depending on the assigned policy effect, Azure Policy can audit, modify, remediate, or deny noncompliant configurations. For example, a policy definition with the `deny` effect can block deployment of a virtual machine whose SKU isn't allowed.

- [Azure Monitor](/azure/azure-monitor/fundamentals/overview) is a telemetry and observability platform that collects performance metrics and activity logs from Azure resources. In this architecture, Azure Monitor detects irregular infrastructure conditions and triggers alerts so triage and remediation can start.

## Scenario details

When you adopt IaC, create automated tests as you develop the code. Generate deployment plans and infrastructure configuration states to emulate actual deployments. [Test-driven development](/azure/cloud-adoption-framework/ready/considerations/test-driven-development) reduces the complexity of testing IaC when your workload scales.

Run integration tests against deployed Azure resources by using Azure SDKs and APIs, Azure Resource Graph, workload-specific validation tools, or automated test frameworks. These tests help verify resource configuration, connectivity, security controls, and operational readiness.

PaC is another important method to deliver infrastructure that complies with regulations and corporate governance. You can add [PaC workflows](/azure/governance/policy/concepts/policy-as-code) into your pipelines to automate cloud governance.

Securing infrastructure early in the development lifecycle reduces the risk of security and compliance issues after deployment. Integrate GitHub Advanced Security and Defender for Cloud DevOps security into DevSecOps workflows to identify vulnerabilities, code quality issues, policy violations, secrets exposure, and configuration risks in IaC code. This approach is similar to static application security testing (SAST) for application code.

Configuration drift can be difficult to resolve when infrastructure is deployed and operational, especially in production environments. Use GitHub Actions with OpenID Connect (OIDC) and Microsoft Entra Workload Identity Federation to provision and manage Azure resources without storing credentials. Restrict deployment permissions through least-privilege Azure role-based access control (Azure RBAC) assignments and environment protection controls. To make exceptional manual changes, use just-in-time privileged access, record the change, and automatically create a GitHub Issue to reconcile the infrastructure definition through source control. Avoid manual configuration whenever possible, and treat Git as the authoritative source of infrastructure state.

To help prevent drift at its source, use Azure deployment stacks when a group of Azure resources defined in a template share a lifecycle. Account for [deployment stack limitations](/azure/azure-resource-manager/bicep/deployment-stacks-known-issues), and apply appropriate deny settings to restrict out-of-band control-plane changes. Keep the IaC definition versioned in source control.

To help prevent security incidents, continuously monitor the cloud environment for threats and vulnerabilities. Use Defender for Cloud, Microsoft Sentinel, Azure Monitor, and other threat protection and SIEM tools to detect abnormal activity. These tools can automatically alert security administrators and raise GitHub Issues for investigation and remediation.

### Potential use cases

Central platform engineering teams can provide reusable GitHub Actions workflows, PaC controls, and Azure deployment stacks to application, data, and AI teams as approved golden paths. GitHub Copilot helps developers create infrastructure definitions, tests, and deployment workflows. A configured Microsoft Security DevOps action validates infrastructure security and configuration before deployment and reports findings to DevOps security in Defender for Cloud. The organization can accelerate infrastructure delivery while maintaining governance, consistency, and security standards.

Financial services, healthcare, public sector, or regulated enterprises can use DevSecOps for IaC to automate infrastructure deployment, policy enforcement, security validation, and compliance reporting. Azure Policy, Defender for Cloud, Microsoft Sentinel, and Azure deployment stacks help maintain auditable infrastructure changes, reduce configuration drift, and support compliance throughout the infrastructure lifecycle. GitHub is the authoritative source of truth for all infrastructure modifications and governance controls.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Vito Chin](https://www.linkedin.com/in/vitochin) | Senior Cloud Solution Architect
- [Yee Shian Lee](https://www.linkedin.com/in/yeeshian) | Senior Cloud Solution Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- Consider what IaC language or template to use. [Bicep](/azure/azure-resource-manager/bicep/overview?tabs=bicep) or [Terraform on Azure](/azure/developer/terraform) are options.
- [Set up Microsoft Security DevOps to scan your connected GitHub repository](/azure/defender-for-cloud/iac-vulnerabilities).