---
title: Secure OAuth 2.0 On-Behalf-Of refresh token storage for web services
titleSuffix: Azure Example Scenarios
description: Store OAuth 2.0 On-Behalf-Of (OBO) refresh tokens securely using Azure Key Vault and Azure Functions managed identity for key rotation and token refresh.
author: jmostella
ms.date: 07/15/2020
ms.topic: example-scenario
ms.service: architecture-center
ms.subservice: example-scenario
ms.custom:
- fcp
---

# Secure OAuth 2.0 OBO refresh token storage for web services

When developing web services, you may need to get access and refresh tokens using the [OAuth 2.0 On-Behalf-Of (OBO) flow](https://docs.microsoft.com/azure/active-directory/develop/v2-oauth2-on-behalf-of-flow). The OBO flow serves the use case where an application invokes a service or web API, which in turn needs to call another service or web API. OBO propagates the delegated user identity and permissions through the request chain.

Carefully consider the need to store OBO tokens, since these tokens can give a malicious actor access to resources in the organization's Azure Active Directory (Azure AD). A security breach of an application that targets **Accounts in any organizational directory (Any Azure AD directory - Multitenant)** can be especially disastrous.

When an app needs to use the access and refresh tokens indefinitely, it's critical to store the refresh tokens securely. Storing the access token may seem like a good idea, but poses a greater security risk, since an access token in and of itself can access resources. The recommended approach is to store only refresh tokens, and get access tokens as needed.

This solution uses Azure Key Vault, Azure Functions, and Azure DevOps to securely store refresh tokens. The solution also shows how to remove an organization's access to an application by removing secrets.

## Architecture

![Diagram showing the key and token refresh processes.](./media/refresh-diagram.png)

- Azure Key Vault holds a secret encryption key per Azure AD tenant.
- An Azure Functions function refreshes the refresh token and saves it with the latest secret key version.
- A database stores the encrypted and opaque data.
- An Azure DevOps continuous delivery pipeline creates and updates the keys.

### Azure Key Vault operations

![Diagram showing Key Vault key creation and update.](./media/key-creation-pipeline.png)

### Azure Functions operations

![Diagram showing Azure Functions operations.](./media/convert-to-opaque-token.png)

### Azure DevOps

Azure Pipelines is a convenient place to add your key rotation strategy, if you're already using Pipelines for infrastructure-as-code (IaC) or continuous integration and delivery (CI/CD). You don't have to use Azure DevOps, but the point is to limit the paths for setting or retrieving secrets.

You can apply the following permissions to the Service Principal for your Azure DevOps service connection, which allow Azure Pipelines to set secrets. Set the `vault_name` and `secret_manager_principal` variables to the correct values for your environment.

```azurecli
az keyvault set-policy --name $vault_name --spn $secret_manager_principal --secret-permissions set
```

After you set up your pipeline to create or update keys, schedule the pipeline to run periodically and enable key rotation. See [Configure schedules for pipelines](https://docs.microsoft.com/azure/devops/pipelines/process/scheduled-triggers?view=azure-devops&tabs=yaml).

You can [sync the key rotation schedule with the token refresh schedule](#key-rotation-and-token-refresh-flow). Whenever the refresh token refreshes, a new key encrypts the new refresh token.

## Managed identity

The most convenient way for an Azure service like Azure Functions to access Key Vault is to use the service's [Managed Identity](https://docs.microsoft.com/azure/azure-resource-manager/managed-applications/publish-managed-identity). You can grant access through the Azure portal, Azure CLI, or through an Azure Resource Manager (ARM) template for IaC scenarios.

### Azure portal

You can use the Azure portal to set up a managed identity for Azure Functions. For more information, see [Add a system-assigned identity](https://docs.microsoft.com/azure/app-service/overview-managed-identity?tabs=dotnet#add-a-system-assigned-identity).

![Screenshot showing how to enable managed identity in the Azure portal.](./media/system-assigned-managed-identity-in-azure-portal.png)

### ARM template

The following [ARM template](https://docs.microsoft.com/azure/azure-resource-manager/templates/) gives Azure Functions access to Azure Key Vault. Replace the `***` variables with the correct values for your environment.

```json
{
  "type": "Microsoft.KeyVault/vaults",
  "apiVersion": "***",
  "name": "***",
  "location": "***",
  "properties": {
    "sku": {
      "family": "A",
      "name": "standard"
    },
    "tenantId": "***",
    "enableSoftDelete": true,
    "enabledForDeployment": false,
    "enabledForTemplateDeployment": false,
    "enabledForDiskEncryption": false,
    "accessPolicies": [
      {
        "tenantId": "***",
        "objectId": "<Managed Identity Principal>",
        "permissions": {
          "secrets": [
            "get"
          ]
        }
      },
      {
        "tenantId": "***",
        "objectId": "<Service Connection Principal>",
        "permissions": {
          "secrets": [
            "set"
          ]
        }
      }
    ]
  }
}
```

### Azure CLI

You can also set Azure Key Vault policy by using the [Azure CLI](https://docs.microsoft.com/cli/azure/ext/keyvault-preview/keyvault?view=azure-cli-latest):

```azurecli
az keyvault set-policy --name $vault_name --spn $secret_manager_principal --secret-permissions set
az keyvault set-policy --name $vault_name --spn $function_managed_identity --secret-permissions get
```

## Token storage

You can use any database to store the tokens in encrypted form. The following diagram shows the sequence to store refresh tokens in a database:

![Diagram that shows the add token sequence.](./media/add-token-sequence-diagram.png)

The sequence has two functions, `userId()` and `secretId()`. You can define these functions as some combination of `token.oid`, `token.tid`, and `token.sub`. For more information, see [Use the id_token](https://docs.microsoft.com/azure/active-directory/develop/id-tokens#using-the-id_token).

With the cryptographic key stored as a secret, you can look up the latest version of the key in Azure Key Vault.

## Token usage

Using the key is straightforward. The following sequence queries the key based on the stored key version. It's not recommended to use Azure Key Vault in the `http` pipeline, so cache the responses whenever possible. The diagram labels the calls to Key Vault that are candidates for caching. For more information, see [HTTP API URL discovery](https://docs.microsoft.com/azure/azure-functions/durable/durable-functions-http-features?tabs=csharp#http-api-url-discovery).

![Diagram that shows the stored token usage sequence.](./media/use-stored-token-sequence.png)

The key rotation is orthogonal to the application, so you can save the refresh token under a new key asynchronously. Azure Functions supports asynchronous processing with [Durable Functions](https://docs.microsoft.com/azure/azure-functions/durable/).

## Key rotation and token refresh

You can rotate the secret key at the same times that you refresh the refresh token. The following sequence diagram illustrates this process:

![Diagram that shows the token refresh sequence.](./media/refresh-token-sequence.png)

This process uses a timer trigger, as in the Azure DevOps example. When you refresh the refresh token, the token gets encrypted using the latest version of the encryption key. Azure Functions has built-in support for timer triggers. For more information, see [Timer trigger for Azure Functions](https://docs.microsoft.com/azure/azure-functions/functions-bindings-timer?tabs=csharp).

## User and access control

To remove a user, just remove the user's record. To remove application access per user, remove the `refreshToken` part of the user data.

To remove access for a group of users, such as all users in a target tenant, you can use Azure Pipelines to delete the group's secret based on `secretId()`.
