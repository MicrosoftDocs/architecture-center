The success of your cloud solution depends on its reliability. Reliability is the probability that the system functions as expected, under specified conditions, within a specified time. Site reliability engineering (SRE) is a set of principles and practices for creating scalable and highly reliable software systems. SRE is a standard approach for designing digital services to ensure reliability.

For more information on SRE strategies, see [AZ-400: Develop a Site Reliability Engineering (SRE) strategy](/training/paths/az-400-develop-sre-strategy).

## Architecture

:::image type="content" source="media/scalable-apps-performance-modeling-site-reliability.png" alt-text="The architecture shows microservices in a Kubernetes cluster. They receive requests passed on by Azure Front Door, and access data using various storage services." lightbox="media/scalable-apps-performance-modeling-site-reliability.png" :::

*Download a [PowerPoint file](https://arch-center.azureedge.net/US-1881435-scalable-apps-performance-modeling-site-reliability.pptx) of this architecture.*

### Dataflow

The following dataflow corresponds to the previous diagram:

1. Client applications such as web apps, mobile apps, and service applications send requests to the unified endpoint `https://api.contoso.com`.
1. Azure Front Door receives all incoming requests and provides global load balancing, SSL termination, and web application firewall protection.
1. Front Door routes requests to Azure API Management, which applies policies for access control, rate limiting, caching, and request transformation.
1. API Management forwards requests to the Application Gateway Ingress Controller (AGIC), which load balances traffic across the AKS cluster.
1. The appropriate microservice in AKS processes the request. Microservices include Product, Profile, Orders and Payment, and Content services.
1. Microservices access backend data stores as needed:
   - Azure Cosmos DB for globally distributed, low-latency data.
   - Azure SQL for relational data.
   - Azure Storage and Azure Data Lake Storage for unstructured content and files.
1. Microsoft Entra ID authenticates and authorizes users and service principals throughout the request flow.
1. The response traverses back through the same path to the client application.

This architecture represents a scalable API platform. The solution comprises multiple microservices that use various databases and storage services.

The example scenario covers high-level marketplace and e-commerce use cases, including:

- Product browsing.
- Registration and sign in.
- Viewing content such as news articles.
- Order and subscription management.

Client applications such as web apps, mobile apps, and service applications consume the API platform services through a unified access path, `https://api.contoso.com`.

### Components

- [Azure Front Door](/azure/well-architected/service-guides/azure-front-door) provides a secure, unified point of entry for all requests. See [Routing architecture overview](/azure/frontdoor/front-door-routing-architecture).
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

## Scenario details

This example scenario covers high-level marketplace and e-commerce use cases. It helps organizations build scalable API platforms using site reliability engineering (SRE) principles. SRE is a standard approach for designing digital services to ensure reliability, measured through service level objectives (SLOs) and service level indicators (SLIs).

### Potential use cases

The concepts in this article apply to:

- API-based cloud services.
- Public-facing web applications.
- IoT-based or event-based workloads.
- E-commerce platforms with product browsing, registration, and order management.
- Content delivery applications serving news articles and media.

## Appropriate reliability

The required reliability depends on the business context. SRE practices help you achieve the appropriate level of reliability.

Reliability is measured using service level objectives (SLOs) that define the target level of reliability for a service. SLOs are usually defined as a percentage achievement over a period. Service level indicators (SLIs) are the metrics used to calculate SLOs, based on customer experience.

The following image shows the relationship between the monitored metric, the SLI, and the SLO:

:::image type="content" source="media/scalable-apps-performance-modeling-site-reliability-slo.png" alt-text="Diagram that shows how to identify the right metric for reliability, define how to calculate its SLI, and set a target SLO." :::

For more information, see [Define SLI metrics to calculate SLOs](#define-sli-metrics-to-calculate-slos).

## Modeling scale and performance expectations

Performance refers to the responsiveness of a system. Scalability is the ability to handle increased load without hurting performance.

Design applications so that resources scale automatically to meet load. This design includes compute, storage, and messaging infrastructure.

This article shows how to ensure reliability by conducting scale and performance modeling, and using the results to define monitors, SLIs, and SLOs.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

> [!NOTE]
> Azure Monitor, including Application Insights, provides application performance management (APM), telemetry, and metrics analysis. Azure Monitor supports OpenTelemetry and integrates with Azure Managed Grafana for distributed tracing and visualization.

### Reliability

Reliability helps to ensure that your application can meet the commitments that you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

This architecture incorporates several reliability patterns:

- **Zone redundancy**: Azure Front Door, Application Gateway v2, and AKS support availability zone deployment for high availability within a region.
- **Autoscaling**: AKS cluster autoscaler, API Management autoscaling, and Azure Cosmos DB autoscale throughput help the system handle load variations without manual intervention.
- **Health monitoring**: Use Azure Monitor and Application Insights to track SLIs and SLOs, enabling proactive identification of reliability issues.
- **Resilience testing**: Use [Azure Chaos Studio](/azure/chaos-studio/chaos-studio-overview) to validate fault tolerance and recovery procedures.

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

This architecture addresses security through multiple layers:

- **Identity and access management**: Microsoft Entra ID provides centralized identity management for users and service principals.
- **Network security**: Azure Front Door provides web application firewall (WAF) protection against common web exploits. API Management enforces access policies and rate limiting.
- **Data protection**: Use managed identities for service-to-service authentication. Enable encryption at rest for all data stores.
- **API security**: API Management provides OAuth 2.0 validation, certificate authentication, and IP filtering capabilities.

### Cost optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

Cost drivers in this architecture include:

- **Compute**: AKS node pools and their VM sizes significantly affect costs. Start with standard-sized VMs and adjust based on monitoring data.
- **API Management**: Costs vary by tier. The Standard and Premium tiers support autoscaling but at higher base costs.
- **Data services**: Azure Cosmos DB costs depend on provisioned throughput and storage. Use autoscale throughput to optimize for variable workloads.
- **Networking**: Azure Front Door and Application Gateway incur costs based on traffic volume and features enabled.

To optimize costs:

- Use Azure Advisor recommendations for Reserved Instances and Azure Savings Plans.
- Right-size AKS node pools based on actual utilization.
- Configure autoscaling thresholds to balance performance and cost.
- Use Azure Cosmos DB autoscale to avoid over-provisioning.

Use the [Azure Pricing Calculator](https://azure.com/e/fe330064f12845cf82272f0e803b77e1) to estimate costs for this architecture. A typical medium-scale deployment includes:

| Component | SKU | Estimated monthly cost factor |
| --- | --- | --- |
| Azure Front Door | Premium | Traffic-based |
| API Management | Standard | Instance-based |
| AKS | Standard | Node count × VM size |
| Azure Cosmos DB | Autoscale | RU/s + storage |
| Application Gateway | WAF_v2 | Capacity units |

### Operational Excellence

Operational Excellence covers the operations processes that deploy an application and keep it running in production. For more information, see [Design review checklist for Operational Excellence](/azure/well-architected/operational-excellence/checklist).

Create an end‑to‑end performance governance process to manage performance throughout the service lifecycle.

- **Performance objectives**: Define aspirational SLOs based on business requirements.
- **Performance modeling**: Identify business-critical workflows and model expected performance.
- **Instrumentation**: Use Azure Monitor and Application Insights for APM, telemetry, and metrics analysis. Azure Monitor supports OpenTelemetry and integrates with Azure Managed Grafana for distributed tracing and visualization.
- **Performance testing**: Conduct load and stress testing using tools such as K6, Karate, and JMeter. Integrate automated tests into continuous deployment pipelines.
- **Continuous monitoring**: Set up alerts based on SLI thresholds and track SLO compliance.
- **Ring-based deployment**: Use progressive rollout strategies to minimize the impact of changes.

Track performance objectives as granular user stories in your backlog to ensure governance activities are prioritized alongside feature work.

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

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

During special events, scale requirements may reach 10 times normal peak load.

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

Examples:

- (Number of requests completed successfully in <1,000 ms) / (Number of requests)
- (Number of search results returned within 3 seconds) / (Number of searches)

After defining SLIs, determine what telemetry to capture. For HTTP services, use status codes. Azure Monitor and Application Insights provide diagnostic and monitoring support.

#### Use percentile distributions

Calculate some SLIs using percentile distributions to exclude outliers. For example, if 95th percentile latency is within the threshold, the SLO is considered met.

#### Choose proper measurement periods

Define SLO measurement periods to capture activity, not idleness. The window can range from five minutes to 24 hours.

#### Establish aspirational SLOs for the target solution

Sample aspirational SLOs:

- 95% of READ requests respond within one second.
- 95% of CREATE and UPDATE requests respond within three seconds.
- 99% of all requests respond within five seconds with no failures.
- 99.9% of all requests succeed within five minutes.
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
- Production mindset.
  - Adjust autoscaling thresholds based on health statistics.
  - Prefer horizontal scaling.
  - Use ring-based deployment.
  - Use error budgets for experimentation.
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

