---
title: "Fusion: Motivations and business risks that drive identity governance"
description: Explanation of the concept identity management in relation to cloud governance
author: BrianBlanchard
ms.date: 1/8/2019
---

# Fusion: Motivations and business risks that drive identity governance

This article discusses the reasons that customers typically adopt an identity management discipline within a cloud governance strategy. It also provides a few examples of business risks which drive policy statements.

## Is identity management relevant?

Identity is increasingly considered the primary perimeter for security in the cloud. This is a shift from the traditional
focus on network security. Identity services provide the core access control mechanism of all IT environments, and the identity management discipline complements the [security management discipline](../security-management/overview.md) by providing user authentication and securing user access to cloud-based resources.

Traditional on-premises directories are designed to allow businesses to strictly control permissions and policies for users, groups, and roles within their internal networks and datacenters. This is usually intended to support single tenant implementations, with services applicable only within the on-premises environment.

Cloud identity services are intended to expand an organization's authentication and access control capabilities to the internet. They support multi-tenancy and can be used to manage users and access policy across cloud applications and deployments. Public cloud platforms have some form of cloud-native identity services supporting management and deployment tasks and are capable of [varying levels of integration](../../infrastructure/identity/overview.md) with your existing on-premises identity solutions. All of these features can result in cloud identity policy being more complicated than your traditional on-premises solutions required. 

The importance of the identity management discipline to your cloud deployment will depend on the size of your team and your need to integrate your cloud-based identity solution with an existing on-premises directory. Initial test deployments may not require much in the way of user organization or management, but as your cloud estate matures, you will likely need to support more complicated organization support. 

## Business risk

The identity management discipline attempts to address the following business risks. During cloud adoption, monitor each of the following for relevance:

* Identity management: Large teams can be difficult to manage if organizational policies are not applied to access control. This can result in oversight or errors in securing resources.
* Access control: Users and groups with control over resources beyond their area of responsibility can, through accident or malicious intent, cause major disruptions to your cloud hosted resources and potentially lead to data security breaches.
* User authentication: Account credentials lacking a strong authentication method can lead to compromised user accounts, allowing unauthorized access to secure resources.
* User activity and auditing: Organizations that don’t actively monitor their identity systems are at risk of having user credentials compromised. Without knowledge that suspicious activities are taking place through these credentials, organizations can’t mitigate this type of threat.
* Isolated providers: Traditional on-premises identity services are single-tenant and introduce management overhead.

## Next steps

Using the [Cloud Management Template](./template.md), document business risks that are likely to be introduced by the current cloud adoption plan.

Once an understanding of realistic business risks is established, the next step is to document the business's [tolerance for risk](./metrics-tolerance.md) and the indicators / key metrics to monitor that tolerance.

> [!div class="nextstepaction"]
> [Understand indicators, metrics, and risk tolerance](./metrics-tolerance.md)