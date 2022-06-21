## Introduction

The deployment and testing of the mission critical environment is crucial piece of the overall reference architecture. The individual application stamps are deployed as infrastructure as code from a source code repository. Updates to the infrastructure are deployed with zero downtime to the application. A DevOps continuous integration pipeline is used to retrieve the source code from the repository and deploy the individual stamps in Azure.

Deployment and updates is the central process in the architecture. Infrastructure and application related updates are deployed to fully independent stamps. Only the globally shared infrastructure in the architecture is shared across the stamps. Existing stamps in the infrastructure aren't touched. The new application version will only be deployed to these new stamps. Infrastructure updates will only be deployed to these new stamps.

The new stamps are added to Azure Front Door. Traffic is gradually moved over to the new stamps. When it's determined that traffic is served from the new stamps without issue, the previous stamps are deleted.

Proactive testing of the infrastructure discovers weaknesses and how the deployed application will behave in the event of a failure.

## Deployment

The deployment of the infrastructure in the reference architecture is dependent upon the following components:

* **DevOps** - The source code and pipelines for the infrastructure.

* **Zero downtime updates** - Updates and upgrades are deployed to the environment with zero downtime to the deployed application.

* **Environments** - Short-lived and permanent environments used for the architecture.

* **Shared and dedicated resources** - Azure resources that are dedicated and shared to the stamps and overall infrastructure.

### DevOps

The DevOps components provide the source code repository and CI/CD pipelines for deployment of the infrastructure and updates. Github and Azure Pipelines were chosen as the components.

* **Github** - Contains the source code repositories for the application and infrastructure.

* **Azure Pipelines** - The pipelines in the Azure DevOps service are used by the architecture for all build, test and release tasks.

An additional component in the design used for the deployment are build agents. Microsoft Hosted build agents are used as part of Azure Pipelines to deploy the infrastructure and updates. The use of Microsoft Hosted build agents removes the management burden for developers to maintain and update the build agent.

For more information about Azure Pipelines and Azure DevOps, see [What is Azure DevOps?](/azure/devops/user-guide/what-is-azure-devops).

### Zero downtime updates

The zero downtime and update strategy in the reference architecture is central to the over all mission critical application. The methodology of replace instead of upgrade of the stamps allows parallel environments for testing and deployment.

There are two main components of the reference architecture:

* **Infrastructure** - Azure services and resources. Deployed with Terraform and it's associated configuration.

* **Application** - The hosted service or application that serves users. Based on Docker containers and npm built artifacts in HTML and JavaScript for the UI.

In many systems, there is an assumption that application updates will be more frequent than infrastructure updates. As a result, different update procedures are developed for each.  With a public cloud infrastructure, changes can happen at a faster pace. The faster pace and rate of change within the Azure platform requires a different approach to updates. One deployment process for application updates and infrastructure updates was chosen. This allows for:

* **One consistent process** - Less chances for mistakes if infrastructure and application updates are mixed together in a release, intentionally or not.

* **Enables Blue/Green deployment** - Every update is deployed using a gradual migration of traffic to the new release.

* **Easier deployment and debugging of the application** - The entire stamp will never host multiple versions of the application side-by-side.

* **Simple rollback** - Traffic can be switched back to the stamps that run the previous version if errors or issues are encountered.

* **Elimination of manual changes and configuration drift** - Every environment is a fresh deployment.

#### Branching strategy

The foundation of the update strategy is the use of branches within the Git repository. The reference architecture uses three types of branches:

| Branch | Description |
| ------ | ----------- |
| **`feature/*`** and **`fix/*`** | The entry points for any change. These branches are created by developers and should be given a descriptive name, like **`feature/catalog-update`** or **`fix/worker-timeout-bug`**. When changes are ready to be merged, a pull request (PR) against the **`main`** branch is created. Every PR must be approved by at least one reviewer. With limited exceptions, every change that is proposed in a PR must run through the end-to-end (E2E) validation pipeline. The E2E pipeline should be used by developers to test and debug changes to a complete environment. |
| **`main`** | The continuously forward moving and stable branch. Mostly used for integration testing. Changes to main are made only through pull requests. A branch policy prohibits direct writes. Nightly releases against the permanent **`integration (int)`** environment are automatically executed from the **`main`** branch. The **`main`** branch is considered stable. It should be safe to assume that at any given time, a release can be created from it. |
| **`release/*`** | Release branches are only created from the **`main`** branch. The branches follow the format **`release/2021.7.X`**. Branch policies are used so that only repo administrators are allowed to create **`release/*`** branches. Only these branches are used to deploy to the **`prod`** environment.

#### Hotfixes

In the event that a hotfix is required urgently because of a bug or other issue and can't go through the regular release process, a hotfix path is available. Critical security updates or issues which break the user experience not discovered in testing are considered valid examples of hotfixes.

The hotfix must be created in a new **`fix`** branch and then merged into **`main`** using a regular PR. Instead of creating a new release branch, the hotfix is "cherry-picked" into an existing release branch. This branch is usually already deployed to the **`prod`** environment. The CI/CD pipeline that originally deployed the release branch with all the tests is executed again and will now deploy the hotfix as part of the pipeline.

To avoid major issues, it's important that the hotfix contains a small number of isolated commits that can easily be cherry-picked and integrated into the release branch. If this isn't the case with the hotfix, it's an indication that the change doesn't qualify as a hotfix. The change should be deployed as a full new release and potentially combined with a rollback to a former stable version until the new release can be deployed.

### Environments


### Shared and dedicated resources

## Failure injection testing

### DNS failure

### Firewall block