[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

DevSecOps builds on the practice of DevOps by incorporating security at different stages of a traditional DevOps lifecycle. Some of the benefits of building security in DevOps practices include:

- Making your applications and systems more secure by providing visibility into security threats and preventing vulnerabilities from reaching deployed environments
- Increasing security awareness with your Development and Operation teams
- Incorporating automated security processes into your Software Development Lifecycle (SDLC)
- Reducing cost to remediate by finding security issues early in development and design stages

When applying DevSecOps to Azure Kubernetes Service (AKS), there are many considerations for implementing security by different organization roles such as Developers building secure applications running on AKS, Cloud Engineers building secure AKS infrastructure, or various Operations teams that may govern clusters or monitor security issues. This guide has been broken out into different DevOps lifecycle stages with considerations and recommendations for embedding security controls and security best practices. This guide includes common processes and tools to incorporate into CI/CD pipelines, opting for easy-to-use built-in tools where available.

As a pre-requisite to this article, it is recommended to review the following article, [Build and deploy apps on AKS using DevOps and GitOps](/azure/architecture/example-scenario/apps/devops-with-aks).

## Process flow

:::image type="content" alt-text="Architecture diagram shows the flow from the developer to the end user and where devsecops can be employed, devsecops in Azure." source="../media/devsecops-azure-aks.png" lightbox="../media/devsecops-azure-aks.png":::

*Download a [Visio file](https://arch-center.azureedge.net/devsecops-azure-aks.vsdx) of this architecture.*

> [!NOTE]
> While this article explicitly references AKS, GitHub, the recommendations mentioned would apply to any container orchestration or CICD platform, while the implementation details may vary, most of the concepts and practices mentioned in each stage would still be relevant and applicable.

1. [Azure Active Directory (Azure AD)](/azure/active-directory/fundamentals/active-directory-whatis) is configured as the identity provider for GitHub. Multi-factor authentication (MFA) gives extra authentication security.
1. Developers commit to GitHub Enterprise, driven by work items and bugs tracked with [Azure Boards](/azure/devops/boards/github/connect-to-github).
1. GitHub Enterprise integrates automatic security and dependency scanning through GitHub Advanced Security and GitHub Open Source Security.
1. Pull requests trigger CI builds and automated testing in [Azure Pipelines](/azure/devops/pipelines/get-started/pipelines-get-started).
1. The CI build in Azure Pipelines generates a Docker container image that is stored to [Azure Container Registry](/azure/container-registry/container-registry-concepts). It's used at release time by [Azure Kubernetes Service](/azure/aks/intro-kubernetes).
1. Microsoft Defender for Cloud will scan the image for Azure-native vulnerabilities and for security recommendations for the pushed image upon uploading to the Azure Container Registry.
1. A release on Azure Pipelines integrates the [Terraform](/azure/terraform/terraform-create-k8s-cluster-with-tf-and-aks) tool. It manages both the cloud infrastructure as code, provisioning resources such as Azure Kubernetes Service, [Azure Application Gateway](/azure/application-gateway/ingress-controller-overview), and [Azure Cosmos DB](/azure/cosmos-db/introduction).
1. Azure Pipelines enable Continuous Delivery (CD) to Azure Kubernetes Service by accessing the Container Registry through a secure service connection.
1. [Azure Policy](/azure/governance/policy/overview) can be applied to Azure Pipelines to enforce post-deployment gateways and can be applied directly to the AKS engine for policy enforcement.
1. [Azure Key Vault](/azure/key-vault/key-vault-overview) is used to securely inject secrets and credentials into an application at runtime, abstracting sensitive information away from developers.
1. End users can authenticate with [Azure AD B2C](/azure/active-directory-b2c/overview). They are required to use MFA for extra security and are routed through an Application Gateway that provides load balancing and security for core services.
1. Continuous monitoring with [Azure Monitor](/azure/azure-monitor/overview) extends to release pipelines to gate or rollback releases based on monitoring data. Azure Monitor also ingests security logs and can alert on suspicious activity.
1. Microsoft Defender for Cloud provides active threat monitoring on the Azure Kubernetes Service at the Node level (VM threats) and for internals.

## Personas Overview and Responsibilities

To manage the complexity of managing DevSecOps on Kubernetes based solution deployments, it is best to look at it in term of a separation of concerns. Which team in an enterprise environment should be concerned with what aspect of the deployment and what tools and processes should that team employ to best achieve their objectives. In this section we will be going over the common roles of developers, application operators (SRE - Site Reliability Engineers), cluster operators, and security teams.

### Developers

Developers are responsible for writing the code that comprises the application. They are also responsible for committing their code to the designated code repository. One of the important responsibilities of developers also includes authoring and running scripts for automated testing to ensure their code actually works as intended and integrates seamlessly with the rest of the application. They are usually also responsible for defining and scripting the building of container images as part of the automation pipeline.

### Application operators (site reliability engineers)

Building applications on the cloud using containers and Kubernetes can simplify application development, deployment, and scalability. But these development approaches also create increasingly distributed environments that complicate administration. SRE builds solutions to automate oversight of large software systems. They serve as a bridge between development and Cluster operator teams and help establish and monitor service level objectives and error budgets. This way they help manage application deployments and often write Kubernetes manifest (YAML) files.

### Cluster operators

This team is responsible for configuring and managing the cluster infrastructure. They often use infrastructure as code (IaC) best practices and frameworks like [GitOps](/azure/architecture/example-scenario/gitops-aks/gitops-blueprint-aks) to provision and maintain their clusters. They use various monitoring tools like Azure monitor container insights and Prometheus/Grafana to monitor overall cluster health. They are responsible for patching and cluster upgrades, permissions / RBAC, etc. on the cluster. In DevSecOps teams, they ensure that the clusters meet the security requirements of the team and work with the security team to create those standards.

### Security team

The security team is responsible for developing security standards and enforcing them. In some teams they may be responsible for creating and selecting Azure policy that will be enforced in the subscriptions and resource groups holding the clusters. They monitor security issues and together with the other teams, ensure that security is brought to the forefront of every step of the DevSecOps process.

## DevSecOps lifecycle stages

Security controls are implemented in each phase of the software development life cycle (SDLC), this is a key proponent of a DevSecOps strategy and the shift-left approach.

:::image type="content" alt-text="Architecture diagram shows the flow from the developer to the end user and where devsecops can be employed, devsecops in Azure." source="../media/devsecops-stages.png" lightbox="../media/devsecops-stages.png":::

*Download a [Visio file](https://arch-center.azureedge.net/devsecops-stages.vsdx) of this architecture.*

### Plan phase

The plan phase generally has the least amount of automation but will have important security implications that significantly impact later DevOps lifecycle stages. This stage involves collaboration between security, development, and operations teams. Including security stakeholders in this phase of designing and planning ensures security requirements and security issues are appropriately accounted for or mitigated.

#### Best Practice – Secure application platform design

Building a secure Azure Kubernetes Service (AKS) hosted platform is an important step to ensure security is built into the system at every layer, starting with the platform itself. This can include components both internal to the cluster such as runtime security and policy agents, as well as components that are external to AKS such as network firewalls, and container registries. For in-depth information on these topics, visit the AKS Landing zone accelerator, which contains critical design areas such as security, identity, and network topology.

#### Best Practice – Threat modeling

- Threat Modeling is traditionally a manual activity that is a collaboration involving security and development teams.  It is used to model and find threats within a system, allowing vulnerabilities to be addressed prior to any code being developed or changes being made to a system. Threat modeling can occur at different times, triggered by events such as a significant software change, solution architectural change, and security incidents.
- Microsoft recommends and uses the [STRIDE threat model](/azure/security/develop/threat-modeling-tool-threats#stride-model), a methodology which starts with a data flow diagram and using the STRIDE mnemonic (Spoofing, Tampering, Info Disclosure, Repudiation, Denial of Service and Elevation of Privilege) threat categories and empowers teams to identify, mitigate, and validate risk. This also includes a [modeling tool](https://www.microsoft.com/securityengineering/sdl/threatmodeling) to easily notate and visualize system components, data flows and security boundaries. Building threat modeling into your SDLC processes will introduce new processes and additional work to maintain updated threat models but will ensure security is in place early which in turn will reduce the potential cost of dealing with security issues found in later SDLC stages.

#### Best Practice – Leverage Azure Well Architect Framework (WAF)

- Leverage [WAF security pillar](/azure/architecture/framework/#security) best practices that provide guidance for things like identity management, application security, infrastructure protection, date security and devOps as it applies to cloud native environments.
- Leverage [WAF operational](/azure/architecture/framework/#operational-excellence) best practices as it applies to DevSecOps and monitoring of your production environments.

### Develop phase

"Shifting left" is a key tenant of the DevSecOps mindset, and this process begins well before code is even committed into a repository and deployed via a pipeline, by adopting secure coding best practices and using IDE (integrated development environments) tools & plugins for code analysis during the development phase can go a long way with addressing security issues earlier in the development lifecycle when it's much easier to fix.

#### Best Practice – Enforce secure coding standards

- Using established secure coding best practices and checklists, developers can ensure they are protecting their code from common vulnerabilities like injection and insecure design, the [OWASP](https://owasp.org/www-pdf-archive/OWASP_SCP_Quick_Reference_Guide_v2.pdf) foundation publishes industry standard secure coding recommendations that that developers should adopt when writing code, these guidelines are especially important when developing public facing web applications or services.
- In addition to general security best practices, developers should also look at secure coding practices for their specific programming language runtimes like [Java](https://www.oracle.com/java/technologies/javase/seccodeguide.html) and .NET.
- Enforce logging standards to protect sensitive information from being leaked into your application logs, most popular logging frameworks like log4j/log4net provide filters and plugins to mask sensitive information like account numbers or PII (personally identifiable information) data.

#### Best practice – Use IDE tools and plugins to automate security checks

Most popular IDEs (Integrated Development Environments) like Visual Studio, Visual Studio Code, IntelliJ IDEA, and Eclipse support extensions that developers can use to get immediate feedback and recommendations around potential security issues they may have introduced while writing their application code.

- [SonarLint](https://www.sonarsource.com/products/sonarlint/#learn) is an IDE plugin available for most popular languages and developer environments, SonarLint provides valuable feedback and auto scans your code for common programming errors and potential security issues.
- Other free and commercial plugins that are focused on security specific items like the OWASP top 10 common vulnerabilities. The [Synk](https://snyk.io/ide-plugins/) plugin for example also scans your application source as well as 3rd party dependencies and alerts you if any vulnerabilities are found.
- The [Static Analysis Results Interchange Format (SARIF)](https://github.com/microsoft/sarif-vscode-extension) plugin for Visual Studio and Visual Studio Code allows developers to easily view vulnerabilities from popular Static Application Security Testing (SAST) tools in an intuitive and easy to read manner vs interpreting results from raw JSON output files.

#### Best practice – Establish controls on your source code repositories

- Establish a branching methodology so there is consistent use of branching across the enterprise, methodologies like [Release flow](/devops/develop/how-microsoft-develops-devops), [GitHub flow](https://docs.github.com/en/get-started/quickstart/github-flow), have very structured guidelines on how branches should be used to support team and parallel development, these methodologies can help teams establish standards and controls for code commits and merges into your CI/CD workflow.
- Certain branches such as master are long lasting branches that preserve the integrity of your application’s source code, these branches should have established merge policies before changes can be merged/committed into them, some best practices include
  - Prevent developers from committing code directly into your main branch
  - Establish a peer review process and require a minimum number of approvals before changes can be merged to a main branch; GitHub allows these controls to be easily configured and enforced. Furthermore, GitHub allows you to designate groups of authorized approvers if necessary for gated environments.
- Use [pre-commit hooks](https://github.com/pre-commit/pre-commit-hooks) to check for sensitive information within your application source code and prevent a commit from happening if a security issue is found.
  - GitHub provides built-in pre-commit hooks that can be easily configured for a specific project, for example, there are pre-built hooks to scan for secrets, private keys and credentials and prevent a commit if any of these issues are found.
- Establish RBAC (role-based access control) within your version control system
  - A CI/CD (continuous integration and continuous delivery) pipeline is your supply chain for production deployments and well-defined roles need to be created using the principle of least privileges.
  - Established user or group [roles](https://docs.github.com/en/enterprise-cloud@latest/admin/user-management/managing-users-in-your-enterprise/roles-in-an-enterprise) within an organization need to be leveraged, roles like Admin, Developer, Security admin and Operator need to be created to group individuals based on their specific role and function with regards to your CI/CD workflows.
- Enable [auditing](https://docs.github.com/en/enterprise-server@3.2/admin/user-management/managing-users-in-your-enterprise/auditing-users-across-your-enterprise) of your workflows so there is transparency and traceability for configuration and other changes with respect to your CI/CD pipelines.

#### Best practice – Secure your container images 

- Use lightweight images with a minimal OS footprint to reduce the overall surface attack area, consider minimal images like Alpine and/or even distroless images that only contain your application and its associated runtime. The open-source Linux distribution from Microsoft named Mariner is a lightweight, hardened distribution designed for AKS to host containerized workloads.
- Use only trusted base images when building your containers, these base images should be retrieved from a private registry that is frequently scanned for vulnerabilities.
- Use developer tools to evaluate image vulnerabilities locally
  - [Trivy](https://trivy.dev/) is an example of an open-source tool that can be used to analyze security vulnerabilities within your container images.
- Prevent root user access/context for an image, by default containers will run as root.
  - For containers that need enhanced security, consider using an AppArmor profile within your Kubernetes cluster to further enforce security for your running containers


### Build phase

During the build phase, developers work with the SRE and security team to integrate automated scans of their application source within their Continuous Integration (CI) build pipelines, the pipelines are configured to enable security practices such as SAST, SCA and secrets scanning using the CI/CD platform’s security tools and extensions.

#### Best practice – Perform Static Code Analysis (SAST) to find potential vulnerabilities in your application source code

- Use GitHub Advances Security scanning capabilities for code scanning and CodeQL
  - [Code scanning](https://docs.github.com/en/enterprise-cloud@latest/code-security/code-scanning/automatically-scanning-your-code-for-vulnerabilities-and-errors/about-code-scanning) is a feature that you use to analyze the code in a GitHub repository to find security vulnerabilities and coding errors. Any problems identified by the analysis are shown in GitHub Enterprise Cloud.
  - If code scanning finds a potential vulnerability or error in your code, GitHub displays an alert in the repository.
  - You can also configure branch rules for [required status checks](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/defining-the-mergeability-of-pull-requests/troubleshooting-required-status-checks), for example to enforce that a feature branch is up to date with base branch before merging any new code, this ensures that your branch has always been tested with the latest code.
- Use tools like [kube-score](https://kube-score.com/) to analyze your Kubernetes deployment objects
  - kube-score is a tool that does static code analysis of your Kubernetes object definitions.
  - The output is a list of recommendations of what you can improve to make your application more secure and resilient.


#### Best practice – Perform secret scanning to prevent the fraudulent use of secrets that were committed accidentally to a repository

- When [secret scanning](https://docs.github.com/en/enterprise-cloud@latest/code-security/secret-scanning/about-secret-scanning#about-secret-scanning-for-advanced-security) is enabled for a repository, GitHub scans the code for patterns that match secrets used by many service providers.
- GitHub will also periodically run a full git history scan of existing content in repositories and send alert notifications.
  - For Azure DevOps, [Defender for Cloud](/azure/defender-for-cloud/detect-credential-leaks) offers a solution by using secret scanning to detect credentials, secrets, certificates, and other sensitive content in your source code and your build output.
  - Secret scanning can be run as part of the Microsoft Security DevOps for Azure DevOps extension


#### Best practice – Use software composition analysis (SCA) tools to track open-source components in the codebase and detect any vulnerabilities in dependencies

- [Dependency review](https://docs.github.com/en/code-security/supply-chain-security/understanding-your-software-supply-chain/about-dependency-review) lets you catch insecure dependencies before you introduce them to your environment, and provides information on license, dependents, and age of dependencies. It provides an easily understandable visualization of dependency changes with a rich diff on the "Files Changed" tab of a pull request.
- [Dependabot](https://docs.github.com/en/enterprise-cloud@latest/code-security/dependabot/dependabot-alerts/about-dependabot-alerts) performs a scan to detect insecure dependencies and sends Dependabot alerts when a new advisory is added to the GitHub Advisory Database, or when dependency graph for a repository changes.

#### Best practice – Enable security scans of Infrastructure as Code (IaC) templates to minimize cloud misconfigurations reaching production environments

- Proactively monitor cloud resource configurations throughout the development lifecycle.
- [Microsoft Defender](/azure/defender-for-cloud/iac-vulnerabilities) for DevOps supports both GitHub and Azure DevOps repositories.

#### Best practice – Scan your workload images in container registries to identify known vulnerabilities

- [Defender for Containers](/azure/defender-for-cloud/defender-for-containers-introduction#hardening) scans the containers in Azure Container Registry (ACR) and Amazon AWS Elastic Container Registry (ECR) to notify you if there are known vulnerabilities in your images.
- [Azure Policy](/azure/container-registry/container-registry-azure-policy) can be enabled to do a vulnerability assessment on all images stored in ACR and provide detailed information on each finding.

#### Best practice – Automatically build new images on base image update

- [Azure Container Registry (ACR) Tasks](/azure/container-registry/container-registry-tasks-base-images) dynamically discover base image dependencies when it builds a container image. As a result, it can detect when an application image's base image is updated. With one preconfigured build task, ACR Tasks can automatically rebuild every application image that references the base image.

#### Best practice – Use ACR, AKV and notation to digitally sign your container images and configure AKS cluster to only allow validated images

- Azure Key Vault (AKV) is used to store a signing key that can be utilized by [notation](/azure/container-registry/container-registry-tutorial-sign-build-push) with the notation AKV plugin (azure-kv) to [sign](/azure/container-registry/container-registry-tutorial-sign-build-push) and verify container images and other artifacts. The Azure Container Registry (ACR) allows you to attach these signatures by using the Azure CLI commands.
- The signed containers enable users to assure deployments are built from a trusted entity and verify artifact hasn't been tampered with since their creation. The signed artifact ensures integrity and authenticity before the user pulls an artifact into any environment and avoid attack
  - [Ratify](https://github.com/deislabs/ratify/blob/main/README.md) enables Kubernetes clusters to verify artifact security metadata prior to deployment and admit for deployment only those that comply with an admission policy that you create.

### Deploy phase

During the deployment phase, developers, application and cluster operator teams work together on establishing the right security controls for the continuous deployment (CD) pipelines to deploy code to a production environment in a secure and automated manner.

#### Best practice – Control the access and workflow of the deployment pipeline

- You can [protect](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/defining-the-mergeability-of-pull-requests/about-protected-branches) important branches by setting branch protection rules, which define whether collaborators can delete or force push to the branch and set requirements for any pushes to the branch, such as passing status checks or a linear commit history.
- Using [environments](https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment) for deployment, one can configure environments with protection rules and secrets
- You can take advantage of the [Approvals](https://docs.github.com/en/actions/managing-workflow-runs/reviewing-deployments) and Gates feature to control the workflow of the deployment pipeline, for example, you may require manual approvals from a security or operations team before a deployment to a production environment.

#### Best practice – Secure deployment credentials

- Using [OpenID Connect (OIDC)](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-azure) allows your GitHub Action workflows to access resources in Azure, without needing to store the Azure credentials as long-lived GitHub secrets.
- Using environments for deployment: You can configure environments with protection rules and secrets
  - A pull-based approach to CI/CD with [GitOps](/azure/architecture/example-scenario/apps/devops-with-aks) allows you to shift security credentials to your Kubernetes cluster, which reduces the security and risk surface by removing credentials from being stored in your external CI tooling. You'll also be able to reduce allowed inbound connections and limit admin-level access to your Kubernetes clusters.


#### XXXXXXH4XXXXXX

xxxxxxxxxxxx

#### XXXXXXH4XXXXXX

xxxxxxxxxxxx

#### XXXXXXH4XXXXXX

xxxxxxxxxxxx



## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author: 

- [Alessandro Segala](https://www.linkedin.com/in/alessandrosegala) | Product Marketing Manager for VS Code

## Next steps

- Using [Microsoft Defender for Cloud](/azure/security-center/container-security), you can supply threat and vulnerability management for your deployed container-based solution.

## Related resources

- [DevSecOps in GitHub](./devsecops-in-github.yml)
- [DevSecOps for Infrastructure as Code (IaC)](./devsecops-infrastructure-as-code.yml)
