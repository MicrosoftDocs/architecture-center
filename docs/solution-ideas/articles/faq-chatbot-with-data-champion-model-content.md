


[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

The QnA Maker tool makes it easy for the content owners to maintain their knowledge base of Questions and Answers. Combined with Bot Service and Language Understanding, it becomes simple to setup a FAQ chatbot which responds from different knowledge bases depending on the intent of the query.

## Architecture

![Architecture diagram](../media/faq-chatbot-with-data-champion-model.png)
*Download an [SVG](../media/faq-chatbot-with-data-champion-model.svg) of this architecture.*

## Data Flow

1. Employee access FAQ Bot
1. Azure Active Director validates the employee's identity
1. Query is send to a LUIS model to get the intent of the query
1. Based in the intent, the query is redirected to the appropriate Knowledge base
1. QnA Maker gives the best match to the incoming query
1. The result is shown to the employee
1. Data Champions manage and update their QnA Knowledge base based on the feedback from user traffic

## Components

* Application Insights, a feature of [Azure Monitor](https://azure.microsoft.com/services/monitor/)
* [Azure Active Directory](https://azure.microsoft.com/services/active-directory/)
* [Azure App Service](https://azure.microsoft.com/services/app-service/)
* [Azure Bot Services](https://azure.microsoft.com/services/bot-services/)
* [Language Understanding (LUIS)](https://azure.microsoft.com/services/cognitive-services/language-understanding-intelligent-service/)
* [QnA Maker](https://azure.microsoft.com/services/cognitive-services/qna-maker/)

## Next steps

* [Artificial intelligence (AI) - Architectural overview](../../data-guide/big-data/ai-overview.md)
* [Chatbot for hotel reservations](/azure/architecture/example-scenario/ai/commerce-chatbot)
* [Build an enterprise-grade conversational bot](/azure/architecture/reference-architectures/ai/conversational-bot)
* [Commerce Chatbot](/azure/architecture/solution-ideas/articles/commerce-chatbot)
* [Enterprise chatbot disaster recovery](/azure/architecture/solution-ideas/articles/enterprise-chatbot-disaster-recovery)
