---
title: Deploy a JMeter JUnit sampler to test Elasticsearch performance
description: >-
  How to use a JUnit sampler to generate and upload data to an Elasticsearch
  cluster.
author: dragon119
ms.service: guidance
ms.topic: article
ms.date: 09/22/2016
ms.author: pnp
ms.custom: elasticsearch

pnp.series.title: Elasticsearch on Azure
pnp.series.prev: implement-jmeter-test-plan
pnp.series.next: automated-resilience-tests
---
# Deploy a JMeter JUnit sampler for testing performance
[!INCLUDE [header](../_includes/header.md)]

This document describes how to create and use a JUnit sampler that can generate and upload data to an Elasticsearch cluster as part of a JMeter test plan. This approach provides a highly flexible approach to load testing that can generate large quantities of test data without depending on external data files.

> [!NOTE]
> The load tests used to assess the performance of data ingestion described in [Tuning data ingestion performance for Elasticsearch](./data-ingestion-performance.md) were constructed using this approach. The details of the JUnit code are described in that document.
> 
> 

For testing data ingestion performance, the JUnit code was developing using Eclipse (Mars), and dependencies were resolved using Maven. The following procedures describe the step by step process for installing Eclipse, configuring Maven, creating a JUnit test, and deploying this test as a JUnit Request sampler in a JMeter test.

> [!NOTE]
> For detailed information on the structure and configuration of the test environment, see [Creating a performance testing environment for Elasticsearch on Azure][Creating a performance testing environment for Elasticsearch on Azure].
> 
> 

## Installing prerequisites
You will need the [Java Runtime Environment](http://www.java.com/en/download/ie_manual.jsp) on your development machine.
You will also need to install the [Eclipse IDE for Java Developers](https://www.eclipse.org/downloads/index.php?show_instructions=TRUE).

> [!NOTE]
> If you are using the JMeter master VM described in [Creating a performance testing environment for Elasticsearch on Azure][Creating a performance testing environment for Elasticsearch on Azure] as your development environment, download the Windows 32 Bit version of the Eclipse Installer.
> 
> 

## Creating a JUnit test project for load testing Elasticsearch
Start the Eclipse IDE if it is not already running, and then close the **Welcome** page.  On the **File** menu, 
click, and then click **Java Project**.

![Eclipse menu](./images/jmeter-deploy7.png)

In the **New Java Project** window, enter a project name, select **Use default JRE**, and then click **Finish**.

![New Java Project dialog](./images/jmeter-deploy8.png)

In the **Package Explorer** window, expand the node named after your project. Verify that it contains a 
folder named **src** and a reference to the JRE you specified.

![Eclipse Package Explorer](./images/jmeter-deploy9.png)

Right-click the **src** folder, click **New**, and then click **JUnit Test Case**.

![New JUnit Test Case menu item](./images/jmeter-deploy10.png)

In the **New JUnit Test Case** window, select **New Junit 4 test**, enter a name for the package (this can 
be the same as the name of the project, although by convention it should start with a lower case letter), 
a name for the test class, and select the options that generate the method stubs required for your test. 
Leave the **Class under test** box empty, and then click **Finish**.

![New JUnit Test Case dialog](./images/jmeter-deploy11.png)

If the following **New JUnit Test Case** dialog box appears, select the option to add the JUnit 4 library 
to the build path and then click **OK**. 

![New JUnit Test Case dialog](./images/jmeter-deploy12.png)

Verify that the skeleton code for the JUnit test is generated and displayed in the Java editor window.

![Java editor window](./images/jmeter-deploy13.png)

In the **Package Explorer**, right-click the node for your project, click **Configure**, and then click 
**Convert to Maven Project**.

> [!NOTE]
> Using Maven enables you to more easily manage external dependencies (such as the 
> Elasticsearch Java client libraries) a project depends on.
> 
> 

![Convert to Maven Project menu item](./images/jmeter-deploy14.png)

In the **Create new POM** dialog box, in the **Packaging** drop-down list, select **jar**, and then click 
**Finish**.

![Create new POM dialog](./images/jmeter-deploy15.png)

The pane that appears below the project object model (POM) editor might display the warning "Build path specifies execution environment J2SE-1.5. There are no JREs installed in the workspace that are strictly compatible with this environment",  depending on which version of Java is installed on your development machine. If you have a version of Java that is later than version 1.5 you can safely ignore this warning.

![Eclipse warnings](./images/jmeter-deploy16.png)

In the POM editor, expand **Properties** and then click **Create**.

![POM editor](./images/jmeter-deploy17.png)

In the **Add Property** dialog box, in the **Name** box type *es.version*, in the **Value** box type *1.7.2*, 
and then click **OK**. This is the version of the Elasticsearch Java client library to use (this version 
may be superseded in the future, and defining the version as a POM property and referencing this property elsewhere within the project enables the version to be changed quickly.)

![Add Property dialog](./images/jmeter-deploy18.png)

Click the **Dependencies** tab at the base of the POM editor, and then click **Add** next to the **Dependencies** 
list.

![Dependencies tab](./images/jmeter-deploy19.png)

In the **Select Dependency** dialog box, in the **Group Id** box type *org.elasticsearch*, in the **Artifact Id** 
box type *elasticsearch*, in the **Version** box type *\${es.version}*, and then click **OK**. Information 
about the Java Elasticsearch client library is held in the online Maven Central repository, and this 
configuration will automatically download the library and its dependencies when the project is built.

![Select Dependency dialog](./images/jmeter-deploy20.png)

On **File** menu, click **Save All**. This action will save and build the project, downloading the 
dependencies specified by Maven. Verify that the Maven Dependencies folder appears in Package Explorer. 
Expand this folder to view the jar files downloaded to support the Elasticsearch Java client library.

![Package Explorer](./images/jmeter-deploy21.png)

## Importing an existing JUnit test project into Eclipse
This procedure assumes that you have downloaded a Maven project that was previously created by using 
Eclipse.

Start the Eclipse IDE. On the **File** menu, click **Import**.

![Import menu item](./images/jmeter-deploy22.png)

In the **Select** window, expand the **Maven** folder, click **Existing Maven Projects**, and then click **Next**.

![Import menu](./images/jmeter-deploy23.png)

In the **Maven Projects** window, specify the folder holding the project (the folder containing the 
pom.xml file), click **Select All**, and then click **Finish**.

![Import Maven Projects dialog](./images/jmeter-deploy24.png)

In the **Package Explorer** window, expand the node corresponding to your project. Verify that the project 
contains a folder named **src**. This folder contains the source code for the JUnit test. The project can 
be compiled and deployed following the instructions below.

![Package explorer](./images/jmeter-deploy25.png)

## Deploying a JUnit test to JMeter
This procedure assumes you have created a project named LoadTest containing a JUnit Test class named 
`BulkLoadTest.java` that accepts configuration parameters passed in as a single string to a 
constructor (this is the mechanism that JMeter expects).

In the Eclipse IDE, in **Package Explorer**, right-click the project node, and then click **Export**.

![Export menu item](./images/jmeter-deploy26.png)

In the **Export Wizard**, on the **Select** page, expand the **Java** node, click **JAR file**, and then click 
**Next**.

![Export dialog](./images/jmeter-deploy27.png)

On the **JAR File Specification** page, in the **Select the resources to export** box, expand the project 
deselect **.project**, and deselect **pom.xml**. In the **JAR file** box, provide a file name and location 
for the JAR (it should be given the .jar file extension), and then click **Finish**.

![JAR Export dialog](./images/jmeter-deploy28.png)

Using Windows Explorer, copy the JAR file you have just created to the JMeter master JVM and save it 
in the apache-jmeter-2.13\\lib\\junit folder underneath the folder where you have installed JMeter 
(see the procedure "Creating the JMeter master virtual machine" in [Creating a performance testing environment for Elasticsearch on Azure](./performance-testing-environment.md) for more information.)

Return to Eclipse, expand the **Package Explorer** window and make a note of all the JAR files and their 
locations listed in the Maven Dependencies folder for the project. Note that the files displayed 
in the following image might vary, depending on which version of Elasticsearch you are using:

![Package Explorer](./images/jmeter-deploy29.png)

Using Windows Explorer, copy each JAR file referenced in the Maven Dependencies folder to the 
apache-jmeter-2.13\\lib\\junit folder on the JMeter master VM.

If the lib\\junit folder already contains older versions of these JAR files then remove them. 
If you leave them in place then the JUnit test might not work as references could be resolved to the 
wrong JARs.

On the JMeter master VM, stop JMeter if is currently running.  Start JMeter.  In JMeter, right-click 
**Test Plan**, click **Add**, click **Threads (Users)**, and then click **Thread Group**.

![Thread Group menu item](./images/jmeter-deploy30.png)

Under the **Test Plan** node, right-click **Thread Group**, click **Add**, click **Sampler**, and then click 
**JUnit Request**.

![JUnit Request menu item](./images/jmeter-deploy31.png)

On the **JUnit Request** page, select **Search for JUnit4 annotations (instead of JUnit 3)**. In the 
**Classname** drop-down list, select your JUnit load test class (it will be listed in the form 
*&lt;package&gt;.&lt;class&gt;*), in the **Test Method** drop-down list select the JUnit test method 
(this is the method that actually performs the work associated with the test and should have been marked 
with the *@test* annotation in the Eclipse project), and enter any values to be passed to the constructor 
in the **Constructor String Label** box. The details shown in the following image are just examples; 
your **Classname**, **Test Method*, and **Constructor String Label** will probably differ from those shown.

![JUnit Request UI](./images/jmeter-deploy32.png)

If your class does not appear in the **Classname** drop-down list, it probably means that the JAR was 
not exported properly or has not been placed in the lib\\junit folder, or some of the dependent JARs 
are missing from the lib\\junit folder. If this occurs, export the project from Eclipse again and 
ensure that you have selected the **src** resource, copy the JAR to the lib\\junit folder, and then 
verify that you have copied all of the dependent JARs listed by Maven to the lib folder.

Close JMeter. There is no need to save the test plan.  Copy the JAR file containing the JUnit test class 
to the /home/&lt;username&gt;/apache-jmeter-2.13/lib/junit folder on each of the JMeter subordinate 
VMs (*&lt;username&gt;* is the name of the administrative user you specified when you created the VM, 
see the procedure "Creating the JMeter subordinate virtual machines" in [Creating a performance testing environment for Elasticsearch on Azure](./performance-testing-environment.md) for more information.)

Copy the dependent JAR files required by the JUnit test class to the 
/home/&lt;username&gt;/apache-jmeter-2.13/lib/junit folder on each of the JMeter subordinate VMs. 
Make sure to remove any older versions of JAR files from this folder first.

You can use the `pscp` utility to copy files from a Windows computer to Linux.

[Creating a Performance Testing Environment for Elasticsearch on Azure]: ./performance-testing-environment.md
