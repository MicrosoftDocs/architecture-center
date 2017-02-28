---
title: Load Testing Synchronous I/O
description: 

author: dragon119
manager: christb

pnp.series.title: Optimize Performance
---
# Load Testing Synchronous I/O
[!INCLUDE [header](../../_includes/header.md)]

This document summarizes the configuration we used to perform load-testing for the SynchronousIO anti-pattern. You should also read about our [general approach][general approach] to deployment and load testing.

## Deployment

 Option             | Value  
------------------- | -------------
Compute             | Cloud Service
VM Size             | Large
Instance Count      | 2

## Test Configuration

The load test project included two webtests, each invoking an HTTP `GET` operation.

The URLs used were:

- http://yourservice.cloudapp.net/api/sync/getuserprofile
- http://yourservice.cloudapp.net/api/async/getuserprofileasync

Replace *yourservice* with the name of your cloud service.

The project also included two load tests, one for each web test. Both load tests were
run against a single deployment but at different times, using the following parameters:

Parameter           | Value
------------------- | ------------:
Initial User Count  | 1
Maximum User Count  | 4000
Step Duration       | 60s
Step Ramp Time      | 0s
Step User Count     | 400
Test Duration       | 15 minutes
Test Warm Up        | 30 seconds

The load test for the http://yourservice.cloudapp.net/api/sync/getuserprofile web test generated the following results:

![Load-test results][LoadTest1]

The load test for the http://yourservice.cloudapp.net/api/async/getuserprofileasync web test generated the following results:

![Load-test results][LoadTest2]

[general approach]: ../load-testing.md

[LoadTest1]: _images/SyncPerformance.jpg
[LoadTest2]: _images/AsyncPerformance.jpg

