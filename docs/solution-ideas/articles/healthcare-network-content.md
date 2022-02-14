[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This solution describes how buildings and campuses can securely, reliably, and scalably connect their on-premises Internet of Things (IoT) devices to the cloud. Cloud services can store and analyze the IoT data to diagnose anomalies and take corrective or preventive actions.

In this solution, a healthcare facility uses LTE or 5G-enabled IoT devices to track both patient health and building performance. The devices use built-in Azure Sphere certified chips to stream data to on-premises edge servers, which communicate with the Azure cloud. On-premises network administrators can view network health through the packet cores on the edge servers.

Azure cloud services can further analyze and store the data, and use machine learning to optimize building settings.

## Potential use cases

Other examples of this approach include:

- Predictive maintenance for machines in a coffeehouse.
- Safety and compliance monitoring for perishable food and drink temperatures in a food manufacturing plant.
- Detecting the optimal point for resource extraction in the energy sector, based on data collected by autonomous exploration vehicles.

## Architecture

:::image type="content" source="../media/healthcare-architecture.png" alt-text="Screenshot showing a healthcare facility with two hospitals that collect patient and facility data with IoT devices. The devices connect to radio access network (RAN) devices, IoT Edge servers, and several Azure services through Azure IoT Hub." border="false":::

1. Hospital buildings use various connected devices to monitor both patient health and facility performance.

   - Health-tracking devices include patient monitors, CT scanners, and blood pressure monitors.
   - Building safety and quality devices include air quality and building temperature sensors.

1. The patient health and building monitoring devices send data to LTE or 5G Radio Access Network (RAN) devices.

1. The 5G or LTE radios in the hospitals forward the data to the 5G or LTE packet cores running on the edge servers. The edge servers can be Azure Stack Edge or any Azure Arc-enabled servers.

1. On the edge servers, the IoT Edge runtime can preprocess data before sending it to Azure for further analysis.

1. In the cloud, Azure IoT Hub ingests data quickly and securely, and sends it to Azure Machine Learning.

1. Azure Machine Learning incorporates the new data to further optimize the model that controls the smart building settings.

1. Data from Azure IoT Hub also feeds into Azure Digital Twins, which provides a map of the hospitals' networked IoT devices as a virtual simulation.

1. Data also feeds into Azure Time Series Insights, which can analyze patient health over a period of time, or treatment efficacy over several hospitals. Time Series Insights also offers a visualization layer to aid in decision-making.

1. All the data is stored in Azure Data Lake Storage, which can store data of any format and size.

### Components

This solution uses the following Azure components:

- [Azure Stack Edge](https://azure.microsoft.com/products/azure-stack/edge/) is a portfolio of devices that bring compute, storage, and intelligence to the IoT Edge. Azure Stack Edge acts as a cloud storage gateway that enables data transfers to Azure, while retaining local access to files.
- [Azure Arc-enabled Kubernetes](/azure/azure-arc/kubernetes/) connects Kubernetes clusters running inside or outside of Azure.
- [Azure Sphere](https://azure.microsoft.com/services/azure-sphere) is a comprehensive IoT security solution that includes hardware, OS, and cloud components for IoT device security.
- [Azure IoT Edge](https://azure.microsoft.com/services/iot-edge) deploys cloud intelligence locally on IoT devices.
- [Azure IoT Hub](https://azure.microsoft.com/en-us/services/iot-hub/) is a cloud-based managed service for bidirectional communication between IoT devices and Azure.
- [Azure Machine Learning](https://azure.microsoft.com/services/machine-learning) is an integrated data science solution for data scientists and developers to build, train, and deploy machine learning models.
- [Azure Digital Twins](https://azure.microsoft.com/services/digital-twins) is an IoT platform that creates digital representations of real-world things, places, processes, and people in the cloud.
- [Azure Time Series Insights](https://azure.microsoft.com/services/time-series-insights) is an end-to-end IoT analytics platform to monitor, analyze, and visualize industrial IoT analytics data at scale.
- [Azure Data Lake Storage](https://azure.microsoft.com/services/storage/data-lake-storage) is a scalable and secure data lake for high-performance analytics workloads.

## Next steps

- [Azure Arc on Kubernetes on Azure Stack Edge](/azure/databox-online/azure-stack-edge-gpu-deploy-arc-kubernetes-cluster)
- [Azure Private MEC](https://azure.microsoft.com/solutions/private-multi-access-edge-compute-mec)

## Related resources

- [Manage configurations for Azure Arc enabled servers](../../hybrid/azure-arc-hybrid-config.yml)
- [Deploy AI and ML computing on-premises and to the edge](../../hybrid/deploy-ai-ml-azure-stack-edge.yml)
