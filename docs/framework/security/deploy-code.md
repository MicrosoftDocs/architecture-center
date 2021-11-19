---
title: Code deployment security considerations in Azure
description: Security strategy for automated deployment pipelines.
author: PageWriter-MSFT
ms.date: 03/26/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-devops
categories:
  - security
subject:
  - security
---

# Code deployments

The automated build and release pipelines should update a workload to a new version seamlessly without breaking dependencies. Augment the automation with processes that allow high priority fixes to get deployed quickly.

Organizations should leverage existing guidance and automation when securing applications in the cloud, rather than starting from zero. Using resources and lessons learned by external organizations that are early adopters of these models can accelerate the improvement of an organizations security posture with less expenditure of effort and resources.

## Key points

> [!div class="checklist"]
> - Involve the security team in the planning and design of the DevOps process to integrate preventive and detective controls for security risks.
> - Design automated deployment pipelines that allow for quick roll-forward and rollback deployments to address critical bugs and code updates outside of the normal deployment lifecycle.
> - Integrate code scanning tools within CI/CD pipeline.

## Rollback and roll-forward

If something goes wrong, the pipeline should roll back to a previous working version. N-1 and N+1 refer to rollback and roll-forward versions. Automated deployment pipelines should allow for quick roll-forward and rollback deployments to address critical bugs and code updates outside of the normal deployment lifecycle.

**Can N-1 or N+1 versions be deployed via automated pipelines where N is current deployment version in production?**
***

Because security updates are a high priority, design a pipeline that supports regular updates and critical security fixes.

A release is typically associated with approval processes with multiple sign-offs, quality gates, and so on. If the workload deployment is small with minimal approvals, you can usually use the same process and pipeline to release a security fix.

An approval process that is complex and takes a significant amount of time can delay a fix. Consider building an emergency process to accelerate high priority fixes. The process might be business and, or communication process between teams. Another way is to build a pipeline that might not include all the gated approvals, but should be able to push out the fix quickly. The pipeline should allow for quick roll-forward and rollback deployments that address security fixes, critical bugs, and code updates outside of the regular deployment life cycle.

> [!IMPORTANT]
> Deploying a security fix is a priority, but it shouldn't be at the cost of introducing a regression or bug. When designing an emergency pipeline, carefully consider which automated tests can be bypassed. Evaluate the value of each test against the execution time. For example, unit tests usually complete quickly. Integration or end-to-end tests can run for a long time.

Involve the security team in the planning and design of the DevOps process. Your automated pipeline design should have the flexibility to support both regular and emergency deployments. This is important to support the rapid and responsible application of both security fixes and other urgent, important fixes.

### Suggested action

Implement an automated deployment process with support for rollback scenarios via Azure App Services deployment slots.

**Learn more**

[Set up staging environments in Azure App Service](/azure/app-service/deploy-staging-slots)

## Credential scanning

Credentials, keys, and certificates grant access to the data or service used by the workload. Storing credentials in code poses a significant security risk. Ensure that static code scanning tools are an integrated part of the continuous integration (CI) process.

**Are code scanning tools an integrated part of the continuous integration (CI) process for this workload?**
***
To prevent credentials from being stored in the source code or configuration files, integrate code scanning tools within the CI/CD pipeline:

- During design time, use code analyzers to prevent credentials from getting pushed to the source code repository. For example, .NET Compiler Platform (Roslyn) Analyzers inspect your C# or Visual Basic code.
- During the build process, use pipeline add-ons to catch credentials in the source code. Some options include [GitHub Advanced Security](https://docs.github.com/en/github/getting-started-with-github/about-github-advanced-security) and [OWASP source code analysis tools](https://owasp.org/www-community/Source_Code_Analysis_Tools).
- Scan all dependencies, such as third-party libraries and framework components, as part of the CI process. Investigate vulnerable components that are flagged by the tool. Combine this task with other code scanning tasks that inspect code churn, test results, and coverage.
- Use a combination of dynamic application security testing (DAST) and static application security testing (SAST). DAST tests the application while its in use. SAST scans the source code and detects vulnerabilities based on its design or implementation. Some technology options are provided by OWASP. For more information, see [SAST Tools](https://owasp.org/www-community/Source_Code_Analysis_Tools) and [Vulnerability Scanning Tools](https://owasp.org/www-community/Vulnerability_Scanning_Tools).
- Use scanning tools that are specialized in technologies used by the workload. For example, if the workload is containerized, run container-aware scanning tools to detect risks in the container registry, before use, and during use.

## Suggested actions

Incorporate Secure DevOps on Azure toolkit and the guidance published by the Organization for Web App Security Project (OWASP), or an equivalent guiding organization.

## Learn more

- [Follow DevOps security guidance](./design-apps-services.md)
- [Getting started with Credential Scanner (CredScan)](https://secdevtools.azurewebsites.net/helpcredscan.html)

## Community links

- [OWASP source code analysis tools](https://owasp.org/www-community/Source_Code_Analysis_Tools)
- [GitHub Advanced Security](https://docs.github.com/en/github/getting-started-with-github/about-github-advanced-security)
- [Vulnerability Scanning Tools](https://owasp.org/www-community/Vulnerability_Scanning_Tools)

> Go back to the main article: [Secure deployment and testing in Azure](deploy.md)
