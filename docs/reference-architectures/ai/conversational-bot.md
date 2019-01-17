# Enterprise-grade conversational bot

This reference architecture describes how to build an enterprise-grade conversational bot (chatbot) using the [Azure Bot Framework](https://dev.botframework.com/). Each bot is different, of course, but there are some common patterns, workflows, and technologies to be aware of. Especially for a bot to serve enterprise workloads, there are many design considerations beyond just the core functionality. This article covers the most essential design aspects, and introduces the tools needed to build a robust, secure, and actively learning bot.

![Diagram of the architecture](./_images/conversational-bot.png)

## Architecture

The architecture shown here uses the following Azure services. Your own bot may not use all of these, or may incorporate additional services.

### Bot logic and user experience

**[Bot Framework Service][bot-framework-service]** (BFS). This service connects your bot to a communication app such as Cortana, Facebook Messenger, or Slack. It facilitates communication between your bot and the user.

**[Azure App Service][app-service]**. The bot application and logic is hosted in Azure App Service.

### Bot cognition and intelligence

**[Language Understanding][luis]** (LUIS). Part of [Azure Cognitive Services][cognitive-services], LUIS enables your bot to understand natural language by identifying user intents and entities.

**[Azure Search][search]**. Search is a managed service that provides a quick searchable document index.

**[QnA Maker][qna-maker]**. QnA Maker is a cloud-based API service that creates a conversational, question-and-answer layer over your data. Typically, it's loaded with semi-structured content such as FAQs. Use it to create a knowledge base for answering natural-language questions.

### Logging and monitoring

- Azure Blob Storage – Optimized for storing massive amounts of unstructured data.
- Cosmos DB – Scalable "schema on demand" document store.
- AppInsights – Used to log web application metrics for monitoring, diagnostic, and analytical purposes.
- PowerBI (PBI) – Used to create visually appealing dashboards for data exploration and analysis.

### Data ingestion

The bot will rely on raw data that must be ingested and prepared. Consider any of the following options to orchestrate this process:

**[Azure Data Factory][data-factory]**. Data Factory orchestrates and automates data movement and data transformation. You can find a Data Factory reference architecture [here][data-factory-ref-arch].

[Logic Apps][logic-apps]**. Logic Apps is a serverless platform for building workflows that integrate applications, data, and services. Logic Apps provides data connectors for numerous applications, including Office 365.

**[Azure Functions][functions]**. You can use Azure Functions to write custom serverless code is invoked by a [trigger][functions-triggers] &mdash; for example, whenever a documented is added to blob storage or Cosmos DB.

### Security and governance

**[Azure Active Directory](** (AAD). Users authenticate through an identity provider such as Azure AD. The Bot Service handles the authentication flow and OAuth token management. See [Add authentication to your bot via Azure Bot Service][bot-authentication].

**[Azure Key Vault][key-vault]**. Store credentials and other secrets using Key Vault.

## Design considerations

At a high level, a conversational bot can be divided into the bot functionality (the "brain") and a set of surrounding requirements (the "body"). The brain includes the domain-aware components, including the bot logic and ML capabilities. Other components are domain agnostic and address non-functional requirements such as CI/CD, quality assurance, and security.

![Logical diagram of bot functionality](./_images/conversational-bot-logical.png)

Before getting into the specifics of this architecture, let's start with the data flow through each subcomponent of the design. The data flow includes user-initiated and system-initiated data flows.

### User message flow

**Authentication**. Users start by authenticating themselves using whatever mechanism is provided by their channel of communication with the bot. The bot framework supports many communciation channels, including Cortana, Microsoft Teams, Facebook Messenger, Kik, and Slack. For a list of channels, see [Connect a bot to channels](/azure/bot-service/bot-service-manage-channels). The bot is configured with channels to create a connection between the bot and the user. You can also connect the bot to a custom app by using the [Direct Line](/azure/bot-service/bot-service-channel-connect-directline) channel. The user's identity is used to provide role-based access control, as well as to serve personalized content.

**User message**. Once authenticated, the user sends a message to the bot. The bot reads the message and routes it to a natural language understanding service such as [LUIS](/azure/cognitive-services/luis/). This step gets the **intents** (what the user wants to do) and **entities** (what things the user is interested in). The bot then builds a query that it passes to a service that serves information, such as Azure Search for document retrieval, [QnA Maker](https://www.qnamaker.ai/) for FAQs, or a custom knowledge base. The bot uses these results to construct a response. To give the best result for a  given query, the bot might make several back-and-forth calls to these remote services.

**Response**. At this point, the bot has determined the best response and sends it to the user. If the confidence score of the best-matched answer is low, the response might be a disambiguation question or an acknowledgement that the bot could not reply adequately.

**Logging**. When a user request is received or a response is sent, all conversation actions should be logged to a logging store, along with performance metrics and general errors from external services. These logs will be useful later when diagnosing issues and improving the system.

**Feedback**. Another good practice is to collect user feedback and satisfaction scores. As a follow up to the bot's final response, the bot should ask the user to rate his or her satisfaction with the reply. Feedback can help you to solve the cold start problem of natural language understanding, and continually improve the accuracy of responses.

### System Data Flow

**ETL**. The bot relies on raw data in the back-end. This data might be structured (SQL database), semi-structured (CRM system, FAQs), or unstructured (Word documents, PDFs, web logs). An ETL subsystem extracts the data on a fixed schedule. The content is transformed and enriched, then loaded into an intermediary data store, such as Cosmos DB or Azure Blob Storage.

Data in the intermediary store is then indexed into Azure Search for document retrieval, loaded into QnA Maker to create question and answer pairs, or loaded into a custom web app for unstructured text processing. It is also used train a LUIS model for intent and entity extraction.

**Quality assurance**. The conversation logs are used to diagnose and fix bugs, provide insight into how the bot is being used, and track overall performance. Feedback data is also useful for retraining the AI models to improve bot performance.

**Monitoring**. Create a performance dashboard for the DevOps team, and set up alerts so that operators are aware of critical issues as they arise. 

**Testing**. For testing, we recommend recording real HTTP responses from external services, such as Azure Search or QnA Maker, so they can be played back during unit testing without needing to make real network calls to external services.

## Building a bot

### Ingest Data

The very first thing you should do before you write a line of code is to write a functional spec so you, and everyone you work with, has a clear idea of what the bot is expected to do. Included in this should be a reasonably sized list of user inputs and expected bot responses in various knowledge domains. This "living document" will be an invaluable guide for developing and testing your bot going forward.

Next identify the data sources that will provide the data the bot will need to interact intelligently with the user. As mentioned earlier, these data sources could contain structured, semi-structured or unstructured datasets. To get started, a one-off copy of the data to a central store, such as CosmosDB or Azure Storage, is a good approach. As you progress, you will want to create automated data ingest pipelines to keep this data current, using such Azure services as Azure Data Factory, Azure Functions or Web Logic (or a combination of these based on the raw data store and the schema of the raw dataset).

As you get started, it's reasonable to use the Azure Portal to manually create whatever Azure resources you need. Later on, more thought should be put into how to automate the deployment of these resources.

### Core Bot Logic and UX

Now it's time to start making your bot into reality. You should familiarize yourself with the [bot framework](https://dev.botframework.com/), including the [bot connector](/azure/bot-service/rest-api/bot-framework-rest-connector-quickstart) that handles the networking between the bot and your channels, and the core bot logic that handles the back and forth communication with the user.

Let's focus on the core bot logic. This is the code that a bot developer writes and handles the conversation with the user including the routing logic, disambiguation logic, and logging. First, you should familiarize yourself with the basic concepts and terminology used in the bot framework, especially what is a conversation, a turn, and an activity. Familiarize yourself with how the conversation [state](/azure/bot-service/bot-builder-concept-state) is maintained, either in memory or better yet in a store such as Azure Blob Storage or Azure Cosmos DB. Also read up on [middleware](/azure/bot-service/bot-builder-basics#middleware), and how it can be used to hook up your bot with external services, such as Cognitive Services.

For a rich [UX](/azure/bot-service/bot-service-design-user-experience) experience, there are many options at your disposal. You can use [cards](/azure/bot-service/bot-service-design-user-experience#cards) to include buttons, images, carousels, and menus. You can make your bot support speech. You can even embed your bot in an app or website and leverage the capabilities of the app hosting it. Here are some design principles to consider.

To get started you can simply build your bot online using the [Azure Bot Service](https://docs.microsoft.com/en-us/azure/bot-service/bot-service-quickstart?view=azure-bot-service-4.0), where you can select from the available C# and Node.js templates. As your bot gets more sophisticated, however, you will need to create your bot locally then deploy it to the web. You must choose an IDE, such as Visual Studio or Code, and a programming language. As of this writing, SDKs are in General Available (GA) release  for [C#](https://github.com/microsoft/botbuilder-dotnet) and [JavaScript](https://github.com/microsoft/botbuilder-js), and preview release for [Java](https://github.com/microsoft/botbuilder-java) and [Python](https://github.com/microsoft/botbuilder-python). As a starting point, you can download the source code for the bot you created using the Azure Bot Service. You can also find [sample code](https://github.com/Microsoft/BotBuilder-Samples/blob/master/README.md), from simple echo bots to more sophisticated bots that integrate with various AI services.

### Add Smarts to your Bot

Depending on what your bot needs to do, for example one with a well-defined list of commands, you might be able to implement the core bot logic just by using a rules-based approach to parse the user input via regex. This has the advantage of being deterministic and understandable. However, when understanding the intents and entities of a more natural language message is required, there are AI services that can help.

LUIS is specifically designed to understand user intents and entities. You train it with a moderately sized collection of relevant [user input](https://docs.microsoft.com/en-us/azure/cognitive-services/luis/luis-concept-utterance) and desired responses, and it will return the intents and entities for a user's given message. AzureSearch can work alongside LUIS. You create searchable indexes over all relevant data and use them to find values for the given entities found by LUIS. [Synonyms](https://docs.microsoft.com/en-us/azure/search/search-synonyms) in Azure Search can also be used to widen the net of correct word mappings. QnA Maker is another service that is designed to return answers for the given questions. It is typically trained over semi-structured data such as FAQs.

There are many more AI services that can be used by your bot to further enrich the user experience. The [Cognitive Services suite of pre-built AI](https://azure.microsoft.com/en-us/services/cognitive-services/?v=18.44a) services (which includes LUIS and QnA Maker) has many services for vision, speech, language, search, and location.  You can quickly add functionality such as language translation, spell checking, sentiment analysis, OCR, location awareness, and content moderation. These services can be wired up as middleware modules in your bot to interact more naturally and intelligently with the user.

Should you want to integrate your own custom AI service, that is an option as well. In this case, you have complete flexibility on what you want to do, as you control the machine learning algorithm, training and the model. For example, you could implement your own topic modelling and use algorithm such as the [LDA](https://en.wikipedia.org/wiki/Latent_Dirichlet_allocation) for finding relevant information or answers from a set of a documents. A good approach here would be to expose your custom AI solution as a web service endpoint hosted on a WebApp, virtual machine or a cluster of machines and call the endpoint from the core bot logic. To assist you with custom AI, Azure Machine Learning provides a number of services and libraries to assist you in [training](https://github.com/Azure/MachineLearningNotebooks/tree/master/how-to-use-azureml/training) and [deploying](https://github.com/Azure/MachineLearningNotebooks/tree/master/how-to-use-azureml/deployment) your models.



## Logging and feedback

It's not a good idea flying blind when it comes to understanding how your bot is being used or how it's performing. You need to log user conversations with the bot, including the underlying performance metrics and any errors that occurred. These logs will prove invaluable when it comes to debugging issues, understanding user interactions, and improving the system. You can implement logging by using [transcript logging middleware](https://docs.microsoft.com/en-us/azure/bot-service/bot-builder-debug-transcript?view=azure-bot-service-4.0) for your bot. Different types of logs might be better suited for different stores. For example, AppInsights might be best for web logs, CosmosDB might be best for conversations, and Azure Storage (azure transcript storage as part of the bot framework) might be best for large payloads.

It's also important to understand how satisfied users are with their bot interactions. If you have a record of user feedback, you can use this data to focus your efforts on improving certain interactions and retraining the AI models for improved performance. You can use the [Feedback Middleware](https://github.com/Microsoft/botbuilder-utils-js/tree/master/packages/botbuilder-feedback) to directly ask users to provide optional feedback for each bot response. This feedback should be used to retrain the models, such as LUIS, in your system.

## Quality assurance and enhancement

Testing of the bot involves unit, integration, regression, and functional testing. To assist with testing the [Testing Middleware](https://github.com/Microsoft/botbuilder-utils-js/tree/master/packages/botbuilder-http-test-recorder) provides developers with the ability to record HTTP traffic from external services. It comes pre-built with support for LUIS, Azure Search, and QnAMaker, but extensions are available to support any service.

The last three sections use the Botbuilder Utils for JavaScript. This repo contains sample middleware code that can be used to accelerate the development of a Microsoft Bot Framework v4 bot running NodeJS. The packages are provided as utility sample code only, and so are not published to npm*. To use them in your bot, follow the instructions in the respective READMEs:

- [botbuilder-transcript-cosmosdb](https://github.com/Microsoft/botbuilder-utils-js/tree/master/packages/botbuilder-transcript-cosmosdb) – transcript logger backed by Cosmos DB SQL.
- [botbuilder-transcript-app-insights](https://github.com/Microsoft/botbuilder-utils-js/tree/master/packages/botbuilder-transcript-app-insights) – transcript logger backed by Application Insights.
- [botbuilder-feedback](https://github.com/Microsoft/botbuilder-utils-js/tree/master/packages/botbuilder-feedback) – feedback logging mechanism to rate the quality of answers.
- [botbuilder-http-test-recorder](https://github.com/Microsoft/botbuilder-utils-js/tree/master/packages/botbuilder-http-test-recorder) – HTTP recording and playback mechanism for unit testing.

*See ReadMe for full support disclaimer.

## Availability considerations

Keeping your enterprise bot up and running during maintenance or heavy load is essential. As you roll out new features or bug fixes to your bot, it is best to employ multiple deployment environments, such as staging and production. Using deployment slots from Azure DevOps allows you to do this with zero downtime. You can test your latest upgrades in the staging environment prior to swapping them to the production environment. As for handling load, bots are deployed as Azure WebApps, which are designed to scale up or out manually or automatically. Because your bot is hosted in Microsoft's global datacenter infrastructure, the App Service SLA promises high availability.

## Security considerations

For an enterprise bot that could potentially expose user and company confidential information, or be the target of denial of service attacks, security is a serious issue. Restricting who can log and use the bot and limiting which data can be accessed based on the user's identity or role is required. This type of user identity and data protection can be achieved using Azure Active Directory for identity and access control and Azure Key Vault for key and secrets management.

## Monitoring and reporting

Now that your enterprise bot is up and running, you will need a devops team to keep it that way. Constant monitoring of the system will be needed to ensure its operating at peak performance. The logs being sent to AppInsights or CosmosDB will be used to create effective monitoring dashboards, either using AppInsights itself, PowerBI, or possibly a custom webapp dashboard. Errors or performance levels falling below an acceptable threshold will result in email notifications to the devops team.

## Deployment considerations

### Automated Resource Deployment

Of course, the bot itself is only part of a larger ecosystem needed to provide it with the latest data and to ensure its proper operation. All of these other Azure resources – data orchestration services such as ADF, Web Logic, or Azure functions, storage services such as Azure Storage Blob or Cosmos DB, etc. – need to be deployed. Azure Resource Manager provides a consistent management layer that you can access through Azure Portal, Client SDKs, REST API, Azure PowerShell and Azure CLI. For speed and consistency, it's best to automate your deployment using one of these approaches.

### Continuous Bot Deployment

Deploying your bot logic itself can be done directly from your IDE, such as Visual Studio. You can also use the command line, such as the Azure CLI. As your bot matures, it's best to use a continual deployment process using a CI/CD solution such as Azure DevOps, as described in the article [Set up continuous deployment](https://docs.microsoft.com/en-us/azure/bot-service/bot-service-build-continuous-deployment?view=azure-bot-service-4.0). This is a good way to ease the friction in testing out new features and fixes in your bot in a near production environment. Speaking of which, and as discussed above under availability, it's a good idea to have multiple deployment environments, typically at least staging and production. Azure DevOps supports this as well, allowing you to deploy to multiple deployment slots.

<!-- links -->

[app-service]: /azure/app-service/
[bot-authentication]: /azure/bot-service/bot-builder-authentication
[bot-framework-service]: /azure/bot-service/bot-builder-basics
[cognitive-services]: /azure/cognitive-services/welcome
[data-factory]: /azure/data-factory/
[data-factory-ref-arch]: ../data/enterprise-bi-adf.md
[functions]: /azure/azure-functions/
[functions-triggers]: /azure/azure-functions/functions-triggers-bindings
[key-vault]: /azure/key-vault/
[logging-utilities]
[logic-apps]: /azure/logic-apps/logic-apps-overview
[luis]: /azure/cognitive-services/luis/
[qna-maker]: /azure/cognitive-services/QnAMaker/index
[search]: /azure/search/
