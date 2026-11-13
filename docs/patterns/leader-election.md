---
title: Leader Election Pattern
description: Learn how to use the Leader Election pattern to coordinate the actions performed by a collection of collaborating task instances in a distributed application.
ms.author: pnp
author: claytonsiemens77
ms.date: 11/12/2026
ms.topic: design-pattern
ms.subservice: cloud-fundamentals
ai-usage: ai-assisted
---

# Leader Election pattern

Coordinate collaborating instances in a distributed application by electing one instance as the leader. The leader manages coordination to help prevent conflicts, contention for shared resources, and interference between instances.

## Context and problem

A cloud application can have many tasks that need coordination. These tasks might be instances running the same code and accessing the same resources, or they might perform parts of a complex calculation in parallel.

The task instances might work independently most of the time. When they interact, coordination helps prevent conflicts, contention for shared resources, and interference with each other's work.

For example:

- In a cloud-based system that implements horizontal scaling, multiple instances of the same task could be running at the same time with each instance serving a different user. If these instances write to a shared resource, you need to coordinate their actions to prevent each instance from overwriting the changes made by the others.
- If the tasks are performing individual elements of a complex calculation in parallel, you need to aggregate the results when they all complete.

The task instances are all peers, so there isn't a natural leader that can act as the coordinator or aggregator.

## Solution

Elect a single task instance as the leader to coordinate the other task instances. If all of the task instances are running the same code, they're each capable of acting as the leader. Therefore, you must manage the election process carefully to prevent two or more instances from taking over the leader position at the same time.

The leader election mechanism must handle network outages and process failures. In many solutions, the other instances monitor the leader through heartbeats or polling. If the leader terminates unexpectedly or becomes unreachable, the instances need to elect a new leader.

Choose an established coordination mechanism for leader election. Options include:

- Racing to acquire a shared, distributed mutex. The first task instance that acquires the mutex is the leader. However, the system must ensure that if the leader terminates or becomes disconnected from the rest of the system, the mutex is released to allow another task instance to become the leader.
- Using an established coordination library or service, such as [Apache ZooKeeper](https://zookeeper.apache.org/) with [Apache Curator](https://curator.apache.org/docs/recipes-leader-election/), or [etcd](https://etcd.io/) with its [Go client's election API](https://pkg.go.dev/go.etcd.io/etcd/client/v3/concurrency#Election).
- Using Kubernetes [`Lease` objects](https://kubernetes.io/docs/concepts/architecture/leases/#custom-workload) for workloads that already run as Kubernetes controllers. Controller replicas use the Kubernetes API for coordination without a separate coordination service.

## Issues and considerations

Consider the following points when deciding how to implement this pattern:

- The process of electing a leader must be resilient to transient and persistent failures.
- Stop leader-specific work when ownership is lost or can't be confirmed. Lease expiration doesn't stop the old process; use resource-side ownership checks to reject stale-leader writes. Make replayed business operations idempotent.
- Set and test a failover target that includes failure detection, lease expiration or election processing, service and retry delays, and new-leader startup. Don't assume immediate takeover.
- Plan for leader termination during scale-in. Stop or checkpoint leader work before voluntarily releasing leadership.
- Keep coordination stateless where possible. If the leader tracks task assignments or partial results, persist this state and any checkpoints in durable storage that other candidates can access. After an unexpected leader failure, recover or reconstruct progress before the new leader resumes coordination. For more information, see [Well-Architected Framework guidance on checkpoints](/azure/well-architected/reliability/self-preservation#application-design-guidance).
- Use expiring ownership, such as a renewable lease, so another instance can take over if the leader fails or disconnects.
- Using a shared, distributed mutex introduces a dependency on the external service that provides the mutex. The service constitutes a single point of failure. If it becomes unavailable for any reason, the system won't be able to elect a leader.
- Retain records of leadership acquisition, loss, and voluntary release. Track leaderless duration, election frequency, and lease-renewal failures. Alert when leaderless duration exceeds your failover target, election frequency exceeds an established baseline, or pending work stops progressing.
- Apply least privilege to coordination resources. Scope role assignments to the resources each candidate uses, and grant only the actions needed to participate in leader election. Pre-create shared coordination resources with a separate deployment identity so runtime instances don't need provisioning or administrative permissions.
- Using a single dedicated process as the leader is a straightforward approach. However, if the process fails there could be a significant delay while it's restarted. This delay affects the performance and response times of processes waiting for coordination.
- Evaluate correctness guarantees, failure handling, and operational requirements when choosing a coordination implementation. Prefer an established implementation over a custom election algorithm.
- Avoid making the leader a bottleneck. It coordinates work but doesn't have to perform that work itself. Each instance should still be able to perform work when it isn't the leader.
- For workloads with independent partitions, elect a leader per partition so coordination can be distributed across instances. Give each partition a separate election scope. For more information, see [Minimize coordination](../guide/design-principles/minimize-coordination.yml#recommendations).

## When to use this pattern

Use this pattern when the tasks in a distributed application, such as a cloud-hosted solution, need careful coordination and there's no natural leader.

This pattern might not be useful if:

- There's a natural leader or dedicated process that can always act as the leader. For example, it might be possible to implement a singleton process that coordinates the task instances. If this process fails or becomes unhealthy, the system can shut it down and restart it.
- The coordination between tasks can be achieved by using a more lightweight method. For example, if several task instances simply need coordinated access to a shared resource, a better solution is to use optimistic or pessimistic locking to control access.

## Workload design

An architect should evaluate how the Leader Election pattern can be used in their workload's design to address the goals and principles covered in the [Azure Well-Architected Framework pillars](/azure/well-architected/pillars). For example:

| Pillar | How this pattern supports pillar goals |
| :----- | :------------------------------------- |
| [Reliability](/azure/well-architected/reliability/checklist) design decisions help your workload become **resilient** to malfunction and to ensure that it **recovers** to a fully functioning state after a failure occurs. | This pattern allows another instance to take over coordination when a leader fails.<br/><br/> - [RE:05 Redundancy](/azure/well-architected/reliability/redundancy)<br/> - [RE:07 Self-healing](/azure/well-architected/reliability/self-preservation) |

As with any design decision, consider any tradeoffs against the goals of the other pillars that might be introduced with this pattern.

## Example

The [Leader Election sample on GitHub](https://github.com/Azure-Samples/cloud-design-patterns/tree/main/leader-election) uses an Azure Storage blob lease as a shared, distributed mutex. The first worker instance to acquire the lease becomes the leader and retains leadership until it releases the lease or can't renew it. Other worker instances monitor the lease in case the leader becomes unavailable.

### Blob lease details

A blob lease provides exclusive write and delete access to a blob. A blob can have only one lease at a time. A worker instance can acquire a lease on a specified blob if no other instance holds the lease. Otherwise, the request throws an exception.

Specify a lease lifetime to prevent a failed leader from retaining the lease indefinitely. If the lease expires instead of being explicitly released, another instance might need to [wait up to one minute](/azure/storage/blobs/storage-blob-lease#lease-states-and-actions) before acquiring a new lease. While an instance holds the lease, it can renew it to retain leadership.

For more information on how to lease a blob, see [Lease Blob (REST API)](/rest/api/storageservices/lease-blob).

### Leader code implementation

The `BlobDistributedMutex` class uses `RunTaskWhenMutexAcquiredAsync` to attempt to acquire a blob lease. Its constructor accepts a `BlobSettings` struct containing the blob name, container name, and Blob service URI. It also accepts a `Func<CancellationToken, Task>` delegate for the work to run when the instance becomes the leader. The `BlobLeaseManager` helper class handles lease acquisition.

The following excerpts omit supporting code and aren't standalone programs. Use the linked sample's README for setup and execution instructions.

```csharp
public class BlobDistributedMutex(
  BlobSettings blobSettings,
  Func<CancellationToken, Task> taskToRunWhenLeaseAcquired,
  Action? onLeaseTimeoutRetry = null)
{
  ...
  private readonly BlobSettings blobSettings = blobSettings;
  private readonly Func<CancellationToken, Task> taskToRunWhenLeaseAcquired = taskToRunWhenLeaseAcquired;
  ...

  public async Task RunTaskWhenMutexAcquiredAsync(CancellationToken token)
  {
    var leaseManager = new BlobLeaseManager(blobSettings);
    await RunTaskWhenBlobLeaseAcquiredAsync(leaseManager, token);
  }
  ...
}
```

The `RunTaskWhenMutexAcquiredAsync` method in the preceding code sample invokes the `RunTaskWhenBlobLeaseAcquiredAsync` method shown in the following code sample to actually acquire the lease. The `RunTaskWhenBlobLeaseAcquiredAsync` method runs asynchronously. If the lease is successfully acquired, the worker instance is elected the leader. The purpose of the `taskToRunWhenLeaseAcquired` delegate is to perform the work that coordinates the other worker instances. If acquisition fails, the current instance doesn't start leader-specific work. Note that the `TryAcquireLeaseOrWaitAsync` method is a helper method that uses the `BlobLeaseManager` object to acquire the lease.

```csharp
  private async Task RunTaskWhenBlobLeaseAcquiredAsync(
    BlobLeaseManager leaseManager, CancellationToken token)
  {
    while (!token.IsCancellationRequested)
    {
      // Try to acquire the blob lease.
      // Otherwise wait for a short time before trying again.
      string? leaseId = await TryAcquireLeaseOrWaitAsync(leaseManager, token);

      if (!string.IsNullOrEmpty(leaseId))
      {
        // Create a new linked cancellation token source so that if either the
        // original token is canceled or the lease can't be renewed, the
        // leader task can be canceled.
        using var leaseCts = CancellationTokenSource.CreateLinkedTokenSource([token]);

        // Run the leader task.
        var leaderTask = taskToRunWhenLeaseAcquired.Invoke(leaseCts.Token);
        ...
      }
    }
  }
```

While leader work runs, `KeepRenewingLeaseAsync` attempts to renew the lease before it expires. This attempt keeps the worker instance the leader. The following excerpt shows how the sample runs leader work and lease renewal together.

```csharp
  private async Task RunTaskWhenBlobLeaseAcquiredAsync(
    BlobLeaseManager leaseManager, CancellationToken token)
  {
    while (!token.IsCancellationRequested)
    {
      ...
      if (!string.IsNullOrEmpty(leaseId))
      {
        ...
        // Keep renewing the lease in regular intervals.
        // If the lease can't be renewed, then the task completes.
        var renewLeaseTask = KeepRenewingLeaseAsync(leaseManager, leaseId, leaseCts.Token);

        // When any task completes (either the leader task itself or when it
        // couldn't renew the lease) then cancel the other task.
        await CancelAllWhenAnyCompletesAsync(leaderTask, renewLeaseTask, leaseCts);
      }
    }
  }
```

When either task completes, `CancelAllWhenAnyCompletesAsync` requests cancellation and waits for both tasks to finish. The leader's code must check its [cancellation token](/dotnet/standard/threading/cancellation-in-managed-threads) and stop when cancellation is requested. The following diagram illustrates the coordination flow.

:::image type="content" source="./_images/leader-election-diagram.png" alt-text="Diagram that illustrates the behavior of the BlobDistributedMutex class.":::

The following illustrative example uses a blob named `leader` in the `leases` container. Your application supplies `storageUri`, the Blob service URI, and `cancellationToken`, its shutdown token. Implement the local function `MyLeaderCoordinatorTaskAsync` to coordinate work and observe cancellation.

```csharp
BlobSettings blobSettings = new(storageUri, "leases", "leader");

// Create a new BlobDistributedMutex object with the BlobSettings object and a task to run when the lease is acquired
BlobDistributedMutex distributedMutex = new(blobSettings, MyLeaderCoordinatorTaskAsync);

// Wait for completion of the DistributedMutex and the task before exiting
await distributedMutex.RunTaskWhenMutexAcquiredAsync(cancellationToken);

...

// Local function that runs if the worker instance is elected the leader
static async Task MyLeaderCoordinatorTaskAsync(CancellationToken token)
{
  ...
}
```

Consider the following limitations and behaviors of the sample:

- If Blob Storage or its network path is unavailable, workers can't acquire or renew leases. Plan for intervals without a leader.
- Account for delayed renewal requests. The sample requests cancellation when renewal fails, but a delayed request can remain pending after the lease expires. Another worker can then become leader while the original leader still runs. Add a way to request cancellation when the lease expires, even if renewal is still pending.
- Don't assume immediate takeover. Lease release isn't guaranteed, so another worker might need to wait for lease expiration and further service or retry delays.
- Monitor leader progress as well as lease renewal. The sample can renew the lease even when leader work stalls, blocking takeover.
- The election process is nondeterministic. Don't assume which worker instance acquires the lease and becomes the leader.
- Use a dedicated blob for leader election. While the lease is active, write and delete requests for that blob must include the active lease ID. Authorized read requests don't require a lease ID.
- The sample doesn't show how other resources can reject updates from a worker that is no longer the leader.

## Next steps

The following guidance might also be relevant when implementing this pattern:

- [Autoscaling](../best-practices/auto-scaling.md). Start and stop task host instances as application load changes to help maintain throughput and performance during peak processing.
- Read about the [task-based asynchronous pattern](/dotnet/standard/asynchronous-programming-patterns/task-based-asynchronous-pattern-tap).
- For background on leader election and consensus algorithms, see the [Bully algorithm](https://en.wikipedia.org/wiki/Bully_algorithm), [Raft consensus algorithm](https://raft.github.io/), and [Chang and Roberts algorithm](https://en.wikipedia.org/wiki/Chang_and_Roberts_algorithm).
