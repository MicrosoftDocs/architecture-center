---
title: Configure resilience and recovery on Elasticsearch on Azure
description: Considerations related to resiliency and recovery for Elasticsearch.
services: ''
documentationcenter: na
author: dragon119
manager: bennage
editor: ''
tags: ''
pnp.series.title: Elasticsearch on Azure
pnp.series.prev: data-aggregation-and-query-performance
pnp.series.next: performance-testing-environment
ms.assetid: 2da4d716-5bba-4ae8-bedf-d40c49f4c2c7
ms.service: guidance
ms.devlang: na
ms.topic: article
ms.tgt_pltfrm: na
ms.workload: na
ms.date: 09/22/2016
ms.author: masashin
---
# Configure resilience and recovery
[!INCLUDE [header](../_includes/header.md)]

A key feature of Elasticsearch is the support that it provides for resiliency in the event of node failures and/or network partition events. Replication is the most obvious way in which you can improve the resiliency of any cluster, enabling Elasticsearch to ensure that more than one copy of any data item is available on different nodes in case one node should become inaccessible. If a node becomes temporarily unavailable, other nodes containing replicas of data from the missing node can serve the missing data until the problem is resolved. In the event of a longer term issue, the missing node can be replaced with a new one, and Elasticsearch can restore the data to the new node from the replicas.

Here we summarize the resiliency and recovery options available with Elasticsearch when hosted in Azure, and describe some important aspects of an Elasticsearch cluster that you should consider to minimize the chances of data loss and extended data recovery times.

This article also illustrates some sample tests that were performed to show the effects of different types of failures on an Elasticsearch cluster, and how the system responds as it recovers.

An Elasticsearch cluster uses replicas to maintain availability and improve read performance. Replicas should be stored on different VMs from the primary shards that they replicate. The intention is that if the VM hosting a data node fails or becomes unavailable, the system can continue functioning using the VMs holding the replicas.

## Using dedicated master nodes
One node in an Elasticsearch cluster is elected as the master node. The purpose of this node is to perform cluster management operations such as:

* Detecting failed nodes and switching over to replicas.
* Relocating shards to balance node workload.
* Recovering shards when a node is brought back online.

You should consider using dedicated master nodes in critical clusters, and ensure that there are 3 dedicated nodes whose only role is to be master. This configuration reduces the amount of resource intensive work that these nodes have to perform (they do not store data or handle queries) and helps to improve cluster stability. Only one of these nodes will be elected, but the others will contain a copy of the system state and can take over should the elected master fail.

## Controlling high availability with Azure – update domains and fault domains
Different VMs can share the same physical hardware. In an Azure datacenter, a single rack can host a number of VMs, and all of these VMs share a common power source and network switch. A single rack-level failure can therefore impact a number of VMs. Azure uses the concept of fault domains to try and spread this risk. A fault domain roughly corresponds to a group of VMs that share the same rack. To ensure that a rack-level failure does not crash a node and the nodes holding all of its replicas simultaneously, you should ensure that the VMs are distributed across fault domains.

Similarly, VMs can be taken down by the [Azure Fabric Controller](https://azure.microsoft.com/documentation/videos/fabric-controller-internals-building-and-updating-high-availability-apps/) to perform planned maintenance and operating system upgrades. Azure allocates VMs to update domains. When a planned maintenance event occurs, only VMs in a single update domain are effected at any one time. VMs in other update domains are left running until the VMs in the update domain being updated are brought back online. Therefore, you also need to ensure that VMs hosting nodes and their replicas belong to different update domains wherever possible.

> [!NOTE]
> For more information about fault domains and update domains, see [Manage the availability of virtual machines](/azure/virtual-machines/virtual-machines-linux-manage-availability/?toc=%2fazure%2fvirtual-machines%2flinux%2ftoc.json).
> 
> 

You cannot explicitly allocate a VM to a specific update domain and fault domain. This allocation is controlled by Azure when VMs are created. However, you can specify that VMs should be created as part of an availability set. VMs in the same availability set will be spread across update domains and fault domains. If you create VMs manually, Azure creates each availability set with two fault domains and five update domains. VMs are allocated to these fault domains and update domains, cycling round as further VMs are provisioned, as follows:

| VM | Fault domain | Update domain |
| --- | --- | --- |
| 1 |0 |0 |
| 2 |1 |1 |
| 3 |0 |2 |
| 4 |1 |3 |
| 5 |0 |4 |
| 6 |1 |0 |
| 7 |0 |1 |

> [!IMPORTANT]
> If you create VMs using the Azure Resource Manager, each availability set can be allocated up to 3 fault domains and 20 update domains. This is a compelling reason for using the Resource Manager.
> 
> 

In general, place all VMs that serve the same purpose in the same availability set, but create different availability sets for VMs that perform different functions. With Elasticsearch this means that you should consider creating at least separate availability sets for:

* VMs hosting data nodes.
* VMs hosting client nodes (if you are using them).
* VMs hosting master nodes.

Additionally, you should ensure that each node in a cluster is aware of the update domain and fault domain it belongs to. This information can help to ensure that Elasticsearch does not create shards and their replicas in the same fault and update domains, minimizing the possibility of a shard and its replicas from being taken down at the same time. You can configure an Elasticsearch node to mirror the hardware distribution of the cluster by configuring [shard allocation awareness](https://www.elastic.co/guide/en/elasticsearch/reference/current/allocation-awareness.html#allocation-awareness). For example, you could define a pair of custom node attributes called *faultDomain* and *updateDomain* in the elasticsearch.yml file, as follows:

```yaml
node.faultDomain: \${FAULTDOMAIN}
node.updateDomain: \${UPDATEDOMAIN}
```

In this case, the attributes are set using the values held in the *\${FAULTDOMAIN}* and *\${UPDATEDOMAIN}* environment variables when Elasticsearch is started. You also need to add the following entries to the Elasticsearch.yml file to indicate that *faultDomain* and *updateDomain* are allocation awareness attributes, and specify the sets of acceptable values for these attributes:

```yaml
cluster.routing.allocation.awareness.force.updateDomain.values: 0,1,2,3,4
cluster.routing.allocation.awareness.force.faultDomain.values: 0,1
cluster.routing.allocation.awareness.attributes: updateDomain, faultDomain
```

You can use shard allocation awareness in conjunction with [shard allocation filtering](https://www.elastic.co/guide/en/elasticsearch/reference/2.0/shard-allocation-filtering.html#shard-allocation-filtering) to specify explicitly which nodes can host shards for any given index.

If you need to scale beyond the number of fault domains and update domains in an availability set, you can create VMs in additional availability sets. However, you need to understand that nodes in different availability sets can be taken down for maintenance simultaneously. Try to ensure that each shard and at least one of its replicas are contained within the same availability set.

> [!NOTE]
> There is currently a limit of 100 VMs per availability set. For more information, see [Azure subscription and service limits, quotas, and constraints](/azure/azure-subscription-service-limits/).
> 
> 

### Backup and restore
Using replicas does not provide complete protection from catastrophic failure (such as accidentally deleting the entire cluster). You should ensure that you back up the data in a cluster regularly, and that you have a tried and tested strategy for restoring the system from these backups.

Use the Elasticsearch [snapshot and restore APIs](https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-snapshots.html) : Elastic doesn't cap these.>> to backup and restore indexes. Snapshots can be saved to a shared filesystem. Alternatively, plugins are available that can write snapshots to the Hadoop distributed file system (HDFS) (the [HDFS plugin](https://github.com/elasticsearch/elasticsearch-hadoop/tree/master/repository-hdfs)) or to Azure storage (the [Azure plugin](https://github.com/elasticsearch/elasticsearch-cloud-azure#azure-repository)).

Consider the following points when selecting the snapshot storage mechanism:

* You can use [Azure File storage](https://azure.microsoft.com/services/storage/files/) to implement a shared filesystem that is accessible from all nodes.
* Only use the HDFS plugin if you are running Elasticsearch in conjunction with Hadoop.
* The HDFS plugin requires you to disable the Java Security Manager running inside the Elasticsearch instance of the Java virtual machine (JVM).
* The HDFS plugin supports any HDFS-compatible file system provided that the correct Hadoop configuration is used with Elasticsearch.

## Handling intermittent connectivity between nodes
Intermittent network glitches, VM reboots after routine maintenance at the datacenter, and other similar events can cause nodes to become temporarily inaccessible. In these situations, where the event is likely to be short lived, the overhead of rebalancing the shards occurs twice in quick succession (once when the failure is detected and again when the node become visible to the master) can become a significant overhead that impacts performance. You can prevent temporary node inaccessibility from causing the master to rebalance the cluster by setting the *delayed\_timeout* property of an index, or for all indexes. The example below sets the delay to 5 minutes:

```http
PUT /_all/settings
{
    "settings": {
    "index.unassigned.node_left.delayed_timeout": "5m"
    }
}
```

For more information, see [Delaying allocation when a node leaves](https://www.elastic.co/guide/en/elasticsearch/reference/current/delayed-allocation.html).

In a network that is prone to interruptions, you can also modify the parameters that configure a master to detect when another node is no longer accessible. These parameters are part of the [zen discovery](https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-discovery-zen.html#modules-discovery-zen) module provided with Elasticsearch, and you can set them in the Elasticsearch.yml file. For example, the *discovery.zen.fd.ping.retries* parameter specifies how many times a master node will attempt to ping another node in the cluster before deciding that it has failed. This parameter defaults to 3, but you can modify it as follows:

```yaml
discovery.zen.fd.ping_retries: 6
```

## Controlling recovery
When connectivity to a node is restored after a failure, any shards on that node will need to be recovered to bring them up to date. By default, Elasticsearch recovers shards in the following order:

* By reverse index creation date. Newer indexes are recovered before older indexes.
* By reverse index name. Indexes that have names that are alphanumerically greater than others will be restored first.

If some indexes are more critical than others, but do not match these criteria you can override the precedence of indexes by setting the *index.priority* property. Indexes with a higher value for this property will be recovered before indexes that have a lower value:

```http
PUT low_priority_index
{
    "settings": {
        "index.priority": 1
    }
}

PUT high_priority_index
{
    "settings": {
        "index.priority": 10
    }
}
```

For more information, see [Index Recovery Prioritization](https://www.elastic.co/guide/en/elasticsearch/reference/2.0/recovery-prioritization.html#recovery-prioritization).

You can monitor the recovery process for one or more indexes using the *\_recovery* API:

```http
GET /high_priority_index/_recovery?pretty=true
```

For more information, see [Indices Recovery](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-recovery.html#indices-recovery).

> [!NOTE]
> A cluster with shards that require recovery will have a status of *yellow* to indicate that not all shards are currently available. When all the shards are available, the cluster status should revert to *green*. A cluster with a status of *red* indicates that one or more shards are physically missing, it may be necessary to restore data from a backup.
> 
> 

## Preventing split brain
A split brain can occur if the connections between nodes fail. If a master node becomes unreachable to part of the cluster, an election will take place in the network segment that remains contactable and another node will become the master. In an ill-configured cluster, it is possible for each part of the cluster to have different masters resulting in data inconsistencies or corruption. This phenomenon is known as a *split brain*.

You can reduce the chances of a split brain by configuring the *minimum\_master\_nodes* property of the discovery module, in the elasticsearch.yml file. This property specifies how many nodes must be available to enable the election of a master. The following example sets the value of this property to 2:

```yaml
discovery.zen.minimum_master_nodes: 2
```

This value should be set to the lowest majority of the number of nodes that are able to fulfil the master role. For example, if your cluster has 3 master nodes, *minimum\_master\_nodes* should be set to 2. If you have 5 master nodes, *minimum\_master\_nodes* should be set to 3. Ideally, you should have an odd number of master nodes.

> [!NOTE]
> It is possible for a split brain to occur if multiple master nodes in the same cluster are started simultaneously. While this occurrence is rare, you can prevent it by starting nodes serially with a short delay (5 seconds) between each one.
> 
> 

## Handling rolling updates
If you are performing a software upgrade to nodes yourself (such as migrating to a newer release or performing a patch), you may need to perform work on individual nodes that requires taking them offline while keeping the remainder of the cluster available. In this situation, consider implementing the following process.

1. Ensure that shard reallocation is delayed sufficiently to prevent the elected master from rebalancing shards from a missing node across the remainder of the cluster. By default, shard reallocation is delayed for 1 minute, but you can increase the duration if a node is likely to be unavailable for a longer period. The following example increases the delay to 5 minutes:
   
    ```http
    PUT /_all/_settings
    {
        "settings": {
            "index.unassigned.node_left.delayed_timeout": "5m"
        }
    }
    ```
   
   > [!IMPORTANT]
   > You can also disable shard reallocation completely by setting the *cluster.routing.allocation.enable* of the cluster to *none*. However, you should avoid using this approach if new indexes are likely to be created while the node is offline as this can cause index allocation to fail resulting in a cluster with red status.
   > 
   > 
2. Stop Elasticsearch on the node to be maintained. If Elasticsearch is running as a service, you may be able to halt the process in a controlled manner by using an operating system command. The following example shows how to halt the Elasticsearch service on a single node running on Ubuntu:
   
    ```bash
    service elasticsearch stop
    ```
   
    Alternatively, you can use the Shutdown API directly on the node:
   
    ```http
    POST /_cluster/nodes/_local/_shutdown
    ```
3. Perform the necessary maintenance on the node
4. Restart the node and wait for it to join the cluster.
5. Re-enable shard allocation:
   
    ```http
    PUT /_cluster/settings
    {
        "transient": {
            "cluster.routing.allocation.enable": "all"
        }
    }
    ```

> [!NOTE]
> If you need to maintain more than one node, repeat steps 2&ndash;4 on each node before re-enabling shard allocation.
> 
> 

If you can, stop indexing new data during this process. This will help to minimize recovery time when nodes are brought back online and rejoin the cluster.

Beware of automated updates to items such as the JVM (ideally, disable automatic updates for these items), especially when running Elasticsearch under Windows. The Java update agent can download the most recent version of Java automatically, but may require Elasticsearch to be restarted for the update to take effect. This can result in uncoordinated temporary loss of nodes, depending on how the Java Update agent is configured. This can also result in different instances of Elasticsearch in the same cluster running different versions of the JVM which may cause compatibility issues.

## Testing and analyzing Elasticsearch resilience and recovery
This section describes a series of tests that were performed to evaluate the resilience and recovery of an Elasticsearch cluster containing three data nodes and three master nodes.

The following scenarios were tested:

* Node failure and restart with no data loss. A data node is stopped and restarted after 5 minutes. Elasticsearch was configured not to reallocate missing shards in this interval, so no additional I/O is incurred in moving shards around. When the node restarts, the recovery process brings the shards on that node back up to date.
* Node failure with catastrophic data loss. A data node is stopped and the data that it holds is erased to simulate catastrophic disk failure. The node is then restarted (after 5 minutes), effectively acting as a replacement for the original node. The recovery process requires rebuilding the missing data for this node, and may involve relocating shards held on other nodes.
* Node failure and restart with no data loss, but with shard reallocation. A data node is stopped and the shards that it holds are reallocated to other nodes. The node is then restarted and more reallocation occurs to rebalance the cluster.
* Rolling updates. Each node in the cluster is stopped and restarted after a short interval to simulate machines being rebooted after a software update. Only one node is stopped at any one time. Shards are not reallocated while a node is down.

Each scenario was subject to the same workload including a mixture of data ingestion tasks, aggregations, and filter queries while nodes were taken offline and recovered. The bulk insert operations in the workload each stored 1000 documents and were performed against one index while the aggregations and filter queries used a separate index containing several millions documents. This was to enable the performance of queries to be assessed separately from the bulk inserts. Each index contained five shards and one replica.

The following sections summarize the results of these tests, noting any degradation in performance while a node is offline or being recovered, and any errors that were reported. The results are presented graphically, highlighting the points at which one or more nodes are missing and estimating the time taken for the system to fully recover and achieve a similar level of performance that was present prior to the nodes being taken offline.

> [!NOTE]
> The test harnesses used to perform these tests are available online. You can adapt and use these harnesses to verify the resilience and recoverability of your own cluster configurations. For more information, see [Running the automated Elasticsearch resiliency tests][Running the automated Elasticsearch resiliency tests].
> 
> 

## Node failure and restart with no data loss: results
<!-- TODO; reformat this pdf for display inline -->

The results of this test are shown in the file [ElasticsearchRecoveryScenario1.pdf](https://github.com/mspnp/elasticsearch/blob/master/figures/Elasticsearch/ElasticSearchRecoveryScenario1.pdf). The graphs show performance profile of the workload and physical resources for each node in the cluster. The initial part of the graphs show the system running normally for approximately 20 minutes, at which point node 0 is shut down for 5 minutes before being restarted. The statistics for a further 20 minutes are illustrated; the system takes approximately 10 minutes to recover and stabilize. This is illustrated by the transaction rates and response times for the different workloads.

Note the following points:

* During the test, no errors were reported. No data was lost, and all operations completed successfully.
* The transaction rates for all three types of operation (bulk insert, aggregate query, and filter query) dropped and the average response times increased while node 0 was offline.
* During the recovery period, the transaction rates and response times for the aggregate query and filter query operations were gradually restored. The performance for bulk insert recovered for a short while before diminishing. However, this is likely due to the volume of data causing the index used by the bulk insert to grow, and the transaction rates for this operation can be seen to slow down even before node 0 is taken offline.
* The CPU utilization graph for node 0 shows reduced activity during the recovery phase, this is due to the increased disk and network activity caused by the recovery mechanism, the node has to catch up with any data it has missed while it is offline and update the shards that it contains.
* The shards for the indexes are not distributed exactly equally across all nodes. There are two indexes containing 5 shards and 1 replica each, making a total of 20 shards. Two nodes will therefore contain 6 shards while the other two hold 7 each. This is evident in the CPU utilization graphs during the initial 20-minute period, node 0 is less busy than the other two. After recovery is complete, some switching seems to occur as node 2 appears to become the more lightly loaded node.

## Node failure with catastrophic data loss: results
<!-- TODO; reformat this pdf for display inline -->

The results of this test are depicted in the file [ElasticsearchRecoveryScenario2.pdf](https://github.com/mspnp/elasticsearch/blob/master/figures/Elasticsearch/ElasticSearchRecoveryScenario2.pdf). As with the first test, the initial part of the graphs shows the system running normally for approximately 20 minutes, at which point node 0 is shut down for 5 minutes. During this interval, the Elasticsearch data on this node is removed, simulating catastrophic data loss, before being restarted. Full recovery appears to take 12-15 minutes before the levels of performance seen before the test are restored.

Note the following points:

* During the test, no errors were reported. No data was lost, and all operations completed successfully.
* The transaction rates for all three types of operation (bulk insert, aggregate query, and filter query) dropped and the average response times increased while node 0 was offline. At this point, the performance profile of the test is similar to the first scenario. This is not surprising as, to this point, the scenarios are the same.
* During the recovery period, the transaction rates and response times were restored, although during this time there was a lot more volatility in the figures. This is most probably due to the additional work that the nodes in the cluster are performing, providing the data to restore the missing shards. This additional work is evident in the CPU utilization, disk activity, and network activity graphs.
* The CPU utilization graph for nodes 0 and 1 shows reduced activity during the recovery phase, this is due to the increased disk and network activity caused by the recovery process. In the first scenario, only the node being recovered exhibited this behavior, but in this scenario it seems likely that most of the missing data for node 0 is being restored from node 1.
* The I/O activity for node 0 is actually reduced compared to the first scenario. This could be due to the I/O efficiencies of simply copying the data for an entire shard rather than the series of smaller I/O requests required to bring an existing shard up to date.
* The network activity for all three nodes indicate bursts of activity as data is transmitted and received between nodes. In scenario 1, only node 0 exhibited as much network activity, but this activity seemed to be sustained for a longer period. Again, this difference could be due to the efficiencies of transmitting the entire data for a shard as a single request rather than the series of smaller requests received when recovering a shard.

## Node failure and restart with shard reallocation: results
<!-- TODO; reformat this pdf for display inline -->

The file [ElasticsearchRecoveryScenario3.pdf](https://github.com/mspnp/elasticsearch/blob/master/figures/Elasticsearch/ElasticSearchRecoveryScenario3.pdf) illustrates the results of this test. As with the first test, the initial part of the graphs show the system running normally for approximately 20 minutes, at which point node 0 is shut down for 5 minutes. At this point, the Elasticsearch cluster attempts to recreate the missing shards and rebalance the shards across the remaining nodes. After 5 minutes node 0 is brought back online, and once again the cluster has to rebalance the shards. Performance is restored after 12-15 minutes.

Note the following points:

* During the test, no errors were reported. No data was lost, and all operations completed successfully.
* The transaction rates for all three types of operation (bulk insert, aggregate query, and filter query) dropped and the average response times increased significantly while node 0 was offline compared to the previous two tests. This is due to the increased cluster activity recreating the missing shards and rebalancing the cluster as evidenced by the raised figures for disk and network activity for nodes 1 and 2 in this period.
* During the period after node 0 is brought back online, the transaction rates and response times remain volatile.
* The CPU utilization and disk activity graphs for node 0 shows very reduced initial action during the recovery phase. This is because at this point, node 0 is not serving any data. After a period of approximately 5 minutes, the node bursts into action <RBC: This made me snort out loud. I'm not coming up with a better way to say this though.  >> as shown by the sudden increase in network, disk, and CPU activity. This is most likely caused by the cluster redistributing shards across nodes. Node 0 then shows normal activity.

## Rolling updates: results
<!-- TODO; reformat this pdf for display inline -->

The results of this test, in the file [ElasticsearchRecoveryScenario4.pdf](https://github.com/mspnp/elasticsearch/blob/master/figures/Elasticsearch/ElasticSearchRecoveryScenario4.pdf), show how each node is taken offline and then brought back up again in succession. Each node is shut down for 5 minutes before being restarted at which point the next node in sequence is stopped.

Note the following points:

* While each node is cycled, the performance in terms of throughput and response times remains reasonably even.
* Disk activity increases for each node for a short time as it is brought back online. This is most probably due to the recovery process rolling forward any changes that have occurred while the node was down.
* When a node is taken offline, spikes in network activity occur in the remaining nodes. Spikes also occur when a node is restarted.
* After the final node is recycled, the system enters a period of significant volatility. This is most likely caused by the recovery process having to synchronize changes across every node and ensure that all replicas and their corresponding shards are consistent. At one point, this effort causes successive bulk insert operations to timeout and fail. The errors reported each case were:

```
Failure -- BulkDataInsertTest17(org.apache.jmeter.protocol.java.sampler.JUnitSampler$AnnotatedTestCase): java.lang.AssertionError: failure in bulk execution:
[1]: index [systwo], type [logs], id [AVEg0JwjRKxX_sVoNrte], message [UnavailableShardsException[[systwo][2] Primary shard is not active or isn't assigned to a known node. Timeout: [1m], request: org.elasticsearch.action.bulk.BulkShardRequest@787cc3cd]]

```

Subsequent experimentation showed that introducing a delay of a few minutes between cycling each node eliminated this error, so it was most likely caused by contention between the recovery process attempting to restore several nodes simultaneously and the bulk insert operations trying to store thousands of new documents.

## Summary
The tests performed indicated that:

* Elasticsearch was highly resilient to the most common modes of failure likely to occur in a cluster.
* Elasticsearch can recover quickly if a well-designed cluster is subject to catastrophic data loss on a node. This can happen if you configure Elasticsearch to save data to ephemeral storage and the node is subsequently reprovisioned after a restart. These results show that even in this case, the risks of using ephemeral storage are most likely outweighed by the performance benefits that this class of storage provides.
* In the first three scenarios, no errors occurred in concurrent bulk insert, aggregation, and filter query workloads while a node was taken offline and recovered.
* Only the last scenario indicated potential data loss, and this loss only affected new data being added. It is good practice in applications performing data ingestion to mitigate this likelihood by retrying insert operations that have failed as the type of error reported is highly likely to be transient.
* The results of the last test also show that if you are performing planned maintenance of the nodes in a cluster, performance will benefit if you allow several minutes between cycling one node and the next. In an unplanned situation (such as the datacenter recycling nodes after performing an operating system update), you have less control over how and when nodes are taken down and restarted. The contention that arises when Elasticsearch attempts to recover the state of the cluster after sequential node outages can result in timeouts and errors.

[Manage the Availability of Virtual Machines]: /azure/articles/virtual-machines/virtual-machines-linux-manage-availability/
[Running the Automated Elasticsearch Resiliency Tests]: automated-resilience-tests.md
