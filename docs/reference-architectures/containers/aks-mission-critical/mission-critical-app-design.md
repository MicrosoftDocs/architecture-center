---
title: Application design considerations for mission-critical workloads on Azure
description: Reference architecture for a workload that is accessed over a public endpoint without additional dependencies to other company resources - App Design.
author: msimecek
ms.author: zarhods
ms.date: 07/20/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: guide
products:
- azure-kubernetes-service
- azure-front-door
ms.category:
- containers
- networking
- database
- monitoring
categories: featured
---

# Application design considerations for mission-critical workloads


The Azure AKS Mission-Critical reference architecture considers a simple web shop catalog workflow where end users can browse through a catalog of items, see details of an item, and post ratings and comments for items. Although fairly straight forward, this application enables the Reference Implementation to demonstrate the asynchronous processing of requests and how to achieve high throughput within a solution. The application's design also focuses on reliability and resiliency.

## Application composition

The application consists of five components:

1. **User interface (UI) application** - This is used by both requestors and reviewers.
1. **API application** (`CatalogService`) - This is called by the the UI application, but also available as REST API for other potential clients.
1. **Worker application** (`BackgroundProcessor`) - This processes write requests to the database by listening to new events on the message bus. This component does not expose any APIs.
1. **Health check application** (`HealthCheck`) - This is used to check the health of the application.
1. **Ingress application** (`Ingress`) - This is used to expose the application as a public endpoint.
1. ?? cert manager?

![Application flow](./images/application-design-flow.png)

`CatalogService`, `BackgroundProcessor`, `HealthCheck`, and `Ingress` are deployed to the Kubernetes cluster as pods, not dependent on each other, completely stateless, and independently scalable.

The `CatalogService` and `BackgroundProcessor` components are dependent on writing and reading messages from Event Hub. The `BackgroundProcessor` and `HealthCheck` components are dependent on writing data to Cosmos DB, and the `CatalogService` component is dependent on reading data from Cosmos DB. `CatalogService`, `BackgroundProcessor`, and `HealthCheck` are dependent on Azure KeyVault for the connection strings and other connection information to connect to CosmosDB and Event Hub. Each component uses the CSI Secrets Store Driver to load the connection details from Azure KeyVault when the pod is created.

?? does cert manager load certs from keyvault via CSI?

The `CatalogService`, `BackgroundProcessor`, and `HealthCheck` components use the Cosmos DB .NET Core SDK to connect to Cosmos DB. The SDK includes logic to maintain alternate connections to the database in case of connection failures.

Within the cluster, `Ingress` load-balances requests between multiple pod instances as each component is scaled up or down. Each service only communicates with either Event Hub or Cosmos DB, and there is no direct communication between the services.

## Identity access management

This reference architecture uses a simple authentication scheme based on API keys for some restricted operations, such as creating new catalog items or deleting comments. More advanced scenarios such as user authentication and user roles are not in scope. All keys and connection details are stored in Azure KeyVault.

## Asynchronous messaging

In order to achieve high responsiveness for all operations, Azure Mission-Critical implements the [Queue-Based Load leveling pattern](https://docs.microsoft.com/azure/architecture/patterns/queue-based-load-leveling) combined with [Competing Consumers pattern](https://docs.microsoft.com/azure/architecture/patterns/competing-consumers) where multiple producer instances (`CatalogService` in our case) generate messages which are then asynchronously processed by consumers (`BackgroundProcessor`). This allows the API to accept the request and return to the caller quickly whilst the more demanding database write operation is processed separately. This asynchronous approach provides reliability and resiliency through the decoupling of dependencies between the components as well as through the resiliency of Event Hub. ??more detail?? 

This architecture uses **Azure Event Hub** as the message queue but provides interfaces in code which enable the use of other messaging services if required, such as Azure Service Bus. **ASP.NET Core API** is used to implement the producer REST API, and **.NET Core Worker Service** is used to implement the consumer service.

Read operations are processed directly by the API and immediately return data back to the user.

![List games reaches to database directly](./images/application-design-operations-1.png)

High-scale write operations, such as *post rating and post comment* are processed asynchronously. The API first sends a message with all relevant information, such as type of action and comment data, to the message queue and immediately returns `HTTP 202 (Accepted)` with additional `Location` header for the create operation.

Messages from the queue are then processed by BackgroundProcessor instances which handle the actual database communication for write operations. The BackgroundProcessor scales in and out dynamically based on message volume on the queue.

![Post rating is asynchronous](./images/application-design-operations-2.png)

There is no back channel which communicates to the client if the operation completed successfully. The client application has to proactively poll the API to for updates.

?? is de-duping required and idempotency provided directly in event hub or is it part of the catalog service?

## Instrumentation

Each component writes logs, metrics, and telemetry to a backing log system, Azure Monitor. The components do not write log files in the runtime environment, or manage log formats or the logging environment. There are no log boundaries, such as date rollover, defined or managed by the applications. The logging is an ongoing event stream and the backing log system is where log analytics and querying are performed. The AKS cluster also has Container Insights enabled, which is a service that collects logs and metrics from the containers in the cluster and sends them to the Log Analytics workspace.

Advanced instrumentation, such as distributed tracing, are not in scope.

## Scalability

Individual workload services should be able to scale out independently (insert why? from reliability perspective). In this design the services are packaged and deployed by using Helm charts to each stamp. They are configured to have the expected requests and limits and a pre-configured auto-scaling (HPA) rule in place. (what is preconfigured? like built-in?) 

The scaling requirements depend on the functionality of the service. Some services have a direct impact on end user is  expected to be able to scale out automatically to provide a positive user experience and performance at any time.

In this reference architecture, the `CatalogService` has at least 3 instances per cluster to spread automatically across three Availability Zones per Azure Region. Each instance requests one CPU core and a given amount of memory based on upfront load testing. Each instance is expected to serve approximately 250 requests per second based on a standardized usage pattern. `CatalogService` has a 3:1 relationship to `Ingress`.

In other cases, the service might not have negative impact on user experience but may cause performance bottlenecks. For instance, the `BackgroundProcessor` service is a background worker that should be able  to<ask Martin what the requirement is>. It can scale between 3 and 32 instances, which matches the maximum number of event hub partitions. The ratio between `CatalogService` and `BackgroundProcessor` is around 10:1.

There are also overall scalability considerations that are applicable to all workload services to prevent availability issues and ensure that the service is always available. For example, supporting services like the `HealthService` and `Ingress` are configured with minimum of three replicas.  The instances are automatically spread across nodes and therefore also across Availability Zones.

In addition, each component of the workload has [Pod Disruption Budgets (PDBs)](/azure/aks/operator-best-practices-scheduler#plan-for-availability-using-pod-disruption-budgets) configured to ensure that a minimum number of instances is always available.

The actual minimum and maximum number of pods for each component should be determined through load testing, while still respecting the ratios defined in this section.

## Load testing
Follow the principals outlined in [Performance testing](/azure/architecture/framework/scalability/performance-test) to determine your specific load testing needs.

## Configuration
Variable files, both general as well as per-environment, store deployment and configuration data and are stored in the source code repository. Sensitive values are stored in Azure DevOps variable groups.

All application runtime configuration is stored in Azure Key Vault - this applies to both, secret and non-sensitive settings. The Key Vaults are only populated by the Terraform deployment. The required values are either sourced directly by Terraform (such as database connection strings) or passed through as Terraform variables from the deployment pipeline.

The applications run in containers on Azure Kubernetes Service. Containers use Container Storage Interface bindings to enable Mission-Critical applications to access Azure Key Vault configuration values, surfaced as environment variables, at runtime.

Configuration values and environment variables are standalone and not reproduced in different runtime "environments", but are differentiated by target environment at deployment.
