The reliable web app pattern provides implementation guidance to replatform web applications transitioning to the cloud. The pattern focuses on the minimal changes you should make to be successful in the cloud. For more information, see [Overview of the reliable web app pattern](../overview.md).

There are two articles in this series and a reference implementation (sample web app). The companion article outlines how to [plan an implementation](plan-implementation.yml) of the reliable web app pattern for Java. A [reference implementation](https://github.com/Azure/reliable-web-app-pattern-java#reliable-web-app-pattern-for-java) of the pattern is available for you to deploy.

## Architecture and code

A well-architected web application needs quality code, and quality code needs a well-architected solution. The reliable web app pattern situates code changes within the pillars of the Azure Well-Architected Framework to reinforce the close relationship between code and architecture. The following diagram illustrates how the reference implementation should look in your environment.

[![Diagram showing the architecture of the reference implementation.](images/reliable-web-app-java.png)](images/reliable-web-app-java.png)
*Download a [Visio file](https://arch-center.azureedge.net/reliable-web-app-java.vsdx) of this architecture. For the estimated cost, see:*

- [Production environment estimated cost](https://azure.com/e/65354031bc084e539b6c8ccfc1a7b097)
- [Non-production environment estimated cost](https://azure.com/e/af7d105ce24340dab93dfe666909a3e0)

The following table lists the principles of the reliable web app pattern and how the reference implementation applies these principles.

| Reliable web app principles | Implementation for Java |
| --- | --- |
|▪ Low-cost, high-value wins<br>▪ Minimal code changes to:<ol>▫ Meet security best practices<br>▫ Apply reliability design patterns<br>▫ Improve operational excellence</ol>▪ Cost-optimized environments<br>▪ Follow Azure Well-Architected Framework principles<br>▪ Business-driven service level objective |▪ Retry pattern <br> ▪ Circuit Breaker pattern <br>▪ Cache-aside pattern <br>▪ Rightsize resource <br>▪ Managed identities <br>▪ Private endpoints <br>▪ Secrets management <br>▪ Repeatable infrastructure <br>▪ Telemetry, logging, monitoring |

## Reliability

A reliable web application is one that's both resilient and available. *Resiliency* is the ability of the system to recover from failures and continue to function. The goal of resiliency is to return the application to a fully functioning state after a failure occurs. *Availability* is a measure of whether your users can access your web application when they need to. We recommend using the Retry and Circuit Breaker patterns as a critical first step toward improving application reliability. These design patterns introduce self-healing qualities and help your application maximize the reliability features of the cloud. Here are our reliability recommendations.

### Use the Retry pattern

The Retry pattern is a technique for handling temporary service interruptions. These temporary service interruptions are known as *transient faults* and typically resolve themselves in a few seconds. In the cloud, the leading causes of transient faults are service throttling, dynamic load distribution, and network connectivity. The Retry pattern handles transient faults by resending failed requests to the service. You can configure the amount of time between retries and how many retries to attempt before throwing an exception. If your code already uses the Retry pattern, you should update your code to use the [Retry mechanisms](/azure/architecture/best-practices/retry-service-specific) available in Azure services and client SDKs. If your application doesn't have a Retry pattern, you should add one based on the following guidance. For more information, see:

- [Transient fault handling](/azure/architecture/best-practices/transient-faults)
- [Retry pattern](/azure/architecture/patterns/retry)

You should use [Resilience4j](https://github.com/resilience4j/resilience4j) to implement the Retry pattern in Java. Resilience4j is a lightweight fault tolerance library. It provides higher-order functions (decorators) to enhance any functional interface, lambda expression, or method reference with a Circuit Breaker, Rate Limiter, Retry, or Bulkhead.

*Reference implementation.* The reference implementation adds the Retry pattern by decorating a lambda expression with the Retry annotations. The code retries the call to get the media file from disk. The following code demonstrates how to use Resilience4j to retry a call to Azure Files to get the last modified time.

```java
private MediaFile checkLastModified(MediaFile mediaFile, MusicFolder folder, boolean minimizeDiskAccess) {
    Retry retry = retryRegistry.retry("media");
    CheckedFunction0<MediaFile> supplier = () -> doCheckLastModified(mediaFile, folder, minimizeDiskAccess);
    CheckedFunction0<MediaFile> retryableSupplier = Retry.decorateCheckedSupplier(retry, supplier);
    Try<MediaFile> result = Try.of(retryableSupplier).recover((IOException) -> mediaFile);
    return result.get();
}
```

The code uses the retry registry to get a `Retry` object. It also uses `Try` from the Vavr library. `Try` is a monad that performs error handling and recovery in Java applications. In this code, `Try` recovers from an exception and invokes another lambda expression as a fallback. The code returns the original `MediaFile` when the number of retries reaches the set maximum number. The reference implementation configures the retry properties in `application.properties`. For more ways to configure Resilience4j, see [Spring Retry](https://docs.spring.io/spring-batch/docs/current/reference/html/retry.html) and the [Resilience4j documentation](https://resilience4j.readme.io/v1.7.0/docs/getting-started-3).
  
### Use the Circuit Breaker pattern

You should pair the Retry pattern with the Circuit Breaker pattern. The Circuit Breaker pattern handles faults that aren't transient. The goal is to prevent an application from repeatedly invoking a service that is down. The Circuit Breaker pattern releases the application from the task to avoid wasting CPU cycles and improves application performance. For more information, see [Circuit Breaker pattern](/azure/architecture/patterns/circuit-breaker). For more ways to configure Resilience4j, see [Spring Circuit Breaker](https://docs.spring.io/spring-cloud-circuitbreaker/docs/current/reference/html/#usage-documentation) and [Resilience4j documentation](https://resilience4j.readme.io/v1.7.0/docs/getting-started-3).

*Simulate the Circuit Breaker pattern:* You can simulate the Circuit Breaker pattern in the reference implementation. For instructions, see [Simulate the Circuit Breaker pattern](https://github.com/Azure/reliable-web-app-pattern-java/blob/main/simulate-patterns.md#retry-and-circuit-break-pattern).

### Use multiple availability zones

Azure availability zones are physically separate datacenters within an Azure region that have independent power, networking, and cooling. Availability zones increase resiliency for reduced risk of data loss or downtime. If you can use multiple availability zones and performance or cost factors don't create a risk, you should use them for production workloads. You can use a single availability zone in your development environment to save money.

*Reference implementation.* The reference implementation uses Azure Database for PostgreSQL - Flexible Server with zone redundant high availability for the production environment only. To save money, the development environment uses a single availability zone. The reference implementation also uses Azure Storage with [zone-redundant storage](/azure/storage/common/storage-redundancy#zone-redundant-storage) for improved data redundancy.

## Security

Security is a critical component of any architectural design. The goal is to ensure the confidentiality, integrity, and availability of your data and systems. The following guidance outlines the key security concepts that you need to implement.

### Enforce the principle of least privilege

As a fundamental security tenet, you should grant users and services (workload identities) only the permissions they need. You should map users to roles and delegate the appropriate permissions to those roles. The number and type of roles you use depends on the needs of your application.

You should also enforce least privileges on the workload identity for all Azure services. There are two ways to manage access for workload identities. You can control access by using Azure Active Directory (Azure AD) role-based access control (RBAC) or at the service level. You should use Azure RBAC to manage permissions before you use service-level access controls. For example, your web app should have an identity in Azure AD, and you should use Azure RBAC to grant the least number of permissions it needs to function. For more information, see:

- [Access to Azure Storage](/azure/storage/blobs/authorize-access-azure-active-directory)
- [Access to Key Vault](/azure/key-vault/general/rbac-guide)
- [Access to Azure Database for PostgreSQL](/azure/postgresql/flexible-server/concepts-azure-ad-authentication)

### Configure user authentication and authorization

Authentication and authorization are critical aspects of web application security. *Authentication* is the process of verifying the identity of a user. *Authorization* specifies the actions a user is allowed to perform within the application. The goal is to implement authentication and authorization without weakening your security posture. To meet this goal, you need to use the features of the Azure application platform (Azure App Service) and identity provider (Azure AD).

**Configure user authentication.** Your web app needs to prioritize the authentication of users to help ensure the security and integrity of the application. To configure user authentication, you should use the capabilities of the web application platform. App Service enables authentication with identity providers, including Azure AD. You should use this feature to reduce the responsibility of your code to handle user authentication. For more information, see [Authentication in App Service](/azure/app-service/overview-authentication-authorization).

*Reference implementation.* The reference implementation uses the built-in authentication feature (EasyAuth) of App Service to manage the initial sign-in flow (cookies). It uses Azure AD as the identity platform. It ensures the users that get access to the web app are users in the directory.

**Integrate with identity provider (code).** You need to integrate the web application with the identity provider (Azure AD) in the code to help ensure secure and seamless authentication and authorization. The Microsoft Authentication Library (MSAL) is a powerful tool that can help with this task.

The Spring Boot Starter for Azure AD is an excellent option for integrating with Azure AD. This starter provides a simple and efficient way to implement enhanced-security authentication at the code level, using Spring Security and Spring Boot frameworks. The Spring Boot Starter for Azure AD provides several benefits, like support for various authentication flows, automatic token management, and customizable authorization policies. Additionally, it enables integration with other Spring Cloud components, like Spring Cloud Config and Spring Cloud Gateway. By using the Spring Boot Starter for Azure AD, you can integrate Azure AD and OAuth 2.0 authentication and authorization into the Spring Boot application without manually configuring the required libraries and settings. For more information, see [Spring Boot Starter for Azure AD](/azure/developer/java/spring-framework/spring-boot-starter-for-azure-active-directory-developer-guide?tabs=SpringCloudAzure4x).

*Reference implementation.* The reference implementation uses the Microsoft identity platform (Azure AD) as the identity provider. It uses the OAuth 2.0 authorization code grant to sign in a user with an Azure AD account. The following XML snippet defines the two required dependencies of the OAuth 2.0 authorization code grant flow. The dependency `com.azure.spring: spring-cloud-azure-starter-active-directory` enables Azure AD authentication and authorization in a Spring Boot application. The dependency `org.springframework.boot: spring-boot-starter-oauth2-client` supports OAuth 2.0 authentication and authorization in a Spring Boot application.

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

For more information, see [Spring Cloud Azure support for Spring Security](https://learn.microsoft.com/azure/developer/java/spring-framework/spring-security-support).

**Implement authentication and authorization business rules (code).** Implementing authentication and authorization business rules involves defining the access control policies and permissions for various application functionalities and resources. You need to configure Spring Security to use Spring Boot Starter for Azure AD. This library allows integration with Azure AD and helps you ensure that users are authenticated securely. Additionally, configuring and enabling MSAL provides access to more security features, like token caching and automatic token refreshing, and enhances the security of the web application.

*Reference implementation* The reference implementation creates two app roles (*User* and *Creator*). Roles translate into permissions during authorization. The *Creator* role has permissions to configure the application settings, upload videos, and create playlists. The *User* Role can view the videos.

To integrate with Azure AD, the reference implementation had to refactor the [`GlobalSecurityConfig.java`](https://github.com/Azure/reliable-web-app-pattern-java/blob/main/src/airsonic-advanced/airsonic-main/src/main/java/org/airsonic/player/security/GlobalSecurityConfig.java). `GlobalSecurityConfig.java` has the class-level annotation `@EnableWebSecurity`. `@EnableWebSecurity` enables Spring Security to locate the class and allows the class to have custom Spring Security configuration defined in any `WebSecurityConfigurer`. `WebSecurityConfigurerAdapter` is the implementation class of the `WebSecurityConfigurer` interface. Extending the `WebSecurityConfigurerAdapter` class enables endpoint authorization.

For Azure AD, the [`AadWebSecurityConfigurerAdapter`](https://github.com/Azure/azure-sdk-for-java/blob/main/sdk/spring/spring-cloud-azure-autoconfigure/src/main/java/com/azure/spring/cloud/autoconfigure/aad/AadWebSecurityConfigurerAdapter.java) class protects the routes in a Spring application, and it extends `WebSecurityConfigurerAdapter`. To configure the specific requirements for the reference implementation, the `WebSecurityConfiguration` class in the following code extends `ADWebSecurityConfigurationAdapter`.

```java
@Configuration
public class WebSecurityConfiguration extends AadWebSecurityConfigurerAdapter {

  @Override
  protected void configure(HttpSecurity http) throws Exception {
      // Use required configuration from AadWebSecurityAdapter.configure:
      super.configure(http);
      // Add custom configuration:

      http
          .authorizeRequests()
          .antMatchers("/recover*", "/accessDenied*", "/style/**", "/icons/**", "/flash/**", "/script/**", "/error")
          .permitAll()
          .antMatchers("/deletePlaylist*", "/savePlaylist*")
          .hasAnyAuthority("APPROLE_Creator")
          .antMatchers("/**")
          .hasAnyAuthority("APPROLE_User", "APPROLE_Creator")
          .anyRequest().authenticated()
          .and()
          .addFilterBefore(aadAddAuthorizedUsersFilter UsernamePasswordAuthenticationFilter.class)
          .logout(logout -> logout
              .deleteCookies("JSESSIONID", "XSRF-TOKEN")
              .clearAuthentication(true)
              .invalidateHttpSession(true)
              .logoutSuccessUrl("/index"));
    }
    ... 
}
```

The `antMatchers` method enforces authorization to the specified routes. For example, users making a request to `/deletePlaylist*` must have the role `APPROLE_Creator`. The code doesn't allow users without `APPROLE_Creator` to make the request.

**Express your application needs in Azure AD.** Most apps use application roles. *Application roles* are custom roles for assigning permissions to users or applications. The application code defines the application roles, and it interprets the application roles as permissions during authorization.

You can define application roles as Azure AD roles that the MSAL configuration can use. The Azure AD roles provide the backing for the access that the application roles receive. Azure AD authorizes users by using the application roles.

The `appRoles` attribute in Azure AD defines the roles that an app can declare in the application manifest. The `appRoles` attribute allows applications to define their own roles. When a user signs in to the application, Azure AD generates an ID token that contains various claims. This token includes a roles claim that lists the roles assigned to the user.

*Reference implementation.* The reference implementation uses an app registration to assign Azure AD users an app role ("User" or "Creator"). The app roles allow users to sign in to the application. The following JSON shows what the *User* and *Creator* `appRoles` look like in Azure active directory app registration.

```json
"appRoles": {
  {
    "allowedMemberTypes": [
        "User"
    ],
    "description": "ReadOnly roles have limited query access",
    "displayName": "ReadOnly",
    "id": "random_uuid",
    "isEnabled": true,
    "value": "User"
  },
 {
    "allowedMemberTypes": [
        "User"
    ],
    "description": "Creator role allows users to create content",
    "displayName": "Creator",
    "id": "random_uuid",
    "isEnabled": true,
    "value": "Creator"
  }
}
```

For more information, see:

- [Register an application with the Microsoft identity platform](/azure/active-directory/develop/quickstart-register-app)
- [AppRoles attribute](/azure/active-directory/develop/reference-app-manifest#approles-attribute)
- [Spring Boot Starter for Azure Active Directory developer's guide](/azure/developer/java/spring-framework/spring-boot-starter-for-azure-active-directory-developer-guide)
- [Add sign-in with Azure Active Directory account to a Spring web app](/azure/developer/java/spring-framework/configure-spring-boot-starter-java-app-with-azure-active-directory)
- [Add app roles to your application and receive them in the token](/azure/active-directory/develop/howto-add-app-roles-in-azure-ad-apps)
- [Configurable token lifetimes in the Microsoft identity platform](/azure/active-directory/develop/active-directory-configurable-token-lifetimes)

### Configure service authentication and authorization

You need to configure user authentication and authorization so users can access the web app. You also need to configure service authentication and authorization so the services in your environment have the permissions to perform necessary functions.

**Use managed identities.** Managed identities create an identity in Azure AD that eliminates the need for developers to manage credentials. The web app receives a workload identity (service principal) in Azure AD, and Azure manages the access tokens behind the scenes. Managed identities make identity management easier and more secure by eliminating the need for developers to manage credentials. They provide benefits for authentication, authorization, and accounting. For example, you can use a managed identity to grant the web app access to other Azure resources (Azure Key Vault, Azure databases). Or you can use a managed identity to enable a CI/CD pipeline to deploy a web app to App Service.

You should use managed identities when you can because of the security and operational benefits. However, in some cases, keeping your on-premises authentication and authorization configuration improves your migration experience. For example, hybrid deployments, legacy systems, and robust on-premises identity solutions could be reasons to delay the adoption of managed identities. In these cases, you should keep the on-premises setup and plan to modernize your identity solution later. For more information, see:

- [Connecting from your application to resources without handling credentials](/azure/active-directory/managed-identities-azure-resources/overview-for-developers)
- [Managed identities for Azure resources](/azure/active-directory/managed-identities-azure-resources/overview)
- [Azure services that support managed identities](/azure/active-directory/managed-identities-azure-resources/managed-identities-status)
- [Access Azure Storage from a web app](/azure/active-directory/develop/multi-service-web-app-access-storage)

*Reference implementation.* The reference implementation demonstrates a scenario in which the developer kept the on-premises authentication mechanism rather than switching to managed identities. The reference implementation stores the database secret in Key Vault. The web app uses a managed identity (system-assigned) to retrieve runtime secrets from Key Vault.

### Use a central secrets store (Key Vault)

The term *secret* refers to anything that you don't want exposed in plain text (passwords, keys, certificates). After you migrate your app to the cloud, you might still have secrets that you need to manage. You should store all these secrets in Key Vault. Many on-premises environments don't have a central secrets store. Key rotation is uncommon and auditing who has access to a secret is difficult. In Azure, the central secrets store is Key Vault. You can use Key Vault to store keys and to manage, audit, and monitor access to secrets.

*Reference implementation.* The reference implementation stores the PostgreSQL database username and password, the Redis Cache password, and the client secret for Azure AD that's associated with the MSAL implementation.

**Don't put Key Vault in the HTTP-request flow.** Key Vault has service limitations to safeguard resources and ensure optimal service quality for its clients. The original intent of Key Vault was to store and retrieve sensitive information during deployment. Organizations sometimes use Key Vault for runtime secret management, and many applications and services treat it like a database. However, the Key Vault limitations don't support high throughput rates and might affect performance if Key Vault is in the HTTP-request flow. When a key vault reaches a service threshold, it limits any further requests from the client and returns HTTP status code 429. The web app should load values from Key Vault at application start time. For more information, see [Key Vault transaction limits](/azure/key-vault/general/service-limits#secrets-managed-storage-account-keys-and-vault-transactions).

**Use one method to access secrets in Key Vault.** There are two methods to configure a web app to access secrets in Key Vault. (1) You can use an app setting in App Service and inject the secret as an [environment variable](/azure/app-service/app-service-key-vault-references#azure-resource-manager-deployment). (2) You can reference the secret in your application code. Add a reference to the app properties file so the app can communicate with Key Vault. You should pick one of these two methods and use it consistently. Avoid using both methods because it creates unneeded complexity.  

To integrate Key Vault with a Spring application, you need to (1) add the Azure Spring Boot Starter For Azure Key Vault Secrets in the `pom.xml` file and (2) configure a Key Vault endpoint in either the `application.properties` file or as an environment variable.

*Reference implementation.* The reference implementation uses the following code to add the Azure Spring Boot Starter For Azure Key Vault Secrets in the `pom.xml`:

```xml
<dependency> 
    <groupId>com.azure.spring</groupId> 
    <artifactId>spring-cloud-azure-starter-keyvault</artifactId> 
</dependency> 
```

The reference implementation uses an environment variable in the [App Service Terraform](https://github.com/Azure/reliable-web-app-pattern-java/blob/main/terraform/modules/app-service/main.tf) file to configure the Key Vault endpoint.

```terraform
SPRING_CLOUD_AZURE_KEYVAULT_SECRET_PROPERTY_SOURCES_0_ENDPOINT=var.key_vault_uri
```

The reference implementation set the property `spring.cloud.azure.keyvault.secret.property-source-enabled` to `true` in the `application.properties` file. This property allows Spring Cloud Azure to inject secrets from Azure Key Vault. The `${airsonic-database-admin-password}` is an example of Spring Cloud Azure injecting a secret into the web application.

```java
spring.cloud.azure.keyvault.secret.property-source-enabled=true

spring.datasource.driver-class-name=org.postgresql.Driver
spring.datasource.url=
spring.datasource.username=${airsonic-database-admin}
spring.datasource.password=${airsonic-database-admin-password}
```

**Avoid using access keys for temporary access where possible.** Granting permanent access to a storage account is a security risk. If compromised, they provide attackers permanent access to your data. It's a best practice to use temporary permissions to grant access to resources. Temporary permissions reduce the risk of unauthorized access or data breaches.

For temporary account access, you should use a shared access signature (SAS). There's a user delegation SAS, a service SAS, and an account SAS. You should use a user delegation SAS when possible. It's the only SAS that uses Azure AD credentials and doesn't require a storage account key.

*Reference implementation.* Sometimes access keys are unavoidable. The reference implementation needs to use an [account access key](/azure/storage/common/storage-account-keys-manage) to mount a directory with Azure Files to App Service. The web app uses the Azure Files integration in App Service to mount an NFS share to the Tomcat app server. The mount allows the web app to access the file share as if it were a local directory. This setup enables the web app to read and write files to the shared file system in the cloud.

### Use private endpoints

Private endpoints provide private connections between resources in an Azure virtual network and Azure services. By default, communication to most Azure services crosses the public internet. You should use private endpoints in all production environments for all supported Azure services. Private endpoints don't require any code changes, app configurations, or connection strings.
For more information, see:

- [How to create a private endpoint](/azure/architecture/example-scenario/private-web-app/private-web-app#deploy-this-scenario)
- [Best practices for endpoint security](/azure/architecture/framework/security/design-network-endpoints)

*Reference implementation.* The reference implementation uses private endpoints for Key Vault, Azure Cache for Redis, and Azure Database for PostgreSQL. To make the deployment possible, it doesn't use a private endpoint for Azure Files. The web app loads the user interface with playlists and videos from the local client IP address. It was less efficient to use a private endpoint for Azure.

You don't need to populate data in production, so you should always use a private endpoint to limit the attack surface. To add a layer of security, Azure Files only accepts traffic only from the virtual network and the local client IP of the user executing the deployment.

### Use a web application firewall

You should protect web applications with a web application firewall. The web application firewall provides a level protection against common security attacks and botnets. To take full advantage of the web application firewall, you must prevent traffic from bypassing it.

You should restrict access on the application platform (App Service) to accept only inbound communication from your gateway instance, Azure Front Door in this architecture. You can (1) [use Azure Front Door private endpoint](/azure/frontdoor/private-link), or (2) you can filter requests by the `X-Azure-FDID` header value. The App Service platform and Java Spring can filter by header value. You should App Service as the first option. Filtering at the platform level prevents unwanted requests from reaching your code.

You need to configure what traffic you want to pass through your WAF. You can filter based on the host name, client IP, and other values. For more information, see [Preserve the original HTTP host name](/azure/architecture/best-practices/host-name-preservation)

*Reference implementation.* The reference implementation uses Azure Front Door as the host name URL, but you should use your own host name.

## Cost optimization

Cost optimization principles balance business goals with budget justification to create a cost-effective web application. Cost optimization is about reducing unnecessary expenses and improving operational efficiencies. This section describes cost-optimization recommendations for a web app that's being migrated to the cloud.

*Reference implementation.* The app uses Azure Files integrated with App Service to save training videos that users upload. Refactoring this integration to use Azure Storage blobs would reduce hosting costs and should be evaluated as a possible future modernization.

### Rightsize resources for each environment

Production environments need SKUs that meet the service level agreements (SLAs), features, and scale needed for production. But non-production environments don't normally need the same capabilities. You can optimize costs in non-production environments by using cheaper SKUs that have lower capacity and SLAs. You should consider Azure Dev/Test pricing and Azure Reservations. How and whether you use these cost-saving methods depends on your environment.

**Consider Azure Dev/Test pricing.** Azure Dev/Test pricing gives you access to select Azure services for non-production environments at discounted pricing under the Microsoft Customer Agreement. The plan reduces the costs of running and managing applications in development and testing environments, across a range of Microsoft products. For more information, see [Dev/Test pricing options](https://azure.microsoft.com/pricing/dev-test/#overview).

*Reference implementation.* This architecture does not benefit from Azure Dev/Test pricing as none of the configurations used in this architecture fall within scope of the discounts of Azure Dev/Test pricing. For example, Azure App Service is Linux-based while the Dev/Test pricing only applies to Windows-based configurations.

**Consider using cheaper SKUs in non-production environments.** You can still use different SKUs across environments to save cost. If you use different SKUs or components for development, you might not encounter specific application issues until you deploy to production. It is essential to account for these differences and incorporate them into your testing cycles. For instance, if you only use Web Application Firewall (WAF) and Azure Front Door in production, you might not discover potential WAF false positives (valid requests that WAF blocks), routing problems, and host-header issues until you deploy the application to production.

*Reference implementation.* The reference implementation has an optional parameter that deploys different SKUs. An environment parameter instructs the Terraform template to select development SKUs as the following code shows:

```terraform
terraform -chdir=./terraform plan -var environment=dev -out infrastructure.tfplan
```

Proseware uses the same infrastructure-as-code (IaC) templates for both development environments and production with a few selected differences for cost optimization purposes. Proseware chose to use cheaper SKUs for Azure Cache for Redis, App Service, and Azure Database for PostgreSQL - Flexible Server when deploying to the development environment. The following table shows the services and the SKUs for each environment. You should choose SKUs that meet the needs of your environment.

| Service | Development SKU | Production SKU | SKU options |
| --- | --- | --- | --- |
| Azure Cache for Redis | Basic | Standard | [Azure Cache for Redis SKU options](https://azure.microsoft.com/pricing/details/cache/)
| App Service | P1v2 | P2v2 | [App Service SKU options](https://azure.microsoft.com/pricing/details/app-service/linux/)
| Azure Database for PostgreSQL - Flexible Server | Burstable B1ms (B_Standard_B1ms) | General Purpose D4s_v3 (GP_Standard_D4s_v3) | [Azure Database for PostgreSQL - Flexible Server SKU options](https://learn.microsoft.com/azure/postgresql/flexible-server/concepts-compute-storage)

**Consider Azure Reservations or an Azure savings plan.** You can combine an Azure savings plan with Azure Reservations to optimize compute cost and flexibility. Azure Reservations helps you save by committing to one-year or three-year plans for multiple products. The Azure savings plan for compute is the most flexible savings plan. It generates savings on pay-as-you-go prices. Pick a one-year or three-year commitment for compute services, regardless of region, instance size, or operating system. Eligible compute services include virtual machines, dedicated hosts, container instances, Azure Functions Premium, and App Service.

Plan your commitments around your team's architecture roadmap. For example, if you plan on being using the same database engine for a year or more, that would make a good candidate for a reserved instance. For more information, see:

- [Azure Reservations](https://learn.microsoft.com/azure/cost-management-billing/reservations/save-compute-costs-reservations)
- [Azure savings plans for compute](https://learn.microsoft.com/azure/cost-management-billing/savings-plan/savings-plan-compute-overview)

*Reference implementation.* Azure Database for PostgreSQL is a prime candidate for a reserved instance based on the plan to stick with this database engine for at least a year after this initial convergence on the cloud phase.

### Automate scaling the environment

You should use autoscale to automate horizontal scaling for production environments. Autoscaling adapts to user demand to save you money. Horizontal scaling automatically increases compute capacity to meet user demand and decreases compute capacity when demand drops. Don't increase the size of your application platform (vertical scaling) to meet frequent changes in demand. It's less cost efficient. For more information, see:

- [Scale up an app in Azure App Service](https://learn.microsoft.com/azure/app-service/manage-scale-up)
- [Overview of autoscale in Microsoft Azure](https://learn.microsoft.com/azure/azure-monitor/autoscale/autoscale-overview)

*Reference implementation.* The reference implementation uses the following configuration in Terraform. It creates an autoscale rule for App Service. The rule scales up to 10 instances and defaults to two instances. The code sets up two rules for scaling the resource up or down based on the average CPU usage over a period of time. The rules define a metric trigger that checks the CPU usage against a threshold value. It also defines a scale action that increases or decreases the number of instances in response to the trigger.

```terraform
resource "azurerm_monitor_autoscale_setting" "sitescaling" {
  name                = "sitescaling"
  resource_group_name = var.resource_group
  location            = var.location
  target_resource_id  = azurerm_service_plan.application.id
  profile {
    name = "default"
    capacity {
      default = 3
      minimum = 2
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

### Delete non-production environments

To optimize cost, it is recommended that you delete non-production environments during periods of low activity such as business hours or holidays. Additionally, it's important to ensure that any unused environments are deleted in a controlled and repeatable process. One way to achieve this is by building a deployment pipeline that includes steps for deleting environments in an automated and standardized manner.

## Operational excellence

The reliable web app pattern recommends using Infrastructure as Code (IaC) tools such as Terraform to deploy application infrastructure, configure services, and set up application telemetry. Monitoring operational health requires telemetry to measure security, cost, reliability, and performance gains. The cloud offers built-in features to configure and capture infrastructure and application telemetry. You should use these to improve performance and reduce costs. By analyzing performance metrics, you can identify inefficiencies in the application and make adjustments to optimize performance and reduce the resources needed to run the application.

### Enable logging and application telemetry

For tracing and debugging, you should enable logging to diagnose when any request fails. The telemetry you gather from your application should cater to its operational needs. At a minimum, you must collect telemetry on baseline metrics. You should gather information on user behavior that can help you apply targeted improvements.

**Monitor baseline metrics.** The workload should monitor baseline metrics. Important metrics to measure include request throughput, average request duration, errors, and monitoring dependencies. We recommend that you use Application Insights to gather this telemetry.

*Reference implementation.* The reference implementation demonstrates how to programmatically enable Application Insights. To enable Application Insights, you need to add the following Maven dependency to the `pom.xml` file.

   ```xml
   <dependency>
      <groupId>com.microsoft.azure</groupId>
      <artifactId>applicationinsights-runtime-attach</artifactId>
      <version>3.4.7</version>
   </dependency>
   ```

This dependency adds the necessary Application Insights components to your application build. It allows you to visualize metrics in Azure Application Insights. Spring Boot registers several core metrics in Application Insights such as Java virtual machine (JVM), CPU, Tomcat, and others. Application insights automatically collects from logging frameworks such as Log4j and Logback. For more information, see:

- [Configure Azure Monitor Application Insights for Spring Boot](/azure/azure-monitor/app/java-spring-boot#enabling-programmatically)
- [Configuration options - Azure Monitor Application Insights for Java - Azure Monitor](/azure/azure-monitor/app/java-standalone-config#auto-collected-logging)
- [Enable Azure Monitor OpenTelemetry for Java applications](https://learn.microsoft.com/azure/azure-monitor/app/java-in-process-agent) and
- [Using Azure Monitor Application Insights with Spring Boot](https://learn.microsoft.com/azure/azure-monitor/app/java-spring-boot).

**Create custom telemetry and metrics as needed.**  In addition to the baseline metrics in Application Insights, you should create custom telemetry to better understand your users and their interactions with your application. Application Insights allows you to gather custom telemetry, and you can also collect custom metrics through Micrometer. The goal is to gain deeper insights into your application's performance and user behavior, so you can make more informed decisions and improvements.

**Gather log-based metrics.** You should track log-based metrics to gain more visibility into essential application health and metrics. You can use [Kusto Query Language (KQL)](https://learn.microsoft.com/azure/data-explorer/kusto/query/) queries in Application Insights to find and organize data. You can run these queries in the portal. Under **Monitoring**, select **Logs** to run your queries. For more information, see:

- [Azure Application Insights log-based metrics](https://learn.microsoft.com/azure/azure-monitor/essentials/app-insights-metrics)
- [Log-based and pre-aggregated metrics in Application Insights](https://learn.microsoft.com/azure/azure-monitor/app/pre-aggregated-metrics-log-metrics)

### Enable platform diagnostics

A diagnostic setting in Azure allow you to specify the platform logs and metrics you want to collect and where to store them. Platform logs are built-in logs that provide diagnostic and auditing information. You can enable platform diagnostics for most Azure services, but each service defines its own log categories. So there will be different categories for different Azure services.

**Enable diagnostics for all supported services.** Azure services create platform logs automatically, but the service doesn't store them automatically. You must enable the diagnostic setting for each service, and you should enable it for every Azure service that supports diagnostics.

**Send diagnostics to same destination as the application logs.** When you enable diagnotics, you pick the logs you want to collect and where to send them. You should send the platform logs to the same destination as the application logs so you can correlate the two datasets.

*Reference implementation.* The reference implementation uses Terraform to enable Azure diagnostics on all supported services. The following Terraform code configures the diagnostic settings for the PostgreSQL database.

```terraform
# Configure Diagnostic Settings for PostgreSQL
resource "azurerm_monitor_diagnostic_setting" "postgresql_diagnostic" {
  name                           = "postgresql-diagnostic-settings"
  target_resource_id             = azurerm_postgresql_flexible_server.postresql_database.id
  log_analytics_workspace_id     = var.log_analytics_workspace_id
  #log_analytics_destination_type = "AzureDiagnostics"

  enabled_log {
    category_group = "audit"

    retention_policy {
      days    = 0
      enabled = false
    }
  }

  enabled_log {
    category_group = "allLogs"

    retention_policy {
      days    = 0
      enabled = false
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = true
    retention_policy {
      enabled = false
      days    = 0
    }
  }
}
```

## Performance efficiency

Performance efficiency is the ability of a workload to scale and meet the demands placed on it by users in an efficient manner. In cloud environments, a workload should anticipate increases in demand to meet business requirements. You should use the Cache-Aside pattern to improve performance and optimize costs when you manage application data.

### Use the Cache-Aside pattern

The Cache-Aside pattern is used to manage in-memory data caching. In this pattern, the application is responsible for managing data requests and data consistency between the cache and a persistent data store, like a database. When a data request reaches the application, the application first checks the cache to see if the cache has the data in memory. If it doesn't, the application queries the database, replies to the requester, and stores that data in the cache. For more information, see [Cache-aside pattern overview](https://learn.microsoft.com/azure/architecture/patterns/cache-aside).

The Cache-Aside pattern introduces a few benefits to the web application. It reduces request response time and can lead to increased response throughput. This efficiency reduces the number of horizontal scaling events, making the app more capable of handling traffic bursts. It also improves service availability by reducing the load on the primary data store and decreasing the likelihood of service outages.

**Cache high-need data.** Most applications have pages that get more views than other pages. You should cache data that supports the most-viewed pages of your application to improve responsiveness for the end user and reduce demand on the database. You should use Azure Monitor to track the CPU, memory, and storage of the database. You can use these metrics to determine whether you can use a smaller database SKU.

**Keep cache data fresh.** You should periodically refresh the data in the cache to keep it relevant. The process involves getting the latest version of the data from the database to ensure that the cache has the most requested data and the most current information. The goal is to ensure that users get current data fast. The frequency of the refreshes depends on the application.

**Ensure data consistency.** To ensure data consistency, you should update the cached data whenever a user makes changes. You can implement an event-driven system for these updates, or you can access cached data through the repository class responsible for managing the create and edit events.

## Deploy the reference implementation

You can deploy the reference implementation by following the instructions in the [Reliable web app pattern for Java repository](https://github.com/Azure/reliable-web-app-pattern-java#reliable-web-app-pattern-for-java). Use the deployment guide to set up a local development environment and deploy the solution to Azure.

## Next steps

The following resources provide cloud best practices and migration guidance.

### Cloud best practices

For Azure adoption and architectural guidance, see:

- [Cloud Adoption Framework](/azure/cloud-adoption-framework/overview). A framework to help your organization prepare and execute a strategy to build solutions on Azure.
- [Well-Architected Framework](/azure/architecture/framework/). A set of guiding tenets that you can use to improve the quality of a workload.

For applications that require a higher service level objective (SLO), see [mission-critical workloads](/azure/architecture/framework/mission-critical/mission-critical-overview).

### Migration guidance

The following tools and resources can help you migrate on-premises resources to Azure.

- [Azure Migrate](/azure/migrate/migrate-services-overview) provides a simplified migration, modernization, and optimization service for Azure that handles assessment and migration of web apps, SQL Server, and virtual machines.
- [Azure Database Migration Guides](/data-migration/) provides resources for various database types, and tools designed for your migration scenario.
- [Azure App Service landing zone accelerator](/azure/cloud-adoption-framework/scenarios/app-platform/app-services/landing-zone-accelerator) provides guidance for hardening and scaling App Service deployments.
