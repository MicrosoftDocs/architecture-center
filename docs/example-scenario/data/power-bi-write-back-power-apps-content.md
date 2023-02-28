This solution implements a Power Apps canvas app via the native Power Apps visual in Power BI. Power Automate provides background automation for bulk-processing and refreshing.

## Architecture

:::image type="content" border="false" source="media/power-platform-write-backs.png" alt-text="Diagram that shows an architecture for Power BI data write-back." lightbox="media/power-platform-write-backs.png"::: 

*Download a [Visio file](https://arch-center.azureedge.net/power-platform-write-backs.vsdx) of this architecture.*

### Dataflow

Core components of this solution incorporate the ability to pass pre-filtered data from Power BI into a Power Apps and/or Power Automate funnel for any updates in a supporting back end. It's important to refresh the Power BI data set (or dataflow) to ensure updates are visible to all users. 

#### Deployment

(For more information, see [Deploy this scenario](#deploy-this-scenario) later in this article.)

A. Deploy Dataverse and a supporting model-driven app with relevant custom tables. 

B. Import all back-end tables and views into a Power BI data set (PBIX). 

C. Initiate the integration between Power BI and Power Apps via the Power Apps visualization in the desktop application. 

D. Use Power Apps to create a canvas app to provide the ability to interact with and update all necessary data. 

#### Process flow

1. **Gather data.** Cross filter a selected row or set of data by selecting part of a visualization in a Power BI report. This interaction passes the necessary underlying data from the Power BI report interface into the embedded canvas app.
1. **Update data or insert it into Dataverse by using the UI of the canvas app.** You can do that by using bound controls like forms and galleries that are native to Power Apps and that are directly tied to back-end data. Alternatively, you can implement more customized functionality by using unbound controls. These controls require additional Power Fx code. For single-update scenarios, you can code the app to directly commit data to the back end via **SubmitForm**, **Patch**, and  **UpdateIf** functions. For bulk-update scenarios, you can establish a collection (a virtual table) by using the **Collect** function. You can then pass the collection to process all data updates at once. See [Power App UI](#power-app-ui) for screenshots of the canvas app. 
1. **Push updates to the source.** A Power Automate flow provides background automation as required by the scenario. For single-update scenarios where only one row from the selected table is updated, a simple flow runs to refresh the PBIX data set. This ensures that the updated data is reflected in the Dataverse back end and in the reporting layer. For bulk-update scenarios, a more complex flow runs. It consumes a JSON collection of nested objects that's passed from the Power Apps collection described in the previous step. The flow then iterates through each nested object, individually updating data in Dataverse as needed. After the update step completes, the flow refreshes the PBIX. If the Power BI report uses DirectQuery, the automated steps associated with refreshing the PBIX aren't needed.  
1. **Visualize updates.** All data is updated and refreshed. The end user refreshes the browser window to see the update. 

### Components

- [Dataverse.](https://powerplatform.microsoft.com/dataverse) A back-end database solution that you can use to store data in a highly secure, customizable, scalable environment. This environment seamlessly connects to Dynamics 365, Azure, Visual Studio, and Power Query. Dataverse provides efficient data processing and an open-source shared data model that provides semantic consistency.       
- [Power BI.](https://powerbi.microsoft.com) A collection of software services, apps, and connectors that work together to turn your unrelated sources of data into coherent, visually immersive, interactive insights. 
   - You can also implement data write-back directly into [Power Query dataflows](/connectors/dataflows).
- [Power Apps.](https://powerapps.microsoft.com) A suite of apps, services, and connectors, all available on a comprehensive data platform. You can use this service to quickly create applications to meet custom business needs. In this solution, Power Apps is used for data updates and inserts in an intuitive UI. It also functions as a trigger for automation.
- [Power Automate.](https://us.flow.microsoft.com) A service that you can use to create automated workflows between a variety of connected apps and outside services. You can configure it to transfer data, send notifications, collect artifacts, and more. In this solution, Power Automate is used for bulk-processing of updated data and for data refresh in the PBIX and/or Dataflow layer to push updated data back into a Power BI report. 

### Alternatives

- Alternatives to Dataverse include the following solutions:
   - [Azure SQL Database](https://azure.microsoft.com/products/azure-sql/database)
   - [Azure Synapse Analytics](https://azure.microsoft.com/services/synapse-analytics)
   - [SQL Server](https://www.microsoft.com/sql-server/sql-server-2022)
   - [Salesforce](https://www.salesforce.com)
   - [SharePoint](https://www.microsoft.com/microsoft-365/sharepoint/collaboration)
- You can use [Power Query dataflows](/connectors/dataflows) separately or together with Power BI data sets for this solution, depending on the scale and efficiency of data in your environment. If you use dataflows in your solution, you need to manage your Power Automate extension to refresh each dataflow or data set accordingly.  
- You can build custom applications by using JavaScript, HTML, C#, or other languages that can be embedded into a Power BI report to update selected data. These apps, however, need to be implemented differently in the Power BI report layer because there's no native visualization as there is for Power Apps. If you implement scalability for these apps, you need to monitor it. For information on how to best implement custom components in Power BI, see the [Power BI Developer Center](https://powerbi.microsoft.com/developers).
- You can also use the [Power Automate visual for Power BI](/power-bi/create-reports/power-bi-automate-visual) for write-back scenarios. This visual is optimized for handling large sets of data, and Power Apps handles delegation. You can use the Power Automate and Power Apps visuals together to provide scalable efficiency. If you use the Power Automate visual, data update occurs in the background without the presence of a displayed UI. 

## Scenario details

This solution for data write-back functionality in Power BI provides an interactive and efficient way to change data directly from Power BI. Power BI doesn't currently have a native solution that you can use for inline or bulk updates of data while you're interacting with a report or dashboard. To push changes to data, you need to make updates directly in your data stores and then, if you're not using DirectQuery, refresh a data set to complete the process flow. This process can be inefficient and can pose problems for users who don't have access to a specific back end or the underlying data.

### Potential use cases

This architecture is highly iterative. You can use it with several different back-end data stores and adapt it to various use cases. Practical uses for this architecture include:
- **Inline editing.** The solution can be used for data that needs to be updated on the fly without provisioned access to a back-end database.
- **Approval workflows.** Extending the capabilities of Power BI with Power Apps and Power Automate allows end users to collect data that requires review directly from a dashboard and send it to subsequent approvers. 
- **Data-driven alerts.** The solution can provide customization to automated notifications about specific insights via submission of records or the passing of data packets into a Power Automate flow. 

### Power App UI 

The following screenshots illustrate the process for passing data from Power BI to the underlying database. 

This is the home screen for the canvas app: 

:::image type="content" border="false" source="media/home-screen.png" alt-text="Screenshot that shows the home screen for the canvas app." lightbox="media/home-screen.png"::: 

This screenshot shows the process for a single update:

:::image type="content" border="false" source="media/single-update.png" alt-text="Screenshot that shows the process for a single update." lightbox="media/single-update.png"::: 

This screenshot shows the process for a bulk update: 

:::image type="content" border="false" source="media/bulk-update.png" alt-text="Screenshot that shows the process for a bulk update." lightbox="media/bulk-update.png"::: 

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Scalability

To correctly establish the integration between Power BI and the canvas app for write-back support, you need to set it up by creating the canvas app directly from the Power Apps visualization on the Power BI report. If this integration isn't set up correctly, there will be no way to pass cross-filtered data from the Power BI report layer to the Power Apps UI.

You need to address [delegation](/powerapps/maker/canvas-apps/delegation-overview) when you consider scalability. Delegation is a concept that's unique to Power Apps (canvas apps) that limits the scope of data processing through the cloud while an app's logic is running. Canvas apps implemented in this solution need to be provisioned properly to handle large sets of data that use loops or complex filter statements to ensure that all data is covered when you run an update to the back-end database and then the Power BI data set. You can use Power Automate in this scenario to increase efficiency when you handle large-scale bulk updates of more than 2,000 rows.

### Availability

All the components outlined in this architecture are managed services that automatically scale depending on regional availability. Currently, Power Apps is available in six core regions and 42 languages. For more information, see [availability of services](https://azure.microsoft.com/global-infrastructure/services/?products=all&regions=all). 

[Dataverse](/powerapps/maker/data-platform/why-dataverse-overview) is designed to meet enterprise-level scalability needs by using service-protection limits to mitigate malicious behavior that might disrupt service.

For information about SLAs, see [Service-level agreements](https://azure.microsoft.com/support/legal/sla). 

### Security

[Row-level security (RLS)](/power-bi/enterprise/service-admin-rls) is the best way to restrict data access for individual users or groups in Power BI.  RLS models persist in this solution. If a user's permissions in Power BI are set to view only a subset of the overall data model, only that subset can be passed to the Power Apps layer. However, you need to configure the Power Apps layer so that end users are able to access only certain data.

You configure data security for Power Apps by using [role-based security](/power-platform/admin/wp-security-cds) in the Dataverse back end. You can apply roles to teams, groups, or individual users to specify which records are available for manipulation in this solution. This functionality enables you to use a single canvas app for users who have different levels of access to the back end. To ensure consistency across the solution, be sure the role-based security configurations match the permissions outlined in the Power BI row-level security model for each team, group, or user. 

For more information on how to implement a well-architected framework, see the [Microsoft security pillar](/azure/architecture/framework/security/overview).

### Cost optimization

Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies. For more information, see [Overview of the cost optimization pillar](/azure/architecture/framework/cost/overview).

[Power Apps](https://powerapps.microsoft.com/pricing) and [Power Automate](https://powerautomate.microsoft.com/pricing) are software as a service (SaaS) applications that have flexible pricing models. You can license Power Apps with per-app or per-user plans that fit your business needs. Similarly, you can license Power Automate with either per-user or per-flow (single automation) plans. 

Several versions of [Power BI](https://powerbi.microsoft.com/pricing) are available. Your choice depends on the volume of data ingested. For Power BI Pro, only a per-user plan is available. Power BI Premium provides per-user and per-capacity plans. 

## Deploy this scenario

You need to have the relevant Power Platform licenses to run this solution in production. Administrators or customizers of the solution also need the proper security roles to enable access to Power Apps and Power Automate. If you don't yet have access to these licenses or roles, you can use the [Power Apps Developer Plan](https://powerapps.microsoft.com/developerplan) to start development in the meantime. 

To deploy this solution:
1. Create a PBIX file in Power BI Desktop as the base component of your reporting layer. Import all necessary data from Dataverse or whichever back end you're using. 
1. Add the Power Apps visual for Power BI directly from the **Visualization** pane. Creating an app directly from the Power Apps visual for Power BI is the only way to implement integration between Power BI and Power Apps. 
1. After you implement the integration, you need to develop, design, and code the canvas app to perform the business processes you want to streamline. 
1. If bulk processing is required, a developer needs to create a Power Automate flow to handle the consumption of data from Power Apps and its propagation to Dataverse. You can configure this flow to provide any notifications or approval workflows that you want to incorporate in the automation.
1. When the app is complete, you need to incorporate it into the Power BI report. You can do this directly in the Power BI report screen or by configuring a drillthrough page. 

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal authors:
- [Tom Berzok](https://www.linkedin.com/in/thomas-berzok) | Consultant, Data & Analytics at [Slalom](https://www.slalom.com)
- [Thomas Edmondson](https://www.linkedin.com/in/thomas-edmondson-7a2b9a2) | Principal at [Slalom](https://www.slalom.com)

Other contributor:
- [Mick Alberts](https://www.linkedin.com/in/mick-alberts-a24a1414) | Technical Writer

*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

Product documentation:
- [Power Apps visual for Power BI](/powerapps/maker/canvas-apps/powerapps-custom-visual)
- [Overview of creating apps in Power Apps](/powerapps/maker/canvas-apps/powerapps-custom-visual)
- [Embed a Power Apps visual in a Power BI report](/power-bi/visuals/power-bi-visualization-powerapp)
- [Use a flow to update a row in Dataverse](/power-automate/dataverse/update)

Microsoft Learn Training modules:
- [Create tables in Dataverse](/training/modules/get-started-with-powerapps-common-data-service)
- [Get started with Power Apps canvas apps](/training/modules/get-started-with-powerapps)
- [Manage solutions in Power Apps and Power Automate](/training/modules/manage-solutions-power-automate)

## Related resources

- [Advanced analytics architecture](../../solution-ideas/articles/advanced-analytics-on-big-data.yml)
- [Extract text from objects using Power Automate and AI Builder](../../example-scenario/ai/extract-object-text.yml)
- [Custom business processes](../../solution-ideas/articles/custom-business-processes.yml)
- [Data governance with Profisee and Azure Purview](../../reference-architectures/data/profisee-master-data-management-purview.yml)
