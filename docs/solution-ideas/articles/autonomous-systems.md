---
title: Microsoft Autonomous Systems Platform
titleSuffix: Azure Example Scenarios
author: jocontr
ms.date: 07/01/2020
description: Learn how the Microsoft Autonomous Systems platform uses machine teaching concepts like deep reinforcement learning and simulations to build and deploy automated systems in Bonsai.
ms.custom: pcp
---
# Autonomous systems

Artificial intelligence (AI) offers unique opportunities and challenges for operations that span the virtual and physical worlds. AI and machine learning (ML) can recognize correlations between real-world input data and outcomes and make decisions to automate complex physical industrial systems. For background information, see [Artificial intelligence](machine-teaching.md#artificial-intelligence).

AI machine learning systems are good at finding correlations between sensor data and outcomes. However, AI systems can't perform higher-level cognitive abilities such as improvisation and decision-making, creative thinking, or determination of causation. [Autonomous systems](https://www.microsoft.com/ai/autonomous-systems) infuse subject matter expertise into automated AI systems models through *machine teaching*.

Machine teaching is a new paradigm for machine learning systems that uses *deep reinforcement learning (DRL)* to identify patterns in the learning process itself, and adopt positive behaviors in its own methods. Abstracting away AI complexity and automate building, managing, deploying, and updating advanced AI and ML models.It Much of the activity in machine learning is focused on improving existing algorithms or developing novel learning algorithms. In contrast, machine teaching focuses on the efficacy of the teachers themselves.

Machine teaching also leverages *simulated environments* to generate large amounts of synthetic data covering many use cases and scenarios. Simulations provide safe and cost-effective data generation for model algorithm training, and faster training times with simulation parallelization.

Automated systems share common attributes, and creating them presents similar challenges. Machine teaching can help automate systems when:

- Existing control systems and machine learning techniques are insufficient. Existing systems are fragile when deployed, or decision logic doesn't adequately cover all possible scenarios.
- Describing the desired system behavior requires subject matter experts who understand the problem domain.
- Generating sufficient real-world data to ensure coverage of all possible scenarios is expensive, challenging, time-consuming, or labor intensive.
- Traditional control systems are difficult to deploy and scale in the real world.

Autonomous systems:

- Combine human domain knowledge with AI and ML through machine teaching.
- Integrate simulations for model optimization and scalability during training.
- Automate generation and management of DRL algorithms and models.
- Deploy and scale automated systems for real-world use.

The [Microsoft Autonomous Systems Platform](https://www.microsoft.com/ai/autonomous-systems-platform) is an innovative framework for building, training, and deploying autonomous systems by using DRL, machine teaching, and simulations. Example applications include motion control, machine calibration, smart buildings, industrial robotics, and process control.

The Microsoft Autonomous Systems Platform's deployment and runtime frameworks simplify the operation, management, and scalability of models across cloud, on-premises, IoT Edge, and embedded device deployment scenarios. Managed Azure graphics processing unit (GPU) clusters run AI training at scale, with built-in support for retraining and analyzing AI system versions. The resulting AI system models can be packaged and deployed to do predictions from complex neural networks at scale.

This approach bridges AI science and software to the traditional engineering world, enabling fields such as chemical and mechanical engineering to build smarter, more capable and more efficient systems by augmenting their own expertise with AI capabilities.

## Architecture

![Autonomous Systems Platform](../media/machine-teaching-1-2.png)

The Microsoft Autonomous Systems Platform manages the full end-to-end machine teaching lifecycle. Autonomous Systems Platform development and deployment has three phases: Build, Train, and Deploy.

1. The Build phase consists of using Bonsai to write the machine teaching program in Inkling and connect to a domain-specific training simulator. The simulator generates sufficient training data for experiments and machine practice.
3. In the Train phase, the training engine automates the generation and training of DRL models. by combining high-level domain models with appropriate DRL algorithms and neural networks.
5. The Deploy phase deploys the trained brain to the target application in the cloud, on-premises, or embedded on site in an IoT layer. Specific SDKs and deployment APIs deploy trained AI systems to various target applications, perform machine tuning, and control the physical systems.

## Components

### Bonsai

Bonsai, now in public preview, is the machine teaching service to create and optimize AI for industrial control systems in the Autonomous Systems suite. Through machine teaching, subject matter experts without an AI background can break down their expertise into steps and tasks and impart them to AI agents. The experts can specify desired outcomes and criteria, then supervise the AI agents as they work to solve problems in simulated virtual environments. The experts provide feedback and guidance that trains the AI agents to dynamically adapt within the simulation. Once they're sufficiently trained in the simulation, the AI agents can use their knowledge to power autonomous systems in real-world applications.

The Bonsai platform simplifies machine teaching with deep reinforcement learning (DRL) to train and deploy smarter autonomous systems. Bonsai lets engineers easily build intelligent control logic to optimize system operations and automate real-time decisions for equipment or processes in a dynamic physical environment.

Use Bonsai to:
- Train adaptive brains with intuitive goals and learning objectives, real-time success assessments, and automatic versioning control.
- Integrate training simulations that implement real-world problems and provide realistic feedback during training.
- Export the optimized brain and deploy it on-premises, in the cloud, or at the IoT Edge.

The Bonsai platform runs on Azure and charges resource costs to your Azure subscription:
- Azure Container Registry (basic tier) for storing exported brains and uploaded simulators.
- Azure Container Instances for running simulations.
- Azure Storage for storing uploaded simulators as zip files.

### Training engine

The training engine compiles machine teaching programs to automatically generate and train AI systems, by:

- Automating model generation, management, and tuning.
- Choosing the neural network architecture (number of layers, topology), selecting the best DRL algorithm, tuning hyper-parameters of the model, and so on.
- Connecting to the simulator and orchestrating the training.

Broadly similar to how a software compiler hides the complexity of the bare metal machine code from the high-level programmer, the training engine hides much of the complexity and details of dealing with DRL algorithms. As the state of the art in AI evolves and new algorithms and network topologies are invented, the training engine can recompile the same machine teaching programs to exploit these new technology advances.

The following Bonsai machine training screenshot shows **Goal satisfaction** on the y-axis and **Training iterations** on the x-axis. The dashboard also shows the total amount of goal satisfactions and the total training time.

![Example of a Bonsai dashboard showing training in progress.](../media/bonsai.png)

### Cartpole simulator and training example

In the following DRL machine teaching example, creating a policy for the agent by hand is either infeasible or incredibly difficult. Allowing the agent to explore the space in simulation and guiding it to make choices through reward functions produces accurate solutions.

Consider a pole attached by an unactivated joint to a cart, which moves along a frictionless track. Applying a force to the cart controls the system. The pendulum starts upright, and the goal is to keep it upright while keeping the cart on the track. A positive reward is provided for every time step that the pole remains upright. The episode ends when the pole is over 15 degrees from vertical, or the cart moves more than a predefined number of units from the center.

The available sensor information includes the cart position and velocity, and the pole angle and angular velocity. The supported agent actions are to push the cart to the left or the right.

For more information about the cartpole example or to try it yourself, see [Quickstart: Balance a pole with AI (Cartpole)](https://docs.microsoft.com/bonsai/quickstart/cartpole/) and [Learn how you can teach an AI agent to balance a pole](https://blogs.microsoft.com/ai-for-business/cartpole-demo/).

## Deployment

As an example of an autonomous systems AI project in action, consider the use case of a manufacturing process optimization. Specifically, we want to optimize the thickness tolerance of a steel beam being manufactured on a production line. Rollers provide pressure across a piece of steel to shape it into the designed thickness. The machine state inputs to the AI system are the rolling force, roller error, and roller noise.

The control actions from the AI system will be actuator commands to control the operation and motion of the rollers, and optimize the thickness tolerance of the steel beam.

First, find or develop a simulator that can simulate agents, sensors, and the environment. The following Matlab simulation model provides an accurate training environment for this AI system:

![Simulink model for steel beam manufacturing process](../media/machine-teaching-4-4-3.png)

Use the Bonsai machine teaching service in the Microsoft Autonomous Systems Platform to build a machine teaching plan into a model, train the model against the simulator, and deploy the trained AI system to the real production facility.

[Inkling](https://docs.microsoft.com/bonsai/inkling/) is a purpose-specific language to formally describe machine teaching plans. Through Inkling, deconstruct the problem into the key concepts to teach the AI system:

![Define machine state and control action in Inkling](../media/machine-teaching-4-4-4.png)

Then, create a *curriculum*, or set of lessons, to teach the AI system, specifying the reward function for the simulation state:

![Define curriculum in Inkling.](../media/machine-teaching-4-4-5.png)

Upload the simulation into Azure and use Bonsai to control training, providing visualizations for training progress as it runs. The AI system learns by practicing the optimization task in simulation, following the concepts of machine teaching.

After building and training the model or *brain*, export it to deploy to the production facility, where optimal actuator commands stream from the AI engine to support operator decisions in real time.

## Learn more

In this article, we've covered a wide range of topics related to machine teaching. If you want to go deeper, we encourage you to check the next resources:

* [Microsoft The AI Blog](https://blogs.microsoft.com/ai/).
* [Bonsai documentation](https://docs.microsoft.com/bonsai/).
* [Bonsai, “AI for Everyone,” 2016 March 2]( https://medium.com/@BonsaiAI/ai-for-everyone-4ddd36c89859).
* [Bonsai, “AI use cases: innovations solving more than just toy problems,” 2017 March 2](https://medium.com/@BonsaiAI/ai-use-cases-9d1b70e61396).
* [Patrice Y. Simard, Saleema Amershi, David M. Chickering, et al., “Machine Teaching: A New Paradigm for Building Machine Learning Systems,” 2017](https://arxiv.org/abs/1707.06742v2).
* [Carlos E. Perez, “Deep Teaching: The Sexiest Job of the Future,” 2017 July 29](https://medium.com/intuitionmachine/why-teaching-will-be-the-sexiest-job-of-the-future-a-i-economy-b8e1c2ee413e).
* [Tambet Matiisen, “Demystifying deep reinforcement learning,” 2015 December 19](https://neuro.cs.ut.ee/demystifying-deep-reinforcement-learning/).
* [Andrej Karpathy, “Deep Reinforcement Learning: Pong from Pixels,” 2016 May 31](http://karpathy.github.io/2016/05/31/rl/).
* [Wikipedia, “End-to-end reinforcement learning”](https://en.wikipedia.org/wiki/End-to-end_reinforcement_learning).
* [Wikipedia, “Reinforcement learning”](https://en.wikipedia.org/wiki/Reinforcement_learning).
* [Wikipedia, “Cobra effect”](https://en.wikipedia.org/wiki/Cobra_effect).
* [David Kestenbaum, “Pop Quiz: How Do You Stop Sea Captains From Killing Their Passengers?,” 2010 September 10](https://www.npr.org/sections/money/2010/09/09/129757852/pop-quiz-how-do-you-stop-sea-captains-from-killing-their-passengers?t=1556642213216).
* [GitHub repo of Microsoft AirSim](https://github.com/Microsoft/AirSim).
* [Aerial Informatics and Robotics Platform](https://www.microsoft.com/en-us/research/project/aerial-informatics-robotics-platform/).
* [Gazebo](http://gazebosim.org/).
* [Simulink](https://www.mathworks.com/products/simulink.html).
