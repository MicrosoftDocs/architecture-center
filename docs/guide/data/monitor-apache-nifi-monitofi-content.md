[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This solution monitors deployments of Apache NiFi on Azure by using MonitoFi. The tool sends alerts and displays health and performance information in dashboards.

*Apache®, Apache NiFi®, and NiFi® are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries. No endorsement by The Apache Software Foundation is implied by the use of these marks.*

## Architecture

:::image type="content" source="./media/monitor-apache-nifi-monitofi-architecture.svg" alt-text="Diagram showing the flow of data between a NiFi cluster and MonitoFi. Other architecture components include Application Insights, InfluxDB, and Grafana." border="false" lightbox="./media/monitor-apache-nifi-monitofi-architecture.svg":::
*Download a [Visio file](https://arch-center.azureedge.net/monitor-apache-nifi-monitofi.vsdx) of this architecture.*

### Workflow

- A Docker image encapsulates a MonitoFi Python module and the [Application Insights][What is Application Insights?] SDK. This Docker image can be retrieved from the [Docker Hub registry][MonitoFi : Health & Performance Monitor for Apache NiFi on Docker Hub] and stored in [Container Registry][Container Registry] for use and deployment.

- If [Container Instances][Container Instances] or [Docker][Docker Desktop] run on a local machine, the image can be retrieved to run instances of the MonitoFi container.

- Another container that hosts an InfluxDB server and a Grafana instance is deployed locally.

- The MonitoFi container collects information on each NiFi cluster's health and performance. The container requests data:

  - From clusters at configurable time intervals.
  - From various endpoints by using the [Apache NiFi REST API][NiFi Rest API 1.14.0].

- The MonitoFi container converts the cluster data into these formats:

  - A structured log format. The container sends this data to Application Insights.
  - InfluxDB line protocol. In air-gapped or on-premises environments, the container stores this data in a local instance of InfluxDB.

- Grafana displays Application Insights data. This data-monitoring tool:

  - Uses Monitor as a data source.
  - Runs [Kusto Query Language][Kusto query overview] queries. The Application Insights dashboard includes sample queries.

- Grafana is used to display data from the local instance of InfluxDB. For querying, Grafana uses the following languages:

  - The [Flux][Flux query language] query language
  - The [Influx Query Language (InfluxQL)][Influx Query Language (InfluxQL)]

- The Grafana notification system sends real-time alerts through email and [Microsoft Teams][Microsoft Teams] when it detects anomalies in the cluster.

### Components

- MonitoFi runs in a [Docker][Docker] container, separately from NiFi. 
- [Azure Container Registry](https://azure.microsoft.com/products/container-registry) and [Azure Container Instances](https://azure.microsoft.com/products/container-instances) manage and run the container images. 

Other architecture components include:

- [Application Insights](/azure/azure-monitor/app/app-insights-overview). This [Azure Monitor](https://azure.microsoft.com/services/monitor) feature monitors application usage, availability, and performance.
- [Grafana][Grafana]. This open-source analysis tool displays data and sends alerts.
- [InfluxDB][InfluxDB]. This platform stores data locally.

## Scenario details

[MonitoFi][MonitoFi] is a tool that monitors the health and performance of [Apache NiFi][Apache NiFi] clusters. When you run [NiFi on Azure][Apache NiFi on Azure] and use MonitoFi:

- MonitoFi dashboards display historic information on the state of NiFi clusters.
- Real-time notifications alert users when anomalies are detected in clusters.

### Key benefits

MonitoFi has these advantages:

- Lightweight and extensible: MonitoFi is a lightweight tool that runs externally. Because MonitoFi is based on Python and is containerized, you can extend it to add features. A MonitoFi instance that runs in one container can target multiple NiFi clusters.
- Effective and useful: MonitoFi uses local instances of InfluxDB and Grafana to provide real-time monitoring and alerts. MonitoFi can monitor clusters with latencies as low as one second.
- Flexible and robust: MonitoFi uses a REST API wrapper to retrieve JSON data from NiFi. MonitoFi converts that data into a usable format that doesn't depend on specific endpoints or field names. As a result, when NiFi REST API responses change, you don't need to change MonitoFi code.
- Easy to adopt: You don't have to reconfigure NiFi clusters to monitor them.
- Easy to use: MonitoFi offers preset configurations. It also includes templates for Grafana dashboards that you can import without modification.
- Highly configurable: MonitoFi runs in a Docker container. You configure MonitoFi by using environment variables. You can easily configure the following settings and others at runtime:

  - Endpoints
  - Settings for secure access
  - Certificates
  - Instrumentation key settings
  - The collection interval

With one container image, you can target different NiFi clusters, configurations, and different instances of Application Insights or InfluxDB. To change targets, you change the runtime command.

## Deploy this scenario

To deploy this solution, see [MonitoFi: Health & Performance Monitor for Apache NiFi on GitHub][MonitoFi : Health & Performance Monitor for Apache NiFi on GitHub].

### Deployment examples

- In air-gapped and on-premises environments, there's no access to the public internet. As a result, these systems deploy a local instance of InfluxDB with Grafana. This approach provides a storage solution for the data. The MonitoFi container uses the NiFi REST API over a private IP address to retrieve cluster data. The container stores this data in InfluxDB. Grafana is used to display the InfluxDB data and send email and Teams messages to alert users.

- In public environments, the MonitoFi container uses the NiFi REST API to retrieve cluster data. The container then sends this data in a structured format to Application Insights. These environments also deploy a local instance of InfluxDB and a Grafana container. MonitoFi can store data in that instance of InfluxDB. Grafana is used to display the data and send email and Teams messages to alert users.

### Deployment process

MonitoFi includes a fully automated deployment script that:

- Verifies prerequisites and installs missing dependencies.
- Deploys a MonitoFi Docker container.
- Deploys containers for InfluxDB and Grafana.
- Configures databases and a retention policy for InfluxDB.
- Configures a data source in Grafana for InfluxDB.
- Optionally configures a data source in Grafana for Monitor.
- Imports the MonitoFi dashboard into Grafana. Grafana uses this dashboard to access InfluxDB data.
- Optionally imports the Application Insights dashboard into Grafana. Grafana can use this dashboard to access Application Insights data.
- Configures a notification channel that Grafana uses for real-time Teams alerts.

### Deployment considerations

When you deploy this solution, keep in mind the following prerequisites and limitations:

- MonitoFi needs access to the NiFi cluster. Use one of these approaches to provide that access:

  - Place MonitoFi in the same network as the NiFi cluster. Provide access through a private IP address.
  - Make the NiFi cluster publicly accessible over the internet.

- The NiFi cluster can be secure or unsecured. For signing in, secured clusters support certificates in PKCS #12 format. Mount this type of certificate in the MonitoFi container, and make the password available.

- One MonitoFi instance can monitor multiple NiFi clusters at the same time. Another possibility is using multiple MonitoFi containers. In this case, the containers can monitor different REST API endpoints in the same cluster or in different clusters.

- If you use more than one MonitoFi instance, it's possible to store the MonitoFi data in one InfluxDB database or send it to one common Application Insights resource. Pre-set tags mark the data and provide a way to identify its source.

- InfluxDB and Grafana run within the same Docker container. To provide a way for MonitoFi to send data to this container, use one of these options:

  - Place the Docker container in the same network as the MonitoFi container.
  - Make the Docker container publicly available.

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.* 

Principal author:

 - [Muazma Zahid](https://www.linkedin.com/in/muazmazahid/) | Principal PM Manager
 
*To see non-public LinkedIn profiles, sign in to LinkedIn.*

## Next steps

- [MonitoFi: Health & Performance Monitor for Apache NiFi on GitHub][MonitoFi : Health & Performance Monitor for Apache NiFi on GitHub]
- [Docker Image with InfluxDB and Grafana][Docker Image with InfluxDB and Grafana]
- [MonitoFi: Health & Performance Monitor for Apache NiFi on Docker Hub][MonitoFi : Health & Performance Monitor for Apache NiFi on Docker Hub]
- [Docker Image with InfluxDB and Grafana on Docker Hub][Docker Image with InfluxDB and Grafana on Docker Hub]
- [NiFi Rest API 1.14.0][NiFi Rest API 1.14.0]

## Related resources

- [Apache NiFi on Azure][Apache NiFi on Azure]
- [Helm-based deployments for Apache NiFi][Helm-based deployments for Apache NiFi]
- [Monitoring Azure Functions and Event Hubs][Monitoring Azure Functions and Event Hubs]
- [Web application monitoring on Azure][Web application monitoring on Azure]

[Apache NiFi]: https://nifi.apache.org
[Apache NiFi on Azure]: ../../example-scenario/data/azure-nifi.yml
[Container Instances]: https://azure.microsoft.com/services/container-instances
[Container Registry]: https://azure.microsoft.com/services/container-registry
[Docker]: https://www.docker.com
[Docker Desktop]: https://www.docker.com/products/docker-desktop
[Docker Image with InfluxDB and Grafana]: https://github.com/tushardhadiwal/docker-influxdb-grafana
[Docker Image with InfluxDB and Grafana on Docker Hub]: https://hub.docker.com/r/dtushar/docker-influxdb-grafana
[Flux query language]: https://www.influxdata.com/products/flux
[Grafana]: https://grafana.com
[Helm-based deployments for Apache NiFi]: ./helm-deployments-apache-nifi.yml
[Influx Query Language (InfluxQL)]: https://docs.influxdata.com/influxdb/v1.8/query_language
[InfluxDB]: https://www.influxdata.com
[Kusto query overview]: /azure/data-explorer/kusto/query
[Microsoft Teams]: https://www.microsoft.com/microsoft-teams/log-in
[MonitoFi]: https://github.com/microsoft/MonitoFi
[MonitoFi : Health & Performance Monitor for Apache NiFi on Docker Hub]: https://hub.docker.com/r/dtushar/monitofi
[MonitoFi : Health & Performance Monitor for Apache NiFi on GitHub]: https://github.com/microsoft/MonitoFi
[Monitoring Azure Functions and Event Hubs]: ../../serverless/event-hubs-functions/observability.yml
[NiFi Rest API 1.14.0]: https://nifi.apache.org/docs/nifi-docs/rest-api/index.html
[Web application monitoring on Azure]: ../../reference-architectures/app-service-web-app/app-monitoring.yml
[What is Application Insights?]: /azure/azure-monitor/app/app-insights-overview
