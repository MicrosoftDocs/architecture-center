---
title: Example monitoring and management loops for a strawberry farm
titleSuffix: Azure Example Scenarios
description: An IoT customer scenario in the agricultural domain that monitors and manages greenhouse conditions in real-time.
author: mcosner
ms.date: 08/04/2020
ms.topic: example-scenario
ms.service: architecture-center
ms.subservice: example-scenario
ms.custom: fcp
---

# Strawberry farm real-time monitoring and management example

Tailwind is a farm that grows strawberries in greenhouses. Tailwind currently has five greenhouses and wants to expand in the future.

Many factors affect strawberry growth. Some key parameters are:
- Temperature: The optimal temperature varies depending on the variety of strawberries grown and the stage of growth.
- Humidity: The level of humidity directly impacts plant growth as well as the occurrence of pests and airborne diseases.
- Soil moisture: Strawberries thrive in dry conditions, but still require some water in their shallow roots.
- Soil acidity: Strawberries thrive in soil that is slightly acidic, with pH levels between 5.5 to 6.9 pH.

Tailwind uses handheld sensors to manually measure soil moisture several times a day. Measuring soil acidity levels is a laborious manual process of taking and measuring samples weekly. The greenhouses also have temperature and humidity sensors with readings that must be manually recorded. Manual data collection is time consuming, error prone, and limited regarding the amount of data that can be recorded. Without sufficient or complete information on key environmental factors, achieving consistent or improved fruit quality is a challenge.

Due to erratic weather in the last few seasons, the quality of the strawberry crop has been inconsistent. This has resulted in an average drop in sales price to retailers, which has impacted Tailwind’s profits. To produce consistent high-quality strawberries that will fetch a premium price, Tailwind needs to know the exact conditions and factors that impact crop growth. This data will enable Tailwind to maintain an optimal agricultural environment while responding to anomalies in a timely and effective manner.

With many environmental variables that directly impact crop growth, the ability to continuously collect and measure real-time key parameter data is critical to farming operations. Real-time data would let farmers react immediately to correct undesirable conditions and create and maintain an optimal farming environment.

Tailwind is also looking at ways to better understand how their farming methods impact produce quality. Tailwind hopes to use historical data over time to identify ideal growth conditions across the various greenhouses, and conduct more in-depth analyses of the cost per acre versus profit per acre. With a comprehensive pool of correlated data, Tailwind will be able to develop a baseline farming method that is repeatable and profitable, and make better business and operational decisions.

Tailwind wants an IoT solution to help them collect and measure real-time data across their farm, which will help them achieve more consistent agricultural output. The solution should include collecting data like temperature, getting insights from the data like "too cold," and taking effective actions like adjusting thermostats. 

The following use cases are examples of applying IoT process patterns to this real-world scenario:

Use case|IoT solution|Process pattern
--- | --- | ---
Measure temperature over time across different greenhouses, and adjust temperature when it goes past limits.|Temperature sensors send data at set intervals to an application, which triggers the thermostat to adjust automatically.|[Measure and control loop](measure-and-control-loop.md)
Measure humidity over time across different greenhouses, and adjust the humidifying system when it goes past limits.|A hygrometer sends data at set intervals to an application, which triggers an alert when humidity goes pass thresholds.|[Measure and control loop](measure-and-control-loop.md)
Measure soil moisture over time across different greenhouses, and adjust moisture level when it goes past limits.|Soil moisture sensors send data at set intervals to an application, which triggers an alert when moisture goes pass thresholds.|[Measure and control loop](measure-and-control-loop.md)
Measure soil acidity over time across different greenhouses, and adjust acidity when it goes past limits.|A pH sensor sends data at set intervals to an application, which triggers an alert when acidity goes past thresholds.|[Measure and control loop](./measure-and-control-loop.md)
See the status and conditions of all greenhouses remotely.|An application shows the status of all greenhouses, with the ability to provide a deep dive into the details.|[Monitor and manage loop](monitor-and-manage-loop.md)
Monitor conditions over time across all greenhouse to understand how conditions impact production and quality.|Monitor the conditions of all greenhouses, cross-reference the data with output quality and quantity, and analyze optimal growth conditions.|[Analyze and optimize loop](analyze-and-optimize-loop.md)

Tailwind should also consider the following factors when building their IoT solution:
- Data
- Sensors and gateways
- Connectivity
- Device management
- High availability and disaster recovery
- Security
- Governance

For the agriculture industry, data, sensors and gateways, and connectivity are especially important.

## Data

Understanding data details helps select the right sensors and gateways, provides initial sizing, and helps design an effective solution. Some of the information may only be available after testing.

-   *What is the level of data accuracy required?*
-   *What is the number of sensors required to make it useful for you?*
-   *What is the data frequency required? Will the frequency vary?*
-   *What is the data classification?*
-   *How long will the data be retained?*
-   *What is the number of sensing points and required frequency of data collection?*
-   *How often should the application read the data?*

For example, Tailwind greenhouses are large, and currently take random soil samples for testing. Tailwind estimates the following data collection requirements for one greenhouse. These estimates can be used to gain better clarity of the IoT platform storage, queue, and cloud gateway requirements.

Sensor|Quantity|Accuracy|Frequency|Classification|Retention|
--- | --- | --- | --- | --- | ---|
Temperature | 5 | 1 decimal point | Every hour | Internal | At least 3 years|
Humidity | 5 | 1 decimal point | Every 30 mins | Internal | At least 3 years|
Soil moisture | 10 | 1 decimal point | Every 30 mins | Internal | At least 3 years|
Soil acidity | 10 | 1 decimal point | Every hour | Internal | At least 3 years|

## Sensors and gateways

Understanding on-ground conditions will enable the right hardware selection.

-   *How would the environment conditions affect hardware choices? How durable is the product?*
-   *How much maintenance will the hardware require?*
-   *How will the hardware be powered?*
-   *How many sensors and gateways are required?*
-   *Do the sensors need to be calibrated?*
-   *Where should the sensors be placed for optimal reading? For example, for certain plants, soil moistures at a certain depth is crucial.*
-   *What are the regulatory requirements which may impact the hardware? For example, intrinsically safe requirements?*
-   *What other site and/or asset factors affect the hardware choices? For example, the asset being monitored cannot have sensors integrated into it in view of warranty violations.*

Because of the farming conditions, Tailwind will need to find hardware of certain reliability and [ingress protection](https://en.wikipedia.org/wiki/IP_Code) level to protect against dust and water.

## Connectivity

Network selection can be complex due to site conditions as well as the data size and frequency requirements. 

-   *What kind of connectivity is available at the site?*
-   *What will happen to the business if the connectivity drops?*
-   *What other site factors affect the network choices? For example, are there many walls in the area that will interfere with connectivity?*

Some farm locations have poor connectivity, which makes it difficult to use mobile network solution in agriculture. Tailwinds will have to consider that and also the power requirements when selecting the right connectivity option.

## High-level considerations

-   *Who are the users for this solution?*
-   *How will they be using the solution? (e.g. Web, mobile etc.)*
-   *What are other use cases which will be added in the future?*
-   *Buy vs build?*
-   *Are there any other systems that you would need to integrate with?*
-   *What is the current skill level of staff and what is the level of expertise they are expected to have?*
