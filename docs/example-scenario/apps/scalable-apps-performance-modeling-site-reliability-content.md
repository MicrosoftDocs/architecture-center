The success of your cloud solution depends on its reliability. Reliability is the probability that the system functions as expected, under specified conditions, within a specified time. Site reliability engineering (SRE) is a set of principles and practices for creating scalable and highly reliable software systems. SRE is a standard approach for designing digital services to ensure reliability.

For more information on SRE strategies, see [AZ-400: Develop a Site Reliability Engineering (SRE) strategy](/training/paths/az-400-develop-sre-strategy).

## Potential use cases

The concepts in this article apply to:

- API-based cloud services.
- Public-facing web applications.
- IoT-based or event-based workloads.

## Architecture

:::image type="content" source="media/scalable-apps-performance-modeling-site-reliability.png" alt-text="The architecture shows microservices in a Kubernetes cluster. They receive requests passed on by Azure Front Door, and access data using various storage services." lightbox="media/scalable-apps-performance-modeling-site-reliability.png" :::

*Download a [PowerPoint file](https://arch-center.azureedge.net/US-1881435-scalable-apps-performance-modeling-site-reliability.pptx) of this architecture.*

This architecture represents a scalable API platform. The solution comprises multiple microservices that use various databases and storage services.

The example scenario covers high-level marketplace and e-commerce use cases, including:

- Product browsing.
- Registration and login.
- Viewing content such as news articles.
- Order and subscription management.

Client applications such as web apps, mobile apps, and service applications consume the API platform services through a unified access path, `https://api.contoso.com`.

### Components

- [Azure Front Door](/azure/well-architected/service-guides/azure-front-door) provides a secured, unified point of entry for all requests. See [Routing architecture overview](/azure/frontdoor/front-door-routing-architecture).
- [Azure API Management](/azure/well-architected/service-guides/api-management/operational-excellence) provides a governance layer for published APIs. Use policies for access restrictions, caching, and data transformation. API Management supports autoscaling in Standard and Premium tiers.
- [Azure Kubernetes Service (AKS)](/azure/well-architected/service-guides/azure-kubernetes-service) is a managed Kubernetes service. Azure manages the control plane; you manage the agent nodes. All microservices are deployed in AKS. AKS supports confidential computing node pools and ARM64 workloads.
- [Azure Container Apps](/azure/container-apps/overview) is an alternative for microservices and event-driven workloads, supporting serverless containers and KEDA-based autoscaling.
- [Azure Application Gateway](/azure/well-architected/service-guides/azure-application-gateway) is an application delivery controller with layer 7 load balancing. The Application Gateway Ingress Controller (AGIC) integrates with AKS. Autoscaling and zone redundancy are supported in the v2 SKU.
- [Azure Storage](/azure/storage/common/storage-introduction), [Azure Data Lake Storage](/azure/storage/blobs/data-lake-storage-introduction), [Azure Cosmos DB](/azure/well-architected/service-guides/cosmos-db), and [Azure SQL](/azure/azure-sql/azure-sql-iaas-vs-paas-what-is-overview) store structured and unstructured content. Cosmos DB supports autoscale throughput.
- [Microsoft Entra ID](/azure/active-directory/fundamentals/) (formerly Azure Active Directory) provides identity and access management.

### Alternatives

For the compute plane, consider:

- [Azure Functions](https://azure.microsoft.com/services/functions) for serverless API services.
- [Azure Spring Apps](https://azure.microsoft.com/services/spring-apps) for Java-based microservices.  
  > [!NOTE]
  > Azure Spring Apps is scheduled for retirement in 2028. For new Java workloads, consider [AKS](https://learn.microsoft.com/azure/aks/) or [Azure Container Apps](https://learn.microsoft.com/azure/container-apps/overview) as alternatives.

## Appropriate reliability

The required reliability depends on the business context. SRE practices help you achieve the appropriate level of reliability.

Reliability is measured using service level objectives (SLOs) that define the target level of reliability for a service. SLOs are usually defined as a percentage achievement over a period. Service level indicators (SLIs) are the metrics used to calculate SLOs, based on customer experience.

The following image shows the relationship between the monitored metric, the SLI, and the SLO:

:::image type="content" source="media/scalable-apps-performance-modeling-site-reliability-slo.png" alt-text="Diagram that shows how to identify the right metric for reliability, define how to calculate its SLI, and set a target SLO." :::

For more information, see [Define SLI metrics to calculate SLOs](#define-sli-metrics-to-calculate-slos).

## Modeling scale and performance expectations

Performance refers to the responsiveness of a system. Scalability is the ability to handle increased load without hurting performance.

Design applications so that resources scale automatically to meet load. This includes compute, storage, and messaging infrastructure.

This article shows how to ensure reliability by conducting scale and performance modeling, and using the results to define monitors, SLIs, and SLOs.

## Considerations

Refer to the [Reliability](/azure/architecture/framework/resiliency) and [Performance Efficiency](/azure/architecture/framework/scalability) pillars of the [Azure Well-Architected Framework](/azure/well-architected/) for guidance.

Apply scalability and performance modeling techniques to fine-tune architecture and design. The process is:

- Identify scalability requirements.
- Model expected load.
- Define SLIs and SLOs for user scenarios.

> [!NOTE]
> Azure Monitor, including Application Insights, provides application performance management (APM), telemetry, and metrics analysis. Azure Monitor supports OpenTelemetry and integrates with Azure Managed Grafana for distributed tracing and visualization.

### Capture scalability requirements

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

During special events, scale requirements may reach 10 times normal peak load.

### Define SLI metrics to calculate SLOs

SLI metrics indicate the degree to which a service provides a satisfactory experience, expressed as the ratio of good events to total events.

Example SLI metrics:

| Metric        | Description                                              |
|---------------|---------------------------------------------------------|
| Availability  | Whether the request was serviced by the API             |
| Latency       | Time for the API to process the request and reply       |
| Throughput    | Number of requests handled                              |
| Success Rate  | Number of requests handled successfully                 |
| Error Rate    | Number of errors for handled requests                   |
| Freshness     | Number of times the user received the latest data       |

Examples:

- (Number of requests completed successfully in <1,000 ms) / (Number of requests)
- (Number of search results returned within 3 seconds) / (Number of searches)

After defining SLIs, determine what telemetry to capture. For HTTP services, use status codes. Azure Monitor and Application Insights provide diagnostic and monitoring support.

### Use percentile distributions

Calculate some SLIs using percentile distributions to exclude outliers. For example, if 95th percentile latency is within the threshold, the SLO is considered met.

### Choose proper measurement periods

Define SLO measurement periods to capture activity, not idleness. The window can range from five minutes to 24 hours.

### Establish a performance governance process

Performance must be managed from inception to retirement. Elements of performance governance:

:::image type="content" source="media/scalable-apps-performance-modeling-site-reliability-lifecycle.png" alt-text="Diagram that shows the seven elements of performance governance, as described in the following section." :::

- **Performance Objectives:** Define aspirational SLOs.
- **Performance Modeling:** Identify business-critical workflows and model performance.
- **Design Guidelines:** Prepare and communicate performance design guidelines.
- **Implement Guidelines:** Instrument components and conduct design reviews.
- **Performance Testing:** Conduct load and stress testing.
- **Bottleneck Analysis:** Identify and remove performance bottlenecks.
- **Continuous Monitoring:** Use Azure Monitor and alerting.
- **Performance Governance:** Track compliance and review after each release.

Repeat these steps throughout development.

### Track performance objectives and expectations in your backlog

Track performance objectives as granular user stories to ensure governance activities are prioritized.

### Establish aspirational SLOs for the target solution

Sample aspirational SLOs:

- 95% of READ requests respond within one second.
- 95% of CREATE and UPDATE requests respond within three seconds.
- 99% of all requests respond within five seconds with no failures.
- 99.9% of all requests succeed within five minutes.
- Less than 1% of requests during peak hour error out.

Tailor SLOs to your application requirements.

### Measure initial SLOs based on log data

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

### Guidance for technical risk mitigation

Recommended practices:

- Design for scale and performance.
  - Capture scale requirements for all scenarios, including peaks.
  - Model performance to identify constraints.
- Manage technical debt.
  - Trace performance metrics.
  - Use tools such as K6, Karate, and JMeter for load testing.
  - Integrate automated tests into continuous deployment.
- Production mindset.
  - Adjust autoscaling thresholds based on health statistics.
  - Prefer horizontal scaling.
  - Use ring-based deployment.
  - Use error budgets for experimentation.
  - Use [Azure Chaos Studio](/azure/chaos-studio/chaos-studio-overview) for resilience testing.

## Pricing

Reliability, performance efficiency, and cost optimization are interrelated. Azure services in this architecture support autoscaling to accommodate changing loads.

For AKS, start with standard-sized VMs for node pools. Monitor and adjust resources as needed. Use Azure Savings Plans and Reserved Instance recommendations in [Azure Advisor](/azure/advisor/advisor-overview) for cost optimization.

Cost optimization is a pillar of the [Microsoft Azure Well-Architected Framework](/azure/well-architected/). To estimate costs, use the [Pricing calculator](https://azure.microsoft.com/pricing/calculator).

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
- [What is Application Gateway Ingress Controller?](/azure/application-gateway/ingress-controller-overview)
- [Azure Kubernetes Service](/azure/aks/intro-kubernetes)
- [Autoscaling and Zone-redundant Application Gateway v2](/azure/application-gateway/application-gateway-autoscaling-zone-redundant)
- [Automatically scale a cluster to meet application demands on Azure Kubernetes Service (AKS)](/azure/aks/cluster-autoscaler)
- [Create Azure Cosmos DB containers and databases with autoscale throughput](/azure/cosmos-db/provision-throughput-autoscale)
- [Azure Chaos Studio](/azure/chaos-studio/chaos-studio-overview)
- [Azure Advisor](/azure/advisor/advisor-overview)
- [Site reliability engineering documentation](/azure/site-reliability-engineering)
- [AZ-400: Develop a Site Reliability Engineering (SRE) strategy](/training/paths/az-400-develop-sre-strategy)
- [Baseline web application with zone redundancy](../../web-apps/app-service/architectures/baseline-zone-redundant.yml)

## Contributors

- Subhajit Chatterjee
- Dawid Obrocki