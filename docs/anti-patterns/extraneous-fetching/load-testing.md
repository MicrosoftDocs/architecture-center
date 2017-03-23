---
title: Load Testing Extraneous Fetching
description: 

author: dragon119
manager: christb

pnp.series.title: Optimize Performance
---
# Load Testing Extraneous Fetching
[!INCLUDE [header](../../_includes/header.md)]

This document summarizes the configuration we used to perform load testing for the Extraneous Fetching antipattern. You should also read about our [general approach][general approach] to deployment and load testing.

## Deployment

 Option             | Value  
------------------- | -------------
Compute             | Web App
Tier                | P1
Instance Count      | 1
SQL Tier            | P3
Max Pool Size       | 1000

## Test Configuration

The load test project included four web tests, each invoking an HTTP `GET` operation.

The URLs used were:

- http://yourwebapp.azurewebsites.net/api/allfields
- http://yourwebapp.azurewebsites.net/api/requiredfields
- http://yourwebapp.azurewebsites.net/api/aggregateonclient
- http://yourwebapp.azurewebsites.net/api/aggregateondatabase

Replace *yourwebapp* with the name of your web application.

The project also included four load tests, one for each web test. All load tests were
run against a single deployment but at different times, using the following parameters:

Parameter           | Value
------------------- | ------------:
Initial User Count  | 1
Maximum User Count  | 400
Step Duration       | 60s
Step Ramp Time      | 60s
Step User Count     | 40
Test Duration       | 15 minutes
Test Warm Up        | 30 seconds

The load test for the http://yourwebapp.azurewebsites.net/api/allfields web test generated the following results:

![Load-test results][AllFields]

The load test for the http://yourwebapp.azurewebsites.net/api/requiredfields web test generated the following results:

![Load-test results][RequiredFields]

The load test for the http://yourwebapp.azurewebsites.net/api/aggregateonclient web test generated the following results:

![Load-test results][AggregateOnClient]

The load test for the http://yourwebapp.azurewebsites.net/api/aggregateondatabase web test generated the following results:

![Load-test results][AggregateOnDatabase]

[general approach]: ../load-testing.md

[AllFields]: _images/LoadTestResultsClientSide1.jpg
[RequiredFields]: _images/LoadTestResultsDatabaseSide1.jpg
[AggregateOnClient]: _images/LoadTestResultsClientSide2.jpg
[AggregateOnDatabase]: _images/LoadTestResultsDatabaseSide2.jpg
