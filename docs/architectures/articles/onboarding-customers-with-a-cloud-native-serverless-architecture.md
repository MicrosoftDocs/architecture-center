---
title: Serverless Computing Solution for LOB Apps 
description: The solution demonstrates a business process for customer onboarding. This serverless architecture enables you to build and run applications without having to worry about the underlying infrastructure and the associated management and maintenance. By using it, you can dramatically improve developer productivity.
author: adamboeglin
ms.date: 10/29/2018
---
# Serverless Computing Solution for LOB Apps 
This serverless architecture enables you to build and run applications without having to worry about the underlying infrastructure and the associated management and maintenance. By using it, you can dramatically improve developer productivity.

## Architecture
<img src="media/onboarding-customers-with-a-cloud-native-serverless-architecture.svg" alt='architecture diagram' />

## Data Flow
1. Information about the new customer is posted to a web endpoint.
1. The customers photo is posted to Cognitive Services Face API. Face API associates
the customers photo and name.
1. The customer information is recorded in Dynamics 365 or other CRM.
1. The information about a new customer is sent to PowerBI.
1. The customer information is added to the mailing list (MailChimp).
1. The solution creates a record of the member in SQL Database.