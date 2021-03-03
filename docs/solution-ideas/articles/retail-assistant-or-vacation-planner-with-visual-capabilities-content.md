


[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

The retail assistant or vacation planner can help your customers have interactions with your business bot and provide suggestions based on the visual information.

## Architecture

![Architecture diagram](../media/retail-assistant-or-vacation-planner-with-visual-capabilities.png)
*Download an [SVG](../media/retail-assistant-or-vacation-planner-with-visual-capabilities.svg) of this architecture.*

## Data Flow

1. Users interact with your business assistant
1. Assistant understands context from LUIS
1. Assistant passes visual context to the Bing Visual Search API
1. Optionally Bot gets more information for user queries exclusively from your domain using the Bing Custom Search API

## Components

* [Azure App Service](/azure/app-service/)
* [Azure Bot Service](/services/bot-services/)
* [Azure Language Understanding](/services/cognitive-services/language-understanding-intelligent-service/)
* [Bing Search](/bing/search-apis/bing-web-search/bing-api-comparison), including Bing Custom search and Bing Visual search

## Next steps

* [Artificial intelligence (AI) - Architectural overview](../../data-guide/big-data/ai-overview.md)
* [Commerce Chatbot](commerce-chatbot.md)
* [Product recommendations for retail using Azure](product-recommendations.md)
* [Visual Assistant](visual-assistant.md)
