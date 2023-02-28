
Gridwich is a .NET 6 solution composed of multiple projects. It's important for code projects to have a naming convention to help understand application structure, find relevant code quickly, and reduce [bike-shedding](https://en.wiktionary.org/wiki/bikeshedding) in project naming.

The Gridwich system has three major components, `Core`, `Host.FunctionApp`, and `SagaParticipants`.

- The `Core` project has system-wide interfaces, models, data transfer objects (DTOs), and base classes.

  `Core.{Technology}` projects have the client classes and base functionalities that various capability implementations use.

- The `Host.FunctionApp` project is the public interface to the overall system.

- `SagaParticipants` projects provide external function capabilities like analysis, encoding, publishing, and storage.

  `SagaParticipants.{Capability}` projects describe the interfaces, exceptions, and events that a capability produces.

  `SagaParticipants.{Capability}.{Technology}` projects provide actual capability implementation, event listeners, and capability-specific functionality.

A Gridwich `Technology` is an actual implementation of a capability or core function. A `{Technology}` project can be under either a `Core` or a `SagaParticipants.{Capability}` namespace and project name, depending on usage.

## Project creation

You can use the following decision tree when naming a new Gridwich project:

Is the code a contract, like base classes, interfaces, models, or DTOs, or a service extension?

- Yes: Does the code relate to a specific capacity or service?
  - Yes: `Gridwich.SagaParticipants.{Capability}`
  - No: `Gridwich.Core`

- No: Does the code relate to an event listener or an implementation of a specific technology?

  - Yes: Will more than one service use the code?
    - Yes, for example an SDK wrapper: `Gridwich.Core.{Technology}`
    - No: `Gridwich.SagaParticipants.{Capability}.{Technology}`

  - No: Does the code relate to a specific capability?

    - Yes: `Gridwich.SagaParticipants.{Capability}`

    - No: Is the code an Azure Function App endpoint?
      - Yes: `Gridwich.Host.FunctionApp`
      - No: `Gridwich.Core`

## Project structure

Each package has two child subdirectories:

- `src` contains the non-test production code.
- `tests` contains unit tests.

Every project has a `tests` subdirectory, but if there are no unit tests for a package, the directory may be empty.

Each of the two subdirectories contains the C# or other files to build the code, plus a *.csproj* file. The *.csproj* filename follows the package name, for example:

- `Gridwich.Host.FunctionApp/src/Gridwich.Host.FunctionApp.csproj`
- `Gridwich.Host.FunctionApp/tests/Gridwich.Host.FunctionAppTests.csproj`

The code namespaces that the packages use also follow this convention, for example:

- `Gridwich.Host.FunctionApp`
- `Gridwich.Host.FunctionAppTests`

During build and test cycles, transient directories like `bin`, `obj`, and `TestResults` appear, which contain no git-eligible artifacts.  The `dotnet clean` processing cleans up these transient directories.

## Project names and namespaces

Gridwich project names and namespaces have the following characteristics.

### Core and SagaParticipants Technology namespaces

`Gridwich.Core.{Technology}` namespaces don't include the purpose of the technology, mainly to avoid *bike-shedding*. `Core` namespaces are internal projects that `SagaParticipants` or `Host.FunctionApp` projects use, and don't need well-defined names.

For example, the `Gridwich.Core.MediaServicesV3` project could have been named `Gridwich.Core.Media.MediaServicesV3` or `Gridwich.Core.Processing.MediaServicesV3`. The `Gridwich.Core.EventGrid` project could be `Gridwich.Core.Events.EventGrid` or `Gridwich.Core.Messaging.EventGrid`. However, the `Core` project names already suggest that the technologies contribute to the core system.

A technology could also contribute to the system in more than one way. For example, you could call Redis a data store or a messaging transport, depending on usage, but it always uses the same SDK wrapper.

The `Gridwich.SagaParticipants.Encode.CloudPort` and `Gridwich.SagaParticipants.Encode.Flip` technology namespaces use components from the `Gridwich.SagaParticipants.Encode` namespace. This code isn't under `Gridwich.Core.Encode` namespace because it's specific to encoding tasks, and doesn't cross into other capabilities like publication.

On the other hand, both `Gridwich.SagaParticipants.Encode.MediaServicesV3` and `Gridwich.SagaParticipants.Publish.MediaServicesV3` use components from `Gridwich.Core.MediaServicesV3`, so those namespaces include the purpose of the technology.

### SagaParticipants packages

Not every `Gridwich.SagaParticipants` package processes external events. Some packages under `Gridwich.SagaParticipants` provide functionality for other saga participants that process external requests.

Besides the `Gridwich.SagaParticipants.Encode` packaging that shares code across multiple encoding technology packages, there are also specialized packages like `Gridwich.SagaParticipants.Encode.TelestreamCloud`. The Telestream package provides Gridwich access to an external Vantage Telestream system. The Flip and CloudPort saga participants use the Telestream package to provide their own request processing.

### Package names and other namespaces

To keep `using` statements to a minimum, Gridwich doesn't restrict package contents to the namespace that the package name indicates. Some packages contribute entities to other namespaces. For example, the package `Gridwich.Core.Tests` contributes the `Gridwich.Core.Helpers.TestHelpers` class.

However, each package builds a DLL that matches the package name for the production code in `src`, and a DLL of unit tests, if any, in `tests`. The test DLL name is the same as the package name, but with a `Tests` suffix.

## Next steps

Product documentation:

- [Gridwich cloud media system](gridwich-architecture.yml)
- [Introduction to Azure Functions](/azure/azure-functions/functions-overview)

Microsoft Learn modules:

- [Create a long-running serverless workflow with Durable Functions](/training/modules/create-long-running-serverless-workflow-with-durable-functions)
- [Explore Azure Functions](/training/modules/explore-azure-functions)

## Related resources

- [Gridwich clean monolith architecture](gridwich-clean-monolith.yml)
- [Gridwich content protection and DRM](gridwich-content-protection-drm.yml)
- [Gridwich saga orchestration](gridwich-saga-orchestration.yml)
