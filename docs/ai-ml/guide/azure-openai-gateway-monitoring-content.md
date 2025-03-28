Monitoring workloads that involve Azure OpenAI Service can be as simple as enabling diagnostics for the Azure OpenAI Service and using preconfigured dashboards. However, this strategy doesn't meet some common, more complex, organizational monitoring requirements for generative AI workloads, such as the following:

- [Track usage by client and model to manage quotas and implement chargeback solutions](#tracking-model-usage)
- [Log model inputs and model outputs for various auditing use cases and monitoring model performance](#auditing-model-inputs-and-outputs)
- [Perform near real-time monitoring](#near-real-time-monitoring)

> [!NOTE]
> For more information on monitoring Azure OpenAI directly, see [Monitor Azure OpenAI](/azure/ai-services/openai/how-to/monitor-openai).

The following diagram illustrates monitoring Azure OpenAI instances without a gateway. You don't need the use of a gateway with this topology. The choice of a gateway depends on whether the outlined monitoring scenarios are part of your requirements. This article describes the challenges each monitoring scenario addresses, and the benefits and costs of including a gateway for each scenario.

:::image type="complex" source="_images/tracking-multiple-models-before.svg" alt-text="Architecture diagram of a scenario with multiple clients connecting directly to more than one model deployment across multiple instances of Azure OpenAI." lightbox="_images/tracking-multiple-models-before.svg":::
   A diagram showing two clients labeled A and B directly interfacing with model deployments in two Azure OpenAI instances. Client A is directly accessing a gpt-35-turbo deployment and a gpt-4-o deployment in the same Azure OpenAI instance. Client B is accessing the gpt-4o deployment in the first Azure OpenAI instance and is accessing a gpt-4 deployment in a second Azure OpenAI instance. Client B also shows a dashed line connecting to a gpt-4o instance in the second Azure OpenAI deployment. Both Azure OpenAI instances are shown passing Azure OpenAI metrics and logs to Azure Monitor.
:::image-end:::

## Tracking model usage

Many workloads or organizations need to track the usage of Azure OpenAI models by client and by model across all Azure OpenAI instances. They use this information for the following purposes:

- Implementing a chargeback system where they allocate usage costs to the appropriate organization or application owner
- Budgeting and forecasting for future usage
- Tie modal cost and usage to model performance

You can use the native Azure OpenAI monitoring functionality to track telemetry of the service, but there are challenges.

- For chargeback models, you must be able to associate the Azure OpenAI token usage metrics with an application or business unit. Azure OpenAI telemetry contains a calling IP with the last octet masked which might be challenging to associate to an application or business unit.
- Azure OpenAI instances in different regions likely log to Azure Monitor instances in the local region. This requires you to aggregate logs from different Azure Monitor instances to track usage across all Azure OpenAI instances.

### Introduce a gateway to track model usage

:::image type="complex" source="_images/tracking-multiple-models-after.svg" alt-text="Architecture diagram of a scenario with multiple clients connecting to more than one model deployment across multiple instances of Azure OpenAI through a gateway." lightbox="_images/tracking-multiple-models-after.svg":::
   A diagram that shows two clients labeled A and B directly interfacing with a gateway. The gateway has two arrows that points to private endpoints. The first private endpoint has two solid arrows that point to a gpt-35-turbo deployment and a gpt-4o deployment in an Azure OpenAI deployment. The second private endpoint has a solid arrow pointing to a gpt-4 deployment and a dashed line pointing to a gpt-4o deployment in a second Azure OpenAI instance. Both Azure OpenAI instances are shown passing Azure OpenAI metrics and logs to Azure Monitor. The gateway has an arrow pointing to Azure Monitor that shows it passing usage metrics including Client IP, Model, and Token data.
:::image-end:::

Introducing a gateway into this topology allows you to capture the full client IP address, the Entra ID (or alternative identity) of the client, or a custom identifier for a business unit, tenant, or an application in one place. This data can then be used to implement a chargeback solution, for budgeting and forecasting, and to perform cost/benefit analyses of models.

The following are examples of usage queries that are possible when using Azure API Management (APIM) as a gateway.

#### Example query for usage monitoring

```kusto
ApiManagementGatewayLogs
| where tolower(OperationId) in ('completions_create','chatcompletions_create')
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

:::image type="content" source="_images/monitor-usage.png" alt-text="A screenshot that shows the output of usage monitoring." lightbox="_images/monitor-usage.png":::

#### Example query for prompt usage monitoring

```kusto
ApiManagementGatewayLogs
| where tolower(OperationId) in ('completions_create','chatcompletions_create')
| extend model = tostring(parse_json(BackendResponseBody)['model'])
| extend prompttokens = parse_json(parse_json(BackendResponseBody)['usage'])['prompt_tokens']
| extend prompttext = substring(parse_json(parse_json(BackendResponseBody)['choices'])[0], 0, 100)
```

Output:

:::image type="content" source="_images/prompt-usage.png" alt-text="A screenshot that shows the output of prompt usage monitoring." lightbox="_images/prompt-usage.png":::

## Auditing model inputs and outputs

Central to many auditing requirements for generative AI workloads is monitoring the input and output of the models. You may further need to know whether a response was from a model, or whether the response was sourced from a cache. There are many use cases for monitoring both inputs and outputs of models. In most cases, auditing rules should be applied uniformly across all models for both inputs and outputs.

**Inputs** - The following are some of the use cases for monitoring the inputs to models:

- Threat detection - analyze inputs to identify and mitigate potential security risks.
- Usage guidelines violation detection - analyze inputs for offensive language or other usage standards to ensure the system is professional, safe, and unbiased.
- Model performance - Combining with model outputs to evaluate performance on metrics like groundedness and relevance. This information can be used to address performance issues with the model or prompts.

**Outputs** - The following are some of the use cases for monitoring the outputs to models:

- Data exfiltration detection - Analyze outputs to guard against unauthorized transfer of sensitive information.
- Stateful compliance - Monitor outputs over multiple interactions within the same conversation to detect stealthy leaks of sensitive information.
- Compliance - Ensure outputs adhere to corporate guidelines and regulatory requirements. Some examples include ensuring models don't provide legal advice or make financial promises.
- Model performance - Combining with model inputs to evaluate performance on metrics like groundedness and relevance. This information can be used to address performance issues with the model or prompts.

### Challenges to auditing model inputs and outputs directly from the model

- Model logging constraints - Some services such as Azure OpenAI don't log model inputs and outputs.
- Cache - More complex architectures may serve responses from cache. In those cases, the model isn't called and doesn't log either the input or output.
- Stateful conversations - The state of a multi-interaction conversation may be stored outside the model. The model doesn't know which interactions should be correlated as a conversation.
- Multi model architecture - The orchestration layer may dynamically invoke multiple models to generate a final response.

### Introduce a gateway for auditing model inputs and outputs

:::image type="complex" source="_images/tracking-multiple-models-inputs-outputs.svg" alt-text="Architecture diagram of a scenario with multiple clients connecting to more than one model deployment across multiple instances of Azure OpenAI through a gateway with the gateway logging inputs and outputs." lightbox="_images/tracking-multiple-models-inputs-outputs.svg":::
   A diagram that shows two clients labeled A and B directly interfacing with a gateway. The gateway has two arrows that points to private endpoints. The first private endpoint has two solid arrows that point to a gpt-35-turbo deployment and a gpt-4o deployment in an Azure OpenAI deployment. The second private endpoint has a solid arrow pointing to a gpt-4 deployment and a dashed line pointing to a gpt-4o deployment in a second Azure OpenAI instance. Both Azure OpenAI instances are shown passing Azure OpenAI metrics and logs to Azure Monitor. The gateway has an arrow pointing to Azure Monitor that shows it passing inputs and outputs.
:::image-end:::

Introducing a gateway into this topology allows you to capture both the original input directly from the client and final output returning to the client. Because the gateway is an abstraction between the client and the models and directly receives the request from the clients, the gateway is in a position to log that raw, unprocessed request. Likewise, because the gateway is the resource that returns the final response to the client, it's able to log that response as well.

The gateway is uniquely able to log both what the client asked for and what it ultimately received, regardless of whether the response was the raw response from a model, the response was an aggregated response from multiple models, or the response was served from cache. Further, if the clients pass a conversation identifier, the gateway can log that identifier with the input and output. This implementation allows you to correlate multiple interactions of a conversation.

Monitoring inputs and outputs at the gateway allows you to apply auditing rules uniformly across all models.

## Near real-time monitoring

Azure Monitor wasn't designed for near real-time processing. The [average latency to ingest log data in Azure Monitor ](/azure/azure-monitor/logs/data-ingestion-time#average-latency) precludes this. If your solution requires near real-time processing of traffic, you can consider a design where you publish logs directly to a message bus and use a stream processing technology, such as Azure Stream Analytics, to perform windowed operations.

:::image type="complex" source="_images/tracking-multiple-models-inputs-outputs-bus.svg" alt-text="Architecture diagram of a scenario with multiple clients connecting to more than one model deployment across multiple instances of Azure OpenAI through a gateway with the gateway logging inputs and outputs to a message bus." lightbox="_images/tracking-multiple-models-inputs-outputs-bus.svg":::
   A diagram that shows two clients labeled A and B directly interfacing with a gateway. The gateway has two arrows that points to private endpoints. The first private endpoint has two solid arrows that point to a gpt-35-turbo deployment and a gpt-4o deployment in an Azure OpenAI deployment. The second private endpoint has a solid arrow pointing to a gpt-4 deployment and a dashed line pointing to a gpt-4o deployment in a second Azure OpenAI instance. Both Azure OpenAI instances are shown passing Azure OpenAI metrics and logs to Azure Monitor. The gateway has an arrow pointing to Azure Monitor that shows it passing inputs and outputs. The gateway has another arrow pointing to a message bus. The message bus has arrows pointing to blob storage and to a stream processor.
:::image-end:::

## Recommendations and considerations when introducing a gateway for monitoring

- **Latency** - Introducing a gateway into your architecture adds other latency to your responses. You need to ensure that the observability benefits you see outweigh the performance implications.
- **Security and privacy** - You must ensure that the monitoring data gathered by using the gateway continues to adhere to customer privacy expectations. Observability data must adhere to the established security and privacy expectations of the workload, without violating any customer privacy standards. You must continue to treat any sensitive data captured through monitoring as sensitive data.
- **Reliability** - You must determine whether the monitoring function is critical to the functionality of the workload. If it's, The application as a whole should be down when the monitoring system is unavailable. If it isn't critical, the application should continue to work in an unmonitored state if the monitoring system is down. Also, understand the risks of adding a new single point of failure either through service faults or human-caused configuration issues in the gateway.
- **Implementation** - Your implementation can take advantage of out-of-the-box gateways like Azure API Management, including all the required configuration. Another common implementation is through implementing an orchestration layer through code.

## Reasons to avoid introducing a gateway for monitoring

If a single application is accessing a single model, the added complexity of adding a gateway likely outweighs the monitoring benefits. The client can handle the responsibility of logging inputs and outputs and you can take advantage of native logging capabilities of the model or service you're using. The gateway becomes beneficial when you have multiple clients and/or multiple models that you need to monitor.

## Next steps

Having a gateway implementation for your workload provides benefits beyond the tactical multiple back end routing benefit described in this article. Learn about the other [key challenges](./azure-openai-gateway-guide.yml#key-challenges) a gateway can solve.

## Related resources

- [Azure OpenAI Service](/azure/well-architected/service-guides/azure-openai)
- [Design a well-architected AI workload](/azure/well-architected/ai/get-started)
- [API gateway in Azure API Management](/azure/api-management/api-management-gateways-overview)