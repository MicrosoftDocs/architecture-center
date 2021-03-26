---
title: Code deployment security considerations in Azure
description: Security strategy for automated deployment pipelines. 
author: PageWriter-MSFT
ms.date: 03/26/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
product:
  - azure-devops
categories:
  - security
---

# Code deployments

The automated build and release pipelines should update a workload to a new version seamlessly without breaking dependencies. Augment the automation with processes that allow high priority fixes to get deployed quickly.

## Key points

- Automated deployment pipelines should allow for quick roll-forward and rollback deployments to address critical bugs and code updates outside of the normal deployment lifecycle.
- Integrate code scanning tools within CI/CD pipeline.

## Rollback and roll-forward

If something goes wrong, the workload should roll back to a previous working version. N-1 and N+1 refer to roll back and roll-forward versions.

**Can N-1 or N+1 versions be deployed via automated pipelines where N is current deployment version in production?**
***

Because security updates are a high priority, design a pipeline that supports regular updates and critical security fixes. 

A release is typically associated with approval processes with multiple sign-offs, quality gates, and so on. If the workload deployment is small with minimal approvals, you can usually use the same process and pipeline to release a security fix.   
    
If the approval process is complex and takes a significant amount of time that could delay a fix, consider having an emergency pipeline that might not include all the gated approvals but can push out the fix quickly. The pipeline should allow for quick roll-forward and rollback deployments that address security fixes, critical bugs, and code updates outside of the regular deployment life cycle.

Involve the security team in the planning and design of the DevOps process. Ideally, design an automated pipeline with a degree of flexibility that supports regular and emergency deployments. 

## Credential scanning
Credentials, keys, certificates grant access to the data or service used by the workload. Storing credentials in code will introduce security vulnerabilities.	

**Are code scanning tools an integrated part of the continuous integration (CI) process for this workload?**
***
To prevent credentials from being stored in the source code or configuration files, integrate code scanning tools within the CI/CD pipeline. 
- During design time, use code analyzers to prevent credentials from getting pushed to the source code repository. For example, .NET Compiler Platform (Roslyn) Analyzers inspect your C# or Visual Basic code. 
- During the build process, use pipeline add-ons to catch credentials in the source code. An option is [Credential Scanner (CredScan)](https://secdevtools.azurewebsites.net/helpcredscan.html) that is part of Microsoft Security Code Analysis.
- Scan all dependencies, such as third-party libraries and framework components, as part of the CI process. Investigate vulnerable components that are flagged by the tool. Combine this task with other code scanning tasks that inspect code churn, test results, and coverage.

> [!div class="nextstepaction"]
> [Secure infrastructure deployments](./deploy-infrastructure.md)