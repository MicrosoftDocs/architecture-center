This architecture shows how to use an Azure Stack Edge or Azure IoT Edge device together with network cameras to determine if retail shelves have items that are out of stock.

## Context and problem

Physical retail stores lose sales when customers look for an items that aren't available on the shelves. The items could be in the back of the store, waiting to be restocked. You can make the restocking process more efficient by notifying staff automatically when items need to be stocked.

## Solution

The solution example uses an edge device, like an Azure Stack Edge device, in the store. The device efficiently processes data from cameras in the store. The optimized design lets stores send only relevant events and images to the cloud. The design saves bandwidth, storage space, and helps to ensure customer privacy. As frames are read from each camera, a machine learning model processes the images and returns images that represent areas where stocking is needed. The images and out-of-stock areas are displayed on a local web app. You can send this data to a Azure Time Series Insights environment to present insights in Power BI.

diagram 

Here's how the solution works:

1. Images are captured from a network camera via HTTP or Real Time Streaming Protocol (RTSP).
2. Images are resized and sent to the inference driver, which communicates with the machine learning model to determine whether there are any images that represent areas that need to be restocked.
3. The machine learning model returns information about areas that need to be restocked.
4. The inferencing driver uploads the raw images to a blob (if specified), and sends the results from the model to Azure IoT Hub and a bounding box processor on the device.
5. The bounding box processor adds bounding boxes to the image and caches the image path in an in-memory database.
6. A web app queries for images and shows them in the order received.
7. Messages from IoT Hub are aggregated in Time Series Insights.
8. Power BI displays an interactive report of out-of-stock items with the data from Time Series Insights.

## Components


- **On-premises hardware:**
   - A network camera with an HTTP or RTSP feed provides images for inference. 
- **Azure:**  
   - [IoT Hub](https://azure.microsoft.com/products/iot-hub) handles device provisioning and messaging for the edge devices. 
   - [Time Series Insights](https://azure.microsoft.com/products/time-series-insights) stores the messages from IoT Hub for visualization. 
   - [Power BI](https://powerbi.microsoft.com) provides business-focused reports about out-of-stock events. Power BI provides an easy-to-use dashboard interface for viewing the output from [Azure Stream Analytics](https://azure.microsoft.com/products/stream-analytics).
- **Azure Stack Edge or IoT Edge device:**
   - [IoT Edge](https://azure.microsoft.com/products/iot-edge) orchestrates the runtime for the on-premises containers and handles device management and updates.
   - On an [Azure Stack Edge](https://azure.microsoft.com/products/azure-stack/edge) device, [Project Brainwave](https://blogs.microsoft.com/ai/build-2018-project-brainwave) uses field-programmable gate arrays (FPGAs) to accelerate machine learning inferencing.

## Issues and considerations

Consider the following points when deciding how to implement this solution:

### Scalability

Most machine learning models can only run at a certain number of frames per second, depending on the provided hardware. Determine the optimal sample rate from your camera(s) to ensure that the ML pipeline doesn't back up. Different types of hardware will handle different numbers of cameras and frame rates.

### Availability

It's important to consider what might happen if the edge device loses connectivity. Consider what data might be lost from the Time Series Insights and Power BI dashboard. The example solution as provided isn't designed to be highly available.

### Manageability

This solution can span many devices and locations, which could get unwieldy. Azure's IoT services can automatically bring new locations and devices online and keep them up to date. Proper data governance procedures must be followed as well.

### Security

This pattern handles potentially sensitive data. Make sure keys are regularly rotated and the permissions on the Azure Storage Account and local shares are correctly set.

## Next steps

To learn more about topics introduced in this article:
- Multiple IoT related services are used in this pattern, including [Azure IoT Edge](/azure/iot-edge/), [Azure IoT Hub](/azure/iot-hub/), and [Azure Time Series Insights](/azure/time-series-insights/).
- To learn more about Microsoft Project Brainwave, see [the blog announcement](https://blogs.microsoft.com/ai/build-2018-project-brainwave/) and checkout out the [Azure Accelerated Machine Learning with Project Brainwave video](https://www.youtube.com/watch?v=DJfMobMjCX0).
- See [Hybrid app design considerations](overview-app-design-considerations.md) to learn more about best practices and to get answers to any additional questions.
- See the [Azure Stack family of products and solutions](/azure-stack) to learn more about the entire portfolio of products and solutions.

When you're ready to test the solution example, continue with the [Edge ML inferencing solution deployment guide](https://aka.ms/edgeinferencingdeploy). The deployment guide provides step-by-step instructions for deploying and testing its components.