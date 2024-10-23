The solution described in the following sections will help organizations and partners create a sustainability model for applications hosted on Azure, based on the available proxies that, with time, allow scoring an application’s carbon impact and efficiency. This score is known as the Software Carbon Intensity (SCI) Score and provides a baseline for measuring changes in an application’s carbon output.

The carbon emissions information will be partially gathered from the Azure Portal Azure carbon optimization  blade, and partially calculated, where possible, via proxy. 
Using a separate architecture to gather Azure carbon optimization  data is essential for two key reasons.  
- First, Azure carbon optimization data is stored and displayed only for the relative past twelve months (rolling window), so if long-term tracking of carbon footprint is required, a dedicated system ensures retention of detailed historical information.  
- Second, an application may span multiple infrastructures, with Azure being only one component. A separate architecture allows for centralized monitoring of carbon impact across all environments, providing a holistic view and ensuring more comprehensive sustainability insights. 

image 


> [!NOTE]
> Greenhouse gases are not only made up of carbon dioxide, and they do not all have the same impact on the environment. For example, 1 ton of methane has the same heating effect as 80 tons of carbon dioxide, so the convention used is to normalize everything to the CO2-equivalent measure: when we talk about carbon, we always mean CO2-equivalent. 

## Architecture

:::image type="content" source="media/measure-app-sci-score-inline.png" alt-text="Diagram of creating a sustainability model based on available proxies that scores the carbon impact of an application." lightbox="media/measure-app-sci-score-expanded.png" border="false":::

*Download a [Visio file](https://arch-center.azureedge.net/measure-app-sci-score.vsdx) of this architecture.*

### Dataflow

1. Configure application data sources that will be used to calculate your SCI score. These can be the Azure emissions coming from the Azure carbon optimization blade in the portal, or can be proxy emissions coming from third party sources and/or systems. 
1. Export Azure Carbon Emission data to your Data Lake 
1. Leverage event handlers such as Azure Functions or Logic Apps to calculate the SCI score. The output is the amount of carbon emitted in grams per unit, where unit refers to the application scaling factor, or an approximation of it using proxies. 
1. Use different types of actions, such as  Azure Functions, Logic Apps, or Automation Runbooks to trigger demand shaping on the application or to initiate the application’s pre-defined eco-mode. 
1. Use Power BI for reporting and visualization of the score and its variation across time. 

### Components

- Azure carbon optimization blade will provide carbon emission measurements of Azure workloads at resource group level. 
- Cloud for Sustainability API- this is the underlying data for the Carbon optimization data, can be used to retrieve information directly on your subscription’s emissions. 
- [Application Insights] is an extension of Azure Monitor and provides Application Performance Monitoring features. It helps you gain powerful insights into how people use your app. With this knowledge, you can make data-driven decisions about improving your application’s efficiency.  
- Azure Blob Storage, can store the emission information from Azure carbon optimization , from the custom calculations, and from any other proxy for emissions. 
- [Azure Data Lake], a centralized repository that ingests and stores large volumes of data in its original form. The data can then be processed and used as a basis for a variety of analytic needs. 
- [Azure Logic Apps] create and run automated workflows with little to no code. By using the visual designer and selecting from prebuilt operations, you can quickly build a workflow that integrates and manages your proxy sources, data storage, and efficiency calculation systems. 
- Azure Function enables you to run small pieces of code, automatically scales based on demand and only charges for the actual execution time. You can make your sustainability calculations and store them in your Blob Storage or DataLake. 
- [Azure Automation] includes process automation with Runbooks which allow you to implement complex logic using PowerShell code that can shape your application to improve efficiency. This service can also add business value by reducing errors and lowering your operational costs. 
- [Power BI] allows you to turn your data into analytics and reports providing real-time insights into your business. Whether your data is cloud-based or on-premises, Azure and Power BI have the built-in integration and connectivity to bring your visualizations and analytics to life.  

## Scenario details

This architecture is designed to gather carbon optimization data from Azure and other sources to provide a comprehensive view of an application's environmental impact. Data from Azure carbon optimization  is collected, and for non-Azure environments, a proxy is used to retrieve relevant carbon metrics. Once the data is consolidated, SCI (software carbon index) calculations are performed to assess the overall carbon footprint. The results are then stored in an Azure Storage Account or Data Lake for long-term retention, enabling Business Intelligence (BI) analysis and historical reporting. This approach ensures centralized tracking of carbon impact across diverse infrastructure and supports strategic sustainability efforts. 

### Data sources

In general, the approach should be to build a proxy equation with few variables. The proxy metrics chosen should represent the application’s behavior and performance.  

These are the metrics used in our example: 

- The carbon emission of the infrastructure retrieved from [Carbon Emissions](https://www.microsoft.com/sustainability/emissions-impact-dashboard) API, which is the source for both the Impact Dashboard and the Azure carbon optimization blade. This is available at resource group level, making it easier to track your application’s emissions. 
- Performance and scale metrics of the application collected from [Azure Application Insights](/azure/azure-monitor/app/app-insights-overview):  
- The scaling factor (or API calls, or server requests, etc..) that are concurrently connected the application 
- CPU usage 
- Memory usage 
- Response time (send/receive) 

Here you can find a tutorial on how to set-up your Application Insights to get the required metrics: [Application Insights SDK for ASP.NET Core applications](/azure/azure-monitor/app/tutorial-asp-net-core)
 
Additional variables can be added to the equation, such as: 

- Edge services and infrastructure carbon emissions 
- Time when users connect, as electricity production and demand varies with time 
- Any other peculiar metric of the app that can tell us how its performance is changing across time 


Building this equation into a score that can also reflect the number of users, represents the closest approximation to a carbon score, and this will be your benchmark for any further change and improvement towards the greenness of the app. 
Another consideration that we associate to application performance is cost. In most cases, we can show direct correlation of performance efficiency to cost and carbon savings. This allows us to make the assumptions that: 

- When performance is higher, but costs are the same = we have optimized the app and have lowered carbon emissions 
- When costs are lower, but performance is the same = we have optimized the app and have lowered carbon emissions 
- When performance and costs are up = we have not optimized the app and have increased carbon emissions 
- When costs are up, but performance is lower or equal = we have not optimized the app and have increased carbon emissions (or the energy cost is higher, which according to principles is also cause for higher carbon emissions) 

This correlation between the Software Carbon Intensity score (SCI), cost, and performance of an application is unique for every application and will depend on many factors. Gathering data of these three variables will allow you to create an algorithm of correlation that will allow you to successfully forecast any variation of the three, and to make informed decisions on the application architecture and patterns. 

### Calculations

As mentioned, we are unable to form a discrete calculation for the proxies we are using. In this scenario, we need to process the data gathered from the Emissions Impact Dashboard as a starting point. The SCI baseline calculation is as follows: 

```text
SCI =C∗RSCI =C∗R
```

Where: 

-	C is the carbon emissions for the application. This value will depend on how the application is deployed in Azure. For example, if all the application resources are in a single resource group, the carbon emissions for this resource group would be the C variable.  

Note: For the time being, we’ll not consider other sources of emissions for the application, as they will strictly depend on the architecture and edge/user behavior – this can be the next step when using carbon proxies. 

-	R is the scaling factor for the application. This can be the number of average concurrent users, for the considered time window, or API requests, or web requests, etc.… This is important as we can have a score that will account the overall impact of the usage of the application, and not just its deployment footprint. 

The time window is, of course, another important aspect of this calculation: carbon emissions for any energy consuming device or system will vary through time, since the energy grid may have renewable or alternate energy sources in specific moments but not in others (think, for example, about solar power). It is therefore important to start with the shortest possible timeframe (for example a daily or hourly calculation) to be as precise as possible. 

The Carbon Emissions API, at the time of writing, will provide monthly carbon information based on the services within a subscription, at resource group level. Emissions data can be exported using the available REST API, towards a Data Lake that will hold all sustainability data for the application. 

[Export Azure carbon optimization  emissions data (Preview)](/azure/carbon-optimization/export-data?toc=%2Findustry%2Fsustainability%2Ftoc.json&bc=%2Findustry%2Fbreadcrumb%2Ftoc.json&tabs=RESTAPI)

```text
Carbon (res-group) = (Carbon(subscription) * Cost(res-group)) / Cost(subscription)
```

Store the monthly carbon information for your resource group along with the rest of the data, as explained in the following section.

### Data storage

The carbon and carbon proxy information that you gathered in the previous section should be stored somewhere that you can connect to dashboards or reports, so you can visualize your carbon score over time and make informed choices. For sustainable reasons, and in alignment with the best practices of the Well Architected Framework (see [Data and storage design considerations for sustainable workloads on Azure](/azure/architecture/framework/sustainability/sustainability-storage) and [Application platform considerations for sustainable workloads on Azure](/azure/architecture/framework/sustainability/sustainability-application-platform%22 /l %22evaluate-moving-to-paas-and-serverless-workloads)) we recommend using the minimum viable system of record. In this case we opt for a Data Lake Storage.  

### Data correlations

When we start gathering data on the carbon, performance, and cost of the application, we’ll have valuable information that will allow you to build a correlation algorithm that is specific to your application, and that will provide guidance when planning for cost, performance, and carbon optimization. 
. 
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
