---
title: Access datasets with Python client library
description: Install and use the Python client library to access and manage Azure Machine Learning data securely from a local Python environment.
author: marktab
manager: marktab
editor: marktab
services: architecture-center
ms.service: architecture-center
ms.subservice: azure-guide
ms.topic: article
ms.date: 01/10/2020
ms.author: tdsp
ms.custom:
  - devx-track-python
  - previous-author=deguhath
  - previous-ms.author=deguhath
products:
  - azure-machine-learning
categories:
  - ai-machine-learning
---
# Access datasets with Python using the Azure Machine Learning Python client library

The preview of Microsoft Azure Machine Learning Python client library can enable secure access to your Azure Machine Learning datasets from a local Python environment and enables the creation and management of datasets in a workspace.

This topic provides instructions on how to:

* install the Machine Learning Python client library
* access and upload datasets, including instructions on how to get authorization to access Azure Machine Learning datasets from your local Python environment
* access intermediate datasets from experiments
* use the Python client library to enumerate datasets, access metadata, read the contents of a dataset, create new datasets, and update existing datasets

## <a name="prerequisites"></a>Prerequisites
The Python client library has been tested under the following environments:

* Windows, Mac, and Linux
* Python 2.7 and 3.6+

It has a dependency on the following packages:

* requests
* python-dateutil
* pandas

We recommend using a Python distribution such as [Anaconda](https://www.anaconda.com/) or [Canopy](https://store.enthought.com/downloads/), which come with Python, IPython and the three packages listed above installed. Although IPython is not strictly required, it is a great environment for manipulating and visualizing data interactively.

### <a name="installation"></a>How to install the Azure Machine Learning Python client library
Install the Azure Machine Learning Python client library to complete the tasks outlined in this topic. This library is available from the [Python Package Index](https://pypi.python.org/pypi/azureml). To install it in your Python environment, run the following command from your local Python environment:

```console
pip install azureml
```

Alternatively, you can download and install from the sources on [GitHub](https://github.com/Azure/Azure-MachineLearning-ClientLibrary-Python).

```console
python setup.py install
```

If you have git installed on your machine, you can use pip to install directly from the git repository:

```console
pip install git+https://github.com/Azure/Azure-MachineLearning-ClientLibrary-Python.git
```

## <a name="datasetAccess"></a>Use code snippets to access datasets
The Python client library gives you programmatic access to your existing datasets from experiments that have been run.

From the Azure Machine Learning Studio (classic) web interface, you can generate code snippets that include all the necessary information to download and deserialize datasets as pandas DataFrame objects on your local machine.

### <a name="security"></a>Security for data access
The code snippets provided by Azure Machine Learning Studio (classic) for use with the Python client library includes your workspace ID and authorization token. These provide full access to your workspace and must be protected, like a password.

For security reasons, the code snippet functionality is only available to users that have their role set as **Owner** for the workspace. Your role is displayed in Azure Machine Learning Studio (classic) on the **USERS** page under **Settings**.

![Screenshot shows settings in the USERS page of Azure Machine Learning Studio.][security]

If your role is not set as **Owner**, you can either request to be reinvited as an owner, or ask the owner of the workspace to provide you with the code snippet.

To obtain the authorization token, you may choose one of these options:

* Ask for a token from an owner. Owners can access their authorization tokens from the Settings page of their workspace in Azure Machine Learning Studio (classic). Select **Settings** from the left pane and click **AUTHORIZATION TOKENS** to see the primary and secondary tokens. Although either the primary or the secondary authorization tokens can be used in the code snippet, it is recommended that owners only share the secondary authorization tokens.

   ![Authorization tokens](./media/python-data-access/ml-python-access-settings-tokens.png)

* Ask to be promoted to role of owner:  a current owner of the workspace needs to first remove you from the workspace then reinvite you to it as an owner.

Once developers have obtained the workspace ID and authorization token, they are able to access the workspace using the code snippet regardless of their role.

Authorization tokens are managed on the **AUTHORIZATION TOKENS** page under **SETTINGS**. You can regenerate them, but this procedure revokes access to the previous token.

### <a name="accessingDatasets"></a>Access datasets from a local Python application
1. In Machine Learning Studio (classic), click **DATASETS** in the navigation bar on the left.
2. Select the dataset you would like to access. You can select any of the datasets from the **MY DATASETS** list or from the **SAMPLES** list.
3. From the bottom toolbar, click **Generate Data Access Code**. If the data is in a format incompatible with the Python client library, this button is disabled.

    ![Screenshot shows datasets with the GENERATE DATA ACCESS CODE.][datasets]
4. Select the code snippet from the window that appears and copy it to your clipboard.

    ![Generate data access code button][dataset-access-code]
5. Paste the code into the notebook of your local Python application.

    ![Paste code into the notebook][ipython-dataset]

## <a name="accessingIntermediateDatasets"></a>Access intermediate datasets from Machine Learning experiments
After an experiment is run in Machine Learning Studio (classic), it is possible to access the intermediate datasets from the output nodes of modules. Intermediate datasets are data that has been created and used for intermediate steps when a model tool has been run.

Intermediate datasets can be accessed as long as the data format is compatible with the Python client library.

The following formats are supported (constants for these formats are in the `azureml.DataTypeIds` class):

* PlainText
* GenericCSV
* GenericTSV
* GenericCSVNoHeader
* GenericTSVNoHeader

You can determine the format by hovering over a module output node. It is displayed along with the node name, in a tooltip.

Some of the modules, such as the [Split][split] module, output to a format named `Dataset`, which is not supported by the Python client library.

![Dataset Format][dataset-format]

You need to use a conversion module, such as [Convert to CSV][convert-to-csv], to get an output into a supported format.

![GenericCSV Format][csv-format]

The following steps show an example that creates an experiment, runs it and accesses the intermediate dataset.

1. Create a new experiment.
2. Insert an **Adult Census Income Binary Classification dataset** module.
3. Insert a [Split][split] module, and connect its input to the dataset module output.
4. Insert a [Convert to CSV][convert-to-csv] module and connect its input to one of the [Split][split] module outputs.
5. Save the experiment, run it, and wait for the job to finish.
6. Click the output node on the [Convert to CSV][convert-to-csv] module.
7. When the context menu appears, select **Generate Data Access Code**.

    ![Context Menu][experiment]
8. Select the code snippet and copy it to your clipboard from the window that appears.

    ![Generate access code from context menu][intermediate-dataset-access-code]
9. Paste the code in your notebook.

    ![Paste code into notebook][ipython-intermediate-dataset]
10. You can visualize the data using matplotlib. This displays in a histogram for the age column:

    ![Histogram][ipython-histogram]

## <a name="clientApis"></a>Use the Machine Learning Python client library to access, read, create, and manage datasets
### Workspace
The workspace is the entry point for the Python client library. Provide the `Workspace` class with your workspace ID and authorization token to create an instance:

```python
ws = Workspace(workspace_id='4c29e1adeba2e5a7cbeb0e4f4adfb4df',
               authorization_token='f4f3ade2c6aefdb1afb043cd8bcf3daf')
```

### Enumerate datasets
To enumerate all datasets in a given workspace:

```python
for ds in ws.datasets:
    print(ds.name)
```

To enumerate just the user-created datasets:

```python
for ds in ws.user_datasets:
    print(ds.name)
```

To enumerate just the example datasets:

```python
for ds in ws.example_datasets:
    print(ds.name)
```

You can access a dataset by name (which is case-sensitive):

```python
ds = ws.datasets['my dataset name']
```

Or you can access it by index:

```python
ds = ws.datasets[0]
```

### Metadata
Datasets have metadata, in addition to content. (Intermediate datasets are an exception to this rule and do not have any metadata.)

Some metadata values are assigned by the user at creation time:

* `print(ds.name)`
* `print(ds.description)`
* `print(ds.family_id)`
* `print(ds.data_type_id)`

Others are values assigned by Azure ML:

* `print(ds.id)`
* `print(ds.created_date)`
* `print(ds.size)`

See the `SourceDataset` class for more on the available metadata.

### Read contents
The code snippets provided by Machine Learning Studio (classic) automatically download and deserialize the dataset to a pandas DataFrame object. This is done with the `to_dataframe` method:

```python
frame = ds.to_dataframe()
```

If you prefer to download the raw data, and perform the deserialization yourself, that is an option. At the moment, this is the only option for formats such as 'ARFF', which the Python client library cannot deserialize.

To read the contents as text:

```python
text_data = ds.read_as_text()
```

To read the contents as binary:

```python
binary_data = ds.read_as_binary()
```

You can also just open a stream to the contents:

```python
with ds.open() as file:
    binary_data_chunk = file.read(1000)
```

### Create a new dataset
The Python client library allows you to upload datasets from your Python program. These datasets are then available for use in your workspace.

If you have your data in a pandas DataFrame, use the following code:

```python
from azureml import DataTypeIds

dataset = ws.datasets.add_from_dataframe(
    dataframe=frame,
    data_type_id=DataTypeIds.GenericCSV,
    name='my new dataset',
    description='my description'
)
```

If your data is already serialized, you can use:

```python
from azureml import DataTypeIds

dataset = ws.datasets.add_from_raw_data(
    raw_data=raw_data,
    data_type_id=DataTypeIds.GenericCSV,
    name='my new dataset',
    description='my description'
)
```

The Python client library is able to serialize a pandas DataFrame to the following formats (constants for these are in the `azureml.DataTypeIds` class):

* PlainText
* GenericCSV
* GenericTSV
* GenericCSVNoHeader
* GenericTSVNoHeader

### Update an existing dataset
If you try to upload a new dataset with a name that matches an existing dataset, you should get a conflict error.

To update an existing dataset, you first need to get a reference to the existing dataset:

```python
dataset = ws.datasets['existing dataset']

print(dataset.data_type_id) # 'GenericCSV'
print(dataset.name)         # 'existing dataset'
print(dataset.description)  # 'data up to jan 2015'
```

Then use `update_from_dataframe` to serialize and replace the contents of the dataset on Azure:

```python
dataset = ws.datasets['existing dataset']

dataset.update_from_dataframe(frame2)

print(dataset.data_type_id) # 'GenericCSV'
print(dataset.name)         # 'existing dataset'
print(dataset.description)  # 'data up to jan 2015'
```

If you want to serialize the data to a different format, specify a value for the optional `data_type_id` parameter.

```python
from azureml import DataTypeIds

dataset = ws.datasets['existing dataset']

dataset.update_from_dataframe(
    dataframe=frame2,
    data_type_id=DataTypeIds.GenericTSV,
)

print(dataset.data_type_id) # 'GenericTSV'
print(dataset.name)         # 'existing dataset'
print(dataset.description)  # 'data up to jan 2015'
```

You can optionally set a new description by specifying a value for the `description` parameter.

```python
dataset = ws.datasets['existing dataset']

dataset.update_from_dataframe(
    dataframe=frame2,
    description='data up to feb 2015',
)

print(dataset.data_type_id) # 'GenericCSV'
print(dataset.name)         # 'existing dataset'
print(dataset.description)  # 'data up to feb 2015'
```

You can optionally set a new name by specifying a value for the `name` parameter. From now on, you'll retrieve the dataset using the new name only. The following code updates the data, name, and description.

```python
dataset = ws.datasets['existing dataset']

dataset.update_from_dataframe(
    dataframe=frame2,
    name='existing dataset v2',
    description='data up to feb 2015',
)

print(dataset.data_type_id)                    # 'GenericCSV'
print(dataset.name)                            # 'existing dataset v2'
print(dataset.description)                     # 'data up to feb 2015'

print(ws.datasets['existing dataset v2'].name) # 'existing dataset v2'
print(ws.datasets['existing dataset'].name)    # IndexError
```

The `data_type_id`, `name` and `description` parameters are optional and default to their previous value. The `dataframe` parameter is always required.

If your data is already serialized, use `update_from_raw_data` instead of `update_from_dataframe`. If you just pass in `raw_data` instead of  `dataframe`, it works in a similar way.

<!-- Images -->
[security]:./media/python-data-access/security.png
[dataset-format]:./media/python-data-access/dataset-format.png
[csv-format]:./media/python-data-access/csv-format.png
[datasets]:./media/python-data-access/datasets.png
[dataset-access-code]:./media/python-data-access/dataset-access-code.png
[ipython-dataset]:./media/python-data-access/ipython-dataset.png
[experiment]:./media/python-data-access/experiment.png
[intermediate-dataset-access-code]:./media/python-data-access/intermediate-dataset-access-code.png
[ipython-intermediate-dataset]:./media/python-data-access/ipython-intermediate-dataset.png
[ipython-histogram]:./media/python-data-access/ipython-histogram.png

<!-- Module References -->
[convert-to-csv]: /azure/machine-learning/studio-module-reference/convert-to-csv
[split]: /azure/machine-learning/studio-module-reference/split-data
