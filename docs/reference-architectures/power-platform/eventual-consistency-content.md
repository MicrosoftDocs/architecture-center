Strategically create data using an upsert to allow systems to synchronize data. Guarantee that the consuming application will be able to accept requests when the data is awaiting synchronization or when it is missing. This scenario builds eventual consistency in Power Apps, to support Azure Web Apps and other similar scenarios. In addition, you can use various Azure services to replicate data.

## Potential use cases

This pattern can be useful in the following situations:

- The system that sends reference data is down.
- The synchronization of data takes a long time or the process is delayed.
- Consuming systems have no logic on the creation of the entity being created.

## Context and problem

In many modern applications, you must consider and implement fault tolerance. In certain situations, you might synchronize accounts and contacts, for example,  from one instance of Power Platform to another. Suppose you have two instances of Power Platform. "Instance A" synchronizes data to "Instance B" and another system that reads data from "Instance A". It then sends a payload with unique identifiers or alternate keys to "Instance B". When "Instance B" does not have the data, the user receives a bad request because the entity with that record does not exist.

The following examples show the potential journeys for a record submission. 

**Example 1 - Successful path with no outage or transient errors**

![Diagram of an example of a multiple-system synchronization that succeeds.](./_images/data-dependent-example.png)

1. **Instance A** synchronizes a new account to **Instance B**. All are working because no transient faults or outages have occurred.
2. An integrated system reads the master accounts from **Instance A** and intends to submit an API call that references an account that was replicated to **Instance B**. It works because everything was up and no outages or transient faults occurred. An HTTP status of 204 is returned.

**Example 2 - Unsuccessful path where sync is down or delayed**

![Diagram of an example of a multiple-system synchronization that fails.](./_images/data-dependent-example-fails.png)

1. **Instance A** attempts to synchronize a new account to **Instance B**. **Instance B** is unreachable, due to downtime or upgrade.
2. An integrated system reads the master accounts from **Instance A** and intends to submit an API call that references an account that was not replicated to **Instance B**. The API call fails because the account with the given identifier was not created in **Instance B**. 

## Solutions

### Plugin/flow to always upsert based on the GUID or alternate key

This can be performed in a number of plugin steps, within the plugin lifecycle. When the entity that you are creating is mandatory, use the PreValidation step. PreValidation happens before any database transactions are started. It is the preferred option, if the field is mandatory. However, in some scenarios, a PreCreate plugin step will suffice.

![Diagram of a solution with the plugin.](./_images/solution.png)

1. **Instance A** attempts to synchronize a new account to **Instance B**. **Instance B** is unreachable, due to downtime or upgrade.
2. An integrated system reads the master accounts from **Instance A**. It intends to submit an API call that references an account that was not replicated to **Instance B**. As it stands, the API call will fail because the record does not exist, due to the sync not working.
3. A PreValidation/PreCreate plugin performs an upsert on the GUID (updating only the ID and setting the name, if it does not exist). If it exists already, then nothing is changed. If it does not exist, a new account is created (with most of the fields blank).
4. The API call succeeds because the account with the given ID exists in the system. The plugin intercepted the operation and handled the missing record gracefully.

### Circuit breaker

Introduce a circuit breaker pattern to back off and retry. For more information about using a circuit breaker, see [Circuit Breaker Pattern](/azure/architecture/patterns/circuit-breaker).

## Replication technologies

There are multiple ways to replicate data between Dynamics instances, which includes the following:

- Logic Apps
- Function apps in Azure Functions
- Azure Data Factory
- Azure Synapse Analytics
- Power Automate

## Issues and considerations

Consider the impact of any business logic on an entity that is not hydrated yet. Consider a scenario where the entity is not fully hydrated and synchronized yet. Some of the properties will be null, so you need to ensure that any decisions on the data are factored in when using this approach. You may receive a `NullReferenceException` error. 

## When to use this approach

Use this approach in the following scenarios:

- You want to guarantee a record with a given key exists and do not care that the record is not fully hydrated.
- You must accept creation, even if the data is still not synchronized.

This pattern may not be suitable in the following scenario:

- Logic is applied when the record is created. Because the data won't be hydrated, it's not safe to rely on certain properties being available.

## Next steps

- [Power Platform](/power-platform)
- [What is Power Apps?](/powerapps/powerapps-overview)
- [App Service overview](/rest/api/appservice/web-apps)
- [What is Azure Logic Apps?](/azure/logic-apps)
- [Get started with Power Automate](/power-automate/getting-started)

## Related resources

Related architectures:

- [CI/CD for Microsoft Power Platform](/azure/architecture/solution-ideas/articles/azure-devops-continuous-integration-for-power-platform)
- [Citizen AI with the Power Platform](/azure/architecture/example-scenario/ai/citizen-ai-power-platform)
- [Power Automate deployment at scale](/azure/architecture/example-scenario/power-automate/power-automate)

Guidance for Web development:

- [Ten design principles for Azure applications](/azure/architecture/guide/design-principles)
- [Design and implementation patterns](/azure/architecture/patterns/category/design-implementation)
- [App Service deployment best practices](https://docs.microsoft.com/azure/app-service/deploy-best-practices?toc=https%3A%2F%2Fdocs.microsoft.com%2Fen-us%2Fazure%2Farchitecture%2Ftoc.json&bc=https%3A%2F%2Fdocs.microsoft.com%2Fen-us%2Fazure%2Farchitecture%2Fbread%2Ftoc.json) 
- [Microsoft Azure Well-Architected Framework](/azure/architecture/framework)
