[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Environmental monitoring has become an important activity in the global supply chain. It provides key signals that help drive real-time decisions that can impact suppliers and coordination of logistics.  Air quality, temperature, wind, humidity, and CO2 are examples of some of the indicators that warehouse operators are interested in monitoring during natural disasters. Advanced scenarios like the fusion of data from weather stations, air quality sensors, public real-time and historical data sets (For example, FEMA, [EPA AirNow](https://www.airnow.gov/announcement/4011/) weather, wildfire data). These scenarios includes machine learning models to help predict the effect of these conditions and their possible impact on supply chain operations.

This article describes a warehouse management scenario that monitors environmental conditions through the integration of sensor data, public datasets and using machine learning (ML) for predictions. The insights is then used to ensure safety of the people and optimization of the supply chain operations. 

## Potential use cases

-   Fleet management - This can be used for fleet management where routes need to be optimized for safety based on conditions of the surrounding.   
-   Agriculture - Predicting wildfires that will impact safety of workers and livestock is critical. By providing ample lead time for danger notifications, the people in the affected area can get to safe grounds. The farms can also equip the livestock with automated gates to unlock and open for the animals to escape in dire situations.  

## Architecture

![Architecture diagram showing the data flow for the Environmental Monitoring and the Supply Chain solution](media/environment-monitor-supply-chain.png)


1. Sensors in warehouse facility connected and sends telemetry to a LoRa gateway.

2. LoRa gateway pushes data to cloud using cellular connectivity.

3. myDevices SaaS based plug and play solution - Devices and gateways are automatically provisioned and associated to the corresponding customer so that data can flow accordingly.

4. Device data is sent to Azure IoT Central. Customers uses the solution for control and monitoring of the devices. 

5. Modeling of the supply chain and warehouse facilities using Digital Twins. Azure Digital Twins provides a live executing environment where applications can ingest to gain visibility of the supply chain status. Azure Digital Twins integrates natively to Azure Event Hub which applications can ingest the data from it. 

6. Temporal and spatial data required by ML models and is obtained via the external data sources.	

7. Key data is stored in Azure data solutions - Blob storage for machine learning (ML) training data, Cosmos DB for scored data and key performance indexes.

8. Telemetry data is ingested from IoT Central via Event Hub to ensure decoupling of the data ingestion and consumption. Azure Functions is used to combine external data sources and telemetry data and analyse for any anomaly in the data. The data is surfaced through Azure Digital Twins.

9. Data transformations required for training the machine learning (ML) models.

10. Wildfire prediction models are trained using Azure Machine Learning by using historical, real-time data and micro-weather data.

11. Routing updates are provided by the Bing Maps truck routing API.

12. Applications can query Azure Digital Twins directly to traverse through the Digtial Twin to obtain relevant data from the model. 

### Components

-   [Azure IoT Central](https://azure.microsoft.com/services/iot-central/) is used as the IoT managed platform. It provides security, scalability, and availability as part of the service so that customers can focus efforts on business requirements. Users can integrate with business components such as Power Apps, Power BI and create notifications through the [data export feature in IoT Central](https://docs.microsoft.com/azure/iot-central/core/howto-export-data).

-   [Azure storage](https://azure.microsoft.com/services/storage/) is used for storing device information in the cloud in a secure and scalable way. The data stored is used for training the machine learning models and as a cost-effective storage option.

-   [Azure Cosmos DB](https://azure.microsoft.com/services/cosmos-db/) is a fully managed NoSQL database service for modern application development. The solution uses Cosmos DB to storing application KPIs and model outputs. It provides high speed transactions and can easily enable the service for global distribution. 

-   [Azure Databricks](https://azure.microsoft.com/services/databricks/) is a data analytics platform optimized for the Microsoft Azure cloud services platform. Azure Databricks is used for transforming, manipulating, and normalizing data so that it can be properly consumed by the machine learning pipeline. 

-   [Azure Machine Learning](https://azure.microsoft.com/services/machine-learning/) is used to create wildfire prediction models. The models provide the intelligence required to assess the risk of a wildfire. We need input from multiple data sources (For example, satellite imagery, historical data, local soil conditions, weather data) to train the model for accuracy. The Supply Chain and Logistics solution can reroute trucks based on the predicated wildfire area from the model.

For more detailed discussions, see the IoT reference architecture [document](../../reference-architectures/iot.yml) to understand and explore the various implementation choices available.

### Challenges faced

There has been a significant [increase in wildfires](https://news.sciencebrief.org/wildfires-sep2020-update/) in recent years and it is a danger to humans and the global supply chain. With the number of acres burned increasing by the year, [climate change](https://www.thebci.org/uploads/assets/e02a3e5f-82e5-4ff1-b8bc61de9657e9c8/BCI-0007h-Supply-Chain-Resilience-ReportLow-Singles.pdf) is top of mind for many leaders. In the United states, the annual average of acres affected by wildfires is approximately 7,000,000 acres. This damage is more than double the average acreage burned during the 1990s. In countries like Australia, the situation is even more alarming. Bush fires in Australia cost nearly 10 times more than the United States and it means an extra month of summer compared to 50 years ago. The [Australian wildfires](https://www.foxbusiness.com/money/australian-wildfires-global-food-supply), impacts the global supply of goods like beef, milk, wool, wine, and wheat. Risks continue to [increase](https://mitsloan.mit.edu/ideas-made-to-matter/supply-chain-resilience-era-climate-change) each year to businesses, as supply chain resiliency during natural disasters is paramount to maintaining the flow of goods globally. [Implementing weather-based forecast and predictions](https://lot.dhl.com/if-australias-bushfires-are-the-new-normal-how-should-companies-manage-risks/) into supply chain capacity planning can help operators adjust planning production and manage shipping schedules. This system can minimize disruptions and adverse effects.

### Business outcomes

Warehouse Operators and major distribution centers will benefit from a safer and predictive way to determine if existing logistics infrastructure is in the path of a major fire. Having an early notification system in the event of a wildfire would provide increase lead time to take preventive measures. In addition, notice of incoming and outgoing logistics activities should be paused to allow employee evacuation and the rerouting of shipments with minimal human intervention. 

### Requirements

- Automation is critical because we cannot assume that operators and facility managers can gather data across multiple systems to make timely decisions. 
- Warehouses, distribution facilities, and operation managers need to be notified via multiple means (for example, dashboard, email, and text message) when there is immediate danger.
- The delivery and deployment of the solution needs to be simple. For example, it can be installed (plug and play) without the need of a technician.
- The solution needs to be low maintenance and cost effective.
- Only changes in the data need to be reported.

### Patterns to address challenges

-   *How can technology like Internet of Things (IoT) help solve your
    business challenges?*

The table below provides a summary of common use cases and corresponding IoT solutions. Each use case is an example of how an IoT process pattern can be applied real-world scenarios. 

| Use case | Solutions | Pattern
|---|---|---|
| Enable supply chain logistics rerouting and production planning by predicting likelihood interruption due to wildfires near the impacted location. | [myDevices](https://mydevices.com/) has a catalog of certified plug and play devices and [LoRa](https://en.wikipedia.org/wiki/LoRa) gateway. The gateway sends data to the cloud application using cellular connectivity. LoRa technology is ideal since the signal needs to penetrate deep into the buildings. Sensors such as CO2, temperature, humidity, wind direction, and air quality can be installed in relevant building locations including roofs and storage facilities. Sensors can also be installed in trucks for location tracking to facilitate rerouting. Ideally, you want to be able to monitor all the key elements of the supply chain so that you can provide a more comprehensive response. | [Analyze and optimize](./analyze-optimize-loop.yml) |
| Identify conditions of wildfire and understand the degree of danger for a given location. | Wildfire prediction model trained with historical data, micro-weather conditions, and local sensor data, can help assess the risk of a wildfire. | [Analyze and optimize](./analyze-optimize-loop.yml) |
| Automated alerts for evacuation and facility reroute | Once unsafe conditions are detected, the digital twin of the facility can then be updated to show that it is no longer online. Once updated, other distribution centers within the network can begin to reroute traffic accordingly.  Additionally, the facility managers and warehouse operators can focus on employee safety. This scenario uses ML to predict where the wildfire is heading to (using public real-time, and historical data sets and micro weather data for more accurate predictions), sensors, track wildfire conditions, and facility alarms to begin employee evacuation. | [Analyze and optimize](./analyze-optimize-loop.yml) |

## Considerations

### Connectivity

Some warehouse and distribution locations could be in rural areas that do not have reliable internet access. This solution uses a LoRa network for connectivity. The devices send data to a LoRa gateway that uses cellular connectivity to send the data to the applications in the cloud. Additionally, LoRa has good building penetration that makes it ideal for warehouse related applications. This solution is a cost-effective and ideal for remote locations that require easy to connect devices. 

### Plug and Play

In a rural setting, it is critical for devices to be easy to deploy without any prior expertise. myDevices has an extensive catalog of IoT devices and gateways that can be applied to multiple scenarios. They are already Plug and Play certified, so all the user needs to do is place them in the right location and turn them on. With their IoT Central integration, customers can easily customize their dashboard and consume their device data and create alerts.

## Next steps 

-   [IoT in transportation and logistics](https://azure.microsoft.com/overview/iot/industry/transportation-and-logistics/) - Bring greater efficiency and reliability to your value chain with world-class IoT and location intelligence services. Improve quality of service, increase safety, and reduce cost by finding smarter ways to get people and products where they need to be.
-   [Architecture of IoT Central connected logistics application template](https://docs.microsoft.com/azure/iot-central/retail/architecture-connected-logistics) - App template and guidance to develop end to end connected logistics solutions.
-   [Truck routing API](https://www.microsoft.com/en-us/maps/truck-routing/) - The Bing Maps Truck Routing API calculates routes that take into consideration the attributes for trucks and other commercial vehicles.
-   [Process real-time vehicle data using IoT](https://docs.microsoft.com/azure/architecture/example-scenario/data/realtime-analytics-vehicle-iot) - Reference design to ingest real-time vehicle data for analysis.
-   [Azure Digital Twins - Supply Chain demo](https://github.com/Azure-Samples/IoTDemos/tree/master/ADT-SupplyChainDemo) - Demo using Azure Digital Twins to model a supply chain scenario.
-   [myDevices](https://mydevices.com/) provides LoRA connectivity and devices that enable solutions to be stood up quickly in locations where connectivity is a challenge and broad network coverage is needed.
-   [C.H. Robinson Navisphere](https://news.microsoft.com/2020/07/14/c-h-robinson-announces-alliance-with-microsoft-to-digitally-transform-the-supply-chain-of-the-future/) Providing real-time visibility to supply chain and provide more predictability and proactive decision making.
