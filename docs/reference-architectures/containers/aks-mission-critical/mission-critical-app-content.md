![Application flow](./images/application-design-flow.png)


## Application composition
- Introduce layered approach
- Microservices as the recommended pattern
    - Loose coupling/high cohesion
    - List some pros and cons
    - 12-Factor described in the table. 

![Application flow](./images/application-design-flow.png)


## Service discoverablity
- Service object and ClusterIP
- Cluster DNS
- Service-to-service communication through APIs
## Networking path within the cluster
- Load balancing
- Ingress to service
- Network policies
## Identity and access management
- Pod identity
- Authentication
## Asynchronous messaging
- Technology choice
- De-duping capability
- Idempotency
- Failure analysis
    - Use case: Sender crashes after messages goes to event hubs
    - Use case: Receiver crashes after writing to DB
    - DLQ management
- Resiliency 
## Instrumentation
- What data to capture (logs, metrics, deployment ennvironment)
- Distributed tracing
- Application profiling
- Structured logging
- APM enabling
## Scalability
- Independent scaling
    - HPA
- How to determine scale values
## Health monitoring
- Health service
- Health and readiness probes
## Secret management
- Application configuration
- Certificates
- Keys

## Load testing

---

## Dump zone

## The workload

The Azure Mission-Critical online reference implementation considers a simple web shop catalog workflow where end users can browse through a catalog of items, see details of an item, and post ratings and comments for items. Although fairly straight forward, this application enables the Reference Implementation to demonstrate the asynchronous processing of requests and how to achieve high throughput within a solution.

The workload consists of three components:

1. **User interface (UI) application** - This is used by both requestors and reviewers.
1. **API application** (`CatalogService`) - This is called by the the UI application, but also available as REST API for other potential clients.
1. **Worker application** (`BackgroundProcessor`) - This processes write requests to the database by listening to new events on the message bus. This component does not expose any APIs.

## Queue-based asynchronous processing

In order to achieve high responsiveness for all operations, Azure Mission-Critical implements the [Queue-Based Load leveling pattern](https://docs.microsoft.com/azure/architecture/patterns/queue-based-load-leveling) combined with [Competing Consumers pattern](https://docs.microsoft.com/azure/architecture/patterns/competing-consumers) where multiple producer instances (`CatalogService` in our case) generate messages which are then asynchronously processed by consumers (`BackgroundProcessor`). This allows the API to accept the request and return to the caller quickly whilst the more demanding database write operation is processed separately.

![Competing consumers diagram](/docs/media/competing-consumers-diagram.png)

*Image source: [docs.microsoft.com](https://docs.microsoft.com/azure/architecture/patterns/competing-consumers)*

- The current Azure Mission-Critical online reference implementation uses **Azure Event Hub** as the message queue but provides interfaces in code which enable the use of other messaging services if required (Azure Service Bus was successfully tested as an alternative solution).
- **ASP.NET Core API** is used to implement the producer REST API.
- **.NET Core Worker Service** is used to implement the consumer service.

Read operations are processed directly by the API and immediately return data back to the user.

![List games reaches to database directly](/docs/media/application-design-operations-1.png)

High-scale write operations (e.g. *post rating, post comment*) are processed asynchronously. The API first sends a message with all relevant information (type of action, comment data, etc.) to the message queue and immediately returns `HTTP 202 (Accepted)` with additional `Location` header for the create operation.

Messages from the queue are then processed by BackgroundProcessor instances which handle the actual database communication for write operations. The BackgroundProcessor scales in and out dynamically based on message volume on the queue.

![Post rating is asynchronous](/docs/media/application-design-operations-2.png)

There is no backchannel which communicates to the client if the operation completed successfully and so the client application has to proactively poll the API to for updates.

## Authentication

This online reference implementation of Azure Mission-Critical uses a simple authentication scheme based on API keys for some restricted operations, such as creating new catalog items or deleting comments.
More advanced scenarios such as user authentication and user roles are not in scope here.

## Scalability & Availability

The `CatalogService` as well as the `BackgroundProcessor` workload component can scale in and out individually. Both services are stateless, packaged as and deployed via Helm charts to each of the (regional) stamps, have proper requests and limits in place and have a pre-configured auto-scaling (HPA) rule in place.

`CatalogService` performance has a direct impact on the end user experience. The service is expected to be able to scale out automatically to provide a positive user experience and performance at any time.

The `CatalogService` has at least 3 instances per cluster to spread automatically across three Availability Zones per Azure Region. Each instance requests one CPU core and a given amount of memory based on upfront load testing. Each instance is expected to serve ~250 requests/second based on a standardized usage pattern. `CatalogService` has a 3:1 relationship to the nginx-based Ingress controller.

The `BackgroundProcessor` service has very different requirements and is considered a background worker which has no direct impact on the user experience. As such, `BackgroundProcessor` has a different auto-scaling configuration than `CatalogService` and it can scale between 2 and 32 instances (which matches the max. no. of EventHub partitions). The ratio between `CatalogService` and `BackgroundProcessor` is around 20:2.

All workload components as well as supporting services like the `HealthService` and dependencies like `ingress-nginx` are configured with at least 3 or in case of the `HealthService` 2 instances (replicas) per cluster. This is supposed to prevent certain availability issues and to ensure that the service is always available. The instances are automatically spread across nodes and therefore also across Availability Zones.

In addition to that, each component of the workload including dependencies like `ingress-nginx` has [Pod Disruption Budgets (PDBs)](https://docs.microsoft.com/azure/aks/operator-best-practices-scheduler#plan-for-availability-using-pod-disruption-budgets) configured to ensure that a minimum number of instances is always available.

---

## 12-Factor App

Azure Mission-Critical aligns to the [12-Factor Application](https://12factor.net/) Methodology as follows.

| Factor | Azure Mission-Critical Alignment |
| --- | --- |
| [Codebase](https://12factor.net/codebase) | All Azure Mission-Critical assets are stored and tracked under source control including CI/CD pipelines, application code, all test code and scripts, infrastructure as code, and configuration management.<br /><br />There is one Mission-Critical codebase and multiple deployments to multiple environments are supported. |
| [Dependencies](https://12factor.net/dependencies) | Mission-Critical applications have NuGet package dependencies which are restored into the build environment.<br /><br />Azure Mission-Critical makes no assumptions about the existence of any dependencies in the build environment. |
| [Config](https://12factor.net/config) | Variable files, both general as well as per-environment, store deployment and configuration data and are stored in the source code repository. Sensitive values are stored in Azure DevOps variable groups.<br /><br />All application runtime configuration is stored in Azure Key Vault - this applies to both, secret and non-sensitive settings. The Key Vaults are only populated by the Terraform deployment. The required values are either sourced directly by Terraform (such as database connection strings) or passed through as Terraform variables from the deployment pipeline.<br /><br />The applications run in containers on Azure Kubernetes Service. Containers use Container Storage Interface bindings to enable Mission-Critical applications to access Azure Key Vault configuration values, surfaced as environment variables, at runtime.<br /><br />Configuration values and environment variables are standalone and not reproduced in different runtime "environments", but are differentiated by target environment at deployment. |
| [Backing Services](https://12factor.net/backing-services) | Mission-Critical applications treat local and third-party services as attached resources, accessed via URL or locator/credentials stored in config.<br /><br />Different resource instances can be accessed by changing the URL or locator/credentials in config. |
| [Build, release, run](https://12factor.net/build-release-run) | Mission-Critical CI/CD pipelines have separate stages. Application stages include build, test, and deploy. Infrastructure stages include global and regional stamp deploy as well as configuration. Releases and runs have distinct IDs. |
| [Processes](https://12factor.net/processes) | Mission-Critical applications are stateless in process, share nothing, and store state in a backing service, Azure Cosmos DB.<br /><br />Sticky sessions are not used.<br /><br />The loss of a stamp will not lose any committed data as it will have been persisted to a backing store. |
| [Port binding](https://12factor.net/port-binding) | Azure Mission-Critical applications run in containers. Endpoints are exported via port binding.<br /><br />Containers are built from images which include the required HTTPS services; no serving capabilities are injected at runtime. |
| [Concurrency](https://12factor.net/concurrency) | Azure Mission-Critical runs different workloads in distinct processes.<br /><br />The front end runs in an HTTP serving process suited for handling web requests, whereas the back end runs in a worker process suited for handling background tasks.<br /><br />The processes manage internal multiplexing/multi-threading. Horizontal scaling is enabled by the shared-nothing, stateless design. |
| [Disposability](https://12factor.net/disposability) | Azure Mission-Critical applications are shared-nothing and stateless. They can be started or stopped with little or zero notice.<br /><br />Hosting in containers on Azure Kubernetes Service enables very fast startup and shutdown which is important for resilience in case of code or config changes. |
| [Dev/prod parity](https://12factor.net/dev-prod-parity) | Azure Mission-Critical is designed for continuous integration and deployment to keep the gaps between development and downstream environment very small.<br /><br />As developers push code updates, testing and deployment are fully automated through CI/CD pipelines.<br /><br />The same pipelines are used to deploy and configure multiple environments as well as build and deploy the application code to the environments, minimizing drift between environments. |
| [Logs](https://12factor.net/logs) | Azure Mission-Critical applications write logs, metrics, and telemetry to a backing log system, Azure Monitor.<br /><br />The applications do not write log files in the runtime environment, or manage log formats or the logging environment. There are no log boundaries (e.g. date rollover) defined or managed by the applications, rather logging is an ongoing event stream and the backing log system is where log analytics and querying are performed. |
| [Admin processes](https://12factor.net/admin-processes) | Administrative tasks such as environment (re)configuration would be performed in the same deployment pipelines used to initially configure and deploy the environments. Deployments are idempotent and incremental due to the underlying Azure Resource Manager platform. |

---
[Azure Mission-Critical - Full List of Documentation](/docs/README.md)