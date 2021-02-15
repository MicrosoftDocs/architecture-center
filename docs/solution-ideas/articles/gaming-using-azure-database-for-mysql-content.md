## Overview

This gaming solution architecture elastically scales your database to accommodate unpredictable bursts of traffic and deliver low-latency multi-player experiences on a global scale. This specific scenario is based on a gaming scenario, but the design patterns are relevant for many industries requiring the process high-traffic web calls and API requests such as e-commerce and retail applications.

## Architecture

![Architecture Diagram](../media/gaming-using-azure-database-for-mysql.png)
*Download an [SVG](../media/gaming-using-azure-database-for-mysql.svg) of this architecture.*

## Data Flow
1. Azure Traffic Manager routes a user's game traffic to the apps hosted in Azure App Service, Functions or Containers and APIs published via Azure API Gateway. 
2. Azure CDN serves static images and game content to the user that are stored in Azure Blob Storage.
3. Azure Database for MySQL stores user's game  data in a transactional database hosted.
4. The data from Azure Database for MySQL are processed using Azure Databricks and stored in the analytics platform.
5. (Optional) Use Power BI to interpret this data and create new visualizations

## Components

This architecture includes the following components:

- [Azure Traffic Manager](/azure/traffic-manager/) is a DNS-based load balancer that controls the distribution of user traffic for service endpoints in different Azure regions. During normal operations, it routes requests to the primary region. If that region becomes unavailable, Traffic Manager can fail over to secondary region as needed.

- [Azure API Management](https://azure.microsoft.com/services/api-management/) provides an API gateway that sits in front of the Gaming APIs. API Management also can be used to implement concerns such as:
    - Enforcing usage quotas and rate limits
    - Validating OAuth tokens for authentication
    - Enabling cross-origin requests (CORS)
    - Caching responses
    - Monitoring and logging requests

- [Azure App Service](/azure/app-service-web/app-service-web-overview) hosts API applications allowing autoscale and high availability without having to manage infrastructure.

- [Azure CDN](https://azure.microsoft.com/en-us/services/cdn/) delivers static, cached content from locations close to users to reduce latency.

- [Azure Blob Storage](https://azure.microsoft.com/services/storage/) are optimized to store large amounts of unstructured data, such as static gaming media.

- [Azure Database for MySQL](/azure/mysql/overview) is a fully managed relational database service based on the community edition of the open-source MySQL database engine.

- [Azure HDInsight](/azure/hdinsight/hdinsight-overview) is a managed, full-spectrum, open-source analytics service in the cloud for enterprises. You can use open-source frameworks such as Hadoop, Apache Spark, Apache Hive, LLAP, Apache Kafka, Apache Storm, R, and more.

- (Optional) [Power BI](https://powerbi.microsoft.com/) provides an interactive dashboard with visualization that uses data stored in SQL Server to drive decisions on the predictions.
