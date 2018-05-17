---
title: "Governance design walkthrough: new development in Azure for multiple teams"
description: Guidance for configuring Azure governance controls to enable a user to deploy a simple workload
author: petertay
---

# Governance design walkthrough: new development in Azure for multiple teams

The audience for this governance walkthrough is the *central IT* and *security operations* personas in your organization. *Central IT* is responsible for designing and implementing your organization's cloud governance architecture. *Security operations* is responsible for the infrastructure for storing secrets in Azure as well as implementing your organization's security protocols in Azure. This guide is also useful as a reference to aid in understanding how governance is implemented for the *finance*, *shared infrastructure owner*, and *workload owner* personas.

As you learned in the [what is cloud resource governance?](governance-explainer.md) explainer, governance refers to the ongoing process of managing, monitoring, and auditing the use of Azure resources to meet the goals and requirements of your organization.

The goal of this guidance is to help you learn the process of designing your organization's governance architecture to accomodate new development in Azure for multiple teams. To facilitate this, we'll look at a set of hypothetical goverance goals and requirements and discuss how to configure Azure's governance tools to meet them. 

Our requirements are:
* Identity management for multiple teams with multiple resource access requirements in Azure. Efficiently manage and audit resource access permissions for groups of users.
* Support for a *shared infrastructure*, *development*, and *production* environment. The *development* environment is for proof-of-concept and testing work and therefore has relaxed security requirements but increased cost tracking requirements to ensure that development teams are working to resource budget constraints. The *production* environment is where workloads are published for internal and external consumption with tighter resource access requirments than the *development* environment.
* A permissions model of least privilege access, that supports the following:
    * A single trusted user that is allowed to delegate permissions assignments to *workload owners* 
    * Allow *workload owner* access to appropriate shared infrastructure resources (such as virtual networking) owned by *shared infrastructure owner*, but deny access to permanent infrastructure such as network gateways to prevent accidental changes or deletion.
* Manage the resources for multiple workloads, with each workload's resources isolated so that no one other than the team responsible for the workload has access.
* Enforce resource tag naming standards to enable cost tracking.
* Use Azure built-in roles to manage access to resources. 

## Identity management

Before we can design our identity management infrastructure to support multiple teams and multiple workloads, it's important to understand the functions that identity management provides in our governance model. These functions are:

* Administration: the processes and tools for managing user identity; we want to be able to efficiently manage user identity to ensure that users only have access to the resources we want them to access when they require that access. 
* Authentication: the process of verifying the identity of a user through the use of credentials such as a user name and password.
* Authorization: once a user has been authorized, this process determines which resources the user is allowed to access and what operations they are allowed to perform.
* Auditing: the process of periodically reviewing logs and other information to uncover any potential security issues related to user identity. This includes reviewing user connection patterns to ensure that a user's activity isn't suspicious, periodically running checks to ensure user permissions are accurate, and many other functions.

The only service trusted by Azure to provide this functionality is Azure Active Directory (AD), so our task in designing our identity management infrastructure is to configure this service to meet our requirements. 

Our first requirement is to efficiently administer identity and permissions for multiple users with multiple resource access requirements. The motivation for this requirement is to reduce the effort it takes to manage our users and their permissions. For example, we'd like to select some common criteria we can use to group users together and apply permissions to them all at once rather than one by one.

As you learned earlier, user identity can be grouped by **tenant** or by [**groups**](/azure/active-directory/active-directory-manage-groups) within the same tenant. 

Let's evaluate grouping by *tenant* first. Grouping at the *tenant* level means that a separate *tenant* is created for each group of users. This allows us to select all the users at the tenant level then apply permissions and audit their activities as a group. 

There are two problems with this approach. First, we cannot audit the activity of users across multiple tenants without exporting and aggregating activity logs from each tenant. Second, we cannot share user identity between Azure AD tenants, so if we have a user that belongs in more than one group we have to replicate and manage their identity separately in each tenant.

Now let's evaluate grouping by Azure AD *group*. Grouping user identities at the *group* level means that we store all our user identities in a single *tenant* and organize them into one or more *groups*. Just as in a *tenant*, we can apply permissions and audit activities by *group*. We can also audit the activity of all users in all groups in a single log file, and we can include users in more than one group.

Based on our analysis, the design that most closely meets our requirements is a single Azure AD *tenant* and multiple *groups*. 

**TODO: add pointer to "how to" on group creation**

## Permissions model of least privilege access

As you learned in the earlier section, resource access in Azure is managed using role-based access control (RBAC). You learned that RBAC defines a role, and the role is associated with a set of allowed or denied actions that a user can take on a particular resource. When we designed our permissions model for a simple workload, we were primarily concerned with assigning permission to create, read, update, or delete resources.

Now that we are designing our permissions model for multiple teams and multiple workloads, we have an additional consideration in that we have to control who in our organization has permission to delegate rights to others. That is, we only want users we trust to have permission to delegate rights to others, otherwise we run the risk of a proliferation of rights delegation in our organization.

Our permissions model, like most permissions models in the past, is a hierarchy. We have a single trusted user at the top who delegates access control to other trusted individuals down the structure of the hierarchy. So, our task in designing our permissions model is to identify the job function at each level of the hierarchy and what permissions are appropriate at that level.

First, recall from earlier that the a hierarchy of resource management scope in Azure starts with a *subscription* at the highest scope, followed by a *resource group*, then finally an individual *resource*. 

In Azure, each subscription has at least one service administrator. The service administrator is assigned the built-in RBAC *owner* role when the subscription is created. The *owner* role allows the user to delegate access control to other users. All delegation of access control rights begins with the service administrator and flows to all other users in the hierarchy.

The next level down in scope is the *resource group* level. There is a decision to be made at this point: who in your organization is trusted to create a resource group? While this may seem like a trivial decision, it is actually a key decision in your permissions model. 

There are two options to consider:  
1. Trust only the *service administrator* to create resource groups, or,
2. allow the *service administrator* to add one or more *workload owners* with the *owner* role at the subscription level, which enables the *workload owner* to create their own resource group.

Let's take a look an example implementation of each option to see the effect of this decision:

When the subscription is initally created, a *service administrator* is added and assigned the *owner* role. The *owner* role grants all permissions to the *service administrator*.
![subscription service administrator with owner role](../_images/governance-2-1.png) 

1. Now let's assume we have someone from one of our development teams who is working on an application. Recall that we defined a *workload* as including not only the code artifacts for the application, but all necessary cloud resources as well. Therefore, this developer will be responsible not only for building and publishing the application code, but they will also be responsible for creating and maintaining the cloud resources necessary for the application to run.  Therefore, we'll call this person *workload owner A*. Because *workload owner A* currently doesn't have permission to do anything in the subscription, they must contact the *service administrator* and request the creation of a *resource group* to contain the resources for the workload.
![workload owner requests creation of resource group A](../_images/governance-2-2.png)  

2. The *service administrator* reviews the request, and creates *resource group A*. At this point, *workload owner A* still doesn't have permission to do anything.
![service administrator creates resource group A](../_images/governance-2-3.png)

3. In order to enable *workload owner A* to manage resources, the *service administrator* adds them to *resource group A*. The *service administrator* can assign any role to *workload owner A*, and in our example the policy is to restrict the right to delegate access management. As a result, the *service administrator* assigns the *contributor* role to *workload owner A*.
![service administrator adds workload owner a to resource group a](../_images/governance-2-4.png)

4. *Workload owner A* has a requirement for a pair of team members to view the CPU and network traffic monitoring data as part of capacity planning for the workload. Because *workload owner A* does not have permission to add a user to *resource group A* directly, they must make the request to the *service administrator*.
![workload owner requests workload contributors be added to resource group](../_images/governance-2-5.png)

5. The *service adminstrator* reviews the request, and adds the two *workload contributor* users to *resource group A*. Neither of these users requires permission to manage resources, so they are assigned the *reader* role. 
![service administrator adds workload contributors to resource group A](../_images/governance-2-6.png)

6. Now let's take a look at what happens when there's another *workload owner* that is also responsible for deploying a workload to Azure. As we learned earlier, *workload owner B* does not initally have any rights at all in the subscription and must make a request for a new *resource group* to the *service administrator*. 
![workload owner B requests creation of resource group B](../_images/governance-2-7.png)

7. The *service administrator* reviews the request and creates *resource group B*.
![Service Administrator creates resource group B](../_images/governance-2-8.png)

8. The *service administrator* then adds *workload owner B* to *resource group B* and assigns the *contributor role*. 
![Service Administrator adds Workload Owner B to resource group B](../_images/governance-2-9.png)

Now let's analyze the resulting state of the *subscription*. We have two workloads, each isolated in their own resource group. None of the users added to *resource group A* has visibility into any of the resources in *resource group B* and vice-versa. This is a desirable state because each user is assigned the correct permission at the correct resource management scope.

![subscription with resource groups A and B](../_images/governance-2-10.png)

However, note that every task in this example was performed by the *service administrator*. This is a simple example and it's not an issue because there were only two workload owners, however it's easy to imagine the types of issues that would result if the organization was very large. The *service administrator* can become a bottleneck, resulting in a backlog of requests that create unacceptably long delays for development teams.

One way to fix this problem is for our organization to allow workload owners to create their own resource groups and delegate access to resources. Let's take a look at how this implementation works and the issues associated with it:

1. To enable workload owners to create their own resource groups and add users to those resource groups, they must be added to the *subscription* with the *owner* role. As in   the first example, the only person with permission to perform this action is the *service administrator*. 
![Service Administrator adds Workload Owner A to subscription](../_images/governance-2-11.png)

2. Now, *workload owner A* creates *resource group A* and is added by default. Note that *workload owner A* inherits the *owner* role from the *subscription*.
![Workload Owner A creates resource group A](../_images/governance-2-12.png)

3. The *owner* role allows *workload owner A* to delegate access. *Workload owner A* adds two *workload contributors* and assigns the *reader* role to them. 
![Workload Owner A adds Workload Contributors](../_images/governance-2-13.png)

4. Similarly, the *service administrator* can now add *workload owner B* to the *subscription* with the *owner* role. 
![Service Administrator adds Workload Owners B to subscription](../_images/governance-2-14.png)

5. *Workload owner B* creates *resource group B* and is added by default. Again, *workload owner B* inherits the *owner* role from their *subscription* level role.
![Workload Owner B creates resource group B](../_images/governance-2-15.png)

As we did earlier, let's analyze the resulting state of the *subscription*, as well as *resource group A* and *resource group B*. In the final state we have two workloads, each isolated in a resource group. The *service administrator* only had to perform two actions, so they are no longer a bottleneck even in a large organization.

![subscription with resource groups A and B](../_images/governance-2-16.png)

However, because both *workload owner A* and *workload owner B* are assigned the *owner* role at the *subscription scope*, they have also both inherited the *owner* role for each other's resource group. This means that not only do they have full access to one another's resources, they are also able to delegate access to others. For example, *workload owner B* has rights to add any other user to *resource group A* and can assign any role, including *owner*.

Therefore, only the first example is a model that implements the concept of least privilege access. There is additional management overhead associated with this model, but there are some other strategies that can be implemented to reduce the effects. We'll take a look at these in the advanced section.

## Resource management scope

The task of designing our resource management scope is to decide how we will organize and group the resources that make up our workloads. As you learned in the workload explainer, a workload can be made up of many different types of resources. Most of your workloads will share network resources with one or more central gateways to your on-premises network, and some of your workloads may share other resources such a load balancers, storage, and databases. 

Now that you've seen some examples of different access management scenarios, let's take a look at some practical applications of these governance models. Recall from our requirements that we want are required to support multiple *environments*. We define an *environment* as a logical grouping of resources that are used for a similar purpose. 

Recall from our requirements that we'll have three environments:
1. **Shared infrastructure:** a single group of resources shared by all workloads. These are resources such as network gateways, firewalls, and security services.  
2. **Development:** multiple groups of resources representing multiple non-production ready workloads. These resources are used for proof-of-concept, testing, and other developer activities. These resources may have a more relaxed goverance model because to allow for increased developer agility.
3. **Production:** multiple groups of resources representing multiple production workloads. These resources are used to host the private and public facing application artifacts. These resources typically have the tightest goverance and security models to protect the resources, application code, and data from unauthorized access.

For each of these three environments, we have a requirement to track cost data by workload, environment, or both. That is, we want to know the ongoing cost of our *shared infrastructure*, the cost of all workloads running in both *development* and *production*, and finally the overall cost of *development* and *production*. We also want to know who is responsible for the cost associated with the resource. 

You have already learned that resources are scoped to two levels: *subscription* and *resource group*. Therefore, our first decision is how to organize our environments by *subscription*. There are two options: a single subscription, or, multiple subscriptions. 

Let's evaluate a resource management model using a single *subscription*. Our first decision is how to align resource groups to the three environments. We have two options:
1. Align each environment to a single resource group. All shared infrastructure resources are deployed to a single *shared infrastructure* resource group. All resources associated development workloads are deployed to a single *development* resource group. All resources associated with production workloads are deployed into a single *production* resource group for the **production** environment. 
2. Align workloads with a separate resource group, using a naming convention and tags to align resource groups with each of the three environments.  

Let's begin by evaluting the first option. We'll be using the permissions model that we discussed in the previous section, with a single subscription service administrator that creates resource groups and adds users to them with either the built-in *contributor* or *reader* role.

> [!NOTE]
> In this hypothetical example, the subscription service administrator is responsible for creating resource groups and adding users to them. In practice, your organization may decide to have one or more trusted users with the *owner* role assigned at the *subscription* level.  

1. The first resource group deployed represents the *shared infrastructure* environment. This resource group includes a virtual network with a gateway subnet. The gateway subnet hosts a VPN gateway that connects to a VPN appliance on-premises. When the subscription service administrator creates the shared infrastructure resource group, they add the *network operations* user with the *contributor* role. The *network operations* user creates a resource group named *netops-shared-rg* and creates a virtual network with a gateway subnet. This user deploys a [VPN gateway](/azure/vpn-gateway/vpn-gateway-about-vpngateways) and configures it to connect to the on-premises VPN appliance. The *network operations* user also applies a pair of [tags](/azure/azure-resource-manager/resource-group-using-tags) to each of the resources: *environment:shared* and *managedBy:netOps*. When the *subscription service administrator* exports a cost report, costs will be aligned with each of these tags. This allows the *subscription service administrator* to pivot costs using the *environment* tag and the *managedBy* tag. Notice the *resource limits* counter at the top right-hand side of the figure. Each Azure subscription has [service limits](/azure/azure-subscription-service-limits), and to help you understand the affect of these limits we'll follow the virtual network limit for each subscription. There is a default limit of 50 virtual networks per subscription, and after the first virtual network is deployed there are now 49 available.
![](../_images/governance-3-1.png)
2. Two more resource groups are deployed, the first is named *prod-rg*. This resource group is aligned with the **production** environment. The second is named *dev-rg* and is aligned with the **development** environment. All resources associated with production workloads are deployed to the **production** environment and all resources associated with development workloads are deployed to the **development** environment. In this example we'll only deploy two workloads to each of these two environments so we won't encounter any Azure subscription service limits. However, it's important to consider that each resource group has a limit of 800 resources per resource group. Therefore, if we keep adding workloads to each resource group it is possible that this limit can be reached. 
![](../_images/governance-3-2.png)
3. The first *workload owner* sends a request to the *subscription service administrator* and is added to each of the **development** and **production** environment resource groups with the *contributor* role. As you learned earlier, the *contributor* role allows the user to perform any operation other than assigning a role to another user. The first *workload owner* can now create the resources associated with their workload.
![](../_images/governance-3-3.png)
4. The first *workload owner* creates a virtual network in each of the two resource groups with a pair of virtual machines in each. The first *workload owner* applies the *environment* and *managedBy* tags to all resources. Note that the Azure service limit counter is now at 47 virtual networks remaining.
![](../_images/governance-3-4.png)
5. Each of the virtual networks does not have connectivity to on-premises when they are created. In this type of architecture, each virtual network must be peered to the *hub-vnet* in the **shared infrastructure** environment. Virtual network peering creates a connection between two separate virtual networks and allows network traffic to travel between them. Note that virtual network peering is not inherently transitive. A peering must be specified in each of the two virtual networks that are connected, and if only one of the virtual networks specifies a peering the connection is incomplete. To illustrate the effect of this, the first *workload owner* specifies a peering between *prod-vnet* and *hub-vnet*. The first peering is created, but no traffic flows because the complementary peering from *hub-vnet* to *prod-vnet* has not yet been specified. The first *workload owner* contacts the *network operations* user and requests this complementary peering connection.
![](../_images/governance-3-5.png)
6. The *network operations* user reviews the request, approves it, then specifies the peering in teh settings for the *hub-vnet*. The peering connection is now complete and network traffic flows between the two virtual networks.
![](../_images/governance-3-6.png)
7. Now, a second *workload owner* sends a request to the *subscription service administrator* and is added to the existing **production** and **development** environment resource groups with the *contributor* role. The second *workload owner* has the same permissions on all resources as the first *workload owner* in each resource group. 
![](../_images/governance-3-7.png)
8. The second *workload owner* creates a subnet in the *prod-vnet* virtual network, then adds two virtual machines. The second *workload owner* applies the *environment* and *managedBy* tags to each resource.
![](../_images/governance-3-8.png) 

Now that our model is complete, let's analyze the final state to see how it aligns with our requirements.

Our model enables us to manage our resources in the three required environments. Our shared infrastructure resources are protected because there's only a single user in the subscrition with permission to access those resources. 


Now let's evaluate a resource management model using multiple subscriptions. In this model, we'll align each of the our three environments to a separate subscription: a **shared services** subscription, **production** subscription, and finally a **development** subscription. The considerations for this model are similar to a model using a single subscription in that we have to decide how to align resource groups to workloads. 

As you learned earlier, if we want to isolate workloads on a permissions basis we must assign the *owner* role to a trusted user at the *subscription* level. The *subscription* owner is responsible for creating resource groups and adding workload owners with the *contributor* role. When we had a single subscription, there was only one subscription owner. Now that we have three subscriptions, we have three subscription owners. These three subscription owners can be the same user or up to three different users.

As you can see from the diagram, workload owners may have resources in both the **production** and **development** subscriptions at the same time. These users do not require management access to the resources in the **shared infrastructure** environment. Because workload owners have to contact the subscription owner to create a resource group, it may be more efficient for the **production** and **development** subscription owner to be the same user or users on the same team. 

## Next steps

