The success of your cloud solution depends on its reliability. Reliability is the probability that the system functions as expected, under specified conditions, within a specified time. Site reliability engineering (SRE) is a set of principles and practices for creating scalable and highly reliable software systems. SRE is a standard approach for designing digital services to support reliability goals in your workload.

This article demonstrates how to apply SRE principles to a scalable API platform. This architecture defines service-level indicators (SLIs) and service-level objectives (SLOs), models scale and performance expectations, and establishes monitoring practices. These techniques help ensure measurable and achievable reliability.

For more information, see [Develop an SRE strategy](/training/paths/az-400-develop-sre-strategy/).

## Architecture

:::image type="complex" source="media/scalable-apps-performance-modeling-site-reliability.svg" border="false" alt-text="Diagram that shows a scalable API platform." lightbox="media/scalable-apps-performance-modeling-site-reliability.svg":::
 Client apps send requests through Azure Front Door, Azure API Management, and Application Gateway for Containers to AKS microservices backed by Azure data services. Microsoft Entra ID provides authentication, Azure Managed Redis provides caching, and Azure Monitor with Application Insights collects telemetry across all layers.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/scalable-apps-performance-modeling-site-reliability.vsdx) of this architecture.*

### Data flow

The following data flow corresponds to the previous diagram:

1. Client applications such as web apps, mobile apps, and service applications send requests to the unified endpoint `https://api.contoso.com`.

1. Azure Front Door receives all incoming requests and provides Secure Sockets Layer (SSL) termination and Azure Web Application Firewall protection.

1. Azure Front Door routes requests to Azure API Management, which applies policies for access control, rate limiting, caching, and request transformation.

1. API Management forwards requests to Application Gateway for Containers, which load balances traffic across the AKS cluster.

1. The appropriate microservice in AKS processes the request. Microservices include product, profile, orders and payment, and content services. Each microservice emits telemetry that contributes to SLI calculations for availability, latency, and throughput.

1. Microservices access back-end data stores as needed:

   - Azure Cosmos DB for globally distributed, low-latency data
   - Azure SQL for relational data
   - Azure Storage and Azure Data Lake Storage for unstructured content and files

1. Microsoft Entra ID authenticates and authorizes users and service principals throughout the request flow.

1. Azure Monitor and Application Insights collect telemetry independently at each layer:

   - Azure Front Door request metrics
   - API Management policy execution
   - Application Gateway for Containers load distribution
   - AKS pod-level metrics
   - Data store response times
  
   SRE teams use per-layer collection to calculate composite SLIs, identify degradation sources, and track SLO compliance.

1. The response traverses back through the same path to the client application.

This architecture represents a scalable API platform. The solution includes multiple microservices that use various databases and storage services.

The example scenario covers high-level marketplace and e-commerce use cases:

- Product browsing
- Registration and sign-in
- Content viewing, such as news articles
- Order and subscription management

Client applications such as web apps, mobile apps, and service applications consume the API platform services through a unified access path, `https://api.contoso.com`.

### Components

- [Azure Front Door](/azure/well-architected/service-guides/azure-front-door) is a modern cloud content delivery network service that uses the Microsoft global edge network to create scalable web applications. In this architecture, it serves as the single entry point for all client requests. It provides SSL termination and applies Azure Web Application Firewall rules before it routes traffic to API Management. For more information, see [Routing architecture overview](/azure/frontdoor/front-door-routing-architecture).

- [API Management](/azure/well-architected/service-guides/azure-api-management) is a managed API gateway service that provides a hybrid, multicloud management platform for APIs across all environments. In this architecture, it functions as the API gateway. It enforces access control policies, applies rate limiting, caches responses by using [Azure Managed Redis](/azure/redis/overview) as an [external cache](/azure/api-management/api-management-howto-cache-external), and transforms requests before it forwards them to the back-end services. API Management supports autoscaling in Standard and Premium tiers.

- [AKS](/azure/well-architected/service-guides/azure-kubernetes-service) is a managed container orchestration service that provides a Kubernetes platform for running containerized applications. In this architecture, it hosts all microservices, including product, profile, orders and payment, and content services. Azure manages the control plane, and you manage the agent nodes.

- [Application Gateway for Containers](/azure/application-gateway/for-containers/overview) is an application load balancer that provides dynamic traffic management for workloads that run in a Kubernetes cluster. In this architecture, it provides layer-7 load balancing for traffic that enters the AKS cluster. It distributes requests from API Management across the microservice pods.

- [Azure Cosmos DB](/azure/well-architected/service-guides/cosmos-db) is a managed NoSQL and relational database service that has global distribution and automatic scalability. In this architecture, it stores product catalog and profile data that requires low-latency, globally distributed access. Autoscale throughput adjusts capacity based on demand.

- [Azure SQL](/azure/azure-sql/azure-sql-iaas-vs-paas-what-is-overview) is a family of managed relational database services that use the SQL Server database engine in Azure. In this architecture, it stores relational data for orders, subscriptions, and transactional records.

- [Azure Storage](/azure/storage/common/storage-introduction) is a cloud storage service that includes object, file, disk, queue, and table storage. [Azure Data Lake Storage](/azure/storage/blobs/data-lake-storage-introduction) is a massively scalable data lake service for high-performance analytics workloads. In this architecture, these services store unstructured content such as media assets, documents, and files.

- [Microsoft Entra ID](/entra/fundamentals/what-is-entra) is a cloud-based identity and access management service that authenticates and authorizes users to access resources. In this architecture, it provides centralized identity and access management for users and service principals across all services.

- [Azure Monitor](/azure/azure-monitor/fundamentals/overview) is an observability service for collecting, analyzing, and responding to monitoring data from your cloud and on-premises environments. [Application Insights](/azure/azure-monitor/app/app-insights-overview) is an extension of Azure Monitor that provides application performance monitoring (APM) features. In this architecture, these services collect telemetry across all layers. They calculate SLIs, track SLO compliance, and provide dashboards for proactive alerting. Azure Monitor supports OpenTelemetry and integrates with Azure Managed Grafana for distributed tracing and visualization.

- [Azure Chaos Studio](/azure/chaos-studio/chaos-studio-overview) is a managed chaos engineering service that helps measure, understand, and improve your cloud application and service resilience. In this architecture, it injects faults and validates the resilience of the system during resiliency and recovery testing.

### Alternatives

For the compute plane, consider:

- [Azure Container Apps](/azure/container-apps/overview) for microservices and event-driven workloads. It supports serverless containers and [KEDA](https://keda.sh/)-based autoscaling without requiring Kubernetes cluster management. This choice replaces both AKS and Application Gateway for Containers because Container Apps provides built-in ingress.

- [Web App for Containers](/azure/app-service/overview) for teams familiar with App Service that only need HTTP/HTTPS ingress. This choice replaces AKS and Application Gateway for Containers with a fully managed platform but provides less granular scaling control.

- [Azure Functions](/azure/azure-functions/functions-overview) for serverless API services where you can deploy individual API endpoints as independent functions. This choice replaces the microservice model with per-endpoint functions and suits event-driven or low-traffic APIs.

For the data layer, consider [Microsoft Fabric](/fabric/get-started/microsoft-fabric-overview) with [Azure Cosmos DB mirroring](/fabric/database/mirrored-database/azure-cosmos-db) when you need analytics on operational data. Fabric adds a reporting and analytics layer alongside the existing transactional stores without consuming request units.

## Scenario details

This example scenario demonstrates how to apply SRE practices to a scalable API platform that handles marketplace and e-commerce use cases. The article focuses on how to define SLIs and SLOs, model scale and performance expectations, and use those results to establish monitoring and alerting.

### Potential use cases

The concepts in this article apply to:

- API-based cloud services.
- Public-facing web applications.
- Internet of Things (IoT)-based or event-based workloads.
- E-commerce platforms with product browsing, registration, and order management.
- Content delivery applications for news articles and media.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps to ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

Your business context determines your reliability requirements. SRE practices help you achieve the appropriate level of reliability. You measure reliability through SLOs, which set targets expressed as percentages over time periods. SLIs are the metrics that you measure to determine SLOs, based on customer experience. For more information, see [Define SLI metrics to calculate SLOs](#define-sli-metrics-to-calculate-slos).

This architecture incorporates several reliability patterns:

- **Zone redundancy:** Azure Front Door, Application Gateway for Containers, and AKS support availability zone deployment for high availability within a region.

- **Autoscaling:** Azure Front Door scales automatically based on traffic volume. Application Gateway for Containers adjusts its capacity units automatically. AKS uses the cluster autoscaler for nodes and Horizontal Pod Autoscaler for pods. API Management supports autoscaling in Standard and Premium tiers. Azure Cosmos DB autoscale throughput adjusts based on request unit consumption. These capabilities help the system handle load variations without manual intervention.

- **Health monitoring:** Use Azure Monitor and Application Insights to track SLIs and SLOs and proactively identify reliability problems.

- **Resiliency and recovery testing:** Use [Chaos Studio](/azure/chaos-studio/chaos-studio-overview) to validate fault tolerance and recovery procedures.

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

This architecture addresses security through multiple layers:

- **Identity and access management:** Microsoft Entra ID provides centralized identity management for users and service principals.

- **Network security:** Azure Web Application Firewall, integrated with Azure Front Door, provides protection against common web exploits, including [Open Worldwide Application Security Project (OWASP) Top 10](https://owasp.org/www-project-top-ten/) vulnerabilities. API Management enforces network-level access controls such as IP address filtering and rate limiting.

- **API gateway security:** API Management enforces application-level authentication and authorization through OAuth 2.0 token validation and certificate authentication. These policies validate caller identity at the API-request level, separate from the network-level protections that Web Application Firewall and IP address filtering provide.

- **Data protection:** Use managed identities for service-to-service authentication. Activate encryption at rest for all data stores.

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

From an SRE perspective, cost optimization relates directly to how you provision monitoring infrastructure, define autoscaling thresholds, and allocate error budget. Overprovisioning degrades cost efficiency. Underprovisioning degrades reliability.

Key SRE-related cost drivers in this architecture include:

- **Monitoring and observability:** Azure Monitor, Application Insights, and Azure Managed Grafana incur costs based on data ingestion volume, retention policies, and alert rule count. Tune sampling rates and retention periods to balance observability depth against cost.

- **Autoscaling overhead:** Compute resources such as AKS node pools and API Management scale units represent the largest cost variable. Set autoscale minimum thresholds carefully. Setting them too high wastes resources, while setting them too low risks SLO violations during traffic spikes. Use monitoring data to calibrate thresholds.

- **Error budget investment:** When failures stay within your error budget, invest in features. When failures consume your budget, invest in reliability. This practice prevents unnecessary spending on reliability improvements when the system already meets its SLOs.

Other cost drivers include:

- **API Management:** Costs vary by tier. The Standard and Premium tiers support autoscaling but at higher base costs compared to the Developer and Basic tiers, which don't support autoscaling.

- **Data services:** Azure Cosmos DB costs depend on provisioned throughput and storage. Use autoscale throughput to optimize for fluctuating workloads.

- **Networking:** Azure Front Door and Application Gateway for Containers incur costs based on traffic volume and active features.

To optimize costs:

- Use [Azure Advisor](/azure/advisor/advisor-overview) recommendations for reserved instances and Azure savings plans.
- Rightsize AKS node pools based on actual utilization.
- Set up autoscaling thresholds to balance performance and cost.
- Use Azure Cosmos DB autoscale to avoid overprovisioning.

Use the [Azure pricing calculator](https://azure.com/e/fe330064f12845cf82272f0e803b77e1) to estimate costs for this architecture.

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

Create a holistic performance governance process to manage performance throughout the service life cycle.

- **Performance objectives:** Define aspirational SLOs based on business requirements.

- **Performance modeling:** Identify business-critical workflows and model expected performance.

- **Instrumentation:** Use Azure Monitor and Application Insights for APM, telemetry, and metrics analysis. Azure Monitor supports OpenTelemetry and integrates with Azure Managed Grafana for distributed tracing and visualization.

- **Performance testing:** Conduct load and stress testing by using tools such as K6, Karate, and JMeter. Integrate automated tests into continuous deployment pipelines.

- **Continuous monitoring:** Set up alerts based on SLI thresholds and track SLO compliance.

- **Ring-based deployment:** Use progressive rollout strategies to minimize the impact of changes.

Track performance objectives as granular user stories in your backlog to ensure that you prioritize governance activities alongside feature work.

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

Design applications so that resources scale automatically to meet load. This design includes compute, storage, and messaging infrastructure.

Apply scalability and performance modeling techniques to fine-tune architecture and design:

- Identify scalability requirements.
- Model expected load.
- Define SLIs and SLOs for user scenarios.

#### Capture scalability requirements

Assume these peak load metrics:

- Number of consumers: 1.5 million
- Hourly active consumers (30%): 450,000
- Load distribution:
  - Product browsing: 75%
  - Registration and sign-in: 10%
  - Orders and subscriptions: 10%
  - Content viewing: 5%

API scale requirements under normal peak load:

- Product microservice: approximately 500 requests per second (RPS)
- Profile microservice: approximately 100 RPS
- Orders and payment microservice: approximately 100 RPS
- Content microservice: approximately 50 RPS

During special events, scale requirements can reach 10 times normal peak load.

#### Define SLI metrics to calculate SLOs

SLI metrics indicate the degree to which a service provides a satisfactory experience, expressed as the ratio of good events to total events.

The following table shows example SLI metrics.

| Metric | Description |
| --- | --- |
| Availability | Whether the API serviced the request |
| Latency | Time for the API to process the request and reply |
| Throughput | Number of requests handled |
| Success rate | Number of requests handled successfully |
| Error rate | Number of errors for handled requests |
| Freshness | Number of times that the user received the latest data |

For each SLI, you calculate the ratio of good events to total events as observed by the customer. The following examples illustrate this calculation for different user scenarios:

- **Latency SLI for product browsing:** The *number of requests completed successfully in <1,000 ms* divided by the *number of requests*. This SLI tracks whether the product microservice responds within the acceptable latency threshold.

- **Freshness SLI for search:** The *number of search results returned within 3 seconds* divided by the *number of searches*. This SLI measures how often the search experience meets the freshness target after catalog updates.

After you define SLIs, determine what telemetry to capture at each layer of the architecture, including Azure Front Door, API Management, Application Gateway, AKS pods, and data stores. For HTTP services, use status codes to classify success and failure. Azure Monitor and Application Insights provide diagnostic and monitoring support for all layers.

Use percentile distributions to calculate some SLIs and exclude outliers. For example, if the 95th percentile latency falls within the threshold, the system meets the SLO.

Define SLO measurement periods to capture activity, not idleness. The window can range from five minutes to 24 hours.

#### Establish aspirational SLOs for the target solution

Consider the following sample aspirational SLOs:

- 95% of READ requests respond within one second.
- 95% of CREATE and UPDATE requests respond within three seconds.
- 99% of all requests respond within five seconds with no failures.
- 99.9% of all requests succeed without error.
- Less than 1% of requests during peak hour error out.

Tailor SLOs to your application requirements.

#### Measure initial SLOs based on log data

Assume a week of data:

- Requests: 123,456
- Successful requests: 123,204
- 90th percentile latency: 497 ms
- 95th percentile latency: 870 ms
- 99th percentile latency: 1,024 ms

Initial SLIs:

- Availability = (123,204 / 123,456) = 99.8%
- 90% of requests served within 500 ms
- 98% of requests served within 1,000 ms

Compare log data to SLO targets to assess compliance.

#### Guidance for technical risk mitigation

Follow these recommended practices:

- Design for scale and performance.
  - Capture scale requirements for all scenarios, including peaks.
  - Model performance to identify constraints.

- Manage technical debt.
  - Trace performance metrics.
  - Use tools such as K6, Karate, and JMeter for load testing.
  - Integrate automated tests into continuous deployment.

- Adopt a production mindset.
  - Adjust autoscaling thresholds based on health statistics.
  - Prefer horizontal scaling.
  - Use ring-based deployment.
  - Use error budgets to determine when to invest in reliability improvements versus new features. An error budget is the difference between 100% and your SLO target. For example, a 99.9% SLO allows a 0.1% error budget. If actual failures consume this budget, prioritize reliability work to reduce failure rates. If failures stay within the budget, invest in experimentation and feature delivery.
  - Use [Chaos Studio](/azure/chaos-studio/chaos-studio-overview) for resilience testing.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Subhajit Chatterjee](https://www.linkedin.com/in/subhajit-chatterjee-b9b53b44) | Principal Software Engineer

Other contributor:

- [Dawid Obrocki](https://www.linkedin.com/in/obrocki) | Senior Software Engineer

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Azure Well-Architected Framework](/azure/well-architected/)
- [What is Azure Front Door?](/azure/frontdoor/front-door-overview)
- [About API Management](/azure/api-management/api-management-key-concepts)
- [What is Application Gateway for Containers?](/azure/application-gateway/for-containers/overview)
- [AKS](/azure/aks/what-is-aks)
- [Autoscaling and zone-redundant Application Gateway v2](/azure/application-gateway/application-gateway-autoscaling-zone-redundant)
- [Automatically scale a cluster to meet application demands on AKS](/azure/aks/cluster-autoscaler)
- [Create Azure Cosmos DB containers and databases with autoscale throughput](/azure/cosmos-db/provision-throughput-autoscale)
- [Chaos Studio](/azure/chaos-studio/chaos-studio-overview)
- [Azure Advisor](/azure/advisor/advisor-overview)
- [SRE documentation](/azure/site-reliability-engineering/)
- [Training: Develop an SRE strategy](/training/paths/az-400-develop-sre-strategy/)

## Related resources

- [Microservices architecture on AKS](../../reference-architectures/containers/aks-microservices/aks-microservices.yml)
- [Microservices architecture style](../../guide/architecture-styles/microservices.md)
- [Design to scale out](../../guide/design-principles/scale-out.md)
- [Choose an Azure compute service for your application](../../guide/technology-choices/compute-decision-tree.md)
- [Baseline web application with zone redundancy](../../web-apps/app-service/architectures/baseline-zone-redundant.yml)

