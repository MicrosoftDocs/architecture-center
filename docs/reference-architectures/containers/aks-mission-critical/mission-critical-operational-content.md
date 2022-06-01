While the reference implementation of Azure Mission-Critical only serves as a demonstration and thus is not really run in production, there are a couple of operational procedures that are lined out in this article, which are still relevant.

---

## Dump zone

General debugging / issue investigation
Transient Pipeline Failures
Package / Dependency updates
INT Deployment pipeline watch
Key and Secret Rotation
General debugging / issue investigation
The reference implementation contains various dashboards, monitoring points and logging/metrics sinks which are useful for monitoring operations as well as for troubleshooting.

Dashboards
There are currently two types of dashboards provided as part of the Reference Implementation. During normal operation, both dashboards should be routinely looked at by the operations team.

Azure Portal Dashboard

This can be found by browsing to the Resource Group of the primary stamp of any release unit (prod, int or e2e). There is a resource called '<prefix>-global-dashboard' dashboard in resource group
Click on that resource and select "Go to dashboard

azure portal dashboard

This dashboard provides metrics from various of the used Azure services such as Front Door, Cosmos DB, Event Hubs or AKS (per stamp in case of the regional resources).
Looking at this dashboard can often provide at a glance insights if there are problems (arising). For instance, if the incoming and outgoing message count of one of the Event Hubs differ for an extended period of time, this mostly means a backlog of messages is building up - which often is caused by a fully utilized Cosmos DB.
Grafana Dashboard

This dashboard shows the visualization of the Health Model.
Logs and metrics
All logs and metrics are sent into different Azure Monitoring Log Analytics workspaces. Those are usually the go-to point when investigating issues. Often an issue report might come from a user that a request has failed. In this case the first item to ask for is the correlation ID that is provided with error messages to the user. Ideally, the user can also provide the values of the HTTP response headers X-Server-Location and X-Server-Name, although they are not necessary.

Equipped with this information the operator can look up the failed request in Application Insights through the "Transaction search". The X-Server-Location will indicate which stamp the request was served from.

This will surface any traces, metrics and dependency calls that were made as part of the transaction and thus allow to drill into the cause of the issue.

Transient Pipeline Failures
There are some points in the deployment pipeline which tend to create transient failures. For most of them, a simple re-run of the failed job fixes the issue. No need to re-run the entire pipeline. When the failed job succeeds in a retry, all subsequent steps will also be executed. A couple of examples which were observed so far:

Terraform init failing after 1 second with no apparent error message
Terraform init failing with an authorization error against the backend storage account
Deployment of one of the workloads on AKS failing after many retry attempts (mostly the CatalogService)
Terraform deployment of Azure Monitor saved queries failing with a Bad Request error
Download of some dependency, e.g. Terraform CLI or Helm
Package / Dependency updates
A critical task for any application is to keep up to date with package / dependency updates. Be it for security fixes or bug repairs. To help with this task, Dependabot is configured. It will automatically create Pull Requests for various dependency updates:

.NET NuGet packages
JavaScript NPM packages
Terraform Provider
Make sure to review and merge those Pull Requests in a timely manner. After you merged critical fixes, you should create a new release towards prod (after it was validated on int).

Dependabot does currently not watch all dependencies which are being used in the reference implementation (for example it does not watch the Kubernetes or Helm versions). Ensure that you have processes in place to watch new releases of all dependencies used in your solution.

INT Deployment pipeline watch
The deployment pipeline from the main branch to the int environment is executed nightly. You should create a notification in Azure DevOps (or similar means) to be notified when that deployment fails for whatever reason. Since the pipeline is not started by a physical user, by default no notifications are sent out.

In Azure DevOps a notification subscription can, for example, look like this (Project Settings -> Notifications -> New Subscription) build fail notification