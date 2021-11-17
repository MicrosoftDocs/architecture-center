---
title: Secure app configuration and dependencies
description: Review application security for IaaS and PaaS. Make sure your configuration is secure. Also check the dependencies, frameworks, and libraries.
author: PageWriter-MSFT
ms.date: 09/23/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
products:
  - azure-key-vault
categories:
  - security
subject:
  - security
  - configuration
ms.custom:
  - article
---

# Secure application configuration and dependencies

Security of an application that is hosted in Azure is a shared responsibility between you as the application owner and Azure. For IaaS, you're responsible for configurations related to VM, operating system, and components installed on it. For PaaS, you're responsible for the security of the application service configurations and making sure that the dependencies used by the application are also secure.

## Key points
> [!div class="checklist"]
> - Don't store secrets in source code or configuration files. Instead, keep them in a secure store, such as Azure App Configuration or Azure Key Vault.
> - Don't expose detailed error information when handling application exceptions.
> - Don't expose platform-specific information.
> - Store application configuration outside of the application code to update it separately and to have tighter access control.
> - Restrict access to Azure resources that don't meet the security requirements.
> - Validate the security of any open-source code added to your application.
> - Update frameworks and libraries as part of the application lifecycle.

## Configuration security

During the design phase, consider the way you store secrets and handle exceptions. Here are some points.

<a id="secrets">**How is application configuration stored and how does the application access it?**</a>
***

Application configuration information can be stored with the application. However, that's not a recommended practice. Consider using a dedicated configuration management system such as Azure App Configuration or Azure Key Vault. That way, it can be updated independently of the application code.

Applications can include secrets like database connection strings, certificate keys, and so on. Don't store secrets in source code or configuration files. Instead, keep them in a secure store, such as Azure Key Vault. Identify secrets in code with static code scanning tools. Add the scanning process in your continuous integration (CI) pipeline.

For more information about secret management, reference [Key and secret management](design-storage-keys.md).

**Are errors and exceptions handled properly without exposing that information to users?**
***

When handling application exceptions, make the application fail gracefully and log the error. Don't provide detailed information related to the failure, such as call stack, SQL queries, or out of range errors. This information can provide attackers with valuable information about the internals of the application.

<a id="config-change">**Can configuration settings be changed or modified without rebuilding or redeploying the application?**</a>
***

Application code and configuration shouldn't share the same lifecycle to enable operational activities. These activities include those that change and update specific configurations without developer involvement or redeployment.

**Is platform-specific information removed from server-client communication?**
***

Don't reveal information about the application platform. Such information (for example, `X-Powered-By`, `X-ASPNET-VERSION`) can get exposed through HTTP banners, HTTP headers, error messages, and website footers. Malicious actors can use this information when mapping attack vectors of the application.

**Suggested actions**

Consider using Azure Front Door or API Management to remove platform-specific HTTP headers. Instead, use Azure CDN to separate the hosting platform from end users. Azure API Management offers transformation policies that allow you to modify HTTP headers and remove sensitive information.

**Learn more**

- [Azure Front Door Rules Engine Actions](/azure/frontdoor/front-door-rules-engine-actions)
- [API Management documentation](/azure/api-management/)

**Are Azure policies used to control the configuration of the solution resources?**
***

Use Azure Policy to deploy settings where applicable. Block resources that don't meet the proper security requirements defined during service enablement.

## Dependencies, frameworks, and libraries

**What are the frameworks and libraries used by the application?**
***

Application frameworks are frequently updated and released by the vendor or communities. It's vital to track the frameworks and libraries used by the application including any resulting vulnerabilities they introduce. These frameworks and libraries include custom, OSS, third party, and others. Understand and manage the technologies the application uses, such as:

- .NET Core
- Spring
- Node.js

Automated solutions can help with this assessment.

Consider the following best practices:

- Validate the security of any open-source code added to your application. Free tools to help with this assessment include:

   - OWASP Dependency-Check
   - NPM audit
   - WhiteSource Bolt

  These tools find outdated components and update them to the latest versions.

- Maintain a list of frameworks and libraries as part of the application inventory. Also, keep track of versions in use. If vulnerabilities are published, this awareness helps to identify affected workloads.

- Update frameworks and libraries as part of the application lifecycle. Prioritize critical security patches.

<a id="SSL">**Are the expiry dates of SSL/TLS certificates monitored and are processes in place to renew them?**</a>
***

Tracking expiry dates of SSL/TLS certificates and renewing them in due time is highly critical. Ideally, the process should be automated, although this often depends on the CA used for the certificate. If not automated, sufficient alerting should be applied to ensure expiry dates don't go unnoticed.

**Learn more**

- [WhiteSource Bolt](https://bolt.whitesourcesoftware.com/)
- [npm-audit](https://docs.npmjs.com/cli/audit)
- [OWASP Dependency-Check](https://owasp.org/www-project-dependency-check/)

## Referenced Azure services

- [Azure Key Vault](/azure/key-vault/general/overview)
- [Azure CDN](/azure/cdn/cdn-features)
- [Azure Policy](/azure/governance/policy/overview)

## Next steps

- [Applications and services](design-apps-services.md)
- [Application classification](design-apps-considerations.md)
- [Application threat analysis](design-threat-model.md)
- [Regulatory compliance](design-regulatory-compliance.md)

## Community resources

- [OWASP Dependency-Check](https://owasp.org/www-project-dependency-check/)
- [NPM audit](https://docs.npmjs.com/cli/audit)
