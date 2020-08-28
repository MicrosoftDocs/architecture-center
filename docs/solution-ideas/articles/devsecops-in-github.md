---
title: DevSecOps in GitHub
titleSuffix: Azure Solution Ideas
author: JKirsch1
ms.date: 08/21/2020
description: Making security principles and practices an integral part of DevOps while maintaining improved efficiency and productivity.
ms.custom: fcp
ms.service: architecture-center
ms.category:
  - devops
  - security
ms.subservice: solution-idea
ms.author: v-jenkir
social_image_url: /azure/architecture/solution-ideas/media/devsecops-in-github-data-flow.png
---

# DevSecOps in GitHub

Starting with the first steps of development, DevSecOps adheres to security best practices. By using a shift-left strategy, DevSecOps shifts the focus on security away from auditing at the end and toward development in the beginning.

With numerous security capabilities, GitHub offers tools that support every part of a DevSecOps workflow.

- Browser-based IDEs with built-in security extensions.
- Continuous monitoring of security advisories and replacement of vulnerable dependencies.
- Agents that maintain dependency trees and update out-of-date packages.
- Search capabilities that scan source code for vulnerabilities.
- Functionality that revokes or replaces tokens and credentials that are exposed in code.
- Action-based workflows that automate every step of development, testing, and deployment.
- Spaces that provide a way to privately discuss and resolve security vulnerabilities and then publish the information.

Combined with the monitoring and evaluation power of Azure, these features provide a superb service for building secure cloud solutions.

## Potential use cases

GitHub DevSecOps installations cover a verity of security scenarios. Possibilities include the following:

- Development teams that want to take advantage of pre-configured environments that offer security capabilities.
- Team leaders who rely on having up-to-date, prioritized security reports at their fingertips, delivered with detailed information on affected code and suggested fixes.
- Streamlined organizations that need systems to automatically procure new, uncompromised security devices when service tokens are left exposed in code.
- Developers with no time to sift through dependencies, who instead need tools that automate the tasks of tracking vulnerabilities and available upgrades.
- Administrators who count on the deployment process stopping automatically when risks are identified.
- Teams that could benefit from automatic upgrades when newer or more secure versions of external libraries become available.
- Developers who need code reverted when packages that they use violate at-rest encryption and potentially leak sensitive information.

## Architecture

![Architecture diagram highlighting the security checks that run in various GitHub and Azure components in a GitHub DevSecOps environment.](../media/devsecops-in-github-data-flow.png)
*Download an [.svg](https://github.com/fmigacz/devsecops-architecture/tree/master/media/devsecops-in-github.svg) of this architecture.*

1. Developers accessing GitHub resources are redirected to Azure AD for authentication using the SAML protocol. The organization enforces Single Sign-On (SSO) using FIDO2 strong authentication with the Microsoft Authenticator app.
1. Developers begin working on tasks in Codespaces. Organized into containers, these pre-built development environments provide correctly configured IDEs that are equipped with required security scanning extensions.
1. When new code is committed, GitHub Actions automatically scans the code to quickly find vulnerabilities and coding errors.
1. Pull requests trigger code builds and automated testing through GitHub Actions. GitHub encrypts secrets and credentials at rest and obfuscates these entries in logs.
1. GitHub Actions deploys build artifacts to App Service while making changes to other cloud resources, such as service endpoints.  
1. Azure Policy evaluates Azure resources that are in deployment and potentially denies releases, modifies cloud resources, or creates warning events in activity logs.
1. Azure Security Center identifies attacks targeting applications that are running in deployed projects.
1. Azure Monitor continuously tracks and evaluates app behavior. When conditions arise that pose risks to security or stability, this service reverts changes by rolling code back to previous commits.

## Components

- [Azure Active Directory](/azure/active-directory/fundamentals/active-directory-whatis) is a multi-tenant, cloud-based identity and access management service that controls access to Azure and other cloud apps like M365 and GitHub.
- [GitHub](https://docs.github.com/en/github) provides a code-hosting platform that developers can use for collaborating on both open source and innersource projects.
- [Codespaces](https://docs.github.com/en/github/developing-online-with-codespaces/about-codespaces) is an online development environment. Hosted by GitHub and powered by Visual Studio Code, this tool provides a complete development solution in the cloud.
- [GitHub Actions](https://docs.github.com/en/actions/getting-started-with-github-actions/about-github-actions) are custom workflows that provide continuous integration (CI) and continuous deployment (CD) capabilities directly in repositories.
- [App Service](https://azure.microsoft.com/services/app-service/) is a platform for building, deploying, and scaling web apps that provides built-in infrastructure maintenance, security patching, and scaling.
- [Azure Policy](/azure/governance/policy/overview) helps teams manage and prevent IT issues through policy definitions that can enforce rules for cloud resources. For instance, if your project is about to deploy a virtual machine with an unrecognized SKU, Azure Policy alerts you to the problem and stops the deployment.
- [Azure Security Center](/azure/security-center/security-center-intro) provides unified security management and advanced threat protection across hybrid cloud workloads.
- [Azure Monitor](/azure/azure-monitor/overview) collects and analyzes app telemetry, such as performance metrics and activity logs. When this service identifies irregular conditions, it alerts apps and personnel.
- GitHub Security works to eliminate vulnerabilities in repositories in multiple ways:

  - [Code scanning](https://docs.github.com/en/github/finding-security-vulnerabilities-and-errors-in-your-code/about-code-scanning) inspects code for known vulnerabilities and coding errors. As an example, if a developer leaves a database connection string exposed in code, this feature discovers the secret, verifies its validity with the database, and initiates the steps needed to secure an uncompromised string. These checks automatically run at scheduled times or after certain events occur, like commits or pushes, and use [CodeQl](https://securitylab.github.com/tools/codeql), a code analysis platform that improves upon traditional analyzers by treating code as data.
  - [GitHub Dependabot](https://docs.github.com/en/github/administering-a-repository/about-github-dependabot) checks for outdated or vulnerable packages and applications. This automated agent updates software, replacing out-of-date or insecure dependencies with newer versions. For instance, if Dependabot determines that an open-source library that your project uses does not encrypt sensitive cleartext before storing that information in a database, Dependabot creates a PR that upgrades the library to a version that encrypts the information.
  - [Vulnerability management](https://docs.github.com/en/github/managing-security-vulnerabilities) identifies and updates known vulnerabilities in code and in software packages that the code uses. It performs checks whenever the following events occur:

    - A repository's dependencies change (for instance, when a project switches from .NET to .NET Core).
    - A notification appears from [WhiteSource](https://www.whitesourcesoftware.com/). This third-party service tracks vulnerabilities by continuously scanning open source repositories.
    - A new vulnerability enters the [GitHub Advisory Database](https://docs.github.com/en/github/managing-security-vulnerabilities/browsing-security-vulnerabilities-in-the-github-advisory-database). Entries in this database originate from the following sources:

      - The [National Vulnerability Database](https://nvd.nist.gov/): A standardized repository of vulnerabilities that the U.S. government maintains.
      - [GitHub tracking](https://docs.github.com/en/github/managing-security-vulnerabilities/browsing-security-vulnerabilities-in-the-github-advisory-database#about-the-github-advisory-database): A combination of machine learning and human review that GitHub conducts to detect vulnerabilities in public commits.
      - [GitHub security advisories](https://github.com/features/security): Information about vulnerabilities that development teams make public on GitHub.
      - [PHP Security Advisories Database](https://github.com/FriendsOfPHP/security-advisories): References to known security vulnerabilities in PHP projects and libraries.  
  
  When GitHub identifies a *vulnerability*, it initiates the following data flow:
  ![Architecture diagram illustrating the chain of events that the identification of a vulnerability triggers, including alerts, upgrades, and deployment.](../media/devsecops-in-github-vulnerability-management-data-flow.png)
  *Download an [.svg](https://github.com/fmigacz/devsecops-architecture/tree/master/media/devsecops-in-github-vulnerability-management.svg) of this diagram.*

  1. GitHub sends an email alert to the organization owners and repository administrators.
  1. GitHub Dependabot, a DevOps bot agent, automatically performs the following three tasks:
      1. Creates a new branch in the repository.
      1. Upgrades the necessary dependencies to the minimum possible secure version needed to eliminate the vulnerability.
      1. Creates a pull request (PR) with the upgraded dependency.
  1. When the PR is approved, the new branch merges with the base branch.
  1. The merged branch triggers CI/CD tasks in GitHub Actions.
  1. GitHub Actions deploys the new app version to a test or staging environment.

## Considerations
Consider the following points when deciding how to implement this pattern:

- You can augment the code-scanning capabilities of GitHub by adding [third-party code-scanning tools](https://docs.github.com/en/github/finding-security-vulnerabilities-and-errors-in-your-code/about-code-scanning) that produce [Static Analysis Results Interchange Format (SARIF)](https://docs.github.com/en/github/finding-security-vulnerabilities-and-errors-in-your-code/sarif-support-for-code-scanning) files. GitHub then creates alerts when those tools identify potential security issues.
- One concern with DevSecOps is that code scans can generate noisy results filled with false positives, leading to the following types of problems:
  - Developers can waste time investigating nonexistent problems.
  - Addressing security issues often interrupts workflow.
  - Having lost trust in security tools because of the inaccuracies, developers start ignoring all results.  

  GitHub DevSecOps solves these problems by [integrating security into the software lifecycle](https://github.blog/2020-04-28-how-to-build-an-effective-devsecops-culture/) in the following ways:
  - Embedding scanning tools in IDEs, the way CodeSpaces does, so developers use them in familiar environments.
  - Making security checks a regular part of code reviews instead of an afterthought.
  - Being smart about running scans: [Putting developers in charge of high-precision ones but leaving noisier checks to security teams.](https://github.blog/2020-08-27-secure-at-every-step-putting-devsecops-into-practice-with-code-scanning/)
- Project managers on tight schedules may worry that adding security measures will delay development. However, [GitHub DevSecOps implementations often observe the opposite](https://github.blog/2020-08-13-secure-at-every-step-a-guide-to-devsecops-shifting-left-and-gitops/):
  - Teams save time by making fewer mistakes when testing shifts left, closer to the source.
  - When developers address issues during programming, rather than months down the line in production, they don't need to refresh their knowledge of the code.


## Tenets of the Azure Well-Architected Framework
The [Azure Well-Architected Framework](azure/architecture/framework/) provides a set of guiding tenets that can improve the quality of workloads. The framework consists of five pillars of architecture excellence: Cost Optimization, Operational Excellence, Performance Efficiency, Reliability, and Security.

### Cost Optimization
* GitHub Actions is billed by the minute. The per-minute consumption rate and per-minute cost are both affected by the choice of operating system used to host Actions jobs. Wherever possible, choose Linux to host your Actions. See [About billing for GitHub Actions](https://docs.github.com/en/github/setting-up-and-managing-billing-and-payments-on-github/about-billing-for-github-actions).

### Operational Excellence
* It is best to have automated tests and maintenance running in your environment. Especially with the Vulnerability Management capabilities, which can change your code (or its dependencies) on your behalf. Automated testing will identify issues with these changes.
* Azure Policy can do more than just deny your deployments or log compliance issues. It can modify your resources to become compliant, even if they aren't deployed that way. For example, if you try to deploy a storage account in Azure that listens to HTTP, Azure Policy can automatically change the deployment and force the storage account to only listen to HTTPS.
* Azure Resource Manager uses JSON templates to describe the resources involved in a deployment. These template documents can also by managed by teams using DevOps tools (like version control, code collaboration, and CI/CD workflows).

### Performance Efficiency
* For long-running or complex Actions, consider hosting your own "runners". GitHub runners are the computers that host CI/CD jobs. Using your own hosted runners, you can use computers with more processing power or memory. See [About self-hosted runners](https://docs.github.com/en/actions/hosting-your-own-runners/about-self-hosted-runners).

### Reliability
* GitHub Enterprise Server can run in a highly available failover configuration. Self-hosted Actions runners can also be distributed geographically. See [About high availability configuration](https://docs.github.com/en/enterprise/2.21/admin/enterprise-management/about-high-availability-configuration).

### Security
* Using self-hosted Actions runners for public repositories is not advised. A malicious user could join your repo and create a pull request that runs untrusted code on computers in your network. Using GitHub-hosted runners prevents this risk.
* Scan your code using the CodeQL analysis engine. CodeQL can discover potential vulnerabilities and coding errors on a schedule, and/or when events occur (like a commit or a pull request). See [About code scanning](https://docs.github.com/en/github/finding-security-vulnerabilities-and-errors-in-your-code/about-code-scanning).
* Dependabot security updates remove a lot risk from using known exploits in your projects. Make sure to configure them, see [Configuring GitHub Dependabot security updates](https://docs.github.com/en/github/managing-security-vulnerabilities/configuring-github-dependabot-security-updates).


