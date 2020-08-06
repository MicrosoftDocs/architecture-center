---
title: Example energy monitoring and management loops
titleSuffix: Azure Example Scenarios
description: A customer scenario utilizing real-time data to understand power generation output and needs for a wind farm.
author: mcosner
ms.date: 08/05/2020
ms.topic: example-scenario
ms.service: architecture-center
ms.subservice: example-scenario
ms.custom: fcp
---

# Energy monitoring and optimization example

Contoso, a global integrated energy company, has capabilities across the energy and utilities value chain. Contoso owns assets like solar arrays, wind farms, and energy storage.

To understand how each wind turbine is operating, field engineers access the relevant operational data in the control center. There have been some data anomalies in Contoso's wind turbine output. The current application sends telemetry data in batches, so the information for analysis is a day late, and issues only surface later.

Also, Contoso's current forecasting application makes a best estimate of the wind farms’ generation rate, but results are often not very accurate. Contoso can't accurately forecast energy demand and supply, which makes it difficult to decide when to generate power for the grid instead of using renewable power from their wind farms and solar arrays. Without real-time data to form accurate energy production forecasts, Contoso is unable to achieve the business and operational agility it needs to succeed in the volatile energy trading market.

Ideally, Contoso wants the ability to view its operating conditions remotely to reduce the effort and resources spent on commissioning and troubleshooting issues with the wind turbines. Viewing operating conditions remotely will also decrease unplanned downtime, because Contoso can send field engineers on-site for maintenance with real-time condition data.

Contoso wants to apply an Internet of Things (IoT) solution to enable real-time monitoring and control of their integrated energy business. The solution should provide accurate production forecasts to improve Contoso's operational efficiencies and help optimize its energy generation plan. Application features should include providing real-time visibility of the power each wind turbine produces on a given day, and how much power generators should be adjusted for demand-supply balance in the grid.

The following use cases are examples of applying IoT process patterns to this real-world scenario:

Use case|IoT solution|Process pattern
--- | --- | ---
Measure wind turbine vibrations to ensure optimal performance.|Accelerometers send data at set intervals to an application that trigger alerts when data exceeds set thresholds.|[Measure and control loop](measure-and-control-loop.md)
Measure wind turbine blade angle to achieve optimum generation.|High Performance Liquid Chromatography (HPLC) sends pitch, yaw, and wind speed data at set intervals to an application, which controls blade angles to achieve optimal generation.|[Measure and control loop](measure-and-control-loop.md)
Compare conditions like amount of energy generated, speed, RPM, and direction for different wind turbines in the same area.|The application overlays all real-time wind turbine data with historical data for operation analysis and anomaly detection and reporting.|[Monitor and manage loop](monitor-and-manage-loop.md)
Optimize energy storage based on battery conditions and demand and supply forecasting.|An application optimizes storage based on remaining useful life (RUL) and projected energy demand and supply.|[Monitor and manage loop](monitor-and-manage-loop.md)
Optimize power production.|An application optimizes different power generation plants based on energy market prices, demand and supply forecast. and energy storage.|[Analyze and optimize loop](analyze-and-optimize-loop.md)

Contoso should also consider the following areas when building their IoT solutions:
- Data
- Sensors and gateways
- Connectivity
- Device management
- High availability and disaster recovery
- Security
- Governance
