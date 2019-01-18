---
title: "Fusion: Motivations and business risks that drive identity governance"
description: Explanation of the concept identity management in relation to cloud governance
author: BrianBlanchard
ms.date: 1/8/2019
---

# Fusion: Motivations and business risks that drive identity governance

This article discusses the reasons that customers typically adopt an identity management discipline within a cloud governance strategy. It also provides a few examples of business risks that drive policy statements.

## Is identity management relevant?

Traditional on-premises directories are designed to allow businesses to strictly control permissions and policies for users, groups, and roles within their internal networks and datacenters. This is usually intended to support single tenant implementations, with services applicable only within the on-premises environment.

Cloud identity services are intended to expand an organization's authentication and access control capabilities to the internet. They support multi-tenancy and can be used to manage users and access policy across cloud applications and deployments. Public cloud platforms have some form of cloud-native identity services supporting management and deployment tasks and are capable of [varying levels of integration](../../infrastructure/identity/overview.md) with your existing on-premises identity solutions. All of these features can result in cloud identity policy being more complicated than your traditional on-premises solutions require. 

The importance of the identity management discipline to your cloud deployment will depend on the size of your team and need to integrate your cloud-based identity solution with an existing on-premises identity service. Initial test deployments may not require much in the way of user organization or management, but as your cloud estate matures, you will likely need to support more complicated organizational integration and centralized management.

## Business risk

The identity management discipline attempts to address core business risks related to identity services and access control. Work with your business to identity these risks and monitor each them during your cloud deployment for relevance.

Risks will differ between organization, but the following serve as common risks that you can use as a starting point for discussions within your cloud governance team:

- **Unauthorized access**. Sensitive data and resources that can be accessed by unauthorized users can lead to data leaks or service disruptions, violating your organization's security perimeter and risking business or legal liabilities.
- **Inefficiency due to multiple identity solutions**. Organizations with multiple identity services tenants can require multiple accounts for users. This can lead to inefficiency for users who need to remember multiple sets of credentials and for IT in managing accounts across multiple systems.
- **Inability to share resources with external partners**. Difficulty adding external business partners to your existing identity solutions can prevent efficient resource sharing and business communication.
- **Difficulty reflecting business change**. If user access assignments are not updated as staff, teams, and business goals change, your cloud resources may be vulnerable to unauthorized access or users unable to access required resources.

## Next steps

Using the [Cloud Management Template](./template.md), document business risks that are likely to be introduced by the current cloud adoption plan.

Once an understanding of realistic business risks is established, the next step is to document the business's [tolerance for risk](./metrics-tolerance.md) and the indicators and key metrics to monitor that tolerance.

> [!div class="nextstepaction"]
> [Understand indicators, metrics, and risk tolerance](./metrics-tolerance.md)