The Internet-of-Things (IoT) *analyze and optimize loop* enables the generation and application of business optimization insights to one or more deployments of physical systems controlled by software, based on the entire enterprise business context. The analyze and optimize loop sources telemetry, typically from [monitor and manage loop](monitor-manage-loop.yml) processes, refines it, and combines it with enterprise data sources to generate insights.

This article provides an overview of analyze and optimize process loop architecture, characteristics, and components.

## Potential use cases

Some example scenarios for analyze and optimize loops include:

- Smart spaces: Compute campus safety index and take appropriate measures.
- Power transmission: Correlate power outage and wildfire event trends to produce proactive transmission repairs and replacement of monitoring devices.
- Oil and gas production: Compute a basin's oil production trends and compare it with site performance.
- Transportation and logistics: Compute carbon footprint trends, compare them with organizational goals, and take corrective measures.
- Wind farm: Compute the power factor of the entire wind farm operation, and devise means to improve efficiency of each wind turbine.
- Discrete manufacturing: Increase the widget production rate of many factories to meet market demand.

## Architecture

The following diagram shows the schematic of a typical analyze and optimize loop and its relationships with other IoT process loops.

[ ![Architecture diagram showing an analyze and optimize loop in context with measure and control and monitor and manage loops.](./media/analyze-and-optimize.svg)](./media/analyze-and-optimize.svg#lightbox)

*Download a [Visio file](https://arch-center.azureedge.net/analyze-and-optimize.vsdx) of this architecture.*

In an analyze and optimize loop, data from various IoT, enterprise, private, and public sources flows into cloud data lakes. Offline analytics consume the data lakes to discover hidden trends and business optimization insights. The optimization insights from the offline analytics processes flow back to IoT installations through [monitor and manage loops](monitor-manage-loop.yml) and [measure and control loops](measure-control-loop.yml).

## Characteristics

- The analyze and optimize loop operates asynchronously, so there are no tight timing deadlines for analyzing data or sending optimization signals to devices. These loops depend on long telemetry history and enterprise operational data history for running batch jobs.
- System dependencies include multiple systems to feed data through the data lake, which include IoT systems and feeds from enterprise systems. The optimization loop primarily uses web service protocols to integrate with supervisory systems and other enterprise systems.

## Components

The important components of business optimization control are:

- A **data lake**, large-scale storage optimized for lower usage costs over longer periods. HDFS storage in the context of map-reduce processing is an example of such a data lake. Data lake defers the structure of the data to the processing time, so is good for storing both structured and unstructured data.
- **Cold time series data**, raw or processed telemetry that is important for offline analytics and often comes from multiple IoT systems. Analytics jobs further refine and combine this data with enterprise and external data sets.
- **Enterprise data** produced by enterprise systems like product lifecycle management, supply chain, finance, sales, manufacturing and distribution, and customer relationship management. Enterprise data combined with external data sets like weather can contextualize IoT telemetry at business scope for generating compatible insights.
- **Offline analytics** to process big data in batch mode. Spark jobs and Hadoop map-reduce processing are a couple of examples. Monitor and manage loop and measure and control loop processes then apply the insights obtained from analyze and optimize loops to IoT devices.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

* [Hanukumar Pinnamraju](https://www.linkedin.com/in/hanukumar-pinnamraju-b290298) | Principal Software Engineering Manager

## Next steps

- [Monitor and manage loops](monitor-manage-loop.yml)
- [Measure and control loops](measure-control-loop.yml)

## Related Resources

- [Environment monitoring and supply chain optimization with IoT - Azure Solution Ideas](/azure/architecture/solution-ideas/articles/environment-monitoring-and-supply-chain-optimization)
