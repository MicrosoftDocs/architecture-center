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

:::image type="complex" alt-text="Architecture diagram shows the flow from the developer to the end user and where DevSecOps can be employed, DevSecOps on AKS." source="./media/devsecops-azure-aks.svg" lightbox="./media/devsecops-azure-aks.svg":::

:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/devsecops-azure-aks.vsdx) of this architecture.*

> [!NOTE]
> This article references AKS and GitHub, but you can apply these recommendations to any container orchestration or CI/CD platform. The implementation details might vary, but most concepts and practices for each stage still apply.

1. [Microsoft Entra ID](/entra/fundamentals/whatis) is configured as the identity provider for GitHub. Configure multifactor authentication (MFA) to help provide extra authentication security.

1. Developers use [Visual Studio Code](https://code.visualstudio.com) or [Visual Studio](https://visualstudio.microsoft.com/vs/) with [security extensions](#best-practice--use-ide-tools-and-plugins-to-automate-security-checks) enabled to proactively analyze their code for security vulnerabilities.

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

Building applications on the cloud by using containers and Kubernetes can simplify application development, deployment, and scalability. But these development approaches also create increasingly distributed environments that complicate administration. Site reliability engineers build solutions to automate the oversight of large software systems. They serve as a bridge between development and cluster operator teams and help establish and monitor service-level objectives and error budgets. In this way, they help manage application deployments and often write Kubernetes manifest (YAML) files.

### Cluster operators

Cluster operators configure and manage the cluster infrastructure. They often use infrastructure as code (IaC) best practices and frameworks like [GitOps](/azure/architecture/example-scenario/gitops-aks/gitops-blueprint-aks) to provision and maintain their clusters. They use monitoring tools like Azure Monitor managed service for Prometheus and Azure Managed Grafana to monitor overall cluster health. They're responsible for patching, cluster upgrades, permissions, and role-based access control on the cluster. In DevSecOps teams, they ensure that the clusters meet the security requirements of the team, and they work with the security team to create those standards.

### Security team

The security team is responsible for developing security standards and enforcing them. Some teams might be responsible for creating and selecting Azure Policy that's enforced in the subscriptions and resource groups holding the clusters. They monitor security problems, and together with the other teams, ensure that security is brought to the forefront of every step of the DevSecOps process.

## DevSecOps life cycle stages

Security controls are implemented in each phase of the software development life cycle (SDLC). This implementation is a key piece of a DevSecOps strategy and of the shift-left approach.

:::image type="content" alt-text="Architecture diagram shows the flow from the developer to the end user and where DevSecOps can be employed, DevSecOps on AKS." source="./media/devsecops-stages.png" lightbox="./media/devsecops-stages.png":::

*Download a [Visio file](https://arch-center.azureedge.net/devsecops-stages.vsdx) of this architecture.*

### Plan phase

The plan phase usually has the least amount of automation, but it has important security implications that significantly affect later DevOps life cycle stages. This phase involves collaboration between security, development, and operations teams. Including security stakeholders in this phase of designing and planning ensures security requirements and security issues are appropriately accounted for or mitigated.

#### Best Practice – Design a more secure application platform

Building a more secure AKS-hosted platform is an important step to help ensure security is built into the system at every layer, starting with the platform itself. The platform can include components both internal to the cluster (such as runtime security and policy agents) and components that are external to AKS (such as network firewalls and container registries).

#### Best Practice – Build threat modeling into your process

- Threat modeling is usually a manual activity that involves security and development teams. It's used to model and find threats within a system so that vulnerabilities can be addressed before any code development or changes to a system. Threat modeling can occur at different times, triggered by events such as a significant software change, solution architectural change, or security incidents.

- We recommend you use the [STRIDE threat model](/azure/security/develop/threat-modeling-tool-threats#stride-model). This methodology starts with a data-flow diagram and uses the STRIDE mnemonic (Spoofing, Tampering, Info Disclosure, Repudiation, Denial of Service, and Elevation of Privilege) threat categories to empower teams to identify, mitigate, and validate risk. It also includes a [modeling tool](https://www.microsoft.com/securityengineering/sdl/threatmodeling) to notate and visualize system components, data flows, and security boundaries. Building threat modeling into your SDLC processes introduces new processes and more work to maintain updated threat models. But it helps ensure security is in place early, which helps reduce the potential cost of dealing with security issues found in later SDLC stages.

#### Best Practice – Apply Azure Well-Architect Framework

- Apply [Security](/azure/well-architected/security/checklist) best practices that provide guidance for things like identity management, application security, infrastructure protection, data security, and DevOps as it applies to cloud native environments.

- Apply [WAF operational](/azure/well-architected/operational-excellence/checklist) best practices as it applies to DevSecOps and monitoring of your production environments.

### Develop phase

"Shifting left" is a key tenent of the DevSecOps mindset. This process begins before code is even committed into a repository and deployed via a pipeline. Adopting secure coding best practices and using IDE tools and plugins for code analysis during the development phase can help address security issues earlier in the development life cycle when they're easier to fix.

#### Best Practice – Enforce secure coding standards

- By using established secure coding best practices and checklists, you can help protect your code from common vulnerabilities like injection and insecure design. The [OWASP](https://owasp.org/www-project-secure-coding-practices-quick-reference-guide/) foundation publishes industry standard secure coding recommendations that you should adopt when writing code. These guidelines are especially important when developing public-facing web applications or services.

- In addition to general security best practices, you should also review secure coding practices for your specific programming language runtimes, like [Java](https://www.oracle.com/java/technologies/javase/seccodeguide.html) and .NET.

- You can enforce logging standards to protect sensitive information from being leaked into application logs. Most popular logging frameworks, like log4j and log4net, provide filters and plugins to mask sensitive information like account numbers or personal data.

#### Best practice – Use IDE tools and plugins to automate security checks

Most popular IDEs, like Visual Studio, Visual Studio Code, IntelliJ IDEA, and Eclipse, support extensions that you can use to get immediate feedback and recommendations for potential security issues you might have introduced while writing application code.

- [SonarQube for IDE](https://www.sonarsource.com/products/sonarqube/ide/) is an IDE plugin available for most popular languages and developer environments. SonarQube for IDE provides valuable feedback and automatically scans your code for common programming errors and potential security issues.

- Other free and commercial plugins are focused on security specific items, like the OWASP top 10 common vulnerabilities. The [Snyk](https://snyk.io/platform/ide-plugins/) plugin, for example, also scans your application source and third-party dependencies and alerts you if any vulnerabilities are found.

- The [Static Analysis Results Interchange Format (SARIF)](https://github.com/microsoft/sarif-vscode-extension) plugin for Visual Studio and Visual Studio Code lets you easily view vulnerabilities from popular Static Application Security Testing (SAST) tools in an intuitive and easy to read manner versus interpreting results from raw JSON output files.

#### Best practice – Establish controls on your source code repositories

- Establish a branching methodology so there's consistent use of branching across the enterprise. Methodologies like [Release flow](/devops/develop/how-microsoft-develops-devops) and [GitHub flow](https://docs.github.com/get-started/quickstart/github-flow) have structured guidelines on how branches should be used to support team and parallel development. These methodologies can help teams establish standards and controls for code commits and merges into your CI/CD workflow.- Certain branches, such as main, are long-lasting branches that preserve the integrity of your application’s source code. These branches should have established merge policies before changes can be merged or committed into them. Some best practices include:

  - Prevent other developers from committing code directly into your main branch.

  - Establish a peer review process and require a minimum number of approvals before changes can be merged to a main branch. You can easily configure and enforce these controls with GitHub. GitHub also lets you designate groups of authorized approvers if necessary for gated environments.

- Use [pre-commit hooks](https://github.com/pre-commit/pre-commit-hooks) to check for sensitive information within your application source code and prevent a commit from happening if a security issue is found.

  - Use the GitHub-provided, built-in pre-commit hooks that can be easily configured for a specific project. For example, there are pre-built hooks to scan for secrets, private keys, and credentials, and prevent a commit if any of these issues are found.

- Establish role-based access control within your version control system.

  - Create well-defined roles by using the principle of least privileges. A CI/CD pipeline is your supply chain for production deployments.

  - Apply established user or group [roles](https://docs.github.com/enterprise-cloud@latest/admin/user-management/managing-users-in-your-enterprise/roles-in-an-enterprise) within your organization. Roles like Admin, Developer, Security admin, and Operator must be created to group individuals based on their specific role and function regarding your CI/CD workflows.

- Enable [auditing](https://docs.github.com/enterprise-cloud@latest/admin/monitoring-activity-in-your-enterprise/reviewing-audit-logs-for-your-enterprise/about-the-audit-log-for-your-enterprise) of your workflows so there's transparency and traceability for configuration and other changes with respect to your CI/CD pipelines.

#### Best practice – Secure your container images

- Use lightweight images with a minimal OS footprint to reduce the overall surface-attack area. Consider minimal images like Alpine or even distroless images that only contain your application and its associated runtime.

- Use only trusted base images when building your containers. These base images should be retrieved from a private registry that is frequently scanned for vulnerabilities.

- Use developer tools to evaluate image vulnerabilities locally.

  - [Trivy](https://trivy.dev/) is an example of an open-source tool that you can use to analyze security vulnerabilities within your container images.

- Prevent root user access/context for an image. By default, containers run as root.

  - For containers that need enhanced security, consider using an [AppArmor](/azure/aks/secure-container-access?pivots=apparmor#configure-an-apparmor-profile) or [seccomp](/azure/aks/secure-container-access?pivots=seccomp#configure-a-custom-seccomp-profile) profile within your Kubernetes cluster to further help enforce security for your running containers.

### Build phase

During the build phase, developers work with the site reliability engineers and security teams to integrate automated scans of their application source within their CI build pipelines. The pipelines are configured to enable security practices such as SAST, SCA, and secrets scanning by using the CI/CD platform’s security tools and extensions.

#### Best practice – Perform Static Code Analysis (SAST) to find potential vulnerabilities in your application source code

- Use GitHub Advanced Security scanning capabilities for code scanning and CodeQL.

  - [Code scanning](https://docs.github.com/enterprise-cloud@latest/code-security/code-scanning/automatically-scanning-your-code-for-vulnerabilities-and-errors/about-code-scanning) is a feature that you use to analyze the code in a GitHub repository to find security vulnerabilities and coding errors. Any problems identified by the analysis are shown in GitHub Enterprise Cloud.
  
  - If code scanning finds a potential vulnerability or error in your code, GitHub displays an alert in the repository.

  - You can also configure branch rules for [required status checks](https://docs.github.com/repositories/configuring-branches-and-merges-in-your-repository/defining-the-mergeability-of-pull-requests/troubleshooting-required-status-checks), for example, to enforce that a feature branch is up to date with the base branch before merging any new code. This practice ensures that your branch has always been tested with the latest code.

  - Enable [Copilot Autofix](https://docs.github.com/enterprise-cloud@latest/code-security/code-scanning/managing-code-scanning-alerts/responsible-use-autofix-code-scanning) to receive AI-generated fix suggestions for code scanning alerts. Copilot Autofix proposes remediation directly in pull requests, which helps developers resolve security findings faster.

- Use tools like [kube-score](https://kube-score.com/) to analyze your Kubernetes deployment objects.

  - kube-score is a tool that does static code analysis of your Kubernetes object definitions.

  - The output is a list of recommendations of what you can improve to help make your application more secure and resilient.

#### Best practice – Perform secret scanning to prevent the fraudulent use of secrets that were committed accidentally to a repository

- When [secret scanning](https://docs.github.com/enterprise-cloud@latest/code-security/secret-scanning/about-secret-scanning#about-secret-scanning-for-advanced-security) is enabled for a repository, GitHub scans the code for patterns that match secrets used by many service providers.

- GitHub also periodically runs a full git history scan of existing content in repositories and sends alert notifications.

  - For Azure DevOps, [Defender for Cloud](/azure/defender-for-cloud/detect-credential-leaks) uses secret scanning to detect credentials, secrets, certificates, and other sensitive content in your source code and your build output.

  - Secret scanning can be run as part of the Microsoft Security DevOps for Azure DevOps extension.

#### Best practice – Use software composition analysis (SCA) tools to track open-source components in the codebase and detect any vulnerabilities in dependencies

- [Dependency review](https://docs.github.com/code-security/supply-chain-security/understanding-your-software-supply-chain/about-dependency-review) lets you catch insecure dependencies before you introduce them to your environment, and provides information on license, dependents, and age of dependencies. It provides an easily understandable visualization of dependency changes with a rich diff on the "Files Changed" tab of a pull request.

- [Dependabot](https://docs.github.com/enterprise-cloud@latest/code-security/dependabot/dependabot-alerts/about-dependabot-alerts) performs a scan to detect insecure dependencies and sends Dependabot alerts when a new advisory is added to the GitHub Advisory Database or when dependency graph for a repository changes.

#### Best practice – Generate a software bill of materials (SBOM) for your container images

- An SBOM provides a complete inventory of the components, libraries, and dependencies that make up your container images. Use SBOM generation tools like [Microsoft sbom-tool](https://github.com/microsoft/sbom-tool) or [Syft](https://github.com/anchore/syft) during the CI build to produce an SPDX or CycloneDX manifest.

- Attaching an SBOM to your container images stored in [Container Registry](/azure/security/container-secure-supply-chain/articles/attach-sbom) enables downstream vulnerability scanning and license compliance tracking across the supply chain.

#### Best practice – Enable security scans of IaC templates to minimize cloud misconfigurations reaching production environments

- Proactively monitor cloud resource configurations throughout the development life cycle.

- [Microsoft Defender](/azure/defender-for-cloud/iac-vulnerabilities) for DevOps supports both GitHub and Azure DevOps repositories.

#### Best practice – Scan your workload images in container registries to identify known vulnerabilities

- [Defender for Containers](/azure/defender-for-cloud/defender-for-containers-introduction#hardening) scans the containers in Container Registry and Amazon AWS Elastic Container Registry (ECR) to notify you if there are known vulnerabilities in your images.

- [Azure Policy](/azure/container-registry/container-registry-azure-policy) can be enabled to do a vulnerability assessment on all images stored in Container Registry and provide detailed information on each finding.

#### Best practice – Automatically build new images on base image update

- [Container Registry Tasks](/azure/container-registry/container-registry-tasks-base-images) dynamically discovers base image dependencies when it builds a container image. As a result, it can detect when an application image's base image is updated. With one preconfigured build task, Container Registry tasks can automatically rebuild every application image that references the base image.

#### Best practice – Use Container Registry, Key Vault and notation to digitally sign your container images and configure AKS cluster to only allow validated images

- Key Vault stores a signing key that can be used by [notation](/azure/container-registry/container-registry-tutorial-sign-build-push) with the notation Key Vault plugin (azure-kv) to [sign](/azure/container-registry/container-registry-tutorial-sign-build-push) and verify container images and other artifacts. Container Registry lets you attach these signatures by using the Azure CLI commands.

- The signed containers let users make sure that deployments are built from a trusted entity and verify an artifact hasn't been tampered with since its creation. The signed artifact ensures integrity and authenticity before the user pulls an artifact into any environment, which helps avoid attacks.

  - [Ratify](https://github.com/notaryproject/ratify/blob/main/README.md) lets Kubernetes clusters verify artifact security metadata before deployment and admit for deployment only those that comply with an admission policy that you create. [AKS Image Integrity](/azure/aks/image-integrity) uses Ratify as a built-in verifier to validate image signatures and SBOM attestations before pods are admitted to the cluster.

### Deploy phase

During the deployment phase, developers, application operators, and cluster operator teams work together on establishing the right security controls for the continuous deployment (CD) pipelines to deploy code to a production environment in a more secure and automated manner.

#### Best practice – Control the access and workflow of the deployment pipeline

- You can [protect](https://docs.github.com/repositories/configuring-branches-and-merges-in-your-repository/defining-the-mergeability-of-pull-requests/about-protected-branches) important branches by setting branch protection rules. These rules define whether collaborators can delete or force push to the branch. They also set requirements for any pushes to the branch, such as passing status checks or a linear commit history.

- By using [environments](https://docs.github.com/actions/deployment/targeting-different-environments/using-environments-for-deployment) for deployment, you can configure environments with protection rules and secrets.

- You can take advantage of the [Approvals](https://docs.github.com/actions/managing-workflow-runs/reviewing-deployments) and [Gates](/azure/devops/pipelines/release/deploy-using-approvals?view=azure-devops) feature to control the workflow of the deployment pipeline. For example, you can require manual approvals from a security or operations team before a deployment to a production environment.

#### Best practice – Secure deployment credentials

- [OpenID Connect (OIDC)](https://docs.github.com/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-azure) lets your GitHub Action workflows access resources in Azure without needing to store the Azure credentials as long-lived GitHub secrets.

- By using environments for deployment, you can configure environments with protection rules and secrets.

  - A pull-based approach to CI/CD with [GitOps](/azure/architecture/guide/aks/aks-cicd-github-actions-and-gitops) lets you shift security credentials to your Kubernetes cluster, which reduces the security and risk surface by removing credentials from being stored in your external CI tooling. You can also reduce allowed inbound connections and limit admin-level access to your Kubernetes clusters.

#### Best practice – Run dynamic application security tests (DAST) to find vulnerabilities in your running application

- Use GitHub [Actions](https://github.com/marketplace?category=testing&type=actions&query=) in deployment workflows to run dynamic application security testing (DAST) tests.

- Use open-source tools such as [ZAP](https://www.zaproxy.org/) to do penetration testing for common web application vulnerabilities.

#### Best practice – Deploy container images from trusted registries only

- Use [Defender for Containers](/azure/defender-for-cloud/kubernetes-workload-protections) to enable Azure Policy add-on for Kubernetes.

- Enable Azure Policy so that container images can only be deployed from trusted registries.

### Operate phase

During this phase, operation monitoring and security monitoring tasks are performed to proactively monitor, analyze, and alert on potential security incidents. Production observability tools like Azure Monitor and Microsoft Sentinel are used to monitor and ensure compliance with enterprise security standards.

#### Best practice – Use Defender for cloud to enable automated scanning and monitoring of your production configurations

- Run continual scanning to detect drift in the vulnerability state of your application and implement a process to patch and replace the vulnerable images.

- Implement automated configuration monitoring for operating systems.

  - Use Defender for Cloud container recommendations (under the **Compute and apps** section) to perform baseline scans for your AKS clusters. Get notified in the Defender for Cloud dashboard when configuration issues or vulnerabilities are found.

  - Use Defender for Cloud and follow its network protection recommendations to help [secure](/azure/defender-for-cloud/protect-network-resources) the network resources being used by your AKS clusters.

- Conduct a vulnerability assessment for images stored in Container Registry.

  - Implement continuous scans for running images in Container Registry by enabling [Defender for Containers](/azure/defender-for-cloud/defender-for-containers-vulnerability-assessment-azure).

#### Best practice – Keep your Kubernetes clusters updated

- Kubernetes releases are rolled out frequently. It's important to have a life cycle management strategy in place to ensure you don't fall behind and out of support. AKS is a managed offering that provides you with tools and flexibility to manage this upgrade process. You can use the AKS platform's planned maintenance features to have more control over maintenance windows and upgrades.

- AKS worker nodes should be [upgraded](/azure/architecture/operator-guides/aks/aks-upgrade-practices) more frequently. We provide weekly OS and runtime updates, which can be applied automatically via unattended mode or through the Azure CLI for more control and comprehensive updates.

#### Best practice – Use Azure Policy to secure and govern your AKS clusters

- After installing the [Azure Policy Add-on for AKS](/azure/aks/use-azure-policy), you can apply individual policy definitions or groups of policy definitions called initiatives (also called policy sets) to your cluster.

- Use [Built-in Azure policies](/azure/aks/policy-reference) for common scenarios like preventing privileged containers from running or only approving allowlisted external IPs. You can also create custom policies for specific use cases.

- Apply policy definitions to your cluster and verify those assignments are being enforced.

- Use Gatekeeper to configure an admission controller that allows or denies deployments based on rules specified. Azure Policy extends Gatekeeper.

- Secure traffic between workload pods by using network policies in AKS.

  - Use [Azure CNI Powered by Cilium](/azure/aks/azure-cni-powered-by-cilium) as the network policy engine. Cilium uses an eBPF-based dataplane and supports Kubernetes-native policies, Layer 7 policy, and FQDN filtering.

#### Best practice – Use Azure Monitor for Continuous monitoring and alerting

- Use [Azure Monitor](/azure/azure-monitor/containers/kubernetes-monitoring-enable) to collect logs and metrics from AKS. Collect Prometheus metrics via [Azure Monitor managed service for Prometheus](/azure/azure-monitor/essentials/prometheus-metrics-overview), query container and platform logs in [Log Analytics](/azure/azure-monitor/logs/log-analytics-overview), and visualize cluster health through [Azure Managed Grafana](/azure/managed-grafana/overview) dashboards.

  - Continuous monitoring with Azure Monitor extends to release pipelines to gate or rollback releases based on monitoring data. Azure Monitor also ingests security logs and can alert on suspicious activity.

  - Onboard your AKS instances to Azure Monitor and configure diagnostic settings for your cluster.

    - See [Azure security baseline for Azure Kubernetes Service](/security/benchmark/azure/baselines/aks-security-baseline).

#### Best practice – Use Defender for Cloud for active threat monitoring

- Defender for Cloud provides active threat monitoring on the AKS at the node level (VM threats) and for internals.

- Defender for DevOps should be used for comprehensive visibility and provides security and operator teams with a centralized dashboard for all your CI/CD pipelines. This functionality is especially useful if you're using multi-pipeline platforms like Azure DevOps and GitHub or are running pipelines across public clouds.

- Defender for Key Vault can be used to detect unusual, suspicious attempts to access key vault accounts and can alert administrators based on configuration.

- Defender for Containers can alert on vulnerabilities found within your container images stored on Container Registry.

#### Best Practice – Enable centralized log monitoring and use SIEM products to monitor for real time security threats

- Connect AKS diagnostics logs to Microsoft Sentinel for centralized security monitoring based on patterns and rules. Microsoft Sentinel enables this access by way of [data connectors](/azure/sentinel/data-connectors-reference#azure-kubernetes-service-aks).

#### Best Practice – Enable audit logging to monitor activity on your production clusters

- Use Activity logs to monitor actions on AKS resources to view all activity and their status. Determine what operations were performed on the resources and by whom.

- Enable [DNS query logging](/azure/aks/coredns-custom) by applying documented configuration in your CoreDNS custom ConfigMap.

- Monitor attempts to access deactivated credentials.

  - Integrate user authentication for AKS with Microsoft Entra ID. Create Diagnostic Settings for Microsoft Entra ID, [sending](    /entra/identity/monitoring-health/howto-integrate-activity-logs-with-azure-monitor-logs) the audit and sign-in logs to an Azure Log Analytics workspace. Configure desired alerts (such as when a deactivated account attempts to sign in) within an Azure Log Analytics workspace.

#### Best Practice – Enable diagnostics on your Azure Resources

- By enabling Azure diagnostics across all of your workload’s resources, you have access to platform logs that provide detailed diagnostic and auditing information for your Azure resources. These logs can be ingested into Log Analytics or a SIEM solution like Microsoft Sentinel for security monitoring and alerting.

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
- [GitOps](/azure/architecture/example-scenario/gitops-aks/gitops-blueprint-aks)

## Related resources

- [DevSecOps for IaC](../../solution-ideas/articles/devsecops-infrastructure-as-code.yml)
- [Shift left](https://devops.com/devops-shift-left-avoid-failure)
