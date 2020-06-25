---
title: Observe and Make Changes to a Strawberry Farm
titleSuffix: Azure Example Scenarios
description: A customer scenario in the agricultural domain to monitor and make changes to greenhouse conditions in real-time using Azure IoT.
author: mcosner
ms.date: 05/04/2020
ms.topic: example-scenario
ms.service: architecture-center
ms.subservice: example-scenario
ms.custom:
- fcp
---

# How to Observe and Make Changes to a Strawberry Farm in Real-Time

Tailwind is a farm that focuses on using greenhouses to produce strawberries. It currently has 5 greenhouses and is looking to expand in the future.

## Motivations

-   *What are the business challenges?*

-   *What is the estimated impact caused by these issues?*

Due to the erratic weather in the last few seasons, the quality of the strawberry crop has been inconsistent. This has resulted in an average drop in sales price to retailers, which has impacted Tailwind’s profits. 

## Current situation

-   *What are the current operation methods?*

There are a multitude of factors that affect the growth of strawberries. Some key parameters are:
-	Temperature: The optimal temperature varies depending on the variety of strawberries grown and the stage of growth.
-	Humidity: The level of humidity directly impacts plant growth as well as the occurrence of pests and airborne diseases.
-	Soil moisture: Strawberries thrive in dry conditions but still require some water in their shallow roots.
-	Soil acidity: Strawberries thrive in soil that is slightly more acidic with pH levels between 5.5 to 6.9 pH. 

Each day, Tailwind uses handheld sensors to measure the level of moisture in the soil. This is a manual process that is done several times throughout the day.

Similarly, the monitoring of soil acidity levels is a manual process where samples are taken and measured. The laborious nature of the process means that this is only done on a weekly basis. 

Meanwhile, the greenhouses also have temperature and humidity sensors, all of which must be manually recorded.

Relying on manual effort to collect data is time consuming, often with a high risk of human error and limitations regarding the amount of data that can be recorded. Without sufficient or complete information on key environmental factors, it is a challenge to achieve consistent or improved fruit quality. 

## Business Outcomes

-   *What business outcomes would you like to achieve?*

-   *What opportunities would this solution create for your business?*

To produce consistent high-quality strawberries which will fetch a premium selling price,   
Tailwind needs to know the exact conditions and factors that impact crop growth. This will enable it to maintain an optimal agricultural environment while responding in a timely and effective manner to address any anomalies. 

Beyond this, they are also looking at ways to have a better understanding of how their farming methods impact produce quality. With historical data over time, Tailwind would be able to identify the ideal growth conditions across the various greenhouses and conduct more in-depth analyses of the cost per acre versus profit per acre, enabling better business and operational decisions. With a comprehensive pool of correlated data, they believe that they will be able to develop a baseline farming method that is repeatable and profitable. 

## Solution to the challenges

-   *How can technology like Internet of Things (IoT) help solve your business challenges?*

Faced with numerous environmental variables that could directly impact crop growth, the ability to continuously collect and measure real-time data of key parameters is critical to farming operations. This would enable farmers to react immediately to correct undesirable conditions in order to create and maintain an optimal farming environment. 

Tailwind thinks that an IoT solution would be able to help them collect and measure real-time data across their farm, which would help them to achieve more consistent agricultural output. This includes collecting data (temperature) and getting insights (too cold) from it. From the insights derived, the farmers would be able to take effective action (adjust thermostat). 

![A diagram illustrating the relationship between devices, insights, and events in an IoT solution.](media/devices-events-insights.png)

The table below provides a summary of common use cases and the corresponding IoT solution. Each use case is an example of how an IoT process pattern can be applied in real-world scenarios. For more details on IoT process patterns, please refer to the detailed [documentation](./measure-and-control-loop.md).

Use case | Proposed solution | Process pattern
--- | --- | ---
Measuring temperature over time across different greenhouses. Adjust temperature when it goes past limits. | Temperature sensors sending data at set intervals to an application. Triggers thermostat to adjust automatically. | [Measure and control loop](./measure-and-control-loop.md)
Measuring humidity over time across different greenhouses. Set humidifying system when it goes past limits. | Hygrometer sending data at set intervals to an application. Triggers an alert when it goes pass thresholds. | [Measure and control loop](./measure-and-control-loop.md)
Measuring soil moisture over time across different greenhouses. Adjust moisture level when it goes past limits. | Soil moisture sensor sending data at set intervals to an application. Triggers an alert when it goes pass thresholds. | [Measure and control loop](./measure-and-control-loop.md)
Measuring soil acidity over time across different greenhouses. Adjust acidity when it goes past limits. | pH sensor sending data at set intervals to an application. Triggers an alert when it goes pass thresholds. | [Measure and control loop](./measure-and-control-loop.md)
Ability to see the status and conditions of all greenhouses remotely. | Application shows the status of all greenhouses with the ability to provide a deep dive into the details. | [Monitor and manage loop](./monitor-and-manage-loop.md)
Monitor the conditions over time and across all greenhouse to understand how conditions impact production and quality. | Monitor the conditions of all greenhouses and cross-reference the data with output quality and quantity. Analyze optimal growth conditions. | [Analyze and optimize loop](./analyze-and-optimize-loop.md)

## Appendix: Other areas for consideration

There are other key areas which a business like Tailwind would need to consider when building their IoT solution. These are listed below. 
-   *Data*

-   *Sensors and gateways*

-   *Connectivity*

-   *Device management*

-   *High availability, Disaster recovery*

-   *Security*

-   *Governance* 

For the agriculture industry, considerations regarding data, sensors and gateways, and connectivity are especially pertinent hence it is expounded as compared to the rest.

## Data

Understanding the details of the data collected will help with the selection of the right sensors and gateways. This also provides an initial sizing and helps in designing an effective solution. Some of the information may only be available after testing.

-   *What is the level of data accuracy required?*

-   *What is the number of sensors required to make it useful for you?*

-   *What is the data frequency required? Will the frequency vary?*

-   *What is the data classification?*

-   *How long will the data be retained?*

-   *What is the number of sensing points and required frequency of data collection?*

-   *How often should the application read the data?*

For example, Tailwind greenhouses are relatively big, and they currently take random
soil samples for testing. They estimate that the following is required
for one greenhouse. These estimates can be used to gain better clarity
of the IoT platform requirements. E.g. storage, queue, cloud gateway
etc.

**Sensor** | **Quantity** | **Accuracy** | **Frequency (Per day)** | **Classification** | **Retention**
--- | --- | --- | --- | --- | ---
Temperature | 5 | 1 decimal point | Every hour | Internal | At least 3 years
Humidity | 5 | 1 decimal point | Every 30 mins | Internal | At least 3 years
Soil moisture | 10 | 1 decimal point | Every 30 mins | Internal | At least 3 years
Soil acidity | 10 | 1 decimal point | Every hour | Internal | At least 3 years

## Sensors and Gateways

Understanding on-ground conditions will enable the right hardware selection.

-   *How would the environment conditions affect hardware choices? How
    durable is the product?*

-   *How much maintenance will the hardware require?*

-   *How will the hardware be powered?*

-   *How many sensors and gateways are required?*

-   *Do the sensors need to be calibrated?*

-   *Where should the sensors be placed for optimal reading? For example, for certain plants, soil moistures at a certain depth is crucial.*

-   *What are the regulatory requirements which may impact the hardware? For example, intrinsically safe requirements?*

-   *What other site and/or asset factors affect the hardware choices? For example, the asset being monitored cannot have sensors integrated into it in view of warranty violations.*

Because of the farming conditions, Tailwind will need to find hardware
which are of certain reliability and [ingress
protection](https://en.wikipedia.org/wiki/IP_Code) level to protect
against dust and water.

## Connectivity

Network selection can be complex due to site conditions as well as the data size and frequency requirements. 

-   *What kind of connectivity is available at the site?*

-   *What will happen to the business if the connectivity drops?*

-   *What other site factors affect the network choices? For example,
    are there many walls in the area that will interfere with
    connectivity?*

Some farm locations have poor connectivity which makes it difficult to
use mobile network solution in agriculture. Tailwinds will have to
consider that and also the power requirements when selecting the right
connectivity option.

## High Level considerations 

-   *Who are the users for this solution?*

-   *How will they be using the solution? (e.g. Web, mobile etc.)*

-   *What are other use cases which will be added in the future?*

-   *Buy vs build?*

-   *Are there any other systems that you would need to integrate with?*

-   *What is the current skill level of staff and what is the level of expertise they are expected to have?*
