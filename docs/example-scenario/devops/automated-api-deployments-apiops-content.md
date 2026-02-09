APIOps is a methodology that applies the concepts of GitOps and [DevOps](/devops) to API deployment. Like DevOps, [APIOps](https://github.com/Azure/apiops) helps team members easily make changes and deploy them in an iterative and automated way. This architecture demonstrates how you can improve the entire API lifecycle and API quality by using APIOps.

## Architecture

:::image type="content" alt-text="Diagram of the architecture for automated API deployments using APIOps on Azure." source="media/automated-api-deployments-apiops-architecture-diagram.svg" lightbox="media/automated-api-deployments-apiops-architecture-diagram.svg" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/automated-api-deployments-apiops-architecture-diagram.vsdx) of this architecture.*

### Workflow

1. API operators run the [extractor pipeline](https://azure.github.io/apiops/apiops/3-apimTools/apiops-2-1-tools-extractor.html) to synchronize the Git repository with the API Management instance and populate the Git repository with API Management objects in the required format.

2. If an API change is detected in the API Management instance, a pull request (PR) is created for operators to review. Operators merge the changes into the Git repository.

3. API developers clone the Git repository, create a branch, and create API definitions by using the OpenAPI Specification or tools of their choice.

4. If a developer pushes changes to the repository, a PR is created for review.

5. The PR can be automatically approved or reviewed, depending on the level of control that's required.

6. After changes are approved and merged, the publishing pipeline deploys the latest changes to the API Management instance.

7. API operators create and modify API Management policies, diagnostics, products, and other relevant objects, and then commit the changes.

8. The changes are reviewed, and they're merged after approval.

9. After merging the changes, the publishing pipeline deploys the changes by using the API-definitions process.

### Components

- [Azure API Management](/azure/well-architected/service-guides/api-management/reliability) is a managed service that creates consistent, API gateways for back-end services. In this architecture, it routes API calls, verifies credentials, enforces usage quotas, and logs metadata. It serves as the central platform for managing and publishing APIs.

- [Azure DevOps](/azure/devops/user-guide/what-is-azure-devops) is a suite of development tools and services that manages the development life cycle. In this architecture, it supports planning, code management, and automated deployment of APIs, which enables teams to collaborate and streamline API delivery.

  - [Azure Pipelines](/azure/devops/pipelines/get-started/what-is-azure-pipelines) is a cloud-based service that enables continuous integration and continuous delivery (CI/CD). In this architecture, it automates testing, building, and deploying API changes to the API Management instance.

  - [Azure Repos](/azure/devops/repos/get-started) is a set of version control tools, including standard Git, that you can use to manage your code. In this architecture, it stores API definitions, policies, and configurations. It serves as the single source of truth for all changes and enables auditability and collaboration through pull requests.

### Alternatives

This solution uses [Azure Repos](/azure/devops/repos/) to provide Git functionality and [Azure Pipelines](/azure/devops/pipelines/get-started/what-is-azure-pipelines) provides the pipelines. You can use any comparable technologies.

## Scenario details

APIOps uses version control to manage APIs and create an audit trail of changes to APIs, policies, and operations.

API developers who use an APIOps methodology review and audit APIs earlier and more frequently, catching and resolving deviations from API standards faster to improve specifications and API quality. The more APIs that you build and deploy with an APIOps approach, the greater the consistency between APIs.

This APIOps architecture uses [Azure API Management](/azure/api-management) as the API management platform. [Azure DevOps](https://azure.microsoft.com/solutions/devops) organizes API management. [Azure Repos](/azure/devops/repos/) provides Git functionality, and [Azure Pipelines](/azure/devops/pipelines/get-started/what-is-azure-pipelines) creates the CI/CD pipeline.

### Potential use cases

- Any organization developing and managing APIs
- Highly regulated industries: insurance, banking, finance, government

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

This solution provides several security-related benefits. Individual developers—and even operators—don't directly access the API Management instance to apply changes or updates. Instead, users push changes to a Git repository, and the extractor and publishing pipelines read and apply them to the API Management instance. This approach follows the security best practice of *least privilege* by not giving teams write permissions to the API Management service instance. In diagnostic or troubleshooting scenarios, you can grant elevated permissions for a limited time on a case-by-case basis.

To make sure the API Management instances are using best practices for security, you can extend this solution to enforce API best practices by using third-party tools and unit testing. Teams can provide early feedback via PR review if the proposed changes to an API or policy violate standards.

Apart from the task of setting up repository permissions, consider implementing the following security measures in Git repositories that synchronize to API Management instances:

- **Pull Request (PR) Review**: Use branches and protect the branches that represent the state of the API Management instances from having changes pushed to them directly. Require PRs to have at least one reviewer to enforce the four-eyes principle.
- **Immutable history**: Only allow new commits on top of existing changes. Immutable history is especially important for auditing purposes.
- **Multi-factor authentication**: Require your users to activate two-factor authentication.
- **Signed Commits**: Allow only signed commits that can't be altered after the fact.

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

- Use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate costs.

- API Management offers the following tiers: Consumption, Developer, Basic, Standard, and Premium.

- GitHub offers a free service. However, to use advanced security-related features, such as code owners or required reviewers, you need the Team plan. For more information, see [GitHub pricing](https://github.com/pricing).

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

APIOps can increase DevOps productivity for API development and deployments. One of the most useful features is the ability to use Git operations to quickly roll back changes that behave unexpectedly. The commit graph contains all commits, so it can help with the post-mortem analysis.

API operators often manage multiple environments for the same set of APIs. It's typical to have several stages of an API deployed to different API Management instances or in a shared API Management instance. The Git repository, which is the single source of truth, shows which versions of applications are currently deployed to a cluster.

When someone makes a PR in the Git repository, the API operator knows they have new code to review. For example, when a developer takes the OpenAPI Specification and builds the API implementation, they add this new code to the repository. The operators can review the PR and make sure that the API that's been submitted for review meets best practices and standards.

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

APIOps has many benefits, but as API Management landscapes grow, so does the complexity of managing them. This solution helps meet challenges like:

- Keeping an overview of all environments and API Management instances.
- Tracking critical changes to APIs and policies.
- Creating an audit trail for all deployed changes.

## Deploy this scenario

Deploying this solution involves these steps:

- Develop the API in the portal or make changes to the OpenAPI Specification by using a tool of your choice.
  - If you make changes in the portal, you can run the extractor to automatically extract all the APIs and other relevant policies, operations, and configurations from API Management. You can synchronize this information to the Git repository.

  - Optionally, use the Azure DevOps CLI to [create a new pull request](/azure/devops/repos/Git/pull-requests?tabs=azure-devops-cli#create-a-pull-request).

- The extractor workflow includes the following steps that you take:

  - Run a pipeline that downloads changes in the portal to the API Management instance.
      <!--Pipeline named _APIM-download-portal-changes_ in the scenario.-->

  - [Enter the names of the branch, your APIM artifacts repository, the API Management instance, and the resource group](https://azure.github.io/apiops/apiops/4-extractApimArtifacts/apiops-azdo-3-1.html#extract-apim-artifacts-in-azure-devops-from-extractor-tool).

      :::image type="content" alt-text="Screenshot of 'Run pipeline', where you enter the names of the API Management instance and the resource group." source="media/automated-api-deployments-run-pipeline.png":::

- In our scenario, the pipeline that downloads changes in the portal to the API Management instance has the following stages: *Build extractor*, *Create artifacts from portal*, and *Create template branch*.

  - *Build extractor*

      This stage builds the extractor code.

  - *Create artifacts from portal*

      This stage runs the extractor and creates artifacts that resemble a Git repository structure like that shown in the following screenshot:

      :::image type="content" alt-text="Screenshot of 'APIM-automation' that shows 'apim-instances' and a folder hierarchy." source="media/automated-api-deployment-api-management-automation-instances.png":::

    - *Create template branch*

      After generating the artifact, this stage creates a PR with the changes extracted for the platform team to review.

      The first time you run the extractor, it pulls everything from the Git repository. The PR that's created will have all the APIs, policies, and artifacts.

      Later extractions have only changes made before the extraction in the PR. Sometimes changes might be only to the specification of an API, which is the case in the following example of a PR.

      :::image type="content" alt-text="Screenshot of an example pull request after an extraction that shows proposed changes to a file named 'specification.yml'." source="media/automated-api-deployment-subsequent-extraction-pr.png" lightbox="media/automated-api-deployment-subsequent-extraction-pr.png":::

- A reviewer goes to **Pull Requests** to view the updated pull requests. You can also configure automatic approvals to automate this step.

  :::image type="content" alt-text="Screenshot of an example pull request that shows changes to content in 'policy.xml' and changes only to whitespace in other files." source="media/automated-api-deployment-merging-artifacts-pr.png" lightbox="media/automated-api-deployment-merging-artifacts-pr.png":::

- After approving the PR, it triggers another pipeline that publishes from API Management to the portal. In our example, <!--we named this pipeline _apim-publish-to-portal_, and--> it has the following stages: *build creator*, *build terminator*, and *publish APIM instances*.

  :::image type="content" alt-text="Screenshot of the stages in APIM-publish-to-portal, a pipeline." source="media/automated-api-deployment-stages-of-api-management-publish.png":::

  - The *build creator* stage handles creation of new APIs.
  - The *build terminator* stage handles any deletions.
  - The *publish APIM instances* stage publishes changes to the API Management instance.

  :::image type="content" alt-text="Screenshot that shows the jobs in an example run of APIM-publish-to-portal, a pipeline." source="media/automated-api-deployment-jobs-in-api-management-publish.png" lightbox="media/automated-api-deployment-jobs-in-api-management-publish.png":::

  After this pipeline runs successfully, it publishes the changes in the API Management instance.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- [Rishabh Saha](https://www.linkedin.com/in/rishabhsaha) | Principal Solution Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Azure Pipelines](/azure/devops/pipelines/get-started/what-is-azure-pipelines)
- [APIOps for Azure API Management](https://azure.github.io/apiops/)
- [CI/CD for API Management using Azure Resource Manager templates](/azure/api-management/devops-api-development-templates)
- [GitOps Overview](https://www.gitops.tech)
- [Weave GitOps](https://gitops.weave.works/)
- [Tutorial: Deploy configurations using GitOps on an Azure Arc-enabled Kubernetes cluster](/azure/azure-arc/kubernetes/tutorial-use-gitops-connected-cluster)

## Related resources

- [GitOps for Azure Kubernetes Service](../gitops-aks/gitops-blueprint-aks.yml)
- [Migrate a web app using Azure API Management](../apps/apim-api-scenario.yml)
- [Protect APIs with Application Gateway and API Management](../../web-apps/api-management/architectures/protect-apis.yml)
