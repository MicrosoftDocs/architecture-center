---
title: DevSecOps on Azure Kubernetes Service (AKS)
description: Learn how DevSecOps helps you incorporate security best practices from the start of software development.
author: akhan-msft
ms.author: adnankhan 
ms.date: 04/02/2026
ms.reviewer: ssumner
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom:
  - e2e-hybrid
  - kr2b-contr-experiment
---

# DevSecOps on Azure Kubernetes Service (AKS)

DevSecOps, also called *Secure DevOps*, builds on the practice of DevOps by incorporating security at different stages of a traditional DevOps life cycle. Build security into DevOps practices to:

- Make your applications and systems more secure, provide visibility into security threats, and prevent vulnerabilities from reaching deployed environments.

- Increase security awareness with your development and operation teams.

- Incorporate automated security processes into your software development life cycle.

- Reduce remediation costs when you find security problems early in development and design stages.

When you apply DevSecOps to Azure Kubernetes Service (AKS), each organization role has specific security considerations:

- Developers build secure applications that run on AKS.

- Cloud engineers build secure AKS infrastructure.

- Operations teams might govern clusters or monitor security problems.

This article organizes guidance by DevOps life cycle stage and provides recommendations for security controls and best practices. It covers common processes and tools for continuous integration and continuous delivery (CI/CD) pipelines, with a focus on built-in tools.

Before you read this article, review [Build and deploy apps on AKS by using DevOps and GitOps](/azure/architecture/guide/aks/aks-cicd-github-actions-and-gitops).

## Process flow

:::image type="complex" alt-text="Architecture diagram shows the flow from the developer to the user and where DevSecOps can be employed, DevSecOps on AKS." source="./media/devsecops-azure-aks.svg" lightbox="./media/devsecops-azure-aks.svg":::
The flow starts with a developer that connects to Microsoft Entra ID and works in development tools like Visual Studio and Visual Studio Code. The developer pushes code to GitHub, which serves as the central source control system. From GitHub, the process continues into GitHub Actions, where automated steps run. Other connections show pull requests, approval gates for deployments, and security checks that feed into this stage. GitHub Advanced Security and Microsoft Defender for DevOps connect to GitHub. The pipeline then connects to Azure Container Registry, which sits between the build process and the deployment target. Governance and security controls, including Microsoft Defender and Azure Policy, connect above and alongside this stage. From the registry, the flow moves into AKS, shown within a separate area on the right that represents the runtime environment. Around the Kubernetes environment, several connected components branch out. These components include Azure Policy and Azure Key Vault above, Log Analytics and Microsoft Sentinel to the right, and tools like network policy, Azure Monitor for containers, and Zed Attack Proxy (ZAP) below.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/devsecops-azure-aks.vsdx) of this architecture.*

> [!NOTE]
> This article references AKS and GitHub, but you can apply these recommendations to any container orchestration or CI/CD platform. The implementation details might vary, but most concepts and practices for each stage still apply.

1. [Microsoft Entra ID](/entra/fundamentals/whatis) is configured as the identity provider for GitHub. Configure multifactor authentication (MFA) to help provide extra authentication security.

1. Developers use [Visual Studio Code](https://code.visualstudio.com) or [Visual Studio](https://visualstudio.microsoft.com/vs/) with [security extensions](#best-practice-use-ide-tools-and-plugins-to-automate-security-checks) enabled to proactively analyze their code for security vulnerabilities.

1. Developers commit application code to a corporate owned and governed GitHub Enterprise repository.

1. GitHub Enterprise integrates automatic security and dependency scanning through [GitHub Advanced Security](https://docs.github.com/enterprise-cloud@latest/get-started/learning-about-github/about-github-advanced-security).

1. Pull requests trigger continuous integration (CI) builds and automated testing via [GitHub Actions](https://docs.github.com/actions).

1. The CI build workflow via GitHub Actions generates a Docker container image and stores it in [Azure Container Registry](/azure/container-registry/container-registry-concepts).

1. You can add manual approvals for deployments to specific environments, like production, as part of the continuous delivery (CD) workflow in GitHub Actions.

1. GitHub Actions enable CD to AKS. Use GitHub Advanced Security to detect secrets, credentials, and other sensitive information in your application source and configuration files.

1. Microsoft Defender scans Container Registry, the AKS cluster, and Azure Key Vault for security vulnerabilities.

   1. [Microsoft Defender for Containers](/azure/defender-for-cloud/defender-for-containers-introduction) scans the container image for known security vulnerabilities when GitHub Actions uploads it to Container Registry.
   
   1. Defender for Containers can also scan your AKS environment and provide runtime threat protection for your AKS clusters.

   1. [Microsoft Defender for Key Vault](/azure/defender-for-cloud/defender-for-key-vault-introduction) detects unusual and suspicious attempts to access key vault accounts.
   
1. You can apply [Azure Policy](/azure/governance/policy/overview) to Container Registry and AKS to enforce policy compliance. Azure Policy includes built-in security policies for both Container Registry and AKS.

1. [Key Vault](/azure/key-vault/key-vault-overview) securely injects secrets and credentials into an application at runtime without exposing them to developers.

1. The AKS network policy engine is configured to help secure traffic between application pods by using Kubernetes network policies. We recommend [Azure CNI Powered by Cilium](/azure/aks/azure-cni-powered-by-cilium) as the network policy engine. It provides extended Berkeley Packet Filter (eBPF)-based enforcement, layer-7 policy, and fully qualified domain name (FQDN) filtering.

1. You can set up continuous monitoring of the AKS cluster by using [Azure Monitor](/azure/azure-monitor/containers/kubernetes-monitoring-enable) to collect Prometheus metrics, container logs, and Kubernetes events. Use [Azure Managed Grafana](/azure/managed-grafana/overview) dashboards for visualization and [Log Analytics](/azure/azure-monitor/logs/log-analytics-overview) for query-based alerting.

   1. Azure Monitor collects performance metrics via Managed Prometheus and application and cluster logs via container log collection.

   1. A Log Analytics workspace pulls in diagnostic and application logs to run log queries.

1. Use Microsoft Sentinel as the centralized security information and event management (SIEM) to correlate AKS telemetry with signals from Microsoft Defender for Cloud, Microsoft Entra ID, and network resources. Microsoft Sentinel provides detection, investigation, and automated response to security incidents across the entire AKS environment.

1. Open-source tools such as [Zed Attack Proxy (ZAP)](https://www.zaproxy.org/) can do penetration testing for web applications and services.

1. Defender for DevOps, a service available in Defender for Cloud, empowers security teams to manage DevOps security across multipipeline environments including GitHub and Azure DevOps.

## Team members overview and responsibilities

Consider managing DevSecOps complexity on Kubernetes-based solution deployments by dividing responsibilities among teams. This section describes the roles and responsibilities of developers, application operators such as site reliability engineers, cluster operators, and security teams.

### Developers

Developers write the application code and commit it to the designated repository. They also author and run scripts for automated testing to ensure that their code works as intended and integrates with the rest of the application. Developers define and script the building of container images as part of the automation pipeline.

### Application operators (site reliability engineers)

Building applications on the cloud by using containers and Kubernetes can simplify application development, deployment, and scalability. But these development approaches also create increasingly distributed environments that complicate administration.

Site reliability engineers build solutions to automate the oversight of large software systems. They serve as a bridge between development and cluster operator teams and help establish and monitor service-level objectives (SLOs) and error budgets. Site reliability engineers help manage application deployments and write Kubernetes manifest (YAML) files.

### Cluster operators

Cluster operators configure and manage the cluster infrastructure. They often use infrastructure as code (IaC) best practices and frameworks like [GitOps](/azure/architecture/example-scenario/gitops-aks/gitops-blueprint-aks) to provision and maintain their clusters. They use monitoring tools like Azure Monitor managed service for Prometheus and Azure Managed Grafana to monitor overall cluster health. They're responsible for patching, cluster upgrades, permissions, and role-based access control (RBAC) on the cluster. In DevSecOps teams, cluster operators collaborate with security teams to establish security standards and ensure that clusters meet those requirements.

### Security team

The security team develops and enforces security standards. Some teams might create and select Azure Policy definitions that you enforce across the subscriptions and resource groups that contain the clusters. Security teams monitor security problems and work with other teams to prioritize security throughout the DevSecOps process.

## DevSecOps life cycle stages

Each phase of the software development life cycle (SDLC) implements security controls. This implementation is a key piece of a DevSecOps strategy and of the shift-left approach.

:::image type="complex" alt-text="Architecture diagram shows the flow from the developer to the user and where DevSecOps can be employed, DevSecOps on AKS." source="./media/devsecops-stages.svg" lightbox="./media/devsecops-stages.svg":::
At the center is a hub labeled security, which connects to each phase of the cycle. Five stages surround this central point arranged in a loop: plan, develop, build, release, and operate. Each stage includes examples of security practices that apply to that phase. Threat modeling, security policies, and Azure Well-Architected Framework practices occur during planning. Secure coding standards and integrated development environment (IDE) security plugins occur during development. Static application security testing (SAST), software composition analysis (SCA), and secrets scanning occurs during build, dynamic application security testing (DAST), penetration testing, and workflow approvals occur during release, and logging, alerting, SIEM, and network monitoring occur during operation. Arrows connect the stages in sequence to show a continuous flow, and connections link each stage back to the central security function.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/devsecops-stages.vsdx) of this architecture.*

### Plan phase

The plan phase usually has the least amount of automation, but it has important security implications that significantly affect later DevOps life cycle stages. This phase involves collaboration between security, development, and operations teams. To ensure that you account for or mitigate security requirements and security problems, include security stakeholders in this phase.

#### Best practice: Design a secure application platform

Build a secure AKS-hosted platform to incorporate security into the system at every layer, starting with the platform itself. The platform can include components internal to the cluster, such as runtime security and policy agents, and components external to AKS, such as network firewalls and container registries.

#### Best practice: Build threat modeling into your process

- Threat modeling is usually a manual activity that involves security and development teams. You can model and find threats within a system to address vulnerabilities before you do code development or make changes. Teams conduct threat modeling in response to significant software changes, solution architectural changes, or security incidents.

- We recommend the [STRIDE threat model](/azure/security/develop/threat-modeling-tool-threats#stride-model). This methodology starts with a data flow diagram and categorizes threats by using the STRIDE mnemonic: Spoofing, Tampering, Info Disclosure, Repudiation, Denial of Service, and Elevation of Privilege. Teams use these categories to identify, mitigate, and validate risks. A [modeling tool](https://www.microsoft.com/securityengineering/sdl/threatmodeling) helps notate and visualize system components, data flows, and security boundaries.

  Building threat modeling into your SDLC adds process overhead and requires maintaining updated threat models. However, it addresses security early in development, which reduces the cost of fixing problems discovered later.

#### Best practice: Apply the Azure Well-Architect Framework

- Apply [Security](/azure/well-architected/security/checklist) best practices that provide guidance identity management, application security, infrastructure protection, data security, and DevOps as it applies to cloud-native environments.

- Apply [WAF operational](/azure/well-architected/operational-excellence/checklist) best practices as it applies to DevSecOps and monitoring of your production environments.

### Develop phase

*Shifting left* is a key tenet of the DevSecOps mindset. This process begins before you commit code into a repository and deploy it via a pipeline. To address security problems earlier in the development life cycle, adopt secure coding best practices and use integrated development environment (IDE) tools and plugins for code analysis during the development phase.

#### Best practice: Enforce secure coding standards

- Use established secure coding best practices and checklists to help protect your code from common vulnerabilities like injection and insecure design. The [Open Worldwide Application Security Project (OWASP)](https://owasp.org/www-project-secure-coding-practices-quick-reference-guide/) foundation publishes industry standard secure coding recommendations that you should adopt when you write code. These guidelines are especially important when you develop public-facing web applications or services.

- Review secure coding practices for your specific programming language runtimes, like [Java](https://www.oracle.com/java/technologies/javase/seccodeguide.html) and .NET.

- Enforce logging standards to protect sensitive information from leaking into application logs. Most popular logging frameworks, like Apache Log4j and Apache log4net, provide filters and plugins to mask sensitive information, like account numbers or personal data.

#### Best practice: Use IDE tools and plugins to automate security checks

Most popular integrated development environments (IDEs), like Visual Studio, Visual Studio Code, IntelliJ IDEA, and Eclipse, support extensions that you can use to get immediate feedback and recommendations for potential security problems that you introduce while you write application code.

- [SonarQube for IDE](https://www.sonarsource.com/products/sonarqube/ide/) is an IDE plugin for most popular languages and developer environments. SonarQube for IDE provides feedback and automatically scans your code for common programming errors and potential security problems.

- Other free and commercial plugins focus on security-specific items, like the OWASP top 10 common vulnerabilities. The [Snyk](https://snyk.io/platform/ide-plugins/) plugin, for example, also scans your application source and external dependencies and alerts you if it finds vulnerabilities.

- The [Static Analysis Results Interchange Format (SARIF)](https://github.com/microsoft/sarif-vscode-extension) plugin for Visual Studio and Visual Studio Code lets you easily view vulnerabilities from popular Static Application Security Testing (SAST) tools versus interpreting results from raw JSON output files.

#### Best practice: Establish controls on your source code repositories

- Establish a branching methodology for consistency across your enterprise. Methodologies like [Release flow](/devops/develop/how-microsoft-develops-devops) and [GitHub flow](https://docs.github.com/get-started/quickstart/github-flow) have structured guidelines about how to use branches to support team and parallel development. These methodologies can help teams establish standards and controls for code commits and merges into your CI/CD workflow.

  Certain branches, such as main, are long-lasting branches that preserve the integrity of your application's source code. Establish merge policies for these branches before you commit or merge changes. Some best practices include:

  - Prevent other developers from committing code directly into your main branch.

  - Establish a peer review process and require a minimum number of approvals before you can merge changes to a main branch. Configure and enforce these controls by using GitHub. Use GitHub to designate groups of authorized approvers if necessary for gated environments.

- Use [precommit hooks](https://github.com/pre-commit/pre-commit-hooks) to check for sensitive information in your application source code and block commits when they detect security problems.

  - Use GitHub-provided, built-in precommit hooks. Easily configure them for specific projects. For example, some prebuilt hooks scan for secrets, private keys, and credentials and block a commit if they find these problems.

- Establish RBAC within your version control system.

  - Create well-defined roles by using the principle of least privilege. A CI/CD pipeline functions as your supply chain for production deployments.

  - Apply established user or group [roles](https://docs.github.com/enterprise-cloud@latest/admin/user-management/managing-users-in-your-enterprise/roles-in-an-enterprise) within your organization. To group individuals based on their specific role and function in your CI/CD workflows, create roles like Admin, Developer, Security admin, and Operator.

- Enable [auditing](https://docs.github.com/enterprise-cloud@latest/admin/monitoring-activity-in-your-enterprise/reviewing-audit-logs-for-your-enterprise/about-the-audit-log-for-your-enterprise) of your workflows to add transparency and traceability for configuration and other changes to your CI/CD pipelines.

#### Best practice: Secure your container images

- Use lightweight images that have a minimal OS footprint to reduce the overall surface-attack area. Consider minimal images like Alpine or even distroless images that contain only your application and its associated runtime.

- Use only trusted base images when you build your containers. Retrieve these base images from a private registry that you frequently scan for vulnerabilities.

- Use developer tools to evaluate image vulnerabilities locally. [Trivy](https://trivy.dev/) is an open-source tool that analyzes security vulnerabilities within your container images.

- Prevent root user access or context for an image. By default, containers run as root.

   For containers that need enhanced security, consider using an [AppArmor](/azure/aks/secure-container-access?pivots=apparmor#configure-an-apparmor-profile) or [seccomp](/azure/aks/secure-container-access?pivots=seccomp#configure-a-custom-seccomp-profile) profile within your Kubernetes cluster to further help enforce security for your running containers.

### Build phase

During the build phase, developers work with site reliability engineers and security teams to integrate automated scans of their application source within their CI build pipelines. Teams configure the pipelines to enable security practices by using the CI/CD platform's security tools and extensions. These practices include SAST, software composition analysis (SCA), and secrets scanning.

#### Best practice: Perform SAST to find potential vulnerabilities in your application source code

- Use GitHub Advanced Security scanning capabilities for code scanning and CodeQL.

  - [Code scanning](https://docs.github.com/enterprise-cloud@latest/code-security/code-scanning/automatically-scanning-your-code-for-vulnerabilities-and-errors/about-code-scanning) is a feature that analyzes code in a GitHub repository to find security vulnerabilities and coding errors. It displays the problems in GitHub Enterprise Cloud.
  
  - If code scanning finds a potential vulnerability or error in your code, GitHub displays an alert in the repository.

  - You can configure branch rules for [required status checks](https://docs.github.com/repositories/configuring-branches-and-merges-in-your-repository/defining-the-mergeability-of-pull-requests/troubleshooting-required-status-checks). For example, you can require that feature branches are up to date with the base branch before you merge new code. This requirement ensures that you test your branch with the latest code.

  - Enable [Copilot Autofix](https://docs.github.com/enterprise-cloud@latest/code-security/code-scanning/managing-code-scanning-alerts/responsible-use-autofix-code-scanning) to receive AI-generated fix suggestions for code scanning alerts. Copilot Autofix proposes remediation directly in pull requests, which helps developers resolve security findings quickly.

- Use tools like [kube-score](https://kube-score.com/) to analyze your Kubernetes deployment objects. kube-score does static code analysis of your Kubernetes object definitions. It outputs a list of recommendations to make your application more secure and resilient.

#### Best practice: Use secret scanning to detect accidentally committed secrets

- When you enable [secret scanning](https://docs.github.com/enterprise-cloud@latest/code-security/secret-scanning/about-secret-scanning#about-secret-scanning-for-advanced-security) for a repository, GitHub scans the code for patterns that match secrets that many service providers use.

- GitHub periodically runs a full git history scan of existing content in repositories and sends alert notifications.

  - For Azure DevOps, [Microsoft Defender for Cloud](/azure/defender-for-cloud/detect-credential-leaks) uses secret scanning to detect credentials, secrets, certificates, and other sensitive content in your source code and build output.

  - You can run secret scanning as part of the Microsoft Security DevOps for Azure DevOps extension.

#### Best practice: Use SCA tools to track open-source components in the codebase and detect vulnerabilities in dependencies

- [Dependency review](https://docs.github.com/code-security/supply-chain-security/understanding-your-software-supply-chain/about-dependency-review) lets you catch insecure dependencies before you introduce them to your environment. It also provides information about the license, dependents, and age of dependencies. It displays dependency changes through a rich diff on the **Files Changed** tab of a pull request.

- [Dependabot](https://docs.github.com/enterprise-cloud@latest/code-security/dependabot/dependabot-alerts/about-dependabot-alerts) performs a scan to detect insecure dependencies and sends Dependabot alerts when a new advisory is added to the GitHub Advisory Database or when dependency graph for a repository changes.

#### Best practice: Generate a SBOM for your container images

- A software bill of materials (SBOM) provides a complete inventory of the components, libraries, and dependencies that make up your container images. Use SBOM generation tools like [Microsoft sbom-tool](https://github.com/microsoft/sbom-tool) or [Syft](https://github.com/anchore/syft) during the CI build to produce an SPDX or CycloneDX manifest.

- Attach an SBOM to your container images stored in [Container Registry](/azure/security/container-secure-supply-chain/articles/attach-sbom) to enable downstream vulnerability scanning and license compliance tracking across the supply chain.

#### Best practice: Scan IaC templates to detect misconfigurations before deployment

- Proactively monitor cloud resource configurations throughout the development life cycle.

- [Microsoft Defender for DevOps](/azure/defender-for-cloud/iac-vulnerabilities) supports both GitHub and Azure DevOps repositories.

#### Best practice: Scan your workload images in container registries to identify known vulnerabilities

- [Defender for Containers](/azure/defender-for-cloud/defender-for-containers-introduction#hardening) scans the containers in Container Registry and Amazon AWS Elastic Container Registry (ECR) to notify you of known vulnerabilities in your images.

- You can enable [Azure Policy](/azure/container-registry/container-registry-azure-policy) to do a vulnerability assessment on all images stored in Container Registry and provide detailed information about each finding.

#### Best practice: Build new images on base image updates automatically

- [Container Registry Tasks](/azure/container-registry/container-registry-tasks-base-images) dynamically discovers base image dependencies when it builds a container image. When it detects an update to an application image's base image, you can configure a build task to automatically rebuild all application images that reference that base image.

#### Best practice: Use Container Registry, Key Vault, and notation to digitally sign your container images and configure AKS cluster to only allow validated images

- Key Vault stores signing keys that the [notation](/azure/container-registry/container-registry-tutorial-sign-build-push) tool uses. The notation Key Vault plugin (azure-kv) accesses these keys to [sign](/azure/container-registry/container-registry-tutorial-sign-build-push) and verify container images and other artifacts. You can attach these signatures to Container Registry images by using Azure CLI commands.

- Signed containers ensure that deployments come from a trusted source and that artifacts aren't tampered with after creation. The signed artifact ensures integrity and authenticity before the user pulls an artifact into any environment, which helps avoid attacks.

  - [Ratify](https://github.com/notaryproject/ratify/blob/main/README.md) verifies artifact security metadata and enforces admission policies before deployment to Kubernetes clusters. [AKS Image Integrity](/azure/aks/image-integrity) uses Ratify as a built-in verifier to validate image signatures and SBOM attestations before pods are admitted to the cluster.

### Deploy phase

During the deployment phase, developers, application operators, and cluster operator teams work together to establish the right security controls for the CD pipelines. These controls help deploy code to a production environment in a secure and automated manner.

#### Best practice: Control the access and workflow of the deployment pipeline

- You can [protect](https://docs.github.com/repositories/configuring-branches-and-merges-in-your-repository/defining-the-mergeability-of-pull-requests/about-protected-branches) important branches by setting branch protection rules. These rules define whether collaborators can delete or force push to the branch. They also set requirements for pushes to the branch, such as passing status checks or a linear commit history.

- Use [environments](https://docs.github.com/actions/deployment/targeting-different-environments/using-environments-for-deployment) for deployment to configure protection rules and secrets.

- You can take advantage of the [approvals](https://docs.github.com/actions/managing-workflow-runs/reviewing-deployments) and [gates](/azure/devops/pipelines/release/deploy-using-approvals) feature to control the workflow of the deployment pipeline. For example, you can require manual approvals from a security or operations team before you deploy to a production environment.

#### Best practice: Secure deployment credentials

- [OpenID Connect (OIDC)](https://docs.github.com/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-azure) lets your GitHub Action workflows access resources in Azure without needing to store the Azure credentials as long-lived GitHub secrets.

- Use a pull-based approach to CI/CD with [GitOps](/azure/architecture/guide/aks/aks-cicd-github-actions-and-gitops) to shift security credentials to your Kubernetes cluster. This approach reduces the security and risk surface by removing credentials from your external CI tooling. You can also reduce allowed inbound connections and limit admin-level access to your Kubernetes clusters.

#### Best practice: Run DAST to find vulnerabilities in your running application

- Use GitHub [Actions](https://github.com/marketplace?category=testing&type=actions&query=) in deployment workflows to run dynamic application security testing (DAST) tests.

- Use open-source tools such as [ZAP](https://www.zaproxy.org/) to do penetration testing for common web application vulnerabilities.

#### Best practice: Deploy container images from trusted registries only

- Use [Defender for Containers](/azure/defender-for-cloud/kubernetes-workload-protections) to enable the Azure Policy add-on for Kubernetes.

- Configure Azure Policy to restrict container image deployments to trusted registries.

### Operate phase

During this phase, perform operation monitoring and security monitoring tasks to proactively monitor, analyze, and alert on potential security incidents. Use production observability tools like Azure Monitor and Microsoft Sentinel to monitor and ensure compliance with enterprise security standards.

#### Best practice: Use Defender for Cloud to automatically scan and monitor your production configurations

- Run continual scanning to detect drift in the vulnerability state of your application and implement a process to patch and replace the vulnerable images.

- Implement automated configuration monitoring for operating systems.

  - Use the container recommendations in Defender for Cloud (under **Compute and apps**) to perform baseline scans for your AKS clusters. Defender for Cloud displays any configuration problems or vulnerabilities in its dashboard.

  - Use Defender for Cloud and follow its network protection recommendations to help [secure](/azure/defender-for-cloud/protect-network-resources) the network resources that your AKS clusters use.

- Conduct a vulnerability assessment for images stored in Container Registry.

  - Implement continuous scans for running images in Container Registry by enabling [Defender for Containers](/azure/defender-for-cloud/defender-for-containers-vulnerability-assessment-azure).

#### Best practice: Keep your Kubernetes clusters updated

- Kubernetes releases new versions frequently. Maintain a life cycle management strategy to keep your clusters supported and up-to-date. AKS provides tools to manage cluster upgrades. Use the AKS planned maintenance features to control when maintenance windows and upgrades occur.

- [Upgrade](/azure/architecture/operator-guides/aks/aks-upgrade-practices) AKS worker nodes frequently. Azure releases weekly OS and runtime updates. Apply these updates automatically through unattended mode or manually through the Azure CLI for greater control.

#### Best practice: Use Azure Policy to secure and govern your AKS clusters

- After you install the [Azure Policy add-on for AKS](/azure/aks/use-azure-policy), you can apply individual policy definitions or groups of policy definitions called initiatives or policy sets to your cluster.

- Use [built-in Azure policies](/azure/aks/policy-reference) for common scenarios like preventing privileged containers from running or restricting external IP addresses to an allow list. You can also create custom policies for specific use cases.

- Apply policy definitions to your cluster and verify that Azure Policy enforces those assignments.

- Use Gatekeeper to configure an admission controller that allows or denies deployments based on rules specified. Azure Policy extends Gatekeeper.

- Secure traffic between workload pods by using network policies in AKS.

  - Use [Azure CNI Powered by Cilium](/azure/aks/azure-cni-powered-by-cilium) as the network policy engine. Cilium uses an eBPF-based data plane and supports Kubernetes-native policies, layer-7 policy, and FQDN filtering.

#### Best practice: Use Azure Monitor for continuous monitoring and alerting

- Use [Azure Monitor](/azure/azure-monitor/containers/kubernetes-monitoring-enable) to collect logs and metrics from AKS. Collect Prometheus metrics via [Azure Monitor managed service for Prometheus](/azure/azure-monitor/essentials/prometheus-metrics-overview), query container and platform logs in [Log Analytics](/azure/azure-monitor/logs/log-analytics-overview), and visualize cluster health through [Azure Managed Grafana](/azure/managed-grafana/overview) dashboards.

  - Azure Monitor extends continuous monitoring to release pipelines. Use monitoring data to approve or roll back releases. Azure Monitor also ingests security logs and alerts on suspicious activity.

  - Onboard your AKS instances to Azure Monitor and configure diagnostic settings for your cluster.

    - For more information, see [Azure security baseline for AKS](/security/benchmark/azure/baselines/aks-security-baseline).

#### Best practice: Use Defender for Cloud for active threat monitoring

- Defender for Cloud provides active threat monitoring for AKS at the node level (VM threats) and cluster workloads.

- Use Defender for DevOps to gain comprehensive visibility across all CI/CD pipelines. It provides security and operator teams with a centralized dashboard. You benefit especially from this centralized visibility when you use multiple-pipeline platforms like Azure DevOps and GitHub or run pipelines across public clouds.

- Defender for Key Vault detects unusual and suspicious attempts to access key vault accounts and can send alerts to administrators based on configuration.

- Defender for Containers can alert on vulnerabilities found within your container images stored in Container Registry.

#### Best practice: Enable centralized log monitoring and use SIEM products to monitor for real-time security threats

- Connect AKS diagnostics logs to Microsoft Sentinel for centralized security monitoring based on patterns and rules. Microsoft Sentinel enables this access by way of [data connectors](/azure/sentinel/data-connectors-reference#azure-kubernetes-service-aks).

#### Best practice: Enable audit logging to monitor activity on your production clusters

- Use activity logs to monitor actions on AKS resources to view all activity and their status. Determine who performed what operations on the resources.

- Enable [Domain Name System (DNS) query logging](/azure/aks/coredns-custom) by applying documented configuration in your CoreDNS custom ConfigMap.

- Monitor attempts to access deactivated credentials.

  - Integrate user authentication for AKS with Microsoft Entra ID. Create diagnostic settings for Microsoft Entra ID and [send](/entra/identity/monitoring-health/howto-integrate-activity-logs-with-azure-monitor-logs) the audit and sign-in logs to a Log Analytics workspace. Within the Log Analytics workspace, configure alerts for security events, such as sign-in attempts from deactivated accounts.

#### Best practice: Enable diagnostics on your Azure resources

- Enable Azure diagnostics across all of your workload's resources to access platform logs that provide detailed diagnostic and auditing information. You can ingest these logs into Log Analytics or a SIEM solution like Microsoft Sentinel for security monitoring and alerting.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Adnan Khan](https://www.linkedin.com/in/adnan-khan-04311939/) | Sr. Cloud Solution Architect

Other contributors:

- [Ayobami Ayodeji](https://www.linkedin.com/in/ayobamiayodeji/) | Program Manager 2
- [Ahmed Bham](https://www.linkedin.com/in/ahmedbham-solutionsarchitect/) | Sr. Cloud Solution Architect
- [Chad Kittel](https://www.linkedin.com/in/chadkittel/) | Principal Software Engineer - Azure Patterns & Practices
- [John Poole](https://www.linkedin.com/in/johnrpoole/) | Sr. Cloud Solution Architect
- [Bahram Rushenas](https://www.linkedin.com/in/bahram-rushenas-306b9b3/) | Sr. Solution Architect
- [Abed Sau](https://www.linkedin.com/in/abed-sau/) | Sr. Cloud Solution Architect

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Defender for Containers](/azure/defender-for-cloud/defender-for-containers-introduction)
- [Secure DevOps](https://www.microsoft.com/securityengineering/devsecops)
- [Security in DevOps (DevSecOps)](/devops/operate/security-in-devops)
- [GitHub Advanced Security](https://docs.github.com/enterprise-cloud@latest/get-started/learning-about-github/about-github-advanced-security)

## Related resources

- [GitOps](../../example-scenario/gitops-aks/gitops-blueprint-aks.yml)
- [DevSecOps for IaC](../../solution-ideas/articles/devsecops-infrastructure-as-code.yml)
- [Shift left](https://devops.com/devops-shift-left-avoid-failure)
