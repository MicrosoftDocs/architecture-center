The [medallion lakehouse](/azure/databricks/lakehouse/medallion) architecture is a frequently used enterprise data design pattern. You can use this design pattern to logically organize raw data in its native format within a large and centralized repository. Incrementally enrich data as it flows through each layer of the architecture. This process improves the structure, quality, and insight that you can derive from the data.

[Azure Data Factory](/azure/data-factory) is an Azure platform-as-a-service solution for scale-out serverless data integration and data transformation. Data Factory performs the extraction, transformation, and loading processes within the medallion lakehouse that are required across the various components to generate value from the raw data source.

This article provides a series of designs that typically progress from an initial implementation to enterprise-wide adoption, and ultimately to mission-critical expansion for specific solutions. This guidance supports customers on a similar cloud adoption journey.

## Get started

If you're embarking on your cloud adoption journey with the medallion lakehouse architecture, start with these training modules.

- [Data Factory](/training/paths/data-integration-scale-azure-data-factory) for data ingestion.

- [Azure Databricks](/training/paths/data-engineer-azure-databricks) for data processing at scale.

- [SQL Server](/training/paths/azure-sql-fundamentals) for data modeling.

- [Power BI](/credentials/certifications/power-bi-data-analyst-associate) for data serving and reporting.

Learn how to design and build secure, scalable, and high-performing solutions in Azure by using the pillars of the [Azure Well-Architected Framework](/training/paths/azure-well-architected-framework). This free online resource provides interactive training that includes knowledge checks to evaluate your learning.

For product documentation, see the following resources:

- [Data Factory](/azure/data-factory/)
- [Azure Databricks](/azure/databricks/)
- [SQL Server](/azure/azure-sql/)
- [Power BI](/power-bi/)

## Baseline implementation

After you learn how to deploy Data Factory for data ingestion, develop your [medallion lakehouse architecture](/azure/databricks/lakehouse/medallion) for data processing by using Azure Databricks, and then serve that data to Power BI by using Azure SQL as the persisted store. You can apply your skills to design and establish a simple solution by using an on-premises data source.

Refer to the baseline architecture that deploys Data Factory instances for data ingestion, Azure Databricks for data processing, and Azure SQL for storing the processed data, all within a single zone-redundant region.

> [!div class="nextstepaction"]
> [Reference architecture: Medallion lakehouse with Data Factory baseline implementation](azure-data-factory-on-azure-landing-zones-baseline.yml)

## Enterprise adoption and hardening

To comply with common enterprise security and governance nonfunctional requirements (NFRs) for production workloads, you should add enterprise hardening patterns to the baseline architecture. For example, an NFR might require the solution to use federated resources that central teams manage. To avoid service disruptions, it's crucial to communicate your requirements effectively with those teams.

Refer to this architecture that deploys an enterprise-hardened implementation. This implementation extends the [hub-and-spoke topology](/azure/architecture/networking/architecture/hub-spoke-virtual-wan-architecture) according to [Azure landing zone](/azure/cloud-adoption-framework/ready/landing-zone/) principles.

> [!div class="nextstepaction"]
> [Reference architecture: Enterprise-hardened workload with Data Factory](azure-data-factory-enterprise-hardened.yml)

## Mission-critical uplift

The last step in this path is to expand the infrastructure and processes of an individual solution infrastructure to support a mission-critical service-level agreement. [Mission-critical](/azure/well-architected/mission-critical/mission-critical-overview) refers to solutions that cause business-critical or safety-critical problems when they underperform or are unavailable.

The solution must ensure high availability, quick responsiveness to operational problems, consistent performance, and robust security. Mission-critical architectures must balance performance and resiliency requirements and targets with cost optimization.

> [!div class="nextstepaction"]
> [Reference architecture: Mission-critical workload with Data Factory](azure-data-factory-mission-critical.yml)

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Leo Kozhushnik](https://www.linkedin.com/in/leo-kozhushnik-ab16707/) | Cloud Solution Architect
- [Darren Turchiarelli](https://www.linkedin.com/in/darren-turchiarelli/) | Cloud Solution Architect
- [Scott Mckinnon](https://www.linkedin.com/in/scott-mckinnon-96756a83) | Cloud Solution Architect
- [Nicholas Moore](https://www.linkedin.com/in/nicholas-moore/) | Cloud Solution Architect

Other contributors:

- [Justice Zisanhi](https://www.linkedin.com/in/justice-zisanhi/) | Cloud Solution Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [Azure landing zones](/azure/cloud-adoption-framework/ready/landing-zone/)
- [Well-Architected Framework](/azure/well-architected/)
- [Azure mission-critical guidance](/azure/well-architected/mission-critical/mission-critical-overview)
- [Medallion lakehouse architecture](/azure/databricks/lakehouse/medallion)

## Related resources

- [Modern analytics architecture with Azure Databricks](/azure/architecture/solution-ideas/articles/azure-databricks-modern-analytics-architecture)
