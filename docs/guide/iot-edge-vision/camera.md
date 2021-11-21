---
title: Camera selection for IoT Edge Vision
titleSuffix: Azure Architecture Center
description: Get information about camera selection in an Azure IoT Edge Vision solution. Explore camera features, camera placement, and the communication interface.
author: MSKeith
ms.author: keith
ms.date: 10/22/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
ms.category:
  - fcp
products:
  - azure-iot-edge
  - azure-machine-learning
ms.custom:
  - guide
---

# Camera selection in Azure IoT Edge Vision

One of the most critical components in any AI Vision workload is selecting the right camera. The items being identified by this camera must be presented in such a way that the artificial intelligence or machine learning models can evaluate them correctly. An in-depth understanding of the different camera types is required to understand this concept.

> [!NOTE]
> There are different manufacturers for **area**, **line**, and **smart** cameras. Instead of recommending any one vendor over another, Microsoft recommends that you select a vendor that fits your specific needs.

## Types of cameras

### Area scan cameras

This camera type generates the traditional camera image, where a 2D image is captured and then sent over to the Edge hardware to be evaluated. This camera typically has a matrix of pixel sensors.

As the name suggests, area scan cameras look at a large area and are great at detecting change in an area. Examples of workloads that could use an area scan camera would be workplace safety, or detecting or counting objects (people, animals, cars, and so on) in an environment.

Examples of manufacturers of area scan cameras are [Basler](https://www.baslerweb.com/en/products/industrial-cameras/), [Axis](https://www.axis.com), [Sony](https://www.sony-semicon.co.jp/e/products/IS/industry/product.html), [Bosch](https://commerce.boschsecurity.com/us/en/IP-Cameras/c/10164917899), [FLIR](https://www.flir.com/), [Allied Vision](https://www.alliedvision.com/en/products/customization/).

### Line scan cameras

Unlike the area scan cameras, the line scan camera has a single row of linear pixel sensors. This allows the camera to take one-pixel width images in quick successions, and then stitches them together into a video stream. This video stream is then sent over to an Edge device for processing.

Line scan cameras are great for vision workloads where the items to be identified are either moving past the camera, or need to be rotated to detect defects. The line scan camera would then be able to produce a continuous image stream for evaluation. Examples of workloads that would work best with a line scan camera are:
- an item defect detection on parts that are moved on a conveyer belt,
- workloads that require spinning to see a cylindrical object, or
- any workload that requires rotation.

Examples of manufacturers of line scan cameras are [Basler](https://www.baslerweb.com/en/products/industrial-cameras/), [Teledyne Dalsa](https://www.teledynedalsa.com/en/home/), [Hamamatsu Corporation](https://www.hamamatsu.com/index.html?nfxsid=5ede4ac8e12e41591626440), [DataLogic](https://www.datalogic.com/), [Vieworks](https://vieworks.com/), and [Xenics](https://www.xenics.com/).

### Embedded smart cameras

This type of camera can use either an area scan or a line scan camera for capturing the images, although a line scan smart camera is rare. An embedded smart camera can not only acquire an image, but can also process that image as it is a self-contained stand-alone system. They typically have either an RS232 or an Ethernet port output, which allows them to be integrated directly into a PLC or other IIoT interfaces.

Examples of manufacturers of embedded smart cameras are [Basler](https://www.baslerweb.com/en/products/industrial-cameras/), [Lesuze Electronics](https://www.leuze.com).

## Camera features

### Sensor size

This is one of the most important factors to evaluate in any vision workload. A sensor is the hardware within a camera that captures the light and converts into signals, which then produce an image. The sensor contains millions of semiconducting photodetectors called photosites. A higher megapixel count does not always result in a better image. For example, let's look at two different sensor sizes for a 12-megapixel camera. Camera A has a ½ inch sensor with 12 million photosites and camera B has a 1-inch sensor with 12 million photosites. In the same lighting conditions, the camera that has the 1-inch sensor will be cleaner and sharper. Many cameras typically used in vision workloads have a sensor sized between ¼ inch to 1 inch. In some cases, much larger sensors might be required.

If a camera has a choice between a larger sensor or a smaller sensor, some factors deciding why you might choose the larger sensor are:
- need for precision measurements,
- lower light conditions,
- shorter exposure times, or fast-moving items.

### Resolution

This is another important factor to both line scan and area scan camera workloads. If your workload must identify fine features, such as the writing on an IC chip, then you need greater resolution cameras. If your workload is trying to detect a face, then higher resolution is required. And if you need to identify a vehicle from a distance, again a higher resolution will be required.

### Speed

Sensors come in two types- [*CCD* and *CMOS*](https://en.wikipedia.org/wiki/Image_sensor). If the vision workload requires high number of images to be captured per second, then two factors will come into play. The first is how fast is the connection on the interface of the camera. The second is what type of sensor it is. CMOS sensors have a direct readout from the photosites, because of which they typically offer a higher frame rate.

> [!NOTE]
> There are several other camera features to consider when selecting the correct camera for your vision workload. These include lens selection, focal length, monochrome, color depth, stereo depth, triggers, physical size, and support. Sensor manufacturers can help you understand the specific feature that your application may require.

## Camera placement

The items that you are capturing in your vision workload will determine the location and angles that the camera should be placed. The camera location can also affect the sensor type, lens type, and camera body type.

There are several different factors that can weigh into the overall decision for camera placement. Two of the most critical ones are the lighting and the field of view.

### Camera lighting

In a computer vision workload, lighting is a critical component to camera placement. There are several different lighting conditions. While some of the lighting conditions would be useful for one vision workload, it might produce an undesirable effect in another. Types of lighting that are commonly used in computer vision workloads are:

* **Direct lighting:** This is the most commonly used lighting condition.  This light source is projected at the object to be captured for evaluation.

* **Line lighting:** This is a single array of lights that are most used with line scan camera applications. This creates a single line of light at the focus of the camera.

* **Diffused lighting:** This type of lighting is used to illuminate an object but prevent harsh shadows and is mostly used around specular objects.

* **Back lighting:** This type of light source is used behind the object, producing a silhouette of the object.  This is most useful when taking measurements, edge detection, or object orientation.

* **Axial diffused lighting:** This type of light source is often used with highly reflective objects, or to prevent shadows on the part that will be captured for evaluation.

* **Custom Grid lighting:** This is a structured lighting condition that lays out a grid of light on the object, the intent is to have a known grid projection to then provide more accurate measurements of components, parts, placement of items, and so on.

* **Strobe lighting:** Strobe lighting is used for high speed moving parts. The strobe must be in sync with the camera to take a *freeze* of the object for evaluation, this lighting helps to prevent motion blurring effect.

* **Dark Field lighting:** This type of light source uses several lights in conjunction with different angles to the part to be captured. For example, if the part is laying flat on a conveyor belt the lights would be placed at a 45-degree angle to it. This type of lighting is most useful when looking at highly reflective clear objects and is most commonly used with *lens scratch detections*.

The figure below shows the angular placement of light:

![Angular placement of light - IoT Edge Vision](./images/lighting-chart.png)

### Field of view

In a vision workload, you need to know the distance to the object that you are trying to evaluate. This also will play a part in the camera selection, sensor selection, and lens configuration. Some of the components that make up the field of view are:

* **Distance to object(s):** For example, is the object being monitored with computer vision on a conveyor belt and the camera is two feet above it, or is the object across a parking lot? As the distance changes, so does the camera's sensors and lens configurations.
* **Area of coverage:** Is the area that the computer vision is trying to monitor small or large? This has direct correlation to the camera's resolution, lens, and sensor type.
* **Direction of the sun:** If the computer vision workload is outside, such as monitoring a job construction site for worker safety, will the camera be pointed in the sun at any time? Keep in mind that if the sun is casting a shadow over the object that the vision workload is monitoring, items might be a bit obscured. Also, if the camera is getting direct sunlight in the lens, the camera might be *blinded* until the angle of the sun changes.
* **Camera angle to the object(s):** Angle of the camera to the object that the vision workload is monitoring is also a critical component to think about. If the camera is too high, it might miss the details that the vision workload is trying to capture, and the same may be true if it is too low.

## Communication interface

In building a computer vision workload, it is also important to understand how the system will interact with the output of the camera. Below are a few of the standard ways that a camera will communicate to IoT Edge:

* **Real Time Streaming Protocol (RTSP):** RTSP is a protocol that transfers real-time video data from a device (in our case, the camera) to an endpoint device (Edge compute) directly over a TCP/IP connection. It functions in a client-server application model that is at the application level in the network.

* **Open Network Video Interface Forum (ONVIF):** A global and open industry forum that is developing open standards for IP-based cameras. This standard is aimed at standardization of communication between the IP camera and down stream systems, interoperability, and open source.

* **USB:** Unlike RTSP and ONVIF, USB connected cameras connect over the Universal Serial Bus directly on the Edge compute device. This is less complex, however, it limits the distance that the camera can be placed away from the Edge compute.

* **Camera Serial Interface:**  CSI specification is from *Mobile Industry Processor Interface (MIPI)*. This interface describes how to communicate between a camera and a host processor.

  There are several standards defined for CSI:

  * **CSI-1**:  This was the original standard that MIPI started with.
  * **CSI-2**:  This standard was released in 2005, and uses either D-PHY or C-PHY as physical layers options. This is further divided into several layers:
    * Physical Layer (C-PHY, D-PHY)
    * Lane Merger layer
    * Low-Level Protocol Layer
    * Pixel to Byte Conversion Layer
    * Application layer

  The specification was updated in 2017 to v2, which added support for RAW-24 color depth, *Unified Serial Link*, and *Smart Region of Interest*.

## Next steps

Now that you know the camera considerations for your IoT Edge Vision workload, proceed to setting up the right hardware for your workload. Read [Hardware acceleration in Azure IoT Edge Vision](./hardware.md) for more information.
