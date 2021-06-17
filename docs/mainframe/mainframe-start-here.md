---
title: Azure mainframe and midrange solution journey
titleSuffix: Azure Architecture Center
description: An overview of Microsoft's Azure mainframe and midrange architectural concepts and guidance offerings.
author: EdPrice-MSFT
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

# Azure mainframe and midrange solution journey

Mainframe and midrange  hardware is comprised of a family of systems from various vendors all with a history and goal of high performance, high throughput, and sometimes high availability.  These systems were often “scale-up” and monolithic, meaning they were a single, large frame with multiple processing units, shared memory, and shared storage.

On the application side, programs were often written in one of two flavors, either transactional or batch.  In both cases, there were a variety of programming languages that were used including COBOL, PL/I, Natural, Fortran, REXX, and more.  Despite the age and complexity of these legacy systems, there are many migration pathways to Azure.

On the data side, data is usually stored in files and in databases. Mainframe and midrange databases commonly come in a variety of possible structures such as relational, hierarchical, and network, among others. There are different types of file organizational systems where some of them can be indexed and can act as a Key-Value stores. Further, data encoding in mainframes can be different from the encodings usually handled in non-mainframe systems. Therefore, data migrations should be handled with upfront planning and there are many options for migrating to the Azure Data Platform.

#TODO: Add image

## Migrating legacy systems to Azure

In many cases, mainframe, midrange, and other legacy workloads can be replicated in Azure with little to no loss of functionality and sometimes without users noticing changes in their underlying systems. In other instances, there are options for refactoring and re-engineering the legacy solution into an architecture in alignment with the cloud – while still maintaining the same or very similar functionality.  The architectures in this section plus the additional white papers and other resources provided below will help to guide you through this process.

## Mainframe and midrange concepts

### Mainframes

Mainframes were designed as scale-up servers to run high-volume online transactions and batch processing in the late 1950s. As such, mainframes have software for online transaction forms (sometimes called green screens) and high-performance I/0 systems for processing the batch runs. Mainframes have a reputation for high reliability and availability, in addition to their ability to run online and batch jobs.
