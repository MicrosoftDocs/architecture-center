---
title: Security considerations for mission-critical workloads on Azure
description: Reference architecture for a workload that is accessed over a public endpoint without additional dependencies to other company resources - Security.
author: msimecek
ms.author: prwilk
ms.date: 09/01/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: guide
products:
- azure-kubernetes-service
- azure-front-door
ms.category:
- containers
- networking
- database
- monitoring
categories: featured
---

The focus of this architecture is to maximize reliability so that the application remains performant and available. Security controls are only applied for the purposes of mitigating threats that impact availability and reliability. <lifted from WAF>

> Your business requirements might call for more security measures. We highly recommend that you extend the controls in your implementation as per the guidance provided in [Misson critical guidance in Well-architected Framework: Security](/azure/architecture/framework/mission-critical/mission-critical-security).

## Identity and access management

At the application level, this architecture uses a simple authentication scheme based on API keys for some restricted operations, such as creating catalog items or deleting comments. More advanced scenarios such as user authentication and user roles are not in scope.

### Managed identities

**[Managed identities](/azure/aks/use-managed-identity) should be used** to access Azure resources from the AKS cluster. The implementation uses managed identity of the AKS agent pool ("Kubelet identity") to access the global Azure Container Registry and stamp Azure Key Vault. Appropriate built-in roles are used to restrict access. For example, the `AcrPull` role is assigned to the Kubelet identity:

```
resource "azurerm_role_assignment" "acrpull_role" {
  scope                = data.azurerm_container_registry.global.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.stamp.kubelet_identity.0.object_id
}
```

## Secrets

Each deployment stamp has its dedicated instance of Azure Key Vault. Some parts of the workload use **keys** to access Azure resources, such as Cosmos DB. Those keys are created automatically during deployment and stored in Key Vault with Terraform. **No human operator interacts with secrets, except developers in e2e environments.** In addition, Key Vault access policies are configured in a way that **no user accounts are permitted to access** secrets.

> [!NOTE]
> This workload doesn't use certificates, but the same principles apply.

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

The reference implementation uses Helm in conjunction with Azure Pipelines to deploy the CSI driver containing all key names from Azure Key Vault. The driver is also responsible to refresh mounted secrets if they change in Key Vault.

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

## Configuration

**All application runtime configuration is stored in Azure Key Vault** including secrets and non-sensitive settings. You can use a configuration store, such as Azure App Configuration, to store the settings. However, for mission critical applications, an additional component will introduce another point of failure. Using Key Vault for runtime configuration simplifies the overall implementation.

**Key Vaults are only populated by Terraform deployment**. The required values are either sourced directly from Terraform (such as database connection strings) or passed through as Terraform variables from the deployment pipeline.

**Infrastructure and deployment configuration** of individual environments (e2e, int, prod) is stored in variable files that are part of the source code repository. This has two benefits:

- All changes in environment are tracked and go through deployment pipelines before they are applied to the environment.
- Individual e2e environments can be configured differently, because deployment is based on code in a branch.

The exception is the storage of **sensitive values** for the pipelines. These values are stored as secrets in Azure DevOps variable groups.


## Container security

Securing container images (also referred to as 'hardening') is important aspect of every containerized workload.

The application Docker containers, used in the reference implementation, are based on **runtime images**, not SDK, to minimize footprint and potential attack surface.

The application runs under a **non-root user**:

```dockerfile
RUN groupadd -r workload && useradd --no-log-init -r -g workload workload
USER workload
```

Read-only filesystem and non-privileged execution is configured with Helm:

```yaml
#
# /src/app/charts/backgroundprocessor/values.yaml
#
containerSecurityContext:
  privileged: false
  readOnlyRootFilesystem: true
  allowPrivilegeEscalation: false
```


- container scanning
- using private registry



## Verify explicitly

- Front Door WAF, TLS-encrypted.
- NGINX, header check, can only receive traffic from front door.

### Authentication and authorization

- System managed identities in compute cluster (kublet, managed control plane).
- SAS keys, key rotation

## Use least privilege access

- RBAC controls to provide right permissions to data plane.

## Assume breach

- Sanctity of the pipeline. Completely automated.
- Policies on resources, inherited polices from the subscription.
- Containers are hardened.

## Next

Deploy the reference implementation to get a full understanding of reources and their configuration. 

> [!div class="nextstepaction"]
> [Implementation: Mission-Critical Online](https://github.com/Azure/Mission-Critical-Online)