## CI/CD pipelines
Azure Pipelines. This part of the Azure DevOps (ADO) service is being used by Azure Mission-Critical for all build, test and release tasks. It is a well proven and feature rich tool set that is used in many organizations, both when targeting Azure and even when not targeting Azure as the deployment environment.

GitHub Actions was considered instead of ADO and for build-related tasks (CI) it would have worked equally well - with the added benefit that source code and pipeline would have lived in the same place. However, Azure Pipelines were chosen because of richer Continuous Deployment (CD) capabilities. It is expected that GitHub Actions will reach parity with ADO in the future, but for now, ADO is the best choice.

Build Agents. The online reference implementation of Azure Mission-Critical uses Microsoft Hosted build agents as this removes any management burden on the developers to maintain and update the build agent whilst also making start up times for build jobs quicker. The exception is when using the connected version of the Azure Mission-Critical reference implementation, which does require the use of self-hosted Build Agents.

See DevOps Pipelines for more details about the concrete pipeline implementation.


## Zero-downtime Update Strategy
"How to deploy updates to Azure Mission-Critical without causing any downtime?"

High-level overview
In short, the update process for Azure Mission-Critical is that any update, no matter whether infrastructure or application-related, is deployed on fully independent stamps called release units. Only the globally shared infrastructure components such as Front Door, Cosmos DB and Container Registry are shared across release units.

This means that for any update, existing stamps are not touched but instead completely new stamps (as many as currently existing) are deployed and that the new application version will only be deployed to these new stamps. Then, these new stamps are added to the global load balancer (Azure Front Door) and traffic is gradually moved over to the new stamps (i.e. blue/green approach). Once all traffic is served from the new release unit with no issues, the previous release units are deleted.

For releases which introduce a new API version that is not compatible with the previously deployed version present a challenge for traffic switchover but can be overcome using a well automated (and tested) configuration of Front Door.

The following diagram summarizes the deployment process:

update strategy diagram

The following diagram is a snapshot of the Azure DevOps deployment pipeline for Prod.

Deployment-Pipeline-PROD

Infrastructure vs. Application-level updates
There are two main parts involved in the Azure Mission-Critical reference implementation:

Underlying infrastructure. This is mostly deployed using Terraform and its associated configuration.
Application. This on top, which is based on Docker containers and, for the UI, npm-built artifacts (HTML and JavaScript).
In many customer systems there is an assumption that application updates are more frequent than infrastructure updates, and, as such, there are different update procedures for each. Within a public cloud infrastructure, these changes can happen at a much faster pace and it is this and the rate of change on the Azure platform that led Azure Mission-Critical to utilize only one deployment process whether application or infrastructure. This allows:

One consistent process. This mean less chances for mistakes if changes in both infrastructure and application get mixed together within a release (whether intentional or not).
Enables proper blue/green deployment for every update utilizing a gradual migration of traffic to the new release.
Easier deployment and debugging of the application since a compute cluster (in fact the entire stamp) will never host multiple versions side-by-side but only ever one.
Simple rollback by switching traffic back to stamps that still run the previous version.
No manual changes or configuration drift. These won't creep in over time as every environment is a completely fresh deployment from the latest IaC definitions.
Branching strategy
A foundation of the Azure Mission-Critical update strategy is around how branches are used in the Git repository. Azure Mission-Critical uses 3 types of branches:

feature/* and fix/* branches

These are the entry points for any change. They are created by developers and should be named something like feature/catalog-update or fix/worker-timeout-bug. Once changes are ready to be merged, a pull request (PR) against the main branch needs to be created. Every PR needs to be approved by at least one reviewer. With very few exceptions, every change that is proposed in a PR must run through the E2E (end-to-end) validation pipeline. The E2E pipeline can – and should – also be used by developers to test and debug their changes on a complete environment. For this, the E2E pipeline can be executed without the destroy step at the end. The environment can then live for a longer period of time with new updates to the branch quickly getting released to it.
main branch

This is considered a continuously forward moving and stable branch and is mostly used for integration testing. Changes are only to come into main through PRs – a branch policy prohibits any other direct writes to it. From the main branch nightly releases against the permanent integration (int) environment are executed automatically. main is considered stable. It should be safe to assume that at any given time a release could be created from it.
release/* branches

These are only created from the main branch and follow the format release/2021.7.X. Using branch policies, only repo administrators are allowed to create release/* branches. Only these branches are used to deploy to the prod environment.
Hotfixes
For those very rare occasions where a hotfix e.g. of a bug, is required urgently and can not go through the regular release process of blue/green deployment, there is a hotfix path available. Valid examples of hotfixes are critical security updates or issues which break the user experience not caught in testing.

First, the hotfix needs to be created in a new fix/* branch and then merged into main using a regular PR. From there, instead of creating a new release branch, this hotfix is "cherry-picked" into an existing release branch (This branch is usually already deployed to the prod environment). Lastly, the CI/CD pipeline that originally deployed this release branch, including all tests, is executed again and will now also deploy the hotfix.

For this to work without major issues, it is important that the hotfix consists of only a very small number of isolated commits that can easily be cherry-picked and integrated into the release branch. If this is not the case, it is a good indicator that the change does not qualify as a hotfix and should rather be deployed as a full new release (potentially combined with a rollback to a former stable version until the new release can be deployed).

Environments
As already described in the previous section, Azure Mission-Critical uses two types of environment: short-lived and permanent.

Short-lived
These environments are deployed using the E2E validation pipeline. They are either used for pure validation where they are created from scratch (usually from a feature/* branch), run through a number of tests and then destroyed again if all tests were successful. They can also be used as debugging environments for developers. In this case they are deployed in the same way but are not destroyed immediately afterwards. They are usually kept around for a no more than a few days and should be deleted when the corresponding PR of the feature branch is merged.

Permanent
These are integration (int) and production (prod) environments and live continuously i.e. not destroyed. They also use fixed domain names like int.mission-critical.app. In a real-world scenario, customers would probably also add a staging (or "pre-prod") environment. This would be used to deploy and validate release/* branches with the same update process as in prod (i.e. blue/green deployment). Azure Mission-Critical does not have a staging environment simply for cost reasons.

Integration (int)
int is deployed every night from the main branch. It is deployed using the same process as prod, although with a much faster switchover of the traffic from the previous release unit. Instead of gradually switching traffic over multiple days as in prod, the process for int completes within a few minutes/hours so that the updated environment is ready by morning. Old stamps are automatically deleted if all tests in the pipeline have been successful.

Production (prod)
prod is only deployed from release/* branches and is different from int in that it uses more granular steps for the traffic switchover - with manual approval gates in between. Each release creates completely new regional stamps and deploys the new application version to these stamps. Existing stamps are not touched in the process. The most important consideration for prod is that it should be "always on", meaning that no planned or unplanned downtime should ever occur. The only exception to this could be foundational changes to the database layer, where a planned maintenance windows might be needed.

Shared and dedicated resources
It is important to understand the different types of resources that exist in the Azure Mission-Critical deployment for the permanent environments (int and prod). These are either globally shared resources or dedicated to a particular release and exist only until the next release unit has taken over.

Globally shared resources
All resources shared between release units are defined in an independent Terraform template. These mainly consist of Front Door, Cosmos DB, Container Registry (ACR) and the Log Analytics workspace. They are deployed before the first regional stamp of any release unit can be deployed. The resources are then referenced in the Terraform templates for the stamps.

Release Units
A release unit consists of several regional stamps per specific release version. Usually the Azure regions used would be the same as for the previous version, but there is no reason they can not be changed. Stamps contain all the resources which are not shared with other stamps (and thus also not across release units). Most notably those are: VNet, AKS cluster, Event Hub, and Key Vault. Other resources, like Cosmos DB or ACR are being pulled in using Terraform data sources.

Front Door
While Front Door is also globally shared across release units, its configuration differs slightly from the other global resources for two main reasons:

To deploy Front Door, at least one backend for each backend pool needs to already exist – and this can only be the case after at least one release unit has been deployed.
Front Door needs to be reconfigured every time a release unit gets deployed and then again when needing to gradually switch over traffic to the new stamps.
Owing to these factor, the backend configuration of Front Door can not directly defined in the Terraform template but instead is injected via Terraform variables. The variable values are constructed before the Terraform deployment is started.

Frontend
On the frontend, session affinity is configured to make sure users do not switch between different UI versions during one session.

Backends
Front Door is configured with two types of Backend Pools:

One pool for the static storage which serves the UI. This contains the storage accounts from all currently active release units. Different weights can be assigned to the backends from different release units to gradually move traffic to the newer unit. Each backend from a release unit should have the same weights assigned.

API Backend pool(s): If there are release units running with different API versions (i.e. the later release unit introduces a new API version), then there is an API backend pool for each release unit. If all release units offer the same compatible API, all backends are added to the same backend pool and assigned different weights - similar to the UI pool as described above.

Routing rules
Like the backends, there are two types of routing rules:

One routing rule for the UI which is linked to the UI-storage backend pool.
For the APIs there will be at any time one or more rules i.e. one for each API version which is currently supported by the backend(s). For example: /api/1.0/* and /api/2.0/*.
If a release introduces a new version on the backend APIs (e.g. from catalog/1.0 to catalog/2.0), these changes will also reflect in the UI that is deployed as part of the release. A specific release of the UI will always call a specific version of the API URL. Hence, by being served a particular UI version a user will automatically use the respective backend API. For this, more specific routing rules are added, for instance /api/1.0/* and /api/2.0/*. These are linked to the corresponding backend pools. If no new API version was introduced, all API-related routing rules link to the one and only backend pool. In this case it does not matter if a user gets served with the UI from a different release than the API.

Deployment process
The following describes the process to deploy a new release from a release/* branch into prod and how the gradual shift of user traffic happens to achieve a blue/green deployment.

When deploying a new version, firstly the infrastructure of the new release unit needs to be deployed using Terraform. This happens by executing the infrastructure deployment pipeline and selecting the new release branch. In parallel to the infrastructure provisioning, container images are built and pushed to the globally shared ACR. Afterwards the application is deployed to the stamps. Overall, this part of the process is very similar to the E2E validation pipeline. From an implementation viewpoint, this is one pipeline with multiple dependent stages. The same pipeline can also be re-executed for hotfix deployments.

After new release unit has been deployed and validated, it needs to be wired up in Front Door so that user traffic can reach it. The following assumes that only one release unit is currently referenced in Front Door.

There needs to be a switch/parameter to distinguish between releases which do or do not introduce new, breaking API version. Based on whether the release introduces a new API version, a new backend pool with the API backends needs to be created, or, new API backends are added to the existing backend pool. Similarly, new UI storage accounts are added to the respective existing backend pool. Weights for new backends should be set according to the desired traffic split. In addition, a new routing rule as described above needs to be created.

As part of the initial addition of the new release unit, the weights of new backends should be set to the desired minimum (e.g. to start serving 20 % of user traffic). Over the course of the next few hours or days, the amount of traffic should be increased (assuming no issues are detected). To do this, the same deployment steps should be executed again but with different weight parameters.

Release unit teardown process
As part of the deployment pipeline for a release unit, there also is a destroy stage which removes all stamps once a release unit is no longer needed i.e. when all traffic was moved over to a new release version. This stage also includes the removal of the release unit references from Front Door. This is critical as in order to be able to release a new version later, Front Door must only be pointing to a single release unit.

Pre-release checklist
Before starting a release, check the following:

Ensure the latest state of the main branch was successfully deployed to and tested on int environment.
Update the changelog file (through a PR against main).
Create a release/ branch from main.
Post-release checklist
Before executing the last two steps in the pipeline (destroy old stamps and remove old stamps' references from Front Door) check that:

No more incoming traffic to the clusters.
Event Hubs do not contain any unprocessed messages.
Downsides and risks of this update strategy
This update strategy comes with a couple of inherent disadvantages and risks which need to be mentioned.

Higher cost around the time of releasing updates as many of the infrastructure components will be running twice for a certain period.
The update process in Front Door is complex to implement and to maintain. The ability to do proper blue/green deployments with zero downtime hinges on this working properly.
Longer release process for small changes (though this can be somewhat mitigated by the hotfix path described above).
Application data forward compatibility design considerations
This update strategy can support multiple versions of an API and worker components running at the same time. Since the Cosmos DB is shared between the two or more versions, there is the possibility that data elements changed by one version may not always match the version of the API or worker consuming it. To allow for this, the API layers and workers must implement forward compatibility design characteristics. To accomplish this, earlier versions of the API or worker components can process data that was inserted by later API or worker component versions, ignoring any parts it does not understand.