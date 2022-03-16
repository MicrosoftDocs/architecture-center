Spaceborne data collection is growing at an exponential rate. New use cases are discovered every day; and with the application of artificial intelligence stored archives of data are a necessity for machine learning. The need to build a cloud-based end-to-end solution for geospatial analysis has become more important than ever for enterprise and government customers to drive better-informed, business and tactical decisions. This reference architecture is designed to show an end-to-end implementation that involves extracting, loading, transforming and analyzing spaceborne data using geospatial libraries and AI models with [Azure Synapse Analytics](https://docs.microsoft.com/en-us/azure/synapse-analytics/overview-what-is). This reference architecture also shows how to integrate geospatial specific [Azure Cognitive services](https://docs.microsoft.com/azure/cognitive-services/) models, AI models from partners, Bring Your Own Data (BYOD) and AI models using Azure Synapse Analytics.

This reference architecture demonstrates how Azure Synapse Analytics can be used for geospatial analysis and for running AI models against the spaceborne data. The intended audience for this document are users with intermediate skill levels in the Geospatial space.

A reference implementation of this architecture is available on [GitHub](https://github.com/Azure/Azure-Orbital-Analytics-Samples).

## Potential use cases

- Raster data ingestion and processing
- Object detection using pre trained AI models
- Classification of land masses using AI models
- Monitor changes in the environment using AI models
- Derived datasets from preprocessed imagery sets
- Vector visualization/small area consumption
- Vector data filtering and cross-data joins

## Architecture

_Download a [Visio file](images/geospatial-processing-analytics-arch.vsdx) of this architecture._

![](images/geospatial-processing-analytics-arch.png)

### Data pipeline

The below workflow will walk-through the different stages of the end-to-end architecture:

#### Spaceborne data ingestion

  - Spaceborne data is pulled from various data sources like [Airbus](https://oneatlas.airbus.com/home), [NAIP / USDA (via Planetary Computer API)](https://planetarycomputer.microsoft.com/dataset/naip), [Maxar](https://www.maxar.com/), [Capella](https://www.capellaspace.com/), [HEAD Aerospace](https://www.head-aerospace.eu/satellite-imagery), etc and ingested into [Azure Data Lake Storage](https://docs.microsoft.com/azure/storage/blobs/data-lake-storage-introduction). 
  - Azure Synapse Analytics provides various pipelines & activities like Web Activity, Data flow Activity and Custom Activity to connect to these sources and copy the data into Azure Data Lake Storage.
  
#### Spaceborne data tranformation

 - The spaceborne data is then processed and transformed into a format that can be consumed by the Analysts and the AI Models. There are various geospatial libraries available to perform the transformation like GDAL, OGR, Rasterio, GeoPandas, etc.
 - Azure Synapse Analytics Spark Pools provide the ability to configure and use these libraries to perform such data transformations. In addition to Spark Pools, Azure Synapse Analytics also provides a *Custom Activity* that leverages Azure Batch Pools which can be used. In our [sample code](#sample-code), data transformations are performed using the **GDAL** library in a Spark Pool. Please refer the sample code section for more details
 - Sample solution implements this pipeline from this step of data transformation and expects data to be copied in Azure Data Lake Storage by above data ingestion methods. It demonstrates end to end implementation of this pipeline for raster data processing.

#### Analysis and Execution of AI Models
 - Azure Synapse Analytics provides a notebook environment for analysis and the execution of AI models 
 - AI models developed using services like Azure Cognitive Services custom vision model, trained in their own environment and packaged as Docker containers are available to be consumed in the Azure Synapse Analytics environment.
 - AI models available from partners for various capabilities like object detection, change detection, land classification, trained in their own environment and packaged as Docker containers can also be consumed and executed in an Azure Synapse Analytics environment.
 - Azure Synapse Analytics is capable of executing such AI models through its *custom activity* that runs code in Azure Batch Pools as executables or as Docker containers. The sample solution demonstrates how to execute a [Custom Vision AI model](https://azure.microsoft.com/services/cognitive-services/custom-vision-service/#overview) as part of an Azure Synapse Analytics pipeline for object detection over a specific geospatial area of interest.

#### Post-analysis and Visualization
 - Output from analysis and execution of the AI models can then be stored in either Azure Data Lake Storage or data-aware databases like Azure Database for Postgres, or Azure CosmosDB for further analysis and visualization. The sample solution showcases how to transform AI model output and store it as [GeoJSON](https://tools.ietf.org/html/rfc7946) data in Azure Data Lake Storage and Azure Database for PostgresSQL, from where it can be subsequently retrieved and queried.
 - Licensed tools like ArcGIS Desktop or open source tools like QGIS are available to be used for visualizing the data.
 - Power BI provides the visualization capabilities to access GeoJSON from various data sources to visualize the GIS data.
 - Client side geospatial javascript based libraries are available to visualize this data in web applications.

### Components

The architecture consist of the following components & categories

#### Data sources
- Imagery providers
	- [Airbus](https://oneatlas.airbus.com/home)
	- [NAIP / USDA (via Planetary Computer API)](https://planetarycomputer.microsoft.com/dataset/naip)
	- [Maxar](https://www.maxar.com/)
	- [Capella](https://www.capellaspace.com/)
	- [HEAD Aerospace](https://www.head-aerospace.eu/satellite-imagery)
- BYOD (Bring your own data) Users bring their own data and copy it to Azure Data Lake Storage

#### Data ingestion
- [Azure Synapse Analytics](https://docs.microsoft.com/azure/synapse-analytics/overview-what-is) is a limitless analytics service that brings together data integration, enterprise data warehousing, and big data analytics. Azure Synapse contains the same Data Integration engine and experiences as Azure Data Factory, allowing you to create rich at-scale ETL pipelines without leaving Azure Synapse Analytics.
  	- Ingest data from 90+ data sources
   - Code-Free ETL with Data flow activities
   - Orchestrate notebooks, Spark jobs, stored procedures, SQL scripts, and more
   - Data movement, transformation and custom pipeline activities
- [Azure Data Lake Storage Gen2](https://docs.microsoft.com/azure/storage/blobs/data-lake-storage-introduction) is a set of capabilities dedicated to big data analytics, built on [Azure Blob Storage](https://docs.microsoft.com/azure/storage/blobs/storage-blobs-introduction)
- [Azure Batch](https://docs.microsoft.com/azure/batch/batch-technical-overview) lets you run and scale large number of batch computing jobs on Azure. Batch tasks can run directly on virtual machines (nodes) in a Batch pool, but you can also set up a Batch pool to run tasks in [Docker-compatible containers](https://docs.microsoft.com/azure/batch/batch-docker-container-workloads) on the nodes.
  - Azure Synapse custom activity runs your customized code logic on an Azure Batch pool of virtual machines or docker containers.
- [Azure Key Vault](https://docs.microsoft.com/azure/key-vault/) stores and controls access to secrets such as tokens, passwords, and API keys. Key Vault also creates and controls encryption keys and manages security certificates.


#### Data transformation
The below geospatial libraries/packages are applied in combination to transformations. These libraries/packages are installed to a serverless Spark pool which will then be attached to a Synapse Notebook. Instructions on how to install the libraries is documented [here](#install-geospatial-packages-into-synapse-spark-pool). 

- Geospatial libraries
	- [GDAL](https://gdal.org/) is a library of tools used for manipulating spaceborne data. GDAL works on both raster and vector data types, and is an incredible useful tool to be familiar with when working with spaceborne data.
	- [Rasterio](https://rasterio.readthedocs.io/en/latest/intro.html) is a highly useful module for raster processing which you can use for reading and writing several different raster formats in Python. Rasterio is based on GDAL and Python automatically registers all known GDAL drivers for reading supported formats when importing the module
	- [Geopandas](https://geopandas.org/en/stable/) is an open source project to make working with spaceborne data in python easier. GeoPandas extends the datatypes used by pandas to allow spatial operations on geometric types.
	- [Shapely](https://shapely.readthedocs.io/en/stable/manual.html#introduction) is a Python package for set-theoretic analysis and manipulation of planar features using (via Python's ctypes module) functions from the well known and widely deployed GEOS library.
	- [pyproj](https://pyproj4.github.io/pyproj/stable/examples.html) Performs cartographic transformations. Converts from longitude, latitude to native map projection x,y coordinates and vice versa using [PROJ](https://proj.org).

- [Azure Batch](https://docs.microsoft.com/azure/batch/batch-technical-overview) to run large-scale parallel and high-performance computing (HPC) batch jobs efficiently in Azure. 
  - Azure Synapse custom activity runs your customized code logic on an Azure Batch pool of virtual machines or docker containers.
- [Azure Synapse Analytics notebooks](https://docs.microsoft.com/azure/synapse-analytics/spark/apache-spark-notebook-concept) is a web interface for you to create files that contain live code, visualizations, and narrative text. Notebooks are a good place to validate ideas and use quick experiments to get insights from your data. 
  - Existing Synapse notebooks can be added to Synapse pipeline using the Notebook activity.

- [Apache Spark pool](https://docs.microsoft.com/azure/synapse-analytics/spark/apache-spark-overview#spark-pool-architecture) Existing Spark jobs can be added to the Synapse pipeline using Spark job definition activity.

#### Analysis and AI Modeling

- [Azure Synapse Analytics](https://docs.microsoft.com/azure/synapse-analytics/machine-learning/what-is-machine-learning) for Machine Learning capabilities
- [Azure Batch](https://docs.microsoft.com/azure/batch/batch-technical-overview) to run large-scale parallel and high-performance computing (HPC) batch jobs efficiently in Azure. 
  - Azure Synapse custom activity runs your customized code logic on an Azure Batch pool of virtual machines or docker containers.

- [Azure Cognitive services](https://docs.microsoft.com/azure/cognitive-services/what-are-cognitive-services)
	- [Custom vision](https://docs.microsoft.com/azure/cognitive-services/custom-vision-service/overview)

- Microsoft Partner AI models like [blackshark.ai](https://blackshark.ai/)
- Bring Your Own AI Models(BYOM)


#### Post-analysis and Visualization

- [Azure Database for PostgreSQL](https://docs.microsoft.com/azure/postgresql/) A fully-managed relational database service designed for hyperscale workloads with support for spaceborne data through [PostGIS](https://www.postgis.net/) extension.
- [Azure Cosmos DB](https://docs.microsoft.com/azure/cosmos-db/introduction) supports indexing and querying of geospatial point data that's represented using the [GeoJSON specification](https://tools.ietf.org/html/rfc7946).
- [Power BI](https://docs.microsoft.com/power-bi/fundamentals/power-bi-overview) An interactive data visualization tool to build reports and dashboards through visuals to provide insights to data including spaceborne data through Esri [ArcGIS Maps](https://powerbi.microsoft.com/power-bi-esri-arcgis/)
- [QGIS](https://www.qgis.org/) A free and open source GIS to create, edit, visualise, analyse and publish geospatial information.
- [ArcGIS Desktop](https://www.esri.com/arcgis/products/arcgis-desktop/overview) is a licensed software provided by Esri to create, analyze, manage and share geographic information.


#### Sample code

The following article shows how to read/write and apply transformations to raster data that is stored in Azure Data Lake Storage using Synapse Notebook. The intention is more to showcase the usage of libraries in Synapse notebooks rather than the actual transformation itself. 

**Note:** Before running the sample code, ensure the required libraries are installed. Instructions on how to install the libraries is documented [here](#install-geospatial-packages-into-synapse-spark-pool)

- Print information from the raster data 
 
  ```
  from osgeo import gdal  
  gdal.UseExceptions()  
  gdal.SetConfigOption('AZURE_STORAGE_ACCOUNT', '<storage_account_name>')
  gdal.SetConfigOption('AZURE_STORAGE_ACCESS_KEY', '<access_key>')  
  dataset_info = gdal.Info('/vsiadls/aoa/input/sample_image.tiff')  #/vsiadls/<container_name>/path/to/image
  print(dataset_info)
  ```
  
  Output:
  
  <pre style="max-height: 500px;">
  Driver: GTiff/GeoTIFF
	Files: /vsiadls/naip/input/sample_image.tiff
	Size is 6634, 7565
	Coordinate System is:
	PROJCRS["NAD83 / UTM zone 16N",
	    BASEGEOGCRS["NAD83",
	        DATUM["North American Datum 1983",
	            ELLIPSOID["GRS 1980",6378137,298.257222101,
	                LENGTHUNIT["metre",1]]],
	        PRIMEM["Greenwich",0,
	            ANGLEUNIT["degree",0.0174532925199433]],
	        ID["EPSG",4269]],
	    CONVERSION["UTM zone 16N",
	        METHOD["Transverse Mercator",
	            ID["EPSG",9807]],
	        PARAMETER["Latitude of natural origin",0,
	            ANGLEUNIT["degree",0.0174532925199433],
	            ID["EPSG",8801]],
	        PARAMETER["Longitude of natural origin",-87,
	            ANGLEUNIT["degree",0.0174532925199433],
	            ID["EPSG",8802]],
	        PARAMETER["Scale factor at natural origin",0.9996,
	            SCALEUNIT["unity",1],
	            ID["EPSG",8805]],
	        PARAMETER["False easting",500000,
	            LENGTHUNIT["metre",1],
	            ID["EPSG",8806]],
	        PARAMETER["False northing",0,
	            LENGTHUNIT["metre",1],
	            ID["EPSG",8807]]],
	    CS[Cartesian,2],
	        AXIS["(E)",east,
	            ORDER[1],
	            LENGTHUNIT["metre",1]],
	        AXIS["(N)",north,
	            ORDER[2],
	            LENGTHUNIT["metre",1]],
	    USAGE[
	        SCOPE["Engineering survey, topographic mapping."],
	        AREA["North America - between 90°W and 84°W - onshore and offshore. Canada - Manitoba; Nunavut; Ontario. United States (USA) - Alabama; Arkansas; Florida; Georgia; Indiana; Illinois; Kentucky; Louisiana; Michigan; Minnesota; Mississippi; Missouri; North Carolina; Ohio; Tennessee; Wisconsin."],
	        BBOX[23.97,-90,84,-84]],
	    ID["EPSG",26916]]
	Data axis to CRS axis mapping: 1,2
	Origin = (427820.000000000000000,3395510.000000000000000)
	Pixel Size = (1.000000000000000,-1.000000000000000)
	Metadata:
	  AREA_OR_POINT=Area
	Image Structure Metadata:
	  COMPRESSION=DEFLATE
	  INTERLEAVE=PIXEL
	  LAYOUT=COG
	  PREDICTOR=2
	Corner Coordinates:
	Upper Left  (  427820.000, 3395510.000) ( 87d45'13.12"W, 30d41'24.67"N)
	Lower Left  (  427820.000, 3387945.000) ( 87d45'11.21"W, 30d37'18.94"N)
	Upper Right (  434454.000, 3395510.000) ( 87d41' 3.77"W, 30d41'26.05"N)
	Lower Right (  434454.000, 3387945.000) ( 87d41' 2.04"W, 30d37'20.32"N)
	Center      (  431137.000, 3391727.500) ( 87d43' 7.54"W, 30d39'22.51"N)
	Band 1 Block=512x512 Type=Byte, ColorInterp=Red
	  Overviews: 3317x3782, 1658x1891, 829x945, 414x472
	Band 2 Block=512x512 Type=Byte, ColorInterp=Green
	  Overviews: 3317x3782, 1658x1891, 829x945, 414x472
	Band 3 Block=512x512 Type=Byte, ColorInterp=Blue
	  Overviews: 3317x3782, 1658x1891, 829x945, 414x472
	Band 4 Block=512x512 Type=Byte, ColorInterp=Undefined
	  Overviews: 3317x3782, 1658x1891, 829x945, 414x472
	</pre>
	
  
	> - **/vsiadls/** is a filesystem handler that allows on-the-fly random reading of (primarily non-public) files available in Microsoft Azure Data Lake Storage file systems, without prior download of the entire file. It has similar capabilities as **/vsiaz/**, and in particular uses the same configuration options for authentication. Its advantages over /vsiaz/ are a real management of directory and Unix-style ACL support. Some features require the Azure storage to have hierarchical support turned on. Please refer to its [documentation](https://gdal.org/user/virtual_file_systems.html#vsiadls-microsoft-azure-data-lake-storage-gen2) for more details.
	


- Convert GeoTiff to PNG using GDAL

	```
	from osgeo import gdal
	gdal.UseExceptions()	
	gdal.SetConfigOption('AZURE_STORAGE_ACCOUNT', '<storage_account_name>')
   gdal.SetConfigOption('AZURE_STORAGE_ACCESS_KEY', '<access_key>') 
	tiff_in = "/vsiadls/aoa/input/sample_image.tiff"	#/vsiadls/<container_name>/path/to/image
	png_out = "/vsiadls/aoa/input/sample_image.png"	#/vsiadls/<container_name>/path/to/image
	options = gdal.TranslateOptions(format='PNG')
	gdal.Translate(png_out, tiff_in, options=options)
	```
	
- Approach for Storing GeoTiff images to Azure Data Lake Storage. 
	
	> Due to the nature of how data is stored in cloud and the fact the file handlers `/vsiaz/` or `/vsiadls/` support only sequential writes, we leverage the file mount feature available in [mssparkutils package](https://docs.microsoft.com/azure/synapse-analytics/spark/synapse-file-mount-api). Once the output is written to a mount location,  copy it to ADLS Gen2 as shown in the below sample transformation.
	
	```
	import shutil
	import sys
	from osgeo import gdal
	from notebookutils import mssparkutils 

	mssparkutils.fs.mount( 
    	"abfss://<container_name>@<storage_account_name>.dfs.core.windows.net", 
    	"/<mount_path>", 
    	{"linkedService":"<linked_service_name>"} 
	)
	
   gdal.SetConfigOption('AZURE_STORAGE_ACCOUNT', '<storage_account_name>')
   gdal.SetConfigOption('AZURE_STORAGE_ACCESS_KEY', '<access_key>') 

   options = gdal.WarpOptions(options=['tr'], xRes=1000, yRes=1000)
   gdal.Warp('dst_img.tiff', '/vsiadls/<container_name>/path/to/src_img.tiff', options=options)

   jobId = mssparkutils.env.getJobId()
	
   shutil.copy("dst_img.tiff", f"/synfs/{jobId}/<mount_path>/path/to/dst_img.tiff")
	```	
   > 	Azure Synapse Analytics allows you to add Azure Data Lake Storage Gen2 as one of the linked services. This can be done using the UI as documented [here](https://docs.microsoft.com/azure/data-factory/concepts-linked-services?context=%2Fazure%2Fsynapse-analytics%2Fcontext%2Fcontext&tabs=synapse-analytics#linked-service-with-ui)
	

#### Sample solution:

A reference implementation of this architecture is available on [GitHub](https://github.com/Azure/Azure-Orbital-Analytics-Samples) as a sample solution.

The sequence diagram below shows the steps of the sample solution.
_Download a [Visio file](images/geospatial-processing-analytics-sequence-diagram.vsdx) of this deployment architecture._

![](images/geospatial-processing-analytics-sequence-diagram.png)


1. Azure Synapse pipeline reads the spaceborne data from Azure Data Lake Storage
	- This spaceborne data data is pulled from spaceborne data sources and copied to Azure Data Lake Storage, this data ingestion is not part of reference implementation.
2. The data is processed using GDAL library using Azure Synapse Notebooks
3. The processed data is stored in Azure Data Lake Storage
4. This processed data is read from Azure Data Lake Storage and passed to the object detection custom vision AI models using Azure Synapse custom activity
	- This custom activity uses Azure Batch pools to run the object detection model
5. The object detection model outputs a list of detected objects and bounding boxes
6. The detected objects are stored in Azure Data Lake Storage
	- The objects are converted to GeoJSON format and stored in Azure Data Lake Storage
7. This GeoJSON data is read from Azure Data Lake Storage and stored to PostGresSQL database
8. This data is read from PostGresSQL database and can be visualized further in tools like ArcGIS Pro, QGIS, and PowerBI


### Alternatives

- [Azure Kubernetes Service](https://docs.microsoft.com/azure/aks/), [Azure Container Instances](https://docs.microsoft.com/azure/container-instances/), [Azure Container Apps](https://azure.microsoft.com/services/container-apps/) provide alternatives to run containerized AI models which can be called from Azure Synapse Analytics.

- [Azure Databricks](https://docs.microsoft.com/azure/databricks/) provides a viable alternative option to host an end-to-end analytics pipeline.

Some other alternative geospatial libraries / frameworks that can be used for geospatial processing are:
- [Apache Sedona](https://sedona.apache.org/) was formerly called GeoSpark, is a cluster computing system for processing large-scale spatial data. Sedona extends Apache Spark / SparkSQL with a set of out-of-the-box Spatial Resilient Distributed Datasets / SpatialSQL that efficiently load, process, and analyze large-scale spatial data across machines.

- [Dask for Python](https://tutorial.dask.org/00_overview.html) is a parallel computing library that scales the existing Python ecosystem.

- [Azure HDInsight Spark](https://docs.microsoft.com/azure/hdinsight/spark/apache-spark-overview)


### Operational excellence

[Azure Devops and Azure Synapse Analytics](https://docs.microsoft.com/azure/synapse-analytics/cicd/source-control#:~:text=Already%20connected%20to%20GitHub%20using%20a%20personal%20account,Synapse%20and%20grant%20the%20access%20to%20your%20organization.)
### Performance

[Speed up your data workloads with performance updates to Apache Spark 3.1.2 in Azure Synapse](https://techcommunity.microsoft.com/t5/azure-synapse-analytics-blog/speed-up-your-data-workloads-with-performance-updates-to-apache/ba-p/2769467#:~:text=In%20the%20new%20release%20of%20Spark%20on%20Azure,your%20data%2C%20faster%20and%20at%20a%20lower%20cost.)

[Spark pools in Azure Synapse Analytics](https://docs.microsoft.com/azure/synapse-analytics/spark/apache-spark-pool-configurations)
### Reliability

[Azure Synapse SLA](https://www.azure.com/support/sla/synapse-analytics/index.html)

### Security

[Azure Synapse Analytics security](https://docs.microsoft.com/azure/synapse-analytics/guidance/security-white-paper-introduction)

[Azure Synapse Analytics security white paper: Data protection](https://docs.microsoft.com/azure/synapse-analytics/guidance/security-white-paper-data-protection)

[Azure Synapse Analytics security white paper: Access control](https://docs.microsoft.com/azure/synapse-analytics/guidance/security-white-paper-access-control)

[Azure Synapse Analytics security white paper: Authentication](https://docs.microsoft.com/azure/synapse-analytics/guidance/security-white-paper-authentication)

[Azure Synapse Analytics Network security](https://docs.microsoft.com/azure/synapse-analytics/guidance/security-white-paper-network-security)


## Deploy this scenario

A deployment of the sample solution is available using [Bicep](https://docs.microsoft.com/azure/azure-resource-manager/bicep/overview?tabs=bicep) files. Instructions on how to get started with this deployment can be accessed [here](https://github.com/Azure/Azure-Orbital-Analytics-Samples).

_Download a [Visio file](images/geospatial-processing-analytics-deploy.vsdx) of this deployment architecture._

![](images/geospatial-processing-analytics-deploy.png)



- [Azure Orbital Analytics Samples](https://github.com/Azure/Azure-Orbital-Analytics-Samples)

## Limitations

This reference architecture showcases functional working of an end-to-end geoprocessing and analytics using Azure Synapse Analytics. This sample implementation is targeted for small to medium area of interest and limited concurrent geoprocessing of raster data.


## Pricing

[Azure Synapse - use Azure Pricing calculator](https://azure.microsoft.com/pricing/calculator/?service=synapse-analytics)

[Azure Batch - use Azure Pricing calculator](https://azure.microsoft.com/pricing/calculator/?service=batch)

## Related resources
 
  - [Geospatial data processing and analytics](https://docs.microsoft.com/azure/architecture/example-scenario/data/geospatial-data-processing-analytics-azure)
- [Azure Maps Geospatial Services](https://microsoft.github.io/SynapseML/docs/features/geospatial_services/GeospatialServices%20-%20Overview/)
- [Getting geospatial insides in big data using SynapseML](https://techcommunity.microsoft.com/t5/azure-maps-blog/getting-geospatial-insides-in-big-data-using-synapseml/ba-p/3154717)
  

## Appendix A

# Install Geospatial packages into Synapse Spark pool

In this tutorial, we will show how to install packages into Synapse Spark pool using the package management feature. For more information, visit [Synapse Package Management](https://docs.microsoft.com/en-us/azure/synapse-analytics/spark/apache-spark-azure-portal-add-libraries).

To support Geospatial workloads on Azure Synapse, it requires libraries like [GDAL](https://gdal.org/), [Rasterio](https://rasterio.readthedocs.io/en/latest/intro.html), [Geopandas](https://geopandas.org/en/stable/), just to name a few. These libraries are installed on a given serverless Apache Spark pool using a yaml file. The Spark pool comes with [Anaconda](https://docs.continuum.io/anaconda/) libraries pre-installed.


### Pre-requisites

- [Create a Synapse workspace](https://docs.microsoft.com/en-us/azure/synapse-analytics/get-started-create-workspace)

- [Create the Apache Spark pool in Synapse Studio](https://docs.microsoft.com/en-us/azure/synapse-analytics/quickstart-create-apache-spark-pool-studio#create-the-apache-spark-pool-in-synapse-studio)

### Steps

1. The following libraries/packages are available in the [environment.yml](/transforms/spark-jobs/environment.yml) file. This file will be used to install the libraries to the Spark pools.

	```
	name: geospatial-pkgs
	channels:
  	  - conda-forge
  	  - defaults
	dependencies:
  	  - azure-storage-file-datalake
	  - gdal=3.3.0
	  - libgdal
	  - pip>=20.1.1		
	  - pyproj
  	  - shapely
  	  - pip:
        - rasterio
        - geopandas
	```
**Note:** GDAL uses virtual file system [/vsiadls/](https://gdal.org/user/virtual_file_systems.html#vsiadls-microsoft-azure-data-lake-storage-gen2) for Azure Data Lake Storage Gen2. This support is available from [GDAL v3.3.0](https://github.com/OSGeo/gdal/blob/eeeffe624996518655f231125712582551222932/gdal/NEWS#L9). When using GDAL please ensure the version is >= 3.3.0.

2. Go to [https://web.azuresynapse.net](https://web.azuresynapse.net) and sign in to your workspace. 

	![](https://docs.microsoft.com/en-us/azure/synapse-analytics/security/media/common/login-workspace.png)

3. Select **Manage** from the main navigation panel and then select **Apache Spark pools**
4. Select **Packages** by clicking `...` on the specific Spark pool, upload the `environment.yml` file from local and apply the package settings.


	![](https://docs.microsoft.com/en-us/azure/synapse-analytics/spark/media/apache-spark-azure-portal-add-libraries/studio-update-libraries.png)

5. The notification section of the portal notifies you once the installation has been completed. You can also track the installation progress by following the below steps:
	1. Navigate to the Spark applications list in the **Monitor** tab.
	2. Select **SystemReservedJob-LibraryManagement** that corresponds to your pool update.
	
		![](https://docs.microsoft.com/en-us/azure/synapse-analytics/spark/media/apache-spark-azure-portal-add-libraries/system-reserved-library-job.png) 
	
	3. View the driver logs 

6. Finally, run the following code to verify the installed libraries and the respective version. This will also display all the pre-installed libraries that Conda installs.

	```
	import pkg_resources
	for d in pkg_resources.working_set:
     	print(d)
    ```

In this tutorial, we have seen how to install libraries using the package management feature available in Azure Synapse. For more information, please visit [Manage packages](https://docs.microsoft.com/en-us/azure/synapse-analytics/spark/apache-spark-manage-python-packages) on Azure Synapse.
