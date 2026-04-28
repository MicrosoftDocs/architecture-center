---
title: External Configuration Store Pattern
description: Review the External Configuration Store pattern, which moves configuration information out of the application deployment package to a centralized location.
ms.author: pnp
author: claytonsiemens77
ms.date: 09/14/2021
ms.topic: design-pattern
ms.subservice: cloud-fundamentals
---

# External Configuration Store pattern

Move configuration information out of the application deployment package to a centralized location. This approach provides opportunities for easier management and control of configuration data. It also lets you share configuration data across applications and application instances.

## Context and problem

The majority of application runtime environments include configuration information that files deployed with the application store. In some cases, you can edit these files to change the application's behavior after you deploy the application. However, configuration changes require you to redeploy the application. Redeployment often results in unacceptable downtime and other administrative overhead.

Local configuration files also limit the configuration to a single application. In some scenarios, sharing configuration settings across multiple applications is useful. Examples include database connection strings, UI theme information, or the URLs of queues and storage that a related set of applications uses.

It's challenging to manage changes to local configurations across multiple running instances of the application, especially in a cloud-hosted scenario. It can result in instances that use different configuration settings while you deploy the update.

Updates to applications and components might also require changes to configuration schemas. Many configuration systems don't support different versions of configuration information.

## Solution

Store the configuration information in external storage, and provide an interface that you can use to quickly and efficiently read and update configuration settings. The type of external store depends on the application's hosting and runtime environment. In a cloud-hosted scenario, external storage is typically a cloud-based storage service or dedicated configuration service. It might also be a hosted database or other custom system.

The backing store that you choose for configuration information should have an interface that provides consistent and easy-to-use access. It should expose the information in a correctly typed and structured format. The implementation might also need to authorize users' access to protect configuration data. It might need to be flexible enough to store multiple versions of the configuration, such as development, staging, or production, including multiple release versions of each configuration.

Many built-in configuration systems read the data when the application starts and then cache the data in memory to provide fast access and minimize the impact on application performance. Depending on the type of backing store that you use and the latency of this store, it might be helpful to implement a caching mechanism within the external configuration store. For more information, see [Caching guidance](/azure/architecture/best-practices/caching). The following diagram shows an overview of the External Configuration Store pattern with an optional local cache.

![An overview of the External Configuration Store pattern with optional local cache](./_images/external-configuration-store-overview.png)

## Problems and considerations

Consider the following points as you decide how to implement this pattern:

- Choose a backing store that provides acceptable performance, high availability, and robustness. Ensure that you can back it up as part of the application maintenance and administration process. In a cloud-hosted application, use a cloud storage mechanism or dedicated configuration platform service to meet these requirements.

- Design the schema of the backing store to allow flexibility in the types of information that it can hold. Ensure that it provides capabilities for all configuration requirements, such as typed data, collections of settings, multiple versions of settings, and any other features that the applications require. The schema should be easy to extend to support more settings as requirements change.

- Consider the physical capabilities of the backing store, how they relate to the way it stores configuration information, and the effects on performance. For example, storing an XML document that contains configuration information requires either the configuration interface or the application to parse the document to read individual settings. Parsing complicates how you update settings, but caching the settings can help offset slower read performance.

- Consider how the configuration interface permits control of the scope and inheritance of configuration settings. For example, you might need to scope configuration settings at the organization, application, and machine levels. The configuration interface might need to delegate control over access to different scopes and prevent or allow individual applications to override settings.

- Ensure that the configuration interface can expose the configuration data in the required formats, such as typed values, collections, key and value pairs, or property bags.

- Consider how the configuration store interface behaves when settings contain errors or don't exist in the backing store. You might need to restore default settings and log errors. Also consider the case sensitivity of configuration setting keys or names, how to store and handle binary data, and how to handle null or empty values.

- Consider how to protect the configuration data and give access to only the appropriate users and applications. The configuration store interface typically provides this feature, but you also need to ensure that users and applications can't directly access the data in the backing store without the appropriate permission. Ensure strict separation between the permissions required to read and to write configuration data. Also consider whether you need to encrypt some or all of the configuration settings and how to implement this encryption in the configuration store interface. 

   In addition to access control, enable audit logging to record who reads or modifies configuration values and when these actions occur. Apply the same audit requirements to any local fallback copies of configuration data.

- Separate non-sensitive configuration values from secrets. Keep routine settings, such as feature flags and endpoints, in the configuration settings. Store secrets, such as connection strings, API keys, certificates, and passwords, in a dedicated secret-management system that provides encryption and controlled access.

- Centrally stored configurations, which change application behavior during runtime, are crucial. Deploy, update, and manage them by using the same mechanisms that you use to deploy application code. For example, you must carry out changes that can affect more than one application by using a full tested-and-staged deployment approach to ensure that the change suits all applications that use this configuration. If an administrator edits a setting to update one application, it might adversely affect other applications that use the same setting. Products like Azure App Configuration help mitigate this risk through built-in capabilities, such as revision history, point-in-time restore, immutable snapshots, and progressive rollout patterns.

- If an application caches configuration information, you need to alert the application if the configuration changes. You might implement an expiration policy for cached configuration data so that this information automatically refreshes periodically, and the application picks up and acts on changes.

- Caching configuration data can help address transient connectivity problems with the external configuration store at application runtime, but this approach typically doesn't solve the problem if the external store is down when the application starts. Ensure that your application deployment pipeline can provide the last known set of configuration values in a configuration file as a fallback if your application can't retrieve live values when it starts.

## When to use this pattern

Use this pattern when:

- You need to share configuration settings across multiple applications or instances, or enforce a standard configuration across them.

- Your standard configuration system doesn't support all required setting types, such as images or complex data structures.

- You need a complementary store for some settings, while allowing applications to override some or all centrally stored values.

- You need to simplify administration across multiple applications and optionally monitor configuration usage by logging access to the configuration store.

This pattern might not be suitable when:

- Your configuration is simple, local to one application, and changes only during normal release cycles. In this case, an external configuration store can add unnecessary operational complexity.

## Workload design

An architect should evaluate how the External Configuration Store pattern can be used in their workload's design to address the goals and principles covered in the [Azure Well-Architected Framework pillars](/azure/well-architected/pillars). For example:

| Pillar | How this pattern supports pillar goals |
| :----- | :------------------------------------- |
| [Operational Excellence](/azure/well-architected/operational-excellence/checklist) helps deliver **workload quality** through **standardized processes** and team cohesion. | This separation of application configuration from application code supports environment-specific configuration and applies versioning to configuration values. External configuration stores are also a common place to manage feature flags to enable safe deployment practices.<br/><br/> - [OE:10 Automation design](/azure/well-architected/operational-excellence/enable-automation)<br/> - [OE:11 Safe deployment practices](/azure/well-architected/operational-excellence/safe-deployments) |

As with any design decision, consider any tradeoffs against the goals of the other pillars that might be introduced with this pattern.

## Example

### Using Azure App Configuration

While building a custom configuration store might be necessary in some situations, many applications can instead use [Azure App Configuration](/azure/azure-app-configuration/overview). Azure App Configuration supports [key-value pairs](/azure/azure-app-configuration/concept-key-value) that can be namespaced. Azure App Configuration also supports [immutable snapshots](/azure/azure-app-configuration/concept-snapshots) of configuration so that you can inspect, roll back, or progressively deploy configuration changes without risk to running instances. Use [snapshot references](/azure/azure-app-configuration/concept-snapshot-references) to let applications switch between snapshots at runtime without code changes or redeployment. Configuration values can be exported so that a copy ships with your application as a startup fallback if the service is unreachable when the application starts.

In Azure App Configuration, [keys](/azure/azure-app-configuration/concept-key-value#keys) and [values](/azure/azure-app-configuration/concept-key-value#values) are Unicode strings, and each key-value has optional metadata such as [label-based variants](/azure/azure-app-configuration/concept-key-value#version-key-values) and [content type](/azure/azure-app-configuration/concept-key-value#use-content-type). Use content type to describe how your application should interpret a value, for example as JSON or as a built-in App Configuration type. App Configuration also keeps a [revision history with point-in-time restore](/azure/azure-app-configuration/concept-point-time-snapshot), which helps you review and recover previous key-values.

For resiliency, provision your store in a region that supports [availability zones](/azure/azure-app-configuration/howto-best-practices?tabs=dotnet#building-applications-with-high-resiliency) and enable [geo-replication](/azure/azure-app-configuration/concept-geo-replication) so that you can configure your applications to read from the nearest replica and switch between replica endpoints during regional outages. Use [Key Vault references](/azure/azure-app-configuration/use-key-vault-references-dotnet-core) to keep secrets in Azure Key Vault and reference them from App Configuration, rather than storing credentials directly in the configuration store. Authenticate applications to App Configuration using [managed identity and Azure RBAC](/azure/azure-app-configuration/concept-enable-rbac) instead of connection strings. For workloads running in Azure Kubernetes Service, the [Azure App Configuration Kubernetes Provider](/azure/azure-app-configuration/quickstart-azure-kubernetes-service) can generate ConfigMaps and Secrets directly from your store without requiring code changes in your workload containers. You can also use App Configuration to manage [feature flags](/azure/azure-app-configuration/concept-feature-management), including targeted rollout and variant-based experimentation, as part of your [safe deployment practices](/azure/well-architected/operational-excellence/safe-deployments).

For network isolation, use [private endpoints for Azure App Configuration](/azure/azure-app-configuration/concept-private-endpoint) so client traffic stays on private IP connectivity through Azure Private Link. After private access is configured, you can [disable public access](/azure/azure-app-configuration/howto-disable-public-access) to reduce exposure of the public endpoint. In geo-replicated deployments, a single private endpoint can reach all replicas, but for higher regional resilience you can provision private endpoints per replica region and configure DNS accordingly.

![Diagram showing Azure App Configuration at the center, connected to Azure Functions, Azure Container Apps Environment, AKS, Azure Virtual Machine, and App Service.](./_images/external-configuration-store.png)

#### Client libraries

Many of these features are exposed through client libraries which integrate with the application runtime to facilitate fetching and caching values, refreshing values on change, and even handling transient outages of App Configuration Service.

| Runtime                 | Client Library                                                                                                                                                            | Notes                                                                        | Quickstart                                                                                     |
| ----------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------- |
| .NET                    | [Microsoft.Extensions.Configuration.AzureAppConfiguration](https://www.nuget.org/packages/Microsoft.Extensions.Configuration.AzureAppConfiguration/)                      | Provider for `Microsoft.Extensions.Configuration`                            | [Quickstart](/azure/azure-app-configuration/quickstart-dotnet-core-app)                        |
| ASP.NET Core            | [Microsoft.Azure.AppConfiguration.AspNetCore](https://www.nuget.org/packages/Microsoft.Azure.AppConfiguration.AspNetCore)                                                 | Adds request-driven refresh middleware for ASP.NET Core                      | [Quickstart](/azure/azure-app-configuration/quickstart-aspnet-core-app)                        |
| Azure Functions in .NET | [Microsoft.Azure.AppConfiguration.Functions.Worker](https://www.nuget.org/packages/Microsoft.Azure.AppConfiguration.Functions.Worker/)                                    | Provider for the isolated worker model using `Program.cs`                    | [Quickstart](/azure/azure-app-configuration/quickstart-azure-functions-csharp)                 |
| .NET Framework          | [Microsoft.Configuration.ConfigurationBuilders.AzureAppConfiguration](https://www.nuget.org/packages/Microsoft.Configuration.ConfigurationBuilders.AzureAppConfiguration) | Configuration builder for `System.Configuration`                             | [Quickstart](/azure/azure-app-configuration/quickstart-dotnet-app)                             |
| Java Spring             | [com.azure.spring > azure-spring-cloud-appconfiguration-config](https://mvnrepository.com/artifact/com.azure.spring/azure-spring-cloud-appconfiguration-config)           | Supports Spring Framework access via `ConfigurationProperties`               | [Quickstart](/azure/azure-app-configuration/quickstart-java-spring-app)                        |
| Python                  | [azure-appconfiguration-provider](https://pypi.org/project/azure-appconfiguration-provider/)                                                                              | Provider library with dynamic refresh and Key Vault reference support        | [Quickstart](/azure/azure-app-configuration/quickstart-python-provider)                        |
| JavaScript/Node.js      | [@azure/app-configuration-provider](https://www.npmjs.com/package/@azure/app-configuration-provider)                                                                      | Provider library with dynamic refresh and Key Vault reference support        | [Quickstart](/azure/azure-app-configuration/quickstart-javascript-provider)                    |

In addition to client libraries, there are also an [Azure App Configuration Sync](https://github.com/marketplace/actions/get-azure-app-configuration) GitHub Action and built-in Azure Pipelines tasks: [Azure App Configuration Export](/azure/azure-app-configuration/azure-pipeline-export-task) and [Azure App Configuration Import](/azure/azure-app-configuration/azure-pipeline-import-task). 

### Custom backing store example

In a Microsoft Azure hosted application, a possible choice for storing configuration information externally is to use Azure Storage. This is resilient and offers high performance. By default, it replicates data three times within a single data center; for geo-redundancy across regions, you can configure geo-replication with manual failover capabilities. Azure Table storage provides a key/value store with the ability to use a flexible schema for the values. Azure Blob storage provides a hierarchical, container-based store that can hold any type of data in individually named blobs.

When implementing this pattern you'd be responsible for abstracting away Azure Blob storage and exposing your settings within your applications, including checking for updates at runtime and addressing how to respond to those.

The following example shows how a simplistic configuration store could be envisioned over Blob storage to store and expose configuration information. A `BlobSettingsStore` class could abstract Blob storage for holding configuration information, and implements a simple `ISettingsStore` interface.

```csharp
public interface ISettingsStore
{
    Task<ETag> GetVersionAsync();
    Task<Dictionary<string, string>> FindAllAsync();
}
```

This interface defines methods for retrieving configuration settings held in the configuration store and includes a version number that can be used to detect whether any configuration settings have been modified recently. A `BlobSettingsStore` class could use the `ETag` property of the blob to implement versioning. The `ETag` property is updated automatically each time a blob is written.

> By design, this simple illustration exposes all configuration settings as string values rather than typed values.

An `ExternalConfigurationManager` class could then provide a wrapper around a `BlobSettingsStore` instance. An application can use this class to retrieve configuration information. This class might use a change notification mechanism, such as [Microsoft Reactive Extensions](https://github.com/dotnet/reactive), to publish updates made to configuration while the system is running. It would also be responsible for implementing the [Cache-Aside pattern](./cache-aside.yml) for settings to provide added resiliency and performance.

Usage might look something like the following.

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

- See additional [App Configuration Samples](https://github.com/Azure/AppConfiguration/tree/main/examples)
- Learn how to [integrate Azure App Configuration with Kubernetes deployments](/azure/azure-app-configuration/integrate-kubernetes-deployment-helm)
- Learn how Azure App Configuration also can help [manage feature flags](/azure/azure-app-configuration/manage-feature-flags)
- [Caching guidance](/azure/architecture/best-practices/caching): This guidance provides more information about how to cache data in a cloud solution, and problems to consider when you implement a cache.
- Review [Azure App Configuration best practices](/azure/azure-app-configuration/howto-best-practices)

## Related resources

- [Cache-aside pattern](./cache-aside.yml): This pattern describes how to load data on demand into a cache from a data store. This pattern also helps to maintain consistency between data that's held in the cache and the data in the original data store.
