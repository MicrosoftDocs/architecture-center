---
title: Customer 360 
description: A deep understanding between customer interests and purchasing patterns is a critical component of any retail business intelligence operation. This solution implements a process of aggregating customer data into a 360 degree profile, and uses advanced machine learning models backed by the reliability and processing power of Azure to provide predictive insights on simulated customers.
author: adamboeglin
ms.date: 10/18/2018
---
# Customer 360 
A deep understanding between customer interests and purchasing patterns is a critical component of any retail business intelligence operation. This solution implements a process of aggregating customer data into a 360 degree profile, and uses advanced machine learning models backed by the reliability and processing power of Azure to provide predictive insights on simulated customers.

## Architecture
<img src="media/customer-360.svg" alt='architecture diagram' />

## Data Flow
1. A Data Generator pipes simulated customer events to an Event Hub
1. A Stream Analytics job reads from the EventHub, performs aggregations
1. Stream Analytics persists time-grouped data to an Azure Storage Blob
1. A Spark job running in HDInsight merges the latest customer browsing data with historical purchase and demographic data to build a consolidated user profile
1. A second Spark job scores each customer profile against a machine learning model to predict future purchasing patterns (i.e., is a given customer likely to make a purchase in the next 30 days, and if so, in which product category?)
1. Predictions and other profile data are visualized and shared as charts and tables in Power BI Online