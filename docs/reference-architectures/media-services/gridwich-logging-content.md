

Best practices for logging include:

- Don't use string formatting or interpolation. Logging a string with `$"This broke {brokenThing}"` isn't useful for debugging.

- Pass objects so that they become searchable fields.

  Instead of `LogInformation(LogEventIds.StartProcessing, $"Processing has started on item {Item.itemNumber}");`, use:

  - An object as such, like `LogInformationObject(LogEventIds.StartProcessing, Item);`, or
  - Anonymous objects, like `LogInformationObject(LogEventIds.StartProcessing, new {Item.itemNumber, Item.itemDescription, someData});`.

- Follow the EventId numbering conventions outlined in [LogEventIds](https://github.com/mspnp/gridwich/blob/main/src/Gridwich.Core/src/Constants/LogEventIds.cs).

- For any significant body of work, use the following logging pattern:

  - Use `LogInformationObject` on entry, for example when about to start an encode job.
  - Use `LogInformationObject` on success, for example when the encode job is successful.
  - Use `LogWarningObject`, `LogErrorObject`, or `LogCriticalObject` on failure, for example if the encoding job fails. Use Exception method variants if applicable.

- Although you can log any information at any stage, don't pollute logs with extraneous noise.

## ObjectLogger

[ObjectLogger](https://github.com/mspnp/gridwich/blob/main/src/Gridwich.Core/src/ObjectLogger.cs) with [IObjectLogger](https://github.com/mspnp/gridwich/blob/main/src/Gridwich.Core/src/Interfaces/IObjectLogger.cs) is a small wrapper utility for the standard Logger/ILogger. This one-liner utility logs any C# object by converting C# objects to dictionary objects that the logger can consume.

ObjectLogger/IObjectLogger restricts use of logger methods that don't have `EventIds` by using an adapter pattern, rather than inheritance. This restriction forces developers to use `EventIds`, which are useful for debugging.

Other recommendations for using ObjectLogger include:

- Don't bypass IObjectLogger by using ILogger.
- Use IObjectLogger with the proper type for your class: `IObjectLogger<myClass>`.
- In any exception handling catch block, use the IObjectLogger methods that include exceptions. Logging providers like Application Insights can use the exception information.

## Logging schema and data

The underlying Event Grid runtime infrastructure provides a base schema. The [Event Grid event schema](/azure/event-grid/event-schema) includes the event time, device of origin, severity level, and string message. Logger/ILogger default custom properties include `EventId`, `Category`, and `RequestPath`.

## Context objects

To work with complex APIs and workflows that require several inputs and outputs, you can create a *context object*, which is a property bag of important variables that your code can pass or generate. Context objects can deal with many parameters, and method signatures don't need to change when you add or remove parameters. You can also pass context objects to the logger and other interfaces as a unit.

For example, instead of:

```csharp
var store = new StorageBlob();
var tier = req.Query["tier"];
var result = await store.SetBlobStorageTier(blobName, tier);
logger.LogInformationObject(LogEventIds.setBlobProperties, result);
```

You can code:

```csharp
var storageContext = new StorageContext();
storageContext.Store = new StorageBlob();
storageContext.Tier = req.Query["tier"];
storageContext.Result = await store.SetBlobStorageTier(blobName, storageContext.Tier);
logger.LogInformationObject(LogEventIds.setBlobProperties, storageContext);
```

## Log levels

Assigning the appropriate logging level may not be straightforward. The following general descriptions of log levels is from [LogLevel Enum](/dotnet/api/microsoft.extensions.logging.loglevel).

| **LogLevel** | **Enum** | **Description** |
| -------- | -------- | -------- |
|LogTrace|0|Contains the most detailed messages and may contain sensitive application data. These messages are turned off by default and shouldn't be turned on in a production environment.|
|LogDebug| 1|Used for interactive investigation during development. These logs primarily contain information that is useful for debugging and have no long-term value.|
|LogInformation| 2|Tracks the general flow of the application. These logs should have long-term value.|
|LogWarning| 3|Highlights an abnormal or unexpected event in the application flow, but doesn't stop application execution.
|LogError| 4|Logs when the current flow of execution is stopped due to a failure. These logs should indicate failures in the current activity, not an application-wide failure.|
|LogCritical| 5|Describes an unrecoverable application or system crash, or a catastrophic failure that requires immediate attention.
|LogNone| 6| Not used for writing log messages. Specifies that a logging category should not write any messages.|

## Next steps

Product documentation:

- [Gridwich cloud media system](gridwich-architecture.yml)
- [Azure Storage analytics logging](/azure/storage/common/storage-analytics-logging)

Microsoft Learn modules:

- [Configure blob storage](/learn/modules/configure-blob-storage)
- [Explore Azure Storage services](/learn/modules/azure-storage-fundamentals)

## Related resources

- [Gridwich operations for Azure Storage](gridwich-storage-service.yml)
- [Gridwich project naming and namespaces](gridwich-project-names.yml)
- [Gridwich request-response messages](gridwich-message-formats.yml)
