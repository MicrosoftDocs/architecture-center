DevSecOps makes security best practices an integral part of DevOps while maintaining efficiency in an Azure framework, starting with the first steps of development. DevSecOps redirects the security focus by using a [shift-left][Shift left] strategy. Instead of auditing code and the software supply chain for vulnerabilities at the end of the development process, it shifts to the beginning. Besides producing robust code, this [fail fast][Fail fast] approach helps resolve problems early on, when they're easier and less expensive to fix.

## Architecture

:::image type="complex" source="../media/devsecops-in-github-data-flow.png" alt-text="Architecture diagram highlighting the security checks that run in various GitHub and Azure components in a GitHub DevSecOps environment." border="false":::
   Architecture diagram highlighting security checks that run in a GitHub DevSecOps environment. After Azure Active Directory (Azure AD) authenticates developers, Codespaces runs security scans. GitHub Actions then test security and encrypt sensitive data. In production, Azure Policy, Microsoft Defender for Cloud, and Azure Monitor evaluate deployed software for risks.
:::image-end:::

*Download a [Visio file][visio-download] of all diagrams in this architecture.*

### Dataflow

1. When developers access GitHub resources, GitHub redirects them to Azure AD for SAML authentication. In a single sign-on (SSO) procedure, the [Microsoft Authenticator app][Microsoft Authenticator] then uses FIDO2 strong authentication. The passwordless [FIDO2 security keys][FIDO2 security keys] align with the latest [Fast Identity Online (FIDO) Alliance][FIDO Alliance] specifications.
1. Developers begin working on tasks in Codespaces. These pre-built development environments organized into containers provide correctly configured IDEs equipped with required security scanning extensions.
1. When developers commit new code, GitHub Actions automatically scan the code to quickly find vulnerabilities and coding errors.
1. Pull requests (PRs) trigger code builds and automated testing through GitHub Actions. GitHub encrypts secrets and credentials at rest and obfuscates these entries in logs.
1. GitHub Actions deploy build artifacts to Azure App Service while making changes to other cloud resources, such as service endpoints.
1. Azure Policy evaluates Azure resources that are in deployment. Defined policies then potentially deny releases, modify cloud resources, or create warning events in activity logs.
1. Microsoft Defender for Cloud identifies attacks targeting applications that are running in deployed projects.
1. Azure Monitor continuously tracks and evaluates app behavior. When threats materialize, this service sends alerts to start the process of rolling code back to previous commits.

When GitHub Security identifies a vulnerability, it takes the steps illustrated in the following diagram:

   :::image type="complex" source="../media/devsecops-in-github-vulnerability-management-data-flow.png" alt-text="Architecture diagram illustrating the chain of events that the identification of a vulnerability triggers, including alerts, upgrades, and deployment." border="false":::
Architecture diagram illustrating a chain of events in a GitHub DevSecOps implementation. At the outset, GitHub identifies a vulnerability and sends an email alert. Dependabot then creates a branch, updates the vulnerability source, and creates a PR. The branch merges. In the final step, GitHub Actions deploy the new app.
   :::image-end:::
  
   *Download a [Visio file][visio-download] of all diagrams in this architecture.*  

    
1. GitHub sends an email alert to the organization owners and repository administrators.
1. GitHub Dependabot, a DevOps bot agent, automatically completes the following three tasks:  
   a. Creates a new branch in the repository.  
   b. Upgrades the necessary dependencies to the minimum possible secure version needed to eliminate the vulnerability.  
   c. Creates a PR with the upgraded dependency.  
1. When the PR is approved, the new branch merges with the base branch.
1. The merged branch triggers CI/CD tasks in GitHub Actions.
1. GitHub Actions deploy the new app version to a test or staging environment.

### Components

- [Azure Active Directory (Azure AD)][Azure AD] is a multi-tenant, cloud-based identity service that controls access to Azure and other cloud apps like [Microsoft 365][Microsoft 365] and GitHub. You can configure Azure AD as the identity provider for GitHub, and you can enable multi-factor authentication for extra security.
- [GitHub][GitHub] provides a code-hosting platform that developers can use for collaborating on both open-source and [inner-source][Inner source] projects.
- [Codespaces][Codespaces] is an online development environment, hosted by GitHub and powered by [Visual Studio Code][Visual Studio Code]. This tool provides a complete development solution in the cloud.
- [GitHub Security][GitHub Security] works to eliminate threats in many ways. Agents and services identify vulnerabilities in repositories and in dependent packages, and ensure dependencies are up-to-date with secure versions. See the GitHub security subsection of Considerations for more details.
- [GitHub Actions][GitHub Actions] are custom workflows that provide continuous integration (CI) and continuous deployment (CD) capabilities directly in repositories. Computers called *runners* host these CI/CD jobs.
- [App Service][App Service] provides a framework for building, deploying, and scaling web apps. This platform offers built-in infrastructure maintenance, security patching, and scaling.
- [Azure Policy][Azure Policy] helps teams manage and prevent IT issues through policy definitions that can enforce rules for cloud resources. For instance, if your project is about to deploy a virtual machine with an unrecognized SKU, Azure Policy alerts you to the problem and stops the deployment.
- [Microsoft Defender for Cloud](/azure/defender-for-cloud/defender-for-cloud-introduction) provides unified security management and advanced threat protection across hybrid cloud workloads.
- [Azure Monitor][Azure Monitor] collects and analyzes app telemetry, such as performance metrics and activity logs. When this service identifies irregular conditions, it alerts apps and personnel.

## Scenario Details

With many security capabilities, GitHub offers tools that support every part of a DevSecOps workflow:

- Browser-based IDEs with built-in security extensions
- Agents that continuously monitor security advisories and replace vulnerable and out-of-date dependencies
- Search capabilities that scan source code for vulnerabilities
- Action-based workflows that automate every step of development, testing, and deployment
- Spaces that provide a way to privately discuss and resolve security threats and then publish the information

These features provide a superb service for building secure cloud solutions combined with the monitoring and evaluation power of Azure.

### Potential use cases

GitHub DevSecOps installations cover many security scenarios. Possibilities include the following cases:

- Developers who want to take advantage of pre-configured environments that offer security capabilities
- Administrators who rely on having up-to-date, prioritized security reports at their fingertips, along with details on affected code and suggested fixes
- Streamlined organizations that need systems to automatically acquire new, uncompromised security devices when secrets are left exposed in code
- Development teams that could benefit from automatic upgrades when newer or more secure versions of external packages become available

## Considerations

To keep GitHub DevSecOps solutions aligned with the tenets of the [Azure Well-Architected Framework][Azure Well-Architected Framework], consider the following points when deciding how to implement this architecture.

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

- If you work with the on-premises deployment of GitHub.com that [GitHub Enterprise Server][GitHub Enterprise Server] provides, use a [highly available failover configuration][GitHub Enterprise highly available failover configuration] for increased resiliency.
- If you opt for self-hosted Actions runners, consider distributing them geographically.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

- We don't advise using self-hosted Actions runners for public repositories. A malicious user could join your repo and create a PR that runs unsafe code on computers in your network. GitHub-hosted runners remove this risk.
- Scan your code using the CodeQL analysis engine to discover potential vulnerabilities and coding errors. CodeQL can run both on a schedule and when events occur, such as a commit or a PR creation, making it easy for users to identify security issues from within their PRs. See [About code scanning][GitHub code scanning].
- [Configure Dependabot security updates][Configure Dependabot security updates], which can remove known threats from projects.
- Configure GitHub Enterprise Server to include [GitHub Advanced Security][GitHub Advanced Security], which is available for enterprise accounts on GitHub Enterprise Cloud and GitHub Enterprise Server 3.0 or higher. This provides extra features that help users find and fix security problems in their code. GitHub Enterprise can integrate automatic security and dependency scanning through GitHub Advanced Security and GitHub Open Source Security.
- Augment the code-scanning capabilities of GitHub by adding [third-party code-scanning tools][Third party code scanning] that produce [Static Analysis Results Interchange Format (SARIF)][SARIF] files. GitHub then creates alerts when those tools identify potential security issues.

#### GitHub Security

[GitHub Security][GitHub Security] provides multiple features for addressing security risks:

- [Secret scanning][GitHub secret scanning] inspects repositories or commits for any tokens, keys, or secrets that appear in code. It can notify teams that secrets have leaked into public view, and can notify service providers that one of their secrets leaked. Service providers can optionally revoke or renew the secrets.
- [Code scanning][GitHub code scanning] inspects code for known vulnerabilities and coding errors. As an example, if a developer leaves a database connection string exposed in code, this feature discovers the secret. GitHub starts the process of obtaining an uncompromised string after verifying its validity with the database. These checks use [CodeQL][CodeQL], a code analysis platform that improves upon traditional analyzers by allowing you to query code as if it were data. Scans automatically run at scheduled times or after certain events occur, like commits or pushes. [Try CodeQL on LGTM][Try CodeQL].
- [GitHub Dependabot][GitHub Dependabot] checks for outdated or vulnerable packages and applications. This automated agent updates software, replacing out-of-date or insecure dependencies with newer, secure versions. For instance, if your project uses an open-source library, Dependabot examines that library. Suppose the library doesn't encrypt sensitive cleartext that it stores in a database. In this case, Dependabot creates a PR to upgrade the library to a version that encrypts the data.
- [Vulnerability management][GitHub vulnerability management] identifies and updates known vulnerabilities in code and in software packages that the code uses. It runs checks whenever the following events occur:

  - A repository's dependencies change (for instance, when a project switches from .NET to .NET Core).
  - A notification appears from [Mend][Mend]. This third-party service tracks vulnerabilities by continuously scanning open-source repositories.
  - A new vulnerability enters the [GitHub Advisory Database][GitHub Advisory Database]. Entries in this database originate from the following sources:

    - The [National Vulnerability Database][National Vulnerability Database]: A standardized repository of vulnerabilities that the U.S. government maintains.
    - [GitHub tracking][GitHub tracking]: A combination of machine learning and human review that GitHub conducts to detect vulnerabilities in public commits.
    - [GitHub security advisories][GitHub security advisories]: Information about vulnerabilities that development teams make public on GitHub.
    - [Repository security advisories][Repository security advisories]: Discuss, fix, and disclose security vulnerabilities in your repositories.
    - [PHP Security Advisories Database][PHP Security Advisories Database]: References to known security vulnerabilities in PHP projects and libraries.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

- GitHub bills customers for GitHub Actions by the minute. In addition, the choice of operating system that hosts Actions jobs affects the per-minute consumption rate and per-minute cost. Wherever possible, choose Linux to host Actions. See [About billing for GitHub actions][About billing for GitHub actions].
- Project managers on tight schedules might worry that adding security measures will delay development. Experience the opposite by saving time with these guidelines:
  - Shift testing left, closer to the source. Teams will have fewer mistakes as a result.
  - Address issues during programming, rather than months down the line in production. That way, developers don't need to refresh their knowledge of the code.
- GitHub Security features vary based on an organization's licensing, and whether a repository's visibility is public or private. See [Plans for all developers][GitHub pricing].

### Operational excellence

Operational excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Overview of the operational excellence pillar](/azure/architecture/framework/devops/overview).

- Run automated tests and maintenance in environments that use vulnerability management capabilities, since these capabilities change code and its dependencies on your behalf. Automated testing identifies any issues that result from these changes.
- Take advantage of Azure Policy features. Besides denying deployments and logging compliance issues, these policies can also modify resources, making them compliant, even if they aren't deployed that way. For example, if you try to deploy a storage account in Azure that uses HTTP, Azure Policy detects the situation. Policies can then automatically change the deployment and force the storage account to use HTTPS.
- Azure Resource Manager uses JSON templates to describe the resources involved in deployment. Teams can also manage these template documents by using DevOps tools, like version control, code collaboration, and CI/CD workflows.
- One concern with DevSecOps is that code scans can generate noisy results filled with false positives, leading to the following types of problems:
  - Developers waste time investigating nonexistent problems.
  - Addressing security issues interrupts workflow.
  - Having lost trust in security tools because of the inaccuracies, developers ignore results.

Overcome these obstacles by integrating security into the software lifecycle:

- Employ tools like Codespaces that embed scanning checks in IDEs, meaning developers use them in familiar environments.
- Make security checks a regular part of code review instead of an afterthought.
- Put developers in charge of high-precision scans, but leave noisier checks to security teams.

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

For long-running or complex Actions, host your own runners for CI/CD jobs. You can then choose computers with powerful processing capabilities and ample memory. See [About self-hosted runners][About self-hosted runners].

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Frank Migacz](https://www.linkedin.com/in/fmigacz) | App Innovation

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Training materials, tools, and other resources on GitHub DevSecOps][GitHub DevSecOps training materials]
- [Tips for getting started with GitHub DevSecOps][GitHub DevSecOps getting started tips]

## Related resources

- [DevSecOps on AKS][DevSecOps on AKS]
- [DevSecOps for Infrastructure as Code (IaC)][DevSecOps for Infrastructure as Code (IaC)]
- [Shift left][Shift left]
- [Fail fast][Fail fast]
- [SARIF files][SARIF]

[Shift left]: https://devops.com/devops-shift-left-avoid-failure
[Fail fast]: https://whatis.techtarget.com/definition/fail-fast
[visio-download]: https://arch-center.azureedge.net/devsecops-in-github.vsdx
[Microsoft Authenticator]: /azure/active-directory/user-help/user-help-auth-app-overview
[FIDO2 security keys]: /azure/active-directory/authentication/concept-authentication-passwordless#fido2-security-keys
[FIDO Alliance]: https://fidoalliance.org
[Azure AD]: /azure/active-directory/fundamentals/active-directory-whatis
[Microsoft 365]: https://www.microsoft.com/microsoft-365/what-is-microsoft-365
[GitHub]: https://docs.github.com
[Inner source]: https://resources.github.com/whitepapers/introduction-to-innersource
[Codespaces]: https://docs.github.com/codespaces/overview
[Visual Studio Code]: https://code.visualstudio.com
[GitHub Security]: https://github.com/features/security
[GitHub Actions]: https://docs.github.com/en/actions/getting-started-with-github-actions/about-github-actions
[App Service]: https://azure.microsoft.com/services/app-service
[Azure Policy]: /azure/governance/policy/overview
[Azure Monitor]: /azure/azure-monitor/overview
[GitHub secret scanning]: https://docs.github.com/code-security/secret-scanning/about-secret-scanning
[GitHub code scanning]: https://docs.github.com/code-security/code-scanning/automatically-scanning-your-code-for-vulnerabilities-and-errors/about-code-scanning
[Third party code scanning]: https://docs.github.com/code-security/code-scanning/automatically-scanning-your-code-for-vulnerabilities-and-errors/about-code-scanning#about-tools-for-code-scanning
[CodeQL]: https://codeql.github.com/
[Try CodeQL]: https://lgtm.com/query/rule:1823453799/lang:java/
[GitHub Dependabot]: https://docs.github.com/code-security/dependabot/dependabot-version-updates/about-dependabot-version-updates
[Securing your software supply chain]: https://docs.github.com/code-security/supply-chain-security
[GitHub vulnerability management]: https://docs.github.com/en/code-security/supply-chain-security/understanding-your-software-supply-chain/about-supply-chain-security
[Mend]: https://www.mend.io
[GitHub Advisory Database]: https://github.com/advisories
[National Vulnerability Database]: https://nvd.nist.gov
[GitHub tracking]: https://docs.github.com/code-security/dependabot/dependabot-alerts/browsing-security-advisories-in-the-github-advisory-database#about-the-github-advisory-database
[GitHub security advisories]: https://docs.github.com/en/github/managing-security-vulnerabilities/about-github-security-advisories
[Repository security advisories]: https://docs.github.com/en/code-security/repository-security-advisories
[PHP Security Advisories Database]: https://github.com/FriendsOfPHP/security-advisories
[Azure Well-Architected Framework]: /azure/architecture/framework/index
[About billing for GitHub actions]: https://docs.github.com/billing/managing-billing-for-github-actions/about-billing-for-github-actions
[About self-hosted runners]: https://docs.github.com/actions/hosting-your-own-runners/about-self-hosted-runners
[GitHub Enterprise Server]: https://azuremarketplace.microsoft.com/marketplace/apps/github.githubenterprise
[GitHub Enterprise highly available failover configuration]: https://docs.github.com/enterprise-server@3.5/admin/enterprise-management/configuring-high-availability
[GitHub Advanced Security]: https://docs.github.com/enterprise-server@3.5/admin/code-security/managing-github-advanced-security-for-your-enterprise/enabling-github-advanced-security-for-your-enterprise
[Configure Dependabot security updates]: https://docs.github.com/code-security/dependabot/dependabot-security-updates/configuring-dependabot-security-updates
[DevSecOps on AKS]: ../../guide/devsecops/devsecops-on-aks.yml
[GitHub pricing]: https://github.com/pricing
[GitHub DevSecOps training materials]: https://github.com/devsecops/awesome-devsecops
[GitHub DevSecOps getting started tips]: https://resources.github.com/whitepapers/Architects-guide-to-DevOps
[SARIF]: https://docs.github.com/en/github/finding-security-vulnerabilities-and-errors-in-your-code/sarif-support-for-code-scanning
[DevSecOps for Infrastructure as Code (IaC)]: ./devsecops-infrastructure-as-code.yml
