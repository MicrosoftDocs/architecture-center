---
title: Logging in Gridwich
titleSuffix: Azure Reference Architectures
description: Understand the importance of logging and use of the ObjectLogger utility, context objects, and logging levels.
author: doodlemania2
ms.date: 10/08/2020
ms.topic: reference-architecture
ms.service: architecture-center
ms.subservice: reference-architecture
ms.custom:
- fcp
---


# Logging in Gridwich

Best practices for logging include:

- Don't use string formatting or interpolation. Logging a string with `$"This broke {brokenThing}"` isn't useful for debugging. Pass objects so that they become searchable fields. Instead of `LogInformation(LogEventIds.StartProcessing, $"Processing has started on item {Item.itemNumber}");`, use an object as such `LogInformationObject(LogEventIds.StartProcessing, Item);`, or anonymous objects like `LogInformationObject(LogEventIds.StartProcessing, new {Item.itemNumber, Item.itemDescription, someData});`.
  
- Follow the EventId numbering conventions outlined in [LogEventIds]().
  
- For any significant body of work, use the following logging pattern:
  
  - `LogInformationObject` on entry, for example when about to start an encode job
  - `LogInformationObject` on success, for example when the encode job is successful
  - `LogWarningObject`, `LogErrorObject`, or `LogCriticalObject` on failure, for example encode job failure. Use Exception method variants if applicable.
  
- Although you can log any information at any stage that you think important, you should also take care not to pollute logs with extraneous noise.

## ObjectLogger

ObjectLogger/IObjectLogger is a small utility that wraps the standard Logger/ILogger. This one-liner utility logs any C# object by converting C# objects to dictionary objects that the logger can consume.

ObjectLogger/IObjectLogger forces developers to use EventIds in their logging by using an adapter pattern, not inheritance, to restrict use of logger methods that don't have EventIds. EventIds are useful for debugging the service.

- Don't bypass IObjectLogger by using ILogger.
- Use IObjectLogger with the proper type for your class: `IObjectLogger<myClass>`.
- In any exception handling catch block, use the IObjectLogger methods that include exceptions. Logging providers like Application Insights can use the exception information.

## Logging schema and data

The underlying Event Grid runtime infrastructure provides a base schema including event time, device of origin, severity level, and string message. Logger/ILogger default custom properties include EventId, Category, and RequestPath.

## Context objects

When working with complex APIs and workflows that require several inputs and outputs, you can create a *context object*, which is a property bag of important variables that your code can pass or generate. Context objects can deal with many parameters, and method signatures don't need to change when adding or removing parameters from the context object. Context objects can also be passed to the logger and other interfaces as a unit.

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
|LogTrace|0|Contains the most detailed messages and may contain sensitive application data. These messages are disabled by default and shouldn't be enabled in a production environment.|
|LogDebug| 1|Used for interactive investigation during development. These logs primarily contain information useful for debugging and have no long-term value.|
|LogInformation| 2|Tracks the general flow of the application. These logs should have long-term value.|
|LogWarning| 3|Highlights an abnormal or unexpected event in the application flow, but doesn't stop application execution.
|LogError| 4|Logs when the current flow of execution is stopped due to a failure. These logs should indicate failures in the current activity, not an application-wide failure.|
|LogCritical| 5|Describes an unrecoverable application or system crash, or a catastrophic failure that requires immediate attention.
|LogNone| 6| Not used for writing log messages. Specifies that a logging category should not write any messages.|

