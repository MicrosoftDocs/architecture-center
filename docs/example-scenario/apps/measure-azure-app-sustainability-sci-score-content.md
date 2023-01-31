This example workload helps you create a sustainability model based on available proxies. This model allows scoring of the carbon efficiency of an application. This Software Carbon Intensity (SCI) score provides a baseline for measuring changes in an application's carbon output.

> [!NOTE]
> Other greenhouse gases besides carbon dioxide have different effects on the environment. For example, one ton of methane has the same heating effect as 80 tons of carbon dioxide. By convention, this article normalizes everything to the *CO2-equivalent* measure. References to *carbon* always mean the CO2-equivalent.

## Architecture

:::image type="content" source="media/measure-app-sci-score-inline.png" alt-text="Diagram of creating a sustainability model based on available proxies that scores the carbon impact of an application." lightbox="media/measure-app-sci-score-expanded.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/measure-app-sci-score.vsdx) of this architecture.*

### Dataflow

1. Configure the application data sources to use to calculate the SCI score.
2. Save the data in Azure Table Storage in an Azure Storage account.
3. Use event handlers to calculate the SCI score. Event handlers might include Azure Functions, Azure Logic Apps, and Azure Blob Storage. The score is the amount of carbon emitted in grams per unit, where unit refers to the application scaling factor, or an approximation of it using proxies.
4. Use Azure Functions, Logic Apps, and automation runbooks to trigger demand shaping on the application or to initiate the pre-defined eco-mode of the application.
5. Use Power BI for reports and visualization of the score over time.

### Components

- [Emissions Impact Dashboard for Azure](https://www.microsoft.com/sustainability/emissions-impact-dashboard) helps measure your cloud-based emissions and carbon savings potential. It tracks direct and indirect greenhouse gas emissions related to cloud usage.
- [Application Insights](/azure/azure-monitor/app/app-insights-overview) is an extension of [Azure Monitor](https://azure.microsoft.com/products/monitor) that provides application performance monitoring (APM). Application Insights helps you understand how people use your application. Use this knowledge to improve application efficiency.
- [Azure Table Storage](https://azure.microsoft.com/products/storage/tables) is a service that stores non-relational structured data, also known as *structured NoSQL data*. It provides a key/attribute store with a schemaless design. For many types of applications, access to Table Storage data is fast and cost-effective. Table Storage typically costs less than traditional SQL for similar volumes of data.
- [Azure Logic Apps](https://azure.microsoft.com/products/logic-apps) is a platform where you can create and run automated workflows with little to no code. By using the visual designer and selecting from prebuilt operations, build a workflow that integrates and manages proxy sources, data storage, and efficiency calculation systems.
- [Azure Functions](https://azure.microsoft.com/products/functions) is a serverless solution that allows you to write less code, maintain less infrastructure, and save on costs. The cloud infrastructure provides all the up-to-date resources needed to keep your applications running.
- [Power BI](/power-bi) can turn data into analytics and reports that provide real-time insights. Whether your data is cloud-based or on-premises, Azure and Power BI have the integration and connectivity to bring visualizations and analytics to life.

### Alternatives

You can replace the Azure services used in this document with similar services. To do the calculation with the minimum effect on your infrastructure and to increase density and use of existing resources, use Azure services or tools that are already deployed in your environment:

- Instead of Power BI dashboards, use [Azure Monitor Workbooks](https://learn.microsoft.com/azure/azure-monitor/visualize/workbooks-overview) or [Azure Managed Grafana](https://azure.microsoft.com/services/managed-grafana) services.
- For Application Insights, substitute another APM tool, such as [Elasticsearch](https://www.elastic.co) or Open APM.
- You can save data tables by using another system of records, such as [MySQL](https://azure.microsoft.com/products/mysql) or [MariaDB](/azure/mariadb/overview).
- If you have a running Azure Functions or Logic Apps applications, consider launching the calculation regularly from existing deployments.
- If the application resources are distributed across multiple resource groups, use tags to correlate cost data and calculate the amount of carbon that the application emits.

## Scenario details

These sections describe the details required to calculate a baseline for measuring changes in carbon output.

### Data sources

Try to build a proxy equation that has few variables. Choose proxy metrics that represent the application behavior and performance. This example uses the following metrics:

- The carbon emission of the infrastructure from the Emissions Impact Dashboard for Azure
- The cost of the infrastructure, measured in daily or monthly spend by resource group, from [Microsoft Cost Management](/rest/api/cost-management)
- Performance and scale metrics of the application from Application Insights:
  - The number of users, API calls, or server requests that are connected to the application
  - CPU usage
  - Memory usage
  - Response time for send or receive

For a tutorial about how to set up Application Insights for the metrics, see [Application Insights SDK for ASP.NET Core applications](https://learn.microsoft.com/azure/azure-monitor/app/tutorial-asp-net-core).

You can add more variables to the equation, such as:

- infrastructure and edge services carbon emissions
- Time when users connect, because electricity production and demand vary with time
- Any other peculiar metric of the application that can explain how its performance changes over time

Building this equation into a score that can also reflect the number of users represents the closest approximation to a carbon score. This value is the benchmark for changes and improvements in the sustainability of the application.

Another consideration for application performance is cost. In most cases, there's a direct correlation of performance efficiency to cost and carbon savings.

| Description | Conclusion |
|:----------- |:----------
| Performance is higher, but costs are the same | The application is optimized and lowered carbon emissions |
| Costs are lower, but performance is the same | The application is optimized and lowered carbon emissions |
| Performance and costs are up | The application isn't optimized and increased carbon emissions |
| Costs are up, but performance is lower or equal | The application isn't optimized and increased carbon emissions, or the energy cost is higher, which also causes higher carbon emissions |

This correlation between application SCI score, cost, and performance is unique for every application. It depends on many factors. Gathering data for these three variables allows you to create an algorithm to forecast their variations. The SCI helps you make informed decisions about the application architecture and patterns.

### Calculations

In this scenario, process the data gathered from the Emissions Impact Dashboard as a starting point. The SCI baseline calculation is as follows:

```text
SCI = C * R
```

The components are:

- `SCI`. Software Carbon Intensity result.

- `C`. The carbon emissions for the application.

  This value depends on how the application is deployed in Azure. For example, if all the application resources are in a single resource group, the carbon emissions for this resource group would be the `C` variable.

  > [!NOTE]
  > This scenario doesn't consider other sources of emissions for the application that depend on the architecture and edge or user behavior. These considerations are the next step when you use carbon proxies.

- `R`. The scaling factor for the application.

  This value can be the number of average concurrent users, for the considered time window, or API requests or web requests. The scaling factor lets the score account for the overall effect of the usage of the application, instead of just its deployment footprint.

The time window is another important aspect of this calculation. Carbon emissions vary for any energy consuming device or system, since the energy grid might have renewable or alternate energy sources at some times but not at others. For example, solar power is variable. To be as precise as possible, start with the shortest possible time frame, for example a daily or hourly calculation.

The Emissions Impact Dashboard provides monthly carbon information based on the services within a subscription. T get this number for a single resource group, use the following equation:

```text
Carbon (res-group) = (Carbon(subscription) * Cost(res-group)) / Cost(subscription)
```

Store the monthly carbon information for your resource group along with the rest of the data, as explained in the following section.

### Data storage

Store the carbon and carbon proxy information gathered in the previous section. Export the information to dashboards or reports, so you can visualize the carbon score over time and make informed choices. For reasons of sustainability, and in alignment with the best practices of the Well Architected Framework, use the minimum viable system of record, for example, [Azure Table Storage](/azure/storage/tables/table-storage-quickstart-portal).

Tables that describe the gathered data use data like the following example:

Data from reports:

- Date
- Resource group name
- Carbon emissions from dashboard C
- Cost

Data from APM:

- CPU
- Memory
- Response time ratio (send/receive)
Scaling factor R

Calculations: SCI

For more information, see:

- [Data and storage design considerations for sustainable workloads on Azure](/azure/architecture/framework/sustainability/sustainability-storage)
- [Application platform considerations for sustainable workloads on Azure](/azure/architecture/framework/sustainability/sustainability-application-platform#evaluate-moving-to-paas-and-serverless-workloads).

### Data correlations

Data on the application carbon, performance, and cost allows you to build a correlation algorithm that is specific to your application. That information provides guidance when planning for cost, performance, and carbon optimization.

> [!NOTE]
> Equations with costs that discounts, such as Azure reservations or cost savings plans, create discrepancies in the correlation algorithm.

For more information about the choice of algorithm, see [How to select algorithms for Azure Machine Learning](/azure/machine-learning/how-to-select-algorithms).

### Data display

You can display data and calculations several ways, such as through a customized Azure Monitor Workbook or a simple Power BI dashboard. For more information, see [Create custom KPI dashboards using Application Insights](/azure/azure-monitor/app/tutorial-app-dashboards) and [Create a Power BI dashboard from a report](/power-bi/create-reports/service-dashboard-create).

### SCI score action triggers

After you score the carbon effect of an application by using proxies, the next step is to define what actions unfavorable conditions in the carbon score should trigger. Some examples of these conditions are:

- Energy production and demand are high and energy is expensive to produce
- Electricity isn't available because of natural disaster or geopolitical conflict
- Edge infrastructure becomes unavailable due to resource over-consumption or supply chain issues

After you identify the failure points that can affect the application, decide what actions to take to make the application *resilient to carbon spikes*.

Consider building an *eco-mode* version of the application. The eco-mode version is a simpler, smaller, cheaper, greener version of the full application. The application reverts to these minimal features if there are carbon emission spikes.

Consider helping end-users to choose the eco-mode version. Provide a *green button* for people to declare that they're OK with a leaner interface, fewer graphics, and limited features in exchange for reducing carbon emissions. Involving users provides an opportunity to drive cultural change along with technical change:

- Specify the effect of this choice: *By using the green version, you're saving \<X> amount of carbon* or *bringing our carbon score to \<Y>*.
- Learn about the user behavior and modify the eco-mode version to reflect their choices. For instance, if someone uses only 10 percent of application features, they might be an ideal user of the green version.
- Ideally, over time the full version is optimized for emission and the versions eventually converge.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

For more security, use [Azure Virtual Network](https://azure.microsoft.com/products/virtual-network) service endpoints to secure Azure service resources to only your virtual network. This approach closes public internet access to those resources and allows traffic only from your virtual network.

With this approach, you create a virtual network in Azure and then create private service endpoints for Azure services. Those services are then restricted to traffic from that virtual network. You can also reach the services from your on-premises network through a gateway.

> [!NOTE]
> To move data from on-premises into Azure Storage, you need to allow public IP addresses from your on-premises computers or use [Azure ExpressRoute](https://azure.microsoft.com/products/expressroute). For details, see [Deploy dedicated Azure services into virtual networks](/azure/virtual-network/virtual-network-for-azure-services).

For general guidance on designing secure solutions, see the [Azure security documentation](/azure/security).

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

The Emissions Impact Dashboard and Azure Cost Management reports are free. This example is intentionally minimal to save on cost and carbon emissions. You can deploy this architecture by using several alternative Azure services.

Use any equivalent service you already have in your application deployment. The following resources provide component pricing information:

- [App Insights pricing](https://azure.microsoft.com/pricing/details/monitor)
- [Azure Table Storage pricing](https://azure.microsoft.com/pricing/details/storage/tables)
- [Azure Logic Apps pricing](https://azure.microsoft.com/pricing/details/logic-apps)
- [Azure Functions pricing](https://azure.microsoft.com/pricing/details/functions)
- [Azure Automation pricing](https://azure.microsoft.com/pricing/details/automation)
- [Power BI pricing](https://powerbi.microsoft.com/pricing)

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

The primary purpose of this architecture is to provide a sustainability score for your applications with a minimal effect on cost and carbon itself. Most of the components are platform as a service (PaaS) and serverless Azure services that can scale independently based on use and traffic.

The dashboard and storage interface in this example aren't suitable for heavy usage and consultation. If you plan to provide this solution to many users, consider these alternatives:

- Decouple the extracted data by transforming it and storing it in a different system of record
- Switch Azure Table Storage to a more scalable data structure alternative, such as [Azure Cosmos DB](https://azure.microsoft.com/products/cosmos-db)

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Paola Annis](https://www.linkedin.com/in/paolaeva) | Principal SVC Engineering Manager
- [Jennifer Wagman](https://www.linkedin.com/in/jcwagman) | Service Engineer

Other contributor:

- [Chad Kittel](https://www.linkedin.com/in/chadkittel) | Principal SDE

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

This work is aligned with the principles and methodology of the [Green Software Foundation](https://greensoftware.foundation).

The next step to building a greener application is to embed the carbon-aware SDK into your application. You can automate triggers in real-time once you meet specific carbon conditions. For more information, see [Green Software Foundation Carbon Aware SDK](https://github.com/Green-Software-Foundation/carbon-aware-sdk).

For sustainability cloud workload guidance in the Well Architected Framework, see the [Sustainability workload documentation](/azure/architecture/framework/sustainability).

For more information about sustainability, see these articles:

- [Build a sustainable IT infrastructure](/industry/sustainability/build-it-infrastructure)
- [Reduce environmental impact of operations](/industry/sustainability/reduce-environmental-impact)
- [What is Microsoft Cloud for Sustainability?](/industry/sustainability/overview)

## Related resources

- [Choose a data analytics and reporting technology in Azure](../../data-guide/technology-choices/analysis-visualizations-reporting.md)
- [Data analysis workloads for regulated industries](/azure/architecture/example-scenario/data/data-warehouse)
- [Interactive price analytics using transaction history data](../../solution-ideas/articles/interactive-price-analytics.yml)
- [Power BI data write-back with Power Apps and Power Automate](../data/power-bi-write-back-power-apps.yml)