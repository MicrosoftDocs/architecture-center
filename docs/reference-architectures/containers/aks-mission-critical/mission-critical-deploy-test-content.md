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

The reference architecture uses two types of environments for the infrastructure:

* **Short-lived** - The E2E validation pipeline is used to deploy short-lived environments. Short-lived environments are used for pure validation or debugging environments for developers. Validation environments can be created from the **`feature/*`** branch, subjected to tests, and then destroyed if all tests were successful. Debugging environments are deployed in the same way as validation, but aren't destroyed immediately. These environments shouldn't exist more than a few days and should be deleted when the corresponding PR of the feature branch is merged.

* **Permanent** - In the permanent environments there are **`integration (int)`** and **`production (prod)`** versions. These environments live continuously and aren't destroyed. The environments use fixed domain names like *int.mission-critical.app*. In a real world implementation of the reference architecture, a **`staging`** (pre-prod) environment should be added. The **`staging`** environment is used to deploy and validate **`release`** branches with the same update process as **`prod`** (Blue/Green deployment).

    * **Integration (int)** - The **`int`** version is deployed nightly from the **`main`** branch with the same process as **`prod`**. The switchover of traffic is faster than the previous release unit. Instead of gradually switching traffic over multiple days, as in **`prod`**, the process for **`int`** completes within a few minutes or hours. This faster switchover ensures the updated environment is ready by the next morning. Old stamps are automatically deleted if all tests in the pipeline are successful.

    * **Production (prod)** - The **`prod`** version is only deployed from **`release/*`** branches. The traffic switchover uses more granular steps. A manual approval gate is between each step. Each release creates new regional stamps and deploys the new application version to the stamps. Existing stamps aren't touched in the process. The most important consideration for **`prod`** is that it should be **"always on"**. No planned or unplanned downtime should ever occur. The only exception is foundational changes to the database layer.  A planned maintenance window maybe needed.

### Shared and dedicated resources

The permanent environments (**`int`** and **`prod`**) within the reference architecture have different types of resources depending on if they are shared with the entire infrastructure or dedicated to an individual stamp. Resources can be dedicated to a particular release and exist only until the next release unit has taken over.

#### Globally shared resources

All resources shared between release units are defined in an independent Terraform template. These resources are Front Door, Cosmos DB, Container registry (ACR), and the Log Analytics workspace. These resources are deployed before the first regional stamp of a release unit is deployed. The resources are referenced in the Terraform templates for the stamps.

##### Front Door

While Front Door is a globally shared resource across release units, it's configuration is slightly different than the other global resources for two reasons:

1. To deploy Front Door, at least one backend for each backend pool must already exist. This is only after at least one release unit has been deployed.

2. Front Door must be reconfigured when a release unit is deployed. Front Door must be reconfigured to gradually switch over traffic to the new stamps.

The backend configuration of Front Door can't be directly defined in the Terraform template. The configuration is inserted with Terraform variables. The variable values are constructed before the Terraform deployment is started.

The individual component configuration for the Front Door deployment is defined as:

* Frontend - Session affinity is configured to ensure users don't switch between different UI versions during a single session.

* Backends - Front Door is configured with two types of backend pools:

    1. A pool for the static storage that serves the UI. The pool contains the storage accounts from all currently active release units. Different weights can be assigned to the backends from different release units to gradually move traffic to a newer unit. Each backend from a release unit should have the same weights assigned.

    2. A pool for the API. If there are release units with different API versions, then an API backend pool exists for each release unit. If all release units offer the same compatible API, all backends are added to the same backend pool and assigned different weights.

* Routing rules - There are two types of routing rules:

    1. A routing rule for the UI that is linked to the UI storage backend pool.

    2. A routing rule for each API currently supported by the backends. For example: **`/api/1.0/*`** and **`/api/2.0/*`**.

    If a release introduces a new version of the backend APIs, the changes will reflect in the UI that is deployed as part of the release. A specific release of the UI will always call a specific version of the API URL. Users served by a UI version will automatically use the respective backend API. Specific routing rules are needed for different instances of the API version. These rules are linked to the corresponding backend pools. In the event that a new API wasn't introduced, all API related routing rules link to the single backend pool. In this case, it doesn't matter if a user is served the UI from a different release than the API.

#### Release units

A release unit is several regional stamps per specific release version. Stamps contain all the resources which aren't shared with the other stamps. These resources are virtual networks, Azure Kubernetes Service cluster, Event Hub, and Azure Key Vault. Cosmos DB and ACR are configured with Terraform data sources.

### Deployment process

A blue/green deployment is the goal of the deployment process. A new release from a **`release/*`** branch is deployed into the **`prod`** environment. User traffic is gradually shifted to the new release.

As a first step in the deployment process of a new version, the infrastructure for the new release unit is deployed with Terraform. Execution of the infrastructure deployment pipeline deploys the new infrastructure from a selected release branch. In parallel to the infrastructure provisioning, the container images are built and pushed to the globally shared container registry (ACR). When the previous processes are completed, the application is deployed to the stamps. From the implementation viewpoint, it's one pipeline with multiple dependent stages. The same pipeline can be re-executed for hotfix deployments.

After the new release unit is deployed and validated, it's added to Front Door to receive user traffic.

A switch/parameter that distinguishes between releases that do and don't introduce a new API version. Based on if the release introduces a new API version, a new backend pool with the API backends must be created. Alternatively, new API backends can be added to an existing backend pool. New UI storage accounts are added to the corresponding existing backend pool. Weights for new backends should be set according to the desired traffic split. A new routing rule as described above must be created that corresponds to the appropriate backend pool.

As a part of the addition of the new release unit, the weights of the new backends should be set to the desired minium user traffic. If no issues are detected, the amount of user traffic should be increased to the new backend pool over a period of time. To adjust the weight parameters, the same deployment steps should be executed again with the desired values.

#### Release unit teardown

As part of the deployment pipeline for the a release unit, there is a destroy stage which removes all stamps once a release unit is no longer needed. Usually after all traffic has been moved to a new release version. This stage includes the removal of release unit references from Front Door. This is critical to enable the release of a new version at a later date. Front Door must point to a single release unit.

#### Checklists

As part of the release cadence, a pre and post release checklist should be used. 

    * **Pre-release checklist** - Before starting a release, check the following:

            * Ensure the latest state of the **`main`** branch was successfully deployed to and tested in the **`int`** environment.

            * Update the changelog file through a PR against the **`main`** branch.

            * Create a **`release/`** branch from the **`main`** branch.

    * **Post-release checklist** - Before old stamps are destroyed and their references are removed from Front Door, check that:

            * Clusters are no longer receiving incoming traffic.

            * Event Hubs don't contain any unprocessed messages.

### Limitations and risks of the update strategy

The update strategy described in this reference architecture has a some limitations and risks that should be mentioned:

    * Higher cost - When releasing updates, many of the infrastructure components will active twice for the release period.

    * Front Door complexity - The update process in Front Door is complex to implement and maintain. The ability to execute effective blue/green deployments with zero downtime is dependent on it working properly.

    * Small changes time consuming - The update process results in a longer release process for small changes. This can be partially mitigated with the hotfix process described in the previous section.

### Application data forward compatibility considerations

The update strategy can support multiple version of an API and work components executing concurrently. Because Cosmos DB is shared between two or more versions, there is a possibility that data elements changed by one version might not always match the version of the API or working consuming it. The API layers and workers must implement forward compatibility design. Earlier versions of the API or worker components processes data that was inserted by a later API or worker component version. It ignores parts it doesn't understand.


## Failure injection testing

### DNS failure

### Firewall block