---
title: Homomorphic encryption with SEAL
titleSuffix: Azure Example Scenarios
author: jocontr
ms.date: 05/07/2020
description: Learn about homomorphic encryption, and get an overview and example of how to use the Microsoft SEAL encryption library.
ms.custom: encryption, homomorphic encryption, Microsoft SEAL, security, 'https://azure.microsoft.com/solutions/architecture/homomorphic-encryption-lab/'
  - fcp
---
# Homomorphic encryption with SEAL

Companies often send and receive their data, and store it in the cloud, in encrypted form. But to take advantage of cloud computing services, companies need to provide either unencrypted data, or the keys to decrypt it, which puts their data at increased risk. *Homomorphic encryption* allows computation directly on encrypted data, making it easier to leverage the potential of the cloud for privacy-critical data.

This article discusses how and when to use homomorphic encryption, and walks through creating an example app that implements homomorphic encryption with the open-source [Microsoft Simple Encrypted Arithmetic Library (SEAL)](https://github.com/microsoft/SEAL#introduction).

## Use cases
- Lightweight cloud computations like addition and multiplication on privacy-critical data and parts of programs.
- Outsourced cloud computing, where a single owner owns all the data and has sole access to the decryption keys.

## Architecture

![Traditional and SEAL encryption](./media/seal.png)

Most encryption schemes consist of three functionalities: key generation, encryption, and decryption. *Symmetric-key* encryption schemes use the same secret key for both encryption and decryption, and enable efficient encryption of large amounts of data for secure outsourced cloud storage. *Public-key* encryption schemes use a public key for encryption plus a separate secret key for decryption. Anyone who knows the public key can encrypt data, but only those who know the secret key can decrypt and read the data. Public-key encryption enables secure online communication, but is typically less efficient than symmetric-key encryption.

While traditional encryption can be used for secure storage and communication, outsourced computation has necessarily required the encryption layers to be removed. Cloud services that provide outsourced computation must implement access policies to prevent unauthorized access to the data and keys. Data privacy relies on the access control policies imposed by the cloud provider and trusted by the customer.

With SEAL homomorphic encryption, cloud providers never have unencrypted access to the data they store and compute on. Computations can be performed directly on encrypted data. The results of such encrypted computations remain encrypted, and can be only decrypted by the data owner by using the secret key. Most homomorphic encryption uses public-key encryption schemes, although the public-key functionality may not always be needed.

## Considerations

- Only some computations are possible on encrypted data. Microsoft SEAL homomorphic encryption library allows additions and multiplications on encrypted integers or real numbers. Encrypted comparison, sorting, or regular expressions are not usually feasible to evaluate on encrypted data using this technology. Therefore, only specific privacy-critical cloud computations on parts of programs can be implemented using Microsoft SEAL.

- Microsoft SEAL comes with two different homomorphic encryption schemes with very different properties. The BFV scheme allows modular arithmetic to be performed on encrypted integers. The CKKS scheme allows additions and multiplications on encrypted real or complex numbers, but yields only approximate results. In applications such as summing up encrypted real numbers, evaluating machine learning models on encrypted data, or computing distances of encrypted locations, CKKS is the best choice. For applications where exact values are necessary, the BFV scheme is the only choice.

- Homomorphic encryption isn't very efficient. Since homomorphic encryption comes with a substantial performance overhead, computations that are already costly to perform on unencrypted data probably aren't feasible on encrypted data. 

- Data encrypted with homomorphic encryption is many times larger than unencrypted data, so it may not make sense to encrypt entire large databases, for example, with this technology. Instead, scenarios where strict privacy requirements prohibit unencrypted cloud computation, but the computations themselves are fairly lightweight, are meaningful use cases. 

- Typically, homomorphic encryption schemes have a single secret key, which is held by the data owner. Therefore, homomorphic encryption isn't reasonable for scenarios where multiple different private data owners want to engage in collaborative computation.

- It's not always easy or straightforward to translate an unencrypted computation into a computation on encrypted data. Even if new users can program and run a specific computation using Microsoft SEAL, the difference between efficient and inefficient implementation can be great, and it can be hard to know how to improve performance.

- While the homomorphic encryption primitive itself is secure, it doesn't guarantee that the apps and protocols that use it are secure.

## Implementation

The example code for this article includes a console app and an API to implement a simple client-server interaction with homomorphic encryption.

### Prerequisites
- [Visual Studio 2019](https://www.visualstudio.com/downloads/), any edition. See [Visual Studio 2019 system requirements](https://docs.microsoft.com/visualstudio/releases/2019/system-requirements).
- The [sample code](https://zarmada.blob.core.windows.net/ai-school-module-updates/ai-school-lab-seal.zip), downloaded and extracted to a local folder.

### Build the Microsoft SEAL library (optional)

The sample code already provides the SEAL library DLL files for a Windows x64 platform. You can use the following steps to update the library, learn more about the process, or build the library for a non-Windows x64 platform.

To build the SEAL library for a non-Windows x64 platform, see the [instructions for building the API on Linux, MacOS, or FreeBSD](https://github.com/microsoft/SEAL#linux-macos-and-freebsd). 

1. Clone the [SEAL](https://github.com/microsoft/SEAL) project from GitHub.
1. In Visual Studio, open *SEAL.sln* in your cloned folder.
1. Change the build configuration from **Debug** to **Release**.
1. Follow the instructions under [Microsoft SEAL for .NET](https://github.com/microsoft/SEAL#microsoft-seal-for-net).
   
   The steps should generate two *.dll* files: *sealnetnative.dll* in *dotnet\lib\$(Platform)\$(Configuration)*, and *SEALNet.dll* in *dotnet\lib\$(Configuration)\netstandard2.0*.

### Run the unencrypted sample app

To build and run the unencrypted sample app:

1. In Visual Studio, open *FitnessTracker.sln* from your downloaded and extracted sample project folder.
1. In **Solution Explorer**, right-click the **FitnessTracker** solution and select **Rebuild Solution**.
1. While the solution is building, review the three projects in the solution:
   - **FitnessTrackerAPI:** The .NET Core API, with endpoints to post metrics, perform calculations, and retrieve the keys needed for encryption/decryption.
   - **FitnessTrackerClient:** The console application that sends requests to the API to store run metrics and return a summary of the metrics that have been sent.
   - **FitnessTracker.Common** The .NET Core library project that holds some useful model definitions and a utility class to be shared in the other two projects.
1. After the solution finishes building, right-click the **FitnessTracker** solution and select **Set StartUp Projects**.
1. On the **Startup Project** property page, select **Multiple startup projects**.
1. Under **Action** next to both **FitnessTrackerAPI** and **FitnessTrackerClient**, select **Start**.
1. Select **OK**. 
1. On the Visual Studio toolbar, select **Start** and wait for the app to run.
1. In the console window, type *1* and press Enter to send a new record to the API.
1. Provide the requested information:
   - Running distance (km): *10*.
   - Running time (hours): *2*.
   
1. Type *2*  and press Enter to retrieve the running statistics from the API.
   
   The response from the API is a `SummaryItem` containing three properties: `TotalRuns`, `TotalDistance`, and `TotalHours`. Here, the data is *unencrypted* in a base 64 value.
   
1. Provide more running metrics and notice that the API is aggregating the data when you request the metrics summary.
   
   The Visual Studio **Output** window provides useful information about what's being sent and received between the client and the API.

Now that the app is running, you can add encryption.

### Add encryption to the projects

First, add the Microsoft SEAL library, and then set the private and public keys for each project.

To add the SEAL library to your projects:

1. Right-click on the **FitnessTrackerClient** project and select **Add** > **Reference**.
1. Select **Browse**, and browse to and select *SEALNet.dll* from the *encryption-lab/Resources* folder, or the folder where you built the library, and then select **OK**.
1. Right-click on the project again, and select **Open Folder in File Explorer**.
1. In Windows File Explorer, copy the *encryption-lab/Resources/sealnetnative.dll* file to the *bin\Debug\netcoreapp2.2* folder of your project.
1. Repeat the preceding steps for the **FitnessTrackerAPI** project.
1. Right-click the **FitnessTracker** solution and select **Rebuild Solution**.

To set the private and public keys in both projects:

1. In the **FitnessTracker.Common** project, open the *Utils/SEALUtils.cs* file.
1. Find the `GetContext` method at the end of the file and replace the contents with the following code snippet:
   
   ```cs
   var encryptionParameters = new EncryptionParameters(SchemeType.BFV)
   {
       PolyModulusDegree = 32768,
       CoeffModulus = DefaultParams.CoeffModulus128(polyModulusDegree: 32768)
   };
   
   encryptionParameters.SetPlainModulus(0x133Ful);
   
   Debug.WriteLine("[COMMON]: Successfully created context");
   
   return SEALContext.Create(encryptionParameters);
   ```
   
   This code initializes the encryption parameters. Once you populate an instance of [EncryptionParameters](https://github.com/microsoft/SEAL/blob/master/dotnet/src/EncryptionParameters.cs) with appropriate parameters, you can use it to create an instance of the **SEALContext**. Both projects will use this method to create the **SealContext**. 
   
1. Save the file.
1. In the **FitnessTrackerAPI** project, open the *MetricsController.cs* file.
1. Add the following import at the beginning of the file:
   
   ```cs
   using Microsoft.Research.SEAL;
   ```

1. Look for the variable `private List<double> _times = new List<double>();` and add the following code snippet after it:
   
   ```cs
   private readonly SEALContext _sealContext;
   
   private readonly KeyGenerator _keyGenerator;
   private Evaluator _evaluator;
   private Encryptor _encryptor;
   ```
   
   This code introduces the variables required to generate the keys and work with *encryption/decryption*. You use the `Evaluator` and `Encryptor` in later steps. For now, focus on the `KeyGenerator`.
   
1. Find the `// Initialize context` comment in the constructor method and replace it with the following code snippet:

   ```cs
   // Getting context from Commons project
   _sealContext = SEALUtils.GetContext();
   ```
   
1. Replace the `// Initialize key generator and encryptor` comment in the same method with the following code snippet:
   
   ```cs
   // Initialize key Generator that will be used to get the Public and Secret keys
   _keyGenerator = new KeyGenerator(_sealContext);
   
   // Initializing encryptor
   _encryptor = new Encryptor(_sealContext, _keyGenerator.PublicKey);
   ```
   
   The key generator object has the secret and public keys that are used to encrypt and decrypt the data. These keys must be shared by the server and the client to be able to encrypt and decrypt the information correctly. You use an API endpoint to get these keys in the client.
   
1. Find the `GetKeys()` method and replace the contents with the following code snippet:
   
   ```cs
   Debug.WriteLine("[API]: GetKeys - return SEAL public and secret keys to client");
   return new KeysModel
   {
       PublicKey = SEALUtils.PublicKeyToBase64String(_keyGenerator.PublicKey),
       SecretKey = SEALUtils.SecretKeyToBase64String(_keyGenerator.SecretKey)
   };
   ```
   
   This method generates an object containing the public key and secret key as base64 strings, using the key generator you created earlier. You use *base64 encoding* to handle the data, as it's easier to load and save the encrypted values later on.
   
1. Save your changes.
1. In the **FitnessTrackerClient** project, open the *Program.cs* file.
1. Add the following import at the beginning of the file:
   
   ```cs
   using Microsoft.Research.SEAL;
   ```
   
1. Add the following variables to the beginning of the class:
   
   ```cs
   private static Encryptor _encryptor;
   private static Decryptor _decryptor;
   private static SEALContext _context;
   ```
   
1. Replace the `// Add Initialization code here` comment with the following code snippet:
   
   ```cs
   _context = SEALUtils.GetContext();
   ```
   
1. Replace the `// Add keys code here` comment with the following code snippet:
   
   ```cs
   var keys = await FitnessTrackerClient.GetKeys();
   
   // Create encryptor
   
   // Create decryptor
   ```
   
   Here you call an endpoint in the **FitnessTrackerAPI** to get the public and secret keys. If you want to encrypt data in one side, client or server, and decrypt it in the other side, you must use the same keys, or you get different results.
   
1. Save your changes.

Now that you added the SEAL library and have your public and private keys, you can use them to add an encryption layer to your app.

### Add encryption to your app

In this section, you encrypt and send data to the API from the client.

1. In *FitnessTrackerClient\Program.cs*, look for the `// Create encryptor` comment and replace it with the following code snippet to initialize the encryptor:
   
   ```cs
   var publicKey = SEALUtils.BuildPublicKeyFromBase64String(keys.PublicKey, _context);
   _encryptor = new Encryptor(_context, publicKey);
   ```
   You use the public key you receive from the API to initialize the encryptor.
   
Convert the distance and time values the user provides to hexadecimal, because that's how they're used by the evaluator in the server. Then, encrypt the values to ciphers to be sent in the request as base 64. 

1. Find the `// Encrypt distance` comment in the `SendNewRun` method, and add the following code snippet:
   
   ```cs
   // Convert the Int value to Hexadecimal using the ToString("X") method
   var plaintext = new Plaintext($"{newRunningDistance.ToString("X")}");
   var ciphertextDistance = new Ciphertext();
   _encryptor.Encrypt(plaintext, ciphertextDistance);
   ```
   
1. Replace the following line, `var base64Distance = SEALUtils.Base64Encode(newRunningDistance.ToString());`, with:
   
   ```cs
   var base64Distance = SEALUtils.CiphertextToBase64String(ciphertextDistance);
   ```

1. Find the `// Encrypt time` comment in the same method and add the following code snippet to get the new run time:

    ```cs
    // Convert the Int value to Hexadecimal using the ToString("X") method
    var plaintextTime = new Plaintext($"{newRunningTime.ToString("X")}");
    var ciphertextTime = new Ciphertext();
    _encryptor.Encrypt(plaintextTime, ciphertextTime);
    ```

1. Replace the following line, `var base64Time = SEALUtils.Base64Encode(newRunningTime.ToString());`, with:
   
   ```cs
   var base64Time = SEALUtils.CiphertextToBase64String(ciphertextTime);
   ```
   
1. Save your changes.

Now that you have the distance and time values encrypted, you can make API requests using the encrypted data, and see how the server performs calculations without decrypting the values.

### Perform summary statistics on the encrypted data

Use a basic `add` method to aggregate the metrics in the API without actually decrypting the information.

1. Open the `Controllers/MetricsController.cs` file in the **FitnessTrackerAPI** project.
1. Add the following code snippet after the variable `private Encryptor _encryptor`:
   
   ```cs
   // Store running metrics in memory. Use a long term storage for production scenarios.
   private List<ClientData> _metrics = new List<ClientData>();
   ```
   
1. Find the `// Initialize evaluator` comment in the constructor method and replace it with the following code:
   
   ```cs
   // Initialize evaluator to be used on calculations with context
   _evaluator = new Evaluator(_sealContext);
   ```
   
   The evaluator is in charge of doing all the calculations with the encrypted data. You don't have to use decryption to run mathematical functions using the SEAL library.
   
1. Find the `AddRunItem` method and replace the contents with the following code snippet:
   
   ```cs
           LogUtils.RunItemInfo("API", "AddRunItem", request);
           var distance = SEALUtils.BuildCiphertextFromBase64String(request.Distance, _sealContext);
           var time = SEALUtils.BuildCiphertextFromBase64String(request.Time, _sealContext);
   
           _metrics.Add(new ClientData
           {
               Distance = distance,
               Hours = time
           });
   
           return Ok();
   ```
   
   This code takes the metrics in *base64* and stores them in memory as a [Ciphertext](https://github.com/microsoft/SEAL/blob/master/dotnet/src/Ciphertext.cs). The code also prints the received request's contents in the **Output** window.
   
1. Add the following method at the end of the class:
   
   ```cs
   private Ciphertext SumEncryptedValues(IEnumerable<Ciphertext> encryptedData)
   {
       if (encryptedData.Any())
       {
           Ciphertext encTotal = new Ciphertext();
           _evaluator.AddMany(encryptedData, encTotal);
           return encTotal;
       }
       else
       {
           return SEALUtils.CreateCiphertextFromInt(0, _encryptor);
       }
   }
   ```
   The `AddMany` method receives the destination object where the calculation result is stored.
   
1. Find the `GetMetrics` method and replace its contents with the following code snippet:
   
   ```cs
       var totalDistance = SumEncryptedValues(_metrics.Select(m => m.Distance));
       var totalHours = SumEncryptedValues(_metrics.Select(m => m.Hours));
       var totalMetrics = SEALUtils.CreateCiphertextFromInt(_metrics.Count(), _encryptor);
       
       var summaryItem = new SummaryItem
       {
           TotalRuns = SEALUtils.CiphertextToBase64String(totalMetrics),
           TotalDistance = SEALUtils.CiphertextToBase64String(totalDistance),
           TotalHours = SEALUtils.CiphertextToBase64String(totalHours)
       };
       
       LogUtils.SummaryStatisticInfo("API", "GetMetrics", summaryItem);
       
       return Ok(summaryItem);
   ```
   
   This code uses the method that you previously added to perform the calculations on the metrics stored in memory. It also prints the `summaryItem` contents in the **Output** window.
   
1. Save your changes.

### Decrypt summary statistics in the client

In this section, you decrypt the data from the API response to display it to the user.

1. Open the `FitnessTrackerClient\Program.cs` file.
1. To initialize the decryptor, look for the `// Create decryptor` comment and replace it with the following code snippet:
   
   ```cs
   var secretKey = SEALUtils.BuildSecretKeyFromBase64String(keys.SecretKey, _context);
   _decryptor = new Decryptor(_context, secretKey);
   ```
   
   You use the secret key you get from the API to initialize the decrypter.
   
1. Find the `// Decrypt the data` comment in the `GetMetrics` method, and add the following code snippet after it:
   
   ```cs
   var ciphertextTotalRuns = SEALUtils.BuildCiphertextFromBase64String(metrics.TotalRuns, _context);
   var plaintextTotalRuns = new Plaintext();
   _decryptor.Decrypt(ciphertextTotalRuns, plaintextTotalRuns);
   
   var ciphertextTotalDistance = SEALUtils.BuildCiphertextFromBase64String(metrics.TotalDistance, _context);
   var plaintextTotalDistance = new Plaintext();
   _decryptor.Decrypt(ciphertextTotalDistance, plaintextTotalDistance);
   
   var ciphertextTotalHours = SEALUtils.BuildCiphertextFromBase64String(metrics.TotalHours, _context);
   var plaintextTotalHours = new Plaintext();
   _decryptor.Decrypt(ciphertextTotalHours, plaintextTotalHours);
   ```
   
   For all three metrics, you build a new **ciphertext** object using the *base64* encrypted data. Then, you create a new **plaintext** object to store the decryption result.
   
1. Find the `// Print metrics in console` comment, and replace the next line with the following code snippet:
   
   ```cs
   PrintMetrics(plaintextTotalRuns.ToString(), plaintextTotalDistance.ToString(), plaintextTotalHours.ToString());
   ```
   
   Since you already have the decrypted data, you just call `PrintMetrics` with this data to show it to the user.
   
1. Save your changes.

Now that you've added SEAL encryption to your app, you can test that it works as expected.

### Test the encryption

Run the app and check the flow to see how you encrypt and decrypt data. Use the app client to send and receive requests to the API, and see SEAL encryption in action.

1. On the Visual Studio toolbar, select **Start** and wait for the app to run. This might take a few minutes, as it takes some time to initialize the SEALContext.
1. In the console window, type *1* and press Enter to send a new record to the API.
1. Provide the requested information:
   - Running distance (km): *10*.
   - Running time (hours): *2*.
1. Type *1* and press Enter to send another record to the API.
1. Provide the requested information:
   - Running distance (km): *5*.
   - Running time (hours): *1*.
1. Type *2*  and press Enter to retrieve the running statistics from the API.

The results displayed are the calculations performed by the API. Review that the numbers match the expected result.

### Run Fiddler to see traffic

You can use Fiddler to view how data is being exchanged in this solution. Fiddler lets you see the raw traffic and check what's being sent and received between the API and the client. This way, you can verify that the encryption is secure.

To use Fiddler to test the actual results of the encryption, see [Capturing traffic with Fiddler](https://docs.myget.org/docs/reference/capturing-traffic-with-fiddler). Fiddler works only on Windows.

## Summary and resources

In this article, you learned how to add homomorphic encryption to your projects using the Microsoft SEAL library, and when it's best to choose this encryption solution.

To learn more about homomorphic encryption and the Microsoft SEAL library, see [Microsoft SEAL](https://www.microsoft.com/research/project/microsoft-seal/) and the [SEAL code project](https://github.com/microsoft/SEAL) on GitHub.
