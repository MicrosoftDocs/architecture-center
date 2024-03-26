---
title: condition monitoring, OEE calculation, forecasting and anomaly detection for Industrial IoT
titleSuffix: Azure Reference Architectures
description: See example Azure IoT architectures for condition monitoring, OEE calculation, forecasting and anomaly detection.
author: erichb
manager: kamv
ms.service: architecture-center
ms.subservice: reference-architecture
ms.topic: reference-architecture
ms.date: 3/25/2024
ms.author: erichb
ms.custom:
  - internal-intro
categories:
  - iot
products:
  - azure-iot-operations
  - azure-event-hubs
  - azure-data-explorer
---
 
## IEC 62541 Open Platform Communications Unified Architecture (OPC UA)

This solution leverages IEC 62541 Open Platform Communications Unified Architecture (OPC UA) for all Operational Technology (OT) data. This standard is described [here](https://opcfoundation.org). 


## Reference Solution Architecture

:::image type="content" source="../media/architecture-iiot-simple.png" alt-text="Simple IIoT architecture." lightbox="../media/architecture-iiot-simple.png" border="false" :::


Detailed architecture:

:::image type="content" source="../media/architecture-iiot.png" alt-text="IIoT architecture." lightbox="../media/architecture-iiot.png" border="false" :::

Here are the components involved in this solution:

| Component | Description |
| --- | --- |
| Industrial Assets | A set of simulated OPC-UA enabled production lines hosted in Docker containers |
| [Azure IoT Operations](https://learn.microsoft.com/en-us/azure/iot-operations/get-started/overview-iot-operations) | Azure IoT Operations is a unified data plane for the edge. It's composed of a set of modular, scalable, and highly available data services that run on Azure Arc-enabled edge Kubernetes clusters. |
| [Data Gateway](https://learn.microsoft.com/en-us/azure/logic-apps/logic-apps-gateway-install#how-the-gateway-works) | This gateway connects your on-premises data sources (like SAP) to Azure Logic Apps in the cloud. |
| [AKS Edge Essentials](https://learn.microsoft.com/en-us/azure/aks/hybrid/aks-edge-overview) | This Kubernetes implementation (both K3S and K8S are supported) runs at the Edge and provides single- and multi-node Kubernetes clusters for a fault-tolerant Edge configuration on embedded or PC-class hardware, like an industrial gateway. |
| [Azure Event Hubs](https://learn.microsoft.com/en-us/azure/event-hubs/event-hubs-about) | The cloud message broker that receives OPC UA PubSub messages from edge gateways and stores them until they're retrieved by subscribers like the UA Cloud Twin. |
| [Azure Data Explorer](https://learn.microsoft.com/en-us/azure/synapse-analytics/data-explorer/data-explorer-overview) | The time series database and front-end dashboard service for advanced cloud analytics, including built-in anomaly detection and predictions. |
| [Azure Logic Apps](https://learn.microsoft.com/en-us/azure/logic-apps/logic-apps-overview) | Azure Logic Apps is a cloud platform you can use to create and run automated workflows with little to no code. |
| [Azure Arc](https://learn.microsoft.com/en-us/azure/azure-arc/kubernetes/overview) | This cloud service is used to manage the on-premises Kubernetes cluster at the edge. New workloads can be deployed via Flux. |
| [Azure Storage](https://learn.microsoft.com/en-us/azure/storage/common/storage-introduction) | This cloud service is used to manage the OPC UA certificate store and settings of the Edge Kubernetes workloads. |
| [Microsoft Sustainability Manager](https://learn.microsoft.com/en-us/industry/sustainability/sustainability-manager-overview) | Microsoft Sustainability Manager is an extensible solution that unifies data intelligence and provides comprehensive, integrated, and automated sustainability management for organizations at any stage of their sustainability journey. It automates manual processes, enabling organizations to more efficiently record, report, and reduce their emissions. |
| [Azure Managed Grafana](https://learn.microsoft.com/en-us/azure/managed-grafana/overview) | Azure Managed Grafana is a data visualization platform built on top of the Grafana software by Grafana Labs. It's built as a fully managed Azure service operated and supported by Microsoft. |
| [Microsoft Power BI](https://learn.microsoft.com/en-us/power-bi/fundamentals/power-bi-overview) | Microsoft Power BI is a collection of SaaS software services, apps, and connectors that work together to turn your unrelated sources of data into coherent, visually immersive, and interactive insights. |
| [Microsoft Dynamics 365 Field Service](https://learn.microsoft.com/en-us/dynamics365/field-service/overview) | Microsoft Dynamics 365 Field Service is a turnkey SaaS solution for managing field service requests. |
| [UA Cloud Commander](https://github.com/opcfoundation/ua-cloudcommander) | This open-source reference application converts messages sent to an MQTT or Kafka broker (possibly in the cloud) into OPC UA Client/Server requests for a connected OPC UA server. It's hosted in a Docker container. |
| [UA Cloud Action](https://github.com/opcfoundation/UA-CloudAction) | This open-source reference cloud application queries the Azure Data Explorer for a specific data value (the pressure in one of the simulated production line machines) and calls UA Cloud Commander via Azure Event Hubs when a certain threshold is reached (4000 mbar). UA Cloud Commander then calls the OpenPressureReliefValve method on the machine via OPC UA. |
| [UA Cloud Library](https://github.com/opcfoundation/UA-CloudLibrary) | The UA Cloud Library is an online store of OPC UA Information Models, hosted by the OPC Foundation [here](https://uacloudlibrary.opcfoundation.org/). |
| [UA Edge Translator](https://github.com/opcfoundation/ua-edgetranslator) | This open-source industrial connectivity reference application translates from proprietary asset interfaces to OPC UA leveraging W3C Web of Things (WoT) Thing Descriptions as the schema to describe the industrial asset interface. |

:exclamation: In a real-world deployment, something as critical as opening a pressure relief valve would of course be done on-premises and this is just a simple example of how to achieve the digital feedback loop.


## A Cloud-based OPC UA Certificate Store and Persisted Storage

When running OPC UA applications, their OPC UA configuration files, keys and certificates must be persisted. While Kubernetes has the ability to persist these files in volumes, a safer place for them is the cloud, especially on single-node clusters where the volume would be lost when the node fails. This is why the OPC UA applications used in this solution (i.e. the UA Cloud Publisher, the MES and the simulated machines/production line stations) store their configuration files, keys and certificates in the cloud. This also has the advantage of providing a single location for mutually trusted certificates for all OPC UA applications.


## UA Cloud Library

You can read OPC UA Information Models directly from Azure Data Explorer (also used in this reference solution) and import the OPC UA nodes defined in the OPC UA Information Model into a table for lookup of additional metadata within queries. 

First, configure an Azure Data Explorer callout policy for the UA Cloud Library by running the following query on your ADX cluster (make sure you are an ADX cluster administrator, configurable under Permissions in the ADX tab in the Azure Portal):

        .alter cluster policy callout @'[{"CalloutType": "webapi","CalloutUriRegex": "uacloudlibrary.opcfoundation.org","CanCall": true}]'

Then, simply run the following Azure Data Explorer query from the Azure Portal:

        let uri='https://uacloudlibrary.opcfoundation.org/infomodel/download/<insert information model identifier from the UA Cloud Library here>';
        let headers=dynamic({'accept':'text/plain'});
        let options=dynamic({'Authorization':'Basic <insert your cloud library credentials hash here>'});
        evaluate http_request(uri, headers, options)
        | project title = tostring(ResponseBody.['title']), contributor = tostring(ResponseBody.contributor.name), nodeset = parse_xml(tostring(ResponseBody.nodeset.nodesetXml))
        | mv-expand UAVariable=nodeset.UANodeSet.UAVariable
        | project-away nodeset
        | extend NodeId = UAVariable.['@NodeId'], DisplayName = tostring(UAVariable.DisplayName.['#text']), BrowseName = tostring(UAVariable.['@BrowseName']), DataType = tostring(UAVariable.['@DataType'])
        | project-away UAVariable
        | take 10000

You need to provide two things in the query above:

1. The Information Model's unique ID from the UA Cloud Library and enter it into the <insert information model identifier from cloud library here> field of the ADX query.
1. Your UA Cloud Library credentials (generated during registration) basic authorization header hash and insert it into the <insert your cloud library credentials hash here> field of the ADX query. Use tools like https://www.debugbear.com/basic-auth-header-generator to generate this.

For example, to render the production line simulation Station OPC UA Server's Information Model in the Kusto Explorer tool available for download [here](https://learn.microsoft.com/en-us/azure/data-explorer/kusto/tools/kusto-explorer), run the following query:

    let uri='https://uacloudlibrary.opcfoundation.org/infomodel/download/1627266626';
    let headers=dynamic({'accept':'text/plain'});
    let options=dynamic({'Authorization':'Basic <insert your cloud library credentials hash here>'});
    let variables = evaluate http_request(uri, headers, options)
        | project title = tostring(ResponseBody.['title']), contributor = tostring(ResponseBody.contributor.name), nodeset = parse_xml(tostring(ResponseBody.nodeset.nodesetXml))
        | mv-expand UAVariable = nodeset.UANodeSet.UAVariable
        | extend NodeId = UAVariable.['@NodeId'], ParentNodeId = UAVariable.['@ParentNodeId'], DisplayName = tostring(UAVariable['DisplayName']), DataType = tostring(UAVariable.['@DataType']), References = tostring(UAVariable.['References'])
        | where References !contains "HasModellingRule"
        | where DisplayName != "InputArguments"
        | project-away nodeset, UAVariable, References;
    let objects = evaluate http_request(uri, headers, options)
        | project title = tostring(ResponseBody.['title']), contributor = tostring(ResponseBody.contributor.name), nodeset = parse_xml(tostring(ResponseBody.nodeset.nodesetXml))
        | mv-expand UAObject = nodeset.UANodeSet.UAObject
        | extend NodeId = UAObject.['@NodeId'], ParentNodeId = UAObject.['@ParentNodeId'], DisplayName = tostring(UAObject['DisplayName']), References = tostring(UAObject.['References'])
        | where References !contains "HasModellingRule"
        | project-away nodeset, UAObject, References;
    let nodes = variables
        | project source = tostring(NodeId), target = tostring(ParentNodeId), name = tostring(DisplayName)
        | join kind=fullouter (objects
            | project source = tostring(NodeId), target = tostring(ParentNodeId), name = tostring(DisplayName)) on source
            | project source = coalesce(source, source1), target = coalesce(target, target1), name = coalesce(name, name1);
    let edges = nodes;
    edges
        | make-graph source --> target with nodes on source

For best results, change the `Layout` option to `Grouped` and the `Lables` to `name`.

:::image type="content" source="../media/stationgraph.png" alt-text="Graph of Station Info Model." lightbox="../media/stationgraph.png" border="false" :::


## Production Line Simulation

The solution leverages a production line simulation made up of several stations, leveraging an OPC UA information model, as well as a simple Manufacturing Execution System (MES). Both the Stations and the MES are containerized for easy deployment.


### Default Simulation Configuration

The simulation is configured to include 2 production lines. The default configuration is depicted below:

| Production Line | Ideal Cycle Time (in seconds) |
| --- | --- |
| Munich | 6 |
| Seattle |	10 |

| Shift Name | Start | End |
| --- | --- | --- |
| Morning | 07:00 | 14:00 |
| Afternoon | 15:00 | 22:00 |
| Night | 23:00 | 06:00 |

Note: Shift times are in local time, i.e. the time zone the VM hosting the production line simulation is set to!


### OPC UA Node IDs of Station OPC UA Server

The following OPC UA Node IDs are used in the Station OPC UA Server for telemetry to the cloud
* i=379 - manufactured product serial number
* i=385 - number of manufactured products
* i=391 - number of discarded products
* i=398 - running time
* i=399 - faulty time
* i=400 - status (0=station ready to do work, 1=work in progress, 2=work done and good part manufactured, 3=work done and scrap manufactured, 4=station in fault state)
* i=406 - energy consumption
* i=412 - ideal cycle time
* i=418 - actual cycle time
* i=434 - pressure


## Digital Feedback Loop with UA Cloud Commander and UA Cloud Action

This reference implementation implements a "digital feedback loop", i.e. triggering a command on one of the OPC UA servers in the simulation from the cloud, based on a time-series reaching a certain threshold (the simulated pressure). You can see the pressure of the assembly machine in the Seattle production line being released on regular intervals in the Azure Data Explorer dashboard.


## Installation of Production Line Simulation and Cloud Services

Clicking on the button below will **deploy** all required resources (on Microsoft Azure):

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fdigitaltwinconsortium%2FManufacturingOntologies%2Fmain%2FDeployment%2Farm.json)

Note: During deployment, you must provide a password for a VM used to host the production line simulation and for UA Cloud Twin. The password must have 3 of the following: 1 lower case character, 1 upper case character, 1 number, and 1 special character. The password must be between 12 and 72 characters long.

Note: To save cost, the deployment deploys just a single Windows 11 Enterprise VM for both the production line simulation and the base OS for the Azure Kubernetes Services Edge Essentials instance. In production scenarios, the production line simulation is obviously not required and for the base OS for the Azure Kubernetes Services Edge Essentials instance, we recommend Windows IoT Enterprise Long Term Servicing Channel (LTSC).

Once the deployment completes, connect to the deployed Windows VM with an RDP (remote desktop) connection. You can download the RDP file in the [Azure portal](https://portal.azure.com) page for the VM, under the **Connect** options. Sign in using the credentials you provided during deployment, open an **Administrator Powershell window**, navigate to the `C:\ManufacturingOntologies-main\Deployment` directory and run
     
    New-AksEdgeDeployment -JsonConfigFilePath .\aksedge-config.json

Once the command is finished, your Azure Kubernetes Services Edge Essentials installation is complete and you can run the production line simulation.

Note: To get logs from all your Kubernetes workloads and services at any time, simply run `Get-AksEdgeLogs` from an **Administrator Powershell window**.

Note: To check the memory utilization of your Kubernetes cluster, simply run `Invoke-AksEdgeNodeCommand -Command "sudo cat /proc/meminfo"` from an **Administrator Powershell window**.


## Running the Production Line Simulation

From the deployed VM, open a **Windows command prompt**, navigate to the `C:\ManufacturingOntologies-main\Tools\FactorySimulation` directory and run the **StartSimulation** command by supplying the following parameters:

Syntax:

    StartSimulation <EventHubsCS> <StorageAccountCS> <AzureSubscriptionID> <AzureTenantID>

Parameters:

| Parameter | Description |
| --- | --- |
| EventHubCS | Copy the Event Hubs namespace connection string as described [here](https://learn.microsoft.com/en-us/azure/event-hubs/event-hubs-get-connection-string). |
| StorageAccountCS | In the Azure Portal, navigate to the Storage Account created by this solution. Select "Access keys" from the left-hand navigation menu. Then, copy the connection string for key1. |
| AzureSubscriptionID | In Azure Portal, browse your Subscriptions and copy the ID of the subscription used in this solution. |
| AzureTenantID | In Azure Portal, open the Microsoft Entry ID page and copy your Tenant ID. |

Example: StartSimulation Endpoint=sb://ontologies.servicebus.windows.net/;SharedAccessKeyName=RootManageSharedAccessKey;SharedAccessKey=abcdefgh= DefaultEndpointsProtocol=https;AccountName=ontologiesstorage;AccountKey=abcdefgh==;EndpointSuffix=core.windows.net 9dd2eft0-3dad-4aeb-85d8-c3adssd8127a 6e660ce4-d51a-4585-80c6-58035e212354

Note: If you have access to several Azure subscriptions, it is worth first logging into the Azure Portal from the VM through the web browser. You can also switch Active Directory tenants through the Azure Portal UI (in the top-right-hand corner), to make sure you are logged in to the tenant used during deployment. Once logged in, simply leave the browser window open. This will ensure that the StartSimulation script can more easily connect to the right subscription.

Note: In this solution, the OPC UA application certificate store for UA Cloud Publisher, as well as the simulated production line's MES and individual machines' store, is located in the cloud in the deployed Azure Storage account.


## Enabling the Kubernetes Cluster for Management via Azure Arc

1. On your virtual machine, open an **Administrator PowerShell window**, navigate to the `C:\ManufacturingOntologies-main\Deployment` directory and run `CreateServicePrincipal`. The two parameters `subscriptionID` and `tenantID` can be retrieved from the Azure Portal.
1. Run `notepad aksedge-config.json` and provide the following information:

    | Attribute | Description |
    | --- | --- |
    | Location | The Azure location of your resource group. You can find this in the Azure portal under the resource group which was deployed for this solution, but remove the spaces in the name! Currently supported regions are eastus, eastus2, westus, westus2, westus3, westeurope and northeurope. |
    | SubscriptionId | Your subscription ID. In the Azure portal, click on the subscription you're using and copy/paste the subscription ID. |
    | TenantId | Your tenant ID. In the Azure portal, click on Azure Active Directory and copy/paste the tenant ID. |
    | ResourceGroupName | The name of the Azure resource group which was deployed for this solution. |
    | ClientId | The name of the Azure Service Principal previously created. AKS uses this service principal to connect your cluster to Arc. |
    | ClientSecret | The password for the Azure Service Principal. |

1. Save the file, close the Powershell window, open a new **Administrator Powershell window**, navigate back to the `C:\ManufacturingOntologies-main\Deployment` directory and run `SetupArc`.

You can now manage your Kubernetes cluster from the cloud via the newly deployed Azure Arc instance. In the Azure Portal, browse to the Azure Arc instance and select Workloads. The required service token can be retrieved via `Get-AksEdgeManagedServiceToken` from an **Administrator Powershell window** on your virtual machine.

:::image type="content" source="../media/arc.png" alt-text="Arc." lightbox="../media/arc.png" border="false" :::


## Deploying Azure IoT Operations on the Edge

Please make sure you have already started the production line simulation and enabled the Kubernetes Cluster for management via Azure Arc as described in the previous paragraphs. Then, follow these steps:

1. From the Azure Portal, navigate to the Key Vault deployed in this reference solution and add your own identity to the access policies by clicking `Access policies`, `Create`, select the `Keys, Secrets & Certificate Management` template, click `Next`, search for and select your own user identity, click `Next`, leave the Application section blank, click `Next` and finally `Create`.
1. Enable custom locations for your Arc-connected Kubernetes cluster (called ontologies_cluster) by first logging in to your Azure subscription via `az login` from an **Administrator PowerShell Window** and then running `az connectedk8s enable-features -n "ontologies_cluster" -g "<resourceGroupName>" --features cluster-connect custom-locations`, providing the `resourceGroupName` from the reference solution deployed.
1. From the Azure Portal, navigate to the Azure Storage deployed in this reference solution, open the `Storage browser` and then `Blob containers`. Here you can access the cloud-based OPC UA certificate store used in this solution. Azure IoT Operations uses Azure Key Vault as the cloud-based OPC UA certificate store so the certificates need to be copied:
    1. From within the Azure Storage browser's Blob containers, for each simulated production line, navigate to the app/pki/trusted/certs folder, select the assembly, packaging and test cert file and download it.
    1. Log in to your Azure subscription via `az login` from an **Administrator PowerShell Window** and then run `az keyvault secret set --name "<stationName>-der" --vault-name <keyVaultName> --file .<stationName>.der --encoding hex --content-type application/pkix-cert`, providing the `keyVaultName` and `stationName` of each of the 6 stations you downloaded a .der cert file for in the previous step.
1. From the Azure Portal, deploy Azure IoT Operations by navigating to your Arc-connected kubernetes cluster, click on `Extensions`, `Add`, select `Azure IoT Operations` and click `Create`. On the Basic page, leave everything as-is. On the Configuration page, set the MQ mode to `Auto`. You don't need to deploy a simulated PLC, as this reference solution already contains a much more substancial production line simulation. On the Automation page, select the Key Vault deployed for this reference solution and then copy the `az iot ops init` command automatically generated. From your deployed VM, open a new **Administrator PowerShell Window**, login to the correct Azure subscription by running `az login` and then run the `az iot ops init` command. Once the command completes, click `Next` and then close the wizard. 
1. Once deployment completes and all Kubernetes pods are up and running, log in to your Azure subscription via `az login` from an **Administrator PowerShell Window** and then run `kubectl apply -f secretsprovider.yaml` with the updated secrets provider resource file provided in the `C:\ManufacturingOntologies-main\Tools\FactorySimulation\Station` directory, providing the Key Vault name, the Azure tenant ID and the station cert file names and aliases you uploaded to Azure Key Vault previously.
1. From a web browser, log in to https://iotoperations.azure.com, pick the right Azure directory (top right hand corner) and start creating assets from the production line simulation. As mentioned above, the solution comes with 2 production lines (Munich and Seattle) consisting of 3 stations each (assembly, test and packaging):
    1. For the asset endpoints, enter opc.tcp://assembly.munich in the OPC UA Broker URL field for the assembly station of the Munich production line, etc. You will also need to select `Use transport authentication certificate` and provide the thumbprint of the Azure IoT Operations certificate you created earlier. To read the thumbprint, double-click the certificate file in Windows File Explorer, select `Details` and scroll dwon to `Thumbprint`.
    1. For the asset tags, select `Import CSV file` and open the `StationTags.csv` file located in the `C:\ManufacturingOntologies-main\Tools\FactorySimulation\Station` directory.
1. From the Azure Portal, navigate to the Azure Storage deployed in this reference solution, open the `Storage browser` and then `Blob containers`. For each production line simulated, navigate to the `app/pki/rejected/certs` folder and download the Azure IoT Operations certificate file. Then delete the file. Navigate to the `app/pki/trusted/certs` folder and upload the Azure IoT Operations certificate file to this directory.
1. From the deployed VM, open a **Windows command prompt** and restart the production line simulation by navigating to the `C:\ManufacturingOntologies-main\Tools\FactorySimulation` directory and run the **StopSimulation** command, followed by the **StartSimulation** command as described above.
1. From the deployed VM, open a **Windows command prompt** and follow the instructions as described [here](https://learn.microsoft.com/en-us/azure/iot-operations/get-started/quickstart-add-assets#verify-data-is-flowing) to verify that data is flowing from the production line simulation.
1. As the last step, connect Azure IoT Operations to the Event Hubs deployed in this reference solution as described [here](https://learn.microsoft.com/en-us/azure/iot-operations/connect-to-cloud/howto-configure-kafka).


## Condition Monitoring, Calculating OEE, Detecting Anomalies and Making Predictions in Azure Data Explorer

You can also visit the [Azure Data Explorer documentation](https://learn.microsoft.com/en-us/azure/synapse-analytics/data-explorer/data-explorer-overview) to learn how to create no-code dashboards for condition monitoring, yield or maintenance predictions, or anomaly detection. We have provided a sample dashboard [here](dashboard-ontologies.json) for you to deploy to the ADX Dashboard by following the steps outlined [here](https://learn.microsoft.com/en-us/azure/data-explorer/azure-data-explorer-dashboards#to-create-new-dashboard-from-a-file). After import, you need to update the dashboard's data source by specifying the HTTPS endpoint of your ADX server cluster instance in the format `https://ADXInstanceName.AzureRegion.kusto.windows.net/` in the top-right-hand corner of the dashboard. 

:::image type="content" source="../media/dashboard.png" alt-text="Dashboard." lightbox="../media/dashboard.png" border="false" :::

Note: If you want to display the OEE for a specific shift, select `Custom Time Range` in the `Time Range` drop down in the top-left hand corner of the ADX Dashboard and enter the date and time from start to end of the shift you are interested in. 


## Rendering the Built-In Unified NameSpace (UNS) and ISA-95 Model Graph in Kusto Explorer

This reference solution implements a Unified NameSapce (UNS), based on the OPC UA metadata sent to the time-series database in the cloud (Azure Data Explorer). This OPC UA metadata also includes the ISA-95 asset hierarchy. The resulting graph can be easily visualized in the Kusto Explorer tool available for download [here](https://learn.microsoft.com/en-us/azure/data-explorer/kusto/tools/kusto-explorer).

Add a new connection to your Azure Data Explorer instance deployed in this reference solution and then run the following query in Kusto Explorer:

    let edges = opcua_metadata_lkv
    | project source = DisplayName, target = Workcell
    | join kind=fullouter (opcua_metadata_lkv
        | project source = Workcell, target = Line) on source
        | join kind=fullouter (opcua_metadata_lkv
            | project source = Line, target = Area) on source
            | join kind=fullouter (opcua_metadata_lkv
                | project source = Area, target = Site) on source
                | join kind=fullouter (opcua_metadata_lkv
                    | project source = Site, target = Enterprise) on source
                    | project source = coalesce(source, source1, source2, source3, source4), target = coalesce(target, target1, target2, target3, target4);
    let nodes = opcua_metadata_lkv;
    edges | make-graph source --> target with nodes on DisplayName

For best results, change the `Layout` option to `Grouped`.

:::image type="content" source="../media/isa95graph.png" alt-text="Graph of ISA-95 Asset Hierarchy." lightbox="../media/isa95graph.png" border="false" :::


## Using Azure Managed Grafana Service

You can also leverage Grafana to create a dashboard on Azure for this reference solution:

:::image type="content" source="../media/grafana.png" alt-text="Grafana." lightbox="../media/grafana.png" border="false" :::

### Grafana Introduction

Grafana is used within manufacturing to create dasbhoards that displays real-time data. Azure offers a service named Azure Managed Grafana. With this, you can create cloud dashboards. In this configuration manual, you will enable Grafana on Azure and you will create a dashboard with data that is queried from Azure Data Explorer and Azure Digital Twins service, using the simulated production line data from this reference solution. Below is a screenshot from the dashboard:

### Enable Azure Managed Grafana Service

Go to the Microsoft Azure portal and search for the service 'Grafana' and select the 'Azure Managed Grafana' service.

:::image type="content" source="../media/enablegrafaservice.png" alt-text="Graph of Station Info Model." lightbox="../media/enablegrafaservice.png" border="false" :::

Give your instance a name and leave the standard options on - and create the service. 

After the service is created, navigate to the URL where you can have access to your Grafana instance. You can find the URL in the homepage of the service. 

:::image type="content" source="../media/urltografana.png" alt-text="URL to Grafana." lightbox="../media/urltografana.png" border="false" :::

### Add a new Data Source in Grafana

After your first login, you will need to add a new data source to Azure Data Explorer. Navigate to 'Configuration' and add a new datasource.

:::image type="content" source="../media/adddatasroucegrafana.png" alt-text="add new service." lightbox="../media/adddatasroucegrafana.png" border="false" :::

Search for Azure Data Explorer and select the service.

:::image type="content" source="../media/searchadx.png" alt-text="Search ADX." lightbox="../media/searchadx.png" border="false" :::

Configure your connection and use the app registration (follow the manual that is provided on the top of this page).

:::image type="content" source="../media/appregistration.png" alt-text="Create app registration." lightbox="../media/appregistration.png" border="false" :::

Save and test your connection on the bottom of the page. 

### Import a Sample Dashboard

Now we can import the provided sample dashboard. You can download it here: [Sample Grafana Manufacturing Dashboard](samplegrafanadashboard.json)

Then go to 'Dashboard' and select 'Import'.

:::image type="content" source="../media/importfile.png" alt-text="Import file." lightbox="../media/importfile.png" border="false" :::

Select the source that you have downloaded and click on 'Save'. You will get an error on the page, because two variables are not set yet. Go the the settings page of the dashboard.

:::image type="content" source="../media/settingsdashboard.png" alt-text="Settings of dashboard." lightbox="../media/settingsdashboard.png" border="false" :::

Select on the left on 'Variables' and update the two URL with the URL of your Azure Digital Twins Service. 

:::image type="content" source="../media/variablesetting.png" alt-text="Variable setting." lightbox="../media/variablesetting.png" border="false" :::

Then, navigate back to the dashboard and hit the refresh button. You should now see data (don't forget to hit the save button on the dashboard).

:::image type="content" source="../media/endresult.png" alt-text="End result." lightbox="../media/endresult.png" border="false" :::

The location variable on the top of the page is automatically filled with data from Azure Digital Twins (the area nodes from ISA95). Here you can select the different locations and see the different datapoints of every factory. 

If data is not showing up in your dashboard, please navigate to the individual panels and see if the right data source is selected:

:::image type="content" source="../media/datasourceselected.png" alt-text="Right data source selected." lightbox="../media/datasourceselected.png" border="false" :::

### Configuring Alerts

Within Grafana it is also possible to create alerts. Please follow manual to create an alert:

In this example, we will create a low OEE alert for one of the production lines. First, login to your Grafana service and select Alert rules in the menu.

:::image type="content" source="../media/navigatetoalerts.png" alt-text="Navigate to Alerts." lightbox="../media/navigatetoalerts.png" border="false" :::

Then click on 'Create Rule' on the right.

:::image type="content" source="../media/createrule.png" alt-text="Create rule." lightbox="../media/createrule.png" border="false" :::

Then give your alert a name and select 'Azure Data Explorer' as data source. Click on query on the left

:::image type="content" source="../media/alertquery.png" alt-text="Alert query." lightbox="../media/alertquery.png" border="false" :::

In the query field, enter the following. In this example, we will use the 'Seattle' production line. 

```
let oee = CalculateOEEForStation("assembly", "seattle", 6, 6);
print round(oee * 100, 2)
```
and select 'table' as output. 

Scroll down to the next section. Here, you will configure the alert threshold. In this example, we will use 'below 10' as the threshold, but in production environments, this will be higher.

:::image type="content" source="../media/threshold%20alert.png" alt-text="Threshold Alert." lightbox="../media/threshold%20alert.png" border="false" :::

Select the folder where you want to save your alerts and configure the 'Alert Evaluation behavior' - here, select 'every 2 minutes'.

Hit the 'Save and exit' button on the top. 

In the overview of your alerts, you can now see an alert being triggered when your OEE is below '10'.

:::image type="content" source="../media/alertoverview.png" alt-text="Alert overview." lightbox="../media/alertoverview.png" border="false" :::

You can integrate this with, for example, Microsoft Dynamics Field Services.


## Connecting the Reference Solution to Microsoft Power BI

1. You need access to a Power BI subscription.
1. Install the Power BI Desktop app from [here](https://go.microsoft.com/fwlink/?LinkId=2240819&clcid=0x409).
1. Login to Power BI Desktop app using the user with access to the Power BI subscription.
1. From the Azure Portal, navigate to your Azure Data Explorer database instance (`ontologies`) and add `Database Admin` permissions to an Azure Active Directory user with access to just a **single** Azure subscription, i.e. the subscription used for your deployed instance of this reference solution. Create a new user in Azure Active Directory if you have to.
1. From Power BI, create a new report and select Azure Data Explorer time-series data as a data source via `Get data` -> `Azure` -> `Azure Data Explorer (Kusto)`.
1. In the popup window, enter the Azure Data Explorer endpoint of your instance (e.g. `https://erichbtest3adx.eastus2.kusto.windows.net`), the database name (`ontologies`) and the following query:

        let _startTime = ago(1h);
        let _endTime = now();
        opcua_metadata_lkv
        | where Name contains "assembly"
        | where Name contains "munich"
        | join kind=inner (opcua_telemetry
            | where Name == "ActualCycleTime"
            | where Timestamp > _startTime and Timestamp < _endTime
        ) on DataSetWriterID
        | extend NodeValue = todouble(Value)
        | project Timestamp, NodeValue

1. Click `Load`. This will import the actual cycle time of the Assembly station of the Munich production line for the last hour.
1. When prompted, log into Azure Data Explorer using the Azure Active Directory user you gave permission to access the Azure Data Explorer database earlier.
1. From the `Data view`, select the NodeValue column and select `Don't summarize` in the `Summarization` menu item.
1. Switch to the `Report view`.
1. Under `Visualizations`, select the `Line Chart` visualization.
1. Under `Visualizations`, move the `Timestamp` from the `Data` source to the `X-axis`, click on it and select `Timestamp`.
1. Under `Visualizations`, move the `NodeValue` from the `Data` source to the `Y-axis`, click on it and select `Median`.
1. Save your new report.

Note: You can add other data from Azure Data Explorer to your report similarily.

:::image type="content" source="../media/powerbi.png" alt-text="Power BI." lightbox="../media/powerbi.png" border="false" :::


## Connecting the Reference Solution to Microsoft Dynamics 365 Field Service

This integration showcases the following scenarios:

- Uploading assets from the Manufacturing Ontologies reference solution to Dynamics 365 Field Service.
- Create alerts in Dynamics 365 Field Service when a certain threshold on Manufacturing Ontologies reference solution telemetry data is reached.

The integration leverages Azure Logics Apps. With Logic Apps bussiness-critcal apps and services can be connected via no-code workflows. We will fetch information from Azure Data Explorer and trigger actions in Dynamics 365 Field Service.

First, if you are not already a Dynamics 365 Field Service customer, activate a 30 day trial [here](https://dynamics.microsoft.com/en-us/field-service/field-service-management-software/free-trial). Remember is to use the same Azure Entra ID (formerly Azure Active Directory) used while deploying the Manufacturing Ontologies reference solution. Otherwise, you would need to configure cross tenant authentication which is not part of these instructions!

### Create an Azure Logic App Workflow to create assets in Dynamics 365 Field Service

Let's start with uploading assets from the Manufacturing Ontologies into Dynamics 365 Field Service:

1. Go to the Azure Portal and create a new Logic App as shown below:

  :::image type="content" source="../media/createlogicapp.png" alt-text="Create Logic App." lightbox="../media/createlogicapp.png" border="false" :::

2. Give the Azure Logic App a name, place it in the same resource group as the Manufacturing Ontologies reference solution.

  :::image type="content" source="../media/configurelogicapp.png" alt-text="Configure Logic App." lightbox="../media/configurelogicapp.png" border="false" :::

3. Click on 'Workflows':

  :::image type="content" source="../media/createlogicappflow.png" alt-text="Navigate to flow." lightbox="../media/createlogicappflow.png" border="false" :::

4. Give your workflow a name - for this scenario we will use the stateful state type, because assets are not flows of data.

  :::image type="content" source="../media/createlogicappflow2.png" alt-text="Give flow a name." lightbox="../media/createlogicappflow2.png" border="false" :::

5. Create a new trigger. We will start with creating a 'Recurrence' tigger. This will check the database every day if new assets are created. Of course, you can change this to happen more often.

  :::image type="content" source="../media/flow2scheduler.png" alt-text="Create Recurrence." lightbox="../media/flow2scheduler.png" border="false" :::

6. In actions, search for 'Azure Data Explorer' and select the 'Run KQL query' command. Within this query we will check what kind of assets we have. Use the following query to get assets and paste it in the query field:

  ```TEXT
  let ADTInstance =  "PLACE YOUR ADT URL";let ADTQuery = "SELECT T.OPCUAApplicationURI as AssetName, T.$metadata.OPCUAApplicationURI.lastUpdateTime as UpdateTime FROM DIGITALTWINS T WHERE IS_OF_MODEL(T , 'dtmi:digitaltwins:opcua:nodeset;1') AND T.$metadata.OPCUAApplicationURI.lastUpdateTime > 'PLACE DATE'";evaluate azure_digital_twins_query_request(ADTInstance, ADTQuery)
  ```

  :::image type="content" source="../media/designerkqlquery2.png" alt-text="Connect Kusto." lightbox="../media/designerkqlquery2.png" border="false" :::

7. To get your asset data into Dynamics 365 Field Service, you need to connect to Microsoft Dataverse. Connect to your Dynamics 365 Field Service instance and use the following configuration:

  - Use the 'Customer Assets' Table Name
  - Put the 'AssetName' into the Name field

  :::image type="content" source="../media/designerkqlquery3.png" alt-text="Configure Dataverse." lightbox="../media/designerkqlquery3.png" border="false" :::

8. Save your workflow and run it. You will see in a few seconds later that new assets are created in Dynamics 365 Field Service.

  :::image type="content" source="../media/runflow.png" alt-text="Run." lightbox="../media/runflow.png" border="false" :::

### Create an Azure Logic App Workflow to create Alerts in Dynamics 365 Field Service

This workflow will create alerts in Dynamics 365 Field Service, specifically when a certain threshold of FaultyTime on an asset of the Manufacturing Ontologies reference solution is reached.

1. We first need to create an Azure Data Explorer function to get the right data. Go to your Azure Data Explorer query panel in the Azure Portal and run the following code to create a FaultyFieldAssets function:

  :::image type="content" source="../media/adxquery.png" alt-text="Create function ADX." lightbox="../media/adxquery.png" border="false" :::

   ```TEXT
   .create-or-alter function  FaultyFieldAssets() {  
   let Lw_start = ago(3d);
   opcua_telemetry
   | where Name == 'FaultyTime'
   and Value > 0
   and Timestamp between (Lw_start .. now())
   | join kind=inner (
       opcua_metadata
       | extend AssetList =split (Name, ';')
       | extend AssetName=AssetList[0]
       ) on DataSetWriterID
   | project AssetName, Name, Value, Timestamp}
   ```

2. Create a new workflow in Azure Logic App. Create a 'Recurrance' trigger to start - every 3 minutes. Create as action 'Azure Data Explorer' and select the Run KQL Query.

  :::image type="content" source="../media/flow2kqleury.png" alt-text="Run KQL Query." lightbox="../media/flow2kqleury.png" border="false" :::

3. Enter your Azure Data Explorer Cluster URL, then select your database and use the function name created in step 1 as the query.

  :::image type="content" source="../media/flow2adx.png" alt-text="Flow to ADX." lightbox="../media/flow2adx.png" border="false" :::

4. Select Microsoft Dataverse as action and put the below configuration in the fields:

  :::image type="content" source="../media/flow2fieldservices.png" alt-text="Configure FS." lightbox="../media/flow2fieldservices.png" border="false" :::

5. Run the workflow and to see new alerts being generated in your Dynamics 365 Field Service dashboard:

  :::image type="content" source="../media/dynamicsiotalerts.png" alt-text="View your alerts in Dynamics365 FS." lightbox="../media/dynamicsiotalerts.png" border="false" :::


## Connect the Solution to Microsoft Sustainability Manager

### Introduction
Microsoft Sustainability Manager (MSM) is an extensible solution that unifies data intelligence and provides comprehensive, integrated, and automated sustainability management for organizations at any stage of their sustainability journey. It automates manual processes, enabling organizations to more efficiently record, report, and reduce their emissions.

In the simulated production also the energy usage of every machine is collected. This data can be loaded into MSM for reporting on scope 2 emissions. Below the global steps how this works. This is more complicated, but it gives a high level understanding what is happening.

:::image type="content" source="../media/overviewsolution.png" alt-text="Overview solution." lightbox="../media/overviewsolution.png" border="false" :::

### Setup Trial account
When you want to use the Microsoft Sustainability Manager (MSM),can you start with a 30 day trial. 

1. For that you need to go to [this](https://www.microsoft.com/en-us/sustainability/cloud) trialpage. Enter there your e-mailadres, agree with the term and click on 'Start your free trial'

:::image type="content" source="../media/trialpage.png" alt-text="MSM trial page." lightbox="../media/trialpage.png" border="false" :::

2. After that select your country and add your phonenumber. 

:::image type="content" source="../media/welcomepage.png" alt-text="Welcome page MSM." lightbox="../media/welcomepage.png" border="false" :::

3. Your MSM environment is ready to go. 

:::image type="content" source="../media/startpagemsm.png" alt-text="Startpage of MSM." lightbox="../media/startpagemsm.png" border="false" :::

4. We need to create a new facility in MSM to connect the production lines of this example to the rigth facility. Navigate to the left bottom menu and select 'Settings'.

:::image type="content" source="../media/settings.png" alt-text="Settings MSM." lightbox="../media/settings.png" border="false" :::

5. Click on 'Add new facility' and create your own facility name that you want to create, for example "Seattle'. Important to add the address of the facility.

:::image type="content" source="../media/addnewfacility.png" alt-text="Add new facility." lightbox="../media/addnewfacility.png" border="false" :::

6. Then you have to connect your Facility also to the MSM calculation models. Therefore please navigate to the Data page (menu left bottom). 

:::image type="content" source="../media/factorylibraries.png" alt-text="Factory library." lightbox="../media/factorylibraries.png" border="false" :::

7. Click on 'New factory mapping' where we can connect the Facility to the right library.

:::image type="content" source="../media/factormapping.png" alt-text="Factor mapping." lightbox="../media/factormapping.png" border="false" :::

8. Give your factor mapping a name, for example Seattle Facility. Select in the reference data the name of your facility, in our case 'Seattle' and connect the factor to it. Because this factory is based in Seattle, I will connect the America library to it.

:::image type="content" source="../media/newfactorymapping.png" alt-text="Create new factory mapping." lightbox="../media/newfactorymapping.png" border="false" :::

### Import data from Azure Data Explorer
Now we can import the energy data (scope 2) from Azure Data Explorer. In the current setup of this solution not all the needed fields for MSM are in the solution.

### Different tenants (Azure and MSM)
9. If you are importing from a different Azure tenant the data from Azure Data Explorer you need to add the full FQDN name. Run the following script on your Azure Data Explorer when needed: 

```
.add database ['ADXDATABASE'] users ('aaduser=YOURFULLFQDN') 'Test MSM (AAD)'
```

For this demo a seperate ADX Function has been created without the location name to make it easier. Add this function to ADX. 

```
.create-or-alter function  GetDigitalTwinIdForUANodeTest(stationName:string,displayName:string) {
let dataHistoryTable = adt_dh_mtcamsafactory_ADT_westeurope; // set to the name of your data history table
let dtId = toscalar(dataHistoryTable
| where Key == 'equipmentID'
| where Value has stationName
| where Value has displayName
| project Id);
print dtId
}
```

10. Navigate to the setting menu and select 'Data'. On the top select the Data Connections and create a new 'Connect to data'. 

:::image type="content" source="../media/connectdata.png" alt-text="Connect data." lightbox="../media/connectdata.png" border="false" :::

11. Select Activity data and select 'Scope 2 - Purchased Electricity'. We are importing kWh usage, if you have other data please select then the right Activity data.  

:::image type="content" source="../media/createconnection.png" alt-text="Create new connection." lightbox="../media/createconnection.png" border="false" :::

12. Select the Azure Data Explorer (KUSTO) connector, if you don't see it in the list, select 'browse all'.

:::image type="content" source="../media/selectadx.png" alt-text="Select ADX connector." lightbox="../media/selectadx.png" border="false" :::

13. Add your URL of your:
- Cluster - full URL name
- Database name
- In the table name the following query

### Query

```
let msmTable = adt_dh_mtcamsafactory_ADT_westeurope
| where Id == toscalar(GetDigitalTwinIdForUANodeTest("assembly", "EnergyConsumption"));
msmTable
| where isnotnull(SourceTimeStamp)
| extend energy = todouble(Value)
| summarize sum(energy) by bin(SourceTimeStamp, 1d)
| project name="EnergyConsumption Factory", OrganizationalUnit="NAME OF YOUR COMPANY", energytype="Electricity", facility="Seattle", energyprovider="YOUR ENERGY PROVIDER", isrenewable="No", dataquality="Metered", consumptionstartdate=SourceTimeStamp, consumptionenddate=SourceTimeStamp, quantity=sum_energy, quantityunit="kWh";
```
Because the solution don't have all the context yet that is needed for MSM in the query certain fields are hard cooked (Capital Letters). Please change them according. 

And clikc on 'Sign in'. You will get a pop-up to login with your account. If that is not working, you need to add your account to the ADX explorer (step 9 in this manual)

:::image type="content" source="../media/connectionsettings.png" alt-text="Settings connection." lightbox="../media/connectionsettings.png" border="false" :::

14. Now you should see your data loading in the screen. Select the 'Map to Entity' button. 

:::image type="content" source="../media/powerqueryoverview.png" alt-text="PowerQuery overview." lightbox="../media/powerqueryoverview.png" border="false" :::

15. Select Energy and click on Auto map. The ones that not be can mapped, just manual map them. Click on 'Ok' when you are finished. Hit then the 'Create' button and your connection has been created.

:::image type="content" source="../media/mappingCDM.png" alt-text="Mapping to CDM." lightbox="../media/mappingCDM.png" border="false" :::

16. If you want to import it automatically you can select that, in this case we just do it onces. When you select daily, ajust your query to only get the day - 1 day. Else you will get double records. 

:::image type="content" source="../media/finishedimport.png" alt-text="Finished import." lightbox="../media/finishedimport.png" border="false" :::

17. Give your connection and name and save. Give it some minutes to import your data into MSM. 

:::image type="content" source="../media/importname.png" alt-text="Import name." lightbox="../media/importname.png" border="false" :::

If it is completed you will see this screen. 

:::image type="content" source="../media/importcompleted.png" alt-text="Import completed." lightbox="../media/importcompleted.png" border="false" :::

18. Now you run the calculation. Depending on your settings in MSM, this is automatically done, but if not, go to the 'Calculation profiles'. Select the Purchased Electricity profile (that is connected to your factory) and Run the calculation.

:::image type="content" source="../media/runcalculation.png" alt-text="Run calculation." lightbox="../media/runcalculation.png" border="false" :::

Within some minutes your dashboard should be updated with the new emissions that are coming from the solution!
