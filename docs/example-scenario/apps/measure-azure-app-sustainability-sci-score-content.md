The solution described in the following sections will help organizations and partners create a sustainability model based on the available proxies that, with time, allow scoring an application’s carbon impact and efficiency. This score is known as the Software Carbon Intensity (SCI) Score and provides a baseline for measuring changes in an application’s carbon output. 

Note: Greenhouse gases aren't only made up of carbon dioxide, and they don't all have the same impact on the environment. For example, one ton of methane has the same heating effect as 80 tons of carbon dioxide, so the convention used is to normalize everything to the CO2-equivalent measure: when we talk about carbon, we always mean CO2-equivalent.



## Architecture

> Architecture diagram goes here. Use the following format:

:::image type="content" source="[image-path]" alt-text="[alt text]" border="false":::

![Diagram of the <solution name> architecture.](./images/<file-name>.png)

> Under the architecture diagram, include this sentence and a link to the Visio file or the PowerPoint file: 

*Download a [Visio file](https://arch-center.azureedge.net/[file-name].vsdx) of this architecture.*

> Note that Visio or PowerPoint files are not allowed in the GitHub repo. Send the file or provide a link so the file can be uploaded to our limited-access CDN server.

### Dataflow

1. Configure application data sources that will be used to calculate your SCI score.
2. Save data in Azure Storage Account -Tables.
3. Use event handlers (Azure Functions, Logic Apps, Blob Storage) to calculate SCI score. The output is the amount of carbon emitted in grams per unit, where unit refers to the application scaling factor, or an approximation of it using proxies.
4. Use different types of actions (Azure Functions, Logic Apps, Automation Runbooks) to trigger demand shaping on the application or to initiate the application’s pre-defined eco-mode.
5. Use Power BI for reporting and visualization of the score and its variation across time.


### Components

- [Microsoft Emissions Impact Dashboard](https://www.microsoft.com/sustainability/emissions-impact-dashboard) helps you measure your Microsoft Cloud-based emissions and carbon savings potential by tracking direct and indirect greenhouse gas emissions related to your cloud usage.
- Application Insights is an extension of [Azure Monitor](https://azure.microsoft.com/en-us/products/monitor) and provides Application Performance Monitoring features. It helps you gain powerful insights into how people use your app. With this knowledge, you can make data-driven decisions about improving your application’s efficiency. 
- [Azure Table Storage](https://azure.microsoft.com/en-us/products/storage/tables) is a service that stores non-relational structured data (also known as structured NoSQL data) in the cloud, providing a key/attribute store with a schemeless design. Access to Table storage data is fast and cost-effective for many types of applications and is typically lower in cost than traditional SQL for similar volumes of data.
- [Azure Logic Apps](https://azure.microsoft.com/en-us/products/logic-apps) is a platform where you can create and run automated workflows with little to no code. By using the visual designer and selecting from prebuilt operations, you can quickly build a workflow that integrates and manages your proxy sources, data storage, and efficiency calculation systems.
- [Azure Automation](https://azure.microsoft.com/en-us/products/automation) includes process automation with Runbooks that allow you to implement complex logic using PowerShell code that can shape your application to improve efficiency. This service can also add business value by reducing errors and lowering your operational costs.
- [Power BI](/power-bi) allows you to turn your data into analytics and reports providing real-time insights into your business. Whether your data is cloud-based or on-premises, Azure and Power BI have the built-in integration and connectivity to bring your visualizations and analytics to life. 


### Alternatives

The Azure services used in this document can be replaced with similar services, and we encourage you to perform the calculation with the minimum impact to your infrastructure by using Azure services or tools that are already deployed within your environment to increase density and utilization on existing resources:

- Substitute Power BI dashboards with Azure Monitor Workbooks or Azure Managed Grafana services. 
- Application Insights can be swapped with any other Application Performance Management tool, for example Elasticsearch or Open APM.
- Data tables can be retained with any other system of records, such as MySQL or MariaDB. 
- If you have a running Azure Functions or Logic App space, consider launching the calculation regularly from your existing deployments.
- If the application resources are distributed across multiple resource groups, tags can be used to correlate cost data and calculate the amount of carbon emitted by the application. 



## Scenario details


Data sources
In general, the approach should be to build a proxy equation with few variables. The proxy metrics chosen should represent the application’s behavior and performance. 
These metrics are used in our example:

- The carbon emission of the infrastructure retrieved from Microsoft Emissions Impact Dashboard
- The cost of the infrastructure, measured in daily or monthly spend by resource group https://learn.microsoft.com/rest/api/cost-management/ 
- Performance and scale metrics of the application collected from Azure Application Insights: 
- The number of users (or API calls or server requests) that are concurrently connected the application
- CPU usage
- Memory usage
- Response time (send/receive)

Here you can find a tutorial on how to set up your Application Insights to get the required metrics: Application Insights SDK for ASP.NET Core applications - Azure Monitor | Microsoft Learn

You can add more variables to the equation, such as:

- Edge services and infrastructure carbon emissions
- Time when users connect, as electricity production and demand varies with time
- Any other peculiar metric of the app that can tell us how its performance is changing across time

Building this equation into a score that can also reflect the number of users, represents the closest approximation to a carbon score, and this will be your benchmark for any further change and improvement towards the greenness of the app.
Another consideration that we associate to application performance is cost. In most cases, we can show direct correlation of performance efficiency to cost and carbon savings. This allows us to make the assumptions that:

- When performance is higher, but costs are the same = we've optimized the app and have lowered carbon emissions
- When costs are lower, but performance is the same = we've optimized the app and have lowered carbon emissions
- When performance and costs are up = we haven't optimized the app and have increased carbon emissions
- When costs are up, but performance is lower or equal = we haven't optimized the app and have increased carbon emissions (or the energy cost is higher, which according to principles is also cause for higher carbon emissions)

This correlation between the Software Carbon Intensity score (SCI), cost, and performance of an application is unique for every application and will depend on many factors. Gathering data of these three variables will allow you to create an algorithm of correlation that will allow you to successfully forecast any variation of the three, and to make informed decisions on the application architecture and patterns.


Calculations
As mentioned, we're unable to form a discrete calculation for the proxies we're using. In this scenario, we need to process the data gathered from the Emissions Impact Dashboard as a starting point. The SCI baseline calculation is as follows:
SCI =C*R
Where:
 C is the carbon emissions for the application. This value will depend on how the application is deployed in Azure. For example, if all the application resources are in a single resource group, the carbon emissions for this resource group would be the C variable. 
Note: For the time being, we’ll not consider other sources of emissions for the application, as they strictly depend on the architecture and edge/user behavior – this can be the next step when using carbon proxies.
 R is the scaling factor for the application. This can be the number of average concurrent users, for the considered time window, or API requests, or web requests, etc.… This is important as we can have a score that will account the overall impact of the usage of the application, and not just its deployment footprint.
The time window is, of course, another important aspect of this calculation: carbon emissions for any energy consuming device or system will vary through time, since the energy grid may have renewable or alternate energy sources in specific moments but not in others (think, for example, about solar power). It is therefore important to start with the shortest possible timeframe (for example a daily or hourly calculation) to be as precise as possible.
The Emissions Impact Dashboard, at the time of writing, will provide monthly carbon information based on the services within a subscription. In order to have this number for a single resource group, this can be calculated with the following:
Carbon (res-group)=(Carbon(subscription)*Cost(res-group))/Cost(subscription)
You can then store the monthly carbon info for your resource group along with the rest of the data, as explained in the following section. 
Data storage
The carbon and carbon proxy information that you gathered in the previous section should be stored somewhere that you can run exports to dashboards or reports, so you can visualize your carbon score over time and make informed choices. For sustainable reasons, and in alignment with the best practices of the Well Architected Framework (see Data and storage design considerations for sustainable workloads on Azure - Microsoft Azure Well-Architected Framework | Microsoft Learn and Application platform considerations for sustainable workloads on Azure - Microsoft Azure Well-Architected Framework | Microsoft Learn) we recommend using the minimum viable system of record, for example, Azure Table Storage (https://learn.microsoft.com/en-us/azure/storage/tables/table-storage-quickstart-portal). 
A sample table describing the gathered data looks like the following:
Data from reports Data from APM Calculations
Date Resource-group name Carbon emissions from dashboard
C Cost  CPU Memory Response time ratio (send/receive) Scaling factor
R SCI
        
        

Data correlations
When we start gathering data on the carbon, performance, and cost of the application, we’ll have valuable information that will allow you to build a correlation algorithm that is specific to your application, and that will provide guidance when planning for cost, performance, and carbon optimization.
Note: reducing costs via discounts such as Azure reservations or cost savings plans will create discrepancies in your correlation algorithm when including cost in the equation.
See additional information on the choice of ML algorithm here: https://learn.microsoft.com/en-us/azure/machine-learning/how-to-select-algorithms 
Data display
Your data and calculations can be displayed several ways, such as through a customized Azure Monitor Workbook, or a simple Power BI dashboard.
For more info see: 
https://learn.microsoft.com/en-us/azure/azure-monitor/app/tutorial-app-dashboards 
https://learn.microsoft.com/en-us/power-bi/create-reports/service-dashboard-create 
What can your SCI score trigger?
One of the most frequent questions when approaching sustainability for cloud workloads is, “Once I know my score, how can I improve it?”
If you can score the application’s carbon impact with proxies, the next step is to focus on defining what actions can be triggered by unfavorable conditions in your carbon score. Some examples of these conditions are: 
 Energy production and demand is at an all-time high and is therefore very expensive to produce 
 Electricity is simply not available – this could be because of natural disaster or geopolitical conflict. 
 Sudden unavailability of edge infrastructure due to resource over-consumption or supply chain issues
Once you can identify the failure points that can impact your application, you can decide what actions you will take to make your application resilient to carbon spikes.
One action you can take is build an “eco-mode” version of your application. This should be a simpler, smaller, cheaper, greener version of the full application that offers minimal features for functional use, that you can revert to in case of carbon emission spikes. You may also simply train your end-users to opt for the eco version by choice, providing a “green button” where people declare they are ok with a leaner interface, less graphics, and limited features in exchange for reducing carbon emissions. 
If you opt to involve the users, this provides an opportunity to drive a cultural change along with the technical one:
 You can specify what the impact of this choice is: “by using the green version you are saving x amount of carbon”, or “bringing our carbon score to Y”
 You can understand the user behavior and modify the eco version to reflect their choices (maybe they use 10% of the features, and they are an ideal user of the green version)
 Slowly the full version gets optimized for emission as well and ideally, these versions are able to eventually converge.


## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Security


Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).


For additional security, you can use Virtual Network service endpoints to secure Azure service resources to only your virtual network. This fully removes public Internet access to those resources, allowing traffic only from your virtual network.
With this approach, you create a virtual network in Azure and then create private service endpoints for Azure services. Those services are then restricted to traffic from that virtual network. You can also reach them from your on-premises network through a gateway.
Be aware of the following limitations:
• To move data from on-premises into Azure Storage, you will need to allow public IP addresses from your on-premises or ExpressRoute. For details, see Securing Azure services to virtual networks.
For general guidance on designing secure solutions, see the Azure Security Documentation.


### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

This architecture can be deployed using several alternative Azure services but was kept intentionally at a minimum to save on cost and carbon emissions. 

While we encourage you to use any equivalent service you may already have in your application deployment, each architecture components’ pricing can be found at the following links:

- The Emissions Impact Dashboard and Azure Cost Management reports are free
- App Insights pricing
- Azure Table Storage pricing 
- Azure Logic Apps pricing 
- Azure Functions pricing  
- Azure Automation pricing 



> Link to the pricing calculator (https://azure.microsoft.com/en-us/pricing/calculator) with all of the components in the architecture included, even if they're a $0 or $1 usage.
> If it makes sense, include small/medium/large configurations. Describe what needs to be changed as you move to larger sizes.

### Performance efficiency

Performance efficiency is the ability of your workload to scale to meet the demands placed on it by users in an efficient manner. For more information, see [Performance efficiency pillar overview](/azure/architecture/framework/scalability/overview).

The primary purpose of this architecture is to provide a sustainability score for your application(s) with a minimal impact on cost and carbon itself. Most of the components are PaaS and serverless Azure services that can scale independently based on use and traffic.

In this scenario, the dashboard and storage interface are not intended for a massive usage and consultation so if you plan to provide it to a large number of users, you might want to consider either 
- decoupling the extracted data, by transforming it and storing it in a different system of record
or
- switching Azure Tables to a more scalable data structure alternative, such as Cosmos DB.
For more information on the principles of performance efficiency, please see Performance efficiency pillar overview - Microsoft Azure Well-Architected Framework | Microsoft Learn




## Contributors

> (Expected, but this section is optional if all the contributors would prefer to not be mentioned.)

> Start with the explanation text (same for every section), in italics. This makes it clear that Microsoft takes responsibility for the article (not the one contributor). Then include the "Principal authors" list and the "Other contributors" list, if there are additional contributors (all in plain text, not italics or bold). Link each contributor's name to the person's LinkedIn profile. After the name, place a pipe symbol ("|") with spaces, and then enter the person's title. We don't include the person's company, MVP status, or links to additional profiles (to minimize edits/updates). Implement this format:

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal authors:
Paola Annis |https://www.linkedin.com/in/paolaeva/ | Prin SVC Engineering Manager
Jennifer Wagman | https://www.linkedin.com/in/jcwagman/ | Service Engineer

Other contributor:
Chad Kittel | Principal SDE | https://www.linkedin.com/in/chadkittel/


Principal authors: > Only the primary authors. Listed alphabetically by last name. Use this format: Fname Lname. If the article gets rewritten, keep the original authors and add in the new one(s).

 - [Author 1 Name](http://linkedin.com/ProfileURL) | Title, such as "Cloud Solution Architect"
 - [Author 2 Name](http://linkedin.com/ProfileURL) | Title, such as "Cloud Solution Architect"
 - > Continue for each primary author (even if there are 10 of them).

Other contributors: > Include contributing (but not primary) authors, major editors (not minor edits), and technical reviewers. Listed alphabetically by last name. Use this format: Fname Lname. It's okay to add in newer contributors.

 - [Contributor 1 Name](http://linkedin.com/ProfileURL) | Title, such as "Cloud Solution Architect"
 - [Contributor 2 Name](http://linkedin.com/ProfileURL) | Title, such as "Cloud Solution Architect"
 - > Continue for each additional contributor (even if there are 10 of them).
 
*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

This work is aligned with the principles and methodology of the Green Software Foundation. The next step to building a greener application is to embed the carbon aware SDK into your application, so that triggers can be automated in real-time once specific carbon conditions are met.
See Green-Software-Foundation/carbon-aware-sdk: Carbon-Aware SDK (github.com)


## Related resources

Sustainability cloud workload guidance for the Well Architected Framework can be found here: https://learn.microsoft.com/en-us/azure/architecture/framework/sustainability

