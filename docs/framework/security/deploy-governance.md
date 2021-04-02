---
title: Governance considerations for secure deployment in Azure
description: Governance for CI/CD pipelines to make sure right access and work is executed. 
author: PageWriter-MSFT
ms.date: 03/26/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-devops
categories:
  - security
---


# Governance considerations for secure deployment in Azure

The automated continuous integration, continuous delivery (CI/CD) processes reduce the need for central authority. However, that doesn't mean zero governance. 

## Key points

- Clearly define CI/CD roles and permissions.
- Implement just-in-time privileged access management.
- Limit long-standing write access to production environments only to service principals.
- Limit the scope of execution in the pipelines. 
- Configure quality gate approvals in DevOps release process.


## Minimize access

Minimize the number of people who have access to secure information or resources. This strategy will reduce the chance of a malicious actor gaining access or an authorized user inadvertently impacting a sensitive resource. Here are some considerations:

- Use the principle of least privilege when assigning roles and permissions. Only users responsible for production releases should start the process and only developers should access the source code.

    A pipeline should execute and consume one or more service principals. Ideally, they should be managed identity, and delivered by the platform and never used directly within a pipeline. The identity should only have the Azure RBAC permissions necessary to do the task. All service principals should be bound to that pipeline and not shared across pipelines. 

    **How do you define CI/CD roles and permissions?**
    ***

    Azure DevOps offers built-in roles that can be assigned to individual users of groups. Variable groups can contain sensitive configuration information and can be protected. If built-in roles are insufficient to define least privilege for a pipeline, consider creating custom Azure RBAC roles. Make sure those roles align with the action and the organization's teams and responsibilities.

    For more information, see [Get started with permissions, access, and security groups](/azure/devops/organizations/security/about-permissions?view=azure-devops&tabs=preview-page&preserve-view=true).

- Use separate pipeline identities between pre-production and production environments. If available, take advantage of pipeline features such as Environments to encapsulate last-mile authentication external to the executing pipeline.

- If the pipeline runs infrequently and has high privileges, consider removing standing permissions for that identity. Use just-in-time (JIT) role assignments, time-based, and approval-based role activation. This strategy will mitigate the risks of excessive, unnecessary, or misused access permissions on crucial resources. [Azure AD Privileged Identity Management](/azure/active-directory/privileged-identity-management/pim-configure) supports all those modes of activation.   

## Execution scope

Where practical, limit the scope of execution in the pipelines. 

Consider creating a multi-stage pipeline. Divide the work into discrete units and that can be isolated in a separate pipeline. Limit the identities only to the scope of the unit so that it has minimal privileges enough to do the action. For example, you can have two units, one that builds source code and another to deploy. Only allow the deploy unit to have access to the identity, not the build unit. If the build unit is compromised, it could start tampering with the infrastructure. 

## Gated approval process

**Do you have release gate approvals configured in the DevOps release process?**
***
Pull Requests and code reviews serve as the first line of approvals during development cycle. Before releasing an update to any environment (including pre-production), have a process that aligns with a documented security review and approval process.

Make sure that you involve the security team in the planning, design, and DevOps process. This collaboration will help them implement security controls, auditing, and response processes. 

**Are branch policies used in source control management of this workload? How are they configured?**
***

Establish branch policies that provide an extra level of control over the code that is committed to the repository. It's a common practice to deny pushes to the main branch if the change isn't approved. For example, you can require pull-request (PR) with code review before merging the changes by at least one reviewer, other than the change author. 

Having multiple branches is recommended where each branch has a purpose and access level. For example, feature branches are created by developers and are open to push. Integration branch requires PR and code-review. Production branch requires another approval from the team lead before merging.

> [!div class="nextstepaction"]
> [Secure code deployments](./deploy-code.md)


## Related links


> Go back to the main article: [Secure deployment and testing in Azure](deploy.md)
