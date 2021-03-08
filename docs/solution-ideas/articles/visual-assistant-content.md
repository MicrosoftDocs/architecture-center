


[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Visual assistant provides rich information based on content of the image with capabilities such as reading business card, identifying barcode, and recognizing popular people, places, objects, artworks, and monuments.

## Architecture

![Architecture diagram](../media/visual-assistant.png)
*Download an [SVG](../media/visual-assistant.svg) of this architecture.*

## Data Flow

1. Users interact with bot
1. Bot understands context from LUIS
1. Bot passes visual context to the Bing Visual Search API
1. Bot gets additional information from Bing Entity Search for rich context on people, place, artwork, monument, and objects.
1. Bot gets additional information for barcodes.
1. Optionally Bot gets more information on barcodes/queries exclusively from your domain through the Bing Custom Search API.
1. Assistant renders similar products/destinations from your domain or provides more information around celebrity/place/monuments/artworks.

## Components

* [Azure App Service](/azure/app-service/)
* [Azure Bot Service](/services/bot-services/)
* [Azure Language Understanding](/services/cognitive-services/language-understanding-intelligent-service/)
* [Bing Search](/bing/search-apis/bing-web-search/bing-api-comparison), including Bing Custom search, Bing Entity search, Bing Visual search, and Bing web search

## Next steps

* [Artificial intelligence (AI) - Architectural overview](../../data-guide/big-data/ai-overview.md)
* [Image classification on Azure](/azure/architecture/solution-ideas/articles/example-scenario/ai/intelligent-apps-image-processing)
* [Interactive Voice Response Bot](/azure/architecture/solution-ideas/articles/interactive-voice-response-bot)
* [Retail Assistant with Visual Capabilities](/azure/architecture/solution-ideas/articles/retail-assistant-or-vacation-planner-with-visual-capabilities)
