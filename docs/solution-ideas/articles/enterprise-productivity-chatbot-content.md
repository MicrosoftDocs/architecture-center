[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Azure Bot Service can be easily combined with Language Understanding to build powerful enterprise productivity bots, allowing organizations to streamline common work activities by integrating external systems, such as Microsoft 365 calendar, customer cases stored in Dynamics CRM and much more.

## Architecture

![Architecture Diagram](../media/enterprise-productivity-chatbot.png)
*Download an [SVG](../media/enterprise-productivity-chatbot.svg) of this architecture.*

## Data Flow

1. An employee accesses the Enterprise Productivity Bot.
1. Azure Active Directory validates the employee's identity.
1. The Bot is able to query the employee's Microsoft 365 calendar via the Microsoft Graph.
1. Using data gathered from the calendar, the Bot accessrd case information in Dynamics CRM.
1. Information is returned to the employee, who can filter down the data without leaving the Bot.
1. Application Insights gathers runtime telemetry, to help the development with Bot performance and usage.

## Components

Key technologies used to implement this architecture:

* [Azure Active Directory](https://azure.microsoft.com/services/active-directory)
* [Azure Monitor](https://azure.microsoft.com/services/monitor): Application Insights is a feature of Azure Monitor.
* [Azure App Service](https://azure.microsoft.com/services/app-service)
* [Azure Bot Service](https://azure.microsoft.com/services/bot-service)
* [Azure Cognitive Services Speech Services](https://azure.microsoft.com/services/cognitive-services/speech-services)
* [Azure Cognitive Services QnA Maker](https://azure.microsoft.com/services/cognitive-services/qna-maker)
* [Azure Cognitive Services Language Understanding](https://azure.microsoft.com/services/cognitive-services/language-understanding-intelligent-service)
* [Microsoft Graph](https://developer.microsoft.com/graph)
* [Microsoft Dynamics 365](https://dynamics.microsoft.com)

## Next Steps

* [Artificial intelligence (AI) - Architectural overview](../../data-guide/big-data/ai-overview.md)
* [Choosing a Microsoft cognitive services technology](../../data-guide/technology-choices/cognitive-services.md)
* [What are Azure Cognitive Services?](/azure/cognitive-services/what-are-cognitive-services)
* [What is the Speech service?](/azure/cognitive-services/speech-service/overview)
* [What is QnA Maker?](/azure/cognitive-services/QnAMaker/Overview/overview)
* [What is Language Understanding (LUIS)?](/azure/cognitive-services/luis/what-is-luis)
* [Introduction to Bot Framework Composer](/composer/introduction)
* [What is Application Insights](/azure/azure-monitor/app/app-insights-overview)
* [Overview of Microsoft Graph](/graph/overview)

Fully deployable architectures:

* [Chatbot for hotel reservations](../../example-scenario/ai/commerce-chatbot.yml)
* [Build an enterprise-grade conversational bot](../../reference-architectures/ai/conversational-bot.yml)
* [Speech-to-text conversion](../../reference-architectures/ai/speech-ai-ingestion.yml)