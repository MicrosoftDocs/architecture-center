---
title: Integration cost estimates
description: Describes cost strategies for integration services
author:  v-aangie
ms.date: 09/03/2020
ms.topic: article
ms.service: architecture-center
ms.subservice: well-architected
ms.custom: 
---

# Integration cost estimates

All integration services have no up-front cost or termination fees, and you pay only for what you use. In addition, if you are running triggers in [Logic Apps](#logic-apps-cost), action and connector executions are metered. Integration services can be purchased together or individually.

Use the [Azure Pricing calculator](https://azure.microsoft.com/pricing/calculator/) for help creating various cost scenarios.

## API Management cost

If you want to publish your APIs securely for internal and external developers to use when connecting to backend systems hosted anywhere, use API Management. For cost considerations, see [Web application cost](https://docs.microsoft.com/azure/architecture/framework/cost/provision-webapps#api-management-cost).

Cost increases or decreases when you change capacity. First, evaluate capacity needs to meet business requirements. Then, increase or decrease the number of units to scale. Each unit has certain request processing capacity that depends on the service’s tier. For guidance in choosing capacity, see [Scalability considerations](https://docs.microsoft.com/azure/architecture/reference-architectures/enterprise-integration/basic-enterprise-integration#scalability-considerations). This topic also discusses the cost impact of the pricing tier.

For pricing details, see [API Management Pricing](https://azure.microsoft.com/pricing/details/api-management/).

## Logic Apps cost

To create workflows and orchestrate business processes to connect hundreds of services, use Logic Apps. To implement a process, a logic app can access other applications, including cloud applications, on-premises applications, and Azure Services. Logic Apps uses a [serverless](https://docs.microsoft.com/azure/logic-apps/logic-apps-serverless-overview) model, which allows for billing on a consumption-based plan. Billing is calculated based on action and connector execution. Cost increases as the number of action and connector executions are added. For details on actions and connectors, see [Consumption pricing model](https://docs.microsoft.com/azure/logic-apps/logic-apps-pricing#consumption-pricing-model).

For pricing details, see [Logic Apps pricing](https://azure.microsoft.com/pricing/details/logic-apps/).

## Service Bus cost

If you want to connect on-premises and cloud-based applications and services to implement highly secure messaging workflows, use Service Bus. The number of operations impact cost. The Basic tier is the cheapest. If you want more operations and more features, choose the Standard or Premium tier. For example, Service Bus Premium runs in dedicated resources to provide higher throughput and more consistent performance.

For pricing details, see [Service Bus pricing](https://azure.microsoft.com/pricing/details/service-bus/).

## Event Grid cost

To connect supported Azure and third-party services using a fully managed event-routing service to simplify event-based app development, use Event Grid. Event Grid uses a pay-per-use model based on operations performed. Examples of some operations are event ingress, subscription delivery attempts, management calls, and filtering by subject suffix.

For pricing details, see [Event Grid pricing](https://azure.microsoft.com/pricing/details/event-grid/).