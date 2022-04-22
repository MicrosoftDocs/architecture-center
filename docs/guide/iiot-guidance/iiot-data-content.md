This article discusses how to analyze and visualize data from an [Azure industrial IoT (IIoT) analytics](./iiot-architecture.yml) solution. There are several ways to analyze data by using visualizations and dashboards. You can use these tools to analyze solution effectiveness, gain insights, and explore trends. The insights you gain from exploring raw data can help build Azure Stream Analytics jobs to look for conditions or do calculations, or Azure Logic Apps to take actions.

There are several options for visualizing your industrial data. Your IIoT analytics solution might use some or all of these options, depending on how you need to use the data.

- Do ad-hoc analytics and trend visualizations with [Azure Data Explorer dashboards (Preview)](https://azure.microsoft.com/services/data-explorer). 
- Use Power BI to develop visualization dashboards. Connect to your Azure IIoT data by using the [Azure Data Explorer connector for Power BI connector](/azure/data-explorer/power-bi-connector). Use Power BI to combine external data from your ERP, EAM, or other line-of-business systems with your IIoT data.
- For advanced visualizations, such as schematic views and process graphics, create a custom web application.
- You can use several [Microsoft and GitHub tools](https://visualstudio.microsoft.com/vs/features/notebooks-at-microsoft) to work with open-source data analysis and visualization tools like Python, Jupyter Notebooks, and [Matplotlib](https://matplotlib.org).

## Azure Data Explorer

Azure Data Explorer is a fast and highly scalable data exploration service for log and telemetry data. Azure Data Explorer is ideally suited to explore, analyze and visualize raw data coming from industrial systems.

Azure Data Explorer provides a web application, the [Web UI](/azure/data-explorer/web-query-data), where you can run queries and build dashboards. Azure Data Explorer is also integrated with other dashboard services like Power BI.

[![Diagram showing IIoT warm and cold data architecture.](./images/warm-cold-data.png)](./images/warm-cold-data.png#lightbox)

## Power BI

For some uses, dashboards containing factory or plant KPIs and visualizations are more valuable than viewing the raw data. For these uses, [Power BI](https://powerbi.microsoft.com/) is an ideal visualization solution. You can [connect Power BI](/azure/data-explorer/power-bi-connector) to your industrial data stored in Azure Data Explorer. Power BI provides powerful reporting and dashboard capabilities, and lets you share insights and results across your organization. Power BI has desktop, web, and mobile interfaces.

By connecting your data to Power BI, you can:

- Perform correlations with other data sources supported by Power BI, and access a host of different data visualization options.
- Create Power BI dashboards and reports using your Azure Data Explorer data, and share them with your organization.
- Unlock data interoperability scenarios in a simple, easy-to-use manner, and get to insights faster than ever.
- Modify Azure Data Explorer data within Power BI by using the powerful Advanced Editor.

## Custom web application

For advanced visualizations, such as schematic views or process graphics, you can create a custom web application. A custom web application can give you a single pane of glass (SPOG) user experience and other advanced capabilities. You can create applications like:

- A simplified and integrated authoring experience for Stream Analytics jobs and Azure Logic Apps.
- Process or custom visuals that display real-time data.
- Embedded Power BI dashboards that display KPIs and external data.
- Visual alert display using SignalR.
- An administrative application for adding or removing solution users.

You can create a single-page application (SPA) by using:

- JavaScript, HTML5, and CSS3.
- [MSAL.js](/graph/toolkit/providers/msal) to sign in users and get tokens to use with the Microsoft Graph.
- [Azure App Services Web Apps](https://azure.microsoft.com/services/app-service/web) to host the web application.
- [Power BI embedded analytics](/power-bi/developer/embedded/embedded-analytics-power-bi) to embed your Power BI content such as reports and dashboards in the web application.
- [Azure Maps](/azure/azure-maps) to render map visualizations.
- [Microsoft Graph SDK for JavaScript](https://developer.microsoft.com/graph/blogs/microsoft-graph-sdk-for-javascript-2-0-0) to integrate with Microsoft 365.

## Notebooks

[Jupyter Notebook](https://jupyter.org) is an open-source web application for creating and sharing documents that contain live code, equations, visualizations, persistent data, and narrative text. Usage includes data cleaning and transformation, numerical simulation, statistical modeling, data visualization, and machine learning. Jupyter Notebook supports data sources including Azure Data Explorer, Azure Monitor logs, and Application Insights.

For more information, see [Use a Jupyter Notebook and kqlmagic extension to analyze data in Azure Data Explorer](/azure/data-explorer/kqlmagic).

## Next steps

> [!div class="nextstepaction"]
> [Considerations for an Azure Industrial IoT (IIoT) analytics solution](iiot-considerations.md)

 or in a website.Power BI to [embed Power BI dashboards](/power-bi/collaborate-share/service-embed-secure) directly in the web app
