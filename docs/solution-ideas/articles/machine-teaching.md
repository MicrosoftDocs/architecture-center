---
title: Machine teaching
titleSuffix: Azure Architecture Center
author: jocontr
ms.date: 07/01/2020
description: Learn how machine teaching incorporates artificial intelligence, machine learning, deep reinforcement learning, and subject matter expertise.
ms.custom: pcp
---
# Machine teaching

Artificial intelligence (AI) offers unique opportunities and challenges for operations that span the virtual and physical worlds. AI and machine learning (ML) can teach machines to recognize correlations between real-world input data and outcomes and make decisions to automate complex systems. *Deep reinforcement learning (DRL)* and *machine teaching* infuse subject matter expertise into automated systems. Focusing on subject matter expertise and abstracting away AI complexity can automate building, managing, deploying, and updating advanced AI and ML models. 

## Artificial intelligence (AI)

Humans have been designing physical tools and machines to perform tasks more efficiently for thousands of years. These technologies aim to achieve output more consistently, at a lower cost, and with less direct manual labor.

The First Industrial Revolution, late 1700s to mid-1800s, introduced machines to replace hand production methods in manufacturing. The Industrial Revolution increased production efficiency through automation with steam power, and through consolidation by moving production from homes to organized factories. The Second Industrial Revolution, mid-1800s to early 1900s, brought advances in production capability through electrification and the production line.

World Wars I and II brought major advances in information theory, communications, and signal processing. Development of the transistor allowed information theory to be easily applied to controlling physical systems. This Third Industrial Revolution allowed computer systems to make inroads in the hard-coded control of physical systems like production, transport, and healthcare. The benefits of programmed automation included consistency, reliability, and security.

The Fourth Industrial Revolution introduces the notion of cyber-physical systems and industrial Internet of Things (IoT). The systems we wish to control are often too complex to have fully prescribed rules written by humans. Artificial intelligence lets smart machines perform tasks that typically required human intelligence. Machine learning lets machines automatically learn and improve from experience without being explicitly programmed. 

AI and machine learning aren't new concepts. Much of the theory has been unchanged for decades, but recent technological advances in storage, bandwidth, and computing enable more accurate and useful algorithm predictions. Increased device processing capacity, miniaturization, storage capacity, and network capacity allow further automation of systems and equipment. These advances also allow collection and collation of vast quantities of real-time sensor data.

*Cognitive automation* is the application of software and AI to information-intensive processes and systems. Cognitive AI can augment manual workers for increased productivity, replace human workers in monotonous or hazardous fields, and allow for new insights because of huge volumes of data processing previously impossible by humans. Cognitive technologies can perform tasks that previously only humans could do, such as computer vision, natural language processing and chatbots, and robotic control.

Many current production systems using industrial robots automate and accomplish impressive feats of engineering and manufacturing. The use and evolution of industrial automation in manufacturing industries produces higher-quality, safer products with more efficient use of energy and raw materials. However, in most cases, robots can only operate in highly structured environments. They're typically inflexible to change and highly specialized toward immediate tasks. Robots may also be expensive to develop because of the hardware and software rules that govern their behaviors.

The *paradox of automation* claims that the more efficient an automated system becomes, the more crucial the human contribution of the operators is. Accordingly, the role of humans changes from mundane per-unit-of-work labor to improving and managing the automated systems and contributing essential domain expertise. While an automated system can produce output more efficiently, it can also generate waste if it's not running correctly. Efficient use of automation makes humans *more important*, not less.

### AI use cases

![Diagram of the AI use case spectrum from augmentation to autonomy.](../media/machine-teaching-1-4.png)

The preceding diagram categorizes the types of AI use cases. The use cases under **Control** and **Optimization** relate to automation, and include advanced robotics, autonomous vehicles, dark factories, smart sensors, route optimization, inventory optimization, and virtual assistants. Smart manufacturing and the [Bonsai platform](https://docs.microsoft.com/bonsai/) are examples.

In this automation of work side of the AI spectrum, there are practically infinite problem spaces. Subject matter expertise is a strategic asset, simulations are the most doable training option, and explainability is paramount.

## Machine teaching

*Machine teaching* moves focus away from the learning algorithms and onto the process of successful model generation and deployment. While machine learning experts are few, domain experts are plentiful. A perspective shift to a machine teaching methodology promotes a more streamlined process and lets domain experts generate and deploy autonomous control models. In doing so, machine teaching makes teaching machines more accessible to domain experts.

Machine teaching is the fundamental abstraction needed to efficiently program subject matter expertise, by codifying *what* to teach and *how* to teach it. Machine teaching moves the technology of AI from a focus on the power, capacity, and performance of learning algorithms and techniques to the application of these algorithms by domain experts to real-world problems.

Machine teaching raises the bar of abstraction for the engineer beyond AI algorithm selection and hyper-parameter tweaking. Machine teaching allows focusing on the most valuable portion, that of the application domain problem. With instruction and configuration from the developer, the Autonomous Systems Platform can automate the development of the most appropriate AI model into an AI system. Even more, it enables the developer to easily refresh the AI system at a future date when new AI algorithmic breakthroughs occur.

In many ways, machine teaching offers a new paradigm for building machine learning systems. It identifies patterns in the learning process itself, and adopts positive behavior into its own method. Much of the activity in machine learning is focused on improving existing algorithms or developing novel learning algorithms. In contrast, machine teaching focuses on the efficacy of the teachers themselves.

Machine teaching also leverages *simulated environments* to generate large amounts of synthetic data covering many use cases and scenarios. Simulations provide safe and cost-effective data generation for model algorithm training, and faster training times with simulation parallelization.

- Incorporating subject matter expertise from human domain experts.
- Training AI models faster and more accurately.
- Providing for greater explainability of the behavior of our resulting AI systems models.

To date, the state of machine learning is largely determined by a few algorithm experts. These experts have a deep understanding of machine learning. They can change a machine learning algorithm or architecture to meet the required performance or accuracy metrics. The number of machine learning experts globally can be estimated in the tens of thousands, which slows down the adoption of machine learning solutions. The overbearing complexity of the models puts machine learning outside the reach of many others.

Besides, machine teaching targets the larger set of domain experts. These experts understand the semantics of the problem but need not be aware of the intricacies of the learner. They can provide examples and counterexamples, and explain the difference between them. Globally, there are around tens of millions domain experts. By tapping into this larger pool, machine teaching may speed up the adoption of machine learning solutions in the workplace.

Machine teaching offers a means by which the power of deep reinforcement learning (DRL) can be applied as a tool by those with domain-specific knowledge.

To drive a car, you don't need to know how the car was built. Similarly to best apply deep reinforcement learning to a specific industrial control problem, you shouldn't need to know the details of the AI algorithms used, but what the problem is you are trying to solve and how to express it in a clear and precise manner.

Machine teaching is the missing abstraction needed to efficiently program subject matter expertise into our deep reinforcement learning model, our AI system.  It enables this by encapsulating and hiding the complexity of the underlying AI technologies, while simultaneously enabling us to codify *what* to teach, and *how* to teach it.

Fundamentally, machine teaching means bringing subject matter and domain expertise to bear - looking beyond pure algorithmic power and techniques to the application of those techniques by those with the knowledge to teach.

Likewise, the management process of building machine learning solutions can be fraught with inefficiencies, and machine teaching tries to streamline this process. Machine teaching looks at common practices of machine learning and adopts beneficial strategies into its own method. Little work has been done to date to evaluate how the development pipeline used in machine learning can be improved. Machine teaching tests this pipeline at a time of growing complexity and offers us a fresh perspective.

In enabling this perspective, it's key to provide an easily understandable central dashboard. It should track the current state of each project, link data, and store labels with version control tools.  Using this machine-teaching infrastructure ensures that model results can be reproduced time and time again.

A welcome outcome of machine teaching is a faster time to model deployment. A typical machine learning iteration, from data collection to model deployment, can take several weeks. It often must be repeated several times before the expected accuracy and performance is reached. The time to deployment can be cut down by reducing or erasing the need for manual intervention from machine learning experts at various stages in development.

Likewise, with additions such as version control, picking up later from where one left off is also easily achievable with minimal overhead. All models break eventually: perhaps the data distribution has changed, new features are available, or old features are no longer available. This can often be several months after the initial model is deployed. The ability to go back in time to retrieve and recreate the data, labels, and model timely is of paramount importance. One of the core aims of machine teaching is model reproducibility. 

### Machine learning and machine teaching

Machine learning research focuses on making the learner better by improving machine-learning algorithms. Machine teaching research focuses on making the teacher more productive at building the machine learning models. Both disciplines are complementary and can evolve independently. Machine teaching solutions require several machine learning algorithms to produce and test models throughout the teaching process.

A representative pipeline for building a machine learning model is as follows:

1. **Datasets must be collected and labeled by the problem owner**. Optionally, a label guideline may be put together, so that the task of labeling the data can be outsourced.
2. **The problem owner reviews labels, and may decide to tweak these further, remove inappropriate or inadequate data for the problem**. Steps 1 and 2 are repeated cyclically until such a point where the product owner is satisfied with the quality of the examples and associated labels.
3. **One or more machine-learning experts are consulted** to select an algorithm, model architecture, objective function, regularizers, cross-validation sets, and so on. 
4. **The model is trained cyclically, with engineers adjusting the features, or creating new features to improve model accuracy**. The model can be retweaked further to enhance speed. Models are trained and deployed on a fraction of traffic for testing.
5. **Test, rinse, repeat**. If the system doesn't do well in the test, revert to step 1.
6. **Monitor performance in field.** Once the model is deployed, model performance is monitored, and if this falls below a critical level, then the model is modified by returning to step 1.

![Typical machine learning flow.](../media/machine-teaching-2-3.png)
The square one reads ‘Start.' From here, one advances to ‘Collect and Label Dataset,' then to ‘Review labels.' If quality isn't okay, one returns to ‘Collect and Label Dataset.' If it's okay, one proceeds to ‘Consult expert: Select algorithm, model architecture, objective function, regularizers, hyper parameters, etc.' Then, if model performance is okay, one arrives at the ‘Finished' box. Otherwise, one goes to ‘Adjust features, create new features, tweak model'. If the dataset is still sufficient, one returns to checking whether model performance is okay. Otherwise, one goes back to ‘Collect and Label Dataset.'

Machine teaching automates the creation of such models, easing the need for manual intervention in the learning process to improve feature selection or training examples or tweaking of hyper-parameters. In effect, machine teaching introduces a level of abstraction into the AI elements of the model, allowing the developer to focus on the domain knowledge. This abstraction even allows the actual AI algorithm to be replaced by new more innovative algorithms in time, without requiring a respecification of the problem.

### Machine teaching and traditional programming

Machine teaching is a form of programming. The goal of both programming and machine teaching is to create a *function*. Creating a stateless target function that returns the value *Y* given an input *X*involves a set of steps.

![Machine teaching vs. programming/traditional software engineering.](../media/machine-teaching-2-5.png)

1. Specify the target function.
1. Decomposed the target function into subfunctions if applicable.
1. Debug and test the functions and subfunctions.
1. Document the functions.
1. Share the functions.
1. Deploy the functions.
1. Maintain the functions with scheduled and unscheduled debug cycles.

*Debugging* evaluates the performance of the solution. Debugging involves unique attributes. In programming, debugging includes evaluating performance, editing code manually, and recompilation. In machine teaching, debugging includes evaluating performance, adding knowledge labels and features, and further training.

Code is then edited when programming or knowledge added when teaching. The code is recompiled in programming, a step equivalent to training in machine teaching. Finally, both programming and teaching run through a Test phase. These steps can be repeated in both cases.

One of the most powerful concepts that allow software engineers to write systems that solve complex problems is *decomposition*. Decomposition uses simpler concepts to express more complex ones. Machine teachers can learn to decompose complex machine learning problems with the right tools and experiences. The machine teaching discipline can bring the expectations of success for teaching a machine to a level comparable to that of programming.

Building a target classification function that returns class *Y* given input *X* involves a machine learning algorithm, while the process for machine teaching is like the set of programming steps above.

The following table illustrates some conceptual similarities between traditional programming and machine teaching:

|Programming|Machine teaching|
|----------|----------|
|Compiler|Machine-learning algorithms, support vector machines (SVMS), neural networks|
|Operating systems, services, integrated development environments (IDEs)| Training, sampling, feature selection|
|Frameworks|ImageNet, word2vec|
|Programming languages like Python and C#| Labels, features, schemas|
|Programming expertise|Teaching expertise|
|Version control|Version control|
|Development processes like specifications, unit tests, deployment, monitoring|Teaching processes like data collection, testing, publishing|

### The machine teaching process

The role of the teacher is to optimize the transfer of knowledge to the learning algorithm so it can generate a useful model. Machine teaching refers to this mapping as a *concept*.

As you might imagine, teachers play a central role in the data collection and labeling process. They can select specific examples by filtering the set of unlabeled examples. In many cases, teachers also look at the available data of an example and guess its label, based on their own intuition or natural biases. Similarly, given two features, the teachers can conjecture that one is better than the other on a large unlabeled set.

The following image shows the high-level algorithm for the process of machine teaching:

![Flowchart showing the teaching process.](../media/machine-teaching-2-6.png)

The chart is divided into two sections: ‘Address test error' on the left and ‘Address training deficiency' on the right. The square one reads ‘Start.' From here, one enters the ‘Address test error' section. First, one questions oneself whether the training set is realizable. If the answer is yes, one questions oneself whether quality criteria are met. In case affirmative, one arrives at the ‘Finished' box. If not, one goes to ‘Find a test error; add to training set' and goes back asking whether the training set is realizable. If it's not, one enters the ‘Address training deficiency' section. If there's a labeling error, one goes to ‘Correct labeling error(s).' Otherwise, one proceeds to ‘Fix “feature blindness”.' In both cases, the next step is asking again if the training set is realizable. 

As we can see from the image, the process is a pair of indefinite loops, ending only when the model is of sufficient quality. The first loop is focused on retraining to meet the overall quality objective of the project. The second complementary loop is focused on improving the quality of the training itself.

The learning capacity of the model is increased on demand. There's no need for traditional regularization because the teacher controls the capacity of the learning system by adding features only when necessary. 

## Reinforcement learning

Reinforcement learning (RL) in machine learning concerns how software agents learn to maximize desired outcomes or rewards in their environments. RL is one of the three basic machine learning paradigms:

- Supervised learning is learning to generalize from tagged data.
- Unsupervised learning is learning to compress unlabeled data.
- Reinforcement learning is learning to act through trial and error.

While supervised learning is learning by example, reinforcement learning can be considered learning from experience. Unlike supervised learning, which focuses on finding and labeling suitable datasets, RL concentrates on designing environments in which agents learn to perform tasks.

RL uses feedback and evaluation of prior actions and experiences to predict the best possible actions to take in specific situations. RL aims to maximize a reward function over time, through sequential decision making based on the algorithm's current understanding of the environment. Deep reinforcement learning (DRL) combines deep learning neural networks with reinforcement learning.

The key components involved in RL include:

- **Agent**: the entity that can make a decision to change the current environment.
- **Environment**: the physical or simulated world in which the agent operates.
- **State**: the current situation of the agent and its environment.
- **Action**: an interaction by the agent on its environment.
- **Reward**: the feedback from the environment, following from an action of the agent.
- **Policy**: the method or function to map the current state of the agent and its environment to actions.

The goal of RL is to allow the agent to learn to complete an objective by rewarding desired behavior and penalizing undesired behavior. The following diagram illustrates the conceptual flow of RL, and how the key components interact.

![Simple diagram of the RL process](../media/machine-teaching-3-2.png)

1. An agent, in this case a robot, takes an action in an environment, in this case a smart manufacturing line.
1. The action causes the environment to change state, and the environment returns its changed state to the agent.
1. An assessment mechanism, in this case a Likert scale, applies a policy to determine what consequence to deliver to the agent.
1. The reward mechanism encourages beneficial actions by delivering a positive reward, or discourages negative actions by delivering a penalty.
1. Rewards cause desired actions to increase, while penalties cause undesired actions to decrease.

There need not be just one agent in the environment, although this is most common. Multiple agents are also valid. The agent senses the environment by observation. The environment can be fully or partially observable, as determined by the sensors accessible to the agent.

A problem can be stochastic (random) in nature, or deterministic. The observations from the world can be discrete or continuous. Each observation is followed by an action, which causes the environment to change. This cycle repeats until a terminal state is reached. Typically, the system has no memory, and the algorithm simply cares about the state it comes from, the state it arrives at, and the reward it receives.

As the agent learns through trial and error, it requires lots of data with which to evaluate its actions. RL is most applicable to domains in which simulated data can be easily produced, or in which there are large historical bodies of data.

### Reward functions

Incentives are crucial to all kinds of systems in our daily lives. Our governments use incentivization to ensure civil order, collect taxes, and provide social services. Sounds easy in concept.But it can often be tricky to get those incentives right. To determine how much to reward a particular action, we need to create a *reward function*.

The agent uses the reward function to learn about the physics and dynamics of the world around it. The fundamental process by which an agent learns to maximize its reward, at least initially, is trial and error.

The agent needs to balance exploration versus maximizing its reward, depending on what the goal is and how the reward function is specified. This is referred to as the *exploration versus exploitation trade-off*. As with many aspects of the real world, the agent must balance the merits of further exploration of the environment, which may lead to better decisions in the future, or exploitation of the environment, using all the knowledge the agent currently has about the world to maximize reward. In RL, we learn as we go, so actions taken can offer a fresh perspective, particularly if these haven't been tried before. 

The reward structure is normally left to the system owner to define. Adjusting this parameter can significantly affect results. Creating good reward functions is more involved than might first be realized.

Rewards are subject to what is known in economics as the *cobra effect*. During the British rule of colonial India, the government became concerned about the number of cobra snakes and decided to offer a reward for every dead cobra to cull the snake population. Initially, this appeared to be a success, as large numbers of the snakes were killed to claim the reward. However, it did not take long for people to start gaming the system, and breeding cobras deliberately to collect the reward. Eventually, the governing authorities noticed this and canceled the program.

With no further incentive, the cobra breeders set their snakes free, with a result that the wild cobra population actually increased compared to what it was at the start of the incentive. The well-intentioned incentivization had made the situation worse, not better. The learning from this is that you get what you incentivize, which may not be what you intended.

Creating a reward function with a particular *shape* can allow the agent to learn an appropriate policy much easier and quicker. 

In the following examples, **Reward** is shown on the y-axis, while **Distance** is on the x-axis.

A step function is an example of a *sparse reward function* that doesn't tell the agent much about how good its action was. In the following step reward function, only a distance action between 0.0 and 0.1 generates. When distance is greater than 0.1, there is no reward.

![Chart showing a step reward function](../media/machine-teaching-3-4.png)

In contrast, a shaped reward function gives the agent a sign of how close the action is to the desired response. The following shaped reward function gives a greater reward depending on how close the response is to the desired 0.0 action. The curve of the function is a hyperbola. The reward is 1.0 for distance 0.0 and gradually drops to 0.0 as distance approaches 1.0.

![Chart showing a shaped reward function](../media/machine-teaching-3-4-2.png)

Shaping might discount the value of a future reward versus a more immediate reward, or encourage exploration by shrinking the size of rewards around the goal.

The following training dashboard shows the exploration versus exploitation trade-off. The chart shows both the smoothed rewards and episode rewards, with the episode rewards on the y-axis and the training iterations on the x-axis. The episode reward rises to 400 in the first 50,000 iterations, then keeps steady until 400,000 iterations, after which it remains a steady 1,500 episode reward.

![Chart showing exploration versus exploitation trade-off](../media/machine-teaching-3-4-3.png)

Sometimes, a reward function might specify temporal as well as spatial considerations, to encourage ordered sequences of actions. However, if a staged reward function is becoming large and complex, you should break up the problem into smaller stages and consider using *concept networks* instead.

### Concept networks

*Concept networks* allow specifying and reusing domain-specific knowledge and subject matter expertise to collect a wanted ordering of behavior into a specific sequence of separate tasks. Concept networks help constrain the search space within which the agent can operate and take actions.

In the following concept network for grasping and stacking objects, the **Grasp and Stack**' box is the parent of two gray boxes, **Reach** and **Move**, and three green boxes, **Orient**, **Grasp**, and **Stack**.

![Example concept network](../media/machine-teaching-3-4-4.png)

Concept networks often allow reward functions to be more easily defined. Each concept can use the most appropriate approach for that task. The notion of concept networks helps with decomposability of the solution into constituent pieces. Components can be replaced without retraining the whole system, allowing reuse of pre-trained models and use of existing controllers or other existing ecosystem components. Especially in industrial control systems, incremental piecemeal improvement is often much more desirable than complete removal and replacement.

Dividing the problem into separate sequential tasks with concept networks allows splitting up the problem into stages of difficulty and presenting it to the agent as a *curriculum* of increasing difficulty. This phased approach starts with a simple problem, lets the agent practice, then challenges it more and more as its ability increases. The reward function changes and evolves as the agent becomes more capable at its task. This *curriculum learning* approach helps guide exploration and drastically reduces required training time. 

You can also constrain the policy search space for the agent by instructing it to learn by mimicking the behavior of an external expert. *Apprenticeship learning* uses expert-guided exemplars to constrain the state space the agent explores. Apprenticeship learning trades off learning known solutions more quickly at the expense of not discovering novel solutions.

A concrete example of apprenticeship learning is teaching a self-driving car agent to mimic the actions of a human driver. The agent learns how to drive, but also inherits any flaws and idiosyncrasies of the teacher.

### Design RL projects

Prerequisites

- Some experience with gathering, exploring, cleaning, preparing, and analyzing data
- Familiarity with basic ML concepts like objective functions, training, cross-validation, and regularization

When building a DRL project, start with a true to life but relatively simple model, to allow for fast iteration and formulation. Then, iteratively improve the fidelity of the model, and make the model more generalizable through better scenario coverage.

The following diagram shows the phases of iterative RL model development. Each successive step requires more training samples.

![Diagram showing the phases of iterative model development.](../media/machine-teaching-3-6.png)

1. Initial setup: rough simulation model for approach validation
2. Simulation fidelity: enhance model of environment dynamics concurrent with iterative teaching refinement
3. Generalization: dynamics randomization and expansion
4. Live equipment: measure real system dynamics and test trained model on real equipment.
5. Expand model to cover more equipment variation.

The following strategy is a practical guide to constructing and building DRL-based AI system:

1. Formulate and iterate on states, terminal conditions, actions, and rewards.
1. Craft reward functions, shaping them as necessary.
1. Allocate rewards for specific subgoals.
1. Discount rewards aggressively if necessary.
1. Experiment with initial states.
1. Experiment with a sampling of examples for training.
1. Limit variation of simulation dynamics parameters during training.
1. Generalize during prediction and keep training as smooth as possible.
1. Introduce some physically relevant noise to accommodate noise in real machines.

There's quite a bit of experimentation and empirical exploration in figuring out the exact parameters for RL-based AI systems. A machine teaching service like [Bonsai](https://docs.microsoft.com/bonsai/) in the [Microsoft Autonomous Systems Platform](https://www.microsoft.com/ai/autonomous-systems-platform) builds on DRL innovations to help simplify AI model development.

### Sample applications

In the following DRL machine teaching examples aim to create policies to control the motions of physical systems. In the cartpole example, a cart must move to keep a pole balanced on top of it without going off track. The oil drilling example automates control of a horizontal oil drill according to a predefined drilling plan.

In both cases, creating a policy for the agent by hand is either infeasible or incredibly difficult. Allowing the agent to explore the space in simulation and guiding it to make choices through reward functions produces accurate solutions.

#### Cartpole or inverted pendulum

Consider a pole attached by an unactivated joint to a cart, which moves along a frictionless track. Applying a force to the cart controls the system. The pendulum starts upright, and the goal is to prevent it from falling over. A positive reward is provided for every time step that the pole remains upright. The episode ends when the pole is over 15 degrees from vertical, or the cart moves more than a predefined number of units from the center.

The available sensor information includes the cart position and velocity, and the pole angle and angular velocity. The supported agent actions are to push the cart to the left or the right.

For more information about the cartpole example or to try it yourself, see [Quickstart: Balance a pole with AI (Cartpole)](https://docs.microsoft.com/bonsai/quickstart/cartpole/) and [Learn how you can teach an AI agent to balance a pole](https://blogs.microsoft.com/ai-for-business/cartpole-demo/).

#### Oil drilling

This application is a motion controller to automates oil rigs that drill horizontally underground. An operator controls the drill underground with a joystick to keep the drill inside the oil shale while avoiding obstacles. The goal is to use reinforcement learning to automate control of the horizontal oil drill. A positive reward is provided when the drill is within the tolerance distance of the chamber walls.

The available sensor information includes the direction of drill bit force, weight of the drill bit, side force, and drilling angle. The supported agent actions are to move the drill bit up, down, left, or right.

The model learns to take as few steering actions as possible, leading to faster drilling. For more information and a demo of this solution, see [Motion contorl: Horizontal oil drilling](https://aidemos.microsoft.com/machineteaching/motion-control).

## Simulations

AI systems are data-hungry and require exposure to many representative scenarios to ensure they're trained to make appropriate decisions. The systems themselves often require expensive prototypes, and the risks of damaging these in real-world environments are consequential. The cost of collecting and manually labeling high fidelity training data can be tremendously significant, both in terms of time and direct labor costs. Using simulators and densely labeled training data generated by simulators is a powerful means of addressing much of this data deficit.

Simulations allow an alternative approach to having to collect huge amounts of real-world training data. They allow the designers to explore the design space virtually, by modeling the system in its intended physical environment. Simulations allow training in hazardous environments, or in conditions difficult to reproduce in the real world, like various types of weather conditions.

### The curse of dimensionality

*The curse of dimensionality* refers to the phenomena that arise when dealing with large quantities of data in high-dimensional spaces. Accurately modeling certain scenarios and problem sets requires the use of deep neural networks. These networks themselves are highly dimensional, with many parameters that need fitting. As dimensionality increases, the volume of the space increases at such a rate that available real-world data becomes sparse. It becomes challenging to collect enough real-world data to make any correlations in it statistically significant, greatly complicating machine learning. Without enough data, training results in a model that underfits the data and doesn't generalize well to new data, which is the purpose of a model.

The problem is twofold:

- The training algorithm has a large learning capacity to accurately model the problem, but needs a significant quantum of data to prevent underfitting.
- Collecting and labeling this large corpus of data, if doable, is difficult, expensive, and error-prone.

Artificially simulated data sidesteps the difficulty in data collection, and keeps algorithms appropriately fed with example scenarios that allow them to accurately generalize to real-world scenarios.
Simulations are the ideal training source for deep reinforcement learning. They are:

- Flexible to custom environments.
- Safe and cost-effective for data generation.
- Parallelizable, allowing for faster training times.

Simulations are available across a broad range of industries and systems, including mechanical and electrical engineering, autonomous vehicles, security and networking, transportation and logistics, and robotics.

Various simulation tools exist, including:

- Simulink, a graphical programming tool, developed by MathWorks, for the modeling, simulating, and analysis of dynamic systems. 
- Gazebo, a tool to allow accurate simulation of populations of robots in complex indoor and outdoor environments, and to ease the design, testing, and evaluation of robotic systems and the training of AIs.
- Microsoft AirSim, an open-source robotics simulation platform.

### AirSim

[Microsoft AirSim (Aerial Informatics and Robotics Simulation)](https://microsoft.github.io/AirSim/) is an open-source robotics simulation platform, designed to train autonomous systems. From ground vehicles, wheeled robotics, aerial drones, and even static IoT devices, AirSim can capture data for models without costly field operations.

AirSim provides realistic environments, vehicle dynamics, and multi-modal sensing for researchers building autonomous vehicles that use AI to enhance their safe operation in the open world.

Engineers building autonomous systems create accurate, detailed models of both systems and environments, making them intelligent using methods such as deep learning, imitation learning, and reinforcement learning. Tools such as autonomous systems AI can be used to train the models across different kinds of environmental conditions and vehicle scenarios in the Microsoft Azure cloud, much faster and safer than is feasible in the real world. After training is complete, designers may deploy these trained models onto actual hardware.

Machine learning has become an increasingly important AI approach to building autonomous and robotic systems. One of the key challenges with machine learning is the need for massive data sets, and the amount of data needed to learn useful behaviors can be prohibitively high. Since a new robotic system is often non-operational during the training phase, the development and debugging phases with real-world experiments must deal with the unpredictability of the solution in development, including any physical hazards that might entail.

AirSim solves these two problems: the need for large data sets for training and the ability to debug in a simulator. AirSim:

- Provides a realistic simulation tool for designers and developers for the seamless generation of the amount of training data they require. 
- Leverages current game engine rendering, physics, and perception computation to create an accurate, real-world simulation. AirSim works as a plug-in to Epic Games' Unreal Engine 4 editor, providing control over building environments and simulating difficult-to-reproduce, real-world events to capture meaningful data for AI models.

Together, this realism, based on efficiently generated ground-truth data, enables the study and execution of complex missions that are time-consuming or risky in the real world. For example, collisions in a simulator cost virtually nothing, yet provide actionable information for improving the design of the system.

For more information about AirSim, see [Welcome to AirSim](https://microsoft.github.io/AirSim/).

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
