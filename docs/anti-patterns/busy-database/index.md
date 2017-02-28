---
title: Busy Database antipattern
description: 

author: dragon119
manager: christb

pnp.series.title: Optimize Performance
---
# Busy Database
[!INCLUDE [header](../../_includes/header.md)]

The primary purpose of a database is to act as a repository of information.
Technically, a database is simply a collection of data files, but most modern database
systems implement a server-based approach that abstracts the details of how these
files are structured. A database server also handles aspects such as concurrency and
locking to prevent data from being corrupted by concurrent read and write operations,
and managing security to control access to data.

As well as the logic associated with storing and fetching data in a controlled and
safe manner, many database systems include the ability to run code within the server.
Examples include stored procedures and triggers. The intent is that it is often more
efficient to perform this processing close to the data rather than transmitting the
data to a client application for processing. It is possible for a single data update
operation to run a number of database triggers and stored procedures which might in
turn fire further triggers and stored procedures. Consider cascading deletes in a SQL
database as an example; removing one row in one table might trigger updates and
deletes of many other related rows in other tables.

However, you should use the increased functionality available with database servers
with care to prevent a database server from becoming overloaded. A common occurrence
is to perform data processing on the database server in the belief that this is the
most efficient way of implementing these tasks. However, offloading processing to a
database server can cause it to spend a significant proportion of the time running
code rather than responding to requests to store and retrieve data. In turn, this can
impact the performance of all client applications using the database; a database is
usually a shared resource and as a result it can become a bottleneck during periods of
high use.

----------

**Note:** In some cases overloading a database can cause significant scalability
issues. For example, you can scale Azure SQL Database vertically but it has a maximum
quota in terms of Database Throughput Units (DTUs) which defines a hard-limit for the
degree of vertical scalability. Scaling horizontally by using multiple database
instances is a non-trivial task in terms of the increased design and programming
complexity, and also the additional management effort required.

----------

This anti-pattern typically occurs because:

- The database is viewed as a service rather than a repository. As such, an
application might expect the database server to format data (such as converting to
XML), manipulate string data, or perform complex calculations rather than simply
returning raw information.

- The client application uses data binding against the database and expects queries to
return results that can be displayed directly. This might involve combining fields as
they are retrieved from the database (for example, using SQL statements such as `
SELECT firstname + ' ' + middlename + ' ' + lastname FROM ...`), or formatting dates,
times, currency, and numeric values according to locale.

----------

**Note:** This practice is not recommended as it closely couples the user interface
with the database. Instead, retrieve the raw data into objects that act as view-models
and bind the user interface to these view-models. For more information, see the [Model View ViewModel (MVVM)][MVVM] pattern.

----------

- It is viewed as a strategy to combat issues with network bandwidth as described by
the [Extraneous Fetching][ExtraneousFetching] anti-pattern.

- An application uses stored procedures in a database to encapsulate business logic
because they are considered to be easier to maintain and quicker to deploy than doing
rolling updates to code in web applications. The process of updating a stored
procedure is also less disruptive to end-users of an application (no re-installation
of the application is required).

- There is the perception that a database running on powerful hardware is more
efficient at performing calculations or transformations over data than a client
application running on less-powerful machinery.

The [sample application][fullDemonstrationOfProblem] available with this anti-pattern
illustrates an example that uses Azure SQL Database to retrieve the details of the top
20 most valuable orders for a specified sales territory and format the results as XML.
This example uses Transact-SQL functions to parse the data as it is retrieved from the
various tables in the database and uses the XML capabilities of Transact-SQL to
converts the resulting data to XML:

**Transact-SQL:**
```SQL
SELECT TOP 20
  soh.[SalesOrderNumber]  AS '@OrderNumber',
  soh.[Status]            AS '@Status',
  soh.[ShipDate]          AS '@ShipDate',
  YEAR(soh.[OrderDate])   AS '@OrderDateYear',
  MONTH(soh.[OrderDate])  AS '@OrderDateMonth',
  soh.[DueDate]           AS '@DueDate',
  FORMAT(ROUND(soh.[SubTotal],2),'C')
                          AS '@SubTotal',
  FORMAT(ROUND(soh.[TaxAmt],2),'C')
                          AS '@TaxAmt',
  FORMAT(ROUND(soh.[TotalDue],2),'C')
                          AS '@TotalDue',
  CASE WHEN soh.[TotalDue] > 5000 THEN 'Y' ELSE 'N' END
                          AS '@ReviewRequired',
  (
  SELECT
    c.[AccountNumber]     AS '@AccountNumber',
    UPPER(LTRIM(RTRIM(REPLACE(
    CONCAT( p.[Title], ' ', p.[FirstName], ' ', p.[MiddleName], ' ', p.[LastName], ' ', p.[Suffix]),
    '  ', ' '))))         AS '@FullName'
  FROM [Sales].[Customer] c
    INNER JOIN [Person].[Person] p
  ON c.[PersonID] = p.[BusinessEntityID]
  WHERE c.[CustomerID] = soh.[CustomerID]
  FOR XML PATH ('Customer'), TYPE
  ),

  (
  SELECT
    sod.[OrderQty]      AS '@Quantity',
    FORMAT(sod.[UnitPrice],'C')
                        AS '@UnitPrice',
    FORMAT(ROUND(sod.[LineTotal],2),'C')
                        AS '@LineTotal',
    sod.[ProductID]     AS '@ProductId',
    CASE WHEN (sod.[ProductID] >= 710) AND (sod.[ProductID] <= 720) AND (sod.[OrderQty] >= 5) THEN 'Y' ELSE 'N' END
                        AS '@InventoryCheckRequired'

  FROM [Sales].[SalesOrderDetail] sod
  WHERE sod.[SalesOrderID] = soh.[SalesOrderID]
  ORDER BY sod.[SalesOrderDetailID]
  FOR XML PATH ('LineItem'), TYPE, ROOT('OrderLineItems')
  )

FROM [Sales].[SalesOrderHeader] soh
WHERE soh.[TerritoryId] = @TerritoryId
ORDER BY soh.[TotalDue] DESC
FOR XML PATH ('Order'), ROOT('Orders')
```

----------

**Note:** The code that invokes this Transact-SQL block is located in the `Get` method
in the `TooMuchProcSql` web API controller in the sample application.

----------

The following XML fragment shows a sample of the results generated by this query:

**XML**
```XML
<Orders>
  <Order OrderNumber="SO51830" Status="5" ShipDate="2007-08-08T00:00:00" OrderDateYear="2007" OrderDateMonth="8" DueDate="2007-08-13T00:00:00" SubTotal="$112,611.97" TaxAmt="$10,849.67" TotalDue="$126,852.16" ReviewRequired="Y">
    <Customer AccountNumber="AW00029617" FullName="MS. LINDSEY R. CAMACHO" />
    <OrderLineItems>
      <LineItem Quantity="14" UnitPrice="$5.21" LineTotal="$71.54" ProductId="875" InventoryCheckRequired="N" />
      <LineItem Quantity="5" UnitPrice="$32.39" LineTotal="$161.97" ProductId="881" InventoryCheckRequired="N" />
      <LineItem Quantity="11" UnitPrice="$649.88" LineTotal="$7,005.75" ProductId="801" InventoryCheckRequired="N" />
      <LineItem Quantity="9" UnitPrice="$672.29" LineTotal="$6,050.65" ProductId="798" InventoryCheckRequired="N" />
      ...
    </OrderLineItems>
  </Order>
  <Order OrderNumber="SO57105" Status="5" ShipDate="2007-11-08T00:00:00" OrderDateYear="2007" OrderDateMonth="11" DueDate="2007-11-13T00:00:00" SubTotal="$110,050.84" TaxAmt="$10,818.02" TotalDue="$124,249.49" ReviewRequired="Y">
    <Customer AccountNumber="AW00029818" FullName="MR. ROGER HARUI" />
    <OrderLineItems>
      <LineItem Quantity="8" UnitPrice="$461.69" LineTotal="$3,693.55" ProductId="983" InventoryCheckRequired="N" />
      <LineItem Quantity="1" UnitPrice="$37.15" LineTotal="$37.15" ProductId="809" InventoryCheckRequired="N" />
      <LineItem Quantity="2" UnitPrice="$72.16" LineTotal="$144.32" ProductId="810" InventoryCheckRequired="N" />
      ...
    </OrderLineItems>
    ...
  </Order>
</Orders>
```
This is clearly a complex query that utilizes significant processing resources on the database server.

## How to detect the problem

Symptoms of a busy database in an application include a disproportionate degradation
in throughput and response time in business operations that access the database. From
a management perspective, the runtime costs may be excessive if data store resources
are metered and charged (*remember, DTUs with Azure SQL Database*).

You can perform the following steps to help identify this problem:

1. Use performance monitoring to identify how much time the system spends performing
database activity.

2. Examine the work performed by the database occurring during these periods.

3. If the database activity reveals significant processing but little data traffic,
review the source code and determine whether the processing can better be performed
elsewhere.

The following sections apply these steps to the sample application described earlier.

----------

**Note:** If you already have an insight into where problems might lie, you may be
able to skip some of these steps. However, you should avoid making unfounded or biased
assumptions. Performing a thorough analysis can sometimes lead to the identification
of unexpected causes of performance problems. The following sections are formulated to
help you examine applications and services systematically.

----------

### Monitoring the volume of database activity

You can use an application performance monitor to track the database activity of the
system in production. If the volume of database activity is low or response times are
relatively fast, then a busy database is unlikely to be a performance problem.

If you suspect that particular operations might cause undue database activity, then
you can perform load-testing in a controlled environment. Each test should run a
mixture of the suspect operations using a variable user-load to see how the system
responds. You should also monitor the test system and examine the telemetry generated
while the load test is in operation and observe how the database is used.

The following graph shows the results of performing a load-test against the sample
application using a step-load of up to 50 concurrent users. The volume of tests that
the system can handle quickly reaches a limit and stays at that level, while the
response time steadily increases (note that the scale measuring the number of tests and
the response time is logarithmic):

![Load-test results for performing processing in the database][ProcessingInDatabaseLoadTest]

Examining the performance of the SQL Database by using the database monitor in the
Azure Management console and capturing the CPU utilization together with the number of
database throughput units (DTU) provides a measure of how much processing the database
was performing. In the graph below, CPU and DTU utilization both quickly reached 100%
during the test (the test ran from 10:20 to 10:50.)

![Azure SQL Database monitor showing the performance of the database while performing processing][ProcessingInDatabaseMonitor]

### Examining the work performed by the database

It could be that the tasks performed by the database are genuine data access
operations, so it is important to understand the SQL statements being run while the
database is busy. You should monitor the system to capture the SQL traffic and
correlate the operational requests (user activity) being performed by the application
with the SQL operations being executed by these requests.

### Reviewing the source code

If you identify database operations that perform processing rather than data access
operations, review the code that invokes these operations. It might be preferable to
implement the processing as application code rather than offloading it to the database
server.

## How to correct the problem

Relocate processing from the database server to the client application or business
tier, where appropriate. This will involve refactoring the application code, and it
may still be necessary to retrieve some information from the database to implement an
operation. Ideally, you should limit the database to performing data access
operations, and possibly to summarizing information where appropriate if the database
server supports the necessary aggregation functions.

In the sample application, the Transact-SQL code can be replaced with the following
statement that simply retrieves the data to be processed from the database:

**Transact-SQL:**
```SQL
SELECT
soh.[SalesOrderNumber]  AS [OrderNumber],
soh.[Status]            AS [Status],
soh.[OrderDate]         AS [OrderDate],
soh.[DueDate]           AS [DueDate],
soh.[ShipDate]          AS [ShipDate],
soh.[SubTotal]          AS [SubTotal],
soh.[TaxAmt]            AS [TaxAmt],
soh.[TotalDue]          AS [TotalDue],
c.[AccountNumber]       AS [AccountNumber],
p.[Title]               AS [CustomerTitle],
p.[FirstName]           AS [CustomerFirstName],
p.[MiddleName]          AS [CustomerMiddleName],
p.[LastName]            AS [CustomerLastName],
p.[Suffix]              AS [CustomerSuffix],
sod.[OrderQty]          AS [Quantity],
sod.[UnitPrice]         AS [UnitPrice],
sod.[LineTotal]         AS [LineTotal],
sod.[ProductID]         AS [ProductId]
FROM [Sales].[SalesOrderHeader] soh
INNER JOIN [Sales].[Customer] c ON soh.[CustomerID] = c.[CustomerID]
INNER JOIN [Person].[Person] p ON c.[PersonID] = p.[BusinessEntityID]
INNER JOIN [Sales].[SalesOrderDetail] sod ON soh.[SalesOrderID] = sod.[SalesOrderID]
WHERE soh.[TerritoryId] = @TerritoryId
AND soh.[SalesOrderId] IN (
	SELECT TOP 20 SalesOrderId
	FROM [Sales].[SalesOrderHeader] soh
	WHERE soh.[TerritoryId] = @TerritoryId
	ORDER BY soh.[TotalDue] DESC)
ORDER BY soh.[TotalDue] DESC, sod.[SalesOrderDetailID]
```

The processing is performed by the client application using the XML library available
with the .NET Framework, as follows:

**C#**
```C#

// Create a new SqlCommand to run the Transact-SQL query
using (var command = new SqlCommand(...))
{
    command.Parameters.AddWithValue("@TerritoryId", id);

    // Run the query and create the initial XML document
    using (var reader = await command.ExecuteReaderAsync())
    {
        var lastOrderNumber = string.Empty;

        var doc = new XDocument();
        var orders = new XElement("Orders");

        doc.Add(orders);
        XElement lineItems = null;

        // Fetch each row in turn, format the results as XML, and add them to the XML document
        while (await reader.ReadAsync())
        {
            var orderNumber = reader["OrderNumber"].ToString();

            if (orderNumber != lastOrderNumber)
            {
                lastOrderNumber = orderNumber;

                var order = new XElement("Order");
                orders.Add(order);
                var customer = new XElement("Customer");
                lineItems = new XElement("OrderLineItems");
                order.Add(customer, lineItems);

                var orderDate = (DateTime)reader["OrderDate"];

                var totalDue = (Decimal)reader["TotalDue"];
                var reviewRequired = totalDue > 5000
                    ? 'Y'
                    : 'N';

                order.Add(
                    new XAttribute("OrderNumber", orderNumber),
                    new XAttribute("Status", reader["Status"]),
                    new XAttribute("ShipDate", reader["ShipDate"]),
                    new XAttribute("OrderDateYear", orderDate.Year),
                    new XAttribute("OrderDateMonth", orderDate.Month),
                    new XAttribute("DueDate", reader["DueDate"]),
                    new XAttribute("SubTotal", RoundAndFormat(reader["SubTotal"])),
                    new XAttribute("TaxAmt", RoundAndFormat(reader["TaxAmt"])),
                    new XAttribute("TotalDue", RoundAndFormat(totalDue)),
                    new XAttribute("ReviewRequired", reviewRequired));

                    var fullName = string.Join(" ",
                        reader["CustomerTitle"],
                        reader["CustomerFirstName"],
                        reader["CustomerMiddleName"],
                        reader["CustomerLastName"],
                        reader["CustomerSuffix"]
                    )
                   .Replace("  ", " ") //remove double spaces
                   .Trim()
                   .ToUpper();

               customer.Add(
                    new XAttribute("AccountNumber", reader["AccountNumber"]),
                    new XAttribute("FullName", fullName));
            }

            var productId = (int)reader["ProductID"];
            var quantity = (short)reader["Quantity"];

            var inventoryCheckRequired = (productId >= 710 && productId <= 720 && quantity >= 5)
                ? 'Y'
                : 'N';

            lineItems.Add(
                new XElement("LineItem",
                    new XAttribute("Quantity", quantity),
                    new XAttribute("UnitPrice", ((Decimal)reader["UnitPrice"]).ToString("C")),
                    new XAttribute("LineTotal", RoundAndFormat(reader["LineTotal"])),
                    new XAttribute("ProductId", productId),
                    new XAttribute("InventoryCheckRequired", inventoryCheckRequired)
                ));
        }

        // Match the exact formatting of the XML returned from SQL
        var xml = doc
            .ToString(SaveOptions.DisableFormatting)
            .Replace(" />", "/>");
    }
}
```

----------

**Note:** This code is available in the `LessProcSql` controller in the [solution code][fullDemonstrationOfSolution] provided with this anti-pattern.

----------

You should consider the following points:

- Many database systems are highly optimized to perform certain types of data
processing, such as calculating aggregate values (such as `SUM`, `MAX`, `MIN`, `AVG`,
`COUNT`) over large datasets. Do not transfer these types of processing to the client.

- Do not relocate processing to the client if this decision means that the database
server has to transfer far more data over the network (see the [Extraneous Fetching anti-pattern][ExtraneousFetching].)

- The platform hosting the application requesting the data may require scaling to
handle the additional processing load.

## Consequences of the solution

Relocating processing to the client application leaves the database free to focus on
supporting data access operations. This strategy can also help to ensure that
sufficient capacity remains available to handle business growth or surges in activity
(expected and unexpected) caused by events such as marketing campaigns and product
launches.

The following graph shows the results of repeating the load-test from earlier against
the updated code (the test started just before 11:00 and ran for 30 minutes). Note
that the throughput is significantly higher (over 400 requests per second versus 12
earlier), and the response time is correspondingly much lower (just above 0.1 seconds
compared to over 4 seconds for the previous test):

![Load-test results for performing processing in the database][ProcessingInClientApplicationLoadTest]

The database monitor in the Azure Management console shows the following CPU and DTU
utilization. Notice that this time the system took far longer to reach saturation
despite the increased throughput and performance of the application:

![Azure SQL Database monitor showing the performance of the database while performing processing in the client application][ProcessingInClientApplicationMonitor]

## Related resources

- The [Model-View-ViewModel][MVVM] pattern.

[fullDemonstrationOfProblem]: https://github.com/mspnp/performance-optimization/tree/master/BusyDatabase
[fullDemonstrationOfSolution]: https://github.com/mspnp/performance-optimization/tree/master/BusyDatabase

[ExtraneousFetching]: ../extraneous-fetching/index.md
[MVVM]: http://blogs.msdn.com/b/msgulfcommunity/archive/2013/03/13/understanding_2d00_the_2d00_basics_2d00_of_2d00_mvvm_2d00_design_2d00_pattern.aspx

[ProcessingInDatabaseLoadTest]: ./_images/ProcessingInDatabaseLoadTest.jpg
[ProcessingInClientApplicationLoadTest]: ./_images/ProcessingInClientApplicationLoadTest.jpg
[ProcessingInDatabaseMonitor]: ./_images/ProcessingInDatabaseMonitor.jpg
[ProcessingInClientApplicationMonitor]: ./_images/ProcessingInClientApplicationMonitor.jpg
