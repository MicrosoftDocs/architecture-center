---
title: Security considerations for mission-critical workloads on Azure
description: Reference architecture for a workload that is accessed over a public endpoint without dependencies to other company resources - Security.
author: msimecek
ms.author: prwilk
ms.date: 09/01/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: guide
products:
- azure-kubernetes-service
- azure-front-door
- azure-container-registry
- azure-key-vault
- azure-cosmos-db
ms.category:
- containers
- networking
- database
- monitoring
categories: featured
---

# Security considerations for mission-critical workloads

The focus of this architecture is to maximize reliability so that the application remains performant and available. Security controls are only applied for the purposes of mitigating threats that impact availability and reliability.

> [!NOTE]
> Your business requirements might call for more security measures. We highly recommend that you extend the controls in your implementation as per the guidance provided in [Misson-critical guidance in Well-Architected Framework: Security](/azure/architecture/framework/mission-critical/mission-critical-security).

## Identity and access management

At the application level, this architecture uses a simple authentication scheme based on API keys for some restricted operations, such as creating catalog items or deleting comments. More advanced scenarios such as user authentication and user roles aren't in scope of the reference implementation.

Applications that require user authentication and account management should follow the principles [outlined in Microsoft Well-Architected Framework](/azure/architecture/framework/security/design-identity-authentication) (that is, use managed identity providers, don't implement custom identity management, use passwordless whenever possible, etc.).

### Least privilege access

Access policies need to be chosen in a way that users and applications obtain only the minimal level of access needed to fulfill their function. Developers typically don't need access to the production infrastructure, but the deployment pipeline requires full access. Kubernetes clusters don't push container images into a registry, but GitHub workflows might. Frontend APIs don't always listen to messaging bus and backend workers don't necessarily send new messages. These decisions depend on the workload and each component's functionality should be reflected when deciding which access level should be assigned.

Examples from the Azure Mission-critical reference implementation:

- Each component that works with Event Hubs is using a connection string with either *Listen* (`BackgroundProcessor`), or *Send* (`CatalogService`) permissions. That ensures that **every pod has only the minimum access required to fulfill its function**.
- The service principal for AKS agent pool has only *Get* and *List* permissions for *Secrets* in Key Vault, no more.
- The AKS Kubelet identity has only the *AcrPull* permission to access the global Container Registry.

### Managed identities

To improve security of a mission-critical workload, the use of service-based secrets (such as connection strings or API keys) should be avoided when possible. Microsoft Azure is gradually increasing the support of **managed identities** across services and this approach should be preferred.

The reference implementation uses service-assigned [managed identity](/azure/aks/use-managed-identity) of the AKS agent pool ("Kubelet identity") to access the global Azure Container Registry and stamp's Azure Key Vault. Appropriate built-in roles are used to restrict access. For example, this Terraform code assigns only the `AcrPull` role the Kubelet identity:

```terraform
resource "azurerm_role_assignment" "acrpull_role" {
  scope                = data.azurerm_container_registry.global.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.stamp.kubelet_identity.0.object_id
}
```

### Secrets

Each deployment stamp has its dedicated instance of Azure Key Vault. Until the *Azure AD Workload Identity* feature is available, some parts of the workload use **keys** to access Azure resources, such as Cosmos DB. Those keys are created automatically during deployment and stored in Key Vault with Terraform. **No human operator interacts with secrets, except developers in e2e environments.** In addition, Key Vault access policies are configured in a way that **no user accounts are permitted to access** secrets.

> [!NOTE]
> This workload doesn't use custom certificates, but the same principles would apply.

The [**Azure Key Vault Provider for Secrets Store**](/azure/aks/csi-secrets-store-driver) is used in order for the application to consume secrets. The CSI driver loads keys from Azure Key Vault and mounts them into individual pods' as files.

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

The reference implementation uses Helm with Azure Pipelines to deploy the CSI driver containing all key names from Azure Key Vault. The driver is also responsible to refresh mounted secrets if they change in Key Vault.

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
        // Load values from k8s CSI Key Vault driver mount point.
        config.AddKeyPerFile(directoryPath: "/mnt/secrets-store/", optional: true, reloadOnChange: true);
        
        // More configuration if needed...
    })
    .ConfigureWebHostDefaults(webBuilder =>
    {
        webBuilder.UseStartup<Startup>();
    });
```

The combination of CSI driver's auto reload and `reloadOnChange: true` ensures that when keys change in Key Vault, new values are mounted on the cluster. **This  doesn't guarantee secret rotation in the application**. The implementation uses singleton Cosmos DB client instance that causes the pod to restart to apply the change.

## Custom domains and TLS

The reference implementation fully supports custom domain names, for example, `contoso.com`, and applies appropriate configuration to the `int` and `prod` environments. For `e2e` environments, custom domains can also be added, however, it was decided not to use custom domain names in the reference implementation due to the short-lived nature of `e2e` and the increased deployment time when using custom domains with SSL certificates in Front Door.

To enable full automation of the deployment, the custom domain is expected to be managed through an **Azure DNS Zone**. Infrastructure deployment pipeline dynamically creates CNAME records in the Azure DNS zone and maps these records automatically to an Azure Front Door instance.

**Front Door-managed SSL certificates** are also enabled, which means that there's no need for manual SSL certificate renewals. **TLS 1.2** is configured as the minimum version.

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

Environments that aren't provisioned with custom domains can be accessed through the default Front Door endpoint, for example `env123.azurefd.net`.

> [!NOTE]
> On the cluster ingress controllers, custom domains are not used in either case; instead an Azure-provided DNS name such as `[prefix]-cluster.[region].cloudapp.azure.com` is used with Let's Encrypt enabled to issue free SSL certificates for those endpoints.

## Certificates

Web applications should use HTTPS everywhere to prevent man-in-the-middle attacks on all interaction levels (client - API, API - API).

The reference implementation uses Jetstack's `cert-manager` to auto-provision SSL/TLS certificates (from Let's Encrypt) for ingress rules. More configuration settings like the `ClusterIssuer` (used to request certificates from Let's Encrypt) are deployed via a separate `cert-manager-config` helm chart stored in [src/config/cert-manager/chart](https://github.com/Azure/Mission-Critical-Online/tree/main/src/config/cert-manager/chart/cert-manager-config).

This implementation is using `ClusterIssuer` instead of `Issuer` as documented [here](https://cert-manager.io/docs/concepts/issuer/) and [here](https://docs.cert-manager.io/en/release-0.7/tasks/issuing-certificates/ingress-shim.html) to avoid having issuers per namespaces.

```yaml
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-staging
spec:
  acme:
```

## Configuration

**All application runtime configuration is stored in Azure Key Vault** including secrets and non-sensitive settings. You can use a configuration store, such as Azure App Configuration, to store the settings. However, for mission critical applications, another component will introduce another point of failure. Using Key Vault for runtime configuration simplifies the overall implementation.

**Key Vaults are only populated by Terraform deployment**. The required values are either sourced directly from Terraform (such as database connection strings) or passed through as Terraform variables from the deployment pipeline.

**Infrastructure and deployment configuration** of individual environments (`e2e`, `int`, `prod`) is stored in variable files that are part of the source code repository. This approach has two benefits:

- All changes in environment are tracked and go through deployment pipelines before they're applied to the environment.
- Individual e2e environments can be configured differently, because deployment is based on code in a branch.

The exception is the storage of **sensitive values** for the pipelines. These values are stored as secrets in Azure DevOps variable groups.

## Container security

Securing container images (also referred to as 'hardening') is important aspect of every containerized workload.

The application Docker containers, used in the reference implementation, are based on **runtime images**, not SDK, to minimize footprint and potential attack surface.

The application runs under a non-privileged user `workload`, created as part of the image build process:

```dockerfile
RUN groupadd -r workload && useradd --no-log-init -r -g workload workload
USER workload
```

The reference implementation uses Helm to package the YAML manifests needed to deploy individual components together, including their Kubernetes deployment, services, auto-scaling (HPA) configuration, and security context. All Helm charts contain foundational security measures following Kubernetes best practices. These security measures are:

- `readOnlyFilesystem`: The root filesystem `/` in each container is set to **read-only** to prevent the container from accidentally writing to the host filesystem. Directories that require read-write access are mounted as volumes.
- `privileged`: All containers are set to run as **non-privileged**. Running a container as privileged gives all capabilities to the container, and it also lifts all the limitations enforced by the device control group controller.
- `allowPrivilegeEscalation`: Prevents the inside of a container from gaining more privileges than its parent process.

These security measures are also configured for 3rd-party containers and Helm charts (that is, `cert-manager`) when possible and audited by Azure Policy.

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

Each environment (*prod*, *int*, every *e2e*) has a **dedicated instance of Azure Container Registry**, with global replication to each of the regions where stamps are deployed.

> [!NOTE]
> Current reference implementation doesn't use vulnerability scanning of Docker images. It is recommended to utilize [Microsoft Defender for container registries](/azure/container-registry/scan-images-defender), potentially [with GitHub Actions](/azure/container-registry/github-action-scan).

## Traffic ingress

**Azure Front Door** functions as the global load balancer in the reference implementation - before any web request reaches the AKS cluster or application code, it has to go through Front Door first, which then chooses the right backend to respond. And because web application traffic passes through Front Door (unlike Traffic Manager), there are more capabilities besides global traffic routing, which mission-critical workloads should utilize (as long as they work with HTTP).

### Web Application Firewall

An important Front Door capability is the **Web Application Firewall (WAF)**, because Front Door is able to inspect traffic, which is passing through. WAF is enabled in the **Prevention** mode, which actively blocks suspicious requests. There are two rulesets configured: `Microsoft_DefaultRuleSet` and `Microsoft_BotManagerRuleSet`.

> [!TIP]
> When deploying Front Door with WAF it's recommended to start with the **Detection** mode, closely monitor it's behavior with natural end-user traffic and fine-tune the detection rules. Once false-positives are eliminated, or rare, it's safe to switch to **Prevention** mode. This is necessary, because every application is different and some payloads can be considered malicious, while completely legitimate for that particular workload.

### Routing

Only those requests that come through Azure Front Door will be routed to the API containers (`CatalogService` and `HealthService`). This behavior is enforced by using an Nginx ingress configuration, which checks the `X-Azure-FDID` header - not just the presence of it, but also if it's the right one for the global Front Door instance of a particular environment.

```yml
#
# /src/app/charts/catalogservice/templates/ingress.yaml
#
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  # ...
  annotations:
    # To restric traffic coming only through our Front Door instance, we use a header check on the X-Azure-FDID
    # The value gets injected by the pipeline. Hence, this ID should be treated as a senstive value
    nginx.ingress.kubernetes.io/modsecurity-snippet: |
      SecRuleEngine On
      SecRule &REQUEST_HEADERS:X-Azure-FDID \"@eq 0\"  \"log,deny,id:106,status:403,msg:\'Front Door ID not present\'\"
      SecRule REQUEST_HEADERS:X-Azure-FDID \"@rx ^(?!{{ .Values.azure.frontdoorid }}).*$\"  \"log,deny,id:107,status:403,msg:\'Wrong Front Door ID\'\"
  # ...
```

Deployment pipelines ensure that this header is properly populated, but there's also a need to **bypass this restriction for smoke tests**, because they probe each cluster directly, not through Front Door. The reference implementation uses the fact that smoke tests are triggered as part of the deployment and therefore the header value is known and can be added to smoke test HTTP requests:

```powershell
#
# /.ado/pipelines/scripts/Run-SmokeTests.ps1
#
$header = @{
  "X-Azure-FDID" = "$frontdoorHeaderId"
  "X-TEST-DATA"  = "true" # Header to indicate that posted comments and rating are just for test and can be deleted again by the app
}
```

## Secure deployments

Following the baseline well-architected principles for operational excellence, **all deployments should be fully automated** and there shouldn't be manual steps required (except triggering the run, or approving a gate).

The reference implementation uses the same pipeline for both infrastructure and application deployment, which forces an **automated rollback of any potential configuration drift** (for example, manual changes through the portal or CLI), maintaining integrity of the infrastructure and alignment with the application code. Any changes in any environment - malicious attempt to disable security measures, or simple accidental misconfiguration, are discarded on the next deploy.

Sensitive values for deployment are either generated during the pipeline run (by Terraform), or supplied as Azure DevOps secrets. These values are protected with role-based access restrictions.

> [!NOTE]
> GitHub workflows offer [similar concept](https://docs.github.com/en/actions/security-guides/encrypted-secrets) of separate store for secret values. Secrets are encrypted environmental variables that can be used by GitHub Actions.

It's important to **pay attention to any artifacts produced by the pipeline**, because those can potentially contain secret values or information about inner workings of the application. The Azure DevOps deployment of the reference implementation generates two files with Terraform outputs: one for stamp and one for global infrastructure. These files don't contain passwords, which would allow direct compromise of the infrastructure. However they can be considered semi-sensitive, because they reveal information about the infrastructure - cluster IDs, IP addresses, Storage Account names, Key Vault names, Cosmos DB database name, Front Door header ID, and others.

For workloads that utilize **Terraform**, extra effort needs to be put into **protecting the state file**, as it contains full deployment context, **including secrets**. The state file is typically stored in a Storage Account that should have a separate lifecycle from the workload and should be accessible only from a deployment pipeline. Any other access to this file should be logged and alerts sent to appropriate security group.

## Dependency updates

Libraries, frameworks and tools used by the application get updated over time and it's important to follow these updates regularly, because they often contain security fixes, which could allow attackers unauthorized access into the system.

The reference implementation uses GitHub's **Dependabot** for NuGet, Docker, NPM, Terraform and GitHub Actions dependency updates. The `dependabot.yml` configuration file is automatically generated with a PowerShell script, because of the complexity of the various parts of the application (for example, each Terraform module needs a separate entry).

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

- **Updates are triggered monthly** as a compromise between having the most up-to-date libraries and keeping the overhead maintainable. Additionally, key tools (Terraform) are monitored continuously and important updates are executed manually.
- **Pull requests** are targeting the `component-updates` branch, instead of `main`.
- **NPM libraries** are configured to check only dependencies that go to the compiled application, not the supporting tools like `@vue-cli`.

Dependabot creates a separate pull request (PR) for each update, which can get overwhelming for the operations team. The reference implementation first collects a batch of updates in the `component-updates` branch, then runs tests in the `e2e` environment and if successful, another PR is created into the `main` branch.

## Defensive coding

API calls can fail - be it because of code errors, malfunctioned deployments, infrastructure failures, or any other reason. If that happens, the caller (client application) shouldn't receive extensive debugging information, because that could provide adversaries with helpful data points about the inner workings of the application.

The reference implementation demonstrates this principle by **returning only the correlation ID** in the failed response and doesn't share the failure reason (like exception message or stack trace). Using this ID (and with the help of `X-Server-Location` header) an operator is able to investigate the incident using Application Insights

```csharp
//
// Example ASP.NET Core middleware which adds the Correlation ID to every API response.
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
                context.Response.Headers.Add("X-Server-Name", Environment.MachineName);
                context.Response.Headers.Add("X-Server-Location", sysConfig.AzureRegion);
                context.Response.Headers.Add("X-Correlation-ID", Activity.Current?.RootId);
                context.Response.Headers.Add("X-Requested-Api-Version", ctx.GetRequestedApiVersion()?.ToString());
            }
            return Task.CompletedTask;
        }, context);
        await next();
    });
    
    // ...
}
```

## Next

Deploy the reference implementation to get a full understanding of resources and their configuration.

> [!div class="nextstepaction"]
> [Implementation: Mission-Critical Online](https://github.com/Azure/Mission-Critical-Online)