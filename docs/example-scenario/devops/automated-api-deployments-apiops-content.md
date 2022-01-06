# Automated API deployments using APIOps on Azure

This example scenario applies generally to businesses that want to apply the concept of APIOps in their API and application lifecycle. APIOps applies the concept of GitOps and DevOps for API deployments. Specifically, this scenario shows how every persona in the lifecycle of API design, development, and deployment can be empowered with self-service and automated tools to ensure the quality of the specs and APIs that they are building.

APIOps places the API Management (APIM) infrastructure under desired state under version control. Rather than making changes directly in APIM, most operations happen through code changes that can be reviewed and audited. This approach supports the security principle of least-privilege access.

APIOps not only enforces policies within APIM, but also helps support security by providing feedback for proposed policy changes. Early feedback is more convenient for developers and reduces risk and costs.

The earlier in the pipeline you can identify deviations from your standards, the faster they are to resolve. The greater the number of APIs you build and deploy following this approach, the greater the consistency between them and the smaller the chance of deploying a service that is of too poor quality to be consumed.

This article describes a solution for using APIOps with an Azure API Management (APIM) instance. This solution provides full audit capabilities, policy enforcement, and early feedback.

## Potential use cases

This solution benefits any organization that wants the advantages of deploying APIs and the APIM infrastructure as code, with an audit trail of every change made to the individual APIs, policies, operations etc. The solution is especially suitable for highly regulated industries like insurance, banking, and finance.

## Architecture

:::image type="content" alt-text="Diagram of the architecture for automated API deployments using APIOps on Azure." source="media/automated-api-deployments-architecture-diagram.png":::

1.  API operators run the extractor pipeline to sync the git repo with the APIM instance and generate the git repo with APIM objects in the required format.

2.  If APIs already exist in the APIM instance and there are changes a PR is created for operators to review and merge the changes in the git repo.

3.  API developers clone the git repo, create a branch and create API definitions using OpenAPI spec and/or tools of their choice.

4.  API developers push the changes to the repo and create a PR for review.

5.  The PR can be auto approved or reviewed depending on the specific level of control needed.

6.  Once changes are approved and merged the publish pipeline will deploy the latest changes to the APIM instance.

7.  API Operators create/modify APIM policies, diagnostics, product, and other relevant objects and commit the changes.

8.  The changes get reviewed and merged after approval.

9.  Once merged the publishing pipeline deploys the changes using the exact same process used for API definitions.

10. For the reference implementation, the git repo is Azure Repos and the Extractor and Publisher pipelines are in Azure Pipelines. Any similar technology could be used to build those out.


### Dataflow @garycentric

> An alternate title for this sub-section is "Workflow" (if data isn't really involved).
> In this section, include a numbered list that annotates/describes the dataflow or workflow through the solution. Explain what each step does. Start from the user or external data source, and then follow the flow through the rest of the solution (as shown in the diagram).

Examples:
1. Admin 1 adds, updates, or deletes an entry in Admin 1's fork of the Microsoft 365 config file.
2. Admin 1 commits and syncs the changes to Admin 1's forked repository.
3. Admin 1 creates a pull request (PR) to merge the changes to the main repository.
4. The build pipeline runs on the PR.


### Components

The solution has the following components:

-   Azure API Management (APIM)

-   Azure DevOps

-   Extractor and Creator (.NET)

-   Create Pull Request Script (shell script)

### Alternatives

APIM devops resource kit. We didn't use it as is. We extended it, because it didn't fit well into the GitOps model—for example, the repo structure, the API names weren't user-friendly, etc. The APIM resource kit is reliant on ARM templates, while this solution is more technology-agnostic. You can now use Terraform, ARM, PowerShell, the REST API, etc. to easily format and push the new extracted changes back to the portal.

The toolkit doesn\'t deploy any changes. The extractor just generates ARM templates from the portal. The creator just generates ARM templates from the config.yml file.

## Considerations

### Scalability

APIOps has many benefits, but as APIM landscapes grow, so does the complexity of managing. This solution helps meet challenges like:

-   Keeping an overview of all environments and APIM instances.

-   Tracking critical changes to APIs and policies.

-   Ensuring that all changes been deployed have an audit trail

### Security

This solution provides several security-related benefits. With the GitOps approach, individual developers or even operators don\'t directly access the APIM instance to apply changes or updates. Instead, users push changes to a Git repository, and the extractor and publish pipelines, reads them and applies them to the APIM instance. This approach follows the security best practice of least privilege by not giving teams write permissions to the APIM service instance. In diagnostic or troubleshooting scenarios, you can grant elevated permissions for a limited time on a case-by-case basis.

To make sure the APIM instances are using security best practices, this solution can be extended to enforce API best practices using 3^rd^ party tools, unit testing. Teams can provide early feedback via PR review if proposed API or policy changes violate the standards.

Apart from the task of setting up repository permissions, consider implementing the following security measures in Git repositories that sync to APIM instances:

-   **Branch protection**: Protect the branches that represent the state of the APIM instances from having changes pushed to them directly. Require every change to be proposed by a PR that is reviewed by at least one other person. Also use PRs to do automatic checks.

-   **PR review**: Require PRs to have at least one reviewer, to enforce the four-eyes principle. You can also use the GitHub code owners feature to define individuals or teams that are responsible for reviewing specific files in a repository.

-   **Immutable history**: Only allow new commits on top of existing changes. Immutable history is especially important for auditing purposes.

-   **Further security measures**: Require your GitHub users to activate two-factor authentication. Also, allow only signed commits, which can\'t be altered after the fact.

### Operations

APIOps can increase DevOps productivity for API development and deployments. One of the most useful features is the ability to quickly roll back changes that are behaving unexpectedly, just by performing Git operations. The commit graph still contains all commits, so it can help with the post-mortem analysis.

API operators often manage multiple environments for the same set of APIs. It\'s typical to have several stages of an API deployed to different APIM instances or in a shared APIM instance. The Git repository, which is the single source of truth, shows which versions of applications are currently deployed to a cluster.

When someone makes a pull request (PR) in the git repo, the API operator will know that they have new code to review. For example, when a developer has taken the OpenAPI spec and built the API implementation, they will add this new code to the repo. The operators can review the PR and make sure that the API that's been submitted for review still meets best practices and standards.

## Deploy this scenario

As the API designer/developer

-   You can develop the API in the portal or make changes to the OpenAPI spec using a tool of your choice.

-   If you have made changes in the portal in you can run the extractor to automatically extract all the APIs and other relevant policies, operations, configuration from APIM and sync it to the git repository.

-   Extractor Workflow

    -   Run the pipeline named _apim-download-portal-changes_.

    -   Enter the branch name, APIM instance name and resource group name.

        :::image type="content" alt-text="Screenshot of 'Run pipeline', where you enter the names of the APIM instance and the resource group." source="media/automated-api-deployments-run-pipeline.png":::

-   The pipeline has the following stages

    -   Build extractor

    -   Create artifacts from portal

    -   Create template branch pull request

-   Build extractor builds the extractor code

-   Create artifacts from portal runs the extractor and creates artifacts that resemble a git repository structure like the below:

    :::image type="content" alt-text="Screenshot of 'apim-automation' that shows 'apim-instances' and a folder hierarchy." source="media/automated-api-deployment-apim-automation-instances.png":::

-   After the artifact is generated the create template branch creates a Pull Request with the changes extracted for the APIM Platform team to review.

    > [!NOTE]
	> The first time you run the extractor it pulls down everything and the PR created will have all the apis, policies, artifacts, etc.

-   Subsequent extractions will only have changes made before the extraction in the PR. Like in the example below only an API spec changed and the PR shows that.

    :::image type="content" alt-text="Screenshot of an example pull request after an extraction that shows proposed changes to a file named 'specification.yml'." source="media/automated-api-deployment-subsequent-extraction-pr.png":::

-   You can go Pull Requests and view the Pull Requests to be reviewed. This step can also be auto approved in case the extractor changes should always be pulled in

    :::image type="content" alt-text="Screenshot of an example pull request that shows changes to content in 'policy.xml' and changes only to whitespace in other files." source="media/automated-api-deployment-merging-artifacts-pr.png":::

-   Once the PR is approved is approved, it triggers another pipeline called apim-publish-to-portal

-   The apim-publish-to-portal has the following stages:

    :::image type="content" alt-text="Screenshot of the stages in APIM-publish-to-portal, a pipeline." source="media/automated-api-deployment-stages-of-apim-publish.png":::

-   The build creator stage handles new API creations

-   The build terminator stage handles any deletions

    :::image type="content" alt-text="Screenshot that shows the jobs in an example run of APIM-publish-to-portal, a pipeline." source="media/automated-api-deployment-jobs-in-apim-publish.png":::

-   Once this pipeline runs successfully all the changes are published into the APIM instance

## Pricing

-   Use the Azure pricing calculator to estimate costs.

-   APIM offers Consumption, Developer, Basic, Standard, and Premium tiers.

-   GitHub offers a free service, but to use advanced security-related features like code owners or required reviewers, you need the Team plan. For more information, see the GitHub pricing page.

## Next steps

-   [Guide To GitOps](https://www.weave.works/technologies/gitops)

-   [APIM DevOps Resource Kit](https://github.com/Azure/azure-api-management-devops-resource-kit/)

## Related resources
