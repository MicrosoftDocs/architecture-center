[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

This solution describes how retailers like grocery stores can monitor storefront events and take immediate actions to improve customer experience. In this solution, 5G-enabled internet protocol (IP) cameras capture real-time video of shelf inventory, curbside pickup, and cashier queues. On-premises IoT Edge devices analyze the video data in real time to detect the number of people in checkout queues, empty shelf space, or cars in the parking lot.

Metrics analysis can trigger anomaly events to alert the store manager or stock supervisors to take corrective actions. The solution stores summary video clips or events in the cloud for long-term trend analysis.

## Potential use cases

This approach can also:

- Monitor and maintain occupancy limits in an establishment.
- Stop unauthorized users from tailgating others into an office building.
- Prevent fraud at grocery store self-checkout stations.

## Architecture

:::image type="content" source="../media/video-analytics-architecture.png" alt-text="Screenshot showing on-premises video capture and analysis through Azure Stack Edge with Azure Video Analyzer and Spatial Analysis. Event notifications pass through Azure IoT Hub to a web app for alerts, and to Azure Media Services Storage for long-term analysis." border="false":::

1. 5G-enabled IP cameras capture video in real time, and send the video feed to a 5G Radio Access Network (RAN) device.

1. The 5G radios in the stores forward the data to the 5G packet core running on the Azure Stack Edge IoT Edge server.

1. The packet core authenticates the devices, applies Quality of Service (QoS) policies, and routes the video traffic to the target application.

1. Azure Video Analyzer also runs on the edge server, which provides the low latency necessary for transporting and processing the video feeds.

1. Video Analyzer simplifies setting up a video streaming pipeline and pre-processing the video for spatial analysis.

1. The [Spatial Analysis](/azure/cognitive-services/computer-vision/intro-to-spatial-analysis-public-preview) module on the edge server anonymously counts cars, goods on a shelf, or people in line. The module sends these event notifications to the Azure IoT Hub module in the cloud.

1. The IoT Hub module records the event notifications in a web app, and alerts store managers or stock keepers if certain thresholds are passed.

1. An Azure Media Services Storage account stores events for long-term trend analysis to help with resource planning.

### Components

This solution uses the following Azure components:

- [Azure Stack Edge](https://azure.microsoft.com/products/azure-stack/edge/) is a portfolio of devices that bring compute, storage, and intelligence to the IoT Edge. Azure Stack Edge acts as a cloud storage gateway that enables data transfers to Azure, while retaining local access to files.
- [Azure Video Analyzer](https://azure.microsoft.com/products/video-analyzer/) helps build intelligent video-based applications using your choice of AI.
- [Web Apps in Microsoft Azure App Service](https://azure.microsoft.com/services/app-service/web/) creates and deploys mission-critical web applications that scale with your business.
- [Azure IoT Hub](https://azure.microsoft.com/en-us/services/iot-hub/) is a cloud-based managed service for bidirectional communication between IoT devices and Azure.
- [Media Services Storage](https://azure.microsoft.com/services/media-services/) uses Azure Storage to store large media files.
- [Azure Network Function Manager](https://azure.microsoft.com/products/azure-network-function-manager) enables the deployment of network functions to the IoT Edge using consistent Azure tools and interfaces.

## Next steps

- [What is the Radio Access Network?](https://www.sdxcentral.com/5g/ran/definitions/radio-access-network/)
- [Live Video Analytics on IoT Edge](https://techcommunity.microsoft.com/t5/azure-video-analyzer/new-product-features-for-live-video-analytics-on-iot-edge/ba-p/2118497)
- [Azure Network Function Manager simplifies 5G deployments (Video)](https://azure.microsoft.com/resources/videos/azure-network-function-manager-simplifies-5g-deployments)

## Related resources

- [IoT event routing](../../example-scenario/iot/event-routing.yml)
- [Contactless IoT interfaces with Azure intelligent edge](./contactless-interfaces.yml)
