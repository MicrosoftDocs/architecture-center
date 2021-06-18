---
title: Azure mainframe and midrange architecture
titleSuffix: Azure Architecture Center
description: An overview of Microsoft's Azure mainframe and midrange architectural concepts and guidance offerings.
author: jjfrost
ms.author: jfrost
ms.date: 06/18/2021
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: reference-architecture
products:
  - azure
ms.custom:
  - overview
  - fcp
---

# Azure mainframe and midrange architecture

Mainframe and midrange  hardware is comprised of a family of systems from various vendors (all with a history and goal of high performance, high throughput, and sometimes high availability). These systems were often _scale-up_ and monolithic, meaning they were a single, large frame with multiple processing units, shared memory, and shared storage.

On the application side, programs were often written in one of two flavors: either transactional or batch. In both cases, there were a variety of programming languages that were used, including COBOL, PL/I, Natural, Fortran, REXX, and so on.  Despite the age and complexity of these systems, there are many migration pathways to Azure.

On the data side, data is usually stored in files and in databases. Mainframe and midrange databases commonly come in a variety of possible structures, such as relational, hierarchical, and network, among others. There are different types of file organizational systems, where some of them can be indexed and can act as a key-value stores. Further, data encoding in mainframes can be different from the encoding usually handled in non-mainframe systems. Therefore, data migrations should be handled with upfront planning. There are many options for migrating to the Azure data platform.

#TODO: Add image

## Migrating legacy systems to Azure

In many cases, mainframe, midrange, and other server-based workloads can be replicated in Azure with little to no loss of functionality. Sometimes users do not notice changes in their underlying systems. In other situations, there are options for refactoring and re-engineering the legacy solution into an architecture that is in alignment with the cloud. This is done while still maintaining the same or very similar functionality. The architectures in this content set (plus the additional white papers and other resources provided below) will help guide you through this process.

## Mainframe and midrange concepts

In our mainframe architectures, we use the following terms.

### Mainframes

Mainframes were designed as scale-up servers to run high-volume online transactions and batch processing in the late 1950s. As such, mainframes have software for online transaction forms (sometimes called green screens) and high-performance I/0 systems, for processing the batch runs. Mainframes have a reputation for high reliability and availability, in addition to their ability to run online and batch jobs.

#### Mainframe storage

Part of demystifying mainframes involves decoding various overlapping terms. For example, central storage, real memory, real storage, and main storage generally all refer to storage that is attached directly to the mainframe processor.  Mainframe hardware includes processors and many other devices, such as direct access storage devices (DASDs), magnetic tape drives, and several types of user consoles. Tapes and DASDs are used for system functions and by user programs.

_Types of physical storage:_
* **Central storage**. Located directly on the mainframe processor, it's also known as _processor storage_ or _real storage_. 
* **Auxiliary storage**. Located separately from the mainframe, it includes storage on DASDs, which is also known as _paging storage_.
