


[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Visual assistant provides rich information based on content of the image with capabilities such as reading business card, identifying barcode, and recognizing popular people, places, objects, artworks, and monuments.

## Architecture

![Architecture diagram](../media/visual-assistant.png)
*Download an [SVG](../media/visual-assistant.svg) of this architecture.*

## Data flow

1. Users interact with Bot through mobile app or web app
1. Bot understands user intent and conversational context by leveraging off LUIS which is built into the application
1. Bot passes visual context (i.e. image) to the Bing Visual Search API
1. Bot gets additional information from Bing Entity Search for rich context on people, place, artwork, monument, and objects.
1. Bot gets additional information for barcodes.
1. Optionally, Bot gets more information on barcodes/queries exclusively from your domain through the Bing Custom Search API.
1. Visual Assistant renders similar products/destinations from your domain or provides more information around celebrity/place/monuments/artworks.

## Components

* [Azure App Service](https://azure.microsoft.com/services/app-service/): A fully managed HTTP-based service for hosting web apps, REST APIs and mobile backends
* [Azure Bot Service](https://azure.microsoft.com/services/bot-services/): Develop intelligent, enterprise-grade bots that enrich your customer experience, all while maintaining control of your data
* [Bing Custom Search](https://www.customsearch.ai/): Build customised search that fits your business needs with Bing's powerful ranking and global-scale search index
* [Bing Entity Search](https://www.microsoft.com/bing/apis/bing-entity-search-api): Infuse a deep knowledge search into your existing content by identifying the most relevant
* [Bing Visual Search](/azure/cognitive-services/bing-visual-search/overview): Find visual insights from your images
* [Bing Web Search](https://www.microsoft.com/bing/apis/bing-web-search-api): Bring intelligent search to your apps and harness the ability to comb through billions of webpages, images, videos and news, all with a single API call
* [Language Understanding Intelligence Service (LUIS)](https://www.luis.ai/): Build natural language into apps, bots and IoT devices

## Next steps

* Let your app detect context that matters to you by training your own [Custom Vision model](/azure/cognitive-services/custom-vision-service/quickstarts/object-detection)
* Explore the [Bing family of search APIs](/bing/search-apis/bing-web-search/bing-api-comparison) to get started
* Look through [Bing Search API documentation](/azure/cognitive-services/bing-web-search/) for the reference REST API material
* [Build in LUIS into your Bot](/azure/bot-service/bot-builder-howto-v4-luis)


## Recommended resources

* Explore how LUIS works in this [Learn Module](/learn/modules/create-language-model-with-language-understanding/)
* [Create a LUIS app in Azure](/learn/modules/create-and-publish-a-luis-model/)
* Learn how to build with [Azure Bot Service](/learn/modules/build-faq-chatbot-qna-maker-azure-bot-service/)
* Create a Bot that incorporates [both QnA Maker and Azure Bot Service](/learn/paths/create-bots-with-the-azure-bot-service/)
* Solidify your understanding of LUIS, Azure Bot Service and Bing Visual Search with [Microsoft Certified: AI Fundamentals](/learn/certifications/exams/ai-900)
* Use your SME knowledge in Azure Cognitive Services and [become an Azure AI Engineer](/learn/certifications/exams/ai-100)
