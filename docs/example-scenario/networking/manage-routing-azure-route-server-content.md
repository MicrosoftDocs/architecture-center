This article presents a solution for simplifying the dynamic routing between network virtual appliances (NVAs) and virtual networks. Network routing determines the path that traffic takes across networks to reach a destination. Azure automatically creates a route table for each subnet within an Azure virtual network. Azure then adds default system routes to those route tables. You can't create or remove system routes. But you can override some system routes with custom routes. By using certain features, you can configure Azure to add optional default routes to specific subnets.

Examples of intro sentences from other articles:
This article presents a solution for managing the compliance of VMs that run on Azure
This article outlines a solution that meets Moodle's needs. At the core of the solution is Azure NetApp Files, a first-party Azure file storage service. 

## Potential use cases



## Architecture

:::image type="content" source="./media/moodle-azure-netapp-files-single-region-architecture.png" alt-text="Architecture diagram showing how students access Moodle. Other components include Azure NetApp Files, Azure Cache for Redis, and Azure Database for MySQL." border="false":::

*Download a [PowerPoint file][PowerPoint version of architecture diagram] of this architecture.*

1. 

### Components



### Alternatives



## Considerations

Keep the following points in mind when you implement this solution.

### Scalability

This solution scales up or down as needed:


### Availability

For the Azure NetApp Files availability guarantee, see [SLA for Azure NetApp Files][SLA for Azure NetApp Files].

### Security


### Resiliency

## Deploy the solution

## Pricing



## Next steps



## Related resources


