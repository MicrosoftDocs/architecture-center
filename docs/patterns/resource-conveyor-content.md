# Resource Conveyor Pattern

## Overview

The **Resource Conveyor Pattern** is a cloud design pattern for efficient lifecycle management of long-running, non-managed external resources such as browser instances, external APIs, or system libraries that degrade over time. This pattern ensures optimal performance by rotating resources in a conveyor-style queue, allowing for preloading, active processing, and safe offloading without new requests.

## Problem Statement

Cloud-based applications often rely on external resources that are prone to degradation over time due to memory leaks, resource exhaustion, or long-running processes. These external resources, such as browser automation, API proxies, or containers, require proper lifecycle management to avoid performance bottlenecks or resource failures.

Existing patterns like **Bulkhead**, **Competing Consumers**, or **Circuit Breaker** help manage faults or isolate resources but do not directly address long-term degradation of non-persistent resources that need constant refreshing.

## Solution

The **Resource Conveyor Pattern** introduces a **rotational queue** that manages an array of **resource instances** at different stages of their lifecycle, ensuring efficient resource management and system resilience.

### Three Positions:

1. **Preload**:  
   In this stage, **new instances** of the resource are preloaded and prepared to enter the active pool, but they are **not yet exposed** to incoming requests. These preloaded instances are standing by to replace active resources as soon as needed.

2. **Active**:  
   **Active instances** are currently handling incoming requests. This is the **live pool** of resources that the system relies on to process tasks in real-time. The conveyor ensures that there is always a **distributed set of healthy active instances** handling the workload.

3. **Offload**:  
   Once an active instance has served its purpose or has started to degrade (but can still finish its current tasks), it enters the **offload stage**. In this stage, the instance **finishes processing any remaining work** but does not accept new requests. Once the work is complete, the instance is **terminated**, ensuring that resources are flushed out before they become a liability.

### Rotating Queue:

The conveyor mechanism **rotates resources at regular intervals**, ensuring that **preloaded instances** are regularly promoted to the **active pool**, while **offloading instances** are safely terminated after completing their work. This **continuous rotation** maintains a pool of healthy resources, preventing **performance degradation** and system slowdowns caused by long-running or degraded resources.

### Self-Healing:

The **Resource Conveyor** also introduces a **self-healing mechanism**. If an **active instance** begins to degrade but remains functional, the conveyor will eventually rotate it out of the **active pool** and into the **offload stage**, ensuring that it is safely terminated before it can further affect the system.

In cases where an **active instance completely fails** or becomes corrupted, the system should detect the failure and immediately **evict the instance** from the active pool. Upon eviction, the conveyor instantly promotes a **preloaded instance** to replace the failed resource, ensuring that requests are handled seamlessly and that there is no disruption in service.

By maintaining a **distributed array of instances** across the three stages (**Preload**, **Active**, **Offload**), the system ensures that it is always operating with a **fresh set of active resources**, while any degraded or failed instances are automatically handled without manual intervention. This approach effectively prevents **resource failures** from compromising the system's stability and ensures **continuous operation**.


## Use Cases

1. **Browser Automation**:
   - Browser instances are known to degrade due to memory leaks. By rotating browser instances in a conveyor-style queue, the system prevents degradation while handling browser-based automation tasks efficiently.

2. **API Proxy Servers**:
   - API proxies that handle large volumes of requests over time can become slow due to resource exhaustion. By rotating proxies, the system ensures optimal performance.

3. **Non-Managed Libraries**:
   - Systems that rely on external, non-managed libraries often experience slowdowns or failures over time. The conveyor ensures that these libraries are periodically recycled to avoid failures.

## Diagram

![Resource Conveyor Diagram](./diagram.png)

## Implementation

### Key Components:

1. **Preload Position**: 
   - Preloads new instances of resources before they are needed.
   
2. **Active Position**:
   - Exposes active resources to handle incoming requests.

3. **Offload Position**:
   - Ensures the current resource finishes its existing work without accepting new requests and then terminates.

### Multi-Instance Resource Conveyor Code Example

```javascript
async function rotateResources() {
  const MAX_INSTANCES = 3;
  const ROTATION_INTERVAL = 180000; // Rotate every 3 minutes (180,000 milliseconds)

  let preloadInstances = [];
  let activeInstances = [];
  let offloadInstances = [];

  // Preload initial instances
  for (let i = 0; i < MAX_INSTANCES; i++) {
    preloadInstances.push(createNewInstance());
  }

  // Function to rotate instances at intervals
  setInterval(() => {
    // Move the oldest active instance to offload
    const instanceToOffload = activeInstances.shift();
    if (instanceToOffload) {
      offloadInstances.push(instanceToOffload);
    }

    // Move the oldest preload instance to active
    const instanceToActivate = preloadInstances.shift();
    if (instanceToActivate) {
      activeInstances.push(instanceToActivate);
    }

    // Create a new preload instance
    const newPreloadInstance = createNewInstance();
    preloadInstances.push(newPreloadInstance);

    // Terminate the oldest offloaded instance after completing its tasks
    const instanceToTerminate = offloadInstances.shift();
    if (instanceToTerminate) {
      terminateInstance(instanceToTerminate);
    }

  }, ROTATION_INTERVAL);
}

// Simulate instance creation
function createNewInstance() {
  return { id: generateId(), status: "preloaded" };
}

// Simulate instance termination
function terminateInstance(instance) {
  console.log(`Terminating instance: ${instance.id} at ${new Date().toISOString()}`);
  // Perform any necessary cleanup here
}

// Simulate ID generation
function generateId() {
  return Math.random().toString(36).substring(7);
}

// Start the rotation process
rotateResources();

```
### Code Description:

#### Key Steps:

##### 1. Initialization of Instances:
- Three arrays are initialized: `preloadInstances`, `activeInstances`, and `offloadInstances`, which will hold the instances in their respective lifecycle stages.
- Initially, a number of instances (defined by `MAX_INSTANCES`) are preloaded into the `preloadInstances` array.

##### 2. Rotation Logic:
- The rotation of resources is handled by a single `setInterval` function, which runs periodically based on `ROTATION_INTERVAL`.
  - The oldest active instance is moved from the `activeInstances` array to the `offloadInstances` array.
  - A new active instance is promoted from the `preloadInstances` array to replace the offloaded instance in the active pool.
  - A new instance is created and added to the `preloadInstances` array to maintain the pipeline of fresh resources.

##### 3. Termination of Offload Instances:
- After each interval, the oldest instance in the `offloadInstances` array is terminated. This ensures that the offloaded instances have completed their tasks before they are removed, maintaining system stability.

#### Core Concept:
The **Resource Conveyor Pattern** ensures that resources are continuously rotated and refreshed across three stages—**Preload**, **Active**, and **Offload**. This prevents resource exhaustion or degradation by terminating older instances after they've been safely moved to the offload stage. The key is that this process is handled by a **single interval**, making the logic simple but effective for automatic lifecycle management.


## Advantages

- **Simplicity**: Manages resource rotation automatically, preventing performance degradation over time.
- **Performance**: Maintains optimal resource performance by periodically refreshing resources.
- **Self-Healing**: Recovers from resource failures without manual intervention due to the automatic offloading and rotation of resources.
- **Modular**: Can be applied to various non-managed external resources such as APIs, browser instances, or non-native libraries in cloud environments.

## Trade-offs

- **Overhead**: The continuous rotation of resources introduces overhead, as resources must be regularly preloaded, activated, and offloaded even when not in immediate use.
- **Latency**: There may be slight latency introduced during the switch between active resources, particularly during resource-heavy operations or resource instantiation.

## Related Patterns

- [Bulkhead Pattern](https://learn.microsoft.com/azure/architecture/patterns/bulkhead)
- [Circuit Breaker Pattern](https://learn.microsoft.com/azure/architecture/patterns/circuit-breaker)
- [Competing Consumers Pattern](https://learn.microsoft.com/azure/architecture/patterns/competing-consumers)

## Conclusion

The **Resource Conveyor Pattern** provides an efficient solution for managing the lifecycle of non-managed external resources in cloud-based applications. By ensuring that resources are regularly rotated between preload, active, and offload states, this pattern prevents resource degradation and maintains optimal system performance. It can be applied to various resource-heavy or long-running processes that are prone to memory leaks, performance slowdowns, or resource exhaustion.

For a detailed justification of the Resource Conveyor pattern, please refer to the [justification document](./justification.md).
