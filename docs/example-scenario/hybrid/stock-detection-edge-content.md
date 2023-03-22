This architecture shows how to use an Azure Stack Edge or Azure IoT Edge device together with network cameras to determine if retail shelves have out-of-stock items.

## Architecture

:::image type="content" border="false" source="media/solution-architecture.svg" alt-text="Diagram that shows an architecture for detecting out-of-stock items in retail stores." lightbox="media/solution-architecture.svg ":::

*Download a [Visio file](https://arch-center.azureedge.net/stock-detection-edge.vsdx) of this architecture.*

### Workflow

1. Images are captured from a network camera via HTTP or Real Time Streaming Protocol (RTSP).
2. Images are resized and sent to the inference driver, which communicates with the machine learning model to determine whether there are any images that represent areas that need to be restocked.
3. The machine learning model returns information about areas that need to be restocked.
4. The inferencing driver uploads the raw images to a blob (if specified) and sends the results from the model to Azure IoT Hub and a bounding box processor on the device.
5. The bounding box processor adds bounding boxes to the image and caches the image path in an in-memory database.
6. A web app queries for images and shows them in the order received.
7. Messages from IoT Hub are aggregated in Azure Time Series Insights.
8. Power BI displays an interactive report of out-of-stock items with the data from Time Series Insights.

### Components

- **On-premises hardware:**
   - A network camera with an HTTP or RTSP feed provides images for inference. 
- **Azure:**  
   - [IoT Hub](https://azure.microsoft.com/products/iot-hub) handles device provisioning and messaging for the edge devices. 
   - [Time Series Insights](https://azure.microsoft.com/products/time-series-insights) stores the messages from IoT Hub for visualization. 
   - [Power BI](https://powerbi.microsoft.com) displays business-focused reports about out-of-stock events. Power BI provides an easy-to-use dashboard interface for viewing the output from [Azure Stream Analytics](https://azure.microsoft.com/products/stream-analytics).
- **Azure Stack Edge or IoT Edge device:**
   - [IoT Edge](https://azure.microsoft.com/products/iot-edge) orchestrates the runtime for the on-premises containers and handles device management and updates.
   - On an [Azure Stack Edge](https://azure.microsoft.com/products/azure-stack/edge) device, [Project Brainwave](https://blogs.microsoft.com/ai/build-2018-project-brainwave) uses field-programmable gate arrays (FPGAs) to accelerate machine learning inferencing.

## Scenario details 

The solution example uses an edge device, like an Azure Stack Edge device, in the store. The device efficiently processes data from cameras in the store. The optimized design lets the store send only relevant events and images to the cloud. This design saves bandwidth and storage space and helps to ensure customer privacy. As frames are read from each camera, a machine learning model processes the images and returns images that represent areas where restocking is needed. The images and out-of-stock areas are displayed on a local web app. You can send this data to a Time Series Insights environment to present insights in Power BI.

### Potential use cases

Physical retail stores lose sales when customers look for items that aren't available on the shelves. The items could be in the back of the store, waiting to be restocked. This solution makes the restocking process more efficient by notifying staff automatically when items need to be stocked.

## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, a set of guiding tenets that you can use to improve the quality of a workload. For more information, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

### Scalability

Most machine learning models can only run at a certain number of frames per second, depending on the provided hardware. Determine the optimal sample rate from your cameras to ensure that the machine learning pipeline doesn't back up. Different types of hardware can handle differing numbers of cameras and frame rates.

### Availability

You should consider what will happen if the edge device loses connectivity. Consider what data might be lost from the Time Series Insights and Power BI dashboard. The example solution as described isn't designed to be highly available.

### Manageability

This solution can span many devices and locations, although it might get unwieldy if you have too many data sources. Azure IoT services can automatically bring new locations and devices online and keep them up to date. 

You also need to follow appropriate data governance procedures.

### Security

Security provides assurances against deliberate attacks and the abuse of your valuable data and systems. For more information, see [Overview of the security pillar](/azure/architecture/framework/security/overview).

This architecture handles potentially sensitive data. Make sure that access keys are rotated regularly and that the permissions on the Azure storage account and local shares are set correctly.

## Next steps

- [IoT Edge documentation](/azure/iot-edge)
- [IoT Hub documentation](/azure/iot-hub) 
- [Training module: Introduction to Azure IoT Edge](/training/modules/introduction-iot-edge)
- [Training module: Introduction to Azure Stack](/training/modules/intro-to-azure-stack)
- [Time Series Insights documentation](/azure/time-series-insights)
- [Project Brainwave blog post](https://blogs.microsoft.com/ai/build-2018-project-brainwave)
- [Video: Azure Accelerated Machine Learning with Project Brainwave](https://www.youtube.com/watch?v=DJfMobMjCX0)
- [Hybrid app design considerations](/hybrid/app-solutions/overview-app-design-considerations)
- [Azure Stack family of products and solutions](/azure-stack)
- [Edge machine learning inferencing solution deployment guide](https://github.com/Azure-Samples/azure-intelligent-edge-patterns/tree/master/edge-ai-void-detection)

## Related resources

- [AI-based footfall detection](../../solution-ideas/articles/hybrid-footfall-detection.yml)
- [Buy online, pick up in store](../../example-scenario/iot/vertical-buy-online-pickup-in-store.yml)
- [Optimize inventory and forecast demand with Power Platform and Azure](../../example-scenario/analytics/optimize-inventory-forecast-demand.yml)
- [Video capture and analytics for retail](../../solution-ideas/articles/video-analytics.yml)
