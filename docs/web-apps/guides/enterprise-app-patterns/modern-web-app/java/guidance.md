---
title: Modern Web App Pattern for Java
description: Implement the Modern Web App pattern for Java. Get prescriptive architecture, code, and deployment guidance for scalable, decoupled cloud applications.
author: nishanil
ms.author: nanil
ms.reviewer: ssumner
ms.date: 11/7/2024
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom:
  - arb-web
  - devx-track-dotnet
---

# Modern Web App pattern for Java

This article describes how to implement the Modern Web App pattern. The Modern Web App pattern defines how to modernize cloud web apps and introduce a service-oriented architecture. The pattern provides prescriptive architecture, code, and configuration guidance that aligns with the principles of the [Azure Well-Architected Framework](/azure/well-architected/). This pattern builds on the [Reliable Web App pattern](../../overview.md#reliable-web-app-pattern).

## Benefits of the Modern Web App pattern

The Modern Web App pattern helps you optimize high-demand areas of your web application. It provides detailed guidance for decoupling these areas to enable independent scaling for cost optimization. This approach lets you allocate dedicated resources to critical components, which enhances overall performance. Decoupling separable services can improve reliability by preventing slowdowns in one part of the app from affecting others. It also enables independent versioning of individual app components.

## Implement the Modern Web App pattern

This article includes guidance for implementing the Modern Web App pattern. Use the following links for the specific guidance that you need:

- [Architecture guidance](#architecture-guidance): Learn how to modularize web app components and select appropriate platform as a service (PaaS) solutions.

- [Code guidance](#code-guidance): Implement the Strangler Fig, Queue-Based Load Leveling, Competing Consumers, and Health Endpoint Monitoring design patterns to optimize the decoupled components.

- [Configuration guidance](#configuration-guidance): Configure authentication, authorization, autoscaling, and containerization for the decoupled components.

> [!TIP]
> ![GitHub logo](../../../../../_images/github.svg) The [reference implementation](https://github.com/Azure/modern-web-app-pattern-java) (sample app) of the Modern Web App pattern represents the final state of the Modern Web App implementation. The production-grade web app features all the code, architecture, and configuration updates in this article. Deploy and use the reference implementation to guide your implementation of the Modern Web App pattern.

## Architecture guidance

The Modern Web App pattern builds on the Reliable Web App pattern. It requires a few extra architectural components. You need a message queue, container platform, storage service, and container registry, as shown in the following diagram.

:::image type="complex" border="false" source="../../../_images/modern-web-app-architecture.svg" alt-text="Diagram that shows the baseline architecture of the Modern Web App pattern." lightbox="../../../_images/modern-web-app-architecture.svg":::
   The architecture includes a web application hosted on Azure App Service, which communicates via a message queue service like Azure Service Bus. The message queue connects to a decoupled service that runs on a container platform like Azure Container Apps or Azure Kubernetes Service (AKS). Both the web app and the decoupled service access independent storage solutions, like Azure SQL Database and Azure Blob Storage. A container registry, like Azure Container Registry, stores container images for deployment. The architecture also features a load balancer that distributes incoming traffic to the web app and a virtual network that secures communication between all components.
:::image-end:::

For a higher service-level objective (SLO), you can add a second region to your web app architecture. Configure your load balancer to route traffic to the second region to support either an active-active or an active-passive configuration, depending on your business needs. Both regions require the same services, but one region includes a hub virtual network. Use a hub-and-spoke network topology to centralize and share resources, like a network firewall. Access the container repository through the hub virtual network. If you have virtual machines (VMs), add a bastion host to the hub virtual network to manage them with enhanced security. The following diagram shows this architecture.

:::image type="complex" border="false" source="../../../_images/modern-web-app-architecture-plus-optional.svg" alt-text="Diagram that shows the Modern Web App pattern architecture with a second region." lightbox="../../../_images/modern-web-app-architecture-plus-optional.svg":::
   Diagram that shows the Modern Web App pattern architecture with two Azure regions. Each region has a web application on App Service, a message queue service like Service Bus, a decoupled service on a container platform, and independent storage solutions. A load balancer directs traffic across both regions, which supports active-active or active-passive configurations. One region includes a hub virtual network that centralizes shared resources, like a network firewall and a bastion host for secure VM access. The container registry can be accessed through the hub network. Spoke virtual networks in each region isolate application resources and connect to the hub for shared services. The architecture supports cross-region failover, centralized security controls, and independent scaling of services in each region.
:::image-end:::

### Decouple the architecture

To implement the Modern Web App pattern, you must decouple the existing web app architecture. This approach breaks down a monolithic application into smaller, independent services. Each service handles a specific feature or function. This process includes evaluating the current web app, changing the architecture, and extracting the web app code to a container platform. The goal is to systematically identify and extract application services that benefit most from being decoupled. To decouple your architecture, follow these recommendations:

- *Identify service boundaries.* Apply domain-driven design principles to identify bounded contexts within your monolithic application. Each bounded context represents a logical boundary and is suitable for decoupling. Prioritize services that represent distinct business functions and have fewer dependencies.

- *Evaluate service benefits.* Focus on services that benefit most from independent scaling. For example, an external dependency like an email service provider in a line-of-business (LOB) application might require more isolation from failure. Consider services that undergo frequent updates or changes. Decouple these services to enable independent deployment and reduce the risk of affecting other parts of the application.

- *Assess technical feasibility.* Examine the current architecture to identify technical constraints and dependencies that might affect the decoupling process. Plan how to manage and share data across services. Decoupled services should manage their own data and minimize direct database access across service boundaries.

- *Deploy Azure services.* Select and deploy the Azure services that you need to support the web app service that you intend to extract. For more information, see [Select the right Azure services](#select-the-right-azure-services).

- *Decouple the web app service.* Define clear interfaces and APIs that the newly extracted web app services can use to interact with other parts of the system. Design a data-management strategy that lets each service manage its own data but ensures consistency and integrity. For more information about specific implementation strategies and design patterns during this extraction process, see [Code guidance](#code-guidance).

- *Use independent storage for decoupled services.* To simplify versioning and deployment, ensure that each decoupled service has its own data stores. For example, the reference implementation separates the email service from the web app and eliminates the need for the service to access the database. Instead, the service communicates the email delivery status back to the web app via an Azure Service Bus message, and the web app saves a note to its database.

- *Implement separate deployment pipelines for each decoupled service.* If you implement separate deployment pipelines, each service can be updated according to its own schedule. If different teams or organizations within your company own different services, using separate deployment pipelines gives each team control over its own deployments. Use continuous integration and continuous delivery (CI/CD) tools like Jenkins, GitHub Actions, or Azure Pipelines to set up these pipelines.

- *Revise security controls.* Ensure that your security controls are updated to account for the new architecture, including firewall rules and access controls.

### Select the right Azure services

For each Azure service in your architecture, consult the relevant [Azure service guide](/azure/well-architected/service-guides) in the Well-Architected Framework. For the Modern Web App pattern, you need a messaging system to support asynchronous messaging, an application platform that supports containerization, and a container image repository.

- *Choose a message queue.* A message queue is an important component of service-oriented architectures. It decouples message senders and receivers to enable [asynchronous messaging](/azure/architecture/guide/technology-choices/messaging). [Choose an Azure messaging service](/azure/service-bus-messaging/compare-messaging-services) that supports your design needs. Azure has three messaging services: Azure Event Grid, Azure Event Hubs, and Service Bus. Start with Service Bus, and use one of the other two options if Service Bus doesn't meet your needs.

    | Service | Use case |
    |-------|--------|
    | Service Bus | Choose Service Bus for reliable, ordered, and possibly transactional delivery of high-value messages in enterprise applications. |
    | Event Grid | Choose Event Grid when you need to handle a large number of discrete events efficiently. Event Grid is scalable for event-driven applications that route many small, independent events, like resource state changes, to subscribers by using a low-latency publish-subscribe model. |
    | Event Hubs | Choose Event Hubs for massive, high-throughput data ingestion, like telemetry, logs, or real-time analytics. Event Hubs is optimized for streaming scenarios that ingest and process bulk data continuously. |

- *Implement a container service.* For the elements of your application that you want to containerize, you need an application platform that supports containers. For more information, see [Choose an Azure container service](/azure/architecture/guide/choose-azure-container-service). Azure has three principal container services: Azure Container Apps, Azure Kubernetes Service (AKS), and Azure App Service. Start with Container Apps, and use one of the other two options if Container Apps doesn't meet your needs.

    | Service | Use case |
    |---|---|
    | Container Apps | Choose Container Apps if you need a serverless platform that automatically scales and manages containers in event-driven applications. |
    | AKS | Choose AKS if you need detailed control over Kubernetes configurations and advanced features for scaling, networking, and security. |
    | Web App for Containers | Choose Web App for Containers in App Service for the simplest PaaS experience. |

- *Implement a container repository.* When you use a container-based compute service, you must have a repository to store the container images. You can use a public container registry like Docker Hub or a managed registry like Azure Container Registry. For more information, see [Introduction to Container Registry](/azure/container-registry/container-registry-intro).

## Code guidance

To successfully decouple and extract an independent service, you must update your web app code with the Strangler Fig, Queue-Based Load Leveling, Competing Consumers, Health Endpoint Monitoring, and Retry patterns. The following diagram shows the roles of these patterns.

:::image type="complex" border="false" source="../../../_images/modern-web-app-design-patterns.svg" alt-text="Diagram that shows the role of the design patterns in the Modern Web App pattern architecture." lightbox="../../../_images/modern-web-app-design-patterns.svg":::
   In the diagram, the web application interacts with a message queue and a decoupled service. The Strangler Fig pattern directs requests from the web app to either the monolithic code or the decoupled service. The Queue-Based Load Leveling pattern buffers requests in the message queue before delivery to the decoupled service. The Competing Consumers pattern enables multiple instances of the decoupled service to process messages from the queue independently. The Health Endpoint Monitoring pattern exposes health check endpoints for both the web app and the decoupled service, which allows orchestrators to check service status. The Retry pattern applies to outbound calls from both the web app and the decoupled service, which ensures resilience against transient failures.
:::image-end:::

1. *Strangler Fig pattern:* The Strangler Fig pattern incrementally migrates functionality from a monolithic application to the decoupled service. Implement this pattern in the main web app to gradually migrate functionality to independent services by directing traffic based on endpoints.

1. *Queue-Based Load Leveling pattern:* The Queue-Based Load Leveling pattern manages the flow of messages between the producer and the consumer by using a queue as a buffer. Implement this pattern on the producer portion of the decoupled service to manage message flow asynchronously by using a queue.

1. *Competing Consumers pattern:* The Competing Consumers pattern enables multiple instances of a decoupled service to independently read from the same message queue and compete to process messages. Implement this pattern in the decoupled service to distribute tasks across multiple instances.

1. *Health Endpoint Monitoring pattern:* The Health Endpoint Monitoring pattern exposes endpoints for monitoring the status and health of different components of the web app. **(4a)** Implement this pattern in the main web app. **(4b)** Also implement it in the decoupled service to track the health of endpoints.

1. *Retry pattern:* The Retry pattern handles transient failures by retrying operations that might fail intermittently. **(5a)** Implement this pattern in the main web app, on all outbound calls to other Azure services, like calls to the message queue and private endpoints. **(5b)** Also implement this pattern in the decoupled service to handle transient failures in calls to the private endpoints.

Each design pattern provides benefits that align with one or more of the pillars of the Well-Architected Framework.

| Design pattern | Implementation location | Reliability (RE) | Security (SE) | Cost Optimization (CO) | Operational Excellence (OE) | Performance Efficiency (PE) | Supporting Well-Architected Framework principles |
|---|---|---|---|---|---|---|---|
| [Strangler Fig pattern](#implement-the-strangler-fig-pattern) | Main web app | ✔ |  | ✔ | ✔ |  | [RE:08](/azure/well-architected/reliability/testing-strategy) <br> [CO:07](/azure/well-architected/cost-optimization/optimize-component-costs) <br> [CO:08](/azure/well-architected/cost-optimization/optimize-environment-costs) <br> [OE:06](/azure/well-architected/operational-excellence/workload-supply-chain) <br> [OE:11](/azure/well-architected/operational-excellence/safe-deployments) |
| [Queue-Based Load Leveling pattern](#implement-the-queue-based-load-leveling-pattern) | Producer of decoupled service | ✔ |  | ✔ |  | ✔ | [RE:06](/azure/well-architected/reliability/scaling) <br> [RE:07](/azure/well-architected/reliability/self-preservation) <br> [CO:12](/azure/well-architected/cost-optimization/optimize-scaling-costs) <br> [PE:05](/azure/well-architected/performance-efficiency/scale-partition) |
| [Competing Consumers pattern](#implement-the-competing-consumers-pattern) | Decoupled service | ✔ |  | ✔ |  | ✔ | [RE:05](/azure/well-architected/reliability/redundancy) <br> [RE:07](/azure/well-architected/reliability/self-preservation) <br> [CO:05](/azure/well-architected/cost-optimization/get-best-rates) <br> [CO:07](/azure/well-architected/cost-optimization/optimize-component-costs) <br> [PE:05](/azure/well-architected/performance-efficiency/scale-partition) <br> [PE:07](/azure/well-architected/performance-efficiency/optimize-code-infrastructure) |
| [Health Endpoint Monitoring pattern](#implement-the-health-endpoint-monitoring-pattern) | Main web app and decoupled service | ✔ |  |  | ✔ | ✔ | [RE:07](/azure/well-architected/reliability/self-preservation) <br> [RE:10](/azure/well-architected/reliability/monitoring-alerting-strategy) <br> [OE:07](/azure/well-architected/operational-excellence/observability) <br> [PE:05](/azure/well-architected/performance-efficiency/scale-partition) |
| [Retry pattern](#implement-the-retry-pattern) | Main web app and decoupled service | ✔ |  |  |  |  | [RE:07](/azure/well-architected/reliability/self-preservation) |

### Implement the Strangler Fig pattern

Use the [Strangler Fig pattern](/azure/architecture/patterns/strangler-fig) to gradually migrate functionality from the monolithic code base to new independent services. Extract new services from the existing monolithic code base and slowly modernize critical parts of the web app. To implement the Strangler Fig pattern, follow these recommendations:

- *Set up a routing layer.* In the monolithic web app code base, implement a routing layer that directs traffic based on endpoints. Use custom routing logic as needed to handle specific business rules for directing traffic. For example, if you have a `/users` endpoint in your monolithic app and you move that functionality to the decoupled service, the routing layer directs all requests to `/users` to the new service.

- *Manage feature rollout.* [Implement feature flags](/azure/azure-app-configuration/use-feature-flags-spring-boot) and [staged rollout](/azure/azure-app-configuration/howto-targetingfilter) to gradually roll out the decoupled services. The existing monolithic app routing should control how many requests the decoupled services receive. Start with a small percentage of requests and increase usage over time as you gain confidence in the service's stability and performance.

  For example, the reference implementation extracts the email delivery functionality into a standalone service. The service can be gradually introduced to handle a larger percentage of the requests to send emails that contain Contoso support guides. As the new service proves its reliability and performance, it can eventually take over the entire set of email responsibilities from the monolith, which completes the transition.

- *Use a façade service if necessary.* A façade service is useful when a single request needs to interact with multiple services or when you want to hide the complexity of the underlying system from the client. But if the decoupled service doesn't have any public-facing APIs, a façade service might not be necessary.

  In the monolithic web app code base, implement a façade service to route requests to the appropriate back end (monolith or microservice). Ensure that the new decoupled service can handle requests independently when it's accessed through the façade.

### Implement the Queue-Based Load Leveling pattern

Implement the [Queue-Based Load Leveling pattern](/azure/architecture/patterns/queue-based-load-leveling) on the producer portion of the decoupled service to asynchronously handle tasks that don't need immediate responses. This pattern enhances overall system responsiveness and scalability by using a queue to manage workload distribution. It enables the decoupled service to process requests at a consistent rate. To implement this pattern effectively, follow these recommendations:

- *Use nonblocking message queuing.* Ensure that the process that sends messages to the queue doesn't block other processes while it waits for the decoupled service to handle messages in the queue. If the process requires the result of the decoupled-service operation, implement an alternative way to handle the situation while waiting for the queued operation to finish. For example, in Spring Boot, you can use the `StreamBridge` class to asynchronously publish messages to the queue without blocking the calling thread:

    ```java
    private final StreamBridge streamBridge;

    public SupportGuideQueueSender(StreamBridge streamBridge) {
        this.streamBridge = streamBridge;
    }

    // Asynchronously publish a message without blocking the calling thread
    @Override
    public void send(String to, String guideUrl, Long requestId) {
        EmailRequest emailRequest = EmailRequest.newBuilder()
                .setRequestId(requestId)
                .setEmailAddress(to)
                .setUrlToManual(guideUrl)
                .build();

        log.info("EmailRequest: {}", emailRequest);

        var message = emailRequest.toByteArray();
        streamBridge.send(EMAIL_REQUEST_QUEUE, message);

        log.info("Message sent to the queue");
    }
    ```

    This Java example uses `StreamBridge` to send messages asynchronously. This approach ensures that the main application remains responsive and can handle other tasks concurrently while the decoupled service processes the queued requests at a manageable rate.

- *Implement message retry and removal.* Implement a mechanism to retry processing of queued messages that can't be processed successfully. If failures persist, these messages should be removed from the queue. For example, Service Bus has built-in retry and dead-letter queue features.

- *Configure idempotent message processing.* The logic that processes messages from the queue must be idempotent to handle cases in which a message might be processed more than once. In Spring Boot, you can use `@StreamListener` or `@KafkaListener` with a unique message identifier to prevent duplicate processing. Or you can organize the business process to operate in a functional approach with Spring Cloud Stream, where the `consume` method is defined in a way that produces the same result when it runs repeatedly. For a list of settings that manage the behavior of message consumption, see [Spring Cloud Stream with Service Bus](/azure/developer/java/spring-framework/configure-spring-cloud-stream-binder-java-app-with-service-bus?tabs=use-a-service-bus-queue).

- *Manage changes to the user experience.* When you use asynchronous processing, tasks might not be finished immediately. To set expectations and avoid confusion, ensure that users know when their tasks are being processed. Use visual cues or messages to indicate that a task is in progress. Give users the option to receive notifications when their task is complete, like an email or push notification.

### Implement the Competing Consumers pattern

Implement the [Competing Consumers pattern](/azure/architecture/patterns/competing-consumers) in the decoupled service to manage incoming tasks from the message queue. This pattern involves distributing tasks across multiple instances of decoupled services. These services process messages from the queue. The pattern enhances load balancing and increases the system's capacity for handling simultaneous requests. The Competing Consumers pattern is effective when the following factors apply:

- The sequence of message processing isn't crucial.

- The queue remains unaffected by malformed messages.

- The processing operation is idempotent, which means that it can be applied multiple times without changing the result after the initial application.

To implement the Competing Consumers pattern, follow these recommendations:

- *Handle concurrent messages.* When services receive messages from a queue, ensure that your system scales predictably by configuring the concurrency to match the system design. Load test results can help you determine the appropriate number of concurrent messages to handle. You can start with a single message to measure how the system performs.

- *Disable prefetching.* Disable prefetching of messages so that consumers only fetch messages when they're ready.

- *Use reliable message processing modes.* Use a reliable processing mode, like peek-lock, that automatically retries messages that fail processing. This mode provides more reliability than deletion-first methods. If one worker fails to handle a message, another worker must be able to process it without errors, even if the message is processed multiple times.

- *Implement error handling.* Route malformed or unprocessable messages to a separate dead-letter queue. This design prevents repetitive processing. For example, you can catch exceptions during message processing and move problematic messages to the separate queue. Service Bus moves messages to the dead-letter queue after a specified number of delivery attempts or after explicit rejection by the application.

- *Handle out-of-order messages.* Design consumers to process messages that arrive out of sequence. When you have multiple parallel consumers, they might process messages out of order.

- *Scale based on queue length.* Services that consume messages from a queue should autoscale based on queue length. Scale-based autoscaling enables efficient processing during spikes in incoming messages.

- *Use a message-reply queue.* If your system requires notifications for post-message processing, set up a dedicated reply or response queue. This setup separates operational messaging from notification processes.

- *Use stateless services.* Consider using stateless services to process requests from a queue. This approach enables easy scaling and efficient resource usage.

- *Configure logging.* Integrate logging and specific exception handling within the message-processing workflow. Focus on capturing serialization errors and directing these problematic messages to a dead-letter mechanism. These logs provide valuable insights for troubleshooting.

The reference implementation uses the Competing Consumers pattern on a stateless service that runs in Container Apps to process email delivery requests from a Service Bus queue.

The processor logs message processing details to help with troubleshooting and monitoring. It captures deserialization errors and provides insights to support debugging. The service scales at the container level to enable efficient handling of message spikes based on queue length:

```java
@Configuration
public class EmailProcessor {

    private static final Logger log = LoggerFactory.getLogger(EmailProcessor.class);

    @Bean
    Function<byte[], byte[]> consume() {
        return message -> {

            log.info("New message received");

            try {
                EmailRequest emailRequest = EmailRequest.parseFrom(message);
                log.info("EmailRequest: {}", emailRequest);

                EmailResponse emailResponse = EmailResponse.newBuilder()
                        .setEmailAddress(emailRequest.getEmailAddress())
                        .setUrlToManual(emailRequest.getUrlToManual())
                        .setRequestId(emailRequest.getRequestId())
                        .setMessage("Email sent to " + emailRequest.getEmailAddress() + " with URL to manual " + emailRequest.getUrlToManual())
                        .setStatus(Status.SUCCESS)
                        .build();

                return emailResponse.toByteArray();

            } catch (InvalidProtocolBufferException e) {
                throw new RuntimeException("Error parsing email request message", e);
            }
        };
    }
}
```

### Implement the Health Endpoint Monitoring pattern

Implement the [Health Endpoint Monitoring pattern](/azure/architecture/patterns/health-endpoint-monitoring) in the main app code and decoupled service code to track the health of application endpoints. Orchestrators like AKS or Container Apps can poll these endpoints to check service health and restart unhealthy instances. Spring Boot Actuator provides built-in support for health checks. It can expose health check endpoints for key dependencies like databases, message brokers, and storage systems. To implement the Health Endpoint Monitoring pattern, follow these recommendations:

- *Implement health checks.* Use Spring Boot Actuator to provide health check endpoints. Actuator exposes an `/actuator/health` endpoint that includes built-in health indicators and custom checks for various dependencies. To enable the health endpoint, add the `spring-boot-starter-actuator` dependency in your `pom.xml` or `build.gradle` file:

    ```xml
    <!-- Add Spring Boot Actuator dependency -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-actuator</artifactId>
    </dependency>
    ```

    Configure the health endpoint in `application.properties` as shown in the reference implementation:

    ```txt
        management.endpoints.web.exposure.include=metrics,health,info,retry,retryevents
    ```

- *Validate dependencies.* Spring Boot Actuator includes health indicators for various dependencies like databases, message brokers (RabbitMQ or Kafka), and storage services. To validate the availability of Azure services like Azure Blob Storage or Service Bus, use technologies like Azure Spring Apps or Micrometer, which provide health indicators for these services. If you need custom checks, you can implement them by creating a custom `HealthIndicator` bean:

    ```java
    import org.springframework.boot.actuate.health.Health;
    import org.springframework.boot.actuate.health.HealthIndicator;
    import org.springframework.stereotype.Component;

    @Component
    public class CustomAzureServiceBusHealthIndicator implements HealthIndicator {
        @Override
        public Health health() {
            // Implement your health check logic here (for example, ping Service Bus).
            boolean isServiceBusHealthy = checkServiceBusHealth();
            return isServiceBusHealthy ? Health.up().build() : Health.down().build();
        }

        private boolean checkServiceBusHealth() {
            // Implement health check logic (pinging or connecting to the service).
            return true; // Placeholder. Implement the actual logic.
        }
    }
    ```

- *Configure Azure resources.* Configure the Azure resource to use the app's health check URLs to confirm liveness and readiness. For example, you can use Terraform to confirm the liveness and readiness of apps that are deployed to Container Apps. For more information, see [Health probes in Container Apps](/azure/container-apps/health-probes).

### Implement the Retry pattern

The [Retry pattern](/azure/architecture/patterns/retry) lets applications recover from transient faults. This pattern is central to the Reliable Web App pattern, so your web app should already be using the Retry pattern. Apply the Retry pattern to requests to the messaging systems and requests that are issued by the decoupled services that you extract from the web app. To implement the Retry pattern, follow these recommendations:

- *Configure retry options.* Apply appropriate retry settings to the client that's responsible for interactions with the message queue. Specify parameters like the maximum number of retries, delay between retries, and maximum delay.

- *Use exponential backoff.* Implement the exponential backoff strategy for retry attempts. This strategy involves increasing the time between each retry exponentially, which helps reduce the load on the system during periods of high failure rates.

- *Use SDK retry functionality.* For services that have specialized SDKs, like Service Bus or Blob Storage, use the built-in retry mechanisms. These built-in mechanisms are optimized for the service's typical use cases, can handle retries more effectively, and require less configuration.

- *Use standard resilience libraries for HTTP clients.* For HTTP clients, you can use [Resilience4j](https://resilience4j.readme.io/docs/getting-started) together with Spring's RestTemplate or WebClient to handle retries in HTTP communications. You can wrap RestTemplate with Resilience4j's retry logic to handle transient HTTP errors effectively.

- *Handle message locking.* For message-based systems, implement message handling strategies that support retries without data loss. For example, use peek-lock modes when they're available. Ensure that failed messages are retried effectively and moved to a dead-letter queue after repeated failures.

## Configuration guidance

The following sections provide guidance for implementing the configuration updates. Each section aligns with one or more of the pillars of the Well-Architected Framework.

| Configuration | Reliability (RE) | Security (SE) | Cost Optimization (CO) | Operational Excellence (OE) | Performance Efficiency (PE) | Supporting Well-Architected Framework principles |
|---|---|---|---|---|---| --- |
| [Configure authentication and authorization](#configure-authentication-and-authorization) | | ✔ | | ✔ | | [SE:05](/azure/well-architected/security/identity-access) <br> [OE:10](/azure/well-architected/operational-excellence/enable-automation#authentication-and-authorization)
| [Implement independent autoscaling](#configure-independent-autoscaling) | ✔ | | ✔ | | ✔ | [RE:06](/azure/well-architected/reliability/scaling) <br> [CO:12](/azure/well-architected/cost-optimization/optimize-scaling-costs) <br> [PE:05](/azure/well-architected/performance-efficiency/scale-partition) |
| [Containerize service deployment](#containerize-service-deployment) | | | ✔ | | ✔ | [CO:13](/azure/well-architected/cost-optimization/optimize-personnel-time) <br> [PE:09](/azure/well-architected/performance-efficiency/prioritize-critical-flows#isolate-critical-flows) <br> [PE:03](/azure/well-architected/performance-efficiency/select-services#evaluate-compute-requirements) |

### Configure authentication and authorization

To configure authentication and authorization on any new Azure services (*workload identities*) that you add to the web app, follow these recommendations:

- *Use managed identities for each new service.* Each independent service should have its own identity and use managed identities for service-to-service authentication. Managed identities eliminate the need to manage credentials in your code and reduce the risk of credential leakage. They help you avoid including sensitive information like connection strings in your code or configuration files.

- *Grant least privilege to each new service.* Assign only necessary permissions to each new service identity. For example, if an identity only needs to push to a container registry, don't give it pull permissions. Review these permissions regularly and adjust them as needed. Use different identities for different roles, like deployment and the application. This approach limits the potential damage if one identity is compromised.

- *Use infrastructure as code (IaC).* Use Bicep or a similar IaC tool like Terraform to define and manage your cloud resources. IaC ensures consistent application of security configurations in your deployments and lets you version control your infrastructure setup.

To configure authentication and authorization on users (*user identities*), follow these recommendations:

- *Grant least privilege to users.* Like with services, ensure that users have only the permissions that they need to perform their tasks. Regularly review and adjust these permissions.

- *Conduct regular security audits.* Regularly review and audit your security setup. Look for misconfigurations and unnecessary permissions and rectify or remove them immediately.

The reference implementation uses IaC to assign managed identities to added services and specific roles to each identity. It defines roles and permissions access for deployment by defining roles for Container Registry pushes and pulls:

```terraform
resource "azurerm_role_assignment" "container_app_acr_pull" {
  principal_id         = var.aca_identity_principal_id
  role_definition_name = "AcrPull"
  scope                = azurerm_container_registry.acr.id
}

resource "azurerm_user_assigned_identity" "container_registry_user_assigned_identity" {
  name                = "ContainerRegistryUserAssignedIdentity"
  resource_group_name = var.resource_group
  location            = var.location
}

resource "azurerm_role_assignment" "container_registry_user_assigned_identity_acr_pull" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.container_registry_user_assigned_identity.principal_id
}


# For demo purposes, allow the current user to access the container registry.
# Note: When running as a service principal, this is also needed.
resource "azurerm_role_assignment" "acr_contributor_user_role_assignement" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "Contributor"
  principal_id         = data.azuread_client_config.current.object_id
}
```

### Configure independent autoscaling

The Modern Web App pattern breaks up the monolithic architecture and introduces service decoupling. When you decouple a web app architecture, you can scale decoupled services independently. Scale the Azure services to support an independent web app service, rather than an entire web app, to optimize scaling costs while meeting demands. To autoscale containers, follow these recommendations:

- *Use stateless services.* Ensure that your services are stateless. If your web app contains in-process session state, externalize it to a distributed cache like Azure Managed Redis or a database like SQL Server.

- *Configure autoscaling rules.* Use the autoscaling configurations that provide the most cost-effective control over your services. For containerized services, event-based scaling, like Kubernetes Event-Driven Autoscaler (KEDA), often provides granular control that lets you scale based on event metrics. [Container Apps](/azure/container-apps/scale-app) and AKS support KEDA. For services that don't support KEDA, like [App Service](/azure/app-service/manage-automatic-scaling), use the autoscaling features provided by the platform itself. These features often include scaling based on metrics-based rules or HTTP traffic.

- *Configure minimum replicas.* To prevent cold starts, configure autoscaling settings to maintain a minimum of one replica. A cold start is the initialization of a service from a stopped state. A cold start often delays the response. If minimizing costs is a priority and you can tolerate cold start delays, set the minimum replica count to 0 when you configure autoscaling.

- *Configure a cooldown period.* Apply an appropriate cooldown period to introduce a delay between scaling events. The goal is to [prevent the system from scaling excessively](/azure/well-architected/cost-optimization/optimize-scaling-costs#optimize-autoscaling) in response to temporary load spikes.

- *Configure queue-based scaling.* If your application uses a message queue like Service Bus, configure your autoscaling settings to scale based on the length of the request message queue. The scaler attempts to maintain one replica of the service for every *N* message in the queue (rounded up).

For example, the reference implementation uses the Service Bus KEDA scaler to automatically scale Container Apps based on the length of the Service Bus queue. The scaling rule, named `service-bus-queue-length-rule`, adjusts the number of service replicas based on the message count in the specified Service Bus queue. The `messageCount` parameter is set to 10, which configures the scaler to add one replica for every 10 messages in the queue. The maximum replica count (`max_replicas`) is set to 10. The minimum replica count is implicitly 0 unless it's overridden. This configuration lets the service scale down to zero when there are no messages in the queue. The connection string for the Service Bus queue is stored as a secret in Azure, named `azure-servicebus-connection-string`, which is used to authenticate the scaler to the Service Bus. Here's the Terraform code:

```terraform
    max_replicas = 10
    min_replicas = 1

    custom_scale_rule {
      name             = "service-bus-queue-length-rule"
      custom_rule_type = "azure-servicebus"
      metadata = {
        messageCount = 10
        namespace    = var.servicebus_namespace
        queueName    = var.email_request_queue_name
      }
      authentication {
        secret_name       = "azure-servicebus-connection-string"
        trigger_parameter = "connection"
      }
    }
```

### Containerize service deployment

Containerization encapsulates all dependencies needed by the app in a lightweight image that can be reliably deployed to a wide range of hosts. To containerize deployment, follow these recommendations:

- *Identify domain boundaries.* Start by identifying the domain boundaries in your monolithic application. This approach helps you determine which parts of the application you can extract into separate services.

- *Create Docker images.* When you create Docker images for your Java services, use official OpenJDK base images. These images contain only the minimal set of packages that Java needs to run. They minimize both the package size and the attack surface area.

- *Use multistage Dockerfiles.* Use a multistage Dockerfile to separate build-time assets from the runtime container image. This type of file helps keep your production images small and secure. You can also use a preconfigured build server and copy the JAR file into the container image.

- *Run as a nonroot user.* Run your Java containers as a nonroot user (via user name or `UID $APP_UID`) to align with the principle of least privilege (PoLP). This approach limits the potential effects of a compromised container.

- *Listen on port 8080.* When you run containers as a nonroot user, configure your application to listen on port 8080. This practice is common for nonroot users.

- *Encapsulate dependencies.* Ensure that all dependencies that the app needs are encapsulated in the Docker container image. Encapsulation lets the app be reliably deployed to a wide range of hosts.

- *Choose the right base images.* The base image that you choose depends on your deployment environment. For example, if you deploy to Container Apps, you must use Linux Docker images.

The reference implementation demonstrates a Docker build process for containerizing a Java application. The Dockerfile uses a single-stage build with the OpenJDK base image (`mcr.microsoft.com/openjdk/jdk:17-ubuntu`), which provides the necessary Java runtime environment.

The Dockerfile includes the following steps:

1. *Declare the volume.* A temporary volume (`/tmp`) is defined. This volume provides temporary file storage that's separate from the container's main file system.

1. *Copy artifacts.* The application's JAR file (`email-processor.jar`) is copied into the container, together with the Application Insights agent (`applicationinsights-agent.jar`) that's used for monitoring.

1. *Set the entrypoint.* The container is configured to run the application with the Application Insights agent enabled. The code uses `java -javaagent` to monitor the application during runtime.

The Dockerfile keeps the image small by only including runtime dependencies. It's suitable for deployment environments like Container Apps that support Linux-based containers.

```dockerfile

# Use the OpenJDK 17 base image on Ubuntu as the foundation.
FROM mcr.microsoft.com/openjdk/jdk:17-ubuntu

# Set a working directory.
WORKDIR /app

# Define a volume for temporary files.
VOLUME /tmp

# Copy the packaged JAR file into the container.
COPY target/email-processor.jar app.jar

# Copy the Application Insights agent for monitoring.
COPY target/agent/applicationinsights-agent.jar applicationinsights-agent.jar

# Create a nonroot user and switch to it.
RUN useradd -m appuser && chown -R appuser /app
USER appuser

# Set the entrypoint to run the application with the Application Insights agent.
ENTRYPOINT ["java", "-javaagent:applicationinsights-agent.jar", "-jar", "app.jar"]

```

## Deploy the reference implementation

Deploy the reference implementation of the [Modern Web App pattern for Java](https://github.com/azure/modern-web-app-pattern-java). The repository includes instructions for both development and production deployment. After you deploy the implementation, you can simulate and observe design patterns.

The following diagram shows the architecture of the reference implementation.

:::image type="complex" border="false" source="../../../_images/modern-web-app-java.svg" alt-text="Diagram that shows an architecture of the reference implementation." lightbox="../../../_images/modern-web-app-java.svg":::
  In the diagram, a user accesses the web app through a browser, which routes requests to Azure Front Door for global load balancing and security. Azure Front Door forwards traffic to App Service, which hosts the main web application. The web app interacts with Azure SQL Database for persistent data storage and Azure Managed Redis for distributed caching. The application sends asynchronous tasks, such as email delivery, to Service Bus queues. Decoupled microservices, deployed in Container Apps, consume messages from the queue and process tasks independently. The architecture includes monitoring and logging through Application Insights and uses managed identities for secure service-to-service authentication.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/modern-web-app-java.vsdx) of this architecture.*

## Next step

- [Modern Web App pattern for Java reference implementation](https://github.com/Azure/modern-web-app-pattern-java)
