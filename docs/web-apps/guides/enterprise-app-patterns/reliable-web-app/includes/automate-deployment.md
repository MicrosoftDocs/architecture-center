---
author: ssumner
ms.author: pnp
ms.date: 10/15/2024
ms.topic: include
---
Use automation to deploy and update Azure resources and code across all environments. Follow these recommendations:

- *Use IaC.* Deploy [IaC](/azure/well-architected/operational-excellence/infrastructure-as-code-design) by using continuous integration and continuous delivery (CI/CD) pipelines. Azure provides prebuilt [Bicep templates, Azure Resource Manager templates (ARM templates) JSON, and Terraform templates](/azure/templates) for every Azure resource.

- *Use a CI/CD pipeline.* Use a CI/CD pipeline to deploy code from source control to your various environments, such as test, staging, and production. Use Azure Pipelines if you work with Azure DevOps. Use GitHub Actions for GitHub projects.

- *Integrate unit testing.* Prioritize running and validating all unit tests within your pipeline before deployment to App Service. Incorporate code quality and coverage tools like SonarQube to achieve comprehensive testing coverage.

- *Adopt mocking frameworks.* For testing that involves external endpoints, use mocking frameworks. These frameworks enable you to create simulated endpoints. They eliminate the need to configure real external endpoints and ensure uniform testing conditions across environments.

- *Perform security scans.* Use static application security testing (SAST) to find security flaws and coding errors in your source code. Conduct software composition analysis (SCA) to examine non-Microsoft libraries and components for security risks. Integrate tools for these analyses into both GitHub and Azure DevOps.
