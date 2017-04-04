---
title: Run the automated Elasticsearch performance tests
description: Description of how you can run the performance tests in your own environment.
author: dragon119
ms.service: guidance
ms.topic: article
ms.date: 09/22/2016
ms.author: pnp
ms.custom: elasticsearch

pnp.series.title: Elasticsearch on Azure
pnp.series.next: automated-resilience-tests
pnp.series.prev: automated-resilience-tests
---
# Run automated performance tests
[!INCLUDE [header](../_includes/header.md)]

The documents [Tuning data ingestion performance for Elasticsearch on Azure] and [Tuning data aggregation and query performance for Elasticsearch on Azure] describe a number of performance tests that were run against a sample Elasticsearch cluster.

These tests were scripted to enable them to be run in an automated manner. This document describes how you can repeat the tests in your own environment.

## Prerequisites
The automated tests require the following items:

* An Elasticsearch cluster.
* A JMeter environment setup as described by the document [Creating a performance testing environment for Elasticsearch on Azure].
* [Python 3.5.1](https://www.python.org/downloads/release/python-351/) installed on the JMeter master VM.

## How the tests work
The tests are run using JMeter. A JMeter master server loads a test plan and passes it to a set of JMeter subordinate servers that actually run the tests. The JMeter master server coordinates the JMeter subordinate servers and accumulates the results.

The following test plans are provided:

* [elasticsearchautotestplan3nodes.jmx](https://github.com/mspnp/elasticsearch/blob/master/ingestion-and-query-tests/templates/elasticsearchautotestplan3nodes.jmx). Runs the ingestion test over a 3-node cluster.
* [elasticsearchautotestplan6nodes.jmx](https://github.com/mspnp/elasticsearch/blob/master/ingestion-and-query-tests/templates/elasticsearchautotestplan6nodes.jmx). Runs the ingestion test over a 6-node cluster.
* [elasticsearchautotestplan6qnodes.jmx](https://github.com/mspnp/elasticsearch/blob/master/ingestion-and-query-tests/templates/elasticsearchautotestplan6qnodes.jmx). Runs the ingestion and query test over a 6-node cluster.
* [elasticsearchautotestplan6nodesqueryonly.jmx](https://github.com/mspnp/elasticsearch/blob/master/ingestion-and-query-tests/templates/elasticsearchautotestplan6nodesqueryonly.jmx). Runs the query-only test over a 6-node cluster.

You can use these test plans as a basis for your own scenarios if you need fewer or more nodes.

The test plans use a JUnit request sampler to generate and upload the test data. The JMeter test plan creates and runs this sampler, and monitors each of the Elasticsearch nodes for performance data.  

## Building and deploying the JUnit JAR and dependencies
Before running the performance tests you should download, compile, and deploy the JUnit tests located under the performance/junitcode folder. These tests are referenced by the JMeter test plan. For more information, see the procedure "Importing an existing JUnit test project into Eclipse" in the document [Deploying a JMeter JUnit sampler for testing Elasticsearch performance].

There are two versions of the JUnit tests: 

* [Elasticsearch1.73](https://github.com/mspnp/elasticsearch/tree/master/ingestion-and-query-tests/junitcode/elasticsearch1.73). Use this code for performing the ingestion tests. These tests use Elasticsearch 1.73.
* [Elasticsearch2](https://github.com/mspnp/elasticsearch/tree/master/ingestion-and-query-tests/junitcode/elasticsearch2). Use this code for performing the query tests. These tests use Elasticsearch 2.1 and later.

Copy the appropriate Java archive (JAR) file along with the rest of the dependencies to your JMeter machines. The process is described in [Deploying a JMeter JUnit sampler for testing Elasticsearch performance][Deploying a JMeter JUnit sampler for testing Elasticsearch performance]. 

> **Important** After deploying a JUnit test, use JMeter to load and configure the test plans that reference this JUnit test and ensure that the BulkInsertLarge thread group references the correct JAR file, JUnit class name, and test method:
> 
> ![JUnit Request UI](./images/performance-tests-image1.png)
> 
> Save the updated test plans before running the tests.
> 
> 

## Creating the test indexes
Each test performs ingestion and/or queries against a single index specified when the test is run. You should create the index using the schemas described in the appendices to the documents [Tuning data ingestion performance for Elasticsearch on Azure] and [Tuning data aggregation and query performance for Elasticsearch on Azure] and configure them according to your test scenario (doc values enabled/disabled, multiple replicas, and so on.) Note that the test plans assume that the index contains a single type named *ctip*.

## Configuring the test script parameters
Copy the following test script parameter files to the JMeter server machine:

* [run.properties](https://github.com/mspnp/elasticsearch/blob/master/ingestion-and-query-tests/run.properties). This file specifies the number of JMeter test threads to use, the duration of the test (in seconds), the IP address of a node (or a load balancer) in the Elasticsearch cluster, and the name of the cluster:
  
  ```ini
  nthreads=3
  duration=300
  elasticip=<IP Address or DNS Name Here>
  clustername=<Cluster Name Here>
  ```
  
  Edit this file and specify the appropriate values for your test and cluster.
* [query-config-win.ini](https://github.com/mspnp/elasticsearch/blob/master/ingestion-and-query-tests/query-config-win.ini) and [query-config-nix.ini](https://github.com/mspnp/elasticsearch/blob/master/ingestion-and-query-tests/query-config-nix.ini). These two files contain the same information; the *win* file is formatted for Windows filenames and paths, and the *nix* file is formatted for Linux filenames and paths:
  
  ```ini
  [DEFAULT]
  debug=true #if true shows console logs.
  
  [RUN]
  pathreports=C:\Users\administrator1\jmeter\test-results\ #path where tests results are saved.
  jmx=C:\Users\administrator1\testplan.jmx #path to the JMeter test plan.
  machines=10.0.0.1,10.0.0.2,10.0.0.3 #IPs of the Elasticsearch data nodes separated by commas.
  reports=aggr,err,tps,waitio,cpu,network,disk,response,view #Name of the reports separated by commas.
  tests=idx1,idx2 #Elasticsearch index(es) name(s) to test, comma delimited if more than one.
  properties=run.properties #Name of the properties file.
  ```
  
  Edit this file to specify the locations of the test results, the name of the JMeter test plan to run, the IP addresses of the Elasticsearch data nodes you are collecting performance metrics from, the reports containing the raw performance data that will be generated, and the name (or names comma delimited) of the index(es) under test, if more than one, tests will run one after another. If the run.properties file is located in a different folder or directory, specify the full path to this file.

## Running the tests
* Copy the file [query-test.py](https://github.com/mspnp/elasticsearch/blob/master/ingestion-and-query-tests/query-test.py) to the JMeter server machine, in the same folder as the run.properties and query-config-win.ini (query-config-nix.ini) files.
* Ensure that jmeter.bat (Windows) or jmeter.sh (Linux) are on the executable path for your environment.
* Run the query-test.py script from the command line to perform the tests:
  
  ```cmd
  py query-test.py
  ```
* When the test has completed, the results are stored as the set of comma-separated values (CSV) files specified in the query-config-win.ini (query-config-nix.ini) file . You can use Excel to analyze and graph this data.

[Tuning Data Ingestion Performance for Elasticsearch on Azure]: data-ingestion-performance.md
[Tuning Data Aggregation and Query Performance for Elasticsearch on Azure]: data-aggregation-and-query-performance.md
[Creating a Performance Testing Environment for Elasticsearch on Azure]: performance-testing-environment.md
[Deploying a JMeter JUnit Sampler for Testing Elasticsearch Performance]: jmeter-junit-sampler.md
