The solution described in this article can help you measure sustainability metrics for a workload that is hosted on Azure. The model uses application data and proxies to score and track an application's carbon impact and efficiency over time. We recommend that you align your measurements to the Software Carbon Intensity (SCI) score, which is formalized in ISO 21031:2024. It provides a baseline for measuring changes in an application's carbon output.

> [!IMPORTANT]
> This article focuses on **measuring** the carbon impact of an existing application using the SCI score. For guidance on **designing** sustainable applications from the ground up, see the [Azure Well-Architected Framework Sustainability workload documentation](/azure/well-architected/sustainability/sustainability-get-started).

## Architecture

:::image type="content" source="media/measure-app-sci-score.png" alt-text="Diagram of a sustainability model that scores the carbon impact of an application." lightbox="media/measure-app-sci-score.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/measure-app-sci-score.vsdx) of this architecture.*

### Data flow

1. Configure the application data sources you'll use to calculate your SCI score, along with operational data like cost and performance. The data can be the emissions measurements from the [Azure Carbon Optimization service APIs](/rest/api/carbon/carbon-service), proxy measurements from non-Microsoft sources, or a combination.
1. All data points, such as [exported emissions data](/azure/carbon-optimization/export-data), get collected and stored in your data lake.
1. Use event handlers like Azure Functions or Azure Logic Apps to calculate the SCI score and related workload utilization metrics. For example, an output could be the amount of carbon emitted in grams per unit, where *unit* refers to the application scaling factor, or an approximation of it that's based on proxies.
1. If your workload is carbon-aware, it can use this data to trigger demand shaping or initiate a predefined eco mode. Carbon-aware applications often use real-time data signals, such as forecasts from [WattTime](https://docs.watttime.org/).
1. Use Power BI to report and visualize the score and its variation over time and utilization. You can track the SCI score and compare performance and cost relative to the SCI score.

   Dashboards show the relationship between performance/utilization and the score. For example, reduced performance with a stable SCI score indicates higher carbon cost for less work accomplished. This insight should drive remediation to return to an optimized state.

### Components

- [Azure Carbon Optimization](/azure/carbon-optimization/overview) provides APIs and visualizations of carbon emission measurements of Azure workloads at resource-group or resource level. In this architecture, it's the primary source of emissions data for the Azure hardware consumed by the workload.
- The Cloud for Sustainability API provides the underlying data for carbon optimization and retrieves information on subscription emissions.
- [Application Insights](/azure/well-architected/service-guides/application-insights), a feature of Azure Monitor, provides application performance management (APM). It helps you understand app usage to make data-driven decisions for improving efficiency. In this architecture, it's a key data source for workload utilization and performance. This data helps measure efficiency as a function of work accomplished relative to the carbon cost.
- [Azure Data Lake](/azure/storage/blobs/data-lake-storage-introduction) is a centralized repository that ingests and stores large volumes of data in its original form for processing and analytics. In this architecture, it stores raw snapshot data for calculating and reporting workload efficiency.
- [Azure Logic Apps](/azure/logic-apps/logic-apps-overview) enables you to create and run automated workflows with minimal code. Use the visual designer and prebuilt operations to create a workflow that integrates and manages proxy sources, data storage, and efficiency calculation systems.
- [Azure Functions](/azure/well-architected/service-guides/azure-functions-security) enables you to run small units of code. It automatically scales resources based on demand, and you pay only for execution time. Use it to perform sustainability calculations and store them in the data lake.
- [Azure Automation](/azure/automation/overview) provides process automation via runbooks. Use runbooks to implement complex logic with PowerShell code to improve application efficiency.
- [Power BI](/power-bi/fundamentals/power-bi-overview) turns data into analytics and reports for real-time insights. In this architecture, it provides dashboards for stakeholders to evaluate sustainability goals.

### Alternatives

You can replace the Azure services in this architecture with similar services. To increase density and utilization of existing resources, perform calculations with minimal infrastructure impact by using services or tools already deployed in your environment:

- Substitute Power BI dashboards with [Azure Monitor workbooks](/azure/azure-monitor/visualize/workbooks-overview) or [Azure Managed Grafana](https://azure.microsoft.com/services/managed-grafana/).
- Substitute Application Insights with another application performance management (APM) tool, like Elasticsearch APM or OpenAPM.
- Retain tabular or unstructured proxy data in any system of record, like [Azure Database for MySQL](/azure/mysql/flexible-server/overview) or [Azure Cosmos DB for NoSQL](/azure/cosmos-db/nosql/overview).
- If you have existing [Azure Functions](/azure/azure-functions/functions-overview) or Logic Apps deployments, run the calculations from there.
- If application resources are distributed across multiple resource groups, use tags to correlate cost data and calculate carbon emissions.

## Scenario details

This architecture gathers carbon optimization data from Azure and other sources to provide a comprehensive view of an application's environmental impact. Data comes from the Azure Carbon Optimization service. Where data is not available, a proxy is used for the carbon metrics. After data consolidation, SCI calculations assess carbon footprint. Results are stored in a data lake for long-term retention, enabling BI analysis, historical reporting, and comparison to baselines. This approach ensures centralized tracking of carbon impact across diverse infrastructure and supports strategic sustainability efforts.

The carbon emissions information is partially gathered from available APIs and partially calculated, when possible, via proxy.

:::image type="content" source="media/carbon-optimization-blade.png" alt-text="Screenshot of the Carbon optimization blade." lightbox="media/carbon-optimization-blade.png" border="false":::

A dedicated architecture for gathering Azure carbon optimization data is beneficial for two reasons:

- Azure carbon optimization data is stored for 12 months. A dedicated system ensures retention of historical information for long-term tracking.
- An application might span multiple infrastructure boundaries. A separate architecture enables centralized monitoring of carbon impact across all environments to ensure comprehensive sustainability insights.

> [!NOTE]
> Greenhouse gases aren't made up of only carbon dioxide, and they don't all have the same impact on the environment. For example, one ton of methane has the [same heating effect](https://wikipedia.org/wiki/Global_warming_potential) as 80 tons of carbon dioxide. In this article, everything is normalized to the CO2-equivalent measure. All references to carbon refer to the CO2-equivalent.

### Data sources

Calculating a comprehensive SCI score requires data from multiple sources. Distinguish between data used for *reporting* (retrospective) and data used for *runtime* decisions (real-time).

#### Reporting and trend analysis

Azure Carbon Optimization provides monthly carbon emission data for Azure resources. This covers the `E` (Energy) and `I` (Carbon Intensity) components of the [SCI formula](#calculations) in an aggregated form. If you are unable to find 'M' (Embodied Carbon), whilst not ideal it can be omitted. As long as the calculation is consistent you will still see the trend over time.

Aggregate data from Microsoft Cost Management and Azure Monitor lets you compare your SCI score to the work accomplished and the monetary cost.

#### Runtime carbon awareness

These sources provide real-time data needed for *carbon-aware* applications that react to changing grid conditions:

- [WattTime](https://docs.watttime.org/) and [Electricity Maps](https://app.electricitymaps.com/): Non-Microsoft APIs that provide real-time carbon intensity (`I`) data for the local power grid. Because Azure doesn't publish real-time datacenter carbon intensity, the local grid intensity serves as the standard proxy.
- Application Insights collects real-time performance and scale metrics to calculate the functional unit (`R`) and estimate energy consumption (`E`):
  - Scaling factor (e.g., API calls, active users)
  - CPU and Memory usage
  - Response time

For a tutorial on how to set up Application Insights to get the required metrics, see [Application Insights for ASP.NET Core applications](/azure/azure-monitor/app/tutorial-asp-net-core).

Consider adding other variables to the equation, such as:

- Edge services and infrastructure carbon emissions
- Proxies based on end-user device profiles
- Connection times, as electricity production and demand vary over time.
- Other application metrics that indicate performance changes.

By incorporating these variables into a score that reflects the number of users, you create an approximate carbon score. This score serves as your benchmark for sustainability improvements.

Cost is another consideration associated with application performance. A direct correlation often exists between performance efficiency, cost, and carbon savings. This correlation suggests:

- When performance is higher but costs are the same, you have optimized the app and reduced carbon emissions.
- When costs are reduced but performance is the same, you have optimized the app and reduced carbon emissions.
- When both performance and costs increase, you haven't optimized the app, and you have increased carbon emissions.
- When costs increase but performance is reduced or the same, you haven't optimized the app and have increased carbon emissions (or the energy cost is higher, which is also a cause for higher carbon emissions).

The correlation between SCI score, cost, and performance is unique to each application. Gathering data for these variables allows you to create a correlation algorithm to forecast variations and make informed architectural decisions and drive desirable usage patterns.

### Calculations

The [Software Carbon Intensity (SCI)](https://grnsft.org/sci) score is formally calculated using the following formula, representing the rate of carbon emissions per one unit:

```text
SCI = ((E * I) + M) per R
```

In this equation:

- `E` is the **Energy** consumed by a software system. It's measured in kilowatt-hours (kWh).
- `I` is the **Carbon Intensity** of the energy source. It's measured in grams of carbon dioxide equivalent per kilowatt-hour (gCO2e/kWh). This value varies by location and time of day.
- `M` is the **Embodied Carbon** of the hardware. It represents the carbon emitted during the manufacturing, transportation, and disposal of the hardware. It's a static value allocated to the software based on its usage share and lifespan.
- `R` is the **Functional Unit** (or scaling factor) for the application. This normalizes the score to a unit of work, such as per user, per API call, or per job.

> [!NOTE]
> This score is sometimes reduced to `SCI = C per R`, where `C` represents total carbon emissions measured through proxies. The expanded formula above provides greater granularity, allowing you to target specific variables for optimization: reducing energy consumption (`E`), shifting workloads to cleaner times/locations (`I`), or extending hardware lifespan (`M`).

The time window is a critical aspect of this calculation. Carbon intensity (`I`) varies depending upon a number of factors. These include energy mix, weather changes, demand, and grid operations constraints (dispatchability and curtailment). Effective runtime carbon-aware decisions require real-time or near-real-time data (hourly or less) from [third-party APIs](#data-sources).

Azure Carbon Optimization provides monthly aggregated carbon data for resources. This data is useful for:

- Tracking long-term trends and validating the impact of design changes.
- Establishing a starting baseline for your sustainability journey.

### Data storage

Store gathered carbon and proxy information in a solution that connects to dashboards or reports. This setup enables visualization of the carbon score over time for informed decision-making. To improve sustainability and align with Azure Well-Architected Framework best practices, use a minimum viable system. For more information, see [Data and storage design considerations for sustainable workloads on Azure](/azure/architecture/framework/sustainability/sustainability-storage) and [Application platform considerations for sustainable workloads on Azure](/azure/well-architected/sustainability/sustainability-application-platform#evaluate-moving-to-paas-and-serverless-workloads). This architecture uses Azure Data Lake Storage.

### Data correlations

Gathering data on carbon, performance, and cost of your application provides valuable information. Use this data to create a correlation algorithm specific to your application for planning cost, performance, and carbon optimization.

For more information, see [How to select algorithms for Azure Machine Learning](/azure/machine-learning/how-to-select-algorithms).

### Data display

Display data and calculations in various ways, including customized [Azure Monitor dashboards](/azure/azure-monitor/app/tutorial-app-dashboards) and [Power BI dashboards](/power-bi/create-reports/service-dashboard-create).

### What can your SCI score and real-time measurements trigger?

Ideally, you've designed your workload to be sustainable by following the [Design principles of a sustainable workload](/azure/well-architected/sustainability/sustainability-design-principles). Upfront workload design focuses on minimizing **Energy (`E`)** and **Embodied Carbon (`M`)**. Strategies include writing efficient code, choosing the right architecture, and maximizing hardware density. These decisions are made before the workload runs or are backlog items to improve an existing workload.

A carbon-aware workload reacts to unfavorable real-time conditions. Runtime triggers are usually based on trying to optimize the **Carbon Intensity (`I`)** component. Examples include:

- High energy production and demand, making energy expensive.
- Unavailable electricity due to natural disasters or geopolitical conflicts.
- Sudden unavailability of edge infrastructure due to resource overconsumption or supply chain issues.

Based on these triggers, decide on actions like shifting job processing times or locations to cleaner energy grids. Other examples include:

- Apply [graceful degradation](/azure/well-architected/reliability/self-preservation#implement-a-graceful-degradation-mode) of application services and features.

  For example, enable an eco mode version of your application. Eco mode is a simpler, small, more sustainable version with minimal features. Revert to this version during carbon emission spikes, or incentivize users to choose it.

- Provide a "go green button" for a leaner interface with fewer graphics and limited features in exchange for a commitment to reduced carbon emissions.

  Involving users creates an opportunity to drive cultural change:

  - Specify the impact of the choice: "Using the eco version saves *x amount* of carbon" or "brings our carbon score to *y amount*."
  - Understand user behavior and modify the eco version to reflect their choices.

  As the full version is optimized for emissions, you can eventually merge the two versions.

> [!EXAMPLE]
> **Windows Update** is an example of runtime optimization. It uses a carbon-aware API to schedule updates. Instead of downloading updates immediately, it waits for a window when the local grid's carbon intensity (`I`) is low, effectively reducing the carbon footprint of the update process without changing the total energy consumed.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

Use Azure Virtual Network private endpoints to restrict access to Azure service resources to your virtual network.

For general guidance on designing secure solutions, see [Azure security documentation](/azure/security).

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

You can deploy this architecture using alternative Azure services. The architecture keeps components to a minimum to save on cost and carbon emissions. We encourage using equivalent services already in your deployment. Pricing information is available for each component:

- The [Emissions Impact Dashboard](https://appsource.microsoft.com/product/power-bi/coi-sustainability.emissions_impact_dashboard), Azure carbon optimization, and Microsoft Cost Management reports are free.
- [Application Insights pricing](https://azure.microsoft.com/pricing/details/monitor/).
- [Azure Logic Apps pricing](https://azure.microsoft.com/pricing/details/logic-apps/).
- [Azure Functions pricing](https://azure.microsoft.com/pricing/details/functions/).
- [Azure Automation pricing](https://azure.microsoft.com/pricing/details/automation/).

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

The primary purpose of this architecture is to provide a sustainability score via a process that has a minimal impact on cost and carbon. Most components are platform as a service (PaaS) and serverless Azure services that scale independently based on use and traffic.

In this scenario, the dashboard and storage interface aren't intended for massive usage and consultation. If you plan to provide it to a large number of users, you might want to consider one of these options:

- Decouple the extracted data by transforming and storing it in a different system.
- Replace Data Lake Storage with a scalable alternative, like Azure Cosmos DB for NoSQL.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Paola Annis](https://www.linkedin.com/in/paolaeva) | Principal Customer Experience Engineering Manager
- [Davide Bedin](https://www.linkedin.com/in/davidebedin/) | Senior Cloud Solution Architect, Application Innovation
- [Simon Thurman](https://www.linkedin.com/in/simonthurman/) | Senior Solution Engineer, Apps & AI

Other contributor:

- [Chad Kittel](https://www.linkedin.com/in/chadkittel/) | Principal Software Engineer, Azure Patterns & Practices

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

This article is aligned with the principles and methodology of the [Green Software Foundation](https://greensoftware.foundation), of which Microsoft is a steering member. The next step in creating a greener application is to embed the [Carbon Aware SDK](https://carbon-aware-sdk.greensoftware.foundation) into your application so that triggers can be automated in real time when specific carbon conditions are met.

For recommendations to optimize Azure workloads, see [Sustainability cloud workload guidance](/azure/architecture/framework/sustainability).

## Related resources

- [Choose a data analytics and reporting technology in Azure](../../data-guide/technology-choices/analysis-visualizations-reporting.md)
- [Data analysis workloads for regulated industries](../data/data-warehouse.yml)
