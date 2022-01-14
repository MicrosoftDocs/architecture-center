---
title: 'Microservice container depplyment with Azure Container Apps'
titleSuffix: Azure Example Scenarios
description: Deploy your Microservices orchestration with Azure Container Apps
services: container-apps
author: cebundy
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: example-scenario
ms.date: 01/15/2022
ms.author: v-bcatherine
ms.custom: mode-portal
---

This scenario shows how your business can simplify the deployment and management of microservice containers by deploying them using Azure Container Apps. Azure Container Apps is a fully managed serverless service for building and deploying modern applications at scale.

To illustrate the use of Azure Container Apps for a microservices architecture, we have taken the reference implementation [Fabrikam Drone Delivery](https://github.com/mspnp/aks-fabrikam-dronedelivery) application that previously ran in Azure Kubernetes Service (AKS) and moved it to Container Apps. You can find this scenario on [GitHub](https://github.com/mspnp/container-apps-fabrikam-dronedelivery).

## Potential use cases

Container Apps is a solution for microservice applications that benefit from:

* Span many microservices deployed in containers.
* The flexibility of serverless environments.
* Autoascaling based on HTTP traffic or Kubernetes Event-Driven Autoscaling (KEDA).
* Kubernetes features without the need to access the Kubernetes API.

## Architecture

_Architecture diagram goes here_

_download Visio/PPT_

### Workflow

1. Ingestion Container App: Receives client requests, buffers them and send them via Azure Service Bus to the WorkFlow Container App.
1. Workflow Container App:  Dispatches client requests and manages the delivery workflow.
1. Package Container App: Manages packages.
1. Drone scheduler Container App: Schedules drones and monitors drones in flight.
1. Delivery Container App: Manages deliveries that are scheduled or in-transit.

Each containerized microservice is stored in a container app.  These container apps deployed to single Azure Container Apps environment.  The Container Apps environment is configured with a [Log Analytics workspace](https://docs.microsoft.com/azure/azure-monitor/logs/design-logs-deployment) which is used by the Azure Monitor service. Container Apps in the same environment share the same virtual network and write logs to the same Log Analytics workspace.

### Components

This solution uses the following Azure components:

**[Azure Container Apps](https://azure.microsoft.com/services/container-apps)** is an Azure offering that provides serverless, managed platform.

**External storage and other components:**

**[Azure Key Vault](https://azure.microsoft.com/services/key-vault)** stores and manages security keys for AKS services.

**[Azure Container Registry](https://azure.microsoft.com/services/container-registry)** stores private container images that can be run in the AKS cluster. AKS authenticates with Container Registry using its Azure AD managed identity. You can also use other container registries like Docker Hub.

**[Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db)** stores data using the open-source [Azure Cosmos DB API for MongoDB](/azure/cosmos-db/mongodb-introduction). Microservices are typically stateless and write their state to external data stores. Azure Cosmos DB is a NoSQL database with open-source APIs for MongoDB and Cassandra.

**[Azure Service Bus](https://azure.microsoft.com/services/service-bus)** offers reliable cloud messaging as a service and simple hybrid integration. Service Bus supports asynchronous messaging patterns that are common with microservices applications.

**[Azure Cache for Redis](https://azure.microsoft.com/services/cache)** adds a caching layer to the application architecture to improve speed and performance for heavy traffic loads.

**[Azure Monitor](/azure/azure-monitor)** collects and stores metrics and logs, including platform metrics for the Azure services in the solution and application telemetry. Use this data to monitor the application, set up alerts and dashboards, and perform root cause analysis of failures. Azure Monitor integrates with Service Fabric to collect metrics from controllers, nodes, and containers, as well as container and node logs.

### Alternatives

An alternative scenario of this example is the Fabrikam Drone Delivery application using Kubernetes can be found [here](https://github.com/mspnp/aks-fabrikam-dronedelivery). 

Instead of using Azure Service Bus, messaging between the microservices can be implemented with [Dapr](https://dapr.io/) (Distributed Application Runtime).  

## Considerations

### Availability

this scenario maintains high availability through Container Apps  autoscaling feature that dynamically provisions new replicas of the container app based 

> Need a specific scaling criteria here that we will use in the scenario

### Operations

Revisions are dynamically deployed when a change to the container app configuration or image.  

Although not configured in this scenario, traffic-splitting across revisions can be enabled for blue/green deployments and A/B testing.

This scenario includes the Azure Monitor service to enable monitoring and analysis of the application.  

### Performance

Factors affecting container app performance:

* The cpu and memory resources configuration.
* The autoscaling criteria.

### Scalability

While this scenario has set the scaling configuration to 
> Need the scaling criteria

Container Apps service supports autoscaling based on HTTP traffic or any KEDA-based scale triggers.

### Security

This scenario users Azure User Managed Identities providing Read and List secrets permissions via Azure KeyVault to the microservices.

### Resiliency

Any container that crashes is automatically restarted.

### DevOps

This example uses Bicep templates for deployment. Both deployments and redeployments are run manually. 

Alternatively CD/CI pipelines can be enabled by adding GitHub Actions to the Container Apps configurations.  This will enable automatic deployments when changes in the repository affect the container images or the container apps configuration.

## Deploy this scenario

Follow the steps in the README.md in the [sample repository](https://github.com/mspnp/container-apps-fabrikam-dronedelivery) to deploy this scenario.

## Pricing

* The [Cost section in the Microsoft Azure Well-Architected Framework](/azure/architecture/framework/cost/overview) describes cost considerations. Use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator) to estimate costs for your specific scenario.

* Azure Container Apps has no costs associated with deployment management, and operations of the Container Apps environments. You only pay for the compute and storage resources the applications consume. Autoscaling can significantly reduce costs by removing empty or unused nodes.

* The Azure Cosmos DB and Azure Cache for Redis services will consume the majority of the costs.  In order to avoid costs, do not leave this example running.

## Next steps

  * [Azure Container Apps Documentation](https://docs.microsoft.com/azure/container-apps/?branch=release-ignite-container-apps)
  * [Build microservices on Azure](https://docs.microsoft.com/azure/architecture/microservices/)

## Related resources

> Any suggestions?
