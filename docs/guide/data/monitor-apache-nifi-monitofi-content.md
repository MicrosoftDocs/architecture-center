[MonitoFi][MonitoFi] is a tool that monitors the health and performance of [Apache NiFi][Apache NiFi] clusters. This tool runs separately from NiFi. MonitoFi provides information in two formats:

- Dashboards display historic information on the state of clusters.
- Real-time notifications alert users when the tool detects anomalies. MonitoFi can monitor clusters with latencies as low as 1 second. By using local instances of Influx DB and Grafana, MonitoFi provides real-time monitoring and alerts.

Apache®, Apache NiFi®, and NiFi® are either registered trademarks or trademarks of the Apache Software Foundation in the United States and/or other countries. No endorsement by The Apache Software Foundation is implied by the use of these marks.

## Key benefits

MonitoFi is:

- Lightweight and extensible: MonitoFi is a lightweight tool that runs externally. Because it's based on Python and is containerized, you can extend MonitoFi to add features. A MonitoFi instance that runs in one container can target multiple NiFi clusters.
- Flexible and robust: MonitoFi uses a REST API wrapper to retrieve JSON data from NiFi. MonitoFi converts that data into a usable format that doesn't depend on specific endpoints or field names. As a result, when NiFi REST API responses change, you don't need to change MonitoFi code.
- Easy to adopt: You don't have to reconfigure existing NiFi clusters to start using MonitoFi to monitor them.
- Easy to use: MonitoFi offers preset configurations. The tool also includes templates for Grafana dashboards that you can import without modification.
- Highly configurable: MonitoFi runs in a Docker container. You configure MonitoFi by using environment variables. You can easily configure the following settings and others at runtime:

  - Endpoints
  - Settings for secure access
  - Certificates
  - Instrumentation key settings
  - The collection interval

  With this approach, you run one container image, But you can target different NiFi clusters, configurations, and different instances of App Insights or Influx DB. To change targets, you change the runtime command.

## Architecture

:::image type="content" source="./media/monitor-apache-nifi-monitofi-architecture.png" alt-text="Architecture diagram showing the automated flow of data through an Azure solution that uses Apache NiFi and Apache ZooKeeper." border="false":::

*Download an [SVG file][SVG file of architecture diagram] of this architecture.*

- A docker image encapsulates a MonitoFi Python module and the [Azure Application Insights][What is Application Insights?] SDK. The system retrieves this docker image from Docker Hub Registry and stores it in Azure container registry for use and deployment.

- By using Azure Container instances or Docker on a local machine, the system retrieves the image to run instances of the MonitoFi container.

- Another container that's locally deployed hosts an InfluxDB server and a Grafana instance.

- The MonitoFi container collects information on each NiFi cluster's health and performance. The container requests data:

  - From clusters at configurable time intervals.
  - From various endpoints by using the Apache NiFi REST API.

- The MonitoFi container converts the cluster data into these formats:

  - Structured log format. The container sends this data to Azure Application Insights.
  - Line protocol format. In air-gapped or on-premises environments, the container stores this data in a local instance of Influx DB.

- Grafana displays Application Insights data. This data-monitoring tool:

  - Uses Azure Monitor as a datasource.
  - Runs Kusto Query Language queries. The Application Insights dashboard includes sample queries.

- Grafana uses MonitoFi dashboard queries and the following languages to display data from the local instance of Influx DB:

  - The Flux Query Language
  - The Influx Query Language

- The Grafana notification system sends real-time alerts through Microsoft Teams and email when it detects anomalies in the cluster.

## Deployment scenarios

- In air-gapped and on-premises environments, there's no access to the public internet. These systems deploy a local instance of Influx DB with Grafana. This approach provides a storage solution for the data. The MonitoFi container uses the NiFi REST API over a private IP address to retrieve cluster data. The container stores this data in Influx DB. Grafana displays the Influx DB data and uses email and Teams to alert users.

- In public environments, the MonitoFi container uses the NiFi REST API to retrieve cluster data. The container then sends this data in a structured format to Azure Application Insights. These environments also deploy a local instance of Influx DB and a Grafana container. MonitoFi can store data in that instance of Influx DB. Grafana displays the data and uses email and Teams to alert users.

## Deployment process

MonitoFi includes a fully automated deployment script that:

- Verifies prerequisites and installs missing dependencies.
- Deploys a MonitoFi Docker container.
- Deploys containers for InfluxDB and Grafana.
- Configures databases and a retention policy for Influx DB.
- Configures a data source in Grafana for Influx DB.
- Optionally configures a data source in Grafana for AzureMonitor.
- Imports the MonitoFi dashboard into Grafana. Grafana uses this dashboard to access Influx DB data.
- Optionally imports the Application Insights dashboard into Grafana. Grafana can use this dashboard to access Azure Application Insights data.
- Configures a notification channel that Grafana for uses for real-time Teams alerts.

When you deploy this solution, keep in mind the following prerequisites and limitations:

- MonitoFi needs access to the Apache NiFi cluster. Use one of these approaches to provide that access:

  - Place MonitoFi in the same network as the NiFi cluster. Provide access through a private IP address.
  - Make the NiFi cluster publicly accessible over the internet.

- The NiFi cluster can be secure or unsecured. For signing in, secured clusters support certificates in PKCS #12 format. Mount this type of certificate in the MonitoFi container, and make the password available.

- One MonitoFi instance can monitor multiple NiFi clusters at the same time. Another possibility is using multiple MonitoFi containers. In this case, the containers can monitor different REST API endpoints in the same cluster or in different clusters.

- If you use more than one MonitoFi instance, it's possible to store the MonitoFi data in one InfluxDB database or send it to one common Application Insights resource. Pre-set tags mark the data and provide a way to identify its source.

- InfluxDB and Grafana run within the same docker container. To provide a way for MonitoFi to send data to this container, use one of these options:

  - Place the docker container in the same network as the MonitoFi container.
  - Make the docker container publicly available.

## Next steps

- [MonitoFi : Health & Performance Monitor for Apache NiFi on GitHub][MonitoFi : Health & Performance Monitor for Apache NiFi on GitHub]
- [Docker Image with InfluxDB and Grafana][Docker Image with InfluxDB and Grafana]
- [MonitoFi : Health & Performance Monitor for Apache NiFi on dockerhub][MonitoFi : Health & Performance Monitor for Apache NiFi on dockerhub]
- [Docker Image with InfluxDB and Grafana on dockerhub][Docker Image with InfluxDB and Grafana on dockerhub]
- [NiFi Rest API 1.14.0][NiFi Rest API 1.14.0]

## Related resources

- [Apache NiFi on Azure][Apache NiFi on Azure]
- [Monitoring Azure Functions and Event Hubs][Monitoring Azure Functions and Event Hubs]
- [Web application monitoring on Azure][Web application monitoring on Azure]

[Apache NiFi]: https://nifi.apache.org/
[Apache NiFi on Azure]: ../../example-scenario/data/azure-nifi.yml
[Docker Image with InfluxDB and Grafana]: https://github.com/tushardhadiwal/docker-influxdb-grafana
[Docker Image with InfluxDB and Grafana on dockerhub]: https://hub.docker.com/r/dtushar/docker-influxdb-grafana
[MonitoFi]: https://github.com/microsoft/MonitoFi
[MonitoFi : Health & Performance Monitor for Apache NiFi on dockerhub]: https://hub.docker.com/r/dtushar/monitofi
[MonitoFi : Health & Performance Monitor for Apache NiFi on GitHub]: https://github.com/microsoft/MonitoFi
[Monitoring Azure Functions and Event Hubs]: https://docs.microsoft.com/en-us/azure/architecture/serverless/event-hubs-functions/observability
[NiFi Rest API 1.14.0]: https://nifi.apache.org/docs/nifi-docs/rest-api/index.html
[SVG file of architecture diagram]: ./media/monitor-apache-nifi-monitofi-architecture.svg
[Web application monitoring on Azure]: https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/app-service-web-app/app-monitoring
[What is Application Insights?]: https://docs.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview











