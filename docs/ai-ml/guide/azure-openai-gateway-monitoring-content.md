Monitoring workloads that involve Azure OpenAI Service can be as simple as enabling diagnostics for the Azure OpenAI Service and using pre-configured dashboards. However, this strategy does not meet some common, more complex, organizational monitoring requirements for generative AI workloads. One such requirement for organizations that have multiple client applications and/or are consuming multiple Azure OpenAI models is to be able to track usage by client, by model for use in implementing chargeback solutions or for quota management. Another common monitoring requirement for generative AI workloads involves logging model inputs and model outputs for a variety of auditing use cases and monitoring model performance.

> ![INFORMATION]
> For more information on basic monitoring of Azure OpenAI, see [Monitor Azure OpenAI](https://learn.microsoft.com/en-us/azure/ai-services/openai/how-to/monitor-openai)

The following diagram illustrates monitoring Azure OpenAI instances without a gateway. You don't need the use of a gateway with this topology. The choice of a gateway depends on whether the monitoring scenarios outlined below are part of your requirements. This article describes the challenges each monitoring scenario addresses, and the benefits and costs of including a gateway for each scenario.

:::image type="complex" source="_images/tracking-multiple-models-before.svg" alt-text="Architecture diagram of a scenario with multiple clients connecting directly to more than one model deployment across multiple instances of Azure OpenAI." lightbox="_images/tracking-multiple-models-before.svg":::
   A diagram showing two clients labeled A and B directly interfacing with model deployments in two Azure OpenAI instances. Client A is directly accessing a gpt-35-turbo deployment and a gpt-4-o deployment in the same Azure OpenAI instance. Client B is accessing the gpt-4o deployment in the first Azure OpenAI instance and is accessing a gpt-4 deployment in a second Azure OpenAI instance. Client B also shows a dashed line connecting to a gpt-4o instance in the second Azure OpenAI deployment. Both Azure OpenAI instances are shown passing Azure OpenAI metrics and logs to Azure Monitor.
:::image-end:::

## Tracking model usage

Many organizations need to track the usage of Azure OpenAI models by client and by model across all Azure OpenAI instances. They use this information for the following purposes:

- Implementing a chargeback system where they allocate usage costs to the appropriate organization or application owner
- Budgeting and forecasting for future usage
- Tie modal cost and usage to model performance

You can use the native Azure OpenAI monitoring functionality to track telemetry of the service, but there are challenges.

- For chargeback models, you must be able to associate the Azure OpenAI token usage metrics with an application or organization. Azure OpenAI telemetry contains a calling IP with the last octet masked which might be challenging to associate to an organization or application.
- Azure OpenAI instances in different regions will likely log to Azure Monitor instances in the local region. This requires you to aggregate logs from different Azure Monitor instances to track usage across all Azure OpenAI instances.

### Introduce a gateway to track model usage

:::image type="complex" source="_images/tracking-multiple-models-after.svg" alt-text="Architecture diagram of a scenario with multiple clients connecting to more than one model deployment across multiple instances of Azure OpenAI through a gateway." lightbox="_images/tracking-multiple-models-after.svg":::
   A diagram that shows two clients labeled A and B directly interfacing with a gateway. The gateway has two arrows that points to private endpoints. The first private endpoint has two solid arrows that point to a gpt-35-turbo deployment and a gpt-4o deployment in an Azure OpenAI deployment. The second privat endpoint has a solid arrow pointing to a gpt-4 deployment and a dashed line pointing to a gpt-4o deployment in a second Azure OpenAI instance. Both Azure OpenAI instances are shown passing Azure OpenAI metrics and logs to Azure Monitor. The gateway has an arrow pointing to Azure Monitor that shows it passing usage metrics including Client IP, Model, and Token data.
:::image-end:::

Introducing a gateway into this topology allows you to capture the full IP address, the Entra ID of the caller, or a custom identifier for an organization or an application in one place. This data can then be used to implement a chargeback solution, for budgeting and forecasting, and to perform cost/benefit analyses of models.

The following are examples of usage queries that are possible when using Azure API Management (APIM) as a gateway.

### Example query for usage monitoring

```
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

### Example query for prompt usage monitoring

```
ApiManagementGatewayLogs
| where tolower(OperationId) in ('completions_create','chatcompletions_create')
| extend model = tostring(parse_json(BackendResponseBody)['model'])
| extend prompttokens = parse_json(parse_json(BackendResponseBody)['usage'])['prompt_tokens']
| extend prompttext = substring(parse_json(parse_json(BackendResponseBody)['choices'])[0], 0, 100)
```

Output:

:::image type="content" source="_images/prompt-usage.png" alt-text="A screenshot that shows the output of prompt usage monitoring." lightbox="_images/prompt-usage.png":::

