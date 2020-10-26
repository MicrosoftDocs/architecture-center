---
title: Gridwich project naming conventions
titleSuffix: Azure Reference Architectures
description: Learn about Gridwich components, capabilities, technologies, namespaces, and project naming conventions and structure.
author: doodlemania2
ms.date: 10/08/2020
ms.topic: reference-architecture
ms.service: architecture-center
ms.subservice: reference-architecture
ms.custom:
- fcp
---

# Gridwich project naming conventions

Gridwich is a .NET Core solution composed of multiple projects. It's important to have a naming convention to easily understand the structure of the application, find relevant code quickly, and reduce [bike-shedding](https://en.wiktionary.org/wiki/bikeshedding) in project naming.

The Gridwich system has three components:

- `Core`
- `Host.FunctionApp`
- `SagaParticipants`

In the `SagaParticipants` component, Gridwich provides external function capabilities like:

- Analyze
- Encode
- Publish
- Store

Technologies are actual implementations of a capability or core function. A technology project can either be under `Core` or under a `SagaParticipants.{Capability}` namespace and project name, depending on usage.

- The `Gridwich.Core` project has all the system-wide interfaces, models, data transfer objects (DTOs), and base classes.
- The `Gridwich.Core.{Technology}` projects have the client classes and base functionalities used across various capability implementations.
- The `Gridwich.Host.FunctionApp` project is the public interface to the overall system.
- The `Gridwich.SagaParticipants.{Capability}` projects describe the interfaces, exceptions, and events that a capability produces.
- The `Gridwich.SagaParticipants.{Capability}.{Technology}` projects provide the actual capability implementation, Event Listeners, and capability-specific functionality.

## Project creation

You can use the following decision tree when creating a new Gridwich project:

Is the code a contract, like base classes, interfaces, models, or DTOs, or a service extension?

- Yes: Is it related to a specific capacity/service?
  - Yes: `Gridwich.SagaParticipants.{Capability}`
  - No: `Gridwich.Core`
  
- No: Is the code related to an event listener or an implementation of a specific technology?

  - Yes: Will more than one service use the code?
    - Yes, for example an SDK wrapper: `Gridwich.Core.{Technology}`
    - No: `Gridwich.SagaParticipants.{Capability}.{Technology}`
  - No: Is the code related to a specific capability?
    - Yes: `Gridwich.SagaParticipants.{Capability}`
    - No: Is the code an Azure Function App endpoint?
      - Yes: `Gridwich.Host.FunctionApp`
      - No: `Gridwich.Core`

## Project structure

Each package, like `Gridwich.Host.FunctionApp`, has two child subdirectories:

- `src` contains the non-test production code.
- `tests` contains unit tests.

Each of those two directories contains the C# or other files to build the code, plus a *.csproj* file.
The *.csproj* filename is patterned after the package name. For example:

- `src/Gridwich.Host.FunctionApp/src/Gridwith.Host.FunctionApp.csproj`
- `src/Gridwich.Host.FunctionApp/tests/Gridwith.Host.FunctionAppTests.csproj`

The code namespaces the package uses also follow this convention, for example:

- `GridWich.Host.FunctionApp`
- `Gridwich.Host.FunctionAppTests`

During build and test cycles, transient directories like `bin`, `obj` and `TestResults` appear, which contain no git-eligible artifacts.  The `dotnet clean` processing cleans up these transient directories.

## Project names and namespaces

Gridwich project names and namespaces have the following characteristics.

### Core and SagaParticipants technology namespaces

The `Gridwich.Core.{Technology}` namespace doesn't include the purpose of the technology, mainly to to avoid *bike-shedding*. `Core` namespaces are internal projects that `SagaParticipants` or `Host.FunctionApp` projects use, so stakeholders don't need to provide well-defined names.

For example, looking at the two existing projects under `Core`: `MediaServicesV3` and `EventGrid`:
- Should `MediaServicesV3` be `Gridwich.Core.Media.MediaServicesV3` or `Gridwich.Core.Processing.MediaServicesV3`?
- Should `EventGrid` be `Gridwich.Core.Events.EventGrid` or `Gridwich.Core.Messaging.EventGrid`?

It doesn't matter, because the project names already suggest that they contribute to the core system. A technology could also contribute to the system in more than one way. For example Redis could be a data store or messaging transport, depending on usage, but it always uses the same SDK wrapper.

A namespace like `Gridwich.SagaParticipants.Encode` has components used by more than one Encode technology-specific package, like `Gridwich.SagaParticipants.Encode.CloudPort` and `Gridwich.SagaParticipants.Encode.Flip`. This code isn't packaged under `Gridwich.Core.Encode` only because it's more specific to Encode, and doesn't cross into other capabilities like Publication.

In contrast, a package like `Gridwich.Core.MediaServicesV3` is used by both `Gridwich.SagaParticipants.Encode.MediaServicesV3` and `Gridwich.SagaParticipants.Publish.MediaServicesV3`.

### SagaParticipants package characteristics

Not every `Gridwich.SagaParticipants` package processes external events. Some packages under `Gridwich.SagaParticipants` provide functionality for other SagaParticipants that do process external requests.

Besides the `Gridwich.SagaParticipants.Encode` packaging that shares code across multiple Encode packages, there may also be specialized packages like `Gridwich.SagaParticipants.Encode.Telestream`. The Telestream package provides Gridwich access to an external Vantage Telestream system. The Flip and CloudPort SagaParticipants make use of the Telestream package to provide their own request processing.

### Package names and other namespaces

To keep `using` statements to a minimum, package contents aren't restricted to the namespace indicated by the package name. Some packages contribute entities to other namespaces. For example, the package `Gridwich.Core.Tests` contributes the `Gridwich.Core.Helpers.TestHelpers` class. 

However, each package builds a DLL that matches the package name for the production-use code in `./src`, and a DLL of unit tests in `tests`.  The test DLL name is the same as the package, but with a `Tests` suffix.

The `./tests` subdirectory is present in every project, but if there are no unit tests for a package, the directory may be empty, and the package won't build a specific unit test DLL.
