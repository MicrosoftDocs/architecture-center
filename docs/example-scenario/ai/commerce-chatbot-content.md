<!-- cSpell:ignore iainfoulds botservice -->

This example scenario applies generally to businesses that want to integrate a conversational chatbot into applications. Specifically, this scenario shows a C# chatbot for a hotel to allow customers to check availability and book accommodation through a web or mobile application.

## Architecture

The following architecture is for designing a hotel booking bot.

![Architecture overview: conversational chatbot and the Azure components involved in a conversational chatbot][architecture]

*Download a [Visio file][visio-download] of this architecture.*

### Dataflow

This scenario covers a conversational bot that functions as a concierge for a hotel. The data flows through the scenario as follows:

1. The customer accesses the chatbot with a mobile or web app.
2. Using [Azure Active Directory (Azure AD) B2C](/azure/active-directory-b2c/active-directory-b2c-overview), the customer is authenticated.
3. Interacting with the [Bot Service][botservice-docs], the customer requests information about hotel availability.
4. [Cognitive Services][cognitive-docs] processes the natural language request to understand the customer communication.
5. After the customer is happy with the results, the bot adds or updates the reservation or booking in a [SQL database][sqldatabase-docs].
6. [Application Insights][appinsights-docs] gathers runtime telemetry throughout the process to help the DevOps team improve bot performance and usage.

### Components

- [Azure AD](https://azure.microsoft.com/services/active-directory) is a multitenant cloud-based directory and identity management service. Azure AD supports a B2C connector allowing you to identify users by their external IDs, such as Google, Facebook, or a Microsoft account.
- [Azure App Service](https://azure.microsoft.com/services/app-service) enables you to build and host web applications in the programming language of your choice without managing infrastructure.
- [Azure Bot Service](https://azure.microsoft.com/services/bot-service) provides tools to build, test, deploy, and manage intelligent bots.
- [Azure Cognitive Services](https://azure.microsoft.com/services/cognitive-services) lets you use intelligent algorithms to see, hear, speak, understand, and interpret your user needs through natural methods of communication.
- [Azure SQL Database](https://azure.microsoft.com/services/sql-database) is a fully managed relational cloud database service that provides SQL Server engine compatibility.
- Application Insights, a feature of [Azure Monitor](https://azure.microsoft.com/services/monitor), is an extensible Application Performance Management (APM) service that lets you monitor the performance of applications, such as your chatbot.

### Alternatives

Other components that could be used to enhance this example scenario include:

- [Speech API](https://azure.microsoft.com/services/cognitive-services/speech-services) to change how customers interface with your bot.
- [QnA Maker](https://azure.microsoft.com/pricing/details/cognitive-services/qna-maker) to quickly add knowledge to your bot from semi-structured content like an FAQ.
- [Translator Text](https://azure.microsoft.com/services/cognitive-services/translator) as a service to easily add multi-lingual support to your bot.

## Scenario details

### Potential use cases

Beyond hotel booking, this chatbot could be used in a wide range of commerce settings. For example, the chatbot can enable customers to review the take-out menu of restaurant and place an order. Or, the chatbot can enable customers of a photography studio to search for and order prints. Traditionally, businesses hire and train customer service agents to respond to these types of customer requests. As a result, customers wait until a representative is available to provide assistance.

With [Azure Bot Service][botservice-docs] and [Language Understanding][language-understanding] or [Speech][speech-api] services, businesses can use scalable bots to handle common customer requests.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Availability

This scenario uses Azure SQL Database for storing customer reservations. SQL Database includes zone redundant databases, failover groups, and geo-replication. For more information, see [Azure SQL Database availability capabilities][sqlavailability-docs].

### Scalability

This scenario uses Azure App Service. With App Service, you can automatically scale the number of instances that run your bot. This functionality lets you keep up with customer demand for your web application and chatbot. For more information on autoscale, see [Autoscaling best practices][autoscaling] in the Azure Architecture Center.

For other scalability articles, see the [performance efficiency checklist][scalability] in the Azure Architecture Center.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

This scenario uses Azure AD B2C, a business-to-consumer identity management service, to authenticate users. With Azure AD B2C, your chatbot doesn't store any sensitive customer account information or credentials. For more information, see the [Azure AD B2C overview](/azure/active-directory-b2c/active-directory-b2c-overview).

Information stored in Azure SQL Database is encrypted at rest with transparent data encryption (TDE). SQL Database also offers Always Encrypted which encrypts data during querying and processing. For more information on SQL Database security, see [Azure SQL Database security and compliance][sqlsecurity-docs].

For general guidance on designing secure solutions, see the [Azure Security Documentation][security].

### Resiliency

This scenario uses Azure SQL Database for storing customer reservations. SQL Database includes zone redundant databases, failover groups, geo-replication, and automatic backups. These features allow your application to continue running if there's a maintenance event or outage. For more information, see [Azure SQL Database availability capabilities][sqlavailability-docs].

To monitor the health of your application, this scenario uses Application Insights. With Application Insights, you can generate alerts and respond to performance issues that would affect customer experience and availability of the chatbot. For more information, see [What is Application Insights?][appinsights-docs]

For other resiliency articles, see [Designing reliable Azure applications](/azure/architecture/framework/resiliency/app-design).

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

To explore the cost of running this scenario, use the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator). To see how pricing changes for different use cases, change the service variables to match expected traffic. For example, consider three cost profiles based on the number of messages you expect your chatbot to process:

- Small, processing < 10,000 messages per month.
- Medium, processing < 500,000 messages per month.
- Large, processing < 10 million messages per month.

## Deploy this scenario

You must have an existing Azure account. If you don't have an Azure subscription, create a [free account](https://azure.microsoft.com/free/?WT.mc_id=A261C142F) before you begin.

This scenario is divided into three components for easier exploration:

- **Infrastructure components**: Use an Azure Resource Manager template to deploy the core infrastructure components of an App Service, Web App, Application Insights, Storage account, and SQL Server and database. Use the following steps.

    1. Use the link below to deploy the solution.

        [![Deploy this solution to Azure](../../_images/deploy-to-azure.svg)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fmspnp%2Fsolution-architectures%2Fmaster%2Fapps%2Fcommerce-chatbot.json)

    2. Wait for the template deployment to open in the Azure portal, and follow the UI instructions to create the deployment. Specify:
       - A resource group name such as *myCommerceChatBotInfrastructure*.
       - Select a region.
       - Provide a username and secure password for the SQL Server administrator account.

        It takes a few minutes for the deployment to complete.

- **Web app chatbot**: To use Azure CLI to deploy a bot with the Bot Service, see [Deploy your bot](/azure/bot-service/bot-builder-deploy-az-cli). To add Language Understanding and Intelligent Services (LUIS) to the bot.

- **Sample C# chatbot application**: Use Visual Studio to review the [sample C# application](https://github.com/Microsoft/AzureBotServices-scenarios/tree/master/CSharp/Commerce/src) on GitHub. The sample application includes the Azure Active Directory authentication components and integration with the Language Understanding and Intelligent Services (LUIS) component of Cognitive Services. The application requires Visual Studio to build and deploy the scenario. Additional information on configuring Azure AD B2C and the LUIS app can be found in the GitHub repo documentation.

## Next steps

Product documentation:

- [What is Azure Active Directory?](/azure/active-directory/fundamentals/active-directory-whatis)
- [What is Azure Active Directory B2C?](/azure/active-directory-b2c/active-directory-b2c-overview)
- [Azure App Service](/azure/app-service)
- [Azure Bot Framework Composer tutorials][botservice-docs]
- [What are Azure Cognitive Services?](/azure/cognitive-services/what-are-cognitive-services)
- [What is Azure SQL Database?](/azure/azure-sql/database/sql-database-paas-overview)
- [Application Insights][appinsights-docs]

Microsoft Learn modules:

- [Create Intelligent Bots with the Azure Bot Service][learn1]
- [Build a bot with QnA Maker and Azure Bot Service][learn2]

## Related resources

- [Commerce chatbot for customer service](../../solution-ideas/articles/commerce-chatbot.yml)
- [Build an enterprise-grade conversational bot](../../reference-architectures/ai/conversational-bot.yml)
- [Speech-to-text conversion](/azure/architecture/example-scenario/ai/speech-to-text-transcription-analytics)

<!-- links -->

[appinsights-docs]: /azure/application-insights/app-insights-overview
[architecture]: ./media/architecture-commerce-chatbot.png
[autoscaling]: ../../best-practices/auto-scaling.md
[botservice-docs]: /composer/tutorial/tutorial-introduction
[cognitive-docs]: /azure/cognitive-services
[language-understanding]: /azure/cognitive-services/luis/what-is-luis
[learn1]: /training/paths/create-bots-with-the-azure-bot-service/
[learn2]: /training/modules/build-faq-chatbot-qna-maker-azure-bot-service/
[security]: /azure/security
[scalability]: /azure/architecture/framework/scalability/performance-efficiency
[sqlavailability-docs]: /azure/sql-database/sql-database-technical-overview#availability-capabilities
[sqldatabase-docs]: /azure/sql-database
[sqlsecurity-docs]: /azure/sql-database/sql-database-technical-overview#advanced-security-and-compliance
[speech-api]: /azure/cognitive-services/speech-service/overview
[visio-download]: https://arch-center.azureedge.net/architecture-commerce-chatbot.vsdx
