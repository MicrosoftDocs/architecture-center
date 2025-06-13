---
title: Security Considerations for Mission-Critical Workloads on Azure
description: Learn about the security considerations for a workload that's accessed over a public endpoint without dependencies on other company resources.
author: msimecek
ms.author: msimecek
ms.date: 10/17/2024
ms.topic: conceptual
ms.subservice: architecture-guide
ms.custom: arb-containers
---

# Security considerations for mission-critical workloads

Mission-critical workloads must be inherently secured. If an application or its infrastructure is compromised, availability is at risk. The focus of this architecture is to maximize reliability so that the application remains performant and available under all circumstances. Security controls are applied primarily with the purpose of mitigating threats that affect availability and reliability.

> [!NOTE]
> Your business requirements might need more security measures. We highly recommend that you extend the controls in your implementation according to the guidance in [Azure Well-Architected Framework security considerations for mission-critical workloads](/azure/architecture/framework/mission-critical/mission-critical-security).

## Identity and access management

At the application level, this architecture uses a simple authentication scheme based on API keys for some restricted operations, such as creating catalog items or deleting comments. Advanced scenarios like user authentication and user roles are beyond the scope of the [baseline architecture](/azure/architecture/reference-architectures/containers/aks-mission-critical/mission-critical-intro).

If your application requires user authentication and account management, follow the [recommendations for identity and access management](/azure/architecture/framework/security/design-identity-authentication). Some strategies include using managed identity providers, avoiding custom identity management, and using passwordless authentication when possible.

### Least privilege access

Configure access policies so that users and applications get the minimal level of access that they need to fulfill their function. Developers typically don't need access to the production infrastructure, but the deployment pipeline does need full access. Kubernetes clusters don't push container images into a registry, but GitHub workflows might. Front-end APIs don't usually get messages from the message broker, and back-end workers don't necessarily send new messages to the broker. These decisions depend on the workload, and the access level that you assign should reflect each component's functionality.

Examples from the Azure mission-critical reference implementation include:

- Each application component that works with Azure Event Hubs uses a connection string with either *Listen* (`BackgroundProcessor`) or *Send* (`CatalogService`) permissions. That access level ensures that every pod only has the minimum access required to fulfill its function.
- The service principal for the Azure Kubernetes Service (AKS) agent pool only has *Get* and *List* permissions for *Secrets* in Azure Key Vault.
- The AKS Kubelet identity only has the *AcrPull* permission to access the global container registry.

### Managed identities

To improve the security of a mission-critical workload, avoid using service-based secrets, such as connection strings or API keys, when possible. We recommend that you use managed identities if the Azure service supports that capability.

The reference implementation uses a service-assigned [managed identity](/azure/aks/use-managed-identity) in the AKS agent pool ("Kubelet identity") to access the global Azure Container Registry and a stamp's key vault. Appropriate built-in roles are used to restrict access. For example, this Terraform code assigns only the `AcrPull` role to the Kubelet identity:

```terraform
resource "azurerm_role_assignment" "acrpull_role" {
  scope                = data.azurerm_container_registry.global.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.stamp.kubelet_identity.0.object_id
}
```

### Secrets

When possible, use Microsoft Entra authentication instead of keys when you access Azure resources. Many Azure services, like [Azure Cosmos DB](/azure/cosmos-db/nosql/security/how-to-disable-key-based-authentication?tabs=csharp&pivots=azure-interface-cli) and [Azure Storage](/azure/storage/common/shared-key-authorization-prevent?tabs=portal), support the option to completely disable key authentication. AKS supports [Microsoft Entra Workload ID](/azure/aks/workload-identity-overview?tabs=dotnet).

For scenarios in which you can't use Microsoft Entra authentication, each deployment stamp has a dedicated instance of Key Vault to store keys. Those keys are created automatically during deployment and are stored in Key Vault with Terraform. No human operator, except developers in end-to-end environments, can interact with secrets. In addition, Key Vault access policies are configured so that no user accounts are permitted to access secrets.

> [!NOTE]
> This workload doesn't use custom certificates, but the same principles apply.

On the AKS cluster, the [Key Vault Provider for Secrets Store](/azure/aks/csi-secrets-store-driver) allows the application to consume secrets. The CSI driver loads keys from Key Vault and mounts them as files into individual pods.

```yml
#
# /src/config/csi-secrets-driver/chart/csi-secrets-driver-config/templates/csi-secrets-driver.yaml
#
apiVersion: secrets-store.csi.x-k8s.io/v1
kind: SecretProviderClass
metadata:
  name: azure-kv
spec:
  provider: azure
  parameters:
    usePodIdentity: "false"
    useVMManagedIdentity: "true"
    userAssignedIdentityID: {{ .Values.azure.managedIdentityClientId | quote }}
    keyvaultName: {{ .Values.azure.keyVaultName | quote }}
    tenantId: {{ .Values.azure.tenantId | quote }}
    objects: |
      array:
        {{- range .Values.kvSecrets }}
        - |
          objectName: {{ . | quote }}
          objectAlias: {{ . | lower | replace "-" "_" | quote }}
          objectType: secret
        {{- end }}
```

The reference implementation uses Helm with Azure Pipelines to deploy the CSI driver that contains all key names from Key Vault. The driver is also responsible for refreshing mounted secrets if they change in Key Vault.

On the consumer end, both .NET applications use the built-in capability to read configuration from files (`AddKeyPerFile`):

```csharp
//
// /src/app/AlwaysOn.BackgroundProcessor/Program.cs
// + using Microsoft.Extensions.Configuration;
//
public static IHostBuilder CreateHostBuilder(string[] args) =>
    Host.CreateDefaultBuilder(args)
    .ConfigureAppConfiguration((context, config) =>
    {
        // Load values from Kubernetes CSI Key Vault driver mount point.
        config.AddKeyPerFile(directoryPath: "/mnt/secrets-store/", optional: true, reloadOnChange: true);
        
        // More configuration if needed...
    })
    .ConfigureWebHostDefaults(webBuilder =>
    {
        webBuilder.UseStartup<Startup>();
    });
```

The combination of the CSI driver's automatic reload and `reloadOnChange: true` helps ensure that when keys change in Key Vault, the new values are mounted on the cluster. This process doesn't guarantee secret rotation in the application. The implementation uses a singleton Azure Cosmos DB client instance that requires the pod to restart to apply the change.

## Custom domains and TLS

Web-based workloads should use HTTPS to prevent man-in-the-middle attacks on all interaction levels, such as communication from the client to the API or from API to API. Make sure to automate certificate rotation because expired certificates are still a common cause of outages and degraded experiences.

The reference implementation fully supports HTTPS with custom domain names, such as `contoso.com`. It also applies the appropriate configuration to both the `int` and `prod` environments. You can also add custom domains for `e2e` environments. However, this reference implementation doesn't use custom domain names because of the short-lived nature of `e2e` and the increased deployment time when you use custom domains with SSL certificates in Azure Front Door.

To enable full automation of the deployment, you should manage the custom domain through an Azure DNS Zone. Infrastructure deployment pipeline dynamically creates CNAME records in the Azure DNS zone and maps these records automatically to an Azure Front Door instance.

Azure Front Door-managed SSL certificates are enabled, which removes the requirement for manual SSL certificate renewals. TLS 1.2 is configured as the minimum version.

```terraform
#
# /src/infra/workload/globalresources/frontdoor.tf
#
resource "azurerm_frontdoor_custom_https_configuration" "custom_domain_https" {
  count                             = var.custom_fqdn != "" ? 1 : 0
  frontend_endpoint_id              = "${azurerm_frontdoor.main.id}/frontendEndpoints/${local.frontdoor_custom_frontend_name}"
  custom_https_provisioning_enabled = true

  custom_https_configuration {
    certificate_source = "FrontDoor"
  }
}
```

Environments that aren't provisioned with custom domains are accessible through the default Azure Front Door endpoint. For instance, you can reach them at an address like `env123.azurefd.net`.

> [!NOTE]
> On the cluster ingress controller, custom domains aren't used in either case. Instead, an Azure-provided DNS name such as `[prefix]-cluster.[region].cloudapp.azure.com` is used with Let's Encrypt, which can issue free SSL certificates for those endpoints.

The reference implementation uses Jetstack's `cert-manager` to automatically provision SSL/TLS certificates from Let's Encrypt for ingress rules. More configuration settings, like the `ClusterIssuer`, which requests certificates from Let's Encrypt, are deployed via a separate `cert-manager-config` helm chart that's stored in [src/config/cert-manager/chart](https://github.com/Azure/Mission-Critical-Online/tree/main/src/config/cert-manager/chart/cert-manager-config).

This implementation uses `ClusterIssuer` instead of `Issuer` to avoid having issuers for each namespace. For more information, see the [cert-manager documentation](https://cert-manager.io/docs/concepts/issuer/) and the [cert-manager release notes](https://docs.cert-manager.io/en/release-0.7/tasks/issuing-certificates/ingress-shim.html).

```yaml
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-staging
spec:
  acme:
```

## Configuration

All application runtime configuration is stored in Key Vault, including secrets and nonsensitive settings. You can use a configuration store, such as Azure App Configuration, to store the settings. However, having a single store reduces the number of potential points of failure for mission-critical applications. Use Key Vault for runtime configuration to simplify the overall implementation.

Key vaults should be populated by the deployment pipeline. In the implementation, the required values are either sourced directly from Terraform, such as database connection strings, or passed through as Terraform variables from the deployment pipeline.

Infrastructure and deployment configuration of individual environments, such as `e2e`, `int`, and `prod`, is stored in variable files that are part of the source code repository. This approach has two benefits:

- All changes in an environment are tracked and go through deployment pipelines before they're applied to the environment.
- Individual `e2e` environments can be configured differently because deployment is based on code in a branch.

One exception is the storage of sensitive values for pipelines. These values are stored as secrets in Azure DevOps variable groups.

## Container security

It's necessary to secure container images for all containerized workloads.

This reference implementation uses Workload Docker containers that are based on runtime images, not SDK, to minimize the footprint and potential attack surface. There are no other tools, such as `ping`, `wget`, or `curl`, installed.

The application runs under a nonprivileged user `workload` that was created as part of the image build process:

```dockerfile
RUN groupadd -r workload && useradd --no-log-init -r -g workload workload
USER workload
```

The reference implementation uses Helm to package the YAML manifests that it needs to deploy individual components. This process includes their Kubernetes deployment, services, Horizontal Pod Autoscaling configuration, and security context. All Helm charts contain foundational security measures that follow Kubernetes best practices.

These security measures are:

- `readOnlyFilesystem`: The root filesystem `/` in each container is set to read-only to prevent the container from writing to the host filesystem. This restriction prevents attackers from downloading more tools and persisting code in the container. Directories that require read-write access are mounted as volumes.
- `privileged`: All containers are set to run as non-privileged. Running a container as privileged gives all capabilities to the container, and it also lifts all the limitations that the device control group controller enforces.
- `allowPrivilegeEscalation`: Prevents the inside of a container from gaining more privileges than its parent process.

These security measures are also configured for non-Microsoft containers and Helm charts like `cert-manager` when possible. You can use Azure Policy to audit these security measures.

```yaml
#
# Example:
# /src/app/charts/backgroundprocessor/values.yaml
#
containerSecurityContext:
  privileged: false
  readOnlyRootFilesystem: true
  allowPrivilegeEscalation: false
```

Each environment, including `prod`, `int`, and every `e2e` environment, has a dedicated instance of Container Registry that has global replication to each of the regions where stamps are deployed.

> [!NOTE]
> This reference implementation doesn't use vulnerability scanning of Docker images. We recommend that you use [Microsoft Defender for container registries](/azure/container-registry/scan-images-defender), potentially [with GitHub Actions](/azure/container-registry/github-action-scan).

## Traffic ingress

Azure Front Door is the global load balancer in this architecture. All web requests are routed through Azure Front Door, which selects the appropriate back end. Mission-critical applications should take advantage of other Azure Front Door capabilities, such as web application firewalls (WAFs). 

### Web application firewall

An important Azure Front Door capability is the WAF because it enables Azure Front Door to inspect traffic that's passing through. In the *Prevention* mode, all suspicious requests are blocked. In the implementation, two rule sets are configured. These rule sets are `Microsoft_DefaultRuleSet` and `Microsoft_BotManagerRuleSet`.

> [!TIP]
> When you deploy Azure Front Door with WAF, we recommend that you start with the *Detection* mode. Closely monitor its behavior with natural customer traffic, and fine-tune the detection rules. After you eliminate false positives, or if false positives are rare, switch to *Prevention* mode. This process is necessary because every application is different, and some payloads can be considered malicious, even though they're legitimate for that specific workload.

### Routing

Only those requests that come through Azure Front Door are routed to the API containers, like `CatalogService` and `HealthService`. Use an Nginx ingress configuration to help enforce this behavior. It checks for the presence of an `X-Azure-FDID` header and whether it's the right one for the global Azure Front Door instance of a specific environment.

```yml
#
# /src/app/charts/catalogservice/templates/ingress.yaml
#
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  # ...
  annotations:
    # To restrict traffic coming only through our Azure Front Door instance, we use a header check on the X-Azure-FDID.
    # The pipeline injects the value. Therefore, it's important to treat this ID as a sensitive value.
    nginx.ingress.kubernetes.io/modsecurity-snippet: |
      SecRuleEngine On
      SecRule &REQUEST_HEADERS:X-Azure-FDID \"@eq 0\"  \"log,deny,id:106,status:403,msg:\'Front Door ID not present\'\"
      SecRule REQUEST_HEADERS:X-Azure-FDID \"@rx ^(?!{{ .Values.azure.frontdoorid }}).*$\"  \"log,deny,id:107,status:403,msg:\'Wrong Front Door ID\'\"
  # ...
```

Deployment pipelines help ensure that this header is properly populated, but it also needs to bypass this restriction for smoke tests because they probe each cluster directly instead of through Azure Front Door. The reference implementation uses the fact that smoke tests are run as part of the deployment. This design allows the header value to be known and added to the smoke test HTTP requests.

```powershell
#
# /.ado/pipelines/scripts/Run-SmokeTests.ps1
#
$header = @{
  "X-Azure-FDID" = "$frontdoorHeaderId"
  "TEST-DATA"  = "true" # Header to indicate that posted comments and ratings are for tests and can be deleted again by the app.
}
```

## Secure deployments

To follow the baseline well-architected principles for operational excellence, fully automate all deployments. They should require no manual steps except to trigger the run or approve a gate.

You must prevent malicious attempts or accidental misconfigurations that can disable security measures. The reference implementation uses the same pipeline for both infrastructure and application deployment, which forces an automated rollback of any potential configuration drift. This rollback helps maintain the integrity of the infrastructure and alignment with the application code. Any change is discarded on the next deployment.

Terraform generates sensitive values for deployment during the pipeline run, or Azure DevOps supplies them as secrets. These values are protected with role-based access restrictions.

> [!NOTE]
> GitHub workflows provide a [similar concept](https://docs.github.com/en/actions/security-guides/encrypted-secrets) of separate stores for secret values. Secrets are encrypted, environmental variables that GitHub Actions can use.

It's important to pay attention to any artifacts that the pipeline produces because those artifacts can potentially contain secret values or information about the inner workings of the application. The Azure DevOps deployment of the reference implementation generates two files with Terraform outputs. One file is for stamps and one file is for global infrastructure. These files don't contain passwords that might compromise the infrastructure. However, you should consider these files to be sensitive because they reveal information about the infrastructure, including cluster IDs, IP addresses, storage account names, Key Vault names, Azure Cosmos DB database names, and Azure Front Door header IDs.

For workloads that use Terraform, you need to put extra effort into protecting the state file because it contains full deployment context, including secrets. The state file is typically stored in a storage account that should have a separate life cycle from the workload and should only be accessible from a deployment pipeline. You should log any other access to this file and send alerts to the appropriate security group.

## Dependency updates

Libraries, frameworks, and tools that the application uses are updated over time. It's important to complete these updates regularly because they often contain fixes for security problems that might give attackers unauthorized access into the system.

The reference implementation uses GitHub's Dependabot for NuGet, Docker, npm, Terraform, and GitHub Actions dependency updates. The `dependabot.yml` configuration file is automatically generated with a PowerShell script because of the complexity of the application's various parts. For example, each Terraform module needs a separate entry.

```yml
#
# /.github/dependabot.yml
#
version: 2
updates:
- package-ecosystem: "nuget"
  directory: "/src/app/AlwaysOn.HealthService"
  schedule:
    interval: "monthly" 
  target-branch: "component-updates" 

- package-ecosystem: "docker"
  directory: "/src/app/AlwaysOn.HealthService"
  schedule:
    interval: "monthly" 
  target-branch: "component-updates" 

# ... the rest of the file...
```

- Updates are triggered monthly as a compromise between having the most up-to-date libraries and keeping the overhead maintainable. Additionally, key tools  like Terraform are monitored continuously, and important updates are executed manually.
- Pull requests (PRs) target the `component-updates` branch instead of `main`.
- Npm libraries are configured to only check dependencies that go to the compiled application instead of to supporting tools like `@vue-cli`.

Dependabot creates a separate PR for each update, which can overwhelm the operations team. The reference implementation first collects a batch of updates in the `component-updates` branch, and then it runs tests in the `e2e` environment. If those tests are successful, it creates another PR that targets the `main` branch.

## Defensive coding

API calls can fail because of various reasons, including code errors, malfunctioned deployments, and infrastructure failures. If an API call fails, the caller, or client application, shouldn't receive extensive debugging information because that information might give adversaries helpful data points about the application.

The reference implementation demonstrates this principle by returning only the correlation ID in the failed response. It doesn't share the failure reason, like exception message or stack trace. By using this ID and with the help of `Server-Location` header, an operator can investigate the incident by using Application Insights.

```csharp
//
// Example ASP.NET Core middleware, which adds the Correlation ID to every API response.
//
public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
{
   // ...

    app.Use(async (context, next) =>
    {
        context.Response.OnStarting(o =>
        {
            if (o is HttpContext ctx)
            {
                context.Response.Headers.Add("Server-Name", Environment.MachineName);
                context.Response.Headers.Add("Server-Location", sysConfig.AzureRegion);
                context.Response.Headers.Add("Correlation-ID", Activity.Current?.RootId);
                context.Response.Headers.Add("Requested-Api-Version", ctx.GetRequestedApiVersion()?.ToString());
            }
            return Task.CompletedTask;
        }, context);
        await next();
    });
    
    // ...
}
```

## Next step

Deploy the reference implementation to get a full understanding of resources and their configuration.

> [!div class="nextstepaction"]
> [Implementation: Mission-Critical-Online template](https://github.com/Azure/Mission-Critical-Online)
