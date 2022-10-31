---
title: Azure Functions security
titleSuffix: Azure Example Scenarios
description: Learn about and implement Azure Functions security essentials, secure hosting setup, and application security guidance.
author: rogeriohc
ms.date: 06/22/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
categories: developer-tools
products:
  - azure-functions
  - azure-app-service
ms.custom:
  - fcp
  - guide
---
# Serverless Functions security

This article describes Azure services and activities security personnel can implement for serverless Functions. These guidelines and resources help develop secure code and deploy secure applications to the cloud.

## Planning

The primary goals of a secure serverless Azure Functions application environment are to protect running applications, quickly identify and address security issues, and prevent future similar issues.

The [OWASP Serverless Top 10](https://owasp.org/www-project-serverless-top-10/) describes the most common serverless application security vulnerabilities, and provides basic techniques to identify and protect against them.

In many ways, planning for secure development, deployment, and operation of serverless functions is much the same as for any web-based or cloud hosted application. Azure App Service provides the hosting infrastructure for your function apps. [Securing Azure Functions](/azure/azure-functions/security-concepts) article provides security strategies for running your function code, and how App Service can help you secure your functions.

For more information about Azure security, best practices, and shared responsibilities, see:

- [Security in Azure App Service](/azure/app-service/overview-security)
- [Built-in security controls](/azure/app-service/app-service-security-controls)
- [Secure development best practices on Azure](/azure/security/develop/secure-dev-overview).
- [Security best practices for Azure solutions (PDF report)](https://azure.microsoft.com/mediahandler/files/resourcefiles/security-best-practices-for-azure-solutions/Azure%20Security%20Best%20Practices.pdf)
- [Shared responsibilities for cloud computing (PDF report)](https://gallery.technet.microsoft.com/Shared-Responsibilities-81d0ff91)

## Deployment

To prepare serverless Functions applications for production, security personnel should:
- Conduct regular code reviews to identify code and library vulnerabilities.
- Define resource permissions that Functions needs to execute.
- Configure network security rules for inbound and outbound communication.
- Identify and classify sensitive data access.

The [Azure Security Baseline for Azure Functions](/azure/azure-functions/security-baseline) article contains more recommendations that will help you improve the security posture of your deployment.

### Keep code secure

Find security vulnerabilities and errors in code and manage security vulnerabilities in projects and dependencies.

For more information, see:
- [GitHub - Finding security vulnerabilities and errors in your code](https://help.github.com/en/github/finding-security-vulnerabilities-and-errors-in-your-code)
- [GitHub - Managing security vulnerabilities in your project](https://help.github.com/en/github/managing-security-vulnerabilities/managing-security-vulnerabilities-in-your-project)

### Perform input validation

Different event sources like Blob storage, Azure Cosmos DB NoSQL databases, event hubs, queues, or Graph events can trigger serverless Functions. Injections aren't strictly limited to inputs coming directly from the API calls. Functions may consume other input from the possible event sources.

In general, don't trust input or make any assumptions about its validity. Always use safe APIs that sanitize or validate the input. If possible, use APIs that bind or parameterize variables, like using prepared statements for SQL queries.

For more information, see:
- [Azure Functions Input Validation with FluentValidation](https://www.tomfaltesek.com/azure-functions-input-validation/)
- [Security Frame: Input Validation Mitigations](/azure/security/develop/threat-modeling-tool-input-validation)
- [HTTP Trigger Function Request Validation](https://marcroussy.com/2019/06/14/http-trigger-function-request-validation/)
- [How to validate request for Azure Functions](https://medium.com/@tsuyoshiushio/how-to-validate-request-for-azure-functions-e6488c028a41)

### Secure HTTP endpoints for development, testing, and production

Azure Functions lets you use keys to make it harder to access your HTTP function endpoints. To fully secure your function endpoints in production, consider implementing one of the following Function app-level security options:

- Turn on App Service authentication and authorization for your Functions app. See [Authorization keys](/azure/azure-functions/functions-bindings-http-webhook-trigger?tabs=csharp#authorization-keys).
- Use Azure API Management (APIM) to authenticate requests. See [Import an Azure Function App as an API in Azure API Management](/azure/api-management/import-function-app-as-api).
- Deploy your Functions app to an Azure App Service Environment (ASE).
- Use an App Service Plan that restricts access, and implement Azure Front Door + WAF to handle your incoming requests. See [Create a Front Door for a highly available global web application](/azure/frontdoor/quickstart-create-front-door).

For more information, see [Secure an HTTP endpoint in production](/azure/azure-functions/functions-bindings-http-webhook-trigger?tabs=csharp#secure-an-http-endpoint-in-production).

### Set up Azure role-based access control (Azure RBAC)

Azure role-based access control (Azure RBAC) has several Azure built-in roles that you can assign to users, groups, service principals, and managed identities to control access to Azure resources. If the built-in roles don't meet your organization's needs, you can create your own Azure custom roles.

Review each Functions app before deployment to identify excessive permissions. Carefully examine functions to apply "least privilege" permissions, giving each function only what it needs to successfully execute.

Use Azure RBAC to assign permissions to users, groups, and applications at a certain scope. The scope of a role assignment can be a subscription, a resource group, or a single resource. Avoid using wildcards whenever possible.

For more information about Azure RBAC, see:
- [What is Azure role-based access control (Azure RBAC)?](/azure/role-based-access-control/overview)
- [Azure built-in roles](/azure/role-based-access-control/built-in-roles)
- [Azure custom roles](/azure/role-based-access-control/custom-roles)

### Use managed identities and key vaults

A common challenge when building cloud applications is how to manage credentials for authenticating to cloud services in your code. Credentials should never appear in application code, developer workstations, or source control. Instead, use a key vault to store and retrieve keys and credentials. Azure Key Vault provides a way to securely store credentials, secrets, and other keys. The code authenticates to Key Vault to retrieve the credentials.

For more information, see [Use Key Vault references for App Service and Azure Functions](/azure/app-service/app-service-key-vault-references).

Managed identities let Functions apps access resources like key vaults and storage accounts without requiring specific access keys or connection strings. A full audit trail in the logs displays which identities execute requests to resources. Use Azure RBAC and managed identities to granularly control exactly what resources Azure Functions applications can access.

For more information, see:
- [What are managed identities for Azure resources?](/azure/active-directory/managed-identities-azure-resources/overview)
- [How to use managed identities for App Service and Azure Functions](/azure/app-service/overview-managed-identity)

### Use shared access signature (SAS) tokens to limit access to resources

A *shared access signature (SAS)* provides secure delegated access to resources in your storage account, without compromising the security of your data. With a SAS, you have granular control over how a client can access your data. You can control what resources the client may access, what permissions they have on those resources, and how long the SAS is valid, among other parameters.

For more information, see [Grant limited access to Azure Storage resources using shared access signatures (SAS)](/azure/storage/common/storage-sas-overview).

### Secure Blob storage

Identify and classify sensitive data, and minimize sensitive data storage to only what is necessary. For sensitive data storage, add multi-factor authentication and data encryption in transit and at rest. Grant limited access to Azure Storage resources using SAS tokens.

For more information, see [Security recommendations for Blob storage](/azure/storage/blobs/security-recommendations).

## Optimization

Once an application is in production, security personnel can help optimize workflow and prepare for scaling.

### Use Microsoft Defender for Cloud and apply security recommendations

Microsoft Defender for Cloud is a security scanning solution for your application that identifies potential security vulnerabilities and creates recommendations. The recommendations guide you to configure needed controls to harden and protect your resources.

For more information, see:
- [Protect your applications with Microsoft Defender for Cloud](/azure/security-center/security-center-virtual-machine-protection#app-services)
- [Defender for Cloud app recommendations](/azure/security-center/recommendations-reference#recs-computeapp)

### Enforce application governance policies

Apply centralized, consistent enforcements and safeguards to your application at scale. For more information, see [Azure Policy built-in policy definitions](/azure/governance/policy/samples/built-in-policies).

## Next steps

- [Serverless application development and deployment](application-development.md)
- [Azure Functions app operations](functions-app-security.md)
