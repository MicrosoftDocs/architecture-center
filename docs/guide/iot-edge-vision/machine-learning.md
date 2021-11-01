---
title: Machine learning in IoT Edge Vision
titleSuffix: Azure Architecture Center
description: This article describes the machine learning and data science considerations in an Azure IoT Edge Vision solution.
author: MSKeith
ms.author: keith
ms.date: 10/22/2020
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
ms.category:
  - fcp
products:
  - azure-machine-learning
ms.custom:
  - guide
---

# Machine learning and data science in Azure IoT Edge Vision

The process of designing the machine learning (ML) approach for a vision on the edge scenario is one of the biggest challenges in the entire planning process. It is important to understand how to consider and think about ML in the context of edge devices.

To begin using machine learning to address business problems and pain points, consider the following points:

* Always consider first how to solve the problem without ML or with a simple ML algorithm.
* Have a plan to test several ML architectures as they will have different capacities to "learn".
* Have a system in place to collect new data from the device to retrain an ML model.
* For poorly performing ML models, often a simple fix is to add more representative data to the training process and ensure it has variability with all classes represented equally.
* Remember, this is often an iterative process with both the choice of data and choice of architecture being updated in the exploratory phase.

It is not an easy space and, for some, a very new way of thinking. It is a data driven process. Careful planning will be critical to successful results especially on very constrained devices.

It is always critical to clearly define the problem to be solved as the data science and machine learning approach will depend upon this. It is also very important to consider what type of data will be encountered in the edge scenario as this will determine the kind of ML algorithm that should be used.

Even at the start, before training any models, real world data collection and examination will help this process greatly and new ideas could even arise. This article will discuss data considerations in detail. Of course, the equipment itself will help determine the ML approach with regard to device attributes like limited memory, compute, and/or power consumption limits.

Fortunately, data science and machine learning are iterative processes, so if the ML model has poor performance, there are many ways to address issues through experimentation. This article will also discuss considerations around ML architecture choices. Often, there will be some trial and error involved as well.

## Machine learning data

Both the source(s) and attributes of data will dictate how the intelligent edge system is built. For vision, it could be images, videos, or even LiDAR, as the streaming signal. Regardless of the signal, when training an ML model and using it to score new data (called _inferencing_), domain knowledge will be required. This includes experience in designing and using ML algorithms or neural network architectures and expertise deploying them to the specialized hardware. Below are a few considerations related to ML. However, it is recommended to gain some deeper knowledge in order to open up more possibilities or find an ML expert with edge experience to help with the project.

Collecting and using a _balanced dataset_ is critical, and it should equally represent all classes or categories. When the ML model is trained on a dataset, generally that dataset has been split into train, validate, and test subsets. The purpose of these subsets is as follows:

* The training dataset is used for the actual model training over many passes or iterations (often called _epochs_).
* Throughout the training process, the model is spot-checked for how well it is doing on the validation dataset.
* After a model is done training, the final step is to pass the test dataset through it and assess how well it did as a proxy to the real-world.

> [!NOTE]
> Be wary of optimizing for the test dataset, in addition to the training dataset, once one test has been run. It might be good to have a few different test datasets available.

Some good news is that in using deep learning, often costly and onerous feature engineering, featurizations, and preprocessing can be avoided because of how deep learning works to find signal in noise better than traditional ML. However, in deep learning, transformations may still be utilized to clean or reformat data for model input during training as well as inference. The same capacity needs to be used in training and when the model is scoring new data.

When advanced preprocessing is used such as denoising, adjusting brightness or contrast, or transformations like RGB to HSV, it must be noted that this can dramatically change the model performance for the better or, sometimes, for the worse.  In general, it is part of the data science exploration process and sometimes it is something that must be observed once the device and other components are placed in a real-world location.

After the hardware is installed into its permanent location, the incoming data stream should be monitored for data drift.

**Data drift** is the deviation due to changes in the current data compared to the original. Data drift will often result in a degradation in model performance (like accuracy), although this is not the only cause of decreased performance (for example, hardware or camera failure).

There should be an allowance for data drift testing in the system. This new data should also be collected for another round of training. The more representative data collected for training, the better the model will perform in almost all cases. So, preparing for this kind of collection is always a good idea.

In addition to using data for training and inference, new data coming from the device could be used to monitor the device, camera or other components for hardware degradation.

In summary, here are the key considerations:

* Always use a balanced dataset with all classes represented equally.
* The more representative data used to train a model, the better.
* Have a system in place to collect new data from device to retrain.
* Have a system in place to test for data drift.
* Only run a test set through a new ML model once. If you iterate and retest on the same test set, this could cause overfitting to the test set in addition to the training set.

## Machine learning architecture choices

Machine learning (ML) architecture is the layout of the mathematical operations that process input into the desired and actionable output. For instance, in deep learning this would be the number of layers and neurons in each layer of a deep neural network as well as their arrangement. It is important to note that there is no guarantee that the performance metric goal (such as, high enough accuracy) for any given ML architecture will be achieved. To mitigate this, several different architectures should be considered. Often, two or three different architectures are tried before a choice is made. Remember that this is often an iterative process; both the choice of data and the choice of architecture may be updated in the exploratory phase of the development process.

It helps to understand the issues that can arise when training an ML model that may only be seen after training or, even at the point of inferencing on device. Overfitting and underfitting are some of the common issues found during the training and testing process.

* **Overfitting:** Overfitting can give a false sense of success because the performance metric (like accuracy) might be very good when the input data looks like the training data.  However, overfitting can occur when the model fits to the training data too closely and cannot generalize well to new data. For example, it may become apparent that the model only performs well indoors because the training data was from an indoor setting.

  Overfitting can be caused by following issues:

  * The model learned to focus on incorrect, non-representative features specifically found in the training dataset.
  * The model architecture may have too many learnable parameters, correlated to the number of layers in a neural network and units per layer. A model's _memorization capacity_ is determined by the number of learnable parameters.
  * Not enough complexity or variation is found in the training data.
  * The model is trained over too many iterations.
  * There may be other reasons for good performance in training and significantly worse performance in validation and testing, which are out of scope for this article.

* **Underfitting:** Underfitting happens when the model has generalized so well that it cannot tell the difference between classes with confidence. For example, the training _loss_ will still be unacceptably high.

  Underfitting can be caused by following issues:

  * Not enough samples available in training data.
  * The model is trained for too few iterations, in other words, it's too generalized.
  * Other reasons related to the model not being able to recognize any objects, or poor recognition and _loss values_ during training. The assessment values used to direct the training process pass through a process called _optimization_ and _weight updates_.

There is a trade-off between too much capacity (such as, a large network or a large number of learnable parameters) and too little capacity. _Transfer learning_ happens when some network layers are set as not trainable, or _frozen_. In this situation, increasing capacity would equate to opening up more layers earlier in the network versus only using the last few layers in training, with the rest remaining frozen.

There is no hard and fast rule for determining number of layers for deep neural networks. So, sometimes several model architectures must be evaluated within an ML task. However, in general, it is good to start with fewer layers and/or parameters (such as, smaller networks) and gradually increase the complexity.

Some considerations when coming up with the best architecture choice will include the inference speed requirements. These include an assessment and acceptance of the speed versus accuracy tradeoff. Often, a faster inference speed is associated with lower performance. For example, accuracy, confidence or precision could suffer.

A discussion around requirements for the ML training and inferencing will be necessary based upon the considerations above and any company-specific requirements.  For instance, if the company policy allows open-source solutions to be utilized, it will open up a great deal of ML algorithmic possibilities as most cutting edge ML work is in the open-source domain.

In summary, here are the key considerations:

* Keep an eye out for overfitting and underfitting.
* Testing several ML architectures is often a good idea. This is an iterative process.
* There will be a trade-off between too much network capacity and too little. However, it is better to start with too little and build up from there.
* There will be a trade-off between speed and your performance metric such as accuracy.
* If the performance of the ML model is acceptable, the exploratory phase is complete. This is important to note, as one can be tempted to iterate indefinitely.

## Data science workflows

The data science process for edge deployments has a general pattern. After a clear data-driven problem statement is formulated, the next steps generally include those shown in the figure below.

![Vision on the edge data science cycle](./images/data-science-cycle.png)

* **Data collection:**  Data collection or acquisition could be an online image search from a currently deployed device, or other representative data source.  Generally, the more data the better. In addition, the more variability, the better the generalization.
* **Data labeling:** If only hundreds of images need to be labeled, such as, when using transfer learning, it can be done in-house. If tens of thousands of images need to be labeled, a vendor could be enlisted for both data collection and labeling.
* **Train a model with ML framework:** An ML framework such as *TensorFlow* or *PyTorch* (both with Python and C++ APIs) will need to be chosen. Usually this depends upon what code samples are available in open-source or in-house, as well as the experience of the ML practitioner. Azure ML may be used to train a model using any ML framework and approach, as it is agnostic of framework and has Python and R bindings, and many wrappers around popular frameworks.
* **Convert the model for inferencing on device:** Almost always, a model will need to be converted to work with a particular runtime. Model conversion usually involves advantageous optimizations like faster inference and smaller model footprints. This step differs for each ML framework and runtime. There are open-source interoperability frameworks available such as *ONNX* and *MMdnn*.
* **Build the solution for device:** The solution is usually built on the same type of device as will be used in the final deployment because binary files created system-specific.
* **Using runtime, deploy solution to device:** Once a runtime is chosen, usually in conjunction with the ML framework choice, the compiled solution may be deployed. The Azure IoT Runtime is a Docker-based system in which the ML runtimes may be deployed as containers.

The diagram below shows a sample data science process where open-source tools may be leveraged for the data science workflow. Data availability and type will drive most of the choices, including the devices/hardware chosen.

![Vision on the edge work flow](./images/vision-edge-flow.png)

If a workflow already exists for the data scientists and app developers, a few other considerations may apply. First, it is advised to have a code, model, and data versioning system in place. Secondly, an automation plan for code and integration testing along with other aspects of the data science process, such as triggers, build/release process, and so on, will help speed up the time to production and cultivate collaboration within the team.

The language of choice can help dictate what API or SDK is used for inferencing and training ML models. This in turn will then dictate what type of ML model, what type(s) of device, what type of IoT Edge module, and so on, need to be used. For example, PyTorch has a C++ API for inferencing and training, that works well in conjunction with the OpenCV C++ API. If the app developer working on the deployment strategy is building a C++ application, or has this experience, one might consider PyTorch or others (such as TensorFlow or CNTK) that have C++ inferencing APIs.

## Machine learning and data science in a nutshell

In summary, here are the key considerations:

* Converting models also involves optimizations such as faster inference and smaller model footprints, critical for very resource-constrained devices.
* The solution will usually need to be built on a build-dedicated device, the same type of device to which the solution will be deployed.
* The language and framework of choice will depend upon both the ML practitioner's experience as well as what is available in open-source.
* The runtime of choice will depend upon the availability of the device and hardware acceleration for ML.
* It is important to have a code, model, and data versioning system.

## Next steps

Proceed to [Image storage and management in Azure IoT Edge Vision](./image-storage.md) article to learn how to properly store the images created by your IoT Edge Vision solution.
