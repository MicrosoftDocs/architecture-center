The reliable web app pattern is a set of principles that helps developers successfully migrate web applications to the cloud. It provides implementation guidance built on the [Azure Well-Architected Framework](/azure/architecture/framework/). The pattern focuses on the minimal changes you need to make to ensure the success of your web app in the cloud.

This article shows you how to apply the reliable web app pattern for Java. The companion article shows you how to [plan the implementation](plan-implementation.yml).

![Diagram showing GitHub icon.](../../../_images/github.png) There's also a [reference implementation](https://github.com/Azure/reliable-web-app-pattern-java#reliable-web-app-pattern-for-java) of the reliable web app pattern for Java that you can deploy. The reference implementation applies the reliable web app pattern to an employee-facing, line of business (LOB) web application.

## Architecture and code

Architecture and code are symbiotic. A well-architected web application needs quality code, and quality code needs a well-architected solution. The reliable web app pattern situates code changes within the pillars of the Well-Architected Framework to reinforce the interdependence of code and architecture. The following diagram illustrates how the reference implementation should look in your environment.

[![Diagram showing the architecture of the reference implementation](images/java-architecture.png)](images/java-architecture.png)
*Download a [Visio file](https://arch-center.azureedge.net/reliable-web-app-java.vsdx) of this architecture. For the estimated cost, see:*

- [Production environment estimated cost](https://azure.com/e/c530c133f36c423e9774de286f7dd28a)
- [Non-production environment estimated cost](https://azure.com/e/48201e05118243e089ded6855839594a)

The following table lists the principles of the reliable web app pattern and how the reference implementation applied these principles.

| Reliable web app principles | Implementation for Java |
| --- | --- |
|▪ Low-cost, high-value wins<br>▪ Minimal code changes to:<ol>▫ Meet security best practices<br>▫ Apply reliability design patterns<br>▫ Improve operational excellence</ol>▪ Cost-optimized environment(s)<br>▪ Follow Azure Well-Architected Framework principles<br>▪ Business-driven service level objective |▪ Retry pattern <br> ▪ Circuit-breaker pattern <br>▪ Cache-aside pattern <br>▪ Right-size resource <br>▪ Managed identities <br>▪ Private endpoints <br>▪ Secrets management <br>▪ Repeatable infrastructure <br>▪ Telemetry, logging, monitoring |

## Reliability

A reliable web application is one that is both resilient and available. Resiliency is the ability of the system to recover from failures and continue to function. The goal of resiliency is to return the application to a fully functioning state after a failure occurs. Availability is whether your users can access your web application when they need to. We recommend using the retry and circuit-breaker patterns as a critical first step toward improving application reliability. These design patterns introduce self-healing qualities and help your application maximize the reliability features of the cloud. Here are our reliability recommendations.

### Use the Retry pattern

The Retry pattern is a technique for handling temporary service interruptions. These temporary service interruptions are known as transient faults. They're transient because they typically resolve themselves in a few seconds. In the cloud, the leading causes of transient faults are service throttling, dynamic load distribution, and network connectivity. The Retry pattern handles transient faults by resending failed requests to the service. You can configure the amount of time between retries and how many retries to attempt before throwing an exception. For more information, see [transient fault handling](https://review.learn.microsoft.com/azure/architecture/best-practices/transient-faults).

*Simulate the Retry pattern:* You can simulate the Retry pattern in the reference implementation. For instructions, see [Simulate the Retry pattern](https://github.com/Azure/reliable-web-app-pattern-java/blob/main/simulate-patterns.md#retry-and-circuit-break-pattern).

If your code already uses the Retry pattern, you should update your code to use the retry mechanisms available in Azure services and client SDKs. If your application doesn't have a Retry pattern, then you should use [Resilience4j](https://github.com/resilience4j/resilience4j). Resilience4j is a lightweight fault tolerance library inspired by Netflix Hystrix and designed for functional programming. It provides higher-order functions (decorators) to enhance any functional interface, lambda expression or method reference with a Circuit Breaker, Rate Limiter, Retry or Bulkhead.

*Reference implementation.* The reference implementation adds the Retry pattern by decorating a lambda expression with the Retry annotations. The code retries the call to get the media file from disk. The following code demonstrates how to use Resilience4j to retry a filesystem call to Azure Files to get the last modified time.

```java
@Retry(name = "retryApi", fallbackMethod = "isNewVersionAvailableFallback")
@CircuitBreaker(name = "CircuitBreakerService")
@GetMapping("/isNewFinalVersionAvailable")
public boolean isNewFinalVersionAvailable() {
    return externalAPICaller.isNewFinalVersionAvailable();
}

@Retry(name = "retryApi", fallbackMethod = "isNewVersionAvailableFallback")
@CircuitBreaker(name = "CircuitBreakerService")
@GetMapping("/isNewBetaVersionAvailable")
public boolean isNewBetaVersionAvailable() {
    return externalAPICaller.isNewBetaVersionAvailable();
}
```

You can configure the properties of the Retry pattern in the `application.properties` file.

```java
resilience4j.retry.instances.retryApi.max-attempts=3
resilience4j.retry.instances.retryApi.wait-duration=3s
resilience4j.retry.metrics.legacy.enabled=true
resilience4j.retry.metrics.enabled=true
```

For more ways to configure Resiliency4J, see [Spring Retry](https://docs.spring.io/spring-batch/docs/current/reference/html/retry.html) and [Resilliency4J documentation](https://resilience4j.readme.io/v1.7.0/docs/getting-started-3)
  
### Use the circuit-breaker pattern

You should pair the Retry pattern with the Circuit Breaker pattern. The Circuit Breaker pattern handles faults that aren't transient. The goal is to prevent an application from repeatedly invoking a service that is clearly faulted. It releases the application and avoids wasting CPU cycles so the application retains its performance integrity for end users. For more information, see the [Circuit Breaker pattern](https://learn.microsoft.com/azure/architecture/patterns/circuit-breaker).

*Simulate the Circuit Breaker pattern:* You can simulate the Circuit Breaker pattern in the reference implementation. For instructions, see [Simulate the Circuit Breaker pattern](https://github.com/Azure/reliable-web-app-pattern-java/blob/main/simulate-patterns.md#retry-and-circuit-break-pattern).

*Reference implementation:* The reference implementation adds the Circuit Breaker pattern by decorating a lambda expression with the Circuit Breaker annotation.

```java
@Retry(name = "retryApi", fallbackMethod = "isNewVersionAvailableFallback")
@CircuitBreaker(name = "CircuitBreakerService")
@GetMapping("/isNewFinalVersionAvailable")
public boolean isNewFinalVersionAvailable() {
    return externalAPICaller.isNewFinalVersionAvailable();
}

@Retry(name = "retryApi", fallbackMethod = "isNewVersionAvailableFallback")
@CircuitBreaker(name = "CircuitBreakerService")
@GetMapping("/isNewBetaVersionAvailable")
public boolean isNewBetaVersionAvailable() {
    return externalAPICaller.isNewBetaVersionAvailable();
}
```

You can configure the properties of the Circuit Breaker pattern in the `application.properties` file.

```java
resilience4j.circuitbreaker.instances.CircuitBreakerService.failure-rate-threshold=50
resilience4j.circuitbreaker.instances.CircuitBreakerService.minimum-number-of-calls=6
resilience4j.circuitbreaker.instances.CircuitBreakerService.automatic-transition-from-open-to-half-open-enabled=true
resilience4j.circuitbreaker.instances.CircuitBreakerService.wait-duration-in-open-state=15s
resilience4j.circuitbreaker.instances.CircuitBreakerService.permitted-number-of-calls-in-half-open-state=3
resilience4j.circuitbreaker.instances.CircuitBreakerService.sliding-window-size=10
resilience4j.circuitbreaker.instances.CircuitBreakerService.sliding-window-type=count_based

resilience4j.circuitbreaker.metrics.enabled=true
resilience4j.circuitbreaker.metrics.legacy.enabled=true
resilience4j.circuitbreaker.instances.CircuitBreakerService.register-health-indicator=true
resilience4j.circuitbreaker.instances.CircuitBreakerService.event-consumer-buffer-size=10
resilience4j.circuitbreaker.configs.CircuitBreakerService.registerHealthIndicator=true
```

For more ways to configure Resiliency4J, see [Spring Circuit Breaker](https://docs.spring.io/spring-cloud-circuitbreaker/docs/current/reference/html/#usage-documentation) and [Resilliency4J documentation](https://resilience4j.readme.io/v1.7.0/docs/getting-started-3).

### Use multiple availability zones

Azure availability zones are physically separate datacenters within an Azure region that have independent power, networking, and cooling. The benefits of using availability zones include increased resiliency and fault tolerance for applications and services, improved business continuity, and reduced risk of data loss or downtime. It's a best practice to use multiple availability zones for production workloads. You can use a single availability zone in your development environment to save money.

*Reference implementation.* The Redis Cache and PostgreSQL database use one availability zone for both the development and production environments. The Azure Storage uses a single availability but uses [zone redundant storage](/azure/storage/common/storage-redundancy#zone-redundant-storage) for improved data redundancy.

## Security

Cloud applications often comprise multiple Azure services. Communication between those services needs to be secure. Enforcing secure authentication, authorization, and accounting practices in your application is essential to your security posture. At this phase in the cloud journey, you should use managed identities, secrets management, and private endpoints. Here are the security recommendations for the reliable web app pattern.

### Use managed identities

Managed identities provide a secure and traceable way to control access to Azure resources. You should use managed identities for all supported Azure services. They make identity management easier and more secure, providing benefits for authentication, authorization, and accounting. For web app, managed identities create a workload identity (service principle) in Azure AD. Applications can use managed identities to obtain Azure AD tokens without having to manage any credentials. For more information, see:

- [Developer introduction and guidelines for credentials](/azure/active-directory/managed-identities-azure-resources/overview-for-developers)
- [Managed identities for Azure resources](/azure/active-directory/managed-identities-azure-resources/overview)
- [Azure services supporting managed identities](/azure/active-directory/managed-identities-azure-resources/managed-identities-status)
- [Web app managed identity](/azure/active-directory/develop/multi-service-web-app-access-storage)

Managed identities are similar to connection strings in on-premises applications. On-premises apps use connection strings to secure communication to a database. Trusted connection and Integrated security features hide the database username and password from the config file. The application connects to the database with an Active Directory account. These are often referred to as service accounts because only the service could authenticate.

*Reference implementation:* The reference implementation uses a system-assigned managed identity to managed permissions and access to the key vault.

### Configure user authentication and authorization

You should use the authentication and authorization mechanisms that meet security best practices and have parity with your on-premises environment.

**Configure user authentication to web app.** Azure App Service has built-in authentication and authorization capabilities (Easy Auth). You should use Easy Auth instead of writing code to handle authentication and authorization. For information, see [Authentication and authorization in Azure App Service](/azure/app-service/overview-authentication-authorization).

*Reference implementation.* The reference implementation configures Easy Auth after the web app deploys. This step is a workaround to a Terraform and Easy Auth support limitation. The following code shows the workaround. It uses a resource named `null_resource` with the name `upgrade_auth_v2`. The `provisioner` block tells Terraform to execute an a Azure CLI command that upgrades the authentication configuration version of an Azure Web App.

```terraform
#Due to the following [issue](https://github.com/hashicorp/terraform-provider-azurerm/issues/12928), We have to manually upgrade the auth settings to version 2.

resource "null_resource" "upgrade_auth_v2" {
  depends_on = [
    module.application
  ]

  provisioner "local-exec" {
    command = "az webapp auth config-version upgrade --name ${module.application.application_name} --resource-group ${azurerm_resource_group.main.name}"
  }
}
```

[See code in context](https://github.com/Azure/reliable-web-app-pattern-java/blob/d02b02aa2572f2bae651dede77fbc5051a313003/terraform/main.tf#L238)

**Use role-based authorization.** A role is a set of permissions, and role-based access control (RBAC) allows you to grant fine-grained permissions to different roles. You should use RBAC and grant roles the least privilege to start. You can always add more permissions later based on need. Align roles to application needs and provide clear guidance to your technical teams that implement permissions.

*Reference implementation.* The reference implementation creates two app roles (*User* and *Creator*). Roles translate into permissions during authorization. The *Creator* role has permissions to configure the Airsonic application settings, upload videos, and create playlists. The *User* Role can view the videos. The following code from the reference implementation demonstrates how to configure App Roles.

```terraform
  app_role {
    allowed_member_types = ["User"]
    description          = "ReadOnly roles have limited query access"
    display_name         = "ReadOnly"
    enabled              = true
    id                   = random_uuid.user_role_id.result
    value                = "User"
  }

  app_role {
    allowed_member_types = ["User"]
    description          = "Creator roles allows users to create content"
    display_name         = "Creator"
    enabled              = true
    id                   = random_uuid.creator_role_id.result
    value                = "Creator"
  }
```

[See code in context](https://github.com/Azure/reliable-web-app-pattern-java/blob/eb73a37be3d011112286df4e5853228f55cb377f/terraform/modules/app-service/main.tf#L98) For more information, see [Add app roles to your application and receive them in the token](https://learn.microsoft.com/azure/active-directory/develop/howto-add-app-roles-in-azure-ad-apps).

The reference implementation uses an app registration to assign AD users an app role ("User" or "Creator"). The app roles allows them to log in to the application. The reference implementation uses the following code to configure the app registration.

```terraform
resource "azuread_application" "app_registration" {
  display_name     = "${azurecaf_name.app_service.result}-app"
  owners           = [data.azuread_client_config.current.object_id]
  sign_in_audience = "AzureADMyOrg"  # single tenant
}
```

[See code in context](https://github.com/Azure/reliable-web-app-pattern-java/blob/eb73a37be3d011112286df4e5853228f55cb377f/terraform/modules/app-service/main.tf#L80). For more information, see [Register an application with the Microsoft identity platform](https://learn.microsoft.com/azure/active-directory/develop/quickstart-register-app).

The `appRoles` attribute in Azure AD defines the roles that an app can declare in the application manifest. The `appRoles` attribute allows applications to define their own roles. When a user signs in to the application, Azure AD generates an ID token that contains various claims. This token includes a `roles` claim that lists the roles assigned to the user. In the following code, the `WebSecurityConfiguration` class extends the `AadWebSecurityConfigurerAdapter` class to add authentication. It only grants access to the two roles configured in Azure AD, and it adds the `APPROLE_` as a prefix each role.

```java
    @Configuration
public class WebSecurityConfiguration extends AadWebSecurityConfigurerAdapter {

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        // use required configuration from AADWebSecurityAdapter.configure:
        super.configure(http);
        // add custom configuration:

         http
                .authorizeRequests()
                .antMatchers("/recover*", "/accessDenied*", "/style/**", "/icons/**", "/flash/**", "/script/**", "/error")
                .permitAll()
                .antMatchers("/personalSettings*",
                            "/playerSettings*", "/shareSettings*", "/credentialsSettings*")
                .hasAnyAuthority("APPROLE_User", "APPROLE_Creator")
                .antMatchers("/**")
                .hasAnyAuthority("APPROLE_User", "APPROLE_Creator")
                .anyRequest().authenticated()
                .and()
                .addFilterBefore(aadAddAuthorizedUsersFilter UsernamePasswordAuthenticationFilter.class)
                .logout(logout -> logout
                        .deleteCookies("JSESSIONID", "XSRF-TOKEN")
                        .clearAuthentication(true)
                        .invalidateHttpSession(true)
                        .logoutSuccessUrl("/index"))
                    ;
        }
```

[See code in context](https://github.com/Azure/reliable-web-app-pattern-java/blob/d02b02aa2572f2bae651dede77fbc5051a313003/src/airsonic-advanced/airsonic-main/src/main/java/org/airsonic/player/security/GlobalSecurityConfig.java#L162). For more information, see:

- [Application roles](https://learn.microsoft.com/azure/architecture/multitenant-identity/app-roles) and [appRoles attribute](https://learn.microsoft.com/azure/active-directory/develop/reference-app-manifest#approles-attribute)
- [Spring Boot Starter for Azure Active Directory developer's guide](/azure/developer/java/spring-framework/spring-boot-starter-for-azure-active-directory-developer-guide)
- [Add sign-in with Azure Active Directory account to a Spring web app](/azure/developer/java/spring-framework/configure-spring-boot-starter-java-app-with-azure-active-directory)
- [Add app roles to your application and receive them in the token](/azure/active-directory/develop/howto-add-app-roles-in-azure-ad-apps)
- [Configurable token lifetimes in the Microsoft identity platform](/azure/active-directory/develop/active-directory-configurable-token-lifetimes)

**Configure administrator authentication to database.** You have two primary methods to access the Azure PostgreSQL database. You can use Azure AD authentication or PostgreSQL authentication. For more information, see [JDBC with Azure PostgreSQL](/azure/developer/java/spring-framework/configure-spring-data-jdbc-with-azure-postgresql)

*Reference implementation.* The reference implementation uses PostgreSQL authentication with a username and password to maintain parity with the on-premises authentication method.

**Store user information.** You application needs to store user data in the database, but it should only add the user to the database if they have a valid role. You need to implement a mechanism to add valid users to the database.

*Reference implementation.* The reference implementation uses a Spring Filter to add the authenticated users to the Airsonic database. The `doFilterInternal()` method checks whether the incoming request is from a valid Airsonic user. If the user is valid, the filter adds the user to the database by calling the addUserToDatabase() method. Finally, the filter calls doFilter() method on the FilterChain object to continue processing the request. The `LOG.debug()` method provides information about the execution status of the filter.

```java
public class AADAddAuthorizedUsersFilter extends OncePerRequestFilter {
    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {

        LOG.debug("In the AADAddAuthorizedUsersFilter filter");

        // Add the user to the User database table if and only if they have a valid app role.
        if (isAirsonicUser(request)) {
            LOG.debug("user is an airsonic user");
            addUserToDatabase(request);
        }

        LOG.debug("AADAddAuthorizedUsersFilter calling doFilter");
        filterChain.doFilter(request, response);
    }
}
```

### Pick a authorization flow

The Microsoft Authentication Library (MSAL) supports several authorization grants and associated token flows for use by different application types and scenarios. You need to pick a supported authentication flow. For more information, see [Authorization flow](/azure/active-directory/develop/msal-authentication-flows).

*Reference implementation.* The reference implementation uses the OAuth 2.0 authorization code grant to log in a user with an Azure AD account. The following XML snippet defines the two required dependencies. The dependency `com.azure.spring : spring-cloud-azure-starter-active-directory` enables Azure Active Directory authentication and authorization in a Spring Boot application. The `org.springframework.boot : spring-boot-starter-oauth2-client` supports OAuth 2.0 authentication and authorization in a Spring Boot application.

```xml
    <dependency>
        <groupId>com.azure.spring</groupId>
        <artifactId>spring-cloud-azure-starter-active-directory</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-oauth2-client</artifactId>
    </dependency>
```

By adding these dependencies to the project, the developer can integrate Azure Active Directory and OAuth 2.0 authentication and authorization into their Spring Boot application without manually configuring the required libraries and settings. For more information, see [Spring Security with Azure Active Directory](https://learn.microsoft.com/azure/developer/java/spring-framework/spring-security-support).

### Use a central secrets store (Azure Key Vault)

Many on-premises environments don't have a central secrets store. Key rotation is uncommon and auditing who has access to a secret is difficult. In Azure, the central secret store is Key Vault. With Key Vault, you can store, keys, manage, audit, and monitor secrets access in Key Vault.

**Use Key Vault for services that don't support managed identities.** Some services in Azure don't support managed identities. In these situations, you must externalize the application configurations and put the secrets in Key Vault.

*Reference implementation:* The reference implementation uses an Azure AD client secret stored in Key Vault. The secret verifies the identity of the web app. To rotate the secret, generate a new client secret and then save the new value to Key Vault. In the reference implementation, the web app must restart so the code will start using the new secret. After the web app has been restarted, the team can delete the previous client secret.

**Use one way to access secrets in Key Vault.** You can configure your web app to access secrets in Key Vault via App Service or your application code. You can use an Application setting in App Service and inject the secret as an environment variable. To reference it in your application code, you add a reference to the app properties file so the app can reach out to Key Vault.

*Reference implementation.* The reference implementation uses the application code to access the secret in Key Vault.

**Use temporary permissions to access storage account.** For access to files in storage account, you should use Shared access signatures (SASs) for authentication. SASs are uniform resource locators (URIs) that grant restricted access to Azure Storage resources for a specified period of time.

*Reference implementation.* The reference implementation uses [Shared Key](/rest/api/storageservices/authorize-with-shared-key) (storage account key) to upload videos in the playlist. It is required to deploy the demo and populate the data, but you should use SASs in production.

### Secure communication with private endpoints

Private endpoints provide a private connection between resources within an Azure virtual network and Azure services. By default, communication to most Azure services traverses the public internet, including Azure Database for PostgreSQL and Azure App Service in the reference implementation. You should use private endpoints in all production environments for all supported Azure services. Private endpoints don't require any code changes, app configurations, or connection strings.

- [How to create a private endpoint](/azure/architecture/example-scenario/private-web-app/private-web-app#deploy-this-scenario)
- [Best practices for endpoint security](/azure/architecture/framework/security/design-network-endpoints)

*Reference implementation.* The reference implementation uses private endpoints for Key Vault, Azure Cache for Redis, and Azure Database for PostgreSQL. To make the deployment possible, it doesn't use a private endpoint for Azure Files. The web app loads the user interface with playlists and videos from the local client IP address, and it was most efficient not to use a private endpoint for Azure. ou do not need to populate data in production and should always use a private endpoint to limit the attack surface. To add a layer of security, Azure Files only accepts traffic from the virtual network and the local client IP of the user executing the deployment.

### Use a web application firewall

You should protect web applications with a web application firewall. The web application firewall provides a level protection against common security attacks and botnets. To take advantage of the value of the web application firewall, you have to prevent traffic from bypassing the web application firewall. In Azure, you should restrict access on the application platform (App Service) to only accept inbound communication from Azure Front Door.

*Reference implementation:* The reference implementation uses Front Door as the host name URL. In production, you should use your own host name and follow the guidance in [Preserve the original HTTP host name](/azure/architecture/best-practices/host-name-preservation).

## Cost optimization

Cost optimization principles balance business goals with budget justification to create a cost-effective web application. Cost optimization is about reducing unnecessary expenses and improving operational efficiencies. For a web app converging on the cloud, here are our recommendations for cost optimization.

**Reference architecture:** Our app uses Azure Files integrated with App Service to save training videos that users upload. Refactoring this to use Azure Storage Blobs would reduce hosting costs and should be evaluated as part of future modernizations.

### Rightsize resources for each environment

Production environments need SKUs that meet the service level agreements (SLA), features, and scale needed for production. But non-production environments don't normally need the same capabilities. You can optimize costs in non-production environments by using cheaper SKUs that have lower capacity and SLAs. You should consider Azure Dev/Test pricing and Azure reservations. How or whether you use these cost-saving methods depends on your environment.

**Consider Azure Dev/Test pricing.** Azure Dev/Test pricing gives you access to select Azure services for non-production environments at discounted pricing under the Microsoft Customer Agreement. The plan reduces the costs of running and managing applications in development and testing environments, across a range of Microsoft products. For more information, see [Dev/Test pricing options](https://azure.microsoft.com/pricing/dev-test/#overview).

**Consider Azure reservations or an Azure savings plan.** You can combine an Azure savings plan with Azure reservations to optimize compute cost and flexibility. Azure reservations help you save by committing to one-year or three-year plans for multiple products. The Azure savings plan for compute is the most flexible savings plan. It generates savings on pay-as-you-go prices. Pick a one-year or three-year commitment for compute services, regardless of region, instance size, or operating system. Eligible compute services include virtual machines, dedicated hosts, container instances, Azure Functions Premium, and Azure app services. For more information, see:

- [Azure Reservations](https://learn.microsoft.com/azure/cost-management-billing/reservations/save-compute-costs-reservations)
- [Azure savings plans for compute](https://learn.microsoft.com/azure/cost-management-billing/savings-plan/savings-plan-compute-overview)

*Reference implementation:* The reference implementation has an optional parameter to deploy different SKUs. It uses cheaper SKUs for Azure Cache for Redis, App Service, and Azure PostgreSQL Flexible Server when deploying to the development environment. You can choose any SKUs that meet your needs, but the reference implementation uses the following SKUs:

| Service | Dev SKU | Prod SKU | SKU options |
| --- | --- | --- | --- |
| Cache for Redis | Basic | Standard | [Redis Cache SKU options](https://azure.microsoft.com/pricing/details/cache/)
| App Service | P1v2 | P2v2 | [App Service SKU options](https://azure.microsoft.com/pricing/details/app-service/linux/)
| PostgreSQL Flexible Server | Burstable B1ms (B_Standard_B1ms) | General Purpose D4s_v3 (GP_Standard_D4s_v3) | [PostgreSQL SKU options](https://learn.microsoft.com/azure/postgresql/flexible-server/concepts-compute-storage)

The following parameter tells the Terraform template the SKUs to select development SKUs. In `scripts/setup-initial-env.sh`, you can set `APP_ENVIRONMENT` to either be prod or dev.

```bash
# APP_ENVIRONMENT can either be prod or dev
export APP_ENVIRONMENT=dev
```

[See code in context](https://github.com/Azure/reliable-web-app-pattern-java/blob/main/scripts/setup-initial-env.sh)

The Terraform uses the `APP_ENVIRONMENT` as the `environment` value when deploying.

```shell
terraform -chdir=./terraform plan -var application_name=${APP_NAME} -var environment=${APP_ENVIRONMENT} -out airsonic.tfplan
```

### Automate scaling the environment

You should use autoscale to automate horizontal scaling for production environments. Autoscaling adapts to user demand to save you money. Horizontal scaling automatically increases compute capacity to meet user demand and decreases compute capacity when demand drops. Don't increase the size of your application platform (vertical scaling) to meet frequent changes in demand. It's less cost efficient. For more information, see:

- [Scale up an app in Azure App Service](https://learn.microsoft.com/azure/app-service/manage-scale-up)
- [Overview of autoscale in Microsoft Azure](https://learn.microsoft.com/azure/azure-monitor/autoscale/autoscale-overview)

*Reference implementation:* The reference implementation uses the following configuration in Terraform. It creates an autoscale rule for the Azure App Service. The rule scales up to 10 instances and defaults to one instance. The code sets up two rules for scaling the resource up or down based on the average CPU usage over a period of time. The rules define a metric trigger that checks the CPU usage against a threshold value, and a scale action that increases or decreases the number of instances in response to the trigger.

```terraform
resource "azurerm_monitor_autoscale_setting" "airsonicscaling" {
  name                = "airsonicscaling"
  resource_group_name = var.resource_group
  location            = var.location
  target_resource_id  = azurerm_service_plan.application.id
  profile {
    name = "default"
    capacity {
      default = 1
      minimum = 1
      maximum = 10
    }
    rule {
      metric_trigger {
        metric_name         = "CpuPercentage"
        metric_resource_id  = azurerm_service_plan.application.id
        time_grain          = "PT1M"
        statistic           = "Average"
        time_window         = "PT5M"
        time_aggregation    = "Average"
        operator            = "GreaterThan"
        threshold           = 85
      }
      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }
    rule {
      metric_trigger {
        metric_name         = "CpuPercentage"
        metric_resource_id  = azurerm_service_plan.application.id
        time_grain          = "PT1M"
        statistic           = "Average"
        time_window         = "PT5M"
        time_aggregation    = "Average"
        operator            = "LessThan"
        threshold           = 65
      }
      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }
  }
}
```

[See this code in context](https://github.com/Azure/reliable-web-app-pattern-java/blob/08b00043f26a580fc6a37d665b173aca4f346c03/terraform/modules/app-service/main.tf#L278)

### Delete non-production environments

IaC is often considered an operational best practice, but it's also a way to manage costs. IaC can create and delete entire environments. You should delete non-production environments after hours or during holidays to optimize cost.

## Operational excellence

Organizations that move to cloud and apply a DevOps methodology see greater returns on investment. Infrastructure-as-code (IaC) is a key tenant of DevOps, and the reliable web app pattern uses IaC (Terraform) to deploy application infrastructure, configure services, and setup application telemetry. Monitoring operational health requires telemetry to measure security, cost, reliability, and performance gains. The cloud offers built-in features to capture telemetry, and when fed into a DevOps framework, they help rapidly improve your application. Here are the recommendations for operational excellence with the reliable web app pattern.

### Logging and application telemetry

You should enable logging to diagnose when any request fails for tracing and debugging. The telemetry you gather on your application should cater to the operational needs of the web application. At a minimum, you must collect telemetry on baseline metrics. Gather information on user behavior that can help you apply targeted improvements. Here are our recommendations for collecting application telemetry:

**Monitor baseline metrics.** The workload should monitor baseline metrics. Important metrics to measure include request throughput, average request duration, errors, and monitoring dependencies. We recommend using application Insights to gather this telemetry.

*Reference implementation:* The reference implementation uses the following code to enable Application Insights Java programmatically.

1. Maven dependency

   ```xml
   <dependency>
      <groupId>com.microsoft.azure</groupId>
      <artifactId>applicationinsights-runtime-attach</artifactId>
      <version>3.4.7</version>
   </dependency>
   ```

1. Invoke the ApplicationInsights.attach() method in Application.java.

   ```java
   public static void main(String[] args) {
       ApplicationInsights.attach();
       SpringApplicationBuilder builder = new SpringApplicationBuilder();
       doConfigure(builder).run(args);
   }
   ```

To enable the Java application to capture telemetry, see [Java in process agent](https://learn.microsoft.com/azure/azure-monitor/app/java-in-process-agent). For more information on configuring Application Insights in apps like our sample, see [Using Azure Monitor Application Insights with Spring Boot](https://learn.microsoft.com/azure/azure-monitor/app/java-spring-boot).

**Create custom telemetry as needed.** You should augment baseline metrics with information that helps you understand your users. You can use Application Insights to gather custom telemetry.

**Gather log-based metrics.** You should track log-based metrics to gain more visibility into essential application health and metrics. You can use [Kusto Query Language (KQL)](https://learn.microsoft.com/azure/data-explorer/kusto/query/) queries in Application Insights to find and organize data. You can run these queries in the portal. Under **Monitoring**, select **Logs** to run your queries. For more information, see:

- [Azure Application Insights log-based metrics](https://learn.microsoft.com/azure/azure-monitor/essentials/app-insights-metrics)
- [Log-based and pre-aggregated metrics in Application Insights](https://learn.microsoft.com/azure/azure-monitor/app/pre-aggregated-metrics-log-metrics)

## Performance efficiency

Performance efficiency is the ability of a workload to scale and meet the demands placed on it by users in an efficient manner. In cloud environments, a workload should anticipate increases in demand to meet business requirements. You should use the cache-aside pattern to manage application data while improving performance and optimizing costs.

### Use the cache-aside pattern

The cache-aside pattern is a technique that's used to manage in-memory data caching. The cache-aside pattern makes the application responsible for managing data requests and data consistency between the cache and a persistent data store, like a database. When a data request reaches the application, the application first checks the cache to see if the cache has the data in memory. If it doesn't, the application queries the database, replies to the requester, and stores that data in the cache. For more information, see [Cache-aside pattern overview](https://learn.microsoft.com/azure/architecture/patterns/cache-aside).

The cache-aside pattern introduces a few benefits to the web application. It reduces the request response time and can lead to increased response throughput. This efficiency reduces the number of horizontal scaling events, making the app more capable of handling traffic bursts. It also improves service availability by reducing the load on the primary data store and decreasing the likelihood of service outages.

**Cache high-need data.** Most applications have pages that get more viewers than other pages. You should cache data that supports the most-viewed pages of your application to improve responsiveness for the end user and reduce demand on the database. You should use Azure Monitor and Azure SQL Analytics to track the CPU, memory, and storage of the database. You can use these metrics to determine whether you can use a smaller database SKU.

**Keep cache data fresh.** You should periodically refresh the data in the cache to keep it relevant. The process involves getting the latest version of the data from the database to ensure that the cache has the most requested data and the most current information. The goal is to ensure that users get current data fast. The frequency of the refreshes depends on the application.

**Ensure data consistency.** You need to change cached data whenever a user makes an update. An event-driven system can make these updates. Another option is to ensure that cached data is only accessed directly from the repository class that's responsible for handling the create and edit events.

### Deploy the reference implementation

You can deploy the reference implementation by following the instructions in the [reliable web app pattern for Java repository](https://github.com/Azure/reliable-web-app-pattern-java#reliable-web-app-pattern-for-java). Follow the deployment guide to set up a local development environment and deploy the solution to Azure.

## Next Steps

The following resources provide cloud best practices and migration guidance.

### Cloud best practices

For Azure adoption and architectural guidance, see:

- [Cloud Adoption Framework](/azure/cloud-adoption-framework/overview). Can help your organization prepare and execute a strategy to build solutions on Azure.
- [Well-Architected Framework](/azure/architecture/framework/). A set of guiding tenets that can be used to improve the quality of a workload.

For applications that require a higher SLO than the reliable web app pattern, see the guidance for architecting and operating [mission-critical workloads](/azure/architecture/framework/mission-critical/mission-critical-overview).

### Migration guidance

The following tools and resources can help you migrate on-premises resources to Azure.

- [Azure Migrate](/azure/migrate/migrate-services-overview) provides a simplified migration, modernization, and optimization service for Azure that handles assessment and migration of web apps, SQL Server, and virtual machines.
- [Azure Database Migration Guides](/data-migration/) provides resources for different database types, and different tools designed for your migration scenario.
- [Azure App Service landing zone accelerator](/azure/cloud-adoption-framework/scenarios/app-platform/app-services/landing-zone-accelerator) provides guidance for hardening and scaling App Service deployments.
