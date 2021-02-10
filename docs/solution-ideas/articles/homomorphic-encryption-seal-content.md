

Companies often send, receive, and store their cloud data in encrypted form. But to take advantage of cloud computing services, companies must provide either unencrypted data, or the keys to decrypt it, which puts their data at increased risk. *Homomorphic encryption* allows computation directly on encrypted data, making it easier to leverage the potential of the cloud for privacy-critical data.

This article discusses how and when to use homomorphic encryption, and how to implement homomorphic encryption with the open-source [Microsoft Simple Encrypted Arithmetic Library (SEAL)](https://github.com/microsoft/SEAL#introduction).

## Use cases
- Lightweight computations like addition and multiplication on privacy-critical data and parts of programs.
- Outsourced cloud computing, where a single owner owns all the data and has sole access to the decryption keys.

## Architecture

![Traditional and SEAL encryption](../media/seal.png)

Traditional encryption schemes consist of three functionalities: key generation, encryption, and decryption. *Symmetric-key* encryption schemes use the same secret key for both encryption and decryption, and enable efficient encryption of large amounts of data for secure outsourced cloud storage. *Public-key* encryption schemes use a public key for encryption, plus a separate secret key for decryption. Anyone who knows the public key can encrypt data, but only those who know the secret key can decrypt and read the data. Public-key encryption enables secure online communication, but is typically less efficient than symmetric-key encryption.

While traditional encryption can be used for secure storage and communication, outsourced computation has necessarily required the encryption layers to be removed. Cloud services that provide outsourced computation must implement access policies to prevent unauthorized access to the data and keys. Data privacy relies on the access control policies imposed by the cloud provider and trusted by the customer.

With SEAL homomorphic encryption, cloud providers never have unencrypted access to the data they store and compute on. Computations can be performed directly on encrypted data. The results of such encrypted computations remain encrypted, and can be decrypted only by the data owner by using the secret key. Most homomorphic encryption uses public-key encryption schemes, although the public-key functionality may not always be needed.

## Considerations

- Only some computations are possible on encrypted data. Microsoft SEAL homomorphic encryption library allows additions and multiplications on encrypted integers or real numbers. Encrypted comparison, sorting, or regular expressions are not usually feasible to evaluate on encrypted data using this technology. Therefore, only specific privacy-critical cloud computations on parts of programs can be implemented using Microsoft SEAL.

- Microsoft SEAL comes with two different homomorphic encryption schemes with very different properties. The *BFV scheme* allows modular arithmetic to be performed on encrypted integers. The *CKKS scheme* allows additions and multiplications on encrypted real or complex numbers, but yields only approximate results. In applications such as summing up encrypted real numbers, evaluating machine learning models on encrypted data, or computing distances of encrypted locations, CKKS is the best choice. For applications where exact values are necessary, the BFV scheme is the only choice.

- Homomorphic encryption isn't very efficient. Since homomorphic encryption comes with a substantial performance overhead, computations that are already costly to perform on unencrypted data probably aren't feasible on encrypted data. 

- Data encrypted with homomorphic encryption is many times larger than unencrypted data, so it may not make sense to encrypt entire large databases, for example, with this technology. Instead, scenarios where strict privacy requirements prohibit unencrypted cloud computation, but the computations themselves are fairly lightweight, are meaningful use cases. 

- Typically, homomorphic encryption schemes have a single secret key, which is held by the data owner. Therefore, homomorphic encryption isn't reasonable for scenarios where multiple different private data owners want to engage in collaborative computation.

- It's not always easy or straightforward to translate an unencrypted computation into a computation on encrypted data. Even if new users can program and run a specific computation using Microsoft SEAL, the difference between efficient and inefficient implementation can be great, and it can be hard to know how to improve performance.

- While the homomorphic encryption primitive itself is secure, it doesn't guarantee that the apps and protocols that use it are secure.

## Implementation

The [sample code](https://zarmada.blob.core.windows.net/ai-school-module-updates/ai-school-lab-seal.zip) includes a console app, an API to implement a simple client-server interaction with homomorphic encryption, and complete instructions. To use the code, download and extract the ZIP to a local folder. The code project requires [Visual Studio 2019](https://www.visualstudio.com/downloads/) and [.NET Core version 2.2](https://dotnet.microsoft.com/download/dotnet-core/2.2).

## Next steps

To learn more about homomorphic encryption and the Microsoft SEAL library, see [Microsoft SEAL](https://www.microsoft.com/research/project/microsoft-seal/) from Microsoft Research, and the [SEAL code project](https://github.com/microsoft/SEAL) on GitHub.
