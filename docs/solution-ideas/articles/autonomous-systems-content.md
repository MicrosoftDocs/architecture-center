[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Artificial intelligence (AI) and machine learning offer unique opportunities and challenges for automating complex industrial systems. *Machine teaching* is a new paradigm for building machine learning systems that moves the focus away from algorithms and towards successful model generation and deployment.

Machine teaching infuses subject matter expertise into automated AI system training with *deep reinforcement learning (DRL)* and *simulations*. Abstracting away AI complexity to focus on subject matter expertise and real-world conditions creates models that turn automated control systems into *autonomous systems*.

Autonomous systems are automated control systems that:

- Use machine teaching to combine human domain knowledge with AI and machine learning.
- Automate the generation and management of DRL algorithms and models.
- Integrate simulations for model optimization and scalability during training.
- Deploy and scale for real-world use.

## Potential use cases

Project Bonsai speeds the creation of AI-powered automation to improve product quality and efficiency while reducing downtime. It's now available in preview, and you can use it to automate systems. Consider Bonsai when you face issues such as:

- Existing control systems are fragile when deployed.
- Machine learning logic doesn't adequately cover all scenarios.
- Describing the desired system behavior requires subject matter experts who understand the problem domain.
- Generating sufficient real-world data to cover all scenarios is difficult or impossible.
- Traditional control systems are difficult to deploy and scale to the real world.

Machine teaching bridges AI science and software with traditional engineering and domain expertise. Example applications include:

- Motion control
- Machine calibration
- Smart buildings
- Industrial robotics
- Process control

## Architecture

Project Bonsai speeds the creation of AI-powered automation. Development and deployment has three phases: Build, Train, and Deploy.

![Diagram that shows the architecture of Project Bonsai.](../media/machine-teaching-1-2.png)

### Workflow

1. The Build phase consists of writing the machine teaching program and connecting to a domain-specific training simulator. Simulators generate sufficient training data for experiments and machine practice.

   Subject matter experts with no AI background can express their expertise as steps, tasks, criteria, and desired outcomes. Engineers build autonomous systems by creating accurate, detailed models of systems and environments, and making the systems intelligent using methods like deep learning, imitation learning, and reinforcement learning.

1. In the Train phase, the training engine automates DRL model generation and training by combining high-level domain models with appropriate DRL algorithms and neural networks.

   Simulations train the models across different kinds of environmental conditions and scenarios much faster and safer than is feasible in the real world. Experts can supervise the agents as they work to solve problems in simulated environments, and provide feedback and guidance that lets the agents dynamically adapt within the simulation.

1. The Deploy phase deploys the trained *brain* to the target application in the cloud, on-premises, or embedded on site. Specific SDKs and deployment APIs deploy trained AI systems to various target applications, perform machine tuning, and control the physical systems.

   After training is complete, engineers deploy these trained agents to the real world, where they use their knowledge to power autonomous systems.

### Components

- [Project Bonsai](https://azure.microsoft.com/services/project-bonsai simplifies) machine teaching with DRL to train and deploy smart autonomous systems.
- [Azure Container Registry](https://azure.microsoft.com/services/container-registry) is a managed, private Docker registry service that's used to store and manage container images and artifacts for all types of container deployments. Images are securely stored, and can be replicated to other regions to speed up deployment. You can build on demand or automate builds with triggers, such as source code commits and base image updates. Container Registry is based on the open-source Docker Registry 2.0

  This architecture uses the basic tier of Container Registry to store exported brains and uploaded simulators.
- [Azure Container Instances](https://azure.microsoft.com/services/container-instances) runs containers on-demand in a serverless Microsoft Azure environment. Container Instances is the fastest and simplest way to run a container in Azure, and doesn't require you to provision virtual machines or adopt a higher-level service.

  This architecture uses Container Instances to run simulations.
- [Azure Storage](https://azure.microsoft.com/services/storage) is a cloud storage solution that includes object, blob, file, disk, queue, and table storage.

  This architecture uses Storage for storing uploaded simulators as ZIP files.

## Deploy this scenario

The following implementations are example deployments. You can follow the resources to understand how these solutions were designed. Use Project Bonsai to build and deploy your own solution.

### Machine teaching service

You can use Bonsai to:

- Teach adaptive brains with intuitive goals and learning objectives, real-time success assessments, and automatic versioning control.
- Integrate training simulations that implement real-world problems and provide realistic feedback.
- Export trained brains and deploy them on-premises, in the cloud, or to IoT Edge devices or embedded devices.

Here's the Bonsai user interface:

![Bonsai user interface](../media/bonsai-ui.png)

In Bonsai, managed Azure graphics processing unit (GPU) clusters run AI training on complex neural networks at scale, with built-in support for retraining and analyzing AI system versions. The deployment and runtime frameworks package and deploy the resulting AI system models at scale.

The Bonsai platform runs on Azure and charges resource costs to your Azure subscription.

#### Inkling

Inkling is a declarative, statically-typed programming language for training AI in Bonsai. Inkling abstracts away the dynamic AI algorithms that require expertise in machine learning, enabling more developers to program AI. An Inkling file defines *concepts* necessary to teach the AI, and a *curriculum* to teach the concepts.

![Inkling example](../media/inkling.png)

For more information about Inkling, see the [Inkling programming language reference](/bonsai/inkling).

#### Training engine

The training engine in Bonsai compiles machine teaching programs to automatically generate and train AI systems. It does the following:

- Automates model generation, management, and tuning.
- Defines the neural network architecture. It specifies characteristics such as number of layers and topology, selects the best DRL algorithm, and tunes the hyper-parameters of the model.
- Connects to the simulator and orchestrates the training.

Just as a language compiler hides the machine code from the programmer, the training engine hides the details of the machine learning models and DRL algorithms. As new algorithms and network topologies are invented, the training engine can recompile the same machine teaching programs to exploit them.

#### Cartpole sample

Bonsai includes two machine teaching samples, Cartpole and [Moab](https://microsoft.github.io/moab).

The Cartpole sample has a pole attached to a cart by an unactivated joint. The cart moves along a straight frictionless track and the pole moves forward and backward, depending on the movements of the cart. The available sensor information includes the cart position and velocity and pole angle and angular velocity. The supported agent actions are to push the cart to the left or the right.

The pole starts upright, and the goal is to keep it upright as the cart moves. There is a reward generated for every time interval that the pole remains upright. A training episode ends when the pole is more than 15 degrees from vertical, or when the cart moves more than a predefined number of units from the center of the track.

The sample uses Inkling to write the machine teaching program, and a Cartpole simulator to speed and improve the training.

![A depiction of the Cartpole simulator, and some Inkling code](../media/cartpole.png)

The following Bonsai screenshot shows Cartpole training progress, with **Goal satisfaction** on the y-axis and **Training iterations** on the x-axis. The dashboard also shows the percentage of goal satisfaction and the total elapsed training time.

![Bonsai dashboard showing the Cartpole training example](../media/bonsai.png)

For more information about the Cartpole example, or to try it yourself, see:

- [Quickstart: Balance a pole with AI (Cartpole)](/bonsai/quickstart/cartpole)
- [Learn how you can teach an AI agent to balance a pole](https://blogs.microsoft.com/ai-for-business/cartpole-demo)

### Simulators

Simulations model a system in a virtual representation of its intended physical environment. Simulations are an alternative approach to creating learning policies by hand or collecting large amounts of real-world training data. Simulations allow training in hazardous environments, or in conditions difficult to reproduce in the real world.

Simulations are the ideal training source for DRL because they:

- Can flexibly create custom environments.
- Are safe and cost-effective for data generation.
- Can run concurrently on multiple training machines to speed up training.

Simulations are available across a broad range of industries and systems such as mechanical and electrical engineering, autonomous vehicles, security and networking, transportation and logistics, and robotics.

Simulation tools include:

- [Simulink](https://www.mathworks.com/products/simulink.html), a graphical programming tool developed by MathWorks to model, simulate, and analyze dynamic systems.
- [Gazebo](http://gazebosim.org), which simulates populations of robots in complex indoor and outdoor environments.
- [Microsoft AirSim](https://microsoft.github.io/AirSim), an open-source robotics simulation platform.

The Bonsai platform includes Simulink and AnyLogic simulators. You can add others.

#### AirSim

[Microsoft AirSim (Aerial Informatics and Robotics Simulation)](https://microsoft.github.io/AirSim) is an open-source robotics simulation platform designed to train autonomous systems. AirSim provides a realistic simulation tool for designers and developers to generate the large amounts of data they need for model training and debugging.

AirSim can capture data from ground vehicles, wheeled robotics, aerial drones, and even static IoT devices, and do it without costly field operations.

![AirSim screenshot](../media/machine-teaching-4-3-2.png)

AirSim works as a plug-in to the [Unreal Engine](https://www.unrealengine.com) editor from Epic Games, providing control over building environments and simulating difficult-to-reproduce, real-world events to capture meaningful data. AirSim leverages current game engine rendering, physics, and perception computation to create an accurate, real-world simulation.

This realism, based on efficiently generated ground-truth data, enables the study and execution of complex missions that are time-consuming or risky in the real world. For example, AirSim provides realistic environments, vehicle dynamics, and multi-modal sensing for researchers building autonomous vehicles. Collisions in a simulator cost virtually nothing, yet provide actionable information to improve the design of the system.

You can use an [Azure Resource Manager (ARM) template](https://github.com/microsoft/AirSim/blob/master/azure/azure-env-creation/vm-arm-template.json) to automatically create a development environment, and code and debug a Python application connected to AirSim in Visual Studio Code. For more information, see [AirSim Development Environment on Azure](https://microsoft.github.io/AirSim/azure).

## Contributors

*This article is maintained by Microsoft. It was originally written by the following contributors.*

Principal author:

[Jose Contreras](https://www.linkedin.com/in/josedanielcontreras/) | Principal Software Engineering Manager

## Next steps

- [Autonomous systems with Microsoft AI](https://www.microsoft.com/ai/autonomous-systems)
- [Autonomy for industrial control systems](https://www.microsoft.com/ai/autonomous-systems-solutions)
- [Innovation space: Autonomous systems (Video)](https://www.youtube.com/watch?v=3hSAFtWcui8&feature=youtu.be)
- [Microsoft The AI Blog](https://blogs.microsoft.com/ai)
- [Microsoft Autonomous Systems](/autonomous-systems)
- [Bonsai documentation](/bonsai)
- [Aerial Informatics and Robotics Platform (AirSim)](https://www.microsoft.com/research/project/aerial-informatics-robotics-platform)

## Related resources

- [Use subject matter expertise in machine teaching and reinforcement learning](machine-teaching.yml)
- [Building blocks for autonomous-driving simulation environments](../../industries/automotive/building-blocks-autonomous-driving-simulation-environments.yml)
- [Compare the machine learning products and technologies from Microsoft](../../data-guide/technology-choices/data-science-and-machine-learning.md)
- [How Azure Machine Learning works: Architecture and concepts](/azure/machine-learning/concept-azure-machine-learning-architecture)
