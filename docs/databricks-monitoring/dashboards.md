---
title: Performance monitoring and troubleshooting for Azure Databricks using Azure Monitor
titleSuffix: 
description: How to monitor and troubleshoot performance issues in Azure Databricks using a library that deploys Azure Monitor and Grafana Dashboards for monitoring and troubleshooting performance in Azure Databricks
author: petertaylor9999
ms.date: 02/28/2019
ms.topic:
ms.service:
ms.subservice:
---

# Use dashboards to visualize Azure Databricks metrics

[Azure Databricks](/azure/azure-databricks/) is a fast, powerful, and collaborative [Apache Spark](https://spark.apache.org/)–based analytics service that makes it easy to rapidly develop and deploy big data analytics and artificial intelligence (AI) solutions. Monitoring and troubleshooting performance issues is a critical component of operating your production Azure Databricks workloads, and the first step in the process is to gather metrics into a workspace for analysis. In Azure, the best solution for managing log data is [Azure Monitor](/azure/azure-monitor/). Azure Databricks does not natively support sending log data to Azure monitor, but a [library for this functionality](https://github.com/mspnp/spark-monitoring) is available in [Github](https://github.com).

This library enables logging of Azure Databricks service metrics as well as Apache Spark structure streaming query event metrics. Once you've successfully deployed this library to an Azure Databricks cluster, you can further deploy a set of [Azure Monitor](/azure/azure-monitor/) or [Grafana](https://granfana.com) dashboards that you can deploy as part of your production environment. This document includes a discussion of the common types of performance issues and how to identify them using these dashboards.

## Deploy dashboards

There are two sets of artifacts in the Github respository, one for an Azure Log Analytics dashboard and another for a Grafana dashboard. Before you begin, clone the [Github repository](https://github.com/mspnp/spark-monitoring) and [follow the deployment instructions](databricks-monitoring.md) to build and configure the Azure Monitor logging for Azure Databricks library to send logs to your Azure Log Analytics workspace.

### Deploy the Azure Log Analytics workspace

To deploy an Azure Log Analytics workspace with dashboards, follow these steps:

1. Navigate to the `/perftools/deployment/loganalytics` directory.
1. Deploy the **logAnalyticsDeploy.json** Azure Resource Manager template. The template has the following parameters:

    * **location**: The region where the Log Analytics workspace and dashboards are deployed.
    * **serviceTier**: Rhe workspace pricing tier. See [here][sku] for a list of valid values.
    * **dataRetention** (optional): The number of days log data is retained in the Log Analytics workspace. The default value is 30 days. If the pricing tier is `Free`, the data retention must be 7 days.
    * **workspaceName** (optional): A name for the workspace. If not specified, the template generates a name.

    ```azurecli
    az group deployment create --resource-group <resource-group-name> --template-file logAnalyticsDeploy.json --parameters location='East US' serviceTier='Standalone'
    ```

For more information about deploying Resource Manager templates, see [Deploy resources with Resource Manager templates and Azure CLI][rm-cli].

### Deploy the Grafana dashboard

Grafana is an open source project you can deploy to visualize the time series metrics stored in your Azure Log Analytics workspace using the Grafana plugin for Azure Monitor. Grafana executes on a virtual machine (VM) and requires a storage account, virtual network, and other resources. To deploy a virtual machine with the bitnami certified Grafana image and associated resources, follow these steps:

1. Navigate to the `/spark-monitoring/perftools/deployment/grafana` directory in the local location of the **spark-monitoring** Github respository.
2. Deploy the **logAnalyticsDeploy.json** [Azure Resource Manager](/azure/azure-resource-manager/resource-group-overview) [template](/azure/azure-resource-manager/resource-group-authoring-templates). You can deploy this template using the [Azure portal](/azure/azure-resource-manager/resource-group-authoring-templates), the [Azure CLI](/azure/azure-resource-manager/resource-group-template-deploy-portal), [PowerShell](/azure/azure-resource-manager/resource-group-template-deploy-portal), or using the [Resource Manager REST API](/azure/azure-resource-manager/resource-group-template-deploy-rest).
3. The template includes a set of parameters, and most have a default value that you can use unles you have a reason to change. However, there are three You must set the following parameters when you deploy the template:

    * **adminPass**: the password for the host operating system of the virtual machine.  
    * **dataSource**: Github URL for the bash script to install Grafana. The URL is: `https://raw.githubusercontent.com/mspnp/spark-monitoring/master/perftools/deployment/grafana/AzureDataSource.sh`

4. Once the deployment is complete, the bitnami image of Grafana is installed on the virtual machine. As part of the setup process, the Grafana installation script output a temporary password for the **admin** user. You require this temporary password to login. To obtain the temporary password, follow these steps:  

    1. Log in to the Azure portal.  
    2. Select the resource group where the resources were deployed.
    3. Select the virtual machine where Grafana was installed. If you used the default parameter name in the deployment template, the virtual machine name is prefaced with **sparkmonitoring-vm-grafana**. 
    4. In the **Support + troubleshooting** section, click on **Boot diagnostics** to open the boot diagnostics page.
    5. Click on **serial log** on the boot diagnostics page.
    6. Search for the following string: "Setting Bitnami application password to". 
    7. Copy the password to a safe location.

5. Next, change the Grafana administrator password by following these steps:

    1. In the Azure portal, select the public IP address associated with the virtual machine where Grafana is installed. If you used the default parameter name in the deployment template, the virtual machine name is prefaced with **grafanavm-ip**. Make note of the IP address.
    2. Open a web browser and open the URL **http://<IP addresss from step 1>:3000**.
    3. At the Grafana log in screen, enter **admin** for the user name, and use the Grafana password from above.
    4. Once logged in, select **Configuration**.
    5. Then select **Server Admin**.
    6. On the **Users** tab, select the **admin** login:
    7. Enter a new password in the **New password** text box, and click the **update** button.

6. Grafana requires an [Azure Service Principal](/azure/active-directory/develop/app-objects-and-service-principals) to manage access to your Azure Log Analytics workspace. Follow the instuctions to [create an Azure service principal with Azure CLI](https://docs.microsoft.com/cli/azure/create-an-azure-service-principal-azure-cli?view=azure-cli-latest). The **--role** of the Service Principal must be **Log Analytics Reader**. When the Service Principal is created, make note of the application ID, password, and tenant ID returned.
7. Next, create the Azure Monitor datasource in Grafana by following these steps:

    1. At the Grafana **Home Dashboard**, select **Configuration**.
    2. Select **Data Sources**.
    3. On the **Configuration** page, select **Add data source** in the **Data Sources** pane.
    4. Select **Azure Monitor** on the **Choose data source type** page.
    5. In the **Settings** section, enter a name for the data source in the **Name** textbox.
    6. In the **Azure Monitor API Details** section, enter your subscription ID and tenant ID the text box for each.
    7. Enter the application ID from the previous step in the **Client ID** text box.
    8. Enter the password from the previous step in the **Client Secret** text box.
    9. In the **Azure Log Analytics API Details** section, check the **Same Details as Azure Monitor API** checkbox.
    10. Click on the **Save & Test** button.
    11. When the Log Analytics data source is correctly configured, a success message is displayed.

8. Create the dashboards in Grafana by following these steps:

    1. Navigate to the `/spark-monitoring/perftools/dashboards/grafana` directory in the local location of the **spark-monitoring** Github respository.
    1. Create the **sparkMonitoringDash.json** file that describes the Grafana dashboard by executing the **DashGen.sh** script as follows:

        ```bash
        export WORKSPACE=<your Azure Log Analytics workspace ID>
        export LOGTYPE=SparkListenerEvent_CL

        sh DashGen.sh
        ```

    1. Return to the Grafana **Home Dashboard** and select the **Create** icon.
    1. Select **Import**.
    1. On the **Import** page, click on the **Upload .json File** button.
    1. Select the **sparkMonitoringDash.json** file created in step 1 and click okay.
    1. In the options section, select the Azure Monitor data source created earlier.
    1. Click the **Import** button.

## Visualizations in the dashboards

Both the Azure Log Analytics and Grafana dashboards include a set of time-series visualizations. Each graph is time-series plot of metric data related to an Apache Spark [job](https://spark.apache.org/docs/latest/job-scheduling.html), stages of the job, and tasks that make up each stage.

The visualizations are as follows:

### Job latency

This visualization shows execution latency for a job, which is a coarse view on the overall peformance of a job. Displays the job execution duration from start to completion. Note that the job start time is not the same as the job submission time. Latency is represented as percentiles (10%, 30%, 50%, 90%) of job execution indexed by cluster ID and application ID.

### Stage latency

The visualization shows the latency of each stage per cluster, per application, and per individual stage. This visualization is useful for identifying a particular stage that is running slowly.

### Task latency

This visualization shows task execution latency. Latency is represented as a percentile of task execution per cluster, stage name, and application.

### Sum Task Execution per host

This visualization shows the sum of task execution latency per host running on a cluster. Viewing task execution latency per host identifies hosts that have much higher overall task latency than other hosts. This may mean that tasks have been inefficiently or unevenly distributed to hosts.

### Task metrics

This visualization shows a set of the execution metrics for a given task's execution. These metrics include the size and duration of a data shuffle, duration of serialization and deserialization operations, and others. For the full set of metrics, view the Log Analytics query for the panel. This visualization is useful for understanding the operations that make up a task and identifying resource consumption of each operation. Spikes in the graph represent costly operations that should be investigated.

### Cluster throughput

This visualization is a high level view of work items indexed by cluster and application to represent the amount of work done per cluster and application. It shows the number of jobs, tasks, and stages completed per cluster, application, and stage in one minute increments. 

### Streaming Throughput/Latency

This visualzation is related to the metrics associated with a structured streaming query. The graphs shows the number of input rows per second and the number of rows processed per second. The streaming metrics are also represented per application. These metrics are sent when the OnQueryProgress event is generated as the structured streaming query is processed and the visualization represents streaming latency as the amount of time, in milliseconds, taken to execute a query batch.

### Resource consumption per executor

Next is a set of visualizations for the dashboard show the particular type of resource and how it is consumed per executor on each cluster. These visualizations help identify outliers in resource consumption per executor. For example, if the work allocation for a particular executor is skewed, resource consumption will be elevated in relation to other executors running on the cluster. This can be identified by spikes in the resource consumption for an executor.

### Executor compute time metrics

Next is a set of visualizations for the dashboard that show the ratio of executor serialize time, deserialize time, CPU time, and Java virtual machine time to overall executor compute time. This demonstrates visually how much each of these four metrics are contributing to overall executor processing.

### Shuffle metrics

The final set of visualizations show the data shuffle metrics associated with a structured streaming query across all executors. These include shuffle bytes read, shuffle bytes written, shuffle memory, and disk usage in queries where the file system is used.

## Next steps

Learn more about the diagnosis and troubleshooting of common Azure Databricks [performance patterns](./performance-troubleshooting.md) that can be identified using these visualizations.

<!-- links -->

[rm-cli]: /azure/azure-resource-manager/resource-group-template-deploy-cli
[sku]: https://docs.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2015-11-01-preview/workspaces#sku-object