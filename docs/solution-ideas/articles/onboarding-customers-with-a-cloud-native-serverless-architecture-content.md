[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This serverless solution provides an efficient way to manage customer data. Core components include the Azure Cognitive Services Face API, which offers access to facial recognition technology. The solution also includes customer relationship management (CRM) through Dynamics 365 and data analytics through Power BI.

## Architecture

:::image type="content" alt-text="Architecture diagram that shows how customer data is sent to an endpoint and added to the Face API, a mailing list, and a database." source="../media/onboarding-customers-with-a-cloud-native-serverless-architecture.png" border="false":::

*Download an [SVG](../media/onboarding-customers-with-a-cloud-native-serverless-architecture.svg) of this architecture.*
<div class="architecture-tooltip-content" id="architecture-tooltip-2">

### Dataflow

1. Information about a new customer is posted to a web endpoint.
1. The customer's photo is posted to the [Cognitive Services Face API](/azure/cognitive-services/face), where the image is linked to the customer's name.
1. The customer information is recorded in a CRM system such as [Dynamics 365](/dynamics365).
1. The customer information is sent to [Power BI](/power-bi).
1. The customer information is added to a MailChimp mailing list.
1. The solution creates a record of the customer in [Azure Cosmos DB](/azure/cosmos-db).

### Components

- [Azure API Management](https://azure.microsoft.com/products/api-management) creates consistent, modern API gateways for back-end services. Besides accepting API calls and routing them to back ends, this platform also verifies keys, tokens, certificates, and other credentials. API Management also enforces usage quotas and rate limits and logs call metadata.
- [Cognitive Services](https://azure.microsoft.com/products/cognitive-services/) consists of cloud-based services that provide AI functionality. You can use the REST APIs and client library SDKs to build cognitive intelligence into apps.
- The [Cognitive Services Face API](https://azure.microsoft.com/products/cognitive-services/face) provides access to functionality that detects facial features and attributes. You can also use the API to match images.
- [Dynamics 365](https://dynamics.microsoft.com/what-is-dynamics365/) is a portfolio of intelligent applications that businesses can use for enterprise resource planning (ERP) and CRM.
- [Power BI](https://powerbi.microsoft.com/) is a collection of software services and apps that provide analytics reporting.
- [Mailchimp](https://mailchimp.com/) is an email marketing platform that provides automation services.
- [Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db) is a globally distributed, multi-model database. With Azure Cosmos DB, your solutions can elastically scale throughput and storage across any number of geographic regions.
- [Azure Functions](https://azure.microsoft.com/products/functions) is a serverless compute platform that you can use to build applications. With Functions, you can use triggers and bindings to react to changes in Azure services.

## Scenario details

Serverless architectures, like the one in this solution, offer many benefits. You can build and run applications without having to manage or maintain the underlying infrastructure. As a result, you can dramatically improve developer productivity.

This solution uses a NoSQL database, Azure Cosmos DB. This type of database system is designed to quickly store huge volumes of rapidly changing, unstructured data and make it readily available for search, consolidation, and analysis.

### Potential use cases

This solution benefits organizations that manage large volumes of customer data. It's ideal for retail, media and entertainment, and other industries that use service-based subscriptions to stream videos and applications like Office 365 and Adobe.

## Next Steps

- [Learn to build Serverless apps](/azure/azure-functions)
- [What are Azure Cognitive Services?](/azure/cognitive-services/what-are-cognitive-services)
- [What is the Azure Face service?](/azure/cognitive-services/computer-vision/overview-identity)
- [What is Azure API Management?](/azure/api-management/api-management-key-concepts)
- [What is Power BI?](/power-bi/fundamentals/power-bi-overview)
- [Welcome to Azure Cosmos DB](/azure/cosmos-db/introduction)

## Related resources
  
- [Decide which compute option to use for your apps](../../guide/technology-choices/compute-decision-tree.yml)
- [Face recognition and sentiment analysis](../../example-scenario/ai/nifi-sentiment-analysis-face-recognition.yml)