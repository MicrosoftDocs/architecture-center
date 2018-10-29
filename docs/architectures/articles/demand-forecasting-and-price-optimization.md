---
title: Demand Forecasting and Price Optimization 
description: Pricing is recognized as a pivotal determinant of success in many industries and can be one of the most challenging tasks. Companies often struggle with several aspects of the pricing process, including accurately forecasting the financial impact of potential tactics, taking reasonable consideration of core business constraints, and fairly validating the executed pricing decisions. Expanding product offerings add further computational requirements to make real-time pricing decisions, compounding the difficulty of this already overwhelming task.
author: adamboeglin
ms.date: 10/29/2018
---
# Demand Forecasting and Price Optimization 
Pricing is recognized as a pivotal determinant of success in many industries and can be one of the most challenging tasks. Companies often struggle with several aspects of the pricing process, including accurately forecasting the financial impact of potential tactics, taking reasonable consideration of core business constraints, and fairly validating the executed pricing decisions. Expanding product offerings add further computational requirements to make real-time pricing decisions, compounding the difficulty of this already overwhelming task.
This solution addresses the challenges raised above by utilizing historical transaction data to train a demand forecasting model. Pricing of products in a competing group is also incorporated to predict cross-product impacts such as cannibalization. A price optimization algorithm then employs the model to forecast demand at various candidate price points and takes into account business constraints to maximize profit. The solution can be customized to analyze various pricing scenarios as long as the general data science approach remains similar.
The process described above is operationalized and deployed in the Cortana Intelligence Suite. This solution will enable companies to ingest historical transaction data, predict future demand, and obtain optimal pricing recommendations on a regular basis. As a result, the solution drives opportunities for improved profitability and reductions in time and effort allocated to pricing tasks.

## Architecture
<img src="media/demand-forecasting-and-price-optimization.svg" alt='architecture diagram' />