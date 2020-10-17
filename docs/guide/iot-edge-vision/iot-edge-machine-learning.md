---
title: IoT Edge Vision machine learning
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

# Machine learning and data science in Azure IoT Edge Vision

The process of designing the machine learning (ML) approach for a vision on the edge scenario one of the biggest challenges in the entire planning process.  Therefore, it is important to understand how to consider and think about ML in the context of edge devices.  Some of the considerations and hurdles are outlined below to help begin to think in terms of using machine learning to address business problems and pain points with guidance including:

* Always consider first how to solve the problem without ML or with a simple ML algorithm
* Have a plan to test several ML architectures as they will have different capacities to "learn"
* Have a system in place to collect new data from the device to retrain an ML model
* For a poorly performing ML models, often a simple fix is to add more representative data to the training process and ensure it has variability with all classes represented equally
* Remember, this is often an iterative process with both the choice of data and choice of architecture being updated in the exploratory phase
* More guidance below

It is not an easy space and, for some, a very new way of thinking.  It is a data driven process. Careful planning will be critical to successful results especially on very constrained devices.

In ML it is always critical to clearly define the problem trying to be solved because the data science and machine learning approach will depend upon this and decisions will be easier the more specific it is.  It is also very  important to consider what type of data will be encountered in the edge scenario as this will determine the kind of ML algorithm that should be used.  

Even at the start, before training any models, real world data collection and examination will help this process greatly and new ideas could even arise.  Below, we will discuss data considerations in detail.  Of course, the equipment itself will help determine the ML approach with regard to device attributes like limited memory, compute, and/or power consumption limits.

Fortunately, data science and machine learning are iterative processes, so if the ML model has poor performance, there are many ways to address issues through experimention.  Below, we will discuss consideratinos around ML architecture choices.  Often, there will be some trial and error involved as well.

## Machine learning data

Both the source(s) and attributes of data will dictate how the intelligent edge system is built.  For vision, it could be images, videos, or even LiDAR, as the streaming signal. Regardless of the signal, when training an ML model and using it to score new data (called _inferencing_) domain knowledge will be required, such as experience in designing and using ML algorithms or neural network architectures and expertise deploying them to the specialized hardware.  Below are a few considerations related to ML, however, it is recommended to gain some deeper knowledge in order to open up more possibilities or find an ML expert with edge experience to help with the project.

Collecting and using a _balanced dataset_ is critical, that is, equally representating all classes or categories.  When the ML model is trained on a dataset, generally that dataset has been split into train, validate and test subsets.  The purpose of these subsets is as follows.

* The training dataset is used for the actual model training over many passes or iterations (often called _epochs_).
* Througout the training process, the model is spot-checked for how well it is doing on the validation dataset.  
* After a model is done training, the final step is to pass the test dataset through it and assess how well it did as a proxy to the real-world.  Note: be wary of optimizing for the test dataset (in addition to the training dataset) once one test has been run.  It might be good to have a few different test datasets available.

Some good news is if using deep learning, often costly and onerous feature engineering, featurizations, and preprocessing can be avoided because of how deep learning works to find signal in noise better than traditional ML.  However, in deep learning, transformations may still be utilized to clean or reformat data for model input during training as well as inference.  Note, the same preprocessing needs to be used in training and when the model is scoring new data.  

When advanced preprocessing is used such as de-noising, adjusting brightness or contrast, or transformations like RGB to HSV, it must be noted that this can dramatically change the model performance for the better or, sometimes, for the worse.  In general, it is part of the data science exploration process and sometimes it is something that must be observed once the device and other components are placed in a real-world location.

After the hardware is installed into its permanent location, the incoming data stream should be monitored for data drift.

* **Data drift**:  deviation due to changes in the current data compared to the original.  Data drift will often result in a degradation in in model performance (like accuracy), albeit, this is not the only cause of decreased performance (e.g. hardware or camera failure).  

There should be an allowance for data drift testing in the system.  This new data should also be collected for another round of training (the more representative data collected for training, the better the model will perform in almost all cases!), therefore, preparing for this kind of collection is always a good idea.

In addition to using data for training and inference, new data coming from the device could be used to monitor the device, camera or other components for hardware degradation.

In summary, here are the key considerations:

* Always use a balanced dataset with all classes represented equally
* The more representative data used to train a model, the better
* Have a system in place to collect new data from device to retrain
* Have a system in place to test for data drift
* Only run a test set through a new ML model once - if you iterate and retest on the same test set this could cause overfitting to the test set in addition to the training set

## Machine learning architecture choices

An ML _architecture_ is the layout of the mathematical operations that process input into our desired, actionable output.  For instance, in deep learning this would be the number of layers and neurons in each layer of a deep neural network, plus their arrangement.  It is important to note that there is no guarantee that the  performance metric goal (e.g. high enough accuracy) for one ML architecture will be achieved.  To mitigate this, several different architectures should be considered.  Often, two or three different architectures are tried before a choice is made.  Remember, this is often an iterative process with both the choice of data and choice of architecture being updated in the exploratory phase of the development process.

It helps to understand the issues that can arise when training an ML model that may only be seen after training or, even, at the point of inferencing on device.  Some such issues include overfitting and underfitting as introduced below.

In the training and testing process, one should keep an eye out for overfitting and underfitting:

* **Overfitting**: can give a false sense of success because the performance metric (like accuracy) might be very good when the input data looks like the training data.  However, overfitting can occur when the model fits to the training data too closely and can not generalize well to new data.  For instance, it may become apparent that the model only performs well indoors because the training data was from an indoor setting.  This can be caused by:
  
  * The model learned to focus on incorrect, non-representative features specifically found in the training dataset
  * The model architecture may have too many learnable parameters (correlated to the number of layers in a neural network and units per layer) - note, the model's _memorization capacity_ is determined by the number of learnable parameters
  * Not enough complexity or variation in the training data
  * Trained over too many iterations
  * Other reasons for good performance in training and significantly worse performance in validation and testing

* **Underfitting**: the model has generalized so well that it can not tell the difference between classes with confidence - e.g. the training _loss_ will still be unacceptably high.  This can be caused by:

  * Not enough samples in training data
  * Trained for too few iterations - too generalized
  * Other reasons related to the model not being able to recognize any objects or poor recogntion and _loss values_ during training (the assessment values used to direct the training process through a process called _optimization_ and _weight updates_)

There is a trade-off between too much capacity (a large network or one with big number of learnable parameters) and too little capacity.  In _transfer learning_ (where some network layers are set as not trainable, i.e. _frozen_) increasing capacity would equate to "opening up" more, earlier layers in the network versus only using the last few layers in training (with the rest remaining frozen).

There isn't a hardfast rule for determining number of layers for deep neural networks, thus sometimes several model architectures must be evaluated within an ML task.  However, in general, it is good to start with fewer layers and/or parameters ("smaller" networks) and gradually increase the complexity.

Some considerations when coming up with the best architecture choice will include the inference speed requirements which will need to include an assessment and acceptance of the speed versus accuracy tradeoff.  Often, a faster inference speed is associated with lower performance (e.g. accuracy, confidence or precision could suffer).

A discussion around requirements for the ML training and inferencing will be necessary based upon the considerations above and any company specific requirements.  For instance, if the company policy allows open source solutions to be utilized, it will open up a great deal of ML algorithmic possibilities as most cutting edge ML work is in the open source domain.

In summary, here are the key considerations:

* Keep an eye out for overfitting and underfitting
* Testing several ML architectures is often a good idea - this is an iterative process
* There will be a trade-off between too much network capaticy and too little, but often it's good to start with too little and build up from there
* There will be a trade-off between speed and your performance metric (e.g. accuracy)
* If the performance of the ML model is acceptable, the exploratory phase is complete (one can be tempted to iterate indefinitely)

## Data science workflows

The data science process for edge deployments has a general pattern.  After a clear data-driven problem statement is formulated, the next steps generally include the following.

![Vision on the edge ds cycle](./images/ds_cycle.png)

* **Data Collection**.  Data collection or acquisition could be an online image search, from a currently deployed device, or other representative data source.  Generally, the more data the better.  In addition, the more variability, the better the generalization.
* **Data Labeling**.  If only hundreds of images need to be labeled usually (e.g. when using transfer learning) this is done in-house, whereas, if tens of thousands of images need to be labeled, a vendor could be enlisted for both data collection and labeling.  
* **Train a Model with ML Framework**.  An ML framework such as TensorFlow or PyTorch (both with Python and C++ APIs) will need to be chosen, but usually this depends upon what code samples are available in open source or in-house, plus experience of the ML practitioner.  Azure ML may be used to train a model using any ML framework and approach - it is agnostic of framework and has Python and R bindings, plus many wrappers around popular frameworks.
* **Convert the Model for Inferencing on Device**.  Almost always, a model will need to be converted to work with a particular runtime (model conversion usually involves advantageous optimizations like faster inference and smaller model footprints).  This step differs for each ML framework and runtime, but there are open-source interoperability frameworks available such as ONNX and MMdnn.  
* **Build the Solution for Device**. The solution is usually built on the same type of device as will be used in the final deployment because binary files are created that are system specific.  
* **Using Runtime, Deploy Solution to Device**.  Once a runtime has been chosen (that is usually chosen in conjunction with ML framework choice), the compiled solution may be deployed.  The Azure IoT Runtime is a Docker-based system in which the ML runtimes may be deployed as containers.

The diagram below gives a picture with an example data science process wherein open source tools may be leveraged for the data science workflow.  Data availability and type will drive most of the choices, even, potentially, the devices/hardware chosen.

![Vision on the edge work flow](./images/vision_edge_flow.png)

If a workflow is already in existance for the data scientists and app developers, a few other considerations exist.  First, it is advised to have a code, model and data versioning system in place.  Secondly, an automation plan for code and integration testing along with other aspects of the data science process (triggers, build/release process, etc.) will help speed up time to production and cultivate collaboration within the team.

The language of choice can help dictate what API or SDK is used for inferencing and training ML models which will then dictate what type of ML model, what type(s) of device, what type of IoT Edge Module, etc. For example, PyTorch has a C++ API for inferencing (and now for training) that works well in conjunction with the OpenCV C++ API.  If the app developer working on the deployment strategy is building a C++ application, or has this experience, one might consider PyTorch or others (TensorFlow, CNTK, etc.) that have C++ inferencing APIs.

## Machine learning and data science in a nutshell 

In summary, here are the key considerations:

* Converting models also involves optimizations such as faster inference and smaller model footprints, critical for very resource-constrained devices
* The solution will usually need to be built on a build-dedicated device (the same type of device to which the solution will be deployed)
* The language and framework of choice will depend upon both the ML practitioners experience as well as what is available in open source
* The runtime of choice will depend upon the device and hardware acceleration for ML available
* It is important to have a code, model and data versioning system

## Next steps

Proceed to [Image storage and management in Azure IoT Edge Vision](./iot-edge-image-storage.md) article to learn how to properly store the images created by your IoT Edge Vision solution.