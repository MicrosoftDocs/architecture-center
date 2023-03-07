---
title: High-performance computing (HPC) deployments
description: Review a list of applications and solutions related to HPC deployments.
author: martinekuan
ms.author: martinek
ms.date: 11/18/2022
ms.topic: conceptual
ms.service: architecture-center
ms.subservice: azure-guide
products:
  - azure-virtual-machines
  - azure-virtual-network
  - azure-cyclecloud
categories:
  - compute
  - storage
  - ai-machine-learning
  - analytics
ms.custom: fcp
---

# High-performance computing (HPC) deployments on Azure

[High-performance computing (HPC)](/azure/architecture/topics/high-performance-computing), also called *big compute*, solves complex mathematical tasks using a large number of CPU or GPU-based computers. Many industries use HPC to solve some of their most difficult problems, including genomics, semiconductor design, and weather modeling.

## Run HPC applications on Azure VMs

The articles listed here describe the steps for running various HPC applications on Azure virtual machines. They also show the performance results achieved when running each application on Azure.

|Application|Summary|
|--|--|
|[ADS CFD Code Leo](hpc-ads-cfd.yml)|Learn how Code Leo is a URANS-based flow solver that delivers accurate and fast flow simulations for general flow configurations.|
|[Altair AcuSolve](hpc-altair-acusolve.yml)|See how AcuSolve provides comprehensive software and tools to solve fluid mechanics problems.|
|[Altair EDEM](altair-edem.yml)|Use a discrete element method (DEM) to simulate and analyze the behavior of bulk materials, such as coal.|
|[Altair nanoFluidX](nanofluidx.yml)|Simulate single-phase and multiphase flows, based on a weakly compressible Lagrangian SPH formulation.|
|[Altair Radioss](altair-radioss.yml)|Predict crash response and dynamic, transient-loading effects on vehicles, structures, and other products. Radioss is a multidisciplinary finite-element solver for linear and nonlinear problems.|
|[Altair ultraFluidX](ultrafluidx.yml)|Predict the aerodynamic properties of passenger and heavy-duty vehicles, and evaluate building and environmental aerodynamics.|
|[Ansys CFX](ansys-cfx.yml)|Learn how Ansys uses an equilibrium phase change model and relies on material properties to reliably predict cavitation without the need for empirical model parameters.|
|[Ansys Fluent](ansys-fluent.yml)|Use Ansys Fluent to model fluid flow, heat and mass transfer, chemical reactions, and more.|
|[Ansys LS-DYNA](ls-dyna.yml)|Learn how Ansys LS-DYNA simulates the response of materials to short periods of severe loading for applications like drop tests, impact and penetration, smashes and crashes, and occupant safety.|
|[Ansys Rocky](ansys-rocky.yml)|Simulate the flow behavior of bulk materials with complex particle shapes and size distributions. Typical applications include conveyor chutes, mills, mixers, and other material-handling equipment.|
|[Autodesk Civil 3D](civil-3d.yml)|Learn how civil engineers use Civil 3D, for design automation and production, enabling multidisciplinary team coordination.|
|[Autodesk Inventor](autodesk-inventor.yml)|Learn how Autodesk Inventor provides professional-grade mechanical design, documentation, and product simulation tools.|
|[Autodesk VRED for HPC on Azure](hpc-autodesk-vred.md)|See how automotive designers and engineers can use Autodesk VRED to create product presentations, design reviews, and virtual prototypes by using interactive CPU and GPU ray tracing.|
|[AVL FIRE M](hpc-avl-fire-m.yml)| Learn how the AVL FIRE M computational fluid dynamics (CFD) simulation application performs on an Azure virtual machine.|
|[Barracuda Virtual Reactor](barracuda-virtual-reactor.yml)|Simulate the 3D transient behavior in fluid-particle systems, including multiphase hydrodynamics, heat balance, and chemical reactions.|
|[Engys ELEMENTS](engys-elements.yml)|Solve flow-related problems encountered in automotive design by running Engys ELEMENTS on an Azure Virtual Machine. You can also use ELEMENTS is to analyze the aerodynamics of other vehicles, like high-speed trains, motorcycles, and competition bicycles.|
|[Engys HELYX](engys-helyx.yml)|Learn how you can run Engys HELYX on a virtual machine to simulate complex flows in your engineering analysis and design optimization. HELYX is used in the automotive, aerospace, construction, marine, turbo, and energy industries.|
|[GROMACS](gromacs.yml)|Learn how GROMACS (GROningen MAChine for Simulations) is used primarily for dynamic simulations of biomolecules and provides a rich set of calculation types and preparation and analysis tools.|
|[Indica Labs HALO AI](indica-labs-halo-ai.yml)|Decipher and assess the complex patterns of histologically stained tissues in a way that's similar to how a pathologist thinks. HALO AI is a collection of train-by-example classification and segmentation tools underpinned by advanced deep learning neural network algorithms.|
|[Luxion KeyShot](luxion-keyshot.yml)|Use photon mapping to create 3D renderings, animations, and interactive visuals that make simulation of global illumination in complex scenes more efficient.|
|[OpenFOAM](openfoam.yml)|See how OpenFOAM is a free, open-source computational fluid dynamics (CFD) application where users have permission to modify and compile the package based on the needs and the physics of the problem they're solving.|
|[Remcom XFdtd](remcom-xfdtd.yml)|Learn all about XFdtd – electromagnetic simulation software that includes full-wave, static, biothermal, optimization, and circuit solvers.|
|[Samadii DEM](samadii-dem.yml)|Analyze and interpret large-scale particles at high speed. Samadii DEM uses a discrete element method (DEM), which is a Lagrangian method that determines the movement of particles by using the six-degrees-of-freedom equations of motion, taking into consideration all forces of individual particles.|
|[Samadii EM](samadii-em.yml)|See how Samadii EM (electromagnetic) analyzes the electromagnetic field in three-dimensional space by using the Maxwell equation, using the vector finite element method (FEM) and GPU computing.|
|[Samadii Plasma](plasma.yml)|Learn all about how Samadii Plasma is a particle-based solution for the analysis of plasma behavior. This solution is ideal for the manufacturing and electronics industries.|
|[Samadii SCIV](samadii-sciv.yml)|Analyze fluid behavior, deposition processes, and chemical reactions on rarefied gas regions by using the direct simulation Monte Carlo (DSMC) method. SCIV also provides functions for traditional flow simulation, display deposition processes, and semiconductor device analysis in rarefied gas regions.|
|[Sandi HiFUN](hpc-sandi-hifun.yml)|Simulate airflow over aircraft, automobiles, buildings, and ships by using Sandi HiFUN, the general-purpose computational fluid dynamics application. HiFUN is used in the aerospace, automotive, industrial, and wind/turbine industries.|
|[Siemens NX](siemens-nx.yml)|Use NX for design, simulation, and manufacturing solutions that enable digital twin technology. NX is used in the automotive sector and for projects ranging from supersonic cars to drones for the medical industry.|
|[Siemens Tecnomatix](siemens-tecnomatix.yml)|Learn how Siemens Tecnomatix is a comprehensive portfolio of digital manufacturing solutions that includes part manufacturing, assembly planning, resource planning, plant simulation, human performance, quality, production management, and manufacturing data management.|
|[Turbostream](turbostream.yml)|Enable high-fidelity methods, like unsteady full-annulus simulations, to be used as part of the routine design process.|
|[Visiopharm](visiopharm.yml)|Learn all about how Visiopharm is an AI-based image analysis and tissue mining tool that supports drug development research and other research.|
|[WRF](weather-research-forecasting.yml)|See how Weather Research & Forecasting (WRF) is a mesoscale numerical weather-prediction system that's designed for atmospheric research and operational forecasting applications. WRF serves a wide range of meteorological applications across scales from tens of meters to thousands of kilometers.|

## Related resources

- [Run a Windows VM on Azure](/azure/architecture/reference-architectures/n-tier/windows-vm)
- [Run a Linux VM on Azure](/azure/architecture/reference-architectures/n-tier/linux-vm)
- [HPC system and big-compute solutions](/azure/architecture/solution-ideas/articles/big-compute-with-azure-batch)
- [HPC cluster deployed in the cloud](/azure/architecture/solution-ideas/articles/hpc-cluster)
