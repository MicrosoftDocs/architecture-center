---
title: Enable an Industrial Dataspace on Azure
description: Learn how to enable an industrial dataspace on Azure. A dataspace provides a secure point-to-point channel for data between the manufacturer and the customer.
author: barnstee
ms.author: erichb
ms.topic: concept-article
ms.subservice: architecture-guide
ms.date: 07/22/2026
ai-usage: ai-assisted
---

# Enable an industrial dataspace on Azure

Many manufacturers need to provide data about their manufactured products to their customers in digital and machine-readable form. Sometimes a law such as the European Union's [Digital Product Passport](https://data.europa.eu/news-events/news/eus-digital-product-passport-advancing-transparency-and-sustainability) legislation mandates this requirement. To provide this data, manufacturers often create an industrial dataspace between their enterprise systems and their customer's systems. The dataspace provides a secure point-to-point communication channel for digital product data between the manufacturer and the customer.

This article shows how to enable an industrial dataspace on Azure.

> [!IMPORTANT]
> Before you deploy this solution, you need to perform the [Azure Data Explorer deployment](how-to-connect-azure-data-explorer-to-solution.md).

## What is an industrial dataspace?

An industrial dataspace is a virtual environment designed to facilitate the secure and efficient exchange of data between different organizations within an industrial ecosystem. It adheres to the following key principles:

- **Data sovereignty.** It ensures that data providers retain control over their data, including who can access it and under what conditions.
- **Interoperability.** It uses standardized protocols and governance models to enable seamless data sharing across various platforms and industries.
- **Collaboration.** It supports collaborative efforts by allowing different stakeholders to share and use data for mutual benefit.

These principles are relevant in the context of *Industry 4.0*, where interconnected systems and data-driven decision making are crucial for optimizing industrial processes and creating resilient supply chains.

## Architecture

The following diagram shows an overview of the solution:

:::image type="complex" source="./media/dataspaces-solution-architecture.svg" alt-text="Architecture diagram that shows the industrial dataspace reference solution from edge assets through Azure IoT Operations, Azure Data Explorer, UA Cloud Library, and a customer ERP system." lightbox="./media/dataspaces-solution-architecture.svg" border="false":::
The diagram is organized into eight labeled columns, flowing from on-premises manufacturing systems on the left to a customer enterprise resource planning system on the far right. A vertical line labeled Firewall separates the on-premises portion from the cloud portion. The two leftmost columns represent ISA-95 manufacturing layers. The leftmost column is labeled Control (ISA-95 Level 2), and the adjacent column is labeled Operations management (ISA-95 Level 3). Together, these columns contain a box labeled Two production lines in two locations, simulated on a Windows VM. This box contains an MES. A group of OPC UA-enabled asset servers also appears in the control layer. It connects to an edge gateway via OPC UA Client/Server. A group of non-OPC UA asset servers also appears in this layer. It connects to the edge gateway through any interface via a WoT connectivity solution. To the right of the operations management layer, the edge layer contains the edge gateway box. The edge gateway runs Linux and Kubernetes and hosts Azure IoT Operations components, including an OPC UA connector, a message queue, data flows, a schema registry, and a UA-CloudAction component. In the fourth column, the edge management layer, Azure Arc and Azure IoT Operations both connect via an arrow labeled Management into the edge gateway. The fifth column, labeled Data acquisition and brokering, contains Event Hubs, which is labeled as the message broker. An arrow from the message queue leads to the data flows component and then crosses the firewall boundary into the cloud, where it connects to the message broker. The fifth column also contains WattTime. The sixth column is labeled Data analytics and storage. This column contains an Azure Data Explorer time-series database, a UA Data Processor, and a Microsoft Dynamics 365 ERP component. An arrow leads from the message broker to Azure Data Explorer. Another arrow, labeled Queries, leads from the UA-CloudAction to the message broker. Arrows labeled Queries lead from the UA Data Processor to WattTime, Azure Data Explorer, and the Dynamics ERP. The seventh column is labeled API. This column contains a UA Cloud Library icon. An arrow, labeled Upload, leads from the data processor to this library. The final column is labeled Apps. This column contains a customer ERP system that connects via an arrow labeled DPP API to the UA Cloud Library.
:::image-end:::

*Download a [PowerPoint file](https://arch-center.azureedge.net/enable-industrial-dataspace.pptx) of this architecture.*

All the required components to enable the industrial dataspace are deployed to Azure during the [Azure Data Explorer workflow](how-to-connect-azure-data-explorer-to-solution.md).

## Provide a carbon footprint for your produced products via DPP

Providing a Product Carbon Footprint (PCF) is one of the most popular use cases for industrial dataspaces. It's increasingly important to customers making buying decisions. Products with a low PCF are popular, but accurately calculating a PCF is difficult. The [Greenhouse Gas (GHG) Protocol](https://ghgprotocol.org) is a common calculation method for PCF. It splits the calculation task into scope 1, scope 2, and scope 3 emissions. Scope 2 emissions are the emissions produced during a production process. This example and reference solution focuses on calculating scope 2 emissions from the simulated production lines.

The simulated stations on the production lines provide energy consumption data. This data is used to calculate the scope 2 carbon footprint for each produced product, if the *marginal carbon intensity* of the electrical energy consumed is known for the location of the simulated production lines. You can retrieve this information from a non-Microsoft cloud service operated by [WattTime](https://watttime.org). If the WattTime service isn't configured, the calculation uses an average value.

## IEC 62541 OPC UA

This reference solution supports Digital Product Passport (DPP) data modeling in a machine-readable and standardized way by using [Open Platform Communication Unified Architecture (OPC UA)](https://opcfoundation.org/about/opc-technologies/opc-ua). This approach is aligned with the OPC Foundation [Cloud Initiative](https://opcfoundation.org/cloud) and simplifies modeling because it builds on the large OPC UA toolset. You can use any OPC UA modeling tool, like the [Siemens OPC UA Modeling Editor (SiOME)](https://support.industry.siemens.com/cs/document/109755133/siemens-opc-ua-modeling-editor-%28siome%29?dti=0&amp;lc=en-US) or the [CESMII SM Profile Designer](https://profiledesigner.cesmii.net), with the reference solution. The reference solution also uses the OPC UA [Nodeset](https://opcconnect.opcfoundation.org/2017/04/using-nodeset-files-to-exchange-information) file format.

This example automatically creates a PCF for a sample of the simulated products produced and stores Digital Product Passports (DPPs) in a UA Cloud Library. The UA Cloud Library is provided as an open-source reference solution by the [OPC Foundation](https://www.opcfoundation.org). The UA Cloud Library configures automatically during deployment and includes a dashboard. To access the dashboard, go to the **Overview** page of the UA Cloud Library container app in the Azure portal after deployment, and select the **Application URL** that's displayed. The UA Cloud Library comes with its own Explorer that you can use to inspect DPPs.

## Retrieve a DPP by using the DPP lifecycle API

The UA Cloud Library exposes a Swagger (OpenAPI) UI that you can use to browse the DPPs produced by the simulation and retrieve a specific one via the EN 18222 DPP lifecycle API. Follow these steps:

1. **Open the Swagger UI.** In the [Azure portal](https://portal.azure.com), go to your resource group and open the UA Cloud Library container app (`<resource-group-name>-ua-cloudlibrary`). From its **Overview** page, copy the **Application URL** (for example `https://<resource-group-name>-ua-cloudlibrary.<region>.azurecontainerapps.io`). Open that URL in a browser and append `/swagger` to reach the Swagger UI.
   
1. **Authorize as admin.** In the Swagger UI, select the **Authorize** button in the top-right corner.
 
   Enter the following credentials and select **Authorize** and then **Close**.
   - **Username**: `admin`
   - **Password**: The value of the admin password that you provided when you deployed the reference solution (the password for the deployment's VM).

   Subsequent requests from the Swagger UI are now sent with the admin credentials.

1. **List the available DPPs.** Expand the **GET `/infomodel/namespaces`** operation and select **Try it out** > **Execute**. The response lists the information-model namespaces stored in the UA Cloud Library, including the DPPs produced by the simulation. Note the identifier (`dppId`) of the DPP you want to retrieve.

1. **Retrieve a specific DPP.** Expand the **GET `/v1/dpps/{dppId}`** operation, select **Try it out**, paste the `dppId` from the previous step into the `dppId` field, and then select **Execute**. The response body contains the full DPP JSON document, including the calculated PCF, for the product.

> [!TIP]
> The same calls work outside the Swagger UI with any HTTP client (for example `curl`) with a Basic authentication header:
> ```bash
> curl -u admin:<ServicePassword> https://<application-url>/infomodel/namespaces
> curl -u admin:<ServicePassword> https://<application-url>/v1/dpps/<dppId>
> ```

## Configure the WattTime service (optional)

To optionally configure the WattTime service for a more accurate carbon footprint calculation:

1. Go to [Register New User](https://docs.watttime.org/#tag/Authentication/operation/post_username_register_post) and choose a username and password for the service. You need these credentials later in this procedure.
1. From a Windows command prompt, enter `wsl` to start the Windows Subsystem for Linux. If WSL isn't installed on your computer, install it by running `wsl --install`, and then restart your computer.
 1. To register your user account, enter the following command, replacing `<organization>`, `<username>`, `<password>`, and `<email>` with your own values:
    ```
    curl -L -X POST -d '{"org":"<organization>","username":"<username>","password":"<password>","email":"<email>"}' https://api.watttime.org/register --header 'Content-Type: application/json' --header 'Accept: application/json'
    ```
1. From Windows Subsystem for Linux, run `echo -n '<username>:<password>' | base64`, and copy the generated value.
1. To validate your registration, sign in to the service by using the following command, replacing `<base64_credentials>` with the value from the previous step: `curl -L -X GET https://api.watttime.org/login -H 'Authorization: Basic <base64_credentials>'`. If the validation succeeds, the response contains an access token.
1. [Contact WattTime](https://watttime.org/contact) to upgrade your free account to a Pro account. The free account only gives you access to the CAISO\_North sub-region, and you need access to the location of the simulated production lines in Munich and Seattle.
1. Wait until you receive an email from WattTime stating that your account was upgraded to a Pro account. Then, in the Azure portal, go to the Azure Container App instance for the deployed UA Data Processor. Follow the steps in [Manage secrets in Azure Container Apps](/azure/container-apps/manage-secrets) to create a secret that contains your WattTime password. Then follow the steps in [Add environment variables on existing container apps](/azure/container-apps/environment-variables?tabs=portal#add-environment-variables-on-existing-container-apps). 
1. In the **Environment variables** section of the **Edit a container** pane, enter your WattTime username as the value of **WATTTIME_USER**, and configure **WATTTIME_PASSWORD** to reference the password secret. Select **Save**, and then select **Create** to deploy a new revision of your UA Data Processor.

## Related resources

- [OPC UA reference solution](iot-industrial-solution-architecture.md)
- [Connect Azure Data Explorer to the OPC UA reference solution](how-to-connect-azure-data-explorer-to-solution.md)