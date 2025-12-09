Monitoring workloads that include Azure OpenAI Service involves enabling diagnostics for Azure OpenAI and using preconfigured dashboards. However, this strategy doesn't satisfy several common, more complex, organizational monitoring requirements for generative AI workloads, such as:

- [Tracking usage by client and model to manage quotas and implement chargeback solutions](#track-model-usage).

- [Logging model inputs and model outputs for various auditing use cases and monitoring model performance](#audit-model-inputs-and-outputs).

- [Running near real-time monitoring](#near-real-time-monitoring).

> [!NOTE]
> For more information about how to monitor Azure OpenAI directly, see [Monitor Azure OpenAI](/azure/ai-services/openai/how-to/monitor-openai).

The following diagram illustrates the monitoring of Azure OpenAI instances without a gateway. A gateway isn't required for this topology. Your decision to include a gateway depends on whether the outlined monitoring scenarios are part of your requirements. This article examines the challenges that each monitoring scenario addresses, along with the benefits and costs of incorporating a gateway for each scenario.

:::image type="complex" border="false" source="_images/tracking-multiple-models-before.svg" alt-text="Architecture diagram of a scenario that has multiple clients connecting directly to more than one model deployment across multiple instances of Azure OpenAI." lightbox="_images/tracking-multiple-models-before.svg":::
   A diagram that shows two clients labeled A and B directly interfacing with model deployments in two Azure OpenAI instances. Client A directly accesses a gpt-35-turbo deployment and a gpt-4-o deployment in the same Azure OpenAI instance. Client B accesses the gpt-4o deployment in the first Azure OpenAI instance and accesses a gpt-4 deployment in a second Azure OpenAI instance. Client B also shows a dashed line that connects to a gpt-4o instance in the second Azure OpenAI deployment. Both Azure OpenAI instances pass Azure OpenAI metrics and logs to Azure Monitor.
:::image-end:::

## Track model usage

Many workloads or organizations need to track the usage of Azure OpenAI models by both clients and models across all Azure OpenAI instances. They use this information to:

- Implement a chargeback system where they allocate usage costs to the appropriate organization or application owner.

- Budget and forecast for future usage.

- Tie modal cost and usage to model performance.

You can use the native Azure OpenAI monitoring functionality to track telemetry of the service, but there are challenges.

- For chargeback models, you must be able to associate the Azure OpenAI token usage metrics with an application or business unit. Azure OpenAI telemetry includes a calling IP address with the last octet masked. This masking might make establishing this association to an application or business unit challenging.

- Azure OpenAI instances in various regions likely record logs to Azure Monitor instances within their respective local regions. This process requires you to aggregate logs from different Azure Monitor instances to track usage across all Azure OpenAI instances.

### Introduce a gateway to track model usage

:::image type="complex" border="false" source="_images/tracking-multiple-models-after.svg" alt-text="Architecture diagram of a scenario that has multiple clients connecting to more than one model deployment across multiple instances of Azure OpenAI through a gateway." lightbox="_images/tracking-multiple-models-after.svg":::
   A diagram that shows two clients labeled A and B directly interfacing with a gateway. The gateway has two arrows that point to private endpoints. The first private endpoint has two solid arrows that point to a gpt-35-turbo deployment and a gpt-4o deployment in an Azure OpenAI deployment. The second private endpoint has a solid arrow that points to a gpt-4 deployment and a dashed line that points to a gpt-4o deployment in a second Azure OpenAI instance. Both Azure OpenAI instances pass Azure OpenAI metrics and logs to Azure Monitor. The gateway has an arrow that points to Azure Monitor that shows it passing usage metrics, including client IP address, model, and token data.
:::image-end:::

Introduce a gateway into this topology to capture the full client IP address, the Microsoft Entra ID (or alternative identity) of the client, or a custom identifier for a business unit, a tenant, or an application in one place. You can then use this data to implement a chargeback solution for budgeting and forecasting and to run cost-benefit analyses of models.

The following examples show usage queries that are possible when you use Azure API Management as a gateway.

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

:::image type="complex" source="_images/monitor-usage.png" alt-text="A screenshot that shows the output of usage monitoring." lightbox="_images/monitor-usage.png":::
   A screenshot that shows the output of usage monitoring. It shows a table that has five columns and five rows. The columns represent the IP address, model, and three types of tokens. These tokens are the total number of tokens used in the input prompt, the total number of tokens generated by the model in response to the prompt, and the combined total of both prompt tokens and completion tokens.
:::image-end:::

#### Example query for prompt usage monitoring

```kusto
ApiManagementGatewayLogs
| where tolower(OperationId) in ('completions_create','chatcompletions_create')
| extend model = tostring(parse_json(BackendResponseBody)['model'])
| extend prompttokens = parse_json(parse_json(BackendResponseBody)['usage'])['prompt_tokens']
| extend prompttext = substring(parse_json(parse_json(BackendResponseBody)['choices'])[0], 0, 100)
```

Output:

:::image type="complex" source="_images/prompt-usage.png" alt-text="A screenshot that shows the output of prompt usage monitoring." lightbox="_images/prompt-usage.png":::
   A screenshot that shows the output of usage monitoring. It shows a table that has four columns and seven rows. The columns represent the time generated in UTC, the model, the prompt tokens, and the prompt text.
:::image-end:::

## Audit model inputs and outputs

Central to many auditing requirements for generative AI workloads is monitoring the input and output of the models. You might need to know whether a response was from a model or sourced from a cache. There are multiple use cases for monitoring both inputs and outputs of models. In most scenarios, auditing rules should be applied uniformly across all models for both inputs and outputs.

The following use cases are for monitoring the inputs to models.

- **Threat detection:** Analyze inputs to identify and mitigate potential security risks.

- **Usage guidelines violation detection:** Analyze inputs for offensive language or other usage standards to ensure that the system is professional, safe, and unbiased.

- **Model performance:** Combine with model outputs to evaluate performance on metrics like groundedness and relevance. You can use this information to address performance problems with the model or prompts.

The following are some of the use cases for monitoring the outputs to models.

- **Data exfiltration detection:** Analyze outputs to guard against unauthorized transfer of sensitive information.

- **Stateful compliance:** Monitor outputs over multiple interactions within the same conversation to detect stealthy leaks of sensitive information.

- **Compliance:** Ensure that outputs adhere to corporate guidelines and regulatory requirements. Two examples are that models don't provide legal advice or make financial promises.

- **Model performance:** Combine with model inputs to evaluate performance on metrics like groundedness and relevance. You can use this information to address performance problems with the model or prompts.

### Challenges to auditing model inputs and outputs directly from the model

- **Model logging constraints:** Some services such as Azure OpenAI don't log model inputs and outputs.

- **Cache:** More complex architectures might serve responses from cache. In those scenarios, the model isn't called and doesn't log the input or output.

- **Stateful conversations:** The state of a multiple-interaction conversation might be stored outside the model. The model doesn't know which interactions should be correlated as a conversation.

- **Multiple-model architecture:** The orchestration layer might dynamically invoke multiple models to generate a final response.

### Introduce a gateway for auditing model inputs and outputs

:::image type="complex" border="false" source="_images/tracking-multiple-models-inputs-outputs.svg" alt-text="Architecture diagram of a scenario with multiple clients connecting to more than one model deployment across multiple instances of Azure OpenAI through a gateway. The gateway logs inputs and outputs." lightbox="_images/tracking-multiple-models-inputs-outputs.svg":::
   A diagram that shows two clients labeled A and B directly interfacing with a gateway. The gateway has two arrows that point to private endpoints. The first private endpoint has two solid arrows that point to a gpt-35-turbo deployment and a gpt-4o deployment in an Azure OpenAI deployment. The second private endpoint has a solid arrow that points to a gpt-4 deployment and a dashed line that points to a gpt-4o deployment in a second Azure OpenAI instance. Both Azure OpenAI instances are shown passing Azure OpenAI metrics and logs to Azure Monitor. The gateway has an arrow that points to Azure Monitor that shows it passing inputs and outputs.
:::image-end:::

Introduce a gateway into this topology to capture both the original input directly from the client and the final output returning to the client. Because the gateway is an abstraction between the client and the models and directly receives the request from the clients, the gateway is in a position to log that raw, unprocessed request. Likewise, because the gateway is the resource that returns the final response to the client, it's also able to log that response.

The gateway has the unique capability to log both the client's request and the final response that it received. This feature applies whether the response came directly from a model, was aggregated from multiple models, or was retrieved from cache. Further, if the clients pass a conversation identifier, the gateway can log that identifier with the input and output. You can use this implementation to correlate multiple interactions of a conversation.

Monitoring inputs and outputs at the gateway allows you to apply auditing rules uniformly across all models.

## Near real-time monitoring

Azure Monitor isn't optimized for near real-time processing because of the inherent [latency in log data ingestion](/azure/azure-monitor/logs/data-ingestion-time#average-latency). If your solution requires near real-time processing of traffic, you can consider a design where you publish logs directly to a message bus and use a stream processing technology, such as Azure Stream Analytics, to run windowed operations.

:::image type="complex" border="false" source="_images/tracking-multiple-models-inputs-outputs-bus.svg" alt-text="Architecture diagram of a scenario that has multiple clients connecting to more than one model deployment across multiple instances of Azure OpenAI through a gateway. The gateway logs inputs and outputs to a message bus." lightbox="_images/tracking-multiple-models-inputs-outputs-bus.svg":::
   A diagram that shows two clients labeled A and B directly interfacing with a gateway. The gateway has two arrows that point to private endpoints. The first private endpoint has two solid arrows that point to a gpt-35-turbo deployment and a gpt-4o deployment in an Azure OpenAI deployment. The second private endpoint has a solid arrow that points to a gpt-4 deployment and a dashed line that points to a gpt-4o deployment in a second Azure OpenAI instance. Both Azure OpenAI instances are shown passing Azure OpenAI metrics and logs to Azure Monitor. The gateway has an arrow that points to Azure Monitor that shows it passing inputs and outputs. The gateway has another arrow that points to a message bus. The message bus has arrows that point to blob storage and to a stream processor.
:::image-end:::

## Considerations when introducing a gateway for monitoring

- **Latency:** Introducing a gateway into your architecture adds latency to your responses. You need to ensure that the observability benefits outweigh the performance implications.

- **Security and privacy:** Ensure that the monitoring data gathered by using the gateway continues to adhere to customer privacy expectations. Observability data must adhere to the established security and privacy expectations of the workload and not violate any customer privacy standards. Continue to treat any sensitive data captured through monitoring as sensitive data.

- **Reliability:** Determine whether the monitoring function is crucial to the functionality of the workload. If it is, the entire application should be down when the monitoring system is unavailable. If it isn't crucial, the application should continue to work in an unmonitored state if the monitoring system is down. Understand the risks of adding a new single point of failure, either through service faults or human-caused configuration problems in the gateway.

- **Implementation:** Your implementation can take advantage of out-of-the-box gateways like API Management, including all the required configurations. Another common approach is to implement an orchestration layer through code.

## Reasons to avoid introducing a gateway for monitoring

If a single application accesses a single model, the added complexity of introducing a gateway likely outweighs the benefits of monitoring. The client can handle the responsibility of logging inputs and outputs. And you can take advantage of native logging capabilities of the model or service that you use. The gateway becomes beneficial when you have multiple clients or multiple models that you need to monitor.

## Next steps

A gateway implementation for your workload provides benefits beyond the tactical, multiple back-end routing benefit described in this article. For more information, see [Access Azure OpenAI and other language models through a gateway](./azure-openai-gateway-guide.yml#key-challenges).

## Related resources

- [Design a well-architected AI workload](/azure/well-architected/ai/get-started)
- [API gateway in API Management](/azure/api-management/api-management-gateways-overview)
