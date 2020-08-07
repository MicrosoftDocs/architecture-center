---
title: Use IoT process loops for energy monitoring and management
titleSuffix: Azure Example Scenarios
description: See how a global integrated energy company can use real-time data and IoT process loops to design a monitoring and management solution.
author: mcosner
ms.date: 08/05/2020
ms.topic: example-scenario
ms.service: architecture-center
ms.subservice: example-scenario
ms.custom: fcp
---

# Energy monitoring and optimization solution

Contoso, a global integrated energy company, has capabilities across the energy and utilities value chain. Contoso owns assets like solar arrays, wind farms, and energy storage.

## Problem

There have been some data anomalies in Contoso's wind turbine output. To understand how wind turbines are operating, field engineers access the relevant operational data in a control center. The current telemetry application sends data in batches, so the information for analysis is a day late, and issues only surface later.

Also, Contoso's current forecasting application makes a best estimate of the wind farms’ generation rate, but results are often inaccurate. Contoso can't accurately forecast energy demand and supply, which makes it difficult to decide when to generate power for the grid instead of using renewable power from their wind farms and solar arrays. Without real-time data to form accurate energy production forecasts, Contoso is unable to achieve the business and operational agility it needs to succeed in the volatile energy trading market.

## Goals

Contoso wants the ability to view operating conditions remotely to reduce the effort and resources spent on commissioning and troubleshooting issues with wind turbines. Viewing operating conditions remotely will also decrease unplanned downtime, because Contoso can send field engineers on-site for maintenance with real-time condition data.

Contoso also wants to enable real-time monitoring and control of their integrated energy business. Accurate production forecasts will improve Contoso's operational efficiencies and help optimize its energy generation plan.

## Solution

Contoso wants to apply an Internet of Things (IoT) solution to provides real-time visibility of the power each wind turbine produces on a given day. The solution should determine how much to adjust power generators for demand-supply balance in the grid.

The following use cases are examples of applying Internet of Things (IoT) process patterns to this real-world scenario:

Use case|IoT solution|Pattern|
---|---|---|
Measure wind turbine vibrations to ensure optimal performance.|Accelerometers send data at set intervals to an application that trigger alerts when data exceeds set thresholds.|[Measure and control loop](measure-and-control-loop.md)|
Measure wind turbine blade angle to achieve optimum generation.|High Performance Liquid Chromatography (HPLC) sends pitch, yaw, and wind speed data at set intervals to an application, which controls blade angles to achieve optimal generation.|[Measure and control loop](measure-and-control-loop.md)|
Compare conditions like amount of energy generated, speed, RPM, and direction for different wind turbines in the same area.|The application overlays all real-time wind turbine data with historical data for operation analysis and anomaly detection and reporting.|[Monitor and manage loop](monitor-and-manage-loop.md)|
Optimize energy storage based on battery conditions and demand and supply forecasting.|An application optimizes storage based on remaining useful life (RUL) and projected energy demand and supply.|[Monitor and manage loop](monitor-and-manage-loop.md)|
Optimize power production.|An application optimizes different power generation plants based on energy market prices, demand and supply forecast. and energy storage.|[Analyze and optimize loop](analyze-and-optimize-loop.md)|

## Considerations

Contoso should also consider the following areas when building their IoT solutions:
- Data
- Sensors and gateways
- Connectivity
- Device management
- High availability and disaster recovery
- Security
- Governance

## See also
- [Measure and control loops](measure-and-control-loop.md)
- [Monitor and manage loops](monitor-and-manage-loop.md)
- [Analyze and optimize loops](analyze-and-optimize-loop.md)
- [Farm monitoring and management solution](strawberry-farm-example.md)
