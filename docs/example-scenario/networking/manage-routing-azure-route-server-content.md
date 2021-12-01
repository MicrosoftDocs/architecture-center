Network routing is the process of determining the path that traffic takes across networks to reach a destination. Routing tables list network topology information that's useful for determining routing paths.

Azure automatically creates a routing table for each subnet within an Azure virtual network. Azure then adds default system routes to each routing table. You can't create or remove system routes. But you have some options for adjusting these routes:

- You can override some system routes with [custom routes][Virtual network traffic routing - Custom routes].
- By using certain features, you can configure Azure to add [optional default routes][Virtual network traffic routing - Optional default routes] to specific subnets.

This article presents a solution for simplifying the dynamic routing between network virtual appliances (NVAs) and virtual networks. At the core of the solution is Azure Route Server. This service/product does something useful like reduces maintenance or automates something or makes it easier to manage routes.

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


[Virtual network traffic routing - Custom routes]: https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-udr-overview#custom-routes
[Virtual network traffic routing - Optional default routes]: https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-udr-overview#optional-default-routes