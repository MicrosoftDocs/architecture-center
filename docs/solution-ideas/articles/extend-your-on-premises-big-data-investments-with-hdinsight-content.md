[!INCLUDE [header_file](../../../includes/sol-idea-header.md)]

Extend your on-premises big data investments to the cloud and transform your business using the advanced analytics capabilities of HDInsight.

## Architecture

![Architecture Diagram](../media/extend-your-on-premises-big-data-investments-with-hdinsight.png)
*Download an [SVG](../media/extend-your-on-premises-big-data-investments-with-hdinsight.svg) of this architecture.*

### Components

- [Apache Hadoop](http://hadoop.apache.org/) or [Apache Spark](http://spark.apache.org/)
- Metadata store
- Local edge router
- [Azure ExpressRoute](https://azure.microsoft.com/services/expressroute/) circuit
- Microsoft edge router
- Data replication (WANdisco's [LiveData Migrator for Azure](https://azuremarketplace.microsoft.com/marketplace/apps/wandisco.ldm) and [LiveData Plane for Azure](https://azuremarketplace.microsoft.com/marketplace/apps/wandisco.ldp))
- [Azure HDInsight](https://azure.microsoft.com/services/hdinsight/)
- [Azure Virtual Network](https://azure.microsoft.com/services/virtual-network/)

## Next steps

Learn more about the component technologies:

- [What is Azure ExpressRoute?](/azure/expressroute/expressroute-introduction)
- [Migrate your Hadoop data lakes with WANDisco LiveData Platform for Azure](https://azure.microsoft.com/blog/migrate-your-hadoop-data-lakes-with-wandisco-livedata-platform-for-azure/)
- [What is Azure HDInsight?](/azure/hdinsight/hdinsight-overview)
- [What is Azure Virtual Network?](/azure/virtual-network/virtual-networks-overview)

## Related resources

Explore related architectures:

- [Connect an on-premises network to Azure using ExpressRoute](../../reference-architectures/hybrid-networking/expressroute-vpn-failover.yml)
- [Extend an on-premises network using ExpressRoute](../../reference-architectures/hybrid-networking/expressroute.yml)
- [Interactive querying with HDInsight](./interactive-querying-with-hdinsight.yml)
