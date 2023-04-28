This architecture provides comprehensive logging and monitoring and enhanced security for enterprise deployments of the  Azure OpenAI Service API. It enables advanced logging capabilities for tracking API usage and performance and robust security measures to help protect sensitive data and help prevent malicious activity.

## Architecture

:::image type="content" source="media/openai-monitor-log.png " alt-text="Diagram that shows an architecture that provides monitoring and logging for Azure OpenAI Service." lightbox="media/openai-monitor-log.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/azure-openai-monitor-log.vsdx) of this architecture.*
 
### Workflow

1.	Client applications can access Azure OpenAI Service endpoints to perform text generation (completions) and model training (fine-tuning).
2.	Azure Application Gateway provides a single point of entry to Azure OpenAI models and provides load balancing for APIs.
  
    > [!Note]
    > Load balancing of stateful operations like model fine-tuning, deployments, and inference of fine-tuned models isn't supported.

3.	Azure API Management enables security controls and auditing and monitoring of the Azure OpenAI models.  
   a.	In API Management, enhanced-security access is granted via Azure Active Directory (Azure AD) groups with subscription-based access permissions.  
   b.	Auditing is enabled for all interactions with the models via Azure Monitor request logging.  
   c.	Monitoring enables detailed Azure OpenAI model usage KPIs and metrics, including prompt information and token statistics for usage traceability.
4.	API Management connects to all Azure resources via Azure Private Link. This configuration provides enhanced security for all traffic via private endpoints and contains traffic in the private network.
5.	Multiple Azure OpenAI Service instances enable scale-out of API usage to ensure high availability and disaster recovery for the service.

### Components

- [Application Gateway](https://azure.microsoft.com/services/application-gateway/). Application load balancer to ensure that all users of the Azure OpenAI APIs can get the fastest response and highest throughput for model completions.
- [API Management](https://azure.microsoft.com/services/api-management/). API management platform for accessing back-end Azure OpenAI endpoints. Provides additional monitoring and logging that's not available natively in Azure OpenAI Service.
- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network/). Provides network isolation so all model network traffic is routed privately to the Azure OpenAI Service.
- [Azure OpenAI Service](https://azure.microsoft.com/products/cognitive-services/openai-service/). Service that hosts models and provides generative model completion outputs.
- [Monitor](https://azure.microsoft.com/services/monitor/). Provides access to application logs via Kusto Query Language. Also enables dashboard reports and monitoring and alerting capabilities.
- [Azure Key Vault](https://azure.microsoft.com/services/key-vault/). Provides enhanced-security storage for keys and secrets that are used by applications.
- [Azure Storage](https://azure.microsoft.com/services/storage/). Application storage in the cloud. Provides accessibility to model training artifacts to the Azure OpenAI Service.
- [Azure Active Directory](https://azure.microsoft.com/services/active-directory/)
  - Secure Identity manager on Azure, enables authentication and authorization of users to the application as well as platform services supporting the application.
  - Enable group policies to ensure principle of least privileges is granted for all users.

### Alternatives

Why do I need this solution? Doesn’t the Azure OpenAI service provide logging and monitoring natively?

The short answer is yes, you can track telemetry of the service through the Azure OpenAI service, but the default cognitive service logging supplied does not track or record inputs and outputs of the service such as prompts, tokens, or models. These components are especially important for compliance purposes and to ensure the service operates as expected. Furthermore, by tracking interactions with the Large Language Models deployed to Azure OpenAI you can analyze how your organization is using the service to identify cost and usage patterns which can help inform decisions on scaling and resource allocation.

Logging Comparison Table:

|	|Default Azure OpenAI Logging|Enterprise Azure OpenAI Logging Architecture|
|-|-|-|
|Request Count|	X|	X|
|Data In (size)/ Data Out (size)| 	X|	X|
|Latency|	X	|X|
|Token Transactions (Total)|	X|	X|
|Caller IP Address	|X (last octet masked)|	X|
|Model Utilization	||	X|
|Token Utilization (Input/Output)	||	X|
|Input Prompt Detail	||	X|
|Output Completion Detail||		X|
|Deployment Operations	|X	|X|
|Embedding Operations	|X|	X* (limited to 8192 response chars)|

## Scenario details

For large enterprises that intend to implement Generative AI (Artificial Intelligence) Models, auditing and logging of the usage of these models is paramount to ensure responsible use and corporate compliance. This solution provides enterprise level logging and monitoring for all interactions with the AI Models to mitigate harmful usage of the models and ensure security and compliance standards are met. This solution integrates with existing APIs for Azure OpenAI with little modification to leverage existing code bases.  Additionally, administrators can monitor service usage for reporting purposes.

Key solution advantages:

- Comprehensive logging of Azure OpenAI model execution tracked to Source IP address.  Log information includes what text users are submitting to the model as well as text being received back from the model.  This ensures models are being used responsibly within the corporate environment and within the approved use cases of the service.
- High availability of the model APIs to ensure user requests are met even if the traffic exceeds the limits of a single Azure OpenAI service.
- Secure use of the service by ensuring role-based access managed via Azure Active Directory follows principle of least privilege.

**Example Query for Usage Monitoring:**

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

image 

**Example Query for Prompt Usage:**

```
ApiManagementGatewayLogs
| where OperationId == 'completions_create'
| extend model = tostring(parse_json(BackendResponseBody)['model'])
| extend prompttokens = parse_json(parse_json(BackendResponseBody)['usage'])['prompt_tokens']
| extend prompttext = substring(parse_json(parse_json(BackendResponseBody)['choices'])[0], 0, 100)
```

Output: 

image 

## Potential use cases

- Deployment of Azure OpenAI for internal Enterprise users to accelerate productivity.
- High availability of Azure OpenAI for internal applications
- Secure use of Azure OpenAI within regulated industries.
 
## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

This scenario ensures high availability of the large language models for your enterprise users. The Azure Application Gateway provides an effective layer-7 application delivery mechanism to ensure fast and consistent access to applications. Azure API Management enables you to configure, manage and monitor access to your models. The platform services such as Storage, Key Vault, and Virtual Network ensure high reliability for your application with inherent high availability. Furthermore, multiple instances of the Azure OpenAI service ensure service resilience in the case of application-level failures. With these architecture components, you can ensure reliability of your application at enterprise scale.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

Enterprise security is of the utmost importance in the use of sensitive data for business critical workstreams. By implementing best practices for application and network level isolation of your cloud services, this scenario mitigates risks of data exfiltration and data leakage. All network traffic containing potentially sensitive data input to the model is isolated to a private network and does not traverse public internet routes. In addition, the use of express route services can be used to further isolate the network traffic to corporate intranet and ensure end-to-end network security.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

To explore the cost of running this scenario, all of the services are pre-configured in the cost calculator. To see how the pricing would change for your particular use case, change the appropriate variables to match your expected traffic.

We have provided three sample cost profiles based on amount of traffic (For simplicity we assume a document contains approximately 1000 tokens):

- [Small](https://azure.com/e/c367a7fdf6174ddfb39563d4f835fa14) : this pricing example correlates to processing 10,000 documents a month.
- [Medium](https://azure.com/e/e0581d8d849c48f4beb1cfcf374c1f36) : this pricing example correlates to processing 100,000 documents a month.
- [Large](https://azure.com/e/b1a2c35910ea42f0bf1eed0ea44e27bf) : this pricing example correlates to processing 10m documents tokens a month.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors: 

- [Jake Wang]( https://www.linkedin.com/in/jake-wang/) | Cloud Solution Architect – AI/ Machine Learning
- [Ashish Chauhan]( https://www.linkedin.com/ProfileURL/) | Cloud Solution Architect – Data/AI

line 

## Next steps

The purpose of this document is to showcase a solution for managing and governing the application of the Azure OpenAI service in an Enterprise setting.  The use of the large language models including prompt engineering and model tuning topics are beyond the scope of this document.  Please refer to the following resources for additional information:

•	Azure OpenAI Request Form
•	Best practices for prompt engineering with OpenAI API | OpenAI Help Center
•	Azure OpenAI - Documentation, quickstarts, API reference - Azure Cognitive Services | Microsoft Learn
•	Azure-Samples/openai-python-enterprise-logging (github.com)

## Related resources
-	https://learn.microsoft.com/azure/cognitive-services/cognitive-services-virtual-networks?tabs=portal
-	Protect APIs with Azure Application Gateway and Azure API Management - Azure Reference Architectures | Microsoft Learn
