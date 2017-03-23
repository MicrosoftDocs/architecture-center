---
title: Optimize Performance for Cloud Applications
description: 

author: dragon119
manager: christb

pnp.series.title: Optimize Performance
---
# Load Testing Busy Front End
[!INCLUDE [header](../../_includes/header.md)]

This document summarizes the configuration we used to perform load testing for the Busy Front End antipattern. You should also read about our [general approach][general approach] to deployment and load testing.

## Deployment

 Option             | Value  
------------------- | -------------
Compute             | Cloud Service
VM Size             | Large
Instance Count      | 1

## Test Configuration

The load test project included three web tests, invoking HTTP `POST` operations over the `workinfrontend` and `workinbackground` controllers, and an HTTP `GET` operation for the `userprofile` controller.

The URLs used for the HTTP `POST` operations were:

- http://yourservice.cloudapp.net/api/workinfrontend
- http://yourservice.cloudapp.net/api/workinbackground

The URL used for the HTTP `GET` operation was:

- http://yourservice.cloudapp.net/api/userprofile

In all cases, replace *yourservice* with the name of your cloud service.

The project also included two load tests, one for each of the two `POST` web tests.
Each load test contained two concurrent scenarios configured as follows:

- Scenario 1 (`UserProfile` - constant load pattern)

Parameter           | Value
------------------- | ------------:
Constant User Count | 500
Test Duration       | 5 minutes
Test Warm Up        | 30 seconds

- Scenario 2 (`WorkInFrontEnd` or `WorkInBackground` - step load pattern)

Parameter           | Value
------------------- | ------------:
Initial User Count  | 1
Maximum User Count  | 500
Step Duration       | 60s
Step Ramp Time      | 0s
Step User Count     | 100
Test Duration       | 5 minutes
Test Warm Up        | 30 seconds


Both load tests were run against a single deployment but at different times.

The load test for the http://yourservice.cloudapp.net/api/workinfrontend web test generated the following results:

![Load-test results][InitialLoadTestResults]

The load test for the http://yourservice.cloudapp.net/api/workinbackground web test generated the following results:

![Load-test results][LoadTestResultsBackground]

[general approach]: ../load-testing.md

[InitialLoadTestResults]: _images/InitialLoadTestResultsFrontEnd.jpg
[LoadTestResultsBackground]: _images/LoadTestResultsBackground.jpg
