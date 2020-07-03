---
title: Machine teaching with Microsoft Autonomous Systems Platform
titleSuffix: Azure Example Scenarios
author: jocontr
ms.date: 07/01/2020
description: Learn how the Microsoft Autonomous Systems platform uses machine teaching, deep reinforcement learning, and simulations to build and deploy autonomous systems with Bonsai.
ms.custom: pcp
---
# Machine teaching for autonomous systems

*Artificial intelligence (AI)* offers unique opportunities and challenges for operations that span the virtual and physical worlds. AI and *machine learning (ML)* can teach machines to recognize correlations between real-world input data and outcomes and to make decisions that automate complex systems.

*Machine teaching* infuses subject matter expertise into automated AI systems by using *deep reinforcement learning (DRL)* and *simulations*. Abstracting away AI complexity to focus on subject matter expertise and real-world conditions creates powerful AI and ML models that can turn automated control systems into *autonomous systems*.

Autonomous systems:

- Combine human domain knowledge with AI and ML through machine teaching.
- Automate generation and management of DRL algorithms and models.
- Integrate simulations for model optimization and scalability during training.
- Deploy and scale automated systems for real-world use.

The [Microsoft Autonomous Systems](https://www.microsoft.com/ai/autonomous-systems-platform) platform is an innovative framework for building, training, and deploying autonomous systems by using machine teaching and simulations. This approach bridges AI science and software with the traditional engineering world, enabling fields such as chemical and mechanical engineering to build smarter, more capable and more efficient systems. Example applications include motion control, machine calibration, smart buildings, industrial robotics, and process control.

Use the Autonomous Systems platform to help automate systems when:

- Existing control systems and machine learning techniques are insufficient. Existing systems are fragile when deployed, or decision logic doesn't adequately cover all possible scenarios.
- Describing the desired system behavior requires subject matter experts who understand the problem domain.
- Generating sufficient real-world data to ensure coverage of all possible scenarios is expensive, challenging, time-consuming, or labor intensive.
- Traditional control systems are difficult to deploy and scale in the real world.

The Autonomous Systems platform's deployment and runtime frameworks simplify the operation, management, and scalability of models across cloud, on-premises, IoT Edge, and embedded device scenarios. Managed Azure graphics processing unit (GPU) clusters run AI training at scale, with built-in support for retraining and analyzing AI system versions. The platform packages and deploys the resulting AI system models to do predictions from complex neural networks at scale.

## Architecture

The Microsoft Autonomous Systems platform manages the full end-to-end machine teaching lifecycle. Autonomous Systems Platform development and deployment has three phases: Build, Train, and Deploy.

![Autonomous Systems Platform](../media/machine-teaching-1-2.png)

1. The Build phase consists of writing the machine teaching program in Inkling and connecting to a domain-specific training simulator. The simulator generates sufficient training data for experiments and machine practice.
3. In the Train phase, the training engine automates the generation and training of DRL models by combining high-level domain models with appropriate DRL algorithms and neural networks.
5. The Deploy phase deploys the trained brain to the target application in the cloud, on-premises, or embedded on site in an IoT layer. Specific SDKs and deployment APIs deploy trained AI systems to various target applications, perform machine tuning, and control the physical systems.

Engineers building autonomous systems create accurate, detailed models of both systems and environments, making them intelligent using methods such as deep learning, imitation learning, and reinforcement learning. Tools such as autonomous systems AI can be used to train the models across different kinds of environmental conditions and vehicle scenarios in the Microsoft Azure cloud, much faster and safer than is feasible in the real world. After training is complete, designers can deploy these trained models onto actual hardware.

## Components

Through machine teaching, subject matter experts with no AI background can break down their expertise into steps and tasks, and specify desired outcomes and criteria. The experts impart the tasks and criteria to AI agents, then supervise the agents as they work to solve problems in simulated virtual environments. The experts provide feedback and guidance that trains the AI agents to dynamically adapt within the simulation. Once they're sufficiently trained in the simulation, the AI agents can use their knowledge to power autonomous systems in real-world applications.

### Bonsai

[Bonsai](https://azure.microsoft.com/services/project-bonsai/) is the machine teaching service for the Autonomous Systems platform. Bonsai simplifies machine teaching with deep reinforcement learning (DRL) to train and deploy smarter autonomous systems. Bonsai lets engineers easily build intelligent control logic to optimize system operations and automate real-time decisions for equipment or processes in a dynamic physical environment.

Use Bonsai to:
- Train adaptive brains with intuitive goals and learning objectives, real-time success assessments, and automatic versioning control.
- Integrate training simulations that implement real-world problems and provide realistic feedback during training.
- Export the optimized brain and deploy it on-premises, in the cloud, or at the IoT Edge.

The Bonsai platform runs on Azure and charges resource costs to your Azure subscription.
- Azure Container Registry (basic tier) for storing exported brains and uploaded simulators.
- Azure Container Instances for running simulations.
- Azure Storage for storing uploaded simulators as zip files.

### Inkling

[Inkling](https://docs.microsoft.com/bonsai/inkling/) is a declarative, statically-typed programming language for training AI with Bonsai. Inkling abstracts away the dynamic AI algorithms that require expertise in machine learning, enabling more developers to program AI. An Inkling file consists of *concepts* necessary to teach the AI, and *curriculum*, or methods for teaching the concepts.

For more information about Inkling, see the [Inkling programming language reference](https://docs.microsoft.com/bonsai/inkling/).

### Training engine

The training engine in Bonsai compiles machine teaching programs to automatically generate and train AI systems. The engine:

- Automates model generation, management, and tuning.
- Chooses neural network architecture such as number of layers and topology, selects the best DRL algorithm, and tunes hyper-parameters of the model.
- Connects to the simulator and orchestrates the training.

Broadly similar to how a software compiler hides the bare metal machine code from the high-level programmer, the training engine hides much of the complexity and details of the ML models and DRL algorithms. As the state of the art in AI evolves and new algorithms and network topologies are invented, the training engine can recompile the same machine teaching programs to exploit these technological advances.

### Cart pole simulator and sample

Bonsai offers a couple of ready-made simulators, including MathWorks Simulink and AnyLogic, and sample AI programs including Cartpole and Moab samples.

The Cartpole or inverted pendulum example has a pole attached by an unactivated joint to a cart, which moves along a frictionless track. Applying a force to the cart controls the system. The pendulum starts upright, and the goal is to keep it upright while keeping the cart on the track. 

The available sensor information includes the cart position and velocity, and the pole angle and angular velocity. The supported agent actions are to push the cart to the left or the right. Every time step that the pole remains upright generates a reward. The episode ends when the pole is over 15 degrees from vertical, or the cart moves more than a predefined number of units from the center.

The following Bonsai screenshot shows the Cartpole training progress, with **Goal satisfaction** on the y-axis and **Training iterations** on the x-axis. The dashboard also shows the percentage of goal satisfaction and the total training time.

![Bonsai dashboard showing the Cartpole training example](../media/bonsai.png)

For more information about the cart pole example or to try it yourself, see:
- [Quickstart: Balance a pole with AI (Cart pole)](https://docs.microsoft.com/bonsai/quickstart/cartpole/)
- [Learn how you can teach an AI agent to balance a pole](https://blogs.microsoft.com/ai-for-business/cartpole-demo/)

### Simulators

When creating a policy for an agent by hand is either infeasible or incredibly difficult, allowing the agent to explore the space in simulation and guiding it to make choices through reward functions produces faster, more accurate solutions.

### AirSim

[Microsoft AirSim (Aerial Informatics and Robotics Simulation)](https://microsoft.github.io/AirSim/) is an open-source robotics simulation platform designed to train autonomous systems. AirSim can capture data for models from ground vehicles, wheeled robotics, aerial drones, and even static IoT devices, without costly field operations.

![AirSim screenshot](../media/machine-teaching-4-3-2.png)

AirSim provides large data sets for training and the ability to debug in a simulator. AirSim provides a realistic simulation tool for designers and developers for the seamless generation of the amount of training data they require. 

AirSim works as a plug-in to Epic Games' Unreal Engine 4 editor, providing control over building environments and simulating difficult-to-reproduce, real-world events to capture meaningful data for AI models. AirSim leverages current game engine rendering, physics, and perception computation to create an accurate, real-world simulation.

This realism, based on efficiently generated ground-truth data, enables the study and execution of complex missions that are time-consuming or risky in the real world. For example, collisions in a simulator cost virtually nothing, yet provide actionable information for improving the design of the system.

AirSim provides realistic environments, vehicle dynamics, and multi-modal sensing for researchers building autonomous vehicles that use AI to enhance their safe operation in the real world.

You can use an [Azure Resource Manager (ARM) template](https://github.com/microsoft/AirSim/blob/master/azure/azure-env-creation/vm-arm-template.json) to automatically create a development environment on Azure and code and debug a Python application connected to AirSim using Visual Studio Code. For more information, see [AirSim Development Environment on Azure](https://microsoft.github.io/AirSim/azure/).