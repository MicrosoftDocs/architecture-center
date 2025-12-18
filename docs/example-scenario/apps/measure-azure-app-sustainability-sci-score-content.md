The solution described in this article can help you measure your sustainability metrics for a workload that is hosted on Azure. The model uses application data and proxies that, over time, allow you to score an application's carbon impact and efficiency. We recommend aligning your measurements to the Software Carbon Intensity (SCI) score. It provides a baseline for measuring changes in an application's carbon output.

> [!IMPORTANT]
> This article focuses on **measuring** the carbon impact of an existing application using the SCI score. For guidance on **designing** sustainable applications from the ground up, see the [Azure Well-Architected Framework Sustainability workload documentation](/azure/well-architected/sustainability/sustainability-get-started).

## Architecture

:::image type="content" source="media/measure-app-sci-score.png" alt-text="Diagram of a sustainability model that scores the carbon impact of an application." lightbox="media/measure-app-sci-score.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/measure-app-sci-score.vsdx) of this architecture.*

### Dataflow

1. Configure application data sources that you'll use to calculate your SCI score along with operational data such as cost and performance. The data can be the emissions measurements provided by the [Azure Carbon Optimization service APIs](/rest/api/carbon/carbon-service), they can be proxy measurements from non-Microsoft sources or systems, or a combination.
1. All data points, such as [exported emissions data](/azure/carbon-optimization/export-data), get collected and stored in your data lake.
1. Use event handlers like Azure Functions or Azure Logic Apps to calculate the SCI score and any calculatations related to the score in comparison to performance or cost. For example, an output could be the amount of carbon emitted in grams per unit, where *unit* refers to the application scaling factor, or an approximation of it that's based on proxies.
1. If your workload was designed to be carbon-aware, it might use this data to trigger demand shaping on the application or to initiate the application's predefined eco mode. Many carbon-aware applications tend to use real-time data signals, such as forecasts from [WattTime](https://docs.watttime.org/).
1. Use Power BI to report and visualize the score and its variation over time. This is used to both track SCI score over time, but also to compare performance and cost relative to your CSI score.

   Dashboards show the relationship between performance/utilization and your score. For example, a reduction of performance for an otherwise stable CSI score means that you're spending more carbon on less work and that might drive a remediation task to return to an optimized state.

### Components

- [Azure Carbon Optimization](/azure/carbon-optimization/overview) service provides APIs and visualizations of carbon emission measurements of Azure workloads at resource-group or resource level. In this architecture, it's the primary source of data specifically related to the emissions from the Azure hardware you consumed in your workload.
- The Cloud for Sustainability API provides the underlying data for carbon optimization. You can use it to retrieve information on your subscription's emissions.
- [Application Insights](/azure/well-architected/service-guides/application-insights) is a feature of Azure Monitor that provides application performance management (APM). It helps you understand how people use your app so you can make data-driven decisions about improving your application's efficiency. In this architecture, it's an important data source for utilization and performance of your workload. This data helps you measure your effeciency as a function of work accomplished to the carbon cost of doing that work.
- [Azure Data Lake](/azure/storage/blobs/data-lake-storage-introduction) is a centralized repository that ingests and stores large volumes of data in its original form. The data can then be processed and used as a basis for various analytics needs. In this architecture, it stores raw snapshot data useful in calculating and reporting on your workload's efficiency.
- [Azure Logic Apps](/azure/logic-apps/logic-apps-overview) enables you to create and run automated workflows with minimal code. By using the visual designer and selecting from prebuilt operations, you can create a workflow that integrates and manages your proxy sources, data storage, and efficiency calculation systems.
- [Azure Functions](/azure/well-architected/service-guides/azure-functions-security) enables you to run small units of code. It automatically scales resources based on demand, and you pay only for the actual execution time. You can use it to make sustainability calculations and store them in your data lake.
- [Azure Automation](/azure/automation/overview) provides process automation via runbooks. You can use the runbooks to implement complex logic, by using PowerShell code, that can influence your application to improve efficiency.
- [Power BI](/power-bi/fundamentals/power-bi-overview) allows you to turn your data into analytics and reports that provide real-time insights. In this architecture, it would contain dashboards that stakeholders can use to evaluate their obtainment of sustainability goals.

### Alternatives

The Azure services described in this article can be replaced with similar services. To increase density and utilization of existing resources, perform the calculations with the minimum impact to your infrastructure by using Azure services or tools that are already deployed in your environment:

- You can substitute Power BI dashboards with [Azure Monitor workbooks](/azure/azure-monitor/visualize/workbooks-overview) or [Azure Managed Grafana](https://azure.microsoft.com/services/managed-grafana/) services.
- You can substitute Application Insights with another application performance management (APM) tool, like Elasticsearch application performance management (APM) or OpenAPM.
- Data in the form of tables or unstructured data can be retained in any system of records, like [Azure Database for MySQL](/azure/mysql/flexible-server/overview) or [Azure Cosmos DB for NoSQL](/azure/cosmos-db/) and [Azure DocumentDB](/azure/documentdb/overview).
- If you have a running [Azure Functions](/azure/azure-functions/functions-overview) or Logic Apps space, you can run the calculation on a regular basis from your existing deployments.
- If the application resources are distributed across multiple resource groups, you can use tags to correlate cost data and calculate the amount of carbon emitted by the application.

## Scenario details

This architecture is designed to gather carbon optimization data from Azure and other sources to provide a comprehensive view of an application's environmental impact. Data is collected from the Azure Carbon Optimization service. For non-Azure environments, a proxy is used to retrieve relevant carbon metrics. After the data is consolidated, SCI calculations are performed to assess the overall carbon footprint. The results are then stored in a data lake for long-term retention, which enables BI analysis and historical reporting. This approach ensures centralized tracking of carbon impact across diverse infrastructure and supports strategic sustainability efforts.

The carbon emissions information is partially gathered from available APIs and partially calculated, when possible, via proxy.

:::image type="content" source="media/carbon-optimization-blade.png" alt-text="Screenshot of the Carbon optimization blade." lightbox="media/carbon-optimization-blade.png" border="false":::

It's essential to use a dedicated architecture to gather Azure carbon optimization data for two key reasons:

- Azure carbon optimization data is stored and displayed only for the past twelve months (in a rolling window). When long-term tracking of a carbon footprint is required, a dedicated system ensures the retention of detailed historical information.
- An application might span multiple infrastructures, with Azure as only one component. A separate architecture enables centralized monitoring of carbon impact across all environments to provide a holistic view and ensure more comprehensive sustainability insights.

> [!NOTE]
> Greenhouse gases aren't made up of only carbon dioxide, and they don't all have the same impact on the environment. For example, one ton of methane has the [same heating effect](https://wikipedia.org/wiki/Global_warming_potential) as 80 tons of carbon dioxide. In this article, everything is normalized to the CO2-equivalent measure. All references to carbon refer to the CO2-equivalent.

### Data sources

To calculate a comprehensive SCI score, you need data from multiple sources. It's important to distinguish between data used for **reporting** (retrospective) and data used for **runtime** decisions (real-time).

#### Reporting and trend analysis

The **Azure Carbon Optimization** provides monthly carbon emission data for your Azure resources. This covers the `E` (Energy) and `M` (Embodied Carbon) components of the [SCI formula](#calculations) in an aggregated form.

Aggregate data from Microsoft Cost Management and Azure Monitor also you to compare your SCI score to the effective work being accomplished and the monetary cost of that work.

#### Runtime carbon awareness

These sources provide real-time data needed for *carbon-aware* applications that react to changing grid conditions:

- [WattTime](https://docs.watttime.org/) and [Electricity Maps](https://app.electricitymaps.com/): Third-party APIs that provide real-time carbon intensity (`I`) data for the local power grid. Since Azure does not publish real-time data center carbon intensity, the local grid intensity serves as the standard proxy.
- Application Insights collects real-time performance and scale metrics to calculate your functional unit (`R`) and estimate energy consumption (`E`):
  - Scaling factor (e.g., API calls, active users)
  - CPU and Memory usage
  - Response time

For a tutorial on how to set up Application Insights to get the required metrics, see [Application Insights for ASP.NET Core applications](/azure/azure-monitor/app/tutorial-asp-net-core).

You should consider adding other variables to the equation, such as:

- Edge services and infrastructure carbon emissions.
- Proxies based on end user device profiles
- The time when users connect, as electricity production and demand vary with time.
- Any other metric of the app that can tell you how its performance changes over time.

By building this equation into a score that can also reflect the number of users, you create the closest approximation to a carbon score. This score is your benchmark for any further change and improvement toward the sustainability of the app.

Cost is another consideration that's associated with application performance. In most cases, a direct correlation between performance efficiency and cost and carbon savings can be established. This correlation leads to the following assumptions:

- When performance is higher but costs are the same, you have optimized the app and reduced carbon emissions.
- When costs are reduced but performance is the same, you have optimized the app and reduced carbon emissions.
- When both performance and costs increase, you haven't optimized the app, and you have increased carbon emissions.
- When costs increase but performance is reduced or the same, you haven't optimized the app and have increased carbon emissions (or the energy cost is higher, which is also a cause for higher carbon emissions).

This correlation between the SCI score, cost, and performance of an application is unique for every application and depends on many factors. By gathering data for these three variables, you can create an algorithm of correlation that allows you to forecast any variation of the three, and to make informed decisions on the application architecture and patterns.

### Calculations

The [Software Carbon Intensity (SCI)](https://grnsft.org/sci) score is formally calculated using the following formula, which represents the rate of carbon emissions per one unit:

```text
SCI = ((E * I) + M) per R
```

In this equation:

- `E` is the **Energy** consumed by a software system. It's measured in kilowatt-hours (kWh).
- `I` is the **Carbon Intensity** of the energy source. It's measured in grams of carbon dioxide equivalent per kilowatt-hour (gCO2e/kWh). This value varies by location and time of day.
- `M` is the **Embodied Carbon** of the hardware. It represents the carbon emitted during the manufacturing, transportation, and disposal of the hardware. It's a static value allocated to the software based on its usage share and lifespan.
- `R` is the **Functional Unit** (or scaling factor) for the application. This normalizes the score to a unit of work, such as per user, per API call, or per job.

> [!NOTE]
> This score is sometimes reduced to a shorthand of `SCI = C * R` where `C` represented total carbon emissions measured or through proxies. The expanded formula above provides greater granularity, allowing you to target specific variables for optimization: reducing energy consumption (`E`), shifting workloads to cleaner times/locations (`I`), or extending hardware lifespan (`M`).

The time window is a critical aspect of this calculation. Carbon intensity (`I`) varies significantly over time as the energy grid shifts between renewable and fossil fuel sources. To make effective carbon-aware decisions at runtime, you need real-time or near-real-time data (hourly or less) provided by [third-party APIs](#data-sources).

The Azure Carbon Optimization service currently provides *monthly* aggregated carbon data for your resources. This monthly data is excellent for:

- **Reporting:** Tracking long-term trends and validating the impact of design changes.
- **Baseline:** Establishing a starting point for your sustainability journey.

### Data storage

You should store the carbon and carbon proxy information that you gather in a solution that you can connect to dashboards or reports. Doing so enables you to visualize your carbon score over time and make informed choices. To improve sustainability and align with Azure Well-Architected Framework best practices, we recommend that you use the minimum viable system. For more information, see [Data and storage design considerations for sustainable workloads on Azure](/azure/architecture/framework/sustainability/sustainability-storage) and [Application platform considerations for sustainable workloads on Azure](/azure/well-architected/sustainability/sustainability-application-platform#evaluate-moving-to-paas-and-serverless-workloads). Azure Data Lake Storage is used in this architecture.

### Data correlations

When you start gathering data on the carbon, performance, and cost of your application, you'll have valuable information that allows you to create a correlation algorithm that's specific to your application and that will provide guidance when you plan for cost, performance, and carbon optimization.

For more information, see [How to select algorithms for Azure Machine Learning](/azure/machine-learning/how-to-select-algorithms).

### Data display

You can display your data and calculations in various ways, including customized [Azure Monitor dashboards](/azure/azure-monitor/app/tutorial-app-dashboards) and simple [Power BI dashboards](/power-bi/create-reports/service-dashboard-create).

### What can your SCI score and real-time measurements trigger?

Ideally, you've designed your workload to be sustainable by following the [Design principles of a sustainable workload](/azure/well-architected/sustainability/sustainability-design-principles). Upfront workload design focuses on minimizing **Energy (`E`)** and **Embodied Carbon (`M`)**. This involves writing efficient code, choosing the right architecture, and maximizing hardware density to prevent premature hardware disposal. These decisions are static and made before the application runs or are backlog items to improve an existing application.

A carbon-aware workload is triggered by unfavorable real-time conditions. Runtime triggers are usually based on the **Carbon Intensity (`I`)** component. Some examples of these conditions are:

- Energy production and demand are at an all-time high and is therefore expensive to produce.
- Electricity isn't available. This condition could be caused by a natural disaster or geopolitical conflict.
- Sudden unavailability of edge infrastructure caused by resource over-consumption or supply chain issues.

Based on these triggers you can decide what actions to take. Such as shift to job processing times or locations where the energy grid is cleaner.  Additional examples that could be part of your workload:

- Apply a [graceful degradation](/azure/well-architected/reliability/self-preservation#implement-a-graceful-degradation-mode) of the app's services and features.

  For example, enable an eco-mode version of your application. Eco mode is a simpler, smaller, cheaper, more sustainable version of the application that offers minimal features. You can revert to this version during carbon emission spikes. You can also simply train your end users to use an eco version by choice. You can provide a "green button" that enables people to use a leaner interface, fewer graphics, and limited features in exchange for reduced carbon emissions.

- If you choose to involve your users, you create an opportunity to drive a cultural change along with the technical one:

  - You can specify the impact of the choice: "By using the eco version, you save *x amount* of carbon" or "bringing our carbon score to *y amount*."
  - You can gain an understanding of user behavior and modify the eco version to reflect their choices. (Maybe they use 10% of the features and are an ideal user of the eco version.)
  - As the full version is optimized for emission, you can ideally eventually merge the two versions.

> [!EXAMPLE]
> **Windows Update** is an example of runtime optimization. It uses a carbon-aware API to schedule updates. Instead of downloading updates immediately, it waits for a window when the local grid's carbon intensity (`I`) is low, effectively reducing the carbon footprint of the update process without changing the total energy consumed.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Well-Architected Framework](/azure/well-architected/).

### Security

Security provides assurances against deliberate attacks and the misuse of your valuable data and systems. For more information, see [Design review checklist for Security](/azure/well-architected/security/checklist).

For additional security, you can use Azure Virtual Network service endpoints to remove public internet access to Azure service resources, allowing traffic only from your virtual network.

With this approach, you create a virtual network in Azure and then create private service endpoints for Azure services. Those services are then restricted to traffic from that virtual network. You can also reach them from your on-premises network via a gateway.

Keep in mind that, in order to move data from on-premises into Azure Storage, you need to allow public IP addresses from on-premises or Azure ExpressRoute. For more information, see [Deploy dedicated Azure services into virtual networks](/azure/virtual-network/virtual-network-for-azure-services).

For general guidance on designing secure solutions, see [Azure security documentation](/azure/security).

### Cost Optimization

Cost Optimization focuses on ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Design review checklist for Cost Optimization](/azure/well-architected/cost-optimization/checklist).

You can deploy this architecture by using several alternative Azure services. The architecture intentionally kept components at a minimum to save on cost and its own carbon emissions. We encourage you to use equivalent services that you already have in your application deployment, pricing information is available for each architecture component:

- The [Emissions Impact Dashboard](https://appsource.microsoft.com/product/power-bi/coi-sustainability.emissions_impact_dashboard), Azure carbon optimization, and Microsoft Cost Management reports are free.
- [Application Insights pricing](https://azure.microsoft.com/pricing/details/monitor/).
- [Azure Table Storage pricing](https://azure.microsoft.com/pricing/details/storage/tables/).
- [Azure Logic Apps pricing](https://azure.microsoft.com/pricing/details/logic-apps/).
- [Azure Functions pricing](https://azure.microsoft.com/pricing/details/functions/).
- [Azure Automation pricing](https://azure.microsoft.com/pricing/details/automation/).

### Performance Efficiency

Performance Efficiency refers to your workload's ability to scale to meet user demands efficiently. For more information, see [Design review checklist for Performance Efficiency](/azure/well-architected/performance-efficiency/checklist).

The primary purpose of this architecture is to provide a sustainability score for your applications via a process that has a minimal impact on cost and carbon. Most of the components are platform as a service (PaaS) and serverless Azure services that can scale independently based on use and traffic.

In this scenario, the dashboard and storage interface aren't intended for massive usage and consultation. If you plan to provide it to a large number of users, you might want to consider one of these options:

- Decouple the extracted data by transforming it and storing it in a different system.
- Replace Data Lake Storage with a more scalable data structure alternative, like Azure Cosmos DB.

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
