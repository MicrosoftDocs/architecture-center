


Starting with the first steps of development, DevSecOps adheres to security best practices. By using a [shift-left][Shift left] strategy, DevSecOps redirects the security focus. Instead of pointing toward auditing at the end, it shifts to development in the beginning. Besides producing robust code, this [fail fast][Fail fast] approach helps to resolve problems early on, when they're easy to fix.

With many security capabilities, GitHub offers tools that support every part of a DevSecOps workflow:

- Browser-based IDEs with built-in security extensions.
- Agents that continuously monitor security advisories and replace vulnerable and out-of-date dependencies.
- Search capabilities that scan source code for vulnerabilities.
- Action-based workflows that automate every step of development, testing, and deployment.
- Spaces that provide a way to privately discuss and resolve security threats and then publish the information.

Combined with the monitoring and evaluation power of Azure, these features provide a superb service for building secure cloud solutions.

## Potential use cases

GitHub DevSecOps installations cover many security scenarios. Possibilities include the following cases:

- Developers who want to take advantage of pre-configured environments that offer security capabilities.
- Administrators who rely on having up-to-date, prioritized security reports at their fingertips, along with details on affected code and suggested fixes.
- Streamlined organizations that need systems to automatically acquire new, uncompromised security devices when secrets are left exposed in code.
- Development teams that could benefit from automatic upgrades when newer or more secure versions of external packages become available.

## Architecture

:::image type="complex" source="../media/devsecops-in-github-data-flow.png" alt-text="Architecture diagram highlighting the security checks that run in various GitHub and Azure components in a GitHub DevSecOps environment." border="false":::
   Architecture diagram highlighting security checks that run in a GitHub DevSecOps environment. After Azure AD authenticates developers, Codespaces run security scans. GitHub Actions then test security and encrypt sensitive data. In production, Azure Policy, Azure Security Center, and Azure Monitor evaluate deployed software for risks.
:::image-end:::
*Download an [.svg][DevSecOps in GitHub svg] of this architecture.*

1. When developers access GitHub resources, GitHub redirects them to Azure Active Directory (Azure AD) for SAML authentication. In a single sign-on (SSO) procedure, the [Microsoft Authenticator app][Microsoft Authenticator] then uses FIDO2 strong authentication. The passwordless [FIDO2 security keys][FIDO2 security keys] align with the latest [Fast Identity Online (FIDO) Alliance][FIDO Alliance] specifications.
1. Developers begin working on tasks in Codespaces. Organized into containers, these pre-built development environments provide correctly configured IDEs that are equipped with required security scanning extensions.
1. When developers commit new code, GitHub Actions automatically scan the code to quickly find vulnerabilities and coding errors.
1. Pull requests (PRs) trigger code builds and automated testing through GitHub Actions. GitHub encrypts secrets and credentials at rest and obfuscates these entries in logs.
1. GitHub Actions deploy build artifacts to Azure App Service while making changes to other cloud resources, such as service endpoints.  
1. Azure Policy evaluates Azure resources that are in deployment. Defined policies then potentially deny releases, modify cloud resources, or create warning events in activity logs.
1. Azure Security Center identifies attacks targeting applications that are running in deployed projects.
1. Azure Monitor continuously tracks and evaluates app behavior. When threats materialize, this service sends alerts to start the process of rolling code back to previous commits.

## Components

- [Azure AD][Azure AD] is a multi-tenant, cloud-based identity service that controls access to Azure and other cloud apps like [Microsoft 365][Microsoft 365] and GitHub.
- [GitHub][GitHub] provides a code-hosting platform that developers can use for collaborating on both open-source and [inner-source][Inner source] projects.
- [Codespaces][Codespaces] is an online development environment. Hosted by GitHub and powered by [Visual Studio Code][Visual Studio Code], this tool provides a complete development solution in the cloud.
- [GitHub Security][GitHub Security] works to eliminate threats in a number of ways. Agents and services identify vulnerabilities in repositories and in dependent packages. They also upgrade dependencies to up-to-date, secure versions.
- [GitHub Actions][GitHub Actions] are custom workflows that provide continuous integration (CI) and continuous deployment (CD) capabilities directly in repositories. Computers called *runners* host these CI/CD jobs.
- [App Service][App Service] provides a framework for building, deploying, and scaling web apps. This platform offers built-in infrastructure maintenance, security patching, and scaling.
- [Azure Policy][Azure Policy] helps teams manage and prevent IT issues through policy definitions that can enforce rules for cloud resources. For instance, if your project is about to deploy a virtual machine with an unrecognized SKU, Azure Policy alerts you to the problem and stops the deployment.
- [Azure Security Center][Azure Security Center] provides unified security management and advanced threat protection across hybrid cloud workloads.
- [Azure Monitor][Azure Monitor] collects and analyzes app telemetry, such as performance metrics and activity logs. When this service identifies irregular conditions, it alerts apps and personnel.

### Security

[GitHub Security][GitHub Security] provides multiple features for addressing security risks:

- [Code scanning][GitHub code scanning] inspects code for known vulnerabilities and coding errors. As an example, if a developer leaves a database connection string exposed in code, this feature discovers the secret. After verifying its validity with the database, GitHub starts the process of obtaining an uncompromised string. These checks use [CodeQL][CodeQL], a code analysis platform that improves upon traditional analyzers by treating code as data. Scans automatically run at scheduled times or after certain events occur, like commits or pushes.
- [GitHub Dependabot][GitHub Dependabot] checks for outdated or vulnerable packages and applications. This automated agent updates software, replacing out-of-date or insecure dependencies with newer, secure versions. For instance, if your project uses an open-source library, Dependabot examines that library. Suppose the library doesn't encrypt sensitive cleartext that it stores in a database. In this case, Dependabot creates a PR to upgrade the library to a version that encrypts the data.
- [Vulnerability management][GitHub vulnerability management] identifies and updates known vulnerabilities in code and in software packages that the code uses. It runs checks whenever the following events occur:

  - A repository's dependencies change (for instance, when a project switches from .NET to .NET Core).
  - A notification appears from [WhiteSource][WhiteSource]. This third-party service tracks vulnerabilities by continuously scanning open-source repositories.
  - A new vulnerability enters the [GitHub Advisory Database][GitHub Advisory Database]. Entries in this database originate from the following sources:

    - The [National Vulnerability Database][National Vulnerability Database]: A standardized repository of vulnerabilities that the U.S. government maintains.
    - [GitHub tracking][GitHub tracking]: A combination of machine learning and human review that GitHub conducts to detect vulnerabilities in public commits.
    - [GitHub security advisories][GitHub security advisories]: Information about vulnerabilities that development teams make public on GitHub.
    - [PHP Security Advisories Database][PHP Security Advisories Database]: References to known security vulnerabilities in PHP projects and libraries.  

When GitHub identifies a vulnerability, it takes the steps illustrated in the following diagram.
:::image type="complex" source="../media/devsecops-in-github-vulnerability-management-data-flow.png" alt-text="Architecture diagram illustrating the chain of events that the identification of a vulnerability triggers, including alerts, upgrades, and deployment." border="false":::
    Architecture diagram illustrating a chain of events in a GitHub DevSecOps implementation. At the outset, GitHub identifies a vulnerability and sends an email alert. Dependabot then creates a branch, updates the vulnerability source, and creates a PR. The branch merges. In the final step, GitHub Actions deploy the new app.
:::image-end:::
*Download an [.svg][Vulnerability management in GitHub svg] of this diagram.*

1. GitHub sends an email alert to the organization owners and repository administrators.
1. GitHub Dependabot, a DevOps bot agent, automatically completes the following three tasks:
    1. Creates a new branch in the repository.
    1. Upgrades the necessary dependencies to the minimum possible secure version needed to eliminate the vulnerability.
    1. Creates a PR with the upgraded dependency.
1. When the PR is approved, the new branch merges with the base branch.
1. The merged branch triggers CI/CD tasks in GitHub Actions.
1. GitHub Actions deploy the new app version to a test or staging environment.

## Considerations

To keep GitHub DevSecOps solutions aligned with the tenets of the [Azure Well-Architected Framework][Azure Well-Architected Framework], consider the following points when deciding how to implement this pattern.

### Cost optimization

- GitHub bills customers for GitHub Actions by the minute. In addition, the choice of operating system that hosts Actions jobs affects the per-minute consumption rate and per-minute cost. Wherever possible, choose Linux to host Actions. See [About billing for GitHub actions][About billing for GitHub actions].
- Project managers on tight schedules may worry that adding security measures will delay development. Experience the opposite by saving time with these guidelines:
  - Shift testing left, closer to the source. Teams make fewer mistakes as a result.
  - Address issues during programming, rather than months down the line in production. Then developers don't need to refresh their knowledge of the code.

### Operational excellence

- Run automated tests and maintenance in environments that use vulnerability management capabilities, since these capabilities change code and its dependencies on your behalf. Automated testing identifies any issues that result from these changes.
- Take advantage of Azure Policy features. Besides denying deployments and logging compliance issues, these policies can also modify resources, making them compliant, even if they aren't deployed that way. For example, if you try to deploy a storage account in Azure that uses HTTP, Azure Policy detects the situation. Policies can then automatically change the deployment and force the storage account to use HTTPS.
- Azure Resource Manager uses JSON templates to describe the resources involved in deployment. Teams can also manage these template documents by using DevOps tools, like version control, code collaboration, and CI/CD workflows.
- One concern with DevSecOps is that code scans can generate noisy results filled with false positives, leading to the following types of problems:
  - Developers waste time investigating nonexistent problems.
  - Addressing security issues interrupts workflow.
  - Having lost trust in security tools because of the inaccuracies, developers ignore results.  

  Overcome these obstacles by integrating security into the software lifecycle:
  - Employ tools like Codespaces that embed scanning checks in IDEs, meaning developers use them in familiar environments.
  - Make security checks a regular part of code reviews instead of an afterthought.
  - Put developers in charge of high-precision scans, but leave noisier checks to security teams.

### Performance efficiency

For long-running or complex Actions, host your own runners for CI/CD jobs. You can then choose computers with powerful processing capabilities and ample memory. See [About self-hosted runners][About self-hosted runners].

### Reliability

- If you work with the on-premises deployment of GitHub.com that [GitHub Enterprise Server][GitHub Enterprise Server] provides, use a [highly available failover configuration][GitHub Enterprise highly available failover configuration] for increased resiliency.
- If you opt for self-hosted Actions runners, consider distributing them geographically.

### Security

- Using self-hosted Actions runners for public repositories isn't advised. A malicious user could join your repo and create a PR that runs unsafe code on computers in your network. GitHub-hosted runners remove this risk.
- Scan your code using the CodeQL analysis engine. CodeQL can discover potential vulnerabilities and coding errors. It can run both on a schedule and when events occur, such as a commit or a PR creation. See [About code scanning][GitHub code scanning].
- Make sure to [configure Dependabot security updates][Configure Dependabot security updates], which can remove known threats from projects.
- You can augment the code-scanning capabilities of GitHub by adding [GitHub third-party code-scanning tools][GitHub code scanning] that produce Static Analysis Results Interchange Format (SARIF) files. GitHub then creates alerts when those tools identify potential security issues.

## Next steps

- [Training materials, tools, and other resources on GitHub DevSecOps][GitHub DevSecOps training materials]
- [Tips for getting started with GitHub DevSecOps][GitHub DevSecOps getting started tips]

## Related resources

- [DevSecOps in Azure][DevSecOps in Azure]
- [Shift left][Shift left]
- [Fail fast][Fail fast]
- [SARIF files][SARIF]

[Shift left]: https://devops.com/devops-shift-left-avoid-failure/
[Fail fast]: https://whatis.techtarget.com/definition/fail-fast
[DevSecOps in GitHub svg]: ../media/devsecops-in-github.svg
[Microsoft Authenticator]: /azure/active-directory/user-help/user-help-auth-app-overview
[FIDO2 security keys]: /azure/active-directory/authentication/concept-authentication-passwordless#fido2-security-keys
[FIDO Alliance]: https://fidoalliance.org/
[Azure AD]: /azure/active-directory/fundamentals/active-directory-whatis
[Microsoft 365]: https://www.microsoft.com/microsoft-365/what-is-microsoft-365
[GitHub]: https://docs.github.com/en/github
[Inner source]: https://resources.github.com/whitepapers/introduction-to-innersource/
[Codespaces]: https://docs.github.com/en/github/developing-online-with-codespaces/about-codespaces
[Visual Studio Code]: https://code.visualstudio.com/
[GitHub Security]: https://github.com/features/security
[GitHub Actions]: https://docs.github.com/en/actions/getting-started-with-github-actions/about-github-actions
[App Service]: https://azure.microsoft.com/services/app-service/
[Azure Policy]: /azure/governance/policy/overview
[Azure Security Center]: /azure/security-center/security-center-intro
[Azure Monitor]: /azure/azure-monitor/overview
[GitHub code scanning]: https://docs.github.com/en/github/finding-security-vulnerabilities-and-errors-in-your-code/about-code-scanning
[CodeQL]: https://securitylab.github.com/tools/codeql
[GitHub Dependabot]: https://docs.github.com/en/free-pro-team@latest/github/administering-a-repository/about-dependabot-version-updates
[GitHub vulnerability management]: https://docs.github.com/en/github/managing-security-vulnerabilities
[WhiteSource]: https://www.whitesourcesoftware.com/
[GitHub Advisory Database]: https://github.com/advisories
[National Vulnerability Database]: https://nvd.nist.gov/
[GitHub tracking]: https://docs.github.com/en/github/managing-security-vulnerabilities/browsing-security-vulnerabilities-in-the-github-advisory-database#about-the-github-advisory-database
[GitHub security advisories]: https://docs.github.com/en/github/managing-security-vulnerabilities/about-github-security-advisories
[PHP Security Advisories Database]: https://github.com/FriendsOfPHP/security-advisories
[Vulnerability management in GitHub svg]: ../media/devsecops-in-github-vulnerability-management-data-flow.svg
[Azure Well-Architected Framework]: ../../framework/index.md
[About billing for GitHub actions]: https://docs.github.com/en/github/setting-up-and-managing-billing-and-payments-on-github/about-billing-for-github-actions
[About self-hosted runners]: https://docs.github.com/en/actions/hosting-your-own-runners/about-self-hosted-runners
[GitHub Enterprise Server]: https://azuremarketplace.microsoft.com/marketplace/apps/github.githubenterprise
[GitHub Enterprise highly available failover configuration]: https://docs.github.com/en/enterprise/2.21/admin/enterprise-management/about-high-availability-configuration
[Configure Dependabot security updates]: https://docs.github.com/en/github/managing-security-vulnerabilities/configuring-github-dependabot-security-updates
[DevSecOps in Azure]: ./devsecops-in-azure.yml
[GitHub DevSecOps training materials]: https://github.com/devsecops/awesome-devsecops
[GitHub DevSecOps getting started tips]: https://resources.github.com/whitepapers/Architects-guide-to-DevOps/
[SARIF]: https://docs.github.com/en/github/finding-security-vulnerabilities-and-errors-in-your-code/sarif-support-for-code-scanning