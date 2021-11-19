---
title: Reserved instances
description: Use reserved instances through Azure Reservations to lower cost. With reserved instances, there's a significant discount when compared to pay-as-you-go pricing.
author: PageWriter-MSFT
ms.date: 05/12/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
ms.custom:
  - article
---

# Reserved instances
[Azure Reservations](/azure/cost-management-billing/reservations/) are offered on many services as a way to lower cost. You reserve a prepaid capacity for a period, generally one or three years. With reserved instances, there's a significant discount when compared with pay-as-you-go pricing. You can pay up front or monthly, price wise both are same.

## Usage pattern
Before opting for reserved instances, analyze the usage data with pay-as-you-go prices over a time duration.

**Do the services in the workload run intermittently or follow long-term patterns?**
***

Azure provides several options that can help analyze usage and make recommendations by comparing reservations prices with pay-as-you-go price. An easy way is to view the **Recommended** tab in the Azure portal. [Azure Advisor](https://portal.azure.com/#blade/Microsoft_Azure_Reservations/CreateBlade/referrer/docs) also provides recommendations that are applicable to an entire subscription. If you need a programmatic way, use the [Reservation Recommendations REST APIs](/rest/api/consumption/reservationrecommendations/list).

Reserved instances can lower cost for long running workloads. For intermittent workloads, prepaid capacity might go unused and it doesn't carry over to the next billing period. Usage exceeding the reserved quantity is charged using more expensive pay-as-you-go rates. But there are some flexible options. You can exchange or refund a reservation within limits. For more information, see [Self-service exchanges and refunds for Azure Reservations](/azure/cost-management-billing/reservations/exchange-and-refund-azure-reservations).

## Scope
Reservations can be applied to a specific scope—subscription, resource group, or a single resource. Suppose you set the scope as the resource group, the reservation savings will apply to the applicable resources provisioned in that group. For more information, see [Scope reservations](/azure/cost-management-billing/reservations/prepare-buy-reservation#scope-reservations).

## Services, subscription, and offer types
Many services are eligible for reservations. This range covers virtual machines and a wide variety of managed services. For information about the services that are eligible for reservations, see [Charges covered by reservation](/azure/cost-management-billing/reservations/save-compute-costs-reservations#charges-covered-by-reservation).

Certain subscriptions and offer types support reservations. For a list of such subscriptions, see [Discounted subscription and offer types](/azure/cost-management-billing/reservations/prepare-buy-reservation#discounted-subscription-and-offer-types).
