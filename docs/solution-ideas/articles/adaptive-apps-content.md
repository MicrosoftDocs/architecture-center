[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Portability is a procurement and operational requirement for modern applications. Teams must design applications that are reversible and can be ported to different targets including sovereign clouds, on-premises infrastructure, and intermittently connected edge environments. The following conditions drive the need for portability:

- Data residency and sovereignty rules
- Sector-specific compliance mandates
- Intermittent connectivity environments
- Business-continuity requirements

[Arc-enabled Kubernetes](/azure/azure-arc/kubernetes/overview), [Radius](https://docs.radapp.io/), and edge AI patterns create a practical foundation for an architecture model that can satisfy portability requirements. This architecture model is the *adaptive apps* solution. 

Adaptive apps separate application intent from environment-specific implementation. Developers describe workloads and required capabilities once, and platform operators bind those portable resources to local service recipes, policies, identity, networking, observability, and infrastructure appropriate to each environment. This article describes the adaptive apps solution and shows how capability portfolios, open protocols, and Radius-based deployment workflows enable applications to remain consistent, governable, and operational wherever they run.

## Architecture

An application modeled with Radius is composed of a set of resources. You can categorize these resources into application components and platform-level resources that support the application. The collection of these platform-level resources is called a *capability portfolio*.

A Radius resource defines an abstract interface to a platform-level capability. When you deploy a Radius resource to a target environment, a target-specific recipe can map that resource type to a concrete, platform-specific implementation. You project the capability portfolio into different target environments through corresponding recipes.

This architecture provides the application with the required capabilities without requiring the application code to be rewritten for each specific platform.

:::image type="complex" border="false" source="../media/adaptive-apps.png" alt-text="Diagram that shows the Adaptive Apps architecture." lightbox="../media/adaptive-apps.png":::
  Diagram that shows the architecture of an adaptive app. At the top, the example application code and Application Model consist of ingress connecting to a service that connects to a database. An arrow shows the Application Model feeding the Radius Control Plane, which contains separate capability profiles for each target environment. Each capability portfolio contains environment-specific ingress, service, and database recipes. An arrow goes from each capability profile to its respective Azure, AKS everywhere, or Arc-enabled Kubernetes target environment. Each environment contains a target-specific gateway, Kubernetes, and database resource.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/adaptive-apps.vsdx) of this architecture.*

The architecture enables portability through two complementary abstraction layers.

- First, Radius provides an application model abstraction that separates application requirements from platform-specific implementations. Abstract resource types represent resources such as databases, caches, or messaging systems that can map to different implementations through environment-specific recipes. This approach allows you to deploy the same application definition across multiple environments without modifying deployment artifacts.

- Second, applications can adopt a programming model abstraction. Applications can interact with dependencies through widely adopted standards and protocols, or through an optional [sidecar](../../patterns/sidecar.md)-based abstraction layer such as [Dapr](https://dapr.io/). These approaches reduce application coupling to platform-specific service APIs and improve portability across environments.

These abstractions provide a compelling "write once, run in many environments" experience, but they also introduce tradeoffs. To remain portable, applications might need to limit direct use of platform-specific features and optimizations that aren't available across all target environments. When you use a sidecar or common programming abstraction to achieve portability, you must accept the constraints imposed by that abstraction layer.

Teams must commit to validating application behavior across supported deployment targets, which increases testing and operational complexity. View portability as an intentional architectural choice that sacrifices deeper platform integration for deployment flexibility, reduced lock-in, and greater consistency across heterogeneous environments.

### Workflow

The following workflow corresponds to the preceding diagram. The workflow describes a sample app that contains typical components such as a front end, back end, AI agent, message broker, and OpenID Connect (OIDC) identity provider.

1. An application developer uses a Radius application definition to describe the workload one time.

   The application definition consists of a list of resources, such as an `Applications.Core/containers` resource describing a containerized payload front end and back end. The adaptive apps pattern also defines a few resource type extensions that abstract common platform capabilities to decouple the application from any particular platform.

   Instead of defining new data plane abstractions, adaptive apps use widely adopted open-source components and open protocols such as OIDC for authentication and Message Queuing Telemetry Transport (MQTT) for messaging. This approach prevents the application from being constrained by an abstract interface and allows it to directly use the full capabilities of the corresponding protocols.

   | Resource type | Purpose |
   | ------------- | --------|
   | `Radius.Resources/agentGuardrails` | Agent-specific governance policies |
   | `Radius.Resources/aiModels` | AI models that support AI inferences |
   | `Radius.Resources/governance` | Enterprise governance policies |
   | `Radius.Resources/mqttBrokers` | Message brokers based on MQTT |
   | `Radius.Resources/workloadIdentities` | Workload identities used to identify a workload or agent within an application |

1. The developer can create or update application code by using a portable API.

   At the programming-model level, an application can further adopt sidecar technologies like Dapr, which provides platform-agnostic APIs for common tasks such as pub/sub, state management, and secrets. Radius has native support for Dapr sidecars.

   Brownfield services that already use Azure SDKs can continue to work in targets if the required Azure endpoints, identity flows, and network connectivity are available. Services that use common protocols can continue to work where compatible implementations are provided. For broader portability, new services can adopt Dapr APIs to help applications adapt to more platform variations.

1. A platform operator bootstraps a capability portfolio for each target.

   The operator picks one of the six predefined portfolios: `min`, `core`, `ent`, `min-ai`, `core-ai`, or `ent-ai`, based on the environment's footprint and compliance needs. The operator installs the portfolio via a Helm chart. The following table shows whether the predefined portfolios support various protocols.

   | Portfolio | Identity (OIDC) | Service mesh (Istio) | Observability (OTel) | Governance (OPA) | On-cluster AI (Kaito) | Agent guardrail |
   | --------- | :-------------: | :------------------: | :------------------: | :--------------: | :-------------------: | :-------------: |
   | `min` | ✓ | ✗ | ✗ | ✗ | ✗ | ✗ |
   | `core` | ✓ | ✓  | ✓  | ✗  | ✗  | ✗ |
   | `ent` | ✓ | ✓ | ✓ | ✓ | ✗ | ✗ |
   | `min-ai` | ✓ | ✗ | ✗ | ✗ | ✓ | ✗ |
   | `core-ai` | ✓ | ✓ | ✓ | ✗ | ✓ | ✓ |
   | `ent-ai` | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |

   Adaptive apps also provide a command line tool to facilitate infrastructure configuration steps beyond Helm installation and make infrastructure information available for application deployment.

1. Radius binds the application to environment-specific recipes.

   When `rad deploy` runs against the target workspace, a recipe registered with the environment provisions each portable resource in the adaptive app. For example, `Radius.Resources/aiModels` resolves to a local small language model (SLM) managed by [Kaito](https://kaito-project.github.io/kaito/docs/) when the app deploys to a local Kubernetes environment. The same resource resolves to an OpenAI or Azure OpenAI endpoint when deployed to a cloud environment. Radius injects connection information for dependencies that the application definition explicitly declares.

   :::image type="complex" border="false" source="../media/adaptive-apps-resource-mapping.png" alt-text="Diagram that shows an adaptive app modeled using Radius application model projected into different target environments via corresponding recipes." lightbox="../media/adaptive-apps-resource-mapping.png":::
     Diagram that shows how the capabilities of the example adaptive app populate each target environment. A box at left shows the Radius adaptive app that contains compute, identity provider, workload identity, messaging, AI model, policy, and observability capabilities. Arrows lead from each capability to the deployment targets: Azure, Azure Arc, or other clouds and custom environments. Each target contains target-specific services and extensions that implement that capability on that environment.
   :::image-end:::

   *Download a [Visio file](https://arch-center.azureedge.net/adaptive-apps.vsdx) of this diagram.*

### Components

- [Radius](https://docs.radapp.io/) is an open-source application model that expresses a workload as a graph of portable resource types and resolves each type to an environment-specific recipe at deployment time. In this architecture, Radius is the primary contract between application teams and platform operators. Adaptive apps also use Radius tooling to deploy applications to target environments.

- [Capability portfolios](https://github.com/microsoft/adaptive-apps/blob/main/docs/portfolios/overview.md) are contracts between applications and their hosting platforms. This architecture has six predefined portfolios for capability tiers, from a baseline edge footprint to a full enterprise setup with policy enforcement and on-cluster AI. Platform operators install capability portfolios as Helm charts. 

- [AI-powered tools](https://github.com/microsoft/adaptive-apps/tree/main/cli) provide a CLI for infrastructure configuration and AI-assisted migration of brownfield applications. In this architecture, the tools help migrate brownfield applications, including microservices applications, legacy applications, and mainframe applications, to the Radius application model.

## Scenario details

A workload team might need to run the same application across a heterogeneous estate that can include the following environments:

- A public-cloud region for elastic workloads
- A sovereign region to meet data-residency obligations
- An on-premises datacenter for latency-sensitive processing
- A fleet of remote edge clusters with intermittent connectivity

Each environment typically has its own identity provider, service mesh overlay, observability stack, policy engine, and AI strategy. Without a unifying contract, application teams must either fork the codebase for each target, lock themselves to a single platform, or incur refactoring costs every time they add a new environment.

Adaptive apps address this problem by making the platform, not the application, responsible for absorbing environmental variation. The application is authored once against the Radius application model and, optionally, the Dapr programming model. Each target environment installs a capability portfolio that exposes the capabilities required by the application. A recipe layer binds portable resources to environment-specific implementations at deployment time.

The architecture is intentionally non-prescriptive about the control plane. Capability vendors can deliver portfolios through Helm, Arc extensions, Bicep, Terraform, or custom installers. Applications remain portable as long as the resulting environment satisfies the portfolio's capability contract.

### Potential use cases

- Sovereign and regulated cloud deployments

  A regulated workload must run in a sovereign cloud or on customer-controlled infrastructure while sharing a codebase with the public cloud version. The `core-ai` or `ent-ai` portfolio provides a consistent capability contract across deployment targets, enabling application portability. The target environment enforces the specific implementation of capabilities and controls, including data residency, encryption, access control, auditing, and compliance certifications to meet sovereignty and regulatory requirements.

- Brownfield modernization without replatforming

  A workload team incrementally modernizes a legacy microservices application by introducing Radius resource definitions to describe its infrastructure dependencies and by selectively adopting Dapr capabilities. AI-powered refactoring tools help accelerate portions of the migration. This approach allows teams to modernize applications to improve portability, observability, and operational consistency at a pace that aligns with business and technical requirements.

- Hybrid AI inference at the edge

  A retail or industrial workload runs the same `aiModel` service on Azure in headquarters by calling Azure OpenAI, and on Azure Local clusters in stores or plants by calling a Kaito-hosted open-source model. The application code is identical and only the `aiModel` recipe differs.

- Intermittently connected edge

  A defense, maritime, or remote-site deployment runs the `min-ai` portfolio on a single resource-constrained cluster with no dependency on cloud-hosted identity or AI services. The same workload, when redeployed to AKS with the `core-ai` portfolio, gains mesh and observability automatically. The `ent-ai` portfolio also adds governance policy enforcement.

- Multicloud deployment

  A workload team deploys modeled application resources to another workspace by using `rad deploy`, as long as each target implements the same capability contract. They treat workload bursting and disaster recovery as separate concerns. A usable secondary environment also needs capacity, artifact and data availability, dependency sequencing, identity, network connectivity, traffic routing, health checks, and tested failover/failback procedures.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Haishi Bai](https://www.linkedin.com/in/haishi/) | Principal Software Architect
- [Boris Scholl](https://www.linkedin.com/in/bscholl/) | VP Engineering
- [Will Tsai](https://www.linkedin.com/in/willtsai-hello/) | Principal Product Manager

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next step

- Explore the [Adaptive Apps](https://github.com/microsoft/adaptive-apps) repository on GitHub
