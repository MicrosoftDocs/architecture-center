## Application insights
 - What am I looking for?
 - Application map

## Respond to alerts

## Failure analysis


--- 

## Dump zone

## Queries
Azure Mission-Critical uses different Kusto Query Language (KQL) queries to implement complex, custom queries as functions to retrieve data from Log Analytics. These queries are stored as individual files in the /src/infra/monitoring/queries directory (separated into global and stamp) and are imported and applied automatically via Terraform as part of each infrastructure pipeline run.

This approach separates the query logic from the visualization layer. It allows us to call these functions individually and use them either directly to retrieve data from Log Analytics or to visualize the results in Azure Dashboards, Azure Monitor Workbooks or 3rd-Party dashboarding solutions like Grafana.

Here's an example - the ClusterHealthStatus() (see the .kql file for details) query retrieves some key metrics per cluster and decides based on given thresholds if the status is "yellow" or "red":

## LogAnalytics Query

This result provides a granular overview about the cluster's health status based on the given metrics and thresholds. To sum this up and to get a more high-level overview per cluster, ClusterHealthScore() can be used:

LogAnalytics Query ClusterHealthScore



## Visualization
The Visualization of the Kusto Queries described above was implemented using Grafana. Grafana is used to show the results of Log Analytics queries and does not contain any logic itself. The Grafana stack is not part of the solution's deployment lifecycle, but released separately. For a detailed description of the Grafana deployment for Azure Mission-Critical, please refer to the Grafana README.


## Alerting
Alerts are an important part of the operations strategy. While there should also be more proactive means of monitoring, for example dashboards, alerts raise immediate attention to issues.

While most critical alert rules should be defined during the building of an application, rules will always require refinement over time. Outages caused by errors that went undetected, often lead to the creation of additional monitoring point and alert rules. Alerts could be delivered as emails, mobile push notifications, tickets created in an IT Service Management system etc. The important part is that they get routed to a place where they will be noticed and acted upon quickly.

A full definition and implementation of alert rules would go beyond the scope of the reference implementation. Thus, only a couple of examples are implemented. In the reference implementation we only use email notifications but other alert sinks can also be configured using Terraform. To avoid unnecessary noise, alerts are not created in the E2E environments.

Alerts in Azure can be configured at various levels. For each category we define a couple of sample alerts which we consider most valuable. Not all of the samples are actually implemented in the reference implementation, but other alerts can follow the same route.

Azure Resource-level alerts
Resource-level alerts are configured on an Azure resource itself. It is therefore scoped to only that resource and does not correlate with signals from other resources.

Activity Log Alerts
Valuable alerts
Metric Alerts
Metric alerts are limited to the built-in metrics that Azure provides for a given resource.

Valuable alerts
Front Door - Backend Health dropping under threshold
Cosmos DB - Availability dropping under threshold
Cosmos DB - RU consumption percentage reaching a threshold
Event Hub Namespace - Quota Exceeded Errors (or Throttled Requests) greater than 0
Event Hub Namespace - Outgoing messages dropping to 0
Key Vault - Overall Vault Availability dropping under threshold
AKS - Unschedulable pods greater than 0 for sustained period
Storage Account - Availability dropping under threshold
Azure Front Door - Backend Health
This alert is implemented as a sample as part of the reference implementation.

A metric alert is configured as part of the infrastructure deployment on Front Door (/src/infra/workload/alerts.tf). We are using the "Backend Health Percentage" metric to create an alert when any one backend's health, as detected by Front Door, falls under a certain threshold in the last minute.

Backend Health Metric

Many causes for the backend health to drop should also be detected on other levels (and potentially earlier). For instance, anything that causes the Health Service to report "unhealthy" to Front Door's health probes should also be logged to Application Insights. Similarly, issues on the static storage accounts should also be detected through the collected diagnostic logs. However, there can still be outages which are not showing up in other signals.

Front Door does not provide any further insight into why the backend health for a certain backend drops. Therefore, we also implemented URL Ping tests in each stamp's Application Insights resource (/src/infra/workload/releaseunit/modules/stamp/monitoring.tf). This calls the same URL of the cluster HealthService (as well as checking the static website storage account) as Front Door does and provides detailed logging and tracing. We can use this to help us determine the cause for an outage: Was the cluster reachable at all? Is the Ingress Controller routing the request correctly? Did the HealthService respond with a 503 response?

Application Insights URL Ping test

Log Analytics / Application Insights query-based alerts
Alerts based on the data stored in a Log Analytics workspace can be created using any arbitrary query. Therefore they are well-suited for correlation of events from multiple sources. Also, they can be used to create alerts based on application-level signals as opposed to only resource-level events and metrics.

Valuable alerts
Percentage of 5xx responses / failed requests exceeding a threshold
The result of the ClusterHealthScore() function dropping below 1
Spike in entries in the Exception table (not all errors are correlated to incoming requests so they won't be covered by the previous alert, for instance exceptions in the BackgroundProcessor)
Percentage of 5xx responses / failed requests exceeding a threshold
This alert is implemented as a sample as part of the reference implementation.

To demonstrate their setup and usage, a query-based alert on Application Insights is configured as part of the infrastructure deployment within each stamp (/src/infra/workload/releaseunit/modules/stamp/alerts.tf). It looks at the number of responses sent by the CatalogService which start with a 5xx status code. If those exceed the set threshold within a 5 minute window, it will fire an alert.

## Failure analysis
"What does it take for Azure Mission-Critical to go down?"

This article walks through a number of possible failure scenarios of the various components of the Azure Mission-Critical reference implementation. It does not claim to be complete since there can always be failure cases which we have not thought of yet. So for any workload, this list should be a living document that gets updated over time.

Composing the failure analysis is mostly a theoretical planning exercise. It can - and should - be complemented by actual failure injection testing. Through testing, at least some of the failure cases and their impact can be simulated and thus validate the theoretical analysis. See the related article for failure injection testing that was done as part of Azure Mission-Critical.

Outage risks of individual components
Each of the following sections lists risks for individual components and evaluate if their failure can cause an outage of the whole application (the outage column).

Azure Active Directory
Risk	Impact/Mitigation/Comment	Outage
Azure AD becomes unavailable	Currently no possible mitigation in place. Also, multi-region approach will likely not (fully) mitigate any outages here as it is a global service. This is a hard dependency we are taking.
Mostly AAD is being used for control plane operations like the creation of new AKS nodes, pulling container images from ACR or to access Key Vault on pod startup. Hence, we expect that existing, running components should be able to keep running when AAD experiences issues. However, we would likely not be able to spawn new pods or AKS nodes. So in scale operations are required during this time, it could lead to a decreased user experience and potentially to outages.	Partial
Azure DNS
Risk	Impact/Mitigation/Comment	Outage
Azure DNS becomes unavailable and DNS resolution fails	If Azure DNS becomes unavailable, the DNS resolution for user requests as well as between different components of the application will likely fail. Currently no possible mitigation in place for this scenario. Also, multi-region approach will likely not (fully) mitigate any outages here as it is a global service. Azure DNS is a hard dependency we are taking.
Using some external DNS services as backup would not help much either, since all the PaaS components we are using also rely on Azure DNS.
Bypassing DNS by switching to IP is not an option, because Azure services don’t have static, guaranteed IP addresses.	Full
Front Door
Risk	Impact/Mitigation/Comment	Outage
General Front Door outage	If Front Door goes down entirely, there is no mitigation for us. We are taking a hard dependency on it.	Yes
Routing/frontend/backend configuration errors	Can happen due to mismatch in configuration when deploying.
Should be caught in testing stages. However, some things like frontend configuration with DNS is specific to each environment.
Mitigation: Rolling back to previous configuration should fix most issues. However, as changes take a couple of minutes in Front Door to deploy, it will cause an outage.	Full
Managed SSL certificate is deleted	Can happen due to mismatch in configuration when deploying. Should be caught in testing stages. Technically the site would still work, but SSL cert errors will prevent users from using it.
If it ever happens, re-issuing the cert can take around 20 minutes (plus fixing and re-running the pipeline).	Full
Cosmos DB
Global replication protects Cosmos DB instances from regional outage. The Cosmos SDK maintains an internal list of database endpoints and switches between them automatically.

Risk	Impact/Mitigation/Comment	Outage
Database/collection is renamed	Can happen due to mismatch in configuration when deploying – Terraform would overwrite the whole database, which could result in data loss (this can be prevented by using database/collection level locks).
Application will not be able to access any data. App configuration needs to be updated and pods restarted.	Yes
Regional outage	Azure Mission-Critical has multi-region writes enabled, so in case of failure on read or write, the client retries the current operation and all the future operations are permanently routed to the next region in order of preference. In case the preference list only had one entry (or was empty) but the account has other regions available, it will route to the next region in the account list.	No
Extensive throttling due to lack of RUs	Depending on how we decide on how many RUs (max setting for the auto scaler), we want to deploy and what load balancing we employ on Front Door level, it could be that certain stamp(s) run hot on Cosmos utilization while others could still serve more requests.
Could be mitigated by better load distribution to more stamps – or of course more RUs.	No
Container Registry
Risk	Impact/Mitigation/Comment	Outage
Regional outage	Container registry uses Traffic Manager to failover between replica regions. Thus, any request should be automatically re-routed to another region. At worst, no Docker images can be pulled for a couple of minutes by a certain AKS node while DNS failover needs to happen.	No
Image(s) get deleted (e.g. by manual error)	Impact: No images can be pulled. This should only affect newly spawned/rebooted nodes. Existing nodes should have the images cached already.
Mitigation: If detected quickly enough, re-running the latest build pipelines should bring the images back into the registry.	No
(stamp) AKS cluster
Risk	Impact/Mitigation/Comment	Outage
Cluster upgrade fails	AKS Node upgrades should occur at different times across the stamps. Hence, if one if upgrades fail, other cluster should not be affected. Also, cluster upgrades should happen in a rolling fashion across the nodes so that not all nodes will become unavailable.	No
Application pod is killed when serving request	Should not happen because cluster upgrades use "cordon and drain" with a buffer node.	No
There is not enough compute capacity in the datacenter to add more nodes	Scale up/out operations will fail, but it shouldn’t affect existing nodes and their operation. Ideally traffic should shift automatically to other regions for load balancing.	No
Subscription runs out of CPU core quota to add new nodes	Scale up/out operations will fail, but it shouldn’t affect existing nodes and their operation.
Ideally traffic should shift automatically to other regions for load balancing.	No
Let’s Encrypt SSL certificates can’t be issued/renewed	Cluster should report unhealthy towards Front Door and traffic should shift to other stamps.
Mitigation: Needs manual investigation on what happened.	No
Pod utilization reaches the allocated capacity	When resource requests/limits are configured incorrectly, pods can reach 100% CPU utilization and start failing requests.
During load test the observed behavior wasn’t blocking – application retry mechanism was able to recover failed requests, causing a longer request duration, without surfacing the error to the client. Excessive load would eventually break it.	No (if not excessive)
3rd-party container images / registry not available	Some components like cert-manager and ingress-nginx require downloading container images from external container registries (outbound traffic). In case one or more of these repositories or images are unavailable, new instances on new nodes (where the image is not already cached) might not be able to start.	Partially (during scale and update/upgrade operations)
(stamp) Event Hub
Risk	Impact/Mitigation/Comment	Outage
No messages can be sent to the Event Hub	Stamp becomes unusable for any write operations. Health service should automatically detect this and take the stamp out of rotation	No
No messages can be read by the BackgroundProcessor	Messages will queue up, but no messages should get lost since they are persisted.
Currently this is not covered by the Health Service. But there should be monitoring/alerting in place on the Worker to detect errors in reading messages.
Mitigation: The stamp needs to be manually disabled until the problem is fixed.	No
(stamp) Storage Account
Risk	Impact/Mitigation/Comment	Outage
Storage account becomes unusable by the Worker for Event Hub checkpointing	Stamp will not be able to process any messages from the Event Hub.
The storage account is also used by the HealthService, so we expect issues with storage to be detected by the HealthService and the stamp should be taken out of rotation.
Anyway, as Storage is a foundational service, it can be expected that other services in the stamp would also be impacted at the same time.	No
Static website encounter issues	If serving of the static web site encounters any issues, this should be detected by Front Door and no more traffic should be send to this storage account. Plus, we will use caching in Front Door as well.	No
(stamp) Key Vault
Risk	Impact/Mitigation/Comment	Outage
Key Vault becomes unavailable for GetSecret operations	At the start of new pods, the AKS CSI driver will fetch all secrets from Key Vault. This would not work; hence we cannot start new pods anymore.
There is also automatic update (currently every 5 minutes). The update will fail (errors show up in kubectl describe pod but the pod keeps working.	No
Key Vault becomes unavailable for GetSecret or SetSecret operations	No new deployments can be executed. Currently, this might cause the entire deployment pipeline to stop, even if only one region is impacted.	No
Key Vault throttling kicks in	Key Vault has a limit of 1000 operations per 10 seconds. Due to the automatic update of secrets, we could in theory hit this limit if we had many (thousands) of pods in a stamp.
Possible mitigation: Decrease update frequency even further or turn it off completely.	No
(stamp) Application
Risk	Impact/Mitigation/Comment	Outage
Misconfiguration	Incorrect connection strings or secrets injected to the app. Should be mitigated by automated deployment (pipeline handles configuration automatically) and blue-green rollout of updates.	No
Expired credentials (stamp resource)	If, for example, Event Hub SAS token or Storage Account key was changed without properly updating them in Key Vault so that the pods can use them, the respective application component will start to fail. This should then also affect the Health Service and hence the stamp should be taken out of rotation automatically.
Mitigation: As a potential way to not run into these issues in the first place, using AAD-based authentication all services which support it, could be implemented. However, when using AKS, this would require to use Pod Identity to use Managed Identities within the pods. We considered this but found pod identity not stable enough yet and thus decided against using it for now. But this could be a solution in the future.	No
Expired credentials (globally shared resource)	If, for example, Cosmos DB API key was changed without properly updating it in all stamp Key Vaults so that the pods can use them, the respective application components will start to fail. This would likely bring all stamps down at about the same time and cause an workload-wide outage. See the article on Key Rotation for an example walkthrough how to execute this process properly without downtime. For a possible way around the need for keys and secrets in the first place using AAD auth, see the previous item.


## Operational Procedures
While the reference implementation of Azure Mission-Critical only serves as a demonstration and thus is not really run in production, there are a couple of operational procedures that are lined out in this article, which are still relevant.

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

This can be found by browsing to the Resource Group of the primary stamp of any release unit (prod, int or e2e). There is a resource called <prefix>-global-dashboard dashboard in resource group
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