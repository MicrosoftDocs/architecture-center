[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This solution presents a visual assistant that provides rich information based on the content of an image. The assistant's capabilities include reading business cards, deciphering barcodes, and recognizing popular people, places, objects, artwork, and monuments.

## Potential use cases

Organizations can use this solution to provide:

- Appointment scheduling.
- Order and delivery tracking in manufacturing, automotive, and transportation applications.
- Barcode purchases in retail.
- Payment processing in finance and retail.
- Subscription renewals in retail.
- Recognizing popular people, places, objects, art, and monuments, in the education, media, and entertainment industries.

## Architecture

![Architecture diagram that shows the flow of data between a browser and a bot, and between the bot and search services.](../media/visual-assistant.png)
*Download an [SVG](../media/visual-assistant.svg) of this architecture.*

### Dataflow

1. Users interact with a bot through a mobile app or a web app.
1. The bot uses LUIS, which is built into the application, to identify the user intent and conversational context.
1. The bot passes visual context, such as an image, to the Bing Visual Search API.
1. The bot retrieves information from Bing Entity Search for about people, places, artwork, monuments, and objects that are related to the image.
1. The bot retrieves information from barcodes.
1. Optionally, the bot gets more information about barcodes/queries that's limited to the user's domain by using the Bing Custom Search API.
1. The visual assistant presents the user with the information about related products, destinations, celebrities, places, monuments, and artwork.

### Components

- [Azure App Service](/azure/app-service): A fully managed HTTP-based service for hosting web apps, REST APIs, and mobile backends
- [Azure Bot Service](/azure/bot-service): Develop intelligent, enterprise-grade bots that enrich your customer experience, all while maintaining control of your data
- [Bing Custom Search](/bing/search-apis/bing-custom-search/overview): Build customized search that fits your business needs with Bing's powerful ranking and global-scale search index
- [Bing Entity Search](/bing/search-apis/bing-entity-search/overview): Infuse a deep knowledge search into your existing content by identifying the most relevant
- [Bing Visual Search](/bing/search-apis/bing-visual-search/overview): Find visual insights from your images
- [Bing Web Search](/bing/search-apis/bing-web-search/overview): Bring intelligent search to your apps and harness the ability to comb through billions of webpages, images, videos, and news, all with a single API call
- [Language Understanding Intelligence Service (LUIS)](/azure/cognitive-services/luis/what-is-luis): Build natural language into apps, bots, and IoT devices

## Next steps

- To design an app that detects context that matters to you, see [Quickstart: Create an object detection project with the Custom Vision client library](/azure/cognitive-services/custom-vision-service/quickstarts/object-detection).
- To explore the search capabilities that Bing provides, see [Bing family of search APIs](/bing/search-apis/bing-web-search/bing-api-comparison).
- To build LUIS into your bot, see [Add natural language understanding to your bot](/azure/bot-service/bot-builder-howto-v4-luis).
- To explore a Learn module about how LUIS works, see [Create a language model with Conversational Language Understanding](/learn/modules/create-language-model-with-language-understanding).
- To learn how to build with Azure Bot Service, see [Build a bot with the Language Service and Azure Bot Service](/learn/modules/build-faq-chatbot-qna-maker-azure-bot-service).
- To create a bot that incorporates QnA Maker and Azure Bot Service, see [Create conversational AI solutions](/learn/paths/create-bots-with-the-azure-bot-service).
- To solidify your understanding of LUIS, Azure Bot Service, and Bing Visual Search, see [Exam AI-900: Microsoft Azure AI Fundamentals](/learn/certifications/exams/ai-900).
- To certify your knowledge about Azure Cognitive Services, see [Microsoft Certified: Azure AI Engineer Associate](/learn/certifications/azure-ai-engineer).
- To learn more about the solution components, see these resources:

  - [App Service overview](/azure/app-service/overview)
  - [Azure Bot Service documentation](/azure/bot-service)
  - [What is Bing Custom Search?](/bing/search-apis/bing-custom-search/overview)
  - [What is Bing Entity Search API?](/bing/search-apis/bing-entity-search/overview)
  - [What is the Bing Visual Search API?](/bing/search-apis/bing-visual-search/overview)
  - [What is the Bing Web Search API?](/bing/search-apis/bing-web-search/overview)
  - [What is Language Understanding (LUIS)?](/azure/cognitive-services/luis/what-is-luis)

## Related resources

- [Artificial intelligence (AI) - Architectural overview](../../data-guide/big-data/ai-overview.md)
- [Image classification on Azure](../../example-scenario/ai/intelligent-apps-image-processing.yml)
- [Interactive voice response application with bot](./interactive-voice-response-bot.yml)
- [Retail Assistant with Visual Capabilities](./retail-assistant-or-vacation-planner-with-visual-capabilities.yml)
