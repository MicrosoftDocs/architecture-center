APIOps applies the concepts of [GitOps](https://www.gitops.tech) and [DevOps](/devops) to API deployment. By using practices from these two methodologies, APIOps can enable everyone involved in the lifecycle of API design, development, and deployment with self-service and automated tools to ensure the quality of the specifications and APIs that they're building.

APIOps places the [Azure API Management](/azure/api-management) infrastructure under version control to achieve these goals. Rather than making changes directly in API Management, most operations happen through code changes that can be reviewed and audited. This approach supports the security principle of least-privilege access.

APIOps not only enforces policies within API Management, but also helps support security by providing feedback for proposed policy changes. Early feedback is more convenient for developers and reduces risks and costs. Also, the earlier in the pipeline that you can identify deviations from your standards, the faster you can resolve them.

Also, the more APIs that you build and deploy by following this approach, the greater the consistency between APIs. With greater consistency, it's less likely that the service can't or won't be consumed because of low quality. 

This article describes a solution for using APIOps with an API Management instance. This solution provides full audit capabilities, policy enforcement, and early feedback.

## Potential use cases

This solution benefits any organization that wants the advantages of deploying APIs and the API Management infrastructure as code. It provides an audit trail of every change that's made to the individual APIs, policies, operations, and so on. This solution is especially suitable for highly regulated industries like insurance, banking, and finance. It's also appropriate for other businesses that want to apply the concept of APIOps to an API and the application lifecycle.

## Architecture

:::image type="content" alt-text="Diagram of the architecture for automated API deployments using APIOps on Azure." source="media/automated-api-deployments-architecture-diagram.png" lightbox="media/automated-api-deployments-architecture-diagram.png":::

Download a [Visio file](https://arch-center.azureedge.net/automated-api-deployments-apiops-architecture-diagram.vsdx) of this architecture.

### Workflow

This solution uses [Azure Repos](/azure/devops/repos/?view=azure-devops) to provide Git functionality. [Azure Pipelines](/azure/devops/pipelines/get-started/what-is-azure-pipelines?view=azure-devops) provides the pipelines. Any similar technology could be used to provide those services.

1.  API operators run the extractor pipeline to synchronize the Git repository with the API Management instance and populate the Git repository with API Management objects in the required format.

2.  If APIs already exist in the API Management instance, and there are changes, a pull request (PR) is created for operators to review and merge the changes in the Git repository.

3.  API developers clone the Git repository, create a branch, and create API definitions by using the OpenAPI specification or tools of their choice.

4.  API developers push the changes to the repository and create a PR for review.

5.  The PR can be automatically approved or reviewed, depending on the level of control that's required.

6.  After changes are approved and merged, the publishing pipeline deploys the latest changes to the API Management instance.

7.  API operators create and modify API Management policies, diagnostics, products, and other relevant objects, and then commit the changes.

8.  The changes are reviewed, and they're merged after approval.

9.  After the changes are merged, the publishing pipeline deploys the changes by using the same process that was used for API definitions.



### Components

The solution has the following components:

- [Azure API Management](/services/api-management/#overview) creates consistent, modern API gateways for back-end services. Besides routing API calls to back ends, this platform also verifies credentials, enforces usage quotas, and logs metadata.

- [Azure DevOps](/azure/devops/?view=azure-devops) is a service for managing your development lifecycle end-to-end—from planning and project management, to code management, and continuing to build and release.

- [API Management DevOps Resource Kit](https://github.com/Azure/azure-api-management-devops-resource-kit) provides guidance, examples, and tools to help you achieve API DevOps with Azure API Management. 

- [Azure Pipelines](/services/devops/pipelines) enables continuous integration (CI) and continuous delivery (CD) to test and build your code and ship it to any target.

- [Azure Repos](/services/devops/repos) is a set of version control tools, including standard Git, that you can use to manage your code.


### Alternatives

This scenario uses a modified version of the [Azure API Management DevOps Resource Kit](https://github.com/Azure/azure-api-management-devops-resource-kit). The modifications made the resource kit a better fit to the GitOps model, such as by changing the repository structure and renaming the APIs to have friendlier names.

The API Management resource kit is reliant on Azure Resource Management templates (ARM templates), while this solution is more technology-agnostic. You can now use Terraform, Azure Resource Manager, PowerShell, the REST API, and so on, to easily format and push newly extracted changes back to the portal.

The toolkit doesn't deploy any changes. The extractor only generates ARM templates from the portal. The creator only generates ARM templates from the config.yml file.

This solution uses [Azure Repos](/azure/devops/repos/?view=azure-devops) to provide Git functionality and [Azure Pipelines](/azure/devops/pipelines/get-started/what-is-azure-pipelines?view=azure-devops) provides the pipelines. Any similar technology could be used to provide those services.

## Considerations

This solution has the following considerations: scalability, security, and operations.

### Scalability

APIOps has many benefits, but as API Management landscapes grow, so does the complexity of managing them. This solution helps meet challenges like:

- Keeping an overview of all environments and API Management instances.
- Tracking critical changes to APIs and policies.
- Ensuring that all changes that have been deployed also have an audit trail.

### Security

This solution provides several security-related benefits. With the GitOps approach, individual developers—and even operators—don't directly access the API Management instance to apply changes or updates. Instead, users push changes to a Git repository, and the extractor and publishing pipelines read them and apply them to the API Management instance. This approach follows the security best practice of _least privilege_ by not giving teams write permissions to the API Management service instance. In diagnostic or troubleshooting scenarios, you can grant elevated permissions for a limited time on a case-by-case basis.

To make sure the API Management instances are using best practices for security, you can extend this solution to enforce API best practices by using third-party tools and unit testing. Teams can provide early feedback via PR review if the proposed changes to an API or policy violate standards.

Apart from the task of setting up repository permissions, consider implementing the following security measures in Git repositories that synchronize to API Management instances:

- **Branch protection**: Protect the branches that represent the state of the API Management instances from having changes pushed to them directly. Require every change to be proposed by a PR that is reviewed by at least one other person. Also use PRs to do automatic checks.

- **PR review**: Require PRs to have at least one reviewer, to enforce the four-eyes principle. You can also use the [GitHub code owners](https://docs.github.com/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-code-owners) feature to define individuals or teams that are responsible for reviewing specific files in a repository.

- **Immutable history**: Only allow new commits on top of existing changes. Immutable history is especially important for auditing purposes.

- **Further security measures**: Require your GitHub users to activate two-factor authentication. Also, allow only signed commits, which can't be altered after the fact.

### Operations

APIOps can increase DevOps productivity for API development and deployments. One of the most useful features is the ability to use Git operations to quickly roll back changes that behave unexpectedly. The commit graph contains all commits, so it can help with the post-mortem analysis.

API operators often manage multiple environments for the same set of APIs. It's typical to have several stages of an API deployed to different API Management instances or in a shared API Management instance. The Git repository, which is the single source of truth, shows which versions of applications are currently deployed to a cluster.

When someone makes a PR in the Git repository, the API operator knows they have new code to review. For example, when a developer takes the OpenAPI specification and builds the API implementation, they add this new code to the repository. The operators can review the PR and make sure that the API that's been submitted for review meets best practices and standards.

## Deploy this scenario

Deploying this solution involves these steps:

- Develop the API in the portal or make changes to the OpenAPI specification by using a tool of your choice.

  If you make changes in the portal, you can run the extractor to automatically extract all the APIs and other relevant policies, operations, and configurations from API Management. You can synchronize this information to the git repository.

- Optionally, use the [Create pull request](/azure/devops/repos/Git/pull-requests?view=azure-devops&tabs=azure-devops-cli#create-a-pull-request) script, which is written in Azure DevOps CLI, to create new PRs.

- The extractor workflow includes the following steps that you take:

    - Run a pipeline that downloads changes in the portal to the API Management instance.
      <!--Pipeline named _APIM-download-portal-changes_ in the scenario.-->

    - Enter the names of the branch, the API Management instance, and the resource group.

      :::image type="content" alt-text="Screenshot of 'Run pipeline', where you enter the names of the API Management instance and the resource group." source="media/automated-api-deployments-run-pipeline.png":::

- In our scenario, the pipeline that downloads changes in the portal to the API Management instance has the following stages: _Build extractor_, _Create artifacts from portal_, and _Create template branch_.

    - _Build extractor_

      This stage builds the extractor code.

    - _Create artifacts from portal_

      This stage runs the extractor and creates artifacts that resemble a Git repository structure like that shown in the following screenshot:

      :::image type="content" alt-text="Screenshot of 'APIM-automation' that shows 'apim-instances' and a folder hierarchy." source="media/automated-api-deployment-api-management-automation-instances.png":::

    - _Create template branch_

      After the artifact is generated, this stage creates a PR with the changes extracted for the platform team to review.

      - The first time you run the extractor, it pulls everything from the Git repository. The PR that's created will have all the APIs, policies, artifacts, and so on.

      - Later extractions have only changes that were made before the extraction in the PR. Sometimes changes might be only to the specification of an API, which is the case in the following example of a PR.

        :::image type="content" alt-text="Screenshot of an example pull request after an extraction that shows proposed changes to a file named 'specification.yml'." source="media/automated-api-deployment-subsequent-extraction-pr.png" lightbox="media/automated-api-deployment-subsequent-extraction-pr.png":::


- A reviewer goes to **Pull Requests** and views the pull requests to be reviewed. This step can also be automatically approved if the changes that are discovered by the extractor should always be pulled in.

  :::image type="content" alt-text="Screenshot of an example pull request that shows changes to content in 'policy.xml' and changes only to whitespace in other files." source="media/automated-api-deployment-merging-artifacts-pr.png" lightbox="media/automated-api-deployment-merging-artifacts-pr.png":::

- After the PR is approved, it triggers another pipeline that publishes from API Management to the portal. In our example, <!--we named this pipeline _apim-publish-to-portal_, and--> it has the following stages: _Build creator_, _Build terminator_, and _Publish APIM instances_.

  :::image type="content" alt-text="Screenshot of the stages in APIM-publish-to-portal, a pipeline." source="media/automated-api-deployment-stages-of-api-management-publish.png":::

  - The _build creator_ stage handles creation of new APIs.

  - The _build terminator_ stage handles any deletions.

    :::image type="content" alt-text="Screenshot that shows the jobs in an example run of APIM-publish-to-portal, a pipeline." source="media/automated-api-deployment-jobs-in-api-management-publish.png" lightbox="media/automated-api-deployment-jobs-in-api-management-publish.png":::

  - After this pipeline runs successfully, all the changes are published into the API Management instance. In our example, this stage is named _Publish APIM instances_.

## Pricing

- Use the [Azure pricing calculator](https://azure.microsoft.com/en-us/pricing/calculator) to estimate costs.

- API Management offers the following tiers: Consumption, Developer, Basic, Standard, and Premium.

- GitHub offers a free service. However, to use advanced security-related features, such as code owners or required reviewers, you need the Team plan. For more information, see [GitHub pricing](https://github.com/pricing).

## Next steps

- [Azure Pipelines](/azure/devops/pipelines/get-started/what-is-azure-pipelines?view=azure-devops)
- [API Management DevOps Resource Kit](https://github.com/Azure/azure-api-management-devops-resource-kit)
- [CI/CD for API Management using Azure Resource Manager templates](/azure/api-management/devops-api-development-templates)
- [Guide to GitOps](https://www.weave.works/technologies/gitops)
- [Tutorial: Deploy configurations using GitOps on an Azure Arc-enabled Kubernetes cluster](/azure/azure-arc/kubernetes/tutorial-use-gitops-connected-cluster)

## Related resources

- [GitOps for Azure Kubernetes Service](../gitops-aks/gitops-blueprint-aks.yml)
- [Migrate a web app using Azure API Management](../apps/apim-api-scenario.yml)
- [Protect APIs with Application Gateway and API Management](../../reference-architectures/apis/protect-apis.yml)
- [Publish internal APIs to external users](../apps/publish-internal-apis-externally.yml)

