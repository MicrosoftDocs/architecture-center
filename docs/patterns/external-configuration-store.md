---
title: External Configuration Store Pattern
description: Review the External Configuration Store pattern, which moves configuration information out of the application deployment package to a centralized location.
ms.author: pnp
author: claytonsiemens77
ms.date: 04/30/2026
ms.topic: design-pattern
ms.subservice: cloud-fundamentals
---

# External Configuration Store pattern

Move configuration information out of the application deployment package to a centralized location. This approach provides easier management and control of configuration data. Use the External Configuration Store pattern to share configuration data across applications and application instances.

## Context and problem

Most application runtime environments include configuration information in files that you deploy with the application. In some cases, you can edit these files to change the application's behavior after you deploy the application. However, configuration changes require you to redeploy the application. Redeployment often results in unacceptable downtime and other administrative overhead.

Local configuration files also limit the configuration to a single application. In some scenarios, you might want to share configuration settings across multiple applications. Examples include database connection strings, UI theme information, and the URLs of queues and storage that a related set of applications uses.

Managing changes to local configurations across multiple running instances of the application is challenging, especially in a cloud-hosted scenario. This challenge can result in instances that use different configuration settings while you deploy the update.

Updates to applications and components might also require changes to configuration schemas. Many configuration systems don't support different versions of configuration information.

## Solution

Store the configuration information in external storage, and provide an interface that you can use to quickly and efficiently read and update configuration settings. The type of external store depends on the application's hosting and runtime environment. In a cloud-hosted scenario, external storage is typically a cloud-based storage service or dedicated configuration service. It might also be a hosted database or other custom system.

The backing store that you choose for configuration information should have an interface that provides consistent and easy-to-use access. It should expose the information in a correctly typed and structured format. The implementation might also need to authorize users' access to protect configuration data. It might need to be flexible enough to store multiple versions of the configuration, such as development, staging, and production, including multiple release versions of each configuration.

Many built-in configuration systems read the data when the application starts and then cache the data in memory to provide fast access and minimize the impact on application performance. Depending on the type of backing store that you use and the latency of this store, you might want to implement a caching mechanism within the external configuration store. For more information, see [Caching guidance](/azure/architecture/best-practices/caching). The following diagram shows an overview of the External Configuration Store pattern with an optional local cache.

:::image type="complex" source="./_images/external-configuration-store-overview.svg" border="false" lightbox="./_images/external-configuration-store-overview.svg" alt-text="A diagram that shows an overview of the External Configuration Store pattern with an optional local cache.":::
    On the left side of the diagram, three circles arranged vertically represent application instances. These application instances connect via arrows to a central rectangle labeled external configuration store. The arrows indicate that applications can read from and write to the configuration store. A bidirectional arrow connects the external configuration store to an icon labeled local cache. This arrow shows that the configuration store can cache data locally. On the right side of the diagram, the external configuration store connects to two backing storage options. A solid bidirectional arrow connects the external configuration store to a cloud icon labeled cloud storage, the primary storage option. A dashed arrow labeled alternative option points from the External configuration store to a database icon labeled database. This database represents an alternative backing store implementation.
:::image-end:::

## Problems and considerations

Consider the following points as you decide how to implement this pattern:

- Choose a backing store that provides acceptable performance, high availability, and robustness. Ensure that you can back it up in your application maintenance and administration process. In a cloud-hosted application, use a cloud storage mechanism or dedicated configuration platform service to meet these requirements.

- Design the schema of the backing store to allow flexibility in the types of information that it can hold. Ensure that it provides capabilities for all configuration requirements, such as typed data, collections of settings, multiple versions of settings, and any other features that the applications require. The schema should be easy to extend to support more settings when requirements change.

- Consider the physical capabilities of the backing store, how they relate to the way it stores configuration information, and the effects on performance. For example, storing an XML document that contains configuration information requires either the configuration interface or the application to parse the document to read individual settings. Parsing complicates how you update settings, but caching the settings can help offset slower read performance.

- Consider how the configuration interface permits control of the scope and inheritance of configuration settings. For example, you might need to scope configuration settings at the organization, application, and machine levels. The configuration interface might need to delegate control over access to different scopes and prevent or allow individual applications to override settings.

- Ensure that the configuration interface can expose the configuration data in the required formats, such as typed values, collections, key-value pairs, and property bags.

- Consider how the configuration store interface behaves when settings contain errors or don't exist in the backing store. You might need to restore default settings and log errors. Also consider the case sensitivity of configuration setting keys or names, how to store and handle binary data, and how to handle null or empty values.

- Consider how to protect the configuration data and give access to only the appropriate users and applications. The configuration store interface typically provides this feature, but you also need to ensure that users and applications can't directly access the data in the backing store without the appropriate permissions. Ensure strict separation between the permissions required to read and write configuration data. Also consider whether you need to encrypt some or all of the configuration settings and how to implement this encryption in the configuration store interface.

   You should also turn on audit logging to record who reads or modifies configuration values and when these actions occur. Apply the same audit requirements to any local fallback copies of configuration data.

- Separate nonsensitive configuration values from secrets. Keep routine settings, such as feature flags and endpoints, in the configuration settings. Store secrets, such as connection strings, API keys, certificates, and passwords, in a dedicated secret-management system that provides encryption and controlled access.

- Centrally stored configurations, which change application behavior during runtime, are crucial. Deploy, update, and manage them by using the same mechanisms that you use to deploy application code. For example, you must carry out changes that can affect more than one application by using a fully tested-and-staged deployment approach to ensure that the change suits all applications that use this configuration. If an administrator edits a setting to update one application, it might adversely affect other applications that use the same setting. Products like Azure App Configuration help mitigate this risk through built-in capabilities, such as revision history, point-in-time recovery (PITR), immutable snapshots, and progressive rollout patterns.

- If an application caches configuration information, you need to alert the application when the configuration changes. You might implement an expiration policy for cached configuration data so that this information automatically refreshes periodically. The application sees the changes and implements them.

- Cached configuration data can help address transient connectivity problems that the external configuration store experiences at application runtime, but this approach typically doesn't solve the problem if the external store is down when the application starts. Ensure that your application deployment pipeline can provide the last known set of configuration values in a configuration file to use when your application can't retrieve live values at startup.

## When to use this pattern

Use this pattern when:

- You need to share configuration settings across multiple applications or instances or enforce a standard configuration across them.

- Your standard configuration system doesn't support all required setting types, such as images or complex data structures.

- You need a complementary store for some settings, while allowing applications to override some or all centrally stored values.

- You need to simplify administration across multiple applications and optionally monitor configuration usage by recording access to the configuration store.

This pattern might not be suitable when:

- Your configuration is simple, local to one application, and changes only during normal release cycles. In this case, an external configuration store can add unnecessary operational complexity.

## Workload design

Evaluate how to use the External Configuration Store pattern in a workload design to address the goals and principles covered in the [Azure Well-Architected Framework pillars](/azure/well-architected/pillars). The following table provides guidance about how this pattern supports the goals of each pillar.

| Pillar | How this pattern supports pillar goals |
| :----- | :------------------------------------- |
| [Operational Excellence](/azure/well-architected/operational-excellence/checklist) helps deliver **workload quality** through **standardized processes** and team cohesion. | This separation of application configuration from application code supports environment-specific configuration and applies versioning to configuration values. External configuration stores are also a common place to manage feature flags to implement safe deployment practices.<br/><br/> - [OE:10 Automation design](/azure/well-architected/operational-excellence/enable-automation)<br/> - [OE:11 Safe deployment practices](/azure/well-architected/operational-excellence/safe-deployments) |

If this pattern introduces trade-offs within a pillar, consider them against the goals of the other pillars.

## Example

The following examples show how to implement the External Configuration Store pattern in Azure. The first example uses App Configuration and client libraries. The second example uses a custom backing store for scenarios that require specialized implementation.

### App Configuration

Most applications can use [App Configuration](/azure/azure-app-configuration/overview) instead of a custom configuration store. App Configuration supports [key-value pairs](/azure/azure-app-configuration/concept-key-value) that you can apply namespaces to. App Configuration also supports [immutable snapshots](/azure/azure-app-configuration/concept-snapshots) of configuration so that you can inspect, roll back, or progressively deploy configuration changes without risk to running instances.

Use [snapshot references](/azure/azure-app-configuration/concept-snapshot-references) to let applications switch between snapshots at runtime without code changes or redeployment. You can export configuration values so that a copy ships with your application as a backup to use if the service is unreachable when the application starts.

In App Configuration, [keys](/azure/azure-app-configuration/concept-key-value#keys) and [values](/azure/azure-app-configuration/concept-key-value#values) are Unicode strings, and each key-value pair has optional metadata, such as [label-based variants](/azure/azure-app-configuration/concept-key-value#version-key-values) and [content type](/azure/azure-app-configuration/concept-key-value#use-content-type). Use content type to describe how your application should interpret a value, such as in JSON or in a built-in App Configuration type. App Configuration also keeps a [revision history with PITR](/azure/azure-app-configuration/concept-point-time-snapshot), which helps you review and recover previous key-value pairs.

For resiliency, provision your store in a region that supports [availability zones](/azure/azure-app-configuration/howto-best-practices?tabs=dotnet#building-applications-with-high-resiliency) and turn on [geo-replication](/azure/azure-app-configuration/concept-geo-replication) so that you can configure your applications to read from the nearest replica and switch between replica endpoints during regional outages. Use [Azure Key Vault references](/azure/azure-app-configuration/use-key-vault-references-dotnet-core) to keep secrets in Key Vault and reference them from App Configuration, rather than storing credentials directly in the configuration store. Use [managed identity and Azure role-based access control (Azure RBAC)](/azure/azure-app-configuration/concept-enable-rbac) instead of connection strings to authenticate applications to App Configuration.

For workloads that run in Azure Kubernetes Service (AKS), the [App Configuration Kubernetes Provider](/azure/azure-app-configuration/quickstart-azure-kubernetes-service) can generate ConfigMaps and Secrets directly from your store without requiring code changes in your workload containers. You can also use App Configuration to manage [feature flags](/azure/azure-app-configuration/concept-feature-management), including targeted rollout and variant-based experimentation, in your [safe deployment practices](/azure/well-architected/operational-excellence/safe-deployments).

For network isolation, use [private endpoints for App Configuration](/azure/azure-app-configuration/concept-private-endpoint) so that client traffic remains on private IP addresses through Azure Private Link. After you set up private access, you can [turn off public access](/azure/azure-app-configuration/howto-disable-public-access) to reduce public endpoint exposure. In geo-replicated deployments, a single private endpoint can reach all replicas, but for higher regional resilience, you can provision private endpoints for each replica region and set up the domain name system (DNS) accordingly.

:::image type="complex" source="./_images/external-configuration-store.svg" border="false" lightbox="./_images/external-configuration-store.svg" alt-text="A diagram that shows an example External Configuration Store pattern implementation with App Configuration as the central hub that connects to multiple Azure services and storage systems.":::
    At the top of the diagram, an arrow points from an Azure function to App Configuration. On the left side of the diagram, an arrow connects the Azure Container Apps environment and AKS and points to App Configuration. On the right side of the diagram, an arrow connects an Azure virtual machine (VM) and Azure App Service to App Configuration. An arrow points from App Configuration to Key Vault at the bottom of the diagram. The architecture demonstrates how App Configuration serves as a centralized configuration management service that multiple Azure compute services can access to retrieve application settings, while keeping sensitive secrets in Key Vault and referencing them through App Configuration.
:::image-end:::

#### Client libraries

Client libraries provide many of the preceding features. Client libraries integrate with the application runtime to help fetch and cache values, refresh values when they change, and handle transient outages in App Configuration.

| Runtime | Client library | Notes | Quickstart |
| ------- | -------------- | ----- | ---------- |
| .NET | [Microsoft.Extensions.Configuration.AzureAppConfiguration](https://www.nuget.org/packages/Microsoft.Extensions.Configuration.AzureAppConfiguration/) | Provider for `Microsoft.Extensions.Configuration` | [Quickstart for .NET](/azure/azure-app-configuration/quickstart-dotnet-core-app) |
| ASP.NET Core | [Microsoft.Azure.AppConfiguration.AspNetCore](https://www.nuget.org/packages/Microsoft.Azure.AppConfiguration.AspNetCore) | Adds request-driven refresh middleware for ASP.NET Core | [Quickstart for ASP.NET Core](/azure/azure-app-configuration/quickstart-aspnet-core-app) |
| Azure Functions in .NET | [Microsoft.Azure.AppConfiguration.Functions.Worker](https://www.nuget.org/packages/Microsoft.Azure.AppConfiguration.Functions.Worker/) | Provider for the isolated worker model that uses `Program.cs` | [Quickstart for Azure Functions](/azure/azure-app-configuration/quickstart-azure-functions-csharp) |
| .NET Framework | [Microsoft.Configuration.ConfigurationBuilders.AzureAppConfiguration](https://www.nuget.org/packages/Microsoft.Configuration.ConfigurationBuilders.AzureAppConfiguration) | Configuration builder for `System.Configuration` | [Quickstart for .NET Framework](/azure/azure-app-configuration/quickstart-dotnet-app) |
| Java Spring | [com.azure.spring > azure-spring-cloud-appconfiguration-config](https://mvnrepository.com/artifact/com.azure.spring/azure-spring-cloud-appconfiguration-config) | Supports Spring Framework access via `ConfigurationProperties` | [Quickstart for Java Spring](/azure/azure-app-configuration/quickstart-java-spring-app) |
| Python | [azure-appconfiguration-provider](https://pypi.org/project/azure-appconfiguration-provider/) | Provider library that provides dynamic refresh and Key Vault reference support | [Quickstart for Python](/azure/azure-app-configuration/quickstart-python-provider) |
| JavaScript and Node.js | [@azure/app-configuration-provider](https://www.npmjs.com/package/@azure/app-configuration-provider) | Provider library that provides dynamic refresh and Key Vault reference support | [Quickstart for JavaScript](/azure/azure-app-configuration/quickstart-javascript-provider) |

The following [App Configuration sync](https://github.com/marketplace/actions/get-azure-app-configuration) GitHub Action and built-in Azure Pipelines tasks are also available:

- [App Configuration Export](/azure/azure-app-configuration/azure-pipeline-export-task)
- [App Configuration Import](/azure/azure-app-configuration/azure-pipeline-import-task)

### Custom backing store example

In an application that Azure hosts, you can use Azure Storage to store configuration information externally. This approach provides resiliency and high performance. By default, Storage replicates data three times within a single datacenter. For geo-redundancy across regions, you can set up geo-replication with manual failover capabilities. Azure Table Storage provides a key-value store that can use a flexible schema for the values. Azure Blob Storage provides a hierarchical, container-based store that can hold any type of data in individually named blobs.

When you implement this pattern, you need to abstract Blob Storage and expose your settings within your applications. You also need to check for updates at runtime and decide how to respond to those updates.

The following example shows how you can use a simple configuration store and Blob Storage to store and expose configuration information. A `BlobSettingsStore` class abstracts Blob Storage for holding configuration information. It implements a simple `ISettingsStore` interface.

```csharp
public interface ISettingsStore
{
    Task<ETag> GetVersionAsync();
    Task<Dictionary<string, string>> FindAllAsync();
}
```

This interface defines methods for retrieving configuration settings that the configuration store holds and includes a version number that you can use to detect recent configuration setting modifications. A `BlobSettingsStore` class can use the `ETag` property of the blob to implement versioning. The `ETag` property updates automatically each time a blob is written.

> [!NOTE]
> By design, this simple illustration exposes all configuration settings as string values rather than typed values.

An `ExternalConfigurationManager` class provides a wrapper around a `BlobSettingsStore` instance. An application can use this class to retrieve configuration information. This class might use a change notification mechanism, such as [Microsoft Reactive Extensions](https://github.com/dotnet/reactive), to publish configuration updates while the system runs. It also implements the [Cache-Aside pattern](./cache-aside.yml) for settings to provide better resiliency and performance.

The following example shows how you might implement an `ExternalConfigurationManager` class.

```csharp
static void Main(string[] args)
{
    // Start monitoring configuration changes.
    ExternalConfiguration.Instance.StartMonitor();

    // Get a setting.
    var setting = ExternalConfiguration.Instance.GetAppSetting("someSettingKey");
    …
}
```

## Next steps

- [App Configuration samples](https://github.com/Azure/AppConfiguration/tree/main/examples)
- [Integrate App Configuration with Kubernetes deployments by using Helm](/azure/azure-app-configuration/integrate-kubernetes-deployment-helm)
- [Manage feature flags in App Configuration](/azure/azure-app-configuration/manage-feature-flags)
- [Caching guidance](/azure/architecture/best-practices/caching)
- [App Configuration best practices](/azure/azure-app-configuration/howto-best-practices)

## Related resource

- [Cache-Aside pattern](./cache-aside.yml)