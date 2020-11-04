---
title: Secure application's configuration and dependencies
description: Check the dependencies, frameworks, and libraries.
author: PageWriter-MSFT
ms.date: 10/27/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: well-architected
ms.custom:
  - article
---

# Secure application configuration and dependencies

Security of an application that is hosted in Azure is a shared responsibility between you as the application owner and Azure. For IaaS, you are responsible for configurations related to VM, operating system, and components installed on it. For PaaS, you are responsible for the security of the application service configurations and making sure that the dependencies used by the application are also secure.

## Key points
- Do not store secrets in source code or configuration files. Instead keep them in a secure store, such as Azure Key Vault.
- Do not expose detailed error information when handling application exceptions.
- Do not expose platform-specific information.
- Restrict access to Azure resources that do not meet the security requirements.
- Validate the security of any open-source code added to your application.
- Update frameworks and libraries as part of the application lifecycle. 

## Configuration security

During the design phase, consider the way you store secrets and handle exceptions. Here are some considerations.

**Are application keys and secrets stored securely?**
***

Configuration within in the application can include secrets like database connection strings, certificate keys, and so on. Do not store secrets in source code or configuration files. Instead keep them in a secure store, such as Azure Key Vault. If you need to store secrets in code, identify them with static code scanning tools. Add the scanning process in your continuous integration (CI) pipeline.

**Are errors and exceptions handled properly without exposing that information to users?**
***

When handling application exceptions, make the application fail gracefully and log the error. Do not provide detailed information related to the failure, such as call stack, SQL queries, or out of range errors. This information can provide attackers with valuable information about the internals of the application.

**Is platform-specific information removed from server-client communication?**
***

Do not reveal information about the application platform. Such information (for example, "X-Powered-By", "X-ASPNET-VERSION") can get exposed through HTTP banners HTTP headers, error messages, website footers. Malicious actors can use this information when mapping attack vectors of the application.

Consider using Azure CDN to separate the hosting platform from end users. Azure API Management offers transformation policies that allow you to modify HTTP headers and remove sensitive information.

**Are Azure policies used to control the configuration of the solution resources?**
***

Use Azure Policy to deploy desired settings where applicable. Block resources that do not meet the proper security requirements defined during service enablement.


## Dependencies, frameworks, and libraries

**What are the frameworks and libraries used by the application?**
***

It's important to be aware of the implications of using third-party frameworks and libraries in your application code. These components can result in vulnerabilities. Here are some best practices:

- Validate the security of any open-source code added to your application. Tools that can help this assessment:
    - [OWASP Dependency-Check](https://owasp.org/www-project-dependency-check/)
    - [NPM audit](https://docs.npmjs.com/cli/audit)

- Maintain a list of frameworks and libraries as part of the application inventory. Also, keep track of versions in use.

- Update frameworks and libraries as part of the application lifecycle. Prioritize critical security patches. 

## Referenced Azure services

- [Azure Key Vault](/azure/key-vault/general/overview)
- [Azure CDN](/azure/cdn/cdn-features)
- [Azure Policy](/azure/governance/policy/overview)


## Next steps

- [Applications and services](design-apps-services.md)
- [Application classification](design-apps-considerations.md)
- [Application threat analysis](design-threat-model.md)
- [Regulatory compliance](design-regulatory-compliance.md)

