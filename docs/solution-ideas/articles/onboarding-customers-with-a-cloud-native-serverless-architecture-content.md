[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This serverless architecture enables you to build and run applications without having to worry about the underlying infrastructure and the associated management and maintenance. By using it, you can dramatically improve developer productivity.

## Architecture

![Architecture diagram that shows customer information sent to endpoint, their photo to Face A P I, added to mailing list, and record created.](../media/onboarding-customers-with-a-cloud-native-serverless-architecture.png)

*Download an [SVG](../media/onboarding-customers-with-a-cloud-native-serverless-architecture.svg) of this architecture.*
<div class="architecture-tooltip-content" id="architecture-tooltip-2">

### Dataflow

1. Information about the new customer is posted to a web endpoint.
1. The customer's photo is posted to [Cognitive Services Face API](/azure/cognitive-services/face). Face API associates the customer's photo and name.
1. The customer information is recorded in [Dynamics 365](/dynamics365) or other CRM.
1. The information about a new customer is sent to [Power BI](/power-bi).
1. The customer information is added to the mailing list ([MailChimp](https://mailchimp.com)).
1. The solution creates a record of the member in [Cosmos DB](/azure/cosmos-db).

### Components

- [Azure API Management](https://azure.microsoft.com/products/api-management) creates consistent, modern API gateways for back-end services. Besides accepting API calls and routing them to back ends, this platform also verifies keys, tokens, certificates, and other credentials. API Management also enforces usage quotas and rate limits and logs call metadata.
- [Cognitive Services](https://azure.microsoft.com/products/cognitive-services/) consists of cloud-based services that provide AI functionality. You can use the REST APIs and client library SDKs to build cognitive intelligence into apps.
- The [Cognitive Services Face API](https://azure.microsoft.com/products/cognitive-services/face) provides access to features for detecting facial features and attributes and for identifying people by a match.
- [Dynamics 365](https://dynamics.microsoft.com/what-is-dynamics365/) is a portfolio of intelligent applications that businesses can use for enterprise resource planning (ERP) and customer relationship management (CRM).
- [Power BI](https://powerbi.microsoft.com/) is a collection of software services and apps that display analytics information.
- [Mailchimp](https://mailchimp.com/) is an email marketing platform that provides automation services.
- [Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db) is a globally distributed, multi-model database. With Azure Cosmos DB, your solutions can elastically scale throughput and storage across any number of geographic regions.
- [Azure Functions](https://azure.microsoft.com/products/functions) is a serverless compute platform that you can use to build applications. With Functions, you can use triggers and bindings to react to changes in Azure services.

## Scenario details


### Potential use cases

This solution benefits organizations that have customers. It's ideal for retail, media and entertainment, and other industries that use service-based subscriptions to stream videos and applications like Office 365 and Adobe.

## Next Steps

- [Learn to build Serverless apps](/azure/azure-functions)
- [Learn how you can use machine learning](/azure/machine-learning/how-to-enable-virtual-network)
- [Infuse intelligence into your apps with Cognitive Services](/azure/cognitive-services)
  
## Related resources
  
- [Decide which compute option to use for your apps](../../guide/technology-choices/compute-decision-tree.yml)
