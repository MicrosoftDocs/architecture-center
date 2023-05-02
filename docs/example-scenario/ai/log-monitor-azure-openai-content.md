This solution provides comprehensive logging and monitoring and enhanced security for enterprise deployments of the  Azure OpenAI Service API. The solution enables advanced logging capabilities for tracking API usage and performance and robust security measures to help protect sensitive data and help prevent malicious activity.

## Architecture

:::image type="content" source="media/openai-monitor-log.png" alt-text="Diagram that shows an architecture that provides monitoring and logging for Azure OpenAI." lightbox="media/openai-monitor-log.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/azure-openai-monitor-log.vsdx) of this architecture.*
 
### Workflow

1.	Client applications access Azure OpenAI endpoints to perform text generation (completions) and model training (fine-tuning).
2.	Azure Application Gateway provides a single point of entry to Azure OpenAI models and provides load balancing for APIs.
  
    > [!Note]
    > Load balancing of stateful operations like model fine-tuning, deployments, and inference of fine-tuned models isn't supported.

3.	Azure API Management enables security controls and auditing and monitoring of the Azure OpenAI models.  
   a.	In API Management, enhanced-security access is granted via Azure Active Directory (Azure AD) groups with subscription-based access permissions.  
   b.	Auditing is enabled for all interactions with the models via Azure Monitor request logging.  
   c.	Monitoring provides detailed Azure OpenAI model usage KPIs and metrics, including prompt information and token statistics for usage traceability.
4.	API Management connects to all Azure resources via Azure Private Link. This configuration provides enhanced security for all traffic via private endpoints and contains traffic in the private network.
5.	Multiple Azure OpenAI instances enable scale-out of API usage to ensure high availability and disaster recovery for the service.

### Components

- [Application Gateway](https://azure.microsoft.com/services/application-gateway/). Application load balancer to help ensure that all users of the Azure OpenAI APIs get the fastest response and highest throughput for model completions.
- [API Management](https://azure.microsoft.com/services/api-management/). API management platform for accessing back-end Azure OpenAI endpoints. Provides monitoring and logging that's not available natively in Azure OpenAI.
- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network/). Private network infrastructure in the cloud. Provides network isolation so that all network traffic for models is routed privately to Azure OpenAI.
- [Azure OpenAI](https://azure.microsoft.com/products/cognitive-services/openai-service/). Service that hosts models and provides generative model completion outputs.
- [Monitor](https://azure.microsoft.com/services/monitor/). End-to-end observability for applications. Provides access to application logs via Kusto Query Language. Also enables dashboard reports and monitoring and alerting capabilities.
- [Azure Key Vault](https://azure.microsoft.com/services/key-vault/). Enhanced-security storage for keys and secrets that are used by applications.
- [Azure Storage](https://azure.microsoft.com/services/storage/). Application storage in the cloud. Provides Azure OpenAI with accessibility to model training artifacts.
- [Azure AD](https://azure.microsoft.com/services/active-directory/). Enhanced-security identity manager. Enables user authentication and authorization to the application and to platform services that support the application. Also provides Group Policy to ensure that the principle of least privilege is applied to all users.

### Alternatives

Azure OpenAI provides native logging and monitoring. You can use this native functionality to track telemetry of the service, but the default cognitive service logging doesn't track or record inputs and outputs of the service, like prompts, tokens, and models. These metrics are especially important for compliance and to ensure that the service operates as expected. Also, by tracking interactions with the large language models deployed to Azure OpenAI, you can analyze how your organization is using the service to identify cost and usage patterns that can help inform decisions on scaling and resource allocation.

The following table provides a comparison of the metrics provided by the default Azure OpenAI logging and those provided by this solution. 

|Metric	|Default Azure OpenAI logging|This solution|
|-|-|-|
|Request count|	x|	x|
|Data in (size) / data out (size)| 	x|	x|
|Latency|	x	|x|
|Token transactions (total)|	x|	x|
|Caller IP address	|x (last octet masked)|	x|
|Model utilization	||	x|
|Token utilization (input/output)	||	x|
|Input prompt detail	||	x|
|Output completion detail||		x|
|Deployment operations	|x	|x|
|Embedding operations	|x|	x (limited to 8,192 response characters)|

## Scenario details

Large enterprises that use generative AI models need to implement auditing and logging of the use of these models to ensure responsible use and corporate compliance. This solution provides enterprise-level logging and monitoring for all interactions with AI models to mitigate harmful use of the models and help ensure that security and compliance standards are met. The solution integrates with existing APIs for Azure OpenAI with little modification to take advantage of existing code bases. Administrators can also monitor service usage for reporting.

The solution provides these advantages:

- Comprehensive logging of Azure OpenAI model execution, tracked to the source IP address. Log information includes text that users submit to the model and text received back from the model. This logging helps ensure that models are used responsibly and within the approved use cases of the service.
- High availability of the model APIs to ensure that user requests are met even if the traffic exceeds the limits of a single Azure OpenAI service.
- Role-based access managed via Azure AD to ensure that the principle of least privilege is applied.

**Example query for usage monitoring**

```
ApiManagementGatewayLogs
| where OperationId == 'completions_create'
| extend modelkey = substring(parse_json(BackendResponseBody)['model'], 0, indexof(parse_json(BackendResponseBody)['model'], '-', 0, -1, 2))
| extend model = tostring(parse_json(BackendResponseBody)['model'])
| extend prompttokens = parse_json(parse_json(BackendResponseBody)['usage'])['prompt_tokens']
| extend completiontokens = parse_json(parse_json(BackendResponseBody)['usage'])['completion_tokens']
| extend totaltokens = parse_json(parse_json(BackendResponseBody)['usage'])['total_tokens']
| extend ip = CallerIpAddress
| summarize
    sum(todecimal(prompttokens)),
    sum(todecimal(completiontokens)),
    sum(todecimal(totaltokens)),
    avg(todecimal(totaltokens))
    by ip, model
```

Output:

:::image type="content" source="media/monitor-usage.png" alt-text="Screenshot that shows the output of usage monitoring." lightbox="media/monitor-usage.png":::

**Example query for prompt usage monitoring**

```
ApiManagementGatewayLogs
| where OperationId == 'completions_create'
| extend model = tostring(parse_json(BackendResponseBody)['model'])
| extend prompttokens = parse_json(parse_json(BackendResponseBody)['usage'])['prompt_tokens']
| extend prompttext = substring(parse_json(parse_json(BackendResponseBody)['choices'])[0], 0, 100)
```

Output: 

:::image type="content" source="media/prompt-usage.png" alt-text="Screenshot that shows the output of prompt usage monitoring." lightbox="media/prompt-usage.png":::


### Potential use cases

- Deployment of Azure OpenAI for internal enterprise users to accelerate productivity
- High availability of Azure OpenAI for internal applications
- Enhanced-security use of Azure OpenAI within regulated industries
 
## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

Reliability ensures that your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

This scenario ensures high availability of the large language models for your enterprise users. The Azure application gateway provides an effective layer-7 application delivery mechanism to ensure fast and consistent access to applications. You can use API Management to configure, manage, and monitor access to your models. The inherent high availability of platform services like Storage, Key Vault, and Virtual Network ensure high reliability for your application. Finally, multiple instances of Azure OpenAI ensure service resilience in case of application-level failures. These architecture components can help you ensure the reliability of your application at enterprise scale.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

By implementing best practices for application-level and network-level isolation of your cloud services, this scenario mitigates risks of data exfiltration and data leakage. All network traffic containing potentially sensitive data that's input to the model is isolated in a private network. This traffic doesn't traverse public internet routes. You can use Azure ExpressRoute to further isolate network traffic to the corporate intranet and help ensure end-to-end network security.

### Cost optimization

Cost optimization is about reducing unnecessary expenses and improving operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

To help you explore the cost of running this scenario, we've preconfigured all the services in the Azure pricing calculator. To learn how the pricing would change for your use case, change the appropriate variables to match your expected traffic.

The following three sample cost profiles provide estimates based on the amount of traffic. (The estimates assume that a document contains approximately 1,000 tokens.)

- [Small](https://azure.com/e/c367a7fdf6174ddfb39563d4f835fa14): For processing 10,000 documents per month.
- [Medium](https://azure.com/e/e0581d8d849c48f4beb1cfcf374c1f36): For processing 100,000 documents per month.
- [Large](https://azure.com/e/b1a2c35910ea42f0bf1eed0ea44e27bf): For processing 10 million documents per month.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors: 

- [Ashish Chauhan](https://www.linkedin.com/in/a69171115/) | Cloud Solution Architect – Data / AI
- [Jake Wang]( https://www.linkedin.com/in/jake-wang/) | Cloud Solution Architect – AI / Machine Learning

Other contributors: 

- [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414/) | Technical Writer 
 
*To see non-public LinkedIn profiles, sign in to LinkedIn.* 

## Next steps

- [Azure OpenAI request form](https://customervoice.microsoft.com/Pages/ResponsePage.aspx?id=v4j5cvGGr0GRqy180BHbR7en2Ais5pxKtso_Pz4b1_xUOFA5Qk1UWDRBMjg0WFhPMkIzTzhKQ1dWNyQlQCN0PWcu)
- [Best practices for prompt engineering with OpenAI API](https://help.openai.com/en/articles/6654000-best-practices-for-prompt-engineering-with-openai-api) 
- [Azure OpenAI: Documentation, quickstarts, API reference](/azure/cognitive-services/openai/)
- [Azure-Samples/openai-python-enterprise-logging (GitHub)](https://github.com/Azure-Samples/openai-python-enterprise-logging)
- [Configure Azure Cognitive Services virtual networks](/azure/cognitive-services/cognitive-services-virtual-networks)

## Related resources

- [Protect APIs with Azure Application Gateway and Azure API Management](../../reference-architectures/apis/protect-apis.yml)
- [Query-based document summarization](/azure/architecture/guide/ai/query-based-summarization)
- [AI architecture design](../../data-guide/big-data/ai-overview.md)
