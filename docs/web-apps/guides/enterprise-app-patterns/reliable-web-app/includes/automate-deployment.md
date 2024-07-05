:::row:::
    :::column:::
        *Well-Architected Framework benefit: Operational Excellence ([OE:05](/azure/well-architected/operational-excellence/infrastructure-as-code-design))*
    :::column-end:::
:::row-end:::

Use automation to deploy and update Azure resources and code across all environments. Follow these recommendations:

- *Use infrastructure as code.* Deploy [infrastructure as code](/azure/well-architected/operational-excellence/infrastructure-as-code-design) through a continuous integration and continuous delivery (CI/CD) pipelines. Azure has premade [Bicep, ARM (JSON), and Terraform templates](/azure/templates/) for every Azure resource.

- *Use a continuous integration/continuous deployment (CI/CD) pipeline.* Use a CI/CD pipeline to deploy code from source control to your various environments, such as test, staging, and production. Utilize Azure Pipelines if you're working with Azure DevOps or GitHub Actions for GitHub projects.

- *Integrate unit testing.* Prioritize the execution and passing of all unit tests within your pipeline before any deployment to App Services. Incorporate code quality and coverage tools like SonarQube to achieve comprehensive testing coverage.

- *Adopt mocking framework.* For testing involving external endpoints, utilize mocking frameworks. These frameworks allow you to create simulated endpoints. They eliminate the need to configure real external endpoints and ensuring uniform testing conditions across environments.

- *Perform security scans.* Employ static application security testing (SAST) to find security flaws and coding errors in your source code. Additionally, conduct software composition analysis (SCA) to examine third-party libraries and components for security risks. Tools for these analyses are readily integrated into both GitHub and Azure DevOps.