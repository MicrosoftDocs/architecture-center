---
title: Load Testing No Caching
description: 

author: dragon119
manager: christb

pnp.series.title: Optimize Performance
---
# Load Testing No Caching
[!INCLUDE [header](../../_includes/header.md)]

This document summarizes the configuration we used to perform load testing for the No Caching antipattern. You should also read about our [general approach][general approach] to deployment and load testing.

## Deployment

 Option             | Value  
------------------- | -------------
Compute             | Cloud Service
VM Size             | Large
Instance Count      | 2
SQL Tier            | S1
Max Pool Size       | 1000
Redis Cache         | S1


## Test Configuration

The load test project included 10 web tests, each invoking an HTTP `GET` operation.

The URLs used were:

- http://yourservice.cloudapp.net/api/nocache/getperson/{Id}
- http://yourservice.cloudapp.net/api/nocache/getcustomer/{Id}
- http://yourservice.cloudapp.net/api/nocache/getemployee/{Id}
- http://yourservice.cloudapp.net/api/nocache/gettoptensalesorders
- http://yourservice.cloudapp.net/api/nocache/gettoptensalespeople
- http://yourservice.cloudapp.net/api/cache/getperson/{Id}
- http://yourservice.cloudapp.net/api/cache/getcustomer/{Id}
- http://yourservice.cloudapp.net/api/cache/getemployee/{Id}
- http://yourservice.cloudapp.net/api/cache/gettoptensalesorders
- http://yourservice.cloudapp.net/api/cache/gettoptensalespeople


Replace *yourservice* with the name of your cloud service, and
replace *{Id}* with an ID generated using the *Generate Random
Integer* plugin.

The project also included two load tests, one for the *nocache* web tests and another
for the *cache* web tests. The web tests in each load test were distributed evenly
(20%). Both load tests were run against a single deployment but at different times,
using the following parameters:

Parameter           | Value
------------------- | ------------:
Initial User Count  | 1
Maximum User Count  | 800
Step Duration       | 60s
Step Ramp Time      | 60s
Step User Count     | 75
Test Duration       | 15 minutes
Test Warm Up        | 30 seconds

The load test for the *nocache* web test generated the following results:

![Load-test results][LoadTest1]

The load test for the *cache* web test generated the following results:

![Load-test results][LoadTest2]

[general approach]: ../load-testing.md

[LoadTest1]: _images/InitialLoadTestResults.jpg
[LoadTest2]: _images/CachedLoadTestResults.jpg
