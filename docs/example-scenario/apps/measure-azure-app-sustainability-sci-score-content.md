The solution described in this article can help you create a sustainability model for applications that are hosted on Azure. The model uses proxies that, over time, allow you to score an application's carbon impact and efficiency. The score is known as the Software Carbon Intensity (SCI) score. It provides a baseline for measuring changes in an application's carbon output.

The carbon emissions information is partially gathered from the Azure portal **Carbon optimization** blade, and partially calculated, when possible, via proxy.

It's essential to use a separate architecture to gather Azure carbon optimization data for two key reasons:  

- Azure carbon optimization data is stored and displayed only for the past twelve months (in a rolling window). When long-term tracking of a carbon footprint is required, a dedicated system ensures the retention of detailed historical information.
- An application might span multiple infrastructures, with Azure as only one component. A separate architecture enables centralized monitoring of carbon impact across all environments to provide a holistic view and ensure more comprehensive sustainability insights.

:::image type="content" source="media/carbon-optimization-blade.png" alt-text="Screenshot of the Carbon optimization blade." border="false":::

> [!NOTE]
> Greenhouse gases aren't made up of only carbon dioxide, and they don't all have the same impact on the environment. For example, one ton of methane has the same heating effect as 80 tons of carbon dioxide. In this article, everything is normalized to the CO2-equivalent measure. All references to carbon refer to the CO2-equivalent. 

## Architecture

:::image type="content" source="media/measure-app-sci-score.png" alt-text="Diagram of a sustainability model that scores the carbon impact of an application." lightbox="media/measure-app-sci-score.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/measure-app-sci-score.vsdx) of this architecture.*

### Dataflow

1. Configure application data sources that you'll use to calculate your SCI score. The data can be the emissions measurements provided by the **Carbon optimization** blade in the Azure portal, or they can be proxy measurements from non-Microsoft sources or systems. 
1. Export carbon emission data to your data lake. 
1. Use event handlers like Azure Functions or Azure Logic Apps to calculate the SCI score. The output is the amount of carbon emitted in grams per unit, where *unit* refers to the application scaling factor, or an approximation of it that's based on proxies. 
1. Use technologies like Azure Functions, Logic Apps, or Azure Automation runbooks to trigger demand shaping on the application or to initiate the application's predefined eco mode. 
1. Use Power BI to report and visualize the score and its variation over time. 

### Components

- The **Carbon optimization** blade on the Azure portal provides carbon emission measurements of Azure workloads at resource-group level. 
- The Cloud for Sustainability API provides the underlying data for carbon optimization. You can use it to retrieve information on your subscription's emissions. 
- [Application Insights](/azure/azure-monitor/app/app-insights-overview) is a feature of Azure Monitor that provides application performance monitoring. It can help you gain powerful insights into how people use your app. You can use this knowledge to make data-driven decisions about improving your application's efficiency.  
- [Azure Blob Storage](/azure/well-architected/service-guides/azure-blob-storage) stores the emission information Azure carbon optimization, from custom calculations, or from other proxies for emissions. 
- [Azure Data Lake](https://azure.microsoft.com/solutions/data-lake) is a centralized repository that ingests and stores large volumes of data in its original form. The data can then be processed and used as a basis for a variety of analytics needs. 
- [Azure Logic Apps](https://azure.microsoft.com/products/logic-apps) enables you to create and run automated workflows with little to no code. By using the visual designer and selecting from prebuilt operations, you can quickly create a workflow that integrates and manages your proxy sources, data storage, and efficiency calculation systems. 
- [Azure Functions](https://azure.microsoft.com/products/functions) enables you to run small pieces of code. It automatically scales resources based on demand, and you pay only for the actual execution time. You can use it to make sustainability calculations and store them in Blob Storage or a data lake. 
- [Azure Automation](https://azure.microsoft.com/products/automation) provides process automation via runbooks. You can use the runbooks to implement complex logic, by using PowerShell code, that can influence your application to improve efficiency. This service can also add business value by reducing errors and reducing operational costs. 
- [Power BI](https://www.microsoft.com/power-platform/products/power-bi) allows you to turn your data into analytics and reports that provide real-time insights.

## Scenario details

This architecture is designed to gather carbon optimization data from Azure and other sources to provide a comprehensive view of an application's environmental impact. Data is collected from Azure carbon optimization. For non-Azure environments, a proxy is used to retrieve relevant carbon metrics. After the data is consolidated, SCI calculations are performed to assess the overall carbon footprint. The results are then stored in an Azure storage account or data lake for long-term retention, which enables BI analysis and historical reporting. This approach ensures centralized tracking of carbon impact across diverse infrastructure and supports strategic sustainability efforts. 

### Data sources

In general, you should create a proxy equation with few variables. The proxy metrics that you choose should represent the application's behavior and performance.  

These metrics are used in this example: 

- The carbon emission of the infrastructure, which retrieved from the [carbon emissions](https://www.microsoft.com/sustainability/emissions-impact-dashboard) API. This API is the source for both the Emissions Impact Dashboard and the **Carbon optimization** blade in the Azure portal. The data is available at resource group level, which makes it easier to track your application's emissions. 
- Performance and scale metrics of the application, collected from [Application Insights](/azure/azure-monitor/app/app-insights-overview):  
   - The scaling factor (or API calls, or server requests, and so on) that are concurrently connected the application 
   - CPU usage 
   - Memory usage 
   - Response time (send and receive) 

For a tutorial on how to set up Application Insights to get the required metrics, see [Application Insights for ASP.NET Core applications](/azure/azure-monitor/app/tutorial-asp-net-core).
 
You can add other variables to the equation, such as: 

- Edge services and infrastructure carbon emissions. 
- The time when users connect, as electricity production and demand varies with time.
- Any other metric of the app that can tell you how its performance changes over time.

By building this equation into a score that can also reflect the number of users, you create the closest approximation to a carbon score. This score is your benchmark for any further change and improvement towards the sustainability of the app.

Cost is another consideration that's associated to application performance. In most cases, a direct correlation of performance efficiency to cost and carbon savings can be established. This correleation leads to the following assumptions: 

- When performance is higher but costs are the same, you have optimized the app and reduced carbon emissions. 
- When costs are reduced but performance is the same, you have optimized the app and reduced carbon emissions.
- When both performance and costs increase, you haven't optimized the app, and you have increased carbon emissions.
- When costs increase but performance is reduced or the same, you haven't optimized the app and have increased carbon emissions (or the energy cost is higher, which is also a cause for higher carbon emissions).

This correlation between the SCI score, cost, and performance of an application is unique for every application and depends on many factors. By gathering data for these three variables, you can create an algorithm of correlation that allows you to forecast any variation of the three, and to make informed decisions on the application architecture and patterns. 

### Calculations

In the scenario described here, it's not possible to form a discrete calculation for the proxies that are used. Instead, the data gathered from the Emissions Impact Dashboard is processed as a starting point. Here's the SCI baseline calculation:

```text
SCI = C∗R
```

In this equation: 

-	`C` is the carbon emissions for the application. This value is affected by how the application is deployed on Azure. For example, if all the application resources are in a single resource group, `C` is the carbon emissions for that resource group.  

    > [!NOTE]
    > For now, other sources of emissions for the application are ignored, because they depend on the architecture and edge/user behavior. If you use proxies for data, you can consider these sources in the next step. 

-	`R` is the scaling factor for the application. This can be the number of average concurrent users for the time window, API requests, web requests, or some other metric. This value is important because it leads to a score that accounts for the overall impact of the usage of the application, not just its deployment footprint.

The time window is, of course, another important aspect of this calculation: carbon emissions for any energy-consuming device or system vary over time, because the energy grid might have renewable or alternative energy sources (for example, solar power) at sime times but not at others. It's therefore important to start with the shortest possible timeframe to increase precision. For example, you might start with a daily or hourly calculation.

The carbon emissions API currently provides monthly carbon information based on the services within a subscription, at the resource group level. By using the provided REST API, you can [export emissions data](/azure/carbon-optimization/export-data?tabs=RESTAPI) to a data lake that holds all sustainability data for the application.

### Data storage

You should store the carbon and carbon proxy information that you gather in a solution that you can connect to dashboards or reports. Doing so enables you to visualize your carbon score over time and make informed choices. To improve sustainability and align with the Well Architected Framework best practices (see [Data and storage design considerations for sustainable workloads on Azure](/azure/architecture/framework/sustainability/sustainability-storage) and [Application platform considerations for sustainable workloads on Azure](/azure/architecture/framework/sustainability/sustainability-application-platform#evaluate-moving-to-paas-and-serverless-workloads)), we recommend that you use the minimum viable system of record. In this case we opt for a Data Lake Storage.  

### Data correlations

When we start gathering data on the carbon, performance, and cost of the application, we’ll have valuable information that will allow you to build a correlation algorithm that is specific to your application, and that will provide guidance when planning for cost, performance, and carbon optimization. 

See additional information on the choice of ML algorithm here: https://learn.microsoft.com/en-us/azure/machine-learning/how-to-select-algorithms 

### Data display

Your data and calculations can be displayed several ways, such as through a customized Azure Monitor Workbook, or a simple Power BI dashboard. 
For more info see:  
https://learn.microsoft.com/en-us/azure/azure-monitor/app/tutorial-app-dashboards  
https://learn.microsoft.com/en-us/power-bi/create-reports/service-dashboard-create  

### What can your SCI score trigger? 

One of the most frequent questions when approaching sustainability for cloud workloads is, “Once I know my score, how can I improve it?” 

If you can score the application’s carbon impact with proxies, the next step is to focus on defining what actions can be triggered by unfavorable conditions in your carbon score. Some examples of these conditions are:  
- Energy production and demand is at an all-time high and is therefore very expensive to produce  
- Electricity is simply not available – this could be because of natural disaster or geopolitical conflict.  
- Sudden unavailability of edge infrastructure due to resource over-consumption or supply chain issues 

Once you can identify the failure points that can impact your application, you can decide what actions you will take to make your application **resilient to carbon spikes**. 

There are several actions that the app may take: 

-	You can apply a graceful degradation of services and features of the app, as described in the WAF documentation https://learn.microsoft.com/en-us/azure/well-architected/reliability/self-preservation#application-design-guidance-and-patterns-1 
-	You can build an “eco-mode” version of your application. This should be a simpler, smaller, cheaper, greener version of the full application that offers minimal features for functional use, that you can revert to in case of carbon emission spikes. You may also simply train your end-users to opt for the eco version by choice, providing a “green button” where people declare they are ok with a leaner interface, less graphics, and limited features in exchange for reducing carbon emissions.  
-	If you opt to involve the users, this provides an opportunity to drive a cultural change along with the technical one: 
      -	You can specify what the impact of this choice is: “by using the green version you are saving x amount of carbon”, or “bringing our carbon score to Y” 
      -	You can understand the user behavior and modify the eco version to reflect their choices (maybe they use 10% of the features, and they are an ideal user of the green version) 
      -	Slowly the full version gets optimized for emission as well and ideally, these versions are able to eventually converge. 

## Alternatives 

The Azure services used in this document can be replaced with similar services, and **we encourage you to perform the calculation with the minimum impact to your infrastructure** by using Azure services or tools that are already deployed within your environment to increase density and utilization on existing resources: 
- Substitute Power BI dashboards with [Azure Monitor Workbooks](/azure/azure-monitor/visualize/workbooks-overview) or [Azure Managed Grafana](https://azure.microsoft.com/services/managed-grafana/) services.  
- Application Insights can be swapped with any other Application Performance Management tool, for example Elasticsearch APM or Open APM. 
- Data in the form of tables or unstructured data can be retained with any system of records, such as [MySQL](https://azure.microsoft.com/products/mysql/) or [MariaDB](/azure/mariadb/overview), or [CosmosDB](/azure/cosmos-db/) and [MongoDB](/azure/cosmos-db/mongodb/). 
- If you have a running Azure [Functions](/azure/azure-functions/functions-overview) or Logic Apps space, consider launching the calculation on a regular basis from your existing deployments. 
- If the application resources are distributed across multiple resource groups, tags can be used to correlate cost data and calculate the amount of carbon emitted by the application.  

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/well-architected/).

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the Security pillar](/azure/architecture/framework/security/overview).

For additional security, you can use Virtual Network service endpoints to secure Azure service resources to only your virtual network. This fully removes public Internet access to those resources, allowing traffic only from your virtual network. 

With this approach, you create a virtual network in Azure and then create private service endpoints for Azure services. Those services are then restricted to traffic from that virtual network. You can also reach them from your on-premises network through a gateway. 

Be aware of the following limitations: 

-	To move data from on-premises into Azure Storage, you will need to allow public IP addresses from your on-premises or ExpressRoute. For details, see Securing Azure services to virtual networks. 

For general guidance on designing secure solutions, see the [Azure Security Documentation](/azure/security). 

### Cost Optimization

Cost Optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the Cost Optimization pillar](/azure/architecture/framework/cost/overview).

This architecture can be deployed using several alternative Azure services but was kept intentionally at a minimum to save on cost and carbon emissions.  

While we encourage you to use any equivalent service you may already have in your application deployment, each architecture components’ pricing can be found at the following links: 
-	The [Emissions Impact Dashboard](https://appsource.microsoft.com/product/power-bi/coi-sustainability.emissions_impact_dashboard), Azure carbon optimization and Azure Cost Management reports are free 
-	[App Insights pricing](https://azure.microsoft.com/pricing/details/monitor/)
-	[Azure Table Storage pricing](https://azure.microsoft.com/pricing/details/storage/tables/)  
-	[Azure Logic Apps pricing](https://azure.microsoft.com/pricing/details/logic-apps/)  
-	[Azure Functions pricing](https://azure.microsoft.com/pricing/details/functions/)
-	[Azure Automation pricing](https://azure.microsoft.com/pricing/details/automation/)  

### Performance efficiency

Performance Efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance Efficiency pillar overview](/azure/architecture/framework/scalability/overview).

The primary purpose of this architecture is to provide a sustainability score for your application(s) with a minimal impact on cost and carbon itself. Most of the components are PaaS and serverless Azure services that can scale independently based on use and traffic. 

In this scenario, the dashboard and storage interface are not intended for a massive usage and consultation so if you plan to provide it to a large number of users, you might want to consider either  

-	decoupling the extracted data, by transforming it and storing it in a different system of record 
or 
-	switching Data Lake or Azure Tables to a more scalable data structure alternative, such as Cosmos DB. 

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:

- [Paola Annis](https://www.linkedin.com/in/paolaeva) | Principal Customer Experience Engineering Manager
- [Davide Bedin](https://www.linkedin.com/in/davidebedin/) | Senior Cloud Solution Architect, Application Innovation 

Other contributor:

- [Chad Kittel](https://www.linkedin.com/in/chadkittel) | Principal Software Engineer 

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

This work is aligned with the principles and methodology of the [Green Software Foundation](https://greensoftware.foundation/). The next step to building a greener application is to embed the **carbon aware SDK** into your application, so that triggers can be automated in real-time once specific carbon conditions are met. 

See [Green-Software-Foundation/carbon-aware-sdk: Carbon-Aware SDK (github.com)](https://github.com/Green-Software-Foundation/carbon-aware-sdk) 

Sustainability cloud workload guidance for the Well Architected Framework can be found here: https://learn.microsoft.com/en-us/azure/architecture/framework/sustainability   

## Related resources

- [Choose a data analytics and reporting technology in Azure](../../data-guide/technology-choices/analysis-visualizations-reporting.md)
- [Data analysis workloads for regulated industries](/azure/architecture/example-scenario/data/data-warehouse)
- [Interactive price analytics using transaction history data](../../solution-ideas/articles/interactive-price-analytics.yml)
- [Power BI data write-back with Power Apps and Power Automate](../data/power-bi-write-back-power-apps.yml)
