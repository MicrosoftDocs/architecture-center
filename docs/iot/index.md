# Internet of Things on Azure: Designing and operating an IoT solution at scale

This series of articles explores how to build and run an IoT solution on Azure. There is a reference implementation on GitHub that accompanies this series.

## Introduction

Depending on who you ask, the Internet of Things (IoT) is either the "Next Big Thing" or something that people have been doing for years. 

The truth is actually both. Network-enabled devices and the concept of [ubiquitous computing](https://en.wikipedia.org/wiki/Ubiquitous_computing) are decades old, and many IoT scenarios have been around for a long time. That said, the convergence of several trends has changed the landscape in recent years.

- Devices are getting smaller and smarter, with longer battery life.
- The sheer number of connected devices is exploding: as many as 20 billion connected devices by 2020, according to [Gartner](https://www.gartner.com/newsroom/id/3598917).
- AI and machine learning are opening new possibilities for analyzing data from devices.
- The public cloud makes it easier to ingest all of this data that devices are sending, feed the data into big data analytics, and integrate the results with backend systems.

Building robust IoT solutions is a challenge, however, because IoT spans such a wide range of engineering disciplines: Embedded systems, real-time stream processing, big data analytics, machine learning, business systems integration, web and mobile client applications, and so on. It’s unlikely that any one person will be an expert in all of these areas.

In this guidance, we focus especially on the cloud backend of an IoT system:

- Ingesting device telemetry into the cloud, at scale.
- Using real-time stream processing to detect anomalies and trigger alerts.
- Using batch processing to produce business insights.
- Monitoring and performance testing.

This guidance is based on a reference implementation that is available on GitHub. 

For a general overview of IoT and how Azure can address challenges in IoT projects, see [Introduction to Azure and the Internet of Things](https://docs.microsoft.com/en-us/azure/iot-fundamentals/iot-introduction).

## The Drone Delivery application

To explore the challenges of building an IoT application, we created a reference implementation called the Drone Delivery application. You can find the code in GitHub. 

Here is the scenario: Fabrikam, Inc. runs a drone delivery service. The company manages a fleet of drone aircraft, and customers can request a drone to pick up goods for delivery. 

The drones this scenario send two types of telemetry:

- Flight data:  Latitude, longitude, altitude, velocity, and acceleration. The drone sends this data once every 5 seconds.
- Operating status: Engine temperature and battery level. The drone sends this data once every 20 seconds.

We assume the drones support IP protocol and MQTT, and that the drones are are mostly-connected devices. That is, they send a constant stream of data while in flight, rather than batching data at intervals.

Here is an example of the two types of telemetry data. The message payload is a JSON document, and the sensorType field indicates the type of message, either flight data or operating status.

Flight data message:

```json
{
	"occurrenceUtcTime": "04/17/2018 20:25:09 +00:00",
	"deviceId": "Simulated.drone-01.35",
	"sensorType": "drone-event-sensor;v1",
	"deliveryId": "d71df1a7-29eb-41e0-8232-030cc511ce87",
	"velocity": "58.08",
	"acceleration": "2.52",
	"position": "60.631945|-99.579919|504.99",
	"flightStatus": "1",
}
```

Operating status:

```json
{
	"occurrenceUtcTime": "04/17/2018 20:25:17 +00:00",
	"deviceId": "Simulated.drone-01.61",
	"sensorType": "drone-state-sensor;v1",
	"deliveryId": "4527e4ef-545a-45ac-8fae-22d17d74b1c5",
	"temperature": "74.74",
	"batteryStatus": "low",
	"batteryLevel": "0.25",
}
```

Fabrikam has a requirement to handle up to 10,000 drones in flight at any time. Each drone sends 15 messages per second, for a total throughput of 150,000 messages per minute (2,500 messages per second).


