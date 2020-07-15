---
title: Secure storage of OAuth 2.0 On-Behalf-Of refresh tokens for web services
titleSuffix: Azure Example Scenarios
description: Store refresh tokens securely using Azure Key Vault with key rotation and token refresh.
author: jmostella
ms.date: 07/15/2020
ms.topic: example-scenario
ms.service: architecture-center
ms.subservice: example-scenario
ms.custom:
- fcp
---

# Secure storage of OAuth 2.0 On-Behalf-Of refresh tokens for web services

When developing web services, you may need to obtain access and refresh tokens using the [OAuth 2.0 On-Behalf-Of (OBO) flow](https://docs.microsoft.com/azure/active-directory/develop/v2-oauth2-on-behalf-of-flow). The OBO flow serves the use case where an application invokes a service or web API, which in turn needs to call another service or web API. OBO propagates the delegated user identity and permissions through the request chain.

Carefully consider the need to store tokens, since these tokens can provide a malicious actor access to resources under the user's Azure Active Directory (Azure AD). A security breach of an application that targets **Accounts in any organizational directory (Any Azure AD directory - Multitenant)** can be especially disastrous.

When an app needs to use the access and refresh tokens indefinitely, it's critical to store the refresh token securely. Storing the access token may seem like a good idea, but poses a greater security risk, since an access token in and of itself can access resources. The recommended approach is to store only refresh tokens, and get access tokens as needed.

This solution uses Azure Key Vault, Azure Functions, and Azure DevOps to securely store refresh tokens. The solution also shows how to remove an organization's access to an application by removing secrets.

- Azure Key Vault holds a secret encryption key per Azure AD tenant.
- An Azure Functions function refreshes the refresh token and saves it with the latest secret version.
- An Azure DevOps continuous delivery (CD) pipeline creates and updates the keys.
- A database stores encrypted and opaque data.

## Azure Key Vault operations

![Key Value key creation](./media/key-creation-pipeline-2.svg)

Apply permissions to the Service Principal for your Azure DevOps service connection, which allows your Azure Pipelines to set secrets. Set the `vault_name` and `secret_manager_principal` variables to correct values for your environment.

```azurecli
az keyvault set-policy --name $vault_name --spn $secret_manager_principal --secret-permissions set
```

After you set up your pipelines to create or update keys, schedule the pipeline to run periodically and enable key rotation. See [Configure schedules for pipelines](https://docs.microsoft.com/azure/devops/pipelines/process/scheduled-triggers?view=azure-devops&tabs=yaml).

When the refresh token is refreshed, a new key is available to encrypt the new refresh token. You can [sync the key rotation schedule with the token refresh schedule](#key-rotation-and-token-refresh-flow).

You don't have to use Azure DevOps. The point is to limit paths for setting or retrieving secrets. If you're already using Azure DevOps for infrastructure-as-code (IaC) or continuous integration and delivery (CI/CD), Azure Pipelines is a convenient place to add your key rotation strategy.

## Azure Functions operations

![Get opaque token](./media/convert-to-opaque-token.svg)

![Get opaque token](./media/convert-to-opaque-token.png)

### Create a managed identity

The most convenient way to allow a service to access Key Vault is to use a [Managed Identity](https://docs.microsoft.com/azure/azure-resource-manager/managed-applications/publish-managed-identity). You can grant access through the Azure portal, an Azure Resource Manager (ARM) template for IaC scenarios, or through the Azure CLI.

![Enable managed identity](./media/ManagedIdentity.PNG)

Use the following [ARM template](https://docs.microsoft.com/azure/azure-resource-manager/templates/) to set up an Azure Functions function with access to Azure Key Vault. Replace the `***` variables to correct values for your environment.

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

You can also set Azure Key Vault policy through the Azure portal or by using the [Azure CLI](https://docs.microsoft.com/cli/azure/ext/keyvault-preview/keyvault?view=azure-cli-latest):

```azurecli
az keyvault set-policy --name $vault_name --spn $secret_manager_principal --secret-permissions set
az keyvault set-policy --name $vault_name --spn $function_managed_identity --secret-permissions get
```

## Interactive client to service call

You can use any database to store the tokens in encrypted format. The following diagram shows the sequence to store a user's refresh tokens in a database:

![Add token sequence](./media/add-token-sequence.PNG)

The sequence has two functions, `userId()` and `secretId()`. You can define these functions as some combination of `token.oid`, `token.tid`, and `token.sub`, but this definition is left to the implementation. For more information, see [Use the id_token](https://docs.microsoft.com/azure/active-directory/develop/id-tokens#using-the-id_token).

With the cryptographic key stored as a secret, you can look up the latest version of the key in Azure Key Vault.

## Server-side service call

Using the key is equally straightforward, but the following sequence queries the key based on the stored `version`. It's not recommended to use Azure Key Vault in the `http` pipeline, so cache these responses whenever possible. The diagram labels the calls to Key Vault that are candidates for caching.

![Use stored token](./media/use-stored-token.PNG)

The implicit key rotation is orthogonal to the application, so you can save the refresh token under a new key asynchronously. Azure Functions supports asynchronous processing with [Durable Functions](https://docs.microsoft.com/azure/azure-functions/durable/). For more information, see [HTTP features](https://docs.microsoft.com/azure/azure-functions/durable/durable-functions-http-features?tabs=csharp#http-api-url-discovery).

## Key rotation and token refresh flow

![Token refresh diagram](./media/refresh-diagram.svg)

You can do key rotation at the same times that you refresh the refresh token. The following sequence diagram illustrates this process:

![Token refresh sequence](./media/token-refresh-sequence.PNG)

Here you use a timer trigger, as in the Azure DevOps example. When you refresh the refresh token, the token gets encrypted using the latest version of the encryption key. Azure Functions has built-in support for timer triggers. For more information, see [Timer trigger for Azure Functions](https://docs.microsoft.com/azure/azure-functions/functions-bindings-timer?tabs=csharp).

## User management and access control

Removing a user or removing access per user is  straightforward. Just remove the user's record or the `refreshToken` part of the user data.

To remove access for a group of users, such as all users in a target tenant, delete the secret for this group based on `secretId()`. Azure Pipelines can be a good place to implement this functionality.
