---
title: Load Testing Busy Database
description: 

author: dragon119
manager: christb

pnp.series.title: Optimize Performance
---
# Load Testing Busy Database <<RBC: Not sure how this content will be published/displayed. If it's a separate page should we say: Load Testing the Busy Database Antipattern or something else that's more descriptive. That way people who may come in through search know this is related to the antipattern? Also, if it's s separate page I'd make the pattern name below a link so people can easily get to it.>>
[!INCLUDE [header](../../_includes/header.md)]

This document summarizes the configuration we used to perform load testing for the Busy Database antipattern. You should also read about our [general approach][general approach] to deployment and load testing.

## Deployment

 Option             | Value  
------------------- | -------------
Compute             | Cloud Service
VM Size             | Large
Instance Count      | 1
SQL Tier            | P3
Max Pool Size       | 4000

## Test Configuration

The load test project included two web tests, each invoking an HTTP `GET` operation.

The URLs used were:

- http://yourservice.cloudapp.net/toomuchprocsql/get/{orderid}
- http://yourservice.cloudapp.net/lessprocsql/get/{orderid}

Replace *yourservice* with the name of your cloud service, and
replace *{orderid}* with an order number generated using the *Generate Random
Integer* plugin.

The project also included two load tests, one for each web test. Both load tests were
run against a single deployment but at different times, using the following parameters:

Parameter           | Value
------------------- | ------------:
Initial User Count  | 1
Maximum User Count  | 50
Step Duration       | 30s
Step Ramp Time      | 0s
Step User Count     | 1
Test Duration       | 30 minutes
Test Warm Up        | 30 seconds

The load test for the http://yourservice.cloudapp.net/toomuchprocsql/get/{orderid} web test generated the following results:

![Load-test results][ProcessingInDatabaseLoadTest]

The load test for the http://yourservice.cloudapp.net/lessprocsql/get/{orderid} web test generated the following results:

![Load-test results][ProcessingInClientApplicationLoadTest]

[general approach]: ../load-testing.md
[ProcessingInDatabaseLoadTest]: _images/ProcessingInDatabaseLoadTest.jpg
[ProcessingInClientApplicationLoadTest]: _images/ProcessingInClientApplicationLoadTest.jpg
