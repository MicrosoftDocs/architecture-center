The success of your cloud solution depends on its reliability. Reliability is the probability that the system functions as expected, under specified conditions, within a specified time. Site reliability engineering (SRE) is a set of principles and practices for creating scalable and highly reliable software systems. SRE is a standard approach for designing digital services to support reliability goals in your workload.

This article demonstrates how to apply SRE principles to a scalable API platform. The architecture serves as a concrete example for defining service level indicators (SLIs) and service level objectives (SLOs), modeling scale and performance expectations, and establishing monitoring practices. The focus is on ensuring that the architecture supports measurable and appropriate reliability.

For more information on SRE strategies, see [Develop a Site Reliability Engineering (SRE) strategy](/training/paths/az-400-develop-sre-strategy).

## Architecture

:::image type="content" source="media/scalable-apps-performance-modeling-site-reliability.png" alt-text="The architecture shows microservices in a Kubernetes cluster. They receive requests passed on by Azure Front Door, and access data using various storage services." lightbox="media/scalable-apps-performance-modeling-site-reliability.png" :::

*Download a [PowerPoint file](https://arch-center.azureedge.net/US-1881435-scalable-apps-performance-modeling-site-reliability.pptx) of this architecture.*

### Dataflow

1. Client applications such as web apps, mobile apps, and service applications send requests to the unified endpoint `https://api.contoso.com`.
1. Azure Front Door receives all incoming requests and provides SSL termination and Azure Web Application Firewall (WAF) protection.
1. Front Door routes requests to Azure API Management, which applies policies for access control, rate limiting, caching, and request transformation.
1. API Management forwards requests to Application Gateway for Containers, which load balances traffic across the AKS cluster.
1. The appropriate microservice in AKS processes the request. Microservices include Product, Profile, Orders and Payment, and Content services. Each microservice emits telemetry that feeds into SLI calculations for availability, latency, and throughput.
1. Microservices access backend data stores as needed:
   - Azure Cosmos DB for globally distributed, low-latency data.
   - Azure SQL for relational data.
   - Azure Storage and Azure Data Lake Storage for unstructured content and files.
1. Microsoft Entra ID authenticates and authorizes users and service principals throughout the request flow.
1. Azure Monitor and Application Insights collect telemetry independently at each layer: Front Door request metrics, API Management policy execution, Application Gateway for Containers load distribution, AKS pod-level metrics, and data store response times. Per-layer collection enables SRE teams to calculate composite SLIs, pinpoint degradation sources, and track SLO compliance.
1. The response traverses back through the same path to the client application.

This architecture represents a scalable API platform. The solution comprises multiple microservices that use various databases and storage services.

The example scenario covers high-level marketplace and e-commerce use cases, including:

- Product browsing.
- Registration and sign in.
- Viewing content such as news articles.
- Order and subscription management.

Client applications such as web apps, mobile apps, and service applications consume the API platform services through a unified access path, `https://api.contoso.com`.

### Components

- [Azure Front Door](/azure/well-architected/service-guides/azure-front-door) serves as the single entry point for all client requests in this architecture. It terminates SSL and applies Azure Web Application Firewall (WAF) rules before routing traffic to API Management. See [Routing architecture overview](/azure/frontdoor/front-door-routing-architecture).
- [Azure API Management](/azure/well-architected/service-guides/api-management/operational-excellence) acts as the API gateway for this platform. It enforces access control policies, applies rate limiting, caches responses (using [Azure Managed Redis](/azure/azure-cache-for-redis/cache-overview) as an [external cache](/azure/api-management/api-management-howto-cache-external)), and transforms requests before forwarding them to the backend services. API Management supports autoscaling in Standard and Premium tiers.
- [Azure Kubernetes Service (AKS)](/azure/well-architected/service-guides/azure-kubernetes-service) hosts all microservices (Product, Profile, Orders and Payment, and Content) in this architecture. Azure manages the control plane; you manage the agent nodes.
- [Application Gateway for Containers](/azure/application-gateway/for-containers/overview) provides layer 7 load balancing for traffic entering the AKS cluster. It distributes requests from API Management across the microservice pods.
- [Azure Cosmos DB](/azure/well-architected/service-guides/cosmos-db) stores product catalog and profile data that requires low-latency, globally distributed access. Autoscale throughput adjusts capacity based on demand.
- [Azure SQL](/azure/azure-sql/azure-sql-iaas-vs-paas-what-is-overview) stores relational data for orders, subscriptions, and transactional records in this architecture.
- [Azure Storage](/azure/storage/common/storage-introduction) and [Azure Data Lake Storage](/azure/storage/blobs/data-lake-storage-introduction) store unstructured content such as media assets, documents, and files.
- [Microsoft Entra ID](/azure/active-directory/fundamentals/) provides centralized identity and access management for users and service principals across all services in this architecture.
- [Azure Monitor](/azure/azure-monitor/overview) and [Application Insights](/azure/azure-monitor/app/app-insights-overview) collect telemetry across all layers of this architecture. These services calculate SLIs, track SLO compliance, and provide dashboards for proactive alerting. Azure Monitor supports OpenTelemetry and integrates with Azure Managed Grafana for distributed tracing and visualization.
- [Azure Chaos Studio](/azure/chaos-studio/chaos-studio-overview) is used to inject faults and validate the resilience of this architecture during resiliency and recovery testing.

### Alternatives

For the compute plane, consider:

- [Azure Container Apps](/azure/container-apps/overview) for microservices and event-driven workloads. It supports serverless containers and KEDA-based autoscaling without requiring Kubernetes cluster management.
- [Azure Functions](https://azure.microsoft.com/services/functions) for serverless API services where individual API endpoints can be deployed as independent functions.

## Scenario details

This example scenario demonstrates how to apply SRE practices to a scalable API platform that handles marketplace and e-commerce use cases. The article focuses on defining SLIs and SLOs, modeling scale and performance expectations, and using those results to establish monitoring and alerting.

### Potential use cases

The concepts in this article apply to:

- API-based cloud services.
- Public-facing web applications.
- IoT-based or event-based workloads.
- E-commerce platforms with product browsing, registration, and order management.
- Content delivery applications serving news articles and media.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Reliability

Reliability helps to ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

The required reliability depends on the business context. SRE practices help you achieve the appropriate level of reliability. Reliability is measured using service level objectives (SLOs) that define the target level of reliability for a service. SLOs are usually defined as a percentage achievement over a period. Service level indicators (SLIs) are the metrics used to calculate SLOs, based on customer experience. For more information, see [Define SLI metrics to calculate SLOs](#define-sli-metrics-to-calculate-slos).

This architecture incorporates several reliability patterns:

- **Zone redundancy**: Azure Front Door, Application Gateway for Containers, and AKS support availability zone deployment for high availability within a region.
- **Autoscaling**: Azure Front Door scales automatically based on traffic volume. Application Gateway for Containers adjusts its capacity units automatically. AKS uses the cluster autoscaler for nodes and Horizontal Pod Autoscaler for pods. API Management supports autoscaling in Standard and Premium tiers. Azure Cosmos DB autoscale throughput adjusts based on request unit consumption. These capabilities help the system handle load variations without manual intervention.
- **Health monitoring**: Use Azure Monitor and Application Insights to track SLIs and SLOs, enabling proactive identification of reliability issues.
- **Resiliency and recovery testing**: Use [Azure Chaos Studio](/azure/chaos-studio/chaos-studio-overview) to validate fault tolerance and recovery procedures.

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

This architecture addresses security through multiple layers:

- **Identity and access management**: Microsoft Entra ID provides centralized identity management for users and service principals.
- **Network security**: Azure Web Application Firewall (WAF), integrated with Azure Front Door, provides protection against common web exploits, including [OWASP Top 10](https://owasp.org/www-project-top-ten/) vulnerabilities. API Management enforces network-level access controls such as IP filtering and rate limiting.
- **API gateway security**: API Management enforces application-level authentication and authorization through OAuth 2.0 token validation and certificate authentication. These policies validate caller identity at the API request level, distinct from the network-level protections that WAF and IP filtering provide.
- **Data protection**: Use managed identities for service-to-service authentication. Enable encryption at rest for all data stores.

### Cost optimization

Cost optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

From an SRE perspective, cost optimization relates directly to how you provision monitoring infrastructure, define autoscaling thresholds, and allocate error budget. Over-provisioning degrades cost efficiency; under-provisioning degrades reliability.

Key SRE-related cost drivers in this architecture include:

- **Monitoring and observability**: Azure Monitor, Application Insights, and Azure Managed Grafana incur costs based on data ingestion volume, retention policies, and alert rule count. Tune sampling rates and retention periods to balance observability depth against cost.
- **Autoscaling overhead**: Compute resources (AKS node pools, API Management scale units) represent the largest cost variable. Over-provisioning autoscale minimums wastes resources; setting them too low risks SLO violations during traffic spikes. Use monitoring data to calibrate thresholds.
- **Error budget investment**: When your error budget is intact, invest in features. When it's consumed, invest in reliability. This practice prevents unnecessary spending on reliability improvements when the system already meets its SLOs.

Additional cost drivers:

- **API Management**: Costs vary by tier. The Standard and Premium tiers support autoscaling but at higher base costs compared to the Developer and Basic tiers, which don't support autoscaling.
- **Data services**: Azure Cosmos DB costs depend on provisioned throughput and storage. Use autoscale throughput to optimize for fluctuating workloads.
- **Networking**: Azure Front Door and Application Gateway for Containers incur costs based on traffic volume and features enabled.

To optimize costs:

- Use [Azure Advisor](/azure/advisor/advisor-overview) recommendations for Reserved Instances and Azure Savings Plans.
- Right-size AKS node pools based on actual utilization.
- Configure autoscaling thresholds to balance performance and cost.
- Use Azure Cosmos DB autoscale to avoid over-provisioning.

Use the [Azure Pricing Calculator](https://azure.com/e/fe330064f12845cf82272f0e803b77e1) to estimate costs for this architecture.

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

Create an end‑to‑end performance governance process to manage performance throughout the service lifecycle.

- **Performance objectives**: Define aspirational SLOs based on business requirements.
- **Performance modeling**: Identify business-critical workflows and model expected performance.
- **Instrumentation**: Use Azure Monitor and Application Insights for APM, telemetry, and metrics analysis. Azure Monitor supports OpenTelemetry and integrates with Azure Managed Grafana for distributed tracing and visualization.
- **Performance testing**: Conduct load and stress testing by using tools such as K6, Karate, and JMeter. Integrate automated tests into continuous deployment pipelines.
- **Continuous monitoring**: Set up alerts based on SLI thresholds and track SLO compliance.
- **Ring-based deployment**: Use progressive rollout strategies to minimize the impact of changes.

Track performance objectives as granular user stories in your backlog to ensure governance activities are prioritized alongside feature work.

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

Performance refers to the responsiveness of a system. Scalability is the ability to handle increased load without hurting performance. Design applications so that resources scale automatically to meet load. This design includes compute, storage, and messaging infrastructure.

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
  - Registration and login: 10%
  - Orders and subscriptions: 10%
  - Content viewing: 5%

API scale requirements under normal peak load:

- Product microservice: ~500 requests per second (RPS)
- Profile microservice: ~100 RPS
- Orders and payment microservice: ~100 RPS
- Content microservice: ~50 RPS

During special events, scale requirements can reach 10 times normal peak load.

#### Define SLI metrics to calculate SLOs

SLI metrics indicate the degree to which a service provides a satisfactory experience, expressed as the ratio of good events to total events.

Example SLI metrics:

| Metric | Description |
| --- | --- |
| Availability | Whether the request was serviced by the API |
| Latency | Time for the API to process the request and reply |
| Throughput | Number of requests handled |
| Success Rate | Number of requests handled successfully |
| Error Rate | Number of errors for handled requests |
| Freshness | Number of times the user received the latest data |

For each SLI, you calculate the ratio of good events to total events as observed by the customer. Two examples that illustrate this calculation for different user scenarios:

- **Latency SLI for product browsing**: (Number of requests completed successfully in <1,000 ms) / (Number of requests). This SLI tracks whether the Product microservice responds within the acceptable latency threshold.
- **Freshness SLI for search**: (Number of search results returned within 3 seconds) / (Number of searches). This SLI measures how often the search experience meets the freshness target after catalog updates.

After defining SLIs, determine what telemetry to capture at each layer of the architecture (Azure Front Door, API Management, Application Gateway, AKS pods, and data stores). For HTTP services, use status codes to classify success and failure. Azure Monitor and Application Insights provide diagnostic and monitoring support for all layers.

#### Use percentile distributions

Calculate some SLIs using percentile distributions to exclude outliers. For example, if the 95th percentile latency is within the threshold, the SLO is considered met.

#### Choose proper measurement periods

Define SLO measurement periods to capture activity, not idleness. The window can range from five minutes to 24 hours.

#### Establish aspirational SLOs for the target solution

Sample aspirational SLOs:

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

Recommended practices:

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
  - Use error budgets to determine when to invest in reliability improvements versus new features. An error budget is the difference between 100% and your SLO target (for example, a 99.9% SLO gives a 0.1% error budget). When the budget is consumed, prioritize reliability work; when it's intact, invest in experimentation and feature delivery.
  - Use [Azure Chaos Studio](/azure/chaos-studio/chaos-studio-overview) for resilience testing.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal author:

- [Subhajit Chatterjee](https://www.linkedin.com/in/subhajit-chatterjee-b9b53b44) | Principal Software Engineer

Other contributors:

- [Dawid Obrocki](https://www.linkedin.com/in/obrocki) | Senior Software Engineer

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Microsoft Azure Well-Architected Framework](/azure/well-architected/)
- [Microservices architecture on Azure Kubernetes Service](/azure/architecture/reference-architectures/containers/aks-microservices/aks-microservices)

## Related resources

- [Azure documentation](/azure)
- [Microservices architecture style](/azure/architecture/guide/architecture-styles/microservices)
- [Design to scale out](/azure/architecture/guide/design-principles/scale-out)
- [Choose an Azure compute service for your application](/azure/architecture/guide/technology-choices/compute-decision-tree)
- [What is Azure Front Door?](/azure/frontdoor/front-door-overview)
- [About API Management](/azure/api-management/api-management-key-concepts)
- [What is Application Gateway for Containers?](/azure/application-gateway/for-containers/overview)
- [Azure Kubernetes Service](/azure/aks/intro-kubernetes)
- [Autoscaling and Zone-redundant Application Gateway v2](/azure/application-gateway/application-gateway-autoscaling-zone-redundant)
- [Automatically scale a cluster to meet application demands on Azure Kubernetes Service (AKS)](/azure/aks/cluster-autoscaler)
- [Create Azure Cosmos DB containers and databases with autoscale throughput](/azure/cosmos-db/provision-throughput-autoscale)
- [Azure Chaos Studio](/azure/chaos-studio/chaos-studio-overview)
- [Azure Advisor](/azure/advisor/advisor-overview)
- [Site reliability engineering documentation](/azure/site-reliability-engineering)
- [AZ-400: Develop a Site Reliability Engineering (SRE) strategy](/training/paths/az-400-develop-sre-strategy)
- [Baseline web application with zone redundancy](../../web-apps/app-service/architectures/baseline-zone-redundant.yml)

