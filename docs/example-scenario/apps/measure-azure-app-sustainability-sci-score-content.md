The solution described in this article can help you measure sustainability metrics for a workload hosted on Azure. The model uses application data and proxies to score and track an application's carbon impact and efficiency over time. We recommend that you align your measurements to the Software Carbon Intensity (SCI) score, which is formalized in ISO/IEC 21031:2024. It provides a baseline for measuring changes in an application's carbon output.

> [!IMPORTANT]
> This article focuses on **measuring** the carbon impact of an existing application by using the SCI score. For more information about **designing** sustainable applications from scratch, see [Sustainable workloads](/azure/well-architected/sustainability/sustainability-get-started).

## Architecture

:::image type="complex" border="false" source="media/measure-app-sci-score.png" alt-text="Diagram of a sustainability model that scores the carbon impact of an application." lightbox="media/measure-app-sci-score.png":::
   <Long description that ends with a period.>
:::image-end:::

*Download a [Visio file](https://arch-center.azureedge.net/measure-app-sci-score.vsdx) of this architecture.*

### Data flow

1. Configure the application data sources that you use to calculate your SCI score, along with operational data like cost and performance. The data can be the emissions measurements from the [Azure carbon optimization service APIs](/rest/api/carbon/carbon-service), proxy measurements from non-Microsoft sources, or a combination of them both.

1. All data points, like [exported emissions data](/azure/carbon-optimization/export-data), get collected and stored in your data lake.

1. Use event handlers like Azure Functions or Azure Logic Apps to calculate the SCI score and related workload utilization metrics. For example, an output might be the amount of carbon emitted in grams per unit, where *unit* refers to the application scaling factor, or an approximation of it that's based on proxies.

1. If your workload is carbon-aware, it can use this data to trigger demand shaping or initiate a predefined eco mode. Carbon-aware applications often use real-time data signals, like forecasts from [WattTime](https://docs.watttime.org).

1. Use Power BI to report and visualize the score and its variation over time and utilization. You can track the SCI score and compare performance and cost relative to the SCI score.

   Dashboards show how performance and utilization relate to the score. For example, reduced performance with a stable SCI score indicates a higher carbon cost for less work accomplished. This insight should drive remediation to restore the system to an optimized state.

### Components

- [Carbon optimization in Azure](/azure/carbon-optimization/overview) is a service for measuring and visualizing Azure workload emissions. It provides APIs and visualizations of carbon emission measurements of Azure workloads at the resource-group or resource level. In this architecture, it's the primary source of emissions data for the Azure hardware that the workload consumes.

- The [Microsoft Cloud for Sustainability API](/industry/sustainability/overview) is a sustainability and emissions data service. It provides the underlying data for carbon optimization and retrieves information about subscription emissions. In this architecture, the API supplies foundational emissions data that complements Azure carbon optimization.

- [Application Insights](/azure/well-architected/service-guides/application-insights) is a feature of Azure Monitor that provides application performance management (APM). It helps you understand app usage to make data-driven decisions for improving efficiency. In this architecture, it's a key data source for workload utilization and performance. This data helps measure efficiency as a function of work accomplished relative to the carbon cost.

- [Azure Data Lake](/azure/storage/blobs/data-lake-storage-introduction) is a centralized repository that ingests and stores large volumes of data in its original form for processing and analytics. In this architecture, it stores raw snapshot data for calculating and reporting workload efficiency.

- [Logic Apps](/azure/logic-apps/logic-apps-overview) is a workflow automation and integration service that you can use to create and run automated workflows with minimal code. In this architecture, the visual designer and prebuilt operations create workflows that integrate and manage proxy sources, data storage, and efficiency calculation systems.

- [Functions](/azure/well-architected/service-guides/azure-functions) is a serverless compute service for running event-driven code. It lets you run small units of code. It automatically scales resources based on demand, and you pay only for the time that your code runs. In this architecture, it does sustainability calculations and stores them in the data lake.

- [Azure Automation](/azure/automation/overview) is a process automation and configuration management service that provides process automation via runbooks. In this architecture, runbooks implement complex logic with PowerShell code to improve application efficiency.

- [Power BI](/power-bi/fundamentals/power-bi-overview) is a business analytics and visualization platform. It turns data into analytics and reports for real-time insights. In this architecture, it provides dashboards for stakeholders to evaluate sustainability goals.

### Alternatives

You can replace the Azure services in this architecture with similar services. To increase density and utilization of existing resources, run calculations with minimal infrastructure impact by using services or tools already deployed in your environment:

- Substitute Power BI dashboards with [Azure Monitor workbooks](/azure/azure-monitor/visualize/workbooks-overview) or [Azure Managed Grafana](https://azure.microsoft.com/services/managed-grafana/).

- Substitute Application Insights with another APM tool, like Elasticsearch APM or OpenAPM.

- Retain tabular or unstructured proxy data in any system of record, like [Azure Database for MySQL](/azure/mysql/flexible-server/overview) or [Azure Cosmos DB for NoSQL](/azure/cosmos-db/nosql/overview).

- If you have existing [Functions](/azure/azure-functions/functions-overview) or Logic Apps deployments, run the calculations from there.

- If you distribute application resources across multiple resource groups, use tags to correlate cost data and calculate carbon emissions.

## Scenario details

This architecture gathers carbon optimization data from Azure and other sources to provide a comprehensive view of an application's environmental impact. Data comes from Azure carbon optimization. Where data isn't available, use a proxy for the carbon metrics. After data consolidation, SCI calculations assess carbon footprint. Results are stored in a data lake for long-term retention, which enables BI analysis, historical reporting, and comparison to baselines. This approach ensures centralized tracking of carbon impact across diverse infrastructure and supports strategic sustainability efforts.

The system gathers carbon emissions information from available APIs and calculates it, when possible, by using a proxy.

:::image type="content" source="media/carbon-optimization-blade.png" alt-text="Screenshot of the Carbon optimization blade in the Azure portal that shows emission details, trends, and resource group emissions data." lightbox="media/carbon-optimization-blade.png" border="false":::

A dedicated architecture for gathering Azure carbon optimization data is beneficial for two reasons:

- Azure carbon optimization data is stored for 12 months. A dedicated system ensures retention of historical information for long-term tracking.

- An application can span multiple infrastructure boundaries. A separate architecture provides centralized monitoring of carbon impact across all environments to ensure comprehensive sustainability insights.

> [!NOTE]
> Greenhouse gases aren't made up of only carbon dioxide, and they don't all have the same impact on the environment. For example, one ton of methane has the [same heating effect](https://wikipedia.org/wiki/Global_warming_potential) as 80 tons of carbon dioxide. In this article, everything is normalized to the CO2-equivalent measure. All references to carbon refer to the CO2-equivalent.

### Data sources

Calculating a comprehensive SCI score requires data from multiple sources. Distinguish between data that you use for *reporting* (retrospective) and for *runtime* decisions (real-time).

#### Reporting and trend analysis

Azure carbon optimization provides monthly carbon-emission data for Azure resources. This data includes the energy (`E`) and carbon intensity (`I`) components of the [SCI formula](#calculations) in aggregated form. If you can't find the embodied carbon (`M`) value, you can omit it. It's not ideal, but if you keep the calculation consistent, you can track the trend over time.

Aggregate data from Microsoft Cost Management and Azure Monitor lets you compare your SCI score to the work accomplished and the monetary cost.

#### Runtime carbon awareness

These sources provide real-time data needed for *carbon-aware* applications that react to changing grid conditions:

- [WattTime](https://docs.watttime.org/) and [Electricity Maps](https://app.electricitymaps.com/) are non-Microsoft APIs that provide real-time carbon intensity (`I`) data for the local power grid. Because Azure doesn't publish real-time datacenter carbon intensity, the local grid intensity serves as the standard proxy.

- Application Insights collects real-time performance and scale metrics to calculate the functional unit (`R`) and estimate energy consumption (`E`):

  - Scaling factor (like API calls or active users)
  - CPU and memory usage
  - Response time

For a tutorial about how to set up Application Insights to get the required metrics, see [Application Insights for ASP.NET Core applications](/azure/azure-monitor/app/tutorial-asp-net-core).

Consider adding other variables to the equation, like the following examples:

- Edge services and infrastructure carbon emissions
- Proxies based on end-user device profiles
- Connection times, as electricity production and demand vary over time.
- Other application metrics that indicate performance changes.

By incorporating these variables into a score that reflects the number of users, you create an approximate carbon score. This score serves as your benchmark for sustainability improvements.

Cost is another consideration associated with application performance. A direct correlation often exists between performance efficiency, cost, and carbon savings. This correlation suggests the following outcomes:

- Higher performance at the same cost indicates that the app is optimized and carbon emissions are reduced.

- Lower cost at the same performance indicates that the app is optimized and carbon emissions are reduced.

- Higher performance combined with higher cost indicates that the app isn't optimized and carbon emissions have increased.

- Higher cost with reduced or unchanged performance indicates that the app isn't optimized and carbon emissions have increased (or that energy costs are higher, which also contributes to increased emissions).

The correlation between SCI score, cost, and performance is unique to each application. Gathering data for these variables let you create a correlation algorithm to forecast variations and make informed architectural decisions and drive desirable usage patterns.

### Calculations

The [SCI score](https://grnsft.org/sci) is calculated by using the following formula, which represents the rate of carbon emissions per one unit:

```text
SCI = ((E * I) + M) per R
```

This equation uses the following variables:

- `E` is the **energy** that a software system consumes. It's measured in kilowatt-hours (kWh).

- `I` is the **carbon intensity** of the energy source. It's measured in grams of carbon dioxide equivalent per kilowatt-hour (gCO2e/kWh). This value varies by location and time of day.

- `M` is the **embodied carbon** of the hardware. It represents the carbon that manufacturers, transporters, and disposers emit during the manufacturing, transportation, and disposal of the hardware. The software allocates this static value based on its usage share and lifespan.

- `R` is the **functional unit** (or scaling factor) for the application. This value normalizes the score to a unit of work, like per user, per API call, or per job.

> [!NOTE]
> This score is sometimes simplified to `SCI = C per R`, where `C` represents total carbon emissions measured through proxies. The expanded formula provides greater granularity and lets you target specific variables for optimization. This granularity reduces energy consumption (`E`), shifts workloads to cleaner times or locations (`I`), or extends hardware lifespan (`M`).

The time window is a critical part of this calculation. Carbon intensity (`I`) varies based on several factors. These factors include energy mix, weather changes, demand, and grid-operations constraints (dispatchability and curtailment). Effective runtime carbon-aware decisions require real‑time or near-real-time data (hourly or less) from [non-Microsoft APIs](#data-sources).

Azure carbon optimization provides monthly aggregated carbon data for resources. This data is useful for the following use cases:

- Tracking long-term trends and validating the impact of design changes.
- Establishing a starting baseline for your sustainability journey.

### Data storage

Store gathered carbon and proxy information in a solution that connects to dashboards or reports. This setup lets you visualize the carbon score over time for informed decision-making. To improve sustainability and align with Azure Well-Architected Framework best practices, use a minimum viable system. For more information, see [Data and storage design considerations for sustainable workloads on Azure](/azure/architecture/framework/sustainability/sustainability-storage) and [Application platform considerations for sustainable workloads on Azure](/azure/well-architected/sustainability/sustainability-application-platform#evaluate-moving-to-paas-and-serverless-workloads). This architecture uses Azure Data Lake Storage.

### Data correlations

Gather data on carbon, performance, and cost of your application to get valuable information. Use this data to create a correlation algorithm specific to your application for cost, performance, and carbon optimization planning.

For more information, see [Select algorithms for Azure Machine Learning](/azure/machine-learning/how-to-select-algorithms).

### Data display

You can display data and calculations in various ways, which include customized [Azure Monitor dashboards](/azure/azure-monitor/app/tutorial-app-dashboards) and [Power BI dashboards](/power-bi/create-reports/service-dashboard-create).

### SCI score and real‑time measurement triggers

Ideally, you should design your workload to be sustainable by following the [Design principles of a sustainable workload](/azure/well-architected/sustainability/sustainability-design-principles). Upfront workload design focuses on ways to minimize **energy (`E`)** and **embodied carbon (`M`)**. Strategies include ways to write efficient code, choose the right architecture, and maximize hardware density. Make these decisions before the workload runs or add them as backlog items to improve an existing workload.

A carbon-aware workload reacts to unfavorable real-time conditions. You typically base runtime triggers on attempts to optimize the **carbon intensity (`I`)** component. Examples include the following scenarios:

- High energy production and demand, which makes energy expensive

- Unavailable electricity because of natural disasters or geopolitical conflicts

- Sudden unavailability of edge infrastructure because of resource overconsumption or supply chain problems

Based on these triggers, you can take actions like shifting job processing times or moving workloads to cleaner energy grids. Consider the following actions:

- Apply [graceful degradation](/azure/well-architected/reliability/self-preservation#implement-a-graceful-degradation-mode) of application services and features.

  For example, enable an eco mode version of your application. Eco mode is a simpler, smaller, more sustainable version that has minimal features. Revert to this version during carbon emission spikes, or incentivize users to choose it.

- Provide a *go green* button that switches to a low‑impact interface that uses fewer graphics and provides limited features in exchange for a commitment to reduced carbon emissions.

  Involving users creates an opportunity to drive cultural change:

  - Specify the impact of the choice by stating how it affects carbon savings or your carbon score. For example, the eco version might save *x amount* of carbon or bring your carbon score to *y amount*.

  - Understand user behavior and modify the eco version to reflect their choices.

  As you optimize the full version for emissions, you can eventually merge the two versions.

> [!NOTE]
> **Windows Update** is an example of runtime optimization. It uses a carbon-aware API to schedule updates. Instead of immediately downloading updates, it waits for a window when the local grid's carbon intensity (`I`) is low. This approach effectively reduces the carbon footprint of the update process without changing the total energy consumed.

## Considerations

These considerations implement the pillars of the Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

Use Azure Virtual Network private endpoints to restrict access to Azure service resources to your virtual network.

For general guidance about how to design secure solutions, see [Azure security documentation](/azure/security).

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

You can deploy this architecture by using alternative Azure services. The architecture keeps components to a minimum to save on cost and carbon emissions. The [Emissions Impact Dashboard](https://appsource.microsoft.com/product/power-bi/coi-sustainability.emissions_impact_dashboard), Azure carbon optimization, and Cost Management reports are free. We recommend that you use equivalent services already in your deployment. For pricing information, see the following articles:

- [Application Insights pricing](https://azure.microsoft.com/pricing/details/monitor/)
- [Logic Apps pricing](https://azure.microsoft.com/pricing/details/logic-apps/)
- [Functions pricing](https://azure.microsoft.com/pricing/details/functions/)
- [Automation pricing](https://azure.microsoft.com/pricing/details/automation/)

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

The primary purpose of this architecture is to provide a sustainability score via a process that has a minimal impact on cost and carbon. Most components are platform as a service (PaaS) and serverless Azure services that scale independently based on use and traffic.

In this scenario, the dashboard and storage interface aren't intended for high-volume usage and consultation. If you plan to provide it to a large number of users, you might consider one of the following options:

- Decouple the extracted data by transforming and storing it in a different system.

- Replace Data Lake Storage with a scalable alternative like Azure Cosmos DB for NoSQL.

## Contributors

*Microsoft maintains this article. The following contributors wrote this article.*

Principal authors:

- [Paola Annis](https://www.linkedin.com/in/paolaeva) | Principal Customer Experience Engineering Manager
- [Davide Bedin](https://www.linkedin.com/in/davidebedin/) | Senior Cloud Solution Architect, Application Innovation
- [Simon Thurman](https://www.linkedin.com/in/simonthurman/) | Senior Solution Engineer, Apps & AI

Other contributor:

- [Chad Kittel](https://www.linkedin.com/in/chadkittel/) | Principal Software Engineer, Azure Patterns & Practices

*To see nonpublic LinkedIn profiles, sign in to LinkedIn.*

## Next steps

This article aligns with the principles and methodology of the [Green Software Foundation](https://greensoftware.foundation), where Microsoft serves as a steering member. To continue building greener applications, embed the [Carbon Aware SDK](https://carbon-aware-sdk.greensoftware.foundation) into your application to automate real-time triggers when you meet specific carbon conditions.

## Related resources

- [Choose a data analytics and reporting technology in Azure](../../data-guide/technology-choices/analysis-visualizations-reporting.md)
- [Data warehousing and analytics](../data/data-warehouse.yml)
