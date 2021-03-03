


## Overview

This gaming solution architecture elastically scales your database to accommodate unpredictable bursts of traffic and deliver low-latency multi-player experiences on a global scale. This specific scenario is based on a gaming scenario, but the design patterns are relevant for many industries requiring the process high-traffic web calls and API requests such as e-commerce and retail applications.

## Architecture

![Architecture Diagram](../media/gaming-using-cosmos-db.png)
*Download an [SVG](../media/gaming-using-cosmos-db.svg) of this architecture.*

## Data Flow
1. Azure Traffic Manager routes a user's game traffic to the apps hosted in Azure App Service, Functions or Containers and APIs published via Azure API Gateway. 
2. Azure CDN serves static images and game content to the user that are stored in Azure Blob Storage.
3. Azure Cosmos DB stores user's game state data.
4. Azure Databricks correlates, cleanses and transforms game state data.
5. Azure Functions processes the insights derived from Azure Databricks and pushes notifications using Azure Notification Hubs to mobile devices.

## Components

This architecture includes the following components:

- [Azure Traffic Manager](/azure/traffic-manager/) is a DNS-based load balancer that controls the distribution of user traffic for service endpoints in different Azure regions. During normal operations, it routes requests to the primary region. If that region becomes unavailable, Traffic Manager can fail over to secondary region as needed.

- [Azure API Management](https://azure.microsoft.com/services/api-management/) provides an API gateway that sits in front of the Gaming APIs. API Management also be used to implement concerns such as:
    - Enforcing usage quotas and rate limits
    - Validating OAuth tokens for authentication
    - Enabling cross-origin requests (CORS)
    - Caching responses
    - Monitoring and logging requests

- [Azure App Service](/azure/app-service-web/app-service-web-overview) hosts API applications allowing autoscale and high availability without having to manage infrastructure.

- [Azure CDN](https://azure.microsoft.com/services/cdn/) delivers static, cached content from locations close to users to reduce latency.

- [Azure Blob Storage](https://azure.microsoft.com/services/storage/) are optimized to store large amounts of unstructured data, such as static gaming media.

- [Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db/) is a fully managed NoSQL database service for building and modernizing scalable, high performance applications.

- [Azure Databricks](https://azure.microsoft.com/services/databricks/) is an Apache Spark-based analytics platform optimized for the Microsoft Azure cloud services platform. 

- [Azure Functions](https://azure.microsoft.com/services/functions/) are serverless compute options that allow applications to run on-demand without having to manage infrastructure.

- [Azure Notification Hubs](https://azure.microsoft.com/services/notification-hubs/#overview) is a massively scalable push notification engine for quickly sending notifications to variety of mobile devices and platforms.
