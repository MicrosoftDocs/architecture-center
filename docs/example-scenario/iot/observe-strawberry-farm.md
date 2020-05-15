---
title: Observe and Make Changes to a Strawberry Farm
titleSuffix: Azure Example Scenarios
description: A customer scenario in the agricultural domain to monitor and make changes to greenhouse conditions in real-time using Azure IoT.
author: mcosner
ms.date: 05/04/2020
ms.topic: example-scenario
ms.service: architecture-center
ms.subservice: example-scenarios
ms.custom:
- fcp
---

# How to Observe and Make Changes to a Strawberry Farm in Real-Time

Tailwind is a farm that focuses on using greenhouses to produce
strawberries. They currently have 5 greenhouses and is looking to expand
in the future.

## Motivations

-   *What are the business use cases and pain points?*

-   *What is the estimated impact to the business?*

Due to the erratic weather in the last few seasons, the strawberries
quality has been impacted. This has resulted in lower sales price
because the retailers are looking for specific size and consistent
quality. This has resulted in an average drop in sales price.

## Business Outcomes and Justifications

-   *Which business outcomes would be achieved?*

-   *What opportunities would this solution create for your business?*

-   *What will success look like?*

Tailwind wants to have timely visibility of the greenhouse conditions so
that they can respond timely. This will help produce high quality
strawberries which will fetch a premium selling price. They are also
looking at ways to have a better understanding how their farming methods
impact the produce quality. With historical data over time, Tailwind
will be able to know the growing conditions across the different
greenhouses and how it affects the produce's consistency and quality. In
the long run, they would like to have a set of baselines for the growing
conditions correlating to inputs used and output quality and quantity.

## Current situation

-   *What is the current situation?*

Tailwind uses handheld sensors to measure the soil moisture every day,
but there are times which it is missed out. Soil acidity is a manual and
laborious process whereby they take samples for measurements. They have
temperature and humidity sensors in each of the greenhouses which needs
to be manually recorded. After these data points are measured, the
farmers will adjust the farm conditions accordingly based on their
experience.

## Requirements for IoT solution

-   *What impacts the quality of fruits?*

There are multitude of factors that affect the growth of strawberries.
Some key conditions are:

-   Temperature: Varies depending on variety and the stage of growth.

-   Humidity: Not only it impacts the plants, it also impacts the pest
    and air diseases.

-   Soil moisture: Strawberries thrive in dry conditions but still
    requires some water in the shallow roots.

-   Soil acidity: Soil that are slightly more acidic is better for
    strawberries.

Tailwind has heard that IoT solutions which uses sensors (device) to
provide real time data so that actions can be taken. 

![A diagram illustrating the relationship between devices, insights, and events in an IoT solution.](media/devices-events-insights.png)

Depending on the requirements, the scenario can be mapped using common IoT patterns in the table below.

Use case | Proposed solution | Process pattern
--- | --- | ---
Measuring temperature over time across the different greenhouses. Adjust temperature when it goes past limits. | Temperature sensors sending data at set interval to an application. Trigger thermostat to adjust automatically. | [Measure and control loop](./measure-and-control-loop.md)
Measuring humidity over time across the different greenhouses. Set humidifying system when it goes past limits. | Hygrometer sending data at set interval to an application. Trigger an alert when it goes past thresholds. | [Measure and control loop](./measure-and-control-loop.md)
Measuring soil moisture over time across the different greenhouses. Adjust moisture level when it goes past limits. | Soil moisture sensor sending data at set interval to an application. Trigger an alert when it goes pass thresholds. | [Measure and control loop](./measure-and-control-loop.md)
Measuring soil acidity over time across the different greenhouses. Adjust acidity when it goes past limits. | pH sensor sending data at set interval to an application. Trigger an alert when it goes past thresholds. | [Measure and control loop](./measure-and-control-loop.md)
Ability to see the status and conditions of the all the greenhouses remotely. | Application shows the status of all the greenhouses with the ability to drill down to detailed information. | Monitor and manage loop
Monitor the conditions over time and across greenhouse to understand how conditions impact production and quality. | Monitor all the conditions of the greenhouses and cross reference to output quality and quantity. Analyze optimum growth conditions. | Analyze and optimize loop

## Appendix: Areas for consideration

Below are areas which Tailwind will need to consider when looking into
the solution. Whilst this document will not delve deep into each aspect,
there are a list of questions to understand the thinking.

## Data requirements

Understanding the details of the data will help the selection of sensors
and gateways. This also provides an initial sizing and helps in design
of the solution. Some of the information may only be available after
testing.

-   *What is the level of data accuracy required?*

-   *What is the number of sensing required to make it useful for you?*

-   *What is the data frequency required? Will this be required to
    change?*

-   *What is the data classification?*

-   *How long will the data be retained?*

-   *Will there be a need to change the frequency of the data?*

-   *What is the amount of sensing points and the frequency?*

-   *How often does the application read the data?*

Tailwind' greenhouses are relatively big, and they currently take random
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

## Things requirements

Understanding on the ground conditions will impact the hardware
selection.

-   *How would the environment conditions affect hardware choices? How
    durable is the product?*

-   *How much maintenance will the hardware require?*

-   *How will the hardware be powered?*

-   *How many sensors and gateways are required?*

-   *Do the sensors need to be calibrated?*

-   *Where should the sensors be placed for optimum reading? For
    example, depending on the plant, soil moistures at certain depth is
    crucial.*

-   *What are the regulatory requirements which may impact the hardware?
    For example, intrinsically safe requirements.*

-   *What other site and/or asset factors affect the hardware choices?
    For example, the asset being monitored cannot have sensors
    integrated into it due to warranty violations.*

Because of the farming conditions, Tailwind will need to find hardware
which are of certain reliability and [ingress
protection](https://en.wikipedia.org/wiki/IP_Code) level to protect
against dust and water.

## Connectivity requirements

The network selection can be complex due to the site conditions and the
data size and frequency requirements.

-   *What connectivity is available at the site?*

-   *What will happen to the business if the connectivity drops?*

-   *What other site factors affect the network choices? For example,
    are there many walls in the area that will interfere with
    connectivity?*

Some farm locations have poor connectivity which makes it difficult to
use mobile network solution in agriculture. Tailwinds will have to
consider that and also the power requirements when selecting the right
connectivity option.

## Device Management

-   *What is the life cycle of the device?*

-   *How do you update the devices firmware?*

-   *How do you update the devices software?*

## High Level considerations 

-   *Who are the personas using this solution?*

-   *How will they be using the solution? (e.g. Web, mobile etc)*

-   *What are the other use cases which will be added in the future?*

-   *What is the level of control required for the development of the
    solution? For example, do you need to have specific?*

-   *What are systems do you need to integrate with?*

-   *Buy vs build?*

-   *What is the current skill level of staff and envisioned where they
    would be?*

### HA/DR

-   *What is the maximum targeted period in which data might be lost if
    the application goes down?*

-   *What is is the targeted duration of time in which the application
    must be restored after a disruption in order to avoid unacceptable
    consequences associated with the downtime?*

-   *What will be the issue if the network is not available to send data
    to the application?*

### Security

-   *What are the company's data in motion encryption policies?*

-   *What are the users of the solution and what are their respective
    access controls?*

-   *How do you prevent tampering of the hardware?*

### Governance

-   *What are the industrial regulations that you need to adhere to?*

-   *What are the governmental regulations that you need to adhere to?*

### Operations

-   *How are you monitoring your applications and devices status?*
