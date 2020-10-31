---
title: Gridwich clean monolith architecture
titleSuffix: Azure Reference Architectures
description: Learn about the components and libraries in the Gridwich clean monolith architecture, and a microservices alternative.
author: doodlemania2
ms.date: 10/30/2020
ms.topic: reference-architecture
ms.service: architecture-center
ms.subservice: reference-architecture
ms.custom:
- fcp
---

# Clean monolith architecture

The code in this project is organized as a clean-architecture [monolith](/dotnet/architecture/containerized-lifecycle/design-develop-containerized-apps/monolithic-applications), with the following typical conceptual components:

- API adapters
- Decoupled application business logic
- Core domain objects
- Infrastructure gateways
- Inversion of Control (IoC)

![Diagram showing the parts of a clean monolith architecture.](media/clean-monolith-components.png)

The solution is stateless, so it doesn't contain any gateways to persistence layers. The solution has no user interface, so it has no controllers or presenters.

Software component composition uses the [ConfigureServices](https://github.com/mspnp/gridwich/src/Gridwich.Host.FunctionApp/src/GridwichConfigureServices.cs) class within the Azure Functions App to define which concrete classes are available in the IoC container for the app.

## Monolithic architecture

![Diagram showing the components for the monolithic Gridwich architecture.](media/solution-components.png)

The solution has a [Core.EventGrid](https://github.com/mspnp/gridwich/src/GridWich.Core.EventGrid/) library, which contains:

- The domain request and response data transfer objects (DTOs).
- Interfaces for all application business logic or service objects.
- The base classes that help achieve common domain-driven logic or activities.
- Logging, observability, and exception definitions for use throughout the application.

To encapsulate Azure Event Grid as a request and response broker, the library has:

- An event dispatcher that uses the IoC to identify and dispatch events to listeners.
- An event publisher to place responses on the correct EventGrid topic.

The Event Grid request adapter is an HTTP endpoint in the form of an [Azure Function HTTP Endpoint](/azure/azure-functions/functions-bindings-http-webhook). An adapter to convert web requests to Event Grid arrays is also in the same [EventGridFunction](https://github.com/mspnp/gridwich/src/GridWich.Host.FunctionApp/src/Functions/EventGridFunction.cs).

The Event Grid response gateway consists of the:
- [EventGridHandlerBase](https://github.com/mspnp/gridwich/src/GridWich.Core/src/Bases/EventGridHandlerBase.cs), which converts a response DTO into an `EventGridEvent` object.
- [EventGridDispatcher](https://github.com/mspnp/gridwich/src/GridWich.Core.EventGrid/src/EventGridDispatcher.cs), which places the Event Grid event on the correct response Event Grid topic endpoint URI by using the correct topic key.

The solution decouples the [saga participants](saga-orchestration.md#saga-participants) into the following libraries, which have responsibilities over domain-specific application business logic. The libraries contain required infrastructure gateways and their SDKs, which accomplish the actions that the business logic requires.

- [Gridwich.SagaParticipants.Analysis.MediaInfo](https://github.com/mspnp/gridwich/src/Gridwich.SagaParticipants.Analysis.MediaInfo/)
- [Gridwich.SagaParticipants.Encode.CloudPort](https://github.com/mspnp/gridwich/src/Gridwich.SagaParticipants.Encode.CloudPort/)
- [Gridwich.SagaParticipants.Encode.Flip](https://github.com/mspnp/gridwich/src/Gridwich.SagaParticipants.Encode.Flip/)
- [Gridwich.SagaParticipants.Encode.MediaServicesV2](https://github.com/mspnp/gridwich/src/Gridwich.SagaParticipants.Encode.MediaServicesV2/)
- [Gridwich.SagaParticipants.Encode.MediaServicesV3](https://github.com/mspnp/gridwich/src/Gridwich.SagaParticipants.Encode.MediaServicesV3/)
- [Gridwich.SagaParticipants.Publication.MediaServicesV3](https://github.com/mspnp/gridwich/src/Gridwich.SagaParticipants.Publication.MediaServicesV3/)
- [Gridwich.SagaParticipants.Storage.AzureStorage](https://github.com/mspnp/gridwich/src/Gridwich.SagaParticipants.Storage.AzureStorage/)

For code reuse and centralization, Gridwich consolidates business logic or infrastructure gateways that are used across participants into the following shared libraries:

- [Gridwich.Core.MediaServicesV3](https://github.com/mspnp/gridwich/src/Core.MediaServicesV3/)
- [Gridwich.SagaParticipants.Encode](https://github.com/mspnp/gridwich/src/Gridwich.SagaParticipants.Encode/)
- [Gridwich.SagaParticipants.Encode.TelestreamCloud](https://github.com/mspnp/gridwich/src/Gridwich.SagaParticipants.Encode.TelestreamCloud/)

## Microservices alternative

Nothing in the Gridwich problem space or architecture explicitly pushes the solution into either a monolithic app or several microservices.

The app could easily be refactored into microservices, each a Function App hosting a single saga participant. Each Function app would link the core and core EventGrid libraries.  The apps would each have a linkage or use a common library for infrastructure gateways.

![Diagram showing the components for a microservices Gridwich architecture.](media/microservices-components.png)

The advantage of such a microservices approach is the ability to scale differently for each type of request. If there were thousands of one type of request per second, but only hundreds of another request type per day, the overall solution would benefit from having smaller, easy-to-instantiate and quick-to-execute functions for the high-volume requests.

The drawback to such microservices is that any shared models would require synchronized rollout of the microservices, or request pool draining and switchover if there was a data schema change. This requirement would complicate future development, continuous deployment, and operations. Since the business problem didn't demonstrate a need for microservices, the architecture uses a clean monolith approach.

