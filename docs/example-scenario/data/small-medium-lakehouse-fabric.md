This example workload illustrates a greenfield solution to build a robust, scalable data platform using the lakehouse design paradigm on Microsoft Fabric. Microsoft Fabric is a cutting-edge platform that seamlessly integrates data storage, processing, and analytics. Unlike traditional data warehouses, which often involve complex migrations and costly transformations, a greenfield lakehouse provides a clean slate for designing an efficient, future-proof data ecosystem.

## Who may benefit from this architecure

The greenfield data lakehouse architecture with Microsoft Fabric is beneficial for a wide range of scenarios including:

- Organisations looking to start fresh, unencumbered by legacy systems, when developing a data platfrom.
- Organisations that anticipate data volumes between 0.5 to 1.5 TB.
- Organisations with a preference for a simple and streamlined pattern that balances cost, complexity, and performance considerations.

## Architecture

:::image type="content" border="false" source="media/small-medium-lakehouse-fabric/small-medium-lakehouse-fabric.svg" alt-text="Diagram illustrates a greenfield solution to build a robust, scalable data platform using the lakehouse design paradigm on Microsoft Fabric for SMBs." lightbox="media/small-medium-lakehouse-fabric/small-medium-lakehouse-fabric.svg":::

*Download a [Visio file](https://arch-center.azureedge.net/small-medium-lakehouse-fabric.vsdx) of this architecture.*

### Workflow

The following demonstrates a standard end-to-end workflow using this design pattern:

1. TODO
2. TODO

### Components

The following components are used to enable this solution:

- [Microsoft Fabric](): An end-to-end cloud-based data analytics platform designed for enterprises that offers a unified environment for various data tasks like data ingestion, transformation, analysis, and visualization.

  - [OneLake](https://learn.microsoft.com/fabric/onelake/onelake-overview): The central hub for all your data within Microsoft Fabric. It's designed as an open data lake, meaning it can store data in its native format regardless of structure.

  - [Data Factory](https://learn.microsoft.com/fabric/data-factory/data-factory-overview): A cloud-based ETL and orchestration service for automated data movement and transformation. It allows you to automate data movement and transformation at scale across various data sources.

  - [Data Engineering](https://learn.microsoft.com/fabric/data-engineering/data-engineering-overview): Tools that enable the collection, storage, processing, and analysis of large volumes of data.

  - [Data Science](https://learn.microsoft.com/fabric/data-science/data-science-overview): Tools that empower you to complete end-to-end data science workflows for the purpose of data enrichment and business insights.

  - [Real-Time Intelligence](https://learn.microsoft.com/fabric/real-time-intelligence/overview): Provides stream ingestion and processing capabilities. This allows you to gain insights from constantly flowing data, enabling quicker decision-making based on real-time trends and anomalies.

  - [Power BI](https://learn.microsoft.com/power-bi/fundamentals/power-bi-overview): Business intelligence tool for creating interactive dashboards and reports to visualize data and gain insights.

  - [Copilot](https://learn.microsoft.com/fabric/get-started/copilot-fabric-overview): Allows you to analyze data, generate insights, and create visualizations and reports in Microsoft Fabric and Power BI using natural language.

### Alternatives

## Scenario details

### Potential use cases

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](https://learn.microsoft.com/azure/well-architected/).

The following considerations apply to this scenario.

### Availability

### Operations

### Cost optimization

## Contributors

*This article is being updated and maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

- Amit Chandra | Cloud Solution Architect
- Nicholas Moore | Cloud Solution Architect

## Next steps

## Related resources
