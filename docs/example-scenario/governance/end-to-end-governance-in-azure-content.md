<!-- cSpell:ignore devsecops -->
When developing a governance model for your organization, it's important to remember that Azure Resource Manager is only _one_ way to manage resources. When introducing Azure DevOps and continuous integration and continuous delivery (CI/CD) automation, it's important to **mirror the Role Based Access Control (RBAC) model** on the Resource Manager side to the CI/CD side. Otherwise Azure DevOps will be the unintentional security back door.

This reference diagram and implementation uses [Azure DevOps](https://azure.microsoft.com/services/devops/). But the concept of end-to-end governance is vendor agnostic. Alternatives are briefly mentioned below.

## Use case and example business requirements

This reference implementation and demo is open source and intended to be used as a **teaching tool** for organizations who are new to DevOps and need to create a governance model for deploying to Azure. Please read this carefully to understand the decisions behind the model used in this sample repository.

Any governance model must be tied to the organization's business rules, which are reflected in any technical implementation of access controls. This example model uses a fictitious company with this is common scenario:

- **Azure AD Groups that align with Business Domains and Permissions Models**  
  The organization has many vertical business domain, such as "fruits" and "vegetables", which operate largely independently. In each business domain, there are two levels or privileges, which are mapped to distinct `*-admins` or `*-devs` Azure AD Groups. This allows developers to be targeted when configuring permissions in the cloud.

- **Deployment environments**  
  Every team has two environments:
  - Production: only admins have elevated privileges
  - Non-production: all developers have elevated privileges (to encourage experimentation and innovation)
  
- **Automation goals**
  Every application should implement Azure DevOps not just for continuous integration (CI), but also for continuous deployment (CD). For example, deployments can be automatically triggered by changes to the Git repository.

- **Cloud journey so far**  
  The organization started with an isolated project model to accelerate the journey to the cloud. But now they are exploring options to break silos and encourage collaboration by creating the "collaboration" and "supermarket" projects.

## Architecture

This diagram shows how linking from Resource Manager and CI/CD to Azure Active Directory (Azure AD) is the key to having an end-to-end governance model.

[ ![End-to-end governance overview with Azure Active Directory at the center](media/e2e-governance-overview-inline.png) ](media/e2e-governance-overview-inline.png#lightbox)
*Download an [SVG of this architecture](media/e2e-governance-overview.svg).*

Note: To make the diagram and concept more clear, it only illustrates the **"veggies"** domain. The "fruits" domain would look similar and use the same naming conventions.

### Components

The numbering reflects the other in which IT administrators and enterprise architects think about and configure their cloud resources.

1. **Azure Active Directory**  
  We integrate Azure DevOps with [Azure AD](https://azure.microsoft.com/services/active-directory/) to have a single plane for identity. This means a developer uses the same Azure AD account for both Azure DevOps and Resource Manager. Users are not added individually. Instead, membership is assigned by Azure AD groups so that we can remove a developer's access to resources in a single step&#8212;by removing their Azure AD group membership(s). For _each domain_, we will create:
    - Azure AD groups: two groups per domain (described further in #4 and #5 below)
    - Service principals: one explicit service principal _per environment_.
  
2. **Production environment**  
   To simplify deployment this reference implementation uses a resource group to represent the production environment. In practice you should use a [different subscription](https://docs.microsoft.com/azure/cloud-adoption-framework/govern/guides/standard/).

   Privileged Access to this environment is limited to administrators only.
  
3. **Development environment**  
   To simplify deployment this reference implementation uses a resource group to represent the development environment. In practice you should use a [different subscription](https://docs.microsoft.com/azure/cloud-adoption-framework/govern/guides/standard/).

4. **Role assignments in Resource Manager**  
   Although our Azure AD group names imply a role, access controls are not applied until we configure a [role assignment](https://docs.microsoft.com/azure/role-based-access-control/overview#role-assignments), which assigns a role to an Azure AD principal for a specific scope. For example, Developers have Contributor role on the Production environment.

   | Azure AD Principal | Dev Environment (Resource Manager) | Production Environment (Resource Manager) |
   |:--|:--|:--|
   | `veggies-devs-group` |  _Owner_ | Reader |
   | `veggies-admins-group` | Owner | Owner |
   | `veggies-ci-dev-sp` | _Custom Role \*_ | &#8212; |
   | `veggies-ci-prod-sp` | &#8212; | _Custom Role \*_ |

   \* To simplify deployment this reference implementation assigns the _Owner_ role to the service principals. However, in production you should create a _**Custom Role**_ that prevents a service principal from removing any [management locks](https://docs.microsoft.com/azure/azure-resource-manager/management/lock-resources) you may have placed on your resources (for example, to prevent a database from being deleted).

   To understand the reasoning behind the individual role assignments, please see [important considerations section](#important-considerations) below.

5. **Security group assignments in Azure DevOps**  
   Security groups function like roles in Resource Manager. We will take advantage of built-in roles and default to [Contributor](https://docs.microsoft.com/azure/devops/user-guide/roles?view=azure-devops#contributor-roles) for developers. Admins get assigned to the [Project Administrator](https://docs.microsoft.com/azure/devops/user-guide/roles?view=azure-devops#project-administrators) security group for elevated permissions, allowing them to configure security permissions.

   Please note that Azure DevOps and Resource Manager have _different_ permissions models:
    - Azure Resource Manager uses an [_additive_ permissions](https://docs.microsoft.com/azure/role-based-access-control/overview#multiple-role-assignments) model
    - Azure DevOps uses a [_least_ permissions](https://docs.microsoft.com/azure/devops/organizations/security/about-permissions?view=azure-devops&tabs=preview-page) model

    For this reason, membership to the `-admins` and `-devs` groups must be mutually exclusive. Otherwise the affected persons would have less access than expected in Azure DevOps.

    | Group name | Resource Manager role | Azure DevOps role |
    |:--|:--|:--|
    | `fruits-all` | &#8212; | &#8212; |
    | `fruits-devs` | Contributor | Contributor |
    | `fruits-admins` | Owner | Project Administrators |
    | `veggies-all` | &#8212; | &#8212; |
    | `veggies-devs` | Contributor | Contributor |
    | `veggies-admins` | Owner | Project Administrators |
    | `infra-all` | &#8212; | &#8212; |
    | `infra-devs` | Contributor | Contributor |
    | `infra-admins` | Owner | Project Administrators |

    Anticipating a scenario for limited collaboration, for example the fruits team invites the veggies team to collaborate on a _single_ repository, then they would use the `veggies-all` group.

    To understand the reasoning behind the individual role assignments, please refer to the [important considerations section](#important-considerations) below.

6. **Service Connections**  
   In Azure DevOps, a [Service Connection](https://docs.microsoft.com/azure/devops/pipelines/library/service-endpoints?view=azure-devops&tabs=yaml) is a generic wrapper around a credential. We create a service connection that holds the service principal Client ID and Client Secret. Project Administrators can configure access to this [protected resource](https://docs.microsoft.com/azure/devops/pipelines/security/resources?view=azure-devops#protected-resources), for example requiring human approval before deploying. This reference architecture has two minimum protections on the Service Connection:
   - Admins must configure [pipeline permissions](https://docs.microsoft.com/azure/devops/pipelines/security/resources?view=azure-devops#pipeline-permissions) to control which pipelines can access the credentials.
   - Admins must also configure a [branch control check](https://docs.microsoft.com/azure/devops/pipelines/process/approvals?view=azure-devops&tabs=check-pass#branch-control) so that only pipelines running in the context of the `production` branch may use the `prod-connection`.

7. **Git repositories**  
   Since our service connections are tied to branches via [branch controls](https://docs.microsoft.com/azure/devops/pipelines/process/approvals?view=azure-devops&tabs=check-pass#branch-control), it's critical to configure permissions to the Git repositories and apply [branch policies](https://docs.microsoft.com/azure/devops/repos/git/branch-policies?view=azure-devops). In addition to requiring CI builds to pass, we will also require pull requests with at least 2 approvers.

## Goal: end-to-end governance

### From developer's computer to Production in Azure

The following diagram illustrates a baseline CI/CD workflow with Azure DevOps. The red lock icon :::image type="icon" source="media/e2e-governance-devsecops-gear.svg"::: indicates security permissions which must be configured by the user. Not configuring or mis-configuring permissions will leave your workloads vulnerable.

[ ![Diagram illustrating a baseline CI/CD workflow with Azure DevOps](media/e2e-governance-devsecops-workflow-inline.png) ](media/e2e-governance-devsecops-workflow-lrg.png#lightbox)
*Download an [SVG of this workflow](media/e2e-governance-devsecops-workflow.svg).*

To successfully secure your workloads, you must use a combination of security permission configurations and human checks in your workflow. It's important that any RBAC model must also extend to pipelines and code, which often run with privileged identities and will happily destroy your workloads if instructed to do so in the pipeline code. To prevent this from happening, you should configure [branch policies](https://docs.microsoft.com/azure/devops/repos/git/branch-policies?view=azure-devops) on your repository to require human approval before accepting changes that trigger automation pipelines.

| Deployment stages | Responsibility | Description |
|:--|:--|:--|
| **Pull requests** | User | Engineers should peer review their work, including the Pipeline code itself. |
| **Branch protection** | [Shared](https://docs.microsoft.com/azure/security/fundamentals/shared-responsibility) | Configure [Azure DevOps](https://docs.microsoft.com/azure/devops/repos/git/branch-policies?view=azure-devops) to reject changes that do not meet certain standards, such as CI checks and peer reviews (via pull requests). |
| **Pipeline as code** | User | A build server will happily delete your production environment if the pipeline code instructs it to do so. Prevent this using a combination of pull requests and branch protection rules, such as human approval. |
| **[Service connections](https://docs.microsoft.com/azure/devops/pipelines/library/service-endpoints?view=azure-devops&tabs=yaml)** | [Shared](https://docs.microsoft.com/azure/security/fundamentals/shared-responsibility) | Configure Azure DevOps to restrict access to these credentials. |
| **Azure Resources** | [Shared](https://docs.microsoft.com/azure/security/fundamentals/shared-responsibility) | Configure RBAC in the Resource Manager. |

Before examining the governance layers in detail, please consider the use case and assumptions of this example organization described above.

## Important considerations

Note: this is only a reference implementation of a relatively simple use case.

### 1. Safeguard your environments with branch policies

Because your source code defines and triggers deployments, your first line of defense is to secure your source code management (SCM) repository. In practice, this is achieved by using the [Pull Request workflow](https://docs.microsoft.com/azure/devops/repos/git/pull-requests-overview?view=azure-devops) in combination with [branch policies](https://docs.microsoft.com/azure/devops/repos/git/branch-policies?view=azure-devops), which define checks and requirements before code can be accepted.

When planning your end-to-end governance model, your privileged users (`veggies-admins`) will be responsible for configuring branch protection. Common branch protection checks used to secure your deployments include:

- **Require CI build to pass**
  Useful for establishing baseline code quality, such code linting, unit tests, and even security checks like virus and credential scans.

- **Require peer review**  
  Have another human double check that code works as intended. Be extra careful when changes are made to pipeline code. Combine with CI builds to make peer reviews less tedious.

#### What happens if a developer tries to push directly to production?

Remember that Git is a distributed SCM system. A developer may choose to commit directly to their local `production` branch. But when configured, this push can be rejected by the Git server. For example:

```console
remote: Resolving deltas: 100% (3/3), completed with 3 local objects.
remote: error: GH006: Protected branch update failed for refs/heads/main.
remote: error: Required status check "continuous-integration" is expected.
To https://github.com/Azure/devops-governance
 ! [remote rejected] main -> main (protected branch hook declined)
error: failed to push some refs to 'https://github.com/Azure/devops-governance'
```

Please note that the workflow above is vendor agnostic. The pull request and branch protection features are available from multiple SCM providers including [Azure Repos](https://azure.microsoft.com/services/devops/repos/), [GitHub](https://github.com) and [GitLab](https://gitlab.com).

Once the code has been accepted into a protected branch the next layer of access controls will be applied by the build server (such as [Azure Pipelines](https://azure.microsoft.com/services/devops/pipelines/)).

### 2. What access do Security Principals need?

In Azure a [security principal](/azure/role-based-access-control/overview#security-principal) can be either a User Principal or headless principal:  Service Principal or Managed Identity.

#### Non-production environments: everyone is an Owner

In this demo use case, the organization wants developers to be able to iterate quickly, which is why developers are given _Owner_ privileges so they can test configuration.
  
#### Production environments: principle of least privilege

- Admins have the [Owner](https://docs.microsoft.com/azure/role-based-access-control/built-in-roles#owner) role in Production, allowing them to adjust security configurations
- Developers are given [Contributor](https://docs.microsoft.com/azure/role-based-access-control/built-in-roles#contributor) access, allowing them to directly troubleshoot instead of using CI/CD. Other organizations may give developers [Reader](https://docs.microsoft.com/azure/role-based-access-control/built-in-roles#reader) access.
- In practice, the Service Principal should have a [custom role](https://docs.microsoft.com/azure/role-based-access-control/custom-roles) to prevent it from removing resource locks and performing other destructive actions. For sake of simplicity, the demo implementation uses an Owner role.

### 3. Create a custom role for the Service Principal used to access Production

It's a common mistake to give CI/CD build agents Owner roles and permissions. Contributor permissions are not enough if your pipeline also need to perform identity role assignments or other privileged operations like Key Vault policy management.

A CI/CD Build Agent will happily delete your entire production environment if told to do so. To avoid _irreversible destructive changes_, we will create a custom role. For example:

- Remove Key Vault access policies
- Remove [management lock](https://docs.microsoft.com/azure/azure-resource-manager/management/lock-resources) that by design should prevent resources from being deleted (common requirement in regulated industries)

Therefore we will create a custom role and remove the `Microsoft.Authorization/*/Delete` actions.

```json
{
  "Name": "Headless Owner",    
  "Description": "Can manage infrastructure.",
  "actions": [
    "*"
  ],
  "notActions": [
    "Microsoft.Authorization/*/Delete"
  ],
  "AssignableScopes": [
    "/subscriptions/{subscriptionId1}",
    "/subscriptions/{subscriptionId2}",
    "/providers/Microsoft.Management/managementGroups/{groupId1}"
  ]
}
```

If that removes too many permissions for your purposes, refer to the full list in the [official documentation for Azure resource provider operations](https://docs.microsoft.com/azure/role-based-access-control/resource-provider-operations#management--governance) and adjust your role definition accordingly.

## Deploy this scenario

This scenario extends beyond Resource Manager, which is why we use [Terraform](https://terraform.io). This allows us to also create principals in Azure AD and bootstrap Azure DevOps using a single infrastructure as code tool.

For source code and detailed instructions, please visit the GitHub repo [Governance on Azure Demo - from DevOps to ARM](https://github.com/azure/devops-governance).

## Next steps

- Visit the Infrastructure as Code repository for this scenario at  
  [https://github.com/azure/devops-governance](https://github.com/azure/devops-governance)
- Review the Cloud Adoption Framework's [Cloud governance guides](https://docs.microsoft.com/azure/cloud-adoption-framework/govern/guides/)

## Related resources

- [What is Azure role-based access control (Azure RBAC)?](https://docs.microsoft.com/azure/role-based-access-control/overview)
- [Cloud Adoption Framework: Resource access management in Azure](https://docs.microsoft.com/azure/cloud-adoption-framework/govern/resource-consistency/resource-access-management)
- **[Azure Resource Manager roles](https://docs.microsoft.com/azure/role-based-access-control/built-in-roles)**
  - [Owner (built-in)](https://docs.microsoft.com/azure/role-based-access-control/built-in-roles#owner)
  - [Contributor (built-in)](https://docs.microsoft.com/azure/role-based-access-control/built-in-roles#contributor)
  - [Reader (built-in)](https://docs.microsoft.com/azure/role-based-access-control/built-in-roles#reader)
  - [Custom Role](https://docs.microsoft.com/azure/role-based-access-control/custom-roles)
- **[Azure DevOps security groups](https://docs.microsoft.com/azure/devops/organizations/security/permissions?view=azure-devops&tabs=preview-page#groups)**
  - [Project Administrators](https://docs.microsoft.com/azure/devops/user-guide/roles?view=azure-devops#project-administrators)
  - Contributor
  - Reader
