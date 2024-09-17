This solution provides comprehensive logging and monitoring and enhanced security for enterprise deployments of the  Azure OpenAI Service API. The solution enables advanced logging capabilities for tracking API usage and performance and robust security measures to help protect sensitive data and help prevent malicious activity.

## Architecture

:::image type="content" source="_images/openai-monitor-log.png" alt-text="Diagram that shows an architecture that provides monitoring and logging for Azure OpenAI." lightbox="_images/openai-monitor-log.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/azure-openai-monitor-log.vsdx) of this architecture.*

### Workflow

1. Client applications access Azure OpenAI endpoints to perform text generation (completions) and model training (fine-tuning).
2. Azure Application Gateway provides a single point of entry for clients to the private network that contains the Azure OpenAI models and APIs. For internal applications the gateway also enables hybrid access from cross-premises clients.
   - Application Gateway Web Application Firewall (WAF) provides protection against common web vulnerabilities and exploits.
   - Application Gateway health probes are used to monitor health of the APIs.
    
    > [!NOTE]
    > Load balancing of stateful operations like model fine-tuning, deployments, and inference of fine-tuned models isn't supported.

3. Azure API Management enables security controls, auditing, and monitoring of the Azure OpenAI models.
   - In API Management, enhanced-security access is granted via Microsoft Entra groups with subscription-based access permissions.
   - Auditing is enabled for all interactions with the models via Azure Monitor request logging.
   - Monitoring provides detailed Azure OpenAI model usage, key performance indicators (KPIs), and metrics, including prompt information and token statistics for usage traceability.
4. API Management connects to all origin resources via Azure Private Link. This configuration provides enhanced privacy for all traffic by containing traffic in the private network.
5. This topology also supports [multiple Azure OpenAI instances](/azure/architecture/ai-ml/guide/azure-openai-gateway-multi-backend) to enable scale-out of API usage to ensure high availability and disaster recovery for the service.
6. For Azure OpenAI model inputs and outputs that exceed the default logging capabilities, APIM policies forward requests to Azure Event Hubs and Azure Stream Analytics to extract payload information and store in Azure Data Storage service such as Azure SQL DB or Azure Data Explorer.  This enables capture of specific data for compliance and auditing purposes without any limits on payload sizing and minimal performance impacts.
    
    > [!NOTE]
    > For streaming responses Azure OpenAI models, additional configuration is required to capture model completions. This configuration is not covered in this architecture.

### Components

- [Application Gateway](https://azure.microsoft.com/services/application-gateway/). Application load balancer to help ensure that all users of the Azure OpenAI APIs get the fastest response and highest throughput for model completions.  The Application Gateway also provides a Web Application Firewall (WAF) to protect against common web vulnerabilities and exploits.
- [API Management](https://azure.microsoft.com/services/api-management/). API management platform for accessing back-end Azure OpenAI endpoints. Provides monitoring and logging that's not available natively in Azure OpenAI. API Management also provides monitoring, logging, and managed access to Azure OpenAI resources.
- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network/). Private network infrastructure in the cloud. Provides network isolation so that all network traffic for models is routed privately to Azure OpenAI.  In this architecture, the Virtual Network provides network isolation for all deployed Azure resources.
- [Azure OpenAI](https://azure.microsoft.com/products/ai-services/openai-service/). Service that hosts models and provides generative model completion outputs.  Azure OpenAI provides access to the GPT Large Language Models used by end-user.
- [Monitor](https://azure.microsoft.com/services/monitor/). End-to-end observability for applications. Provides access to application logs via Kusto Query Language. Also enables dashboard reports and monitoring and alerting capabilities.  In this architecture, Monitor provides access to API Management logs and metrics.
- [Azure Key Vault](https://azure.microsoft.com/services/key-vault/). Enhanced-security storage for keys and secrets that are used by applications.  Key Vault provides secure storage for all resource secrets.
- [Azure Storage](https://azure.microsoft.com/services/storage/). Application storage in the cloud. Provides Azure OpenAI with accessibility to model training artifacts.  Azure Storage provides persistence of AOAI managed artifacts.
- [Azure Event Hub](https://azure.microsoft.com/services/event-hubs/). Event ingestion service that can receive and process events from applications and services. Event Hub provides a scalable event ingestion service for streaming AOAI model completions.
- [Azure Stream Analytics](https://azure.microsoft.com/services/stream-analytics/). Real-time data stream processing from Azure Event Hub. Stream Analytics provides real-time processing of steam messages.
- [Azure Data Explorer](https://azure.microsoft.com/services/data-explorer/). Fast and highly scalable data exploration service for log and telemetry data. Data Explorer can be used to store all logged conversations which are sent in streaming mode from the LLM.
- [Azure SQL Database](https://azure.microsoft.com/services/sql-database/). Managed relational database service that provides a secure, scalable database for storing structured data. Azure SQL DB can be used to store all logged conversations which are sent in streaming mode from the LLM.
- [Microsoft Entra ID](https://azure.microsoft.com/services/active-directory/). Enables user authentication and authorization to the application and to platform services that support the application.  Entra ID provides secure access to all Azure resources which includes using identity based access control.

### Alternatives

Azure OpenAI provides native logging and monitoring as consistent with all Azure AI Service resources. You can use this native functionality to track telemetry of the service, but the default Azure AI Service logging doesn't track or record inputs and outputs of the service, like prompts, tokens, and models. These metrics are especially important for compliance and to ensure that the service operates as expected. Also, by tracking interactions with the language models deployed to Azure OpenAI, you can analyze how your organization is using the service to identify cost and usage patterns that can help inform decisions on scaling and resource allocation.

The following table provides a comparison of the metrics provided by the default Azure OpenAI logging and those provided by this solution.

|Metric |Default Azure OpenAI logging|This solution|
|-|-|-|
|Request count| x| x|
|Data in (size) / data out (size)|  x| x|
|Latency| x |x|
|Token transactions (total)| x| x|
|Caller IP address |x (last octet masked)| x|
|Model utilization || x|
|Token utilization (Prompt/Completion) |x| x|
|Input prompt detail || x |
|Output completion detail|| x |
|Request Parameters |x| x|
|Deployment operations |x |x|
|Embedding operations |x| x|
|Embedding text detail | | x|
|Image generation operations |x | x|
|Image generation prompt detail | | x|
|Speech to Text (STT) operations |x | x|
|Assistants API operations |x | x|
|Assistants API prompt detail | | x|


## Scenario details

Large enterprises that use generative AI models need to implement auditing and logging of the use of these models to ensure responsible use and corporate compliance. This solution provides enterprise-level logging and monitoring for all interactions with AI models to mitigate harmful use of the models and help ensure that security and compliance standards are met. The solution integrates with existing APIs for Azure OpenAI with little modification to take advantage of existing code bases. Administrators can also monitor service usage for reporting.

The solution provides these advantages:

- Comprehensive logging of Azure OpenAI model execution, tracked to the source IP address. Log information includes text that users submit to the model and text received back from the model. This logging helps ensure that models are used responsibly and within the approved use cases of the service.
- High availability of the model APIs to ensure that user requests are met even if the traffic exceeds the limits of a single Azure OpenAI service.
- Role-based access managed via Microsoft Entra ID to ensure that the principle of least privilege is applied.

**Example query for usage monitoring**

```
ApiManagementGatewayLogs
| where OperationId == 'chatcompletions_create'
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

:::image type="content" source="_images/monitor-usage.png" alt-text="Screenshot that shows the output of usage monitoring." lightbox="_images/monitor-usage.png":::

**Example query for prompt usage monitoring**

```
ApiManagementGatewayLogs
| where OperationId == 'chatcompletions_create'
| extend model = tostring(parse_json(BackendResponseBody)['model'])
| extend prompttokens = parse_json(parse_json(BackendResponseBody)['usage'])['prompt_tokens']
| extend prompttext = substring(parse_json(parse_json(BackendResponseBody)['choices'])[0], 0, 100)
```

Output:

:::image type="content" source="_images/prompt-usage.png" alt-text="Screenshot that shows the output of prompt usage monitoring." lightbox="_images/prompt-usage.png":::

### Potential use cases

- Deployment of Azure OpenAI for internal enterprise users to accelerate productivity
- Quota management for token-based Azure OpanAI APIs
- [High availability of Azure OpenAI for internal applications](/azure/architecture/ai-ml/guide/azure-openai-gateway-multi-backend)
- Enhanced-security use of Azure OpenAI within regulated industries

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).

### Reliability
Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Design review checklist for Reliability](/azure/well-architected/reliability/checklist).

This scenario ensures high availability of the language models for your enterprise users. Azure Application Gateway provides an effective layer-7 application delivery mechanism to ensure fast and consistent access to applications. You can use API Management to configure, manage, and monitor access to your models. The inherent high availability of platform services like Storage, Key Vault, and Virtual Network ensure high reliability for your application. Finally, multiple instances of Azure OpenAI ensure service resilience in case of application-level failures. These architecture components can help you ensure the reliability of your application at enterprise scale.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

By implementing best practices for application-level and network-level isolation of your cloud services, this scenario mitigates risks of data exfiltration and data leakage. All network traffic containing potentially sensitive data that's input to the model is isolated in a private network. This traffic doesn't traverse public internet routes. You can use Azure ExpressRoute to further isolate network traffic to the corporate intranet and help ensure end-to-end network security.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

To help you explore the cost of running this scenario, we've preconfigured all the services in the Azure pricing calculator. To learn how the pricing would change for your use case, change the appropriate variables to match your expected traffic.

The following three sample cost profiles provide estimates based on the amount of traffic. (The estimates assume that a conversation contains approximately 1,000 tokens.)

- [Small](https://azure.com/e/98ddb659c31543f0a4e9b95803955aef): For processing 10,000 conversations per month.
- [Medium](https://azure.com/e/53b794faa79740a7aec57dfbafd0eb8c): For processing 100,000 conversations per month.
- [Large](https://azure.com/e/2be9f69894cf45de9683528c23ebaab3): For processing 10 million conversations per month.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Jake Wang](https://www.linkedin.com/in/jake-wang/) | Cloud Solution Architect – AI / Machine Learning
- [Matthew Felton](https://www.linkedin.com/in/matthewfeltonma/) | Cloud Solution Architect – Infrastructure
- [Shaun Callighan](https://www.linkedin.com/in/shauncallighan/) | Technical Specialist – App Innovation

Other contributors:

- [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414/) | Technical Writer

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps
- [Generative AI Gateway](../../../ai-ml/guide/azure-openai-gateway-guide.yml)
- [Azure-Samples/openai-python-enterprise-logging (GitHub)](https://github.com/Azure-Samples/openai-python-enterprise-logging)
- [Configure Azure AI Services virtual networks](/azure/ai-services/cognitive-services-virtual-networks)


## Related resources
- [Azure OpenAI: Documentation, quickstarts, API reference](/azure/ai-services/openai/)
- [Protect APIs with Azure Application Gateway and Azure API Management](../../../web-apps/api-management/architectures/protect-apis.yml)
- [AI architecture design](../../../data-guide/big-data/ai-overview.md)
