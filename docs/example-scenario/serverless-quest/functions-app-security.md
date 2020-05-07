---
title: Azure functions app security
titleSuffix: Azure Example Scenarios
description: Learn about using Azure Functions for application security.
author: rogeriohc
ms.date: 04/28/2020
ms.topic: example-scenario
ms.service: architecture-center
ms.subservice: example-scenarios
ms.custom:
- fcp
---
# Azure functions app security

Familiarize yourself with Azure Functions security essentials and review the secure setup for hosting and application security guidance.

## Plan, train, and proof

As you get started, the checklist and resources below will help you plan the Functions application and hosting security. You should be able answer these questions:

- Have you reviewed the most common serverless application security vulnerabilities? 
- Have you reviewed the shared responsibilities for your application and Azure Functions?
- Is your Azure Functions application enabled managed identities?

| Checklist | Resources |
|------------------------------------------------------------------|-----------------------------------------------------------------|
| **Review the OWASP top 10 serverless interpretation.** OWASP Serverless Top 10 aims at educating practitioners and organizations about the consequences of the most common serverless application security vulnerabilities, as well as providing basic techniques to identify and protect against them.| [OWASP Serverless Top 10](https://owasp.org/www-project-serverless-top-10/)|
| **Review the security best practices and shared responsibilities.** These whitepapers are collections of security best practices to use when you’re designing, deploying, and managing your cloud solutions by using Microsoft Azure.| [Shared Responsibilities for Cloud Computing](https://gallery.technet.microsoft.com/Shared-Responsibilities-81d0ff91) <br/> [Security best practices for Azure solutions](https://azure.microsoft.com/mediahandler/files/resourcefiles/security-best-practices-for-azure-solutions/Azure%20Security%20Best%20Practices.pdf)|
| **Familiarize yourself with managed identities for Azure resources.** A common challenge when building cloud applications is how to manage the credentials in your code for authenticating to cloud services. Keeping the credentials secure is an important task. Ideally, the credentials never appear on developer workstations and aren't checked into source control. Azure Key Vault provides a way to securely store credentials, secrets, and other keys, but your code has to authenticate to Key Vault to retrieve them.| [What are managed identities for Azure resources?](https://docs.microsoft.com/azure/active-directory/managed-identities-azure-resources/overview) <br/> [How to use managed identities for App Service and Azure Functions](https://docs.microsoft.com/azure/app-service/overview-managed-identity)|
| **Familiarize yourself with the security in Azure Functions.** The primary goals of a secure Azure Functions application environment are ensuring that the applications it runs are protected, that security issues can be identified and addressed quickly, and that future similar issues will be prevented.| [Security in Azure App Service](https://docs.microsoft.com/azure/app-service/overview-security) <br/> [Built-in security controls](https://docs.microsoft.com/azure/app-service/app-service-security-controls)|

## Deploy to production and apply best practices

As you prepare the application for production, you should implement a minimum set of best practices. Use the checklist below at this stage. You should be able to answer these questions:
- Is your Azure Functions application enabled for role-based access control?
- Have you configured network security rules for inbound and outbound communication?
- Have you identified and classified sensitive data access?

| Checklist | Resources |
|------------------------------------------------------------------|-----------------------------------------------------------------|
| **Perform input validation.** Since serverless functions can be triggered from different events sources like storage (Blob), NoSQL database (CosmosDB), Event Hubs, Queue, Graph events and more, injections are not strictly limited to inputs coming directly from the API calls and functions can consume input from each type of the possible event sources. <br/> In general, never trust input or make any assumptions about its validity. Always use safe APIs that sanitize or validate the input. When possible, use APIs which bind or parameterize variables (e.g. using prepared statements for SQL queries).| tbd |
| **Manage application secrets.** Don't store credentials in your application code. A key vault should be used to store and retrieve keys and credentials.| [Use Key Vault references for App Service and Azure Functions](https://docs.microsoft.com/azure/app-service/app-service-key-vault-references)|
| **Secure the HTTP endpoints for development, testing and production.** Functions lets you use keys to make it harder to access your HTTP function endpoints during development. To fully secure your function endpoints in production, you should consider implementing one of the following function app-level security options: </br> Turn on App Service Authentication / Authorization for your function app. </br> Use Azure API Management (APIM) to authenticate requests. </br> Deploy your function app to an Azure App Service Environment (ASE). </br> Use an App Service Plan where you restrict access, and implement Azure Front Door + WAF to handle your incoming requests. | [Authorization keys](https://docs.microsoft.com/azure/azure-functions/functions-bindings-http-webhook-trigger?tabs=csharp#authorization-keys) </br> [Secure an HTTP endpoint in production](https://docs.microsoft.com/azure/azure-functions/functions-bindings-http-webhook-trigger?tabs=csharp#secure-an-http-endpoint-in-production) </br>  [Import an Azure Function App as an API in Azure API Management](https://docs.microsoft.com/azure/api-management/import-function-app-as-api) </br> [Create a Front Door for a highly available global web application](https://docs.microsoft.com/azure/frontdoor/quickstart-create-front-door) |
| **Setup role-based access control (RBAC).** Azure role-based access control (RBAC) has several Azure built-in roles that you can assign to users, groups, service principals, and managed identities. Role assignments are the way you control access to Azure resources. If the built-in roles don't meet the specific needs of your organization, you can create your own Azure custom roles. <br/> Review each function before deployment to identify excessive permissions. Carefully examine functions to apply “least privilege” permissions, giving each function exactly, and only what is required for the function to successfully execute its task. Use RBAC to assign permissions to users, groups, and applications at a certain scope. The scope of a role assignment can be a subscription, a resource group, or a single resource and avoid using wildcards whenever possible. | [What is role-based access control (RBAC) for Azure resources?](https://docs.microsoft.com/azure/role-based-access-control/overview) <br/> [Azure built-in roles](https://docs.microsoft.com/azure/role-based-access-control/built-in-roles) <br/> [Azure role-based access control (RBAC)](https://docs.microsoft.com/azure/role-based-access-control/overview) <br/> [Azure custom roles](https://docs.microsoft.com/azure/role-based-access-control/custom-roles)|
| **Use Shared Access Signature (SAS) tokens to get limited access to other resources and services.** A shared access signature (SAS) provides secure delegated access to resources in your storage account without compromising the security of your data. With a SAS, you have granular control over how a client can access your data. You can control what resources the client may access, what permissions they have on those resources, and how long the SAS is valid, among other parameters.| [Grant limited access to Azure Storage resources using shared access signatures (SAS)](https://docs.microsoft.com/azure/storage/common/storage-sas-overview)|
| **Secure Blob storage.** Identify and classify sensitive data. Minimize storage of sensitive data to only what is absolutely necessary. For sensitive data storage, add multi-factor authentication, and data encryption (in transit and at rest). Grant limited access to Azure Storage resources using shared access signatures (SAS). | [Security recommendations for Blob storage](https://docs.microsoft.com/azure/storage/blobs/security-recommendations)|
| **Deploy an API gateway if you use HTTP trigger.** An API gateway serves as a front door to microservices, decouples clients from your microservices, adds an additional layer of security, and decreases the complexity of your microservices by removing the burden of handling cross-cutting concerns.| [Import an Azure Function App as an API in Azure API Management](https://docs.microsoft.com/azure/api-management/import-function-app-as-api)|

## Optimize and scale

? Now that the application is in production, how can you optimize your workflow and prepare your application and team to scale? Use the optimization and scaling checklist to prepare. You should be able to answer these questions:
- ?
- ?

| Checklist | Resources |
|------------------------------------------------------------------|-----------------------------------------------------------------|
| **Configure Azure Security Center and apply security recommendations.** Azure Security Center identifies potential security vulnerabilities, it creates recommendations that guide you through the process of configuring the needed controls to harden and protect your resources. | [Protect your applications with Azure Security Center](https://docs.microsoft.com/azure/security-center/security-center-virtual-machine-protection#app-services) </br> [Security Center app recommendations](https://docs.microsoft.com/en-us/azure/security-center/recommendations-reference#recs-computeapp)|
| **Enforce application governance policies.** Apply at-scale enforcements and safeguards on your application in a centralized, consistent manner.| [Azure Policy built-in policy definitions](https://docs.microsoft.com/azure/governance/policy/samples/built-in-policies) |
| **Monitor 3rd-party dependencies.** tbc. Continuously monitor dependencies and their versions throughout the system using OWASP Dependency Track or any other system. Obtain components only from official sources over secure links. Prefer signed packages to reduce the chance of including a modified, malicious component. Continuously monitor packages with vulnerability databases like MITRE CVE and NVD. It is recommended to scan dependencies for known vulnerabilities using tools such as OWASP Dependency Check or a commercial solution.For dotnet, Use dotnet-retire. A tool to check dependencies for versions with known vulnerabilities. Check NuGet package vulnerabilities with OWASP SafeNuGet. Use runtime-dependent security databases such as pyup for Python and npm Security Advisories For Node. Use Audit.NET which integrates with VS to identify known vulnerabilities in .Net NuGet dependencies
| tbd|

## Next steps

To move forward with serverless - Azure Functions adoption, see the following resources:

- [Validate and commit the serverless adoption](./validate-commit-serverless-adoption.md)
- [Application development and deployment](./application-development.md)
- [Azure functions app operations](./functions-app-operations.md)

