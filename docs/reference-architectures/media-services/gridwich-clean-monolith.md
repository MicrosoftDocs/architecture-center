---
title: Gridwich clean monolith architecture
titleSuffix: Azure Reference Architectures
description: Learn about the components and libraries in the Gridwich clean monolith architecture.
author: doodlemania2
ms.date: 10/08/2020
ms.topic: reference-architecture
ms.service: architecture-center
ms.subservice: reference-architecture
ms.custom:
- fcp
---

# Clean monolith architecture

The code in this project is organized as a clean-architecture monolith, with the following conceptual components:

- API adapters
- Decoupled application business logic
- Core domain objects
- Infrastructure gateways
- Inversion of Control (IoC)

![components_clean diagram](media/clean-monolith-components.png)

The solution is stateless, so it doesn't contain any gateways to persistence layers. The solution has no user interface, so it has no controllers or presenters.

Software component composition is achieved by using the `ConfigureServices` class within the Function app. The `ConfigureServices` class defines which concrete classes are available in the IoC container for the app.

## Architecture

![components_solution diagram](media/solution-components.png)

The solution has a `Core.EventGrid` library, which contains:

- The domain request and response data transfer objects (DTOs).
- Interfaces for all application business logic or service objects.
- The base classes that help achieve common domain-driven logic or activities.
- Logging, observability, and exception definitions for use throughout the application.

To encapsulate EventGrid as a request and response broker, the library has:

- An event dispatcher that uses the IoC to identify and dispatch events to listeners.
- An event publisher to place responses on the correct EventGrid topic.

The Event Grid request adapter is an https endpoint in the form of an [Azure Function HTTP Endpoint](/azure/azure-functions/functions-bindings-http-webhook). An adapter to convert web requests to Event Grid arrays is also in the same [EventGridFunction](https://github.com/mspnp/gridwich/src/GridWich.Host.FunctionApp/src/Functions/EventGridFunction.cs).

The Event Grid response gateway consists of the:
- [EventGridHandlerBase](https://github.com/mspnp/gridwich/src/GridWich.Core/src/Bases/EventGridHandlerBase.cs), which converts a response DTO into an `EventGridEvent` object.
- [EventGridDispatcher](https://github.com/mspnp/gridwich/src/GridWich.Core.EventGrid/src/EventGridDispatcher.cs), which places the Event Grid event on the correct response Event Grid topic endpoint URI by using the correct topic key.

The solution decouples the [saga participants](gridwich-operations-sagas.md#saga-participants) into the following libraries, which have responsibilities over domain-specific application business logic. The libraries contain required infrastructure gateways and their SDKs, which accomplish the actions that the business logic requires.

- Analysis.MediaInfo
- Encode.CloudPort
- Encode.Flip
- Encode.MediaServicesV2
- Encode.MediaServicesV3
- Publication.MediaServicesV3
- Storage.AzureStorage

For code reuse and centralization, business logic or infrastructure gateways that are used across participants are consolidated into the following shared libraries:

- Core.MediaServicesV3
- Encode
- Encode.TelestreamCloud

## Alternatives

- Better decoupling from the Event Grid infrastructure could be achieved by refactoring the `EventGridHandlerBase` into a `RequestHandlerBase`, and removing any linkage to Event Grid objects or types.  This refactored class would deal only in base DTOs, and not in transport-specific object types. Similarly, the `IEventGridDispatcher` would become a `IResponseDispatcher` with a specific `EventGridDispatcher` implementation.

- The `Storage.AzureStorage` library also contains storage services that other participants use. Having the interfaces in core project avoids IoC issues, but they could be extracted into a separate core storage infrastructure gateway library.

### Microservices considerations

Nothing in the problem space or architecture explicitly pushes the solution into either a monolithic app or several microservices.

The app could easily be refactored into microservices, each a Function App hosting a single saga participant. Each Function app would link the core and core EventGrid libraries.  The apps would each have a linkage or use a common library for infrastructure gateways.

![components_microservices diagram](media/microservices-components.png)

The advantage of such a microservices approach is the ability to scale differently for each type of request. If there were thousands of one type of request per second, but only hundreds of another request type per day, the overall solution would benefit from having smaller, easy-to-instantiate and quick-to-execute functions for the high-volume requests.

The drawback to such microservices is that any shared models would require synchronized rollout of the microservices, or request pool draining and switchover if there was a data schema change. This requirement would complicate future development, continuous deployment, and operations. Since the business problem didn't demonstrate a need for microservices, the architecture uses a clean monolith approach.

