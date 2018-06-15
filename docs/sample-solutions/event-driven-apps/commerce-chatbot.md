---
title: Conversational commerce chatbot
description: Proven solution for building a conversational chatbot for commerce applications in Azure.
author: iainfoulds
ms.date: 06/13/2018
---
# Conversational commerce chatbot on Azure

This sample solution is applicable for businesses that have a need for integrating a conversational chatbot into applications.

Example application scenarios include providing a way for customers to view hotel availaiblity and book rooms, review a restaurant take-out menu and place a food order, or search for and order prints of photographs. Traditionally, businesses would need to hire and train customer service agents to respond to these customer requests, and customers would have to wait until a representative is available to provide assistance.

By leveraging Azure services such as the Bot Service and Language Understanding or Speech API services, companies can assist customers and process orders or reservations with automated, scalable bots. This scenario specifically outlines a hotel chain that allows customers to check availability and reserve a room. If you have different commerce needs, you may want to consider the full suite of [Cognitive Services][cognitive-docs].

## Potential use cases

You should consider this solution for the following use cases:

* View restaurant take-out menu and order food
* Check hotel availability and reserve a room
* Search available photos and order prints

## Architecture diagram

The solution diagram below is an example of this solution:

![Architecture overview of the Azure components involved in a commerce chatbot][architecture]

## Architecture

This solution covers a commerce bot that functions as a concierge for a hotel. The data flows through the solution as follows:

1. The customer uses a mobile or web app.
2. Using Azure Active Directory B2C (Business 2 Customer), the user is authenticated.
3. Interacting with the Bot Service, user requests information about hotel availability.
4. Cognitive Services process the natural language request to understand the customer communication.
5. The bot's response is reviewed by customer who can refine their question or continue the discussion using natural conversation.
6. After the user is happy with the results, the bot adds or updates the customer’s reservation in a SQL Database.
7. Application Insights gathers runtime telemetery throughout the process to help development with bot performance and usage.

### Components

* [Azure Active Directory][aad-docs] is Microsoft’s multi-tenant cloud based directory and identity management service. Azure AD supports a B2C connector allowing you to identify individuals using external IDs such as Google, Facebook, or a Microsoft Account.
* [App Service][appservice-docs] enables you to build and host web applications in the programming language of your choice without managing infrastructure.
* [Bot Service][botservice-docs] provides tools to build, test, deploy, and manage intelligent bots.
* [Cognitive Services][cognitive-docs] lets you use intelligent algorithms to see, hear, speak, understand and interpret your user needs through natural methods of communication.
* [SQL Database][sqldatabase-docs] is a fully managed relational cloud database service that provides SQL Server engine compatibility.
* [Application Insights][appinsights-doc] is an extensible Application Performance Management (APM) service that lets you monitor the performance of applications, such as your chatbot.

### Availability

This solution uses Azure SQL Database for storing customer reservations. SQL Database includes zone redundant databases, failover groups, and geo-replication. For more information, see [Azure SQL Database availability capabilities][sqlavailability-docs].

For other scalability topics, see the [availability checklist][availability] available in the architecure center.

### Scalability

This solution uses Azure App Service. With App Service, you can automatically scale the number of instances that run your bot. For more information on autoscale, see [Autoscaling best practices][autoscaling] in the architecture center.

For other scalability topics, see the [scalability checklist][scalability] available in the architecure center.

### Security

This solution uses Azure Active Directory B2C (Business 2 Consumer) for the identity and authentication components. With AAD B2C, your chatbot doesn't store any sensitive customer account information or credentials. For more information, see [Azure Active Directory B2C overview][aadb2c-docs].

Information stored in Azure SQL Database is encrypted at rest with transparent data encryption (TDE). SQL Database also offers Always Encrypted which also encrypts data during querying and processing. For more information on SQL Database security, see [Azure SQL Database security and compliance][sqlsecurity-docs].

For a deeper discussion on [security][], see the relevant article in the architecture center.

### Resiliency

This solution uses Azure SQL Database for storing customer reservations. SQL Database includes zone redundant databases, failover groups, geo-replication, and automatic backups. For more information, see [Azure SQL Database availability capabilities][sqlavailability-docs].

To monitor the health of your application, this solution also uses Application Insights. With App Insights, you can generate alerts and respond to performance issues that would impact the customer experience and availability of the chatbot. For more information, see [App Insights overview][appinsights-docs].

For a deeper discussion on [resiliency][], see the relevant article in the architecture center.

## Pricing

Explore the cost of running this solution, all of the services are pre-configured in the cost calculator.  To see how the pricing would change for your particular use case, change the appropriate variables to match your expected traffic.

We have provided three sample cost profiles based on the amount of messages you expect your chatbot to process:

* [Small][small-pricing]: this correlates to processing < 10,000 messages per month.
* [Medium][medium-pricing]: this correlates to processing < 500,000 messages per month.
* [Large][large-pricing]: this correlates to processing < 10 million messages per month.

## Related Resources

Other resources that are relevant that aren't linked from else where in the doc.

<!-- links -->
[aadb2c-docs]: /azure/active-directory-b2c/active-directory-b2c-overview
[appinsights-docs]: /azure/application-insights/app-insights-overview
[architecture]: ./media/commerce-chatbot/architecture-commerce-chatbot.png
[resource-groups]: /azure/azure-resource-manager/resource-group-overview
[aad-docs]: /azure/active-directory/
[appservice-docs]: /azure/app-service/
[botservice-docs]: /azure/bot-service/
[cognitive-docs]: /azure/cognitive-services/
[sqldatabase-docs]: /azure/sql-database/
[appinsights-doc]: /azure/application-insights/
[availability]: ../../checklist/availability.md
[resiliency]: ../../resiliency/index.md
[security]: ../../patterns/category/security.md
[sqlavailability-docs]: /azure/sql-database/sql-database-technical-overview#availability-capabilities
[sqlsecurity-docs]: /azure/sql-database/sql-database-technical-overview#advanced-security-and-compliance
[scalability]: ../../checklist/scalability.md
[autoscaling]: ../../best-practices/auto-scaling.md
[small-pricing]: https://azure.com/e/dce05b6184904c50b38e1a8654f726b6
[medium-pricing]: https://azure.com/e/304d17106afc480dbc414f9726078a03
[large-pricing]: https://azure.com/e/8319dd5e5e3d4f118f9029e32a80e887