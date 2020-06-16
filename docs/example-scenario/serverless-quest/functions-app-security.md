---
title: Azure Functions security
titleSuffix: Azure Example Scenarios
description: Learn about and implement Azure Functions security essentials, secure hosting setup, and application security guidance.
author: rogeriohc
ms.date: 04/28/2020
ms.topic: example-scenario
ms.service: architecture-center
ms.subservice: example-scenario
ms.custom:
- fcp
---
# Serverless Functions security

Azure provides many services to help secure applications in the cloud. This article address Azure services and activities to implement at each stage of the software development lifecycle to help develop more secure code and deploy a more secure cloud application.

## Planning

- Review [Secure development best practices on Azure](https://docs.microsoft.com/azure/security/develop/secure-dev-overview).
- Learn about the most common serverless application security vulnerabilities. [OWASP Serverless Top 10](https://owasp.org/www-project-serverless-top-10/) educates practitioners and organizations about the consequences of the most common serverless application security vulnerabilities, as well as providing basic techniques to identify and protect against them.
- Learn about Azure Functions security. The primary goals of a secure Azure Functions application environment are to protect running applications, quickly identify and address security issues, and prevent future similar issues. For more information, see:
  - [Security in Azure App Service](https://docs.microsoft.com/azure/app-service/overview-security)
  - [Built-in security controls](https://docs.microsoft.com/azure/app-service/app-service-security-controls)
- Review the Azure security shared responsibilities for your application and Azure Functions. See the following best practices whitepapers:
  - [Shared Responsibilities for Cloud Computing](https://gallery.technet.microsoft.com/Shared-Responsibilities-81d0ff91)
  - [Security best practices for Azure solutions](https://azure.microsoft.com/mediahandler/files/resourcefiles/security-best-practices-for-azure-solutions/Azure%20Security%20Best%20Practices.pdf)

## Deployment

To prepare an application for production:
- Conduct regular code reviews to identify code and library vulnerabilities.
- Define resource permissions that Functions must access to execute.
- Configure network security rules for inbound and outbound communication.
- Identify and classify sensitive data access.

Keep your code secure.
Find security vulnerabilities and errors in your code and manage security vulnerabilities in your project and dependencies. For more information, see:
- [GitHub - Finding security vulnerabilities and errors in your code](https://help.github.com/en/github/finding-security-vulnerabilities-and-errors-in-your-code)
- [GitHub - Managing security vulnerabilities in your project](https://help.github.com/en/github/managing-security-vulnerabilities/managing-security-vulnerabilities-in-your-project)
- [GitHub - Managing vulnerabilities in your project's dependencies](https://help.github.com/en/github/managing-security-vulnerabilities/managing-vulnerabilities-in-your-projects-dependencies)

Perform input validation.
Different event sources like Blob storage, Cosmos DB NoSQL databases, event hubs, queues, or Graph events can trigger Serverless Functions. Injections aren't strictly limited to inputs coming directly from the API calls. Functions can consume input from the possible event sources. In general, never trust input or make any assumptions about its validity. Always use safe APIs that sanitize or validate the input. When possible, use APIs which bind or parameterize variables, like using prepared statements for SQL queries. For more information, see:
[Azure Functions Input Validation with FluentValidation](https://www.tomfaltesek.com/azure-functions-input-validation/)
[Security Frame: Input Validation Mitigations](https://docs.microsoft.com/azure/security/develop/threat-modeling-tool-input-validation)
[HTTP Trigger Function Request Validation](https://marcroussy.com/2019/06/14/http-trigger-function-request-validation/)
[How to validate request for Azure Functions](https://medium.com/@tsuyoshiushio/how-to-validate-request-for-azure-functions-e6488c028a41)

Secure HTTPS endpoints for development, testing and production.
Functions lets you use keys to make it harder to access your HTTPS function endpoints during development. To fully secure your function endpoints in production, consider implementing one of the following Function app-level security options:
- Turn on App Service authentication and authorization for your Functions app. See [Authorization keys](https://docs.microsoft.com/azure/azure-functions/functions-bindings-http-webhook-trigger?tabs=csharp#authorization-keys)
- Use Azure API Management (APIM) to authenticate requests. See [Import an Azure Function App as an API in Azure API Management](https://docs.microsoft.com/azure/api-management/import-function-app-as-api).
- Deploy your Functions app to an Azure App Service Environment (ASE).
- Use an App Service Plan that restricts access, and implement Azure Front Door + WAF to handle your incoming requests. See [Create a Front Door for a highly available global web application](https://docs.microsoft.com/azure/frontdoor/quickstart-create-front-door).
For more information, see [Secure an HTTP endpoint in production](https://docs.microsoft.com/azure/azure-functions/functions-bindings-http-webhook-trigger?tabs=csharp#secure-an-http-endpoint-in-production).

Use managed identities and key vaults.
A common challenge when building cloud applications is how to manage credentials for authenticating to cloud services in your code. Credentials should never appear on developer workstations. Don't store credentials in application code or check them in to source control. Instead, use a key vault to store and retrieve keys and credentials. Azure Key Vault provides a way to securely store credentials, secrets, and other keys. The code authenticates to Key Vault to retrieve the credentials. For more information, see [Use Key Vault references for App Service and Azure Functions](https://docs.microsoft.com/azure/app-service/app-service-key-vault-references).

Managed identities let Function apps access resources like key vaults and storage accounts without requiring specific global access keys or connection strings. A full audit trail in the logs displays what identity executes a request to resources. Use role-based access control (RBAC) and managed identities to granularly control exactly what resources Azure Functions applications can access. For more information, see:
- [What are managed identities for Azure resources?](https://docs.microsoft.com/azure/active-directory/managed-identities-azure-resources/overview)
- [How to use managed identities for App Service and Azure Functions](https://docs.microsoft.com/azure/app-service/overview-managed-identity)

Set up role-based access control.
Azure role-based access control (RBAC) has several built-in Azure roles that you can assign to users, groups, service principals, and managed identities to control access to Azure resources. If the built-in roles don't meet your organization's specific needs, you can create your own Azure custom roles. Review each function before deployment to identify excessive permissions. Carefully examine functions to apply "least privilege" permissions, giving each function exactly, and only what it needs to successfully execute. Use RBAC to assign permissions to users, groups, and applications at a certain scope. The scope of a role assignment can be a subscription, a resource group, or a single resource. Avoid using wildcards whenever possible. For more information about RBAC, see:
- [What is role-based access control (RBAC) for Azure resources?](https://docs.microsoft.com/azure/role-based-access-control/overview)
- [Azure built-in roles](https://docs.microsoft.com/azure/role-based-access-control/built-in-roles)
- [Azure role-based access control (RBAC)](https://docs.microsoft.com/azure/role-based-access-control/overview)
- [Azure custom roles](https://docs.microsoft.com/azure/role-based-access-control/custom-roles)

Use shared access signature (SAS) tokens to provide limited access to resources and services.
A shared access signature (SAS) provides secure delegated access to resources in your storage account without compromising the security of your data. With a SAS, you have granular control over how a client can access your data. You can control what resources the client may access, what permissions they have on those resources, and how long the SAS is valid, among other parameters. For more information, see [Grant limited access to Azure Storage resources using shared access signatures (SAS)](https://docs.microsoft.com/azure/storage/common/storage-sas-overview).

Secure Blob storage.
Identify and classify sensitive data. Minimize storage of sensitive data to only what is absolutely necessary. For sensitive data storage, add multi-factor authentication, and data encryption in transit and at rest. Grant limited access to Azure Storage resources using shared access signatures (SAS). For more information, see [Security recommendations for Blob storage](https://docs.microsoft.com/azure/storage/blobs/security-recommendations).

## Optimization

Once the application is in production, optimize workflow and prepare the application and team to scale.
- Run a security scanning solution for your application.
- Enforce governance and application policies at scale.

Configure Azure Security Center and apply security recommendations.
Azure Security Center identifies potential security vulnerabilities and creates recommendations that guide you through the process of configuring the needed controls to harden and protect your resources. For more information, see:
- [Protect your applications with Azure Security Center](https://docs.microsoft.com/azure/security-center/security-center-virtual-machine-protection#app-services)
- [Security Center app recommendations](https://docs.microsoft.com/azure/security-center/recommendations-reference#recs-computeapp)

Enforce application governance policies.
Apply at-scale enforcements and safeguards on your application in a centralized, consistent manner. For more information, see [Azure Policy built-in policy definitions](https://docs.microsoft.com/azure/governance/policy/samples/built-in-policies).

