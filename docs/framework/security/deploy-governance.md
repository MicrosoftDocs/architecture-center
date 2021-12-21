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
subject:
  - security
---

# Governance considerations for secure deployment in Azure

The automated continuous integration, continuous delivery (CI/CD) processes must have built-in governance that authorize and authenticate the identities to do the tasks within a defined scope.

## Key points

> [!div class="checklist"]
> - Clearly define CI/CD roles and permissions.
> - Implement just-in-time privileged access management.
> - Limit long-standing write access to production environments.
> - Limit the scope of execution in the pipelines.
> - Configure quality gate approvals in DevOps release process.

## Minimize access

Minimize the number of people who have access to secure information or resources. This strategy will reduce the chance of a malicious actor gaining access or an authorized user inadvertently impacting a sensitive resource. Here are some considerations:

- Use the principle of least privilege when assigning roles and permissions. Only users responsible for production releases should start the process and only developers should access the source code.

    A pipeline should use one or more service principals. Ideally, they should be managed identity, and delivered by the platform and never directly defined within a pipeline. The identity should only have the Azure RBAC permissions necessary to do the task. All service principals should be bound to that pipeline and not shared across pipelines.

    **How do you define CI/CD roles and permissions?**
    ***

    Azure DevOps offers built-in roles that can be assigned to individual users of groups. If built-in roles are insufficient to define least privilege for a pipeline, consider creating custom Azure RBAC roles. Make sure those roles align with the action and the organization's teams and responsibilities.

    To support security of your pipeline operations, you can add users to a built-in security group, set individual permissions for a user or group, or add users to pre-defined roles. You manage security for the following objects from Azure Pipelines in the web portal, either from the user or admin context.

    For more information, see [Get started with permissions, access, and security groups](/azure/devops/organizations/security/about-permissions?view=azure-devops&tabs=preview-page&preserve-view=true).

- For permissions, you grant or restrict permissions by setting the permission state to **Allow** or **Deny**, either for a security group or an individual user. For a role, you add a user or group to the role.

- Use separate pipeline identities between pre-production and production environments. If available, take advantage of pipeline features such as Environments to encapsulate last-mile authentication external to the executing pipeline.

- If the pipeline runs infrequently and has high privileges, consider removing standing permissions for that identity. Use just-in-time (JIT) role assignments, time-based, and approval-based role activation. This strategy will mitigate the risks of excessive, unnecessary, or misused access permissions on crucial resources. [Azure AD Privileged Identity Management](/azure/active-directory/privileged-identity-management/pim-configure) supports all those modes of activation.

- Review the organization's CI/CD pipeline and refine role assignment to create a clear delineation between development and production responsibilities.

**Learn more**

For more information about pipeline permission and security roles, reference [Set different levels of pipeline permissions](/azure/devops/pipelines/policies/permissions?view=azure-devops&preserve-view=true).

## Execution scope

Where practical, limit the scope of execution in the pipelines.

Consider creating a multi-stage pipeline. Divide the work into discrete units and that can be isolated in a separate pipeline. Limit the identities only to the scope of the unit so that it has minimal  privileges enough to do the action. For example, you can have two units, one to deploy and another that builds source code. Only allow the deploy unit to have access to the identity, not the build unit. If the build unit is compromised, it could start tampering with the infrastructure.

## Gated approval process

**Do you have release gate approvals configured in the DevOps release process?**
***
Pull Requests and code reviews serve as the first line of approvals during development cycle. Before releasing an update to production, require a process that mandates security review and approval.

Make sure that you involve the security team in the planning, design, and DevOps process. This collaboration will help them implement security controls, auditing, and response processes.

**Are branch policies used in source control management of this workload? How are they configured?**
***
Establish branch policies that provide an extra level of control over the code that is committed to the repository. Lack of secure branch policy might allow poor, rogue or broken code to be checked-in and deployed. It's a common practice to deny pushes to the main branch if the change isn't approved. For example, you can require pull-request (PR) with code review before merging the changes by at least one reviewer, other than the change author.

Having multiple branches is recommended where each branch has a purpose and access level. For example, feature branches are created by developers and are open to push. Integration branch requires PR and code-review. Production branch requires another approval from the team lead before merging.

### Suggested actions

- Configure quality gate approvals in DevOps release process.
- Follow the guidance in the linked articles to deploy and adopt branch strategy.

## Learn more

- [About branches and branch policies](/azure/devops/repos/git/branch-policies-overview?view=azure-devops&preserve-view=true)
- [Adopt a Git branching strategy](/azure/devops/repos/git/git-branching-guidance?view=azure-devops&preserve-view=true)
- [Release deployment control using gates](/azure/devops/pipelines/release/approvals/gates?view=azure-devops&preserve-view=true)

## Next

> [!div class="nextstepaction"]
> [Secure infrastructure deployments](./deploy-infrastructure.md)

## Related links

> Go back to the main article: [Secure deployment and testing in Azure](deploy.md)
