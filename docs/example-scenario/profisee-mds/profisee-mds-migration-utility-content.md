This example scenario demonstrates how to migrate from SQL Server Master Data Services (MDS) to a full-featured master data management (MDM) platform in  Azure by using Profisee.

## Architecture

![Architectural diagram showing the data flow when migrating from SQL Server MDS to Profisee MDM.](./images/profisee-purview-reference-architecture.png)

*Download a [Visio file](https://arch-center.azureedge.net/microsoft-purview-profisee-architecture.vsdx) of this architecture.*

### Dataflow

Metadata and data flow include these steps, which are shown in the preceding figure:

1. Pre-built Microsoft Purview connectors are used to build a data catalog from source business applications. The connectors scan data sources and populate the Microsoft Purview Data Catalog.

1. The master data model is published to Microsoft Purview. Master data entities that are created in Profisee MDM are seamlessly published to Microsoft Purview. This step further populates the Microsoft Purview Data Catalog and ensures that there's a record of this critical source of data in Microsoft Purview.

1. Governance standards and policies for data stewardship are used to enrich master data entity definitions. The data is enriched in Microsoft Purview with data dictionary and glossary information, ownership data, and sensitive data classifications. Any definitions and metadata that are available in Microsoft Purview are visible in real time in Profisee as guidance for the MDM data stewards.

1. Master data from source systems is loaded into Profisee MDM. A data integration toolset like Azure Data Factory extracts data from the source systems by using any of more than 100 pre-built connectors or a REST gateway. Multiple streams of master data are loaded into Profisee MDM.

1. **Standardize, match, merge, enrich, and validate master data according to governance rules.** Although data quality and governance rules might be defined in other systems (such as Microsoft Purview), Profisee MDM is where they're enforced. Source records are matched and merged both within and across source systems to create the most complete and correct record possible. Data quality rules check each record for compliance with business and technical requirements. Any record failing validation or matching with only a low probability score is subject to remediation. To remediate failed validations, a workflow process assigns records requiring review to data stewards who are experts in their business data domains. After records are verified or corrected, they're ready to use as a golden record master.

1. **Load transactional data to downstream analytics solution.** Azure Data Factory (or any DI toolset) extracts transactional data from source systems with 100+ pre-built connectors or REST gateway. The data loads direct to the analytic data platform, whether Azure Synapse Analytics or any other analytic database. Analysis on this raw information without proper master (golden) data is subject to inaccuracy if the data overlaps, mismatches, and conflicts aren't yet resolved.

1. **Direct master data access through Power BI connector.** The connector provides direct access to curated master data, including secure data access for reporting in [Power BI](https://powerbi.microsoft.com/). Power BI users can report directly on master data through a dedicated Power BI connector that recognizes and enforces role-based security and hides various system fields for simplicity.

1. **Publish master data.** High quality, curated master data is published to downstream analytics solution. When master data records are then merged into a single golden record, you can preserve the parent-child links to the original records.

1. **Analyze complete, consistent data foundation.** The analytics platform has a complete set of certified data (complete, consistent, accurate), including both master data and associated transactional data. With this combination of properly curated master data, plus transactional data, you have a solid foundation of trusted data for further analysis. In Microsoft-centric environments, [Azure Synapse](https://azure.microsoft.com/services/synapse-analytics/) is preferred, although you can use any analytic database. Both Snowflake and Azure Databricks are common choices.

1. **Understand visualization and analytics.** Visualization and analytics with high-quality master data eliminates common data quality issues to improve insights that drive your business. Visualization and analytics improve data quality and deliver improved insights no matter what tools you use for analysis (including machine learning) and visualization. Well-curated master data forms a better and more reliable data foundation. Without well-formed data, you might end up using whatever information you can get, which can lead to misleading results that can damage your business.

### Components

- [Microsoft Purview](https://azure.microsoft.com/services/purview/) is a data governance solution that provides broad visibility into on-premises and cloud data estates. It offers a combination of data discovery and classification, lineage, metadata search and discovery, and usage insights. All of these features help you manage and understand data across your enterprise data landscape.

- [Power BI](https://powerbi.microsoft.com/) is a suite of business analytics tools that delivers insights throughout your organization. Connect to hundreds of data sources, simplify data preparation, and drive improvised analysis. Produce beautiful reports and then publish them for your organization to consume on the web and on mobile devices.

- [Azure Data Factory](https://azure.microsoft.com/products/data-factory/) is a hybrid data integration service that lets you create, schedule, and run your ETL/ELT workflows.

- [Azure Synapse Analytics](https://azure.microsoft.com/services/synapse-analytics/) is a fast, flexible, and trusted cloud data warehouse that lets you scale, compute, and store data elastically and independently, with a massive parallel processing architecture.

- [Profisee](https://profisee.com/platform/) is a fast and scalable MDM platform that integrates seamlessly with Microsoft technologies and the Azure data management ecosystem.

## Scenario details

Since June 2021, we no longer actively support SQL Server Master Data Services (MDS), and we only provide maintenance for the current version. As a result, long-time users are moving to other options. For many, the opportunity to upgrade to a more full-featured Master Data Management (MDM) platform is the obvious choice, especially if you can do so with minimal effort and disruption.

Profisee MDM is a full-featured MDM platform that was originally built using MDS as a foundation. Several of the original developers of Profisee MDM were the original developers of MDS. MDS was part of the architecture of early versions of the Profisee Platform.

Although the MDS underpinning was removed several years ago, it still represents a familiar architecture to current MDS users. Since all legacy Profisee users migrated from an MDS-based version of Profisee to the current architecture, Profisee developed several automated migration capabilities to streamline MDS migration for users down to a few steps.

Profisee core functionality includes data stewardship, data quality, golden record management, and relationship management. You can combine high-quality, trusted, and enriched master data with transactional data sent into Azure Synapse for downstream analytics and consumption. Or, you can use the officially certified Profisee Connector for Power BI to load data directly from Profisee as a native data source in Power BI.

### Benefits of migrating to Profisee MDM

Aside from the ease of migration, there are several benefits of migrating to a fully featured MDM platform like Profisee, including:

- **Matching.** Create a single golden record master by matching between and within data sources.

- **Data quality.** Enforce data quality and governance rules.

- **Data stewardship.** Engage experts to approve low-probability matches and directly remediate problem data, as required.

- **Workflow.** Orchestrate data routing issues to data stewards, as required.

- **Multidomain.** Model and master data from multiple domains (customer, product, location, asset, and more) simultaneously in a single system, together with all reference data.

- **Deployment options.** Use cloud-native platform as a service (PaaS) and turnkey software as a service (SaaS).

Upon migration, a new Profisee solution operates in full managed mode, eliminating usual deployment and administration that comes with on-premises solutions. For example, ARM templates automate the Profisee instance for you in Azure. Profisee is an all-Azure native solution. So, resolving maintenance and operation-related support issues becomes easier and quicker.

Profisee is built on a modern cloud architecture as a containerized Kubernetes service for easy deployment and flexibility. You can use Profisee MDM for complete flexibility to deploy in any cloud, on-premises, or in a hybrid environment. Or you can use Profisee MDM SaaS in the Azure cloud as a full turnkey service for the quickest path to trusted data.

For complete flexibility, both Profisee MDM and Profisee MDM SaaS are available as *transactable* services in Azure Marketplace.

For more information, see the following:

- [Cloud-native MDM](https://profisee.com/cloud-master-data-management/)
- [Profisee listings on Azure Marketplace](https://azuremarketplace.microsoft.com/en-us/marketplace/apps?search=profisee&page=1)

### Features of MDS and Profisee MDM

MDS helps organizations manage customer lists, product lists, hierarchies, state codes, cost centers, and other attributes. Profisee expands on the MDS toolset by creating a more complete MDM platform, as shown by the functional areas in the following chart.

Although Profisee was once based on MDS, its multi-domain MDM platform has been re-engineered on a modern, PaaS architecture, which is also offered in a turnkey SaaS model. With native integrations into leading Azure services such as Microsoft Purview, Azure Data Factory, Azure Synapse, and Power BI, Profisee is an ideal choice for modern Microsoft enterprises.

This chart shows the expansion in capabilities offered by Profisee MDM over MDS:

![Diagram showing a comparison of MDS and Profisee MDM.](./images/mds-features-overview.png)

Along with the functional expansion shown in the preceding chart, the close fit and synergy from MDS to Profisee demonstrates the advantage of migrating reference data management to a cloud-native, multi-domain platform with Profisee MDM. It also demonstrates why Profisee MDM is a natural successor from MDS, helping organizations easily upgrade to full-featured MDM. Profisee’s lightweight MDS Migration Utility helps users quickly migrate their existing MDS entities, hierarchies, users, and groups to Profisee.

#### Profisee MDS Migration Utility (MMU)

To ensure simple and fast migration from MDS to full-featured MDM, Profisee developed the [MDS Migration Utility (MMU)](https://profisee.com/solutions/microsoft-enterprise/master-data-services/) and includes it with the Profisee MDM platform.

#### Profisee MDM core features

Profisee MDM is a full-featured multi-domain MDM solution that accommodates all functionality available in MDS.

- **Profisee core:** Supports the creation and deployment of flexible entity models to represent and master any domain.

- **Integration:** Makes it easy to synchronize clean, consistent, and trusted data across enterprise applications and data warehouses with out-of-the-box, real-time, and bi-directional integrations and support for REST APIs and webhooks.

- **Stewardship and governance:** Lets data stewards interact with their data for common tasks such as reviewing and approving matches and correcting data quality issues. The web-based user interface is intuitive and configurable to create applications tailored to typical data stewardship workflows and tasks.

- **Relationship management:** Supports modeling and exploration of both hierarchical (parent-child) roll-ups (typically used in reference data management and analytics) and peer-level entity relationships through common attributes.

- **Golden record management:** De-duplicates data between and within data sources with automated match and merge and survivorship functions. Matching is based on machine-learning algorithms and configurable for any master data domain and matching strategy. You can similarly configure survivorship rules to support specifying preferred sources when conflicts occur or to require human review of a low-confidence result. This feature includes a dedicated match-result viewer to explore and verify the matching process.

- **Data quality:** Specifies data quality rules to verify valid data. Machine-learning anomaly detection helps flag out-of-band values and then route them for appropriate remediation.

- **Workflow:** Optimizes and orchestrates routing of various tasks to data stewards for review or intervention, through a highly configurable workflow engine.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

The MMU utility is lightweight and easy to use, and it doesn't require installation. Just download the utility from the Profisee Support Portal and unzip the file into the desired directory. The utility transfers data and model structures from MDS 2014, 2016, and 2017 to Profisee MDM. The utility then re-creates the entities, attributes, relationships, and hierarchies from the current MDS implementation directly within Profisee MDM.

Migration is a one-time process. Each model is only migrated once.

Entities, hierarchies, users and groups, and data seamlessly migrate to Profisee. For more information, see the [MMU User Guide](https://profisee.com/resources/mds-migration-utility/).

> [!NOTE]
> Data quality rules aren't automatically migrated (due to the availability of more advanced data quality structures in Profisee). But you can quickly re-create and expand most data quality rules in the Profisee no-code data quality rules UI.

### Reliability

Reliability ensures your application can meet the commitments you make to your customers. For more information, see [Overview of the reliability pillar](/azure/architecture/framework/resiliency/overview).

You're a customer of Profisee MDM SaaS, your data hosts on Azure in regional pairs. The resources used to host Profisee Cloud are deployed across region pairs. The resources apply multiple availability zones within a region for high availability, geo-replication across regions for disaster recovery, and strong backup policies. These options enable minimal downtime, fast recovery, and seamless failover if necessary.

Profisee is a cloud-native application that runs on Azure services, including Azure Kubernetes Service (AKS), Azure SQL, and Azure Storage accounts. The Profisee SaaS offering uses these underlying services to provide high availability within an Azure region and the ability to fail over to an alternative Azure region if a major outage in an Azure region occurs.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

The Profisee MDS Migration Utility (MMU) requires users to link to their Profisee instance and sign in with their verified credentials to open the utility. To migrate data models from MDS, users must enter the URL of their MDS database and enter valid credentials before choosing a data model.

For SaaS implementations (hosted by Profisee on Azure), after you import MDS models into the Profisee Platform, they're managed under the Profisee security policy. For more information, see [Profisee Security Overview](https://profisee.com/security/).

Profisee data security practices have been audited against the SOC 2 security framework by a trusted audit firm, A-LIGN. Profisee complies with laws and regulations that affect or are relevant to Profisee operations (such as GDPR or CCPA) and implements security practices that follow industry standard practices. Profisee reviews the Security Information Program annually to identify and update the changes required to maintain a modern, proactive, and effective security program.

#### Encryption of data at rest

Customer data is stored in tenant-specific repositories (such as databases, storage accounts, and so on). All data at rest is encrypted with modern encryption standards and is reevaluated as required. Repositories aren't accessible publicly. They're isolated on a private network with row-level security enabled. Row-level security helps prevent unauthorized access as controlled through Azure AD roles and groups. Profisee maintains row-level security, which helps prevent unapproved access of any customer data by Profisee employees.

#### Encryption of data in transit

All network traffic to and from Profisee Cloud over the public internet uses a minimum of TLS 1.2 to encrypt data in transit.

#### Tenant isolation

Profisee Cloud uses dedicated repositories to provide complete tenant isolation between Profisee Cloud environments. Customer data isn't shared or co-mingled between environments. Users must be authenticated and authorized for each individual Profisee Cloud environment they access. If a customer uses a common authentication provider like Azure Active Directory across environments (such as Development, Test, and Production), users gain the benefit of single sign-on but are authorized independently for each environment.

#### Access security

Profisee uses single sign-on (SSO) by way of OpenIDConnect-compliant providers, coupled with multifactor authentication. After customers deploy on the platform, they're responsible for using role-based access controls to manage their users, groups, and roles. Profisee has designed the Profisee Cloud solution with the principles of least privilege access in mind, requiring the minimum access necessary.

Along with the role-based access controls required to gain access to the platform, the Profisee solution internally supports customization and granular control. You can assign built-in roles or custom group permissions that support identity and access management controls that you can use for just-in-time access.

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

The Profisee MMU is a free download from the Profisee Support Portal to all customers and is compatible with the Profisee Platform v7.1.1 and later. The MMU can migrate models built in Master Data Services 2014, 2016, and 2017.

Profisee is a true multi-domain MDM platform with domain-agnostic, volume-based pricing. Every deployment of the Profisee Platform includes 500,000 unique records. Bulk pricing is available for large-scale implementations.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Benjamin Bourgeois](https://www.linkedin.com/in/benbourgeois1) | Content Marketing Manager
- [Martin Boyd](https://www.linkedin.com/in/martin-boyd-6714b4) | VP Product Marketing

Other contributors:

- [Brian Barnett](https://www.linkedin.com/in/brian-barnett-ga) | Software Architect

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- For more information about Profisee, see the [Profisee website](https://profisee.com/).
- For instructions on upgrading from Master Data Services to Profisee, see the [Profisee MDS Migration Utility](https://profisee.com/solutions/microsoft-enterprise/master-data-services/) web page.
- Learn more about Profisee shared history with Microsoft and SQL Server MDS in [this blog from one of the original architects of MDS](https://profisee.com/blog/4-key-takeaways-mds-migration-options-and-why-you-should-switch/).
- View a [Webinar with the original architect of MDS](https://profisee.com/resources/mdm-resource-hub/videos/master-data-services-migration-options-and-why-you-should-switch/).

## Related resources

- [Data governance with Profisee and Microsoft Purview](/azure/architecture/reference-architectures/data/profisee-master-data-management-purview)
- [Master data management with Profisee and Azure Data Factory](/azure/architecture/reference-architectures/data/profisee-master-data-management-data-factory)
- [Azure Data Architecture Guide](/azure/architecture/data-guide/)
- [Analytics end-to-end with Azure Synapse](/azure/architecture/example-scenario/dataplate2e/data-platform-end-to-end)
- [Deploy Microsoft Purview - Profisee integration for master data management (MDM) - Microsoft Purview](/azure/purview/how-to-deploy-profisee-purview-integration)
