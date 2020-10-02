---
title: Retail - Buy online, pickup in store (BOPIS)
titleSuffix: Azure Example Scenarios
description: Learn about how Azure IoT can help a retail solution for stores implementing buy online, pickup in store scenarios.
author: falloutxAY
ms.date: 10/1/2020
ms.topic: example-scenario
ms.service: architecture-center
ms.subservice: example-scenario
ms.category: 
    - iot
ms.custom: fcp
---

# Scenario
Contoso is a European retailer operating mid-sized supermarkets. They
have grown through the years and is now one of the largest with more
than 1000 stores located in both cities and suburbs.

## Challenges faced

-   *What are the business challenges?*
-   *What is the estimated impact caused by these issues?*
-   *What are current operations like?*

Due to the recent COVID-19 pandemic, fewer customers have been making
physical trips to the supermarkets as many are concerned with health
risks and are practicing safe distancing. As a result, Contoso has also
seen an increase in the usage of buy online, pickup in store (BOPIS).
This is also often known as curbside pickup.

In order to ensure that their customers get the freshest quality
produce, Contoso will only pack items that are temperature controlled
when the customers arrive. Due to the rise in usage and time taken to
pack fresh produce, there is a longer than usual waiting time for
curbside pickup. This has caused an increased amount of customer
dissatisfaction and surveys have shown that customers are choosing to
use other retailers because of the long waiting times at Contoso.

## Business Outcomes

-   *What are the desired business outcomes?*
-   *What should the solution do for the business?*

With [**59% of
consumers**](https://retailwire.com/discussion/is-curbside-pickup-just-getting-started/) polled
saying they\'re likely to continue choosing curbside pickup even after
the pandemic, Contoso would like to improve the levels of efficiency in
their curbside operations. For curbside pickups, Contoso would like to
have information on how far away each customer is and when the customer
arrives at the parking lot.

The solution should provide alerts to the store associates and trigger a
work order to start packing the fresh produce for customers that are
near the outlet. This would decrease the waiting time, which would
improve a key aspect of the curbside pickup experience.

## Requirements

-   *What are key technical and non-technical requirements?*

In accessing data on their customers' movements, Contoso will need to
ensure personal privacy protection for their customers as an essential
prerequisite as part of corporate accountability and given that their
brand is built on trust.

There are cases where the vehicles license details do not match the
database or that information is non-existent. To mitigate such data
gaps, Contoso would like to use GPS to help them identify the location
of their customers.

## Patterns to address challenges

-   *How can technology like Internet of Things (IoT) help solve your
    business challenges?*

The table below provides a summary of common use cases and corresponding
IoT solutions. Each use case is an example of how an IoT process pattern
can be applied to real-world scenarios. 

| Use case | Solutions | Pattern
|---|---|---|
| Obtain license plate details and cross-reference that with the respective customer order when the vehicle turns into the parking lot. To alert store associate immediately to start packing and preparing the order. | Use video analytics to detect license plates when the vehicle turns into the parking lot.  This information is reconciled with order management system and a task is sent to Teams which alerts and schedules a store associate to start packing. | [Monitor and manage loop](./monitor-manage-loop.md) -- The video analytics is part of the monitoring layer and the insights are actioned by the store associates as part of the manage pattern. |
| Notify customer that store has started packing and will deliver the order soon. | When store associate starts task, system will cross-check with geofence rule of the customer location. A notification will be sent to the customer to let them know that their delivery is on the way when the system detects that the customer is in the boundaries of the geofence. | [Monitor and manage loop](./monitor-manage-loop.md)  -- The geofence rule is monitoring the location of the customer and sending an alert when the customer is in the vicinity (manage) 

## Reference Architecture

![Architecture diagram showing the data flow for the Buy online pick up in store IoT solution](media/bopis.png)

1.  Video feed is obtained as cars come into the parking area. The IP
    camera hosting a Real-Time Streaming Protocol (RTSP) server send the
    feed to Live View Analytics (LVA) module. The LVA module processes
    the frame rate and sends the image to Azure Cognitive Service
    running on the gateway. Azure Cognitive Service extracts only the
    license plate details and sends it to the cloud application.

2.  Azure IoT Central is used as it is a fully managed solution. It provides
    device management and secure bi-directional communication.

3.  License plate details are queued in Event hub and sent to an Azure
    Storage for long-term storage.

4.  The license plate details are sent to the curbside pickup
    application via Azure Functions. The serverless design allows
    Contoso to lower their infrastructure management and cost.

5.  The license plate details are cross-referenced with the respective
    order and within the customer relationship management system. When a
    match is confirmed, the order packing task is sent to Microsoft
    Teams. A store associate will be notified to start preparing the
    order immediately and deliver it to the customer upon arrival.

6.  The curbside pickup application also uses Azure Maps geofence
    triggers based on rules to start the order packing. This can be used
    to reconcile the license plate notification (described in the
    previous point) or it can be a standalone function in the absence of
    license plate information.

7. Once the store associate picks up the task, the application will
    send a notification to the customer to inform them of the order
    progress. Contoso has found that providing feedback to the customer
    is appreciated as it completes the communication loop with the
    customer and presents accountability in the process.

8. Order pickup details are written back into the storage so that
    Contoso can understand the time taken to work on the order.

9. Business intelligence is done using Azure Synapse and Power Platform
    as it provides Contoso management team an easy way to understand the
    performance of curbside pickup.

## Architecture considerations

**Privacy**

Azure IoT Edge is selected as it is a runtime which allows
container-based modules to be used and it helps to orchestrate these
modules. The solution uses Azure Cognitive services running on the edge
device and only the license plate details are sent to the application.
This ensures that no facial images or privacy data is sent to the
storage.

**Geofence**

The application uses Azure Maps to provide geofencing capabilities. The
inbuilt feature allows Contoso to create geofence rules, which provides
another data point that allows identification of a customer's location.
This provides additional accuracy on the estimated time of arrival.

## Components


-   [Azure IoT Edge](https://azure.microsoft.com/services/iot-edge/) -- Used to run analytics, applications on-premise to ensure
    low latency, lower bandwidth usage and privacy (i.e. extract only
    the license plate details).

-   [Live Video Analytics](https://azure.microsoft.com/services/media-services/live-video-analytics/) -- Live Video Analytics on IoT Edge offers the
    capability to capture, record, and analyze live video. This allows
    Contoso to focus on building features for the business rather than
    managing the video processing pipeline.

-   [Azure Cognitive Services](https://azure.microsoft.com/services/cognitive-services/) -- This allows the AI model to run on the
    edge to adhere to privacy regulations and lower the bandwidth
    required. Contoso can leverage the service without spending
    engineering efforts for creating and training the model.

-   [Azure IoT Central](https://azure.microsoft.com/services/iot-central/) -- As it is a fully managed application platform,
    Contoso spends less time building highly available and scalable
    infrastructure and lower the operation efforts.

-   [Event Hubs](https://azure.microsoft.com/services/event-hubs/) -- Used to queue the events sent to the curb side pickup
    application. This is to create decoupling for consumption.

-   [Azure Storage](https://azure.microsoft.com/services/storage/) -- Storing raw data for analysis.

-   [Azure Functions](https://azure.microsoft.com/services/functions/) -- Serverless application which takes the event
    received and send it to a REST API on the curb side pickup
    application.

-   [Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db/) -- Provide low latency, guaranteed availability and
    automatic scalability database. Application can leverage this NoSQL
    database for fast writes and reads anywhere in the world with
    turnkey multi-master global distribution.

-   [Azure Kubernetes Service](https://azure.microsoft.com/services/kubernetes-service/) -- The curb side pickup application is
    built using a cluster of containers and managed a hosted Kubernetes
    service. The Kubernetes masters are managed by Azure. It handles
    critical tasks like health monitoring and maintenance.

-   [Azure Synapse](https://azure.microsoft.com/services/synapse-analytics/) -- Provides insights on the usage and service levels
    for BOPIS. The engineering team can leverage T-SQL to implement data
    warehousing. Azure Synapse provides a unified plane to manage
    analytics resources, monitor usage and activity, and enforce
    security which is critical to Contoso.

-   [Azure Maps](https://azure.microsoft.com/services/azure-maps/) -- Provides geofencing as a service required to
    gauge customer proximity.

For more detailed discussions, see the IoT reference architecture
[document](https://docs.microsoft.com/azure/architecture/reference-architectures/iot) to understand and explore the various implementation choices
available.

## Next Steps

For more details on solutions, take a look at the below retail partner solutions. 

[Oneview Commerce](https://www.oneviewcommerce.com/)<br>
[Ombori](https://ombori.com/)
