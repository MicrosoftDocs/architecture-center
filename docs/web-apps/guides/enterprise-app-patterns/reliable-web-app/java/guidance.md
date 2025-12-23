---
title: Reliable Web App Pattern for Java
description: Implement the Reliable Web App pattern for Java. Get essential guidance for migrating web apps to the cloud. Learn how to replatform web apps.
author: nishanil
ms.author: nanil
ms.reviewer: ssumner
ms.date: 10/15/2024
ms.topic: concept-article
ms.subservice: architecture-guide
ms.custom:
  - arb-web
  - devx-track-dotnet
  - sfi-ropc-nochange
ms.collection:
  - migration
  - onprem-to-azure
---

# Reliable Web App pattern for Java

[!INCLUDE [intro 1](../includes/intro-1.md)]

## Why use the Reliable Web App pattern for Java?

The Reliable Web App pattern is a set of principles and implementation techniques that define how to replatform web apps when you migrate them to the cloud. It emphasizes minimal code updates to ensure success in the cloud. This guidance uses a reference implementation as a consistent example throughout. It follows the replatforming journey of the fictional company Contoso Fiber to provide business context for your own migration. Before Contoso Fiber implements the Reliable Web App pattern for Java, it operates a monolithic, on-premises Customer Account Management System (CAMS) built with the Spring Boot framework.

> [!TIP]
> ![GitHub logo.](../../../../../_images/github.svg) The [reference implementation](https://github.com/azure/reliable-web-app-pattern-java) (sample) of the Reliable Web App pattern represents the final state of a completed implementation. This production-grade web app includes all the code, architecture, and configuration updates described in this article. Deploy and use the reference implementation to help guide your own implementation of the Reliable Web App pattern.

[!INCLUDE [intro 2](../includes/intro-2.md)]

## Business context

The first step in replatforming a web app is to define your business objectives. Set immediate goals such as service-level objectives (SLOs) and cost optimization targets, along with future goals for your web application. These objectives influence your choice of cloud services and the architecture of your application in the cloud. Define a target SLO for your web app, such as 99.9% uptime. Calculate the [composite service-level agreement (SLA)](/azure/cloud-adoption-framework/manage/protect#manage-cloud-resources-reliability) for all the services that affect the availability of your web app.

Contoso Fiber wants to expand its on-premises CAMS web app to reach other regions. To meet the increased demand on the web app, the company establishes the following goals:

- Apply low-cost, high-value code changes.
- Reach an SLO of 99.9%.
- Adopt DevOps practices.
- Create cost-optimized environments.
- Improve reliability and security.

Contoso Fiber determines that its on-premises infrastructure isn't a cost-effective solution for scaling the application. The company decides that migrating the CAMS web application to Azure is the most cost-effective way to achieve its immediate and future objectives.

## Architecture guidance

[!INCLUDE [reliable web app pattern architecture updates](../includes/architecture-updates.md)]

### Select the right Azure services

When you move a web app to the cloud, choose Azure services that meet your business requirements and align with the features of the on-premises web app. This alignment helps minimize the replatforming effort. For example, use services that allow you to keep the same database engine and support existing middleware and frameworks.

Before migration, Contoso Fiber's CAMS web app is an on-premises, monolithic Java application. It's a Spring Boot app with a PostgreSQL database. The web app is a line-of-business (LOB) support app for employees. They use it to manage customer support cases. The app experiences common challenges with scalability and feature deployment. This starting point, along with business goals and SLOs, influences their service choices.

The following list provides guidance to select the right Azure services for your web app and describes why Contoso Fiber selects specific services:

- *Application platform:* Use [Azure App Service](/azure/app-service/overview) as your application platform. Contoso Fiber uses App Service for the following reasons:

  - *Natural progression:* Contoso Fiber deploys a Spring Boot JAR file on its on-premises server and wants to minimize the amount of rearchitecting for that deployment model. App Service provides robust support to run Spring Boot apps, which makes it a suitable option. Azure Container Apps is also a suitable option for this application. For more information, see [Container Apps overview](/azure/container-apps/overview) and [Java on Container Apps overview](/azure/container-apps/java-overview/).

  - *High SLA:* App Service provides a high SLA that meets production requirements.

  - *Reduced management overhead:* App Service is a managed hosting solution.

  - *Containerization capability:* App Service integrates with private container image registries like Azure Container Registry. Contoso Fiber can use these registries to containerize the web app in the future.

  - *Autoscaling:* The web app can rapidly scale up, scale down, scale in, and scale out based on user traffic.

- *Identity management:* Use [Microsoft Entra ID](/entra/fundamentals/what-is-entra) as your identity and access management solution. Contoso Fiber uses Microsoft Entra ID for the following reasons:

  - *Authentication and authorization:* The application needs to authenticate and authorize call center employees.

  - *Scalability:* Microsoft Entra ID scales to support larger scenarios.

  - *User-identity control:* Call center employees can use their existing enterprise identities.

  - *Authorization protocol support:* Microsoft Entra ID supports OAuth 2.0 for managed identities.

- *Database:* Use a service that lets you keep the same database engine. Use the [data store decision tree](/azure/architecture/guide/technology-choices/data-stores-getting-started) to guide your selection. Contoso Fiber uses the Azure Database for PostgreSQL flexible server deployment model for the following reasons:

  - *Reliability:* The flexible server deployment model supports zone-redundant high availability across multiple availability zones. This configuration maintains a warm standby server in a different availability zone within the same Azure region. The configuration replicates data synchronously to the standby server.

  - *Cross-region replication:* Azure Database for PostgreSQL provides a read replica feature to asynchronously replicate data to a [read-only replica database in another region](/azure/postgresql/flexible-server/concepts-read-replicas).

  - *Performance:* Azure Database for PostgreSQL provides predictable performance and intelligent tuning that improves database performance by using real usage data.

  - *Reduced management overhead:* This managed Azure service reduces management obligations.

  - *Migration support:* It supports database migration from on-premises single-server PostgreSQL databases. Contoso Fiber can use the [migration tool](/azure/postgresql/migrate/migration-service/overview-migration-service-postgresql) to simplify the migration process.

  - *Consistency with on-premises configurations:* It supports [different community versions of PostgreSQL](/azure/postgresql/flexible-server/concepts-supported-versions), including the version that Contoso Fiber currently uses.

  - *Recoverability:* The flexible server deployment automatically creates [server backups](/azure/postgresql/flexible-server/concepts-backup-restore) and stores them in zone-redundant storage (ZRS) within the same region. Contoso Fiber can restore the database to any point in time within the backup retention period. The backup and restoration capability creates a better RPO compared to on-premises environments.

- *Application performance monitoring:* Use [Application Insights](/azure/azure-monitor/app/app-insights-overview) to analyze telemetry on your application. Contoso Fiber uses Application Insights for the following reasons:

  - *Integration with Azure Monitor:* It provides the best integration with Azure Monitor.

  - *Anomaly detection:* It automatically detects performance anomalies.

  - *Troubleshooting:* It helps diagnose problems in the running app.

  - *Monitoring:* It collects usage data for the app and tracks custom events.

  - *Visibility gap:* The on-premises solution doesn't have an application performance monitoring solution. Application Insights provides easy integration with the application platform and code.

- *Cache:* Choose whether to add a cache to your web app architecture. [Azure Managed Redis](/azure/redis/overview) is the primary Azure cache solution. It's a managed in-memory data store based on the Redis software. Contoso Fiber adds Azure Managed Redis for the following reasons:

  - *Speed and volume:* It provides high-data throughput and low-latency reads for frequently accessed, slow-changing data.

  - *Diverse supportability:* It's a unified cache location that all instances of the web app can use.

  - *External data store:* The on-premises application servers use VM-local caching. This setup doesn't offload frequently accessed data and can't invalidate stale data.

  - *Nonsticky sessions:* The cache lets the web app externalize session state and use nonsticky sessions. Most Java web apps that run on-premises rely on in-memory client-side caching. This approach doesn't scale well and increases the memory footprint on the host. Azure Managed Redis provides a managed, scalable cache service to improve the scalability and performance of applications. Contoso Fiber used Spring Cache as their cache abstraction framework and needed only minimal configuration changes to switch from an Ehcache provider to the Redis provider.

- *Load balancer:* Web applications that use platform as a service (PaaS) solutions should use Azure Front Door, Azure Application Gateway, or both, depending on the web app architecture and requirements. Use the [load balancer decision tree](/azure/architecture/guide/technology-choices/load-balancing-overview) to select the right load balancer. Contoso Fiber needs a layer-7 load balancer that can route traffic across multiple regions and a multiregion web app to meet the SLO of 99.9%. The company uses [Azure Front Door](/azure/frontdoor/front-door-overview) for the following reasons:

  - *Global load balancing:* This layer-7 load balancer can route traffic across multiple regions.

  - *Web application firewall:* It integrates natively with Azure Web Application Firewall.

  - *Routing flexibility:* It allows the application team to configure ingress needs to support future changes in the application.

  - *Traffic acceleration:* It uses anycast routing to reach the nearest Azure point of presence and find the fastest route to the web app.

  - *Custom domains:* It supports custom domain names with flexible domain validation.

  - *Health probes:* The application needs intelligent health probe monitoring. Azure Front Door uses responses from the probe to determine the best origin for routing client requests.

  - *Monitoring support:* Azure Front Door supports built-in reports with an all-in-one dashboard for both Azure Front Door and security patterns. It provides alerts that integrate with Azure Monitor. Azure Front Door lets the application log each request and failed health probes.

  - *Distributed denial-of-service (DDoS) protection:* It has built-in DDoS protection at layer 3 and layer 4.

  - *Content delivery network:* It positions Contoso Fiber to use a content delivery network. The content delivery network provides site acceleration.

- *Web application firewall:* Use [Azure Web Application Firewall](/azure/web-application-firewall/overview) to provide centralized protection from common web exploits and vulnerabilities. Contoso Fiber uses Azure Web Application Firewall for the following reasons:

  - *Global protection:* It provides improved global web app protection while maintaining performance.

  - *Botnet protection:* The team can monitor and configure settings to address security concerns related to botnets.

  - *Parity with on-premises:* The on-premises solution runs behind a web application firewall that IT manages.

  - *Ease of use:* Azure Web Application Firewall integrates with Azure Front Door.

- *Secrets manager:* Use [Azure Key Vault](/azure/key-vault/general/overview) if you have secrets to manage in Azure. Contoso Fiber uses Key Vault for the following reasons:

  - *Encryption:* It supports encryption at rest and in transit.

  - *Managed identity support:* The application services can use managed identities to access the secret store.

  - *Monitoring and logging:* Key Vault facilitates audit access and generates alerts when stored secrets change.

  - *Integration:* Key Vault provides native integration with the Azure configuration store (Azure App Configuration) and web hosting platform (App Service).

- *Endpoint security:* Use [Azure Private Link](/azure/private-link/private-link-overview) to access PaaS solutions over a private endpoint in your virtual network. Traffic between your virtual network and the service travels across the Microsoft backbone network. Contoso Fiber uses Private Link for the following reasons:

  - *Enhanced-security communication:* It lets the application privately access services on the Azure platform and reduces the network footprint of data stores to help protect against data leakage.

  - *Minimal effort:* The private endpoints support the web app platform and database platform that the web app uses. Both platforms mirror existing on-premises configurations, so minimal change is required.

- *Network security:* Use [Azure Firewall](/azure/firewall/overview) to control inbound and outbound traffic at the network level. Use [Azure Bastion](/azure/bastion/bastion-overview) to connect to VMs with enhanced security, without exposing Remote Desktop Protocol/Secure Shell (RDP/SSH) ports. Contoso Fiber adopts a hub-and-spoke network topology and puts shared network security services in the hub. Azure Firewall inspects outbound traffic from the spokes to enhance network security. The company uses Azure Bastion for enhanced-security deployments from a jump host in the DevOps subnet.

## Code guidance

[!INCLUDE [Code updates](../includes/code-updates.md)]

### Implement the Retry pattern

[!INCLUDE [Retry pattern intro](../includes/retry.md)]

Use [Resilience4j](https://resilience4j.readme.io/docs/getting-started), a lightweight fault-tolerance library, to implement the Retry pattern in Java. To add the Retry pattern, the reference implementation decorates the service plan controller's `listServicePlans` method with Retry annotations. The code retries the call to a list of service plans from the database if the initial call fails. The retry policy for the reference implementation includes maximum attempts, wait duration, and exceptions to retry. Configure the retry policy in the `application.properties` file.

```java
    @GetMapping("/list")
    @PreAuthorize("hasAnyAuthority('APPROLE_AccountManager')")
    @CircuitBreaker(name = SERVICE_PLAN)
    @Retry(name = SERVICE_PLAN)
    public String listServicePlans(Model model) {
        List<serviceplandto> servicePlans = planService.getServicePlans();
        model.addAttribute("servicePlans", servicePlans);
        return "pages/plans/list";
    }
```

### Implement the Circuit Breaker pattern

[!INCLUDE [Circuit-breaker pattern intro](../includes/circuit-breaker.md)]

Use [Spring Cloud Circuit Breaker](https://docs.spring.io/spring-cloud-circuitbreaker/docs/current/reference/html/#usage-documentation) and [Resilience4j](https://resilience4j.readme.io/docs/getting-started) to implement the Circuit Breaker pattern. The reference implementation applies the Circuit Breaker pattern by decorating methods with the Circuit Breaker attribute.

### Implement the Cache-Aside pattern

[!INCLUDE [Cache-aside pattern intro](../includes/cache-aside.md)]

- *Configure the application to use a cache.* To enable caching, add the `spring-boot-starter-cache` package as a dependency in your `pom.xml` file. This package provides default configurations for Redis cache.

- *Cache high-need data.* Apply the Cache-Aside pattern on high-need data to enhance its effectiveness. Use Azure Monitor to track the CPU, memory, and storage of the database. These metrics help you determine whether you can use a smaller database SKU after you apply the Cache-Aside pattern. To cache specific data in your code, add the `@Cacheable` annotation. This annotation specifies to Spring which methods should have their results cached.

- *Keep cache data fresh.* Schedule regular cache updates to sync with the latest database changes. Use data volatility and user needs to determine the optimal refresh rate. This practice ensures that the application uses the Cache-Aside pattern to provide rapid access and current information. The default cache settings might not suit your web application. You can customize these settings in the `application.properties` file or the environment variables. For instance, you can modify the `spring.cache.redis.time-to-live` value (expressed in milliseconds) to control how long data should remain in the cache before it's removed.

- *Ensure data consistency.* Implement mechanisms to update the cache immediately after database write operations. Use event-driven updates or dedicated data management classes to ensure cache coherence. Consistently synchronizing the cache with database modifications is central to the Cache-Aside pattern.

## Configuration guidance

[!INCLUDE [configuration guidance intro](../includes/configuration.md)]

### Configure user authentication and authorization

[!INCLUDE [AuthN and AuthZ intro](../includes/authn-authz.md)]

- *Use an identity platform.* Use the [Microsoft identity platform for developers](/entra/identity-platform/v2-overview) to [set up web app authentication](/entra/identity-platform/index-web-app). This platform supports applications that use a single Microsoft Entra directory, multiple Microsoft Entra directories from different organizations, and Microsoft identities or social accounts.

  The [Spring Boot Starter for Microsoft Entra ID](/azure/developer/java/spring-framework/spring-boot-starter-for-entra-developer-guide uses [Spring Security](/azure/developer/java/spring-framework/spring-security-support) and Spring Boot to ensure easy configuration and integration. It provides various authentication flows, automatic token management, customizable authorization policies, and integration capabilities with Spring Cloud components. This tool enables straightforward Microsoft Entra ID and OAuth 2.0 integration into Spring Boot applications without manual library or settings configuration.

  The reference implementation uses the Microsoft identity platform (Microsoft Entra ID) as the identity provider for the web app. It uses the [OAuth 2.0 authorization code grant](/entra/identity-platform/v2-oauth2-auth-code-flow) to sign in a user who has a Microsoft Entra account. The following XML snippet defines the two required dependencies of the OAuth 2.0 authorization code grant flow. The dependency `com.azure.spring: spring-cloud-azure-starter-active-directory` enables Microsoft Entra authentication and authorization in a Spring Boot application. The dependency `org.springframework.boot: spring-boot-starter-oauth2-client` enables OAuth 2.0 authentication and authorization in a Spring Boot application.

    ```xml
    <dependency>
        <groupid>com.azure.spring</groupid>
        <artifactid>spring-cloud-azure-starter-active-directory</artifactid>
    </dependency>
    <dependency>
        <groupid>org.springframework.boot</groupid>
        <artifactid>spring-boot-starter-oauth2-client</artifactid>
    </dependency>
    ```

- *Create an application registration.* Microsoft Entra ID requires an application registration in the primary tenant. The application registration helps ensure that users who get access to the web app have identities in the primary tenant. The reference implementation uses Terraform to create a Microsoft Entra ID app registration together with an app-specific Account Manager role:

    ```terraform
    resource "azuread_application" "app_registration" {
      display_name     = "${azurecaf_name.app_service.result}-app"
      owners           = [data.azuread_client_config.current.object_id]
      sign_in_audience = "AzureADMyOrg"  # single tenant

      app_role {
        allowed_member_types = ["User"]
        description          = "Account Managers"
        display_name         = "Account Manager"
        enabled              = true
        id                   = random_uuid.account_manager_role_id.result
        value                = "AccountManager"
      }
    }
    ```

- *Enforce authorization in the application.* Use role-based access control (RBAC) to assign least privileges to [application roles](/entra/identity-platform/custom-rbac-for-developers). Define specific roles for different user actions to avoid overlap and ensure clarity. Map users to the appropriate roles and ensure that they have access only to necessary resources and actions. Configure Spring Security to use Spring Boot Starter for Microsoft Entra ID. This library enables integration with Microsoft Entra ID and helps ensure that users are authenticated securely. Configure and enable the Microsoft Authentication Library (MSAL) to get access to more security features. These features include token caching and automatic token refreshing.

  The reference implementation creates app roles that reflect the types of user roles in Contoso Fiber's account management system. Roles translate into permissions during authorization. Examples of app-specific roles in CAMS include Account Manager, Level One (L1) Support Representative, and Field Service Representative. The Account Manager role has permissions to add new app users and customers. A Field Service Representative can create support tickets. The `PreAuthorize` attribute restricts access to specific roles.

    ```java
        @GetMapping("/new")
        @PreAuthorize("hasAnyAuthority('APPROLE_AccountManager')")
        public String newAccount(Model model) {
            if (model.getAttribute("account") == null) {
                List<ServicePlan> servicePlans = accountService.findAllServicePlans();
                ServicePlan defaultServicePlan = servicePlans.stream().filter(sp -> sp.getIsDefault() == true).findFirst().orElse(null);
                NewAccountRequest accountFormData = new NewAccountRequest();
                accountFormData.setSelectedServicePlanId(defaultServicePlan.getId());
                model.addAttribute("account", accountFormData);
                model.addAttribute("servicePlans", servicePlans);
            }
            model.addAttribute("servicePlans", accountService.findAllServicePlans());
            return "pages/account/new";
        }
        ...
    ```

  To [integrate with Microsoft Entra ID](/azure/developer/java/spring-framework/spring-boot-starter-for-azure-active-directory-developer-guide?tabs=SpringCloudAzure5x#access-a-web-application), the reference implementation uses the [OAuth 2.0 authorization](/entra/identity-platform/v2-oauth2-auth-code-flow) code grant flow. This flow enables a user to sign in by using a Microsoft account. The following code snippet shows how to configure the `SecurityFilterChain` to use Microsoft Entra ID for authentication and authorization.

    ```java
    @Configuration(proxyBeanMethods = false)
    @EnableWebSecurity
    @EnableMethodSecurity
    public class AadOAuth2LoginSecurityConfig {
        @Bean
        SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
            http.apply(AadWebApplicationHttpSecurityConfigurer.aadWebApplication())
                .and()
                    .authorizeHttpRequests()
                .requestMatchers(EndpointRequest.to("health")).permitAll()
                .anyRequest().authenticated()
                .and()
                    .logout(logout -> logout
                                .deleteCookies("JSESSIONID", "XSRF-TOKEN")
                                .clearAuthentication(true)
                                .invalidateHttpSession(true));
            return http.build();
        }
    }
    ...
    ```

[!INCLUDE [User authN and authZ bullet points](../includes/authn-authz-notes.md)]

### Implement managed identities

[!INCLUDE [Managed identity intro](../includes/managed-id.md)]

### Rightsize environments

[!INCLUDE [Rightsize environments intro and guidance](../includes/right-size.md)]

For example, the reference implementation has an optional parameter that specifies the SKU to deploy. An environment parameter specifies that the Terraform template should deploy development SKUs:

```azurecli
azd env set APP_ENVIRONMENT prod
```

### Implement autoscaling

[!INCLUDE [Autoscaling guidance](../includes/autoscaling.md)]

### Automate resource deployment

[!INCLUDE [Automate deployment guidance](../includes/automate-deployment.md)]

### Configure monitoring

[!INCLUDE [Monitoring](../includes/monitor.md)]

- *Collect application telemetry.* Use [autoinstrumentation](/azure/azure-monitor/app/codeless-overview) in Application Insights to collect application [telemetry](/azure/azure-monitor/app/data-model-complete), such as request throughput, average request duration, errors, and dependency monitoring. You don't need to change any code to use this telemetry. Spring Boot registers several core metrics in Application Insights, like Java virtual machine (JVM), CPU, and Tomcat. Application Insights automatically collects from logging frameworks like Log4j and Logback.

  The reference implementation enables Application Insights via Terraform in the app service's `app_settings` configuration:

    ```terraform
    app_settings = {
        APPLICATIONINSIGHTS_CONNECTION_STRING = var.app_insights_connection_string
        ApplicationInsightsAgent_EXTENSION_VERSION = "~3"
        ...
    }
    ```

  For more information, see the following articles:

  - [Configure Azure Monitor Application Insights for Spring Boot](/azure/azure-monitor/app/java-spring-boot#enabling-programmatically)
  - [Azure Monitor Application Insights for Java](/azure/azure-monitor/app/java-standalone-config#autocollected-logging)
  - [Enable Azure Monitor OpenTelemetry for Java applications](/azure/azure-monitor/app/opentelemetry-enable)
  - [Use Azure Monitor Application Insights with Spring Boot](/azure/azure-monitor/app/java-spring-boot)

- *Create custom application metrics.* Implement code-based instrumentation to capture [custom application telemetry](/azure/azure-monitor/app/metrics-overview) by adding the Application Insights SDK and using its API.

- *Monitor the platform.* Enable diagnostics for all supported services. Send diagnostics to the same destination as the application logs for correlation. Azure services create platform logs automatically but only store them when you enable diagnostics. Enable diagnostic settings for each service that supports diagnostics.

  The reference implementation uses Terraform to enable Azure diagnostics on supported services. The following Terraform code configures the diagnostic settings for the app service:

    ```terraform
    # Configure diagnostic settings for app service
    resource "azurerm_monitor_diagnostic_setting" "app_service_diagnostic" {
      name                           = "app-service-diagnostic-settings"
      target_resource_id             = azurerm_linux_web_app.application.id
      log_analytics_workspace_id     = var.log_analytics_workspace_id
      #log_analytics_destination_type = "AzureDiagnostics"

      enabled_log {
        category_group = "allLogs"

      }

      metric {
        category = "AllMetrics"
        enabled  = true
      }
    }
    ```

## Deploy the reference implementation

The [reference implementation](https://github.com/azure/reliable-web-app-pattern-java) guides you through Contoso Fiber's simulated migration of an on-premises Java application to Azure. It also highlights required changes during the initial adoption phase.

The following architecture represents the final state of Contoso Fiber's Reliable Web App pattern implementation based on [their goals](#business-context).

:::image type="complex" border="false" source="../../../_images/reliable-web-app-java.svg" alt-text="Diagram that shows the architecture of the reference implementation." lightbox="../../../_images/reliable-web-app-java.svg":::
   Diagram that shows a reliable Java web application architecture on Azure that uses a hub-and-spoke network topology. Users access the app through Azure Front Door, which provides global load balancing, web application firewall, and DDoS protection. Azure Front Door routes traffic to App Service instances in a primary region and secondary region. Each App Service instance hosts a Java Spring Boot web app and is integrated with Application Insights for monitoring. Authentication and authorization are managed by Microsoft Entra ID. The app uses Azure Database for PostgreSQL flexible server for data storage, configured for high availability and read replicas, and Azure Managed Redis for distributed caching. Key Vault stores secrets, accessed via managed identities. Private Link secures connections between the app, database, and other PaaS resources. The architecture is deployed in a hub-and-spoke virtual network. The hub in the primary region contains Azure Firewall and Azure Bastion for network security and management, and the Key Vault private endpoint subnet. The spokes in the primary and secondary regions host the app and database. The subnets include the other private endpoints subnet, DevOps subnet, web app integration subnet, and web app private endpoint subnet. Diagnostic logs and metrics are sent to Azure Monitor and Log Analytics. A private DNS zones icon resides between the primary and secondary region. Arrows indicate data flow and relationships between components, illustrating a production-ready, scalable, and secure pattern for migrating a monolithic Java web app to Azure.
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/reliable-web-app-java-1.1.vsdx) of this architecture.*

## Next step

- [Reference implementation](https://github.com/azure/reliable-web-app-pattern-java)
