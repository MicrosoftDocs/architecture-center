---
title: Camera selection for IoT Edge Vision
titleSuffix: Azure Architecture Center
description: 
author: MSKeith
ms.date: 09/30/2020
ms.topic: guide
ms.service: architecture-center
ms.author: kehilsch
ms.category:
  - fcp
ms.subservice: reference-architecture
---

# Camera selection in Azure IoT Edge Vision

One of the most critical components to any vision workload is selecting the correct camera. The items that are being identified in a vision workload must be presented in such a way so that a computer’s artificial intelligence or machine learning models can evaluate them correctly. To further understand this concept, you need to understand the different camera types that can be used. One thing to note in this article as we move forward, there are a lot of different manufacturers of **area**, **line**, and **smart** cameras. Microsoft does not recommend any one vendor over another - instead we recommend that you select a vendor that fits your specific needs.

## Area Scan Cameras

This is more your traditional camera image, where a 2D image is captured and then sent over to the Edge hardware to be evaluated. This camera typically has a matrix of pixel sensors.

### When should you use an Area Scan Camera? 

As the name suggest, Area Scan Cameras look at a large area and are great at detecting change in an area. Some examples of workloads that would use an Area Scan Camera would be workplace safety, or detecting or counting objects (people,animals,cars,etc.) in an environment.

Examples of manufacturers of Area Scan Cameras are [Basler](https://www.baslerweb.com/en/products/industrial-cameras/), [Axis](https://www.axis.com), [Sony](https://www.sony.co.jp/Products/ISP/products/), [Bosch](https://commerce.boschsecurity.com/IP-Cameras/c/10164917899), [FLIR](https://www.flir.com/), [Allied Vision](https://www.alliedvision.com/digital-industrial-camera-solutions.html).

## Line Scan Cameras

Unlike the Area Scan Cameras, the Line Scan Camera has a single row of linear pixel sensors. This can allow the camera to take one-pixel width in very quick successions and then stitches these one-pixel images into a video stream that is sent over to an Edge Device for processing

### When should you use a Line Scan Camera? 

Line Scan Cameras are great for vision workloads where in the items to be identified are moving past the camera, or items that need to be rotated to detect defects. The Line Scan Camera would then be able to produce a continuous image stream that can then be evaluated. Some examples of workloads that would work best with a Line Scan Camera would be item defect detection on parts that are moved on a conveyer belt, workloads that require spinning to see a cylindrical object, or any workload that requires rotation.

Examples of manufacturers of Area Scan Cameras are [Basler](https://www.baslerweb.com/en/products/industrial-cameras/), [Teledyne Dalsa](https://www.teledynedalsa.com/en/home/), [Hamamatsu Corporation](https://www.hamamatsu.com/index.html?nfxsid=5ede4ac8e12e41591626440), [DataLogic](https://www.datalogic.com/), [Vieworks](https://vieworks.com/), and [Xenics](https://www.xenics.com/).

## Embedded Smart Camera

This type of camera can use either a Area Scan or Line Scan Camera for the acquisition of the images, however, the Line Scan Smart Camera is rare. The main feature of this camera is that it not only acquires the image, but it can also process the image as they are a self-contained stand-alone system. They typically have either and RS232 or Ethernet port output, and this allows the Smart Cameras to be integrated directly into a PLC or other IIoT interfaces.

Examples of manufacturers of Embedded Smart Cameras are [Basler](https://www.baslerweb.com/en/products/industrial-cameras/), [Lesuze Electronics](https://www.leuze.com).

## Other camera features to consider

- **Sensor size**- This is one of the most important factors to evaluate in any vision workload. A sensor is the hardware within a camera that is capturing the light and converting into signals which then produces an image. The sensor contains millions of semiconducting photodetectors that are called photosites. One thing that is a bit of a misconception is that higher megapixel count is a better image. For example, let’s look at two different sensor sizes for a 12-megapixel camera. Camera A has a ½ inch sensor with 12 million photosites and camera B has a 1-inch sensor with 12 million photosites. In the same lighting conditions the camera that has a 1-inch sensor will be cleaner and sharper. Many cameras that would be typically be used in vision workloads would have a sensor between ¼ inch to 1 inch. In some cases, much larger sensors might be required. 

If a camera has a choice between a larger sensor or a smaller sensor some factors consider as to why you might choose the larger sensor are:
    - need for precision measurements
    - Lower light conditions
    - Shorter exposure times, i.e. fast-moving items

- **Resolution**- This is another very important factor to both Line Scan and Area Scan camera workloads. If your workload must identify fine features (Ex. writing on an IC Chip) then you need greater resolutions of the cameras used. If your workload is trying to detect a face, then higher resolution is required. And if you need to identify a vehicle from a distance, again this would require higher resolution.

- **Speed**- Sensors come in two types, a *CCD* and a *CMOS*. If the vision workload requires high number of images per second capture rate, then there are two factors that come into play. The first is how fast is the connection on the interface of the camera and the second is what type of sensor is it. CMOS sensors have a direct readout from the photosites and because of this they typically offer a higher frame rate.

> [!NOTE] There are more camera features to consider when selecting the correct camera for your vision workload. These include lens selection, focal length, monochrome, color depth, stereo depth, triggers, physical size, and support. Sensor manufacturers can help you understand the specific feature that your application may require.

## Camera placement

Depending on the items that you are capturing in your vision workload will determine the location and angles that the camera should be placed. The camera location can also affect the sensor type, lens type, and camera body type. There are several key concepts to keep in mind when figuring out the perfect spot to place the camera in.

There are several different factors that can weigh into the overall decision for camera placement. Two of the most critical are lighting and field of view

### Camera lighting

In a computer vision workload, lighting is a critical component to camera placement. There are several different lighting conditions. While some of the lighting conditions would be useful for one vision workload, it might produce an undesirable condition in another. Types of lighting that are commonly used in computer vision workloads are:

* **Direct lighting:** This is the most commonly used lighting condition.  This light source is projected at the object to be captured for evaluation.

* **Line lighting:** This is a single array of lights that are most used with line scan camera applications to create a single line of light where the camera is focused.

* **Diffused lighting:** This type of lighting is used to illuminate an object but prevent harsh shadows and is mostly used around specular objects.

* **Back lighting:** This type of light source is used behind the object, in which produces a silhouette of the object.  This is most useful when taking measurements, edge detection, or object orientation.

* **Axial diffused lighting:** This type of light source is often used with highly reflective objects, or to prevent shadows on the part that will be captured for evaluation.

* **Custom Grid lighting:** This is a structured lighting condition that lays out a grid of light on the object, the intent is to have a known grid projection to then provide more accurate measurements of components, parts, placement of items, etc.

* **Strobe lighting:** Strobe lighting is used for high speed moving parts.  The strobe must be in sync with the camera to take a “freeze” of the object for evaluation, this lighting helps to prevent motion blurring effect.

* **Dark Field lighting:** This type of light source uses several lights in conjunction with different angles to the part.  For example, if the part is laying flat on a conveyor belt the lights would be placed at a 45-degree angle to the part.  This type of lighting is most useful when looking at highly reflective clear objects…and is most commonly used with lens scratch detections.

  Angular placement of light

![lightingchart](./images/lightingchart.png)

### Field of View

In a vision workload you need to know the distance to the object that you are trying to evaluate.  This also will play a part in the camera selection, sensor selection, and lens configuration.  Some of the components that make up the field of view are:

* **Distance to object(s):** For an example is the object that we are monitoring with computer vision on a conveyor belt and the camera is 2 feet above it, or is the object across a parking lot?  As the distance changes so does the camera’s sensors and lens configurations.
* **Area of coverage:** is the area that the computer vision trying to monitor small or large?  This has direct correlation to the camera’s resolution overall, lens, and sensor type.
* **Direction of the Sun:** if the computer vision workload is outside, such as monitoring a job construction site for worker safety, will the camera be pointed in the sun at any time?  Keep in mind that if the sun is casting a shadow over the object that the vision workload is monitoring, items might be obscured a bit.  Also, if the camera is getting direct sunlight in the lens, the camera might be “blinded” until the angle of the sun changes.
* **Camera angle to the object(s):** angle of the camera to the object that the vision workload is monitoring is also critical component to think about.  If the camera is too high it might miss the details that the vision workload is trying to monitor for, and the same may be true if it is too low.

## Communication Interface

In building a computer vision workload it is also important to understand how the system will interact with the output of the camera.  Below are a few of the standard ways that a camera will communicate to IoT Edge:

* **Real Time Streaming Protocol(RTSP):** RTSP is a protocol that transfers real-time video data from a device (in our case the camera) to an endpoint device (Edge compute) directly over a TCP/IP connection.  It functions in a client server application model that is at the application level in the network.

* **Open Network Video Interface Forum (ONVIF):** a global and open industry forum that is developing open standards for IP-based cameras.  This standard is aimed at standardization of communication between the IP Camera and down stream systems, Interoperability, and Open sourced.

* **USB:** Unlike RTSP and ONVIF USB connected cameras connect over the Universal Serial Bus directly on the Edge compute device.  This is less complex; however, it is limited on distance that the camera can be placed away from the Edge compute.

* **Camera Serial Interface:**  CSI specification is from Mobile Industry Processor Interface(MIPI).  It is an interface that describes how to communicate between a camera and a host processor.

There are several standards defined for CSI

* **CSI-1**:  This was the original standard that MIPI started with.  
* **CSI-2**:  This standard was released in 2005, and uses either D-PHY or C-PHY as physical layers options.  This is further divided into several layers:
  1. Physical Layer (C-PHY, D-PHY)
  2. Lane Merger layer
  3. Low Level Protocol Layer
  4. Pixel to Byte Conversion Layer
  5. Application layer

The specification was updated in 2017 to v2, which added support for RAW-24 color depth, Unified Serial Link, and Smart Region of Interest.

## Next steps

With this knowledge of camera considerations, please proceed to [Hardware acceleration in Azure IoT Edge Vision](iot-edge-hardware.md).