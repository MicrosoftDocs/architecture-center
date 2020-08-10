---
title: IoT process loops for farm monitoring and management
titleSuffix: Azure Example Scenarios
description: Learn about an IoT agricultural solution that monitors and manages greenhouse conditions in real-time using IoT process loops.
author: mcosner
ms.date: 08/04/2020
ms.topic: example-scenario
ms.service: architecture-center
ms.subservice: example-scenario
ms.custom: fcp
---

# IoT farm monitoring and management solution

Tailwind is a farm that grows strawberries in greenhouses. Tailwind currently has five greenhouses and wants to expand in the future.

This article describes how Tailwind can use Internet-of-Things (IoT) process loops to design a real-time greenhouse monitoring and management solution.

## Problem

Many factors affect strawberry growth. Some key parameters are:
- Temperature: The optimal temperature varies depending on the variety of strawberries grown and the stage of growth.
- Humidity: The level of humidity directly impacts plant growth, as well as the occurrence of pests and airborne diseases.
- Soil moisture: Strawberries thrive in dry conditions, but still require some water in their shallow roots.
- Soil acidity: Strawberries thrive in soil that is slightly acidic, with pH levels between 5.5 to 6.9 pH.

Tailwind uses handheld sensors to manually measure soil moisture several times a day. Measuring soil acidity levels is a laborious manual process of taking and measuring soil samples weekly. The greenhouses also have temperature and humidity sensors that require manual reading and recording. Manual measurements and data collection are time consuming, error prone, and limited in quantity and frequency. Without sufficient or complete information on key environmental factors, achieving consistent or improved fruit quality is a challenge.

Due to erratic weather the past few seasons, strawberry crop quality has been inconsistent. Inconsistent quality has caused an average drop in sales price to retailers, which has impacted Tailwind’s profits. 

## Goals

With many environmental variables that directly impact crop growth, the ability to continuously collect and measure real-time key parameter data is critical to farming operations. Real-time data will enable Tailwind to create and maintain an optimal farming environment, while responding to undesirable conditions and anomalies in a timely and effective manner.

Tailwind also wants to better understand how their farming methods impact produce quality. To produce consistent high-quality strawberries that will fetch a premium price, Tailwind needs to know the exact conditions and factors that impact crop growth. Tailwind hopes to use historical data over time to identify ideal growth conditions across greenhouses, and conduct in-depth analyses of cost versus profit per acre. With a comprehensive pool of correlated data, Tailwind can develop a baseline farming method that is repeatable and profitable, and make better business and operational decisions.

## Solution

Tailwind wants an IoT solution to help them collect and measure real-time data across their farm, which will help them achieve more consistent agricultural output. The solution should include collecting data like temperature, getting insights from the data like temperature too hot or cold, and taking effective actions like adjusting thermostats.

The following use cases are examples of applying IoT process loop patterns to this real-world scenario:

Use case|IoT solution|Pattern|
---|---|---|
Measure temperature over time across different greenhouses, and adjust temperature when it goes past limits.|Temperature sensors send data at set intervals to an application, which triggers the thermostat to adjust automatically.|[Measure and control loop](measure-and-control-loop.md)|
Measure humidity over time across different greenhouses, and adjust the humidifying system when it goes past limits.|A hygrometer sends data at set intervals to an application, which triggers an alert when humidity goes past thresholds.|[Measure and control loop](measure-and-control-loop.md)|
Measure soil moisture over time across different greenhouses, and adjust moisture level when it goes past limits.|Soil moisture sensors send data at set intervals to an application, which triggers an alert when moisture goes past thresholds.|[Measure and control loop](measure-and-control-loop.md)|
Measure soil acidity over time across different greenhouses, and adjust acidity when it goes past limits.|A pH sensor sends data at set intervals to an application, which triggers an alert when acidity goes past thresholds.|[Measure and control loop](./measure-and-control-loop.md)|
See the status and conditions of all greenhouses remotely.|An application shows the status of all greenhouses, with the ability to provide a deep dive into the details.|[Monitor and manage loop](monitor-and-manage-loop.md)|
Monitor conditions over time across all greenhouse to understand how conditions impact production and quality.|Monitor the conditions of all greenhouses, cross-reference the data with output quality and quantity, and analyze optimal growth conditions.|[Analyze and optimize loop](analyze-and-optimize-loop.md)|

## Considerations

Tailwind should also consider the following factors when building their IoT solution:
- Data
- Sensors and gateways
- Connectivity
- Device management
- High availability and disaster recovery
- Security
- Governance

For the agriculture industry, data, sensors and gateways, and connectivity are especially important.

### Data

Understanding data details helps select the right sensors and gateways, and provides initial sizing to help design an effective solution.

To determine data needs, consider the following factors. Some of the information may be available only after testing.
- Data accuracy requirements
- Optimal number of sensors and sensing points
- Data collection frequency and variability
- Data read frequency
- Data classification
- Data retention requirements

For example, Tailwind greenhouses are large, and currently take random soil samples for testing. For their IoT solution, Tailwind estimates that each greenhouse will need five temperature sensors, five humidity sensors, 10 soil moisture sensors, and 10 soil acidity sensors. The sensors must be accurate within one decimal point, and collect data every 30 minutes. Data will be classified as internal, and retained for at least three years.

### Sensors and gateways

Understanding on-ground conditions enables the right hardware selection. To determine hardware requirements, consider the following factors:

- Environment conditions and hardware durability. Because of farming conditions, Tailwind will need to find hardware of certain reliability and [ingress protection](https://en.wikipedia.org/wiki/IP_Code) levels to protect against dust and water.
- Hardware maintenance requirements
- Hardware power sources and requirements
- Number of required sensors and gateways
- Sensor calibration requirements
- Sensor location for optimal reading. For example, soil moisture at a certain depth may be crucial.
- Regulatory requirements and intrinsically safe requirements that impact the hardware
- Other site and asset factors that affect hardware choices. For example, an asset that needs to be monitored may not be able to have sensors integrated into it because of warranty restrictions.

### Connectivity

Network selection can be complex due to site conditions as well as data size and collection frequency requirements. Some farm locations have poor connectivity, which makes it difficult to use mobile network solutions in agriculture. To select the right connectivity option, Tailwinds must consider connectivity challenges, power requirements, and factors like:

- Type of connectivity available at the site
- Effect on the business if connectivity drops
- Other site factors that affect network choices. For example, many walls in the area can interfere with connectivity.

### Other considerations

Tailwinds should also consider the following factors when designing their IoT solution:
- Solution user roles, and current and expected staff skill levels
- How users access the solution, such as web or mobile
- Other use cases to be added in future
- Whether to buy or build a solution
- Need to integrate with other systems

## See also
- [Measure and control loops](measure-and-control-loop.md)
- [Monitor and manage loops](monitor-and-manage-loop.md)
- [Analyze and optimize loops](analyze-and-optimize-loop.md)
- [Energy monitoring and optimization solution](energy-domain-example.md)
