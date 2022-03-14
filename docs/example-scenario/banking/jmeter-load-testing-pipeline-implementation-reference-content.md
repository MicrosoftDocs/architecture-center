[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This article provides an overview of an implementation for a scalable cloud load testing pipeline. The testing pipeline does a lot to carry out stress testing:

* Creates infrastructure on-demand

* Deploys the infrastructure

* Executes testing

* Reports results

* Destroys infrastructure on-demand

The implementation uses [Apache JMeter](https://jmeter.apache.org/) and [Terraform](https://www.terraform.io/) to provision and destroy the required infrastructure from Azure. It also enables observation and viewing of test results. The commercial software engineer (CSE) team used it to help a customer create a [banking system cloud transformation solution](banking-system-cloud-transformation.yml).

This implementation enables the following capabilities:

* Viewing combined data in a dashboard to monitor the scalability and performance of a solution infrastructure.

* The ability to determine:

  * The impact of infrastructure scalability.

  * The reaction to failures in the existing architectural design and various workloads.

  The CSE team made these determinations by observing a set of simulations. They ran functional scenarios in the simulations and monitored the performance and scalability of the infrastructure.

* Supports any system that exposes a JMeter supported endpoint. For example: Azure Container Instances (ACI), Azure Kubernetes Service (AKS), and so on. Carries out pod/node autoscaling and performance tests on all services.

The implementation also supports:

* Executing performance tests over the microservices until the solution reaches or surpasses a target of a set number of transactions per second.

* Executing horizontal pod/node autoscaling tests over microservices.

* Providing observability on specific solution component(s) by activating metrics captured (for example, with Prometheus and Grafana).

* Providing a detailed report about the tests executed, the applications' behavior and the partitioning strategies adopted where applicable (for example, Kafka).

This implementation provides the following advantages:

* Full integration with Azure.

* Alternative to other proprietary/deprecating solutions.

* Fully open-source.

## Potential use case

This solution is ideal for any scenario in which there's a need to evaluate the capability of different infrastructure designs and configurations to handle different types of loads.

## Architecture

:::image type="content" source="./images/load-testing-pipeline-jmeter.png" alt-text="Diagram of a load testing pipeline with JMeter, ACI, and Terraform.":::

The CSE team structured the load testing implementation into two Azure Pipelines:

1. One pipeline builds a custom JMeter Docker container and pushes the image to Azure Container Registry (ACR). This structure provides flexibility for adding any JMeter plugin.

1. The other pipeline:

    1. Validates the JMeter test definition (.jmx file).

    1. Dynamically provisions the load testing infrastructure.

    1. Runs the load test.

    1. Publishes the test results and artifacts to Azure Pipelines.

    1. Destroys the infrastructure.

First the solution creates and runs the Docker pipeline, and then it creates the JMeter pipeline.

An Azure Pipelines triggers and controls the flow. During setup, the solution provisions JMeter agents as ACI instances using the [Remote Testing](https://jmeter.apache.org/usermanual/remote-test.html) approach.

A JMeter controller:

* Configures all workers using its own protocol.

* Combines all load testing results.

* Generates resulting artifacts like dashboards and logs.

Docker pipeline and JMeter pipeline definition files are in YAML (.yml) format. The files contain setting like branch, path, variable, and so on. First the solution creates the pipelines. Then the developer can run the JMeter pipeline from the command line. They run the pipeline by defining which JMeter test definition file and the number of JMeter workers required for the test.

To integrate with Azure test results, the solution uses a Python script to convert the JMeter test results format (.jtl file) to JUnit format (.xml file).

:::image type="content" source="./images/azure-test-results-dashboard.png" alt-text="sample of Azure Pipelines Dashboard Displaying Successful Requests":::

### Components

* Azure

  * [Azure Pipelines](https://azure.microsoft.com/services/devops/pipelines/)

  * [Azure Container Registry (ACR)](https://azure.microsoft.com/services/container-registry/)

  * [Azure Container Instances (ACI)](https://azure.microsoft.com/services/container-instances/)

* Open-source

  * [Apache JMeter](https://jmeter.apache.org/)

  * [Terraform](https://www.terraform.io/)

## Next steps

* Visit the project page on GitHub, at [Load testing pipeline with JMeter, ACI, and Terraform](https://github.com/Azure-Samples/jmeter-aci-terraform).
* [Azure Container Instances (ACI)](/azure/container-instances/) – additional documentation and resources on ACI
* [An introduction to load testing basics and practices](https://apica-kb.atlassian.net/wiki/spaces/ALTTUTS/pages/5538048/LoadTesting+101) – Guide from [Apica](https://www.apica.io)
* [Multilayered Cloud Applications Autoscaling Performance Estimation](https://www.researchgate.net/publication/323791761_Multilayered_Cloud_Applications_Autoscaling_Performance_Estimation) – Conference paper available from ResearchGate

## Related resources

* [Banking system cloud transformation on Azure](banking-system-cloud-transformation.yml)  – describes the use of this load testing pipeline in the Financial Services Industry (FSI)
