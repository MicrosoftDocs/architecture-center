This example scenario applies generally to businesses that want to apply the concept of APIOps in their API and application lifecycle. APIOps applies the concept of GitOps and DevOps to API deployments. Specifically, this scenario shows how every persona in the lifecycle of API design, development, and deployment can be empowered with self-service and automated tools to ensure the quality of the specifications and APIs that they're building.

APIOps places the [API Management (APIM)](/azure/api-management/) infrastructure under version control to achieve these goals. Rather than making changes directly in APIM, most operations happen through code changes that can be reviewed and audited. This approach supports the security principle of least-privilege access.

APIOps not only enforces policies within APIM, but also helps support security by providing feedback for proposed policy changes. Early feedback is more convenient for developers and reduces risks and costs.

The earlier in the pipeline that you can identify deviations from your standards, the faster you can resolve them. The greater the number of APIs that you build and deploy following this approach, the greater the consistency between them. This means that there's a smaller chance of deploying a service that is of too poor quality to be consumed.

This article describes a solution for using APIOps with an APIM instance. This solution provides full audit capabilities, policy enforcement, and early feedback.

## Potential use cases

This solution benefits any organization that wants the advantages of deploying APIs and the APIM infrastructure as code, with an audit trail of every change made to the individual APIs, policies, operations, and so on. This solution is especially suitable for highly regulated industries like insurance, banking, and finance.

## Architecture

:::image type="content" alt-text="Diagram of the architecture for automated API deployments using APIOps on Azure." source="media/automated-api-deployments-architecture-diagram.png" lightbox="media/automated-api-deployments-architecture-diagram.png":::

Download a [Visio file](https://arch-center.azureedge.net/automated-api-deployments-apiops-architecture-diagram.vsdx) of this architecture.

### Workflow

1.  API operators run the extractor pipeline to synchronize the git repository with the APIM instance and generate the git repository with APIM objects in the required format.

2.  If APIs already exist in the APIM instance and there are changes, a pull request (PR) is created for operators to review and merge the changes in the git repository.

3.  API developers clone the git repository, create a branch, and create API definitions by using the OpenAPI specification or tools of their choice.

4.  API developers push the changes to the repository and create a PR for review.

5.  The PR can be automatically approved or reviewed, depending on the specific level of control required.

6.  After changes are approved and merged, the publishing pipeline will deploy the latest changes to the APIM instance.

7.  API Operators create and modify APIM policies, diagnostics, product, and other relevant objects, and then commit the changes.

8.  The changes are reviewed, and they're merged after approval.

9.  After the changes are merged, the publishing pipeline deploys the changes by using the same process that was used for API definitions.

10. For the reference implementation, the git repository is [Azure Repos](/azure/devops/repos/?view=azure-devops) and the Extractor and Publisher pipelines are in [Azure Pipelines](/azure/devops/pipelines/get-started/what-is-azure-pipelines?view=azure-devops). Any similar technology could be used to build those.


### Components

The solution has the following components:

- [Azure API Management (APIM)](/azure/api-management/)
- [Azure DevOps](/azure/devops/?view=azure-devops)
- Extractor and Creator (.NET)
- Create Pull Request Script (shell script)

### Alternatives

We used the [APIM devops resource kit](https://github.com/Azure/azure-api-management-devops-resource-kit), but we didn't use it as is. Instead, we extended it, because it didn't fit well into the GitOps model—for example, the repository structure wasn't ideal, and the API names weren't user-friendly. The APIM resource kit is reliant on Azure Resource Management templates (ARM templates), while this solution is more technology-agnostic. You can now use Terraform, ARM, PowerShell, the REST API, and so on, to easily format and push newly extracted changes back to the portal.

The toolkit doesn't deploy any changes. The extractor only generates ARM templates from the portal. The creator only generates ARM templates from the config.yml file.

## Considerations

This solution has the following considerations: scalability, security, and operations.

### Scalability

APIOps has many benefits, but as APIM landscapes grow, so does the complexity of managing them. This solution helps meet challenges like:

- Keeping an overview of all environments and APIM instances.
- Tracking critical changes to APIs and policies.
- Ensuring that all changes that have been deployed also have an audit trail.

### Security

This solution provides several security-related benefits. With the GitOps approach, individual developers—and even operators—don't directly access the APIM instance to apply changes or updates. Instead, users push changes to a git repository, and the extractor and publishing pipelines read them and apply them to the APIM instance. This approach follows the security best practice of _least privilege_ by not giving teams write permissions to the APIM service instance. In diagnostic or troubleshooting scenarios, you can grant elevated permissions for a limited time on a case-by-case basis.

To make sure the APIM instances are using best practices for security, you can extend this solution to enforce API best practices by using third-party tools and unit testing. Teams can provide early feedback via PR review if the proposed changes to an API or policy violate standards.

Apart from the task of setting up repository permissions, consider implementing the following security measures in git repositories that synchronize to APIM instances:

- **Branch protection**: Protect the branches that represent the state of the APIM instances from having changes pushed to them directly. Require every change to be proposed by a PR that is reviewed by at least one other person. Also use PRs to do automatic checks.

- **PR review**: Require PRs to have at least one reviewer, to enforce the four-eyes principle. You can also use the [GitHub code owners](https://docs.github.com/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-code-owners) feature to define individuals or teams that are responsible for reviewing specific files in a repository.

- **Immutable history**: Only allow new commits on top of existing changes. Immutable history is especially important for auditing purposes.

- **Further security measures**: Require your GitHub users to activate two-factor authentication. Also, allow only signed commits, which can't be altered after the fact.

### Operations

APIOps can increase DevOps productivity for API development and deployments. One of the most useful features is the ability to quickly roll back changes that are behaving unexpectedly by performing git operations. The commit graph still contains all commits, so it can help with the post-mortem analysis.

API operators often manage multiple environments for the same set of APIs. It's typical to have several stages of an API deployed to different APIM instances or in a shared APIM instance. The git repository, which is the single source of truth, shows which versions of applications are currently deployed to a cluster.

When someone makes a PR in the git repository, the API operator will know that they have new code to review. For example, when a developer has taken the OpenAPI specification and built the API implementation, they'll add this new code to the repository. The operators can review the PR and make sure that the API that's been submitted for review still meets best practices and standards.

## Deploy this scenario

This scenario provides API designers and developers with the following options and benefits:

- You can develop the API in the portal or make changes to the OpenAPI specification by using a tool of your choice.

- If you have made changes in the portal, you can run the extractor to automatically extract all the APIs and other relevant policies, operations, configuration from APIM. You can synchronize it to the git repository.

- Extractor Workflow:

    - Run the pipeline named _apim-download-portal-changes_.

    - Enter the names of the branch, the APIM instance, and the resource group.

      :::image type="content" alt-text="Screenshot of 'Run pipeline', where you enter the names of the APIM instance and the resource group." source="media/automated-api-deployments-run-pipeline.png":::

- The pipeline has the following stages:

    - Build extractor
    - Create artifacts from portal
    - Create template branch PRs

- _Build extractor_ builds the extractor code.

- _Create artifacts from portal_ runs the extractor and creates artifacts that resemble a git repository structure like that shown in the following screenshot:

  :::image type="content" alt-text="Screenshot of 'apim-automation' that shows 'apim-instances' and a folder hierarchy." source="media/automated-api-deployment-apim-automation-instances.png":::

- After the artifact is generated, _Create template branch_ creates a pull request (PR) with the changes extracted for the APIM Platform team to review.

  > [!NOTE]
  > The first time you run the extractor, it pulls down everything. The PR that's created will have all the APIs, policies, artifacts, and so on.

- Later extractions will have only changes that were made before the extraction in the PR. Like in the following example, only an API specification changed, and the PR shows that.

  :::image type="content" alt-text="Screenshot of an example pull request after an extraction that shows proposed changes to a file named 'specification.yml'." source="media/automated-api-deployment-subsequent-extraction-pr.png" lightbox="media/automated-api-deployment-subsequent-extraction-pr.png":::

- You can go Pull Requests and view the Pull Requests to be reviewed. This step can also be automatically approved if the extractor changes should always be pulled in.

  :::image type="content" alt-text="Screenshot of an example pull request that shows changes to content in 'policy.xml' and changes only to whitespace in other files." source="media/automated-api-deployment-merging-artifacts-pr.png" lightbox="media/automated-api-deployment-merging-artifacts-pr.png":::

- After the PR is approved, it triggers another pipeline called _apim-publish-to-portal_. This pipeline has the following stages: Build creator, Build terminator, and Publish APIM instances.

  :::image type="content" alt-text="Screenshot of the stages in APIM-publish-to-portal, a pipeline." source="media/automated-api-deployment-stages-of-apim-publish.png":::

- The _build creator_ stage handles new API creations.

- The _build terminator_ stage handles any deletions.

  :::image type="content" alt-text="Screenshot that shows the jobs in an example run of APIM-publish-to-portal, a pipeline." source="media/automated-api-deployment-jobs-in-apim-publish.png" lightbox="media/automated-api-deployment-jobs-in-apim-publish.png":::

- After this pipeline runs successfully, all the changes are published into the APIM instance.

## Pricing

- Use the [Azure pricing calculator](https://azure.microsoft.com/en-us/pricing/calculator/) to estimate costs.

- APIM offers the following tiers: Consumption, Developer, Basic, Standard, and Premium.

- GitHub offers a free service. However, to use advanced security-related features, such as code owners or required reviewers, you need the Team plan. For more information, see [GitHub pricing](https://github.com/pricing).

## Next steps

- [Azure Pipelines](/azure/devops/pipelines/get-started/what-is-azure-pipelines?view=azure-devops)
- [APIM DevOps Resource Kit](https://github.com/Azure/azure-api-management-devops-resource-kit/)
- [Guide to GitOps](https://www.weave.works/technologies/gitops)

## Related resources

- [Migrate a web app using Azure APIM](../apps/apim-api-scenario.yml)
- [Protect APIs with Application Gateway and API Management](../../reference-architectures/apis/protect-apis.yml)
- [Publish internal APIs to external users](../apps/publish-internal-apis-externally.yml)
