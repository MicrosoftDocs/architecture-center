:::row:::
    :::column:::
        *Well-Architected Framework alignment - Operational Excellence ([OE:05](/azure/well-architected/operational-excellence/infrastructure-as-code-design))*
    :::column-end:::
:::row-end:::
---

Use [infrastructure as code](/azure/well-architected/operational-excellence/infrastructure-as-code-design) and deploy through a continuous integration and continuous delivery (CI/CD) pipelines. Azure has premade [Bicep, ARM (JSON), and Terraform templates](/azure/templates/) for every Azure resource. The reference implementation uses Bicep to deploy and configure all Azure resources.