[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This solution uses Azure Cache for Redis to route real-time messages in publish and subscribe systems. It also scales up web communication frameworks like Azure SignalR Service.

## Architecture

![Architecture Diagram](../media/messaging.png)
*Download an [SVG](../media/messaging.svg) of this architecture.*

### Dataflow

1. The publishers send messages to Azure Cache for Redis.
1. Azure Cache for Redis stores these messages and manages the delivery to the subscribers.
1. The subscribers pull messages that they've subscribed to from Azure Cache for Redis.

### Components

Key technologies used to implement this architecture:

- [Azure Cache for Redis](https://azure.microsoft.com/services/cache) is a fully managed, in-memory cache that enables high-performance and scalable architectures. You can use it to create cloud or hybrid deployments that handle millions of requests per second at submillisecond latency – all with the configuration, security, and availability benefits of a managed service.
- [Azure App Service](https://azure.microsoft.com/services/app-service) is an HTTP-based service for hosting web applications, REST APIs, and mobile back ends. You can develop in your favorite language, be it .NET, Java, Ruby, Node.js, PHP, or Python. Applications run and scale with ease on both Windows and Linux-based environments.

## Scenario details

This scenario demonstrates how to use Azure Cache for Redis as a message broker to implement a publish/subscribe asynchronous messaging capability. It's ideal for routing real-time messages and scaling up web communication frameworks such as SignalR.

## Next steps

- [About Azure Cache for Redis](/azure/azure-cache-for-redis/cache-overview)
- [What is Azure SignalR Service?](/azure/azure-signalr/signalr-overview)
- [App Service overview](/azure/app-service/overview)

## Related resources

- [Asynchronous messaging options in Azure](../../guide/technology-choices/messaging.yml)
- [Caching guidance](../../best-practices/caching.yml)
