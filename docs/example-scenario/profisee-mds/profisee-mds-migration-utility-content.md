This example scenario demonstrates how to migrate from SQL Server Master Data Services to a full-featured master data management (MDM) platform in Azure by using Profisee.

## Architecture

:::image type="content" source="images/profisee-microsoft-purview-reference-architecture.png" alt-text="Architecture diagram that shows the data flow during a migration from SQL Server Master Data Services to Profisee MDM." lightbox="images/profisee-microsoft-purview-reference-architecture.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/microsoft-purview-profisee-architecture.vsdx) of this architecture.*

### Dataflow

Metadata and data flow include these steps, which are shown in the preceding figure:

1. Prebuilt Microsoft Purview connectors are used to build a data catalog from source business applications. The connectors scan data sources and populate the Microsoft Purview Data Catalog.

1. The master data model is published to Microsoft Purview. Master data entities that are created in Profisee MDM are seamlessly published to Microsoft Purview. This step further populates the Microsoft Purview Data Catalog and ensures that there's a record of this critical source of data in Microsoft Purview.

1. Governance standards and policies for data stewardship are used to enrich master data entity definitions. The data is enriched in Microsoft Purview with data dictionary and glossary information, ownership data, and sensitive data classifications. Any definitions and metadata that are available in Microsoft Purview are visible in real time in Profisee as guidance for the MDM data stewards.

1. Master data from source systems is loaded into Profisee MDM. A data integration toolset like Azure Data Factory extracts data from the source systems by using any of more than 100 prebuilt connectors or a REST gateway. Multiple streams of master data are loaded into Profisee MDM.

1. The master data is standardized, matched, merged, enriched, and validated according to governance rules. Other systems, like Microsoft Purview, might define data quality and governance rules. But Profisee MDM is the system that enforces these rules.

   Source records are matched and merged within and across source systems to create the most complete and correct record possible. Data quality rules check each record for compliance with business and technical requirements. Any record that fails validation or that returns a low probability score is subject to remediation.

   To remediate failed validations, a workflow process assigns records that require review to data stewards who are experts in their business data domain. After a record has been verified or corrected, it's ready to use as a *golden record* master.

1. Transactional data is loaded into a downstream analytics solution. A data integration toolset like Data Factory extracts transactional data from source systems by using any of more than 100 prebuilt connectors or a REST gateway. The toolset loads the data directly into an analytics data platform like Azure Synapse Analytics. Analysis on this raw information without the proper master golden data is subject to inaccuracy, because data overlaps, data mismatches, and conflicts aren't yet resolved.

1. Power BI connectors provide direct access to the curated master data. Power BI users can use the master data directly in reports. A dedicated Power BI connector recognizes and enforces role-based security. It also hides various system fields to simplify use.

1. High-quality, curated master data is published to a downstream analytics solution. If master data records are merged into a single golden record, parent/child links to the original records are preserved.

1. The analytics platform has a set of data that's certified in the sense that it's complete, consistent, and accurate. That data includes properly curated master data and associated transactional data. That combination forms a solid foundation of trusted data that's available for further analysis.

1. The high-quality master data is visualized and analyzed, and machine learning models are applied. The system delivers sound insights for driving the business.

### Components

- [Microsoft Purview](https://azure.microsoft.com/services/purview) is a data governance solution that provides broad visibility into on-premises and cloud data estates. Microsoft Purview offers a combination of data discovery and classification, lineage, metadata search and discovery, and usage insights. All these features help you manage and understand data across your enterprise data landscape.

- [Power BI](https://powerbi.microsoft.com) is a suite of business analytics tools that delivers insights throughout your organization. You can use Power BI to connect to hundreds of data sources, simplify data preparation, and drive improvised analysis. You can also produce first-rate reports and then publish them for your organization to consume on the web and on mobile devices.

- [Data Factory](https://azure.microsoft.com/products/data-factory) is a hybrid data integration service. You can use Data Factory to create, schedule, and orchestrate extract, transform, and load (ETL) and extract, load, and transform (ELT) workflows. Data Factory also offers more than 100 prebuilt connectors and a REST gateway that you can use to extract data from source systems.

- [Azure Synapse Analytics](https://azure.microsoft.com/services/synapse-analytics) is a fast, flexible, and trusted cloud data warehouse that uses a massive parallel processing architecture. You can use Azure Synapse Analytics to scale, compute, and store data elastically and independently.

- [Profisee](https://profisee.com/platform) is a fast and scalable MDM platform that integrates seamlessly with Microsoft technologies and the Azure data management ecosystem.

### Alternatives

In Microsoft-centric environments, customers generally prefer [Azure Synapse Analytics](https://azure.microsoft.com/services/synapse-analytics) as an analytics service. But you can use any analytics database. Snowflake and Azure Databricks are common choices.

## Scenario details

Although Master Data Services continues to be supported as part of SQL Server, many users want to expand beyond reference data management. For many, the opportunity to upgrade to a full-featured MDM platform is the obvious choice, especially if they can do so with minimal effort and disruption.

Profisee MDM is a full-featured MDM platform that originally used Master Data Services as a foundation. Master Data Services was part of the architecture of early versions of the Profisee platform. Several original developers of Profisee MDM were also the original developers of Master Data Services.

Although the Master Data Services underpinning was removed several years ago, the Profisee architecture is still familiar to current Master Data Services users. All legacy Profisee users migrated to the current architecture from a version of Profisee that's based on Master Data Services. As a result, Profisee offers several automated migration capabilities that streamline Master Data Services migration down to a few steps.

Profisee core functionality includes data stewardship, data quality, golden record management, and relationship management. In Profisee, you can combine high-quality, trusted, and enriched master data with transactional data.

Master data is the data that defines a domain entity. Examples of master data include customer, product, asset, location, vendor, patient, household, menu item, and ingredient data. This data is typically present in multiple systems. To use cross-system data in a meaningful way, it's critical to resolve differing definitions and match and merge this data across systems.

The alternative is to use whatever information you can get. But when you take this approach, you risk generating misleading results that can damage your business. When you instead use well-curated master data, you provide a better, more reliable foundation for delivering sound insights, no matter which tools you use for analysis, machine learning, and visualization.

After you combine enriched master data with transactional data, you can send the combined data to Azure Synapse Analytics for downstream analytics and consumption. You can also use the officially certified Profisee connector for Power BI to load data directly from Profisee as a native data source in Power BI.

### Benefits of migrating to Profisee MDM

Aside from the ease of migration, there are several benefits of migrating to a fully featured MDM platform like Profisee, including:

- **Matching**. By matching between and within data sources, you can create a single golden record master.

- **Data quality**. You can enforce data quality and governance rules.

- **Data stewardship**. You can engage experts to approve low-probability matches and directly remediate problem data as required.

- **Workflow**. Profisee provides a way for you to orchestrate data routing issues to data stewards as required.

- **Multiple domains**. You can model and master data from multiple domains simultaneously in a single system, together with all reference data. Domains can include customer, product, location, asset, and others.

- **Deployment options**. Multiple options are available, including cloud-native platform as a service (PaaS) and turnkey software as a service (SaaS) solutions.

After migration, a new Profisee solution operates in full managed mode, eliminating the usual deployment and administration that come with on-premises solutions. For example, Azure Resource Management templates (ARM templates) automate the Profisee instance for you in Azure. Profisee is an all-Azure native solution. So you can resolve maintenance and operation-related support issues relatively easily and quickly.

Profisee is built on a modern cloud architecture as a containerized Kubernetes service for easy deployment and flexibility. You can use Profisee MDM for complete flexibility to deploy in any cloud, on-premises system, or hybrid environment. Or you can use a Profisee MDM SaaS solution in the Azure cloud as a full turnkey service for the quickest path to trusted data.

For complete flexibility, both Profisee MDM and Profisee MDM SaaS are available as *transactable* services in Azure Marketplace.

For more information, see the following resources:

- [Cloud-native MDM](https://profisee.com/cloud-master-data-management)
- [Profisee listings on Azure Marketplace](https://azuremarketplace.microsoft.com/marketplace/apps?search=profisee&page=1)

### Features of Master Data Services and Profisee MDM

Master Data Services helps organizations manage customer lists, product lists, hierarchies, state codes, cost centers, and other attributes. Profisee expands on the Master Data Services toolset by creating a more complete MDM platform, as shown by the functional areas in the following chart.

Although Profisee was once based on Master Data Services, the Profisee multiple-domain MDM platform has been re-engineered on a modern, PaaS architecture, which is also offered in a turnkey SaaS model. With native integrations into leading Azure services such as Microsoft Purview, Data Factory, Azure Synapse Analytics, and Power BI, Profisee is an ideal choice for modern Microsoft enterprises.

The following chart shows the expansion in capabilities that Profisee MDM offers over Master Data Services:

- MDM offers all the capabilities in the chart.
- Master Data Services offers the teal-colored capabilities.
- Master Data Services offers the multicolored capabilities to a limited extent. The amount of teal coloring indicates the extent that the capability is possible under Master Data Services. The coloring is approximate and appears in increments of 25 percent.

:::image type="content" source="images/master-data-services-features-overview.png" alt-text="Conceptual image that shows a comparison of Master Data Services and Profisee MDM." lightbox="images/master-data-services-features-overview.png" border="false":::

The preceding chart shows the functional expansion that Profisee MDM brings to Master Data Services. The close fit and synergy between the two services also demonstrate the advantage of using Profisee MDM to migrate reference data management to a cloud-native, multiple-domain platform. The diagram also illustrates why Profisee MDM is a natural successor for Master Data Services and how Profisee MDM can help you easily upgrade to full-featured MDM. The lightweight Master Data Services migration utility (MMU) in Profisee helps you quickly migrate your existing Master Data Services entities, hierarchies, users, and groups to Profisee.

#### Profisee MMU

The Profisee [MMU](https://profisee.com/solutions/microsoft-enterprise/master-data-services) helps ensure simple and fast migration from Master Data Services to full-featured MDM. Profisee includes MMU with its MDM platform.

#### Profisee MDM core features

Profisee MDM is a full-featured multiple-domain MDM solution that accommodates all the functionality that's available in Master Data Services:

- The Profisee core supports the creation and deployment of flexible entity models to represent and master any domain.

- Integration functionality in Profisee makes it easy to synchronize clean, consistent, and trusted data across enterprise applications and data warehouses. Profisee offers out-of-the-box, real-time, and bidirectional integrations. It also supports REST APIs and webhooks.

- Data stewards can use Profisee stewardship and governance capabilities to interact with their data. For instance, data stewards use this functionality for common tasks such as reviewing and approving matches and correcting data quality issues. The web-based user interface is intuitive and configurable. It provides a way to create applications that are tailored to typical data stewardship workflows and tasks.

- Profisee relationship management functionality supports the modeling and exploration of hierarchical (parent/child) roll-ups that are typically used in reference data management and analytics. Profisee also supports peer-level entity relationships through common attributes.

- By using Profisee golden record management, you can deduplicate data between and within data sources with automated match and merge and survivorship functions. Matching is based on machine-learning algorithms and is configurable for any master data domain and matching strategy. You can similarly configure survivorship rules to support specifying preferred sources when conflicts occur or to require human review of a low-confidence result. This feature includes a dedicated match-result viewer to explore and verify the matching process.

- Data quality in Profisee specifies data quality rules to verify valid data. Machine-learning anomaly detection helps flag out-of-band values and then route them for appropriate remediation.

- The Profisee workflow uses a highly configurable workflow engine to optimize and orchestrate the routing of various tasks to data stewards for review or intervention.

### Potential use cases

MDM use cases include the following retail and manufacturing scenarios:

- Consolidating customer data for analytics.
- Having a 360-degree view of product data in a consistent and accessible form, such as each product's name, description, and characteristics.
- Establishing reference data to consistently augment descriptions of master data. For example, reference data might include lists of countries/regions, currencies, colors, sizes, and units of measure.
- Supporting organizations like financial institutions that rely heavily on data for critical activities, such as timely reporting.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

The MMU is lightweight and easy to use, and it doesn't require installation. You can download this utility from the Profisee Support Portal and unzip the file into a desired directory. The MMU transfers data and model structures from Master Data Services 2014, 2016, and 2017 to Profisee MDM. The utility then re-creates the entities, attributes, relationships, and hierarchies from the current Master Data Services implementation directly within Profisee MDM.

Migration is a one-time process. You migrate each model only once.

Entities, hierarchies, users, groups, and data seamlessly migrate to Profisee. For more information, see the [MMU user guide](https://profisee.com/resources/mds-migration-utility).

> [!NOTE]
> Data quality rules aren't automatically migrated because advanced data quality structures are available in Profisee. But you can quickly re-create and expand most data quality rules in the Profisee no-code UI for data quality rules.

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

If you're a Profisee MDM SaaS customer, you can host data on Azure in regional pairs. The resources that are used to host Profisee Cloud are deployed across region pairs. The resources use multiple availability zones within a region for high availability, geo-replication across regions for disaster recovery, and strong backup policies. These options minimize downtime and make fast recovery and seamless failover possible when needed.

Profisee is a cloud-native application that runs on Azure services, including Azure Kubernetes Service (AKS), Azure SQL, and Azure Storage. The Profisee SaaS offering uses these underlying services to provide high availability within an Azure region and the ability to fail over to an alternative Azure region if a major outage in an Azure region occurs.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

The MMU requires users to connect to their Profisee instance and sign in with their verified credentials to open the utility. To migrate data models from Master Data Services, users must enter the URL of their Master Data Services database and enter valid credentials before they choose a data model.

For SaaS implementations that Profisee hosts on Azure, after you import Master Data Services models into the Profisee platform, the models are managed under the Profisee security policy. For more information, see [Profisee Security Overview](https://profisee.com/security).

A trusted audit firm, A-LIGN, has audited Profisee data security practices against the SOC 2 security framework. Profisee complies with laws and regulations that affect or are relevant to Profisee operations, such as General Data Protection Regulation (GDPR) or the California Consumer Privacy Act (CCPA). Profisee also implements security practices that follow industry-standard practices. Profisee reviews its security information program annually to identify and update the changes that are required to maintain a modern, proactive, and effective security program.

#### Encryption of data at rest

Customer data is stored in tenant-specific repositories, such as databases and storage accounts. All data at rest is encrypted with modern encryption standards and is reevaluated as required.

Repositories aren't accessible publicly. They're isolated on a private network with row-level security enabled. Access to rows is controlled through Azure Active Directory (Azure AD) roles and groups. Row-level security helps prevent unauthorized access. By implementing row-level security, Profisee prevents its own employees from accessing customer data without approval.

#### Encryption of data in transit

All network traffic to and from Profisee Cloud over the public internet encrypts data in transit by using TLS 1.2 or a later version.

#### Tenant isolation

Profisee Cloud uses dedicated repositories to provide complete tenant isolation between Profisee Cloud environments. Customer data isn't shared or commingled between environments. Users must be authenticated and authorized for each individual Profisee Cloud environment that they access. If a customer uses a common authentication provider like Azure AD across environments like development, test, and production environments, users gain the benefit of single sign-on (SSO) but are authorized independently for each environment.

#### Access security

Profisee uses SSO by way of OpenIDConnect-compliant providers, coupled with multifactor authentication. After customers deploy resources on the platform, they're responsible for using role-based access controls to manage their users, groups, and roles. Profisee has designed the Profisee Cloud solution with the principles of least privilege access in mind, requiring the minimum access necessary.

Along with the role-based access controls that are required to gain access to the platform, the Profisee solution internally supports customization and granular control. You can assign built-in roles or custom group permissions that support identity and access management controls that you can use for just-in-time access.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

The Profisee MMU is a free download from the Profisee Support Portal to all customers and is compatible with version 7.1.1 and later versions of the Profisee platform. The MMU can migrate models that are built in Master Data Services 2014, 2016, and 2017.

Profisee is a true multiple-domain MDM platform with domain-agnostic, volume-based pricing. Every deployment of the Profisee platform includes 500,000 unique records. Bulk pricing is available for large-scale implementations.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Benjamin Bourgeois](https://www.linkedin.com/in/benbourgeois1) | Content Marketing Manager
- [Martin Boyd](https://www.linkedin.com/in/martin-boyd-6714b4) | VP Product Marketing

Other contributors:

- [Brian Barnett](https://www.linkedin.com/in/brian-barnett-ga) | Software Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- For more information about Profisee, see the [Profisee website](https://profisee.com).
- For instructions on upgrading from Master Data Services to Profisee, see the [Profisee MMU](https://profisee.com/solutions/microsoft-enterprise/master-data-services) web-page.
- To learn more about the shared history between Profisee and SQL Server Master Data Services, see a [blog from one of the original architects of Master Data Services](https://profisee.com/blog/4-key-takeaways-mds-migration-options-and-why-you-should-switch).
- To view a webinar with the original architect of Master Data Services, see [Master Data Services migration options and why you should switch](https://profisee.com/resources/mdm-resource-hub/videos/master-data-services-migration-options-and-why-you-should-switch).

## Related resources

- [Data governance with Profisee and Microsoft Purview](../../reference-architectures/data/profisee-master-data-management-purview.yml)
- [Master data management with Profisee and Azure Data Factory](../../reference-architectures/data/profisee-master-data-management-data-factory.yml)
- [Azure data architecture guide](../../data-guide/index.md)
- [Analytics end-to-end with Azure Synapse](../../example-scenario/dataplate2e/data-platform-end-to-end.yml)
- [Microsoft Purview - Profisee MDM integration](/azure/purview/how-to-deploy-profisee-purview-integration)
